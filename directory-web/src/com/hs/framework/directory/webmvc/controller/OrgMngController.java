package com.hs.framework.directory.webmvc.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.LocaleUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.hs.framework.directory.batch.BatchColumnConverter;
import com.hs.framework.directory.common.Translator;
import com.hs.framework.directory.common.license.LicenseException;
import com.hs.framework.directory.common.license.LicenseManager;
import com.hs.framework.directory.config.OrgConfigData;
import com.hs.framework.directory.context.FileUploadBase;
import com.hs.framework.directory.context.FileUploadCommonImpl;
import com.hs.framework.directory.context.NoAuthenticationException;
import com.hs.framework.directory.context.NoAuthorizationException;
import com.hs.framework.directory.context.OrgContext;
import com.hs.framework.directory.context.OrgException;
import com.hs.framework.directory.context.OrgFolder;
import com.hs.framework.directory.context.OrgMngContext;
import com.hs.framework.directory.context.UserOrderKeys;
import com.hs.framework.directory.info.Auth;
import com.hs.framework.directory.info.Authentication;
import com.hs.framework.directory.info.Batch;
import com.hs.framework.directory.info.BatchMsg;
import com.hs.framework.directory.info.Community;
import com.hs.framework.directory.info.CommunityRequest;
import com.hs.framework.directory.info.Dept;
import com.hs.framework.directory.info.DirGroup;
import com.hs.framework.directory.info.Duty;
import com.hs.framework.directory.info.Position;
import com.hs.framework.directory.info.Rank;
import com.hs.framework.directory.info.User;
import com.hs.framework.directory.info.UserAuth;
import com.hs.framework.directory.info.impl.AuthImpl;
import com.hs.framework.directory.info.impl.BatchMsgImpl;
import com.hs.framework.directory.info.impl.CommunityImpl;
import com.hs.framework.directory.info.impl.CommunityRequestImpl;
import com.hs.framework.directory.info.impl.DeptImpl;
import com.hs.framework.directory.info.impl.DirGroupImpl;
import com.hs.framework.directory.info.impl.DutyImpl;
import com.hs.framework.directory.info.impl.PositionImpl;
import com.hs.framework.directory.info.impl.RankImpl;
import com.hs.framework.directory.info.impl.UserAuthImpl;
import com.hs.framework.directory.info.impl.UserImpl;
import com.hs.framework.directory.model.FileVO;
import com.hs.framework.directory.model.PaginationParam;
import com.hs.framework.directory.model.RuleParameter;
import com.hs.framework.directory.search.AuthKey;
import com.hs.framework.directory.search.DeptIDKey;
import com.hs.framework.directory.search.DeptMngAuthKey;
import com.hs.framework.directory.search.DirGroupTypeKey;
import com.hs.framework.directory.search.DutyKey;
import com.hs.framework.directory.search.EmailKey;
import com.hs.framework.directory.search.EmpCodeKey;
import com.hs.framework.directory.search.FlagKey;
import com.hs.framework.directory.search.MobilePhoneKey;
import com.hs.framework.directory.search.MultiSearchKey;
import com.hs.framework.directory.search.NameKey;
import com.hs.framework.directory.search.OrderByKey;
import com.hs.framework.directory.search.OrderKey;
import com.hs.framework.directory.search.PhoneKey;
import com.hs.framework.directory.search.PositionKey;
import com.hs.framework.directory.search.RankKey;
import com.hs.framework.directory.search.SearchKey;
import com.hs.framework.directory.search.StatusKey;

public class OrgMngController extends MultiActionController implements InitializingBean {

	private OrgContext orgContext;
	private OrgMngContext orgMngContext;
	private OrgFolder orgFolder;
	private long maxUploadSize;
	private String uploadTempDir;
	private FileUploadBase fileUpload;
	private String defaultCharset;
	private List<String> charsetList;
	/**
	 * 컨텍스트가 달라, BPM 엔진쪽으로 계정/부서등의 관리를 해야 함. 
	 */
	private String bpaAddress;

	private static final String PAGE_ACTON = ";orgMng;orgSys;viewDept;viewAddDept;viewUpdateDept;viewMoveDept;listUsers;viewUser;viewAddUser;viewUpdateUser;viewMoveUsers;listPositions;viewAddPosition;viewUpdatePosition;listRanks;viewAddRank;viewUpdateRank;listDuties;viewAddDuty;viewUpdateDuty;listAuthes;viewAddAuth;viewUpdateAuth;listSearch;listBatchs;viewAddBatch;listCommunities;viewCommunity;viewAddCommunity;viewUpdateCommunity;viewAddExternalUser;dirGroupMng;viewDirGroup;viewAddDirGroup;viewUpdateDirGroup;listDirGroupHir;viewDirGroupHir;viewAddDirGroupHir;viewUpdateDirGroupHir;";
	private static final String NOAUTH_ACTON = ";viewAddExternalUser;addExternalUser;addCommunityRequest;getCommunityRequest;";

	public void setOrgContext(OrgContext orgContext) {
		this.orgContext = orgContext;
	}

	public void setOrgMngContext(OrgMngContext orgMngContext) {
		this.orgMngContext = orgMngContext;
	}

	public void setOrgFolder(OrgFolder orgFolder) {
		this.orgFolder = orgFolder;
	}

	public long getMaxUploadSize() {
		return this.maxUploadSize;
	}

	private void setMaxUploadSize(long maxUploadSize) {
		this.maxUploadSize = maxUploadSize;
	}

	public String getUploadTempDir() {
		return this.uploadTempDir;
	}

	private void setUploadTempDir(String uploadTempDir) {
		this.uploadTempDir = uploadTempDir;
	}

	public FileUploadBase getFileUpload() {
		return this.fileUpload;
	}

	public void setFileUpload(FileUploadBase fileUpload) {
		this.fileUpload = fileUpload;
	}

	public void afterPropertiesSet() throws Exception {
		setMaxUploadSize(OrgConfigData.getPropertyForInt("directory.upload.maxsize", 1048576));
		if (this.fileUpload == null) {
			this.fileUpload = FileUploadCommonImpl.getInstance();
			this.fileUpload.init(new Long(getMaxUploadSize()));
		}
		this.defaultCharset = System.getProperty("file.encoding", "UTF-8");

		String charsets = OrgConfigData.getProperty("directory.batch.csv.charset");
		if (!StringUtils.isEmpty(charsets)) {
			String[] charsetsArray = StringUtils.split(charsets, ",");
			this.charsetList = new ArrayList();
			for (String charset : charsetsArray) {
				this.charsetList.add(charset);
			}
		}

		bpaAddress = OrgConfigData.getProperty("directory.bpa.address");
	}

	private void setContextDir(HttpServletRequest request) {
		String contexDir = request.getSession().getServletContext().getRealPath("/");

		setUploadTempDir(contexDir + "/directory/tmp");
	}

	private Locale getClientLocale(HttpServletRequest request) {
		String locale = request.getParameter("FRAMEWORK_DIRECTORY_LOCALE");
		if (StringUtils.isEmpty(locale)) {
			locale = (String)request.getSession().getAttribute("FRAMEWORK_DIRECTORY_LOCALE");
		}
		if (StringUtils.isEmpty(locale)) {
			Cookie[] cookies = request.getCookies();
			if (cookies != null) {
				for (Cookie cookie : cookies) {
					if (("GWLANG".equals(cookie.getName())) && (StringUtils.isNotEmpty(cookie.getValue()))) {
						locale = cookie.getValue();
						break;
					}
				}
			}
		}
		if (StringUtils.isEmpty(locale)) {
			locale = request.getLocale().toString();
		}
		Locale localeObj = null;
		try {
			localeObj = LocaleUtils.toLocale(locale);
		} catch (IllegalArgumentException e) {
			this.logger.error(e.getMessage());
			localeObj = request.getLocale();
		}
		request.getSession().setAttribute("FRAMEWORK_DIRECTORY_LOCALE", localeObj.toString());

		return localeObj;
	}

	protected boolean isAuthentication(HttpServletRequest request, HttpServletResponse response) throws NoAuthenticationException {
		String key = request.getParameter("K");
		if (StringUtils.isEmpty(key)) {
			Object session_key = request.getSession().getAttribute("DIRECTORY_AUTHENTICATION");
			if (session_key != null) {
				key = ((Authentication)session_key).getUserKey();
			} else {
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
					for (Cookie cookie : cookies) {
						if (("key".equals(cookie.getName())) && (StringUtils.isNotEmpty(cookie.getValue()))) {
							key = cookie.getValue();
							break;
						}
					}
				}
			}
		}
		if (StringUtils.isEmpty(key)) {
			throw new NoAuthenticationException(5005, "can't find the authentication key, K[" + key + "] is empty");
		}
		Authentication authentication = this.orgContext.getAuthentication(key);
		if (authentication == null) {
			throw new NoAuthenticationException(5005, "can't find the authentication info. for the K[" + key + "]");
		}
		if ("2".equals(authentication.getLoginStatus())) {
			throw new NoAuthenticationException(5005, "invalid the authentication's loginStatus[" + authentication.getLoginStatus() + "]");
		}
		request.getSession().setAttribute("DIRECTORY_AUTHENTICATION", authentication);
		request.setAttribute("DIRECTORY_AUTHENTICATION", authentication);
		Cookie cookie = new Cookie("key", authentication.getUserKey());
		cookie.setPath("/");
		response.addCookie(cookie);

		return true;
	}

	protected boolean isAuthorization(String uid, List<UserAuth> userAuths) {
		if ((userAuths == null) || (userAuths.size() < 1)) {
			return true;
		}
		boolean isAdmin = isAuthorization(uid, null, "ADM");
		int size = userAuths.size();
		for (int i = 0; i < size; i++) {
			UserAuth userAuth = (UserAuth)userAuths.get(i);
			RuleParameter parameter = null;
			if ((!isAdmin) && ("ADM".equals(userAuth.getAuth()))) {
				return false;
			}
		}
		return true;
	}

	protected boolean isAuthorization(String uid, String relID, String authes) {
		String[] arrAuthes = StringUtils.split(authes, ",;");
		List ruleParameters = new ArrayList(arrAuthes.length);
		for (int i = 0; i < arrAuthes.length; i++) {
			String auth = arrAuthes[i];
			RuleParameter parameter = null;
			if ("ADM".equals(auth)) {
				parameter = new RuleParameter(null, auth, false);
			} else {
				parameter = new RuleParameter(relID, auth, true);
			}
			ruleParameters.add(parameter);
		}
		return this.orgContext.isUserInRole(uid, ruleParameters);
	}

	protected ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response) throws Exception {
		getClientLocale(request);

		String methodName = null;
		try {
			if (this.uploadTempDir == null) {
				setContextDir(request);
			}
			methodName = getMethodNameResolver().getHandlerMethodName(request);

			boolean isNoAuthPage = ";viewAddExternalUser;addExternalUser;addCommunityRequest;getCommunityRequest;".indexOf(";" + methodName + ";") > -1;
			if ((isNoAuthPage) || (isAuthentication(request, response))) {
				try {
					String communityID = isNoAuthPage ? request.getParameter("communityID") : ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

					LicenseManager.isValidLicense(communityID);
				} catch (LicenseException e) {
					this.logger.error(e.getMessage(), e);

					throw new OrgException(3000, e.getMessage());
				}
				return super.handleRequestInternal(request, response);
			}
			throw new NoAuthenticationException(5005, "can't find the authentication info.");
		} catch (NoAuthenticationException e) {
			return createErrorPage(methodName, e);
		} catch (NoAuthorizationException e) {
			return createErrorPage(methodName, e);
		} catch (Exception e) {
			return createErrorPage(methodName, e);
		}
	}

	private ModelAndView createErrorPage(String methodName, Exception e) {
		this.logger.error(e.getMessage(), e);

		int errorCode = (e instanceof OrgException) ? ((OrgException)e).getErrorCode() : 3000;

		String errorMessage = e.getMessage();

		String viewName = null;
		if ((methodName == null)
			|| (";orgMng;orgSys;viewDept;viewAddDept;viewUpdateDept;viewMoveDept;listUsers;viewUser;viewAddUser;viewUpdateUser;viewMoveUsers;listPositions;viewAddPosition;viewUpdatePosition;listRanks;viewAddRank;viewUpdateRank;listDuties;viewAddDuty;viewUpdateDuty;listAuthes;viewAddAuth;viewUpdateAuth;listSearch;listBatchs;viewAddBatch;listCommunities;viewCommunity;viewAddCommunity;viewUpdateCommunity;viewAddExternalUser;dirGroupMng;viewDirGroup;viewAddDirGroup;viewUpdateDirGroup;listDirGroupHir;viewDirGroupHir;viewAddDirGroupHir;viewUpdateDirGroupHir;".indexOf(
				";" + methodName + ";") > -1)) {
			if ((e instanceof NoAuthenticationException)) {
				viewName = "common/sessionError";
			} else if ((e instanceof NoAuthorizationException)) {
				viewName = "common/authorityError";
			} else {
				viewName = "common/errorMessage";
			}
		} else {
			viewName = "mng/resultData";
			errorMessage = StringEscapeUtils.escapeJava(errorMessage);
		}
		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("errorCode", Integer.valueOf(errorCode));
		mav.addObject("errorMessage", errorMessage);
		return mav;
	}

	private Map<String, Boolean> createOptionMap(String str) {
		Map<String, Boolean> map = new HashMap();
		if (StringUtils.isNotEmpty(str)) {
			String[] arr = StringUtils.split(str, ",");
			for (String s : arr) {
				if (StringUtils.isNotEmpty(s.trim())) {
					map.put(s.trim(), Boolean.valueOf(true));
				}
			}
		}
		return map;
	}

	public ModelAndView orgMng(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the orgMng");
		}
		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("mng/orgMng");
		mav.addObject("isSysAdmin", Boolean.valueOf(isAuthorization(uid, null, "SYS")));
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		if (OrgConfigData.getPropertyForBoolean("directory.use.externaluser")) {
			mav.addObject("isExternalUserMng", Boolean.valueOf(isAuthorization(uid, null, "EUM")));
		}
		mav.addObject("baseDept", getBaseDeptID(user));
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		mav.addObject("useExternalUser", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.externaluser")));
		return mav;
	}

	public ModelAndView getBaseDeptID(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the getBaseDeptID");
		}
		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("deptID", getBaseDeptID(user));
		return mav;
	}

	private String getBaseDeptID(User user) {
		if (isAuthorization(user.getID(), null, "ADM")) {
			return this.orgContext.getRootDept(user.getDeptID()).getID();
		}
		List<UserAuth> userAuthList = this.orgContext.getUserRoleList(user.getID(), "D5");
		return ((UserAuth)userAuthList.get(0)).getRelID();
	}

	public ModelAndView initDeptTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the initDeptTree");
		}
		String baseDept = request.getParameter("baseDept");
		boolean isExpandAll = "true".equals(request.getParameter("isExpandAll"));

		Dept rootDept = this.orgContext.getRootDept(this.orgContext.getUser(uid).getDeptID());

		String data = null;
		if (isAuthorization(uid, null, "ADM")) {
			List<Dept> pathList = null;
			if (isExpandAll) {
				pathList = this.orgContext.getDeptList(null, rootDept.getID(), 2, null, true);
				pathList.add(rootDept);
				pathList = sortBySeq(pathList);
			} else {
				List<Dept> tmpList = this.orgContext.getDeptList(null, baseDept, 3, null, true);

				pathList = new ArrayList();
				pathList.add(rootDept);
				for (Dept tmp : tmpList) {
					pathList.addAll(this.orgContext.getDeptList(null, tmp.getID(), 1, null, true));
				}
			}
			boolean isEnglish = getClientLocale(request).getLanguage().equals("en");
			if (isEnglish) {
				for (Dept dept : pathList) {
					if (StringUtils.isNotEmpty(dept.getNameEng())) {
						dept.setName(dept.getNameEng());
					}
				}
			}
			data = buildTreeData(rootDept, pathList, pathList, true, isExpandAll);
		} else {
			List<Dept> pathList = new ArrayList();
			List<Dept> authList = new ArrayList();
			if (isExpandAll) {
				List<UserAuth> userAuthList = this.orgContext.getUserRoleList(uid, "D5");
				for (UserAuth userAuth : userAuthList) {
					List<Dept> tmpList = this.orgContext.getDeptList(null, userAuth.getRelID(), 3, null, true);
					pathList.addAll(tmpList);
					authList.add(tmpList.get(tmpList.size() - 1));
					authList.addAll(this.orgContext.getDeptList(null, userAuth.getRelID(), 2, null, true));
				}
			} else {
				if (isAuthorization(uid, baseDept, "D5")) {
					pathList = this.orgContext.getDeptList(null, baseDept, 3, null, true);
				}
				List<UserAuth> userAuthList = this.orgContext.getUserRoleList(uid, "D5");
				for (UserAuth userAuth : userAuthList) {
					pathList.addAll(this.orgContext.getDeptList(null, userAuth.getRelID(), 3, null, true));
				}
				List<String> pathIDs = new ArrayList();
				for (Dept tmp : pathList) {
					pathIDs.add(tmp.getID());
				}
				MultiSearchKey multiSearchKey = new MultiSearchKey();
				multiSearchKey.add(new DeptMngAuthKey(uid, "D5"));
				multiSearchKey.add(new DeptIDKey(pathIDs));

				List<Dept> tmpList = this.orgContext.getDeptList(rootDept.getCommunityID(), null, 0, multiSearchKey, true);
				for (Dept tmp : tmpList) {
					authList.add(tmp);
					authList.addAll(this.orgContext.getDeptList(null, tmp.getID(), 1, null, true));
				}
			}
			pathList.addAll(authList);

			pathList = sortBySeq(deduplicate(pathList));
			authList = sortBySeq(deduplicate(authList));

			boolean isEnglish = getClientLocale(request).getLanguage().equals("en");
			if (isEnglish) {
				for (Dept dept : pathList) {
					if (StringUtils.isNotEmpty(dept.getNameEng())) {
						dept.setName(dept.getNameEng());
					}
				}
			}
			data = buildTreeData(rootDept, pathList, authList, false, isExpandAll);
		}
		return new ModelAndView("mng/treeData", "data", data);
	}

	private String buildTreeData(Dept dept, List<Dept> pathList, List<Dept> authList, boolean isAdmin, boolean isExpandAll) throws OrgException {
		String children = "";
		for (Dept tmp : pathList) {
			if (tmp.getParentID().equals(dept.getID())) {
				if (StringUtils.isNotEmpty(children)) {
					children = children + ", ";
				}
				children = children + buildTreeData(tmp, pathList, authList, isAdmin, isExpandAll);
			}
		}
		return "{\"key\": \"" + dept.getID() + "\", \"title\": \"" + dept.getName() + "\", \"deptStatus\": \"" + dept.getStatus() + "\", \"isLazy\": true, \"isFolder\": true" + ", \"noLink\": "
			+ ((!isAdmin) && (!contains(authList, dept))) + ", \"expand\": " + isExpandAll + ", \n\"children\": [" + children + "]}";
	}

	private boolean contains(List<Dept> list, Dept dept) {
		for (Dept tmp : list) {
			if (tmp.getID().equals(dept.getID())) {
				return true;
			}
		}
		return false;
	}

	private List<Dept> sortBySeq(List<Dept> list) {
		Collections.sort(list, new Comparator() {
			public int compare(Dept o1, Dept o2) {
				if (o1.getSeq() > o2.getSeq()) {
					return 1;
				}
				if (o1.getSeq() == o2.getSeq()) {
					return 0;
				}
				return -1;
			}

			//FIXME: 여기 위에거로 수정필요
			@Override
			public int compare(Object o1, Object o2) {
				// TODO Auto-generated method stub
				return 0;
			}
		});
		return list;
	}

	private List<Dept> deduplicate(List<Dept> list) {
		List<Dept> result = new ArrayList();
		for (Dept tmp : list) {
			if (!contains(result, tmp)) {
				result.add(tmp);
			}
		}
		return result;
	}

	public ModelAndView expandDeptTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the expandDeptTree");
		}
		String deptID = request.getParameter("deptID");

		List<Dept> deptList = this.orgContext.getDeptList(null, deptID, 1, null, true);

		return new ModelAndView("mng/treeData", "deptList", deptList);
	}

	public ModelAndView searchDeptTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the searchDeptTree");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchValue = request.getParameter("searchValue");

		List<Dept> deptList = null;
		if (StringUtils.isEmpty(searchValue)) {
			deptList = new ArrayList();
		} else {
			deptList = this.orgContext.getDeptList(communityID, null, 0, new NameKey(searchValue), true);
			if ((!deptList.isEmpty()) && (!isAuthorization(uid, null, "ADM"))) {
				List<Dept> authList = new ArrayList();

				List<UserAuth> userAuthList = this.orgContext.getUserRoleList(uid, "D5");
				for (UserAuth userAuth : userAuthList) {
					authList.add(this.orgContext.getDept(userAuth.getRelID()));
					authList.addAll(this.orgContext.getDeptList(null, userAuth.getRelID(), 2, null, true));
				}
				List<Dept> tmpList = new ArrayList();
				for (Dept tmp : deptList) {
					if (contains(authList, tmp)) {
						tmpList.add(tmp);
					}
				}
				deptList = tmpList;
			}
			for (Dept dept : deptList) {
				String deptFullName = this.orgContext.getDeptFullName(dept.getID(), false);
				deptFullName = deptFullName.indexOf(".") < 0 ? deptFullName : deptFullName.substring(deptFullName.indexOf(".") + 1);

				dept.setName(deptFullName);

				String deptFullNameEng = this.orgContext.getDeptFullName(dept.getID(), true);
				deptFullNameEng = deptFullNameEng.indexOf(".") < 0 ? deptFullNameEng : deptFullNameEng.substring(deptFullNameEng.indexOf(".") + 1);

				dept.setNameEng(deptFullNameEng);
			}
		}
		return new ModelAndView("mng/treeData", "deptList", deptList);
	}

	public ModelAndView viewDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewDept");
		}
		Dept dept = null;
		try {
			dept = this.orgContext.getDept(deptID);
		} catch (OrgException e) {
			if (1204 == e.getErrorCode()) {
				return new ModelAndView("mng/viewDept", "dept", null);
			}
			throw e;
		}
		List userAuthes = this.orgContext.getUserRoleListByRelID(deptID);
		List authes = this.orgContext.getAuthList("3;2");

		List userIDs = new ArrayList();
		List deptIDs = new ArrayList();
		int userSize = userAuthes == null ? 0 : userAuthes.size();
		int authSize = authes == null ? 0 : authes.size();
		for (int i = 0; i < userSize; i++) {
			UserAuth userAuth = (UserAuth)userAuthes.get(i);
			for (int j = 0; j < authSize; j++) {
				Auth auth = (Auth)authes.get(j);
				if (auth.getCode().equals(userAuth.getAuth())) {
					if ("3".equals(auth.getType())) {
						deptIDs.add(userAuth.getUserID());
					} else {
						userIDs.add(userAuth.getUserID());
					}
				}
			}
		}
		List users = (userIDs == null) || (userIDs.size() < 1) ? null : this.orgContext.getUserList(userIDs);
		List depts = (deptIDs == null) || (deptIDs.size() < 1) ? null : this.orgContext.getDeptList(deptIDs);
		Map userMap = new HashMap();
		int size = users == null ? 0 : users.size();
		for (int i = 0; i < size; i++) {
			User tmp = (User)users.get(i);
			userMap.put(tmp.getID(), tmp);
		}
		Map deptMap = new HashMap();
		size = depts == null ? 0 : depts.size();
		for (int i = 0; i < size; i++) {
			Dept tmp = (Dept)depts.get(i);
			deptMap.put(tmp.getID(), tmp);
		}
		ModelAndView mav = new ModelAndView("mng/viewDept");
		mav.addObject("dept", dept);
		mav.addObject("authes", authes);
		mav.addObject("userAuthes", userAuthes);
		mav.addObject("userMap", userMap);
		mav.addObject("deptMap", deptMap);
		return mav;
	}

	public ModelAndView viewAddDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String targetDeptID = request.getParameter("targetDeptID");
		if (!isAuthorization(uid, targetDeptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddDept");
		}
		Dept rootDept = this.orgContext.getRootDept(targetDeptID);

		Dept targetDept = this.orgContext.getDept(targetDeptID);
		boolean hasAuthParentDept = rootDept.getID().equals(targetDeptID) ? false : isAuthorization(uid, targetDept.getParentID(), "ADM;D5");

		List authes = this.orgContext.getAuthList("3;2");

		ModelAndView mav = new ModelAndView("mng/addDept");
		mav.addObject("targetDept", targetDept);
		mav.addObject("hasAuthParentDept", Boolean.valueOf(hasAuthParentDept));
		mav.addObject("authes", authes);
		return mav;
	}

	public ModelAndView addDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String deptName = request.getParameter("deptName");
		String deptNameEng = request.getParameter("deptNameEng");
		String deptCode = request.getParameter("deptCode");
		String email = request.getParameter("email");
		String targetDeptID = request.getParameter("targetDeptID");
		String movePosition = request.getParameter("movePosition");

		List<UserAuth> userAuths = new ArrayList();
		for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
			String param = (String)e.nextElement();
			if (param.startsWith("ownerID_")) {
				String authCode = param.substring("ownerID_".length());
				String ownerIDs = request.getParameter(param);
				if (this.logger.isDebugEnabled()) {
					this.logger.debug("handle the authcodes, param[" + param + "], authCode[" + authCode + "],ownerIDs[" + ownerIDs + "]");
				}
				if ((ownerIDs != null) && (ownerIDs.trim().length() >= 1)) {
					String[] managerIDs = StringUtils.split(ownerIDs, ";,");
					for (String id : managerIDs) {
						UserAuth userAuth = new UserAuthImpl();
						userAuth.setAuth(authCode);
						if (authCode.equals(id)) {
							userAuth.setUserID(null);
						} else {
							userAuth.setUserID(id);
						}
						userAuths.add(userAuth);
					}
				}
			}
		}
		if (("1".equals(movePosition)) || ("2".equals(movePosition))) {
			Dept rootDept = this.orgContext.getRootDept(targetDeptID);
			if (rootDept.getID().equals(targetDeptID)) {
				throw new OrgException(5006, "don't have the authority for the addDept");
			}
		}
		Dept targetDept = this.orgContext.getDept(targetDeptID);

		Dept parent = null;
		int toSeqNum = 0;
		if ("1".equals(movePosition)) {
			parent = this.orgContext.getDept(targetDept.getParentID());
			toSeqNum = targetDept.getSeq();
		} else if ("2".equals(movePosition)) {
			parent = this.orgContext.getDept(targetDept.getParentID());
			toSeqNum = targetDept.getSeq() + 1;
		} else {
			parent = targetDept;
		}
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, parent.getID(), "ADM;D5")) {
			throw new OrgException(5006, "don't have the authority for the addDept");
		}
		Dept dept = new DeptImpl();
		dept.setCommunityID(parent.getCommunityID());
		dept.setParentID(parent.getID());
		dept.setName(deptName);
		dept.setNameEng(deptNameEng);
		dept.setDeptCode(deptCode);
		dept.setEmail(email);
		if ("0".equals(movePosition)) {
			this.orgMngContext.addDept(dept, parent.getID(), userAuths, null);
		} else {
			this.orgMngContext.addDept(dept, parent.getID(), userAuths, toSeqNum, null);
		}
		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("deptID", dept.getID());
		return mav;
	}

	public ModelAndView viewUpdateDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateDept");
		}
		Dept dept = this.orgContext.getDept(deptID);

		List userAuthes = this.orgContext.getUserRoleListByRelID(deptID);
		List authes = this.orgContext.getAuthList("3;2");

		List userIDs = new ArrayList();
		List deptIDs = new ArrayList();
		int userSize = userAuthes == null ? 0 : userAuthes.size();
		int authSize = authes == null ? 0 : authes.size();
		for (int i = 0; i < userSize; i++) {
			UserAuth userAuth = (UserAuth)userAuthes.get(i);
			for (int j = 0; j < authSize; j++) {
				Auth auth = (Auth)authes.get(j);
				if (auth.getCode().equals(userAuth.getAuth())) {
					if ("3".equals(auth.getType())) {
						deptIDs.add(userAuth.getUserID());
					} else {
						userIDs.add(userAuth.getUserID());
					}
				}
			}
		}
		List users = (userIDs == null) || (userIDs.size() < 1) ? null : this.orgContext.getUserList(userIDs);
		List depts = (deptIDs == null) || (deptIDs.size() < 1) ? null : this.orgContext.getDeptList(deptIDs);
		Map userMap = new HashMap();
		int size = users == null ? 0 : users.size();
		for (int i = 0; i < size; i++) {
			User tmp = (User)users.get(i);
			userMap.put(tmp.getID(), tmp);
		}
		Map deptMap = new HashMap();
		size = depts == null ? 0 : depts.size();
		for (int i = 0; i < size; i++) {
			Dept tmp = (Dept)depts.get(i);
			deptMap.put(tmp.getID(), tmp);
		}
		ModelAndView mav = new ModelAndView("mng/updateDept");
		mav.addObject("dept", dept);
		mav.addObject("authes", authes);
		mav.addObject("userAuthes", userAuthes);
		mav.addObject("userMap", userMap);
		mav.addObject("deptMap", deptMap);
		return mav;
	}

	public ModelAndView updateDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		String deptName = request.getParameter("deptName");
		String deptNameEng = request.getParameter("deptNameEng");
		String deptCode = request.getParameter("deptCode");
		String deptStatus = request.getParameter("deptStatus");
		String email = request.getParameter("email");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateDept");
		}
		Dept dept = this.orgContext.getDept(deptID);
		dept.setName(deptName);
		dept.setNameEng(deptNameEng);
		dept.setDeptCode(deptCode);
		dept.setStatus(deptStatus);
		dept.setEmail(email);

		List<UserAuth> userAuths = new ArrayList();
		for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
			String param = (String)e.nextElement();
			if (param.startsWith("ownerID_")) {
				String authCode = param.substring("ownerID_".length());
				String ownerIDs = request.getParameter(param);
				if (this.logger.isDebugEnabled()) {
					this.logger.debug("handle the authcodes, param[" + param + "], authCode[" + authCode + "],ownerIDs[" + ownerIDs + "]");
				}
				if ((ownerIDs != null) && (ownerIDs.trim().length() >= 1)) {
					String[] managerIDs = StringUtils.split(ownerIDs, ";,");
					for (String id : managerIDs) {
						UserAuth userAuth = new UserAuthImpl();
						userAuth.setAuth(authCode);
						userAuth.setUserID(id);
						userAuth.setRelID(dept.getID());
						userAuths.add(userAuth);
					}
				}
			}
		}
		this.orgMngContext.updateDept(dept, userAuths, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewMoveDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewMoveDept");
		}
		Dept dept = this.orgContext.getDept(deptID);

		return new ModelAndView("mng/moveDept", "dept", dept);
	}

	public ModelAndView moveDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		String targetDeptID = request.getParameter("targetDeptID");
		String movePosition = request.getParameter("movePosition");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the moveDept");
		}
		if (("1".equals(movePosition)) || ("2".equals(movePosition))) {
			Dept rootDept = this.orgContext.getRootDept(targetDeptID);
			if (rootDept.getID().equals(targetDeptID)) {
				throw new OrgException(10015, "don't have the authority for the moveDept");
			}
		}
		Dept dept = this.orgContext.getDept(deptID);
		Dept targetDept = this.orgContext.getDept(targetDeptID);

		Dept parent = null;
		int toSeqNum = 0;
		if ("1".equals(movePosition)) {
			parent = this.orgContext.getDept(targetDept.getParentID());
			toSeqNum = targetDept.getSeq();
		} else if ("2".equals(movePosition)) {
			parent = this.orgContext.getDept(targetDept.getParentID());
			toSeqNum = targetDept.getSeq() + 1;
		} else {
			parent = targetDept;
		}
		if (!isAuthorization(uid, parent.getID(), "ADM;D5")) {
			throw new OrgException(10015, "don't have the authority for the moveDept");
		}
		if ((dept.getParentID().equals(parent.getID())) && ((dept.getSeq() == toSeqNum) || (dept.getSeq() + 1 == toSeqNum))) {
			throw new OrgException(10013, "It cannot be moved to same position.");
		}
		if ("0".equals(movePosition)) {
			this.orgMngContext.moveDept(dept, parent.getID(), null);
		} else {
			this.orgMngContext.moveDept(dept, parent.getID(), toSeqNum, null);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteDept");
		}
		Dept dept = this.orgContext.getDept(deptID);

		boolean isComplete = false;
		String resultDeptID = dept.getID();
		if ("4".equals(dept.getStatus())) {
			isComplete = true;
			resultDeptID = dept.getParentID();
		}
		this.orgMngContext.deleteDept(dept.getID(), isComplete, null);

		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("deptID", resultDeptID);
		return mav;
	}

	public ModelAndView repairDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the repairDept");
		}
		Dept dept = this.orgContext.getDept(deptID);
		dept.setStatus("1");

		this.orgMngContext.updateDept(dept, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	private SearchKey createUserSearchKey(String searchType, String searchValue) {
		SearchKey key = null;
		if ("name".equals(searchType)) {
			key = new NameKey(searchValue, false);
		} else if ("pos".equals(searchType)) {
			key = new PositionKey(searchValue, false);
		} else if ("rank".equals(searchType)) {
			key = new RankKey(searchValue, false);
		} else if ("duty".equals(searchType)) {
			key = new DutyKey(searchValue, false);
		} else if ("code".equals(searchType)) {
			key = new EmpCodeKey(searchValue, false);
		} else if ("email".equals(searchType)) {
			key = new EmailKey(searchValue, false);
		} else if ("phone".equals(searchType)) {
			key = new PhoneKey(searchValue, false);
		} else if ("mobile".equals(searchType)) {
			key = new MobilePhoneKey(searchValue, false);
		} else if ("auth".equals(searchType)) {
			key = new AuthKey(searchValue, true);
		} else if ("status".equals(searchType)) {
			key = new MultiSearchKey();
			boolean isLock = true;
			List statusList = new ArrayList();
			if ("confirm".equals(searchValue)) {
				isLock = false;
				statusList.add("1");
			} else {
				isLock = true;
				statusList.add("8");
			}
			((MultiSearchKey)key).add(new FlagKey(268435456, isLock));
			((MultiSearchKey)key).add(new StatusKey(statusList));
		}
		return key;
	}

	private OrderByKey createOrderByKey(String orderField, String orderType) {
		if (this.logger.isDebugEnabled()) {
			this.logger.debug("orderField = " + orderField + ", orderType = " + orderType);
		}
		boolean orderDesc = "desc".equals(orderType);

		OrderByKey orderByKey = null;
		if (StringUtils.isNotEmpty(orderField)) {
			if ("position".equals(orderField)) {
				orderByKey = new OrderKey("1", orderDesc);
			} else if ("rank".equals(orderField)) {
				orderByKey = new OrderKey("17", orderDesc);
			} else if ("duty".equals(orderField)) {
				orderByKey = new OrderKey("19", orderDesc);
			} else if ("name".equals(orderField)) {
				orderByKey = new OrderKey("2", orderDesc);
			} else if ("nameEng".equals(orderField)) {
				orderByKey = new OrderKey("16", orderDesc);
			} else if ("empCode".equals(orderField)) {
				orderByKey = new OrderKey("15", orderDesc);
			} else if ("email".equals(orderField)) {
				orderByKey = new OrderKey("3", orderDesc);
			} else if ("deptName".equals(orderField)) {
				orderByKey = new OrderKey("6", orderDesc);
			} else if ("lockF".equals(orderField)) {
				orderByKey = new OrderKey("18", orderDesc);
			}
		}
		return orderByKey;
	}

	public ModelAndView listUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listUsers");
		}
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");

		OrderByKey orderByKey = createOrderByKey(orderField, orderType);
		if (orderByKey == null) {
			String listUsersOrder = OrgConfigData.getProperty("directory.listusers.order", "pos");
			orderByKey = new UserOrderKeys(listUsersOrder);
		}
		Dept dept = null;
		try {
			dept = this.orgContext.getDept(deptID);
		} catch (OrgException e) {
			if (1204 == e.getErrorCode()) {
				return new ModelAndView("mng/listUsers", "dept", null);
			}
			throw e;
		}
		List<User> userList = this.orgContext.getUserList(null, deptID, 1, null, orderByKey, null, true, false);

		ModelAndView mav = new ModelAndView("mng/listUsers");
		mav.addObject("dept", dept);
		mav.addObject("userList", userList);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		return mav;
	}

	public ModelAndView viewUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = request.getParameter("userID");

		User user = null;
		try {
			user = this.orgContext.getUser(userID);
		} catch (OrgException e) {
			if (1204 == e.getErrorCode()) {
				return new ModelAndView("mng/viewUser", "user", null);
			}
			throw e;
		}
		if (!isAuthorization(uid, user.getDeptID(), "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUser");
		}
		List userAuthes = this.orgContext.getUserRoleList(userID);
		List authes = this.orgContext.getAuthList("0;1");

		List userIDs = new ArrayList();
		int userSize = userAuthes == null ? 0 : userAuthes.size();
		int authSize = authes == null ? 0 : authes.size();
		for (int i = 0; i < userSize; i++) {
			UserAuth userAuth = (UserAuth)userAuthes.get(i);
			for (int j = 0; j < authSize; j++) {
				Auth auth = (Auth)authes.get(j);
				if (auth.getCode().equals(userAuth.getAuth())) {
					userIDs.add(userAuth.getRelID());
				}
			}
		}
		List users = (userIDs == null) || (userIDs.size() < 1) ? null : this.orgContext.getUserList(userIDs);
		Map userMap = new HashMap();
		int size = users == null ? 0 : users.size();
		for (int i = 0; i < size; i++) {
			User tmp = (User)users.get(i);
			userMap.put(tmp.getID(), tmp);
		}
		userMap.put(userID, user);

		ModelAndView mav = new ModelAndView("mng/viewUser");
		mav.addObject("user", user);
		mav.addObject("authes", authes);
		mav.addObject("userAuthes", userAuthes);
		mav.addObject("userMap", userMap);
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		mav.addObject("useUC", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.uc")));
		mav.addObject("useMail", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.mail")));
		mav.addObject("useCloudfolder", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.cloudfolder")));
		return mav;
	}

	public ModelAndView viewAddUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddUser");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, false, 1);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			throw new OrgException(3000, e.getMessage());
		}
		Dept dept = this.orgContext.getDept(deptID);
		List<Position> positionList = this.orgContext.getPositionList(communityID);

		List authes = this.orgContext.getAuthList("0;1");
		String defaultLoginPassword = OrgConfigData.getProperty("directory.password.defaultpassword", "1");

		ModelAndView mav = new ModelAndView("mng/addUser");
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("dept", dept);
		mav.addObject("positionList", positionList);
		mav.addObject("authes", authes);
		mav.addObject("defaultLoginPassword", defaultLoginPassword);
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		if (OrgConfigData.getPropertyForBoolean("directory.use.rank")) {
			mav.addObject("rankList", this.orgContext.getRankList(communityID));
		}
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		if (OrgConfigData.getPropertyForBoolean("directory.use.duty")) {
			mav.addObject("dutyList", this.orgContext.getDutyList(communityID));
		}
		mav.addObject("isEmailRequired", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.email.rule.required")));
		mav.addObject("useUC", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.uc")));
		mav.addObject("useExternalUser", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.externaluser")));
		mav.addObject("useMail", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.mail")));
		mav.addObject("defaultMailCapacity", Integer.valueOf(OrgConfigData.getPropertyForInt("directory.mail.defaultCapacity", 100)));
		mav.addObject("useCloudfolder", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.cloudfolder")));
		mav.addObject("defaultCloudfolderCapacity", Integer.valueOf(OrgConfigData.getPropertyForInt("directory.cloudfolder.defaultCapacity", 3072)));
		mav.addObject("allowPeriodInUsername", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.allow.period.in.username", false)));
		return mav;
	}

	public String getApi(String url, String userKey) {
		return url += "&k=" + userKey + "&userkey=" + userKey + "&resultType=json";
	}

	class SRResponseHandler implements ResponseHandler<String> {
		@Override
		public String handleResponse(HttpResponse response) throws ClientProtocolException, IOException {
			int status = response.getStatusLine().getStatusCode();
			if (status >= 200 && status < 300) {
				HttpEntity entity = response.getEntity();
				return entity != null ? EntityUtils.toString(entity) : null;
			} else {
				throw new ClientProtocolException("Unexpected response status: " + status);
			}
		}
	}

	public ModelAndView addUser(HttpServletRequest request, HttpServletResponse response) throws Exception {

		Authentication auth = (Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION");

		String uid = auth.getUserID();
		String deptID = request.getParameter("deptID");
		String userName = request.getParameter("userName");
		String userNameEng = request.getParameter("userNameEng");
		String empCode = request.getParameter("empCode");
		String positionID = request.getParameter("positionID");
		String rankID = request.getParameter("rankID");
		String dutyID = request.getParameter("dutyID");
		String secLevel = request.getParameter("secLevel");
		String loginID = request.getParameter("loginID");
		String loginPassword = request.getParameter("loginPassword");
		String loginLock = request.getParameter("loginLock");
		String expiryDate = request.getParameter("expiryDate");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String mobilePhone = request.getParameter("mobilePhone");
		String fax = request.getParameter("fax");
		String clientIPAddr = request.getParameter("clientIPAddr");
		String phoneRuleID = request.getParameter("phoneRuleID");
		String extPhone = request.getParameter("extPhone");
		String extPhoneHead = request.getParameter("extPhoneHead");
		String extPhoneExch = request.getParameter("extPhoneExch");
		String phyPhone = request.getParameter("phyPhone");
		String fwdPhone = request.getParameter("fwdPhone");
		String capacity = request.getParameter("capacity");
		String cloudfolderCapacity = request.getParameter("cloudfolderCapacity");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addUser");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		User user = new UserImpl();
		user.setDeptID(deptID);
		user.setName(userName);
		user.setNameEng(userNameEng);
		user.setEmpCode(empCode);
		user.setSeq(-1);
		user.setPositionID(positionID);
		user.setRankID(rankID);
		user.setDutyID(dutyID);
		user.setSecurityLevel(Integer.parseInt(secLevel));
		user.setLoginID(loginID);
		user.setLoginPassword(loginPassword);
		user.setLock("1".equals(loginLock));
		user.setExpireDate(new SimpleDateFormat("yyyy.MM.dd").parse(StringUtils.isNotEmpty(expiryDate) ? expiryDate : "2999.12.31"));
		user.setEmail(email);
		user.setPhone(phone);
		user.setMobilePhone(mobilePhone);
		user.setFax(fax);
		user.setClientIPAddr(clientIPAddr);
		user.setPhoneRuleID(StringUtils.isEmpty(phoneRuleID) ? 0 : Integer.parseInt(phoneRuleID));
		user.setExtPhone(extPhone);
		user.setExtPhoneHead(extPhoneHead);
		user.setExtPhoneExch(extPhoneExch);
		user.setPhyPhone(phyPhone);
		user.setFwdPhone(fwdPhone);
		if (StringUtils.isNotEmpty(capacity)) {
			user.setCapacity(Integer.parseInt(capacity));
		}
		if (StringUtils.isNotEmpty(cloudfolderCapacity)) {
			user.setCloudfolderCapacity(Integer.parseInt(cloudfolderCapacity));
		}
		List<UserAuth> userAuths = new ArrayList();
		for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
			String param = (String)e.nextElement();
			if (param.startsWith("relID_")) {
				String authCode = param.substring("relID_".length());
				String relIDs = request.getParameter(param);
				if (this.logger.isDebugEnabled()) {
					this.logger.debug("handle the authcodes, param[" + param + "], authCode[" + authCode + "],relIDs[" + relIDs + "]");
				}
				if ((relIDs != null) && (relIDs.trim().length() >= 1)) {
					String[] managerIDs = StringUtils.split(relIDs, ";,");
					for (String id : managerIDs) {
						UserAuth userAuth = new UserAuthImpl();
						userAuth.setAuth(authCode);
						userAuth.setUserID(null);
						if (authCode.equals(id)) {
							userAuth.setRelID(null);
						} else {
							userAuth.setRelID(id);
						}
						userAuths.add(userAuth);
					}
				}
			}
		}
		if (!isAuthorization(uid, userAuths)) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateUser");
		}
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, false, 1);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			throw new OrgException(3000, e.getMessage());
		}
		this.orgMngContext.addUser(user, userAuths, null);
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, true, 0);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			this.orgMngContext.deleteUser(user.getID(), true, null);
			throw new OrgException(3000, e.getMessage());
		}

		String uKey = auth.getUserKey();

		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", user.getID());
		params.put("email", email);
		params.put("firstName", URLEncoder.encode(userName, "UTF-8"));
		params.put("lastName", "");
		params.put("password", "1");
		callBPMService("createUser", uKey, params);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	/**
	 * ============================================================
	 * TODO: 현재는 orgMng 에서만 사용하고 있음. 
	 * 인터페이스를 위해, 향후 Http Client 에 대한 Pooling 및 소스 로직 분리해야 함.
	 * ============================================================
	 *  
	 * @throws IOException 
	 * @throws ClientProtocolException 
	 */
	private void callBPMService(String api, String uKey, Map<String, String> params) throws ClientProtocolException, IOException {

		System.out.println("ykkim ==================== OrgMngController::addUser ============================");
		System.out.println("ykkim OrgMngController > callBPMService (api) : " + api);
		System.out.println("ykkim OrgMngController > callBPMService (uKey) : " + uKey);
		System.out.println("ykkim OrgMngController > callBPMService (params) : " + params);

		SRResponseHandler responseHandler = new SRResponseHandler();
		String host = "http://" + bpaAddress;
		String bpaOpenApiHost = host + "/bpa-web/openapi/bpm";
		String url = getApi(bpaOpenApiHost + "/" + api + "?p=1", uKey);

		for (Iterator<String> loop = params.keySet().iterator(); loop.hasNext();) {
			String key = loop.next();
			String value = params.get(key);
			url += "&" + key + "=" + value;
		}

		CloseableHttpClient httpClient = HttpClients.createDefault();
		HttpPost method = new HttpPost(url);
		String res = httpClient.execute(method, responseHandler);

	}

	public ModelAndView viewUpdateUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = request.getParameter("userID");

		User user = this.orgContext.getUser(userID);
		if (!isAuthorization(uid, user.getDeptID(), "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateUser");
		}
		List<Position> positionList = this.orgContext.getPositionList(user.getCommunityID());

		List userAuthes = this.orgContext.getUserRoleList(userID);
		List authes = this.orgContext.getAuthList("0;1");

		List userIDs = new ArrayList();
		int userSize = userAuthes == null ? 0 : userAuthes.size();
		int authSize = authes == null ? 0 : authes.size();
		for (int i = 0; i < userSize; i++) {
			UserAuth userAuth = (UserAuth)userAuthes.get(i);
			for (int j = 0; j < authSize; j++) {
				Auth auth = (Auth)authes.get(j);
				if (auth.getCode().equals(userAuth.getAuth())) {
					userIDs.add(userAuth.getRelID());
				}
			}
		}
		List users = (userIDs == null) || (userIDs.size() < 1) ? null : this.orgContext.getUserList(userIDs);
		Map userMap = new HashMap();
		int size = users == null ? 0 : users.size();
		for (int i = 0; i < size; i++) {
			User tmp = (User)users.get(i);
			userMap.put(tmp.getID(), tmp);
		}
		userMap.put(userID, user);

		ModelAndView mav = new ModelAndView("mng/updateUser");
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("user", user);
		mav.addObject("positionList", positionList);
		mav.addObject("authes", authes);
		mav.addObject("userAuthes", userAuthes);
		mav.addObject("userMap", userMap);
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		if (OrgConfigData.getPropertyForBoolean("directory.use.rank")) {
			mav.addObject("rankList", this.orgContext.getRankList(user.getCommunityID()));
		}
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		if (OrgConfigData.getPropertyForBoolean("directory.use.duty")) {
			mav.addObject("dutyList", this.orgContext.getDutyList(user.getCommunityID()));
		}
		mav.addObject("isEmailRequired", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.email.rule.required")));
		mav.addObject("useUC", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.uc")));
		mav.addObject("useMail", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.mail")));
		mav.addObject("useCloudfolder", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.cloudfolder")));
		mav.addObject("allowPeriodInUsername", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.allow.period.in.username", false)));
		return mav;
	}

	public ModelAndView updateUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Authentication auth = (Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION");
		String uid = auth.getUserID();
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		String userNameEng = request.getParameter("userNameEng");
		String empCode = request.getParameter("empCode");
		String positionID = request.getParameter("positionID");
		String rankID = request.getParameter("rankID");
		String dutyID = request.getParameter("dutyID");
		String secLevel = request.getParameter("secLevel");
		String loginID = request.getParameter("loginID");
		String loginPassword = request.getParameter("loginPassword");
		String loginLock = request.getParameter("loginLock");
		String expiryDate = request.getParameter("expiryDate");
		String userStatus = request.getParameter("userStatus");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String mobilePhone = request.getParameter("mobilePhone");
		String fax = request.getParameter("fax");
		String clientIPAddr = request.getParameter("clientIPAddr");
		String phoneRuleID = request.getParameter("phoneRuleID");
		String extPhone = request.getParameter("extPhone");
		String extPhoneHead = request.getParameter("extPhoneHead");
		String extPhoneExch = request.getParameter("extPhoneExch");
		String phyPhone = request.getParameter("phyPhone");
		String fwdPhone = request.getParameter("fwdPhone");
		String capacity = request.getParameter("capacity");
		String cloudfolderCapacity = request.getParameter("cloudfolderCapacity");

		User user = this.orgContext.getUser(userID);
		if (!isAuthorization(uid, user.getDeptID(), "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateUser");
		}
		user.setName(userName);
		user.setNameEng(userNameEng);
		user.setEmpCode(empCode);
		user.setPositionID(positionID);
		user.setRankID(rankID);
		user.setDutyID(dutyID);
		user.setSecurityLevel(Integer.parseInt(secLevel));
		user.setLoginID(loginID);
		user.setLoginPassword(loginPassword);
		user.setLock("1".equals(loginLock));
		user.setExpireDate(new SimpleDateFormat("yyyy.MM.dd").parse(StringUtils.isNotEmpty(expiryDate) ? expiryDate : "2999.12.31"));
		user.setStatus(userStatus);
		user.setEmail(email);
		user.setPhone(phone);
		user.setMobilePhone(mobilePhone);
		user.setFax(fax);
		user.setClientIPAddr(clientIPAddr);
		user.setPhoneRuleID(StringUtils.isEmpty(phoneRuleID) ? 0 : Integer.parseInt(phoneRuleID));
		user.setExtPhone(extPhone);
		user.setExtPhoneHead(extPhoneHead);
		user.setExtPhoneExch(extPhoneExch);
		user.setPhyPhone(phyPhone);
		user.setFwdPhone(fwdPhone);
		if (StringUtils.isNotEmpty(capacity)) {
			user.setCapacity(Integer.parseInt(capacity));
		}
		if (StringUtils.isNotEmpty(cloudfolderCapacity)) {
			user.setCloudfolderCapacity(Integer.parseInt(cloudfolderCapacity));
		}
		List<UserAuth> userAuths = new ArrayList();
		for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
			String param = (String)e.nextElement();
			if (param.startsWith("relID_")) {
				String authCode = param.substring("relID_".length());
				String relIDs = request.getParameter(param);
				if (this.logger.isDebugEnabled()) {
					this.logger.debug("handle the authcodes, param[" + param + "], authCode[" + authCode + "],relIDs[" + relIDs + "]");
				}
				if ((relIDs != null) && (relIDs.trim().length() >= 1)) {
					String[] managerIDs = StringUtils.split(relIDs, ";,");
					for (String id : managerIDs) {
						UserAuth userAuth = new UserAuthImpl();
						userAuth.setAuth(authCode);
						userAuth.setUserID(user.getID());
						if (authCode.equals(id)) {
							userAuth.setRelID(user.getID());
						} else {
							userAuth.setRelID(id);
						}
						userAuths.add(userAuth);
					}
				}
			}
		}
		if (!isAuthorization(uid, userAuths)) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateUser");
		}
		List authTypes = new ArrayList();
		authTypes.add("0");
		authTypes.add("1");

		this.orgMngContext.updateUser(user, userAuths, authTypes, null);

		String uKey = auth.getUserKey();
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", user.getID());
		params.put("email", email);
		params.put("firstName", URLEncoder.encode(userName, "UTF-8"));
		params.put("lastName", "");
		params.put("password", "1");
		callBPMService("updateUser", uKey, params);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewMoveUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		String userIDs = request.getParameter("userIDs");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewMoveUsers");
		}
		Dept dept = this.orgContext.getDept(deptID);

		List<String> uIDs = new ArrayList();
		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			uIDs.add(id);
		}
		List<User> userList = null;
		if (uIDs.size() > 0) {
			userList = this.orgContext.getUserList(uIDs);
		}
		ModelAndView mav = new ModelAndView("mng/moveUsers");
		mav.addObject("dept", dept);
		mav.addObject("userList", userList);
		return mav;
	}

	public ModelAndView moveUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		String userIDs = request.getParameter("userIDs");
		String targetDeptID = request.getParameter("targetDeptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the moveUsers");
		}
		if (!isAuthorization(uid, targetDeptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the moveUsers");
		}
		List<String> uIDs = new ArrayList();
		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			uIDs.add(id);
		}
		this.orgMngContext.moveUsers(uIDs, deptID, targetDeptID, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateUsersSeq(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateUsersSeq");
		}
		String usersOrder = OrgConfigData.getProperty("directory.listusers.order", "pos");
		UserOrderKeys orderByKey = new UserOrderKeys(usersOrder);

		List<User> userList = this.orgContext.getUserList(null, deptID, 1, null, orderByKey, null, true, false);
		ModelAndView mv = new ModelAndView("mng/updateUsersSeq", "userList", userList);
		mv.addObject("usersOrder", usersOrder);
		return mv;
	}

	public ModelAndView updateUsersSeq(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		String userIDs = request.getParameter("userIDs");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateUsersSeq");
		}
		List<String> uIDs = new ArrayList();
		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			uIDs.add(id);
		}
		this.orgMngContext.updateUsersSeq(uIDs, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {

		Authentication auth = (Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION");
		String uid = auth.getUserID();
		String uKey = auth.getUserKey();
		String deptID = request.getParameter("deptID");
		String userIDs = request.getParameter("userIDs");

		//System.out.println("ykkim... deleteUsers (deptID) : "+deptID);
		//System.out.println("ykkim... deleteUsers (userIDs) : "+userIDs);

		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteUsers");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			User user = this.orgContext.getUser(id);

			boolean isComplete = false;
			if ("4".equals(user.getStatus())) {
				isComplete = true;
			}
			this.orgMngContext.deleteUser(user.getID(), isComplete, null);
		}
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, true, 0);
		} catch (LicenseException e) {
		}

		Map<String, String> params = new HashMap<String, String>();
		params.put("userIds", userIDs);
		callBPMService("deleteUser", uKey, params);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));

	}

	public ModelAndView repairUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String deptID = request.getParameter("deptID");
		String userIDs = request.getParameter("userIDs");
		if (!isAuthorization(uid, deptID, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the repairUsers");
		}
		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			repairUser(id);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView repairUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = request.getParameter("userID");

		User user = this.orgContext.getUser(userID);
		if (!isAuthorization(uid, user.getDeptID(), "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the repairUser");
		}
		repairUser(userID);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	private void repairUser(String userID) {
		User user = this.orgContext.getUser(userID);
		if (!"4".equals(user.getStatus())) {
			return;
		}
		user.setStatus("1");
		user.setLock(false);
		try {
			LicenseManager.isValidLicenseForRegisteredUser(user.getCommunityID(), false, 1);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			throw new OrgException(3000, e.getMessage());
		}
		this.orgMngContext.updateUser(user, null);
		try {
			LicenseManager.isValidLicenseForRegisteredUser(user.getCommunityID(), true, 0);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			this.orgMngContext.deleteUser(user.getID(), false, null);
			throw new OrgException(3000, e.getMessage());
		}
	}

	public ModelAndView listPositions(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listPositions");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<Position> positionList = this.orgContext.getPositionList(communityID);

		ModelAndView mav = new ModelAndView("mng/listPositions");
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("positionList", positionList);
		return mav;
	}

	public ModelAndView viewAddPosition(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddPosition");
		}
		return new ModelAndView("mng/addPosition");
	}

	public ModelAndView addPosition(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addPosition");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String positionCode = request.getParameter("positionCode");
		String positionName = request.getParameter("positionName");
		String positionNameEng = request.getParameter("positionNameEng");
		String secLevel = request.getParameter("secLevel");

		Position position = new PositionImpl();
		position.setCommunityID(communityID);
		position.setCode(positionCode);
		position.setName(positionName);
		position.setNameEng(positionNameEng);
		position.setSecurityLevel(Integer.parseInt(secLevel));

		this.orgMngContext.addPosition(position, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdatePosition(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdatePosition");
		}
		String positionID = request.getParameter("positionID");

		Position position = this.orgContext.getPosition(positionID);

		return new ModelAndView("mng/updatePosition", "position", position);
	}

	public ModelAndView updatePosition(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updatePosition");
		}
		String positionID = request.getParameter("positionID");
		String positionCode = request.getParameter("positionCode");
		String positionName = request.getParameter("positionName");
		String positionNameEng = request.getParameter("positionNameEng");
		String secLevel = request.getParameter("secLevel");
		String updateUserSecLevel = request.getParameter("updateUserSecLevel");

		Position position = this.orgContext.getPosition(positionID);
		position.setCode(positionCode);
		position.setName(positionName);
		position.setNameEng(positionNameEng);
		position.setSecurityLevel(Integer.parseInt(secLevel));
		boolean updateUserSecLevelF = "1".equals(updateUserSecLevel);

		this.orgMngContext.updatePosition(position, updateUserSecLevelF, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deletePositions(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deletePositions");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String positionIDs = request.getParameter("positionIDs");

		List<String> posIDs = new ArrayList();
		String[] ids = StringUtils.split(positionIDs, ";,");
		for (String id : ids) {
			posIDs.add(id);
		}
		this.orgMngContext.deletePositions(communityID, posIDs, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView listRanks(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listRanks");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<Rank> rankList = this.orgContext.getRankList(communityID);

		ModelAndView mav = new ModelAndView("mng/listRanks");
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("rankList", rankList);
		return mav;
	}

	public ModelAndView viewAddRank(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddRank");
		}
		return new ModelAndView("mng/addRank");
	}

	public ModelAndView addRank(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addRank");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String rankCode = request.getParameter("rankCode");
		String rankName = request.getParameter("rankName");
		String rankNameEng = request.getParameter("rankNameEng");
		String rankLevel = request.getParameter("rankLevel");

		Rank rank = new RankImpl();
		rank.setCommunityID(communityID);
		rank.setCode(rankCode);
		rank.setName(rankName);
		rank.setNameEng(rankNameEng);
		rank.setLevel(Integer.parseInt(rankLevel));

		this.orgMngContext.addRank(rank, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateRank(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateRank");
		}
		String rankID = request.getParameter("rankID");

		Rank rank = this.orgContext.getRank(rankID);

		return new ModelAndView("mng/updateRank", "rank", rank);
	}

	public ModelAndView updateRank(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateRank");
		}
		String rankID = request.getParameter("rankID");
		String rankCode = request.getParameter("rankCode");
		String rankName = request.getParameter("rankName");
		String rankNameEng = request.getParameter("rankNameEng");
		String rankLevel = request.getParameter("rankLevel");

		Rank rank = this.orgContext.getRank(rankID);
		rank.setCode(rankCode);
		rank.setName(rankName);
		rank.setNameEng(rankNameEng);
		rank.setLevel(Integer.parseInt(rankLevel));

		this.orgMngContext.updateRank(rank, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteRanks(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteRanks");
		}
		String rankIDs = request.getParameter("rankIDs");

		List<String> raIDs = new ArrayList();
		String[] ids = StringUtils.split(rankIDs, ";,");
		for (String id : ids) {
			raIDs.add(id);
		}
		this.orgMngContext.deleteRanks(raIDs, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView listDuties(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listDuties");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<Duty> dutyList = this.orgContext.getDutyList(communityID);

		ModelAndView mav = new ModelAndView("mng/listDuties");
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("dutyList", dutyList);
		return mav;
	}

	public ModelAndView viewAddDuty(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddDuty");
		}
		return new ModelAndView("mng/addDuty");
	}

	public ModelAndView addDuty(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addDuty");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String dutyCode = request.getParameter("dutyCode");
		String dutyName = request.getParameter("dutyName");

		Duty duty = new DutyImpl();
		duty.setCommunityID(communityID);
		duty.setSeq(0);
		duty.setCode(dutyCode);
		duty.setName(dutyName);

		this.orgMngContext.addDuty(duty, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateDuty(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateDuty");
		}
		String dutyID = request.getParameter("dutyID");

		Duty duty = this.orgContext.getDuty(dutyID);

		return new ModelAndView("mng/updateDuty", "duty", duty);
	}

	public ModelAndView updateDuty(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateDuty");
		}
		String dutyID = request.getParameter("dutyID");
		String dutyCode = request.getParameter("dutyCode");
		String dutyName = request.getParameter("dutyName");

		Duty duty = this.orgContext.getDuty(dutyID);
		duty.setCode(dutyCode);
		duty.setName(dutyName);

		this.orgMngContext.updateDuty(duty, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateDutiesSeq(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateDutiesSeq");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<Duty> dutyList = this.orgContext.getDutyList(communityID);

		return new ModelAndView("mng/updateDutiesSeq", "dutyList", dutyList);
	}

	public ModelAndView updateDutiesSeq(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateDutiesSeq");
		}
		String dutyIDs = request.getParameter("dutyIDs");

		List<String> duIDs = new ArrayList();
		String[] ids = StringUtils.split(dutyIDs, ";,");
		for (String id : ids) {
			duIDs.add(id);
		}
		this.orgMngContext.updateDutiesSeq(duIDs, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteDuties(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteDuties");
		}
		String dutyIDs = request.getParameter("dutyIDs");

		List<String> duIDs = new ArrayList();
		String[] ids = StringUtils.split(dutyIDs, ";,");
		for (String id : ids) {
			duIDs.add(id);
		}
		this.orgMngContext.deleteDuties(duIDs, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView listAuthes(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listAuthes");
		}
		List authList = this.orgContext.getRoleList();

		ModelAndView mav = new ModelAndView("mng/listAuthes");
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("authList", authList);
		return mav;
	}

	public ModelAndView viewAddAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddAuth");
		}
		return new ModelAndView("mng/addAuth");
	}

	public ModelAndView addAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addAuth");
		}
		String authCode = request.getParameter("authCode");
		String authName = request.getParameter("authName");
		String authDescription = request.getParameter("authDescription");
		String authType = request.getParameter("authType");
		String authMultiFlag = request.getParameter("authMultiFlag");

		Auth auth = new AuthImpl();
		auth.setCode(authCode);
		auth.setName(authName);
		auth.setDescription(authDescription);
		auth.setType(authType);
		auth.setMulti(authMultiFlag == null ? true : "1".equals(authMultiFlag));

		this.orgMngContext.addAuth(auth, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateAuth");
		}
		String authCode = request.getParameter("authCode");

		Auth auth = this.orgContext.getRole(authCode);

		return new ModelAndView("mng/updateAuth", "auth", auth);
	}

	public ModelAndView updateAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateAuth");
		}
		String authCode = request.getParameter("authCode");
		String authName = request.getParameter("authName");
		String authDescription = request.getParameter("authDescription");
		String authType = request.getParameter("authType");
		String authMultiFlag = request.getParameter("authMultiFlag");

		Auth auth = new AuthImpl();
		auth.setCode(authCode);
		auth.setName(authName);
		auth.setDescription(authDescription);
		auth.setType(authType);
		auth.setMulti(authMultiFlag == null ? true : "1".equals(authMultiFlag));

		this.orgMngContext.updateAuth(auth, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteAuth(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteAuth");
		}
		String authCode = request.getParameter("authCode");

		this.orgMngContext.deleteAuth(authCode, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteAuthes(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteAuthes");
		}
		String authCodes = request.getParameter("authCodes");

		this.orgMngContext.deleteAuthes(authCodes, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView listSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;D5")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listSearch");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");
		String authTypes = request.getParameter("authTypes");

		SearchKey key = createUserSearchKey(searchType, searchValue);
		OrderByKey orderByKey = createOrderByKey(orderField, orderType);

		List userList = null;
		if ((key == null) || (StringUtils.isEmpty(searchValue))) {
			userList = new ArrayList();
		} else if (this.orgContext.isUserInRole(uid, "ADM")) {
			userList = this.orgContext.getUserList(communityID, null, 0, key, orderByKey, null, true, false);
		} else {
			MultiSearchKey multiSearchKey = new MultiSearchKey();
			multiSearchKey.add(new DeptMngAuthKey(uid, "D5"));
			multiSearchKey.add(key);
			userList = this.orgContext.getUserList(communityID, null, 0, multiSearchKey, orderByKey, null, true, false);
		}
		Map cryptedUserColumnsMap = this.orgContext.getCryptedUserColumnsMap();
		if (StringUtils.isEmpty(authTypes)) {
			authTypes = "0,1,2";
		}
		List authList = this.orgContext.getAuthList(authTypes);

		ModelAndView mav = new ModelAndView("mng/listSearch");
		mav.addObject("userList", userList);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("cryptedUserColumnsMap", cryptedUserColumnsMap);
		if (authList != null) {
			mav.addObject("authList", authList);
		}
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		return mav;
	}

	public ModelAndView listBatchs(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listBatchs");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String listType = request.getParameter("listType");
		int currentPage = StringUtils.isNotEmpty(request.getParameter("currentPage")) ? Integer.parseInt(request.getParameter("currentPage")) : 1;

		List list = new ArrayList();
		if ((listType == null) || ("all".equals(listType))) {
			list.add("3");
			list.add("0");
			list.add("2");
		} else {
			list.add("1");
		}
		SearchKey key = new StatusKey(list);

		PaginationParam pParam = new PaginationParam(15, 10);
		pParam.setCurrentPage(currentPage);
		pParam.setTotalCount(this.orgMngContext.getBatchIDs(communityID, key).size());
		List<Batch> batchList = this.orgMngContext.getBatchList(communityID, key, pParam.getStartRowIndex(), pParam.getEndRowIndex());

		ModelAndView mav = new ModelAndView("mng/listBatchs");
		mav.addObject("isSysAdmin", Boolean.valueOf(isAuthorization(uid, null, "SYS")));
		mav.addObject("pParam", pParam);
		mav.addObject("batchList", batchList);
		return mav;
	}

	public ModelAndView viewAddBatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddBatch");
		}
		ModelAndView mav = new ModelAndView("mng/addBatch");
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		if ((this.charsetList != null) && (this.charsetList.size() > 0)) {
			mav.addObject("charsetList", this.charsetList);
		}
		return mav;
	}

	public ModelAndView addBatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
			if (!isAuthorization(uid, null, "ADM")) {
				throw new NoAuthorizationException(5006, "don't have the authority for the addBatch");
			}
			String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

			String[] type = {"positionFile", "rankFile", "dutyFile", "deptFile", "userFile", "authFile"};

			List<File> files = new ArrayList();
			String charset = null;
			if ((request instanceof MultipartHttpServletRequest)) {
				MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest)request;
				charset = multipartRequest.getParameter("charset");
				MultipartFile multipartFile = null;
				for (String curType : type) {
					multipartFile = multipartRequest.getFile(curType);
					if ((multipartFile != null) && (StringUtils.isNotEmpty(multipartFile.getOriginalFilename()))) {
						String extender = FilenameUtils.getExtension(multipartFile.getOriginalFilename());

						File destFile = this.orgFolder.createFile(uid, getBatchFileNameWithPath(uid + "_" + curType, new Date(), extender, true));
						multipartFile.transferTo(destFile);
						files.add(destFile);
					}
				}
			} else {
				charset = request.getParameter("charset");
				Map parameterMap = this.fileUpload.fileUpload(request, -1L, this.uploadTempDir);
				uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
				for (String curType : type) {
					Object object = parameterMap.get(curType);
					if ((object != null) && ((object instanceof FileVO))) {
						FileVO fileVO = (FileVO)object;
						if ((fileVO != null) && (StringUtils.isNotEmpty(fileVO.getOrgFileName()))) {
							File srcFile = new File(fileVO.getFilePath());
							String extender = FilenameUtils.getExtension(fileVO.getOrgFileName());
							File destFile = this.orgFolder.createFile(uid, getBatchFileNameWithPath(uid + "_" + curType, new Date(), extender, true));
							this.fileUpload.copy(srcFile, destFile);
							files.add(destFile);
						}
					}
				}
			}
			for (File file : files) {
				this.orgMngContext.parseFileOnline(communityID, file.getAbsolutePath(), charset, null);
				file.delete();
			}
			return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		} catch (Exception e) {
			ModelAndView mav = new ModelAndView("mng/resultData");
			mav.addObject("errorCode", Integer.valueOf(3000));
			mav.addObject("errorMessage", e.getMessage());
			return mav;
		}
	}

	private String getBatchFileNameWithPath(String id, Date date, String extender, boolean type) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateString = dateFormat.format(date);
		if (type) {
			return id + "_import_" + dateString + "." + extender;
		}
		return id + "_export_" + dateString + "." + extender;
	}

	public ModelAndView viewExportBatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewExportBatch");
		}
		ModelAndView mav = new ModelAndView("mng/viewExportBatch");
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		if ((this.charsetList != null) && (this.charsetList.size() > 0)) {
			mav.addObject("charsetList", this.charsetList);
		}
		return mav;
	}

	public ModelAndView exportBatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
			if (!isAuthorization(uid, null, "ADM")) {
				throw new NoAuthorizationException(5006, "don't have the authority for the exportBatch");
			}
			String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
			String type = request.getParameter("type");

			Date exportDate = null;
			String exportDateStr = request.getParameter("exportDate");
			String exportDateFormat = request.getParameter("exportDateFormat");
			if (!StringUtils.isEmpty(exportDateStr)) {
				if (StringUtils.isEmpty(exportDateFormat)) {
					exportDateFormat = "yyyy.MM.dd HH:mm";
				}
				SimpleDateFormat dateFormat = new SimpleDateFormat(exportDateFormat);
				exportDate = dateFormat.parse(exportDateStr);
			}
			String typeStr = "";
			if ("1".equals(type)) {
				typeStr = "DEPT";
			} else if ("0".equals(type)) {
				typeStr = "USER";
			} else if ("2".equals(type)) {
				typeStr = "POS";
			} else if ("3".equals(type)) {
				typeStr = "RANK";
			} else if ("4".equals(type)) {
				typeStr = "DUTY";
			} else if ("5".equals(type)) {
				typeStr = "AUTH";
			}
			String charset = request.getParameter("charset");
			if ((charset == null) || (charset.trim().length() < 1)) {
				charset = this.defaultCharset;
			}
			String fileName = typeStr.toLowerCase() + ".csv";
			response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

			response.setContentType("application/vnd.ms-excel; charset=" + charset);

			Writer writer = null;
			writer = new BufferedWriter(new OutputStreamWriter(response.getOutputStream(), charset));

			writer.write("HANDY*GROUPWARE E/F CSV " + typeStr + " INFO VERSION 1.0\n");
			List<String> addColumns;
			if ("1".equals(type)) {
				String[] columns = {"DEPT_NAME", "DEPT_NAME_ENG", "DEPT_CODE", "PAR_CODE", "SEQ", "STATUS", "LINK_ID", "COMP_ID"};
				writer.write("*OPERATION");
				for (String column : columns) {
					writer.write("," + BatchColumnConverter.convertBatchToCsv(type, column));
				}
				String addColumnsStr = OrgConfigData.getProperty("directory.export.dept.addcolumns");
				addColumns = new ArrayList();
				if (!StringUtils.isEmpty(addColumnsStr)) {
					String[] addColumnsArray = StringUtils.split(addColumnsStr, ",");
					for (String addColumn : addColumnsArray) {
						addColumns.add(addColumn.toUpperCase());
					}
					writer.write("," + StringUtils.join(addColumns, ","));
				}
				writer.write("\n");

				List<Map> list = this.orgContext.getDeptListForExport(communityID, true, exportDate);
				for (Map map : list) {
					String status = (String)map.get("STATUS");
					if ("4".equals(status)) {
						writer.write("DELETE");
					} else {
						writer.write("ADD");
					}
					writer.write("," + Translator.getCSVStr((String)map.get("DEPT_NAME")));
					writer.write("," + Translator.getCSVStr((String)map.get("DEPT_NAME_ENG")));
					writer.write("," + Translator.getCSVStr((String)map.get("DEPT_CODE")));
					writer.write("," + Translator.getCSVStr((String)map.get("PAR_CODE")));
					writer.write("," + Translator.getCSVStr(String.valueOf(map.get("SEQ"))));
					writer.write("," + Translator.getCSVStr((String)map.get("STATUS")));
					writer.write("," + Translator.getCSVStr((String)map.get("LINK_ID")));
					writer.write("," + Translator.getCSVStr((String)map.get("COMP_ID")));
					for (String addColumn : addColumns) {
						writer.write("," + Translator.getCSVStr((String)map.get(addColumn)));
					}
					writer.write("\n");
				}
			} else {
				//List<String> addColumns;
				SimpleDateFormat simpleDateFormat;
				if ("0".equals(type)) {
					String[] columns = {"EMP_CODE", "NAME", "DEPT_CODE", "STATUS", "ABS_F", "SEC_LEVEL", "SEQ", "LOCK_F", "OTHER_OFFICE_F", "LOGIN_PASSWD", "PHONE", "E_MAIL", "MOBILE_PHONE",
						"PIC_PATH", "LOGIN_ID", "LINK_ID", "EXPIRY_DATE", "BUSINESS", "NAME_ENG", "FAX", "CLIENT_IP_ADDR", "COMP_ID", "POS_CODE", "POS_NAME"};

					writer.write("*OPERATION");
					for (String column : columns) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, column));
					}
					if (OrgConfigData.getPropertyForBoolean("directory.use.rank")) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, "RANK_NAME"));
					}
					if (OrgConfigData.getPropertyForBoolean("directory.use.duty")) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, "DUTY_NAME"));
					}
					if (OrgConfigData.getPropertyForBoolean("directory.use.uc")) {
						String[] ucColumns = {"PHONE_RULE_ID", "EXT_PHONE", "EXT_PHONE_HEAD", "EXT_PHONE_EXCH", "PHY_PHONE", "FWD_PHONE"};
						writer.write("," + StringUtils.join(ucColumns, ","));
					}
					String addColumnsStr = OrgConfigData.getProperty("directory.export.user.addcolumns");
					addColumns = new ArrayList();
					if (!StringUtils.isEmpty(addColumnsStr)) {
						String[] addColumnsArray = StringUtils.split(addColumnsStr, ",");
						for (String addColumn : addColumnsArray) {
							addColumns.add(addColumn.toUpperCase());
						}
						writer.write("," + StringUtils.join(addColumns, ","));
					}
					writer.write("\n");

					simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");

					List<Map> list = this.orgContext.getUserListForExport(communityID, true, exportDate);
					for (Map map : list) {
						String status = (String)map.get("STATUS");
						if ("4".equals(status)) {
							writer.write("DELETE");
						} else {
							writer.write("ADD");
						}
						writer.write("," + Translator.getCSVStr((String)map.get("EMP_CODE")));
						writer.write("," + Translator.getCSVStr((String)map.get("NAME")));
						writer.write("," + Translator.getCSVStr((String)map.get("DEPT_CODE")));
						writer.write("," + Translator.getCSVStr((String)map.get("STATUS")));
						writer.write("," + Translator.getCSVStr((String)map.get("ABS_F")));
						writer.write("," + Translator.getCSVStr(String.valueOf(map.get("SEC_LEVEL"))));
						writer.write("," + Translator.getCSVStr(String.valueOf(map.get("SEQ"))));
						writer.write("," + Translator.getCSVStr((String)map.get("LOCK_F")));
						writer.write("," + Translator.getCSVStr((String)map.get("OTHER_OFFICE_F")));
						writer.write("," + Translator.getCSVStr((String)map.get("LOGIN_PASSWD")));
						writer.write("," + Translator.getCSVStr((String)map.get("PHONE")));
						writer.write("," + Translator.getCSVStr((String)map.get("E_MAIL")));
						writer.write("," + Translator.getCSVStr((String)map.get("MOBILE_PHONE")));
						writer.write("," + Translator.getCSVStr((String)map.get("PIC_PATH")));
						writer.write("," + Translator.getCSVStr((String)map.get("LOGIN_ID")));

						writer.write("," + Translator.getCSVStr((String)map.get("LINK_ID")));

						writer.write("," + (map.get("EXPIRY_DATE") != null ? simpleDateFormat.format(map.get("EXPIRY_DATE")) : "2999-12-31"));
						writer.write("," + Translator.getCSVStr((String)map.get("BUSINESS")));
						writer.write("," + Translator.getCSVStr((String)map.get("NAME_ENG")));
						writer.write("," + Translator.getCSVStr((String)map.get("FAX")));
						writer.write("," + Translator.getCSVStr((String)map.get("CLIENT_IP_ADDR")));
						writer.write("," + Translator.getCSVStr((String)map.get("COMP_ID")));
						writer.write("," + Translator.getCSVStr((String)map.get("POS_CODE")));
						writer.write("," + Translator.getCSVStr((String)map.get("POS_NAME")));
						if (OrgConfigData.getPropertyForBoolean("directory.use.rank")) {
							writer.write("," + Translator.getCSVStr((String)map.get("RANK_NAME")));
						}
						if (OrgConfigData.getPropertyForBoolean("directory.use.duty")) {
							writer.write("," + Translator.getCSVStr((String)map.get("DUTY_NAME")));
						}
						if (OrgConfigData.getPropertyForBoolean("directory.use.uc")) {
							writer.write("," + Translator.getCSVStr(String.valueOf(map.get("PHONE_RULE_ID"))));
							writer.write("," + Translator.getCSVStr((String)map.get("EXT_PHONE")));
							writer.write("," + Translator.getCSVStr((String)map.get("EXT_PHONE_HEAD")));
							writer.write("," + Translator.getCSVStr((String)map.get("EXT_PHONE_EXCH")));
							writer.write("," + Translator.getCSVStr((String)map.get("PHY_PHONE")));
							writer.write("," + Translator.getCSVStr((String)map.get("FWD_PHONE")));
						}
						for (String addColumn : addColumns) {
							writer.write("," + Translator.getCSVStr((String)map.get(addColumn)));
						}
						writer.write("\n");
					}
				} else if ("2".equals(type)) {
					String[] columns = {"POS_NAME", "POS_NAME_ENG", "POS_CODE", "SEC_LEVEL", "LINK_ID"};
					writer.write("*OPERATION");
					for (String column : columns) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, column));
					}
					writer.write("\n");

					List<Position> list = this.orgContext.getPositionList(communityID);
					for (Position position : list) {
						writer.write("ADD");
						writer.write("," + Translator.getCSVStr(position.getName()));
						writer.write("," + Translator.getCSVStr(position.getNameEng()));
						writer.write("," + Translator.getCSVStr(position.getCode()));
						writer.write("," + Integer.toString(position.getSecurityLevel()));
						writer.write("," + Translator.getCSVStr(position.getLinkID()));
						writer.write("\n");
					}
				} else if (("3".equals(type)) && (OrgConfigData.getPropertyForBoolean("directory.use.rank"))) {
					String[] columns = {"RANK_NAME", "RANK_NAME_ENG", "RANK_CODE", "RANK_LEVEL"};
					writer.write("*OPERATION");
					for (String column : columns) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, column));
					}
					writer.write("\n");

					List<Rank> list = this.orgContext.getRankList(communityID);
					for (Rank rank : list) {
						writer.write("ADD");
						writer.write("," + Translator.getCSVStr(rank.getName()));
						writer.write("," + Translator.getCSVStr(rank.getNameEng()));
						writer.write("," + Translator.getCSVStr(rank.getCode()));
						writer.write("," + Integer.toString(rank.getLevel()));
						writer.write("\n");
					}
				} else if (("4".equals(type)) && (OrgConfigData.getPropertyForBoolean("directory.use.duty"))) {
					String[] columns = {"DUTY_NAME", "DUTY_CODE", "SEQ"};
					writer.write("*OPERATION");
					for (String column : columns) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, column));
					}
					writer.write("\n");

					List<Duty> list = this.orgContext.getDutyList(communityID);
					for (Duty duty : list) {
						writer.write("ADD");
						writer.write("," + Translator.getCSVStr(duty.getName()));
						writer.write("," + Translator.getCSVStr(duty.getCode()));
						writer.write("," + Integer.toString(duty.getSeq()));
						writer.write("\n");
					}
				} else if ("5".equals(type)) {
					String[] columns = {"EMP_CODE", "AUTH_CODE", "REL_CODE"};
					writer.write("*OPERATION");
					for (String column : columns) {
						writer.write("," + BatchColumnConverter.convertBatchToCsv(type, column));
					}
					writer.write("\n");

					List<Map> list = this.orgContext.getUserRoleListForExport(communityID);
					for (Map map : list) {
						if (!"SYS".equals(map.get("AUTH_CODE"))) {
							writer.write("ADD");
							writer.write("," + Translator.getCSVStr((String)map.get("EMP_CODE")));
							writer.write("," + Translator.getCSVStr((String)map.get("AUTH_CODE")));
							writer.write("," + Translator.getCSVStr((String)map.get("REL_CODE")));
							writer.write("\n");
						}
					}
				}
			}
			writer.flush();

			return null;
		} catch (Exception e) {
			this.logger.error(e.getMessage(), e);
			try {
				response.getOutputStream().write(e.getMessage().getBytes());
				response.flushBuffer();
			} catch (Exception e1) {
				this.logger.debug(e.getMessage());
			}
		}
		return null;
	}

	public ModelAndView retryBatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the retryBatch");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		this.orgMngContext.updateBatchToBeWait(communityID, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteBatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteBatch");
		}
		String batchIDs = request.getParameter("batchIDs");

		List<String> batchIdList = new ArrayList();
		String[] ids = StringUtils.split(batchIDs, ";,");
		for (String id : ids) {
			batchIdList.add(id);
		}
		if (batchIdList.size() > 0) {
			this.orgMngContext.deleteBatchs(null, batchIdList, null, null);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteAllBatchs(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteBatchAll");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String listType = request.getParameter("listType");

		List list = new ArrayList();
		list.add("3");
		list.add("0");
		list.add("2");
		if ((listType == null) || ("all".equals(listType))) {
			this.orgMngContext.deleteBatchs(communityID, null, new StatusKey(list), null);
		} else {
			this.orgMngContext.deleteBatchCompleted(communityID, null);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewBatchMsg(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewBatchMsg");
		}
		String batchID = request.getParameter("batchID");

		Batch batch = this.orgMngContext.getBatch(batchID);
		BatchMsg batchMsg = null;
		if ("3".equals(batch.getStatus())) {
			batchMsg = this.orgMngContext.getBatchMsg(batchID);
		} else {
			batchMsg = new BatchMsgImpl();
			batchMsg.setMessage("");
		}
		ModelAndView mav = new ModelAndView("mng/viewBatchMsg");
		mav.addObject("batch", batch);
		mav.addObject("batchMsg", batchMsg);
		return mav;
	}

	public ModelAndView runBatchProcess(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the runBatchProcess");
		}
		this.orgMngContext.runBatchProcess();

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public void importDirectory(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the importDirectory");
		}
	}

	public void exportDirectory(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the exportDirectory");
		}
	}

	public ModelAndView listCommunities(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listCommunities");
		}
		List<Community> communityList = this.orgContext.getCommunityListWithUserCount(null);

		ModelAndView mav = new ModelAndView("mng/listCommunities");
		mav.addObject("communityList", communityList);
		mav.addObject("useCommunityRequest", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.communityRequest")));
		return mav;
	}

	public ModelAndView viewCommunity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewCommunity");
		}
		String communityID = request.getParameter("communityID");

		Community community = this.orgContext.getCommunity(communityID);

		ModelAndView mav = new ModelAndView("mng/viewCommunity");
		mav.addObject("community", community);
		mav.addObject("useDirGroup", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.dirgroup")));
		if (community.getID().equals("001000000")) {
			mav.addObject("editable", Boolean.valueOf(false));
			mav.addObject("deletable", Boolean.valueOf(false));
		} else {
			mav.addObject("editable", Boolean.valueOf(true));
			List deptList = this.orgContext.getDeptList(communityID, null, 0, new StatusKey(Arrays.asList(new String[] {"1", "8"})), true);
			if ((community.getUserCount() > 1) || (deptList.size() > 1)) {
				mav.addObject("deletable", Boolean.valueOf(false));
			} else {
				mav.addObject("deletable", Boolean.valueOf(true));
			}
		}
		return mav;
	}

	public ModelAndView viewAddCommunity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddCommunity");
		}
		ModelAndView mav = new ModelAndView("mng/addCommunity");
		mav.addObject("localeList", OrgConfigData.getProperty("directory.locale.support", "ko_KR"));
		return mav;
	}

	public ModelAndView addCommunity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addCommunity");
		}
		String communityExpiryDate = request.getParameter("communityExpiryDate");
		boolean communityExpiryDateUnlimited = "true".equals(request.getParameter("communityExpiryDateUnlimited"));

		Community community = new CommunityImpl();
		community.setName(request.getParameter("communityName"));
		community.setAlias(request.getParameter("communityAlias"));
		community.setManagerName(request.getParameter("communityManagerName"));
		community.setMaxUser(Integer.parseInt(request.getParameter("communityMaxUser")));
		if ((StringUtils.isNotBlank(communityExpiryDate)) && (!communityExpiryDateUnlimited)) {
			community.setExpiryDate(new SimpleDateFormat("yyyy.MM.dd").parse(communityExpiryDate));
		} else {
			community.setExpiryDate(null);
		}
		community.setDefaultLocale(request.getParameter("communityDefaultLocale"));
		community.setPhone(request.getParameter("communityPhone"));
		community.setFax(request.getParameter("communityFax"));
		community.setHomeUrl(request.getParameter("communityHomeUrl"));
		community.setEmail(request.getParameter("communityEmail"));

		this.orgMngContext.addCommunity(community, null);
		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("communityID", community.getID());
		return mav;
	}

	public ModelAndView viewUpdateCommunity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateCommunity");
		}
		String communityID = request.getParameter("communityID");

		Community community = this.orgContext.getCommunity(communityID);

		ModelAndView mav = new ModelAndView("mng/updateCommunity");
		mav.addObject("community", community);
		mav.addObject("localeList", OrgConfigData.getProperty("directory.locale.support", "ko_KR"));
		return mav;
	}

	public ModelAndView updateCommunity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateCommunity");
		}
		String communityExpiryDate = request.getParameter("communityExpiryDate");
		boolean communityExpiryDateUnlimited = "true".equals(request.getParameter("communityExpiryDateUnlimited"));

		Community community = new CommunityImpl();
		community.setID(request.getParameter("communityID"));
		community.setName(request.getParameter("communityName"));
		community.setAlias(request.getParameter("communityAlias"));
		community.setManagerName(request.getParameter("communityManagerName"));
		community.setMaxUser(Integer.parseInt(request.getParameter("communityMaxUser")));
		if ((StringUtils.isNotBlank(communityExpiryDate)) && (!communityExpiryDateUnlimited)) {
			community.setExpiryDate(new SimpleDateFormat("yyyy.MM.dd").parse(communityExpiryDate));
		} else {
			community.setExpiryDate(null);
		}
		community.setDefaultLocale(request.getParameter("communityDefaultLocale"));
		community.setPhone(request.getParameter("communityPhone"));
		community.setFax(request.getParameter("communityFax"));
		community.setHomeUrl(request.getParameter("communityHomeUrl"));
		community.setEmail(request.getParameter("communityEmail"));

		this.orgMngContext.updateCommunity(community, null);
		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("communityID", community.getID());
		return mav;
	}

	public ModelAndView deleteCommunity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteCommunity");
		}
		this.orgMngContext.deleteCommunity(request.getParameter("communityID"), null);
		try {
			CommunityRequest communityRequest = this.orgContext.getCommunityRequestByCommunityID(request.getParameter("communityID"));
			communityRequest.setExpiredDate(new Date());
			communityRequest.setStatus("2");
			this.orgMngContext.updateCommunityRequest(communityRequest, null);
		} catch (Exception e) {
			this.logger.error(e.getMessage(), e);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView addCommunityRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String remoteAddr = request.getRemoteAddr();
		if (!isSsoHost(remoteAddr)) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addCommunityRequest");
		}
		CommunityRequest communityRequest = new CommunityRequestImpl();
		communityRequest.setCompanyName(request.getParameter("companyName"));
		communityRequest.setCompanyNameEng(request.getParameter("companyNameEng"));
		communityRequest.setCompanyType(request.getParameter("companyType"));
		communityRequest.setManagerName(request.getParameter("managerName"));
		communityRequest.setEmail(request.getParameter("eMail"));
		communityRequest.setPhone(request.getParameter("phone"));
		communityRequest.setMobilePhone(request.getParameter("mobilePhone"));
		communityRequest.setDomainFlag(request.getParameter("domainFlag"));
		communityRequest.setDomain(request.getParameter("domain"));
		communityRequest.setUserCount(Integer.parseInt(request.getParameter("userCount")));
		communityRequest.setDefaultLocale(request.getParameter("defaultLocale"));
		communityRequest.setServiceMonths(Integer.parseInt(request.getParameter("serviceMonths")));
		communityRequest.setRequestType(request.getParameter("requestType"));
		if (StringUtils.isBlank(communityRequest.getRequestType())) {
			communityRequest.setRequestType("0");
		}
		communityRequest.setRequestDate(new Date());
		communityRequest.setStatus("0");
		this.orgMngContext.addCommunityRequest(communityRequest, null);

		ModelAndView mav = new ModelAndView("mng/addCommunityRequest", "errorCode", Integer.valueOf(0));
		mav.addObject("communityRequest", communityRequest);
		return mav;
	}

	public ModelAndView getCommunityRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String remoteAddr = request.getRemoteAddr();
		if (!isSsoHost(remoteAddr)) {
			throw new NoAuthorizationException(5006, "don't have the authority for the getCommunityRequest");
		}
		String communityRequestID = request.getParameter("CRI");

		CommunityRequest communityRequest = this.orgContext.getCommunityRequest(communityRequestID);

		ModelAndView mav = new ModelAndView("mng/getCommunityRequest", "errorCode", Integer.valueOf(0));
		mav.addObject("communityRequest", communityRequest);
		return mav;
	}

	private boolean isSsoHost(String ip) {
		try {
			String[] ssoHosts = OrgConfigData.getProperty("directory.sso.hosts").split(",");
			for (int i = 0; i < ssoHosts.length; i++) {
				if (ip.equals(ssoHosts[i])) {
					return true;
				}
			}
			InetAddress ia = InetAddress.getByName(ip);
			String hostName = ia.getHostName();
			for (int i = 0; i < ssoHosts.length; i++) {
				if (hostName.equals(ssoHosts[i])) {
					return true;
				}
			}
		} catch (Exception e) {
			this.logger.error(e.getMessage(), e);
			return false;
		}
		return false;
	}

	public ModelAndView listCommunityRequests(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listCommunityRequests");
		}
		String status = request.getParameter("status");

		List<CommunityRequest> communityRequestList = new ArrayList();
		if ((status != null) && (status.equals("approved"))) {
			communityRequestList = this.orgContext.getCommunityRequestList("1");
		} else if ((status != null) && (status.equals("expired"))) {
			communityRequestList = this.orgContext.getCommunityRequestList("2");
		} else {
			communityRequestList = this.orgContext.getCommunityRequestList("0");
		}
		ModelAndView mav = new ModelAndView("mng/listCommunityRequests");
		mav.addObject("communityRequestList", communityRequestList);
		return mav;
	}

	public ModelAndView viewCommunityRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewCommunityRequest");
		}
		String communityRequestID = request.getParameter("communityRequestID");

		CommunityRequest communityRequest = this.orgContext.getCommunityRequest(communityRequestID);

		ModelAndView mav = new ModelAndView("mng/viewCommunityRequest");
		mav.addObject("communityRequest", communityRequest);
		return mav;
	}

	public ModelAndView approveCommunityRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the approveCommunityRequest");
		}
		String communityRequestID = request.getParameter("communityRequestID");

		CommunityRequest communityRequest = this.orgContext.getCommunityRequest(communityRequestID);

		Community community = new CommunityImpl();
		community.setName(communityRequest.getCompanyName());
		community.setAlias(communityRequest.getCompanyNameEng());
		community.setManagerName(communityRequest.getCompanyNameEng() + "admin");
		community.setMaxUser(communityRequest.getUserCount());
		if (communityRequest.getServiceMonths() > 0) {
			Calendar cal = Calendar.getInstance();
			cal.add(2, communityRequest.getServiceMonths());
			community.setExpiryDate(cal.getTime());
		} else {
			community.setExpiryDate(null);
		}
		community.setDefaultLocale(communityRequest.getDefaultLocale());
		community.setPhone(communityRequest.getPhone());
		community.setEmail(communityRequest.getEmail());
		this.orgMngContext.addCommunity(community, null);

		communityRequest.setCommunityID(community.getID());
		communityRequest.setApprovedDate(new Date());
		communityRequest.setExpiredDate(community.getExpiryDate());
		communityRequest.setStatus("1");
		this.orgMngContext.updateCommunityRequest(communityRequest, null);

		ModelAndView mav = new ModelAndView("mng/addCommunityRequest", "errorCode", Integer.valueOf(0));
		mav.addObject("communityRequestID", communityRequest.getCommunityRequestID());
		return mav;
	}

	public ModelAndView resetDeptTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the resetDeptTree");
		}
		String communityID = request.getParameter("communityID");

		this.orgMngContext.resetDeptTree(communityID);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView resetDirGroupTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "SYS")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the resetDirGroupTree");
		}
		String communityID = request.getParameter("communityID");

		this.orgMngContext.resetDirGroupTree(communityID);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewAddExternalUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = request.getParameter("communityID");
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, false, 1);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			throw new OrgException(3000, e.getMessage());
		}
		String externalDeptID = OrgConfigData.getProperty("directory.external.rootdeptid");
		if (StringUtils.isEmpty(externalDeptID)) {
			throw new OrgException(3000, "The external root dept ID doesn't exist! Please, check the configuration.");
		}
		Dept dept = this.orgContext.getDept(externalDeptID);
		List deptList = this.orgContext.getDeptList(communityID, dept.getID(), 2, null);
		if (deptList == null) {
			deptList = new ArrayList();
		}
		deptList.add(0, dept);
		List<Position> positionList = this.orgContext.getPositionList(communityID);
		String defaultLoginPassword = OrgConfigData.getProperty("directory.password.defaultpassword", "1");

		ModelAndView mav = new ModelAndView("mng/addExternalUser");
		mav.addObject("dept", dept);
		mav.addObject("deptList", deptList);
		mav.addObject("positionList", positionList);
		mav.addObject("defaultLoginPassword", defaultLoginPassword);
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		if (OrgConfigData.getPropertyForBoolean("directory.use.rank")) {
			mav.addObject("rankList", this.orgContext.getRankList(communityID));
		}
		mav.addObject("isEmailRequired", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.email.rule.required")));
		mav.addObject("useUC", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.uc")));

		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("required", createOptionMap(request.getParameter("required")));
		return mav;
	}

	public ModelAndView addExternalUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = request.getParameter("communityID");
		String deptID = request.getParameter("deptID");
		String userName = request.getParameter("userName");
		String userNameEng = request.getParameter("userNameEng");
		String empCode = request.getParameter("empCode");
		String positionID = request.getParameter("positionID");
		String rankID = request.getParameter("rankID");

		String secLevel = request.getParameter("secLevel");
		String loginID = request.getParameter("loginID");
		String loginPassword = request.getParameter("loginPassword");

		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String mobilePhone = request.getParameter("mobilePhone");
		String fax = request.getParameter("fax");

		String extPhone = request.getParameter("extPhone");

		User user = new UserImpl();
		user.setCommunityID(communityID);
		user.setDeptID(deptID);
		user.setName(userName);
		user.setNameEng(userNameEng);
		user.setEmpCode(empCode);
		user.setSeq(-1);
		user.setPositionID(positionID);
		user.setRankID(rankID);

		user.setSecurityLevel(Integer.parseInt(secLevel));
		user.setLoginID(loginID);
		user.setLoginPassword(loginPassword);
		user.setLock(true);

		user.setEmail(email);
		user.setPhone(phone);
		user.setMobilePhone(mobilePhone);
		user.setFax(fax);

		user.setExtPhone(extPhone);

		user.setStatus("8");

		List<UserAuth> userAuths = new ArrayList();
		userAuths.add(new UserAuthImpl(null, "110", null));
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, false, 1);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			throw new OrgException(3000, e.getMessage());
		}
		this.orgMngContext.addUser(user, userAuths, null);
		try {
			LicenseManager.isValidLicenseForRegisteredUser(communityID, true, 0);
		} catch (LicenseException e) {
			this.logger.error(e.getMessage(), e);

			this.orgMngContext.deleteUser(user.getID(), true, null);
			throw new OrgException(3000, e.getMessage());
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView listExternalUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;EUM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listExternalUsers");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String deptID = request.getParameter("deptID");
		String currentPage = getParameter(request, "currentPage", "1");
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");

		PaginationParam pParam = new PaginationParam(15, 10);

		MultiSearchKey multiSearchKey = new MultiSearchKey();
		SearchKey searchKey = createUserSearchKey(searchType, searchValue);
		AuthKey authKey = new AuthKey("110");
		multiSearchKey.add(searchKey);
		multiSearchKey.add(authKey);
		OrderByKey orderByKey = createOrderByKey(orderField, orderType);

		pParam.setCurrentPage(Integer.parseInt(currentPage));
		pParam.setTotalCount(this.orgContext.getUserListCount(communityID, deptID, 2, multiSearchKey, pParam, new String[] {"4"}, true));
		List<User> userList = this.orgContext.getUserList(communityID, deptID, 2, multiSearchKey, orderByKey, pParam, new String[] {"4"}, true);

		Map cryptedUserColumnsMap = this.orgContext.getCryptedUserColumnsMap();
		Dept dept = this.orgContext.getDept(deptID);

		ModelAndView mav = new ModelAndView("mng/listExternalUsers");
		mav.addObject("pParam", pParam);
		mav.addObject("dept", dept);
		mav.addObject("userList", userList);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("cryptedUserColumnsMap", cryptedUserColumnsMap);
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));

		return mav;
	}

	public ModelAndView confirmExternalUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;EUM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteBatch");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		String userIDs = request.getParameter("userIDs");

		List<String> userIDList = new ArrayList();
		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			userIDList.add(id);
		}
		if (userIDList.size() > 0) {
			this.orgMngContext.updateExternalUsers(communityID, userIDList, true, null);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView rejectExternalUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if (!isAuthorization(uid, null, "ADM;EUM")) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteBatch");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		String userIDs = request.getParameter("userIDs");

		List<String> userIDList = new ArrayList();
		String[] ids = StringUtils.split(userIDs, ";,");
		for (String id : ids) {
			userIDList.add(id);
		}
		if (userIDList.size() > 0) {
			this.orgMngContext.updateExternalUsers(communityID, userIDList, false, null);
		}
		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	private String getParameter(HttpServletRequest request, String name, String defaultValue) {
		String value = request.getParameter(name);
		return StringUtils.isNotEmpty(value) ? value : defaultValue;
	}

	public ModelAndView dirGroupMng(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the dirGroupMng");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<DirGroup> hirList = this.orgContext.getDirGroupList(communityID, "000000000", 1, new DirGroupTypeKey("H"), true);

		ModelAndView mav = new ModelAndView("mng/dirGroupMng");

		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("hirList", hirList);
		return mav;
	}

	public ModelAndView initDirGroupTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the initDirGroupTree");
		}
		String hirID = request.getParameter("hirID");
		boolean isExpandAll = "true".equals(request.getParameter("isExpandAll"));

		List<DirGroup> rootList = this.orgContext.getDirGroupList(null, hirID, 1, null, true);

		List<DirGroup> pathList = null;
		if (isExpandAll) {
			pathList = this.orgContext.getDirGroupList(null, hirID, 2, null, true);
			pathList = sortBySeqForDirGroup(pathList);
		} else {
			pathList = new ArrayList();
			pathList.addAll(rootList);
			for (DirGroup tmp : rootList) {
				pathList.addAll(this.orgContext.getDirGroupList(null, tmp.getID(), 1, null, true));
			}
		}
		String data = "";
		for (DirGroup root : rootList) {
			if (StringUtils.isNotEmpty(data)) {
				data = data + ", ";
			}
			data = data + buildTreeDataForDirGroup(root, pathList, isExpandAll);
		}
		return new ModelAndView("mng/treeData", "data", data);
	}

	private List<DirGroup> sortBySeqForDirGroup(List<DirGroup> list) {
		Collections.sort(list, new Comparator() {
			public int compare(DirGroup o1, DirGroup o2) {
				if (o1.getSeq() > o2.getSeq()) {
					return 1;
				}
				if (o1.getSeq() == o2.getSeq()) {
					return 0;
				}
				return -1;
			}

			//FIXME: 여기 위에거로 수정필요함
			@Override
			public int compare(Object o1, Object o2) {
				// TODO Auto-generated method stub
				return 0;
			}
		});
		return list;
	}

	private String buildTreeDataForDirGroup(DirGroup group, List<DirGroup> pathList, boolean isExpandAll) throws OrgException {
		String children = "";
		for (DirGroup tmp : pathList) {
			if (tmp.getParentID().equals(group.getID())) {
				if (StringUtils.isNotEmpty(children)) {
					children = children + ", ";
				}
				children = children + buildTreeDataForDirGroup(tmp, pathList, isExpandAll);
			}
		}
		return "{\"key\": \"" + group.getID() + "\", \"title\": \"" + group.getName() + "\", \"isLazy\": true, \"isFolder\": true" + ", \"expand\": " + isExpandAll + ", \n\"children\": [" + children
			+ "]}";
	}

	public ModelAndView expandDirGroupTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the expandDirGroupTree");
		}
		String groupID = request.getParameter("groupID");

		List<DirGroup> groupList = this.orgContext.getDirGroupList(null, groupID, 1, null, true);

		return new ModelAndView("mng/treeData", "groupList", groupList);
	}

	public ModelAndView searchDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the searchDirGroup");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchValue = request.getParameter("searchValue");

		List<DirGroup> groupList = null;
		if (StringUtils.isEmpty(searchValue)) {
			groupList = new ArrayList();
		} else {
			MultiSearchKey multiKey = new MultiSearchKey();
			multiKey.add(new DirGroupTypeKey("G"));
			multiKey.add(new NameKey(searchValue));
			groupList = this.orgContext.getDirGroupList(communityID, null, 0, multiKey, true);
		}
		return new ModelAndView("mng/treeData", "groupList", groupList);
	}

	public ModelAndView viewDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewDirGroup");
		}
		String groupID = request.getParameter("groupID");

		DirGroup group = null;
		try {
			group = this.orgContext.getDirGroup(groupID);
		} catch (OrgException e) {
			if (1204 == e.getErrorCode()) {
				ModelAndView mav = new ModelAndView("mng/viewDirGroup");
				mav.addObject("group", null);
				mav.addObject("hirID", request.getParameter("hirID"));
				return mav;
			}
			throw e;
		}
		DirGroup hir = this.orgContext.getDirGroup(group.getHierarchyID());
		List<User> memberList = this.orgContext.getDirGroupMemberList(groupID);

		ModelAndView mav = new ModelAndView("mng/viewDirGroup");
		mav.addObject("group", group);
		mav.addObject("hir", hir);
		mav.addObject("memberList", memberList);
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView viewAddDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddDirGroup");
		}
		String targetGroupID = request.getParameter("targetGroupID");

		DirGroup targetGroup = this.orgContext.getDirGroup(targetGroupID);
		DirGroup hir = "H".equals(targetGroup.getType()) ? targetGroup : this.orgContext.getDirGroup(targetGroup.getHierarchyID());

		ModelAndView mav = new ModelAndView("mng/addDirGroup");
		mav.addObject("targetGroup", targetGroup);
		mav.addObject("hir", hir);
		return mav;
	}

	public ModelAndView addDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {

		Authentication auth = (Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION");
		String uid = auth.getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addDirGroup");
		}
		String groupName = request.getParameter("groupName");
		String memberIDs = request.getParameter("memberIDs");
		String targetGroupID = request.getParameter("targetGroupID");
		String movePosition = request.getParameter("movePosition");

		DirGroup targetGroup = this.orgContext.getDirGroup(targetGroupID);

		DirGroup parent = null;
		int toSeqNum = 0;
		if ("1".equals(movePosition)) {
			parent = this.orgContext.getDirGroup(targetGroup.getParentID());
			toSeqNum = targetGroup.getSeq();
		} else if ("2".equals(movePosition)) {
			parent = this.orgContext.getDirGroup(targetGroup.getParentID());
			toSeqNum = targetGroup.getSeq() + 1;
		} else {
			parent = targetGroup;
		}
		DirGroup group = new DirGroupImpl();
		group.setName(groupName);

		List<String> members = new ArrayList();
		if (memberIDs != null) {
			String[] ids = StringUtils.split(memberIDs, ";,");
			for (String id : ids) {
				members.add(id);
			}
		}
		if ("0".equals(movePosition)) {
			this.orgMngContext.addDirGroup(group, parent.getID(), members, null);
		} else {
			this.orgMngContext.addDirGroup(group, parent.getID(), toSeqNum, members, null);
		}
		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("groupID", group.getID());

		String uKey = auth.getUserKey();

		Map<String, String> params = new HashMap<String, String>();
		params.put("groupId", group.getID());
		params.put("groupName", URLEncoder.encode(groupName, "UTF-8"));
		params.put("userIds", memberIDs);
		callBPMService("createGroup", uKey, params);

		return mav;
	}

	public ModelAndView viewUpdateDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateDirGroup");
		}
		String groupID = request.getParameter("groupID");

		DirGroup group = this.orgContext.getDirGroup(groupID);
		DirGroup hir = this.orgContext.getDirGroup(group.getHierarchyID());
		List<User> memberList = this.orgContext.getDirGroupMemberList(groupID);

		ModelAndView mav = new ModelAndView("mng/updateDirGroup");
		mav.addObject("group", group);
		mav.addObject("hir", hir);
		mav.addObject("memberList", memberList);
		return mav;
	}

	public ModelAndView updateDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Authentication auth = (Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION");
		String uid = auth.getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateDirGroup");
		}
		String groupID = request.getParameter("groupID");
		String groupName = request.getParameter("groupName");
		String groupStatus = request.getParameter("groupStatus");
		String memberIDs = request.getParameter("memberIDs");

		DirGroup group = this.orgContext.getDirGroup(groupID);
		group.setName(groupName);
		group.setStatus(groupStatus);

		List<String> members = new ArrayList();
		if (memberIDs != null) {
			String[] ids = StringUtils.split(memberIDs, ";,");
			for (String id : ids) {
				members.add(id);
			}
		}
		this.orgMngContext.updateDirGroup(group, members, null);

		String uKey = auth.getUserKey();
		Map<String, String> params = new HashMap<String, String>();
		params.put("groupId", group.getID());
		params.put("groupName", URLEncoder.encode(groupName, "UTF-8"));
		params.put("userIds", memberIDs);
		callBPMService("updateGroup", uKey, params);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Authentication auth = (Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION");
		String uid = auth.getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteDirGroup");
		}
		String groupID = request.getParameter("groupID");

		DirGroup group = this.orgContext.getDirGroup(groupID);
		DirGroup parent = this.orgContext.getDirGroup(group.getParentID());

		String resultGroupID = group.getParentID();
		String resultHirID = group.getHierarchyID();

		this.orgMngContext.deleteDirGroup(group.getID(), null);
		if ("H".equals(parent.getType())) {
			List<DirGroup> rootList = this.orgContext.getDirGroupList(null, parent.getID(), 1, null, true);
			if (rootList.size() > 0) {
				resultGroupID = ((DirGroup)rootList.get(0)).getID();
			} else {
				resultGroupID = null;
			}
		}

		String uKey = auth.getUserKey();
		Map<String, String> params = new HashMap<String, String>();
		params.put("groupId", group.getID());
		callBPMService("deleteGroup", uKey, params);

		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("groupID", resultGroupID);
		mav.addObject("hirID", resultHirID);
		return mav;
	}

	public ModelAndView listDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listDirGroupHir");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<DirGroup> hirList = this.orgContext.getDirGroupList(communityID, "000000000", 1, new DirGroupTypeKey("H"), true);

		ModelAndView mav = new ModelAndView("mng/listDirGroupHir");
		mav.addObject("hirList", hirList);
		return mav;
	}

	public ModelAndView viewDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewDirGroupHir");
		}
		String hirID = request.getParameter("hirID");

		DirGroup hir = null;
		try {
			hir = this.orgContext.getDirGroup(hirID);
		} catch (OrgException e) {
			if (1204 == e.getErrorCode()) {
				ModelAndView mav = new ModelAndView("mng/viewDirGroupHir");
				mav.addObject("hir", null);
				return mav;
			}
			throw e;
		}
		ModelAndView mav = new ModelAndView("mng/viewDirGroupHir");
		mav.addObject("hir", hir);
		return mav;
	}

	public ModelAndView viewAddDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewAddDirGroupHir");
		}
		ModelAndView mav = new ModelAndView("mng/addDirGroupHir");
		return mav;
	}

	public ModelAndView addDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the addDirGroupHir");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String hirName = request.getParameter("hirName");

		DirGroup group = new DirGroupImpl();
		group.setName(hirName);

		this.orgMngContext.addDirGroupHierarchy(communityID, group, null);

		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		mav.addObject("hirID", group.getID());
		return mav;
	}

	public ModelAndView viewUpdateDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateDirGroupHir");
		}
		String hirID = request.getParameter("hirID");

		DirGroup hir = this.orgContext.getDirGroup(hirID);

		ModelAndView mav = new ModelAndView("mng/updateDirGroupHir");
		mav.addObject("hir", hir);
		return mav;
	}

	public ModelAndView updateDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateDirGroupHir");
		}
		String hirID = request.getParameter("hirID");
		String hirName = request.getParameter("hirName");
		String hirStatus = request.getParameter("hirStatus");

		DirGroup hir = this.orgContext.getDirGroup(hirID);
		hir.setName(hirName);
		hir.setStatus(hirStatus);

		this.orgMngContext.updateDirGroup(hir, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateDirGroupHirSeq(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateDirGroupHir");
		}
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<DirGroup> hirList = this.orgContext.getDirGroupList(communityID, "000000000", 1, new DirGroupTypeKey("H"), true);

		ModelAndView mav = new ModelAndView("mng/updateDirGroupHirSeq");
		mav.addObject("hirList", hirList);
		return mav;
	}

	public ModelAndView updateDirGroupHirSeq(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the updateDirGroupHir");
		}
		String hirIDs = request.getParameter("hirIDs");

		List<String> hIDs = new ArrayList();
		String[] ids = StringUtils.split(hirIDs, ";,");
		for (String id : ids) {
			hIDs.add(id);
		}
		this.orgMngContext.updateDirGroupsSeq(hIDs, null);

		return new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteDirGroupHir(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		if ((!isAuthorization(uid, null, "ADM")) || (!OrgConfigData.getPropertyForBoolean("directory.use.dirgroup"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteDirGroupHir");
		}
		String hirID = request.getParameter("hirID");

		this.orgMngContext.deleteDirGroup(hirID, null);

		ModelAndView mav = new ModelAndView("mng/resultData", "errorCode", Integer.valueOf(0));
		return mav;
	}
}

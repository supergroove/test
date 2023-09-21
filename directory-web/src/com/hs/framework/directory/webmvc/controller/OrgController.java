package com.hs.framework.directory.webmvc.controller;

import com.hs.framework.directory.common.license.LicenseException;
import com.hs.framework.directory.common.license.LicenseManager;
import com.hs.framework.directory.config.OrgConfigData;
import com.hs.framework.directory.context.DuplicatedLoginException;
import com.hs.framework.directory.context.DuplicatedNameException;
import com.hs.framework.directory.context.FileUploadBase;
import com.hs.framework.directory.context.FileUploadCommonImpl;
import com.hs.framework.directory.context.NameParser;
import com.hs.framework.directory.context.NoAuthenticationException;
import com.hs.framework.directory.context.NoAuthorizationException;
import com.hs.framework.directory.context.OrgContext;
import com.hs.framework.directory.context.OrgException;
import com.hs.framework.directory.context.OrgFolder;
import com.hs.framework.directory.context.OrgPasswordRulesException;
import com.hs.framework.directory.context.PasswordRules;
import com.hs.framework.directory.context.UserOrderKeys;
import com.hs.framework.directory.context.rsa.RsaKeyGen;
import com.hs.framework.directory.info.Absence;
import com.hs.framework.directory.info.Auth;
import com.hs.framework.directory.info.Authentication;
import com.hs.framework.directory.info.Dept;
import com.hs.framework.directory.info.DirGroup;
import com.hs.framework.directory.info.Group;
import com.hs.framework.directory.info.GroupApp;
import com.hs.framework.directory.info.LinkageAccount;
import com.hs.framework.directory.info.Member;
import com.hs.framework.directory.info.Position;
import com.hs.framework.directory.info.User;
import com.hs.framework.directory.info.UserAuth;
import com.hs.framework.directory.info.impl.AbsenceImpl;
import com.hs.framework.directory.info.impl.GroupImpl;
import com.hs.framework.directory.info.impl.LinkageAccountImpl;
import com.hs.framework.directory.info.impl.MemberImpl;
import com.hs.framework.directory.model.Contact;
import com.hs.framework.directory.model.ContactGroup;
import com.hs.framework.directory.model.FileVO;
import com.hs.framework.directory.model.PaginationParam;
import com.hs.framework.directory.model.ResolveResult;
import com.hs.framework.directory.model.RuleParameter;
import com.hs.framework.directory.search.BusinessKey;
import com.hs.framework.directory.search.DeptIDKey;
import com.hs.framework.directory.search.DeptNameKey;
import com.hs.framework.directory.search.DirGroupTypeKey;
import com.hs.framework.directory.search.DutyKey;
import com.hs.framework.directory.search.EmailKey;
import com.hs.framework.directory.search.EmpCodeKey;
import com.hs.framework.directory.search.FlagKey;
import com.hs.framework.directory.search.LoginApp;
import com.hs.framework.directory.search.MobilePhoneKey;
import com.hs.framework.directory.search.MultiORSearchKey;
import com.hs.framework.directory.search.MultiSearchKey;
import com.hs.framework.directory.search.NameKey;
import com.hs.framework.directory.search.OrderByKey;
import com.hs.framework.directory.search.OrderKey;
import com.hs.framework.directory.search.PhoneKey;
import com.hs.framework.directory.search.PositionKey;
import com.hs.framework.directory.search.RankKey;
import com.hs.framework.directory.search.SearchKey;
import com.hs.framework.directory.search.UserIDKey;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.StringTokenizer;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.LocaleUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MethodNameResolver;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class OrgController extends MultiActionController implements InitializingBean {
	private OrgContext orgContext;
	private PasswordRules passwordRules;
	private OrgFolder orgFolder;
	private long maxUploadSize;
	private String uploadTempDir;
	private FileUploadBase fileUpload;
	private String allowFileExt = ",bmp,gif,jpg,jpeg,png,";
	private static final String PAGE_ACTON = ";popup;userList;searchUser;contactList;resolveItems;memberList;positionList;viewUpdateUserInfo;viewChangePassword;viewSetAbsence;listAbsences;viewUpdateAbsence;viewUpdateNotify;viewUpdateLinkageAccount;groupMng;listGroups;viewAddGroup;viewUpdateGroup;orgView;absentUserList;searchAbsentUser;loginUserList;searchLoginUser;viewDeptSpec;viewUserSpec;main;orgEnv;dirGroupMemberList;viewFavoriteUser;viewUpdateFavoriteUser;viewRecentSearchUser;unifiedSearch;listUnifiedSearchUsers;";
	private static final String NOAUTH_ACTON = ";login;loginByCert;generateKeyPairs;viewPicture;";

	public void setOrgContext(OrgContext orgContext) {
		this.orgContext = orgContext;
	}

	public void setPasswordRules(PasswordRules passwordRules) {
		this.passwordRules = passwordRules;
	}

	public void setOrgFolder(OrgFolder orgFolder) {
		this.orgFolder = orgFolder;
	}

	public FileUploadBase getFileUpload() {
		return this.fileUpload;
	}

	public void setFileUpload(FileUploadBase fileUpload) {
		this.fileUpload = fileUpload;
	}

	public long getMaxUploadSize() {
		return this.maxUploadSize;
	}

	private void setMaxUploadSize(long maxUploadSize) {
		this.maxUploadSize = maxUploadSize;
	}

	private void setUploadTempDir(String uploadTempDir) {
		this.uploadTempDir = uploadTempDir;
	}

	private void setContextDir(HttpServletRequest request) {
		String contexDir = request.getSession().getServletContext().getRealPath("/");

		String tmp = "directory" + File.separator + "tmp";
		tmp = File.separator + tmp;

		setUploadTempDir(contexDir + tmp);
	}

	public void afterPropertiesSet() throws Exception {
		setMaxUploadSize(OrgConfigData.getPropertyForInt("directory.upload.maxsize", 1048576));
		if (this.fileUpload == null) {
			this.fileUpload = FileUploadCommonImpl.getInstance();
			this.fileUpload.init(new Long(getMaxUploadSize()));
		}
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

			boolean isNoAuthPage = ";login;loginByCert;generateKeyPairs;viewPicture;".indexOf(";" + methodName + ";") > -1;
			if ((isNoAuthPage) || (isAuthentication(request, response))) {
				try {
					String communityID = isNoAuthPage ? request.getParameter("communityID") : ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
					if (StringUtils.isEmpty(communityID)) {
						communityID = "001000000";
					}
					LicenseManager.isValidLicense(communityID);
				} catch (LicenseException e) {
					this.logger.error(e.getMessage(), e);

					throw new OrgException(3000, e.getMessage());
				}
				return super.handleRequestInternal(request, response);
			}
			throw new NoAuthenticationException(5005, "can't find the authentication info.");
		} catch (MaxUploadSizeExceededException e) {
			this.logger.error(e.getMessage(), e);

			ModelAndView mav = new ModelAndView("mng/resultData");

			mav.addObject("errorCode", Integer.valueOf(5007));
			mav.addObject("errorMessage", StringEscapeUtils.escapeJava(e.getMessage()));
			mav.addObject("length", Long.valueOf(e.getMaxUploadSize()));
			return mav;
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
			|| (";popup;userList;searchUser;contactList;resolveItems;memberList;positionList;viewUpdateUserInfo;viewChangePassword;viewSetAbsence;listAbsences;viewUpdateAbsence;viewUpdateNotify;viewUpdateLinkageAccount;groupMng;listGroups;viewAddGroup;viewUpdateGroup;orgView;absentUserList;searchAbsentUser;loginUserList;searchLoginUser;viewDeptSpec;viewUserSpec;main;orgEnv;dirGroupMemberList;viewFavoriteUser;viewUpdateFavoriteUser;viewRecentSearchUser;unifiedSearch;listUnifiedSearchUsers;".indexOf(
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

	private String getParameter(HttpServletRequest request, String name, String defaultValue) {
		String value = request.getParameter(name);
		return StringUtils.isNotEmpty(value) ? value : defaultValue;
	}

	private String getNotHiddenDeptInPath(String baseDept) {
		List<Dept> list = this.orgContext.getDeptList(null, baseDept, 3, null, true);
		for (Dept dept : list) {
			if ("8".equals(dept.getStatus())) {
				return dept.getParentID();
			}
		}
		return baseDept;
	}

	public ModelAndView popup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String startDept = request.getParameter("startDept");

		User user = this.orgContext.getUser(uid);

		String baseDept = request.getParameter("baseDept");
		if (StringUtils.isEmpty(baseDept)) {
			baseDept = user.getDeptID();
		}
		if ((StringUtils.isNotEmpty(startDept)) && (!"undefined".equalsIgnoreCase(startDept))) {
			List<Dept> pathList = this.orgContext.getDeptList(communityID, startDept, 3, null);
			for (Dept o : pathList) {
				if (o.getID().equals(user.getDeptID())) {
					baseDept = startDept;
					break;
				}
			}
		}
		baseDept = getNotHiddenDeptInPath(baseDept);

		List<DirGroup> hirList = null;
		if (OrgConfigData.getPropertyForBoolean("directory.use.dirgroup")) {
			hirList = this.orgContext.getDirGroupList(communityID, "000000000", 1, new DirGroupTypeKey("H"));
		}
		ModelAndView mav = new ModelAndView("orgPopup");
		mav.addObject("baseDept", baseDept);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("hirList", hirList);
		return mav;
	}

	public ModelAndView orgView(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);

		String baseDept = user.getDeptID();

		baseDept = getNotHiddenDeptInPath(baseDept);

		Map cryptedUserColumnsMap = this.orgContext.getCryptedUserColumnsMap();

		ModelAndView mav = new ModelAndView("view/orgView");
		mav.addObject("baseDept", baseDept);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("cryptedUserColumnsMap", cryptedUserColumnsMap);
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		return mav;
	}

	public ModelAndView initOrgTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String baseDept = request.getParameter("baseDept");
		String startDept = request.getParameter("startDept");
		boolean isExpandAll = "true".equals(request.getParameter("isExpandAll"));

		List<Dept> tmpList = this.orgContext.getDeptList(communityID, baseDept, 3, null);
		Dept rootDept = (Dept)tmpList.get(0);
		if ((StringUtils.isNotEmpty(startDept)) && (!"undefined".equalsIgnoreCase(startDept))) {
			rootDept = this.orgContext.getDept(communityID, new DeptIDKey(Arrays.asList(new String[] {startDept})), true);
			if (!contains(tmpList, rootDept)) {
				tmpList = new ArrayList();
				tmpList.add(rootDept);
			}
		}
		List<Dept> pathList = null;
		if (isExpandAll) {
			pathList = this.orgContext.getDeptList(communityID, rootDept.getID(), 2, null);
			pathList.add(rootDept);
			pathList = sortBySeq(pathList);
		} else {
			pathList = new ArrayList();
			pathList.add(rootDept);
			for (Dept tmp : tmpList) {
				pathList.addAll(this.orgContext.getDeptList(communityID, tmp.getID(), 1, null));
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
		String data = buildTreeData(rootDept, pathList, isExpandAll);

		return new ModelAndView("treeData", "data", data);
	}

	private String buildTreeData(Dept dept, List<Dept> pathList, boolean isExpandAll) throws OrgException {
		String children = "";
		for (Dept tmp : pathList) {
			if (tmp.getParentID().equals(dept.getID())) {
				if (StringUtils.isNotEmpty(children)) {
					children = children + ", ";
				}
				children = children + buildTreeData(tmp, pathList, isExpandAll);
			}
		}
		return "{\"key\": \"" + dept.getID() + "\", \"title\": \"" + dept.getName() + "\", \"rbox\": \"\", \"isLazy\": true, \"isFolder\": true" + ", \"expand\": " + isExpandAll
			+ ", \n\"children\": [" + children + "]}";
	}

	private boolean contains(List<Dept> list, Dept dept) {
		for (Dept o : list) {
			if (o.getID().equals(dept.getID())) {
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

			//FIXME: 이거 수정할 것 위에거로 
			@Override
			public int compare(Object o1, Object o2) {
				// TODO Auto-generated method stub
				return 0;
			}
		});
		return list;
	}

	public ModelAndView expandOrgTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String deptID = request.getParameter("deptID");
		String scope = request.getParameter("scope");

		List<Dept> deptList = this.orgContext.getDeptList(communityID, deptID, 1, null);

		ModelAndView mav = new ModelAndView("treeData");
		if ("subtree".equals(scope)) {
			boolean isEnglish = getClientLocale(request).getLanguage().equals("en");
			if (isEnglish) {
				for (Dept dept : deptList) {
					if (StringUtils.isNotEmpty(dept.getNameEng())) {
						dept.setName(dept.getNameEng());
					}
				}
			}
			String data = buildTreeAllData(deptList);
			mav.addObject("data", data);
		} else {
			mav.addObject("deptList", deptList);
		}
		return mav;
	}

	private String buildTreeAllData(List<Dept> deptList) throws OrgException {
		String s = "";
		Dept dept = null;
		int size = deptList.size();
		for (int i = 0; i < size; i++) {
			dept = (Dept)deptList.get(i);
			if (i != 0) {
				s = s + ",";
			}
			s = s + "{\"key\": \"" + dept.getID() + "\", \"title\": \"" + dept.getName() + "\", \"rbox\": \"\", \"isLazy\": true, \"isFolder\": true";
			s = s + ", \"children\": [";

			List<Dept> children = this.orgContext.getDeptList(dept.getID());
			if (children.size() > 0) {
				s = s + buildTreeAllData(children);
			}
			if (i != size - 1) {
				s = s + "]}";
			}
		}
		if (size != 0) {
			s = s + "]}";
		}
		return s;
	}

	public ModelAndView viewDeptSpec(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String deptID = request.getParameter("deptID");

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
		ModelAndView mav = new ModelAndView("view/viewDeptSpec");
		mav.addObject("dept", dept);
		mav.addObject("authes", authes);
		mav.addObject("userAuthes", userAuthes);
		mav.addObject("userMap", userMap);
		mav.addObject("deptMap", deptMap);

		return mav;
	}

	public ModelAndView searchDept(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String startDept = request.getParameter("startDept");
		String searchValue = request.getParameter("searchValue");

		String base = null;
		if ((StringUtils.isNotEmpty(startDept)) && (!"undefined".equalsIgnoreCase(startDept))) {
			base = startDept;
		}
		List<Dept> deptList = null;
		if (StringUtils.isEmpty(searchValue)) {
			deptList = new ArrayList();
		} else {
			deptList = this.orgContext.getDeptList(communityID, base, 2, new NameKey(searchValue));
			for (Dept dept : deptList) {
				String deptFullName = this.orgContext.getDeptFullName(dept.getID(), false);
				deptFullName = deptFullName.indexOf(".") < 0 ? deptFullName : deptFullName.substring(deptFullName.indexOf(".") + 1);

				dept.setName(deptFullName);

				String deptFullNameEng = this.orgContext.getDeptFullName(dept.getID(), true);
				deptFullNameEng = deptFullNameEng.indexOf(".") < 0 ? deptFullNameEng : deptFullNameEng.substring(deptFullNameEng.indexOf(".") + 1);

				dept.setNameEng(deptFullNameEng);
			}
		}
		return new ModelAndView("treeData", "deptList", deptList);
	}

	private SearchKey createUserSearchKey(String searchType, String searchValue) {
		if ((StringUtils.isEmpty(searchType)) || (StringUtils.isEmpty(searchValue))) {
			return null;
		}
		if ("name".equals(searchType)) {
			return new NameKey(searchValue, false);
		}
		if ("pos".equals(searchType)) {
			return new PositionKey(searchValue, false);
		}
		if ("rank".equals(searchType)) {
			return new RankKey(searchValue, false);
		}
		if ("duty".equals(searchType)) {
			return new DutyKey(searchValue, false);
		}
		if ("code".equals(searchType)) {
			return new EmpCodeKey(searchValue, false);
		}
		if ("email".equals(searchType)) {
			return new EmailKey(searchValue, false);
		}
		if ("phone".equals(searchType)) {
			return new PhoneKey(searchValue, false);
		}
		if ("mobile".equals(searchType)) {
			return new MobilePhoneKey(searchValue, false);
		}
		if ("business".equals(searchType)) {
			return new BusinessKey(searchValue, false);
		}
		if ("dept".equals(searchType)) {
			return new DeptNameKey(searchValue, false);
		}
		if ((searchType.indexOf(";") > 0) || (searchType.indexOf(",") > 0)) {
			List<SearchKey> keys = new ArrayList();

			String[] types = StringUtils.split(searchType, ";,");
			for (String type : types) {
				SearchKey key = createUserSearchKey(type.trim(), searchValue);
				if (key != null) {
					keys.add(key);
				}
			}
			switch (keys.size()) {
				case 0:
					return null;
				case 1:
					return (SearchKey)keys.get(0);
			}
			return new MultiORSearchKey(keys);
		}
		return null;
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
			} else if ("email".equals(orderField)) {
				orderByKey = new OrderKey("3", orderDesc);
			} else if ("phone".equals(orderField)) {
				orderByKey = new OrderKey("4", orderDesc);
			} else if ("mobile".equals(orderField)) {
				orderByKey = new OrderKey("5", orderDesc);
			} else if ("deptName".equals(orderField)) {
				orderByKey = new OrderKey("6", orderDesc);
			} else if ("absStartDate".equals(orderField)) {
				orderByKey = new OrderKey("7", orderDesc);
			} else if ("absEndDate".equals(orderField)) {
				orderByKey = new OrderKey("8", orderDesc);
			} else if ("reason".equals(orderField)) {
				orderByKey = new OrderKey("9", orderDesc);
			} else if ("message".equals(orderField)) {
				orderByKey = new OrderKey("10", orderDesc);
			} else if ("loginDate".equals(orderField)) {
				orderByKey = new OrderKey("11", orderDesc);
			}
		}
		return orderByKey;
	}

	public ModelAndView userList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String deptID = request.getParameter("deptID");
		String currentPage = getParameter(request, "currentPage", "1");
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");
		String listType = request.getParameter("listType");

		OrderByKey orderByKey = createOrderByKey(orderField, orderType);
		PaginationParam pParam = new PaginationParam(15, 10);

		Dept dept = null;
		List<User> userList = null;
		if (listType == null) {
			if (orderByKey == null) {
				String listUsersOrder = OrgConfigData.getProperty("directory.listusers.order", "pos");
				orderByKey = new UserOrderKeys(listUsersOrder);
			}
			userList = this.orgContext.getUserList(communityID, deptID, 1, null, orderByKey, null, false, false);
		} else if ("searchList".equals(listType)) {
			String searchType = getParameter(request, "searchType", "name");
			String searchValue = request.getParameter("searchValue");
			SearchKey key = createUserSearchKey(searchType, searchValue);

			pParam.setCurrentPage(Integer.parseInt(currentPage));
			pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 0, key, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, null, 0, key, orderByKey, pParam, false, false);
		} else {
			if (orderByKey == null) {
				String listUsersOrder = OrgConfigData.getProperty("directory.listusers.order", "pos");
				orderByKey = new UserOrderKeys(listUsersOrder);
			}
			dept = this.orgContext.getDept(deptID);

			pParam.setCurrentPage(Integer.parseInt(currentPage));
			pParam.setTotalCount(this.orgContext.getUserListCount(null, deptID, 1, null, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, deptID, 1, null, orderByKey, pParam, false, false);
		}
		String viewName = getParameter(request, "viewName", "userList");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("pParam", pParam);
		mav.addObject("dept", dept);
		mav.addObject("userList", userList);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("dutiesUsed", createOptionMap(request.getParameter("dutiesUsed")));
		mav.addObject("useDetailUser", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.detailuser", true)));
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		return mav;
	}

	public ModelAndView viewUserSpec(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		String userID = request.getParameter("userID");

		User user = null;
		try {
			user = this.orgContext.getUser(communityID, new UserIDKey(Arrays.asList(new String[] {userID})), true);
		} catch (OrgException e) {
			if ((1204 == e.getErrorCode()) && (StringUtils.isNotEmpty(userID))) {
				user = this.orgContext.getUser(communityID, new EmpCodeKey(userID));
			} else {
				throw e;
			}
		}
		String viewName = getParameter(request, "viewName", "view/viewUserSpec");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("user", user);
		return mav;
	}

	public ModelAndView searchUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchType = getParameter(request, "searchType", "name");
		String listType = request.getParameter("listType");
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");

		OrderByKey orderByKey = createOrderByKey(orderField, orderType);
		PaginationParam pParam = new PaginationParam(15, 10);

		List<User> userList = null;
		if ("role".equals(searchType)) {
			String base = request.getParameter("deptID");
			String role = request.getParameter("searchRole");
			boolean subdept = "true".equals(request.getParameter("role_subdept"));
			userList = this.orgContext.getUserListInRole(communityID, base, role, subdept);
		} else {
			String startDept = request.getParameter("startDept");
			String searchValue = request.getParameter("searchValue");

			String base = null;
			if ((StringUtils.isNotEmpty(startDept)) && (!"undefined".equalsIgnoreCase(startDept))) {
				base = startDept;
			}
			SearchKey key = createUserSearchKey(searchType, searchValue);
			if (orderByKey == null) {
				String listUsersOrder = OrgConfigData.getProperty("directory.listusers.order", "pos");
				orderByKey = new UserOrderKeys(listUsersOrder);
			}
			if ((key == null) || (StringUtils.isEmpty(searchValue))) {
				userList = new ArrayList();
			} else if ("searchList".equals(listType)) {
				pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 0, key, pParam, false, false));
				userList = this.orgContext.getUserList(communityID, base, 0, key, orderByKey, pParam, false, false);
			} else {
				userList = this.orgContext.getUserList(communityID, base, 2, key, orderByKey);
			}
		}
		String viewName = getParameter(request, "viewName", "userList");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("pParam", pParam);
		mav.addObject("userList", userList);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("dutiesUsed", createOptionMap(request.getParameter("dutiesUsed")));
		mav.addObject("useDetailUser", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.detailuser", true)));
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		mav.addObject("useRank", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.rank")));
		mav.addObject("useDuty", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.duty")));
		return mav;
	}

	public ModelAndView absentUserList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String currentPage = getParameter(request, "currentPage", "1");
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");
		String listType = request.getParameter("listType");
		String deptID = request.getParameter("deptID");

		OrderByKey orderByKey = createOrderByKey(orderField, orderType);
		PaginationParam pParam = new PaginationParam(15, 10);

		Dept dept = null;
		List userList = null;
		if ("searchList".equals(listType)) {
			String searchType = getParameter(request, "searchType", "name");
			String searchValue = request.getParameter("searchValue");
			SearchKey key = createUserSearchKey(searchType, searchValue);

			MultiSearchKey multiSearchKey = new MultiSearchKey();
			multiSearchKey.add(new FlagKey(65536));
			multiSearchKey.add(key);

			pParam.setDisplayType("1");
			pParam.setCurrentPage(Integer.parseInt(currentPage));
			pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 0, multiSearchKey, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, null, 0, multiSearchKey, orderByKey, pParam, false, false);
		} else {
			dept = this.orgContext.getDept(deptID);

			pParam.setDisplayType("1");
			pParam.setCurrentPage(Integer.parseInt(currentPage));
			pParam.setTotalCount(this.orgContext.getUserList(null, deptID, 2, new FlagKey(65536)).size());
			userList = this.orgContext.getUserList(null, deptID, 2, new FlagKey(65536), orderByKey, pParam, false, false);
		}
		String viewName = getParameter(request, "viewName", "view/listAbsentUsers");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("dept", dept);
		mav.addObject("pParam", pParam);
		mav.addObject("userList", userList);
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView searchAbsentUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchType = getParameter(request, "searchType", "name");
		String searchValue = request.getParameter("searchValue");
		String listType = request.getParameter("listType");

		SearchKey key = createUserSearchKey(searchType, searchValue);

		List userList = null;

		PaginationParam pParam = new PaginationParam(15, 10);
		if ((key == null) || (StringUtils.isEmpty(searchValue))) {
			userList = new ArrayList();
		} else {
			MultiSearchKey multiSearchKey = new MultiSearchKey();
			multiSearchKey.add(new FlagKey(65536));
			multiSearchKey.add(key);

			pParam.setDisplayType("1");
			pParam.setOrderField("12");
			pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 0, multiSearchKey, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, null, 0, multiSearchKey, null, pParam, false, false);
		}
		String viewName = getParameter(request, "viewName", "view/listAbsentUsers");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("pParam", pParam);
		mav.addObject("userList", userList);
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView loginUserList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String currentPage = getParameter(request, "currentPage", "1");
		String orderField = request.getParameter("orderField");
		String orderType = request.getParameter("orderType");
		String listType = request.getParameter("listType");
		String deptID = request.getParameter("deptID");
		String app = request.getParameter("app");
		if (StringUtils.isEmpty(app)) {
			app = "DEFAULT";
		}
		OrderByKey orderByKey = createOrderByKey(orderField, orderType);
		PaginationParam pParam = new PaginationParam(15, 10);

		Dept dept = null;
		List userList = null;
		if ("searchList".equals(listType)) {
			String searchType = getParameter(request, "searchType", "name");
			String searchValue = request.getParameter("searchValue");

			SearchKey key = createUserSearchKey(searchType, searchValue);

			MultiSearchKey multiSearchKey = new MultiSearchKey();
			multiSearchKey.add(new LoginApp(app));
			multiSearchKey.add(key);

			pParam.setDisplayType("2");
			pParam.setCurrentPage(Integer.parseInt(currentPage));
			pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 0, multiSearchKey, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, null, 0, multiSearchKey, orderByKey, pParam, false, false);
		} else {
			dept = this.orgContext.getDept(deptID);

			pParam.setDisplayType("2");
			pParam.setCurrentPage(Integer.parseInt(currentPage));
			pParam.setTotalCount(this.orgContext.getUserListCount(null, deptID, 1, new LoginApp(app), pParam, false, false));
			userList = this.orgContext.getUserList(null, deptID, 1, new LoginApp(app), orderByKey, pParam, false, false);
		}
		String viewName = getParameter(request, "viewName", "view/listLoginUsers");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("dept", dept);
		mav.addObject("pParam", pParam);
		mav.addObject("userList", userList);
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView searchLoginUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchType = getParameter(request, "searchType", "name");
		String searchValue = request.getParameter("searchValue");
		String app = request.getParameter("app");
		if (StringUtils.isEmpty(app)) {
			app = "DEFAULT";
		}
		SearchKey key = createUserSearchKey(searchType, searchValue);
		PaginationParam pParam = new PaginationParam(15, 10);

		List userList = null;
		if ((key == null) || (StringUtils.isEmpty(searchValue))) {
			userList = new ArrayList();
		} else {
			MultiSearchKey multiSearchKey = new MultiSearchKey();
			multiSearchKey.add(new LoginApp(app));
			multiSearchKey.add(key);

			pParam.setDisplayType("2");
			pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 0, multiSearchKey, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, null, 0, multiSearchKey, null, pParam, false, false);
		}
		String viewName = getParameter(request, "viewName", "view/listLoginUsers");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("pParam", pParam);
		mav.addObject("userList", userList);
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView contactTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);
		List<ContactGroup> contactList = this.orgContext.getContactGroupList(uid);
		List<ContactGroup> sharedContactList = this.orgContext.getContactGroupList("000000001");

		ModelAndView mv = new ModelAndView("treeData");
		mv.addObject("user", user);
		mv.addObject("contactList", contactList);
		mv.addObject("sharedContactList", sharedContactList);
		return mv;
	}

	public ModelAndView contactList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String base = request.getParameter("base");
		String scope = request.getParameter("scope");

		List<Contact> contactList = this.orgContext.getContactList(base, Integer.parseInt(scope));

		return new ModelAndView("contactList", "contactList", contactList);
	}

	private boolean hasUnresolved(List<List<ResolveResult>> list) {
		for (List<ResolveResult> l : list) {
			for (Iterator i$ = l.iterator(); i$.hasNext();) {
				ResolveResult o = (ResolveResult)i$.next();
				if ((o.isResolved()) || (o.isHomonym())) {
				}
			}
		}
		return false;
	}

	private boolean hasHomonym(List<List<ResolveResult>> list) {
		for (List<ResolveResult> l : list) {
			for (ResolveResult o : l) {
				if (o.isHomonym()) {
					return true;
				}
			}
		}
		return false;
	}

	public ModelAndView resolveItems(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String startDept = request.getParameter("startDept");
		String to = request.getParameter("to");
		String cc = request.getParameter("cc");
		String bcc = request.getParameter("bcc");
		String hwto = request.getParameter("hwto");
		String hwcc = request.getParameter("hwcc");
		String hwbcc = request.getParameter("hwbcc");

		List<List<ResolveResult>> list = new ArrayList();

		String base = null;
		if ((StringUtils.isNotEmpty(startDept)) && (!"undefined".equalsIgnoreCase(startDept))) {
			base = startDept;
		}
		NameParser nameParser = new NameParser(base);
		list.add(nameParser.resolve(communityID, hwto, to, uid));
		list.add(nameParser.resolve(communityID, hwcc, cc, uid));
		list.add(nameParser.resolve(communityID, hwbcc, bcc, uid));

		String viewName = null;
		ModelAndView mav = new ModelAndView();
		if (hasUnresolved(list)) {
			viewName = "unresolved";
		} else if (hasHomonym(list)) {
			viewName = "homonym";
		} else {
			ResolveResult firstResult = null;
			for (int i = 0; i < list.size(); i++) {
				List<ResolveResult> results = (List)list.get(i);
				int j = 0;
				if (j < results.size()) {
					firstResult = (ResolveResult)results.get(i);
				}
				if (firstResult != null) {
					break;
				}
			}
			if (firstResult != null) {
			}
			viewName = "resolved";
		}
		mav.setViewName(viewName);
		mav.addObject("list", list);
		return mav;
	}

	public ModelAndView groupTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String groupType = request.getParameter("groupType");

		ModelAndView mv = new ModelAndView("treeData");
		if (StringUtils.isEmpty(groupType)) {
			return mv;
		}
		if (groupType.equals("M")) {
			List<Group> groupList = this.orgContext.getGroupList("M", uid);
			List<Group> sharedGroupList = this.orgContext.getGroupList("P", uid);

			mv.addObject("groupList", groupList);
			mv.addObject("sharedGroupList", sharedGroupList);
		} else {
			List<Group> groupList = this.orgContext.getGroupList(groupType, uid);
			mv.addObject("groupList", groupList);
		}
		return mv;
	}

	public ModelAndView memberList(HttpServletRequest request, HttpServletResponse response) throws OrgException {
		String base = request.getParameter("base");
		ModelAndView mv = new ModelAndView("memberList");
		List<Member> members = this.orgContext.getMemberList(base);
		filterMemberList(members, mv);
		return mv;
	}

	public ModelAndView memberJSON(HttpServletRequest request, HttpServletResponse response) throws OrgException {
		String base = request.getParameter("base");
		ModelAndView mv = new ModelAndView("memberJSON");
		List<Member> members = this.orgContext.getMemberList(base);
		filterMemberList(members, mv);
		return mv;
	}

	private void filterMemberList(List<Member> members, ModelAndView mav) {
		List<Member> emailList = new ArrayList();
		List<String> userIDList = new ArrayList();
		List<String> deptIDList = new ArrayList();
		List<String> subDeptIDList = new ArrayList();
		for (Member member : members) {
			char type = member.getType();
			if (type == '0') {
				userIDList.add(member.getID());
			} else if (type == '2') {
				emailList.add(member);
			} else if (type == '1') {
				deptIDList.add(member.getID());
			} else if (type == '5') {
				subDeptIDList.add(member.getID());
			}
		}
		List<User> userList = this.orgContext.getUserList(userIDList);
		List<Dept> deptList = this.orgContext.getDeptList(deptIDList);
		List<Dept> subDeptList = this.orgContext.getDeptList(subDeptIDList);

		List<User> sortedUserList = new ArrayList();
		List<Dept> sortedDeptList = new ArrayList();
		List<Dept> sortedSubDeptList = new ArrayList();
		
		String id = "";
		for (Iterator i$ = userIDList.iterator(); i$.hasNext();) {
			id = (String)i$.next();
			for (User user : userList) {
				if (user.getID().equals(id)) {
					sortedUserList.add(user);
					break;
				}
			}
		}
		for (Iterator i$ = deptIDList.iterator(); i$.hasNext();) {
			id = (String)i$.next();
			for (Dept dept : deptList) {
				if (dept.getID().equals(id)) {
					sortedDeptList.add(dept);
					break;
				}
			}
		}
		//String id;
		for (Iterator i$ = subDeptIDList.iterator(); i$.hasNext();) {
			id = (String)i$.next();
			for (Dept dept : subDeptList) {
				if (dept.getID().equals(id)) {
					sortedSubDeptList.add(dept);
					break;
				}
			}
		}
		//String id;
		mav.addObject("userList", sortedUserList);
		mav.addObject("emailList", emailList);
		mav.addObject("deptList", sortedDeptList);
		mav.addObject("subDeptList", sortedSubDeptList);
	}

	public ModelAndView positionList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();

		List<Position> positionList = this.orgContext.getPositionList(communityID);

		return new ModelAndView("positionList", "positionList", positionList);
	}

	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Authentication authentication = (Authentication)request.getSession().getAttribute("DIRECTORY_AUTHENTICATION");
		String userKey = request.getParameter("K");
		if (authentication != null) {
			this.orgContext.logout(authentication.getUserKey());
		}
		if (StringUtils.isNotEmpty(userKey)) {
			this.orgContext.logout(userKey);
		}
		request.getSession().setAttribute("FRAMEWORK_DIRECTORY_LOCALE", null);

		request.getSession().setAttribute("DIRECTORY_AUTHENTICATION", null);
		request.setAttribute("DIRECTORY_AUTHENTICATION", null);
		Cookie cookie = new Cookie("key", null);
		cookie.setPath("/");
		cookie.setMaxAge(0);
		response.addCookie(cookie);

		return new ModelAndView("login/loginErrorData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView login(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = request.getParameter("communityID");
		String loginType = request.getParameter("loginType");
		String loginName = request.getParameter("loginName");
		String password = request.getParameter("password");
		String app = request.getParameter("app");
		String cryptedParam = request.getParameter("cryptedParam");
		if (StringUtils.isEmpty(app)) {
			app = "DEFAULT";
		}
		boolean checkDupLogin = "1".equals(request.getParameter("checkDupLogin"));
		String locale = request.getParameter("FRAMEWORK_DIRECTORY_LOCALE");
		try {
			this.logger.debug("login cryptedParam[" + cryptedParam + "]");
			if ((StringUtils.isNotEmpty(cryptedParam)) && (cryptedParam.indexOf("password") > -1)) {
				password = RsaKeyGen.decryptParameter(request, "password");
			}
			if ((StringUtils.isNotEmpty(cryptedParam)) && (cryptedParam.indexOf("loginName") > -1)) {
				loginName = RsaKeyGen.decryptParameter(request, "loginName");
			}
			request.getSession().setAttribute("FRAMEWORK_DIRECTORY_LOCALE", locale);

			Authentication authentication = this.orgContext.login(communityID, loginType, loginName, password, request.getRemoteAddr(), app, checkDupLogin);
			if (!"000000001".equals(authentication.getUserID())) {
				try {
					LicenseManager.isValidLicenseForLogin(authentication.getCommunityID());
				} catch (LicenseException e) {
					this.logger.error(e.getMessage(), e);

					this.orgContext.logout(authentication.getUserKey());
					throw new OrgException(3000, e.getMessage());
				}
			}
			request.getSession().setAttribute("DIRECTORY_AUTHENTICATION", authentication);
			request.setAttribute("DIRECTORY_AUTHENTICATION", authentication);
			Cookie cookie = new Cookie("key", authentication.getUserKey());
			cookie.setPath("/");
			response.addCookie(cookie);

			User user = this.orgContext.getUser(authentication.getUserID());

			ModelAndView mv = new ModelAndView("/login/loginData", "errorCode", Integer.valueOf(0));
			mv.addObject("authentication", authentication);
			mv.addObject("loginName", loginName);
			mv.addObject("loginType", loginType);
			mv.addObject("isOtherOffice", Boolean.valueOf(user.isOtherOffice()));
			if (user.isOtherOffice()) {
				List otherOffices = this.orgContext.getOtherOfficeList(user.getID());
				if (otherOffices != null) {
					List<Map> users = new ArrayList();
					Map userMap = new HashMap();
					userMap.put("ID", user.getID());
					userMap.put("name", user.getName());
					userMap.put("nameEng", user.getNameEng());
					userMap.put("deptName", user.getDeptName());
					userMap.put("deptNameEng", user.getDeptNameEng());
					users.add(userMap);
					for (int i = 0; i < otherOffices.size(); i++) {
						User otherOffice = (User)otherOffices.get(i);
						userMap = new HashMap();
						userMap.put("ID", otherOffice.getID());
						userMap.put("name", otherOffice.getName());
						userMap.put("nameEng", otherOffice.getNameEng());
						userMap.put("deptName", otherOffice.getDeptName());
						userMap.put("deptNameEng", otherOffice.getDeptNameEng());
						users.add(userMap);
					}
					mv.addObject("users", users);
				}
			}
			if (OrgConfigData.getPropertyForInt("directory.password.changedays") > 0) {
				int days = OrgConfigData.getPropertyForInt("directory.password.changedays");
				if ((user != null) && (user.getPasswordDate() != null)) {
					Date passwordDate = user.getPasswordDate();

					Calendar passwordDays = Calendar.getInstance();
					passwordDays.setTime(passwordDate);
					passwordDays.add(5, days);
					if (Calendar.getInstance().after(passwordDays)) {
						mv.addObject("changePassword", Boolean.valueOf(true));
					}
				}
			}
			return mv;
		} catch (DuplicatedNameException e) {
			ModelAndView mv = new ModelAndView("/login/homonymsData");
			mv.addObject("errorCode", Integer.valueOf(e.getErrorCode()));
			mv.addObject("errorMessage", StringEscapeUtils.escapeJava(e.getMessage()));
			mv.addObject("homonyms", e.getHomonyms());
			return mv;
		} catch (OrgException e) {
			ModelAndView mv = new ModelAndView("/login/loginErrorData");
			mv.addObject("errorCode", Integer.valueOf(e.getErrorCode()));
			mv.addObject("errorMessage", StringEscapeUtils.escapeJava(e.getMessage()));
			if ((e instanceof DuplicatedLoginException)) {
				mv.addObject("dupLoginClientName", StringEscapeUtils.escapeJava(((DuplicatedLoginException)e).getClientName()));
			}
			return mv;
		}
	}

	public ModelAndView loginByCert(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String serverIP = request.getRemoteAddr();
		String certKey = request.getParameter("certKey");
		String clientName = request.getParameter("clientName");

		String communityID = request.getParameter("communityID");
		String loginType = request.getParameter("loginType");
		String loginName = request.getParameter("loginName");

		String app = request.getParameter("app");
		if (StringUtils.isEmpty(app)) {
			app = "DEFAULT";
		}
		boolean checkDupLogin = "1".equals(request.getParameter("checkDupLogin"));
		try {
			Authentication authentication = this.orgContext.loginByCert(serverIP, certKey, communityID, loginType, loginName, clientName, app, checkDupLogin);
			if (!"000000001".equals(authentication.getUserID())) {
				try {
					LicenseManager.isValidLicenseForLogin(authentication.getCommunityID());
				} catch (LicenseException e) {
					this.logger.error(e.getMessage(), e);

					this.orgContext.logout(authentication.getUserKey());
					throw new OrgException(3000, e.getMessage());
				}
			}
			ModelAndView mv = new ModelAndView("/login/loginData", "errorCode", Integer.valueOf(0));
			mv.addObject("authentication", authentication);
			mv.addObject("loginName", loginName);
			mv.addObject("loginType", loginType);
			return mv;
		} catch (OrgException e) {
			ModelAndView mv = new ModelAndView("/login/loginErrorData");
			mv.addObject("errorCode", Integer.valueOf(e.getErrorCode()));
			mv.addObject("errorMessage", StringEscapeUtils.escapeJava(e.getMessage()));
			if ((e instanceof DuplicatedLoginException)) {
				mv.addObject("dupLoginClientName", StringEscapeUtils.escapeJava(((DuplicatedLoginException)e).getClientName()));
			}
			return mv;
		}
	}

	public ModelAndView groupMng(HttpServletRequest request, HttpServletResponse response) throws Exception {
		return new ModelAndView("env/groupMng");
	}

	public ModelAndView listGroups(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String application = request.getParameter("application");

		List<GroupApp> groupAppList = this.orgContext.getGroupAppList();
		if ((StringUtils.isEmpty(application)) && (groupAppList.size() > 0)) {
			application = ((GroupApp)groupAppList.get(0)).getApplication();
		}
		List<Group> groupList = this.orgContext.getGroupList(application, uid);

		ModelAndView mav = new ModelAndView("env/listGroups");
		mav.addObject("groupAppList", groupAppList);
		mav.addObject("groupList", groupList);
		mav.addObject("application", application);
		return mav;
	}

	public ModelAndView viewAddGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String application = request.getParameter("application");

		GroupApp groupApp = this.orgContext.getGroupApp(application);

		ModelAndView mav = new ModelAndView("env/addGroup");
		mav.addObject("groupApp", groupApp);
		return mav;
	}

	public ModelAndView addGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String application = request.getParameter("application");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String memberIDs = request.getParameter("memberIDs");

		Group group = new GroupImpl();
		group.setApplication(application);
		group.setName(groupName);
		group.setDescription(description);

		List<Member> members = new ArrayList();
		String[] ids = StringUtils.split(memberIDs, ";,");
		for (String id : ids) {
			Member member = new MemberImpl();
			member.setID(getMemberID(id));
			member.setType(getMemberType(id));

			members.add(member);
		}
		this.orgContext.addGroup(group, members, uid);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	private String getMemberID(String id) {
		if (id.startsWith("$+")) {
			return id.substring("$+".length());
		}
		if (id.startsWith("$")) {
			return id.substring("$".length());
		}
		return id;
	}

	private char getMemberType(String id) {
		if (id.startsWith("$+")) {
			return '5';
		}
		if (id.startsWith("$")) {
			return '1';
		}
		return '0';
	}

	public ModelAndView viewUpdateGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String groupID = request.getParameter("groupID");

		Group group = this.orgContext.getGroup(groupID);
		GroupApp groupApp = this.orgContext.getGroupApp(group.getApplication());
		List<Member> memberList = this.orgContext.getMemberList(group.getID());
		for (Member member : memberList) {
			String prefix = "";
			if ('5' == member.getType()) {
				prefix = "$+";
			} else if ('1' == member.getType()) {
				prefix = "$";
			}
			member.setID(prefix + member.getID());
			member.setName(prefix + member.getName());
		}
		ModelAndView mav = new ModelAndView("env/updateGroup");
		mav.addObject("group", group);
		mav.addObject("groupApp", groupApp);
		mav.addObject("memberList", memberList);
		return mav;
	}

	public ModelAndView updateGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String groupID = request.getParameter("groupID");
		String groupName = request.getParameter("groupName");
		String description = request.getParameter("description");
		String memberIDs = request.getParameter("memberIDs");

		Group group = this.orgContext.getGroup(groupID);
		group.setName(groupName);
		group.setDescription(description);

		List<Member> members = new ArrayList();
		if (memberIDs != null) {
			String[] ids = StringUtils.split(memberIDs, ";,");
			for (String id : ids) {
				Member member = new MemberImpl();
				member.setID(getMemberID(id));
				member.setType(getMemberType(id));

				members.add(member);
			}
		}
		this.orgContext.updateGroup(group, members, uid);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteGroups(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String groupIDs = request.getParameter("groupIDs");

		List<String> gIDs = new ArrayList();
		String[] ids = StringUtils.split(groupIDs, ";,");
		for (String id : ids) {
			gIDs.add(id);
		}
		this.orgContext.deleteGroups(gIDs);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateUserInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("env/viewUpdateUserInfo");

		mav.addObject("allowPeriodInUsername", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.allow.period.in.username", false)));
		mav.addObject("user", user);
		return mav;
	}

	private String getPictureName(String id, Date date, String extender) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		String dateString = dateFormat.format(date);
		return id + "_" + dateString + "." + extender;
	}

	public ModelAndView updateUserInfo(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = null;
		String phone = null;
		String mobilePhone = null;
		String business = null;
		boolean deletePicture = false;
		String picturePath = null;
		String userNameEng = null;
		String fax = null;
		if ((request instanceof MultipartHttpServletRequest)) {
			MultipartHttpServletRequest multipartRequest = null;

			multipartRequest = (MultipartHttpServletRequest)request;
			uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
			phone = multipartRequest.getParameter("phone");
			mobilePhone = multipartRequest.getParameter("mobilePhone");
			business = multipartRequest.getParameter("business");
			deletePicture = "1".equals(multipartRequest.getParameter("deletePicture"));
			MultipartFile pictureFile = multipartRequest.getFile("pictureFile");
			if ((pictureFile != null) && (!pictureFile.isEmpty())) {
				String extender = FilenameUtils.getExtension(pictureFile.getOriginalFilename());
				if (this.allowFileExt.indexOf("," + extender + ",") < 0) {
					ModelAndView mav = new ModelAndView("env/resultData");
					mav.addObject("errorCode", Integer.valueOf(5010));
					mav.addObject("errorMessage", "The file extension[" + extender + "] does not be allowed.");
					return mav;
				}
				File destFile = this.orgFolder.createFile(uid, getPictureName(uid, new Date(), extender));
				pictureFile.transferTo(destFile);
				picturePath = this.orgFolder.getRelativePath(destFile.getAbsolutePath());
			}
			userNameEng = multipartRequest.getParameter("userNameEng");
			fax = multipartRequest.getParameter("fax");
		} else {
			Map parameterMap = this.fileUpload.fileUpload(request, this.maxUploadSize, this.uploadTempDir);
			uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
			phone = (String)parameterMap.get("phone");
			mobilePhone = (String)parameterMap.get("mobilePhone");
			business = (String)parameterMap.get("business");
			deletePicture = "1".equals((String)parameterMap.get("deletePicture"));
			Object fileVO = parameterMap.get("pictureFile");
			if ((fileVO != null) && ((fileVO instanceof FileVO))) {
				File srcFile = new File(((FileVO)fileVO).getFilePath());
				String extender = FilenameUtils.getExtension(((FileVO)fileVO).getOrgFileName());
				if (this.allowFileExt.indexOf("," + extender + ",") < 0) {
					ModelAndView mav = new ModelAndView("env/resultData");
					mav.addObject("errorCode", Integer.valueOf(5010));
					mav.addObject("errorMessage", "The file extension[" + extender + "] does not be allowed.");
					return mav;
				}
				File destFile = this.orgFolder.createFile(uid, getPictureName(uid, new Date(), extender));
				this.fileUpload.copy(srcFile, destFile);
				srcFile.delete();
				picturePath = this.orgFolder.getRelativePath(destFile.getAbsolutePath());
			}
			userNameEng = (String)parameterMap.get("userNameEng");
			fax = (String)parameterMap.get("fax");
		}
		User user = this.orgContext.getUser(uid);
		user.setPhone(phone);
		user.setMobilePhone(mobilePhone);
		user.setBusiness(business);
		if ((deletePicture) || (picturePath != null)) {
			if (user.getPicturePath() != null) {
				File file = new File(this.orgFolder.getPath(user.getPicturePath()));
				if ((file.exists()) && (file.isFile())) {
					file.delete();
				}
			}
			user.setPicturePath(picturePath);
		}
		user.setNameEng(userNameEng);
		user.setFax(fax);

		this.orgContext.updateUserInfo(user);

		ModelAndView mv = new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
		mv.addObject("user", user);

		return mv;
	}

	public ModelAndView viewChangePassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("env/viewChangePassword");
		mav.addObject("user", user);
		return mav;
	}

	public ModelAndView changePassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
			User user = this.orgContext.getUser(uid);
			String oldPassword = request.getParameter("oldPassword");
			String newPassword = request.getParameter("newPassword");
			if (this.passwordRules != null) {
				this.passwordRules.validate(newPassword, user);
			}
			this.orgContext.changePassword(uid, oldPassword, newPassword);

			return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
		} catch (OrgPasswordRulesException e) {
			if (this.logger.isDebugEnabled()) {
				this.logger.debug(e.getMessage(), e);
			}
			ModelAndView mv = new ModelAndView("env/resultData");
			mv.addObject("errorCode", Integer.valueOf(e.getErrorCode()));
			mv.addObject("length", Integer.valueOf(e.getLength()));
			mv.addObject("property", e.getProperty());
			mv.addObject("rule", e.getRule());
			return mv;
		} catch (OrgException e) {
			if (this.logger.isDebugEnabled()) {
				this.logger.debug(e.getMessage(), e);
			}
			return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(e.getErrorCode()));
		} catch (Exception e) {
			if (this.logger.isDebugEnabled()) {
				this.logger.debug(e.getMessage(), e);
			}
		}
		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(3000));
	}

	public ModelAndView viewSetAbsence(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("env/setAbsence");
		mav.addObject("user", user);
		mav.addObject("isAdmin", Boolean.valueOf(isAuthorization(uid, null, "ADM")));
		mav.addObject("isDeptAdmin", Boolean.valueOf(isAuthorization(uid, null, "D5")));
		return mav;
	}

	public ModelAndView checkSetAbsence(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = getParameter(request, "userID", uid);

		User user = this.orgContext.getUser(userID);
		if ((!uid.equals(user.getID())) && (!isAuthorization(uid, user.getDeptID(), "ADM;D5"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the checkSetAbsence");
		}
		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView listAbsences(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = getParameter(request, "userID", uid);

		User user = this.orgContext.getUser(userID);
		if ((!uid.equals(user.getID())) && (!isAuthorization(uid, user.getDeptID(), "ADM;D5"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the listAbsences");
		}
		List<Absence> absenceList = this.orgContext.getAbsenceList(user.getID());

		ModelAndView mav = new ModelAndView("env/listAbsences");
		mav.addObject("absenceList", absenceList);

		mav.addObject("current", new Date());
		return mav;
	}

	public ModelAndView viewUpdateAbsence(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = getParameter(request, "userID", uid);
		String absenceID = request.getParameter("absenceID");
		boolean isCopy = "1".equals(request.getParameter("isCopy"));

		User user = this.orgContext.getUser(userID);
		if ((!uid.equals(user.getID())) && (!isAuthorization(uid, user.getDeptID(), "ADM;D5"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the viewUpdateAbsence");
		}
		Absence absence = new AbsenceImpl();
		if (StringUtils.isNotEmpty(absenceID)) {
			absence = this.orgContext.getAbsenceByAbsenceID(absenceID);
		}
		if ((absence.getAbsSDate() == null) || (isCopy)) {
			absenceID = null;

			absence.setAbsSDate(new Date());
			Calendar endDate = Calendar.getInstance();
			endDate.add(5, 7);
			absence.setAbsEDate(endDate.getTime());
		}
		String altMailUserName = null;
		if (StringUtils.isNotEmpty(absence.getAltMailUserID())) {
			boolean isEnglish = getClientLocale(request).getLanguage().equals("en");
			try {
				User altUser = this.orgContext.getUser(absence.getAltMailUserID());
				altMailUserName = this.orgContext.getUserUniqueName(altUser, isEnglish);
			} catch (OrgException e) {
				if (1204 == e.getErrorCode()) {
					this.logger.error(e.getMessage(), e);
					absence.setAltMailUserID(null);
				} else {
					throw e;
				}
			}
		}
		ModelAndView mav = new ModelAndView("env/updateAbsence");
		mav.addObject("absenceID", absenceID);
		mav.addObject("absence", absence);
		mav.addObject("notSancs", this.orgContext.getNotSancList());
		mav.addObject("altMailUserName", altMailUserName);
		mav.addObject("useMail", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.mail")));
		mav.addObject("isReadOnly", new Boolean(absence.getAbsEDate().getTime() < new Date().getTime()));
		return mav;
	}

	public ModelAndView updateAbsence(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = getParameter(request, "userID", uid);
		String absenceID = request.getParameter("absenceID");

		User user = this.orgContext.getUser(userID);
		if ((!uid.equals(user.getID())) && (!isAuthorization(uid, user.getDeptID(), "ADM;D5"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the setAbsence");
		}
		String absSDate = request.getParameter("absSDate");
		String absEDate = request.getParameter("absEDate");
		String notSancID = request.getParameter("notSancID");
		String absMsg = request.getParameter("absMsg");

		String altMailUserID = request.getParameter("altMailUserID");
		String msgRecipientID = request.getParameter("msgRecipientID");
		String msgRecipientName = request.getParameter("msgRecipientName");
		String msgRecipientType = request.getParameter("msgRecipientType");

		Absence oldObj = null;
		if (StringUtils.isNotEmpty(absenceID)) {
			oldObj = this.orgContext.getAbsenceByAbsenceID(absenceID);
		}
		Absence absence = new AbsenceImpl();
		absence.setUserID(user.getID());
		absence.setAbsSDate(new SimpleDateFormat("yyyy.MM.dd HH:mm:ss").parse(absSDate));
		absence.setAbsEDate(new SimpleDateFormat("yyyy.MM.dd HH:mm:ss").parse(absEDate));
		absence.setNotSancID(notSancID);
		absence.setAbsMsg(absMsg);

		absence.setAltMailUserID(altMailUserID);
		absence.setMsgRecipientID(msgRecipientID);
		absence.setMsgRecipientName(msgRecipientName);
		absence.setMsgRecipientType(msgRecipientType);

		this.orgContext.setAbsence(oldObj, absence);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView deleteAbsences(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String userID = getParameter(request, "userID", uid);
		String absenceIDs = request.getParameter("absenceIDs");

		User user = this.orgContext.getUser(userID);
		if ((!uid.equals(user.getID())) && (!isAuthorization(uid, user.getDeptID(), "ADM;D5"))) {
			throw new NoAuthorizationException(5006, "don't have the authority for the deleteAbsences");
		}
		if (StringUtils.isNotEmpty(absenceIDs)) {
			String[] ids = StringUtils.split(absenceIDs, ";,");
			for (String absenceID : ids) {
				Absence absence = this.orgContext.getAbsenceByAbsenceID(absenceID);
				this.orgContext.deleteAbsence(absence);
			}
		}
		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateNotify(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("env/updateNotify");
		mav.addObject("user", user);
		mav.addObject("useBBS", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.bbs")));
		mav.addObject("useMail", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.mail")));
		return mav;
	}

	public ModelAndView updateNotify(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String useNotify = request.getParameter("useNotify");
		String useBBoardNotify = request.getParameter("useBBoardNotify");
		String useMailNotify = request.getParameter("useMailNotify");

		User user = this.orgContext.getUser(uid);
		user.setUseNotify("1".equals(useNotify));
		user.setUseBBoardNotify("1".equals(useBBoardNotify));
		user.setUseMailNotify("1".equals(useMailNotify));

		this.orgContext.updateNotifyFlag(user);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewUpdateLinkageAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		List linkageAccountList = this.orgContext.getLinkageAccountList(uid);
		String linkageNames = OrgConfigData.getProperty("directory.linkageaccount.linkageNames", "google");
		List<String> linkageNameList = new ArrayList();
		StringTokenizer stringTokenizer = new StringTokenizer(linkageNames, ",;");
		while (stringTokenizer.hasMoreTokens()) {
			linkageNameList.add(stringTokenizer.nextToken());
		}
		ModelAndView mav = new ModelAndView("env/updateLinkageAccount");
		mav.addObject("linkageAccountList", linkageAccountList);
		mav.addObject("linkageAccountLinkageNames", linkageNames);
		mav.addObject("linkageAccountLinkageNameList", linkageNameList);
		return mav;
	}

	public ModelAndView updateLinkageAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String accountName = request.getParameter("accountName");
		String accountPassword = request.getParameter("accountPassword");
		String linkageName = request.getParameter("linkageName");

		LinkageAccount linkageAccount = new LinkageAccountImpl();
		linkageAccount.setUserID(uid);
		linkageAccount.setAccountName(accountName);
		linkageAccount.setAccountPassword(accountPassword);
		linkageAccount.setLinkageName(linkageName);

		this.orgContext.updateLinkageAccount(linkageAccount);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView getLinkageAccount(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String linkageName = request.getParameter("linkageName");

		LinkageAccount linkageAccount = this.orgContext.getLinkageAccount(uid, linkageName);

		return new ModelAndView("env/linkageAccount", "linkageAccount", linkageAccount);
	}

	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		User user = this.orgContext.getUser(uid);
		boolean isAdmin = isAuthorization(uid, null, "ADM");
		boolean isDeptAdmin = isAuthorization(uid, null, "D5");
		ModelAndView mav = new ModelAndView("main");
		mav.addObject("user", user);
		mav.addObject("isAdmin", Boolean.valueOf(isAdmin));
		mav.addObject("isDeptAdmin", Boolean.valueOf(isDeptAdmin));
		mav.addObject("useDirGroup", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.dirgroup")));
		if (user.isOtherOffice()) {
			List otherOffices = this.orgContext.getOtherOfficeList(user.getID());
			mav.addObject("otherOffices", otherOffices);
		}
		if (user.isOtherOffice()) {
			List otherOffices = this.orgContext.getOtherOfficeList(user.getID());
			if (otherOffices != null) {
				otherOffices.add(0, user);

				mav.addObject("otherOffices", otherOffices);
			}
		}
		return mav;
	}

	public ModelAndView orgEnv(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		User user = this.orgContext.getUser(uid);
		boolean isAdmin = isAuthorization(uid, null, "ADM");
		boolean isDeptAdmin = isAuthorization(uid, null, "D5");
		ModelAndView mav = new ModelAndView("env/orgEnv");
		mav.addObject("user", user);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("isAdmin", Boolean.valueOf(isAdmin));
		mav.addObject("isDeptAdmin", Boolean.valueOf(isDeptAdmin));
		mav.addObject("useDirGroup", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.dirgroup")));
		mav.addObject("useNotify", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.notify")));
		mav.addObject("useLinkageAccount", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.linkageaccount")));
		return mav;
	}

	public ModelAndView popupChangePassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		User user = this.orgContext.getUser(uid);

		ModelAndView mav = new ModelAndView("env/popupChangePassword");
		mav.addObject("user", user);
		return mav;
	}

	public ModelAndView loginOtherOffice(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			String communityID = request.getParameter("communityID");
			String userKey = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserKey();
			if (userKey == null) {
				userKey = request.getParameter("K");
			}
			String userID = request.getParameter("userID");
			String clientName = request.getRemoteAddr();

			Authentication authentication = this.orgContext.loginOtherOffice(communityID, userKey, userID, clientName);

			request.getSession().setAttribute("DIRECTORY_AUTHENTICATION", authentication);
			request.setAttribute("DIRECTORY_AUTHENTICATION", authentication);
			Cookie cookie = new Cookie("key", authentication.getUserKey());
			cookie.setPath("/");
			response.addCookie(cookie);

			ModelAndView mv = new ModelAndView("/login/loginData", "errorCode", Integer.valueOf(0));
			mv.addObject("authentication", authentication);
			mv.addObject("loginName", userID);
			mv.addObject("loginType", "userid");
			mv.addObject("bIsAdditionalOfficer", Boolean.valueOf(true));
			return mv;
		} catch (OrgException e) {
			ModelAndView mv = new ModelAndView("/login/loginErrorData");
			mv.addObject("errorCode", Integer.valueOf(e.getErrorCode()));
			mv.addObject("errorMessage", StringEscapeUtils.escapeJava(e.getMessage()));
			if ((e instanceof DuplicatedLoginException)) {
				mv.addObject("dupLoginClientName", StringEscapeUtils.escapeJava(((DuplicatedLoginException)e).getClientName()));
			}
			return mv;
		}
	}

	public ModelAndView initDirGroupTree(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String hirID = request.getParameter("hirID");
		boolean isExpandAll = "true".equals(request.getParameter("isExpandAll"));

		List<DirGroup> rootList = this.orgContext.getDirGroupList(communityID, hirID, 1, null);

		List<DirGroup> pathList = null;
		if (isExpandAll) {
			pathList = this.orgContext.getDirGroupList(communityID, hirID, 2, null);
			pathList = sortBySeqForDirGroup(pathList);
		} else {
			pathList = new ArrayList();
			pathList.addAll(rootList);
			for (DirGroup tmp : rootList) {
				pathList.addAll(this.orgContext.getDirGroupList(communityID, tmp.getID(), 1, null));
			}
		}
		String data = "";
		for (DirGroup root : rootList) {
			if (StringUtils.isNotEmpty(data)) {
				data = data + ", ";
			}
			data = data + buildTreeDataForDirGroup(root, pathList, isExpandAll);
		}
		return new ModelAndView("treeData", "data", data);
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

			//FIXME: 이거 술정할 것 
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
		String groupID = request.getParameter("groupID");

		List<DirGroup> groupList = this.orgContext.getDirGroupList(null, groupID, 1, null);

		return new ModelAndView("treeData", "groupList", groupList);
	}

	public ModelAndView searchDirGroup(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchValue = request.getParameter("searchValue");

		List<DirGroup> groupList = null;
		if (StringUtils.isEmpty(searchValue)) {
			groupList = new ArrayList();
		} else {
			MultiSearchKey multiKey = new MultiSearchKey();
			multiKey.add(new DirGroupTypeKey("G"));
			multiKey.add(new NameKey(searchValue));
			groupList = this.orgContext.getDirGroupList(communityID, null, 0, multiKey);
		}
		return new ModelAndView("treeData", "groupList", groupList);
	}

	public ModelAndView dirGroupMemberList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String groupID = request.getParameter("groupID");

		List<User> memberList = this.orgContext.getDirGroupMemberList(communityID, groupID);

		ModelAndView mav = new ModelAndView("dirGroupMemberList");
		mav.addObject("memberList", memberList);
		mav.addObject("display", createOptionMap(request.getParameter("display")));
		mav.addObject("useDetailUser", Boolean.valueOf(OrgConfigData.getPropertyForBoolean("directory.use.detailuser", true)));
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView viewFavoriteUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		List<User> memberList = this.orgContext.getFavoriteUserList(uid);

		String viewName = getParameter(request, "viewName", "common/quickOrgUser");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("memberList", memberList);
		return mav;
	}

	public ModelAndView viewUpdateFavoriteUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		List<User> memberList = this.orgContext.getFavoriteUserList(uid);

		ModelAndView mav = new ModelAndView("env/updateFavoriteUser");
		mav.addObject("memberList", memberList);
		return mav;
	}

	public ModelAndView updateFavoriteUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String memberIDs = request.getParameter("memberIDs");

		String[] ids = null;
		if (memberIDs != null) {
			ids = StringUtils.split(memberIDs, ";,");
		}
		this.orgContext.updateFavoriteUser(uid, ids);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView viewRecentSearchUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();

		List<User> memberList = this.orgContext.getRecentSearchUserList(uid);

		String viewName = getParameter(request, "viewName", "common/quickOrgUser");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("memberList", memberList);
		return mav;
	}

	public ModelAndView addRecentSearchUser(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String uid = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getUserID();
		String memberID = request.getParameter("memberID");

		this.orgContext.addRecentSearchUser(uid, memberID);

		return new ModelAndView("env/resultData", "errorCode", Integer.valueOf(0));
	}

	public ModelAndView unifiedSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String viewName = getParameter(request, "viewName", "view/unifiedSearch");

		ModelAndView mav = new ModelAndView(viewName);
		return mav;
	}

	public ModelAndView listUnifiedSearchUsers(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
		String searchType = getParameter(request, "searchType", "name");
		String searchValue = request.getParameter("searchValue");
		String listPerPage = getParameter(request, "listPerPage", "15");
		String pageShortCut = getParameter(request, "pageShortCut", "10");
		String currentPage = getParameter(request, "currentPage", "1");

		Map cryptedUserColumnsMap = this.orgContext.getCryptedUserColumnsMap();
		String[] types = StringUtils.split(searchType, ";,");
		searchType = "";
		for (String type : types) {
			if (((!"rank".equals(type)) || (OrgConfigData.getPropertyForBoolean("directory.use.rank"))) && ((!"duty".equals(type)) || (OrgConfigData.getPropertyForBoolean("directory.use.duty")))
				&& ((!"email".equals(type)) || (cryptedUserColumnsMap.containsKey("e_mail"))) && ((!"phone".equals(type)) || (cryptedUserColumnsMap.containsKey("phone")))
				&& ((!"mobile".equals(type)) || (cryptedUserColumnsMap.containsKey("mobile_phone")))) {
				searchType = searchType + type + ";";
			}
		}
		SearchKey key = createUserSearchKey(searchType, searchValue);
		PaginationParam pParam = new PaginationParam(Integer.parseInt(listPerPage), Integer.parseInt(pageShortCut));
		pParam.setCurrentPage(Integer.parseInt(currentPage));

		List<User> userList = null;
		Map<String, Dept> compMap = new HashMap();
		if (key != null) {
			pParam.setTotalCount(this.orgContext.getUserListCount(communityID, null, 2, key, pParam, false, false));
			userList = this.orgContext.getUserList(communityID, null, 2, key, null, pParam, false, false);

			List<String> compIDs = new ArrayList();
			for (User tmp : userList) {
				compIDs.add(tmp.getCompanyID());
			}
			List<Dept> compList = this.orgContext.getDeptList(compIDs);
			for (Dept tmp : compList) {
				if (compMap.get(tmp.getID()) == null) {
					compMap.put(tmp.getID(), tmp);
				}
			}
		}
		String viewName = getParameter(request, "viewName", "view/listUnifiedSearchUsers");

		ModelAndView mav = new ModelAndView(viewName);
		mav.addObject("pParam", pParam);
		mav.addObject("userList", userList);
		mav.addObject("compMap", compMap);
		mav.addObject("detailUserSrc", OrgConfigData.getProperty("directory.detailuser.src"));
		mav.addObject("detailUserCmd", OrgConfigData.getProperty("directory.detailuser.cmd"));
		return mav;
	}

	public ModelAndView generateKeyPairs(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String communityID = request.getParameter("communityID");
		String locale = request.getParameter("FRAMEWORK_DIRECTORY_LOCALE");
		try {
			String[] publicKeyArray = RsaKeyGen.generateKeyPair(request.getSession());
			String publicKey = null;
			String exponent = null;
			if (publicKeyArray != null) {
				publicKey = publicKeyArray[0];
				exponent = publicKeyArray[1];
			} else {
				throw new OrgException(3000, "cannot create the key pairs.");
			}
			this.logger.debug("generateKeyPairs publicKey[" + publicKey + "], exponent[" + exponent + "]");

			ModelAndView mv = new ModelAndView("/login/generateKeyPairs", "errorCode", Integer.valueOf(0));
			mv.addObject("publicKey", publicKey);
			mv.addObject("exponent", exponent);
			return mv;
		} catch (OrgException e) {
			ModelAndView mv = new ModelAndView("/login/loginErrorData");
			mv.addObject("errorCode", Integer.valueOf(e.getErrorCode()));
			mv.addObject("errorMessage", StringEscapeUtils.escapeJava(e.getMessage()));
			return mv;
		}
	}

	private ResourceBundle getResourceBundle(HttpServletRequest request, HttpSession session) {
		Locale locale = null;
		try {
			if (session.getAttribute("FRAMEWORK_DIRECTORY_LOCALE") != null) {
				String value = (String)session.getAttribute("FRAMEWORK_DIRECTORY_LOCALE");
				this.logger.debug("find the 'FRAMEWORK_DIRECTORY_LOCALE' from session [" + value + "].");
				if (StringUtils.isNotEmpty(value)) {
					locale = new Locale(value);
				}
				this.logger.debug("find the locale[" + locale + "].");
			} else {
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
					for (int i = 0; i < cookies.length; i++) {
						String name = cookies[i].getName();
						String value = cookies[i].getValue();
						if (("GWLANG".equals(name)) && (StringUtils.isNotEmpty(value))) {
							locale = new Locale(value);
							this.logger.debug("find the 'GWLANG' from cookie [" + value + "].");
						}
					}
				}
				this.logger.debug("the locale is [" + locale + "].");
			}
		} catch (Exception e) {
			this.logger.warn("fail to get the locale info.", e);
		} finally {
			if (locale == null) {
				locale = Locale.getDefault();
			}
		}
		return ResourceBundle.getBundle("com.hs.framework.directory.resources.messages_directory", locale);
	}

	private File getNoImageFile(HttpServletRequest request, HttpSession session) {
		ResourceBundle resourceBundle = getResourceBundle(request, session);
		String relativePath = null;
		if (resourceBundle != null) {
			relativePath = resourceBundle.getString("/directory/images/NOIMAGE.GIF");
		} else {
			relativePath = "/directory/images/ko/NOIMAGE.GIF";
		}
		return new File(session.getServletContext().getRealPath(relativePath));
	}

	public void viewPicture(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String userID = request.getParameter("userID");
		String empcode = request.getParameter("empcode");
		String communityID = request.getParameter("communityID");
		if (StringUtils.isEmpty(communityID)) {
			if (request.getAttribute("DIRECTORY_AUTHENTICATION") != null) {
				communityID = ((Authentication)request.getAttribute("DIRECTORY_AUTHENTICATION")).getCommunityID();
			} else {
				communityID = "001000000";
			}
		}
		this.logger.debug("viewPicture userID[" + userID + "], empcode[" + empcode + "], communityID[" + communityID + "]");
		User user = null;
		if (StringUtils.isNotEmpty(userID)) {
			user = this.orgContext.getUser(userID);
		} else if (StringUtils.isNotEmpty(empcode)) {
			user = this.orgContext.getUser(communityID, new EmpCodeKey(empcode, true));
		}
		this.logger.debug("viewPicture find user[" + user + "]");
		HttpSession session = request.getSession();

		File pictureFile = null;
		if ((user == null) || (StringUtils.isEmpty(user.getPicturePath()))) {
			pictureFile = getNoImageFile(request, session);
		} else {
			this.logger.debug("viewPicture find user.getPicturePath()[" + user.getPicturePath() + "]");
			pictureFile = new File(this.orgFolder.getBaseDir() + user.getPicturePath());
			if (!pictureFile.exists()) {
				pictureFile = getNoImageFile(request, session);
			}
		}
		this.logger.debug("viewPicture find pictureFile[" + pictureFile + "]");
		FileInputStream in = null;
		try {
			in = new FileInputStream(pictureFile);
			String extender = FilenameUtils.getExtension(pictureFile.getName());
			response.setContentType("image/" + (StringUtils.isEmpty(extender) ? "jpg" : extender.toLowerCase()));
			response.setContentLength((int)pictureFile.length());
			IOUtils.copy(in, response.getOutputStream());
			return;
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e) {
			}
		}
	}
}

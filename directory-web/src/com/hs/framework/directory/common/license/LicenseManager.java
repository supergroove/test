package com.hs.framework.directory.common.license;

import com.hs.framework.directory.context.OrgContext;
import com.hs.framework.directory.context.OrgFolder;
import com.hs.framework.directory.info.Community;
import com.hs.framework.directory.search.LoginApp;
import com.hs.framework.directory.search.MultiSearchKey;
import com.hs.framework.directory.search.StatusKey;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;
import org.apache.log4j.Logger;
import org.springframework.context.MessageSource;

public class LicenseManager {
	private static Logger logger = Logger.getLogger(LicenseManager.class);
	private static final int DEFAULT_MAXIMUM_USER = 1;
	private static boolean initialized = false;
	private static HashMap<String, LicenseHeader> licenseHashMap = null;
	private static OrgContext orgContext;
	private static OrgFolder orgFolder;
	private static MessageSource messageSource;

	public void setOrgContext(OrgContext orgContext) {
		this.orgContext = orgContext;
	}

	public void setOrgFolder(OrgFolder orgFolder) {
		this.orgFolder = orgFolder;
	}

	public void setMessageSource(MessageSource messageSource) {
		this.messageSource = messageSource;
	}

	public static boolean isValidLicense(String communityID) throws LicenseException {
		LicenseParameter param = new LicenseParameter();

		return isValidLicense(communityID, false, param);
	}

	public static boolean isValidLicenseForRegisteredUser(String communityID, boolean reScan, int offsetRegister) throws LicenseException {
		LicenseParameter param = new LicenseParameter();
		param.isRegister = true;
		param.offsetRegister = offsetRegister;

		return isValidLicense(communityID, reScan, param);
	}

	public static boolean isValidLicenseForLogin(String communityID) throws LicenseException {
		LicenseParameter param = new LicenseParameter();
		param.isLogin = true;

		return isValidLicense(communityID, false, param);
	}

	public static boolean isValidLicenseForOpenApi(String communityID) throws LicenseException {
		if (!initialized) {
			initialize();
		}
		LicenseHeader header = (LicenseHeader)licenseHashMap.get(communityID);
		if ((header == null) || (header.getLicenseInfo() == null) || (!header.getLicenseInfo().isOpenApi())) {
			throw new LicenseException("Invalid OpenApi License");
		}
		return true;
	}

	private static boolean isValidLicense(String communityID, boolean reScan, LicenseParameter param) throws LicenseException {
		if (!initialized) {
			initialize();
		}
		try {
			LicenseHeader header = (LicenseHeader)licenseHashMap.get(communityID);
			if (header == null) {
				throw new LicenseException("Not exist license info : communityID[" + communityID + "]");
			}
			LicenseInfo license = header.getLicenseInfo();
			LicenseInfo current = header.getCurrentInfo();

			StringBuffer errorMsg = new StringBuffer();
			boolean isLicenseException = false;

			System.out.println("by ykkim ===> license.getIP() : " + license.getIP());
			NetIfInfo.printNetInfos();

			if (!"unlimited".equals(license.getIP())) {
				boolean pass = false;
				StringTokenizer st = new StringTokenizer(license.getIP(), ";");
				while (st.hasMoreTokens()) {
					String ip = st.nextToken();
					if (NetIfInfo.containIPv4(ip)) {
						current.setIP(ip);
						pass = true;
						break;
					}
				}
				if (!pass) {
					isLicenseException = true;
					String msg = messageSource.getMessage("directory.HostLicenseException", null, "Not licensed server.", Locale.getDefault());

					errorMsg.append(msg).append("\n");
				}
			}
			if (license.getDate() != null) {
				current.setDate(Calendar.getInstance().getTime());
				if (license.getDate().getTime() + 86400000L <= current.getDate().getTime()) {
					isLicenseException = true;
					String msg = messageSource.getMessage("directory.ExpireLicenseException", null, "License has expired.", Locale.getDefault());

					errorMsg.append(msg).append("\n");
				}
			}
			if ((license.getMaxUser() != -1) && (param.isRegister)) {
				if ((current.getMaxUser() == -1) || (reScan)) {
					current.setMaxUser(getRegisterCount(communityID) - getAdditionalOfficerCount(communityID));
				}
				if (license.getMaxUser() < current.getMaxUser() + param.offsetRegister) {
					isLicenseException = true;
					String msg = messageSource.getMessage("directory.RegisteredUserLicenseException", new Integer[] {Integer.valueOf(license.getMaxUser()), Integer.valueOf(current.getMaxUser())},
						"Maximum allowable registered user count was exceeded. License user count[" + license.getMaxUser() + "], registered user count[" + current.getMaxUser() + "]",
						Locale.getDefault());

					errorMsg.append(msg).append("\n");
				}
			}
			if ((license.getConcurrent() != -1) && (param.isLogin)) {
				current.setConcurrent(getLoginCount(communityID));
				if (license.getConcurrent() < current.getConcurrent()) {
					isLicenseException = true;
					String msg = messageSource.getMessage("directory.LoginUserLicenseException", new Integer[] {Integer.valueOf(license.getConcurrent()), Integer.valueOf(current.getConcurrent())},
						"Maximum allowable concurrent user count was exceeded. License user count[" + license.getConcurrent() + "], concurrent user count[" + current.getConcurrent() + "]",
						Locale.getDefault());

					errorMsg.append(msg).append("\n");
				}
			}
			if (isLicenseException) {
				throw new LicenseException(errorMsg.toString());
			}
			return true;
		} catch (LicenseException e) {
			logger.error("EXCEPTION occurred: [" + e.toString() + "] " + e.getMessage(), e);
			throw e;
		} catch (Exception e) {
			logger.error("EXCEPTION occurred: [" + e.toString() + "] " + e.getMessage(), e);
			throw new LicenseException(e.getMessage());
		}
	}

	public static LicenseHeader getLicenseHeader(String communityID) throws CloneNotSupportedException, LicenseException {
		if (!initialized) {
			initialize();
		}
		LicenseHeader header = (LicenseHeader)licenseHashMap.get(communityID);
		if (header == null) {
			throw new LicenseException("Not exist license info : communityID[" + communityID + "]");
		}
		return (LicenseHeader)header.clone();
	}

	private static synchronized void initialize() {
		licenseHashMap = new HashMap();

		System.out.println("orgContext ===> " + orgContext);

		List<Community> communityList = orgContext.getCommunityList();
		for (Community community : communityList) {
			LicenseHeader header = null;
			try {
				String filePath = orgFolder.getPath("license" + File.separator);
				String fileName = "license_" + community.getAlias() + ".lic";
				File licenseFile = new File(filePath + fileName);

				System.out.println("ykkim license fiel ===> " + filePath + fileName);

				if (!licenseFile.exists()) {
					throw new FileNotFoundException("Not exist license file : " + licenseFile.getAbsolutePath());
				}
				header = LicenseUtils.getLicenseHeader(licenseFile);
			} catch (Exception e) {
				logger.error("Invalid license - " + e.getMessage(), e);

				header = new LicenseHeader(1);
			}
			licenseHashMap.put(community.getID(), header);
			if (logger.isDebugEnabled()) {
				logger.debug("License initialize, communityID = " + community.getID() + ", header = {" + header.toString() + "}");
			}
		}
		initialized = true;
	}

	public static void reload() {
	}

	private static int getRegisterCount(String communityID) {
		List<String> statuses = new ArrayList();
		statuses.add("1");
		statuses.add("8");
		return orgContext.getUserListCount(communityID, null, 0, new StatusKey(statuses), null, true, false);
	}

	private static int getAdditionalOfficerCount(String communityID) {
		return 0;
	}

	private static int getLoginCount(String communityID) {
		List<String> statuses = new ArrayList();
		statuses.add("1");
		statuses.add("8");
		MultiSearchKey multiKey = new MultiSearchKey();
		multiKey.add(new StatusKey(statuses));
		multiKey.add(new LoginApp("DEFAULT"));

		return orgContext.getUserListCount(communityID, null, 0, multiKey, null, true, false);
	}
}

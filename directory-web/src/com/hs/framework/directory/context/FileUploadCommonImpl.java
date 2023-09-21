package com.hs.framework.directory.context;

import com.hs.framework.directory.model.FileVO;
import com.hs.framework.directory.model.FileVOImpl;
import java.io.File;
import java.rmi.server.UID;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;

public class FileUploadCommonImpl extends FileUploadBase {
	static Log logger = LogFactory.getLog(FileUploadCommonImpl.class);
	public static final String PROGRESS_LISTENER = "PROGRESS_LISTENER";
	public static final String PROGRESS_LISTENER_STATUS = "PROGRESS_LISTENER_STATUS";
	public static final String PROGRESS_LISTENER_ERROR = "PROGRESS_LISTENER_ERROR";
	public static final String PROGRESS_LISTENER_ERROR_SIZE = "SIZE";
	public static final String PROGRESS_LISTENER_ERROR_ERROR = "ERROR";
	public static final String PROGRESS_LISTENER_ERROR_INTERRUPT = "INTERRUPT";
	public static final String ATTACHED_FILES = "ATTACHED_FILES";
	public static final String DOWNLOAD_TARGET_FILE_NAME = "filename";
	public static final String IS_CONCRETE_FILE_DOWNLOAD = "isconcrete";
	private static FileUploadBase instance = null;
	private long fileSizeMax = 10485760L;
	private static final String UID = new UID().toString().replace(':', '_').replace('-', '_');
	private static final String MULTIPART = "multipart/form-data";
	private static final String X_FILENAME = "X_FILENAME";

	public void init(Object obj) {
		this.fileSizeMax = ((Long)obj).longValue();
	}

	public static FileUploadBase getInstance() {
		if (instance == null) {
			instance = new FileUploadCommonImpl();
		}
		return instance;
	}

	protected Map fileUploadProcess(HttpServletRequest request, long maxUploadSize, String temporaryDirectory) throws Exception {
		initialingUploadStatus(request);
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.fileUploadProcess set PROGRESS_LISTENER_STATUS 0");
		}
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.fileUploadProcess request.getSession() " + request.getSession().getId());
		}
		request.getSession().setAttribute("PROGRESS_LISTENER_STATUS", new Integer(0));

		Integer listenerStatus = (Integer)request.getSession().getAttribute("PROGRESS_LISTENER_STATUS");
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.fileUploadProcess listenerStatus " + listenerStatus.intValue());
		}
		if (listenerStatus == null) {
			if (logger.isDebugEnabled()) {
				logger.debug("FileUploadCommonImpl.fileUploadProcess listenerStatus is null");
			}
		}
		Map parameterMap = null;
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.fileUploadProcess");
		}
		try {
			String contentType = request.getContentType();

			parameterMap = saveFiles(request, maxUploadSize, temporaryDirectory);
		} catch (SizeLimitExceededException ex) {
			request.getSession().setAttribute("PROGRESS_LISTENER_ERROR", "SIZE");
			throw new MaxUploadSizeExceededException(this.fileSizeMax, ex);
		} catch (FileUploadException ex) {
			request.getSession().setAttribute("PROGRESS_LISTENER_ERROR", "ERROR");
			ex.printStackTrace();
			throw new MultipartException("Could not parse multipart servlet request", ex);
		} catch (FileUploadInterruptedException fex) {
			request.getSession().setAttribute("PROGRESS_LISTENER_ERROR", "INTERRUPT");
			throw new MultipartException("fileupload interrupted", fex);
		}
		return parameterMap;
	}

	private void initialingUploadStatus(HttpServletRequest request) {
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.initialingUploadStatus start");
		}
		request.getSession().removeAttribute("PROGRESS_LISTENER_STATUS");
		request.getSession().removeAttribute("PROGRESS_LISTENER_ERROR");
		request.getSession().removeAttribute("PROGRESS_LISTENER");
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.initialingUploadStatus finish");
		}
	}

	private Map saveFiles(HttpServletRequest request, long maxUploadSize, String temporaryDirectory) throws Exception {
		List<FileVO> files = new ArrayList();
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.saveFiles for multi-part/formdata");
		}
		ServletFileUpload fileUpload = new ServletFileUpload();

		fileUpload.setFileSizeMax(getFileSizeMax());
		FileUploadListener pListener = new FileUploadListener();
		fileUpload.setProgressListener(pListener);

		request.getSession().setAttribute("PROGRESS_LISTENER", pListener);
		if (request.getContentLength() > fileUpload.getFileSizeMax()) {
			if (logger.isDebugEnabled()) {
				logger.debug("this file' size is larger than permitted size");
			}
			throw new SizeLimitExceededException("The file size is too large", request.getContentLength(), getFileSizeMax());
		}
		if (logger.isDebugEnabled()) {
			logger.debug("this file' size is under permitted size");
		}
		DiskFileItemFactory factory = new DiskFileItemFactory();
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.saveFiles factory :  " + factory);
		}
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadCommonImpl.saveFiles temporaryDirectory :  " + temporaryDirectory);
		}
		File repo = new File(temporaryDirectory);
		if (!repo.exists()) {
			repo.mkdirs();
		}
		factory.setRepository(repo);
		fileUpload.setFileItemFactory(factory);
		List fileItemList = fileUpload.parseRequest(request);

		String charset = request.getCharacterEncoding();
		FileItem item = null;

		FileVO tempVO = null;
		Map parameterMap = new HashMap();
		for (Iterator iter = fileItemList.iterator(); iter.hasNext();) {
			item = (FileItem)iter.next();
			if (!item.isFormField()) {
				if (item.getSize() > 0L) {
					tempVO = new FileVOImpl();
					int idx = item.getName().lastIndexOf("\\");
					if (idx == -1) {
						idx = item.getName().lastIndexOf("/");
					}
					tempVO.setOrgFileName(item.getName().substring(idx + 1));
					tempVO.setFileSize(item.getSize());

					String ext = szGetExtender(tempVO.getOrgFileName());

					tempVO.setSysFileName(request.getSession().getId() + "_" + System.currentTimeMillis() + "_" + item.getFieldName() + "." + ext);
					tempVO.setFilePath(temporaryDirectory + File.separator + tempVO.getSysFileName());
					File file = new File(tempVO.getFilePath());
					item.write(file);

					parameterMap.put(item.getFieldName(), tempVO);
				}
			} else {
				String prevValue = (String)parameterMap.get(item.getFieldName());
				String value = item.getString(charset);
				if (prevValue == null) {
					parameterMap.put(item.getFieldName(), value);
				} else {
					parameterMap.put(item.getFieldName(), prevValue + "," + value);
				}
			}
		}
		parameterMap.put("files", files);

		return parameterMap;
	}

	public void setFileSizeMax(long fileSizeMax) {
		this.fileSizeMax = fileSizeMax;
	}

	public long getFileSizeMax() {
		return this.fileSizeMax;
	}
}

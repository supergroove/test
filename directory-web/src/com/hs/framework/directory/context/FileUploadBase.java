package com.hs.framework.directory.context;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public abstract class FileUploadBase {
	static Log logger = LogFactory.getLog(FileUploadBase.class);

	public String szGetExtender(String szPath) throws Exception {
		String szRet = "";

		szPath = new File(szPath).getCanonicalPath();

		int i = szPath.lastIndexOf('.');
		int j = szPath.lastIndexOf(File.separator);
		if (i >= 0) {
			if (((j >= 0) && (i > j)) || (j < 0)) {
				if (i + 1 < szPath.length()) {
					szRet = szPath.substring(i + 1);
				}
			}
		}
		return szRet;
	}

	public void copy(File srcFile, File tgtFile) throws Exception {
		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		try {
			in = new BufferedInputStream(new FileInputStream(srcFile));
			out = new BufferedOutputStream(new FileOutputStream(tgtFile));

			copy(in, out, null);
			return;
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e) {
			}
			try {
				if (out != null) {
					out.close();
				}
			} catch (Exception e) {
			}
		}
	}

	public void copy(InputStream inStream, OutputStream outStream, FileUploadListener fileUploadListener) throws Exception {
		copy(new BufferedInputStream(inStream), new BufferedOutputStream(outStream), fileUploadListener);
	}

	public void copy(BufferedInputStream inStream, BufferedOutputStream outStream, FileUploadListener fileUploadListener) throws Exception {
		byte[] bBuf = new byte['?'];
		try {
			int nRead = 1;
			long nSum = 0L;
			while ((nRead = inStream.read(bBuf, 0, 10240)) > 0) {
				outStream.write(bBuf, 0, nRead);
				nSum += nRead;
				if (fileUploadListener != null) {
					fileUploadListener.update(nSum, fileUploadListener.getContentLength(), 0);
				}
			}
			logger.debug("IOUtils File Size(486) : " + nSum);
		} catch (FileUploadInterruptedException e) {
			throw e;
		} catch (Exception e) {
			logger.error("[IOUtils File Buffer flush Error(490)]" + e.toString());
			throw e;
		} finally {
			outStream.flush();
		}
	}

	public Map fileUpload(HttpServletRequest request, long maxUploadSize, String temporaryDirectory) throws Exception {
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadBase.fileUpload");
		}
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadBase.fileUpload temporaryDirectory : " + temporaryDirectory);
		}
		Map parameterMap = fileUploadProcess(request, maxUploadSize, temporaryDirectory);
		if (logger.isDebugEnabled()) {
			logger.debug("FileUploadBase.fileUpload parameterMap : " + parameterMap);
		}
		return parameterMap;
	}

	private boolean validUrl(String url) {
		return (url.toLowerCase().startsWith("http://")) || (url.toLowerCase().startsWith("https://"));
	}

	protected abstract Map fileUploadProcess(HttpServletRequest paramHttpServletRequest, long paramLong, String paramString) throws Exception;

	public abstract void init(Object paramObject);
}

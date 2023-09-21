package com.hs.framework.directory.context;

import org.springframework.web.multipart.MultipartException;

public class FileUploadInterruptedException
  extends MultipartException
{
  private static final long serialVersionUID = 8442828950362528785L;
  protected String faultCode;
  
  public FileUploadInterruptedException(String msg)
  {
    super(msg);
  }
  
  public FileUploadInterruptedException(String faultCode, String msg)
  {
    super(msg);
    this.faultCode = faultCode;
  }
  
  public FileUploadInterruptedException(String msg, Throwable cause)
  {
    super(msg, cause);
  }
  
  public FileUploadInterruptedException(String faultCode, String msg, Throwable cause)
  {
    super(msg, cause);
    this.faultCode = faultCode;
  }
  
  public void setFaultCode(String faultCode)
  {
    this.faultCode = faultCode;
  }
  
  public String getFaultCode()
  {
    return this.faultCode;
  }
  
  public String getMessage()
  {
    String message = super.getMessage();
    if (this.faultCode != null) {
      if (message != null) {
        message = message.length() + 16 + '[' + this.faultCode + "] " + message;
      } else {
        message = 16 + '[' + this.faultCode + ']';
      }
    }
    return message;
  }
}

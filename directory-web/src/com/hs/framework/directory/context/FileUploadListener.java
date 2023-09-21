package com.hs.framework.directory.context;

import org.apache.commons.fileupload.ProgressListener;

public class FileUploadListener
  implements ProgressListener
{
  private long bytesRead;
  private long contentLength = -1L;
  private boolean interrupted;
  
  public FileUploadListener() {}
  
  public FileUploadListener(long contentLength)
  {
    this.contentLength = contentLength;
  }
  
  public void update(long bytesRead, long contentLength, int items)
  {
    if (contentLength < 0L) {
      throw new IllegalArgumentException("contentLength is " + contentLength + ", illegal use");
    }
    this.bytesRead = bytesRead;
    this.contentLength = contentLength;
    if (this.interrupted) {
      throw new FileUploadInterruptedException("Fileupload interrupted!!");
    }
  }
  
  public long getBytesRead()
  {
    return this.bytesRead;
  }
  
  public void setBytesRead(long bytesRead)
  {
    this.bytesRead = bytesRead;
  }
  
  public void addBytesRead(long bytesRead)
  {
    this.bytesRead += bytesRead;
  }
  
  public long getContentLength()
  {
    return this.contentLength;
  }
  
  public void addContentLength(long contentLength)
  {
    this.contentLength += contentLength;
  }
  
  public void setContentLength(long contentLength)
  {
    this.contentLength = contentLength;
  }
  
  public void setInterrupted(boolean interrupted)
  {
    this.interrupted = interrupted;
  }
}

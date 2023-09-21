package com.hs.framework.directory.common.license;

import java.io.IOException;
import java.io.PrintStream;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import org.apache.log4j.Logger;

public class NetIfInfo {
	private static Logger logger = Logger.getLogger(NetIfInfo.class);
	private static final String NL = System.getProperty("line.separator");
	private static final String NL_TAB = NL + "\t";
	private static final String IPV4 = "IPv4";
	private static final String IPV6 = "IPv6";
	private static List<InterfaceInfo> interfaceInfos;

	private static class InterfaceInfo {
		public String displayName;
		public String name;
		public List<NetIfInfo.IpAddressInfo> ipAddresses;

		public String toString() {
			StringBuffer sb = new StringBuffer();
			sb.append(NetIfInfo.NL).append("*** Interface [" + this.name + "] ***");
			sb.append(NetIfInfo.NL).append("display name  : " + this.displayName);
			sb.append(NetIfInfo.NL).append("HW address    : ");
			for (NetIfInfo.IpAddressInfo ipAddr : this.ipAddresses) {
				sb.append(ipAddr);
			}
			return sb.toString();
		}
	}

	private static class IpAddressInfo {
		public String ipAddress;
		public String ipVersion = "unknown";
		public String hostName;
		public String canonicalHostName;
		public boolean isLoopback;
		public boolean isSiteLocal;
		public boolean isAnyLocal;
		public boolean isLinkLocal;
		public boolean isMulticast;

		public String toString() {
			StringBuffer sb = new StringBuffer();
			sb.append(NetIfInfo.NL).append("INET address (" + this.ipVersion + "): " + this.ipAddress);
			sb.append(NetIfInfo.NL_TAB).append("host name           : " + this.hostName);
			sb.append(NetIfInfo.NL_TAB).append("canonical host name : " + this.canonicalHostName);
			sb.append(NetIfInfo.NL_TAB).append("loopback            : " + this.isLoopback);
			sb.append(NetIfInfo.NL_TAB).append("site local          : " + this.isSiteLocal);
			sb.append(NetIfInfo.NL_TAB).append("any local           : " + this.isAnyLocal);
			sb.append(NetIfInfo.NL_TAB).append("link local          : " + this.isLinkLocal);
			sb.append(NetIfInfo.NL_TAB).append("multicast           : " + this.isMulticast);

			return sb.toString();
		}
	}

	private static InterfaceInfo getInterfaceInfo(NetworkInterface nif) {
		InterfaceInfo info = new InterfaceInfo();
		info.displayName = nif.getDisplayName();
		info.name = nif.getName();
		info.ipAddresses = new ArrayList();

		Enumeration<InetAddress> inetAddresses = nif.getInetAddresses();
		while (inetAddresses.hasMoreElements()) {
			InetAddress inetAddr = (InetAddress)inetAddresses.nextElement();

			IpAddressInfo ipInfo = new IpAddressInfo();
			if ((inetAddr instanceof Inet4Address)) {
				ipInfo.ipVersion = "IPv4";
			} else if ((inetAddr instanceof Inet6Address)) {
				ipInfo.ipVersion = "IPv6";
			}
			ipInfo.ipAddress = inetAddr.getHostAddress();
			ipInfo.hostName = inetAddr.getHostName();
			ipInfo.canonicalHostName = inetAddr.getCanonicalHostName();
			ipInfo.isAnyLocal = inetAddr.isAnyLocalAddress();
			ipInfo.isLinkLocal = inetAddr.isLinkLocalAddress();
			ipInfo.isSiteLocal = inetAddr.isSiteLocalAddress();
			ipInfo.isLoopback = inetAddr.isLoopbackAddress();
			ipInfo.isMulticast = inetAddr.isMulticastAddress();

			info.ipAddresses.add(ipInfo);
		}
		return info;
	}

	public static List<InterfaceInfo> getInterfaceInfos() throws IOException {
		if (interfaceInfos != null) {
			return interfaceInfos;
		}
		interfaceInfos = new ArrayList();

		Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
		while (interfaces.hasMoreElements()) {
			NetworkInterface nif = (NetworkInterface)interfaces.nextElement();
			InterfaceInfo info = getInterfaceInfo(nif);
			interfaceInfos.add(info);
		}
		if (logger.isDebugEnabled()) {
			String msg = "NetworkInterface initialize..";
			for (InterfaceInfo info : interfaceInfos) {
				for (IpAddressInfo ipAddr : info.ipAddresses) {
					if ("IPv4".equals(ipAddr.ipVersion)) {
						msg = msg + ipAddr;
					}
				}
			}
			logger.debug(msg);
		}
		return interfaceInfos;
	}

	public static boolean containIPv4(String ip) throws IOException {
		for (InterfaceInfo info : interfaceInfos) {
			for (IpAddressInfo ipAddr : info.ipAddresses) {
				if ("IPv4".equals(ipAddr.ipVersion)) {
					if ((ip.equals(ipAddr.ipAddress)) || (ip.equals(ipAddr.hostName))) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public static void printNetInfos() throws IOException {
		if (interfaceInfos == null) {
			NetIfInfo.getInterfaceInfos();
		}
		for (InterfaceInfo info : interfaceInfos) {
			for (IpAddressInfo ipAddr : info.ipAddresses) {
				if ("IPv4".equals(ipAddr.ipVersion)) {
					System.out.println(ipAddr);
				}
			}
		}
	}

	public static void main(String[] args) throws Exception {

		NetIfInfo.getInterfaceInfos();
		NetIfInfo.printNetInfos();

		//System.out.println(containIPv4("127.0.0.1"));
	}
}

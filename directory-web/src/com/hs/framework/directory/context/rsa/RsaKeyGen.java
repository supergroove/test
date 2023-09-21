package com.hs.framework.directory.context.rsa;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.RSAPublicKeySpec;

import javax.crypto.Cipher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

public class RsaKeyGen {
	static Logger logger = Logger.getLogger(RsaKeyGen.class);
	public static String SESSION_RSAPRIVATEKEY = "__rsaPrivateKey__";
	public static String PARAM_CRYPTEDPARAMS = "__cryptedParams__";
	public static String ATTR_PRIVATEKEY_ERROR = "PRIVATEKEY_ERROR";

	public static String[] generateKeyPair(HttpSession session) {
		try {
			int KEY_SIZE = 1024;
			KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
			generator.initialize(KEY_SIZE);
			KeyPair keyPair = generator.genKeyPair();
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");

			PublicKey publicKey = keyPair.getPublic();
			PrivateKey privateKey = keyPair.getPrivate();

			session.setAttribute(SESSION_RSAPRIVATEKEY, privateKey);

			RSAPublicKeySpec publicSpec = (RSAPublicKeySpec)keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);

			String[] publicKeyArray = new String[2];
			publicKeyArray[0] = publicSpec.getModulus().toString(16);
			publicKeyArray[1] = publicSpec.getPublicExponent().toString(16);

			return publicKeyArray;
		} catch (Exception e) {
			e.printStackTrace();
			logger.warn("fail to generate the KeyPair", e);
		}
		return null;
	}

	private static byte[] hexToByteArray(String hex) {
		if ((hex == null) || (hex.length() % 2 != 0)) {
			return new byte[0];
		}
		byte[] bytes = new byte[hex.length() / 2];
		for (int i = 0; i < hex.length(); i += 2) {
			byte value = (byte)Integer.parseInt(hex.substring(i, i + 2), 16);
			bytes[((int)Math.floor(i / 2))] = value;
		}
		return bytes;
	}

	private static String decryptRsa(PrivateKey privateKey, String securedValue) throws Exception {
		Cipher cipher = Cipher.getInstance("RSA");
		byte[] encryptedBytes = hexToByteArray(securedValue);
		cipher.init(2, privateKey);
		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
		String decryptedValue = new String(decryptedBytes, "utf-8");
		return decryptedValue;
	}

	public static String decryptParameter(HttpServletRequest request, String cryptedParam) throws Exception {
		HttpSession session = request.getSession();
		PrivateKey rasPrivateKey = session != null ? (PrivateKey)session.getAttribute(SESSION_RSAPRIVATEKEY) : null;
		String cryptedValue = request.getParameter(cryptedParam);
		logger.debug("decryptParameter rasPrivateKey[" + rasPrivateKey + "],cryptedValue[" + cryptedValue + "]");
		if ((rasPrivateKey != null) && (StringUtils.isNotEmpty(cryptedValue))) {
			return decryptRsa(rasPrivateKey, cryptedValue);
		}
		return cryptedValue;
	}
}

package com.bms.utils;

import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 */
public class Md5Encrypt {
	/**
	 * Used building output as Hex
	 */
	private static final char[] DIGITS = { '0', '1', '2', '3', '4', '5', '6',
			'7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

    
	/**
	 * 对字符串进行MD5加密
	 * @param text 明文
	 * @return 密文
	 */
	public static String md5(String text) {
		return md5(text,Charset.forName("utf8"));
	}
	
	/**
	 * 对字符串进行MD5加密
	 * @param text 明文
	 * @return 密文
	 */
	public static String md5(String text,Charset charset) {
		try {
			MessageDigest msgDigest = MessageDigest.getInstance("MD5");
			msgDigest.update(text.getBytes(charset));    //按照utf-8编码形式加密
			return  new String(encodeHex(msgDigest.digest()));
		} catch (NoSuchAlgorithmException e) {
			throw new IllegalStateException("当前系统不支持Md5加密！");
        }
	}
	
	/**
	 * 对字符串进行MD5加密
	 * @param text 明文
	 * @return 密文
	 */
	public static String md5New(String text) {
		String md5 = "";  
        try {  
            MessageDigest md = MessageDigest.getInstance("MD5");  // 创建一个md5算法对象  
            byte[] messageByte = text.getBytes("UTF-8");  
            byte[] md5Byte = md.digest(messageByte);              // 获得MD5字节数组,16*8=128位  
            md5 = bytesToHex(md5Byte);                            // 转换为16进制字符串  
        } catch (Exception e) {  
            e.printStackTrace();  
        }  
        return md5;  
	}
	
	
	public static String md5Two(String text) {
		try {
            // 得到一个信息摘要器
            MessageDigest digest = MessageDigest.getInstance("md5");
            byte[] result = digest.digest(text.getBytes());
            StringBuffer buffer = new StringBuffer();
            // 把每一个byte 做一个与运算 0xff;
            for (byte b : result) {
                // 与运算
                int number = b & 0xff;// 加盐
                String str = Integer.toHexString(number);
                if (str.length() == 1) {
                    buffer.append("0");
                }
                buffer.append(str);
            }

            // 标准的md5加密后的结果
            return buffer.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return "";
        }  
	}
	public static String md5Three(String text) {
		char hexDigits[] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
        };
        try {
            byte[] btInput = text.getBytes();
            // 获得MD5摘要算法的 MessageDigest 对象
            MessageDigest mdInst = MessageDigest.getInstance("MD5");
            // 使用指定的字节更新摘要
            mdInst.update(btInput);
            // 获得密文
            byte[] md = mdInst.digest();
            // 把密文转换成十六进制的字符串形式
            int j = md.length;
            char str[] = new char[j * 2];
            int k = 0;
            for (int i = 0; i < j; i++) {
                byte byte0 = md[i];
                str[k++] = hexDigits[byte0 >>> 4 & 0xf];
                str[k++] = hexDigits[byte0 & 0xf];
            }
            return new String(str);
        } catch (Exception e) {
            return null;
        }
    }

	 // 二进制转十六进制  
    public static String bytesToHex(byte[] bytes) {  
        StringBuffer hexStr = new StringBuffer();  
        int num;  
        for (int i = 0; i < bytes.length; i++) {  
            num = bytes[i];  
             if(num < 0) {  
                 num += 256;  
            }  
            if(num < 16){  
                hexStr.append("0");  
            }  
            hexStr.append(Integer.toHexString(num));  
        }  
        return hexStr.toString().toUpperCase();  
    }  

	public static char[] encodeHex(byte[] data) {

		int l = data.length;
		char[] out = new char[l << 1];
		// two characters form the hex value.
		for (int i = 0, j = 0; i < l; i++) {
			out[j++] = DIGITS[(0xF0 & data[i]) >>> 4];
			out[j++] = DIGITS[0x0F & data[i]];
		}
		return out;
	}
	
	public static void main(String[] args) {
		System.out.println(Md5Encrypt.md5("ty189@2013admin"));
	}
	
	public static byte[] md5Byte(byte[] input) {
	    try {
	    	MessageDigest msgDigest = MessageDigest.getInstance("MD5");
	    	msgDigest.update(input);
	 	    return msgDigest.digest();
	    } catch (NoSuchAlgorithmException e) {
	      throw new IllegalStateException("System doesn't support MD5 algorithm.");
	    }
	  }
//	public static String md5Byte(byte[] array) {
//		try {
//			MessageDigest msgDigest = MessageDigest.getInstance("MD5");
//			msgDigest.update(array);
//			return  new String(encodeHex(msgDigest.digest()));
//		} catch (NoSuchAlgorithmException e) {
//			throw new IllegalStateException("当前系统不支持Md5加密！");
//        }
//	}
	
	


}
package com.students.util;

import net.sf.json.JSONObject;

import javax.crypto.Cipher;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.math.BigInteger;
import java.security.*;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPrivateKeySpec;
import java.security.spec.RSAPublicKeySpec;

public class RSAUtil {

    public static KeyPair generateKeyPair(String RSAKeyStore) throws Exception{
        try{
            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA",new org.bouncycastle.jce.provider.BouncyCastleProvider());
            final int KEY_SIZE = 1024; //key大小 越大越安全 但解码效率也更加低下 根据硬件配置而定
            keyPairGenerator.initialize(KEY_SIZE,new SecureRandom());
            KeyPair keyPair = keyPairGenerator.generateKeyPair();

            System.out.println(keyPair.getPrivate());
            System.out.println(keyPair.getPublic());
            saveKeyPair(keyPair,RSAKeyStore);

            return keyPair;
        }catch (Exception e){
            e.printStackTrace();
            throw new Exception("生成密匙出错"+e.getMessage());
        }
    }
    public static KeyPair getKeyPair(String RSAKeyStore) throws Exception{
        FileInputStream fis = new FileInputStream(RSAKeyStore);
        ObjectInputStream os = new ObjectInputStream(fis);
        KeyPair kp = (KeyPair) os.readObject();
        os.close();
        fis.close();
        return kp;
    }
    public static void saveKeyPair(KeyPair kp,String RSAKeyStore) throws Exception{
        FileOutputStream fos = new FileOutputStream(RSAKeyStore);
        ObjectOutputStream oos = new ObjectOutputStream(fos);
        //生成密匙文件
        oos.writeObject(kp);
        oos.close();
        fos.close();
    }

    /**
     * 生成公匙
     */
    public static RSAPublicKey generateRsaPublicKey(byte[] modulus,byte[] publicExponent) throws Exception{
        KeyFactory keyFac = null;
        try{
            keyFac = KeyFactory.getInstance("RSA",new org.bouncycastle.jce.provider.BouncyCastleProvider());
        }catch (NoSuchAlgorithmException e){
            throw new Exception(e.getMessage());
        }
        RSAPublicKeySpec publicKeySpec = new RSAPublicKeySpec(new BigInteger(modulus),new BigInteger(publicExponent));
        try{
            return (RSAPublicKey) keyFac.generatePublic(publicKeySpec);
        }catch (InvalidKeySpecException e){
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
    }
    /**
     * 生成私匙
     */
    public static RSAPrivateKey generateRSAPrivateKey(byte[] modulus,byte[] privateExponent) throws Exception{
        KeyFactory keyFac = null;
        try{
            keyFac = KeyFactory.getInstance("RSA",new org.bouncycastle.jce.provider.BouncyCastleProvider());
        }catch (NoSuchAlgorithmException e){
            throw new Exception(e.getMessage());
        }
        RSAPrivateKeySpec privateKeySpec = new RSAPrivateKeySpec(new BigInteger(modulus),new BigInteger(privateExponent));
        try{
            return (RSAPrivateKey)keyFac.generatePrivate(privateKeySpec);
        }catch (InvalidKeySpecException e){
            e.printStackTrace();
            throw new Exception(e.getMessage());
        }
    }
    /**
     * 加密
     * key ： 加密的密匙*
     * data待解密的明文数据
     */
    public static byte[] encrypt(PublicKey pk, byte[] data) throws Exception{
        try{
            Cipher cipher = Cipher.getInstance("RSA",new org.bouncycastle.jce.provider.BouncyCastleProvider());
            int blockSize = cipher.getBlockSize(); //获得加密块大小
            //加密块大小为127
            //byte，加密后为128个byte，因此共有2个加密块，第一个127
            //byte第二个为1个byte
            int outputSize = cipher.getOutputSize(data.length);
            int leavedSize = data.length % blockSize;
            int blocksSize = leavedSize != 0 ? data.length / blockSize + 1 : data.length / blockSize;
            byte[] raw = new byte[outputSize * blocksSize];
            int i = 0;
            while (data.length - i * blocksSize > 0){
                if(data.length - i * blockSize > blockSize){
                    cipher.doFinal(data, i * blockSize,blockSize,raw,i * outputSize);
                }else {
                    cipher.doFinal(data,i * blockSize, data.length - i * blockSize, raw, i * outputSize);
                }
                i++;
            }
            return raw;
        }catch (Exception e){
            throw new Exception(e.getMessage());
        }
        /**
         * 解密
         * key：解密的密匙
         * raw 已经加密的数据
         * return 解密后的明文
         */
    }

    public static Object RSA(String path,HttpServletRequest request) throws Exception{
        JSONObject result = new JSONObject();
        KeyPair kp = RSAUtil.generateKeyPair(path);
        RSAPublicKey pubk = (RSAPublicKey) kp.getPublic();//生成公匙
        RSAPrivateKey prik = (RSAPrivateKey) kp.getPrivate();//生成私匙
        String publicKeyExponent = pubk.getPublicExponent().toString(16);//16进制
        String publicKeyModulus = pubk.getModulus().toString(16);
        request.getSession().setAttribute("prikey",prik);
        result.put("pubexponent",publicKeyExponent);
        result.put("pubmoulues", publicKeyModulus);
        result.put("error",0);
        return result;
    }
    public static byte[] decrypt(PrivateKey pk, byte[] raw) throws Exception{
        try{
            Cipher cipher = Cipher.getInstance("RSA",
                    new org.bouncycastle.jce.provider.BouncyCastleProvider());
            cipher.init(cipher.DECRYPT_MODE, pk);
            int blockSize = cipher.getBlockSize();
            ByteArrayOutputStream bout = new ByteArrayOutputStream(64);
            int j = 0;

            while (raw.length - j * blockSize > 0) {
                bout.write(cipher.doFinal(raw, j * blockSize, blockSize));
                j++;
            }
            return bout.toByteArray();
        }catch (Exception e){
            throw new Exception(e.getMessage());
        }
    }
    public static String decryptRSA(String password,String path) throws Exception {
        byte[] en_result = hexStringToBytes(password);
        byte[] de_result = RSAUtil.decrypt(RSAUtil.getKeyPair(path).getPrivate(),en_result);
        StringBuffer sb = new StringBuffer();
        sb.append(new String(de_result));
        String pwd = sb.reverse().toString();
        return pwd;
    }

    public static byte[] hexStringToBytes(String hexString){
        if(hexString == null){
            return null;
        }
        hexString = hexString.toUpperCase();
        int length = hexString.length() / 2;
        char[] hexChars = hexString.toCharArray();
        byte[] d = new byte[length];
        for(int i = 0; i < length;i++){
            int pos = i * 2;
            d[i] = (byte) (charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
        }
        return d;
    }
    private static byte charToByte(char c){
        return (byte) "0123456789ABCDEF".indexOf(c);
    }
}

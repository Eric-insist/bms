package com.bms.utils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class IdcardValidator {
    /**
     * 省，直辖市代码表： { 11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",
     * 21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",
     * 33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",
     * 42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",
     * 51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",
     * 63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"}
     */
    protected String codeAndCity[][] = { { "11", "北京" }, { "12", "天津" },
            { "13", "河北" }, { "14", "山西" }, { "15", "内蒙古" }, { "21", "辽宁" },
            { "22", "吉林" }, { "23", "黑龙江" }, { "31", "上海" }, { "32", "江苏" },
            { "33", "浙江" }, { "34", "安徽" }, { "35", "福建" }, { "36", "江西" },
            { "37", "山东" }, { "41", "河南" }, { "42", "湖北" }, { "43", "湖南" },
            { "44", "广东" }, { "45", "广西" }, { "46", "海南" }, { "50", "重庆" },
            { "51", "四川" }, { "52", "贵州" }, { "53", "云南" }, { "54", "西藏" },
            { "61", "陕西" }, { "62", "甘肃" }, { "63", "青海" }, { "64", "宁夏" },
            { "65", "新疆" }, { "71", "台湾" }, { "81", "香港" }, { "82", "澳门" },
            { "91", "国外" } };

    private String cityCode[] = { "11", "12", "13", "14", "15", "21", "22",
            "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43",
            "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63",
            "64", "65", "71", "81", "82", "91" };

    // 每位加权因子
    private int power[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };

    // 第18位校检码
    private String verifyCode[] = { "1", "0", "X", "9", "8", "7", "6", "5",
            "4", "3", "2" };

    /**
     * 验证所有的身份证的合法性
     *
     * @param idcard
     * @return
     */
    public boolean isValidatedAllIdcard(String idcard) {
        return this.isValidate18Idcard(idcard);
    }

    /**
     * <p>
     * 判断18位身份证的合法性
     * </p>
     * 根据〖中华人民共和国国家标准GB11643-1999〗中有关公民身份号码的规定，公民身份号码是特征组合码，由十七位数字本体码和一位数字校验码组成。
     * 排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码。
     * <p>
     * 顺序码: 表示在同一地址码所标识的区域范围内，对同年、同月、同 日出生的人编定的顺序号，顺序码的奇数分配给男性，偶数分配 给女性。
     * </p>
     * <p>
     * 1.前1、2位数字表示：所在省份的代码； 2.第3、4位数字表示：所在城市的代码； 3.第5、6位数字表示：所在区县的代码；
     * 4.第7~14位数字表示：出生年、月、日； 5.第15、16位数字表示：所在地的派出所的代码；
     * 6.第17位数字表示性别：奇数表示男性，偶数表示女性；
     * 7.第18位数字是校检码：也有的说是个人信息码，一般是随计算机的随机产生，用来检验身份证的正确性。校检码可以是0~9的数字，有时也用x表示。
     * </p>
     * <p>
     * 第十八位数字(校验码)的计算方法为： 1.将前面的身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7 9 10 5 8 4
     * 2 1 6 3 7 9 10 5 8 4 2
     * </p>
     * <p>
     * 2.将这17位数字和系数相乘的结果相加。
     * </p>
     * <p>
     * 3.用加出来和除以11，看余数是多少？
     * </p>
     * 4.余数只可能有0 1 2 3 4 5 6 7 8 9 10这11个数字。其分别对应的最后一位身份证的号码为1 0 X 9 8 7 6 5 4 3
     * 2。
     * <p>
     * 5.通过上面得知如果余数是2，就会在身份证的第18位数字上出现罗马数字的Ⅹ。如果余数是10，身份证的最后一位号码就是2。
     * </p>
     *
     * @param idcard
     * @return
     */
    public boolean isValidate18Idcard(String idcard) {
        // 非18位为假
        if (idcard.length() != 18) {
            return false;
        }
        // 获取前17位
        String idcard17 = idcard.substring(0, 17);
        // 获取第18位
        String idcard18Code = idcard.substring(17, 18);
        char c[] = null;
        String checkCode = "";
        // 是否都为数字
        if (isDigital(idcard17)) {
            c = idcard17.toCharArray();
        } else {
            return false;
        }

        if (null != c) {
            int bit[] = new int[idcard17.length()];

            bit = converCharToInt(c);

            int sum17 = 0;

            sum17 = getPowerSum(bit);

            // 将和值与11取模得到余数进行校验码判断
            checkCode = getCheckCodeBySum(sum17);
            if (null == checkCode) {
                return false;
            }
            // 将身份证的第18位与算出来的校码进行匹配，不相等就为假
            if (!idcard18Code.equalsIgnoreCase(checkCode)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 15位和18位身份证号码的基本数字和位数验校
     *
     * @param idcard
     * @return
     */
    public boolean isIdcard(String idcard) {
        return idcard == null || "".equals(idcard) ? false : Pattern.matches(
                "(^\\d{15}$)|(\\d{17}(?:\\d|x|X)$)", idcard);
    }


    /**
     * 18位身份证号码的基本数字和位数验校
     *
     * @param idcard
     * @return
     */
    public boolean is18Idcard(String idcard) {
        return Pattern
                .matches(
                        "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([\\d|x|X]{1})$",
                        idcard);
    }

    /**
     * 数字验证
     *
     * @param str
     * @return
     */
    public boolean isDigital(String str) {
        return str == null || "".equals(str) ? false : str.matches("^[0-9]*$");
    }

    /**
     * 将身份证的每位和对应位的加权因子相乘之后，再得到和值
     *
     * @param bit
     * @return
     */
    public int getPowerSum(int[] bit) {

        int sum = 0;

        if (power.length != bit.length) {
            return sum;
        }

        for (int i = 0; i < bit.length; i++) {
            for (int j = 0; j < power.length; j++) {
                if (i == j) {
                    sum = sum + bit[i] * power[j];
                }
            }
        }
        return sum;
    }

    /**
     * 将和值与11取模得到余数进行校验码判断
     *
     * @param sum17
     * @return 校验位
     */
    public String getCheckCodeBySum(int sum17) {
        String checkCode = null;
        switch (sum17 % 11) {
            case 10:
                checkCode = "2";
                break;
            case 9:
                checkCode = "3";
                break;
            case 8:
                checkCode = "4";
                break;
            case 7:
                checkCode = "5";
                break;
            case 6:
                checkCode = "6";
                break;
            case 5:
                checkCode = "7";
                break;
            case 4:
                checkCode = "8";
                break;
            case 3:
                checkCode = "9";
                break;
            case 2:
                checkCode = "x";
                break;
            case 1:
                checkCode = "0";
                break;
            case 0:
                checkCode = "1";
                break;
        }
        return checkCode;
    }

    /**
     * 将字符数组转为整型数组
     *
     * @param c
     * @return
     * @throws NumberFormatException
     */
    public int[] converCharToInt(char[] c) throws NumberFormatException {
        int[] a = new int[c.length];
        int k = 0;
        for (char temp : c) {
            a[k++] = Integer.parseInt(String.valueOf(temp));
        }
        return a;
    }
    public Integer IdcardInfoSex(String idcard) {
        Integer sex =0;
        try {
            int birthYearSpan = 4;
                // 获取性别
                String id17 = idcard.substring(16, 17);
                if (Integer.parseInt(id17) % 2 != 0) {
                    sex = 1;
                } else {
                    sex = 2;
                }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sex;
    }

    public Date IdcardInfoBirthday(String idcard) {

        Date birthdate=new Date();
        int birthYearSpan = 4;
        try {
            // 获取出生日期
            String year = (birthYearSpan == 2 ? "19" : "") + idcard.substring(6, 6 + birthYearSpan);
            String month = idcard.substring(6 + birthYearSpan, 6 + birthYearSpan + 2);
            String day = idcard.substring(8 + birthYearSpan, 8 + birthYearSpan + 2);
            String birthdays  = year + '-' + month + '-' + day;
            birthdate = new SimpleDateFormat("yyyy-MM-dd")
                    .parse(birthdays);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return birthdate;
    }
    /**
     * @param checkType 校验类型：0校验手机号码，1校验座机号码，2两者都校验满足其一就可
     * @param phoneNum
     * */
    public static boolean validPhoneNum(String checkType,String phoneNum){
        boolean flag=false;
        Pattern p1 = null;
        Pattern p2 = null;
        Matcher m = null;
        p1 = Pattern.compile("^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(17[0-9]{1}))+\\d{8})?$");
        p2 = Pattern.compile("^(0[0-9]{2,3}\\-)?([1-9][0-9]{6,7})$");
        if("0".equals(checkType)){
            System.out.println(phoneNum.length());
            if(phoneNum.length()!=11){
                return false;
            }else{
                m = p1.matcher(phoneNum);
                flag = m.matches();
            }
        }else if("1".equals(checkType)){
            if(phoneNum.length()<11||phoneNum.length()>=16){
                return false;
            }else{
                m = p2.matcher(phoneNum);
                flag = m.matches();
            }
        }else if("2".equals(checkType)){
            if(!((phoneNum.length() == 11 && p1.matcher(phoneNum).matches())||(phoneNum.length()<16&&p2.matcher(phoneNum).matches()))){
                return false;
            }else{
                flag = true;
            }
        }
        return flag;
    }
    public static boolean isValidDate(Date currentTime) {
        boolean convertSuccess = true;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        String dateString = formatter.format(currentTime);
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        if (dateString != null && !dateString.equals("")) {
            if (dateString.split("/").length > 1) {
                dateFormat = new SimpleDateFormat("yyyy/MM/dd");
            }
            if (dateString.split("-").length > 1) {
                dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            }
        } else {
            convertSuccess =false;
        }
        try {
            dateFormat.setLenient(false);
            dateFormat.parse(dateString);
        } catch (Exception e) {
            convertSuccess =false;
        }
        return convertSuccess;
    }

    public static void main(String[] args) throws Exception {
       /* String idcard18 = "18823235651";
        IdcardValidator iv = new IdcardValidator();
     *//*   System.out.println(iv.isValidatedAllIdcard(idcard18));
        System.out.println(iv.IdcardInfoSex(idcard18));
        System.out.println(iv.IdcardInfoBirthday(idcard18));*//*
        System.out.println(iv.validPhoneNum("0",idcard18));*/

      /*  String checkValue = "2008，09-11";
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        if (checkValue != null && !checkValue.equals("")) {
            if (checkValue.split("/").length > 1) {
                dateFormat = new SimpleDateFormat("yyyy/MM/dd");
            }
            if (checkValue.split("-").length > 1) {
                dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            }
        } else {
            return;
        }
        try {
            dateFormat.setLenient(false);
            dateFormat.parse(checkValue);
           *//* d = dateFormat.parse(checkValue);
            System.out.println(d);*//*
        } catch (Exception e) {
            System.out.println("格式错误");
            return;
        }*/
        String  str="畜牧";
        String s = str.replace(" ", "");
        System.out.println(s);
    }
}
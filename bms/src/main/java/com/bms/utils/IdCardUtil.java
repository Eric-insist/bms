package com.bms.utils;

import java.util.Calendar;

public class IdCardUtil {

    /**
     * 通过身份证获取年龄
     * @param idCard
     * @return
     */
    public static Integer getAge(String idCard){
        Calendar calendar = Calendar.getInstance();
        int yearNow = calendar.get(Calendar.YEAR);
        int monthNow = calendar.get(Calendar.MONTH);
        int dayNow = calendar.get(Calendar.DATE);

        int year = Integer.parseInt(idCard.substring(6,10));
        int month = Integer.parseInt(idCard.substring(10,12));
        int day = Integer.parseInt(idCard.substring(12,14));

        if (month < monthNow ||(month == monthNow && day <= dayNow)){
            return yearNow-year;
        }else {
            return yearNow-year-1;
        }
    }

    /**
     * 根据身份证获取性别
     * @param idCard
     * @return
     */
    public static Integer getSex(String idCard){
        return Integer.parseInt(idCard.substring(idCard.length() -4 ,idCard.length()-1)) % 2 == 1 ? 1 : 2;
    }
}

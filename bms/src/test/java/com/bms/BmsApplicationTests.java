package com.bms;

import com.bms.utils.Md5Encrypt;
import org.junit.jupiter.api.Test;
import org.mybatis.generator.api.MyBatisGenerator;
import org.mybatis.generator.config.Configuration;
import org.mybatis.generator.config.xml.ConfigurationParser;
import org.mybatis.generator.exception.InvalidConfigurationException;
import org.mybatis.generator.exception.XMLParserException;
import org.mybatis.generator.internal.DefaultShellCallback;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//@SpringBootTest
class BmsApplicationTests {

    @Test
    void contextLoads() {
        String str = "01车";
        System.out.println(str.replaceFirst("^0*",""));
    }

    @Test
    void md5(){
        String pwd = Md5Encrypt.md5("123456");
        System.out.println(pwd);
        Map map = new HashMap();

    }

    /**
     * mapper自动生成工具
     */
//    @Test
//    public void genCfg() {
//        List<String> warnings = new ArrayList<String>();
//        boolean overwrite = true;
//        String genCfg = "src/main/resources/generatorConfig.xml";
//        File configFile = new File(genCfg);
//        ConfigurationParser cp = new ConfigurationParser(warnings);
//        Configuration config = null;
//        try {
//            config = cp.parseConfiguration(configFile);
//        } catch (IOException e) {
//            e.printStackTrace();
//        } catch (XMLParserException e) {
//            e.printStackTrace();
//        }
//        DefaultShellCallback callback = new DefaultShellCallback(overwrite);
//        MyBatisGenerator myBatisGenerator = null;
//        try {
//            myBatisGenerator = new MyBatisGenerator(config, callback, warnings);
//        } catch (InvalidConfigurationException e) {
//            e.printStackTrace();
//        }
//        try {
//            myBatisGenerator.generate(null);
//        } catch (SQLException e) {
//            e.printStackTrace();
//        } catch (IOException e) {
//            e.printStackTrace();
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//    }

}

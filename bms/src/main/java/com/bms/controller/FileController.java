package com.bms.controller;

import cn.afterturn.easypoi.excel.ExcelImportUtil;
import cn.afterturn.easypoi.excel.entity.ImportParams;
import com.alibaba.fastjson.JSONArray;
import com.bms.common.ReturnResult;
import com.bms.model.BedRoom;
import com.bms.model.User;
import com.bms.model.excelVo.UserVo;
import com.bms.service.BedRoomService;
import com.bms.service.UserService;
import com.bms.utils.ExcelUtil;
import com.fasterxml.jackson.annotation.JsonFormat;
import jdk.nashorn.internal.parser.JSONParser;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/file")
public class FileController {

    @Autowired
    private BedRoomService bedRoomService;
    @Autowired
    private UserService userService;

    /**
     * excel导入寝室信息
     *
     * @param file
     * @return
     * @throws Exception
     */
    @PostMapping("/excelImport")
    public ReturnResult excelImport(@RequestParam("file") MultipartFile file, HttpServletRequest request
    ) throws Exception {
        System.out.println("开始导入数据...");
        String filePath = request.getSession().getServletContext().getRealPath("/excel");

        String dataPath = "/ImportExcel/";

        System.out.println("数据存入路径:" + filePath + dataPath);
        File uploadDir = new File(filePath + dataPath);
        //创建一个目录 （它的路径名由当前 File 对象指定，包括任一必须的父路径。）
        if (!uploadDir.exists()) uploadDir.mkdirs();
        String fileName = filePath + dataPath + UUID.randomUUID() + ".xlsx";
        //新建一个文件
        File tempFile = new File(fileName);
        try {
            //将上传的文件写入新建的文件中
            file.transferTo(tempFile);
            ImportParams params = new ImportParams();
            List<BedRoom> list = ExcelImportUtil.importExcel(new File(fileName), BedRoom.class, params);

            List<BedRoom> resultDataList = bedRoomService.insertByExcelImport(list);
            if (resultDataList.size() != 0) {
                return ReturnResult.SUCCESS("部分数据导入失败", resultDataList);
            }
        } catch (IOException e) {
            return ReturnResult.FAILURE(e.getMessage());
        }
        return ReturnResult.SUCCESS("导入成功");
    }


    /**
     * 批量办理入住
     * @param file
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping("/excelIn")
    public ReturnResult excelIn(@RequestParam("file") MultipartFile file, HttpServletRequest request
    ) throws Exception {
        System.out.println("开始导入数据...");
        String filePath = request.getSession().getServletContext().getRealPath("/excel");

        String dataPath = "/ImportExcel/";

        System.out.println("数据存入路径:" + filePath + dataPath);
        File uploadDir = new File(filePath + dataPath);
        //创建一个目录 （它的路径名由当前 File 对象指定，包括任一必须的父路径。）
        if (!uploadDir.exists()) uploadDir.mkdirs();
        String fileName = filePath + dataPath + UUID.randomUUID() + ".xlsx";
        //新建一个文件
        File tempFile = new File(fileName);
        try {
            //将上传的文件写入新建的文件中
            file.transferTo(tempFile);
            ImportParams params = new ImportParams();
            List<User> list = ExcelImportUtil.importExcel(new File(fileName), User.class, params);

            List<User> resultDataList = userService.insertByExcelImport(list);
            if (resultDataList.size() != 0) {
                return ReturnResult.SUCCESS("部分数据导入失败", resultDataList);
            }
        } catch (IOException e) {
            return ReturnResult.FAILURE(e.getMessage());
        }
        return ReturnResult.SUCCESS("导入成功");
    }

    /**
     * 文件下载
     *
     * @param request
     * @param response
     * @param storeName
     * @throws Exception
     */
    @GetMapping("/downloadFileRename")
    public static void download(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestParam(value = "filePath", required = true) String storeName,
            @RequestParam(value = "realName", required = true) String realName)
            throws Exception {
        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;
        // 获取项目根目录
        String ctxPath = request.getSession().getServletContext()
                .getRealPath("/excel");
        // 获取下载文件露肩
        String downLoadPath = ctxPath + "/" + storeName;
        try {

            File file = new File(downLoadPath);
            if (!file.exists()) {
                response.sendError(404, "File not found!");
                return;
            }
            // 获取文件的长度
            // 设置文件输出类型
            // 清空response
            response.reset();
            response.setContentType("application/octet-stream");// 设置类型
            response.setHeader("Pragma", "No-cache");// 设置头
            response.setHeader("Cache-Control", "no-cache");
            response.setDateHeader("Expires", 0);// 设置日期头
            response.setHeader("Content-disposition", "attachment; filename="
                    + new String(realName.getBytes("utf-8"), "ISO8859-1"));
            // 设置输出长度
            response.setHeader("Content-Length", String.valueOf(file.length()));
            // 获取输入流
            bis = new BufferedInputStream(new FileInputStream(file));
            // 输出流
            bos = new BufferedOutputStream(response.getOutputStream());
            byte[] buff = new byte[2048];
            int bytesRead;
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 关闭流
            if (bis != null) {
                bis.close();
            }
            if (bos != null) {
                bos.close();
            }
        }
    }

    /**
     * 导出（前端需要用location.href 或者 window.open()请求才可以）
     * @param list
     * @param request
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/excelExport", produces = { "application/json;charset=UTF-8" })
    public void excelExport(@RequestParam("list") String list,HttpServletRequest request, HttpServletResponse response) throws Exception{
        long beginTime = System.currentTimeMillis();
        List<BedRoom> list1 = (List<BedRoom>) JSONArray.parse(list);
        ExcelUtil.exportExcel(list1, "失败数据", "失败数据", BedRoom.class, "导入失败数据", response);
        long endTime = System.currentTimeMillis();
        System.out.println("cast:"+ (endTime - beginTime));
    }
}

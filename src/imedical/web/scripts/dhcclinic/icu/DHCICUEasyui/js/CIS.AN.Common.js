var archive={
    saveArchive:function(filePath){
        var saveDatas=[{
            ClassName:ANCLS.Model.RecordSheet,
            RowId:session.RecordSheetID,
            FileUser:session.UserID,
            FileDate:"today",
            FileTime:"now",
            FilePath:filePath
        }];

        var saveStr=dhccl.formatObjects(saveDatas);
        var saveResult=dhccl.saveDatas(ANCSP.DataListService,{
            jsonData:saveStr
        });

        return saveResult;
    },

    sendArchive:function(opts){
        if(!opts){
            $.messager.alert("提示","参数不能为空！","error");
            return;
        }
        if(!opts.operSchedule){
            $.messager.alert("提示","手术申请参数不能为空！","error");
            return;
        }
        if(!opts.fileName){
            $.messager.alert("提示","PDF文件名参数不能为空！","error");
            return;
        }
        if(!opts.report){
            $.messager.alert("提示","报表名参数不能为空！","error");
            return;
        }
        var _this=this;
        var fileDir=_this.getFileDir(opts.operSchedule);
        if(!fileDir){
            $.messager.alert("提示","无法获取到存储归档文件的目录！","error");
            return;
        }
        var fileName=opts.fileName;
        if(fileDir){
            fileName+=fileName;
        }
        var taskId=opts.taskId || "";
        $.post("http://"+session.ArchiveServerIP+":"+session.ArchiveServerPort+"/printreport",{
            "ReportType": "gridreport",     /*报表类型 gridreport fastreport reportmachine 为空 将默认为gridreport  */	
            "ReportName": opts.report+".grf",     /*报表文件名 测试报表 */
            "ReportVersion": 1,              /*可选。报表版本, 为空则默认1  如果本地报表的版本过低 将从 ReportUrl 地址进行下载更新*/
            "ReportUrl": "",                  /*可选。为空 将不更新本地报表 , 如果本地报表不存在可以从该地址自动下载*/
            "Copies": 0,                    /*可选。打印份数，支持指定打印份数。默认1份,如果为零,不打印,只返回报表生成的pdf,jpg等文件*/
            "PrinterName": "",      /*可选。指定打印机，为空的话 使用默认打印机, 请在 控制面板 -> 设备和打印机 中查看您的打印机的名称 */
            "PrintOffsetX": 0,                 /*可选。打印右偏移，单位厘米。报表的水平方向上的偏移量，向右为正，向左为负。*/
            "PrintOffsetY": 0,                /*可选。打印下偏移，单位厘米。 报表的垂直方向上的偏移量，向下为正，向上为负。*/
            "Preview": 0,                 /*可选。是否预览，和主界面设置的效果一样 为空默认不预览,   0：不预览，1：预览(弹出导出的pdf,jpg等文件)。*/
            "token": "",      /*可选。只要token值在列表中 方可打印*/
            "taskId": taskId,     /*可选。多个打印任务同时打印时，根据该id确定返回的是哪个打印任务。 */ 
            "exportfilename": fileName,      /*可选。自定义 导出 文件名称 为空 或者 自定义名称 如 test */ 
            "exportfiletype": "pdf",      /*可选。自定义 导出 文件格式 为空 或者 自定义名称 如 pdf  */ 
            "Parameter": opts.parameter
        },function(data){
            data = decodeURIComponent(data);
            if(data==""){
                alert("连接HttpPrinter失败");
            }else{
                var obj = JSON.parse(data);
                if(obj.status=="ok"){
                    var saveArchive=_this.saveArchive(obj.data);
                    if(saveArchive.indexOf("S^")===0){
                        $.messager.alert("提示","归档成功！","info",function(){
                            //window.open(obj.data);
                            var recordBrowser=new RecordBrowser({
                                title:opts.operSchedule.PatName+"的"+opts.moduleName,
                                href:obj.data
                            });
                            recordBrowser.open();
                        });
                    }else{
                        $.messager.alert("提示","归档失败:"+saveArchive,"error");
                    }
                }else{
                    $.messager.alert("提示","归档失败:"+obj.data,"error");
                }
            }
        });
    },

    getFileDir:function(operSchedule){
        if(operSchedule && operSchedule.OperDate && operSchedule.RowId){
            var operDateArr=operSchedule.OperDate.split("-");
            var operDateYear=operDateArr[0],operDateMonth=operDateArr[1],operDateDay=operDateArr[2];
            return operDateYear+"\\"+operDateMonth+"\\"+operDateDay+"\\"+operSchedule.RowId+"\\";
        }
        return "";
    }
}
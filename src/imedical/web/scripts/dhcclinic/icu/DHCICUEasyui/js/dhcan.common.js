// $(document).ready(function() {
//     openChrome();
// });

// function openChrome() {
//     var queryString = window.location.search;
//     //alert(queryString);
//     var linkUrl = "dhcan.default.csp";
//     linkUrl = linkUrl + queryString + "&userId=" + session.UserID + "&deptId=" + session.DeptID + "&groupId=" + session.GroupID;
//     var hrefArr = window.location.href.split("/csp/");
//     linkUrl = "chrome.exe --disable-infobars --test-type --ignore-certificate-errors " + hrefArr[0] + "/csp/" + linkUrl;
//     var wsh = new ActiveXObject("WScript.Shell");
//     wsh.Run(linkUrl);
//     window.close();
// }

var CLCOM={};
CLCOM.initOptions=function(){
    this.comObj=null;
    this.port="COM1";
    this.bundRate="115200";
    try {
        this.comObj=new ActiveXObject("DHCClinic.Common");
    } catch (error) {
        console.log(error.message);
    }
}

/**
 * 打开串口
 */
CLCOM.openComm=function(){
    var ret="";
    if(this.comObj){
        this.comObj.OpenCom(this.port,this.bundRate);
        ret="S^";
    }
    return ret;
}

CLCOM.closeComm=function(){
    var ret="";
    if(this.comObj){
        this.comObj.CloseComm();
        ret="S^";
    }
    return ret;
}

var FTPWeb={
    serverIP:"111.111.116.29",
    delFlag:"Y",
    localPath:"D:\\DHCClinic",
    initOptions:function(options){
        this.lodop=options.lodop;
        this.clcom=options.clcom;
        if(!this.clcom){
            this.clcom=new ActiveXObject("DHCClinic.Common");
        }
        this.printer=options.printer;
        this.fileName=options.fileName;
        this.operDate=options.operDate;
        this.opsId=options.opsId;
        this.waitTime=0;
        this.printJobID="";
        this.timeOut=null;
    },
    getFtpPath:function(){
        var operDate=new Date(this.operDate);
        
        // 需引用dhcan.datetime.js
        var ftpPath=operDate.format("yyyy")+"\\"+operDate.format("MM")+"\\"+operDate.format("dd")+"\\"+this.opsId;

        return ftpPath;
    },
    uploadFiles:function(successFn){
        if(this.lodop.SET_PRINTER_INDEX(this.printer)){
            this.lodop.SET_PRINT_MODE("CATCH_PRINT_STATUS",true);
            this.printJobID=this.lodop.PRINT();
            //this.waitFor();
            setTimeout(function(){console.log("test");},10000);
            if(this.lodop.GET_VALUE("PRINT_STATUS_EXIST",this.printJobID)){
                //alert("test2");
                var ftpPath=this.getFtpPath();
                var uploadRet=this.clcom.UploadFiles(this.serverIP,ftpPath,this.localPath,this.fileName,this.delFlag);
                if(uploadRet==="S^"){
                    console.log("success");
                    if(successFn){
                        successFn(this.serverIP,ftpPath,this.fileName);
                    }
                }
            }
            
        }
    },
    waitFor:function(){
        this.waitTime=this.waitTime+1;    
        //document.getElementById('T12B').value="正等待(JOB代码是"+jobID+")打印结果："+c+"秒";
        this.timeOut=setTimeout("this.waitFor()",1000);  
        console.log(this.timeOut);  
        // if (this.lodop.GET_VALUE("PRINT_STATUS_OK",this.printJobID)) {
        //     clearTimeout(this.timeOut);
        //     //document.getElementById('T12B').value="打印成功！";
        //     this.waitTime=0;
        //     //alert("打印成功！");
        // }
        if (!this.lodop.GET_VALUE("PRINT_STATUS_EXIST",this.printJobID)) {
            //alert("test1");
            clearTimeout(this.timeOut);
            //document.getElementById('T12B').value="打印任务被删除！";
            this.waitTime=0;
            //alert("打印任务被删除！");
        } else if (this.waitTime>30){
            clearTimeout(this.timeOut);
            //document.getElementById('T12B').value="打印超时(30秒)！";
            this.waitTime=0;
            //alert("打印超过30秒没捕获到成功状态！");		
        };
    }
}
$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
});

function initPage(){
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });

    $("#btnPreANSave").linkbutton({
        onClick:function(){
            if(session.GroupDesc==="手术室护士" || session.GroupDesc==="手术室护士长" || session.GroupDesc==="手术室管理员"){
                $("#PreANSurgeonChecked").attr("data-value","Y");
                $("#PreANNurseChecked").attr("data-value","Y");
            }else{
                $("#PreANAnaestChecked").attr("data-value","Y");
            }
            operDataManager.saveOperDatas("#PreANSafetyCheck .operdata");
            initStatusButton();
        }
    });

    $("#btnPreOPSave").linkbutton({
        onClick:function(){
            if(session.GroupDesc==="手术室护士" || session.GroupDesc==="手术室护士长" || session.GroupDesc==="手术室管理员"){
                $("#PreOPSurgeonChecked").attr("data-value","Y");
                $("#PreOPNurseChecked").attr("data-value","Y");
            }else{
                $("#PreOPAnaestChecked").attr("data-value","Y");
            }
            operDataManager.saveOperDatas("#PreOPSafetyCheck .operdata");
            initStatusButton();
        }
    });

    $("#btnPreOutSave").linkbutton({
        onClick:function(){
            if(session.GroupDesc==="手术室护士" || session.GroupDesc==="手术室护士长" || session.GroupDesc==="手术室管理员"){
                $("#PreOutSurgeonChecked").attr("data-value","Y");
                $("#PreOutNurseChecked").attr("data-value","Y");
            }else{
                $("#PreOutAnaestChecked").attr("data-value","Y");
            }
            operDataManager.saveOperDatas("#PreOutSafetyCheck .operdata");
            initStatusButton();
        }
    });

    $("#btnPrint").linkbutton({
        onClick: printOperSafetyCheck
    });

    $("#btnPrintAll").linkbutton({
        onClick: printOperSafetyCheckAll
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

    $("#btnSurgeonSign").linkbutton({
        onClick:function(){
            var dataIntegrity=operDataManager.isDataIntegrity("#PreANSafetyCheck .operdata");
            if(dataIntegrity===false){
                $.messager.alert("提示","麻醉前核查数据不完整，不能签名。","warning");
                return;
            }
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode,
                printCallBack:printOperSafetyCheckPDF
            });
            signView.initView();
            signView.open();
        }
    });

    $("#btnAnaestSign").linkbutton({
        onClick:function(){
            var dataIntegrity=operDataManager.isDataIntegrity("#PreOPSafetyCheck .operdata");
            if(dataIntegrity===false){
                $.messager.alert("提示","手术前核查数据不完整，不能签名。","warning");
                return;
            }
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode,
                printCallBack:printOperSafetyCheckPDF
            });
            signView.initView();
            signView.open();
        }
    });

    $("#btnOperNurseSign").linkbutton({
        onClick:function(){
            var dataIntegrity=operDataManager.isDataIntegrity("#PreOutSafetyCheck .operdata");
            if(dataIntegrity===false){
                $.messager.alert("提示","离室前核查数据不完整，不能签名。","warning");
                return;
            }
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode,
                printCallBack:printOperSafetyCheckPDF
            });
            signView.initView();
            signView.open();
        }
    });

    // $(".sign-btn").linkbutton({
    //     onClick: function () {
    //         var dataIntegrity=operDataManager.isDataIntegrity(".operdata");
    //         if(dataIntegrity===false){
    //             $.messager.alert("提示","数据不完整，不能签名。","warning");
    //             return;
    //         }
    //         var signCode = $(this).attr("data-signcode");
    //         var originalData = JSON.stringify(operDataManager.getOperDatas());
    //         var signView = new SignView({
    //             container: "#signContainer",
    //             originalData: originalData,
    //             signCode: signCode,
    //             printCallBack:printOperSafetyCheckPDF
    //         });
    //         signView.initView();
    //         signView.open();
    //     }
    // });

    initStatusButton();
}

function initStatusButton(){
    var preanSurgeonChecked=$("#PreANSurgeonChecked").attr("data-value"),
        preanNurseChecked=$("#PreANNurseChecked").attr("data-value"),
        preanAnaestChecked=$("#PreANAnaestChecked").attr("data-value"),
        preopSurgeonChecked=$("#PreOPSurgeonChecked").attr("data-value"),
        preopNurseChecked=$("#PreOPNurseChecked").attr("data-value"),
        preopAnaestChecked=$("#PreOPAnaestChecked").attr("data-value"),
        preoutSurgeonChecked=$("#PreOutSurgeonChecked").attr("data-value"),
        preoutNurseChecked=$("#PreOutNurseChecked").attr("data-value"),
        preoutAnaestChecked=$("#PreOutAnaestChecked").attr("data-value");
    var preanChecked=((preanAnaestChecked==="Y") && (preanNurseChecked==="Y") && (preanAnaestChecked==="Y")),
        preopChecked=((preopAnaestChecked==="Y") && (preopNurseChecked==="Y") && (preopAnaestChecked==="Y")),
        preoutChecked=((preoutAnaestChecked==="Y") && (preoutNurseChecked==="Y") && (preoutAnaestChecked==="Y"));
    if(session.GroupDesc==="手术室护士" || session.GroupDesc==="手术室护士长" || session.GroupDesc==="手术室管理员"){
        preanChecked=preanNurseChecked;
        preopChecked=preopNurseChecked;
        preoutChecked=preoutNurseChecked;
    }else{
        preanChecked=preanAnaestChecked;
        preopChecked=preopAnaestChecked;
        preoutChecked=preoutAnaestChecked;
    }
    if(preanChecked){
        $("#btnPreOPSave").linkbutton("enable");
        $("#btnPreANSave").linkbutton("enable");
        $("#btnPreOutSave").linkbutton("disable");
        $("#btnPrint").linkbutton("disable");
    }else{
        $("#btnPreOPSave").linkbutton("disable");
        $("#btnPreANSave").linkbutton("enable");
        $("#btnPreOutSave").linkbutton("disable");
        $("#btnPrint").linkbutton("disable");
        return;
    }
    if(preopChecked){
        $("#btnPreOPSave").linkbutton("enable");
        $("#btnPreANSave").linkbutton("enable");
        $("#btnPreOutSave").linkbutton("enable");
        $("#btnPrint").linkbutton("disable");
    }else{
        $("#btnPreOPSave").linkbutton("enable");
        $("#btnPreANSave").linkbutton("enable");
        $("#btnPreOutSave").linkbutton("disable");
        $("#btnPrint").linkbutton("disable");
        return;
    }
    if(preoutChecked){
        $("#btnPreOPSave").linkbutton("enable");
        $("#btnPreANSave").linkbutton("enable");
        $("#btnPreOutSave").linkbutton("enable");
        $("#btnPrint").linkbutton("enable");
    }else{
        $("#btnPreOPSave").linkbutton("enable");
        $("#btnPreANSave").linkbutton("enable");
        $("#btnPreOutSave").linkbutton("enable");
        $("#btnPrint").linkbutton("disable");
    }
}

var operSchedule;
function loadApplicationData(appData) {
    if(!appData) return;
    // $("#PatName").text(appData.PatName);
    // $("#PatGender").text(appData.PatGender);
    // $("#PatAge").text(appData.PatAge);
    // $("#PatDept").text(appData.PatDeptDesc);
    // $("#PatMedCareNo").text(appData.MedcareNo);
    // $("#OperationDesc").text(appData.OperationDesc);
    // $("#SurgeonDesc").text(appData.SurgeonDesc);
    // $("#OperDate").text(appData.OperDate);
    // $("#AnaMethodDesc").text(appData.PrevAnaMethodDesc);
    operSchedule=appData;
    
}

function printOperSafetyCheck() {
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperSafetyCheck"+session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	createPrintOnePage(lodop);
	lodop.PREVIEW();
}

function printOperSafetyCheckAll(){
    
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperSafetyCheck"+session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
	createPrintOnePage(lodop);
	lodop.NEWPAGE();
	createOperRiskAssessmentPage(lodop);
	lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
	lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
	lodop.PREVIEW();
}

function printOperSafetyCheckPDF(){
    // operDataManager.reloadPatInfo(loadApplicationData);
    // var lodop = getLodop();
    // lodop.SET_PRINT_PAGESIZE(1,0,0,PrintSetting.AuditSign.Paper);
    // createPrintOnePage(lodop);
    // if (parent.printTask){
    //     lodop.NEWPAGE();
    //     parent.printTask("OperRiskAssessment",lodop);
    // }
    // FTPWeb.initOptions({
    //     lodop:lodop,
    //     printer:PrintSetting.AuditSign.Printer,
    //     fileName:"OperSafetyCheck"+session.OPSID,
    //     operDate:operSchedule.OperDate,
    //     opsId:session.OPSID
    // });
    // FTPWeb.uploadFiles();
    // if(lodop.SET_PRINTER_INDEXA(PrintSetting.AuditSign.Printer)){
    //     lodop.SET_PRINT_MODE("CATCH_PRINT_STATUS",true);
    //     var jobID=lodop.PRINT();
    //     WaitFor();
    //     if(lodop.GET_VALUE("PRINT_STATUS_EXIST",jobID)){
    //         var operDate=new Date($("#OperDate").text());
    //         var ftpPath=operDate.format("yyyy")+"\\"+operDate.format("MM")+"\\"+operDate.format("dd")+"\\"+session.OPSID;
    //         var uploadRet=dhcclcomm.UploadFiles("111.111.116.29",ftpPath,"D:\\DHCClinic","OperCount"+session.OPSID,"Y");
    //         if(uploadRet==="S^"){
    //             console.log("success");
    //         }
    //     }
        
    // }
}

function createPrintOnePage(lodop) {
    // lodop.PRINT_INIT("OperSafetyCheck"+session.OPSID);
    // lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");

    lodop.SET_PRINT_STYLE("FontSize", 11);
    lodop.ADD_PRINT_TEXT(35, 300, "100%", 60, "山西省肿瘤医院手术安全核查表");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    lodop.ADD_PRINT_TEXT(75, 20, 200, 15, "科别："+(operSchedule?operSchedule.PatDeptDesc:""));
    lodop.ADD_PRINT_TEXT(75, 220, 200, 15, "患者姓名："+(operSchedule?operSchedule.PatName:""));
    lodop.ADD_PRINT_TEXT(75, 360, 200, 15, "性别："+(operSchedule?operSchedule.PatGender:""));
    lodop.ADD_PRINT_TEXT(75, 460, 200, 15, "年龄："+(operSchedule?operSchedule.PatAge:""));
    lodop.ADD_PRINT_TEXT(75, 560, 200, 15, "病案号："+(operSchedule?operSchedule.MedcareNo:""));
    var anaestMethodInfo=operSchedule?operSchedule.AnaestMethodInfo:""
    if (!anaestMethodInfo || anaestMethodInfo===""){
        anaestMethodInfo=operSchedule?operSchedule.PrevAnaMethodDesc:"";
    }
    lodop.ADD_PRINT_TEXT(100, 20, 200, 15, "麻醉方式："+(anaestMethodInfo));
    lodop.ADD_PRINT_TEXT(100, 360, 200, 15, "手术医生："+(operSchedule?operSchedule.SurgeonDesc:""));
    lodop.ADD_PRINT_TEXT(100, 560, 200, 15, "手术日期："+(operSchedule?operSchedule.OperDate:""));
    lodop.ADD_PRINT_TEXT(125, 20, "100%", 15, "手术方式："+(operSchedule?operSchedule.OperationDesc:""));

    lodop.ADD_PRINT_RECT(150,20,240,30,0,1);
    lodop.ADD_PRINT_TEXT(159, 20, 240, 30, "麻醉实施前");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.ADD_PRINT_RECT(150,260,240,30,0,1);
    lodop.ADD_PRINT_TEXT(159, 260, 240, 30, "手术开始前");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.ADD_PRINT_RECT(150,500,240,30,0,1);
    lodop.ADD_PRINT_TEXT(159, 500, 240, 30, "患者离室前");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 12);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);

    lodop.ADD_PRINT_RECT(180,20,240,720,0,1);
    lodop.ADD_PRINT_TEXT(190,25,240,20, "患者姓名、性别、年龄正确：");
    lodop.ADD_PRINT_TEXT(210,180,240,20, "是");
    lodop.ADD_PRINT_RECT(210,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(210,192,12,12,$("#PreanPatInfoCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(210,220,240,20, "否");
    lodop.ADD_PRINT_RECT(210,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(210,232,12,12,$("#PreanPatInfoCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(240,25,240,20, "手术方式确认：");
    lodop.ADD_PRINT_TEXT(240,180,240,20, "是");
    lodop.ADD_PRINT_RECT(240,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(240,192,12,12,$("#PreanOperCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(240,220,240,20, "否");
    lodop.ADD_PRINT_RECT(240,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(240,232,12,12,$("#PreanOperCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(270,25,240,20, "手术部位与标识正确：");
    lodop.ADD_PRINT_TEXT(270,180,240,20, "是");
    lodop.ADD_PRINT_RECT(270,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(270,192,12,12,$("#PreanBodySiteAndMarkCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(270,220,240,20, "否");
    lodop.ADD_PRINT_RECT(270,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(270,232,12,12,$("#PreanBodySiteAndMarkCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(300,25,240,20, "手术知情同意：");
    lodop.ADD_PRINT_TEXT(300,180,240,20, "是");
    lodop.ADD_PRINT_RECT(300,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(300,192,12,12,$("#SurgicalConsentCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(300,220,240,20, "否");
    lodop.ADD_PRINT_RECT(300,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(300,232,12,12,$("#SurgicalConsentCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(330,25,240,20, "麻醉知情同意： ");
    lodop.ADD_PRINT_TEXT(330,180,240,20, "是");
    lodop.ADD_PRINT_RECT(330,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(330,192,12,12,$("#AnaestConsentCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(330,220,240,20, "否");
    lodop.ADD_PRINT_RECT(330,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(330,232,12,12,$("#AnaestConsentCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(360,25,240,20, "麻醉设备安全检查完成： ");
    lodop.ADD_PRINT_TEXT(360,180,240,20, "是");
    lodop.ADD_PRINT_RECT(360,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(360,192,12,12,$("#AnaDeviceSafetyCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(360,220,240,20, "否");
    lodop.ADD_PRINT_RECT(360,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(360,232,12,12,$("#AnaDeviceSafetyCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(390,25,240,20, "皮肤是否完整： ");
    lodop.ADD_PRINT_TEXT(390,180,240,20, "是");
    lodop.ADD_PRINT_RECT(390,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(390,192,12,12,$("#PreanIntackSkinCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(390,220,240,20, "否");
    lodop.ADD_PRINT_RECT(390,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(390,232,12,12,$("#PreanIntackSkinCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(420,25,240,20, "术前皮肤准备确认：");
    lodop.ADD_PRINT_TEXT(420,180,240,20, "是");
    lodop.ADD_PRINT_RECT(420,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(420,192,12,12,$("#PrepareSkinCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(420,220,240,20, "否");
    lodop.ADD_PRINT_RECT(420,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(420,232,12,12,$("#PrepareSkinCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(450,25,240,20, "静脉通道建立完成： ");
    lodop.ADD_PRINT_TEXT(450,180,240,20, "是");
    lodop.ADD_PRINT_RECT(450,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(450,192,12,12,$("#IntravenousAccessCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(450,220,240,20, "否");
    lodop.ADD_PRINT_RECT(450,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(450,232,12,12,$("#IntravenousAccessCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(480,25,240,20, "患者是否有过敏史： ");
    lodop.ADD_PRINT_TEXT(480,180,240,20, "是");
    lodop.ADD_PRINT_RECT(480,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(480,192,12,12,$("#AllergicHistoryCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(480,220,240,20, "否");
    lodop.ADD_PRINT_RECT(480,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(480,232,12,12,$("#AllergicHistoryCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(510,25,240,20, "抗菌药物皮试结果： ");
    lodop.ADD_PRINT_TEXT(510,180,240,20, "是");
    lodop.ADD_PRINT_RECT(510,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(510,192,12,12,$("#AntibioticsSkinTestResultCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(510,220,240,20, "否");
    lodop.ADD_PRINT_RECT(510,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(510,232,12,12,$("#AntibioticsSkinTestResultCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(540,25,240,20, "术前备血： ");
    lodop.ADD_PRINT_TEXT(540,180,240,20, "是");
    lodop.ADD_PRINT_RECT(540,195,12,12,0,1);
    lodop.ADD_PRINT_TEXT(540,192,12,12,$("#PrepareBloodCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(540,220,240,20, "否");
    lodop.ADD_PRINT_RECT(540,235,12,12,0,1);
    lodop.ADD_PRINT_TEXT(540,232,12,12,$("#PrepareBloodCheckingCHK2").checkbox("getValue")?"√":"");
    
    lodop.ADD_PRINT_TEXT(570,25,240,20, "假体");
    lodop.ADD_PRINT_RECT(570,55,12,12,0,1);
    if(!$("#Prosthesis").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(570,56,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(570,52,12,12,$("#Prosthesis").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(570,80,240,20, "体内植入物");
    lodop.ADD_PRINT_RECT(570,155,12,12,0,1);
    if(!$("#ImplantationMaterials").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(570,156,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(570,152,12,12,$("#ImplantationMaterials").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(600,25,240,20, "影像学资料");
    lodop.ADD_PRINT_RECT(600,100,12,12,0,1);
    if(!$("#ImagingData").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(600,101,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(600,97,12,12,$("#ImagingData").checkbox("getValue")?"√":"/");
    }
    

    lodop.ADD_PRINT_TEXT(850, 25, 240, 30, "其他");
    lodop.ADD_PRINT_LINE(865,55,865,250,0,1);
    lodop.ADD_PRINT_TEXT(850,162,240,30,$("#PreanOtherInfo").val()===""?"/":$("#PreanOtherInfo").val());

    

    lodop.ADD_PRINT_RECT(180,260,240,720,0,1);
    lodop.ADD_PRINT_TEXT(190,265,240,20, "患者姓名、性别、年龄正确：");
    lodop.ADD_PRINT_TEXT(210,420,240,20, "是");
    lodop.ADD_PRINT_RECT(210,435,12,12,0,1);
    lodop.ADD_PRINT_TEXT(210,432,12,12,$("#PreopPatInfoCheckingCHK1").checkbox("getValue")?"√":"");
    // lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    // lodop.SET_PRINT_STYLEA(0, "Bold", 1);
    lodop.ADD_PRINT_TEXT(210,460,240,20, "否");
    lodop.ADD_PRINT_RECT(210,475,12,12,0,1);
    lodop.ADD_PRINT_TEXT(210,472,12,12,$("#PreopPatInfoCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(240,265,240,20, "手术方式确认：");
    lodop.ADD_PRINT_TEXT(240,420,240,20, "是");
    lodop.ADD_PRINT_RECT(240,435,12,12,0,1);
    lodop.ADD_PRINT_TEXT(240,432,12,12,$("#PreopOperCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(240,460,240,20, "否");
    lodop.ADD_PRINT_RECT(240,475,12,12,0,1);
    lodop.ADD_PRINT_TEXT(240,472,12,12,$("#PreopOperCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(270,265,240,20, "手术部位与标识正确：");
    lodop.ADD_PRINT_TEXT(270,420,240,20, "是");
    lodop.ADD_PRINT_RECT(270,435,12,12,0,1);
    lodop.ADD_PRINT_TEXT(270,432,12,12,$("#PreopBodySiteAndMarkCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(270,460,240,20, "否");
    lodop.ADD_PRINT_RECT(270,475,12,12,0,1);
    lodop.ADD_PRINT_TEXT(270,472,12,12,$("#PreopBodySiteAndMarkCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(300, 265, 240, 30, "手术、麻醉风险预警：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 10);

    lodop.ADD_PRINT_TEXT(330, 265, 240, 30, "手术医师陈述：");
    lodop.ADD_PRINT_TEXT(360, 385, 240, 30, "预计手术时间");
    lodop.ADD_PRINT_RECT(360,475,12,12,0,1);
    if(!$("#EstimateOperationTime").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(360,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(360,472,12,12,$("#EstimateOperationTime").checkbox("getValue")?"√":"");
    }
    //lodop.ADD_PRINT_TEXT(360,472,12,12,$("#EstimateOperationTime").checkbox("getValue")?"√":"/");
    lodop.ADD_PRINT_TEXT(390, 400, 240, 30, "预计失血量");
    lodop.ADD_PRINT_RECT(390,475,12,12,0,1);
    if(!$("#EstimateBloodLoss").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(390,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(390,472,12,12,$("#EstimateBloodLoss").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(420, 400, 240, 30, "手术关注点");
    lodop.ADD_PRINT_RECT(420,475,12,12,0,1);
    if(!$("#SurgicalAttention").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(420,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(420,472,12,12,$("#SurgicalAttention").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(450, 445, 240, 30, "其他");
    lodop.ADD_PRINT_RECT(450,475,12,12,0,1);
    if(!$("#SurgeonPresentationCHK4").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(450,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(450,472,12,12,$("#SurgeonPresentationCHK4").checkbox("getValue")?"√":"");
    }
    

    lodop.ADD_PRINT_TEXT(480, 265, 240, 30, "麻醉医师陈述：");
    lodop.ADD_PRINT_TEXT(510, 400, 240, 30, "麻醉关注点");
    lodop.ADD_PRINT_RECT(510,475,12,12,0,1);
    if(!$("#AnestheticAttention").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(510,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(510,472,12,12,$("#AnestheticAttention").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(540, 445, 240, 30, "其他");
    lodop.ADD_PRINT_RECT(540,475,12,12,0,1);
    if(!$("#AnesthetistPresentation").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(541,475,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(540,472,12,12,$("#AnesthetistPresentation").checkbox("getValue")?"√":"");
    }
    

    lodop.ADD_PRINT_TEXT(570, 265, 240, 30, "手术护士陈述：");
    lodop.ADD_PRINT_TEXT(600, 385, 240, 30, "物品灭菌合格");
    lodop.ADD_PRINT_RECT(600,475,12,12,0,1);
    if(!$("#SterilizationGoods").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(600,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(600,472,12,12,$("#SterilizationGoods").checkbox("getValue")?"√":"");
    }
    
    
    lodop.ADD_PRINT_TEXT(630, 415, 240, 30, "仪器设备");
    lodop.ADD_PRINT_RECT(630,475,12,12,0,1);
    if(!$("#Instrumenttation").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(630,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(630,472,12,12,$("#Instrumenttation").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(660, 320, 240, 30, "术前术中特殊用药情况");
    lodop.ADD_PRINT_RECT(660,475,12,12,0,1);
    if(!$("#SpecialDrugUse").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(660,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(660,472,12,12,$("#SpecialDrugUse").checkbox("getValue")?"√":"/");
    }
    
    lodop.ADD_PRINT_TEXT(690, 445, 240, 30, "其他");
    lodop.ADD_PRINT_RECT(690,475,12,12,0,1);
    if(!$("#OperNursePresentationCHK4").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(690,476,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(690,472,12,12,$("#OperNursePresentationCHK4").checkbox("getValue")?"√":"");
    }
    

    lodop.ADD_PRINT_TEXT(720,265,240,20, "是否需要影像资料：");
    lodop.ADD_PRINT_TEXT(720,420,240,20, "是");
    lodop.ADD_PRINT_RECT(720,435,12,12,0,1);
    if(!$("#NeedImagingDataCHK1").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(720,436,12,12,"");
    }else{
        lodop.ADD_PRINT_TEXT(720,432,12,12,$("#NeedImagingDataCHK1").checkbox("getValue")?"√":"");
    }
    
    
    lodop.ADD_PRINT_TEXT(720,460,240,20, "否");
    lodop.ADD_PRINT_RECT(720,475,12,12,0,1);
    if(!$("#NeedImagingDataCHK2").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(720,476,12,12,"");
    }else{
        lodop.ADD_PRINT_TEXT(720,472,12,12,$("#NeedImagingDataCHK2").checkbox("getValue")?"√":"");
    }
    

    lodop.ADD_PRINT_TEXT(850, 265, 240, 30, "其他");
    lodop.ADD_PRINT_LINE(865,295,865,490,0,1);
    lodop.ADD_PRINT_TEXT(850,405,240,30,$("#PreopOtherInfo").val()===""?"/":$("#PreopOtherInfo").val());

    lodop.ADD_PRINT_RECT(180,500,240,720,0,1);
    lodop.ADD_PRINT_TEXT(190,505,240,20, "患者姓名、性别、年龄正确：");
    lodop.ADD_PRINT_TEXT(210,660,240,20, "是");
    lodop.ADD_PRINT_RECT(210,675,12,12,0,1);
    lodop.ADD_PRINT_TEXT(210,672,12,12,$("#PreoutPatInfoCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(210,700,240,20, "否");
    lodop.ADD_PRINT_RECT(210,715,12,12,0,1);
    lodop.ADD_PRINT_TEXT(210,712,12,12,$("#PreoutPatInfoCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(240,505,240,20, "实际手术方式确认：");
    lodop.ADD_PRINT_TEXT(240,660,240,20, "是");
    lodop.ADD_PRINT_RECT(240,675,12,12,0,1);
    lodop.ADD_PRINT_TEXT(240,672,12,12,$("#PreoutOperCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(240,700,240,20, "否");
    lodop.ADD_PRINT_RECT(240,715,12,12,0,1);
    lodop.ADD_PRINT_TEXT(240,712,12,12,$("#PreoutOperCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(270,505,240,20, "手术用药、输血的核查：");
    lodop.ADD_PRINT_TEXT(270,660,240,20, "是");
    lodop.ADD_PRINT_RECT(270,675,12,12,0,1);
    lodop.ADD_PRINT_TEXT(270,672,12,12,$("#OperDrugAndBloodCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(270,700,240,20, "否");
    lodop.ADD_PRINT_RECT(270,715,12,12,0,1);
    lodop.ADD_PRINT_TEXT(270,712,12,12,$("#OperDrugAndBloodCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(300,505,240,20, "手术用物清点正确：");
    lodop.ADD_PRINT_TEXT(300,660,240,20, "是");
    lodop.ADD_PRINT_RECT(300,675,12,12,0,1);
    lodop.ADD_PRINT_TEXT(300,672,12,12,$("#SurgicalInstrumentCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(300,700,240,20, "否");
    lodop.ADD_PRINT_RECT(300,715,12,12,0,1);
    lodop.ADD_PRINT_TEXT(300,712,12,12,$("#SurgicalInstrumentCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(330,505,240,20, "手术标本确认：");
    lodop.ADD_PRINT_TEXT(330,660,240,20, "是");
    lodop.ADD_PRINT_RECT(330,675,12,12,0,1);
    lodop.ADD_PRINT_TEXT(330,672,12,12,$("#SurgicalSpecimenCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(330,700,240,20, "否");
    lodop.ADD_PRINT_RECT(330,715,12,12,0,1);
    lodop.ADD_PRINT_TEXT(330,712,12,12,$("#SurgicalSpecimenCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(360,505,240,20, "皮肤是否完整：");
    lodop.ADD_PRINT_TEXT(360,660,240,20, "是");
    lodop.ADD_PRINT_RECT(360,675,12,12,0,1);
    lodop.ADD_PRINT_TEXT(360,672,12,12,$("#PreoutIntackSkinCheckingCHK1").checkbox("getValue")?"√":"");
    lodop.ADD_PRINT_TEXT(360,700,240,20, "否");
    lodop.ADD_PRINT_RECT(360,715,12,12,0,1);
    lodop.ADD_PRINT_TEXT(360,712,12,12,$("#PreoutIntackSkinCheckingCHK2").checkbox("getValue")?"√":"");

    lodop.ADD_PRINT_TEXT(390, 505, 240, 30, "各种管路");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 10);
    lodop.ADD_PRINT_TEXT(420, 625, 240, 30, "中心静脉通路");
    lodop.ADD_PRINT_RECT(420,715,12,12,0,1);
    if(!$("#IntubationCHK1").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(420,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(420,712,12,12,$("#IntubationCHK1").checkbox("getValue")?"√":"/");
    }
    
    lodop.ADD_PRINT_TEXT(450, 655, 240, 30, "动脉通路");
    lodop.ADD_PRINT_RECT(450,715,12,12,0,1);
    if(!$("#IntubationCHK2").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(450,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(450,712,12,12,$("#IntubationCHK2").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(480, 655, 240, 30, "气管插管");
    lodop.ADD_PRINT_RECT(480,715,12,12,0,1);
    if(!$("#IntubationCHK3").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(480,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(480,712,12,12,$("#IntubationCHK3").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(510, 655, 240, 30, "伤口引流");
    lodop.ADD_PRINT_RECT(510,715,12,12,0,1);
    if(!$("#IntubationCHK4").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(510,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(510,712,12,12,$("#IntubationCHK4").checkbox("getValue")?"√":"/");
    }
    
    lodop.ADD_PRINT_TEXT(540, 685, 240, 30, "胃管");
    lodop.ADD_PRINT_RECT(540,715,12,12,0,1);
    if(!$("#IntubationCHK5").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(540,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(540,712,12,12,$("#IntubationCHK5").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(570, 685, 240, 30, "尿管");
    lodop.ADD_PRINT_RECT(570,715,12,12,0,1);
    if(!$("#IntubationCHK6").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(570,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(570,712,12,12,$("#IntubationCHK6").checkbox("getValue")?"√":"/");
    }
    
    lodop.ADD_PRINT_TEXT(600, 510, 240, 30, "其他");
    lodop.ADD_PRINT_LINE(615,540,615,715,0,1);
    if($("#AddlIntubation").val()===""){
        lodop.ADD_PRINT_TEXT(600, 620, 240, 30, "/");
    }else{
        var text=$("#AddlIntubation").val();
        var fontSize=dhccl.getFontSize(text,175);
        lodop.ADD_PRINT_TEXT(600, 542, 170, 40, $("#AddlIntubation").val()===""?"/":$("#AddlIntubation").val());
        //lodop.SET_PRINT_STYLEA(0, "FontSize", fontSize);

    }
    
    lodop.ADD_PRINT_RECT(600,715,12,12,0,1);
    if(!$("#IntubationCHK7").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(600,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(600,712,12,12,$("#IntubationCHK7").checkbox("getValue")?"√":"");
    }
    

    lodop.ADD_PRINT_TEXT(650, 505, 240, 30, "患者去向");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 10);

    lodop.ADD_PRINT_TEXT(670, 670, 240, 30, "恢复室");
    lodop.ADD_PRINT_RECT(670,715,12,12,0,1);
    if(!$("#PatientWhereaboutsCHK1").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(670,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(670,712,12,12,$("#PatientWhereaboutsCHK1").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(700, 685, 240, 30, "病房");
    lodop.ADD_PRINT_RECT(700,715,12,12,0,1);
    if(!$("#PatientWhereaboutsCHK2").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(700,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(700,712,12,12,$("#PatientWhereaboutsCHK2").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(730, 660, 240, 30, "ICU病房");
    lodop.ADD_PRINT_RECT(730,715,12,12,0,1);
    if(!$("#PatientWhereaboutsCHK3").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(730,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(730,712,12,12,$("#PatientWhereaboutsCHK3").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(760, 685, 240, 30, "急诊");
    lodop.ADD_PRINT_RECT(760,715,12,12,0,1);
    if(!$("#PatientWhereaboutsCHK4").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(760,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(760,712,12,12,$("#PatientWhereaboutsCHK4").checkbox("getValue")?"√":"");
    }
    
    lodop.ADD_PRINT_TEXT(790, 685, 240, 30, "离院");
    lodop.ADD_PRINT_RECT(790,715,12,12,0,1);
    if(!$("#PatientWhereaboutsCHK5").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(790,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(790,712,12,12,$("#PatientWhereaboutsCHK5").checkbox("getValue")?"√":"");
    }

    lodop.ADD_PRINT_TEXT(820, 670, 240, 30, "未离室");
    lodop.ADD_PRINT_RECT(820,715,12,12,0,1);
    if(!$("#PatientWhereaboutsCHK6").checkbox("getValue")){
        lodop.ADD_PRINT_TEXT(820,716,12,12,"/");
    }else{
        lodop.ADD_PRINT_TEXT(820,712,12,12,$("#PatientWhereaboutsCHK6").checkbox("getValue")?"√":"");
    }
    

    lodop.ADD_PRINT_TEXT(850, 505, 240, 30, "其他");
    lodop.ADD_PRINT_LINE(865,535,865,730,0,1);
    lodop.ADD_PRINT_TEXT(850,645,240,30,$("#PreoutOtherInfo").val()===""?"/":$("#PreoutOtherInfo").val());

    var imgSrc=$("#SurgeonSign").attr("src");
    var imgHtml="<img "+((imgSrc && imgSrc!="")?("src='"+imgSrc+"'"):"")+">";
    lodop.ADD_PRINT_TEXT(920, 25, 240, 30, "手术医生签名：");
    lodop.ADD_PRINT_IMAGE(950,30,"100%","100%",imgHtml);

    imgSrc=$("#AnaestSign").attr("src");
    imgHtml="<img "+((imgSrc && imgSrc!="")?("src='"+imgSrc+"'"):"")+">";
    lodop.ADD_PRINT_TEXT(920, 265, 240, 30, "麻醉医生签名：");
    lodop.ADD_PRINT_IMAGE(950,270,"100%","100%",imgHtml);

    imgSrc=$("#OperNurseSign").attr("src");
    imgHtml="<img "+((imgSrc && imgSrc!="")?("src='"+imgSrc+"'"):"")+">";
    lodop.ADD_PRINT_TEXT(920, 505, 240, 30, "手术护士签名：");
    lodop.ADD_PRINT_IMAGE(950,510,"100%","100%",imgHtml);

    // var printStyleCss = $("head").html();
    // $(":text").each(function(i, obj) {
    //     $(":text").eq(i).attr("value", obj.value);
    // })
    // $(":checkbox").each(function(i, obj) {
    //     $(":checkbox").eq(i).attr("checked", obj.checked);
    // });

    // var buttonStyle="<style>.hisui-linkbutton{display:none;} span.checkbox-list{display:inline-flex;} .hischeckbox_square-blue {display:none;}</style>"
    // var html = "<head>" + printStyleCss+buttonStyle +"</head>" + "<body>" + $("#dataForm").html() + "</body>";
    // //$(html).find(".hischeckbox_square-blue").addClass("hover");
    // // lodop.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
    // lodop.ADD_PRINT_HTML(140, 0, "100%", "100%", html);

}
function initPage(){
    operDataManager.initFormData();
    initButton();
    initAppForm(); 
    operDataManager.setCheckChange();
    signCommon.loadSignature();
    // $("#OperPressCarryover1").checkbox("setValue",true)
}

/**
 * 初始化手术申请表单
 */
function initAppForm(){
    loadAppFormData();
}

function initButton()
{
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
        }
    });
    $("#btnPrint").linkbutton({
        onClick: printOperOperPressuresore
    });

    $("#btnRefresh").linkbutton({
        onClick:function(){
            window.location.reload();
        }
    });

}

function msg(value, name) {
	var signCode = $(this).attr("id");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
            signCommon.loadSignatureCommon();
}

var operCount={
    schedule:null,
    contextMenu:null,
    contextMenuD:null,
    clickColumn:null
};

function loadAppFormData(){
    $("#OperPressuresoreForm").form("clear");
    setOperAppData();
    //operCount.schedule=operApplication;
}

function setOperAppData(){
    let opsId=dhccl.getQueryString("opsId");
    var appDatas=dhccl.getDatas(ANCSP.DataQuery,{
        ClassName:ANCLS.BLL.OperScheduleList,
        QueryName:"FindOperScheduleList",
        Arg1:"",
        Arg2:"",
        Arg3:"",
        Arg4:opsId,
        ArgCnt:4
    },"json");
    if(appDatas && appDatas.length>0){
        var appData=appDatas[0];
        $("#OperPressuresoreForm").form("load",appData);
    }
}

function loadApplicationData(operApplication) {
    operCount.schedule=operApplication;
}

function setPrintCheckBox(){
    $("input[type='checkbox']").each(function(index,el){
        var printSelector="#"+$(this).attr("id")+"_Print";
        if($(printSelector).length<=0) return;
        //$(printSelector).addClass("print-checkbox-print");
        $(printSelector).text($(this).checkbox("getValue")?"√":"");
        if($(this).checkbox("getValue"))$(printSelector).addClass('print-checkbox-checked');
    });
}

function setPrintTextkBox(){
    $("input[type='text']").each(function(index,el){
        var printSelector="#"+$(this).attr("id")+"_Print";
        if($(printSelector).length<=0) return;
        //$(printSelector).addClass("print-checkbox-print");
       // $(printSelector).text($(this).text());
       $(printSelector).text($(this).val());
        var tt=$(this).val();
        //if($(this).text()) 
        
        if($(this).attr("class").indexOf("hisui-datetimebox") !== -1 )
        {
            var tt=$(this).datebox('getValue');
            $(printSelector).text($(this).datebox('getValue'));
        }
        $(printSelector).addClass('print-textbox-value');
    });
}

function printOperOperPressuresore() {
    //operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperRiskAssessment" + session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX",2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    operDataManager.reloadPatInfo(loadApplicationData);
    createPrintOnePage(lodop,operCount.schedule);
    lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
    lodop.PREVIEW();

}

function createPrintOnePage(lodop,operSchedule) {  
    
    var prtConfig=sheetPrintConfig,
    logoMargin=prtConfig.logo.margin,
    logoSize=prtConfig.logo.size,
    titleFont=prtConfig.title.font,
    titleSize=prtConfig.title.size,
    titleMargin=prtConfig.title.margin,
    contentSize=prtConfig.content.size,
    contentFont=prtConfig.content.font;
lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);
    // lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    // lodop.SET_PRINT_STYLE("FontName", "宋体");
    lodop.SET_PRINT_STYLE("FontSize", 11);
    //var hospName=getHospital();
    var startPos={
        x:prtConfig.paper.margin.left,
        y:logoMargin.top+logoSize.height+logoMargin.bottom
    };
    
    //lodop.ADD_PRINT_TEXT(70, 300, "100%", 60, session.ExtHospDesc);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "3S手术患者压疮高危因素评估量表");
    lodop.SET_PRINT_STYLEA(0, "FontName", titleFont.name);
    lodop.SET_PRINT_STYLEA(0, "FontSize", titleFont.size);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "HOrient", 2);
    
    startPos.y+=titleSize.height+titleMargin.bottom;
    var lineHeight=20;
    /*lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "姓名："+(operSchedule?operSchedule.PatName:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+120, 200, 15, "性别："+(operSchedule?operSchedule.PatGender:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 200, 15, "年龄："+(operSchedule?operSchedule.PatAge:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+300, 200, 15, "科室："+(operSchedule?operSchedule.PatDeptDesc:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+460, 200, 15, "床号："+(operSchedule?operSchedule.PatBedCode:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "住院号："+(operSchedule?operSchedule.MedcareNo:""));
    var anaestMethodInfo=operSchedule?operSchedule.AnaestMethodInfo:""
    if (!anaestMethodInfo || anaestMethodInfo===""){
        anaestMethodInfo=operSchedule?operSchedule.PrevAnaMethodDesc:"";
    }
    startPos.y+=lineHeight;
    //lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "手术日期:"+(operSchedule?operSchedule.OperDate:""));
    var operInfo=$("#OperationDesc").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "手术方式：");
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+70, 470, 30, operSchedule?operSchedule.OperDesc:"");

    startPos.y+=lineHeight;  //+(operInfo.length>40?25:0);

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 400, 15, "麻醉方式:"+(operSchedule?operSchedule.AnaMethodDesc:""));

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 200, 15, "手术体位:"+(operSchedule?operSchedule.OperPositionDesc:""));
    */
    startPos.y+=lineHeight;

    setPrintCheckBox();
    setPrintTextkBox();

    var html="<html><head>"+$("head").html();
    html+="<style> .hisui-linkbutton,.hisui-checkbox,.hischeckbox_square-blue,.textbox {display:none}";
    html+="img.signature {border:none;}"
    html+=".print-checkbox {font-size:11px; width:9px;height: 9px;border: 2px solid #000;display: inline-block;text-align: center;line-height: 10px;}"
    html+=".print-checkbox-checked {font-size:16px; width:9px;height: 9px;display: inline-block;text-align: center;line-height: 10px; font-weight: bold;}"
    html+=".print-textbox-value {display: inline-block}</style></head>"
    html+="<body>"+$("#OperPressuresore").html();
    html+=" <div><div class=form-row><div class=form-item style=width:500px>巡回护士签字："+$("#CircualNurseSign").triggerbox("getValue")+"</div><div class=form-item>";
    html+="<div class=form-item>时间:"+$("#SignTime").datebox('getValue')+"</div><div class=form-item></div></div></div></body></html>";
    //html+=" </td><td>麻醉医师签名:"+$("#AnesthetistSign").triggerbox("getValue")+"<span class=form-title-right6 style=width:140px;>"
    //html+="</td><td>巡回护士签名:"+$("#OperNurseSign").triggerbox("getValue")+"<span class=form-title-right6 style=width:140px;></span>"

    lodop.ADD_PRINT_HTM(startPos.y,0,1088,"100%",html);

    lodop.SET_PRINT_MODE("FULL_WIDTH_FOR_OVERFLOW",true);//宽度溢出缩放
    lodop.SET_PRINT_MODE("FULL_HEIGHT_FOR_OVERFLOW",true);//高度溢出缩放

}
$(document).ready(initPage);


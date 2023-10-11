/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.19
 *  Description 门诊药房--处方预览-发药
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "FY";
PHAOP_COM.VAR.PermissionTpe = "FY";
PHAOP_COM.VAR.CAModelCode = "PHAOPExecuteFY";
PHAOP_COM.VAR.TIMER = "";
PHAOP_COM.VAR.TIMERSTEP = 30 * 1000;
PHAOP_COM.VAR.WayId = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", PHAOP_COM.VAR.WayType);
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
var CurPatNo = "";      //主要记录是否按人查询，发药
var IfPatNoEnter = "";
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  验证人员权限
    InitGridWaitList();     //  处方列表
    InitGridPrescList();    //  处方列表
    InitEvent();            //  按钮事件
    ResizePanel();          //  布局调整
    Clean();                //  包含初始化查询条件
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    
    //切换窗口
    PHA_EVENT.Bind('#btnChangeWin',     'click', function () {ChangeWin();});
    //表格 toolbar
    PHA_EVENT.Bind('#btnFY',            'click', function () {
        PHAOP_COM.CACert({},ExecuteFY);
    });
    PHA_EVENT.Bind('#btnRefuse',        'click', function () {ExecuteRefuseFY();});
    PHA_EVENT.Bind('#btnCancelRefuse',  'click', function () {CancelRefuseFY();});
    PHA_EVENT.Bind('#btnPrintPresc',    'click', function () {PrintHandler("2");});
    PHA_EVENT.Bind('#btnPrintLabel',    'click', function () {PrintHandler("3");});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnReturn',        'click', function () {Return();});
    //待发药列标
    PHA_EVENT.Bind('#btnFresh',             'click', function () {QueryWaitList();});
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                IfPatNoEnter = true;
                QueryPrescList();
            }
        }
    });
    //卡号回车事件
    $('#cardNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardNo = $.trim($("#cardNo").val());
            IfPatNoEnter = true;
            if (cardNo != "") {
                ReadCard();
            }
        }
    });
    //跨窗口标志是否可见
    if(APP_PROP.FYDispAllowNoJudgWin != "Y"){
        $('#td-crossFlag').css('display', 'none');
    }
}
// 布局调整
function ResizePanel(){
    setTimeout(function () {    
        var flag = 0.5;
        if(PHA_COM.Window.Width()<1500 ){flag = 0.6}         

        PHA_COM.ResizePanel({
            layoutId: 'layout-op—grid',
            region: 'west',
            width: flag 
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—grid-presc',
            region: 'south',
            height: 0.5 
        });
    }, 0);
}
// 初始化查询条件
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
}
function InitGridWaitList(){
    COMPOMENTS.WaitGrid("gridWaitList",{
        toolbar : '#gridWaitListBar',
        onSelect : function(rowIndex, rowData) {
            $('#patNo').val(rowData.tbpatid);
            QueryPrescList();
            
        }
    })
}
function InitGridPrescList(){
     COMPOMENTS.PrescListGrid("gridPrescList",{
         columns: COMPOMENTS.Columns.FYMain.Normal(),
         frozenColumns: COMPOMENTS.Columns.FYMain.Frozen(),
         toolbar : [],
         onSelect : function(rowIndex, rowData) {
            QueryPrescDetail();
            var prescNo = rowData.TPrescNo;
            PHAOP_COM.InitErpMenu({prescNo:prescNo});   
        },onCheck : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onUncheck : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onCheckAll : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onUncheckAll : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onLoadSuccess : function(data) {
            if(data.total>0){
                //加载核对界面数据
                var fyFlag = $("#fyFlag").checkbox('getValue');
                if(fyFlag != true){
                    if ((IfPatNoEnter == true)&&(PHAOP_COM.DEFAULT.FYCheck == "Y")) {
                        ShowCheckFyWin(data.rows[0].TPmiNo);
                    }
                    if(IfPatNoEnter == true){
                        PHAOP_COM.SendOPInfoToMachine({
                            faceCode:"105", 
                            prescNo:data.rows[0].TPrescNo, 
                            patNo:data.rows[0].TPmiNo
                        });
                    }
                }
                $('#gridPrescList').datagrid("selectRow",0);
            }else{
                $("#ifrm-PreViewPresc").attr("src", "");
            }
            IfPatNoEnter = false;
        }
    })
}

function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    if(PHAOP_COM.DEFAULT.phlId == ""){return false;}
    pJson.phlId = PHAOP_COM.DEFAULT.phlId;
    pJson.winIdStr = PHAOP_COM.DEFAULT.winIdStr;
    pJson.phPerId = PHAOP_COM.DEFAULT.phPerId;

    return pJson;
}
// 查询处方列表
function QueryPrescList(){
    CurPatNo = ""
    PHAOP_COM.ClearErpMenu(); // 清除电子病历菜单需要的参数
    var fyFlag = $("#fyFlag").checkbox('getValue');
    var patNo = $("#patNo").val();
    if((APP_PROP.OnlyDispByPatNo == "Y")&&(patNo == "")&&(fyFlag == false)){
        PHAOP_COM._Msg("error","请输入登记号或卡号后,再次查询!");
        Setfocus();
        return;
    }
    var $grid =  $("#gridPrescList");
    var pJson = GetParams();
    if(pJson==false){return;}
    CurPatNo = $("#patNo").val();
    if(CurPatNo == ""){IfPatNoEnter = false;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyDisp.Api' ,
        pMethodName:'GetPrescList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
     setTimeout(function () {
        if(!$("#fyFlag").checkbox('getValue')){
            PHAOP_COM.ChkUnFyOtherLoc({});
        }
        Setfocus();
    },100)
}
// 查询处方明细
function QueryPrescDetail(){    
    var $grid =  $("#gridPrescList");
    var selRowData = $grid.datagrid('getSelected');
    if(selRowData == null){return}
    var prescNo = selRowData.TPrescNo;
    var cyFlag = PHAOP_COM.DEFAULT.cyFlag;
    var dispFlag = selRowData.TFyFlag;
    var pharType = "OP";        // 门诊类型
    var zfFlag = "底方"
    if (dispFlag !== "OK"){
        var useFlag = "3"       // 未发药
    }
    else {
        var useFlag = "4"       // 已发药
    }
    
    PHA_PRESC.PREVIEW({
        prescNo: prescNo,           
        preAdmType: pharType,
        zfFlag: zfFlag,
        prtType: 'DISPPREVIEW',
        useFlag: useFlag,
        iframeID: 'ifrm-PreViewPresc',
        cyFlag: cyFlag
    });
}

function QueryWaitList(){
    var $grid =  $("#gridWaitList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyDisp.Api' ,
        pMethodName:'GetNeedFYList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
    PHAOP_COM.ClearErpMenu();
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescList').datagrid("uncheckAll")
    $("#ifrm-PreViewPresc").attr("src", "");
    $('#gridWaitList').datagrid('clear');
    InitDefVal();
    QueryWaitList();
    Setfocus();
    CurPatNo = "";
    IfPatNoEnter == false;

    
}
// 读卡
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
// 发药
function ExecuteFY(){
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "明细没有数据！");
        return false;
    }
    var chkFlag = ChkBefDisp();
    if(chkFlag == false){return false;}
    var checkedRows = $grid.datagrid('getChecked');
    var retVal ;
    var index;
    var tipMsg = "";
    var dspNum = 0;
    var prescStr = "";
    if (checkedRows.length >0){
        if(checkedRows.length>1) tipMsg = "您已选择多张处方，是否同时发药?"
        else{tipMsg = $g("您通过勾选进行发药，是否发药？")+ "<span>"+ checkedRows[0].TPrescNo +"</span>"}
        PHAOP_COM._Confirm($g("发药"), tipMsg, function (r) {
            if (r) {    
                var len = checkedRows.length;          
                for (var i = 0;i<len ; i++) {
                    var rowData = checkedRows[i];
                    index = rows.indexOf(rowData);
                    retVal = CheckPayment(index)
                    if(retVal){
                        dspNum = dspNum + 1;
                        if (prescStr=="")prescStr = rowData.TPrescNo;
                        else{prescStr = prescStr + "," + rowData.TPrescNo;}
                    }
                }
                if(dspNum>0){ChkUnFyThisLoc(dspNum)}
                QueryWaitList();
                Setfocus();
            } 
        });

    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            index = $grid.datagrid('getRowIndex',rowData)
            retVal =  CheckPayment(index);
            if(retVal){
                dspNum = 1
                prescStr = rowData.TPrescNo;
            }
        }else{
            PHAOP_COM._Msg('error', "请选择发药数据！");    
        }
        if(dspNum>0){ChkUnFyThisLoc(dspNum)}
        QueryWaitList();
        Setfocus();
    }
    
}

/// 是否可以发药
function ChkBefDisp(){
    var $grid = $("#gridPrescList");
    var checkedRows = $grid.datagrid('getChecked');
    var patNum = 0;
    var tmpPatNo = "";
    var patNo = "";
    var fyFlag =""
    var len = checkedRows.length;
    if (len >0){
        for (var i = 0;i<len ; i++) {
            var rowData = checkedRows[i];
            fyFlag = rowData.TFyFlag;
            patNo = rowData.TPmiNo;
            if(fyFlag == "OK"){
                PHAOP_COM._Msg('error', rowData.TPrescNo+$g("已发药！"));
                return false;
            }
            if(APP_PROP.OnlyDispByPatNo == "Y"){
                if((tmpPatNo != "")&&(tmpPatNo != patNo)){
                    PHAOP_COM._Msg('error', $g("按设置，不允许多患者同时发药!"));
                    return false;
                }
            }
            tmpPatNo = patNo        
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            fyFlag = rowData.TFyFlag;
            if(fyFlag == "OK"){
                PHAOP_COM._Msg('error',"<span>"+ rowData.TPrescNo + "</span>"+ $g("已发药！"));
                return false;
            }
        }else{
            PHAOP_COM._Msg('error', "请选择配药数据！");
            return false;           
        }
    }
    return true;
}
// 发药
function Dispening(index){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo;
    var pJson ={
        phlId : PHAOP_COM.DEFAULT.phlId,
        winIdStr : PHAOP_COM.DEFAULT.winIdStr,
        phPerId : PHAOP_COM.DEFAULT.phPerId,
        phdId : rowData.phdrow,
        prescNo : prescNo
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.PyDisp.Api',
        pMethodName: 'SaveDispData',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var phdId = retVal.data;
        var updData = {
            TFyFlag : "OK",
            phdrow : phdId,
            TPhDispStat:$g("已发药")
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        $grid.datagrid('refreshRow', index)
        OP_PRINTCOM.PrintPrescHandler({
            prescNo:prescNo,
            prtType:APP_PROP["FY.PrintType"],
            phdId:phdId,
            rePrint:"",
            defPrintorFlag:""
        })
        PHAOP_COM.SendOPInfoToMachine({
            faceCode:"104,108,110", 
            prescNo:prescNo, 
            patNo:rowData.TPmiNo
        }); //104发药灭灯 108发药时下屏 110发送机(处方状态)
        PHAOP_COM.SaveCACert({
            signVal:phdId,
            type:"F"
        })
        return true;
    }else{
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// 拒绝发药
function ExecuteRefuseFY(){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg("error", "没有需拒绝发药的记录");
        return
    }
    var phdStat = rowData.TPhDispStat;
    if(phdStat.indexOf($g("已发药"))>-1){
        PHAOP_COM._Msg("error", "处方已发药，不允许拒绝发药");
        return;
    }
    var auditStat = rowData.TDocSS;
    if(auditStat.indexOf($g("拒绝发药"))>-1){
        PHAOP_COM._Msg("error", "处方已拒绝发药，不需要再次拒绝发药");
        return;
    }
    var prescNo = rowData.TPrescNo;
    PHAOP_COM.ShowPHAPRASelReason({
        wayId: "",      //PHAOP_COM.VAR.WayId
        oeori: "",
        prescNo: prescNo,
        selType: "PRESCNO"
    }, SaveCommontResultEX, {
        prescNo: prescNo
    }); 
}
function SaveCommontResultEX(reasonStr, origOpts) {
    var $grid = $("#gridPrescList");
    if (reasonStr == "") {
        return "";
    }
    var prescNo = origOpts.prescNo
    var retArr = reasonStr.split("@");
    var ret = "N";
    var reasonDr = retArr[0];
    var adviceTxt = retArr[2];
    var facTxt = retArr[1];
    var phNote = retArr[3];
    if (reasonDr.indexOf("$$$") == "-1") {
        reasonDr = reasonDr + "$$$" + prescNo;
    }
    var pJson = {
        prescNo : prescNo,
        reasonDr : reasonDr,
        auditFlag :ret,
        userId :PHAOP_COM.LogonData.UserId,
        adviceTxt:adviceTxt,
        facTxt:facTxt,
        phNote:phNote,
        groupId : PHAOP_COM.LogonData.GroupId,
        wayType :"OR"
    }
    var rowData = $grid.datagrid('getSelected');
    var selIndex = $grid.datagrid('getRowIndex',rowData);//获取行号

    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'SaveOPAuditResult',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TDocSS : $g("拒绝发药")
        }   
        $grid.datagrid('updateRowData', {
            index: selIndex,
            row: updData
        });
        PHAOP_COM._Msg("success","保存成功!");
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// 取消拒绝发药
function CancelRefuseFY(){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){return}
    var selIndex = $grid.datagrid('getRowIndex',rowData);//获取行号
    var prescNo = rowData.TPrescNo;
    var pJson = {
        prescNo : prescNo,
        wayType:"OR",
        userId :PHAOP_COM.LogonData.UserId
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'CancelRefuse',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var auditInfo = retVal.data;
        var updData = {
            TDocSS : auditInfo
        }   
        $grid.datagrid('updateRowData', {
            index: selIndex,
            row: updData
        });
        PHAOP_COM._Msg("success","保存成功!");
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
    
}
function PrintHandler(type){
    var $grid = $("#gridPrescList");
    var checkedRows = $grid.datagrid('getChecked');
    var len = checkedRows.length;
    if (len >0){
        for (var i = 0;i<len ; i++) {
            var rowData = checkedRows[i];
            RePrint(rowData,type)
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            RePrint(rowData,type)
        }else{
            PHAOP_COM._Msg('error', "请选择打印数据！");
            return false;           
        }
    }
    return true;
}
function RePrint(rowData,type){
    OP_PRINTCOM.PrintPrescHandler({
        prescNo:rowData.TPrescNo,
        prtType:type,
        phdId:rowData.phdrow,
        rePrint:"(补)"
    })
}
// 退药
function Return(){
    var lnk = "pha.op.v4.return.csp";
    websys_createWindow(lnk, $g("退药"), "width=95%,height=75%")
}

// 切换窗口
function ChangeWin(){
    var ret = COMPOMENTS.Window.Open({
        locId :PHA_COM.Session.CTLOCID,
        type:PHAOP_COM.VAR.WinType
    },Clean)
    
}
// 人员权限
function CheckPermission(){
    PHAOP_COM.CheckPermission({
        permissionType:PHAOP_COM.VAR.PermissionTpe
    },Clean)
}
// 查询or配药后光标位置
function Setfocus()
{
    $("#patNo").val("");
    $("#cardNo").val("");
    if(APP_PROP.FocusFlag == 1){
        $('#cardNo').focus();
    }
    else{
        $('#patNo').focus();
    }
}

/* 检查收费情况 */
function CheckPayment(index){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo
    var pJson = {
        prescNo : prescNo,
    }
    /* 获取处方中的未交费医嘱信息 */
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'GetUnPaidInfo',
        pJson: JSON.stringify(pJson)
    },false);
    var unPaidInfo = retVal.data;
    var retFlag;
        /* 存在未交费时是否允许发药 */
    if (unPaidInfo !== ""){
        if (APP_PROP.PartPiedDispFlag == "Y") {
            retFlag = Dispening(index); 
            return retFlag;
        }
        else {
            PHAOP_COM._Alert(prescNo + $g("中存在未交费的医嘱明细,禁止发药!医嘱名称为:") + "<br/>" + unPaidInfo)
            return false;
        }
    }
    else{
        retFlag = Dispening(index); 
        return retFlag  
    }   
}
function ChkUnFyThisLoc(dspPrescNum){
    if((APP_PROP.ChkUnDispPrescNum != "Y")&&(APP_PROP.TipDispPrescNum != "Y")){return}
    var patNo = CurPatNo;
    var $grid = $("#gridPrescList");
    if(dspPrescNum != 1){
        var rowsData = $grid.datagrid('getRows');
        var rowNum = rowsData.length;    
        var successNum=0;
        for (var rowi = 0; rowi < rowNum; rowi++) {
            rowData = rowsData[rowi]
            var okFlag = rowData.TFyFlag;        
            if(okFlag == "OK")successNum = successNum + 1
        }
        dspPrescNum = successNum;
    }
    var alertMsg = "";
    var tipDispNum = "";
    tipDispNum = $g("此次发药处方数：")+ "<span>" + dspPrescNum + "</span>"; 
    
    if (patNo!=""){
        if(APP_PROP.ChkUnDispPrescNum == "Y"){
            var phlId=PHAOP_COM.DEFAULT.phlId;
            var winId = PHAOP_COM.DEFAULT.winIdStr;
            var stDate = $("#stDate").datebox("getValue")|| ""; 
            var endDate = $("#endDate").datebox("getValue")|| ""; 

            var unDspNum=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyThisLoc",stDate,endDate,patNo,phlId)
            var otherLocRet=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyOtherLoc",stDate,endDate,patNo,phlId,winId)
            if (unDspNum < 0) unDspNum=0
            if (unDspNum > 0) { 
                var prescNum = parseInt(unDspNum) + dspPrescNum;
                alertMsg= $g("该患者当前药房共缴费待发处方数：")+prescNum;
                if(tipDispNum != "")  alertMsg = alertMsg + "</br>" + tipDispNum
                alertMsg = alertMsg + "</br>" + $g("待发处方数：")+unDspNum
                if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
            }else if (otherLocRet!="") {
                alertMsg = otherLocRet;
            }
        }
    }
    if((alertMsg == "")&&(APP_PROP.TipDispPrescNum == "Y")){
        alertMsg =  tipDispNum;
    }
    if(alertMsg == "") return;
    PHAOP_COM._Alert(alertMsg,"info")
}
//发药核对
function ShowCheckFyWin(patNo){
    var rowsData =  $("#gridPrescList").datagrid('getData').rows;
    var pJson = {};
    var prescArr = [];
    for (var i=0;i<rowsData.length;i++) {
        var rowData = rowsData[i];
        prescArr.push({ 
            phlId   : PHAOP_COM.DEFAULT.phlId,
            prescNo : rowData.TPrescNo,
        }); 
    }
    pJson.rows = prescArr;
    pJson.patNo =patNo;
    pJson.winIdStr = PHAOP_COM.DEFAULT.winIdStr;
    var ret = COMPOMENTS.Dialog.Open({
        prescGrid:"gridPrescList",
        pJson:pJson,
        locId :PHA_COM.Session.CTLOCID,
        type:"FYCheck"
    },ExecuteFY)
}
/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.03
 *  Description ������ҩ
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "PY";
PHAOP_COM.VAR.PermissionTpe = "PY";
PHAOP_COM.VAR.TIMER = "";
PHAOP_COM.VAR.TIMERSTEP = 30 * 1000;
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  ��֤��ԱȨ��
    InitGridPrescList();    //  �����б�
    InitGridPrescDetail();  //  ������ϸ
    InitEvent();            //  ��ť�¼�
    ResizePanel();          //  ���ֵ���    
    Clean();                //  ������ʼ����ѯ����
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    
    //�л�����
    PHA_EVENT.Bind('#btnChangeWin',     'click', function () {ChangeWin();});
    //��� toolbar
    PHA_EVENT.Bind('#btnPY',            'click', function () {ExecutePY();});
    PHA_EVENT.Bind('#btnRePrint',       'click', function () {RePrint();});
    PHA_EVENT.Bind('#btnAutoPY',        'click', function () {AutoPY();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                QueryPrescList();
            }
        }
    });
    //���Żس��¼�
    $('#cardNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var cardNo = $.trim($("#cardNo").val());
            if (cardNo != "") {
                ReadCard();
            }
        }
    });
    
}
// ���ֵ���
function ResizePanel(){
    
    setTimeout(function () {   
        $("#divGridDetail").panel({title:""})
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��grid',
            region: 'north',
            height: 0.5 
        });
        if(APP_PROP.ShowDetailType=="1"){
            ChangShowDetailType();
        }
    }, 0);
}
// ��ʼ����ѯ����
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#defPrintorFlag").checkbox('setValue', true);
}
function InitGridPrescList(){
     COMPOMENTS.PrescListGrid("gridPrescList",{
         columns: COMPOMENTS.Columns.PYMain.Normal(),
         frozenColumns: COMPOMENTS.Columns.PYMain.Frozen(),
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
                $('#gridPrescList').datagrid("selectRow",0);
            }else{
                $('#gridPrescDetail').datagrid('clear');
                $("#divImg").html("");
            }
        }
    })
}
function InitGridPrescDetail(){
     COMPOMENTS.PrescDetailGrid("gridPrescDetail",{})
     $('#gridPrescDetail').datagrid('hideColumn',"TRealQty")
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
// ��ѯ�����б�
function QueryPrescList(){
    PHAOP_COM.ClearErpMenu(); // ������Ӳ����˵���Ҫ�Ĳ���
    var pyFlag = $("#pyFlag").checkbox('getValue');
    var patNo = $("#patNo").val();
    if((patNo == "")&&(pyFlag == false)){
        PHAOP_COM._Msg("error","������ǼǺŻ򿨺ź�,�ٴβ�ѯ!");
        Setfocus();
        return false;
    }
    var $grid =  $("#gridPrescList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyAdv.Api' ,
        pMethodName:'GetPrescList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    Setfocus();
}
function ChangShowDetailType(){
    if($("#divImg").css("display")=="none"){
        $("#divTab").css("display","none")
        $("#divImg").css("display","block");
        $("#divImg").css("height",$("#divTab").height())
    }else{
        $("#divTab").css("display","block")
        $("#divImg").css("display","none")
        $("#divImg").css("height",$("#divTab").height())
    }
    QueryPrescDetail();
}
// ��ѯ������ϸ
function QueryPrescDetail(){
    
    if($("#divImg").css("display")=="none"){
        QueryPrescDetailForTab();
    }else{
        QueryPrescDetailForImg()
    }
}
// ��ѯ������ϸ
function QueryPrescDetailForImg(){
    var checkedRows = $("#gridPrescList").datagrid('getChecked');
    if (checkedRows.length === 0) {
        var selRowData = $("#gridPrescList").datagrid('getSelected');
        if(selRowData == null){return}
        else{
            checkedRows.push(selRowData);
        }
    }
    var phlId = PHAOP_COM.DEFAULT.phlId;;
    var pJson = {};
    var prescArr = [];
    var len = checkedRows.length;
    for (var i = 0 ;i < len ;i++){
        var rowData = checkedRows[i];
        prescArr.push({ 
            phlId   : phlId,
            prescNo : rowData.TPrescNo,
            phdId   : rowData.Tphdrowid          
        });
        
    }
    pJson.rows = prescArr;
    PHAOP_COM.ShowPrescDetailForImg({
        pJson:pJson,
        divImgId:"divImg"
    })
    return;
}
// ��ѯ������ϸ
function QueryPrescDetailForTab(){  
    
    var $grid =  $("#gridPrescDetail");
    var checkedRows = $("#gridPrescList").datagrid('getChecked');
    if (checkedRows.length === 0) {
        var selRowData = $("#gridPrescList").datagrid('getSelected');
        if(selRowData == null){return}
        else{
            checkedRows.push(selRowData);
        }
    }
    var phlId = PHAOP_COM.DEFAULT.phlId;;
    var pJson = {};
    var prescArr = [];
    var len = checkedRows.length;
    
    for (var i = 0;i<len ; i++) {
        var rowData = checkedRows[i];
        prescArr.push({ 
            phlId   : phlId,
            prescNo : rowData.TPrescNo,
            phdId   : rowData.Tphdrowid          
        });
        
    }
    pJson.rows = prescArr;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyAdv.Api' ,
        pMethodName:'GetPrescDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
    PHAOP_COM.ClearErpMenu();
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescList').datagrid("uncheckAll")
    $('#gridPrescDetail').datagrid('clear');
    $("#divImg").html("");
    InitDefVal();
    Setfocus();
    
    
}
// ����
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
function CheckBeforePy(){
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var checkedRows = $grid.datagrid('getChecked');
    var len = checkedRows.length;
    if (len >0){
        for (var i = 0;i<len ; i++) {
            var rowData = checkedRows[i];
            var phdStat = rowData.TPhDispStat;
            var prescNo = rowData.TPrescNo;
            if(phdStat != ""){
                PHAOP_COM._Msg("error",$g("����")+":"+"<span>"+ prescNo+phdStat + "</span>");
                return false;
            }
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            var phdStat = rowData.TPhDispStat;
            var prescNo = rowData.TPrescNo;
            if(phdStat != ""){
                PHAOP_COM._Msg("error",$g("����")+":"+prescNo+phdStat);
                return false;
            }
        }else{
            PHAOP_COM._Msg('error', "��ѡ����ҩ���ݣ�");
            return false;
        }
    }
    return true;
}
// ��ҩ
function ExecutePY(){
    var retFlag = CheckBeforePy();
    if(retFlag == false){
        Setfocus();
        return;
    }
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    
    var checkedRows = $grid.datagrid('getChecked');
    var retVal ;
    var index;
    var len = checkedRows.length;
    if (len >0){
        if(checkedRows.length>1) tipMsg = "����ѡ����Ŵ������Ƿ�ͬʱ��ҩ?"
        else{tipMsg = $g("��ͨ����ѡ������ҩ���Ƿ���ҩ��")+ "<span>"+ checkedRows[0].TPrescNo + "</span>"}
        PHAOP_COM._Confirm("��ҩ", tipMsg, function (r) {
            if (r) {    
                for (var i = 0;i<len ; i++) {
                    var rowData = checkedRows[i];
                    index = rows.indexOf(rowData);
                    retVal = Dispening(index);
                    if(!retVal)return;
                }
                PHAOP_COM._Msg("success","��ҩ�ɹ�!");
            }
        })
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            index = $grid.datagrid('getRowIndex',rowData)
            retVal = Dispening(index);
            if(!retVal)return;
        }else{
            PHAOP_COM._Msg('error', "��ѡ����ҩ���ݣ�");
            return;
        }
        PHAOP_COM._Msg("success","��ҩ�ɹ�!");
    }
    
    Setfocus();
}
// ��ҩ
function Dispening(index){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo;
    var pJson ={
        phlId : PHAOP_COM.DEFAULT.phlId,
        winIdStr : PHAOP_COM.DEFAULT.winIdStr,
        phPerId : PHAOP_COM.DEFAULT.phPerId,
        pharId : rowData.TPhawId,
        prescNo : prescNo
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.PyAdv.Api',
        pMethodName: 'SavePhdData',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var phdId = retVal.data;
        var updData = {
            TPrintFlag : 1,
            Tphdrowid : phdId,
            TPhDispStat:$g("����ҩ")
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        $grid.datagrid('refreshRow', index)
        OP_PRINTCOM.PrintPrescHandler({
            prescNo:prescNo,
            prtType:APP_PROP.PYPrintType,
            phdId:phdId,
            rePrint:"",
            defPrintorFlag:""
        })
        return true;
    }else{
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// �Զ���ҩ
function AutoPY(){
    var ret = COMPOMENTS.Window.Open({
        type:"AutoPY"
    },StartAutoPY)
    
    
}
// ��ʼ�Զ���ҩ
function StartAutoPY(){
    $("#"+OP_COMPOMENTS.Element.AutoPyErrInfo).text("");   
    PHAOP_COM.VAR.TIMER = setTimeout("AutoPrint()", PHAOP_COM.VAR.TIMERSTEP);
}
function AutoPrint(){
    var pJson = GetParams();
    if(pJson==false){
        StopAutoPY();
        return;
    }
    var defPrintorFlag ="";
    if($("#defPrintorFlag").checkbox('getValue')){defPrintorFlag = "Y"};
    var retJson = PHA.CM({
        pClassName: 'PHA.OP.PyAdv.Api',
        pMethodName: 'AutoPY',
        pJson: JSON.stringify(pJson)
    },false);
    
    var prtInfo = retJson.prtInfo;
    var errInfo = retJson.errInfo;
    if(typeof prtInfo === 'undefined'){
        StopAutoPY();
        return;
    }
    if (prtInfo!=""){
        var phdInfoArr = prtInfo.split("^");
        for (var phdI = 0; phdI < phdInfoArr.length; phdI++) {
            var phdInfoStr = phdInfoArr[phdI] || "";
            if (phdInfoStr == "") {
                continue;
            }
            var phdId = phdInfoStr.split("$")[0];
            var prescNo = phdInfoStr.split("$")[1];
            Print(prescNo, phdId, "", defPrintorFlag)
        }       
    }
    if (errInfo!=""){
        var errInfoData=$("#"+OP_COMPOMENTS.Element.AutoPyErrInfo).val();
        if(errInfoData!="") {errInfo=errInfo+" \n"+errInfoData};
        $("#"+OP_COMPOMENTS.Element.AutoPyErrInfo).val(errInfo)
    }
    PHAOP_COM.VAR.TIMER = setTimeout("AutoPrint()", PHAOP_COM.VAR.TIMERSTEP);
}
// ֹͣ�Զ���ҩ
function StopAutoPY(){
    if(COMPOMENTS.Window.ComInfo.winId){
        $('#'+ OP_COMPOMENTS.Window.ComInfo.winId ).window('close');
    }
}
// ��ӡ
function RePrint(){
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var checkedRows = $grid.datagrid('getChecked');
    var retVal ;
    var len = checkedRows.length;
    if (len >0){
        var printNum = 0;
        for (var i = 0;i<len ; i++) {
            var rowData = checkedRows[i];
            var phdId = rowData.Tphdrowid || "";
            if((APP_PROP.PYPrintType != "1")||(phdId != "")){
                printNum ++;
            }
            Print(rowData.TPrescNo,rowData.Tphdrowid,$g("��"),"")
        }
        if(printNum == 0){
            PHAOP_COM._Msg('info', "����ҩ���ٴ�ӡ��");
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            var phdId = rowData.Tphdrowid || "";
            if((APP_PROP.PYPrintType == "1")&&(phdId == "")){
                PHAOP_COM._Msg('info', "����ҩ���ٴ�ӡ��");
            }
            Print(rowData.TPrescNo,rowData.Tphdrowid,$g("��"),"")
        }
    }
}
function Print(prescNo,phdId,rePrint,defPrtFlag){
    OP_PRINTCOM.PrintPrescHandler({
        prescNo:prescNo,
        prtType:APP_PROP.PYPrintType,
        phdId:phdId,
        rePrint:rePrint,
        defPrintorFlag:defPrtFlag,
    })
}
// �л�����
function ChangeWin(){
    var ret = COMPOMENTS.Window.Open({
        locId :PHA_COM.Session.CTLOCID,
        type:PHAOP_COM.VAR.WinType
    },Clean)
    
}
// ��ԱȨ��
function CheckPermission(){
    PHAOP_COM.CheckPermission({
        permissionType:PHAOP_COM.VAR.PermissionTpe
    },Clean)
}
// ��ѯor��ҩ����λ��
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
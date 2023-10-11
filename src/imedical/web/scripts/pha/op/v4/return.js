/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.26
 *  Description ������ҩ
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "Return";
PHAOP_COM.VAR.CAModelCode = "PHAOPReturn";      
PHAOP_COM.VAR.TIMER = "";
PHAOP_COM.VAR.TIMERSTEP = 30 * 1000;
PHAOP_COM.VAR.ReturnId = "";
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  ��֤��ԱȨ��
    InitGridRequestList();  //  �����б�
    InitGridReturnDetail(); //  ������ϸ
    InitDIct();             //  
    InitEvent();            //  ��ť�¼�
    ResizePanel();          //  ���ֵ���    
    Clean();                //  ������ʼ����ѯ����
    $("#cardNo").imedisabled();
    
})

function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {Query();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    
    //��� toolbar
    PHA_EVENT.Bind('#btnReturn',        'click', function () {
        PHAOP_COM.CACert({},DoReturn);
    });
    PHA_EVENT.Bind('#btnRefuse',        'click', function () {DoExecuteRefuseRet();});
    PHA_EVENT.Bind('#btnCancelRefuse',  'click', function () {DoCancelRefuseRet();});
    PHA_EVENT.Bind('#btnPrintReturn',   'click', function () {PrintReturn();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                Query();
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
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��grid-return',
            region: 'west',
            width: 0.3 
        });
    }, 0);
}
function InitDIct(){
    PHA.ComboBox('prescNo',{
        mode:'remote',
        editable:false, 
        width:250,
        panelWidth:350,
        url: PHA.$URL,
        onShowPanel: function() {
            $(this).combobox("reload")
        },
        onBeforeLoad: function(param) {
            var stDate=$("#stDate").datebox("getValue");
            var endDate=$("#endDate").datebox("getValue");
            var patNo = $("#patNo").val();
            var freeDrgFlag=$("#freeDrgFlag").checkbox('getValue')
            if(PHAOP_COM.DEFAULT.RetNeedReq == "Y"){
                if(freeDrgFlag == false){
                    $('#prescNo').combobox('hidePanel')
                    PHAOP_COM._Alert("�����ҩ�⣬��ҩ��Ҫ������ҩ����!");
                    return false;
                }
            }else{freeDrgFlag = "";}
            var pJson = {
                locId:PHAOP_COM.LogonData.LocId,
                stDate:stDate,
                endDate:endDate,
                patNo:patNo,
                freeDrgFlag: freeDrgFlag
            };
            param.pClassName ='PHA.OP.Return.Api';
            param.pMethodName = 'GetPrescForRet';
            param.pPlug = 'datagrid';
            param.pJson = JSON.stringify(pJson)
            
            
        },loadFilter: function (data){
            return data.rows;
        },onSelect:function(rowData){
            $('#gridRequestList').datagrid('clear');
            QueryGridReturn();
        }
    });
}

// ��ʼ����ѯ����
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#defPrintorFlag").checkbox('setValue', true);
}
function InitGridRequestList(){
    var normalCol=[[
        {field:'reqNo',             title: ("���뵥��"),        width:100,      align:'left'},
        {field:'prescNo',           title: ("������"),         width:120,      align:'left'},
        {field:'reqUser',           title: ("������"),         width:100,      align:'left'},
        {field:'reqRowId',          title:"reqRowId",           width:90,       align:'left',   hidden:true}, 
        {field:'reqReason',         title:"reqReason",          width:100,      align:'left',   hidden:true},
        {field:'prescCYFlag',       title:"prescCYFlag",        width:80,       align:'left',   hidden:true},
        {field:'reqReasonDesc',     title: ("����ԭ��"),        width:120,      algin:'left',   hidden:true}
        
    ]];
    COMPOMENTS.ComomGrid("gridRequestList",{
         columns: normalCol,
         onSelect : function(rowIndex, rowData) {
            $("#prescNo").combobox('clear') ;
            QueryGridReturn();
            
        },onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridRequestList').datagrid("selectRow",0);
            }else{
                $('#gridReturnDetail').datagrid('clear');
            }
        }
    })
}
function InitGridReturnDetail(){
    var normalCol=[[
        {field:'TRefuse',           title: ("����ԭ��"),        width:100,      align:'left'},
        {field:'TPhdesc',           title: ("ҩƷ����"),        width:120,      align:'left'},
        {field:'TPhUom',            title: ("ҩƷ��λ"),        width:100,      align:'left'},
        {field:'TPrice',            title: ("ҩƷ����"),        width:100,      align:'left'},
        {field:'TDispQty',          title: ("��ҩ����"),        width:100,      align:'left'},
        {field:'TDispMoney',        title: ("��ҩ���"),        width:100,      align:'left'},
        {field:'TRetQty',           title: ("��ҩ����"),        width:100,      align:'left',
            editor: PHA_GridEditor.NumberBox({
                checkOnBlur: true,
                onBlur:function(val, rowData, rowIndex){
                    if(val == "") val = 0;
                    // ����
                    var retQty = parseFloat(val);
                    if (isNaN(retQty)) {
                        PHAOP_COM._Alert("<span>"+ rowData.TPhdesc + "</span>" + $g("���������֣�"));
                        return false;
                    }
                    if (retQty < 0) {
                        PHAOP_COM._Alert("<span>"+ rowData.TPhdesc + "</span>" + $g("���������0�����֣�"));
                        return false;
                    }

                    var reg = /^[0-9]\d*$/;
                    if (!reg.test(retQty)) {
                        PHAOP_COM._Alert("<span>"+ rowData.TPhdesc + "</span>" + $g("��ҩ����ֻ��Ϊ����!"))
                        return false;
                    }
                    // ��������
                    var dispQty = rowData.TDispQty || 0;
                    if (parseFloat(retQty * 1000) > parseFloat(dispQty * 1000)){
                        PHAOP_COM._Alert($g("ҩƷ")+":" + "<span>"+ rowData.TPhdesc + "</span>"  + "</br>"+$g("��ҩ�������ڷ�ҩ����!"));
                        return false;
                    }
                    var price = rowData.TPrice || 0;
                    $("#gridReturnDetail").datagrid('updateRowData', {
                        index: rowIndex,
                        row: {
                            TRetMoney : retQty*price
                        }   
                    });
                }
            })
        },
        {field:'TRetMoney',         title: ("��ҩ���"),        width:100,      align:'left'},
        {field:'TPhgg',             title: ("���"),          width:100,      align:'left'},
        {field:'TIncDispBatCode',   title: ("��ҩ����"),        width:100,      align:'left'},
        {field:'TIncRetBatCode',    title: ("��ҩ����"),        width:100,      align:'left',
            formatter:function(value, rowData, index) {
                var dispBatNo = rowData.TIncDispBatCode;
                if(dispBatNo.indexOf($g("Ƿҩ"))>-1) {dispBatNo ="";} 
                return dispBatNo;
            }
        },
        {field:'TInvNo',            title: ("��Ʊ��"),         width:100,      align:'left'},
        {field:'TPhdItm',           title:"TPhdItm",            width:100,      align:'left'},
        {field:'TPhUomid',          title:"TPhUomid",           width:90,       align:'left',   hidden:true}, 
        {field:'TReqItm',           title:"TReqItm",            width:100,      align:'left',   hidden:true},
        {field:'TPhdLbRowId',       title: ("��ҩ�ӱ�ID"),  width:80,       align:'left',   hidden:true},
        {field:'TDodisBatch',       title: ("����ӱ�ID"),  width:120,      algin:'left',   hidden:true},
        {field:'TCantRetReason',    title: ("������ҩԭ��"),  width:80,       align:'left'},
        {field:'TCyFlag',           title: ("��ҩ������־"),  width:120,      algin:'left',   hidden:true},
        {field:'TRefuseFlag',       title: ("�ܾ���־"),        width:120,      algin:'left',   hidden:true}

        
    ]];
    COMPOMENTS.ComomGrid("gridReturnDetail",{
        columns: normalCol,
        isCellEdit:true,
        onClickCell: function (index, field, value) {
            if(field == "TRetQty"){
                var rowData = $('#gridReturnDetail').datagrid('getData').rows[index];
                var cyFlag = rowData.TCyFlag;
                if (cyFlag == "Y") {
                    return;
                }
                var dispBatNo = rowData.TIncDispBatCode;
                if (dispBatNo.indexOf($g("Ƿҩ")) >-1) {
                    return;
                }
                PHA_GridEditor.Edit({
                    gridID: "gridReturnDetail",
                    index: index,
                    field: field
                });
            }
        },
        onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridReturnDetail').datagrid("selectRow",0);
            }
        }
    })
}
function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    if(PHAOP_COM.DEFAULT.phlId == ""){return false;}
    pJson.locId = PHAOP_COM.LogonData.LocId;
    return pJson;
}
function Query(){
    var patNo = $("#patNo").val() || "";
    if(patNo == ""){
        PHAOP_COM._Msg('error', "������ǼǺŻ򿨺ź�,�ٲ�ѯ!");
        return false;
    }
    AddPatInfo(patNo);
    var prescNo = $("#prescNo").combobox("getValue") || "";
    if (prescNo == "") {
        QueryGridRequest();
    } else {
        QueryGridReturn();
    }
}
// ��ʾ������Ϣ
function AddPatInfo(patNo){
    var patOpt = {
        id: "#OP_PatInfo",
        getType: "patNo",
        inputNo: patNo
    }
    PHAOP_COM.AppendPatBasicInfo(patOpt);
}
// ��ѯ��ҩ�����б�
function QueryGridRequest(){
    var $grid =  $("#gridRequestList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Return.Api' ,
        pMethodName:'GetRequestList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    
}

// ��ѯ����ҩ��ϸ
function QueryGridReturn(){
    PHAOP_COM.VAR.ReturnId = "";
    var $grid =  $("#gridReturnDetail");
    var prescNo = $("#prescNo").combobox("getValue") ||""
    var pJson={}
    var methodName = ""
    if(prescNo != "") {
        pJson = GetParams();
        if(pJson==false){return;}
        methodName = "GetReturnDetailByPresc"
    }else{
        var selRowData = $("#gridRequestList").datagrid('getSelected');
        if(selRowData != null){
            pJson.reqId = selRowData.reqRowId;
            methodName = "GetReturnDetailByReq";
        }
    }
    if(methodName==""){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Return.Api' ,
        pMethodName:methodName,
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
   
}
// ����
function Clean(){
    PHAOP_COM.VAR.ReturnId = "";
    if(PHAOP_COM.DEFAULT.RetNeedReq != "Y"){
        $("#divFreeDrgFlag").css("display","none");
    }else {
        $("#divFreeDrgFlag").css("display","");
    }
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridRequestList').datagrid('clear');
    $('#gridReturnDetail').datagrid('clear');
    if ($("#patInfo")) {
        $("#patInfo").remove()
    }
    InitDefVal();
    Setfocus();
}
// ����
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },Query)

}
// ��ҩ
function DoReturn(){
    var retFlag = CheckBeforeReturn();
    if(retFlag == false){return}
    SelReatson("retReasonWin","Return",ExecuteReturn);
    
}
//��ҩǰ�������
function CheckBeforeReturn(){
    var $grid = $("#gridReturnDetail");
    var rowsData = $grid.datagrid('getRows');
    var len = rowsData.length;
    if (len ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var canRetNum = 0;      //����ҩ��¼����
    var tipInfo = "";
    for(var rowi = 0;rowi < len; rowi ++){
        var rowData = rowsData[rowi]
        var cyFlag = rowData.TCyFlag;
        var refuseFlag = rowData.TRefuseFlag;
        var inciDesc = rowData.TPhdesc;
        if ((cyFlag == "Y") && (refuseFlag == "Y")) {
            PHAOP_COM._Alert($g("�ò�ҩ����ҩƷ")+":" + '<span>' +inciDesc + '</span>'+ "</br>"+$g("���ھܾ���ҩ��¼�����ܲ�����!"));
            return false;
        }
        var noCanRetReason = rowData.TCantRetReason;
        if ((cyFlag == "Y") && (noCanRetReason != "")) {
            PHAOP_COM._Alert($g("�ò�ҩ����ҩƷ")+":" + '<span>' + inciDesc + '</span>' + "</br>"+$g("ά���˲�����ҩԭ�򣬲��ܲ�����!"));
            return false;
        }
        if (noCanRetReason!=""){
            continue;
        }
        var phdLbId = rowData.TPhdLbRowId;
        var preColFlag = tkMakeServerCall("PHA.OP.Return.OperTab","GetPreColFlag",phdLbId)
        if (preColFlag == "1"){
            PHAOP_COM._Alert($g("ҩƷ")+":" + '<span>'+ inciDesc + '</span>' + "</br>"+$g("���ڴ������ڼ�ҩ���շ�����������ҩ!"));
            return false;
        }
        var retQty = rowData.TRetQty;
        var dispQty = rowData.TDispQty;
        var refuseReason = rowData.TRefuse;
        var batNo = rowData.TIncDispBatCode
        var phdLbId = rowData.TPhdLbRowId;
        var phdItmId = rowData.TPhdItm;
        if ((refuseReason != "") && (refuseReason != undefined)) {
            continue;
        }
        var uomId = rowData.TPhUomid;
        retQty = $.trim(retQty);
        dispQty = $.trim(dispQty);
        // �մ�����
        if ((retQty == "")||(retQty == 0)) {
            continue;
        }
        if (parseFloat(retQty) < 0) {
            PHAOP_COM._Alert($g("ҩƷ")+":" + '<span>'+ inciDesc + '</span>' + "</br>"+$g("��ҩ��������С��0!"));
            return false;
        }
        if (isNaN(retQty) == true) {
            PHAOP_COM._Alert($g("ҩƷ")+":" + '<span>'+ inciDesc + '</span>' + "</br>"+$g("��ҩ��������Ϊ������!"));
            return false;
        }
        if (parseFloat(retQty * 1000) > parseFloat(dispQty * 1000)){
            PHAOP_COM._Alert($g("ҩƷ")+":" + '<span>'+ inciDesc + '</span>' + "</br>"+$g("��ҩ�������ڷ�ҩ����!"));
            return false;
        }
        var reg = /^[0-9]\d*$/;
        if (!reg.test(parseFloat(retQty))) {
            PHAOP_COM._Alert('<span>'+ inciDesc + '</span>' + $g("��ҩ����ֻ��Ϊ����!"))
            return false;
        }
        if ((retQty > 0) && (batNo != $g("Ƿҩ"))) {
            var checkret = tkMakeServerCall("PHA.OP.Return.Query", "CheckRetQty", phdLbId, retQty, uomId);
            if (checkret == "-1") {

                PHAOP_COM._Alert($g("ҩƷ")+":" + '<span>'+ inciDesc + '</span>' + "</br>"+$g("��ҩ��������ʣ��δ������!"));
                return false;
            }
        }
        canRetNum ++;
    }
    if(canRetNum==0){
        PHAOP_COM._Alert($g("�޷���Ҫ�����ҩ��¼��")+ "</br>"+$g("�������ҩ��¼���������Ƿ�ܾ���ҩƷ������ԭ��"));
        return false;
    }
    return true;
}
// ��ҩ
function ExecuteReturn(reasonJson){
    var retReasonId = reasonJson.reasonId;
    var $grid = $("#gridReturnDetail");
    var rowsData = $grid.datagrid('getRows');
    var len = rowsData.length;
    if (len ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var retInfo = "";
    var retQty,dispQty,phdItmId,retMoney,sp,batNo,retUomId,refuseReason,phdLbId;
    var noCanRetReason;
    var oweFlag,retInfo;
    for(var rowi = 0;rowi < len; rowi ++){
        var oneRetInfo ; 
        var rowData = rowsData[rowi]
        retQty = rowData.TRetQty;
        phdItmId = rowData.TPhdItm;
        retMoney = rowData.TRetMoney;
        batNo = rowData.TIncDispBatCode;
        retUomId = rowData.TPhUomid;
        phdLbId = rowData.TPhdLbRowId;
        refuseReason = rowData.TRefuse;
        noCanRetReason = rowData.TCantRetReason;
        if ((refuseReason != "") && (refuseReason != undefined)) {
            continue;
        }
        if (noCanRetReason!=""){
            continue;
        }
        // �մ�����
        if ((retQty == "")||(retQty == 0)) {
            continue;
        }
        if (batNo == $g("Ƿҩ")) {
            oweFlag = 1;  //Ƿҩ��ҩ���� �ͷ�ҩ��ҩ���벻����ͳһ������
            oneRetInfo = phdItmId;
        }else{
            oneRetInfo = phdItmId + "^" + retQty + "^" + retMoney + "^" + retUomId + "^" + "" + "^" + phdLbId;
        }
        if (retInfo == "") {
            retInfo = oneRetInfo;
        } else {
            retInfo = retInfo + "&" + oneRetInfo;
        }
    }

    var reqId = "";
    var selReqData =  $('#gridRequestList').datagrid('getSelected');;
    if (selReqData != null) {
        reqId = selReqData.reqRowId;
    }

    if (oweFlag == "1") {
        var retVal = tkMakeServerCall("PHA.OP.Owe.OperTab", "DoChowReturn", reqId, PHAOP_COM.LogonData.UserId, retInfo);
        var retCode = retVal.split("^")[0];
        if (retCode != 0) {
            PHAOP_COM._Alert($g("Ƿҩ��ҩʧ�ܣ�")+"</br>"+$g("�������")+":" + retVal.split("^")[1]);
            return;
        } else {
            PHAOP_COM.SaveCACert({
                signVal:phdItmId.split("||")[0],
                type:"OH"
            })
            PHAOP_COM._Alert("Ƿҩ��ҩ�ɹ�!", "success");
            return;
        }
    } else {
        var prtId = "";
        var retVal = tkMakeServerCall("PHA.OP.Return.OperTab", "DoReturn",
                PHAOP_COM.LogonData.LocId,
                PHAOP_COM.LogonData.UserId,
                phdItmId, retReasonId, prtId, "", reqId, retInfo);
        var retCode = retVal.split("^")[0];
        var retMsg = retVal.split("^")[1];
        if (retCode < 0) {
            PHAOP_COM._Alert(retMsg);
            return;
        } else {
            PHAOP_COM.VAR.ReturnId=retCode;
            PHAOP_COM._Alert("��ҩ�ɹ�!", "success");
            PHAOP_COM.SaveCACert({
                signVal:retCode,
                type:"H"
            })
        }
    }
    
}
// ��ӡ
function PrintReturn(){
    if (PHAOP_COM.VAR.ReturnId == "") {
        PHAOP_COM._Alert("������ҩ��,�ٴ�ӡ!");
        return false;
    }
    OP_PRINTCOM.PrintReturn(PHAOP_COM.VAR.ReturnId, "")
}
// ��ԱȨ��
function CheckPermission(){
    PHAOP_COM.CheckPermission({
        winType:PHAOP_COM.VAR.WinType,
        noSelWin:"Y"
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
function DoExecuteRefuseRet(){
    if (PHAOP_COM.VAR.ReturnId != "") {
        PHAOP_COM._Alert("���μ�¼����ҩ,��˲�!");
        return;
    }
    var reqSelData = $("#gridRequestList").datagrid('getSelected');
    if(reqSelData == null){
        PHAOP_COM._Alert("��ѡ����ҩ���뵥!");
        return false;
    }
    var retRowsData = $("#gridReturnDetail").datagrid('getRows');
    var len = retRowsData.length;
    if (len ==0) {
        PHAOP_COM._Alert( "����ҩ��ϸû�����ݣ�");
        return false;
    }
    var cyFlag = reqSelData.prescCYFlag ;
    if(cyFlag != "Y" ){
        var retSelData = $("#gridReturnDetail").datagrid('getSelected');
        if(retSelData == null){
            PHAOP_COM._Alert("��ѡ�����ҩ��ϸ��¼��ܾ���ҩ��");
            return false;
        }
        var reqItmId = retSelData.TReqItm;
        var refuseReason = retSelData.TRefuse;
        if ((reqItmId == "") || (reqItmId == undefined)) {
            PHAOP_COM._Alert("��������ҩ������ҩʱ����ܾ���ҩ!");
            return;
        }
        if ((refuseReason != "") && (refuseReason != undefined)) {
            PHAOP_COM._Alert("�ü�¼�Ѿܾ�!");
            return;
        }
    }else{
        var reqId = reqSelData.reqRowId ;
        if ((reqId == "") || (reqId == undefined)) {
            PHAOP_COM._Alert("��ҩ����������ҩ������ҩʱ������ܾ���ҩ!");
            return;
        }
    }
    SelReatson("refRetResonWin","Refuse",ExecuteRefuseRet);
}
function ExecuteRefuseRet(reasonJson){
    var $grid = $("#gridReturnDetail");
    var reqSelData = $("#gridRequestList").datagrid('getSelected');
    var cyFlag = reqSelData.prescCYFlag ;
    var methodName =""
    var pJson = {};
    pJson.reasonId = reasonJson.reasonId;
    pJson.userId = PHAOP_COM.LogonData.UserId;
    if(cyFlag != "Y" ){
        var retSelData = $grid.datagrid('getSelected');
        var reqItmId = retSelData.TReqItm;
        pJson.reqItmId = reqItmId;
    }else{
        var reqId = reqSelData.reqRowId ;
        pJson.reqId = reqId
    }
    
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.Return.Api',
        pMethodName: 'RefuseReturn',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TRefuse: reasonJson.reasonDesc,
            TRefuseFlag: "Y"
        }   
        if(cyFlag == "Y" ){
            var rowsData =  $grid.datagrid('getData').rows;
        }else{
            var rowsData = $grid.datagrid('getSelections');
        }
        var len = rowsData.length
        for (var rowi = 0 ;rowi < len;rowi++) {
            var rowData = rowsData[0];
            var index = $grid.datagrid('getRowIndex',rowData)
            $grid.datagrid('updateRowData', {
                index: index,
                row: updData
            });
        }
        PHAOP_COM._Msg('success', "�ܾ���ҩ�ɹ���");       
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
function DoCancelRefuseRet(){
    var $grid = $("#gridReturnDetail");
    if (PHAOP_COM.VAR.ReturnId != "") {
        PHAOP_COM._Alert("���μ�¼����ҩ,��˲�!");
        return;
    }
    var reqSelData = $("#gridRequestList").datagrid('getSelected');
    if(reqSelData == null){
        PHAOP_COM._Alert("��ѡ����ҩ���뵥!");
        return false;
    }
    var retRowsData = $grid.datagrid('getRows');
    var len = retRowsData.length;
    if (len ==0) {
        PHAOP_COM._Alert("����ҩ��ϸû�����ݣ�");
        return false;
    }
    var cyFlag = reqSelData.prescCYFlag ;
    var pJson = {};
    pJson.userId = PHAOP_COM.LogonData.UserId;
    pJson.cyFlag = cyFlag;
    if(cyFlag != "Y" ){
        var retSelData = $grid.datagrid('getSelected');
        if(retSelData == null){
            PHAOP_COM._Alert("��ѡ�����ҩ��ϸ��¼�����ܾ���ҩ��");
            return false;
        }
        var reqItmId = retSelData.TReqItm;
        var refuseReason = retSelData.TRefuse;
        if ((reqItmId == "") || (reqItmId == undefined)) {
            PHAOP_COM._Alert("��������ҩ������ҩʱ�����ܾ���ҩ!");
            return;
        }
        if ((refuseReason == "") || (refuseReason == undefined)) {
            PHAOP_COM._Alert("�ü�¼����Ҫ�����ܾ���ҩ");
            return;
        }
        pJson.reqItmId = reqItmId;
    }else{
        var reqId = reqSelData.reqRowId ;
        if ((reqId == "") || (reqId == undefined)) {
            PHAOP_COM._Alert("��ҩ����������ҩ������ҩʱ�ų����ܾ���ҩ!");
            return;
        }
        pJson.reqId = reqId;
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.Return.Api',
        pMethodName: 'CancelRefuseReturn',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TRefuse: "",
            TRefuseFlag: ""
        }   
        if(cyFlag == "Y" ){
            var rowsData =  $grid.datagrid('getData').rows;
        }else{
            var rowsData = $grid.datagrid('getSelections');
        }
        var len = rowsData.length
        for (var rowi = 0 ;rowi < len;rowi++) {
            var rowData = rowsData[0];
            var index = $grid.datagrid('getRowIndex',rowData)
            $grid.datagrid('updateRowData', {
                index: index,
                row: updData
            });
        }   
        PHAOP_COM._Msg('success', "�����ܾ���ҩ�ɹ���"); 
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
function SelReatson(winId,type,_fn){
    var $widow = $('#' + winId);
    if ($widow.length === 0){
        var $widow = $('<div id="'+ winId +'"></div>').appendTo('body');
        $widow.empty();
    }else{
        $('#'+ winId ).dialog('open');
        return
    
    }
    var idText,id,storeUrl;
    var marLeft = 60;
    if(type=="Refuse"){
        idText = $g("�ܾ���ҩԭ��");
        id = "refuseRetReasonId";
        storeUrl = PHAOP_STORE.RefuseRetReason().url;       
    }
    if(type=="Return"){
        idText = $g("��ҩԭ��")
        id = "retReasonId"
        storeUrl = PHAOP_STORE.RetReason().url; 
    }
    var htmlStr = '<div class = "pha-row" style="margin-top:72px;text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+idText+'</div>'     
            +           '<div class="pha-col" style="margin-left:0px"><input id = "'+id+'" class = "hisui-combobox" ></div>'
            + '</div>'

    var $toolbar = $(htmlStr).prependTo('#'+ winId);
    // �ܾ���ҩ
    PHA.ComboBox(id,{
        editable:false, 
        url: storeUrl
    });
    PHA_COM.Window.Proportion = 1;
    $widow.dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        closed: true,               
        modal: true,
        title:  "��ѡ��"+idText,
        width: 400, 
        height: 250,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'ȷ��',
            handler:function(){
                var reasonId = $("#"+id).combobox("getValue")||""
                if(reasonId == ""){
                    PHAOP_COM._Alert("��ѡ��"+idText);
                    return
                }
                var retJson = {reasonId:reasonId,reasonDesc:$("#"+id).combobox("getText")||""}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'�ر�',
            handler:function(){$('#'+ winId ).dialog('close');}
        }]
    }); 
    $('#'+ winId ).dialog('open');
}
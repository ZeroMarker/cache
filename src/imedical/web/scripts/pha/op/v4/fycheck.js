/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.03
 *  Description ���﷢ҩ�˶�
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "FY";
PHAOP_COM.VAR.PermissionTpe = "FY";
PHAOP_COM.VAR.CAModelCode = "PHAOPExecuteFY";
PHAOP_COM.VAR.WayId = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetWayIdByCode", PHAOP_COM.VAR.WayType);
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
var CurPatNo = "";      //��Ҫ��¼�Ƿ��˲�ѯ����ҩ
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  ��֤��ԱȨ��
    InitGridWaitList();     //  �����б�
    InitGridPrescList();    //  �����б�
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
    //���� toolbar
    PHA_EVENT.Bind('#btnCheck',         'click', function () {ExecutePrescCheck();});
    PHA_EVENT.Bind('#btnCheckAndFY',    'click', function () {
        PHAOP_COM.CACert({},ExecuteFY);
    });
    PHA_EVENT.Bind('#btnRefuse',        'click', function () {ExecuteRefuseFY();});
    PHA_EVENT.Bind('#btnCancelRefuse',  'click', function () {CancelRefuseFY();});
    PHA_EVENT.Bind('#btnPrintPresc',    'click', function () {PrintHandler("2");});
    PHA_EVENT.Bind('#btnPrintLabel',    'click', function () {PrintHandler("3");});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnReturn',        'click', function () {Return();});
    //����ҩ�б�
    PHA_EVENT.Bind('#btnFresh',         'click', function () {QueryWaitList();});
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
    //���Żس��¼�
    $('#barCode').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var barCode = $.trim($("#barCode").val());
            if (barCode != "") {
                var type = tkMakeServerCall("PHA.OP.COM.Method","GetBarCodeType",barCode) 
                if(type === "1"){ //�ǼǺ�
                    $("#patNo").val(barCode);
                    QueryPrescList();
                }else if(type === "2"){// ������ //��ʱ����
                    $("#prescNo").val(barCode);
                    QueryPrescList();
                }else{
                    var $grid = $("#gridPrescList")
                    var rowsData = $grid.datagrid('getRows');
                    var len = rowsData.total;
                    for(var i = 0;i<len;i++){
                        var itemData =rowsData.rows[i];
                        if((gridBarCode != "") && (gridBarCode.indexOf(barcode + ",") > -1)) {
                            $grid.datagrid("checkRow",i)
                        } 
                    }
                }
            }
        }
    });
    //�細�ڱ�־�Ƿ�ɼ�
    if(APP_PROP.FYDispAllowNoJudgWin != "Y"){
        $('#td-crossFlag').css('display', 'none');
    }
}
// ���ֵ���
function ResizePanel(){
    setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��grid',
            region: 'east',
            width: 0.2 
        });
    }, 0);
}
// ��ʼ����ѯ����
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
     var frozenCol = [[
        { field: 'Select',          checkbox: true},
        { field: 'patNo',           title: ('�ǼǺ�'),     width: 100,     align: 'left',      hidden: true},
        { field: 'patName',         title: ('����'),          width: 100,     align: 'left',      hidden: true},
        { field: 'patAge',          title: ('����'),          width: 50,      align: 'left',      hidden: true},
        { field: 'patSex',          title: ('�Ա�'),          width: 50,      align: 'left',      hidden: true},
        { field: 'dispStat',        title: ('����״̬'),        width: 50,      align: 'left',      hidden: true},
        
        { field: 'TOrditm',         title: ('ҽ��id'),        width: 200,     align: 'left',      hidden: true},
        { field: 'TPhDispItmStat',  title: ('��ϸ״̬'),        width: 120,     align: 'left',
            styler:function(value, row, index) {
                return OP_COMPOMENTS.ItmStatusStyler(value, row, index);
            }
        },
        { field: 'drugIcon',        title: ('ͼ��'),          width: 80,      align: 'left',
            formatter:function(value, row, index) {
                return PHA_COM.Drug.Icon(value, row, index);
            }
        },
        { field: 'TPhDesc',         title: ('ҩƷ����'),        width: 200,     align: 'left',
            styler:function(value, row, index) {
                return PHA_COM.Drug.Color(value, row, index);
            }
        },
        { field: 'TPhQty',          title: ('��ҩ����'),        width: 80,      align: 'left'},
        { field: 'TPhUom',          title: ('��λ'),          width: 60,      align: 'left'}
    ]]
    var normalCol = [[
        { field: 'TPhgg',           title: ('���'),          width: 100,     align: 'left'},
        { field: 'TJL',             title: ('����'),          width: 100,     align: 'left'},
        { field: 'TYF',             title: ('�÷�'),          width: 100,     align: 'left'},
        { field: 'TPC',             title: ('Ƶ��'),          width: 100,     align: 'left'},
        { field: 'TLC',             title: ('�Ƴ�'),          width: 100,     align: 'left'},
        { field: 'TIncHW',          title: ('��λ'),          width: 100,     align: 'left'},
        { field: 'TPhFact',         title: ('����'),          width: 100,     align: 'left'},
        { field: 'TPhFact',         title: ('����'),          width: 100,     align: 'left'},
        { field: 'TPhbz',           title: ('��ע'),          width: 100,     align: 'left'},
        { field: 'TKCQty',          title: ('�������'),        width: 100,     align: 'left'},
        { field: 'TYBType',         title: ('ҽ������'),        width: 100,     align: 'left'},
        { field: 'TPrice',          title: ('����'),          width: 100,     align: 'left'},
        { field: 'TMoney',          title: ('���'),          width: 100,     align: 'left'},
        { field: 'TOrdStatus',      title: ('״̬'),          width: 100,     align: 'left'},
        { field: 'TIncPC',          title: ('����'),          width: 100,     align: 'left',      hidden: true},
        { field: 'TPrtNo',          title: ('��Ʊ��'),         width: 100,     align: 'left'},
        { field: 'TSkinTest',       title: ('Ƥ��'),          width: 100,     align: 'left'},
        { field: 'TPrescNo',        title: ('������'),             width: 100,     align: 'left'},
        { field: 'TCInsuCode',      title: ('����ҽ������'),  width: 100,     align: 'left'},
        { field: 'TCInsuDesc',      title: ('����ҽ������'),          align: 'left'},
        { field: 'TInci',           title: ('TInci'),           width: 100,     align: 'left',      hidden: true},
        { field: 'TUnit',           title: ('TUnit'),           width: 100,     align: 'left',      hidden: true},
        { field: 'TOrditm',         title: ('TOrditm'),         width: 100,     align: 'left',      hidden: true},
        { field: 'TBarCode',        title: ('����'),          width: 100,     align: 'left',      hidden: true},
        
    ]]

    COMPOMENTS.ComomGrid("gridPrescList",{
        frozenColumns: frozenCol, 
        columns: COMPOMENTS.Columns.Detail.Normal(),
        fit: true,
        fitColumns: false,
        //view: groupview,
        groupField:"TPrescNo",
        groupFormatter: function (value, rows) {
            var rowData = rows[0];
            // ���˻�����Ϣ / ҽ����Ϣ /
            var patDiv = '';
            var viewDiv = '';
            var prescDiv = '';
            patDiv += '<div id="grpViewPat" class="pha-op-grid-grpviewpat" style="padding-left:0px">';
            patDiv +=       '<div >' + rowData.patNo + '</div>';
            patDiv +=       '<div>/</div>';
            patDiv +=       '<div>' + rowData.patName + '</div>';
            patDiv +=       '<div>/</div>';
            patDiv +=       '<div>' + rowData.patSex + '</div>';
            patDiv +=       '<div>/</div>';
            patDiv +=       '<div>' + rowData.patage + '</div>';
            patDiv +=       '<div>/</div>';
            patDiv += '</div>';
            prescDiv += '<div id="grpViewPresc" class="pha-op-grid-grpviewpresc">';
            prescDiv +=     '<div>' + rowData.TPrescNo + '</div>';
            prescDiv +=     '<div>/</div>';
            prescDiv +=     '<div>' + rowData.dispStat + '</div>';
            prescDiv += '</div>';
            viewDiv+= '<div id="pha-op-grid-grpviewbase" class="pha-op-grid-grpviewbase">'  + prescDiv + patDiv + '</div>';
            return viewDiv;
        },
        rowStyler: function(index,rowData){
            //return OP_COMPOMENTS.GridDifRowStyler(index,rowData,"TPatNo");
        },
        onLoadSuccess: function(data){ 
            if(data.total>0){
                for(var i=0;i<data.total;i++){
                    var itemData =data.rows[i];
                    if(itemData.TSelect == "Yes"){
                        $("#gridPrescList").datagrid("checkRow",i)
                    } 
                }
            }
            PHA_COM.Drug.Tips(); 
        }
    })
    $('#gridPrescList').datagrid('options').view = groupview;
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
    CurPatNo = ""
    PHAOP_COM.ClearErpMenu(); // ������Ӳ����˵���Ҫ�Ĳ���
    if(!$("#fyFlag").checkbox('getValue'))PHAOP_COM.ChkUnFyOtherLoc({});
    var $grid =  $("#gridPrescList");
    var pJson = GetParams();
    if(pJson==false){return;}
    CurPatNo = $("#patNo").val();
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PyDisp.Api' ,
        pMethodName:'GetPrescInfo',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    Setfocus();
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
// ����
function Clean(){
    PHAOP_COM.ClearErpMenu();
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridWaitList').datagrid('clear');
    InitDefVal();
    QueryWaitList();
    Setfocus();
    CurPatNo = ""
    
}
// ����
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
//�����˶�
function ExecutePrescCheck(){
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var chkFlag = ChkBefDisp();
}
// ��ҩ
function ExecuteFY(){
    var $grid = $("#gridPrescList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
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
        if(checkedRows.length>1) tipMsg = "����ѡ����Ŵ������Ƿ�ͬʱ��ҩ?"
        else{tipMsg = $g("��ͨ����ѡ���з�ҩ���Ƿ�ҩ��")+ "<span>"+ checkedRows[0].TPrescNo + "</span>"}
        PHAOP_COM._Confirm($g("��ҩ"), tipMsg, function (r) {
            if (r) {    
                var len = checkedRows.length;
                var dspNum=len 
                for (var i = 0;i<len;i++ ) {
                    var rowData = checkedRows[i]
                    index = rows.indexOf(rowData);
                    retVal = CheckPayment(index)
                    if(retVal){
                        if (prescStr=="")prescStr = rowData.TPrescNo;
                        else{prescStr = prescStr + "," + rowData.TPrescNo;}
                    }
                }
            } 
        });

    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            dspNum = 1
            index = $grid.datagrid('getRowIndex',rowData)
            retVal =  CheckPayment(index);
            if(retVal){
                prescStr = rowData.TPrescNo;
            }
        }else{
            PHAOP_COM._Msg('error', "��ѡ��ҩ���ݣ�");    
        }
    }
    if(dspNum>0){ChkUnFyThisLoc(dspNum)}
    QueryWaitList();
    Setfocus();
}

/// �Ƿ���Է�ҩ
function ChkBefDisp(){
    var $grid = $("#gridPrescList");
    var rowsData = $grid.datagrid('getRows');
    var patNum = 0;
    var tmpPatNo = "";
    var patNo = "";
    var fyFlag ="";
    var prescNo = "" ;
    var len = rowsData.length;
    for (var i = 0;i<len;i++ ) {
        var rowData = rowsData[i]
        fyFlag = rowData.TFyFlag;
        patNo = rowData.TPmiNo;
        prescNo = rowData.TPrescNo;
        if(fyFlag == "OK"){
            PHAOP_COM._Msg('error', "<span>"+ rowData.TPrescNo + "</span>"+ $g("�ѷ�ҩ��"));
            return false;
        }
        if(APP_PROP.OnlyDispByPatNo == "Y"){
            if((tmpPatNo != "")&&(tmpPatNo != patNo)){
                PHAOP_COM._Msg('error', "�����ã��������໼��ͬʱ��ҩ!");
                return false;
            }
        }
        tmpPatNo = patNo        
    }
    
    return true;
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
            TPhDispStat:$g("�ѷ�ҩ")
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
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
        }); //104��ҩ��� 108��ҩʱ���� 110���ͻ�(����״̬)
        return true;
    }else{
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// �ܾ���ҩ
function ExecuteRefuseFY(){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){return}
    var prescNo = rowData.TPrescNo;
    PHAOP_COM.ShowPHAPRASelReason({
        wayId: PHAOP_COM.VAR.WayId,
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
    var selIndex = $grid.datagrid('getRowIndex',rowData);//��ȡ�к�

    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'SaveOPAuditResult',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TDocSS : $g("�ܾ���ҩ")
        }   
        $grid.datagrid('updateRowData', {
            index: selIndex,
            row: updData
        });
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// ȡ���ܾ���ҩ
function CancelRefuseFY(){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){return}
    var selIndex = $grid.datagrid('getRowIndex',rowData);//��ȡ�к�
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
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
    
}
function PrintHandler(type){
    var $grid = $("#gridPrescList");
    var checkedRows = $grid.datagrid('getChecked');
    if (checkedRows.length >0){
        for (var i = 0; i < checkedRows.length; i++) {
            var rowData = checkedRows[i]
            RePrint(rowData,type)
        }
    }else{
        var rowData = $grid.datagrid('getSelected');
        if(rowData != null){
            RePrint(rowData,type)
        }else{
            PHAOP_COM._Msg('error', "��ѡ���ӡ���ݣ�");
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
        rePrint:"(��)"
    })
}
// ��ҩ
function Return(){
    var lnk = "pha.op.v4.return.csp";
    websys_createWindow(lnk, $g("��ҩ"), "width=95%,height=75%")
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

/* ����շ���� */
function CheckPayment(index){
    var $grid = $("#gridPrescList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo
    var pJson = {
        prescNo : prescNo,
    }
    /* ��ȡ�����е�δ����ҽ����Ϣ */
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.COM.Api',
        pMethodName: 'GetUnPaidInfo',
        pJson: JSON.stringify(pJson)
    },false);
    var unPaidInfo = retVal.data;
    var retFlag;
        /* ����δ����ʱ�Ƿ�������ҩ */
    if (unPaidInfo !== ""){
        if (APP_PROP.PartPiedDispFlag == "Y") {
            PHAOP_COM._Confirm("",prescNo + $g("�д���δ���ѵ�ҽ����ϸ!ҽ������Ϊ:") + "<br/>" + unPaidInfo + "<br/>" + $g("���[ȷ��]��������ҩ�����[ȡ��]��������ҩ������"), function (r) {
                if (r == true) {
                    retFlag = Dispening(index); 
                    return retFlag;
                } else {
                    return false;
                }
            });
        }
        else {
            PHAOP_COM._Alert(prescNo + $g("�д���δ���ѵ�ҽ����ϸ,��ֹ��ҩ!ҽ������Ϊ:") + "<br/>" + unPaidInfo)
            return false;
        }
    }
    else{
        retFlag = Dispening(index); 
        return retFlag  
    }   
}
function ChkUnFyThisLoc(dspPrescNum){
    if(APP_PROP.ChkUnDispPrescNum != ""){return}
    var patNo = CurPatNo;
    var $grid = $("#gridPrescList");

    if(dspPrescNum != 1){
        var rowsData = $grid.datagrid('rowsData');
        var rowNum = rowsData.length;    
        var successNum=0;
        for (var rowi = 0; rowi < rowNum; rowi++) {
            rowData = rowsData[rowi]
            var okFlag = rowData.TFyFlag;        
            if(okFlag == "OK")successNum = successNum + 1
        }
        dspPrescNum = successNum;
    }
    var phlId=PHAOP_COM.DEFAULT.phlId;
    var winId = PHAOP_COM.DEFAULT.winIdStr;
    var stDate = $("#stDate").datebox("getValue")|| ""; 
    var endDate = $("#endDate").datebox("getValue")|| ""; 

    if (patNo!=""){
        var unDspNum=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyThisLoc",stDate,endDate,patNo,phlId)
        var otherLocRet=tkMakeServerCall("PHA.OP.COM.Method","ChkUnFyOtherLoc",stDate,endDate,patNo,phlId,winId)
        if (unDspNum<0) unDspNum=0
        if (unDspNum>=0) { 
            var prescNum = parseInt(unDspNum) + dspPrescNum;
            var alertMsg=$g("�û��߱��ξ��ﹲ�ɷѴ�����������")+prescNum+"<br>"+$g("�˴η�ҩ��������")+dspPrescNum+"</br>"+$g("������������")+unDspNum
            if (otherLocRet!="") alertMsg=alertMsg +"</br>"+otherLocRet
            PHAOP_COM._Alert(alertMsg)
        }
        else  if (otherLocRet!="") {
            PHAOP_COM._Alert(otherLocRet)
        }
    }else  {
        PHAOP_COM._Alert($g("�˴η�ҩ��������")+ "<span>"+ dspPrescNum + "</span>");
    }   
}
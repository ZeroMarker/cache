/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.08.26
 *  Description ����Ƿҩ����
 */
var COMPOMENTS ={};
PHAOP_COM.VAR.WinType = "Owe";
PHAOP_COM.VAR.PermissionTpe = "FY";
PHAOP_COM.VAR.CAModelCode = "PHAOPExecuteFY";
PHAOP_COM.VAR.TIMER = "";
PHAOP_COM.VAR.TIMERSTEP = 30 * 1000;
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME)
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    CheckPermission();      //  ��֤��ԱȨ��
    InitGridOweList();  //  �����б�
    InitGridOweDetail();    //  ������ϸ
    InitEvent();            //  ��ť�¼�
    ResizePanel();          //  ���ֵ���    
    Clean();                //  ������ʼ����ѯ����
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryOweList();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
    
    //��� toolbar
    PHA_EVENT.Bind('#btnFY',            'click', function () {
        PHAOP_COM.CACert({},ExecuteFY);
    });
    PHA_EVENT.Bind('#btnReturn',        'click', function () {
        PHAOP_COM.CACert({modelName:"PHAOPReturn"},DoReturn);
    });
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    $('#prescNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var prescNo = $.trim($("#prescNo").val());
            if (prescNo != "") {
                QueryOweList();
            }
        }
    });
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                QueryOweList();
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
    /* �󶨰�ť�¼� start*/
    $("#fyFlag").on("change",function(){
        if($(this).is(':checked')==true){
            $('#returnFlag').checkbox('uncheck');       
        }
    })
    $("#returnFlag").on("change",function(){
        if($(this).is(':checked')==true){
            $('#fyFlag').checkbox('uncheck');       
        }
    })
    
}
// ���ֵ���
function ResizePanel(){
    setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��grid',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
// ��ʼ����ѯ����
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
}
function InitGridOweList(){
    var frozenCol=[[
        {field:'pid',               title: ("���̺�"),             width:100,      hidden:true},
        {field:'TPatName',          title: ("����"),          width:100},
        {field:'TPmiNo',            title: ("�ǼǺ�"),         width:100},
        {field:'TPrtDate',          title: ("�շ�����"),        width:100},
        {field:'TPrtInv',           title: ("�վݺ�"),         width:90,       hidden:true},
        {field:'TPrescNo',          title: ("����"),          width:120}
        
    ]];
    var normalCol=[[
        {field:'TPrescMoney',       title: ("���"),          width:70,       align:'right'},
        {field:'TPerSex',           title: ("�Ա�"),          width:40},
        {field:'TPerAge',           title: ("����"),          width:40},
        {field:'TPerLoc',           title: ("����"),          width:100},     
        {field:'TPrescType',        title: ("�ѱ�"),          width:70},
        {field:'TCallCode',         title: ("�绰"),          width:100},
        {field:'TOweDate',          title: ("Ƿҩʱ��"),        width:140},
        {field:'TOweUser',          title: ("Ƿҩ��"),         width:100},
        {field:'TOweStatusdesc',    title: ("Ƿҩ״̬"),        width:70},  
        {field:'TOweretdate',       title: ("��ҩ����"),        width:100},
        {field:'TOweretuser',       title: ("��ҩ��"),         width:70},
        {field:'TMR',               title: ("���"),          width:250},
        {field:'TEncryptLevel',     title: ("�����ܼ�"),        width:100,      hidden:PHAOP_COM.ColHidden.PatLevel},       
        {field:'TPatLevel',         title: ("���˼���"),        width:100,      hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'TPrt',              title:'TPrt',               width:60,       hidden:true},
        {field:'TOwedr',            title:'TOwedr',             width:60,       hidden:true},
        {field:'Tphdrowid',         title:'Tphdrowid',          width:80,       hidden:true}
    ]]
     COMPOMENTS.ComomGrid("gridOweList",{
         columns: normalCol,
         frozenColumns: frozenCol,
         onSelect : function(rowIndex, rowData) {
            QueryOweDetail();
            var prescNo = rowData.TPrescNo;
            PHAOP_COM.InitErpMenu({prescNo:prescNo});   
        },onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridOweList').datagrid("selectRow",0);
            }else{
                $('#gridOweDetail').datagrid('clear');
            }
        },
        rowStyler:function(index,rowData){
            return COMPOMENTS.GridDifRowStyler(index,rowData,"TPmiNo");
        }
    })
}
function InitGridOweDetail(){
    var normalCol=[[
        {field:'TInciDesc',         title: ("ҩƷ����"),        width:250,align:'left'},
        {field:'TPhUom',            title: ("��λ"),          width:60},
        {field:'TPhQty',            title: ("Ƿҩ����"),        width:70,align:'right'},
        {field:'TRealQty',          title: ("Ԥ��"),          width:70,
            editor: PHA_GridEditor.NumberBox({
                required: true,
                checkOnBlur: true,
                checkValue: function (val, checkRet) {
                    if (val == "") {
                        checkRet.msg = "����Ϊ�գ�"
                        return false;
                    }
                    var nQty = parseFloat(val);
                    if (isNaN(nQty)) {
                        checkRet.msg = "���������֣�";
                        return false;
                    }
                    if (nQty < 0) {
                        checkRet.msg = "���������0�����֣�";
                        return false;
                    }
                    var reg = /^[0-9]\d*$/;
                    if (!reg.test(nQty)) {
                        PHAOP_COM._Alert("Ԥ������ֻ��Ϊ����!")
                        return false;
                    }
                    return true;
                },
                onBlur:function(val, rowData, rowIndex){
                    var realQty = parseFloat(val);;
                    var phQty = rowData.TPhQty;
                    if(phQty<realQty){
                        PHAOP_COM._Alert("Ԥ�������費����Ƿҩ����")
                        return false
                    }                               
                }
            })      
        },
        {field:'TDispedqty',            title: ("�ѷ�"),      width:70},
        {field:'TPrice',                title: ("����"),      width:80,       align:'right'},
        {field:'TMoney',                title: ("���"),      width:80,       align:'right'},
        {field:'TOrdStatus',            title: ("״̬"),      width:50},
        {field:'TDoseQty',              title: ("����"),      width:50},
        {field:'TPC',                   title: ("Ƶ��"),      width:60},
        {field:'TYF',                   title: ("�÷�"),      width:40},
        {field:'TLC',                   title: ("�Ƴ�"),      width:40},
        {field:'TDoctor',               title: ("ҽʦ"),      width:70,       hidden:true},
        {field:'TInsuCode',             title: ("ҽ�����"),    width:70},
        {field:'TIncHW',                title: ("��λ"),      width:70},
        {field:'TSpec',                 title: ("���"),      width:70},
        {field:'TPhbz',                 title: ("��ע"),      width:80},
        {field:'TManfDesc',             title: ("������ҵ"),    width:200},
        {field:'TKCFlag',               title: ("���"),      width:50},
        {field:'TKCQty',                title: ("�������"),    width:80},
        {field:'TOrditm',               title:'TOrditm',        width:80,       hidden:true},
        {field:'TUnit',                 title:'TUnit',          width:80,       hidden:true},
        {field:'TDoctCode',             title:'TDoctCode',      width:80,       hidden:true},
        {field:'TInci',                 title:'TInci',          width:80,       hidden:true}
        
    ]]; 
    COMPOMENTS.ComomGrid("gridOweDetail",{
        columns: normalCol,
        isCellEdit:true,
        onClickCell: function (index, field, value) {
            if(field != "TRealQty"){return;}
            PHA_GridEditor.Edit({
                gridID: "gridOweDetail",
                index: index,
                field: field
            });
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
// ��ѯ�����б�
function QueryOweList(){
    PHAOP_COM.ClearErpMenu(); // ������Ӳ����˵���Ҫ�Ĳ���
    var $grid =  $("#gridOweList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Owe.Api' ,
        pMethodName:'GetOweList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
    Setfocus();
}
// ��ѯ������ϸ
function QueryOweDetail(){  
    var $grid =  $("#gridOweDetail");
    var selRowData = $("#gridOweList").datagrid('getSelected');
    if(selRowData == null){return}
    var pJson={};
    pJson.locId = PHAOP_COM.LogonData.LocId;
    pJson.oweId = selRowData.TOwedr;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Owe.Api' ,
        pMethodName:'GetOweDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
    if(PHAOP_COM.DEFAULT.RetNeedReq == "Y"){
        $("#btnReturn").css("display","none");
    }
    PHAOP_COM.ClearErpMenu();
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridOweList').datagrid('clear');
    $('#gridOweDetail').datagrid('clear');
    InitDefVal();
    Setfocus();
    
}
// ����
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryOweList)

}
function ChkBefDisp(){
    var $grid = $("#gridOweList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData != null){
        var prescno=rowData.TPrescNo;
        var owestat=rowData.TOweStatusdesc;
        var patname=rowData.TPatName;
        var warnInfo=$g("��������:")+patname+"</br>"+$g("������:")+prescno+"</br>";
        if((owestat==$g("�ѷ�ҩ"))||(owestat==$g("����ҩ"))){
            PHAOP_COM._Alert(warnInfo+owestat);
            return false;
        }
    }else{
        PHAOP_COM._Msg('error', "��ѡ����ҩ���ݣ�");
        return false;           
    }
}
// ��ҩ
function ExecuteFY(){
    var $grid = $("#gridOweList");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var chkFlag = ChkBefDisp();
    if(chkFlag == false){return false;}
    var rowData = $grid.datagrid('getSelected');
    if(rowData != null){
        index = $grid.datagrid('getRowIndex',rowData)
        retVal = OweDispMonitor(index);
        if(retVal == true){PHAOP_COM._Msg("success","Ƿҩ��ҩ�ɹ�!");}
    }else{
        PHAOP_COM._Msg('error', "��ѡ��Ƿҩ��ҩ���ݣ�");
    }
    
    Setfocus();
}
// Ƿҩ����
function OweDispMonitor(index){
    var detailData = $("#gridOweDetail").datagrid("getRows");
    var chkFlag = 0;        //�Ƿ�����ҪǷҩ��¼
    var allowe = 1;         //
    var zeroFlag = 0;       //�Ƿ����跢ҩ��¼  
    var rowsDispQtyStr = 0
    for (var rowi = 0; rowi < detailData.length; rowi++) {
        var oeoriQty =  $.trim(detailData[rowi].TPhQty);
        var realQty =  $.trim(detailData[rowi].TRealQty);
        if (parseFloat(realQty) > 0) {
            var zeroFlag = 1;
        }
        if(realQty < 0){
            PHAOP_COM._Alert("Ԥ����������С��0!");
            return false
        }
        if (parseFloat(realQty) > parseFloat(oeoriQty)) {
            PHAOP_COM._Alert("Ԥ���������ܴ���Ƿҩ����!");
            return false;
        }
        var reg = /^[0-9]\d*$/;
        if (!reg.test(parseFloat(realQty))) {
            PHAOP_COM._Alert("Ԥ������ֻ��Ϊ����!")
            return false;
        }
        if (parseFloat(realQty) != parseFloat(oeoriQty)) {
            chkFlag = "1";
        }
        if (allowe != 0) {
            allowe = 0
        }
        var ordItm = detailData[rowi].TOrditm
        var uomId = detailData[rowi].TUnit
        var inci = detailData[rowi].TInci
        var tmpDispString = ordItm + "," + realQty + "," + oeoriQty + "," + uomId + "," + inci
        if (rowsDispQtyStr == 0) {
            rowsDispQtyStr = tmpDispString
        } else {
            rowsDispQtyStr = rowsDispQtyStr + "!!" + tmpDispString
        }

    }
    if (zeroFlag != 1) {
        PHAOP_COM._Alert("Ԥ���������ܶ�Ϊ0!");
        return false;
    }
    var rowData =  $("#gridOweList").datagrid("getRows")[index];
    var oweDr=rowData.TOwedr;
    var prescNo=rowData.TPrescNo;
    dispQtyStr = chkFlag + "&&" + allowe + "&&" + rowsDispQtyStr+ "&&" +  oweDr;
    if (chkFlag == "1") {
        PHAOP_COM._Confirm("","<span>"+ prescNo + "</span>"+ $g("�Ƿ���Ҫ����Ƿҩ��? ���[ȷ��]���ɣ����[ȡ��]�˳�"), function (r) {
            if (r == true) {
                var retVal = Dispening(index,dispQtyStr)
                return retVal
            } else {
                return false;
            }
        });
    } else {
        var retVal = Dispening(index,dispQtyStr)
        return retVal;
    }

}
// ��ҩ
function Dispening(index,dispQtyStr){
    
    var $grid = $("#gridOweList");
    var rowData = $grid.datagrid("getRows")[index];
    var prescNo = rowData.TPrescNo;
    var pJson ={
        phlId : PHAOP_COM.DEFAULT.phlId,
        winIdStr : PHAOP_COM.DEFAULT.winIdStr,
        fyPerId : PHAOP_COM.DEFAULT.phPerId,
        pyPerId : PHAOP_COM.DEFAULT.phPerId,  // Ƿҩ��ҩʱ����ҩ��=��ҩ��
        prescNo : prescNo,
        dispQtyStr:dispQtyStr
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.DirDisp.Api',
        pMethodName: 'SaveDispData',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var phdId = retVal.data;
        var updData = {
            TOweStatusdesc:$g("�ѷ�ҩ"),
            Tphdrowid:phdId
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        var phOweId=tkMakeServerCall("PHA.OP.COM.Print","GetPhOweByPhd",phdId);
        OP_PRINTCOM.PrintPhdOwe(phOweId);
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
// Ƿҩ-��ҩ
function DoReturn(){
    var $grid = $("#gridOweList");
    var rowData = $grid.datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg('error', "��ѡ��Ƿҩ��ҩ���ݣ�");
        return false;
    }
    var rows = $("#gridOweDetail").datagrid('getRows');
    if (rows.length ==0) {
        PHAOP_COM._Msg('error', "��ϸû�����ݣ�");
        return false;
    }
    var index = $grid.datagrid('getRowIndex',rowData)
    var prescNo=rowData.TPrescNo;
    var oweId=rowData.TOwedr;
    var pJson ={
        prescNo:prescNo,
        oweId:oweId,
        userId:PHAOP_COM.LogonData.UserId
    }
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.Owe.Api',
        pMethodName: 'ExcRetrun',
        pJson: JSON.stringify(pJson)
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        var updData = {
            TOweStatusdesc:$g("����ҩ"),
            TOweretdate:retVal.data.oweRetDate,
            TOweretuser:retVal.data.oweRetUser
        }   
        $grid.datagrid('updateRowData', {
            index: index,
            row: updData
        });
        PHAOP_COM.SaveCACert({
            signVal:oweId,
            modelName:"PHAOPReturn",
            type:"OH"
        })
        PHAOP_COM._Msg("success", "Ƿҩ��ҩ�ɹ�,�뵽�շѴ��˷�!"); 
        return true;
    }else{
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
}
// ��ԱȨ��
function CheckPermission(){
    PHAOP_COM.CheckPermission({
        permissionType:PHAOP_COM.VAR.PermissionTpe,
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

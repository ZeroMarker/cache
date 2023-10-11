/*
 *  Creator     zhaozhiduan
 *  CreatDate   2022.09-05
 *  Description ����ҩ��--�������д�ӡ
 *  JS          scripts/pha/op/v4/query.locpresc.js
 */
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
var COM_PID = "";
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    InitGridPrescList();    //  �����б�
    InitGridPrescDetail();  //  ������ϸ
    InitDict();             
    InitEvent();            //  ��ť�¼�
    ResizePanel();          //  ���ֵ���    
    Clean();                //  ������ʼ����ѯ����
    $("#cardNo").imedisabled();
})
function InitEvent(){
    PHA_EVENT.Bind('#btnFind',          'click', function () {QueryPrescList();});
    //��� toolbar
    PHA_EVENT.Bind('#btnRePrint',       'click', function () {RePrint();});
    PHA_EVENT.Bind('#btnClean',         'click', function () {Clean();});
    PHA_EVENT.Bind('#btnExport',        'click', function () {Export();});
    PHA_EVENT.Bind('#btnReadCard',      'click', function () {ReadCard();});
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
        PHA_COM.ResizePanel({
            layoutId: 'layout-op��condition',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
    // ҽ������--  ҽ�����ҡ������������
    PHA.ComboBox('docLoc',{
        blurValidValue:true,
        url:  PHAOP_STORE.CTLOC().url+"&TypeStr="+"E,EM,OP" 
    });
     PHA.ComboBox('prescType',{
        blurValidValue:true,
        panelHeigh:"auto",
        url:  PHA_STORE.ComDictionary("PrescType").url 
    });
    
}
// ��ʼ����ѯ����
function InitDefVal(){
    $("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
    $("#endDate").datebox("setValue",'t') ;
    $("#fyFlag").checkbox('setValue', true);
    $("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");

}
function InitGridPrescList(){
    var frozenCol=[[
        {field:'gridSelect',        checkbox: true },
        {field:'prescStat',         title: ("״̬-todo"),     width:100,      align:'center',     hidden:true},
        {field:'docLocDesc',        title: ("��������"),        width:140,      align:'left'},
        {field:'patNo',             title: ("�ǼǺ�"),         width:90,       align:'center',
            formatter: function (value, rowData, index) {
                return '<a class="pha-op-grid-link">' + value + '</a>';
            }
        },  
        {field:'patName',           title: ("����"),          width:100,      align:'left'},   
        {field:'spAmt',             title: ("ҩ��"),          width:75,       align:'right'},
        {field:'prescNo',           title: ("������"),         width:125,      align:'center'},
        {field:'prescType',         title: ("��������"),        width:75,       align:'center'},
    ]];
    var normalCol = [[
        {field:'diagDesc',          title: ("���"),          width:200,      align:'left'},
        {field:'prtDate',           title: ("�շ�����"),        width:90,       align:'center'},
        {field:'prtTime',           title: ("�շ�ʱ��"),        width:90,       align:'center'},
        {field:'fyDate',            title: ("��ҩ����"),        width:90,       align:'center'},
        {field:'fyTime',            title: ("��ҩʱ��"),        width:90,       align:'center'},
        {field:'pyUserName',        title: ("��ҩ��"),         width:90,       align:'left'},
        {field:'fyUserName',        title: ("��ҩ��"),         width:90,       align:'left'},
        {field:'winDesc',           title: ("��ҩ����"),        width:90,       align:'left'},
        {field:'encryptLevel',      title: ("�����ܼ�"),        width:100,      align:'left',       hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'patLevel',          title: ("���˼���"),        width:100,      align:'left',       hidden:PHAOP_COM.ColHidden.PatLevel},
        {field:'admId',             title:"admId",              width:100,      align:'left',       hidden:true},
        {field:'pid',               title:"pid",                width:100,      align:'left',       hidden:true}
            
    ]]
    COMPOMENTS.ComomGrid("gridPrescList",{
        columns: normalCol,
        frozenColumns: frozenCol,
        toolbar : '#gridPrescListBar',
        onSelect : function(rowIndex, rowData) {
            QueryPrescDetail();
        },onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridPrescList').datagrid("selectRow",0);
                COM_PID = $('#gridPrescList').datagrid("getRows")[0].pid;
                $('#gridPrescList').datagrid("options").queryParams.pid =COM_PID;
            }else{
                $('#gridPrescDetail').datagrid('clear');
            }
        }
    })
    var eventClassArr = [];
    eventClassArr.push('pha-op-grid-link');
    PHA.GridEvent('gridPrescList', 'click', eventClassArr, function(rowIndex, rowData, className){
        PHA_UX.AdmDetail({},{
            AdmId:rowData.admId
        })
    })
}
function InitGridPrescDetail(){
    var normalCol = [[
         {field:'oeoriStatDesc',        title: ("״̬"),      width:60,       align:'center',
            styler: function(value, rowData, index) {
                var styleCls = "";
                if ((value.indexOf($g("����")) > -1) || (value.indexOf("ֹͣ") > -1)) {
                    styleCls = {class:'pha-op-grid-ordstop'};
                }
                return styleCls;
            }
        }, 
        {field:'arcItmDesc',            title: ("ҩƷ"),      width:200,      align:'left'},  
        {field:'oeoriQty',              title: ("ҽ������"),    width:65,       align:'right'},     
        {field:'uomDesc',               title: ("��λ"),      width:80,       align:'center'},    
        {field:'sp',                    title: ("�۸�"),      width:80,       align:'right'},
        {field:'spAmt',                 title: ("���"),      width:80,       align:'right'},
        {field:'dosage',                title: ("����"),      width:80,       align:'left'},    
        {field:'freqDesc',              title: ("Ƶ��"),      width:80,       align:'left'},
        {field:'instrucDesc',           title: ("�÷�"),      width:80,       align:'left'},    
        {field:'duraDesc',              title: ("�Ƴ�"),      width:80,       align:'left'},
        {field:'dispQty',               title: ("�ѷ�ҩ"),     width:50,       align:'left'}, 
        {field:'retQty',                title: ("����ҩ"),     width:50,       align:'left'},    
        {field:'oeoriRemark',           title: ("ҽ����ע"),    width:120,      align:'left'}
    ]];
    COMPOMENTS.ComomGrid("gridPrescDetail",{
        columns: normalCol
    })
}
function GetParams(){
    var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
    if(retJson[0] == undefined) {return false;}
    var pJson = {};
    pJson = retJson[0];
    pJson.locId = PHAOP_COM.LogonData.LocId;
    return pJson;
}
// ��ѯ�����б�
function QueryPrescList(){
    COM_PID = "";
    var $grid =  $("#gridPrescList");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PreBatPrt.Api' ,
        pMethodName:'GetPrescList',
        pPlug:'datagrid',
        pid:"",
        pJson: JSON.stringify(pJson)
    }); 

}

// ��ѯ������ϸ
function QueryPrescDetail(){    
    var $grid =  $("#gridPrescDetail");
    var rowData = $("#gridPrescList").datagrid('getSelected');
    if(rowData == null){
        PHAOP_COM._Msg('error', "��ѡ�񴦷����ݣ�");
        return false;
    }
    var pJson = {};
    pJson.prescNo = rowData.prescNo;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PreBatPrt.Api' ,
        pMethodName:'GetPrescDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridPrescList').datagrid('clear');
    $('#gridPrescList').datagrid("uncheckAll")
    $('#gridPrescDetail').datagrid('clear');
    InitDefVal();
    KillTmpGloal();
    COM_PID = "";
}
// ��ӡ
function RePrint(){
    var checkedRows = $("#gridPrescList").datagrid('getChecked');
    if (checkedRows.length === 0) {
        var selRowData = $("#gridPrescList").datagrid('getSelected');
        if(selRowData == null){return}
        else{
            checkedRows.push(selRowData);
        }
    }
    for (var i = 0; i < checkedRows.length; i++) {
        var rowData = checkedRows[i];
        var prescNo = rowData.prescNo;
        OP_PRINTCOM.Presc(prescNo,"����", "");
    }
}

function Export(){
    PHAOP_COM.ExportGrid("gridPrescList");
}
// ����
function ReadCard(){
    PHA_COM.ReadCard({
        CardNoId : "cardNo",
        PatNoId : "patNo"
    },QueryPrescList)

}
// �����ʱglobal
function KillTmpGloal() {
    PHAOP_COM.KillTmpOnUnLoad("PreBatPrt.Query",COM_PID);
}
window.onbeforeunload = function (){
    KillTmpGloal();
}
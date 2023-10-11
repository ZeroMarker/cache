/*
*   Creator     zhaozhiduan
*   CreatDate   2023-03-02
*   Description ����ҩ�����������-
*        �磬����ҩ���Ĵ���������5���Ժ�ɵ�����ȡҩ
*   Path        scripts/pha/op/v4/crossrecloc.js
*/

var COMPOMENTS ={};
var diag_width = 288.5;
$(function () {
    COMPOMENTS = OP_COMPOMENTS;
    InitDict();
    InitGridDict();
    InitEvent();
    HelpInfo();
    setTimeout(function () {
        QueryCrossRecLoc();
    }, 300)
})
function InitEvent(){
    $('#btnFind').on('click', QueryCrossRecLoc);
    $('#btnClean').on('click', Clean);
    $('#btnAdd,#btnSave').on('click', function () {
        ShowDiagCrossRecLoc(this);
    });
    $('#btnDel').on('click', DelCrossRecLoc);
}

function InitDict(){
    
    // ʵ�ʷ�ҩҩ��
    PHA.ComboBox('aftLocId',{
        editable:false, 
        url: PHAOP_STORE.PHLOC().url,
        onLoadSuccess: function () {
            var datas = $("#aftLocId").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == session['LOGON.CTLOCID']) {
                    $("#aftLocId").combobox("setValue", datas[i].RowId);
                    $("#aftLocId").combobox("options").defVal = datas[i].RowId;
                    break;
                }
            }
            if(datas.length>0){
                $("#aftLocId").combobox("setValue", datas[0].RowId);
                $("#aftLocId").combobox("options").defVal = datas[0].RowId;
            }
        }
        
    });
    // ԭ��ҩҩ��
    PHA.ComboBox('oriLocId',{
        editable:false, 
        url: PHAOP_STORE.PhLocByHosp().url
    });
    // ʵ�ʷ�ҩҩ��
    PHA.ComboBox('diag_aftLocId',{
        editable:false, 
        width:diag_width,
        url: PHAOP_STORE.PHLOC().url
    });
     // ԭ��ҩҩ��
    PHA.ComboBox('diag_oriLocId',{
        editable:false, 
        width:diag_width,
        url: PHAOP_STORE.PhLocByHosp().url
    });
     // �ܼ� 
     PHA.ComboBox('diag_weekDay',{
        width:diag_width,
        multiple:true,
        editor:false,
        //rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
        panelHeight:'auto',
        selectOnNavigation:false,
        url: PHAOP_STORE.WeekDay().url
    });
   
}
function InitGridDict(){
    var normalCol = [[
        {field: 'rowId',            title: "RowId",                width: 120,         align: 'left',          hidden: true},
        {field: 'aftLocId',         title: "ʵ�ʷ�ҩҩ��Id",    width: 100,         align: 'left',          hidden: true},
        {field: 'oriLocId',         title: "ԭ��ҩҩ��Id",      width: 100,         align: 'left',         hidden: true},
        {field: 'aftLocDesc',       title: "ʵ�ʷ�ҩҩ��",      width: 150,         align: 'left' },
        {field: 'oriLocDesc',       title: "ԭ��ҩҩ��",        width: 150,         align: 'left'},
        {field: 'startTime',        title: "��ʼʱ��",              width: 100,         align: 'left'},
        {field: 'endTime',          title: "����ʱ��",              width: 100,          align: 'left'},
        {field: 'weekDay',          title: "����������д",          width: 100,          align: 'left',         hidden: true},
        {field: 'weekDayDesc',      title: "��������",              width: 100,          align: 'left'},
        {field: 'useDate',          title: "ʹ������",              width: 100,         align: 'left'}
    ]];
    COMPOMENTS.ComomGrid("gridCrossRecLoc",{
        toolbar : '#gridCrossRecLocBar',
        columns:normalCol,
        gridSave: false,
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                ShowDiagCrossRecLoc($('#btnSave')[0])
            }
        },
        onLoadSuccess : function(data) {
            if(data.total>0){
                $('#gridCrossRecLoc').datagrid("selectRow",0);
            }
        }
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

function QueryCrossRecLoc(){
    var $grid =  $("#gridCrossRecLoc");
    var pJson = GetParams();
    if(pJson==false){return;}
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.CrossRecLoc.Api' ,
        pMethodName:'Query',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function Clean(){
    PHA.DomData("#qCondition",{doType: 'clear'});
    $('#gridCrossRecLoc').datagrid('clear');
    $('#aftLocId').combobox('reload');
}
function ShowDiagCrossRecLoc(btnOpt){
    var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
    var crlRowId = "";
    if (ifAdd == false) {
        var gridSelect = $('#gridCrossRecLoc').datagrid('getSelected') || '';
        if (gridSelect == '') {
            PHA.Popover({
                msg: '����ѡ����Ҫ�޸ĵļ�¼',
                type: 'alert'
            });
            return;
        }
        crlRowId = gridSelect.rowId;
    }
    $("#diagCrossRecLoc").dialog({
        title: '��¼' + btnOpt.text,
        iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
        modal: true
    }).dialog('open');
    if (ifAdd == false) {
        $('#diag_btnAdd').hide();
        $('#div_useEndDate').attr("disabled",true);
        $("#diag_useEndDate").datebox('disable');
        PHA.ComboBox('diag_weekDay',{
            width:diag_width,
            multiple:false,
            editor:false
        })
        var pJson = {};
        pJson.rowId = crlRowId;
        PHA.CM({
            pClassName: 'PHA.OP.CrossRecLoc.Api',
            pMethodName: 'GetOneCrossRecLoc',
            pJson: JSON.stringify(pJson)
        },function(data) {
            PHA.Loading("Hide")
            if(PHA.Ret(data)){
                $('#diag_rowId').val(data.rowId);
                $('#diag_aftLocId').combobox("setValue",data.aftLocId);
                $('#diag_oriLocId').combobox("setValue",data.oriLocId);
                $('#diag_weekDay').combobox("setValue",data.weekDay);
                $('#diag_startTime').timespinner("setValue",data.startTime);
                $('#diag_endTime').timespinner("setValue",data.endTime);
                $('#diag_useStDate').datebox("setValue",data.useDate);
                $('#diag_useEndDate').datebox("setValue","");
            }else{
                PHAOP_COM._Alert(data.msg);
            }
        },function(failRet){
            PHA_COM._Alert(failRet);
        })
    } else {
        PHA.ComboBox('diag_weekDay',{
            width:diag_width,
            multiple:true,
            editor:false
        })
        $("#diag_useEndDate").datebox('enable');
        PHA.DomData("#diag_qCondition",{doType: 'clear'});
        var aftLocId = $('#aftLocId').combobox("getValue");
        $('#diag_aftLocId').combobox("setValue",aftLocId);
    }
}
function SaveCressRecLoc(type){
    var retJson = PHA.DomData("#diag_qCondition",{doType: 'query',retType: 'Json'});
    retJson[0].weekDayStr = retJson[0].diag_weekDay;
    var pJsonStr = JSON.stringify(retJson[0]).replace(/diag_/g, '');
    pJsonStr.weekDayStr = pJsonStr.weekDay
    var retVal = PHA.CM({
        pClassName: 'PHA.OP.CrossRecLoc.Api',
        pMethodName: 'SaveData',
        pJson: pJsonStr
    },false);
    var retCode = retVal.code; 
    if(retCode == 0){
        PHAOP_COM._Msg('success', "����ɹ�!");
    } else {
        PHAOP_COM._Alert(retVal.msg);
        return false;
    }
    if (type == 1) {
        var aftLocId = $('#diag_aftLocId').combobox("getValue");
        PHA.DomData("#diag_qCondition",{doType: 'clear'});
        $('#diag_aftLocId').combobox("setValue",aftLocId);
    } else {
        $('#diagCrossRecLoc').dialog('close');
        QueryCrossRecLoc();
    }
}
function DelCrossRecLoc(){
    var $grid =  $('#gridCrossRecLoc');
    var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHAOP_COM._Msg('error','����ѡ����Ҫ�h���ļ�¼');
        return;
    }
    PHAOP_COM._Confirm("", $g("��ȷ��ɾ����ǰ��¼��") + "<br/>" + $g("���[ȷ��]������ɾ�������[ȡ��]������ɾ��������"), function (r) {
        if (r == true) {
            crlRowId = gridSelect.rowId;
            var pJson = {};
            pJson.rowId = crlRowId;
            var retVal = PHA.CM({
                pClassName: 'PHA.OP.CrossRecLoc.Api',
                pMethodName: 'Delete',
                pJson: JSON.stringify(pJson)
            },false);
            var retCode = retVal.code;
            if(retCode == 0){
                PHAOP_COM._Msg('success', "ɾ���ɹ�!");
                var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
                $grid.datagrid('deleteRow', rowIndex);
            } else {
                PHAOP_COM._Alert(retVal.msg);
                return false;
            }
        }else {
            return false;
        }
    })
    
}

function HelpInfo() {
    $("#btnHelp").popover({
        title: '����ҷ�ҩά��',
        trigger: 'hover',
        padding: '10px',
        width: 650,
        content: '<div>'
         + $g("����ҷ�ҩ��Aҩ��������ָ��ʱ���ڲ�ѯBҩ���Ĵ��������ɷ�ҩ")+'<br>'
         + '<div class="pha-row pha-line" ><a style="color:red">'+$g("���ʽ���")+'��</a></div>'
         + '&emsp;&emsp;'+$g("ԭ��ҩҩ������ҽ��ʱ������/ҽ���Ľ��տ��ң���Bҩ��")+'<br>'
         + '<p class="pha-row">&emsp;&emsp;'+$g("ʵ�ʷ�ҩҩ��������ҷ�ҩ��ҩ������Aҩ��")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("��ʼʱ��-����ʱ�䣺���Կ���ҷ�ҩ��ʱ��Σ���ָ��ʱ��")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("�������ڣ����Կ���ҷ�ҩ�����ӣ���������ά��")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("ʹ�����ڣ����Կ���ҷ�ҩ�����ӣ�����������ά��")+'</p >'
         + '<div class="pha-row pha-line" ><a style="color:red">'+$g("��ע")+'��</a></div>'
         + '&emsp;&emsp;'+$g("1������������������ʱ���ɶ�ѡ���������ɶ�����¼���޸�ʱ����Ҫ��ѡ")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("2������ʹ����������ʱ����ʼ/�������ڲ�һ�������ɶ�����¼���޸�ʱ��ֻ���޸Ŀ�ʼ����")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("3��ʹ��������������������")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("4��ά����¼��ͬʱ��ʱ�䲻Ҫ����")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("5������ͨ�ù����հ�����������ά����������ڰ���ʹ������ά��")+'</p >'
         + '</div>'
    });
}
/*
*   Creator     zhaozhiduan
*   CreatDate   2023-03-02
*   Description 门诊药房跨科室配置-
*        如，门诊药房的处方，下午5点以后可到急诊取药
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
    
    // 实际发药药房
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
    // 原发药药房
    PHA.ComboBox('oriLocId',{
        editable:false, 
        url: PHAOP_STORE.PhLocByHosp().url
    });
    // 实际发药药房
    PHA.ComboBox('diag_aftLocId',{
        editable:false, 
        width:diag_width,
        url: PHAOP_STORE.PHLOC().url
    });
     // 原发药药房
    PHA.ComboBox('diag_oriLocId',{
        editable:false, 
        width:diag_width,
        url: PHAOP_STORE.PhLocByHosp().url
    });
     // 周几 
     PHA.ComboBox('diag_weekDay',{
        width:diag_width,
        multiple:true,
        editor:false,
        //rowStyle:'checkbox', //显示成勾选行形式
        panelHeight:'auto',
        selectOnNavigation:false,
        url: PHAOP_STORE.WeekDay().url
    });
   
}
function InitGridDict(){
    var normalCol = [[
        {field: 'rowId',            title: "RowId",                width: 120,         align: 'left',          hidden: true},
        {field: 'aftLocId',         title: "实际发药药房Id",    width: 100,         align: 'left',          hidden: true},
        {field: 'oriLocId',         title: "原发药药房Id",      width: 100,         align: 'left',         hidden: true},
        {field: 'aftLocDesc',       title: "实际发药药房",      width: 150,         align: 'left' },
        {field: 'oriLocDesc',       title: "原发药药房",        width: 150,         align: 'left'},
        {field: 'startTime',        title: "开始时间",              width: 100,         align: 'left'},
        {field: 'endTime',          title: "结束时间",              width: 100,          align: 'left'},
        {field: 'weekDay',          title: "星期日期缩写",          width: 100,          align: 'left',         hidden: true},
        {field: 'weekDayDesc',      title: "星期日期",              width: 100,          align: 'left'},
        {field: 'useDate',          title: "使用日期",              width: 100,         align: 'left'}
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
                msg: '请先选中需要修改的记录',
                type: 'alert'
            });
            return;
        }
        crlRowId = gridSelect.rowId;
    }
    $("#diagCrossRecLoc").dialog({
        title: '记录' + btnOpt.text,
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
        PHAOP_COM._Msg('success', "保存成功!");
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
        PHAOP_COM._Msg('error','请先选中需要刪除的记录');
        return;
    }
    PHAOP_COM._Confirm("", $g("您确定删除当前记录吗") + "<br/>" + $g("点击[确定]将继续删除，点击[取消]将放弃删除操作。"), function (r) {
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
                PHAOP_COM._Msg('success', "删除成功!");
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
        title: '跨科室发药维护',
        trigger: 'hover',
        padding: '10px',
        width: 650,
        content: '<div>'
         + $g("跨科室发药：A药房可以在指定时间内查询B药房的处方，并可发药")+'<br>'
         + '<div class="pha-row pha-line" ><a style="color:red">'+$g("名词解释")+'：</a></div>'
         + '&emsp;&emsp;'+$g("原发药药房：开医嘱时，处方/医嘱的接收科室，即B药房")+'<br>'
         + '<p class="pha-row">&emsp;&emsp;'+$g("实际发药药房：跨科室发药的药房，即A药房")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("开始时间-结束时间：可以跨科室发药的时间段，即指定时间")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("星期日期：可以跨科室发药的日子，按照星期维护")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("使用日期：可以跨科室发药的日子，按照年月日维护")+'</p >'
         + '<div class="pha-row pha-line" ><a style="color:red">'+$g("备注")+'：</a></div>'
         + '&emsp;&emsp;'+$g("1、按照星期日期新增时，可多选，但是生成多条记录。修改时，需要单选")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("2、按照使用日期新增时，开始/结束日期不一致则生成多条记录。修改时，只可修改开始日期")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("3、使用日期优先于星期日期")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("4、维护记录相同时，时间不要交叉")+'</p >'
         + '<p class="pha-row">&emsp;&emsp;'+$g("5、建议通用工作日按照星期日期维护，特殊假期按照使用日期维护")+'</p >'
         + '</div>'
    });
}
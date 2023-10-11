/*
 *模块:门诊药房
 *子模块:门诊药房-发药窗口日志
 *createdate:2020-09-23
 *creator:zhaozhiduan
 */
 
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    InitDict();
    InitGridWinLog();
    $("#btnFind").on("click", QueryWinLog);
    $("#btnClean").on("click", CleanConditions);
})
 
function InitDict(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $('#conPhStTime').timespinner('setValue', '00:00:00');
    $('#conPhEndTime').timespinner('setValue', '23:59:59');
    
    // 门诊科室
    PHA.ComboBox('conPhLoc',{
        editable:false, 
        url: PHAOP_STORE.PHLOC().url,
        onLoadSuccess: function () {
            var datas = $("#conPhLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == session['LOGON.CTLOCID']) {
                    $("#conPhLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onChange:function(newValue, oldValue){
            PHA.ComboBox("conPhlWin", {
                url: PHAOP_STORE.PhlWin().url+"&locId="+newValue
            });
        }
        
    });
    PHA.ComboBox('conPhlWin',{
        editable:false, 
        url: PHAOP_STORE.PhlWin().url
    });
}
function InitGridWinLog(){
    var columns = [[{
                field: 'opwlRowid',
                title: 'ID',
                width: 100,
                hidden: true
            },
            {
                field: 'LocDesc',
                title: '药房',
                width: 100,
                hidden: true
            },
            {
                field: 'WinDesc',
                title: '窗口名称',
                width: 100
            },
            {
                field: 'UpdUser',
                title: '修改人',
                width: 100
            },
            {
                field: 'UpdDate',
                title: '修改日期',
                width: 100
            },
            {
                field: 'UpdTime',
                title: '修改时间',
                width: 100
            },
            {
                field: 'UpdState',
                title: '修改状态',
                width: 100
            }
        
    ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.WinLog.Query',
            QueryName: 'QueryOPWinLog',
            inputStr:  ''
        },
        pagination: true,
        columns: columns,
        fitColumns: true,
        toolbar: '#gridPhWinLogBar'
    };
    PHA.Grid('gridPhWinLog', dataGridOption);
}

function GetParams(){
    var StDate =  $("#conPhStDate").datebox("getValue")|| ""; 
    var EdDate = $("#conPhEndDate").datebox("getValue") || ""; 
    var StTime =  $("#conPhStTime").timespinner("getValue")|| ""; 
    var EdTime = $("#conPhEndTime").timespinner("getValue") || ""; 

    var phLoc =  $("#conPhLoc").combobox("getValue")|| ""; 
    var phlWIn = $("#conPhlWin").combobox("getValue") || ""; 
    var Params=StDate + "^" + EdDate + "^" + StTime + "^" + EdTime + "^" +phLoc  + "^" + phlWIn;
    return Params;

}
function QueryWinLog(){
    var inputStr=GetParams();
    $("#gridPhWinLog").datagrid("query",{inputStr:inputStr}); 
}

//清空
function CleanConditions() {
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $('#conPhStTime').timespinner('setValue', '00:00:00');
    $('#conPhEndTime').timespinner('setValue', '23:59:59');

    var datas = $("#conPhLoc").combobox("getData");
    for (var i = 0; i < datas.length; i++) {
        if (datas[i].RowId == session['LOGON.CTLOCID']) {
            $("#conPhLoc").combobox("setValue", datas[i].RowId);
            break;
        }
    }
    $("#conPhlWin").combobox("setValue", '');
    $('#gridPhWinLog').datagrid('clear');
     
}
/**
*   author:     zhaoxinlong 
*   creatDate:  2022-03-02
*   descrption: 发药前退费医嘱查询
*/

var hisPatNoLen;
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    GetPhaHisCommonParmas();
    InitDict();
    InitGrid();
    $("#btnFind").on("click", Query);
    $("#btnExport").on("click", Export);
    $("#btnClean").on("click", CleanConditions);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#conPatNo").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, hisPatNoLen);
                $(this).val(newpatno);
                if(newpatno==""){return;}
                Query();
            }
        }
    });
})
function InitDict(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    
}

function InitGrid(){
    var columns = [[{
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'prescNo',
                title: '处方号',
                width: 140
            },{
                field: 'recLocDesc',
                title: '接收科室',
                width: 150
            },{
                field: 'inciCode',
                title: '药品代码',
                width: 150
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 300
            },
            {
                field: 'qtyUom',
                title: '数量',
                width: 100
            },
            {
                field: 'oeFlag',
                title: '医嘱状态',
                width: 80
            },
            {
               field: 'priDesc',
                title: '优先级',
                width: 100
            },
            {
                field: 'doseQty',
                title: '剂量',
                width: 100
            },
            {
                field: 'instDesc',
                title: '用法',
                width: 100
            }
           
        
    ]];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Query.RefBeforeDisp',
            QueryName: 'Query',
            pJsonStr:  JSON.stringify({ locId: PHA_COM.Session.CTLOCID }),
            rows: 999
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        titleNoWrap:false,/*表头自动折行*/
        exportXls: false,
        rownumbers: true,
        toolbar: '#gridBar'
    };
    PHA.Grid('grid', dataGridOption);
}
function Query(){
    var startDate =  $("#conPhStDate").datebox("getValue")|| ""; 
    var endDate = $("#conPhEndDate").datebox("getValue") || ""; 
    var patNo=$("#conPatNo").val() || ""; 
    var pJson = {};
    pJson.locId = PHA_COM.Session.CTLOCID ; 
    pJson.startDate = startDate;    
    pJson.endDate = endDate;    
    pJson.patNo = patNo;    
    $("#grid").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  

}
function Export()
{
    if ($("#grid").datagrid("getData").rows.length == 0){
        PHA.Popover({
            msg: '没有数据,不能导出!',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    PHA_COM.ExportGrid("grid")
    //PHA_COM.PrintGrid("grid")
    }
function CleanConditions(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $("#conPatNo").val('')
    $('#grid').datagrid('clear');
}
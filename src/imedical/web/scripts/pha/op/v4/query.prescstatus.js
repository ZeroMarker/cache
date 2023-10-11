/*
*Creator    zhaozhiduan
*CreatDate  2021-01-27
*Descrption 门诊处方状态查询
*/

var hisPatNoLen;
$(function () {
    PHA_COM.SetPanel('#qcondPanel');
    GetPhaHisCommonParmas();
    InitDict();
    InitGridPrescStatus();
    $("#btnFind").on("click", QueryPrescStatus);
    $("#btnClean").on("click", CleanConditions);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#conPatNo").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, hisPatNoLen);
                $(this).val(newpatno);
                if(newpatno==""){return;}
                QueryPrescStatus();
            }
        }
    });
})
function InitDict(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    
}

function InitGridPrescStatus(){
    var columns = [[{
                field: 'admId',
                title: 'admId',
                width: 100,
                hidden: true
            },
            {
                field: 'recLocDesc',
                title: '接收科室',
                width: 100
            },
            {
                field: 'winDesc',
                title: '窗口',
                width: 100
            },
            {
                field: 'billFlag',
                title: '收费状态',
                width: 100
            },
            {
                field: 'prescAudited',
                title: '审核结果',
                width: 100
            },
            {
                field: 'pyFlag',
                title: '配药状态',
                width: 80
            },
            {
                field: 'fyFlag',
                title: '发药状态',
                width: 80
            },
            {
                field: 'repInfo',
                title: '配药需报到',
                width: 100
            },
            {
                field: 'baseMedLocDesc',
                title: '基数药科室',
                width: 100
            },
            {
                field: 'specialLocDesc',
                title: '留观科室',
                width: 100
            },
            {
                field: 'ipDispFlag',
                title: '发药方式',
                width: 100
            },
            {
                field: 'cesFlag',
                title: '应急恢复标志',
                width: 100
            },
            {
                field: 'inciCode',
                title: '药品代码',
                width: 150,
                hidden:true
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 200
            },
            {
                field: 'qtyUom',
                title: '数量',
                width: 80
            },
            {
                field: 'detailDispStatus',
                title: '明细发药状态',
                width: 60
            },
            {
                field: 'oeStatus',
                title: '医嘱状态',
                width: 80
            },
            {
                field: 'skinDesc',
                title: '皮试状态',
                width: 80
            },
            {
               field: 'priDesc',
                title: '医嘱类型',
                width: 100
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 80
            },
            {
                field: 'instDesc',
                title: '用法',
                width: 100
            },
            {
                field: 'stkQtyFlag',
                title: '库存情况',
                width: 100
            },
            {
                field: 'reqFlagDesc',
                title: '退费申请',
                width: 100
            },{
                field: 'ordItmId',
                title: '医嘱id',
                width: 100
            },{
                field: 'retQty',
                title: '退药数量',
                width: 100
            }
           
        
    ]];
   var frozenColumns=[[
            {
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
            }
        ]];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Query.PrescStatus',
            QueryName: 'QueryPrescStatus',
            pJsonStr:  JSON.stringify({ locId: PHA_COM.Session.CTLOCID }),
            rows: 999
        },
        pagination: true,
        columns: columns,
        frozenColumns:frozenColumns,
        fitColumns: false,
        titleNoWrap:false,/*表头自动折行*/
        exportXls: false,
        rownumbers: true,
        toolbar: '#gridPrescStatusBar'
    };
    PHA.Grid('gridPrescStatus', dataGridOption);
}
function QueryPrescStatus(){
    var startDate =  $("#conPhStDate").datebox("getValue")|| ""; 
    var endDate = $("#conPhEndDate").datebox("getValue") || ""; 
    var patNo=$("#conPatNo").val() || ""; 
    var prescNo=$("#conPrescNo").val() || "";
    var pJson = {};
    pJson.locId = PHA_COM.Session.CTLOCID ; 
    pJson.startDate = startDate;    
    pJson.endDate = endDate;    
    pJson.patNo = patNo;    
    pJson.prescNo = prescNo;    
    $("#gridPrescStatus").datagrid("query",{
        pJsonStr: JSON.stringify(pJson),
    });  

}
function CleanConditions(){
    $('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $("#conPatNo").val('')
    $("#conPrescNo").val('')
    $('#gridPrescStatus').datagrid('clear');
}
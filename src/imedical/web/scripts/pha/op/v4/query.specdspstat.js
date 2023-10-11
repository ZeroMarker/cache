/**
*	author:		zhaoxinlong 
*	creatDate:	2022-03-29
*	descrption:	门诊基数药已收费未发药统计
*/

$(function () {
	InitDict();
	InitGrid();
	$("#btnFind").on("click", Query);
	$("#btnExport").on("click", Export);
	$("#btnClean").on("click", CleanConditions);
})
function InitDict(){
	$('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    PHA.ComboBox("loc", {
		placeholder: '药房科室...',
		url: PHA_STORE.Pharmacy().url
	});
	PHA.ComboBox("ctpcp", {
		placeholder: '号别...',
		url: PHA_STORE.CTCareProv().url
	});
}

function InitGrid(){
	var columns = [[{
                field: 'inciDesc',
                title: '药品名称',
                width: 400
            },
            {
                field: 'spec',
                title: '规格',
                width: 160
            },
            {
                field: 'instDesc',
                title: '用法',
                width: 140
            },{
                field: 'sp',
                title: '单价',
                width: 150
            },{
                field: 'qty',
                title: '数量',
                width: 100
            },
            {
                field: 'buomDesc',
                title: '单位',
                width: 80
            },
            {
                field: 'spAmt',
                title: '总金额',
                width: 200
            }
           
        
    ]];

    var dataGridOption = {
	    url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.Query.SpecDspStat',
            QueryName: 'SpecDspStat',
            pJsonStr:  JSON.stringify({ docLocId: PHA_COM.Session.CTLOCID }),
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
    var ctpcpID=$("#ctpcp").combobox('getValue')|| ""; 
    var locId=$("#loc").combobox('getValue') || "";
    if (locId == ""){
        PHA.Popover({
            msg: '请先选择药房',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
	var pJson = {};
	pJson.startDate = startDate;	
	pJson.endDate = endDate;
	pJson.docLocId = PHA_COM.Session.CTLOCID ;	
	pJson.locId = locId ;	
	pJson.ctpcpID = ctpcpID;	
	$("#grid").datagrid("query",{
		pJsonStr: JSON.stringify(pJson),
	});  

}
function Export()
{
	//PHA_COM.ExportGrid("grid")
	PHA_COM.PrintGrid("grid")
	}
function CleanConditions(){
	$('#conPhStDate').datebox('setValue', 't');
    $('#conPhEndDate').datebox('setValue', 't');
    $("#ctpcp").combobox('setValue','')
    $("#loc").combobox('setValue','')
    $('#grid').datagrid('clear');
}
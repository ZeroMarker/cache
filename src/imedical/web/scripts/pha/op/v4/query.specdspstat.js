/**
*	author:		zhaoxinlong 
*	creatDate:	2022-03-29
*	descrption:	�������ҩ���շ�δ��ҩͳ��
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
		placeholder: 'ҩ������...',
		url: PHA_STORE.Pharmacy().url
	});
	PHA.ComboBox("ctpcp", {
		placeholder: '�ű�...',
		url: PHA_STORE.CTCareProv().url
	});
}

function InitGrid(){
	var columns = [[{
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 400
            },
            {
                field: 'spec',
                title: '���',
                width: 160
            },
            {
                field: 'instDesc',
                title: '�÷�',
                width: 140
            },{
                field: 'sp',
                title: '����',
                width: 150
            },{
                field: 'qty',
                title: '����',
                width: 100
            },
            {
                field: 'buomDesc',
                title: '��λ',
                width: 80
            },
            {
                field: 'spAmt',
                title: '�ܽ��',
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
        titleNoWrap:false,/*��ͷ�Զ�����*/
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
            msg: '����ѡ��ҩ��',
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
function InitTableAndEchart(columns,tableData,tableId,clickRowFun){
	$HUI.datagrid('#'+tableId,{
		url: '',
		data:tableData,
		fit:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		iconCls:'icon-paper',
		headerCls:'panel-header-gray',
		onClickRow:function(){
			if(typeof clickRowFun == "function"){
				clickRowFun();	
			}
		}
	})
}

var columns = [[
	{field: 'MedInst', align: 'center',width:100,title: 'ҽ�ƻ���'},
	{field: 'Number', align: 'center',width:50,title: '����'}
]]
var tableData=[
	{"MedInst":"Э��ҽԺ","InstArea":"������","Category":"��ҩ","DrugName":"��ù��","Number":"120"},
	{"MedInst":"����ʡ�پ�ҽԺ","InstArea":"��ɽ��","Category":"��ҩ","DrugName":"������","Number":"220"},
	{"MedInst":"����ʡ��ҽԺ","InstArea":"�����","Category":"��ҩ","DrugName":"��Ī����","Number":"320"},
	{"MedInst":"ʡ��ǻҽԺ","InstArea":"��ɽ��","Category":"��ҩ","DrugName":"��������","Number":"420"},
	{"MedInst":"�人��ѧ����ҽԺ","InstArea":"�����","Category":"��ҩ","DrugName":"ob","Number":"520"},
	{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"��ҩ","DrugName":"ob","Number":"620"},
	{"MedInst":"�人��Ƥ��������Ժ","InstArea":"�~����","Category":"��ҩ","DrugName":"ob","Number":"720"},
	{"MedInst":"��������ҽ���˿�ҽԺ","InstArea":"������","Category":"��ҩ","DrugName":"ob","Number":"820"}
]

var showIndex=0;
var tableData1=[
	{"LocName":"���ڿ�","Number":"120"},
	{"LocName":"�ڷ��ڿ�","Number":"120"},
	{"LocName":"���ٿ�","Number":"320"},
	{"LocName":"���","Number":"420"},
	{"LocName":"�س���","Number":"520"},
	{"LocName":"����","Number":"620"},
]

var tableData2=[
	{"LocName":"����","Number":"120"},
	{"LocName":"������","Number":"120"},
	{"LocName":"������","Number":"320"},
	{"LocName":"����","Number":"420"},
	{"LocName":"����","Number":"520"},
	{"LocName":"������","Number":"620"},
]

var patColumns = [[
	{field: 'PatName', align: 'center',width:100,title: '����'},
	{field: 'PatSex', align: 'center',width:50,title: '�Ա�'},
	{field: 'PatAge', align: 'center',width:50,title: '����'},
	{field: 'PatBob', align: 'center',width:50,title: '��������'},
	{field: 'PatPhone', align: 'center',width:50,title: '��ϵ��ʽ'},
	{field: 'Number', align: 'center',width:50,title: '����'},
	{field: 'Op', align: 'center',width:50,title: 'Op',formatter:formatOp},
]]
var patTableData=[
	{"PatName":"����","PatSex":"��","PatAge":"21��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"����","PatSex":"��","PatAge":"31��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"��־��","PatSex":"��","PatAge":"41��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"����ң","PatSex":"��","PatAge":"51��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"��ҫ��","PatSex":"��","PatAge":"21��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"��֮��","PatSex":"��","PatAge":"19��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"����ҫ","PatSex":"��","PatAge":"41��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"�ƴ���","PatSex":"Ů","PatAge":"21��","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
]

var callPatClickBak=function(){
	InitTableAndEchart(patColumns,patTableData,"patTable");
}

var callClickBak=function(){
	var columns = [[
		{field: 'LocName', align: 'center',width:100,title: '��������'},
		{field: 'Number', align: 'center',width:50,title: '����'}
	]]
	
	showIndex++;
	var tableData = showIndex%2?tableData1:tableData2;
	InitTableAndEchart(columns,tableData,"locTable",callPatClickBak);	
	InitTableAndEchart(patColumns,[],"patTable");
}

InitTableAndEchart(columns,tableData,"hospTable",callClickBak);

function formatOp(value, rowData, rowIndex){
	return "<a href='#' onclick='ShowChuFang(\""+rowData.PatName+"\")'>����</a>"	
}

function ShowChuFang(PatName){
	$('#ChuFangWin').window("open");		
}


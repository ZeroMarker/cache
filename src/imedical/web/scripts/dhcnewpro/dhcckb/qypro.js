function InitTableAndEchart(columns,tableData,tableId,clickRowFun){
	$HUI.datagrid('#'+tableId,{
		url: '',
		data:tableData,
		fit:true,
		columns:columns,
		fitColumns:true,
		pageSize:60,  
		pageList:[30,60,90], 
		loadMsg: '正在加载信息...',
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
	{field: 'MedInst', align: 'center',width:100,title: '医疗机构'},
	{field: 'Number', align: 'center',width:50,title: '数量'}
]]
var tableData=[
	{"MedInst":"协和医院","InstArea":"江汉区","Category":"西药","DrugName":"青霉素","Number":"120"},
	{"MedInst":"湖北省荣军医院","InstArea":"洪山区","Category":"西药","DrugName":"葡萄糖","Number":"220"},
	{"MedInst":"湖北省中医院","InstArea":"武昌区","Category":"西药","DrugName":"阿莫西林","Number":"320"},
	{"MedInst":"省口腔医院","InstArea":"洪山区","Category":"西药","DrugName":"青莲地心","Number":"420"},
	{"MedInst":"武汉大学人民医院","InstArea":"武昌区","Category":"西药","DrugName":"ob","Number":"520"},
	{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"西药","DrugName":"ob","Number":"620"},
	{"MedInst":"武汉市皮肤病防治院","InstArea":"硚口区","Category":"西药","DrugName":"ob","Number":"720"},
	{"MedInst":"新洲区中医骨伤科医院","InstArea":"新洲区","Category":"西药","DrugName":"ob","Number":"820"}
]

var showIndex=0;
var tableData1=[
	{"LocName":"心内科","Number":"120"},
	{"LocName":"内分泌科","Number":"120"},
	{"LocName":"乳腺科","Number":"320"},
	{"LocName":"外科","Number":"420"},
	{"LocName":"肛肠科","Number":"520"},
	{"LocName":"妇科","Number":"620"},
]

var tableData2=[
	{"LocName":"产科","Number":"120"},
	{"LocName":"消化科","Number":"120"},
	{"LocName":"呼吸科","Number":"320"},
	{"LocName":"牙科","Number":"420"},
	{"LocName":"妇科","Number":"520"},
	{"LocName":"康复科","Number":"620"},
]

var patColumns = [[
	{field: 'PatName', align: 'center',width:100,title: '姓名'},
	{field: 'PatSex', align: 'center',width:50,title: '性别'},
	{field: 'PatAge', align: 'center',width:50,title: '年龄'},
	{field: 'PatBob', align: 'center',width:50,title: '出生日期'},
	{field: 'PatPhone', align: 'center',width:50,title: '联系方式'},
	{field: 'Number', align: 'center',width:50,title: '数量'},
	{field: 'Op', align: 'center',width:50,title: 'Op',formatter:formatOp},
]]
var patTableData=[
	{"PatName":"张三","PatSex":"男","PatAge":"21岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"李四","PatSex":"男","PatAge":"31岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"王志忠","PatSex":"男","PatAge":"41岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"张逍遥","PatSex":"男","PatAge":"51岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"胡耀邦","PatSex":"男","PatAge":"21岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"华之国","PatSex":"男","PatAge":"19岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"刘大耀","PatSex":"男","PatAge":"41岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
	{"PatName":"黄大娜","PatSex":"女","PatAge":"21岁","PatBob":"1999-01-01","PatPhone":"13181819237","Number":"120"},
]

var callPatClickBak=function(){
	InitTableAndEchart(patColumns,patTableData,"patTable");
}

var callClickBak=function(){
	var columns = [[
		{field: 'LocName', align: 'center',width:100,title: '科室名称'},
		{field: 'Number', align: 'center',width:50,title: '数量'}
	]]
	
	showIndex++;
	var tableData = showIndex%2?tableData1:tableData2;
	InitTableAndEchart(columns,tableData,"locTable",callPatClickBak);	
	InitTableAndEchart(patColumns,[],"patTable");
}

InitTableAndEchart(columns,tableData,"hospTable",callClickBak);

function formatOp(value, rowData, rowIndex){
	return "<a href='#' onclick='ShowChuFang(\""+rowData.PatName+"\")'>处方</a>"	
}

function ShowChuFang(PatName){
	$('#ChuFangWin').window("open");		
}


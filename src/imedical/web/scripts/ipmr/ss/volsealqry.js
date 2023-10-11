/**
 * Sealqry 病案封存查询
 * 
 * CREATED BY likai 2023-02-15
 * 
 * 注解说明
 * TABLE: 
 */
//页面全局变量对象


var globalObj = {

}

$(function(){
	//初始化
	Init();
	
	//事件初始化
	InitEvent();

})

function Init(){
	var tdateFrom	= Common_GetDate("","FIRST");
	var tdateTo		= Common_GetDate("","LAST");	
	$('#aDateFrom').datebox('setValue', tdateFrom);		// 给日期框赋值
	$('#aDateTo').datebox('setValue', tdateTo);			// 给日期框赋值
	Common_ComboToHosp("cboHospital",'',Logon.HospID);
	Common_ComboToMrType("cboMrType",ServerObj.MrClass);
	Common_ComboToDic("cboDateType","SealDateType",1,'');					// 初始化日期类型
	$('#cboDateType').combobox('select',ServerObj.DateTypeId);				// 选择默认日期类型
	InitgridSealVol();
}

function InitEvent(){
	$('#btnQry').click(function(){
		QuerySealVol();
	});					

	// 导出
	$('#btnExportVol').click(function(){
		var data = $('#gridSealVol').datagrid('getData');
		if (data.rows.length==0)
		{
			messager.popover({msg: '请先查询再导出！',type: 'alert',timeout: 1000});
			return;
		}
		$('#gridSealVol').datagrid('Export', {
			filename: '封存查询',
			extension:'xls'
		});
	});		

}

/**
* NUMS: C001
* CTOR: likai
* DESC: 病案封存查询
* DATE: 2023-02-15
* NOTE: 包括方法：InitgridSealVol
* TABLE: 
*/
function InitgridSealVol(){
	var columns = [[
		{field:'PapmiNo',title:'登记号',width:80,align:'left'},
		{field:'MrNo',title:'病案号',width:80,align:'left'},
		{field:'PatName',title:'姓名',width:80,align:'left'},
		{field:'ClientName',title:'委托人',width:80,align:'left'},
		{field:'Relation',title:'与患者关系',width:80,align:'left'},
		{field:'IdentityCode',title:'委托人号码',width:120,align:'left'},
		{field:'Telephone',title:'委托人电话',width:100,align:'left'},
		{field:'ContentDescs',title:'封存内容',width:350,align:'left'},
		{field:'Purpose',title:'封存原因',width:100,align:'left'},
		{field:'Resume',title:'备注',width:100,align:'left'}
	]];
	
	var gridSealVol = $HUI.datagrid("#gridSealVol",{
		fit:true,
		//title:"封存明细",
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		pagination: true,		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true,		//如果为true, 则显示一个行号列
		singleSelect:true,
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		fitColumns:true,		//设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		striped:false,			//设置为 true，则把行条纹化。（即奇偶行使用不同背景色）  默认为false
		nowrap:false,
		url:$URL,
		queryParams:{
		    ClassName:"MA.IPMR.SSService.VolSealQry",
		    QueryName:"QrySealVol",
		    aHospital:'',
			aMrType:'',
			aDateType:'',
			aDateFrom:'',
			aDateTo:'',
			aIsUnSeal:'',
		    rows:10000
		},
		columns :columns,
		rowStyler:function(index,row){
		},
	});
}

/**
* NUMS: C002
* CTOR: likai
* DESC: 封存查询
* DATE: 2023-02-15
* NOTE: 包括方法：QuerySealVol
* TABLE: 
*/
function QuerySealVol(){
	var HospID		= $('#cboHospital').combobox('getValue');
	var MrTypeID	= $('#cboMrType').combobox('getValue');
	var DateFrom	= $('#aDateFrom').datebox('getValue');
	var DateTo		= $('#aDateTo').datebox('getValue');
	
	$('#gridSealVol').datagrid('reload',  {
		ClassName:"MA.IPMR.SSService.VolSealQry",
		QueryName:"QrySealVol",
		aHospital:HospID,
		aMrType:MrTypeID,
		aDateType:getDateTypeCode(),
		aDateFrom:DateFrom,
		aDateTo:DateTo,
		aIsUnSeal:$('#cboIsUnSeal').combobox('getValue'),
		rows:10000
	});
	$('#gridSealVol').datagrid('unselectAll');
}
function getDateTypeCode(){
	var DateTypeId = $("#cboDateType").combobox('getValue');
	if (DateTypeId=="") {
		$.messager.popover({msg:"请选择日期类型!"});
		return;
	}
	
	var DateTypeCode = '';
	var jsonData = $cm({
		ClassName:"CT.IPMR.BT.Dictionary",
		MethodName:"GetObjById",
		aId:DateTypeId
	},false);
	DateTypeCode = jsonData.BDCode;
	return DateTypeCode;
}
// Creator: congyue
// CreateDate: 2021-02-07
// Descript: 医嘱相关不良事件列表
var RepCode="",OrderID="",LgParam="";
$(function(){ 
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataGrid();		  /// 初始化页面datagrid
});
/// 初始化界面控件内容
function InitPageComponent(){
	//首页 报告管理联动
	RepCode=getParam("RepCode");
	OrderID=getParam("OrderID");
}

/// 初始化页面datagrid
function InitPageDataGrid()
{
	//定义columns
	var columns=[[
		{field:"RepID",title:'RepID',width:80,hidden:true},
		{field:"recordID",title:'recordID',width:80,hidden:true},
		{field:'RepDate',title:'报告日期',sortable:true},
		{field:'RepType',title:'报告类型',width:260,hidden:true},
		{field:'OccurDate',title:'发生日期',width:100,hidden:true},
		{field:'OccurLoc',title:'发生科室',width:130,hidden:true},
		{field:'RepLocDr',title:'RepLocDr',width:150,hidden:true},
		{field:'RepLoc',title:'报告科室',width:130,hidden:true},	
		{field:'RepUser',title:'报告人',width:100,hidden:true},	
		{field:'RepLevel',title:'不良事件级别',width:120,hidden:true},
		{field:'RepInjSev',title:'伤害严重度',width:120,hidden:true},
		{field:'AdmID',title:'就诊ID',width:80,hidden:true}
	]];
	//定义datagrid
	$('#maindg').datagrid({
		title:'', 
		method:'get',
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepListByOrder'+'&LgParam='+LgParam+'&RepCode='+RepCode+'&OrderID='+OrderID,
		fit:true,
		rownumbers:true,
		columns:columns,
		remoteSort:false,
	    singleSelect:false,
		loadMsg: '正在加载信息...',
		pagination:true,
		nowrap:true,
		onClickRow:function(rowIndex, rowData){
			$('#repfream').attr('src','dhcadv.layoutform.csp?recordId='+rowData.recordID+'&RepTypeDr='+rowData.RepTypeDr+'&code='+rowData.RepTypeCode+'&desc='+rowData.RepType+'&RepID='+rowData.RepID+'&editFlag=-1&AdmID='+rowData.AdmID);
    	},
		onLoadSuccess:function(data){
			$(".pagination").hide();
		}
	});
	
}



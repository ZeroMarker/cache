//===========================================================================================
// 作者：      shy
// 编写日期:   2022-3-29
// 描述:	   案例收藏分享
//===========================================================================================
var AuditId="" ;   //收藏审方主表ID
var collectId = "";
/// 页面初始化函数
function initPageDefault(){
	InitGetData();            /// 初始化入参信息 
	InitPageDataGrid();		  /// 初始化页面datagrid
	InitCombobox();           /// 初始化Combobox
	InitMethod();         	  /// 初始化方法

}
// 收藏分享
function Update()
{
	
	//数据准备
	var Theme=$("#theme").combobox('getValue') //主题
	var Level=$("#level").combobox('getValue') //级别
	var ShreGrp=$("#shregrp").combobox('getValue');  //分享组
	var ShareUit=$("#shareuit").combobox('getValue'); //分享单位
	var StartDate=$("#startDate").datebox('getValue');  //开始日期
	var EndDate=$("#endDate").datebox('getValue');    //结束日期
	var Params=Theme+"^"+Level+"^"+ShreGrp+"^"+ShareUit+"^"+StartDate+"^"+EndDate+"^"+LgUserID+"^"+LgHospID
	//增加条件过滤
	if(Theme=="")
	{
		$.messager.alert("提示","请选择主题！","warning")
		return ;	
	}
	if(Level=="")
	{
		$.messager.alert("提示","请选择级别！","warning")
		return ;	
	}
	if(ShreGrp=="")
	{
		$.messager.alert("提示","请选择分享组！","warning")
		return ;	
	}
	if(ShareUit=="")
	{
		$.messager.alert("提示","请选择分享单位！","warning")
		return ;	
	}
	if(StartDate=="")
	{
		$.messager.alert("提示","请选择开始日期！","warning")
		return ;	
	}
	if(EndDate=="")
	{
		$.messager.alert("提示","请选择结束日期！","warning")
		return ;	
	}
	//判断主题是否存在，如果不存在则保存该新增主题
	//保存案例收藏四个表
	var Result=""
	runClassMethod("web.DHCPrescCaseCollection","InsertCase",{"Params":Params,"AuditId":AuditId},function(getString){
		if (getString == 0){
			Result = "操作成功！";
		}else
		{
			Result = "操作失败！";	
		}
	},'text',false);
	$("#visgrid").datagrid('reload');
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	
	
	//关闭收藏分享窗口
	//websys_showModal("close")
}
// 收藏 lidong
function Collect()
{
	
	//数据准备
	var ShreGrp=$("#shregrp").combobox('getValue');  //分享组
	var ShareUit=$("#shareuit").combobox('getValue'); //分享单位
	var StartDate=$("#startDate").datebox('getValue');  //开始日期
	var EndDate=$("#endDate").datebox('getValue');    //结束日期
	var Theme=$HUI.combobox("#theme").getValue() //主题
	var Level=$("#level").combobox('getValue') //级别
	var Params=Theme+"^"+Level+"^"+LgUserID+"^"+LgHospID;		//增加条件过滤
	if(Theme=="")
	{
		$.messager.alert("提示","请选择主题！","warning")
		return ;	
	}
	if(Level=="")
	{
		$.messager.alert("提示","请选择级别！","warning")
		return ;	
	}
	/* if((ShreGrp!=="")||(ShareUit!=="")||(StartDate!=="")||(EndDate!==""))
	{
		$.messager.alert("提示","您已填写分享信息，请继续点击分享按钮","info")
			
	} */
	
	//判断主题是否存在，如果不存在则保存该新增主题
	//保存案例收藏四个表
	var Result=""
	runClassMethod("web.DHCPrescCaseCollection","CollectSave",{"Params":Params,"AuditId":AuditId},function(getString){
		if (getString > 0){
			collectId = getString;
			Result = "操作成功！";
			if((ShreGrp!=="")||(ShareUit!=="")||(StartDate!=="")||(EndDate!==""))
			{
				$.messager.alert("提示","收藏成功，请分享该收藏记录","info")
			
			} 
		}else
		{
			Result = "操作失败！";	
		}
	},'text',false);
	$("#visgrid").datagrid('reload');
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	
	
	//关闭收藏分享窗口
	//websys_showModal("close")
}
// 分享
function Share()
{
	//数据准备
	var Theme=$("#theme").combobox('getValue') //主题
	var Level=$("#level").combobox('getValue') //级别
	var ShreGrp=$("#shregrp").combobox('getValue');  //分享组
	var ShareUit=$("#shareuit").combobox('getValue'); //分享单位
	var StartDate=$("#startDate").datebox('getValue');  //开始日期
	var EndDate=$("#endDate").datebox('getValue');    //结束日期
	var Params=ShreGrp+"^"+ShareUit+"^"+StartDate+"^"+EndDate+"^"+LgUserID+"^"+collectId
	//增加条件过滤
	if(ShreGrp=="")
	{
		$.messager.alert("提示","请选择分享组！","warning")
		return ;	
	}
	if(ShareUit=="")
	{
		$.messager.alert("提示","请选择分享单位！","warning")
		return ;	
	}
	if(StartDate=="")
	{
		$.messager.alert("提示","请选择开始日期！","warning")
		return ;	
	}
	if(EndDate=="")
	{
		$.messager.alert("提示","请选择结束日期！","warning")
		return ;	
	}
	//判断主题是否存在，如果不存在则保存该新增主题
	//保存案例收藏四个表
	var Result=""
	runClassMethod("web.DHCPrescCaseCollection","ShareSave",{"Params":Params,"AuditId":AuditId},function(getString){
		if (getString == 0){
			Result = "操作成功！";
		}else if(getString == -7){
			Result = "请先收藏，再分享！";
		}else{
			Result = "操作失败！";	
		}
	},'text',false);
	$("#visgrid").datagrid('reload');
	$.messager.popover({msg: Result,type:'success',timeout: 2000});
	
	
	//关闭收藏分享窗口
	//websys_showModal("close")
}
// 初始化入参信息 
function InitGetData()
{
	AuditId=getParam("AuditId");		//审方主表ID
}
// 初始化方法
function InitMethod()
{
		
}
// 初始化Combobox
function InitCombobox()
{      
	/* // 案例收藏主题
	$HUI.combobox("#themes",{
		url: $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=GetThemeData",
		valueField: "id", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	// 案例收藏级别
	$HUI.combobox("#levels",{
		url: $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=GetLevelData",
		valueField: "id", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	// 案例分享分享组
	$('#shregrps').combobox( {
		data:[{"id":"D","text":"全院"},{"id":"L","text":"科室"},{"id":"G","text":"安全组"},{"id":"U","text":"人员"},{"id":"P","text":"职称"}],
	    valueField: 'id',
	    textField: 'text',
	    onSelect: function (option) {
	    $("#shareuits").combobox( { 
				url:'dhcapp.broker.csp?ClassName=web.DHCPrescCaseCollection&MethodName=GetScopeValueDate&type='+option.id
		})
	    }
	   
	})
// 初始化案例分享分享单位
$('#shareuits').combobox( {
    valueField: 'id',//绑定字段ID
    textField: 'text',//绑定字段Name
    onSelect: function (option) {
    }
   
}) */



// 案例收藏分享主题
	$HUI.combobox("#theme",{
		url: $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName=QueryDicItemCombox&code=COLLECT&hospId="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	
	// 案例收藏分享级别
	$HUI.combobox("#level",{
		url: $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName=QueryDicItemCombox&code=COLLECTLEV&hospId="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote',
		onSelect:function(ret){
			
		}
	})	
	// 案例收藏分享分享组
	$('#shregrp').combobox( {
		data:[{"id":"D","text":"全院"},{"id":"L","text":"科室"},{"id":"G","text":"安全组"},{"id":"U","text":"人员"},{"id":"P","text":"职称"}],
	    valueField: 'id',
	    textField: 'text',
	    mode:'remote',
	    onSelect: function (option) {
	    $("#shareuit").combobox( { 
				url:$URL+'?ClassName=web.DHCPrescCaseCollection&MethodName=GetScopeValueDate&type='+option.id
		})
	    }
	   
	})
// 初始化案例收藏分享分享单位
$('#shareuit').combobox( {
    valueField: 'id',//绑定字段ID
    textField: 'text',//绑定字段Name
    mode:'remote',
    onSelect: function (option) {
    }
   
})
}





/// 页面DataGrid初始定义已选列表
function InitPageDataGrid(){
	///  定义columns
	var columns=[[
		{field:'AttributeTValue',title:'主题',width:120,align:'center'},
		{field:'AttributeLValue',title:'级别',width:100,align:'center'},
		{field:'Type',title:'分享组',width:100,align:'center'},
		{field:'Pointer',title:'分享单位',width:200,align:'center'},
		{field:'StartDate',title:'开始日期',width:120,align:'center'},
		{field:'EndDate',title:'结束日期',width:120,align:'center'},
	]]
	
	/* var option={	
		columns:columns,
		bordr:false,	
		fitColumns:false,
		singleSelect:true,		
		striped: true, 
		pagination:true,
		rownumbers:true,
		loadMsg: '正在加载信息...',
		pageSize:50,
		pageList:[50,100,150],		
 		onClickRow:function(rowIndex,rowData){}, 
		onDblClickRow: function (rowIndex, rowData) {},
        onLoadSuccess:function(data){
	     }
	}  */
	var option = {
		//showHeader:false,
		fitColumn:true,
		toolbar:[],
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //数据加载完毕事件
	    	
        }
	};       
	
	var uniturl = $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=QueryCollectShare&AuditId="+ AuditId+"&LgUserID="+LgUserID;
	new ListComponent('visgrid', columns, uniturl, option).Init();
	///  定义datagrid
	/* var option = {
		//showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:true,
		fit:true,
	    onLoadSuccess:function (data) { //数据加载完毕事件
	    	
        }
	};
	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCPrescCaseCollection&MethodName=QueryCollectShare&AuditId="+ AuditId+"&LgUserID="+LgUserID;
	new ListComponent('visgrid', columns, uniturl, option).Init(); */
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })

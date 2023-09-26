var PageLogicObj = {
	arcosaliasList:"",
}
$(function(){
	//页面元素初始化
	PageHandle();
	//事件初始化
	InitEvent();
});
function PageHandle(){
	PageLogicObj.arcosaliasList=IntarcosaliasList()	
	LoadTable()
	$('#Save').bind('click',function(){Save()})
}
function InitEvent()
{
}
function BodyLoadHandler()
{
}
//新增别名
function Save()
{
	var Alias=$("#Alias").val()
	var Alias=Alias.replace(/(^\s*)|(\s*$)/g,'');
	if (Alias==""){
		$.messager.alert("提示","请填写有效的别名数据！")
		return;
	}
	var rtn = $cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"InsertArcosAlias",
		dataType:"text",
		ARCOSRowid:ServerObj.ARCOSRowid,
		Alias:Alias,
	},false);
	if (rtn!=0){
		$.messager.alert("提示","保存失败:"+rtn);
		return;
	}else{
		$.messager.popover({msg:"保存成功!",type:'success'});
	}
	LoadTable()
}
function deleteAlias()
{
	var rows=$('#arcosaliasList').datagrid("getRows");
	if (rows.length==1){
		$.messager.alert("提示","医嘱套别名不能全部删除!");
		return false;
	}
	var rtnobj=$('#arcosaliasList').datagrid("getSelections")
	var length=rtnobj.length
	if (length==0){$.messager.alert("提示","请先选择需要删除的别名信息!");return false}
	var AliasRowID=rtnobj[0].ALIASRowId
	var rtn = $cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"DeleteArcosAlias",
		dataType:"text",
		ALIASRowId:AliasRowID,
	},false);
	if (rtn!=0){
		$.messager.alert("提示","删除失败！"+rtn);
		return;
	}else{
		$.messager.popover({msg:"删除成功!",type:'success'});
	}
	LoadTable()
}

function LoadTable()
{
	$cm({
		ClassName:"web.DHCUserFavItems",
		QueryName:"FindAlias",
		ArcosID:ServerObj.ARCOSRowid,
	},function(GridData){
		PageLogicObj.arcosaliasList.datagrid('unselectAll').datagrid('loadData',GridData)
	});	
}
///初始化查询Table	
function IntarcosaliasList()
{
	var tabdatagrid=$('#arcosaliasList').datagrid({  
	//可用
	fit : true,
	border : false,
	striped : true,
	singleSelect : true,
	fitColumns : false,
	autoRowHeight : true,
	rownumbers:true,
	pagination : false,  
	rownumbers : true, 
	nowrap: false, //不换行
	pageSize: 20,
	pageList : [20,100,200],
	idField:"ALIASRowId",
	toolbar:[{
			iconCls:'icon-cancel',
			text:"删除别名",
			handler: function() {
				deleteAlias()
			}
	}],
	columns :[[ 
				{field:'ALiCode',title:"别名",width:350,align:'left'},
				{field:'ALIASRowId',title:"别名ID",width:35,align:'left',hidden:true},
				
			 ]]
   });
  return tabdatagrid
}
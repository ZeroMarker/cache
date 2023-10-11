//===========================================================================================
// Author：      qunianpeng
// Date:		 2020-04-16
// Description:	 复制属性
//===========================================================================================


var dicStr=""	// 字典id
var parref = "" // 实体id
/// JQuery 初始化页面
$(function(){ 
	
	initPageDefault(); 
})

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();			// 初始化参数
	InitButton();			// 按钮响应事件初始化
	InitAttrGrid();			// 初始化属性列表
	IniTtempAttrGrid();		// 已关联的属性
}

/// 初始化参数
function InitParams(){
	
	dicStr = getParam("dicStr");
	parref = getParam("parref");

}

/// 按钮响应事件初始化
function InitButton(){

	$("#addProp").bind("click",AddProp); 			//	添加属性
	$("#removeProp").bind("click",RemoveProp); 		//	移除属性 	
	
	//检索框
	$('#queryEnt').searchbox({
	    searcher:function(value,name){
	   		queryEnt();
	    }	   
	});	
	
	$('#queryDic').searchbox({
	    searcher:function(value,name){
	   		queryDic();
	    }	   
	});
		
}

/// 实体属性列表
function InitAttrGrid()
{
	///  定义columns
	var columns=[[ //ID^DLADicDr^DLAAttrCode^DLAAttrCodeDesc^DLAAttrDr^DLAAttrDesc^DLAResult
		{field:"ck",checkbox:"true"},
		{field:'ID',title:'ID',width:50,hidden:true},
		{field:'code',title:'代码',width:50,hidden:true},
		{field:'desc',title:'描述',width:650}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,		
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:false,
		selectOnCheck:true	    
	};
	
	var params=parref +"^"+ "LinkProp"
	var uniturl = $URL+"?ClassName=web.DHCCKBRangeCat&MethodName=QueryDicAttr&params="+params;
	new ListComponent('attrlist', columns, uniturl, option).Init();
}


/// 实体属性列表
function IniTtempAttrGrid()
{
	///  定义columns
	var columns=[[
		{field:'propID',title:'ID',width:50,hidden:true},
		{field:'propCode',title:'代码',width:50,hidden:true},
		{field:'propDesc',title:'描述',width:650}
	]];
	
	///  定义datagrid
	var option = {
		fitColumns:true,		
		nowrap: false,
		striped: true, 
		pagination:false,
		rownumbers:false,
		selectOnCheck:true	    
	};
	
	var params=dicStr;
	var uniturl = $URL+"?ClassName=web.DHCCKBDrugDetail&MethodName=QueryDicLinkProp&dicID="+params;
	new ListComponent('tempElement', columns, uniturl, option).Init();
}

// 保存属性
function AddProp(){
	
	var node = $("#attrlist").datagrid('getChecked');
    if (node.length==0){
        $.messager.alert("提示","请选择至少一个属性！")
        return;
    }
  	var listArr=[]
	
	$.each(node,function(index,item){
		listArr.push(item.ID)
	})
	var listData=listArr.join("^")

	//保存数据
	runClassMethod("web.DHCCKBDrugDetail","SaveDicLinkProp",{"dicStr":dicStr,"propList":listData},function(jsonString){
		if (jsonString == 0){
			 $.messager.alert("提示","保存失败！","error")
		}
		QueryDicLinkProp();
	},"text",false);
}



/// 属性移除
function RemoveProp(){

	var delPropList=$("#tempElement").datagrid('getSelections');

	if (delPropList.length==0){
		
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
	
	var propArr=[]
	$.each(delPropList,function(index,item){
		propArr.push(item.propID)
	})
	var propList = propArr.join("^");
	
	runClassMethod("web.DHCCKBDrugDetail","DelDicLinkProp",{"dicID":dicStr,"propList":propList},function(jsonString){					
		if (jsonString==1){
			QueryDicLinkProp();
		}
		else{
			 $.messager.alert('提示','删除失败.失败代码'+jsonString,'warning');
		}
		
	},"text",false);
	
	
}

/// 查询已经保存关联的属性
function QueryDicLinkProp(){

	var params=dicStr;
	$('#tempElement').datagrid('load',{'dicID':params}); //重新加载
}


/// 复制属性值
function CopyPropValue(){	
	
	var ret="";
	//保存数据
	console.log(dicStr)
	console.log(LoginInfo)
	console.log(ClientIPAdd)
	runClassMethod("web.DHCCKBDrugDetail","CopyPropValue",{"dicStr":dicStr,"userInfo":LoginInfo,"clientIP":ClientIPAdd},function(jsonString){
		
		ret = jsonString;
	},"text",false);

	return ret;

}

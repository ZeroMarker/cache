///===========================================================================================
/// Author：      qunianpeng
/// Date:		 2021-04-22
/// Description:	 分类关联药品tab
///===========================================================================================

var drugTypeArr = [{"value":"DrugData","text":"西药"},{"value":"ChineseDrugData","text":"中成药"},{"value":"ChineseHerbalMedicineData","text":"中药饮片"}]
var selDataID = "";	// 选择的字典id
var selCatID = "";	// 选择的分类id
var chkValue = "";	// 是否关联
var drugType = "";	// 药品大类
var datagridID = "";// tab中的datagirdID

/// 页面初始化函数
function initPageDefault(){
	
	initParams();		// 初始化参数
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitDataList();		// 页面DataGrid初始化定义
	InitTree();     	// 初始分类树
}

/// 初始化参数
function initParams(){
	
	selDataID =  getParam("selDataID");
	selCatID = getParam("selCatID");

}

/// 按钮响应事件初始化
function InitButton(){
	
	/* tab切换 */
	$HUI.tabs("#linkTab",{	
		onSelect:function(title){
			switchTab();						
		}		
	});
	
	datagridID = getDatagridId("");
	$HUI.radio("[name='FilterCK']",{	// 关联勾选 
        onChecked:function(e,value){	        
	        //$HUI.combotree("#"+datagridID).setValue("");
	        chkValue=this.value;
	        var tab = this.getAttribute("data-code");	        
	        findLinkList(tab);
	        cleanCombotree(tab);
        }
	});
	
	$('#drugDesc').searchbox({	// 药品检索
	    searcher:function(value,name){
		    findLinkList("drug");
		}	   
	});
	
	$('#genformDesc').searchbox({	// 待剂型通用名检索
	    searcher:function(value,name){
		    findLinkList("genform");
		}	   
	});
	
	$('#generDesc').searchbox({	// 通用名检索
	    searcher:function(value,name){
		    findLinkList("gener");
		}	   
	});
	
	$('#ingrDesc').searchbox({	// 成分检索
	    searcher:function(value,name){
		    findLinkList("ingr");
		}	   
	});

	$("#selmulitm").bind("click",selItmMulSelRow);	// 批量关联	
	
	$("#remomulitm").bind("click",revItmMulSelRow);	// 批量移除
	
	
}

/// 初始化combobox
function InitCombobox(){

	/*  药品大类 */
    $HUI.combobox("#drugType",{	 
		    valueField:'value',
			textField:'text',
			panelHeight:"150",
			mode:'remote',
			data:drugTypeArr,
			onSelect:function(opt){
				findLinkList("");
			}
	   })
}

/// 页面DataGrid初始化定义
function InitDataList(){
	
	/* 药品tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'操作',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'药品代码',width:100,align:'center'},
		{field:'Desc',title:'药品描述',width:150,align:'center'},
		{field:'CatDesc',title:'关联的分类',width:150,align:'center'}
	]];
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        }
	};	
	var params = selCatID;
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryCatLinkDrug&params="+params+"&drugType=";
	new ListComponent('drugTable', columns, uniturl, option).Init(); 
	
	/* 通用名(带剂型)tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'操作',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'通用名代码',width:100,align:'center'},
		{field:'Desc',title:'通用名描述',width:150,align:'center'},
		{field:'CatDesc',title:'关联的分类',width:150,align:'center'}
	]];
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        }
	};	
	var uniturl = ""
	new ListComponent('genformTable', columns, uniturl, option).Init(); 
	
	/* 通用名tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'操作',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'通用名代码',width:100,align:'center'},
		{field:'Desc',title:'通用名描述',width:150,align:'center'},
		{field:'CatDesc',title:'关联的分类',width:150,align:'center'}
	]];
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        }
	};	

	var uniturl = ""
	new ListComponent('generTable', columns, uniturl, option).Init(); 
	
	/* 成分tab-datagrid */
	var columns=[[
		{field:'ck',checkbox:'true'},
		{field:'Id',title:'Id',width:100,hidden:'true'},
		{field:'Operat',title:'操作',formatter:SetLinkOp,hidden:true},
		{field:'Code',title:'成分代码',width:100,align:'center'},
		{field:'Desc',title:'成分描述',width:150,align:'center'},
		{field:'CatDesc',title:'关联的分类',width:150,align:'center'}
	]];
	
	///  定义datagrid
	var option = {
		fit:true,
		fitColumns:true,
		singleSelect:false,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],	
	    onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
        }
	};
	
	var uniturl = "";
	new ListComponent('ingrTable', columns, uniturl, option).Init(); 
}

/// 初始分类树
function InitTree(){
	
	/* 药品tab-分类树 */
	$HUI.combotree("#drugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){			
			findLinkList("");
		}
	})
	
	/* 通用名(带剂型)tab-分类树 */
	$HUI.combotree("#genformdrugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){
			findLinkList("");
		}
	})
	
	/* 通用名tab-分类树 */
	$HUI.combotree("#generdrugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){			
			findLinkList("");
		}
	})
	
	/* 成分tab-分类树 */
	$HUI.combotree("#ingrdrugcat",{
		url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+selDataID,
		editable:true,
		onSelect:function(node){
			findLinkList("");
		}
	})
}

function SetLinkOp(value, rowData, rowIndex){
	
	if (rowData.Link == "0"){
		var html = "<a href='#' onclick='selItmSelRow("+rowIndex+")'>关联</a>";
	}else{
		var html = "<a href='#' onclick='revItmSelRow("+rowIndex+")'>移除</a>";
	}
    return html;
}

/// 查询关联的数据
function findLinkList(tab){
	
	var paramsArr = getParams(tab);
	var params = paramsArr[0];
	var drugType = paramsArr[1];
	$("#"+datagridID).datagrid('load',{"params":params,"drugType":drugType});
}


/// 关联
function selItmSelRow(rowIndex){

	var rowData=$("#"+datagridID).datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id||"";
	var DrugCatAttrId=rowData.DrugCatAttrId||"";	
	var ListData="" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ selCatID +"^"+ "";
	
	//runClassMethod("web.DHCCKBDicLinkAttr","InsText",{"ListData":ListData},
	runClassMethod("web.DHCCKBDicLinkAttr","InsMulPhacla",{"listData":ListData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},	
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});            	
           	}
           	$("#"+datagridID).datagrid('reload');
 	})
}

/// 移除
function revItmSelRow(rowIndex){
	
	var rowData=$("#"+datagridID).datagrid('getData').rows[rowIndex];
	var DrugId=rowData.Id||"";
	var DrugCatAttrId=rowData.DrugCatAttrId||"";
	var ListData=DrugId +"^"+ DrugCatAttrId +"^"+ selCatID;
	
	
	//runClassMethod("web.DHCCKBDiction","revRelation",{"ListData":ListData},	function(data){
	runClassMethod("web.DHCCKBDiction","revMulRelation",{"listData":ListData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},function(data){
    	if(data==0){
        	$.messager.popover({msg: '移除成功！',type:'success',timeout: 1000});
       	}
       	$("#"+datagridID).datagrid('reload');
	})
}

/// 批量关联
function selItmMulSelRow() {
	
	var radioObj = $("input[name='FilterCK']:checked");
	if (radioObj.val() == 1){
		$.messager.popover({
			msg: '选择的药品已经关联,不需要重复关联!',
			type: 'info',
			timeout: 2000, 		//0不自动关闭。3000s
			showSpeed: 'slow', //fast,slow,normal,1500
			showType: 'fade'  //show,fade,slide
		});	
		return;
	}
	
	var rowData = $("#"+datagridID).datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('提示',"请选择需要关联的数据!","info");
		return false;
	}
		
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		var DrugId = rowData[i].Id||"";
		var DrugCatAttrId = rowData[i].DrugCatAttrId||"";
		var tempList = "" +"^"+ DrugId +"^"+ DrugCatAttrId +"^"+ selCatID +"^"+ "";
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDicLinkAttr","InsMulPhacla",{"listData":listData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '关联成功！',type:'success',timeout: 1000});
            	
           	}
           $("#"+datagridID).datagrid('reload');
 	})
}

/// 批量移除
function revItmMulSelRow(){
	var rowData = $("#"+datagridID).datagrid('getSelections');
	if(rowData.length==0){
		$.messager.alert('提示',"请选择需要关联的药品!","info");
		return false;
	}
	var dataList = [];
	for(var i=0; i<rowData.length; i++){
		
		var DrugId = rowData[i].Id||"";
		var DrugCatAttrId = rowData[i].DrugCatAttrId||"";
		var tempList = DrugId +"^"+ DrugCatAttrId +"^"+ selCatID
		dataList.push(tempList);
	}
	var listData = dataList.join("&&");
	runClassMethod("web.DHCCKBDiction","revMulRelation",{"listData":listData,"loginInfo":LoginInfo, "ClientIP":ClientIPAdd},
    	function(data){
        	if(data==0){
            	$.messager.popover({msg: '移除成功！',type:'success',timeout: 1000});
            	
           	}
           	$("#"+datagridID).datagrid('reload');
 	})
}

/// tab切换事件
function switchTab(){
	
	var selTab = $('#linkTab').tabs('getSelected');
	var tab = selTab.panel('options').id; 
	datagridID = getDatagridId(tab);
	chkValue = "";
	$('input:radio[name=FilterCK]').each(function (i) {
		 	$(this).attr("checked","false");		 	   
	});  
	
	var paramsArr = getParams(tab);
	var params = paramsArr[0];
	var drugType = paramsArr[1];
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryCatLinkDrug&params="+params+"&drugType="+drugType;
	$('#'+datagridID).datagrid('options').url = uniturl;
	$('#'+datagridID).datagrid('reload');	
}

/// 获取查询的参数
function getParams(tabID){
	
	var paramsArr = []; 
	if (tabID == ""){
		tabID = "drug";
	}
	switch (tabID){
		 case "drug":	// 药品关联界面
			var drugDesc = $HUI.searchbox("#drugDesc").getValue();
			var subSelCatObj = $HUI.combotree("#drugcat").getValue();
			var subSelCatID = "";
			if (subSelCatObj){
				subSelCatID = subSelCatObj.id;
			}
			var drugType =$HUI.combobox("#drugType").getValue()||"";
			var params = selCatID +"^"+ drugDesc +"^"+ chkValue +"^"+ subSelCatID;	
			paramsArr.push(params);
			paramsArr.push(drugType);
			break;			
			
		 case "genform":	// 通用名带剂型关联界面
		 	var genformDesc = $HUI.searchbox("#genformDesc").getValue();
		 	var params = selCatID +"^"+ genformDesc +"^"+ chkValue +"^"+ "";
		 	var drugType = "GeneralFromData";
			paramsArr.push(params);
			paramsArr.push(drugType);			
			break;
			
		 case "gener":		// 通用名关联界面
			var generDesc = $HUI.searchbox("#generDesc").getValue();
		 	var params = selCatID +"^"+ generDesc +"^"+ chkValue +"^"+ "";
		 	var drugType = "GeneralData";
			paramsArr.push(params);
			paramsArr.push(drugType);			
		 	break;
		 case "ingr":		// 成分
			var ingrDesc = $HUI.searchbox("#ingrDesc").getValue();
		 	var params = selCatID +"^"+ ingrDesc +"^"+ chkValue +"^"+ "";
		 	var drugType = "ingredientData";
			paramsArr.push(params);
			paramsArr.push(drugType);	
		 	break;	
	}
	
	return paramsArr;
}

/// 获取tab中的数据列表id
function getDatagridId(tabID){
	var datagridID = "";
	switch (tabID){
		 case "drug":	// 药品关联界面	
		 	datagridID = "drugTable";	
			break;			
			
		 case "genform":	// 通用名带剂型关联界面
		 	datagridID = "genformTable";		
			break;
			
		 case "gener":		// 通用名关联界面
			datagridID = "generTable";			
		 	break;
		 	
		 case "ingr":		// 成分
			datagridID = "ingrTable";
		 	break;	
		 	
		 default:
		 	datagridID = "drugTable";
	}
	
	return datagridID;
}

/// 清除查询界面的分类
function cleanCombotree(tab){
	
	var combotreeId = "";
	switch (tab){
		 case "drug":	// 药品关联界面	
		 	combotreeId = "drugcat";	
			break;			
			
		 case "genform":	// 通用名带剂型关联界面
		 	combotreeId = "genformdrugcat";		
			break;
			
		 case "gener":		// 通用名关联界面
			combotreeId = "generdrugcat";			
		 	break;
		 	
		 case "ingr":		// 成分
			combotreeId = "ingrdrugcat";
		 	break;	
		 	
		 default:
		 	combotreeId = "drugcat";
	}
	
	$HUI.combotree("#"+combotreeId).setValue("");
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })

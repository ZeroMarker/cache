$(function(){
	initHospGroup();
	
	initPrivRuleType();
	loadPrivRuleType();
	
	initPrivStore();
	loadPrivStore();
	
	initPrivRule();
	
	$HUI.dialog('#dialog').close();	
	$HUI.dialog('#dialogstore').close();
	
	
})

//初始化医院名称
function initHospGroup(){
	$('#txtHospName').triggerbox('disable');
	$("#txtHospName").triggerbox('setValue', setting.hospDesc);
}

//加载权限类型
function initPrivRuleType()
{
	$HUI.combogrid('#cbxdgPrivType',{
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		singleSelect:true,
		panelWidth: 300,
		blurValidValue:true,
		idField: 'name',
        textField: 'description',
		autoSizeColumn:false,
		fitColumns:true,
		columns:[[
			{field:'id',title:'ID',width:30},
			{field:'name',title:'代码',width:80},
			{field:'description',title:'名称',width:90}
		]],
		onSelect:function(i,row){
			//权限加载
			setting.privRuleTypeId = row.id;
			setting.privRuleType = row.name;
			setting.privRuleTypeDesc = row.description;
			
			loadPrivRule();
			loadPrivStore();
			
			loadPrivRuleConfig();
		}
	})
	
}

function loadPrivRuleConfig()
{
	
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRuleConfig",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType
		},
		success : function(d) {
			$("#switchPrivRuleType").switchbox("setValue",d.data=="true"?true:false);
		},
		error : function(d) { 
			$.messager.popover({msg: "cbxPrivType:"+d ,type:'alert'});
		}
	});
	
	return;
	

}
function loadPrivRuleType()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRuleType"
		},
		success : function(d) {
	    	loadComboGridData("cbxdgPrivType",d);
		},
		error : function(d) { 
			$.messager.popover({msg: "cbxPrivType:"+d ,type:'alert'});
		}
	});
	return;
}

//初始化Store
function initPrivStore()
{
	$HUI.datagrid('#dgPrivStore',{
		idField:'storeid',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		singleSelect:false,
		width:470,
		title:'权限仓库',
		autoSizeColumn:false,
		fitColumns:true,
		fit:true,
		columns:[[
			{field:'ck',title:'ckbox',checkbox:true},
			{field:'storeid',title:'ID',width:160,hidden:true},
			{field:'storename',title:'描述',width:100,showTip:true,tipWidth:300},
			{field:'storecode',title:'权限脚本',width:100,showTip:true,tipWidth:300}
		]]
	})
	
}
function addPrivStoreToPrjPriv()
{
	var rows = $('#dgPrivStore').datagrid('getSelections');
	if (rows.length ==0)
	{
		$.messager.popover({msg: "添加前请完成勾选",type:'alert'});
	}
	else
	{
		rows.forEach(
			function(row,i,rows){
				
				row.ruletypeid= setting.privRuleTypeId
				row.ruletype= setting.privRuleType
				
				$("#dgPrivRule").datagrid('appendRow',row);
			}
		)
	}
}
function loadPrivStore()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRuleStore",
			"p1":setting.privRuleType,
			"p2":setting.hospGroupId
		},
		success : function(d) {
	    	loadDgData("dgPrivStore",d);
		},
		error : function(d) { 
			$.messager.popover({msg: "dgPrivStore"+d ,type:'alert'});
		}
	});
	return result;
}

//初始化脚本列表
function initPrivRule()
{
	$HUI.datagrid('#dgPrivRule',{
		idField:'id',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		rownumbers:true,
		singleSelect:true,
		title:'权限项目明细',
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		autoSizeColumn:false,
		fitColumns:true,
		onClickRow: onClickRow,
		//height:600px,
		fit:true,
		columns:[[
			{field:'ck',title:'ckbox',checkbox:true},
			{field:'changeflag',title:' ',align:'center', width:10},
			{field:'id',title:'代码',width:40},
			{field:'storename',title:'描述',width:160},
			{field:'storeid',title:'脚本库ID',width:200,showTip:true,tipWidth:450,hidden:true},
			{field:'storecode',title:'脚本库Code',width:40,hidden:true},
			{field:'isactive',title:'是否启用',width:80,
				editor:{
					type:'switchbox',
					options:{onClass:'primary',offClass:'gray',onText:'启用',offText:'停用'}
				}
			},
			{field:'ruletype',title:'规则类型',width:40},
			{field:'ruletypeid',title:'规则类型ID',width:40,hidden:true},
			{field:'sequece',title:'执行顺序',width:40,hidden:true},
			{field:'privruleid',title:'关联权限ID',width:40,hidden:true},
			{field:'storehaschanged',title:'仓库脚本变化',width:40,hidden:true},
			{field:'changedstorecode',title:'同步脚本内容',width:40,hidden:true},
			{field:'haschanged',title:'变更',width:20, hidden:true}
			
		]],
		rowStyler:function(index,row)
		{
			if (row.storehaschanged=="true")
			{
				return 'background-color:#6293BB;color:#fff;font-weight:bold;';
			}
			if (row.haschanged=="true")
			{
				return row.changeflag = "<span style='color:red'>*</span>";
			}
		}

	})
}
function loadPrivRule()
{
	var result = "";
	$.ajax({
		type: "GET",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"GetPrivRule",
			"p1":setting.hospId,
			"p2":setting.privRuleType
		},
		success : function(d) {
	    	loadDgData("dgPrivRule",d);
		},
		error : function(d) { 
			$.messager.popover({msg: "dgPrivRule:"+d ,type:'alert'});
		}
	});
	return result;
}
function loadDgData(id,data)
{
	$("#"+id).datagrid("loadData",data)

}

function loadComboGridData(id,data)
{
	$HUI.combogrid("#"+id).grid().datagrid("loadData",data)

}

 function upRow(rowindex){
	
   	var row = $('#dgPrivRule').datagrid('getSelected');
   	
   	if (row==null) 
	{
		$.messager.popover({msg: "请勾选要向上移动的权限条目" ,type:'alert'});
		return;
	};
   	
    var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row);
    
    if(rowindex === 0) 
    { 
    	$.messager.popover({msg: "已经移动至第一条" ,type:'alert'});
    	return;
    }
	
	$('#dgPrivRule').datagrid('insertRow',{index:rowindex-1,row:row});
	
	$('#dgPrivRule').datagrid('deleteRow',rowindex+1);
	
	$('#dgPrivRule').datagrid('selectRow',rowindex-1);
	
	$('#dgPrivRule').datagrid('getRows')[rowindex-1].haschanged = "true";
	$('#dgPrivRule').datagrid('refreshRow',rowindex-1)
	
	 
 }
 
function downRow(){
	 
	var row = $('#dgPrivRule').datagrid('getSelected');
	if (row==null) 
	{
		$.messager.popover({msg: "请勾选要向下移动的权限条目" ,type:'alert'});
		return;
	};
    var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row);        
	
	if(rowindex === $('#dgPrivRule').datagrid('getRows').length-1) 
	{ 
		$.messager.popover({msg: "已经移动至最后一条" ,type:'alert'});
		return;
	}
	
	$('#dgPrivRule').datagrid('insertRow',{index:rowindex+2,row:row});
	
	$('#dgPrivRule').datagrid('deleteRow',rowindex);
	
	$('#dgPrivRule').datagrid('selectRow',rowindex+1);
	
	$('#dgPrivRule').datagrid('getRows')[rowindex+1].haschanged = "true";
	$('#dgPrivRule').datagrid('refreshRow',rowindex+1)

}
function deletePrivRule(privRuleDetailID)
{
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"DeletePrivRule",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType,
			"p3":privRuleDetailID
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadPrivRule();
				$.messager.popover({msg: "删除权限条目成功!" ,type:'alert'});
				
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "deletePrivRule:"+d ,type:'alert'});
		}
	});
	
	return;	
}
function savePrivRule()
{

	endEditing();
	
	
	$('#dgPrivRule').datagrid('getRows').forEach(function(row,index)
	{
		if (row.changeflag != undefined)
		{
				row.changeflag = "";
		}
				
	})
						
	var privRuleDetailString=JSON.stringify($('#dgPrivRule').datagrid('getData'));
	
	//处理前后台交互时，因为delete字符被异常解析，p3参数值被清空，导致保存异常。用delte代替delete，后台还原为delete。
	privRuleDetailString = privRuleDetailString.split("delete").join("delte");

	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"SavePrivRule",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType,
			"p3":privRuleDetailString
		},
		success : function(d) {
			if (d.status=='suc')
			{
				loadPrivRule();
				$.messager.popover({msg: "脚本生成成功!" ,type:'alert'});
				
			}
			else
			{
				$.messager.popover({msg: d.message ,type:'alert'});
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "savePrivRule:"+d ,type:'alert'});
		}
	});
	
	return;
}

$("#btnSaveConfig").on("click",function(){
	
	saveConfig();
		
})


function saveConfig()
{
	var switchPrivRuleType = $("#switchPrivRuleType").switchbox("getValue");
	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"SavePrivRuleConfig",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType,
			"p3":switchPrivRuleType
		},
		success : function(d) {
			if (d.status=='suc')
			{
				$.messager.popover({msg: "权限配置保存成功!" ,type:'alert'});
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "权限配置保存失败："+d ,type:'alert'});
		}
	});	
}
function checkPrivRuleStore()
{
	var privRuleDetailString=JSON.stringify($('#dgPrivRule').datagrid('getData'));
	//处理前后台交互时，因为delete字符被异常解析，p3参数值被清空，导致保存异常。用delte代替delete，后台还原为delete。
	privRuleDetailString = privRuleDetailString.split("delete").join("delte");
	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"CheckPrivRuleStore",
			"p1":setting.hospGroupId,
			"p2":setting.privRuleType,
			"p3":privRuleDetailString
		},
		success : function(d) {
			if (d.status=='suc')
			{
				if (d.data=="")
				{
					$.messager.popover({msg: "权限脚本与脚本仓库编码一致!" ,type:'alert'});
				}
				else
				{
					
					d.data.forEach(function(item){
						/*$('#dgPrivRule').datagrid('getData').rows.forEach(function(row,index)
						{
							if (row.id == item.id)
							{
								$('#dgPrivRule').getRowIndex(index).storehaschanged = true;
							}
							
						})*/
						
						$('#dgPrivRule').datagrid('getRows').forEach(function(row,index)
						{
							if (row.id == item.id)
							{
								//$('#dgPrivRule').getRowIndex(index).storehaschanged = true;
								row.storehaschanged = "true";
								row.changedstorecode = item.storecode;
							}
							
						})
					
					})
					//重载包含样式数据
					$("#dgPrivRule").datagrid("loadData",$('#dgPrivRule').datagrid('getRows'))
					//更新同步代码
				}
				
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "权限脚本与脚本仓库验证失败："+d ,type:'alert'});
		}
	});	
		
}

function deletePrjPrivItem()
{
	var rows = $('#dgPrivRule').datagrid('getSelections');
	if (rows.length ==0)
	{
		$.messager.popover({msg: "请勾选要删除的权限项目",type:'alert'});
	}
	else
	{
		if (rows[0].id==undefined)
		{
			var row = $('#dgPrivRule').datagrid('getSelected');
			var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row);
			$('#dgPrivRule').datagrid('deleteRow',rowindex);
		}
		else
		{
			deletePrivRule(rows[0].id)
		}
	}
}

var editIndex=undefined;
var modifyBeforeRow = {};
var modifyAfterRow = {};

function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#dgPrivRule').datagrid('validateRow', editIndex)){
		var ed = $('#dgPrivRule').datagrid('getEditor', {index:editIndex,field:'isactive'});
		//var fieldText = $(ed.target).combobox('getText');
		//$('#dgPrivRule').datagrid('getRows')[editIndex]['changeflag'] = true;
		$('#dgPrivRule').datagrid('endEdit', editIndex);
		modifyAfterRow = $('#dgPrivRule').datagrid('getRows')[editIndex];
		if ( modifyAfterRow.isactive!=modifyBeforeRow.isactive)
		{
			$('#dgPrivRule').datagrid('getRows')[editIndex].haschanged = "true";
			$('#dgPrivRule').datagrid('refreshRow',editIndex)
		}
		
		
		editIndex = undefined;
		
		return true;
	} else {
		return false;
	}
}
function onClickRow(index){
	
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#dgPrivRule').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#dgPrivRule').datagrid('getRows')[editIndex]);
		} else {
			$('#dgPrivRule').datagrid('selectRow', editIndex);
		}
	}
}

function editPrivRuleDetail()
{
	var row = $('#dgPrivRule').datagrid('getSelected');
   	
   	if (row==null) 
	{
		$.messager.popover({msg: "请勾选要编辑的权限条目" ,type:'alert'});
		return;
	};
	$("#labelPrivRuleDesc").text(row.storename)
	$("#labelStoreRuleCode").text(row.storecode)
	$("#txtPrivRuleCode").val(row.storecode)


	var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row);
	
	setting.selrowindex = rowindex
	setting.selrow = row
	
	$HUI.dialog('#dialog').open();	

}

function updatedgPrivRule()
{
	$('#dgPrivRule').datagrid('updateRow',{index:setting.selrowindex,row:setting.selrow});
	
}

////新增权限仓库数据维护前端页面
function addPrivStoreItem()
{
	$HUI.dialog('#dialogstore').open();	
}
function editPrivStoreItem()
{
	var row = $('#dgPrivStore').datagrid('getSelections');

   	if (row==null) 
	{
		$.messager.popover({msg: "请勾选要编辑的权限仓库条目" ,type:'alert'});
		return;
	};
	
	if (row.length>1) 
	{
		$.messager.popover({msg: "请仅勾一条要编辑的权限仓库条目" ,type:'alert'});
		return;
	};
	
	$("#txtPrivStoreDesc").val(row[0].storename)
	$("#txtPrivStoreCode").val(row[0].storecode)
	
	var rowindex = $('#dgPrivRule').datagrid('getRowIndex',row[0]);
	
	setting.storeselrowindex = rowindex
	setting.storeselrow = row[0]
	
	$HUI.dialog('#dialogstore').open();	

}
///校验维护的仓库数据
function checkPrivStoreItem()
{
	var result=false;
	var checkStoreItemCode=$("#txtPrivStoreCode").val();
	
	//处理前后台交互时，因为delete字符被异常解析，p3参数值被清空，导致保存异常。用delte代替delete，后台还原为delete。
	checkStoreItemCode = checkStoreItemCode.split("delete").join("delte");
	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"CheckPrivStoreItem",
			"p1":checkStoreItemCode,
		},
		success : function(d) {
			if (d.status=='suc')
			{
				$.messager.popover({msg: "校验通过",type:'alert'});
				result=true;
			}
			else
			{
				$.messager.popover({msg: d.message,type:'alert'});
				result=false;
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "校验服务异常："+d ,type:'alert'});
		}
	});	
	return result;
}
///保存仓库数据
function savePrivStoreItem()
{
	var isPass = checkPrivStoreItem();
	if (isPass==false)
	{
		return 
	}
	
	var newStoreItemId=setting.storeselrow==undefined?"":setting.storeselrow.storeid
	var newStoreItemCode=$("#txtPrivStoreCode").val();
	var newStoreItemDesc=$("#txtPrivStoreDesc").val();
	
	//处理前后台交互时，因为delete字符被异常解析，p3参数值被清空，导致保存异常。用delte代替delete，后台还原为delete。
	newStoreItemCode = newStoreItemCode.split("delete").join("delte");
	
	$.ajax({
		type: "POST",
		dataType : "json",
		url: "../EMRservice.Ajax.common.cls", 
		async : false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLPrivRuleView",
			"Method":"SavePrivStoreItem",
			"p1":newStoreItemDesc,
			"p2":newStoreItemCode,
			"p3":newStoreItemId
		},
		success : function(d) {
			if (d.status=='suc')
			{
				$.messager.popover({msg: "保存仓库数据成功",type:'alert'});
			}
		},
		error : function(d) { 
			$.messager.popover({msg: "保存仓库数据失败："+d ,type:'alert'});
		}
	});
	
	
	//重新加载仓库数据
	loadPrivStore();
	initDialogStore();
								
}

function initDialogStore()
{
	setting.storeselrow={};
	setting.storeselrowindex = "";
	$("#txtPrivStoreCode").val("");
	$("#txtPrivStoreDesc").val("");
	
}
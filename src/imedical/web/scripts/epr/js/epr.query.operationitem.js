var dataStr = '';
var cataId = '';
var rowIndexs = '';
var editIndex=undefined;
var editIndex=undefined;

var modifyBeforeRow = {};
var modifyAfterRow = {};
var arr = [];
var per = [];
$(function(){
	$("#filechoose").filebox({
		width:300,
		buttonText:emrTrans("浏览文件"),
		onChange:function(){
			xlsxUpload();
			}
		});
	$('#cbtreeCategory1').tree({
	url: '../web.eprajax.query.basicsetting.cls?Action=getCategoryTree&node=RT0&frameType=HISUI&flag=1',
	
	loadFilter: function(data){
		if (data.d){
			return data.d;
		} else {
			
			return data
		}
    },
	onSelect:function(node){
		categoryItemId = node.id;
		setCategoryItems(node.id);
	},
	onContextMenu: function(e, node){
		var aa =$('#cbtreeCategory1').tree('select', node.target);
		treeRightClick(e,node);
	},
		lines:true,autoNodeHeight:true
	})
	//可能还需要监听事件
	$('#cbtreeCategory1').on('click','.icon-write-order',function(){
	var id=$(this).data('id');
	var node=$('#sptt').tree('find',id);
	});

	$("#selectTypeCode").combobox({
		valueField:'id', 
		textField:'text', 
		panelHeight:"auto",
		data:typeCodeData
	});
	$("#selectStd").combobox({
		valueField:'Code', 
		textField:'Description', 
		panelHeight:'270',
		data:StdData
	});
	$("#QueryCategoryIsActive").combobox({
		valueField:'id', 
		textField:'text', 
		panelHeight:"auto",
		data:getQItemIsActive()
	});
	$("#selectIsActive").combobox({
		valueField:'id', 
		textField:'text', 
		panelHeight:"auto",
		data:getQItemIsActive()
	});
	//导入按钮
	$("#ImportData").click(function(){
		SetImportItem(importData,categoryItemId)	
	});


	$('#showItems').datagrid({
		pageSize: 20,
		toolbar: [{
		iconCls: 'icon-add',
		text:'添加',
		handler: function(){

				if (categoryItemId =="")
				{ 
					$.messager.alert("提示","请先选择检索类别");
				}
				else
				{
					if(categoryItemId == "CG1")
					{
						$.messager.alert("提示","添加此类查询条件需联系技术支持或开发人员！");
					}
					else
					{
						var key = 'categoryId';
						var value = categoryItemId;
						per[key]= value;
						$(":input").val('');
						$('#QueryItem').dialog({closed: false});
					}	
				} 
			}	
		}
		,{
		iconCls: 'icon-edit',
		text:'编辑',
		handler: function()
		{
			if(categoryItemId == "CG1")
			{
				$.messager.alert("提示","编辑此类查询条件需联系技术支持或开发人员！");
			}
			else
			{
				var jqobj = $('#showItems');
				var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
				$('#showItems').datagrid('beginEdit',curInd);
			}
		}
		},{
		iconCls: 'icon-save',
		text:'保存',
		handler: function()
		{
			var jqobj = $('#showItems');
			var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
			$('#showItems').datagrid('endEdit',curInd);
			var rowData = $('#showItems').datagrid('getSelected',curInd);
			getItemValue(rowData);
		}	
		}]
	});


	$('#QuertCatory').dialog({
			toolbar: [{
			iconCls: 'icon-undo',
			text:'取消',
			handler: function(){
				$('#QuertCatory').dialog({closed: false});
			}
		},{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				setQueryCategorg("addParentQueryCategory");
			}		
		}]
	});
	$('#QueryItem').dialog({
			toolbar: [{
			iconCls: 'icon-undo',
			text:'取消',
			handler: function(){
				$('#QueryItem').dialog({closed: false});
			}
		},{
			iconCls: 'icon-save',
			text:'保存',
			handler: function(){
				setQueryItem();
			}		
		}]
	});


	//修改节点
	document.getElementById("editQueryCategory").onclick = function(){
		arr = $('#cbtreeCategory1').tree('getSelected').attributes;
		var key = 'action';
		var value = 'editQueryCategory';
		arr[key]= value;	
		$('#QuertCatory').dialog({closed: false});
			getQueryCategorg(arr);
		}
	//添加同级检索节点
	document.getElementById("addParentQueryCategory").onclick = function(){
		arr = $('#cbtreeCategory1').tree('getSelected').attributes;
		var key = 'action';
		var value = 'addParentQueryCategory';
		arr[key]= value;
		$(":input").val('');
		$('#QuertCatory').dialog({closed: false});

	}
	//添加子节点
	document.getElementById("addChildQueryCategory").onclick = function(){
		arr = $('#cbtreeCategory1').tree('getSelected').attributes;
		var key = 'action';
		var value = 'addChildQueryCategory';
		arr[key]= value;
		$(":input").val('');
		$('#QuertCatory').dialog({closed: false});
	}
	

},0);﻿
///获取数据
function setCategoryItems(categoryId)
{
	$('#showItems').datagrid('load', {
		Action: 'getOperateCategoryItems',
		CategoryID: categoryId
	});
}




function closeWindow()
{

	window.close();	
}

var xlsxData;//读取完成的数据
var rABS = true; //是否将文件读取为二进制字符串
/**
* 表格文件文件上传
* @param obj
*/
function xlsxUpload(obj) {
	var files = $("#filechoose").filebox("files");
		if(!files) {
			return;
	}
	var file = files[0];
	var reader = new FileReader();
	reader.onload = function(e) {
		var data = e.target.result;
		if(rABS) {
			xlsxData = XLSX.read(btoa(fixData(data)), {//手动转化
			type: 'base64'
		});
		} else {
			xlsxData = XLSX.read(data, {
			type: 'binary'
		});
	}
// xlsxData.SheetNames[0]是获取Sheets中第一个Sheet的名字
// xlsxData.Sheets[Sheet名]获取第一个Sheet的数据
var obj = XLSX.utils.sheet_to_json(xlsxData.Sheets[xlsxData.SheetNames[0]]);// 拿到表格对象。默认表格第一行是字段，从第二行开始是数据
//document.getElementById("demo").innerHTML= JSON.stringify( obj );// 输出
	importData = obj
};
	if(rABS) {
		reader.readAsArrayBuffer(file);
	} else {
		reader.readAsBinaryString(file);
	}
}

/**
* 文件流转BinaryString
* @param data
* @returns {string}
*/
function fixData(data) {
var o = "";
var l = 0;
var w = 10240;
	for(; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	return o;
}



function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#showItems').datagrid('validateRow', editIndex)){
	//debugger
	//列表中下拉框实现，修改后把回写feetypename，因为formatter显示的是feetypename字段
	//var ed = $('#showItems').datagrid('getEditor', {index:editIndex,field:'feetypeid'});
	//var feetypename = $(ed.target).combobox('getText');
	//$('#showItems').datagrid('getRows')[editIndex]['feetypename'] = feetypename;
	$('#showItems').datagrid('endEdit', editIndex);
	modifyAfterRow = $('#showItems').datagrid('getRows')[editIndex];
	var aStr = JSON.stringify(modifyAfterRow);
	var bStr = JSON.stringify(modifyBeforeRow);
	if(aStr!=bStr){
		console.log('修改前：');
		console.dir(modifyBeforeRow);
		console.log('修改后：');
		console.dir(modifyAfterRow);
	}
	editIndex = undefined;
	return true;
	} else {
	return false;
	}
}

function onClickRow(index){
	if (editIndex!=index) {
		if (endEditing()){
			$('#showItems').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#showItems').datagrid('getRows')[editIndex]);
	} else {
			$('#showItems').datagrid('selectRow', editIndex);
	}
	}
}

function treeRightClick(e,node)
{
	if(node.id =="CG1")
	{
		$('#mm').menu('disableItem',$("#addParentQueryCategory")[0]);
		$('#mm').menu('disableItem',$("#addChildQueryCategory")[0]);
		$('#mm').menu('disableItem',$("#editQueryCategory")[0]);
		e.preventDefault();
		$('#cbtreeCategory1').tree('select', node.target);
		$('#mm').menu('show', {left: e.pageX, top: e.pageY});
	}else
	{
		$('#mm').menu('enableItem',$("#addParentQueryCategory")[0]);
		$('#mm').menu('enableItem',$("#addChildQueryCategory")[0]);
		$('#mm').menu('enableItem',$("#editQueryCategory")[0]);
		e.preventDefault();
		$('#cbtreeCategory1').tree('select', node.target);
		$('#mm').menu('show', {left: e.pageX, top: e.pageY});
	}
}

//表格选中的数据添加到div中
function getQueryCategorg(arr)
{
	var obj = arr
	var thisValueId = obj.RowID;	
	var thisValueName = obj.text;
	var thisValueSequence = obj.Sequence;
	var thisValueParentId = obj.ParentID;	
	var thisValueIsActive = obj.IsActive;
	var thisValueRemark = obj.Remark;
	var thisValueCode = obj.Itemcode;	

	$("#QueryCategoryId").val(thisValueId);
	$("#QueryCategoryCode").val(thisValueCode);
	$("#QueryCategoryName").val(thisValueName);
	$("#QueryCategoryParentId").val(thisValueParentId);
	$("#QueryCategoryRemark").val(thisValueRemark);
	$("#QueryCategorySequence").val(thisValueSequence);
	
	$("#QueryCategoryIsActive").combobox('setValue', thisValueIsActive);
	$("#QueryCategoryIsActive").combobox('getValue');
	

}
///修改和添加queryCategoty数据
function setQueryCategorg()
{
	var id = '';
	if(arr.action =="editQueryCategory")
{
	var id = document.getElementById('QueryCategoryId').value;
}
	var code = document.getElementById('QueryCategoryCode').value;  
	var name = document.getElementById('QueryCategoryName').value;
	var parentid = document.getElementById('QueryCategoryParentId').value; 
	if(arr.action =="addParentQueryCategory")
	{
		parentid =  arr.ParentID;

	}
	else if(arr.action =="addChildQueryCategory")
	{
		parentid = arr.RowID;
	}
	var remark = document.getElementById('QueryCategoryRemark').value;
	var sequence = document.getElementById('QueryCategorySequence').value;
	var IsActive = $("#QueryCategoryIsActive").combobox('getValue');
	
	var ret = id +"^"+ code +"^"+ name +"^"+ parentid +"^"+ remark +"^"+ sequence +"^"+ IsActive + "/"; 
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
		"OutputType":"String",
		"Class":"web.eprajax.query.basicoperation",
		"Method":"SetobjQueryCategoryData",
		"p1":ret,
		"p2":"",
		},
	success : function(d) {
		if ( d == 1) 
		{
			$.messager.alert("提示","成功");
			arr = [];
			$('#cbtreeCategory1').tree('reload');
		}
		else
		{
			$.messager.alert("提示","数据重复或有问题，请检查");
		}
	},
	error: function(d){alert("error");}
});  
	 $('#QuertCatory').dialog({closed: true}); 
}

////保存修改的QueryItem数据
function getItemValue(rowData)
{
	var obj = rowData
	var id = obj.ID;	
	var title = obj.Title;
	var code = obj.ItemCode;
	var CategoryId = obj.CategoryID;	
	var name = obj.Name;
	var Sequence = obj.Sequence;
	var IsActive = obj.ItemIsActive;	
	var StdDicDesc = obj.stdDicDesc;
	var QueryItemTypeID = obj.TypeCode;
	var Remark = obj.Remark;
	var ParentID=0;
	if(typeof(QueryItemTypeID)=='string')
	{
		for(var i=0;i<typeCodeData.length;i++)
		{
			if(typeCodeData[i].text == QueryItemTypeID)
			{
				QueryItemTypeID = typeCodeData[i].id
			}
		}
	}
	if(typeof(StdDicDesc)=='string')
	{
		for(var i=0;i<StdData.length;i++)
		{
			if(StdData[i].Description == StdDicDesc)
			{
				StdDicDesc = StdData[i].Code;
			}
		}
	}
	/* if(IsActive == "启用")
	{
			IsActive = "Y"
	}
	else
	{
		IsActive = "N"
	} */
	var ret = CategoryId +"^"+ code +"^"+ IsActive +"^"+ name +"^"+ ParentID +"^"+ QueryItemTypeID +"^"+ Remark +"^"+ Sequence +"^"+ StdDicDesc +"^"+ title +"^"+ id +  "/";
	alert(ret);
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
	data: {
		"OutputType":"String",
		"Class":"web.eprajax.query.basicoperation",
		"Method":"SetQueryItemData",
		"p1":ret,
		"p2":"",
	},
	success : function(d) {
		if ( d == 1) 
		{
			$.messager.alert("提示","成功");
			$('#showItems').datagrid('reload');
		}
		else
		{
			$.messager.alert("提示","数据重复或有问题，请检查");
			$('#showItems').datagrid('reload');
		}
	},
	error: function(d){alert("error");}
	});
	
	$('#QueryItem').dialog({closed: true});
}
///添加queryItem数据
function setQueryItem()
{
	if(per.categoryId != '')
	{
	var id = document.getElementById('selectRowId').value;
	var title = document.getElementById('selectTitle').value;  
	var code = document.getElementById('selectCode').value;

	var CategoryId = per.categoryId.replace(/[^0-9]/ig,"");
	var name = document.getElementById('selectName').value; 
	var Sequence = document.getElementById('selectSequence').value;
	var IsActive = $("#selectIsActive").combobox('getValue');
	
	var StdDic = $('#selectStd').combobox('getValue');
	var Remark = document.getElementById('selectRemark').value;
	var QueryItemTypeID = $('#selectTypeCode').combobox('getValue');
	var  selText= $('#selectTypeCode').combobox('getText');
	if(QueryItemTypeID == selText)
	{
		for(var i=0;i<typeCodeData.length;i++)
		{
			if(typeCodeData[i].text == selText)
			{
				QueryItemTypeID = typeCodeData[i].id
			}
		}
	}

	var ParentID=0
	var ret = CategoryId +"^"+ code +"^"+ IsActive +"^"+ name +"^"+ ParentID +"^"+ QueryItemTypeID +"^"+ Remark +"^"+ Sequence +"^"+ StdDic +"^"+ title +"^"+ id +  "/";
			jQuery.ajax({
				type: "Post",
				dataType: "text",
				url: "../EMRservice.Ajax.common.cls",
				async: false,
				data: {
					"OutputType":"String",
					"Class":"web.eprajax.query.basicoperation",
					"Method":"SetQueryItemData",
					"p1":ret,
					"p2":"",
			},
			success : function(d) {
				if ( d == 1) 
				{
					$.messager.alert("提示","成功");

					$('#QuertItem').dialog({closed: true});
					$('#showItems').datagrid('reload');	 
				}
				else
				{
					$.messager.alert("提示","数据重复或有问题，请检查");
					$('#showItems').datagrid('reload');
				}
			},
			error: function(d){alert("error");}
		});  
	}
	else
	{
		$.messager.alert("提示","请先选择检索类别");
	} 
		$('#showItems').datagrid('reload');	
}
///添加导入数据
function SetImportItem(checkedItems,categoryItemId)
{

	if((categoryItemId == "")||(categoryItemId==undefined))
	{
	$.messager.alert("提示","请先选择检索类别");

	}else
	{
	var categoryId = categoryItemId.replace(/[^0-9]/ig,"");
	var ret = "";
	for (var i=0;i<checkedItems.length;i++)
	{
	ret = ret + categoryId+"^"+checkedItems[i].DataCode+"^"+checkedItems[i].IsActive+"^"+checkedItems[i].Name+"^"+checkedItems[i].ParentID+"^"+checkedItems[i].QueryItemTypeID+"^"+checkedItems[i].Remark+"^"+checkedItems[i].Sequence+"^"+checkedItems[i].StdDic+"^"+checkedItems[i].Title+"^"+ "/"
	}
	jQuery.ajax({
	type: "Post",
	dataType: "text",
	url: "../EMRservice.Ajax.common.cls",
	async: false,
	data: {
	"OutputType":"String",
	"Class":"web.eprajax.query.basicoperation",
	"Method":"SetQueryItemData",
	"p1":ret,
	"p2":""
	}, 

	success: function(d)
	{
		if ( d == 1) 
		{
			$('#showItems').datagrid('reload');
			$.messager.alert("提示","导入成功");

		}
	},
	error: function(d){alert("error");} 

	});     	  	
}

}
function getQItemIsActive()
{
	var data = 
	[
		{"id":"Y","text":"启用"},
		{"id":"N","text":"禁用"}
	]
	return data;	
}

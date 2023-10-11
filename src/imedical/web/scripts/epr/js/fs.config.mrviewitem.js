var FSConfigViewItem = new Object();
FSConfigViewItem.AjaxUrl = '../DHCEPRFS.web.eprajax.AjaxConfigMRViewItem.cls';
FSConfigViewItem.SelectMRItems = '#';
(function($) {
	$(function() {
		
		$('#mrViewCategoryTable').datagrid({
			title: '浏览父类',
			fit: true,
			toolbar:'#mrViewCategoryTB',
			url: FSConfigViewItem.AjaxUrl,
			queryParams: {
				Action: 'mrViewCategorylist',	
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: true,
			rownumbers: true,
			pagination: false,
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{ field: 'ID', title: 'ID', width: 80, hidden: true },
				{ field: 'Code', title: 'Code', width: 80 ,editor:{type:'text'}},
				{ field: 'Name', title: '名称', width: 100,editor:{type:'text'} },
				{ field: 'Desc', title: '描述', width: 180,editor:{type:'text'} },
				{ field: 'Sequence', title: '排序号', width: 50,editor:{type:'numberbox'}}
				]],
			onClickRow: function(rowIndex,rowData) {
				$('#mrViewSubCategoryTable').datagrid('options').url = FSConfigViewItem.AjaxUrl;
				var queryParams = $('#mrViewSubCategoryTable').datagrid('options').queryParams;
				queryParams.ParentCode = rowData.Code;
				$('#mrViewSubCategoryTable').datagrid('options').queryParams = queryParams;
				$('#mrViewSubCategoryTable').datagrid('reload');
				
			}
			
		});	
		
		$('#mrViewSubCategoryTable').datagrid({
			title: '浏览子类',
			fit: true,
			toolbar:'#mrViewSubCategoryTB',
			queryParams: {
				Action: 'mrViewSubCategorylist',
				ParentCode: ''	
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: true,
			rownumbers: true,
			pagination: false,
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{ field: 'ID', title: 'ID', width: 80, hidden: true },
				{ field: 'ParentCode', title: 'ParentCode', width: 80, hidden: true },
				{ field: 'Code', title: 'Code', width: 80,editor:{type:'text'} },
				{ field: 'Name', title: '名称', width: 100,editor:{type:'text'} },
				{ field: 'Desc', title: '描述', width: 180,editor:{type:'text'} },
				{ field: 'Sequence', title: '排序号', width: 50,editor:{type:'numberbox'}}
				]],
			onClickRow: function(rowIndex,rowData) {
				$('#mrViewItemTable').datagrid('options').url = FSConfigViewItem.AjaxUrl;
				var queryParams = $('#mrViewItemTable').datagrid('options').queryParams;
				queryParams.ParentCode = rowData.Code;
				$('#mrViewItemTable').datagrid('options').queryParams = queryParams;
				$('#mrViewItemTable').datagrid('reload');
				
			}
		});
		
		$('#mrViewItemTable').datagrid({
			title: '浏览实例',
			fit: true,
			toolbar:'#mrViewItemTB',
			queryParams: {
				Action: 'mrViewItemlist',
				ParentCode: ''	
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: false,
			rownumbers: true,
			pagination: false,
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{ field: 'ID', title: 'ID', width: 80, hidden: true },
				{ field: 'ParentCode', title: 'ParentCode', width: 80, hidden: true },
				{ field: 'Name', title: '名称', width: 100 ,editor:{type:'text'}},
				{ field: 'MRItemID', title: 'MRItemID', width: 80,editor:{type:'numberbox'} },
				{ field: 'Sequence', title: '排序号', width: 50,editor:{type:'numberbox'}}
				]],
			onClickRow: function(rowIndex,rowData) {	
			}
		});
		$('#mrItemDialog').dialog({
			title: '归档项目实例',
			closed: true,
			cache: false,
			modal: true,
			buttons: [{
				text: '保存',
				iconCls:'icon-ok',
				handler: function() {
					let mrItems = "";
					let parentCode = $('#mrViewSubCategoryTable').datagrid('getSelected').Code
					let selectAllRows = $('#SaveMRItemTable').datagrid('getSelections');
					for(let i=0;i<selectAllRows.length;i++)
					{
						if(i==0)
						{
							mrItems = selectAllRows[i].ID+"#"+selectAllRows[i].Name+"#"+selectAllRows[i].ID
						}
						else
						{
							mrItems=mrItems+"^"+selectAllRows[i].ID+"#"+selectAllRows[i].Name+"#"+selectAllRows[i].ID
						}
					}
					var obj = $.ajax({
						url: FSConfigViewItem.AjaxUrl,
						data: {
							Action: 'addmritembatch',
							ParentCode:parentCode,
							MRItemID: mrItems
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (ret== "1") {
						$.messager.alert('完成','添加成功！','info',function(){
							$('#SaveMRItemTable').datagrid('loadData', { total: 0, rows: [] });	
							FSConfigViewItem.SelectMRItems="#";
							
							$('#mrItemDialog').dialog('close');
							$('#mrViewItemTable').datagrid('reload');
						});
					}
					else {
						$.messager.alert('错误','添加失败！','error');
						return;
					}
				}
			},{
				text: '取消',
				iconCls:'icon-cancel',
				handler: function() {
					$('#SaveMRItemTable').datagrid('loadData', { total: 0, rows: [] });	
					FSConfigViewItem.SelectMRItems="#";
					$('#mrItemDialog').dialog('close');
				}
			}]
		});
		LoadEvent();
	})
})(jQuery);

function LoadEvent()
{
	$("#mrViewCategoryEdit").on('click',function(){
		mrViewCategoryEditClick();
	});
	
	$("#mrViewCategorySave").on("click",function(){
		mrViewCategorySaveClick();
	});
	
	$("#mrViewCategoryAdd").on('click',function(){
		mrViewCategoryAddClick();	
	});
	$("#mrViewCategoryDel").on('click',function(){
		mrViewCategoryDelClick();
	});
	
	$("#mrViewSubCategoryEdit").on('click',function(){
		mrViewSubCategoryEditClick();
	});
	$("#mrViewSubCategorySave").on("click",function(){
		mrViewSubCategorySaveClick();
	});
	
	$("#mrViewSubCategoryAdd").on('click',function(){
		mrViewSubCategoryAddClick();	
	});
	$("#mrViewSubCategoryDel").on('click',function(){
		mrViewSubCategoryDelClick();
	});
	
	$("#mrViewItemEdit").on('click',function(){
		mrViewItemEditClick();
	});
	
	$("#mrViewItemSave").on("click",function(){
		mrViewItemSaveClick();
	});
	
	$("#mrViewItemAdd").on('click',function(){
		mrViewItemAddClick();	
	});
	$("#mrViewItemDel").on('click',function(){
		mrViewItemDelClick();
	});
	$("#mrViewSubCategoryAddBatch").on("click",function(){
		let selectedRow =  $('#mrViewSubCategoryTable').datagrid('getSelected');
		if(selectedRow==null)
		{
			return;
		}
		let desc = selectedRow.Name;
		if(desc=="")
		{
			return;
		}
		InitDialog(desc);
		$('#MRItemTable').datagrid('loadData',{total:0,rows:[]});
		$('#SaveMRItemTable').datagrid('loadData',{total:0,rows:[]});
		$('#mrItemDialog').dialog('open');
		
	});
	
}


function mrViewCategoryEditClick()
{
	var jqobj = $('#mrViewCategoryTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected'));
	$('#mrViewCategoryTable').datagrid('beginEdit',curInd); 
}
function mrViewCategorySaveClick(){
	var jqobj = $('#mrViewCategoryTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
	let oldData=JSON.parse(JSON.stringify(jqobj.datagrid('getSelected')));
	$('#mrViewCategoryTable').datagrid('endEdit',curInd)
	let newData = jqobj.datagrid('getSelected')
	var obj = $.ajax({
		url: FSConfigViewItem.AjaxUrl,
		data: {
			Action: 'AddCategory',
			ID:newData.ID,
			Code: newData.Code,
			Name:newData.Name,
			Description:newData.Desc,
			Sequence:newData.Sequence
		},
		type: 'post',
		async: false
	});
	var ret = obj.responseText;
	if (parseInt(ret) > 0) {
		$.messager.alert('完成','新增成功','info');
		$('#mrViewCategoryTable').datagrid('updateRow',{
			index: curInd,
			row: {ID:ret}
		});
		return;
	}
	else {
		$.messager.alert('错误','新增失败','error');
		$('#mrViewCategoryTable').datagrid('updateRow',{
			index: curInd,
			row: oldData
		});
		return;
	}	
}

function mrViewCategoryAddClick()
{
	$('#mrViewCategoryTable').datagrid('appendRow',{});
	editIndex = $('#mrViewCategoryTable').datagrid('getRows').length-1;
	$('#mrViewCategoryTable').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}

function mrViewCategoryDelClick()
{
	var jqobj = $('#mrViewCategoryTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected'));
	var id = jqobj.datagrid('getSelected').ID;
	if(id!="")
	{
		var obj = $.ajax({
			url: FSConfigViewItem.AjaxUrl,
			data: {
				Action: 'DelCategory',
				ID:id
			},
			type: 'post',
			async: false
		});
		var ret = obj.responseText;
		if (parseInt(ret) > 0) {
			$.messager.alert('完成','删除成功','info');
		}
		else {
			$.messager.alert('错误','删除失败','error');
			return;
		}	
	}	
	$('#mrViewCategoryTable').datagrid('cancelEdit', curInd).datagrid('deleteRow', curInd);
}

function mrViewSubCategoryEditClick()
{
	var jqobj = $('#mrViewSubCategoryTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected'));
	$('#mrViewSubCategoryTable').datagrid('beginEdit',curInd); 
}

function mrViewSubCategorySaveClick(){
	var jqobj = $('#mrViewSubCategoryTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
	let oldData=JSON.parse(JSON.stringify(jqobj.datagrid('getSelected')));
	$('#mrViewSubCategoryTable').datagrid('endEdit',curInd)
	let newData = jqobj.datagrid('getSelected')
	//ajax更新，更新失败还原
	var obj = $.ajax({
		url: FSConfigViewItem.AjaxUrl,
		data: {
			Action: 'AddSubCategory',
			ID:newData.ID,
			ParentCode:newData.ParentCode,
			Code: newData.Code,
			Name:newData.Name,
			Description:newData.Desc,
			Sequence:newData.Sequence
		},
		type: 'post',
		async: false
	});
	var ret = obj.responseText;
	if (parseInt(ret) > 0) {
		$.messager.alert('完成','新增成功','info');
		$('#mrViewSubCategoryTable').datagrid('updateRow',{
			index: curInd,
			row: {ID:ret}
		});
		
		return;
	}
	else {
		$.messager.alert('错误','新增失败','error');
		$('#mrViewSubCategoryTable').datagrid('updateRow',{
			index: curInd,
			row: oldData
		});
		return;
	}	
}

function mrViewSubCategoryAddClick()
{
	$('#mrViewSubCategoryTable').datagrid('appendRow',{ID:"",ParentCode:$('#mrViewCategoryTable').datagrid('getSelected').Code});
	editIndex = $('#mrViewSubCategoryTable').datagrid('getRows').length-1;
	$('#mrViewSubCategoryTable').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}

function mrViewSubCategoryDelClick()
{
	var jqobj = $('#mrViewSubCategoryTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
	//ajax删除
	var id = jqobj.datagrid('getSelected').ID;
	console.log(jqobj.datagrid('getSelected').ID)
	if(id!="")
	{
		var obj = $.ajax({
			url: FSConfigViewItem.AjaxUrl,
			data: {
				Action: 'DelSubCategory',
				ID:id
			},
			type: 'post',
			async: false
		});
		var ret = obj.responseText;
		if (parseInt(ret) > 0) {
			$.messager.alert('完成','删除成功','info');
		}
		else {
			$.messager.alert('错误','删除失败','error');
			return;
		}	
	}	
	$('#mrViewSubCategoryTable').datagrid('cancelEdit', curInd).datagrid('deleteRow', curInd);
}

function mrViewItemEditClick()
{
	var jqobj = $('#mrViewItemTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected'));
	$('#mrViewItemTable').datagrid('beginEdit',curInd); 
}

function mrViewItemSaveClick(){
	var jqobj = $('#mrViewItemTable');
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
	let oldData=JSON.parse(JSON.stringify(jqobj.datagrid('getSelected')));
	$('#mrViewItemTable').datagrid('endEdit',curInd)
	let newData = jqobj.datagrid('getSelected')
	console.log(newData)
	//ajax更新，更新失败还原
	var obj = $.ajax({
		url: FSConfigViewItem.AjaxUrl,
		data: {
			Action: 'AddMRItem',
			ID:newData.ID,
			ParentCode:newData.ParentCode,
			MRItemID: newData.MRItemID,
			Name:newData.Name,
			Sequence:newData.Sequence
		},
		type: 'post',
		async: false
	});
	var ret = obj.responseText;
	console.log(ret)
	if (parseInt(ret) > 0) {
		$.messager.alert('完成','新增成功','info');
		$('#mrViewItemTable').datagrid('updateRow',{
			index: curInd,
			row: {ID:ret}
		});
		$('#mrViewItemTable').datagrid("uncheckAll");
		return;
	}
	else {
		$.messager.alert('错误','新增失败','error');
		$('#mrViewItemTable').datagrid('updateRow',{
			index: curInd,
			row: oldData
		});
		return;
	}	
}

function mrViewItemAddClick()
{
	$('#mrViewItemTable').datagrid('appendRow',{ID:"",ParentCode:$('#mrViewSubCategoryTable').datagrid('getSelected').Code});
	editIndex = $('#mrViewItemTable').datagrid('getRows').length-1;
	$('#mrViewItemTable').datagrid("uncheckAll");
	$('#mrViewItemTable').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
}

function mrViewItemDelClick()
{
	var jqobj = $('#mrViewItemTable');
	var selectRows = jqobj.datagrid("getSelections");
	var ids = "";
	var indexs = [];
	for(let i = 0;i<selectRows.length;i++)
	{
		let row = selectRows[i];
		if(row.ID!="")
		{
			ids=ids+row.ID+"^";
		}
		indexs.push(jqobj.datagrid('getRowIndex',selectRows[i]));
	}
	var curInd =jqobj.datagrid('getRowIndex',jqobj.datagrid('getSelected')) ;
	
	if(ids!="")
	{
		var obj = $.ajax({
			url: FSConfigViewItem.AjaxUrl,
			data: {
				Action: 'DelMRItem',
				ID:ids.substring(0,ids.length-1)
			},
			type: 'post',
			async: false
		});
		var ret = obj.responseText;
		if (parseInt(ret) > 0) {
			$.messager.alert('完成','删除成功','info');
		}
		else {
			$.messager.alert('错误','删除失败','error');
			return;
		}	
	}
	for(let i =indexs.length-1;i>=0;i--)
	{
		$('#mrViewItemTable').datagrid('cancelEdit', indexs[i]).datagrid('deleteRow', indexs[i]);
	}	
	
}


function InitDialog(desc)
{
	FSConfigViewItem.SelectMRItems = "#";
	var url2 = FSConfigViewItem.AjaxUrl+"?Action=SimilaryTree&Description="+encodeURIComponent(desc);
	$('#SimilaryTree').tree({
			title: '相似归档实例',
			method:'get',
    		animate:true,
    		checkbox:true,
			url:url2
	});
	$('#CategoryTree').tree({
			title: '归档分类目录',
			method:'get',
			animate:true,
			url:FSConfigViewItem.AjaxUrl+"?Action=CategoryTree",
			onClick:function(node){
				var queryParams = $('#MRItemTable').datagrid('options').queryParams;
				queryParams.ParentCode = node.attributes.ID;
				
				$('#MRItemTable').datagrid('options').queryParams = queryParams;
				$('#MRItemTable').datagrid('reload');
			}
		});
	
	$('#MRItemTable').datagrid({
			title: '归档实例',
			fit: true,
			border:false,
			toolbar:'#mrItemTB',
			url: FSConfigViewItem.AjaxUrl,
			queryParams: {
				Action: 'mrItemlist',
				ParentCode: ''	
			},
			method: 'post',
			loadMsg: '数据装载中......',
			rownumbers: true,
			pagination: false,
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{ field: 'ID', title: 'ID', width: 80, hidden: true },
				{ field: 'Name', title: '名称', width: 300}
				]]	
		});	
	$('#SaveMRItemTable').datagrid({
			title: '添加归档实例',
			toolbar:'#mrAllItemTB',
			border: false,
			fit: true,
			rownumbers: true,
			pagination: false,
			columns: [[
				{field:'ck',title:'sel',checkbox:true},
				{ field: 'ID', title: 'ID', width: 80, hidden: true },
				{ field: 'Name', title: '名称', width: 600}
				]]	
		});	
	$("#mrItemAdd").on('click',function(){
		let selectTables = $('#MRItemTable').datagrid('getSelections');
		for(let i=0;i<selectTables.length;i++)
		{
			if (FSConfigViewItem.SelectMRItems.indexOf(selectTables[i].ID)==-1)
			{
				$('#SaveMRItemTable').datagrid('appendRow',selectTables[i]);
			
				FSConfigViewItem.SelectMRItems=FSConfigViewItem.SelectMRItems+selectTables[i].ID+"#"
			}
		}
		let similaryTreeChecked = $('#SimilaryTree').tree('getChecked');
		for(let i = 0;i<similaryTreeChecked.length;i++)
		{
			if($('#SimilaryTree').tree('isLeaf',similaryTreeChecked[i].target))
			{
				let id = similaryTreeChecked[i].attributes.mrItemID;
				if (FSConfigViewItem.SelectMRItems.indexOf("#"+id+"#")==-1)
				{
					$('#SaveMRItemTable').datagrid('appendRow',{ID:id,Name:similaryTreeChecked[i].text});
					FSConfigViewItem.SelectMRItems=FSConfigViewItem.SelectMRItems+id+"#"
				}
			}
		}	
	});
	$("#mrAllItemRm").on('click',function(){
		$('#SaveMRItemTable').datagrid('loadData', { total: 0, rows: [] });	
		FSConfigViewItem.SelectMRItems="#";
	});
	
}
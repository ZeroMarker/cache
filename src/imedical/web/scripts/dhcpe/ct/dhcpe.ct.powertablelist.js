
/*
 * FileName: dhcpe.ct.powertablelist.js
 * Author: xy
 * Date: 2021-08-02
 * Description: 表登记授权维护
 */
 
 var lastIndex = "";
var EditIndex = -1;

 $(function(){
		
	InitCombobox();
	
	InitPowerTableListGrid();
	
	//查询
     $('#BFind').click(function(){
    	BFind_click();
    });
    
    //新增
     $('#BAdd').click(function(){
    	BAdd_click();
    });
    
    //修改
     $('#BUpdate').click(function(){
    	BUpdate_click();
    });
    
    //保存
     $('#BSave').click(function(){
    	BSave_click();
    });
	   
	    
})

//查询
function BFind_click(){
	
	$("#PowerTableListGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.PowerTable",
			QueryName:"SearchPowerTableList",
			Code:$("#TabCode").val(),
			Desc:$("#TabDesc").val(),
			Type:$("#PowerType").combobox('getValue'),
			ClsCode:$("#ClsCode").val(),
			ParCode:$("#ParCode").val(),
			
		});	
}

//新增
function BAdd_click()
 {
	lastIndex = $('#PowerTableListGrid').datagrid('getRows').length - 1;
	$('#PowerTableListGrid').datagrid('selectRow', lastIndex);
	var selected = $('#PowerTableListGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TPTLRowid == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#PowerTableListGrid').datagrid('appendRow', {
		TPTLRowid: '',
		TTabCode: '',
		TTabDesc: '',
		TPowerType: '',
		TPowerTypeID:'',
		TTabClsCode:'',
		TTabParCode:'',
		
			});
	lastIndex = $('#PowerTableListGrid').datagrid('getRows').length - 1;
	$('#PowerTableListGrid').datagrid('selectRow', lastIndex);
	$('#PowerTableListGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#PowerTableListGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#PowerTableListGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#PowerTableListGrid').datagrid('beginEdit', thisIndex);
		$('#PowerTableListGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#PowerTableListGrid').datagrid('getSelected');

		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPowerType'  
			});
			
		$(thisEd.target).combobox('select', selected.TPowerTypeID);  
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabDesc'  
			});
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabCode'  
			});
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabClsCode'  
			});
			
		var thisEd = $('#PowerTableListGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TTabParCode'  
			});
		 
		
	}
 }

//保存
function BSave_click()
{
	$('#PowerTableListGrid').datagrid('acceptChanges');
	var selected = $('#PowerTableListGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TPTLRowid == "") {
			if ((selected.TTabCode == "undefined") || (selected.TTabDesc == "undefined") ||(selected.TPowerType=="undefined")||(selected.TTabClsCode == "undefined")||(selected.TTabCode == "") ||(selected.TTabDesc == "")||(selected.TPowerType == "")||	(selected.TTabClsCode == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				LoadPowerTableList();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.PowerTable",
				MethodName: "InsertPowerTable",
				TabCode: selected.TTabCode,
				TabDesc: selected.TTabDesc,
				PowerType: selected.TPowerType,
				ClsCode: selected.TTabClsCode,
				ParCode: selected.TTabParCode	
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', '保存失败:'+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('提示', '保存成功', 'success');
					
				}
			
				
				LoadPowerTableList();
			});
		} else {
			$('#PowerTableListGrid').datagrid('selectRow', EditIndex);
			var selected = $('#PowerTableListGrid').datagrid('getSelected');
		if ((selected.TTabCode == "undefined") || (selected.TTabDesc == "undefined") ||(selected.TPowerType=="undefined")||(selected.TTabClsCode == "undefined")|| (selected.TTabCode == "") || (selected.TTabDesc == "")||(selected.TPowerType == "")||(selected.TTabClsCode == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				LoadPowerTableList();
				return;
			}
			$.m({
				ClassName: "web.DHCPE.CT.PowerTable",
				MethodName: "UpdatePowerTable",
				PTLRowid: selected.TPTLRowid,
				TabCode: selected.TTabCode,
				TabDesc: selected.TTabDesc,
				PowerType: selected.TPowerType,
				ClsCode: selected.TTabClsCode,
				ParCode: selected.TTabParCode
				
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', '修改失败:'+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('提示', '修改成功', 'success');
					
				}
			
				LoadPowerTableList();
			});
		}
	}
}

function LoadPowerTableList()
{
	 $("#PowerTableListGrid").datagrid('reload');
}



//公/私/管控类型  下拉列表值
	
var PowerTypeData = [{
		id: 'G',
		text: '公有'
	}, {
		id: 'S',
		text: '私有'
	}, {
		id: 'C',
		text: '管控'
	}, {
		id: 'A',
		text: '绝对私有'
}];
		
	
var PowerTableListColumns = [[
	{
		field:'TPTLRowid',
		title:'TPTLRowid',
		hidden:true
	},{
		field:'TTabCode',
		width: '200',
		title:'表名',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TTabDesc',
		width: '200',
		title:'中文名',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{  
		field:'TTabClsCode',
		width: '300',
		title:'类名',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TPowerType',
		title:'公/私/管控类型',
		width:250,
		sortable:true,
		resizable:true,
		editor: {
			type:'combobox',
			options: {	
				valueField: 'id',
				textField: 'text',
				data: PowerTypeData,
				required: true
			}
		}
   },{
		field:'TTabParCode',
		width: '200',
		title:'父表',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox'
		}
	},{
		field:'TPowerTypeID',
		title:'TPowerTypeID',
		hidden:true
	}
			
]];
		

function InitPowerTableListGrid(){
	

		
	// 初始化DataGrid
	$('#PowerTableListGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true, 
		pageSize: 20,
		pageList : [20,50,100],
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: PowerTableListColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.PowerTable",
			QueryName:"SearchPowerTableList",
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


function InitCombobox()
{
			
	// 公/私/管控类型
	$HUI.combobox("#PowerType", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:PowerTypeData
	});
	
}
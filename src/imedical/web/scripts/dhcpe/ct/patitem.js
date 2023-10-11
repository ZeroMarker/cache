/*
 * FileName: dhcpe/ct/patitem.js
 * Author: xy
 * Date: 2021-08-15
 * Description: 导诊单类别维护
 */
 
var lastIndex = "";

var EditIndex = -1;

var tableName = "DHC_PE_UsherItemCat";

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){
		
	//获取科室下拉列表
	GetLocComp(SessionStr)
	
	//科室下拉列表change
	$("#LocList").combobox({
       onSelect:function(){
			BFind_click();
		}
	})
	
	//初始化 导诊单类别Grid
	InitPatItemGrid();
	
	//查询
     $('#BFind').click(function(){
    	BFind_click();
    })
    
    //新增
     $('#BAdd').click(function(){
    	BAdd_click();
    })
    
    //修改
     $('#BUpdate').click(function(){
    	BUpdate_click();
    })
    
    //保存
     $('#BSave').click(function(){
    	BSave_click();
    })
    
	$('#PINoActive').checkbox({
		onCheckChange:function(e,vaule){
			BFind_click();			
	    }			
    });
	
	$("#PatItemName").keydown(function(e) {
			
			if(e.keyCode==13){
				BFind_click();
			}
			
     });
          	    
})

//查询
function BFind_click()
{
	$("#PatItemGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.PatItem",
		QueryName:"FindPatItem",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#PatItemName").val(),
		NoActive:$("#PINoActive").checkbox('getValue') ? "Y" : "N"
			
	});	
}
//新增
function BAdd_click()
 {
	lastIndex = $('#PatItemGrid').datagrid('getRows').length - 1;
	$('#PatItemGrid').datagrid('selectRow', lastIndex);
	var selected = $('#PatItemGrid').datagrid('getSelected');
	if (selected) {
		if (selected.TID == "") {
			$.messager.alert('提示', "不能同时添加多条!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('提示', "一次只能修改一条记录", 'info');
		return;
	}
	$('#PatItemGrid').datagrid('appendRow', {
		TID: '',
		TCategory: '',
		TSort: '',
		TPlace: '',
		TDocSignName: '',
		TPatSignName: '',
		TNoActive: ''
		
			});
	lastIndex = $('#PatItemGrid').datagrid('getRows').length - 1;
	$('#PatItemGrid').datagrid('selectRow', lastIndex);
	$('#PatItemGrid').datagrid('beginEdit', lastIndex);
	EditIndex = lastIndex;
 }
 
 //修改
 function BUpdate_click()
 {
	var selected = $('#PatItemGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('提示', "请选择待修改的记录", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#PatItemGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('提示', "一次只能修改一条记录", 'info');
			return;
		}
		$('#PatItemGrid').datagrid('beginEdit', thisIndex);
		$('#PatItemGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#PatItemGrid').datagrid('getSelected');
			
		var thisEd = $('#PatItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TCategory'  
			});
			
		var thisEd = $('#PatItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TSort'  
			});
			
		var thisEd = $('#PatItemGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TPlace'  
			});
		
	}
 }

//TID,TCategory,TSort,TPlace,TDocSignName,TPatSignName,TNoActive,TUpdateDate,TUpdateTime,TUserName
//保存
function BSave_click()
{
	var LocID=$("#LocList").combobox('getValue');
	var UserID=session['LOGON.USERID'];
	
	$('#PatItemGrid').datagrid('acceptChanges');
	var selected = $('#PatItemGrid').datagrid('getSelected');
	
	if (selected) {
			
		if (selected.TID == "") {
			if ((selected.TCategory == "undefined") || (selected.TSort == "undefined")||(selected.TCategory == "") ||(selected.TSort == "")) {
				$.messager.alert('提示', "数据为空,不允许添加", 'info');
				LoadPatItemGrid();
				return;
			}
			var InfoStr=selected.TID+"^"+selected.TCategory+"^"+selected.TSort+"^"+selected.TPlace+"^"+selected.TDocSignName+"^"+selected.TPatSignName+"^"+selected.TNoActive+"^"+LocID+"^"+UserID
			$.m({
				
				ClassName: "web.DHCPE.CT.PatItem",
				MethodName: "SavePatItem",
				InfoStr:InfoStr,
				tableName:tableName
						
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('保存失败:')+ rtnArr[1], 'error');
					
				}else{
					
					$.messager.alert('提示', '保存成功', 'success');
					
				}
			
				
				LoadPatItemGrid();
			});
		} else {
			$('#PatItemGrid').datagrid('selectRow', EditIndex);
			var selected = $('#PatItemGrid').datagrid('getSelected');
			if ((selected.TCategory == "undefined") || (selected.TSort == "undefined")||(selected.TCategory == "") ||(selected.TSort == "")) {
				$.messager.alert('提示', "数据为空,不允许修改", 'info');
				LoadPatItemGrid();
				return;
			}
		   var InfoStr=selected.TID+"^"+selected.TCategory+"^"+selected.TSort+"^"+selected.TPlace+"^"+selected.TDocSignName+"^"+selected.TPatSignName+"^"+selected.TNoActive+"^"+LocID+"^"+UserID
			$.m({
				
				ClassName: "web.DHCPE.CT.PatItem",
				MethodName: "SavePatItem",
				InfoStr:InfoStr,
				tableName:tableName
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('提示', $g('修改失败:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.alert('提示', '修改成功', 'success');
					
				}
			
				LoadPatItemGrid();
			});
		}
	}
}

function LoadPatItemGrid()
{
	 $("#PatItemGrid").datagrid('reload');
}

function InitPatItemGrid(){
	// 初始化Grid
	$('#PatItemGrid').datagrid({
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
		columns: PatItemColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.PatItem",
			QueryName:"FindPatItem",
			LocID:session['LOGON.CTLOCID']
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;
		}
	});
	
}


//保存
var PatItemColumns = [[
	{
		field:'TID',
		title:'ID',
		hidden:true
	},{
		field:'TCategory',
		width: '200',
		title:'类别',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TSort',
		width: '90',
		title:'顺序',
		sortable: true,
		//resizable: true,
		editor: {
			type: 'numberbox',
			options: {
				required: true
			}
		}
	},{
		field:'TPlace',
		width: '250',
		title:'位置',
		editor: 'text',
		//sortable: false,
		resizable: true,
		editor: {
			type: 'textarea',
			options: {
				height:'50px'
						
			}
		}
	 },{
		field: 'TDocSignName',
		width: '90',
		title: '医生签名',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{
		field: 'TPatSignName',
		width: '90',
		title: '患者签名',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{
		field: 'TNoActive',
		width: '80',
		title: '激活',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
			on:'Y',
			off:'N'
		}
						
	  }
	},{
		field: 'TUpdateDate',
		width: '120',
		title: '更新日期'
	}, {
		field: 'TUpdateTime',
		width: '120',
		title: '更新时间'
	}, {
		field: 'TUserName',
		width: '120',
		title: '更新人'
	}	
	
	
	
]];

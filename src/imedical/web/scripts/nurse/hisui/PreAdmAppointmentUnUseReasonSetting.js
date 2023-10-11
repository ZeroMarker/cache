var PageLogicObj={
	m_ReturnReasonTabDataGrid:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	var hospComp = GenHospComp("Nur_IP_DHCDocIPCancleReason");
	hospComp.jdata.options.onSelect = function(e,t){
		ClearData();
		UnUseReasonTabDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitUnUseReasonTabDataGrid();
		UnUseReasonTabDataGridLoad();
	}
}
function InitEvent(){
	$("#Bfind").click(UnUseReasonTabDataGridLoad);
}
function InitUnUseReasonTabDataGrid() {
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddClickHandle(); }
    },{
        text: '修改',
        iconCls: 'icon-write-order',
        handler: function() { UpdateClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelClickHandle();}
    }];
	var Columns=[[ 
		{field:'RowID',hidden:true,title:''},
		{field:'Code',title:'代码',width:300},
		{field:'Desc',title:'描述',width:300}
    ]]
	$("#UnUseReasonTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'RowID',
		columns :Columns,
		toolbar:toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=$("#UnUseReasonTab").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#UnUseReasonTab").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#UnUseReasonTab").datagrid('unselectRow',index);
					return false;
				}
			}
		},
		onBeforeLoad:function(param){
			$('#UnUseReasonTab').datagrid("unselectAll"); 
		}
	}); 
}
function UnUseReasonTabDataGridLoad(){
	var Code=$("#code").val()
	var Desc=$("#name").val()
	$.m({
		ClassName:"web.DHCDocIPAppointment",
		MethodName:"FindCancleReasonBroker",
		CodeStr:Code,
		DescStr:Desc,
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(data){
		var GridData=[];
		if(data){
			for (var i=0;i<data.split("!").length;i++){
				var oneData=data.split("!")[i];
				var RowID=oneData.split("^")[0];
				var Code=oneData.split("^")[1];
				var Desc=oneData.split("^")[2];
				GridData.push({
					RowID:RowID,
					Code:Code,
					Desc:Desc
				});
			}
		}
		$("#UnUseReasonTab").datagrid("unselectAll").datagrid('loadData',GridData);
	})
}
function SetSelRowData(row){
	$("#code").val(row["Code"])
	$("#name").val(row["Desc"])
}
function AddClickHandle(){
	var Code=$("#code").val()
	var Desc=$("#name").val()
	if(!CheckData()) return false;
	$.m({
		ClassName:"web.DHCDocIPAppointment",
		MethodName:"AddCancleReason",
		Code:Code,
		Desc:Desc,
		IsActive:"Y",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if(rtn.split("^")[0]=="0"){
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			ClearData();
			UnUseReasonTabDataGridLoad();
		}else{
			$.messager.popover({msg: '保存失败!'+rtn.split("^")[1],type:'error',timeout: 1000});
			return false
		}
	})
}
function DelClickHandle(){
	var row=$("#UnUseReasonTab").datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.popover({msg: '请选择需要删除的行！',type:'error',timeout: 1000});
		return false
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
	    if (r){    
	        var RowId=row["RowID"]
			$.m({
				ClassName:"web.DHCDocIPAppointment",
				MethodName:"DeleteCancleReason",
				RowId:RowId
			},function(rtn){
				if(rtn=="0"){
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					ClearData();
					var oldIndex=$("#UnUseReasonTab").datagrid('getRowIndex',row);
					$("#UnUseReasonTab").datagrid('deleteRow',oldIndex);
				}else{
					$.messager.popover({msg: '删除失败!',type:'error',timeout: 1000});
					return false
				}
			})
	    }    
	});  
}
function UpdateClickHandle(){
	var row=$("#UnUseReasonTab").datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.popover({msg: '请选择需要修改的行！',type:'error',timeout: 1000});
		return false
	}
	var RowId=row["RowID"]
	var Code=$("#code").val()
	var Desc=$("#name").val()
	if(!CheckData()) return false;
	$.m({
		ClassName:"web.DHCDocIPAppointment",
		MethodName:"UpdateCancleReason",
		RowId:RowId,
		Code:Code,
		Desc:Desc
	},function(rtn){
		if(rtn=="0"){
			$.messager.popover({msg: '更新成功!',type:'success',timeout: 1000});
			ClearData();
			var index=$("#UnUseReasonTab").datagrid("unselectAll").datagrid('getRowIndex',RowId);
			$('#UnUseReasonTab').datagrid('updateRow',{
				index: index,
				row: {
					Code: Code,
					Desc: Desc
				}
			});
		}else{
			$.messager.popover({msg: '更新失败!'+rtn,type:'error',timeout: 1000});
			return false
		}
	})
}
function CheckData(){
	var Code=$("#code").val()
	var Desc=$("#name").val()
	if (Code==""){
		$.messager.popover({msg: '请输入编码！',type:'error',timeout: 1000});
		$("#code").focus();
		return false;
	}
	if (Desc==""){
		$.messager.popover({msg: '请输入描述！',type:'error',timeout: 1000});
		$("#code").focus();
		return false
	}
	return true
}
function ClearData(){
	$("#code,#name").val("");
}
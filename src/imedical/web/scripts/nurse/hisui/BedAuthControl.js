var PageLogicObj={
	m_EditIndex:""
}
$(function(){
	//初始化
	Init();
});
function Init(){
	var hospComp = GenHospComp("Nur_IP_DHCBedManager");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#tabLimitHosp,#tabUnLimitWard").datagrid("reload");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		InitLimitHospDataGrid();
		InitUnLimitWardDataGrid();
	}
}
function InitLimitHospDataGrid() {
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {AddHospClickHandle(); }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelHospClickHandle();}
    }];
	var Columns=[[ 
		{field:'HosID',title:'院区ID',width:70},
		{field:'HosDesc',title:'院区',width:250}
    ]]
	$("#tabLimitHosp").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'HosID',
		columns :Columns,
		toolbar:toobar,
		onBeforeSelect:function(index, row){
			var selrow=$("#tabLimitHosp").datagrid('getSelected');
			if (selrow){
				var oldIndex=$("#tabLimitHosp").datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					$("#tabLimitHosp").datagrid('unselectRow',index);
					return false;
				}
			}
		},
		url : $URL+"?ClassName=Nur.DHCBedManager&QueryName=GetControlHos",
		onBeforeLoad:function(param){
			$('#tabLimitHosp').datagrid("unselectAll");
			param = $.extend(param,{Hosid:$HUI.combogrid('#_HospList').getValue()});
		}
	}); 
}
function InitUnLimitWardDataGrid() {
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() {
	        if (PageLogicObj.m_EditIndex) {
                return;
            }else{
                $("#tabUnLimitWard").datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                $("#tabUnLimitWard").datagrid("beginEdit", 0);
                PageLogicObj.m_EditIndex = 0;
            }
	    }
    },{
        text: '删除',
        iconCls: 'icon-cancel',
        handler: function() {DelUnLimitWardClickHandle();}
    },{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {SaveUnLimitWardClickHandle();}
    }];
	var Columns=[[ 
		{field:'LocID',title:'病区ID',width:90},
		{field:'LocDesc',title:'病区',width:350,
			editor:{
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=Nur.InService.DHCDocIPAppointment&QueryName=QryCTLoc&rows=99999&ResultSetType=array",
					valueField:'CTLocID',
					textField:'CTLocDesc',
					mode:'remote',
					onSelect:function(rec){
						if (rec){
							var rows=$("#tabUnLimitWard").datagrid("selectRow",PageLogicObj.m_EditIndex).datagrid("getSelected");
							rows.LocID=rec.CTLocID;
						}
					},
					onHidePanel:function(){
						var rows=$("#tabUnLimitWard").datagrid("selectRow",PageLogicObj.m_EditIndex).datagrid("getSelected");
						if (!$.isNumeric($(this).combobox('getValue'))) {
							rows.LocID="";
							return;
						}
						rows.LocID=$(this).combobox('getValue');
					},
					onBeforeLoad:function(param){
						var argDesc=param["q"];
						$.extend(param,{
							argDesc:argDesc,
							argType:"W",
							argLocID:"",
							Hos:$HUI.combogrid('#_HospList').getValue(),
							LocConfig:""
						});
					}
				}
		    }
		}
    ]]
	$("#tabUnLimitWard").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'LocID',
		columns :Columns,
		toolbar:toobar,
		url : $URL+"?ClassName=Nur.DHCBedManager&QueryName=GetControlWard",
		onBeforeLoad:function(param){
			$('#tabUnLimitWard').datagrid("unselectAll");
			param = $.extend(param,{Hosid:$HUI.combogrid('#_HospList').getValue()});
		}
	}); 
}
function AddHospClickHandle(){
	$.m({
		ClassName:"Nur.DHCBedManager",
		MethodName:"AddHospital",
		id:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if(+rtn=="0"){
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			$("#tabLimitHosp").datagrid("reload");
		}else{
			$.messager.popover({msg: '保存失败!',type:'error',timeout: 1000});
			return false
		}
	})
}
function DelHospClickHandle(){
	var row=$("#tabLimitHosp").datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.popover({msg: '请选择需要删除的行！',type:'error',timeout: 1000});
		return false
	}
	$.m({
		ClassName:"Nur.DHCBedManager",
		MethodName:"DeleteHospital",
		id:row.HosID
	},function(rtn){
		if(rtn=="0"){
			$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
			$("#tabLimitHosp,#tabUnLimitWard").datagrid("reload");
		}else{
			$.messager.popover({msg: '删除失败!',type:'error',timeout: 1000});
			return false
		}
	})
}
function SaveUnLimitWardClickHandle(){
	var rows=$("#tabUnLimitWard").datagrid("selectRow",PageLogicObj.m_EditIndex).datagrid("getSelected");
	if (!rows.LocID) {
		$.messager.popover({msg: '请选择病区!',type:'error',timeout: 1000});
		return false;
	}
	$.m({
		ClassName:"Nur.DHCBedManager",
		MethodName:"AddWard",
		id:rows.LocID
	},function(rtn){
		if(+rtn=="0"){
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			$("#tabUnLimitWard").datagrid("reload");
		}else{
			$.messager.popover({msg: '保存失败!'+rtn,type:'error',timeout: 1000});
			return false
		}
	})
}
function DelUnLimitWardClickHandle(){
	var row=$("#tabUnLimitWard").datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.popover({msg: '请选择需要删除的行！',type:'error',timeout: 1000});
		return false
	}
	if (!row.LocID) {
		PageLogicObj.m_EditIndex = "";
        $("#tabUnLimitWard").datagrid("rejectChanges").datagrid("unselectAll");
        return;
	}
	$.m({
		ClassName:"Nur.DHCBedManager",
		MethodName:"DeleteWard",
		id:row.LocID
	},function(rtn){
		if(rtn=="0"){
			$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
			$("#tabUnLimitWard").datagrid("reload");
		}else{
			$.messager.popover({msg: '删除失败!',type:'error',timeout: 1000});
			return false
		}
	})
}
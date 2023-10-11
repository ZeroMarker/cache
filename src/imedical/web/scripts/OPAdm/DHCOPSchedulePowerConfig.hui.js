var PageLogicObj={
	m_UserListTabDataGrid:"",
	m_LocListTabDataGrid:"",
	m_ResListTabDataGrid:"",
	m_PoweredListTabDataGrid:"",
	m_searchGroup:""
};
$(function(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_GroupScheAuth");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#FindUser,#FindLoc,#FindRes").searchbox('setValue',"");
		Init()
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
	//事件初始化
	InitEvent();
	$("#Group").focus();
});
function Init(){
	PageLogicObj.m_UserListTabDataGrid=InitUserListTabDataGrid();
}
function InitEvent(){
	$("#BSavePower").click(BSavePowerClick);
}
function InitUserListTabDataGrid(){
	var Columns=[[ 
		{field:'SSUSR_Name',title:'排班员',width:180},
		{field:'SSUSR_RowId',title:'ID',width:80}
    ]]
	var UserListTabDataGrid=$("#UserListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'SSUSR_RowId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCUserGroup&QueryName=Finduse1&HOSPID="+$HUI.combogrid('#_HospList').getValue(),
		onBeforeLoad:function(param){
			$("#UserListTab").datagrid("uncheckAll");
			var desc=$("#FindUser").searchbox('getValue'); 
			param = $.extend(param,{Desc:desc});
		},
		onSelect:function(){
			if (PageLogicObj.m_LocListTabDataGrid=="") {
				PageLogicObj.m_LocListTabDataGrid=InitLocListTabDataGrid();
			}else{
				PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
			}
			if (PageLogicObj.m_PoweredListTabDataGrid=="") {
				PageLogicObj.m_PoweredListTabDataGrid=InitPoweredListTabDataGrid();
			}else{
				PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
			}
		},
		onUncheckAll:function(rows){
			if (PageLogicObj.m_LocListTabDataGrid!="") {
				PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_ResListTabDataGrid!=""){
				PageLogicObj.m_ResListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
			if (PageLogicObj.m_PoweredListTabDataGrid!=""){
				PageLogicObj.m_PoweredListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
			}
		}
	});
	return UserListTabDataGrid;
}
function InitLocListTabDataGrid(){
	var Columns=[[ 
		{field:'id',title:'',checkbox:true},
		{field:'name',title:'科室',width:200}
    ]]
	var LocListTabDataGrid=$("#LocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'id',
		columns :Columns,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QueryLoc&rows=99999",
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_LocListTabDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_LocListTabDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		},
		onBeforeLoad:function(param){
			$("#LocListTab").datagrid("uncheckAll");
			var desc=$("#FindLoc").searchbox('getValue'); 
			param = $.extend(param,{depname:desc,LogHospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onSelect:function(){
			if (PageLogicObj.m_ResListTabDataGrid=="") {
				PageLogicObj.m_ResListTabDataGrid=InitResListTabDataGrid();
			}else{
				PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
			}
			PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
		},
		onUnselect:function(){
			PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
			PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
		},onUncheckAll:function(rows){
			setTimeout(function() { 
				if (PageLogicObj.m_ResListTabDataGrid!=""){
					PageLogicObj.m_ResListTabDataGrid.datagrid("uncheckAll").datagrid('loadData', {"total":0,"rows":[]});
				}
				if (PageLogicObj.m_PoweredListTabDataGrid!=""){
					PageLogicObj.m_PoweredListTabDataGrid.datagrid("uncheckAll").datagrid('reload');
				}
			},500);
		},
		onCheckAll:function(){
			if (PageLogicObj.m_ResListTabDataGrid=="") {
				PageLogicObj.m_ResListTabDataGrid=InitResListTabDataGrid();
			}else{
				PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
			}
			PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
		}
	});
	return LocListTabDataGrid;
}
function InitResListTabDataGrid(){
	var Columns=[[ 
		{field:'ResRowId',title:'',checkbox:true},
		{field:'Desc',title:'医生号别',width:180}		
    ]]
	var ResListTabDataGrid=$("#ResListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		idField:'ResRowId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCOPAdmPowerConfig&QueryName=FindResDoc&rows=99999",
		onBeforeLoad:function(param){
			$("#ResListTab").datagrid("uncheckAll");
			var desc=$("#FindRes").searchbox('getValue'); 
			param = $.extend(param,{UserId:GetSelUserId(),depstr:GetSelDeptStr(),docname:desc});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].PoweredFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_ResListTabDataGrid.datagrid('selectRow',i);
				}
			}
			
		}
	});
	return ResListTabDataGrid;
}
function InitPoweredListTabDataGrid(){
	var Columns=[[ 
		{field:'LocDesc',title:'科室',width:160},
		{field:'CTPCPDesc',title:'医生号别',width:110},
		{field:'RESRowId',title:'操作',width:40,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="CancelSchedulePower(\'' + row["LocId"] +'\',\''+ row["CTPCPDR"]+ '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png"/></a>';
				return btn;
			}
		}	
    ]]
	var PoweredListTabDataGrid=$("#PoweredListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false, 
		pageSize: 20,
		pageList : [20,100,200], 
		idField:'RESRowId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCOPAdmPowerConfig&QueryName=FindPoweredByUser",
		onBeforeLoad:function(param){
			var isShowDoc=$("#switch1").switchbox('getValue')?"Y":"N";
			param = $.extend(param,{UserId:GetSelUserId(),Depstr:GetSelDeptStr(),isShowDoc:isShowDoc,HospRowId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	return PoweredListTabDataGrid;
}
function CancelSchedulePower(DeptId,DocId){
	var UserId=GetSelUserId();
	$.m({
	    ClassName:"web.DHCOPAdmPowerConfig",
	    MethodName:"DeleteSchedulePower",
	    UserId:UserId,
	    DeptId:DeptId,
	    DocId:DocId
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'删除成功!',type:'success',timeout:1000});
			PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
		}
	})
}
function GetSelDeptStr(){
	var depstr=""; 
	var locRows=PageLogicObj.m_LocListTabDataGrid.datagrid('getSelections');
	for (var i=0;i<locRows.length;i++){
		if (depstr=="") depstr=locRows[i].id;
		else  depstr=depstr+"^"+locRows[i].id;
	}
	return depstr;
}
function GetSelUserId(){
	var UserSelRow=PageLogicObj.m_UserListTabDataGrid.datagrid('getSelections');
	if (UserSelRow.length==0) return "";
	var UserId=UserSelRow[0].SSUSR_RowId;
	return UserId;
}
function FindUserChange(){
	PageLogicObj.m_UserListTabDataGrid.datagrid("reload");
}
function FindLocChange(){
	PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
}
function FindResChange(){
	PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
}
function BSavePowerClick(){
	var UserId=GetSelUserId();
	if (UserId=="") {
		$.messager.alert("提示","请选择排班员!");
		return false;
	}
	var Depstr=GetSelDeptStr();
	if (Depstr=="") {
		$.messager.alert("提示","没有需要授权的科室!");
		return false;
	}
	if (PageLogicObj.m_ResListTabDataGrid=="") {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var rows=PageLogicObj.m_ResListTabDataGrid.datagrid('getRows');
	if (rows.length==0) {
		$.messager.alert("提示","没有需要保存的数据!");
		return false;
	}
	var GridSelectArr=PageLogicObj.m_ResListTabDataGrid.datagrid('getSelections');
	var inPara="",outPara="";
	for (var i=0;i<rows.length;i++){
		//var RowID=rows[i].RowID;
		var ResRowId=rows[i].ResRowId;
		//if ($("input[value='"+ResRowId+"']").is(":Checked")){
		if ($.hisui.indexOfArray(GridSelectArr,"ResRowId",ResRowId)>=0) {
			if (inPara == "") inPara = ResRowId;
			else  inPara = inPara + "^" + ResRowId;
		}else{
			if (outPara == "") outPara = ResRowId;
			else  outPara = outPara + "!" + ResRowId;
		}
	}
	$.m({
	    ClassName:"web.DHCOPAdmPowerConfig",
	    MethodName:"SaveSchedulePower",
	    UserId:UserId,
	    Depstr:Depstr,
	    inPara:inPara,
		outPara:outPara
	},function(rtn){
		if(rtn==0){
			$("#FindRes").searchbox('setValue',''); 
			$.messager.popover({msg:'授权保存成功',type:'success',timeout:1000});
			PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
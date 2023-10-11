var PageLogicObj={
	m_GroupListTabDataGrid:"",
	m_LocListTabDataGrid:"",
	m_ResListTabDataGrid:"",
	m_PoweredListTabDataGrid:"",
	m_searchGroup:""
};
$(function(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_GroupRegAuth");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#FindGroup,#FindLoc,#FindRes").searchbox('setValue',"");
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
	PageLogicObj.m_GroupListTabDataGrid=InitGroupListTabDataGrid();
	initRegRoomPowerWin();
}
function InitEvent(){
	$("#BSavePower").click(BSavePowerClick);
	$("#BSaveRoomPower").click(ShowRoomWin);
}
function InitGroupListTabDataGrid(){
	var Columns=[[ 
		{field:'SSGRP_Desc',title:'安全组',width:180},
		{field:'SSGRP_Rowid',title:'ID',width:80}
    ]]
	var GroupListTabDataGrid=$("#GroupListTab").datagrid({
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
		idField:'SSGRP_Rowid',
		columns :Columns,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindGroup",
		onBeforeLoad:function(param){
			$("#GroupListTab").datagrid("uncheckAll");
			var desc=$("#FindGroup").searchbox('getValue'); 
			param = $.extend(param,{value:desc,HospRowId:$HUI.combogrid('#_HospList').getValue()});
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
	return GroupListTabDataGrid;
}
function InitLocListTabDataGrid(){
	var Columns=[[ 
		{field:'id',title:'',checkbox:true},
		{field:'name',title:'科室',width:180}
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
		url:$URL+"?ClassName=web.DHCOPAdmPowerConfig&QueryName=FindDoc&rows=99999",
		onBeforeLoad:function(param){
			$("#ResListTab").datagrid("uncheckAll");
			var desc=$("#FindRes").searchbox('getValue'); 
			//新增院区ID
			param = $.extend(param,{GroupId:GetSelGroupId(),depstr:GetSelDeptStr(),docname:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
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
				if (row["RESRowId"]!="") { 
					var btn = '<a class="editcls" onclick="CancelRegPower(\'' + row["LocId"] +'\',\''+ row["RESRowId"]+ '\')"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png"/></a>';
					return btn;
				}
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
		url:$URL+"?ClassName=web.DHCOPAdmPowerConfig&QueryName=FindPoweredByGroup",
		onBeforeLoad:function(param){
			var isShowDoc=$("#switch1").switchbox('getValue')?"Y":"N";
			param = $.extend(param,{GroupId:GetSelGroupId(),Depstr:GetSelDeptStr(),isShowDoc:isShowDoc,HospRowId:$HUI.combogrid('#_HospList').getValue()});
		}
	});
	return PoweredListTabDataGrid;
}
function CancelRegPower(LocId,ResRowId){
	var GroupId=GetSelGroupId();
	var isShowDoc=$("#switch1").switchbox('getValue')?"Y":"N";
	if (isShowDoc=="Y") {
		$.m({
		    ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
		    MethodName:"DeleteGroupRes",
		    GroupRowId:GroupId,
		    ResRowId:ResRowId,
		    //新增院区ID
	    	HospId:$HUI.combogrid('#_HospList').getValue()
		},function(rtn){
			if(rtn==0){
				$.messager.popover({msg:'删除成功!',type:'success',timeout:1000});
				PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
			}
		})
	}else{
		$.m({
		    ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
		    MethodName:"DeleteGroupResByLoc",
		    GroupRowId:GroupId,
		    LocId:LocId,
		    //新增院区ID
	    	HospId:$HUI.combogrid('#_HospList').getValue()
		},function(rtn){
			if(rtn==0){
				$.messager.popover({msg:'删除成功!',type:'success',timeout:1000});
				PageLogicObj.m_PoweredListTabDataGrid.datagrid("reload");
			}
		})
	}
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
function GetSelGroupId(){
	var GroupSelRow=PageLogicObj.m_GroupListTabDataGrid.datagrid('getSelections');
	if (GroupSelRow.length==0) return "";
	var GroupId=GroupSelRow[0].SSGRP_Rowid;
	return GroupId;
}
function FindGroupChange(){
	PageLogicObj.m_GroupListTabDataGrid.datagrid("reload");
}
function FindLocChange(){
	PageLogicObj.m_LocListTabDataGrid.datagrid("reload");
}
function FindResChange(){
	PageLogicObj.m_ResListTabDataGrid.datagrid("reload");
}
function BSavePowerClick(){
	var GroupId=GetSelGroupId();
	if (GroupId=="") {
		$.messager.alert("提示","请选择安全组!");
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
	
	var inPara="",subPara="";
	for (var i=0;i<rows.length;i++){
		//var RowID=rows[i].RowID;
		var ResRowId=rows[i].ResRowId;
		//if ($("input[value='"+ResRowId+"']").is(":Checked")){
		if ($.hisui.indexOfArray(GridSelectArr,"ResRowId",ResRowId)>=0) {
			if (inPara == "") inPara = ResRowId;
			else  inPara = inPara + "!" + ResRowId;
		}else{
			if (subPara == "") subPara = ResRowId;
			else  subPara = subPara + "!" + ResRowId;
		}
	}
	$.m({
	    ClassName:"DHCDoc.DHCDocConfig.CommonFunction",
	    MethodName:"SaveGroupRes",
	    GroupRowId:GroupId,
	    inPara:inPara,
	    subPara:subPara,
	    ////新增院区ID
	    HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'授权保存成功',type:'success',timeout:1000});
			PageLogicObj.m_LocListTabDataGrid.datagrid("uncheckAll");
		}
	})
}
function ShowRoomWin(){
	var GroupId=GetSelGroupId();
	if (GroupId=="") {
		$.messager.alert("提示","请选择安全组!");
		return false;
	}
	$('#reg-roompower-win-search').searchbox('setValue','');
	$('#reg-roompower-win-list').datagrid('options').url='websys.Broker.cls';
	$('#reg-roompower-win-list').datagrid('unselectAll').datagrid('load',{ClassName:'web.DHCOPAdmPowerConfig',QueryName:'FindRoomByGroup',GroupId:GetSelGroupId(),Desc:'',HospRowId:$HUI.combogrid('#_HospList').getValue()});
	$('#reg-roompower-win').dialog('open');
}
function initRegRoomPowerWin(){
	var winH=$(window).height()||550-120;
	var winW=430;
	$('#reg-roompower-win').dialog({
		height:winH,
		width:winW,
		title:'诊室授权',
		buttons:[
			{
				text:'保存',
				handler:saveRegRoomPower
			},
			{
				text:'关闭',
				handler:function(){
					$('#reg-roompower-win').dialog('close');
				}	
			}
		]
	});
	$('#reg-roompower-win-search').searchbox({
		width:winW-40,
		searcher:function(value){
			var ResRowId=$('#reg-roompower-win-id').val();
			$('#reg-roompower-win-list').datagrid('load',{ClassName:'web.DHCOPAdmPowerConfig',QueryName:'FindRoomByGroup',GroupId:GetSelGroupId(),Desc:value,HospRowId:$HUI.combogrid('#_HospList').getValue()});
		}
	})
	$('#reg-roompower-win-list').datagrid({
		width:winW-20,
		height:winH-207+110,
		bodyCls:'panel-header-gray',
		singleSelect:true,
		pagination:true,
		pageSize:30,
		columns:[[
			{field:'RoomName',title:'诊室',width:270},
			{field:'GrantedFlag',title:'诊室挂号授权',width:100,align:'center',formatter:function(value,row,index){
				return "<label class='checkbox-label'><input type='checkbox' data-id='"+row.RoomId+"'  "+(value=="1"?"checked":"")+"/> </label>";
			}},
			{field:'RoomId',title:'ID',hidden:true}
		]],
		idField:'RoomId',
		url:"",
		lazy:true,
		toolbar:'#reg-roompower-win-list-tb'
	})
}
function saveRegRoomPower(){
	var inStr="",OutStr="";
	$('#reg-roompower-win .checkbox-label>input').each(function(i){
		var id=$(this).data('id');
		if($(this).is(':checked')){
			if (inStr=="") inStr=id;
			else  inStr=inStr+"!"+id;
		}else{
			if (OutStr=="") OutStr=id;
			else  OutStr=OutStr+"!"+id;
		}
	})
	$.m({
		ClassName:'web.DHCOPRegConfig',
		MethodName:'SaveGroupRegRoomNew',
		GroupRowId:GetSelGroupId(),
		InResRoomStr:inStr,
		OutResRoomStr:OutStr,
		//新增院区ID
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'授权保存成功',type:'success',timeout:1000});
		}
		$('#reg-roompower-win').dialog('close');
	})
}
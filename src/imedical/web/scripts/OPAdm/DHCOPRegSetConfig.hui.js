var PageLogicObj={
	m_GroupListTabDataGrid:"",
	OPRegInsertOrder:false,
}
$(function(){
	//初始化医院
	var hospComp = GenHospComp("Doc_OPAdm_RegSetConfig");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#FindGroup,#FindLoc,#FindRes").searchbox('setValue',"");
		Init()
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
	//事件初始化
	InitEvent();
});
function Init(){
	InitOPRegAdmCategory();
	PageLogicObj.m_GroupListTabDataGrid=InitGroupListTabDataGrid();
	$("#ForceCancelRegGroup").switchbox('setValue',false);
	$("#OPNotReportGroup").switchbox('setValue',false);
	$("#OPAllocReport").switchbox('setValue',false);
	$("#ScheduleSentMessage").switchbox('setValue',false);
	//$("#BookPreLocDocLimit").switchbox('setValue',false);
	//$("#BookPreLocNurseLimit").switchbox('setValue',false);
	//$("#BookPreLocCashLimit").switchbox('setValue',false);
	$("#RegDefaultSearch").switchbox('setValue',false);
	$("#OPRegInsertOrder").switchbox('setValue',false);
}
function InitEvent(){
	$("#Update").click(UpdateClick);
	$("#MessageInfo").click(MessageInfoClick);
	$("#SaveMessage").click(SaveMessageClick);
}
function InitOPRegAdmCategory() {
	$('#OPRegAdmCategory').combogrid({    
		panelWidth:310,    
		value:'',
		idField:'ADMCATRowId',    
		textField:'ADMCATDesc',    
		url:$URL+"?ClassName=web.DHCOPRegConfig&QueryName=PACAdmCategoryList",
		columns:[[    
			{field:'ADMCATDesc',title:'名称',width:150},    
			{field:'ADMCATIsPayAfterTrea',title:'先诊疗后付费',width:150},    
			{field:'ADMCATRowId',hidden:true} 
		]],
		onChange:function(newValue, oldValue){
			console.log(newValue+";"+ oldValue)
			if (newValue!=""){
				var Gird=$($('#OPRegAdmCategory').combogrid("grid"));
				var rows=Gird.datagrid("getData").rows;
				var VaildFlag="N";
				rows.forEach(function(row,i){
					if (row.ADMCATRowId==newValue){
						VaildFlag="Y";
						return false;
					}
				})
				if (VaildFlag=="N"){
					$.messager.alert("提醒","就诊分类数据已失效，请重新维护","info",function () {
						$('#OPRegAdmCategory').combogrid("setValue","")
					})
				}
			}
		},
		onSelect:function(Index,RowData){
			if (RowData.ADMCATIsPayAfterTrea=="Y"){
				$("#OPRegInsertOrder").switchbox('setValue',true);
			}else{
				$("#OPRegInsertOrder").switchbox('setValue',PageLogicObj.OPRegInsertOrder);
			}
		}  
	}); 
	
	$("#OPRegAdmCategory").combo('disable',true);
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
			var GroupId=GetSelGroupId()
			LoadData(GroupId)
		},	onUnselect:function(){LoadData("")},
		onUncheckAll:function(rows){
			LoadData("")
		}
	});
	return GroupListTabDataGrid;
}
function FindGroupChange(){
	PageLogicObj.m_GroupListTabDataGrid.datagrid("reload");
}
function GetSelGroupId(){
	var GroupSelRow=PageLogicObj.m_GroupListTabDataGrid.datagrid('getSelections');
	if (GroupSelRow.length==0) return "";
	var GroupId=GroupSelRow[0].SSGRP_Rowid;
	return GroupId;
}
function LoadData(GroupId){
	if (GroupId==""){
		$("#ForceCancelRegGroup").switchbox('setValue',false);
		$("#OPNotReportGroup").switchbox('setValue',false);
		$("#OPAllocReport").switchbox('setValue',false);
		$("#ScheduleSentMessage").switchbox('setValue',false);
		//$("#BookPreLocDocLimit").switchbox('setValue',false);
		//$("#BookPreLocNurseLimit").switchbox('setValue',false);
		//$("#BookPreLocCashLimit").switchbox('setValue',false);
		$("#RegDefaultSearch").switchbox('setValue',false);
		$("#OPRegInsertOrder").switchbox('setValue',false);
		$("#OPRegInsertOrder").switchbox('setValue',false);
		PageLogicObj.OPRegInsertOrder=false;
		$('#OPRegAdmCategory').combogrid("setValue",'')
	}else{
	$.m({
	    ClassName:"web.DHCOPRegConfig",
	    MethodName:"GetRegSetConfig",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    GroupID:GroupId,
	},function(rtn){
		var rtnArr=rtn.split(String.fromCharCode(1))
		if (rtnArr[0]==1){
			$("#ForceCancelRegGroup").switchbox('setValue',true);
		}else{
			$("#ForceCancelRegGroup").switchbox('setValue',false);
		}
		if (rtnArr[1]==1){
			$("#OPNotReportGroup").switchbox('setValue',true);
		}else{
			$("#OPNotReportGroup").switchbox('setValue',false);
		}
		if (rtnArr[2]==1){
			$("#OPAllocReport").switchbox('setValue',true);
		}else{
			$("#OPAllocReport").switchbox('setValue',false);
		}
		if (rtnArr[3]==1){
			$("#ScheduleSentMessage").switchbox('setValue',true);
		}else{
			$("#ScheduleSentMessage").switchbox('setValue',false);
		}
		$("#MessageSentFunction").val(rtnArr[4])
		$("#MessageSentContent").val(rtnArr[5])
		/*if (rtnArr[6]==1){
			$("#BookPreLocDocLimit").switchbox('setValue',true);
		}else{
			$("#BookPreLocDocLimit").switchbox('setValue',false);
		}
		if (rtnArr[7]==1){
			$("#BookPreLocNurseLimit").switchbox('setValue',true);
		}else{
			$("#BookPreLocNurseLimit").switchbox('setValue',false);
		}
		if (rtnArr[8]==1){
			$("#BookPreLocCashLimit").switchbox('setValue',true);
		}else{
			$("#BookPreLocCashLimit").switchbox('setValue',false);
		}*/
		if (rtnArr[9]==1){
			$("#RegDefaultSearch").switchbox('setValue',true);
		}else{
			$("#RegDefaultSearch").switchbox('setValue',false);
		}
		$('#OPRegAdmCategory').combogrid("setValue",rtnArr[11])
		if (rtnArr[10]==1){
			$("#OPRegInsertOrder").switchbox('setValue',true);
			PageLogicObj.OPRegInsertOrder=true;
		}else{
			$("#OPRegInsertOrder").switchbox('setValue',false);
			PageLogicObj.OPRegInsertOrder=false;
		}
		
	})		
	}
	}
function UpdateClick(){
	var GroupId=GetSelGroupId();
	if (GroupId=="") {
		$.messager.alert("提示","请选择安全组!");
		return false;
	}
	var OPRegAdmCategory=$('#OPRegAdmCategory').combogrid("getValue");
	var OPRegInsertOrder=(eval($("#OPRegInsertOrder").switchbox("getValue"))==true?1:0);
	if (OPRegAdmCategory!=""){
		var Gird=$($('#OPRegAdmCategory').combogrid("grid"));
		var rows=Gird.datagrid("getData").rows;
		var Desc="";var IsPayAfterTrea="";
		rows.forEach(function(row,i){
			if (row.ADMCATRowId==OPRegAdmCategory){
				Desc=row.ADMCATDesc;
				IsPayAfterTrea=row.ADMCATIsPayAfterTrea;
				return false;
			}
		})
		if ((IsPayAfterTrea=="Y")&&(OPRegInsertOrder==0)){
			$.messager.confirm("提示", "就诊分类["+Desc+"]为先诊疗后付费类型，与挂号插入医嘱不结算流程不一致，是否确认保存？", function (r) {
				if (r) {
					Save();
				} else {
					return false;
				}
			});
		}else{
			Save()
		}
	}else{
		Save()
	}
	function Save(){
		var NoteStr=""
		NoteStr="ForceCancelRegGroup"+"!"+(eval($("#ForceCancelRegGroup").switchbox("getValue"))==true?1:0);
		NoteStr=NoteStr+"^"+"OPNotReportGroup"+"!"+(eval($("#OPNotReportGroup").switchbox("getValue"))==true?1:0);
		NoteStr=NoteStr+"^"+"OPAllocReport"+"!"+(eval($("#OPAllocReport").switchbox("getValue"))==true?1:0);
		NoteStr=NoteStr+"^"+"ScheduleSentMessage"+"!"+(eval($("#ScheduleSentMessage").switchbox("getValue"))==true?1:0);
		//NoteStr=NoteStr+"^"+"BookPreLocDocLimit"+"!"+(eval($("#BookPreLocDocLimit").switchbox("getValue"))==true?1:0);
		//NoteStr=NoteStr+"^"+"BookPreLocNurseLimit"+"!"+(eval($("#BookPreLocNurseLimit").switchbox("getValue"))==true?1:0);
		//NoteStr=NoteStr+"^"+"BookPreLocCashLimit"+"!"+(eval($("#BookPreLocCashLimit").switchbox("getValue"))==true?1:0);
		NoteStr=NoteStr+"^"+"RegDefaultSearch"+"!"+(eval($("#RegDefaultSearch").switchbox("getValue"))==true?1:0);
		NoteStr=NoteStr+"^"+"OPRegInsertOrder"+"!"+OPRegInsertOrder;
		NoteStr=NoteStr+"^"+"OPRegAdmCategory"+"!"+OPRegAdmCategory;
		$.m({
			ClassName:"web.DHCOPRegConfig",
			MethodName:"SaveRegSetConfig",
			HospId:$HUI.combogrid('#_HospList').getValue(),
			GroupID:GroupId,
			NodeStr:NoteStr
		},function(rtn){
			if(rtn==0){
				$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			}
		})
	}
}
function MessageInfoClick(){
	var GroupId=GetSelGroupId();
	if (GroupId=="") {
		$.messager.alert("提示","请选择安全组!");
		return false;
	}
	$("#MessageInfoWin").dialog("open")
	}
function SaveMessageClick(){
	var GroupId=GetSelGroupId();
	if (GroupId=="") {
		$.messager.alert("提示","请选择安全组!");
		return false;
	}
	var NoteStr=""
	NoteStr="MessageSentFunction"+"!"+$("#MessageSentFunction").val();
	NoteStr=NoteStr+"^"+"MessageSentContent"+"!"+$("#MessageSentContent").val();
	$.m({
	    ClassName:"web.DHCOPRegConfig",
	    MethodName:"SaveRegSetConfig",
	    HospId:$HUI.combogrid('#_HospList').getValue(),
	    GroupID:GroupId,
	    NodeStr:NoteStr
	},function(rtn){
		if(rtn==0){
			$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
			$("#MessageInfoWin").dialog("close")
		}
	})
}
function OPNotReportGroupSwitchChange(e,obj){
	if (obj.value) {
		$("#OPAllocReport").switchbox('setValue',false);
	}
}
function OPAllocReportSwitchChange(e,obj){
	if (obj.value) {
		$("#OPNotReportGroup").switchbox('setValue',false);
	}
}

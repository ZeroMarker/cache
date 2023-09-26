var arrayObj = new Array(
	  new Array("Check_GeneSchedule","AudiGeneSchedule"),
	  new Array("Check_NewSchedule","AudiNewSchedule"),
	  new Array("Check_StopSchedule","AudiStopSchedule"),
	  new Array("Check_CancelStopSchedule","AudiCancelStopSchedule"),
	  new Array("Check_ReplaceSchedule","AudiReplaceSchedule")
);

var AudiReasonDataGrid;

$(document).ready(function(){
	Init();
	InitEvent();
});


function Init(){
	var hospComp = GenHospComp("Doc_OPAdm_ScheduleAudit");
	InitAudiReasonDataGrid();
	hospComp.jdata.options.onSelect = function(e,t){
		LoadGroupData();
		LoadCheckData();
		LoadLocData();
		AudiReasonDataGridLoad();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		LoadGroupData();
		LoadCheckData();
		LoadLocData();
		AudiReasonDataGridLoad();
	}
}

function LoadCheckData(){
	for(var i=0;i<arrayObj.length;i++){
		var paramid=arrayObj[i][0];
		var param=arrayObj[i][1];
		
		var ObjScope=$.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"GetConfigNodeNew",
			'Node':param,
			HospId:$HUI.combogrid('#_HospList').getValue()
		},false);
		
		var result=false;
		var value=ObjScope.result;
		if(value=="Y"){
			result=true;	
		}

		SetSwitchBox(paramid,result);	

	}
}

function InitEvent(){
	$('#Confirm').click(function() {
		SaveConfigData();
	})
	
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});

}

function SetSwitchBox(param,objScopeVal){
	var obj=$HUI.switchbox("#"+param);
	obj.setValue(objScopeVal)	
}

function LoadGroupData(){
	$("#List_AudiNotLimitedGroup").empty();
	$.m({
		ClassName:"web.DHCRBApptScheduleAudi",
		MethodName:"FindGroupListBroker",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneGroup=objScopeArr[i];
			var oneGroupArr=oneGroup.split(String.fromCharCode(2))
			var GroupRowID=oneGroupArr[0];
			var GroupDesc=oneGroupArr[1];
			var selected=oneGroupArr[2];
			vlist += "<option value=" + GroupRowID + ">" + GroupDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_AudiNotLimitedGroup").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_AudiNotLimitedGroup").get(0).options[j-1].selected = true;
			}
		}
	});	
}

function LoadLocData(){
	$("#List_AudiNotNeedLoc").empty();
	$.m({
		ClassName:"web.DHCRBApptScheduleAudi",
		MethodName:"FindLocListBroker",
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function(objScope){
		var vlist = ""; 
		var selectlist="";
		var objScopeArr=objScope.split(String.fromCharCode(1))
		for(var i=0;i<objScopeArr.length;i++){
			var oneLoc=	objScopeArr[i];
			var oneLocArr=oneLoc.split(String.fromCharCode(2))
			var LocRowID=oneLocArr[0];
			var LocDesc=oneLocArr[1];
			var selected=oneLocArr[2];
			vlist += "<option value=" + LocRowID + ">" + LocDesc + "</option>"; 
			selectlist=selectlist+"^"+selected
		}
		$("#List_AudiNotNeedLoc").append(vlist); 
		for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]==1){
				$("#List_AudiNotNeedLoc").get(0).options[j-1].selected = true;
			}
		}
	});
    
}

function SaveConfigData()
{
	var LocDataStr=""
	var size = $("#List_AudiNotNeedLoc option").size();
	if(size>0){
		$.each($("#List_AudiNotNeedLoc  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (LocDataStr=="") LocDataStr=svalue
			else LocDataStr=LocDataStr+"^"+svalue
		})
		LocDataStr="AudiNotNeedLocStr"+String.fromCharCode(1)+LocDataStr
	}
	
	var GroupDataStr=""
	var size = $("#List_AudiNotLimitedGroup option").size();
	if(size>0){
		$.each($("#List_AudiNotLimitedGroup  option:selected"), function(i,own){
			var svalue = $(own).val();
			if (GroupDataStr=="") GroupDataStr=svalue
			else GroupDataStr=GroupDataStr+"^"+svalue
		})
		GroupDataStr="AudiNotLimitedGroupStr"+String.fromCharCode(1)+GroupDataStr
	}
	
	var CheckStr="";
	for(var i=0;i<arrayObj.length;i++){
		var paramid=arrayObj[i][0];
		var param=arrayObj[i][1];
		var myobj=$HUI.switchbox("#"+paramid);
		var paramflag="";
		if (myobj.getValue()) {
			paramflag="Y";
		}
		var str=param+String.fromCharCode(1)+paramflag;
		if(CheckStr==""){
			CheckStr=str;
		}else{
			CheckStr=CheckStr+String.fromCharCode(2)+str;	
		}
	}

	var DataStr=LocDataStr+String.fromCharCode(2)+CheckStr+String.fromCharCode(2)+GroupDataStr;
	$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig",
		Coninfo:DataStr,
		HospId:$HUI.combogrid('#_HospList').getValue()
	},function(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});					
		}else{
			$.messager.show({title:"提示",msg:"保存失败"});		
		}
	});
}

function InitAudiReasonDataGrid(){
	var AudiReasontoolbar=[{
		text:'增加',
		iconCls:'icon-add',
		handler:function(){
			$("#add-dialog").dialog("open");
			//清空表单数据
			$('#add-form').form("clear");

		}
	},{
		text:'更新',
		iconCls:'icon-edit',
		handler:function(){
			UpdateGridData();
		}	
	},{
        text: '授权医院',
        iconCls: 'icon-house',
        handler: function() {
	        var row=AudiReasonDataGrid.datagrid('getSelected');
			if (!row){
				$.messager.alert("提示","请选择一行！")
				return false
			}
			GenHospWin("DHC_RBApptScheduleAudiReason",row.TAudiID);
	    }
    }]
	AudiReasonDataGrid=$('#tblAudiReason').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		singleSelect:true,    
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"TAudiID",
		//pageNumber:0,
		pageSize : 10,
		pageList : [10,20,50],
		toolbar:AudiReasontoolbar,
		columns :[[ 
				{field:'TAudiID',title:'主键',width:50,align:'center'}, 
				{field:'TAudiDesc',title:'拒绝原因',width:250,align:'center'}, 
				{field:'TAudiStartDate',title:'开始日期',width:150,align:'center'}, 
				{field:'TAudiEndDate',title:'结束日期',width:150,align:'center'}								
			 ]]
	});
	
}

function AudiReasonDataGridLoad(){
	
	$.cm({
		ClassName:"web.DHCRBApptScheduleAudi",
		QueryName:"FindAudiReason",
		HospID:$HUI.combogrid('#_HospList').getValue(),
		Pagerows:AudiReasonDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		AudiReasonDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData); 
		AudiReasonDataGrid.datagrid('clearSelections'); 
	})

}

function CheckData(){
	var DDCTSDesc=$("#Desc").val();
	if(DDCTSDesc=="")
	{
		$.messager.alert('提示','描述不能为空');   
        return false;
	}
	var DDCTSStartTime=$("#StartDate").datebox('getValue');
	if(DDCTSStartTime=="")
	{
		$.messager.alert('提示','开始日期不能为空');   
        return false;
	}
	var DDCTSEndTime=$("#EndDate").datebox('getValue');
	if(DDCTSEndTime=="")
	{
		//$.messager.alert('提示','结束日期不能为空');   
        //return false;
	}
	return true;
}
///修改表格函数
function SaveFormData(){
	if(!CheckData()) return false;    
	var ROWID=$("#ROWID").val();
	var Desc=$("#Desc").val();
	var StartDate=$("#StartDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	var InputPara=ROWID+"^"+Desc+"^"+StartDate+"^"+EndDate;
	 //alert(InputPara)
	 
	$.m({
		ClassName:"web.DHCRBApptScheduleAudi",
		MethodName:"SetAudiReason",
		Para:InputPara,
		HospID:$HUI.combogrid('#_HospList').getValue()
	},function testget(value){
		if(value=="0"){
			$.messager.show({title:"提示",msg:"保存成功"});	
			$("#add-dialog").dialog( "close" );
			AudiReasonDataGridLoad()
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else err=value;
			$.messager.alert('提示',err);   
			return false;
		}
	});
}
///修改表格函数
function UpdateGridData(){
	var rows = AudiReasonDataGrid.datagrid("getSelections");
	if (rows.length ==1) {
		//$("#add-dialog").dialog("open");
		$('#add-dialog').window('open').window('resize',{width:'350px',height:'300px',top: 100,left:400});
		//清空表单数据
		$('#add-form').form("clear")
		
		$('#add-form').form("load",{
			ROWID:rows[0].TAudiID,
			Desc:rows[0].TAudiDesc,
			StartDate:rows[0].TAudiStartDate,
			EndDate:rows[0].TAudiEndDate,
		})
     }else if (rows.length>1){
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
     }

}

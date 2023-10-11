/**
* @author songchunli
* HISUI 护嘱频次配置主js
*/
var PageLogicObj={
	m_SelFreqId:"",
	m_tabFreqDispeningListGrid:"",
	iframeflag:"0", //2758853【护理计划配置】业务界面整合  是否是iframe 界面  1：是； 0：否

}
$(function(){ 
	//2758853【护理计划配置】业务界面整合
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe 界面
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// 正常界面
	}
	InitEvent();
});
$(window).load(function() {
	$("#loading").hide();
	InitEditWindow();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabInterventionFreqList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabInterventionFreqList").datagrid("reload");
		}
	});
	$("#BSaveFreq").click(SaveFreqClick);
	$("#BCancel").click(function(){
		$("#InterventionFreqWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_InterventionFreq");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$.extend(PageLogicObj,{m_SelFreqId:""});
		$("#tabInterventionFreqList").datagrid("load");
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// 初始化 状态查询条件
	InitInterventionLinkTaskList();
}
function InitInterventionLinkTaskList(){
	var ToolBar = [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				// 初始化 2021.7.12
				$("#Active").checkbox("setValue",false);
				// 清空选项
				$("input[name='AdmType']:checked").each(function(index,data){
					$HUI.checkbox("#"+data.id).setValue(false);
				})
				PageLogicObj.m_SelFreqId="";
				$("#InterventionFreqWin").window('open');
			}
	},{
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#tabInterventionFreqList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
				return false;
			}
			ShowInterventionFreqWin(row);
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var row = $("#tabInterventionFreqList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
				return false;
			}
			$.messager.confirm('确认对话框', '确认要删除该条数据吗?', function(r){
				if (r){
					$.m({
						ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
						MethodName:"DeleteInterventionFreq",
						rowID:row.id
					},function(rtn){
						if (rtn ==0){
							$('#tabInterventionFreqList').datagrid("reload");
						}else{
							$.messager.alert("提示","删除失败！"+rtn);
						}
					})
				}
			});	
		}
    }];
	var Columns=[[ 
		{ field: 'code',title:'代码',width:100},
		{ field: 'namec',title:'中文描述',width:150,wordBreak:"break-all"},
		{ field: 'namee',title:'英文描述',width:150},
		{ field: 'factor',title:'系数',width:60,},
		{ field: 'activeFlag',title:'是否激活',width:70,
			formatter: function(value,row,index){
				if (value=="Yes"){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{ field: 'weekFlag',title:'周频次',width:60,
			formatter: function(value,row,index){
				if (value=="Yes"){
					return "是";
				} else {
					return "否";
				}
			}
		},
		{ field: 'clinicType',title:'就诊类型',width:250},
		{ field: 'disposing',title:'分发时间',width:250}
    ]];
	$('#tabInterventionFreqList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : true, 
		rownumbers : true,
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionFreq",
		onBeforeLoad:function(param){
			$.extend(PageLogicObj,{m_SelFreqId:""});
			$('#tabInterventionFreqList').datagrid("unselectAll"); 
			//param = $.extend(param,{codeIn:$("#SearchDesc").val(),active:"",hospicalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{
				codeIn:$("#SearchDesc").val(),
				active:"",
				hospicalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
			});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionFreqWin(rowData);
		}
	})
}

//2758853【护理计划配置】业务界面整合
function ReloadInterventionFreqList(rowID){
	$('#tabInterventionFreqList').datagrid('load',{
		nameCN:$("#SearchDesc").val(),
		codeIn:$("#SearchDesc").val(),
		active:"",
		hospicalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	})
}

function InitEditWindow(){
    $("#InterventionFreqWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetInterventionFreqWinData();
	   }
	});
	InitFreqDispeningListGrid();
}
function InitFreqDispeningListGrid(){
	var ToolBar = [{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				if (!checkDispengTime()) return;
				var time=$("#FreqDispeningTime").timespinner("getValue");
				if (!time){
					$.messager.popover({msg:'请选择时间！',type:'error'});
					$("#FreqDispeningTime").focus();
					return false;
				}
				var index=$("#tabFreqDispeningList").datagrid("getRowIndex",time);
				if (index>=0) {
					$.messager.popover({msg:'时间已存在！',type:'error'});
					$("#FreqDispeningTime").focus();
					return false;
				}
				var rows = $("#tabFreqDispeningList").datagrid("getRows");
				$('#tabFreqDispeningList').datagrid('appendRow',{
					id: rows.length,
					DispeningTime: time
				});		
				$("#FreqDispeningTime").timespinner("setValue","");	
				$("#FreqDispeningTime").focus();	
			}
	},{
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var FreqFactor=$("#FreqFactor").val();
			if (!FreqFactor) {
				$.messager.popover({msg:'请先维护系数！',type:'error'});
				$("#FreqFactor").focus();
				return false;
			}
			var time=$("#FreqDispeningTime").timespinner("getValue");
			if (!time){
				$.messager.popover({msg:'请选择时间！',type:'error'});
				$("#FreqDispeningTime").focus();
				return false;
			}
			var row = $("#tabFreqDispeningList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
				return false;
			}
			var SelIndex=$("#tabFreqDispeningList").datagrid("getRowIndex",row.DispeningTime);
			var index=$("#tabFreqDispeningList").datagrid("getRowIndex",time);
			if ((index>=0)&&(SelIndex!=index)) {
				$.messager.popover({msg:'时间已存在！',type:'error'});
				$("#FreqDispeningTime").focus();
				return false;
			}
			$('#tabFreqDispeningList').datagrid('updateRow',{
				index: SelIndex,
				row: {
					DispeningTime: time
				}
			});
			$("#FreqDispeningTime").timespinner("setValue","");	
			$("#FreqDispeningTime").focus();	
		}
	},{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			if (!checkDispengTime()) return;
			var row = $("#tabFreqDispeningList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
				return false;
			}
			var index=$("#tabFreqDispeningList").datagrid("getRowIndex",row.DispeningTime);
			$("#tabFreqDispeningList").datagrid("deleteRow",index);
		}
	}];
	var Columns=[[    
		{ field: 'id',checkbox:'true'},
		{ field: 'DispeningTime',title:'分发时间',width:200}
	]];
	PageLogicObj.m_tabFreqDispeningListGrid=$('#tabFreqDispeningList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false, 
		rownumbers : false, 
		idField:"DispeningTime",
		columns :Columns, 
		nowrap:false,  /*此处为false*/
		toolbar :ToolBar,
		onBeforeLoad:function(param){
			$('#tabFreqDispeningList').datagrid("unselectAll"); 
		}
	})
}
function ShowInterventionFreqWin(row){
	PageLogicObj.m_SelFreqId=row.id;
	$("#FreqCode").val(row.code);
	$("#FreqNameE").val(row.namee);
	$("#FreqNameC").val(row.namec);
	$("#FreqFactor").val(row.factor);
	$("#Active").checkbox("setValue",row.activeFlag=="Yes"?true:false);
	$("#WeekFlag").checkbox("setValue",row.weekFlag=="Yes"?true:false);
	// 就诊类型 回显数据
	SetTypeList(row.clinicTypeList)
	var disposing=row.disposing;
	var gridData=[];
	for (var i=0;i<disposing.split("|").length;i++){
		gridData.push({"id":i,"DispeningTime":disposing.split("|")[i]});
	}
	$("#tabFreqDispeningList").datagrid("loadData",gridData);
	$("#InterventionFreqWin").window('open');
}
function SetInterventionFreqWinData(){
	$("#FreqCode,#FreqNameE,#FreqNameC,#FreqFactor").val("");
	$("#Active").checkbox("setValue",true);
	$("#WeekFlag").checkbox("setValue",false);
	$("#FreqDispeningTime").timespinner("setValue","");
	$("#tabFreqDispeningList").datagrid("loadData",[]);
}
function checkDispengTime(){
	var FreqFactor=$("#FreqFactor").val();
	if (!FreqFactor) {
		$.messager.popover({msg:'请先维护系数！',type:'error'});
		$("#FreqFactor").focus();
		return false;
	}
	var rows = $("#tabFreqDispeningList").datagrid("getRows");
	if (rows.length==FreqFactor){
		$.messager.popover({msg:'分发时间次数应等于系数！',type:'error'});
		return false;
	}
	return true;
}
// 保存频次
function SaveFreqClick(){
	var FreqCode=$("#FreqCode").val();
	var FreqNameE=$("#FreqNameE").val();
	var FreqNameC=$("#FreqNameC").val();
	var FreqFactor=$("#FreqFactor").val();
	if ((!FreqCode)||(!FreqNameE)||(!FreqNameC)||(!FreqFactor)){
		$.messager.popover({msg:'基本信息未填写全！',type:'error'});
		return false;
	}
	var DispensingTimeStr="";
	var rows = $("#tabFreqDispeningList").datagrid("getRows");
	if (rows.length !=FreqFactor){
		$.messager.popover({msg:'分发时间次数应等于系数！',type:'error'});
		return false;
	}
	for (var i=0;i<rows.length;i++){
		if (DispensingTimeStr=="") DispensingTimeStr=rows[i].DispeningTime;
		else  DispensingTimeStr=DispensingTimeStr+"|"+rows[i].DispeningTime;
	}
	var Json=$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"SaveInterventionFreq",
		rowID:PageLogicObj.m_SelFreqId,
		LocDR:session['LOGON.CTLOCID'],
		NIFRCode:FreqCode,
		NIFRDescEN:FreqNameE,
		NIFRDescCN:FreqNameC,
		NIFRFactor:FreqFactor,
		NIFRDays:"",
		NIFREnableDate:"",
		NIFRActiveFlag:$("#Active").checkbox("getValue")?"Y":"N",
		NIFRWeekFlag:$("#WeekFlag").checkbox("getValue")?"Y":"N",
		NIFRAfterNextDayFlag:"",
		DispensingTime:DispensingTimeStr,
		NIFRClinicType:GetTyteList(),
		optID:session['LOGON.USERID'],
		//hospitalID:$HUI.combogrid('#_HospList').getValue()
		//2758853【护理计划配置】业务界面整合
		hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},false)
	if (Json.errcode ==0){
		$("#InterventionFreqWin").window("close");
		$("#tabInterventionFreqList").datagrid("reload");
	}else{
		$.messager.alert("提示","保存失败!"+Json.errinfo);
		return false;
	}
}

// 获取当前选中的类型
function GetTyteList()
{
	var str="";
	$("input[name='AdmType']:checked").each(function(){
		str += (str==""?"":"") + $(this).val();
	})
	return str;
}

// 设置初始化的类型
function SetTypeList(valueStr)
{
	// 清空选项
	$("input[name='AdmType']:checked").each(function(index,data){
		$HUI.checkbox("#"+data.id).setValue(false);
	})
	
	// 数据库中数据
	var checkArray = [];
	for (var j=0;j<valueStr.length;j++)
	{
		var str = valueStr[j]
		checkArray.push(str)
	}
	
	//获得所有的复选框对象
	var checkBoxAll = $("input[name='AdmType']");
	for(var i=0;i<checkArray.length;i++){
	 //获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
	 $.each(checkBoxAll,function(j,checkbox){
		 //获取复选框的value属性
		 var checkValue=$(checkbox).val();
		 if(checkArray[i]==checkValue){
			 $HUI.checkbox("#"+checkbox.id).setValue(true);
		 }
	 });
 	};
}
//2758853【护理计划配置】业务界面整合
function ResetInterventionFreqWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	/*
	if (PageLogicObj.iframeflag=="1"){
		$("#InterventionFreqWin").parent().css({
			width:innerWidth,
		});
		$("#InterventionFreqWin").parent().find(".panel-header").css({
			width:innerWidth,
		});
		$("#InterventionFreqWin").window('resize',{
			width:innerWidth,
			height:innerHeight-28,
		});
    }    
    */
}
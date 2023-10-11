/**
* @author songchunli
* HISUI 措施内容配置主js
* InterventionSetting.js
*/
var PageLogicObj={
	InterventionApplyArea:[{"id":"1","text":"成人"},{"id":"2","text":"儿童"},{"id":"3","text":"婴儿"},{"id":"4","text":"新生儿"}],
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
	InitInterventionsEditWinWin();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabInterventionsList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabInterventionsList").datagrid("reload");
		}
	});
	$("#BSaveIntervention").click(SaveInterventionClick);
	$("#BCancel").click(function(){
		$("#InterventionsEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_Intervention");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabInterventionsList").datagrid("load");
		InitInterventionsEditWinWin();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// 初始化 状态查询条件
	InitStatus();
	InitQuestionListDataGrid();
}
function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		data:[{"id":"1","text":"启用",selected:true},{"id":"0","text":"停用"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabInterventionsList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabInterventionsList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabInterventionsList").datagrid("load");
		}
	});
}

function InitQuestionListDataGrid(){
	var ToolBar = [{
            text: '新增',
            iconCls: 'icon-add',
            handler: function() {
				$("#InterventionsEditWin").window('open');
            }
        },{
            text: '修改',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#tabInterventionsList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'请选择需要修改的记录！',type:'error'});
					return false;
				}
				ShowInterventionsWin(row);
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteInterventions();
            }
        },"-",{
	        text:'措施分类配置',
	        iconCls: 'icon-set-col',
	        handler:function(){
		        window.parent.window.addiFrametoEditWindow("nur.hisui.interventionstype.csp","措施分类配置","","");

		    }	        
	    }];
	var Columns=[[    
		{ field: 'intType',title:'措施分类',width:120,
			formatter: function(value,row,index){
				var valueArr=value.split("^");
				return valueArr[1]+"("+valueArr[2]+")";
			}
		},
		{ field: 'intCode',title:'措施编码',width:100},
		{ field: 'intShortName',title:'措施短描述',width:350,wordBreak:"break-all"},
		{ field: 'intLongName',title:'措施长描述',width:350,wordBreak:"break-all"},
		{ field: 'applayArea',title:'适用人群',width:200},
		{ field: 'intStatus',title:'状态',width:60,
			styler: function(value,row,index){
				if (value =="启用"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		}
    ]];
	$('#tabInterventionsList').datagrid({  
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
		idField:"intRowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*此处为false*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=GetInterventionList",
		onBeforeLoad:function(param){
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="";
			}
			PageLogicObj.m_SelRowId="";
			$('#tabInterventionsList').datagrid("unselectAll");
			//param = $.extend(param,{searchName:$("#SearchDesc").val(),status:status,hospDR:$HUI.combogrid('#_HospList').getValue()});
			//2758853【护理计划配置】业务界面整合
			param = $.extend(param,{searchName:$("#SearchDesc").val(),status:status,hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionsWin(rowData);
		},
		//2758853【护理计划配置】业务界面整合
		onClickRow:function(rowIndex, rowData){
			var rowID=rowData.intRowID;
			$(window.parent.$("#iframeInterventionlinktasksetting"))[0].contentWindow.ReloadInterventionLinkTaskList(rowID);	
			
			$(window.parent.$("#iframeInterventionextreport"))[0].contentWindow.ReloadInterventionExtReportList(rowID);	

		}

	})
}
//2758853【护理计划配置】业务界面整合
function ReloadInterventionsList(){
	$('#tabInterventionsList').datagrid('load',{searchName:$("#SearchDesc").val(),status:status,hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())})
}

function InitEditWindow(){
    $("#InterventionsEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetInterventionsEditWinData();
	   }
	});
}
function InitInterventionsEditWinWin(){
	// 措施类别
	InitInterventionType();
	// 默认频次
	InitInterventionFreq();
	// 适用人群
	InitInterventionApplyArea();
	$("#EnableDate").datebox("setValue",ServerObj.CurrentDate);
}
function InitInterventionType(){
	$('#InterventionType').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.InterventionSetting&QueryName=FindInterventionType&rows=99999",
		mode:'remote',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'NewName',
		onBeforeLoad:function(param){
			param.nameCN=param['q'];
			//param.hospDR=$HUI.combogrid('#_HospList').getValue();
			//2758853【护理计划配置】业务界面整合
			param.hospDR=(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue());
		},loadFilter:function(data){
			// todo 优化 改成query直接返回显示值
			var newData=new Array();
			for (var i=0;i<data.total;i++){
				var obj=data.rows[i];
				obj.NewName=obj.shortNameEN+obj.shortNameCN;
				newData.push(obj);
			}
			return newData;
		}
    });
}
function InitInterventionFreq(){
	$('#InterventionFreq').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionFreq&rows=99999",
		valueField:'id',
		textField:'name',
		loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.total;i++){
				var obj=data.rows[i];
				obj.name=obj.code+"("+obj.namec+")";
				newData.push(obj);
			}
			return newData;
		},
		onBeforeLoad:function(param){
			param.codeIn=param['q'];
			param.active="Y";
			//param.hospicalID=$HUI.combogrid('#_HospList').getValue();
			//2758853【护理计划配置】业务界面整合
			param.hospicalID=(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue());
		}
	})
}
function InitInterventionApplyArea(){
	$("#InterventionApplyArea").combobox({
		valueField:'id',
		textField:'text',
		multiple:true,
		method:'local',
		data:PageLogicObj.InterventionApplyArea
	})
}
function ShowInterventionsWin(row){
	$("#InterventionType").combobox("setValue",row.intType.split("^")[0]);
	$("#InterventionCode").val(row.intCode);
	$("#InterventionFreq").combobox("setValue",row.defFreq);
	var applayArea=row.applayArea;
	if (applayArea =="全部人群") applayArea="";
	var applayAreaId=[];
	for (var i=0;i<applayArea.split(";").length;i++){
		var index=$.hisui.indexOfArray(PageLogicObj.InterventionApplyArea,"text",applayArea.split(";")[i]);
		if (index >=0) applayAreaId.push(PageLogicObj.InterventionApplyArea[index].id);
	}
	$("#InterventionApplyArea").combobox("setValues",applayAreaId);
    $("#InterventionShortName").val(row.intShortName);
	$("#InterventionLongName").val(row.intLongName);
	$("#EnableDate").datebox("setValue",row.intEnableDate);
	$("#StopDate").datebox("setValue",row.intStopDate);
	PageLogicObj.m_SelRowId=row.intRowID;
	$("#InterventionsEditWin").window('open');
}
function SetInterventionsEditWinData(){
	PageLogicObj.m_SelRowId="";
	$("#InterventionType").combobox("setValue","");
	$("#InterventionCode,#InterventionShortName,#InterventionLongName").val("");
	$("#InterventionFreq").combobox("setValue","");
	$("#InterventionApplyArea").combobox("setValues",[]);
	$("#EnableDate").datebox("setValue",ServerObj.CurrentDate);
	$("#StopDate").datebox("setValue","");
}
function DeleteInterventions(){
	var selected = $("#tabInterventionsList").datagrid("getSelected");
	if (!selected) {
		$.messager.popover({msg:'请选择需要删除的记录！',type:'error'});
		return false;
	}
	var rowID=selected.intRowID;
	var Msg="确定要删除此条措施内容吗？";
		Msg += '</br><sapn style="opacity:0.65;">此措施内容删除后，措施类别将不会自动带出该措施内容.</sapn>';
	$.messager.confirm('确认对话框', Msg, function(r){
		if (r) {
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
				MethodName:"DeleteSingleIntervention",
				locID:session['LOGON.CTLOCID'],
				userID:session['LOGON.USERID'], 
				intRowID:rowID
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'删除失败！',type:'error'});
				return false;
			}else{
				var QueIndex=$('#tabInterventionsList').datagrid('getRowIndex',rowID);
				$('#tabInterventionsList').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
// 保存措施内容
function SaveInterventionClick(){
	var intCode=$("#InterventionCode").val();
	var InterventionType=$("#InterventionType").combobox("getValue");
	if (!InterventionType) {
		$.messager.popover({msg:'请选择措施类别！',type:'error'});
		$('#InterventionType').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#InterventionType').combobox("getData"),"id",InterventionType)<0){
		$.messager.popover({msg:'请在下拉框中选择措施类别！',type:'error'});
		$('#InterventionType').next('span').find('input').focus();
		return false;
	}
	var defFreq=$("#InterventionFreq").combobox("getValue");
	if (!defFreq) {
		$.messager.popover({msg:'请选择默认频次！',type:'error'});
		$('#InterventionFreq').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#InterventionFreq').combobox("getData"),"id",defFreq)<0){
		$.messager.popover({msg:'请在下拉框中选择默认频次！',type:'error'});
		$('#InterventionFreq').next('span').find('input').focus();
		return false;
	}
	var intShortName=$("#InterventionShortName").val();
	if (!intShortName) {
		$.messager.popover({msg:'请输入措施短描述！',type:'error'});
		$("#InterventionShortName").focus();
		return false;
	}
	var InterventionLongName=$("#InterventionLongName").val();
	if (!InterventionLongName) {
		$.messager.popover({msg:'请输入措施长描述！',type:'error'});
		$('#InterventionLongName').focus();
		return false;
	}
	
	var EnableDate=$("#EnableDate").datebox("getValue");
	if (!EnableDate) {
		$.messager.popover({msg:'请填写启用日期！',type:'error'});
		$('#EnableDate').next('span').find('input').focus();
		return false;
	}
	var intStopDate=$("#StopDate").datebox("getValue");
	if ((intStopDate)&&(CompareDate(EnableDate,intStopDate))) {
		$.messager.popover({msg:'停用日期不能早于启用日期！',type:'error'});
		$('#StopDate').next('span').find('input').focus();
		return false;
	}
	
	var appArea=$("#InterventionApplyArea").combobox("getValues").join("_");
	var sc=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		MethodName:"SaveIntervention",
		locID:session['LOGON.CTLOCID'],
		userID:session['LOGON.USERID'],
		intRowID:PageLogicObj.m_SelRowId,
		intCode:intCode,
		intTypeID:InterventionType,
		intShortName:intShortName,
		intLongName:InterventionLongName,
		intEnableDate:EnableDate,
		intStopDate:intStopDate,
		//hospitalDR:$HUI.combogrid('#_HospList').getValue(),
		//2758853【护理计划配置】业务界面整合
		hospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		defFreq:defFreq,
		appArea:appArea,
		rowId:""
	},false)
	if (sc>=0){
		$("#InterventionsEditWin").window("close");
		$("#tabInterventionsList").datagrid("reload");
	}else{
		$.messager.alert("提示","保存失败!");
		return false;
	}
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (dtseparator=="-") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (dtseparator=="/") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(dtseparator=="/"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function CompareDate(date1,date2){
	var date1 = myparser(date1);
	var date2 = myparser(date2); 
	if(date2<date1){  
		return true;  
	} 
	return false;
}

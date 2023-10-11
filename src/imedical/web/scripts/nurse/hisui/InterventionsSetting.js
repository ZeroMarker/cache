/**
* @author songchunli
* HISUI ��ʩ����������js
* InterventionSetting.js
*/
var PageLogicObj={
	InterventionApplyArea:[{"id":"1","text":"����"},{"id":"2","text":"��ͯ"},{"id":"3","text":"Ӥ��"},{"id":"4","text":"������"}],
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����

}
$(function(){ 
	//2758853������ƻ����á�ҵ���������
	var iframeflag=""
	if (window.parent.window.PageLogicObj){
		iframeflag=window.parent.window.PageLogicObj.iframeflag
	}
	if(iframeflag=="1"){
		PageLogicObj.iframeflag=iframeflag
		Init();		   			// iframe ����
	}
	else if ((iframeflag== "")||(iframeflag=="0")){
		InitHospList();			// ��������
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
	// ��ʼ�� ״̬��ѯ����
	InitStatus();
	InitQuestionListDataGrid();
}
function InitStatus(){
	$("#status").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:[{"id":"1","text":"����",selected:true},{"id":"0","text":"ͣ��"}],
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
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
				$("#InterventionsEditWin").window('open');
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#tabInterventionsList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				ShowInterventionsWin(row);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
				DeleteInterventions();
            }
        },"-",{
	        text:'��ʩ��������',
	        iconCls: 'icon-set-col',
	        handler:function(){
		        window.parent.window.addiFrametoEditWindow("nur.hisui.interventionstype.csp","��ʩ��������","","");

		    }	        
	    }];
	var Columns=[[    
		{ field: 'intType',title:'��ʩ����',width:120,
			formatter: function(value,row,index){
				var valueArr=value.split("^");
				return valueArr[1]+"("+valueArr[2]+")";
			}
		},
		{ field: 'intCode',title:'��ʩ����',width:100},
		{ field: 'intShortName',title:'��ʩ������',width:350,wordBreak:"break-all"},
		{ field: 'intLongName',title:'��ʩ������',width:350,wordBreak:"break-all"},
		{ field: 'applayArea',title:'������Ⱥ',width:200},
		{ field: 'intStatus',title:'״̬',width:60,
			styler: function(value,row,index){
				if (value =="����"){
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
		loadMsg : '������..',  
		pagination : true, 
		rownumbers : true,
		idField:"intRowID",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
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
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{searchName:$("#SearchDesc").val(),status:status,hospDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowInterventionsWin(rowData);
		},
		//2758853������ƻ����á�ҵ���������
		onClickRow:function(rowIndex, rowData){
			var rowID=rowData.intRowID;
			$(window.parent.$("#iframeInterventionlinktasksetting"))[0].contentWindow.ReloadInterventionLinkTaskList(rowID);	
			
			$(window.parent.$("#iframeInterventionextreport"))[0].contentWindow.ReloadInterventionExtReportList(rowID);	

		}

	})
}
//2758853������ƻ����á�ҵ���������
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
	// ��ʩ���
	InitInterventionType();
	// Ĭ��Ƶ��
	InitInterventionFreq();
	// ������Ⱥ
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
			//2758853������ƻ����á�ҵ���������
			param.hospDR=(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue());
		},loadFilter:function(data){
			// todo �Ż� �ĳ�queryֱ�ӷ�����ʾֵ
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
			//2758853������ƻ����á�ҵ���������
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
	if (applayArea =="ȫ����Ⱥ") applayArea="";
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
		$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
		return false;
	}
	var rowID=selected.intRowID;
	var Msg="ȷ��Ҫɾ��������ʩ������";
		Msg += '</br><sapn style="opacity:0.65;">�˴�ʩ����ɾ���󣬴�ʩ��𽫲����Զ������ô�ʩ����.</sapn>';
	$.messager.confirm('ȷ�϶Ի���', Msg, function(r){
		if (r) {
			var rtn=$.m({
				ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
				MethodName:"DeleteSingleIntervention",
				locID:session['LOGON.CTLOCID'],
				userID:session['LOGON.USERID'], 
				intRowID:rowID
			},false)
			if (rtn !=0) {
				$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
				return false;
			}else{
				var QueIndex=$('#tabInterventionsList').datagrid('getRowIndex',rowID);
				$('#tabInterventionsList').datagrid('deleteRow', QueIndex);
			}
		}
	});
}
// �����ʩ����
function SaveInterventionClick(){
	var intCode=$("#InterventionCode").val();
	var InterventionType=$("#InterventionType").combobox("getValue");
	if (!InterventionType) {
		$.messager.popover({msg:'��ѡ���ʩ���',type:'error'});
		$('#InterventionType').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#InterventionType').combobox("getData"),"id",InterventionType)<0){
		$.messager.popover({msg:'������������ѡ���ʩ���',type:'error'});
		$('#InterventionType').next('span').find('input').focus();
		return false;
	}
	var defFreq=$("#InterventionFreq").combobox("getValue");
	if (!defFreq) {
		$.messager.popover({msg:'��ѡ��Ĭ��Ƶ�Σ�',type:'error'});
		$('#InterventionFreq').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#InterventionFreq').combobox("getData"),"id",defFreq)<0){
		$.messager.popover({msg:'������������ѡ��Ĭ��Ƶ�Σ�',type:'error'});
		$('#InterventionFreq').next('span').find('input').focus();
		return false;
	}
	var intShortName=$("#InterventionShortName").val();
	if (!intShortName) {
		$.messager.popover({msg:'�������ʩ��������',type:'error'});
		$("#InterventionShortName").focus();
		return false;
	}
	var InterventionLongName=$("#InterventionLongName").val();
	if (!InterventionLongName) {
		$.messager.popover({msg:'�������ʩ��������',type:'error'});
		$('#InterventionLongName').focus();
		return false;
	}
	
	var EnableDate=$("#EnableDate").datebox("getValue");
	if (!EnableDate) {
		$.messager.popover({msg:'����д�������ڣ�',type:'error'});
		$('#EnableDate').next('span').find('input').focus();
		return false;
	}
	var intStopDate=$("#StopDate").datebox("getValue");
	if ((intStopDate)&&(CompareDate(EnableDate,intStopDate))) {
		$.messager.popover({msg:'ͣ�����ڲ��������������ڣ�',type:'error'});
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
		//2758853������ƻ����á�ҵ���������
		hospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
		defFreq:defFreq,
		appArea:appArea,
		rowId:""
	},false)
	if (sc>=0){
		$("#InterventionsEditWin").window("close");
		$("#tabInterventionsList").datagrid("reload");
	}else{
		$.messager.alert("��ʾ","����ʧ��!");
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

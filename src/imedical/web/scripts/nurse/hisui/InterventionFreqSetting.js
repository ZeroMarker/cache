/**
* @author songchunli
* HISUI ����Ƶ��������js
*/
var PageLogicObj={
	m_SelFreqId:"",
	m_tabFreqDispeningListGrid:"",
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
	// ��ʼ�� ״̬��ѯ����
	InitInterventionLinkTaskList();
}
function InitInterventionLinkTaskList(){
	var ToolBar = [{
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
				// ��ʼ�� 2021.7.12
				$("#Active").checkbox("setValue",false);
				// ���ѡ��
				$("input[name='AdmType']:checked").each(function(index,data){
					$HUI.checkbox("#"+data.id).setValue(false);
				})
				PageLogicObj.m_SelFreqId="";
				$("#InterventionFreqWin").window('open');
			}
	},{
		text: '�޸�',
		iconCls: 'icon-write-order',
		handler: function() {
			var row = $("#tabInterventionFreqList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
				return false;
			}
			ShowInterventionFreqWin(row);
		}
	},{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var row = $("#tabInterventionFreqList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
				return false;
			}
			$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫɾ������������?', function(r){
				if (r){
					$.m({
						ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
						MethodName:"DeleteInterventionFreq",
						rowID:row.id
					},function(rtn){
						if (rtn ==0){
							$('#tabInterventionFreqList').datagrid("reload");
						}else{
							$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+rtn);
						}
					})
				}
			});	
		}
    }];
	var Columns=[[ 
		{ field: 'code',title:'����',width:100},
		{ field: 'namec',title:'��������',width:150,wordBreak:"break-all"},
		{ field: 'namee',title:'Ӣ������',width:150},
		{ field: 'factor',title:'ϵ��',width:60,},
		{ field: 'activeFlag',title:'�Ƿ񼤻�',width:70,
			formatter: function(value,row,index){
				if (value=="Yes"){
					return "��";
				} else {
					return "��";
				}
			}
		},
		{ field: 'weekFlag',title:'��Ƶ��',width:60,
			formatter: function(value,row,index){
				if (value=="Yes"){
					return "��";
				} else {
					return "��";
				}
			}
		},
		{ field: 'clinicType',title:'��������',width:250},
		{ field: 'disposing',title:'�ַ�ʱ��',width:250}
    ]];
	$('#tabInterventionFreqList').datagrid({  
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
		idField:"id",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryInterventionFreq",
		onBeforeLoad:function(param){
			$.extend(PageLogicObj,{m_SelFreqId:""});
			$('#tabInterventionFreqList').datagrid("unselectAll"); 
			//param = $.extend(param,{codeIn:$("#SearchDesc").val(),active:"",hospicalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������
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

//2758853������ƻ����á�ҵ���������
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
			text: '����',
			iconCls: 'icon-add',
			handler: function() {
				if (!checkDispengTime()) return;
				var time=$("#FreqDispeningTime").timespinner("getValue");
				if (!time){
					$.messager.popover({msg:'��ѡ��ʱ�䣡',type:'error'});
					$("#FreqDispeningTime").focus();
					return false;
				}
				var index=$("#tabFreqDispeningList").datagrid("getRowIndex",time);
				if (index>=0) {
					$.messager.popover({msg:'ʱ���Ѵ��ڣ�',type:'error'});
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
		text: '�޸�',
		iconCls: 'icon-write-order',
		handler: function() {
			var FreqFactor=$("#FreqFactor").val();
			if (!FreqFactor) {
				$.messager.popover({msg:'����ά��ϵ����',type:'error'});
				$("#FreqFactor").focus();
				return false;
			}
			var time=$("#FreqDispeningTime").timespinner("getValue");
			if (!time){
				$.messager.popover({msg:'��ѡ��ʱ�䣡',type:'error'});
				$("#FreqDispeningTime").focus();
				return false;
			}
			var row = $("#tabFreqDispeningList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
				return false;
			}
			var SelIndex=$("#tabFreqDispeningList").datagrid("getRowIndex",row.DispeningTime);
			var index=$("#tabFreqDispeningList").datagrid("getRowIndex",time);
			if ((index>=0)&&(SelIndex!=index)) {
				$.messager.popover({msg:'ʱ���Ѵ��ڣ�',type:'error'});
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
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			if (!checkDispengTime()) return;
			var row = $("#tabFreqDispeningList").datagrid("getSelected");
			if (!row) {
				$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
				return false;
			}
			var index=$("#tabFreqDispeningList").datagrid("getRowIndex",row.DispeningTime);
			$("#tabFreqDispeningList").datagrid("deleteRow",index);
		}
	}];
	var Columns=[[    
		{ field: 'id',checkbox:'true'},
		{ field: 'DispeningTime',title:'�ַ�ʱ��',width:200}
	]];
	PageLogicObj.m_tabFreqDispeningListGrid=$('#tabFreqDispeningList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, 
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false, 
		idField:"DispeningTime",
		columns :Columns, 
		nowrap:false,  /*�˴�Ϊfalse*/
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
	// �������� ��������
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
		$.messager.popover({msg:'����ά��ϵ����',type:'error'});
		$("#FreqFactor").focus();
		return false;
	}
	var rows = $("#tabFreqDispeningList").datagrid("getRows");
	if (rows.length==FreqFactor){
		$.messager.popover({msg:'�ַ�ʱ�����Ӧ����ϵ����',type:'error'});
		return false;
	}
	return true;
}
// ����Ƶ��
function SaveFreqClick(){
	var FreqCode=$("#FreqCode").val();
	var FreqNameE=$("#FreqNameE").val();
	var FreqNameC=$("#FreqNameC").val();
	var FreqFactor=$("#FreqFactor").val();
	if ((!FreqCode)||(!FreqNameE)||(!FreqNameC)||(!FreqFactor)){
		$.messager.popover({msg:'������Ϣδ��дȫ��',type:'error'});
		return false;
	}
	var DispensingTimeStr="";
	var rows = $("#tabFreqDispeningList").datagrid("getRows");
	if (rows.length !=FreqFactor){
		$.messager.popover({msg:'�ַ�ʱ�����Ӧ����ϵ����',type:'error'});
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
		//2758853������ƻ����á�ҵ���������
		hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},false)
	if (Json.errcode ==0){
		$("#InterventionFreqWin").window("close");
		$("#tabInterventionFreqList").datagrid("reload");
	}else{
		$.messager.alert("��ʾ","����ʧ��!"+Json.errinfo);
		return false;
	}
}

// ��ȡ��ǰѡ�е�����
function GetTyteList()
{
	var str="";
	$("input[name='AdmType']:checked").each(function(){
		str += (str==""?"":"") + $(this).val();
	})
	return str;
}

// ���ó�ʼ��������
function SetTypeList(valueStr)
{
	// ���ѡ��
	$("input[name='AdmType']:checked").each(function(index,data){
		$HUI.checkbox("#"+data.id).setValue(false);
	})
	
	// ���ݿ�������
	var checkArray = [];
	for (var j=0;j<valueStr.length;j++)
	{
		var str = valueStr[j]
		checkArray.push(str)
	}
	
	//������еĸ�ѡ�����
	var checkBoxAll = $("input[name='AdmType']");
	for(var i=0;i<checkArray.length;i++){
	 //��ȡ���и�ѡ������value���ԣ�Ȼ����checkArray[i]������ƥ�䣬����У���˵����Ӧ��ѡ��
	 $.each(checkBoxAll,function(j,checkbox){
		 //��ȡ��ѡ���value����
		 var checkValue=$(checkbox).val();
		 if(checkArray[i]==checkValue){
			 $HUI.checkbox("#"+checkbox.id).setValue(true);
		 }
	 });
 	};
}
//2758853������ƻ����á�ҵ���������
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
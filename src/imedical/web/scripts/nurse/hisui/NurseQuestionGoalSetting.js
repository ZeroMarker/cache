/**
* @author songchunli
* HISUI Ŀ������������js
* NurseQuestionGoalSetting.js
*/

var PageLogicObj={
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
	selectQueRowID:""
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
	InitQuestionGoalEditWin();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQuestionGoalList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabQuestionGoalList").datagrid("reload");
		}
	});
	$("#BSaveQuestionGoal").click(SaveQuestionGoalClick);
	$("#BCancel").click(function(){
		$("#QuestionGoalEditWin").window('close');
	});
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_Goal");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabQuestionGoalList").datagrid("load");
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
		data:[{"id":"1","text":"����"},{"id":"0","text":"ͣ��"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabQuestionGoalList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabQuestionGoalList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabQuestionGoalList").datagrid("load");
		}
	});
}
function ReloadQuestionGoalListDataGrid(rowID){
	$("#QuestionGoalEditWin").window("close");	
	$('#tabQuestionGoalList').datagrid('reload',{keyword:$("#SearchDesc").val(),statusIn:status,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),SearchQuestionDR:rowID})	
	PageLogicObj.selectQueRowID=rowID
}
//2758853������ƻ����á�ҵ���������
function ResetQuestionGoalEditWin(){
	var innerHeight = window.innerHeight;
	var innerWidth= window.innerWidth;
	if (PageLogicObj.iframeflag=="1"){
		$("#QuestionGoalEditWin").parent().css({
			width:innerWidth,
		});
		$("#QuestionGoalEditWin").parent().find(".panel-header").css({
			width:innerWidth,
		});
		$("#QuestionGoalEditWin").css({
			height:innerHeight-38,
			width:innerWidth,
		});
		$("#quesion-layout").layout("resize",{width:innerWidth,height:innerHeight-38});
		$("#quesion-layout").layout("resize").layout('panel', 'center').panel('resize', {
	        width: innerWidth-20,
    	});
    	$("#divQuestionGoalEdit").css({
	    	height:$("#QuestionGoalEditWin").height()-50-90-30,    //�ڸ� - (panel-north) - (panel-south) - "����Ŀ��"
	    	width: innerWidth-20,
	    });
    	$("#tabQuestionGoalEdit").datagrid("resize",{width:'96%',height:'96%'});

    }
}
function InitQuestionListDataGrid(){
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	            // ������������  ������л��� 2021.7.5
	            InitQuestion();	
				//2758853������ƻ����á�ҵ���������
				if (PageLogicObj.iframeflag=="1"){
					ResetQuestionGoalEditWin();
					var qrow =$(window.parent.$("#iframeQuestion"))[0].contentWindow.$("#tabQuestionList").datagrid("getSelected");
					if (!qrow){
						$.messager.popover({msg:'��ѡ��һ���������⣡',type:'error'});
						return false;
					}
					$('#Question').combobox('select',qrow.rowID);
					$('#tabQuestionGoalEdit').datagrid("load");
					$("#QuestionGoalEditWin").window('open');	
					/*
					var row = $("#tabQuestionGoalList").datagrid('getRows')[0];
					if (row) {
						ShowQuestionGoalSelWin(row);	
					}else{
						$('#Question').combobox('select',qrow.rowID);
						$('#tabQuestionGoalEdit').datagrid("load");
						$("#QuestionGoalEditWin").window('open');						
					}
					*/				
				}
				else{									
					$("#QuestionGoalEditWin").window('open');
				}
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#tabQuestionGoalList").datagrid("getSelected");
				if (!row) {
					$.messager.popover({msg:'��ѡ����Ҫ�޸ĵļ�¼��',type:'error'});
					return false;
				}
				ResetQuestionGoalEditWin();
				ShowQuestionGoalSelWin(row);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQuestionGoalList").datagrid("getSelected");
				if (!selected) {
					$.messager.popover({msg:'��ѡ����Ҫɾ���ļ�¼��',type:'error'});
					return false;
				}
				$.messager.confirm('��ʾ',"ȷ��Ҫɾ������������?",function(r){   
					if (r){
						if (DeleteQuestionGoal(selected.rowID)){
							var QueIndex=$('#tabQuestionGoalList').datagrid('getRowIndex',selected.rowID);
							$('#tabQuestionGoalList').datagrid('deleteRow', QueIndex);
						}
					}
				}); 
            }
        }];
	var Columns=[[    
		{ field: 'questionCode',title:'�������',width:100},
		{ field: 'questionDesc',title:'��������',width:250,wordBreak:"break-all"},
		{ field: 'goalCode',title:'Ŀ�����',width:150},
		{ field: 'goalDesc',title:'����Ŀ��',width:380,wordBreak:"break-all"},
		{ field: 'applayArea',title:'������Ⱥ',width:240},
		{ field: 'status',title:'״̬',width:60,
			styler: function(value,row,index){
				if (value =="����"){
					return "color:#3FBD79;"
				}else{
					return "color:#F16E57;"
				}
			}
		}
    ]];
	$('#tabQuestionGoalList').datagrid({  
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
		idField:"rowID",
		pageSize: 15,
		pageList : [15,25,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestionGoal",
		onBeforeLoad:function(param){
			try{
				var qRowId=window.parent.window.iframeQuestion.PageLogicObj.m_SelRowId;
			}catch(err){
				qRowId=""
			}
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="";
			}
			PageLogicObj.m_SelRowId="";
			$('#tabQuestionGoalList').datagrid("unselectAll");
			//param = $.extend(param,{keyword:$("#SearchDesc").val(),statusIn:status,hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{keyword:$("#SearchDesc").val(),statusIn:status,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),SearchQuestionDR:qRowId});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowQuestionGoalSelWin(rowData);
		},
		onLoadSuccess:function(){
			//2758853������ƻ����á�ҵ���������
			if(PageLogicObj.iframeflag=="1"){
				$('#tabQuestionGoalList').datagrid("hideColumn", "questionCode");
				$('#tabQuestionGoalList').datagrid("hideColumn", "questionDesc");
				
			}
		}
	})
}
function InitEditWindow(){
    $("#QuestionGoalEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
			SetQuestionGoalEditWinData();
	   }
	});
}
function InitQuestionGoalEditWin(){
	// ����������
	InitQuestion();
	InittabQuestionGoalEdit();
}
function InitQuestion(){
	$('#Question').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion&ResultSetType=array&rows=99999",
		valueField:'rowID',
		textField:'shortName',
		mode: "remote",
		onBeforeLoad: function(param){
			var desc=param["q"];
			if (!desc) desc=""
			//param = $.extend(param,{keyword:desc,statusIn:"1",hospitalID:$HUI.combogrid('#_HospList').getValue()});
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{keyword:desc,statusIn:"1",hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		
		},
		onSelect:function(rec){
			if (rec) {
				$("#QuestionCode").val(rec.queCode);
				$('#tabQuestionGoalEdit').datagrid("load");
			}
		},
		onChange:function(newValue, oldValue){
			if (!newValue){
				$("#QuestionCode").val("");
				$('#tabQuestionGoalEdit').datagrid("load");
			}
		}
    });
}
function InittabQuestionGoalEdit(){
	var ToolBar = [{
		id:"QuesGoalAdd",
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var Question=$("#Question").combobox("getValue");
			if (!Question) {
				$.messager.popover({msg:'��ѡ�������⣡',type:'error'});
				$('#Question').next('span').find('input').focus();
				return false;
			}else if($.hisui.indexOfArray($('#Question').combobox("getData"),"rowID",Question)<0){
				$.messager.popover({msg:'������������ѡ�������⣡',type:'error'});
				$('#Question').next('span').find('input').focus();
				return false;
			}
			var Len=$("#tabQuestionGoalEdit").datagrid("getRows").length;
			$("#tabQuestionGoalEdit").datagrid("insertRow",{
				index: Len,
				row: {
					rowID:"",
					enableDate:ServerObj.CurrentDate
				}
			});
			$("#tabQuestionGoalEdit").datagrid("beginEdit", Len);
			var Editors=$('#tabQuestionGoalEdit').datagrid("getEditors",Len);
			$(Editors[0].target).focus();
		}
	}];
	var Columns=[[    
		{ field: 'goalCode',title:'Ŀ�����',width:130},
		{ field: 'goalDesc',title:'����Ŀ��',width:330,wordBreak:"break-all",
			editor:{
				type:'text'
			}
		},
		{ field: 'applayAreaId',title:'��Ӧ��Ⱥ',width:150,wordBreak:"break-all", 
			editor:{
				type:'combobox',
				options:{
					valueField:'id',
					textField:'text',
					multiple:true,
					method:'local',
					data:[{"id":"1","text":"����"},{"id":"2","text":"��ͯ"},{"id":"3","text":"Ӥ��"},{"id":"4","text":"������"}]
				}
			},
			formatter: function(value,row,index){
				return row.applayArea;
			}
		},
		{ field: 'enableDate', title: '��������',width:160,
			editor:{
				type:'dateboxq'
			}
		},
		{ field: 'stopDate', title: 'ͣ������',width:160,
			editor:{
				type:'dateboxq'
			}
		},
		{ field: 'Action', title: '����',
			formatter:function(value,row,index){
				var d = "<a href='#' onclick='DeleteRow(this)'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/></a>";
				return d;
			}
		}
	]];
	$('#tabQuestionGoalEdit').datagrid({  
		fit : true,
		//width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		//fitColumns : false, 
		//autoRowHeight : false,
		fitColumns : (PageLogicObj.iframeflag=="1"? true:false), 
		autoRowHeight : (PageLogicObj.iframeflag=="1"? true:false),		
		loadMsg : '������..',  
		pagination : false, 
		rownumbers : false, 
		idField:"rowID",
		columns :Columns, 
		toolbar:ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestionGoalByQID&rows=99999",
		onBeforeLoad:function(param){
			$('#tabQuestionGoalEdit').datagrid("unselectAll");
			var questionID=$('#Question').combobox("getValue");
			param = $.extend(param,{questionID:questionID});
		},
		onDblClickRow:function(rowIndex, rowData){
			$("#tabQuestionGoalEdit").datagrid("beginEdit", rowIndex);
			var Editors=$('#tabQuestionGoalEdit').datagrid("getEditors",rowIndex);
			$(Editors[0].target).focus();
		}
	}) 
}
function ShowQuestionGoalSelWin(row){
	$("#QuestionCode").val(row.questionCode);
	$("#Question").combobox("select",row.questionID).combobox("disable");
	if ($.hisui.indexOfArray($("#Question").combobox("getData"),"rowID",row.questionID)<0) {
		$("#Question").combobox("setText",row.questionDesc);
		$('#tabQuestionGoalEdit').datagrid('load',{
			questionID: row.questionID
		})
		// $("#QuesGoalAdd,#BSaveQuestionGoal").linkbutton('disable');
		$("#BSaveQuestionGoal").linkbutton('disable');
	}else{
		$("#QuesGoalAdd,#BSaveQuestionGoal").linkbutton('enable');
	}
	$("#QuestionGoalEditWin").window('open');
}
function SetQuestionGoalEditWinData(){
	PageLogicObj.m_SelRowId="";
	$("#QuestionCode").val("");
	$("#Question").combobox("setValue","").combobox("enable");
	$("#tabQuestionGoalEdit").datagrid("rejectChanges");
}
function DeleteRow(target){
	var Msg="ȷ��ɾ���û���������";
		Msg += '</br><sapn style="opacity:0.65;">�˻���Ŀ��ɾ���󣬻������⽫�����Զ������û���Ŀ��.</sapn>';
	$.messager.confirm('��ʾ', Msg, function(r){
		if (r) {
			var tr = $(target).closest('tr.datagrid-row');
			var index=parseInt(tr.attr('datagrid-row-index'));
			var rows=$('#tabQuestionGoalEdit').datagrid('getRows'); //tabQuestionList
			var rowID=rows[index].rowID;
			if (rowID) {
				if (DeleteQuestionGoal(rowID)){
					var QueIndex=$('#tabQuestionGoalEdit').datagrid('getRowIndex',rowID);
					$('#tabQuestionGoalEdit').datagrid('deleteRow', QueIndex);
					var QueIndex=$('#tabQuestionGoalList').datagrid('getRowIndex',rowID);
					if (QueIndex>=0){
						$('#tabQuestionGoalList').datagrid('deleteRow', QueIndex);
					}
				}
			}else{
				$('#tabQuestionGoalEdit').datagrid('deleteRow', index);
			}
		}
	});
}
function DeleteQuestionGoal(rowID){
	var rtn=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"DeleteQuestionGoal",
		goalID:rowID,
		optID:session['LOGON.USERID']
	},false)
	if (rtn !=0) {
		$.messager.popover({msg:'ɾ��ʧ�ܣ�',type:'error'});
		return false;
	}else{
		return true;
	}
}
// ��������Ŀ������
function SaveQuestionGoalClick(){
	if ($("#BSaveQuestionGoal").hasClass('l-btn-disabled')){
		return false;
	}
	var Question=$("#Question").combobox("getValue");
	if (!Question) {
		$.messager.popover({msg:'��ѡ�������⣡',type:'error'});
		$('#Question').next('span').find('input').focus();
		return false;
	}else if($.hisui.indexOfArray($('#Question').combobox("getData"),"rowID",Question)<0){
		$.messager.popover({msg:'������������ѡ�������⣡',type:'error'});
		$('#Question').next('span').find('input').focus();
		return false;
	}
	var dataArray=new Array();
	var rows=$("#tabQuestionGoalEdit").datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		var rowID=rows[i].rowID;
		if (!rowID) rowID="";
		var Editors=$('#tabQuestionGoalEdit').datagrid("getEditors",i);
		if (Editors.length >0){
			var goalDesc=$(Editors[0].target).val();
			if (!goalDesc) {
				$.messager.popover({msg:'�����뻤��Ŀ�꣡',type:'error'});
				$(Editors[0].target).focus()
				return false;
			}
			var applayArea=$(Editors[1].target).combobox("getValues").join("_");
			var EnableDate=$(Editors[2].target).dateboxq('getValue');
			var StopDate=$(Editors[3].target).dateboxq('getValue');
			if (!EnableDate) {
				$.messager.popover({msg:'�������ڲ���Ϊ�գ�',type:'error'});
				$(Editors[2].target).focus();
				return false;
			}
			if ((StopDate)&&(CompareDate(EnableDate,StopDate))){
				$.messager.popover({msg:'��ֹ���ڲ��������������ڣ�',type:'error'});
				$(Editors[3].target).focus();
				return false;
			}
		}else{
			var goalDesc=rows[i].goalDesc;
			var applayArea=rows[i].applayAreaId;
			var EnableDate=rows[i].enableDate;
			var StopDate=rows[i].stopDate;
		}
		dataArray.push([
			rowID,
			Question,
			goalDesc,
			session['LOGON.CTLOCID'],
			EnableDate,
			StopDate,
			session['LOGON.USERID'],
			applayArea
		]);
	}
	if (dataArray.length ==0){
		$.messager.popover({msg:'û����Ҫ��������ݣ�',type:'error'});
		return false;
	}
	var sc=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"BatchInsertQuestionGoal",
		dataArrays:JSON.stringify(dataArray),
		//hospitalId:$HUI.combogrid('#_HospList').getValue(),
		//2758853������ƻ����á�ҵ���������
		hospitalId:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())
	},false)
	if (sc>=0){
		$("#QuestionGoalEditWin").window("close");
		$("#tabQuestionGoalList").datagrid("reload");
	}else{
		$.messager.popover({msg:'����ʧ��!'+sc,type:'error'});
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
	if(date2<=date1){  
		return true;  
	} 
	return false;
}

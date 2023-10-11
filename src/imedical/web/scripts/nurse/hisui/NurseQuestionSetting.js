/**
* HISUI ����������js
* @author songchunli
* NurseQuestionSetting.js
*/
var PageLogicObj={
	m_SelRowId:"", //�����¼ѡ����ID
	m_WardJson:"",
	iframeflag:"0", //2758853������ƻ����á�ҵ���������  �Ƿ���iframe ����  1���ǣ� 0����
	iframeOnMax:'0', //2758853������ƻ����á�ҵ���������  �Ƿ���iframe��� 1���ǣ� 0����
	CopyFlag:'0'     //�Ƿ��ƻ�������
}

//2758853������ƻ����á�ҵ���������
var $parent = self.parent.$;
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
	InitQuestionEditWinWin();
})
function InitEvent(){
 	$("#BFind").click(function(){
	 	$("#tabQuestionList").datagrid("reload");
	});
	$("#SearchDesc").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			$("#tabQuestionList").datagrid("reload");
		}
	});
	$("#BSaveQuestion").click(SaveQuestionClick);
	$("#BCancel").click(function(){
		$("#QuestionEditWin").window('close');
		PageLogicObj.CopyFlag='0';

	});
	
	// ��ʼ��������Ϸ���
	//$("tr[id=QuestionCategoryTR]").hide();
}
function InitHospList(){
	var hospComp = GenHospComp("Nur_IP_Question");
	hospComp.jdata.options.onSelect = function(e,t){
		$("#SearchDesc").val("");
		$("#tabQuestionList").datagrid("load");
		// ���÷�Χ
		InitQuestionApplyArea()
		// ����������
		InitMainQuestion();
		// �������
		InitQuestionType();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}
function Init(){
	// ��ʼ�� ״̬��ѯ����
	InitStatus();
	// ��ʼ�� �Ƿ����ɻ��� ��ѯ����
	InitIsNurAd();
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
				$("#tabQuestionList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabQuestionList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabQuestionList").datagrid("load");
		}
	});
	//Ĭ�Ϲ�ѡ�����á�
	$("#status").combobox('setValue',"1");
}
function InitIsNurAd(){
	$("#IsNurAd").combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		data:[{"id":"Y","text":"��"},{"id":"N","text":"��"}],
		onSelect:function(rec){
			if (rec) {
				$("#tabQuestionList").datagrid("load");
			}
		},
		onUnselect:function(rec){
			$("#tabQuestionList").datagrid("load");
		},
		onAllSelectClick:function(e){
			$("#tabQuestionList").datagrid("load");
		}
	});
}
//2758853������ƻ����á�ҵ���������
function ReloadQuestionListDataGrid(){
	$("#QuestionEditWin").window('close'); //�������3085086
	//$('#tabSubQuestionEdit').datagrid("load");//�������3085111			
	$('#tabQuestionList').datagrid('load',{keyword:$("#SearchDesc").val(),statusIn:status,IsNurAd:IsNurAd,hospitalID:window.parent.$HUI.combogrid('#_HospList').getValue()})
	$("#SearchDesc").val('');
	$("#IsNurAd").combobox('setValue', '');
	$("#status").combobox('setValue', '');
	
	
}

function InitQuestionListDataGrid(){
	var ToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() {
	            // �ⲿ���� ������Ϸ���
	            $("tr[id=QuestionCategoryTR]").hide();
				SetQuestionEditWinData();
				$(".main-question-tr,.sub-question-tr").hide();
				$('#QuestionEditWin').panel('resize',{
					height: 110
				});
				$("#quesion-layout").layout('panel', 'north').panel("resize",{height:90});
				$("#quesion-layout").layout('panel', 'center').panel("resize",{height:0});
				$('#QuestionEditWin').window("center");	//�������3085047
				$("#QuestionEditWin").window('open');							
            }
        },{
            text: '�޸�',
            iconCls: 'icon-write-order',
            handler: function() {
	            var row = $("#tabQuestionList").datagrid("getSelected");
				if (!row) {
					$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼��");
					return false;
				}
				SetQuestionEditWinData(); //�������	3084657
				ShowQuestionSelWin(row);
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var selected = $("#tabQuestionList").datagrid("getSelected");
				if (!selected) {
					$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼��");
					return false;
				}
				var rowID=selected.rowID;
				var parentID=selected.parentID;
				var Msg="ȷ��ɾ���û���������";
				if (parentID ==-1) {
					Msg += '</br><sapn style="opacity:0.65;">�û�������Ϊ�����⣬���������⽫��һ��ɾ��.</sapn>';
				}
				$.messager.confirm('��ʾ',Msg,function(r){   
					if (r){
						DeleteQuestion(rowID);
					}
				}); 
            }
        },{
	        text: '����',
	        iconCls: 'icon-copy',
	        handler: function() {
		        
			    var row = $("#tabQuestionList").datagrid("getSelected");
				if (!row) {
					$.messager.alert("��ʾ","��ѡ����Ҫ���Ƶļ�¼��");
					return false;
				}
				PageLogicObj.CopyFlag=row.rowID;			
				ShowQuestionSelWin(row);
		    }
	    },"-",{
		    id:"nursequestionType",
		   	text: '�ֶ��������',
	        iconCls: 'icon-set-col',
	        handler: function() {
		        PageLogicObj.CopyFlag='0';
		        window.parent.window.addiFrametoEditWindow("nur.hisui.nursequestionType.csp");
		    }
		    
	    }];
	//rowID:%String:hidden,careTypeT:%String:��Ϸ���,careTypeV:%String:hidden,queCode:%String:�������,shortName:%String:��������,
	// longName:%String:���ⶨ��,IsNursingAdvice:%String:�Ƿ����ɻ���,applyArea:%String:���÷�Χ,status:%String:״̬,
	//parentID:%String:hidden,enableDate:%String:hidden,stopDate:%String:hidden,queTypeDr:%String:hidden,queTypeDesc:%String:hidden
	
	//2758853������ƻ����á�ҵ���������	
	//����˳�򣬴�������˳�����Ϊ����š�������롢�������⡢������ࡢ���ⶨ�塢�Ƿ����ɻ��������÷�Χ��״̬  
	var Columns=[[    
		
		{ field: 'queCode',title:'�������',width:95},
		{ field: 'shortName',title:'��������',width:230,wordBreak:"break-all"},
		//{ field: 'careTypeT',title:'�������',width:200,wordBreak:"break-all"},  �������	3084788
		{ field: 'careTypeT',title:'��Ϸ���',width:200,wordBreak:"break-all"},
		{ field: 'longName',title:'���ⶨ��',width:230,wordBreak:"break-all"},
		{ field: 'IsNursingAdvice',title:'�Ƿ����ɻ���',width:100,
			formatter: function(value,row,index){
				if (value =="Y") return "��";
				else return "��";
			}
		},
		{ field: 'applyAreaDescStr',title:'���÷�Χ',width:200,wordBreak:"break-all",
			formatter: function(value,row,index){
				value=eval("("+value+")").join("��");
				if (!value) value="ȫԺ";
				return value;
			}
		},
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
	$('#tabQuestionList').datagrid({  
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
		pageList : [15,50,100,200],
		columns :Columns,
		toolbar :ToolBar,
		autoRowHeight:true,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion",
		onBeforeLoad:function(param){
			var status=$("#status").combobox('getValues');
			if (status.length ==1){
				status=status.join("");
			}else{
				status="";
			}
			var IsNurAd=$("#IsNurAd").combobox('getValues');
			if (IsNurAd.length ==1){
				IsNurAd=IsNurAd.join("");
			}else{
				IsNurAd="";
			}
			PageLogicObj.m_SelRowId="";
			$('#tabQuestionList').datagrid("unselectAll");
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{keyword:$("#SearchDesc").val(),statusIn:status,IsNurAd:IsNurAd,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onDblClickRow:function(rowIndex, rowData){
			ShowQuestionSelWin(rowData);
		},
		//2758853������ƻ����á�ҵ���������
		onClickRow:function(rowIndex, rowData){			
			var rowID=rowData.rowID;
			PageLogicObj.m_SelRowId=rowData.rowID;
			$(window.parent.$("#iframeQlassess"))[0].contentWindow.ReloadQLAssessListDataGrid(rowID);			
			$(window.parent.$("#iframeQuestionGoal"))[0].contentWindow.ReloadQuestionGoalListDataGrid(rowID);			
			$(window.parent.$("#iframeInterventions"))[0].contentWindow.ReloadQLInterventionListDataGrid(rowID);		
			$(window.parent.$("#iframeQlRelate"))[0].contentWindow.ReloadQLRelateFactorListDataGrid(rowID);	
		
		},
		onLoadSuccess:function(){
			PageLogicObj.CopyFlag='0';
			if(PageLogicObj.iframeflag!="1"){
				$("#nursequestionType").hide();
			}
		}
	})
}
function InitEditWindow(){
	$("#QuestionEditWin" ).window({
	   modal: true,
	   collapsible:false,
	   minimizable:false,
	   maximizable:false,
	   closed:true,
	   onClose:function(){
		   $('#QuestionEditWin').panel('resize',{
				width: 345,
				height: 177
			});
			$('#QuestionEditWin').window("center");	
			SetQuestionEditWinData();
	   }
	});
}
function InitQuestionEditWinWin(){
	// ��Ϸ���
	InitQuestionCategory();
	// ����㼶
	InitQuestionLevel();
	// ���÷�Χ
	InitQuestionApplyArea()
	// ����������
	InitMainQuestion();
	// �������
	InitQuestionType();
	InittabSubQuestionEdit();
	$("#IsHandle").checkbox({
		onCheckChange:function(	e,value){
			$("label[for=QuestionType]").removeClass("clsRequired");
			if (value) {
				$("label[for=QuestionType]").addClass("clsRequired");
			}
			$("#QuestionType").combobox("setValue","");
			$('#QuestionType').next('span').find('input').focus();
		}
	})
}
function InitQuestionCategory(){
	$('#QuestionCategory').combobox({
		url:$URL+"?ClassName=Nur.NIS.Common.QueryBrokerNew&MethodName=GetOptionOfProperty&className=CF.NUR.NIS.Question&propertyName=NQCareType",
		valueField:'value',
		textField:'text',
		mode: "remote",
		editable:false,
		onLoadSuccess:function(){
			var data=$('#QuestionCategory').combobox("getData");
			//$('#QuestionCategory').combobox("setValue",data[0].value);
		}
	});
}
function InitQuestionLevel(){
	$('#QuestionLevel').combobox({
		valueField:'id',
		textField:'text',
		mode: "local",
		editable:false,
		data:[{"id":"1", "text":"������"},{"id":"2", "text":"������"}],
        onSelect:function(rec){
			QuestionLevelChange(rec.id);
			if (rec.id == "2")
			{
				$("#MainQuestion").combobox({
					disabled:false
				});
				// ���������� ���²�ѯ ������л���  2021.7.5
				InitMainQuestion();
				
				// ������������Ϸ���
				$("#QuestionCategory").combobox("disable");
				$("tr[id=QuestionCategoryTR]").show();
        	}else
        	{
	        	$("#QuestionCategory").combobox("enable");
	        	$("tr[id=QuestionCategoryTR]").show();	
	        }
	    }
	});
}
function InitQuestionApplyArea(){
   $('#QuestionApplyArea').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&bizTable=Nur_IP_Question&rows=99999&ResultSetType=array",
		valueField:'wardid',
		textField:'warddesc',
		multiple:true,
		mode: "remote",
		onBeforeLoad: function(param){
			$(this).combobox("clear");
			//param = $.extend(param,{desc:param["q"],hospid:PageLogicObj.HospID||(window.parent.$HUI.combogrid('#_HospList').getValue())});
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{desc:param["q"],hospid:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		}
    });
}
function InitMainQuestion(){
	$('#MainQuestion').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion&ResultSetType=array&rows=99999",
		valueField:'rowID',
		textField:'shortName',
		mode: "remote",
		onBeforeLoad: function(param){
			var desc=param["q"];
			if (!desc) desc=""
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{keyword:desc,statusIn:"",hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onSelect:function(rec){
			if (rec) {
				$('#tabSubQuestionEdit').datagrid("load");
			}
		},
		onChange:function(newValue, oldValue){
			if (!newValue){
				showSubAddBtn();
				$('#tabSubQuestionEdit').datagrid("load");
			}
		},
		loadFilter:function(data){
            // ֻ���������⡢ͣ������Ҳ��Ҫ���˵� 2021.7.5
            for(var i = 0; i < data.length; i++){
                if(data[i].parentID != "-1" || data[i].status == "ͣ��"){
                    data.splice(i,1);
                    i--;
                }
            }
            return data;
         }
    });
}
function InitQuestionType(){
	$('#QuestionType').combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestionType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		mode: "remote",
		onBeforeLoad: function(param){
			var desc=param["q"];
			if (!desc) desc="";
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{name:desc,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		}
    });
}
function InittabSubQuestionEdit(){
	var ToolBar = [{
		id:'newSubAdd',
		text: '����',
		iconCls: 'icon-add',
		handler: function() {
			var MainQuestion=$("#MainQuestion").combobox("getValue");
			if (!MainQuestion) {
				$.messager.popover({msg:'��ѡ�������⣡',type:'error'});
				$('#MainQuestion').next('span').find('input').focus();
				return false;
			}else if($.hisui.indexOfArray($('#MainQuestion').combobox("getData"),"rowID",MainQuestion)<0){
				$.messager.popover({msg:'������������ѡ�������⣡',type:'error'});
				$('#MainQuestion').next('span').find('input').focus();
				return false;
			}
			$("#tabSubQuestionEdit").datagrid("appendRow", {enableDate:ServerObj.CurrentDate});
			var rows=$("#tabSubQuestionEdit").datagrid("getRows");
			$("#tabSubQuestionEdit").datagrid("beginEdit", rows.length-1);
			var Editors=$('#tabSubQuestionEdit').datagrid("getEditors",rows.length-1);
			$(Editors[0].target).focus();
		}
	}];
	var Columns=[[  
		{ field: 'queCode',title:'�������',width:95},
		{ field: 'shortName',title:'��������',width:130,wordBreak:"break-all",
			editor:{
				type:'text'
			}
		},
		{ field: 'longName',title:'���ⶨ��',width:130,wordBreak:"break-all",
			editor:{
				type:'text'
			}
		},
		{ field: 'applyArea',title:'���÷�Χ',width:120,wordBreak:"break-all", 
			formatter: function(value,row,index){
				if (value){
					var applyAreaDescStr=eval("("+row.applyAreaDescStr+")").join("��");
					if (!applyAreaDescStr) applyAreaDescStr="ȫԺ";
					return applyAreaDescStr;
				}
			},
			editor:{
				type:'combobox',
				options:{
					url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew&ResultSetType=array",
					valueField:'wardid',
					textField:'warddesc',
					multiple:true,
					method:'remote',
					onBeforeLoad:function(param){
						$(this).combobox("clear");
						//2758853������ƻ����á�ҵ���������
						param = $.extend(param,{desc:param["q"],bizTable:"Nur_IP_Question",hospid:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
					}
				}
			}
		},
		{ field: 'IsNursingAdvice',title:'�Ƿ����ɻ���',width:100,align:'center',
			formatter: function(value,row,index){
				if (value =="Y") return "��";
				else return "��";
			},
			editor:{
				type:'icheckbox',options:{
					on:'Y',
					off:'N'
				}
			}
		},
		{ field: 'enableDate', title: '��������',width:110,
			editor:{
				type:'dateboxq'
			}
		},
		{ field: 'stopDate', title: 'ͣ������',width:110,
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
	$('#tabSubQuestionEdit').datagrid({  
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
		idField:"rowID",
		columns :Columns, 
		toolbar:ToolBar,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionSetting&QueryName=QueryQuestion&rows=99999",
		onBeforeLoad:function(param){
			$('#tabSubQuestionEdit').datagrid("unselectAll");
			var PID=$('#MainQuestion').combobox("getValue");
			if (!PID) {
				$('#tabSubQuestionEdit').datagrid("loadData",[]);
				return false;
			}else{
				if (PageLogicObj.m_SelRowId) {
					var QueIndex=$("#tabQuestionList").datagrid("getRowIndex",PageLogicObj.m_SelRowId);
					var QueRows=$("#tabQuestionList").datagrid("getRows");
					// �˴������ö�����,������$.extend����QueRows[QueIndex]�����ڵ�applyAreaһ���޸�
					var AppendObj=jQuery.extend(true, {}, QueRows[QueIndex]);
					$.extend(AppendObj,{applyArea:(eval("("+AppendObj.applyArea+")").join(","))});
					$('#tabSubQuestionEdit').datagrid("appendRow",AppendObj).datagrid("beginEdit", 0);
					var Editors=$('#tabSubQuestionEdit').datagrid("getEditors",0);
					$(Editors[0].target).focus();
					$('#tabSubQuestionEdit').datagrid("hideColumn","Action");
					setTimeout(function(){ 
						var applyAreaDescStr=eval("("+AppendObj.applyAreaDescStr+")").join("��");
						$(Editors[2].target).combobox("setText",applyAreaDescStr);				
					},100)
					return false;
				}
			}
			// ��ѯ�������µ������⣬���ܴ�������࣬������ķ����Ǹ��������ߵ� 2021.7.9
			var careTypeIn= "" //$('#QuestionCategory').combobox("getValue");
			//2758853������ƻ����á�ҵ���������
			param = $.extend(param,{keyword:"",PID:PID,careTypeIn:careTypeIn,hospitalID:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue())});
		},
		onLoadSuccess:function(data){
			// ���������⣬ѡ�������⣬ˢ�µ�ǰ��Ϸ��� 2021.7.10
			var PID = $('#MainQuestion').combobox("getValue");
			if (PageLogicObj.m_SelRowId == "" && PID != "") {
				//ͬ�������෽�� ,������ʹ��
				refreshCareTypeById(PID)
			}
		}
	})
}

function refreshCareTypeById(queId)
{
	var retType = $m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"GetCareTypeByRowId",
		rowId:queId
	},false);
	if (retType)
	{
		$('#QuestionCategory').combobox("setValue",retType);
	}	
}
function ShowQuestionSelWin(row){
	
	$("#QuestionCategory").combobox("select",row.careTypeV);
	$("#QuestionCategory,#QuestionLevel,#MainQuestion").combobox("enable");
	PageLogicObj.m_SelRowId=row.rowID;
	var parentID=row.parentID;
	var subQuestionFlag = 0
	if (parentID ==-1) { //ѡ��������
		$("#QuestionLevel").combobox("select",1).combobox("disable");
		$("#QuestionCode").val(row.queCode);
		$("#Question").val(row.shortName);
		$("#QuestionLongName").val(row.longName);
		$("#QuestionApplyArea").combobox("setValues",eval("("+row.applyArea+")"));
		$("#IsNursingAdvice").checkbox("setValue",row.IsNursingAdvice=="Y"?true:false);
		$("#QuestionType").combobox("select",row.queTypeDr);
		if (!row.queTypeDr) {
			$("#IsHandle").checkbox("setValue",false);
		}
		$("#StDate").datebox("setValue",row.enableDate);
		$("#EndDate").datebox("setValue",row.stopDate);
	}else{
		subQuestionFlag = 1
		$("#QuestionLevel").combobox("select",2);
		$("#MainQuestion").combobox("select",row.parentID);
		$("#QuestionCategory,#QuestionLevel,#MainQuestion").combobox("disable");
		//�������3085111
		$('#tabSubQuestionEdit').datagrid('loadData',{total:0,rows:[]})
		$('#tabSubQuestionEdit').datagrid("reload");			
	}

	// ˢ����Ϸ���
	if (row.rowID && row.rowID != "")
	{
		// test 2021.7.10
		refreshCareTypeById(row.rowID)
	}
	
	// �����޸��������
	$("#QuestionCategory").combobox("disable");
	
	$("#QuestionEditWin").window('open');

	
	// �޸Ļ���˫����� --ֻ�������⣬����������
	// ������ ��Ҫ����������ť
	if (subQuestionFlag == "1" && row.rowID && row.rowID != "0")
	{
		hideSubAddBtn();
	}
}

function showSubAddBtn()
{
	$('#newSubAdd').linkbutton("enable");
}

function hideSubAddBtn()
{
	
	$('#newSubAdd').linkbutton("disable");
	
	/*
	//��ȡ���е�toolbar��ť
    var button=$('div.datagrid div.datagrid-toolbar a'); 
    for (var i = 0; i < button.length; i++) {
        var toolbar = button[i];
        var id = toolbar.id;
        if (id == "newSubAdd") {  //����IdΪnewAdd�İ�ť
        	$('div.datagrid div.datagrid-toolbar a').eq(i).hide();
        }
    }
    */
}

function SetQuestionEditWinData(){
	PageLogicObj.m_SelRowId="";
	//$("#QuestionCategory").combobox("select",$("#QuestionCategory").combobox("getData")[0].value);
	$("#QuestionLevel,#QuestionType").combobox("setValue","");
	$("#QuestionType").combobox("reload");
	$("#QuestionCode,#Question,#QuestionLongName").val("");
	$("#QuestionApplyArea").combobox("setValues",[]).combobox("reload");
	$("#IsNursingAdvice,#IsHandle").checkbox("setValue",true);
	$("#StDate").datebox("setValue",ServerObj.CurrentDate);
	$("#EndDate").datebox("setValue","");
	$("#MainQuestion").combobox("select","");
	$("#QuestionCategory,#QuestionLevel,#MainQuestion").combobox("enable");
}
function DeleteRow(target){
	$.messager.confirm('ȷ�϶Ի���', "ȷ��ɾ���û���������", function(r){
		if (r) {
			var tr = $(target).closest('tr.datagrid-row');
			var index=parseInt(tr.attr('datagrid-row-index'));
			var rows=$('#tabSubQuestionEdit').datagrid('getRows'); //tabQuestionList
			var rowID=rows[index].rowID;
			if (rowID) {
				DeleteQuestion(rowID);
			}
			$('#tabSubQuestionEdit').datagrid('deleteRow', index);
		}
	});
}
function DeleteQuestion(rowID){
	var rtn=$.m({
		ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
		MethodName:"DeleteQuestion",
		rowID:rowID,
		optID:session['LOGON.USERID']
	},false)
	if (rtn !=0) {
		$.messager.popover({msg:'ɾ����������ʧ�ܣ�',type:'error'});
		return false;
	}else{
		//var QueIndex=$('#tabQuestionList').datagrid('getRowIndex',rowID);
		//$('#tabQuestionList').datagrid('deleteRow', QueIndex);
		$("#tabQuestionList").datagrid("reload");
	}
}
// ���滤������
function SaveQuestionClick(){
	var QuestionLevel=$("#QuestionLevel").combobox("getValue");
	if (!QuestionLevel) {
		$.messager.popover({msg:'��ѡ������㼶��',type:'error'});
		$('#QuestionLevel').next('span').find('input').focus();
		return false;
	}
	var careTypeIn=$('#QuestionCategory').combobox("getValue");
	if ((PageLogicObj.m_SelRowId)&&(PageLogicObj.CopyFlag=="0")){
		// ��������
		if (QuestionLevel ==1) {
			var QuestionType=$("#QuestionType").combobox("getValue");
			var longName=$("#QuestionLongName").val();
			var shortName=$("#Question").val();
			if (!shortName) {
				$.messager.popover({msg:'����д���������⣡',type:'error'});
				$('#Question').focus();
				return false;
			}
			var wardLocs=JSON.stringify($("#QuestionApplyArea").combobox("getValues"));
			var EnableDate=$("#StDate").datebox("getValue");
			if (!EnableDate) {
				$.messager.popover({msg:'�������ڲ���Ϊ�գ�',type:'error'});
				$('#StDate').next('span').find('input').focus();
				return false;
			}
			var NQStopDate=$("#EndDate").datebox("getValue");
			if ((NQStopDate)&&(CompareDate(EnableDate,NQStopDate))){
				$.messager.popover({msg:'��ֹ���ڲ��������������ڣ�',type:'error'});
				$('#EndDate').next('span').find('input').focus();
				return false;
			}
			var isNurAdvance=$("#IsNursingAdvice").checkbox("getValue")?"Y":"N";
		}else{
			var QuestionType="";
			var Editors=$('#tabSubQuestionEdit').datagrid("getEditors",0);
			var shortName=$(Editors[0].target).val();
			if (!shortName) {
				$.messager.popover({msg:'����д���������⣡',type:'error'});
				$(Editors[0].target).focus()
				return false;
			}
			var longName=$(Editors[1].target).val();
			var wardLocs=JSON.stringify($(Editors[2].target).combobox("getValues"));
			var isNurAdvance=$(Editors[3].target).checkbox("getValue")?"Y":"N";
			var EnableDate=$(Editors[4].target).dateboxq('getValue');
			var NQStopDate=$(Editors[5].target).dateboxq('getValue');
			if (!EnableDate) {
				$.messager.popover({msg:'�������ڲ���Ϊ�գ�',type:'error'});
				$(Editors[4].target).focus();
				return false;
			}
			if ((NQStopDate)&&(CompareDate(EnableDate,NQStopDate))){
				$.messager.popover({msg:'��ֹ���ڲ��������������ڣ�',type:'error'});
				$(Editors[5].target).focus();
				return false;
			}
		}	
		var sc=$.m({
			ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
			MethodName:"UpdateQuestion",
			rowID:PageLogicObj.m_SelRowId,
			queTypeDr:QuestionType,
			longName:longName,
			shortName:shortName,
			wardLocLinks:wardLocs,
			enableDate:EnableDate,
			disableDate:NQStopDate,
			optID:session['LOGON.USERID'],
			isNurAdvance:isNurAdvance
		},false);

	}else{
		/**
		 * ��������
		 * 1.1 ����������
		 * 1.2 ��������������
		 */
		if (QuestionLevel ==1) {
			var shortName=$("#Question").val();
			if (!shortName) {
				$.messager.popover({msg:'����д���������⣡',type:'error'});
				$('#Question').focus();
				return false;
			}
			var QuestionType=$("#QuestionType").combobox("getValue");
			var IsHandle=$("#IsHandle").checkbox("getValue");
			if (IsHandle) {
				if (!QuestionType) {
					$.messager.popover({msg:'��ѡ��������࣡',type:'error'});
					$('#QuestionType').next('span').find('input').focus();
					return false;
				}
			}
			if ((QuestionType)&&($.hisui.indexOfArray($('#QuestionType').combobox("getData"),"id",QuestionType))<0){
				$.messager.popover({msg:'������������ѡ��������࣡',type:'error'});
				$('#QuestionType').next('span').find('input').focus();
				return false;
			}
			var enableDate=$("#StDate").datebox("getValue");
			var stopDate=$("#EndDate").datebox("getValue");
			if (!enableDate) {
				$.messager.popover({msg:'�������ڲ���Ϊ�գ�',type:'error'});
				$('#StDate').next('span').find('input').focus();
				return false;
			}
			if ((stopDate)&&(CompareDate(enableDate,stopDate))){
				$.messager.popover({msg:'��ֹ���ڲ��������������ڣ�',type:'error'});
				$('#EndDate').next('span').find('input').focus();
				return false;
			}
			var rtn=$.cm({
				ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
				MethodName:"InsertQuestion",
				NQCareType:careTypeIn,
				NQQueTypeDR:QuestionType,
				NQLongNameCN:$("#QuestionLongName").val(),
				NQShortNameCN:shortName,
				NQParentRowIdDR:"",
				LocDR:"",
				NQEnableDate:enableDate,
				NQStopDate:stopDate,
				NQOperateUserDR:session['LOGON.USERID'],
				wardLocs:JSON.stringify($("#QuestionApplyArea").combobox("getValues")),
				//NQHospitalDR:PageLogicObj.HospID||window.parent.$HUI.combogrid('#_HospList').getValue(),
				//2758853������ƻ����á�ҵ���������
				NQHospitalDR:(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
				isNurAdvance:$("#IsNursingAdvice").checkbox("getValue"),
				CopyFlag:PageLogicObj.CopyFlag,	//��������			
			},false)
			var sc=rtn.sc;
		}else{
			var MainQuestion=$("#MainQuestion").combobox("getValue");
			if (!MainQuestion) {
				$.messager.popover({msg:'��ѡ�������⣡',type:'error'});
				$('#MainQuestion').next('span').find('input').focus();
				return false;
			}else if($.hisui.indexOfArray($('#MainQuestion').combobox("getData"),"rowID",MainQuestion)<0){
				$.messager.popover({msg:'������������ѡ�������⣡',type:'error'});
				$('#MainQuestion').next('span').find('input').focus();
				return false;
			}
			var rows=$('#tabSubQuestionEdit').datagrid('getRows');
			if (rows.length ==0) {
				$.messager.popover({msg:'û����Ҫ����������⣡',type:'error'});
				return false;
			}
			var dataArray=[];
			for (var i=0;i<rows.length;i++){
				var Editors=$('#tabSubQuestionEdit').datagrid("getEditors",i);
				if (Editors.length >0) {
					var shortName=$(Editors[0].target).val();
					if (!shortName) {
						$.messager.popover({msg:'����д���������⣡',type:'error'});
						$(Editors[0].target).focus();
						return false;
					}
					var longName=$(Editors[1].target).val();
					var applyArea=$(Editors[2].target).combobox("getValues");
					var isNurAdvance=$(Editors[3].target).checkbox("getValue")?"Y":"N";
					var enableDate=$(Editors[4].target).dateboxq('getValue');
					var stopDate=$(Editors[5].target).dateboxq('getValue');
					if (!enableDate) {
						$.messager.popover({msg:'�������ڲ���Ϊ�գ�',type:'error'});
						$(Editors[4].target).focus();
						return false;
					}
					if ((stopDate)&&(CompareDate(enableDate,stopDate))){
						$.messager.popover({msg:'��ֹ���ڲ��������������ڣ�',type:'error'});
						$(Editors[5].target).focus();
						return false;
					}
				}else{
					/*var shortName=rows[i].shortName;
					var longName=rows[i].longName;
					var applyArea=rows[i].applyArea;
					var isNurAdvance=rows[i].isNurAdvance=="Y"?"true":"false";
					var enableDate=rows[i].enableDate;
					var stopDate=rows[i].stopDate;*/
					continue;
				}
				dataArray.push([
					careTypeIn,"",longName,shortName,MainQuestion,"",enableDate,stopDate,
					session['LOGON.USERID'],
					applyArea,
					//2758853������ƻ����á�ҵ���������
					(PageLogicObj.iframeflag=="1"? window.parent.$HUI.combogrid('#_HospList').getValue():$HUI.combogrid('#_HospList').getValue()),
					isNurAdvance,
					PageLogicObj.CopyFlag,	//��������
				]);
			}
			var sc=$.cm({
				ClassName:"Nur.NIS.Service.NursingPlan.QuestionSetting",
				MethodName:"BatchInsertQuestion",
				dataArray:JSON.stringify(dataArray),
				dataType:"text"
			},false);
		}
	}
	if (sc>=0){
		$("#QuestionEditWin").window("close");
		PageLogicObj.CopyFlag='0';
		$("#tabQuestionList").datagrid("reload");
	}else{
		$.messager.alert("��ʾ","���滤������ʧ��!"+sc);
		return false;
	}
}
function QuestionLevelChange(QuestionLevel){
	var Msg="ȷ��Ҫ�л�����㼶��";
		Msg += '</br><sapn style="opacity:0.65;">�л�����㼶�󣬽���յ�ǰ�㼶����Ϣ.</sapn>';
	if (QuestionLevel ==1) {
		var MainQuestion=$("#MainQuestion").combobox("getValue");
		// ��ʼ�� ��Ϸ��� 20210710
		$("#QuestionCategory").combobox("select",$("#QuestionCategory").combobox("getData")[0].value);
		if (MainQuestion) {
			$.messager.confirm("ȷ�϶Ի���",Msg, function(r){
				if (r){
					$("#MainQuestion").combobox("setValue","");
					SetQuestionEditWinStyle();				
				}else{
					var mainQuestionID = $("#MainQuestion").combobox("getValue");
					refreshCareTypeById(mainQuestionID)
					//$('#QuestionCategory').combobox("setValue","");
					//$("tr[id=QuestionCategoryTR]").hide();
					$('#QuestionLevel').combobox("setValue",2);
					$("#QuestionCategory").combobox("disable");
				}
				return;
			});
		}else{
			SetQuestionEditWinStyle();
		}
	}else{
		var Question=$("#Question").val();
		if (Question) {
			$.messager.confirm("ȷ�϶Ի���",Msg, function(r){
				if (r){
					$("#Question,#QuestionLongName").val("");
					SetQuestionEditWinStyle();				
				}else{
					// ȡ��������
					$("#QuestionCategory").combobox("select",$("#QuestionCategory").combobox("getData")[0].value);
					$("#QuestionCategory").combobox("enable");
					$('#QuestionLevel').combobox("setValue",1);
				}
				return;
			});
		}else{
			SetQuestionEditWinStyle();
		}
		$('#QuestionCategory').combobox("setValue","");
	}
	function SetQuestionEditWinStyle(){
		if (QuestionLevel ==1) {
			$(".main-question-tr").show();
			$(".sub-question-tr").hide();
			//2758853������ƻ����á�ҵ���������
			if (PageLogicObj.iframeflag=="1"){
				var Width = document.body.clientWidth;
				var Height = document.body.clientHeight;
				$('#QuestionEditWin').panel('resize',{	
					width: Width-10,
					height: Height-50
				});							
				$('#QuestionEditWin').window("center");					
				$("#quesion-layout").css("height",Height-50);
				$("#quesion-layout").css("width",Width-20);
				$("#quesion-layout").layout('panel', 'north').panel("resize",{height:Height-130});
				$("#quesion-layout").layout('panel', 'center').hide().panel("resize",{height:0});
				//var Top = $("#quesion-layout").layout('panel', 'center').panel("options").top
				$("#quesion-layout").layout('panel', 'south').panel("resize",{top:Height-130});
				$("#QuestionLongName").css("width",Width*0.6);
				$("#Question").css("width",Width*0.6);				
				$("#Question").focus();	
	
			}
			else{
				$('#QuestionEditWin').panel('resize',{	
					width: 970,
					height: 555
				});							
				$('#QuestionEditWin').window("center");					
				$("#quesion-layout").css("height","525px");
				$("#quesion-layout").layout('panel', 'north').panel("resize",{height:477});
				$("#quesion-layout").layout('panel', 'south').panel("resize",{top:467});
				$("#quesion-layout").layout('panel', 'center').hide().panel("resize",{height:0});
				$("#Question").focus();	
			}
		}else{
			$(".main-question-tr").hide();
			$(".sub-question-tr").show();
			//2758853������ƻ����á�ҵ���������
			if (PageLogicObj.iframeflag=="1") {
				var Width = document.body.clientWidth;
				var Height = document.body.clientHeight;
				$('#QuestionEditWin').panel('resize',{
					width: Width-10,
					height: Height-20
				});
				
				$('#QuestionEditWin').window("center");						
				$("#quesion-layout").css("height",(Height-50)+"px");			
				$("#quesion-layout").layout('panel', 'north').panel("resize",{height:128});
				$("#quesion-layout").layout('panel', 'center').show().panel("resize",{top:130,height:372});
				$("#quesion-layout").layout('panel', 'south').panel("resize",{top:500});
				$("#tabSubQuestionEdit").datagrid('resize',{
					width:'100%',
				});

			}
			else{
				$('#QuestionEditWin').panel('resize',{
					width: 970,
					height: 552
				});

				$('#QuestionEditWin').window("center");						
				$("#quesion-layout").css("height","525px");			
				$("#quesion-layout").layout('panel', 'north').panel("resize",{height:130});
				$("#quesion-layout").layout('panel', 'center').show().panel("resize",{top:130,height:345});
				$("#quesion-layout").layout('panel', 'south').panel("resize",{top:465});
			}
			/* ������ ���¼���߶�
			$("#quesion-layout").layout('panel', 'north').panel("resize",{height:90});
			$("#quesion-layout").layout('panel', 'center').show().panel("resize",{top:90,height:335});
			$("#quesion-layout").layout('panel', 'south').panel("resize",{top:465});
			*/
		}
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
	//if(date2<=date1){  //�������	3086276
	if(date2<date1){  
		return true;  
	} 
	return false;
}

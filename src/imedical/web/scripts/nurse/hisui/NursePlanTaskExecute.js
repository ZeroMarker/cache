/**
* @author songchunli
* NursePlanTaskExecute.js
* HISUI ����ִ����js
*/
var PageLogicObj={
	episodeIDs:"", //�ѷ�ѡ���ﴮ
	m_NurPlanTaskTab:"",
	m_LastSearchObj:{}, //��һ�β�ѯtable����ζ������β�ѯ������ͬʱ���ظ���ȡ������ʩ����δִ�е�����
	m_ReSetIntTypeCountFlag:"N", //�Ƿ����»�ȡ������ʩ����δִ�е�����(����ʩ�������Ƿ��к�ɫ��ʶ)
	m_recordList:[], //�ѹ�ѡ������С��Ļ�����������
	m_exeTaskListJson:"", //���������Ӧ��С��json
	m_positionArr:[], //��ռλ����Ϣ��С���¼
	m_btnClickRecord:[], //����С�ť�����¼
	m_NursingRecordTemplateJson:[] //�����¼��ͷ���������б�
}
/**
*	�˵��������������񡪡����ʽ����"&ifMultiCheck=1" 
*	��ѡ��Ҫ��ifMultiCheck=1
*/
$(function(){
	Init();
	InitEvent();
	if(ServerObj.versionPatientListNew=="1"){
		$('#main').layout('panel', 'west').panel({
			onExpand: ResetDomSize,
		  	onCollapse: ResetDomSize
		});
	}
});
$(window).load(function() {
	$("#loading").hide();
	if(IsNurTaskRedirect()){
		ResetDomSize();
	}
})
window.addEventListener("resize",ResetDomSize);
function Init(){
	InitSearchData();
	if (ServerObj.IsShowPatList =="Y") {
		//չʾ�����б�			
		if(ServerObj.versionPatientListNew!="1"){
			//�ɰ汾
			// �������Ȩ�޿���ʱ��Ĭ����ʾ����
			if(ServerObj.groupFlag=="Y"){
				$("#switchBtn").addClass("ant-switch-checked");
				$($(".switch label")[1]).addClass("current");
			}
			//InitPatientTree();			
			InitPatientTreeOld();
			$('#wardPatientCondition').css("margin-top","5px");
			$('#wardPatientCondition').css("width","206px");
			$('#wardPatientCondition').css("padding","0 1px");
			//$(".tree-file,.tree-folder,.tree-folder-open").css("display","none")
			ResetDomSize();
		}else{
			//�°汾
			PageLogicObj.episodeIDs=ServerObj.portalEpisodeIDS||ServerObj.EpisodeID;
			InitNurPlanTaskTab();
			ResetDomSize();
		}						
	}else{
		// ��չʾ�����б�
		// ������������ת
		if (!IsNurTaskRedirect() || IsNurTaskRedirect() == ""){
			// portal ����
			PageLogicObj.episodeIDs=ServerObj.portalEpisodeIDS||ServerObj.EpisodeID;
			//PageLogicObj.episodeIDs=ServerObj.EpisodeID;
		}else{
			PageLogicObj.episodeIDs=getQueryVariable("episodeIDString");
		}
		InitNurPlanTaskTab();
		$("#TaskPlanExecute-panel").panel("resize",{height:$(window).height()-20,width:'100%'});
		$("#tab-div").css('height',$("#TaskPlanExecute-panel").height()-51-$("#intType").height())
    	$('#NurPlanTaskTab').datagrid("resize");
	}
}
function InitEvent(){
	$("#BFind").click(function(){
		$('#NurPlanTaskTab').datagrid('load');
	});
	$("#BShowPRNModal").click(showPRNModal);
	/*$('#wardPatientSearchBox').searchbox({
		searcher: function(value) {
			SetPatientTreeStatus();
		}
	});*/
	$("#wardPatientSearchBox").keydown(function(e){
		var key=websys_getKey(e);
		if (key==13){
			SetPatientTreeStatus();
		}
	});
	$("#wardPatientSearchBtn").click(function(){
		SetPatientTreeStatus();
	});
	$("#switchBtn").click(function(){
		$(".current").removeClass("current");
		if ($(".ant-switch-checked").length) {
			$("#switchBtn").removeClass("ant-switch-checked");
			$($(".switch label")[0]).addClass("current");
		}else{
			$("#switchBtn").addClass("ant-switch-checked");
			$($(".switch label")[1]).addClass("current");
		}
		PageLogicObj.episodeIDs="";
		$HUI.tree('#patientTree','reload');
	});
	/*$('#wardPatientCondition').switchbox('options').onSwitchChange = function(){
		PageLogicObj.episodeIDs="";
		$HUI.tree('#patientTree','reload');
	};*/
}
function InitSearchData(){
	// 2021.8.24 ����������ת�����Ĳ���
	var redDateFrom = getQueryVariable("dateFrom")
	var redDateTo = getQueryVariable("dateTo")
	var redTimeFrom = getQueryVariable("timeFrom")
	var redTimeTo = getQueryVariable("timeTo")
	if (redDateFrom && redDateFrom != "")
	{
		ServerObj.startDate = redDateFrom
	}
	if (redDateTo && redDateTo != "")
	{
		ServerObj.endDate = redDateTo
	}
	if (redTimeFrom && redTimeFrom != "")
	{
		ServerObj.startTime = redTimeFrom
	}
	if (redTimeTo && redTimeTo != "")
	{
		ServerObj.endTime = redTimeTo
	}
	// end
	/*
	$("#SearchDateFrom").datebox("setValue",ServerObj.startDate);
	$("#SearchTimeFrom").timespinner("setValue",ServerObj.startTime);
	$("#SearchDateTo").datebox("setValue",ServerObj.endDate);
	$("#SearchTimeTo").timespinner("setValue",ServerObj.endTime);
	*/
	$("#SearchDateFrom").datebox("setValue",ServerObj.QPCCInterventionStartDate);
	$("#SearchTimeFrom").timespinner("setValue",ServerObj.QPCCInterventionStartTime);
	$("#SearchDateTo").datebox("setValue",ServerObj.QPCCInterventionEndDate);
	$("#SearchTimeTo").timespinner("setValue",ServerObj.QPCCInterventionEndTime);
	
	InittaskStatus();
	//��ʼ����ʩ����tab
	InitintType();
}
function InittaskStatus(){
	$HUI.combobox("#taskStatus", {
		valueField: 'value',
		textField: 'text', 
		//editable:false,
		data: eval("("+ServerObj.taskStatusJson+")"),
		loadFilter:function(data){
			var newData=new Array();
			for (var i=0;i<data.length;i++){
				var value=data[i].value;
				var text=data[i].text;
				newData.push({
					"value":value.toString(),
					"text":text
				});
			}
			return newData;
		},
		onLoadSuccess:function(){
			$("#taskStatus").combobox("setValue",0);
		},
		onSelect:function(rec){
			if (rec) {
				var tab = $('#intType').tabs('getTab',0);  
				$('#intType').tabs('update', {
					tab: tab,
					options: {
						title: rec.text
					}
				});
				$('#NurPlanTaskTab').datagrid('load');
			}
		},
		onChange: function(newValue, oldValue){
			if (!newValue) {
				var tab = $('#intType').tabs('getTab',0);  
				$('#intType').tabs('update', {
					tab: tab,
					options: {
						title: $g('ȫ��')
					}
				});
				$('#NurPlanTaskTab').datagrid('load');			
			}
		}
    });
}

// �ж��Ƿ�����������ת ��:���� �ǿ�:��
function IsNurTaskRedirect()
{
	// ��ʼ�� --����������ת url����
	var showTaskTabName = decodeURI(decodeURI(getQueryVariable("showTaskTabName")));
	var showTaskTabName = (showTaskTabName == "0" ? "" : showTaskTabName);
	// HOS ����վ������� 2021.11.2
	if (showTaskTabName=="")
	{
		showTaskTabName = decodeURI(decodeURI(ServerObj.showTaskTabNameHOS));
	}
	return showTaskTabName;
}
function InitintType(){
	var Json=$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
		QueryName:"FindInterventionType",
		nameCN:"",
		hospDR:session['LOGON.HOSPID'],
		rows:99999
	},false)
	// ��ʼ�� --����������ת
	var showTaskTabName = IsNurTaskRedirect()
	var selectedType1 = true;
	if (showTaskTabName != "")
	{
		PageLogicObj.episodeIDs = getQueryVariable("episodeIDString")
		//�������	3274722 ��������-˫��������ƻ���ģ���������¼����ϸ��Ϣ�����ѯ��������
		//if (ServerObj.IsShowAllPatient=="Y"&&showTaskTabName=="δִ��")
		if (showTaskTabName=="δִ��")
		{
			selectedType1 = true;
		}else
		{
			selectedType1 = false;
		}
	}
	// portal ��ת
	if (ServerObj.portalEpisodeIDS && ServerObj.portalEpisodeIDS!="")
	{
		selectedType1 = false;
		// ͨ��Ӣ�Ļ�ȡ��������
		var showTaskTabName = $.m({
			ClassName:"Nur.NIS.Service.NursingPlan.InterventionSetting",
			MethodName:"GetInterventionTypeNameForCN",
			hosDR:session['LOGON.HOSPID'],
			longNameEN:ServerObj.portalCodeStr
		},false)
		// ��ȡ������ȷ��tabҳǩ Ĭ������δִ��
		if (!showTaskTabName || showTaskTabName=="")
		{
			selectedType1 = true;
		}
	}
	$('#intType').tabs('add',{
		id:"",
		title:$g("δִ��"),    
		content:'',
		closable:false,   
		selected:selectedType1
	})
	for (var i=0;i<Json.total;i++){
		var id=Json.rows.id;
		var text=Json.rows[i].shortNameCN;
		var selectedType2 = false;
		if (text == showTaskTabName)
		{
			selectedType2 = true;
		}
		$('#intType').tabs('add',{ 
			id:Json.rows[i].id,
			title:text,    
			content:'',
			closable:false,   
			selected:selectedType2
		}) 
	}

   $('#intType').tabs({
	   onSelect: function(title,index){
			$('#NurPlanTaskTab').datagrid('load');
	   }
   })
}
// ��ȡurl����
function getQueryVariable(variable)
{
       var query = window.location.search.split("?")[1];
       if (query)
       {
	       var vars = query.split("&");
	       for (var i=0;i<vars.length;i++) {
	               var pair = vars[i].split("=");
	               if(pair[0] == variable){return pair[1];}
	       }
       }
       return "";
}

function InitPatientTreeOld(){
	var innerHeight=window.innerHeight;
	$("#patientList").panel('resize', {
	  	height:innerHeight-42
	});
	$("#patientListTree").panel('resize', {
	  	height:innerHeight-100
	});
	$HUI.tree('#patientTree', {
		checkbox:true,
		loader: function(param, success, error) {
			// HIS 8.5 �汾
			if (ServerObj.version85 == "1")
			{
				var parameter = { EpisodeID:ServerObj.EpisodeID, WardID:session['LOGON.WARDID'], LocID:session['LOGON.CTLOCID'], GroupFlag:$(".ant-switch-checked").length ? true : false, BabyFlag:'', SearchInfo:$("#wardPatientSearchBox").val(), LangID:session['LOGON.LANGID'], UserID:session['LOGON.USERID'] };
				$cm({
					ClassName: "Nur.NIS.Service.Base.Ward",
					MethodName: "GetWardPatientsNew",
					wardID:session['LOGON.WARDID'],
					adm:ServerObj.EpisodeID,
					groupSort:$(".ant-switch-checked").length?"true":"false",
					babyFlag:"",
					searchInfo:$("#wardPatientSearchBox").val(),
					locID:session['LOGON.CTLOCID']
					//MethodName: "getPatients",
					//Param: JSON.stringify(parameter)
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === ServerObj.EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			}
			/*
			else
			{
				// ���ݵͰ汾HIS -- ȡ�����������б�ӿ�
				$cm({
					ClassName: "NurMp.NursingRecords",
					MethodName: "getWardPatients",
					wardID: session['LOGON.WARDID'],
					adm: ServerObj.EpisodeID,
					groupSort: $(".ant-switch-checked").length?"true":"false", //!$('#wardPatientCondition').switchbox('getValue'),
					babyFlag: '',
					searchInfo:$("#wardPatientSearchBox").val(), //$HUI.searchbox('#wardPatientSearchBox').getValue(),
					locID: session['LOGON.CTLOCID']||'',
					todayOperFlag: $("#radioTodayOper").radio('getValue')
				}, function(data) {
					var addIDAndText = function(node) {
						node.id = node.ID;
						node.text = node.label ;
						if (node.id === ServerObj.EpisodeID) {
							node.checked = true;
						}
						if (node.children) {
							node.children.forEach(addIDAndText);
						}
					}
					data.forEach(addIDAndText);
					success(data);
				});
			}
			*/
            else {
                // ���ݵͰ汾HIS -- ȡ�����������б�ӿ�
                var parameter = {
					EpisodeID: ServerObj.EpisodeID,
					WardID: session['LOGON.WARDID'],
					LocID: session['LOGON.CTLOCID'],
					GroupFlag: $(".ant-switch-checked").length ? "true" : "false", //$('#wardPatientCondition').switchbox('getValue') == true ? 'N' : 'Y',
					BabyFlag: '',
					SearchInfo: $("#wardPatientSearchBox").val(),//$HUI.searchbox('#wardPatientSearchBox').getValue(),
					LangID: session['LOGON.LANGID'],
					UserID: session['LOGON.USERID'],
					StartDate: '', //ShowSearchDate == 1 ? $('#startDate').datebox('getValue') : '',
					EndDate: '', //ShowSearchDate == 1 ? $('#endDate').datebox('getValue') : ''
				};
                $cm({
					ClassName: 'NurMp.Service.Patient.List',
					MethodName: 'getPatients',
					Param: JSON.stringify(parameter)
				}, function (data) {
                    var addIDAndText = function (node) {
                        node.id = node.ID;
                        node.text = node.label;
                        if (node.id === ServerObj.EpisodeID) {
                            node.checked = true;
                        }
                        if (node.children) {
                            node.children.forEach(addIDAndText);
                        }
                    }         
                    data.WardPatients.forEach(addIDAndText);
                    success(data.WardPatients);
                });
            }
		},
		onLoadSuccess: function(node, data) {
			$(".tree-file,.tree-folder,.tree-folder-open").css("display","none")
			if (ServerObj.IsShowAllPatient =="Y") {
				PatientTreeCheckHandle();
			}else{
				if (!!ServerObj.EpisodeID) {
					var selNode = $('#patientTree').tree('find', ServerObj.EpisodeID);
					$('#patientTree').tree('check', selNode.target);
					$($(selNode.target).children()[4]).addClass("frmepisodepat")
				}
			}
		},
		lines: true,
		onClick: function (node) {
			var nodes =$('#patientTree').tree('getChecked');
			if ($.hisui.indexOfArray(nodes,"ID",node.ID)>=0) {
				$('#patientTree').tree('uncheck', node.target);
			}else{
				$('#patientTree').tree('check', node.target);
			}
		},
		onCheck:function(node, checked){
			PatientTreeCheckHandle();
		}
	});
}
//��������ѡ/ȡ����ѡʱ����
//�˵��������������񡪡����ʽ����"&ifMultiCheck=1"
function patientTreeCheckChangeHandle()
{
	if(ServerObj.versionPatientListNew!="1"){
		PatientTreeCheckHandle();
	}else{
		PageLogicObj.episodeIDs=EpisodeIDStr;
		if (!PageLogicObj.m_NurPlanTaskTab) {
			InitNurPlanTaskTab();
		}else{
			$('#NurPlanTaskTab').datagrid('load');
		}
	}	
}
function PatientTreeCheckHandle(){
	var selEpisodeIDsArr=new Array();
	var nodes =$('#patientTree').tree('getChecked');
	for (var i=0;i<nodes.length;i++){
		// 2021.11.30 ĸӤ�� ����ֻ��ʾһ�� bug fix
		// if (nodes[i].children) continue;
		selEpisodeIDsArr.push(nodes[i].episodeID);
	}
	PageLogicObj.episodeIDs=selEpisodeIDsArr.join("^");
	if (!PageLogicObj.m_NurPlanTaskTab) {
		InitNurPlanTaskTab();
	}else{
		$('#NurPlanTaskTab').datagrid('load');
	}
}
function InitNurPlanTaskTab(){
	$("#tab-div").css("height",window.innerHeight-130);
	var ToolBar = [{
		text: 'ִ��',
		iconCls: 'icon-arrow-right-top',
		handler: function() {
			var sels=$('#NurPlanTaskTab').datagrid("getChecked");
			if (sels.length==0){
				$.messager.popover({msg:'�빴ѡ��Ҫִ�еļ�¼��',type:'error'});
				return false;
			}
			PageLogicObj.m_recordList=[];
			for (var i=0;i<sels.length;i++){
				var tkStatus=sels[i].tkStatus;
				if ((tkStatus==2)||(tkStatus==3)) {
					$.messager.popover({msg:'����ִ�� ������ �� ��ֹͣ �ļ�¼��',type:'error'});					
					return;
					}
				var itemInfo=sels[i].itemInfo;
				itemInfo=eval("("+itemInfo+")");
				var itemTotalCount=itemInfo.itemTotalCount;
				if (itemTotalCount>0) {
					continue;
					}
				PageLogicObj.m_recordList.push(sels[i]);
			}
			showNoSubItemExeWin();
		}
	}
	,{
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			//Nur_NIS.TaskRecord
			DelTaskRecord();
		}
	},{
		text: 'ִ�б�ע',
		iconCls: 'icon-paper-ok',
		handler: function() {
			showExeNoteWin();
		}
	},{
		text: 'ת�뻤���¼',
		iconCls: 'icon-export-report',
		handler: function() {
			showTransferRecordWin();
		}
	},{
		text: '��ӡ��������',
		iconCls: 'icon-print',
		handler: function() {
			if ((PageLogicObj.episodeIDs.split("^").length >1)||(PageLogicObj.episodeIDs=="")){
				$.messager.popover({msg:'��ѡ��һ�����߽��л��������ӡ!',type:'error'});
				return false;
			}
			// �ⲿ����Դ��ӡbug fix
			var locationURL = window.location.href.split("/csp/")[0]; // + "/"
			var dateFrom = PageLogicObj.m_LastSearchObj.dateFrom;
			var dateTo = PageLogicObj.m_LastSearchObj.dateTo;
			var taskStatus = PageLogicObj.m_LastSearchObj.taskStatus; //״̬
			var PrnParams = dateFrom + "^" + dateTo + "^" + taskStatus;
			AINursePrintAll(locationURL,"DHCNURMoudPrnHZRWD",PageLogicObj.episodeIDs,PrnParams);

			//AINursePrintAll(locationURL,"DHCNURMoudPrnHZRWD",PageLogicObj.episodeIDs,"");
		}
	}];
	//���� 2861448--�ֶ������Ļ���ƻ�֧���޸�����ʱ�䡢����֧���޸�Ϊǰһ���ʱ��
	if(ServerObj.IsOpenEditDateTime == "Y"){
		ToolBar.push({
            text: 'ʱ���޸�',
            iconCls: 'icon-edit',
            handler: function () {
                EditDateTime();
            }
        })		
	}	
	// �������� 2021.9.1
	if (ServerObj.IsOpenCancelNursePlan == "Y")
	{
		ToolBar.splice(1,0,
		{
			text: '����ִ��',
			iconCls: 'icon-back',
			handler: function() {
				var sels=$('#NurPlanTaskTab').datagrid("getSelections");
				//var sels=$('#NurPlanTaskTab').datagrid("getChecked");
				if (sels.length==0){
					$.messager.popover({msg:'��ѡ����Ҫ����ִ�еļ�¼��',type:'error'});
					return false;
				}
				var recordArr = []
				for (var i=0;i<sels.length;i++){
					var tkStatusName=sels[i].tkStatusName;
					var recordId = sels[i].recordId
					if (tkStatusName!="��ִ��")
					{
						$.messager.popover({msg:'���ܳ�������'+tkStatusName+"״̬�ļ�¼��",type:'error'});
						return false;
					}
					var obj = {recordId:recordId}
					recordArr.push(obj)
				}
				
				$.messager.confirm("������ʾ", "ȷ������ִ��?", function (r) {
					if (r) {
						if (recordArr.length>0) {
							var rtnResult=$m({
								ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
								MethodName:"CancelTaskRecord",
								userID:session['LOGON.USERID'],
								recordArr:JSON.stringify(recordArr)
							},false)
							if (rtnResult != "0"){
								$.messager.popover({msg:'����ʧ�ܣ�'+rtnResult,type:'error'});
								return false;
							}else{
								$.messager.popover({msg:'�����ɹ�!',type:'success'});
								//PageLogicObj.m_ReSetIntTypeCountFlag="Y";
								//UpdateInitTypeCount();
								$('#NurPlanTaskTab').datagrid('reload');
							}
						}
					}
				});
			 }
	 	});
	}
	
	if (ServerObj.QPCCOpenDelNureTask !="Y"){
		if (ServerObj.IsOpenCancelNursePlan == "Y"){
			ToolBar.splice(2,1);
		}else{
			ToolBar.splice(1,1);
		}
	}
	var Columns=[[ 
		{ field: 'interventionTypeName', title: '����',width:100},
		{ field: 'planDateTime', title: '�ƻ�ִ��ʱ��',width:140},
		{ field: 'executeItemName', title: 'ִ����Ŀ',width:250,wordBreak:"break-all"},
		{ field: 'itemInfo', title: 'ִ������',width:180,
			formatter: function(itemInfo,row,index){
				itemInfo=eval("("+itemInfo+")");
				var itemExecutedCount=itemInfo.itemExecutedCount;
				var itemTotalCount=itemInfo.itemTotalCount;
				if ((itemExecutedCount>0)||(itemTotalCount>0)) {
					return $g("����������")+itemTotalCount+"��"+$g(" ��ִ�У�")+itemExecutedCount;
				}else{
					return "";
				}
			},
			styler: function(itemInfo,row,index){
				itemInfo=eval("("+itemInfo+")");
				var itemExecutedCount=itemInfo.itemExecutedCount;
				var itemTotalCount=itemInfo.itemTotalCount;
				if ((itemTotalCount>0)&&(itemExecutedCount<itemTotalCount)) {
					return "background-color:#fda632;color:white;";
				}
			}
		},
		{ field: 'executeNote', title: 'ִ�б�ע',width:95},
		{ field: 'freqName', title: 'Ƶ��',width:100},
		{ field: 'executeUserName', title: 'ִ����',width:100},
		{ field: 'executeDateTime', title: 'ִ��ʱ��',width:140},
		{ field: 'insertDateTime', title: '��ʼʱ��',width:140},
		{ field: 'stopDateTime', title: '����ʱ��',width:140},
		{ field: 'transferDateTime', title: 'ת�뻤���¼ʱ��',width:150},
		{ field: 'executeContent', title: 'ִ�н��',width:250},
		{ field: 'tkStatusName', title: '״̬',width:100}
		
    ]];
	PageLogicObj.m_NurPlanTaskTab=$('#NurPlanTaskTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('������..'),  
		pagination : true, 
		rownumbers : false,
		idField:"recordId",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		nowrap:false,  /*�˴�Ϊfalse*/
		toolbar:ToolBar,
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.TaskRecord&QueryName=GetTaskList",
		frozenColumns:[[
			{ field: 'recordId', checkbox: 'true'},
			{ field: 'patientBedNo', title: '����',width:70},
			{ field: 'patientName', title: '����',width:100}
		]],
		rowStyler: function (index, row) {
			var itemInfo=row.itemInfo;
			itemInfo=eval("("+itemInfo+")");
			var itemTotalCount=itemInfo.itemTotalCount;
			if (itemTotalCount) {				
			}
			else{
				//��������ɫ���� Լ��������ִ�С��б��б���ɫ��
				// ���� ONCE��ST ��PRN
		        if ((row.freqName=="ONCE")||(row.freqName=="Once")||(row.freqName=="һ��")
		        	||(row.freqName=="ST")||(row.freqName=="St")||(row.freqName=="Prn")
		       		||(row.freqName=="PRN")) {
		           		return 'background:' + ServerObj.QPCCTemporaryInterventionColor + ';';
		        }
		        else{
		        	return 'background:' + ServerObj.QPCCLongTermInterventionColor + ';';
		        }
			}
        },
		onBeforeLoad:function(param){
			$("#NurPlanTaskTab").datagrid("unselectAll");
			var intType="";
			var tab = $('#intType').tabs('getSelected');
			var index = $('#intType').tabs('getTabIndex',tab);
			if (index>0) {
				intType=$('#intType').tabs('getSelected').panel('options').id;
			}
			var NewSearchObj={
				episodeIDString:PageLogicObj.episodeIDs,
				dateFrom:$("#SearchDateFrom").datebox('getValue')+" "+$("#SearchTimeFrom").timespinner("getValue"), 
				dateTo:$("#SearchDateTo").datebox('getValue')+" "+$("#SearchTimeTo").timespinner("getValue"),
				taskStatus:$("#taskStatus").combobox("getValue"), //״̬
				intType:intType //��ʩ����id
			}
			if (JSON.stringify(PageLogicObj.m_LastSearchObj) == JSON.stringify(NewSearchObj)) {
				PageLogicObj.m_ReSetIntTypeCountFlag="N";
			}else{
				PageLogicObj.m_ReSetIntTypeCountFlag="Y";
			}
			param = $.extend(param,NewSearchObj);
			$.extend(PageLogicObj.m_LastSearchObj,NewSearchObj);
		},
		onDblClickRow:function(rowIndex, rowData){
			PageLogicObj.m_recordList=[];
			PageLogicObj.m_recordList.push(rowData);
			var itemInfo=rowData.itemInfo;
			itemInfo=eval("("+itemInfo+")");
			var itemTotalCount=itemInfo.itemTotalCount;
			//if((rows[rowIndex].tkStatus==2)||(rows[rowIndex].tkStatus==3)){
			if((rowData.tkStatus==2)||(rowData.tkStatus==3)){
				//if(itemTotalCount) alert("�����ϻ���ֹͣ�����񲻿�ִ��");
				if(itemTotalCount)	$.messager.popover({msg:'�����ϻ���ֹͣ�����񲻿�ִ��',type:'error'});
				return
			}
			else{
				if (itemTotalCount) {
					PageLogicObj.m_btnClickRecord=[];
					showSubItemExeWin();
				}else{
					showNoSubItemExeWin();
				}
			}
		},
		onClickCell:function(rowIndex, field, value){
			if (field =="itemInfo") {
				var rows=$("#NurPlanTaskTab").datagrid("getRows");
				var itemInfo=rows[rowIndex].itemInfo;
				itemInfo=eval("("+itemInfo+")");
				var itemTotalCount=itemInfo.itemTotalCount;
				if((rows[rowIndex].tkStatus==2)||(rows[rowIndex].tkStatus==3)){
					//if(itemTotalCount) alert("�����ϻ���ֹͣ�����񲻿�ִ��");
					if(itemTotalCount) $.messager.popover({msg:'�����ϻ���ֹͣ�����񲻿�ִ��',type:'error'});					
					return
				}
				else{
					if (itemTotalCount) {
						PageLogicObj.m_recordList=[];
						PageLogicObj.m_recordList.push(rows[rowIndex]);
						PageLogicObj.m_btnClickRecord=[];
						showSubItemExeWin();
					}
				}
			}
		},
		onLoadSuccess:function(data){
			// ���� 2922747
			PageLogicObj.m_ReSetIntTypeCountFlag="Y";
			UpdateInitTypeCount();
			if (data['rows'].length>=0){
				var _$recordId=$("input[name='recordId']");
				for (var i=0;i<data['rows'].length;i++){
					var itemInfo=data['rows'][i].itemInfo;
					itemInfo=eval("("+itemInfo+")");
					var itemExecutedCount=itemInfo.itemExecutedCount;
					var itemTotalCount=itemInfo.itemTotalCount;
					if ((itemExecutedCount>0)||(itemTotalCount>0)) {
						$(_$recordId[i]).attr('disabled','disabled');
					}
				}
			}
		},
		onBeforeCheck:function(index, row){
			var itemInfo=row.itemInfo;
			itemInfo=eval("("+itemInfo+")");
			var itemExecutedCount=itemInfo.itemExecutedCount;
			var itemTotalCount=itemInfo.itemTotalCount;
			if ((itemExecutedCount>0)||(itemTotalCount>0)) {
				return false;
			}
		},
		onCheckAll:function(rows){
			for (var i=0; i<rows.length; i++) {
				if (!$("input[name='recordId']")[i].disabled){
					$("#NurPlanTaskTab").datagrid('selectRow',i);
				}else{
					$($("input[name='recordId']")[i]).prop("checked", false);
				}
			}
			$(".datagrid-header-check input").prop("checked", true);
		}
	})
}
function UpdateInitTypeCount(){
	if (PageLogicObj.m_ReSetIntTypeCountFlag =="Y"){	
		$.cm({
			ClassName : "Nur.NIS.Service.NursingPlan.TaskRecord",
			QueryName : "GetTaskList",
			episodeIDString:PageLogicObj.m_LastSearchObj.episodeIDString,
			dateFrom:PageLogicObj.m_LastSearchObj.dateFrom, 
			dateTo:PageLogicObj.m_LastSearchObj.dateTo,
			taskStatus:PageLogicObj.m_LastSearchObj.taskStatus, //״̬
			intType:"", //PageLogicObj.m_LastSearchObj.intType, //��ʩ����id
			rows:9999999
		},function(data){
			$(".tabItem_badge").remove();
			var intTypeArr=new Array();
			for (var i=0;i<data.total;i++){
				var tkStatus=data.rows[i].tkStatus;
				var interventionTypeId=data.rows[i].interventionTypeId;
				if (intTypeArr[interventionTypeId]) continue;
				var interventionTypeName=data.rows[i].interventionTypeName;
				var tab = $('#intType').tabs('getTab',interventionTypeName);
				var index = $('#intType').tabs('getTabIndex',tab);
				$($("#intType ul li")[index]).append('<sup class="tabItem_badge"></sup>');
				intTypeArr[interventionTypeId]=1;
			}
		});
	}
}
function DelTaskRecord(){
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ���¼��',type:'error'});
		return false;
	}
	var delRecordIdArr=[];
	for (var i=0;i<sels.length;i++){
		var taskRecordId=sels[i].recordId;
		if (!taskRecordId) continue;
		var executeItemName=sels[i].executeItemName;
		var tkStatusName=sels[i].tkStatusName;
		if (tkStatusName !=$g("δִ��")) {
			$.messager.popover({msg:executeItemName+ ' �� "δִ��" ״̬�ļ�¼����ɾ��!',type:'error'});
			return false;
		}
		delRecordIdArr.push(taskRecordId);
	}
	$.messager.confirm('��ʾ', "ȷ��Ҫɾ��ѡ��ļ�¼��", function(r){
		if (r){
			$.cm({
				ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
				MethodName:"DelTaskRecord",
				userId:session['LOGON.USERID'],
				taskRecordIds:delRecordIdArr.join("^"),
				dataType:"text"
			},function(rtn){
				if (rtn ==0){
					for (var i=delRecordIdArr.length-1;i>=0;i--){
						var index=$('#NurPlanTaskTab').datagrid("getRowIndex",delRecordIdArr[i]);
						$('#NurPlanTaskTab').datagrid("deleteRow",index);
					}
					PageLogicObj.m_ReSetIntTypeCountFlag="Y";
					UpdateInitTypeCount();
				}else{
					$.messager.popover({msg:'ɾ��ʧ��!'+rtn,type:'error'});
				}
			})
		}
	});
}
function showSubItemExeWin(){
	destroyDialog("NurPlanTaskExecuteDiag");
	var iconCls="icon-w-edit";
	var Content=initDiagDivHtml("ItemNurseExe");
	createModalDialog("NurPlanTaskExecuteDiag",$g("��������ִ��"), 850, 'auto',iconCls,$g("ȷ��"),Content,"saveItemExeTask()");
	InitPatIfoBar(PageLogicObj.m_recordList[0].episodeID);	
	InitExecDefaultData();
	$("label.checkbox, label.radio").css("padding-right:10px;");
	if (ServerObj.QPCCOpenNurTaskTrans =="Y"){
		$("#SureTrans").checkbox("check");
	}
	$("#BDataRefer").click(referHandlerClick);
	InitNursingRecordTemplate();
	
}

function showNoSubItemExeWin(){
	if (PageLogicObj.m_recordList.length == 0 || !PageLogicObj.m_recordList)
	{
		$.messager.popover({msg:'��������ִ�к�������С��ļ�¼��',type:'error'});
		return;
	}
	destroyDialog("NurPlanTaskExecuteDiag");
	var iconCls="icon-w-edit";
	var Content=initDiagDivHtml("NoSubItemNurseExe");
	if (isRepeat(PageLogicObj.m_recordList,"episodeID")){ //�໼������ִ��	
		createModalDialog("NurPlanTaskExecuteDiag",$g("��������ִ��"), 510, 245,iconCls,"ȷ��",Content,"saveNoSubItemExeTask()");
		$(".patInfoBanner_patInfoText,#BDataRefer,#SureTrans,#exeDesc").parent().hide();
		$("#BDataRefer,#SureTrans").parent().parent().hide();
		//$("#BDataRefer").hide();
		$("#exeDesc").val("").hide();
		$("#TdTaskExeResult").css({padding:" 10px 0px 10px 10px"})
		$("#NursingRecordTemplate").parent().css({padding:" 0px 10px 0px 10px;"})
		
	}else{ //����������ִ��
		//createModalDialog("NurPlanTaskExecuteDiag",$g("��������ִ��"), 742, 465,iconCls,$g("ȷ��"),Content,"saveNoSubItemExeTask()");
		if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//�Ų�
			createModalDialog("NurPlanTaskExecuteDiag",$g("��������ִ��"), 742, 489,iconCls,$g("ȷ��"),Content,"saveNoSubItemExeTask()");
	   	}else if((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)){//����
			createModalDialog("NurPlanTaskExecuteDiag",$g("��������ִ��"), 742, 485,iconCls,$g("ȷ��"),Content,"saveNoSubItemExeTask()");
	   	}else{
			createModalDialog("NurPlanTaskExecuteDiag",$g("��������ִ��"), 747, 504,iconCls,$g("ȷ��"),Content,"saveNoSubItemExeTask()");
		}
		InitPatIfoBar(PageLogicObj.m_recordList[0].episodeID);
		if (ServerObj.QPCCOpenNurTaskTrans =="Y"){
			$("#SureTrans").checkbox("check");
		}
		$("#BDataRefer").click(referHandlerClick);
	}
	InitExecDefaultData();
	InitNursingRecordTemplate();
	
}
//ִ��������С��Ļ�������
function saveItemExeTask(){
	var data = [],record = [];
	for (var i=0;i<PageLogicObj.m_exeTaskListJson.result.length;i++){
		var widgetType = PageLogicObj.m_exeTaskListJson.result[i].widgetType;
		var itemId = PageLogicObj.m_exeTaskListJson.result[i].itemId;
		var itemName = PageLogicObj.m_exeTaskListJson.result[i].itemName;
		var itemRequired = PageLogicObj.m_exeTaskListJson.result[i].itemRequired;
		var subItemList = PageLogicObj.m_exeTaskListJson.result[i].data.subItemList;
		var exeNoteList = PageLogicObj.m_exeTaskListJson.result[i].data.exeNoteList;
		var itemValue="";
		var obj={
			itemId:itemId,
			itemValue:""
			//exeNoteList:[],
			//childItemList:[]
		}
		if (widgetType == 5) {
			if (PageLogicObj.m_btnClickRecord[itemId]) {
				$.extend(obj,{exeNoteList:["click"]});
			}else{
				if (itemRequired =="Y"){
					$.messager.popover({msg:itemName+' ��ť����Ҫ�����',type:'error'});
					return;
				}else{
					$.extend(obj,{exeNoteList:exeNoteList});
				}
			}
		}else{
			if (widgetType ==1) { //��ѡ
				$.extend(obj,{childItemList:[],exeNoteList:[]});
				for (var j=0;j<subItemList.length;j++){
					var subItemId=subItemList[j].subItemId;
					var subItemName=subItemList[j].subItemName;
					var subWidgetType=subItemList[j].subWidgetType;
					if ($("input[id='option"+subItemId+"']").radio("getValue")) {
						obj.childItemList.push({
							childId: subItemId,
							childValue: ""
						});
						itemValue=subItemName;
					}
				}
				if ((itemRequired =="Y")&&(obj.childItemList.length ==0)){
					$.messager.popover({msg:itemName+' ��ѡ����һ�',type:'error'});
					return;
				}
			}else if(widgetType ==2){ //��ѡ
				$.extend(obj,{childItemList:[]});
				itemValue=[];
				for (var j=0;j<subItemList.length;j++){
					var subItemId=subItemList[j].subItemId;
					var subItemName=subItemList[j].subItemName;
					var subWidgetType=subItemList[j].subWidgetType;
					if ($("input[id='option"+subItemId+"']").checkbox("getValue")) {
						obj.childItemList.push({
							childId: subItemId,
							childValue: ""
						});
						itemValue.push(subItemName);
					}
				}
				itemValue = itemValue.join();
				if ((itemRequired =="Y")&&(obj.childItemList.length ==0)){
					$.messager.popover({msg:itemName+' ��ѡ����һ�',type:'error'});
					return;
				}
			}else if(widgetType ==3){ //������
				$.extend(obj,{exeNoteList:[],childItemList:[]});
				itemValue=[]; 
				var values=$("#option"+itemId).combobox("getValues");
				for (var j=0;j<values.length;j++){
					obj.childItemList.push({
						childId: values[j],
						childValue: ""
					});
					var index=$.hisui.indexOfArray(subItemList,"subItemId",values[j]);
					var subItemName=subItemList[index].subItemName;
					itemValue.push(subItemName);
				}
				itemValue = itemValue.join();
				if ($("#optionNote"+itemId).length>0) {
					var values=$("#optionNote"+itemId).combobox("getValues");
					for (var j=0;j<values.length;j++){
						obj.exeNoteList.push(values[j]);
					}
				}
				if ((itemRequired =="Y")&&(obj.childItemList.length ==0)){
					$.messager.popover({msg:itemName+' ��ѡ����һ�',type:'error'});
					return;
				}
			}else if(widgetType ==4){ //�ı�
				itemValue=$("#option"+itemId).val();
				if ((itemRequired =="Y")&&(!itemValue)){
					$.messager.popover({msg:itemName+' �������',type:'error'});
					$("#option"+itemId).focus();
					return;
				}
				$.extend(obj,{exeNoteList:[],itemValue:itemValue});
				if ($("#optionNote"+itemId).length>0) {
					var values=$("#optionNote"+itemId).combobox("getValues");
					for (var j=0;j<values.length;j++){
						obj.exeNoteList.push(values[j]);
					}
				}
			}else if(widgetType ==6){ //����
				itemValue=$("#option"+itemId).datebox("getValue");
				if ((itemRequired =="Y")&&(!itemValue)){
					$.messager.popover({msg:itemName+' ���ڱ��',type:'error'});
					$("#option"+itemId).next('span').find('input').focus();
					return;
				}
				$.extend(obj,{exeNoteList:[],itemValue:itemValue}); //formatToUTCTime
			}else if (widgetType == 7) { //ʱ��
				itemValue=$("#option"+itemId).datetimebox("getValue");
				if ((itemRequired =="Y")&&(!itemValue)){
					$.messager.popover({msg:itemName+' ʱ����',type:'error'});
					$("#option"+itemId).next('span').find('input').focus();
					return;
				}
				$.extend(obj,{exeNoteList:[],itemValue:itemValue}); //formatToUTCTime
			}else if(widgetType ==8){ //��ѡ�������
				$.extend(obj,{exeNoteList:[],childItemList:[]});
				itemValue=[];
				for (var j=0;j<subItemList.length;j++){
					var subItemId=subItemList[j].subItemId;
					var subItemName=subItemList[j].subItemName;
					var subWidgetType=subItemList[j].subWidgetType;
					var childValue="";
					if ($("input[id='option"+subItemId+"']").radio("getValue")) {
						if ($("input[id='optionNote"+subItemId+"']").length>0) {
							childValue=$.trim($("input[id='optionNote"+subItemId+"']").val());
						}
						obj.childItemList.push({
							childId: subItemId,
							childValue: childValue
						});
						itemValue.push(subItemName);
						if (childValue){
							itemValue.push(childValue);
						}else{
							if (itemRequired =="Y") {
								$.messager.popover({msg:itemName+' ����д��ѡ������գ�',type:'error'});
								$("input[id='optionNote"+subItemId+"']").focus();
								return false;
							}
						}
					}
				}
				if ((itemRequired =="Y")&&(obj.childItemList.length ==0)){
					$.messager.popover({msg:itemName+' ��ѡ����һ�',type:'error'});
					return;
				}
			}else if(widgetType ==9){ //��ѡ�������
				$.extend(obj,{exeNoteList:[],childItemList:[]});
				itemValue=[];
				for (var j=0;j<subItemList.length;j++){
					var subItemId=subItemList[j].subItemId;
					var subItemName=subItemList[j].subItemName;
					var subWidgetType=subItemList[j].subWidgetType;
					var childValue="";
					if ($("input[id='option"+subItemId+"']").checkbox("getValue")) {
						if ($("input[id='optionNote"+subItemId+"']").length>0) {
							childValue=$.trim($("input[id='optionNote"+subItemId+"']").val());
						}
						obj.childItemList.push({
							childId: subItemId,
							childValue: childValue
						});
						itemValue.push(subItemName);
						if (childValue){
							itemValue.push(childValue);
						}else{
							if (itemRequired =="Y") {
								$.messager.popover({msg:itemName+' ����д��ѡ������գ�',type:'error'});
								$("input[id='optionNote"+subItemId+"']").focus();
								return false;
							}
						}
					}
				}
				if ((itemRequired =="Y")&&(obj.childItemList.length ==0)){
					$.messager.popover({msg:itemName+' ��ѡ����һ�',type:'error'});
					return;
				}
			}else if(widgetType ==10){ //��������
				$.extend(obj,{exeNoteList:[],childItemList:[]});
				itemValue=[];
				for (var j=0;j<subItemList.length;j++){
					var subItemId=subItemList[j].subItemId;
					var subItemName=subItemList[j].subItemName;
					var subWidgetType=subItemList[j].subWidgetType;
					if (subWidgetType =="1") {
						if ($("input[id='option"+subItemId+"']").radio("getValue")) {
							obj.childItemList.push({
								childId: subItemId,
								childValue: ""
							});
							itemValue.push(subItemName);
						}
					}else if(subWidgetType =="2"){
						if ($("input[id='option"+subItemId+"']").checkbox("getValue")) {
							obj.childItemList.push({
								childId: subItemId,
								childValue: ""
							});
							itemValue.push(subItemName);
						}
					}else if(subWidgetType =="4"){ //�ı�
						var optionNotes=$.trim($("input[id='option"+subItemId+"']").val());
						if (optionNotes) {
							obj.childItemList.push({
								childId: subItemId,
								childValue: optionNotes
							});
							itemValue.push(subItemName);
						}
					}else if(subWidgetType =="6"){ //����
						var optionNotes=$.trim($("input[id='option"+subItemId+"']").datebox("getValue"));
						if (optionNotes) {
							obj.childItemList.push({
								childId: subItemId,
								childValue: optionNotes
							});
							itemValue.push(subItemName);
						}
					}else if(subWidgetType =="7"){ //ʱ��
						var optionNotes=$.trim($("input[id='option"+subItemId+"']").datetimebox("getValue"));
						if (optionNotes) {
							obj.childItemList.push({
								childId: subItemId,
								childValue: optionNotes
							});
							itemValue.push(subItemName);
						}
					}else if(subWidgetType =="8"){ //��ѡ�������
						if ($("input[id='option"+subItemId+"']").radio("getValue")) {
							itemValue.push(subItemName);
							var optionNotes=$.trim($("input[id='optionNote"+subItemId+"']").val());
							obj.childItemList.push({
								childId: subItemId,
								childValue: optionNotes
							});
							if (optionNotes){
								itemValue.push(optionNotes);
							}
						}
					}else if(subWidgetType =="9"){ //��ѡ�������
						if ($("input[id='option"+subItemId+"']").checkbox("getValue")) {
							itemValue.push(subItemName);
							var optionNotes=$.trim($("input[id='optionNote"+subItemId+"']").val());
							obj.childItemList.push({
								childId: subItemId,
								childValue: optionNotes
							});
							if (optionNotes){
								itemValue.push(optionNotes);
							}
						}
					}
					if ((itemRequired =="Y")&&(obj.childItemList.length ==0)){
						$.messager.popover({msg:itemName+' ���',type:'error'});
						return;
					}
				}
				itemValue = itemValue.join();
			}
		}
		data.push(obj);
		record.push({
            id: itemId,
            name: itemName.replace(/[\(��].*?[\)��]/g, ""),
            value: itemValue
        });
	}
	var exeDescFlag="";
	var exeDesc=$.trim($("#exeDesc").val());
	var OldExecutedContent=PageLogicObj.m_exeTaskListJson.executedContent;
	
	// У�黤��ִ��ʱ������ 2021.6.25 start 2022.10.14 update
	/*
	var limitHour = getTaskExeTimeLimit(PageLogicObj.m_recordList[0].planDateTime)
	if (limitHour != "")
	{
		var rtn = "����ִ��ʱ�������Ҫ��ʱ��"+limitHour+"Сʱ�ڣ�"
		$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
		return;
	}
	*/
	var Limit = getTaskExeTimeLimit(PageLogicObj.m_recordList[0].planDateTime,PageLogicObj.m_recordList[0].insertDateTime)
	var limitDesc= Limit.split("@")[0];
	var limitMin= Limit.split("@")[1];
	if (Limit != "")
	{
		var rtn = "����ִ��ʱ�������"+limitDesc+"�ƻ�ִ��ʱ��"+limitMin+"�����ڣ�"
		$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
		return;
	}
	// end
	
	if ((OldExecutedContent)&&(OldExecutedContent !=exeDesc)) {
		$.messager.confirm('��ʾ', "ȷ��Ҫ�����ϴ�ִ�м�¼��<br>����ִ�м�¼���ϴβ�ͬ�����潫�����ϴμ�¼��", function(r){
			if (r){
				exeDescFlag=true;
				save();
			}
		});
	}else{
		save();
	}
	function save(){
		var recordData = {
			episodeID: PageLogicObj.m_recordList[0].episodeID,
			locID: session['LOGON.CTLOCID'],
			userID: session['LOGON.USERID'],
			exedate: $("#ExecDate").datebox("getValue"),
			exetime: $("#ExecTime").timespinner("getValue"),
			exeDesc: exeDesc,
			emrRecordId: PageLogicObj.m_recordList[0].emrRecordId,
			record: record,
			//exeDescFlag:exeDescFlag   ����2642890
			exeDescFlag:"true"
		};
		var nurseRecordEntryTplId=""
		var templategrid = $('#NursingRecordTemplate').combogrid("grid");
		var templaterowdata = templategrid.datagrid('getSelected');
		if (!((templaterowdata==null)||(templaterowdata.length == 0))){
			var nurseRecordEntryTplId=templaterowdata.nurseRecordEntryTplId;
		}
		$.cm({
			ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
			MethodName:"ExecuteTask",
			userId:session['LOGON.USERID'],
			taskRecordId:PageLogicObj.m_recordList[0].recordId,
			executedContent:$("#exeDesc").val(),
			taskJson:JSON.stringify(data),
			transferFlag:$("#SureTrans").checkbox("getValue") ? 1 : "",
			locID:session['LOGON.CTLOCID'],
			recordData:JSON.stringify(recordData),
			hospDR:session['LOGON.HOSPID'],
			sessionArrayJson:GetSessionInfo(),
			nurseRecordEntryTplId:nurseRecordEntryTplId,
			dataType:"text"
		},function(rtn){
			if (rtn ==0) {
				bakPatInfoBanner();
				destroyDialog("NurPlanTaskExecuteDiag");
				$("#NurPlanTaskTab").datagrid("load");	
				// ���� 2922747
				//PageLogicObj.m_ReSetIntTypeCountFlag="Y";	

			}else{
				$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
			}
		})
	}
}
// ����ִ��û��С��Ļ�������
function saveNoSubItemExeTask(){
	
	//var exeDescFlag="";
	var exeDescChangeFlag="N";
	var exeDesc=$("#exeDesc").val();
	var dataList = [];
	var length=PageLogicObj.m_recordList.length;
	if (length > 1) {
		var exeDescArr=[];
		for (var i=0;i<PageLogicObj.m_recordList.length;i++){
		// У�黤��ִ��ʱ������ 2021.6.25 start 2022.10.14 update
		/*
		var limitHour = getTaskExeTimeLimit(PageLogicObj.m_recordList[0].planDateTime)
		if (limitHour != "")
		{
			var rtn = "����ִ��ʱ�������Ҫ��ʱ��"+limitHour+"Сʱ�ڣ�"
			$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
			return;
		}
		*/
		var Limit = getTaskExeTimeLimit(PageLogicObj.m_recordList[0].planDateTime,PageLogicObj.m_recordList[0].insertDateTime)
		var limitDesc= Limit.split("@")[0];
		var limitMin= Limit.split("@")[1];
		if (Limit != "")
		{
			var rtn = "����ִ��ʱ�������"+limitDesc+"�ƻ�ִ��ʱ��"+limitMin+"�����ڣ�"
			$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
			return;
		}
		// end
			
			var executeContent=PageLogicObj.m_recordList[i].executeContent;
			var executeItemName=PageLogicObj.m_recordList[i].executeItemName;
			exeDescArr.push(executeContent || executeItemName);
		}
		//var executedContent=exeDescArr.join("&#13;");
		var executedContent=exeDescArr.join("  ");
		// ��ѡ����ִ�� ��ʾbug fix start
		var executedContent2 = exeDescArr.join("\n");
		if ((executedContent2)&&(executedContent2!=exeDesc)&&(!(isRepeat(PageLogicObj.m_recordList,"episodeID")))){
			exeDescChangeFlag="Y";
		}
		// ��ѡ����ִ�� ��ʾbug fix end
	}else{
		
		// У�黤��ִ��ʱ������ 2021.6.25 start 2022.10.14 update
		/*
		var limitHour = getTaskExeTimeLimit(PageLogicObj.m_recordList[0].planDateTime)
		if (limitHour != "")
		{
			var rtn = "����ִ��ʱ�������Ҫ��ʱ��"+limitHour+"Сʱ�ڣ�"
			$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
			return;
		}
		*/
		var Limit = getTaskExeTimeLimit(PageLogicObj.m_recordList[0].planDateTime,PageLogicObj.m_recordList[0].insertDateTime)
		var limitDesc= Limit.split("@")[0];
		var limitMin= Limit.split("@")[1];
		if (Limit != "")
		{
			if(Limit=="false"){
				var rtn = "�޸�ʱ�䳬��������ʼʱ���ϵͳ��ǰʱ�䣡"
				$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
				return;				
			}else{
				var rtn = "����ִ��ʱ�������"+limitDesc+"�ƻ�ִ��ʱ��"+limitMin+"�����ڣ�"
				$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
				return;	
			}
		}
		// end

		var executedContent=PageLogicObj.m_recordList[0].executedContent;
		if ((executedContent)&&(executedContent!=exeDesc)){
			exeDescChangeFlag="Y";
		}
	}	

	if (exeDescChangeFlag =="Y"){
		$.messager.confirm('��ʾ', "ȷ��Ҫ�����ϴ�ִ�м�¼��<br>����ִ�м�¼���ϴβ�ͬ�����潫�����ϴμ�¼��", function(r){
			if (r){
				saveExeTask();
			}
		});
		return;
	}
	saveExeTask();
	function saveExeTask(){
		for (var i=0;i<length;i++){
			var elem=PageLogicObj.m_recordList[i];
			var recordData = {
				episodeID: elem.episodeID,
				locID:session['LOGON.CTLOCID'],
				userID:session['LOGON.USERID'],
				exedate: $("#ExecDate").datebox("getValue"),
				exetime: $("#ExecTime").timespinner("getValue"),
				exeDesc: $("#exeDesc").val(),
				emrRecordId: elem.emrRecordId,
				exeDescFlag: true,
				record: []
			};
			dataList.push({
				taskRecordId: elem.recordId,
				executedContent: $("#exeDesc").val(),
				taskJson: [],
				recordData: recordData
			});
		}
		var nurseRecordEntryTplId=""
		var templategrid = $('#NursingRecordTemplate').combogrid("grid");
		var templaterowdata = templategrid.datagrid('getSelected');
		if (!((templaterowdata==null)||(templaterowdata.length == 0))){
			var nurseRecordEntryTplId=templaterowdata.nurseRecordEntryTplId;
		}
		$.cm({
			ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
			MethodName:"ExecuteNoSubItemTaskList",
			userId:session['LOGON.USERID'],
			transferFlag:$("#SureTrans").checkbox("getValue") ? 1 : "",
			locID:session['LOGON.CTLOCID'],
			recordList:JSON.stringify(dataList),
			hospDR:session['LOGON.HOSPID'],
			sessionArrayJson:GetSessionInfo(),
			nurseRecordEntryTplId:nurseRecordEntryTplId,
			dataType:"text"
		},function(rtn){
			if (rtn ==0) {
				bakPatInfoBanner();
				destroyDialog("NurPlanTaskExecuteDiag");
				$("#NurPlanTaskTab").datagrid("load");
				// ���� 2922747
				//PageLogicObj.m_ReSetIntTypeCountFlag="Y";

			}else{
				$.messager.popover({msg:'ִ��ʧ�ܣ�'+rtn,type:'error'});
			}
		})
	}
}

// 2021.6.25 ����ִ��ʱ������
function getTaskExeTimeLimit(planDateTime,insertDateTime)
{
	/*
	var exedate = $("#ExecDate").datebox("getValue");
	var exetime = $("#ExecTime").timespinner("getValue");
	var how = new Date(planDateTime.replace(/-/g,'/'));
	var date2 = (exedate + " " + exetime).replace(/-/g,'/')
	var newdate = new Date(date2)
	var cha = parseInt((newdate.getTime() - how.getTime()) / 1000 / 60);
	//ͬ�������෽�� ,������ʹ��
	var retHour = $m({
		ClassName:"CF.NUR.NIS.QPCommonConfig",
		MethodName:"GetTaskLimitHour",
		Hospital:session['LOGON.HOSPID']
	},false);
	// demo��û����������ʱ�� ǰ̨���� bug fix
	if (retHour == "") return "";
	var lmitmin = retHour*60
	var cha2 = Math.abs(cha)
	if (cha2 > lmitmin)
	{
		return retHour; // ��������
	}
	return ""
	*/
	// 2022.10.14 update 
	var plandatetime = new Date(planDateTime.replace(/-/g,'/'));
	var exedate = $("#ExecDate").datebox("getValue");
	var exetime = $("#ExecTime").timespinner("getValue");
	var exeDateTime= exedate + " " + exetime;
	var exedatetime = new Date(exeDateTime.replace(/-/g,'/'));
	var insertDateTime = new Date(insertDateTime.replace(/-/g,'/'));
	
	var QPCCInterventionLimit=ServerObj.QPCCInterventionLimit;
	if ((ServerObj.QPCCInterventionTime==0)||(ServerObj.QPCCInterventionTime=="")||(ServerObj.QPCCInterventionTime=="N")){
		//��������ã���֧�ֻ���ִ��ʱ�������Χ����ϵͳ��ǰʱ���뻤����ʼʱ��֮��
		var rtn=TimeMinuteComparison(exedatetime,insertDateTime,new Date());
		if (!rtn)
		{
			return "false"; // ��������
		}
	}else{
		// Լ���ڡ���������ִ�С������С�ִ��ʱ�䡱�޸ķ�Χ
		var lmitmin = ServerObj.QPCCInterventionTime*1;
		if ((QPCCInterventionLimit=="����")||(QPCCInterventionLimit=="Early")){
			var beginTime=new Date(plandatetime.getTime()-(lmitmin*60*1000));		
			var rtn=TimeMinuteComparison(exedatetime,beginTime,plandatetime);
		}else if((QPCCInterventionLimit=="����")||(QPCCInterventionLimit=="Later")){
			var endTime=new Date(plandatetime.getTime()+(lmitmin*60*1000));		
			var rtn=TimeMinuteComparison(exedatetime,plandatetime,endTime);
		}else if ((QPCCInterventionLimit=="���ڻ�����")||(QPCCInterventionLimit=="EarlyOrLater")){
			var beginTime=new Date(plandatetime.getTime()-(lmitmin*60*1000));
			var endTime=new Date(plandatetime.getTime()+(lmitmin*60*1000));
			var rtn=TimeMinuteComparison(exedatetime,beginTime,endTime);		
		}
		if (!rtn)
		{
			return QPCCInterventionLimit+"@"+lmitmin; // ��������
		}		
	}
	return "" //δ�������Ʒ�Χ
	
}
function TimeMinuteComparison(time,beginTime ,endTime ) {
	if((time instanceof Date)||(beginTime instanceof Date)||(endTime instanceof Date)){
		var a =(Date.parse(time)-Date.parse(beginTime))/3600/1000;
	    var b =(Date.parse(time)-Date.parse(endTime))/3600/1000; 
	}else{
		var times=time.replace(/-/g,"/");
		var beginTimes =beginTime.replace(/-/g,"/");
	    var endTimes =endTime.replace(/-/g,"/");
		var a =(Date.parse(times)-Date.parse(beginTimes))/3600/1000;
	    var b =(Date.parse(times)-Date.parse(endTimes))/3600/1000; 	
	}
    if ((a>=0)&(b<=0)) return true;
    return false;
}

/**
 * 1.���ݻ��������ȡ����С��
 * 2.������չʾ��������С��
 * 3.����jquery������
 * 4.��������С�ֵ
 * 5.ִ��ʱ�䡢��ʿ��ִ�н������Ĭ��ֵ��ֵ
 */
function InitExecDefaultData(){
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		MethodName:"GetExecuteTaskList",
		taskRecordId:PageLogicObj.m_recordList[0].recordId,
		interventionDR:PageLogicObj.m_recordList[0].interventionDR,
		userId:session['LOGON.USERID'],
		hospid:session['LOGON.HOSPID'],
	},function(JsonData){
		PageLogicObj.m_positionArr=[]; 
		PageLogicObj.m_exeTaskListJson=JsonData;
		//������չʾ��������С��
		var result=JsonData.result;
		var html="";
		// 1��ѡ��ť,2��ѡ��,3�����˵�,4�ı���,5button,6����,7ʱ��,8��ѡ�������,9��ѡ�������,10�������� 
		if((result!=undefined)&&(result!="")&&(result!=null)){
			for (var i=0;i<result.length;i++){
				var widgetType = result[i].widgetType;
				var itemId = result[i].itemId;
				var itemName = result[i].itemName;
				var itemValue = result[i].itemValue;
				if (!itemValue) itemValue="";
				var positionId = result[i].positionId; //�ڻ��������е�ռλ��
				var itemRequired = result[i].itemRequired; //�Ƿ���� demo��ʩ������������
				var subItemList = result[i].data.subItemList;
				if ((subItemList)&&(subItemList.length>0)){
					subItemList = subItemList.sort(compare("subItemSortNo"));
				}
				var newItemName = itemName;
				if (itemRequired =="Y") {
					newItemName='<span class="clsRequired">*</span>'+itemName;
				}
				var childItemList=result[i].data.childItemList;
				var noteList = result[i].data.noteList;
				html+="<div class='form-item'>";
				if ((widgetType ==1)||(widgetType ==2)){// ��ѡ/��ѡ
					html+="<div class='form-item-label'><label for='option"+itemId+"' title='"+itemName+"'>"+newItemName+"</label></div>";					
					html+="<div class='form-item-control-wrapper'>";
					for (var j=0;j<subItemList.length;j++){
						var subItemId=subItemList[j].subItemId;
						var subItemDesc=subItemList[j].subItemDesc;
						var subItemName=subItemList[j].subItemName;
						var subPositionId=subItemList[j].subPositionId;
						var subWidgetType=subItemList[j].subWidgetType;
						if (widgetType ==1){
							html+='<input class="hisui-radio" type="radio" name="radio'+itemId+'" title="'+subItemDesc+'" label="'+subItemName+'" id="option'+subItemId+'"></input>';
						}else{
							html+='<input class="hisui-checkbox" type="checkbox"  title="'+subItemDesc+'" label="'+subItemName+'" id="option'+subItemId+'"></input>';
						}
						if (subPositionId) {
							var positionName="";
							if ((childItemList)&&($.hisui.indexOfArray(childItemList,"childId",subItemId)>=0)){
								positionName=subItemName;
							}
							PageLogicObj.m_positionArr.push({
								positionId:subPositionId,
								positionName:positionName,
								itemId:subItemId,
								itemName:subItemName,
								itemWidgetType:subWidgetType
							})
						}
					}
					html+="</div>";
				}else if ((widgetType ==3)||(widgetType ==4)){ //3�����˵�,4�ı���
					html+="<div class='form-item-label'><label title='"+itemName+"'>"+newItemName+"</label></div>";
						html+='<div class="form-item-control-wrapper">';
					var style="width:"+(noteList.length ? "110px;" : "225px;") + "margin-right:"+ (noteList.length ? "5px;" : "0;");
					if (widgetType ==3){
						style+="width:115px;"
						html+='<select id="option'+itemId+'" class="hisui-combobox textbox" style="'+style+'">'; 
						for (var j=0;j<subItemList.length;j++){
							var subItemId=subItemList[j].subItemId;
							var subItemDesc=subItemList[j].subItemDesc;
							var subItemName=subItemList[j].subItemName;
							var subPositionId=subItemList[j].subPositionId;
							var subWidgetType=subItemList[j].subWidgetType;
							html+='<option value="'+subItemId+'">'+subItemName+'</option>';
							if (subPositionId) {
								var positionName="";
								if ((childItemList)&&($.hisui.indexOfArray(childItemList,"childId",subItemId)>=0)){
									positionName=subItemName;
								}
								PageLogicObj.m_positionArr.push({
									positionId:subPositionId,
									positionName:positionName,
									itemId:subItemId,
									itemName:subItemName,
									itemWidgetType:subWidgetType
								})
							}
						}
						html+='</select>';
					}else{
						html+='<input id="option'+itemId+'" class="textbox form-item-text" style="'+style+'"></input>'
						if (positionId) {
							PageLogicObj.m_positionArr.push({
								positionId:positionId,
								positionName:itemValue,
								itemId:itemId,
								itemName:itemName,
								itemWidgetType:widgetType
							})
						}
					}
					if ((noteList)&&(noteList.length>0)) {
						html+='<select id="optionNote'+itemId+'" class="hisui-combobox textbox" style="'+style+'">'
						for (var j=0;j<noteList.length;j++){
							html+='<option selected="" value="'+noteList[j]+'">'+noteList[j]+'</option>';
						}
						html+='</select>';
					}
					html+='</div>';
				}else if (widgetType ==5){ //button
					html+="<div class='form-item-label'><label title='"+itemName+"'>"+newItemName+"</label></div>";
					var itemUrl =window.location.href.split("/csp/")[0] +
					"/" + result[i].itemUrl +
					"&EpisodeID=" + PageLogicObj.m_recordList[0].episodeID;

					html+='<div class="form-item-control-wrapper"><a href="#" ��nClick="openNewWindow(\'' + itemUrl + '\',\'' + itemId + '\')" class="hisui-linkbutton">'+itemName+'</a></div>'
				}else if ((widgetType ==6)||(widgetType ==7)){ //6����,7ʱ��
					html+="<div class='form-item-label'><label title='"+itemName+"'>"+newItemName+"</label></div>";
					html+='<div class="form-item-control-wrapper">';
					if (widgetType ==6){
						html+='<input for="option'+itemId+'" class="hisui-datebox textbox form-item-datebox" style="width: 120px;margin-right:5px;"></input>';
					}else{
						html+='<input for="option'+itemId+'" class="hisui-datetimebox textbox" data-options="showSeconds:false" style="width: 160px;"></input>';
					}
					html+='</div>';
					if (positionId) {
						if (widgetType ==6){
							var positionName=itemValue?(myformatter(formatUTC(itemValue))):"";
						}else{
							var positionName=itemValue?(formatUTCToTime(itemValue)):"";
						}
						PageLogicObj.m_positionArr.push({
							positionId:positionId,
							positionName:positionName,
							itemId:itemId,
							itemName:itemName,
							itemWidgetType:widgetType
						})
					}
				}else if (widgetType ==8){ // 8��ѡ�������
					html+="<div class='form-item-label'><label title='"+itemName+"'>"+newItemName+"</label></div>";
					html+='<div class="form-item-control-wrapper">';
						html+='<input class="hisui-radio" type="radio" name="radio'+itemId+'" title="'+itemName+'" label="'+itemName+'" id="option'+itemId+'"></input>';
						html+='<input id="optionNote'+itemId+'" class="textbox form-item-text" style="margin-left:5px;width:110px;"></input>'
					html+='</div>';
					if (positionId) {
						var positionName="";
						if (childItemList.length >0) {
							positionName=childItemList[0].childValue;
						}
						PageLogicObj.m_positionArr.push({
							positionId:positionId,
							positionName:positionName,
							itemId:itemId,
							itemName:itemName,
							itemWidgetType:widgetType
						})
					}
				}else if (widgetType ==9){ //9��ѡ�������
					html+="<div class='form-item-label'><label title='"+itemName+"'>"+newItemName+"</label></div>";
					html+='<div class="form-item-control-wrapper">';
						html+='<input class="hisui-checkbox" type="checkbox"  title="'+itemName+'" label="'+itemName+'" id="option'+itemId+'"></input>';
						html+='<input id="optionNote'+itemId+'" class="textbox form-item-text" style="margin-left:5px;width:110px;"></input>'
					html+='</div>';
					if (positionId) {
						var positionName="";
						if (childItemList.length >0) {
							positionName=childItemList[0].childValue;
						}
						PageLogicObj.m_positionArr.push({
							positionId:positionId,
							positionName:positionName,
							itemId:itemId,
							itemName:itemName,
							itemWidgetType:widgetType
						})
					}
				}else if (widgetType ==10){ //10�������� 
					html+="<div class='form-item-label'><label title='"+itemName+"'>"+newItemName+"</label></div>";
					html+='<div class="form-item-control-wrapper">';	
					for (var j=0;j<subItemList.length;j++){
						var subItemId=subItemList[j].subItemId;
						var subItemDesc=subItemList[j].subItemDesc;
						var subItemName=subItemList[j].subItemName;
						var subWidgetType=subItemList[j].subWidgetType;
						var subPositionId=subItemList[j].subPositionId;
						var index=$.hisui.indexOfArray(childItemList,"childId",subItemId);
						var positionName="";
						if (subWidgetType ==1){
							html+='<input class="hisui-radio" type="radio" name="radio'+itemId+'" title="'+subItemDesc+'" label="'+subItemName+'" id="option'+subItemId+'"></input>';
						}else if (subWidgetType ==2){
							html+='<input class="hisui-checkbox" type="checkbox"  title="'+subItemDesc+'" label="'+subItemName+'" id="option'+subItemId+'"></input>';
						}else if (subWidgetType ==4){
							html+='<input id="option'+subItemId+'" class="textbox" style="margin-right:10px;"></input>';
							if (index>=0) positionName=childItemList[index].childValue;
						}else if (subWidgetType ==6){
							html+='<input id="option'+subItemId+'" class="hisui-datebox textbox form-item-datebox" style="width: 120px;margin-right:5px;"></input>';
							if (index>=0) positionName=childItemList[index].childValue?(myformatter(formatUTC(childItemList[index].childValue))):"";
						}else if (subWidgetType ==7){
							html+='<input id="option'+subItemId+'" class="hisui-datetimebox textbox" data-options="showSeconds:false" style="width: 160px;"></input>';
							if (index>=0) positionName=childItemList[index].childValue?(formatUTCToTime(childItemList[index].childValue)):"";
						}else if (subWidgetType ==8){
							html+='<input class="hisui-radio" type="radio" name="radio'+itemId+'" title="'+subItemDesc+'" label="'+subItemName+'" id="option'+subItemId+'"></input>';
							html+='<input id="optionNote'+subItemId+'" class="textbox form-item-text" style="margin-left:5px;width:110px;"></input>'
						}else if (subWidgetType ==9){
							html+='<input class="hisui-checkbox" type="checkbox"  title="'+subItemDesc+'" label="'+subItemName+'" id="option'+subItemId+'"></input>';
							html+='<input id="optionNote'+subItemId+'" class="textbox form-item-text" style="margin-left:5px;width:110px;"></input>'
						}
						if (subPositionId) {
							PageLogicObj.m_positionArr.push({
								positionId:subPositionId,
								positionName:positionName,
								itemId:subItemId,
								itemName:subItemName,
								itemWidgetType:subWidgetType
							})
						}
					}
					html+='</div>';
				}
				html+="</div>";
			}
			$("#SubItem-div").append(html);
			$HUI.radio("#SubItem-div .hisui-radio",{});
			$HUI.checkbox("#SubItem-div .hisui-checkbox",{});
			$HUI.linkbutton("#SubItem-div .hisui-linkbutton",{});
			$HUI.datebox(".form-item-datebox",{}); //hisui-datebox
			$HUI.datetimebox(".hisui-datetimebox",{});
			$HUI.combobox("#SubItem-div .hisui-combobox",{});
			// ��ִ��С�ֵ
			for (var i=0;i<result.length;i++){
				var widgetType = result[i].widgetType;
				var itemId = result[i].itemId;
				var itemName = result[i].itemName;
				var subItemList = result[i].data.subItemList;
				var childItemList=result[i].data.childItemList;
				var exeNoteList=result[i].data.exeNoteList;
				var positionId = result[i].positionId; //�ڻ��������е�ռλ��
				if (widgetType ==1) {
					if (childItemList.length >0) {
						var itemValue=childItemList[0].childId;
						$("input[id='option"+itemValue+"']").radio("check");
					}
				}else if(widgetType ==2){
					for (var j=0;j<childItemList.length;j++){
						var itemValue=childItemList[j].childId;
						$("input[id='option"+itemValue+"']").checkbox("check");
					}
				}else if(widgetType ==3){
					$("#option"+itemId).combobox("select","");
					var values=[];
					for (var j=0;j<childItemList.length;j++){
						var itemValue=childItemList[j].childId;
						values.push(itemValue);
					}
					$("#option"+itemId).combobox("setValues",values);
					// ����С�עѡ��
					if (exeNoteList) {
						$("#optionNote"+itemId).combobox("select","");
						values=[];
						for (var j=0;j<exeNoteList.length;j++){ 
							var itemValue=exeNoteList[j];
							values.push(itemValue);
						}
						$("#optionNote"+itemId).combobox("setValues",values);
					}
				}else if(widgetType ==4){
					$("#option"+itemId).val(result[i].itemValue);
					// ����С�עѡ��
					if (exeNoteList) {
						$("#optionNote"+itemId).combobox("select","");
						var values=[];
						for (var j=0;j<exeNoteList.length;j++){ 
							var itemValue=exeNoteList[j];
							values.push(itemValue);
						}
						$("#optionNote"+itemId).combobox("setValues",values);
					}
				}else if(widgetType ==5){

				}else if(widgetType ==6){
					$("#option"+itemId).datebox("setValue",result[i].itemValue?(myformatter(formatUTC(itemValue))):"");
				}else if(widgetType ==7){
					$("#option"+itemId).datetimebox("setValue",result[i].itemValue?(formatUTCToTime(itemValue)):"");
				}else if(widgetType ==8){
					if (childItemList.length >0) { //radio�ĸ�ֵ
						var childId=childItemList[0].childId;
						$("#option"+childId).radio("check");
						if ($("input[id='optionNote"+childId+"']").length >0) {
							var childValue=childItemList[0].childValue;
							$("input[id='optionNote"+childId+"']").val(childValue);
						}
					}
				}else if(widgetType ==9){
					if (childItemList.length >0) { //checkbxo�ĸ�ֵ
						var childId=childItemList[0].childId;
						$("#option"+childId).checkbox("check");
						if ($("input[id='optionNote"+childId+"']").length >0) {
							var childValue=childItemList[0].childValue;
							$("input[id='optionNote"+childId+"']").val(childValue);
						}
					}
				}else if(widgetType ==10){
					for (var j=0;j<subItemList.length;j++){
						var subItemId=subItemList[j].subItemId;
						var subItemName=subItemList[j].subItemName;
						var subWidgetType=subItemList[j].subWidgetType;
						var index=$.hisui.indexOfArray(childItemList,"childId",subItemId);
						if (index>=0) {
							if (subWidgetType ==1){
								$("input[id='option"+subItemId+"']").radio("check");
							}else if(subWidgetType ==2){
								$("input[id='option"+subItemId+"']").checkbox("check");
							}else if(subWidgetType ==4){
								$("input[id='option"+subItemId+"']").val(childItemList[index].childValue);
							}else if(subWidgetType ==6){
								$("input[id='option"+subItemId+"']").datebox("setValue",childItemList[index].childValue?(myformatter(formatUTC(childItemList[index].childValue))):"");
							}else if(subWidgetType ==7){
								$("input[id='option"+subItemId+"']").datetimebox("setValue",childItemList[index].childValue?(formatUTCToTime(childItemList[index].childValue)):"");
							}else if(subWidgetType ==8){
								$("input[id='option"+subItemId+"']").radio("check");
								$("input[id='optionNote"+subItemId+"']").val(childItemList[index].childValue);
							}else if(subWidgetType ==9){
								$("input[id='option"+subItemId+"']").checkbox("check");
								$("input[id='optionNote"+subItemId+"']").val(childItemList[index].childValue);
							}
						}
					}
				}
			}
			// ����С���¼�����,�����滻ִ�н�������е�ռλ�������Ƶ�ѡ�������/��ѡ������ն�Ӧ�༭���Ƿ�ɱ༭
			$("#SubItem-div .hisui-radio").radio({
				onCheckChange:function(e,value){
					var id=e.target.id;
					id=id.replace("optionNote","").replace("option","");
					// ������������Ƿ�ɱ༭
					if ($("input[id='optionNote"+id+"']").length >0){
						if (value) {
							$("input[id='optionNote"+id+"']").focus().removeAttr("disabled")
						}else{
							$("input[id='optionNote"+id+"']").val("").attr("disabled","disabled");
						}
					}
					// �滻ռλ��
					var index=$.hisui.indexOfArray(PageLogicObj.m_positionArr,"itemId",id);
					if (index>=0) {
						var itemWidgetType=PageLogicObj.m_positionArr[index].itemWidgetType;
						if (itemWidgetType ==8){
							var replaceContent=$("input[id='optionNote"+id+"']").val();
						}else{
							var replaceContent=value?PageLogicObj.m_positionArr[index].itemName:"";
						}
						replaceExeDesc(id,replaceContent);
					}
				}
			})
			$("#SubItem-div .hisui-checkbox").checkbox({
				onCheckChange:function(e,value){
					var id=e.target.id;
					id=id.replace("optionNote","").replace("option","");
					// ������������Ƿ�ɱ༭
					if ($("input[id='optionNote"+id+"']").length >0){
						if (value) {
							$("input[id='optionNote"+id+"']").focus().removeAttr("disabled")
						}else{
							$("input[id='optionNote"+id+"']").val("").attr("disabled","disabled");
						}
					}
					// �滻ռλ��
					var index=$.hisui.indexOfArray(PageLogicObj.m_positionArr,"itemId",id);
					if (index>=0) {
						var itemWidgetType=PageLogicObj.m_positionArr[index].itemWidgetType;
						if (itemWidgetType ==9){
							var replaceContent=$("input[id='optionNote"+id+"']").val();
						}else{
							var replaceContent=value?PageLogicObj.m_positionArr[index].itemName:"";
						}
						replaceExeDesc(id,value?PageLogicObj.m_positionArr[index].itemName:"");
					}
				}
			})
			$(".form-item-datebox").datebox({
				onChange: function(newValue, oldValue){
					var id=$(this).attr("for");
					id=id.replace("optionNote","").replace("option","");
					replaceExeDesc(id,newValue);
				}
			})
			$(".hisui-datetimebox").datetimebox({
				onChange: function(newValue, oldValue){
					var id=$(this).attr("for");
					id=id.replace("optionNote","").replace("option","");
					replaceExeDesc(id,newValue);
				}
			})
			$("#SubItem-div .hisui-combobox").combobox({
				onSelect:function(rec){
					if (rec) {
						replaceExeDesc(rec.value,rec.text);
					}
				}
			})
			$(".form-item-text").keyup(function(e){
				var id=e.target.id;
				id=id.replace("optionNote","").replace("option","");
				// �滻ռλ��
				var index=$.hisui.indexOfArray(PageLogicObj.m_positionArr,"itemId",id);
				if (index>=0) {
					replaceExeDesc(id,$("input[id='"+e.target.id+"']").val());
				}
			})
		}
		// ִ��ʱ�䡢ִ�л�ʿ��ִ�н������ ��ֵ
		var executeDateTime=JsonData.executeDateTime;
		var planDateTime=JsonData.planDateTime;
		var QPCCInterventionShowTime=ServerObj.QPCCInterventionShowTime;

		if (executeDateTime){
			$("#ExecDate").datebox("setValue",executeDateTime.split(" ")[0]);
			$("#ExecTime").timespinner("setValue",executeDateTime.split(" ")[1]);
		}else{
			if (QPCCInterventionShowTime=="Exe"){
				if (planDateTime){
					$("#ExecDate").datebox("setValue",planDateTime.split(" ")[0]);
					$("#ExecTime").timespinner("setValue",planDateTime.split(" ")[1]);
				}
			}else if(QPCCInterventionShowTime=="Now"){
				var now=new Date();
				var nowDateTime=now.getFullYear()+"-"+(now.getMonth()+1)+"-"+now.getDate()+" "+now.getHours()+":"+now.getMinutes()+":"+now.getSeconds();
				if (nowDateTime){
					$("#ExecDate").datebox("setValue",nowDateTime.split(" ")[0]);
					$("#ExecTime").timespinner("setValue",nowDateTime.split(" ")[1]);
				}
			}		
		}
		$("#ExecUser").val(JsonData.executeUser);
		// update 2021.6.28 start
		if (PageLogicObj.m_recordList.length ==1) {
			var finalDefaultShowStr = ""
			// �Ѿ�����������
			if (JsonData.executedContent && JsonData.executedContent !=""){
				finalDefaultShowStr = JsonData.executedContent
			}else{
				// ����������ļ�¼
				if (result&&result.length>0){
					finalDefaultShowStr = JsonData.executeTemplate
					//����(��ɾ����)������ļ�¼ ����������δ���õ����
					if (finalDefaultShowStr==undefined){						
						//alert("undefined")
						$.messager.popover({msg:'���黤���������ã�!',type:'error'});
						finalDefaultShowStr = PageLogicObj.m_recordList[0].executeItemName						
					}   	
				}else
				{
					// û��������ļ�¼
					finalDefaultShowStr = PageLogicObj.m_recordList[0].executeItemName
				}
			}		
			
			$("#exeDesc").val(finalDefaultShowStr); // ��׼�������죺JsonData.executedContent => JsonData.executeTemplate --zhangxiangbo ������ 2021.05
					
		// end
		}else{
			var exeDescArr=[];
			for (var i=0;i<PageLogicObj.m_recordList.length;i++){
				var executeContent=PageLogicObj.m_recordList[i].executeContent;
				var executeItemName=PageLogicObj.m_recordList[i].executeItemName;
				exeDescArr.push(executeContent || executeItemName);
			}
			//$("#exeDesc").html(exeDescArr.join("&#13;"));
			// �����3394545
			if (ServerObj.QPCCNurExecuteTransCommon=="Y"){
				$("#exeDesc").html(JsonData.executedContent);
			}else{
				$("#exeDesc").html(exeDescArr.join("  "));	
			}
		}
	})
}
/**
 * PageLogicObj.m_positionArr.push({
		positionId:[parseInt(subPositionId)],
		itemId:subItemId,
		itemName:subItemName,
		itemWidgetType:subWidgetType,
		positionName:positionName //ռλ���滻����
	});
 */
// �滻ִ�н���е���������(�滻����С��id,�滻����)
function replaceExeDesc(replaceItemId,replaceContent){
	var index=$.hisui.indexOfArray(PageLogicObj.m_positionArr,"itemId",replaceItemId);
	if (index>=0) {
		PageLogicObj.m_positionArr[index].positionName=replaceContent;
		var i=0;
		$.grep(PageLogicObj.m_positionArr,function(em){
			if ((em.positionId == PageLogicObj.m_positionArr[index].positionId)&&(em.itemId !=replaceItemId)&&(em.itemWidgetType!=2)) {
				PageLogicObj.m_positionArr[i].positionName="";
			}
			i++;
        });
		var replacepositionIdArr=[];
		var executeTemplate=PageLogicObj.m_exeTaskListJson.executeTemplate;
		for (var i=0;i<PageLogicObj.m_positionArr.length;i++){
			var positionId=PageLogicObj.m_positionArr[i].positionId;
			if (replacepositionIdArr[positionId]) continue;
			var positionName=PageLogicObj.m_positionArr[i].positionName;
			var itemId=PageLogicObj.m_positionArr[i].itemId;
			if ((executeTemplate.split("["+positionId+"]").length-1) ==1){
				for (var j=(i+1);j<PageLogicObj.m_positionArr.length;j++){
					if ((PageLogicObj.m_positionArr[j].positionId ==positionId)&&(PageLogicObj.m_positionArr[j].positionName)){
						positionName += PageLogicObj.m_positionArr[j].positionName;
						replacepositionIdArr[positionId]=1;
					}
				}
			}
			executeTemplate=executeTemplate.replace("["+parseInt(positionId)+"]",positionName);
		}
		$("#exeDesc").val(executeTemplate);
	}
}
function openNewWindow(url, itemId){
	PageLogicObj.m_btnClickRecord[itemId]=1;
	if (url) {
		websys_showModal({
			url:url,
			title:'',
			width:'80%',height:'80%'
		});
    }
}
//ִ�б�ע����
function showExeNoteWin(){
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ���¼��',type:'error'});
		return false;
	}
	destroyDialog("NurPlanTaskExecuteDiag");
	var Content=initDiagDivHtml("ExeNote");
    var iconCls="icon-w-edit";
    createModalDialog("NurPlanTaskExecuteDiag",$g("ִ�б�ע"), 350, 127,iconCls,$g("ȷ��"),Content,"saveExeNote()");
	$("#ExeNoteList").combobox({
		multiple:false,
		selectOnNavigation:true,
		valueField:'value',
		textField:'text', 
		data:eval("("+ServerObj.ExecuteNoteJson+")")
	});
	$('#ExeNoteList').next('span').find('input').focus();
}
function saveExeNote(){
	var ExecuteNote=$("#ExeNoteList").combobox("getText");
	if (!ExecuteNote) {
		$.messager.popover({msg:'��ѡ��ִ�б�ע��',type:'error'});
		return false;
	}
	var taskRecordIdArr=[];
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	for (var i=0;i<sels.length;i++){
		var taskRecordId=sels[i].recordId;
		if (!taskRecordId) continue;
		taskRecordIdArr.push(taskRecordId);
	}
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		MethodName:"ExecuteNote",
		userId:session['LOGON.USERID'],
		taskRecordId:taskRecordIdArr.join("^"),
		executedNote:ExecuteNote,
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			destroyDialog("NurPlanTaskExecuteDiag");
			for (var i=0;i<taskRecordIdArr.length;i++){
				var index=$('#NurPlanTaskTab').datagrid("getRowIndex",taskRecordIdArr[i]);
				$('#NurPlanTaskTab').datagrid('updateRow',{
					index: index,
					row: {
						executeNote: ExecuteNote
					}
				});
			}
		}else{
			$.messager.popover({msg:'ִ�б�ע����ʧ�ܣ�!'+rtn,type:'error'});
		}
	})
}
//���� 2861448--�ֶ������Ļ���ƻ�֧���޸�����ʱ�䡢����֧���޸�Ϊǰһ���ʱ��
//�޸�ʱ�䵯��
function EditDateTime(){
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ���¼��',type:'error'});
		return false;
	}
	else{
		var count=0
	    for (var i = 0; i < sels.length; i++){
		    if (sels[i].tkStatusName != "δִ��") {			    
		        $.messager.popover({
		            msg: 'δִ�еĻ��������޸�ʱ��',
		            type: 'error'
		        });		
		        count++;		        	            
		        return false;
	    	}		    		
		}
		if (count==0) {
			destroyDialog("NurPlanTaskEditTimeDiag");
			var Content=initDiagDivHtml("EditDateTime");
		    var iconCls="icon-w-edit";
		    createModalDialog("NurPlanTaskEditTimeDiag",$g("�޸�����ʱ��"), 350, 150,iconCls,$g("ȷ��"),Content,"NurPlanTaskEditTime()");

		}
	}
	
}
//���� 2861448--�ֶ������Ļ���ƻ�֧���޸�����ʱ�䡢����֧���޸�Ϊǰһ���ʱ��
function NurPlanTaskEditTime(){
	var datetime = $('#EditDataTimeBox').datetimebox('getValue')
	var date = datetime.split(" ")[0];
	var time = datetime.split(" ")[1];
	var taskRecordIdArr=[];
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	for (var i=0;i<sels.length;i++){
		var taskRecordId=sels[i].recordId;
		if (!taskRecordId) continue;
		taskRecordIdArr.push(taskRecordId);
	}
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		MethodName:"NurPlanTaskEditTime",
		taskRecordId:taskRecordIdArr.join("^"),
		Date:date,
		Time:time,
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			destroyDialog("NurPlanTaskEditTimeDiag");
            $("#NurPlanTaskTab").datagrid('load');
		}else if(rtn == 1) {
            $.messager.popover({
                msg: "����ʧ�ܣ��޸�ʱ����ڵ�ǰʱ��" ,
                type: 'error'
            });
        }else if(rtn == 2) {
            $.messager.popover({
                msg: "����ʧ�ܣ��ֶ���ӵĻ�������ſ����޸�ʱ��" ,
                type: 'error'
            });
            $("#QuestionDiag").window("close");
        }else if(rtn == 3) {
            $.messager.popover({
                msg: "����ʧ�ܣ�״̬δִ�еĻ����ſ����޸�ʱ��" ,
                type: 'error'
            });
            $("#QuestionDiag").window("close");
        }else{
			$.messager.popover({msg:'ִ��ʧ�ܣ�!'+rtn,type:'error'});
		}
	})	
}
function showTransferRecordWin(){
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ���¼��',type:'error'});
		return false;
	}
	var exeDescArr=[];
	PageLogicObj.m_recordList=[];
	
	var errmsg=""
	for (var i=0;i<sels.length;i++){
		var canExecuteFlag=1;		
		
		var taskRecordId=sels[i].recordId;
		if (!taskRecordId) continue;
		var executeItemName=sels[i].executeItemName;
		var tkStatusName=sels[i].tkStatusName;		
		
		if (tkStatusName !=$g("��ִ��")) {
			//$.messager.popover({msg:executeItemName+ ' �� "��ִ��" ״̬�ļ�¼����ת�뻤���¼!',type:'error'});
			//return false;
			var index_1=$('#NurPlanTaskTab').datagrid('getRowIndex',sels[i].recordId);
			errmsg=errmsg+" ��"+(index_1+1)+"�У�"+' �� "��ִ��" ״̬�ļ�¼����ת�뻤���¼! \n';
			canExecuteFlag=0;
			
		}
		var itemInfo=sels[i].itemInfo;
		itemInfo=eval("("+itemInfo+")");
		var itemTotalCount=itemInfo.itemTotalCount;
		if (itemTotalCount>0) {
			//$.messager.popover({msg:executeItemName+ ' ��������С��ļ�¼����ת�뻤���¼!',type:'error'});
			//return false;
			var index_2=$('#NurPlanTaskTab').datagrid('getRowIndex',sels[i].recordId);
			errmsg=errmsg+" ��"+(index_2+1)+"�У�"+' ��������С��ļ�¼����ת�뻤���¼! \n';
			canExecuteFlag=0;
		}
		
		if(canExecuteFlag==1) PageLogicObj.m_recordList.push(sels[i]);
		var executeContent=sels[i].executeContent;
		var executeItemName=sels[i].executeItemName;
		if(canExecuteFlag==1) exeDescArr.push(executeContent || executeItemName);
	}
	if (errmsg){
	    $.messager.popover({msg:errmsg.replace(/\n/g,"<br>"),type:'error',timeout: 5000 });
	}
	if (isRepeat(PageLogicObj.m_recordList,"episodeID")){
		$.messager.popover({msg:'ת�뻤���¼ֻ֧�ֵ����ߵ���/����ת�룡',type:'error'});
		return false;
	}
	destroyDialog("NurPlanTaskExecuteDiag");
	var Content=initDiagDivHtml("transferRecord");
    var iconCls="icon-w-edit";
    if (PageLogicObj.m_recordList.length>=1){
	/*if (isRepeat(PageLogicObj.m_recordList,"episodeID")){
		createModalDialog("NurPlanTaskExecuteDiag","ת�뻤���¼", 742, 400,iconCls,"ȷ��",Content,"transferRecord()");
		$(".patInfoBanner_patInfoText").parent().hide();
		$("#BDataRefer").hide();
	}else{*/
		// 742, 432
		if ((typeof(HISUIStyleCode)!='undefined')&&('lite'!=HISUIStyleCode)) {//�Ų�
		   	createModalDialog("NurPlanTaskExecuteDiag",$g("ת�뻤���¼"), 742, 464,iconCls,$g("ȷ��"),Content,"transferRecord()");	   	
	   	}else if((typeof(HISUIStyleCode)!='undefined')&&('lite'==HISUIStyleCode)){//����
		   	createModalDialog("NurPlanTaskExecuteDiag",$g("ת�뻤���¼"), 742, 460,iconCls,$g("ȷ��"),Content,"transferRecord()");	   	
	   	}else{
		   	createModalDialog("NurPlanTaskExecuteDiag",$g("ת�뻤���¼"), 742, 464,iconCls,$g("ȷ��"),Content,"transferRecord()");	 	
		}
		InitPatIfoBar(PageLogicObj.m_recordList[0].episodeID);
		// ת�뻤���¼ ���������޷����� bug fix 2021.6.2
		$("#BDataRefer").click(referHandlerClick);
	//}
    }
	$("#ExecDate").datebox("setValue",ServerObj.CurrentDate);
	$("#ExecTime").timespinner("setValue",GetCurTime("N"));
	$("#ExecUser").val(session['LOGON.USERNAME']);
	if (session['LOGON.LANGCODE']=='EN'){
		var username=$cm({
		    ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		    MethodName:"getUserNameDesc",
		    executeUser:session['LOGON.USERNAME'],
		    dataType: "text"
		},false);
		$("#ExecUser").val(username);

	}
	// 2021.7.14 ����Ҫ��ȥ��
	//var tempString = getMergeExeDesc(exeDescArr.join("&#13;"))
	var tempString = getMergeExeDesc(exeDescArr.join("  "))
	// $("#exeDesc").html(exeDescArr.join("&#13;"))
	$("#exeDesc").html(tempString);
	InitNursingRecordTemplate();
}
function transferRecord(){
	var sels=$('#NurPlanTaskTab').datagrid("getSelections");
	if (sels.length==0){
		$.messager.popover({msg:'��ѡ���¼��',type:'error'});
		return false;
	}
	var taskRecordIds=[],recordDataArr=[];
	for (var i=0;i<sels.length;i++){
		var taskRecordId=sels[i].recordId;
		if (!taskRecordId) continue;
		taskRecordIds.push(taskRecordId);
		recordDataArr.push({
			episodeID:sels[i].episodeID,
			locID:session['LOGON.CTLOCID'],
			userID:session['LOGON.USERID'],
			exedate:$("#ExecDate").datebox("getValue"),
			exetime:$("#ExecTime").timespinner("getValue"),
			exeDesc:$("#exeDesc").val(),			
			exeDescFlag:true, // ִ�������Ƿ��и��ĵı�ʶ
			//transdate:$("#ExecDate").datebox("getValue"),
			//transtime:$("#ExecTime").timespinner("getValue"),
			//transDesc:$("#exeDesc").val(),			
			//DescFlag:true, // ִ�������Ƿ��и��ĵı�ʶ
			emrRecordId:sels[i].emrRecordId,
			record:[]
		});
	}
	/*
	var templategrid = $('#NursingRecordTemplate').combogrid("grid");
	var templaterowdata = templategrid.datagrid('getSelected');
	var nurseRecordEntryTplId=templaterowdata.nurseRecordEntryTplId;
	*/
	var nurseRecordEntryTplId=""
	var templategrid = $('#NursingRecordTemplate').combogrid("grid");
	var templaterowdata = templategrid.datagrid('getSelected');
	if (!((templaterowdata==null)||(templaterowdata.length == 0))){
		var nurseRecordEntryTplId=templaterowdata.nurseRecordEntryTplId;
	}
	//todo �໼����ô����ת��
	$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		MethodName:"BatchTransferNursingRecord",
		userId:session['LOGON.USERID'],
		//taskRecordIds:taskRecordIds.join("^"),
		RecordIds:taskRecordIds.join("^"),
		recordData:JSON.stringify(recordDataArr),
		transferFlag:$("#SureTrans").checkbox("getValue") ? 1 : "",
		//exeDesc: $("#exeDesc").val(),
		transferDesc: $("#exeDesc").val(),
		hospDR:session['LOGON.HOSPID'],
		sessionArrayJson:GetSessionInfo(),
		nurseRecordEntryTplId:nurseRecordEntryTplId,
		Type:'TASK',
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			bakPatInfoBanner();
			destroyDialog("NurPlanTaskExecuteDiag");
			$.messager.popover({msg:'ת�뻤���¼�ɹ���',type:'success'});
		}else{
			$.messager.popover({msg:'ת�뻤���¼ʧ�ܣ�'+rtn,type:'error'});
		}
	})
}

// 2021.7.14 ת�뻤���¼ȥ��
function getMergeExeDesc(text)
{
	var textAll = text
	//var arr = textAll.split("&#13;");
	var arr = textAll.split("  ");
	var obj = {};
	var tmp = [];
	for(var i = 0 ;i< arr.length;i++){
	   if( !obj[arr[i]] ){
	      obj[arr[i]] = 1;
	      tmp.push(arr[i]);
	   }
	}
	
	//var finalstr = tmp.join("&#13;");
	var finalstr = tmp.join("  ");
	var tmp = null;
	return finalstr;
}

function initDiagDivHtml(type){
	if(type =="PRN"){
		var html="<div id='PRNWin' style='margin:10px 10px 0 10px;border:1px solid #ccc;border-radius:4px;'>"
			   html +='<div style="padding:10px 0;border-bottom:1px solid #ccc;">'
				html +='<label class="r-label">'+$g("����")+'</label>'
				html +='<input id="PatBedNo" class="hisui-combobox textbox"></input>'
				html +='<label class="r-label">'+$g("�����ʩ")+'</label>'
				html +='<input id="QuestionMeasure" class="textbox" placeholder="'+$g("�����뻤���ʩ")+'" style="margin-right:10px;vertical-align:bottom;width:300px;"></input>'
				html +='<a class="hisui-linkbutton" id="BQuestionMeasureFind" >'+$g("��ѯ")+'</a>'
			   html +='</div>'

			   html +='<div style="height:487px;">' 
			   	html +='<table id="QuestionMeasureTab"></table>'
			   html +="	 </div>"
		   html += "</div>"
	}else if(type =="ExeNote"){
		var html="<div id='PRNWin'>"
			   html +='<div style="padding-top:10px;text-align:center">'
				html +='<label style="padding-right: 10px;text-align:right"">'+$g("ִ�б�ע")+'</label>'
				html +='<input  id="ExeNoteList" class="hisui-combobox textbox" style="width:260px;"></input>'
			   html +='</div>'
		   html += "</div>"
	}else if(type =="NoSubItemNurseExe"){
		var html="<div id='NoSubItemNurseExe'>"
				html +='<div style="padding:10px;">'
					html +='<div class="patInfoBanner_patInfoText"></div>'
				html +='</div>'
				html +='<table>'
					html +='<tr class="remind" ><td id ="TdTaskExeResult" style="padding: 0px 0px 10px 10px;width: 85px;text-align:right" >'+$g("����ִ�н��")+'</td></tr>'
					html +='<tr style="margin-bottom:10px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ִ��ʱ��")+'</label></td>'
						html +="<td style='padding:0px 10px 0px 10px'><input id='ExecDate' class='hisui-datebox textbox r-label' style='width:120px;'></input>"
						html +="<span style='margin:0 5px;'></span>"
						html +="<input id='ExecTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:80px;'></input></td>"
					html += "</tr>"
					html +='<tr>'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ִ�л�ʿ")+'</label></td>'
						html +="<td style='padding:10px'><input id='ExecUser' class='textbox' disabled style='width:203px;'></input></td>"
					html += "</tr>"

					html +='<tr class="remind"><td  style="padding: 10px 0 10px 10px;text-align:right">'+$g("ִ�н������")+'</td>'
					html +='<td style="padding:0px 10px 5px 0px"><a class="hisui-linkbutton" id="BDataRefer" style="margin-left:10px;">'+$g("��������")+'</a></td></tr>'
					html +='<tr style="margin-bottom:10px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +="<td style='padding:5px 0px 5px 0px'><textarea id='exeDesc' style='margin:0 10px;height:120px;width:621px;border-radius:2px;'></textarea></td>"
					html +='</tr>'

					html +='<tr style="margin:0px 0 0 10px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +='<td style="padding:5px 10px 10px 10px;"><input id="SureTrans" class="hisui-checkbox" type="checkbox" label="'+$g("ȷ��Ҫ������ִ�н��")+'<span>'+$g("ת�뻤���¼")+'</span>'+$g("��")+'">'
					html +='</tr>'
					
					html +='<tr class="remind">'
						html +='<td style="padding: 0px 0 0px 10px;text-align:right"><label for="NursingRecordTemplate">'+$g("ת�뻤���¼")+'</label></td>'
						html +='<td style="padding:0px 10px 0px 10px"><input  style="margin-left:10px;width:360px;" class="hisui-combogrid" id="NursingRecordTemplate" placeholder='+$g("��ָ��ר�ƻ����¼��")+'></td>'
					html +='</tr>'
				html +='</table>'
			html += "</div>"
	}else if(type =="ItemNurseExe"){
		var html="<div id='ItemNurseExe'>"
				html +='<div style="padding:10px;">'
					html +='<div class="patInfoBanner_patInfoText"></div>'
				html +='</div>'
				html +='<table>'
					html +='<tr class="remind"><td id ="TdTaskExeResult" style="padding: 0px 0px 10px 10px;width: 148px;text-align:right" >'+$g("����ִ�н��")+'</td></tr>'
				html +='</table>'	
				html +='<div id="SubItem-div"></div>'
				html +='<table>'
					html +='<tr style="margin-bottom:10px;">'
						html +='<td style="padding-right:0px;text-align:right;width: 158px;"><label>'+$g("ִ��ʱ��")+'</label></td>'
						html += '<td class="form-item-control-wrapper" style="padding:0px 10px 0px 10px">'
							html +="<input id='ExecDate' class='hisui-datebox textbox r-label' style='width:140px;'></input>"
							html +="<input id='ExecTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:86px;'></input>"
						html += "</td>"
					html += "</tr>"
					html +='<tr>'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ִ�л�ʿ")+'</label></td>'
						html += '<td class="form-item-control-wrapper" style="padding:10px">'
							html +="<input id='ExecUser' class='textbox' disabled style='width:225px;'></input>"
						html += "</td>"
					html += "</tr>"

					html +='<tr class="remind"><td  style="padding: 10px 0 10px 10px;text-align:right">'+$g("ִ�н������")+'</td><td style="padding:0px 10px 5px 0px"><a class="hisui-linkbutton" id="BDataRefer" style="margin-left:10px;">'+$g("��������")+'</a></td></tr>'
					html +='<tr style="margin-bottom:10px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"<!-- width:calc(100% - 26px);-->
						html +="<td style='padding:5px 0px 5px 0px'><textarea id='exeDesc' style='margin:0 10px;height:120px;width:610px;border-radius:2px;'></textarea></td>"
					html +='</tr>'

					html +='<tr style="margin:10px 0 0 10px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +='<td style="padding:0 10px;"><input id="SureTrans" class="hisui-checkbox" type="checkbox" label="'+$g("ȷ��Ҫ������ִ�н��")+'<span>'+$g("ת�뻤���¼")+'</span>'+$g("��")+'">'
					html +='</tr>'
					html +='<tr class="remind">'
						html +='<td  style="padding: 10px 0 10px 10px;text-align:right"><label for="NursingRecordTemplate">'+$g("ת�뻤���¼")+'</label></td>'
						html +='<td style="padding:10px"><input  style="margin-left:10px;width:360px;" class="hisui-combogrid" id="NursingRecordTemplate" placeholder='+$g("��ָ��ר�ƻ����¼��")+'></td>'
					html +='</tr>'
				html +='</table>'
			html += "</div>"
	}else if(type =="transferRecord"){
		var html='<div id="transferRecord">'
				html +='<div style="padding:10px;">'
					html +='<div class="patInfoBanner_patInfoText"></div>'
				html +='</div>'
				html +='<table id="transTable">'
					html +='<tr ><td  style="padding: 0px 0 10px 10px; width: 85px;text-align:right">'+$g("ִ�н������")+'</td><td style="padding-bottom:10px;"><a class="hisui-linkbutton" id="BDataRefer" style="margin-left:10px;">'+$g("��������")+'</a></td></tr>'
					html +='<tr>'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +=" <td><textarea id='exeDesc' style='margin:0 10px;height:120px;width:621px;border-radius:2px;'></textarea></td>"
					html +='</tr>'

					html +='<tr style="margin:10px 0 0 0px;">'
						html +="<td><span style='margin:0 10px;'></span></td>"
						html +='<td style="padding:10px 0 0 10px;"><input id="SureTrans" class="hisui-checkbox" type="checkbox" data-options="checked:true" label="'+$g("ȷ��Ҫ������ִ�н��<span>ת�뻤���¼</span>��")+'">'
					html +='</tr>'
					html +='<tr style="margin:10px 0 0 0px;">'
						html +='<td style="padding:10px 0px 0 10px;text-align:right""><label for="NursingRecordTemplate">'+$g("�����¼��")+'</label></td>'
						html +='<td style="padding:10px 10px 0 10px"><input class="hisui-combogrid" style=" width:360px; "id="NursingRecordTemplate"/></td>'
					html +='</tr>'
					html +='<tr style="margin:10px 0 10px 0px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ת��ʱ��")+'</label></td>'
						html +="<td style='padding:10px'><input id='ExecDate' class='hisui-datebox textbox r-label' style='width:120px;'></input>"
						html +="<span style='margin:0 5px;'></span>"
						html +="<input id='ExecTime' class='hisui-timespinner textbox' data-options='showSeconds:false' style='width:80px;'></input></td>"
					html += "</tr>"
					html +='<tr style="margin:10px 0 0 0px;">'
						html +='<td style="padding-right:0px;text-align:right"><label>'+$g("ת�뻤ʿ")+'</label></td>'
						html +="<td style='padding:0px 10px 0px 10px'><input id='ExecUser' class='textbox' disabled style='width:203px;'></input></td>"
					html += "</tr>"					
				html +='</table>'
			html += "</div>"
	}else if (type == "EditDateTime") {    //���� 2861448--�ֶ������Ļ���ƻ�֧���޸�����ʱ�䡢����֧���޸�Ϊǰһ���ʱ��
        var html = "<div id='QuestionWin' class='messager-body'>"
		html +='<tr>'
		html +='<td class="r-label">�޸�����ʱ��Ϊ ��</td>'
		html +='<td>'
		html +='<input class="hisui-datetimebox" id="EditDataTimeBox" data-options="required:true,showSeconds:false" style="width:180px">'
		html +='</td>'
		html +='</tr>'
		html += "</div>"
    }
	
	return html;
}
function showPRNModal(){
	destroyDialog("NurPlanTaskExecuteDiag1");
	var Content=initDiagDivHtml("PRN");
    var iconCls="icon-w-list";
    createModalDialog("NurPlanTaskExecuteDiag1","PRN", 1000, 637,iconCls,$g("ȷ��"),Content,"savePRNTask()");
	var SelPatBedNoArr=new Array();
	if (ServerObj.IsShowPatList =="Y") {
		if (((ServerObj.versionPatientListNew=="1")&&(_PatListGV.ifMultiCheck==1)||(ServerObj.versionPatientListNew!="1"))){
			//  1��չʾ�����б� 2���л��»����б�(�°汾)  3�������б��ѡ
			//  1��չʾ�����б� 2��δ�л��»����б�(�ɰ汾) 
			var length=PageLogicObj.episodeIDs.split("^").length;	
			for (var i=0;i<length;i++){
				var node = $('#patientTree').tree('find', PageLogicObj.episodeIDs.split("^")[i]);
				// �ǿ��ж� 2011.11.30
				if (!node || node == null || node == "") continue;
				var bedCode=node.bedCode;
				if (!bedCode) continue;
				SelPatBedNoArr.push({"id":PageLogicObj.episodeIDs.split("^")[i],"text":bedCode});
			}
		}else{  
			// 1��չʾ�����б� 2���л��»����б�(�°汾)3�������б�ѡ
			var node = $('#patientTree').tree('find', PageLogicObj.episodeIDs);
			// �ǿ��ж� 2011.11.30
			if (!node || node == null || node == "") return;
			var bedCode=node.bedCode;
			if (!bedCode) return;	
			SelPatBedNoArr.push({"id":PageLogicObj.episodeIDs,"text":bedCode});
				
		}		
	}else if(IsNurTaskRedirect()){
		//����������ת����
		for (var i=0;i<PageLogicObj.episodeIDs.split("^").length;i++){
			var bedCode = parent.getPatBedByEpisodeID(PageLogicObj.episodeIDs.split("^")[i]);
			if (!bedCode) continue;
			SelPatBedNoArr.push({"id":PageLogicObj.episodeIDs.split("^")[i],"text":bedCode});
		}
	}else{
		//��չʾ�����б� 
	    var PatInfo = $.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetPatient",
		EpisodeID:PageLogicObj.episodeIDs
		},false);
		SelPatBedNoArr.push({"id":PageLogicObj.episodeIDs,"text":PatInfo.bedCode});				
	}
	$("#PatBedNo").combobox({
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		data:SelPatBedNoArr,
		onSelect:function(rec){
			if (rec) {
				$('#QuestionMeasureTab').datagrid("load");
			}
		},
		onChange:function(newValue, oldValue){
			if (!newValue) {
				$('#QuestionMeasureTab').datagrid("load");
			}
		},
		onLoadSuccess:function(data){
			if (data.length ==1){
				$("#PatBedNo").combobox("setValue",data[0].id);
			}
		}
	});
	InitQuestionMeasureTab();
	$('#BQuestionMeasureFind').linkbutton({    
		iconCls: 'icon-w-find'   
	}); 
	$("#BQuestionMeasureFind").click(function(){
		$('#QuestionMeasureTab').datagrid("load");
	});
}
function savePRNTask(){
	var sels=$('#QuestionMeasureTab').datagrid("getSelections");
	if (sels.length==0){
		$.messager.popover({msg:'����ѡ��PRN����',type:'error'});
		return false;
	}
	var intRecordIds = [];
	for (var i=0;i<sels.length;i++){
		var intRecordId=sels[i].intRecordId;
		if (!intRecordId) continue;
		intRecordIds.push(intRecordId);
	}
   $.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.TaskRecord",
		MethodName:"SavePRNTask",
		intRecordIds:intRecordIds.join("^"),
		wardId:session['LOGON.WARDID'],
		userId:session['LOGON.USERID'],
		dataType:"text"
	},function(rtn){
		if (rtn ==0){
			destroyDialog("NurPlanTaskExecuteDiag1");
			$("#NurPlanTaskTab").datagrid('load');
		}else{
			$.messager.popover({msg:'PRN���񱣴�ʧ�ܣ�',type:'error'});
		}
	})
}
function InitQuestionMeasureTab(){
	var Columns=[[ 
		{ field: 'intRecordId', checkbox: 'true'},
		{ field: 'patientBedNo', title: '����',width:70},
		{ field: 'patientName', title: '����',width:110},
		{ field: 'intName', title: '�����ʩ',width:360,wordBreak:"break-all"},
		{ field: 'intTypeName', title: '����',width:120},
		{ field: 'questionName', title: '��������',width:280,wordBreak:"break-all"}
    ]];
	$('#QuestionMeasureTab').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : false, //������Ч��
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('������..'),  
		pagination : true, 
		rownumbers : false,
		idField:"intRecordId",
		pageSize: 15,
		pageList : [15,50,100,200],
		columns :Columns,
		nowrap:false,  /*�˴�Ϊfalse*/
		url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.TaskRecord&QueryName=GetPrnInterventionList",
		onBeforeLoad:function(param){
			$('#QuestionMeasureTab').datagrid("unselectAll");
			var selEpisodeID=$("#PatBedNo").combobox("getValue");
			if (!selEpisodeID) {
				selEpisodeID=PageLogicObj.episodeIDs;
			}
			param = $.extend(param,{
				episodeIDString:selEpisodeID,
				searchName:$.trim($("#QuestionMeasure").val()),
				hospDR:session['LOGON.HOSPID']
			});
		}
	})
}
function InitPatIfoBar(EpisodeID){
	if (ServerObj.versionIsInfoBarNew=="1"){
		InitPatInfoBanner(PageLogicObj.m_recordList[0].episodeID);		
		var _patinfobanner=$(".patInfoBanner_patInfoText");	
		var banner_bak=$("#PatInfoBannner").contents();
		//$('#patinfobanner').html('');
		if (_patinfobanner.length>0){
			$(".patInfoBanner_patInfoText").append(banner_bak);
		}		
	}else{
		$.cm({
			ClassName:"Nur.NIS.Service.Base.Patient",
			MethodName:"GetPatient",
			EpisodeID:EpisodeID
		},function(PatInfo){
			var _$patInfo=$(".patInfoBanner_patInfoText");
			var sex=PatInfo.sex;
			if (sex =="Ů") {
				_$patInfo.append('<img src="../images/uiimages/bed/fmaleAvatar.png" alt="" class="patSexIcon">');
			}else{
				_$patInfo.append('<img src="../images/uiimages/bed/maleAvatar.png" alt="" class="patSexIcon">');
			}
			_$patInfo.append("<span class='patInfoBanner_patInfoText--name'>"+PatInfo.bedCode+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--name'>"+PatInfo.name+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.age+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.regNo+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.admReason+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.ctLocDesc+"</span>");
			_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
			_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>"+PatInfo.wardDesc+"</span>");
			$.cm({
				ClassName:"Nur.NIS.Service.Base.Patient",
				MethodName:"GetChunkIcons",
				episodeIDString:EpisodeID
			},function(icons){
				icons=icons[0];
				_$patInfo.append("<span class='patInfoBanner_sep'>/</span>");
				var appendHtml="<span class='patInfoBanner_patInfoText--otherInfo'>"
				_$patInfo.append("<span class='patInfoBanner_patInfoText--otherInfo'>");
				for (var i=0;i<icons.length;i++){
					var src=icons[i].src;
					if (!src) continue;
					var title=icons[i].title;

					appendHtml+='<a href="#"><img src="../images/'+src+'" alt="'+title+'" title="'+title+'" class="patInfoBanner_patInfoIcon--icon"></a>';
				}
				appendHtml+="</span>";
				_$patInfo.append(appendHtml);
			})
		})		
	}
}
function referHandlerClick(){
	var tabsArr=["Know","Diag","Order","Exec","Obs","Lis","Pacs","Epr","Record1","Record2","Symbol"];
	//var url = "nur.hisui.nurseRefer.comm.csp?EpisodeID=" + PageLogicObj.episodeIDs.split("^")[0] + "&Tabs=" + tabsArr.join(",") ;
	var url = "nur.hisui.nurseRefer.comm.csp?EpisodeID=" + PageLogicObj.m_recordList[0].episodeID+ "&Tabs=" + tabsArr.join(",")+ "&WinWidth="+$(window).width()*0.6;
	// MWToken ����
	url = getIframeUrl(url);
	$('#dialogRefer').dialog({  
		title: $g('��������'),
		width: $(window).width() - 100,  
		height: $(window).height() - 100,
		cache: false,  
		content:"<iframe id='iframeRefer' scrolling='auto' frameborder='0' src='" + url + "' style='width:100%; height:100%; display:block;'></iframe>",
		modal: true
	});
	$("#dialogRefer").dialog("open");
}
 function sureReferHandler() {
	var topFrame = topWindow(window);
	var textEdit = topFrame.$('#iframeRefer').contents().find('#textEdit')[0];	
	var editContent = $(textEdit).val();
	var textEdit = $('#iframeRefer').contents().find('#editor');	
	var editContent = textEdit.innerText || textEdit[0].innerText;
	if (!editContent) {
		topFrame.$.messager.alert('��ʾ','û��Ҫ���õ�����!'); 
		return;
	}
	var exeDesc=$("#exeDesc").val();
	$("#exeDesc").val(exeDesc+editContent)
	closeHandler();
}
function clearHandler() {
	//var textEdit = $('#iframeRefer').contents().find('#textEdit')[0];
	//$(textEdit).val('');
	var textEdit = $('#iframeRefer').contents().find('#editor')[0];		
	textEdit.innerHTML='';
	var btnClear = $('#iframeRefer').contents().find('#btnClearTree')[0];
	if (btnClear) btnClear.click();
}
function closeHandler() {
	$('#dialogRefer').dialog('close');
}
function topWindow(currentWindow) {
	if (!!currentWindow.parent) {
		if (!currentWindow.parent.TemplateIndentity) {
			return currentWindow;
		}
		return topWindow(currentWindow.parent);
	}
	return currentWindow;
}
function bakPatInfoBanner(){
	if (ServerObj.versionIsInfoBarNew=="1"){
	    //InitPatInfoBanner(PageLogicObj.m_recordList[0].episodeID);			        
		var _PatInfoBannner=$("#PatInfoBannner");	
		var banner_bak=$(".patInfoBanner_patInfoText").contents();
		//$('#patinfobanner').html('');
		if (_PatInfoBannner.length>0){	
			$("#PatInfoBannner").append(banner_bak);
		}
	}
}
/**
 * ����һ��ģ̬ Dialog
 * @param id divId
 * @param _url Div����
 * @param _title ����
 * @param _width ���
 * @param _height �߶�
 * @param _icon ICONͼ��
 * @param _btntext ȷ����ťtext
*/
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
	if(_btntext==""){
		var buttons=[];
	}else{
		var buttons=[{
			 text:_btntext,
			 //iconCls:_icon,
			 handler:function(){
				 if(_event!="") eval(_event);
			 }
		 }]
	}
	//���ȥ���رհ�ť�����û�����������Ͻ�X�ر�ʱ�������޷��ص����������¼�����Ҫ����ƽ̨Э������
	buttons.push({
		text:$g('ȡ��'),
		 handler:function(){			 
			 bakPatInfoBanner();
			 destroyDialog(id);
		 }
	});
	 $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
	 if (_width == null)
		 _width = 800;
	 if (_height == null)
		 _height = 500;
	 $("#"+id).dialog({
		 title: _title,
		 width: _width,
		 height: _height,
		 top:((_height =="auto")?50:null),
		 cache: false,
		 iconCls: _icon,
		 collapsible: false,
		 minimizable:false,
		 maximizable: false,
		 resizable: false,
		 modal: true,
		 closed: false,
		 closable: false,
		 content:_content,
		 buttons:buttons
	 });
}
function destroyDialog(id){
	$("body").remove("#"+id); //�Ƴ����ڵ�Dialog
	$("#"+id).dialog('destroy');
}
function SetPatientTreeStatus(){
	var SearchName=$.trim($('#wardPatientSearchBox').val());
	if (!SearchName) {
		$(".hidenode").removeClass("hidenode");
	}else{
		SearchName=SearchName.toUpperCase();
		var roots=$('#patientTree').tree('getRoots');
		for (var i=0;i<roots.length;i++){
			var children=roots[i].children;
			var childrenHideNum=0;
			for (var j=0;j<children.length;j++){
				var bedCode=children[j].bedCode;
				if (bedCode) {
					bedCode=bedCode.toUpperCase();
				}
				var name=children[j].name.toUpperCase();
				var Node = $('#patientTree').tree('find', children[j].episodeID);
				if (((bedCode)&&(bedCode.indexOf(SearchName) >=0))||(name.indexOf(SearchName) >=0)){
					$(Node.target).removeClass("hidenode");
				}else{
					$(Node.target).addClass("hidenode");
					childrenHideNum++;
				}
			}
			var ParentNode = $('#patientTree').tree('find', roots[i].ID);
			if (childrenHideNum == children.length) {
				$(ParentNode.target).addClass("hidenode");
			}else{
				$(ParentNode.target).removeClass("hidenode");
			}
		}
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
function GetCurTime(IsShowSeconds){
	function p(s) {
		return s < 10 ? '0' + s: s;
	}
	var myDate = new Date();
	var h=myDate.getHours();       //��ȡ��ǰСʱ��(0-23)
	var m=myDate.getMinutes();     //��ȡ��ǰ������(0-59)
	var s=myDate.getSeconds();
	if (IsShowSeconds =="Y") {
		var nowTime=p(h)+':'+p(m)+":"+p(s);
	} else{
		var nowTime=p(h)+':'+p(m);
	}
	return nowTime;
}
function formatUTC(t) {
    var T_pos = t.indexOf('T'),
        Z_pos = t.indexOf('Z');
    y = t.substr(0, T_pos),
        h = t.substr(T_pos + 1, Z_pos - T_pos - 1),
        nT = y + " " + h;
    var timestamp = new Date(Date.parse(nT)).getTime() / 1000,
        off = new Date().getTimezoneOffset() / 60; //��ǰʱ��
    timestamp = timestamp - off * 60 * 60;
    return new Date(parseInt(timestamp) * 1000);
}
function formatUTCToTime(t){
	var date=formatUTC(t);
	var h=date.getHours();
	h=(h<10)?('0'+h):h;
	var m=date.getMinutes();
	m=(m<10)?('0'+m):m;
	return myformatter(date)+" "+h+":"+m;
}
function formatToUTCTime(s){
	if (!s) return "";
	var date=s.split(" ")[0];
	if (s.indexOf(":")>=0) {
		var time=s.split(" ")[1];
	}
	if(dtseparator=="/"){
		var ss = date.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
		date=y+"-"+m+"-"+d;
	}
	if (time) date=date+" "+time;
	var date=new Date(date);
	return date.toISOString();
}
function compare(property) {
	return function(firstobj, secondobj){
		var  firstValue = firstobj[property];
	    var  secondValue = secondobj[property];
	    if ((firstValue)&&(secondValue)) {
		    return firstValue - secondValue ; //����
	    }else{
		    return true;
	    }
	}
}
// ��֤��������ĳ������ֵ�Ƿ����ظ�Ԫ��
function isRepeat(arr,key){
	var obj = {};
	for(var i=0;i<arr.length;i++){
		if ((!obj[arr[i][key]])&&(i>0)){
			return true;
		}else{
			obj[arr[i][key]] = arr[i];
		}
    }
    return false;
}

function ResetDomSize(){
	//$(".hisui-layout").layout("resize").layout('panel', 'center').panel('resize',{height:'100%',width:'100%'});
	if((ServerObj.versionPatientListNew!="1")||(IsNurTaskRedirect())){
		$('#main').css({'margin': '0','width': '100%', 'height': '100%'});	
		//$("#main").layout("resize").layout('panel', 'center').panel('resize',{height:'100%',width:'100%'});
		$("#main").layout('panel', 'center').panel('resize',{height:$(window).height(),width:$(window).width()});
		$("#TaskPlanExecute-panel").parent().css({'width':$(window).width(), 'height':$(window).height()});
		$("#TaskPlanExecute-panel").panel("resize",{height:$(window).height(),width:'100%'});
		var tabheight=$("#TaskPlanExecute-panel").height()-$("#intType").height()-$("#search-table-div").height()
		$("#tab-div").css({'width': '100%', 'height': tabheight-1})
		//$('#NurPlanTaskTab').datagrid("resize");
	}
	else{
		setTimeout(function () {
	        ResetPatientSearch();
	    },200);
	}
}
function ResetPatientSearch(){
	var innerWidth= window.innerWidth;
	var innerHeight= window.innerHeight;
	$("#main").css('width',window.innerWidth-8);
	$("#main").css('height',window.innerHeight-8);
	var ele = document.getElementById("patient_search");
	var style=window.getComputedStyle ? window.getComputedStyle(ele,null) : ele.currentStyle;
	var display=style["display"];
	if (display=="block"){
		$("#main").layout("resize").layout('panel', 'center').panel('resize', {
        	left: 225,
        	width: innerWidth-225-8,
        	height:'100%',
    	});
    	$("#TaskPlanExecute-panel").panel("resize",{height:$(window).height()-8,width:'100%'});
    	$('#tab-div').css('height',$("#TaskPlanExecute-panel").height()-87);
    	$('#NurPlanTaskTab').datagrid("resize",{height:'100%'});
	}
	else if (display=="none"){
		$("#main").layout("resize").layout('panel', 'center').panel('resize', {
        	left: 32,
        	width: innerWidth-32-8        	
    	});
    	$("#TaskPlanExecute-panel").panel("resize",{height:$(window).height()-8,width:'100%'});
    	$('#NurPlanTaskTab').datagrid("resize");
	}

}
// ƴ��session��Ϣ
function GetSessionInfo()
{
	var websysSession = {}
	websysSession["LOGON.CTLOCID"] = session['LOGON.CTLOCID']
	websysSession["LOGON.WARDID"] = session['LOGON.WARDID']
	websysSession["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC']
	websysSession["LOGON.USERID"] = session['LOGON.USERID']
	websysSession["LOGON.SSUSERLOGINID"] = session['LOGON.SSUSERLOGINID']
	
	return JSON.stringify(websysSession);
}
// MWToken ����
function getIframeUrl(url){
	if ('undefined'!==typeof websys_getMWToken){
		if(url.indexOf("?")==-1){
			url = url+"?MWToken="+websys_getMWToken()
		}else{
			url = url+"&MWToken="+websys_getMWToken()
		}
	}
	return url
}
function InitNursingRecordTemplateJson(){
	PageLogicObj.m_NursingRecordTemplateJson=$.cm({
		ClassName:"Nur.NIS.Service.NursingPlan.EMRLinkItem",
		QueryName:"GetEMRLinkItemList",
		hospDR:session['LOGON.HOSPID'],
	},false);
}
// ��ʼ��ת�뻤���¼��
function InitNursingRecordTemplate(){
	InitNursingRecordTemplateJson();
	$('#NursingRecordTemplate').combogrid({
		mode: "local",
		valueField:'nurseRecordEntryTplId',
		textField:'nurseRecordEntryTpl',
		mode: "local",
		multiple:false,
		data:PageLogicObj.m_NursingRecordTemplateJson.rows,		
		columns:[[
			{field:'nurseRecordEntryTpl',title:'��¼��ģ��',width:206,sortable:true},
			{field:'locsName',title:'��Ч����',width:150,sortable:true}
        ]],
	});
}
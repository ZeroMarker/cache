$(function(){
	
	InitEntryDataList();
	InitCurQualityResult();
	InitQualityScore();
	getQualityResult();
	getQualiytStruct();
});
var eprPatient= new Object();
eprPatient.admStatus = "";
eprPatient.startDate = "";
eprPatient.endDate = "";
eprPatient.medicareNo = "";
eprPatient.locID = "";
eprPatient.specialAdm = "";
	var editIndex=undefined;
	var modifyBeforeRow = {};
	var modifyAfterRow = {};
	function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#dgStructEntry').datagrid('validateRow', editIndex)){
				
				
				var ed = $('#dgStructEntry').datagrid('getEditor', {index:editIndex,field:'LocID'});
				var LocName = $(ed.target).combobox('getText');
				$('#dgStructEntry').datagrid('getRows')[editIndex]['LocName'] = LocName;
				
				var ef = $('#dgStructEntry').datagrid('getEditor', {index:editIndex,field:'EmployeeID'});
				var EmployeeName = $(ef.target).combobox('getText');
				$('#dgStructEntry').datagrid('getRows')[editIndex]['EmployeeName'] = EmployeeName;
			
				$('#dgStructEntry').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				
				return true;
			} else {
				return false;
			}
		}
		
function onClickRow(index){
		if (editIndex!=index) {
			if (endEditing()){
				$('#dgStructEntry').datagrid('selectRow', index).datagrid('beginEdit', index);
				editIndex = index;
				
			} else {
				$('#dgStructEntry').datagrid('selectRow', editIndex);
			}
		}
	}	         
function InitCurQualityResult()
{
	$('#dgCurQualityResult').datagrid({
			toolbar:[{
				iconCls: 'icon-cancel ',
				text:'ɾ��',
				handler:function(){
					deleteQualityResult();
				}
			}]
			
		})
}
//��ȡ�ʿؽṹ���ʿ���Ŀ
//hky 2018-08-17
function InitEntryDataList()
{
	$('#dgStructEntry').datagrid({ 
			fitColumns: true,
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetEntryGrid.cls',
			queryParams: {
            	RuleID:RuleID,
            	EpisodeID:EpisodeID,
            	StructID:""
            },
            bbar: [{
				iconCls: 'icon-edit',
				handler: function(){alert('�༭��ť')}
				},'-',{
				iconCls: 'icon-help',
				handler: function(){alert('������ť')}
			}],
			onClickRow: onClickRow,
			//singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				{ field: 'ck', checkbox: true },
				{field:'EntryDesc',title:'������Ŀ',width:170,align:'center'},
				{field:'EntryScore',title:'�۷�',width:50,align:'center'},
				{field:'Number',title:'ȱ����',width:60,align:'center', editor:{type:'numberbox'}},
				{field:'LocID',title:'���ο���',width:110,align:'center', 
					formatter:function(v,r){
						return r.LocName
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'LocID',
							textField:'LocName',
							method:'get',
							url:'../web.eprajax.usercopypastepower.cls?Action=GetTransCTLocID&EpisodeID='+EpisodeID
							
						}
					}
				},
				{field:'EmployeeID',title:'����ҽʦ',width:90,align:'center', 
					formatter:function(v,r){
						return r.EmployeeName
					},
					editor:{
						type:'combobox',
						options:{
							valueField:'EmployeeID',
							textField:'EmployeeName',
							method:'get',
							url:'../web.eprajax.usercopypastepower.cls?Action=GetTransEmployee&EpisodeID='+EpisodeID
							
						}
					}
				},
				{field:'Remark',title:'��ע',width:80,editor:'text',align:'center'},
				{field:'btnsave',title:'����',width:100,align:'center',editor:{type:'linkbutton',options:{iconCls:'icon-save',handler:function(){endEditing();}}}}	
				
				
			]]
	  }); 
	  $.parser.parse('#dgStructEntry');

}
//��ȡ�ʿؽṹ
//hky 2018-08-17
function getQualiytStruct()
{
	$('#comboQualiytStruct').combobox
	({
		valueField:'StructID',  
	    textField:'StructName',
		url:'../EPRservice.Quality.Ajax.GetStructResult.cls?Action=action',
		onSelect: function() {
			var StructID = $("#comboQualiytStruct").combobox('getValue');
            $('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID}
			$('#dgStructEntry').datagrid('reload');	
			//���¼������ݺ��ٴγ�ʼ���༭dg������
            editIndex=undefined;
        }
    });
}

//��ȡ�����ʿؽ���б�����
//hky 2018-08-17
function getQualityResult()
{
	
	$('#dgCurQualityResult').datagrid({ 
			fitColumns: true,
			method: 'post',
            loadMsg: '������......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetQualityResult.cls',
			queryParams: {
            	RuleID:RuleID,
                EpisodeID:EpisodeID,
                SSGroupID:SSGroupID,
                CTLocatID:CTLocatID,
                Action:action
            },
			fit:true,
			columns:[[
				{field: 'ck', checkbox: true },
				{field:'EntryName',title:'������Ŀ',width:100,align:'center'},
				{field:'ResumeText',title:'��ע',width:100,align:'center'},
				{field:'SignUserName',title:'�ʿ�Ա',width:100,align:'center'},
				{field:'ReportDate',title:'�ʿ�����',width:100,align:'center'},
				{field:'CtLocName',title:'���ο���',width:100,align:'center'},
				{field:'EmployeeName',title:'������',width:100,align:'center'}
				
			]]
	  }); 
}


function CommitEntryItems()
{
	var EntryScores = 0
	var ChangeData = ""
	
	//var EntryItemRows = $('#dgStructEntry').datagrid('getChecked'); 
	var EntryItemRows = $('#dgStructEntry').datagrid('getSelections');
	
	if (EntryItemRows.length == 0) 
	{	
			$.messager.alert("��ʾ","��ѡ�������");
			return;
	}
	$('#dgStructEntry').datagrid('clearChecked'); 
	for(var i=0; i<EntryItemRows.length; i++){
    	var EntryID = EntryItemRows[i].EntryID;
    	var EmployeeName = EntryItemRows[i].EmployeeName;
    	var EmployeeID = EntryItemRows[i].EmployeeID;
    	var Number = EntryItemRows[i].Number;
    	var Remark = EntryItemRows[i].Remark;
        var LocID =EntryItemRows[i].LocID
    	var EntryScore = EntryItemRows[i].EntryScore;
    	var Action = action
		var EmrDocId = emrDocId
		if (ChangeData == "")
		{
			var ChangeData=EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate + "^" + Remark + "^" +  Action + "^" + InstanceId + "^" + EmrDocId;
		}
		else
		{
			var ChangeData=ChangeData+'&'+EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + Number + "^" + TriggerDate + "^" + Remark + "^" +  Action + "^" + InstanceId + "^" + EmrDocId;
		}
		var EntryScores = EntryScores*1+EntryScore*1
    	
	}
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: true,
		data: {
			"ChangeData":ChangeData,
		},
		success: function(d) {
			$.messager.alert("��ʾ","���ֳɹ���");
			var Scoretext = $("#score").html();
			var newScoretext =Scoretext - EntryScores;
			$('#score').html(newScoretext);
			if (Action =="D")
			{
				SetDisManualFlag();
			}
			if (Action =="A")
			{
				SetAdmManualFlag();
			}
			$('#dgCurQualityResult').datagrid('reload');
			//parent.patientListTableReload();
		},
		error : function(d) { 
			$.messager.alert("��ʾ","����ʧ�ܣ�");
		}
	});
	
	
}


function SetDisManualFlag() {
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			EpisodeID:EpisodeID,
			SignUserID:SignUserID,
			Action:"Set",
			Status:"D"
		},
		success: function(d) {
			var ret = response.responseText;
			if (ret ==1 )
			{
				$.messager.alert("��ʾ","ȷ�ϳɹ���");
				window.parent.parent.doSearch();
				return;
			}
		}
	});
			
}

function SetOutManualFlag() {
	
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			EpisodeID:EpisodeID,
			SignUserID:SignUserID,
			Action:"Set",
			Status:"O"
		},
		success: function(d) {
			var ret = response.responseText;
			if (ret ==1 )
			{
				$.messager.alert("��ʾ","ȷ�ϳɹ���");
				window.parent.parent.doSearch();
				return;
			}
		}
	});
			
}
//����ѡ���ʿ���Ŀ��Ϣ
//hky 20180817
function SendMsg()
{

	var QualityResultItemRows = $('#dgCurQualityResult').datagrid('getChecked'); 
	
	if (QualityResultItemRows.length == 0) 
	{	
			$.messager.alert("��ʾ","��ѡ������Ŀ��");
			return;
	}
	
	var SendDatas = "";
	var Action = action;
	$('#dgCurQualityResult').datagrid('clearChecked'); 
	for(var i=0; i<QualityResultItemRows.length; i++){
		
		
		var EntryName = QualityResultItemRows[i].EntryName;
		var ResumeText = QualityResultItemRows[i].ResumeText;
		var EmployeeID = QualityResultItemRows[i].EmployeeID;
		var SignUserID = QualityResultItemRows[i].SignUserID;
		var EmployeeName = QualityResultItemRows[i].EmployeeName;
		var InstanceId = QualityResultItemRows[i].InstanceId;
		var EmrDocId = QualityResultItemRows[i].EmrDocId;
		var EntryScore = QualityResultItemRows[i].EntryScore;
		var EntryID = QualityResultItemRows[i].EntryID;
		var ExamCount = QualityResultItemRows[i].ExamCount;
		var ResultDetailID = QualityResultItemRows[i].ResultDetailID;
		
		
		if (SendDatas == "")
		{
			
			var SendDatas = EntryName +  "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID;
		}
		else
		{
			
			var SendDatas = SendDatas + "&" + EntryName + "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID;
		}
    	
	}
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: true,
		data: {
			"SendDatas":SendDatas,
		},
		success: function(d) {
			if (d == 0 )
			{
				$.messager.alert("��ʾ","����ʧ�ܣ�");
				return;
			}
			else if (d == 1)
			{
				$('#dgCurQualityResult').datagrid('reload');
				$.messager.alert("��ʾ","���ͳɹ���");
				//Ext.getCmp('MessageGrid1').store.reload();
			}
		}
	});
		
}
//ȷ���ʿ���ȱ��
//hky 20180817
function SureZeroError()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"SignUserID":SignUserID,
			"Action":"Set",
			"Status":action,
			"SSGroupID":SSGroupID,
			"IsMessage":"1"
		},
		success: function(d) {
			
			if (d ==1 )
			{
				$.messager.alert("��ʾ","ȷ�ϳɹ���");
			}
		}
	});
	
}


function SetAdmManualFlag() {
	
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"SignUserID":SignUserID,
			"Action":"Set",
			"Status":"A",
			"SSGroupID":SSGroupID,
			"IsMessage":"1"
		},
		success: function(d) {
			
			if (d ==1 )
			{
				$.messager.alert("��ʾ","ȷ�ϳɹ���");
			}
		}
	});		
}


function deleteQualityResult()
{
	
	var EntryScores = 0
	
	var QualityResultItemRows = $('#dgCurQualityResult').datagrid('getChecked'); 
	
	if (QualityResultItemRows.length == 0) 
	{	
			$.messager.alert("��ʾ","��ѡ��ɾ���");
			return;
	}
	
	var DelData = "";
	
	
	for(var i=0; i<QualityResultItemRows.length; i++){
		
		
		var UserID = QualityResultItemRows[i].UserID;
		if ((SignUserID!=UserID)&&(SSGroupID==KSSGroup))
		{
			$.messager.alert("��ʾ","��Ȩɾ�������ʿ�ҽ����Ŀ��");
			return;
		}
		var ResultID = QualityResultItemRows[i].ResultID;
		var DetailID = QualityResultItemRows[i].DetailID;
		var EntryScore = QualityResultItemRows[i].EntryScore;
		if (DelData == "")
		{
			var DelData = ResultID + "||" + DetailID;
		}
		else
		{
			var DelData = DelData + '&' + ResultID + "||" + DetailID;
		}
		var EntryScores = EntryScores*1+EntryScore*1
	}

   jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: true,
		data: {
			"DelData":DelData,
		},
		success: function(d) {
			if (d == 0 )
			{
				$.messager.alert("��ʾ","ɾ��ʧ�ܣ�");
				return;
			}
			else if (d == 1)
			{
				$.messager.alert("��ʾ","ɾ���ɹ���");
				var Scoretext = $("#score").html();
			    var newScoretext =Scoretext*1+EntryScores*1;
			    if (newScoretext > 100) 
			    {	
			    	newScoretext=100;
			    }
			    
			    $('#score').html(newScoretext);
				$('#dgCurQualityResult').datagrid('reload');
			}
		}
	});
}

function InitQualityScore()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.Ajax.GetQualityResult.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"Action":"GetScore"
		},
		success: function(d) {
			var newScoretext =d;
			$('#score').html(newScoretext);
		}
	});
		
}

function GetProblemList()
{
	console.log("action:"+action);
	var Action = action
	
	if (Action=="A")
	{
		parent.createModalDialog("QualityResultDialogA","�Զ��ʿ��б���Ժ","600","800","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID + "&ARuleID=2" +"' style='width:600px; height:800px; display:block;'></iframe>","","")
	}
	else if (Action=="D")
	{
		parent.createModalDialog("QualityResultDialogD","�Զ��ʿ��б��Ժ","600","800","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID + "&ARuleID=2" +"' style='width:600px; height:800px; display:block;'></iframe>","","")
	
	}
		
}

function setRevision(status)
{
	/*
	������õĲ������������emr.record.fullquality.csp
	��Ҫ�ѿ�������ҳǩiframe��id�ĳ�"frameBrowsepageoutPat" 
	�������������
	if (window.parent.Left.frames["frameBrowsepageoutPat"].frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"])
	{
		window.parent.Left.frames["frameBrowsepageoutPat"].frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"].setViewRevision(status);
	}
	*/
	//������õĲ������������emr.record.quality.csp�������
	/*if (window.frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"])
	{
		window.frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"].setViewRevision(status);
		
		
	}*/
	
	parent.setViewRevisionFlag(status)
}

function changeRevisionStatus()
{
 	if (document.getElementById("revision").innerText == "��ʾ����")
 	{
	 	document.getElementById("revision").innerText = "�ر�����";
	 	setRevision("true");
	}
	else
	{
		document.getElementById("revision").innerText = "��ʾ����";
		setRevision("false");
	}
	document.getElementById("revision").style.height="30px"
	document.getElementById("revision").font="30px"
	document.getElementById("revision").style.lineHeight="30px"
}

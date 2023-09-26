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
				text:'删除',
				handler:function(){
					deleteQualityResult();
				}
			}]
			
		})
}
//获取质控结构下质控条目
//hky 2018-08-17
function InitEntryDataList()
{
	$('#dgStructEntry').datagrid({ 
			fitColumns: true,
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetEntryGrid.cls',
			queryParams: {
            	RuleID:RuleID,
            	EpisodeID:EpisodeID,
            	StructID:""
            },
            bbar: [{
				iconCls: 'icon-edit',
				handler: function(){alert('编辑按钮')}
				},'-',{
				iconCls: 'icon-help',
				handler: function(){alert('帮助按钮')}
			}],
			onClickRow: onClickRow,
			//singleSelect:true,
			//idField:'rowID', 
			//rownumbers:true,
			fit:true,
			columns:[[
				{ field: 'ck', checkbox: true },
				{field:'EntryDesc',title:'评估条目',width:170,align:'center'},
				{field:'EntryScore',title:'扣分',width:50,align:'center'},
				{field:'Number',title:'缺陷数',width:60,align:'center', editor:{type:'numberbox'}},
				{field:'LocID',title:'责任科室',width:110,align:'center', 
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
				{field:'EmployeeID',title:'责任医师',width:90,align:'center', 
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
				{field:'Remark',title:'备注',width:80,editor:'text',align:'center'},
				{field:'btnsave',title:'保存',width:100,align:'center',editor:{type:'linkbutton',options:{iconCls:'icon-save',handler:function(){endEditing();}}}}	
				
				
			]]
	  }); 
	  $.parser.parse('#dgStructEntry');

}
//获取质控结构
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
			//重新加载数据后，再次初始化编辑dg行数据
            editIndex=undefined;
        }
    });
}

//获取病历质控结果列表数据
//hky 2018-08-17
function getQualityResult()
{
	
	$('#dgCurQualityResult').datagrid({ 
			fitColumns: true,
			method: 'post',
            loadMsg: '加载中......',
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
				{field:'EntryName',title:'评估项目',width:100,align:'center'},
				{field:'ResumeText',title:'备注',width:100,align:'center'},
				{field:'SignUserName',title:'质控员',width:100,align:'center'},
				{field:'ReportDate',title:'质控日期',width:100,align:'center'},
				{field:'CtLocName',title:'责任科室',width:100,align:'center'},
				{field:'EmployeeName',title:'责任人',width:100,align:'center'}
				
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
			$.messager.alert("提示","请选择评分项！");
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
			$.messager.alert("提示","评分成功！");
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
			$.messager.alert("提示","评分失败！");
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
				$.messager.alert("提示","确认成功！");
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
				$.messager.alert("提示","确认成功！");
				window.parent.parent.doSearch();
				return;
			}
		}
	});
			
}
//发送选中质控条目消息
//hky 20180817
function SendMsg()
{

	var QualityResultItemRows = $('#dgCurQualityResult').datagrid('getChecked'); 
	
	if (QualityResultItemRows.length == 0) 
	{	
			$.messager.alert("提示","请选择发送条目！");
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
				$.messager.alert("提示","发送失败！");
				return;
			}
			else if (d == 1)
			{
				$('#dgCurQualityResult').datagrid('reload');
				$.messager.alert("提示","发送成功！");
				//Ext.getCmp('MessageGrid1').store.reload();
			}
		}
	});
		
}
//确认质控无缺陷
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
				$.messager.alert("提示","确认成功！");
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
				$.messager.alert("提示","确认成功！");
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
			$.messager.alert("提示","请选择删除项！");
			return;
	}
	
	var DelData = "";
	
	
	for(var i=0; i<QualityResultItemRows.length; i++){
		
		
		var UserID = QualityResultItemRows[i].UserID;
		if ((SignUserID!=UserID)&&(SSGroupID==KSSGroup))
		{
			$.messager.alert("提示","无权删除其他质控医生条目！");
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
				$.messager.alert("提示","删除失败！");
				return;
			}
			else if (d == 1)
			{
				$.messager.alert("提示","删除成功！");
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
		parent.createModalDialog("QualityResultDialogA","自动质控列表在院","600","800","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID + "&ARuleID=2" +"' style='width:600px; height:800px; display:block;'></iframe>","","")
	}
	else if (Action=="D")
	{
		parent.createModalDialog("QualityResultDialogD","自动质控列表出院","600","800","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID + "&ARuleID=2" +"' style='width:600px; height:800px; display:block;'></iframe>","","")
	
	}
		
}

function setRevision(status)
{
	/*
	如果调用的病历浏览界面是emr.record.fullquality.csp
	需要把看病历的页签iframe的id改成"frameBrowsepageoutPat" 
	用下面这个代码
	if (window.parent.Left.frames["frameBrowsepageoutPat"].frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"])
	{
		window.parent.Left.frames["frameBrowsepageoutPat"].frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"].setViewRevision(status);
	}
	*/
	//如果调用的病历浏览界面是emr.record.quality.csp用下面的
	/*if (window.frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"])
	{
		window.frames["frameBrowsepage"].frames["frameBrowseEPRorEMR"].frames["frameBrowseContent"].setViewRevision(status);
		
		
	}*/
	
	parent.setViewRevisionFlag(status)
}

function changeRevisionStatus()
{
 	if (document.getElementById("revision").innerText == "显示留痕")
 	{
	 	document.getElementById("revision").innerText = "关闭留痕";
	 	setRevision("true");
	}
	else
	{
		document.getElementById("revision").innerText = "显示留痕";
		setRevision("false");
	}
	document.getElementById("revision").style.height="30px"
	document.getElementById("revision").font="30px"
	document.getElementById("revision").style.lineHeight="30px"
}

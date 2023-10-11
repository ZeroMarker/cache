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
			//fitColumns: true,
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
			scrollbarSize:0,
			fit:true,
			nowrap:false,//自动换行
			columns:[[
				{ field: 'ck', checkbox: true },
				{field:'EntryDesc',title:'评估条目',width:200,align:'left'},
				{field:'EntryScore',title:'扣分',width:70,align:'left'},
				{field:'Number',title:'缺陷数',width:70,align:'left',
			    editor:{type:'numberbox'}
				},
				{field:'LocName',title:'责任科室',width:110,align:'left'},
				{field:'EmployeeName',title:'责任医师',width:110,align:'left'},
				{field:'Remark',title:'备注',width:110,editor:'text',align:'left'},
//				{field:'btnsave',title:'保存',width:110,align:'left',editor:{type:'linkbutton',options:{iconCls:'icon-save',handler:function(){endEditing();}}}}
				//{field:HISUIStyleCode!=='lite'?'btnsaves':'btnsave',title:'保存',width:110,align:'left',editor:{type:'linkbutton',options:{iconCls:'icon-save',handler:function(){endEditing();}}}}
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
		url:'../EPRservice.Quality.Ajax.GetStructResult.cls?Action='+action,
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
			//fitColumns: true,
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
			nowrap:false,//自动换行
			columns:[[
				{field: 'ck', checkbox: true },
				{field:'EntryName',title:'评估项目',width:170,align:'left'},
				{field:'ResumeText',title:'备注',width:100,align:'left'},
				{field:'MessageFlag',title:'状态',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){
							if (row.MessageFlag == "未处理"){
								return 'background-color:#FFE1E1;color:#FF5252';
							}
							else if (row.MessageFlag == "已修复"){
								return 'background-color:#E0FBEB;color:#2AB66A';
							}
							else{
								return 'background-color:#E2F2FF;color:#449BE2';
     						}
						}else{
							if (row.MessageFlag == "未处理"){
								return 'background-color:#FFE2E2;color:#BB0000';
							}
							else if (row.MessageFlag == "已修复"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							else{
         						return 'background-color:#EFF9FF;color:#339EFF';
     						}
						}
					},
					formatter:function(value,row,index){  
	   					if(row.MessageFlag == "未处理" ){
	         				return $g("未处理");
	     				}
	     				else if (row.MessageFlag == "已修复" ){
	         				return $g("已修复");
	     				}
	         			else if (row.MessageFlag == "已处理" )
	         			{
		         			return $g("已处理");
		         		}
	                    else if (row.MessageFlag == "未发送消息" )
	         			{
		         			return $g("未发送消息");
		         		}
		         		else if (row.MessageFlag == "已读" )
	         			{
		         			return $g("已读未处理");
		         		}
	 				}
 				},
				{field:'Confirm',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){  
					var MsgStatus  = row.MessageFlag;
 					var MsgID = row.MessageID;
   					if(MsgStatus == "已处理" ){
         			//return "<button>确认完成</button>";
         			//return "<INPUT type='button'  style='width:75px;background:#2db46a;color:white' onclick='Confirm(" + MsgID + ")' value='确认完成'>";
     					return '<div title="确认修复" onClick="Confirm('+MsgID+')"><span class="icon-ok">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
     				}
 				}},
				{field:'SignUserName',title:'质控员',width:100,align:'left'},
				{field:'ReportDate',title:'质控日期',width:100,align:'left'},
				{field:'CtLocName',title:'责任科室',width:100,align:'left'},
				{field:'EmployeeName',title:'责任人',width:100,align:'left'}
				
			]]
	  });
	  $.parser.parse(); 
}


function CommitEntryItems()
{
	endEditing()
	var EntryScores = 0
	var ChangeData = ""
	
	//var EntryItemRows = $('#dgStructEntry').datagrid('getChecked'); 
	var EntryItemRows = $('#dgStructEntry').datagrid('getSelections');
	
	if (EntryItemRows.length == 0) 
	{	
			$.messager.alert("提示","请选择评分项！");
			return;
	}
	if (EntryItemRows[0].EmployeeName=="")
	{
		$.messager.alert("提示","患者入院后尚未分配主管医生，暂不能评价！");
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
			$.messager.alert("提示","添加成功！");
			var Scoretext = $("#score").html();
			var newScoretext =Scoretext - EntryScores;
			$('#score').html(newScoretext);
			$('#dgCurQualityResult').datagrid('reload');
			SetSManualFlag(action,"Y")
			
			//parent.patientListTableReload();
		},
		error : function(d) { 
			$.messager.alert("提示","添加失败！");
		}
	});
	
	
}


function SetSManualFlag(Status,Flag) {
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			EpisodeID:EpisodeID,
			SignUserID:SignUserID,
			Action:"Set",
			Status:Status,
			Flag:Flag
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
		var Path = QualityResultItemRows[i].Path;
		var CtLocDR = QualityResultItemRows[i].LocID;
		
		if (SendDatas == "")
		{
			
			var SendDatas = EntryName +  "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID+ "^" +Path+"^"+CtLocDR;
		}
		else
		{
			
			var SendDatas = SendDatas + "&" + EntryName + "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID+ "^" +Path+"^"+CtLocDR;
		}
    	
	}
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: true,
		data: {
			"SendDatas":SendDatas,
			"Action":action
		},
		success: function(d) {
			if (d == 0 )
			{
				$.messager.alert("提示","质控消息已发送过不能重复发送！");
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


//质控通过
//yhy
function SureZeroError()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			EpisodeID:EpisodeID,
			SignUserID:SignUserID,
			Action:"Set",
			Status:action,
			Flag:"P"
		},
		success: function(d) {
			if (d ==1 )
			{
				$.messager.alert("提示","确认成功！");
				window.parent.parent.doSearch();
				return;
			}
			else if (d==2)
			{
				$.messager.alert("提示","患者有缺陷未修复！");
				return;
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
		
		
		var UserID = QualityResultItemRows[i].SignUserID;
		if ((SignUserID!=UserID)&&(SSGroupID==KSSGroup))
		{
			$.messager.alert("提示","无权删除其他质控医生条目！");
			return;
		}
		var MessageFlag=QualityResultItemRows[i].MessageFlag;
		if ((MessageFlag=="未处理")||(MessageFlag=="已处理")||(MessageFlag=="已修复")||(MessageFlag=="已读"))
		{
			$.messager.alert("提示","已发送的消息不能删除！");
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
 function Confirm(MsgID) {
		    
	    var ret = ""
	    var obj = $.ajax({
	        url: "../web.eprajax.AjaxEPRMessage.cls?Action=confirmmessage&MessageIDS=" + MsgID + "&UserID=" + SignUserID,
	        type: 'post',
	        async: false
	    });
	    var ret = obj.responseText;
	    if ((ret != "" || (ret != null)) && (ret != "-1")) {
		    $.messager.alert("提示","确认成功！");
	        $('#dgCurQualityResult').datagrid('reload');
	    }
	    else {
	        $.messager.alert('错误', '确认失败，请再次尝试！', 'error');
	    }	
}

function GetProblemList()
{
	//window.open("dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID+ "&RuleID=" + 5+ "&Action=" + "GetQualityResult"); 
	var url='dhc.emr.quality.qualityresult.csp?EpisodeID=' + EpisodeID+ '&RuleID='+ 5+ '&Action=GetQualityResult&pageType=KESY' 
	if('undefined' != typeof websys_getMWToken)
	{
		url += "&MWToken="+websys_getMWToken()
	} 
	var content='<iframe id="iframeResultList" frameborder="0" scrolling="no" src='+url+' style="width:1180px; height:443px; display:block;;padding:10px;"></iframe>'
	var title='';
	if(HISUIStyleCode!=='lite'){
		title='<div class="icon-w-paper" style="width:16px;height:16px;display:inline-block;vertical-align: middle;margin-right:5px;"></div>时效性缺陷'	
	}else{
		title='时效性缺陷'	
	}
	parent.createModalDialog("resultList",title,"1200","500","iframeResultList",content,"","")
}

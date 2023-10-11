var StructID=""
var SelectDec=""
$(function(){
	
	InitEntryDataList();
	InitCurQualityResult();
	InitQualityScore();
	getQualityResult();
	getQualiytStruct();
});
var flag=""
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
			var LocID = $(ed.target).combobox('getValue');
			$('#dgStructEntry').datagrid('getRows')[editIndex]['LocName'] = LocName;
			$('#dgStructEntry').datagrid('getRows')[editIndex]['LocID'] = LocID;
			var ef = $('#dgStructEntry').datagrid('getEditor', {index:editIndex,field:'EmployeeID'});
			var EmployeeName = $(ef.target).combobox('getText');
			var EmployeeID = $(ef.target).combobox('getValue');
			$('#dgStructEntry').datagrid('getRows')[editIndex]['EmployeeName'] = EmployeeName;
			$('#dgStructEntry').datagrid('getRows')[editIndex]['EmployeeID'] = EmployeeID;
			$('#dgStructEntry').datagrid('endEdit', editIndex);
			
			editIndex = undefined;
			
			return true;
		} else {
			return false;
		}
	}	
function onClickRow(index){
		nowIndex = index;
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
	var SelectDec="";
	$('#dgStructEntry').datagrid({ 
			fitColumns: true,
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.GetEntryGrid.cls',
			queryParams: {
            	RuleID:RuleID,
            	EpisodeID:EpisodeID,
            	StructID:"",
            	Action:action,
				SelectDec:SelectDec
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
			nowrap:false,
			scrollbarSize:0,
			columns:[[
				{ field: 'ck', checkbox: true },
				{field:'EntryDesc',title:'评估条目',width:170,align:'left'},
				{field:'EntryScore',title:'扣分',width:60,align:'left'},
				{field:'Number',title:'缺陷数',width:70,align:'left',
			    editor:{type:'numberbox'}
				},
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
							url:'../web.eprajax.usercopypastepower.cls?Action=GetTransCTLocID&EpisodeID='+EpisodeID,
							onChange: function(nowLocID,befLocID)
							{
								var objEmployee = $('#dgStructEntry').datagrid('getEditor', {index:nowIndex,field:'EmployeeID'});
								$(objEmployee.target).combobox('setValue',"");
								$(objEmployee.target).combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetTransEmployee&EpisodeID='+EpisodeID+'&LocId='+nowLocID)	
							}
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
							url:'../web.eprajax.usercopypastepower.cls?Action=GetTransEmployee&EpisodeID='+EpisodeID+'&LocId='+PaLocID
							
						}
					}
				},
				{field:'Remark',title:'备注',width:110,editor:'text',align:'left'},
				//{field:'btnsave',title:'保存',width:110,align:'left',editor:{type:'linkbutton',options:{iconCls:'icon-save',handler:function(){endEditing();}}}}	
				//风格切换
				//{field:HISUIStyleCode!=='lite'?'btnsaves':'btnsave',title:'保存',width:110,align:'left',editor:{type:'linkbutton',options:{iconCls:'icon-save',handler:function(){endEditing();}}}}
				
			]],
				rowStyler:function(rowIndex, rowData){   
       			if (rowData.QualityFlag=="1"){   
           		return 'background-color:#FFB6C1;';   
       			}   
   			},

	  }); 
	  $.parser.parse('#dgStructEntry');

}
$('#selectDec').searchbox({
    searcher:function(value,name){
    	var SelectDec=value;
        var StructID = $("#comboQualiytStruct").combobox('getValue');	
		endEditing();			
        $('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID,SelectDec:SelectDec}
		$('#dgStructEntry').datagrid('reload');	
		
    },
   
});
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
			 StructID = $("#comboQualiytStruct").combobox('getValue');
			var SelectDec="";
            $('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID,SelectDec:SelectDec,Action:action}
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
			nowrap:false,
			columns:[[
				{field: 'ck', checkbox: true },
				{field:'EntryName',title:'评估项目',width:150,align:'left',showTip:true,tipWidth:200},
				{field:'ResumeText',title:'备注',width:100,align:'left',showTip:true,tipWidth:200},
				{field:'MessageFlag',title:'消息状态',width:100,align:'left',
					styler:function(value,row,index){
						if(HISUIStyleCode!=='lite'){
							if (row.MessageFlag == "未处理"){
								return 'background-color:#FFE1E1;color:#FF5252';
							}
							else if (row.MessageFlag == "已修复"){
								return 'background-color:#E0FBEB;color:#2AB66A';
							}
							else if (row.MessageFlag == "已处理"){
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
							else if (row.MessageFlag == "已处理"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							else{
         						return 'background-color:#EFF9FF;color:#339EFF';
     						}
						}
					},
					formatter:function(value,row,index){  
	   					if(row.MessageFlag == "未处理" ){
	         				return $g("未处理")
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
				{field:'Confirm',title:'消息确认',width:120,align:'left',
				formatter:function(value,row,index){  
					var MessageFlag  = row.MessageFlag;
 					var MessageID = row.MessageID;
   					if(MessageFlag == "已处理" ){
         			//return '<a href="#" name="confirm" class="hisui-linkbutton" style="background:#16bba2;color:white" onclick="Confirm('+MessageID+')"></a>';
     				return '<div title="确认修复" name="confirm" onClick="Confirm('+MessageID+')"><span class="icon-ok">&nbsp;&nbsp;&nbsp;&nbsp;</span></div>'
     				}
     				/*else{
	     			return '<a href="#" name="confirm" class="hisui-linkbutton" style="background:#999999;color:white" onclick=""></a>';		
	     			}*/
 				}},
				{field:'SignUserName',title:'质控员',width:100,align:'left'},
				{field:'ReportDate',title:'质控日期',width:100,align:'left'},
				{field:'CtLocName',title:'责任科室',width:100,align:'left'},
				{field:'EmployeeName',title:'责任人',width:100,align:'left'}
				
			]],
			onLoadSuccess:function(data){  
        	$("a[name='confirm']").linkbutton({text:'确认已修复',plain:true});   
			},
	  }); 
}


function CommitEntryItems()
{
	endEditing()
	var EntryScores = 0
	var ChangeData = ""
	var SelectData = ""

	//var EntryItemRows = $('#dgStructEntry').datagrid('getChecked'); 
	var EntryItemRows = $('#dgStructEntry').datagrid('getSelections');
	
	if (EntryItemRows.length == 0) 
	{	
			$.messager.alert("提示","请选择评分项！");
			return;
	}
	//$('#dgStructEntry').datagrid('clearChecked'); 
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
    	if (SelectData == "")
		{
			var SelectData=EntryID + "^"+Remark
		}
		else
		{
			var SelectData=SelectData+'&'+EntryID + "^"+Remark
		}

	}
    var unhasEntryInfo = CompareEntryExists(SelectData);
	
	if (unhasEntryInfo==true)
	{
	endEditing();		
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
			InitQualityScore();
			$('#dgCurQualityResult').datagrid('reload');
		},
		error : function(d) { 
			$.messager.alert("提示","评分失败！");
		}
	});
	
	$('#dgStructEntry').datagrid('clearChecked'); 
	$('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID,SelectDec:SelectDec,Action:action}
	$('#dgStructEntry').datagrid('reload');	
 }

	
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
	//var Action = action;
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
		var CtLocDR = QualityResultItemRows[i].LocID;
		
		if (SendDatas == "")
		{
			
			var SendDatas = EntryName +  "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID+ "^" + "" + "^" + CtLocDR;
		}
		else
		{
			
			var SendDatas = SendDatas + "&" + EntryName + "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID+ "^" + "" + "^" + CtLocDR;
		}
    	
	}

	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: false,
		data: {
			"SendDatas":SendDatas,
			"Action":action,
		},
		success: function(d) {
			if (d == 0 )
			{
				$.messager.alert("提示","消息发送失败！");
				return;
			}
			else if (d == 1)
			{
				$('#dgCurQualityResult').datagrid('reload');
				$.messager.alert("提示","消息发送成功！");
			
			}
		}
	});
	
}

function BackToDoctorConfirm()
{
	var oldOk = $.messager.defaults.ok;
	var oldCancel = $.messager.defaults.cancel;
	$.messager.defaults.ok = "退回";
	$.messager.defaults.cancel = "取消";
	$.messager.confirm("确认", "确定退回并发消息?", function (r) {
		if (r) {
			BackToDoctor()
		} else {
			$.messager.popover({ msg: "点击了取消" });
		}
		/*要写在回调方法内,否则在旧版下可能不能回调方法*/
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel;
	});		
}

//退回医生
//病历退回并发送消息
function BackToDoctor()
{
	var QualityResultItemRows = $('#dgCurQualityResult').datagrid('getChecked'); 	
	if (QualityResultItemRows.length == 0) 
	{	
			$.messager.alert("提示","请选择发送条目！");
			return;
	}
	
	//弹出授权界面
	if (pilotView>=0)
	{
		if('undefined' != typeof websys_getMWToken)
		{
			parent.parent.createModalDialog("QualityRecordGrant","病历授权","500","800","iframeQualityRecordGrant","<iframe id='iframeQualityRecordGrant' scrolling='auto' frameborder='0' src='dhc.emr.quality.GrantRecord.csp?EpisodeID=" + EpisodeID+"&userID="+SignUserID+"MWToken="+websys_getMWToken()+"' style='width:500px; height:750px; display:block;'></iframe>","","")
		}
		else
		{
			parent.parent.createModalDialog("QualityRecordGrant","病历授权","500","800","iframeQualityRecordGrant","<iframe id='iframeQualityRecordGrant' scrolling='auto' frameborder='0' src='dhc.emr.quality.GrantRecord.csp?EpisodeID=" + EpisodeID+"&userID="+SignUserID+"' style='width:500px; height:750px; display:block;'></iframe>","","")
		}
	}
	else
	{
		if('undefined' != typeof websys_getMWToken)
		{
			parent.createModalDialog("QualityRecordGrant","病历授权","500","800","iframeQualityRecordGrant","<iframe id='iframeQualityRecordGrant' scrolling='auto' frameborder='0' src='dhc.emr.quality.GrantRecord.csp?EpisodeID=" + EpisodeID+"&userID="+SignUserID+"MWToken="+websys_getMWToken()+"' style='width:500px; height:750px; display:block;'></iframe>","","")
		}
		else
		{
			parent.createModalDialog("QualityRecordGrant","病历授权","500","800","iframeQualityRecordGrant","<iframe id='iframeQualityRecordGrant' scrolling='auto' frameborder='0' src='dhc.emr.quality.GrantRecord.csp?EpisodeID=" + EpisodeID+"&userID="+SignUserID+"' style='width:500px; height:750px; display:block;'></iframe>","","")
		}
	}
}

function BackAndGrant(InstanceIDs)
{
	var BackFlag=0
		jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: false,
		data: {
			"EpisodeID":EpisodeID,
			"SignUserID":SignUserID,
			"action":action,
			"Action":"CancelDoctor",
			"Ip":Ip,
			"InstanceIDs":InstanceIDs
		},
		success: function(d) {		
			if (d ==1 )
			{
				BackFlag="1"
				$.messager.alert("提示","退回成功！");
			}else if (d=="DocErr")
			{
				BackFlag="-1"
				$.messager.alert("提示","医生未提交，退回失败！");		
			}else if (d=="WMRErr")
			{
				BackFlag="-1"
				$.messager.alert("提示","病历已回收，退回失败！");		
			}else if (d=="PassErr")
			{
				BackFlag="-1"
				$.messager.alert("提示","该病历已审核通过，不能再进行操作！");
			}else if (d=="CancelRecoveryErr")
			{
				BackFlag="-1"
				$.messager.alert("提示","病历取消回收失败，医生退回失败！");
			}else if (d=="-1")
			{
				BackFlag="-1"
				$.messager.alert("提示","医生退回失败！");
			}else
			{
				BackFlag="-1"
				$.messager.alert("提示",d);
			}
		}
	});
	
	//退回成功，发送消息
	if (BackFlag==1) SendMsg()
}

//确认质控无缺陷
//hky 20180817
function Pass()
{
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"SignUserID":SignUserID,
			"action":action,
			"Action":"SetPassFlag"
		},
		success: function(d) {

			if (d ==1 )
			{
				$.messager.alert("提示","确认成功！");
			}else if(d=="DocErr"){
				$.messager.alert("提示","医生未提交，不能审核通过！");	
			}else if (d=="DepErr")
			{
				$.messager.alert("提示","科室终末质控未通过，不能审核通过！");
			}else if (d=="ScoreErr")
			{
				$.messager.alert("提示","分数不到90分，不能审核通过！");
			}else if (d=="MesErr")
			{
				$.messager.alert("提示","返修病历质控消息未走完闭环流程，不能审核通过！");
			}else if (d=="PassErr")
			{
				$.messager.alert("提示","该病历已审核通过，不能再进行操作！");
			}else
			{
				$.messager.alert("提示","失败！");
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
		if ((QualityResultItemRows[i].MessageFlag!="未发送消息")&&(QualityResultItemRows[i].MessageFlag!="已撤回"))
		{
			if (QualityResultItemRows[i].MessageFlag=="未处理")
			{
				$.messager.alert("提示","已发送消息的质控条目不允许删除，请先撤回消息！");
				return;
			}
			else
			{
				$.messager.alert("提示","质控条目医生已读，不允许删除！");
				return;
			}
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
	endEditing();		
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
				InitQualityScore();
				$('#dgCurQualityResult').datagrid('reload');
				$('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID,SelectDec:SelectDec,Action:action}
			    $('#dgStructEntry').datagrid('reload');	
			}
		}
	});
}

function InitQualityScore()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"action":action,
			"Action":"GetMDScore"
		},
		success: function(d) {
			var newScoretext =d;
			$('#score').html(newScoretext);
		}
	});
		
}

function GetProblemList()
{
	
		//window.open("dhc.emr.quality.qualitylist.csp?EpisodeID=" + EpisodeID+ "&RuleID=" + 2); 

	if (pilotView>=0)
	{
		if('undefined' != typeof websys_getMWToken)
		{
			parent.parent.createModalDialog("QualityResultDialogD","自动质控列表出院","1204","500","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualitylist.csp?EpisodeID=" + EpisodeID + "&RuleID=2" +"&CTLocatID="+CTLocatID+"&userID="+SignUserID+"&Action=GetQualityResult&pageType=KEZM&MWToken="+websys_getMWToken()+"'style='width:1204px; height:463px; display:block;'></iframe>","","")
		}
		else
		{
			parent.parent.createModalDialog("QualityResultDialogD","自动质控列表出院","1204","500","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualitylist.csp?EpisodeID=" + EpisodeID + "&RuleID=2" +"&CTLocatID="+CTLocatID+"&userID="+SignUserID+"&Action=GetQualityResult&pageType=KEZM' style='width:1204px; height:463px; display:block;'></iframe>","","")
		}
		
	}
	else
	{
		if('undefined' != typeof websys_getMWToken)
		{
			parent.createModalDialog("QualityResultDialogD","自动质控列表出院","1204","500","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualitylist.csp?EpisodeID=" + EpisodeID + "&RuleID=2" +"&CTLocatID="+CTLocatID+"&userID="+SignUserID+"&Action=GetQualityResult&pageType=KEZM&MWToken="+websys_getMWToken()+"' style='width:1204px; height:463px; display:block;'></iframe>","","")
		}
		else
		{
			parent.createModalDialog("QualityResultDialogD","自动质控列表出院","1204","500","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualitylist.csp?EpisodeID=" + EpisodeID + "&RuleID=2" +"&CTLocatID="+CTLocatID+"&userID="+SignUserID+"&Action=GetQualityResult&pageType=KEZM' style='width:1204px; height:463px; display:block;'></iframe>","","")	
		}
	}
}
function Sign()
{
	if (id=="")
	{
		$.messager.alert("提示","此人无病案首页，无法签名！")
	}
	else{
		var url = "emr.interface.ip.main.csp?EpisodeID=" + EpisodeID+ "&InstanceID=" + id+"&DocID="+SYDocumentID+"&FromType=Quality&FromCode=&RecordShowType=Doc";
		if('undefined' != typeof websys_getMWToken)
		{
			url += "&MWToken="+websys_getMWToken()
		}
		window.open (url,'','top=0,left=0,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ')

	//window.open("emr.interface.ip.main.csp?EpisodeID=" + EpisodeID+ "&InstanceID=" + id+"&DocID=52&FromType=Quality&FromCode=&RecordShowType=Doc"); 
	//emr.interface.ip.main.csp?EpisodeID=59&DocID=52&InstanceID=20||1&FromType=Quality&FromCode=&RecordShowType=Doc
	
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
	
	if (pilotView>=0)
	{
		parent.parent.setViewRevisionFlag(status)
	}else{
		parent.setViewRevisionFlag(status)
	}
}

function changeRevisionStatus()
{
 	if (document.getElementById("revision").innerText == $g("显示留痕"))
 	{
	 	document.getElementById("revision").innerText = $g("关闭留痕");
	 	setRevision("true");
	}
	else
	{
		document.getElementById("revision").innerText = $g("显示留痕");
		setRevision("false");
	}
	document.getElementById("revision").style.height="30px"
	document.getElementById("revision").font="30px"
	document.getElementById("revision").style.lineHeight="30px"
}

function CompareEntryExists(SelectData)
{
	var ret=false;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.CompareEntryExistsFlag.cls",
		async: false,
		data: {
			    "RuleID":RuleID,
                "EpisodeID":EpisodeID,
                "SSGroupID":SSGroupID,
                "CTLocatID":CTLocatID,
                "Action":action,
			    "SelectData":SelectData,
			
		},
		success: function(d) {
			if (d == 0 )
			{
				ret = true;
			}
			else 
			{
				$.messager.alert("提示","【"+d+"】已评价,"+"\r\n如需多次评价请修改备注内容!");
				
			}
		}
	});
	
	return ret;
	
}
function Confirm(MessageID) {
	    var ret = ""
	    var obj = $.ajax({
	        url: "../web.eprajax.AjaxEPRMessage.cls?Action=confirmmessage&MessageIDS=" + MessageID + "&UserID=" + SignUserID,
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
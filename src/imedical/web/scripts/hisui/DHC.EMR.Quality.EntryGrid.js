var StructID=""
var SelectDec=""
$(function(){
	
	InitEntryDataList();
	InitCurQualityResult();
	InitQualityScore();
	getQualityResult();
	getQualiytStruct();
});
var locName=''
var DocName=''
var sumPoints=0
var KSsumPoints=0
var recordGrade=''
var KSrecordGrade=''
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
			nowrap:false,
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
	if(action=="A")
	{
	$('#dgCurQualityResult').datagrid({ 
			fitColumns: false,
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
				{field:'EntryName',title:'评估项目',width:100,align:'center',showTip:true,tipWidth:200},
				{field:'ResumeText',title:'备注',width:100,align:'center',showTip:true,tipWidth:200},
				{field:'SignUserName',title:'质控员',width:100,align:'center'},
				{field:'ReportDate',title:'质控日期',width:100,align:'center'},
				{field:'CtLocName',title:'责任科室',width:100,align:'center'},
				{field:'EmployeeName',title:'责任人',width:100,align:'center'},
				{field:'MessageFlag',title:'消息状态',width:100,align:'center'},		
				{field:'EntryScore',title:'扣分标准',width:100,align:'center',hidden:true},
				{field:'EntryScore',title:'科室扣分',width:100,align:'center',hidden:true},
				{field:'BYSScore',title:'病案室扣分',width:100,align:'center',hidden:true},
				{field:'YWKScore',title:'医务科扣分',width:100,align:'center',hidden:true},
				{field:'Confirm',title:'消息撤回',width:120,align:'center',
				formatter:function(value,row,index){  
					var MessageFlag  = row.MessageFlag;
 					var MessageID = row.MessageID;
   					if(MessageFlag == "未处理" ){
         			return '<a href="#" name="recall" class="hisui-linkbutton" style="background:#2db46a;color:white" onclick="Recall('+MessageID+')"></a>';
     				}else{
	     			return '<a href="#" name="recall" class="hisui-linkbutton" style="background:rgb(205,205,205);color:white" onclick=""></a>';		
	     			}
 				}},
				
			]],
			rowStyler:function(rowIndex, rowData){   
       			if ((rowData.MessageFlag!="未发送消息")&&(rowData.MessageFlag!="已撤回")){   
           		return 'background-color:#FFB6C1;';   
       			}   
   			},
			onLoadSuccess:function(r)
			{
				console.log(r.rows)
				locName=r.rows[0].CtLocName
				DocName=r.rows[0].EmployeeName
				$("a[name='recall']").linkbutton({text:'撤回消息',plain:true}); 
			}
	  }); 
	}
	else
	{
	 $('#dgCurQualityResult').datagrid({ 
			fitColumns: false,
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
				{field:'EntryName',title:'评估项目',width:100,align:'center',showTip:true,tipWidth:200},
				{field:'ResumeText',title:'备注',width:100,align:'center',showTip:true,tipWidth:200},
				{field:'SignUserName',title:'质控员',width:100,align:'center'},
				{field:'ReportDate',title:'质控日期',width:100,align:'center'},
				{field:'CtLocName',title:'责任科室',width:100,align:'center'},
				{field:'EmployeeName',title:'责任人',width:100,align:'center'},		
				{field:'EntryScore',title:'扣分标准',width:100,align:'center',hidden:true},
				{field:'EntryScore',title:'科室扣分',width:100,align:'center',hidden:true},
				{field:'BYSScore',title:'病案室扣分',width:100,align:'center',hidden:true},
				{field:'YWKScore',title:'医务科扣分',width:100,align:'center',hidden:true}
				
				
			]],

			onLoadSuccess:function(r)
			{
				console.log(r.rows)
				locName=r.rows[0].CtLocName
				DocName=r.rows[0].EmployeeName
			
			}
	  }); 	
	}
}


function CommitEntryItems()
{
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
	if (EntryItemRows[0].EmployeeName=="")
	{
		$.messager.alert("提示","患者入院后尚未分配主管医生，暂不能评价！");
			return;
	}
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

				if (Action =="D")
				{
					SetDisManualFlag();
				}
				if (Action =="A")
				{
					SetAdmManualFlag();
				}
				$('#dgCurQualityResult').datagrid('reload');
				InitQualityScore();
				//parent.patientListTableReload();
				
			},
			error : function(d) { 
				$.messager.alert("提示","评分失败！");
			}
		});
		$('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID,SelectDec:SelectDec,Action:action}
	    $('#dgStructEntry').datagrid('reload');	
		$('#dgStructEntry').datagrid('clearChecked'); 
	}
	 
	
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
		var Path = QualityResultItemRows[i].Path;
		
		if (SendDatas == "")
		{
			
			var SendDatas = EntryName +  "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID+ "^" +Path;
		}
		else
		{
			
			var SendDatas = SendDatas + "&" + EntryName + "^" + EpisodeID + "^" + EmployeeID + "^" + "" + "^" + SignUserID + "^" + InstanceId + "^" + EmrDocId + "^" + EntryScore + "^" + ExamCount + "^" + EntryID + "^" + ResumeText + "^" + ResultDetailID+ "^" +Path;
		}
    	
	}
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SaveManualResult.cls",
		async: true,
		data: {
			"SendDatas":SendDatas,
			"Action":Action
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
				InitQualityScore();
			
				$('#dgCurQualityResult').datagrid('reload');
				$('#dgStructEntry').datagrid('options').queryParams = { RuleID:RuleID,EpisodeID:EpisodeID,StructID:StructID,SelectDec:SelectDec,Action:action}
	            $('#dgStructEntry').datagrid('reload');	
				//$('#dgStructEntry').datagrid('reload');
			}
		}
	});
}

function InitQualityScore()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.Ajax.GetQualityScore.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"Action":action,
			"ARuleIDs":RuleID
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
		parent.createModalDialog("QualityResultDialogA","自动质控列表在院","1000","500","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID + "&RuleID=2" +"&CTLocatID="+CTLocatID+"&userID="+SignUserID+"&Action=GetQualityResult"+"' style='width:1000px; height:450px; display:block;'></iframe>","","")
	}
	else if (Action=="D")
	{
		parent.createModalDialog("QualityResultDialogD","自动质控列表出院","1000","500","iframeQualityResultD","<iframe id='iframeQualityResultD' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresult.csp?EpisodeID=" + EpisodeID + "&RuleID=2" +"&CTLocatID="+CTLocatID+"&userID="+SignUserID+"&Action=GetQualityResult"+"' style='width:1000px; height:450px; display:block;'></iframe>","","")
	
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
var tableData=""
// strPrintName 打印任务名
// printDatagrid 要打印的datagrid
function CreateFormPage(strPrintName, printDatagrid) {
    var tableString = '<table cellspacing="0" class="pb">';
    //var frozenColumns = printDatagrid.datagrid("options").frozenColumns;  // 得到frozenColumns对象
    
    
    var columns = printDatagrid.datagrid("options").columns;   // 得到columns对象
    var nameList = '';
    // 载入title
    if (typeof columns != 'undefined' && columns != '') {
        $(columns).each(function (index) {
            tableString += '<tr>';
         
            for (var i = 0; i < columns[index].length; ++i) {
	            
                if (columns[index][i].hidden) {
                    tableString += '<th width="' + columns[index][i].width + '"';
                    //alert(columns[index][i].width)
                    if (typeof columns[index][i].rowspan != 'undefined' && columns[index][i].rowspan > 1) {
                        tableString += ' rowspan="' + columns[index][i].rowspan + '"';
                    }
                    if (typeof columns[index][i].colspan != 'undefined' && columns[index][i].colspan > 1) {
                        tableString += ' colspan="' + columns[index][i].colspan + '"';
                    }
                    if (typeof columns[index][i].field != 'undefined') {
                        nameList += ',{"f":"' + columns[index][i].field + '", "a":"' + columns[index][i].align + '"}';
                    }
                    tableString += '>' + columns[index][i].title + '</th>';
       
                }
            }
            tableString += '</tr>';
        });
    }
    // 载入内容
    var rows = printDatagrid.datagrid("getRows"); // 这段代码是获取当前页的所有行
    var nl = eval('([' + nameList.substring(1) + '])');
    for (var i = 0; i < rows.length; ++i) {
        tableString += '<tr>';
        $(nl).each(function (j) {
            var e = nl[j].f.lastIndexOf('_0');
            tableString += '<td';
            if (nl[j].a != 'undefined' && nl[j].a != '') {
                tableString += ' style="text-align:' + nl[j].a + ';"';
            }
            tableString += '>';
            if (e + 2 == nl[j].f.length) {
                tableString += rows[i][nl[j].f.substring(0, e)];
            }
            else{
	            //医务科、病案室未设置评分
	            if (typeof rows[i][nl[j].f]=='undefined')
	            {
		            rows[i][nl[j].f]=''
		        }
		        
	            tableString += rows[i][nl[j].f];
            }
            if (j==2)
            {
	            if(rows[i][nl[j].f]!="")
	            {
		            sumPoints=sumPoints+parseInt(rows[i][nl[j].f])
		        }   
	        }
	        
	        if (j==1)
            {
	            if(rows[i][nl[j].f]!="")
	            {
		            KSsumPoints=sumPoints+parseInt(rows[i][nl[j].f])
		        }   
	        }
            tableString += '</td>';
        });
        tableString += '</tr>';
    }
    
    if (sumPoints<=10){
		recordGrade='甲级'
	}
	if (sumPoints>=11&&sumPoints<=25)
	{
		recordGrade='乙级'
	}
	if (sumPoints>25){
		recordGrade='丙级'
	}
	
	if (KSsumPoints<=10){
		KSrecordGrade='甲级'
	}
	if (KSsumPoints>=11&&KSsumPoints<=25)
	{
		KSrecordGrade='乙级'
	}
	if (KSsumPoints>25){
		KSrecordGrade='丙级'
	}
    
	tableString+='<tr style="text-align:center">'+ '\n<td>合计得分'+ '</td>'+'<td>'+(100-KSsumPoints)+ '</td>'+'<td>'+(100-sumPoints)+'</td>'+'<td>'+ '</td></tr>' 
	tableString+='<tr style="text-align:center">'+ '\n<td>病历等级'+ '</td>'+'<td>'+KSrecordGrade+ '</td>'+'<td>'+ recordGrade+'</td>'+'<td>'+ '</td></tr>' 
	tableString+='<tr style="text-align:center">'+ '\n<td>病历检查者签名'+ '</td>'+'<td>'+ '</td>'+'<td>'+ '</td>'+'<td>'+ '</td></tr>' 
	tableString+='<tr style="text-align:center">'+ '\n<td>优缺点'+ '</td>'+'<td>'+ '</td>'+'<td>'+ '</td>'+'<td>'+ '</td></tr>' 
	
    tableString += '</table>';
   	tableData=tableString
    window.open(
    "../csp/dhc.emr.quality.preprint.csp?patientName="+patientName+'&MedicareNo='+MedicareNo+'&BedNo='+BedNo+'&DocName='+DocName+'&locName='+locName,
    "预览","width="+window.screen.width*0.6+",height="+window.screen.height*0.6);
}

function getTableData(){
	if (tableData==""){
		return "表格加载失败!"
	}
	return tableData
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

function Recall(MessageID) {
	    var ret = ""
	    var obj = $.ajax({
	        url: "../web.eprajax.AjaxEPRMessage.cls?Action=recallmmessage&MessageIDS=" + MessageID + "&UserID=" + SignUserID,
	        type: 'post',
	        async: false
	    });
	    var ret = obj.responseText;
	    if ((ret != "" || (ret != null)) && (ret != "-1")) {
		    $.messager.alert("提示","撤回成功！");
	        $('#dgCurQualityResult').datagrid('reload');
	    }
	    else {
	        $.messager.alert('错误', '撤回失败！', 'error');
	    }	
}

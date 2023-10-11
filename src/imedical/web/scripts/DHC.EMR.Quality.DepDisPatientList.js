$(function(){
	
	initcombox();
	InitDataList();
	if (Action=="MD") $('#Type').combobox('setValue',"U");
	$(document).keydown(function(e){
     if (e.keyCode==13) doSearch()
	 });
	if(HISUIStyleCode == 'lite'){
		$('.lite_back').css({'background-color':'#f5f5f5'})
	}
});
var refreshRowIndex=""
var eprPatient= new Object();
eprPatient.Type = "";
eprPatient.YType = "";
eprPatient.StartDate = "";
eprPatient.EndDate = "";
eprPatient.MedRecordNo = "";
eprPatient.RegNo = "";
eprPatient.Name = "";
eprPatient.CTLocID = "";
eprPatient.DocCommit = "";
eprPatient.NurCommit = "";
eprPatient.PDFCreated = "";
eprPatient.specialAdm="";
eprPatient.doctorID="";
eprPatient.RcFlag="";
eprPatient.AEpisodeID="";
//病人列表初始化
function InitDataList()
{
	
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
			//fitColumns: true,
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.disPatientList.cls',
			//'../EPRservice.Quality.Ajax.paProInfoList.cls',
			queryParams: {
				Type: eprPatient.Type,
				YType: eprPatient.YType,
				StartDate: eprPatient.StartDate,
				EndDate: eprPatient.EndDate,
				MedRecordNo: eprPatient.MedRecordNo,
				RegNo: eprPatient.RegNo,
				Name: eprPatient.Name,
				CTLocID: eprPatient.CTLocID,
				DocCommit: eprPatient.DocCommit,
				NurCommit: eprPatient.NurCommit,
				PDFCreated: eprPatient.PDFCreated,
				SpecialAdm:eprPatient.specialAdm,
				doctorID:eprPatient.doctorID,
				RcFlag:eprPatient.RcFlag,
				AEpisodeID:eprPatient.AEpisodeID
            },
			fit:true,
			columns:[[
				{field: 'ckb', checkbox: true },
				{field:'ReviewStatus',title:'科室审核',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){							
							if (row.ReviewStatus=="是"){
								return 'background-color:#2ab66a;color:#ffffff';
							}
							if (row.ReviewStatus=="否"){
								return 'background-color:#ff5252;color:#ffffff';
							}
							if (row.ReviewStatus=="已退回"){
								return 'background-color:#ffb746;color:#ffffff';
							}
						}else{
							if (row.ReviewStatus=="是"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							if (row.ReviewStatus=="否"){
								return 'background-color:#FFEDEB;color:#ff1414';
							}
							if (row.ReviewStatus=="已退回"){
								return 'background-color:#FFFAE8;color:#FFA200';
							}
						}
						
					}
				},
				{field:'EprDocStatusDesc',title:'医生提交',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){
							if (row.EprDocStatusDesc=="是"){
								return 'background-color:#2ab66a;color:#ffffff';
							}
							if (row.EprDocStatusDesc=="否"){
								return 'background-color:#ff5252;color:#ffffff';
							}
						}else{
							if (row.EprDocStatusDesc=="是"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							if (row.EprDocStatusDesc=="否"){
								return 'background-color:#FFEDEB;color:#ff1414';
							}
						}
					}
				},
				{field:'EprNurStatusDesc',title:'护士提交',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){
							if (row.EprNurStatusDesc=="是"){
								return 'background-color:#2ab66a;color:#ffffff';
							}
							if (row.EprNurStatusDesc=="否"){
								return 'background-color:#ff5252;color:#ffffff';
							}
						}else{
							if (row.EprNurStatusDesc=="是"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							if (row.EprNurStatusDesc=="否"){
								return 'background-color:#FFEDEB;color:#ff1414';
							}
						}
					}
				},
				{field:'EprPdfStatusDesc',title:'PDF生成',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){
							if (row.EprPdfStatusDesc=="是"){
								return 'background-color:#2ab66a;color:#ffffff';
							}
							if (row.EprPdfStatusDesc=="否"){
								return 'background-color:#ff5252;color:#ffffff';
							}
						}else{
							if (row.EprPdfStatusDesc=="是"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							if (row.EprPdfStatusDesc=="否"){
								return 'background-color:#FFEDEB;color:#ff1414';
							}
						}
					}
				},
				{field:'RCInfo',title:'回收',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){
							if (row.RCInfo=="是"){
								return 'background-color:#2ab66a;color:#ffffff';
							}
							if (row.RCInfo=="否"){
								return 'background-color:#ff5252;color:#ffffff';
							}
						}else{
							if (row.RCInfo=="是"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							if (row.RCInfo=="否"){
								return 'background-color:#FFEDEB;color:#ff1414';
							}
						}
					}
				},
				{field:'disReviewStatus',title:'终末审核',width:100,align:'left',hidden:(Action=="MD"),
					styler: function(value,row,index){
						if(HISUIStyleCode!=='lite'){							
							if (row.disReviewStatus=="是"){
								return 'background-color:#2ab66a;color:#ffffff';
							}
							if (row.disReviewStatus=="否"){
								return 'background-color:#ff5252;color:#ffffff';
							}
							if (row.disReviewStatus=="已退回"){
								return 'background-color:#ffb746;color:#ffffff';
							}
						}else{
							if (row.disReviewStatus=="是"){
								return 'background-color:#E9FFE3;color:#58CF00';
							}
							if (row.disReviewStatus=="否"){
								return 'background-color:#FFEDEB;color:#ff1414';
							}
							if (row.disReviewStatus=="已退回"){
								return 'background-color:#FFFAE8;color:#FFA200';
							}
						}
					}
				},
				{field:'BrowseVier',title:'病历浏览',width:100,align:'left',
					formatter:function(value,row,index){ 
					
					return '<span style="color:#339eff;cursor:pointer" onMouseOver="hover(this)" onMouseOut="hoverOut(this)">'+emrTrans("病历浏览")+'</span>'
					}
				},
				{field:'Entry',title:'手工质控',width:100,align:'left',
					formatter:function(value,row,index){ 
					
					return '<span style="color:#339eff;cursor:pointer" onMouseOver="hover(this)" onMouseOut="hoverOut(this)">'+emrTrans("手工质控")+'</span>'
					}
				},
				{field:'Log',title:'操作记录',width:100,align:'left',
					formatter:function(value,row,index){ 
					return '<span style="color:#339eff;cursor:pointer" onMouseOver="hover(this)" onMouseOut="hoverOut(this)" >'+emrTrans("操作记录")+'</span>'
					}
				},
				{field:'ProblemFlag',title:'时效缺陷',width:100,align:'left', 
				formatter:function(value,row,index){  
   					if(row.ProblemFlag != 0 ){
         			return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
     				}
 				}},
				{field:'MedRecordNo',title:'病案号',width:100,align:'left'},
				{field:'RegNo',title:'登记号',width:100,align:'left'},
				{field:'PAPMIName',title:'姓名',width:100,align:'left'},
				{field:'Age',title:'年龄',width:100,align:'left'},
				{field:'PAPMISex',title:'性别',width:100,align:'left'},
				{field:'Illness',title:'病情',width:100,align:'left',
				formatter:function(value){
					return emrTrans(value)
				}
				},
				{field:'ResidentDays',title:'住院天数',width:100,align:'left'},
				{field:'AdmDateTime',title:'入院时间',width:150,align:'left'},
				{field:'QualityFlag',title:'环节质控',width:100,align:'left',
				formatter:function(value,row,index){  
   					if(row.QualityFlag == "Y" ){
         			return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
     				}
 				}},
				{field:'DisDateTime',title:'出院日期',width:150,align:'left'},
				{field:'PAAdmDepCodeDR',title:'就诊科室',width:130,align:'left'},
				{field:'TransLocFlag',title:'转科标志',width:100,align:'left',
				formatter:function(value){
					return emrTrans(value)
				}
				},
				{field:'MainDiagnos',title:'诊断',width:100,align:'left'},
				{field:'PAAdmDocCodeDR',title:'主治医生',width:100,align:'left'},
				{field:'BedNo',title:'床号',width:100,align:'left'}
			]],
		
			onClickCell: function(rowIndex, field, value) {
				var rows = $('#patientListTable').datagrid('getRows');
				var row = rows[rowIndex];
				var episodeID = row.EpisodeID;
				if(field =='Entry'){
					var flag1=DoRecipit(episodeID)
					if (flag1==1)
					{
						var ip=getIpAddress()
						if (Action=="MD")
						{
							var urlstr = "dhc.emr.quality.depdischeckrule.csp?EpisodeID="+episodeID+ '&action='+Action+'&Ip='+ip;
						}
						else
						{
							var urlstr = "dhc.emr.quality.paperlesscheckrule.csp?EpisodeID="+episodeID+ '&action='+Action+'&Ip='+ip;	
						}
						if('undefined' != typeof websys_getMWToken)
						{
							urlstr += "&MWToken="+websys_getMWToken()
						}
						refreshRowIndex=rowIndex
						window.open (urlstr,'newwindowQuality','top=-33,left=3,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ')
					}else if (flag1=="DocErr")
					{
						$.messager.alert("提示","医生未提交，不能质控！");
					}else if (flag1="DepErr")
					{
						$.messager.alert("提示","科室终末质控未通过，不能质控！");	
					}else{
						$.messager.alert("提示","错误！");
					}
				}
				if (field=="Log")
				{
					var urlstr = "dhc.emr.quality.depdislog.csp?EpisodeID="+episodeID;
					websys_showModal({
						iconCls:'icon-w-eye',
						url:urlstr,
						title:$g(emrTrans('操作日志')),
						width:500,height:400
						});
					//createModalDialog("depdislog","操作日志","500","400","iframedepdislog","<iframe id='iframedepdislog' scrolling='auto' frameborder='0' src='" + urlstr +"' style='width:500px; height:350px; display:block;'></iframe>","","")	
				}
				if (field == "BrowseVier")
				{
					var urlstr = "emr.browse.quality.csp?EpisodeID="+episodeID;
					if('undefined' != typeof websys_getMWToken)
					{
						urlstr += "&MWToken="+websys_getMWToken()
					}
					window.open (urlstr,'newwindowQuality','top=-33,left=3,width='+window.screen.width+',height='+window.screen.height+',toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ')
				}
			},
			loadFilter:function(data)
			{
				if(typeof data.length == 'number' && typeof data.splice == 'function'){
					data={total: data.length,rows: data}
				}
				var dg=$(this);
				var opts=dg.datagrid('options');
				var pager=dg.datagrid('getPager');
				pager.pagination({
					onSelectPage:function(pageNum, pageSize){
						opts.pageNumber=pageNum;
						opts.pageSize=pageSize;
						pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
						dg.datagrid('loadData',data);
					}
				});
				if(!data.originalRows){
					data.originalRows = (data.rows);
				}
				var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
				return data;
			}
			}); 
}
function hover(obj){
	obj.style.textDecoration = "underline";
}
function hoverOut(obj){
	obj.style.textDecoration = "none";
}
function initcombox()
{
	var Typebox = $HUI.combobox("#Type",{
			valueField:'id',
			textField:'text',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			data:[
				{id:'U',text:emrTrans('科室未审核')},{id:'F',text:emrTrans('科室已通过')},{id:'B',text:emrTrans('科室已退回')}
			]
	});
	var YTypebox = $HUI.combobox("#YType",{
			valueField:'id',
			textField:'text',
			multiple:true,
			rowStyle:'checkbox', 
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'U',text:emrTrans('院级未审核')},{id:'F',text:emrTrans('院级已通过')},{id:'B',text:emrTrans('院级已退回')}
			]
	});
	var DocCommitbox = $HUI.combobox("#DocCommit",{
			valueField:'id',
			textField:'text',
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'y',text:emrTrans('是'),selected:true},{id:'n',text:emrTrans('否')}
			]
	});
	var NurCommitbox = $HUI.combobox("#NurCommit",{
			valueField:'id',
			textField:'text',
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'y',text:emrTrans('是')},{id:'n',text:emrTrans('否')}
			]
	});
	var PDFCreatedbox = $HUI.combobox("#PDFCreated",{
			valueField:'id',
			textField:'text',
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'y',text:emrTrans('是')},{id:'n',text:emrTrans('否')}
			]
	});
	var RcFlagbox = $HUI.combobox("#RcFlag",{
			valueField:'id',
			textField:'text',
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'y',text:emrTrans('是')},{id:'n',text:emrTrans('否')}
			]
	});
	$('#ctLocID').combobox
	({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID,
		mode:'remote',
		onChange: function (n,o) {
			$('#ctLocID').combobox('setValue',n);
		    var newText = $('#ctLocID').combobox('getText');
			$('#ctLocID').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID+'&Filter='+encodeURI(newText.toUpperCase()));
		},
		onSelect: function(record){
			
	    } 
    
    });
	$('#ssUser').combobox
	({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=ssUser&userLocID='+userLocID, 
		mode:'remote',
		onChange: function (n,o) {
			$('#ssUser').combobox('setValue',n);
		    var newText = $('#ssUser').combobox('getText');
			$('#ssUser').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=ssUser&userLocID='+userLocID+'&doctorName='+encodeURI(newText.toUpperCase())); //
		},
		onSelect: function(record){
			
	    }
	});
    $('#RegNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				setpatientNoLength();
			}
		});
}
///初始化重点患者下拉多选框
$(function(){
	var cbox = $HUI.combobox("#specialAdm",{
		valueField:'id',
		textField:'text',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'OverAdm',text:emrTrans('住院超过31天患者')},
			{id:'TerminallyIll',text:emrTrans('病危患者')},
			{id:'DiseaseSeve',text:emrTrans('病重患者')},
			{id:'Salvage',text:emrTrans('抢救患者')}
		]
		
		
	})
});
function setpatientNoLength(){
	var RegNo = $("#RegNo").val();
	if (RegNo != '') {
		for (var i=(10-RegNo.length-1); i>=0; i--){
			RegNo ="0"+ RegNo;
		}
	}
	$("#RegNo").val(RegNo);
	
}

//查询按钮事件
function doSearch() {
     var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.Type=""+$("#Type").combobox('getValues')+""
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');
     queryParams.EndDate =$("#inputCreateDateEnd").datetimebox('getText');
     queryParams.MedRecordNo = $("#MedRecordNo").val();
     queryParams.RegNo=$("#RegNo").val();
     queryParams.Name=$("#Name").val()
     queryParams.DocCommit=$("#DocCommit").combobox('getValue');
	 if (Action=="MD"){	 
     	queryParams.CTLocID = userLocID
		queryParams.doctorID=$("#ssUser").combobox('getValue');
     }else{
	     queryParams.CTLocID =$("#ctLocID").combobox('getValue')
	     queryParams.SpecialAdm =$("#specialAdm").combobox('getValues')+""
		 queryParams.YType=""+$("#YType").combobox('getValues')+""
	 }
	 queryParams.NurCommit = $("#NurCommit").combobox('getValue');
     queryParams.PDFCreated = $("#PDFCreated").combobox('getValue');
	 queryParams.RcFlag = $("#RcFlag").combobox('getValue');
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   
    //AType,AStartDate,AEndDate,AMedRecordNo,ARegNo,AName,ACTLocID,ADocCommit,ANurCommit,APDFCreated
}

function DoRecipit(episodeID)
{
	var result="0"
	jQuery.ajax({
			type: "get",
			dataType: "text",
			url: "../EPRservice.Quality.SetDepDisFlag.cls",
			async: false,
			data: {
				"EpisodeID":episodeID,
				"SignUserID":userID,
				"action":Action,
				"Action":"SetReceiptFlag"
			},
			success: function(d) {
				if ((d ==1)||(d=="ReciErr"))
				{
					result=1
				}else if (d=="DocErr")
				{
					result="DocErr";
				}else if (d=="DepErr")
				{
					result="DepErr"
				}else
				{
					result="Err";
				}
			}
		});	
		
		return result	
}

function doPass(){	
	var PassDataStr = ""
	var PassSelectRows=$("#patientListTable").datagrid("getSelections");
	if (PassSelectRows.length == 0) 
	{	
	$.messager.alert("提示","请选择项！");
			return;
	}

	for(var i=0; i<PassSelectRows.length; i++){
		var EpisodeID = PassSelectRows[i].EpisodeID;
		if (PassDataStr=="")
		{
			var PassDataStr=EpisodeID	
		}else{
			var PassDataStr=PassDataStr+"^"+EpisodeID		
		}
	}
	$('#patientListTable').datagrid('clearChecked'); 
	
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":PassDataStr,
			"SignUserID":userID,
			"action":Action,
			"Action":"SetPassFlagDetail"
		},
		success: function(d) {
			if (d ==1 )
			{
				$.messager.alert("提示","确认成功！");
				$('#patientListTable').datagrid('reload');
			}else if (d=="DocErr")
			{
				$.messager.alert("提示","医生未提交，不能审核通过！");
			}else if (d=="DepErr")
			{
				$.messager.alert("提示","科室终末质控未通过，不能审核通过！");
			}else if (d=="ScoreErr")
			{
				$.messager.alert("提示","分数不到90分，不能审核通过！");
			}else if (d=="PassErr")
			{
				$.messager.alert("提示","该病历已审核通过，不能再进行操作！");
			}else if (d=="-1")
			{
				$.messager.alert("提示","失败！");
			}else
			{
				d=d.replace(new RegExp("&","gm"),"<br>")
				$.messager.alert("提示",d,"info").window({width:500});
			}
		}
	});
}

function doDocRetreatConfirm()
{	
	var oldOk = $.messager.defaults.ok;
	var oldCancel = $.messager.defaults.cancel;
	$.messager.defaults.ok = "退回";
	$.messager.defaults.cancel = "取消";
	$.messager.confirm("确认", "确定退回?", function (r) {
		if (r) {
			doDocRetreat()
		} else {
			$.messager.popover({ msg: "点击了取消" });
		}
		/*要写在回调方法内,否则在旧版下可能不能回调方法*/
		$.messager.defaults.ok = oldOk;
		$.messager.defaults.cancel = oldCancel;
	});		
}

function doDocRetreat(){
	var PassDataStr = ""
	var PassSelectRows=$("#patientListTable").datagrid("getSelections");
	if (PassSelectRows.length == 0) 
	{	
	$.messager.alert("提示","请选择项！");
			return;
	}

	for(var i=0; i<PassSelectRows.length; i++){
		var EpisodeID = PassSelectRows[i].EpisodeID;
		if (PassDataStr=="")
		{
			var PassDataStr=EpisodeID	
		}else{
			var PassDataStr=PassDataStr+"^"+EpisodeID		
		}
	}
	$('#patientListTable').datagrid('clearChecked'); 

	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":PassDataStr,
			"SignUserID":userID,
			"action":Action,
			"Action":"CancelDoctor",
			"Ip":getIpAddress()
		},
		success: function(d) {
			
			if (d ==1 )
			{
				$.messager.alert("提示","医生退回成功！");
				$('#patientListTable').datagrid('reload');
			}else if (d=="DocErr")
			{
				$.messager.alert("提示","医生未提交，医生退回失败！");
			}else if (d=="WMRErr")
			{
				$.messager.alert("提示","病历已回收，医生退回失败！");
			}else if (d=="PassErr")
			{
				$.messager.alert("提示","该病历已审核通过，不能再进行操作！");
			}else if (d=="CancelRecoveryErr")
			{
				$.messager.alert("提示","病历取消回收失败，医生退回失败！");
			}else if (d=="-1")
			{
				$.messager.alert("提示","医生退回失败！");
			}else
			{
				$.messager.alert("提示",d);
			}
		}
	});		
}
//先不要用这个护士退回
function InActivedoNurRetreat(){
	var PassDataStr = ""
	var PassSelectRows=$("#patientListTable").datagrid("getSelections");
	if (PassSelectRows.length == 0) 
	{	
	$.messager.alert("提示","请选择项！");
			return;
	}

	for(var i=0; i<PassSelectRows.length; i++){
		var EpisodeID = PassSelectRows[i].EpisodeID;
		if (PassDataStr=="")
		{
			var PassDataStr=EpisodeID	
		}else{
			var PassDataStr=PassDataStr+"^"+EpisodeID		
		}
	}
	$('#patientListTable').datagrid('clearChecked'); 

	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":PassDataStr,
			
			"Action":"CancelNurse"
		},
		success: function(d) {
			
			if (d ==1 )
			{
				$.messager.alert("提示","护士退回成功！");
				$('#patientListTable').datagrid('reload');
			}else
			{
				$.messager.alert("提示","护士失败！");
			}
		}
	});		
}
//先不要用这个全部退回
function InActivedoRetreat()
{
	var PassDataStr = ""
	var PassSelectRows=$("#patientListTable").datagrid("getSelections");
	if (PassSelectRows.length == 0) 
	{	
	$.messager.alert("提示","请选择项！");
			return;
	}

	for(var i=0; i<PassSelectRows.length; i++){
		var EpisodeID = PassSelectRows[i].EpisodeID;
		if (PassDataStr=="")
		{
			var PassDataStr=EpisodeID	
		}else{
			var PassDataStr=PassDataStr+"^"+EpisodeID		
		}
	}
	$('#patientListTable').datagrid('clearChecked'); 

	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":PassDataStr,
			"SignUserID":userID,
			"Action":"CancelDoctor"
		},
		success: function(d) {
			
			if (d ==1 )
			{
				$.messager.alert("提示","医生退回成功！");
				$('#patientListTable').datagrid('reload');
			}else if (d=="DocErr")
			{
				$.messager.alert("提示","医生未提交，医生退回失败！");
			}else
			{
				$.messager.alert("提示","医生退回失败！");
			}
		}
	});		
	
		jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EPRservice.Quality.SetDepDisFlag.cls",
		async: true,
		data: {
			"EpisodeID":PassDataStr,
			
			"Action":"CancelNurse"
		},
		success: function(d) {
			
			if (d ==1 )
			{
				$.messager.alert("提示","护士退回成功！");
				$('#patientListTable').datagrid('reload');
			}else
			{
				$.messager.alert("提示","护士失败！");
			}
		}
	});		
}

//导出excel
function makeExcel(){
    var options = $('#patientListTable').datagrid('getPager').data("pagination").options; 
    var curr = options.pageNumber; 
    var total = options.total;
    var pager = $('#patientListTable').datagrid('getPager');
    var rows = [] 
    var limit=(total/options.pageSize)
    if (Math.floor(limit)!=limit)
    {
	    var limit= limit+1
	  }
    for (i=1;i<=limit;i++)
    {
	     pager.pagination('select',i);
         pager.pagination('refresh');
         var currows =  $('#patientListTable').datagrid('getRows');
         if (currows.length==0)
         {
	         continue;
	     }
         for (var j in currows)
         {
	         rows.push(currows[j]);
	     }
         //rows.concat(currows);
	}
	 pager.pagination('select',curr);
     pager.pagination('refresh');
	$('#patientListTable').datagrid('toExcel',{
		filename:'终末质控.xls',
		rows:rows
		});
	}
	
function refreshRow(Episodeid)
{
	jQuery.ajax({
	type: "get",
	dataType: "text",
	url: "../EPRservice.Quality.Ajax.disPatientList.cls",
	async: true,
	data: {
			Type: eprPatient.Type,
			YType: eprPatient.YType,
			StartDate: eprPatient.StartDate,
			EndDate: eprPatient.EndDate,
			MedRecordNo: eprPatient.MedRecordNo,
			RegNo: eprPatient.RegNo,
			Name: eprPatient.Name,
			CTLocID: eprPatient.CTLocID,
			DocCommit: eprPatient.DocCommit,
			NurCommit: eprPatient.NurCommit,
			PDFCreated: eprPatient.PDFCreated,
			SpecialAdm:eprPatient.specialAdm,
			doctorID:eprPatient.doctorID,
			RcFlag:eprPatient.RcFlag,
			AEpisodeID:Episodeid
	},
	success: function(d) {
		//console.log(d)
		var result=jQuery.parseJSON(d)
		if (result.total==0)
		{
			$('#patientListTable').datagrid('deleteRow',refreshRowIndex)	
		}else{
		$('#patientListTable').datagrid('updateRow',{
			index: refreshRowIndex,
			row: result.rows[0]
		});
		}
	}
	});	
}
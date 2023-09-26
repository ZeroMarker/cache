var objFeedBackQry = new Object();
objFeedBackQry.CurrentSubjectID = "";

objFeedBackQry.init = function()
{
	var ctrlItems = ExtTool.RunServerMethod("DHCMed.CCService.Sys.SubjectConfig", "GetCtrlItemsByConfigCode", ViewConfigCode);
	
	objFeedBackQry.objTpl = new Ext.XTemplate(
		'<div class="all">',
			'<div class="SubTotal">',
				'<table width="100%">',
					'<tr>',
						 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
						 '<td width="160" class="SubTotal_td">查找到的病例数量：</td>',
						 '<td width="160" class="SubTotal_td"><span class="SubTotal_Number">{totalCount}个</span></td>',
						 '<td width="60%" class="SubTotal_td"></td>',
					'</tr>',
				'</table>',
			'</div>',
			'<tpl for=".">',
				'<div id="frame-{SummaryID}" CLASS="t-bg">',
					'<div class="t-header">',
						'<div class="t-header-left">',
							'<div class="t-header-text">{PatientName}&nbsp;&nbsp;{PatNo}&nbsp;&nbsp;{Sex}&nbsp;&nbsp;{Age}&nbsp;&nbsp;{AdmitDate}&nbsp;&nbsp;{Ward}&nbsp;&nbsp;{Doctor}&nbsp;&nbsp;',
								'<div class="ButtonGroup">',
									'<a href="#" onclick="return objFeedBackQry.viewPatientInfo({EpisodeID},{CtlSummaryID})"><img src="../scripts/dhcmed/img/cc/summary.png" alt="摘要" /></a>',
									'{[this.FeedbackEvaHTML(values)]}',
								'</div>',
							'</div>',
						'</div>',
					'</div>',
					'<div class="mas">',
						'<div class="lim">',
							'<div id="divFeedbackList-{FeedbackRowID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
							'<div id="divCtlResult-{FeedbackRowID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
							'<div id="divInf-{FeedbackRowID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
							'{[this.FeedbackMsgHTML(values)]}',
						'</div>',
					'</div>',
				'</div>',	
			 '</tpl>',
		'</div>',
		{
			FeedbackEvaHTML : function(values) {
				if (values.IsEva != '') {
					var str='<img src="../scripts/dhcmed/img/cc/feedbackevano.png" alt="已评价" />'
				} else {
					var FeedbackRowID = values.FeedbackRowID;
					var LnkFeedBackIDs = values.LnkFeedBackIDs;
					var str='<a href="#" onclick="return objFeedBackQry.btnFeedbackEva_onclick(' + FeedbackRowID + ',\'' + LnkFeedBackIDs + '\');"><img src="../scripts/dhcmed/img/cc/feedbackeva.png" alt="评价" /></a>'
				}
				return str;
			},
			FeedbackMsgHTML : function(values) {
				var EpisodeID = values.EpisodeID;
				var SummaryID = values.CtlSummaryID;
				var FeedbackRowID = values.FeedbackRowID;
				
				var strTitle = '<strong>'+values.PatientName + '</strong><strong>' +
					'<span class="Result_Item_Title"> 就诊卡号：</span></strong>' + values.PatNo + 
					'<strong><span class="Result_Item_Title"> 性别：</span></strong>' + values.Sex +
					'<strong><span class="Result_Item_Title"> 年龄：</span></strong>' + values.Age +
					'<strong><span class="Result_Item_Title">入院日期：</span></strong>' + values.AdmitDate + 
					'<strong><span class="Result_Item_Title"> 科室：</span></strong>' + values.Department +
					'<strong><span class="Result_Item_Title"> 病房：</span></strong>' + values.Ward + 
					'<strong><span class="Result_Item_Title"> 床位</span></strong>' + values.Bed;
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.FeedBackService',
						QueryName : 'QryFeedBackDtl',
						Arg1 : "",
						Arg2 : values.LnkFeedBackIDs,
						Arg3 : "",
						ArgCnt : 3
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							arryData[arryData.length] = objItem;
						}
						objINTCCommon.RenderFeedback("divFeedbackList-" + FeedbackRowID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divFeedbackList-" + FeedbackRowID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divFeedbackList-" + FeedbackRowID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});								
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.ResultService',
						QueryName : 'QryCtlResultDtl',
						Arg1 : "",
						Arg2 : values.LnkFeedBackIDs,
						Arg3 : ctrlItems,
						ArgCnt : 3
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
						objItem = objData.record[i];
						arryData[arryData.length] = objItem;
						}
						objINTCCommon.RenderCtlResult("divCtlResult-" + FeedbackRowID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divCtlResult-" + FeedbackRowID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divCtlResult-" + FeedbackRowID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.EpisodeService',
						QueryName : 'QryInfReportByEpisodeID',
						Arg1 : EpisodeID,
						ArgCnt : 1
					},
					success: function(response, opts) {
						var objData = Ext.decode(response.responseText);
						var arryData = new Array();
						var objItem = null;
						for(var i = 0; i < objData.total; i ++)
						{
							objItem = objData.record[i];
							arryData[arryData.length] = objItem;
						}
						objINTCCommon.RenderInfReport("divInf-" + FeedbackRowID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divInf-" + FeedbackRowID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divInf-" + FeedbackRowID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});	
			}
		}
	);
	
	var arryDateTypeData = [
        ['3', '消息日期'],
        ['4', '响应日期'],
		['1', '入院日期'],
		['2', '出院日期']
	];
		
    var objDataTypeStore = new Ext.data.ArrayStore({
        fields: [
           {name: 'Code'},
           {name: 'Desc'}
        ]
    });

    // manually load local data
    objDataTypeStore.loadData(arryDateTypeData);
	objFeedBackQry.cboDateType = new Ext.form.ComboBox({
		id : 'cboDateType',
        store: objDataTypeStore,
        displayField:'Desc',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
		valueField : 'Code',
		editable : false,
		width : 90
    });
	
	objFeedBackQry.dtFromDate=new Date(new Date()-24*60*60*1000);	//update by lyh 开始日期为 昨天 2012-09-06	
	objFeedBackQry.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate',
		fieldLabel : '开始日期',
		format : 'Y-m-d',
		value : objFeedBackQry.dtFromDate,
		width : 90,
		xtype : 'datefield'
	});
	objFeedBackQry.dtToDate = new Ext.form.DateField({
		id : 'dtToDate',
		fieldLabel : '结束日期',
		format : 'Y-m-d',
		value : new Date(),
		width : 90,
		xtype : 'datefield'			
	});
	objFeedBackQry.rdoNotRead = new Ext.form.Radio({
		id : 'rdoNotRead',
		boxLabel : '未阅读',
		xtype : 'radio',
		name : 'rdoFeedBackStatus',
		checked : false					
	});
	objFeedBackQry.rdoAccept = new Ext.form.Radio({
		id : 'rdoAccept',
		boxLabel : '接受',
		xtype : 'radio',
		name : 'rdoFeedBackStatus',
		checked : true					
	});				
	objFeedBackQry.rdoReject = new Ext.form.Radio({
		id : 'rdoReject',
		boxLabel : '拒绝',
		xtype : 'radio',
		name : 'rdoFeedBackStatus',
		checked : false					
	});
	
	objFeedBackQry.Active = new Ext.form.Checkbox({
		id : 'Active',
		boxLabel : '有特异指标',
		checked : true
	});
		
	objFeedBackQry.btnQryFeedBack = new Ext.Button({
		text : '查询',
		icon  : '../scripts/dhcmed/img/find.gif',
		xtype : 'button' ,
		handler: function(){
			objFeedBackQry.btnQryFeedBack_click();
		}		
	});
	
	objFeedBackQry.QryFeedBackStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	objFeedBackQry.QryFeedBackStore = new Ext.data.Store({
		proxy: objFeedBackQry.QryFeedBackStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'FeedbackRowID'
		}, 
		[
			{name: 'FeedbackRowID', mapping: 'FeedbackRowID'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'CtlSummaryID', mapping: 'CtlSummaryID'}
			,{name: 'SubjectID', mapping: 'SubjectID'}
			,{name: 'ToDepartment', mapping: 'ToDepartment'}
			,{name: 'ToDepartmentDesc', mapping: 'ToDepartmentDesc'}
			,{name: 'ToUser', mapping: 'ToUser'}
			,{name: 'ToUserDesc', mapping: 'ToUserDesc'}
			,{name: 'FeedBackNote', mapping: 'FeedBackNote'}
			,{name: 'FeedBackUser', mapping: 'FeedBackUser'}
			,{name: 'FeedBackDate', mapping: 'FeedBackDate'}
			,{name: 'FeedBackTime', mapping: 'FeedBackTime'}
			,{name: 'ReceiveNote', mapping: 'ReceiveNote'}
			,{name: 'ReceiveUser', mapping: 'ReceiveUser'}
			,{name: 'ReceiveDate', mapping: 'ReceiveDate'}
			,{name: 'ReceiveTime', mapping: 'ReceiveTime'}
			,{name: 'ReceiveResult', mapping: 'ReceiveResult'}
			,{name: 'ControlCorrect', mapping: 'ControlCorrect'}
			,{name: 'ControlInCorrectReason', mapping: 'ControlInCorrectReason'}
			,{name: 'ReportOnTime', mapping: 'ReportOnTime'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PatNo', mapping: 'PatNo'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'Department', mapping: 'Department'}
			,{name: 'Ward', mapping: 'Ward'}
			,{name: 'TotalScore', mapping: 'TotalScore'}
			,{name: 'ScoreThisTime', mapping: 'ScoreThisTime'}
			,{name: 'SensitiveAmount', mapping: 'SensitiveAmount'}
			,{name: 'SpecificityAmount', mapping: 'SpecificityAmount'}
			,{name: 'FireItemCount', mapping: 'FireItemCount'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'Days', mapping: 'Days'}
			,{name: 'IsEva', mapping: 'IsEva'}
			,{name: 'FeedBackCnt', mapping: 'FeedBackCnt'}
			,{name: 'AcceptFeedbackCnt', mapping: 'AcceptFeedbackCnt'}
			,{name: 'RejectFeedbackCnt', mapping: 'RejectFeedbackCnt'}
			,{name: 'NoResponseFeedbackCnt', mapping: 'NoResponseFeedbackCnt'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'LnkFeedBackIDs', mapping: 'LnkFeedBackIDs'}
		])
	});
	objFeedBackQry.QryFeedBackStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.Feedback.FeedBackService';
		param.QueryName = 'QryByDate';
		param.Arg1 = Ext.getCmp("dtFromDate").getRawValue();
		param.Arg2 = Ext.getCmp("dtToDate").getRawValue();
		param.Arg3 = Ext.getCmp("cboDateType").getValue();
		param.Arg4 = objFeedBackQry.CurrentSubjectID;
		param.Arg5 = 0;
		if(Ext.getCmp("rdoNotRead").getValue()) param.Arg5 = 0;
		if(Ext.getCmp("rdoAccept").getValue()) param.Arg5 = 1;
		if(Ext.getCmp("rdoReject").getValue()) param.Arg5 = 2;
		param.Arg6 = Ext.getCmp("Active").getValue()? "1" : "0";
		param.ArgCnt = 6;
	});
		
	objFeedBackQry.pnScreen = new Ext.Panel({
		autoScroll : true
		,tpl : objFeedBackQry.objTpl
		,tbar : {
			items :[
				{text : '请选择查询条件：',xtype :'label'},
				objFeedBackQry.cboDateType ,
				objFeedBackQry.dtFromDate,
				{text : '至',xtype :'label'},
				objFeedBackQry.dtToDate,
				{ width : 10},
				//{text : '状态：',xtype :'label'},
				objFeedBackQry.rdoNotRead,
				objFeedBackQry.rdoAccept,
				objFeedBackQry.rdoReject,
				{ width : 10},
				objFeedBackQry.Active,
				{ width : 10},
				objFeedBackQry.btnQryFeedBack
			]
		}
		,bbar: new Ext.PagingToolbar({
			id : 'PagingToolbar',
			pageSize : 20,
			store : objFeedBackQry.QryFeedBackStore,
			displayInfo : true,
			displayMsg : '显示第{0}-{1}条数据   共{2}条数据',
			emptyMsg : '没有记录'
        })
	});
	
	objFeedBackQry.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'fit'
		,items:[
			objFeedBackQry.pnScreen
		]
	});		
	
	objFeedBackQry.viewBaseInfo
	
	InitobjFeedBackQryEvent(objFeedBackQry);
	objFeedBackQry.LoadEvent(arguments);		

}
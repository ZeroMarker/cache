
var objScreen = new Object();
objScreen.CurrentSubjectID = '';
objScreen.init = function()
{
	var ctrlItems = ExtTool.RunServerMethod("DHCMed.CCService.Sys.SubjectConfig", "GetCtrlItemsByConfigCode", ViewConfigCode);
	
	objScreen.tplWardSta = new Ext.XTemplate(
	'<div class="vertmenu">',
	'<ul>',
       '<table width="100%" border="0">',
			'<tpl for="record">',
				'<tr>',
					'<td><li><a class="vertmenu_a" onclick="objScreen.btnQuery_onClick(null, null, {ItemID}, null, \'{ItemName}\',\'\');" href="#">{ItemName}：{Number}人</li></td>',
					'<td>',
					//'<tpl for="WarnCtrl">',
					//	'<a href="#" onclick="return objScreen.DisplayWarnCtrlPatient({WardID},\'{TypeCode}\', \'{Keyword}\', \'{MinNum}\' , \'{ItemName}\')"><img src="../scripts/dhcmed/img/cc/warn.gif" title="{TypeDesc}"/></a>',
					//'</tpl>',
					'</td>',
				'</tr>',
			'</tpl>',
		'</table>',
	'</ul>',
	'</div>'
	);
	objScreen.tplItemSta = new Ext.XTemplate(
	'<div class="vertmenu">',
    '<ul>',
       '<table width="100%" border="0">',
		    '<tpl for="record">',
				'<tr>',
					'<td><li><a  class="vertmenu_a" onclick="objScreen.btnQuery_onClick(null, null, {WardID}, {ItemID}, \'\', \'\');" href="#">{ItemName}：{Number}例</a></li></td>',
				'</tr>',
			'</tpl>',
		'</table>',
	'</ul>',
	'</div>'
	);
	
	objScreen.objTplDetail = new Ext.XTemplate(
	'<div class="all">',
		'<div class="SubTotal">', 
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					 '<td width="30%" class="SubTotal_td">查找到的病例数量：</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{total}个</span></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<tpl for="record">',
			'<DIV id="frame-{SummaryID}" CLASS="t-bg">',
		     '<div class="t-header">',
			     '<div class="t-header-left">',
					'<div class="t-header-text">{FireCatFlag}&nbsp;&nbsp;{PatientName}&nbsp;&nbsp;{PatNo}&nbsp;&nbsp;{Sex}&nbsp;&nbsp;{Age}&nbsp;&nbsp;{AdmitDate}&nbsp;&nbsp;{Ward}&nbsp;&nbsp;{Doctor}&nbsp;&nbsp;',
						'<div class="ButtonGroup">',
							'<a href="#" onclick="return window.viewPatientInfo({EpisodeID},{SummaryID})"><img src="../scripts/dhcmed/img/cc/summary.png" alt="摘要" /></a>',
							'<a href="#" onclick="return objScreen.btnNoticeDoctor_onclick({SummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/cc/notice.png" alt="提示医师" /></a>',
							'<a href="#" onclick="return objScreen.btnReject_onclick({SummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/cc/reject.png" alt="排除" /></a>',
						'</div>',
					'</div>',
				 '</div>',
			 '</div>',
			 '<div class="mas">',
					'<div class="lim">',
						'<div id="divFeedbackList-{SummaryID}">{[this.FormatHTML(values.EpisodeID,values.SummaryID,values.ActDate,values)]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
						'<div id="divCtlResult-{SummaryID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
						'<div id="divInf-{SummaryID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',     
						'</div>',
					'</div>', 
				'</div>',	
			'</tpl>',
		'</div>',
		{
			FormatHTML : function(EpisodeID, SummaryID, ActDate, values){
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.FeedBackService',
						QueryName : 'QryFeedBackDtl',
						Arg1 : values.LnkSummaryIDs,
						Arg2 : "",
						Arg3 : RepType, //Add By LiYang 2013-04-07根据报告筛选报告类别
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
						objINTCCommon.RenderFeedback("divFeedbackList-" + SummaryID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divFeedbackList-" + SummaryID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divFeedbackList-" + SummaryID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
				
				//DistinctEpisodeID=1  同一时间段，同一就诊多条记录是否合并 0-不合并 其他-合并
				if (1) {
					var ctlRstDateFrom = Ext.getCmp("dtFromDate").getRawValue();
					var ctlRstDateTo = Ext.getCmp("dtToDate").getRawValue();
				} else {
					var ctlRstDateFrom = ActDate;
					var ctlRstDateTo = ActDate;
				}
				
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.ResultService',
						QueryName : 'QryCtlResultDtl',
						Arg1 : values.LnkSummaryIDs,
						Arg2 : "",
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
						objINTCCommon.RenderCtlResult("divCtlResult-" + SummaryID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divCtlResult-" + SummaryID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divCtlResult-" + SummaryID);
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
						objINTCCommon.RenderInfReport("divInf-" + SummaryID, arryData);
					},
					failure: function(response, opts) {
						//document.getElementById("divInf-" + SummaryID).innerHTML = response.responseText;
						var objTargetElement = document.getElementById("divInf-" + SummaryID);
						if (objTargetElement) {
							objTargetElement.innerHTML = response.responseText;
						}
					}
				});
			}
		}
	);
	
	objScreen.objTplLocBed = new Ext.XTemplate(
		'<div>',
		'<div class="SubTotal">',
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					 '<td width="30%" class="SubTotal_td">查找到的病例数量：</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{total}个</span></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<table  width="100%" border="0" style="padding-left:10px"><tbody>',
			'{[this.StartFormatHTML()]}',
			'<tpl for="record">',
				'{[this.FormatHTML(values,5)]}',
			'</tpl>',
			'{[this.EndFormatHTML(5)]}',
		'</tbody></table>',
		'</div>',
		{
			StartFormatHTML : function()
			{
				objScreen.PatNum = 0;
				return '';
			},
			EndFormatHTML : function(colCount)
			{
				var ret = '';
				var PatNum = objScreen.PatNum;
				if ((PatNum-1)%colCount != (colCount-1)) {
					var xcolnum = (colCount-1)-((PatNum-1)%colCount)
					for (var xcol=0;xcol<xcolnum;xcol++) {
						ret += '<td width="20%" ><table class="locbedctrl-tb" id="tb-Null' + xcol + '" width="100%"><tbody><tr><td></td><tr></tbody></table></td>'
					}
					ret += '</tr>'
				}
				return ret;
			},
			FormatHTML : function(values,colCount)
			{
				var PatNum = objScreen.PatNum;
				PatNum++;
				objScreen.PatNum = PatNum;
				
				var ret = '';
				if ((PatNum-1)%colCount == 0) ret += '<tr>';
				
				ret += '<td width="20%" valign="top" >'
				ret += '<div class="locbedctrl01">'
				ret += '<a href="#" onclick="objScreen.btnQuery_onClick(null, null, \''+values.WardID + '\', null, \'\',\''+values.EpisodeID + '\');" >'
				ret += '<table class="locbedctrl-tb" id="tb-' + values.EpisodeID + '" width="100%">'  //class="wardctrl-tb"
				ret +=     '<tr>'
				ret +=         '<td  align="center" colspan="2" style="font-size:14px" >' + values.PatientName + '(' + values.Sex + ')' + '<br></td>'
				ret +=     '</tr>'
				ret +=     '<tr>'
				ret +=         '<td  align="center" colspan="2" style="font-size:20px" ><b>' + values.Bed + '</b><br></td>'
				ret +=     '</tr>'
				
				ret +=     '<tr><td  align="right" colspan="2">'
				var arryData = values.SubCatList.split(String.fromCharCode(1));
				var arryFields = null;
				for(var i = 0; i < arryData.length; i ++)
				{
					if(arryData[i] == '') continue;
					if ((i+1)%colCount==1) {
						ret += '<br>'
					}
					arryFields = arryData[i].split('^');
					ret +=     '<span title="'+arryFields[1]+'">'
					ret +=         '<img height="16px" width="16px" src="../scripts/dhcmed/img/cc/' + ViewConfigCode +  '/' + arryFields[3] + '.png" />' + arryFields[2] 
					ret +=     '</span>&nbsp;&nbsp;'
				}
				ret +=     '</td></tr>'
				
				ret += '</table>'
				ret += '</a>'
				ret += '</div>'
				ret += '</td>'
				
				if ((PatNum-1)%colCount == (colCount-1)) ret += '</tr>';
				return ret;
			}
		}
	);
	
	objScreen.txtTemp = new Ext.form.NumberField({
		id : 'txtTemp'
		,width : 30
		,value : 1
		,fieldLabel:'同科室体温异常>'
	});
	objScreen.txtDepGerm = new Ext.form.NumberField({
		id : 'txtDepGerm'
		,width : 30
		,value : 1
		,fieldLabel : '同科室检出微生物者>'
	});
	objScreen.txtPeronalGerm = new Ext.form.NumberField({
		id : 'txtPeronalGerm'
		,width : 30
		,value : 1
		,fieldLabel : '一次就诊检出微生物类别>'
	});
	objScreen.txtDepGermKind = new Ext.form.NumberField({
		id : 'txtDepGermKind'
		,width : 30
		,value : 1
		,fieldLabel : '科室同种病原体发生数量>'
	});
	
	objScreen.gridDep = new Ext.Panel({
		id : 'gridDep'
		,region : 'center'
		//,height : 270
		//,frame : true
		,autoScroll:true
	});
	objScreen.gridKeyword = new Ext.Panel({
		id : 'gridKeyword'
		,region : 'south'
		,height : 240
		,title : "科室指标"
		//,frame : true
		,autoScroll:true
	});	
	
	objScreen.pnCondition = new Ext.Panel({
		layout : 'border',
		region : 'west',
		//frame : true,
		width : 250,
		title : '指标汇总',
		items : [
			objScreen.gridDep,
			objScreen.gridKeyword
		]
	});
	
	objScreen.pnDetail = new Ext.Panel({
		id : 'pnDetail'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,tpl : objScreen.objTplDetail
		,title : '明细'
	});
	
	objScreen.pnLocBed = new Ext.Panel({
		id : 'pnLocBed'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,tpl : objScreen.objTplLocBed
		,title : '床位图'
	});
	
	objScreen.pnFloorplan = new Ext.Panel({
		id : 'pnFloorplan'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,title : '病区床位图'
	});
	
	objScreen.pnSummary = new Ext.Panel({
		id : 'pnSummary',
		title : '摘要',
		autoScroll : true
	});
	
	objScreen.tabResult = new Ext.TabPanel({
		region : 'center',
		frame : true,
		activeTab: 0,
		items : [
			objScreen.pnSummary,
			objScreen.pnLocBed,
			objScreen.pnDetail
		]
	});
	
	objScreen.pnQryCondition = new Ext.Panel({
		region : 'south',
		split:true,
		collapsible: true,
		collapsed : true,
        lines:false,
        animCollapse:false,
        animate: false,
        collapseMode:'mini',
		collapseFirst:false,
		hideCollapseTool:true,
		border:true,
		height : 210,
		boxMinHeight : 210,
		boxMaxHeight : 210,
		frame : true,
		layout : 'form',
		title : '查询条件调整',
		items : [
			new Ext.form.FieldSet({
				title : '查询条件',
				layout : 'hbox',
				items : [
					{
						text : '查询日期',
						xtype :'label'
					},{
						id : 'dtFromDate',
						fieldLabel : '开始日期',
						format : 'Y-m-d',
						//value : new Date().add(Date.DAY, -3).format('Y-m-d'),
						value : new Date().add(Date.DAY, -1).format('Y-m-d'),
						xtype : 'datefield',
						width : 100
					},{
						text : '至',
						xtype :'label'
					},{
						id : 'dtToDate',
						fieldLabel : '结束日期',
						format : 'Y-m-d',
						value : new Date().add(Date.DAY, -1).format('Y-m-d'),
						xtype : 'datefield',
						width : 100
					},{
						width : 20
					},{
						text : '状态:',
						xtype :'label'
					},{
						id : 'rdoStatus1',
						boxLabel : '未通知',
						xtype : 'radio',
						name : 'rdoStatus'		,
						checked : true,
						value : 0
					},{
						id : 'rdoStatus2',
						boxLabel : '已通知',
						xtype : 'radio',
						name : 'rdoStatus'		,
						value : 1
					},{
						id : 'rdoStatus3',
						boxLabel : '已排除',
						xtype : 'radio',
						name : 'rdoStatus'	,
						value : 9	
					}
				]
			}),
			new Ext.form.FieldSet({
				title : '预警条件',
				layout : 'hbox',
				items : [
					{
						text : '同科室体温异常',
						xtype :'label'
					},
					objScreen.txtTemp,
					{
						text : '同科室检出微生物者',
						xtype :'label'
					},					
					objScreen.txtDepGerm,
					{
						text : '一次就诊检出微生物类别',
						xtype :'label'
					},					
					objScreen.txtPeronalGerm,
					{
						text : '科室同种病原体发生数量',
						xtype :'label'
					},					
					objScreen.txtDepGermKind			
				]
			})
		],
		buttons : [
			{
				id : 'btnQuerySummary',
				text : '查询',
				icon  : '../scripts/dhcmed/img/find.gif',
				xtype : 'button' ,
				handler: function(){
					objScreen.btnQuery_onClick();
				}
			}
		]
	});
	
	objScreen.pnResult = new Ext.Panel({
		region : 'center',
		layout : 'border',
		//frame : true,
		items : [
			objScreen.tabResult,
			objScreen.pnQryCondition
		]
	});	
	
	objScreen.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [
			objScreen.pnCondition,
			objScreen.pnResult
		]
	});	
	
	InitviewScreenEvent(objScreen);
	objScreen.LoadEvent();
}
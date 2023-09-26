
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
					'<td><li><a class="vertmenu_a" onclick="objScreen.btnQuery_onClick(null, null, {ItemID}, null, \'{ItemName}\',\'\');" href="#">{ItemName}��{Number}��</li></td>',
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
					'<td><li><a  class="vertmenu_a" onclick="objScreen.btnQuery_onClick(null, null, {WardID}, {ItemID}, \'\', \'\');" href="#">{ItemName}��{Number}��</a></li></td>',
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
					 '<td width="30%" class="SubTotal_td">���ҵ��Ĳ���������</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{total}��</span></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<tpl for="record">',
			'<DIV id="frame-{SummaryID}" CLASS="t-bg">',
		     '<div class="t-header">',
			     '<div class="t-header-left">',
					'<div class="t-header-text">{FireCatFlag}&nbsp;&nbsp;{PatientName}&nbsp;&nbsp;{PatNo}&nbsp;&nbsp;{Sex}&nbsp;&nbsp;{Age}&nbsp;&nbsp;{AdmitDate}&nbsp;&nbsp;{Ward}&nbsp;&nbsp;{Doctor}&nbsp;&nbsp;',
						'<div class="ButtonGroup">',
							'<a href="#" onclick="return window.viewPatientInfo({EpisodeID},{SummaryID})"><img src="../scripts/dhcmed/img/cc/summary.png" alt="ժҪ" /></a>',
							'<a href="#" onclick="return objScreen.btnNoticeDoctor_onclick({SummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/cc/notice.png" alt="��ʾҽʦ" /></a>',
							'<a href="#" onclick="return objScreen.btnReject_onclick({SummaryID},\'{LnkSummaryIDs}\')"><img src="../scripts/dhcmed/img/cc/reject.png" alt="�ų�" /></a>',
						'</div>',
					'</div>',
				 '</div>',
			 '</div>',
			 '<div class="mas">',
					'<div class="lim">',
						'<div id="divFeedbackList-{SummaryID}">{[this.FormatHTML(values.EpisodeID,values.SummaryID,values.ActDate,values)]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">���ݼ����У����Ժ�...</div>',
						'<div id="divCtlResult-{SummaryID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">���ݼ����У����Ժ�...</div>',
						'<div id="divInf-{SummaryID}"><img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">���ݼ����У����Ժ�...</div>',     
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
						Arg3 : RepType, //Add By LiYang 2013-04-07���ݱ���ɸѡ�������
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
				
				//DistinctEpisodeID=1  ͬһʱ��Σ�ͬһ���������¼�Ƿ�ϲ� 0-���ϲ� ����-�ϲ�
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
					 '<td width="30%" class="SubTotal_td">���ҵ��Ĳ���������</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{total}��</span></td>',
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
		,fieldLabel:'ͬ���������쳣>'
	});
	objScreen.txtDepGerm = new Ext.form.NumberField({
		id : 'txtDepGerm'
		,width : 30
		,value : 1
		,fieldLabel : 'ͬ���Ҽ��΢������>'
	});
	objScreen.txtPeronalGerm = new Ext.form.NumberField({
		id : 'txtPeronalGerm'
		,width : 30
		,value : 1
		,fieldLabel : 'һ�ξ�����΢�������>'
	});
	objScreen.txtDepGermKind = new Ext.form.NumberField({
		id : 'txtDepGermKind'
		,width : 30
		,value : 1
		,fieldLabel : '����ͬ�ֲ�ԭ�巢������>'
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
		,title : "����ָ��"
		//,frame : true
		,autoScroll:true
	});	
	
	objScreen.pnCondition = new Ext.Panel({
		layout : 'border',
		region : 'west',
		//frame : true,
		width : 250,
		title : 'ָ�����',
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
		,title : '��ϸ'
	});
	
	objScreen.pnLocBed = new Ext.Panel({
		id : 'pnLocBed'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,tpl : objScreen.objTplLocBed
		,title : '��λͼ'
	});
	
	objScreen.pnFloorplan = new Ext.Panel({
		id : 'pnFloorplan'
		,autoScroll : true
		//,style : 'overflow-x:hidden; overflow-y:scroll'
		,title : '������λͼ'
	});
	
	objScreen.pnSummary = new Ext.Panel({
		id : 'pnSummary',
		title : 'ժҪ',
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
		title : '��ѯ��������',
		items : [
			new Ext.form.FieldSet({
				title : '��ѯ����',
				layout : 'hbox',
				items : [
					{
						text : '��ѯ����',
						xtype :'label'
					},{
						id : 'dtFromDate',
						fieldLabel : '��ʼ����',
						format : 'Y-m-d',
						//value : new Date().add(Date.DAY, -3).format('Y-m-d'),
						value : new Date().add(Date.DAY, -1).format('Y-m-d'),
						xtype : 'datefield',
						width : 100
					},{
						text : '��',
						xtype :'label'
					},{
						id : 'dtToDate',
						fieldLabel : '��������',
						format : 'Y-m-d',
						value : new Date().add(Date.DAY, -1).format('Y-m-d'),
						xtype : 'datefield',
						width : 100
					},{
						width : 20
					},{
						text : '״̬:',
						xtype :'label'
					},{
						id : 'rdoStatus1',
						boxLabel : 'δ֪ͨ',
						xtype : 'radio',
						name : 'rdoStatus'		,
						checked : true,
						value : 0
					},{
						id : 'rdoStatus2',
						boxLabel : '��֪ͨ',
						xtype : 'radio',
						name : 'rdoStatus'		,
						value : 1
					},{
						id : 'rdoStatus3',
						boxLabel : '���ų�',
						xtype : 'radio',
						name : 'rdoStatus'	,
						value : 9	
					}
				]
			}),
			new Ext.form.FieldSet({
				title : 'Ԥ������',
				layout : 'hbox',
				items : [
					{
						text : 'ͬ���������쳣',
						xtype :'label'
					},
					objScreen.txtTemp,
					{
						text : 'ͬ���Ҽ��΢������',
						xtype :'label'
					},					
					objScreen.txtDepGerm,
					{
						text : 'һ�ξ�����΢�������',
						xtype :'label'
					},					
					objScreen.txtPeronalGerm,
					{
						text : '����ͬ�ֲ�ԭ�巢������',
						xtype :'label'
					},					
					objScreen.txtDepGermKind			
				]
			})
		],
		buttons : [
			{
				id : 'btnQuerySummary',
				text : '��ѯ',
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
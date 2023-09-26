var objScreen = new Object();
objScreen.init = function()
{

	objScreen.objTpl = new Ext.XTemplate(

	'<div>',
        '<div class="SubTotal">',
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					'<td width="30%" class="SubTotal_td">累计提示信息数量：</td>',
					'<td width="50%" class="SubTotal_td"><span class="SubTotal_Number">{length}个</span></td>',
				'</tr>',
			'</table>',				 
		'</div>',
		'<tpl for=".">',
			'<tpl if="xindex === xcount">',
		     '<div class="t-header">',
			     '<div class="t-header-left">',
					'<div class="t-header-text">日期:{FeedBackDate}&nbsp;{FeedBackTime}&nbsp;&nbsp;提示人：{FeedBackUser}',
						'<div class="ButtonGroup">',
							'<a href="#" onclick="return objScreen.viewPatientInfo({[objScreen.CurrentEpisodeID]},0)"><img src="../scripts/dhcmed/img/summary.gif" width="66" height="32" alt="摘要" /></a>',
							'<a href="#" onclick="return objScreen.btnAccept_onclick({FeedbackRowID});"><img src="../scripts/dhcmed/img/accept.gif"width="65" height="32" /></a></a>',
							'<a href="#" onclick="return objScreen.btnReject_onclick({FeedbackRowID})"><img src="../scripts/dhcmed/img/reject.gif" width="65" height="32" alt="排除" /></a></a>',
						'</div>',
					'</div>',
					/*'<ul>',
						'<li><span class="Result_Item_Title"> 日期:</span></strong>{FeedBackDate}</li>',
						'<li><strong><span class="Result_Item_Title"> 时间：</span></strong>{FeedBackTime}<strong></li>',
						'<li><strong><span class="Result_Item_Title"> 提示人：</span></strong>{FeedBackUser}</li>',
						//'<li><strong>此次得分：</strong>{ScoreThisTime}分</li>',
						//'<li><strong>总得分：</strong>{TotalScore}分</li>',
						'<li><a href="#" onclick="return objScreen.viewPatientInfo({[objScreen.CurrentEpisodeID]},0)"><img src="../scripts/dhcmed/img/summary.gif" width="66" height="32" alt="摘要" /></a><//li> ',
						'<li><a href="#" onclick="return objScreen.btnAccept_onclick({FeedbackRowID});"><img src="../scripts/dhcmed/img/accept.gif"width="65" height="32" /></a></li>',
						'<li><a href="#" onclick="return objScreen.btnReject_onclick({FeedbackRowID})"><img src="../scripts/dhcmed/img/reject.gif" width="65" height="32" alt="排除" /></a></li>',
					'</ul>',
					*/					
				 '</div>',
			 '</div>',
			 '</tpl>',
		'</tpl>',
		//'<tpl if="length" >',
			'<div id="divFeedbackList">{[this.RenderFeedBack()]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',			
			'<br/>',
			'<div id="divCtlResult">{[this.FormatHTML()]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',
		//'</tpl>',
		'<br/>',
		'<div id="divInf">{[this.RenderInf()]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>', 
		'<br/>',
		'<div id="divEpd">{[this.RenderEpd()]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">数据加载中，请稍后...</div>',			
		'<br/>',
		{
			FormatHTML : function()
				{
					var objEpisode = ExtTool.RunServerMethod("DHCMed.Base.PatientAdm", "GetObjById", objScreen.CurrentEpisodeID);
					var objPatient = ExtTool.RunServerMethod("DHCMed.Base.Patient", "GetObjById", objEpisode.PatientID);
					
					var strTitle = '<strong>'+objPatient.PatientName + '</strong><strong>' +
						'<span class="Result_Item_Title"> 就诊卡号：</span></strong>' + objPatient.PapmiNo + 
						'<strong><span class="Result_Item_Title"> 性别：</span></strong>' + objPatient.Sex +
						'<strong><span class="Result_Item_Title"> 年龄：</span></strong>' + objPatient.Age +
						'<strong><span class="Result_Item_Title">入院日期：</span></strong>' + objEpisode.AdmitDate + 
						'<strong><span class="Result_Item_Title"> 科室：</span></strong>' + objEpisode.Department +
						'<strong><span class="Result_Item_Title"> 病房：</span></strong>' + objEpisode.Ward + 
						'<strong><span class="Result_Item_Title"> 床位</span></strong>' + objEpisode.Bed;
					objScreen.pnScreen.setTitle(strTitle);
					Ext.Ajax.request({
						url : ExtToolSetting.RunQueryPageURL,
						method : "POST",
						params  : {
							ClassName : 'DHCMed.CCService.Feedback.ResultService',
							QueryName : 'qryCtlResultByEpisodeID',
							Arg1 : objScreen.CurrentEpisodeID,
							Arg2 : objScreen.CurrentSubjectID,
							Arg3 : "",
							Arg4 : 1,
							Arg5 : 0,
							ArgCnt : 5
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
						  objINTCCommon.RenderCtlResult("divCtlResult", arryData);
					   },
					   failure: function(response, opts) {
						  document.getElementById("divCtlResult").innerHTML = response.responseText;
					   }
					});
					
					
				}
				
			,RenderInf : function()
			{
				Ext.Ajax.request({
						url : ExtToolSetting.RunQueryPageURL,
						method : "POST",
						params  : {
							ClassName : 'DHCMed.CCService.Feedback.EpisodeService',
							QueryName : 'QryInfReportByEpisodeID',
							Arg1 : objScreen.CurrentEpisodeID,
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
						  	objINTCCommon.RenderInfReport("divInf", arryData);
					   },
					   failure: function(response, opts) {
						  document.getElementById("divInf").innerHTML = response.responseText;
					   }
					});									
			}
			,RenderEpd : function()
			{
				Ext.Ajax.request({
						url : ExtToolSetting.RunQueryPageURL,
						method : "POST",
						params  : {
							ClassName : 'DHCMed.CCService.Feedback.EpisodeService',
							QueryName : 'QryEpdReportByEpisodeID',
							Arg1 : objScreen.CurrentEpisodeID,
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
						  	objINTCCommon.RenderEpdReport("divEpd", arryData);
					   },
					   failure: function(response, opts) {
						  document.getElementById("divEpd").innerHTML = response.responseText;
					   }
					});						
			}
			,RenderFeedBack : function()
			{

						Ext.Ajax.request({
							url : ExtToolSetting.RunQueryPageURL,
							method : "POST",
							params  : {
								ClassName : 'DHCMed.CCService.Feedback.FeedBackService',
								QueryName : 'QryByEpisodeSubject',
								Arg1 : objScreen.CurrentEpisodeID,
								Arg2 : objScreen.CurrentSubjectID,
								Arg3 : "",
								Arg4 : objScreen.RepType,
								ArgCnt : 4
							},
						   success: function(response, opts) {
							  var objData = Ext.decode(response.responseText);
							  var arryData = new Array();
							  var objItem = null;
							  for(var i = 0; i < objData.total; i ++)
							  {
								objItem = objData.record[i];
								objItem.EpisodeID = objScreen.CurrentEpisodeID; //Add By LiYang 2013-03-24
								arryData[arryData.length] = objItem;
							  }
							  objINTCCommon.RenderFeedback("divFeedbackList", arryData);
						   },
						   failure: function(response, opts) {
							  document.getElementById("divFeedbackList").innerHTML = response.responseText;
						   }
						});											
			}
				
		}	
	);

	objScreen.pnScreen = new Ext.Panel({
		autoScroll : true
		,tpl : objScreen.objTpl
		,title : '该患者此次住院期间的提示信息'
		,tbar : {
			items :[
				{
					id : 'rdoStatus1',
					boxLabel : '未处理',
					xtype : 'radio',
					name : 'rdoStatus',
					checked : true					
				},
				{
					id : 'rdoStatus2',
					boxLabel : '已处理',
					xtype : 'radio',
					name : 'rdoStatus'		
				}
				/*,{
					id : 'btnQuerySummary',
					text : '查询',
					icon  : '../scripts/dhcmed/img/find.gif',
					xtype : 'button' ,
					handler: function(){
						objScreen.btnQrySummary_onclick();
					}
				}*/
			]
		}		
	});

	objScreen.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'fit'
		,items:[
			objScreen.pnScreen
		]
	});	
	
	InitviewScreenEvent(objScreen);
	objScreen.LoadEvent();
}
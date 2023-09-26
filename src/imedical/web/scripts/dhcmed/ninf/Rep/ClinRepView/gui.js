var objScreen = new Object();
objScreen.init = function()
{
	objScreen.FeedBackIDs = '';
	
	var objEpisode = ExtTool.RunServerMethod("DHCMed.Base.PatientAdm", "GetObjById", EpisodeID);
	var objPatient = ExtTool.RunServerMethod("DHCMed.Base.Patient", "GetObjById", objEpisode.PatientID);
	var ctrlItems = ExtTool.RunServerMethod("DHCMed.CCService.Sys.SubjectConfig", "GetCtrlItemsByConfigCode", ViewConfigCode);
	
	//**************************************��Ϣ��ʾ���� Start************************************
	/* update by zf 20130422 */
	objScreen.objTpl = new Ext.XTemplate(
		'<div class="all">',
		'<div class="SubTotal">', 
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					 '<td width="30%" class="SubTotal_td">��Ϣ��ʾ��������</td>',
					 '<td width="50%" class="SubTotal_td"><span class="SubTotal_Number"></span></td>',
					 '<td width="5%" class="SubTotal_td"><a href="#" onclick="return objScreen.viewPatientInfo({[EpisodeID]},0)"><img src="../scripts/dhcmed/img/cc/summary.png" width="66" height="32" alt="ժҪ" /></a></td>',
					 '<td width="5%" class="SubTotal_td"><a href="#" onclick="return objScreen.btnAccept_onclick();"><img src="../scripts/dhcmed/img/cc/receive.png"width="65" height="32" alt="����" /></a></td>',
					 '<td width="5%" class="SubTotal_td"><a href="#" onclick="return objScreen.btnReject_onclick()"><img src="../scripts/dhcmed/img/cc/refuse.png" width="65" height="32" alt="�ܾ�" /></a></td>',
					 '<td width="5%" class="SubTotal_td"></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<div class="mas">',
			'<div>',
				'<div id="divFeedbackList">{[this.RenderFeedBack()]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">���ݼ����У����Ժ�...</div>',
				'<div id="divCtlResult">{[this.FormatHTML()]}<img src="../scripts/dhcmed/img/loading.gif" height="32px" width="32px">���ݼ����У����Ժ�...</div>',
			'</div>', 
		'</div>',
		'</div>',
		{
			FormatHTML : function()
			{
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.ResultService',
						QueryName : 'qryCtlResultByEpisodeID',
						Arg1 : EpisodeID,
						Arg2 : SubjectID,
						Arg3 : "",
						Arg4 : "",
						Arg5 : 0,
						Arg6 : ctrlItems,
						ArgCnt : 6
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
			,RenderFeedBack : function()
			{
				Ext.Ajax.request({
					url : ExtToolSetting.RunQueryPageURL,
					method : "POST",
					params  : {
						ClassName : 'DHCMed.CCService.Feedback.FeedBackService',
						QueryName : 'QryByEpisodeSubject',
						Arg1 : EpisodeID,
						Arg2 : SubjectID,
						Arg3 : "",
						Arg4 : "",
						ArgCnt : 4
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
		autoScroll : false
		,region : 'center'
		,tpl : objScreen.objTpl
		,bodyStyle : 'overflow-x:visible; overflow-y:scroll'
		,frame : true
	});
	//**************************************��Ϣ��ʾ���� End**************************************
	
	//**************************************ҽԺ��Ⱦ���� Start************************************
	objScreen.btnInfReport = new Ext.Button({
		id : 'btnInfReport'
		,iconCls : 'icon-add'
		,width : 80
		,text : 'ҽԺ��Ⱦ����'
	})
	objScreen.btnICUReport = new Ext.Button({
		id : 'btnICUReport'
		,iconCls : 'icon-add'
		,width : 80
		,text : 'ICU����ǼǱ�'
	})
	objScreen.btnNICUReport = new Ext.Button({
		id : 'btnNICUReport'
		,iconCls : 'icon-add'
		,width : 80
		,text : '����������ǼǱ�'
	})
	objScreen.btnOperReport = new Ext.Button({
		id : 'btnOperReport'
		,iconCls : 'icon-add'
		,width : 80
		,text : '�����пڵ����'
	})
	
	objScreen.gridInfReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	objScreen.gridInfReportStore = new Ext.data.Store({
		proxy: objScreen.gridInfReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'ReportID'
		}, 
		[
			{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'TransID', mapping: 'TransID'}
			,{name: 'ReportTypeID', mapping: 'ReportTypeID'}
			,{name: 'ReportTypeDesc', mapping: 'ReportTypeDesc'}
			,{name: 'ReportLocID', mapping: 'ReportLocID'}
			,{name: 'ReportLocDesc', mapping: 'ReportLocDesc'}
			,{name: 'ReportUserID', mapping: 'ReportUserID'}
			,{name: 'ReportUserDesc', mapping: 'ReportUserDesc'}
			,{name: 'ReportDate', mapping: 'ReportDate'}
			,{name: 'ReportTime', mapping: 'ReportTime'}
			,{name: 'ReportStatusID', mapping: 'ReportStatusID'}
			,{name: 'ReportStatusDesc', mapping: 'ReportStatusDesc'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'InfPos', mapping: 'InfPos'}
			,{name: 'InfDate', mapping: 'InfDate'}
			,{name: 'InfDiag', mapping: 'InfDiag'}
			,{name: 'Specimen', mapping: 'Specimen'}
			,{name: 'TestResults', mapping: 'TestResults'}
			,{name: 'LogResume', mapping: 'LogResume'}
		])
	});
	var Age = ExtTool.RunServerMethod("DHCMed.SSIO.FromHisSrv","GetPapmiAge",objEpisode.PatientID,EpisodeID,objEpisode.AdmitDate,objEpisode.AdmitTime);
	objScreen.gridInfReport = new Ext.grid.GridPanel({
		id : 'gridInfReport'
		,store : objScreen.gridInfReportStore
		,columnLines : true
		,loadMask : true
		,frame : true
		,region : 'north'
		,height : 240
		//,title : '�ٴ������ϱ�'
		,columns: [
			{header : 'ID', width : 40, dataIndex : 'ReportID', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����', width : 60, dataIndex : 'PatName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��������', width : 100, dataIndex : 'ReportTypeDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '״̬', width : 60, dataIndex : 'ReportStatusDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var ReportStatus = rd.get("ReportStatusDesc");
					var LogResume = rd.get("LogResume");
					if ((ReportStatus == 'ɾ��')||(ReportStatus == '�˻�')||(LogResume != '')) {
						return '<span style="color:red"><b>' + ReportStatus + '</b></span>';
					} else {
						return ReportStatus;
					}
				}
			}
			,{header : '�������', width : 100, dataIndex : 'ReportLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '������', width : 60, dataIndex : 'ReportUserDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��������', width : 80, dataIndex : 'ReportDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����ʱ��', width : 60, dataIndex : 'ReportTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ⱦ��λ', width : 100, dataIndex : 'InfPos', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ⱦ����', width : 80, dataIndex : 'InfDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ⱦ���', width : 100, dataIndex : 'InfDiag', sortable: false, menuDisabled:true, align:'center', //modified By LiYang 2013-05-18 �������ӵ�����Ⱦ��ֹ���ڵ�¼����桿
				renderer: function(v, m, rd, r, c, s) 
				{
					return "<a href='#' onclick='return window.ShowInfEndDateWindow(" 
					+ rd.get("ReportID") + ")'>" 
					//+ v.replace(/��������/g, '<img src="../scripts/dhcmed/img/update.png" />'
					+ v + "</a>";
				}		
			}
			,{header : '����걾', width : 100, dataIndex : 'Specimen', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��ԭ��', width : 100, dataIndex : 'InfPath', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��ע', width : 200, dataIndex : 'LogResume', sortable: false, menuDisabled:true, align:'left'
				,renderer: function(v, m, rd, r, c, s){
					var LogResume = rd.get("LogResume");
					if (LogResume != '') {
						return '<span style="color:red"><b>' + LogResume + '</b></span>';
					} else {
						return LogResume;
					}
				}
			}
		]
		,viewConfig : {
			//forceFit : true
		}
		
		,bbar : ['-',objScreen.btnInfReport,objScreen.btnOperReport,objScreen.btnICUReport,objScreen.btnNICUReport,'-']
		,tbar : ['-'
			,'��������:',objPatient.PatientName,'-'
			,'�ǼǺ�:',objPatient.PapmiNo,'-'
			,'�Ա�:',objPatient.Sex,'-'
			,'����:',Age,'-'
			,'��Ժ����:',objEpisode.AdmitDate,'-'
			,'����:',objEpisode.Department,'-'
			,'����:',objEpisode.Ward,'-'
			,'��λ:',objEpisode.Bed,'-'
		]
    });
	
	objScreen.gridInfReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.InfReport';
		param.QueryName = 'QryReportByAdm';
		param.Arg1 = EpisodeID;
		param.Arg2 = "";
		param.ArgCnt = 2;
	});
	//**************************************ҽԺ��Ⱦ���� End**************************************
	
	objScreen.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,frame : true
		,items:[
			objScreen.pnScreen
			,objScreen.gridInfReport
		]
	});	
	
	InitviewScreenEvent(objScreen);
	objScreen.LoadEvent();
}
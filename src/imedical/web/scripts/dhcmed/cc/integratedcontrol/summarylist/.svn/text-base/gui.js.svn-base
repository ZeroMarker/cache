function InitwinSummaryList(EpisodeID, SubjectID){
	var obj = new Object();
	obj.CurrentEpisodeID = EpisodeID;
	obj.CurrentSubjectID = SubjectID;
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridSummaryStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridSummaryStore = new Ext.data.Store({
		proxy: obj.gridSummaryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
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
			,{name: 'ItemSubTotal', mapping: 'ItemSubTotal'}
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
			,{name: 'KeywordList', mapping: 'KeywordList'}
			,{name: 'SensitiveAmount', mapping: 'SensitiveAmount'}
			,{name: 'SpecificityAmount', mapping: 'SpecificityAmount'}
			,{name: 'SummaryID', mapping: 'SummaryID'}
			,{name: 'FireItemCount', mapping: 'FireItemCount'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'Days', mapping: 'Days'}
			,{name: 'IsEva', mapping: 'IsEva'}
			,{name: 'FeedbackRowID', mapping: 'FeedbackRowID'}
			,{name: 'FeedBackCnt', mapping: 'FeedBackCnt'}
			,{name: 'AcceptFeedbackCnt', mapping: 'AcceptFeedbackCnt'}
			,{name: 'RejectFeedbackCnt', mapping: 'RejectFeedbackCnt'}
			,{name: 'NoResponseFeedbackCnt', mapping: 'NoResponseFeedbackCnt'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'INFInfo', mapping: 'INFInfo'}
			,{name: 'RowID', mapping: 'RowID'}
		])
	});
	obj.gridSummaryCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridSummary = new Ext.grid.GridPanel({
		id : 'gridSummary'
		,store : obj.gridSummaryStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '目标科室', width: 100, dataIndex: 'ToDepartmentDesc', sortable: true}
			,{header: '目标<BR/>医师', width: 70, dataIndex: 'ToUserDesc', sortable: true}			
			,{header: '反馈<BR/>医师', width: 70, dataIndex: 'FeedBackUser', sortable: true}
			,{header: '反馈日期', width: 90, dataIndex: 'FeedBackDate', sortable: true}
			,{header: '反馈时间', width: 90, dataIndex: 'FeedBackTime', sortable: true}			
			,{header: '此次<BR/>得分', width: 50, dataIndex: 'ScoreThisTime', sortable: true}			
			,{header: '总分', width: 50, dataIndex: 'TotalScore', sortable: true}	
			,{header: '状态', width: 50, dataIndex: 'Status', sortable: true, 
				renderer : function(v)
				{
					var ret = "";
					switch(v)
					{
						case 1:
							ret = "<span style='color:blue;'>已接受</span>";
							break;
						case 2:
							ret = "<span style='color:green;'>已接受</span>";
							break;		
						default:
							ret = "<span style='color:red;'>未响应</span>";
							break;							
					}
					return ret;
				}
			}
			,{header: '敏感项<BR/>目数量', width: 50, dataIndex: 'SensitiveAmount', sortable: true}
			,{header: '特异性<BR/>项目数量', width: 50, dataIndex: 'SpecificityAmount', sortable: true}
			,{header: '触发项<BR/>目数量', width: 50, dataIndex: 'FireItemCount', sortable: true}			
			,{header: '反馈<BR/>间隔<BR/>天数', width: 50, dataIndex: 'Days', sortable: true}
			,{header: '是否<BR/>评价', width: 50, dataIndex: 'IsEva', sortable: true, 
				renderer : function(v)
				{
					var ret = "<span>" + (v > 0 ? "已评价" : "未评价") + "</span>";
					return ret;
				}
			}
			//,{header: '反馈<BR/>次数', width: 50, dataIndex: 'FeedBackCnt', sortable: true}
/*
			

			,{header: '提示医师信息', width: 100, dataIndex: 'FeedBackNote', sortable: true}

			,{header: '反馈具体描述', width: 100, dataIndex: 'ReceiveNote', sortable: true}
			,{header: '接受反馈的医师', width: 100, dataIndex: 'ReceiveUser', sortable: true}
			,{header: '接受反馈的日期', width: 100, dataIndex: 'ReceiveDate', sortable: true}
			,{header: '接受反馈日期', width: 100, dataIndex: 'ReceiveTime', sortable: true}
			,{header: '医师是否接受', width: 100, dataIndex: 'ReceiveResult', sortable: true}
			,{header: '监控是否正确', width: 100, dataIndex: 'ControlCorrect', sortable: true}
			,{header: '监控错误的原因', width: 100, dataIndex: 'ControlInCorrectReason', sortable: true}
			,{header: '报告及时性', width: 100, dataIndex: 'ReportOnTime', sortable: true}
			,{header: '内容汇总', width: 100, dataIndex: 'ItemSubTotal', sortable: true}


			,{header: '类别划分', width: 100, dataIndex: 'KeywordList', sortable: true}
*/


		]});
	obj.btnClose = new Ext.Button({
		iconCls : 'icon-exit',
		text : '关闭'
});
	obj.winSummaryList = new Ext.Window({
		height : 400
		,buttonAlign : 'center'
		,width : 800
		,title : '反馈信息'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.gridSummary
		]
	,	buttons:[
			obj.btnClose
		]
	});
	obj.gridSummaryStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Feedback.FeedBackService';
			param.QueryName = 'QryByEpisodeSubject';
			param.Arg1 = obj.CurrentEpisodeID;
			param.Arg2 = obj.CurrentSubjectID;
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.gridSummaryStore.load({});
	InitwinSummaryListEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}


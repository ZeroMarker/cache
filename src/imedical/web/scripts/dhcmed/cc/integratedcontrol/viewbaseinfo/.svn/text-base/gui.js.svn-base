function InitViewBaseInfo(){
	var obj = new Object();
	obj.CurrentEpisodeID = "0";
	obj.CurrentSubjectID = "0";
	obj.CurrentSummaryID = "0";
	obj.OrderTypeList = "";
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete', function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.gridCtlResultStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridCtlResultStore = new Ext.data.GroupingStore({
		proxy: obj.gridCtlResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CtlResultID',
			sortInfo:{field: 'KeyWord', direction: "ASC"},
			groupOnSort: true,
			//remoteGroup: true,
            groupField:'KeyWord'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'CtlResultID', mapping: 'CtlResultID'}
			,{name: 'RecDate', mapping: 'RecDate'}
			,{name: 'ActDate', mapping: 'ActDate'}
			,{name: 'ActTime', mapping: 'ActTime'}
			,{name: 'KeyWord', mapping: 'KeyWord'}
			,{name: 'ItemId', mapping: 'ItemId'}
			,{name: 'Summary', mapping: 'Summary'}
			,{name: 'DataValue', mapping: 'DataValue'}
			,{name: 'ObjectID', mapping: 'ObjectID'}
			,{name: 'UserID', mapping: 'UserID'}
			,{name: 'UserName', mapping: 'UserName'}
			,{name: 'SubjectID', mapping: 'SubjectID'}
			,{name: 'Score', mapping: 'Score'}
			,{name: 'IsAbsolute', mapping: 'IsAbsolute'}
			,{name: 'IsSensitive', mapping: 'IsSensitive'}
			,{name: 'IsSpecificity', mapping: 'IsSpecificity'}
		])
	});
	
	obj.gridCtlResult = new Ext.grid.GridPanel({
		id : 'gridCtlResult'
		,title : '监控结果'
		,store : obj.gridCtlResultStore
		,loadMask : { msg : '正在读取数据,请稍后...'}
		,buttonAlign : 'center'
		,view: new Ext.grid.GroupingView({
	        showGroupName: false,
            enableNoGroups: false,
			//enableGroupingMenu: false,	
           groupTextTpl: '{text}:{[values.rs.length]}条记录',
		   forceFit : true
		})		
		
		,columns: [
			{id:'CtlResultID',header: '项目', width: 100, dataIndex: 'KeyWord', sortable: true, groupable : true, groupName:"KeyWord",
				summaryRenderer: function(v, params, data){
                    return ((v === 0 || v > 1) ? '(' + v +' Tasks)' : '(1 Task)');
                }}
			//,{ header: '记录日期', width: 80, dataIndex: 'RecDate', sortable: true, groupable : true}
			,{header: '日期', width: 80, dataIndex: 'ActDate', sortable: true, groupable : true}
			,{header: '时间', width: 80, dataIndex: 'ActTime', sortable: true, groupable : false}
			,{header: '摘要信息', width: 400, dataIndex: 'Summary', groupable : false}
			//,{header: '分数', width: 60, dataIndex: 'Score', sortable: true, groupable : false}
			/*,{header: '绝对项目', width: 60, dataIndex: 'IsAbsolute', sortable: true, groupable : true, 
				renderer : function(v)
				{
					var strRet = "";
					if(v != 0)
						strRet = "<img src='../scripts/dhcmed/img/accept.png' width='16px' height='16px' alt='绝对项目'/>";
					return strRet;
				}
			}
			,{header: '敏感项目', width: 60, dataIndex: 'IsSensitive', sortable: true, groupable : true,
				renderer : function(v)
				{
					var strRet = "";
					if(v != 0)
						strRet = "<img src='../scripts/dhcmed/img/accept.png' width='16px' height='16px' alt='敏感项目'/>";
					return strRet;
				}
			}
			,{header: '特异项目', width: 60, dataIndex: 'IsSpecificity', sortable: true, groupable : true,
				renderer : function(v)
				{
					var strRet = "";
					if(v != 0)
						strRet = "<img src='../scripts/dhcmed/img/accept.png' width='16px' height='16px' alt='特异项目'/>";
					return strRet;
				}}*/
		],
        iconCls: 'icon-grid'
		,viewConfig : {forceFit : true}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridCtlResultStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,tbar : {
			items :[
				{
					text : '记录日期查询',
					xtype :'label'
				},
				{
					id : 'dtCtlResultFromDate',
					fieldLabel : '开始日期',
					format : 'Y-m-d',
					value : new Date(),
					xtype : 'datefield'
				},
				{
					text : '至',
					xtype :'label'
				},				
				{
					id : 'dtCtlResultToDate',
					fieldLabel : '结束日期',
					format : 'Y-m-d',
					value : new Date(),
					xtype : 'datefield'				
				},
				{
					id : 'btnQueryCtlResult',
					text : '查询',
					icon  : '../scripts/dhcmed/img/find.gif',
					xtype : 'button' ,
					handler: function(){
						var objStore = obj.gridCtlResultStore;
						objStore.removeAll();
						objStore.load({});
					}
				}
			]
		}
		});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridDiagnoseStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridDiagnoseStore = new Ext.data.Store({
		proxy: obj.gridDiagnoseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ARowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ARowID', mapping: 'ARowID'}
			,{name: 'AMRADMRowId', mapping: 'AMRADMRowId'}
			,{name: 'ADiaSubID', mapping: 'ADiaSubID'}
			,{name: 'ADiagnosTypeID', mapping: 'ADiagnosTypeID'}
			,{name: 'ADiagnosType', mapping: 'ADiagnosType'}
			,{name: 'AICDID', mapping: 'AICDID'}
			,{name: 'AICDCode', mapping: 'AICDCode'}
			,{name: 'ADiagnosName', mapping: 'ADiagnosName'}
			,{name: 'ADemo', mapping: 'ADemo'}
			,{name: 'AEvaluation', mapping: 'AEvaluation'}
			,{name: 'AEvaluationDesc', mapping: 'AEvaluationDesc'}
			,{name: 'AEffects', mapping: 'AEffects'}
			,{name: 'AEffectsDesc', mapping: 'AEffectsDesc'}
			,{name: 'ALevel', mapping: 'ALevel'}
			,{name: 'ASquence', mapping: 'ASquence'}
			,{name: 'AUserName', mapping: 'AUserName'}
			,{name: 'ADateTime', mapping: 'ADateTime'}
		])
	});
	obj.gridDiagnoseCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridDiagnose = new Ext.grid.GridPanel({
		id : 'gridDiagnose'
		,store : obj.gridDiagnoseStore
		,buttonAlign : 'center'
		,title : '诊断信息'
		,region : 'center'
		,loadMask : { msg : '正在读取数据,请稍后...'}
		,viewConfig : {forceFit : true}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '诊断类型', width: 100, dataIndex: 'ADiagnosType', sortable: true}
			,{header: 'ICD', width: 100, dataIndex: 'AICDCode', sortable: true}
			,{header: '诊断名称', width: 200, dataIndex: 'ADiagnosName', sortable: true}
			,{header: '状态', width: 100, dataIndex: 'AEvaluationDesc', sortable: true}
			,{header: 'ICD转归', width: 100, dataIndex: 'AEffectsDesc', sortable: true}
			,{header: '级别', width: 100, dataIndex: 'ALevel', sortable: true}
			,{header: '顺序', width: 100, dataIndex: 'ASquence', sortable: true}
			,{header: '医师', width: 100, dataIndex: 'AUserName', sortable: true}
			,{header: '诊断时间', width: 100, dataIndex: 'ADateTime', sortable: true}
		]});
	
	var arrItem = new Array();
	var objCommonSrv = ExtTool.StaticServerObject("DHCMed.CCService.Feedback.ResultService");
	var strDicList = objCommonSrv.GetLabItemCat("L",session['LOGON.USERID']);
	var dicList = strDicList.split(String.fromCharCode(1));

	for (var dicIndex = 0; dicIndex < dicList.length; dicIndex++) {
		var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
		var chkItem = {
			boxLabel : dicSubList[1],
			name : dicSubList[0],
			checked : (dicSubList[2]==1),
			listeners : {'check' : function(){ 
   				obj.dicList_checked();
				} 
    		}
		}
		arrItem.push(chkItem);
	}

	obj.cbgLabOrderType = new Ext.form.CheckboxGroup({
		id : 'cbgLabOrderType',
		xtype : 'checkboxgroup',
		fieldLabel : '医嘱类型',
		columns : 8,
		items : arrItem
	});
	obj.LabOrderTypePanel = new Ext.Panel({
		id : 'LabOrderTypePanel'
		//,title : '基本信息'
		,region:'north'
		,layout : 'column'
		,height:60
		,items:[
			obj.cbgLabOrderType
		]
	});
	obj.gridLabStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridLabStore = new Ext.data.Store({
		proxy: obj.gridLabStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrderID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrderID', mapping: 'OrderID'}
			,{name: 'OrderName', mapping: 'OrderName'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'OrderStatus', mapping: 'OrderStatus'}
			,{name: 'LabTestNo', mapping: 'LabTestNo'}
			,{name: 'LabEpisodeNo', mapping: 'LabEpisodeNo'}
			,{name: 'SpecimenDesc', mapping: 'SpecimenDesc'}
			,{name: 'StartDateTime', mapping: 'StartDateTime'}
			,{name: 'DocDesc', mapping: 'DocDesc'}
		]),
		sortInfo : {field : 'LabEpisodeNo',direction : 'ASC'}
	});
	obj.gridLabCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridLab = new Ext.grid.GridPanel({
		store : obj.gridLabStore
		,title : '检验报告'
		,region : 'center'
		,viewConfig : {forceFit : true}
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '医嘱ID', width: 100, dataIndex: 'OrderID', sortable: true}
			//,{header: '报告ID', width: 100, dataIndex: 'LabTestNo', sortable: true}
			,{header: '辅助检查名称', width: 250, dataIndex: 'OrderName', sortable: true}
			,{header: '医嘱日期', width: 120, dataIndex: 'StartDate', sortable: true}
			,{header: '报告日期', width: 120, dataIndex: 'StartDateTime', sortable: true}
			,{header: '状态', width: 80, dataIndex: 'OrderStatus', sortable: true}
			,{header: '开医嘱医生', width: 120, dataIndex: 'DocDesc', sortable: true}
			,{header: '检验号', width: 100, dataIndex: 'LabEpisodeNo', sortable: true}
			,{header: '送检标本', width: 100, dataIndex: 'SpecimenDesc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridLabStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});
	
	obj.gridLabStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.Feedback.EpisodeService';
		param.QueryName = 'QueryLab';
		param.Arg1 = obj.CurrentEpisodeID;
		param.Arg2 = obj.OrderTypeList;
		param.Arg3 = session['LOGON.USERID'];
		param.ArgCnt = 3;
	});			
	
	obj.LabPanel = new Ext.form.FormPanel({
			id : 'LabPanel'
			,title : '检验报告'
			,layout : 'border'
			,frame : true
			,items:[
				obj.LabOrderTypePanel
				,obj.gridLab
			]
		});
	
	/* update by zf 用电子病历中的医嘱单
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridOrderStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridOrderStore = new Ext.data.Store({
		proxy: obj.gridOrderStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrderItemID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrderItemID', mapping: 'OrderItemID'}
			,{name: 'ArcimID', mapping: 'ArcimID'}
			,{name: 'OrderType', mapping: 'OrderType'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'Number', mapping: 'Number'}
			,{name: 'Unit', mapping: 'Unit'}
			,{name: 'OrderStatus', mapping: 'OrderStatus'}
			,{name: 'ExecDate', mapping: 'ExecDate'}
			,{name: 'ExecTime', mapping: 'ExecTime'}
		])
	});
	
	obj.gridOrderCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridOrder = new Ext.grid.GridPanel({
		id : 'gridOrder'
		,store : obj.gridOrderStore
		,buttonAlign : 'center'
		,title : '医嘱信息'
		,loadMask : { msg : '正在读取数据,请稍后...'}
		,viewConfig : {forceFit : true}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '医嘱类别', width: 80, dataIndex: 'OrderType', sortable: true}
			,{header: '医嘱名称', width: 250, dataIndex: 'ArcimDesc', sortable: true}
			,{header: '数量', width: 50, dataIndex: 'Number', sortable: true}
			,{header: '单位', width: 70, dataIndex: 'Unit', sortable: true}
			,{header: '状态', width: 50, dataIndex: 'OrderStatus', sortable: true}
			,{header: '执行日期', width: 90, dataIndex: 'ExecDate', sortable: true}
			//,{header: '执行时间', width: 90, dataIndex: 'ExecTime', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridOrderStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,tbar : {
			items :[
				{
					text : '医嘱日期查询',
					xtype :'label'
				},
				{
					id : 'dtOrderFromDate',
					fieldLabel : '开始日期',
					format : 'Y-m-d',
					value : new Date(),
					xtype : 'datefield'
				},
				{
					text : '至',
					xtype :'label'
				},				
				{
					id : 'dtOrderToDate',
					fieldLabel : '结束日期',
					format : 'Y-m-d',
					value : new Date(),
					xtype : 'datefield'				
				},
				{
					id : 'btnQueryOrder',
					text : '查询',
					icon  : '../scripts/dhcmed/img/find.gif',
					xtype : 'button' ,
					handler: function(){
						var objStore = obj.gridOrderStore;
						objStore.removeAll();
						objStore.load({});
					}
				}
			]
		}	
	});
	*/
	
	obj.pnTimeLine = new Ext.Panel({
		id : 'pnTimeLine'
		,buttonAlign : 'center'
		,title : '感染集成视图'
		,html : '<iframe id="frmTimeLine" height="100%" width="100%" src="#" />' 
	});
	
	obj.objMsgTpl = new Ext.XTemplate(
		'<div class="SubTotal">', 
			'<table width="100%">',
				'<tr>',
					 '<td width="160" class="SubTotal_td"><img src="../scripts/dhcmed/img/cc/08.png" width="98" height="31" /></td>',
					 '<td width="20%" class="SubTotal_td">交互信息量：{length}条</td>',
					 '<td width="80%" class="SubTotal_td"></td>',
				'</tr>',
			'</table>',
		'</div>',
		'<tpl for=".">',
			'<div class="{[this.GetClass(values.SendUser,\"main\")]}">',
				'<b class="{[this.GetClass(values.SendUser,\"b1\")]}"></b>',
				'<b class="{[this.GetClass(values.SendUser,\"b2\")]}"></b>',
				'<b class="{[this.GetClass(values.SendUser,\"b3\")]}"></b>',
				'<b class="{[this.GetClass(values.SendUser,\"b4\")]}"></b>',
				'<div class="{[this.GetClass(values.SendUser,\"content\")]}">',
					'<p><b>{SendUser}</b>&nbsp;&nbsp;{SendDate}&nbsp;&nbsp;{SendTime}</p>',
					'<p>{Message}</p>',
				'</div>',
				'<b class="{[this.GetClass(values.SendUser,\"b5\")]}"></b>',
				'<b class="{[this.GetClass(values.SendUser,\"b6\")]}"></b>',
				'<b class="{[this.GetClass(values.SendUser,\"b7\")]}"></b>',
				'<b class="{[this.GetClass(values.SendUser,\"b8\")]}"></b>',
			'</div>',
		'</tpl>',
		{
			LastSendUser : "",
			Flag : false,
			GetClass : function(UserName, ClassName){
				if(UserName != this.LastSendUser){
					this.Flag = ! this.Flag;
					this.LastSendUser = UserName;
				}
				if(this.Flag){
					return ClassName;
				}else{
					return ClassName + "_1";
				}
			}
		}
	);	

		

	obj.txtMsg = new Ext.form.TextArea({
			height : 50
			,width : 600
			,fieldLabel : '消息内容'
	});		
	
	obj.cboMsgDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboMsgDicStore = new Ext.data.Store({
		proxy: obj.cboMsgDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ColorNumber'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	
	obj.cboMsgDic = new Ext.form.ComboBox({
		id : 'cboMsgDic'
		,width : 18
		,store : obj.cboMsgDicStore
		,minChars : 1
		,displayField : 'Description'
		,valueField : 'Code'
		,editable : false
		,triggerAction : 'all'
		,hideParent : true
		,listWidth : 350
	});

	obj.pnMsgPanel = new Ext.Panel({
		autoScroll : true
		,tpl : obj.objMsgTpl
		,title : "<font color='#FF0000'>交互信息</font>"
		,forceLayout : true
		,bbar : {
			items : [
				{
					text : '待发送的信息',
					xtype : 'label'
				},
				obj.txtMsg,
				obj.cboMsgDic,
				{
					text : '发送',
					icon : '../scripts/dhcmed/img/save.gif',
					xtype : 'button',
					handler : function()
					{
						obj.btnSendMsg_click.call(obj);
					}
					
				}
			]
		}
	});			
	
	obj.pnEpr = new Ext.Panel({
		title : '电子病历浏览',
		html : '<iframe id="ifEpr" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnOrder = new Ext.Panel({
		title : '医嘱单',
		html : '<iframe id="ifOrder" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnRis= new Ext.Panel({
		title : '检查报告',
		html : '<iframe id="ifRis" width="100%" height="100%" src="#"/>'
	});
	
	obj.tabDetail = new Ext.TabPanel({
		id : 'tabDetail'
		//,collapsible : true
	//,collapsed : true
		,activeTab : 0
		,title : '详细信息'
		,region : 'south'
		,frame : true
		,items:[
			obj.pnTimeLine
			,obj.gridCtlResult
			//,obj.gridDiagnose
			,obj.pnEpr
			,obj.LabPanel
			,obj.pnRis
			//,obj.gridOrder
			,obj.pnOrder
			,obj.pnMsgPanel
		]
	});

	obj.viewPatientWin = new Ext.Window({
		id : 'viewPatientWin'
		,width : 800
		,height : 500
		,layout : 'fit'
		,modal : true
		,maximized : true
		,title : '感染监测-摘要信息'
		,items:[
			obj.tabDetail
		],
		buttons : [
			{
				iconCls : 'icon-exit',
				text : '关闭',
				handler : function()
				{
					obj.viewPatientWin.close();
				}
			}
		
		]
	});
	obj.gridCtlResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Feedback.ResultService';
			param.QueryName = 'qryCtlResult';
			param.Arg1 = Ext.getCmp("dtCtlResultFromDate").getRawValue();
			param.Arg2 = Ext.getCmp("dtCtlResultToDate").getRawValue();
			param.Arg3 = obj.CurrentEpisodeID;
			//param.Arg4 = obj.CurrentSubjectID;
			param.Arg4 =SubjectID;
			param.ArgCnt = 4;
	});
	obj.gridDiagnoseStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Feedback.EpisodeService';
			param.QueryName = 'GetMRDiagnosList';
			param.Arg1 = obj.CurrentEpisodeID;
			param.ArgCnt = 1;
	});
	/*
	obj.gridOrderStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Feedback.EpisodeService';
			param.QueryName = 'QueryOrderItemByDate';
			param.Arg1 = obj.CurrentEpisodeID;
			param.Arg2 = Ext.getCmp("dtOrderFromDate").getRawValue();
			param.Arg3 = Ext.getCmp("dtOrderToDate").getRawValue();
			param.ArgCnt = 3;
	});
	*/
	
	obj.cboMsgDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'NoticeMessage';
			param.ArgCnt = 1;
	});
	obj.cboMsgDicStore.load({});
	
	InitViewBaseInfoEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}


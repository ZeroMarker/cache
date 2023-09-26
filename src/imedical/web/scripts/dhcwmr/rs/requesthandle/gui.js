var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	obj.WFIConfig = new Object();
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","申请日期");
	obj.dfDateTo= Common_DateFieldToDate("dfDateTo","至");
	obj.cboStatus = new Ext.form.ComboBox({
		id : 'cboStatus'
		,name :'cboStatus'
		,fieldLabel : '状态'
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'R'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:[
			        'svalue',
			        'stext'
			],
			data:[["R","申请"],["A","响应"],["U","作废"]]
		})
	});
	obj.cboWFItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboWFItemStore = new Ext.data.Store({
		proxy: obj.cboWFItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'WFItemID'
		}, 
		[
			{name: 'WFItemID', mapping: 'WFItemID'}
			,{name: 'WFItemDesc', mapping: 'WFItemDesc'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemType', mapping: 'ItemType'}
			,{name: 'SubFlow', mapping: 'SubFlow'}
			,{name: 'PostStep', mapping: 'PostStep'}
			,{name: 'SysOpera', mapping: 'SysOpera'}
			,{name: 'CheckUser', mapping: 'CheckUser'}
			,{name: 'BeRequest', mapping: 'BeRequest'}
			,{name: 'BatchOper', mapping: 'BatchOper'}
			,{name: 'MRCategory', mapping: 'MRCategory'}
		])
	});
	obj.cboWFItem = new Ext.form.ComboBox({
		id : 'cboWFItem'
		,fieldLabel : '操作项目'
		,store : obj.cboWFItemStore
		,editable : false
		,selectOnFocus : true
		,forceSelection : true
		,mode : 'local'
		,triggerAction : 'all'
		,minListWidth:100
		,valueField : 'WFItemID'
		,displayField : 'WFItemDesc'
		,loadingText: '加载中,请稍候...'
		,anchor : '100%'
	});

	//科室组
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocGroupStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocGroupStore = new Ext.data.Store({
		proxy: obj.cboLocGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'GroupID'
		},[
			{name: 'GroupID', mapping : 'GroupID'}
			,{name: 'GroupCode', mapping: 'GroupCode'}
			,{name: 'GroupDesc', mapping: 'GroupDesc'}
		])
	});
	obj.cboLocGroup = new Ext.form.ComboBox({
		id : 'cboLocGroup'
		,fieldLabel : '科室组'
		,store : obj.cboLocGroupStore
		,minChars : 1
		,valueField : 'GroupID'
		,displayField : 'GroupDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	
	//科室
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		},[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,fieldLabel : '科室'
		,store : obj.cboLocStore
		,minChars : 1
		,valueField : 'LocID'
		,displayField : 'LocDesc'
		,editable : true
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "病案号"
		,emptyText : '病案号/条码号'
		,regex : /^[A-Za-z0-9]+$/
		,anchor : '100%'
	});

	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '查询'
	});

	obj.btnSetThree = new Ext.Button({
		id : 'btnSetThree'
		,iconCls : 'icon-update'
		,width : 80
		,anchor : '100%'
		,text : '三分钟刷新'
	});

	obj.btnSetFive = new Ext.Button({
		id : 'btnSetFive'
		,iconCls : 'icon-update'
		,width : 80
		,anchor : '100%'
		,text : '五分钟刷新'
	});

	obj.btnPrinf = new Ext.Button({
		id : 'btnPrinf'
		,iconCls : 'icon-print'
		,width : 80
		,anchor : '100%'
		,text : '打印清单'
	});

	obj.ConsultListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ConsultListStore = new Ext.data.Store({
		proxy: obj.ConsultListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RquestID'
		},[
			{name: 'RquestID', mapping : 'RquestID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'VolumeID', mapping: 'VolumeID'}
			,{name: 'VolumeStatusDr', mapping: 'VolumeStatusDr'}
			,{name: 'VolumeStatus', mapping: 'VolumeStatus'}
			,{name: 'ReqLoc', mapping: 'ReqLoc'}
			,{name: 'ReqLocDesc', mapping: 'ReqLocDesc'}
			,{name: 'ReqUser', mapping: 'ReqUser'}
			,{name: 'ReqUserDesc', mapping: 'ReqUserDesc'}
			,{name: 'ReqStatus', mapping: 'ReqStatus'}
			,{name: 'ReqStatusDesc', mapping: 'ReqStatusDesc'}
			,{name: 'ReqDate', mapping: 'ReqDate'}
			,{name: 'ReqTime', mapping: 'ReqTime'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
			,{name: 'UpdateUser', mapping: 'UpdateUser'}
			,{name: 'UpdateUserDesc', mapping: 'UpdateUserDesc'}
			,{name: 'Marker', mapping: 'Marker'}
			,{name: 'ReqTypeDesc', mapping: 'ReqTypeDesc'}
			,{name: 'MrNo', mapping: 'MrNo'}
		])
	});
	obj.ConsultList = new Ext.grid.GridPanel({
		id : 'ConsultList'
		,store : obj.ConsultListStore
		,columnLines : true
		,region : 'center'
		,layout: 'fit'
		,loadMask : true
		,buttonAlign:'center'
		,tbar : [
			{id:'msgConsultLis',text:'病案调阅申请列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->','-','病案号：',obj.txtMrNo,'-',obj.btnQuery,'-',obj.btnPrinf,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '病人姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 80, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 70, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病历号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病历状态', width: 70, dataIndex: 'VolumeStatus', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请人', width: 70, dataIndex: 'ReqUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请科室', width: 70, dataIndex: 'ReqLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请类型', width: 70, dataIndex: 'ReqTypeDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请时间', width: 70, dataIndex: 'ReqTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '标记', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var Marker  = rd.get("Marker");
					
					if (Marker)
					{
						return "";
					}else{
						return "<a href='#' onclick='objScreen.marking(\"" + r + "\");'><b>标记</b></a>";
					}
				}
			}
			,{header: '出库', width: 80 , align : 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID  = rd.get("VolumeID");
					var ReqStatus= rd.get("ReqStatus");
				
					if (ReqStatus=='R')
						return "<a href='#' onclick='objScreen.operation(\"" + r + "\");'><b>出库</b></a>";
					else return"";
				}
			}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.ConsultListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
    });

	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north'
				,height : 40
				,layout : 'column'
				,frame : true
				,items : [
					{	
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,columnWidth : .15
						,items: [obj.cboHospital]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .15
						,items: [obj.cboMrType]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .15
						,items: [obj.dfDateFrom]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 35
						,columnWidth : .12
						,items: [obj.dfDateTo]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,columnWidth : .11
						,items: [obj.cboStatus]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,columnWidth : .15
						,items: [obj.cboLocGroup]
					},{
						layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,columnWidth : .15
						,items: [obj.cboLoc]
					}
				]
			}
			,obj.ConsultList
		]
	});

	obj.ConsultListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.RsRquestSrv';
			param.QueryName = 'QryRsRquest';
			param.Arg1 = Common_GetValue('dfDateFrom');
			param.Arg2 = Common_GetValue('dfDateTo');
			param.Arg3 = Common_GetValue('cboStatus');
			param.Arg4 = "";
			param.Arg5 = "";
			param.Arg6 = Common_GetValue('cboLocGroup');
			param.Arg7 = Common_GetValue('cboLoc');
			param.Arg8 = Common_GetValue('txtMrNo');
			param.ArgCnt = 8;
	});
	
	obj.cboLocGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocGroup';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = obj.cboLocGroup.getRawValue();
		param.ArgCnt = 2;
	});
	
	obj.cboWFItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.WorkFlowSrv"
		param.QueryName = "QryWFItemList"
		param.Arg1 = Common_GetValue('cboMrType');
		param.Arg2 = obj.GetOperaList();
		param.ArgCnt = 2
	});

	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LocGroupSrv';
		param.QueryName = 'QryCboLocList';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = Common_GetValue('cboLocGroup');
		param.Arg3 = obj.cboLoc.getRawValue();
		param.ArgCnt = 3;
	});

	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}
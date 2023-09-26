
function InitSpeStatistic(){
	var obj = new Object();
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"SPE");
	obj.cboLoc = Common_ComboToLoc("cboLoc","就诊科室","E","","","cboSSHosp");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	
	obj.cboPatTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPatTypeStore = new Ext.data.Store({
		proxy: obj.cboPatTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTID'
		}, 
		[
			{name: 'PTID', mapping: 'PTID'}
			,{name: 'PTCode', mapping: 'PTCode'}
			,{name: 'PTDesc', mapping: 'PTDesc'}
			,{name: 'IsActive', mapping: 'PTIsActiveDesc'}
			,{name: 'ResumeText', mapping: 'PTResume'}
		])
		
	});
	obj.cboPatType = new Ext.form.ComboBox({
		id : 'cboPatType'
		,width : 50
		,store : obj.cboPatTypeStore
		,minChars : 0
		,valueField : 'PTID'
		,displayField : 'PTDesc'
		,fieldLabel : '特殊患者大类'
		,emptyText: '请选择'   	
		,editable : true   //修复bug 153620 允许编辑，解决无法清空选项不能查询全部问题
		,triggerAction : 'all'
		,anchor : '99%'
	});
	
	
	obj.cboPatTypeSubStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboPatTypeSubStore = new Ext.data.Store({
		proxy: obj.cboPatTypeSubStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTSID'
		}, 
		[
			{name: 'PTSID', mapping: 'PTSID'}
			,{name: 'PTSCode', mapping: 'PTSCode'}
			,{name: 'PTSDesc', mapping: 'PTSDesc'}
			,{name: 'IsActive', mapping: 'PTSIsActiveDesc'}
			,{name: 'PTSIcon', mapping: 'PTSIcon'}
			,{name: 'PTSAutoMarkDesc', mapping: 'PTSAutoMarkDesc'}
			,{name: 'PTSAutoCheckDesc', mapping: 'PTSAutoCheckDesc'}
			,{name: 'PTSAutoCloseDesc', mapping: 'PTSAutoCloseDesc'}
			,{name: 'ResumeText', mapping: 'PTSResume'}
		])
	});
	obj.cboPatTypeSub = new Ext.form.ComboBox({
		id : 'cboPatTypeSub'
		,width : 100
		,store : obj.cboPatTypeSubStore
		,minChars : 0
		,valueField : 'PTSID'
		,displayField : 'PTSDesc'
		,fieldLabel : '特殊患者子类'
		,emptyText: '请选择'	
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'	
		,iconCls : 'icon-find'
		,width : 80
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出'
	});
	
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Index', mapping: 'Index'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'TypeSubDesc', mapping: 'TypeSubDesc'}
			,{name: 'CountCS', mapping: 'CountCS'}
			,{name: 'CountZS', mapping: 'CountZS'}
			,{name: 'CountBJ', mapping: 'CountBJ'}
			,{name: 'CountSH', mapping: 'CountSH'}
			,{name: 'CountZF', mapping: 'CountZF'}
			,{name: 'CountGB', mapping: 'CountGB'}
		])
	});
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,region : 'center'
		,buttonAlign : 'center'
		,tbar : ['->','-',obj.btnQuery,'-',obj.btnExport]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '责任科室', width: 100, dataIndex: 'LocDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '患者大类', width: 200, dataIndex: 'TypeDesc', sortable: true, menuDisabled:true}
			,{header: '患者子类', width: 100, dataIndex: 'TypeSubDesc', sortable: true, menuDisabled:true,
			renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var retStr = "", tmpTypeSubDesc = record.get("TypeSubDesc");
					if (tmpTypeSubDesc=="合计") {
						retStr = "<div style='color:blue'>" + value + "</div>";
					} else {
						retStr = "<div style='color:black'>" + value + "</div>";
					} 
					return retStr;
				}
			}
			,{header: '人(次)数', width: 80, dataIndex: 'CountCS', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '标记人数', width: 80, dataIndex: 'CountBJ', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '审核人数', width: 80, dataIndex: 'CountSH', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '作废人数', width: 80, dataIndex: 'CountZF', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '关闭人数', width: 80, dataIndex: 'CountGB', sortable: true, menuDisabled:true, align: 'center'}
		]
	});
	
	
	obj.cboPatTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.PatType';
			param.QueryName = 'QryPatTypeActive';
			param.ArgCnt = 0;
	});
	obj.cboPatTypeSubStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.PatTypeSub';
			param.QueryName = 'QryPatTypeSubActive';
			param.Arg1 = obj.cboPatType.getValue();
			param.ArgCnt = 1;
	});
		obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.gridResult
			,{
				layout : 'form'
				,region : 'north'
				,height : 75
				,frame : true
				,items :[
					{
						layout : 'column'
						,items : [
							{
								width:240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateFrom]
							},{
								width:240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.txtDateTo]
							},{
								width: 285
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 100
								,items: [obj.cboPatType]
							},{
								width : 240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 100
								,items: [obj.cboPatTypeSub]
							}
						]
					},{
						layout : 'column'
						,items : [
							{
								width: 240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboSSHosp]
							},{
								width : 240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 60
								,items: [obj.cboLoc]
							}
						]
					}
				]
			}
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.PatientsQry';
			param.QueryName = 'QueryStatistic';
			param.Arg1 = obj.txtDateFrom.getRawValue();
			param.Arg2 = obj.txtDateTo.getRawValue();
			param.Arg3 = obj.cboPatType.getValue();
			param.Arg4 = obj.cboPatTypeSub.getValue();
			param.Arg5 = Common_GetValue("cboLoc");
			param.Arg6 = Common_GetValue("cboSSHosp");
			param.ArgCnt = 6;
	});
	InitSpeStatisticEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}


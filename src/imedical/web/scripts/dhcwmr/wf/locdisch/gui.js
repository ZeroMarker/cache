var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
    obj.LocID="";
    obj.LocNotBackFlag="";
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","操作日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,anchor : '100%'
		,text : '导出科室出院信息'
	});
	
	obj.btnExportDtl = new Ext.Button({
		id : 'btnExportDtl'
		,iconCls : 'icon-export'
		,width : 80
		,anchor : '100%'
		,text : '导出科室明细'
	});
	
	obj.LocDischGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LocDischGridStore = new Ext.data.Store({
		proxy: obj.LocDischGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocID'
		},[
			{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping : 'LocDesc'}
			,{name: 'DisNum', mapping : 'DisNum'}
			,{name: 'NotBackNum', mapping : 'NotBackNum'}
			,{name: 'BackNum', mapping : 'BackNum'}
		])
	});
	obj.LocDischGrid = new Ext.grid.GridPanel({
		id : 'LocDischGrid'
		,store : obj.LocDischGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'west'
		,height : 310
		,width : 390
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgLocDischGrid',text:'科室出院查询结果',style:'font-weight:bold;font-size:14px;',xtype:'label'}
		]
		,columns: [
			{header: '科室', width: 150, dataIndex: 'LocDesc', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '未回收数', width: 80, dataIndex: 'NotBackNum', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '回收数', width: 80, dataIndex: 'BackNum', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '出院总人数', width: 80, dataIndex: 'DisNum', sortable: true, menuDisabled:true, align : 'center'}
		]
		,viewConfig : {
			//forceFit : true
		}
    });
    
	obj.LocDischGridDtlStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LocDischGridDtlStore = new Ext.data.Store({
		proxy: obj.LocDischGridDtlStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		},[
			{name: 'VolID', mapping : 'VolID'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'AdmDate', mapping : 'AdmDate'}
			,{name: 'DischDate', mapping : 'DischDate'}
			,{name: 'BackDate', mapping : 'BackDate'}
		])
	});
	
	obj.LocDischGridDtl = new Ext.grid.GridPanel({
		id : 'LocDischGridDtl'
		,store : obj.LocDischGridDtlStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgLocDischGridDtl',text:'科室明细：单击左侧【科室出院查询结果】一条数据显示未回收记录，双击显示所有（未回收+回收）记录',style:'font-weight:bold;font-size:14px;',xtype:'label'}
		]
		,columns: [
			{header: '姓名', width: 100, dataIndex: 'PatName', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '登记号', width: 100, dataIndex: 'PapmiNo', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '病案号', width: 100, dataIndex: 'MrNo', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '就诊日期', width: 100, dataIndex: 'AdmDate', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '出院日期', width: 100, dataIndex: 'DischDate', sortable: true, menuDisabled:true, align : 'center'}
			,{header: '回收日期', width: 100, dataIndex: 'BackDate', sortable: true, menuDisabled:true, align : 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 35,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.dfDateFrom]
					},{
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.dfDateTo]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:80
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.btnQuery]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:135
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.btnExport]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items: [obj.btnExportDtl]
					}
				]
			}
			,obj.LocDischGrid
			,obj.LocDischGridDtl
		]
	});
	
	obj.LocDischGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.VolDischQry';
			param.QueryName = 'QryLocDischData';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = Common_GetValue("cboMrType");
			param.Arg3 = Common_GetValue("dfDateFrom");
			param.Arg4 = Common_GetValue("dfDateTo");
			param.ArgCnt = 4;
	});
	
	obj.LocDischGridDtlStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.VolDischQry';
			param.QueryName = 'QryLocDischData';
			param.Arg1 = Common_GetValue("cboHospital");
			param.Arg2 = Common_GetValue("cboMrType");
			param.Arg3 = Common_GetValue("dfDateFrom");
			param.Arg4 = Common_GetValue("dfDateTo");
			param.Arg5 = obj.LocID;
			param.Arg6 = obj.LocNotBackFlag;
			param.ArgCnt = 6;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}
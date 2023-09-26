function InitWinControl(SubjectID)
{
	var obj = new Object();
	obj.SubjectID = SubjectID;
	obj.SelectNode=null;
	obj.loadParamArg1="";
	obj.loadParamArg2="";
	obj.loadParamArg3="";
	obj.loadParamArg4="";
	obj.loadParamArg5="";
	obj.loadParamArg6="";
    
    obj.selLocDr = "";
    obj.selWardDr = "";
	
    obj.mnuMenu = new Ext.menu.Menu({
        items : [
               {
                   id : 'mnuEva',
                   text : '<B>评价<B/>',
                   iconCls : ''
               },
                "-",
               {
                   id : 'mnuSendMsg',
                   text : '<B>发送消息<B/>',
                   iconCls : ''                   
               },
                "-",
               {
                   id : 'mnuBaseInfo',
                   text : '<B>基本信息<B/>',
                   iconCls : ''                   
               }
        ]
    })



    obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.ux.form.LovCombo({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '住院科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = obj.cboWard.getValue();
			param.ArgCnt = 3;
	});
	obj.cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboWardStore = new Ext.data.Store({
		proxy: obj.cboWardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboWard = new Ext.ux.form.LovCombo({
		id : 'cboWard'
		,width : 100
		,store : obj.cboWardStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '住院病区'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	obj.cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = obj.cboLoc.getValue();
			param.ArgCnt = 3;
	});	
    
    
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '结束日期'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
	});

	obj.radioAdmitDate = new Ext.form.Radio({
		name : 'radioVisit'
		,boxLabel : '入院'
		,inputValue : 'I'
	});
	obj.radioDisDate = new Ext.form.Radio({
		name : 'radioVisit'
		,boxLabel : '出院'
		,inputValue : 'O'
	});	
	obj.radioInHospital = new Ext.form.Radio({
		name : 'radioVisit'
		,boxLabel : '在院'
		,inputValue : 'O'
		,checked : true
	});
	obj.radioVisit = new Ext.form.RadioGroup({
		id : 'radioVisit'
		,fieldLabel : '在院状态'
		,items:[
			obj.radioAdmitDate,
			obj.radioDisDate,
			obj.radioInHospital
		]
	});
	
	

	obj.radioDepTypeD = new Ext.form.Radio({
		name : 'radioDepType'
		,boxLabel : '科室'
		,checked : true
	});	
	obj.radioDepTypeW = new Ext.form.Radio({
		name : 'radioDepType'
		,boxLabel : '病区'
	});
	obj.radioDepType = new Ext.form.RadioGroup({
		id : 'radioDepType'
		,fieldLabel : '统计类别'
		,items:[
			obj.radioDepTypeD,
			obj.radioDepTypeW
		]
	});	
	

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DepName'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DepID', mapping: 'DepID'}
			,{name: 'WardID', mapping: 'WardID'}
			,{name: 'DepName', mapping: 'DepName'}
			,{name: 'InfNumber', mapping: 'InfNumber'}
			,{name: 'DisNumber', mapping: 'DisNumber'}
			,{name: 'InfPercent', mapping: 'InfPercent'}
			,{name: 'InfPercent1000', mapping: 'InfPercent1000'}
			,{name: 'Fee', mapping: 'Fee'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,region : 'center'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,columns: [
			{header: '科室/病房名称', width: 150, dataIndex: 'DepName', sortable: true}
			,{header: '感染人数', width: 80, dataIndex: 'InfNumber', sortable: true}
			,{header: '出院人数', width: 80, dataIndex: 'DisNumber', sortable: true}
			,{header: '感染率', width: 80, dataIndex: 'InfPercent', sortable: true}
			,{header: '千床感染率', width: 80, dataIndex: 'InfPercent1000', sortable: true}
			,{header: '次均费用', width: 80, dataIndex: 'Fee', sortable: true}
		]});

	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.IntegratedCtrl.INFControlSta';
			param.QueryName = 'StaByDate';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			if(obj.radioAdmitDate.getValue())
				param.Arg3 = 1;
			if(obj.radioDisDate.getValue())
				param.Arg3 = 2;
			if(obj.radioInHospital.getValue())
				param.Arg3 = 3;		
			param.Arg4 = obj.cboLoc.getValue();
			param.Arg5 = obj.cboWard.getValue();		
			param.Arg6 = (obj.radioDepTypeD.getValue() ? 1 : 2);		
			param.ArgCnt = 6;
	});		

	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '统计'
		,height: 25
	});
    obj.btnExport = new Ext.Button({
		id:'btnExport'
		,iconCls:'icon-export'
		,anchor:'95%'
		,text:'导出'
		,height: 25
    });
	obj.ConditionPanel = new Ext.form.FormPanel({
		buttonAlign : 'center'
		,layout : 'form'
		,frame:true
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,region : 'east'
		,width : "20%"
		,collapsed : false
		,collapsible : true
		,title : '查询条件'
		,items:[
			obj.radioVisit
			,obj.dfDateFrom
			,obj.dfDateTo
			,obj.radioDepType
			,obj.cboLoc
			,obj.cboWard
		]
		,buttons:[
			obj.btnQuery
			//,obj.btnExport
		]
	});

	obj.pnDisplay = new Ext.Panel({
		region : 'center'
		,autoScroll : true
		,layout : 'fit'
		,html : '<iframe id="iframeResult" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg" />'
	});
	
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.pnDisplay
			,obj.ConditionPanel
		]
	});
	
	InitWinControlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
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


	obj.radioDateType1 = new Ext.form.Radio({
		name : 'radioDateType'
		,boxLabel : '月'
		,checked : true
	});	
	obj.radioDateType2 = new Ext.form.Radio({
		name : 'radioDateType'
		,boxLabel : '季度'
	});
	
	
	obj.radioDateType = new Ext.form.RadioGroup({
		fieldLabel : '日期分组'
		,items:[
			obj.radioDateType1,
			obj.radioDateType2
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
	

	obj.pnResult = new Ext.Panel({
		region : 'center',
		html : '<iframe id="pnResult" src="" height="100%" width="100%"/>'
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
		,width : "25%"
		,collapsed : false
		,collapsible : true
		,title : '查询条件'
		,items:[
			obj.dfDateFrom
			,obj.dfDateTo
			,obj.radioDateType 
			,obj.radioDepType
			,obj.cboLoc
			,obj.cboWard
		]
		,buttons:[
			obj.btnQuery
			//,obj.btnExport
		]
	});
	
	obj.WinControl = new Ext.Viewport({
		id: 'WinControl'
		,layout : 'border'
		,items: [
			obj.pnResult,
			obj.ConditionPanel
		]
	});
	
	InitWinControlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
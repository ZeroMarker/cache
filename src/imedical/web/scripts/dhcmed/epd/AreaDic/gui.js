function InitviewScreen(){
	var obj = new Object(); 
	obj.ParentId=1;
	
	obj.cboProvinceStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboProvinceStore = new Ext.data.Store({
		proxy : obj.cboProvinceStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'RowID'
		}, [
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboProvince = new Ext.form.ComboBox({
		id : 'cboProvince',
		store : obj.cboProvinceStore,
		minChars : 0,
		displayField : 'ShortDesc',
		fieldLabel : '省',
		valueField : 'RowID',
		queryDelay : 10,
		emptyText : '请选择',
		minLength : 0,
		width : 100,
		anchor : '99%',
		editable : false
		,listeners : {
			'select' :  function(){
				obj.cboCity.setDisabled(false);
				obj.cboCounty.setDisabled(true);
				obj.cboCityStore.removeAll();
				obj.cboCity.setValue('');
				obj.cboCity.setRawValue('');
				obj.cboCityStore.load({});
				obj.cboCountyStore.removeAll();
				obj.cboCounty.setValue('');
				obj.cboCounty.setRawValue('');
				obj.gridResultStore.removeAll();
				obj.gridResultStore.load({});
			}
		}
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .30
		,boxMaxWidth : 150
		,boxMinWidth : 100
		,layout : 'form'
		,items:[
			obj.cboProvince
		]
	});
	obj.cboCityStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCityStore = new Ext.data.Store({
		proxy : obj.cboCityStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'RowID'
		}, [
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboCity = new Ext.form.ComboBox({
		id : 'cboCity',
		store : obj.cboCityStore,
		minChars : 0,
		displayField : 'ShortDesc',
		fieldLabel : '市',
		emptyText : '请选择',
		valueField : 'RowID',
		queryDelay : 10,
		width : 100,
		anchor : '99%',
		editable : false
		,listeners : {
			'select' :  function(){
				obj.cboCounty.setDisabled(false);
				obj.cboCountyStore.removeAll();
				obj.cboCounty.setValue('');
				obj.cboCounty.setRawValue('');
				obj.cboCountyStore.load({});
				obj.gridResultStore.removeAll();
				obj.gridResultStore.load({});
			}
		}
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .30
		,boxMaxWidth : 150
		,boxMinWidth : 100
		,layout : 'form'
		,items:[
			obj.cboCity
		]
	});
	obj.cboCountyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCountyStore = new Ext.data.Store({
		proxy : obj.cboCountyStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'RowID'
		}, [
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'RowID', mapping : 'RowID' }
			,{ name : 'ShortDesc', mapping : 'ShortDesc' }
		])
	});
	obj.cboCounty = new Ext.form.ComboBox({
		id : 'cboCounty',
		minChars : 0,
		store : obj.cboCountyStore,
		valueField : 'RowID',
		fieldLabel : '县',
		emptyText : '请选择',
		displayField : 'ShortDesc',
		width : 100,
		anchor : '99%',
		editable : false
		,listeners : {
			'select' :  function(){
				obj.gridResultStore.removeAll();
				obj.gridResultStore.load({});
			}
		}
	});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .40
		,boxMaxWidth : 250
		,boxMinWidth : 200
		,layout : 'form'
		,items:[
			obj.cboCounty
		]
	});
	
	obj.btnAdd = new Ext.Toolbar.Button({
		id : 'obj.btnAdd'
		,iconCls : 'icon-add'
		,text : '增加'
		,width : 80
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
			idProperty: 'RowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'LongDesc', mapping: 'LongDesc'}
			,{name: 'ShortDesc', mapping: 'ShortDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,region : 'center'
		,autoScroll : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 80, dataIndex: 'Code', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 100, dataIndex: 'ShortDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '全名', width: 150, dataIndex: 'LongDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否<br>有效', width: 60, dataIndex: 'IsActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: 'ID', width: 80, dataIndex: 'RowID', sortable: false, menuDisabled:true, align: 'center'}
		]
		,tbar : [obj.btnAdd]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.ConditionPane = new Ext.form.FormPanel({
		id : 'ConditionPane'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,region : 'north'
		,frame : true
		,height : 35
		,items:[
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
		]
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.ConditionPane
			,obj.gridResult
		]
	});
	obj.cboProvinceStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1      = 1;
		param.Arg2      = "";
		param.ArgCnt = 2;
	});
	//obj.cboProvinceStore.load({});
	
	obj.cboCityStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1      = obj.cboProvince.getValue();
		param.Arg2      = "";
		param.ArgCnt = 2;
	});
	//obj.cboCityStore.load({});
	
	obj.cboCountyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
		param.Arg1      = obj.cboCity.getValue();
		param.Arg2      = "";
		param.ArgCnt = 2;
	});
	//obj.cboCountyStore.load({});
	
	//界面初始化是的gridpanel数据
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.AreaDicSrv';
		param.QueryName = 'QryAreaDic';
			var ProvinceID=obj.cboProvince.getValue();
			var CityID=obj.cboCity.getValue();
			var CountyID=obj.cboCounty.getValue();
			if(CountyID!=""){
				obj.ParentId=CountyID;
			}else if(CityID!=""){
				obj.ParentId=CityID;
			}else if(ProvinceID!=""){
				obj.ParentId=ProvinceID;
			}else {
				//省
			}
			param.Arg1 = obj.ParentId;
			param.Arg2    = "";
			param.ArgCnt = 2;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
	
    //窗口代码
function InitwinArea(ParentId,Record){
	var obj = new Object();
	obj.ParentId=ParentId;
	obj.Record=Record;
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,fieldLabel : '代码'
		,width : 100
		,anchor : '99%'
	});
	obj.txtShortDesc = new Ext.form.TextField({
		id : 'txtShortDesc'
		,fieldLabel : '名称'
		,width : 100
		,anchor : '99%'
	});
	obj.txtLongDesc = new Ext.form.TextField({
		id : 'txtLongDesc'
		,fieldLabel : '全名'
		,width : 100
		,anchor : '99%'
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,fieldLabel : '是否有效'
		,anchor : '99%'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
		,width : 60
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-exit'
		,text : '取消'
		,width : 60
	});
	obj.cbowin = new Ext.form.FormPanel({
		id : 'windows'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,items:[
			obj.txtCode
			,obj.txtShortDesc
			,obj.txtLongDesc
			,obj.chkIsActive
		]
	});
	obj.winArea = new Ext.Window({
		id : 'winArea'
		,height : 300
		,buttonAlign : 'center'
		,width : 300
		,modal : true
		,title : '省市县乡维护'
		,layout : 'fit'
		,items:[
			obj.cbowin
		]
		,buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	
	InitwinAreaEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
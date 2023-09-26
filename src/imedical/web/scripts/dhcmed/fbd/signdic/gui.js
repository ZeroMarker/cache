// dhcmed.fbd.signdic.csp
function InitViewport1() {
	
	var obj = new Object();
	
	obj.gridSignDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridSignDicStore = new Ext.data.Store({
		proxy : obj.gridSignDicStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ID'
		},[
			{ name : 'ID', mapping : 'ID' }
			,{ name : 'Code', mapping : 'Code' }
			,{ name : 'Desc', mapping : 'Desc' }
			,{ name : 'ExtraTypeID', mapping : 'ExtraTypeID' }
			,{ name : 'ExtraTypeDesc', mapping : 'ExtraTypeDesc' }
			,{ name : 'ExtraUnit', mapping : 'ExtraUnit' }
			,{ name : 'IsActive', mapping : 'IsActive' }
			,{ name : 'IsActiveDesc', mapping : 'IsActiveDesc' }
			,{ name : 'Resume', mapping : 'Resume' }
		])
	});
	
	obj.gridSignDic = new Ext.grid.GridPanel({
		id : 'gridSignDic'
		,header : true
		,store : obj.gridSignDicStore
		,columnLines : true
		,loadMask : true
		,region : 'center'
		,frame : true
		,columns : [
			new Ext.grid.RowNumberer()
			,{ header : '代码', width : 150, dataIndex : 'Code', sortable : true }
			,{ header : '描述', width : 200, dataIndex : 'Desc', sortable : true }
			,{ header : '值类型', width : 150, dataIndex : 'ExtraTypeDesc', sortable : true }
			,{ header : '值单位', width : 150, dataIndex : 'ExtraUnit', sortable : true }
			,{ header : '是否有效', width : 100, dataIndex : 'IsActiveDesc', sortable : true }
			,{ header : '备注', width : 300, dataIndex : 'Resume', sortable : true }
		]
	});
	
	obj.gridSignDicStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.FBDService.SignDicSrv';
		param.QueryName = 'QrySignDic';
		param.Arg1 = '';
		param.Arg2 = '';
		param.Arg3 = '';
		param.ArgCnt = 3;
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,width : 160
		,fieldLabel : '代码'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,width : 160
		,fieldLabel : '描述'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.txtExtraUnit = new Ext.form.TextField({
		id : 'txtExtraUnit'
		,width : 160
		,fieldLabel : '值单位'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.txtResume = new Ext.form.TextField({
		id : 'txtResume'
		,width : 160
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '99%'
	});
	
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,fieldLabel : '是否有效'
		,labelSeparator :''
		,checked : true
	});
	
	obj.cboExtraTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.cboExtraTypeStore = new Ext.data.Store({
		proxy : obj.cboExtraTypeStoreProxy
		,reader : new Ext.data.JsonReader({
			root : 'record'
			,totalProperty : 'total'
			,idProperty : 'myid'
		},[
			{ name : 'checked', mapping : 'checked' }
			,{ name : 'myid', mapping : 'myid' }
			,{ name : 'Description', mapping : 'Description' }
		])
		,listeners : {
			'load' : function() {
				for (var i=0; i<obj.cboExtraTypeStore.getCount(); i++) {
					if (obj.cboExtraTypeStore.getAt(i).get("Description")=="无") {
						obj.cboExtraType.setValue(obj.cboExtraTypeStore.getAt(i).get("myid"));
					}
				}
			}
		}
	});
	
	obj.cboExtraType = new Ext.form.ComboBox({
		id : 'cboExtraType'
		,width : 160
		,valueField : 'myid'
		,displayField : 'Description'
		,minChars : 1
		,fieldLabel : '值类型'
		,store : obj.cboExtraTypeStore
		,labelSeparator :''
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	obj.cboExtraTypeStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'FBDSignExtraType';
		param.Arg2 = 1;
		param.ArgCnt = 2;
	});
	
	obj.pnCol1 = new Ext.Panel({
		id : 'pnCol1'
		,layout : 'form'
		,columnWidth : 0.33
		,items : [
			obj.txtCode
			,obj.txtDesc
		]
	});
	
	obj.pnCol2 = new Ext.Panel({
		id : 'pnCol2'
		,layout : 'form'
		,columnWidth : 0.33
		,items : [
			obj.cboExtraType
			,obj.txtExtraUnit
		]
	});
	
	obj.pnCol3 = new Ext.Panel({
		id : 'pnCol3'
		,layout : 'form'
		,columnWidth : 0.33
		,items : [
			obj.chkIsActive
			,obj.txtResume
		]
	});
	
	obj.pnSignDic = new Ext.form.FormPanel({
		id : 'pnSignDic'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 85
		,bodyBorder : 'padding : 0 0 0 0'
		,region : 'south'
		,height : 110
		,frame : true
		,layout : 'column'
		,items : [
			obj.pnCol1
			,obj.pnCol2
			,obj.pnCol3
		]
		,buttons : [
			obj.btnSave
		]
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items : [
			obj.gridSignDic
			,obj.pnSignDic
		]
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitWinVarCateg(){
	var obj = new Object();
	obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'VCCode', mapping: 'VCCode'}
			,{name: 'VCDesc', mapping: 'VCDesc'}
			,{name: 'VCColour', mapping: 'VCColour'}
			,{name: 'VCDateFrom', mapping: 'VCDateFrom'}
			,{name: 'VCDateTo', mapping: 'VCDateTo'}
			,{name: 'VCTypeDesc', mapping: 'VCTypeDesc'}
			,{name: 'VCType', mapping: 'VCType'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'

		,store : obj.MainGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: 'ID', width: 50, dataIndex: 'ID', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'VCCode', sortable: true}
			,{header: '描述', width: 200, dataIndex: 'VCDesc', sortable: false}
			,{header: '颜色', width: 80, dataIndex: 'VCColour', sortable: false}
			,{header: '开始日期', width: 100, dataIndex: 'VCDateFrom', sortable: true}
			,{header: '结束日期', width: 100, dataIndex: 'VCDateTo', sortable: true}
			,{header: '类型', width: 100, dataIndex: 'VCTypeDesc', sortable: false}
		]
		/*,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MainGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})*/ //Modified By LiYang 2011-05-28 取消分页
		,stripeRows : true
                ,autoExpandColumn : 'VCDesc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
});
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
		]
	});
	obj.txtVCCode = new Ext.form.TextField({
		id : 'txtVCCode'
		,width : 150
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	obj.txtVCDesc = new Ext.form.TextField({
		id : 'txtVCDesc'
		,width : 150
		,fieldLabel : '描述'
		,anchor : '95%'
	});
	obj.dtVCDateFrom = new Ext.form.DateField({
		id : 'dtVCDateFrom'
		,width : 150
		,fieldLabel : '开始日期'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,anchor : '95%'
	});
	obj.dtVCDateTo = new Ext.form.DateField({
		id : 'dtVCDateTo'
		,width : 150
		,fieldLabel : '结束日期'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,anchor : '95%'
	});
	
	obj.txtVCColour = new Ext.form.TextField({
		id : 'txtVCColour'
		,width : 150
		,fieldLabel : '颜色'
		,anchor : '95%'
		,readOnly : true
	});
	obj.ColorPicker = new Ext.ColorPalette({
			id : 'ColorPicker'
			,hidden : true
			,width : 300
	});
	obj.ColorPicker.colors =  
			   ["000000","000033","000066","000099","0000CC","0000FF","330000","330033","330066","330099","3300CC",
				"3300FF","660000","660033","660066","660099","6600CC","6600FF","990000","990033","990066","990099",
				"9900CC","9900FF","CC0000","CC0033","CC0066","CC0099","CC00CC","CC00FF","FF0000","FF0033","FF0066",
				"FF0099","FF00CC","FF00FF","003300","003333","003366","003399","0033CC","0033FF","333300","333333",
				"333366","333399","3333CC","3333FF","663300","663333","663366","663399","6633CC","6633FF","993300",
				"993333"];
				/*,"993366","993399","9933CC","9933FF","CC3300","CC3333","CC3366","CC3399","CC33CC","CC33FF",
				"FF3300","FF3333","FF3366","FF3399","FF33CC","FF33FF","006600","006633","006666","006699","0066CC",
				"0066FF","336600","336633","336666","336699","3366CC","3366FF","666600","666633","666666","666699",
				"6666CC","6666FF","996600","996633","996666","996699","9966CC","9966FF","CC6600","CC6633","CC6666",
				"CC6699","CC66CC","CC66FF","FF6600","FF6633","FF6666","FF6699","FF66CC","FF66FF","009900","009933",
				"009966","009999","0099CC","0099FF","339900","339933","339966","339999","3399CC","3399FF","669900",
				"669933","669966","669999","6699CC","6699FF","999900","999933","999966","999999","9999CC","9999FF",
				"CC9900","CC9933","CC9966","CC9999","CC99CC","CC99FF","FF9900","FF9933","FF9966","FF9999","FF99CC",
				"FF99FF","00CC00","00CC33","00CC66","00CC99","00CCCC","00CCFF","33CC00","33CC33","33CC66","33CC99",
				"33CCCC","33CCFF","66CC00","66CC33","66CC66","66CC99","66CCCC","66CCFF","99CC00","99CC33","99CC66",
				"99CC99","99CCCC","99CCFF","CCCC00","CCCC33","CCCC66","CCCC99","CCCCCC","CCCCFF","FFCC00","FFCC33",
				"FFCC66","FFCC99","FFCCCC","FFCCFF","00FF00","00FF33","00FF66","00FF99","00FFCC","00FFFF","33FF00",
				"33FF33","33FF66","33FF99","33FFCC","33FFFF","66FF00","66FF33","66FF66","66FF99","66FFCC","66FFFF",
				"99FF00","99FF33","99FF66","99FF99","99FFCC","99FFFF","CCFF00","CCFF33","CCFF66","CCFF99","CCFFCC",
				"CCFFFF","FFFF00","FFFF33","FFFF66","FFFF99","FFFFCC","FFFFFF"];*/
	obj.cboVarCategTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboVarCategTypeStore = new Ext.data.Store({
		proxy: obj.cboVarCategTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboVarCategType = new Ext.form.ComboBox({
		id : 'cboVarCategType'
		,width : 150
		,store : obj.cboVarCategTypeStore
		,displayField : 'DicDesc'
		,fieldLabel : '类型'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DicCode'
	});
	
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtVCCode
			,obj.txtVCDesc
			,obj.txtVCColour
			,obj.dtVCDateFrom
			,obj.dtVCDateTo
			,obj.cboVarCategType
		]
	});
	
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.ColorPicker
		]
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.MainPanel = new Ext.form.FormPanel({
		id : 'MainPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,height:220,
		frame:true,
		labelAlign:'right'
		,region : 'south'
		,items:[
			obj.SubPanel1
			,obj.SubPanel2
			,obj.SubPanel3
		]		
		,	buttons:[
			obj.btnUpdate
			,obj.btnDelete
		]
	
	});
	
	obj.WinVarCateg = new Ext.Viewport({
		id : 'WinVarCateg'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,title : '变异类型维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainGridPanel
			,obj.MainPanel
		]

	});
	obj.cboVarCategTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseConfig';
			param.QueryName = 'QryBaseDic';
			param.Arg1 = "VarCategoryType";
			param.ArgCnt = 1;
	});
	obj.cboVarCategTypeStore.load({});
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
			param.QueryName = 'QueryAll';
			param.ArgCnt = 0;
	});
	obj.MainGridPanelStore.load({
	params : {
		start:0
		,limit:20
	}});
	
	InitWinVarCategEvent(obj);
  	obj.LoadEvent(arguments);
  	return obj;
}


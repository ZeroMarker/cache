
function InitMainViewport(){
	var obj = new Object();
	CategID=ExtTool.GetParam(window,"cate");    //add by wuqk 2011-09-16
	obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'CategID', mapping: 'CategID'}
			,{name: 'CategDesc', mapping: 'CategDesc'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'MultiSelect', mapping: 'MultiSelect'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'
		,store : obj.MainGridPanelStore
		,region : 'center'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,columns: [
			//obj.MainGridPanelCheckCol
			//{header: '大类',  dataIndex: 'CategDesc', sortable: true}
			{header: '代码',  dataIndex: 'Code', sortable: false}
			,{header: '描述',  dataIndex: 'Desc', sortable: false}
			,{header: '字典类型',  dataIndex: 'Type', sortable: false,
				renderer:function(value, metaData, record, rowIndex, colIndex, store){
					//data: [['DIC', '字典'], ['B', '是否'], ['T', '文本'], ['D', '日期'], ['I', '整数'], ['N', '数值']]
					var strRet='';
					switch(value)
					{
						case "DIC":
							strRet="字典";
							break;
						case "B":
							strRet="是否";
							break;
						case "T":
							strRet="文本";
							break;
						case "D":
							strRet="日期";
							break;
						case "I":
							strRet="整数";
							break;
						case "N":
							strRet="数值";
							break;
					}
					return strRet;
				}
			}
			,{header: '可多选',  dataIndex: 'MultiSelect', sortable: false,
				renderer:function(value, metaData, record, rowIndex, colIndex, store){
					if (value=="1"){return "Yes"}
					else{return "No"}
				}
			}
		]/*
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MainGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})*/
		,stripeRows : true
        ,autoExpandColumn : 'Desc'
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
		,columnWidth : .1
		,layout : 'form'
		,items:[
		]
	});
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		//,width : 150
		,fieldLabel : '代码'
		,anchor : '100%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		//,width : 150
		,fieldLabel : '描述'
		,anchor : '100%'
	});/*
	obj.cboCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCategStore = new Ext.data.Store({
		proxy: obj.cboCategStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboCateg = new Ext.form.ComboBox({
		id : 'cboCateg'
		,width : 150
		,store : obj.cboCategStore
		,displayField : 'Desc'
		,fieldLabel : '大类'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});*/
	
	
	obj.chkMultiSelect = new Ext.form.Checkbox({
		id : 'chkMultiSelect'
		//,boxLabel : '是否有效'
		,fieldLabel : '可多选'
		,disabled : true
	});
	obj.cboType = new Ext.form.ComboBox({
		id : 'cboType',
		mode: 'local',
		fieldLabel : '数据类型',
		width : 245,
		forceSelection:true,
		allowBlank : false,
		store: new Ext.data.ArrayStore({
			id: 0,
			fields: [
				'code',
				'Text'
			],
			data: [['DIC', '字典'], ['B', '是否'], ['T', '文本'], ['D', '日期'], ['I', '整数'], ['N', '数值']]
		}),
    valueField: 'code',
    displayField: 'Text'
	});
	//",DIC,B,T,D,I,N"

	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,width : 400
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 150
		,items:[
			obj.txtCode
			,obj.txtDesc
			,obj.cboType
			,obj.chkMultiSelect
			//,obj.cboCateg
		]
	});
	
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
		]
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.MainPanel = new Ext.form.FormPanel({
		id : 'MainPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,height:165,
		frame:true,
		labelAlign:'right'
		,region : 'south'
		,items:[
			obj.SubPanel1
			,obj.SubPanel2
			,obj.SubPanel3
		]		
		,buttons:[
			obj.btnUpdate
		]
	
	});
	obj.WinDicCateg = new Ext.Viewport({
		id : 'WinDicCateg'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,title : '基础字典项目子类维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainGridPanel
			,obj.MainPanel
		]
	});
	/*
	obj.cboCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDicCategory';
			param.QueryName = 'QryCategory';
			param.ArgCnt = 0;
	});
	obj.cboCategStore.load({});*/
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDicSubCategory';
			param.QueryName = 'QrySubCategory';
			param.Arg1 = CategID;    //add by wuqk 2011-09-16 cateId
			param.ArgCnt = 1;
	});
	obj.MainGridPanelStore.load({});
	/*
	{
	params : {
		start:0
		,limit:20
	}}
	*/
	
	InitMainViewportEvent(obj);
  	obj.LoadEvent(arguments);
  	return obj;
}



function InitMainViewport(){
	var obj = new Object();
	obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BCID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'BCID', mapping: 'BCID'}
			,{name: 'BCCode', mapping: 'BCCode'}
			,{name: 'BCDesc', mapping: 'BCDesc'}
			,{name: 'BCValue', mapping: 'BCValue'}
			,{name: 'BCResume', mapping: 'BCResume'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'

		,store : obj.MainGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: 'ID', width: 30, dataIndex: 'BCID', sortable: true}
			,{header: '����', width: 100, dataIndex: 'BCCode', sortable: true}
			,{header: '����', width: 100, dataIndex: 'BCDesc'}
			,{header: 'ֵ', width: 100, dataIndex: 'BCValue'}
			,{header: '˵��', width: 200, dataIndex: 'BCResume'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MainGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,stripeRows : true
        ,autoExpandColumn : 'BCResume'
        ,bodyStyle : 'width:100%'
        ,autoWidth : true
        ,autoScroll : true
        ,viewConfig : {
            forceFit : true
        }
	});
	obj.txtBCCode = new Ext.form.TextField({
		id : 'txtBCCode'
		,width : 150
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.txtBCDesc = new Ext.form.TextField({
		id : 'txtBCDesc'
		,width : 150
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.txtBCValue = new Ext.form.TextField({
		id : 'txtBCValue'
		,width : 150
		,fieldLabel : 'ֵ'
		,anchor : '95%'
	});
	obj.txtBCResume = new Ext.form.TextArea({
		id : 'txtBCResume'
		,height : 75
		,width : 100
		//,fieldLabel : '��ע'
		,fieldLabel : '˵��'	//	Modified by zhaoyu 2012-11-14 ������Ϣά��-������������-�������ͷ�е�"˵��"����Ŀ�����е�"��ע"һ�� ȱ�ݱ��150
		,anchor : '95%'
	});
	
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[]
	});
	
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .80
		,layout : 'form'
		,items:[
			obj.txtBCCode
			,obj.txtBCDesc
			,obj.txtBCValue
			,obj.txtBCResume
		]
	});
	
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[]
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.MainPanel = new Ext.form.FormPanel({
		id : 'MainPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,height:210,
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
			,obj.btnDelete
		]
	
	});
	
	obj.WinBaseConfig = new Ext.Viewport({
		id : 'WinBaseConfig'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,title : '������������'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainGridPanel
			,obj.MainPanel
		]
	});
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseConfig';
			param.QueryName = 'QueryAll';
			param.ArgCnt = 0;
	});
	obj.MainGridPanelStore.load({
	params : {
		start:0
		,limit:20
	}});
	
	InitMainViewportEvent(obj);
  	obj.LoadEvent(arguments);
  	return obj;
}


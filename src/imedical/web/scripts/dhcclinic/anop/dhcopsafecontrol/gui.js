//20170307+dyl
function InitViewScreen()
{
	var obj = new Object();
	obj.form1 = new Ext.form.TextField({
		id : 'form1'
		,fieldLabel :'<span style=color:red;>*</span>��Ŀ'
		,labelSeparator: ''
		//,width:120
		,triggerAction : 'all'
		,anchor : '98%'
	}); 
    
	var data=[
		['A','��ʾ'],
		['F','��ֹ'],
		['N','�޿���']
	]
	obj.form2StoreProxy=data;
	obj.form2Store = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.form2 = new Ext.form.ComboBox({
		id : 'form2'
		,minChars : 1
		,fieldLabel : '<span style=color:red;>*</span>��������'
		,triggerAction : 'all'
		,editable:false
		,store : obj.form2Store
		,displayField : 'desc'
		,labelSeparator: ''
		,anchor : '98%'
		,valueField : 'code'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 60
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.form1
		]
	});
	obj.form4StoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.form4Store = new Ext.data.Store({
		proxy: obj.form4StoreProxy,
		reader: new Ext.data.JsonReader({
			root:'record',
			totalProperty:'total',
			idProperty: 'RowId'
          }, 
		[
			{name:'code',mapping:'typeCode'}
			,{name:'desc',mapping:'typeDesc'}

		])
	});
	obj.form4 = new Ext.form.ComboBox({
		id : 'form4'
		,store : obj.form4Store
		,minChars : 0
		,fieldLabel : '<span style=color:red;>*</span>��Ŀ����'
		,triggerAction : 'all'
		,editable:false
		,displayField : 'desc'
		,labelSeparator: ''
		,anchor : '98%'
		,editable : true
		,valueField : 'code'

	});
	
	obj.form4StoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPItemCheck';
		param.QueryName = 'FindCheckItemType';
		param.ArgCnt = 0;
	});
	obj.form4Store.load();
	obj.form3 = new Ext.form.TextField({
		id : 'form3'
		,fieldLabel : '<span style=color:red;>*</span>��Ŀ����'
		//,width:120
		,labelSeparator: ''
		,anchor : '98%'
	}); 
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.form3
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.form4
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.form2
		]
	});	
	

    obj.addbutton= new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:84
		,text : '����'
	});
	obj.deletebutton= new Ext.Button({
		id : 'deletebutton'
		,width:84
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.updatabutton= new Ext.Button({
		id : 'updatabutton'
		,width:84
		,iconCls : 'icon-updateSmall'
		,text : '����'
	});
	obj.buttonPanel1 = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:15px'
		,layout : 'form'
        ,items:[
			obj.addbutton
		]
	});
	obj.buttonPanel2 = new Ext.Panel({
		id : 'buttonPane2'
		,buttonAlign : 'center'
		,style:'margin-left:15px'
		,columnWidth : .1
		,layout : 'form'
        ,items:[
			obj.deletebutton
		]
	});
	obj.buttonPanel3 = new Ext.Panel({
		id : 'buttonPane3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,style:'margin-left:15px'
		,layout : 'form'
        ,items:[
			obj.updatabutton
		]
	});
	
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OpaId'
		}, 
	    [
	         {name: 'ID', mapping : 'tId'}
			,{name: 'tItemDesc', mapping : 'tItemDesc'}
			,{name: 'tItemCode', mapping : 'tItemCode'}
			,{name: 'tCtrType', mapping : 'tCtrType'}
			,{name: 'tItemType', mapping : 'tItemType'}
			,{name: 'tTypeCode', mapping : 'tTypeCode'}
			,{name: 'ctrType', mapping : 'ctrType'}
		])
	});
	
	  obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,height : 330
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: 'ID', width: 40, dataIndex: 'ID', sortable: true,hidden:true}
		,{header: '��Ŀ', width: 150, dataIndex: 'tItemDesc', sortable: true}
		,{header: '��Ŀ����', width: 150, dataIndex: 'tItemCode', sortable: true}
		,{header: '��������', width: 150, dataIndex: 'tCtrType', sortable: true}
		,{header: '�������ʹ���', width: 100, dataIndex: 'ctrType', sortable: true}
		,{header: '��Ŀ����', width: 150, dataIndex: 'tItemType', sortable: true}
		,{header: '��Ŀ����Code', width: 150, dataIndex: 'tTypeCode', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '������ȫ�����ѯ���'
	    ,region : 'center'
		,layout : 'border'
		,iconCls:'icon-result'
		,frame : true
		,tbar:obj.tb
		,items:[
		    obj.retGridPanel
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 70
		,labelAlign : 'right'
		,title : '������ȫ����'
		,iconCls:'icon-opersafe'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
           ,obj.buttonPanel1
           ,obj.buttonPanel2
           ,obj.buttonPanel3
            
		]
    });
    obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPItemCheck';
		param.QueryName = 'FindChkItem';
		param.ArgCnt = 0;
	});
	
	
     obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.resultPanel
		]
	});
    
	InitViewScreenEvent(obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
    obj.updatabutton.on("click", obj.updatabutton_click, obj);
    obj.retGridPanelStore.load({});
    //obj.LoadEvent(arguments);
	return obj;
	
}
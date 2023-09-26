//20170307+dyl
function InitViewScreen(){
	var obj = new Object();
	obj.bpcERMCode = new Ext.form.TextField({
		id : 'bpcERMCode'
		,fieldLabel : 'ģʽ����'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.bpcERMDesc = new Ext.form.TextField({
		id : 'bpcERMDesc'
		,fieldLabel : 'ģʽ����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcERMCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcERMDesc
		]
	});
		obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,style:'margin-left:20px'
		,iconCls:'icon-add'
		,text : '����'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,style:'margin-left:20px'
		,iconCls:'icon-edit'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,style:'margin-left:20px'
		,iconCls:'icon-delete'
		,text : 'ɾ��'
	});
	obj.buttonpanel = new Ext.Panel({
		id : 'buttonpanel'
		,buttonAlign : 'right'
		//,height : 80
		,columnWidth : .5
		,layout : 'column'
		,items:[
		    obj.addbutton
		    ,obj.updatebutton
		    ,obj.deletebutton
		]
	});
	
	
	
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		,region : 'north'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Rowid
			,obj.buttonpanel
		]
	});

	obj.runmodePanel = new Ext.Panel({
		id : 'runmodePanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '�豸͸��ģʽά��'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
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
			idProperty: 'tBPCERMRowId'
		}, 
	    [
			{name: 'tBPCERMDesc', mapping : 'tBPCERMDesc'}
			,{name: 'tBPCERMCode', mapping: 'tBPCERMCode'}
			,{name: 'tBPCERMRowId', mapping: 'tBPCERMRowId'}

		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{
				header: 'ģʽ����'
				,width: 150
				,dataIndex: 'tBPCERMCode'
				,sortable: true
				}
        	,{
		        header: 'ģʽ����'
				, width: 150
				, dataIndex: 'tBPCERMDesc'
				, sortable: true
					
			}
			,{
				header: 'ϵͳ��'
				, width: 100
				, dataIndex: 'tBPCERMRowId'
				, sortable: true
			}
		
		]
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipRunMode';
		param.QueryName = 'FindERunMode';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});

    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.runmodePanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}
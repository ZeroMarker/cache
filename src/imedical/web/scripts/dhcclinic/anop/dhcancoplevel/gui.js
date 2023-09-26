//20170302+GY
function InitViewScreen(){
	var obj = new Object();
	obj.anCOPLCode = new Ext.form.TextField({//newһ���ı���
		id : 'anCOPLCode'
		,fieldLabel : '������ģ����' //��ǩ
		,labelSeparator: ''
		,anchor : '95%'  //�����ı���ĳ���
	});	
	
	obj.anCOPLDesc = new Ext.form.TextField({
		id : 'anCOPLDesc'
		,fieldLabel : '������ģ����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true //��ʾ����Ϊ����
    });
	  	
   	obj.Panel1 = new Ext.Panel({ //newһ��Panel
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.anCOPLCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,style:'margin-left:10px'
		,labelAlign : 'right'
		,items:[
			obj.anCOPLDesc
		]
	});
	/*
    obj.fPanel = new Ext.form.FormPanel({ //Newһ��FormPanel
		id : 'fPanel'
		,buttonAlign : 'center' 
		,labelAlign : 'right'  
	    ,labelWidth : 100
		,height : 30
		,region : 'north'  //����ڱ���
		,layout : 'column'
		,columnWidth : .7
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Rowid
		]
	});*/
	obj.addbutton = new Ext.Button({  //Newһ����ť
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,style:'margin-left:15px'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		,style:'margin-left:15px'		
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		,style:'margin-left:15px'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
	});	
	/*
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,region : 'center'
		,columnWidth : .3
		,layout : 'column'
		,height : 30
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});*/
	obj.runmodePanel = new Ext.Panel({
		id : 'runmodePanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '������ģά��'
		,region : 'north'
		,iconCls:'icon-manage'
		,layout : 'column'  //
		,frame : true   //�Ƿ��б߿�
		,collapsible:true  //
		,animate:true    //
		,items:[
			//obj.fPanel
			//,obj.buttonPanel	
			obj.Panel1
			,obj.Panel2	
			,obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
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
			idProperty: 'RowId'
		}, 
	    [
			{name: 'ANCOPL_Desc', mapping : 'ANCOPL_Desc'}
			,{name: 'ANCOPL_Code', mapping: 'ANCOPL_Code'}
			,{name: 'RowId', mapping: 'RowId'}

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
				,width: 200
				,dataIndex: 'ANCOPL_Code'
				,sortable: true
				}
        	,{
		        header: 'ģʽ����'
				, width: 200
				, dataIndex: 'ANCOPL_Desc'
				, sortable: true
					
			}
			,{
				header: 'ϵͳ��'
				, width: 0
				, dataIndex: 'RowId'
				, sortable: true
				,hidden:true
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
		param.ClassName = 'web.DHCANCOPLevel';
		param.QueryName = 'FindOPLevel';
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
		,title : '������ģ��ѯ���'
		,region : 'center'
		,layout : 'border'
	    ,iconCls:'icon-result'
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
function InitViewScreen(){
	var obj = new Object();
	obj.PatName = new Ext.form.TextField({
		id : 'PatName'
		,fieldLabel : '��������'
		,anchor : '95%'
		,readOnly:true
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	
	obj.schPanel1 = new Ext.Panel({
		id : 'schPanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.PatName
		]
	});
	obj.EpisodeID = new Ext.form.TextField({
		id : 'EpisodeID'
		,fieldLabel : '�����'
		,anchor : '95%'
		,readOnly:true
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	
	obj.schPanel2 = new Ext.Panel({
		id : 'schPanel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.EpisodeID
		]
	});
   
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,text : '����'
	});
	obj.schPanel3 = new Ext.Panel({
		id : 'schPanel3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.btnAdd
		]
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,text : '����'
	});
	obj.schPanel4 = new Ext.Panel({
		id : 'schPanel4'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.btnUpdate
		]
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,text : 'ɾ��'
	});
	obj.schPanel5 = new Ext.Panel({
		id : 'schPanel5'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.btnDelete
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '��ѯ'
	});
	obj.schPanel6 = new Ext.Panel({
		id : 'schPanel6'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.btnSch
		]
	});
	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,buttonAlign : 'center'
		,height : 80
		,title : '������Ϣ'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.schPanel1
			,obj.schPanel2
			,obj.schPanel3
			,obj.schPanel4
			,obj.schPanel5
			,obj.schPanel6
		]
	});
	obj.CLCMSStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CLCMSStore = new Ext.data.Store({
		proxy: obj.CLCMSStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CLCMSId'
		}, 
		[
			{name: 'CLCMSId', mapping: 'rowId'}
			,{name: 'CLCMSDesc', mapping: 'Desc'}
		])
	});
	obj.CLCMS = new Ext.form.ComboBox({
		id : 'CLCMS'
		,store : obj.CLCMSStore
		,minChars : 1
		,displayField : 'CLCMSDesc'
		,fieldLabel : '�����¼�'
		,valueField : 'CLCMSId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	var sessLoc=sessLoc=session['LOGON.CTLOCID'];
	obj.CLCMSStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLMedicalSafety';
		param.QueryName = 'GetEvent';
		param.Arg1 = obj.CLCMS.getRawValue();
		param.Arg2 = sessLoc;
		param.ArgCnt = 2;
	});
	obj.CLCMSStore.load({});
	obj.status = new Ext.form.ComboBox({
		id : 'status'
		,store : [[' ',' '],['N','Normal'],['A','Audit']]
		,minChars : 1 
		//,renderTo:'lovcomboct' 
		,displayField : 'statusDesc'
		,fieldLabel : '״̬'
		,valueField : 'statusId'
		,mode: 'local'
		,triggerAction : 'all'
		,anchor : '95%'
		
	});
	obj.tschPanel1 = new Ext.Panel({
		id : 'tschPanel1'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.CLCMS
		]
	});
	obj.tschPanel2 = new Ext.Panel({
		id : 'tschPanel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.status
		]
	});
	obj.note = new Ext.form.TextField({
		id : 'note'
		,fieldLabel : '��ע'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
	});
	obj.tschPanel3 = new Ext.Panel({
		id : 'tschPanel3'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
		    obj.note
		]
	});
	obj.tschPanel = new Ext.Panel({
		id : 'tschPanel'
		,buttonAlign : 'center'
		,height : 142
		,title : '�����¼���д'
		,region : 'center'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.tschPanel1
			,obj.tschPanel2
			,obj.tschPanel3
		]
	});
	obj.sch = new Ext.Panel({
		id : 'sch'
		,buttonAlign : 'center'
		,height : 200
		,title : '������Ϣ'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.schPanel
			,obj.tschPanel
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
			idProperty: 'trowId'
		}, 
		[
			{name: 'tEventId', mapping: 'EventId'}
			,{name: 'tEventDesc', mapping: 'EventDesc'}
			,{name: 'tstatusCode', mapping: 'statusCode'}
			,{name: 'tstatusDesc', mapping: 'statusDesc'}
			,{name: 'tnote', mapping: 'note'}
			,{name: 'trowId', mapping: 'rowId'}
		])
	});
	
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
            new Ext.grid.RowNumberer()
			,{header: '�����¼�', width: 300, dataIndex: 'tEventDesc', sortable: true}
			,{header: '�����¼�Id', width: 300, dataIndex: 'tEventId', sortable: true,hidden : true}
			,{header: '״̬', width: 300, dataIndex: 'tstatusDesc', sortable: true}
			,{header: '״̬Id', width: 300, dataIndex: 'tstatusCode', sortable: true,hidden : true}
			,{header: '��ע', width: 300, dataIndex: 'tnote', sortable: true}
			,{header: 'rowId', width: 300, dataIndex: 'trowId', sortable: true,hidden : true}
			]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
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
		,title : '�����¼���ѯ���'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,tbar:obj.tb
		,items:[
			//obj.Panel23
			//,obj.Panel25
			obj.retGridPanel
		]
	});
	obj.rowId = new Ext.form.TextField({
		id : 'rowId'
	});
	obj.icuId = new Ext.form.TextField({
		id : 'icuId'
	});
	obj.sessLoc = new Ext.form.TextField({
		id : 'sessLoc'
	});
	obj.hiddenPanel = new Ext.Panel({
		id : 'hiddenPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,hidden : true
		,items:[
			obj.rowId
			,obj.icuId
			,obj.sessLoc
		]
	});
	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.sch
			,obj.resultPanel
			,obj.hiddenPanel
		]
	});
	
	InitViewScreenEvent(obj);
	
	
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	obj.btnUpdate.on("click", obj.btnUpdate_click, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.LoadEvent(arguments);
	return obj;
	
}
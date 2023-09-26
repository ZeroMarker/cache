var dateFormat=tkMakeServerCall("web.DHCClinicCom","GetDateFormat");
function InitViewScreen()
{
	 var obj = new Object();
	 
	 //��Ȩ���ң�Ĭ�ϵ�ǰ��¼���ң������޸�
	 obj.ANAACtlocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ANAACtlocStore = new Ext.data.Store({
	    proxy : obj.ANAACtlocStoreProxy
		,reader : new Ext.data.JsonReader({
		     root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctlocId'
		},
		[
		    {name:'ctlocDesc',mapping:'ctlocDesc'}
			,{name:'ctlocId',mapping:'ctlocId'}
		])
	
	});
	obj.ANAACtloc=new Ext.form.ComboBox({
		id : 'ANAACtloc'
		,store:obj.ANAACtlocStore
		,mode:'local'
		,minChars:1	
		,displayField:'ctlocDesc'	
		,fieldLabel : '<span style="color:red;">*</span>��Ȩ����'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable:false
		//,readOnly:true
	}); 
	obj.ANAACtlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.ANAACtloc.getRawValue();
		param.Arg2 = '';
		param.Arg3 = "";
		param.ArgCnt = 3;
	});	
	obj.Panel11 = new Ext.Panel({ 
		id : 'Panel11'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth:80
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.ANAACtloc
		]
	});
	
	obj.ANAACtpcpStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ANAACtpcpStore = new Ext.data.Store({
	    proxy : obj.ANAACtpcpStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctcpId'
		},
		[
		    {name:'ctcpDesc',mapping:'ctcpDesc'}
			,{name:'ctcpId',mapping:'ctcpId'}
		])
	
	});	
	obj.ANAACtpcp=new Ext.form.ComboBox({
		id : 'ANAACtpcp'
		,store:obj.ANAACtpcpStore
		,minChars:1	
		,displayField:'ctcpDesc'	
		,fieldLabel : '<span style="color:red;">*</span>��Ȩҽ��'
		,valueField : 'ctcpId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : true
	}); 
	obj.ANAACtpcpStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPArrange';
		param.QueryName = 'FindCtcp';
		param.Arg1 = obj.ANAACtpcp.getRawValue();
		param.Arg2 ='INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.Arg3= obj.ANAACtloc.getValue();
		param.Arg4 ="";
		param.Arg5 ="";
		param.Arg6 = "Y";
		param.Arg7 = "";
		param.ArgCnt = 7;
	});
	obj.Panel12 = new Ext.Panel({ 
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth: 80
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.ANAACtpcp
		]
	});
	obj.ANAAStartDate=new Ext.form.DateField({
	    id : 'ANAAStartDate'
		,value : new Date()
		,format : dateFormat
		,fieldLabel : '<span style="color:red;">*</span>��Ȩ��ʼ����'
		,width:165
		,labelSeparator: ''
		,anchor : '100%'
	});
	
	obj.Panel13 = new Ext.Panel({ 
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelWidth: 100
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.ANAAStartDate
		]
	});
	obj.ANAAStartTime = new Ext.form.TimeField({
	    id : 'ANAAStartTime'
		,format : 'H:i'
		,fieldLabel : '<span style="color:red;">*</span>��Ȩ��ʼʱ��'
		,width:180
		,labelSeparator: ''
		,anchor : '100%'
	});
	obj.Panel14 = new Ext.Panel({ 
		id : 'Panel14'
		,buttonAlign : 'center'
		,columnWidth : .3
		,labelWidth: 100
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.ANAAStartTime
		]
	});
	obj.Panel1=new Ext.Panel({ 
		id : 'Panel1'
		,buttonAlign : 'center'
		,style:'margin-bottom:10px;'
		,layout : 'column'
		,labelAlign : 'right'
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
			
		]
	});
	
	obj.ANAAEndDate=new Ext.form.DateField({
	    id : 'ANAAEndDate'
		,value : new Date().add(Date.DAY,+3)
		,format : dateFormat
		,fieldLabel : '��Ȩ��������'
		,width:165
		,labelSeparator: ''
		,anchor : '100%'
	});
	
	obj.Panel21 = new Ext.Panel({ 
		id : 'Panel21'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth: 100
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.ANAAEndDate
		]
	});
	obj.ANAAEndTime = new Ext.form.TimeField({
	    id : 'ANAAEndTime'
		,format : 'H:i'
		,fieldLabel : '��Ȩ����ʱ��'
		,width:165
		,labelSeparator: ''
		,anchor : '100%'
	});
	obj.Panel22 = new Ext.Panel({ 
		id : 'Panel22'
		,buttonAlign : 'center'
		,columnWidth : .1
		,labelWidth: 100
		,layout : 'form'
		,labelAlign : 'right'
		,items:[
			obj.ANAAEndTime
		]
	});
	obj.RowId = new Ext.form.TextField({
	    id : 'RowId'
		,hidden: true
	});
	obj.hiddenPanel=new Ext.Panel({
	    id : 'hiddenPanel'
	    ,buttonAlign : 'center'
	    ,region : 'south'
	    ,hidden : true
	    ,items:[
	    	obj.RowId	
	    ]
    });
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,style:'margin-bottom:10px;'
		,layout : 'column'
		,labelAlign : 'right'
		,items:[
			obj.Panel21
			,obj.Panel22
			,obj.hiddenPanel
		]
	});
	obj.conditionPanel = new Ext.Panel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.Panel1
			,obj.Panel2
		]
	});
	obj.saveButton= new Ext.Button({
		id : 'saveButton'
		,width:100
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.deleteButton= new Ext.Button({
		id : 'deleteButton'
		,width:100
		,iconCls : 'icon-close'
		,text : 'ɾ��'
	});
	
	obj.savePanel = new Ext.Panel({
		id : 'savePanel'
		,buttonAlign : 'right'
		,style:'margin-left:15px;margin-bottom:10px;'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.saveButton
		]
	});
	obj.deletePanel = new Ext.Panel({
		id : 'deletePanel'
		,buttonAlign : 'center'
		,style:'margin-left:15px;margin-bottom:10px;'		
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.deleteButton
		]
	});
	obj.buttonPanel = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,layout : 'form'
		,frame : false
		,items:[
			obj.savePanel
			,obj.deletePanel
		]
	});
	obj.DHCANAduitAccredit = new Ext.Panel({
		id : 'DHCANAduitAccredit'
		,region:'north'
		,height : 100
		,title : '��������Ȩ��Ϣά��'
		,layout : 'column'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			,obj.buttonPanel
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
			idProperty: 'ANAARowId'
		}, 
	    [
			{name: 'ANAARowId', mapping : 'ANAARowId'}
			,{name: 'ANAACtlocId', mapping: 'ANAACtlocId'}
			,{name: 'ANAACtlocDesc', mapping: 'ANAACtlocDesc'}
			,{name: 'ANAACtpcpId', mapping: 'ANAACtpcpId'}
			,{name: 'ANAACtpcpDesc', mapping: 'ANAACtpcpDesc'}
			,{name: 'ANAAStartDT', mapping: 'ANAAStartDT'}
			,{name: 'ANAAEndDT', mapping: 'ANAAEndDT'}
			,{name: 'ANAACreateUserId', mapping: 'ANAACreateUserId'}
			,{name: 'ANAACreateUserName', mapping: 'ANAACreateUserName'}
			,{name: 'ANAACreateDT', mapping: 'ANAACreateDT'}

		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true            
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{
				header: 'ϵͳ��'
				,width: 80
				,dataIndex: 'ANAARowId'
				,sortable: true
				}
        	,{
		        header: '��Ȩ����Id'
				,width: 60
				,dataIndex: 'ANAACtlocId'
				,sortable: true
				,hidden:true
					
			}
			,{
				header: '��Ȩ����'
				, width: 220
				, dataIndex: 'ANAACtlocDesc'
				, sortable: true
			}
			,{
				header: '��Ȩҽ��Id'
				, width: 60
				, dataIndex: 'ANAACtpcpId'
				, sortable: true
				,hidden:true
			}
			,{
				header: '��Ȩҽ��'
				, width: 120
				, dataIndex: 'ANAACtpcpDesc'
				, sortable: true
			}
			,{
				header: '��Ȩ��ʼʱ��'
				, width: 200
				, dataIndex: 'ANAAStartDT'
				, sortable: true
			}
			,{
				header: '��Ȩ����ʱ��'
				, width: 200
				, dataIndex: 'ANAAEndDT'
				, sortable: true
			}
			,{
				header: '������Ȩҽ��Id'
				, width: 60
				, dataIndex: 'ANAACreateUserId'
				, sortable: true
				,hidden:true
			}
			,{
				header: '������Ȩҽ��'
				, width: 120
				, dataIndex: 'ANAACreateUserName'
				, sortable: true
			}
			,{
				header: '��������'
				, width: 200
				, dataIndex: 'ANAACreateDT'
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
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANAduitAccredit';
		param.QueryName = 'FindAduitAccreditList';
		param.Arg1= obj.ANAACtloc.getValue();
		param.ArgCnt = 1;
	});
	//obj.retGridPanelStore.load({});
	
	obj.DHCANAADisplay = new Ext.Panel({
		id : 'DHCANAADisplay'
		,title : '��Ч��Ȩ��Ϣ�б�'
		,iconCls : 'icon-table'
		,region:'center'
		,layout:'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.retGridPanel
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout:"border"
		,items:[
			obj.DHCANAduitAccredit
			,obj.DHCANAADisplay
		]
	});
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.saveButton.on("click", obj.saveButton_click, obj);
	obj.deleteButton.on("click", obj.deleteButton_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}
//dyl+20171031+��־��ѯ
var dateFormat=tkMakeServerCall("web.DHCClinicCom","GetDateFormat");
 function InitViewScreen()
{
	var obj = new Object();
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : dateFormat
		,width:110
		,fieldLabel : '��ʼ����'
		,labelSeparator: ''	//�Ժ����ͳһ��label�����ð��ȥ��
		,anchor : '98%'
	});
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,width:110
		,format : dateFormat
		,fieldLabel : '��������'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth : 80
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
	});
		obj.LogValueStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.LogValueStore = new Ext.data.Store({
		proxy: obj.LogValueStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tClclogId'
		}, 
		[
		     {name: 'tClclogId', mapping: 'tClclogId'}
			,{name: 'tClclogDesc', mapping: 'tClclogDesc'}
		])
	});	

	obj.LogValue = new Ext.form.ComboBox({
		id : 'LogValue'
		,store:obj.LogValueStore
		,minChars:1	
		,displayField:'tClclogDesc'	
		,fieldLabel : '��־��Ŀ'
		,valueField : 'tClclogId'
		,triggerAction : 'all'
		,anchor : '90%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});	
	obj.UserIp = new Ext.form.TextField({
		id : 'UserIp'
		,fieldLabel : '�û�IP��ַ'
		,labelSeparator: ''
		,anchor : '90%'
	});	
	
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth : 100
		,layout : 'form'
		,items:[
			obj.LogValue
			,obj.UserIp
		]
	});

	obj.OriginValueStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.OriginValueStore = new Ext.data.Store({
		proxy: obj.OriginValueStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
		     {name: 'tValue', mapping: 'tValue'}
			,{name: 'tValueDesc', mapping: 'tValueDesc'}
		])
	});	
	obj.OriginValue = new Ext.form.ComboBox({
		id : 'OriginValue'
		,store:obj.OriginValueStore
		,minChars:1	
		,displayField:'tValueDesc'	
		,fieldLabel : '��ʼֵ'
		,valueField : 'tValue'
		,triggerAction : 'all'
		,anchor : '90%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});	
	obj.EditValueStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.EditValueStore = new Ext.data.Store({
		proxy: obj.EditValueStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tValue'
		}, 
		[
		     {name: 'tValue', mapping: 'tValue'}
			,{name: 'tValueDesc', mapping: 'tValueDesc'}
		])
	});	
	obj.EditValue = new Ext.form.ComboBox({
		id : 'EditValue'
		,store:obj.EditValueStore
		,minChars:1	
		,displayField:'tValueDesc'	
		,fieldLabel : '�޸�ֵ'
		,valueField : 'tValue'
		,triggerAction : 'all'
		,anchor : '90%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth : 100
		,layout : 'form'
		,items:[
			obj.OriginValue
			,obj.EditValue
		]
	});
	
	
	obj.OriginValueStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'LookupCLCLogValue';
		param.Arg1 = obj.LogValue.getValue();
		param.ArgCnt = 1;
	});
	obj.OriginValueStore.load({});
	obj.LogValueStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'LookupCLCLog';
		param.ArgCnt = 0;
	});
	obj.LogValueStore.load({});
	obj.EditValueStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'LookupCLCLogValue';
		param.Arg1 = obj.LogValue.getValue();
		param.ArgCnt = 1;
	});
	obj.EditValueStore.load({});
	
	
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		//,hidden:true
		,anchor : '95%'
		,labelSeparator: ''
	});	
	
	
	
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,width:86
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,width:86
		,iconCls : 'icon-print'
		,style: 'margin-Top:3px;'
		,text : '��ӡ'
	});
	
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,style: 'margin-left:20px;'
		,layout : 'form'
		,items:[
		    obj.btnSch
		    //,obj.btnPrint
		]

	});
	

	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.addpanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 60
		,width:800
		,region : 'north'
		,layout : 'form'
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
			idProperty: 'tCllogId'
		}, 
	    [
	    
			{name: 'tCllogId', mapping : 'tCllogId'}
			,{name: 'tClclogId', mapping: 'tClclogId'}
			,{name: 'tClclogDesc', mapping: 'tClclogDesc'}
			,{name: 'tLogRecordId', mapping: 'tLogRecordId'}
			,{name: 'tPreValue', mapping: 'tPreValue'}
			,{name: 'tPreNote', mapping: 'tPreNote'}
			,{name: 'tPostValue', mapping: 'tPostValue'}
			,{name: 'tPostNote', mapping: 'tPostNote'}
			,{name: 'tUpdateUser', mapping: 'tUpdateUser'}
			,{name: 'tPostQT', mapping: 'tPostQT'}
			,{name: 'tPostYY', mapping: 'tPostYY'}
			,{name: 'tMedCareNo', mapping: 'tMedCareNo'}
			,{name: 'tPatname', mapping: 'tPatname'}
			,{name: 'tUpdateDate', mapping: 'tUpdateDate'}
			,{name: 'tUpdateTime', mapping: 'tUpdateTime'}
			,{name: 'tUpdateTcpip', mapping: 'tUpdateTcpip'}
			,{name: 'tLocdes', mapping: 'tLocdes'}
			,{name: 'tOPDOC', mapping: 'tOPDOC'}
			,{name: 'tOpRoom', mapping: 'tOpRoom'}
			,{name: 'tOpaSeq', mapping: 'tOpaSeq'}
			,{name: 'topdate', mapping: 'topdate'}
			,{name: 'tCllogIfReceive', mapping: 'tCllogIfReceive'}
			,{name: 'opStat', mapping: 'opStat'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			//tCllogId,tClclogId,tClclogDesc,tLogRecordId,tPreValue
	    //,tPreNote,tPostValue,tPostNote,tUpdateUser,tPostQT
	    //,tPostYY,tMedCareNo,tPatname,tUpdateDate,tUpdateTime
	    //,tUpdateTcpip,tLocdes,tOPDOC,tOpRoom,tOpaSeq
	    //,topdate,tCllogIfReceive,opStat
			{header: 'tCllogId',width: 60,dataIndex: 'tCllogId',sortable: true}
			,{header: 'tClclogId',width: 120,dataIndex: 'tClclogId',sortable: true}
        	,{header: '��־��Ŀ',width: 120,dataIndex: 'tClclogDesc',sortable: true}
			,{header: '��¼Id',width: 50,dataIndex: 'tLogRecordId',sortable: true}
			,{header: '��ǰֵ',width: 50,dataIndex: 'tPreValue',sortable: true}
			,{header: '��ǰ˵��',width: 50,dataIndex: 'tPreNote',sortable: true}
			,{header: '�ĺ�ֵ',width: 50,dataIndex: 'tPostValue',sortable: true}
			,{header: '�ĺ�˵��',width: 50,dataIndex: 'tPostNote',sortable: true}
			,{header: '�����û�',width: 50,dataIndex: 'tUpdateUser',sortable: true}
			,{header: 'tPostQT',width: 50,dataIndex: 'tPostQT',sortable: true}
			,{header: 'tPostYY',width: 50,dataIndex: 'tPostYY',sortable: true}
			,{header: '������',width: 50,dataIndex: 'tMedCareNo',sortable: true}
			,{header: '��������',width: 50,dataIndex: 'tPatname',sortable: true}
			,{header: 'tUpdateDate',width: 50,dataIndex: 'tUpdateDate',sortable: true}
			,{header: 'tUpdateTime',width: 50,dataIndex: 'tUpdateTime',sortable: true}
			,{header: 'IP��ַ',width: 50,dataIndex: 'tUpdateTcpip',sortable: true}
			,{header: '����',width: 50,dataIndex: 'tLocdes',sortable: true}
			,{header: '����ҽ��',width: 50,dataIndex: 'tOPDOC',sortable: true}
			,{header: '������',width: 50,dataIndex: 'tOpRoom',sortable: true}
			,{header: '̨��',width: 50,dataIndex: 'tOpaSeq',sortable: true}
			,{header: '����ʱ��',width: 50,dataIndex: 'topdate',sortable: true}
			,{header: 'tCllogIfReceive',width: 50,dataIndex: 'tCllogIfReceive',sortable: true}
			,{header: '����״̬',width: 50,dataIndex: 'opStat',sortable: true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,title : '��־��ѯ���'
		,iconCls : 'icon-result'
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
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLLog';
		param.QueryName = 'FindCLLog';
		param.Arg1 = obj.LogValue.getValue();	//Id
		param.Arg2 = obj.dateFrm.getRawValue();	//��ʼ
		param.Arg3 = obj.dateTo.getRawValue();	//����
		param.Arg4 = "";	//��¼Id
		param.Arg5 = obj.UserIp.getValue();
		param.Arg6 = obj.OriginValue.getValue();
		param.Arg7 = obj.EditValue.getValue();
		param.ArgCnt = 7;
	});
	obj.retGridPanelStore.load({});
	
	
	obj.AnOpReport = new Ext.Panel({
		id : 'AnOpReport'
		,buttonAlign : 'center'
		,height : 200
		,width:400
		,title : '��־��ѯ'
		,region : 'center'
		,layout : 'border'
		,iconCls : 'icon-find'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.retGridPanel
		]
	});
	
	
	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.AnOpReport
		]
	}); 
	
	
	InitViewScreenEvent(obj);
	
    obj.btnSch.on("click", obj.btnSch_click, obj);
    obj.btnPrint.on("click", obj.btnPrint_click, obj);
    obj.LogValue.on("select", obj.LogValue_select, obj);
    obj.LoadEvent(arguments);    
    return obj;	
}
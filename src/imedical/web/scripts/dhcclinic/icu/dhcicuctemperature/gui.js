//20180412 ͬ�����µ�����
function InitViewScreen(){
	var obj = new Object();
	
	//RowId
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
    
    //����ҽ��
    function selcomord(v, record) { 
         return record.Desc+" || "+record.ID; 
    }
    obj.RecordItemstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.RecordItemstore = new Ext.data.Store({
		proxy: obj.RecordItemstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		    ,{ name: 'selecttext', convert: selcomord}
		])
	});
	obj.RecordItem = new Ext.form.ComboBox({
		id : 'RecordItem'
		,store:obj.RecordItemstore
		,minChars:1
		,displayField:'selecttext'
		,fieldLabel : '����ҽ��'
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	//�۲���
	obj.ObserveItemstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ObserveItemstore = new Ext.data.Store({
		proxy: obj.ObserveItemstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'RowId', mapping: 'RowId'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.ObserveItem = new Ext.form.ComboBox({
		id : 'ObserveItem'
		,store:obj.ObserveItemstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '�۲���'
		,valueField : 'RowId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	//ʱ������
	obj.DayFactor=new Ext.form.TextField({
		id : 'DayFactor'
		,fieldLabel : 'ʱ������'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	//��ʼʱ��
	obj.StartTime=new Ext.form.TimeField({
	    id : 'StartTime'
		,format : 'H:i'
		,increment : 5
		,labelSeparator: ''
		,fieldLabel : '��ʼʱ��'
		,anchor : '95%'
	});
	
	//ʱ����
	obj.ValidSpan=new Ext.form.TimeField({
	    id : 'ValidSpan'
		,format : 'H:i'
		,increment : 5
		,labelSeparator: ''
		,fieldLabel : 'ʱ����'
		,anchor : '95%'
	});
	
	//����
	var data = [
		['R','�໤����'],
		['A','��֢����']
	]
	obj.TypestoreProxy=data;
	obj.Typestore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'Code'}
			,{name: 'Desc'}
		])
	});
	obj.Type=new Ext.form.ComboBox({
		id : 'Type'
		,store : obj.Typestore
		,minChars : 1
		,fieldLabel : '����'
		,triggerAction : 'all'
		,displayField : 'Desc'
		,anchor : '95%'
		,valueField : 'Code'
	});
	
	//�쳣ֵ
	obj.UpperThreshold=new Ext.form.TextField({
		id : 'UpperThreshold'
		,fieldLabel : '�쳣ֵ'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	//�쳣����ʱ����
	obj.Interval=new Ext.form.TextField({
		id : 'Interval'
		,fieldLabel : '�쳣����ʱ����'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//����ֵ����ʱ��
	obj.SummaryInsertTime=new Ext.form.TimeField({
	    id : 'SummaryInsertTime'
		,format : 'H:i'
		,increment : 5
		,labelSeparator: ''
		,fieldLabel : '����ֵ����ʱ��'
		,anchor : '95%'
	});
	
	//����
	obj.CtlocstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.Ctlocstore = new Ext.data.Store({
		proxy: obj.CtlocstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			,{name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
		])
	});
	obj.Ctloc=new Ext.form.ComboBox({
		id : 'Ctloc'
		,store:obj.Ctlocstore
		,minChars:1
		,displayField:'ctlocDesc'
		,fieldLabel : '����'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	//����
	obj.Strategy=new Ext.form.TextField({
		id : 'Strategy'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	});
	//���ó���ҽ��
	obj.SpareIcucriCode = new Ext.form.ComboBox({
		id : 'SpareIcucriCode'
		,store:obj.RecordItemstore
		,minChars:1
		,displayField:'selecttext'
		,fieldLabel : '���ó���ҽ��'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 80
		,layout : 'form'
		,items:[
			obj.RecordItem
			,obj.ValidSpan
			,obj.SummaryInsertTime
		]
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.ObserveItem
			,obj.Type
			,obj.Ctloc
			
		]
	});

	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.DayFactor
			,obj.UpperThreshold
			,obj.Strategy
		]
	});


	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 120
		,layout : 'form'
		,items:[
			obj.StartTime
			,obj.Interval
			,obj.SpareIcucriCode
			
		]
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:80
		,text : '���'
		,style:'margin-bottom:5px;'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-update'
		,width:80
		,text : '�޸�'
		,style:'margin-bottom:5px;'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,width:80
		,text : 'ɾ��'
	});
	
	obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,columnWidth : .12
		,columnHeight:30
		,style:'margin-left:20px'
		,layout : 'form'
        ,items:[
        	obj.addbutton
        	,obj.updatebutton
            ,obj.deletebutton
       ]
	});
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.keypanel2
		]
	});


	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 140
		,title : '���µ�ͬ����Ŀ����'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,iconCls : 'icon-manage'
		,items:[
			obj.conditionPanel
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
			{name: 'RowId', mapping: 'RowId'}
			,{name: 'RecordItemId', mapping: 'RecordItemId'}
			,{name: 'ObserveItemId', mapping: 'ObserveItemId'}
			,{name: 'ObserveItem', mapping: 'ObserveItem'}
			,{name: 'DayFactor', mapping: 'DayFactor'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'ValidSpan', mapping: 'ValidSpan'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'UpperThreshold', mapping: 'UpperThreshold'}
			,{name: 'Interval', mapping: 'Interval'}
			,{name: 'SummaryInsertTime', mapping: 'SummaryInsertTime'}
			,{name: 'CtlocId', mapping: 'CtlocId'}
			,{name: 'Strategy', mapping: 'Strategy'}
			,{name: 'SpareIcucriCode', mapping: 'SpareIcucriCode'}
		])
	});
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer(),
			{ dataIndex: "RowId", header: "ID", width: 60, sortable: true },
            { dataIndex: "RecordItemId", header: "����ҽ������", width: 120, sortable: true },
           	{ dataIndex: "ObserveItemId", header: "�۲���Id", width: 60, sortable: true },
           	{ dataIndex: "ObserveItem", header: "�۲���", width: 100, sortable: true },
           	{ dataIndex: "DayFactor", header: "ʱ������", width: 60, sortable: true},
           	{ dataIndex: "StartTime", header: "��ʼʱ��", width: 100, sortable: true },
           	{ dataIndex: "ValidSpan", header: "ʱ����", width: 100, sortable: true },
           	{ dataIndex: "Type", header: "����", width: 100, sortable: true, formatter:function(value,index,row){
	           	if (value==='R') return '�໤����';
	           	if (value==='A') return '��֢����';
	           	return '';
	           	}
            },
          	{ dataIndex: "UpperThreshold", header: "�쳣ֵ", width: 60, sortable: true },
           	{ dataIndex: "Interval", header: "�쳣����ʱ����", width: 100, sortable: true },
           	{ dataIndex: "SummaryInsertTime", header: "���ܲ���ʱ��", width: 100, sortable: true },
           	{ dataIndex: "CtlocId", header: "����ID", width: 100, sortable: true },
           	{ dataIndex: "Strategy", header: "����", width: 100, sortable: true },
           	{ dataIndex: "SpareIcucriCode", header: "���ó���ҽ������", width: 100, sortable: true }
		]
		});
	
   
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
		,title : '���µ�ͬ����Ŀ���ý��'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,iconCls : 'icon-result'
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
			obj.functionPanel
			,obj.resultPanel
		]
	});
	
	obj.RecordItemstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindANCComOrd';
		param.Arg1='';
		param.Arg2=obj.RecordItem.getValue();
		param.Arg3='Y';
		param.ArgCnt = 3;
	});
	obj.RecordItemstore.load({});

	obj.ObserveItemstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCTemperature';
		param.QueryName = 'FindObserveItem';
		param.ArgCnt = 0;
	});
	obj.ObserveItemstore.load({});
	
	obj.CtlocstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1='';
		param.Arg2='ICU';
		param.ArgCnt = 2;
	});
	obj.Ctlocstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCTemperature';
		param.QueryName = 'FindICUCTemper';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});

	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}
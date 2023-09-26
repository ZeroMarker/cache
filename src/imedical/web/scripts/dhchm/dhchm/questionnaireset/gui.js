function InitViewportQN(){
	var obj = new Object();
	obj.GridPanelQNStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelQNStore = new Ext.data.Store({
		proxy: obj.GridPanelQNStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'QNID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'QNID', mapping: 'QNID'}
			,{name: 'QCode', mapping: 'QCode'}
			,{name: 'QDesc', mapping: 'QDesc'}
			,{name: 'QType', mapping: 'QType'}
			,{name: 'QActive', mapping: 'QActive'}
			,{name: 'QRemark', mapping: 'QRemark'}
		])
	});
	obj.GridPanelQNCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanelQN = new Ext.grid.GridPanel({
		id : 'GridPanelQN'
		,store : obj.GridPanelQNStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: 'ID', hidden:true, dataIndex: 'QNID', sortable: true}
			,{header: '����', width: 70, dataIndex: 'QCode', sortable: true}
			,{header: '����', width: 80, dataIndex: 'QDesc', sortable: true}
			,{header: '����', width: 80, dataIndex: 'QType', sortable: true,
				 renderer: function(value)
				{
					if(value == 'HM'){return '��������'}
					if(value == 'CRM'){return '���'}
				}}
			,{header: '����', width: 50, dataIndex: 'QActive', sortable: true,
				renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
        	}}
			,{header: '��ע', width: 80, dataIndex: 'QRemark', sortable: true}
		]});
	obj.QCode = new Ext.form.TextField({
		id : 'QCode'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.QDesc = new Ext.form.TextField({
		id : 'QDesc'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
obj.TypeStore = new Ext.data.SimpleStore({
        fields: ['TypeCode', 'TypeDesc'],
        data: [['HM', '��������'], ['CRM', '���']]
    });

	obj.QType = new Ext.form.ComboBox({
		id : 'QType'
		,minChars : 1
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,triggerAction : 'all'
		,store: obj.TypeStore
    	,mode: 'local'
    	,valueField: 'TypeCode'
    	,displayField: 'TypeDesc'
    	,allowBlank : false
});
	obj.QActive = new Ext.form.Checkbox({
		id : 'QActive'
		,fieldLabel : '����'
		,checked : true
});
	obj.QRemark = new Ext.form.TextArea({
		id : 'QRemark'
		,fieldLabel : '��ע'
});
	obj.QNID = new Ext.form.TextField({
		id : 'QNID'
		,hidden : true
});
	obj.QNSave = new Ext.Button({
		id : 'QNSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.QNClear = new Ext.Button({
		id : 'QNClear'
		,iconCls : 'icon-new'
		,text : '���'
});
	obj.FormPanelQN = new Ext.form.FormPanel({
		id : 'FormPanelQN'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,defaults : {anchor:'90%'}
		,height : 210
		,region : 'north'
		,items:[
			obj.QCode
			,obj.QDesc
			,obj.QType
			,obj.QActive
			,obj.QRemark
			,obj.QNID
		]
	,	buttons:[
			obj.QNSave
			,obj.QNClear
		]
	});
	obj.PanelQN1 = new Ext.Panel({
		id : 'PanelQN1'
		,buttonAlign : 'center'
		,width : 390
		,title : '�ʾ�ά��'
		,region : 'west'
		,layout : 'border'
		,frame : true
		,collapsible : true
		,items:[
			obj.GridPanelQN
			,obj.FormPanelQN
		]
	});
	obj.QSCode = new Ext.form.TextField({
		id : 'QSCode'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.QSDesc = new Ext.form.TextField({
		id : 'QSDesc'
		,fieldLabel : ExtToolSetting.RedStarString+'����'
		,allowBlank : false
});
	obj.QSOrder = new Ext.form.NumberField({
		id : 'QSOrder'
		,fieldLabel : '˳��'
});
	obj.QSRemark = new Ext.form.TextField({
		id : 'QSRemark'
		,fieldLabel : '��ע'
});
	obj.QSActive = new Ext.form.Checkbox({
		id : 'QSActive'
		,fieldLabel : '����'
		,checked : true
});
	obj.QSParRef = new Ext.form.TextField({
		id : 'QSParRef'
		,hidden : true
});
	obj.QSID = new Ext.form.TextField({
		id : 'QSID'
		,hidden : true
});
	obj.QSSave = new Ext.Button({
		id : 'QSSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.QSClear = new Ext.Button({
		id : 'QSClear'
		,iconCls : 'icon-new'
		,text : '���'
});
	obj.FormPanelQS = new Ext.form.FormPanel({
		id : 'FormPanelQS'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,defaults : {anchor:'90%'}
		,height : 180
		,region : 'north'
		,items:[
			obj.QSCode
			,obj.QSDesc
			,obj.QSOrder
			,obj.QSRemark
			,obj.QSActive
			,obj.QSParRef
			,obj.QSID
		]
	,	buttons:[
			obj.QSSave
			,obj.QSClear
		]
	});
	obj.GridPanelQSStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelQSStore = new Ext.data.Store({
		proxy: obj.GridPanelQSStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'QSID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'QSID', mapping: 'QSID'}
			,{name: 'QSCode', mapping: 'QSCode'}
			,{name: 'QSDesc', mapping: 'QSDesc'}
			,{name: 'QSOrder', mapping: 'QSOrder'}
			,{name: 'QSActive', mapping: 'QSActive'}
			,{name: 'QSRemark', mapping: 'QSRemark'}
		])
	});
	obj.GridPanelQSCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanelQS = new Ext.grid.GridPanel({
		id : 'GridPanelQS'
		,store : obj.GridPanelQSStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: 'ID', hidden:true, dataIndex: 'QSID', sortable: true}
			,{header: '����', width: 80, dataIndex: 'QSCode', sortable: true}
			,{header: '����', width: 80, dataIndex: 'QSDesc', sortable: true}
			,{header: '˳��', width: 60, dataIndex: 'QSOrder', sortable: true}
			,{header: '����', width: 80, dataIndex: 'QSActive', sortable: true,
				renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
        	}}
			,{header: '��ע', width: 100, dataIndex: 'QSRemark', sortable: true}
		]});
	obj.PanelQS1 = new Ext.Panel({
		id : 'PanelQS1'
		,buttonAlign : 'center'
		,region : 'center'
		,title : '����ά��'
		//,collapsible : true
		,layout : 'border'
		,frame : true
		,items:[
			obj.FormPanelQS
			,obj.GridPanelQS
		]
	});
	obj.SDLQuestionsDetailDRStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SDLQuestionsDetailDRStore = new Ext.data.Store({
		proxy: obj.SDLQuestionsDetailDRStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SDLQuestionsDetailDR'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SDLQuestionsDetailDR', mapping: 'SDLQuestionsDetailDR'}
			,{name: 'QDActive', mapping: 'QDActive'}
			,{name: 'QDCode', mapping: 'QDCode'}
			,{name: 'QDDesc', mapping: 'QDDesc'}
			,{name: 'QDElementNum', mapping: 'QDElementNum'}
			,{name: 'QDLinkCode', mapping: 'QDLinkCode'}
			,{name: 'QDNote', mapping: 'QDNote'}
			,{name: 'QDRemark', mapping: 'QDRemark'}
			,{name: 'QDRequired', mapping: 'QDRequired'}
			,{name: 'QDSex', mapping: 'QDSex'}
			,{name: 'QDType', mapping: 'QDType'}
			,{name: 'QDUnit', mapping: 'QDUnit'}
		])
	});
	obj.SDLQuestionsDetailDR = new Ext.form.ComboBox({
		id : 'SDLQuestionsDetailDR'
		,minChars : 1
		,store : obj.SDLQuestionsDetailDRStore
		,valueField : 'SDLQuestionsDetailDR'
		,fieldLabel : ExtToolSetting.RedStarString+'�ʾ�����'
		,displayField : 'QDDesc'
		,triggerAction : 'all'
		,allowBlank : false
		,mode: 'local'
});
	obj.SDLOrder = new Ext.form.NumberField({
		id : 'SDLOrder'
		,fieldLabel : '��ʾ˳��'
});
	obj.SDLActive = new Ext.form.Checkbox({
		id : 'SDLActive'
		,fieldLabel : '����'
		,checked : true
});
	obj.SDLParRef = new Ext.form.TextField({
		id : 'SDLParRef'
		,hidden : true
});
	obj.SDLID = new Ext.form.TextField({
		id : 'SDLID'
		,hidden : true
});
	obj.QDDesc = new Ext.form.TextField({
		id : 'QDDesc'
		,hidden : true
});
	obj.SDLSave = new Ext.Button({
		id : 'SDLSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.SDLClear = new Ext.Button({
		id : 'SDLClear'
		,iconCls : 'icon-new'
		,text : '���'
});
	obj.FormPanelSDL = new Ext.form.FormPanel({
		id : 'FormPanelSDL'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,defaults : {anchor:'90%'}
		,height : 140
		,region : 'north'
		,items:[
			obj.SDLQuestionsDetailDR
			,obj.SDLOrder
			,obj.SDLActive
			,obj.SDLParRef
			,obj.SDLID
			,obj.QDDesc
		]
	,	buttons:[
			obj.SDLSave
			,obj.SDLClear
		]
	});
	obj.GridPanelSDLStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelSDLStore = new Ext.data.Store({
		proxy: obj.GridPanelSDLStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SDLID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'SDLID', mapping: 'SDLID'}
			,{name: 'QDDesc', mapping: 'QDDesc'}
			,{name: 'SDLOrder', mapping: 'SDLOrder'}
			,{name: 'SDLActive', mapping: 'SDLActive'}
			,{name: 'SDLNote', mapping: 'SDLNote'}
			,{name: 'SDLQuestionsDetailDR', mapping: 'SDLQuestionsDetailDR'}
		])
	});
	obj.GridPanelSDLCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanelSDL = new Ext.grid.GridPanel({
		id : 'GridPanelSDL'
		,store : obj.GridPanelSDLStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			{header: 'ID', hidden:true, dataIndex: 'SDLID', sortable: true}
			,{header: '�ʾ�����', width: 100, dataIndex: 'QDDesc', sortable: true}
			,{header: '��ʾ˳��', width: 80, dataIndex: 'SDLOrder', sortable: true}
			,{header: '����', width: 80, dataIndex: 'SDLActive', sortable: true,
				renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
        	}}
			,{header: 'SDLNote', hidden:true, dataIndex: 'SDLNote', sortable: true}
			,{header: 'SDLQuestionsDetailDR', hidden:true, dataIndex: 'SDLQuestionsDetailDR', sortable: true}
		]});
	obj.PanelQS2 = new Ext.Panel({
		id : 'PanelQS2'
		,buttonAlign : 'center'
		,width : 270
		,region : 'east'
		,title : '��������'
		//,collapsible : true
		,layout : 'border'
		,frame : true
		,items:[
			obj.FormPanelSDL
			,obj.GridPanelSDL
		]
	});
	obj.PanelQS = new Ext.Panel({
		id : 'PanelQS'
		,buttonAlign : 'center'
		,hidden : true
		,title : '��������'
		,frame : true
		,layout : 'border'
		,items:[
			obj.PanelQS1
			,obj.PanelQS2
		]
	});

	obj.QEDLEvaluationDetailDRStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.QEDLEvaluationDetailDRStore = new Ext.data.Store({
		proxy: obj.QEDLEvaluationDetailDRStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'QEDLEvaluationDetailDR'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'QEDLEvaluationDetailDR', mapping: 'QEDLEvaluationDetailDR'}
			,{name: 'EDActive', mapping: 'EDActive'}
			,{name: 'EDCode', mapping: 'EDCode'}
			,{name: 'EDDataSource', mapping: 'EDDataSource'}
			,{name: 'EDDesc', mapping: 'EDDesc'}
			,{name: 'EDNote', mapping: 'EDNote'}
			,{name: 'EDSex', mapping: 'EDSex'}
			,{name: 'EDType', mapping: 'EDType'}
			,{name: 'EDUnit', mapping: 'EDUnit'}
		])
	});
	obj.QEDLEvaluationDetailDR = new Ext.form.ComboBox({
		id : 'QEDLEvaluationDetailDR'
		,store : obj.QEDLEvaluationDetailDRStore
		,minChars : 1
		,displayField : 'EDDesc'
		,fieldLabel : ExtToolSetting.RedStarString+'��������'
		,valueField : 'QEDLEvaluationDetailDR'
		,triggerAction : 'all'
		,allowBlank : false
		,mode: 'local'
});
	obj.QEDLOrder = new Ext.form.NumberField({
		id : 'QEDLOrder'
		,fieldLabel : '��ʾ˳��'
});
	obj.QEDLCalculateOrder = new Ext.form.NumberField({
		id : 'QEDLCalculateOrder'
		,fieldLabel : '����˳��'
});
	obj.QEDLActive = new Ext.form.Checkbox({
		id : 'QEDLActive'
		,fieldLabel : '����'
		,checked : true
});
	obj.EDLID = new Ext.form.TextField({
		id : 'EDLID'
		,hidden : true
});
	obj.EDDesc = new Ext.form.TextField({
		id : 'EDDesc'
		,hidden : true
});
	obj.QEDLParRef = new Ext.form.TextField({
		id : 'QEDLParRef'
		,hidden : true
});
	obj.EDLSave = new Ext.Button({
		id : 'EDLSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.EDLClear = new Ext.Button({
		id : 'EDLClear'
		,iconCls : 'icon-new'
		,text : '���'
});
	obj.FormPanelEDL = new Ext.form.FormPanel({
		id : 'FormPanelEDL'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,defaults : {anchor:'90%'}
		,height : 180
		//,collapsible : true
		,region : 'north'
		,items:[
			obj.QEDLEvaluationDetailDR
			,obj.QEDLOrder
			,obj.QEDLCalculateOrder
			,obj.QEDLActive
			,obj.EDLID
			,obj.QEDLParRef
			,obj.EDDesc
		]
	,	buttons:[
			obj.EDLSave
			,obj.EDLClear
		]
	});
	obj.GridPanelEDLStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelEDLStore = new Ext.data.Store({
		proxy: obj.GridPanelEDLStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'EDLID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'EDLID', mapping: 'EDLID'}
			,{name: 'EDDesc', mapping: 'EDDesc'}
			,{name: 'QEDLOrder', mapping: 'QEDLOrder'}
			,{name: 'QEDLCalculateOrder', mapping: 'QEDLCalculateOrder'}
			,{name: 'QEDLActive', mapping: 'QEDLActive'}
			,{name: 'QEDLEvaluationDetailDR', mapping: 'QEDLEvaluationDetailDR'}
			,{name: 'QEDLNote', mapping: 'QEDLNote'}
		])
	});
	obj.GridPanelEDLCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanelEDL = new Ext.grid.GridPanel({
		id : 'GridPanelEDL'
		,store : obj.GridPanelEDLStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			{header: 'ID', hidden:true, dataIndex: 'EDLID', sortable: true}
			,{header: '��������', width: 200, dataIndex: 'EDDesc', sortable: true}
			,{header: '��ʾ˳��', width: 100, dataIndex: 'QEDLOrder', sortable: true}
			,{header: '����˳��', width: 100, dataIndex: 'QEDLCalculateOrder', sortable: true}
			,{header: '����', width: 100, dataIndex: 'QEDLActive', sortable: true,
				renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="x-grid3-check-col' +
            (v == 'true' ? '-on' : '') +
            ' x-grid3-cc-' +
            this.id +
            '">&#160;</div>';
        	}}
			,{header: 'QEDLEvaluationDetailDR', hidden:true, dataIndex: 'QEDLEvaluationDetailDR', sortable: true}
			,{header: 'QEDLNote', hidden:true, dataIndex: 'QEDLNote', sortable: true}
		]});
	obj.PanelED = new Ext.Panel({
		id : 'PanelED'
		,buttonAlign : 'center'
		,title : '��������'
		,frame : true
		,layout : 'border'
		,items:[
			obj.FormPanelEDL
			,obj.GridPanelEDL
		]
	});
	obj.PanelQN2 = new Ext.TabPanel({
		id : 'PanelQN2'
		,buttonAlign : 'center'
		,region : 'center'
		,frame : true
		,items:[
			obj.PanelQS
			,obj.PanelED
		]
	});
	obj.PanelQN2.setActiveTab(obj.PanelQS);
	obj.QCode.focus(true,3);
	obj.ViewportQN = new Ext.Viewport({
		id : 'ViewportQN'
		,layout : 'border'
		,items:[
			obj.PanelQN1
			,obj.PanelQN2
		]
	});
	obj.GridPanelQNStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.QuestionnaireSet';
			param.QueryName = 'FindQuestion';
			param.ArgCnt = 0;
	});
	obj.GridPanelQNStore.load({});
	obj.GridPanelQSStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.QuestionnaireSet';
			param.QueryName = 'FindQSubject';
			param.Arg1 = obj.QSParRef.getValue();
			param.ArgCnt = 1;
	});
	obj.SDLQuestionsDetailDRStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.QuestionnaireSet';
			param.QueryName = 'FindQD';
			param.ArgCnt = 0;
	});
	obj.SDLQuestionsDetailDRStore.load({});
	obj.GridPanelSDLStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.QuestionnaireSet';
			param.QueryName = 'FindCSDLink';
			param.Arg1 = obj.SDLParRef.getValue();
			param.ArgCnt = 1;
	});
	obj.QEDLEvaluationDetailDRStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.QuestionnaireSet';
			param.QueryName = 'FindEvaDetail';
			param.ArgCnt = 0;
	});
	obj.QEDLEvaluationDetailDRStore.load({});
	obj.GridPanelEDLStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.QuestionnaireSet';
			param.QueryName = 'FindEDL';
			param.Arg1 = obj.QEDLParRef.getValue();
			param.ArgCnt = 1;
	});
	InitViewportQNEvent(obj);
	//�¼��������
	obj.GridPanelQN.on("rowclick", obj.GridPanelQN_rowclick, obj);
	obj.QNSave.on("click", obj.QNSave_click, obj);
	obj.QNClear.on("click", obj.QNClear_click, obj);
	obj.QSSave.on("click", obj.QSSave_click, obj);
	obj.QSClear.on("click", obj.QSClear_click, obj);
	obj.GridPanelQS.on("rowclick", obj.GridPanelQS_rowclick, obj);
	obj.SDLSave.on("click", obj.SDLSave_click, obj);
	obj.SDLClear.on("click", obj.SDLClear_click, obj);
	obj.GridPanelSDL.on("rowclick", obj.GridPanelSDL_rowclick, obj);
	obj.EDLSave.on("click", obj.EDLSave_click, obj);
	obj.EDLClear.on("click", obj.EDLClear_click, obj);
	obj.GridPanelEDL.on("rowclick", obj.GridPanelEDL_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}


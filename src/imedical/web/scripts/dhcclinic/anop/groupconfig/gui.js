//20170303+dyl
function InitViewport(){
	var obj = new Object();
	obj.comGroupStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comGroupStore = new Ext.data.Store({
		proxy: obj.comGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Group'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Group', mapping: 'Group'}
			,{name: 'ID', mapping: 'ID'}
		])
	});
	obj.comGroup = new Ext.form.ComboBox({
		id : 'comGroup'
		,valueField : 'ID'
		,minChars : 1
		,displayField : 'Group'
		,fieldLabel : '��ȫ��'
		,labelSeparator: ''
		,store : obj.comGroupStore
		,triggerAction : 'all'
		,anchor : '95%'
	});
	var data=[
		['MENU','�˵�'],
		['BUTTON','��ť'],
		['COLUMN','�ɼ�����']
	]
	obj.comTypeStoreProxy=data;
	obj.comTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.comType = new Ext.form.ComboBox({
		id : 'comType'
		,minChars : 1
		,fieldLabel : '����'
		,labelSeparator: ''
		,triggerAction : 'all'
		,store : obj.comTypeStore
		,displayField : 'desc'
		,anchor : '95%'
		,valueField : 'code'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.comGroup
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.comType
		]
	});
	
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '��ѯ'
		,iconCls : 'icon-find'
		,width:86
		,style:'margin-left:20px'
	});
	obj.btnNew = new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-insert'
		,style:'margin-left:20px'
		,width:86
		,text : '�½�'
	});
	obj.btnEdit = new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-updateSmall'
		,style:'margin-left:20px'
		,width:86
		,text : '�༭'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,style:'margin-left:20px'
		,width:86
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .5
		
		,layout : 'column'
		,items:[
		obj.btnSch
			,obj.btnNew
			,obj.btnEdit
			,obj.btnDelete]
	});
	
	obj.FormPanel = new Ext.form.FormPanel({
		id : 'FormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '��ȫ���������'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 65
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
		]
		,buttons:[
			
		]
	});
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
		}, 
		[
			{name: 'rowId', mapping: 'rowId'}
			,{name: 'groupId', mapping: 'groupId'}
			,{name: 'groupDesc', mapping: 'groupDesc'}
			,{name: 'name', mapping: 'name'}
			,{name: 'caption', mapping: 'caption'}
			,{name: 'typeCode', mapping: 'typeCode'}
			,{name: 'type', mapping: 'type'}
		])
	});
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,store : obj.GridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '˳��', width: 100, dataIndex: 'rowId', sortable: true}
			,{header: '��ȫ��', width: 100, dataIndex: 'groupDesc', sortable: true}
			,{header: '����', width: 100, dataIndex: 'type', sortable: true}
			,{header: '����', width: 150, dataIndex: 'name', sortable: true}
			,{header: '����', width: 100, dataIndex: 'caption', sortable: true}
		]});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.FormPanel
			,obj.GridPanel
		]
	});
	obj.comGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPArrange';
		param.QueryName = 'SSGROUP';
		param.Arg1 = obj.comGroup.getRawValue();
		param.ArgCnt = 1;
	});
	obj.comGroupStore.load({});
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPArrange';
		param.QueryName = 'GetGroupConfig';
		param.Arg1 = obj.comType.getValue();
		param.Arg2 = obj.comGroup.getValue();
		param.ArgCnt = 2;
	});
	obj.GridPanelStore.load({});
	InitViewportEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	return obj;
}
function InitwinScreen()
{
	var obj = new Object();
	obj.winTxtName = new Ext.form.TextField({
		id : 'winTxtName'
		,allowBlank : false
		,labelSeparator: ''
		,fieldLabel : 'Name'
		,anchor : '75%'
	});
	obj.winTxtRowId = new Ext.form.TextField({
		id : 'winTxtRowId'
		,allowBlank : false
		,fieldLabel : ''
		,anchor : '75%'
		,hidden : true
	});
	obj.winComGroupStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.winComGroupStore = new Ext.data.Store({
		proxy: obj.winComGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Group'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Group', mapping: 'Group'}
			,{name: 'ID', mapping: 'ID'}
		])
	});
	obj.winComGroup = new Ext.form.ComboBox({
		id : 'winComGroup'
		,valueField : 'ID'
		,minChars : 1
		,displayField : 'Group'
		,fieldLabel : '��ȫ��'
		,labelSeparator: ''
		,store : obj.winComGroupStore
		,triggerAction : 'all'
		,anchor : '75%'
	});
	var data=[
		['MENU','�˵�'],
		['BUTTON','��ť'],
		['COLUMN','�ɼ�����']
	]
	obj.winComTypeStoreProxy=data;
	obj.winComTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			 {name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.winComType = new Ext.form.ComboBox({
		id : 'winComType'
		,minChars : 1
		,fieldLabel : 'Ԫ������'
		,labelSeparator: ''
		,triggerAction : 'all'
		,store : obj.winComTypeStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '75%'
	});
	var data=[
		['1','1'],
		['2','2'],
		['3','3'],
		['4','4'],
		['5','5'],
		['6','6'],
		['7','7'],
		['8','8'],
		['9','9'],
		['10','10'],
		['11','11'],
		['12','12'],
		['13','13'],
		['14','14'],
		['15','15'],
		['16','16'],
		['17','17'],
		['18','18'],
		['19','19']
	]
	obj.winComRowIdStoreProxy=data;
	obj.winComRowIdStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			 {name: 'code'}
			,{name: 'desc'}
		])
	});
	/*obj.winComRowIdStore = new Ext.data.SimpleStore( {
         fields : [ 
		     {name: 'code'}
			,{name: 'desc'}
			]
			}
			)
    obj.winComRowIdStore.loadData(data)*/
	obj.winComRowIdStore.load({});
	obj.winComRowId = new Ext.form.ComboBox({
		id : 'winComRowId'
		,minChars : 1
		,fieldLabel : 'Ԫ��˳��'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.winComRowIdStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '75%'
	});
	var data=[
		['AppOper','��������','MENU'],
		['AppOperClinics','������������','MENU'],
		['AppIntervent','��������(����)','MENU'], 	
		['AlterDayOper','���ռ������޸�','MENU'],
		['AlterOper','�޸���������','MENU'],
		['ConfirmDayOper','���ռ�����ȷ��','MENU'],
		['UpdateOperClinics','�޸�������������','MENU'], 
		['UpdateOpIntervent','�޸���������(����)','MENU'], 	
		['ArrOper','��������','MENU'],
		['ANAuditDayOper','���ռ�������ǰ����','MENU'],
		['ANPostDayOperAcess','�ռ�����ָ�����','MENU'],
		['ANDayOutAcess','�ռ��Ժ����','MENU'],
		['ArrOperClinics','��������(����)','MENU'],
		['ArrOperIntervent','��������(����)','MENU'], 
		['DHCANOPNurseRecord','����������ӵ�','MENU'],
		['RefuseOper','����ֹͣ','MENU'],
		['CancelRef','����ֹͣ','MENU'],
		['ArrAn','������','MENU'],
		['AnConsent','����֪��ͬ����','MENU'],
		['PreOpAssessment','��ǰ����','MENU'],
		['MonAn','����໤','MENU'],
		['AnRecord','�����¼��ϸ','MENU'],
		['PACURecord','����ָ���','MENU'],
		['PostOpRecord','�������','MENU'],
		['AduitAccredit','��������Ȩ','MENU'],
		['ANOPCount','�������','MENU'],
		['RegOper','����Ǽ�','MENU'],
		['NotAppRegOper','��ԤԼ�����Ǽ�','MENU'],
		['AlterNotAppRegOper','��ԤԼ�����Ǽ��޸�','MENU'],
		['RegOperClinics','����Ǽ�(����)','MENU'],
		['PrintSQD','����������ӡ','MENU'],
		['PrintSSD','�Ű���ӡ','MENU'],
		['PrintMZD','������ӡ','MENU'],
			['AduitAccredit','��������Ȩ','MENU'],
		['PrintSSYYDBNZ','������(������)','MENU'],
		['PrintSSYYDTY','������(�ۿ�ͨ��)','MENU'],
		['PrintMZSSYYD','����ԤԼ����ӡ','MENU'],
		['OperTransfer','׼�˵�����','MENU'],
		['btnAnDocOrdered','��¼����ҽ��','BUTTON'],
		['btnClearRoom','���������','BUTTON'],
		['btnDirAudit','���������','BUTTON'],
		['btnReOperAudit','�������','BUTTON'],
		['ChangeOperPlanAudit','��������������','BUTTON'],
		['CheckRiskAssessment','������������','BUTTON'],
		['CheckSafetyInfo','������ȫ�˲�','BUTTON'],
		['OPControlledCost','�ɿسɱ�','BUTTON'],
		['btnCancelOper','ȡ������','BUTTON'],//20161214+dyl
		['btnOPNurseOrdered','�����Ʒ�','BUTTON'],//20161214+dyl
		['btnArrAnDocAuto','ͬ������ҽʦ','BUTTON'],//20161214+dyl
		['oproom','����','COLUMN'],
		['opordno','̨��','COLUMN'],
		['scrubnurse','��е��ʿ','COLUMN'],
		['circulnurse','Ѳ�ػ�ʿ','COLUMN'],
		['tNurseNote','��ʿ��ע','COLUMN'],
		['andoc','����ҽ��','COLUMN'],
		['tPacuBed','�ָ��Ҵ�λ','COLUMN'],
		['anmethod','������','COLUMN']
	]
	obj.winComCaptionStoreProxy=new Ext.data.MemoryProxy(data)
	obj.winComCaptionStore = new Ext.data.Store({
		proxy: obj.winComCaptionStoreProxy,
		reader: new Ext.data.ArrayReader({
		}, 
		[
			 {name: 'code'}
			,{name: 'desc'}
			,{name: 'type'}
		])
	});
	obj.winComCaptionStore.load({});
	obj.winComCaption = new Ext.form.ComboBox({
		id : 'winComCaption'
		,minChars : 1
		,fieldLabel : 'Caption'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.winComCaptionStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '75%'
	});
	var data=[
		['1','OpenWin'],
		['2','PrintSQD'],
		['3','PrintSSD'],
		['4','PrintMZD']
	]
	obj.winComHandlerStoreProxy=data;
	obj.winComHandlerStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.winComHandler = new Ext.form.ComboBox({
		id : 'winComHandler'
		,minChars : 1
		,fieldLabel : '���ú���'
		,labelSeparator: ''
		,triggerAction : 'all'
		,store : obj.winComHandlerStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '75%'
	});
	obj.winPanel3 = new Ext.Panel({
		id : 'winPanel3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[]
	});
	obj.winBtnSave = new Ext.Button({
		id : 'winBtnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.winBtnCancle = new Ext.Button({
		id : 'winBtnCancle'
		,iconCls : 'icon-cancel'
		,text : 'ȡ��'
	});
	obj.winPanel4 = new Ext.Panel({
		id : 'winPanel4'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:
		[
		    obj.winComGroup
			,obj.winComType
			,obj.winComRowId
			,obj.winComCaption
			,obj.winTxtName 
			,obj.winTxtRowId
		]
		,buttons:[
			obj.winBtnSave
			,obj.winBtnCancle
		]
	});
	obj.winPanel5 = new Ext.Panel({
		id : 'winPanel5'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[]
	});
	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,items:[
			obj.winPanel3
			,obj.winPanel4
			,obj.winPanel5
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 260
		,buttonAlign : 'center'
		,width : 330
		,title : '�༭'
		,iconCls:'icon-updateSmall'
		,modal : true
		,layout : 'fit'
		,items:[
			obj.winfPanel
		]
	});
	obj.storeProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.store = new Ext.data.Store({
		proxy: obj.storeProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
		}, 
		[
			{name: 'rowId', mapping: 'rowId'}
			,{name: 'groupId', mapping: 'groupId'}
			,{name: 'groupDesc', mapping: 'groupDesc'}
			,{name: 'name', mapping: 'name'}
			,{name: 'caption', mapping: 'caption'}
			,{name: 'typeCode', mapping: 'typeCode'}
			,{name: 'type', mapping: 'type'}
		])
	});
	obj.winComGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPArrange';
		param.QueryName = 'SSGROUP';
		param.Arg1 = obj.winComGroup.getRawValue();
		param.ArgCnt = 1;
	});
	obj.winComGroupStore.load({});
    obj.storeProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPArrange';
		param.QueryName = 'GetGroupConfig';
		param.Arg1 = obj.winComType.getValue();
		param.Arg2 = obj.winComGroup.getValue();
		param.ArgCnt = 2;
	});
	obj.store.load({});
	InitwinScreenEvent(obj);
	//�¼��������
	obj.winBtnSave.on("click",obj.winBtnSave_click,obj);
	obj.winComCaption.on("select",obj.winComCaption_select,obj);
	obj.winBtnCancle.on("click",obj.winBtnCancle_click,obj);
	obj.winComType.on("select",obj.winComType_select,obj);
	obj.winComGroup.on("select",obj.winComGroup_select,obj);
	obj.winComRowId.on("select",obj.winComRowId_select,obj);
	obj.LoadEvent(arguments);
	return obj;
}


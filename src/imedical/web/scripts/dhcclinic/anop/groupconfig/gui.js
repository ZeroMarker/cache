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
		,fieldLabel : '安全组'
		,labelSeparator: ''
		,store : obj.comGroupStore
		,triggerAction : 'all'
		,anchor : '95%'
	});
	var data=[
		['MENU','菜单'],
		['BUTTON','按钮'],
		['COLUMN','可激活列']
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
		,fieldLabel : '类型'
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
		,text : '查询'
		,iconCls : 'icon-find'
		,width:86
		,style:'margin-left:20px'
	});
	obj.btnNew = new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-insert'
		,style:'margin-left:20px'
		,width:86
		,text : '新建'
	});
	obj.btnEdit = new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-updateSmall'
		,style:'margin-left:20px'
		,width:86
		,text : '编辑'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,style:'margin-left:20px'
		,width:86
		,iconCls : 'icon-delete'
		,text : '删除'
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
		,title : '安全组配置相关'
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
			,{header: '顺序', width: 100, dataIndex: 'rowId', sortable: true}
			,{header: '安全组', width: 100, dataIndex: 'groupDesc', sortable: true}
			,{header: '类型', width: 100, dataIndex: 'type', sortable: true}
			,{header: '名称', width: 150, dataIndex: 'name', sortable: true}
			,{header: '标题', width: 100, dataIndex: 'caption', sortable: true}
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
	//事件处理代码
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
		,fieldLabel : '安全组'
		,labelSeparator: ''
		,store : obj.winComGroupStore
		,triggerAction : 'all'
		,anchor : '75%'
	});
	var data=[
		['MENU','菜单'],
		['BUTTON','按钮'],
		['COLUMN','可激活列']
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
		,fieldLabel : '元素类型'
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
		,fieldLabel : '元素顺序'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.winComRowIdStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor : '75%'
	});
	var data=[
		['AppOper','手术申请','MENU'],
		['AppOperClinics','门诊手术申请','MENU'],
		['AppIntervent','手术申请(介入)','MENU'], 	
		['AlterDayOper','拟日间手术修改','MENU'],
		['AlterOper','修改手术申请','MENU'],
		['ConfirmDayOper','拟日间申请确认','MENU'],
		['UpdateOperClinics','修改门诊手术申请','MENU'], 
		['UpdateOpIntervent','修改手术申请(介入)','MENU'], 	
		['ArrOper','手术安排','MENU'],
		['ANAuditDayOper','拟日间麻醉术前评估','MENU'],
		['ANPostDayOperAcess','日间麻醉恢复评估','MENU'],
		['ANDayOutAcess','日间出院评估','MENU'],
		['ArrOperClinics','手术安排(门诊)','MENU'],
		['ArrOperIntervent','手术安排(介入)','MENU'], 
		['DHCANOPNurseRecord','手术护理访视单','MENU'],
		['RefuseOper','手术停止','MENU'],
		['CancelRef','撤销停止','MENU'],
		['ArrAn','麻醉安排','MENU'],
		['AnConsent','麻醉知情同意书','MENU'],
		['PreOpAssessment','术前访视','MENU'],
		['MonAn','麻醉监护','MENU'],
		['AnRecord','麻醉记录明细','MENU'],
		['PACURecord','麻醉恢复室','MENU'],
		['PostOpRecord','术后随访','MENU'],
		['AduitAccredit','科主任授权','MENU'],
		['ANOPCount','手术清点','MENU'],
		['RegOper','术后登记','MENU'],
		['NotAppRegOper','非预约手术登记','MENU'],
		['AlterNotAppRegOper','非预约手术登记修改','MENU'],
		['RegOperClinics','术后登记(门诊)','MENU'],
		['PrintSQD','手术申请表打印','MENU'],
		['PrintSSD','排班表打印','MENU'],
		['PrintMZD','麻醉单打印','MENU'],
			['AduitAccredit','科主任授权','MENU'],
		['PrintSSYYDBNZ','手术条(白内障)','MENU'],
		['PrintSSYYDTY','手术条(眼科通用)','MENU'],
		['PrintMZSSYYD','门诊预约单打印','MENU'],
		['OperTransfer','准运单申请','MENU'],
		['btnAnDocOrdered','已录麻醉医嘱','BUTTON'],
		['btnClearRoom','清空手术间','BUTTON'],
		['btnDirAudit','科主任审核','BUTTON'],
		['btnReOperAudit','二次审核','BUTTON'],
		['ChangeOperPlanAudit','手术方案变更审核','BUTTON'],
		['CheckRiskAssessment','手术风险评估','BUTTON'],
		['CheckSafetyInfo','手术安全核查','BUTTON'],
		['OPControlledCost','可控成本','BUTTON'],
		['btnCancelOper','取消手术','BUTTON'],//20161214+dyl
		['btnOPNurseOrdered','手术计费','BUTTON'],//20161214+dyl
		['btnArrAnDocAuto','同步麻醉医师','BUTTON'],//20161214+dyl
		['oproom','术间','COLUMN'],
		['opordno','台次','COLUMN'],
		['scrubnurse','器械护士','COLUMN'],
		['circulnurse','巡回护士','COLUMN'],
		['tNurseNote','护士备注','COLUMN'],
		['andoc','麻醉医生','COLUMN'],
		['tPacuBed','恢复室床位','COLUMN'],
		['anmethod','麻醉方法','COLUMN']
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
		,fieldLabel : '调用函数'
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
		,text : '保存'
	});
	obj.winBtnCancle = new Ext.Button({
		id : 'winBtnCancle'
		,iconCls : 'icon-cancel'
		,text : '取消'
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
		,title : '编辑'
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
	//事件处理代码
	obj.winBtnSave.on("click",obj.winBtnSave_click,obj);
	obj.winComCaption.on("select",obj.winComCaption_select,obj);
	obj.winBtnCancle.on("click",obj.winBtnCancle_click,obj);
	obj.winComType.on("select",obj.winComType_select,obj);
	obj.winComGroup.on("select",obj.winComGroup_select,obj);
	obj.winComRowId.on("select",obj.winComRowId_select,obj);
	obj.LoadEvent(arguments);
	return obj;
}


///PDA��������ʾ����
///LMM
///2017-03-17

var selId="";

///***ģ���������������***///
var modelData = new Array();
function ModelData(a, b) {
	modelData.push({
				modelCode : a,
				modelName : b
			});
}
//tkMakeServerCall("web.DHCNurPdaDepModelSet", "getModelList", 'ModelData');
var storeModel = new Ext.data.JsonStore({
			data : modelData,
			fields : ['modelCode', 'modelName']
		});
var modelField = new Ext.form.ComboBox({
			id : 'modelCom',
			hiddenName : 'model',
			width : 200,
			fieldLabel : 'ģ��',
			valueField : 'modelCode',
			displayField : 'modelName',
			allowBlank : true,
			mode : 'local',
			anchor : '100%',
			store:new Ext.data.JsonStore({
						url:"../csp/dhc.nurse.extjs.getdata.csp?className=web.DHCNurPdaDepModelSet&methodName=getModelListJson",
						root:"rowData",
						fields:['modelCode','modelName']
			})
		});		
///***end***///		
///***ģ���������������***///
var menuData = new Array();
function MenuData(a, b) {
	menuData.push({
				menuId : a,
				menuName : b
			});
}
//tkMakeServerCall("web.DHCNurPdaDepModelSet", "getMenuList", 'MenuData');
var storeMenu = new Ext.data.JsonStore({
			data : menuData,
			fields : ['menuId', 'menuName']
		});	
///***end***///	

function onReady() {
	var selectionModel = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false
	});
	//��߿����б�
	var locList = new Ext.grid.GridPanel({
		region: "center",
		layout: "fit",
		id: "locList",
		loadMask: true,
		
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function() {
					var record = Ext.getCmp("locList").getSelectionModel().getSelected();
					selId = record.get("modelCode");
					Ext.getCmp("modelList").setTitle("ģ������:" + record.get("modelName") );
					loadData(Ext.getCmp("modelList"), {
						className: "web.DHCNurPdaDepModelSet",
						methodName: "getItemSetByEmrCode",
						parameter1:selId
					})
				}
			}
		}),
		cm: new Ext.grid.ColumnModel({
			columns: [
				selectionModel, {
					header: "ģ������",
					dataIndex: "modelName",
					width: 160
				}, {
					header: "ģ��Code",
					dataIndex: "modelCode",
					width: 160
				}, {
					header: "modelID",
					dataIndex: "modelID",
					width: 80
				}
			]
		}),
		
		store: createStore({
			className: "web.DHCNurPdaDepModelSet",
			methodName: "getModelJson"
		}, ["modelName","modelCode","modelSort","modelCanFlag","modelID"]),
		
		tbar: [	
			
			new Ext.Button({
				id: "finddataButton",
				text: "��ѯ",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						Ext.getCmp("locList").getStore().removeAll();
						loadData(Ext.getCmp("locList"), {
							className: "web.DHCNurPdaDepModelSet",
							methodName: "getModelJson"
						});
					}
				}
				
			})
		]
	});
	locList.getStore().load();

	//�ұ�ģ���б�
	var modelList = new Ext.grid.GridPanel({
		layout: "fit",
		id: "modelList",
		cm: new Ext.grid.ColumnModel([{
			header: "ģ������",
			dataIndex: "emrCode",
			width: 170
		}, {
			header: "Ԫ��CODE",
			dataIndex: "itemCode",
			width: 300
		}, {
			header: "����Ԫ��CODE",
			dataIndex: "linkCode",
			width: 300
		}, {
			header: "��������",
			dataIndex: "linkType",
			width: 300
		}, {
			header: "����˵��",
			dataIndex: "linkNote",
			width: 300
		}, {
			header: "ID",
			dataIndex: "setId",
			width: 300
		}]),
		tbar: [
			new Ext.Button({
				id: "addButton",
				text: "���",
				icon: '../images/uiimages/edit_add.png',
				listeners: {
					click: function() {
						if(selId==""){
								alert("��ѡ��һ������")
								return;
						}
						AddModelItemwindow.setTitle('���');
						AddModelItemwindow.show();
						WinForm.getForm().reset();
					 
					}
				}
			}),
			new Ext.Button({
				id: "changeButton",
				text: "�޸�",
				icon: '../images/uiimages/register.png',
				listeners: {
					click: function() { 
						updateModel();
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "delButton",
				text: "ɾ��",
				icon: '../images/uiimages/edit_remove.png',
				listeners: {
					click: function() {
							
						var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						if(subselobj){
							subsselloc=subselobj.get("setId")
						}
						if(subsselloc==""){
							alert("��ѡ��һ������")
							return;
						}
						var resStr = tkMakeServerCall("Nur.DHCNurPdaModelSet", "Delete", subsselloc);
						if(resStr!="0"){
							alert(resStr)
					    }
						var selobj = Ext.getCmp("locList").getSelectionModel().getSelected();
						if(selobj){
							selloc=selobj.get("LocId")
						}
						Ext.getCmp("modelList").getStore().removeAll();	
						loadData(Ext.getCmp("modelList"), {
							className: "web.DHCNurPdaDepModelSet",
							methodName: "getItemSetByEmrCode",
							parameter1: selId
						});
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "findButton",
				text: "��ѯ",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						Ext.getCmp("modelList").getStore().removeAll();					
						var modelCom = Ext.getCmp("modelCom").getValue();
						loadData(Ext.getCmp("modelList"), {
							className: "web.DHCNurPdaDepModelSet",
							methodName: "getItemSetByEmrCode",
							parameter1: selId
						});
					}
				}
			})
		],
		store: createStore({
			className: "web.DHCNurPdaDepModelSet",
			methodName: "getItemSetByEmrCode"
		}, ["emrCode", "itemCode", "linkCode", "linkType","linkNote","setId"]),
		viewConfig: {
			forceFit: true
		}
	});
modelList.on("rowdblclick", function(grid, rowIndex, e)
   { 
	  updateModel();				 
   });
	///***���ؽ���***///
	var viewPore = new Ext.Viewport({
		layout: "border",
		items: [{
			region: "west",
			layout: "fit",
			id: "westPanel",
			width: 400,
			items: [locList]

		}, {
			region: "center",
			layout: "fit",
			id: "centerPanel",
			items: [modelList]
		}]
	});	
	Ext.EventManager.onWindowResize(windowResize);
	///***end***///
}
function windowResize() {

}
/*
  store
*/
function loadData(obj, params) {
	obj.getStore().load({
		params: params
	})
}
function createStore(basePar, fields) {
		var store = new Ext.data.JsonStore({
			url: "../csp/dhc.nurse.extjs.getdata.csp",
			root: "rowData",
			fields: fields,
			baseParams: basePar
		});
		return store;
	}

///////�����ǽ���
////////////////////****************************************************************************************///////////////////////
/*
*ģ�嶨��
*/
function ModelDefine(){
	var columnDefine = new Ext.grid.ColumnModel([
		{header:"ģ������",width:90,dataIndex:"modelName",editor:new Ext.form.Field()},
		{header:"ģ��Code",width:90,dataIndex:"modelCode",editor:new Ext.form.Field()},
		{header: "��ʾ˳��",width:60,dataIndex:"modelSort",editor:new Ext.form.Field()},
    	{header: "�Ƿ�����",width:100,dataIndex:"modelCanFlag",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
		{header: "modelID",width:30,dataIndex:"modelID"},	
	]);
	var window =createModelPanelWin({
		winID:"modelDefineWin",
		gridID:"modelDefine",
		cm:columnDefine,
		fields:["modelName","modelCode","modelSort","modelCanFlag","modelID"],
		className:"web.DHCNurPdaDepModelSet",
		methodName:"getModelJson",
		forceFit:true,
		idField:"modelID"
	});
	window.show();
	}
/*
*��Ŀ¼����
*/
function MenuDefine()
{	
	var cloumnModel = new Ext.grid.ColumnModel([
	   
	    {header: "����",width:90,dataIndex:"menuName",editor:new Ext.form.Field()},
    	{header: "����",width:60,dataIndex:"menuCode",editor:new Ext.form.Field()},
		{header: "��ʾ˳��",width:60,dataIndex:"menuSort",editor:new Ext.form.Field()},
    	{header: "�Ƿ�����",width:100,dataIndex:"canFlag",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
		{header: "ID",width:20,dataIndex:"menuID"},
	]);
	
	var window =createEidtPanelWin({
		winID:"menuDefineWin",
		gridID:"menuDefine",
		cm:cloumnModel,
		fields:["menuName","menuCode","menuSort","canFlag","menuID"],
		className:"web.DHCNurPdaDepModelSet",
		methodName:"getMenuJson",
		forceFit:true,
		idField:"menuID"
	});
	window.show();
}

/**
*��������
*Note:�����༭����
*obj������
*/
//ģ������  lms
function createModelPanelWin(obj){
	if(Ext.getCmp(obj.winID))
	{
		Ext.getCmp(obj.winID).close();
	}
	var grid = new Ext.grid.EditorGridPanel({
		id:obj.gridID,
		layout:"fit",
		sm:new Ext.grid.RowSelectionModel({}),
		cm:obj.cm,
		viewConfig:{forceFit:obj.forceFit},
		store:new Ext.data.JsonStore({
			url:"../csp/dhc.nurse.extjs.getdata.csp?className="+obj.className+"&methodName="+obj.methodName,
			fields:obj.fields,
			root:"rowData",
			autoLoad:true
		})
	});
	var window = new Ext.Window({
		id:obj.winID,
		layout:"fit",
		items:[grid],
		width:800,
		height:400,
		buttons:[
			new Ext.Button({
				text:"����",
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"����",
				handler:function(){
				saveModelDefines(obj.gridID)
				}
			}),
			new Ext.Button({
				text:"ɾ��",
				handler:function(){
				deleteMoSelected(obj.gridID,obj.idField)
				}
			}),
			new Ext.Button({
				text:"ȡ��",
				handler:function (){
					window.close();
				}
			})
		],
		listeners:{close:function(){
			//Ext.getCmp("sheetButtons").getStore().removeAll();
			//Ext.getCmp("sheetColumn").getStore().removeAll();
			//Ext.getCmp("sheetButtons").getStore().load();
			//Ext.getCmp("sheetColumn").getStore().load();
		}}
	})
	return window;
	}
//��Ŀ¼����
function createEidtPanelWin(obj)
{
	if(Ext.getCmp(obj.winID))
	{
		Ext.getCmp(obj.winID).close();
	}
	var grid = new Ext.grid.EditorGridPanel({
		id:obj.gridID,
		layout:"fit",
		sm:new Ext.grid.RowSelectionModel({}),
		cm:obj.cm,
		viewConfig:{forceFit:obj.forceFit},
		store:new Ext.data.JsonStore({
			url:"../csp/dhc.nurse.extjs.getdata.csp?className="+obj.className+"&methodName="+obj.methodName,
			fields:obj.fields,
			root:"rowData",
			autoLoad:true
		})
	});
	var window = new Ext.Window({
		id:obj.winID,
		layout:"fit",
		items:[grid],
		width:800,
		height:400,
		buttons:[
			new Ext.Button({
				text:"����",
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"����",
				handler:function(){
				saveDefines(obj.gridID)
				}
			}),
			new Ext.Button({
				text:"ɾ��",
				handler:function(){
				deleteSelected(obj.gridID,obj.idField)
				}
			}),
			new Ext.Button({
				text:"ȡ��",
				handler:function (){
					window.close();
				}
			})
		],
		listeners:{close:function(){
			//Ext.getCmp("sheetButtons").getStore().removeAll();
			//Ext.getCmp("sheetColumn").getStore().removeAll();
			//Ext.getCmp("sheetButtons").getStore().load();
			//Ext.getCmp("sheetColumn").getStore().load();
		}}
	})
	return window;
}
/**
*��������
*Note:���Ӽ�¼
*/
function insertNewRecord(fields,gridID)
{
	var store = Ext.getCmp(gridID).getStore();
	var recObj = "{"
	for(var i=0;i<fields.length;i++)
	{
		if(recObj!="{") recObj=recObj+","
		recObj=recObj+fields[i]+":''";
	}
	recObj=recObj+"}"
	recObj=eval("("+recObj+")");
	var newRecord = new Ext.data.Record(recObj);
	var count =store.getCount()
	store.insert(count,newRecord);
	Ext.getCmp(gridID).startEditing( count, 0 ) ;
}
/**
*��������
*Note:��������
*/
function saveModelDefines(gridID){
	Ext.getCmp(gridID).stopEditing(false);
	var saveStr=""
	var store = Ext.getCmp(gridID).getStore(); 
	var count = store.getCount();
	for(var index = 0;index<count;index++)
	{
		var rowRecord = store.getAt(index);
		var modefiedFlag=false;
		var dataStr="";
		for(var key in rowRecord.data)
		{
			if(rowRecord.isModified(key)==true)
			{
				modefiedFlag=true;
			}
			var cellVal= rowRecord.get(key);
			dataStr=dataStr+"^"+cellVal;
		}		
		dataStr=dataStr.substring(1,dataStr.length)	
		if(modefiedFlag)
		{
			if(saveStr=="")
			{
				saveStr=dataStr;
			}
			else
			{
				saveStr=saveStr+"^"+dataStr
			}
		}
	}
	if(saveStr!="")
	{
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		saveStr=saveStr+"^"+session['LOGON.USERID']
		var ret = tkMakeServerCall("Nur.DHCNurPdaEmrModel","Save",saveStr);
		Ext.MessageBox.alert("<��ʾ>",ret==""?"����ɹ���":ret);
	}
	Ext.getCmp(gridID).getStore().load();
	}
function saveDefines(gridID)
{
	Ext.getCmp(gridID).stopEditing(false);
	var saveStr=""
	var store = Ext.getCmp(gridID).getStore(); 
	var count = store.getCount();
	for(var index = 0;index<count;index++)
	{
		var rowRecord = store.getAt(index);
		var modefiedFlag=false;
		var dataStr="";
		for(var key in rowRecord.data)
		{
			if(rowRecord.isModified(key)==true)
			{
				modefiedFlag=true;
			}
			var cellVal= rowRecord.get(key);
			dataStr=dataStr+"^"+cellVal;
		}		
		dataStr=dataStr.substring(1,dataStr.length)	
		if(modefiedFlag)
		{
			if(saveStr=="")
			{
				saveStr=dataStr;
			}
			else
			{
				saveStr=saveStr+"^"+dataStr
			}
		}
	}
	if(saveStr!="")
	{
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		saveStr=saveStr+"^"+session['LOGON.USERID']
		var ret = tkMakeServerCall("Nur.DHCNurPdaEmrMenu","Save",saveStr);
		Ext.MessageBox.alert("<��ʾ>",ret==""?"����ɹ���":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
/**
*��������
*Note:ɾ��ѡ����
*/
function deleteMoSelected(gridID,idField){
	Ext.MessageBox.confirm("ɾ��ȷ��", "ȷ��ɾ��ѡ�����𣿣�" ,function (btId){
		if(btId=="yes")
		{
			var grid = Ext.getCmp(gridID);
			var SelectionModel  = grid.getSelectionModel();
			var rowArray = SelectionModel.getSelections();
			var IDStr="";
			for(var i =0;i<rowArray.length;i++)
			{
				var rowRecord = rowArray[i];
				var ID = rowRecord.get(idField);
				IDStr=IDStr==""?ID:IDStr+"^"+ID
			}
			if(IDStr!="")
			{
				var ret = tkMakeServerCall("Nur.DHCNurPdaEmrModel","Delete",IDStr)
				Ext.MessageBox.alert("<��ʾ>",ret==""?"�����ɹ���":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
	
	}
function deleteSelected(gridID,idField)
{
	Ext.MessageBox.confirm("ɾ��ȷ��", "ȷ��ɾ��ѡ�����𣿣�" ,function (btId){
		if(btId=="yes")
		{
			var grid = Ext.getCmp(gridID);
			var SelectionModel  = grid.getSelectionModel();
			var rowArray = SelectionModel.getSelections();
			var IDStr="";
			for(var i =0;i<rowArray.length;i++)
			{
				var rowRecord = rowArray[i];
				var ID = rowRecord.get(idField);
				IDStr=IDStr==""?ID:IDStr+"^"+ID
			}
			if(IDStr!="")
			{
				var ret = tkMakeServerCall("Nur.DHCNurPdaEmrMenu","Delete",IDStr)
				Ext.MessageBox.alert("<��ʾ>",ret==""?"�����ɹ���":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
}
/**
*�������ô���
*/
function createLocWindow(title) {
	if (Ext.getCmp("verifiWindow")) {
		Ext.getCmp("verifiWindow").close();
	}

	var window = new Ext.Window({
		bodyStyle: "padding:5px;",
		id: "verifiWindow",
		width: 260,
		height: 100,
		title: title,
		resizable: false,
		layout: "form",
		items: [
		{
					id: "formComFlag",
					xtype: "combo",
					fieldLabel: "ͨ�ñ��",
					width: 125,
					store: [
					["Y", "��"],
					["N", "��"]
					],
					value: "Y",
					labelStyle: "font-size:18px"		
		}],
		buttons: [{
			id: "execButton",
			xtype: "button",
			text: "ȷ��"
		}, {
			id: "cancelButton",
			xtype: "button",
			text: "ȡ��",
			handler: function() {
				window.close()
			}
		}],
		listeners: {
			beforeclose: function() {
				this.destroy();
			}
		}
	})
	return window
}
//ģ��
var formModelName=new Ext.form.ComboBox({
	    fieldLabel :'<font size=3>ģ��</font>',
		name:'formModelName',
		id:'formModelName',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'desc',
					'mapping':'id'
				},{
					'name':'desc',
					'mapping':'id'
				}]
			}),
			baseParams:{
				className:'Nur.PDA.NurEmrConfig',
				methodName:'getModel',
				type:'RecQuery'
			}
		}),
		tabIndex:'0',
		listWidth:220,
		height:18,
		width:150,
		xtype:'combo',
		displayField:'desc',
		valueField:'id',
		hideTrigger:false,
		queryParam:'ward1',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:100,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});
formModelName.on('select', function() {
			var formModelName = Ext.get("formModelName").dom.value;
			Ext.getCmp("formShowName").setValue(formModelName);
		});
		
//����ģ��
var LinkModelName=new Ext.form.ComboBox({
	    fieldLabel :'<font size=3>�����������ģ��</font>',
		name:'LinkModelName',
		id:'LinkModelName',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'desc',
					'mapping':'id'
				},{
					'name':'desc',
					'mapping':'id'
				}]
			}),
			baseParams:{
				className:'Nur.PDA.NurEmrConfig',
				methodName:'getModel',
				type:'RecQuery'
			}
		}),
		tabIndex:'0',
		listWidth:220,
		height:18,
		width:150,
		xtype:'combo',
		displayField:'desc',
		valueField:'id',
		hideTrigger:false,
		queryParam:'ward1',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:100,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});
 
//��Ŀ¼
var formMenuName=new Ext.form.ComboBox({
	    fieldLabel :'<font size=3>��Ŀ¼</font>',
		name:'formMenuName',
		id:'formMenuName',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'desc',
					'mapping':'id'
				},{
					'name':'desc',
					'mapping':'id'
				}]
			}),
			baseParams:{
				className:'Nur.PDA.NurEmrConfig',
				methodName:'getMenu',
				type:'RecQuery'
			}
		}),
		tabIndex:'0',
		listWidth:220,
		height:18,
		width:150,
		xtype:'combo',
		displayField:'desc',
		valueField:'id',
		hideTrigger:false,
		queryParam:'modeDesc',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:100,
		typeAhead:true,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});
function comboLoadData(comBoBoxDepObj,className,methodName)
{
	//comBoBoxDepObj.on('beforequery',function(){
	    comBoBoxDepObj.store.proxy=new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		});
		comBoBoxDepObj.store.reader =new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'id',
				'mapping' : 'id'
			}]
		});
		comBoBoxDepObj.store.baseParams.className =className;
		comBoBoxDepObj.store.baseParams.methodName = methodName;
		comBoBoxDepObj.store.baseParams.codedesc=comBoBoxDepObj.lastQuery;
		comBoBoxDepObj.store.baseParams.type = 'RecQuery';
		var comboboxDepStore=comBoBoxDepObj.getStore();
	    comboboxDepStore.load({
 		params:{start:0,limit:1000}
	    });	
   //});	
}
comboLoadData(formModelName,"Nur.PDA.NurEmrConfig","getModel");
comboLoadData(formMenuName,"Nur.PDA.NurEmrConfig","getMenu");
comboLoadData(LinkModelName,"Nur.PDA.NurEmrConfig","getModel");

/**
*ģ�����ô���
*/
 var WinForm = new Ext.FormPanel({
				id : 'form-save',
				title:'',
				//baseCls : 'x-plain',//form͸��,����ʾ���
				labelAlign : 'right',
				labelWidth : 120,
				height :420,
				split : true,
				frame : true,
				waitMsgTarget : true,
				defaults : {
					anchor : '100%',
					bosrder : false
				},
				items: [
					{ 
								id: "formItemCode", 
								xtype: "textfield",
								fieldLabel:'<font size=3>Ԫ��CODE</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					},
					{ 
								id: "formLinkCode", 
								xtype: "textfield",
								fieldLabel:'<font size=3>Ԫ�ع���CODE</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					},
					{ 
								id: "formLinkType",
								xtype: "combo",
								fieldLabel:'<font size=3>��������</font>',
								width: 250,
								mode : 'local',
								store: [
								["1", "��ֵ"],
								["2", "����"],
								["3", "��ת"],
								["4", "������"],
								["5", "���ּ�"],
								["6", "���ɱ༭"],
								["7", "��������"],
								["8", "ƽ��"],
								["9", "��ѡ"]
								],
								labelStyle: "font-size:18px"	
					},
					{ 
								id: "formLinkNote", 
								xtype: "textfield",
								fieldLabel:'<font size=3>����˵��</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					}]
 });
var AddModelItemwindow = new Ext.Window({
		title : '', 
		width : 580,
		layout : 'fit',
		closeAction : 'hide',
		plain : true,// true�����屳��͸��
		modal : true,
		frame : true,
		autoScroll : true,
		collapsible : true,
		hideCollapseTool : true,
		titleCollapse : true,
		bodyStyle : 'padding:3px',
		buttonAlign : 'center',
		items : WinForm,
		buttons : [
			{
				text : '����',
			    id:'save_btn',
				handler :saveModel,
				icon:'../images/uiimages/filesave.png'
		    }, 
			{
			    text : 'ȡ��',
				icon:'../images/uiimages/cancel.png',
			    handler : function() 
				{
				   AddModelItemwindow.hide();
			    }
		    }
	    ]
	});
//����ģ��
function saveModel()
{
	var itemCode = Ext.getCmp("formItemCode").getValue();
	var linkCode = Ext.getCmp("formLinkCode").getValue();
	var linkType = Ext.getCmp("formLinkType").getValue();
	var linkNote = Ext.getCmp("formLinkNote").getValue();
	
	if((itemCode=="")||(linkCode=="")||(linkType==""))
	{
		alert("��Ϣ������!!!")
		return;
	}
	var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
	var setId=""
	if(subselobj){
		setId=subselobj.get("setId")
	}
	
	var parr=selId+"^"+itemCode+"^"+linkCode+"^"+linkType+"^"+linkNote+"^"+setId;
	
	var resStr = tkMakeServerCall("Nur.DHCNurPdaModelSet", "Save", parr);
	if(resStr==""){
		alert("����ɹ�")
	}
	AddModelItemwindow.hide();
	Ext.getCmp("findButton").fireEvent("click");
}
//�޸�ģ��
function updateModel()
{ 
	var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
	//alert(subselobj)
	var setId=""
	if(subselobj){
		setId=subselobj.get("setId")
	}
	if(setId==""){
			alert("��ѡ��һ��ģ��")
			return;
	}
	
	var setInfo = tkMakeServerCall("web.DHCNurPdaDepModelSet", "getItemSetInfoById", setId);
	if(setInfo==""){
		alert("û��������Ϣ");
		return;
	}
	var setArr=setInfo.split("^");
	Ext.getCmp("formItemCode").setValue(setArr[0]);
	Ext.getCmp("formLinkCode").setValue(setArr[1]);
	Ext.getCmp("formLinkType").setValue(setArr[2]);
	Ext.getCmp("formLinkNote").setValue(setArr[3]);
	AddModelItemwindow.show();
}
Ext.onReady(onReady);
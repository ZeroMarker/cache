///PDA��������ʾ����
///fengliang
///2021-06-11

var selId="",thisHospId,hosptalComboBox;
///***ģ���������������***///
var modelData = new Array();
function ModelData(a, b) {
	modelData.push({
				modelCode : a,
				modelName : b
			});
}
//tkMakeServerCall("Nur.MNIS.Web.DepModelSet", "getModelList", 'ModelData');
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
						url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.MNIS.Web.DepModelSet&methodName=GetModelListJson",
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
//tkMakeServerCall("Nur.MNIS.Web.DepModelSet", "getMenuList", 'MenuData');
var storeMenu = new Ext.data.JsonStore({
			data : menuData,
			fields : ['menuId', 'menuName']
		});	
///***end***///	

function onReady() {
	thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","Nur_IP_NurseSheetSet",session['LOGON.HOSPID'])
	var hospComp=GenHospComp("Nur_IP_NurseSheetSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	var hospDS= hospComp.store;
	hospDS.root="data";
	hospDS.load({
		callback:function() {
			hosptalComboBox.setValue(thisHospId);
		}
	});
	
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
					selId = record.get("locId");
					Ext.getCmp("modelList").setTitle("����:" + record.get("LocName") );
					var hospitalID = Ext.getCmp("hospitalName").getValue();
					loadData(Ext.getCmp("modelList"), {
						className: "Nur.MNIS.Web.DepModelSet",
						methodName: "GetSetByloc",
						parameter1:selId,
						parameter2: hospitalID
					})
					comboLoadData(formModelName,"Nur.MNIS.Service.NurEmrConfig","GetModel");
					comboLoadData(formMenuName,"Nur.MNIS.Service.NurEmrConfig","GetMenu");
					comboLoadData(LinkModelName,"Nur.MNIS.Service.NurEmrConfig","GetModel");	
				}
			}
		}),
		cm: new Ext.grid.ColumnModel({
			columns: [
				selectionModel, {
					header: "��������",
					dataIndex: "locName",
					width: 160
				}, {
					header: "ͨ�ñ��",
					dataIndex: "commonFlag",
					width: 80
				}, {
					header: "����ID",
					dataIndex: "locId",
					width: 80
				}	
			]
		}),
		store: createStore({
			className: "Nur.MNIS.Web.DepModelSet",
			methodName: "GetLocJson",
			parameter1: thisHospId
		}, ["locName", "commonFlag", "locId"]),
		
		tbar: [	
			hosptalComboBox=new Ext.form.ComboBox ({
				id:"hospitalName",
				// valueField:"ID",
				// displayField :"DESC",
				valueField:"HOSPRowId",
				displayField :"HOSPDesc",
				width:180,
				minChars :0,
				triggerAction:"all",
				store:hospDS, /*new Ext.data.JsonStore({
						url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getHospital",
						root:"rowData",
						fields:['ID','DESC']
				})*/
				listeners: {
		          afterRender: function(combo) {
		        ����combo.setValue(thisHospId);
		          }  
		    	}
			}),
			"-",
			new Ext.Button({
				id: "ExcuteBtn",
				text: "�޸�",
				listeners: {
					click: function() {
						var selComFlag="";
						var selobj = Ext.getCmp("locList").getSelectionModel().getSelected();
						if(selobj){
							selId=selobj.get("locId")
							selComFlag=selobj.get("commonFlag")
						}					
						if(selId==""){
							alert("��ѡ��һ����¼")
							return;
						}
						var window = createLocWindow("ά������");   //alert("�½�")  //UnExcuteBun_OnClick()
						window.buttons[0].on("click", function() {
							
							var ComFlag = window.getComponent("formComFlag").getValue();
						    var resStr = tkMakeServerCall("Nur.MNIS.Web.DepModelSet", "setLocComFlag", selId, ComFlag);
							if(resStr!=""){
								alert("����ɹ�")
							}
							window.close();
							Ext.getCmp("finddataButton").fireEvent("click");
						});
						window.getComponent("formComFlag").setValue(selComFlag);
						window.show();
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "finddataButton",
				text: "��ѯ",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						var hospitalID = Ext.getCmp("hospitalName").getValue();
						Ext.getCmp("locList").getStore().removeAll();
						loadData(Ext.getCmp("locList"), {
							className: "Nur.MNIS.Web.DepModelSet",
							methodName: "GetLocJson",
							parameter1: hospitalID
						});
					
						Ext.getCmp("modelList").getStore().removeAll(); 
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
			header: "Ŀ¼����",
			dataIndex: "menuName",
			width: 170
		}, {
			header: "ģ������",
			dataIndex: "modelName",
			width: 300
		}, {
			header: "ģ��Code",
			dataIndex: "modelCode",
			width: 300
		}, {
			header: "ģ������",
			dataIndex: "modelType",
			width: 300
		}, {
			header: "ID",
			dataIndex: "setId",
			width: 300
		}]),
		tbar: [
			new Ext.Button({
				id: "modleButton",
				text: "ģ��",
				listeners: {
					click: function() {
						if(selId==""){
								alert("��ѡ��һ������")
								return;
						}
						ModelDefine();
					 
					}
				}
			}),
			new Ext.Button({
				id: "menuButton",
				text: "��Ŀ¼",
				listeners: {
					click: function() {
						if(selId==""){
								alert("��ѡ��һ������")
								return;
						}
						MenuDefine();
					 
					}
				}
			}),
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
						var resStr = tkMakeServerCall("CF.NUR.MNIS.DepModelSet", "Delete", subsselloc);
						if(resStr!="0"){
							alert(resStr)
					    }
						var selobj = Ext.getCmp("locList").getSelectionModel().getSelected();
						if(selobj){
							selloc=selobj.get("LocId")
						}
						Ext.getCmp("modelList").getStore().removeAll();	
						var hospitalID = Ext.getCmp("hospitalName").getValue();
						loadData(Ext.getCmp("modelList"), {
							className: "Nur.MNIS.Web.DepModelSet",
							methodName: "GetSetByloc",
							parameter1: selId,
							parameter2: hospitalID
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
						var hospitalID = Ext.getCmp("hospitalName").getValue();
						loadData(Ext.getCmp("modelList"), {
							className: "Nur.MNIS.Web.DepModelSet",
							methodName: "GetSetByloc",
							parameter1: selId,
							parameter2: hospitalID
						});
					}
				}
			})
		],
		store: createStore({
			className: "Nur.MNIS.Web.DepModelSet",
			methodName: "GetSetByloc"
		}, ["menuName", "modelName", "modelCode", "modelType","setId"]),
		viewConfig: {
			forceFit: true
		}
	});

					comboLoadData(formModelName,"Nur.MNIS.Service.NurEmrConfig","GetModel");
					comboLoadData(formMenuName,"Nur.MNIS.Service.NurEmrConfig","GetMenu");
					comboLoadData(LinkModelName,"Nur.MNIS.Service.NurEmrConfig","GetModel");		
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
		{header:"��ֵ����",width:90,dataIndex:"sortDesc",editor:new Ext.form.Field()},
		{header: "��ֵ�ֶ�",width:60,dataIndex:"sortItem",editor:new Ext.form.Field()},
		{header: "modelID",width:30,dataIndex:"modelID"}
	]); 
	var hospitalID = Ext.getCmp("hospitalName").getValue();
	var window =createModelPanelWin({
		winID:"modelDefineWin",
		gridID:"modelDefine",
		cm:columnDefine,
		fields:["modelName","modelCode","modelSort","modelCanFlag","sortDesc","sortItem","modelID"],
		className:"Nur.MNIS.Web.DepModelSet",
		methodName:"GetModelJson",
		parameter1: selId,
		parameter2: hospitalID,
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
	
	var hospitalID = Ext.getCmp("hospitalName").getValue();
	var window =createEidtPanelWin({
		winID:"menuDefineWin",
		gridID:"menuDefine",
		cm:cloumnModel,
		fields:["menuName","menuCode","menuSort","canFlag","menuID"],
		className:"Nur.MNIS.Web.DepModelSet",
		methodName:"GetMenuJson",
		parameter1: selId,
		parameter2: hospitalID,
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
			url:"../csp/dhc.nurse.extjs.getdata.csp?className="+obj.className+"&methodName="+obj.methodName+"&parameter1="+obj.parameter1+"&parameter2="+obj.parameter2,
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
			url:"../csp/dhc.nurse.extjs.getdata.csp?className="+obj.className+"&methodName="+obj.methodName+"&parameter1="+obj.parameter1+"&parameter2="+obj.parameter2,
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
	var hospitalID = Ext.getCmp("hospitalName").getValue();
	if(saveStr!="")
	{
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		saveStr=saveStr+"^"+session['LOGON.USERID']+"^"+selId+"^"+hospitalID
		//alert(saveStr)
		var ret = tkMakeServerCall("CF.NUR.MNIS.EmrModel","Save",saveStr);
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
	var hospitalID = Ext.getCmp("hospitalName").getValue();	
	if(saveStr!="")
	{
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		saveStr=saveStr+"^"+session['LOGON.USERID']+"^"+selId+"^"+hospitalID
		var ret = tkMakeServerCall("CF.NUR.MNIS.EmrMenu","Save",saveStr);
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
				var ret = tkMakeServerCall("CF.NUR.MNIS.EmrModel","Delete",IDStr)
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
				var ret = tkMakeServerCall("CF.NUR.MNIS.EmrMenu","Delete",IDStr)
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
				className:'Nur.MNIS.Service.NurEmrConfig',
				methodName:'GetModel',
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
				className:'Nur.MNIS.Service.NurEmrConfig',
				methodName:'GetModel',
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
				className:'Nur.MNIS.Service.NurEmrConfig',
				methodName:'GetMenu',
				type:'RecQuery',
				hosId:thisHospId,
				locId:selId
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
		queryParam:123,
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
		var hospitalID = Ext.getCmp("hospitalName").getValue();
		comBoBoxDepObj.store.baseParams.className =className;
		comBoBoxDepObj.store.baseParams.methodName = methodName;
		comBoBoxDepObj.store.baseParams.locId = selId;
		comBoBoxDepObj.store.baseParams.hosId = hospitalID;
		comBoBoxDepObj.store.baseParams.codedesc=comBoBoxDepObj.lastQuery;
		comBoBoxDepObj.store.baseParams.type = 'RecQuery';
		var comboboxDepStore=comBoBoxDepObj.getStore();
	    comboboxDepStore.load({
 		params:{start:0,limit:1000}
	    });	
   //});	
}

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
					formModelName,
					formMenuName,
					{ 
								id: "formShowName", 
								xtype: "textfield",
								fieldLabel:'<font size=3>��ʾ����</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					},
					{ 
								id: "formModelNum", 
								xtype: "textfield",
								fieldLabel:'<font size=3>PDAģ������</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					},
					{ 
								id: "formGetValMth", 
								xtype: "textfield",
								fieldLabel:'<font size=3>PDAģ��ȡֵ����</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					},
					{ 
								id: "formGetListMth", 
								xtype: "textfield",
								fieldLabel:'<font size=3>PDAģ���б���</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					},
					{ 
								id: "formSaveMth", 
								xtype: "textfield",
								fieldLabel:'<font size=3>PDAģ�屣��</font>',
								width: 250,
								value: "",
								labelStyle: "font-size:18px"
					}
					,{
								id: "formModelType",
								xtype: "combo",
								fieldLabel:'<font size=3>ģ������</font>',
								width: 250,
								mode : 'local',
								store: [
								["1", "��¼��"],
								["2", "������"],
								["3", "���������"]
								],
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
	var modelCode = Ext.getCmp("formModelName").getValue();
	var menuId = Ext.getCmp("formMenuName").getValue();
	var showName = Ext.getCmp("formShowName").getValue();
	var modelType = Ext.getCmp("formModelType").getValue();
	var LinkModelName = Ext.getCmp("LinkModelName").getValue();
	var modelNum = Ext.getCmp("formModelNum").getValue();
	var getListMth = Ext.getCmp("formGetListMth").getValue();
	var getValMth = Ext.getCmp("formGetValMth").getValue();
	var saveMth = Ext.getCmp("formSaveMth").getValue();
	var hospitalID = Ext.getCmp("hospitalName").getValue();
	
	if((modelCode=="")||(menuId=="")||(showName=="")||(modelType=="")||(modelNum==""))
	{
		//alert("��Ϣ������!!!")
		//return;
	}
	var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
	var setId=""
	if(subselobj){
		setId=subselobj.get("setId")
		
	}
	
	var parr=selId+"^"+modelCode+"^"+menuId+"^"+session['LOGON.USERID']+"^"+setId+"^"+showName+"^"+modelType+"^"+LinkModelName+"^"+modelNum+"^"+getValMth+"^"+getListMth+"^"+saveMth+"^"+hospitalID;

	var resStr = tkMakeServerCall("CF.NUR.MNIS.DepModelSet", "Save", parr);
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
	
	var setInfo = tkMakeServerCall("Nur.MNIS.Web.DepModelSet", "GetModelSetInfoById", setId);
	if(setInfo==""){
		alert("û��������Ϣ");
		return;
	}
	var setArr=setInfo.split("^");
	Ext.getCmp("formModelName").setValue(setArr[0]);
	Ext.getCmp("formMenuName").setValue(setArr[1]);
	Ext.getCmp("formShowName").setValue(setArr[2]);
	Ext.getCmp("formModelType").setValue(setArr[3]);
	Ext.getCmp("LinkModelName").setValue(setArr[4]);
	Ext.getCmp("formModelNum").setValue(setArr[5]);
	Ext.getCmp("formGetValMth").setValue(setArr[6]);
	Ext.getCmp("formGetListMth").setValue(setArr[7]);
	Ext.getCmp("formSaveMth").setValue(setArr[8]);
	AddModelItemwindow.show();
}
Ext.onReady(onReady);
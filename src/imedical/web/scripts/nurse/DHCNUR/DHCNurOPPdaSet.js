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
					selId = record.get("locId");
					var commonFlag = record.get("commonFlag");
					Ext.getCmp("modelList").setTitle("����:" + record.get("LocName") );
					loadData(Ext.getCmp("modelList"), {
						className: "Nur.DHCNurOPPdaSet",
						methodName: "getModuleSetByloc",
						parameter1:selId
					})
					loadData(Ext.getCmp("msgList"), {
						className: "Nur.DHCNurOPPdaSet",
						methodName: "getMsgSetByloc",
						parameter1:selId
					})
					if((commonFlag=="Y")&&(selId!="common")){
						Ext.getCmp("changeButton").hide();
						Ext.getCmp("changeMsgButton").hide();
						Ext.getCmp("commSave").hide();
					}else{
						Ext.getCmp("changeButton").show();	
						Ext.getCmp("changeMsgButton").show();
						Ext.getCmp("commSave").show();	
					}
					initCommSet(selId);
				}
			}
		}),
		cm: new Ext.grid.ColumnModel({
			columns: [{
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
			className: "Nur.DHCNurOPPdaSet",
			methodName: "getLocJson"
		}, ["locName", "commonFlag", "locId"]),
		
		tbar: [	
			
			new Ext.Button({
				id: "modelBtn",
				text: "ģ�鶨��",
				handler : ModelDefine
			}),
			"-",
			new Ext.Button({
				id: "unExcuteBtn",
				text: "���ڶ���",
				handler : MenuDefine
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
						    var resStr = tkMakeServerCall("Nur.DHCNurOPPdaSet", "setLocComFlag", selId, ComFlag);
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
						//var record = Ext.getCmp("locList").getSelectionModel().getSelected();
						//if(record) CurrentLocID=record.get("LocID");
						//else CurrentLocID = ""
						Ext.getCmp("locList").getStore().removeAll();
						loadData(Ext.getCmp("locList"), {
							className: "Nur.DHCNurOPPdaSet",
							methodName: "getLocJson"
						});
					}
				}
				
			})
		]
	});
	locList.getStore().load();

	//�ұ�ģ���б�
	var modelList = new Ext.grid.EditorGridPanel({
		layout: "fit",
		id: "modelList",
		height:document.body.scrollHeight/2,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{rowselect:function(){
				//alert(111)
			}}
		}),
		colModel: new Ext.grid.ColumnModel([{
			header: "ģ������",
			dataIndex: "moduleName",
			width: 170,
			editor:new Ext.form.Field()
		}, {
			header: "ģ�����",
			dataIndex: "moduleCode",
			width: 300
		}, {
			header: "��ʾ˳��",
			dataIndex: "moduleSort",
			width: 300,
			editor:new Ext.form.Field()
		}, {
			header: "�Ƿ���ʾ",
			dataIndex: "moduleShowFlag",
			width: 300,
			editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
			})
		}, {
			header: "ID",
			dataIndex: "moduleID",
			width: 300,
			hidden:true
		}]),
		tbar: [
			new Ext.Button({
				id: "changeButton",
				text: "�޸�",
				icon: '../images/uiimages/register.png',
				listeners: {
					click: function() { 
						var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						if(subselobj){
							var moduleName=subselobj.get("moduleName")
							var moduleCode=subselobj.get("moduleCode")
							var moduleSort=subselobj.get("moduleSort")
							var moduleShowFlag=subselobj.get("moduleShowFlag")
							var moduleID=subselobj.get("moduleID")
							
							var parr=moduleName+"^"+moduleCode+"^"+moduleSort+"^"+moduleShowFlag+"^"+selId+"^"+moduleID
							var resStr = tkMakeServerCall("Nur.DHCNurOPPdaModuleByLoc", "Save", parr);
							if(resStr!="0"){
								alert(resStr)
						    }
						    Ext.getCmp("findButton").fireEvent("click");
						}else{
							alert("��ѡ��һ������")
							return;
						}
						
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
							className: "Nur.DHCNurOPPdaSet",
							methodName: "getModuleSetByloc",
							parameter1: selId
						});
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "punNoteList",
				text: "���̲�λ",
				icon: '../images/uiimages/register.png',
				handler : punPartListDifine
			}),
			"-",
			new Ext.Button({
				id: "reasonNoteList",
				text: "�쳣ԭ��",
				icon: '../images/uiimages/register.png',
				handler : ifReasonListDifine
				
			})
		],
		store: createStore({
			className: "Nur.DHCNurOPPdaSet",
			methodName: "getModuleSetByloc"
		}, ["moduleName","moduleCode","moduleSort","moduleShowFlag","moduleID"]),
		viewConfig: {
			forceFit: true
		}
	});
	/*
modelList.on("rowdblclick", function(grid, rowIndex, e)
   { 
	  updateModel();				 
   });*/
   
   //�ұ�ģ���б�
	var msgList = new Ext.grid.EditorGridPanel({
		layout: "fit",
		id: "msgList",
		height:document.body.scrollHeight/2,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{rowselect:function(){
				//alert(111)
			}}
		}),
		cm: new Ext.grid.ColumnModel([{
			header: "��������",
			dataIndex: "msgName",  
			width: 170,
			editor:new Ext.form.Field()
		}, {
			header: "���ڴ���",
			dataIndex: "msgCode",
			width: 300
		}, {
			header: "����˳��",
			dataIndex: "msgSort",
			width: 300,
			editor:new Ext.form.Field()
		}, {
			header: "�Ƿ���ʾ",
			dataIndex: "msgShowFlag",
			width: 300,
			editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
			})
		}, {
			header: "ID",
			dataIndex: "msgId",
			width: 300
		}]),
		tbar: [
			new Ext.Button({
				id: "changeMsgButton",
				text: "�޸�",
				icon: '../images/uiimages/register.png',
				listeners: {
					click: function() { 
					var subselobj = Ext.getCmp("msgList").getSelectionModel().getSelected();
						if(subselobj){
							var msgName=subselobj.get("msgName")
							var msgCode=subselobj.get("msgCode")
							var msgSort=subselobj.get("msgSort")
							var msgShowFlag=subselobj.get("msgShowFlag")
							var msgId=subselobj.get("msgId")
							
							var parr=msgName+"^"+msgCode+"^"+msgSort+"^"+msgShowFlag+"^"+selId+"^"+msgId
							var resStr = tkMakeServerCall("Nur.DHCNurPdaWinByLoc", "Save", parr);
							if(resStr!="0"){
								alert(resStr)
						    }
						    Ext.getCmp("findMsgButton").fireEvent("click");
						}else{
							alert("��ѡ��һ������")
							return;
						}
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "findMsgButton",
				text: "��ѯ",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						Ext.getCmp("msgList").getStore().removeAll();					
						var modelCom = Ext.getCmp("modelCom").getValue();
						loadData(Ext.getCmp("msgList"), {
							className: "Nur.DHCNurOPPdaSet",
							methodName: "getMsgSetByloc",
							parameter1: selId
						});
					}
				}
			})
		],
		store: createStore({
			className: "web.DHCNurPdaDepModelSet",
			methodName: "getSetByloc"
		}, ["msgName","msgCode","msgSort","msgShowFlag","msgId"]),
		viewConfig: {
			forceFit: true
		}
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
			layout: "border",
			id: "centerPanel",
			width: 400,
			items:[{
				region: "center",
				id: "centerSubPanel",
				items: [modelList,msgList]
			}]
		}, {
			region: "east",
			layout: "fit",
			id: "eastPanel",
			width: 400,
			items: [{
				region: "center",
				layout: "fit",
				id: "eastSubPanel",
				items: [InHosSetPanel]
			}]
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
		{header: "modelID",width:30,dataIndex:"modelID"}
	]);
	var window =createModelPanelWin({
		winID:"modelDefineWin",
		gridID:"modelDefine",
		cm:columnDefine,
		fields:["modelName","modelCode","modelSort","modelCanFlag","modelID"],
		className:"Nur.DHCNurOPPdaSet",
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
		className:"Nur.DHCNurOPPdaSet",
		methodName:"getMessageTypeJson",
		forceFit:true,
		idField:"menuID"
	});
	window.show();
}
/*
*��ע����
*/

function ifReasonListDifine()
{	
  noteListDifine("IFReason");
}
function punPartListDifine()
{	
  noteListDifine("PunPart");
}
function tourNoteListDifine()
{	
  noteListDifine("Tour");
}
function supNoteListDifine()
{	
  noteListDifine("Sup");
}
function stopNoteListDifine()
{	
  noteListDifine("Stop");
}
function noteListDifine(flag)
{	
	var cloumnModel = new Ext.grid.ColumnModel([
	   
	    {header: "����",width:90,dataIndex:"noteName",editor:new Ext.form.Field()},
    	{header: "����",width:60,dataIndex:"noteCode",editor:new Ext.form.Field()},
		{header: "��ʾ˳��",width:60,dataIndex:"noteSort",editor:new Ext.form.Field()},
    	{header: "�Ƿ�����",width:100,dataIndex:"canFlag",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
		{header: "ID",width:20,dataIndex:"noteID"},
	]);
	
	var window =createNotePanelWin({
		winID:"noteDefineWin",
		gridID:"noteDefine",
		cm:cloumnModel,
		fields:["noteName","noteCode","noteSort","canFlag","noteID"],
		className:"Nur.DHCNurOPPdaSet",
		methodName:"getNoteListJson",
		parameter1:flag,
		forceFit:true,
		idField:"noteID",
		flag:flag
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
//��Ŀ¼����
function createNotePanelWin(obj)
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
			url:"../csp/dhc.nurse.extjs.getdata.csp?className="+obj.className+"&methodName="+obj.methodName+"&parameter1="+obj.flag,
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
				saveNoteDefines(obj.gridID,obj.flag)
				}
			}),
			new Ext.Button({
				text:"ɾ��",
				handler:function(){
				deleteNoteSelected(obj.gridID,obj.idField)
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
		var ret = tkMakeServerCall("Nur.DHCNurPdaWindow","Save",saveStr);
		Ext.MessageBox.alert("<��ʾ>",ret==""?"����ɹ���":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
function saveNoteDefines(gridID,flag)
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
		saveStr=saveStr+"^"+flag+"^"+session['LOGON.USERID']
		var ret = tkMakeServerCall("Nur.DHCNurOPPdaNote","Save",saveStr);
		Ext.MessageBox.alert("<��ʾ>",ret==""?"����ɹ���":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
function deleteNoteSelected(gridID,idField)
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
				IDStr=IDStr==""?ID:IDStr+String.fromCharCode(135)+ID
			}
			if(IDStr!="")
			{
				var ret = tkMakeServerCall("Nur.DHCNurOPPdaNote","Delete",IDStr)
				Ext.MessageBox.alert("<��ʾ>",ret==""?"�����ɹ���":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
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
		var ret = tkMakeServerCall("Nur.DHCNurOPPdaModule","Save",saveStr);
		Ext.MessageBox.alert("<��ʾ>",ret==""?"����ɹ���":ret);
	}
	Ext.getCmp(gridID).getStore().load();
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
function initCommSet(locId){
	var ret=tkMakeServerCall("Nur.DHCNurOPPdaSet","getCommonSet",locId);
	var retArray=ret.split("^");
	Ext.getCmp('pyControlFlag').setValue(retArray[1]);
	Ext.getCmp('zspyControlFlag').setValue(retArray[2]);
	Ext.getCmp('pspyControlFlag').setValue(retArray[3]);
	Ext.getCmp('jyhdControlFlag').setValue(retArray[4]);
}

function saveCommSet(){
	var pyControlFlag=Ext.getCmp('pyControlFlag').getValue();
	var zspyControlFlag=Ext.getCmp('zspyControlFlag').getValue();
	var pspyControlFlag=Ext.getCmp('pspyControlFlag').getValue();
	var jyhdControlFlag=Ext.getCmp('jyhdControlFlag').getValue();
	var parr=selId+"^"+pyControlFlag+"^"+zspyControlFlag+"^"+pspyControlFlag+"^"+jyhdControlFlag
	var setInfo = tkMakeServerCall("Nur.DHCNurOPPdaSet", "setComFlag", parr);
	if(setInfo!="0"){
	 alert(setInfo);
	 return;
	}
	alert("�����ɹ�")
}
var searchSetPanel = new Ext.Panel({
		title: "ͨ������",
		layout:"form",
		tbar:[
			new Ext.Button({
				text:'����',
				id:'commSave',
				icon:'../images/uiimages/filesave.png',
				handler:saveCommSet
			})],
		items: [{
					xtype: 'checkbox',
					fieldLabel:'��Һ��Һ����',
					labelStyle: 'text-align:right;',
					id: 'pyControlFlag'
				},
				{
					xtype: 'checkbox',
					fieldLabel:'ע����Һ����',
					labelStyle: 'text-align:right;',
					id: 'zspyControlFlag'
				},
				{
					xtype: 'checkbox',
					fieldLabel:'Ƥ����Һ����',
					labelStyle: 'text-align:right;',
					id: 'pspyControlFlag'
				},
				{
					xtype: 'checkbox',
					fieldLabel:'����˶Կ���',
					labelStyle: 'text-align:right;',
					id: 'jyhdControlFlag'
				}
		]
});
	/*
	*ͨ�������ַ��ٲ���panel
	*/
var InHosSetPanel = new Ext.Panel({  
       height: 350,	   
       layout: 'accordion',  
       title: 'ͨ������',
	   layoutConfig: {  
		 activeOnTop: true,  //���ô򿪵�������ö�  
		 fill: true,         //��������������ʣ��ռ�  
		 titleCollapse: true,      //����ͨ����������ı�����չ�������������  
		 animate: true             //ʹ�ö���Ч��  
	   },  	   
       items: [searchSetPanel]   
});
Ext.onReady(onReady);
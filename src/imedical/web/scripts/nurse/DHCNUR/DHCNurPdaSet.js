///PDA护理病历显示配置
///LMM
///2017-03-17

var selId="",thisHospId,hosptalComboBox;

///***模板下拉框加载数据***///
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
			fieldLabel : '模板',
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
///***模板下拉框加载数据***///
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
	thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","Nur_IP_NurseSheetSet",session["LOGON.HOSPID"])
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
	//左边科室列表
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
					var hospitalID = Ext.getCmp("hospitalName").getValue();
					Ext.getCmp("modelList").setTitle("科室:" + record.get("LocName") );
					loadData(Ext.getCmp("modelList"), {
						className: "Nur.DHCNurPdaSet",
						methodName: "getModuleSetByloc",
						parameter1:selId,
						parameter2:hospitalID
						
					})
					loadData(Ext.getCmp("msgList"), {
						className: "Nur.DHCNurPdaSet",
						methodName: "getMsgSetByloc",
						parameter1:selId,
						parameter2:hospitalID
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
					header: "科室名称",
					dataIndex: "locName",
					width: 160
				}, {
					header: "通用标记",
					dataIndex: "commonFlag",
					width: 80
				}, {
					header: "科室ID",
					dataIndex: "locId",
					width: 80
				}	
			]
		}),
		store: createStore({
			className: "Nur.DHCNurPdaSet",
			methodName: "getLocJson",
			parameter1: "",
			parameter2: thisHospId
		}, ["locName", "commonFlag", "locId"]),
		
		tbar: [	
			
			new Ext.Button({
				id: "modelBtn",
				text: "模块定义",
				handler : ModelDefine
			}),
			"-",
			new Ext.Button({
				id: "unExcuteBtn",
				text: "消息类型",
				handler : MenuDefine
			}),
			new Ext.Button({
				id: "ExcuteBtn",
				text: "修改",
				listeners: {
					click: function() {
						var selComFlag="";
						var selobj = Ext.getCmp("locList").getSelectionModel().getSelected();
						if(selobj){
							selId=selobj.get("locId")
							selComFlag=selobj.get("commonFlag")
						}					
						if(selId==""){
							alert("请选择一条记录")
							return;
						}
						var window = createLocWindow("维护科室");   //alert("新建")  //UnExcuteBun_OnClick()
						window.buttons[0].on("click", function() {
							
							var ComFlag = window.getComponent("formComFlag").getValue();
						    var resStr = tkMakeServerCall("Nur.DHCNurPdaSet", "setLocComFlag", selId, ComFlag);
							if(resStr!=""){
								alert("保存成功")
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
			hosptalComboBox=new Ext.form.ComboBox ({
				id:"hospitalName",
				// valueField:"ID",
				// displayField :"DESC",
				valueField:"HOSPRowId",
				displayField :"HOSPDesc",
				width:150,
				minChars :0,
				triggerAction:"all",
				store:hospDS, /*new Ext.data.JsonStore({
						url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getHospital",
						root:"rowData",
						fields:['ID','DESC']
				})*/
				listeners: {
		          afterRender: function(combo) {
		        　　combo.setValue(thisHospId);
		          }  
		    	}
			}),
			"-",
			new Ext.Button({
				id: "finddataButton",
				text: "查询",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						//var record = Ext.getCmp("locList").getSelectionModel().getSelected();
						//if(record) CurrentLocID=record.get("LocID");
						//else CurrentLocID = ""
						var hospitalID = Ext.getCmp("hospitalName").getValue();
						Ext.getCmp("locList").getStore().removeAll();
						loadData(Ext.getCmp("locList"), {
							className: "Nur.DHCNurPdaSet",
							methodName: "getLocJson",
							parameter1: "",
							parameter2: hospitalID
						});
						Ext.getCmp("msgList").getStore().removeAll();
						Ext.getCmp("modelList").getStore().removeAll();  
					}
				}
				
			})
		]
	});
	locList.getStore().load();

	//右边模板列表
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
			header: "模块名称",
			dataIndex: "moduleName",
			width: 170,
			editor:new Ext.form.Field()
		}, {
			header: "模块代码",
			dataIndex: "moduleCode",
			width: 300
		}, {
			header: "显示顺序",
			dataIndex: "moduleSort",
			width: 300,
			editor:new Ext.form.Field()
		}, {
			header: "是否显示",
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
				text: "修改",
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
							var hospitalID = Ext.getCmp("hospitalName").getValue();
						
							var parr=moduleName+"^"+moduleCode+"^"+moduleSort+"^"+moduleShowFlag+"^"+selId+"^"+moduleID+"^"+hospitalID
							var resStr = tkMakeServerCall("Nur.DHCNurPdaModuleByLoc", "Save", parr);
							if(resStr!="0"){
								alert(resStr)
						    }
						    Ext.getCmp("findButton").fireEvent("click");
						}else{
							alert("请选中一条数据")
							return;
						}
						
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "findButton",
				text: "查询",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						Ext.getCmp("modelList").getStore().removeAll();					
						var modelCom = Ext.getCmp("modelCom").getValue();
						var hospitalID = Ext.getCmp("hospitalName").getValue();
						loadData(Ext.getCmp("modelList"), {
							className: "Nur.DHCNurPdaSet",
							methodName: "getModuleSetByloc",
							parameter1: selId,
							parameter2: hospitalID
						});
					}
				}
			})
		],
		store: createStore({
			className: "Nur.DHCNurPdaSet",
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
   
   //右边模板列表
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
			header: "消息名称",
			dataIndex: "msgName",  
			width: 170,
			editor:new Ext.form.Field()
		}, {
			header: "消息代码",
			dataIndex: "msgCode",
			width: 300
		}, {
			header: "提示顺序",
			dataIndex: "msgSort",
			width: 300,
			editor:new Ext.form.Field()
		}, {
			header: "是否显示",
			dataIndex: "msgShowFlag",
			width: 300,
			editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
			})
		}, {
			header: "是否提示",
			dataIndex: "msgRemindFlag",
			width: 300,
			editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
			})
		}, {
			header: "开启声音",
			dataIndex: "msgRemindSoundFlag",
			width: 300,
			editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
			})
		}, {
			header: "开启震动",
			dataIndex: "msgRemindVibrateFlag",
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
				text: "修改",
				icon: '../images/uiimages/register.png',
				listeners: {
					click: function() { 
					var subselobj = Ext.getCmp("msgList").getSelectionModel().getSelected();
						if(subselobj){
							var msgName=subselobj.get("msgName")
							var msgCode=subselobj.get("msgCode")
							var msgSort=subselobj.get("msgSort")
							var msgShowFlag=subselobj.get("msgShowFlag")
							var msgRemindFlag=subselobj.get("msgRemindFlag")
							var msgRemindSoundFlag=subselobj.get("msgRemindSoundFlag")
							var msgRemindVibrateFlag=subselobj.get("msgRemindVibrateFlag")
							var msgId=subselobj.get("msgId")
							
							var parr=msgName+"^"+msgCode+"^"+msgSort+"^"+msgShowFlag+"^"+msgRemindFlag+"^"+msgRemindSoundFlag+"^"+msgRemindVibrateFlag+"^"+selId+"^"+msgId
							var resStr = tkMakeServerCall("Nur.DHCNurPdaMsgByLoc", "Save", parr);
							if(resStr!="0"){
								alert(resStr)
						    }
						    Ext.getCmp("findMsgButton").fireEvent("click");
						}else{
							alert("请选中一条数据")
							return;
						}
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "findMsgButton",
				text: "查询",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						Ext.getCmp("msgList").getStore().removeAll();					
						var modelCom = Ext.getCmp("modelCom").getValue();
						var hospitalID = Ext.getCmp("hospitalName").getValue();
						loadData(Ext.getCmp("msgList"), {
							className: "Nur.DHCNurPdaSet",
							methodName: "getMsgSetByloc",
							parameter1: selId,
							parameter2: hospitalID
						});
					}
				}
			})
		],
		store: createStore({
			className: "web.DHCNurPdaDepModelSet",
			methodName: "getSetByloc"
		}, ["msgName","msgCode","msgSort","msgShowFlag","msgRemindFlag","msgRemindSoundFlag","msgRemindVibrateFlag","msgId"]),
		viewConfig: {
			forceFit: true
		}
	});
	/*
msgList.on("rowdblclick", function(grid, rowIndex, e)
   { 
	  updateModel();				 
   });*/
	///***加载界面***///
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

///////以上是界面
////////////////////****************************************************************************************///////////////////////
/*
*模板定义
*/
function ModelDefine(){
	var columnDefine = new Ext.grid.ColumnModel([
		{header:"模块名称",width:90,dataIndex:"modelName",editor:new Ext.form.Field()},
		{header:"模块Code",width:90,dataIndex:"modelCode",editor:new Ext.form.Field()},
		{header: "显示顺序",width:60,dataIndex:"modelSort",editor:new Ext.form.Field()},
    	{header: "是否启用",width:100,dataIndex:"modelCanFlag",editor:new Ext.form.ComboBox({
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
		className:"Nur.DHCNurPdaSet",
		methodName:"getModelJson",
		forceFit:true,
		idField:"modelID"
	});
	window.show();
	}
/*
*根目录定义
*/
function MenuDefine()
{	
	var cloumnModel = new Ext.grid.ColumnModel([
	   
	    {header: "名称",width:90,dataIndex:"menuName",editor:new Ext.form.Field()},
    	{header: "代码",width:60,dataIndex:"menuCode",editor:new Ext.form.Field()},
		{header: "显示顺序",width:60,dataIndex:"menuSort",editor:new Ext.form.Field()},
    	{header: "是否启用",width:100,dataIndex:"canFlag",editor:new Ext.form.ComboBox({
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
		className:"Nur.DHCNurPdaSet",
		methodName:"getMessageTypeJson",
		forceFit:true,
		idField:"menuID"
	});
	window.show();
}
/*
*备注定义
*/

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
	   
	    {header: "名称",width:90,dataIndex:"noteName",editor:new Ext.form.Field()},
    	{header: "代码",width:60,dataIndex:"noteCode",editor:new Ext.form.Field()},
		{header: "显示顺序",width:60,dataIndex:"noteSort",editor:new Ext.form.Field()},
    	{header: "是否启用",width:100,dataIndex:"canFlag",editor:new Ext.form.ComboBox({
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
		className:"Nur.DHCNurPdaSet",
		methodName:"getNoteListJson",
		parameter1:flag,
		forceFit:true,
		idField:"noteID",
		flag:flag
	});
	window.show();
}
/**
*公共方法
*Note:创建编辑窗口
*obj配置项
*/
//模板配置  lms
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
				text:"新增",
				hidden:true,
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"保存",
				handler:function(){
				saveModelDefines(obj.gridID)
				}
			}),
			new Ext.Button({
				text:"删除",
				hidden:true,
				handler:function(){
				deleteMoSelected(obj.gridID,obj.idField)
				}
			}),
			new Ext.Button({
				text:"取消",
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
//根目录配置
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
				text:"新增",
				hidden:true,
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"保存",
				handler:function(){
				saveDefines(obj.gridID)
				}
			}),
			new Ext.Button({
				text:"删除",
				hidden:true,
				handler:function(){
				deleteSelected(obj.gridID,obj.idField)
				}
			}),
			new Ext.Button({
				text:"取消",
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
//根目录配置
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
				text:"新增",
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"保存",
				handler:function(){
				saveNoteDefines(obj.gridID,obj.flag)
				}
			}),
			new Ext.Button({
				text:"删除",
				handler:function(){
				deleteNoteSelected(obj.gridID,obj.idField)
				}
			}),
			new Ext.Button({
				text:"取消",
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
		var ret = tkMakeServerCall("Nur.DHCNurPdaMessage","Save",saveStr);
		Ext.MessageBox.alert("<提示>",ret==""?"保存成功！":ret);
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
		var ret = tkMakeServerCall("Nur.DHCNurPdaNote","Save",saveStr);
		Ext.MessageBox.alert("<提示>",ret==""?"保存成功！":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
function deleteNoteSelected(gridID,idField)
{
	var grid = Ext.getCmp(gridID);
	var SelectionModel  = grid.getSelectionModel();
	var rowArray = SelectionModel.getSelections();
	if(rowArray.length<1){
		alert("请选择一条记录!")
		return;
	}
	Ext.MessageBox.confirm("删除确认", "确定删除选中行吗？？" ,function (btId){
	if(btId=="yes")
	{
			var IDStr="";
			for(var i =0;i<rowArray.length;i++)
			{
				var rowRecord = rowArray[i];
				var ID = rowRecord.get(idField);
				IDStr=IDStr==""?ID:IDStr+String.fromCharCode(135)+ID
			}
			if(IDStr!="")
			{
				var ret = tkMakeServerCall("Nur.DHCNurPdaNote","Delete",IDStr)
				Ext.MessageBox.alert("<提示>",ret==""?"操作成功！":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
}
/**
*公共方法
*Note:增加记录
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
*公共方法
*Note:保存设置
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
		var ret = tkMakeServerCall("Nur.DHCNurPdaModule","Save",saveStr);
		Ext.MessageBox.alert("<提示>",ret==""?"保存成功！":ret);
	}
	Ext.getCmp(gridID).getStore().load();
	}
/**
*科室配置窗口
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
					fieldLabel: "通用标记",
					width: 125,
					store: [
					["Y", "是"],
					["N", "否"]
					],
					value: "Y",
					labelStyle: "font-size:18px"		
		}],
		buttons: [{
			id: "execButton",
			xtype: "button",
			text: "确定"
		}, {
			id: "cancelButton",
			xtype: "button",
			text: "取消",
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
	var hospitalID = Ext.getCmp("hospitalName").getValue();
	var ret=tkMakeServerCall("Nur.DHCNurPdaSet","getCommonSet",locId,hospitalID);
	var retArray=ret.split("^");
	Ext.getCmp('queryStartDate').setValue(retArray[0]);
	Ext.getCmp('queryStartTime').setValue(retArray[1]);
	Ext.getCmp('queryEndDate').setValue(retArray[2]);
	Ext.getCmp('queryEndTime').setValue(retArray[3]);
	Ext.getCmp('allOutNum').setValue(retArray[4]);
	Ext.getCmp('exeAlertFlag').setValue(retArray[5]);
	Ext.getCmp('infusionLoopFlag').setValue(retArray[6]);
	Ext.getCmp('voiceFlag').setValue(retArray[7]);
	Ext.getCmp('jpRecControlFlag').setValue(retArray[8]);
	Ext.getCmp('pyfhControlFlag').setValue(retArray[9]);
}

function saveCommSet(){
	var queryStartDate=Ext.getCmp('queryStartDate').getValue();
	var queryStartTime=Ext.getCmp('queryStartTime').getValue();
	var queryEndDate=Ext.getCmp('queryEndDate').getValue();
	var queryEndTime=Ext.getCmp('queryEndTime').getValue();
	var allOutNum=Ext.getCmp('allOutNum').getValue();
	var exeAlertFlag=Ext.getCmp('exeAlertFlag').getValue();
	var infusionLoopFlag=Ext.getCmp('infusionLoopFlag').getValue();
	var voiceFlag=Ext.getCmp('voiceFlag').getValue();
	var jpRecControlFlag=Ext.getCmp('jpRecControlFlag').getValue();
	var pyfhControlFlag=Ext.getCmp('pyfhControlFlag').getValue();
	var hospitalID = Ext.getCmp("hospitalName").getValue();
	var parr=selId+"^"+queryStartDate+"^"+queryStartTime+"^"+queryEndDate+"^"+queryEndTime+"^"+allOutNum+"^"+exeAlertFlag+"^"+infusionLoopFlag+"^"+voiceFlag+"^"+jpRecControlFlag+"^"+pyfhControlFlag+"^"+hospitalID
	var setInfo = tkMakeServerCall("Nur.DHCNurPdaCommSet", "Save", parr);
	if(setInfo!="0"){
	 alert(setInfo);
	 return;
	}
	alert("操作成功")
}
var searchSetPanel = new Ext.Panel({
		title: "通用设置",
		layout:"form",
		tbar:[
			new Ext.Button({
				text:'保存',
				id:'commSave',
				icon:'../images/uiimages/filesave.png',
				handler:saveCommSet
			})],
		items: [{
				xtype: 'numberfield',	
				fieldLabel:'开始日期',
				labelStyle: 'text-align:right;',
				id: 'queryStartDate',
				validator :function(val){
					var reg = /^-?\d+$/;
					return reg.test(val);
				}
			},  {
				xtype: 'timefield',
				fieldLabel:'开始时间',
				format:'H:i',
				labelStyle: 'text-align:right;',
				id: 'queryStartTime',
			},  {
				xtype: 'numberfield',
				fieldLabel:'结束日期',
				labelStyle: 'text-align:right;',
				id: 'queryEndDate',
				validator :function(val){
					var reg = /^-?\d+$/;
					return reg.test(val);
				}
			},  {
				xtype: 'timefield',
				format:'H:i',
				fieldLabel:'结束时间',
				labelStyle: 'text-align:right;',
				id: 'queryEndTime',
			},  {
				xtype: 'textfield',
				fieldLabel:'全出区天数设置',
				labelStyle: 'text-align:right;',
				id: 'allOutNum',
			},{
					xtype: 'checkbox',
					fieldLabel:'执行医嘱弹框',
					labelStyle: 'text-align:right;',
					id: 'exeAlertFlag',
					listeners :{
						check:function(e,newVal){
							var limitExecBeforeMinutes=Ext.getCmp('infusionLoopFlag');
							if(!newVal){			
								limitExecBeforeMinutes.setValue("false");
							}
						}
					} 
			},{
					xtype: 'checkbox',
					fieldLabel:'输液闭环',
					labelStyle: 'text-align:right;',
					id: 'infusionLoopFlag',
					listeners :{
						check:function(e,newVal){
							var exeAlertFlag=Ext.getCmp('exeAlertFlag');
							if(newVal){			
								exeAlertFlag.setValue("true");
							}
						}
					}
			},{
					xtype: 'checkbox',
					fieldLabel:'语音识别',
					labelStyle: 'text-align:right;',
					id: 'voiceFlag'
			},{
					xtype: 'checkbox',
					fieldLabel:'静配接收控制',
					labelStyle: 'text-align:right;',
					id: 'jpRecControlFlag'
			},{
					xtype: 'checkbox',
					fieldLabel:'病区配液控制',
					labelStyle: 'text-align:right;',
					id: 'pyfhControlFlag'
			},{
					xtype: 'button',
					text:'巡 视 备 注',
					id: 'tourNoteList',
					icon: '../images/uiimages/register.png',
					handler : tourNoteListDifine
			},{
					xtype: 'button',
					text:'暂 停 备 注',
					id: 'supNoteList',
					icon: '../images/uiimages/register.png',
					handler : supNoteListDifine
			},{
					xtype: 'button',
					text:'停 止 备 注',
					id: 'stopNoteList',
					icon: '../images/uiimages/register.png',
					handler : stopNoteListDifine
			}
		]
});
	/*
	*通用设置手风琴布局panel
	*/
var InHosSetPanel = new Ext.Panel({  
       height: 350,	   
       layout: 'accordion',  
       title: '通用设置',
	   layoutConfig: {  
		 activeOnTop: true,  //设置打开的字面板置顶  
		 fill: true,         //字面板充满父面板的剩余空间  
		 titleCollapse: true,      //允许通过点击子面板的标题来展开或者收缩面板  
		 animate: true             //使用动画效果  
	   },  	   
       items: [searchSetPanel]   
});
Ext.onReady(onReady);
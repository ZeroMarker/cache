///PDA护理病历显示配置
///LMM
///2017-03-17

var selId="";
/*
///***User下拉框加载数据***
var userData = new Array();
function UserData(d, c) {
	userData.push({
				groupUserId : d,
				groupUserName : c
			});
}
tkMakeServerCall("web.DHCNurConSet", "getUserList",'UserData');
var userStoreModel = new Ext.data.JsonStore({
			data : userData,
			fields : ['groupUserId', 'groupUserName']
		});
///***end***///		
		

function onReady() {
	var selectionModel = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false
	});
	//左边科室列表
	var headsetList = new Ext.grid.GridPanel({
		region: "center",
		layout: "fit",
		id: "headsetList",
		loadMask: true,
		cm: new Ext.grid.ColumnModel({
			columns: [
				selectionModel, {
					header: "单据关键字",
					dataIndex: "EmrCode",
					width: 160
				}, {
					header: "出入量所在列",
					dataIndex: "Col",
					width: 80
				}, {
					header: "要显示的出入量名称",
					dataIndex: "Name",
					width: 160
				}, {
					header: "ID",
					dataIndex: "Rowid",
					width: 50
				}	
			]
		}),
		store: createStore({
			className: "Nur.DHCNurIODisplaySet",
			methodName: "getheadJson"
		}, ["EmrCode","Col", "Name", "Rowid"]),
		
		tbar: [		
			new Ext.Button({
				id: "addButton",
				text: "添加",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						var window = createGroupWindow("添加出入量名称显示配置");   //alert("新建")  //UnExcuteBun_OnClick()
						window.buttons[0].on("click", function() {
							var EmrCode = window.getComponent("formEmrCode").getValue();
							var Col = window.getComponent("formCol").getValue();
							var Name = window.getComponent("formName").getValue();	
							var parr = EmrCode+"^"+Col+"^"+Name+"^"
						    var resStr = tkMakeServerCall("Nur.DHCNurIODisplaySet", "Save", parr);
							if(resStr==""){
								alert("保存成功")
							}
							window.close();
							Ext.getCmp("finddataButton").fireEvent("click");
							
						});
						window.show();
					}
				}
			}),
			"-",
			
			new Ext.Button({
				id: "ExcuteBtn",
				text: "修改",
				listeners: {
					click: function() {
						var selComFlag="";
						var selobj = Ext.getCmp("headsetList").getSelectionModel().getSelected();
						if(selobj){
							selId=selobj.get("Rowid")
						}					
						if(selId==""){
							alert("请选择一条记录")
							return;
						}
						var window = createGroupWindow("修改显示名称");   //alert("新建")  //UnExcuteBun_OnClick()
						window.buttons[0].on("click", function() {
							var EmrCode = window.getComponent("formEmrCode").getValue();
							var Col = window.getComponent("formCol").getValue();
							var Name = window.getComponent("formName").getValue();							
							var parr=EmrCode+"^"+Col+"^"+Name+"^"+selId
						    var resStr = tkMakeServerCall("Nur.DHCNurIODisplaySet", "Save", parr);
							if(resStr==""){
								alert("保存成功")
							}
							window.close();
							Ext.getCmp("finddataButton").fireEvent("click");
						});
						var resStr = tkMakeServerCall("Nur.DHCNurIODisplaySet", "getHeadInfoById", selId);
						var groupArr=resStr.split("^");
						if(groupArr.length>2){
							window.getComponent("formEmrCode").setValue(groupArr[0]);
							window.getComponent("formCol").setValue(groupArr[1]);
							window.getComponent("formName").setValue(groupArr[2]);							
						}

						window.show();
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
						Ext.getCmp("headsetList").getStore().removeAll();
						loadData(Ext.getCmp("headsetList"), {
							className: "Nur.DHCNurIODisplaySet",
							methodName: "getheadJson"
						});
					}
				}
				
			})
		]
	});
	headsetList.getStore().load();

	///***加载界面***///
	var viewPore = new Ext.Viewport({
		layout: "border",
		items: [{
			region: "center",
			layout: "fit",
			id: "centerPanel",
			items: [headsetList]
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
*根目录定义
*/
function MenuDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	   
	    {header: "单据关键字",width:90,dataIndex:"menuName",editor:new Ext.form.Field()},
    	{header: "代码",width:60,dataIndex:"menuCode",editor:new Ext.form.Field()},
		{header: "显示顺序",width:60,dataIndex:"menuSort",editor:new Ext.form.Field()},
    	{header: "是否启用",width:100,dataIndex:"Name",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
		{header: "ID",width:20,dataIndex:"menuID"},
	]);
	
	var window =createEidtPanelWin({
		winID:"menuDefineWin",
		gridID:"menuDefine",
		cm:cloumnModel,
		fields:["menuName","menuCode","menuSort","Name","menuID"],
		className:"web.DHCNurPdaDepModelSet",
		methodName:"getMenuJson",
		forceFit:true,
		idField:"menuID"
	});
	window.show();
}

/**
*公共方法
*Note:创建编辑窗口
*obj配置项
*/
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
		Ext.MessageBox.alert("<提示>",ret==""?"保存成功！":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
/**
*公共方法
*Note:删除选中项
*/
function deleteSelected(gridID,idField)
{
	Ext.MessageBox.confirm("删除确认", "确定删除选中行吗？？" ,function (btId){
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
				Ext.MessageBox.alert("<提示>",ret==""?"操作成功！":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
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
/**
*模板配置窗口
*/
function createGroupWindow(title) {
	if (Ext.getCmp("verifiWindow")) {
		Ext.getCmp("verifiWindow").close();
	}

	var window = new Ext.Window({
		bodyStyle: "padding:5px;",
		id: "verifiWindow",
		width: 460,
		height: 200,
		title: title,
		resizable: false,
		layout: "form",
		items: [
		{
					id: "formEmrCode", 
					xtype: "textfield",
					fieldLabel: "单据关键字",
					width: 325,
					value: "",
					labelStyle: "font-size:18px"				
		},
		{
					id: "formCol",
					xtype: "textfield",
					fieldLabel: "出入量所在列",
					width: 225,
					value: "",					
					labelStyle: "font-size:18px",
					
		},
		{ 
					id: "formName",
					xtype: "textfield",
					fieldLabel: "要显示的出入量名称",
					width: 325,
					value: "",
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
Ext.onReady(onReady);
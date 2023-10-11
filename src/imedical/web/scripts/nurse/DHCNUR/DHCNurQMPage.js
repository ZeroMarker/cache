///科室诊断描述维护配置
///MRK
///2018-4-2

var setId=""
var LocId="";
var DescId="";
///***模板下拉框加载数据***///
var modelData = new Array();
function ModelData(a, b) {
	modelData.push({
				modelCode : a,
				modelName : b
			});
}
tkMakeServerCall("web.DHCNurQMPage", "getModelList", 'ModelData');
var storeModel = new Ext.data.JsonStore({
			data : modelData,
			fields : ['modelCode', 'modelName']
		});
var modelField = new Ext.form.ComboBox({
			id : 'modelCom',
			hiddenName : 'model',
			store : storeModel,
			width : 200,
			fieldLabel : '模板',
			valueField : 'modelCode',
			displayField : 'modelName',
			allowBlank : true,
			mode : 'local',
			anchor : '100%'
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
tkMakeServerCall("web.DHCNurQMPage", "getMenuList", 'MenuData');
var storeMenu = new Ext.data.JsonStore({
			data : menuData,
			fields : ['menuId', 'menuName']
		});	
///***end***///	

function onReady() {
	var selectionModel = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false
	});
	//左边科室列表
	var locList = new Ext.grid.GridPanel({
		region: "west",
		layout: "fit",
		id: "locList",
		loadMask: true,
		
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function() {
					var record = Ext.getCmp("locList").getSelectionModel().getSelected();
					LocId = record.get("locId");
					Ext.getCmp("modelList").setTitle("科室:" + record.get("LocName") );
					loadData(Ext.getCmp("modelList"), {
						className: "web.DHCNurQMPage",
						methodName: "getSetByloc",
						parameter1:LocId
					});
					
				}
			}
		}),
		cm: new Ext.grid.ColumnModel({
			columns: [
				selectionModel, {
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
			className: "web.DHCNurQMPage",
			methodName: "getLocJson"
		}, ["locName", "commonFlag", "locId"]),
		
		tbar: [		
			new Ext.Button({
				id: "unExcuteBtn",
				text: "诊断创建",
				handler : MenuDefine
			}),
			"-",
			
			new Ext.Button({
				id: "ExcuteBtn",
				text: "修改",
				listeners: {
					click: function() {
						var selComFlag="";
						var selobj = Ext.getCmp("locList").getSelectionModel().getSelected();
						if(selobj){
							setId=selobj.get("locId")
							selComFlag=selobj.get("commonFlag")
						}					
						if(LocId==""){
							alert("请选择一条记录")
							return;
						}
						var window = createLocWindow("维护科室");   //alert("新建")  //UnExcuteBun_OnClick()
						window.buttons[0].on("click", function() {
							
							var ComFlag = window.getComponent("formComFlag").getValue();
						    var resStr = tkMakeServerCall("web.DHCNurQMPage", "setLocComFlag", setId, ComFlag);
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
			new Ext.Button({
				id: "finddataButton",
				text: "查询",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						//var record = Ext.getCmp("locList").getSelectionModel().getSelected();
						//if(record) CurrentLocID=record.get("LocID");
						//else CurrentLocID = ""
						Ext.getCmp("locList").getStore().removeAll();
						loadData(Ext.getCmp("locList"), {
							className: "web.DHCNurQMPage",
							methodName: "getLocJson"
						});
					}
				}
				
			})
		]
	});
	locList.getStore().load();

	//中间模板列表
	var modelList = new Ext.grid.GridPanel({
		layout: "fit",
		region: "center",
		id: "modelList",
		cm: new Ext.grid.ColumnModel([{
			header: "诊断",
			dataIndex: "Question",
			width: 170
		}, {
			header: "描述",
			dataIndex: "QuestionDesc",
			width: 300
		},  
		{
			header: "编号",
			dataIndex: "sort",
			width: 300
		},
		{
			header: "ID",
			dataIndex: "setId",
			width: 300
		}]),
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function() {
					var record = Ext.getCmp("modelList").getSelectionModel().getSelected();
					setId = record.get("setId");
					//var menuId=tkMakeServerCall("web.DHCNurQMPage","SeachMenuID",setId);
					var subsselloc="^"+setId;
					Ext.getCmp("List").setTitle("科室:" );
					loadData(Ext.getCmp("List"), {
						className: "web.DHCNurQMPage",
						methodName: "getSetByDesc",
						parameter1:subsselloc
					});
					//alert(LocId);
				}
			}
		}),
		tbar: [
			new Ext.Button({
				id: "addButton",
				text: "添加",
				listeners: {
					click: function() {
						if(LocId==""){
								alert("请选择一间科室")
								return;
						}
						var window = createModelWindow("添加诊断描述");   //alert("新建")  //UnExcuteBun_OnClick()
						//var modelCodeObj=window.getComponent("formQuestion");
						//modelCodeObj.on('change', function(){
							//var modelCode = window.getComponent("formQuestion").getRawValue();
							//window.getComponent("formShowName").setValue(modelCode);
							//});
						window.buttons[0].on("click", function() {
							
							var menuId = window.getComponent("formQuestion").getValue();
							var sort = window.getComponent("formSort").getValue();
							var QuestionDesc = window.getComponent("formQuestionDesc").getValue();;
							
							var parr=sort+"^"+menuId+"^"+QuestionDesc+"^"+LocId+"^"+session['LOGON.USERID']+"^"
						    var resStr = tkMakeServerCall("Nur.DHCNurQMDesc", "Save", parr);
							if(resStr==""){
								alert("保存成功")
							}
							window.close();
							Ext.getCmp("findButton").fireEvent("click");
							
						});
						window.show();
					}
				}
			}),
			"-",
			new Ext.Button(
			{
				id: "updateButton",
				text: "修改",
				listeners:{
					click:function(){
						if(LocId==""){
								alert("请选择一间科室")
								return;
						}
						
						//alert(subsselloc)
						var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						if(subselobj){
							var setId=subselobj.get("setId");
							var Question=subselobj.get("Question");
							var QuestionDesc=subselobj.get("QuestionDesc");
							var sort=subselobj.get("sort");
							subsselloc=subselobj.get("setId");
						}
						else{
							alert("请选中一条记录")
							return;
						}
						
						var window = createModelWindow("修改描述");
						var MenuId=tkMakeServerCall("web.DHCNurQMPage", "SeachMenuID", setId);
						if(Question==""){
							var Question=tkMakeServerCall("web.DHCNurQMPage", "SearchQuestionName", MenuId);
						}
						if(setId){
							//valueField
							window.getComponent("formQuestion").setValue(Question);
							window.getComponent("formSort").setValue(sort);
							window.getComponent("formQuestionDesc").setValue(QuestionDesc);
							
						}
						
						window.buttons[0].on("click", function() {
							//alert(window.getComponent("formQuestion").getValue());
							if(Question==window.getComponent("formQuestion").getValue()){
								var menuId=MenuId;
								//alert(1);
							}else{
								var menuId = window.getComponent("formQuestion").getValue();
								//alert(2);
							}
							var sort = window.getComponent("formSort").getValue();
							var QuestionDesc = window.getComponent("formQuestionDesc").getValue();
							
							var parr=sort+"^"+menuId+"^"+QuestionDesc+"^"+LocId+"^"+session['LOGON.USERID']+"^"+subsselloc
						   var resStr = tkMakeServerCall("Nur.DHCNurQMDesc", "Save", parr);
							if(resStr==""){
								alert("保存成功")
							}
							window.close();
							Ext.getCmp("findButton").fireEvent("click");
							
						});
						window.show();
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "delButton",
				text: "删除",
				listeners: {
					click: function() {
							
						var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						if(subselobj){
							subsselloc=subselobj.get("setId")
						}
						//alert(subsselloc)
						if(LocId==""){
							alert("请选中一个子科室")
							return;
						}
						var resStr = tkMakeServerCall("Nur.DHCNurQMDesc", "Delete", subsselloc);
						if(resStr!="0"){
								//alert(resStr)
					    }
						var selobj = Ext.getCmp("locList").getSelectionModel().getSelected();
						if(selobj){
							selloc=selobj.get("locId")
						}
						Ext.getCmp("modelList").getStore().removeAll();	
						loadData(Ext.getCmp("modelList"), {
							className: "web.DHCNurQMPage",
							methodName: "getSetByloc",
							parameter1: selloc
						});
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
						loadData(Ext.getCmp("modelList"), {
							className: "web.DHCNurQMPage",
							methodName: "getSetByloc",
							parameter1: LocId
						});
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "importSubButton",
				text: "导入",
				listeners: {
					click: function() {
						importFromExcel("sub","modelList");
					}
				}
			})
						
		],
		store: createStore({
			className: "web.DHCNurQMPage",
			methodName: "getSetByloc"
		}, ["Question", "QuestionDesc","sort", "setId"]),
		viewConfig: {
			forceFit: true
		}
	});
	
	//右边模板列表
	var List = new Ext.grid.GridPanel({
		layout: "fit",
		region: "east",
		id: "List",
		cm: new Ext.grid.ColumnModel([{
			header: "措施",
			dataIndex: "planName",
			width: 100
		}, {
			header: "自定义措施",
			dataIndex: "planMeasure",
			width: 100
		},  
		{
			header: "ID",
			dataIndex: "planID",
			width: 100
		}]),
		tbar: [
			new Ext.Button({
				id: "add",
				text: "添加",
				listeners: {
					click: function() {
						
						var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						if(subselobj){
							subsselloc=subselobj.get("setId")
						var menuId=tkMakeServerCall("web.DHCNurQMPage","SeachMenuID",subsselloc);
						
						var window = createDescWindow("添加诊断描述");   //alert("新建")  //UnExcuteBun_OnClick()
						//var modelCodeObj=window.getComponent("formQuestion");
						//modelCodeObj.on('change', function(){
							//var modelCode = window.getComponent("formQuestion").getRawValue();
							//window.getComponent("formShowName").setValue(modelCode);
							//});
						window.buttons[0].on("click", function() {
							
							
							var planMeasure = window.getComponent("formplanMeasure").getValue();;
							var planMeasure=planMeasure.replace("\n","");
							
							var parr=menuId+"^"+subsselloc+"^"+planMeasure+"^"+session['LOGON.USERID']+"^"
							//alert(parr);
						    var resStr = tkMakeServerCall("Nur.DHCNurQMDescDetails", "Save", parr);
							if(resStr==""){
								alert("保存成功")
							}
							window.close();
							Ext.getCmp("find").fireEvent("click");
							
							});
							window.show();}
						else{ 
						alert("请选择一项措施");
						}
					}
				}
			}),
			"-",
			new Ext.Button(
			{
				id: "update",
				text: "修改",
				listeners:{
					click:function(){
						if(LocId==""){
								alert("请选择一间科室")
								return;
						}
						if(setId==""){
							alert("请选择一项措施")
							return;
						}
						//alert(subsselloc)
						var subselobj = Ext.getCmp("List").getSelectionModel().getSelected();
						if(subselobj){
							var planID=subselobj.get("planID");
							
							var planMeasure=subselobj.get("planMeasure");
							var sort=subselobj.get("sort");
							subsselloc=subselobj.get("planID");
						}
						else{
							alert("请选中一条记录")
							return;
						}
						
						var window = createDescWindow("修改自定义措施");
						if(subsselloc){
							//valueField
							window.getComponent("formplanMeasure").setValue(planMeasure);
							
						}
						var MenuId=tkMakeServerCall("web.DHCNurQMPage", "SeachMenuID", setId);
						//alert(MenuId);
						window.buttons[0].on("click", function() {
						
							var planMeasure = window.getComponent("formplanMeasure").getValue();
							var planMeasure=planMeasure.replace("\n","");
							
							var parr=MenuId+"^"+setId+"^"+planMeasure+"^"+session['LOGON.USERID']+"^"+subsselloc
						    var resStr = tkMakeServerCall("Nur.DHCNurQMDescDetails", "Save", parr);
							if(resStr==""){
								alert("保存成功")
							}
							window.close();
							Ext.getCmp("find").fireEvent("click");
							
						});
						window.show();
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "del",
				text: "删除",
				listeners: {
					click: function() {
						if(LocId==""){
								alert("请选择一间科室")
								return;
						}
						if(setId==""){
							alert("请选择一项措施")
							return;
						}
						
						var subselobj = Ext.getCmp("List").getSelectionModel().getSelected();
						if(subselobj){
							subsselloc=subselobj.get("planID")
						}
						//alert(subsselloc)
						if(subsselloc==""){
							alert("请选中一个自定义措施")
							return;
						}
						var resStr = tkMakeServerCall("Nur.DHCNurQMDescDetails", "Delete", subsselloc);
						
						//var selobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						//if(selobj){
							//selloc=selobj.get("setId")
						//}
						
							Ext.getCmp("find").fireEvent("click");
					}
				}
			}),
			"-",
			new Ext.Button({
				id: "find",
				text: "查询",
				icon: '../images/uiimages/search.png',
				listeners: {
					click: function() {
						Ext.getCmp("List").getStore().removeAll();	
						var subselobj = Ext.getCmp("modelList").getSelectionModel().getSelected();
						if(subselobj){
							subsselloc=subselobj.get("setId")
						//var menuId=tkMakeServerCall("web.DHCNurQMPage","SeachMenuID",setId);		
						//var TotalDescId="setId^menuId"
						var subsselloc="^"+subsselloc;
						Ext.getCmp("List").setTitle("自定义措施" );
							loadData(Ext.getCmp("List"), {
								className: "web.DHCNurQMPage",
								methodName: "getSetByDesc",
								parameter1:subsselloc
								
							});
						}
						else{
							alert("请选择措施");
						}
					}
				}
			})
		],
		store: createStore({
			className: "web.DHCNurQMPage",
			methodName: "getSetByDesc"
		}, ["planName", "planMeasure","planID"]),
		viewConfig: {
			forceFit: true
		}
	});
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
			layout: "fit",
			id: "centerPanel",
			
			items: [modelList]
		},
		{
			region: "east",
			layout: "fit",
			id: "eastPanel",
			width: 600,
			items: [List]
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
*导入
*/
function importFromExcel(flag,gridID) { 
	var excelApp; 
	var excelWorkBook; 
	var excelSheet; 
	var fileName="C:\\hljh-"+flag+".xlsx"
	try{ 
		excelApp = new ActiveXObject("Excel.Application"); 
		excelWorkBook = excelApp.Workbooks.open(fileName); 
		excelSheet = excelWorkBook.ActiveSheet; 
		var startRow=excelSheet.Cells(2,3).value
		var endRow=excelSheet.Cells(2,4).value
		if((startRow=="")||(endRow=="")){
			alert("请填写起始行和截止行");
			return;
		}
		var sortNo = tkMakeServerCall("web.DHCNurQMPage","getLastSortNo");
		for(i=startRow;i<=endRow;i++){
			if(flag=="main"){
				var sortNo = tkMakeServerCall("web.DHCNurQMPage","getLastSortNo");
				var saveStr=excelSheet.Cells(i,1).value+"^"+sortNo+"^Y^^"+session['LOGON.USERID'];
				var ret = tkMakeServerCall("Nur.DHCNurQMEmrMenu","Save",saveStr);
			}
			if(flag=="sub"){
				var menuIdStr = tkMakeServerCall("web.DHCNurQMPage","getMenuIdBydesc",excelSheet.Cells(i,1).value);
				if(menuIdStr=="^") continue;
				var menuIdArr=menuIdStr.split("^");
				var parr=menuIdArr[1]+"^"+menuIdArr[0]+"^"+excelSheet.Cells(i,2).value+"^"+LocId+"^"+session['LOGON.USERID']+"^"
				var resStr = tkMakeServerCall("Nur.DHCNurQMDesc", "Save", parr);
			}
		}
		alert("操作成功");
		excelSheet.usedrange.rows.count;//使用的行数 
		excelWorkBook.Worksheets.count;//得到sheet的个数 
		excelSheet=null; 
		excelWorkBook.close(); 
		excelApp.Application.Quit(); 
		excelApp=null; 
	}catch(e){ 
		if(excelSheet !=null || excelSheet!=undefined){ 
		excelSheet =nul; 
		} 
		if(excelWorkBook != null || excelWorkBook!=undefined){ 
	
		} 
		if(excelApp != null || excelApp!=undefined){ 
		excelApp.Application.Quit(); 
		excelApp=null; 
		} 
	} 
	if(flag=="sub"){
		Ext.getCmp("modelList").getStore().removeAll();					
		var modelCom = Ext.getCmp("modelCom").getValue();
		loadData(Ext.getCmp("modelList"), {
			className: "web.DHCNurQMPage",
			methodName: "getSetByloc",
			parameter1: LocId
		});
	}else{
		
	Ext.getCmp(gridID).getStore().load();
	}
}
/*
*根目录定义
*/
function MenuDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	   
	    {header: "诊断名称",width:90,dataIndex:"QuestionName",editor:new Ext.form.Field()},
		{header: "显示顺序",width:60,dataIndex:"MenuSort",editor:new Ext.form.Field()},
    	{header: "是否启用",width:100,dataIndex:"CanFlag",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
		{header: "ID",width:20,dataIndex:"menuID"},
	]);
	
	var window =createEidtPanelWin({
		winID:"menuDefineWin",
		gridID:"menuDefine",
		cm:cloumnModel,
		fields:["QuestionName","MenuSort","CanFlag","menuID"],
		className:"web.DHCNurQMPage",
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
				text:"导入",
				handler:function(){
						importFromExcel("main",obj.gridID);
				}
			}),
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
		var ret = tkMakeServerCall("Nur.DHCNurQMEmrMenu","Save",saveStr);
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
				var ret = tkMakeServerCall("Nur.DHCNurQMEmrMenu","Delete",IDStr)
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
function createModelWindow(title) {
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
					id: "formQuestion",
					xtype: "combo",
					fieldLabel: "诊断",
					width: 225,
					store:storeMenu,
					labelStyle: "font-size:18px",
					valueField : 'menuId',
					displayField : 'menuName',
					allowBlank : true,
					mode : 'local',
					anchor : '100%'					
		},
		{ 
					id: "formSort", 
					xtype: "textfield",
					fieldLabel: "编号",
					width: 325,
					value: "",
					labelStyle: "font-size:18px"
		},
		{ 
					id: "formQuestionDesc", 
					xtype: "textfield",
					fieldLabel: "描述",
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
	});
	
	return window
}
/**
*自定义措施配置窗口
*/
function createDescWindow(title) {
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
					id: "formplanMeasure", 
					xtype: "textarea",
					fieldLabel: "自定义措施",
					width: 325,
					Height:160,
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
	});
	
	return window
}
Ext.onReady(onReady);
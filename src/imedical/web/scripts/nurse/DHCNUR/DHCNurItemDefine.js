/**
*护士执行单据设置-- 按钮定义、列定义和 操作类型定义
*DHCNurItemDefine.js
*lvxin
*2014-09-02
*/

/**
*Note:按钮定义
*用公共方法保存 cloumnModel 列顺序必须保持和 后台save方法对应
*buttonDefine 类：Nur.NurseExcuteButtons.cls
*保存:save()
*删除:delete()
*/
function buttonDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	    {header: "ID",width:20,dataIndex:"buttonID"},
	    {header: "按钮描述",width:90,dataIndex:"buttonDesc",editor:new Ext.form.Field()},
    	{header: "按钮名称",width:60,dataIndex:"buttonName",editor:new Ext.form.Field()},
		{header: "代码",width:60,dataIndex:"buttonCode",editor:new Ext.form.Field()},
    	{header: "JS函数",width:100,dataIndex:"jsFunction",editor:new Ext.form.Field()},
		{header: "图片名称",width:100,dataIndex:"iconName",editor:new Ext.form.Field()},
		{header: "弹窗",width:50,dataIndex:"ifShowWindow",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},
    	{header: "单签",width:50,dataIndex:"ifSign",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"],
			listeners:{
				'change':function(feild,newValue,oldValue ){
					var grid = Ext.getCmp('buttonDefine');
					var selections = grid.getSelectionModel().getSelections();
					var store = grid.getStore();
					var selectData = selections[0];
					var dataIndex = store.indexOf(selectData);
					var record = grid.getStore().getAt(dataIndex);   //Get the Record
					var ifDoubleSign = record.get("ifDoubleSign");
					if(newValue=='Y'&&ifDoubleSign=='Y'){
						record.set("ifDoubleSign","N");
						return;
					}
				}
			}
		})},  
    	{header: "双签",width:50,dataIndex:"ifDoubleSign",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"],
			listeners:{
				'change':function(feild,newValue,oldValue ){
					var grid = Ext.getCmp('buttonDefine');
					var selections = grid.getSelectionModel().getSelections();
					var store = grid.getStore();
					var selectData = selections[0];
					var dataIndex = store.indexOf(selectData);
					var record = grid.getStore().getAt(dataIndex);   //Get the Record
					var ifSign = record.get("ifSign");
					if(newValue=='Y'&&ifSign=='Y'){
						record.set("ifSign","N");
						return;
					}
				}
			}
		})},
    	{header: "操作类型",hidden:true,width:70,dataIndex:"operationType",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			valueField:"operationID",
			displayField :"operationTypeDesc",
			store:new Ext.data.JsonStore({
				url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getOperationType",
				fields:["operationID","operationTypeDesc"],
				root:"rowData"
			})
		})},
		{header: "打印标记",width:60,dataIndex:"printFlag",editor:new Ext.form.Field()},
	]);
	
	var window =createEidtPanelWin({
		winID:"buttonDefineWin",
		gridID:"buttonDefine",
		cm:cloumnModel,
		fields:["buttonID","buttonDesc","buttonName","buttonCode","jsFunction","iconName","ifShowWindow","ifSign","ifDoubleSign","operationType","printFlag"],
		className:"Nur.NurseSheetSetCom",
		methodName:"getButtons",
		forceFit:true,
		MainClass:"Nur.NurseExcuteButtons",
		idField:"buttonID"
	});
	window.show();
}
/**
*Note:操作类型定义
*用公共方法保存 cloumnModel 列顺序必须保持和 后台save方法对应
*operationDefine 类：Nur.NurseOperationType.cls
*保存:save()
*删除:delete()
*/
function operationDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	    {header: "ID",width:20,dataIndex:"operationID"},
	    {header: "操作类型",width:60,dataIndex:"operationTypeCode",editor:new Ext.form.Field()},
    	{header: "操作类型描述",width:100,dataIndex:"operationTypeDesc",editor:new Ext.form.Field()}
	]);
	var window =createEidtPanelWin({
		winID:"operationDefineWin",
		gridID:"operationDefine",
		cm:cloumnModel,
		fields:["operationID","operationTypeCode","operationTypeDesc"],
		className:"Nur.NurseSheetSetCom",
		methodName:"getOperationType",
		forceFit:true,
		MainClass:"Nur.NurseOperationType",
		idField:"operationID"
	});
	window.show();
}
/**
*Note:列定义
*用公共方法保存 cloumnModel 列顺序必须保持和 后台save方法对应
*columnDefine 类：Nur.NurseExcuteColumns.cls
*保存:save()
*删除:delete()
*/
function columnDefine()
{
	var cloumnModel = new Ext.grid.ColumnModel([
	    {header: "ID",width:20,dataIndex:"columnID"},
	    {header: "列名",width:60,dataIndex:"varDesc",editor:new Ext.form.Field()},
    	{header: "代码",width:60,dataIndex:"varCode",editor:new Ext.form.Field()},
		{header: "列宽",width:20,dataIndex:"columnWidth",editor:new Ext.form.Field()},
		{header: "是否显示子医嘱",width:50,dataIndex:"ifShowSubOrder",editor:new Ext.form.ComboBox({
			triggerAction:"all",
			store:["Y","N"]
		})},  
		{header: "绑定函数",width:200,dataIndex:"funCode",editor:new Ext.form.Field()}
	]);
	var window =createEidtPanelWin({
		winID:"columnDefineWin",
		gridID:"columnDefine",
		cm:cloumnModel,
		fields:["columnID","varDesc","varCode","columnWidth","ifShowSubOrder","funCode"],
		className:"Nur.NurseSheetSetCom",
		methodName:"getColumns",
		forceFit:true,
		MainClass:"Nur.NurseExcuteColumns",
		idField:"columnID"
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
				icon:'../images/uiimages/edit_add.png',
				handler:function(){
					insertNewRecord(obj.fields,obj.gridID);
				}
			}),
			new Ext.Button({
				text:"保存",
				icon:'../images/uiimages/filesave.png',
				handler:function(){
				saveDefines(obj.gridID,obj.MainClass)
				}
			}),
			new Ext.Button({
				text:"删除",
				icon:'../images/uiimages/edit_remove.png',
				handler:function(){
				deleteSelected(obj.gridID,obj.MainClass,obj.idField)
				}
			}),
			new Ext.Button({
				text:"取消",
				icon:'../images/uiimages/cancel.png',
				handler:function (){
					window.close();
				}
			})
		],
		listeners:{close:function(){
			Ext.getCmp("sheetButtons").getStore().removeAll();
			Ext.getCmp("sheetColumn").getStore().removeAll();
			Ext.getCmp("sheetButtons").getStore().load();
			Ext.getCmp("sheetColumn").getStore().load();
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
	Ext.getCmp(gridID).startEditing( count, 1 ) ;
}
/**
*公共方法
*Note:保存设置
*/
function saveDefines(gridID,saveClass)
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
			dataStr=dataStr+String.fromCharCode(135)+cellVal;
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
				saveStr=saveStr+String.fromCharCode(138)+dataStr
			}
		}
	}
	if(saveStr!="")
	{
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		var ret = tkMakeServerCall("Nur.NurseSheetSetCom","saveDefines",saveClass,saveStr);
		Ext.MessageBox.alert("<提示>",ret==""?"保存设置成功！":ret);
	}
	Ext.getCmp(gridID).getStore().load();
}
/**
*公共方法
*Note:删除选中项
*/
function deleteSelected(gridID,deleteClass,idField)
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
				IDStr=IDStr==""?ID:IDStr+String.fromCharCode(135)+ID
			}
			if(IDStr!="")
			{
				var ret = tkMakeServerCall("Nur.NurseSheetSetCom","deleteDefines",deleteClass,IDStr)
				Ext.MessageBox.alert("<提示>",ret==""?"操作成功！":ret);
			}
 			Ext.getCmp(gridID).getStore().load();
		}
	});	
}
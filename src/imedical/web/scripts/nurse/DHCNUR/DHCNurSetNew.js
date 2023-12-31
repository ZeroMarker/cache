/**
*护士执行单据设置 
*DHCNurSetNew.js
*lvxin
*2014-08-28
* 其中 按钮定义、列定义和 操作类型定义 在DHCNurItemDefine.js中
*/
var ordCatJsonStore,specJsonStore,locJsonStore,hosptalComboBox,thisHospId;
console.log(896);
function onLoad()
{
	/**
	*单据设置 gridPanel
	*/
	// var hospComp=GenHospComp("ARC_ItemCat","1^1^1^2");
	thisHospId=tkMakeServerCall("web.DHCBL.BDP.BDPMappingHOSP","GetDefHospIdByTableName","Nur_IP_NurseSheetSet",session['LOGON.HOSPID'])
	console.log(thisHospId);
	var hospComp=GenHospComp("Nur_IP_NurseSheetSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	var hospDS= hospComp.store;
	hospDS.root="data";
	hospDS.load({
		callback:function() {
			hosptalComboBox.setValue(thisHospId);
		}
	});
	// hospDS.load()
	console.log(5757);
	// var hospDS1= new Ext.data.JsonStore({
	// 					url: "../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getHospital",
	// 					root: "rowData",
	// 					fields: ['ID', 'DESC']
	// 				});
	// 	hospDS1.load();
	var sheetSetGrid = new Ext.grid.EditorGridPanel({
		id:"sheetSetGrid",
		layout :"fit",
		columnWidth : .45,
		clicksToEdit:2,
		height:350,
		tbar:[
			new Ext.form.Label({
				text:"代码："
			}),
			new Ext.form.TextField({
				id:"code",
				width:60
			}),
			new Ext.form.Label({
				text:"医院名称："
			}),
			hosptalComboBox=new Ext.form.ComboBox ({
				id:"hospitalName",
				// valueField:"ID",
				// displayField :"DESC",
				valueField:"HOSPRowId",
				displayField :"HOSPDesc",
				width:164,
				editable:false,
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
			new Ext.Button({				
				text:'查询',
				icon:'../images/uiimages/search.png',
				handler:function(){
					Ext.getCmp("sheetSetGrid").getStore().load({});
					initCommSet()
					ordCatJsonStore.load({
					  params: {parameter1:Ext.getCmp("hospitalName").getValue()}
					})
					specJsonStore.load({
					  params: {parameter1:Ext.getCmp("hospitalName").getValue()},
					  callback:function (){
						Ext.getCmp("sheetSetGrid").getSelectionModel().selectFirstRow();
						}
					})
					// locJsonStore.load({
					//   params: {parameter1:Ext.getCmp("hospitalName").getValue()},
					//   callback:function (){
					// 	Ext.getCmp("sheetSetGrid").getSelectionModel().selectFirstRow();
					// 	}
					// })
				}
			}),
			new Ext.Button({
				text:'新建',
				icon:'../images/uiimages/edit_add.png',
				handler:function (){
					var hospitalID = Ext.getCmp("hospitalName").getValue();
					if(hospitalID=="")
					{
						hospitalID=0;
					}
					var store = Ext.getCmp("sheetSetGrid").getStore();
					var count = store.getCount();
					var record = new Ext.data.Record({ID:'',code:'',name:'',fileName:'',pat:'',printLine:'',startDate:'',startTime:'',endDate:'',endTime:'',hospitalName:'',tHospitalRowId:hospitalID,executeRecordFlag:''});
					store.insert(count,record)
					Ext.getCmp("sheetSetGrid").startEditing( count, 1 ) ;
				}
			}),
			new Ext.Button({
				text:'删除',
				icon:'../images/uiimages/edit_remove.png',
				handler:function (){
				Ext.MessageBox.confirm("删除确认", "确定删除选中行吗？？" ,function (btId){
				if(btId=="yes")
				{
					var record =Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected();
					if(record){
							var ID = record.get("ID");
							var ret = tkMakeServerCall("Nur.NurseSheetSet","delete",ID);
							if(ret=="0")
							{
								Ext.MessageBox.alert("<提示>","删除成功！");
							}
							else{
								Ext.MessageBox.alert("<提示>","删除失败！");
							}					
					}
					Ext.getCmp("sheetSetGrid").getStore().load({callback:function (){
						Ext.getCmp("sheetSetGrid").getSelectionModel().selectFirstRow();
					}});
				}
				});
			}}),
			"->",
			new Ext.Button({
				text:'保存',
				icon:'../images/uiimages/filesave.png',
				handler:saveSheetSet
			}),
			"-",
			new Ext.Button({
				text:'按钮',
				icon:'../images/uiimages/arcossets.png',
				handler:buttonDefine 	//DHCNurItemDefine.js
			}),
			new Ext.Button({
				text:'操作类型定义',
				icon:'../images/uiimages/arcossets.png',
				handler:operationDefine,   //DHCNurItemDefine.js
				hidden :true
			}),
			new Ext.Button({
				text:'列定义',
				icon:'../images/uiimages/list.png',
				handler:columnDefine   //DHCNurItemDefine.js
			})],
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{rowselect:function(){
				Ext.getCmp("sheetButtons").getStore().removeAll();
				Ext.getCmp("sheetColumn").getStore().removeAll();
				Ext.getCmp("sheetButtons").getStore().load();
				Ext.getCmp("sheetColumn").getStore().load();
				initFilter();
			}}
		}), 
		colModel:new Ext.grid.ColumnModel([
			{header: "ID",  width:90,dataIndex:"ID",hidden:true},
			{header: "代码",  width:90,dataIndex:"code",editor:new Ext.form.Field()},
			{header: "名称", width:140,dataIndex:"name",editor:new Ext.form.Field()},
			{header: "文件名",width:120,dataIndex:"fileName",editor:new Ext.form.Field()},
			//{header: "按病人",width:70,dataIndex:"pat",editor:new Ext.form.Field()},
			//{header: "打印边框", width:80,dataIndex:"printLine",editor:new Ext.form.Field()},
			{header: "查询开始日期",hidden:true,width:150,dataIndex:"startDate",editor:new Ext.form.Field()},
			{header: "查询开始时间",hidden:true,width:150,dataIndex:"startTime",editor:new Ext.form.Field()},
			{header: "查询结束日期",hidden:true, width:150,dataIndex:"endDate",editor:new Ext.form.Field()},
			{header: "查询结束时间",hidden:true,width:150,dataIndex:"endTime",editor:new Ext.form.Field()},
			{
				header: "医院名",
				editor: new Ext.form.ComboBox({
					id:"hospitalCmb",
					// valueField: "ID",
					// displayField: "DESC",
					valueField:"HOSPRowId",
					displayField :"HOSPDesc",
					width: 140,
					minChars: 0,
					triggerAction: "all",
					forceSelection: true,
					selectOnFocus: true,
					store:hospDS
				}),
				renderer: function (value, cellmeta, record) {
					var initIndex=hospDS.find(Ext.getCmp('hospitalCmb').displayField, value);
					if(initIndex>-1){
						var index=initIndex;	
					}else{
						//通过匹配value取得ds索引
						var index = hospDS.find(Ext.getCmp('hospitalCmb').valueField, value);
					}					
					//通过索引取得记录ds中的记录集
					var record = hospDS.getAt(index);
					//返回记录集中的value字段的值
					if (record) {
						// return record.data.DESC;
						return record.data.HOSPDesc;
					}
					return "";
				},
				width: 150,
				dataIndex: "hospitalName"
			},
			{header: "医院ID",width:70,dataIndex:"tHospitalRowId",hidden:true},
			{
				header: "执行记录单据",width:100,dataIndex:"executeRecordFlag",editor:new Ext.form.Checkbox({
					inputValue : true ? 'Y' : 'N'	
				}),
				renderer: function(value,cellmeta,record){
					return record.data.executeRecordFlag && record.data.executeRecordFlag=="Y" ? "是" : ""					
				}
			},
 		]),
		store:new Ext.data.JsonStore({
			pageSize:10,
			url:"../csp/dhc.nurse.extjs.getdata.csp",
			root:"rowData",
			fields:['ID','code','name','fileName','startDate','startTime','endDate','endTime','hospitalName','tHospitalRowId','executeRecordFlag'], //,'pat','printLine'
			listeners:{beforeLoad:function (){
				var store = Ext.getCmp("sheetSetGrid").getStore();
				store.baseParams.className = "Nur.NurseSheetSetCom";
				store.baseParams.methodName="getNurseSheets";
				store.baseParams.parameter1=Ext.getCmp("code").getValue();
				store.baseParams.parameter2=Ext.getCmp("hospitalName").getValue();
			}}
		})
	});// end sheetSetGrid
	
	/**
	*单据按钮 gridPanel
	*/
	var sheetButtons = new Ext.grid.GridPanel({
		id:"sheetButtons",
		layout :"fit",
		columnWidth : .17, 
		height:350,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true
		}),
		tbar:[
			new Ext.Button({
				text:'添加按钮',
				icon:'../images/uiimages/edit_add.png',
				handler:addButtons
			}),
			new Ext.Button({
				text:'移除',
				icon:'../images/uiimages/edit_remove.png',
				handler:function(){
					var selectRecore = Ext.getCmp("sheetButtons").getSelectionModel().getSelected();
					if(selectRecore)
					{
						var store =Ext.getCmp("sheetButtons").getStore();
						store.remove(selectRecore);
					}
				}
			}),
			new Ext.Button({
				text:'上移',
				icon:'../images/uiimages/moveup.png',
				id:"buttonMoveUp",
				handler:function(){
				moveRecord(Ext.getCmp("sheetButtons"),"U")
				}
			}),
			new Ext.Button({
				text:'下移',
				icon:'../images/uiimages/movedown.png',
				id:"buttonMoveDown",
				handleMouseEvents:true,
				handler:function(){
				moveRecord(Ext.getCmp("sheetButtons"),"D")
				}
			})],
		colModel:new Ext.grid.ColumnModel([
			{header: "ID",  width:100,sortable: true,dataIndex:"ID",hidden:true},
			{header: "名称",  width:100,sortable: true,dataIndex:"name"},
			{header: "描述", width:100,sortable: true,dataIndex:"desc"}
		]),
	    viewConfig:{
			forceFit:true
		},
		store:new Ext.data.JsonStore({
			url:"../csp/dhc.nurse.extjs.getdata.csp",
			root:"rowData",
			fields:['ID','name','desc'],
			listeners:{beforeLoad:function (){
				var store = Ext.getCmp("sheetButtons").getStore();
				store.baseParams.className = "Nur.NurseSheetSetCom";
				store.baseParams.methodName="getSheetButtons";
				store.baseParams.parameter1=Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected()?Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected().get("ID"):""; 
			}}
		})
	});//end sheetButtons
	
	/**
	*单据 列定义 gridPanel
	*/
	var sheetColumn = new Ext.grid.GridPanel({
		id:"sheetColumn",
		layout :"fit",
		columnWidth : .17, 
		height:350,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true
		}),
		tbar:[
			new Ext.Button({
				text:'添加列',
				icon:'../images/uiimages/edit_add.png',
				handler:addSheetColumns 
			}),
			new Ext.Button({
				text:'移除',
				icon:'../images/uiimages/edit_remove.png',
				handler:function(){
					var selectRecore = Ext.getCmp("sheetColumn").getSelectionModel().getSelected();
					if(selectRecore)
					{
						var store =Ext.getCmp("sheetColumn").getStore();
						store.remove(selectRecore);
					}
				}
			}),
			new Ext.Button({
				text:'上移',
				icon:'../images/uiimages/moveup.png',
				id:"columnMoveUp",
				handleMouseEvents:true,
				handler:function(){
				moveRecord(Ext.getCmp("sheetColumn"),"U")
				}
			}),
			new Ext.Button({
				text:'下移',
				icon:'../images/uiimages/movedown.png',
				id:"columnMoveDown",
				handleMouseEvents:true,
				handler:function(){
				moveRecord(Ext.getCmp("sheetColumn"),"D")
				}
			})],
		colModel:new Ext.grid.ColumnModel([
			{header: "ID",  width:100,sortable: true,dataIndex:"ID",hidden:true},
			{header: "名称",  width:100,sortable: true,dataIndex:"name"},
			{header: "代码", width:100,sortable: true,dataIndex:"code"}
		]),
		 viewConfig:{
			forceFit:true
		},
		store:new Ext.data.JsonStore({
			url:"../csp/dhc.nurse.extjs.getdata.csp",
			root:"rowData",
			fields:['ID','name','code'],
			listeners:{beforeLoad:function (){
				var store = Ext.getCmp("sheetColumn").getStore();
				store.baseParams.className = "Nur.NurseSheetSetCom";
				store.baseParams.methodName="getSheetColumns";
				store.baseParams.parameter1=Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected()?Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected().get("ID"):""; 
			}}
		})
	});//end sheetColumn
	
	var viewPort = new Ext.Viewport({
		layout:"border",
		items:[
			{
				region:"north",
				xtype:"panel",
				id:"northRegion",
				layout:"column",				
				height:350,
				items:[
					sheetSetGrid,
					sheetButtons,
					sheetColumn,
					InHosSetPanel
				]
			},
			{
				region:"center",
				id:"centerRegion",
				xtype:"panel",
				layout:"column",
				defaults: {
					layout:'fit',
					style: {
						padding: '1px'
					}
				},
				tbar:[
					new Ext.Button({
						text:"保存设置",
						icon:'../images/uiimages/filesave.png',
						handler:saveFilter
					})
				],
				items:[]
			}		
		]
	});// end Viewport
	reloadCenterRegion()
	initCommSet();
}//end function onLoad
function reloadCenterRegion() {
	Ext.getCmp("centerRegion").add(createPanel("disposeStat","处置状态","Nur.NurseSheetSetCom","getDisposeStat",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("oecpr","医嘱优先级","Nur.NurseSheetSetCom","getOecpr",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("ordCat","医嘱分类","Nur.NurseSheetSetCom","getOrdCat",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("ordStat","医嘱状态","Nur.NurseSheetSetCom","getOrdStat",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("ordPhcin","医嘱用法","Nur.NurseSheetSetCom","getOrdPhcin",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("ordStage","医嘱阶段","Nur.NurseSheetSetCom","getOrdStage",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("specCode","标本名称","Nur.NurseSheetSetCom","GetGroupHospSpecCode",.125,1));
	Ext.getCmp("centerRegion").add(createPanel("recloc","接收科室","Nur.NurseSheetSetCom","getRecloc",.125,1));
	Ext.getCmp("sheetSetGrid").getStore().load({callback:function (){
		setTimeout("Ext.getCmp('sheetSetGrid').getSelectionModel().selectFirstRow();",1500);
	}});
}
/**
*Note:保存单据设置
*/
function saveSheetSet()
{
	/*
	*	基本设置
	* 	修改过（包括新增）才保存
	*/
	var errorStr="";  
	Ext.getCmp("sheetSetGrid").stopEditing(false);
	var saveStr=""
	var store = Ext.getCmp("sheetSetGrid").getStore(); 
	var count = store.getCount();
	for(var index = 0;index<count;index++)
	{
		var rowRecord = store.getAt(index);
		if (!rowRecord.get('hospitalName')) {
			Ext.MessageBox.alert("<提示>","医院不能为空！");
			return;
		}
		var modefiedFlag=false;
		var dataStr="";
		var modifiedKey="";
		for(var key in rowRecord.data)
		{
			if (('pat'==key)||('printLine'==key)) continue;
			if(rowRecord.isModified(key)==true)
			{
				modifiedKey=key;
				modefiedFlag=true;
			}
			var cellVal= rowRecord.get(key);
			if ('hospitalName'!=modifiedKey) {
				if ('hospitalName'==key) {
					cellVal= rowRecord.get('tHospitalRowId');
				} else if ('tHospitalRowId'==key) {
					cellVal= rowRecord.get('hospitalName');
				}
			}
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
		console.log(saveStr);
		saveStr=saveStr.replace(/"/ig,String.fromCharCode(129));
		console.log(saveStr);
		var ret = tkMakeServerCall("Nur.NurseSheetSetCom","saveSheets",saveStr);
		if(ret!="")
		{
			errorStr=errorStr+"</br>"+ret;
		}
	}
	/*
	*	按钮和列设置
	*/
	var record = Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected();
	if(record)
	{
		var ID = record.get("ID");
		var buttonIDStr =getStoreIDStr(Ext.getCmp("sheetButtons"),"ID",false);
		var columnIDStr=getStoreIDStr(Ext.getCmp("sheetColumn"),"ID",false);
		if (ID&&buttonIDStr) {
			var ret = tkMakeServerCall("Nur.NurseSheetSet","saveButtons",ID,buttonIDStr);
			if(ret!="0") errorStr=errorStr+"</br>"+"按钮保存失败";
		}
		if (ID&&columnIDStr) {
			var ret = tkMakeServerCall("Nur.NurseSheetSet","saveColumns",ID,columnIDStr);
			if(ret!="0") errorStr=errorStr+"</br>"+"列保存失败";
		}
	}
	Ext.MessageBox.alert("<提示>",errorStr==""?"操作成功！":errorStr);
	//刷新后保持现选中的行
	var currentSelectIndex = Ext.getCmp("sheetSetGrid").getStore().indexOf(record);
	Ext.getCmp("sheetSetGrid").getStore().load({callback:function(){
		Ext.getCmp("sheetSetGrid").getSelectionModel().selectRow(currentSelectIndex);
	}});
}

/**
*Note:保存单据过滤设置
*d ##class(Nur.NurseSheetSet).saveFilter()
*/
function saveFilter()
{
	var gridIDArray = ["disposeStat","oecpr","ordCat","ordStat","ordPhcin","ordStage","specCode","recloc"];
	var record = Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected();
	if(record)
	{
		var ID = record.get("ID");
	}
	else return;
	var ret="";
	var codeStr="var ret=tkMakeServerCall('Nur.NurseSheetSet','saveFilter','"+ID+"'";
	for(var i=0;i<gridIDArray.length;i++)
	{
		codeStr=codeStr+",'"+getStoreIDStr(Ext.getCmp(gridIDArray[i]),"ID",true)+"'";
	}
	codeStr=codeStr+")";
	eval(codeStr);
	Ext.MessageBox.alert("提示",ret=="0"?"	保存成功！	":"	 保存失败！	");

}
/**
*Note:获取grid里面的ID串
*gridObj:grid对象
*idField：ID字段名
*selected:true 为取选中的 false 为取所有数据
*保存设置时用
*/
function getStoreIDStr(gridObj,idField,selected)
{
	var store = gridObj.getStore();
	var idStr = "";
	if(!selected)
	{
		store.each(function (rec){
			var ID = rec.get(idField);
			idStr=idStr==""?ID:idStr+"^"+ID;
		});
	}
	else
	{
		var selecterRecord = gridObj.getSelectionModel().getSelections();
		for(var i=0;i<selecterRecord.length;i++)
		{
			var rec = selecterRecord[i];
			var ID = rec.get(idField);
			idStr=(idStr==""?ID:idStr+"^"+ID);
		}
	}
	return idStr;
}
/**
*Note:添加对应的按钮
*/
function addButtons()
{
	var selectModel = new Ext.grid.CheckboxSelectionModel({});
	var cloumnModel = new Ext.grid.ColumnModel([
	selectModel,
	{header: "按钮描述",  width:70,sortable: true,dataIndex:"buttonDesc"},
    {header: "按钮名称", width:70,sortable: true,dataIndex:"buttonName"},
    {header: "JS函数名",width:70,sortable: true,dataIndex:"jsFunction"},
	{header: "图片名称",width:70,sortable: true,dataIndex:"iconName"},
    {header: "单签",width:70,sortable: true,dataIndex:"ifSign"},
    {header: "双签",width:70,sortable: true,dataIndex:"ifDoubleSign"},
    {header: "操作类型",hidden:true,width:70,sortable: true,dataIndex:"operationType"},
    {header: "按钮ID",width:70,sortable: true,dataIndex:"buttonID",hidden:true}
	]);
	var store = new Ext.data.JsonStore({
		url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getButtons",
		root:"rowData",
		fields:["buttonDesc","buttonName","jsFunction","iconName","ifSign","ifDoubleSign","operationType","buttonID"]
	});
	var window = createWindow("addButtonWin","addButtonGrid",store,cloumnModel,selectModel)
	window.buttons[0].on("click",function(){
		var store = Ext.getCmp("sheetButtons").getStore();
		var sm = Ext.getCmp("addButtonGrid").getSelectionModel();
		var records = sm.getSelections();
		for(var i=0;i<records.length;i++)
		{
			if(ifExistID(store,"ID",records[i].get("buttonID"))) continue;
			var newRecord = new Ext.data.Record({ID:records[i].get("buttonID"),name:records[i].get("buttonName"),desc:records[i].get("buttonDesc")});
			store.add(newRecord);
		}
		window.close();
	});
	Ext.getCmp("addButtonGrid").getStore().load();
	window.show();
}

/**
*Note:添加对应的列设置
*/
function addSheetColumns()
{
	var selectModel = new Ext.grid.CheckboxSelectionModel({});
	var cloumnModel = new Ext.grid.ColumnModel([
	selectModel,
	{header: "列名",  width:70,sortable: true,dataIndex:"varDesc"},
    {header: "列代码", width:70,sortable: true,dataIndex:"varCode"},
    {header: "列宽",width:40,sortable: true,dataIndex:"columnWidth"},
    {header: "绑定函数",width:350,sortable: true,dataIndex:"funCode"},
    {header: "列ID",width:10,sortable: true,dataIndex:"columnID",hidden:true}
	]);
	var store = new Ext.data.JsonStore({
		url:"../csp/dhc.nurse.extjs.getdata.csp?className=Nur.NurseSheetSetCom&methodName=getColumns",
		root:"rowData",
		fields:["varDesc","varCode","columnWidth","funCode","columnID"]
	});
	var window = createWindow("addColumnWin","addColumnGrid",store,cloumnModel,selectModel)
	window.buttons[0].on("click",function(){
		var store = Ext.getCmp("sheetColumn").getStore();
		var sm = Ext.getCmp("addColumnGrid").getSelectionModel();
		var records = sm.getSelections();
		for(var i=0;i<records.length;i++)
		{
			if(ifExistID(store,"ID",records[i].get("columnID"))) continue;
			var newRecord = new Ext.data.Record({ID:records[i].get("columnID"),name:records[i].get("varDesc"),code:records[i].get("varCode")});
			store.add(newRecord);
		}
		window.close();
	});
	Ext.getCmp("addColumnGrid").getStore().load();
	window.show();
}
/**
*Note:判断Store  里是否包含指定ID
* 存在返回true
* 否则返回false
*/
function ifExistID(store,idField,id)
{
	if(id=="") return false;
	var count = store.getCount();
	for(var i=0;i<count;i++)
	{
		var ID = store.getAt(i).get(idField);
		if(ID==id)
		{
			return true
		}
	}
	return false;
}
/**
*Note:创建window对象
*添加 按钮和列  用
*/
function createWindow(windowID,gridPanelID,store,cm,sm)
{
	if(Ext.getCmp(windowID))
	{
		Ext.getCmp(windowID).close();
	}
	if(Ext.getCmp(gridPanelID))
	{
		Ext.getCmp(gridPanelID).destroy();
	}
	var gridPanel= new Ext.grid.GridPanel({
		id:gridPanelID,
		layout:"fit",
		store:store,
		sm:sm,
		cm:cm,
		viewConfig:{
			forceFit:true
		}
	});
	var window = new Ext.Window({
		id:"addButtonWin",
		layout:"fit",
		height:500,
		width:900,
		items:[
			gridPanel
		],
		buttons:[
		new Ext.Button({
			text:"选择",
			icon:'../images/uiimages/all_selected.png',
		}),
		new Ext.Button({
			text:"取消",
			icon:'../images/uiimages/cancel.png',
			handler:function(){
				window.close();
			}
		})]
	});	
	return window;
}
/**
*Note:移动选中项
*Direction:"U" 上移 "D" 下移  
*		   "T" 顶部 "B" 底部(暂不用)
*/
function moveRecord(grid,Direction)
{
	var selectModel = grid.getSelectionModel();
	var seleRecord = selectModel.getSelected();
	if(seleRecord)
	{
		var store = grid.getStore();
		var count = store.getCount();
		var index = store.indexOf(seleRecord);
		if(index!=-1)
		{
			switch(Direction)
			{	
				case "U":	if(index-1<0) return;
							currentRecord = store.getAt(index-1);
							store.removeAt(index-1);
							store.insert(index,currentRecord);
							break;
				case "D":	if(index+1>=count) return;
							currentRecord = store.getAt(index+1);
							store.removeAt(index+1);
							store.insert(index,currentRecord);
							break;
				case "T" :	break;
				case "B" :  break;
				
			}
		}
	}
	
}

/**
*创建 过滤选项 panel
*id:panel的id
*className:panel Store加载的后台类名
*methodName:panel store加载的后台方法名
*clWidth:panel的宽 值为小数，表示占总宽度的比例
*padding:创建region时定义的,表示penel与父控件的内边距
*header:列头部显示的名称
*/
function createPanel(id,header,className,methodName,clWidth,padding)
{
	var hospitalID=Ext.getCmp("hospitalName").getValue()||''
	var panelJsonStore=new Ext.data.JsonStore({
		url:"../csp/dhc.nurse.extjs.getdata.csp?className="+className+"&methodName="+methodName,
		// +"&parameter1="+hospitalID,
		baseParams: { parameter1: hospitalID },
		fields:["ID","DESC"],
		root:"rowData",
		autoLoad:true,
		// listeners:{beforeLoad:function (){
		// 	var store = Ext.getCmp("sheetSetGrid").getStore();
		// 	// store.baseParams.className = "Nur.NurseSheetSetCom";
		// 	// store.baseParams.methodName="getNurseSheets";
		// 	store.baseParams.parameter1=Ext.getCmp("hospitalName").getValue();
		// }}
	})
	if ('getOrdCat'==methodName) {
		ordCatJsonStore=panelJsonStore
	}
	if ('GetGroupHospSpecCode'==methodName) {
		// 标本名称
		specJsonStore=panelJsonStore
	}
	// if ('getRecloc'==methodName) {
	// 	locJsonStore=panelJsonStore
	// }
	var height =Ext.getCmp("centerRegion").getHeight()-Ext.getCmp("centerRegion").getTopToolbar().getHeight()-(2*parseInt(padding));
	var panel = new Ext.grid.GridPanel({
		id:id,
		layout :"fit",
		columnWidth : clWidth, 
		height:height,
		store:panelJsonStore,
		cm:new Ext.grid.ColumnModel([
			{header: "ID",  width:70,sortable: true,dataIndex:"ID",hidden:true},
			{header: header,  width:70,dataIndex:"DESC",menuDisabled:true}
		]),
		viewConfig:{forceFit:true}
	});
	return panel;
}
/**
*Note:初始化过滤选项
*/
function initFilter()
{
	var record = Ext.getCmp("sheetSetGrid").getSelectionModel().getSelected();
	if(record)
	{
		var ID = record.get("ID");
	}
	else return;
	var filterObjStr = tkMakeServerCall("Nur.NurseSheetSetCom","getSheetFilters",ID);
	if(filterObjStr=="{}") return;
	var filterObj = eval("("+filterObjStr+")")
	var gridIDArray = ["disposeStat","oecpr","ordCat","ordStat","ordPhcin","ordStage","specCode","recloc"];
	for(var i=0;i<gridIDArray.length;i++)
	{
		var selectRec = new Array();
		var selectionModel = Ext.getCmp(gridIDArray[i]).getSelectionModel();
		selectionModel.clearSelections();
		var store = Ext.getCmp(gridIDArray[i]).getStore();
		var count =store.getCount();
		var idStr=eval("("+"filterObj."+gridIDArray[i]+")");
		if(!idStr) continue;
		for(var j=0;j<count;j++)
		{	
			if(("^"+idStr+"^").indexOf("^"+store.getAt(j).get("ID")+"^")>-1)
			{
				selectRec.push(store.getAt(j));
			}
		}
		selectionModel.selectRecords(selectRec);
	}
}
//保存执行查询配置
function saveSearchSet() {
	var queryStartDate = Ext.getCmp('queryStartDate').getValue();
	var queryStartTime = Ext.getCmp('queryStartTime').getValue();
	var queryEndDate = Ext.getCmp('queryEndDate').getValue();
	var queryEndTime = Ext.getCmp('queryEndTime').getValue();
	var querySearchNum = Ext.getCmp('querySearchNum').getValue();
	var reg = /^-?\d+$/;
	if (!reg.test(queryStartDate) || !reg.test(queryEndDate)) {
		alert("开始日期或结束日期为空或输入值不合法,请检查!");
		return;
	}
	if (queryStartTime == "" || queryEndTime == "") {
		alert("开始时间或结束时间为空或输入值不合法,请检查!");
		return;
	}
	var parr = queryStartDate + "^" + queryStartTime + "^" + queryEndDate + "^" + queryEndTime+"^"+querySearchNum+"^"+Ext.getCmp("hospitalName").getValue()
		var ret = tkMakeServerCall("Nur.NurseSheetSetCom", "saveSearchSet", parr);
	if (ret == "0") {
		alert('保存成功！');
	} else {
		alert(ret);
	}
}
//保存执行限制配置
function saveExecSet(){
	var limitExcuteTime=Ext.getCmp('limitExcuteTime').getValue();
	var limitExecBeforeMinutes=Ext.getCmp('limitExecBeforeMinutes').getValue();
	var highRiskDoubleExec=Ext.getCmp('highRiskDoubleExec').getValue();
	var parr=limitExcuteTime+"^"+limitExecBeforeMinutes+"^"+highRiskDoubleExec+"^"+Ext.getCmp("hospitalName").getValue()
	var ret=tkMakeServerCall("Nur.NurseSheetSetCom","saveExecSet",parr);
	if(ret=="0"){
		alert('保存成功！');
	}else{
		alert(ret);
	}
	
}
function initCommSet(){
	var ret=tkMakeServerCall("Nur.NurseSheetSetCom","getCommSet",Ext.getCmp("hospitalName").getValue());
	var retArray=ret.split("^");
	Ext.getCmp('queryStartDate').setValue(retArray[0]);
	Ext.getCmp('queryStartTime').setValue(retArray[1]);
	Ext.getCmp('queryEndDate').setValue(retArray[2]);
	Ext.getCmp('queryEndTime').setValue(retArray[3]);
	Ext.getCmp('limitExcuteTime').setValue(retArray[4]);
	Ext.getCmp('limitExecBeforeMinutes').setValue(retArray[5]);	
	Ext.getCmp('querySearchNum').setValue(retArray[6]);
	Ext.getCmp('highRiskDoubleExec').setValue(retArray[7]);
}
	var searchSetPanel = new Ext.Panel({
		title: "查询设置",
		layout:"form",
		tbar:[
			new Ext.Button({
				text:'保存',
				icon:'../images/uiimages/filesave.png',
				handler:saveSearchSet
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
				fieldLabel:'(已执行/已打印)病人数上限',
				labelStyle: 'text-align:right;',
				id: 'querySearchNum',
			}
		]
	});
    var execSetPanel =new Ext.Panel({
		title: "执行设置",
		layout:"form",
		tbar:[
			new Ext.Button({
				text:'保存',
				icon:'../images/uiimages/filesave.png',
				handler:saveExecSet
			})],
		items: [{
					xtype: 'checkbox',
					fieldLabel:'限制执行时间',
					labelStyle: 'text-align:right;',
					id: 'limitExcuteTime',
					listeners :{
						check:function(e,newVal){
							var limitExecBeforeMinutes=Ext.getCmp('limitExecBeforeMinutes');
							if(newVal){			
								limitExecBeforeMinutes.enable();
							}else{
								limitExecBeforeMinutes.disable();
							}
						}
					}
				},
				{
					xtype: 'numberfield',
					fieldLabel:'可提前执行(分钟)',
					labelStyle: 'text-align:right;',
					width:'60px',
					value:'0',
					id: 'limitExecBeforeMinutes',
					validator :function(val){
						var reg = /^-?\d+$/;
						return reg.test(val);
					}
				},
				{
					xtype: 'checkbox',
					fieldLabel:'高危药是否双签',
					labelStyle: 'text-align:right;',
					id: 'highRiskDoubleExec',
					listeners :{}
				}
			]
	});
/*
	*通用设置手风琴布局panel
	*/
	var InHosSetPanel = new Ext.Panel({ 
	   columnWidth : .21, 
       height: 350,	   
       layout: 'accordion',  
       title: '通用设置',
	   layoutConfig: {  
		 activeOnTop: true,  //设置打开的字面板置顶  
		 fill: true,         //字面板充满父面板的剩余空间  
		 titleCollapse: true,      //允许通过点击子面板的标题来展开或者收缩面板  
		 animate: true             //使用动画效果  
	   },  	   
       items: [searchSetPanel,execSetPanel]  
    });
   
Ext.onReady(onLoad);
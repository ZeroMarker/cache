var REC = new Array();
var RowId = new Array();
var count =0;
var count1=0;
function BodyLoadHandler()
{
	var Height = document.body.clientHeight-5;
	var Width = document.body.clientWidth-3;
	var mygrid1pl=Ext.getCmp("mygrid1pl");
	mygrid1pl.setHeight(Height);
	mygrid1pl.setWidth(Width*0.25);
	mygrid1pl.setPosition(0,0);
	var mygrid2pl=Ext.getCmp("mygrid2pl");
	mygrid2pl.setPosition(Width*0.25+1,0);
	mygrid2pl.setHeight(Height);
	mygrid2pl.setWidth(Width*0.4);
	var mygrid3pl=Ext.getCmp("mygrid3pl");
	mygrid3pl.setPosition(Width*0.65+1,0);
	mygrid3pl.setHeight(Height);
	mygrid3pl.setWidth(Width*0.35);
	myGridFun("mygrid1");
	myGridFun("mygrid2");
	myGridFun("mygrid3");
	if(session['LOGON.GROUPDESC']=='Inpatient Nurse'){findData("mygrid1");}
	//var grid = Ext.getCmp("mygrid1");
	//grid.addListener('beforeedit',function(){return false;},'','');
	//grid.addListener('rowdblclick',rowdblclick,'','');
	//grid.addListener('rowcontextmenu',rowdbclick,'','');
	var grid = Ext.getCmp("mygrid2");
	grid.removeListener('beforeedit',beforeedit1,'','');
	grid.addListener('beforeedit',beforeedit2,'','');
}
var combo = new Ext.form.ComboBox({
	id:'comboward',
  typeAhead: true,
  triggerAction: 'all',
  lazyRender:true,
  mode: 'local',
  lazyInit:true,
  editable:false,
  store: new Ext.data.ArrayStore({
      id: 0,
      fields: [
          'WardId2',
          //'WardCode2',
          'WardDesc2'
      ],
      data: getArray3()
  }),
  valueField: 'WardId2',
  displayField: 'WardDesc2',
  listeners:{
  	select:function(combox,record,index){
  		//alert(combox.getValue());
  		findData("mygrid1");
  		combo2.setValue("");
  		combo2.store.loadData(getArray2());
  	}
  }
});
var combo2 = new Ext.form.ComboBox({
	id:'comboItem1',
  typeAhead: true,
  triggerAction: 'all',
  lazyRender:true,
  mode: 'local',
  lazyInit:true,
  editable:false,
  store: new Ext.data.ArrayStore({
		id: 0,
  	fields: [
  		'Item1Id',
    	'Item1Desc'
  	]
	}),
  valueField: 'Item1Id',
  displayField: 'Item1Desc',
  listeners:{
  	select:function(combox,record,index){
  		///alert(combox.getValue());
  		findData("mygrid2");
  		combo3.setValue("");
  		combo3.store.loadData(getArray4());
  	}
  }
});
var combo3 = new Ext.form.ComboBox({
	id:'comboItem2',
  typeAhead: true,
  triggerAction: 'all',
  lazyRender:true,
  mode: 'local',
  lazyInit:true,
  editable:false,
  store: new Ext.data.ArrayStore({
		id: 0,
  	fields: [
  		'Item2Id',
    	'Item2Desc'
  	]
	}),
  valueField: 'Item2Id',
  displayField: 'Item2Desc',
  listeners:{
  	select:function(combox,record,index){
  		//alert(combox.getValue());
  		findData("mygrid3");
  	},
  	expand:function(combox,record)
  	{
  		combo3.store.loadData(getArray4());
  	}
  }
});
function myGridFun(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var tobar=grid.getTopToolbar();
	var but1=Ext.getCmp(mygrid+"but1");
	but1.hide();
	var but=Ext.getCmp(mygrid+"but2");
	but.hide();
	var tbar2=new Ext.Toolbar({});
	var UserType = session['LOGON.GROUPDESC'];
	if(mygrid=="mygrid1")
	{
		if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部')
		{
			tobar.addItem("病区:",combo);
		}
		else{
			if(UserType=="Inpatient Nurse")
			{
				var parr = session['LOGON.CTLOCID'];
				combo.setValue(parr);
				//var FindWardById = document.getElementById("FindWardById");
				//var ret = cspRunServerMethod(FindWardById.value,parr);
				//var hh = ret.split("^");
				//alert(hh[1]);
				//combo.selectByValue(hh[1],true);
				combo.disable();
				tobar.addItem("病区:",combo);
			}
		}
	}
	if(mygrid=="mygrid2")
	{
		tobar.addItem("项目一:",combo2);
		if(UserType=="Inpatient Nurse"||UserType=="住院护士长")
		{
			combo2.store.loadData(getArray2());
		}
	}
	if(mygrid=="mygrid3")
	{
		tobar.addItem("项目二:",combo3);
		if(UserType=="Inpatient Nurse"||UserType=="住院护士长")
		{
			combo3.store.loadData(getArray4());
		}
	}
	//tbar2.addItem("-");
	tbar2.addButton({
		text:'增加',
		handler:function(){AddData(mygrid);},
		id:mygrid+'addDatabtn'
	});
	if(mygrid=="mygrid1"){
		tbar2.addItem("-");
		tbar2.addButton({
			text:'保存',
			id:mygrid+'editBtn',
			handler:function(){saveData(mygrid);}
		});
	}
	tbar2.addItem("-");
	tbar2.addButton(
	{
		text:"修改",
		handler:function(){updateData(mygrid);},
		id:mygrid+'updbtn'
	});
	tbar2.addItem("-");
	tbar2.addButton(
	{
		text:"作废",
		handler:function(){deleteData(mygrid);},
		id:mygrid+'btnDlt'
	});
	tbar2.render(grid.tbar);
	tobar.doLayout();
}

function additm(mygrid,Desc)
{
	var grid = Ext.getCmp(mygrid);
	if(mygrid=="mygrid1")
	{
		var Plant="";
  	Plant = Ext.data.Record.create([
			{name:'Item1'}, 
			{name:'WardItem'},
			{name:'RowId1'}
  	]);
   	var r = new Plant({WardItem:Desc});
   	 var RowCount = grid.store.getCount();
  	grid.store.commitChanges(); 
  	grid.store.insert(RowCount,r); 
  }
  if(mygrid=="mygrid2")
  {
  	var window = createWindow();
  	window.show();
  	var Item1Name = Ext.getCmp("Item1Name");
  	Item1Name.setValue(combo2.getRawValue());
  	Item1Name.disable();
  	var saveBtn = Ext.getCmp("saveBtn");
  	saveBtn.on('click',function(){saveData(mygrid);window.close();});
  }
  if(mygrid=="mygrid3")
  {
  	var window = createWindow();
  	window.show();
  	var Item1Name = Ext.getCmp("Item1Name");
  	Item1Name.setValue(combo3.getRawValue());
  	Item1Name.disable();
  	var saveBtn = Ext.getCmp("saveBtn");
  	saveBtn.on('click',function(){saveData(mygrid);window.close();});
  }
	return;
}
/*
function createTable1()
{
	var colModel = new Ext.grid.ColumnModel([
    { header: "WardId", width: 50, sortable: true,dataIndex: 'WardRowId'},
    { header: "WardCode", width: 150, sortable: true,dataIndex: 'WardCode'},
    { header: "WardDesc", width: 150, sortable: true, dataIndex: 'WardDesc'}
 	]);
	var store = new Ext.data.Store({
    proxy: new Ext.data.MemoryProxy(getArray()),
    start:0,limit:20,
    sortInfo:{field: "WardRowId", direction: "ASC"},
    reader: new Ext.data.ArrayReader({}, [
    	{name: 'WardRowId'},
      {name: 'WardCode'},
      {name: 'WardDesc'}
    ])
	});
	store.load({params:{start:0,limit:16}});
	var table = new Ext.grid.GridPanel({
		renderTo:'mygrid1',
		id:'mygrid3',
		x:0,y:0,
		height: 500,
		width: 375,
		store: store,
		cm: colModel,
    listeners:{
    	rowdblclick:function(grid, index, e){
        var selectionModel = grid.getSelectionModel();    
        var record = selectionModel.getSelected();
        RowId[RowId.length] = record.get("WardRowId");
        var WardDesc = record.get("WardDesc");
        additm("mygrid1",WardDesc);
        var window=Ext.getCmp("gformward");
        window.close();
    	}
    } 
	});
	return table;
}*/
/*function createTable2()
{
	var colModel = new Ext.grid.ColumnModel([
    { header: "Item1Id", width: 50, sortable: true,dataIndex: 'Item1Id'},
    { header: "Item1Desc", width: 150, sortable: true,dataIndex: 'Item1Desc'},
    { header: "WardDesc", width: 150, sortable: true, dataIndex: 'WardDesc'}
 	]);
	var store = new Ext.data.Store({
    proxy: new Ext.data.MemoryProxy(getArray2()),
    start:0,limit:20,
    sortInfo:{field: "CareId", direction: "ASC"},
    reader: new Ext.data.ArrayReader({}, [
    	{name: 'Item1Id'},
      {name: 'Item1Desc'},
      {name: 'WardDesc'}
    ])
	});
	store.load({params:{start:0,limit:16}});
	var table = new Ext.grid.GridPanel({
		renderTo:'mygrid2',
		id:'mygrid4',
		x:0,y:0,
		height: 500,
		width: 375,
		store: store,
		cm: colModel,
    listeners:{
    	rowdblclick:function(grid, index, e){
        var selectionModel = grid.getSelectionModel();    
        var record = selectionModel.getSelected();
        RowId[RowId.length] = record.get("Item1Id");
        var CareDesc = record.get("CareDesc");
        additm("mygrid2",CareDesc);
        var window=Ext.getCmp("gformcare");
        window.close();
    	}
    } 
	});
	return table;
}*/
function rowdblclick(grid, index, e){
	var mygrid = Ext.getCmp("mygrid1");
	var selectedRow = mygrid.getSelectionModel().getSelected();
	var parr = selectedRow.get("RowId1");
	//alert(parr);
	if(parr!=null)
	{
		var GetQueryData = document.getElementById("getQureyData");
  	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemTwo", "parr$" + parr, "AddRec3");
		count1 = REC.length;
		mygrid.store.loadData(REC);
  }
}
/*function checkWindows1()
{
	var table = createTable1();
	var window = new Ext.Window({
		title : '请选择病区',
		id : "gformward",
		x:10,y:50,
		width : 390,
		height : 540,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [table]
	});
	return window;
}
function checkWindows2()
{
	var table = createTable2();
	var window = new Ext.Window({
		title : '请选择治疗项',
		id : "gformcare",
		x:10,y:50,
		width : 390,
		height : 540,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [table]
	});
	return window;
}*/
function AddData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var store = grid.store;
	if(mygrid=="mygrid1")
	{
		if(store.getCount()>0){
			var Item1 = store.getAt(store.getCount()-1).get("Item1");
			var WardItem = store.getAt(store.getCount()-1).get("WardItem");
			if(Item1==null||WardItem=="")
			{
				alert("请完成上一条记录的录入");
				return;
			}
		}
		var UserType = session['LOGON.GROUPDESC'];
		if(UserType=="Inpatient Nurse"||UserType=="住院护士长")
		{
			var parr = session['LOGON.CTLOCID'];
			RowId[RowId.length] = parr;
			var FindWardById = document.getElementById("FindWardById");
			var ret = cspRunServerMethod(FindWardById.value,parr);
			var hh = ret.split("^");
			var WardDesc = hh[1];
			additm("mygrid1",WardDesc);
		}
		if(UserType=="Demo Group"||UserType=="护理部"){
			var parr = combo.getValue();
			if(parr=="")
			{
				alert("请选择病区");
			}
			else{
				RowId[RowId.length] = parr;
				var FindWardById = document.getElementById("FindWardById");
				var ret = cspRunServerMethod(FindWardById.value,parr);
				var hh = ret.split("^");
				var WardDesc = hh[1];
				additm("mygrid1",WardDesc);
				//grid.getColumnModel().setEditable(1,true)
  			//grid.getColumnModel().setEditable(3,true)
				//var window= checkWindows1();
 				//window.show();
 			}
 		}
 	}
 	if(mygrid=="mygrid2")
 	{
 		if(combo.getValue()==""){alert("请选择病区!");return;}
 		if(combo2.getValue()==""){alert("请选择项目一!");return;}
		additm("mygrid2","");
 	}
 	if(mygrid=="mygrid3")
 	{
 		if(combo.getValue()==""){alert("请选择病区!");return;}
 		if(combo2.getValue()==""){alert("请选择项目一!");return;}
 		if(combo3.getValue()==""){alert("请选择项目二!");return;}
		additm("mygrid3","");
 	}
}
function AddRec1(a1,a2,a3){
	REC.push(a1,a2,a3);
}
function getArray()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQureyData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindAllWardData", "parr$", "AddRec1");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i++,j++)
	{
		arr[j] = new Array(parseInt(REC[i].toString()),REC[++i].toString(),REC[++i].toString());
	}
	return arr;
}

function getArray2()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQureyData");
	//var parr = session['LOGON.WARDID'];
	var parr="";
	var UserType = session['LOGON.GROUPDESC'];
	if(UserType=='Inpatient Nurse'||UserType=='住院护士长')
	{
		parr = session['LOGON.CTLOCID'];
	}
	if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部')
	{
		//var combobox1 = Ext.getCmp("comboward")
		parr = combo.getValue();
	}
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemOne", "parr$" + parr, "AddRec1");
	var ret = cspRunServerMethod(FindWardById.value,parr);
	var hh = ret.split("^");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i++,j++)
	{
		//CareRowId,CareItem,CareDesc
		arr[j] = new Array(parseInt(REC[i].toString()),REC[++i].toString());
		i++;
	}
	return arr;
}
function getArray3()
{
	REC = new Array();
	var GetQueryData = document.getElementById("getQureyData");
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindAllWardData", "parr$", "AddRec1");
	var arr = new Array();
	for(j=0,i=0;i<REC.length;i=i+3,j++)
	{
		arr[j] = new Array(parseInt(REC[i].toString()),REC[i+2].toString());
	}
	return arr;
}
function saveData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var store = grid.store;
	if(mygrid=="mygrid1")
	{
		var addHEAPData = document.getElementById("addHEAPData");
  	for (var i = count,j=0; i < store.getCount(); i++,j++) {
  		var Item1Desc = store.getAt(i).get("Item1");
  		var WardItem = RowId[j];
  		if(Item1Desc!=""&&WardItem!="")
  		{
  			var parr = Item1Desc+"^"+WardItem;
  			//alert(parr);
  			var ret = cspRunServerMethod(addHEAPData.value,parr);
  			//if(ret!=""){alert(ret);}
  			combo2.store.loadData(getArray2());
  		}
		}
		RowId=new Array();
		//findData("mygrid1");
	}
	if(mygrid=="mygrid2")
	{
		var addHEAPIData = document.getElementById("addHEAPIData");
		var Item2Desc = Ext.getCmp("Item2Name").getValue();
		if(Item2Desc==""){alert("项目名称为空!");return;}
		var Item1DR = combo2.getValue();
		var ItemTwoDesc = Ext.getCmp("Item2Desc").getValue();
  	var parr = Item2Desc+"^"+Item1DR+"^"+ItemTwoDesc;
  	var ret = cspRunServerMethod(addHEAPIData.value,parr);
  	combo3.store.loadData(getArray4());
	}
	if(mygrid=="mygrid3")
	{
		var saveData = document.getElementById("saveData");
		var Item3 = Ext.getCmp("Item2Name").getValue();
		if(Item3Desc==""){alert("项目名称为空!");return;}
		var Item2DR = combo3.getValue();
		var Item3Desc = Ext.getCmp("Item2Desc").getValue();
  	var parr = "^"+Item3+"^"+Item2DR+"^"+Item3Desc;
  	var ret = cspRunServerMethod(saveData.value,parr);
  	//alert(ret);
	}
	findData(mygrid);
}
function beforeedit1()
{
	return true;
}
function beforeedit2()
{
	return false;
}
function findData(mygrid)
{
	REC= new Array();
	var grid = Ext.getCmp(mygrid);
	var GetQueryData = document.getElementById("getQureyData");
	if(mygrid=="mygrid1")
	{
		var parr="";
		var UserType = session['LOGON.GROUPDESC'];
		if(UserType=='Inpatient Nurse'||UserType=='住院护士长')
		{
			parr = session['LOGON.CTLOCID'];
		}
		if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部主任'||UserType=='护理部')
		{
			//var combobox1 = Ext.getCmp("comboward")
			parr = combo.getValue();
		}
		var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemOne", "parr$" + parr, "AddRec2");
		count = REC.length;
	}
	if(mygrid=="mygrid2")
	{
		//var mygrid = Ext.getCmp("mygrid1");
		//var selectedRow = mygrid.getSelectionModel().getSelected();
		//var parr = selectedRow.get("RowId1");
		var parr = combo2.getValue();
		//alert(parr);
		//alert(combo2.getRawValue());
		var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemTwo", "parr$" + parr, "AddRec3");
		count1 = REC.length;
	}
	if(mygrid=="mygrid3")
	{
		var parr = combo3.getValue();
		var a = cspRunServerMethod(GetQueryData.value,"DHCMGNUR.DHCNurHEAPIItem:FindHEAPIIData", "parr$" + parr, "AddRec5");
	}
	grid.store.loadData(REC);
}
function AddRec3(a1,a2,a3,a4)
{
	//Item2RowId,Item2Desc,Item1Desc,Describle
	//alert(a1+"-"+a2+"-"+a3+"-"+a4);
	REC.push({
		Item2:a2,
		Item12:a3,
		ItemTwoDesc:a4,
		RowId2:a1
	});
}
function AddRec2(a1,a2)
{
	var FindWardById = document.getElementById("FindWardById");
	var parr="";
	var UserType = session['LOGON.GROUPDESC'];
	if(UserType=='Inpatient Nurse'||UserType=='住院护士长')
	{
		parr = session['LOGON.CTLOCID'];
	}
	if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部主任'||UserType=='护理部')
	{
		//var combobox1 = Ext.getCmp("comboward")
		parr = combo.getValue();
	}
	var ret = cspRunServerMethod(FindWardById.value,parr);
	var hh = ret.split("^");
	REC.push({
		Item1:a2,
		WardItem:hh[1],
		RowId1:a1
	});
}

function deleteData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示 ', "请选择 一条记录 !"); return;
	}
	var selectedRow = grid.getSelectionModel().getSelected();
	if(confirm("确认作废这条记录？")){
		if(mygrid=="mygrid1")
		{
			var deletevalue = document.getElementById("deleteHEAPData");
			var Item1RowId = selectedRow.get("RowId1");
			var parr = Item1RowId+"^N";
			var ret = cspRunServerMethod(deletevalue.value,parr);
			if(ret!=""){alert(ret);}
		}
		if(mygrid=="mygrid2")
		{
			var deletevalue = document.getElementById("deleteHEAPIData");
			var Item2RowId = selectedRow.get("RowId2");
			var parr = Item2RowId+"^N";
			var ret = cspRunServerMethod(deletevalue.value,parr);
			if(ret!=""){alert(ret);}
		}
		if(mygrid=="mygrid3")
		{
			var deleteData = document.getElementById("deleteData");
			var Item3RowId = selectedRow.get("RowId3");
			var parr = Item3RowId+"^N";
			var ret = cspRunServerMethod(deleteData.value,parr);
			if(ret!=""){alert(ret);}
		}
		findData(mygrid);
	}
}
function updateData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var rowObj = grid.getSelectionModel().getSelections();
	var selectedRow = grid.getSelectionModel().getSelected();
	if (rowObj.length == 0)
	{
		Ext.Msg.alert('提示 ', "请选择 一条记录 !");
		return;
	}
	var RowObj = grid.getSelectionModel().getSelected();  
	if(mygrid=="mygrid1")
	{  
   	var rowId = RowObj.get("RowId1");
   	var Item1 = RowObj.get("Item1");
   	var parr = rowId+"^"+Item1;
   	var UpdateHEPData = document.getElementById("UpdateHEPData");
   	var ret = cspRunServerMethod(UpdateHEPData.value,parr);
   	//alert(ret);
   	findData("mygrid1");
	}
	if(mygrid=="mygrid2"){
		var window = createWindow();
		window.show();
		Ext.getCmp("Item2Name").setValue(RowObj.get("Item2"));
		Ext.getCmp("Item1Name").setValue(RowObj.get("Item12"));
		Ext.getCmp("Item1Name").disable();
		Ext.getCmp("Item2Desc").setValue(RowObj.get("ItemTwoDesc"));
		var saveBtn = Ext.getCmp("saveBtn");
		saveBtn.on('click',function(){
			var rowId = RowObj.get("RowId2");
			var Item2Name = Ext.getCmp("Item2Name").getValue();
			var Item2Desc = Ext.getCmp("Item2Desc").getValue();
			var parr = rowId+"^"+Item2Name+"^"+Item2Desc;
			var UpdateHEPIData = document.getElementById("UpdateHEPIData");
	   	var ret = cspRunServerMethod(UpdateHEPIData.value,parr);
	   	//alert(ret);
	   	window.close();
	   	findData("mygrid2");
	  });
	}
	if(mygrid=="mygrid3"){
		var window = createWindow();
		window.show();
		Ext.getCmp("Item2Name").setValue(RowObj.get("Item3"));
		Ext.getCmp("Item1Name").setValue(RowObj.get("Item22"));
		Ext.getCmp("Item1Name").disable();
		Ext.getCmp("Item2Desc").setValue(RowObj.get("Item3Desc"));
		var saveBtn = Ext.getCmp("saveBtn");
		saveBtn.on('click',function(){
			var rowId = RowObj.get("RowId3");
			var Item3 = Ext.getCmp("Item2Name").getValue();
			var Item2DR = combo3.getValue();
			//alert("UpDate:"+Item2DR)
			var Item3Desc = Ext.getCmp("Item2Desc").getValue();
			var parr = rowId+"^"+Item3+"^"+Item2DR+"^"+Item3Desc
			var saveData = document.getElementById("saveData");
	   	var ret = cspRunServerMethod(saveData.value,parr);
	   	//alert(ret);
	   	window.close();
	   	findData("mygrid3");
	  });
	}
}

function createWindow()
{
	//DHCNURHEAPWindow
	var a=cspRunServerMethod(pdata1,"","DHCNURHEAPWindow","","");
	var arr = eval(a);
	var window= new Ext.Window({
		title : '健康教育评估子项维护',
		id : "heapWindow",
		x:10,y:2,
		width : 600,
		height : 530,
		fileUpload:true,
		autoScroll : true,
		layout : 'absolute',
		items : [arr]
	});
	return window;
}

function getArray4()
{
	REC=new Array();
	var GetQueryData = document.getElementById("getQureyData");
	var parr = combo2.getValue();
	var a = cspRunServerMethod(GetQueryData.value,"web.DHCNurHlthEduComm:FindHEAPItemTwo", "parr$" + parr, "AddRec4");
	return REC;
}

function AddRec4(a1,a2,a3,a4)
{
	REC.push(new Array(a1,a2));
}

function AddRec5(a1,a2,a3,a4)
{
	//Item3,Item2Desc,Item3Decs,ItemId
	REC.push({
		Item3:a1,
		Item22:a2,
		Item3Desc:a3,
		RowId3:a4
	});
}
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
	
	combo1.on('select',function(combo,record,index){
				var wardid=combo1.getValue();
				combo2.store.baseParams.parr=wardid;  //加载combo2
	 			
				
				var grid=Ext.getCmp("mygrid1");
				grid.store.baseParams.CtLocId=wardid;
				grid.store.load({
						params : {
							start : 0,
							limit : 10
						}
				});	
				
			});
			
	combo2.on('select',function(combo,record,index){
				var itm1=combo2.getValue();
				combo3.store.baseParams.parr=itm1;  //加载combo2
	 			
				//alert(itm1)
				var grid=Ext.getCmp("mygrid2");
				grid.store.baseParams.Item1RowId=itm1;
				grid.store.load({
						params : {
							start : 0,
							limit : 10
						}
				});	
				
			});
			
	combo3.on('select',function(combo,record,index){
				var itm2=combo3.getValue();
				
				//alert(itm2)
				var grid=Ext.getCmp("mygrid3");
				grid.store.baseParams.Item2RowId=itm2;
				grid.store.load({
						params : {
							start : 0,
							limit : 10
						}
				});	
				
			});
}

var combo1 = new Ext.form.ComboBox({
	name:'comboward',
	id:'comboward',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'WardDesc',
				'mapping':'WardDesc'
			},{
				'name':'WardRowId',
				'mapping':'WardRowId'
			}]
		}),
		baseParams:{
			className:'web.DHCNurHlthEduComm',
			methodName:'FindAllWardData',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'250',
	height:18,
	width:250,
	xtype : 'combo',
	displayField : 'WardDesc',
	valueField : 'WardRowId',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : true,
	editable:false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
	
});

var combo2 = new Ext.form.ComboBox({
	name:'comboItem1',
	id:'comboItem1',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'Item1Desc',
				'mapping':'Item1Desc'
			},{
				'name':'Ttem1RowId',
				'mapping':'Ttem1RowId'
			}]
		}),
		baseParams:{
			className:'web.DHCNurHlthEduComm',
			methodName:'FindHEAPItemOne',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'250',
	height:18,
	width:250,
	xtype : 'combo',
	displayField : 'Item1Desc',
	valueField : 'Ttem1RowId',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : true,
	editable:false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
	
});

var combo3 = new Ext.form.ComboBox({
	name:'comboItem2',
	id:'comboItem2',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'Item2Desc',
				'mapping':'Item2Desc'
			},{
				'name':'Item2RowId',
				'mapping':'Item2RowId'
			}]
		}),
		baseParams:{
			className:'web.DHCNurHlthEduComm',
			methodName:'FindHEAPItemTwo',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:'250',
	height:18,
	width:250,
	xtype : 'combo',
	displayField : 'Item2Desc',
	valueField : 'Item2RowId',
	hideTrigger : false,
	//queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : true,
	editable:false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
	
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
			tobar.addItem("病区:",combo1);
		}
		else{
			if(UserType=="Inpatient Nurse")
			{
				var parr = session['LOGON.CTLOCID'];
				combo1.setValue(parr);
				
				combo1.disable();
				tobar.addItem("病区:",combo1);
			}
		}
	}
	if(mygrid=="mygrid2")
	{
		tobar.addItem("项目一:",combo2);
		if(UserType=="Inpatient Nurse"||UserType=="住院护士长")
		{
			//to do 
		}
	}
	if(mygrid=="mygrid3")
	{
		tobar.addItem("项目二:",combo3);
		if(UserType=="Inpatient Nurse"||UserType=="住院护士长")
		{
			//to do
		}
	}
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
function AddData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var store = grid.store;
	if(mygrid=="mygrid1")
	{
		if(store.getCount()>0){
			var ItemDesc = store.getAt(store.getCount()-1).get("ItemDesc");
			var LocID = store.getAt(store.getCount()-1).get("LocID");
			if(ItemDesc==null||LocID=="")
			{
				alert("请完成上一条记录的录入");
				return;
			}
		}
		var UserType = session['LOGON.GROUPDESC'];
		if(UserType=="Inpatient Nurse"||UserType=="住院护士长")
		{
			//to do
		}
		if(UserType=="Demo Group"||UserType=="护理部"){
			var parr = combo1.getValue();
			if(parr=="")
			{
				alert("请选择病区");
			}
			else{
				
				var FindWardById = document.getElementById("FindWardById");
				var ret = cspRunServerMethod(FindWardById.value,parr);
				var hh = ret.split("^");
				var WardDesc = hh[1];
				additm("mygrid1",WardDesc);
				
 			}
 		}
 	}
 	if(mygrid=="mygrid2")
 	{
 		if(combo1.getValue()==""){alert("请选择病区!");return;}
 		if(combo2.getValue()==""){alert("请选择项目一!");return;}
		additm("mygrid2","");
 	}
 	if(mygrid=="mygrid3")
 	{
 		if(combo1.getValue()==""){alert("请选择病区!");return;}
 		if(combo2.getValue()==""){alert("请选择项目一!");return;}
 		if(combo3.getValue()==""){alert("请选择项目二!");return;}
		additm("mygrid3","");
 	}
}
function additm(mygrid,Desc)
{
	var grid = Ext.getCmp(mygrid);
	if(mygrid=="mygrid1")
	{
		var Plant="";
  	    Plant = Ext.data.Record.create([
			{name:'ItemDesc'}, 
			{name:'LocDesc'},
			{name:'LocID'},
			{name:'rw'}
  	]);
   		var r = new Plant({ItemDesc:"",LocDesc:Desc,LocID:combo1.getValue(),rw:""});
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

function saveData(mygrid)
{
	var grid = Ext.getCmp(mygrid);
	var store = grid.store;
	if(mygrid=="mygrid1")
	{
		var addHEAPData = document.getElementById("addHEAPData");
  		for (var i=0; i < store.getCount(); i++) {
  			var ItemDesc = store.getAt(i).get("ItemDesc");
  			var LocID = store.getAt(i).get("LocID");
  			var rw = store.getAt(i).get("rw");
  			
  			if (rw!="") continue;
  			if (ItemDesc==""){
  				alert("项目一不能为空!");
  			    continue;
  			}
  			if((ItemDesc!="")&&(LocID!=""))
  			{
  				var parr = ItemDesc+"^"+LocID;
  				//alert(parr);
  				var ret = cspRunServerMethod(addHEAPData.value,parr);
  				
  			}
		}
		
		
		
	}
	if(mygrid=="mygrid2")
	{
		var addHEAPIData = document.getElementById("addHEAPIData");
		var Item2Name = Ext.getCmp("Item2Name").getValue();
		if(Item2Name==""){alert("项目名称为空!");return;}
		var Item1DR = combo2.getValue();
		var Item2Desc = Ext.getCmp("Item2Desc").getValue();
  		var parr = Item2Name+"^"+Item1DR+"^"+Item2Desc;
  		var ret = cspRunServerMethod(addHEAPIData.value,parr);
  		
	}
	if(mygrid=="mygrid3")
	{
		var saveData = document.getElementById("saveData");
		var Item3Code = Ext.getCmp("Item2Name").getValue();
		if(Item3Code==""){alert("项目名称为空!");return;}
		var Item2DR = combo3.getValue();
		var Item3Desc = Ext.getCmp("Item2Desc").getValue();
  	    var parr = "^"+Item3Code+"^"+Item2DR+"^"+Item3Desc;
  		var ret = cspRunServerMethod(saveData.value,parr);
  	
	}
	findData(mygrid);
}

function findData(mygrid)
{
	
	var grid = Ext.getCmp(mygrid);
	
	if(mygrid=="mygrid1")
	{
		
		var UserType = session['LOGON.GROUPDESC'];
		if(UserType=='Inpatient Nurse'||UserType=='住院护士长')
		{
			
		}
		if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部主任'||UserType=='护理部')
		{
			combo2.store.baseParams.parr=combo1.getValue();  //刷新combo2
			grid.store.baseParams.CtLocId=combo1.getValue();
			grid.store.load({
				params : {
							start : 0,
							limit : 10
						 }
			});	
		}
		
	}
	if(mygrid=="mygrid2")
	{
		var UserType = session['LOGON.GROUPDESC'];
		if(UserType=='Inpatient Nurse'||UserType=='住院护士长')
		{
			
		}
		if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部主任'||UserType=='护理部')
		{
			combo3.store.baseParams.parr=combo2.getValue();  //刷新combo2
			grid.store.baseParams.Item1RowId=combo2.getValue();
			grid.store.load({
				params : {
							start : 0,
							limit : 10
						 }
			});	
		}
	}
	if(mygrid=="mygrid3")
	{
		
		var UserType = session['LOGON.GROUPDESC'];
		if(UserType=='Inpatient Nurse'||UserType=='住院护士长')
		{
			
		}
		if(UserType=='Demo Group'||UserType=='护理部主任'||UserType=='护理部主任'||UserType=='护理部')
		{
			var itm2=combo3.getValue();
				
				//alert(itm2)
				var grid=Ext.getCmp("mygrid3");
				grid.store.baseParams.Item2RowId=itm2;
				grid.store.load({
						params : {
							start : 0,
							limit : 10
						}
				});	
		}
		
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
   	var rowId = RowObj.get("rw");
   	if (rowId==""){
   		alert("新记录请点击保存!");
   		findData("mygrid1");
   		return;
   		
   	}else{
   			var ItemDesc = RowObj.get("ItemDesc");
   			if (ItemDesc==""){
   				alert("项目一不能为空!");
		   		findData("mygrid1");
		   		return;
   			}else{
   				var parr = rowId+"^"+ItemDesc;
		   		var UpdateHEPData = document.getElementById("UpdateHEPData");
		   		var ret = cspRunServerMethod(UpdateHEPData.value,parr);
   			}
   		
   	}
   
   	
   	findData("mygrid1");
	}
	if(mygrid=="mygrid2"){
		var window = createWindow();
		window.show();
		Ext.getCmp("Item2Name").setValue(RowObj.get("Item2Code"));
		Ext.getCmp("Item1Name").setValue(RowObj.get("Item1Desc"));
		Ext.getCmp("Item1Name").disable();
		Ext.getCmp("Item2Desc").setValue(RowObj.get("Item2Desc"));
		var saveBtn = Ext.getCmp("saveBtn");
		saveBtn.on('click',function(){
			var rowId = RowObj.get("Item2rw");
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
		Ext.getCmp("Item2Name").setValue(RowObj.get("Item3Code"));
		Ext.getCmp("Item1Name").setValue(RowObj.get("Item2"));
		Ext.getCmp("Item1Name").disable();
		Ext.getCmp("Item2Desc").setValue(RowObj.get("Item3Desc"));
		var saveBtn = Ext.getCmp("saveBtn");
		saveBtn.on('click',function(){
			var rowId = RowObj.get("Item3rw");
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
			var rw = selectedRow.get("rw");
			var parr = rw+"^N";
			var ret = cspRunServerMethod(deletevalue.value,parr);
			if(ret!=""){alert(ret);}
		}
		if(mygrid=="mygrid2")
		{
			var deletevalue = document.getElementById("deleteHEAPIData");
			var Item2RowId = selectedRow.get("Item2rw");
			var parr = Item2RowId+"^N";
			var ret = cspRunServerMethod(deletevalue.value,parr);
			if(ret!=""){alert(ret);}
		}
		if(mygrid=="mygrid3")
		{
			var deleteData = document.getElementById("deleteData");
			var Item3RowId = selectedRow.get("Item3rw");
			var parr = Item3RowId+"^N";
			var ret = cspRunServerMethod(deleteData.value,parr);
			if(ret!=""){alert(ret);}
		}
		findData(mygrid);
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
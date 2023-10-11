var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-1;
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
//var DHCMgNurLocWardT102=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocWard','mapping':'LocWard'},{'name':'LocDr','mapping':'LocDr'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'}]}),baseParams:{className:'web.DHCMgQualCheck',methodName:'FindNurLocWard',type:'Query'}});
function SizeChange(changewidth) {
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth + changewidth);
	setsize("mygridpl", "gform", "mygrid");
}
//var LocWard=CreateComboBoxQ("LocWard","LocDes","LocDr","护理单元","","150","web.DHCMgNurSysComm","FindWardLoc","par",0,0);
var Nurse=new Ext.form.ComboBox({
	name:'Nurse',
	id:'Nurse',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'nursename',
				'mapping':'nursename'
			},{
				'name':'nurdr',
				'mapping':'nurdr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgQualCheck',
			methodName:'FindNur',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:200,
	//height:20,
	width:127,
	xtype:'combo',
	displayField:'nursename',
	valueField:'nurdr',
	hideTrigger:false,
	queryParam:'nuser',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:5000,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var WardLoc=new Ext.form.ComboBox({
	name:'WardLoc',
	id:'WardLoc',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'ctlocDesc',
				'mapping':'ctlocDesc'
			},{
				'name':'CtLocDr',
				'mapping':'CtLocDr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'SearchComboDep',
			type:'Query'
		}
	}),
	listeners:{ 
			focus: {
				fn: function (e) {
				e.expand();
				this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]);
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
		},
	tabIndex:'0',
	listWidth:220,
	//height:18,
	width:150,
	xtype:'combo',
	displayField:'ctlocDesc',
	valueField:'CtLocDr',
	hideTrigger:false,
	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:1000,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var checktyp = new Ext.form.ComboBox({
	name:'CheckTyp',
	id:'CheckTyp',
	tabIndex:'0',
	//height:20,
	width:120,
	xtype:'combo',
	store:new Ext.data.JsonStore({
		data:[{
			desc:'护士长',
			id:'Nur'
		},{
			desc:'大科护士长',
			id:'LocNur'
		},{
			desc:'护理部',
			id:'MasterNur'
		}],
		fields:['desc','id']
	}),
	displayField:'desc',
	valueField:'id',
	allowBlank:true,
	triggerAction:'all',
	mode:'local',
	value:''
});
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler() 
{
	//setsize("mygridpl", "gform", "mygrid");
	var gridPl = Ext.getCmp('mygridpl');
	gridPl.setWidth(Width);
	gridPl.setHeight(Height);
	var grid=Ext.getCmp('mygrid');
	var mydate=new Date();
	var tobar=grid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
 	grid.on("dblclick",function(){MoudCheck();});
	tobar.addItem("-","级别",checktyp);
	tobar.addItem("-","人员",Nurse);
	tobar.addItem("-","护理单元",WardLoc);
	tbar2=new Ext.Toolbar({});
	tobar.addItem("-");
	var tobar1=new Ext.Toolbar({});
	tobar1.addButton({
		text: "增加",
		handler:function(){additm();},
		id:'btnnew',
		icon:'../images/uiimages/edit_add.png'
	});
	tobar1.addItem("-");
	tobar1.addButton({
		text: "修改",
		disabled:true,
		handler:function(){Edititm();},
		id:'btnEdit',
		icon:'../images/uiimages/pencil.png'
	});
	tobar1.addItem("-");
	tobar1.addButton({
		id:"seachbtn",
		text:"查询",
		icon:'../images/uiimages/search.png',
		handler:function(){setgrid();}	
	});
	tobar1.addItem("-");
	tobar1.addButton({
		text: "删除",
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delNur();},
		id:'btnmod'
	});
	tobar1.addItem("-");
	tobar1.addButton({
		id:'btnClear',
		text:'清屏',
		icon:'../images/uiimages/clearscreen.png',
		handler:function(){funClear();}	
	});
	tobar1.addItem("-");
	tobar1.addButton(  { 
		text: "所辖护理单元",
		handler:function(){LocNurWard();},
		icon:'../images/uiimages/app.png',
		id:'btnward'
	}); 
	tobar1.render(grid.tbar);
	tobar.doLayout();
	WardLoc.store.on("beforeload",function(){
    	var laststr1=WardLoc.lastQuery
    	//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
    	var nurseString=session['LOGON.USERID']+"^"+secGrpFlag;
      	if (laststr1!=undefined)
         	WardLoc.store.baseParams.ward1=laststr1;
      	WardLoc.store.baseParams.typ="1";
      	WardLoc.store.baseParams.nurseid=nurseString; 
  });
 // var nurse=Ext.getCmp("Nurse");
  Nurse.store.on("beforeload",function(){
    var laststr=Nurse.lastQuery
    if (laststr!=undefined)
      Nurse.store.baseParams.nurse=laststr;
  });
	var mygrid=Ext.getCmp('mygrid');
	mygrid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid.bbar);
	setgrid();
//	mygrid.store.on('beforeload',function(){
//		mygrid.store.basePrams.typ = 	checktyp.getValue();
//		mygrid.store.basePrams.typ = 
//	})
	var cmb=Ext.getCmp("CheckTyp");
 // cmb.on("select",setgrid);
	var mygrid=Ext.getCmp('mygrid');
	mygrid.colModel.setHidden(3,true);
	mygrid.colModel.setHidden(4,true);
	mygrid.colModel.setHidden(5,true);
	mygrid.colModel.setHidden(6,true);
	mygrid.bbar.pageSize=30;
}
function funClear()
{
	Ext.getCmp('Nurse').setValue('')
	Ext.getCmp('WardLoc').setValue('');
	Ext.getCmp('CheckTyp').setValue('');
	Ext.getCmp('btnnew').enable();
	Ext.getCmp('btnEdit').disable();
}
function Edititm()
{
	var checktyp=Ext.getCmp("CheckTyp").getValue();
  var SaveQt=document.getElementById('Save');
  var nurse=Ext.getCmp("Nurse").getValue();
  var ward=Ext.getCmp("WardLoc").getValue();
  if((checktyp=="")||(nurse==""))
  {
  	Ext.Msg.alert('提示',"请选择级别,人员");
  	return;
  }
  if((checktyp=="Nur")&&(ward==""))
  {
  	Ext.Msg.alert('提示',"请选择护理单元");
  	return;
  }
	var CheckExist=document.getElementById('CheckExist');
	var flag=cspRunServerMethod(CheckExist.value,nurse);
	if(!flag){
		var mygrid=Ext.getCmp('mygrid');
		var rowObj = mygrid.getSelectionModel().getSelections();
		var rw= rowObj[0].get("rw");
  	var a=cspRunServerMethod(SaveQt.value,ward,nurse,checktyp,rw);
   	if(a!=0)
   	{
  		setgrid();
  		return;
  	}
	}else{
		Ext.MessageBox.confirm("提示", "确认修改?",function(button,text){
			if(button=='yes'){
				var mygrid=Ext.getCmp('mygrid');
				var rowObj = mygrid.getSelectionModel().getSelections();
				var rw= rowObj[0].get("rw");
		  	var a=cspRunServerMethod(SaveQt.value,ward,nurse,checktyp,rw);
		   	if(a!=0)
		   	{
		  		setgrid();
		  		return;
		  	}
		  	Ext.getCmp('btnEdit').disable();
				Ext.getCmp('btnnew').enable();
			}else{
				
			}
		})
	}
	Ext.getCmp('btnnew').enable();
	Ext.getCmp('btnEdit').disable();
	//setgrid();
}
function MoudCheck()
{
	Ext.getCmp('btnEdit').enable();
	//alert(Ext.getCmp('btnnew'))
	Ext.getCmp('btnnew').disable();
	var grid=Ext.getCmp("mygrid");
	var rowObj=grid.getSelectionModel().getSelections();
	if(rowObj.length!="")
	{
		var NurDr=rowObj[0].get("nurdr");
		var loc=rowObj[0].get("loc");
		var Level= rowObj[0].get("Level");
		Ext.getCmp("CheckTyp").setValue(Level);
		comboload1(Ext.getCmp("Nurse"),NurDr);
		comboload1(Ext.getCmp("WardLoc"),loc);
		//comboload1(Ext.getCmp("CheckTyp"),Level);
	}
}
var cmbitm=new Hashtable();
function comboload1(itm,val)
{
	itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if(val!="")
	{
		itm.getStore().load(
		{
			params:{
				start:0,
				limit:10000
			},
			callback:function(){
				itm.setValue(val);
			}
		}
	 );
	}
}
function delNur()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
  var rw = rowObj[0].get("rw");
 	var delNur=document.getElementById('delNur');
	if (confirm('确定删除选中的项？')) {
			var a=cspRunServerMethod(delNur.value,rw);
			setgrid();
	}
}
function menuSavePos()
{
  var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var loctyp=Ext.getCmp("LocTyp1").getValue();
  var sortpos=Ext.getCmp("SortPos1").getValue();
  var hsdr=1;
  var loc = rowObj[0].get("LocDr");
  if(sortpos!=""){
  	var SaveQt=document.getElementById('SavePos');
		var a=cspRunServerMethod(SaveQt.value,hsdr,loctyp,loc,sortpos);
    setgrid();
  } 
}
function additm()
{
	var checktyp=Ext.getCmp("CheckTyp").getValue();
  var SaveQt=document.getElementById('Save');
  var nurse=Ext.getCmp("Nurse").getValue();
  var ward=Ext.getCmp("WardLoc").getValue();
  if((checktyp=="")){
  	Ext.Msg.alert('提示',"级别不能为空！");
  	return;
  }
  if(nurse==""){Ext.Msg.alert('提示','人员不能为空！');return;}
  if ((checktyp=="Nur")&&(ward=="")){
  	Ext.Msg.alert('提示',"请选择护理单元");
  	return;
  }
	var rw="";
	var str="";
  var a=cspRunServerMethod(SaveQt.value,ward,nurse,checktyp,"");
  if(a.indexOf("已存在")!=-1){
   	alert(a);
   	return;
  }
  if (a!=0){
  	setgrid();
  	return;
  }
}
function setgrid(){
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeload",function(){
    var CheckTyp=Ext.getCmp("CheckTyp").getValue();
    mygrid.store.baseParams.typ = CheckTyp;
    mygrid.store.baseParams.nur = Nurse.getValue();
    mygrid.store.baseParams.CheckTyp =WardLoc.getValue();
  });
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
	mygrid.bbar.pageSize=30;
}
function menunew(){
	curmenuid = "";
	menuWin("");
}
function grid1click()
{
	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		return;
	}
	var sort = rowObj[0].get("SortPos");
  	var sortpos=Ext.getCmp("SortPos1");
  	sortpos.setValue(sort);
}
function LocNurWard()
{
	var mygrid=Ext.getCmp('mygrid')
	var rowObj = mygrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var Par=rowObj[0].get("rw");
	var arr = new Array();
	var CheckTyp=rowObj[0].get("checktyp"); 
	//if ((CheckTyp!="总护士长")&&(CheckTyp!="护士长")) return;
	if(CheckTyp!="护士长"){
  		Ext.Msg.alert('提示','请选择护士长级别！');
  		return;
  	}
	var locGrid=createGrid(Par);
}
function createGrid(Par)
{
	var locWard1=new Ext.form.ComboBox({
		name:'locWard1',
		id:'locWard1',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'ctlocDesc',
					'mapping':'ctlocDesc'
				}, {
					'name':'CtLocDr',
					'mapping':'CtLocDr'
				}]
			}),
			baseParams:{
				className:'web.DHCMgNurPerHRComm',
				methodName:'SearchComboDep',
				type:'Query'
			}
		}),
		tabIndex:'0',
		listWidth:'220',
		//height:18,
		width:150,
		xtype:'combo',
		displayField:'ctlocDesc',
		valueField:'CtLocDr',
		hideTrigger:false,
		queryParam : 'ward1',
		forceSelection:true,
		triggerAction:'all',
		minChars:1,
		pageSize:1000,
		typeAhead:false,
		minChars : 1,
		typeAheadDelay:1000,
		loadingText:'Searching...'
	});
	var ttable=createTable();
	var mainpanel=new Ext.Panel({
		id:'mainpanle',
		x:0,y:0,
    	header:false,
    	width:400,
    	height:600,
    	plain:true,
    	items:[ttable]
	});
	var win=new Ext.Window({
		title : '',
		id:'winLocWard',
		x:150,y:2,
		width : 385,
		height : 525,
		autoScroll : true,
		layout : 'absolute',
		modal:true,
		items : [mainpanel],
		buttons:[{
			id:'btnsure',
			text:'关闭',
			icon:'../images/uiimages/cancel.png',
			handler:function(){win.close();}
		}]
	});
	win.show();
	var mygrid1=Ext.getCmp('mygrid1');
	var trbar=mygrid1.getTopToolbar();
	trbar.addItem('-','护理单元',locWard1);
	trbar.addItem('-');
	trbar.addButton({
		id:'btnAdd1',
		text:'增加',
		icon:'../images/uiimages/edit_add.png',
		handler:function(){addward(Par);}
	});
	trbar.addItem('-');
	trbar.addButton({
		id:'',
		text:'删除',
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delitm();}	
	});
	locWard1.store.on('beforeload',function(){
		locWard1.store.baseParams.ward1=locWard1.lastQuery;
		locWard1.store.baseParams.nurseid=session['LOGON.USERID']+"^"+secGrpFlag+"^"+"";
	});
	mygrid1.store.on('beforeload',function(){
		mygrid1.store.baseParams.Par=Par;	
	})
	setgrid1(Par);
}
function createTable()
{
	var colModelStr = new Array();
	var colData = new Array();
	colModelStr.push(new Ext.grid.RowNumberer());
	colModelStr.push({header:"护理单元",width:300,dataIndex:'LocWard'});
	colData.push({'name':'LocWard','mapping':'LocWard'});
	colModelStr.push({header:"LocDr",width:30,dataIndex:'LocDr',hidden:true});
	colData.push({'name':'LocDr','mapping':'LocDr'});
	colModelStr.push({header:"Par",width:30,dataIndex:'Par',hidden:true});
	colData.push({'name':'Par','mapping':'Par'});
	colModelStr.push({header:"rw",width:30,dataIndex:'rw',hidden:true});
	colData.push({'name':'rw','mapping':'rw'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{
			className:'web.DHCMgQualCheck',
			methodName:'FindNurLocWard',
			type:'Query'
		}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid1',
		title:'所辖护理单元',
		region: 'center',
		split: true,
		height:600,
		width:400,
		x:0,y:0,
		collapsible: false,
		margins:'0 0 0 0',
		store: store,
		tbar: [],
		bbar: new Ext.PagingToolbar({ 
      		pageSize: 25, 
      		store: store, 
      		displayInfo: true, 
      		displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      		emptyMsg: "没有记录"
    	}),
		cm:colModel,
		sm:new Ext.grid.CheckboxSelectionModel()
	});
	return table;
}
function delitm()
{
	var grid=Ext.getCmp("mygrid1");
  var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	if (rowObj.length == 0) {
		return;
	}
	var rw= rowObj[0].get("rw");
	var Par=rowObj[0].get("Par");
	var delitm = document.getElementById('delitm');
	if (confirm('确定删除选中的项？')) {
		var a = cspRunServerMethod(delitm.value, Par+"||"+rw);
        setgrid1(Par);
    }
}
function addward(Par)
{
	var loc=Ext.getCmp("locWard1").getValue();
   	if(!loc){
		Ext.Msg.alert('提示','请选择护理单元！')
		return;
	}
	var isward=tkMakeServerCall("DHCMGNUR.MgNurseSub","isWard",Par,loc);
	if(isward==1){
		alert("护理单元已存在,请不要重复添加!");
		return;
	}
   	var Save = document.getElementById('SaveWard');
   	var a = cspRunServerMethod(Save.value, Par,loc);
   	if (a!=0){
  		setgrid1(Par);
  		return;
   	}
}
var CurrSelItm = "";
function griddblclick()
{
	var grid=Ext.getCmp("mygrid2");
  var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	if(rowObj.length == 0) {
		return;
	}
	CurrSelItm = rowObj[0].get("rw");
  setbutstatus(1);
	for(var r = 0; r < len; r++){
		list.push(rowObj[r].data);
	}
	for(var i = 0; i < list.length; i++){
		var obj = list[i];
		for(var p in obj){
			var itm= Ext.getCmp(p);
			if(itm!=undefined) itm.setValue(obj[p]);
		}
	}
}
function comboload(itm, str){
	var aa = str.split('!');
	var par = itm.id;
	if (aa.length < 2){
		itm.setValue(str);
		return;
	}
	if(str!=""){
		itm.getStore().load({
			params : {
				start : 0,
				limit : 10,
				locdes : aa[0]
			},
			callback : function(){
				itm.setValue(aa[1])
			}
		});
	}
}
function setgrid1(Par){
	var mygrid = Ext.getCmp("mygrid1");
	mygrid.store.load({
		params : {
			start : 0,
			limit : 25
		}
	});
}
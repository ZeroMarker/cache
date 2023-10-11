/**
 * @author Administrator
 */
 
var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-1;
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();

function SizeChange(changewidth) {
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;

	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth + changewidth);
	setsize("mygridpl", "gform", "mygrid");
}
// var commould = CreateComboBoxQ("commould","MouldName","rw","模块","","150","web.DHCMgNurSysComm","GetMould.RecQuery","sid",0,0);
var SortPos1=new Ext.form.TextField(
{
	tabIndex : '0',
	xtype : 'textfield',
	//height : 21,
	width : 24,
	name : 'SortPos1',
	id : 'SortPos1',
	value : ''
});

var loctyp1 = new Ext.form.ComboBox({
	name : 'LocTyp',
	id : 'LocTyp1',
	tabIndex : '0',
	x : 0,
	y : 0,
	//height : 20,
	width : 134,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : '病区',
			id : 'Ward'
		}, {
			desc : '特殊科室',
			id : 'PWard'
		}],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	mode : 'local',
	value : ''
});
function BodyLoadHandler() {
	//setsize("mygridpl", "gform", "mygrid");
	var gridPl = Ext.getCmp('mygridpl');
	gridPl.setHeight(Height);
	gridPl.setPosition(0,0);
	var grid1Pl = Ext.getCmp('mygrid1pl');
	grid1Pl.setHeight(Height);
	gridPl.setWidth(480);
	grid1Pl.setPosition(480,0);
	grid1Pl.setWidth(480);
	var grid = Ext.getCmp('mygrid1');
	var mygrid=Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	//grid.colModel.setHidden(2,true);
	var tbar1 = new Ext.Toolbar();
  grid.on("click",grid1click);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
//	var but1 = Ext.getCmp("mygridbut1");
//	but1.setText("确定");
//	but1.on('click', menusure);
	tbar1.addItem('-');
	tbar1.addButton({
		id:'addsurebtn',
		text:'保存',
		handler:menusure,
		icon:'../images/uiimages/filesave.png'	
	});
	//tobar.addItem('-');
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tbar1.render(mygrid.tbar);
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
	tobar.addItem("-","类型",loctyp1);
	tobar.addItem("-","序号",SortPos1);
	//tobar.addItem("-","科室",LocDes);
	gform.remove(loctyp);
  gform.remove(SortPos);
  //gform.remove(LocDes);
	var but1 = Ext.getCmp("mygrid1but1");
//	but1.setText("保存");
//	but1.on('click', menuSavePos);
	but1.hide();
	var but = Ext.getCmp("mygrid1but2");
	//but.setText("删除");
	but.hide();
	/* tobar.addItem('-');
	tobar.addButton({
		id:'saveitmbtn',
		text:'保存',
		handler:menuSavePos,
		icon:'../images/uiimages/filesave.png'
	}); */
	tobar.addItem('-');
	tobar.addButton({
		id:'delitmbtn',
		text:'删除',
		handler:menudelPos,
		icon:'../images/uiimages/edit_remove.png'
	});
	mygrid.colModel.setHidden(3,true);
	mygrid.getBottomToolbar().hide();
	var bbar3 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar3.render(mygrid.bbar);
	//but.on('click', menudelPos);
  var cmb=Ext.getCmp("LocTyp1");
  cmb.on("select",setgrid);
  cmb.setValue("Ward");
	// tobar.render(grid.tbar);
	tobar.doLayout();
	setgrid();
	loadgrid();
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'qudr'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function menudelPos()
{
	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var loctyp=Ext.getCmp("LocTyp1").getValue();
  var hsdr=1;
  var loc = rowObj[0].get("qudr");
  //alert(loc);
 	var delpos=document.getElementById('delpos');
	if (confirm('确定删除选中的项？')) {
		var a=cspRunServerMethod(delpos.value,hsdr,loctyp,loc);
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
  var loc = rowObj[0].get("qudr");
  if (sortpos!="")
  {
  	var SaveQt=document.getElementById('SavePos');
	var a=cspRunServerMethod(SaveQt.value,hsdr,loctyp,loc,sortpos);
      setgrid();
  }
}
function menusure()
{
	var grid = Ext.getCmp("mygrid");
  var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); 
	//debugger;
	var loctyp=Ext.getCmp("LocTyp1").getValue();
 	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}
  var SaveQt=document.getElementById('Save');
  var rw="";
  var str="";
  for (var i = 0; i < list.length; i++) {
		  var obj=list[i];
		  rw=obj["rw"];
		  str=str+rw+"^";
	}
	var a=cspRunServerMethod(SaveQt.value,loctyp,str);
  if (a!=0)
  {
  	Ext.Msg.alert('提示',a);
  	return;
  }
	setgrid();
}
function loadgrid() {
	// var cmb=Ext.getCmp("commould");
	var mygrid=Ext.getCmp("mygrid");
	mygrid.store.on("load",function(){
     setSelItem();
  });
	mygrid.store.load({
		params : {start:0,limit:30},
		callback : function() {}
	});
}
function setSelItem()
{
   var loctyp=Ext.getCmp("LocTyp1").getValue();
   var hsdr=1;
   var mygrid=Ext.getCmp("mygrid");
   var getselloc=document.getElementById('getselloc');
   var a=cspRunServerMethod(getselloc.value,hsdr,loctyp);
   mygrid.getSelectionModel().clearSelections();
	 if (a!="")
	 {
       var ha = new Hashtable();
       var arr=a.split('^');
       for (var i=0;i<arr.length;i++)
       {
          	ha.add(arr[i],arr[i]);
       }
       var n = mygrid.getStore().getCount();
       var store = mygrid.store;
       var arrsel = new Array();
       for( var j=0;j<n;j++)
       {
	       var LocDr=store.getAt(j).get("rw");
     	   if(ha.contains(LocDr)){
      	   	arrsel[j]=j;
      	 }
       }
       mygrid.getSelectionModel().selectRows(arrsel,true);  
	 }
}
function setgrid() {
	var mygrid = Ext.getCmp("mygrid1");
	mygrid.store.on("beforeLoad",function(){
    var loctyp=Ext.getCmp("LocTyp1").getValue();
	  var hsdr=1;
	  if (loctyp=="") return;
    mygrid.store.baseParams.HsDr=hsdr;
    mygrid.store.baseParams.typ=loctyp; 
  });
  var loctyp=Ext.getCmp("LocTyp1").getValue();
	var hsdr=1;
	if (loctyp=="") return;
	mygrid.store.load({params : {start : 0,limit : 30},
		callback : function() {
			setSelItem();
		}
	});
}
function menunew() {
	curmenuid = "";
	menuWin("");
}
function grid1click() {

	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		//alert("请选择一条记录！");
		return;
	}

	var sort = rowObj[0].get("SortPos");
    var sortpos=Ext.getCmp("SortPos1");
    sortpos.setValue(sort);

}
function QualSubWin() {

	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var menuid = rowObj[0].get("rw");
	curmenuid = menuid;
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMgNurQualSubList", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '菜单维护',
		id : "gform2",
		width : 700,
		height : 470,
		autoScroll : true,
		layout : 'absolute',
		// plain: true,
		// modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : arr
	});

	// debugger;
	window.show();
	var but1 = Ext.getCmp("butSave");
	but1.on('click', itmAdd);
	var but = Ext.getCmp("butMod");
	but.on('click', itmMod);
	var but2 = Ext.getCmp("butClear");
	but2.on('click', clearscreen);
	var grid = Ext.getCmp('mygrid2');
	grid.on('dblclick', griddblclick);
  var stdata=Ext.getCmp("mygrid2").store;
	stdata.on("beforeload",function(){stdata.baseParams.Par=curmenuid;})
	Ext.getCmp("mygrid2").store.load({
		params : {
			start : 0,
			limit : 10,
			Par : curmenuid
		}
	});
}

var CurrSelItm = "";
function SaveItm()
{
  ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	var parr = "rw|" + CurrSelItm + "^Par|" + curmenuid + "^" + ret + "^"+ checkret + "^" + comboret;
	var row = cspRunServerMethod(Save.value, parr);
	Ext.getCmp("mygrid2").store.load({
		params : {
			start : 0,
			limit : 10,
			Par : curmenuid
		}
	});
	return;
}
function itmAdd() {
   CurrSelItm=""
   SaveItm();
}
function itmMod() {
	if (CurrSelItm=="") return;
	SaveItm();
}
function clearscreen() {
   Ext.getCmp("ItemDesc").setValue("");
  Ext.getCmp("ItemCode").setValue("");
  Ext.getCmp("ItemLevel").setValue("");
  Ext.getCmp("ItemMem").setValue("");
  Ext.getCmp("ItemValue").setValue("");
  setbutstatus(0);
}
function setbutstatus(flag)
{
  var but1 = Ext.getCmp("butSave");
	var but = Ext.getCmp("butMod");
	var but2 = Ext.getCmp("butClear");
	if (flag==0){
      but.disable();
      but1.enable();
	}else{
	
	 but1.disable();
	 but.enable();
	 
	}
}
function griddblclick()
{
	var grid=Ext.getCmp("mygrid2");
  var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var list = [];
	if (rowObj.length == 0) {
		return;
	}
	CurrSelItm = rowObj[0].get("rw");
    setbutstatus(1);
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		for (var p in obj) {
			var itm= Ext.getCmp(p);
			if (itm!=undefined) itm.setValue(obj[p]);
		}
	}
}
function menuWin(menuid) {

	var arr = new Array();
	curmenuid = menuid;
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNurQualGui", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '菜单维护',
		id : "gform2",
		width : 600,
		height : 250,
		autoScroll : true,
		layout : 'absolute',
		items : arr,
		buttons : [{
			text : '保存',
			icon:'../images/uiimages/filesave.png',
			handler : function() {
				Save(window, menuid);
			}
		}, {
			text : '关闭',
			icon:'../images/uiimages/cancel.png',
			handler : function() {
				window.close();
			}
		}]
	});
	window.show();
	setvalue(menuid);
}
function SaveGrid() {
	var grid = Ext.getCmp("mygrid1");
	var store = grid.store;
	var rowCount = store.getCount(); // 记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var SaveQt = document.getElementById('SaveSub');
	var rw = "";
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		var str = "";
		var CareDate = "";
		var CareTime = "";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "")
				continue;
			// str = str + p + "|" + obj[p] + '^';
			if (aa == "") {
				str = str + p + "|" + obj[p] + '^';
			} else {
				str = str + p + "|" + aa + '^';
			}
			rw = obj["rw"];
		}
		if (str != "") {
			if (rw == undefined)
				str = str + "Par|" + curmenuid;
			var a = cspRunServerMethod(SaveQt.value, str);
			if (a != 0) {
				alert(a);
			}
		}
	}
	Ext.getCmp('mygrid1').store.load({
				params : {
					start : 0,
					limit : 10,
					Par : curmenuid
				}
			});
}
function setvalue(menid) {

	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menid);
	var tm = ret.split('^')
	sethashvalue(ha, tm)
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	for (var i = 0; i < ht.keys().length; i++)// for...in statement get all of
	{
		var key = ht.keys()[i];
		// restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_") == -1) {
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				if (itm.xtype == "combo") {
					comboload(itm, ha.items(key));
				} else {
					itm.setValue(ha.items(key));
				}
		} else {
			var aa = key.split('_');
			if (ha.contains(aa[0])) {
				setcheckvalue(key, ha.items(aa[0]));
			}
		}
	}
}
function comboload(itm, str) {
	var aa = str.split('!');
	var par = itm.id;
	// alert(aa.length);
	if (aa.length < 2) {
		itm.setValue(str);
		return;
	}
	if (str != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 10,
				locdes : aa[0]
			},
			callback : function() {
				itm.setValue(aa[1])
			}
		});
	}
}
function Save(win, menuid) {
	ret = "";
	checkret = "";
	comboret = "";
	var Save = document.getElementById('Save2');
	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	var parr = "rw|" + menuid + "^" + ret + "^" + checkret + "^" + comboret;
	menuid = cspRunServerMethod(Save.value, parr);
	curmenuid = menuid;
	win.close();
	loadgrid();
	return;
}

function setgrid1() {
	var mygrid = Ext.getCmp("mygrid1");
	mygrid.store.load({
		params : {
			start : 0,
			limit : 10
		}
	});

}

function additm() {
	var grid = Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([]);
	var count = grid.store.getCount();
	var r = new Plant();
	grid.store.commitChanges();
	grid.store.insert(count, r);
	return;

}

function typdelete() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if (len == 0) {
		Ext.Msg.alert('提示', "请先选择一行!");
		return;
	};
	var QtDelete = document.getElementById('QtDelete');
	if (QtDelete) {
		var id = rowObj[0].get("rw");
		var ee = cspRunServerMethod(QtDelete.value, id);
		if (ee != "0") {
			alert(ee);
			return;
		}
	}
	setgrid();
};
/**
 * @author Administrator
 */
var Width=document.body.clientWidth;
var Height=document.body.clientHeight;
var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();
var DHCMGNURMENUT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemTyp','mapping':'ItemTyp'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'GetMenuItem',type:'RecQuery'}});
var curmenuid="";
var cmbitm = new Hashtable();
function SizeChange(changewidth)
{
  var fheight=document.body.offsetHeight;
	var fwidth=document.body.offsetWidth;
	var fm=Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth+changewidth);
    setsize("mygridpl","gform","mygrid");
}
var commould =CreateComboBoxQ("commould","MouldName","rw","模块","","200","web.DHCMgNurSysComm","GetMould.RecQuery","sid",0,0);
function BodyLoadHandler() {
	//setsize('mygridpl', 'gform', 'mygrid');
	var mygridpl = Ext.getCmp('mygridpl');
	mygridpl.setWidth(Width);
	mygridpl.setHeight(Height);
	var grid = Ext.getCmp('mygrid');
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.hide();
	var tbar1 = new Ext.Toolbar();
	tbar1.addItem('-');
	tbar1.addButton({
		id:'addnewbtn',
		text:'增加',
		handler:menunew,
		icon:'../images/uiimages/edit_add.png'	
	});
	tbar1.addItem("-");
	tbar1.addButton({
		id:'delitmbtn',
		text:'编辑',
		handler:menumod,
		icon:'../images/uiimages/pencil.png'
	});
	tbar1.addItem("-","模块",commould);
	tbar1.addItem("-");
	tbar1.addButton({
		//className: 'new-topic-button', 
		text: "删除",
		handler:function(){MenuDel();},
		id:'btndel',
		icon:'../images/uiimages/edit_remove.png'
  });
  grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
 	tbar1.render(grid.tbar);
 	bbar2.render(grid.bbar);
	tobar.doLayout();
//	var but1=Ext.getCmp("mygridbut1");
//	but1.on('click',menunew);
//	var but = Ext.getCmp("mygridbut2");
//	but.setText("编辑");
//	but.on('click',menumod);
	tbar2=new Ext.Toolbar({});	
	Ext.getCmp("commould").getStore().load({params:{start:0,limit:10,sid:2},callback:function() {}});
	var cmb=Ext.getCmp("commould");
  cmb.on("select",loadgrid);
 	var stdata=grid.store;
	stdata.on("beforeLoad",function(){
		stdata.baseParams.mouldid=cmb.getValue();
	});
 	grid.store.load({params:{start:0, limit:30}});
 	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function loadgrid()
{
	var cmb=Ext.getCmp("commould");
 	Ext.getCmp("mygrid").store.load({params:{start:0, limit:30,mouldid:cmb.getValue()}});
}
function menunew()
{
  curmenuid="";
  var menuid=""
  menuWin(menuid);
}
function menumod()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var menuid=rowObj[0].get("rw");
	menuWin(menuid);
}
function MenuDel()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	if (confirm('确定删除选中的项？')) {
		var menuid=rowObj[0].get("rw");
	  var delete1=document.getElementById('delete');
	  var a=cspRunServerMethod(delete1.value,menuid);
	  if(a==0){
		Ext.Msg.alert('提示',"删除成功!");
		grid.store.load({params:{start:0, limit:30}});
	  }
    }
}
function menuWin(menuid) 
{
	var arr = new Array();
	curmenuid=menuid;
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNURMENU", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '菜单维护',
		id:"gform2",
		width : 560,
		height : 450,
		autoScroll : true,
		layout : 'absolute',
		// plain: true,
		 modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : arr,
		buttons : [{
			text : '保存',
			icon:'../images/uiimages/filesave.png',
			handler : function() {
				Save(window,menuid);
				//window.close();
			}
		}, {
			text : '关闭',
			icon:'../images/uiimages/cancel.png',
			handler : function() {
				window.close();
			}
		}]
	});

	//debugger;
	window.show();
	if(!menuid){
		Ext.getCmp('mygrid1').getStore().removeAll();	
	}
	var grid=Ext.getCmp('mygrid1');
	grid.getTopToolbar().hide();
	var tbarsub = new Ext.Toolbar();
	tbarsub.addItem('-');
	tbarsub.addButton({
		id:'addsubbtn',
		text:'增加',
		handler:additm,
		icon:'../images/uiimages/edit_add.png'
	});
	tbarsub.addItem('-');
	tbarsub.addButton({
		id:'savesubbtn',
		text:'保存',
		handler:function(){SaveGrid(menuid);},
		icon:'../images/uiimages/filesave.png'
	});
//	var but1=Ext.getCmp("mygrid1but1");
//	but1.on('click',additm);
//	var but2=Ext.getCmp("mygrid1but2");
//	but2.setText("保存");
//	but2.on('click',function(){SaveGrid(menuid);});
	var cmould=Ext.getCmp("NurProduct");
  var cmparent=Ext.getCmp("ParentMenuNod");
  cmbitm.add("ParentMenuNod","menu");
  cmbitm.add("NurProduct","mouldname");
  var cmbstore=cmparent.getStore();
  cmbstore.on("beforeload",function(){
		cmbstore.baseParams.mouldid=cmould.getValue();
	});
	setvalue(menuid);
	//var grid=Ext.getCmp('mygrid1');
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:1000,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	tbarsub.render(grid.tbar);
	bbar2.render(grid.bbar);
	Ext.getCmp('mygrid1').store.load({params:{start:0, limit:1000,Par:curmenuid}});
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'Par'){
			grid.getColumnModel().setHidden(i,true);
		}

  }
}
function SaveGrid(menuid)
{
	var grid = Ext.getCmp("mygrid1");
  	var store = grid.store;
	var rowCount = store.getCount(); //记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount(); 
 	var list = [];
	//for (var i = 0; i < store.getCount(); i++) {
	//	list.push(store.getAt(i).data);
	//	//debugger;
	//}
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len==0){Ext.Msg.alert('提示','请选择要保存的记录！');return;}
	if(!menuid){Ext.Msg.alert('提示','请先保存菜单后再为菜单添加控制元素！');Ext.getCmp('mygrid1').getStore().removeAll();return;}
	for (var r = 0;r < len; r++) {
		list.push(rowObj[r].data);
	}
  	var SaveQt=document.getElementById('SaveSub');
  	var rw="";
  	for (var i = 0; i < list.length; i++) {
  		var obj=list[i];
	  	var str="";
	  	var CareDate="";
	  	var CareTime="";
    	for (var p in obj) {
	  	var aa = formatDate(obj[p]);
			if (p=="") continue;
			//str = str + p + "|" + obj[p] + '^';
		  if (aa == ""){
	    	str = str + p + "|" + obj[p] + '^';
	    }else{
				str = str + p + "|" + aa + '^';	
			}
			rw=obj["rw"];
		}
		if (str!="")
		{
		  if (rw==undefined) str=str+"Par|"+curmenuid;
		  var a=cspRunServerMethod(SaveQt.value,str);
		  if (a!=0)
		  {
		  	//alert(a);
		  	//return;
		  }
		}
	}
	Ext.getCmp('mygrid1').store.load({params:{start:0, limit:1000,Par:curmenuid}});
}
function setvalue(menid)
{
	 var ha = new Hashtable();
	 var getval=document.getElementById('getVal');
	 var ret=cspRunServerMethod(getval.value,menid);
   	var tm=ret.split('^')
	 sethashvalue(ha,tm)
//	 var tm1=ret.split('^')
//	 sethashvalue(ha,tm1);
	 var gform=Ext.getCmp("gform2");
   gform.items.each(eachItem, this);  
	
   for (var i=0 ; i<ht.keys().length;i++){//for...in statement get all of Array's index
   	var key = ht.keys()[i];
		//restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_")==-1){
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			if (itm.xtype=="combo")
			{
				comboload(itm,ha.items(key));
			}else{
				itm.setValue(ha.items(key));	
			}
	  }else{
			var aa=key.split('_');
			if(ha.contains(aa[0])){
			  setcheckvalue(key,ha.items(aa[0]));
			}
		}
   }
}
function comboload(itm,str)
{
   var aa=str.split('!');
   //alert(aa);
   var par=itm.id;
   itm.getStore().baseParams[cmbitm.items(itm.id)]=aa[0];
	 if (str!=""){
	 	itm.getStore().load({
			params : {
				start : 0,
				limit : 10,
				par:aa[0]
			},
			callback : function() {
				itm.setValue(aa[1])
			}
		});
	 }
}
function Save(win,menuid)
{
	var mould=Ext.getCmp("NurProduct");
	var menucode=Ext.getCmp("MenuCode");
	var MenuTitle=Ext.getCmp("MenuTitle");
	if (mould.getValue()=="") {
	  Ext.Msg.alert('提示',"请选择所属模块！");
	  return;
	}
	if (menucode.getValue()=="") {
	  Ext.Msg.alert('提示',"菜单代码不能为空！");
	  return;
	}	
	if (MenuTitle.getValue()=="") {
	  Ext.Msg.alert('提示',"菜单名称不能为空！");
	  return;
	}
	ret="";
	checkret="";
	comboret="";
	
	var Save=document.getElementById('Save2');
	var gform=Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	//var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	//var parr=ret+"&"+checkret+"&"+comboret;
	//alert(ret+"^"+checkret+"^"+comboret);
	var parr= "rw|"+menuid+"^"+ret+"^"+checkret+"^"+comboret;
	var flag=tkMakeServerCall("DHCMGNUR.MenuSystem","getFlag",parr)
	if(flag==1){
		alert("显示顺序已存在，请修改！");
		return;
	}
	//var id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret); //+"^UserDr|"+session['LOGON.USERID']
  	menuid=cspRunServerMethod(Save.value,parr);
  	curmenuid=menuid;
	win.close();
  	loadgrid();
  	return;
}


function setgrid1()
{	
   /* var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHDCodeComm:HDMode", "","AddRec");
   grid.store.loadData(arrgrid);   */
	var mygrid = Ext.getCmp("mygrid1");
	//var parr = getParameters()
	mygrid.store.load({params:{start:0, limit:30}});
}
function setgrid()
{	
   /* var grid = Ext.getCmp("mygrid");
	var GetQueryData=document.getElementById('GetQueryData');
	arrgrid=new Array();
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurHDCodeComm:HDMode", "","AddRec");
   grid.store.loadData(arrgrid);   */
	var mygrid = Ext.getCmp("mygrid");
	//var parr = getParameters()
	//alert(parr);
	// debugger;
	mygrid.store.load({params:{start:0, limit:30}});
}
function additm()
{
	var grid=Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([]);
  // the "name" below matches the tag name to read, except "availDate"
  // which is mapped to the tag "availability"
  var count = grid.store.getCount(); 
  var r = new Plant(); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
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
	if (QtDelete)
	{
   var id=rowObj[0].get("rw");
		var ee = cspRunServerMethod(QtDelete.value, id);
		if (ee != "0") {
			//alert(ee);
			return;
		}
 	}
	setgrid();
};
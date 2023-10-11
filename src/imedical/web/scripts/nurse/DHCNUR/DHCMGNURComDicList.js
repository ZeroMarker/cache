/**
 * @author Administrator
 */
var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
var DHCMGNURCODECATGUIT108=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'Code','mapping':'Code'},{'name':'CodeDesc','mapping':'CodeDesc'},{'name':'txtMem','mapping':'txtMem'},{'name':'HisDr','mapping':'HisDr'},{'name':'FromDate','mapping':'FromDate'},{'name':'EndDate','mapping':'EndDate'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'GetCodeItem',type:'RecQuery'}});

var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var curmenuid = "";
function SizeChange(changewidth) {
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth + changewidth);
	setsize("mygridpl", "gform", "mygrid");
}
var commould = CreateComboBoxQ("commould", "MouldName", "rw", "模块", "", "200","web.DHCMgNurSysComm", "GetMould.RecQuery", "sid", 0, 0);
function BodyLoadHandler() {
	//setsize("mygridpl", "gform", "mygrid");
	var myGridPl = Ext.getCmp('mygridpl');
	myGridPl.setWidth(Width);
	myGridPl.setHeight(Height);
	var grid = Ext.getCmp('mygrid');
	//grid.colModel.setHidden(7,true);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	tobar.hide();
	var tbar1 = new Ext.Toolbar();
	tbar1.addItem('-');
	tbar1.addButton({
		id:'addbtn',
		text:'增加',
		handler:menunew,
		icon:'../images/uiimages/edit_add.png'
	});
	tbar1.addItem('-');
	tbar1.addButton({
		id:'editbtn',
		text:'编辑',
		handler:menumod,
		icon:'../images/uiimages/pencil.png'
	});
	tbar1.addItem("-", "模块", commould);
	tbar1.render(grid.tbar);
	tbar1.doLayout();
	grid.getBottomToolbar().hide();
	var bbar12 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar12.render(grid.bbar);
	Ext.getCmp("commould").getStore().load({
		params : {start : 0,limit : 30,sid : 2},callback : function() {}
	});
	Ext.getCmp("mygrid").store.on('beforeLoad',function(){
		var strSid=Ext.getCmp('commould').getValue();
		Ext.getCmp("mygrid").store.baseParams.sid=strSid;	
	})
	var cmb = Ext.getCmp("commould");
	cmb.on("select", loadgrid);
	grid.store.load({params : {start : 0,limit : 30}});
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function loadgrid() 
{
	var cmb = Ext.getCmp("commould");
	Ext.getCmp("mygrid").store.load({
		params : {start : 0,limit : 30,mouldid : cmb.getValue()}
	});
}
function menunew() {
	curmenuid = "";
	var menuid="";
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
	var menuid = rowObj[0].get('rw');
	menuWin(menuid);
}
function menuWin(menuid)
{
	var arr = new Array();
	curmenuid = menuid;
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNURCODECATGUI", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '菜单维护',
		id : "gform2",
		width : 585,
		height :450,
		autoScroll : true,
		layout : 'absolute',
		items : arr,
		modal:true,
		resizable:false,
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
	var grid1=Ext.getCmp('mygrid1');
//	grid1.colModel.setHidden(6,true);
//	grid1.colModel.setHidden(7,true);
	if(!menuid){
		grid1.getStore().removeAll();
	}
	var tobar1=grid1.getTopToolbar();
	tobar1.hide();
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
	tbarsub.addItem('-');
	tbarsub.addButton({
		id:'delItem',
		hidden:true,
		text:'删除',
		icon:'../images/uiimages/edit_remove.png',
		handler:function(){delItem(menuid);}
	});
	var cmould = Ext.getCmp("MouldCode");
	if(menuid==""){
		setvalue(menuid);
	}else{
		setvalueOld(menuid);
	}
	if (curmenuid=="") return; 
	var mygrid1=Ext.getCmp("mygrid1").store; 
	mygrid1.on("beforeload",function(){
		 	mygrid1.baseParams.Par=curmenuid;
	})
	var grid1=Ext.getCmp('mygrid1');
	grid1.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid1.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	tbarsub.render(grid1.tbar);
	bbar2.render(grid1.bbar);
	Ext.getCmp('mygrid1').store.load({params:{start:0,limit:30,Par:curmenuid}});
	var len = grid1.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid1.getColumnModel().getDataIndex(i) == 'rw'){
			grid1.getColumnModel().setHidden(i,true);
		}
		if(grid1.getColumnModel().getDataIndex(i) == 'Par'){
			grid1.getColumnModel().setHidden(i,true);
		}
  }
}
function setvalueOld(menuid)
{
	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menuid);
	var tm = ret.split('^')
	sethashvalue(ha, tm)
	//CateDesc|测试^Category|测试^
	//ChildSub|5@%Library.RelationshipObject^Code|test^
	//CodeUse|测试1^HisDr|北京地坛医院!2^
	//MouldCode|护理人力资源管理!1^ValidFlag|无效^
	Ext.getCmp('Category').setValue(ha.items('Category'));
	//alert(ha.items('MouldCode').split('!')[1])
	//护理人力资源管理!1
	
	var MouldCodeStore=Ext.getCmp("MouldCode").getStore();
	MouldCodeStore.load({params:{start:0,limit:100}});
	MouldCodeStore.on('load',function(MouldCodeStore,records,options){
		Ext.getCmp("MouldCode").selectText();
		Ext.getCmp("MouldCode").setValue(ha.items("MouldCode")) //.split('!')[1]);
	});
	var HisDrStore=Ext.getCmp("HisDr").getStore();
	HisDrStore.load({params:{start:0,limit:100}});
	HisDrStore.on('load',function(HisDrStore,records,options){
		Ext.getCmp("HisDr").selectText();
		//Ext.getCmp("HisDr").setValue(ha.items("HisDr").split('!')[1]);
		Ext.getCmp('HisDr').setValue(ha.items('HisDr'));
	});
	//Ext.getCmp('HisDr').setValue(ha.items('HisDr'));
	Ext.getCmp('CateDesc').setValue(ha.items('CateDesc'));
	Ext.getCmp('Code').setValue(ha.items('Code'));
	if(ha.items('ValidFlag')=='有效'){
		Ext.getCmp('ValidFlag_1').setValue(true);	
	}else{
		Ext.getCmp('ValidFlag_1').setValue(false);
	}
	Ext.getCmp('CodeUse').setValue(ha.items('CodeUse'))
}
function delItem(menuid)
{
	//if(!par){Ext.Msg.alert('提示','请')}
	var grid = Ext.getCmp('mygrid1');
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var par=rowObj[0].get('Par');
	if(!par){Ext.Msg.alert('删除失败','请先保存菜单类别后确认删除数据！');Ext.getCmp('mygrid1').getStore().reload();return;}
	var rw=rowObj[0].get('rw');
	var Delete=document.getElementById('del');
	var a=cspRunServerMethod(Delete.value,par+"||"+rw);
	//alert(a)
	Ext.getCmp('mygrid1').store.load({params : {start:0,limit:30}});
}
function SaveGrid(par) {
	var grid = Ext.getCmp("mygrid1");
	var store = grid.store;
	var rowCount = store.getCount(); // 记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	
	var len = rowObj.length;
	if(len==0){Ext.Msg.alert('提示','请选择保存的记录！');return;}
	if(!par){
		Ext.Msg.alert('提示','请先保存类别数据后再添加数据！');
		Ext.getCmp('mygrid1').getStore().reload();
		Ext.getCmp('gform2').close();
		return;
	}
	
	var FromDate=rowObj[0].get('FromDate');
	var EndDate=rowObj[0].get('EndDate');
	if(FromDate!=undefined&FromDate!=""){
		//var reg=/^((((19|20)(([02468][048])|([13579][26]))-02-29))|((20[0-9][0-9])|(19[0-9][0-9]))-((((0[1-9])|(1[0-2]))-((0[1-9])|(1\d)|(2[0-8])))|((((0[13578])|(1[02]))-31)|(((01,3-9])|(1[0-2]))-(29|30)))))$/;
		//if(!reg.test(FromDate.format('Y-m-d'))){Ext.Msg.alert('提示','开始日期格式不对！');return;}
		if(EndDate!=undefined&EndDate!=""){	
			if(FromDate instanceof Date){
				stDate=new Date(FromDate).format('m/d/Y');
				var value1=Date.parse(stDate);
				if(EndDate instanceof Date){
					endDate=new Date(EndDate).format('m/d/Y');
					var value2=Date.parse(endDate);
				}else{
					endDate=EndDate;
					var endDateArr=endDate.toString().split('-');
					var endDateStr=endDateArr[1]+'-'+endDateArr[2]+'-'+endDateArr[0];
					var endDate1=new Date(endDateStr);
					endDate1=endDate1.format('m/d/Y');
					var value2=Date.parse(endDate1);
				}
				if(value1>value2){Ext.Msg.alert('提示','开始日期不能大于结束日期');return;}
			}else{
				stDate=FromDate;
				var stDateArr=stDate.toString().split('-');
				var stDateString=stDateArr[1]+'-'+stDateArr[2]+'-'+stDateArr[0]
				var stDate1=new Date(stDateString)
				stDate1=stDate1.format('m/d/Y');
				value1=Date.parse(stDate1);
				if(EndDate instanceof Date){
					endDate=new Date(EndDate).format('m/d/Y');
					var value2=Date.parse(endDate);
				}else{
					endDate=EndDate;
					var endDateArr=endDate.toString().split('-');
					var endDateStr=endDateArr[1]+'-'+endDateArr[2]+'-'+endDateArr[0];
					var endDate1=new Date(endDateStr);
					endDate1=endDate1.format('m/d/Y');
					var value2=Date.parse(endDate1);
				}
				if(value1>value2){Ext.Msg.alert('提示','开始日期不能大于结束日期！');return;}
			}
		}
	}
//	var stDate=rowObj[0].get('FromDate');
//	//alert(stDate)
//	var endDate=rowObj[0].get('EndDate');
//	if((stDate)&&(endDate)){
//		//var date1=stDate.replace(/-/g,'/');
//		//var date2=endDate.replace(/-/g,'/');
//		//alert(date1)
//		var d1=new Date(stDate);
//		alert(d1)   
//    var d2=new Date(endDate); 
//		if(Date.parse(d1)-Date.parse(d2)<0){
//			Ext.Msg.alert('提示','开始日期不能晚于结束日期');
//			return;
//		} 
//	}
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	var SaveQt = document.getElementById('SaveSub');
	var rw = "";
	for (var i=0;i<list.length;i++){
		var obj=list[i];
		var str="";
		var CareDate="";
		var CareTime="";
		for (var p in obj) {
			var aa = formatDate(obj[p]);
			if (p == "")
				continue;
			// str = str + p + "|" + obj[p] + '^';
			if(aa==""){
				str=str+p+"|"+obj[p]+'^';
			}else{
				str=str+p+"|"+aa+'^';
			}
			rw=obj["rw"];
		}
		if(str!=""){
			if(rw==undefined)
				str=str+"Par|"+curmenuid;
				//alert(str);
			var a = cspRunServerMethod(SaveQt.value, str);
			if (a != 0) {
			}
		}
	}
	Ext.getCmp('mygrid1').store.load({
		params : {
			start : 0,
			limit : 30,
			Par : curmenuid
		}
	});
	
}
function setvalue(menid) {

	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menid);
	var tm = ret.split('^')
	 //alert(ret);
	sethashvalue(ha, tm)

	var gform = Ext.getCmp("gform2");
	gform.items.each(eachItem, this);
	for (var i = 0; i < ht.keys().length; i++)// for...in statement get all of// Array's index
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

	if (str != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 30,
				par : aa[0]
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
	var Save = document.getElementById('Save');
	var gform = Ext.getCmp("gform2");
	var Category=Ext.getCmp('Category').getValue();
	if(!Category){Ext.Msg.alert('提示','类别不能为空！');return;}
	var MouldCode=Ext.getCmp('MouldCode').getValue();
	if(!MouldCode){Ext.Msg.alert('提示','模块不能为空！');return;}
	var Code=Ext.getCmp('Code').getValue();
	if(!Code){Ext.Msg.alert('提示','代码不能为空！');return;}
	//alert(Ext.getCmp('ValidFlag_1').getValue())
	var ValidFlag=Ext.getCmp('ValidFlag_1').getValue();
	var CateDesc=Ext.getCmp('CateDesc').getValue();
	//下一行修改(1行)
	//////////////////gform.items.each(eachItem, this);
	//alert(Ext.getCmp('ValidFlag_1').id)
	// alert(NurRecId);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// alert(rw);
	// var parr=ret+"&"+checkret+"&"+comboret;
	// alert(ret+"^"+checkret+"^"+comboret);
	var HisDr=Ext.getCmp('HisDr').getValue();
	var CodeUse=Ext.getCmp('CodeUse').getValue();
	var parr="rw|"+menuid+"^Category|"+Category+"^MouldCode|"+MouldCode+"^Code|"+Code+"^ValidFlag|"+ValidFlag+"^CateDesc|"+CateDesc+"^HisDr|"+HisDr+"^CodeUse|"+CodeUse

	menuid = cspRunServerMethod(Save.value, parr);
	curmenuid = menuid;
	win.close();
	Ext.getCmp('mygrid').store.load({
		params:{
			start:0,
			limit:30
		}
	});
	return;
}

function setgrid1() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var mygrid = Ext.getCmp("mygrid1");
	// var parr = getParameters()
	// alert(parr);
	// debugger;
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function setgrid() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var mygrid = Ext.getCmp("mygrid");
	// var parr = getParameters()
	// debugger;
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function additm() {
	//alert('1')
	var grid = Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([
		// the "name" below matches the tag name to read, except "availDate"
		// which is mapped to the tag "availability"
	]);
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
/**
 * @author Administrator
 */
var Height = document.body.clientHeight;
var Width = document.body.clientWidth;
var ret = "";
var checkret = "";
var comboret = "";
//var CheckTyp="";
var arrgrid = new Array();

var DHCNurMgChItmMulT101=new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({
		url:"../csp/dhc.nurse.ext.common.getdata.csp"
	}),
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		fields:[{
			'name':'QualDesc',
			'mapping':'QualDesc'
		},
		{
			'name':'QualWeight',
			'mapping':'QualWeight'
		},{
			'name':'rw',
			'mapping':'rw'
		}]
	}),
	baseParams:{
		className:'web.DHCMgNurSysComm',
		methodName:'FindWardRoomItem',
		type:'RecQuery'
	}
});

var DHCMGNurCheckGradeT101 = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : "../csp/dhc.nurse.ext.common.getdata.csp"
	}),
	reader : new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : 'results',
		fields : [{
			'name' : 'ItemCode',
			'mapping' : 'ItemCode'
		}, {
			'name' : 'ItemDesc',
			'mapping' : 'ItemDesc'
		}, {
			'name' : 'ItemValue',
			'mapping' : 'ItemValue'
		}, {
			'name' : 'ItemDedStand',
			'mapping' : 'ItemDedStand'
		}, {
			'name' : 'CheckScore',
			'mapping' : 'CheckScore'
		}, {
			'name' : 'CheckMem',
			'mapping' : 'CheckMem'
		}, {
			'name' : 'rw',
			'mapping' : 'rw'
		}, {
			'name' : 'Par',
			'mapping' : 'Par'
		}, {
			'name' : 'MinLevel',
			'mapping' : 'MinLevel'
		}]
	}),
	baseParams : {
		className : 'web.DHCMgQualCheck',
		methodName : 'GetQualItemGrade',
		type : 'RecQuery'
	}
});
var DHCNurQualCheckT104=new Ext.data.JsonStore({data:[],fields:['User','rw']});
var DHCNurQualCheckT109=new Ext.data.JsonStore({data:[],fields:['Qual','rw','QualWeight']});
var DHCNurCheckRoomQualT103=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'ItemLevel','mapping':'ItemLevel'},{'name':'Par','mapping':'Par'},{'name':'rw','mapping':'rw'},{'name':'MinLevel','mapping':'MinLevel'}]}),baseParams:{className:'web.DHCMgQualCheck',methodName:'GetCheckItemSub',type:'RecQuery'}});

function SizeChange(changewidth) {
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth + changewidth);
	setsize("mygridpl", "gform", "mygrid");
}
// var commould=CreateComboBoxQ("commould","MouldName","rw","模块","","150","web.DHCMgNurSysComm","GetMould.RecQuery","sid",0,0);
var stdate=new Ext.form.DateField({
	name:'StDate',
	id:'StDate',
	//format:'Y-m-d',
	tabIndex:'0',
//	height:20,
//	width:119,
	xtype:'datefield',
	value:new Date((new Date()).getFullYear(),(new Date()).getMonth(),1).format('Y-m-d')
});
var eddate=new Ext.form.DateField(
{
	name : 'EndDate',
	id : 'EndDate',
	//format : 'Y-m-d',
	tabIndex : '0',
//	height : 21,
//	width : 116,
	xtype : 'datefield',
	value : new Date()
});
var getsschk=document.getElementById('getsschk');
 	NurTyp=cspRunServerMethod(getsschk.value,session['LOGON.USERID']);
var QualScore=0;
var NurTyp="";
//判断安全组
	var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler(){
	//alert(secGrpFlag);
	//setsize("mygridpl", "gform", "mygrid",0);
 	var myGridPl = Ext.getCmp('mygridpl');
 	myGridPl.setWidth(Width);
 	myGridPl.setHeight(Height);
	var grid = Ext.getCmp('mygrid');
	//grid.colModel.setHidden(8,true);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
	grid.on("dblclick",checkroom);
	tobar.addItem("-","检查日期",stdate);
	tobar.addItem("-",eddate);
	//tobar.addItem("-","科室",LocDes);
	tbar2=new Ext.Toolbar({});
	tbar2.addItem('-');
	tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({ 
		text:"增加",
		handler:function(){NewCheck();},//新建查房
		id:'btnnew',
		hidden:true,
		icon:'../images/uiimages/edit_add.png'
	});
	//tbar2.addItem(new Ext.form.Label({width:10}));
 	tbar2.addItem("-");
  //tbar2.addItem(new Ext.form.Label({width:10}));
  tbar2.addButton({ 
		text: "编辑",
		icon:'../images/uiimages/pencil.png',
		handler:function(){ModCheck();},//编辑条目
		id:'btnmod',
		hidden:true
  });
  //tbar2.addItem(new Ext.form.Label({width:10}));
  tbar2.addItem("-");
  //tbar2.addItem(new Ext.form.Label({width:10}));
  tbar2.addButton({
  	text:"删除",
  	handler:function(){delQualItem();},
  	id:'btnDel',
  	hidden:true,
  	icon:'../images/uiimages/edit_remove.png'
  });
  //tbar2.addItem(new Ext.form.Label({width:10}));
  tbar2.addItem("-");
  //tbar2.addItem(new Ext.form.Label({width:10}));
  tbar2.addButton({
		text: "查询",
		handler:function(){SchQual();},//查询
		id:'btnSch',
		hidden:true,
		icon:'../images/uiimages/search.png'
  });
	tbar2.render(grid.tbar);
	grid.getBottomToolbar().hide();
		var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tobar.doLayout();	
	grid.getColumnModel().setHidden(5, true);
	//****************************************//
	//通过HIS安全组判断显示页面控件元素
	//var PageElement=tkMakeServerCall("web.DHCMgNurSecGrpComm","getPageElement",session['LOGON.GROUPID'],EmrCode)
	var PageElement=tkMakeServerCall("web.DHCMgNurSecGrpComm","getPageElement",session['LOGON.GROUPID'],menucode);
	//--PageElement="addNewbtn^longTranBtn"
	var ElementArray=PageElement.split('^');
	for(var i=0;i<ElementArray.length;i++){
		if(Ext.getCmp(ElementArray[i])){
			Ext.getCmp(ElementArray[i]).show();
		}
	}
	//****************************************//
	if(secGrpFlag=="hlb"||secGrpFlag=="demo"){flag=1}
	else{flag=0;}
  var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeLoad",function(){
		var stdate=Ext.getCmp("StDate").getValue();//列表界面日期初始化
		if(!stdate){
			Ext.Msg.alert('提示','开始日期不能为空！');
			return
		}else{
			if(stdate instanceof Date){
				stdate = stdate.format('Y-m-d');	
			}
		}
 		var eddate=Ext.getCmp("EndDate").getValue();
 		if(!eddate){
 			Ext.Msg.alert('提示','结束日期不能为空！');
 			return;
 		}else{
 			if(eddate instanceof Date){
 				eddate = eddate.format('Y-m-d');	
 			}
 		}
  	var mygrid = Ext.getCmp("mygrid");
  	mygrid.store.baseParams.parr=stdate+"^"+eddate+"^"+CheckTyp+"^"+session['LOGON.USERID']+"^"+flag;
  });
	SchQual();
	//'NurTyp'
	var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'NurTyp'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
  }

	//loadgrid();
}
function checkroom()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}    
	var CheckRoomId = rowObj[0].get("rw");
	var CheckTyp = rowObj[0].get("CheckTyp");
	var eCode="DHCMGNurStChkList";//?
	if ((CheckTyp=="QualCheck")||(CheckTyp=="SpecCheck")){
		var link="dhcmgnurcheck.csp?CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
		//window.showModalDialog(link,'质控检查','dialogHeight:700px;dialogWidth:1200px');
    window.open(link,'质控检查','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
    return;
	}
	if ((CheckTyp=="SafeCheck"))
	{
		var link="dhcmgnurcheck.csp?CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
		//window.showModalDialog(link,"htm","dialogWidth=1200px;dialogHeight=700px");
   //window.location.reload();
    window.open(link,'重点核查','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
    return;
	}
	if ((CheckTyp=="SatisfyNurse")||(CheckTyp=="SatisfyDoctor"))
	{//护士满意度
		 var link="dhcnuremrcomm.csp?CheckRoomId="+CheckRoomId+"&EmrCode=DHCMGNurseDocSatList&CheckTyp="+CheckTyp;
		 //window.showModalDialog(link,'满意度','dialogHeight:700px;dialogWidth:900px');
	   window.open(link,'满意度','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
     return;
	}
	if ((CheckTyp=="SatisfyCurrPat")||(CheckTyp=="SatisfyDischarge"))
	{
	  var link="dhcmgsatisfy.csp?CheckRoomId="+CheckRoomId+"&EmrCode="+eCode+"&CheckTyp="+CheckTyp;
  	window.open (link,'满意度','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
		return;
	}
	if ((CheckTyp=="QualSelfCheck")||(CheckTyp=="SpecSelfCheck")||(CheckTyp=="SafeSelfCheck"))
	{
		var link="dhcmgnurcheck.csp?CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
		//window.showModalDialog(link,'质控检查','dialogHeight:700px;dialogWidth:1200px');
    window.open (link,'质控检查','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') ;
    return;
	}
	else{
		//2013-5-24
		//eCode="DHCMGNurSelfCheckList";
		//var link="dhcmgnurcheck.csp?CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
		//var link="dhcnuremrcomm.csp?CheckRoomId="+CheckRoomId+"&EmrCode="+eCode+"&CheckTyp="+CheckTyp;
		var link="dhcmgnurcomm.csp?CheckRoomId="+CheckRoomId+"&EmrCode="+eCode+"&CheckTyp="+CheckTyp;
		//alert(link)
		//window.showModalDialog(link,'满意度','dialogHeight:700px;dialogWidth:900px');  
		window.open(link,'满意度','height=600,width=1000,top=50,left=50,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no')   
	}
}
function SchQual() {
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}

var cmbitm = new Hashtable();
function comboload2(itm, val) {
  itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if (val != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 10
			},
			callback : function() {
				itm.setValue(session['LOGON.CTLOCID']);
			}
		});
	}
}
function comboload1(itm, val) {
  itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if (val != "") {
		itm.getStore().load({
			params : {
				start : 0,
				limit : 10
			},
			callback : function() {
				itm.setValue(val);
			}
		});
	}
}

function grid1click(){
	var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var sort = rowObj[0].get("SortPos");
  var sortpos=Ext.getCmp("SortPos1");
  sortpos.setValue(sort);
}

function DelItm()
{
  var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	var DelItm = document.getElementById('DelItm');
	var ret=cspRunServerMethod(DelItm.value,p+"||"+rw);
	setgrid();

}
function checkitmgrid()
{
	Ext.getCmp("mygrid1").store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function ModCheck()
{
  if((secGrpFlag=='demo')||(secGrpFlag=='hlb')||(secGrpFlag=='hlbzr')){
	  var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");
	CheckValue = new Hashtable();
  CheckReason = new Hashtable();
  Check(Par);
  }else{
	  alert("您无权编辑任务,请联系护理部!");
	  return;  
  }
}
function NewCheck() 
{
 if((secGrpFlag=='demo')||(secGrpFlag=='hlb')||(secGrpFlag=='hlbzr')){
	  Check("");
  }else{
	  alert("您无权新建任务,请联系护理部!");
	  return;  
  }	
 // Ext.getCmp("CheckScore").setValue(QualScore);
}
//var DHCNurMgChItmMulT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'QualDesc','mapping':'QualDesc'},{'name':'QualWeight','mapping':'QualWeight'},{'name':'rw','mapping':'rw'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'FindQualRel',type:'Query'}});
function multiCheck()
{
	var arr = new Array();
	// 录入界面														
	var a = cspRunServerMethod(pdata1, "", "DHCNurMgChItmMul", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '多选',
		id : "gform3",
		x:200,y:2,
		width : 350,
		height : 560,
		autoScroll : false,
		layout : 'absolute',
		// plain: true,
		// modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : arr
	});
	//检查项目选择窗口显示
  	window.show();
	setsize("mygrid4pl", "gform3", "mygrid4",30);
	var gfrom=Ext.getCmp("gform3");
	var gridpl=Ext.getCmp("mygrid4pl");
  	gridpl.setWidth(gfrom.getWidth()-20)
	var but1=Ext.getCmp("mygrid4but1");
  	but1.hide();
	var but1=Ext.getCmp("mygrid4but2");
	but1.setText("确定");
	but1.setIcon('../images/uiimages/ok.png');
	but1.on('click',function(){Sure();window.close();});
	Ext.getCmp("mygrid4").store.removeAll();
	loadgrid();
	var grid1 = Ext.getCmp('mygrid4');
	grid1.colModel.setHidden(4,true);
	var stdata=Ext.getCmp("mygrid4").store;
	stdata.on("beforeLoad",function(){ 
		stdata.baseParams.sid="WARD";
	})
}
function loadgrid(){
	
//	var mygrid4 = Ext.getCmp('mygrid4');
////	alert(mygrid4)
//	mygrid4.store.on("beforeLoad",function(){
//   	var hsdr=1;
//   	if(CheckTyp=="QualCheck"){
//    	mygrid4.store.baseParams.HsDr=hsdr;
//     	mygrid4.store.baseParams.typ="Ward";
//     	return;
//   	}
//   	if(CheckTyp=="SpecCheck"){
//    	mygrid4.store.baseParams.HsDr=hsdr;
//    	mygrid4.store.baseParams.typ="Pward";
//    	return;
//   	} 
//  });
	Ext.getCmp("mygrid4").store.load({
		params : {
			start : 0,
			limit : 30,
			sid:"WARD"
		}//,
//		callback : function() {
//			var mygrid = Ext.getCmp('mygrid3');
//			var n = mygrid.getStore().getCount();
//			var store = mygrid.store;
//			var arrsel = new Array();
//			for (var j = 0; j < n; j++) {
//				var rwd = store.getAt(j).get("rw");
//				if (rwd != "") {
//					arrsel[j] = rwd-4;
//				}
//			}
//			mygrid4.getSelectionModel().selectRows(arrsel, true);
//		}
	});
}

function Sure()
{
	var grid = Ext.getCmp("mygrid4");
	var store = grid.store;
	var rowCount = store.getCount(); // 记录数
	//alert(rowCount);
	var cm = grid.getColumnModel();
  //alert(cm);
	var colCount = cm.getColumnCount();
	var list = [];
	// for (var i = 0; i < store.getCount(); i++) {
	// list.push(store.getAt(i).data);
	// //debugger;
	// }
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		rw = obj["rw"];
		des=obj["QualDesc"];
		wet=obj["QualWeight"];
		additmItm("mygrid3",des,wet,rw);
	}
}
function Check(Par){
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNurQualCheck", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '查房',
		id : "gform2",
		x:10,y:2,
		width:510,
		height:540,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		resizable:false,
		items:arr
	});
	/*	var but1 = Ext.getCmp("butSave");
	but1.on('click', itmAdd);
	var but = Ext.getCmp("butMod");
	but.on('click', itmMod);
	var but2 = Ext.getCmp("butClear");
	but2.on('click', clearscreen);
*///debugger;
	//新建查房记录窗口显示
	var mygrid2=Ext.getCmp('mygrid2');
	mygrid2.getBottomToolbar().hide();
	mygrid2.colModel.setHidden(1,true);
	var mygrid3=Ext.getCmp('mygrid3');
	mygrid3.getBottomToolbar().hide();
	mygrid3.colModel.setHidden(1,true);
	window.show();
  	Ext.getCmp("mygrid2").store.removeAll();
  	Ext.getCmp("mygrid3").store.removeAll();
  	var but1=Ext.getCmp("mygrid2but1");
  	but1.setText("删除");
  	but1.setIcon('../images/uiimages/edit_remove.png');
  	but1.on('click',function(){delitm(Ext.getCmp("mygrid2"));});//检查人员删除
  	var but=Ext.getCmp("mygrid2but2");
  	but.hide();
  	var but1=Ext.getCmp("mygrid3but1");
  	but1.setText("删除");
  	but1.setIcon('../images/uiimages/edit_remove.png');
  	but1.on('click',function(){delitm(Ext.getCmp("mygrid3"));});//检查项目删除
  	var but=Ext.getCmp("mygrid3but2");
  	but.hide();
  	var CheckDate=Ext.getCmp("CheckStDate");
  	CheckDate.setValue(new Date());
  	var CheckDate=Ext.getCmp("CheckEdDate");
  	CheckDate.setValue(new Date());
  	var btnMulti=Ext.getCmp("btnMulti"); 
  	btnMulti.setIcon('../images/uiimages/booking.png');
  	btnMulti.on("click",function(){multiCheck();});
  	var btnadd1=Ext.getCmp("btnadd1");
  	btnadd1.setText('增加');
  	btnadd1.setIcon('../images/uiimages/edit_add.png');
  	btnadd1.on("click",function(){
  	var Nurse=Ext.getCmp("Nurse");
  	if (Nurse.getValue()=="") return;
  	var des=Nurse.lastSelectionText;
  	var rw=Nurse.getValue();
  	additmNurse("mygrid2",des,rw);});
	/*	var but1 = Ext.getCmp("mygrid1but1");
	but1.hide();
	var but = Ext.getCmp("mygrid1but2");
	but.hide();
     Ext.getCmp("CheckDate").setValue(new Date());
	var grid = Ext.getCmp('mygrid1');
    var stdata=Ext.getCmp("mygrid1").store;
	stdata.on(
	"beforeLoad",function(){ 
	stdata.baseParams.parr=CheckCode+"^"+Par;}
	 )

	 * var cmould=Ext.getCmp("NurProduct"); var
	 * cmparent=Ext.getCmp("ParentMenuNod"); var cmbstore=cmparent.getStore();
	 * cmbstore.on(
	 * "beforeLoad",function(){cmbstore.baseParams.mouldid=cmould.getValue();} );
	 * 
	 * Ext.getCmp('mygrid1').store.load({params:{start:0,
	 * limit:10,Par:curmenuid}});
	 */
    var btnSure=Ext.getCmp("btnSure");
    btnSure.setText('保存');
    btnSure.setIcon('../images/uiimages/filesave.png');
    btnSure.on("click",function(){SureCheck(Par);SchQual();});
    if (Par!=""){
	   	var getVal = document.getElementById('getVal');
	    var ret=cspRunServerMethod(getVal.value,Par);
      var getitms = document.getElementById('getitms1');
	    var ret1=cspRunServerMethod(getitms.value,Par);
      var ha = new Hashtable();
      var tm=ret.split('^')
	    sethashvalue(ha,tm)
   	  //Ext.getCmp("CheckScore").setValue(arr[2]);
  	  Ext.getCmp("CheckMem").setValue(ha.items("CheckMem"));
 	    Ext.getCmp("CheckStDate").setValue(ha.items("CheckStDate"));
  	  Ext.getCmp("CheckEdDate").setValue(ha.items("CheckEdDate"));
 	    Ext.getCmp("CheckTitle").setValue(ha.items("CheckTitle"));
   	  if (ret1!=""){
	        var gr=ret1.split("$");
	        var arr2=gr[0].split("!");
	        var arr1=gr[1].split("!");
	        for (var i=0;i<arr1.length;i++)
	        {
	            if (arr1[i]!=""){
	              var itm=arr1[i].split("^");
	            	// var itm=arr1[i];
	              additmItm("mygrid3",itm[0],itm[1],itm[2]);
	            }
	        }
	        for (var i=0;i<arr2.length;i++){
	            if (arr2[i]!=""){
	            	//alert(arr2[i])
	              var itm=arr2[i].split("^");
	              additmNurse("mygrid2",itm[0],itm[1]);
	            }
	        }
	    }
 		}
 	var pagesize=30;
/*	if (Par=="") setCheckLayout(NurTyp);
	grid.on("afteredit",afterEidt,grid)
	Ext.getCmp('mygrid1').toolbars[1].pageSize=pagesize;
	Ext.getCmp("mygrid1").store.load({
				params : {
					start : 0,
					limit :pagesize
				}
			});
*/
}

function SureCheck(Par)
{
	var CheckStDate=Ext.getCmp("CheckStDate").getValue();
	if(!CheckStDate){
		Ext.Msg.alert('提示','检查日期不能为空！');
		return;
	}else{
		if(CheckStDate instanceof Date){
			CheckStDate = CheckStDate.format('Y-m-d');
		}
	}
  var CheckEdDate=Ext.getCmp("CheckEdDate").getValue();
  if(!CheckEdDate){
  	Ext.Msg.alert('提示','结束日期不能为空！');
  	return;
  }else{
  	if(CheckEdDate instanceof Date){
  		CheckEdDate = CheckEdDate.format('Y-m-d');
  	}
  }
  var users=getgriditm(Ext.getCmp("mygrid2"));
  if(users==""){Ext.Msg.alert('提示','请添加检查人员！');return;}
  var checkItms=getgridwet(Ext.getCmp("mygrid3"));
  var CheckTitle=Ext.getCmp("CheckTitle").getValue();
  if(!CheckTitle){Ext.Msg.alert('提示','检查标题不能为空！');return;}
  var CheckMem=Ext.getCmp("CheckMem").getRawValue();
  // var CheckTyp=Ext.getCmp("CheckTyp").getValue();
  var parr="rw|"+Par+"^CheckTitle|"+CheckTitle+"^CheckMem|"+CheckMem+"^CheckStDate|"+CheckStDate+"^CheckEdDate|"+CheckEdDate+"^CheckTyp|"+CheckTyp+"^NurTyp|"+NurTyp+"^CheckQuals|"+checkItms;
 	var Save = document.getElementById('Save');
  cspRunServerMethod(Save.value,parr,users,checkItms);
  // SchQual();
  Ext.getCmp('gform2').close();
}
function delitm(grid)
{
  grid.store.remove(grid.getSelectionModel().getSelected());
}
function getgriditm(grid)
{
    var n = grid.getStore().getCount();
    var store = grid.store;
    var ret="";
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       ret=ret+"^"+rw; 
    }
   return ret;
}
function getgridwet(grid)
{
    var n = grid.getStore().getCount();
    var store = grid.store;
    var ret="";
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       var wet=store.getAt(j).get("QualWeight");
       ret=ret+"^"+wet+"!"+rw;
    }
   return ret;
}
function additmNurse(griditm,Nurse,idrw)
{
    var grid=Ext.getCmp(griditm);
    var n = grid.getStore().getCount();
    var store = grid.store;
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       if (rw==idrw)return;
    }
    var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"
    ]);
    var count = grid.store.getCount(); 
    var r = new Plant({User:Nurse,rw:idrw}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
    return;
}
function additmItm(griditm,Qual,wet,idrw)
{
    var grid=Ext.getCmp(griditm);
    var n = grid.getStore().getCount();
    var store = grid.store;
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       if (rw==idrw)return;
    }
    var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"
    ]);
    var count = grid.store.getCount(); 
    var r = new Plant({Qual:Qual,QualWeight:wet,rw:idrw}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
    return;
}

function additmItm1(griditm,wet,idrw)
{
    var grid=Ext.getCmp(griditm);
    var n = grid.getStore().getCount();
    var store = grid.store;
    for( var j=0;j<n;j++)
    {
       var rw=store.getAt(j).get("rw");
       if (rw==idrw)return;
    }
    var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"
    ]);
    var count = grid.store.getCount(); 
    var r = new Plant({QualWeight:wet,rw:idrw}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
    return;
}
function iniform(pagesize)
{
	Ext.getCmp("CheckScore").setValue(QualScore);
  Ext.getCmp("mygrid1").store.load({ 	
		params : {
			start : 0,
			limit :pagesize
		}
	});
}
function SetScore()
{ //计算得分
  var Score=QualScore;
 	for (var i=0 ; i<CheckValue.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = CheckValue.keys()[i];
		if (CheckValue.items(key)=="") continue;
		Score=Score-parseFloat(CheckValue.items(key)).toFixed(2);
	}
  Ext.getCmp("CheckScore").setValue(Score);
}
function DelCheck()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");
	var delQual = document.getElementById('delQual');
	var ret=cspRunServerMethod(delQual.value,Par);
	SchQual();
}
/*grid.on("afteredit",afterEidt,grid); //EditorGridPanel的afteredit事件
 
function afterEidt(e){
    e.row;;//修改过的行从0开始
    e.column;//修改列
    e.originalValue;//原始值
    e.value;//修改后的值
    e.grid;//当前修改的grid
    e.field;//正在被编辑的字段名
    e.record;//正在被编辑的行
}
var row = e.record;
var price = row.get("price");
var totalPrice = parseInt(e.value) * price;
totalPrice = parseFloat(totalPrice).toFixed(2);
row.set(e.grid.getColumnModel().getDataIndex(7), totalPrice);
1.var classificationRadioGroup = Ext.getCmp('classifications');   
2.                var classifications = "";   
3.                classificationRadioGroup.eachItem(function(item){   
4.                    if(item.checked == true){   
5.                        classifications += item.inputValue+";";   
6.                    }   
7.                });  

*
*var sex=Ext.getCmp('selectsex');
*2 sex.eachItem(function(item){
*3     if(item.checked===true){
*4         alert(item.inputValue);5     }
*6 });
Ext.override(Ext.form.RadioGroup, {      
 getValue: function(){   
         var v;           
         if (this.rendered) {               
         this.items.each(function(item){                   
         if (!item.getValue())                        
         return true;                   
         v = item.getRawValue();                  
          return false;               });           
          }           
          else {               
          for (var k in this.items) {                   
          if (this.items[k].checked) {                       
          v = this.items[k].inputValue;                       
          break;                   }               }           }           
          return v;       },       
          setValue: function(v){           
          if (this.rendered)                
          this.items.each(function(item){                   
          item.setValue(item.getRawValue() == v);               
          });           
          else {               
          for (var k in this.items) {                   
          this.items[k].checked = this.items[k].inputValue == v; 
          }   
        }  
       } 
    });  
*/
var CheckValue = new Hashtable();
var CheckReason = new Hashtable();
function setqualitmdata(Par)
{
	var getval = document.getElementById('getqualitmdata');
	var ret = cspRunServerMethod(getval.value, Par);
	var tm = ret.split('^')
	for (var i=0;i<tm.length;i++)
	{
	   if (tm[i]=="") continue;
	   var arr=tm[i].split('|');
	   CheckValue.add(arr[0],arr[2]);
	   CheckReason.add(arr[0],arr[1]);
	}
}

function setgrid() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var grid1 = Ext.getCmp("mygrid2");
	grid1.store.load({
		params : {
			start : 0,
			limit : 30
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
	// alert(NurRecId);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// alert(rw);
	// var parr=ret+"&"+checkret+"&"+comboret;
	//alert(ret + "^" + checkret + "^" + comboret);
	var parr = "rw|" + CurrSelItm + "^Par|" + curmenuid + "^" + ret + "^"
			+ checkret + "^" + comboret;
	//alert(parr);
	// return;
	// var
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
	// alert(parr);
	var row = cspRunServerMethod(Save.value, parr);
	//alert(row);
	win.close();
	Ext.getCmp("mygrid2").store.load({
		params : {
			start : 0,
			limit : 30,
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
	//alert(CurrSelItm);
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
	if (flag==0)
	{
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
function setvalue(menid) {
	var ha = new Hashtable();
	var getval = document.getElementById('getVal');
	var ret = cspRunServerMethod(getval.value, menid);
	var tm = ret.split('^')
	sethashvalue(ha, tm);
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
function additm() {
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
			//alert(ee);
			return;
		}
	}
	setgrid();
};

function delQualItem(){
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");
	var jud = document.getElementById('judclear');
	var count=cspRunServerMethod(jud.value,Par);
	if(count==0)
	{
		var a=confirm("确定要删除吗？");
	 	if(a==true)
 		{	
			var delQual = document.getElementById('delQualItem');
		    var ret=cspRunServerMethod(delQual.value,Par);
		    if(ret=="0"){
			  alert("删除成功!");
		    }else{
		      alert("删除失败!");
			  return;
		    }
		    SchQual();
		    return;
		}
 		else
 		{
			return;
 		}
	}
	else{
		alert("此记录已评分不允许删除!");
		return;
     resure(Par);
	}
};
function resure(Par)
{
		var a=confirm("此条记录已经评分，确定要删除吗？");
	 	if(a==true)
 		{	
			var delQual = document.getElementById('delQualItem');
		  var ret=cspRunServerMethod(delQual.value,Par);
		  SchQual();
		}
 		else
 		{
			return;
 		}
}
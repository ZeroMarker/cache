var Width = document.body.clientWidth-2;
var Height = document.body.clientHeight-2;
var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();
var DHCMGNurCheckGradeT101 = new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({
		url:"../csp/dhc.nurse.ext.common.getdata.csp"
	}),
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		fields:[{
			'name':'ItemCode',
			'mapping':'ItemCode'
		},{
			'name':'ItemDesc',
			'mapping':'ItemDesc'
		},{
			'name':'ItemValue',
			'mapping':'ItemValue'
		},{
			'name':'ItemDedStand',
			'mapping':'ItemDedStand'
		},{
			'name':'CheckScore',
			'mapping':'CheckScore'
		},{
			'name':'CheckMem',
			'mapping':'CheckMem'
		},{
			'name':'rw',
			'mapping':'rw'
		},{
			'name':'Par',
			'mapping':'Par'
		},{
			'name':'MinLevel',
			'mapping':'MinLevel'
		}]
	}),
	baseParams:{
		className:'web.DHCMgQualCheck',
		methodName:'GetQualItemGrade',
		type:'RecQuery'
	}
});
var label1=new Ext.Component({
  xtype:'label',
	text:'常用模板名称2',
	x:0,y:10,height:20,width:81,
	id:'label1'
});
var textfield=new Ext.form.TextField({
		id:'textfield'	
});
var DHCMgNurCheckQuickInT103=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'FindWardLoc',type:'Query'}});
var DHCNurCheckRoomItemT106=new Ext.data.JsonStore({data:[],fields:['WardDes','rw']});
var DHCNurCheckRoomItemT109=new Ext.data.JsonStore({data:[],fields:['User','rw']});
var DHCNurCheckRoomQualT102=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'ItemLevel','mapping':'ItemLevel'},{'name':'Par','mapping':'Par'},{'name':'rw','mapping':'rw'},{'name':'MinLevel','mapping':'MinLevel'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'GetQualItemSub',type:'RecQuery'}});
var DHCNurCheckRoomQualNewT103=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'ItemLevel','mapping':'ItemLevel'},{'name':'Par','mapping':'Par'},{'name':'rw','mapping':'rw'},{'name':'MinLevel','mapping':'MinLevel'}]}),baseParams:{className:'web.DHCMgQualCheck',methodName:'GetCheckItemSub',type:'RecQuery'}});

function SizeChange(changewidth) 
{
	var fheight = document.body.offsetHeight;
	var fwidth = document.body.offsetWidth;
	var fm = Ext.getCmp('gform');
	fm.setHeight(fheight);
	fm.setWidth(fwidth+changewidth);
	setsize("mygridpl","gform","mygrid");
}
// var commould=CreateComboBoxQ("commould","MouldName","rw","模块","","150","web.DHCMgNurSysComm","GetMould.RecQuery","sid",0,0);
var stdate=new Ext.form.DateField({
	name:'StDate',
	id:'StDate',
	//format:'Y-m-d',
	tabIndex:'0',
	//height:20,
	//width:119,
	xtype:'datefield',
	value:new Date().add(Date.DAY,-7)
});
var eddate=new Ext.form.DateField({
	name:'EndDate',
	id:'EndDate',
	//format:'Y-m-d',
	tabIndex:'0',
	//height:21,
	//width:116,
	xtype:'datefield',
	value:new Date().add(Date.DAY,14)
});
var WardLoc = new Ext.form.ComboBox({
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
				'name':'LocDes',
				'mapping':'LocDes'
			}, {
				'name':'LocDr',
				'mapping':'LocDr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurSysComm',
			methodName:'FindWardLoc',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:200,
	//height:18,
	width:191,
	xtype:'combo',
	displayField:'LocDes',
	valueField:'LocDr',
	hideTrigger:false,
	queryParam:'HsDr',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var checktyp=new Ext.form.ComboBox({
	name:'CheckTyp1',
	id:'CheckTyp1',
	tabIndex:'0',
	//height:20,
	width:120,
	xtype:'combo',
	store:new Ext.data.JsonStore({
		data:[{
			desc:'夜查房',
			id:'NightChk'
		},{
			desc:'随机督查',
			id:'DayChk'
		}],
		fields:['desc','id']
	}),
	displayField:'desc',
	valueField:'id',
	allowBlank:true,
	mode:'local',
	value:''
});
var QualScore=0;
var CheckFlag=-1;
//判断安全组
	var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler(){
	
	//setsize("mygridpl","gform","mygrid",0);
	var gridPl = Ext.getCmp('mygridpl');
  gridPl.setWidth(Width);
  gridPl.setHeight(Height);
 	var getsschk=document.getElementById('getsschk');
 	var NurTyp=cspRunServerMethod(getsschk.value,session['LOGON.USERID']);
	var grid=Ext.getCmp('mygrid');
	grid.colModel.setHidden(6,true);
	grid.colModel.setHidden(7,true);
	var mydate=new Date();
	var tobar=grid.getTopToolbar();
	var but1=Ext.getCmp("mygridbut1");
	but1.hide();
	var but=Ext.getCmp("mygridbut2");
	but.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
	grid.on("dblclick",checkroom);
   // grid.setTitle(CheckTitle);
	tobar.addItem("-","查房类型",checktyp);
	tobar.addItem("-","检查日期",stdate);
	tobar.addItem("-",eddate);
	tbar2=new Ext.Toolbar({});
	tbar2.addItem("-");
	tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({
		text:"增加",
		handler:function(){NewCheck();},
		id:'btnnew',
		hidden:true,
		icon:'../images/uiimages/edit_add.png'
	});
	//tbar2.addItem(new Ext.form.Label({width:5}));
  tbar2.addItem("-");
  //tbar2.addItem(new Ext.form.Label({width:5}));
  tbar2.addButton({
		text:"编辑",
		handler:function(){ModCheck();},
		id:'btnmod',
		hidden:true,
		icon:'../images/uiimages/pencil.png'
  });
  //tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addItem("-");
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({ 
		text:"删除",
		handler:function(){DelCheck();},
		id:'btndelete',
		hidden:true,
		icon:'../images/uiimages/edit_remove.png'
	});
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addItem("-");
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({
		text:"检查项目",
		handler:function(){CheckItem();},
		id:'btnCheckitm',
		hidden:true,
		icon:'../images/uiimages/dblpaper.png'
	});
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addItem("-");
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({ 
		text: "查询",
		handler:function(){SchQual();},
		id:'SchBtn',
		hidden:true,
		icon:'../images/uiimages/search.png'
	});
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addItem("-");
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({
		text:"导出",
		handler:function(){exportFn();},
		id:'btnExport',
		hidden:true,
		icon:'../images/uiimages/redo.png'
	});
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addItem("-");
	//tbar2.addItem(new Ext.form.Label({width:5}));
	tbar2.addButton({
		text:"短信通知",
		handler:function(){messageFn();},
		icon:'../images/uiimages/unread.png',
		id:'btnNews',
		hidden:true
	});
	var bbar = grid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tbar2.render(grid.tbar);
	tobar.doLayout();
	//****************************************//
	//通过HIS安全组判断显示页面控件元素
	var PageElement=tkMakeServerCall("web.DHCMgNurSecGrpComm","getPageElement",session['LOGON.GROUPID'],menucode)
	//--PageElement="addNewbtn^longTranBtn"
	var ElementArray=PageElement.split('^');
	for(var i=0;i<ElementArray.length;i++){
		if(Ext.getCmp(ElementArray[i])){
			Ext.getCmp(ElementArray[i]).show();
		}
	}
	//****************************************//
	WardLoc.store.on("beforeload",function(){
     WardLoc.store.baseParams.HsDr=1;
     //WardLoc.store.baseParams.typ="";
     WardLoc.store.baseParams.typ="Ward";
  });
  var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeload",function(){
  	var flag=0
    var stdate=Ext.getCmp("StDate").getValue();
    if(!stdate){
    	Ext.Msg.alert('提示','开始日期不能为空！');
    	return;
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
	 	var chktyp=Ext.getCmp("CheckTyp1").getValue();
	 	if((secGrpFlag!="hlb")&&(secGrpFlag!="hlbzr")&&(secGrpFlag!="demo")){
	 		flag=1;
	 	}
		var mygrid = Ext.getCmp("mygrid");
		//flag为1无权限，为0有权限
	  mygrid.store.baseParams.parr=stdate+"^"+eddate+"^"+chktyp+"^"+session['LOGON.USERID']+"^"+flag+"^"+secGrpFlag;
  });
	SchQual();
}
//短信通知
function messageFn()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par=rowObj[0].get("rw");
	//暂时禁用 没有短信平台
	//cspRunServerMethod(SendMsg,Par);
	Ext.Msg.alert('提示',"发送成功");
}
//Excel表格导出
function exportFn() 
{ 
	var xls = new ActiveXObject ("Excel.Application"); 	 
	xls.visible =true;  //设置excel为可见 
	var xlBook = xls.Workbooks.Add; 
	var xlSheet = xlBook.Worksheets(1); 
	//var grid = Ext.getCmp('ApplyRecordGrid');
  var grid = Ext.getCmp("mygrid");
 	var cm = grid.getColumnModel(); 
	var colCount = cm.getColumnCount(); 
	var temp_obj = []; 
	//只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示) 
	//临时数组,存放所有当前显示列的下标 
	 for(i=0;i <colCount;i++){ 
		if(cm.isHidden(i) == true){ 
		}else{ 
			temp_obj.push(i); 
		} 
	} 
	for(i=1;i <=temp_obj.length;i++){ 
		//显示列的列标题 
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i - 1]); 
	} 
	var store = grid.getStore(); 
	var recordCount = store.getCount(); 
	var view = grid.getView(); 
	for(i=1;i <=recordCount;i++){ 
		for(j=1;j <=temp_obj.length;j++){ 
			//EXCEL数据从第二行开始,故row = i + 1; 
			xlSheet.Cells(i + 1,j).Value = " "+view.getCell(i - 1,temp_obj[j - 1]).innerText; 
		} 
	} 
	xlSheet.Columns.AutoFit; 
	xls.ActiveWindow.Zoom = 75 
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
    xls=null; 
    xlBook=null; 
    xlSheet=null; 
}
function checkroom()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		return;
	}
	var CheckRoomId = rowObj[0].get("rw");
	var CheckTyp = rowObj[0].get("CheckTyp");
	//var link="dhcnuremrcomm.csp?CheckRoomId="+CheckRoomId+"&EmrCode=DHCMGNurStChkList&CheckTyp="+CheckTyp;
  var link="dhcmgnurcomm.csp?CheckRoomId="+CheckRoomId+"&EmrCode=DHCMGNurStChkList&CheckTyp="+CheckTyp;
  window.open (link,'查房','height=600,width=1000,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
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
	if (val!="") {
		itm.getStore().load({
			params:{
				start:0,
				limit:10
			},
			callback : function() {
				itm.setValue(session['LOGON.CTLOCID']);
			}
		});
	}
}
function comboload1(itm, val) {
  itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if(val!=""){
		itm.getStore().load({
			params:{
				start:0,
				limit:100
			},
			callback:function() {
				itm.setValue(val);
			}
		});
	}
}
function grid1click() {
	var grid=Ext.getCmp("mygrid1");
	var rowObj=grid.getSelectionModel().getSelections();
	if (rowObj.length==0) {
		return;
	}
	var sort=rowObj[0].get("SortPos");
	//alert(sort)
  var sortpos=Ext.getCmp("SortPos1");
  sortpos.setValue(sort);
}
//保存时弹出检查框用
function CheckItem1(typ)
{
  var Par=returnid;
	var a=cspRunServerMethod(pdata1,"","DHCNurCheckRoomQualNew","","");
	arr=eval(a);
	var window=new Ext.Window({
		title:'检查项目',
		id:"gform2",
		x:10,y:2,width:810,height:630,
	//	autoScroll:true,
		layout:'absolute',
		items:arr
	});
	window.on("close",function(){CheckFlag=-1;});
  window.show();
  Ext.getCmp('B122').hide();
  Ext.getCmp('Level').hide();
  Ext.getCmp('B123').hide();
  Ext.getCmp('ItemCode').hide();
  Ext.getCmp('btnSave1').hide();
  setsize("mygrid2pl","gform","mygrid2");
  var gfrom=Ext.getCmp("gform");
	var gridpl=Ext.getCmp("mygrid2pl");
	gridpl.setHeight(gfrom.getHeight()-110)
 	Ext.getCmp("mygrid2").store.removeAll();
 	var grid = Ext.getCmp('mygrid2');
 	
 	grid.getBottomToolbar().hide();
 	var bbar2 = new Ext.PagingToolbar({
		pageSize:1000,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	grid.on('rowclick', gridclick);
  var grid = Ext.getCmp('mygrid1');
  var but1=Ext.getCmp("mygrid2but1");
  but1.setText("删除");
  but1.hide();
  but1.on('click',function(){DelItm();});
  var but=Ext.getCmp("mygrid2but2");
  but.hide();
  var btnsure=Ext.getCmp("btnSure1");
  btnsure.setIcon('../images/uiimages/ok.png');
  Ext.getCmp('DeleteBtn').setIcon('../images/uiimages/edit_remove.png');
  btnsure.on("click",function(){
  	addcheckitmMoud(Par);
    //window.close();
    CheckFlag=-1;
  }); 
  var CheckItem=Ext.getCmp("CheckItm");
  //CheckItem.on("select",setgridNow);
  CheckItem.on('select',function(){
  	CheckFlag=0;
  	var grid = Ext.getCmp('mygrid2');
		grid.store.load({
			params:{
				start:0,
				limit:1000
			}
		});
  })
  var CheckItemSelf=Ext.getCmp("CheckItmMoud");
  CheckItemSelf.on("select",setgridU);
	var stdata2=Ext.getCmp("mygrid2").store; 
	stdata2.on("beforeload",function(){
		if(CheckFlag==-1){
		 stdata2.baseParams.className="web.DHCMgQualCheck";
	 	 stdata2.baseParams.methodName="GetCheckItemSub";
		 stdata2.baseParams.Par=Par;
		}
		if(CheckFlag==0){
		 var CheckItem=Ext.getCmp("CheckItm");
		 var qupar=CheckItem.getValue();
		 stdata2.baseParams.className="web.DHCMgNurSysComm";
	 	 stdata2.baseParams.methodName="GetQualItemSub";		
		 stdata2.baseParams.Par=qupar;
	  }
	  if(CheckFlag==1){
	   var CheckItem=Ext.getCmp("CheckItmMoud");
		 var qupar=CheckItem.getValue();
		 stdata2.baseParams.className="web.DHCMgNurSysComm";
	 	 stdata2.baseParams.methodName="GetQualItemUsual";		
		 stdata2.baseParams.Par=qupar;
	  }
	})
  setgrid();
  var grid = Ext.getCmp('mygrid2');
  var len = grid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(grid.getColumnModel().getDataIndex(i) == 'MinLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'Par'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'ItemLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
  }

}
function CheckItem()
{   
	 var grid=Ext.getCmp("mygrid");
	var rowObj=grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par=rowObj[0].get("rw");		
	var a=cspRunServerMethod(pdata1,"","DHCNurCheckRoomQualNew","","");
	arr=eval(a);
	var window=new Ext.Window({
		title:'检查项目',
		id:"gform2",
		x:10,y:2,
		width:810,
		height:630,
		autoScroll:false,
		layout:'absolute',
		items:arr,
		modal:true,
		resizable:false
	});
	window.on("close",function(){CheckFlag=-1;});
  window.show();
  setsize("mygrid2pl","gform","mygrid2");
  var gfrom=Ext.getCmp("gform");
	var gridpl=Ext.getCmp("mygrid2pl");
	gridpl.setHeight(gfrom.getHeight()-110)
  Ext.getCmp("mygrid2").store.removeAll();
  var grid=Ext.getCmp('mygrid2');
  	// grid.colModel.setHidden(4,true);
  	// grid.colModel.setHidden(5,true);
  	// grid.colModel.setHidden(6,true);
  	// grid.colModel.setHidden(7,true);
	grid.on('rowclick',gridclick);
	grid.getTopToolbar().hide();
	grid.getBottomToolbar().hide();
	var bbar3 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar3.render(grid.bbar);
  var but1=Ext.getCmp("mygrid2but1");
  but1.setText("删除");
  but1.setIcon('../images/uiimages/edit_remove.png');
  but1.hide();
  but1.on('click',function(){DelItm();});
  var but=Ext.getCmp("mygrid2but2");
  but.hide();
  var btnsave=Ext.getCmp("btnSave1");
  btnsave.setIcon('../images/uiimages/pencil.png');
  btnsave.on("click",SaveCheckItm);
  var btnsure=Ext.getCmp("btnSure1");
  btnsure.setText('保存');
  btnsure.setIcon('../images/uiimages/filesave.png');
  btnsure.on("click",function(){
    addcheckitmMoud(Par);
    //window.close();
    CheckFlag=-1;
  }); 
  var  checkname=tkMakeServerCall("DHCMGNUR.QuCheckWard","getcheckname",Par);
  //alert(checkname)
  var btnDel=Ext.getCmp("DeleteBtn");
  btnDel.on("click",function(){DelcheckitmMoud(Par);})
  btnDel.setIcon('../images/uiimages/edit_remove.png');
  if((secGrpFlag=='demo')||(secGrpFlag=='hlb')||(secGrpFlag=='hlbzr')){
	  
  }else{
	   Ext.getCmp("mygrid2but1").hide();
	   Ext.getCmp("btnSave1").hide();
	   Ext.getCmp("btnSure1").hide();
	   Ext.getCmp("DeleteBtn").hide();
  }	
  var CheckItem=Ext.getCmp("CheckItm");
  CheckItem.setValue(checkname)
  CheckItem.on("select",setgridNow);
  var CheckItemSelf=Ext.getCmp("CheckItmMoud");
  CheckItemSelf.on("select",setgridU);
	var stdata2=Ext.getCmp("mygrid2").store; 
	stdata2.on("beforeload",function(){
		if(CheckFlag==-1){
		 stdata2.baseParams.className="web.DHCMgQualCheck";
	 	 stdata2.baseParams.methodName="GetCheckItemSub";
		 stdata2.baseParams.Par=Par;
		}
		if(CheckFlag==0){
		 var CheckItem=Ext.getCmp("CheckItm");
		 var qupar=CheckItem.getValue();
		 stdata2.baseParams.className="web.DHCMgNurSysComm";
	 	 stdata2.baseParams.methodName="GetQualItemSub";		
		 stdata2.baseParams.Par=qupar;
	  }
	  if(CheckFlag==1){
	   var CheckItem=Ext.getCmp("CheckItmMoud");
		 var qupar=CheckItem.getValue();
		 stdata2.baseParams.className="web.DHCMgNurSysComm";
	 	 stdata2.baseParams.methodName="GetQualItemUsual";		
		 stdata2.baseParams.Par=qupar;
	  }
	});
  setgrid();
  //grid
  var len = grid.getColumnModel().getColumnCount()
  for(var i = 0 ;i < len;i++){
  	if(grid.getColumnModel().getDataIndex(i) == 'ItemLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
  	if(grid.getColumnModel().getDataIndex(i) == 'Par'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'MinLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
//固定模板加载
function setgridNow(){
	CheckFlag=0;
	var grid1 = Ext.getCmp("mygrid2");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}
//常用模板加载
function setgridU() {
	CheckFlag=1;
	var grid1 = Ext.getCmp("mygrid2");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}
function DelcheckitmMoud(Par)
{
	Ext.Msg.confirm('删除', '是否确认删除:', function(btn, text){
	   if (btn == 'yes'){
		 	 var IsDelete = document.getElementById('IsDelete');
		 	 var ret=cspRunServerMethod(IsDelete.value,Par);
		 	 if(ret!=0)
		 	 {
		 	 		alert(ret)
		 	 }
		 	 setgrid();
		 }
	});
}
function addcheckitmMoud(Par)
{
  var grid = Ext.getCmp("mygrid2");
  var rowObj = grid.getSelectionModel().selectAll();
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var level=Ext.getCmp("Level").getValue();
	var code=Ext.getCmp("ItemCode").getValue();
	level=""
	code=""
 	var IsSave = document.getElementById('IsSave');
 	var ret=cspRunServerMethod(IsSave.value,Par);
 	if(ret!=""){
 		alert("已使用，请先删除后再保存!")
 		return;
 	}
  for(var i=0;i<rowObj.length;i++){
		var p = rowObj[i].get("Par");
		var rw=rowObj[i].get("rw");
		var MinLevel=rowObj[i].get("MinLevel");
		if(MinLevel=="N") {continue;}
		var save = document.getElementById('SaveCheck');
		//alert(Par);
	  var ret=cspRunServerMethod(save.value,p+"||"+rw,Par,level,code,CheckFlag);
	}
	Ext.getCmp("gform2").close();
  setgrid();
}
//常用模板维护  暂不用
function usualMoudFn()
{	
	var a=cspRunServerMethod(pdata1, "", "DHCNurCheckRoomQual", "", "");
	arr=eval(a);
	var window=new Ext.Window({
		title:'常用检查项目维护',
		id:"gform3",
		x:10,y:2,
		width:810,
		height:760,
		autoScroll:true,
		layout:'absolute',
		items:[arr]
	});
	Ext.getCmp('B123').hidden=true;
	Ext.getCmp('btnSave1').hidden=true;
	Ext.getCmp('B122').hidden=true;
	Ext.getCmp('Level').hidden=true;
	Ext.getCmp('ItemCode').hidden=true;	
  // Ext.getCmp('gform').addItem('-','常用模板',label1);
  Ext.getCmp('gform').doLayout();
   window.show();
   var but1=Ext.getCmp("mygrid1but1");
   but1.setText("添加至常用模板");
   but1.on('click',function(){addcheckMoud();});		
   var but2=Ext.getCmp("mygrid1but2");
   but2.hide();
   Ext.getCmp('B125').hidden=true;
   Ext.getCmp('gform').add(label1);
   Ext.getCmp('gform').doLayout();
   Ext.getCmp("mygrid2").store.removeAll();
   Ext.getCmp("mygrid1").store.removeAll();
	//大标题选择后小标题自动选择
	sm1.on('rowselect',function(sm1,rowIndex){
		var store = Ext.getCmp("mygrid1").store;
		var rowObj =sm1.getSelections();
		var MinLevel=rowObj[rowObj.length-1].get("MinLevel");
		if(MinLevel=="N"){
			var rows=store.getCount()
			var Level=rowObj[rowObj.length-1].get("ItemLevel");
			var code=rowObj[rowObj.length-1].get("ItemCode");
			if(code.indexOf(".")!=-1){Level=code}
			for(var i=0;i<rows;i++){
				var MLevel=store.getAt(i).get("MinLevel");
				var MILevel=store.getAt(i).get("ItemLevel");
				if((MLevel!="N")&&(MILevel==Level)){
					sm1.selectRow(i,true);
				}
			}
		}
	})
	//取消选择
	sm1.on('rowdeselect',function(sm1,rowIndex){
		var store = Ext.getCmp("mygrid1").store;
		var rowObj =sm1.getSelections();
		var MinLevel=store.getAt(rowIndex).get("MinLevel");
		if(MinLevel=="N"){
			var rows=store.getCount()
			var Level=store.getAt(rowIndex).get("ItemLevel");
			var code=store.getAt(rowIndex).get("ItemCode");
			if(code.indexOf(".")!=-1){Level=code}
			for(var i=0;i<rows;i++){
				var MLevel=store.getAt(i).get("MinLevel");
				var MILevel=store.getAt(i).get("ItemLevel");
				if((MLevel=="Y")&&(MILevel==Level)){
					sm1.deselectRow(i);
				}
			}
		}
	})
  var grid = Ext.getCmp('mygrid2');
	grid.on('click', gridclick);
  var but1=Ext.getCmp("mygrid2but1");
  but1.setText("删除");
  but1.on('click',function(){DelItmMoud();});
  var but=Ext.getCmp("mygrid2but2");
  but.hide();
  var btnsure=Ext.getCmp("btnSure1");
  btnsure.on("click",function(){window.close();}); 
  var CheckItem=Ext.getCmp("CheckItm");
  CheckItem.on("select",checkitmgrid);
  CheckItem.on("select",function(){
	  var grid1=Ext.getCmp("mygrid2");
		grid1.store.load({
			params : {
				start : 0,
				limit : 30
			}
		});
	})
   //常用模板选择事件
  var CheckItem=Ext.getCmp("CheckItmMoud");
  CheckItem.on("select",setgridU);  
  var stdata=Ext.getCmp("mygrid1").store;  
	stdata.on("beforeLoad",function(){
		var CheckItem=Ext.getCmp("CheckItm");
		var qupar=CheckItem.getValue();
		//MoudType 为1 自定义， 为0 通用
		stdata.baseParams.Moudtype="0";
		stdata.baseParams.Par=qupar;
	});
	var stdata2=Ext.getCmp("mygrid2").store; 
	stdata2.on("beforeLoad",function(){
		var CheckItem=Ext.getCmp("CheckItmMoud");
		var qupar=CheckItem.getValue();
		stdata2.baseParams.className="web.DHCMgNurSysComm";
	 	stdata2.baseParams.methodName="GetQualItemSub";		
		stdata2.baseParams.Moudtype="1";
		stdata2.baseParams.Par=qupar;
	})
}

//不用
function setgridU1() 
{
	DHCNurCheckRoomQualT104.load({
		params:{
			start:0,
			limit:30
		}
	});
}
function addcheckMoud()
{
  var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var level=Ext.getCmp("Level").getValue();
	var code=Ext.getCmp("ItemCode").getValue();
	level=""
	code=""
	var Name = Ext.getCmp("CheckName").getValue();
	if(Name=="")
	{
		alert("请先录入:常用模板名称,然后再进行添加。")
		return
	}
	var save = document.getElementById('SaveMoud');
	var Moudid=cspRunServerMethod(save.value,"",Name,session['LOGON.CTLOCID']);
  if(Moudid!=""){
    for(var i=0;i<rowObj.length;i++){
		var p = rowObj[i].get("Par");
		var rw=rowObj[i].get("rw");
		var MinLevel=rowObj[i].get("MinLevel");
		if(MinLevel=="N") {continue;}
		var save = document.getElementById('SaveCheckMoud');
		//alert(Par);
	    var ret=cspRunServerMethod(save.value,p+"||"+rw,Moudid,level,code);
    }
  }
  setgrid();
  checkitmgrid();
}
function DelItmMoud()
{
  var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	var DelItm = document.getElementById('DelItmMoud');
	var ret=cspRunServerMethod(DelItm.value,p+"||"+rw);
	setgrid();
}

function gridclick()
{
  var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	Ext.getCmp("Level").setValue(rowObj[0].get("ItemLevel"));
	Ext.getCmp("ItemCode").setValue(rowObj[0].get("ItemCode"));
}
function gridclick11()
{
  var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
}
function addcheckitm(Par)
{
  var grid = Ext.getCmp("mygrid1");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var level=Ext.getCmp("Level").getValue();
	var code=Ext.getCmp("ItemCode").getValue();
	level=""
	code=""
  for(var i=0;i<rowObj.length;i++){
		var p = rowObj[i].get("Par");
		var rw=rowObj[i].get("rw");
		var MinLevel=rowObj[i].get("MinLevel");
		if(MinLevel=="N") {continue;}
		var save = document.getElementById('SaveCheck');
	  var ret=cspRunServerMethod(save.value,p+"||"+rw,Par,level,code);
  }
  setgrid();
  checkitmgrid();
}
function SaveCheckItm()
{
  var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var level=Ext.getCmp("Level").getValue();
	var code=Ext.getCmp("ItemCode").getValue();
	if ((level=="")||(code=="")) return;
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	var save = document.getElementById('SaveItm');
	var ret=cspRunServerMethod(save.value,p+"||"+rw,level,code);
	//alert(ret)
	if(ret==1){Ext.Msg.alert('提示','此记录不存在，请先保存后再修改序号！');}
	Ext.getCmp("Level").setValue("");
	Ext.getCmp("ItemCode").setValue("");
	setgrid();
}
function DelItm()
{
	var grid = Ext.getCmp("mygrid2");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}
	var p = rowObj[0].get("Par");
	var rw=rowObj[0].get("rw");
	var DelItm = document.getElementById('DelItm');
	var ret=cspRunServerMethod(DelItm.value,p+"||"+rw);
	//alert(ret)
	setgrid();
}
function checkitmgrid()
{

	Ext.getCmp("mygrid2").store.load({
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
  
}
var DHCNurMgWardMulT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'FindWardLoc',type:'Query'}});
var DHCNurMgFloorAndWardT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'DHCMGNUR.MGNurFloor',methodName:'FindWardLoc',type:'Query'}});

function floorAndWard()
{
	var loctyp1=new Ext.form.ComboBox({
		name:'LocTyp',
		id:'loctyp1',
		tabIndex:'0',
//		x:100,
//		y:27,
		//height:20,
		width:134,
		xtype:'combo',
		store:new Ext.data.JsonStore({
			data:[{
				desc:'外科楼',
				id:'WK'
			},{
				desc:'内科楼',
				id:'NK'
			},{
				desc:'保健楼',
				id:'BJL'
			},{
				desc:'急救楼',
				id:'JJL'
			},{
				desc:'综合楼',
				id:'ZHL'
			}],
			fields:['desc','id']
		}),
		displayField : 'desc',
		valueField : 'id',
		allowBlank : true,
		mode : 'local',
		value : ''
	});
	var arr=new Array();
	var a=cspRunServerMethod(pdata1,"","DHCNurMgFloorAndWard","","");
	arr=eval(a);
	var window=new Ext.Window({
		title:'多选',
		id:'gform03',
		x:265,y:2,width:350,height:400,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		items:[arr]
	});
	window.show();	
	var mygrid14pl=Ext.getCmp('mygrid14pl');
	mygrid14pl.setWidth(Ext.getCmp('gform03').width);
	mygrid14pl.setHeight(Ext.getCmp('gform03').height);
  	var grid = Ext.getCmp('mygrid14');
  	grid.colModel.setHidden(3,true);
	var tobar = grid.getTopToolbar();
	var but1=Ext.getCmp("mygrid14but1");
	but1.hide();
	var but2=Ext.getCmp("mygrid14but2");
	but2.setText("确定");
	but2.setIcon('../images/uiimages/ok.png');
	but2.on('click',function(){Sure1();window.close();});
	tobar.addItem("-","楼层选择",loctyp1);
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tobar.render(grid.tbar);
	tobar.doLayout();
	var cmb=Ext.getCmp("loctyp1");
  	cmb.on("select",setgrid14);
	Ext.getCmp("mygrid14").store.removeAll();
	Ext.getCmp("mygrid14").store.on("beforeload",function(){
    var hsdr=1;
    var loctyp=Ext.getCmp("loctyp1").getValue();
    if (loctyp=="") return;
    var mygrid = Ext.getCmp("mygrid14");
    mygrid.store.baseParams.HsDr=hsdr;
    mygrid.store.baseParams.typ=loctyp;        
  });
}
function Sure1()
{
	var grid = Ext.getCmp("mygrid14");
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
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		rw = obj["LocDr"];
		des=obj["LocDes"];
    additmWard("mygrid3",des,rw);
	}
}
function setgrid14()
{
	var grid1 = Ext.getCmp("mygrid14");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}
function multiward()
{
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCNurMgWardMul", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '多选',
		id : "gform3",
		x:265,
		y:2,
		width : 350,
		height : 440,
		modal:true,
		autoScroll : true,
		layout : 'absolute',
		// plain: true,
		// modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : arr
	});
	window.show();
	var but1=Ext.getCmp("mygrid4but1");
	but1.hide();
	var but1=Ext.getCmp("mygrid4but2");
  	but1.setText("确定");
  	but1.setIcon('../images/uiimages/ok.png');
  	var mygrid4=Ext.getCmp('mygrid4');
  	mygrid4.colModel.setHidden(3,true);
  	mygrid4.getBottomToolbar().hide();
  	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:mygrid4.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(mygrid4.bbar);
  but1.on('click',function(){Sure();window.close();});
  Ext.getCmp("mygrid4").store.removeAll();
  Ext.getCmp("mygrid4").store.on("beforeLoad",function(){
    var hsdr=1;
    var mygrid = Ext.getCmp("mygrid4");
    mygrid.store.baseParams.HsDr=hsdr;
    //WardLoc.store.baseParams.typ="";
    mygrid.store.baseParams.typ="Ward";
  });
  setgrid3();
}
function setgrid3() {
	var grid1 = Ext.getCmp("mygrid4");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}
function Sure()
{
	var grid = Ext.getCmp("mygrid4");
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
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		rw = obj["LocDr"];
		des=obj["LocDes"];
    additmWard("mygrid3",des,rw);
	}
}
function Check(Par)
{
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1,"","DHCNurCheckRoomItem","","");
	arr = eval(a);
	var window = new Ext.Window({
		title:'查房内容',
		id:"gform2",
		x:10,y:2,
		width:600,
		height:500,
		autoScroll:true,
		layout:'absolute',
		items:arr
	});
	var mygrid2=Ext.getCmp('mygrid2');
	mygrid2.colModel.setHidden(1,true);
	var grid2Bttar=mygrid2.getBottomToolbar();
	grid2Bttar.hide();
	var mygrid3=Ext.getCmp('mygrid3');
	mygrid3.colModel.setHidden(1,true);
	var grid3Bttar=mygrid3.getBottomToolbar();
	grid3Bttar.hide();
	window.show();
  Ext.getCmp("mygrid2").store.removeAll();
  Ext.getCmp("mygrid3").store.removeAll();
  var but1=Ext.getCmp("mygrid2but1");
  but1.setText("删除");
  but1.setIcon('../images/uiimages/edit_remove.png');
	but1.on('click',function(){delitm(Ext.getCmp("mygrid2"));});
	var but=Ext.getCmp("mygrid2but2");
	but.hide();
	var but1=Ext.getCmp("mygrid3but1");
	but1.setText("删除");
	but1.setIcon('../images/uiimages/edit_remove.png');
	but1.on('click',function(){delitm(Ext.getCmp("mygrid3"));});
	var but=Ext.getCmp("mygrid3but2");
	but.hide();
	var CheckDate=Ext.getCmp("CheckDate");
	CheckDate.setValue(new Date());
 	var CheckSTime=Ext.getCmp("CheckSTime");
  CheckSTime.setValue(new Date());
 	var CheckEndTime=Ext.getCmp("CheckEndTime");
  CheckEndTime.setValue(new Date());
  var btnFloor=Ext.getCmp("btnFloor");//楼层关联病区
  btnFloor.setIcon('../images/uiimages/app.png');
  btnFloor.on("click",function(){floorAndWard();});
  var btnMulti=Ext.getCmp("btnMulti"); ///butClear
  btnMulti.setIcon('../images/uiimages/AppDep.png');
  btnMulti.on("click",function(){multiward();});
 	var btnadd1=Ext.getCmp("btnadd1"); ///butClear
 	btnadd1.setIcon('../images/uiimages/edit_add.png');
 	btnadd1.on("click",function(){
  var Nurse=Ext.getCmp("Nurse");
 	if (Nurse.getValue()=="") return;
 	var des=Nurse.lastSelectionText;
 	var rw=Nurse.getValue();
 	additmNurse("mygrid2",des,rw);});
  var btnadd2=Ext.getCmp("btnadd2"); ///butClear
  btnadd2.setIcon('../images/uiimages/edit_add.png');
  btnadd2.on("click",function(){  
   	var PatWard=Ext.getCmp("PatWard");
   	if (PatWard.getValue()=="") return;
   	var des=PatWard.lastSelectionText;
   	var rw=PatWard.getValue();
  	additmWard("mygrid3",des,rw);
  });
  Ext.getCmp('PatWard').store.on("beforeload",function(){
    var wardstore=Ext.getCmp('PatWard').store;
    wardstore.baseParams.HsDr=1;
    WardLoc.store.baseParams.typ="";
    var laststr2=Ext.getCmp('PatWard').lastQuery
    if (laststr2!=undefined){wardstore.baseParams.ward=laststr2;}
  });
  var laststr1
  Ext.getCmp('Nurse').store.on("beforeload",function(){
  	var wardstore=Ext.getCmp('Nurse').store;
    laststr1=Ext.getCmp('Nurse').lastQuery
		wardstore.baseParams.typ=""
    wardstore.baseParams.Name=laststr1;
  });
	var checkt=Ext.getCmp("CheckTyp").getValue()
  var btnSure=Ext.getCmp("btnSure");
  btnSure.setIcon('../images/uiimages/filesave.png');
  btnSure.setText('保存');
  btnSure.on("click",function(){
    SureCheck(Par);window.close();
    var mygrid=Ext.getCmp("mygrid");
   	mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);
    CheckItem1(checkt)
  });
  if(Par!=""){
	  var getVal = document.getElementById('getVal');
	  var ret=cspRunServerMethod(getVal.value,Par);
    var getitms = document.getElementById('getitms1');
	  var ret1=cspRunServerMethod(getitms.value,Par);
    var ha = new Hashtable();
    var tm=ret.split('^')
	  sethashvalue(ha,tm)
   	//Ext.getCmp("CheckScore").setValue(arr[2]);
  	Ext.getCmp("CheckTyp").setValue(ha.items("CheckTyp"));
 	  Ext.getCmp("CheckDate").setValue(ha.items("CheckDate"));
  	Ext.getCmp("CheckSTime").setValue(ha.items("CheckSTime"));
 	  Ext.getCmp("CheckEndTime").setValue(ha.items("CheckEndTime"));
   	if(ret1!=""){
	    var gr=ret1.split("$");
	    var arr2=gr[0].split("!");
	    var arr1=gr[1].split("!");
	    for (var i=0;i<arr1.length;i++){
	     if (arr1[i]!=""){
	     	var itm=arr1[i].split("^");
	      additmWard("mygrid3",itm[0],itm[1]);
	     }
	    }
	    for (var i=0;i<arr2.length;i++){
	     if (arr2[i]!=""){
        var itm=arr2[i].split("^");
	      additmNurse("mygrid2",itm[0],itm[1]);
	     }
	    }
	  }
 	}
 	var pagesize=30;
}
var returnid=""
function SureCheck(Par)
{
  var CheckDate=Ext.getCmp("CheckDate").getValue();
  if(!CheckDate){
  	Ext.Msg.alert('提示','检查日期不能为空！');
  	return;
  }else{
  	if(CheckDate instanceof Date){
  		CheckDate = CheckDate.format('Y-m-d');
  	}
  }
  var users=getgriditm(Ext.getCmp("mygrid2"));;
  var cwards=getgriditm(Ext.getCmp("mygrid3"));
  var CheckSTime=Ext.getCmp("CheckSTime").value;
  var CheckEndTime=Ext.getCmp("CheckEndTime").value;
  var CheckTyp=Ext.getCmp("CheckTyp").getValue();
  var parr="rw|"+Par+"^CheckSTime|"+CheckSTime+"^CheckEndTime|"+CheckEndTime+"^CheckDate|"+CheckDate+"^CheckTyp|"+CheckTyp;
 	var Save = document.getElementById('Save');
  var a=cspRunServerMethod(Save.value,parr,users,cwards);
  //returnid保存后记录id值
  returnid=a
  SchQual();
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
  for( var j=0;j<n;j++){
  	var rw=store.getAt(j).get("rw");
   	ret=ret+"^"+rw;
  }
 return ret;
}
function additmNurse(griditm,Nurse,idrw)
{
	var grid=Ext.getCmp(griditm);
 	var n = grid.getStore().getCount();
 	var store = grid.store;
  for( var j=0;j<n;j++){
    var rw=store.getAt(j).get("rw");
    if (rw==idrw)return;
  }  
  var Plant = Ext.data.Record.create([]);
	// the "name" below matches the tag name to read, except "availDate"
	// which is mapped to the tag "availability"
  var count = grid.store.getCount(); 
  var r = new Plant({User:Nurse,rw:idrw}); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}
function additmWard(griditm,ward,idrw)
{
  var grid=Ext.getCmp(griditm);
  var n = grid.getStore().getCount();
  var store = grid.store;
  for( var j=0;j<n;j++){
	  var rw=store.getAt(j).get("rw");
    if (rw==idrw)return;
  }  
  var Plant = Ext.data.Record.create([]);
  var count = grid.store.getCount(); 
  var r = new Plant({WardDes:ward,rw:idrw}); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}
function iniform(pagesize)
{
   Ext.getCmp("CheckScore").setValue(QualScore);
   Ext.getCmp("mygrid1").store.load({
		params:{
			start:0,
			limit:pagesize
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
	var rowObj=grid.getSelectionModel().getSelections();
	if (rowObj.length==0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");
	var rowid=tkMakeServerCall('Nur.CheckRoom','checkRecords',Par)
	if(rowid!=""){
		Ext.Msg.alert('提示','此记录已经存在打分记录，不允许删除！');
		return
	}
	var delQual = document.getElementById('delQual');
	if (confirm('确定删除选中的项？')) {
		var ret=cspRunServerMethod(delQual.value,Par);
		SchQual();
	}
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
function setgrid() 
{
	var grid1 = Ext.getCmp("mygrid2");
	grid1.store.load({
		params:{
			start:0,
			limit:30
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
		params:{
			start:0,
			limit:30,
			Par:curmenuid
		}
	});
	return;
}
function itmAdd()
{
   CurrSelItm=""
   SaveItm();
}
function itmMod() 
{
	if (CurrSelItm=="") return;
	SaveItm();
}
function clearscreen() 
{
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
	for (var i = 0; i < ht.keys().length; i++){
		var key = ht.keys()[i];
		if (key.indexOf("_") == -1){
			var itm = Ext.getCmp(key);
			if (ha.contains(key))
				if (itm.xtype == "combo"){
					comboload(itm, ha.items(key));
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
	var mygrid = Ext.getCmp("mygrid1");
	mygrid.store.load({
		params:{
			start:0,
			limit:30
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
function typdelete()
{
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
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
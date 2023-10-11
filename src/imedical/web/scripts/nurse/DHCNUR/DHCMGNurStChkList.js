/**
 * @author Administrator
 */
 var Width = document.body.clientWidth-2;
var Height = document.body.clientHeight-2;
var ret = "";
var checkret = "";
var comboret = "";
var arrgrid = new Array();
var DHCMGNurStChkGradeT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'ItemCode','mapping':'ItemCode'},{'name':'ItemDesc','mapping':'ItemDesc'},{'name':'ItemValue','mapping':'ItemValue'},{'name':'ItemDedStand','mapping':'ItemDedStand'},{'name':'CheckScore','mapping':'CheckScore'},{'name':'CheckMem','mapping':'CheckMem'},{'name':'CheckPeople','mapping':'CheckPeople'},{'name':'rw','mapping':'rw'},{'name':'Par','mapping':'Par'},{'name':'MinLevel','mapping':'MinLevel'}]}),baseParams:{className:'web.DHCNurCheckRoom',methodName:'GetCheckItemSub',type:'RecQuery'}});
var DHCMgNurCheckQuickInT103=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'FindWardLoc',type:'Query'}});
function SizeChange(changewidth) 
{
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
	//height:20,
	width:119,
	xtype:'datefield',
	value:new Date()
});
var eddate=new Ext.form.DateField({
	name:'EndDate',
	id:'EndDate',
	//format:'Y-m-d',
	tabIndex:'0',
	//height:21,
	width:116,
	xtype:'datefield',
	value:new Date()
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
			},{
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
	pageSize:20,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var checktyp=new Ext.form.ComboBox({
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
			desc:'科护士长',
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
	mode:'local',
	value:''
});
var QualScore=0;
var NurTyp=cspRunServerMethod(getsschk.value,session['LOGON.USERID']);
var CheckTyp
var CheckDate=""
function BodyLoadHandler() {
	//setsize("mygridpl", "gform", "mygrid",0);
	var gridPl = Ext.getCmp('mygridpl');
  gridPl.setWidth(Width);
  gridPl.setHeight(Height);
	//var getItmValue=document.getElementById('getItmValue');
	var getsschk=document.getElementById('getsschk');
  //QualScore=cspRunServerMethod(getItmValue.value,CheckCode);
  if ((CheckRoomId!="")&&(CheckTyp=="QualSelfCheck")){
    var getVal = document.getElementById('getVal2');
    var ret=cspRunServerMethod(getVal.value,CheckRoomId);
    var ha = new Hashtable();
    var tm=ret.split('^')
    sethashvalue(ha,tm)
    QualScore=ha.items("CheckScore");
    CheckTyp=ha.items("CheckTyp");
 	  QualScore=ha.items("CheckScore");
 	  CheckDate=ha.items("CheckDate");
  }
  if((CheckRoomId!="")&&(CheckTyp!="QualSelfCheck")){
  	var getVal = document.getElementById('getVal1');
	  var ret=cspRunServerMethod(getVal.value,CheckRoomId);
   	var ha = new Hashtable();
   	var tm=ret.split('^');
	  sethashvalue(ha,tm)
	  QualScore=ha.items("CheckScore");
	  CheckTyp=ha.items("CheckTyp");
    QualScore=ha.items("CheckScore");
    CheckDate=ha.items("CheckDate");
   	if(tm[7].split("|")[1]!=""){
   		var user=tm[7].split("|")[1].split(";");
   		var flag=0
   		for (var i=0;i<user.length;i++){
				if(session['LOGON.USERNAME']==user[i])  {flag=1}
			}
	  }
   	if((flag==0)&&(session['LOGON.GROUPDESC']!="护理部")&&(session['LOGON.GROUPDESC']!="护理部主任")&&(session['LOGON.GROUPDESC']!="Demo Group")){
   		Ext.Msg.alert('提示',"无权限录入!");
   		window.close();
   		return; 
   	}
  }
	// fm.doLayout();
	// but.hide();
	var grid = Ext.getCmp('mygrid');
	//var grid = Ext.getCmp('mygrid');
  grid.on("dblclick",ModCheck);
	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
  grid.setTitle("查房");
   // debugger;
    /*	tobar.addItem("-","检查类型",checktyp);
	tobar.addItem("-","病区",WardLoc);
	tobar.addItem("-","检查日期",stdate);
	tobar.addItem("-",eddate);
*/
	//tobar.addItem("-","科室",LocDes);
  //gform.remove(LocDes);
	tbar2=new Ext.Toolbar({});	
	tbar2.addButton({
		//className: 'new-topic-button', 
		text: "增加",
		handler:function(){NewCheck();},
		id:'btnnew',
		icon:'../images/uiimages/edit_add.png'
	});
 tbar2.addItem("-");
  tbar2.addButton({
		//className: 'new-topic-button', 
		text: "编辑",
		handler:function(){ModCheck();},
		id:'btnmod',
		icon:'../images/uiimages/pencil.png'
  }); 
  tbar2.addItem("-");
  tbar2.addButton({
		//className: 'new-topic-button', 
		text: "删除",
		handler:function(){DelCheck();},
		id:'btndelete',
		icon:'../images/uiimages/edit_remove.png'
  });
  tbar2.addItem("-");
  tbar2.addButton({
		//className: 'new-topic-button', 
		text: "导出",
		icon:'../images/uiimages/redo.png',
		handler:function(){exportFn();},
		id:'btnexport'
  });
  //tbar2.addItem("-");
  tbar2.addButton({
		//className: 'new-topic-button', 
		text:"快速输入(满分病区)",
		handler:function(){QuickCheckIn();},
		id:'btnquickin',
		hidden:true
  });		  
  tbar2.addItem("-");
  tbar2.addButton({
		//className: 'new-topic-button', 
		text: "查询",
		handler:function(){SchQual();},
		id:'btnSch',
		icon:'../images/uiimages/search.png'
  });
	tbar2.render(grid.tbar);
	tobar.doLayout();
	WardLoc.store.on("beforeload",function(){
		WardLoc.store.baseParams.HsDr=1;
   	WardLoc.store.baseParams.typ="Ward";  
  });
  var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeload",function(){
		var stdatestr = tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CheckDate);
		var stdate=tkMakeServerCall('web.DHCNurCheckRoom','ConverDate',stdatestr);
 	 	var eddate=tkMakeServerCall('web.DHCNurCheckRoom','ConverDate',stdatestr);
	 	var chktyp=CheckTyp;
	 	var ward="";
	  if (chktyp=="") return;
	  var mygrid = Ext.getCmp("mygrid");
    mygrid.store.baseParams.parr=stdate+"^"+eddate+"^"+chktyp+"^"+CheckRoomId+"^"+ward;
  });
	setGrpLayout(NurTyp);
 	/*
	 * Ext.getCmp("commould").getStore().load({ params : { start : 0, limit :
	 * 10, sid:2 }, callback : function() { //Ext.getCmp("commould").setValue(2) }
	 * }); var cmb=Ext.getCmp("commould"); cmb.on("select",loadgrid); var
	 * stdata=grid.store; stdata.on( "beforeLoad",function(){
	 * stdata.baseParams.mouldid=cmb.getValue();} );
	 * 
	 * grid.store.load({params:{start:0, limit:10}});
	 */
	document.onkeydown=BsKeyDown;
	SchQual();
	var len=mygrid.getColumnModel().getColumnCount()
	for(var i=0;i<len;i++){
		if(mygrid.getColumnModel().getDataIndex(i)=="rw"){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i)=="QualDesc"){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}

}
//Excel导出
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
function SchQual() {
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function setGrpLayout(NurTyp)
{
   if (NurTyp=="1")
   {
     cmbitm.add("WardLoc","ward");   	  
     Ext.getCmp("CheckTyp").setValue("Nur");
   	 comboload1(Ext.getCmp("WardLoc"),session['LOGON.CTLOCID']);
   }
  if (NurTyp=="2")
  {
    //CheckTyp,WardLoc
 	  Ext.getCmp("CheckTyp").setValue("LocNur");
 	  var getchktypPar=document.getElementById('getchktypPar');
    var Par=cspRunServerMethod(getchktypPar.value,session['LOGON.USERID']);
    cmbitm.add("WardLoc","Par");
 	  comboload2(Ext.getCmp("WardLoc"),Par);
  }
  if (NurTyp=="3")
 	{
    //CheckTyp,WardLoc
 	  Ext.getCmp("CheckTyp").setValue("MasterNur");
 	 // comboload1(Ext.getCmp("WardLoc"),session['LOGON.CTLOCID']);
 	}
}
var cmbitm = new Hashtable();
function comboload2(itm, val) {
  itm.getStore().baseParams[cmbitm.items(itm.id)]=val;
	if (val != "") {
		itm.getStore().load({
			params:{
				start:0,
				limit:100
			},
			callback:function(){
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
				limit : 100
			},
			callback : function() {
				itm.setValue(val);
			}
		});
	}
}
function setCheckLayout(NurTyp)
{
   if (NurTyp=="1")
   {
      cmbitm.add("CheckWard","ward");
      cmbitm.add("CheckUser","nur");

   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);
   	  comboload1(Ext.getCmp("CheckWard"),session['LOGON.CTLOCID']);
   }
  if (NurTyp=="2")
   {
      //CheckTyp,WardLoc
      var getchktypPar=document.getElementById('getchktypPar');
      var Par=cspRunServerMethod(getchktypPar.value,session['LOGON.USERID']);
      cmbitm.add("CheckWard","Par");

   	  comboload2(Ext.getCmp("CheckWard"),Par);
   	  cmbitm.add("CheckUser","nur");
   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);
   }
  if (NurTyp=="3")
   {
      //CheckTyp,WardLoc
   	 // comboload1(Ext.getCmp("WardLoc"),session['LOGON.CTLOCID']);
   	  cmbitm.add("CheckUser","nur");
   	  comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);
   }
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
function ModCheck()
{
  var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par=rowObj[0].get("rw");
	CheckValue=new Hashtable();
  CheckReason=new Hashtable();
	CheckPeople=new Hashtable();
	Check(Par);
}
function NewCheck() 
{
  Check("");
  CheckValue = new Hashtable();
  CheckReason = new Hashtable();
  CheckPeople = new Hashtable();
  Ext.getCmp("CheckScore").setValue(QualScore);
  Ext.getCmp("HundredScore").setValue("100");  //2013-5-20
}
var window1;
var HundredScore1;
function Check(Par){
	var arr = new Array();
	// 录入界面
	var a = cspRunServerMethod(pdata1, "", "DHCMGNurStChkGrade", "", "");
	arr = eval(a);
	window1 = new Ext.Window({
		title:'查房',
		id:"gform2",
		x:10,y:2,
		width:820,
		height:600,
		//autoScroll:true,
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
*/
	window1.show();
	var checkUserObj=Ext.getCmp("CheckUser");
	checkUserObj.multiSelect=true;
	//checkUserObj.tpl='<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{"11"}</span></div></tpl>'
	//checkUserObj.tpl='<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{desc}</span></div></tpl>';
	var but1 = Ext.getCmp("mygrid1but1");
	but1.hide();
	var but = Ext.getCmp("mygrid1but2");
	but.hide();
	Ext.getCmp('mygrid1pl').setHeight(490);
	Ext.getCmp('mygrid1').getTopToolbar().hide();
  Ext.getCmp("CheckDate").setValue(new Date());
  Ext.getCmp("CheckDate").disable();
	var grid = Ext.getCmp('mygrid1');
  var stdata=Ext.getCmp("mygrid1").store;
	stdata.on("beforeload",function(){ 
		var stdata=Ext.getCmp("mygrid1").store;
	  stdata.baseParams.parr=CheckRoomId+"^"+Par+"^"+CheckTyp;
	})
	Ext.getCmp('CheckWard').store.on("beforeload",function(){
  	var wardstore=Ext.getCmp('CheckWard').store;
   	wardstore.baseParams.Par=CheckRoomId;
  	wardstore.baseParams.typ="Ward"; 
  });
	Ext.getCmp('CheckUser').store.on("beforeload",function(){
    var CheckUser=Ext.getCmp('CheckUser').store;
    CheckUser.baseParams.Par=CheckRoomId;    
  });
  checkUserObj.tpl='<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.id]}" /></span><span >{Nurse}</span></div></tpl>';
  var btnSure=Ext.getCmp("btnSure");
  btnSure.setText('保存');
  btnSure.setIcon('../images/uiimages/filesave.png');
  btnSure.on('click',function(){SureCheck(Par);});
  if(CheckRoomId!=""){
    Ext.getCmp("CheckScore").setValue(QualScore);
    HundredScore1=QualScore;
    Ext.getCmp("CheckDate").setValue(CheckDate);
  }
  if(Par!=""){
	  var getVal = document.getElementById('getVal');
	  var ret=cspRunServerMethod(getVal.value,Par);
	  var arr=ret.split('^');
	  cmbitm.add("CheckWard","ward");
	  cmbitm.add("CheckUser","nur");
	  comboload1(Ext.getCmp("CheckWard"),arr[1]);
	  comboload1(Ext.getCmp("CheckUser"),arr[3]);
	  Ext.getCmp("CheckScore").setValue(arr[2]);
	  Ext.getCmp("CheckPat").setValue(arr[4]);
	  Ext.getCmp("MedCareNo").setValue(arr[5]);
	  //var Nuaa=unescape(arr[6]);
	  Ext.getCmp("CheckNur").setValue(arr[6]);
	  Ext.getCmp("CheckDate").value=arr[0];
    //人数统计
    if(arr[7]!=""&&arr[7]!=undefined){
  		//debugger
	    var sum=arr[7].split('!');
	    Ext.getCmp("BedPat").setValue(sum[0]);
     	Ext.getCmp("BWPat").setValue(sum[1]);
     	Ext.getCmp("OpPat").setValue(sum[2]);
    }
	//alert(arr[8])
   	Ext.getCmp("ReMark").setValue(arr[8]);
    //Ext.getCmp("CheckDate").disable(); 
    Ext.getCmp("CheckWard").disable(); 
    Ext.getCmp("CheckUser").disable();
    var score=(arr[2]*100)/HundredScore1
    Ext.getCmp("HundredScore").setValue(score.toFixed(1))
	  setqualitmdata(Par);//初始化扣分值，与扣分原因
 	}
  var pagesize=1000;
  var cmb=Ext.getCmp("CheckWard");
  cmb.on("select",function(){
		iniform(pagesize);
		//alert(cmb.value)取夜班护士
		Ext.getCmp("CheckNur").setValue("")
		if(cmb.value!=""){
	  	Ext.getCmp("CheckNur").value=""
	    var getNur = document.getElementById('getNur1');  
	    var parr=cmb.value+"^"+Ext.getCmp("CheckDate").getValue().format('Y-m-d');
	 		var ret=cspRunServerMethod(getNur.value,parr);
			//取病区
			if(Ext.getCmp("CheckWard").getValue()!=""){
			findpatnum(Ext.getCmp("CheckWard").getValue())}
	   	var NightNur=Ext.getCmp("CheckNur");
	  	if(ret!=""){
		   	NightNur.setValue(ret)
	   	}
	 	}
	});
 	//if (Par=="") setCheckLayout(NurTyp);
	grid.on("afteredit",afterEidt,grid)
	Ext.getCmp('mygrid1').toolbars[1].pageSize=pagesize;
	Ext.getCmp("mygrid1").store.load({
		params : {
			start : 0,
			limit :pagesize
		}
	});
	//Ext.getCmp('CheckWard')
	//findpatnum()
	var len = grid.getColumnModel().getColumnCount()
  for(var i = 0 ;i < len;i++){
  	if(grid.getColumnModel().getDataIndex(i) == 'Par'){
			grid.getColumnModel().setHidden(i,true);
		}
  	if(grid.getColumnModel().getDataIndex(i) == 'rw'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'MinLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
		if(grid.getColumnModel().getDataIndex(i) == 'ItemLevel'){
			grid.getColumnModel().setHidden(i,true);
		}
  }
}
function findpatnum(CheckWard11)
{
	var getPatNum = document.getElementById('getPatNum');
	//var CheckWard=Ext.getCmp("CheckWard").getValue();
  if(CheckWard11!="")
  {
  	var ret=cspRunServerMethod(getPatNum.value,CheckWard11);
    var sum=ret.split("^")
    Ext.getCmp("BedPat").setValue(sum[0]);
    var patCount = tkMakeServerCall('web.DHCNurseManageComm','getOrderPat',CheckWard11,"病危");
  	Ext.getCmp('BWPat').setValue(patCount);
  	var opatCount = tkMakeServerCall('web.DHCNurseManageComm','getOrderPat',CheckWard11,"手术申请：");
  	Ext.getCmp('OpPat').setValue(opatCount);
  }
}
function iniform(pagesize)
{
  // Ext.getCmp("CheckScore").setValue(QualScore);
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
  HScore=(Score/HundredScore1)*100
  Ext.getCmp("HundredScore").setValue(HScore.toFixed(1));
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
	if (confirm('确定删除选中的项？')) {
			var ret=cspRunServerMethod(delQual.value,Par);
			SchQual();
	}		
}
var MedCareNo=""
function BsKeyDown()
{
	if(document.all)
	{
		var iekey=window.event.keyCode;
		if(iekey==13)
		{
			var itm=event.srcElement.id
			if(event.srcElement.id=="MedCareNo")
			{
				MedCareNo=Ext.getCmp("MedCareNo").getValue();
				var num=8-MedCareNo.length
				for(var i=0;i<num;i++)
				{
					MedCareNo="0"+MedCareNo
				}
				Ext.getCmp("MedCareNo").setValue(MedCareNo);
				getPatName(MedCareNo)
			}
		}
	}
}
function getPatName(No)
{
 	var PatName=document.getElementById('getPatName');
  var Name=cspRunServerMethod(PatName.value,No);
  Ext.getCmp("CheckPat").setValue(Name);
}
function SureCheck(CheckPar)
{
	var sgrid = Ext.getCmp('mygrid1');
	var slen = sgrid.store.getCount();
	
	var CheckDate=Ext.getCmp("CheckDate").getValue();
	if(CheckDate instanceof Date){
			CheckDate = CheckDate.format('Y-m-d');
	}
	var CheckUser=Ext.getCmp("CheckUser").getValue();
	var CheckWard=Ext.getCmp("CheckWard").getValue();
	var CheckPat=Ext.getCmp("CheckPat").getValue();
	var CheckScore=Ext.getCmp("CheckScore").getValue();
	var NightNur=Ext.getCmp("CheckNur").getValue();
	var ChkTyp="";
	//alert(NurTyp)
	if (NurTyp=="1")
   {   	  
     ChkTyp="Nur";
   }
  if (NurTyp=="2")
  {
 	ChkTyp="LocNur";
 	  
  }
  if (NurTyp=="3")
 	{
 	  ChkTyp="MasterNur";
 	}
	//alert(ChkTyp)
  //MedCareNo保存  登记号
  CheckPat=MedCareNo
  if (CheckUser=="") {
  	//2013-6-30
     //alert("检查者不能为空！");
     //return;
  }
  if (CheckWard=="") {
     Ext.Msg.alert('提示',"检查病区不能为空！");
     return;
  }
  if(slen==0){
		Ext.Msg.alert('提示','检查项目为空不能保存！请添加检查项目！');
		return;
	}
  var chkval="";
  var checkreason="";
  var checkpeople=""
  for (var i=0 ; i<CheckValue.keys().length;i++){
		var key = CheckValue.keys()[i];
		chkval=chkval+key+"|"+CheckValue.items(key)+"^";
	}
  for(var i=0;i<CheckReason.keys().length;i++)//for...in statement get all of Array's index
	{
		var key=CheckReason.keys()[i];
		checkreason=checkreason+key+"|"+CheckReason.items(key)+"^";
	}
  for(var i=0 ; i<CheckPeople.keys().length;i++)//for...in statement get all of Array's index
	{
		var key=CheckPeople.keys()[i];
		checkpeople=checkpeople+key+"|"+CheckPeople.items(key)+"^";
	}
  var BedPat=Ext.getCmp("BedPat").getValue();
 	var BWPat=Ext.getCmp("BWPat").getValue();
 	var OpPat=Ext.getCmp("OpPat").getValue();
 	var PatSum=BedPat+"!"+BWPat+"!"+OpPat
	var ReMark1=Ext.getCmp("ReMark").getValue();
	/*
	 if ((CheckRoomId!="")&&(CheckTyp!="QualSelfCheck"))
    {
        var getVal = document.getElementById('getVal1');
	    var ret=cspRunServerMethod(getVal.value,CheckRoomId);
         var ha = new Hashtable();
         var tm=ret.split('^')
     }*/
     
	var SaveQual = document.getElementById('SaveQual');
	// alert(NurRecId);checkdate, user, checktyp, qualcode, wloc, score, ques, checkpat,checkrw
	//alert(CheckDate+"^"+CheckUser+"^"+CheckTyp+"^"+CheckRoomId+"^"+CheckWard+"^"+CheckScore+"^"+CheckPat+"^"+CheckPar);
	//2013-6-30CheckPar=cspRunServerMethod(SaveQual.value,CheckDate,CheckUser,CheckTyp,CheckRoomId,CheckWard,CheckScore,"",CheckPat,CheckPar);
	CheckPar=cspRunServerMethod(SaveQual.value,CheckDate,session['LOGON.USERID'],CheckTyp,CheckRoomId,CheckWard,CheckScore,"",CheckPat,CheckPar,NightNur,PatSum,ReMark1,ChkTyp);
//	debugger;
	if (CheckPar!="" )
	{
	  var SaveQualItem = document.getElementById('SaveQualItem');
    CheckPar=cspRunServerMethod(SaveQualItem.value,CheckRoomId,chkval,checkreason,CheckPar,checkpeople);
	}
	MedCareNo=""
  window1.close();
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
var CheckPeople = new Hashtable();
function setqualitmdata(Par)
{
	var getval = document.getElementById('getqualitmdata');
	var ret = cspRunServerMethod(getval.value, Par);
	var tm = ret.split('^')
	for (var i=0;i<tm.length;i++)
	{
	   if (tm[i]=="") continue;
	   var arr=tm[i].split('|');
	   //var nurr=unescape(arr[1]);
	   CheckValue.add(arr[0],arr[2]);
	   CheckReason.add(arr[0],arr[1]);
	   CheckPeople.add(arr[0],arr[3]);
	}
}
function afterEidt(e)
{ //拿到选中的列 ,下面是在editGridPanel中
 //var record = grid.getSelectionModel().selection.record; 
 //如果是在GridPanel中，拿到record的方法为如下
 //var record = grid.getSelectionModel().getSelected();
  //调用record的set方法格式为
 //record.set(名称,值)
 //其中名称是dataindex对应的值。
 //最后提交以下
 //record.commit()
  var row = e.record;
//  if (row.get("CheckScore")=="") return;
  if(row.get("CheckScore")=="")
  {
	var ItemCode=row.get('ItemCode');
	if(CheckValue.contains(ItemCode)){
		CheckValue.remove(ItemCode);
	}
	// 扣分原因
	if(CheckReason.contains(ItemCode)){
		CheckReason.remove(ItemCode);
	}
	if(CheckPeople.contains(ItemCode)){
		CheckPeople.remove(ItemCode);
	}
	row.set('CheckMem','');
	SetScore();
	return;
  }
  var itmvalue =parseFloat( row.get("ItemValue")).toFixed(2);
  var numflag = isNaN(row.get("CheckScore"));
  if (numflag==true) row.set("CheckScore","");
  numflag=isNaN(row.get("ItemValue"));
  if (numflag==true) {
  	alert("分值类型不对！");
  	return;
  }
 	var flag =row.get("MinLevel");
 	var ItemCode =row.get("ItemCode");
 	var CheckMem =row.get("CheckMem");
  var People =row.get("CheckPeople");
 	if (flag=="N") row.set("CheckScore","");
  var checkscore =parseFloat( row.get("CheckScore")).toFixed(2);
  if (parseFloat(checkscore)>parseFloat(itmvalue))
  {
    row.set("CheckScore","");
  }else{
  	//扣分
   if(CheckValue.contains(ItemCode))
  	{
  	   CheckValue.remove(ItemCode);
   	}else{
   	}
  	CheckValue.add(ItemCode,checkscore);
  }
  //扣分原因
  if (CheckReason.contains(ItemCode))
	{
	   CheckReason.remove(ItemCode);
 	}else{
  }
	CheckReason.add(ItemCode,CheckMem);
	//检查对象
	if (CheckPeople.contains(ItemCode))
	{
	  CheckPeople.remove(ItemCode);
 	}else{
  }
 	CheckPeople.add(ItemCode,People);
  SetScore();
}
function QuickCheckIn() {
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var arr = new Array();
	// 录入界面														DHCMgNurCheckQuickIn
	var a = cspRunServerMethod(pdata1,"","DHCMgNurCheckQuickIn","","");
	arr = eval(a);
	var window = new Ext.Window({
		title:'快速评分',
		id:'gform3',
		x:150,y:2,
		width:420,
		height:550,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		items:arr
	});
	window.show();
	/*	var but1 = Ext.getCmp("butSave");
	but1.on('click', itmAdd);
	var but = Ext.getCmp("butMod");
	but.on('click', itmMod);
	var but2 = Ext.getCmp("butClear");
	but2.on('click', clearscreen);
*/
	var but1=Ext.getCmp("mygrid2but1");
	but1.hide();
	var but=Ext.getCmp("mygrid2but2");
	but.hide();
	var btnSure=Ext.getCmp('btnSure');
	btnSure.on('click',quickSure);
  Ext.getCmp('CheckDate').setValue(CheckDate);
	Ext.getCmp('mygrid2').store.on("beforeLoad",function(){
 	  var hsdr=1;
	  var mygrid = Ext.getCmp("mygrid2");
    mygrid.store.baseParams.HsDr=hsdr;
    mygrid.store.baseParams.typ="Ward";
  });
  Ext.getCmp('CheckUser').store.on("beforeLoad",function(){
    var CheckUser=Ext.getCmp('CheckUser').store;
    CheckUser.baseParams.Par=CheckRoomId;  
  });
    /*2013-5-22
      cmbitm.add("CheckUser","nur");
      var user = rowObj[0].get("CheckUser");
      comboload1(Ext.getCmp("CheckUser"),user);
   	  //comboload1(Ext.getCmp("CheckUser"),session['LOGON.USERID']);
*/
   setgrid();
}
function quickSure()
{
	var grid=Ext.getCmp("mygrid2");
	var store=grid.store;
	var rowCount=store.getCount(); // 记录数
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	var list=[];
	var CheckDate=Ext.getCmp("CheckDate").value;
  var CheckUser=Ext.getCmp("CheckUser").getValue();
  //var CheckUser=Ext.getCmp("CheckUser").getValue();
  //var CheckTyp=Ext.getCmp("CheckTyp").getValue();
  var CheckScore=QualScore;
  if (CheckUser==""){
   alert("检查者不能为空！");
   return;
  }
	// for (var i = 0; i < store.getCount(); i++) {
	// list.push(store.getAt(i).data);
	// //debugger;
	// }
	var rowObj = grid.getSelectionModel().getSelections();
	var len=rowObj.length;
	for (var r=0;r<len;r++) {
		list.push(rowObj[r].data);
	}
	var SaveQt = document.getElementById('SaveMulitms');
	var rw="";
	var str="";
	for (var i=0;i<list.length;i++){
		var obj=list[i];
		rw=obj["LocDr"];
		str=str+rw+"^";
	}
	if(str!=""){
		//CheckPar=cspRunServerMethod(SaveQual.value,CheckDate,CheckUser,CheckTyp,CheckRoomId,CheckWard,CheckScore,"",CheckPat,CheckPar);
    //保存参数
		var a=cspRunServerMethod(SaveQt.value,CheckUser,str,CheckRoomId,CheckDate,CheckTyp,CheckScore);
		if(a!=0){
     SchQual();
   	}
	}
}
function setgrid(){
	/*
	 * var grid = Ext.getCmp("mygrid"); var
	 * GetQueryData=document.getElementById('GetQueryData'); arrgrid=new
	 * Array(); var a = cspRunServerMethod(GetQueryData.value,
	 * "web.DHCNurHDCodeComm:HDMode", "","AddRec");
	 * grid.store.loadData(arrgrid);
	 */
	var grid1=Ext.getCmp("mygrid2");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
}
var CurrSelItm="";
function SaveItm()
{
  ret="";
	checkret="";
	comboret="";
	var Save=document.getElementById('Save');
	var gform=Ext.getCmp("gform2");
	gform.items.each(eachItem,this);
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// var parr=ret+"&"+checkret+"&"+comboret;
	//alert(ret + "^" + checkret + "^" + comboret);
	var parr = "rw|"+CurrSelItm+"^Par|"+curmenuid+"^"+ret+"^"+ checkret + "^" + comboret;
	// return;
	// var
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
	var row = cspRunServerMethod(Save.value, parr);
	// win.close();
	Ext.getCmp("mygrid2").store.load({
		params:{
			start:0,
			limit:10,
			Par:curmenuid
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
  var rowObj=grid.getSelectionModel().getSelections();
	var len=rowObj.length;
	var list=[];
	if(rowObj.length==0){
		return;
	}
	CurrSelItm=rowObj[0].get("rw");
  setbutstatus(1);
	for(var r=0;r<len;r++){
		list.push(rowObj[r].data);
	}
	for(var i=0;i<list.length;i++) {
		var obj=list[i];
		for(var p in obj){
			var itm=Ext.getCmp(p);
			if(itm!=undefined) itm.setValue(obj[p]);
		}
	}
}
function setvalue(menid) {
	var ha = new Hashtable();
	var getval=document.getElementById('getVal');
	var ret=cspRunServerMethod(getval.value, menid);
	var tm=ret.split('^')
	sethashvalue(ha,tm)
	// debugger;
	// var tm1=ret.split('^')
	// debugger;
	// sethashvalue(ha,tm1);
	var gform=Ext.getCmp("gform2");
	gform.items.each(eachItem,this);
	for(var i=0;i<ht.keys().length;i++)// for...in statement get all of
	// Array's index
	{
		var key=ht.keys()[i];
		// restr += ht.items(key) + " " + ht.parent[key] + "<br/>";
		if (key.indexOf("_")==-1) {
			var itm=Ext.getCmp(key);
			if(ha.contains(key))
				if(itm.xtype=="combo"){
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
function comboload(itm,str){
	var aa=str.split('!');
	var par=itm.id;
	if(aa.length<2){
		itm.setValue(str);
		return;
	}
	if(str!=""){
		itm.getStore().load({
			params:{
				start:0,
				limit:10,
				locdes:aa[0]
			},
			callback:function() {
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
	// var rw=cspRunServerMethod(getemrcodeid.value,code,NurRecId);
	// var parr=ret+"&"+checkret+"&"+comboret;
	var parr = "rw|" + menuid + "^" + ret + "^" + checkret + "^" + comboret;
	// var
	// id=cspRunServerMethod(SaveExam.value,"id|"+ret+"^CTLocDr|"+session['LOGON.CTLOCID']+"^"+checkret+"^"+comboret);
	// //+"^UserDr|"+session['LOGON.USERID']
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
	// debugger;
	mygrid.store.load({
		params:{
			start:0,
			limit:10
		}
	});
}
function additm() {
	var grid = Ext.getCmp('mygrid1');
	var Plant = Ext.data.Record.create([]);
			// the "name" below matches the tag name to read, except "availDate"
			// which is mapped to the tag "availability"	
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
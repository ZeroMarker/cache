var Width = document.body.clientWidth-5;
var Height = document.body.clientHeight-3;
var stDate=new Ext.form.DateField({
	id:'stdate',
	format:'Y-m-d',
	tabIndex:'0',
	height:20,
	width:100,
	xtype:'datefield',
	value:new Date().getFirstDateOfMonth()
	//value:new Date((new Date()).getFullYear(),(new Date()).getMonth(),1).format('Y-m-d')
});
var edDate=new Ext.form.DateField({
	id : 'enddate',
	format : 'Y-m-d',
	tabIndex : '0',
	height : 21,
	width : 100,
	xtype : 'datefield',
	value:new Date().getLastDateOfMonth()
});
var DHCNurQualRoomSetT105=new Ext.data.JsonStore({data:[],fields:['Qual','rw']});
var DHCNurQualRoomSetT108=new Ext.data.JsonStore({data:[],fields:['User','srw']});
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
var checkflag=tkMakeServerCall("DHCMGNUR.MgNurse","getCheckFlag",session['LOGON.USERID']);
function BodyLoadHandler()
{
	var mygridpl = Ext.getCmp('mygridpl');
	mygridpl.setWidth(Width);
	mygridpl.setHeight(Height);
	var mygrid = Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	var tbar1 = new Ext.Toolbar({});
	tbar1.addItem('-','开始日期:',stDate);
	tbar1.addItem('-','结束日期:',edDate);
	var tbar2 = new Ext.Toolbar({});
	tbar2.addItem('-');
	tbar2.addButton({ 
		text: '新建',
		handler:function(){NewCheck();},
		icon:'../Image/light/useradd.png',
		id:'btnnew'
	});
	tbar2.addItem('-');
	tbar2.addButton(  { 
		text: '编辑',
		handler:function(){ModCheck();},//编辑条目
		icon:'../image/light/useredit.png',
		id:'btnmod'
  });
  tbar2.addItem("-");
  tbar2.addButton({
  	text:'删除',
  	handler:function(){delQualItem();},
  	icon:'../Image/light/delete.gif',
  	id:'btndel'
  });
	tbar2.addItem("-");
  tbar2.addButton({
		text: '查询',
		handler:function(){SchQual(mygrid,30);},
		icon:'../image/light/search.png',
		id:'btnSch'
  });
	mygrid.getBottomToolbar().hide();
	setBottomTool(mygrid,30);
	tbar1.render(mygrid.tbar);
	tbar2.render(mygrid.tbar);
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on('beforeload',function(){
	  var stdate=Ext.getCmp('stdate').getValue();
	  if(!stdate){
	  	stdate = "";
	  }else{
	  	if(stdate instanceof Date){
	  		stdate = stdate.format('Y-m-d');
	  	}
	  }
	 	var eddate=Ext.getCmp('enddate').getValue();
	 	if(!eddate){
	 		eddate = "";
	 	}else{
	 		if(eddate instanceof Date){
	 			eddate = eddate.format('Y-m-d');
	 		}
	 	}
	  var mygrid = Ext.getCmp('mygrid');
	  mygrid.store.baseParams.parr=stdate+"^"+eddate+"^"+CheckTyp+"^"+session['LOGON.USERID']+"^"+secGrpFlag;
  });
  mygrid.on('rowdblclick',checkroom);
  var len = mygrid.getColumnModel().getColumnCount()
  for(var i=0;i<len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}
  SchQual(mygrid,30);
  
}
function delQualItem()
{
	var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var Par = rowObj[0].get('rw');
	var recUser = tkMakeServerCall('DHCMGNUR.MgCheckWard','getRecUser',Par);
	if(session['LOGON.USERID'] != recUser){
		Ext.Msg.alert('提示','无权删除！');
		return;
	}
	Ext.Msg.confirm('删除', '是否确认删除', function(btn, text){
	  if (btn == 'yes'){
			
			var count = tkMakeServerCall('DHCMGNUR.MgCheckWard','judClear',Par);
			if(count==0){
				tkMakeServerCall('DHCMGNUR.MgCheckWard','delQual',Par);
				SchQual(grid,30);
				return;
			}else{
	  		resure(Par);
	  	}
		}
	});
}
function resure(Par)
{
	var grid = Ext.getCmp('mygrid');
	var a = confirm('此条记录已经评分，确定要删除吗？');
 	if(a == true){
	  tkMakeServerCall('DHCMGNUR.MgCheckWard','delQual',Par);
	  SchQual(grid,30);
	}else{
		return;
	}
}
function checkroom()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}    
	var CheckRoomId = rowObj[0].get('rw');
	var CheckTyp = rowObj[0].get('CheckTyp');
	if ((CheckTyp == 'QualCheck')||(CheckTyp == 'SpecCheck')){
		var link = "dhcmgnurcheck.csp?CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
    window.open(link,'质控检查','height=680,width=1100,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
    return;
	}else if((CheckTyp=="QualSelfCheck")||(CheckTyp=="SpecSelfCheck")||(CheckTyp=="SafeSelfCheck")){
		var link="dhcmgnurcheck.csp?CheckRoomId="+CheckRoomId+"&CheckTyp="+CheckTyp;
    window.open (link,'质控检查','height=700,width=1200,top=0,left=0,toolbar=no,menubar=no,scrollbars=yes, resizable=no,location=no, status=no') ;
    return;
	}
}
function NewCheck() 
{
   if(secGrpFlag!="demo"){
	   if((CheckTyp=="QualSelfCheck")&&(secGrpFlag!="nurhead")){
	      alert("病区自查只有护士长可以新建检查任务!");
	      return;
        }
       if(CheckTyp=="QualCheck"){
		  if(secGrpFlag!="hlb"){
			  if(checkflag!=2){
				  alert("质控检查只有护理部或者科护士长可以新建检查任务!");
			      return;
			  }
	        }
        }
   }
  Check('');
}
function ModCheck()
{
  var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var Par = rowObj[0].get('rw');
	var recUser = tkMakeServerCall('DHCMGNUR.MgCheckWard','getRecUser',Par);
	if(session['LOGON.USERID'] != recUser){
		Ext.Msg.alert('提示','无权修改！');
		return;
	}
	Check(Par);
}
function Check(Par)
{
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCNurQualRoomSet", "", "");
	arr = eval(a);
	var window = new Ext.Window({
		title : '查房',
		id : 'gform2',
		x:80,y:80,
		width:465,
		height:480,
		autoScroll:true,
		layout:'absolute',
		modal:true,
		resizable:false,
		items:arr,
		buttons:[{
			id:'btnSure',
			text:'确定'
		}]
	});
	var mygrid2=Ext.getCmp('mygrid2');
	mygrid2.colModel.setHidden(1,true);
	mygrid2.getBottomToolbar().hide();
	var mygrid3=Ext.getCmp('mygrid3');
	mygrid3.getBottomToolbar().hide();
	window.show();
	var grid2 = Ext.getCmp('mygrid2');
	grid2.getBottomToolbar().hide();
	var grid3 = Ext.getCmp('mygrid3');
	grid3.getBottomToolbar().hide();
	grid2.store.removeAll();
	grid3.store.removeAll();
	var but1=Ext.getCmp("mygrid2but1");
  but1.setText('删除');
  but1.on('click',function(){delitm(grid2);})
  var but=Ext.getCmp("mygrid2but2");
  but.hide();
  var but1=Ext.getCmp("mygrid3but1");
  but1.setText('删除');
  but1.on('click',function(){delitm(grid3);});//检查项目删除
  var but=Ext.getCmp("mygrid3but2");
  but.hide();
  var checkStDate = Ext.getCmp('CheckStDate');
  checkStDate.setValue(new Date());
  //checkStDate.addListener('change',function(obj,newValue,oldValue){checkDateValid(obj,Ext.getCmp('CheckEdDate'))})
	checkStDate.addListener('select',function(obj,date){
		var enddate = Ext.getCmp('CheckEdDate').getValue();
		if(enddate){
			var flag = date.between(date,enddate);
			if(!flag){
				Ext.Msg.alert('提示','开始日期不能大于结束日期！');
				obj.setValue('');
				return;
			}
		}
	});
	var checkEndDate = Ext.getCmp('CheckEdDate');
	checkEndDate.setValue((new Date()).getLastDateOfMonth());
	checkEndDate.addListener('select',function(obj,date){
		var stdate = Ext.getCmp('CheckStDate').getValue();
		if(stdate){
			var flag = date.between(stdate,date);
			if(!flag){
				Ext.Msg.alert('提示','结束日期不能小于开始日期！');
				obj.setValue('');
				return;
			}
		}
	});
	var nurComm = Ext.getCmp('Nurse');
  nurComm.store.on("beforeload",function(){
    nurComm.store.baseParams.Name = nurComm.lastQuery;
    nurComm.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID'];
  });
  var btnadd1 = Ext.getCmp("btnadd1");
 	btnadd1.on('click',function(){
  	var Nurse = Ext.getCmp('Nurse');
 		if (Nurse.getValue() == '') return;
 		var des = Nurse.lastSelectionText;
 		var raw = Nurse.getValue();
 		additmNurse('mygrid2',des,raw);
 	});
 	var btnMulti = Ext.getCmp('btnMulti'); 
  btnMulti.on('click',function(){multiCheck();});
  var btnSure = Ext.getCmp('btnSure');
  btnSure.on('click',function(){SureCheck(Par);});
  if(Par){
  	var	ret = tkMakeServerCall('DHCMGNUR.MgCheckWard','getVal',Par);
  	if(ret){
  		var ha = new Hashtable();
    	var tm = ret.split('^');
    	sethashvalue(ha,tm);
    	Ext.getCmp('CheckMem').setValue(ha.items('CheckMem'));
	    Ext.getCmp('CheckStDate').setValue(ha.items('CheckStDate'));
		  Ext.getCmp('CheckEdDate').setValue(ha.items('CheckEdDate'));
	    Ext.getCmp('CheckTitle').setValue(ha.items('CheckTitle'));
    }
    var ret1 = tkMakeServerCall('web.DHCMgNurQcRestruct','getitms1',Par);
    if(ret1){
    	var gr=ret1.split("$");
      var arr2=gr[0].split("!");
      var arr1=gr[1].split("!");
      for (var i=0;i<arr1.length;i++){
      	if (arr1[i]!=""){
      		var itm=arr1[i].split("^");
          additmItm("mygrid3",itm[0],itm[1],itm[2]);
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
}
function SureCheck(Par)
{
	var CheckTitle = Ext.getCmp('CheckTitle').getValue();
	if(!CheckTitle){
		Ext.Msg.alert('提示','请填写检查标题！');
		return;
	}
	var CheckStDate=Ext.getCmp('CheckStDate').getValue();
	if(!CheckStDate){
		Ext.Msg.alert('提示','请选择开始日期！');
		return;
	}else{
		if(CheckStDate instanceof Date){
			CheckStDate = CheckStDate.format('Y-m-d');
		}
	}
	var CheckEdDate=Ext.getCmp('CheckEdDate').getValue();
	if(!CheckEdDate){
		Ext.Msg.alert('提示','请选择结束日期!');
		return;
	}else{
		if(CheckEdDate instanceof Date){
			CheckEdDate = CheckEdDate.format('Y-m-d');
		}
	}
	var users = getgriditm(Ext.getCmp("mygrid2"));
  if(users==""){Ext.Msg.alert('提示','请添加检查人员！');return;}
  var checkItms=getgridwet(Ext.getCmp("mygrid3"));
  if(checkItms==""){Ext.Msg.alert('提示','请添加检查项目！');return;}
  var CheckMem=Ext.getCmp('CheckMem').getValue();
  var NurTyp="";
  if(secGrpFlag=="demo"||secGrpFlag=="hlb"){
  	NurTyp = "H";
  }else if(secGrpFlag=="nurhead"){
  	NurTyp = "W";
  }else if(secGrpFlag=="znurhead"){
  	NurTyp = "Z";
  }else{
  	return;
  }
  if(checkflag=="2"){
  	NurTyp = "Z";
  }
  parr='rw|'+Par+'^CheckTitle|'+CheckTitle+'^CheckMem|'+CheckMem+'^CheckStDate|'+CheckStDate+'^CheckEdDate|'+CheckEdDate+'^CheckTyp|'+CheckTyp+'^NurTyp|'+NurTyp+'^CheckQuals|'+checkItms+'^RecUser|'+session['LOGON.USERID'];
  //alert(parr)
  //return
	tkMakeServerCall('DHCMGNUR.MgCheckWard','Save',parr,users,checkItms);
	Ext.getCmp('gform2').close();
	var mygrid = Ext.getCmp('mygrid');
	SchQual(mygrid,30);
}
function SchQual(grid,count)
{
	grid.store.load({params:{start:0,limit:count}});
}
function getgridwet(grid)
{
    var n = grid.getStore().getCount();
    var store = grid.store;
    var ret="";
    for( var j=0;j<n;j++){
       var rw=store.getAt(j).get('rw');
       var qType=store.getAt(j).get('QType');
       ret=ret+"^"+qType+"!"+rw;
    }
   return ret;
}
function getgriditm(grid)
{
	var n = grid.getStore().getCount();
  var store = grid.store;
  var ret="";
  for( var j = 0;j < n;j++)
  {
     var rw = store.getAt(j).get('srw');
     ret = ret + "^" + rw; 
  }
  return ret;
}
var DHCNurMgChItmMulT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'QualDesc','mapping':'QualDesc'},{'name':'rw','mapping':'rw'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'GetQualCode',type:'RecQuery'}});
//var DHCNurMgWardMulT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'FindWardLoc',type:'Query'}});
function Sure()
{
	var grid = Ext.getCmp("mygridt");
	var store = grid.store;
	var rowCount = store.getCount(); // 记录数
	var cm = grid.getColumnModel();
	var colCount = cm.getColumnCount();
	var list = [];
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len==0){
		Ext.Msg.alert('提示','请选择要保存的记录！');
		return;
	}
	for (var r = 0; r < len; r++) {
		list.push(rowObj[r].data);
	}
	for (var i = 0; i < list.length; i++) {
		var obj = list[i];
		raw = obj["raw"];
		des=obj["QualDesc"];
		qtype=obj["QType"];
		additmItm("mygrid3",des,qtype,raw);
	}
}
function delitm(grid)
{
  grid.store.remove(grid.getSelectionModel().getSelected());
}
function additmItm(griditm,Qual,qtype,raw)
{
    var grid=Ext.getCmp(griditm);
    var n = grid.getStore().getCount();
    var store = grid.store;
    for( var j=0;j<n;j++){
       var rw=store.getAt(j).get("rw");
       if (rw==raw)return;
    }
    var Plant = Ext.data.Record.create([]);
    var count = grid.store.getCount(); 
    var r = new Plant({Qual:Qual,QType:qtype,rw:raw}); 
    grid.store.commitChanges(); 
    grid.store.insert(count,r); 
    return;
}
function multiCheck()
{
	var typ="";
	var Par="";
	createWin(typ,Par);
}
function createWin(typ,Par)
{
	var itmType=new Ext.form.ComboBox({
		name:'itmtype',
		id:'itmtype',
		tabIndex:'0',
		height:20,
		width:100,
		xtype:'combo',
		store:new Ext.data.JsonStore({
			data:[{
				desc:'标准项目',
				id:'S'
			},{
				desc:'自定义项目',
				id:'C'
			}],
			fields:['desc','id']
		}),
		displayField:'desc',
		valueField:'id',
		allowBlank:true,
		mode:'local',
		triggerAction :'all',
		value:''
	});
	var mypanel = createNewPanel(typ);
	var win=new Ext.Window({
 		title:'质控项目',
		id:'qcWin',
		x:200,y:100,
		width:350,
		height:500,
		layout:'absolute',
		modal:true,
		resizable: false,
		items:[mypanel],
		buttons:[{
			id:'OkBtn',
			text:'关闭',
			handler:function(){win.close();}	
		}]
 	});
	win.show();
	var mainpanel = Ext.getCmp('mainpanel');
	mainpanel.setWidth(win.getInnerWidth());
	mainpanel.setHeight(win.getInnerHeight());
	var mygridt = Ext.getCmp('mygridt');
	mygridt.setWidth(win.getInnerWidth());
	mygridt.setHeight(win.getInnerHeight());
	mygridt.getTopToolbar().hide();
	var newTbar = new Ext.Toolbar({});
	newTbar.addItem('-','类型:',itmType);
	newTbar.addItem('-');
	newTbar.addButton({
		id:'addqualitm',
		text:'保存',
		handler:function(){Sure();}
	});
	newTbar.render(mygridt.tbar);
	itmType.on('select',function(combo, record, index){
		mygridt.store.on('beforeload',function(ts, ops ){
			mygridt.store.baseParams.typ = combo.getValue();
			mygridt.store.baseParams.ward = '';
			mygridt.store.baseParams.parr = secGrpFlag+"^"+session['LOGON.USERID'];
		});
		mygridt.store.load({params:{start:0,limit:1000}});
	});
	
}
function createNewPanel(typ)
{
	var table = createNewTable(typ);
	var panel = new Ext.Panel({
		id:'mainpanel',
		region: 'center',
		margins:'3 3 3 0',
		activeTab: 0,
		x:-1,y:-8,
		border:false,
		height: Height-100,
		width: 700,
		tbar:[],
		items:[{
			items:[table]
		}]
	});
	return panel;
}
function createNewTable(typ)
{
	var colModelStr = new Array();
	var colData = new Array();
	var smt = new Ext.grid.CheckboxSelectionModel();
	colModelStr.push(smt);
	colModelStr.push(new Ext.grid.RowNumberer());
	colModelStr.push({header:'名称',width:100,align:'left',sortable:false,dataIndex:'QualDesc'});	
	colData.push({'name':'QualDesc','mapping':'QualDesc'});
	colModelStr.push({header:'raw',width:50,align:'center',sortable:false,dataIndex:'raw'});	
	colData.push({'name':'raw','mapping':'raw'});
	colModelStr.push({header:'类型',width:50,align:'center',sortable:false,dataIndex:'QType'});	
	colData.push({'name':'QType','mapping':'QType'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{className:'web.DHCMgNurQcRestruct',methodName:'findQualItms',type:'RecQuery'}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygridt',
		x:5,y:0,
		height:686,
		width:686,
		store:store,
		sm:smt,
		cm:colModel,
		tbar:[],
		bbar:new Ext.PagingToolbar({ 
      pageSize:1000, 
      store:store,
      displayInfo:true, 
      displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录" 
    })
	});
	return table;
}
function additmNurse(griditm,Nurse,srw)
{
	var grid=Ext.getCmp(griditm);
 	var n = grid.getStore().getCount();
 	var store = grid.store;
  for( var j=0;j<n;j++){
    var rw=store.getAt(j).get("srw");
    if (rw==srw)return;
  }  
  var Plant = Ext.data.Record.create([]);
  var count = grid.store.getCount(); 
  var r = new Plant({User:Nurse,srw:srw}); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}

function setBottomTool(grid,pageSize)
{
	var bbar1 = new Ext.PagingToolbar({
		pageSize:pageSize,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar1.render(grid.bbar);
}
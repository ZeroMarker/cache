var Width = document.body.clientWidth-5;
var Height = document.body.clientHeight-3;
var stDate=new Ext.form.DateField({
	id:'stdate',
	format:'Y-m-d',
	tabIndex:'0',
	height:20,
	width:100,
	xtype:'datefield',
	//value:new Date().add(Date.DAY,-7)
	value:new Date().getFirstDateOfMonth()
});
var endDate=new Ext.form.DateField({
	id:'enddate',
	format:'Y-m-d',
	tabIndex:'0',
	height:20,
	width:100,
	xtype:'datefield',
	//value:new Date().add(Date.DAY,14)
	value:new Date().getLastDateOfMonth()
});
var DHCNURNightWardSetT109=new Ext.data.JsonStore({data:[],fields:['WardDes','rw']});
var DHCNURNightWardSetT112=new Ext.data.JsonStore({data:[],fields:['User','raw']});
//var DHCNurMgWardMulT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'web.DHCMgNurSysComm',methodName:'FindWardLoc',type:'Query'}});
var DHCNurMgWardMulT101=new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:[{'name':'LocDes','mapping':'LocDes'},{'name':'LocDr','mapping':'LocDr'}]}),baseParams:{className:'web.DHCMgNurQcRestruct',methodName:'FindWardLoc',type:'Query'}});
var roomType=new Ext.form.ComboBox({
	name:'roomtype',
	id:'roomtype',
	tabIndex:'0',
	height:20,
	width:100,
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
	triggerAction :'all',
	value:'NightChk'
});
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	var mygridpl = Ext.getCmp('mygridpl');
	mygridpl.setWidth(Width);
	mygridpl.setHeight(Height);
	var mygrid = Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	var tbar1 = new Ext.Toolbar({});
	tbar1.addItem('-','类型:',roomType);
	tbar1.addItem('-','开始日期:',stDate);
	tbar1.addItem('-','结束日期:',endDate);
	var tbar2 = new Ext.Toolbar({});
	tbar2.addItem('-');
	tbar2.addButton({
		text:"新建",
		handler:function(){NewCheck();},
		id:'btnnew',
		//hidden:true,
		icon:'../Image/light/useradd.png'	
	});
	tbar2.addItem('-');
	tbar2.addButton({
		text:"编辑",
		handler:function(){ModCheck();},
		id:'btnmod',
		//hidden:true,
		icon:'../image/light/useredit.png'
  });
  tbar2.addItem('-');
//  tbar2.addButton({
//		text:"检查项目",
//		handler:function(){CheckItem1();},
//		id:'btnCheckitm',
//		hidden:true,
//		icon:'../Image/icons/application_add.png'
//	});
//  tbar2.addItem('-')
  tbar2.addButton({ 
		text: "查询",
		handler:function(){SchQual();},
		id:'SchBtn',
		//hidden:true,
		icon:'../image/light/search.png'
	});
	tbar2.addItem('-');
	tbar2.addButton({
		text:"Excel",
		handler:function(){exportFn();},
		id:'btnExport',
		//hidden:true,
		icon:'../Image/icons/application_put.png'
	});
	mygrid.getBottomToolbar().hide();
	setBottomTool(mygrid,30);
	tbar1.render(mygrid.tbar);
	tbar2.render(mygrid.tbar);
	mygrid.store.on("beforeload",function(){
  	var flag=0
    var stdate=Ext.getCmp("stdate").getValue();
    if(!stdate){
    	stdate = "";
    }else{
    	if(stdate instanceof Date){
    		stdate = stdate.format('Y-m-d');
    	}
    }
 	 	var eddate=Ext.getCmp("enddate").getValue();
 	 	if(!eddate){
 	 		eddate = ""
 	 	}else{
 	 		if(eddate instanceof Date){
 	 			eddate = eddate.format('Y-m-d');
 	 		}
 	 	}
	 	var chktyp = "";
		var CheckLevel="";
		if(secGrpFlag == 'hlb' || secGrpFlag == 'demo'){
			CheckLevel = 'H';
		}else if(secGrpFlag == 'nurhead'){
			CheckLevel = 'W';
		}else if(secGrpFlag == 'znurhead'){
			CheckLevel = 'Z';
		}
		var mygrid = Ext.getCmp('mygrid');
		//flag为1无权限，为0有权限
	  mygrid.store.baseParams.parr = stdate + "^" + eddate + "^" + chktyp + "^" + session['LOGON.USERID'] + "^" + flag + "^" + CheckLevel + "^" + secGrpFlag + "^" + roomType.getValue();
  });
  SchQual();
  mygrid.on('dblclick',checkroom);
  var len=mygrid.getColumnModel().getColumnCount()
  for(var i=0;i<len;i++){
		if(mygrid.getColumnModel().getDataIndex(i)=="QualDesc"){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i)=="row"){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i)=="RecUser"){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i)=="CheckTyp"){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}
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
			xlSheet.Cells(i + 1,j).Value = view.getCell(i - 1,temp_obj[j - 1]).innerText; 
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
	var CheckRoomId = rowObj[0].get('row');
	var CheckTyp = rowObj[0].get('CheckTyp');
  var link="dhcmgnurcomm.csp?CheckRoomId="+CheckRoomId+"&EmrCode=DHCMGNurCheckRoomLsts&CheckTyp="+CheckTyp;
	window.open(link,'查房','height=650,width=1000,top=20,left=20,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no') 
}
function NewCheck() 
{
  if(secGrpFlag!="demo"){
	  if(secGrpFlag!="hlb"){
		  alert("只有护理部可以新建检查任务!");
		  return;
	  }
  }
  Check("");
}
function ModCheck()
{
  var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("row");
	var recUser = rowObj[0].get('RecUser');
	if(session['LOGON.USERID'] != recUser){
		Ext.Msg.alert('提示','无权修改！');
		return;
	}
	CheckValue = new Hashtable();
  CheckReason = new Hashtable();
	Check(Par);
}
function Check(Par)
{
	var arr = new Array();
	var a = cspRunServerMethod(pdata1,"","DHCNURNightWardSet","","");
	arr = eval(a);
	var window = new Ext.Window({
		title:'查房内容',
		id:"gform2",
		x:20,y:20,
		width:530,
		height:520,
		resizable:false,
		autoScroll:true,
		layout:'absolute',
		modal: true,
		items:arr,
		buttons:[{id:'btnSure',text:'确定'}]
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
  but1.on('click',function(){delitm(Ext.getCmp("mygrid2"));});
	var but=Ext.getCmp("mygrid2but2");
	but.hide();
	var but1=Ext.getCmp("mygrid3but1");
	but1.setText("删除");
	but1.on('click',function(){delitm(Ext.getCmp("mygrid3"));});
	var but=Ext.getCmp("mygrid3but2");
	but.hide();
	var CheckDate=Ext.getCmp("CheckDate");
	CheckDate.setValue(new Date());
 	var CheckSTime=Ext.getCmp("CheckSTime");
  CheckSTime.setValue(new Date());
 	var CheckEndTime=Ext.getCmp("CheckEndTime");
  CheckEndTime.setValue(new Date());
  
  var btnMulti=Ext.getCmp("btnMulti");
  btnMulti.on("click",function(){multiward();});
  var btnadd1=Ext.getCmp("btnadd1");
 	btnadd1.on("click",function(){
  	var Nurse=Ext.getCmp("Nurse");
 		if (Nurse.getValue()=="") return;
 		var des=Nurse.lastSelectionText;
 		var raw=Nurse.getValue();
 		additmNurse("mygrid2",des,raw);
 	});
 	var btnadd2=Ext.getCmp("btnadd2");
  btnadd2.on("click",function(){  
  	var PatWard=Ext.getCmp("PatWard");
  	if (PatWard.getValue()=="") return;
  	var des=PatWard.lastSelectionText;
   	var rw=PatWard.getValue();
  	additmWard("mygrid3",des,rw);
  });
  var patWard = Ext.getCmp('PatWard');
  patWard.store.on("beforeload",function(){
    patWard.store.baseParams.HsDr=1;
    var laststr2=patWard.lastQuery
    if(laststr2!=undefined){patWard.store.baseParams.ward=laststr2;}
    var nurTypeFlag = "";
    if(secGrpFlag == "hlb"){
    	nurTypeFlag = "H"
    }else if(secGrpFlag == "znurhead"){
    	nurTypeFlag = "Z";
    }else if(secGrpFlag == 'nurhead'){
    	nurTypeFlag = "W";
    }
    patWard.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID']+"^"+nurTypeFlag;
    
  });
  var nurComm = Ext.getCmp('Nurse');
  nurComm.store.on("beforeload",function(){
    nurComm.store.baseParams.Name = nurComm.lastQuery;
    nurComm.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID'];
  });
	var checkt=Ext.getCmp("CheckTyp").getValue();
	
	//确定按钮
  var btnSure=Ext.getCmp("btnSure");
  btnSure.on("click",function(){
    SureCheck(Par);
    var mygrid=Ext.getCmp("mygrid");
   	mygrid.getSelectionModel().selectRow(mygrid.store.getCount()-1);
   	//添加质控项目
   	if(Par==""){CheckItem1(checkt,returnid);}
    else{CheckItem1(checkt,Par);}
  });
  if(Par != ""){
	  var ret = tkMakeServerCall('DHCMGNUR.QuCheckWard','getVal',Par);
	  var ret1 = tkMakeServerCall('DHCMGNUR.QuCheckWard','getitms1',Par);
    var ha = new Hashtable();
    var tm = ret.split('^');
	  sethashvalue(ha,tm);
  	Ext.getCmp("CheckTyp").setValue(ha.items("CheckTyp"));
 	  Ext.getCmp("CheckDate").setValue(ha.items("CheckDate"));
  	Ext.getCmp("CheckSTime").setValue(ha.items("CheckSTime"));
 	  Ext.getCmp("CheckEndTime").setValue(ha.items("CheckEndTime"));
   	if(ret1 != ""){
	    var gr = ret1.split("$");
	    var arr2 = gr[0].split("!");
	    var arr1 = gr[1].split("!");
	    for(var i = 0;i < arr1.length;i++){
	     if(arr1[i] != ""){
	     	var itm = arr1[i].split("^");
	      additmWard("mygrid3",itm[0],itm[1]);
	     }
	    }
	    for(var i = 0;i < arr2.length;i++){
	     if(arr2[i] != ""){
        var itm = arr2[i].split("^");
	      additmNurse("mygrid2",itm[0],itm[1]);
	     }
	    }
	  }
 	}
}
function CheckItem1(typ,Par)
{
	createWin(typ,Par);
}
function createWin(typ,Par)
{
	var mypanel = createNewPanel(typ);
	var win=new Ext.Window({
 		title:'质控项目',
		id:'qcWin',
		x:20,y:20,
		width:700,
		height:Height-50,
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
	var qcitmscom = Ext.getCmp('qcitemscom');
	var checkflag = -1;
	qcitmscom.on('select',function(){
		checkflag = 0;
		schQcItmSubData();
	})
	var qccustcom = Ext.getCmp('qccustomitms');
	qccustcom.on('select',function(){
		checkflag = 1;
		schQcItmSubData();	
	});
	var mygrid = Ext.getCmp('mygridt');
	mygrid.store.on('beforeload',function(){
		if(checkflag == 0){
			mygrid.store.baseParams.Par = qcitmscom.getValue();
		}else if(checkflag == 1){
			mygrid.store.baseParams.Par = qccustcom.getValue();
		}else if(checkflag == -1){
			mygrid.store.baseParams.Par = Par;
		}
		mygrid.store.baseParams.flag=checkflag;
	});
	mygrid.store.load({params:{start:0,limit:1000}});
	//保存质控项目
	var savebtn = Ext.getCmp('savemolbtn');
	savebtn.on('click',function(){saveMolData(Par,checkflag);})
}
function schQcItmSubData()
{
	var mygrid = Ext.getCmp('mygridt');
	mygrid.store.load({pramas:{start:0,limit:10000}});
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
function createNewTable()
{
	var QCItemsCom = new Ext.form.ComboBox({
		id : 'qcitemscom',
		store : new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
				url : "../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results',
				fields : [{
					'name' : 'QualDesc',
					'mapping' : 'QualDesc'
				}, {
					'name' : 'rw',
					'mapping' : 'rw'
				}]
			}),
			baseParams : {
				className : 'web.DHCMgNurQcRestruct',
				methodName : 'GetQualCode',
				type : 'RecQuery'
			}
		}),
		tabIndex : '0',
		listWidth : '220',
		height : 18,
		width : 100,
		xtype : 'combo',
		displayField : 'QualDesc',
		valueField : 'rw',
		hideTrigger : false,
		//queryParam : 'ward1',
		forceSelection : true,
		triggerAction : 'all',
		minChars : 1,
		pageSize : 10000,
		typeAhead : true,
		typeAheadDelay : 1000,
		loadingText : 'Searching...'
	});
	var QcCustomItms = new Ext.form.ComboBox({
		id : 'qccustomitms',
		store : new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
				url : "../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results',
				fields : [{
					'name' : 'modelname',
					'mapping' : 'modelname'
				}, {
					'name' : 'rw',
					'mapping' : 'rw'
				}]
			}),
			baseParams : {
				className : 'web.DHCMgNurQcRestruct',
				methodName : 'GetCusQualCode',
				type : 'RecQuery'
			}
		}),
		tabIndex : '0',
		listWidth : '220',
		height : 18,
		width : 100,
		xtype : 'combo',
		displayField : 'modelname',
		valueField : 'rw',
		hideTrigger : false,
		queryParam : 'typ',
		forceSelection : true,
		triggerAction : 'all',
		minChars : 1,
		pageSize : 10000,
		typeAhead : true,
		typeAheadDelay : 1000,
		loadingText : 'Searching...'
	});
	QcCustomItms.store.on('beforeload',function(){
		if(secGrpFlag=="hlb"||secGrpFlag=="demo"){
			QcCustomItms.store.baseParams.typ = 'H';
		}else if(secGrpFlag=="nurhead"){
			QcCustomItms.store.baseParams.typ = 'W';
		}else if(secGrpFlag=="znurhead"){
			QcCustomItms.store.baseParams.typ = 'Z';
		}
	});
	var colModelStr = new Array();
	var colData = new Array();
	colModelStr.push(new Ext.grid.RowNumberer());
	colModelStr.push({header:'序号',width:50,align:'left',sortable:false,dataIndex:'sort'});	
	colData.push({'name':'sort','mapping':'sort'});
	colModelStr.push({header:'条目',width:380,align:'left',sortable:false,dataIndex:'moldesc'});	
	colData.push({'name':'moldesc','mapping':'moldesc'});
	colModelStr.push({header:'分值',width:50,align:'left',sortable:false,dataIndex:'checkscore'});
	colData.push({'name':'checkscore','mapping':'checkscore'});
	colModelStr.push({header:'par',width:50,align:'center',hidden:true,sortable:false,dataIndex:'par'});	
	colData.push({'name':'par','mapping':'par'});
	colModelStr.push({header:'raw',width:50,align:'center',hidden:true,sortable:false,dataIndex:'raw'});	
	colData.push({'name':'raw','mapping':'raw'});
	colModelStr.push({header:'subrw',width:50,align:'center',hidden:true,sortable:false,dataIndex:'subrw'});	
	colData.push({'name':'subrw','mapping':'subrw'});
	colModelStr.push({header:'QualPar',width:50,align:'center',hidden:true,sortable:false,dataIndex:'QualPar'});	
	colData.push({'name':'QualPar','mapping':'QualPar'});
	colModelStr.push({header:'QualRaw',width:50,align:'center',hidden:true,sortable:false,dataIndex:'QualRaw'});	
	colData.push({'name':'QualRaw','mapping':'QualRaw'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{className:'web.DHCMgNurQcRestruct',methodName:'GetCustItmsSub',type:'RecQuery'}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygridt',
		x:5,y:0,
		height:Height-115,
		width:686,
		store:store,
		cm:colModel,
		tbar:['-','质控项目:',QCItemsCom,'-','自定义项目:',QcCustomItms,'-',new Ext.Button({id:'savemolbtn',text:'保存'})],
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
function saveMolData(Par,checkflag)
{

	var isExistFlag = tkMakeServerCall('Nur.CheckRoom','isExist',Par);
	if(isExistFlag==1){
		Ext.Msg.alert('提示','已经生成查房记录，禁止修改检查项目！');
		return;
	}
	var grid = Ext.getCmp('mygridt');
	//var rowObj = grid.getSelectionModel().selectAll();
	//var rowObj = grid.getSelectionModel().getSelections();
	var len = grid.store.getCount();
	if(len == 0){
		Ext.Msg.alert('提示','请选择质控模板！');
		return;
	}
	var checkqual=Ext.getCmp('qcitemscom');
	var checkcode=checkqual.getValue();
	var aa=tkMakeServerCall('DHCMGNUR.QuCheckWard','SaveCheckMoudId',checkcode,Par);
	//alert(aa)
	var ret="";
	var ret6="";
	tkMakeServerCall('DHCMGNUR.QuCheckWardChild','DelChildItms',Par);
	for(var i = 0;i < len; i++){
		var moldesc = grid.store.getAt(i).get('moldesc');
		var checkscore = grid.store.getAt(i).get('checkscore');
		var QualPar = grid.store.getAt(i).get('QualPar');
		var QualRaw = grid.store.getAt(i).get('QualRaw');
		var ModleCode = grid.store.getAt(i).get('sort');
		ret = Par + "^" + moldesc + "^" + checkscore + "^" + QualPar + "^" + QualRaw+"^"+checkflag+"^"+ModleCode;
		ret6=tkMakeServerCall('DHCMGNUR.QuCheckWardChild','SaveChildItms',ret);
	}
	if(ret6=="1"){
		alert("保存成功!");
	}else{
		alert("保存失败!");
		return;
	}
}
function getMolItmData(grid)
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
var returnid="";
function SureCheck(Par)
{
    var CheckDate = Ext.getCmp("CheckDate").getValue();
    if(!CheckDate){
    	Ext.Msg.alert('提示','请选择检查日期!');
    	return;
    }else{
    	if(CheckDate instanceof Date){
    		CheckDate = CheckDate.format('Y-m-d');
    	}
    }
    var users = getgriditm(Ext.getCmp("mygrid2"));
    if(!users){
    	Ext.Msg.alert('提示','请添加检查人员！');
    	return;
    }
    var cwards = getgriditm(Ext.getCmp("mygrid3"));
    if(!cwards){
    	Ext.Msg.alert('提示','请添加病区！');
    	return;
    }
    var CheckSTime = Ext.getCmp("CheckSTime").getValue();
    if(!CheckSTime){
    	Ext.Msg.alert('提示','请选择开始时间！');
    	return;
    }
    var CheckEndTime = Ext.getCmp("CheckEndTime").getValue();
    if(!CheckEndTime){
    	Ext.Msg.alert('提示','请选择结束时间！');
    	return;
    }
    var CheckTyp = Ext.getCmp("CheckTyp").getValue();
    if(!CheckTyp){
    	Ext.Msg.alert('提示','请选择类型！');
    	return;
    }
    var CheckLevel = "";
    if(secGrpFlag == "hlb"||secGrpFlag=="demo"){
    	CheckLevel = "H";
    }else if(secGrpFlag == "znurhead"){
    	CheckLevel = "Z";
    }else if(secGrpFlag=="nurhead"){
    	CheckLevel = "W";
    }else{
    	return;
    }
    var parr="rw|"+Par+"^CheckSTime|"+CheckSTime+"^CheckEndTime|"+CheckEndTime+"^CheckDate|"+CheckDate+"^CheckTyp|"+CheckTyp+"^CheckLevel|"+CheckLevel+"^RecUser|"+session['LOGON.USERID']; //+"^NurTyp|"+NurTyp;
 		//var Save = document.getElementById('Save');
    //var a=cspRunServerMethod(Save.value,parr,users,cwards);
    //returnid保存后记录id值
    var a = tkMakeServerCall('DHCMGNUR.QuCheckWard','Save',parr,users,cwards)
    returnid=a;
    SchQual();
    Ext.getCmp('gform2').close();
}
function SchQual() 
{
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.load({
		params:{
			start:0,
			limit:30
		}
	});
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
		width : 384,
		height : 425,
		autoScroll : true,
		layout : 'absolute',
		// plain: true,
		modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : arr
	});
	window.show();
	var but1=Ext.getCmp("mygrid4but1");
	but1.hide();
	var but1=Ext.getCmp("mygrid4but2");
  but1.setText("确定");
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
  Ext.getCmp("mygrid4").store.on("beforeload",function(){
    var hsdr=1;
    var mygrid = Ext.getCmp("mygrid4");
//    mygrid.store.baseParams.HsDr=hsdr;
//    //WardLoc.store.baseParams.typ="";
//    mygrid.store.baseParams.typ="Ward";
		var nurTypFlag = "";
		if(secGrpFlag=="demo"||secGrpFlag=="hlb"){
	  	nurTypFlag = "H";
	  }else if(secGrpFlag=="nurhead"){
	  	nurTypFlag = "W";
	  }else if(secGrpFlag=="znurhead"){
	  	nurTypFlag = "Z";
	  }else{
	  	return;
	  }
		mygrid.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID']+"^"+nurTypFlag;
  });
  setgrid3();
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
function setgrid3() 
{
	var grid1 = Ext.getCmp("mygrid4");
	grid1.store.load({
		params:{
			start:0,
			limit:30
		}
	});
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
  var count = grid.store.getCount(); 
  var r = new Plant({User:Nurse,rw:idrw}); 
  grid.store.commitChanges(); 
  grid.store.insert(count,r); 
  return;
}
function delitm(grid)
{
  grid.store.remove(grid.getSelectionModel().getSelected());
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
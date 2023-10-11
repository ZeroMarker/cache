var Width = document.body.clientWidth-5;
var Height = document.body.clientHeight-3;
var stDate=new Ext.form.DateField({
	id : 'stdate',
	format : 'Y-m-d',
	tabIndex : '0',
	height : 20,
	width : 90,
	xtype : 'datefield',
	value : new Date().getFirstDateOfMonth()
});
var edDate=new Ext.form.DateField({
	id : 'enddate',
	format : 'Y-m-d',
	tabIndex : '0',
	height : 21,
	width : 90,
	xtype : 'datefield',
	value : new Date()
});
var WardLoc=new Ext.form.ComboBox({
	id:'wardloc',
	typeAhead:true,
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
			className:'web.DHCMgNurQcRestruct',
			methodName:'FindWardLoc',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:220,
	height:18,
	width:180,
	xtype:'combo',
	displayField:'LocDes',
	valueField:'LocDr',
	hideTrigger:false,
	queryParam:'HsDr',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:10000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var checkTyp = new Ext.form.ComboBox({
	id : 'checktyp',
	tabIndex : '0',
	height : 20,
	width : 80,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : '病区',
			id : 'W'
		}, {
			desc : '科护士长',
			id : 'Z'
		}, {
			desc : '护理部',
			id : 'H'
		}],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	mode : 'local',
	triggerAction:'all',
	value : ''
});
//var QualDescS = new Ext.form.ComboBox({
//	id : 'qualdescs',
//	store : new Ext.data.Store({
//		proxy : new Ext.data.HttpProxy({
//			url : "../csp/dhc.nurse.ext.common.getdata.csp"
//		}),
//		reader : new Ext.data.JsonReader({
//			root : 'rows',
//			totalProperty : 'results',
//			fields : [{
//				'name' : 'QualDes',
//				'mapping' : 'QualDes'
//			}, {
//				'name' : 'QualDr',
//				'mapping' : 'QualDr'
//			}]
//		}),
//		baseParams : {
//			className : 'web.DHCMGCheckQuestion',
//			methodName : 'GetQualCode',
//			type : 'Query'
//		}
//	}),
//	tabIndex : '0',
//	listWidth : 220,
//	height : 18,
//	width : 100,
//	xtype : 'combo',
//	displayField : 'QualDes',
//	valueField : 'QualDr',
//	hideTrigger : false,
//	queryParam : 'HsDr',
//	forceSelection : true,
//	triggerAction : 'all',
//	minChars : 1,
//	pageSize : 20,
//	typeAhead : false,
//	typeAheadDelay : 1000,
//	loadingText : 'Searching...'
//});
//问题来源
var QualDescS = new Ext.form.ComboBox({
	id : 'qualdescs',
	tabIndex : '0',
	height : 20,
	width : 80,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : '夜查房',
			id : "NIGHTCHK"
		},{
			desc : '随机督查',
			id : 'DAYCHK'	
		},{
			desc : '质控检查',
			id : 'QUALCHECK'
		}, {
			desc : '病区自查',
			id : 'QUALSELFCHECK'
		}],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	triggerAction:'all',
	mode : 'local',
	value : ''
});
var statusS = new Ext.form.ComboBox({
	id : 'statuss',
	tabIndex : '0',
	height : 20,
	width : 80,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : '待处理',
			id : '1'
		}, {
			desc : '处理中',
			id : '2'
		}, {
			desc : '已解决',
			id : '3'
		}
		,{
			desc : '问题上诉',
			id : '4'
		}
		],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	triggerAction:'all',
	mode : 'local',
	value : ''
});
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	var mygridpl = Ext.getCmp('mygridpl');
	mygridpl.setWidth(Width);
	mygridpl.setHeight(Height);
	var mygrid = Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	//mygrid.store.sort("CheckDate","ASC");
	//增加颜色控制
	mygrid.getColumnModel( ).setRenderer(5,function(value){
		if(value=="待处理"){
			return "<span style='color:#CD2626;font-weight:bold;'>待处理</span>";
		}else if(value=="已解决"){
			return "<span style='color:green;font-weight:bold;'>已解决</span>";
		}else if(value=="处理中"){
			return "<span style='color:#CDCD00;font-weight:bold;'>处理中</span>";
		}else if(value=="问题上诉"){
			return "<span style='color:#8B8386;font-weight:bold;'>问题上诉</span>";
		}
	});
	var tobar = new Ext.Toolbar({});
	tobar.addItem('-','检查日期:',stDate);
	tobar.addItem('-','截止日期:',edDate);
	tobar.addItem('-','检查级别:',checkTyp);
	tobar.addItem('-','状态:',statusS);
	var tobar2 = new Ext.Toolbar({});
	tobar2.addItem('-','检查病区:',WardLoc);
	tobar2.addItem('-','问题来源',QualDescS);
	tobar2.addItem("-"); 
	tobar2.addButton({
		text: '查询',
		icon:'../image/light/search.png',
		handler:function(){SchQual();},
		id:'btnsch'
	});
	tobar2.addItem('-'); 
	tobar2.addButton({
		text: 'Excel',
		handler:function(){exportFn();},
		icon:'../Image/icons/application_put.png',
		id:'btnexport'
	});
	mygrid.getBottomToolbar().hide();
	setBottomTool(mygrid,30);
	tobar.render(mygrid.tbar);
	tobar2.render(mygrid.tbar);
	var chkTyp = "";
	if(secGrpFlag == "hlb"){
		chkTyp = "H";
	}else if(secGrpFlag == "znurhead"){
		chkTyp = "Z";
	}else if(secGrpFlag == "nurhead"){
		chkTyp = "W";
	}else{
		chkTyp = "";
	}
	WardLoc.store.on('beforeload',function() {
		var laststr1 = WardLoc.lastQuery
		if (laststr1 != undefined)
			WardLoc.store.baseParams.ward = laststr1;
		WardLoc.store.baseParams.HsDr = 1;
		WardLoc.store.baseParams.nurtype = secGrpFlag+"^"+session['LOGON.USERID']+"^"+chkTyp;
	});
	mygrid.store.on('beforeload',function(){
		var stdate = Ext.getCmp('stdate').getValue();
		if(stdate){
			if(stdate instanceof Date){
				stdate = stdate.format('Y-m-d');
			}
		}
		var eddate = Ext.getCmp('enddate').getValue();
		if(eddate){
			if(eddate instanceof Date){
				eddate = eddate.format('Y-m-d');
			}
		}
		//病区
	 	var ward = Ext.getCmp('wardloc').getValue();
	 	//质控项目dr  
	 	var Code = Ext.getCmp('qualdescs').getValue();
	 	//检查类型
	 	var Typ = Ext.getCmp('checktyp').getValue();
	 	//状态
	 	var Status = Ext.getCmp('statuss').getValue();
	 	var Question = Ext.getCmp('qualdescs').getValue();
	 	mygrid.store.baseParams.Type = Typ;
	 	mygrid.store.baseParams.CheckCode = Code;
	  mygrid.store.baseParams.WardLoc = ward;
	  mygrid.store.baseParams.SEDate = stdate + "^" + eddate
	  mygrid.store.baseParams.Statu = Status;
	  mygrid.store.baseParams.question = Question;
  });
  var len=mygrid.getColumnModel().getColumnCount()
  for(var i=0;i<len;i++){
		if(mygrid.getColumnModel().getDataIndex(i)=="ReMark"){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}
	mygrid.on('rowdblclick',function(){ModCheck();});
	if(secGrpFlag=="nurse"){
		WardLoc.store.load({params:{start:0,limit:5000},callback:function(){
			WardLoc.setValue(session['LOGON.CTLOCID']);
		}});
		WardLoc.disable();
	}
}
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
function SchQual()
{
	var ward = Ext.getCmp('wardloc').getValue();
	if((secGrpFlag == "nurhead" || secGrpFlag == "znurhead" || secGrpFlag == "nurse")&&(!ward)){
		Ext.Msg.alert('提示','检查病区不能为空！');
		return;
	}
	var mygrid = Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:30}});
}
function ModCheck()
{
	var grid = Ext.getCmp('mygrid');
	var rowObj = grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var Par = rowObj[0].get('rw');
	var QualTyp = rowObj[0].get('QualTyp');
	
//	var Qreason = rowObj[0].get("Question");
//	var ReMark = rowObj[0].get("ReMark");
//	if((Qreason!="")&&(ReMark=="")) {Qreason="问题:"+Qreason}
//	if((Qreason!="")&&(ReMark!="")) {Qreason="问题:"+Qreason+"  备注:"+ReMark}
//	if((Qreason=="")&&(ReMark!="")) {Qreason="备注:"+ReMark}
//	var Status=rowObj[0].get("Status");
	Check(Par,QualTyp);
}
function Check(Par,QualTyp)
{
	var questionData = tkMakeServerCall('web.DHCMGCheckQuestion','getQuestionsData',Par,QualTyp);
	var arr = new Array();
	var a = cspRunServerMethod(pdata1,"","DHCMGNurCheckSumLR","","");
	arr = eval(a);
	var b=new Ext.BoxComponent({			
		xtype:'box',
		pressed:true,
		x:460,y:50,
		height:'220px',
		width:'260px',
		handler:function(){Ext.MessageBox.alert("nnnn");},
		autoEl:{
			tag:'img',
			src:''
		}
	});		
	var box1=new Ext.BoxComponent({
		xtype:'box',
		id:'imgBox',
		x:560,
		y:40, 
		autoShow:true,
		style: 'margin-top:4px',
		width: '260px',
		height: '220px',
		fileUpload:true,	    
		autoEl: {
			tag: 'img',  
			id:'imgsrc', 
			src: '../images/dhcpe/yylogo.bmp'            
		},
		listeners: {
			'beforerender': function(){} 
    },
		renderTo:Ext.getBody()
	});
	var StatDesc=new Ext.form.Label({
		id:'StatDesc',
		height:20,
		width:50,
		x:620,
		y:535,
		text:'处理状态'
	});
	var StatType = new Ext.form.ComboBox({
		id : 'statType',
		tabIndex : '0',
		height : 20,
		width : 80,
		x:670,
		y:525,
		renderTo:Ext.getBody(),
		xtype : 'combo',
		store : new Ext.data.JsonStore({
			data : [{
				desc:'待处理',
				id:'1'	
			},{
				desc:'已处理',
				id:'2'	
			},{
				desc : '已解决',
				id : '3'
			},{
				desc : '问题上诉',
				id : '4'
			}],
			fields : ['desc', 'id']
		}),
		displayField : 'desc',
		valueField : 'id',
		allowBlank : true,
		mode : 'local',
		triggerAction:'all',
		value : ''
	});
	window1 = new Ext.Window({
		title : '质控问题改进',
		id : 'gform2',
		x:10,y:2,
		width : 970,
		height : 600,
		autoScroll : true,
		layout : 'absolute',
		items : [arr,box1,StatDesc,StatType]
	});
	window1.show();
	
	if((secGrpFlag != "hlb")&&(secGrpFlag != "hlbzr")&&(secGrpFlag != "demo")){
		Ext.getCmp("Praise").disable();
	}
	if(secGrpFlag == "nurse"){
		Ext.getCmp('butSave').hide();
	}
	Ext.getCmp('SButton').hide();
	var butup = Ext.getCmp("upimg");
	var butdown = Ext.getCmp("downimg");
	butup.hide();
	butdown.hide();
	Ext.getCmp('Question').setValue(questionData);
	var but1 = Ext.getCmp("butSave");
	but1.on('click',function(){Save(Par,QualTyp);});
	var but2 = Ext.getCmp("Read");
	but2.on('click',function(){Readed(Par,QualTyp);});
	var getRecDate = tkMakeServerCall('web.DHCMGCheckQuestion','getVal',Par,QualTyp);
	//var ret = getRecDate.replace(/_n/g,"\n\r");
  if(getRecDate!=""){
  	var array = getRecDate.split('^');
  	Ext.getCmp("Reason").setValue(array[0]);
  	Ext.getCmp("Method").setValue(array[1]);
  	Ext.getCmp("Goal").setValue(array[2]);
  	Ext.getCmp("Praise").setValue(array[3]);
  	Ext.getCmp("HRead").setValue(array[5]);	
  	Ext.getCmp("ReasonNurse").setValue(array[6]);
  	Ext.getCmp("ReasonPat").setValue(array[7]);
  	Ext.getCmp("ReasonEnv").setValue(array[8]);
  	Ext.getCmp("ReasonEpu").setValue(array[9]);
  	Ext.getCmp("ReasonThings").setValue(array [10]);
  }
  var statuFlag = tkMakeServerCall('web.DHCMGCheckQuestion','getStatus',Par,QualTyp);
  Ext.getCmp('statType').setValue(statuFlag);
  
}
function Readed(checkid,QualTyp)
{
	var username = session['LOGON.USERNAME']
	var a = tkMakeServerCall('Nur.NurCheckSumLR','ReadSave',username,checkid,QualTyp);
	if(a!=""){
		alert("已浏览");
	}
	Ext.getCmp('gform2').close();
	SchQual();
}
function Save(Par,QualTyp)
{
	//alert("Par==="+Par+"%"+"QualTyp===="+QualTyp);
	var Reasona = Ext.getCmp("Reason").getValue();
	var Methoda = Ext.getCmp("Method").getValue();
	var Goala = Ext.getCmp("Goal").getValue();
	var Praisea = Ext.getCmp("Praise").getValue();
	ReasonNursea = Ext.getCmp("ReasonNurse").getValue();
	ReasonPata = Ext.getCmp("ReasonPat").getValue();
	ReasonEnva = Ext.getCmp("ReasonEnv").getValue();
	ReasonEpua = Ext.getCmp("ReasonEpu").getValue();
	ReasonThingsa = Ext.getCmp("ReasonThings").getValue();
	var stateType = Ext.getCmp('statType').getValue();
	if(!stateType){
		Ext.Msg.alert('提示','请选择处理状态！');
		return;
	}
	var parr = Reasona + "^" + Methoda + "^" + Goala + "^" + Praisea + "^" + "" + "^" + ReasonNursea + "^" + ReasonPata + "^" + ReasonEnva + "^" + ReasonEpua + "^" + ReasonThingsa;
	
	if(secGrpFlag=="nurhead"||secGrpFlag=="znurhead"){
		if(stateType=="3"){
			var Praise = Ext.getCmp('Praise').getValue();
			if(!Praise){
				Ext.Msg.alert('提示','权限不足！请选择其他处理状态!');
				return;
			}
		}
		tkMakeServerCall('Nur.NurCheckSumLR','Save',parr,Par,QualTyp,stateType);
	}else if(secGrpFlag=="demo"||secGrpFlag=="hlb"){
		tkMakeServerCall('Nur.NurCheckSumLR','SaveQuestions',Par,QualTyp,stateType,Praisea);
	}
	Ext.getCmp('gform2').close();
	SchQual();
	
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
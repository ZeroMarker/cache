var Height = document.body.clientHeight;
var Width = document.body.clientWidth;
var stdate=new Ext.form.DateField({
	name : 'StDate',
	id : 'StDate',
	//format : 'Y-m-d',
	tabIndex : '0',
//	height : 20,
//	width : 90,
	xtype : 'datefield',
	value : new Date().add(Date.DAY,-7)
});
var eddate=new Ext.form.DateField({
	name : 'EndDate',
	id : 'EndDate',
	//format : 'Y-m-d',
	tabIndex : '0',
//	height : 21,
//	width : 90,
	xtype : 'datefield',
	value : new Date()
});
var WardLoc = new Ext.form.ComboBox({
	name : 'WardLoc',
	id : 'WardLoc',
	typeAhead:true,
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'LocDes',
				'mapping' : 'LocDes'
			}, {
				'name' : 'LocDr',
				'mapping' : 'LocDr'
			}]
		}),
		baseParams : {
			className : 'web.DHCMgNurQcRestruct',
			methodName : 'FindWardLoc',
			type : 'Query'
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
	//tabIndex : '0',,web.DHCMgNurSysComm
	listWidth : 200,
//	height : 18,
	width : 185,
	xtype : 'combo',
	displayField : 'LocDes',
	valueField : 'LocDr',
	hideTrigger : false,
	queryParam : 'HsDr',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
var question=new Ext.form.TextField({
	name : 'QuestionS',
	id : 'QuestionS',
	tabIndex : '0',
	//height : 21,
	width : 130,
	xtype : 'textfield',
	value : ""
});
var QualDescS = new Ext.form.ComboBox({
	name : 'QualDescS',
	id : 'QualDescS',
	tabIndex : '0',
	width : 200,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : '夜查房',
			id : 'NightChk'
		}, {
			desc : '随机督查',
			id : 'DayChk'
		}, {
			desc : '病房质控',
			id : 'Check'
		}],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	mode : 'local',
	value : ''
});
/* var QualDescS = new Ext.form.ComboBox({
	name : 'QualDescS',
	id : 'QualDescS',
	typeAhead:true,
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'QualDes',
				'mapping' : 'QualDes'
			}, {
				'name' : 'QualDr',
				'mapping' : 'QualDr'
			}]
		}),
		baseParams : {
			className : 'web.DHCMGCheckQuestion',
			methodName : 'GetQualCode',
			type : 'Query'
		}
	}),
	//tabIndex : '0',
	listWidth : 200,
//	height : 18,
	width : 200,
	xtype : 'combo',
	displayField : 'QualDes',
	valueField : 'QualDr',
	hideTrigger : false,
	queryParam : 'HsDr',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : true,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
}); */
var checktyp = new Ext.form.ComboBox({
	name : 'CheckTyp',
	id : 'CheckTyp',
	tabIndex : '0',
	//height : 20,
	width : 80,
	xtype : 'combo',
	store : new Ext.data.JsonStore({
		data : [{
			desc : '护士长',
			id : 'Nur'
		}, {
			desc : '大科护士长',
			id : 'LocNur'
		}, {
			desc : '护理部',
			id : 'MasterNur'
		}],
		fields : ['desc', 'id']
	}),
	displayField : 'desc',
	valueField : 'id',
	allowBlank : true,
	mode : 'local',
	value : ''
});
var StatusS = new Ext.form.ComboBox({
	name : 'StatusS',
	id : 'StatusS',
	tabIndex : '0',
	//height : 20,
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
	value : ''
});
//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler() {
	var myGridPl = Ext.getCmp('mygridpl');
	myGridPl.setWidth(Width-1);
	myGridPl.setHeight(Height-2);
	var grid = Ext.getCmp('mygrid');
	//增加颜色控制
//	grid.colModel.setHidden(4,true);
//	grid.colModel.setHidden(6,true);
//	grid.colModel.setHidden(7,true);
	grid.getColumnModel( ).setRenderer(5,function(value){
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
	grid.on("rowdblclick",function(){ModCheck();});

	var mydate = new Date();
	var tobar = grid.getTopToolbar();
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.hide();
	var loctyp=Ext.getCmp("LocTyp");
	var SortPos=Ext.getCmp("SortPos");
	var gform=Ext.getCmp("gform");
  tobar.addItem("-","检查日期",stdate);
	tobar.addItem("-",eddate);
	tobar.addItem("-","检查类型",checktyp);
	//tobar.addItem("-","检查病区:",WardLoc);
	tobar.addItem("-","状态",StatusS);
	tobar.addItem("-","问题",question);
  tobar1=new Ext.Toolbar({});	
  tobar1.addItem("-","检查病区",WardLoc);
	tobar1.addItem("-","检查方式",QualDescS);
	
	//tobar1.addItem("-","状态:",StatusS);
	tobar1.addItem("-"); 
	tobar1.addButton({
		//className: 'new-topic-button', 
		text: "查询",
		icon:'../images/uiimages/search.png',
		handler:function(){SchQual2();},
		id:'btnSch'
	});
	tobar1.addItem("-");
	tobar1.addButton({
		//className: 'new-topic-button', 
		text: "基础分析",
		icon:'../images/uiimages/read.png',
		handler:function(){QualDA();},
		id:'btnDA',
		hidden:true
	});
  tobar1.addButton({
	    //className: 'new-topic-button', 
		text: "导出",
		handler:function(){exportFn();},
		icon:'../images/uiimages/redo.png',
		id:'btnExport'
	});
	grid.getBottomToolbar().hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:30,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tobar1.render(grid.tbar);
	tobar.doLayout();	
	/* WardLoc.store.on("beforeLoad",function(){
  		 var laststr1=WardLoc.lastQuery
       if (laststr1!=undefined)
       WardLoc.store.baseParams.ward=laststr1;
       //alert(WardLoc.store.baseParams.ward)
       WardLoc.store.baseParams.HsDr=1;
       WardLoc.store.baseParams.typ="Ward";
  }); */
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
  var mygrid = Ext.getCmp("mygrid");
  mygrid.store.on("beforeload",function(){
  	var stdate=Ext.getCmp("StDate").getValue();
		if(!stdate){
			Ext.Msg.alert('提示','检查开始日期不能为空！');
			return;
		}else{
			if(stdate instanceof Date){
				stdate = stdate.format('Y-m-d');
			}
		}
		var eddate=Ext.getCmp("EndDate").getValue();
		if(!eddate){
			Ext.Msg.alert('提示','检查结束日期不能为空！');
			return;
		}else{
			if(eddate instanceof Date){
				eddate = eddate.format('Y-m-d');	
			}
		}
		//病区
	 	var ward=Ext.getCmp("WardLoc").getValue();
	 	//质控项目dr   qual1
	 	var Code=Ext.getCmp("QualDescS").getValue();
	 	//检查类型
	 	var Typ=Ext.getCmp("CheckTyp").getValue();
	 	//状态
	 	var Status=Ext.getCmp("StatusS").getValue();
	 	var Question=Ext.getCmp("QuestionS").getValue();
    //var mygrid = Ext.getCmp("mygrid");
    mygrid.store.baseParams.WardLoc=ward;
    //mygrid.store.baseParams.QualDr=;
    mygrid.store.baseParams.CheckCode=Code;
    mygrid.store.baseParams.Type=Typ;
    mygrid.store.baseParams.Statu=Status;
    mygrid.store.baseParams.question=Question;
		mygrid.store.baseParams.SEDate=stdate+"^"+eddate;
  });
	SchQual();
	var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'CheckTyp'){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i) == 'ReMark'){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
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
function SchQual()
{
	var mygrid = Ext.getCmp("mygrid");
 	var chktyp=Ext.getCmp("CheckTyp").getValue();
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function SchQual2()
{
	var mygrid = Ext.getCmp("mygrid");
 	var chktyp=Ext.getCmp("CheckTyp").getValue();
	if(chktyp==""){
		alert("请选择检查类型!");
		return;
	}
	mygrid.store.load({
		params : {
			start : 0,
			limit : 30
		}
	});
}
function SumAverage(){}

var oArcSize=1
function mStart(){
	var oImg = document.all('oImg');
	oImg.style.filter = 'Progid:DXImageTransform.Microsoft.BasicImage(Rotation='+ oArcSize +')';
	oArcSize += 1;
	oArcSize = oArcSize==4 ? 0 : oArcSize ;
}
function ModCheck()
{
  var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");
	var stateTyp=rowObj[0].get("Status");
	CheckValue = new Hashtable();
  CheckReason = new Hashtable();
	var Qreason = rowObj[0].get("Question");
	var ReMark = rowObj[0].get("ReMark");
	if((Qreason!="")&&(ReMark=="")) {Qreason="问题:"+Qreason}
	if((Qreason!="")&&(ReMark!="")) {Qreason="问题:"+Qreason+"  备注:"+ReMark}
	if((Qreason=="")&&(ReMark!="")) {Qreason="备注:"+ReMark}
	var CheckTyp = rowObj[0].get("CheckTyp");
	Check(Qreason,Par,CheckTyp,stateTyp);
}
var imagenum=0
var sum=0
function Check(Qreason,Par,CheckTyp,stateTyp){
	var arr = new Array();
	var a = cspRunServerMethod(pdata1, "", "DHCMGNurCheckSumLR", "", "");
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
		// disabled:true,
		width: '260px', //图片宽度   
		height: '220px', //图片高度
		fileUpload:true,		    
		autoEl: {
			tag: 'img',    //指定为img标签  
			id:'imgsrc', 
			src: '../images/dhcpe/yylogo.bmp'   //指定url路径	            
		},
		listeners: {
			'beforerender': function () {
      } 
    },
		renderTo:Ext.getBody()
	});
	var statTypFlag=new Ext.form.Label({
			text:'状态',
			id:'statTypFlag',
			x:550,
			y:519,
			width:40,
			height:20
	});	
	var StatType = new Ext.form.ComboBox({
		name : 'StatType',
		id : 'statType',
		tabIndex : '0',
		height : 20,
		width : 80,
		x:585,
		y:515,
		renderTo:Ext.getBody(),
		xtype : 'combo',
		store : new Ext.data.JsonStore({
			data : [{
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
		value : ''
	});
	window1 = new Ext.Window({
		title : '质控问题改进',
		id : "gform2",
		x:10,y:2,
		width : 960,
		height : 600,
		autoScroll : true,
		layout : 'absolute',
		modal:true,
		resizable:false,
		// plain: true,
		// modal: true,
		// bodyStyle: 'padding:5px;',
		// /buttonAlign: 'center',
		items : [arr,box1,statTypFlag,StatType]
	});
window1.show();
sum=0
imagenum=0
//权限控制-------
//	if((session['LOGON.GROUPDESC']!="护理部")&&(session['LOGON.GROUPDESC']!="护理部主任")&&(session['LOGON.GROUPDESC']!="Demo Group"))
	//alert(secGrpFlag)
	if((secGrpFlag!="hlb")&&(secGrpFlag!="hlbzr")&&(secGrpFlag!="demo"))	
	{
		Ext.getCmp("Praise").disable()
		//Ext.getCmp("Opinion").disable()
	}
//---------
	var but1 = Ext.getCmp("butSave");
	but1.setIcon('../images/uiimages/filesave.png');
	but1.on('click',function(){
		var stateType=Ext.getCmp('statType').getValue();
		Save(Par,CheckTyp,stateType);
		window1.close();
		SchQual()
	});//,window1.close()
	var but2 = Ext.getCmp("Read");
	but2.setIcon('../images/uiimages/see.png');
	but2.on('click',function(){Readed(Par,CheckTyp)});
	var SButton = Ext.getCmp("SButton");
	SButton.on('click',function(){
		var windowImage = new Ext.Window({
			title : '图片操作',
			hidden:true,
			id : "gform5",
			x:10,
			y:2,
			width : 850,
			height : 600,    
			autoScroll : true,
			layout : 'absolute',
			items : [{
		  	html:'<html><div align="center"><img id="oImg" src='+Ext.getCmp("imgBox").getEl().dom.src+'  onDblClick="mStart();"></div></html>'
              //autoLoad: {url:Ext.getCmp("imgBox").getEl().dom.src}  ///style="position:relative; zoom:100%; cursor:move;"
      }]
		});
		windowImage.show();
	});
//	window1.show();
	Ext.getCmp('SButton').hide();
  var getPatNurInfo = document.getElementById('getPatNurInfo');
	var PatEpsiId=cspRunServerMethod(getPatNurInfo.value,Par,CheckTyp);
	if(Qreason!=""){
		Ext.getCmp("Question").setValue(Qreason+PatEpsiId);
	}
	var getVal = document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,Par,CheckTyp);
	ret=ret.replace(/_n/g,"\n\r");
  var arr=ret.split('^');
  //alert(ret)
  if(ret!=""){
  	Ext.getCmp("Reason").setValue(arr[0]);
  	Ext.getCmp("Method").setValue(arr[1]);
  	Ext.getCmp("Goal").setValue(arr[2]);
  	Ext.getCmp("Praise").setValue(arr[3]);
  	//Ext.getCmp("Opinion").setValue(arr[4]);
  	Ext.getCmp("HRead").setValue(arr[5]);
  	Ext.getCmp("ReasonNurse").setValue(arr[6]);
  	Ext.getCmp("ReasonPat").setValue(arr[7]);
  	Ext.getCmp("ReasonEnv").setValue(arr[8]);
  	Ext.getCmp("ReasonEpu").setValue(arr[9]);
  	Ext.getCmp("ReasonThings").setValue(arr[10]);
  	//alert(arr[6])
  	//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/117/117_2013925113244.jpg";
  }
   if(stateTyp=="已解决"||stateTyp=="问题上诉"){
    	Ext.getCmp("statType").setRawValue(stateTyp);
    }   
  //获取图片地址
  if ((CheckTyp=="NIGHTCHK")||(CheckTyp=="DAYCHK")){
 	  var butup = Ext.getCmp("upimg");
		butup.on('click',function(){ upimage()});
		var butdown = Ext.getCmp("downimg");
		butdown.on('click',function(){ downimage()});
		//alert(imagenum)
    var getImages = document.getElementById('getImages');
    //alert(Par+"!"+CheckTyp)
	  var ret=cspRunServerMethod(getImages.value,Par,CheckTyp);
	  var arr=ret.split(';');
	  //alert(arr)
	  if(arr==""){
   		Ext.getCmp("imgBox").getEl().dom.src="../images/dhcpe/yylogo.bmp";	     		
   		butup.hide();
   		butdown.hide();
   	}
		else{
			if(arr.length==1){
     		///此处需要进一步完善
     	//	Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('_')[0]+"/"+arr[0]+".jpg";
     	  butup.hide();
     		butdown.hide();
			}
	    if(arr.length>1)
	    {
     		sum=arr.length-1
     		butup.disable();
     	  // Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('_')[0]+"/"+arr[0]+".jpg";
     	  Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('_')[0]+"/"+arr[0]+".jpg";
     		//alert(Ext.getCmp("imgBox").getEl().dom.src)
	    }
		}
	}
	//病房质控-----------------------------
 	if ((CheckTyp=="QualCheck")||(CheckTyp=="QUALCHECK")||(CheckTyp.indexOf("QUAL")!=-1))
 	{
 	  var butup = Ext.getCmp("upimg");
		butup.on('click',function(){ upimage1()});
		var butdown = Ext.getCmp("downimg");
		butdown.on('click',function(){ downimage1()});
  	var getImages = document.getElementById('getImages');
   	var ret=cspRunServerMethod(getImages.value,Par,CheckTyp);
   	var arr=ret.split(';');
   	if(arr==""){
   		Ext.getCmp("imgBox").getEl().dom.src="../images/dhcpe/yylogo.bmp";	     		
   		butup.hide();
   		butdown.hide();
   	}else{
   		if(arr.length==1){
   			//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('^')[0]+"/"+arr[0].split('^')[1].split('_')[0]+"/"+arr[0]+".jpg";
   	  	butup.hide();
   			butdown.hide();
			}
   		if(arr.length>1){
   			sum=arr.length-1
   			butup.disable();
   	  	// Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[0].split('^')[0]+"/"+arr[0].split('^')[1].split('_')[0]+"/"+arr[0]+".jpg";
   		}
		}
 	}
  if (Par!=""){/*
		   var getVal = document.getElementById('getVal');
	     var ret=cspRunServerMethod(getVal.value,Par);
        var arr=ret.split('^');
        //alert(ret)
        cmbitm.add("CheckWard","ward");
        cmbitm.add("CheckUser","nur");
   	    comboload1(Ext.getCmp("CheckWard"),arr[1]);
  	    comboload1(Ext.getCmp("CheckUser"),arr[3]);
  	    Ext.getCmp("CheckScore").setValue(arr[2]);
  	    //Ext.getCmp("CheckDate").value=arr[0];
  	    Ext.getCmp("CheckPat").setValue(arr[4]);
				Ext.getCmp("CheckDate").setValue(arr[0]);
  	    //alert(Ext.getCmp("CheckDate").value)CheckPat
  	    Ext.getCmp("CheckDate").disable(); 
  	    Ext.getCmp("CheckWard").disable(); 
  	    Ext.getCmp("CheckUser").disable();
  	    setqualitmdata(Par);//初始化扣分值，与扣分原因
  	    */
 	}
function upimage()
{
	if(imagenum>0) {
		imagenum--;	
		butdown.enable();
	}
	Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('_')[0]+"/"+arr[imagenum]+".jpg";
	if(imagenum==0) {
		butup.disable();
	}
}
function downimage()
{
	if(imagenum<sum) {
		imagenum++;
		butup.enable();
	}
	Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('_')[0]+"/"+arr[imagenum]+".jpg";
	if(imagenum==sum){
		//alert(1)
		butdown.disable();
	}
}
//病房质控
function upimage1()
{
	if(imagenum>0) {
		imagenum--;	
		butdown.enable();
	}    		
	Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('^')[0]+"/"+arr[imagenum].split('^')[1].split('_')[0]+"/"+arr[imagenum]+".jpg";
	if(imagenum==0) {
		butup.disable();
	}
}
function downimage1()
{
	if(imagenum<sum) {
		imagenum++;
		butup.enable();
	}
	Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('^')[0]+"/"+arr[imagenum].split('^')[1].split('_')[0]+"/"+arr[imagenum]+".jpg";
//Ext.getCmp("imgBox").getEl().dom.src="http://192.192.10.122/uploadimg/Images/"+arr[imagenum].split('_')[0]+"/"+arr[imagenum]+".jpg";
	if(imagenum==sum){
		butdown.disable();
	}
}
}
function Save(checkid,CheckTyp,stateType)
{
	Reasona=Ext.getCmp("Reason").getValue()
	Methoda=Ext.getCmp("Method").getValue()
	Goala=Ext.getCmp("Goal").getValue()
	Praisea=Ext.getCmp("Praise").getValue()
	//Opiniona=Ext.getCmp("Opinion").getValue()
	//Reasona=Ext.getCmp("Reason").getValue()
	ReasonNursea=Ext.getCmp("ReasonNurse").getValue()
	ReasonPata=Ext.getCmp("ReasonPat").getValue()
	ReasonEnva=Ext.getCmp("ReasonEnv").getValue()
	ReasonEpua=Ext.getCmp("ReasonEpu").getValue()
	ReasonThingsa=Ext.getCmp("ReasonThings").getValue()
	//var parr=Reasona+"^"+Methoda+"^"+Goala+"^"+Praisea+"^"+Opiniona+"^"+ReasonNursea+"^"+ReasonPata+"^"+ReasonEnva+"^"+ReasonEpua+"^"+ReasonThingsa
	var parr=Reasona+"^"+Methoda+"^"+Goala+"^"+Praisea+"^"+""+"^"+ReasonNursea+"^"+ReasonPata+"^"+ReasonEnva+"^"+ReasonEpua+"^"+ReasonThingsa
	var SaveCheck=document.getElementById('SaveCheckSum');
	//var stateType=Ext.getCmp('statType').getValue();
	if(stateType==""){
		stateType="2";
	}
	var a=cspRunServerMethod(SaveCheck.value,parr,checkid,CheckTyp,stateType);
}
function Readed(checkid,CheckTyp)
{
	var username=session['LOGON.USERNAME']
	var ReadSave=document.getElementById('ReadSave');
	//alert(username+"^^"+checkid+"^^"+CheckTyp)
	var a=cspRunServerMethod(ReadSave.value,username,checkid,CheckTyp);
	if(a!=""){
		Ext.Msg.alert('提示',"已浏览");
		var getVal = document.getElementById('getVal');
		var ret=cspRunServerMethod(getVal.value,checkid,CheckTyp);
		ret=ret.replace(/_n/g,"\n\r");
		var arr=ret.split('^');
		Ext.getCmp("HRead").setValue(arr[5]);
	}
}
//病区问题汇总   基础分析  图表部分
function QualDA(){
	Ext.chart.Chart.CHART_URL = '../ext-3.1.1/resources/charts.swf';
	//var stdate=Ext.getCmp("StDate").value;
  //var eddate=Ext.getCmp("EndDate").value;
	var stdate=Ext.getCmp("StDate").getValue();
	var edDate=Ext.getCmp("EndDate").getValue();
	var TypDCode=Ext.getCmp("QualDescS").getValue();
	var DA3Title="";
	switch(TypDCode){
		case 'Qual1':
		DA3Title="病房护理管理";
		break;
		case 'Qual2':
		DA3Title="分级护理";
		break;
		case 'Qual3':
		DA3Title="护理文件书写";
		break;
		case 'Qual4':
		DA3Title="临床科室消毒隔离";
		break;
		case 'Qual5':
		DA3Title="危重病人护理";
		break;
	}
	var storeDA1=new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		//autoLoad:true,
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'score',
				'mapping' : 'score'
			}]
		}),
		baseParams : {
			className : 'web.DHCNurHGDA',
			methodName : 'ProblemOfProportion',
			type : 'Query'
		}
	});
	storeDA1.on('beforeload',function(){
		storeDA1.baseParams.startDate=stdate;
		storeDA1.baseParams.endDate=edDate;
		storeDA1.baseParams.typ='NightChk';
	});	
	storeDA1.load({
		params : {
			start : 0,
			limit : 20
		}
	});	
			
	var storeDA2=new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		//autoLoad:true,
		sortInfo:{
			 field: 'score',
			 direction:'ASC'
		},
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'score',
				'mapping' : 'score'
			}]
		}),
		baseParams : {
			className : 'web.DHCNurHGDA',
			methodName : 'ProblemOfWardPoint',
			type : 'Query'
		}
	});
	storeDA2.on('beforeload',function(){
		storeDA2.baseParams.startDate=stdate;
		storeDA2.baseParams.endDate=edDate;
		storeDA2.baseParams.typ='NightChk';
	});
	storeDA2.load({
		params : {
			start : 0,
			limit : 20
		}
	});	
	var storeDA3=new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		//autoLoad:true,
		sortInfo:{
			field: 'score',
			direction:'ASC'
		},
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'desc',
				'mapping' : 'desc'
			}, {
				'name' : 'score',
				'mapping' : 'score'
			}]
		}),
		baseParams : {
			className : 'web.DHCMGCheckQuestion',
			methodName : 'CheckQuesSum2',
			type : 'Query'
		}
	});
	storeDA3.on('beforeload',function(){
		storeDA3.baseParams.STDate=stdate;
		storeDA3.baseParams.SEDate=edDate;
		storeDA3.baseParams.RealTypeCode=TypDCode;
		storeDA3.baseParams.typ=TypDCode;
	});	
	storeDA3.load({
		params : {
			start : 0,
			limit : 20
		}
	});
  var panelDA=new Ext.Panel({
    width: 400,
    height: 400,
    title: '夜查房出现问题占比',
    autoScroll:true,
    renderTo:windowDA ,
    items: {
      store:storeDA1,
      xtype: 'piechart',
      id:'piechartss',
      dataField: 'score',
      categoryField: 'desc',
      //extra styles get applied to the chart defaults
      extraStyle:
      {
        legend:
        {
          display: 'bottom',
          padding: 5,
          font:
          {
            family: 'Tahoma',
            size: 13
          }
        }
      }
    }
  });
  var panelDA2=new Ext.Panel({
    width: 400,
    height: 400,
    title: '夜查房科室扣分占比',
    x:450,
    renderTo:windowDA ,
    items: {
      store:storeDA2,
      xtype: 'piechart',
      //id:'piechartss',
      dataField: 'score',
      categoryField: 'desc',
      //extra styles get applied to the chart defaults
      extraStyle:
      {
        legend:
        {
          display: 'bottom',
          padding: 5,
          font:
          {
            family: 'Tahoma',
            size: 13
          }
        }
      }
    }
  });
	var panelDA3=new Ext.Panel({
     width: 400,
     height: 400,
     title: '科室'+DA3Title+'数据扣分占比',
     y:450,
     renderTo:windowDA ,
     items: {
       store:storeDA3,
       xtype: 'piechart',
       //id:'piechartss',
       dataField: 'score',
       categoryField: 'desc',
       //extra styles get applied to the chart defaults
       extraStyle:
       {
         legend:
         {
           display: 'bottom',
           padding: 5,
           font:
           {
             family: 'Tahoma',
             size: 13
           }
         }
       }
     }
  });
	var windowDA = new Ext.Window({
		title : '分析',
		id : "gform4",
		x:10,
		y:2,
		width : 1000,
		height : 1000,     //690,
		autoScroll : true,
		layout : 'absolute',
		items : [panelDA,panelDA2,panelDA3]
	});
	windowDA.show();			
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
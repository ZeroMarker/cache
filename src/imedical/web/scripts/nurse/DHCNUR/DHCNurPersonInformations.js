/*
Ext.onReady(
function(){
	BodyLoadHandler();
	}
);
*/
var fheight = document.body.offsetHeight;
var fwidth = document.body.offsetWidth;
var Height = document.body.clientHeight;
var Width = document.body.clientWidth-2;
//查询出生日期
var AgeStDate=new Ext.form.DateField({
	name:'AgeStDate',
	id:"AgeStDate",
	//format:'Y-m-d',
	xtype:'datefield',
	listeners:{
		select:function(dateField,date){
			var ageStDate=Ext.getCmp('AgeEndDate').getValue();
			if(ageStDate!=""){
				var flag=date.between(date,ageStDate);
				if(!flag){
					Ext.Msg.alert('提示',"开始时间不能大于结束时间！");
				  AgeStDate.setValue("");
				}				
			}
		}
	}
});
var AgeEndDate=new Ext.form.DateField({
	name:'AgeEndDate',
	id:'AgeEndDate',
	//format:'Y-m-d',
	xtype:'datefield',
	listeners:{
		select:function(dateField,date){
			var ageStDate=Ext.getCmp('AgeStDate').getValue();
			if(ageStDate!=""){
				var flag=date.between(ageStDate,date);
				if(!flag){
					Ext.Msg.alert('提示',"开始时间不能大于结束时间！");
					AgeEndDate.setValue("");	
				}
			}
		}
	}
});
//学历
var comboBoxSchAge=new Ext.form.ComboBox({
	name:'comboBoxSchAge',
	id:'comboBoxSchAge',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'SchoolAgeDr',
				'mapping':'SchoolAgeDr'
			},{
				'name':'raw',
				'mapping':'raw'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'FindPersonSchoolAgeDr',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:200,
	//height:18,
	width:80,
	xtype : 'combo',
	displayField : 'SchoolAgeDr',
	valueField : 'raw',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
});
//聘任职称
var comboboxAppDuty=new Ext.form.ComboBox({
	name:'comboboxAppDuty',
	id:'comboboxAppDuty',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'resutls',
			fields:[{
				'name':'AppDutyDR',
				'mapping':'AppDutyDR'
			},{
				'name':'raw',
				'mapping':'raw'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'FindPersonAppDutyDR',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:200,
//	height:18,
//	width:80,
	xtype : 'combo',
	displayField : 'AppDutyDR',
	valueField : 'raw',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 20,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
})
//护士种类
var comboboxNurTyp=new Ext.form.ComboBox({
	name:'comboboxNurTyp',
	id:'comboboxNurTyp',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'NurTyp',
				'mapping':'NurTyp'
			},{
				'name':'raw',
				'mapping':'raw'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'FindPersonNurTyp',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:200,
//	height:18,
//	width:90,
	xtype:'combo',
	displayField:'NurTyp',
	valueField:'raw',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
})
//鞋号
var comboboxShoeNo=new Ext.form.ComboBox({
	name:'comboboxShoeNo',
	id:'comboboxShoeNo',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'ShoeNO',
				'mapping':'ShoeNO'
			},{
				'name':'raw',
				'mapping':'raw'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'FindPersonShoeNO',
			type:'Query'
		}
	}),
	//tabIndex : '0',
	listWidth : 400,
//	height : 18,
//	width : 50,
	xtype : 'combo',
	displayField : 'ShoeNO',
	valueField : 'raw',
	hideTrigger : false,
	queryParam : 'typ',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
})
//护士层级
var comboboxBattery=new Ext.form.ComboBox({
		name:'comboboxBattery',
		id:'comboboxBattery',
		store:new Ext.data.Store({
			proxy:new Ext.data.HttpProxy({
				url:"../csp/dhc.nurse.ext.common.getdata.csp"
			}),
			reader:new Ext.data.JsonReader({
				root:'rows',
				totalProperty:'results',
				fields:[{
					'name':'Battery',
					'mapping':'Battery'
				},{
					'name':'raw',
					'mapping':'raw'
				}]
			}),
			baseParams:{
				className:'web.DHCMgNurPerHRComm',
				methodName:'FindPersonBattery',
				type:'Query'
			}
		}),
		//tabIndex : '0',
		listWidth : 200,
//		height : 18,
//		width : 50,
		xtype : 'combo',
		displayField : 'Battery',
		valueField : 'raw',
		hideTrigger : false,
		queryParam : 'typ',
		forceSelection : true,
		triggerAction : 'all',
		minChars : 1,
		pageSize : 10,
		typeAhead : false,
		typeAheadDelay : 1000,
		loadingText : 'Searching...'
})
//护理单元
var comboboxDep = new Ext.form.ComboBox({
	name : 'comboboxDep',
	id : 'comboboxDep',
	store : new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : "../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader : new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : 'results',
			fields : [{
				'name' : 'ctlocDesc',
				'mapping' : 'ctlocDesc'
			}, {
				'name' : 'CtLocDr',
				'mapping' : 'CtLocDr'
			}]
		}),
		baseParams : {
			className : 'web.DHCMgNurPerHRComm',
			methodName : 'SearchComboDep',
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
	//tabIndex : '0',
	listWidth : 300,
//	height : 18,
//	width : 150,
	xtype : 'combo',
	displayField : 'ctlocDesc',
	valueField : 'CtLocDr',
	hideTrigger : false,
	queryParam : 'ward1',
	forceSelection : true,
	triggerAction : 'all',
	minChars : 1,
	pageSize : 10,
	typeAhead : false,
	typeAheadDelay : 1000,
	loadingText : 'Searching...'
	
});
//大科
var LarLocCom=new Ext.form.ComboBox({
	name:'LarLocCom',
	id:'LarLocCom',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'LocDesc',
				'mapping':'LocDesc'
			},{
				'name':'LocId',
				'mapping':'LocId'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'SearchLarLocCom',
			type:'Query'
		}
	}),
	//tabIndex:'0',
	listWidth:190,
//	height:18,
//	width:120,
	xtype:'combo',
	displayField:'LocDesc',
	valueField:'LocId',
	hideTrigger:false,
	//queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:20,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var pname=new Ext.form.TextField({
	width:80,
	id:'PName',
	xtype:'textfield'
});
var nurseNameLab = new Ext.form.Label({
	id:'nurnamelabel',
	xtype:'label',
	//style:{marginLeft:45},
	text:'姓名'	
});
//姓名
var nurseName=new Ext.form.TextField({
	width:100,
	//style:{marginLeft:1},
//	height:16,
	id:'nurseName',
	xtype:'textfield'
});
//判断安全组
	var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
	//alert(secGrpFlag)
function BodyLoadHandler()
{ 
  //setsize("mygridpl","gform","mygrid");
  var gridPl = Ext.getCmp('mygridpl');
  gridPl.setWidth(Width);
  gridPl.setHeight(Height);
  ///2013.11.22 修改 添加下拉框事件
	var comboboxDepStore=Ext.getCmp('comboboxDep').getStore();
	comboboxDepStore.load({params:{start:0,limit:2000}});
  var getNurseDep=document.getElementById('getnursedep');
  var retdep=cspRunServerMethod(getNurseDep.value,session['LOGON.USERCODE']);
  var hata = new Hashtable();
  var ta=retdep.split('^')
  sethashvalue(hata,ta);
  var gridpl = Ext.getCmp('mygridpl');
  gridpl.setWidth(Width);
  gridpl.setHeight(Height);
  var grid = Ext.getCmp('mygrid');
  grid.colModel.setHidden(47,true);
  grid.colModel.setHidden(48,true);
  var tobar=grid.getTopToolbar();   
  var getVal=document.getElementById('getVal');  
	var but1=Ext.getCmp("mygridbut1"); 	
	but1.hide();
  var but=Ext.getCmp("mygridbut2");
	but.hide();
	//tobar.addItem("-","人员",checktyp);
	if(secGrpFlag=="hlb"||secGrpFlag=="demo"||(secGrpFlag=="hlbzr")){
		tobar.addItem('-','大科',LarLocCom);
	}
	tobar.addItem("-","护理单元",comboboxDep);
	tobar.addItem("-","工号",pname);
	var tbar2=new Ext.Toolbar({});
	tbar2.addItem("-")
	tbar2.addButton({
		text:'增加',
		handler:function(){addNew();},
		id:'addNewbtn',
		hidden:true,
		icon:'../images/uiimages/edit_add.png'
	});
	tbar2.addItem("-")
  tbar2.addButton({
		text: "编辑",
		handler:function(){ModCheck();},
		//id:'mygridbutAllSave',
		id:'editBtn',
		hidden:true,
		icon:'../images/uiimages/pencil.png'
	});
	tbar2.addItem("-")
	tbar2.addButton({
		text:"查询",
		hidden:true,
		icon:'../images/uiimages/search.png',
		handler:function(){
			if(secGrpFlag=="hlb"||secGrpFlag=="hlbzr"||secGrpFlag=="demo"){
				SchQual();
			}
			else if (session['LOGON.USERCODE']==Ext.getCmp('PName').getValue()){
				SchQual(Ext.getCmp('PName').getValue());
			}
			else if(secGrpFlag=="nurhead") //&&(Ext.getCmp("comboboxDep").getValue()==session['LOGON.CTLOCID']))
			{
				SchQual();
			}
			else if((secGrpFlag=="nurhead")&&(Ext.getCmp("comboboxDep").getValue()==session['LOGON.CTLOCID'])&&((Ext.getCmp("PName").getValue())||(Ext.getCmp("comboboxBattery").getValue())||(Ext.getCmp("comboboxNurTyp").getValue())||(Ext.getCmp("comboboxAppDuty").getValue())))
			{
				SchQual()
			}
			else if(secGrpFlag=="znurhead"){
				SchQual();
			}
		},
		id:'btnSch'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'查看人员信息',
		handler:function(){infSearch();},
		id:'btnSearch',
		hidden:true,
		icon:'../images/uiimages/doctor.png'
	});
	//tbar2.addItem("-");
	tbar2.addButton({
		text:"临时调换科室",
		handler:function(){TranDep();},
		id:'btnSch1',
		hidden:true,
		icon:'../images/uiimages/blue_arrow.png'
	});
	tbar2.addItem("-")
	tbar2.addButton({
		text:'调科',
		handler:function(){longTranDep();},
		id:'longTranBtn',
		hidden:true,
		icon:'../images/uiimages/blue_arrow.png'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'审核',
		handler:function(){editAudite();},
		id:'unAuditeBtn',
		hidden:true,
		icon:'../images/uiimages/ok.png'
	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'<font color=red> 个人信息填报说明</font>',
		id:'fileLoad',
		icon:'../images/uiimages/help.png',
		handler:function(){fileLoad();}
	});
//维护完后取消 添加来院时间
//	tbar2.addItem("-");
//	tbar2.addButton({
//		id:'btnAdmHosDate',
//		text:'<font color=green>添加来院时间</font>',
//		handler:function(){addAdmHosDate();}
//	});
	tbar2.addItem("-");
	tbar2.addButton({
		text:'导入',
		handler:exportRec,
		id:'exportBtn',
		hidden:true
		//icon:'../Image/light/accept.png'
	});
//	tbar2.addItem(new Ext.form.Label({width:200}));
//	tbar2.addItem('<img src="../images/uiimages/ok.png">','已审核');
//	tbar2.addItem('<img src="../images/uiimages/cancel.png">','未审核');
	
	var contextmenu=new Ext.menu.Menu({
		id:'theContextMenu',
 		items:[{
 			text:'撤销审核',
		icon:'../images/uiimages/undo.png',
   		iconCls:'revoke',
   		handler:function(){
   			revokeAudite();
   		}
  	}]
	});
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
	//******************************// 以下是安全组判断
	//添加安全组判断
	//var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
	//alert(secGrpFlag)
//	if(secGrpFlag=="hlb"||secGrpFlag=="demo"){//护理部安全组
//		
//	}else if(secGrpFlag=="znurhead"){//总护士长安全组
//		
//	}else if(secGrpFlag=="nurhead"){//护士长安全组
//		
//	}else if(secGrpFlag=="nurse"){//护士安全组
//		
//	}else if(secGrpFlag==0){
//		
//	}
	//**************************
	//通过判断安全组添加工具控件
	if((secGrpFlag=="hlb")||(secGrpFlag=="demo")||(secGrpFlag=="hlbzr")||(secGrpFlag=="znurhead")||(secGrpFlag=="nurhead")){
		tobar.addItem("-",nurseNameLab,nurseName);
		var tbar3=new Ext.Toolbar({});
		tbar3.addItem("-","层级",comboboxBattery);
		//tobar.addItem("-","护士种类",comboboxNurTyp);
		//tobar.addItem("-","鞋号",comboboxShoeNo);
		tbar3.addItem("-","聘任职称",comboboxAppDuty);
		tbar3.addItem("-","学历",comboBoxSchAge);
		
		//tbar3.addItem("-","出生时间段");
		tbar3.addItem("-","出生时间段",AgeStDate);
		tbar3.addItem("-",AgeEndDate);
		tbar3.render(grid.tbar);
		//右键事件
		grid.on('rowcontextmenu',function(grid,rowIndex,e){
			var selections = grid.getSelectionModel().getSelections();
			if(selections.length==0){
				//Ext.Msg.alert('提示','请选择一行！');
				return;
			}else{
				if(selections[0].get("PersonFlag")==1){
					e.preventDefault();
	 				grid.getSelectionModel().selectRow(rowIndex);
	 				contextmenu.showAt(e.getXY());
				}else if(selections[0].get("PersonFlag")==0){
					e.preventDefault();
	 				grid.getSelectionModel().selectRow(rowIndex);
	 				contextmenu.hide();
	 				//contextmenu.showAt(e.getXY());
				};
			}
		});
	}else{
		tobar.addItem("-","姓名",nurseName);
		nurseName.setValue(hata.items("perNurName"));
		nurseName.disable();
		comboboxDep.disable();
		comboboxBattery.disable();
	}
	var bbar = grid.getBottomToolbar ();
	bbar.hide();
	var bbar2 = new Ext.PagingToolbar({
		pageSize:20,
		store:grid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	bbar2.render(grid.bbar);
	tbar2.render(grid.tbar);
	tobar.doLayout();
	//setsize("mygridpl", "gform", "mygrid",0);
	comboboxAppDuty.store.on("beforeLoad",function(){
	 	comboboxAppDuty.store.baseParams.typ="";
	})
	if(secGrpFlag!="hlb"){	
		comboboxDep.store.on("beforeload",function(){
    	var pward=comboboxDep.lastQuery;
			//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
			var nurseString=session['LOGON.USERID']+"^"+secGrpFlag;
      comboboxDep.store.baseParams.typ="1";
      comboboxDep.store.baseParams.ward1=pward;        
 			comboboxDep.store.baseParams.nurseid=nurseString;
    });
	}
	var mygrid = Ext.getCmp("mygrid");
	mygrid.store.on("beforeLoad",function(){
		var mygrid = Ext.getCmp("mygrid");
		var largeLoc=Ext.getCmp('LarLocCom').getValue();
	 	var ppname=Ext.getCmp('PName').getValue();
	 	var nurseName=Ext.getCmp('nurseName').getValue();
	 	var perdep=Ext.getCmp("comboboxDep").getValue();
		var comboboxBattery=Ext.getCmp("comboboxBattery").getValue();
	 	var comboboxShoeNo=Ext.getCmp("comboboxShoeNo").getValue();
	 	var comboboxNurTyp=Ext.getCmp("comboboxNurTyp").getValue();
	 	var comboboxAppDuty=Ext.getCmp("comboboxAppDuty").getValue();
	 	var comboBoxSchAge=Ext.getCmp("comboBoxSchAge").getValue();
	 	var AgeStDate=Ext.getCmp("AgeStDate").getValue();
	 	if(AgeStDate!=""){
	 		var AgeStString=AgeStDate.format('Y-m-d');	 		
	 	}else{
	 		var AgeStString=""; 		
	 	}	 	
	 	var AgeEndDate=Ext.getCmp("AgeEndDate").getValue();
	 	if(AgeEndDate!=""){
	 		var AgeEndString=AgeEndDate.format('Y-m-d');
	 	}else{
	 			var AgeEndString="";			
	 	}
	 	//原始var pstring=perdep+"^"+ppname+"^"+comboboxBattery+"^"+comboboxShoeNo+"^"+comboboxNurTyp+"^"+comboboxAppDuty+"^"+comboBoxSchAge+"^"+AgeStString+"^"+AgeEndString+"^"+nurseName+"^"+largeLoc+"^"+session['LOGON.GROUPDESC']+"^"+session['LOGON.USERID'];
	  var pstring=perdep+"^"+ppname+"^"+comboboxBattery+"^"+comboboxShoeNo+"^"+comboboxNurTyp+"^"+comboboxAppDuty+"^"+comboBoxSchAge+"^"+AgeStString+"^"+AgeEndString+"^"+nurseName+"^"+largeLoc+"^"+secGrpFlag+"^"+session['LOGON.USERID'];
	 	
	 	mygrid.store.baseParams.parr=pstring;
  });    
  var gform=Ext.getCmp('gform');
	grid.on('dblclick',gblClick);
	//通过判断安全组 设置查询
	if(secGrpFlag=="hlb"||secGrpFlag=="demo"){//护理部或者demo安全组
		SchQual("");
		comboboxDep.store.on('beforeLoad',function(){
				var pward=comboboxDep.lastQuery;
				//原始var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+LarLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+LarLocCom.getValue();
	 			comboboxDep.store.baseParams.typ="1";
	 			comboboxDep.store.baseParams.ward1=pward;        
				comboboxDep.store.baseParams.nurseid=nurseString;
		});
		comboboxDep.addListener('click',function(){
			comboboxDep.store.load({params:{start:0,limit:1000}})
			comboboxDep.store.on('beforeLoad',function(){
				var pward=comboboxDep.lastQuery;
				//原始var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+LarLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+LarLocCom.getValue();
	 			comboboxDep.store.baseParams.typ="1";
	 			comboboxDep.store.baseParams.ward1=pward;        
				comboboxDep.store.baseParams.nurseid=nurseString;
			});
		})
		LarLocCom.addListener('blur',function(){
			comboboxDep.setValue('');
			comboboxDep.store.load({params:{start:0,limit:10}})
				comboboxDep.store.on('beforeLoad',function(){
				var pward=comboboxDep.lastQuery;
				//原始var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+LarLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+LarLocCom.getValue();
	 			comboboxDep.store.baseParams.typ="1";
	 			comboboxDep.store.baseParams.ward1=pward;        
				comboboxDep.store.baseParams.nurseid=nurseString;
			});
		})
		LarLocCom.addListener('focus',function(){
			comboboxDep.store.on('beforeLoad',function(){
				var pward=comboboxDep.lastQuery;
				//原始var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+LarLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+LarLocCom.getValue();
	 			comboboxDep.store.baseParams.typ="1";
	 			comboboxDep.store.baseParams.ward1=pward;        
				comboboxDep.store.baseParams.nurseid=nurseString;
			});
			LarLocCom.on('select',function(combo,record,index){
				comboboxDep.setValue('');
				//comboboxDep.store.load({params:{start:0,limit:10}});
				SchQual();
			})
		})
	}else if(secGrpFlag=="nurhead"){
		//comboboxDep.disable();
		var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
		comboboxDepStore.load({params:{start:0,limit:1000},callback:function(){
			Ext.getCmp("comboboxDep").setValue(hata.items('perNurDep'));	
		}});
	}else if(secGrpFlag=="nurse"){//护士安全组
		comboboxDep.disable();
		var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
		comboboxDepStore.load({params:{start:0,limit:1000},callback:function(){
			Ext.getCmp("comboboxDep").setValue(hata.items('perNurDep'));
		}});
		pname.setValue(session['LOGON.USERCODE']);
		pname.disable();
		SchQual(session['LOGON.USERCODE']);
	}else if(secGrpFlag=="znurhead"){//总护士长安全组
		comboboxDep.setEditable(false);
		var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
		comboboxDepStore.load({params:{start:0,limit:1000},callback:function(){
			Ext.getCmp("comboboxDep").selectText();
			//Ext.getCmp("comboboxDep").setValue(session['LOGON.CTLOCID']);
		}});
	}
	
}
function fileLoad()
{
  window.open ('../scripts/nurse/help/关于填写护理人员档案的几点说明.htm','人力资源填报说明','top=90,left=210,height=450,width=768,toolbar=no,menubar=no,scrollbars=yes, resizable=yes,location=no, status=no');
}
//维护完后取消
function addAdmHosDate()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择一条记录！");
		return;
	}	
	var Par = rowObj[0].get("rw");
	var personName=rowObj[0].get("PersonName");
	var personId=rowObj[0].get("PersonID");
	var AdmHosDate=new Ext.form.DateField({
		name:'AdmHosDate',
		id:"AdmHosDate",
		format:'Y-m-d',
		width:100,
		xtype:'datefield',
		x:90,y:80
		//items:[{fieldLabel: '来院时间'}]
	});
	var nameLabel=new Ext.form.Label({
		id:'nameLabel',
		text:'姓名:',
		x:20,y:18
	});
 var nameField=new Ext.form.TextField({
		id:'nameField',
		width:100,
		x:90,y:15,
		height:21,
		xtype:'textfiled'
	});
	var pNoLabel=new Ext.form.Label({
		id:'pNoLabel',
		text:'工号:',
		x:20,y:50
	});
	var pNoField=new Ext.form.TextField({
		id:'pNoField',
		width:100,
		x:90,y:47,
		xtype:'textfiled'
	});
	var timeLabel=new Ext.form.Label({
		id:'timeLabel',
		text:'来院时间:',
		width:80,
		x:20,y:85
	});
	var btnAddSureDate= new Ext.Button({
		id:'btnAddSureDate',
		text:'确定',
		width:60,
		x:120,y:120
		//handler:function(){addFunDate();}
	});
	var btnAddCancle= new Ext.Button({
		id:'btnAddCancle',
		text:'取消',
		width:60,
		x:40,y:120,
		handler:function(){window.close();}
	});
	var window= new Ext.Window({		
		title : '添加来院时间',
		id : "winAddHosDate",
		x:300,y:200,
		width : 230,
		height : 200,
		autoScroll : true,
		layout : 'absolute',
		items : [pNoLabel,pNoField,nameLabel,nameField,btnAddCancle,btnAddSureDate,timeLabel,AdmHosDate]
	});	
	Ext.getCmp('nameField').setValue(personName);
	Ext.getCmp('nameField').disabled=true;
	Ext.getCmp('pNoField').setValue(personId);
	Ext.getCmp('pNoField').disabled=true;
	window.show();
	btnAddSureDate.on('click',function(){addFunDate(Par);})
}
function addFunDate(str)
{
	var dateTime=document.getElementById('AdmHosDate').value;
	
	if(!dateTime){alert("来院时间不能为空！");return;}
	//alert(dateTime)
	var SaveHosDate=document.getElementById('SaveHosDate');
	//alert(SaveHosDate);
	var ret=cspRunServerMethod(SaveHosDate.value,dateTime+"^"+str);
	//var win1=document.getElementById('winAddHosDate');
	var win1=Ext.getCmp('winAddHosDate');
	if(win1!=null){win1.close();}
	SchQual();
}
function infSearch()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");	
	var getVal = document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,Par);
  var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1, "", "DHCNurPersonInformationAdd", "", "");
	arr = eval(a);
	var box1=new Ext.BoxComponent({
		xtype:'box',
		id:'imgBox',
		x:5,
		y:60, 
		autoShow:true,
		style: 'margin-top:4px',
		// disabled:true,
		width: '110px', //图片宽度   
		height: '140px', //图片高度
		fileUpload:true,		    
		autoEl: {
			tag: 'img',    //指定为img标签  
		  id:'imgsrc', 
		  src: '../../web/images/222349.png'   //指定url路径	            
		},
		listeners: {
      'beforerender': function () {} 
    },
		renderTo:Ext.getBody()
	});		
	var window= new Ext.Window({		
		title : '查看护理人员信息',
		id : "gform2",
		x:10,y:20,
		width : 768,
		height : 512,
		autoScroll : true,
		layout : 'absolute',
		items : [arr,box1],
		modal:true,
		resizable:false
	});	
	/*
	if(ha.items("PersonFlag")==1){
		var btnSave=Ext.getCmp("btSave");
		btnSave.hide();
		alert("已审核，不能修改!");
		return;
	}	
	*/
	Ext.getCmp('PersonDepDR').store.on("beforeLoad",function(){
  	var wardstore=Ext.getCmp('PersonDepDR').store;
  	var str=Ext.getCmp("PersonDepDR").lastQuery
 		wardstore.baseParams.ward=str; 
  });	
   //加载comobox
	window.items.each(function(item,index,length){
	 	if(item.getXType()=="combo"){
	 		//if((item.getId()=="PersonSexDR")||(item.getId()=="Personmarriage")||(item.getId()=="PersonWorkType")){
	 		if(item.mode=="local"){
	 			if(ha.items(item.getId())!=""){
	 				if(item.getId()&&(Ext.getCmp(item.getId()))){
	 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()).replace("__","||"));
	 				}
	 			}
	 			item.triggerAction='all';
	 		}else{
		 		Ext.getCmp(item.getId()).store.load({params:{start:0,limit:2000},callback:function(){
		 			if(ha.items(item.getId())!=""){
		 				if(item.getId()&&(Ext.getCmp(item.getId()))){
		 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()).replace("__","||"));
		 				}
		 			}
		 		}})
		 	}
		 	item.typeAhead='false';
		 	item.disable();
	 	}
	 	if(item.getXType()=="datefield"){
		 	if(ha.items(item.getId())){
		 		if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));	
				}
			}
			item.disable();
		}
		if(item.getXType()=="textfield"){
			if(ha.items(item.getId())){
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
				}
			}
			item.disable();
		}
		if(item.getXType()=='box'){
			if(item.getId()&&(Ext.getCmp(item.getId()))){
				Ext.getCmp("imgBox").getEl().dom.src=ha.items("PersonImage");
			}
		}
	})
	if(ha.items("PersonPrefQual")){
		Ext.getCmp('PersonPrefQualFlag_1').setValue(true);
	}else{
		Ext.getCmp('PersonPrefQualFlag_1').checked=false;
		Ext.getCmp("PersonPrefQual").disable();
		Ext.getCmp("PersonPrefQualDate").disable();
	}
	var personPrefQualFlag=Ext.getCmp("PersonPrefQualFlag_1");
	personPrefQualFlag.disable();
	personPrefQualFlag.on('check',function(personPrefQualFlag,checked){
		if(checked==true){
			var PersonPrefQualFlag="1";
			var personPrefQual=Ext.getCmp("PersonPrefQual");
  		//if(secGrpFlag!="hlb"){personPrefQual.setEditable(false);}
  		personPrefQual.enable();
  	 	var personProfPostDRStore=Ext.getCmp("PersonProfPostDR").getStore();
		 	personProfPostDRStore.load({params:{start:0,limit:50}});
		 	var PersonProfPostDR=Ext.getCmp("PersonProfPostDR").getValue();
		 	var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
		 	personPrefQualDate.enable();	
		}else{
			var PersonPrefQualFlag="0";
  		var personPrefQual=Ext.getCmp("PersonPrefQual");
  		//personPrefQual.setEditable(false);  		
  		personPrefQual.clearValue();
  		personPrefQual.disable();
  		var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
  		personPrefQualDate.setValue("");
		 	personPrefQualDate.disable();
		}
	})
	Ext.getCmp("imgBox").getEl().dom.src=ha.items("PersonImage");
	Ext.getCmp('PersonAdmHosDate').setValue(ha.items("PersonAdmHosDate"));
	window.show();
	var btnClear=Ext.getCmp('btnClear');
	btnClear.hide()
	var btnSave=Ext.getCmp("btSave");
	btnSave.hide();
	var btnUpload=Ext.getCmp("UpLoadImg");
	btnUpload.hide();
	
}
//撤销审核
function revokeAudite(Par)
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	var Par = rowObj[0].get("rw");	
	var revokeFlag="0";
	var parr=Par+"^"+revokeFlag;
	var revokeSave=document.getElementById('revokeSave');
	if (confirm('确定撤销审核选中的项？')) {
	  var a=cspRunServerMethod(revokeSave.value,parr);
	  SchQual();
	}
}
///审核窗口
function editAudite()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}	
	var Par = rowObj[0].get("rw");	
	var getVal = document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,Par);
	//alert(ret)
  var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);	
	var aa=cspRunServerMethod(pdata1,"","DHCNurPersonInformationAdd","","");
	var arr=eval(aa);
	var box1=new Ext.BoxComponent({
		xtype:'box',
		id:'imgBox',
		x:5,y:60, 
		autoShow:true,
		style: 'margin-top:4px',
		// disabled:true,
		width: '110px', //图片宽度   
		height: '140px', //图片高度
		fileUpload:true,		    
		autoEl: {
			tag: 'img',    //指定为img标签  
		  id:'imgsrc', 
		  src: '../../web/images/222349.png'   //指定url路径	            
		},
		listeners: {
      'beforerender': function () {
      	//alert('ooooo'); 
    	} 
    },
		renderTo:Ext.getBody()
	});	
	var window= new Ext.Window({		
		title : '审核人员信息',
		id : "gform2",
		x:10,y:20,
		width : 768,
		height : 500,
		autoScroll : true,
		layout : 'absolute',
		items : [arr,box1],
		modal:true,
		resizable:false
	});
	if(ha.items("PersonFlag")==1){
		var btnSave=Ext.getCmp("btSave");
		btnSave.hide();
		Ext.Msg.alert('提示',"已审核，不能重复审核!");
		return;
	}	
	Ext.getCmp('PersonDepDR').store.on("beforeLoad",function(){
		var wardstore=Ext.getCmp('PersonDepDR').store;
  	var str=Ext.getCmp("PersonDepDR").lastQuery
 		wardstore.baseParams.ward=str; 
  });	
   //加载comobox
	window.items.each(function(item,index,length){
	 	if(item.getXType()=="combo"){
	 		//if((item.getId()=="PersonSexDR")||(item.getId()=="Personmarriage")||(item.getId()=="PersonWorkType")){
	 		if(item.mode=="local"){
	 			if(ha.items(item.getId())!=""){
	 				if(item.getId()&&(Ext.getCmp(item.getId()))){
	 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()).replace("__","||"));
	 				}
	 			}
	 			item.triggerAction='all';
	 		}else{
		 		Ext.getCmp(item.getId()).store.load({params:{start:0,limit:2000},callback:function(){
		 			if(ha.items(item.getId())!=""){
		 				if(item.getId()&&(Ext.getCmp(item.getId()))){
		 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()).replace("__","||"));
		 				}
		 			}
		 		}})
		 	}
		 	item.typeAhead='false';
		 	item.disable();
	 	}
	 	if(item.getXType()=="datefield"){
		 	if(ha.items(item.getId())){
		 		if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));	
				}
			}
			item.disable();
		}
		if(item.getXType()=="textfield"){
			if(ha.items(item.getId())){
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
				}
			}
			item.disable();
		}
		if(item.getXType()=='box'){
			if(item.getId()&&(Ext.getCmp(item.getId()))){
				Ext.getCmp("imgBox").getEl().dom.src=ha.items("PersonImage");
			}
		}
	})
	if(ha.items("PersonPrefQual")){
		Ext.getCmp('PersonPrefQualFlag_1').setValue(true);
	}else{
		Ext.getCmp('PersonPrefQualFlag_1').checked=false;
		Ext.getCmp("PersonPrefQual").disable();
		Ext.getCmp("PersonPrefQualDate").disable();
	}
	var personPrefQualFlag=Ext.getCmp("PersonPrefQualFlag_1");
	personPrefQualFlag.disable();
	personPrefQualFlag.on('check',function(personPrefQualFlag,checked){
		if(checked==true){
			var PersonPrefQualFlag="1";
			var personPrefQual=Ext.getCmp("PersonPrefQual");
  		//if(secGrpFlag!="hlb"){personPrefQual.setEditable(false);}
  		personPrefQual.enable();
  	 	var personProfPostDRStore=Ext.getCmp("PersonProfPostDR").getStore();
		 	personProfPostDRStore.load({params:{start:0,limit:50}});
		 	var PersonProfPostDR=Ext.getCmp("PersonProfPostDR").getValue();
		 	var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
		 	personPrefQualDate.enable();	
		}else{
			var PersonPrefQualFlag="0";
  		var personPrefQual=Ext.getCmp("PersonPrefQual");
  		//personPrefQual.setEditable(false);  		
  		personPrefQual.clearValue();
  		personPrefQual.disable();
  		var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
  		personPrefQualDate.setValue("");
		 	personPrefQualDate.disable();
		}
	})

  Ext.getCmp("imgBox").getEl().dom.src=ha.items("PersonImage");
  Ext.getCmp('PersonAdmHosDate').setValue(ha.items("PersonAdmHosDate"));
	Ext.getCmp("UpLoadImg").hide();
	window.show();
	var btnClear=Ext.getCmp('btnClear');
	btnClear.hide()
	var btnSave=Ext.getCmp("btSave");
	btnSave.setIcon('../images/uiimages/ok.png')
	btnSave.setText("确认审核");
	btnSave.on("click",function(){VerifySure(Par);window.close();alert("审核完毕！");SchQual();});	
}
///审核
function VerifySure(Par)
{
	var verFlag="1";
	var parr=Par+"^"+verFlag;
	var VerSave = document.getElementById('VerSave');
	var a=cspRunServerMethod(VerSave.value,parr);	
}
//长期调科
function longTranDep()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择需要调科人员！");
		return;
	}
	var Par = rowObj[0].get("rw");
	var  getCurrentDep = document.getElementById('getCurrentDep');
	var ret=cspRunServerMethod(getCurrentDep.value,Par);	
	var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a=cspRunServerMethod(pdata1,"","DHCNURPerExchangeAdd","","");
	arr=eval(a);
	var win=new Ext.Window({
		title:'调换科室',
		id:"gformtran",
		x:100,y:200,
		width:340,
		height:340,
		modal:true,
		resizable:false,
		autoScroll:true,
		layout:'absolute',
		items:arr
	});
	Ext.getCmp('PersonDepDR').store.on('beforeload',function(){
   	var wardstore=Ext.getCmp('PersonDepDR').store;
   	var str=Ext.getCmp("PersonDepDR").lastQuery
 		wardstore.baseParams.ward=str; 
  });	
	var CurrentDep=Ext.getCmp("PersonDepDR1");
	CurrentDep.disabled=true;
	var personName=Ext.getCmp("PersonName")
	personName.disabled=true;
	var personID=Ext.getCmp("PersonID")
	personID.disabled=true;
	CurrentDep.setValue(ha.items("PerCurrentDep"));
	personName.setValue(ha.items("PersonName"));
	personID.setValue(ha.items("PersonID"))
	var StDate=Ext.getCmp("PerTranStDate")
	StDate.setValue(new Date());
	/*
	var StTime=Ext.getCmp("PerTranStTime");
	var datetime=new Date();
	if(datetime.getMinutes()<10){
		var Minutes="0"+datetime.getMinutes().toString();
		StTime.setValue(datetime.getHours()+":"+Minutes);
	}else{
		StTime.setValue(datetime.getHours()+":"+datetime.getMinutes());		
	}
	*/
	var btnSave=Ext.getCmp("btnSave");
	btnSave.setIcon('../images/uiimages/ok.png');
	btnSave.hide();
	win.show();
	var btnSave1=Ext.getCmp("btnSave1");
	btnSave1.setIcon('../images/uiimages/ok.png');
	btnSave1.on("click",function(){makeSure1(Par);});
}
function makeSure1(Par)
{
	var personName=Ext.getCmp("PersonName").getValue();
	var personID=Ext.getCmp("PersonID").getValue();
	var personDepDR=Ext.getCmp("PersonDepDR").getValue();
	if(personDepDR==""){
		Ext.Msg.alert('提示','请选择需要更换的护理单元！');
		return;
	}
	var StDate=Ext.getCmp("PerTranStDate").getValue();
	if(StDate==""){Ext.Msg.alert('提示',"请输入开始日期！");return;}
	if(StDate instanceof Date){
		StDate=StDate.format('Y-m-d');
		var StDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",StDate);
			var PersonAdmHos=tkMakeServerCall("web.DHCMgNurSchComm","getPersonAdmHosDate",Par);
			if(StDate1<PersonAdmHos){
				Ext.Msg.alert('提示',"开始日期不能小于来院时间！");
				return;
			}
	}
	//var StTime=Ext.getCmp("PerTranStTime").value;
	//if(StTime==""){alert("请输入开始时间！");return;}
	var tranCurrent="Y";
	var tranFlag="0"
	var parm=personName+"^"+personID+"^"+"^"+Par+"^"+personDepDR+"^"+StDate+"^"+"^"+tranCurrent+"^"+tranFlag;
	//alert(parm);
	var SaveLongTranDep = document.getElementById('SaveLongTranDep');
	var a=cspRunServerMethod(SaveLongTranDep.value,parm);
	Ext.getCmp('gformtran').close();
	SchQual();
}
//临时调科
function TranDep()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		alert("请选择需要调科人员！");
		return;
	}
	var Par = rowObj[0].get("rw");
	var  getCurrentDep = document.getElementById('getCurrentDep');
	var ret=cspRunServerMethod(getCurrentDep.value,Par);
	var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a=cspRunServerMethod(pdata1,"","DHCNURPerExchangeAdd","","");
	arr=eval(a);
	var win=new Ext.Window({
		title:'临时调换科室',
		id:"gformtran",
		x:100,y:200,
		width:340,
		height:340,
		autoScroll:true,
		layout:'absolute',
		items:arr
	});
	Ext.getCmp('PersonDepDR').store.on("beforeLoad",function(){
  	var wardstore=Ext.getCmp('PersonDepDR').store;
   	var str=Ext.getCmp("PersonDepDR").lastQuery
 		wardstore.baseParams.ward=str; 
  });
	var CurrentDep=Ext.getCmp("PersonDepDR1");
	CurrentDep.disabled=true;
	var personName=Ext.getCmp("PersonName")
	personName.disabled=true;
	var personID=Ext.getCmp("PersonID")
	personID.disabled=true;
	CurrentDep.setValue(ha.items("PerCurrentDep"));
	personName.setValue(ha.items("PersonName"));
	personID.setValue(ha.items("PersonID"))
	//CurrentDep.setValue(ret);
	var StDate=Ext.getCmp("PerTranStDate")
	StDate.setValue(new Date());
	var btnSave1=Ext.getCmp('btnSave1');
	btnSave1.hide();
	win.show();	
	var btnSave=Ext.getCmp("btnSave");
	btnSave.on("click",function(){makeSure(Par);win.close();SchQual();});
}
function makeSure(Par)
{
	var personName=Ext.getCmp("PersonName").getValue();
	var personID=Ext.getCmp("PersonID").getValue();
	var personDepDR=Ext.getCmp("PersonDepDR").getValue();
	if(personDepDR==""){alert("请选择需要更换的护理单元！");return;}
	var StDate=Ext.getCmp("PerTranStDate").value;
	if(StDate==""){alert("请输入开始日期！");return;}
	/*
	var StTime=Ext.getCmp("PerTranStTime").value;
	if(StTime==""){alert("请输入开始时间！");return;}
	*/
	var tranCurrent="Y";
	var tranFlag="1"
	var CurrentDep=Ext.getCmp("PersonDepDR1").getValue();
	var parm=personName+"^"+personID+"^"+"^"+Par+"^"+personDepDR+"^"+StDate+"^"+"^"+tranCurrent+"^"+tranFlag+"^^"+CurrentDep;;
	//alert(parm);
	var SaveTranDep = document.getElementById('SaveTranDep');
	var a=cspRunServerMethod(SaveTranDep.value,parm);	
}
var locdata = new Array();
var condata = new Array();
//编辑事件
function ModCheck()
{
	var grid = Ext.getCmp("mygrid");
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) {
		Ext.Msg.alert('提示',"请选择一条记录！");
		return;
	}
	var Par = rowObj[0].get("rw");	
	var getVal = document.getElementById('getVal');
	var ret=cspRunServerMethod(getVal.value,Par);
	//alert(ret)
  var ha = new Hashtable();
  var tm=ret.split('^')
	sethashvalue(ha,tm);
	var a = cspRunServerMethod(pdata1,"","DHCNurPersonInformationAdd","","");
	arr = eval(a);
	var box1=new Ext.BoxComponent({
		xtype:'box',
		id:'imgBox',
		x:5,y:60, 
		autoShow:true,
		style: 'margin-top:4px',
		// disabled:true,
		width: '110px', //图片宽度   
		height: '140px', //图片高度
		fileUpload:true,		    
		autoEl: {
			tag: 'img',    //指定为img标签  
		  id:'imgsrc', 
		  src: '../../web/images/222349.png'   //指定url路径	            
		},
		listeners: {
      'beforerender': function () {
    	} 
    },
		renderTo:Ext.getBody()
	});		
	var window= new Ext.Window({		
		title:'修改人员信息',
		id:'gform2',
		x:10,y:20,
		width:768,height:550,
		autoScroll:true,
		layout:'absolute',
		items:[arr,box1],
		modal:true,
		resizable:false
	});	
	if(ha.items("PersonFlag")==1){
		var btnSave=Ext.getCmp("btSave");
		btnSave.hide();
		Ext.Msg.alert('提示',"已审核，不能修改!");
		return;
	}	
	//window.show();
	Ext.getCmp('PersonDepDR').store.on("beforeLoad",function(){
  	var wardstore=Ext.getCmp('PersonDepDR').store;
  	var str=Ext.getCmp("PersonDepDR").lastQuery
 		wardstore.baseParams.ward=str; 
  });	
  Ext.getCmp("PersonID").disable();
  //加载comobox数据
	window.items.each(function(item,index,length){
	 	if(item.getXType()=="combo"){
	 		//if((item.getId()=="PersonSexDR")||(item.getId()=="Personmarriage")||(item.getId()=="PersonWorkType")){
	 		if(item.mode=="local"){
	 			if(ha.items(item.getId())!=""){
	 				if(item.getId()&&(Ext.getCmp(item.getId()))){
	 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()).replace("__","||"));
	 				}
	 			}
	 			item.triggerAction='all';
	 		}else{
		 		Ext.getCmp(item.getId()).store.load({params:{start:0,limit:2000},callback:function(){
		 			if(ha.items(item.getId())!=""){
		 				if(item.getId()&&(Ext.getCmp(item.getId()))){
		 					Ext.getCmp(item.getId()).typeAhead=false;
		 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()).replace("__","||"));
		 				}
		 			}
		 		}})
		 	}
		 	item.typeAhead='false';
	 	}
	 	if(item.getXType()=="datefield"){
		 	if(ha.items(item.getId())){
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));	
				}
			}
		}
		if(item.getXType()=="textfield"){
			if(ha.items(item.getId())){
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
				}
			}
		}
		if(item.getXType()=='box'){
			if(item.getId()&&(Ext.getCmp(item.getId()))){
				Ext.getCmp("imgBox").getEl().dom.src=ha.items("PersonImage");
			}
		}
	})
	window.show();
	if(ha.items("PersonPrefQual")){
		Ext.getCmp('PersonPrefQualFlag_1').setValue(true);
	}else{
		Ext.getCmp('PersonPrefQualFlag_1').checked=false;
		Ext.getCmp("PersonPrefQual").disable();
		Ext.getCmp("PersonPrefQualDate").disable();
	}
	var personPrefQualFlag=Ext.getCmp("PersonPrefQualFlag_1");
	personPrefQualFlag.on('check',function(personPrefQualFlag,checked){
		if(checked==true){
			var PersonPrefQualFlag="1";
			var personPrefQual=Ext.getCmp("PersonPrefQual");
  		//if(secGrpFlag!="hlb"){personPrefQual.setEditable(false);}
  		personPrefQual.enable();
  	 	var personProfPostDRStore=Ext.getCmp("PersonProfPostDR").getStore();
		 	personProfPostDRStore.load({params:{start:0,limit:50}});
		 	var PersonProfPostDR=Ext.getCmp("PersonProfPostDR").getValue();
		 	var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
		 	personPrefQualDate.enable();	
		}else{
			var PersonPrefQualFlag="0";
  		var personPrefQual=Ext.getCmp("PersonPrefQual");
  		//personPrefQual.setEditable(false);  		
  		personPrefQual.clearValue();
  		personPrefQual.disable();
  		var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
  		personPrefQualDate.setValue("");
		 	personPrefQualDate.disable();
		}
	})
  /*
	Ext.getCmp("imgBox").getEl().dom.src=ha.items("PersonImage");
	Ext.getCmp('PersonAdmHosDate').setValue(ha.items("PersonAdmHosDate"));
	//if(session['LOGON.GROUPDESC']!="护理部主任"&&session['LOGON.GROUPDESC']!="护理部"){
	if(secGrpFlag!="hlb"&&secGrpFlag!="hlbr"){
		//setComItem();
	}
	*/
	//window.show();
	document.getElementById('_Label150').style.color='#ff0000';
	document.getElementById('_Label164').style.color='#ff0000';
	var btnClear=Ext.getCmp('btnClear');
	btnClear.hide()
	var btnSave=Ext.getCmp("btSave");
	btnSave.setIcon('../images/uiimages/ok.png');
	btnSave.setText("更新");
	var btnUpload=Ext.getCmp("UpLoadImg");
	btnUpload.setIcon('../images/uiimages/doctor.png');
	//需求确认后放开
	//btnUpload.hide();
	btnUpload.on("click",function(){upLoadImg();});
	//添加
	var btnSave=Ext.getCmp("btSave");
	var newadd=0;
  btnSave.on("click",function(){SureCheck(Par,newadd);});	// Refresh(Par)
  var Personpeopledr = Ext.getCmp('Personpeopledr');
  Personpeopledr.store.on('beforeload',function(){
  	Personpeopledr.store.baseParams.typ=Personpeopledr.lastQuery;
  });
}
function setComItem()
{
	Ext.getCmp('PersonName').setDisabled(true);
	Ext.getCmp('PersonSexDR').setDisabled(true);
	Ext.getCmp('PersonBirthDay').setDisabled(true);
	Ext.getCmp('PersonIdentity').setDisabled(true);
	Ext.getCmp('PersonRegNo').setDisabled(true);
	Ext.getCmp('PersonID').setDisabled(true);
	Ext.getCmp('PersonSchoolAgeDr').setDisabled(true);
	Ext.getCmp('PersonDegreeDR').setDisabled(true);
	Ext.getCmp('PersonProfession').setDisabled(true);
	Ext.getCmp('PersonSchoolType').setDisabled(true);
	Ext.getCmp('PersonGraduateSchool').setDisabled(true);
	Ext.getCmp('PersonWorkDateTime').setDisabled(true);
	Ext.getCmp('PersonAdmHosDate').setDisabled(true);
	Ext.getCmp('PersonDepDR').setDisabled(true);
	Ext.getCmp('PersonTransDate').setDisabled(true);
	Ext.getCmp('PersonWorkType').setDisabled(true);
	Ext.getCmp('PersonPostTyp').setDisabled(true);
	Ext.getCmp('PersonProfPostDR').setDisabled(true);
	Ext.getCmp('PersonTechPostDate').setDisabled(true);
	Ext.getCmp('PersonAppDutyDR').setDisabled(true);
	Ext.getCmp('PersonBattery').setDisabled(true);
	Ext.getCmp('PersonheadshipDR').setDisabled(true);
	Ext.getCmp('PersonNurHeadDate').setDisabled(true);
	Ext.getCmp('PersonMentorDR').setDisabled(true);
	Ext.getCmp('PersonTeachPostDR').setDisabled(true);
	Ext.getCmp('PersonRetireDate').setDisabled(true);
	Ext.getCmp('PersonPrefQual').setDisabled(true);
	Ext.getCmp('PersonNurseQualDate').setDisabled(true);
	Ext.getCmp('PersonPrefQualDate').setDisabled(true);
	Ext.getCmp('PersonPrefQualFlag').setDisabled(true);
	
}
function gblClick()
{
	var grid = Ext.getCmp("mygrid");	
	var rowObj = grid.getSelectionModel().getSelections();
	if (rowObj.length == 0) 
	{
		alert("请选择一条记录！");
		return;
	}
	var RowId = rowObj[0].get("rw");
	//var PerName=rowObj[0].get("PersonName");
	var PerID=rowObj[0].get("PersonID");
	//alert(RowId)
	var link="dhcmgperinformation.csp?RowId="+RowId+"&PerID="+PerID; //+"&PerName="+PerName
	//alert(link);
//	var fheight = document.body.offsetHeight;
//var fwidth = document.body.offsetWidth;
	window.open (link,'学习经历','height=600,width=1024,top=0,left=20,scroll=yes,toolbar=no,status=no,resizable=no,floating=true'); //scrollbars=yes,
  return;
}
	//查询列表
function SchQual()
{		
	var mygrid = Ext.getCmp("mygrid"); 
	mygrid.getStore().addListener('load',handleGridLoadEvent);
	mygrid.store.load({
			params : {
				start : 0,
				limit : 20
			}
	});	
}
function handleGridLoadEvent(store,records)
{
	var grid=Ext.getCmp('mygrid');
	var gridcount=0;
	store.each(function(r){
		if(r.get('PersonFlag')==1){
			//grid.getView().getRow(gridcount).style.backgroundColor='#33FF00';	
			//grid.getView().getCell(gridcount,0).style.backgroundColor='#33FF00';
			grid.getView().getCell(gridcount,0).style.backgroundImage="url('../images/uiimages/ok.png')";
			grid.getView().getCell(gridcount,0).style.backgroundRepeat='no-repeat';
			grid.getView().getCell(gridcount,0).style.backgroundPosition='center';
		}else if(r.get('PersonFlag')==0){
			//grid.getView().getRow(gridcount).style.backgroundColor='#FF3300';	
			//grid.getView().getCell(gridcount,0).style.backgroundColor='#FF3300';
			grid.getView().getCell(gridcount,0).style.backgroundImage="url('../images/uiimages/cancel.png')";
			grid.getView().getCell(gridcount,0).style.backgroundRepeat='no-repeat';
			grid.getView().getCell(gridcount,0).style.backgroundPosition='center';
		}
		gridcount=gridcount+1;
	})
}
function cellclick(obj)
{
   var r=obj.record; 
   var sum=0;
   var mygrid = Ext.getCmp('mygrid'); 
   var selModel = mygrid.getSelectionModel(); 
   var rowIndex = mygrid.store.indexOf(mygrid.getSelectionModel().getSelected());
   for (colIndex = 2; colIndex < 7; colIndex++) 
    {
      var colname = mygrid.getColumnModel().getDataIndex(colIndex);   
      var celldata = grid.getStore().getAt(rowIndex).get(colname); //获取数据 
      if (celldata==undefined)
      {
      	celldata =0;
      }
      else
      {
       if (celldata.indexOf(",")!="-1")
       {
      	 celldata=calculate(celldata);
       }
       else
       	{
       		celldata=scoreFormat(celldata);
       	}
     }
      sum=sum+ parseInt(celldata);     
    } 
   mygrid.store.getAt(rowIndex).set(mygrid.getColumnModel().getDataIndex(7),sum);
}

function Check(Par)
{
	var a = cspRunServerMethod(pdata1,"","DHCNurPersonInformationAdd","","");
	var arr = eval(a);
	var b=new Ext.BoxComponent({			
		xtype:'box',
		pressed:true,
		x:920,y:50,
		height:'120px',
		width:'100px',
		handler:function(){Ext.MessageBox.alert("nnnn");},
		autoEl:{
			tag:'img',
			src:''
		}
	});
	var box1=new Ext.BoxComponent({
		xtype:'box',
		id:'imgBox',
		x:5,
		y:60, 
		autoShow:true,
		style: 'margin-top:4px',
		// disabled:true,
		width: '110px', //图片宽度   
		height: '140px', //图片高度
		fileUpload:true,		    
		autoEl: {
			tag: 'img',    //指定为img标签  
			id:'imgsrc', 
			src: '../images/uiimages/patdefault.png'   //指定url路径	            
		},
		listeners: {
			'beforerender':function () { 
      } 
    },
		renderTo:Ext.getBody()
	});	
	var window= new Ext.Window({
		title:'添加人员',
		id:"gform2",
		x:10,y:2,
		width:780,
		height:550,
		fileUpload:true,
		autoScroll:true,
		layout:'absolute',
		items:[arr,box1],
		modal:true,
		resizable:false
	});
	window.items.each(function(item,index,length){
		if(item.getXType()=="combo"){
			item.triggerAction='all';
			item.forceSelection=true;
			item.typeAhead=false;
			if(item.getId()=='PersonDepDR'){
				//debugger;
			}
			if(item.getId()=='PersonGraduateSchool'){
				Ext.getCmp(item.getId()).store.on('beforeload',function(){
					Ext.getCmp(item.getId()).store.baseParams.typ=Ext.getCmp(item.getId()).lastQuery;	
				})
			}
		}	
	});
	var personPrefQual=Ext.getCmp("PersonPrefQual");
	personPrefQual.disable();
	var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
	personPrefQualDate.disable();
	var personPrefQualFlag=Ext.getCmp("PersonPrefQualFlag_1");
  personPrefQualFlag.on('check',function(personPrefQualFlag,checked){
  	if(checked==true){  		
  		var PersonPrefQualFlag="1";  	
  		var personPrefQual=Ext.getCmp("PersonPrefQual");
  		personPrefQual.allowBlank=true;
  		personPrefQual.selectByValue();
  		personPrefQual.enable();
  	 	var personProfPostDRStore=Ext.getCmp("PersonProfPostDR").getStore();
		 	personProfPostDRStore.load({params:{start:0,limit:50}});
		 	var PersonProfPostDR=Ext.getCmp("PersonProfPostDR").getValue();
		 	var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
		 	personPrefQualDate.enable();
  	}
  	else{
  		var PersonPrefQualFlag="0";
  		var personPrefQual=Ext.getCmp("PersonPrefQual");
  		if(secGrpFlag!="hlb"){personPrefQual.setEditable(false);}
  		personPrefQual.clearValue();
  		personPrefQual.disable();
  		var personPrefQualDate=Ext.getCmp("PersonPrefQualDate");
  		personPrefQualDate.setValue("");
		 	personPrefQualDate.disable();
  	}  		
  })
	window.show();
	var btnClear=Ext.getCmp('btnClear');
	btnClear.hide()
	btnClear.on('click',function(){ClearMethod();})
	document.getElementById('_Label150').style.color='#ff0000';
	document.getElementById('_Label164').style.color='#ff0000';
  Ext.getCmp('PersonDepDR').store.on("beforeLoad",function(){
  	var wardstore=Ext.getCmp('PersonDepDR').store;
   	var str=Ext.getCmp("PersonDepDR").lastQuery
 		wardstore.baseParams.ward=str;         
  });
	var btnUpload=Ext.getCmp("UpLoadImg");
	btnUpload.setIcon('../images/uiimages/doctor.png');
	btnUpload.on("click",function(){upLoadImg();});
	//添加人员界面保存按钮
	var btnSave=Ext.getCmp("btSave");
	btnSave.setIcon('../images/uiimages/filesave.png');
	var newadd=1;
	btnSave.on("click",function(){SureCheck(Par,newadd);});	
	if(Par!=""){
		var getVal = document.getElementById('getVal');
    var ret=cspRunServerMethod(getVal.value,Par);    
	}
}
function upComboBoxDep(depString)
{
	comboboxDep.pageSize=1000;
	var comboboxDepStore=Ext.getCmp('comboboxDep').getStore();
	comboboxDepStore.load({
		params:{start:0,limit:1000}
	});
	comboboxDepStore.on('load',function(comboboxDepStore,record,options){
		Ext.getCmp('comboboxDep').selectText();
		Ext.getCmp('comboboxDep').setValue(depString);
	})
	SchQual();
}
function ClearMethod()
{
	//alert(Ext.getCmp('gform2').findByType('textfield').getValue());
//		 Ext.getCmp('gform2').items.each(function(item,index.length){
//			Ext.getCmp(item).setValue('')	
//		});
		//BookPanel.items.each(function(item,index,length){
}
//添加人员弹出窗口事件
function addNew()
{ 
	Check("");
}
function  uploadpic1()
{
	var savename = '00'+session['LOGON.USERCODE'];
	var filepath="E:\\dthealth\\app\\dthis\\web\\images\\pic\\002.png"
	var savepath="//192.192.100.205/trakcare/web/loadimage/"
	var mn=FileUploadImg(filepath,savepath,savename)
	alert(mn);
	if(mm=="图片上传成功！！！"){showimg();}
}
///暂时不用
function uploadpic()
{
	var saveName = '00'+session['LOGON.USERCODE'];
	//window.showModalDialog("http://192.192.100.222/uploadimg/?saveName="+saveName,"newwindow", "dialogWidth=490px;dialogHeight=180px, top=200,left=200 toolbar =no, menubar=no, scrollbars=no, resizable=no, location=no, status=no,scroll=no");
	//window.open("http://192.192.100.222/uploadimg/?saveName="+saveName,"newwindow", "height=100, width=450, top=200,left=200 toolbar =no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	window.showModalDialog("http://192.192.100.222/uploadimg/?saveName="+saveName,window.self,"dialogWidth:490px;dialogHeight:180px:center:yes");   
	window.close();
	showimg();
}
function showimg()
{
	var box1=Ext.getCmp("imgBox");
	var imgsrc="//192.192.100.205/trakcare/web/loadimage/"+'00'+session['LOGON.USERCODE']+".jpg";
	box1.getEl().dom.src=imgsrc;
}
function parseXML()
{
	try //Internet Explorer
  {
  	xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
  }catch(e){
  	try //Firefox, Mozilla, Opera, etc.
  	{
    	xmlDoc=document.implementation.createDocument("","",null);
    }catch(e){
	    alert(e.message);
    	return;
    }
  }
	xmlDoc.async=false;
	var ftpIp=webIP.substring(7,webIP.length);
	xmlDoc.load(webIP+"/dhcmg/ftpupload.xml");
	//alert(webIP)
	//<FTP server="172.21.21.78" user="view" pwd="1" port="1881" dealyTim="20" /> 
	var elements=xmlDoc.getElementsByTagName("FTP");
//	for (var i = 0; i < elements.length; i++) {
//     var name = elements[i].getElementsByTagName("cNname")[0].firstChild.nodeValue;
//     var ip = elements[i].getElementsByTagName("cIP")[0].firstChild.nodeValue;               
//
//	}
	var server=elements[0].getElementsByTagName("server")[0].firstChild.nodeValue;
	var userName=elements[0].getElementsByTagName("user")[0].firstChild.nodeValue;
	var password=elements[0].getElementsByTagName("pwd")[0].firstChild.nodeValue;
	var portID=elements[0].getElementsByTagName("port")[0].firstChild.nodeValue;
	ftpServerIP="Ftp://"+userName+":"+password+"@"+server+":"+portID+"/ftploadimg/";
	//ftpServerIP="Ftp://"+server+":"+portID+"/ftploadimg/"
	//alert("test"+ftpServerIP)
	return ftpServerIP;
}
function findFtpServer()
{
	try //Internet Explorer
  {
  	xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
  }catch(e){
  	try //Firefox, Mozilla, Opera, etc.
  	{
    	xmlDoc=document.implementation.createDocument("","",null);
    }catch(e){
	    alert(e.message);
    	return;
    }
  }
	xmlDoc.async=false;
	var ftpIp=webIP.substring(7,webIP.length);
	xmlDoc.load(webIP+"/dhcmg/ftpupload.xml");
	
	var elements=xmlDoc.getElementsByTagName("FTP");
	var server=elements[0].getElementsByTagName("server")[0].firstChild.nodeValue;
	var userName=elements[0].getElementsByTagName("user")[0].firstChild.nodeValue;
	var password=elements[0].getElementsByTagName("pwd")[0].firstChild.nodeValue;
	var portID=elements[0].getElementsByTagName("port")[0].firstChild.nodeValue;
	ftpServerIP="Ftp://"+server+":"+portID+"/ftploadimg/";
	var arr=[];
	arr["server"]=server;
	arr["userName"]=userName;
	arr["password"]=password;
	arr["portID"]=portID;
	arr["ftpServerIP"]=ftpServerIP;
	return arr;
}
//上传图片
function upLoadImg()
{  
	if(Ext.getCmp('PersonID').getValue()==""){
		Ext.Msg.alert('提示','工号不能为空!');
		return;
	}
	var newSrc="";
	var types="";
	var form = new Ext.form.FormPanel({
		baseCls : 'x-plain',
		//id:'form',
		labelWidth : 70,
		//frame:true,
		fileUpload : true,
		defaultType : 'textfield',
		items : [{
			xtype : 'textfield',
			fieldLabel : '请选择图片',
			name : 'userfile',
			id : 'userfile',
			inputType : 'file',				
			blankText : 'File can\'t not empty.',
			anchor : '100%'
		}]
	});    
	var winUpload = new Ext.Window({
		title : '照片上传',
		width : 400,
		height : 110,
		minWidth : 300,
		minHeight : 100,
		layout : 'fit',
		plain : true,
		bodyStyle : 'padding:5px;',
		buttonAlign : 'center',
		modal:true,
		items: [new Ext.form.FormPanel({
			id: 'upfile',
			layout: 'fit',
			fileUpload: true,
			items: [{
				xtype: 'textfield',
				allowBlank: false,
				inputType: 'file',
				name: 'FileStream',
				id: 'FileStream'
			}]

		})],
		buttons : [{
			text : '上传',
			icon:'../images/uiimages/moveup.png',
			handler : function() {
				var grid = Ext.getCmp("mygrid");
					var rowObj = grid.getSelectionModel().getSelections();
					if (rowObj.length == 0) {
						alert("请选择一条记录！");
						return;
					}
					var Par = rowObj[0].get("rw");
				if(Ext.getCmp('FileStream').getValue()==''){
						Ext.Msg.alert('错误','请选择你要上传的文件');
			 			return;
					}
				var newSrc =Ext.getCmp('FileStream').getValue();
				if(!/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(newSrc))
				{
				  alert("图片类型必须是.gif,jpeg,jpg,png中的一种")
				  return false;
				}
                var sdate=new Date();
				var sYear=sdate.getFullYear();
				var sMonth=sdate.getMonth()+1;
				var sDay=sdate.getDate();
				var sHour=sdate.getHours();
				var sMinute=sdate.getMinutes();
				var sSecond=sdate.getSeconds();
				var sExtension=sYear.toString()+sMonth.toString()+sDay.toString()+sHour.toString()+sMinute.toString()+sSecond.toString();
				var savename='';
				var PersonID=Ext.getCmp("PersonID").getValue();
				if(PersonID==''){alert("工号不能为空！");winUpload.close();return;}
				else{
					savename=PersonID+sExtension+".jpg";
				}			
				//alert(savename)
				//alert(Par)
				//alert(PersonID)
				var filepath=newSrc;
				var fp = Ext.getCmp('upfile');
				var form = fp.getForm();
				try {
					form.submit({
						url: "DHCMgNurFTPLoadImg.CSP",
						method: 'POST',
						waitMsg: '正在上传.........',
						params: {
							
							savename: savename,
							Par:Par,
							PersonID:PersonID
						},
						success: function(form, action) {
							Ext.Msg.alert('Success', action.result.msg);
							var imgsrc="ftp://ftpuser:1_ftp_2@172.19.19.58:1880/ftploadimg/"+savename;
							//alert(imgsrc)
							var box1=Ext.getCmp("imgBox");
							box1.getEl().dom.src=imgsrc;
							winUpload.close();
						},
						failure: function(form, action) {
							switch (action.failureType) {
								case Ext.form.Action.CLIENT_INVALID:
									Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');
									break;
								case Ext.form.Action.CONNECT_FAILURE:
									Ext.Msg.alert('Failure', 'Ajax communication failed');
									break;
								case Ext.form.Action.SERVER_INVALID:
									Ext.Msg.alert('Failure', action.result.msg);
							}
						}
					});
				} catch (e) {
					// statements
					//console.log(e);
					alert(e)
				}
			}	
	 	}, {
	 		text : '关闭',
			icon:'../images/uiimages/cancel.png',
	 		handler : function() {winUpload.close();}
		}]
	}); 
	winUpload.show();	
}
function getFtpPassWord()
{
	try //Internet Explorer
  {
  	xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
  }catch(e){
  	try //Firefox, Mozilla, Opera, etc.
  	{
    	xmlDoc=document.implementation.createDocument("","",null);
    }catch(e){
	    alert(e.message);
    	return;
    }
  }
	xmlDoc.async=false;
	var ftpIp=webIP.substring(7,webIP.length);
	xmlDoc.load(webIP+"/dhcmg/ftpupload.xml");
	var elements=xmlDoc.getElementsByTagName("FTP");
	var server=elements[0].getElementsByTagName("server")[0].firstChild.nodeValue;
	var userName=elements[0].getElementsByTagName("user")[0].firstChild.nodeValue;
	var password=elements[0].getElementsByTagName("pwd")[0].firstChild.nodeValue;
	var portID=elements[0].getElementsByTagName("port")[0].firstChild.nodeValue;
	return password;
}
//
function SureCheck(Par,newadd)
{	
	//姓名
	var PersonName=Ext.getCmp("PersonName").getValue();
	if(PersonName==""){Ext.Msg.alert('提示',"姓名不能为空！");return;}
	//出生年月
	var PersonBirthDay=Ext.getCmp("PersonBirthDay").getValue();
	if(PersonBirthDay==""){Ext.Msg.alert('提示',"出生日期不能为空！");return;}
	else{
		if(PersonBirthDay instanceof Date){
			PersonBirthDay=PersonBirthDay.format('Y-m-d')
		}
	}
	//alert(PersonBirthDay)
	//身份证
	var PersonIdentity=Ext.getCmp("PersonIdentity").getValue();	
	if(PersonIdentity=="")
	{
		Ext.Msg.alert('提示',"身份证号码不能为空！")
		return;
	}else{
		var reg=/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
		if(!reg.test(PersonIdentity))
		{
			Ext.Msg.alert('提示',"非法身份证号码！请重新输入！")
			return false;
		}			
	}
	if(PersonBirthDay!=""&&PersonIdentity!=""){
		var iLen=PersonIdentity.length;
		//alert(iLen)
		//alert("PersonIdentity:"+PersonIdentity)
		//alert("PersonBirthDay:"+PersonBirthDay)
		if(iLen==18){
			//PersonIdentity.substring(6,13);
			PersonIdentity = PersonIdentity.replace(/^\s+|\s+$/g,"");
			var iStr=PersonIdentity.substring(6,14); //+"%"+PersonIdentity
			//debugger
			if(PersonBirthDay instanceof Date){
				var bStr=PersonBirthDay.format('Y-m-d').replace(/-/g,'');
			}else{
				var bStr=PersonBirthDay.replace(/-/g,'');
			}
			//var bStr=PersonBirthDay.replace(/-/g,'');
			if(iStr!=bStr){Ext.Msg.alert('提示','出生日期与身份证中的年月日不一致，请核对后保存！');return;}
		}else if(iLen==15){
			PersonIdentity = PersonIdentity.replace(/^\s+|\s+$/g,"");
			var iStr="19"+PersonIdentity.substring(6,12);
			//alert("iStr："+iStr)
			if(PersonBirthDay instanceof Date){
				var bStr=PersonBirthDay.format('Y-m-d').replace(/-/g,'');
			}else{
				var bStr=PersonBirthDay.replace(/-/g,'');
			}
			if(iStr!=bStr){Ext.Msg.alert('提示','出生日期与身份证中的年月日不一致，请核对后保存！');return;}			
		}
	}
	//return;
	//现住址
	var PersonAddress=Ext.getCmp("PersonAddress").getValue();
	//性别
	var PersonSexDR=Ext.getCmp("PersonSexDR").getValue();
	if(PersonSexDR==""){Ext.Msg.alert('提示',"性别不能为空！");return;}
	//婚姻
	var Personmarriage=Ext.getCmp("Personmarriage").getValue();
	//家庭电话
	var PersonTelHome=Ext.getCmp("PersonTelHome").getValue();
	//调试通过后放开
	if(PersonTelHome!="")
	{
		var reg=/^((\d{3,4}-)*\d{7,8}(-\d{3,4})*|13\d{9})$/;
		if(!reg.test(PersonTelHome))
		{
			Ext.Msg.alert('提示',"非法家庭电话号码！请重新输入！电话可以带区号，以-分隔");
			return false;
		}
	}
	//工号
	var PersonID=Ext.getCmp("PersonID").getValue();
	if(PersonID==""){Ext.Msg.alert('提示',"工号不能为空!");return;}
	else{
			PersonID=PersonID.replace(/(^\s*)|(\s*$)/g,"");
	}
	//if(PersonID.length!=4){alert("请输入4位有效工号！");return;}
	if(newadd==1){
		var ExistPerson = document.getElementById('ExistPerson');
		var retexit=cspRunServerMethod(ExistPerson.value,PersonID);
		if(retexit==1){Ext.Msg.alert('提示',"此工号已经存在！请重新输入工号！");return;}
	}
	//来院时间
	var PersonAdmHosDate1="";
	var PersonAdmHosDate=Ext.getCmp('PersonAdmHosDate').getValue();
	if(!PersonAdmHosDate){
		Ext.Msg.alert('提示','来院时间不能为空！');
		return;
	}else{
		if(PersonAdmHosDate instanceof Date){
			PersonAdmHosDate=PersonAdmHosDate.format('Y-m-d');
			PersonAdmHosDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonAdmHosDate);
		}
	}
	//手机
	var PersonTelHand=Ext.getCmp("PersonTelHand").getValue();  
	/*
	if(PersonTelHand=="")
	{alert("手机号不能为空！");return;}
	else{
		var reg=/^0?(13[0-9]|15[012356789]|18[01236789]|14[57])[0-9]{8}$/;
		if(!reg.test(PersonTelHand))
		{
			alert("非法手机号！请重新输入！")	
			return false;
		}
	}
	*/
/* 	if(PersonTelHand!=""){
		var reg=/^0?(13[0-9]|15[012356789]|18[012356789]|14[57])[0-9]{8}$/;
		if(!reg.test(PersonTelHand)){
			Ext.Msg.alert('提示',"非法手机号码！请重新输入！");
			return false;
		}
	} */
	if(PersonTelHand!=""){
		var reg=/^1(3|4|5|7|8)\d{9}$/;
		if(!reg.test(PersonTelHand)){
			Ext.Msg.alert('提示',"非法手机号码！请重新输入！");
			return false;
		}
	}
	//户籍地址
	var PersonHouseholdAdd=Ext.getCmp("PersonHouseholdAdd").getValue();
	
	//参加工作时间
	var PersonWorkDateTime=Ext.getCmp("PersonWorkDateTime").getValue();
	if(!PersonWorkDateTime){Ext.Msg.alert('提示','参加工作时间不能为空！');return;}
	else{
		if(PersonWorkDateTime instanceof Date){
			PersonWorkDateTime=PersonWorkDateTime.format('Y-m-d');
		}
	}
	//现住址邮编
	var PersonPresentZipCode=Ext.getCmp("PersonPresentZipCode").getValue();
	//籍贯
	var PersonNativePlaceDR=Ext.getCmp("PersonNativePlaceDR").getValue();
	//身高
	var PersonHeight=Ext.getCmp("PersonHeight").getValue();
	//注册号
	var PersonRegNo=Ext.getCmp("PersonRegNo").getValue();
	//户籍邮编
	var PersonHouseZipCode=Ext.getCmp("PersonHouseZipCode").getValue();
	//护士长任职时间
	if(Ext.getCmp("PersonNurHeadDate").getValue()==""){
		var PersonNurHeadDate=""
	}else{
		var PersonNurHeadDate=Ext.getCmp("PersonNurHeadDate").getValue();
		if(PersonNurHeadDate instanceof Date){
			PersonNurHeadDate=PersonNurHeadDate.format('Y-m-d');
			var PersonNurHeadDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonNurHeadDate);
			if(PersonNurHeadDate1<PersonAdmHosDate1){
				Ext.Msg.alert('提示',"任职时间不能小于来院时间！");
				return;
			}
		}
	}
	//职务
	var PersonheadshipDR=Ext.getCmp("PersonheadshipDR").getValue();
	if(PersonheadshipDR){
		PersonheadshipDR=PersonheadshipDR.replace("||","__");
	}
	//院内聘用时间
	var PersonHosEngageDate=Ext.getCmp("PersonHosEngageDate").getValue();
	if(PersonHosEngageDate!=""){
		if(PersonHosEngageDate instanceof Date){
		PersonHosEngageDate=PersonHosEngageDate.format('Y-m-d');
	    }
		var PersonHosEngageDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonHosEngageDate);
			if(PersonHosEngageDate1<PersonAdmHosDate1){
				Ext.Msg.alert('提示',"职称聘任时间不能小于来院时间！");
				return;
			}
	}
	//竞聘时间 （2013.10.11修改）
	//var PersonEngageDate=Ext.getCmp("PersonEngageDate").value;
	//退休时间
	var PersonRetireDate=Ext.getCmp("PersonRetireDate").getValue();
	if(PersonRetireDate!=""){
		if(PersonRetireDate instanceof Date){
		PersonRetireDate=PersonRetireDate.format('Y-m-d');
	    }
		var PersonRetireDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonRetireDate);
			if(PersonRetireDate1<PersonAdmHosDate1){
				Ext.Msg.alert('提示',"退休时间不能小于来院时间！");
				return;
			}
	}
	//取得护士执业资格时间
	var PersonNurseQualDate=Ext.getCmp("PersonNurseQualDate").getValue();
	if(PersonNurseQualDate instanceof Date){
		PersonNurseQualDate=PersonNurseQualDate.format('Y-m-d');
	}
	//取得专科护士资格时间
	var PersonPrefQualDate=Ext.getCmp("PersonPrefQualDate").getValue();
	if(PersonPrefQualDate instanceof Date){
		PersonPrefQualDate=PersonPrefQualDate.format('Y-m-d');
	}
	//护理单元
	var PersonDepDR=Ext.getCmp("PersonDepDR").getValue();
	if(PersonDepDR==""){
		Ext.Msg.alert('提示',"护理单元不能为空！")
		return;
	}
	//取得职称时间
	var PersonTechPostDate=Ext.getCmp("PersonTechPostDate").getValue();
	if(PersonTechPostDate instanceof Date){
		PersonTechPostDate=PersonTechPostDate.format('Y-m-d');
	}
	//民族
	var Personpeopledr=Ext.getCmp("Personpeopledr").getValue();
	if(Personpeopledr){
		Personpeopledr=Personpeopledr.replace("||","__");
	}	
	//政治面貌
	var PersonPolitydr=Ext.getCmp("PersonPolitydr").getValue();
  if(PersonPolitydr){
  	PersonPolitydr=PersonPolitydr.replace("||","__");
  }
  //鞋号
	var PersonShoeNO=Ext.getCmp("PersonShoeNO").getValue();
	if(PersonShoeNO){
		PersonShoeNO=PersonShoeNO.replace("||","__");
	}
	//教学职称
	var PersonTeachPostDR=Ext.getCmp("PersonTeachPostDR").getValue();
	if(PersonTeachPostDR){
		PersonTeachPostDR=PersonTeachPostDR.replace("||","__");
	}
	//衣号
	var PersonClothesNO=Ext.getCmp("PersonClothesNO").getValue();
	if(PersonClothesNO){
		PersonClothesNO=PersonClothesNO.replace("||","__");
	}
	//护士层级
	var PersonBattery=Ext.getCmp("PersonBattery").getValue();
	if(PersonBattery==""){
		Ext.Msg.alert('提示',"护士层级不能为空！")
		return;
	}
	if(PersonBattery){
		PersonBattery=PersonBattery.replace("||","__");
	}
	//导师资格
	var PersonMentorDR=Ext.getCmp("PersonMentorDR").getValue();
	if(PersonMentorDR){
		PersonMentorDR=PersonMentorDR.replace("||","__");
	}
	//院校制式
	var PersonSchoolType=Ext.getCmp("PersonSchoolType").getValue();
	if(PersonSchoolType){
		PersonSchoolType=PersonSchoolType.replace("||","__");
	}
	//护士种类
	var PersonNurTyp=Ext.getCmp("PersonNurTyp").getValue();
	if(PersonNurTyp){
		PersonNurTyp=PersonNurTyp.replace("||","__");
	}
	//人员类别 改为 工作科室
	var PersonPostTyp=Ext.getCmp("PersonPostTyp").getValue();
	if(PersonPostTyp){
		PersonPostTyp=PersonPostTyp.replace("||","__");
	}
	//专业
	var PersonProfession=Ext.getCmp("PersonProfession").getValue();
	if(PersonProfession){
		PersonProfession=PersonProfession.replace("||","__");
	}
	//学历
	var PersonSchoolAgeDr=Ext.getCmp("PersonSchoolAgeDr").getValue();
	if(PersonSchoolAgeDr){
		PersonSchoolAgeDr=PersonSchoolAgeDr.replace("||","__");
	}
	//学位
	var PersonDegreeDR=Ext.getCmp("PersonDegreeDR").getValue();
	if(PersonDegreeDR){
		PersonDegreeDR=PersonDegreeDR.replace("||","__");
	}
	//取得专科护士资格种类
	var PersonPrefQual=Ext.getCmp("PersonPrefQual").getValue();
	if(PersonPrefQual){
		PersonPrefQual=PersonPrefQual.replace("||","__");
	}
	//调入科室时间
	var PersonTransDate=Ext.getCmp("PersonTransDate").getValue();
	
	if(PersonTransDate=="")
	{
		Ext.Msg.alert('提示',"调入科室时间不能为空！")
		return;
	}else{
		if(PersonTransDate instanceof Date){
			PersonTransDate=PersonTransDate.format('Y-m-d');
			var PersonTransDate1=tkMakeServerCall("DHCMGNUR.MgPersons","getzdhdate",PersonTransDate);
			if(PersonTransDate1<PersonAdmHosDate1){
				Ext.Msg.alert('提示',"调入科室时间不能小于来院时间！")
				return;
			}	
		}
	}
	//聘任职称   ----需要修改
	var PersonAppDutyDR=Ext.getCmp("PersonAppDutyDR").getValue();
	if(PersonAppDutyDR){
		PersonAppDutyDR=PersonAppDutyDR.replace("||","__");
	}
	//毕业院校
	var PersonGraduateSchool=Ext.getCmp("PersonGraduateSchool").getValue();
	if(PersonGraduateSchool){
		PersonGraduateSchool=PersonGraduateSchool.replace("||","__");
	}
	//专业技术职称  ----需要修改 me2013.9.24
	var PersonProfPostDR=Ext.getCmp("PersonProfPostDR").getValue();
	if(PersonProfPostDR){
		PersonProfPostDR=PersonProfPostDR.replace("||","__");
	}
	//工作类别
	var PersonWorkType=Ext.getCmp("PersonWorkType").getValue();
	//照片
	var PersonImage=Ext.getCmp("imgBox").getEl().dom.src;
	var PersonPrefQualFlag=Ext.getCmp("PersonPrefQualFlag_1");
	//alert(PersonPrefQualFlag)
	if(PersonPrefQualFlag.checked){
		PersonPrefQualFlag="1";
	}else{
		PersonPrefQualFlag="0";
	}	
	
	var parr="rw|"+Par+"^PersonName|"+PersonName+"^PersonBirthDay|"+PersonBirthDay+"^PersonAddress|"+PersonAddress+"^PersonSexDR|"+PersonSexDR+"^Personmarriage|"+Personmarriage+"^PersonTelHome|"+PersonTelHome+"^PersonID|"+PersonID+"^PersonTelHand|"+PersonTelHand+"^PersonHouseholdAdd|"+PersonHouseholdAdd+"^PersonIdentity|"+PersonIdentity+"^PersonWorkDateTime|"+PersonWorkDateTime+"^PersonPresentZipCode|"+PersonPresentZipCode+"^PersonNativePlaceDR|"+PersonNativePlaceDR+"^PersonHeight|"+PersonHeight+"^PersonRegNo|"+PersonRegNo+"^PersonHouseZipCode|"+PersonHouseZipCode+"^PersonNurHeadDate|"+PersonNurHeadDate+"^PersonheadshipDR|"+PersonheadshipDR+"^PersonHosEngageDate|"+PersonHosEngageDate+"^PersonRetireDate|"+PersonRetireDate+"^PersonNurseQualDate|"+PersonNurseQualDate+"^PersonPrefQualDate|"+PersonPrefQualDate+"^PersonDepDR|"+PersonDepDR+"^PersonTechPostDate|"+PersonTechPostDate+"^Personpeopledr|"+Personpeopledr+"^PersonPolitydr|"+PersonPolitydr+"^PersonShoeNO|"+PersonShoeNO+"^PersonTeachPostDR|"+PersonTeachPostDR+"^PersonClothesNO|"+PersonClothesNO+"^PersonBattery|"+PersonBattery+"^PersonMentorDR|"+PersonMentorDR+"^PersonSchoolType|"+PersonSchoolType+"^PersonNurTyp|"+PersonNurTyp+"^PersonPostTyp|"+PersonPostTyp+"^PersonProfession|"+PersonProfession+"^PersonSchoolAgeDr|"+PersonSchoolAgeDr+"^PersonDegreeDR|"+PersonDegreeDR+"^PersonPrefQual|"+PersonPrefQual+"^PersonTransDate|"+PersonTransDate+"^PersonAppDutyDR|"+PersonAppDutyDR+"^PersonGraduateSchool|"+PersonGraduateSchool+"^PersonProfPostDR|"+PersonProfPostDR+"^PersonWorkType|"+PersonWorkType+"^PersonImage|"+PersonImage+"^PersonPrefQualFlag|"+PersonPrefQualFlag+"^PersonAdmHosDate|"+PersonAdmHosDate; //"^PersonEngageDate|"+PersonEngageDate+
//alert(parr)
	var Save = document.getElementById('Save');
	var a=cspRunServerMethod(Save.value,parr);
	//alert(a)
//检查完后单击保存后关闭当前窗口
	var gform2=Ext.getCmp("gform2");
	gform2.close();
	upComboBoxDep(PersonDepDR);
	SchQual();
}

function exportRec()
{
	window.open('dhcmgnurcomm.csp?EmrCode=DHCNURImportData','new','height='+fheight+',width='+fwidth+',top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=yes');
}
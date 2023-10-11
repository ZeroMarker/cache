var Width=document.body.clientWidth-2;
var Heigth=document.body.clientHeight-2;
//大科
var larLocCom=new Ext.form.ComboBox({
	name:'larloccom',
	id:'larloccom',
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
	tabIndex:'0',
	listWidth:190,
	//height:18,
	width:115,
	xtype:'combo',
	displayField:'LocDesc',
	valueField:'LocId',
	hideTrigger:false,
	//queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:20,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var comboBoxDep=new Ext.form.ComboBox({
	name:'comboboxDep',
	id:'comboboxDep',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'ctlocDesc',
				'mapping':'ctlocDesc'
			}, {
				'name':'CtLocDr',
				'mapping':'CtLocDr'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurPerHRComm',
			methodName:'SearchComboDep',
			type:'Query'
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
//	tabIndex:'0',
	listWidth:200,
	//height:22,
	width:220,
	xtype:'combo',
	displayField:'ctlocDesc',
	valueField:'CtLocDr',
	hideTrigger:false,
	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:2000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
///护士
var nurseCom = new Ext.form.ComboBox({
	name:'nurseCom',
	id:'nurseCom',
	x:0,y:0,
	//height:22,
	width:100,
	listWidth:180,
	xtype:'combo',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'nurseInfo',
				'mapping':'nurseInfo'
			}, {
				'name':'nurseNo',
				'mapping':'nurseNo'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurQuarterExamComm',
			methodName:'SearchNurse',
			type:'Query'
		}	
	}),
	displayField:'nurseInfo',
	valueField:'nurseNo',
	triggerAction:'all',
	hideTrigger : false,
	queryParam:'parr',
	forceSelection:true,
	minChars:1,
	pageSize:5000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
	//listeners:{'focus':function(){alert(this.getValue())}}
});
///成绩
var scoreLabel=new Ext.form.TextField({
	id:'scoreLabel',
	fieldLabel:'成绩',
	width:40,           
  listeners:{
  	blur:function(scoreLabel){
  		var text=this.getValue();
  		//Ext.getCmp('passCom').setValue('');
  		if(text){
  			var reg=/^(\d+)(\.\d{0,2})?$/;
  			if(!reg.test(text)){
  				Ext.Msg.alert('提示','只能输入非负浮点数(两位小数)！');
  				this.setValue('');
  				return;
  			}
  		}
  	},
  	keyup:function(){
  			
  	}
  }
});
///考试日期
var examDate=new Ext.form.DateField({
	name:'examdate',
	id:'examdate',
	//width:80,
	//format:'Y-m-d',
	xtype:'datefield',
	value:new Date(),//.getFirstDateOfMonth(),
	listeners:{
		select:function(dateField,date){
			Ext.getCmp('StDate').setValue(date)
		},
		blur:function(){
			if(!this.getValue()){
				Ext.Msg.alert('提示','考试日期不能为空！');
				this.setValue((new Date()).format('Y-m-d'))
			}
		}
	}
});
///操作项目
var operateItm = new Ext.form.ComboBox({
	name:'operateitm',
	id:'operateitm',
	x:0,y:0,
	//height:22,
	width:100,
	listWidth:180,
	xtype:'combo',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'operatecode',
				'mapping':'operatecode'
			}, {
				'name':'operatedesc',
				'mapping':'operatedesc'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurOperationExamComm',
			methodName:'SearchOperItm',
			type:'Query'
		}	
	}),
	displayField:'operatedesc',
	valueField:'operatecode',
	triggerAction:'all',
	hideTrigger : false,
	//queryParam:'parr',
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
///缺考原因
var comReason=new Ext.form.ComboBox({
	name:'comreason',
	id:'comreason',
	store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({
			url:"../csp/dhc.nurse.ext.common.getdata.csp"
		}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:[{
				'name':'desc',
				'mapping':'desc'
			}, {
				'name':'code',
				'mapping':'code'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurQuarterExamComm',
			methodName:'SearchCommType',
			type:'Query'
		}
	}),
	tabIndex:'0',
	listWidth:200,
	//height:22,
	width:100,
	xtype:'combo',
	displayField:'desc',
	valueField:'code',
	hideTrigger:false,
//	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:20,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//开始日期
var StDate=new Ext.form.DateField({
	name:'StDate',
	id:"StDate",
	//width:80,
	//format:'Y-m-d',
	xtype:'datefield',
	value:new Date().getFirstDateOfMonth(),
	listeners:{
		select:function(dateField,date){
			Ext.getCmp('examdate').setValue(date);
			var stDate=Ext.getCmp('EndDate').getValue();
			if(stDate!=""){
				var flag=date.between(date,stDate);
				if(!flag){
					Ext.Msg.alert('提示',"开始日期不能大于结束日期！");
				  StDate.setValue("");
				}				
			}
		}
	}
});
///结束日期
var EndDate=new Ext.form.DateField({
	name:'EndDate',
	id:'EndDate',
	//width:80,
	//format:'Y-m-d',
	xtype:'datefield',
	value:new Date().getLastDateOfMonth(),
	listeners:{
		select:function(dateField,date){
			var stDate=Ext.getCmp('StDate').getValue();
			if(stDate!=""){
				var flag=date.between(stDate,date);
				if(!flag){
					Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
					EndDate.setValue("");	
				}
			}
		}
	}
});
var checkBox=new Ext.form.Checkbox({
	id:'checkbox',
	checked:false,
	hidden:true,
	boxLabel:'缺考人员'
});
var yearcombo=new Ext.form.ComboBox({
	id:'yearcombo',mode:'local',displayField:'desc',valueField:'id',triggerAction:'all',width:76,value:new Date().format('Y'),
	store:new Ext.data.ArrayStore({fields:['id','desc']}),
	listeners:{
		focus:function(tc,e){
			var nowyear=new Date().format('Y');
			var YearArray=new Array();
			for(var yi=parseInt(nowyear-10);yi<=parseInt(nowyear+10);yi++){
				YearArray.push([yi,yi]);
			}
			tc.store.loadData(YearArray);
		}
	}
});

///判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag)
function BodyLoadHandler()
{
	var retDep=tkMakeServerCall("DHCMGNUR.MgPersons","getnursedep",session['LOGON.USERCODE']);
	var ha= new Hashtable();
  var tm=retDep.split('^')
  sethashvalue(ha,tm);
	var mygridpl=Ext.getCmp('mygridpl');
	mygridpl.setSize(Width,Heigth);
	mygridpl.setPosition(0,0);
	var mygrid=Ext.getCmp('mygrid');
	mygrid.getTopToolbar().hide();
	var tobar=new Ext.Toolbar({});
	//if(session['LOGON.GROUPDESC']=='护理部'||session['LOGON.GROUPDESC']=='Demo Group'){
	if((secGrpFlag=="demo")||(secGrpFlag=="hlb")){
		tobar.addItem('-','大科',larLocCom);
	}
	tobar.addItem('-','科室',comboBoxDep);
	tobar.addItem('-','护士',nurseCom);
	tobar.addItem('-','操作项目',operateItm);
	tobar.addItem('-','成绩',scoreLabel);
	var ttbar=new Ext.Toolbar({});
	ttbar.addItem('-','考试日期',examDate);
	ttbar.addItem('-','年份',yearcombo);
	ttbar.addItem('-','月份',monthComm());
	Ext.getCmp('monthCom').setWidth(75);
	ttbar.addItem('-','缺考原因',comReason);
	mygrid.getBottomToolbar().hide();
	var mbbar= new Ext.PagingToolbar({
		pageSize:25,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg:"没有记录"
	});
	ttbar.addItem('-');
	ttbar.addButton({
		id:'addbtn',
		text:'增加',
		icon:'../images/uiimages/edit_add.png',
		handler:function(){saveDataRec('');}	
	});
	ttbar.addItem('-');
	ttbar.addButton({
		id:'updatebtn',
		text:'更新',
		disabled:true,
		icon:'../images/uiimages/reload.png',
		handler:function(){updateRecData();}	
	});
	ttbar.addItem('-');
	ttbar.addButton({
		id:'clearbtn',
		text:'清屏',
		icon:'../images/uiimages/clearscreen.png',
		handler:function(){clearItm();}
	});
	var tmbar=new Ext.Toolbar({});
	tmbar.addItem('-','开始日期',StDate);
	tmbar.addItem('-','结束日期',EndDate);
	tmbar.addItem('-');
	tmbar.addButton({
		id:'schBtn',
		text:'查询',
		icon:'../images/uiimages/search.png',
		handler:function(){schDataList();setItmEnable();}	
	});
	tmbar.addItem('-');
	tmbar.addButton({
		id:'invalBtn',
		text:'删除',
		icon:'../images/uiimages/cancel.png',
		handler:function(){invalRec("N");}
	});
	tmbar.addItem('-');
	tmbar.addButton({
		id:'exportbtn',
		text:'导出',
		icon:'../images/uiimages/redo.png',
		handler:function(){exportExcelData();}	
	})
	if((secGrpFlag=="demo")||(secGrpFlag=="hlb")){
		tmbar.addItem('-','',checkBox);
	}
	checkBox.on('check',function(checkBox,checked ){checkChange(checkBox,checked)})
	mbbar.render(mygrid.bbar);
	tobar.render(mygrid.tbar);
	ttbar.render(mygrid.tbar);
	tmbar.render(mygrid.tbar);
	mygrid.getColumnModel().setHidden(8, true);
	//if(session['LOGON.GROUPDESC']!='护理部'){
	if(secGrpFlag!="demo"){
		comboBoxDep.store.on("beforeload",function(){
	  	var pward=comboBoxDep.lastQuery;
			//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
			var nurseString=session['LOGON.USERID']+"^"+secGrpFlag;
	    comboBoxDep.store.baseParams.typ="1";
	    comboBoxDep.store.baseParams.ward1=pward;        
			comboBoxDep.store.baseParams.nurseid=nurseString;
		});		
	}
	//if((session['LOGON.GROUPDESC']=="护理部")||(session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="Demo Group")){
	if(secGrpFlag=="demo"||secGrpFlag=="hlb"||secGrpFlag=="hlbzr"){
		comboBoxDep.store.on('beforeload',function(){
			var pward=comboBoxDep.lastQuery;
			//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+larLocCom.getValue();
	 		var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+larLocCom.getValue();
	 		comboBoxDep.store.baseParams.typ="1";
	 		comboBoxDep.store.baseParams.ward1=pward;        
			comboBoxDep.store.baseParams.nurseid=nurseString;
		});
		comboBoxDep.addListener('click',function(){
			comboBoxDep.store.load({params:{start:0,limit:1000}})
			comboBoxDep.store.on('beforeload',function(){
				var pward=comboBoxDep.lastQuery;
				//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+larLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+larLocCom.getValue();
	 			comboBoxDep.store.baseParams.typ="1";
	 			comboBoxDep.store.baseParams.ward1=pward;        
				comboBoxDep.store.baseParams.nurseid=nurseString;
			});
		})
		larLocCom.addListener('blur',function(){
			comboBoxDep.setValue('');
			comboBoxDep.store.load({params:{start:0,limit:1000}})
				comboBoxDep.store.on('beforeload',function(){
				var pward=comboBoxDep.lastQuery;
				//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+larLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+larLocCom.getValue();
	 			comboBoxDep.store.baseParams.typ="1";
	 			comboBoxDep.store.baseParams.ward1=pward;        
				comboBoxDep.store.baseParams.nurseid=nurseString;
			});
		})
		larLocCom.addListener('focus',function(){
			comboBoxDep.store.on('beforeload',function(){
				var pward=comboBoxDep.lastQuery;
				//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+larLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+larLocCom.getValue();
	 			comboBoxDep.store.baseParams.typ="1";
	 			comboBoxDep.store.baseParams.ward1=pward;        
				comboBoxDep.store.baseParams.nurseid=nurseString;
			});
			larLocCom.on('select',function(combo,record,index){
				comboBoxDep.setValue('');
				//SchQual();
			})
		})
	}//else if(session['LOGON.GROUPDESC']=="总护士长"){
	else if(secGrpFlag=="znurhead"){
		//var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
		Ext.getCmp("comboboxDep").store.load({params:{start:0,limit:1000},callback:function(){
			Ext.getCmp("comboboxDep").selectText();
		}});
		//		comboboxDepStore.on('load',function(comboboxDepStore, records, options){						
		//			Ext.getCmp("comboboxDep").selectText();
		//		});	
	}else if(secGrpFlag=="nurhead"){
		//else if((session['LOGON.GROUPDESC'].indexOf("护士长")>0)&&(session['LOGON.GROUPDESC'].indexOf("总")==-1)){
		var comboDep=Ext.getCmp('comboboxDep');
		//var comboDepStore=comboDep.getStore();
  	comboDep.store.load({params:{start:0,limit:1000},callback:function(){
			comboDep.setValue(ha.items('perNurDep'));
  	}});
//  	comboDepStore.on('load',function(comboDepStore, records, options){
//			Ext.getCmp("comboboxDep").setValue(ha.items('perNurDep'));
//		});
		comboDep.setEditable(false);
	}
	nurseCom.store.on('beforeload',function(){
  	var nurse=nurseCom.lastQuery;
  	nurse!=undefined
  	nurseCom.store.baseParams.parr=nurse;
  	nurseCom.store.baseParams.sdep=comboBoxDep.getValue();
  });
  comboBoxDep.on('select',function(){
  	var nurperCom=Ext.getCmp('nurseCom');
  	nurperCom.setValue('');
  	nurperCom.store.load({params:{start:0,limit:1000}});
		nurperCom.store.on('beforeload',function(){
	  	var nurse=nurperCom.lastQuery;
	  	nurse!=undefined
	  	nurperCom.store.baseParams.parr=nurse;
	  	nurperCom.store.baseParams.sdep=comboBoxDep.getValue();
	  });
  });
	comboBoxDep.on('blur',function(){
		var nurperCom=Ext.getCmp('nurseCom')
		nurperCom.setValue('');
		nurperCom.store.load({params:{start:0,limit:1000}});
		nurperCom.store.on('beforeload',function(){
	  	var nurse=nurperCom.lastQuery;
	  	nurse!=undefined
	  	nurperCom.store.baseParams.parr=nurse;
	  	nurperCom.store.baseParams.sdep=comboBoxDep.getValue();
	  });
	})
  var operItm=Ext.getCmp('operateitm');
  operItm.store.on('beforeload',function(){
  	operItm.store.baseParams.par="操作考试项目";
  	operItm.store.baseParams.stype=operItm.lastQuery;	
  });
  comReason.store.on('beforeload',function(){
  	var reason=comReason.lastQuery;
  	comReason.store.baseParams.param="季度考试缺考原因";
  	comReason.store.baseParams.stype=reason;
  });
  mygrid.store.on('beforeload',function(){
  	var largeLoc=Ext.getCmp('larloccom').getValue();
 	    var stdate=Ext.getCmp('StDate').getValue();
		if(stdate!=""){
			if(stdate instanceof Date){
				stdate=stdate.format('Y-m-d');
			}
		}	
		var enddate=Ext.getCmp('EndDate').getValue();
		if(enddate!=""){
			if(enddate instanceof Date){
				enddate=enddate.format('Y-m-d');
			}
		}
		mygrid.store.baseParams.parr=comboBoxDep.getValue()+"^"+Ext.getCmp('nurseCom').getValue()+"^"+Ext.getCmp('operateitm').getValue()+"^"+Ext.getCmp('examdate').getValue().format('Y-m-d')+"^"+largeLoc+"^"+secGrpFlag+"^"+session['LOGON.USERID']+"^"+checkBox.checked+"^"+stdate+"^"+enddate; 
  });
  schDataList();
  
  mygrid.on('rowclick',gridClick);
}
function exportExcelData()
{
	var grid=Ext.getCmp('mygrid');
	var xls = new ActiveXObject ("Excel.Application");
	
	xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.Worksheets(1);
	
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
		if(cm.getColumnHeader(temp_obj[i-1])=='rw') continue;
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i-1]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	var store = grid.getStore();
	var recordCount = store.getCount();
	
	arrgrid = new Array();
	var tmpStore=new Ext.data.JsonStore({
		fields:['ScoreDep','ScoreNur','ScoreDate','ScoreYear','ScoreMonth','ScoreResult','ScoreItem','ScoreReason'],
		data:[],
		idIndex: 0
	});
	var parr=store.lastOptions.params.parr;
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"web.DHCMgNurOperationExamComm:SearchOperDataLst","parr$"+parr,"AddRec");
	tmpStore.loadData(arrgrid);
	var storeLen=tmpStore.getCount();
	for(i=1;i<=storeLen;i++){
		for(j=0;j<=tmpStore.fields.length-1;j++){
			xlSheet.Cells(i+1,j+1).value="'"+tmpStore.getAt(i-1).get(tmpStore.fields.items[j].name)
		}
	}
	xlSheet.Columns.AutoFit;
	xls.ActiveWindow.Zoom = 100;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  	xls=null;
  	xlBook=null; 
  	xlSheet=null;
}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function clearItm()
{
	Ext.getCmp('nurseCom').setValue('');
	Ext.getCmp('operateitm').setValue('');
	Ext.getCmp('scoreLabel').setValue('');
	Ext.getCmp('monthCom').setValue('');
	Ext.getCmp('comreason').setValue('');
	if(secGrpFlag=="demo"||secGrpFlag=="hlb"){
		Ext.getCmp('comboboxDep').setValue('');
	}
	schDataList();
	setItmEnable();
}
function gridClick()
{
	var grid=Ext.getCmp('mygrid');
	var rowObj=grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurOperationExam','getVal',rw);
	var ha=new Hashtable();
	var tm=retVal.split("^");
	sethashval(ha,tm);
	var comboPerDep=Ext.getCmp('comboboxDep');
	var depStore=comboPerDep.getStore();
	comboPerDep.store.load({params:{start:0,limit:1000},callback:function(){
			comboPerDep.setValue(ha.items('ScoreDep'));
	}});
	var nurCom=Ext.getCmp('nurseCom');
	var nurStore=nurCom.getStore();
	nurStore.load({params:{start:0,limit:10000},callback:function(){
			nurCom.setValue(ha.items('ScoreNur'));
	}});
	var operItm=Ext.getCmp('operateitm');
	var itmStore=operItm.getStore();
	itmStore.load({params:{start:0,limit:1000},callback:function(){
		operItm.setValue(ha.items('ScoreItem'));	
	}});
	var score=Ext.getCmp('scoreLabel');
	score.setValue(ha.items('ScoreResult'));
	yearcombo.setValue(ha.items("ScoreYear"));
	var monCom=Ext.getCmp('monthCom');
	monCom.setValue(ha.items('ScoreMonth'));
	var comRea=Ext.getCmp('comreason');
	var reaStore=comRea.getStore();
	reaStore.load({params:{start:0,limit:1000},callback:function(){
		comRea.setValue(ha.items('ScoreReason'));	
	}});
	var examdate=Ext.getCmp('examdate');
	examdate.setValue(ha.items('ScoreDate'));
	setItmDisable();
}
function setItmDisable()
{
	Ext.getCmp('addbtn').disable();
	Ext.getCmp('updatebtn').enable();
}
function setItmEnable()
{
	Ext.getCmp('addbtn').enable();
	Ext.getCmp('updatebtn').disable();
}
function sethashval(ha,tm)
{
	 for (i=0;i<tm.length;i++)
	 {
	 	var v=tm[i].split("@");
		var id=v[0];
		var vl=v[1];
		ha.add(id,vl);
	 }
} 
function schDataList()
{
	var grid=Ext.getCmp('mygrid');
	grid.store.load({
		params:{
			start:0,
			limit:20	
		}	
	});
}
function updateRecData()
{
	var grid=Ext.getCmp('mygrid');
	var rowObj=grid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	
	saveDataRec(rw);
}
function checkChange(checkBox,checked)
{
	if(checked==true){
		setItmDisVal();
	}else{
		setItmEnVal();
	}
}
function setItmDisVal()
{
	if(Ext.getCmp('larloccom')){Ext.getCmp('larloccom').disable();Ext.getCmp('larloccom').setValue('');}
	Ext.getCmp('comboboxDep').disable();
	Ext.getCmp('comboboxDep').setValue('');
	Ext.getCmp('nurseCom').disable();
	Ext.getCmp('nurseCom').setValue('');
	Ext.getCmp('operateitm').disable();
	Ext.getCmp('operateitm').setValue('');
	Ext.getCmp('scoreLabel').disable();
	Ext.getCmp('scoreLabel').setValue('');
	Ext.getCmp('monthCom').disable();
	Ext.getCmp('monthCom').setValue('');
	Ext.getCmp('comreason').disable();
	Ext.getCmp('comreason').setValue('');
}
function setItmEnVal()
{
	if(Ext.getCmp('larloccom')){Ext.getCmp('larloccom').enable();}
	Ext.getCmp('comboboxDep').enable();
	Ext.getCmp('nurseCom').enable();
	Ext.getCmp('operateitm').enable();
	Ext.getCmp('scoreLabel').enable();
	Ext.getCmp('monthCom').enable();
	Ext.getCmp('comreason').enable();
}
function addDataRec()
{
}
function invalRec(flag)
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一行记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	//alert(rw);
	if (confirm('确定删除选中的项？')) {
			var retInval=tkMakeServerCall('DHCMGNUR.MgNurOperationExam','delete',rw);
			if(retInval){
				Ext.Msg.alert('提示','执行成功！');
			}
			schDataList();
	}
}
function saveDataRec(rw)
{
	var depVal=Ext.getCmp('comboboxDep').getValue();
	if(!depVal){
		Ext.Msg.alert('提示','科室不能为空！');
		return;
	}
	var nurseVal=Ext.getCmp('nurseCom').getValue();
	if(!nurseVal){
		Ext.Msg.alert('提示','护士不能为空！');
		return;
	}
	var operatorVal=Ext.getCmp('operateitm').getValue();
	if(!operatorVal){
		Ext.Msg.alert('提示','操作项目不能为空！');
		return;
	}
	var scoreVal=Ext.getCmp('scoreLabel').getValue();
	var examDate=Ext.getCmp('examdate').getValue();
	if(!examDate){
		Ext.Msg.alert('提示','考试日期不能为空！');
		return;
	}else{
		if(examDate instanceof Date){
			examDate=examDate.format('Y-m-d');
		}
	}
	var year=Ext.getCmp('yearcombo').getValue();
	if(year==""){
		Ext.Msg.alert('提示','年份不能为空!');
		return;
	}
	var monthVal=Ext.getCmp('monthCom').getValue();
	if(!monthVal){
		Ext.Msg.alert('提示','月份不能为空!');
		return;
	}
	var reasExam=Ext.getCmp('comreason').getValue();
	if(!reasExam&&!scoreVal){
		Ext.Msg.alert('提示','成绩不能为空！');
		return;
	}
	var mon=tkMakeServerCall("web.DHCMgNurOperationExamComm","getMonth2",monthVal);
	var examDateret=examDate.split("-");
	var examDateyear=examDateret[0];
	var examDatemon=examDateret[1];
	if(examDateyear!=year&&examDatemon!=mon){
		alert("输入的考试日期和年份、月份不一致请重新输入!");
		return;
	}else if(examDateyear!=year){
		alert("输入的考试日期和年份不一致请重新输入!");
		return;
	}else if(examDatemon!=mon){
		alert("输入的考试日期和月份不一致请重新输入!");
		return;
	}
	var isRetVal=tkMakeServerCall('DHCMGNUR.MgNurOperationExam','isExist',nurseVal,operatorVal,monthVal,year);

	if(isRetVal&&!rw){
		Ext.Msg.alert('提示','此人该月该操作项目已经存在，请重新选择！');
		return;
	}
	var strVal="rw@"+rw+"^depVal@"+depVal+"^nurseVal@"+nurseVal+"^operatorVal@"+operatorVal+"^scoreVal@"+scoreVal+"^examDate@"+examDate+"^monthVal@"+monthVal+"^reasExam@"+reasExam+"^scoreYear@"+year+"^Flag@"+"Y";
	
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurOperationExam','Save',strVal);
	schDataList();
	schDataList();
	setItmEnable();
}
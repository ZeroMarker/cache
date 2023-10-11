var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
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
	//tabIndex:'0',
	listWidth:'190',
	//height:18,
	width:126,
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
	tabIndex:'0',
	listWidth:'220',
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
	pageSize:10000,
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
	pageSize:100000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
var passCom=new Ext.form.ComboBox({
	name:'passCom',
	id:'passCom',
	tabIndex:'0',
	x:0,y:0,
	//height:22,
	width:60,
	xtype:'combo',
	store:new Ext.data.JsonStore({
		data:[{
			desc:'不及格',
			id:'1'
		},{
			desc:'及格',
			id:'2'	
		},{
			desc:'良好',
			id:'3'
		},{
			desc:'优秀',
			id:'4'
		}],
		fields:['desc','id']
	}),
	displayField:'desc',
	valueField:'id',
	allowBlank:true,
	triggerAction:'all',
	mode:'local',
	forceSelection:true,
	//listEmptyText:'',
	value:''
});
//Ext.apply(Ext.form.VTypes, {
//  numeric: function (val, field) {
//      return /^\d+(\.\d{1,2})?$/.test(val);
//  },
//  numericText: '只能输入数字！'
//});
var scoreLabel=new Ext.form.TextField({
	id:'scoreLabel',
	fieldLabel:'成绩',
	width:40,           
  listeners:{
  	blur:function(scoreLabel){
  		var text=this.getValue();
  		Ext.getCmp('passCom').setValue('');
  		if(text){
  			var reg=/^(\d+)(\.\d{0,2})?$/;
  			if(!reg.test(text)){
  				Ext.Msg.alert('提示','只能输入非负浮点数(两位小数)！');
  				this.setValue('');
  				return;
  			}else{
  				if(parseFloat(text)>=parseFloat(90)){
  					Ext.getCmp('passCom').setValue(4);
  				}else if(parseFloat(text)>=parseFloat(80)){
  					Ext.getCmp('passCom').setValue(3);
  				}else if(parseFloat(text)>=parseFloat(60)){
  					Ext.getCmp('passCom').setValue(2);
  				}else if(parseFloat(text)<parseFloat(60)){
  					Ext.getCmp('passCom').setValue(1);
  				}
  			}
  			Ext.getCmp('comreason').setValue('');
  		}
  	}	
  }
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
var examDate=new Ext.form.DateField({
	name:'examdate',
	id:'examdate',
	//width:80,
	//format:'Y-m-d',
	xtype:'datefield',
	value:new Date(),  //.getFirstDateOfMonth(),
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
//判断安全组
	var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	var retDep=tkMakeServerCall("DHCMGNUR.MgPersons","getnursedep",session['LOGON.USERCODE']);
	var ha= new Hashtable();
  var tm=retDep.split('^')
  sethashvalue(ha,tm);
	var mygridpl=Ext.getCmp('mygridpl');
	mygridpl.setPosition(0,0);
	mygridpl.setSize(Width,Height);
	var mygrid=Ext.getCmp('mygrid');
	mygrid.setTitle("列表    "+'<font color=red>优秀（90分以上）、良好（80-90）、及格（60-80）、不及格（60以下）</font>')
	mygrid.getTopToolbar().hide();
	var tobar=new Ext.Toolbar({});
	//if(session['LOGON.GROUPDESC']=='护理部'||session['LOGON.GROUPDESC']=='Demo Group'){
	if((secGrpFlag=="demo")||(secGrpFlag=="hlb")){
		tobar.addItem('-','大科',larLocCom);
	}
//	tobar.addItem('-','<font color=red>* </font>科室',comboBoxDep);
//	tobar.addItem('-','<font color=red>* </font>季度',quarterCom());
//	tobar.addItem('-','<font color=red>* </font>护士',nurseCom);
	tobar.addItem('-','科室',comboBoxDep);
	tobar.addItem('-','季度',quarterCom());
	tobar.addItem('-','护士',nurseCom);
	tobar.addItem('-','成绩',scoreLabel);
	tobar.addItem('-','合格与否',passCom);
	var tmbar=new Ext.Toolbar({});
	tmbar.addItem('-','考试日期',examDate);
	tmbar.addItem('-','缺考原因',comReason);
	tmbar.addItem('-');
	tmbar.addButton({
		id:'addBtn',
		text:'增加',
		icon:'../images/uiimages/edit_add.png',
		handler:function(){addFun("");}
	});
	tmbar.addItem('-');
	tmbar.addButton({
		id:'updateBtn',
		disabled:true,
		text:'更新',
		icon:'../images/uiimages/reload.png',
		handler:function(){updateFun();}
	});
	tmbar.addItem('-');
	tmbar.addButton({
		id:'clearBtn',
		text:'清屏',
		icon:'../images/uiimages/clearscreen.png',
		handler:function(){clearFtn();}	
	});
//	tmbar.addItem('-');
//	tmbar.addButton({
//		id:'importBtn',
//		text:'导入',
//		handler:function(){importData();}	
//	});
//	tmbar.addItem('-');
//	tmbar.addButton({
//		id:'loadModel',
//		text:'<font color=red>数据模板下载</font>',
//		handler:function(){loadExcelModel();}
//	});
//	
//	tmbar.addItem('-','<font color="FF0000">*批量导入季度考试请务必按照模板整理数据</font>')
	var ttbar=new Ext.Toolbar({});
	ttbar.addItem('-','开始日期',StDate);
	ttbar.addItem('-','结束日期',EndDate);
	ttbar.addItem('-');
	ttbar.addButton({
		id:'schBtn',
		text:'查询',
		icon:'../images/uiimages/search.png',
		handler:function(){schData();}	
	});
	ttbar.addItem('-');
	ttbar.addButton({
		id:'invalBtn',
		text:'作废',
		icon:'../images/uiimages/cancel.png',
		handler:function(){invalRec("N");}
	});
	ttbar.addItem('-');
	ttbar.addButton({
		id:'exportbtn',
		text:'导出',
		icon:'../images/uiimages/redo.png',
		handler:function(){exportExcelData();}	
	})
	mygrid.getBottomToolbar().hide();
	var mbbar= new Ext.PagingToolbar({
		pageSize:25,
		store:mygrid.store,
		displayInfo:true,
		displayMsg:'显示第 {0} 条到 {1} 条记录,一共 {2} 条',
		emptyMsg:"没有记录"
	});
	mbbar.render(mygrid.bbar);
	tobar.render(mygrid.tbar);
	tmbar.render(mygrid.tbar);
	ttbar.render(mygrid.tbar);
	//if(session['LOGON.GROUPDESC']!='护理部'){
	if(secGrpFlag!="hlb"){
		comboBoxDep.store.on("beforeLoad",function(){
	  	var pward=comboBoxDep.lastQuery;
			//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC'];
	    var nurseString=session['LOGON.USERID']+"^"+secGrpFlag;
	    comboBoxDep.store.baseParams.typ="1";
	    comboBoxDep.store.baseParams.ward1=pward;        
			comboBoxDep.store.baseParams.nurseid=nurseString;
  	});
	}
	//if((session['LOGON.GROUPDESC']=="护理部")||(session['LOGON.GROUPDESC']=="护理部主任")||(session['LOGON.GROUPDESC']=="Demo Group")){
	if((secGrpFlag=="hlb")||(secGrpFlag=="hlbzr")||(secGrpFlag=="demo")){
		comboBoxDep.store.on('beforeload',function(){
				var pward=comboBoxDep.lastQuery;
				//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^"+larLocCom.getValue();
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+larLocCom.getValue();
	 			comboBoxDep.store.baseParams.typ="1";
	 			comboBoxDep.store.baseParams.ward1=pward;        
				comboBoxDep.store.baseParams.nurseid=nurseString;
		});
		comboBoxDep.addListener('click',function(){
			comboBoxDep.store.load({params:{start:0,limit:10000}})
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
			comboBoxDep.store.load({params:{start:0,limit:10000}})
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
				var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^"+larLocCom.getValue();;
	 			comboBoxDep.store.baseParams.typ="1";
	 			comboBoxDep.store.baseParams.ward1=pward;        
				comboBoxDep.store.baseParams.nurseid=nurseString;
			});
			larLocCom.on('select',function(combo,record,index){
				comboBoxDep.setValue('');
				//SchQual();
			})
		})
	}else if(secGrpFlag=="znurhead"){ //else if(session['LOGON.GROUPDESC']=="总护士长"){
		var comboboxDepStore=Ext.getCmp("comboboxDep").getStore();
		comboboxDepStore.load({params:{start:0,limit:10000}});
		comboboxDepStore.on('load',function(comboboxDepStore, records, options){						
			Ext.getCmp("comboboxDep").selectText();
		});	
	}else if(secGrpFlag=="nurhead"){ //else if((session['LOGON.GROUPDESC'].indexOf("护士长")>0)&&(session['LOGON.GROUPDESC'].indexOf("总")==-1)){
		comboBoxDep.setEditable(false);
	}
	
  comReason.store.on('beforeload',function(){
  	var reason=comReason.lastQuery;
  	comReason.store.baseParams.param="季度考试缺考原因";
  	comReason.store.baseParams.stype=reason;
  });
  nurseCom.store.on('beforeload',function(){
  	var nurse=nurseCom.lastQuery;
  	nurse!=undefined
  	nurseCom.store.baseParams.parr=nurse;
  	nurseCom.store.baseParams.sdep=Ext.getCmp('comboboxDep').getValue();
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
  mygrid.store.on('beforeload',function(){
  	var largeLoc=Ext.getCmp('larloccom').getValue();
	var depid=comboBoxDep.getValue();
  	//if((session['LOGON.GROUPDESC'].indexOf("护士长")>0)&&(session['LOGON.GROUPDESC'].indexOf("总")==-1)){
  	if(secGrpFlag=="nurhead"){
  		mygrid.store.baseParams.parr=ha.items('perNurDep')+"^"+Ext.getCmp('quarterCom').getValue()+"^"+nurseCom.getValue()+"^"+passCom.getValue()+"^"+examDate.getValue().format('Y-m-d')+"^"+largeLoc+"^"+session['LOGON.GROUPDESC']+"^"+session['LOGON.USERID']+"^"+depid;
  	}else{
  		mygrid.store.baseParams.parr=comboBoxDep.getValue()+"^"+Ext.getCmp('quarterCom').getValue()+"^"+nurseCom.getValue()+"^"+passCom.getValue()+"^"+examDate.getValue().format('Y-m-d')+"^"+largeLoc+"^"+session['LOGON.GROUPDESC']+"^"+session['LOGON.USERID'];
  	}
  })
  //if((session['LOGON.GROUPDESC'].indexOf("护士长")>0)&&(session['LOGON.GROUPDESC'].indexOf("总")==-1)){
  if(secGrpFlag=="nurhead"){
  	var comboBoxDepStore=comboBoxDep.getStore();
  	comboBoxDepStore.load({params:{start:0,limit:10000},callback:function(){
  		Ext.getCmp("comboboxDep").setValue(ha.items('perNurDep'));
  	}});
//  	comboBoxDepStore.on('load',function(comboBoxDepStore, records, options){
//			Ext.getCmp("comboboxDep").setValue(ha.items('perNurDep'));
//		});
  }
  schData();
  mygrid.on('rowclick',getVal);
  var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
  }
}
function loadExcelModel()
{
	var Template=WebIp+"/dthealth/med/Results/Template/协和医院季度考试录入模板.xls";
	var xls=new ActiveXObject("Excel.Application");
	var xlBook=xls.Workbooks.Add(Template);
	xls.Visible = true;
	var xlSheet=xlBook.ActiveSheet;
	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
  xls=null;
  xlBook=null; 
  xlSheet=null;
  
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
		fields:['QuarterDep','QuarterNur','QuarterDate','QuarterType','QuarterPass','QuarterResult','QuarterMissReason'],
		data:[],
		idIndex: 0
	});
	var parr=store.lastOptions.params.parr;
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"web.DHCMgNurQuarterExamComm:SearchNurseExam","parr$"+parr,"AddRec");
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
	if (confirm('确定作废选中的项？')) {
			var retInval=tkMakeServerCall('DHCMGNUR.MgNurQuarterExam','invalRec',rw,flag);
			if(retInval){
				Ext.Msg.alert('提示','执行成功！');
			}
			clearFtn();
			schData();
	}
}
function importData()
{
	var fpFileUpload=new Ext.FormPanel({  
   frame:true,  
   fileUpload:true,
   items:[{
     xtype:'textfield',  
     allowBlank:false,  
     fieldLabel:'选择文件',  
     inputType:'file', 
     name:'fileName',
		 id:'fileName',
		 blankText:'File can\'t not empty!',
		 anchor:'100%'
   }],
   buttonAlign:'center',
   buttons:[{
     text:'上传',
     handler:function(){
			var filePath=Ext.getCmp('fileName').getValue();
			var RealFilePath='';
			RealFilePath = filePath.replace(/\\/g, "\\\\");
			if(RealFilePath!=''){
				ReadExcel(RealFilePath);
				alert("导入完成！");
				winFielUpload.close();
			}else{
				alert("请选择文件！");
				return;
			}
		 }
   },{
     text:'取消',
     handler:function(){winFielUpload.close();}
	 }]
	});
	var winFielUpload=new Ext.Window({
		id:'win',
  	title:'文件上传',
  	width:350,
  	height:100,
  	layout:'fit',
  	autoDestory:true,
  	modal:true,
  	items:[fpFileUpload]
 	});
 	winFielUpload.show();
 	
}
function ReadExcel(RealFilePath)
{
	try{
		var filePath= RealFilePath;
    var oXL=new ActiveXObject("Excel.application");
    var oWB=oXL.Workbooks.open(filePath);
    oWB.worksheets(1).select();
    var oSheet=oWB.ActiveSheet;
    var rowLen=oSheet.usedrange.rows.count;	//Excel行
    var collen=oSheet.UsedRange.Columns.Count;	 //Excel列
		var colarr=['QuarterDep','QuarterNur','QuarterDate','QuarterType','QuarterResult','QuarterPass','QuarterMissReason']; //列对应字段和表中字段一致		
		for(var i=2;i<=rowLen;i++){
			var parm="";
			for(var col=1;col<=collen;col++){
				var cellvalue=oSheet.Cells(i,col).Value;
				if(colarr[col-1].indexOf('Date')!=-1){
					if(new Date(cellvalue).format('Y-m-d')!="NaN-NaN-NaN"){
						cellvalue=new Date(cellvalue).format('Y-m-d');
					}
				}
				if(cellvalue==undefined){cellvalue="";}
				parm=parm+colarr[col-1]+"|"+cellvalue+"^";
			}
			if(i==2){parm=parm.substring(0,parm.length-1);alert(parm);}
			//保存

			tkMakeServerCall('DHCMGNUR.MgNurQuarterExam','importData',parm);
		}
	}catch(e){
		alert(e.message);
	}
  oXL.Quit();
  CollectGarbage();
}
function clearFtn()
{
	//if(session['LOGON.GROUPDESC']=="护理部"){
	if((secGrpFlag=="hlb")||(secGrpFlag=="demo")){
		Ext.getCmp('comboboxDep').setValue('');
	}
	Ext.getCmp('quarterCom').setValue('');
	Ext.getCmp('nurseCom').setValue('');
	Ext.getCmp('scoreLabel').setValue('');
	Ext.getCmp('passCom').setValue('');
	Ext.getCmp('comreason').setValue('');
	Ext.getCmp('addBtn').enable();
  Ext.getCmp('updateBtn').disable();
	schData();
}
function getVal()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的行！');
		return;
	}
	var rw=rowObj[0].get('rw');
	var val=tkMakeServerCall('DHCMGNUR.MgNurQuarterExam','getVal',rw);
	var ht=new Hashtable();
  var tt=val.split('^')
  sethashvalue(ht,tt);
  var quDep=Ext.getCmp('comboboxDep');
  quDep.store.load({params:{start:0,limit:1000},callback:function(){
  	quDep.setValue(ht.items('QuarterDep'));
  }});
  var quarter=Ext.getCmp('quarterCom');
  quarter.setValue(ht.items('QuarterType'));
  var nurse=Ext.getCmp('nurseCom');
  nurse.store.load({params:{start:0,limit:100000},callback:function(){
  	nurse.setValue(ht.items('QuarterNur')); 		
  }});
  var score=Ext.getCmp('scoreLabel');
  score.setValue(ht.items('QuarterResult'));
  var passval=Ext.getCmp('passCom');
  passval.setValue(ht.items('QuarterPass'));
  var examdate=Ext.getCmp('examdate');
  examdate.setValue(ht.items('QuarterDate'));
  var reason=Ext.getCmp('comreason');
  reason.store.load({params:{start:0,limit:100},callback:function(){
  	reason.setValue(ht.items('QuarterMissReason').replace('__','||'));		
  }});
  Ext.getCmp('addBtn').disable();
  Ext.getCmp('updateBtn').enable();
}
function updateFun()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的行！');
		return;
	}
	var rw=rowObj[0].get('rw');
	addFun(rw);
}
function addFun(rw)
{
	var dep=Ext.getCmp('comboboxDep').getValue();
	if(!dep){
		Ext.Msg.alert('提示','请选择科室！');
		return;
	}
	var quarter=Ext.getCmp('quarterCom').getValue();
	if(!quarter){
		Ext.Msg.alert('提示','请选择季度！');
		return;
	}
	var nurse=Ext.getCmp('nurseCom').getValue();
	if(!nurse){
		Ext.Msg.alert('提示','请选择护士！');
		return;
	}
	var score=Ext.getCmp('scoreLabel').getValue();
	var passval=Ext.getCmp('passCom').getValue();
	if((score)&&(!passval)){
		Ext.Msg.alert('提示','请选择合格与否！');
		return;
	}
	var date=Ext.getCmp('examdate').getValue();
	if(!date){
		Ext.Msg.alert('提示','请填写考试日期！');
		return;
	}else{
		if(date instanceof Date){
			date=date.format('Y-m-d');
		}
	}
	var reason=Ext.getCmp('comreason').getValue();
	if((!score)&&(!reason)){
		Ext.Msg.alert('提示','缺考原因不能为空！');
		return;
	}
	var strVal=date+"^"+quarter+"^"+nurse+"^"+rw;
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurQuarterExam','isExistData',strVal);
	if((retVal!=0)){
		Ext.Msg.alert('提示','此人成绩已经存在，请勿重复添加！');
		return;
	}
	var parr="dep@"+dep+"^quarter@"+quarter+"^nurse@"+nurse+"^score@"+score+"^passval@"+passval+"^date@"+date+"^reason@"+reason+"^rw@"+rw;
	tkMakeServerCall('DHCMGNUR.MgNurQuarterExam','Save',parr);
	schData();
}
function schData()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({
		params:{
			start:0,
			limit:25	
		}	
	});
	Ext.getCmp('addBtn').enable();
  Ext.getCmp('updateBtn').disable();
}
var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;

var bbar1 = new Ext.Toolbar(["<font color=red>开始日期</font>",{
	id:'stdate',
	xtype:'datefield',
	//format:'Y-m-d',
	value:new Date().getFirstDateOfMonth(),
	listeners:{
		select:function(dateField,date){
			var endDate=Ext.getCmp('enddate').getValue();
			if(endDate!=""){
				var flag=date.between(date,endDate);
				if(!flag){
					alert("开始日期不能大于结束日期！");
				  Ext.getCmp('stdate').setValue("");
				}				
			}
		}
	}
},"-","<font color=red>结束日期</font>",{
	id:'enddate',
	//format:'Y-m-d',
	xtype:'datefield',
	value:new Date().getLastDateOfMonth(),
	listeners:{
		select:function(dateField,date){
			var stDate=Ext.getCmp('stdate').getValue();
			if(stDate!=""){
				var flag=date.between(stDate,date);
				if(!flag){
					alert("结束日期不能小于开始日期！");
					Ext.getCmp('enddate').setValue("");	
				}
			}
		}
	}
},"-",{
	id:'schdatabtn',
	text:'查询',
	xtype:'button',
	width:60,
	//style : 'background-color:#00FFFF',
	icon:'../images/uiimages/search.png',
	handler:function(){schRecData();clearItmVal();}
},'-',{
	id:'adddatabtn',
	text:'增加',
	xtype:'button',
	width:60,
	//ctCls:'x-btn-separator',
	//style : {marginLeft:'5px'},
	icon:'../images/uiimages/edit_add.png',
	handler:function(){saveData('');}
},'-',{
	id:'addupdatebtn',
	text:'编辑',
	xtype:'button',
	width:60,
	//style : 'background-color:#00FFFF',
	ctCls:'my-toolbar',
	icon:'../images/uiimages/pencil.png',
	handler:function(){updateRecVal();}
},"-",{
	id:'addexportbtn',
	text:'导出',
	width:60,
	//style : 'background-color:#00FFFF',
	icon:'../images/uiimages/redo.png',
	handler:function(){exportExcelData();}
},"-",{
	id:'clearallbtn',
	text:'清屏',
	width:60,
	//style:'background-color:#00FFFF',
	icon:'../images/uiimages/clearscreen.png',
	handler:function(){clearAllItems();}
}]);
//立项日期Lab
var researchDateLab=new Ext.form.Label({
	name:'researchdatelab',
	id:'researchdatelab',
	//width:80,
	text:'立项日期',
	x:40,y:10
});
//立项日期
var researchDate=new Ext.form.DateField({
	id:'researchdate',
	width:100,
	//format:'Y-m-d',
	xtype:'datefield',
	x:100,y:5
});
//立项等级Lab
var researchGradeLab=new Ext.form.Label({
	name:'researchgradelab',
	id:'researchgradelab',
	width:80,
	text:'立项等级',
	x:255,y:10
});
///立项等级
var researchGrade = new Ext.form.ComboBox({
	name:'researchgrade',
	id:'researchgrade',
	x:315,y:5,
	//height:22,
	width:150,
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
//立项名称Lab
var researchNameLab=new Ext.form.Label({
	name:'researchnamelab',
	id:'researchnamelab',
	width:80,
	text:'立项名称',
	x:518,y:10
});
//立项名称
var researchName=new Ext.form.TextField({
	id:'researchname',
	width:180,
	x:580,y:5
});
//预计完成日期Lab
var expecteDateLab=new Ext.form.Label({
	name:'expectedatelab',
	id:'expectedatelab',
	//width:80,
	text:'预计完成日期',
	x:12,y:40
});
//预计完成日期
var expecteDate=new Ext.form.DateField({
	id:'expectedate',
	width:100,
	//format:'Y-m-d',
	xtype:'datefield',
	x:100,y:35
});
//项目类型Lab
var projectTypeLab=new Ext.form.Label({
	id:'projecttypelab',
	name:'projecttypelab',
	width:'80',
	text:'项目类型',
	x:255,y:40
});
//项目类型
var projectType = new Ext.form.ComboBox({
	name:'projecttype',
	id:'projecttype',
	x:315,y:35,
	//height:22,
	width:150,
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
//获批科研经费Lab
var proExpenseLab=new Ext.form.Label({
	id:'proexpenselab',
	name:'proexpenselab',	
	width:100,
	text:'获批科研经费',
	x:490,y:40
});
//获批科研经费
var proExpense=new Ext.form.TextField({
	id:'proexpense',
	width:180,
	x:580,y:35	
});
//总负责人Lab
var firResponserLab=new Ext.form.Label({
	id:'firresponserlab',
	name:'firresponserlab',
	text:'总负责人',
	x:40,y:70	
});
//总负责人
var firResponser=new Ext.form.ComboBox({
	name:'firresponser',
	id:'firresponser',
	x:100,y:65,
	//height:22,
	width:100,
	listWidth:185,
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
	//queryParam:'',
	forceSelection:true,
	minChars:1,
	pageSize:10000,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//总负责人职务Lab
var firResponHeadLab=new Ext.form.Label({
	id:'firresponheadlab',
	name:'firresponheadlab',
	text:'总负责人职务',
	x:228,y:70	
});
//总负责人职务
var firResponHead = new Ext.form.ComboBox({
	name:'firresponhead',
	id:'firresponhead',
	x:315,y:65,
	//height:22,
	width:150,
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
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//总负责职称Lab
var firResponDutyLab=new Ext.form.Label({
	id:'firrespondutylab',
	name:'firrespondutylab',
	text:'总负责人职称',
	x:490,y:70	
});
//总负责人职称
var firResponDuty = new Ext.form.ComboBox({
	name:'firresponduty',
	id:'firresponduty',
	x:580,y:65,
	//height:22,
	width:180,
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
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//总负责人层级Lab
var firResponLevLab=new Ext.form.Label({
	id:'firresponlevlab',
	name:'firresponllab',
	text:'总负责人层级',
	x:13,y:100	
});
//总负责人层级
var firResponLev = new Ext.form.ComboBox({
	name:'firresponlev',
	id:'firresponlev',
	x:100,y:95,
	height:22,
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
	//queryParam:'par',
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//总负责人所在大科Lab
var firResponBigLab=new Ext.form.Label({
	id:'firresponbiglab',
	text:'总负责人大科',
	x:228,y:100
});
//总负责人所在大科
var firResponBig= new Ext.form.ComboBox({
	name:'firresponbig',
	id:'firresponbig',
	x:315,y:95,
	//height:22,
	width:150,
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
				'name':'loccode',
				'mapping':'loccode'
			}, {
				'name':'locdesc',
				'mapping':'locdesc'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurSchComm',
			methodName:'SearchLargeLoc',
			type:'Query'
		}	
	}),
	displayField:'locdesc',
	valueField:'loccode',
	triggerAction:'all',
	hideTrigger : false,
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//总负责人人所在病房Lab
var firResponLocLab=new Ext.form.Label({
	id:'firresponloclab',
	text:'总负责人病房',
	x:490,y:100
});
//总负责人所在病房
var firResponLoc=new Ext.form.ComboBox({
	name:'firresponloc',
	id:'firresponloc',
	listWidth:'220',
	height:22,
	width:180,
	x:580,y:95,
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
	xtype:'combo',
	displayField:'ctlocDesc',
	valueField:'CtLocDr',
	hideTrigger:false,
	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:1000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二负责人Lab
var secResponLab=new Ext.form.Label({
	id:'secresponlab',
	text:'第二负责人',
	width:80,
	x:28,y:130
});
//第二负责人
var secRespon=new Ext.form.ComboBox({
	name:'secrespon',
	id:'secrespon',
	x:100,y:125,
	height:22,
	width:100,
	listWidth:185,
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
	//queryParam:'',
	forceSelection:true,
	minChars:1,
	pageSize:10000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二负责人职务Lab
var secResponHeadLab=new Ext.form.Label({
	id:'secresponheadlab',
	text:'第二负责人职务',
	width:100,
	x:215,y:130	
});
var secResponHead = new Ext.form.ComboBox({
	name:'secresponhead',
	id:'secresponhead',
	x:315,y:125,
	//height:22,
	width:150,
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
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二负责人职称Label
var secResponDutyLab=new Ext.form.Label({
	id:'secrespondutylab',
	text:'第二负责人职称',
	x:478,y:130,
	width:100	
});
//第二负责人职称
var secResponDuty = new Ext.form.ComboBox({
	name:'secresponduty',
	id:'secresponduty',
	x:580,y:125,
	//height:22,
	width:180,
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
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});

///第二负责人层级Lab
var secResponLevLab=new Ext.form.Label({
	id:'secresponlevlab',
	text:'第二负责人层级',
	width:100,
	x:0,y:160	
});
//第二负责人层级
var secResponLev = new Ext.form.ComboBox({
	name:'secresponlev',
	id:'secresponlev',
	x:100,y:155,
	height:22,
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
	//queryParam:'par',
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二负责人所在大科Lab
var secResponBigLab=new Ext.form.Label({
	id:'secresponbiglab',
	text:'第二负责人大科',
	x:214,y:160
});
//第二负责人所在大科
var secResponBig= new Ext.form.ComboBox({
	name:'secresponbig',
	id:'secresponbig',
	x:315,y:155,
	//height:22,
	width:150,
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
				'name':'loccode',
				'mapping':'loccode'
			}, {
				'name':'locdesc',
				'mapping':'locdesc'
			}]
		}),
		baseParams:{
			className:'web.DHCMgNurSchComm',
			methodName:'SearchLargeLoc',
			type:'Query'
		}	
	}),
	displayField:'locdesc',
	valueField:'loccode',
	triggerAction:'all',
	hideTrigger : false,
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二负责人所在病房Lab
var secResponLocLab=new Ext.form.Label({
	id:'secresponloclab',
	text:'第二负责人病房',
	x:478,y:160
});
//第二负责人所在病房
var secResponLoc=new Ext.form.ComboBox({
	name:'secresponloc',
	id:'secresponloc',
	listWidth:'220',
	height:22,
	width:180,
	x:580,y:155,
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
	xtype:'combo',
	displayField:'ctlocDesc',
	valueField:'CtLocDr',
	hideTrigger:false,
	queryParam:'ward1',
	forceSelection:true,
	triggerAction:'all',
	minChars:1,
	pageSize:1000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第三负责人Lab
var thirdResponLab=new Ext.form.Label({
	id:'thirdresponlab',
	text:'第三负责人',
	//width:80,
	x:28,y:190
});
//第三负责人
var thirdRespon=new Ext.form.ComboBox({
	name:'thirdrespon',
	id:'thirdrespon',
	x:100,y:185,
	height:22,
	width:100,
	listWidth:185,
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
	forceSelection:true,
	minChars:1,
	pageSize:10000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//其他参与者Lab
var otherResponLab=new Ext.form.Label({
	id:'otherresponLab',
	text:'其他参与者',
	width:80,
	x:242,y:190
});
//其他参与者
var otherRespon=new Ext.form.ComboBox({
	name:'otherrespon',
	id:'otherrespon',
	x:315,y:185,
	//height:22,
	width:150,
	listWidth:185,
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
	forceSelection:true,
	minChars:1,
	pageSize:10000,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//结题日期Lab
var concludeDateLab=new Ext.form.Label({
	name:'concludedatelab',
	id:'concludedatelab',
	width:80,
	text:'结题日期',
	x:518,y:190
});
//结题日期
var concludeDate=new Ext.form.DateField({
	id:'concludedate',
	width:180,
	//format:'Y-m-d',
	xtype:'datefield',
	x:580,y:185
});
//备注
var proRemarkLab=new Ext.form.Label({
	id:'proremarklab',
	text:'备注',
	width:100,
	x:68,y:220	
});
var proRemark=new Ext.form.TextField({
	id:'proremark',
	width:366,
	x:100,y:215
});
function clearAllItems()
{
	Ext.getCmp('addpanel').items.each(function(item,index,length){
		if(item.getXType()=="combo"){
			if(item.getId()&&(Ext.getCmp(item.getId()))){
				Ext.getCmp(item.getId()).setValue('');
			}
		}
		if(item.getXType()=="textfield"){
			if(item.getId()&&(Ext.getCmp(item.getId()))){
				Ext.getCmp(item.getId()).setValue('');
			}
		}
		if(item.getXType()=="datefield"){
			if(item.getId()&&(Ext.getCmp(item.getId()))){
				Ext.getCmp(item.getId()).getValue('');
			}
		}
	});
	schRecData();
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
	for(i=1;i <temp_obj.length;i++){
		//显示列的列标题
		xlSheet.Cells(1,i).Value = cm.getColumnHeader(temp_obj[i]);
		xlSheet.Cells(1,i).Font.Bold = true;//加粗
	}
	var store = grid.getStore();
	var recordCount = store.getCount();
	
	arrgrid = new Array();
	var myfields=[];
	for(var i = 0;i<cm.getColumnCount();i++){
		//var itmName=cm.getColumnHeader(i);
		var itmName=cm.getDataIndex(i);
		 if(itmName){
		 	myfields.push(itmName);
		 }
	}
	var tmpStore=new Ext.data.JsonStore({
		//fields:['QuarterDep','QuarterNur','QuarterDate','QuarterType','QuarterPass','QuarterResult','QuarterMissReason'],
		fields:myfields,
		data:[],
		idIndex: 0
	});
	var parr=store.lastOptions.params.parr;
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"web.DHCMgNurResearchPrizeComm:SchResProManageLst","parr$"+parr,"AddRec");
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
function createPanel()
{
	var panel=new Ext.Panel({
		title:'', 
		id:'addpanel',
		height:Height/2-20,  
   	width:Width,
   	frame:true,
   	autoScroll:true,
   	x:0,
   	y:Height/2-50,
   	tbar:bbar1,
   	items:[researchDateLab,researchDate,researchGradeLab,researchGrade,researchNameLab,researchName,expecteDateLab,expecteDate,
   		projectTypeLab,projectType,proExpenseLab,proExpense,firResponserLab,firResponser,firResponHeadLab,firResponHead,
   		firResponDutyLab,firResponDuty,firResponLevLab,firResponLev,firResponBigLab,firResponBig,firResponLocLab,firResponLoc,
   		secResponLab,secRespon,secResponHeadLab,secResponHead,secResponDutyLab,secResponDuty,secResponLevLab,secResponLev,
   		secResponBigLab,secResponBig,secResponLocLab,secResponLoc,thirdResponLab,thirdRespon,otherResponLab,otherRespon,
   		concludeDateLab,concludeDate,proRemarkLab,proRemark],
    layout:'absolute'
	});
	return panel;
}
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	createGrid();
	var grid=Ext.getCmp('mygrid');
	researchGrade.store.on('beforeload',function(){
		researchGrade.store.baseParams.par="科研立项等级";
  	researchGrade.store.baseParams.stype=researchGrade.lastQuery;		
	});
	projectType.store.on('beforeload',function(){
		projectType.store.baseParams.par="科研项目类型";
		projectType.store.baseParams.stype=projectType.lastQuery;
	});
	firResponser.store.on('beforeload',function(){
		firResponser.store.baseParams.parr=firResponser.lastQuery;
		if(secGrpFlag=="nurhead"){
			firResponser.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}	
	});
	firResponHead.store.on('beforeload',function(){
		firResponHead.store.baseParams.par='职务',
		firResponHead.store.baseParams.stype=firResponHead.lastQuery;
	});
	firResponDuty.store.on('beforeload',function(){
		firResponDuty.store.baseParams.par="聘任专业技术职称",
		firResponDuty.store.baseParams.stype=firResponDuty.lastQuery;	
	});
	firResponLev.store.on('beforeload',function(){
		firResponLev.store.baseParams.par="护士层级";
		firResponLev.store.baseParams.stype=firResponLev.lastQuery;	
	});
	firResponLoc.store.on('beforeload',function(){
		var pward=firResponLoc.lastQuery;
		//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^";
	 	firResponLoc.store.baseParams.typ="1";
	 	firResponLoc.store.baseParams.ward1=pward;        
		firResponLoc.store.baseParams.nurseid=nurseString;
	});
	secRespon.store.on('beforeload',function(){
		secRespon.store.baseParams.parr=secRespon.lastQuery;
		if(secGrpFlag=="nurhead"){
			secRespon.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}		
	});
	secResponHead.store.on('beforeload',function(){
		secResponHead.store.baseParams.par="职务",
		secResponHead.store.baseParams.stype=secResponHead.lastQuery;	
	});
	secResponDuty.store.on('beforeload',function(){
		secResponDuty.store.baseParams.par="聘任专业技术职称";
		secResponDuty.store.baseParams.stype=secResponDuty.lastQuery;	
	});
	secResponLev.store.on('beforeload',function(){
		secResponLev.store.baseParams.par="护士层级";
		secResponLev.store.baseParams.stype=secResponLev.lastQuery;	
	});
	secResponLoc.store.on('beforeload',function(){
		//var flagStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var flagStr=session['LOGON.USERID']+"^"+secGrpFlag+"^";
	 	secResponLoc.store.baseParams.typ="1";
	 	secResponLoc.store.baseParams.ward1=secResponLoc.lastQuery;     
		secResponLoc.store.baseParams.nurseid=flagStr;
	});
	thirdRespon.store.on('beforeload',function(){
		thirdRespon.store.baseParams.parr=thirdRespon.lastQuery;
		if(secGrpFlag=="nurhead"){
			thirdRespon.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	otherRespon.store.on('beforeload',function(){
		otherRespon.store.baseParams.parr=otherRespon.lastQuery;
		if(secGrpFlag=="nurhead"){
			otherRespon.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}	
	});
	grid.store.on('beforeload',function(){
		var stDate=Ext.getCmp('stdate').getValue();
		if(stDate instanceof Date){
			stDate=stDate.format('Y-m-d');
		}
		var endDate=Ext.getCmp('enddate').getValue();
		if(endDate instanceof Date){
			endDate=endDate.format('Y-m-d');
		}
		var proDate=Ext.getCmp('researchdate').getValue();
		if(proDate instanceof Date){
			proDate=proDate.format('Y-m-d');
		}
		var firResponser=Ext.getCmp('firresponser').getValue();
		var proName=Ext.getCmp('researchname').getValue();
		grid.store.baseParams.parr=stDate+"^"+endDate+"^"+proDate+"^"+firResponser+"^"+proName;
	})
	schRecData();
	grid.on('rowclick',getRowData);
	setBtnEnable();
}
function setBtnEnable()
{
	Ext.getCmp('adddatabtn').enable();
	Ext.getCmp('addupdatebtn').disable();
}
function setBtnDisable()
{
	Ext.getCmp('adddatabtn').disable();
	Ext.getCmp('addupdatebtn').enable();
}
function getRowData()
{
	var grid=Ext.getCmp('mygrid');
	var rowObj=grid.getSelectionModel().getSelections();
	if(rowObj.length==0){Ext.Msg.alert('提示','请选择一条记录！');return;}
	var rw=rowObj[0].get('rw');
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurResearchProManage','getVal',rw);
	var ha=new Hashtable();
	var tm=retVal.split("^");
	sethashval(ha,tm);
	Ext.ComponentMgr.all.each(function(item,index,length){
		if(item.getXType()=="combo"){
			Ext.getCmp(item.getId()).store.load({params:{start:0,limit:2000},callback:function(){
				if(ha.items(item.getId())!=""){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
				}else{
					if(item.getId()&&(Ext.getCmp(item.getId()))){
	 					Ext.getCmp(item.getId()).setValue('');
	 				}	
				}
			}});
		}
		if(item.getXType()=="textfield"){
			if(ha.items(item.getId())){
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
				}
			}else{
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue('');
				}
			}
		}
		if(item.getXType()=="datefield"){
			if(ha.items(item.getId())){
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
				}	
			}else{
				if(item.getId()&&(Ext.getCmp(item.getId()))){
					Ext.getCmp(item.getId()).getValue('');
				}
			}
		}
	});
	setBtnDisable();
}
function updateRecVal()
{
	var mygrid=Ext.getCmp('mygrid')
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	saveData(rw);
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
function schRecData()
{
	var grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:25}});
	clearItmVal();
	setBtnEnable();
}
function saveData(rw)
{
	//alert('')
	var researchStDate=Ext.getCmp('researchdate').getValue();
	if(!researchStDate){
		Ext.Msg.alert('提示','请选择立项日期！');
		return;
	}else{
		if(researchStDate instanceof Date){
			researchStDate=researchStDate.format('Y-m-d');
		}
	}
	var researchGrade=Ext.getCmp('researchgrade').getValue();
	var researchName=Ext.getCmp('researchname').getValue();
	if(!researchName){
		Ext.Msg.alert('提示','请填写立项名称');
		return;
	}else{
		researchName=researchName.replace(/(^\s*)|(\s*$)/g, "")
	}
	var researchEndDate=Ext.getCmp('expectedate').getValue();
	if(!researchEndDate){
		Ext.Msg.alert('提示','请填写预计完成日期！');
		return;
	}else{
		if(researchEndDate instanceof Date){
			researchEndDate=researchEndDate.format('Y-m-d');
		}
	}
	var aaa=tkMakeServerCall("DHCMGNUR.MgNurResearchProManage","datethan",researchStDate,researchEndDate);
	if(aaa==1){
		Ext.Msg.alert('提示','预计完成日期必须大于或者等于立项日期,请重新输入!');
		return;
	}
	var researchType=Ext.getCmp('projecttype').getValue();
	if(!researchType){
		Ext.Msg.alert('提示','请选择项目类型！');
		return;
	}
	var researchExpense=Ext.getCmp('proexpense').getValue();
	var resFirResponser=Ext.getCmp('firresponser').getValue();
	if(!resFirResponser){
		Ext.Msg.alert('提示','请选择总负责人！');
		return;
	}
	var resFirResponHead=Ext.getCmp('firresponhead').getValue();
	var resFirResponDuty=Ext.getCmp('firresponduty').getValue();
	var resFirResponLev=Ext.getCmp('firresponlev').getValue();
	var resFirResponBig=Ext.getCmp('firresponbig').getValue();
	var resFirResponLoc=Ext.getCmp('firresponloc').getValue();
	var resSecRespon=Ext.getCmp('secrespon').getValue();
	var resSecResponHead=Ext.getCmp('secresponhead').getValue();
	var resSecResponDuty=Ext.getCmp('secresponduty').getValue();
	var resSecResponLev=Ext.getCmp('secresponlev').getValue();
	var resSecResponBig=Ext.getCmp('secresponbig').getValue();
	var resSecResponLoc=Ext.getCmp('secresponloc').getValue();
	var resThirdRespon=Ext.getCmp('thirdrespon').getValue();
	var resOtherRespon=Ext.getCmp('otherrespon').getValue();
	var resConcludeDate=Ext.getCmp('concludedate').getValue();
	if(resConcludeDate instanceof Date){
		resConcludeDate=resConcludeDate.format('Y-m-d');
	}
	var resProRemark=Ext.getCmp('proremark').getValue();
	var isExistStr=researchStDate+"^"+researchName+"^"+resFirResponser;
	var existRetVal=tkMakeServerCall('DHCMGNUR.MgNurResearchProManage','isExist',isExistStr)
	//return;
	if(existRetVal&&!rw){
		Ext.Msg.alert('提示','此人科研项目已经存在，请确认！');
		return;
	}	
	var parr="rw@"+rw+"^researchStDate@"+researchStDate+"^researchGrade@"+researchGrade+"^researchName@"+researchName
	+"^researchEndDate@"+researchEndDate+"^researchType@"+researchType+"^researchExpense@"+researchExpense
	+"^resFirResponser@"+resFirResponser+"^resFirResponHead@"+resFirResponHead+"^resFirResponDuty@"+resFirResponDuty
	+"^resFirResponLev@"+resFirResponLev+"^resFirResponBig@"+resFirResponBig+"^resFirResponLoc@"+resFirResponLoc
	+"^resSecRespon@"+resSecRespon+"^resSecResponHead@"+resSecResponHead+"^resSecResponDuty@"+resSecResponDuty
	+"^resSecResponLev@"+resSecResponLev+"^resSecResponBig@"+resSecResponBig+"^resSecResponLoc@"+resSecResponLoc
	+"^resThirdRespon@"+resThirdRespon+"^resOtherRespon@"+resOtherRespon+"^resConcludeDate@"+resConcludeDate
	+"^resProRemark@"+resProRemark;
	//alert(parr)
	tkMakeServerCall('DHCMGNUR.MgNurResearchProManage','Save',parr);
	schRecData();
	clearItmVal();
	setBtnEnable();
	clearAllItems();
}
function clearItmVal()
{
	Ext.ComponentMgr.all.each(function(item,index,length){
		if(item.getXType()=="combo"){
			Ext.getCmp(item.getId()).store.load({params:{start:0,limit:2000},callback:function(){
				if((item.getId()!='firresponser')){
					Ext.getCmp(item.getId()).setValue('');
				}
			}});
		}
		if(item.getXType()=="textfield"){
			if(item.getId()!='researchname'){
				Ext.getCmp(item.getId()).setValue('');
			}
		}
		if(item.getXType()=="datefield"){
			if((item.getId()!='stdate')&&(item.getId()!='enddate')){//&&(item.getId()!='researchdate')
				Ext.getCmp(item.getId()).setValue('');
			}
		}
	});
//Ext.getCmp('researchDateLab').setValue('');
//	Ext.getCmp('researchdate').setValue('');
//	Ext.getCmp('researchgrade').setValue('');
//	Ext.getCmp('researchname').setValue('');
//	Ext.getCmp('expectedate').setValue('');
//	Ext.getCmp('projecttype').setValue('');
//	Ext.getCmp('proexpense').setValue('');
//	Ext.getCmp('firresponser').setValue('');
//	Ext.getCmp('firresponhead').setValue('');
//	Ext.getCmp('firresponduty').setValue('');
//	Ext.getCmp('firresponlev').setValue('');
//	Ext.getCmp('firresponbig').setValue('');
//	Ext.getCmp('firresponloc').setValue('');
//	Ext.getCmp('secrespon').setValue('');
//	Ext.getCmp('secresponhead').setValue('');
//	Ext.getCmp('secresponduty').setValue('');
//	Ext.getCmp('secresponlev').setValue('');
//	Ext.getCmp('secresponbig').setValue('');
//	Ext.getCmp('secresponloc').setValue('');
//	Ext.getCmp('thirdrespon').setValue('');
//	Ext.getCmp('otherrespon').setValue('');
//	Ext.getCmp('concludedate').setValue('');
//	Ext.getCmp('proremark').setValue('');
}
function createGrid()
{
	var ttable=createListTable();
	var tpanel=createPanel();
	var mainpanel=new Ext.Panel({
		id:'mainpanle',
		x:0,y:0,
    header:false,
    width:Width,
    height:Height,
    plain:true,
    //layout:'border',
    items:[ttable,tpanel]
	});
	var gform=Ext.getCmp('gform');
	gform.add(mainpanel);
	gform.doLayout();
	Ext.getCmp('mygrid').getTopToolbar().hide();
}
function createListTable()
{
	var colModelStr = new Array();
	var colData = new Array();
	colModelStr.push(new Ext.grid.RowNumberer());
	colModelStr.push({header:'项目等级',width:80,dataIndex:'ProjectGrade'});
	colData.push({'name':'ProjectGrade','mapping':'ProjectGrade'});
	colModelStr.push({header:'项目名称',width:200,dataIndex:'ProjectName'});
	colData.push({'name':'ProjectName','mapping':'ProjectName'});
	colModelStr.push({header:'项目类型',width:80,dataIndex:'ProjectType'});
	colData.push({'name':'ProjectType','mapping':'ProjectType'});
	colModelStr.push({header:'立项日期',width:100,dataIndex:'ProjectDate'});
	colData.push({'name':'ProjectDate','mapping':'ProjectDate'});
	colModelStr.push({header:'预计完成日期',width:100,dataIndex:'FinishDate'});
	colData.push({'name':'FinishDate','mapping':'FinishDate'});
	colModelStr.push({header:'总负责人',width:80,dataIndex:'FirstResponser'});
	colData.push({'name':'FirstResponser','mapping':'FirstResponser'});
	colModelStr.push({header:'总负责人职务',width:100,dataIndex:'FirResponerHead'});
	colData.push({'name':'FirResponerHead','mapping':'FirResponerHead'});
	colModelStr.push({header:'总负责人职称',width:100,dataIndex:'FirResponerDuty'});
	colData.push({'name':'FirResponerDuty','mapping':'FirResponerDuty'});
	colModelStr.push({header:'总负责人层级',width:100,dataIndex:'FirResponerLev'});
	colData.push({'name':'FirResponerLev','mapping':'FirResponerLev'});
	colModelStr.push({header:'总负责人大科',width:100,dataIndex:'FirResponerBig'});
	colData.push({'name':'FirResponerBig','mapping':'FirResponerBig'});
	colModelStr.push({header:'总负责人病房',width:150,dataIndex:'FirResponerLoc'});
	colData.push({'name':'FirResponerLoc','mapping':'FirResponerLoc'});
	colModelStr.push({header:'第二负责人',width:100,dataIndex:'SecondResponser'});
	colData.push({'name':'SecondResponser','mapping':'SecondResponser'});
	colModelStr.push({header:'第二负责人职务',width:120,dataIndex:'SecResponerHead'});
	colData.push({'name':'SecResponerHead','mapping':'SecResponerHead'});
	colModelStr.push({header:'第二负责人职称',width:120,dataIndex:'SecResponerDuty'});
	colData.push({'name':'SecResponerDuty','mapping':'SecResponerDuty'});
	colModelStr.push({header:'第二负责人层级',width:120,dataIndex:'SecResponerLev'});
	colData.push({'name':'SecResponerLev','mapping':'SecResponerLev'});
	colModelStr.push({header:'第二负责人大科',width:120,dataIndex:'SecResponerBig'});
	colData.push({'name':'SecResponerBig','mapping':'SecResponerBig'});
	colModelStr.push({header:'第二负责人病房',width:120,dataIndex:'SecResponerLoc'});
	colData.push({'name':'SecResponerLoc','mapping':'SecResponerLoc'});
	colModelStr.push({header:'第三负责人',width:100,dataIndex:'ThirdResponser'});
	colData.push({'name':'ThirdResponser','mapping':'ThirdResponser'});
	colModelStr.push({header:'其他人员',width:100,dataIndex:'OtherResponser'});
	colData.push({'name':'OtherResponser','mapping':'OtherResponser'});
	colModelStr.push({header:'获批经费',width:80,dataIndex:'ProjectSpotExpense'});
	colData.push({'name':'ProjectSpotExpense','mapping':'ProjectSpotExpense'});
	colModelStr.push({header:'结题日期',width:100,dataIndex:'ConcludeDate'});
	colData.push({'name':'ConcludeDate','mapping':'ConcludeDate'});
	colModelStr.push({header:'备注',width:80,dataIndex:'ProjectRemark'});
	colData.push({'name':'ProjectRemark','mapping':'ProjectRemark'});
	colModelStr.push({header:"rw",hidden:true,width:30,dataIndex:'rw'});
	colData.push({'name':'rw','mapping':'rw'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results',
			fields:colData
		}),
		baseParams:{
			className:'web.DHCMgNurResearchPrizeComm',
			methodName:'SchResProManageLst',
			type:'RecQuery'
		},
		listeners:{
			beforeload:function(thisstore){
				//thisstore.baseParams.par=paid+"|"+"@"+itmCount+"@Y@"+Ext.getCmp('myRadioGroup').getValue().inputValue;
			},
			load:function(thisstore,recodes,o){
			}	
		}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid',
		title:'科研立项',
		region:'center',
		split: true,
		height:Height/2+20,
		width:Width,
		x:0,y:0,
		collapsible: false,
		margins:'0 0 0 0',
		store: store,
		tbar: [],
		bbar: new Ext.PagingToolbar({ 
      pageSize: 25, 
      store: store, 
      displayInfo: true, 
      displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
      emptyMsg: "没有记录",
      onFirstLayout :function(){
      	if(this.dsLoaded){
           this.onLoad.apply(this, this.dsLoaded);
        }
        if(this.rendered && this.refresh){
           this.refresh.hide();
        }	
      }
    }),
		cm:colModel,
		sm:new Ext.grid.CheckboxSelectionModel()
	});
	return table;
}
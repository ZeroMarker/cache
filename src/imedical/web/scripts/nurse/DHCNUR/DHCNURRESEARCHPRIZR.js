var Width=document.body.clientWidth-2;
var Height=document.body.clientHeight-2;
//奖项来源Lab
var awardSourceLab=new Ext.form.Label({
	id:'awardsourcelab',
	text:'奖项来源',
	x:40,y:10,
	width:60
});
///奖项来源
var awardSource = new Ext.form.ComboBox({
	name:'awardsource',
	id:'awardsource',
	x:105,y:5,
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
//成果等级label
var awardGradeLab=new Ext.form.Label({
	id:'awardgradelab',
	text:'成果等级',
	x:40,y:40,
	width:60
});
//成果等级
var awardGrade = new Ext.form.ComboBox({
	name:'awardgrade',
	id:'awardgrade',
	x:105,y:35,
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
	//queryParam:'parr',
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//奖项名称Lab
var awardNameLab=new Ext.form.Label({
	name:'awardnamelab',
	id:'awardnamelab',
	width:80,
	text:'奖项名称',
	x:279,y:10
});
//奖项名称
var awardName=new Ext.form.TextField({
	id:'awardname',
	width:150,
	x:345,y:5
});
//获奖日期Label
var awardDateLab=new Ext.form.Label({
	name:'awarddatelab',
	id:'awarddatelab',
	width:80,
	text:'获奖日期',
	x:570,y:10
});
//获奖日期
var awardDate=new Ext.form.DateField({
	id:'awarddate',
	width:150,
	//format:'Y-m-d',
	xtype:'datefield',
	x:635,y:5
});
//奖金数额Lab
var awardBonusLab=new Ext.form.Label({
	id:'awardbonuslab',
	text:'奖金数额',
	width:80,
	x:279,y:40
});
//奖金数额
var awardBonus=new Ext.form.TextField({
	id:'awardbonus',
	x:345,y:35,
	width:150
});
//成果类型Lab
var awardTypeLab=new Ext.form.Label({
	id:'awardtypelab',
	text:'成果类型',
	x:570,y:40,
	width:80	
});
//成果类型
var awardType = new Ext.form.ComboBox({
	name:'awardtype',
	id:'awardtype',
	x:635,y:35,
	height:22,
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
//第一完成人Lab
var awardFirPerLab=new Ext.form.Label({
	id:'awardfirperlab',
	text:'第一完成人',
	width:80,
	x:27,y:70
});
//第一完成人
var awardFirPer=new Ext.form.ComboBox({
	name:'awardfirper',
	id:'awardfirper',
	x:105,y:65,
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
//第一完成人职务Lab
var awardFirHeadLab=new Ext.form.Label({
	id:'awardfirheadlab',
	text:'第一完成人职务',
	//width:100,
	x:237,y:70	
});
//第一完成人职务
var awardFirHead = new Ext.form.ComboBox({
	name:'awardfirhead',
	id:'awardfirhead',
	x:345,y:65,
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
//第一完成人职称Label
var awardFirDutyLab=new Ext.form.Label({
	id:'awardfirdutylab',
	text:'第一完成人职称',
	x:527,y:70
	//width:100	
});
//第一完成人职称
var awardFirDuty = new Ext.form.ComboBox({
	name:'awardfirduty',
	id:'awardfirduty',
	x:635,y:65,
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
///第一完成人层级Lab
var awardFirLevLab=new Ext.form.Label({
	id:'awardfirlevlab',
	text:'第一完成人层级',
	width:120,
	x:0,y:100	
});
//第一完成人层级
var awardFirLev = new Ext.form.ComboBox({
	name:'awardfirlev',
	id:'awardfirlev',
	x:105,y:95,
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
	//queryParam:'par',
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第一完成人所在大科Lab
var awardFirBigLab=new Ext.form.Label({
	id:'awardfirbiglab',
	text:'第一完成人所在大科',
	x:210,y:100
});
//第一完成人所在大科
var awardFirBig= new Ext.form.ComboBox({
	name:'awardfirbig',
	id:'awardfirbig',
	x:345,y:95,
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
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第一完成人所在病房Lab
var awardFirLocLab=new Ext.form.Label({
	id:'awardfirloclab',
	text:'第一完成人所在病房',
	x:500,y:100
});
//第一完成人所在病房
var awardFirLoc=new Ext.form.ComboBox({
	name:'awardfirloc',
	id:'awardfirloc',
	listWidth:'220',
	//height:22,
	width:150,
	x:635,y:95,
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
//第二完成人Lab
var awardSecPerLab=new Ext.form.Label({
	id:'awardsecperlab',
	text:'第二完成人',
	width:80,
	x:27,y:130
});
//第二完成人
var awardSecPer=new Ext.form.ComboBox({
	name:'awardsecper',
	id:'awardsecper',
	x:105,y:125,
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
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二完成人职务Lab
var awardSecHeadLab=new Ext.form.Label({
	id:'awardsecheadlab',
	text:'第二完成人职务',
	//width:100,
	x:237,y:130	
});
//第二完成人职务
var awardSecHead = new Ext.form.ComboBox({
	name:'awardsechead',
	id:'awardsechead',
	x:345,y:125,
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
//第二完成人职称Label
var awardSecDutyLab=new Ext.form.Label({
	id:'awardsecdutylab',
	text:'第二完成人职称',
	x:527,y:130
	//width:100	
});
//第二完成人职称
var awardSecDuty = new Ext.form.ComboBox({
	name:'awardsecduty',
	id:'awardsecduty',
	x:635,y:125,
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
///第二完成人层级Lab
var awardSecLevLab=new Ext.form.Label({
	id:'awardseclevlab',
	text:'第二完成人层级',
	width:120,
	x:0,y:160	
});
//第二完成人层级
var awardSecLev = new Ext.form.ComboBox({
	name:'awardseclev',
	id:'awardseclev',
	x:105,y:155,
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
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二完成人所在大科Lab
var awardSecBigLab=new Ext.form.Label({
	id:'awardsecbiglab',
	text:'第二完成人所在大科',
	x:210,y:160
});
//第二完成人所在大科
var awardSecBig= new Ext.form.ComboBox({
	name:'awardsecbig',
	id:'awardsecbig',
	x:345,y:155,
	height:22,
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
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第二完成人所在病房Lab
var awardSecLocLab=new Ext.form.Label({
	id:'awardsecloclab',
	text:'第二完成人所在病房',
	x:500,y:160
});
//第二完成人所在病房
var awardSecLoc=new Ext.form.ComboBox({
	name:'awardsecloc',
	id:'awardsecloc',
	listWidth:'220',
	height:22,
	width:150,
	x:635,y:155,
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
//第三完成人Lab
var awardThirPerLab=new Ext.form.Label({
	id:'awardthirperlab',
	text:'第三完成人',
	width:80,
	x:27,y:190
});
//第三完成人
var awardThirPer=new Ext.form.ComboBox({
	name:'awardthirper',
	id:'awardthirper',
	x:105,y:185,
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
//第三完成人职务Lab
var awardThirHeadLab=new Ext.form.Label({
	id:'awardthirheadlab',
	text:'第三完成人职务',
	//width:100,
	x:237,y:190	
});
//第三完成人职务
var awardThirHead = new Ext.form.ComboBox({
	name:'awardthirhead',
	id:'awardthirhead',
	x:345,y:185,
	height:22,
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
//第三完成人职称Label
var awardThirDutyLab=new Ext.form.Label({
	id:'awardthirdutylab',
	text:'第三完成人职称',
	x:527,y:190
	//width:100	
});
//第三完成人职称
var awardThirDuty = new Ext.form.ComboBox({
	name:'awardthirduty',
	id:'awardthirduty',
	x:635,y:185,
	height:22,
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
///第三完成人层级Lab
var awardThirLevLab=new Ext.form.Label({
	id:'awardthirlevlab',
	text:'第三完成人层级',
	width:120,
	x:0,y:220	
});
//第三完成人层级
var awardThirLev = new Ext.form.ComboBox({
	name:'awardthirlev',
	id:'awardthirlev',
	x:105,y:215,
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
	typeAhead:true,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第三完成人所在大科Lab
var awardThirBigLab=new Ext.form.Label({
	id:'awardthirbiglab',
	text:'第三完成人所在大科',
	x:210,y:220
});
//第三完成人所在大科
var awardThirBig= new Ext.form.ComboBox({
	name:'awardthirbig',
	id:'awardthirbig',
	x:345,y:215,
	height:22,
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
//第三完成人所在病房Lab
var awardThirLocLab=new Ext.form.Label({
	id:'awardthirloclab',
	text:'第三完成人所在病房',
	x:500,y:220
});
//第三完成人所在病房
var awardThirLoc=new Ext.form.ComboBox({
	name:'awardthirloc',
	id:'awardthirloc',
	listWidth:'220',
	height:22,
	width:150,
	x:635,y:215,
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
//其他完成人Lab
var awardOthPerLab=new Ext.form.Label({
	id:'awardothperlab',
	text:'其他完成人',
	width:80,
	x:27,y:250
});
//其他完成人
var awardOthPer=new Ext.form.ComboBox({
	name:'awardothper',
	id:'awardothper',
	x:105,y:245,
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
					Ext.Msg.alert('提示',"开始日期不能大于结束日期！");
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
					Ext.Msg.alert('提示',"结束日期不能小于开始日期！");
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
	icon:'../images/uiimages/search.png',
	//style : 'background-color:#00FFFF',
	handler:function(){schDataRec();}
},"-",{
	id:'adddatabtn',
	text:'增加',
	xtype:'button',
	width:60,
	//style : 'background-color:#00FFFF',
	icon:'../images/uiimages/edit_add.png',
	handler:function(){saveData("");}
},"-",{
	id:'addupdatebtn',
	text:'编辑',
	xtype:'button',
	width:60,
	//style : 'background-color:#00FFFF',
	icon:'../images/uiimages/pencil.png',
	handler:function(){updateDataRec();}
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
				Ext.getCmp(item.getId()).setValue('');
			}
		}
	});
	schDataRec();
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
	for(i=1;i<temp_obj.length;i++){
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
		fields:myfields,
		data:[],
		idIndex: 0
	});
	var parr=store.lastOptions.params.parr;
	var GetQueryData=document.getElementById('GetQueryData');
	var a=cspRunServerMethod(GetQueryData.value,"web.DHCMgNurResearchPrizeComm:FindReseaAwardLst","parr$"+parr,"AddRec");
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
function creatToolPanel()
{
	var panel=new Ext.Panel({
		title:'',
		id:'toolpanel',
		frame:true,
		x:1,y:305,
		width:Width,
		height:50,
		layout:'absolute'//,
		//items:[stDateLab,stDate,endDateLab,endDate,schDataBtn,addDataBtn,addUpdateBtn,addExportBtn]
	});
	return panel;
}
function createPanel()
{
	var toolPanel=creatToolPanel();
	var panel=new Ext.Panel({
		title:'', 
		id:'addpanel',
		height:Height/2+20,  
   	width:Width,
   	frame:true,
   	autoScroll:true,
   	x:0,
   	y:Height/2-50,
   	tbar:bbar1,
   	items:[awardSourceLab,awardSource,awardGradeLab,awardGrade,awardNameLab,awardName,awardDateLab,awardDate,awardBonusLab,awardBonus,awardTypeLab,awardType,awardFirPerLab,
   	awardFirPer,awardFirHeadLab,awardFirHead,awardFirDutyLab,awardFirDuty,awardFirLevLab,awardFirLev,awardFirBigLab,awardFirBig,awardFirLocLab,awardFirLoc,awardSecPerLab,
   	awardSecPer,awardSecHeadLab,awardSecHead,awardSecDutyLab,awardSecDuty,awardSecLevLab,awardSecLev,awardSecBigLab,awardSecBig,awardSecLocLab,awardSecLoc,awardThirPerLab,
   	awardThirPer,awardThirHeadLab,awardThirHead,awardThirDutyLab,awardThirDuty,awardThirLevLab,awardThirLev,awardThirBigLab,awardThirBig,awardThirLocLab,awardThirLoc,
   	awardOthPerLab,awardOthPer], //,toolPanel],
    layout:'absolute'
	});
	return panel;
}
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	createGrid();
	var mygrid=Ext.getCmp('mygrid');
	awardSource.store.on('beforeload',function(){
		awardSource.store.baseParams.par="科研成果奖项来源";
  	awardSource.store.baseParams.stype=awardSource.lastQuery;		
	});
	awardGrade.store.on('beforeload',function(){
		awardGrade.store.baseParams.par="科研成果等级";
		awardGrade.store.baseParams.stype=awardGrade.lastQuery;	
	});
	awardType.store.on('beforeload',function(){
		awardType.store.baseParams.par="科研成果类型";
		awardType.store.baseParams.stype=awardType.lastQuery;
	});
	var wardFirPer=Ext.getCmp('awardfirper');
	wardFirPer.store.on('beforeload',function(){
		wardFirPer.store.baseParams.parr=wardFirPer.lastQuery;
		if(secGrpFlag=="nurhead"){
			wardFirPer.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	awardFirHead.store.on('beforeload',function(){
		awardFirHead.store.baseParams.par="职务",
		awardFirHead.store.baseParams.stype=awardFirHead.lastQuery;	
	});
	awardFirDuty.store.on('beforeload',function(){
		awardFirDuty.store.baseParams.par="聘任专业技术职称",
		awardFirDuty.store.baseParams.stype=awardFirDuty.lastQuery;	
	});
	awardFirLev.store.on('beforeload',function(){
		awardFirLev.store.baseParams.par="护士层级";
		awardFirLev.store.baseParams.stype=awardFirLev.lastQuery;	
	});
	awardFirLoc.store.on('beforeload',function(){
		var pward=awardFirLoc.lastQuery;
		//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^";
	 	awardFirLoc.store.baseParams.typ="1";
	 	awardFirLoc.store.baseParams.ward1=pward;        
		awardFirLoc.store.baseParams.nurseid=nurseString;
	});
	awardSecPer.store.on('beforeload',function(){
		awardSecPer.store.baseParams.parr=awardSecPer.lastQuery;
		if(secGrpFlag=="nurhead"){
			awardSecPer.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	awardSecHead.store.on('beforeload',function(){
		awardSecHead.store.baseParams.par="职务",
		awardSecHead.store.baseParams.stype=awardSecHead.lastQuery;	
	});
	awardSecDuty.store.on('beforeload',function(){
		awardSecDuty.store.baseParams.par="聘任专业技术职称";
		awardSecDuty.store.baseParams.stype=awardSecDuty.lastQuery;	
	});
	awardSecLev.store.on('beforeload',function(){
		awardSecLev.store.baseParams.par="护士层级";
		awardSecLev.store.baseParams.stype=awardSecLev.lastQuery;	
	});
	awardSecLoc.store.on('beforeload',function(){
		//var flagStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var flagStr=session['LOGON.USERID']+"^"+secGrpFlag+"^";
	 	awardSecLoc.store.baseParams.typ="1";
	 	awardSecLoc.store.baseParams.ward1=awardSecLoc.lastQuery;     
		awardSecLoc.store.baseParams.nurseid=flagStr;
	});
	awardThirPer.store.on('beforeload',function(){
		awardThirPer.store.baseParams.parr=awardThirPer.lastQuery;
		if(secGrpFlag=="nurhead"){
			awardThirPer.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}	
	});
	awardThirHead.store.on('beforeload',function(){
		awardThirHead.store.baseParams.par="职务";
		awardThirHead.store.baseParams.stype=awardThirHead.lastQuery;	
	});
	awardThirDuty.store.on('beforeload',function(){
		awardThirDuty.store.baseParams.par="聘任专业技术职称";
		awardThirDuty.store.baseParams.stype=awardThirDuty.lastQuery;	
	});
	awardThirLev.store.on('beforeload',function(){
		awardThirLev.store.baseParams.par="护士层级";
		awardThirLev.store.baseParams.stype=awardThirLev.lastQuery;
	});
	awardThirLoc.store.on('beforeload',function(){
		//var flagStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var flagStr=session['LOGON.USERID']+"^"+secGrpFlag+"^";
		awardThirLoc.store.baseParams.typ="1";
	 	awardThirLoc.store.baseParams.ward1=awardThirLoc.lastQuery;     
		awardThirLoc.store.baseParams.nurseid=flagStr;
	});
	awardOthPer.store.on('beforeload',function(){
		awardOthPer.store.baseParams.parr=awardOthPer.lastQuery;
		if(secGrpFlag=="nurhead"){
			awardOthPer.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}	
	});
	mygrid.store.on('beforeload',function(){
		var schStDate=Ext.getCmp('stdate').getValue();
		if(!schStDate){
			return;
		}else{
			if(schStDate instanceof Date){
				schStDate=schStDate.format('Y-m-d');
			}
		}
		var schEndDate=Ext.getCmp('enddate').getValue();
		if(!schEndDate){
			return;
		}else{
			if(schEndDate instanceof Date){
				schEndDate=schEndDate.format('Y-m-d');
			}
		}
		var schAwardDate=Ext.getCmp('awarddate').getValue();
		if(!schAwardDate){
		}else{
			if(schAwardDate instanceof Date){
				schAwardDate=schAwardDate.format('Y-m-d');
			}
		}
		var firPer=Ext.getCmp('awardfirper').getValue();
		var schAwardName=Ext.getCmp('awardname').getValue();
		var strParams=schStDate+"^"+schEndDate+"^"+schAwardDate+"^"+firPer+"^"+schAwardName;
		mygrid.store.baseParams.parr=	strParams;
	})
	schDataRec();
	setBtnEnable();
	mygrid.on('rowclick',singleRowClick)
	
}
function singleRowClick()
{
	setBtnDisable();
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	var strVal=tkMakeServerCall('DHCMGNUR.MgNurResearchAward','getVal',rw);
	var ha=new Hashtable();
	var tm=strVal.split("^");
	sethashval(ha,tm);
	Ext.getCmp('addpanel').items.each(function(item,index,length){
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
					Ext.getCmp(item.getId()).setValue('');
				}
			}
		}
	});//combo
	//var strVal=tkMakeServerCall('DHCMGNUR.MgNurResearchAward','getVal',rw);
	//alert(strVal)
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
function schDataRec()
{
	var grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:25}});
	setBtnEnable();
	clearItem();
}
function updateDataRec()
{
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一条记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	saveData(rw);
}
function saveData(rw)
{
	var scienSource=Ext.getCmp('awardsource').getValue(); //奖项来源
	if(!scienSource){
		Ext.Msg.alert('提示','请填写奖项来源！');
		return;
	}
	var scienGrade=Ext.getCmp('awardgrade').getValue(); //成果等级
	if(!scienGrade){
		Ext.Msg.alert('提示','请填写成果等级！');
		return;
	}
	var scienDate=Ext.getCmp('awarddate').getValue(); //获奖日期
	if(!scienDate){
		Ext.Msg.alert('提示','请填写获奖日期！');
		return;
	}else{
		if(scienDate instanceof Date){
			scienDate=scienDate.format('Y-m-d');
		}
	}
	var scienName=Ext.getCmp('awardname').getValue(); //奖项名称
	if(!scienName){
		Ext.Msg.alert('提示','请填写奖项名称！');
		return;	
	}else{
		scienName=scienName.replace(/(^\s*)|(\s*$)/g, "");
	}
	var scienBonuses=Ext.getCmp('awardbonus').getValue(); //奖金金额
	var scienType=Ext.getCmp('awardtype').getValue(); //成果类型
	if(!scienType){
		Ext.Msg.alert('提示','请填写成果类型！');
		return;	
	}
	var scienFirPer=Ext.getCmp('awardfirper').getValue(); // 第一完成人
	if(!scienFirPer){
		Ext.Msg.alert('提示','请选择第一完成人！');
		return;
	}
	var scienFirHead=Ext.getCmp('awardfirhead').getValue(); //第一完成人职务
	var scienFirDuty=Ext.getCmp('awardfirduty').getValue(); //第一完成人职称
	var scienFirLev=Ext.getCmp('awardfirlev').getValue(); //第一完成人层级
	var scienFirBig=Ext.getCmp('awardfirbig').getValue(); //第一完成人所在大科
	var scienFirLoc=Ext.getCmp('awardfirloc').getValue(); //第一完成人所在病房
	var scienSecPer=Ext.getCmp('awardsecper').getValue(); //第二完成人
	var scienSecHead=Ext.getCmp('awardsechead').getValue(); //第二完成人职务
	var scienSecDuty=Ext.getCmp('awardsecduty').getValue(); //第二完成人职称
	var scienSecLev=Ext.getCmp('awardseclev').getValue(); //第二完成人层级
	var scienSecBig=Ext.getCmp('awardsecbig').getValue(); //第二完成人所在大科
	var scienSecLoc=Ext.getCmp('awardsecloc').getValue(); //第二完成人所在病房
	var scienThirdPer=Ext.getCmp('awardthirper').getValue(); //第三完成人
	var scienThirdHead=Ext.getCmp('awardthirhead').getValue(); //第三完成人职务
	var scienThirdDuty=Ext.getCmp('awardthirduty').getValue(); //第三完成人职称
	var scienThirdLev=Ext.getCmp('awardthirlev').getValue(); //第三完成人层级
	var scienThirdBig=Ext.getCmp('awardthirbig').getValue(); //第三完成人所在大科
	var scienThirdLoc=Ext.getCmp('awardthirloc').getValue(); //第三完成人所在病房
	var scienOtPer=Ext.getCmp('awardothper').getValue(); //其他完成人
	var isExistFlag=scienDate+"^"+scienName+"^"+scienFirPer;
	var isRetVal=tkMakeServerCall('DHCMGNUR.MgNurResearchAward','isExist',isExistFlag);
	if((isRetVal)&&(!rw)){
		Ext.Msg.alert('提示','此人科研奖已存在，请确认!');
		return;	
	}
	var parr="rw@"+rw+"^scienSource@"+scienSource+"^scienGrade@"+scienGrade+"^scienDate@"+scienDate+"^scienName@"+scienName+"^scienBonuses@"+scienBonuses+"^scienType@"+scienType+"^scienFirPer@"+scienFirPer+"^scienFirHead@"+scienFirHead+"^scienFirDuty@"+scienFirDuty+"^scienFirLev@"+scienFirLev+"^scienFirBig@"+scienFirBig+"^scienFirLoc@"+scienFirLoc+"^scienSecPer@"+scienSecPer+"^scienSecHead@"+scienSecHead+"^scienSecDuty@"+scienSecDuty+"^scienSecLev@"+scienSecLev+"^scienSecBig@"+scienSecBig+"^scienSecLoc@"+scienSecLoc+"^scienThirdPer@"+scienThirdPer+"^scienThirdHead@"+scienThirdHead+"^scienThirdDuty@"+scienThirdDuty+"^scienThirdLev@"+scienThirdLev+"^scienThirdBig@"+scienThirdBig+"^scienThirdLoc@"+scienThirdLoc+"^scienOtPer@"+scienOtPer;
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurResearchAward','Save',parr);
	setBtnEnable();
	schDataRec();
	clearAllItems();
}
function clearItem()
{
	Ext.getCmp('awardsource').setValue('');
	Ext.getCmp('awardgrade').setValue('');
	//Ext.getCmp('awarddate').setValue('');
	//Ext.getCmp('awardname').setValue('');
	Ext.getCmp('awardbonus').setValue('');
	Ext.getCmp('awardtype').setValue('');
	//Ext.getCmp('awardfirper').setValue('');
	Ext.getCmp('awardfirhead').setValue('');
	Ext.getCmp('awardfirduty').setValue(''); //第一完成人职称
	Ext.getCmp('awardfirlev').setValue(''); //第一完成人层级
	Ext.getCmp('awardfirbig').setValue(''); //第一完成人所在大科
	Ext.getCmp('awardfirloc').setValue(''); //第一完成人所在病房
	Ext.getCmp('awardsecper').setValue(''); //第二完成人
	Ext.getCmp('awardsechead').setValue(''); //第二完成人职务
	Ext.getCmp('awardsecduty').setValue(''); //第二完成人职称
	Ext.getCmp('awardseclev').setValue(''); //第二完成人层级
	Ext.getCmp('awardsecbig').setValue(''); //第二完成人所在大科
	Ext.getCmp('awardsecloc').setValue(''); //第二完成人所在病房
	Ext.getCmp('awardthirper').setValue(''); //第三完成人
	Ext.getCmp('awardthirhead').setValue(''); //第三完成人职务
	Ext.getCmp('awardthirduty').setValue(''); //第三完成人职称
	Ext.getCmp('awardthirlev').setValue(''); //第三完成人层级
	Ext.getCmp('awardthirbig').setValue(''); //第三完成人所在大科
	Ext.getCmp('awardthirloc').setValue(''); //第三完成人所在病房
	Ext.getCmp('awardothper').setValue(''); //其他完成人
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
	colModelStr.push({header:"奖项来源",width:80,dataIndex:'ScienSource'});
	colData.push({'name':'ScienSource','mapping':'ScienSource'});
	colModelStr.push({header:"项目名称",width:220,dataIndex:'ScienName'});
	colData.push({'name':'ScienName','mapping':'ScienName'});
	colModelStr.push({header:"成果等级",width:80,dataIndex:'ScienGrade'});
	colData.push({'name':'ScienGrade','mapping':'ScienGrade'});
	colModelStr.push({header:"获奖时间",width:100,dataIndex:'ScienDate'});
	colData.push({'name':'ScienDate','mapping':'ScienDate'});
	colModelStr.push({header:"奖金数",width:80,dataIndex:'ScienBonuses'});
	colData.push({'name':'ScienBonuses','mapping':'ScienBonuses'});
	colModelStr.push({header:"成果类型",width:80,dataIndex:'ScienType'});
	colData.push({'name':'ScienType','mapping':'ScienType'});
	colModelStr.push({header:"第一完成人",width:80,dataIndex:'ScienFirPer'});
	colData.push({'name':'ScienFirPer','mapping':'ScienFirPer'});
	colModelStr.push({header:"第一完成人职务",width:120,dataIndex:'ScienFirHead'});
	colData.push({'name':'ScienFirHead','mapping':'ScienFirHead'});
	colModelStr.push({header:"第一完成人职称",width:120,dataIndex:'ScienFirDuty'});
	colData.push({'name':'ScienFirDuty','mapping':'ScienFirDuty'});
	colModelStr.push({header:"第一完成人层级",width:120,dataIndex:'ScienFirLev'});
	colData.push({'name':'ScienFirLev','mapping':'ScienFirLev'});
	colModelStr.push({header:"第一完成人所在大科",width:150,dataIndex:'ScienFirBig'});
	colData.push({'name':'ScienFirBig','mapping':'ScienFirBig'});
	colModelStr.push({header:"第一完成人所在病房",width:200,dataIndex:'ScienFirLoc'});
	colData.push({'name':'ScienFirLoc','mapping':'ScienFirLoc'});
	colModelStr.push({header:"第二完成人",width:80,dataIndex:'ScienSecPer'});
	colData.push({'name':'ScienSecPer','mapping':'ScienSecPer'});
	colModelStr.push({header:"第二完成人职务",width:120,dataIndex:'ScienSecHead'});
	colData.push({'name':'ScienSecHead','mapping':'ScienSecHead'});
	colModelStr.push({header:"第二完成人职称",width:120,dataIndex:'ScienSecDuty'});
	colData.push({'name':'ScienSecDuty','mapping':'ScienSecDuty'});
	colModelStr.push({header:"第二完成人层级",width:120,dataIndex:'ScienSecLev'});
	colData.push({'name':'ScienSecLev','mapping':'ScienSecLev'});
	colModelStr.push({header:"第二完成人所在大科",width:150,dataIndex:'ScienSecBig'});
	colData.push({'name':'ScienSecBig','mapping':'ScienSecBig'});
	colModelStr.push({header:"第二完成人所在病房",width:200,dataIndex:'ScienSecLoc'});
	colData.push({'name':'ScienSecLoc','mapping':'ScienSecLoc'});
	colModelStr.push({header:"第三完成人",width:80,dataIndex:'ScienThirdPer'});
	colData.push({'name':'ScienThirdPer','mapping':'ScienThirdPer'});
	colModelStr.push({header:"第三完成人职务",width:120,dataIndex:'ScienThirdHead'});
	colData.push({'name':'ScienThirdHead','mapping':'ScienThirdHead'});
	colModelStr.push({header:"第三完成人职称",width:120,dataIndex:'ScienThirdDuty'});
	colData.push({'name':'ScienThirdDuty','mapping':'ScienThirdDuty'});
	colModelStr.push({header:"第三完成人层级",width:120,dataIndex:'ScienThirdLev'});
	colData.push({'name':'ScienThirdLev','mapping':'ScienThirdLev'});
	colModelStr.push({header:"第三完成人所在大科",width:150,dataIndex:'ScienThirdBig'});
	colData.push({'name':'ScienThirdBig','mapping':'ScienThirdBig'});
	colModelStr.push({header:"第三完成人所在病房",width:200,dataIndex:'ScienThirdLoc'});
	colData.push({'name':'ScienThirdLoc','mapping':'ScienThirdLoc'});
	colModelStr.push({header:"其他完成人",width:80,dataIndex:'ScienOtPer'});
	colData.push({'name':'ScienOtPer','mapping':'ScienOtPer'});	
	colModelStr.push({header:"rw",hidden:true,width:30,dataIndex:'rw'});
	colData.push({'name':'rw','mapping':'rw'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{
			className:'web.DHCMgNurResearchPrizeComm',
			methodName:'FindReseaAwardLst',
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
		title:'科研成果奖列表',
		region: 'center',
		split: true,
		height:Height/2-10,
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
      emptyMsg: "没有记录", onFirstLayout :function(){
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
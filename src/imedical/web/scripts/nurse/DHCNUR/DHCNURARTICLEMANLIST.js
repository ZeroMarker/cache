var Width=document.body.clientWidth-5;
var Height=document.body.clientHeight-3;
var bbar1 = new Ext.Toolbar(["<font color=red>开始日期:</font>",{
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
},"-","<font color=red>结束日期:</font>",{
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
	handler:function(){schDataRec();clearItm();}
},"-",{
	id:'adddatabtn',
	text:'增加',
	xtype:'button',
	width:60,
	icon:'../images/uiimages/edit_add.png',
	//style : 'background-color:#00FFFF',
	handler:function(){saveRecData('');}
},"-",{
	id:'updatedatabtn',
	text:'编辑',
	xtype:'button',
	width:60,
	icon:'../images/uiimages/pencil.png',
	//style : 'background-color:#00FFFF',
	handler:function(){updateRecData();}
},"-",{
	id:'clearitmbtn',
	text:'清屏',
	xtype:'button',
	width:60,
	icon:'../images/uiimages/clearscreen.png',
	//style:'background-color:#00FFFF',
	handler:function(){clearItm();}	
},"-",{
	id:'exportbtn',
	text:'导出',
	width:60,
	icon:'../images/uiimages/redo.png',
	//style : 'background-color:#00FFFF',
	handler:function(){exportData();}
}]);
var categoryLabel=new Ext.form.Label({
	id:'categorylabel',
	text:'类别',
	x:55,y:5,
	width:60
});
///类别ComboBox
var artCategory = new Ext.form.ComboBox({
	name:'category',
	id:'category',
	x:90,y:0,
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
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//文章题目label
var titleLabel=new Ext.form.Label({
	id:'titlelabel',
	text:'文章题目',
	x:28,y:40,
	width:60
});
//文章题目
var artTitle=new Ext.form.TextField({
	id:'arttitle',
	width:330,
	x:90,y:35	
});
//卷label
var volLabel=new Ext.form.Label({
	id:'vollabel',
	text:'卷',
	x:70,y:75,
	width:40	
});
var volText=new Ext.form.TextField({
	id:'voltext',
	width:40,
	x:90,y:70	
});
//发表栏目Label
var artHead=new Ext.form.Label({
	id:'arthead',
	text:'发表栏目',
	x:484,y:75,
	width:80	
});
//发表栏目ComboBox
var artHeadCom = new Ext.form.ComboBox({
	name:'artheadcom',
	id:'artheadcom',
	x:550,y:70,
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
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第一作者
var artFirAuthLab=new Ext.form.Label({
	id:'artfirauthlab',
	text:'第一作者',
	width:80,
	x:28,y:110
});
//第一作者
var artFirstAuth=new Ext.form.ComboBox({
	name:'artfirstauth',
	id:'artfirstauth',
	x:90,y:105,
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

var artMagLab=new Ext.form.Label({
	id:'artmaglab',
	text:'杂志名称',
	width:80,
	x:256,y:5
});
///杂志名称
var artMagazine = new Ext.form.ComboBox({
	name:'artmagazine',
	id:'artmagazine',
	x:320,y:0,
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
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//发表日期Label
var artDateLab=new Ext.form.Label({
	name:'artdatelab',
	id:'artdatelab',
	width:80,
	text:'发表日期',
	x:484,y:5
});
//发表日期
var artDate=new Ext.form.DateField({
	id:'artdate',
	width:150,
	//format:'Y-m-d',
	xtype:'datefield',
	x:550,y:0
});
//期Lab
var artTermLab=new Ext.form.Label({
	id:'arttermlab',
	width:60,
	text:'期',
	x:130,y:75	
});
//期
var artTerm=new Ext.form.TextField({
	id:'artterm',
	x:150,y:70,
	width:40	
});
//文章类型Lab
var artTypeLab=new Ext.form.Label({
	id:'arttypelab',
	text:'文章类型',
	width:80,
	x:484,y:40
});
//文章类型
var artType = new Ext.form.ComboBox({
	name:'arttype',
	id:'arttype',
	x:550,y:35,
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
	//queryParam:'par',
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});

//第一作者层级Lab
var artFirAuthLevLab=new Ext.form.Label({
	id:'artfirauthlevlab',
	text:'第一作者层级',
	width:100,
	x:228,y:110	
});
//第一作者层级
var artFirAuthLev = new Ext.form.ComboBox({
	name:'artfirauthlev',
	id:'artfirauthlev',
	x:320,y:105,
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
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//所在页码Lab
var artPageLab=new Ext.form.Label({
	id:'artpagelab',
	text:'所在页码',
	width:60,
	x:256,y:75	
});
//所在页码
var artPage=new Ext.form.TextField({
	id:'artpage',
	width:100,
	x:320,y:70
});
//第一作者职务Lab
var artFirAuthHeadLab=new Ext.form.Label({
	id:'artfirauthheadlab',
	text:'第一作者职务',
	x:456,y:110	
});
//第一作者职务
var artFirAuthHead = new Ext.form.ComboBox({
	name:'artfirauthhead',
	id:'artfirauthhead',
	x:550,y:105,
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
//第一作者职称Lab
var artFirAuthDutyLab=new Ext.form.Label({
	id:'artfirauthdutylab',
	text:'第一作者职称',
	x:0,y:145
});
//第一作者职称
var artFirAuthDuty = new Ext.form.ComboBox({
	name:'artfirauthduty',
	id:'artfirauthduty',
	x:90,y:140,
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
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
///第一作者所在大科Lab
var artFirAuthBigLab=new Ext.form.Label({
	id:'artfirauthbiglab',
	text:'第一作者所在大科',
	x:200,y:145
});
//第一作者所在大科
var artFirAuthBig= new Ext.form.ComboBox({
	name:'artfirauthbig',
	id:'artfirauthbig',
	x:320,y:140,
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
//第一作者所在病房Lab
var artFirAuthLocLab=new Ext.form.Label({
	id:'artfirauthloclab',
	text:'第一作者所在病房',
	x:426,y:145
});
//第一作者所在病房
var artFirAuthLoc=new Ext.form.ComboBox({
	name:'artfirauthloc',
	id:'artfirauthloc',
	listWidth:220,
	//height:22,
	width:150,
	x:550,y:140,
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
//通讯作者Label
var artWriteLab=new Ext.form.Label({
	id:'artwritelab',
	text:'通讯作者',
	x:28,y:180,
	width:80
});

///通讯作者
var artWriter = new Ext.form.ComboBox({
	name:'artwriter',
	id:'artwriter',
	x:90,y:175,
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
	//queryParam:'parr',
	forceSelection:true,
	minChars:1,
	pageSize:20,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//通讯作者层级Lab
var artWriterLevLab=new Ext.form.Label({
	id:'artwriterlevlab',
	text:'通讯作者层级',
	x:228,y:180	
});
//通讯作者层级
var artWriterLev = new Ext.form.ComboBox({
	name:'artwriterlev',
	id:'artwriterlev',
	x:320,y:175,
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
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//通讯作者职务Lab
var artWriterHeadLab=new Ext.form.Label({
	id:'artwriterheadlab',
	text:'通讯作者职务',
	x:456,y:180
});
//通讯作者职务
var artWriterHead = new Ext.form.ComboBox({
	name:'artwriterhead',
	id:'artwriterhead',
	x:550,y:175,
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
//通讯作者职称Lab
var artWriterDutyLab=new Ext.form.Label({
	id:'artwriterdutylab',
	text:'通讯作者职称',
	x:1,y:215
});
//通讯作者职称
var artWriterDuty = new Ext.form.ComboBox({
	name:'artwriterduty',
	id:'artwriterduty',
	x:90,y:210,
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
	forceSelection:true,
	minChars:1,
	pageSize:500,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
///通讯作者所在大科Lab
var artWriterBigLab=new Ext.form.Label({
	id:'artwriterbiglab',
	text:'通讯作者所在大科',
	x:200,y:215
});
//通讯作者所在大科
var artWriterBig= new Ext.form.ComboBox({
	name:'artwriterbig',
	id:'artwriterbig',
	x:320,y:210,
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
//通讯作者所在病房Lab
var artWriterLocLab=new Ext.form.Label({
	id:'artwriterloclab',
	text:'通讯作者所在病房',
	x:430,y:215
});
//通讯作者所在病房
var artWriterLoc=new Ext.form.ComboBox({
	name:'artwriterloc',
	id:'artwriterloc',
	listWidth:'220',
	//height:22,
	width:150,
	x:550,y:210,
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
//第二作者Lab
var artSecAuthLab=new Ext.form.Label({
	id:'artsecauthlab',
	text:'第二作者',
	width:80,
	x:28,y:250
});
//第二作者
var artSecAuth=new Ext.form.ComboBox({
	name:'artsecauth',
	id:'artsecauth',
	x:90,y:245,
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
	//queryParam:'parr',
	forceSelection:true,
	minChars:1,
	pageSize:20,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//第三作者Lab
var artThirdAuthLab=new Ext.form.Label({
	id:'artthirdauthlab',
	text:'第三作者',
	width:80,
	x:256,y:250
});
//第三作者
var artThirdAuth=new Ext.form.ComboBox({
	name:'artthirdauth',
	id:'artthirdauth',
	x:320,y:245,
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
	//queryParam:'parr',
	forceSelection:true,
	minChars:1,
	pageSize:20,
	typeAhead:false,
	typeAheadDelay:1000,
	loadingText:'Searching...'
});
//其他作者Lab
var artOtAuthLab=new Ext.form.Label({
	id:'artotauthlab',
	text:'其他作者',
	x:486,y:250
});
//其他作者
var artOtAuth=new Ext.form.TextField({
	id:'artotauth',
	x:550,y:245,
	width:150
});
function createPanel()
{
	var panel=new Ext.Panel({
		title:'', 
		id:'addpanel',
		height:Height/2-20,  
   		width:Width,
   		frame:true,
   		autoScroll:true,
   		tbar:bbar1,
   		x:0,
   		y:Height/2-20,
   		items:[categoryLabel,artCategory,titleLabel,artTitle,volLabel,volText,artHead,artHeadCom,artFirAuthLab,artFirstAuth,artWriteLab,artWriter,artMagLab,artMagazine,
   			artDateLab,artDate,artTermLab,artTerm,artTypeLab,artType,artSecAuthLab,artSecAuth,artFirAuthLevLab,artFirAuthLev,artPageLab,artPage,artFirAuthHeadLab,artFirAuthHead,
   			artFirAuthDutyLab,artFirAuthDuty,artFirAuthBigLab,artFirAuthBig,artFirAuthLocLab,artFirAuthLoc,artWriterLevLab,artWriterLev,artWriterHeadLab,artWriterHead,
   			artWriterDutyLab,artWriterDuty,artWriterBigLab,artWriterBig,artWriterLocLab,artWriterLoc,artThirdAuthLab,artThirdAuth,artOtAuthLab,artOtAuth
   		],
    	layout:'absolute'
	});
	return panel;
}
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
function BodyLoadHandler()
{
	createGrid();
	artCategory.store.on('beforeload',function(){
		artCategory.store.baseParams.par="文章管理类别";
  		artCategory.store.baseParams.stype=artCategory.lastQuery;		
	});
	artHeadCom.store.on('beforeload',function(){
		artHeadCom.store.baseParams.par="发表栏目",
		artHeadCom.store.baseParams.stype=artHeadCom.lastQuery;	
	});
	artMagazine.store.on('beforeload',function(){
		artMagazine.store.baseParams.par="文章管理杂志名称",
		artMagazine.store.baseParams.stype=artMagazine.lastQuery;	
	});
	artType.store.on('beforeload',function(){
		artType.store.baseParams.par="文章类型",
		artType.store.baseParams.stype=artType.lastQuery;	
	});
	var artfirstauth=Ext.getCmp('artfirstauth');
	artfirstauth.store.on('beforeload',function(){
		artfirstauth.store.baseParams.parr=artfirstauth.lastQuery;
		if(secGrpFlag=="nurhead"){
			artfirstauth.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	artFirAuthLev.store.on('beforeload',function(){
		artFirAuthLev.store.baseParams.par="护士层级";
		artFirAuthLev.store.baseParams.stype=artFirAuthLev.lastQuery;	
	});
	artFirAuthHead.store.on('beforeload',function(){
		artFirAuthHead.store.baseParams.par="职务",
		artFirAuthHead.store.baseParams.stype=artFirAuthHead.lastQuery;	
	});
	artFirAuthDuty.store.on('beforeload',function(){
		artFirAuthDuty.store.baseParams.par="聘任专业技术职称",
		artFirAuthDuty.store.baseParams.stype=artFirAuthDuty.lastQuery;	
	});
	artFirAuthBig.store.on('beforeload',function(){
		artFirAuthBig.store.baseParams.parr=artFirAuthBig.lastQuery;
	});
	artFirAuthLoc.store.on('beforeload',function(){
		var pward=artFirAuthLoc.lastQuery;
		//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^";
	 	artFirAuthLoc.store.baseParams.typ="1";
	 	artFirAuthLoc.store.baseParams.ward1=pward;        
		artFirAuthLoc.store.baseParams.nurseid=nurseString;
	});
	artWriterLev.store.on('beforeload',function(){
		artWriterLev.store.baseParams.par="护士层级",
		artWriterLev.store.baseParams.stype=artWriterLev.lastQuery;	
	});
	artWriterHead.store.on('beforeload',function(){
		artWriterHead.store.baseParams.par="职务",
		artWriterHead.store.baseParams.stype=artWriterHead.lastQuery;	
	});
	artWriterDuty.store.on('beforeload',function(){
		artWriterDuty.store.baseParams.par="聘任专业技术职称";
		artWriterDuty.store.baseParams.stype=artWriterDuty.lastQuery;	
	});
	artWriterBig.store.on('beforeload',function(){
		artWriterBig.store.baseParams.parr=artWriterBig.lastQuery;	
	});
	artWriter.store.on('beforeload',function(){
		artWriter.store.baseParams.parr=artWriter.lastQuery;
		if(secGrpFlag=="nurhead"){
			artWriter.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	artSecAuth.store.on('beforeload',function(){
		artSecAuth.store.baseParams.parr=artSecAuth.lastQuery;
		if(secGrpFlag=="nurhead"){
			artSecAuth.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	artThirdAuth.store.on('beforeload',function(){
		artThirdAuth.store.baseParams.parr=artThirdAuth.lastQuery;
		if(secGrpFlag=="nurhead"){
			artThirdAuth.store.baseParams.sdep=session['LOGON.CTLOCID'];
		}
	});
	artWriterLoc.store.on('beforeload',function(){
		var pward=artWriterLoc.lastQuery;
		//var nurseString=session['LOGON.USERID']+"^"+session['LOGON.GROUPDESC']+"^";
	 	var nurseString=session['LOGON.USERID']+"^"+secGrpFlag+"^";
	 	artWriterLoc.store.baseParams.typ="1";
	 	artWriterLoc.store.baseParams.ward1=pward;
		artWriterLoc.store.baseParams.nurseid=nurseString;
	});
	
	var grid=Ext.getCmp('mygrid');
	var table=document.getElementById('mygrid');
	table.oncontextmenu = function (){
		return false;
  }
	setBtnEnable();
	grid.store.on('beforeload',function(){
		var stdate=Ext.getCmp('stdate').getValue();
		if(stdate instanceof Date){
			stdate=stdate.format('Y-m-d');
		}
		var enddate=Ext.getCmp('enddate').getValue();
		if(enddate instanceof Date){
			enddate=enddate.format('Y-m-d');
		}
		var firstAuthor=Ext.getCmp('artfirstauth').getValue();
		var writerAuthor=Ext.getCmp('artwriter').getValue();
		var articleDate=Ext.getCmp('artdate').getValue();
		if(articleDate instanceof Date){
			articleDate=articleDate.format('Y-m-d');
		}
		var aticleTitle=Ext.getCmp("arttitle").getValue();
		var paramers=stdate+"^"+enddate+"^"+firstAuthor+"^"+writerAuthor+"^"+articleDate+"^"+aticleTitle;
		//alert(paramers)
		grid.store.baseParams.parr=	paramers;
	});
	schDataRec();
	grid.on('rowclick',function(){gridRowClick();});
//	grid.on('rowcontextmenu',function(grid,rowIndex,e){
//		e.preventDefault();
//		rightClick.showAt(e.getXY());
//	});
}
var rightClick=new Ext.menu.Menu({
	id : 'rightClickCont',
	items :[{
		id : 'rMenu1',
		text : '导入文章图片',
		handler:importArtImg
	},{
		id:'findartimg',
		text:'查看文章',
		handler:readArticle	
	}]
});
function readArticle()
{
	//debugger
	//var picStr="";
	var mygrid=Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一行记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	var retVal=tkMakeServerCall("DHCMGNUR.MgNurArticleManage",'getArtImg',rw);
	if(retVal){
		articleShow(retVal,rw);
	}else{
		Ext.Msg.alert('提示','没有上传文章图片！');
		return;
	}
}
function importArtImg()
{
	var mygrid=new Ext.getCmp('mygrid');
	var rowObj=mygrid.getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择一行记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	var newSrc="";
	var fp = new Ext.form.FormPanel({
		baseCls:'x-plain',
		labelWidth:70,
		frame:true,
		fileUpload:true,
		defaultType:'textfield',
		items:[{
			xtype:'textfield',
			fieldLabel:'请选择图片',
			name:'userfile',
			id:'userfile',
			inputType:'file',			
			blankText:'File can\'t not empty.',
			anchor:'100%'
		}]
	});
	var winUpload = new Ext.Window({
		title:'文章图片上传',
		width:400,
		height:100,
		layout:'fit',
		plain:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		modal:true,
		items:[fp],
		buttons:[{
			text:'上传',
			handler:function() {
				if(fp.form.isValid()){
					if(Ext.getCmp('userfile').getValue()==''){
						Ext.Msg.alert('错误','请选择你要上传的文件');
			 			return;
					}
					newSrc=Ext.getCmp('userfile').getValue(); 
					var sdate=new Date();
					var sYear=sdate.getFullYear();
					var sMonth=sdate.getMonth()+1;
					var sDay=sdate.getDate();
					var sHour=sdate.getHours();
					var sMinute=sdate.getMinutes();
					var sSecond=sdate.getSeconds();
					var sExtension=sYear.toString()+sMonth.toString()+sDay.toString()+sHour.toString()+sMinute.toString()+sSecond.toString();
					var savename=rw+sExtension+".jpg";
					var filepath=newSrc;
					//var ftpServerIP=parseXML()+rw+"/";
					var ftpServerIP="Ftp://dhcc:,@127.0.0.1:21"+"/articleImg/"+rw+"/";
					var array=ftpServerIP.split('//');
					var loginname=array[1].split('@')[0].split(':')[0];
					var loginpassword=array[1].split('@')[0].split(':')[1];
					var mn=articleLoadImg(filepath,ftpServerIP,savename,loginname,loginpassword);
					//alert(mn);
					var imgStr=rw+"^"+ftpServerIP+savename;
					var imgRet=tkMakeServerCall('DHCMGNUR.MgNurArticleManage','saveImg',imgStr)
					if((mn=="图片上传成功！")&&(parseInt(imgRet)>0)){
						alert(mn)
						winUpload.close();
					}else{
						alert(mn)
						winUpload.close();
					}
				}else if(mn=="图片上传失败！"){
					winUpload.close();
				}
			}
		},{
	 		text : '关闭',
	 		handler : function() {winUpload.close();}
		}]
	});
	winUpload.show();		  

}
function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function exportData()
{
	var grid=Ext.getCmp('mygrid');
	var xls = new ActiveXObject ("Excel.Application");
	//xls.visible =true;  //设置excel为可见
	var xlBook = xls.Workbooks.Add;
	var xlSheet = xlBook.ActiveSheet;
	//var xlSheet = xlBook.Worksheets(1);
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
	var a=cspRunServerMethod(GetQueryData.value,"web.DHCMgNurArtManageComm:SearchNurArtList","parr$"+parr,"AddRec");
	tmpStore.loadData(arrgrid);
	var storeLen=tmpStore.getCount();
	for(i=1;i<=storeLen;i++){
		for(j=0;j<=tmpStore.fields.length-2;j++){
			xlSheet.Cells(i+1,j+1).value="'"+tmpStore.getAt(i-1).get(tmpStore.fields.items[j].name)
		}
	}
//	xlSheet.Columns.AutoFit;
//	xls.ActiveWindow.Zoom = 100;
//	xls.UserControl = true;  //很重要,不能省略,不然会出问题 意思是excel交由用户控制 
//  xls=null;
//  xlBook=null; 
//  xlSheet=null;
	var fname = xls.GetSaveAsFilename("文章列表.xls", "Excel Spreadsheets (*.xls), *.xls");
	if (fname!=""){
		xlBook.SaveAs(fname);
	}
	xlBook.Close (savechanges=false);
	xls.Quit();
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
function gridRowClick()
{
	//debugger
	var rowObj=Ext.getCmp('mygrid').getSelectionModel().getSelections();
	if(rowObj.length==0){
		Ext.Msg.alert('提示','请选择要一行记录！');
		return;
	}
	var rw=rowObj[0].get('rw');
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurArticleManage','getVal',rw);
	if(!retVal){return;}
	var ha= new Hashtable();
  	var tm=retVal.split('^')
  	sethashval(ha,tm);
  	Ext.getCmp('addpanel').items.each(function(item,index,length){
  		if(item.getXType()=="combo"){
			Ext.getCmp(item.getId()).store.load({params:{start:0,limit:2000},callback:function(){
	 			if(ha.items(item.getId())!=""){
	 				if(item.getId()&&(Ext.getCmp(item.getId()))){
	 					Ext.getCmp(item.getId()).setValue(ha.items(item.getId()));
	 				}
				}else{
	 				if(item.getId()&&(Ext.getCmp(item.getId()))){
	 					Ext.getCmp(item.getId()).setValue('');
	 				}
	 			}
	 		}})	
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
  	})
	setBtnDisable();
}
function setBtnDisable()
{
	var addBtn=Ext.getCmp('adddatabtn');
	addBtn.disable();
	var upBtn=Ext.getCmp('updatedatabtn');
	upBtn.enable();
}
function updateRecData()
{
	var grid=Ext.getCmp('mygrid');
	var rwObj=grid.getSelectionModel().getSelections();
	if(rwObj.length==0){
		Ext.Msg.alert('提示','请选择要修改的记录！');
		return;
	}
	var rw=rwObj[0].get('rw');
	saveRecData(rw);
}
function setBtnEnable()
{
	var addBtn=Ext.getCmp('adddatabtn');
	addBtn.enable();
	var upBtn=Ext.getCmp('updatedatabtn');
	upBtn.disable();
}
function schDataRec()
{
	var grid=Ext.getCmp('mygrid');
	grid.store.load({params:{start:0,limit:25}});
	setBtnEnable();
}
function addRecData(rw)
{
	
}
function saveRecData(rw)
{
	var artCategoryVal=Ext.getCmp('category').getValue();
	if(!artCategory){
		Ext.Msg.alert('提示','类别不能为空！');
		return;
	}
	var artMagzineVal=Ext.getCmp('artmagazine').getValue();
	if(!artMagzineVal){
		Ext.Msg.alert('提示','杂志名称不能为空！');
		return;
	}
	var artDateVal= Ext.getCmp('artdate').getValue();
	if(!artDateVal){
		Ext.Msg.alert('提示','发表日期不能为空！');
		return;
	}else{
		if(artDateVal instanceof Date){
			artDateVal=artDateVal.format('Y-m-d');
		}
	}
	var artTitleVal=Ext.getCmp('arttitle').getValue();
	if(!artTitleVal){
		Ext.Msg.alert('提示','文章题目不能为空！');
		return;
	}else{
		artTitleVal=artTitleVal.replace(/(^\s*)|(\s*$)/g, "");
	}
	var artTypeVal=Ext.getCmp('arttype').getValue();
	if(!artTypeVal){
		Ext.Msg.alert('提示','文章类型不能为空！');
		return;
	}
	var volTextVal=Ext.getCmp('voltext').getValue();
	if(!volTextVal){
		Ext.Msg.alert('提示','卷不能为空！');
		return;
	}
	var artTermVal=Ext.getCmp('artterm').getValue();
	if(!artTermVal){
		Ext.Msg.alert('提示','期不能为空！');
		return;
	}
	var artPageVal=Ext.getCmp('artpage').getValue();
//	if(!artPageVal){
//		Ext.Msg.alert('提示','所在页码不能为空！');
//		return;
//	}
	var artHeadComVal=Ext.getCmp('artheadcom').getValue();
	if(!artHeadComVal){
		Ext.Msg.alert('提示','发表栏目不能为空！');
		return;
	}
	var artFirstAuthVal=Ext.getCmp('artfirstauth').getValue();
	if(!artFirstAuthVal){
		Ext.Msg.alert('提示','第一作者不能为空！');
		return;
	}
	var artFirAuthLevVal=Ext.getCmp('artfirauthlev').getValue();
	var artFirAuthHeadVal= Ext.getCmp('artfirauthhead').getValue();
	var artFirAuthDutyVal=Ext.getCmp('artfirauthduty').getValue();
	var artFirAuthBigVal=Ext.getCmp('artfirauthbig').getValue();
	var artFirAuthLocVal=Ext.getCmp('artfirauthloc').getValue();
	var artWriterVal=Ext.getCmp('artwriter').getValue();
	var artWriterLevVal= Ext.getCmp('artwriterlev').getValue();
	var artWriteHeadVal=Ext.getCmp('artwriterhead').getValue();
	var artWriteDutyVal=Ext.getCmp('artwriterduty').getValue();
	var artWriteBigVal=Ext.getCmp('artwriterbig').getValue();
	var artWriteLocVal=Ext.getCmp('artwriterloc').getValue();
	var artSecAuthVal=Ext.getCmp('artsecauth').getValue();
	var artThirdAuthVal=Ext.getCmp('artthirdauth').getValue();
	var artOtAuthVal=Ext.getCmp('artotauth').getValue();
	
	var parr="artCategoryVal@"+artCategoryVal+"^artMagzineVal@"+artMagzineVal+"^artDateVal@"+artDateVal+"^artTitleVal@"+artTitleVal+"^artTypeVal@"+artTypeVal+
	"^volTextVal@"+volTextVal+"^artTermVal@"+artTermVal+"^artPageVal@"+artPageVal+"^artHeadComVal@"+artHeadComVal+"^artFirstAuthVal@"+artFirstAuthVal+
	"^artFirAuthLevVal@"+artFirAuthLevVal+"^artFirAuthHeadVal@"+artFirAuthHeadVal+"^artFirAuthDutyVal@"+artFirAuthDutyVal+"^artFirAuthBigVal@"+artFirAuthBigVal+
	"^artFirAuthLocVal@"+artFirAuthLocVal+"^artWriterVal@"+artWriterVal+"^artWriterLevVal@"+artWriterLevVal+"^artWriteHeadVal@"+artWriteHeadVal+
	"^artWriteDutyVal@"+artWriteDutyVal+"^artWriteBigVal@"+artWriteBigVal+"^artWriteLocVal@"+artWriteLocVal+"^artSecAuthVal@"+artSecAuthVal+
	"^artThirdAuthVal@"+artThirdAuthVal+"^artOtAuthVal@"+artOtAuthVal+"^rw@"+rw;
	var strVal=artDateVal+"^"+artTitleVal+"^"+artFirstAuthVal+"^"+rw;
	var isExistFlag=tkMakeServerCall('DHCMGNUR.MgNurArticleManage','isExist',strVal);
	//if(isExistFlag&&!rw){
	if(isExistFlag==1){
		Ext.Msg.alert('提示','此文章已经存在，请确认!');
		return;
	}
	
	var retVal=tkMakeServerCall('DHCMGNUR.MgNurArticleManage','Save',parr);
	schDataRec();
}
function clearItm()
{
	Ext.getCmp('category').setValue('');
	Ext.getCmp('artmagazine').setValue('');
	Ext.getCmp('artdate').setValue('');
	Ext.getCmp('arttitle').setValue('');
	Ext.getCmp('arttype').setValue('');
	Ext.getCmp('voltext').setValue('');
	Ext.getCmp('artterm').setValue('');
	Ext.getCmp('artpage').setValue('');
	Ext.getCmp('artheadcom').setValue('');
	Ext.getCmp('artfirstauth').setValue('');
	Ext.getCmp('artfirauthlev').setValue('');
	Ext.getCmp('artfirauthhead').setValue('');
	Ext.getCmp('artfirauthduty').setValue('');
	Ext.getCmp('artfirauthbig').setValue('');
	Ext.getCmp('artfirauthloc').setValue('');
	Ext.getCmp('artwriter').setValue('');
	Ext.getCmp('artwriterlev').setValue('');
	Ext.getCmp('artwriterhead').setValue('');
	Ext.getCmp('artwriterduty').setValue('');
	Ext.getCmp('artwriterbig').setValue('');
	Ext.getCmp('artwriterloc').setValue('');
	Ext.getCmp('artsecauth').setValue('');
	Ext.getCmp('artthirdauth').setValue('');
	Ext.getCmp('artotauth').setValue('');
	setBtnEnable();
	var grid=Ext.getCmp('mygrid');
	//grid.store.load({params:{start:0,limit:25}});
	schDataRec();
}
function createGrid()
{
	var ttable=createListTable();
	var tpanel=createPanel();
	var mainpanel=new Ext.Panel({
		id:'mainpanle',
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
	//Ext.getCmp('mygrid').on('rowclick',function(){gridRowClick();});
}
function createListTable()
{
	var colModelStr = new Array();
	var colData = new Array();
	colModelStr.push(new Ext.grid.RowNumberer());
	colModelStr.push({header:"类别",width:80,dataIndex:'ArtCategory'});
	colData.push({'name':'ArtCategory','mapping':'ArtCategory'});
	colModelStr.push({header:"杂志名称",width:100,dataIndex:'ArtMagazine'});
	colData.push({'name':'ArtMagazine','mapping':'ArtMagazine'});	
	colModelStr.push({header:"文章题目",width:300,dataIndex:'ArtTitle'});
	colData.push({'name':'ArtTitle','mapping':'ArtTitle'});
	colModelStr.push({header:"发表日期",width:100,dataIndex:'ArtDate'});
	colData.push({'name':'ArtDate','mapping':'ArtDate'});
	colModelStr.push({header:"卷",width:50,dataIndex:'ArtVolume'});
	colData.push({'name':'ArtVolume','mapping':'ArtVolume'});
	colModelStr.push({header:"期",width:50,dataIndex:'ArtTerm'});
	colData.push({'name':'ArtTerm','mapping':'ArtTerm'});	
	colModelStr.push({header:"所在页码",width: 70,dataIndex:'ArtPage'});
	colData.push({'name':'ArtPage','mapping':'ArtPage'});	
	colModelStr.push({header:"发表栏目",width:80,dataIndex:'ArtHeading'});
	colData.push({'name':'ArtHeading','mapping':'ArtHeading'});	
	colModelStr.push({header:'文章类型',width:80,dataIndex:'ArtType'});
	colData.push({'name':'ArtType','mapping':'ArtType'});
	colModelStr.push({header:"第一作者",width:100,dataIndex: 'ArtFirAuthor'});
	colData.push({'name':'ArtFirAuthor','mapping':'ArtFirAuthor'});	
	colModelStr.push({header:"通讯作者",width:100,dataIndex:'ArtWriter'});
	colData.push({'name':'ArtWriter','mapping':'ArtWriter'});	
	colModelStr.push({header:"第二作者",width:100,dataIndex:'ArtSecAuthor'});
	colData.push({'name':'ArtSecAuthor','mapping':'ArtSecAuthor'});	
	colModelStr.push({header:"第三作者",width:100,dataIndex:'ArtThirdAuthor'});
	colData.push({'name':'ArtThirdAuthor','mapping':'ArtThirdAuthor'});
	colModelStr.push({header:"其他作者",width:120,dataIndex:'ArtOtAuthor'});
	colData.push({'name':'ArtOtAuthor','mapping':'ArtOtAuthor'});	
	colModelStr.push({header:"通讯作者层级",width:100,dataIndex:'ArtWriterLev'});
	colData.push({'name':'ArtWriterLev','mapping':'ArtWriterLev'});	
	colModelStr.push({header:"通讯作者职务",width:100,dataIndex:'ArtWriterHead'});
	colData.push({'name':'ArtWriterHead','mapping':'ArtWriterHead'});	
	colModelStr.push({header:"通讯作者职称",width:100,dataIndex:'ArtWriterDuty'});
	colData.push({'name':'ArtWriterDuty','mapping':'ArtWriterDuty'});	
	colModelStr.push({header:"通讯作者所在大科",width:120,dataIndex:'ArtWriterBig'});
	colData.push({'name':'ArtWriterBig','mapping':'ArtWriterBig'});	
	colModelStr.push({header:'通讯作者所在病房',width:180,dataIndex:'ArtWriterLoc'});
	colData.push({'name':'ArtWriterLoc','mapping':'ArtWriterLoc'});
	colModelStr.push({header:"第一作者层级",width:100,dataIndex:'ArtFirAuthorLev'});
	colData.push({'name':'ArtFirAuthorLev','mapping':'ArtFirAuthorLev'});	
	colModelStr.push({header:"第一作者职务",width:100,dataIndex:'ArtFirAuthorHead'});
	colData.push({'name':'ArtFirAuthorHead','mapping':'ArtFirAuthorHead'});
	colModelStr.push({header:"第一作者职称",width:100,dataIndex:'ArtFirAuthorDuty'});
	colData.push({'name':'ArtFirAuthorDuty','mapping':'ArtFirAuthorDuty'});
	colModelStr.push({header:"第一作者所在大科",width:120,dataIndex:'ArtFirAuthorBig'});
	colData.push({'name':'ArtFirAuthorBig','mapping':'ArtFirAuthorBig'});
	colModelStr.push({header:"第一作者所在病房",width:180,dataIndex:'ArtFirAuthorLoc'});
	colData.push({'name':'ArtFirAuthorLoc','mapping':'ArtFirAuthorLoc'});
	colModelStr.push({header:"rw",width:30,dataIndex:'rw',hidden:true});
	colData.push({'name':'rw','mapping':'rw'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',fields:colData}),
		baseParams:{
			className:'web.DHCMgNurArtManageComm',
			methodName:'SearchNurArtList',
			type:'RecQuery'
		},
		listeners:{
			beforeload:function(thisstore){
				//thisstore.baseParams.par=paid+"|"+"@"+itmCount+"@Y@"+Ext.getCmp('myRadioGroup').getValue().inputValue;
			}
			//,
			//load:function(thisstore,recodes,o){}	
		}
	});
	var table = new Ext.grid.GridPanel({
		id:'mygrid',
		title:'文章管理列表',
		region: 'center',
		//split: true,
		height:Height/2+20,
		width:Width,
		x:0,y:0,
		//collapsible: false,
		//margins:'0 0 0 0',
		store: store,
		tbar:[],
		bbar:new Ext.PagingToolbar({
			id:'pageid',
      		pageSize:25,
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
      		},
      		moveFirst:function(){
      			this.doLoad(0);
      			if(Ext.getCmp('mygrid').getSelectionModel().getSelections().length>0)
      			{
      				setTimeout("schDataRec()",100);
      			}
      		},
      		moveNext:function(){
      			this.doLoad(this.cursor+this.pageSize);
      			if(Ext.getCmp('mygrid').getSelectionModel().getSelections().length>0)
      			{
      				setTimeout("schDataRec()",100);
      			}
      		},
      		moveLast:function(){
      			var c=this.store.getTotalCount(),b=c%this.pageSize;
      			this.doLoad(b?(c-b):c-this.pageSize);
      			if(Ext.getCmp('mygrid').getSelectionModel().getSelections().length>0)
      			{
      				setTimeout("schDataRec()",100);
      			}
      		},
      		movePrevious:function(){
      			this.doLoad(Math.max(0,this.cursor-this.pageSize));
      			if(Ext.getCmp('mygrid').getSelectionModel().getSelections().length>0)
      			{
      				setTimeout("schDataRec()",100);
      			}
      		}
    	}),
		cm:colModel,
		sm:new Ext.grid.CheckboxSelectionModel()
	});
	return table;
}
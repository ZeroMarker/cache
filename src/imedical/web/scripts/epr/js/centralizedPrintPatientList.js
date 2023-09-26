//分页页面大小
var eprPageSize = 5;

//查询基本条件
var admNo = "";
var patientNo = "";
var patientName = "";
var patientLocID = "";
var patientWardID = "";
var startDate = "";
var startTime = "";
var endDate = "";
var endTime = "";
var outStartDate = "";
var outStartTime = "";
var outEndDate = "";
var outEndTime = "";

//更多查询条件
var statusType = "";
var provinceBirth = "";
var gender = "";
var age = "";
var occupation = "";
var pAAdmType = "";
var cityBirth = "";
var marriage = "";
var nation = "";
var mobilePhone = "";
var birthday = "";
var idCardNo = "";

//科室字典
var getLocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxPatientLocID").getRawValue();
			getLocStore.baseParams = { DicCode: 'S07', DicQuery: txtValueText};
		}
	}
});
//病区字典
var getWardStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxPatientWardID").getRawValue();
			getWardStore.baseParams = { DicCode: 'S10', DicQuery: txtValueText};
		}
	}
});

//省份字典
var getProvinceStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxProvinceBirth").getRawValue();
			getProvinceStore.baseParams = { DicCode: 'S01', DicQuery: txtValueText};
		}
	}
});

//城市字典
var getCityStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxCityBirth").getValue();
			getCityStore.baseParams = { DicCode: 'S02', DicQuery: txtValueText};
		}
	}
});

//民族字典
var getNationStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxNation").getValue();
			getNationStore.baseParams = { DicCode: 'S04', DicQuery: txtValueText};
		}
	}
});

//职业字典
var getOccupationStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxOccupation").getValue();
			getOccupationStore.baseParams = { DicCode: 'S08', DicQuery: txtValueText};
		}
	}
});

var searchCondition = new Ext.Panel({
	id: 'searchCondition',
	labelWidth: 80,
	frame:true,
	title: '查询条件：',
	bodyStyle:'padding:0px 0px 0px 0px',
	buttonAlign:'left',
	labelAlign : 'right',
	items:[{
		layout:'table',
		layoutConfig:{
			columns:3
		},
		items:[{
			xtype:'fieldset',
			collapsible: false,
			title: '查询条件',
			autoHeight:true,
			layout:'table',
			layoutConfig:{
				columns:6
			},
			bodyStyle:'padding:0px 0px 0px 0px',
			items :[{
				width:80,
				html:'<div align="right"><font size="2">登记号：</font></div>'
			},{
				id: 'txtPatientNo',
				name: 'txtPatientNo',
				xtype: 'textfield',
				width: 80,
				emptyText: '请填写登记号'
			},{
				width:55,
				html:'<div align="right"><font size="2">科室：</font></div>'
			},{
				id: 'cbxPatientLocID',
	        	name: 'cbxPatientLocID',
				xtype: 'combo',
				width: 80,
				minChars: 1,
				store:getLocStore,
				hiddenName: 'locID',
				displayField: 'DicDesc',
				valueField: 'DicCode',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择患者科室',
				listWidth: 240,
				pageSize: 12,
				mode : 'remote'
			},{
				width:100,
				html:'<div align="right"><font size="2">病人姓名：</font></div>'
			},{
	  			id: 'txtPatientName',
	       		name: 'txtPatientName',
	        	xtype: 'textfield',
				width: 80,
				emptyText: '请填写病人姓名'
			},{
				width:80,
				html:'<div align="right"><font size="2">就诊号：</font></div>'
			},{
				id: 'txtAdmNo',
				name: 'txtAdmNo',
				xtype: 'textfield',
				width: 80,
				emptyText: '请填写就诊号'
			},{
				width:55,
				html:'<div align="right"><font size="2">病区：</font></div>'
			},{
				id: 'cbxPatientWardID',
				name: 'cbxPatientWardID',
				xtype: 'combo',
				width: 80,
				minChars: 1,
				store: getWardStore,
				hiddenName: 'wardID',
				displayField: 'DicDesc',
				valueField: 'DicCode',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择患者病区',
				listWidth: 240,
				pageSize: 12,
				mode : 'remote'
			}]
		},{
			html:'&nbsp;&nbsp;&nbsp;'
		},{
			xtype:'fieldset',
			id:'dateTimeCondition',
			title: '日期时间条件',
			autoHeight:true,
			layout:'table',
			layoutConfig:{
				columns:6
			},
			bodyStyle:'padding:0px 25px 0px 0px;',
			items:[{
				width:160,
				html:'<div align="right"><font size="2">入院日期（起始）：</font></div>'
			},{
				id: 'dtAdmissionDateStart',
				name: 'dtAdmissionDateStart',
	        	xtype: 'datefield',
				anchor: '100%',
				width: 80,
	        	format: 'Y-m-d',
				emptyText: '请选择入院日期起始范围',
				listeners: {
					scope:this,
					change:function(){
						if (Ext.getCmp('dtAdmissionDateStart').getValue() != "") {
							Ext.getCmp('tmAdmissionTimeStart').setVisible(true);
						}
						else{
							Ext.getCmp('tmAdmissionTimeStart').clearValue();
							Ext.getCmp('tmAdmissionTimeStart').setVisible(false);
						}
					}
				}
			},{
				id: 'tmAdmissionTimeStart',
				name: 'tmAdmissionTimeStart',
				xtype: 'timefield',
				hideLabel: true,
				anchor: '90%',
				width: 70,
				increment: 60,
				format: 'H:i',
				hidden: true,
				emptyText: '请选择入院时间起始范围'	
			},{
				width:160,
				html:'<div align="right"><font size="2">出院日期（起始）：</font></div>'
			},{
				id: 'dtOutDateStart',
				name: 'dtOutDateStart',
	        	xtype: 'datefield',
				anchor: '100%',
				width: 80,
	        	format: 'Y-m-d',
				emptyText: '请选择出院日期起始范围',
				listeners: {
					scope:this,
					change:function(){
						if (Ext.getCmp('dtOutDateStart').getValue() != "") {
							Ext.getCmp('tmOutTimeStart').setVisible(true);
						}
						else{
							Ext.getCmp('tmOutTimeStart').clearValue();
							Ext.getCmp('tmOutTimeStart').setVisible(false);
						}
					}
				}
			},{
				id: 'tmOutTimeStart',
				name: 'tmOutTimeStart',
				xtype: 'timefield',
				hideLabel: true,
				anchor: '90%',
				width: 70,
				increment: 60,
				format: 'H:i',
				hidden: true,
				emptyText: '请选择出院时间起始范围'		
			},{
				width:160,
				html:'<div align="right"><font size="2">入院日期（终止）：</font></div>'
			},{
				id: 'dtAdmissionDateEnd',
	        	name: 'dtAdmissionDateEnd',
	        	xtype: 'datefield',
				anchor: '100%',
				width: 80,
				format: 'Y-m-d',
				emptyText: '请选择入院日期结束范围',
				listeners: {
					scope:this,
					change:function(){
						if (Ext.getCmp('dtAdmissionDateEnd').getValue() != "") {
							Ext.getCmp('tmAdmissionTimeEnd').setVisible(true);
						}
						else{
							Ext.getCmp('tmAdmissionTimeEnd').clearValue();
							Ext.getCmp('tmAdmissionTimeEnd').setVisible(false);
						}
					}
				}
			},{
				id: 'tmAdmissionTimeEnd',
	        	name: 'tmAdmissionTimeEnd',
				xtype: 'timefield',
				hideLabel: true,
				anchor: '90%',
				width: 70,
				increment: 60,
				format: 'H:i',
				hidden: true,
				emptyText: '请选择入院时间结束范围'
			},{
				width:160,
				html:'<div align="right"><font size="2">出院日期（终止）：</font></div>'
			},{
				id: 'dtOutDateEnd',
	        	name: 'dtOutDateEnd',
	        	xtype: 'datefield',
				anchor: '100%',
				width: 80,
				format: 'Y-m-d',
				emptyText: '请选择出院日期结束范围',
				listeners: {
					scope:this,
					change:function(){
						if (Ext.getCmp('dtOutDateEnd').getValue() != "") {
							Ext.getCmp('tmOutTimeEnd').setVisible(true);
						}
						else{
							Ext.getCmp('tmOutTimeEnd').clearValue();
							Ext.getCmp('tmOutTimeEnd').setVisible(false);
						}
					}
				}
			},{
				id: 'tmOutTimeEnd',
	        	name: 'tmOutTimeEnd',
				xtype: 'timefield',
				hideLabel: true,
				anchor: '90%',
				width: 70,
				increment: 60,
				format: 'H:i',
				hidden: true,
				emptyText: '请选择出院时间结束范围'	
			}]
		}]
	},{
		xtype:'fieldset',
		id:'additionalCondition',
		title: '更多查询条件',
		colspan:2,
		autoHeight:true,
		layout:'table',
		layoutConfig:{
			columns:10
		},
		bodyStyle:'padding:0px 0px 0px 0px',
		items :[{
			width:100,
			html:'<div align="right"><font size="2">在院状态：</font></div>'
		},{
			id: 'cbxStatusType',
			name: 'cbxStatusType',
        	xtype: 'combo',
			width: 80,
			anchor: '90%',
			readOnly: true,
			editable: false,
        	store: new Ext.data.SimpleStore({
        		fields: ['id', 'name'],
				data:[
					['A','在院患者'],
					['D','出院患者'],
					['','全部']
				]
			}),
			mode: 'local',
       		displayField: 'name',
			valueField: 'id',
        	triggerAction: 'all',
        	selectOnFocus: true,
        	emptyText: '请选择在院状态'
		},{
			width:100,
			html:'<div align="right"><font size="2">性别：</font></div>'	
		},{			
			id: 'cbxGender',
			name: 'cbxGender',
        	xtype: 'combo',
			width: 80,
			anchor: '90%',
			readOnly: true,
			editable: false,
        	store: new Ext.data.SimpleStore({
        		fields: ['id', 'name'],
				data:[
					['1','男'],
					['2','女'],
					['','全部']
				]
			}),
			mode: 'local',
       		displayField: 'name',
			valueField: 'id',
        	triggerAction: 'all',
        	selectOnFocus: true,
        	emptyText: '请选择性别'		
		},{
			width:100,
			html:'<div align="right"><font size="2">年龄：</font></div>'
		},{
			id: 'txtAge',
			name: 'txtAge',
			xtype: 'numberfield',
			width: 80,
			emptyText: '请填写年龄'			
		},{
			width:100,
			html:'<div align="right"><font size="2">职业：</font></div>'
		},{
			id: 'cbxOccupation',
			name: 'cbxOccupation',
			xtype: 'combo',
			width: 80,
			minChars: 1,
			store:getOccupationStore,
			hiddenName: 'provinceID',
			displayField: 'DicDesc',
			valueField: 'DicCode',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请填写职业',
			listWidth: 240,
			pageSize: 12,
			mode : 'remote'
		},{
			width:100,
			html:'<div align="right"><font size="2">出生省份：</font></div>'
		},{
			id: 'cbxProvinceBirth',
        	name: 'cbxProvinceBirth',
			xtype: 'combo',
			width: 80,
			minChars: 1,
			store:getProvinceStore,
			hiddenName: 'provinceID',
			displayField: 'DicDesc',
			valueField: 'DicCode',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请填写出生省份',
			listWidth: 240,
			pageSize: 12,
			mode : 'remote',
			listeners: {
				scope: this,
				change: function(){
					if (Ext.getCmp('cbxProvinceBirth').getValue() != ""){
						Ext.getCmp('cbxCityBirth').enable();
					}
					else{
						Ext.getCmp('cbxCityBirth').disable();
					}
					Ext.getCmp('cbxCityBirth').setValue("");
					getCityStore.reload();
				}
			}
		},{
			width:100,
			html:'<div align="right"><font size="2">就诊类型：</font></div>'
		},{
			id: 'cbxPAAdmType',
			name: 'cbxPAAdmType',
           	xtype: 'combo',
			fieldLabel: '就诊类型',
			width: 80,
			anchor: '90%',
			editable: false,
            store: new Ext.data.SimpleStore({
            	fields: ['id', 'name'],
				data:[
					['I','住院'],
					['O','门诊'],
					['E','急诊'],
					['','全部']
				]
			}),
			mode: 'local',
			displayField: 'name',
			valueField: 'id',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请选择就诊类型'		
		},{
			width:100,
			html:'<div align="right"><font size="2">婚姻：</font></div>'
		},{
			id: 'cbxMarriage',
			name: 'cbxMarriage',
        	xtype: 'combo',
			width: 80,
			anchor: '90%',
			readOnly: true,
			editable: false,
        	store: new Ext.data.SimpleStore({
        		fields: ['id', 'name'],
				data:[
					['02','已婚'],
					['01','未婚'],
					['','全部']
				]
			}),
			mode: 'local',
       		displayField: 'name',
			valueField: 'id',
        	triggerAction: 'all',
        	selectOnFocus: true,
        	emptyText: '请选择婚姻状况'	
		},{
			width:100,
			html:'<div align="right"><font size="2">手机：</font></div>'
		},{
			id: 'txtMobilePhone',
			name: 'txtMobilePhone',
			xtype: 'textfield',
			width: 80,
			emptyText: '请填写手机'	
		},{
			width:100,
			html:'<div align="right"><font size="2">民族：</font></div>'
		},{
			id: 'cbxNation',
			name: 'cbxNation',
			xtype: 'combo',
			width: 80,
			minChars: 1,
			store:getNationStore,
			hiddenName: 'cityID',
			displayField: 'DicDesc',
			valueField: 'DicCode',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请填写民族',
			listWidth: 240,
			pageSize: 12,
			mode : 'remote'
		},{
			width:100,
			html:'<div align="right"><font size="2">出生城市：</font></div>'
		},{
			id: 'cbxCityBirth',
        	name: 'cbxCityBirth',
			xtype: 'combo',
			width: 80,
			minChars: 1,
			store:getCityStore,
			hiddenName: 'cityID',
			displayField: 'DicDesc',
			valueField: 'DicCode',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请填写出生城市',
			listWidth: 240,
			pageSize: 12,
			mode : 'remote',
			disabled: true
			},{
				width:100,
				html:'<div align="right"><font size="2">身份证号：</font></div>'
			},{
				id: 'txtPatientIDNo',
				name: 'txtPatientIDNo',
				xtype: 'textfield',
				width: 80,
				emptyText: '请填写身份证号',
				vtype: 'alphanum',
				regex: /^(\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$/,
				regexText:'身份证号错误'
		},{
			width:100,
			html:'<div align="right"><font size="2">生日：</font></div>'
		},{
			id: 'dtBirthday',
        	name: 'dtBirthday',
        	xtype: 'datefield',
			anchor: '100%',
			width: 80,
			format: 'Y-m-d',
			emptyText: '请选择生日'	
		}]		
	}],
	buttons :[{
		id: 'btnSearch',
		text: '查找',
		style : 'margin-left:10px',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/btnSearch.gif',
		pressed: false,
		handler: doSearch
	},{
		id: 'btnReset',
		text: '重置',
		style : 'margin-left:10px',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/sltPrint.gif',
		pressed: false,
		handler: doReset
	},{
		id: 'btnSwitch',
		text: '确定',
		style : 'margin-left:10px',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/btnConfirm.gif',
		pressed: false,
		handler: doSwitch
	},{
		id: 'btnSwitch',
		text: '返回',
		style : 'margin-left:100px',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/sltPrint.gif',
		pressed: false,
		handler: doBack
	}],
	keys:[{
		key: Ext.EventObject.ENTER,
		scope:this,
		fn:doSearch
	}]
});

searchCondition.render(document.body);

function rendererPADischgeDateTime(val){
	if (val == "" || typeof(val) == "undefined") {
		return;
	}
	else {
		if (val == "1840-12-31,12:00:00AM") {
			return "";
		}
		else {
			return val;
		}
	}	
}

var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.CentralizedPrintPatientList.cls',
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
		{name: 'PAStatusType'},
        {name: 'PAAdmType'},
        {name: 'PAPMIName'},
        {name: 'PAPMINO'},
        {name: 'PAPMIDOB'},
        {name: 'PAPMIAge'},
        {name: 'PAPMISex'},
        {name: 'PAAdmDateTime'},
        {name: 'PAAdmWard'},
        {name: 'PAAdmRoom'},
        {name: 'PAAdmBed'},
        {name: 'PAAdmLoc'},
        {name: 'PADischgeDateTime'},
        {name: 'PAAdmDoc'},
        {name: 'PayMode'},
        {name: 'EpisodeID'},
		{name: 'PatientID'}
    ]
});
eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });

var cm = new Ext.grid.ColumnModel([
	{ header: '在院状态', dataIndex: 'PAStatusType', align: 'center'},
    { header: '就诊类型', dataIndex: 'PAAdmType', align: 'center'},
    { header: '病人姓名', dataIndex: 'PAPMIName', align: 'center'},
    { header: '登记号', dataIndex: 'PAPMINO', align: 'center'},
    { header: '出生日期', dataIndex: 'PAPMIDOB', align: 'center'},
    { header: '年龄', dataIndex: 'PAPMIAge', align: 'center'},
    { header: '性别', dataIndex: 'PAPMISex', align: 'center'},
    { header: '入院时间', dataIndex: 'PAAdmDateTime', align: 'center'},
    { header: '病区', dataIndex: 'PAAdmWard', align: 'center'},
    { header: '病房', dataIndex: 'PAAdmRoom', align: 'center'},
	{ header: '病床', dataIndex: 'PAAdmBed', align: 'center'},
	{ header: '科室', dataIndex: 'PAAdmLoc', align: 'center'},
    { header: '出院时间', dataIndex: 'PADischgeDateTime', align: 'center',renderer: rendererPADischgeDateTime},
	{ header: '医生', dataIndex: 'PAAdmDoc', align: 'center'},
    { header: '付费类型', dataIndex: 'PayMode', align: 'center'},
    { header: '就诊号', dataIndex: 'EpisodeID', align: 'center'}
]);

var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
	title:'结果列表',
    border: false,
    store: eprEpisodeStore,
    cm: cm,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    autoScroll: true,
    frame: true,
    stripeRows: true,
	viewConfig: { forceFit: false },
    bbar: new Ext.PagingToolbar({
        id: "eprPagingToolbar",
        store: eprEpisodeStore,
        pageSize: eprPageSize,
        displayInfo: true,
        displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
        beforePageText: '页码',
        afterPageText: '总页数 {0}',
        firstText: '首页',
        prevText: '上一页',
        nextText: '下一页',
        lastText: '末页',
        refreshText: '刷新',
        emptyMsg: "没有记录"
    })
});

eprEpisodeGrid.on("rowdblclick", function(g, rowindex, e) {
    var selModel = Ext.getCmp('eprEpisodeGrid').getSelectionModel();
    var selects = selModel.getSelections();
    if (selects.length == 0) {
        Ext.MessageBox.alert('操作提示', '请先选择一个就诊病人!');
        return;
    }
	var row = selects[0];

    var patientID = row.get('PatientID');
    var episodeID = row.get('EpisodeID');
    
    parent.doSwitch(patientID,episodeID);
});

var eprPortal = new Ext.Viewport({
    id: 'patientListPort',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
	autoScroll:true,
	layout:'border',
	items: [{
		border:true,
		layout:'fit',
		region:'north',
		autoHeight:true,
		autoScroll:true,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:searchCondition
	},{
		border: false,
		layout:'fit',
		region:'center',
		id: 'episodelist',
		height: 500,
		autoScroll:true,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:eprEpisodeGrid
	}]
});

function doSearch() {
    //基本条件
	admNo = Ext.getCmp('txtAdmNo').getValue().replace(/\s/g, "");
	patientNo = Ext.getCmp('txtPatientNo').getValue().replace(/\s/g, "");
	patientName = encodeURI(Ext.getCmp('txtPatientName').getValue().replace(/\s/g, ""));
	patientLocID = Ext.getCmp('cbxPatientLocID').getValue();
	patientWardID = Ext.getCmp('cbxPatientWardID').getValue();
	if(typeof(Ext.getCmp('dtAdmissionDateStart'))!= "undefined" && Ext.getCmp('dtAdmissionDateStart').getValue() != ""){
		startDate = Ext.getCmp('dtAdmissionDateStart').getValue().format('Y-m-d');
	}
	if(typeof(Ext.getCmp('dtAdmissionDateEnd'))!= "undefined" && Ext.getCmp('dtAdmissionDateEnd').getValue() != ""){
		endDate = Ext.getCmp('dtAdmissionDateEnd').getValue().format('Y-m-d');
	}
	startTime = Ext.getCmp('tmAdmissionTimeStart').getValue();
	endTime = Ext.getCmp('tmAdmissionTimeEnd').getValue();
	if(typeof(Ext.getCmp('dtOutDateStart'))!= "undefined" && Ext.getCmp('dtOutDateStart').getValue() != ""){
		outStartDate = Ext.getCmp('dtOutDateStart').getValue().format('Y-m-d');
	}
	if(typeof(Ext.getCmp('dtOutDateEnd'))!= "undefined" && Ext.getCmp('dtOutDateEnd').getValue() != ""){
		outEndDate = Ext.getCmp('dtOutDateEnd').getValue().format('Y-m-d');
	}
	outStartTime = Ext.getCmp('tmOutTimeStart').getValue();
	outEndTime = Ext.getCmp('tmOutTimeEnd').getValue();

	//更多条件
	statusType = Ext.getCmp('cbxStatusType').getValue();
	pAAdmType = Ext.getCmp('cbxPAAdmType').getValue();
	provinceBirth = Ext.getCmp('cbxProvinceBirth').getValue().replace(/\s/g, "");
	cityBirth = Ext.getCmp('cbxCityBirth').getValue().replace(/\s/g, "");	
	gender = Ext.getCmp('cbxGender').getValue();
	//add by yhy 2014-5-5
	age = Ext.getCmp('txtAge').getValue();
	occupation = Ext.getCmp('cbxOccupation').getValue().replace(/\s/g, "");
	marriage = Ext.getCmp('cbxMarriage').getValue();
	nation = Ext.getCmp('cbxNation').getValue();
	mobilePhone = Ext.getCmp('txtMobilePhone').getValue().replace(/\s/g, "");
	if(typeof(Ext.getCmp('dtBirthday'))!= "undefined" && Ext.getCmp('dtBirthday').getValue() != ""){
		birthday = Ext.getCmp('dtBirthday').getValue().format('Y-m-d');
	}
	idCardNo = Ext.getCmp('txtPatientIDNo').getValue().replace(/\s/g, "");

	var additionalCondition = '&StatusType=' + statusType 
							+ '&ProvinceBirth=' + provinceBirth 
							+ '&Gender=' + gender 
							+ '&Age=' + age
							+ '&Occupation=' + occupation 
							+ '&PAAdmType=' + pAAdmType 
							+ '&CityBirth=' + cityBirth
							+ '&Marriage=' + marriage
							+ '&Nation=' + nation 
							+ '&MobilePhone=' + mobilePhone 
							+ '&Birthday=' + birthday
							+ '&IdCardNo=' + idCardNo;
	
	if ((admNo == "") && (patientNo == "") && (patientName == "") && (patientLocID == "") && (patientWardID == "") && (startDate == "") && (endDate == "") && (startTime == "") && (endTime == "")) {
		Ext.MessageBox.alert('操作提示', '请填写至少一项查询条件');
	}
	else {
		Ext.getCmp('eprEpisodeGrid').getEl().mask('数据重新加载中，请稍等');
		var s = Ext.getCmp('eprEpisodeGrid').getStore();
		var url = '../web.eprajax.CentralizedPrintPatientList.cls?PatientNo=' + patientNo 
																+ '&AdmNo=' + admNo 
																+ '&PatientName=' + patientName 
																+ '&PatientLocID=' + patientLocID 
																+ '&PatientWardID=' + patientWardID 
																+ '&StartDate=' + startDate 
																+ '&StartTime=' + startTime 
																+ '&EndDate=' + endDate 
																+ '&EndTime=' + endTime
																+ '&OutStartDate=' + outStartDate 
																+ '&OutStartTime=' + outStartTime
																+ '&OutEndDate=' + outEndDate 
																+ '&OutEndTime=' + outEndTime
																+ additionalCondition;
		s.proxy.conn.url = url;
		s.load({
			params: {
				start: 0,
				limit: eprPageSize
			}
		});
		
		s.on('load', function(store, record){
			//debugger;
			Ext.get('eprEpisodeGrid').unmask();
		});
		
		s.on('loadexception', function(proxy, options, response, e){
			//debugger;
			Ext.get('eprEpisodeGrid').unmask();
		});
	}
}

function doReset() {
	//基本查询条件
	Ext.getCmp('txtAdmNo').setValue("");
	Ext.getCmp('txtPatientNo').setValue("");
	Ext.getCmp('cbxPatientLocID').setValue("");
	Ext.getCmp('txtPatientName').setValue("");
	Ext.getCmp('cbxPatientWardID').setValue("");
	Ext.getCmp('dtAdmissionDateStart').setValue("");
	Ext.getCmp('tmAdmissionTimeStart').setValue("");
	Ext.getCmp('tmAdmissionTimeStart').setVisible(false);
	Ext.getCmp('dtAdmissionDateEnd').setValue("");
	Ext.getCmp('tmAdmissionTimeEnd').setValue("");
	Ext.getCmp('tmAdmissionTimeEnd').setVisible(false);
	Ext.getCmp('dtOutDateStart').setValue("");
	Ext.getCmp('tmOutTimeStart').setValue("");
	Ext.getCmp('tmOutTimeStart').setVisible(false);
	Ext.getCmp('dtOutDateEnd').setValue("");
	Ext.getCmp('tmOutTimeEnd').setValue("");
	Ext.getCmp('tmOutTimeEnd').setVisible(false);
	admNo = "";
	patientNo = "";
	patientName = "";
	patientLocID = "";
	patientWardID = "";
	startDate = "";
	startTime = "";
	endDate = "";
	endTime = "";
	outStartDate = "";
	outStartTime = "";
	outEndDate = "";
	outEndTime = "";
	//更多过滤条件
	Ext.getCmp('cbxStatusType').setValue("");
	Ext.getCmp('cbxProvinceBirth').setValue("");
	Ext.getCmp('cbxGender').setValue("");
	Ext.getCmp('txtAge').setValue("");
	Ext.getCmp('cbxOccupation').setValue("");
	Ext.getCmp('cbxPAAdmType').setValue("");
	Ext.getCmp('cbxCityBirth').setValue("");	
	Ext.getCmp('cbxMarriage').setValue("");
	Ext.getCmp('cbxNation').setValue("");
	Ext.getCmp('txtMobilePhone').setValue("");
	Ext.getCmp('dtBirthday').setValue("");
	Ext.getCmp('cbxCityBirth').disable();
	Ext.getCmp('txtPatientIDNo').setValue("");
	statusType = "";
	provinceBirth = "";
	gender = "";
	age = "";
	occupation = "";
	pAAdmType = "";
	cityBirth = "";
	marriage = "";
	nation = "";
	mobilePhone = "";
	birthday = "";
	idCardNo = "";
}

function doBack(){
	parent.Ext.getCmp("eprEpisodelist").collapse(true);
}

//切换到当前选中患者的病历
function doSwitch() {
    //debugger;
    var selModel = Ext.getCmp('eprEpisodeGrid').getSelectionModel();
    var selects = selModel.getSelections();
    if (selects.length == 0) {
        Ext.MessageBox.alert('操作提示', '请先选择一个就诊病人!');
        return;
    }
	var row = selects[0];

    var patientID = row.get('PatientID');
    var episodeID = row.get('EpisodeID');
    
    parent.doSwitch(patientID,episodeID);
}
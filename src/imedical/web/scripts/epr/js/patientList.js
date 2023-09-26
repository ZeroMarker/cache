//此js文件为病历书写和病历浏览共用,修改时请注意.
var eprPageSize = 5;
var patientNo = "", medicareNo = "", MedicalInsuranceNo = "",  CFCardNo = "", IDCardNo = "", patientName = "", AdmType = "", AdmStatus = "", startDate = "", endDate = "", isArrivedQue = "off", startTime = "", endTime = "";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelist.cls?PatientNo=' + patientNo + '&MedicareNo=' + medicareNo + '&MedicalInsuranceNo=' + MedicalInsuranceNo + '&CFCardNo=' + CFCardNo + '&IDCardNo=' + IDCardNo + '&PatientName=' + patientName + '&AdmType=' + AdmType + '&StartDate=' + startDate + '&EndDate=' + endDate + '&IsArrivedQue=' + isArrivedQue,
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
        { name: 'PatientID' },
        { name: 'EpisodeID' },
        { name: 'mradm' },
        { name: 'PAPMINO' },
		{ name: 'MedicareNo'},
        { name: 'PAPMIName' },
        { name: 'PAPMIDOB' },
        { name: 'PAPMISex' },
        { name: 'PAAdmDate' },
        { name: 'PAAdmTime' },
        { name: 'PAAdmDepCodeDR' },
        { name: 'PAAdmDocCodeDR' },
        { name: 'PAAdmType' },
        { name: 'PAAdmWard' },
        { name: 'PAAdmReason' },
		{ name: 'PAADMBedNO' },
		{ name: 'PADischgeDate' },
		{ name: 'PADischgeTime' },
		{ name: 'IDCardNO' },
		{ name: 'CFCardNO' },
		{ name: 'Warddesc' },
        { name: 'Diagnosis' }
    ]
});
eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });

// **************** start
// add by 牛才才
var LocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
			LocStore.removeAll();
			LocStore.baseParams = { DicCode: 'S07', DicQuery: txtValueText};
		}
	}
});

//*************** end


var cm = new Ext.grid.ColumnModel([
    { header: '<div style="text-align:center">登记号</div>', dataIndex: 'PAPMINO', align: 'center' },
	//add by lina 2014-11-24
	{ header: '<div style="text-align:center">病案号</div>', dataIndex: 'MedicareNo', align: 'center' },
	//add by lina 2014-11-26
	{ header: '<div style="text-align:center">健康卡号</div>', dataIndex: 'CFCardNO', align: 'center', width: 150 },
    { header: '<div style="text-align:center">病人姓名</div>', dataIndex: 'PAPMIName', align: 'center', width: 80 },
	{ header: '<div style="text-align:center">就诊类型</div>', dataIndex: 'PAAdmType', align: 'center', width: 80 },
    { header: '<div style="text-align:center">就诊日期</div>', dataIndex: 'PAAdmDate', align: 'center' },
    { header: '<div style="text-align:center">就诊时间</div>', dataIndex: 'PAAdmTime', align: 'center' },
    { header: '<div style="text-align:center">出生日期</div>', dataIndex: 'PAPMIDOB', align: 'center' },
    { header: '<div style="text-align:center">性别</div>', dataIndex: 'PAPMISex', align: 'center', width: 50 },
    { header: '<div style="text-align:center">就诊科室</div>', dataIndex: 'PAAdmDepCodeDR',width: 200 },
	{ header: '<div style="text-align:center">病区</div>', dataIndex: 'Warddesc', sortable: true },
    { header: '<div style="text-align:center">医生</div>', dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 80 },
    { header: '<div style="text-align:center">病房</div>', dataIndex: 'PAAdmWard', align: 'center', width: 150 },
	{ header: '<div style="text-align:center">床位</div>', dataIndex: 'PAADMBedNO' , align: 'center'},
	{ header: '<div style="text-align:center">出院日期</div>', dataIndex: 'PADischgeDate', align: 'center' },
	{ header: '<div style="text-align:center">出院时间</div>', dataIndex: 'PADischgeTime', align: 'center' },
    { header: '<div style="text-align:center">付费方式</div>', dataIndex: 'PAAdmReason', align: 'center', sortable: true },
    { header: '<div style="text-align:center">诊断</div>', dataIndex: 'Diagnosis', align: 'center' }
]);

var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store: eprEpisodeStore,
    cm: cm,
    sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	keys:[{
		key: Ext.EventObject.ENTER,
		scope:this,
		fn: SetPatientNoLength
	}],
	tbar: new Ext.Toolbar({
		id: 'treeTbar1',
		autoWidth: true,
		items: [
		'就诊类型',
		{
			id:'cboAdmType',
			//emptyText:'就诊类型',
			width:46,
			resizable: false,
			xtype :'combo',
			valueField:'returnValue',
			displayField:'displayText',
			readOnly: true,
			triggerAction : 'all', 
			value: 'I',
			mode: 'local',
			store: new Ext.data.SimpleStore({
				fields:['returnValue','displayText'],
				data:[['','全部'],['O','门诊'],['E','急诊'],['I','住院']]
			})
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'就诊状态',
		{
			id:'cboAdmStatus',
			//emptyText:'在院状态',
			width:62,
			resizable: false,
			xtype :'combo',
			valueField:'returnValue',
			displayField:'displayText',
			readOnly: true,
			triggerAction : 'all', 
			value: 'A',
			mode: 'local',
			store: new Ext.data.SimpleStore({
				fields:['returnValue','displayText'],
				//目前支持对全部、在院、退院、出院四个状态的查询
				//data:[['all','全部'],['A','在院'],['C','退院'],['D','出院'],['P','Pre-Admission'],['R','Released'],['N','DNA']]
				data:[['all','全部'],['A','在院'],['C','退院'],['D','出院']]
			})
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'开始日期',
		{
		    id: 'dtStartDate',
		    xtype: 'datefield',
		    fieldLabel: '开始日期',
		    format: 'Y-m-d',
		    width: 65,
		    lableWidth: 65,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '开始日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'结束日期',
		{
		    id: 'dtEndDate',
		    xtype: 'datefield',
		    fieldLabel: '结束日期',
		    format: 'Y-m-d',
		    width: 65,
		    lableWidth: 65,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '结束日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},		
        '-',
        '开始时间',
		{
		    id: 'timeStart',
		    xtype: 'timefield',
		    fieldLabel: '开始时间',
		    format: 'H:i',
			increment: 60,
		    width: 60,
		    lableWidth: 60,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '开始时间'
		},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},		
        '-',
        '结束时间',
		{
		    id: 'timeEnd',
		    xtype: 'timefield',
		    fieldLabel: '结束时间',
		    format: 'H:i',
			increment: 60,
		    width: 60,
		    lableWidth: 60,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '结束时间'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'科室',
		{
			id: 'cbxLoc',
			name: 'cbxLoc',
			xtype: 'combo',
			fieldLabel: '科室',
			minChars: 1,
			store:LocStore,
			hiddenName: 'locID',
			displayField: 'DicDesc',
			valueField: 'DicCode',
			triggerAction: 'all',
			selectOnFocus: true,
			emptyText: '请选择患者科室',
			listWidth: 240,
			pageSize: 12,
			mode : 'remote',
			width:130,
			listeners:{
				'expand': function(){
					LocStore.load();
				}
			}
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},		
        '-',
        {
            id: 'chkCurLoc',
            xtype: 'checkbox',
            boxLabel: '本科病人',
            hideLabel: true,
            checked: false,
			listeners: {
				'check': function() {
					var cboAdmTypeValue = Ext.getCmp("chkCurLoc").getValue();
					if (cboAdmTypeValue == true){
						Ext.getCmp("cbxLoc").setDisabled(true);
					}
					else{
						Ext.getCmp("cbxLoc").setDisabled(false);
					}
				}
			}
        },
		'->'
		]
	}),
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
    ,listeners: {
        'render': function(){
                treeTbar2.render(this.tbar);
        }
    }
});

var treeTbar2 = new Ext.Toolbar({
	id: 'treeTbar2',
	autoWidth: true,
    items: [
		'病人姓名',
		{
		    id: 'txtPatientName',
		    xtype: 'textfield',
		    fieldLabel: '病人姓名',
		    emptyText: '病人姓名',
		    width: 60
		},
		'-',
		'登记号　',
		{
		    id: 'txtPatientNo',
		    xtype: 'textfield',
		    fieldLabel: '登记号',
		    emptyText: '登记号',
		    width: 80
		},
		'-',
		'病案号　',
		{
		    id: 'txtMedicareNo',
		    xtype: 'textfield',
		    fieldLabel: '病案号',
		    emptyText: '病案号',
		    width: 80
		},
		'-',
		'医保号　',
		{
		    id: 'MedicalInsuranceNo',
		    xtype: 'textfield',
		    fieldLabel: '医保号',
		    emptyText: '医保号',
		    width: 80
		},
		'-',
		'身份证号',
		{
		    id: 'IDCardNo',
		    xtype: 'textfield',
		    fieldLabel: '身份证号',
		    emptyText: '身份证号',
		    width: 120
		},
		'-',
		'健康卡号',
		{
		    id: 'CFCardNo',
		    xtype: 'textfield',
		    fieldLabel: '健康卡号',
		    emptyText: '健康卡号',
		    width: 120
		},
		'-',
    	'->',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnSearch.gif',
		    pressed: false,
		    handler: doSearch
		},
		'-',
		{
		    id: 'btnSwitch',
		    text: '确定',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnConfirm.gif',
		    pressed: false,
		    handler: doSwitch
		}
	]
});

var eprPortal = new Ext.Viewport({
    id: 'patientListPort',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
	items: [{ 
    	border: false,region: "center", layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid
		}]
	}]
});

function doSearch() { 
    //debugger;
    patientNo = Ext.getCmp('txtPatientNo').getValue();
	//获取病案号   add by lina 2014-11-24
	medicareNo = Ext.getCmp('txtMedicareNo').getValue();
	MedicalInsuranceNo = Ext.getCmp('MedicalInsuranceNo').getValue();
	//获取健康卡号  add by lina 2014-11-26
	CFCardNo =  Ext.getCmp('CFCardNo').getValue();
	//alert(CFCardNo);
	IDCardNo = Ext.getCmp('IDCardNo').getValue();
    patientName = Ext.getCmp('txtPatientName').getValue();
	AdmType = Ext.getCmp('cboAdmType').getValue();
	AdmStatus = Ext.getCmp('cboAdmStatus').getValue();
    //startDate = Ext.getCmp('dtStartDate').getValue();
    //endDate = Ext.getCmp('dtEndDate').getValue();
	//startDate = Ext.getCmp('dtStartDate').value;
    //endDate = Ext.getCmp('dtEndDate').value;
	startDate = Ext.getCmp('dtStartDate').getRawValue();
	endDate = Ext.getCmp('dtEndDate').getRawValue();
	startTime = Ext.getCmp('timeStart').getValue();
	endTime = Ext.getCmp('timeEnd').getValue();
	
	// 获取要查询的科室ID
	if (Ext.getCmp("cbxLoc").getRawValue()=="")
	{
		var expectedLocID = "";
	}
	else
	{
		var expectedLocID = Ext.getCmp('cbxLoc').getValue();
	}
	if (startDate == undefined)
	{
		startDate = "";
	}
	if (endDate == undefined)
	{
		endDate = "";
	}
    var chkArrivedQue = Ext.getCmp('chkCurLoc').getValue();
    if (chkArrivedQue) {
        isArrivedQue = "on";
		expectedLocID = ""; //当页面中选中“本科病人”复选框，科室下拉框中的内容无效；
    }
	else
	{
		isArrivedQue = "off";
	}
	if (patientNo=="" && medicareNo=="" && patientName=="" && MedicalInsuranceNo=="" && CFCardNo=="" && IDCardNo=="" && AdmType=="" && startDate=="" && endDate=="" && expectedLocID=="" && isArrivedQue=="off")
	{
		alert("不能只查询全部就诊记录");
		return;
	}
    Ext.getCmp('eprEpisodeGrid').getEl().mask('数据重新加载中，请稍等');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelist.cls?PatientNo=' + patientNo + '&MedicareNo=' + medicareNo + '&MedicalInsuranceNo=' + MedicalInsuranceNo + '&CFCardNo=' + CFCardNo + '&IDCardNo=' + IDCardNo + '&PatientName=' + escape(patientName) + '&AdmType=' + AdmType + '&AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&IsArrivedQue=' + isArrivedQue + '&expectedLocID=' + expectedLocID + '&StartTime=' + startTime + '&EndTime=' + endTime;
    s.proxy.conn.url = url;
    s.load({ params: { start: 0, limit: eprPageSize} });

    s.on('load', function(store, record) {
        //debugger;
        Ext.get('eprEpisodeGrid').unmask();
    });

    s.on('loadexception', function(proxy, options, response, e) {
        //debugger;
        Ext.get('eprEpisodeGrid').unmask();
    });
}

//切换到当前选中患者的病历或病历浏览信息
function doSwitch() {
    //debugger;
    var selModel = Ext.getCmp('eprEpisodeGrid').getSelectionModel();
    var selects = selModel.getSelections();
    if (selects.length == 0) {
        Ext.MessageBox.alert('操作提示', '请先选择一个就诊病人!');
        return;
    }

    var PatientID = selects[0].data["PatientID"];
    var EpisodeID = selects[0].data["EpisodeID"];
    var mradm = selects[0].data["mradm"];
    var PAPMIName = selects[0].data["PAPMIName"];
    var PAPMINO = selects[0].data["PAPMINO"];
    var Patient = PAPMINO + ' ' + PAPMIName;
    var PAPMINameLink = selects[0].data["PAPMIName"];
    var AdmDate = selects[0].data["PAAdmDate"];
    
    parent.doSwitch(PatientID,EpisodeID,mradm);
}

//add by niucaicai 2013-12-12

function SetPatientNoLength(){
	var obj=document.getElementById('txtPatientNo');
	if (obj.value!='') 
	{
		if ((obj.value.length<PatientNoLength)&&(PatientNoLength!=0)) 
		{
			for (var i=(PatientNoLength-obj.value.length-1); i>=0; i--)
			{
				obj.value="0"+obj.value;
			}
		}
	}
}

//此js文件为病历书写和病历浏览共用,修改时请注意.
var eprPageSize = 20;
var AdmStatus = "", startDate = "", endDate = "",medicareNo = "";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelistFS.cls?StartDate=' + startDate + '&EndDate=' + endDate+ '&MedicareNo=' + medicareNo,
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
        { name: 'PatientID' },
        { name: 'EpisodeID' },
		{ name: 'MedicareNo'},
        { name: 'PAPMIName' },
        { name: 'PAPMIDOB' },
        { name: 'PAPMISex' },
        { name: 'EprDocStatusDesc' },
        { name: 'EstimDischDate' },
		{ name: 'AdmDate' },
        { name: 'EprNurStatusDesc' },
        { name: 'EprPdfStatusDesc' },
        { name: 'StatusDesc' },
        { name: 'PAAdmDepCodeDR' },
        { name: 'Warddesc' },
        { name: 'mrEpisodeID' },
        { name: 'MRVerItemsIDs' },
		{ name: 'PAAdmDocCodeDR' }
    ]
});
eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });
var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
var cm = new Ext.grid.ColumnModel([
	sm,
	{ header: '<div style="text-align:center">病案号</div>', dataIndex: 'MedicareNo', align: 'center' ,
		renderer : function(v, m, rd, r, c, s) {
			m.attr = 'style="white-space:normal;"';
			var EpisodeID = rd.get("EpisodeID");
			//alert(EpisodeID);
			var ret = "<a href='#' onclick='LnkEprEditPage(\"" + EpisodeID + "\",\"\")'><font size='3'>" + v + "</font></a>";
			return ret;
		}
	},
    { header: '<div style="text-align:center">病人姓名</div>', dataIndex: 'PAPMIName', align: 'center', width: 80 },
	{ header: '<div style="text-align:center">出生日期</div>', dataIndex: 'PAPMIDOB', align: 'center' },
    { header: '<div style="text-align:center">性别</div>', dataIndex: 'PAPMISex', align: 'center', width: 80 },
	{ header: '医生<br>提交', width: 100, dataIndex: 'EprDocStatusDesc', sortable: false, menuDisabled:true, align: 'center'
		,renderer : function(v, m, rd, r, c, s){
			var EprDocStatusDesc  = rd.get("EprDocStatusDesc");
			if (EprDocStatusDesc != '是'){
				m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: '护士<br>提交', width: 100, dataIndex: 'EprNurStatusDesc', sortable: false, menuDisabled:true, align: 'center'
		,renderer : function(v, m, rd, r, c, s){
			var EprNurStatusDesc  = rd.get("EprNurStatusDesc");
			if (EprNurStatusDesc != '是'){
				m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: 'PDF<br>生成', width: 100, dataIndex: 'EprPdfStatusDesc', sortable: false, menuDisabled:true, align: 'center'
		,renderer : function(v, m, rd, r, c, s){
			var EprPdfStatusDesc  = rd.get("EprPdfStatusDesc");
			if (EprPdfStatusDesc != '是'){
				m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: '当前状态', width: 100, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'},
	{ header: '入院时间', width: 150, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'},
	{ header: '医疗结算时间', width: 150, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'},
    { header: '<div style="text-align:center">就诊科室</div>', dataIndex: 'PAAdmDepCodeDR',width: 200 },
	{ header: '<div style="text-align:center">病区</div>', dataIndex: 'Warddesc', sortable: true ,width: 200 },
    { header: '<div style="text-align:center">主治医师</div>', dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 80 }
]);

var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store: eprEpisodeStore,
    cm: cm,
    sm: sm,
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
	tbar: new Ext.Toolbar({
		id: 'treeTbar1',
		autoWidth: true,
		items: [
		'状态',
		{
			id:'cboAdmStatus',
			width:136,
			resizable: false,
			xtype :'combo',
			valueField:'returnValue',
			displayField:'displayText',
			readOnly: true,
			triggerAction : 'all', 
			value: '0',
			mode: 'local',
			store: new Ext.data.SimpleStore({
				fields:['returnValue','displayText'],
				data:[['0','未审核'],['DEPTREVIEWED','审核通过'],['INITIALIZED','科室审核退回'],['2','病案室审核退回']]
			})
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'病案号',
		{
		    id: 'txtMedicareNo',
		    xtype: 'textfield',
		    fieldLabel: '病案号',
		    emptyText: '病案号',
		    width: 80
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'开始日期:',
		{
		    id: 'dtStartDate',
		    xtype: 'datefield',
		    fieldLabel: '开始日期',
		    format: 'Y-m-d',
		    width: 165,
		    lableWidth: 165,
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
		    width: 165,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '结束日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnSearch.gif',
		    pressed: false,
		    handler: doSearch
		}
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
		},
		'rowdblclick':function(grid,rowindex,e){
			goEPRPDF(grid, rowindex, e);
		}
    }
});

var treeTbar2 = new Ext.Toolbar({
	id: 'treeTbar2',
	autoWidth: true,
    items: [
		'->',
		{
		    id: 'btnPass',
		    text: '审核通过',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnConfirm.gif',
		    pressed: false,
		    handler: doPass
		},
		'-',
		{
		    id: 'btnDoc',
		    text: '退回到医生',
		    cls: 'x-btn-text-icon',
		    //icon: '../scripts/epr/Pics/btnConfirm.gif',
		    pressed: false,
		    handler: doDoc
		},
		'-',
		{
		    id: 'btnNus',
		    text: '退回到护士',
		    cls: 'x-btn-text-icon',
		    //icon: '../scripts/epr/Pics/btnConfirm.gif',
		    pressed: false,
		    handler: doNus
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
    var ctlocid = userLocID
    
	medicareNo = Ext.getCmp('txtMedicareNo').getValue();
	AdmStatus = Ext.getCmp('cboAdmStatus').getValue();
	startDate = Ext.getCmp('dtStartDate').getRawValue();
	endDate = Ext.getCmp('dtEndDate').getRawValue();
	
    Ext.getCmp('eprEpisodeGrid').getEl().mask('数据重新加载中，请稍等');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&MedicareNo=' + medicareNo + '&ctlocid=' + ctlocid;
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
function doPass() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var EpisodeIDs=""
	for (var i=0; i<selections.length; i++)
	{
		var record = selections[i];
		var EpisodeID = record.get("EpisodeID");
		var EprPdfStatusDesc = record.get("EprPdfStatusDesc")
		var EprDocStatusDesc = record.get("EprDocStatusDesc")
		var EprNurStatusDesc = record.get("EprNurStatusDesc")
		//alert(EprPdfStatusDesc);
		//alert(EprDocStatusDesc);
		//alert(EprNusStatusDesc);
		if ((EprPdfStatusDesc=="是")&&(EprDocStatusDesc=="是")&&(EprNurStatusDesc=="是"))
		{
			if (EpisodeIDs=="")
			{
				var EpisodeIDs = EpisodeID
			}
			else
			{
				var EpisodeIDs = EpisodeIDs + "&" + EpisodeID
			}
		}
		else
		{
			alert("PDF未完成，不能审核！");
		}
	}
	Ext.Ajax.request({
		url: '../web.eprajax.EPRReviewStatus.cls',
		params: {EpisodeIDs:EpisodeIDs,Action:"DEPTREVIEW"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == "" )
			{
				alert("审核失败！");
				return;
			}
			else
			{
				alert("审核成功！");
			}
			
		}
	}) 	

}
function doDoc() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var EpisodeIDs=""
	for (var i=0; i<selections.length; i++)
	{
		var record = selections[i];
		var EpisodeID = record.get("EpisodeID");
		if (EpisodeIDs=="")
		{
			var EpisodeIDs = EpisodeID
		}
		else
		{
			var EpisodeIDs = EpisodeIDs + "&" + EpisodeID
		}
	}
	
	Ext.Ajax.request({
		url: '../web.eprajax.EPRReviewStatus.cls',
		params: {EpisodeIDs:EpisodeIDs,Action:"DOCDEPTQCBACK"},
		success: function(response, options){
			var ret = response.responseText;
			if ((ret == "0" ) || (ret == "" ))
			{
				alert("退回失败！");
				return;
			}
			else
			{
				alert("退回成功！");
			}
			
		}
	}) 	
}
function doNus() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var EpisodeIDs=""
	for (var i=0; i<selections.length; i++)
	{
		var record = selections[i];
		var EpisodeID = record.get("EpisodeID");
		if (EpisodeIDs=="")
		{
			var EpisodeIDs = EpisodeID
		}
		else
		{
			var EpisodeIDs = EpisodeIDs + "&" + EpisodeID
		}
	}
	
	Ext.Ajax.request({
		url: '../web.eprajax.EPRReviewStatus.cls',
		params: {EpisodeIDs:EpisodeIDs,Action:"NUSDEPTQCBACK"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret =="0" )
			{
				alert("退回失败！");
				return;
			}
			else if (ret=="1")
			{
				alert("退回成功！");
			}
			
		}
	}) 	
}
function LnkEprEditPage(EpisodeID) {
	
	location.href = 'dhceprredirect.csp?1=1&EpisodeID=' + EpisodeID + '&2=2';
}

function goEPRPDF(grid, rowindex, e) {
    //debugger;
    var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");
    
    var MRVerItemsIDs = record.get("MRVerItemsIDs");
	var mrEpisodeID = record.get("mrEpisodeID");
	var DataServiceUrl = "http://192.168.99.11/dthealth/web/"
	
    var win = new Ext.Window({
        id: 'winBrowse',
        layout: 'fit', 	//自动适应Window大小 
        title: '患者病历',
        frame: true,
        width: 1200,
        height: 640,
        shim: false,
        animCollapse: false,
        constrainHeader: true,
        resizable: true,
        modal: true,
        maximizable: true,
        raggable: true, //不可拖动
        items: [
	        {
		        html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.fs.viewrecord.csp?mrEpisodeID=' + mrEpisodeID + '&MRVerItemsIDs=' + MRVerItemsIDs + '&DataServiceUrl='+ DataServiceUrl +'"></iframe>'
	            //html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="epr.newfw.episodelistbrowser.csp?EpisodeID=' + episodeID + '"></iframe>'
	        }
        ]
    });
    win.show();
	win.maximize();
}
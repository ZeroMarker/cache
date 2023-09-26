
var eprPageSize = 100;
var AdmStatus = "", startDate = "", endDate = "",medicareNo = "",locID="", specialAdm = "";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + startDate + '&EndDate=' + endDate+ '&MedicareNo=' + medicareNo+ '&ALocID=' + locID + '&SpecialAdm=' + specialAdm,
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
        { name: 'PatientID' },
        { name: 'EpisodeID' },
		{ name: 'MedicareNo'},
        { name: 'PAPMIName' },
        { name: 'PAPMIDOB' },
        { name: 'PAPMISex' },
        { name: 'ManualFlag'},
        { name: 'DisManualFlag'},
        { name: 'MessageFlag'},
        { name: 'ProblemFlag'},
        { name: 'EprDocStatusDesc' },
        { name: 'EstimDischDate' },
        { name: 'EprNurStatusDesc' },
        { name: 'EprPdfStatusDesc' },
        { name: 'StatusDesc' },
        { name: 'PAAdmDepCodeDR' },
        { name: 'MainDiagnos' },
        { name: 'AdmDateTime' },
		{ name: 'PAAdmDocCodeDR' },
		{ name: 'CreateAdmUser' },
		{ name: 'Illness' },
		{ name: 'QualityFlag' },
		{ name: 'DeathDate' },
		{ name: 'InPathWayStatus' },
		{ name: 'Attending' },
		{ name: 'Chief' },
		{ name: 'Age' },
		{ name: 'TransLocFlag' },
		{ name: 'ResidentDays' ,type:'number'},
		{ name: 'BedNo',type:'number' }
    ]
});

eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });
eprEpisodeStore.on('beforeload', function(store, options) {
        //debugger;
        var params = {
	        MedicareNo : Ext.getCmp('txtMedicareNo').getValue(),
			AdmStatus : "D" ,
			StartDate : Ext.getCmp('dtStartDate').getRawValue(),
			EndDate : Ext.getCmp('dtEndDate').getRawValue(),
			ALocID : Ext.getCmp('cbxLoc').getValue(),
			SpecialAdm : specialAdm,
			start: 0, limit: eprPageSize
	        };
	     eprEpisodeStore.baseParams = params
	    //Ext.apply(store.proxy.extraParams, params);
        //Ext.get('eprEpisodeGrid').unmask();
    });
var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
var cm = new Ext.grid.ColumnModel([
	sm,
	{ header: '<div style="text-align:center">时效缺陷</div>', width: 60, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
	,renderer : function(v, m, rd, r, c, s){
			var ProblemFlag  = rd.get("ProblemFlag");
			if (ProblemFlag != 0){
				return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
				//m.attr = 'style="background-image:url(../scripts/image/icon/forbid.png);"';
			}
			return v;
		}
	},
	{ header: '<div style="text-align:center">病案号</div>', dataIndex: 'MedicareNo', align: 'center', width: 80  },
    { header: '<div style="text-align:center">病人姓名</div>', dataIndex: 'PAPMIName', align: 'center', width: 80 
    ,renderer : function(v, m, rd, r, c, s){
			var DeathDate  = rd.get("DeathDate");
			if (DeathDate !=""){
				//m.attr = 'style="background:#FF5151;"';
				m.attr = 'style="color:#FF0033;font-weight:bold;"';
			}
			return v;
		}
    },
	{ header: '<div style="text-align:center">年龄</div>', dataIndex: 'Age', align: 'center', width: 60  },
    { header: '<div style="text-align:center">性别</div>', dataIndex: 'PAPMISex', align: 'center', width: 60 },
    { header: '<div style="text-align:center">病情</div>',sortable: true, dataIndex: 'Illness',width: 60 , align: 'center'},
	{ header: '<div style="text-align:center">转科标志</div>',sortable: true, dataIndex: 'TransLocFlag',width: 60 , align: 'center'},
    { header: '<div style="text-align:center">住院天数</div>',sortable: true, dataIndex: 'ResidentDays',width: 60 , align: 'center'},
	{ header: '<div style="text-align:center">环节质控</div>', width: 60, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
	,renderer : function(v, m, rd, r, c, s){
			var MessageFlag  = rd.get("MessageFlag");
			if (MessageFlag !=0){
				return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
				//m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: '<div style="text-align:center">质控医生</div>', dataIndex: 'CreateAdmUser', sortable: true ,width: 80, align: 'center' },
	{ header: '<div style="text-align:center">入院时间</div>', width: 100, dataIndex: 'AdmDateTime', sortable: false, menuDisabled:true, align: 'center'},
	{ header: '<div style="text-align:center">出院时间</div>', width: 100, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'},
    { header: '<div style="text-align:center">诊断</div>', dataIndex: 'MainDiagnos',width: 130 , align: 'center'},
    { header: '<div style="text-align:center">临床路径</div>',sortable: true, dataIndex: 'InPathWayStatus',width: 80 , align: 'center'},
    { header: '<div style="text-align:center">经治医生</div>', dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 80, align: 'center' },
    { header: '<div style="text-align:center">主治医生</div>', dataIndex: 'Attending', align: 'center', width: 80, align: 'center' },
    { header: '<div style="text-align:center">主任医生</div>', dataIndex: 'Chief', align: 'center', width: 80, align: 'center' },
    { header: '<div style="text-align:center">床号</div>',dataIndex: 'BedNo', align: 'center', width: 80, align: 'center' }
     //{ header: '<div style="text-align:center">分数</div>', dataIndex: 'DisScore', align: 'center', width: 80, align: 'center' }
]);
var getLocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.GetQualityDicList.cls',
	fields: ['ID', 'Name'],
	root: 'data',
	totalProperty: 'TotalCount',
	//baseParams: { AdmStatus:"A"},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
			getLocStore.baseParams = {AdmStatus:"D",DicQuery: txtValueText};
		}
	}
})

var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store: eprEpisodeStore,
    cm: cm,
    sm: sm,
    viewConfig: { forceFit: true ,scrollOffset: 0},
    autoScroll: true,
    frame: true,
    stripeRows: false,
		keys:[{
		key: Ext.EventObject.ENTER,
		scope:this,
		fn: EnterEvent
	}],
	tbar: new Ext.Toolbar({
		id: 'treeTbar1',
		autoWidth: true,
		items: [
		/*'审核状态',
		{
			id:'cboAdmStatus',
			width:136,
			resizable: false,
			xtype :'combo',
			valueField:'returnValue',
			displayField:'displayText',
			readOnly: true,
			triggerAction : 'all', 
			value: 'DEPTREVIEW',
			mode: 'local',
			store: new Ext.data.SimpleStore({
				fields:['returnValue','displayText'],
				data:[['DEPTREVIEW','未审核'],['DEPTREVIEWED','审核通过'],['DEPTQCBACK','审核退回']]
			})
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',*/
		/*'患者类型',
		{
			id:'cboAdm',
			width:136,
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
				data:[['A','在院'],['D','出院']]
			})
		},*/
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'科室',
		{
				id: 'cbxLoc',
				name: 'cbxLoc',
				xtype: 'combo',
				fieldLabel: '科室',
				minChars: 1,
				store:getLocStore,
				displayField: 'Name',
				valueField: 'ID',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择患者科室',
				listWidth: 240,
				//pageSize: 12,
				mode : 'remote'
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
		'开始日期',
		{
		    id: 'dtStartDate',
		    xtype: 'datefield',
		    fieldLabel: '开始日期',
		    format: 'Y-m-d',
		    width: 135,
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
		    width: 135,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '结束日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'重点患者',
		{
			id:'cboAdm',
			name: 'cboAdm',
			width:180,
			resizable: false,
			xtype : 'combo',
			fieldLabel: '重点患者',
			valueField: 'value',
			displayField: 'text',
			hiddenName: 'value',
			typeAhead: true,
			triggerAction : 'all', 
			selectOnFocus: true,
			emptyText: '请选择...',
			//value: '0',
			mode: 'local',
			store: new Ext.data.SimpleStore({
				fields:['value','text'],
				data:[['all','<b><font Color=#365BBD>全选/全消</font></b>'],['OverAdm','住院超过31天患者'],['TerminallyIll','病危患者'],['DiseaseSeve','病重患者'],['Death','死亡患者']]
			}),
            //增加多选 
            tpl: '<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.text]}" /></span><span >{text}</span></div></tpl>',
            
            //以下是重写onSelect事件方法 
			onSelect: function(record, index){
				//debugger;
                if (this.fireEvent('beforeselect', this, record, index) !== false) {
                    record.set('check', !record.get('check'));
                    var str = [];//页面显示的值
                    var strvalue = [];//传入后台的值
					if (index == 0) //点击全选按钮
					{
						if (record.get('check') == true)  //全选
						{
							this.store.each(function(rc){
								if (rc.data.value !== "all") //去掉第一个“全选按钮”的值
								{
									rc.set('check', true);
									str.push(rc.get('text'));
									strvalue.push(rc.get('value'));
								}
							});
						}
						else  //全消
						{
							this.store.each(function(rc){
								rc.set('check', false);
							});
						}
					}
					else  //点击其他按钮
					{
						this.store.each(function(rc){
							if (rc.get('check')) {
								if (rc.data.value == "all") //去掉第一个“全选按钮”的值
								{
									rc.set('check', false);
								}
								else
								{
									str.push(rc.get('text'));
									strvalue.push(rc.get('value'));
								}
							}
						});
					}
					
                    this.setValue(str.join());
                    this.value = strvalue.join();
                    specialAdm = strvalue.join();
                    //alert(this.value);
                    this.fireEvent('select', this, record, index);
                }
            }
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/browser.gif',
		    pressed: false,
		    handler: doSearch
		}]
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
    }),
    viewConfig: {
        'getRowClass': function(record,rowindex,rowParams,store){
                  if(record.data.DisManualFlag == 'Y' ){ 
                         return 'x-grid-record-yellow';
                  }
            }},
    	listeners: {
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
		    id: 'btnSearch',
		    text: '取消终末质控',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/upda.gif',
		    pressed: false,
		    handler: CancelManualFlag
		},
		'->','-'
    /*
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
		}*/
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
		title:"终末质控查询", 
    	border: false,region: "center", layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid
		}]
	}]
});


function CancelManualFlag() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var record = selections[0];
	var EpisodeID = record.get("EpisodeID");
	var QualityFlag = record.get("QualityFlag");
	if (QualityFlag=="Y")
	{
		alert("患者已经存在质控缺陷，无法取消！");
		return;
	}
	var SignUserID = userID
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Cancel",Status:"D"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("取消成功！");
				doSearch();
			}
		}
	}) 		
}
function EnterEvent() {
	var btnobj=document.getElementById('btnSearch');
		btnobj.click();
}
/*
function SetManualFlag() {
    var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var record = selections[0];
	var EpisodeID = record.get("EpisodeID");
	
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,userID:userID},
		success: function(response, options){
			var ret = response.responseText;
		}
	}) 	
	
}*/
function doSearch() { 
    //debugger;
	var medicareNo = Ext.getCmp('txtMedicareNo').getValue();
	var AdmStatus = "D" ;
	var startDate = Ext.getCmp('dtStartDate').getRawValue();
	var endDate = Ext.getCmp('dtEndDate').getRawValue();
	if (startDate>endDate)
	{
		alert("开始日期不能大于结束日期！");
		return;
	}
	var locID = Ext.getCmp('cbxLoc').getValue();
	//var specialAdm = Ext.getCmp('cboAdm').getValue();
	if ((((startDate=="")||(endDate==""))&&(medicareNo==""))&&((locID=="")))
	{
		alert("请输入病案号或开始和结束时间作为查询条件！");
		return;
	}
    Ext.getCmp('eprEpisodeGrid').getEl().mask('数据重新加载中，请稍等');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&MedicareNo=' + medicareNo + '&ALocID=' + locID + '&SpecialAdm=' + specialAdm;
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
		params: {EpisodeIDs:EpisodeIDs,Action:"PASS"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == 0 )
			{
				alert("审核失败！");
				return;
			}
			else if (ret == 1)
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
			alert("请选择患者1");
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
	alert(EpisodeIDs);
	Ext.Ajax.request({
		url: '../web.eprajax.EPRReviewStatus.cls',
		params: {EpisodeIDs:EpisodeIDs,Action:"DOC"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == 0 )
			{
				alert("审核失败！");
				return;
			}
			else if (ret == 1)
			{
				alert("审核成功！");
			}
			
		}
	}) 	
}
function doNus() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者2");
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
	alert(EpisodeIDs);
	Ext.Ajax.request({
		url: '../web.eprajax.EPRReviewStatus.cls',
		params: {EpisodeIDs:EpisodeIDs,Action:"NUS"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==0 )
			{
				alert("审核失败！");
				return;
			}
			else if (ret == 1)
			{
				alert("审核成功！");
			}
			
		}
	}) 	
}
function goEPRPDF(grid, rowindex, e) {
    //debugger;
    var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");
    var action = "D"
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
		            html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.quality.checkrule.csp?EpisodeID=' + episodeID + '&action=' + action +'"></iframe>'
		        }
	        ]
        });
        win.show();
		win.maximize();
}

var eprPageSize = 30;
var AdmStatus = "", startDate = "", endDate = "",medicareNo = "",locID="";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelistFS.cls?StartDate=' + startDate + '&EndDate=' + endDate+ '&MedicareNo=' + medicareNo+ '&ALocID=' + locID,
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
        { name: 'OutManualFlag'},
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
		{ name: 'CreateOutUser' },
		{ name: 'Illness' },
		{ name: 'BedNo' }
    ]
});
eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });
var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
var cm = new Ext.grid.ColumnModel([
	sm,
    { header: '<div style="text-align:center">��������</div>', dataIndex: 'PAPMIName', align: 'center', width: 100 },
	{ header: '<div style="text-align:center">��������</div>', dataIndex: 'PAPMIDOB', align: 'center' },
    { header: '<div style="text-align:center">�Ա�</div>', dataIndex: 'PAPMISex', align: 'center', width: 100 },
	{ header: '�����ʿ�', width: 90, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
	,renderer : function(v, m, rd, r, c, s){
			var MessageFlag  = rd.get("MessageFlag");
			if (MessageFlag !=0){
				return "<img height='15' src='../scripts/emr/image/icon/forbid.png'/>";
				//m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: '<div style="text-align:center">�ʿ�ҽ��</div>', dataIndex: 'CreateOutUser', sortable: true ,width: 150, align: 'center' },
	{ header: '����ʱ��', width: 100, dataIndex: 'AdmDateTime', sortable: false, menuDisabled:true, align: 'center'},
    { header: '<div style="text-align:center">���</div>', dataIndex: 'MainDiagnos',width: 130 , align: 'center'},
    { header: '<div style="text-align:center">����ҽ��</div>', dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 80, align: 'center' }
   
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
			getLocStore.baseParams = {AdmStatus:"O",DicQuery: txtValueText};
		}
	}
})
var getDocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.GetQualityDicList.cls',
	fields: ['UserID', 'UserDesc'],
	root: 'data',
	totalProperty: 'TotalCount'
})

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
		keys:[{
		key: Ext.EventObject.ENTER,
		scope:this,
		fn: EnterEvent
	}],
	tbar: new Ext.Toolbar({
		id: 'treeTbar1',
		autoWidth: true,
		items: [
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'����',
		{
				id: 'cbxLoc',
				name: 'cbxLoc',
				xtype: 'combo',
				fieldLabel: '����',
				minChars: 1,
				store:getLocStore,
				displayField: 'Name',
				valueField: 'ID',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '��ѡ���߿���',
				listWidth: 240,
				//pageSize: 12,
				mode : 'remote'
			},
			'-',
		'ҽ��',
		{
				id: 'cbxDoc',
				name: 'cbxDoc',
				xtype: 'combo',
				fieldLabel: 'ҽ��',
				minChars: 1,
				store:getDocStore,
				displayField: 'UserDesc',
				valueField: 'UserID',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '��ѡ����ҽ��',
				listWidth: 240,
				//pageSize: 12,
				mode : 'remote',
				listeners:{
					'expand' : function(){
						//alert(action);
						getDocStore.removeAll();
						var Locid = Ext.getCmp("cbxLoc").getValue();
						getDocStore.baseParams = {Action:"GetUserID",AdmStatus:"O",LocId:Locid};
						getDocStore.load();
					}
				}
			},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'��ʼ����',
		{
		    id: 'dtStartDate',
		    xtype: 'datefield',
		    fieldLabel: '��ʼ����',
		    format: 'Y-m-d',
		    width: 165,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '��ʼ����'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		
		'-',
		'��������',
		{
		    id: 'dtEndDate',
		    xtype: 'datefield',
		    fieldLabel: '��������',
		    format: 'Y-m-d',
		    width: 165,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '��������'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		{
		    id: 'btnSearch',
		    text: '����',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnSearch.gif',
		    pressed: false,
		    handler: doSearch
		}]
	}),
    bbar: new Ext.PagingToolbar({
        id: "eprPagingToolbar",
        store: eprEpisodeStore,
        pageSize: eprPageSize,
        displayInfo: true,
        displayMsg: '�� {0} ����  {1} ��, һ�� {2} ��',
        beforePageText: 'ҳ��',
        afterPageText: '��ҳ�� {0}',
        firstText: '��ҳ',
        prevText: '��һҳ',
        nextText: '��һҳ',
        lastText: 'ĩҳ',
        refreshText: 'ˢ��',
        emptyMsg: "û�м�¼"
    }),
    viewConfig: {
        'getRowClass': function(record,rowindex,rowParams,store){
                  if(record.data.OutManualFlag == 'Y' ){ 
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
		    text: 'ȡ���ֹ��ʿ�',
		    cls: 'x-btn-text-icon',
		    pressed: false,
		    handler: CancelManualFlag
		},
		'->','-'
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
		title:"�����ʿز�ѯ",  
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
			alert("��ѡ����");
			return;
	}
	var record = selections[0];
	var EpisodeID = record.get("EpisodeID");
	var SignUserID = userID
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Cancel",Status:"O"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("ȡ���ɹ���");
				doSearch();
			}
		}
	}) 		
}
function EnterEvent() {
	var btnobj=document.getElementById('btnSearch');
		btnobj.click();
}

function doSearch() { 
    //debugger;
	var AdmStatus = "O"
	var startDate = Ext.getCmp('dtStartDate').getRawValue();
	var endDate = Ext.getCmp('dtEndDate').getRawValue();
	if (startDate>endDate)
	{
		alert("��ʼ���ڲ��ܴ��ڽ������ڣ�");
		return;
	}
	var locID = Ext.getCmp('cbxLoc').getValue();
	//if (((startDate=="")||(endDate==""))&&(medicareNo==""))
	if (((startDate=="")||(endDate==""))||(locID==""))
	{
		alert("��������ҿ�ʼ�ͽ���ʱ����Ϊ��ѯ������");
		return;
	}
	var docID = Ext.getCmp('cbxDoc').getValue();
    Ext.getCmp('eprEpisodeGrid').getEl().mask('�������¼����У����Ե�');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&ALocID=' + locID + '&ADocID=' + docID;
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
function goEPRPDF(grid, rowindex, e) {
    //debugger;
    var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");
    var action = "O"
        var win = new Ext.Window({
            id: 'winBrowse',
            layout: 'fit', 	//�Զ���ӦWindow��С 
            title: '���߲���',
            frame: true,
            width: 1200,
            height: 640,
            shim: false,
            animCollapse: false,
            constrainHeader: true,
            resizable: true,
            modal: true,
            maximizable: true,
            raggable: true, //�����϶�
            items: [
		        {
		            html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.quality.checkrule.csp?EpisodeID=' + episodeID + '&action=' + action +'"></iframe>'
		        }
	        ]
        });
        win.show();
		win.maximize();
}
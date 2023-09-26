var eprPageSize = 20;
var AdmStatus = "", startDate = "", endDate = "",medicareNo = "";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelistFS.cls?StartDate=' + startDate + '&EndDate=' + endDate+ '&MedicareNo=' + medicareNo + '&ALocID=' + userLocID,
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
        { name: 'PatientID' },
        { name: 'EpisodeID' },
		{ name: 'MedicareNo'},
        { name: 'PAPMIName' },
        { name: 'PAPMIDOB' },
        { name: 'PAPMISex' },
    	{ name: 'MessageFlag'},
    	{ name: 'ProblemFlag'},
        { name: 'EprDocStatusDesc' },
        { name: 'EstimDischDate' },
        { name: 'EprNurStatusDesc' },
        { name: 'EprPdfStatusDesc' },
        { name: 'StatusDesc' },
        { name: 'MainDiagnos' },
        { name: 'PAAdmDepCodeDR' },
        { name: 'AdmRecordStatus' },
        { name: 'Warddesc' },
        { name: 'CreateAdmUser' },
        { name: 'Illness' },
        { name: 'InPathWayStatus' },
       	{ name: 'Attending' },
		{ name: 'Chief' },
		{ name: 'Age' },
		{ name: 'TransLocFlag' },
		{ name: 'ResidentDays' ,type:'number'},
		{ name: 'BedNo' ,type:'number'}
    ]
});
eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });
var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
var cm = new Ext.grid.ColumnModel([
	sm,
	{ header: 'ʱЧȱ��', width: 80, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
	,renderer : function(v, m, rd, r, c, s){
			var ProblemFlag  = rd.get("ProblemFlag");
			if (ProblemFlag != 0){
				return "<img height='15' src='../scripts/emr/image/icon/aging.png'/>";
				//m.attr = 'style="background-image:url(../scripts/image/icon/forbid.png);"';
			}
			return v;
		}
	},
	{ header: '<div style="text-align:center">������</div>', dataIndex: 'MedicareNo', align: 'center' },
    { header: '<div style="text-align:center">��������</div>', dataIndex: 'PAPMIName', align: 'center', width: 80 },
	{ header: '<div style="text-align:center">����</div>', dataIndex: 'Age', align: 'center' },
    { header: '<div style="text-align:center">�Ա�</div>', dataIndex: 'PAPMISex', align: 'center', width: 80 },
    { header: '<div style="text-align:center">����</div>', dataIndex: 'Illness',width: 100 , align: 'center'},
	{ header: '�����ʿ�', width: 90, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
	,renderer : function(v, m, rd, r, c, s){
			var MessageFlag  = rd.get("MessageFlag");
			if (MessageFlag !=0){
				return "<img height='15' src='../scripts/emr/image/icon/segment.png'/>";
				//m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: '<div style="text-align:center">�ʿ�ҽ��</div>', dataIndex: 'CreateAdmUser', sortable: true ,width: 100, align: 'center' },
	//{ header: '��ǰ״̬', width: 100, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'},
	{ header: '��Ժʱ��', width: 100, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'},
    { header: '<div style="text-align:center">���</div>', dataIndex: 'MainDiagnos',width: 130, align: 'center'},
	{ header: '<div style="text-align:center">�ٴ�·��</div>',sortable: true, dataIndex: 'InPathWayStatus',width: 80 , align: 'center',flex: 1},
	//{ header: '<div style="text-align:center">����</div>', dataIndex: 'PAAdmDepCodeDR', sortable: true ,width: 100 },
    { header: '<div style="text-align:center">����ҽ��</div>',sortable: true, dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 80, align: 'center' },
    { header: '<div style="text-align:center">����ҽ��</div>',sortable: true, dataIndex: 'Attending', align: 'center', width: 80, align: 'center' },
    { header: '<div style="text-align:center">����ҽ��</div>', sortable: true,dataIndex: 'Chief', align: 'center', width: 80, align: 'center' },
    { header: '<div style="text-align:center">����</div>',dataIndex: 'BedNo', align: 'center', width: 80, align: 'center' }
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
    stripeRows: false,
	tbar: new Ext.Toolbar({
		id: 'treeTbar1',
		autoWidth: true,
		items: [
		/*'״̬',
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
				data:[['DEPTREVIEW','δ���'],['DEPTREVIEWED','���ͨ��'],['DEPTQCBACK','����˻�']]
			})
		},*/
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'������',
		{
		    id: 'txtMedicareNo',
		    xtype: 'textfield',
		    fieldLabel: '������',
		    emptyText: '������',
		    width: 80
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'��ʼ����:',
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
		}
		]
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
                  if(record.data.AdmRecordStatus == 1 ){ 
                         return 'x-grid-record-yellow';
                  }
            }}
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
		    text: '�Ͳ�����',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnConfirm.gif',
		    pressed: false,
		    handler: doPass
		},
		'-',
		{
		    id: 'btnDoc',
		    text: '�˻ص�ҽ��',
		    cls: 'x-btn-text-icon',
		    //icon: '../scripts/epr/Pics/btnConfirm.gif',
		    pressed: false,
		    handler: doDoc
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
	medicareNo = Ext.getCmp('txtMedicareNo').getValue();
	var AdmStatus = "D"
	startDate = Ext.getCmp('dtStartDate').getRawValue();
	endDate = Ext.getCmp('dtEndDate').getRawValue();
	
    Ext.getCmp('eprEpisodeGrid').getEl().mask('�������¼����У����Ե�');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&MedicareNo=' + medicareNo+ '&ALocID=' + userLocID;
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
			alert("��ѡ����");
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
				alert("���ʧ�ܣ�");
				return;
			}
			else if (ret == 1)
			{
				alert("��˳ɹ���");
				doSearch();
			}
			
		}
	}) 

}
function doDoc() {
	Ext.MessageBox.show({  
                    title: '�˻�ԭ��',  
                    buttons: Ext.Msg.OKCANCEL,  
                    width: 500,
                    closable: false,  
                    msg: "����д�˻�ԭ��",
                    fn: function(e, text) { 
	                    if (e == 'ok')
	                    {
	                        SendData = text,
	                        Ext.Ajax.request({
							url: '../EPRservice.Quality.SaveManualResult.cls',
							params: {SendData:SendData},
							success: function(response, options){
								var ret = response.responseText;
								if (ret == 0 )
								{
									alert("�˻�ʧ�ܣ�");
									return;
								}
								else if (ret == 1)
								{
									alert("�˻سɹ���");
									return;
								}
							}
						})         
                    }
                    },
                    prompt: true,  
                    multiline: true  
                    
       }); 
   } 
                   
	/*
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("��ѡ����");
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
		params: {EpisodeIDs:EpisodeIDs,Action:"DOC"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret == 0 )
			{
				alert("�˻�ʧ�ܣ�");
				return;
			}
			else if (ret == 1)
			{
				alert("�˻سɹ���");
			}
			
		}
	}) 	*/
function doNus() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("��ѡ����2");
			return;
	}

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
				alert("���ʧ�ܣ�");
				return;
			}
			else if (ret == 1)
			{
				alert("��˳ɹ���");
			}
			
		}
	}) 	
}
function goEPRPDF(grid, rowindex, e) {
    //debugger;
    var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");
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
		            html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="emr.record.browse.browseform.csp?EpisodeID=' + episodeID + '"></iframe>'
		        }
	        ]
        });
        win.show();
		win.maximize();
}
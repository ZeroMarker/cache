/////////////////////////////////////////////////

var itemGridUrl = 'dhc.bonus.uBonusEmpReportexe.csp';

//�г��������ݵĵ��÷���
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});

//�������Դ
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'RowId',
			'BonusEmployeeID',
			'EmployeeName',
			'BonusReportID',
			'ReportName',
			'UpdateDate'
		]),
	    remoteSort: true
});

//����ҳ�����ݸ���pageSizeȷ��ҳ����PagingToolbar����ÿҳ�����Ŀؼ�
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('RowId');

	
//ColumnModel�����ģʽ
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'RowId', 
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            sortable:true,
            dataIndex: 'RowId'   
                                 
       }, {
            id:'BonusEmployeeID',
            header: '��Ա����', 
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            sortable:true,
            dataIndex: 'BonusEmployeeID'
       }, {
            id:'EmployeeName',
            header: '��Ա����', 
            allowBlank: false,
            width:100,
            editable:false,
            sortable:true,
            dataIndex: 'EmployeeName'
       }, {
            id:'BonusReportID',
            header: '��������', 
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            sortable:true,
            dataIndex: 'BonusReportID'
       },{
            id:'ReportName',
            header: '��������', 
            allowBlank: false,
            width:160,
            editable:false,
            sortable:true,
            dataIndex: 'ReportName'
       }, {
            id:'UpdateDate',
            header: '�޸�ʱ��',
            allowBlank: false,
            width:130,
            editable:false,
            sortable:true,
            dataIndex: 'UpdateDate'
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���',  //�����ڰ�ť��ʱҳ���Զ���ʾ������
					iconCls : 'add',   //��ť��ͼ��
					handler : function() {
						BonusEmpReportAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler : function() {
						BonusEmpReportEditFun();
					}
				});
				
var delButton = new Ext.Toolbar.Button({
			        text : 'ɾ��',
					tooltip : 'ɾ��',
					iconCls : 'remove',
					handler : function() {
					BonusEmpReportDelFun()
					}
				});

//��������
var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.bonus.uBonusEmpReportexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,  //ʵ��������о���ʱ�Ĺ켣Ч��
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

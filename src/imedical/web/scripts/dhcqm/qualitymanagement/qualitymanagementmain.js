var itemGridUrl = '../csp/dhc.qm.qualityinfomanagementexe.csp';
var userid=session['LOGON.USERID'];

//�������Դ
//var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=listNew'});
var self=this;
//ѡ�е�Ԫ���ֵ
var selectedcell;
//ѡ�е�Ԫ���������
var selectedcellfieldname;
//��ȡ��Ԫ������
var columnnumber;

var columns = [];
var itemGridDs={};
var itemGridCm = new Ext.grid.ColumnModel(columns);


//itemGridPagingToolbar.doRefresh=dosearch();
var addButton = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���',
					iconCls : 'add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler : function() {
						doedit();
					}
				});
var delButton = new Ext.Toolbar.Button({
					text : 'ɾ��',
					tooltip : 'ɾ��',
					iconCls : 'remove',
					handler : function() {
						
					}
				});
				
		
var pageBar = new Ext.PagingToolbar({
            store: itemGridDs,
			pageSize:limit,
            displayInfo: true,
            displayMsg: '��ǰ��ʾ�� {0} - {1} �����ܹ� {2}��',
            emptyMsg: "û������"
        });		
				
	/* var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update'
    });	*/
var itemGrid = new Ext.grid.GridPanel({
			//title: '������Ϣά��',
		    region: 'center',
		    loadMask: true,
		    layout:'fit',
			width:400,
		    readerModel:'local',
		   	url: 'dhc.qm.qualityinfomanagementexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			bbar : pageBar,
			columnLines:true//,//�зָ���
			
			
		
 
});
function getcellvalue(data,fieldName,columnIndex){

	selectedcell=data;
	selectedcellfieldname=fieldName;
	columnnumber=columnIndex;
};

var cellclick=function(grid, rowIndex, columnIndex, e) {
    var record = grid.getStore().getAt(rowIndex);  // Get the Record
    var fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
    var data = record.get(fieldName);
	//���ñ�ѡ�����ʽ
	var selectObj = e.target;
	if(selectObj.nodeName=='DIV'){
		$("div[class^='x-grid3-cell-inner x-grid3-col-']").attr("style","white-space:normal;");
		$(selectObj).attr("style","border:2px solid #8CB2E5;white-space:normal;");
	}
    getcellvalue(data,fieldName,columnIndex);
	
};
itemGrid.addListener('cellclick',cellclick);


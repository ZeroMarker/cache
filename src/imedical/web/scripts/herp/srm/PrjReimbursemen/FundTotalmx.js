
FundTotalfun = function(FundBillDR,Name){

var statetitle = Name +"��Ŀ������ϸ";


var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.srm.PrjReimbursemenFundTotalexe.csp',
				fields : [
				{
							header : '������ϸID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'itemname',
							header : '��Ŀ����',
							dataIndex : 'itemname',
							width : 100,
							editable:false
						},{
							id : 'budgvalue',
							header : '��Ŀ���ƽ��(��Ԫ)',
							align:'right',
							dataIndex : 'budgvalue',
							width : 120,
							editable:false,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						},{
							id : 'datastatus',
							header : '״̬',
							dataIndex : 'datastatus',
							width : 80,
							editable:false

						},{
							id : 'checkresult',
							header : '����״̬',
							dataIndex : 'checkresult',
							align:'left',
							width : 150,
							editable:false
						},{
							id : 'checkdesc',
							header : '�������',
							dataIndex : 'checkdesc',
							align:'left',
							width : 150,
							editable:false

						}]
						//viewConfig : {forceFit : true}
						//tbar : ['������ȣ�',yearCombo,'��Ŀ���ƣ�',projCombo,'-',findButton ]	

			});

	detailitemGrid.btnAddHide();  //�������Ӱ�ť
   	detailitemGrid.btnSaveHide();  //���ر��水ť
    detailitemGrid.btnResetHide();  //�������ð�ť
    detailitemGrid.btnDeleteHide(); //����ɾ����ť
    detailitemGrid.btnPrintHide();  //���ش�ӡ��ť
	detailitemGrid.load({params:{start:0, limit:12,projdr:FundBillDR}});
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�',iconCls : 'cancel'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  window.close();
	};

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [detailitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				iconCls : 'popup_list',
				title : statetitle,
				plain : true,
				width : 700,
				height : 450,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};

PrjFundMatchedfun = function(FundBillDR,Name){

var statetitle = Name +"��λ������ϸ";


var detailitemGrid1 = new dhc.herp.Grid({
	
				width : 400,
				region : 'center',
				url : 'herp.srm.PrjAppropriationdetailexe.csp',
				fields : [
				{
							header : '��λ������ϸID',
							width : 30,
							editable:false,
							dataIndex : 'RowID',
							hidden : true
						},{
							id : 'arriveexpenditure',
							header : '��λ����(��Ԫ)',
							align:'right',
							dataIndex : 'arriveexpenditure',
							width : 100,
							editable:false,
							renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						},{
							id : 'recipient',
							header : '������',
							dataIndex : 'recipient',
							width : 100,
							editable:false

						},{
							id : 'midcheckFlag',
							header : '״̬',
							dataIndex : 'midcheckFlag',
							width : 80,
							editable:false

						},{
							id : 'midcheckState',
							header : '����״̬',
							dataIndex : 'midcheckState',
							align:'left',
							width : 150,
							editable:false
						},{
							id : 'midcheckopinion',
							header : '�������',
							dataIndex : 'midcheckopinion',
							align:'left',
							width : 150,
							editable:false

						}]
						//viewConfig : {forceFit : true}
						//tbar : ['������ȣ�',yearCombo,'��Ŀ���ƣ�',projCombo,'-',findButton ]	

			});

	detailitemGrid1.btnAddHide();  //�������Ӱ�ť
   	detailitemGrid1.btnSaveHide();  //���ر��水ť
    detailitemGrid1.btnResetHide();  //�������ð�ť
    detailitemGrid1.btnDeleteHide(); //����ɾ����ť
    detailitemGrid1.btnPrintHide();  //���ش�ӡ��ť
	detailitemGrid1.load({params:{start:0, limit:12,rowid:FundBillDR}});
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
				items : [detailitemGrid1]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				iconCls: 'popup_list',
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
DetailFun = function(PayBillNo)
{	

	var detailGrid = new dhc.herp.Griddetail({
	    title: '��Ӧ�̸�����ϸ ',
	    width: 400,
	    region: 'center',
	    url:'herp.acct.acctPayMonyDetailexe.csp' ,
	    fields: [{

	        id:'rowid',
	        header: '�������ݲɼ���ϸ��ID',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'rowid',
	        hidden:true
	   }, {
	        id:'AcctYear',
	        header: '���',
	        allowBlank: false,
	        width:60,
	        editable:false,
	        dataIndex: 'AcctYear'

	   }, {
	        id:'AcctMonth',
	        header: '�·�',
	        allowBlank: false,
	        width:60,
	        editable:false,
	        dataIndex: 'AcctMonth'

	   },{
	        id:'SupplierCode',
	        header: '��λ����',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'SupplierCode'

	   }, {
	        id:'SupplierName',
	        header: '��λ����',
	        allowBlank: false,
	        width:190,
	        editable:false,
	        dataIndex: 'SupplierName'

	   }, {
	        id:'ItemTypeName',
	        header: '�����������',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'ItemTypeName'

	   }, {
	        id:'ItemName',
	        header: '��Ŀ����',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'ItemName'

	   }, {
	        id:'ItemValue',
	        header: '��Ŀ���',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'ItemValue'

	   }, {
	        id:'InvoiceNo',
	        header: '��Ʊ��',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'InvoiceNo'
	   }, {
	        id:'InvoiceDate',
	        header: '��Ʊ����',
	        allowBlank: false,
	        width:100,
	        hidden:true,
	        editable:false,
	        dataIndex: 'InvoiceDate'
	   }, {
	        id:'BillNo',
	        header: '���ݺ�',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'BillNo'
	   }, {
	        id:'curMoney',
	        header: '���ҽ��',
	        allowBlank: false,
	        width:100,
	        hidden:true,
	        editable:false,
	        dataIndex: 'curMoney'
	   }, {
	        id:'CreateDate',
	        header: '�ɼ�����',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'CreateDate'
	   }]

	});
	
	detailGrid.btnAddHide();  //���ر��水ť
	detailGrid.btnDeleteHide(); //�������ð�ť
	detailGrid.btnSaveHide();  //���ر��水ť
	detailGrid.btnResetHide();  //�������ð�ť
	detailGrid.btnPrintHide();  //���ش�ӡ��ť
	
	detailGrid.load(({params:{start:0,limit:25,PayBillNo:PayBillNo}}));	
	
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		window.close();
	}
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [detailGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				plain : true,
				width : 1000,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	detailGrid.getStore().on("load",function()
			{
				
				if(detailGrid.getStore().getCount()<1)
	              {
			    Ext.Msg.show({title:'ע��',msg:'����û�и�����ϸ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                  }		
                else
                 {
	             window.show();
                  }
			});
	
	
};
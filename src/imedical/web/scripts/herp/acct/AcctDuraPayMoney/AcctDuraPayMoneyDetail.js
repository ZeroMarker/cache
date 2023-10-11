DetailFun = function(PayBillNo)
{	

	var detailGrid = new dhc.herp.Griddetail({
	    title: '供应商付款明细 ',
	    width: 400,
	    region: 'center',
	    url:'herp.acct.acctPayMonyDetailexe.csp' ,
	    fields: [{

	        id:'rowid',
	        header: '物资数据采集明细表ID',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'rowid',
	        hidden:true
	   }, {
	        id:'AcctYear',
	        header: '年度',
	        allowBlank: false,
	        width:60,
	        editable:false,
	        dataIndex: 'AcctYear'

	   }, {
	        id:'AcctMonth',
	        header: '月份',
	        allowBlank: false,
	        width:60,
	        editable:false,
	        dataIndex: 'AcctMonth'

	   },{
	        id:'SupplierCode',
	        header: '单位编码',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'SupplierCode'

	   }, {
	        id:'SupplierName',
	        header: '单位名称',
	        allowBlank: false,
	        width:190,
	        editable:false,
	        dataIndex: 'SupplierName'

	   }, {
	        id:'ItemTypeName',
	        header: '物资类别名称',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'ItemTypeName'

	   }, {
	        id:'ItemName',
	        header: '项目名称',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'ItemName'

	   }, {
	        id:'ItemValue',
	        header: '项目金额',
	        allowBlank: false,
	        width:90,
	        editable:false,
	        dataIndex: 'ItemValue'

	   }, {
	        id:'InvoiceNo',
	        header: '发票号',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'InvoiceNo'
	   }, {
	        id:'InvoiceDate',
	        header: '发票日期',
	        allowBlank: false,
	        width:100,
	        hidden:true,
	        editable:false,
	        dataIndex: 'InvoiceDate'
	   }, {
	        id:'BillNo',
	        header: '单据号',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'BillNo'
	   }, {
	        id:'curMoney',
	        header: '本币金额',
	        allowBlank: false,
	        width:100,
	        hidden:true,
	        editable:false,
	        dataIndex: 'curMoney'
	   }, {
	        id:'CreateDate',
	        header: '采集日期',
	        allowBlank: false,
	        width:100,
	        editable:false,
	        dataIndex: 'CreateDate'
	   }]

	});
	
	detailGrid.btnAddHide();  //隐藏保存按钮
	detailGrid.btnDeleteHide(); //隐藏重置按钮
	detailGrid.btnSaveHide();  //隐藏保存按钮
	detailGrid.btnResetHide();  //隐藏重置按钮
	detailGrid.btnPrintHide();  //隐藏打印按钮
	
	detailGrid.load(({params:{start:0,limit:25,PayBillNo:PayBillNo}}));	
	
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({
				text : '关闭'
			});

	// 定义取消按钮的响应函数
	cancelHandler = function() {
		window.close();
	}
	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	// 初始化面板
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
			    Ext.Msg.show({title:'注意',msg:'数据没有付款明细!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
                  }		
                else
                 {
	             window.show();
                  }
			});
	
	
};

PrjFundMatchedfun = function(FundBillDR,Name){

var statetitle = Name +"到位经费明细";


var detailitemGrid1 = new dhc.herp.Grid({
	
				width : 400,
				region : 'center',
				url : 'herp.srm.PrjAppropriationdetailexe.csp',
				fields : [
				{
							header : '到位经费明细ID',
							width : 30,
							editable:false,
							dataIndex : 'RowID',
							hidden : true
						},{
							id : 'arriveexpenditure',
							header : '到位经费(万元)',
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
							header : '接收人',
							dataIndex : 'recipient',
							width : 100,
							editable:false

						},{
							id : 'midcheckFlag',
							header : '状态',
							dataIndex : 'midcheckFlag',
							width : 80,
							editable:false

						},{
							id : 'midcheckState',
							header : '审批状态',
							dataIndex : 'midcheckState',
							align:'left',
							width : 150,
							editable:false
						},{
							id : 'midcheckopinion',
							header : '审批结果',
							dataIndex : 'midcheckopinion',
							align:'left',
							width : 150,
							editable:false

						}]
						//viewConfig : {forceFit : true}
						//tbar : ['立项年度：',yearCombo,'项目名称：',projCombo,'-',findButton ]	

			});

	detailitemGrid1.btnAddHide();  //隐藏增加按钮
   	detailitemGrid1.btnSaveHide();  //隐藏保存按钮
    detailitemGrid1.btnResetHide();  //隐藏重置按钮
    detailitemGrid1.btnDeleteHide(); //隐藏删除按钮
    detailitemGrid1.btnPrintHide();  //隐藏打印按钮
	detailitemGrid1.load({params:{start:0, limit:12,rowid:FundBillDR}});
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭',iconCls : 'cancel'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
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

FundTotalfun = function(FundBillDR,Name){

var statetitle = Name +"科目编制明细";


var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.srm.PrjReimbursemenFundTotalexe.csp',
				fields : [
				{
							header : '编制明细ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'itemname',
							header : '科目名称',
							dataIndex : 'itemname',
							width : 100,
							editable:false
						},{
							id : 'budgvalue',
							header : '科目编制金额(万元)',
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
							header : '状态',
							dataIndex : 'datastatus',
							width : 80,
							editable:false

						},{
							id : 'checkresult',
							header : '审批状态',
							dataIndex : 'checkresult',
							align:'left',
							width : 150,
							editable:false
						},{
							id : 'checkdesc',
							header : '审批结果',
							dataIndex : 'checkdesc',
							align:'left',
							width : 150,
							editable:false

						}]
						//viewConfig : {forceFit : true}
						//tbar : ['立项年度：',yearCombo,'项目名称：',projCombo,'-',findButton ]	

			});

	detailitemGrid.btnAddHide();  //隐藏增加按钮
   	detailitemGrid.btnSaveHide();  //隐藏保存按钮
    detailitemGrid.btnResetHide();  //隐藏重置按钮
    detailitemGrid.btnDeleteHide(); //隐藏删除按钮
    detailitemGrid.btnPrintHide();  //隐藏打印按钮
	detailitemGrid.load({params:{start:0, limit:12,projdr:FundBillDR}});
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
////资金申请单据明细表

 FundBillDetail = function(rowid,funcode){

 var statetitle;
 statetitle = funcode+"单据状态明细";

var addmainGrid = new dhc.herp.Gridapplyadddetail({
				width : 600,
				region : 'center',
				url : 'herp.budg.fundbilldetailexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'BudgCode',
							header : '预算项编码',
							dataIndex : 'BudgCode',
							width : 120,
							align:'left',
							editable:false
						},{
							id : 'ReqPay',
							header : '申请金额',
							dataIndex : 'ReqPay',
                                                        align:'right',
							width : 120,
							editable:false

						},{
							id : 'ActPay',
							header : '审批支付金额',
							dataIndex : 'ActPay',
                                                        align:'right',
							width : 120,
							editable:false

						},{
							id : 'Balance',
							header : '目前预算结余',
							dataIndex : 'Balance',
  						        align:'right',
							width : 120,
                                                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           var sf = record.data['Balance']
						           if (sf >=0) {
							   return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						             } else {
							    return '<span style="color:red;cursor:hand">'+value+'</span>';
						             }},
							editable:false

						},{
							id : 'Desc',
							header : '说明',
							dataIndex : 'Desc',
							width : 120,
							editable:false

						}]
});


        addmainGrid.btnAddHide();  //隐藏增加按钮
   	addmainGrid.btnSaveHide();  //隐藏保存按钮
    

	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

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
				items : [addmainGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[addmainGrid]                                 //添加Tabs
  });
	

	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 650,
				height : 400,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]
			});
	window.show();	
       addmainGrid.load({params:{start:0,rowid:rowid}});


};












////项目支出单据明细表
PayBillDetail = function(rowid,payrcode){

 var statetitle;
 statetitle = payrcode +"单据状态明细";

var PayDetailGrid = new dhc.herp.Gridapplyadddetail({
				width : 600,
				region : 'center',
				url : 'herp.budg.paybilldetailexe.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'BudgCode',
							header : '预算项编码',
							dataIndex : 'BudgCode',
							width : 120,
							align:'left',
							editable:false
						},{
							id : 'ReqPay',
							header : '申请金额',
							dataIndex : 'ReqPay',
							width : 120,
                                                        align:'right',
							editable:false

						},{
							id : 'ActPay',
							header : '审批支付金额',
							dataIndex : 'ActPay',
                                                        align:'right',
							width : 120,
							editable:false

						},{
							id : 'Balance',
							header : '预算结余',
							dataIndex : 'Balance',
							align:'right',
							width : 120,
                                                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           var sf = record.data['Balance']
						           if (sf >=0) {
							   return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						             } else {
							    return '<span style="color:red;cursor:hand">'+value+'</span>';
						             }},
							editable:false

						},{
							id : 'Desc',
							header : '说明',
							dataIndex : 'Desc',
							width : 120,
							editable:false

						}]
});


        PayDetailGrid.btnAddHide();  //隐藏增加按钮
   	PayDetailGrid.btnSaveHide();  //隐藏保存按钮
    

	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

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
				items : [PayDetailGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[PayDetailGrid]                                 //添加Tabs
  });
	

	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 650,
				height : 400,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]
			});
	window.show();	
       PayDetailGrid.load({params:{start:0,rowid:rowid}});


};



















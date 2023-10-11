 billstate = function(rowid){

 var statetitle;
 statetitle = "单据状态明细";

var addmainGrid = new dhc.herp.Gridapplyadddetail({
				width : 600,
				region : 'center',
				url : 'herp.budg.billstate.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'serialnumber',
							header : '序号',
							dataIndex : 'serialnumber',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'exectdept',
							header : '执行科室',
							dataIndex : 'exectdept',
							width : 120,
							editable:false

						},{
							id : 'executor',
							header : '执行人',
							dataIndex : 'executor',
							width : 120,
							editable:false

						},{
							id : 'execresult',
							header : '执行结果',
							dataIndex : 'execresult',
///////							align:'right',
							width : 120,
							editable:false

						},{
							id : 'execprocedescr',
							header : '执行过程描述',
							dataIndex : 'execprocedescr',
							width : 120,
							editable:false

						},{
							id : 'execdate',
							header : '执行时间',
							dataIndex : 'execdate',
							align:'right',
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
				width : 770,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]
			});
	window.show();	
       addmainGrid.load({params:{start:0,rowid:rowid}});


};

 billstate = function(rowid){

 var statetitle;
 statetitle = "����״̬��ϸ";

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
							header : '���',
							dataIndex : 'serialnumber',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'exectdept',
							header : 'ִ�п���',
							dataIndex : 'exectdept',
							width : 120,
							editable:false

						},{
							id : 'executor',
							header : 'ִ����',
							dataIndex : 'executor',
							width : 120,
							editable:false

						},{
							id : 'execresult',
							header : 'ִ�н��',
							dataIndex : 'execresult',
///////							align:'right',
							width : 120,
							editable:false

						},{
							id : 'execprocedescr',
							header : 'ִ�й�������',
							dataIndex : 'execprocedescr',
							width : 120,
							editable:false

						},{
							id : 'execdate',
							header : 'ִ��ʱ��',
							dataIndex : 'execdate',
							align:'right',
							width : 120,
							editable:false
						}]
});


        addmainGrid.btnAddHide();  //�������Ӱ�ť
   	addmainGrid.btnSaveHide();  //���ر��水ť
    

	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

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
				items : [addmainGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[addmainGrid]                                 //���Tabs
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

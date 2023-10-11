
stateFun = function(FundBillDR,Code,Name){

var statetitle = "���ݺ�"+Code+"��Ӧ����Ŀ"+Name +"״̬";


var stateitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgfundapplystate.csp',
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'deptname',
							header : 'ִ�п���',
							dataIndex : 'deptname',
							width : 80,
							editable:false
						},{
							id : 'apllyname',
							header : 'ִ����',
							dataIndex : 'apllyname',
							width : 70,
							editable:false

						},{
							id : 'ChkResult',
							header : 'ִ�н��',
							dataIndex : 'ChkResult',
							width : 60,
							editable:false

						},{
							id : 'ChkProcDesc',
							header : 'ִ�й�������',
							dataIndex : 'ChkProcDesc',
							width : 80,
							editable:false

						},{
							id : 'DateTime',
							header : 'ִ��ʱ��',
							dataIndex : 'DateTime',
							width : 120,
							editable:false

						}],
						viewConfig : {forceFit : true}	

			});

	stateitemGrid.btnAddHide();  //�������Ӱ�ť
   	stateitemGrid.btnSaveHide();  //���ر��水ť
    stateitemGrid.btnResetHide();  //�������ð�ť
    stateitemGrid.btnDeleteHide(); //����ɾ����ť
    stateitemGrid.btnPrintHide();  //���ش�ӡ��ť
    
	stateitemGrid.load({params:{start:0, limit:12,FundBillDR:FundBillDR}});
	// ��ʼ��ȡ����ť
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
				items : [stateitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 600,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};
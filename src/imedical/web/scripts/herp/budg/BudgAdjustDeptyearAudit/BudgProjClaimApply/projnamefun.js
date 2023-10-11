var userid = session['LOGON.USERID'];//FundBillDR,projDr,Name
projnamefun = function(FundBillDR,projDr,Name){

var statetitle = Name +"ִ����ϸ";

var projUrl = 'herp.budg.budgprojclaimapplymainexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '�������',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
var projDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

projDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=projName&userid='+userid,
						method : 'POST'
					});
		});

var projCombo = new Ext.form.ComboBox({
			fieldLabel : '��Ŀ����',
			store : projDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'option',
	handler: function(){
	      	var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			detailitemGrid.load({params:{start:0,limit:12,year:year,projname:projname}});
			
	}
});

var detailitemGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplyprojname.csp',
				fields : [
				{
							header : 'ִ����ϸID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'Date',
							header : 'ʱ��',
							dataIndex : 'Date',
							width : 60,
							editable:false
						},{
							id : 'Desc',
							header : 'ժҪ',
							dataIndex : 'Desc',
							width : 70,
							editable:false

						},{
							id : 'itemCode',
							header : 'Ԥ����',
							dataIndex : 'itemCode',
							width : 80,
							editable:false

						},{
							id : 'BudgValue',
							header : 'Ԥ���',
							dataIndex : 'BudgValue',
							align:'right',
							width : 60,
							editable:false
						},{
							id : 'PayValue',
							header : 'ִ�ж�',
							dataIndex : 'PayValue',
							align:'right',
							width : 60,
							editable:false

						},{
							id : 'Banlance',
							header : '����',
							dataIndex : 'Banlance',
							align:'right',
							width : 60,
							editable:false

						}],
						viewConfig : {forceFit : true},
						tbar : ['������ȣ�',yearCombo,'��Ŀ���ƣ�',projCombo,'-',findButton ]	

			});

	detailitemGrid.btnAddHide();  //�������Ӱ�ť
   	detailitemGrid.btnSaveHide();  //���ر��水ť
    detailitemGrid.btnResetHide();  //�������ð�ť
    detailitemGrid.btnDeleteHide(); //����ɾ����ť
    detailitemGrid.btnPrintHide();  //���ش�ӡ��ť
	detailitemGrid.load({params:{start:0, limit:12,projDr:projDr}});
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
				items : [detailitemGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
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
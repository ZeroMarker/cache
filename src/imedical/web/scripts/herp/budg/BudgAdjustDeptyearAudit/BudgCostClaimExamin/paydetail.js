 paydetail = function(rowid,applydecls,applyers,deprdrs,billcodes){

 ///var statetitle;
 

 var statetitle = "һ��֧����������ϸ";

 //var code=FundBillDR;
 var name="vcxv";
 var username="cv";
 var Desc="weerdfs";
//////�ʽ����뵥��//////////////////
applyDs1 = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

applyDs1.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costpaydetaiexe.csp?action=billcode',
				method : 'POST'
			});
});

 applyCombo1 = new Ext.form.ComboBox({
	fieldLabel : '�ʽ����뵥��',
	store : applyDs1,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 100,
	listWidth : 230,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});


/////////////////////Ԥ����///////////////////////////


    budget = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowids', 'names'])
});

    budget.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costpaydetaiexe.csp?action=budget',
				method : 'POST'
			});
});

 budgetCombox = new Ext.form.ComboBox({
	fieldLabel : 'Ԥ����',
	store : budget,
	displayField : 'names',
	valueField : 'rowids',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 150,
	listWidth : 230,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

/////////////////////Ԥ����//////////////////////////

  budgetitem = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowids', 'names'])
});

    budgetitem.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.costpaydetaiexe.csp?action=budgetitem',
				method : 'POST'
			});
});

 budgetitemCombox = new Ext.form.ComboBox({
	fieldLabel : 'Ԥ����',
	store :budgetitem,
	displayField : 'names',
	valueField : 'rowids',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 150,
	listWidth : 230,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
 
/////////////////////��������/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:billcodes,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////��������/////////////////////////
var projname = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:deprdrs,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////������/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: applyers,
                 	disabled: true,
			selectOnFocus : true

		});
/////////////////////����˵��/////////////////////////
Descfield1 = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:applydecls,
			selectOnFocus : true

		});		




//////�޸�
var modification = new Ext.Toolbar.Button({
	text: '�޸�',
        tooltip:'�޸�',        
        iconCls:'add',
	handler:function(){
        var selectedRow = addmainGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
         rowid	=selectedRow[0].data['rowid'];
	modificationfun(rowid);
	}
	
});

var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">һ����֧����������ϸ</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .12
				},applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '��������:',
					columnWidth : .12
				},projname,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '������:',
					columnWidth : .12
				}, appuName

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : 'Ԥ����:',
					columnWidth : .12
				},budgetCombox,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�ʽ����뵥��:',
					columnWidth : .12
				},applyCombo1,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '˵��:',
					columnWidth : .12
				},Descfield1

		]
	}]
});



//////////////////////////////
var paydetailGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : 'herp.budg.costpaydetaiexe.csp',
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
							id : 'budget',
							header : 'Ԥ����',
							dataIndex : 'budget',
							align:'right',
							width : 120,
							type:budgetitemCombox


						},{
							id : 'currbudgetsurplus',
							header : '��ǰԤ�����',
							dataIndex : 'currbudgetsurplus',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'reimbursementapply',
							header : '���α�������',
							dataIndex : 'reimbursementapply',
							align:'right',
							width : 120,
							editable:true

						},{
							id : 'examinepay',
							header : '����֧��',
							dataIndex : 'examinepay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'execbudgetsurplus',
							header : 'ִ�к�Ԥ�����',
							dataIndex : 'execbudgetsurplus',
							align:'right',
							width : 120,
							editable:false
						},{
							id : 'budgetcontrol',
							header : 'Ԥ�����',
							dataIndex : 'budgetcontrol',
							align:'right',
							width : 120,
							editable:false,
                                                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgetcontrol']
						if (sf == "Ԥ����") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}}
						}],
tbar:[modification]
});
   


 paydetailGrid.btnPrintHide() 	//���ش�ӡ��ť
                 
 paydetailGrid.btnResetHide();  //�������ð�ť     

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
				items : [queryPanel,paydetailGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,paydetailGrid]                                 //���Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 885,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	window.show();	
        paydetailGrid.load({params:{start:0,rowid:rowid}});
};
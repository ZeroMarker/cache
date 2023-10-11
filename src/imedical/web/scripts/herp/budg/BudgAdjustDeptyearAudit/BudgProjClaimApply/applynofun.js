
applynofun = function(itemDetail){
	var userid = session['LOGON.USERID'];

	var records   = itemDetail.getSelectionModel().getSelections();
	var rowid     = records[0].get("rowid")
	var code  	  = records[0].get("code");
	var name  	  = records[0].get("name");
	var deptname  = records[0].get("deptname");
	var username  = records[0].get("username");
	var Desc  	  = records[0].get("Desc");
	var facode    = records[0].get("facode")
	var projdr    = records[0].get("projdr")
	var oldfundbilldr=records[0].get("FundBillDR")	
	var BillState=records[0].get("BillState")	
	
var statetitle = name +"֧������";

////////////////////////// �ʽ����뵥�� ///////////////////////
 applyDs1 = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'namedesc'])
});

applyDs1.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=billcode&projDr='+projdr,
				method : 'POST'
			});
});
var applyCombo1 = new Ext.form.ComboBox({
	fieldLabel : '�ʽ����뵥',
	store : applyDs1,
	displayField : 'namedesc',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	allowBlank:false,
	width : 90,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});
applyCombo1.setValue(facode);
 
/////////////////////��������/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:code,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////��Ŀ����/////////////////////////
var projname = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:name,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////������/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: username,
			disabled: true,
			selectOnFocus : true

		});
/////////////////////����˵��/////////////////////////
Descfield1 = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: Desc,
			selectOnFocus : true

		});		
/////////////////////�������/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: deptname,
			disabled: true,
			selectOnFocus : true

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
			value : '<center><p style="font-weight:bold;font-size:120%">��Ŀ֧������</p></center>',
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
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '��Ŀ����:',
					columnWidth : .12
				},projname,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
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
					value : '����˵��:',
					columnWidth : .12
				}, Descfield1,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�������:',
					columnWidth : .12
				},dnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '�ʽ����뵥:',
					columnWidth : .12
				}, applyCombo1

		]
	}]
});

//Ԥ����
var codeDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['code', 'name'])
});

codeDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=itemcode',
				method : 'POST'
			});
});

var codeCombo = new Ext.form.ComboBox({
	fieldLabel : 'Ԥ����',
	store : codeDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
//	value:codedesc,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

//��ǰԤ�����
var budgbalanceDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['code', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp'+'?action=budgbalance&start=0&limit=25&itemcode='+ codeCombo.getvalue(),
				method : 'POST'
			});
});

var budgbalanceCombo = new Ext.form.ComboBox({
	fieldLabel : '��ǰԤ�����',
	store : budgbalanceDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	disabled: true,
	emptyText : '',
	columnWidth : .15,
	width : 200,
	selectOnFocus : true
});

//����¼��
var valueField = new Ext.form.TextField({
	id: 'valueField',
	width:215,
	listWidth : 215,
	name: 'valueField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "ֻ����������",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var applyGrid = new dhc.herp.Gridapplynos({
				width : 600,
				height : 150,
				region : 'south',
				url : 'herp.budg.budgprojclaimapplynos.csp',
				tbar:[],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                 if (BillState=="�ύ") {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						if (BillState=="�ύ") {
		                      return false;
		                 } else {return true;}
					}
            	},
				fields : [
						{
							header : '��Ŀ֧����ϸID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'itemcode',
							header : 'Ԥ����(����)',
							dataIndex : 'itemcode',
							width : 60,
							editable:false,
							hidden : true
						},{
							id : 'codename',
							header : 'Ԥ����',
							dataIndex : 'codename',
							width : 100,
							editable:false,
							type:codeCombo
						},{
							id : 'budgreal',
							header : '��ǰԤ�����',
							dataIndex : 'budgreal',
							align:'right',
							width : 120,
							editable:false,
							type:budgbalanceCombo

						},{
							id : 'reqpay',
							header : '���α�������',
							dataIndex : 'reqpay',
							align:'right',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							editable:true,
							type:valueField
						},{
							id : 'actpay',
							header : '����֧��',
							align:'right',
							dataIndex : 'actpay',
							width : 120,
							editable:false

						},{
							id : 'ddesc',
							header : '˵��',
							dataIndex : 'ddesc',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
								cellmeta.css="cellColor3";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
								return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
								},
							width : 120,
							editable:true
						},{
							id : 'budgco',
							header : 'ִ��Ԥ�����',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcontrol',
							header : 'Ԥ�����',
							dataIndex : 'budgcontrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcontrol']
							if (sf == "����Ԥ��") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						}],
						loadMask : true,
						viewConfig : {forceFit : true}
			});
var aaa = function(){ 
	mainGrid.load({params:{start:0, limit:25,rowid:rowid}});
	};			
Ext.getCmp('herpSaveId').addListener('click', aaa, false);


/////////////////�����е���Ӱ�ť////////////////////////////
var saveButtonMain = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'���',        
    iconCls: 'save',
	handler:function(){

		var mdesc=encodeURIComponent(Descfield1.getValue());
		var fundbilldr=applyCombo1.getValue();
		if(fundbilldr==facode)
		{
			fundbilldr=oldfundbilldr
		}
		
		var datad='&rowid='+rowid+'&mdesc='+mdesc+'&fundbilldr='+fundbilldr+'&oldfundbilldr='+oldfundbilldr;		
		Ext.Ajax.request({
				url: 'herp.budg.budgprojclaimapplynos.csp?action=edit'+datad,
				waitMsg : '������...',
				failure : function(result, request) {
					Ext.Msg.show({
								title : '����',
								msg : '������������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Ext.Msg.show({
								title : '',
								msg : '����ɹ�',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.INFO
							});
					}
				},
				scope : this
			});
			
			mainGrid.load({params:{start:0, limit:25,rowid:rowid}});
	}
	
	
	
});


var mainGrid = new dhc.herp.Gridapplyno({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplyno.csp',
				tbar:[saveButtonMain],
				fields : [
				{
							header : '��Ŀ֧������ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'budgtotal',
							header : '��Ŀ��Ԥ��',
							dataIndex : 'budgtotal',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'reppay',
							header : '�����ʽ�',
							dataIndex : 'reppay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaywait',
							header : '��;����',
							dataIndex : 'actpaywait',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpay',
							header : '��ִ��Ԥ��',
							dataIndex : 'actpay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcur',
							header : '��ǰԤ�����',
							dataIndex : 'budgcur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaycur',
							header : '���α���',
							dataIndex : 'actpaycur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgco',
							header : 'ִ�к�Ԥ�����',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcontrol',
							header : 'Ԥ�����',
							dataIndex : 'budgcontrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcontrol']
							if (sf == "����Ԥ��") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						},{
							id : 'FundBillDR',
							header : '��Ŀ������Ӧ���ʽ����뵥ID',
							dataIndex : 'FundBillDR',
							align:'right',
							width : 120,
							editable:false,
							hidden:true

						}],
						viewConfig : {forceFit : true}
			}
);




	mainGrid.load({params:{start:0, limit:25,rowid:rowid}});
	applyGrid.load({params:{start:0, limit:25,rowid:rowid}});
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  window.hide();
	  itemDetail.load({params:{start:0,limit:12,userid:userid,projdr:projdr}});
	};

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,mainGrid,applyGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,mainGrid,applyGrid]                                 //���Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	if(BillState=="�ύ")
	{
		saveButtonMain.disable();
		Ext.getCmp('herpSaveId').disable();
		applyCombo1.disable();
		Descfield1.disable();
	}
	window.show();
};


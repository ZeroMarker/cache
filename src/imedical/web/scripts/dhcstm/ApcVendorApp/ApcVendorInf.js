var gUserId = session['LOGON.USERID'];	

var Vendor = new Ext.ux.UsrVendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '30%',
	userId :gUserId,
	emptyText : '��Ӧ��...'
});



var findAPCVendor = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var rowid = Ext.getCmp('Vendor').getValue();
		SetVendorInfo(rowid);
	}
});

// ��հ�ť
var RefreshBT = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '������',
	iconCls : 'page_clearscreen',
	width : 70,
	Height : 30,
	handler : function() {
		clearData();
	}
});

		
		 //��շ���
		 
function clearData() {
	Ext.getCmp("Vendor").setValue('');
	rowid="";
	
	//������Ϣ
	Ext.getCmp('codeField').setValue('');
	Ext.getCmp('nameField').setValue('');
	Ext.getCmp('categoryField').setValue('');
	Ext.getCmp('categoryField').setRawValue('');
	Ext.getCmp('corporationField').setValue('');
	Ext.getCmp('presidentField').setValue('');
	Ext.getCmp('ctrlAcctField').setValue('');
	Ext.getCmp('bankField').setValue('');
	Ext.getCmp('crAvailField').setValue('');
	Ext.getCmp('lstPoDate').setValue('');
	Ext.getCmp('addressField').setValue('');
	Ext.getCmp('telField').setValue('');
	Ext.getCmp('faxField').setValue('');
	Ext.getCmp('limitSupplyField').setValue(false);
	Ext.getCmp('feeField').setValue('');
	Ext.getCmp('stateField').setValue('');
	Ext.getCmp('stateField').setRawValue("ͣ��");
	//������Ϣ
	Ext.getCmp('comLicField').setValue('');
	Ext.getCmp('taxLicField').setValue('');
	Ext.getCmp('orgCodeField').setValue('');
	Ext.getCmp('drugBusLicField').setValue('');
	Ext.getCmp('comLicValidDate').setValue('');
	Ext.getCmp('taxLicValidDate').setValue('');
	Ext.getCmp('orgCodeValidDate').setValue('');
	Ext.getCmp('drugBusLicValidDate').setValue('');
	Ext.getCmp('insBusLicField').setValue('');
	Ext.getCmp('insProLicField').setValue('');
	Ext.getCmp('qualityCommField').setValue('');
	Ext.getCmp('agentAuthField').setValue('');
	Ext.getCmp('insBusLicValidDate').setValue('');
	Ext.getCmp('insProLicValidDate').setValue('');
	Ext.getCmp('qualityCommValidDate').setValue('');
	Ext.getCmp('agentAuthValidDate').setValue('');
	Ext.getCmp('saleServCommField').setValue('');
	Ext.getCmp('drugProLicField').setValue('');
	Ext.getCmp('drugRegLicField').setValue('');
	Ext.getCmp('gspLicField').setValue('');
	Ext.getCmp('legalCommField').setValue('');
	Ext.getCmp('drugProLicValidDate').setValue('');
	Ext.getCmp('drugRegLicValidDate').setValue('');
	Ext.getCmp('gspLicValidDate').setValue('');
	Ext.getCmp('insRegLicField').setValue('');
	Ext.getCmp('inletRegLicField').setValue('');
	Ext.getCmp('inletRLicField').setValue('');
	Ext.getCmp('insRegLicValidDate').setValue('');
	Ext.getCmp('inletRegLicValidDate').setValue('');
	Ext.getCmp('inletRLicValidDate').setValue('');
	//ҵ��Ա��Ȩ��Ϣ
	Ext.getCmp('bussPersonField').setValue('');
	Ext.getCmp('validDate').setValue('');
	Ext.getCmp('phoneField').setValue('');			
	
}

//�����༭����(����)
//rowid :��Ӧ��rowid


	
	
	//��Ӧ�̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>*��Ӧ�̴���</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ�̴���...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��Ӧ������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>*��Ӧ������</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҵ��Ա����
	var bussPersonField = new Ext.form.TextField({
		id:'bussPersonField',
		fieldLabel:'ҵ��Ա����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҵ��Ա����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��Ӧ�̴���
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'��Ӧ�̵�ַ',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ�̵�ַ...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��Ӧ�̵绰
	var telField = new Ext.form.TextField({
		id:'telField',
		fieldLabel:'��Ӧ�̵绰',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ�̵绰...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����
	var categoryField = new Ext.form.ComboBox({
		id:'categoryField',
		fieldLabel:'����',
		width:143,
		listWidth:250,
		allowBlank:true,
		store:GetVendorCatStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'����...',
		triggerAction:'all',
		//emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	
	//�˻�
	var ctrlAcctField = new Ext.form.NumberField({
		id:'ctrlAcctField',
		fieldLabel:'�˻�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�˻�...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��������
	var bankField = new Ext.form.TextField({
		id:'bankField',
		fieldLabel:'��������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ע���ʽ�
	var crAvailField = new Ext.form.NumberField({
		id:'crAvailField',
		fieldLabel:'ע���ʽ�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ע���ʽ�...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//�ɹ����
	var feeField = new Ext.form.NumberField({
		id:'feeField',
		fieldLabel:'�ɹ����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�ɹ����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��ͬ��ֹ����
	var lstPoDate = new Ext.ux.DateField({ 
		id:'lstPoDate',
		fieldLabel:'��ͬ��ֹ����',  
		allowBlank:true,
		width:143,
		listWidth:143
	});
	
	//ҵ��Ա֤����Ч��
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:'֤����Ч��',  
		allowBlank:true,
		width:184,
		listWidth:184
	});
	
	//ҵ��Ա�绰
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:'ҵ��Ա�绰',  
		allowBlank:true,
		width:184,
		listWidth:184      
		//emptyText:'ҵ��Ա�绰 ...'
	});
	
	//����
	var faxField = new Ext.form.TextField({
		id:'faxField',
		fieldLabel:'����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����
	var corporationField = new Ext.form.TextField({
		id:'corporationField',
		fieldLabel:'����(��ϵ��)',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����(��ϵ��)...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//�������֤
	var presidentField = new Ext.form.TextField({
		id:'presidentField',
		fieldLabel:'�������֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�������֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//״̬
	var stateStore = new Ext.data.SimpleStore({
		fields:['key', 'keyValue'],
		data:[["A",'ʹ��'], ["S",'ͣ��']]
	});
	
	var stateField = new Ext.form.ComboBox({
		id:'stateField',
		fieldLabel:'ʹ��״̬',
		width:184,
		listWidth:184,
		allowBlank:true,
		store:stateStore,
		value:'A', // Ĭ��ֵ"ʹ��"
		valueField:'key',
		displayField:'keyValue',
		//emptyText:'ʹ��״̬...',
		triggerAction:'all',
		//emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local'
	});
	
	//���ƹ�Ӧ
	var limitSupplyField = new Ext.form.Checkbox({
		id: 'limitSupplyField',
		fieldLabel:'���ƹ�Ӧ',
		allowBlank: true
	});
	
	//����ִ��
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'����ִ��',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ִ��...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����ִ����Ч��
	var comLicValidDate = new Ext.ux.DateField({ 
		id:'comLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	//˰��ִ��
	var taxLicField = new Ext.form.TextField({
		id:'taxLicField',
		fieldLabel:'˰��ִ��',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'˰��ִ��...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//˰��ִ����Ч��
	var taxLicValidDate = new Ext.ux.DateField({ 
		id:'taxLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//��������
	var orgCodeField = new Ext.form.TextField({
		id:'orgCodeField',
		fieldLabel:'��������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����������Ч��
	var orgCodeValidDate = new Ext.ux.DateField({ 
		id:'orgCodeValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//ҩƷ��Ӫ���֤
	var drugBusLicField = new Ext.form.TextField({
		id:'drugBusLicField',
		fieldLabel:'ҩƷ��Ӫ���֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҩƷ��Ӫ���֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷ��Ӫ���֤��Ч��
	var drugBusLicValidDate = new Ext.ux.DateField({ 
		id:'drugBusLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//��е��Ӫ���֤
	var insBusLicField = new Ext.form.TextField({
		id:'insBusLicField',
		fieldLabel:'��е��Ӫ���֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��е��Ӫ���֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��е��Ӫ���֤��Ч��
	var insBusLicValidDate = new Ext.ux.DateField({ 
		id:'insBusLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});

	//��е�������֤
	var insProLicField = new Ext.form.TextField({
		id:'insProLicField',
		fieldLabel:'��е�������֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��е�������֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��е�������֤��Ч��
	var insProLicValidDate = new Ext.ux.DateField({ 
		id:'insProLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//������ŵ��
	var qualityCommField = new Ext.form.TextField({
		id:'qualityCommField',
		fieldLabel:'������ŵ��',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'������ŵ��...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//������ŵ����Ч��
	var qualityCommValidDate = new Ext.ux.DateField({ 
		id:'qualityCommValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//������Ȩ��
	var agentAuthField = new Ext.form.TextField({
		id:'agentAuthField',
		fieldLabel:'������Ȩ��',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'������Ȩ��...',
		anchor:'90%',
		selectOnFocus:true
	});

	//������Ȩ����Ч��
	var agentAuthValidDate = new Ext.ux.DateField({ 
		id:'agentAuthValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//�ۺ�����ŵ��
	var saleServCommField = new Ext.form.TextField({
		id:'saleServCommField',
		fieldLabel:'�ۺ�����ŵ��',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�ۺ�����ŵ��...',
		anchor:'90%',
		selectOnFocus:true
	});

	//����ί����
	var legalCommField = new Ext.form.TextField({
		id:'legalCommField',
		fieldLabel:'����ί����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ί����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷ�������֤
	var drugProLicField = new Ext.form.TextField({
		id:'drugProLicField',
		fieldLabel:'ҩƷ�������֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҩƷ�������֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷ�������֤��Ч��
	var drugProLicValidDate = new Ext.ux.DateField({ 
		id:'drugProLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//ҩƷע������
	var drugRegLicField = new Ext.form.TextField({
		id:'drugRegLicField',
		fieldLabel:'ҩƷע������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҩƷע������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷע��������Ч��
	var drugRegLicValidDate = new Ext.ux.DateField({ 
		id:'drugRegLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//GSP��֤
	var gspLicField = new Ext.form.TextField({
		id:'gspLicField',
		fieldLabel:'GSP��֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'GSP��֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//GSP��֤��Ч��
	var gspLicValidDate = new Ext.ux.DateField({ 
		id:'gspLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	 
	//��еע��֤
	var insRegLicField = new Ext.form.TextField({
		id:'insRegLicField',
		fieldLabel:'��еע��֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��еע��֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��еע��֤��Ч��
	var insRegLicValidDate = new Ext.ux.DateField({ 
		id:'insRegLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//����ע��ǼǱ�
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:'����ע��ǼǱ�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ע��ǼǱ�...',
		anchor:'90%',
		selectOnFocus:true
	});

	//����ע��ǼǱ���Ч��
	var inletRegLicValidDate = new Ext.ux.DateField({ 
		id:'inletRegLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	
	//����ע��֤
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:'����ע��֤',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ע��֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����ע��֤��Ч��
	var inletRLicValidDate = new Ext.ux.DateField({ 
		id:'inletRLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});

	
	
	//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			autoHeight : true,
			items : [{
				xtype : 'fieldset',
				title : '������Ϣ',
				autoHeight : true,
				items : [{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[codeField]},
						{columnWidth:.7,layout:'form',items:[nameField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[categoryField]},
						{columnWidth:.35,layout:'form',items:[corporationField]},
						{columnWidth:.35,layout:'form',items:[presidentField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[ctrlAcctField]},
						{columnWidth:.35,layout:'form',items:[bankField]},
						{columnWidth:.35,layout:'form',items:[crAvailField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[lstPoDate]},
						{columnWidth:.7,layout:'form',items:[addressField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[telField]}, 
						{columnWidth:.35,layout:'form',items:[faxField]}, 
						{columnWidth:.35,layout:'form',items:[limitSupplyField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[feeField]},
						{columnWidth:.35,layout:'form',items:[stateField]}
					]
				}]
			},{
				xtype : 'fieldset',
				title : '������Ϣ',
				autoHeight : true,
				items : [{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[comLicField]},
						{columnWidth:.25,layout:'form',items:[taxLicField]},
						{columnWidth:.25,layout:'form',items:[orgCodeField]},
						{columnWidth:.25,layout:'form',items:[drugBusLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[comLicValidDate]},
						{columnWidth:.25,layout:'form',items:[taxLicValidDate]},
						{columnWidth:.25,layout:'form',items:[orgCodeValidDate]},
						{columnWidth:.25,layout:'form',items:[drugBusLicValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insBusLicField]},
						{columnWidth:.25,layout:'form',items:[insProLicField]},
						{columnWidth:.25,layout:'form',items:[qualityCommField]},
						{columnWidth:.25,layout:'form',items:[agentAuthField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insBusLicValidDate]},
						{columnWidth:.25,layout:'form',items:[insProLicValidDate]},
						{columnWidth:.25,layout:'form',items:[qualityCommValidDate]},
						{columnWidth:.25,layout:'form',items:[agentAuthValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[saleServCommField]},
						{columnWidth:.25,layout:'form',items:[drugProLicField]},
						{columnWidth:.25,layout:'form',items:[drugRegLicField]},
						{columnWidth:.25,layout:'form',items:[gspLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[legalCommField]},
						{columnWidth:.25,layout:'form',items:[drugProLicValidDate]},
						{columnWidth:.25,layout:'form',items:[drugRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[gspLicValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insRegLicField]},
						{columnWidth:.25,layout:'form',items:[inletRegLicField]},
						{columnWidth:.25,layout:'form',items:[inletRLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[inletRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[inletRLicValidDate]}
					]
				},{
					layout : 'column',
					autoHeight : true,
					xtype:'fieldset',
					title : 'ҵ��Ա��Ȩ����Ϣ',
					items : [{
						layout : 'column',
						height:25,
						items : [
							{columnWidth:.3,layout:'form',items:[bussPersonField]},
							{columnWidth:.35,layout:'form',items:[validDate]},
							{columnWidth:.35,layout:'form',items:[phoneField]}
						]
					}]
				}]
			}]
		}]
	});
		

	

	//��ʼ������
	/*var window = new Ext.Window({
		title:'�½���Ӧ��',
		width:1000,
		height:612,
		minWidth:1000,
		minHeight:612,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		buttons:[okButton,	cancelButton],
		listeners:{
			'show':function(){
				if (rowid!='')	{SetVendorInfo(rowid);}
			}
		}
	});
	
	window.show();*/
	
	//��ʾ��Ӧ����Ϣ
	function SetVendorInfo(rowid)
	{
		var APCVendorGridUrl = 'dhcstm.apcvendoraction.csp';
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {alert('ʧ�ܣ�');},
			success: function(result, request) {
				//alert(result.responseText)
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//alert(result.responseText);
				if (jsonData.success=='true') {
					var value = jsonData.info;
					//alert(value);
					var arr = value.split("^");
					//������Ϣ
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					addComboData(GetVendorCatStore,arr[10],arr[11]);
					Ext.getCmp('categoryField').setValue(arr[10]);
					Ext.getCmp('corporationField').setValue(arr[7]);
					Ext.getCmp('presidentField').setValue(arr[8]);
					Ext.getCmp('ctrlAcctField').setValue(arr[4]);
					Ext.getCmp('bankField').setValue(arr[3]);
					Ext.getCmp('crAvailField').setValue(arr[12]);
					Ext.getCmp('lstPoDate').setValue(arr[13]);
					Ext.getCmp('addressField').setValue(arr[14]);
					Ext.getCmp('telField').setValue(arr[2]);
					Ext.getCmp('faxField').setValue(arr[6]);
					Ext.getCmp('limitSupplyField').setValue(arr[15]=="Y"?true:false);
					Ext.getCmp('feeField').setValue(arr[5]);
					Ext.getCmp('stateField').setValue(arr[9]);
					Ext.getCmp('stateField').setRawValue(arr[9]=="A"?"ʹ��":"ͣ��");
					//������Ϣ
					Ext.getCmp('comLicField').setValue(arr[16]);
					Ext.getCmp('taxLicField').setValue(arr[38]);
					Ext.getCmp('orgCodeField').setValue(arr[33]);
					Ext.getCmp('drugBusLicField').setValue(arr[19]);
					Ext.getCmp('comLicValidDate').setValue(arr[17]);
					Ext.getCmp('taxLicValidDate').setValue(arr[39]);
					Ext.getCmp('orgCodeValidDate').setValue(arr[34]);
					Ext.getCmp('drugBusLicValidDate').setValue(arr[20]);
					Ext.getCmp('insBusLicField').setValue(arr[29]);
					Ext.getCmp('insProLicField').setValue(arr[31]);
					Ext.getCmp('qualityCommField').setValue(arr[43]);
					Ext.getCmp('agentAuthField').setValue(arr[18]);
					Ext.getCmp('insBusLicValidDate').setValue(arr[30]);
					Ext.getCmp('insProLicValidDate').setValue(arr[32]);
					Ext.getCmp('qualityCommValidDate').setValue(arr[44]);
					Ext.getCmp('agentAuthValidDate').setValue(arr[45]);
					Ext.getCmp('saleServCommField').setValue(arr[35]);
					Ext.getCmp('drugProLicField').setValue(arr[36]);
					Ext.getCmp('drugRegLicField').setValue(arr[40]);
					Ext.getCmp('gspLicField').setValue(arr[21]);
					Ext.getCmp('legalCommField').setValue(arr[42]);
					Ext.getCmp('drugProLicValidDate').setValue(arr[37]);
					Ext.getCmp('drugRegLicValidDate').setValue(arr[41]);
					Ext.getCmp('gspLicValidDate').setValue(arr[22]);
					Ext.getCmp('insRegLicField').setValue(arr[27]);
					Ext.getCmp('inletRegLicField').setValue(arr[25]);
					Ext.getCmp('inletRLicField').setValue(arr[23]);
					Ext.getCmp('insRegLicValidDate').setValue(arr[28]);
					Ext.getCmp('inletRegLicValidDate').setValue(arr[26]);
					Ext.getCmp('inletRLicValidDate').setValue(arr[24]);
					//ҵ��Ա��Ȩ��Ϣ
					Ext.getCmp('bussPersonField').setValue(arr[46]);
					Ext.getCmp('validDate').setValue(arr[47]);
					Ext.getCmp('phoneField').setValue(arr[48]);				
				}
			}
			,
			scope: this
		});
		
	}



//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[{
	          region: 'north',
	          title:'��Ӧ����Ϣ��ѯ',
						labelAlign : 'right',
						frame : true,
				    tbar : [findAPCVendor,'-',RefreshBT],
	          height:100, // give north and south regions a height
	          layout: 'form', // specify layout manager for items
	          bodyStyle : 'padding:5px;',
	          items:[Vendor]
	        },{
	        	region: 'center',
	          title: '��Ӧ����Ϣ',			               
	          layout: 'fit', // specify layout manager for items
	          items: [vendorPanel]
	        }],
		renderTo:'mainPanel'
	});
	
});
	
//===========ģ����ҳ��===========================================
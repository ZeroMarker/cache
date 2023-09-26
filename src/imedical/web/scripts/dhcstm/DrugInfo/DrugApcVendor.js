// ����:��Ӧ�̹���
// ��д����:2012-05-14

//�����༭����(����)
//rowid :��Ӧ��rowid
var gVendorPara = [];
var APCVendorGridUrl = 'dhcstm.apcvendoraction.csp';
var win;
var PbVendor ='';
function CreateEditWin(Vendor){
	PbVendor = Vendor;
	setVendorParam();
	if(win){
		win.show();
		return;
	}

	//��Ӧ�̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>*��Ӧ�̴���</font>',
		allowBlank:false,
		anchor:'90%',
		selectOnFocus:true,
		disabled:true,
		listeners:
		{
			'change':function(x,n,o){
				if (getVendorParamValue('CodeAlphaUp')=='1')		{
					var s=n;
					x.setValue(s.toUpperCase()) ;
				}	
			}
		}
	});
	
	//��Ӧ������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>*��Ӧ������</font>',
		allowBlank:false,
		anchor:'90%',
		selectOnFocus:true,
		disabled:true,
		listeners:
		{
			'change':function(x,n,o){
				if (getVendorParamValue('NameAlphaUp')=='1')		{
					var s=n;
					x.setValue(s.toUpperCase()) ;
				}	
			}
		}
	});
	
	//��Ӧ�̼��
	var abbrevField = new Ext.form.TextField({
		id:'abbrevField',
		fieldLabel:'��Ӧ�̼��',
		//autoWidth:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});	

	///�ϼ���Ӧ��
	var parField = new Ext.ux.VendorComboBox({
		id:'parField',
		fieldLabel:'��һ����Ӧ��',
		anchor:'90%',
		width:143,
		listWidth:250,
		allowBlank:true,
		disabled:true,
		//store:GetParVendorsStore,
		//valueField:'RowId',
		//displayField:'Description',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		listeners:{
			'beforeselect':function(c,rec,index)
			{
				if (rec.get('Description')==Ext.getCmp('nameField').getValue())
				{
					Msg.info("error","�뵱ǰ��Ӧ����ͬ��������!");
					return false;
				}
			}
		}
	});
	
	//ҵ��Ա����
	var bussPersonField = new Ext.form.TextField({
		id:'bussPersonField',
		fieldLabel:'����',
		allowBlank:true,
		anchor:'95%',
		disabled:true,
		selectOnFocus:true
	});
	//ҵ��Ա֤����Ч��
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:'֤����Ч��',
		allowBlank:true,
		anchor:'95%',
		disabled:true
	});
	
	//ҵ��Ա�绰
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:'�绰',
		anchor:'95%',
		disabled:true,
		allowBlank:true
	});
	
	//ҵ��Ա���֤
	var salesIDField = new Ext.form.TextField({ 
		id:'salesIDField',
		anchor:'95%',
		fieldLabel:'���֤',
		disabled:true,
		allowBlank:true
	});
	//ҵ��Ա����
	var emailField = new Ext.form.TextField({ 
		id:'emailField',
		anchor:'95%',
		fieldLabel:'����',
		disabled:true,
		allowBlank:true
	});
	
	//ҵ��Ա���͵绰(�����ֻ���)
	var salesCarrTelField = new Ext.form.TextField({ 
		id:'salesCarrTelField',
		anchor:'95%',
		disabled:true,
		fieldLabel:'�����ֻ���',
		allowBlank:true
	});	
	
	
	//��Ӧ�̴���
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'��Ӧ�̵�ַ',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//��Ӧ�̵绰
	var telField = new Ext.form.TextField({
		id:'telField',
		fieldLabel:'��Ӧ�̵绰',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//����
	var categoryField = new Ext.form.ComboBox({
		id:'categoryField',
		fieldLabel:'����',
		anchor:'90%',
		allowBlank:true,
		store:GetVendorCatStore,
		valueField:'RowId',
		displayField:'Description',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		disabled:true,
		editable:true
	});
	
	//�˻�
	var ctrlAcctField = new Ext.form.NumberField({
		id:'ctrlAcctField',
		fieldLabel:'�˻�',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//��������
	var bankField = new Ext.form.TextField({
		id:'bankField',
		fieldLabel:'��������',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//ע���ʽ�
	var crAvailField = new Ext.form.NumberField({
		id:'crAvailField',
		fieldLabel:'ע���ʽ�',
		allowBlank:true,
		allowNegative:false,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//�ɹ����
	var feeField = new Ext.form.NumberField({
		id:'feeField',
		fieldLabel:'�ɹ����',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//��ͬ��ֹ����
	var lstPoDate = new Ext.ux.DateField({
		id:'lstPoDate',
		fieldLabel:'���ҵ������',
		allowBlank:true,
		disabled:true,
		disabled:true
	});
	
	//����
	var faxField = new Ext.form.TextField({
		id:'faxField',
		fieldLabel:'����',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//����
	var corporationField = new Ext.form.TextField({
		id:'corporationField',
		fieldLabel:'����(��ϵ��)',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//�������֤
	var presidentField = new Ext.form.TextField({
		id:'presidentField',
		fieldLabel:'�������֤',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//������ϵ�绰
	var presidentTelField = new Ext.form.TextField({
		id:'presidentTelField',
		fieldLabel:'������ϵ�绰',
		allowBlank:true,
		anchor:'90%',
		disabled:true,
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
		allowBlank:true,
		store:stateStore,
		value:'A', // Ĭ��ֵ"ʹ��"
		valueField:'key',
		displayField:'keyValue',
		triggerAction:'all',
		anchor:'90%',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		disabled:true,
		mode:'local'
	});
	
	//���ƹ�Ӧ
	var limitSupplyField = new Ext.form.Checkbox({
		id: 'limitSupplyField',
		fieldLabel:'���ƹ�Ӧ',
		disabled:true,
		allowBlank: true
	});

	var SmsField = new Ext.form.Checkbox({
		id: 'SmsField',
		fieldLabel:'����֪ͨ',
		disabled:true,
		allowBlank: true
	});

	var PurchPlatField = new Ext.form.Checkbox({
		id: 'PurchPlatField',
		fieldLabel:'ƽ̨֪ͨ',
		disabled:true,
		allowBlank: true
	});
	
	//����ִ��
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'����ִ��',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	
	//����ִ����Ч��
	var comLicValidDate = new Ext.ux.DateField({ 
		id:'comLicValidDate',
		fieldLabel:'��Ч��',
		allowBlank:true,
		disabled:true
	});
	//˰��ִ��
	var taxLicField = new Ext.form.TextField({
		id:'taxLicField',
		fieldLabel:'˰��ִ��',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});	
	
	//˰��ִ����Ч��
	var taxLicValidDate = new Ext.ux.DateField({ 
		id:'taxLicValidDate',
		fieldLabel:'��Ч��',
		allowBlank:true,
		disabled:true 
	});
	
	//��������
	var orgCodeField = new Ext.form.TextField({
		id:'orgCodeField',
		fieldLabel:'��������',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	
	//����������Ч��
	var orgCodeValidDate = new Ext.ux.DateField({ 
		id:'orgCodeValidDate',
		fieldLabel:'��Ч��',
		allowBlank:true,
		disabled:true
	});
	
	//ҩƷ��Ӫ���֤
	var drugBusLicField = new Ext.form.TextField({
		id:'drugBusLicField',
		fieldLabel:'ҩƷ��Ӫ���֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//ҩƷ��Ӫ���֤��Ч��
	var drugBusLicValidDate = new Ext.ux.DateField({ 
		id:'drugBusLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true        
	});
	
	//��е��Ӫ���֤
	var insBusLicField = new Ext.form.TextField({
		id:'insBusLicField',
		fieldLabel:'��е��Ӫ���֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//��е��Ӫ���֤��Ч��
	var insBusLicValidDate = new Ext.ux.DateField({ 
		id:'insBusLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,  
		disabled:true       
	});

	//��е�������֤
	var insProLicField = new Ext.form.TextField({
		id:'insProLicField',
		fieldLabel:'��е�������֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//��е�������֤��Ч��
	var insProLicValidDate = new Ext.ux.DateField({ 
		id:'insProLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true
	});
	
	//������ŵ��
	var qualityCommField = new Ext.form.TextField({
		id:'qualityCommField',
		fieldLabel:'������ŵ��',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//������ŵ����Ч��
	var qualityCommValidDate = new Ext.ux.DateField({ 
		id:'qualityCommValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true       
	});
	
	//������Ȩ��
	var agentAuthField = new Ext.form.TextField({
		id:'agentAuthField',
		fieldLabel:'������Ȩ��',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//������Ȩ����Ч��
	var agentAuthValidDate = new Ext.ux.DateField({ 
		id:'agentAuthValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true, 
		disabled:true        
	});
	
	//�ۺ�����ŵ��
	var saleServCommField = new Ext.form.TextField({
		id:'saleServCommField',
		fieldLabel:'�ۺ�����ŵ��',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	
	//����ί����
	var legalCommField = new Ext.form.TextField({
		id:'legalCommField',
		fieldLabel:'����ί����',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//ҩƷ�������֤
	var drugProLicField = new Ext.form.TextField({
		id:'drugProLicField',
		fieldLabel:'ҩƷ�������֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//ҩƷ�������֤��Ч��
	var drugProLicValidDate = new Ext.ux.DateField({
		id:'drugProLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true
	});
	
	//ҩƷע������
	var drugRegLicField = new Ext.form.TextField({
		id:'drugRegLicField',
		fieldLabel:'ҩƷע������',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//ҩƷע��������Ч��
	var drugRegLicValidDate = new Ext.ux.DateField({ 
		id:'drugRegLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true    
	});
	
	//GSP��֤
	var gspLicField = new Ext.form.TextField({
		id:'gspLicField',
		fieldLabel:'GSP��֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//GSP��֤��Ч��
	var gspLicValidDate = new Ext.ux.DateField({ 
		id:'gspLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true, 
		disabled:true      
	});
	 
	//��еע��֤
	var insRegLicField = new Ext.form.TextField({
		id:'insRegLicField',
		fieldLabel:'��еע��֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//��еע��֤��Ч��
	var insRegLicValidDate = new Ext.ux.DateField({ 
		id:'insRegLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true
	});
	
	//����ע��ǼǱ�
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:'����ע��ǼǱ�',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//����ע��ǼǱ���Ч��
	var inletRegLicValidDate = new Ext.ux.DateField({ 
		id:'inletRegLicValidDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		disabled:true   
	});
	
	//����ע��֤
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:'����ע��֤',
		allowBlank:true,
		disabled:true,
		selectOnFocus:true
	});
	//����ע��֤��Ч��
	var inletRLicValidDate = new Ext.ux.DateField({ 
		id:'inletRLicValidDate',
		fieldLabel:'��Ч��',
		allowBlank:true,
		disabled:true
	});

	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'page_delete',
		//height:30,
		//width:70,
		handler : function() {
			win.close();
		}
	});
	
	//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
				xtype : 'fieldset',
				title : '������Ϣ',
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[codeField]},
						{columnWidth:.55,layout:'form',items:[nameField]},
						{columnWidth:.1,layout:'form',items:[closeBT]}						
					]
				},{
					layout : 'column',
					items : [{columnWidth:.35,layout:'form',items:[categoryField]},
						{columnWidth:.45,layout:'form',items:[parField]}			
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[corporationField]},
						{columnWidth:.35,layout:'form',items:[presidentField]},
						{columnWidth:.3,layout:'form',items:[presidentTelField]}						
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[ctrlAcctField]},
						{columnWidth:.35,layout:'form',items:[bankField]},
						{columnWidth:.3,layout:'form',items:[crAvailField]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[lstPoDate]},
						{columnWidth:.65,layout:'form',items:[addressField]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[telField]}, 
						{columnWidth:.35,layout:'form',items:[faxField]}, 
						{columnWidth:.3,layout:'form',items:[limitSupplyField]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.35,layout:'form',items:[feeField]},
						{columnWidth:.2,layout:'form',items:[stateField]},
						{columnWidth:.35,layout:'form',items:[abbrevField]}
					]
				},{
					layout : 'column',
					items : [
						
						{columnWidth:.15,layout:'form',items:[SmsField]},
						{columnWidth:.15,layout:'form',items:[PurchPlatField]}
						
					]
				}]
			},{
				xtype : 'fieldset',
				title : '������Ϣ',
				autoHeight : true,
				items : [{
					layout:'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [comLicField,comLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [taxLicField,taxLicValidDate]}]}   //,taxLicButton,taxLicButtonTP
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [orgCodeField,orgCodeValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [drugBusLicField,drugBusLicValidDate]}]} //,drugBusLicButton,drugBusLicButtonTP
							]
				},{
					layout:'column',
					items : [
					    {columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [insBusLicField,insBusLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [insProLicField,insProLicValidDate]}]}
							]
				},{
					layout : 'column',
					items : [
 						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [qualityCommField,qualityCommValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [agentAuthField,agentAuthValidDate]}]}
							]
				},{
					layout:'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [drugRegLicField,drugRegLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [drugProLicField,drugProLicValidDate]}]}
						]
				},{
					layout : 'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [gspLicField,gspLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [insRegLicField,insRegLicValidDate]}]}					
					]
				},{
					layout:'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [inletRegLicField,inletRegLicValidDate]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [inletRLicField,inletRLicValidDate]}]}
					]
				},{
					layout : 'column',
					items : [
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [saleServCommField]}]},
						{columnWidth:.5,layout:'form',labelWidth:150,items: [{xtype: 'compositefield',items: [legalCommField]}]}
					]
				},{
					autoHeight : true,
					xtype:'fieldset',
					title : 'ҵ��Ա��Ȩ����Ϣ',
					items : [{
						layout : 'column',
						items : [
							{columnWidth:.25,layout:'form',items:[bussPersonField]},
							{columnWidth:.25,layout:'form',items:[validDate]},
							{columnWidth:.4,layout:'form',items:[phoneField]},
							{columnWidth:.3,layout:'form',items:[salesIDField]},
							{columnWidth:.3,layout:'form',items:[emailField]},
							{columnWidth:.4,layout:'form',items:[salesCarrTelField]}
						]
					}]
				}]
			}]
	});

	//��ʼ������
	win = new Ext.Window({
		title:'��Ӧ����Ϣ',
		width:1000,
		height:600,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		closeAction:'hide',
		listeners:{
			'show':function(){
				if (PbVendor!=''){
					SetVendorInfo(PbVendor);
				}
			},
			'close' : function(p){
				win=null;
			}
		}
	});


		win.show();
	//��ʾ��Ӧ����Ϣ
	function SetVendorInfo(rowid){
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {
				Msg.info('error','ʧ�ܣ�');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//vendorPanel.getForm().setValues(jsonData);
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//������Ϣ
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('categoryField').setValue(arr[10]);
					Ext.getCmp('categoryField').setRawValue(arr[11]);
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
					Ext.getCmp('salesIDField').setValue(arr[49]);
					
					addComboData(Ext.getCmp("parField").getStore(),arr[50],arr[51]);
					Ext.getCmp("parField").setValue(arr[50]);
					Ext.getCmp("abbrevField").setValue(arr[52]);
					Ext.getCmp('presidentTelField').setValue(arr[53]);   //���˵绰									
					Ext.getCmp('emailField').setValue(arr[54]);   //����
					Ext.getCmp('salesCarrTelField').setValue(arr[55]); 
					Ext.getCmp('SmsField').setValue(arr[56]=="Y"?true:false);
					Ext.getCmp('PurchPlatField').setValue(arr[57]=="Y"?true:false);
					
				}
			},
			scope: this
		});
	}

	//ȡ�ù�Ӧ�̴�
	function  getVendorDataStr()
	{
		//������Ϣ
		//��Ӧ�̴���
		var code = codeField.getValue();
		//��Ӧ������
		var name = nameField.getValue();
		
		if(code.trim()==""){
			Msg.info("warning","��Ӧ�̴���Ϊ��!");
			return;
		}
		
		if(name.trim()==""){
			Msg.info("warning","��Ӧ������Ϊ��!");
			return;
		}
		
		//���
		var abbrev=abbrevField.getValue();
		
		//��һ����Ӧ��
		var parVendor=parField.getValue();
		
		//��Ӧ�̷���
		var categoryId = categoryField.getValue();
		//����(��ϵ�� )
		var corporation = corporationField.getValue();
		//�������֤
		var president = presidentField.getValue();
		
		var presidentTel=presidentTelField.getValue();
		//�˻�
		var ctrlAcct = ctrlAcctField.getValue();
		//������
		var bankName = bankField.getValue();
		//ע���ʽ�
		var crAvail = crAvailField.getValue();
		if((crAvail!="" && crAvail<1)||crAvail===0){
			Msg.info("warning","ע���ʽ�����Ϊ1Ԫ!");
			return;
		}
		//��ͬ��ֹ����
		var lstPoDate = Ext.getCmp('lstPoDate').getValue();
		if((lstPoDate!="")&&(lstPoDate!=null)){
			lstPoDate = lstPoDate.format(ARG_DATEFORMAT);
		}
		//��ַ
		var address = addressField.getValue();
		//��Ӧ�̵绰
		var tel = telField.getValue();
		//��Ӧ�̴���
		var fax = faxField.getValue();
		//���ƹ�Ӧ
		var isLimitSupply = (limitSupplyField.getValue()==true)?'Y':'N';
		//�ɹ����
		var fee = feeField.getValue();
		//ʹ��״̬
		var state = stateField.getValue();
		
		//������Ϣ
		//����ִ��
		var comLic = comLicField.getValue();
		//����ִ����Ч��
		var comLicValidDate = Ext.getCmp('comLicValidDate').getValue();
		if((comLicValidDate!="")&&(comLicValidDate!=null)){
			comLicValidDate = comLicValidDate.format(ARG_DATEFORMAT);
		}
		//˰��ִ��
		var taxLic = taxLicField.getValue();
		//˰��ִ����Ч��
		var taxLicValidDate = Ext.getCmp('taxLicValidDate').getValue();
		if((taxLicValidDate!="")&&(taxLicValidDate!=null)){
			taxLicValidDate = taxLicValidDate.format(ARG_DATEFORMAT);
		}
		//��������
		var orgCode = orgCodeField.getValue();
		//˰��ִ����Ч��
		var orgCodeValidDate = Ext.getCmp('orgCodeValidDate').getValue();
		if((orgCodeValidDate!="")&&(orgCodeValidDate!=null)){
			orgCodeValidDate = orgCodeValidDate.format(ARG_DATEFORMAT);
		}
		//ҩƷ��Ӫ���֤
		var drugBusLic = drugBusLicField.getValue();
		//ҩƷ��Ӫ���֤��Ч��
		var drugBusLicValidDate = Ext.getCmp('drugBusLicValidDate').getValue();
		if((drugBusLicValidDate!="")&&(drugBusLicValidDate!=null)){
			drugBusLicValidDate = drugBusLicValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//��е��Ӫ���֤
		var insBusLic = insBusLicField.getValue();
		//��е��Ӫ���֤��Ч��
		var insBusLicValidDate = Ext.getCmp('insBusLicValidDate').getValue();
		if((insBusLicValidDate!="")&&(insBusLicValidDate!=null)){
			insBusLicValidDate = insBusLicValidDate.format(ARG_DATEFORMAT);
		}
		//��е�������֤
		var insProLic = insProLicField.getValue();
		//��е�������֤��Ч��
		var insProLicValidDate = Ext.getCmp('insProLicValidDate').getValue();
		if((insProLicValidDate!="")&&(insProLicValidDate!=null)){
			insProLicValidDate = insProLicValidDate.format(ARG_DATEFORMAT);
		}
		//������ŵ��
		var qualityComm = qualityCommField.getValue();
		//������ŵ����Ч��
		var qualityCommValidDate = Ext.getCmp('qualityCommValidDate').getValue();
		if((qualityCommValidDate!="")&&(qualityCommValidDate!=null)){
			qualityCommValidDate = qualityCommValidDate.format(ARG_DATEFORMAT);
		}
		//������Ȩ��
		var agentAuth = agentAuthField.getValue();
		//������Ȩ����Ч��
		var agentAuthValidDate = Ext.getCmp('agentAuthValidDate').getValue();
		if((agentAuthValidDate!="")&&(agentAuthValidDate!=null)){
			agentAuthValidDate = agentAuthValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//�ۺ�����ŵ��
		var saleServComm = saleServCommField.getValue();
		//����ί����
		var legalComm = legalCommField.getValue();
		//ҩƷ�������֤
		var drugProLic = drugProLicField.getValue();
		//ҩƷ�������֤��Ч��
		var drugProLicValidDate = Ext.getCmp('drugProLicValidDate').getValue();
		if((drugProLicValidDate!="")&&(drugProLicValidDate!=null)){
			drugProLicValidDate = drugProLicValidDate.format(ARG_DATEFORMAT);
		}
		//ҩƷע������
		var drugRegLic = drugRegLicField.getValue();
		//ҩƷע��������Ч��
		var drugRegLicValidDate = Ext.getCmp('drugRegLicValidDate').getValue();
		if((drugRegLicValidDate!="")&&(drugRegLicValidDate!=null)){
			drugRegLicValidDate = drugRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//GSP��֤
		var gspLic = gspLicField.getValue();
		//GSP��֤��Ч��
		var gspLicValidDate = Ext.getCmp('gspLicValidDate').getValue();
		if((gspLicValidDate!="")&&(gspLicValidDate!=null)){
			gspLicValidDate = gspLicValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//��еע��֤
		var insRegLic = insRegLicField.getValue();
		//��еע��֤��Ч��
		var insRegLicValidDate = Ext.getCmp('insRegLicValidDate').getValue();
		if((insRegLicValidDate!="")&&(insRegLicValidDate!=null)){
			insRegLicValidDate = insRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//����ע��ǼǱ�
		var inletRegLic = inletRegLicField.getValue();
		//����ע��ǼǱ���Ч��
		var inletRegLicValidDate = Ext.getCmp('inletRegLicValidDate').getValue();
		if((inletRegLicValidDate!="")&&(inletRegLicValidDate!=null)){
			inletRegLicValidDate = inletRegLicValidDate.format(ARG_DATEFORMAT);
		}
		//����ע��֤
		var inletRLic = inletRLicField.getValue();
		//����ע��֤
		var inletRLicValidDate = Ext.getCmp('inletRLicValidDate').getValue();
		if((inletRLicValidDate!="")&&(inletRLicValidDate!=null)){
			inletRLicValidDate = inletRLicValidDate.format(ARG_DATEFORMAT);
		}
		
		
		//ҵ��Ա��Ȩ��Ϣ
		//ҵ��Ա����
		var bussPerson = bussPersonField.getValue();
		//֤����Ч��
		var validDate = Ext.getCmp('validDate').getValue();
		if((validDate!="")&&(validDate!=null)){
			validDate = validDate.format(ARG_DATEFORMAT);
		}
		//ҵ��Ա�绰
		var phone = phoneField.getValue();		
		//ҵ��Ա���֤
		var salseID=salesIDField.getValue();
		var email=emailField.getValue();
		//
		var salesCarrTel=salesCarrTelField.getValue();	
		var Sms = (SmsField.getValue()==true)?'Y':'N';
		var PurchPlat = (PurchPlatField.getValue()==true)?'Y':'N';
		/*
		��Ӧ�̴���^����^�绰^������^�˻�^�ɹ��޶�^����^����^����id^ʹ�ñ�־^����id^ע���ʽ�^��ͬ��ֹ����^��ַ^���ƹ�Ӧ��־^����ִ��^����ִ��Ч��^������Ȩ��^ҩƷ��Ӫ���֤^ҩƷ��Ӫ���֤��Ч��
		^Gsp��֤^Gsp��֤��Ч��^����ע��֤^����ע��֤��Ч��^����ע��ǼǱ�^����ע��ǼǱ���Ч��^��еע��֤^��еע��֤��Ч��^��е��Ӫ���֤^��е��Ӫ���֤��Ч��^��е�������֤^��е�������֤��Ч��
		^��֯��������^��֯������Ч��^�ۺ�����ŵ��^ҩƷ�������֤^ҩƷ�������֤��Ч��^˰��Ǽ�^˰��Ǽ���Ч��^ҩƷע������^ҩƷע��������Ч��^����ί����^������ŵ��^������ŵ����Ч��^������Ȩ����Ч��^ҵ��Ա����^ҵ��Ա��Ȩ����Ч��^ҵ��Ա�绰^ҵ��Ա���֤^������ϵ�绰
		*/
		
		//ƴdata�ַ���
		var data=code+"^"+name+"^"+tel+"^"+bankName+"^"+ctrlAcct+"^"+fee+"^"+fax+"^"+corporation+"^"+president+"^"+state+"^"+categoryId+"^"+crAvail+"^"+lstPoDate+"^"+address+"^"+isLimitSupply
		+"^"+comLic+"^"+comLicValidDate+"^"+agentAuth+"^"+drugBusLic+"^"+drugBusLicValidDate
		+"^"+gspLic+"^"+gspLicValidDate+"^"+inletRLic+"^"+inletRLicValidDate+"^"+inletRegLic+"^"+inletRegLicValidDate
		+"^"+insRegLic+"^"+insRegLicValidDate+"^"+insBusLic+"^"+insBusLicValidDate+"^"+insProLic+"^"+insProLicValidDate
		+"^"+orgCode+"^"+orgCodeValidDate+"^"+saleServComm+"^"+drugProLic+"^"+drugProLicValidDate+"^"+taxLic+"^"+taxLicValidDate
		+"^"+drugRegLic+"^"+drugRegLicValidDate+"^"+legalComm+"^"+qualityComm+"^"+qualityCommValidDate
		+"^"+agentAuthValidDate+"^"+bussPerson+"^"+validDate+"^"+phone+"^"+salseID+"^"+parVendor+"^"+abbrev+"^"+presidentTel+"^"+email+"^"+salesCarrTel+"^"+Sms+"^"+PurchPlat;
		
		return data;
	}
}

function setVendorParam()
{

	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var hospId=session['LOGON.HOSPID'];
	
	var url='dhcstm.apcvendoraction.csp?actiontype=GetVendorParamP&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId+'&HospId='+hospId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);

	if (jsonData.length<0) return ;
	gVendorPara.length=jsonData.length ;
	for (var i=0;i<jsonData.length;i++)
	{
		var ss=jsonData[i];
		gVendorPara[ss.APCode]=ss.APValue ;
	}
}
function getVendorParamValue(apcode)
{
	return gVendorPara[apcode]
}


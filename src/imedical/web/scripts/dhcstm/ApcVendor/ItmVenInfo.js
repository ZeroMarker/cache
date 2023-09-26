
//�����༭����(����)
//rowid :��Ӧ��rowid
var remarkWindow;
var list='';
function CreateEditWin(List){
	list=List;
	if(remarkWindow){
		remarkWindow.show();
		return;
	}
	
	//���̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>���̴���</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'���̴���...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	//��������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>��������</font>',
		allowBlank:false,
		width:150,
		listWidth:150,
		//emptyText:'��������...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	})	
	//���̵�ַ
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'���̵�ַ',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'���̵�ַ...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	//���̵绰
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
		fieldLabel:'���̵绰',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'���̵绰...',
		anchor:'90%',
		regex:/^[^\u4e00-\u9fa5]{0,}$/,
		regexText:'����ȷ�ĵ绰����',
		disabled:true,
		selectOnFocus:true
	});
	
	//�ϼ�����
	var lastPhManfField = new Ext.form.ComboBox({
		id:'lastPhManfField',
		fieldLabel:'�ϼ�����',
		anchor:'90%',
		allowBlank:true,
		store:PhManufacturerStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'�ϼ�����...',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		disabled:true,
		editable:true
	});
	
	//ҩ���������
	var drugProductPermitField = new Ext.form.TextField({
		id:'drugProductPermitField',
		fieldLabel:'ҩ���������',
		width:200,
		listWidth:200,
		//emptyText:'ҩ���������...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//ҩ�����������Ч��
	var drugProductExpDate = new Ext.ux.DateField({ 
		id:'drugProductExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100,  
		disabled:true
	});  
	
	//�����������
	var matProductPermitField = new Ext.form.TextField({
		id:'matProductPermitField',
		fieldLabel:'�����������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�����������...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//�������������Ч��
	var matProductExpDate = new Ext.ux.DateField({ 
		id:'matProductExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100, 
		disabled:true
	});
	
	//����ִ�����
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'����ִ�����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ִ�����...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//����ִ�������Ч��
	var comLicExpDate = new Ext.ux.DateField({ 
		id:'comLicExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100, 
		disabled:true
	});
	//����ע���
	var BusinessRegNoField = new Ext.form.TextField({
		id:'BusinessRegNoField',
		fieldLabel:'����ע���',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ע���...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//����ע�����Ч��
	var BusinessRegExpDate = new Ext.ux.DateField({ 
		id:'BusinessRegExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100, 
		disabled:true
	});
	//��֯��������
	var OrgCodeField = new Ext.form.TextField({
		id:'OrgCodeField',
		fieldLabel:'��֯��������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��֯��������...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
	
	//��֯����������Ч��
	var OrgCodeExpDate = new Ext.ux.DateField({ 
		id:'OrgCodeExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100,  
		disabled:true
	});
	//˰��ǼǺ�
	var TaxRegNoField = new Ext.form.TextField({
		id:'TaxRegNoField',
		fieldLabel:'˰��ǼǺ�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'˰��ǼǺ�...',
		anchor:'90%',
		disabled:true,
		selectOnFocus:true
	});
		//����
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		fieldLabel:'����',
		hideLabel:false,
		allowBlank:false,
		disabled:true,
		checked:true  //Ĭ����"����"״̬
	})
	//������Ϣ
	//�̱�
	var LabelField = new Ext.form.TextField({
		id:'LabelField',
		fieldLabel:'�̱�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�̱�...',
		anchor:'90%',
		selectOnFocus:true
	});
	//ԭ��׼�ĺ�
	var LastTextField = new Ext.form.TextField({
		id:'LastTextField',
		fieldLabel:'ԭ��׼�ĺ�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ԭ��׼�ĺ�...',
		anchor:'90%',
		selectOnFocus:true
	});
	//ҩƷ��׼�ĺţ�ҽ����еע��֤�ţ�
	var NewTextField = new Ext.form.TextField({
		id:'NewTextField',
		fieldLabel:'��׼�ĺ�',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��׼�ĺ�...',
		anchor:'90%',
		selectOnFocus:true
	});
	//��׼�ĺţ�ע��֤�ţ���Ч��
	var TextExpDate = new Ext.ux.DateField({ 
		id:'TextExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100
	});
	//�޸�����
	var UpDate = new Ext.ux.DateField({ 
		id:'UpDate',
		fieldLabel:'�޸�����',  
		allowBlank:true,
		width:298,
		listWidth:298   
	});
	var UpUserFieldStore=new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			                url : DictUrl
								+ 'itmvenaction.csp?actiontype=GroupUser&start=0&limit=999'
					}),
		baseParams:{'GrpDesc':'���ʿ��'},
		reader:new Ext.data.JsonReader({
			totalProperty : "results",
						root : 'rows'
					}, ['Name', 'Rowid'])			
		})
	
       UpUserFieldStore.load();
		// �޸���
	var UpUserField=new Ext.form.ComboBox({
		fieldLabel:'�޸���',
		id:'UpUserField',
		name:'UpUserField',
		anchor : '90%',
		store : UpUserFieldStore,
		disabled:true,
		valueField : 'Rowid',
		displayField : 'Name',
		triggerAction : 'all',
		valueNotFoundText : ''
	});

	//��֤���
	var CertificatField = new Ext.form.TextField({
		id:'CertificatField',
		fieldLabel:'��֤���',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��֤���...',
		anchor:'90%',
		selectOnFocus:true
	});
   //����ע��֤��
	var RegCertNoField = new Ext.form.TextField({
		id:'RegCertNoField',
		fieldLabel:'����ע��֤��',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ע��֤��...',
		anchor:'90%',
		selectOnFocus:true
	});
	//����ע��֤Ч�� 
	var RegCertExpDate = new Ext.ux.DateField({ 
		id:'RegCertExpDate',
		fieldLabel:'��Ч��',  
		allowBlank:true,
		width:100,
		listWidth:100   
	});
	//����

	//��ʼ����Ӱ�ť
	var okButton = new Ext.Toolbar.Button({
		text:'ȷ��',
		handler:function(){	
		  	var ss=getVendorDataStr();
			if (typeof(ss)=='undefined' || ss==""){return;}
			if (list!='') {
				ss=list+'^'+ss;
				//UpdVendorInfo(ss);  //ִ�и���
				InsVendorInfo(ss); 
			}
		}
	});
	
	//��ʼ��ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��',
		handler:function(){
			//alert(Ext.getCmp('codeField').getValue());
			if (remarkWindow){
				remarkWindow.hide();
			}
		}
	});
	
	//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
		labelwidth : 30,
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
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[codeField]},
						{columnWidth:.5,layout:'form',items:[nameField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[drugProductPermitField]},
						{columnWidth:.5,layout:'form',items:[drugProductExpDate ]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[matProductPermitField]},
						{columnWidth:.5,layout:'form',items:[matProductExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[comLicField]},
						{columnWidth:.5,layout:'form',items:[comLicExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[BusinessRegNoField]},  
						{columnWidth:.5,layout:'form',items:[BusinessRegExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[OrgCodeField]},
						{columnWidth:.5,layout:'form',items:[OrgCodeExpDate]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[TaxRegNoField]},  
						{columnWidth:.5,layout:'form',items:[lastPhManfField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[phoneField]},
						{columnWidth:.4,layout:'form',items:[addressField]},
						{columnWidth:.3,layout:'form',items:[activeField]}
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
						{columnWidth:.3,layout:'form',items:[LabelField]},
						{columnWidth:.5,layout:'form',items:[LastTextField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[NewTextField]},
                        {columnWidth:.5,layout:'form',items:[TextExpDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[UpUserField]},
						{columnWidth:.5,layout:'form',items:[CertificatField]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[RegCertNoField]},
						{columnWidth:.5,layout:'form',items:[RegCertExpDate]}
					]
				}]
		}]
	});
	
	
	//��ʼ������
	remarkWindow = new Ext.Window({
		closeAction:'hide',
		title:'���ʳ�����Ϣ',
		width:900,
		height:500,
		minWidth:900,
		minHeight:500,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		buttons:[okButton, cancelButton],
		listeners:{
			'show':function(){
				if (list!=''){
					SetVendorInfo(list);
				}
			},
			'close' : function(p){
				remarkWindow=null;
			}
		}
	});
	remarkWindow.show();

	//��ʾ��Ӧ����Ϣ
	function SetVendorInfo(list){
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=select&list='+list,
			failure: function(result, request) {
				Msg.info("error",'ʧ�ܣ�');
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var value = jsonData.info;
					var arr = value.split("^");
					//������Ϣ
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('drugProductPermitField').setValue(arr[2]);
					Ext.getCmp('drugProductExpDate').setRawValue(arr[3]);
					Ext.getCmp('matProductPermitField').setValue(arr[4]);
					Ext.getCmp('matProductExpDate').setValue(arr[5]);
					Ext.getCmp('comLicField').setValue(arr[6]);
					Ext.getCmp('comLicExpDate').setValue(arr[7]);
					Ext.getCmp('BusinessRegNoField').setValue(arr[8]);
					Ext.getCmp('BusinessRegExpDate').setValue(arr[9]);
					Ext.getCmp('OrgCodeField').setValue(arr[10]);
					Ext.getCmp('OrgCodeExpDate').setValue(arr[11]);
					Ext.getCmp('TaxRegNoField').setValue(arr[12]);
					Ext.getCmp('activeField').setValue(arr[16]=="Y"?true:false);
					addComboData(lastPhManfField.getStore(), arr[13],arr[26]);
					Ext.getCmp('lastPhManfField').setValue(arr[13]);
					Ext.getCmp('phoneField').setValue(arr[14]);
					Ext.getCmp('addressField').setValue(arr[15]);
					//������Ϣ
					Ext.getCmp('LabelField').setValue(arr[17]);
					Ext.getCmp('LastTextField').setValue(arr[18]);
					Ext.getCmp('NewTextField').setValue(arr[19]);
					Ext.getCmp('TextExpDate').setValue(arr[20]);
					Ext.getCmp('UpUserField').setValue(arr[21]);
					Ext.getCmp('UpUserField').setRawValue(arr[22]);
					Ext.getCmp('CertificatField').setValue(arr[23]);
					Ext.getCmp('RegCertNoField').setValue(arr[24]);
					Ext.getCmp('RegCertExpDate').setValue(arr[25]);
				}
			},
			scope: this
		});
	}
	
	//ȡ�ù�Ӧ�̴�
	function  getVendorDataStr(){
		//��������
		var Label=LabelField.getValue();  //�̱� 
		var LastText=LastTextField.getValue(); //ԭ��еע��֤��
		var NewText=NewTextField.getValue();  //��еע��֤�� 
		var TextExpDate = Ext.getCmp('TextExpDate').getValue();  //��Ч��
		if((TextExpDate!="")&&(TextExpDate!=null)){
			TextExpDate = TextExpDate.format(ARG_DATEFORMAT);
		}
		var UpDate = Ext.getCmp('UpDate').getValue();  //�޸�����
		var UpDate="";
		if((UpDate!="")&&(UpDate!=null)){
			UpDate = UpDate.format(ARG_DATEFORMAT);
		}
		//var UpUser=UpUserField.getValue(); // �޸���gUserId
		var UpUser=gUserId;
		var Certificat=CertificatField.getValue(); //��֤���
		var RegCertNo=RegCertNoField.getValue();  //����ע��֤��
		var RegCertExpDate = Ext.getCmp('RegCertExpDate').getValue();  //����ע��֤Ч��
		if((RegCertExpDate!="")&&(RegCertExpDate!=null)){
			RegCertExpDate = RegCertExpDate.format(ARG_DATEFORMAT);
		}
		//ƴdata�ַ���
		var data=Label+"^"+LastText+"^"+NewText+"^"+TextExpDate+"^"+UpDate+"^"+UpUser+"^"+Certificat
		         +"^"+RegCertNo+"^"+RegCertExpDate;
		
		return data;
	}
 
	//���빩Ӧ��
	function InsVendorInfo(data){
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=insert',
			params : {data:data},
			method:'post',
			waitMsg:'������...',
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success", "����ɹ�!");
					remarkWindow.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","���ƺʹ����ظ�!");
					}else if(jsonData.info==-2){
						Msg.info("error","�����ظ�!");
					}else if(jsonData.info==-3){
						Msg.info("error","�����ظ�!");
					}else{
						Msg.info("error", "����ʧ��!");
					}
				}
			},
			scope: this
		});	
	}
}	
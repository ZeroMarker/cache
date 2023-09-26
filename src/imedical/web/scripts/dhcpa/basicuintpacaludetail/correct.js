CorrectFun = function(rowid,unitName,Period,KPIName,actualValue){
	
var UnitField = new Ext.form.TextField({
		id:'UnitField',
		fieldLabel: '��������',
		allowBlank: false,
		width:180,
		disabled:true,
		value:unitName,
		listWidth : 180,
		//emptyText:'����д��������...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(UnitField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){UnitField.focus();}
						Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	
	
var PeriodField = new Ext.form.TextField({
		id:'PeriodField',
		fieldLabel: '�ڼ�',
		allowBlank: false,
		width:180,
		disabled:true,
		value:Period,
		listWidth : 180,
		//emptyText:'����д�ڼ�...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(PeriodField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){PeriodField.focus();}
						Ext.Msg.show({title:'����',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var KpiField = new Ext.form.TextField({
		id:'KpiField',
		fieldLabel: 'ָ������',
		allowBlank: false,
		width:180,
		disabled:true,
		value:KPIName,
		listWidth : 180,
		//emptyText:'����д�ڼ�...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(KpiField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){KpiField.focus();}
						Ext.Msg.show({title:'����',msg:'�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var actualValueField = new Ext.form.TextField({
		id:'actualValueField',
		fieldLabel: 'ʵ��ֵ',
		allowBlank: false,
		width:180,
		listWidth : 180,
		value:actualValue,
		emptyText:'����дʵ��ֵ...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(actualValueField.getValue()!=""){
						CorrectButton.focus();
					}else{
						Handler = function(){actualValueField.focus();}
						Ext.Msg.show({title:'����',msg:'ʵ��ֵ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	var descField = new Ext.form.TextArea({
		id:'descField',
		fieldLabel: '����',
		allowBlank: true,
		width:180,
		listWidth : 180,
		emptyText:'����д����...',
		anchor: '90%',
		selectOnFocus:'true'
	});
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:60,
		items: [
	
			UnitField,
			PeriodField,
			KpiField,
			actualValueField,
			descField
		]
	});
	
	//������Ӱ�ť
	var CorrectButton = new Ext.Toolbar.Button({
		text:'�޸�'
	});
			
	//��Ӵ�����
	var addHandler = function(){
		
		
		var actualValue = actualValueField.getValue();
		var desc = descField.getValue();
		
	
		
		actualValue = trim(actualValue);
		if(actualValue==""){
			Ext.Msg.show({title:'��ʾ',msg:'ʵ��ֵΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		desc = trim(desc);
		if(desc==""){
			Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		
		var data = rowid+"^"+actualValue+"^"+desc;
		
		Ext.Ajax.request({
			url:'dhc.pa.jxbasedataexe.csp?action=correct&data='+data,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'�����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,period:periodValue,periodType:type,dir:'asc',sort:'childSub'}});
				}
				else{
					var message="��������";
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
			scope: this
		});
	}

	//��Ӱ�ť����Ӧ�¼�
	CorrectButton.addListener('click',addHandler,false);

	//����ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});

	//ȡ��������
	var cancelHandler = function(){
		win.close();
	}

	//ȡ����ť����Ӧ�¼�
	cancelButton.addListener('click',cancelHandler,false);

	var win = new Ext.Window({
		title: '�������ݼ�¼',
		width: 415,
		height:280,
		minWidth: 415,
		minHeight: 280,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			CorrectButton,
			cancelButton
		]
	});
	win.show();
}
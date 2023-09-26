addFun = function(locSetField,grid,ds,pagingToolbar){
		var locsetName=Ext.getCmp('locSetField').getRawValue();
		var locsetDr=Ext.getCmp('locSetField').getValue();
	
		var periodField = new Ext.form.NumberField({
			id:'periodField',
			fieldLabel:'��Ч�ڼ�',
			allowBlank:false,
			emptyText:'��Ч�ڼ�...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			allowNegative:false,
			allowDecimals:false,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(periodField.getValue()!=""){
							periodTypeField.focus();
						}else{
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��Ч�ڼ䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var periodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','M-��'],['Q','Q-��'],['H','H-����'],['Y','Y-��']]
		});
		var periodTypeField = new Ext.form.ComboBox({
			id: 'periodTypeField',
			fieldLabel: '�ڼ�����',
			width:220,
			listWidth : 220,
			selectOnFocus: true,
			allowBlank: false,
			store: periodTypeStore,
			anchor: '90%',
			value:'', //Ĭ��ֵ
			valueNotFoundText:'',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'ѡ���ڼ�����...',
			mode: 'local', //����ģʽ
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true
		});
		
		var monthCombo = new Ext.ux.form.LovCombo({
			id:'monthCombo',
			fieldLabel: '�����ڼ�',
			hideOnSelect: false,
			store: new Ext.data.Store({
				autoLoad: true,
				proxy: new Ext.data.HttpProxy({url:'dhc.pa.interperiodexe.csp?action=quotelist&locSetDr='+locsetDr}),
				reader: new Ext.data.JsonReader({
					root: 'rows',
					totalProperty: 'results',
					id: 'rowid'
				},[
					'rowid',
					'name'
				])
			},[
				'rowid', 'name'
			]),
			valueField:'rowid',
			displayField:'name',
			typeAhead: false,
			triggerAction: 'all',
			pageSize:18,
			width:220,
			listWidth:220,
			allowBlank: false,
			disabled:false,
			emptyText:'��ѡ�������ڼ�...',
			editable:false,
			anchor: '90%'
		});
		
		//������ʼʱ��ؼ�
		var startDate = new Ext.form.DateField({
			id:'startDate',
			//format:'Y-m-d',
			fieldLabel:'��ʼʱ��',
			width:220,
			disabled:false,
			emptyText: '��ѡ����ʼʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(startDate.getValue()!=""){
							endDate.focus();
						}else{
							Handler = function(){startDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��ʼʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		//�������ʱ��ؼ�
		var endDate = new Ext.form.DateField({
			id:'endDate',
			//format:'Y-m-d',
			fieldLabel:'����ʱ��',
			width:220,
			disabled:false,
			emptyText: '��ѡ�����ʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(endDate.getValue()!=""){
							remarkField.focus();
						}else{
							Handler = function(){endDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'����ʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var remarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '��ע',
			allowBlank: true,
			width:220,
			listWidth : 220,
			emptyText:'��ע...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		
		if(locsetName=="�ɱ�����ϵͳ"){
			//��ʼ�����
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items:[
					periodField,
					periodTypeField,
					monthCombo,
					remarkField
				]
			});
		}else{
			//��ʼ�����
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items:[
					periodField,
					periodTypeField,
					startDate,
					endDate,
					remarkField
				]
			});
		}
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
			var period = periodField.getRawValue();
			
			if(!judge(period)){
				Ext.Msg.show({title:'��ʾ',msg:'��Ч�ڼ��ʽ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			
			var periodType = periodTypeField.getValue();
			var remark = remarkField.getValue();
		
			var data="";
			//alert(locsetName);
			if(locsetName=="�ɱ�����ϵͳ"){
				var monthDrStr = Ext.getCmp('monthCombo').getValue();
				var arr=monthDrStr.split(",");
				var newMonthDrStr="";
				for(var i=0;i<arr.length;i++){
					if(newMonthDrStr==""){
						newMonthDrStr=arr[i];
					}else{
						newMonthDrStr=newMonthDrStr+"-"+arr[i];
					}
				}
				var corrType="R";
				data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+newMonthDrStr+"^"+corrType;
			}else{
				var startDate = Ext.getCmp('startDate').getValue();
				if(startDate!=""){
					startDate = startDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				var endDate = Ext.getCmp('endDate').getValue();
				if(endDate!=""){
					endDate = endDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if(checkDate(startDate,endDate)){
					var corrType="I";
					data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+startDate+"^"+endDate+"^"+corrType;
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ���ڴ��ڽ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
			}
			
			Ext.Ajax.request({
				url: '../csp/dhc.pa.interperiodexe.csp?action=add&data='+encodeURIComponent(data),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,locSetDr:locsetDr}});
					}else{
						if(jsonData.info=='RepRecord'){
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'�˼�¼�Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='dataEmpt'){
							Handler = function(){periodField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��¼Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				},
				scope: this
			});
		}
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '��ӽӿ��ڼ��¼',
			width: 343,
			height:220,
			minWidth: 343, 
			minHeight: 220,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//������ʾ
		addwin.show();
		
}
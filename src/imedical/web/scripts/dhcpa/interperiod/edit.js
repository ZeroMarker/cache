editFun = function(locSetField,grid,ds,pagingToolbar){
		var rowObj=PeriodGrid.getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
	

		var locsetDr=Ext.getCmp('locSetField').getValue();
		var locsetName=Ext.getCmp('locSetField').getRawValue();
	
		var PeriodField = new Ext.form.NumberField({
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
			name:'period',
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
		
		var PeriodTypeStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data:[['M','M-��'],['Q','Q-��'],['H','H-����'],['Y','Y-��']]
		});
		var PeriodTypeField = new Ext.form.ComboBox({
			id: 'PeriodTypeField',
			fieldLabel: '�ڼ�����',
			width:220,
			listWidth : 220,
			selectOnFocus: true,
			allowBlank: false,
			store: PeriodTypeStore,
			anchor: '90%',
			value:'', //Ĭ��ֵ
			valueNotFoundText:rowObj[0].get('periodTypeName'),
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
		
		var MonthCombo = new Ext.ux.form.LovCombo({
			id:'MonthCombo',
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
			emptyText:'��ѡ�������ڼ�...',
			editable:false,
			anchor: '90%'
		});
		
		var StartDate = new Ext.form.DateField({
			id:'StartDate',
			//format:'Y-m-d',
			fieldLabel:'��ʼʱ��',
			width:220,
			emptyText: '��ѡ����ʼʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(StartDate.getValue()!=""){
							EndDate.focus();
						}else{
							Handler = function(){StartDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��ʼʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var EndDate = new Ext.form.DateField({
			id:'EndDate',
			//format:'Y-m-d',
			fieldLabel:'����ʱ��',
			width:220,
			emptyText: '��ѡ�����ʱ��...',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(EndDate.getValue()!=""){
							remarkField.focus();
						}else{
							Handler = function(){EndDate.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'����ʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				}
			}
		});
		
		var RemarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '��ע',
			allowBlank: true,
			width:220,
			listWidth : 220,
			emptyText:'��ע...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'remark',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
		
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '��Ч��־:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
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
					PeriodField,
					PeriodTypeField,
					MonthCombo,
					RemarkField,
					activeField
				]
			});
			formPanel.on('afterlayout', function(panel, layout){
				this.getForm().loadRecord(rowObj[0]);
				PeriodTypeField.setValue(rowObj[0].get('periodType'));
				Ext.getCmp('MonthCombo').setValue("");
			});
		}else{
			//��ʼ�����
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items:[
					PeriodField,
					PeriodTypeField,
					StartDate,
					EndDate,
					RemarkField,
					activeField
				]
			});
			formPanel.on('afterlayout', function(panel, layout){
				this.getForm().loadRecord(rowObj[0]);
				PeriodTypeField.setValue(rowObj[0].get('periodType'));
				Ext.getCmp('StartDate').setRawValue(rowObj[0].get("startDate"));
				Ext.getCmp('EndDate').setRawValue(rowObj[0].get("endDate"));
			});
		}
		
		
		
		editButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		editHandler = function(){
			var period = PeriodField.getRawValue();
			
			if(!judge(period)){
				Ext.Msg.show({title:'��ʾ',msg:'��Ч�ڼ��ʽ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				return false;
			}
			
			var periodType = PeriodTypeField.getValue();
			var remark = RemarkField.getValue();
			var active = (activeField.getValue()==true)?'Y':'N';
		
			var data="";
			if(locsetName=="�ɱ�����ϵͳ"){
				var monthDrStr = Ext.getCmp('MonthCombo').getValue();
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
				data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+active+"^"+newMonthDrStr+"^"+corrType;
			}else{
				var startDate = Ext.getCmp('StartDate').getValue();
				if(startDate!=""){
					startDate = startDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				var endDate = Ext.getCmp('EndDate').getValue();
				if(endDate!=""){
					endDate = endDate.format('Y-m-d');
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
				if(checkDate(startDate,endDate)){
					var corrType="I";
					data=locsetDr+"^"+period+"^"+periodType+"^"+remark+"^"+active+"^"+startDate+"^"+endDate+"^"+corrType;
				}else{
					Ext.Msg.show({title:'��ʾ',msg:'��ʼ���ڴ��ڽ�������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return false;
				}
			}
			
			Ext.Ajax.request({
				url: '../csp/dhc.pa.interperiodexe.csp?action=edit&rowid='+rowid+'&data='+encodeURIComponent(data),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,locSetDr:locsetDr}});
						editwin.close();
					}else{
						if(jsonData.info=='RepRecord'){
							Handler = function(){PeriodField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'�˼�¼�Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='EmptyRowid'){
							Handler = function(){PeriodField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'rowid��ʧ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='EmptyData'){
							Handler = function(){PeriodField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'��¼Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
					}
				},
				scope: this
			});
		}
	
		editButton.addListener('click',editHandler,false);
	
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		cancelHandler = function(){
			editwin.close();
		}
	
		cancelButton.addListener('click',cancelHandler,false);
	
		editwin = new Ext.Window({
			title: '�޸Ľӿ��ڼ��¼',
			width: 343,
			height:250,
			minWidth: 343, 
			minHeight: 250,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		editwin.show();
		
}
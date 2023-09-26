edit=function(){

		//���岢��ʼ���ж���
		//var rowObj=KPITargetTab.getSelections();
		var rowObj=KPITargetTab.getSelectionModel().getSelections();
		console.log(rowObj);
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		
	var unitFields = new Ext.form.ComboBox({
		id: 'unitField',
		fieldLabel: 'ָ������',
		anchor: '90%',
		allowBlank: false,
		store: KPIIndexDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ��ָ��...',
		name: 'unitField',
		minChars:1,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});	
/*
		var targetNameField = new Ext.form.ComboBox({
			id:'targetNameField',
			fieldLabel: 'Ŀ����������',
			editable:false,
			anchor: '90%',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','ͬ�ھ�ֵ'],['2','��ƽ��']]
			}),
			listeners :{
				select :function(field,e){
						if(targetNameField.getValue() =="1"){
							targetCodeField.setValue(1)
						}
						if(targetNameField.getValue() =="2"){
							targetCodeField.setValue(2)
						}
	
				}
			}		
		});
	
	*/
		var targetNameField=new Ext.form.RadioGroup({
			name:'targetNameField',
			fieldLabel:'Ŀ����������',
			//columns: 4,
			items:[{
				boxLabel:'ͬ�ھ�ֵ',
				inputValue:'1',
				name:'targetNameField',
				style:'height:14px;',
				checked:true
			},{
				boxLabel:'��ƽ��',
				inputValue:'2',
				style:'height:14px;',
				name:'targetNameField'
			}],
			listeners :{
				change :function(radioGroupObj,checkedObj){
					//console.log(checkedObj);
					targetCodeField.setValue(checkedObj.inputValue);
				}
			}		
		});
		var targetCodeField = new Ext.form.TextField({
			id:'targetCodeField',
			fieldLabel: 'Ŀ��������',
			allowBlank: false,
			width:220,
			listWidth : 220,
			emptyText:'Ŀ��������...',
			anchor: '90%',
			disabled:true
			
		});
		var coefficientField = new Ext.form.NumberField({
			id:'coefficientField',
			fieldLabel:'����',
			allowBlank:false,
			emptyText:'����...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			allowNegative:false,
			allowDecimals:false,
			name:'coefficient',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(coefficientField.getValue()!=""){
							changeNumField.focus();
						}else{
							Handler = function(){coefficientField.focus();}
							Ext.Msg.show({title:'����',msg:'��������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var changeNumField = new Ext.form.TextField({
			id:'changeNumField',
			fieldLabel: '������',
			width:180,
			listWidth : 180,
			emptyText:'������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'changeNum',
			regex:/^(-)?[0-9]\.[0-9]{1,3}$/,
			regexText:'������С��',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		//���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				unitFields,
				targetNameField,
				targetCodeField,
				coefficientField,
				changeNumField
			]
		});
	
		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			targetNameField.setValue(rowObj[0].get("targetCode"));
			targetCodeField.setValue(rowObj[0].get("targetCode"));
			unitFields.setValue(rowObj[0].get("kpiDr"));
			//alert(rowObj[0].get("kpiDr"));
		});
		
		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){
			var kpiDr = unitFields.getValue();
			var kpiname = unitFields.getRawValue();
			
			if(kpiDr==kpiname){
				kpiDr="";
				}
			
			//var targetName = targetNameField.getValue();
			var targetName = formPanel.getForm().findField('targetNameField').getValue().boxLabel;
			var targetNamecode = targetNameField.getRawValue();
			if(targetName==targetNamecode){
				targetName="";
				}
			var targetCode = targetCodeField.getValue();
			var coefficient = coefficientField.getValue();
			var changeNum = changeNumField.getValue();
			kpiDr = trim(kpiDr);
			targetName = trim(targetName);
			targetCode = trim(targetCode);
		
			if(targetCode==""){
				Ext.Msg.show({title:'����',msg:'Ŀ��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(changeNumField.isValid()==false){
				Ext.Msg.show({title:'����',msg:'�����ʸ�ʽ����:Ӧ����С��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: '../csp/dhc.pa.nYearKPITargetexe.csp?action=edit&rowid='+rowid+'&kpiDr='+kpiDr+'&targetName='+targetName+'&targetCode='+targetCode+'&coefficient='+coefficient+'&changeNum='+changeNum,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){unitField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						KPITargetTabDs.load({params:{start:0,limit:KPITargetTabPagingToolbar.pageSize}});
						editwin.close();
					}
						if(jsonData.info=='RepkpiDr'){
							Handler = function(){targetCodeField.focus();}
							Ext.Msg.show({title:'����',msg:'ָ���Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						
					
				},
				scope: this
			});
		}
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ���޸�'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸�Ŀ������¼',
			width: 380,
			height:260,
			minWidth: 380, 
			minHeight: 260,
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
	
		//������ʾ
		editwin.show();
}

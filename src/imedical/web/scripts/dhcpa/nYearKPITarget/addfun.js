add=function(){
	var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: 'ָ������',
	anchor: '90%',
	//allowBlank: false,
	store: KPIIndexDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ָ��...',
	name: 'unitField',
	minChars: 1,
	//pageSize: 10,
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
				'select' :function(field,e){
					
					if(targetNameField.getValue() =="1"){
						targetCodeField.setValue(1);
						coefficientField.focus();
					}
					if(targetNameField.getValue() =="2"){
						targetCodeField.setValue(2);
						coefficientField.focus();
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
			fieldLabel:'Ŀ�����ʹ���',
			allowBlank:false,
			emptyText:'Ŀ�����͵Ĵ���...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			disabled:true,
			value:"1"
			
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
			emptyText:'������С��',
			anchor: '90%',
			selectOnFocus:'true',
			regex:/^(-)?[0-9]\.[0-9]{1,3}$/,
			regexText:'������С��',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		
		//��ʼ�����
		formPanels = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				unitField,
				targetNameField,
				targetCodeField,
				coefficientField,
				changeNumField
			]
		});
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
			var kpiDr = unitField.getValue();
			var targetName = formPanels.getForm().findField('targetNameField').getValue().boxLabel;;
			//alert(targetName);
			var targetCode = targetCodeField.getValue();
			var coefficient = coefficientField.getValue();
			var changeNum = changeNumField.getValue();
			kpiDr = trim(kpiDr);
			targetName = trim(targetName);
			targetCode = trim(targetCode);
			if(kpiDr==""){
				Ext.Msg.show({title:'����',msg:'ָ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(targetName==""){
				Ext.Msg.show({title:'����',msg:'Ŀ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(coefficient==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(changeNumField.isValid()==false){
				Ext.Msg.show({title:'����',msg:'�����ʸ�ʽ����:Ӧ����С��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			//alert('code='+code+'&name='+name+'&order='+order+'&appSysDr='+appSysDr+'&desc='+desc);
			Ext.Ajax.request({
				url: '../csp/dhc.pa.nYearKPITargetexe.csp?action=add&kpiDr='+kpiDr+'&targetName='+targetName+'&targetCode='+targetCode+'&coefficient='+coefficient+'&changeNum='+changeNum,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){unitField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){unitField.focus();}
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						KPITargetTabDs.load({params:{start:0,limit:KPITargetTabPagingToolbar.pageSize}});
					}else{
						if(jsonData.info=='RepkpiDr'){
							Handler = function(){targetCodeField.focus();}
							Ext.Msg.show({title:'����',msg:'��ָ���Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			addwins.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwins = new Ext.Window({
			title: '���Ŀ������¼',
			width: 380,
			height:250,
			minWidth: 380, 
			minHeight: 250,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanels,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//������ʾ
		addwins.show();
	
};
//��Ӻ���
addFun = function(node){
	if(node!=null){
		var end = node.attributes.isEnd;
		if(end=="Y"){
			Ext.Msg.show({title:'��ʾ',msg:'ĩ�˲�������ӽڵ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//��ĩ�˽ڵ�,�������
			var nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: 'ָ������',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'��ָ������...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(nameField.getValue()!=""){
								codeField.focus();
							}else{
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'����',msg:'ָ�����Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var codeField = new Ext.form.TextField({
				id:'codeField',
				fieldLabel: 'ָ�����',
				allowBlank: true,
				width:180,
				listWidth : 180,
				emptyText:'��ָ�����...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							pyField.focus();
						}
					}
				}
			});
			
			var pyField = new Ext.form.TextField({
				id:'pyField',
				fieldLabel: 'ƴ �� ��',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'����дƴ����...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							dimTypeField.focus();
						}
					}
				}
			});
			
			var dimTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			dimTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=dimtype&str='+Ext.getCmp('dimTypeField').getRawValue(),method:'POST'})
			});

			var dimTypeField = new Ext.form.ComboBox({
				id: 'dimTypeField',
				fieldLabel: 'ά�����',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: dimTypeDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'��ѡ��ά�����...',
				name: 'dimTypeField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				//disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(dimTypeField.getValue()!=""){
								targetField.focus();
							}else{
								Handler = function(){dimTypeField.focus();}
								Ext.Msg.show({title:'����',msg:'ά�������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var targetField = new Ext.form.TextField({
				id:'targetField',
				fieldLabel: '����Ŀ��',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'����д����Ŀ��...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							descField.focus();
						}
					}
				}
			});
			
			var descField = new Ext.form.TextField({
				id:'descField',
				fieldLabel: 'ָ������',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'����дָ������...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							calUnitField.focus();
						}
					}
				}
			});
			
			var calUnitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			calUnitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=calunit&str='+Ext.getCmp('calUnitField').getRawValue(),method:'POST'})
			});

			var calUnitField = new Ext.form.ComboBox({
				id: 'calUnitField',
				fieldLabel: '������λ',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: calUnitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'��ѡ�������λ...',
				name: 'calUnitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(calUnitField.getValue()!=""){
								extreMumField.focus();
							}else{
								Handler = function(){calUnitField.focus();}
								Ext.Msg.show({title:'����',msg:'������λ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});

			var extreMumStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["H",'����'],["M",'����'],["L",'����']]
			});
			var extreMumField = new Ext.form.ComboBox({
				id: 'extreMumField',
				fieldLabel: '��   ֵ',
				listWidth : 285,
				selectOnFocus: true,
				allowBlank: false,
				store: extreMumStore,
				anchor: '90%',
				value:"", //Ĭ��ֵ
				valueNotFoundText:'',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'ѡ��ֵ...',
				mode: 'local', //����ģʽ
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true,
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							expreField.focus();
						}
					}
				}
			});
			
			expreField = new Ext.form.TextField({
				id:'expreField',
				fieldLabel: '���㹫ʽ',
				allowBlank: false,
				width:100,
				listWidth : 100,
				emptyText:'��༭���㹫ʽ...',
				anchor: '90%',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				itemCls:'sex-female', //���󸡶�,����ؼ�����
				clearCls:'allow-float', //�������߸���
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							expreDescField.focus();
						}
					}
				}
			});
			
			var editorbutton = new Ext.Toolbar.Button({
				text:'�༭',
				itemCls:'age-field',
				handler:function(){
					formula(node,1);
				}
			});
			
			expreDescField = new Ext.form.TextField({
				id:'expreDescField',
				fieldLabel: '��ʽ����',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'����д��ʽ����...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							colTypeStore.focus();
						}
					}
				}
			});
			
			var colTypeStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'¼��'],["2",'����'],["3",'��ʵ��ֵ'],["4",'�ɼ�']]
			});
			var colTypeField = new Ext.form.ComboBox({
				id: 'colTypeField',
				fieldLabel: '�ռ���ʽ',
				listWidth : 285,
				selectOnFocus: true,
				allowBlank: false,
				store: colTypeStore,
				anchor: '90%',
				value:"1", //Ĭ��ֵ
				valueNotFoundText:'¼��',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'ѡ���ռ���ʽ...',
				mode: 'local', //����ģʽ
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			
			var scoreMethodStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["I",'���䷨'],["C",'�ȽϷ�'],["D",'�۷ַ�'],["A",'�ӷַ�'],["M",'Ŀ����շ�']]
			});
			var scoreMethodField = new Ext.form.ComboBox({
				id: 'scoreMethodField',
				fieldLabel: '���ַ���',
				listWidth : 285,
				selectOnFocus: true,
				allowBlank: false,
				store: scoreMethodStore,
				anchor: '90%',
				value:"I", //Ĭ��ֵ
				valueNotFoundText:'���䷨',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'ѡ�����ַ���...',
				mode: 'local', //����ģʽ
				editable:false,
				pageSize: 10,
				//disabled:true,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
////////////////////////�жϼӷַ��۷ַ����㷽ʽ////////////////////////			
		scoreMethodField.on('select',function(cmb,rec,id){
	
		if(cmb.getValue()=="D"||(cmb.getValue()=="A"))
		{
			calculationField.enable();
		
		}
		else
		{
			calculationField.setValue("");
			calculationField.disable();
		
		}
	
	});
			
			var calculationDs = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'�����ʼ���'],["2",'������']]
			});
			var calculationField = new Ext.form.ComboBox({
				id: 'calculationField',
				fieldLabel: '���㷽ʽ(�۷ַ�)',
				listWidth : 285,
				selectOnFocus: true,
				//allowBlank: false,
				store: calculationDs,
				anchor: '90%',
				//value:"1", //Ĭ��ֵ
				
				displayField: 'keyValue',
				disabled:true,
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'���㷽ʽ...',
				mode: 'local', //����ģʽ
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			
		
//////////////////////�ж�ѡ�������ʱ��ֵ������///////////////////////////////////

calculationField.on('select',function(cmb,rec,id){
	
		if(cmb.getValue()=="2")
		{
			extreMumField.setValue("");
			extreMumField.disable();
		
		
		}
		
		
	
	});		
			
////////////////////////////////////////////////////////////			
			var colDeptDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			colDeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=coldept&str='+Ext.getCmp('colDeptField').getRawValue(),method:'POST'})
			});

			var colDeptField = new Ext.form.ComboBox({
				id: 'colDeptField',
				fieldLabel: '�ռ�����',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: colDeptDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'��ѡ���ռ�����...',
				name: 'colDeptField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(colDeptField.getValue()!=""){
								dataSourceField.focus();
							}else{
								Handler = function(){colDeptField.focus();}
								Ext.Msg.show({title:'����',msg:'�ռ����Ų���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var dataSourceField = new Ext.form.TextField({
				id:'dataSourceField',
				fieldLabel: '������Դ',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'����д������Դ...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isHospKPIField.focus();
						}
					}
				}
			});
			
			var isHospKPIField = new Ext.form.Checkbox({
				id: 'isHospKPIField',
				fieldLabel:'ҽԺ KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isDeptKPIField.focus();
						}
					}
				}
			});
			
			var isDeptKPIField = new Ext.form.Checkbox({
				id: 'isDeptKPIField',
				fieldLabel:'���� KPI',
				clearCls:'stop-float',
				hideLabel:false,
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isMedKPIField.focus();
						}
					}
				}
			});
			
			var isMedKPIField = new Ext.form.Checkbox({
				id: 'isMedKPIField',
				fieldLabel:'ҽ�� KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isNurKPIField.focus();
						}
					}
				}
			});
			
			var isNurKPIField = new Ext.form.Checkbox({
				id: 'isNurKPIField',
				fieldLabel:'���� KPI',
				clearCls:'stop-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isPostKPIField.focus();
						}
					}
				}
			});
			
			var isPostKPIField = new Ext.form.Checkbox({
				id: 'isPostKPIField',
				fieldLabel:'��λ KPI',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isStopField.focus();
						}
					}
				}
			});
			
			var isStopField = new Ext.form.Checkbox({
				id: 'isStopField',
				fieldLabel:'�Ƿ�ͣ��',
				itemCls:'float-left',
				clearCls:'allow-float',
				hideLabel:false,
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isEndField.focus();
						}
					}
				}
			});
			
			var isEndField = new Ext.form.Checkbox({
				id: 'isEndField',
				fieldLabel:'ĩ�˱�־',
				allowBlank: false,
				clearCls:'stop-float',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							orderField.focus();
						}
					},
					'check':function(checked){
                        if(checked.checked){
							//dimTypeField.enable();
							//scoreMethodField.enable();
							extreMumField.enable();
							calUnitField.enable();
							colDeptField.enable();
                        }else{
                           // dimTypeField.disable();
							//scoreMethodField.disable();
							extreMumField.disable();
							calUnitField.disable();
							colDeptField.disable();
                        }
                    }
				}
			});
			
			var orderField = new Ext.form.NumberField({
				id:'orderField',
				fieldLabel: '˳   ��',
				allowBlank: false,
				minValue:0,
				selectOnFocus: true,
				emptyText:'˳��...',
				anchor: '90%',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isKPIField.focus();
						}
					}
				}
			});
			
			var isKPIField = new Ext.form.Checkbox({
				id: 'isKPIField',
				fieldLabel:'KPI ָ��',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							addButton.focus();
						}
					}
				}
			});
			
			//��ĩ�˱�־Ϊ"Y"��ʱ��,����ʾ����ά�Ⱥ����ַ����ؼ�
			
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items: [
					nameField,
					codeField,
					pyField,
					dimTypeField,
					targetField,
					descField,
					calUnitField,
					expreField,
					editorbutton,
					expreDescField,
					colTypeField,
					scoreMethodField,
					
					calculationField,
	
					extreMumField,
					colDeptField,
					dataSourceField,
					//isHospKPIField,
					isDeptKPIField,
					//isMedKPIField,
					//isNurKPIField,
					//isPostKPIField,
					isStopField,
					isEndField,
					orderField,
					isKPIField
				]
			});	
			
			
			
			//������Ӱ�ť
			var addButton = new Ext.Toolbar.Button({
				text:'���'
			});
			
			//��Ӵ�����
			var addHandler = function(){
				
				var name = nameField.getValue();
				var code = codeField.getValue();
				var py = pyField.getValue();
				var dimTypeDr = Ext.getCmp('dimTypeField').getValue();
				var target = targetField.getValue();
				var desc = descField.getValue();
				var calUnitDr = Ext.getCmp('calUnitField').getValue();
				var extreMum = Ext.getCmp('extreMumField').getValue();
				var expre = encodeURIComponent(Ext.encode(globalStr3));
				var expreDesc = expreDescField.getValue();
				var colTypeDr = Ext.getCmp('colTypeField').getValue();
				var scoreMethodCode = Ext.getCmp('scoreMethodField').getValue();
				var colDeptDr = Ext.getCmp('colDeptField').getValue();
				var dataSource = dataSourceField.getValue();
				var isHospKPI = (isHospKPIField.getValue()==true)?'Y':'N';
				var isDeptKPI = (isDeptKPIField.getValue()==true)?'Y':'N';
				var isMedKPI = (isMedKPIField.getValue()==true)?'Y':'N';
				var isNurKPI = (isNurKPIField.getValue()==true)?'Y':'N';
				var isPostKPI = (isPostKPIField.getValue()==true)?'Y':'N';
				var parent = 0;
				var level = 0;
				if(node.attributes.id!="roo"){
					parent = node.attributes.id;
					level = node.attributes.level;
				}
				var isStop = (isStopField.getValue()==true)?'Y':'N';
				var isEnd = (isEndField.getValue()==true)?'Y':'N';
				
				//���㷽ʽ
				var calculation = calculationField.getValue();
				
				if(isEnd=="Y"){
					dimTypeDr = trim(dimTypeDr);
					if(dimTypeDr==""){
						Ext.Msg.show({title:'��ʾ',msg:'ά��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
						return false;
					};
					scoreMethodCode = trim(scoreMethodCode);
					if(scoreMethodCode==""){
						Ext.Msg.show({title:'��ʾ',msg:'���ַ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
						return false;
					};
					calUnitDr = trim(calUnitDr);
					if(calUnitDr==""){
						Ext.Msg.show({title:'��ʾ',msg:'������λΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
						return false;
					};
					
					/**
					//["I",'���䷨'],["C",'�ȽϷ�'],["D",'�۷ַ�'],["A",'�ӷַ�'],["M",'Ŀ����շ�']
					if((scoreMethodCode=="I")||(scoreMethodCode=="A")||(scoreMethodCode=="D")){
						extreMum = trim(extreMum);
						if(extreMum==""){
							Ext.Msg.show({title:'��ʾ',msg:'��ֵΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							return false;
						};
					}else{
						extreMum="";
					}
					**/
					//�ж����ַ���Ϊ  �ӷַ����߿۷ַ�  ���㷽ʽ �Ƿ�Ϊ��
					if(scoreMethodCode=="D"){
						if(calculation==""){
							
								Ext.Msg.show({title:'��ʾ',msg:'���㷽ʽΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
								return false;
						}
					}
					
				}else{
					//dimTypeDr="";
					//scoreMethodCode="";
					extreMum="";
					calUnitDr="";
				}
				var order = orderField.getValue();
				var isKPI = (isKPIField.getValue()==true)?'Y':'N';
				name = trim(name);
				code = trim(code);
				if(name==""){
					Ext.Msg.show({title:'��ʾ',msg:'ָ������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				};
				var data = name+"^"+py+"^"+dimTypeDr+"^"+target+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+isHospKPI+"^"+isDeptKPI+"^"+isMedKPI+"^"+isNurKPI+"^"+isPostKPI+"^"+parent+"^"+level+"^"+isStop+"^"+isEnd+"^"+order+"^"+isKPI+"^"+code+"^"+calculation;
				
				Ext.Ajax.request({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=add&data='+data,
					waitMsg:'�����..',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							Ext.getCmp('detailReport').getNodeById(node.attributes.id).reload();
						}else{
							if(jsonData.info=='RepName'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'�����ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='dataEmpt'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='ParamErr'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'���������д�,���޸Ĳ�����ָ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
							if(jsonData.info=='null'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'����ǰ��ӹ���������,û���ϼ��ڵ�ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
						}
					},
					scope: this
				});
			}

			//��Ӱ�ť����Ӧ�¼�
			addButton.addListener('click',addHandler,false);

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
				title: '���ָ���¼����',
				width: 420,
				height:585,
				minWidth: 420,
				minHeight: 585,
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
			win.show();
		}
	}else{
		Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ����ӽڵ�ļ�¼!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
	}
};
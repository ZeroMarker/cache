//�޸ĺ���
updateFun = function(node){
	if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ�޸ĵ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻�����޸�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//ȡ������¼��rowid
			var rowid = node.attributes.id;
			var name = node.attributes.name;
			var code = node.attributes.code;
			var unit = node.attributes.unit;
			var type = node.attributes.type;
			var desc = node.attributes.desc;
			var isend = node.attributes.isend;
			if(isend=="Y"){
				var isend="��";
			}else{
				var isend="��";
			}
		
			var rateField = new Ext.form.TextField({
				id:'rateField',
				fieldLabel: '�۷�ϵ��',
				allowBlank: false,
				width:150,
				listWidth : 150,
				emptyText:'�����ÿ۷�ϵ��...',
				selectOnFocus:'true'
				
			});
			
			

				
			formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				//region:'center',
				frame:true,
				labelWidth: 60,
				items: [
					rateField			
				]
			});	
		
			/*formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				NameField.setValue(node.attributes.name);
				CodeField.setValue(node.attributes.code);
				PYField.setValue(node.attributes.py);
				DimTypeField.setValue(node.attributes.dimTypeDr);
				TargetField.setValue(node.attributes.target);
				DescField.setValue(node.attributes.desc);
				CalUnitField.setValue(node.attributes.calUnitDr);
				ExtreMumField.setValue(node.attributes.extreMum);
				expreField.setValue(node.attributes.expName);
				expreDescField.setValue(node.attributes.expDesc);
				ColTypeField.setValue(node.attributes.colTypeDr);
				ScoreMethodField.setValue(node.attributes.scoreMethodCode);
				ColDeptField.setValue(node.attributes.colDeptDr);
				DataSourceField.setValue(node.attributes.dataSource);
				OrderField.setValue(node.attributes.order);
				globalStr3=node.attributes.expression;	
				calculationField.setValue(node.attributes.calculationDr);			
			});	*/
			
			editButton = new Ext.Toolbar.Button({
				text:'�޸�'
			});

			editHandler = function(){
				var rowid = node.attributes.id;
				var newrate = rateField.getValue();
				/*var data =code+"^"+name+"^"+py+"^"+dimTypeDr+"^"+target+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+IsHospKPI+"^"+IsDeptKPI+"^"+IsMedKPI+"^"+IsNurKPI+"^"+IsPostKPI+"^"+parent+"^"+level+"^"+IsStop+"^"+IsEnd+"^"+order+"^"+IsKPI+"^"+calculation;
				alert(data);
				data = trim(data);
				if(data==""){
					Ext.Msg.show({title:'��ʾ',msg:'������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};*/
		
				Ext.Ajax.request({
					url: '../csp/dhc.pa.Selfmanageexe.csp?action=Setdeductpoints&rowid='+rowid+'&newrate='+newrate,
					waitMsg: '�޸���...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
							//Ext.getCmp('detailReport').getNodeById(node.attributes.parent).reload();
							var path = node.getPath('id'); 
							Ext.getCmp('detailReport').root.reload();
							Ext.getCmp('detailReport').expandPath(path);
							window.close();
							/*var path = node.getPath('id');  
    						detailReport.getLoader().load(detailReport.getRootNode(),function(treeNode) {  
                    			detailReport.expandPath(path, 'id', function(bSucess, oLastNode) {  
                                	detailReport.getSelectionModel().select(oLastNode);  
                            	});  
                			}, this);չ����ĳһ��ڵ㣬��expandPathЧ����ͬ*/
							
						}else{
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
						}
						
						
						
					},
					scope: this
				});
			};
	
			editButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'�˳�'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '���ÿ۷�ϵ��',
				width: 300,
				height:120,
				minWidth: 300,
				minHeight: 120,
				layout: 'fit',
				plain:true,
				modal:true,
				bodyStyle:'padding:7px;',
				buttonAlign:'center',
				items: formPanel,
				buttons:[editButton,cancel]
			});
			window.show();
		}
	}
};
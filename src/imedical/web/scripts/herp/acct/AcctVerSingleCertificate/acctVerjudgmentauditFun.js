verifyauditFun = function(vercode,userdr) {
		//alert(AdjustNo+"^"+objdeptdr)

		var userdr = session['LOGON.USERID'];
		var projUrl  = 'herp.acct.acctversinglecertifexe.csp'

			var CheckResultField = new Ext.form.ComboBox({												
				fieldLabel: '�������',
				width:500,
				anchor: '100%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', 'ͨ��'], ['0', '��ͨ��']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
				//disabled:true
			});	
			
		
//////////////// ���ı��� ////////////////////
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
				anchor: '100%',
				fieldLabel : '�������',
				allowBlank :false,
				selectOnFocus:'true',
				emptyText : '����д�����������(��ͨ�������ֲ�����8��)'
			});

/////////////// ����˵�����ı��� /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
				title : '�������',
				height : 110,
				labelSeparator : '��',
				items : textArea
			});
	var checkFieldSet = new Ext.form.FieldSet({
				title : '�������',
				height : 70,
				labelSeparator : '��',
				items : CheckResultField
			});

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1.0',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
									checkFieldSet,																	
									viewFieldSet
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				labelWidth: 80,
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'ȷ��'
			});
			
	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
			addHandler = function(){      			
							
			var ChkResult = encodeURIComponent(CheckResultField.getRawValue());
			//alert(ChkResult);
			var view	  = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
			var statusid  = CheckResultField.getValue();
				
			if(view=="")
      		{
      			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
						
			if(formPanel.form.isValid()){
				Ext.Ajax.request({
					url:projUrl+'?action=veraudit'+'&userdr='+userdr+'&vercode='+vercode+'&ChkResult1='+ChkResult+'&view1='+view+'&statusid='+statusid,
					waitMsg:'������...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if ((jsonData.success=='true'))
						{					
							//Ext.Msg.show({title:'ע��',msg:'������!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							
					window.close();
					p_URL = 'acct.html?acctno='+vercode+'&user='+userdr;
                    var reportFrame=document.getElementById("frameReport");
                    reportFrame.src=p_URL;
					
						}
						else if(jsonData.info=='RepName')
						{
							Ext.Msg.show({title:'����',msg:'�ϼ��Ѿ���ˣ���ǰ����ȡ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}else{
				Ext.Msg.show({title:'����',msg:'������ҳ���ϵĴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			
			addwin.close();
		}
		////// ��Ӽ����¼� ////////////////	
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'ȡ��',
				handler: function()
					{
					window.close();
					p_URL = 'acct.html?acctno='+vercode+'&user='+userdr;
                    var reportFrame=document.getElementById("frameReport");
                    reportFrame.src=p_URL;
					}
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '����˵��+�������',
				width: 500,
				height: 300,
				layout: 'fit',
				plain:true,
				//modal:true,
				bodyStyle:'padding:5px;',
				buttonAlign:'center',
				items: formPanel,
				buttons: 
				[
					addButton,
					cancelButton,	
				]	
			});		
			addwin.show();			
	}



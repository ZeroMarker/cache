savefun = function(FundBillDR, Code, Name) {
		var userdr = session['LOGON.USERID'];	
		var username = session['LOGON.USERNAME'];
//		var mydate=new Date();
//		var date=mydate.toLocaleDateString(); 
		var now=new Date(); 
		y=now.getFullYear();
		m=now.getMonth()+1;
		d=now.getDate();
		m=m<10?"0"+m:m;
		d=d<10?"0"+d:d;
		date=y+"-"+m+"-"+d;
		
		
		
		var ChequeCodeField = new Ext.form.TextField({												
			fieldLabel: '发票编号',
			allowBlank : false,
			width:180,
			anchor: '95%',
			selectOnFocus:'true'
		});
		var BillCodeField = new Ext.form.TextField({												
			fieldLabel: '申请单号',
			allowBlank : false,
			editable : false,
			disabled: true,
			value:Code,
			width:180,
			anchor: '95%',
			selectOnFocus:'true'
		});
		var ChequeDateField = new Ext.form.TextField({												
			fieldLabel: '发放日期',
			allowBlank : false,
			editable : false,
			disabled: true,
			value:date,
			width:180,
			anchor: '95%',
			selectOnFocus:'true'
		});
		var ChequeAfforderField = new Ext.form.TextField({												
			fieldLabel: '发放人',
			width:180,
			allowBlank : false,
			editable : false,
			disabled: true,
			value:username,
			anchor: '95%',
			selectOnFocus:'true'
		});

			var colItems =	[
					{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '.5',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [
							{
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								        ChequeCodeField,
								        ChequeAfforderField
								        
//									ApplBillCodeField,				
//									ApplyMoneyField,				
//									CompCodeField,
//									ApplyernameField,				
//									ApplyerDRField
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								        BillCodeField,
								        ChequeDateField
//									yearmonthField,				
//									FundFromField,	
//									projField,
//									deptField,
//									DescField
										
								]
							}]
					}
				]			
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 80,
				
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'保存'
			});

			addHandler = function(){
      			
				//var ApplBillCode		= ApplBillCodeField.getValue();
//				var ProjDR				= projField.getValue();
//				var CompCode			= CompCodeField.getValue();	
//				var ApplyerDR			= ApplyerDRField.getValue();
//				var YearMonth			= yearmonthField.getValue();
//				var FundFrom		    = FundFromField.getValue();
//				var ApplyMoney			= ApplyMoneyField.getValue();
//				var Desc				= DescField.getValue();
//				var deptdr				= deptField.getValue();
				var code				= ChequeCodeField.getValue();
				var time				= ChequeDateField.getValue();
				//	var afforder				= ChequeAfforderField.getValue();
				
				var afforder				= userdr;
				//alert(afforder);
				var billcode				= BillCodeField.getValue();
				if(code==""){
					Ext.Msg.show({
						title : '注意',
						msg : '发票编号不能为空!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
				}
				
				/*if(IsLast){
					IsLast = 1
				}else{
					IsLast = 0
				}	*/			
				
			//var data = ProjDR+"|"+CompCode+"|"+ApplyerDR+"|"+YearMonth+"|"+FundFrom+"|"+ApplyMoney+"|"+Desc+"|"+deptdr
				var data = code+"|"+time+"|"+afforder+"|"+FundBillDR
			if(formPanel.form.isValid()){
				
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgctrlchequeaffordexe.csp?action=add&data='+encodeURIComponent(data),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.info=='0'){
							
							addwin.close();
							//var apllycode = jsonData.info;
							//alert(jsonData.info);
							
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
		
							//ApplBillCodeField.setValue(apllycode);

							var year = yearCombo.getValue();
							var dept = deptCombo.getValue();
							var username = userCombo.getValue();
							var billcode = applyNo.getValue();
								itemGrid.load({
								params : {
									start : 0,
									limit :	this.pageSize,
									year : year,
									dept : dept,
									username : username,
									billcode : billcode
								}
							});

						}else
						{
							addwin.close();
							var message="";
							if(jsonData.info=='RepCode') message='输入的支票号已经存在!';
							if(jsonData.info=='RepName') message='输入的名称已经存在!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}
			
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '支票发放',
				width: 500,
				height: 200,
				//autoHeight: true,
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
			addwin.show();			
	
	}



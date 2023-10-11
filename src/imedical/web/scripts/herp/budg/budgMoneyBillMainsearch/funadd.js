addFun = function() {
		var userdr = session['LOGON.USERID'];	
		var username = session['LOGON.USERNAME'];
			//tmpRowid =   tmpNode.attributes["Rowid"];
   		    //tmpLevel = parseInt(tmpNode.attributes["Level"])+1;

			
			var ApplBillCodeField = new Ext.form.TextField({
				fieldLabel: '申请单号',
				width:180,
				disabled: true,
				anchor: '95%',
				selectOnFocus:'true'
			});
			
//****************************************************//
			var projDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});
			projDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgprojfundreqexe.csp?action=projList&userdr='+userdr,
							method : 'POST'
						})
			});
			var projField = new Ext.form.ComboBox({
				fieldLabel : '项目名称',
				width : 100,
				allowBlank : true,
				store : projDs,
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				//name:ProjDR,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
			//////////////////////////////////////////////////////////
		
			var CompCodeField = new Ext.form.TextField({
				fieldLabel: '单位编码',
				width:180,
				allowBlank:true,
				anchor: '95%',
				selectOnFocus:'true'
			});//usercode
			
			var ApplyerDRField = new Ext.form.TextField({
				fieldLabel: '申请人dr',
				width:180,
				allowBlank:false,				
				value:userdr,
				disabled: true,
				//hidden:true,
				anchor: '95%',
				selectOnFocus:'true'
			});
			var ApplyernameField = new Ext.form.TextField({
				fieldLabel: '申请人',
				width:180,
				allowBlank : false,
				editable : false,
				disabled: true,				
				value : username,
				anchor: '95%',
				selectOnFocus:'true'
			});
	
//****************************************************//
			var yearmonthDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});
			yearmonthDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgprojfundreqexe.csp?action=yearmonth',
							method : 'POST'
						})
			});
			var yearmonthField = new Ext.form.ComboBox({
				fieldLabel : '年月',
				width : 100,
				allowBlank : true,
				store : yearmonthDs,
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				//name:YearMonth,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
///***********************************************///						

//****************************************************//
			var deptDs = new Ext.data.Store({
				autoLoad : true,
				proxy : "",
				reader : new Ext.data.JsonReader({
							totalProperty : 'results',
							root : 'rows'
						}, ['rowid', 'name'])
			});
			deptDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'herp.budg.budgschemaselfexe.csp?action=deptNList',
							method : 'POST'
						})
			});
			var deptField = new Ext.form.ComboBox({
				fieldLabel : '申请科室',
				width : 100,
				allowBlank : true,
				store : deptDs,
				displayField : 'name',
				valueField : 'rowid',
				triggerAction : 'all',
				emptyText : '',
				minChars : 1,
				//name:YearMonth,
				anchor: '95%',
				pageSize : 10,
				selectOnFocus : true,
				forceSelection : 'true',
				editable : true
			});
///***********************************************///	

			var FundFromField = new Ext.form.ComboBox({												
				fieldLabel: '资金来源类型',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '财政资金'], ['2', '预算外资金'], ['2', '其他资金']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});
			
			var ApplyMoneyField = new Ext.form.TextField({												
				fieldLabel: '申领额度',
				width:180,
				anchor: '95%',
				allowBlank :false,
				selectOnFocus:'true'
			});
			var DescField = new Ext.form.TextField({												
				fieldLabel: '资金申请说明',
				width:180,
				anchor: '95%',
				selectOnFocus:'true'
			});
			//var IsLastField = new Ext.form.Checkbox({												
			//	fieldLabel: '末级'
			//});	

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
									ApplBillCodeField,				
									ApplyMoneyField,				
									CompCodeField,
									ApplyernameField,				
									ApplyerDRField
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [	
									yearmonthField,				
									FundFromField,	
									projField,
									deptField,
									DescField
										
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
				text:'添加'
			});

			addHandler = function(){
      			
				//var ApplBillCode		= ApplBillCodeField.getValue();
				var ProjDR				= projField.getValue();
				var CompCode			= CompCodeField.getValue();	
				var ApplyerDR			= ApplyerDRField.getValue();
				var YearMonth			= yearmonthField.getValue();
				var FundFrom		    = FundFromField.getValue();
				var ApplyMoney			= ApplyMoneyField.getValue();
				var Desc				= DescField.getValue();
				var deptdr				= deptField.getValue();
				/*if(IsLast){
					IsLast = 1
				}else{
					IsLast = 0
				}	*/			
				
			var data = ProjDR+"|"+CompCode+"|"+ApplyerDR+"|"+YearMonth+"|"+FundFrom+"|"+ApplyMoney+"|"+Desc+"|"+deptdr
			if(formPanel.form.isValid()){
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgprojfundreqexe.csp?action=add&data='+encodeURIComponent(data),
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var apllycode = jsonData.info;
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							ApplBillCodeField.setValue(apllycode);
							itemGrid.load({params:{start:0, limit:12,userdr:userdr}});	
						}else
						{
							var message="";
							if(jsonData.info=='RepCode') message='输入的编码已经存在!';
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
				title: '新增申请单',
				width: 500,
				height: 300,
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



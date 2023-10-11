checkFun = function(rowid) {

		var userdr = session['LOGON.USERID'];	
		var username = session['LOGON.USERNAME'];

			var CheckResultField = new Ext.form.ComboBox({									

			
				fieldLabel: '审批结果',
				width:500,
				anchor: '100%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['2', '通过'], ['3', '不通过']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '2',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true'
			});	
			
			
	// 多文本域
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
                                height:90,
				anchor: '100%',
				fieldLabel : '审批意见',
				//readOnly : true,
				//disabled : true,
				allowBlank :true,
				selectOnFocus:'true',
				emptyText : '请填写审批意见……'
			});

	// 导入说明多文本域
	var viewFieldSet = new Ext.form.FieldSet({
				title : '',
				height : 110,
                                region:'south',
				labelSeparator : '：',
				items : textArea
			});
	var checkFieldSet = new Ext.form.FieldSet({
				title : '',
				height : 70,
				labelSeparator : '：',
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
				//baseCls: 'x-plain',
				labelWidth: 80,
				//layout: 'form',
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'确定'
			});

			addHandler = function(){
      			
				
				var view				= textArea.getValue();
				var ChkResult			= CheckResultField.getValue();

                                                          
			if(formPanel.form.isValid()){
				Ext.Ajax.request({
					url: '../csp/herp.budg.costclaimexamiexe.csp?action=check&rowid='+rowid+'&view='+encodeURIComponent(view)+'&ChkResult='+ChkResult+'&userdr='+userdr,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						//alert(jsonData);
						if (jsonData.success=='true'){
							var apllycode = jsonData.info;
							Ext.Msg.show({title:'注意',msg:'审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							addwin.close();
							itemGrid.load({params:{start:0, limit:25,userdr:userdr}});	
						}else{
							var tmpMsg = jsonData.info;
							Ext.Msg.show({title:'错误',msg:tmpMsg,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}else{
				Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: 

Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				title: '审批',
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
	
	};



nocheck = function(rowid){
var userdr = session['LOGON.USERID'];	

  Ext.Ajax.request({
					url: '../csp/herp.budg.costclaimexamiexe.csp?action=nocheck&rowid='+rowid+'&userdr='+userdr,
					
					scope: this
				});
			
};








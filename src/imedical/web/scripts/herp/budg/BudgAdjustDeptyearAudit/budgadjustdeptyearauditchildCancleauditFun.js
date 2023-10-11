﻿cancleauditFun = function(SchemDr,auditdr,AdjustNo,objdeptdr) {
		//alert(AdjustNo+"^"+objdeptdr)

		var userdr   = session['LOGON.USERID'];	

		var projUrl  = 'herp.budg.budgadjustdeptyearauditdetailexe.csp';

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
				value : '3',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : '选择...',
				selectOnFocus:'true',
				disabled:true
			});	
			
			
//////////////// 多文本域 ////////////////////
	var textArea = new Ext.form.TextArea({
				id : 'textArea',
				width : 500,
				anchor: '100%',
				fieldLabel : '审批意见',
				allowBlank :false,
				selectOnFocus:'true',
				emptyText : '请填写审批意见……'
			});

/////////////// 导入说明多文本域 /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
				title : '审批意见',
				height : 110,
				labelSeparator : '：',
				items : textArea
			});
	var checkFieldSet = new Ext.form.FieldSet({
				title : '审批结果',
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
				labelWidth: 80,
				frame: true,
				items: colItems
			});
	
			addButton = new Ext.Toolbar.Button({
				text:'确定'
			});
			
	//////////////////////////  增加按钮响应函数   //////////////////////////////
			addHandler = function(){      			
							
			var ChkResult = CheckResultField.getValue();
			var view	  = encodeURIComponent(Ext.getCmp('textArea').getRawValue())
			
			if(view=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'描述不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
						
			if(formPanel.form.isValid()){
				Ext.Ajax.request({
					url:projUrl+'?action=cancleaudit'+'&SchemDr='+SchemDr+'&auditdr='+auditdr+'&userdr='+userdr+'&ChkResult='+ChkResult+'&view='+view+'&adjustno='+AdjustNo+'&objdeptdr='+objdeptdr,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true')
						{					
							Ext.Msg.show({title:'注意',msg:'取消审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							
							itemMain.load({params:{start:0, limit:12,userdr:userdr}});
							itemDetail.load({params:{start:0, limit:12,SchemDr:"",objdeptdr:"",bsmyear:"",adjustno:""}});
	
						}
						else if(jsonData.info=='RepName')
						{
							Ext.Msg.show({title:'错误',msg:'上级已经审核，当前不可取消!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}else{
				Ext.Msg.show({title:'错误',msg:'请修正页面上的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}
			
			addwin.close();
		}
		////// 添加监听事件 ////////////////	
			addButton.addListener('click',addHandler,false);
	
			cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});
			
			cancelHandler = function(){
				addwin.close();
			}
			
			cancelButton.addListener('click',cancelHandler,false);
	
			addwin = new Ext.Window({
				title: '"申请说明"+审批意见',
				width: 500,
				height: 300,
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



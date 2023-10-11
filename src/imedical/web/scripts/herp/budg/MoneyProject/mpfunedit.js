// 修改函数
var	hospid = session['LOGON.HOSPID'];
var mainUrl = '../csp/herp.budg.budgitemdictexe.csp';
updateFun = function(node) {
	var tempdgroup=node.attributes.DGroup;
	if (node == null) {
		Ext.Msg.show({
					title : '提示',
					msg : '请选择要修改的数据!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.INFO
				});
		return false;
	} else {
		if (node.attributes.id == "roo") {
			Ext.Msg.show({
						title : '提示',
						msg : '根节点不允许被修改!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
		function isempty( myself, next) 
		{
			
			if(myself.getValue()!==""){
				next.focus();
			}else{
				Handler = function(){myself.focus();};
				Ext.Msg.show({title:'错误',msg:myself.fieldLabel+'不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
			}
		}
		}}
			// 取该条记录的rowid
			var rowid = node.attributes.id;
			var parent = node.attributes.parent;
			//alert(level);
			//alert(parent);
			var level=node.attributes.level;
			var CodeField = new Ext.form.TextField({
						id : 'CodeField',
						fieldLabel : '项目编码',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									isempty( CodeField, NameField);
									//NameField.focus();
								}
							}
						}
					});
			if(level>=0){
					CodeField.setValue("");
					CodeField.disable();
				}else{
					CodeField.enable();
				}	

			var NameField = new Ext.form.TextField({
						id : 'NameField',
						fieldLabel : '项目名称',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (NameField.getValue() !== "") {
									var name = NameField.getValue();
					Ext.Ajax.request({
					url: '../csp/herp.budg.moneyprojectexe.csp?action=getmnemo&name='+encodeURIComponent(name),				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var Mnemonics = jsonData.info;
							MnemField.setValue(Mnemonics);
						}
					},
					scope: this
					});
										MnemField.focus();
									} else {
										Handler = function() {
											NameField.focus();
										};
										Ext.Msg.show({
													title : '错误',
													msg : '单元名称不能为空!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR,
													fn : Handler
												});
									}
								}
							}
						}
					});
//////////////////////医疗单位////////////////////////////////////			
			var AddCompDRDs = new Ext.data.Store({
						
			            url : commonboxURL+'?action=hospital&rowid='+hospid+'&start=0&limit=10&str=',
						autoLoad : true,  
						fields: ['rowid','name'],
						reader : new Ext.data.JsonReader({
									totalProperty : "results",
									root : 'rows'
								}, ['rowid', 'name'])
			});


			var AddCompDRCombo = new Ext.form.ComboBox({
						fieldLabel : '医疗单位',
						store : AddCompDRDs,
						displayField : 'name',
						valueField : 'rowid',
						typeAhead : true,
						forceSelection : true,
						triggerAction : 'all',
						emptyText : '',
						width : 180,
						listWidth : 145,
						pageSize : 10,
						minChars : 1,
						anchor: '90%',
						selectOnFocus : true
					});	
					
			AddCompDRDs.on("load", function(){
	
				var Num=AddCompDRDs.getCount();
			    if (Num!=0){
			        var id=AddCompDRDs.getAt(0).get('rowid');
				    AddCompDRCombo.setValue(id); 
			    } 

			});
					var MnemField = new Ext.form.TextField({
					fieldLabel: '拼音码',
					width:180,
					anchor: '90%',
					allowBlank : false,  
					selectOnFocus:'true',
					listeners : {
								specialKey : function(field, e) {
									if (e.getKey() == Ext.EventObject.ENTER) {
										isempty( MnemField);
									}
									}}
					});
				
					var StateFieldStore = new Ext.data.SimpleStore({
								fields : ['key', 'keyValue'],
								data : [['1', '有效'], ['2', '无效']]
							});
					var StateField = new Ext.form.ComboBox({
								id : 'stateField',
								fieldLabel : '状态',
								width : 200,
								selectOnFocus : true,
								allowBlank : false,
								store : StateFieldStore,
								anchor : '90%',			
								displayField : 'keyValue',
								valueField : 'key',
								triggerAction : 'all',
								emptyText : '',
								mode : 'local', // 本地模式
								editable : false,
								selectOnFocus : true,
								forceSelection : true,
								listeners : {
								specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									isempty( StateField,StyleField);//
									//StyleField.focus();
								}
							}
						}
							});
					StateField.on('select',function(combo, record, index){
						State = combo.getValue();
						//alert(tmpdCode);
					});
							
					var IsEndField = new Ext.form.Checkbox({
						id : 'IsEndField',
						fieldLabel : '末端标志',
						allowBlank : false,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									CodeField.focus();
								}
							}
						}
					});
				var StyleStore = new Ext.data.SimpleStore({
						fields:['key','keyValue'],
						data:[['01','现金流入'],['02','现金流出'],['03','净额'],['04','其他']]
					});
			var StyleField = new Ext.form.ComboBox({
						id: 'StyleField',
						fieldLabel: '现金类型',
						width:120,
						allowBlank: false,
						store:StyleStore,
						anchor: '90%',
						displayField: 'keyValue',
						valueField: 'key',
						triggerAction: 'all',
						emptyText:'选择...',
						mode: 'local', // 本地模式
						pageSize: 10,
						minChars: 15,
						selectOnFocus:true,
						forceSelection:true,
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									isempty(StyleField);
									
								}
							}
						}
					});
			
			
			if(level=="1" || level=="2"){
		
		
			IsEndField.disable();
			
			}
			
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
									AddCompDRCombo,
									CodeField,
									NameField,
									MnemField,
								
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								
									StateField,
									StyleField,
									IsEndField,
									
								]
							}]
					}
				];
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 70,
				//layout: 'form',
				frame: true,
				items: colItems
			});
			/*formPanel = new Ext.form.FormPanel({
						baseCls : 'x-plain',
						labelWidth : 70,
						items : [
						CodeField,
						NameField,
					
						stateField,
						StyleField,
					
						IsEndField]
					});*/

			formPanel.on('afterlayout', function(panel, layout) {
						this.getForm().loadRecord(node);
						var Code=node.attributes.Code;
						/*var arr=new Array();
						arr=codestr.split("_");
						var Code=arr[1];*/
						CodeField.setValue(Code);
						NameField.setValue(node.attributes.Name);
						MnemField.setValue(node.attributes.Mnemonics);
						StateField.setValue(node.attributes.State);
						IsEndField.setValue((node.attributes.IsLast=='Y')? true : false);
						
						StyleField.setValue(node.attributes.Style);
						
						//alert((node.attributes.IsLast=='Y')? true : false);
						

					});

			editButton = new Ext.Toolbar.Button({
						text : '修改'
					});

			editHandler = function() {

				var Code = CodeField.getValue();
				if(Code==""){
						Ext.Msg.show({title:'错误',msg:'编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						reture;
						}
				var Name = NameField.getValue();
			
				var Mnem = MnemField.getValue();
				var isEnd = (IsEndField.getValue() == true) ? 'Y' : 'N';
				var State = StateField.getValue();
				var Level = node.attributes.Level;
				//alert(level)
				var CompDR	= AddCompDRCombo.getValue();
				
				var Style = StyleField.getValue();
				
			
			
			
				
				
				
				
var data=Code+"|"+Name+"|"+Mnem+"|"+isEnd+"|"+State+"|"+Level+"|"+parent+"|"+Style+"|"+CompDR;
			if(formPanel.form.isValid()){
				Ext.Ajax.request({
							url : '../csp/herp.budg.moneyprojectexe.csp?action=update&data='+encodeURIComponent(data)+'&rowid='+rowid,
							waitMsg : '修改中...',							
							failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接?',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
												title : '提示',
												msg : '修改成功!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
											
									if (node.attributes.parent == 0) {
										node.attributes.parent = "roo";
									}
									 
									//alert(node.attributes.id);
									//alert(Ext.getCmp('itemGrid').getNodeById(node.attributes.id).parentNode.text)
									Ext.getCmp('itemGrid').getNodeById(node.attributes.id).parentNode.reload();
									window.close();
								} else {
									var message="";
									if(jsonData.info=='RepCode') message='输入的编码已经存在!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									if(jsonData.info=='fail') message='保存到相应的组失败!';
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope : this
						});
						};
			};

			editButton.addListener('click', editHandler, false);

			cancel = new Ext.Toolbar.Button({
						text : '退出'
					});

			cancelHandler1 = function() {
				window.close();
			}

			cancel.addListener('click', cancelHandler1, false);

			var window = new Ext.Window({
						title : '修改记录',
						width : 550,
						height : 350,
						minWidth : 415,
						minHeight : 335,
						layout : 'fit',
						plain : true,
						modal : true,
						bodyStyle : 'padding:5px;',
						buttonAlign : 'center',
						items : formPanel,
						buttons : [editButton, cancel]
					});
			window.show();
        
        }
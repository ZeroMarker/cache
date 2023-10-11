// 添加函数
var	hospid = session['LOGON.HOSPID'];
var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
addFun = function(node) {
	if (node != null) {
		var end = node.attributes.IsLast;
		if (end == "Y") {
			Ext.Msg.show({
						title : '提示',
						msg : '末端不能添加子节点!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
			return false;
		} else {
			// 非末端节点,允许添加	
		function isempty( myself, next){
			
			if(myself.getValue()!==""){
				next.focus();
			}else{
				Handler = function(){myself.focus();};
				Ext.Msg.show({title:'错误',msg:myself.fieldLabel+'不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
			}}
		}
		
			var level=node.attributes.level;
			var CodeField = new Ext.form.TextField({
						id : 'CodeField',
						fieldLabel : '项目编码',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						minLength : 2,  
						maxLength : 8, 
						emptyText : '',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									isempty(CodeField,nameField);
								}
								}}
					});				
				if(level>=0){
					CodeField.setValue("");
					CodeField.disable();
				}else{
					CodeField.enable();
				}	
			var nameField = new Ext.form.TextField({
						id : 'nameField',
						fieldLabel : '项目名称',
						allowBlank : false,
						width : 180,
						listWidth : 180,
						emptyText:'',
						anchor : '90%',
						selectOnFocus : 'true',
						listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if (nameField.getValue() !== "") {
					var name = nameField.getValue();
					var parent = 0;
					var level = 0;
					//alert(node.attributes.id);
					if (node.attributes.id != "roo") {
						parent = node.attributes.Code;
						level = node.attributes.level;
						//alert(level);
						level=level*1;
						level = level+1;
						//alert(level);
					}
					var Code0 = CodeField.getValue();
				
					Ext.Ajax.request({
					url: '../csp/herp.budg.moneyprojectexe.csp?action=getcode&name='+encodeURIComponent(name)+'&level='+level+'&parent='+parent+'&Code0='+Code0+'&Dept='+Dept,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var data = jsonData.info;
							var arr=data.split("^");
							var code = arr[0];
							var Mnemonics = arr[1];
							CodeField.setValue(code);
							MnemField.setValue(Mnemonics);
						}
					},
					scope: this
					});
										MnemField.focus();
									} else {
										Handler = function() {
											nameField.focus();
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
					
				var MnemField = new Ext.form.TextField({
				fieldLabel: '拼音码',
				width:180,
				anchor: '90%',
				allowBlank : false,  
				selectOnFocus:'true',
				listeners : {
							specialKey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									isempty(MnemField);
								}
								}}
				});
					
					var stateFieldStore = new Ext.data.SimpleStore({
						fields:['key','keyValue'],
						data:[['1','有效'],['2','无效']]
					});
					var stateField = new Ext.form.ComboBox({
						id: 'stateField',
						fieldLabel: '状态',
						width:120,
						allowBlank: false,
						store: stateFieldStore,
						anchor: '90%',
						value : 1,
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
									isempty(stateField,TypeField);
									//TypeField.focus();
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
			
			
			var isEndField = new Ext.form.Checkbox({
						id : 'isEndField',
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
						fieldLabel: '类型',
						width:120,
						allowBlank: false,
						store: StyleStore,
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
			// ////////////////////////////////////
		
			
		
			
			
			
		
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
									nameField,
									MnemField,
									isEndField,
								]
							}, {
								xtype: 'fieldset',
								autoHeight: true,
								items: [
								
									stateField,
									StyleField,
							
									
									
									
								]
							}]
					}
				]
			
			var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 70,
				//layout: 'form',
				frame: true,
				items: colItems
			});
			
			// 定义添加按钮
			var addButton = new Ext.Toolbar.Button({
						text : '添加'
					});

			// 添加处理函数
			var addHandler = function() {
				var Code = CodeField.getValue();
				var name = nameField.getValue();
				var Mnem = MnemField.getValue();
				var CompDR	= AddCompDRCombo.getValue();
				var isEnd = (isEndField.getValue() == true) ? 'Y' : 'N';
					//alert(isEnd);
				var state = stateField.getValue();
				var level = 0;
				var parent = 0;
				//alert(node.attributes.id);
				var Style = StyleField.getValue();
				if (node.attributes.id != "roo") {
					var parent = node.attributes.Code;
					level = node.attributes.Level;
					//alert(level);
					level=level*1;
					level = level+1;
					//alert(level);
					//
				
				}
				
var data=Code+"|"+name+"|"+Mnem+"|"+isEnd+"|"+state+"|"+level+"|"+parent+"|"+Style+"|"+CompDR;
				//alert(data);		
				var url = '../csp/herp.budg.moneyprojectexe.csp?action=add&data='+encodeURIComponent(data);

			if(formPanel.form.isValid()){
				Ext.Ajax.request({
				url : Ext.util.Format.htmlDecode(url),
				waitMsg : '添加中..',
				failure : function(result, request) {
					Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
				},
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
					Ext.Msg.show({title : '提示',msg : '信息添加成功，请稍作等候!',icon : Ext.MessageBox.INFO,buttons : Ext.Msg.OK});
						Ext.getCmp('itemGrid').getNodeById(node.attributes.id).reload();
				
				
					} else {
						var message="";
						if(jsonData.info=='RepCode') message='输入的编码已经存在!';
						if(jsonData.info=='RepName') message='输入的名称已经存在!';
						if(jsonData.info=='fail') message='保存到相应的组失败!';
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						if (jsonData.info == 'null') {
							Handler = function() {
							nameField.focus();
							}
							Ext.Msg.show({title : '提示',msg : '你以前添加过错误数据,没有上级节点ID!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR,
										fn : Handler});
						}
					}
				},
				scope : this
				});
				}
			
			}
			// 添加按钮的响应事件
			addButton.addListener('click', addHandler, false);

			// 定义取消按钮
			var cancelButton = new Ext.Toolbar.Button({
						text : '取消'
					});

			// 取消处理函数
			var cancelHandler = function() {
				win.close();
			}

			// 取消按钮的响应事件
			cancelButton.addListener('click', cancelHandler, false);

			var win = new Ext.Window({
						title : '添加单元记录',
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
						buttons : [addButton, cancelButton]
					});
			win.show();
	}
	
	  else 
	{
		Ext.Msg.show({
					title : '错误',
					msg : '请选择要添加子节点的记录！',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
	}
	
}
//添加函数
addFun = function(node){
	
	if(node!=null){
		var end = node.attributes.End;
		if(end=="Y"){
			Ext.Msg.show({title:'提示',msg:'末端不能添加子节点!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			//非末端节点,允许添加
			var nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '单元名称',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写单元名称...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(nameField.getValue()!=""){
								codeField.focus();
							}else{
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'错误',msg:'单元名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			var codeField = new Ext.form.TextField({
				id:'codeField',
				fieldLabel: '单元代码',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写单元代码...',
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
				fieldLabel: '拼 音 码',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写拼音码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							appSysField.focus();
						}
					}
				}
			});
			
			var appSysStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [['1','1-全院'],['2','2-科室'],['3','3-护理'],['4','4-医疗'],['5','5-个人']]
			});
			var appSysField = new Ext.form.ComboBox({
				id: 'appSysField',
				fieldLabel: '应用系统号',
				width:275,
				listWidth : 275,
				selectOnFocus: true,
				allowBlank: false,
				store: appSysStore,
				anchor: '90%',
				value:'1', //默认值
				valueNotFoundText:'1-全院',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'选择标志...',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(appSysField.getValue()!=""){
								typeField.focus();
							}else{
								Handler = function(){appSysField.focus();}
								Ext.Msg.show({title:'错误',msg:'应用系统代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			appSysField.on("select",function(cmb,rec,id ){
				if(cmb.getValue()=="5"){
					unitField.enable();
					deptField.enable();
				}else{
					unitField.disable();
					deptField.disable();
				}
			});
			
			var typeField = new Ext.form.TextField({
				id:'typeField',
				fieldLabel: '类别编码',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写类别编码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(typeField.getValue()!=""){
								jxLocTypeField.focus();
							}else{
								Handler = function(){typeField.focus();}
								Ext.Msg.show({title:'错误',msg:'类别编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});

			var jxLocTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			jxLocTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=loctype&str='+encodeURIComponent(Ext.getCmp('jxLocTypeField').getRawValue()),method:'POST'})
			});

			var jxLocTypeField = new Ext.form.ComboBox({
				id: 'jxLocTypeField',
				fieldLabel: '科室类别',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: jxLocTypeDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择科室类别...',
				name: 'jxLocTypeField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true
				/**
					listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(jxLocTypeField.getValue()!=""){
								isEndField.focus();
							}else{
								Handler = function(){jxLocTypeField.focus();}
								Ext.Msg.show({title:'错误',msg:'科室类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
				**/
			});
			
			var isEndField = new Ext.form.Checkbox({
				id: 'isEndField',
				fieldLabel:'核算标志',
				//itemCls:'float-left',
				//clearCls:'allow-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							unitField.focus();
						}
					}
				}
			});
			
			var unitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			unitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=unit&str='+encodeURIComponent(Ext.getCmp('unitField').getRawValue()),method:'POST'})
			});

			var unitField = new Ext.form.ComboBox({
				id: 'unitField',
				fieldLabel: '所属单位',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: unitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择所属单位...',
				name: 'unitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(unitField.getValue()!=""){
								deptField.focus();
							}else{
								Handler = function(){unitField.focus();}
								Ext.Msg.show({title:'错误',msg:'所属单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});

			var deptDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			deptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=dept&str='+encodeURIComponent(Ext.getCmp('deptField').getRawValue())+'&unitDr='+Ext.getCmp('unitField').getValue(),method:'POST'})
			});

			var deptField = new Ext.form.ComboBox({
				id: 'deptField',
				fieldLabel: '部门名称',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: deptDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择部门...',
				name: 'deptField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(deptField.getValue()!=""){
								StratagemField.focus();
							}else{
								Handler = function(){deptField.focus();}
								Ext.Msg.show({title:'错误',msg:'部门不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			unitField.on("select",function(cmb,rec,id ){
				searchFun(cmb.getValue());
			});

			function searchFun(unitDr){
				deptDs.proxy = new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=coldept&unitDr='+unitDr+'&str='+(Ext.getCmp('deptField').getRawValue()),method:'POST'})
				deptDs.load({params:{start:0, limit:deptField.pageSize}});
			};
			
			var StratagemDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			StratagemDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=stratagem&str='+encodeURIComponent(Ext.getCmp('StratagemField').getRawValue()),method:'POST'})
			});

			var StratagemField = new Ext.form.ComboBox({
				id: 'StratagemField',
				fieldLabel: '战略目标',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: StratagemDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择战略目标...',
				name: 'StratagemField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(StratagemField.getValue()!=""){
								endField.focus();
							}else{
								Handler = function(){StratagemField.focus();}
								Ext.Msg.show({title:'错误',msg:'战略目标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			var endField = new Ext.form.Checkbox({
				id: 'EndField',
				fieldLabel:'末端标志',
				//hideLabel:true,
				allowBlank: false,
				//clearCls:'stop-float',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							addButton.focus();
						}
					}
				}
			});
			
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 70,
				items: [
					
					nameField,
					codeField,
					pyField,
					//appSysField,
					typeField,
					jxLocTypeField,
					isEndField,
					//unitField,
					//deptField,
					//StratagemField,
					endField
				]
			});	
			
			//定义添加按钮
			var addButton = new Ext.Toolbar.Button({
				text:'添加'
			});
			
			//添加处理函数
			var addHandler = function(){
				var code = codeField.getValue();
				var name = nameField.getValue();
				var py = pyField.getValue();
				/*
				var appSysDr = Ext.getCmp('appSysField').getValue();
				if(appSysDr=="5"){
					var deptDr = Ext.getCmp('deptField').getValue();
					deptDr = trim(deptDr);
					if(deptDr==""){
						Ext.Msg.show({title:'提示',msg:'部门为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return false;
					};
				}else{
					var deptDr = "";
				}
				*/
				var type = typeField.getValue();
				var jxLocTypeDr = Ext.getCmp('jxLocTypeField').getValue();
				var isEnd = (isEndField.getValue()==true)?'Y':'N';
				
				//var stratagemDr = Ext.getCmp('StratagemField').getValue();
				
				
				
				var end = (endField.getValue()==true)?'Y':'N';
				
				var parent = 0;
				var level = 0;
				if(node.attributes.id!="roo"){
					parent = node.attributes.id;
					level = node.attributes.level;
				}
				
				name = trim(name);
				code = trim(code);
				if(name==""){
					Ext.Msg.show({title:'提示',msg:'绩效单元名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};
				jxLocTypeDr = trim(jxLocTypeDr);
				if((jxLocTypeDr=="")&&(isEnd=="Y")){
					Ext.Msg.show({title:'提示',msg:'科室类别为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};
				/*
				stratagemDr = trim(stratagemDr);
				if(stratagemDr==""){
					Ext.Msg.show({title:'提示',msg:'战略目标为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};
				*/
				//var data = encodeURIComponent(name+"^"+py+"^"+appSysDr+"^"+type+"^"+jxLocTypeDr+"^"+isEnd+"^"+level+"^"+deptDr+"^"+parent+"^"+stratagemDr+"^"+code+"^"+end);
				
				
				var data = name+"^"+py+"^"+2+"^"+type+"^"+jxLocTypeDr+"^"+isEnd+"^"+level+"^"+""+"^"+parent+"^"+""+"^"+code+"^"+end;
				
				Ext.Ajax.request({
					url:'../csp/dhc.pa.jxunitexe.csp?action=add&data='+encodeURIComponent(data),
					waitMsg:'添加中..',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							Ext.getCmp('detailReport').getNodeById(node.attributes.id).reload();
						}else{
							if(jsonData.info=='RepName'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'名称重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
							if(jsonData.info=='dataEmpt'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
							if(jsonData.info=='ParamErr'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'参数数据有错,请修改参数表指标深度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
							if(jsonData.info=='null'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'你以前添加过错误数据,没有上级节点ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					},
					scope: this
				});
			}

			//添加按钮的响应事件
			addButton.addListener('click',addHandler,false);

			//定义取消按钮
			var cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});

			//取消处理函数
			var cancelHandler = function(){
				win.close();
			}

			//取消按钮的响应事件
			cancelButton.addListener('click',cancelHandler,false);

			var win = new Ext.Window({
				title: '添加绩效单元记录',
				width: 415,
				height:315,
				minWidth: 415,
				minHeight: 315,
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
		Ext.Msg.show({title:'错误',msg:'请选择要添加子节点的记录！',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	}
};
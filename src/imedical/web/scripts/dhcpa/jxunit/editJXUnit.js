//修改函数
updateFun = function(node){
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return false;
		}else{
			//取该条记录的rowid
			var rowid = node.attributes.id;
			
			var appSysDr = node.attributes.appSysDr;
			if(appSysDr=="5"){
				var disabled=false;
			}else{
				var disabled=true;
			}
		
			var NameField = new Ext.form.TextField({
				id:'NameField',
				fieldLabel: '单元名称',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请选择单元名称...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(NameField.getValue()!=""){
								CodeField.focus();
							}else{
								Handler = function(){NameField.focus();}
								Ext.Msg.show({title:'错误',msg:'单元名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			var CodeField = new Ext.form.TextField({
				id:'CodeField',
				fieldLabel: '单元代码',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请选择单元代码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							PYField.focus();
						}
					}
				}
			});
			
			var PYField = new Ext.form.TextField({
				id:'PYField',
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
							AppSysField.focus();
						}
					}
				}
			});
			
			var AppSysStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [['1','1-全院'],['2','2-科室'],['3','3-护理'],['4','4-医疗'],['5','5-个人']]
			});
			var AppSysField = new Ext.form.ComboBox({
				id: 'AppSysField',
				fieldLabel: '应用系统号',
				width:275,
				listWidth : 275,
				selectOnFocus: true,
				allowBlank: false,
				store: AppSysStore,
				anchor: '90%',
				//value:'1', //默认值
				valueNotFoundText:node.attributes.appSysName,
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
								TypeField.focus();
							}else{
								Handler = function(){appSysField.focus();}
								Ext.Msg.show({title:'错误',msg:'应用系统代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			AppSysField.on("select",function(cmb,rec,id ){
				if(cmb.getValue()=="5"){
					UnitField.enable();
					DeptField.enable();
				}else{
					UnitField.disable();
					DeptField.disable();
				}
			});
			
			var TypeField = new Ext.form.TextField({
				id:'TypeField',
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
							if(TypeField.getValue()!=""){
								JXLocTypeField.focus();
							}else{
								Handler = function(){TypeField.focus();}
								Ext.Msg.show({title:'错误',msg:'类别编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			var JXLocTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			JXLocTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=loctype&str=',method:'POST'})
			});

			var JXLocTypeField = new Ext.form.ComboBox({
				id: 'JXLocTypeField',
				fieldLabel: '科室类别',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: JXLocTypeDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择科室类别...',
				name: 'JXLocTypeField',
				valueNotFoundText:node.attributes.locTypeName,
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(jxLocTypeField.getValue()!=""){
								isEnd.focus();
							}else{
								Handler = function(){jxLocTypeField.focus();}
								Ext.Msg.show({title:'错误',msg:'科室类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			var isEnd = new Ext.form.Checkbox({
				id: 'isEnd',
				labelSeparator:'核算标志',
				allowBlank: false,
				checked:(node.attributes.isEnd)=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							UnitField.focus();
						}
					}
				}
			});
			
			var UnitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			UnitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=unit&str='+encodeURIComponent(Ext.getCmp('UnitField').getRawValue()),method:'POST'})
			});

			var UnitField = new Ext.form.ComboBox({
				id: 'UnitField',
				fieldLabel: '所属单位',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: UnitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择所属单位...',
				valueNotFoundText:node.attributes.unitName,
				name: 'UnitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:disabled,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(UnitField.getValue()!=""){
								DeptField.focus();
							}else{
								Handler = function(){UnitField.focus();}
								Ext.Msg.show({title:'错误',msg:'所属单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});

			var DeptDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			DeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=dept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue())+'&unitDr='+Ext.getCmp('UnitField').getValue(),method:'POST'})
			});

			var DeptField = new Ext.form.ComboBox({
				id: 'DeptField',
				fieldLabel: '部门名称',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: DeptDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择部门...',
				valueNotFoundText:node.attributes.deptName,
				name: 'DeptField',
				minChars: 1,
				pageSize: 10,
				disabled:disabled,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(DeptField.getValue()!=""){
								stratagemField.focus();
							}else{
								Handler = function(){DeptField.focus();}
								Ext.Msg.show({title:'错误',msg:'部门不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			UnitField.on("select",function(cmb,rec,id ){
				searchFun(cmb.getValue());
			});

			function searchFun(unitDr){
				DeptDs.proxy = new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=coldept&unitDr='+unitDr+'&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'})
				DeptDs.load({params:{start:0, limit:DeptField.pageSize}});
			};
			
			var stratagemDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			stratagemDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.jxunitexe.csp?action=stratagem&str='+encodeURIComponent(Ext.getCmp('stratagemField').getRawValue()),method:'POST'})
			});

			var stratagemField = new Ext.form.ComboBox({
				id: 'stratagemField',
				fieldLabel: '战略目标',
				width:275,
				listWidth : 275,
				allowBlank: false,
				store: stratagemDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择战略目标...',
				name: 'stratagemField',
				minChars: 1,
				valueNotFoundText:node.attributes.stratagemName,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(stratagemField.getValue()!=""){
								end.focus();
							}else{
								Handler = function(){stratagemField.focus();}
								Ext.Msg.show({title:'错误',msg:'战略目标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
							}
						}
					}
				}
			});
			
			var end = new Ext.form.Checkbox({
				id: 'end',
				labelSeparator:'末端标志',
				allowBlank: false,
				checked:(node.attributes.End)=='Y'?true:false
			});
			var isStop = new Ext.form.Checkbox({
				id: 'isStop',
				labelSeparator:'是否停用',
				allowBlank: false,
				checked:(node.attributes.isStop)=='Y'?true:false
				
			});
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 70,
				items: [
					NameField,
					CodeField,
					PYField,
					//AppSysField,
					TypeField,
					JXLocTypeField,
					isEnd,
					//UnitField,
					//DeptField,
					//stratagemField,
					end,
					isStop
				]
			});	
		
			formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				NameField.setValue(node.attributes.name);
				CodeField.setValue(node.attributes.code);
				PYField.setValue(node.attributes.py);
				//AppSysField.setValue(node.attributes.appSysDr);
				TypeField.setValue(node.attributes.type);
				JXLocTypeField.setValue(node.attributes.jxLocTypeDr);
				//alert(node.attributes.isStop);
				//UnitField.setValue(node.attributes.unitDr);
				//DeptField.setValue(node.attributes.aDeptDr);
				//stratagemField.setValue(node.attributes.stratagemDr);
			});	
			
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			editHandler = function(){
				
				var code = CodeField.getValue();
				var name = NameField.getValue();
				var py = PYField.getValue();
				/*
				var appSysDr = Ext.getCmp('AppSysField').getValue();
				if(appSysDr=="5"){
					var deptDr = Ext.getCmp('DeptField').getValue();
					deptDr = trim(deptDr);
					if(deptDr==""){
						Ext.Msg.show({title:'提示',msg:'部门为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return false;
					};
				}else{
					var deptDr="";
				}
				*/
				var type = TypeField.getValue();
				var jxLocTypeDr = Ext.getCmp('JXLocTypeField').getValue();
				var IsEnd = (isEnd.getValue()==true)?'Y':'N';
				
				//var stratagemDr = Ext.getCmp('stratagemField').getValue();
				var End = (end.getValue()==true)?'Y':'N';
				var parent = node.attributes.parent;
				var level = node.attributes.level;
				var IsStop = (isStop.getValue()==true)?'Y':'N';
				name = trim(name);
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
				//var data = encodeURIComponent(code+"^"+name+"^"+py+"^"+appSysDr+"^"+type+"^"+jxLocTypeDr+"^"+IsEnd+"^"+level+"^"+deptDr+"^"+parent+"^"+stratagemDr+"^"+End);
					var data = code+"^"+name+"^"+py+"^"+2+"^"+type+"^"+jxLocTypeDr+"^"+IsEnd+"^"+level+"^"+""+"^"+parent+"^"+""+"^"+End+"^"+IsStop;
				Ext.Ajax.request({
					url: '../csp/dhc.pa.jxunitexe.csp?action=edit&data='+encodeURIComponent(data)+'&rowid='+rowid,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							if(node.attributes.parent==0){
								node.attributes.parent="roo";
							}
							Ext.getCmp('detailReport').getNodeById(node.attributes.parent).reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='RepName') message='绩效单元名称重复!';
							if(jsonData.info=='dataEmpt') message='空数据!';
							if(jsonData.info=='rowidEmpt') message='数据有错!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			};
	
			editButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'退出'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '修改绩效单元记录',
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
				buttons:[editButton,cancel]
			});
			window.show();
		}
	}
};
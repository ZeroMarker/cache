//添加函数
addFun = function(node){
	if(node!=null){
		var end = node.attributes.isEnd;
		if(end=="Y"){
			Ext.Msg.show({title:'提示',msg:'末端不能添加子节点!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//非末端节点,允许添加
			var nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '指标名称',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请指标名称...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(nameField.getValue()!=""){
								codeField.focus();
							}else{
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'错误',msg:'指标名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var codeField = new Ext.form.TextField({
				id:'codeField',
				fieldLabel: '指标代码',
				allowBlank: true,
				width:180,
				listWidth : 180,
				emptyText:'请指标代码...',
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
							dimTypeField.focus();
						}
					}
				}
			});
			
			var dimTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			dimTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=dimtype&str='+Ext.getCmp('dimTypeField').getRawValue(),method:'POST'})
			});

			var dimTypeField = new Ext.form.ComboBox({
				id: 'dimTypeField',
				fieldLabel: '维度类别',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: dimTypeDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择维度类别...',
				name: 'dimTypeField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				//disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(dimTypeField.getValue()!=""){
								targetField.focus();
							}else{
								Handler = function(){dimTypeField.focus();}
								Ext.Msg.show({title:'错误',msg:'维度类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var targetField = new Ext.form.TextField({
				id:'targetField',
				fieldLabel: '评测目标',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写评测目标...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							descField.focus();
						}
					}
				}
			});
			
			var descField = new Ext.form.TextField({
				id:'descField',
				fieldLabel: '指标描述',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写指标描述...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							calUnitField.focus();
						}
					}
				}
			});
			
			var calUnitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			calUnitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=calunit&str='+Ext.getCmp('calUnitField').getRawValue(),method:'POST'})
			});

			var calUnitField = new Ext.form.ComboBox({
				id: 'calUnitField',
				fieldLabel: '计量单位',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: calUnitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择计量单位...',
				name: 'calUnitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(calUnitField.getValue()!=""){
								extreMumField.focus();
							}else{
								Handler = function(){calUnitField.focus();}
								Ext.Msg.show({title:'错误',msg:'计量单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});

			var extreMumStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["H",'趋高'],["M",'趋中'],["L",'趋低']]
			});
			var extreMumField = new Ext.form.ComboBox({
				id: 'extreMumField',
				fieldLabel: '极   值',
				listWidth : 285,
				selectOnFocus: true,
				allowBlank: false,
				store: extreMumStore,
				anchor: '90%',
				value:"", //默认值
				valueNotFoundText:'',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'选择极值...',
				mode: 'local', //本地模式
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true,
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							expreField.focus();
						}
					}
				}
			});
			
			expreField = new Ext.form.TextField({
				id:'expreField',
				fieldLabel: '计算公式',
				allowBlank: false,
				width:100,
				listWidth : 100,
				emptyText:'请编辑计算公式...',
				anchor: '90%',
				editable:false,
				disabled:true,
				selectOnFocus:'true',
				itemCls:'sex-female', //向左浮动,处理控件横排
				clearCls:'allow-float', //允许两边浮动
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							expreDescField.focus();
						}
					}
				}
			});
			
			var editorbutton = new Ext.Toolbar.Button({
				text:'编辑',
				itemCls:'age-field',
				handler:function(){
					formula(node,1);
				}
			});
			
			expreDescField = new Ext.form.TextField({
				id:'expreDescField',
				fieldLabel: '公式描述',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写公式描述...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							colTypeStore.focus();
						}
					}
				}
			});
			
			var colTypeStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'录入'],["2",'计算'],["3",'无实际值'],["4",'采集']]
			});
			var colTypeField = new Ext.form.ComboBox({
				id: 'colTypeField',
				fieldLabel: '收集方式',
				listWidth : 285,
				selectOnFocus: true,
				allowBlank: false,
				store: colTypeStore,
				anchor: '90%',
				value:"1", //默认值
				valueNotFoundText:'录入',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'选择收集方式...',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			
			var scoreMethodStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["I",'区间法'],["C",'比较法'],["D",'扣分法'],["A",'加分法'],["M",'目标参照法']]
			});
			var scoreMethodField = new Ext.form.ComboBox({
				id: 'scoreMethodField',
				fieldLabel: '评分方法',
				listWidth : 285,
				selectOnFocus: true,
				allowBlank: false,
				store: scoreMethodStore,
				anchor: '90%',
				value:"I", //默认值
				valueNotFoundText:'区间法',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'选择评分方法...',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				//disabled:true,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
////////////////////////判断加分法扣分法计算方式////////////////////////			
		scoreMethodField.on('select',function(cmb,rec,id){
	
		if(cmb.getValue()=="D"||(cmb.getValue()=="A"))
		{
			calculationField.enable();
		
		}
		else
		{
			calculationField.setValue("");
			calculationField.disable();
		
		}
	
	});
			
			var calculationDs = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'增长率计算'],["2",'差额计算']]
			});
			var calculationField = new Ext.form.ComboBox({
				id: 'calculationField',
				fieldLabel: '计算方式(扣分法)',
				listWidth : 285,
				selectOnFocus: true,
				//allowBlank: false,
				store: calculationDs,
				anchor: '90%',
				//value:"1", //默认值
				
				displayField: 'keyValue',
				disabled:true,
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'计算方式...',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			
		
//////////////////////判断选择差额计算时极值不可用///////////////////////////////////

calculationField.on('select',function(cmb,rec,id){
	
		if(cmb.getValue()=="2")
		{
			extreMumField.setValue("");
			extreMumField.disable();
		
		
		}
		
		
	
	});		
			
////////////////////////////////////////////////////////////			
			var colDeptDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			colDeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=coldept&str='+Ext.getCmp('colDeptField').getRawValue(),method:'POST'})
			});

			var colDeptField = new Ext.form.ComboBox({
				id: 'colDeptField',
				fieldLabel: '收集部门',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: colDeptDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择收集部门...',
				name: 'colDeptField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(colDeptField.getValue()!=""){
								dataSourceField.focus();
							}else{
								Handler = function(){colDeptField.focus();}
								Ext.Msg.show({title:'错误',msg:'收集部门不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var dataSourceField = new Ext.form.TextField({
				id:'dataSourceField',
				fieldLabel: '数据来源',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写数据来源...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isHospKPIField.focus();
						}
					}
				}
			});
			
			var isHospKPIField = new Ext.form.Checkbox({
				id: 'isHospKPIField',
				fieldLabel:'医院 KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isDeptKPIField.focus();
						}
					}
				}
			});
			
			var isDeptKPIField = new Ext.form.Checkbox({
				id: 'isDeptKPIField',
				fieldLabel:'科室 KPI',
				clearCls:'stop-float',
				hideLabel:false,
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isMedKPIField.focus();
						}
					}
				}
			});
			
			var isMedKPIField = new Ext.form.Checkbox({
				id: 'isMedKPIField',
				fieldLabel:'医疗 KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isNurKPIField.focus();
						}
					}
				}
			});
			
			var isNurKPIField = new Ext.form.Checkbox({
				id: 'isNurKPIField',
				fieldLabel:'护理 KPI',
				clearCls:'stop-float',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isPostKPIField.focus();
						}
					}
				}
			});
			
			var isPostKPIField = new Ext.form.Checkbox({
				id: 'isPostKPIField',
				fieldLabel:'岗位 KPI',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isStopField.focus();
						}
					}
				}
			});
			
			var isStopField = new Ext.form.Checkbox({
				id: 'isStopField',
				fieldLabel:'是否停用',
				itemCls:'float-left',
				clearCls:'allow-float',
				hideLabel:false,
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isEndField.focus();
						}
					}
				}
			});
			
			var isEndField = new Ext.form.Checkbox({
				id: 'isEndField',
				fieldLabel:'末端标志',
				allowBlank: false,
				clearCls:'stop-float',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							orderField.focus();
						}
					},
					'check':function(checked){
                        if(checked.checked){
							//dimTypeField.enable();
							//scoreMethodField.enable();
							extreMumField.enable();
							calUnitField.enable();
							colDeptField.enable();
                        }else{
                           // dimTypeField.disable();
							//scoreMethodField.disable();
							extreMumField.disable();
							calUnitField.disable();
							colDeptField.disable();
                        }
                    }
				}
			});
			
			var orderField = new Ext.form.NumberField({
				id:'orderField',
				fieldLabel: '顺   序',
				allowBlank: false,
				minValue:0,
				selectOnFocus: true,
				emptyText:'顺序...',
				anchor: '90%',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isKPIField.focus();
						}
					}
				}
			});
			
			var isKPIField = new Ext.form.Checkbox({
				id: 'isKPIField',
				fieldLabel:'KPI 指标',
				allowBlank: false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							addButton.focus();
						}
					}
				}
			});
			
			//当末端标志为"Y"的时候,才显示所属维度和评分方法控件
			
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items: [
					nameField,
					codeField,
					pyField,
					dimTypeField,
					targetField,
					descField,
					calUnitField,
					expreField,
					editorbutton,
					expreDescField,
					colTypeField,
					scoreMethodField,
					
					calculationField,
	
					extreMumField,
					colDeptField,
					dataSourceField,
					//isHospKPIField,
					isDeptKPIField,
					//isMedKPIField,
					//isNurKPIField,
					//isPostKPIField,
					isStopField,
					isEndField,
					orderField,
					isKPIField
				]
			});	
			
			
			
			//定义添加按钮
			var addButton = new Ext.Toolbar.Button({
				text:'添加'
			});
			
			//添加处理函数
			var addHandler = function(){
				
				var name = nameField.getValue();
				var code = codeField.getValue();
				var py = pyField.getValue();
				var dimTypeDr = Ext.getCmp('dimTypeField').getValue();
				var target = targetField.getValue();
				var desc = descField.getValue();
				var calUnitDr = Ext.getCmp('calUnitField').getValue();
				var extreMum = Ext.getCmp('extreMumField').getValue();
				var expre = encodeURIComponent(Ext.encode(globalStr3));
				var expreDesc = expreDescField.getValue();
				var colTypeDr = Ext.getCmp('colTypeField').getValue();
				var scoreMethodCode = Ext.getCmp('scoreMethodField').getValue();
				var colDeptDr = Ext.getCmp('colDeptField').getValue();
				var dataSource = dataSourceField.getValue();
				var isHospKPI = (isHospKPIField.getValue()==true)?'Y':'N';
				var isDeptKPI = (isDeptKPIField.getValue()==true)?'Y':'N';
				var isMedKPI = (isMedKPIField.getValue()==true)?'Y':'N';
				var isNurKPI = (isNurKPIField.getValue()==true)?'Y':'N';
				var isPostKPI = (isPostKPIField.getValue()==true)?'Y':'N';
				var parent = 0;
				var level = 0;
				if(node.attributes.id!="roo"){
					parent = node.attributes.id;
					level = node.attributes.level;
				}
				var isStop = (isStopField.getValue()==true)?'Y':'N';
				var isEnd = (isEndField.getValue()==true)?'Y':'N';
				
				//计算方式
				var calculation = calculationField.getValue();
				
				if(isEnd=="Y"){
					dimTypeDr = trim(dimTypeDr);
					if(dimTypeDr==""){
						Ext.Msg.show({title:'提示',msg:'维度为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:200});
						return false;
					};
					scoreMethodCode = trim(scoreMethodCode);
					if(scoreMethodCode==""){
						Ext.Msg.show({title:'提示',msg:'评分方法为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
						return false;
					};
					calUnitDr = trim(calUnitDr);
					if(calUnitDr==""){
						Ext.Msg.show({title:'提示',msg:'计量单位为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
						return false;
					};
					
					/**
					//["I",'区间法'],["C",'比较法'],["D",'扣分法'],["A",'加分法'],["M",'目标参照法']
					if((scoreMethodCode=="I")||(scoreMethodCode=="A")||(scoreMethodCode=="D")){
						extreMum = trim(extreMum);
						if(extreMum==""){
							Ext.Msg.show({title:'提示',msg:'极值为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							return false;
						};
					}else{
						extreMum="";
					}
					**/
					//判断评分方法为  加分法或者扣分法  计算方式 是否为空
					if(scoreMethodCode=="D"){
						if(calculation==""){
							
								Ext.Msg.show({title:'提示',msg:'计算方式为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
								return false;
						}
					}
					
				}else{
					//dimTypeDr="";
					//scoreMethodCode="";
					extreMum="";
					calUnitDr="";
				}
				var order = orderField.getValue();
				var isKPI = (isKPIField.getValue()==true)?'Y':'N';
				name = trim(name);
				code = trim(code);
				if(name==""){
					Ext.Msg.show({title:'提示',msg:'指标名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				};
				var data = name+"^"+py+"^"+dimTypeDr+"^"+target+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+isHospKPI+"^"+isDeptKPI+"^"+isMedKPI+"^"+isNurKPI+"^"+isPostKPI+"^"+parent+"^"+level+"^"+isStop+"^"+isEnd+"^"+order+"^"+isKPI+"^"+code+"^"+calculation;
				
				Ext.Ajax.request({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=add&data='+data,
					waitMsg:'添加中..',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							Ext.getCmp('detailReport').getNodeById(node.attributes.id).reload();
						}else{
							if(jsonData.info=='RepName'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'名称重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='dataEmpt'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='ParamErr'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'参数数据有错,请修改参数表指标深度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
							if(jsonData.info=='null'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'你以前添加过错误数据,没有上级节点ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
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
				title: '添加指标记录窗口',
				width: 420,
				height:585,
				minWidth: 420,
				minHeight: 585,
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
		Ext.Msg.show({title:'错误',msg:'请选择要添加子节点的记录!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
	}
};
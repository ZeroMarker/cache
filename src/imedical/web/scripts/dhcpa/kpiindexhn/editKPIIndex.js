//修改函数
updateFun = function(node){
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//取该条记录的rowid
			var rowid = node.attributes.id;
			
			var isEnd = node.attributes.isEnd;
			if(isEnd=="Y"){
				var disabled=false;
			}else{
				var disabled=true;
			}
		
			var NameField = new Ext.form.TextField({
				id:'NameField',
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
							if(NameField.getValue()!=""){
								CodeField.focus();
							}else{
								Handler = function(){NameField.focus();}
								Ext.Msg.show({title:'错误',msg:'指标名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var CodeField = new Ext.form.TextField({
				id:'CodeField',
				fieldLabel: '指标代码',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请指标代码...',
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
				//allowBlank: false,
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
			
			var DimTypeDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			DimTypeDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					//url:'../csp/dhc.pa.kpiindexexe.csp?action=dimtype&str='+Ext.getCmp('DimTypeField').getRawValue(),method:'POST'})
					url:'../csp/dhc.pa.kpiindexexe.csp?action=dimtype',method:'POST'})
			});
		
			var DimTypeField = new Ext.form.ComboBox({
				id: 'DimTypeField',
				fieldLabel: '维度类别',
				width:285,
				listWidth : 285,
				allowBlank: false,
				store: DimTypeDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择维度类别...',
				valueNotFoundText:node.attributes.dimTypeName,
				name: 'DimTypeField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				//disabled:disabled,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(DimTypeField.getValue()!=""){
								TargetField.focus();
							}else{
								Handler = function(){DimTypeField.focus();}
								Ext.Msg.show({title:'错误',msg:'维度类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var TargetField = new Ext.form.TextField({
				id:'TargetField',
				fieldLabel: '评测目标',
				//allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写评测目标...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							DescField.focus();
						}
					}
				}
			});
			
			var DescField = new Ext.form.TextField({
				id:'DescField',
				fieldLabel: '指标描述',
				//allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写指标描述...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							CalUnitField.focus();
						}
					}
				}
			});
			
			var CalUnitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			CalUnitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=calunit&str='+Ext.getCmp('CalUnitField').getRawValue(),method:'POST'})
			});
			
			var CalUnitField = new Ext.form.ComboBox({
				id: 'CalUnitField',
				fieldLabel: '计量单位',
				width:285,
				listWidth : 285,
				//allowBlank: false,
				store: CalUnitDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				valueNotFoundText:node.attributes.calUnitName,
				triggerAction: 'all',
				emptyText:'请选择计量单位...',
				name: 'CalUnitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(CalUnitField.getValue()!=""){
								ExtreMumField.focus();
							}else{
								Handler = function(){CalUnitField.focus();}
								Ext.Msg.show({title:'错误',msg:'计量单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
//=====================================================================
			var ExtreMumStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["H",'趋高'],["M",'趋中'],["L",'趋低']]
			});
			var ExtreMumField = new Ext.form.ComboBox({
				id: 'ExtreMumField',
				fieldLabel: '极   值',
				listWidth : 285,
				selectOnFocus: true,
				//allowBlank: false,
				store: ExtreMumStore,
				anchor: '90%',
				valueNotFoundText:node.attributes.extreMumName,
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'极值...',
				mode: 'local', //本地模式
				editable:true,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							expreField.focus();
						}
					}
				}
			});
//=====================================================================
			expreField = new Ext.form.TextField({
				id:'expreField',
				fieldLabel: '计算公式',
				//allowBlank: false,
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
			
			var editorButton = new Ext.Toolbar.Button({
				text:'编辑',
				itemCls:'age-field',
				handler:function(){
					formula(node,2);
				}
			});
			
			expreDescField = new Ext.form.TextField({
				id:'expreDescField',
				fieldLabel: '公式描述',
				//allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写公式描述...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							ColTypeField.focus();
						}
					}
				}
			});
			
			var ColTypeStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'录入'],["2",'计算'],["3",'无实际值'],["4",'采集']]
			});
			var ColTypeField = new Ext.form.ComboBox({
				id: 'ColTypeField',
				fieldLabel: '收集方式',
				listWidth : 285,
				selectOnFocus: true,
				//allowBlank: false,
				store: ColTypeStore,
				anchor: '90%',
				//value:"1", //默认值
				valueNotFoundText:node.attributes.colTypeName,
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
			
			var ScoreMethodStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["I",'区间法'],["C",'比较法'],["D",'扣分法'],["A",'加分法'],["M",'目标参照法'],["K",'实际值法']]
			});
			var ScoreMethodField = new Ext.form.ComboBox({
				id: 'ScoreMethodField',
				fieldLabel: '评分方法',
				listWidth : 285,
				selectOnFocus: true,
				//allowBlank: false,
				store: ScoreMethodStore,
				anchor: '90%',
				//value:"I", //默认值
				valueNotFoundText:node.attributes.scoreMethodName,
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'选择评分方法...',
				mode: 'local', //本地模式
				disabled:disabled,
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			
			///////////////扣分法计算方式////////////////////
			
				ScoreMethodField.on('select',function(cmb,rec,id){
	
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
				data : [["1",'增长率计算'],["2",'增长量计算'],["3",'差额计算'],["4",'基础值上计算']]
			});
			var calculationField = new Ext.form.ComboBox({
				id: 'calculationField',
				fieldLabel: '计算方式(扣分法)',
				listWidth : 285,
				selectOnFocus: true,
				valueNotFoundText:node.attributes.calculationName,
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
			
			/////////////////////////////////////
			var ColDeptDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name','shortcut'])
			});

			ColDeptDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.kpiindexexe.csp?action=coldept&str='+Ext.getCmp('ColDeptField').getRawValue(),method:'POST'})
			});

			var ColDeptField = new Ext.form.ComboBox({
				id: 'ColDeptField',
				fieldLabel: '收集部门',
				width:285,
				listWidth : 285,
				//allowBlank: false,
				store: ColDeptDs,
				valueField: 'rowid',
				displayField: 'shortcut',
				triggerAction: 'all',
				emptyText:'请选择收集部门...',
				valueNotFoundText:node.attributes.colDeptName,
				name: 'ColDeptField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(ColDeptField.getValue()!=""){
								DataSourceField.focus();
							}else{
								Handler = function(){ColDeptField.focus();}
								Ext.Msg.show({title:'错误',msg:'收集部门不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			var DataSourceDs = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'同期值'],["2",'去年平均值']]
			});
			var DataSourceField = new Ext.form.ComboBox({
				id: 'DataSourceField',
				fieldLabel: '目标类型',
				listWidth : 285,
				selectOnFocus: true,
				valueNotFoundText:node.attributes.dataSourceName,
				//allowBlank: false,
				store: DataSourceDs,
				anchor: '90%',
				//value:"1", //默认值
				
				displayField: 'keyValue',
				disabled:true,
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'目标类型...',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			/*	
			var DataSourceField = new Ext.form.TextField({
				id:'DataSourceField',
				fieldLabel: '数据来源',
				//allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写数据来源...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isHospKPI.focus();
						}
					}
				}
			});
			*/
			var isHospKPI = new Ext.form.Checkbox({
				id: 'isHospKPI',
				fieldLabel:'医院 KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				allowBlank: false,
				checked:(node.attributes.isHospKPI)=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isDeptKPI.focus();
						}
					}
				}
			});
			
			var isDeptKPI = new Ext.form.Checkbox({
				id: 'isDeptKPI',
				fieldLabel:'科室 KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				hideLabel:false,
				allowBlank: false,
				checked:node.attributes.isDeptKPI=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isMedKPI.focus();
						}
					}
				}
			});
				
			var isMedKPI = new Ext.form.Checkbox({
				id: 'isMedKPI',
				fieldLabel:'医疗 KPI',
				itemCls:'float-left',
				clearCls:'allow-float',
				allowBlank: false,
				checked:node.attributes.isMedKPI=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isNurKPI.focus();
						}
					}
				}
			});
			
			var isNurKPI = new Ext.form.Checkbox({
				id: 'isNurKPI',
				fieldLabel:'护理 KPI',
				clearCls:'stop-float',
				allowBlank: false,
				checked:node.attributes.isNurKPI=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isPostKPI.focus();
						}
					}
				}
			});
				
			var isPostKPI = new Ext.form.Checkbox({
				id: 'isPostKPI',
				fieldLabel:'岗位 KPI',
				allowBlank: false,
				checked:node.attributes.isPostKPI=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isStop.focus();
						}
					}
				}
			});
			
			var isStop = new Ext.form.Checkbox({
				id: 'isStop',
				fieldLabel:'是否停用',
				itemCls:'float-left',
				clearCls:'allow-float',
				hideLabel:false,
				allowBlank: false,
				checked:node.attributes.isStop=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isEnd.focus();
						}
					}
				}
			});
			
			var isEnd = new Ext.form.Checkbox({
				id: 'isEnd',
				fieldLabel:'末端标志',
				allowBlank: false,
				clearCls:'stop-float',
				checked:node.attributes.isEnd=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							OrderField.focus();
						}
					},
					'check':function(checked){
                        if(checked.checked){
							//DimTypeField.enable();
							ScoreMethodField.enable();
							CalUnitField.enable();
							ExtreMumField.enable();
							ColDeptField.enable();
							DataSourceField.enable();
							OrderField.enable();
                        }else{
                           // DimTypeField.disable();
							ScoreMethodField.disable();
							CalUnitField.disable();
							ExtreMumField.disable();
							ColDeptField.disable();
							DataSourceField.disable();
							OrderField.disable();
                        }
                    }
				}
			});
			var orderDs = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'自动采集'],["2",'手工采集']]
			});
			var OrderField = new Ext.form.ComboBox({
				id: 'OrderField',
				fieldLabel:'采集方式(目标值)',
				listWidth : 285,
				selectOnFocus: true,
				valueNotFoundText:node.attributes.importType,
				//allowBlank: false,
				store: orderDs,
				anchor: '90%',
				//value:"1", //默认值
				
				displayField: 'keyValue',
				//disabled:true,
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'采集方式(目标值)...',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true
			});
			
			OrderField.on('select',function(cmb,rec,id){
	
			if(cmb.getValue()=="1")
			{
				DataSourceField.enable();
			
			}
			else
			{
				DataSourceField.setValue("");
				DataSourceField.disable();
		
			}
			});
			/*
			var OrderField = new Ext.form.NumberField({
				id:'OrderField',
				fieldLabel: '顺   序',
				//allowBlank: false,
				minValue:0,
				selectOnFocus: true,
				emptyText:'顺序...',
				anchor: '90%',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isKPI.focus();
						}
					}
				}
			});
			*/	
			var isKPI = new Ext.form.Checkbox({
				id: 'isKPI',
				fieldLabel:'KPI 指标',
				clearCls:'stop-float',
				allowBlank: false,
				checked:node.attributes.isKPI=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							addButton.focus();
						}
					}
				}
			});
			
			 if(node.attributes.isEnd=='Y'){
							//DimTypeField.enable();
							ScoreMethodField.enable();
							CalUnitField.enable();
							ExtreMumField.enable();
							ColDeptField.enable();
							DataSourceField.enable();
							OrderField.enable();
                        }else{
                           // DimTypeField.disable();
							ScoreMethodField.disable();
							CalUnitField.disable();
							ExtreMumField.disable();
							ColDeptField.disable();
							DataSourceField.disable();
							OrderField.disable();
                        }
            //alert(node.attributes.order);
            if(node.attributes.order=="1")
			{
				DataSourceField.enable();
			
			}
			else
			{
				
				DataSourceField.setValue("");
				DataSourceField.disable();
		
			}	
				
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 60,
				items: [
					NameField,
					CodeField,
					PYField,
					DimTypeField,
					TargetField,
					DescField,
					CalUnitField,
					ExtreMumField,
					expreField,
					editorButton,
					expreDescField,
					ColTypeField,
					ScoreMethodField,
					
					calculationField,
					
					ColDeptField,
					DataSourceField,
					//isHospKPI,
					isDeptKPI,
					isKPI,
					//isMedKPI,
					//isNurKPI,
					//isPostKPI,
					isStop,
					isEnd,
					OrderField
					
				]
			});	
		
			formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				NameField.setValue(node.attributes.name);
				CodeField.setValue(node.attributes.code);
				PYField.setValue(node.attributes.py);
				DimTypeField.setValue(node.attributes.dimTypeDr);
				TargetField.setValue(node.attributes.target);
				DescField.setValue(node.attributes.desc);
				CalUnitField.setValue(node.attributes.calUnitDr);
				ExtreMumField.setValue(node.attributes.extreMum);
				expreField.setValue(node.attributes.expName);
				expreDescField.setValue(node.attributes.expDesc);
				ColTypeField.setValue(node.attributes.colTypeDr);
				ScoreMethodField.setValue(node.attributes.scoreMethodCode);
				ColDeptField.setValue(node.attributes.colDeptDr);
				DataSourceField.setValue(node.attributes.dataSource);
				OrderField.setValue(node.attributes.order);
				globalStr3=node.attributes.expression;
				
				calculationField.setValue(node.attributes.calculationDr);
				
			});	
			
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			editHandler = function(){
				var code = CodeField.getValue();
				var name = NameField.getValue();
				var py = PYField.getValue();
				var dimTypeDr = Ext.getCmp('DimTypeField').getValue();
				var target = TargetField.getValue();
				var desc = DescField.getValue();
				var calUnitDr = Ext.getCmp('CalUnitField').getValue();
				var extreMum = Ext.getCmp('ExtreMumField').getValue();
				//var expre = encodeURIComponent(Ext.encode(globalStr3));
				var expre =globalStr3;  
		
				var expreDesc = expreDescField.getValue();
				var colTypeDr = Ext.getCmp('ColTypeField').getValue();
				var scoreMethodCode = Ext.getCmp('ScoreMethodField').getValue();
				var colDeptDr = Ext.getCmp('ColDeptField').getValue();
				var dataSource = DataSourceField.getValue();
				var IsHospKPI = (isHospKPI.getValue()==true)?'Y':'N';
				var IsDeptKPI = (isDeptKPI.getValue()==true)?'Y':'N';
				var IsMedKPI = (isMedKPI.getValue()==true)?'Y':'N';
				var IsNurKPI = (isNurKPI.getValue()==true)?'Y':'N';
				var IsPostKPI = (isPostKPI.getValue()==true)?'Y':'N';
				var parent = node.attributes.parent;
				var level = node.attributes.level;
				var IsStop = (isStop.getValue()==true)?'Y':'N';
				var IsEnd = (isEnd.getValue()==true)?'Y':'N';
				
				
				var calculation = calculationField.getValue();
			
				
				if(IsEnd=="Y"){
					dimTypeDr = trim(dimTypeDr);
					if(dimTypeDr==""){
						Ext.Msg.show({title:'提示',msg:'维度为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
						return false;
					};
					scoreMethodCode = trim(scoreMethodCode);
					if(scoreMethodCode==""){
						Ext.Msg.show({title:'提示',msg:'评分方法为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
						return false;
					};
					calUnitDr = trim(calUnitDr);
					if(calUnitDr==""){
						Ext.Msg.show({title:'提示',msg:'计量单位为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
						return false;
					};
					extreMum = trim(extreMum);
						if(extreMum==""){
							Ext.Msg.show({title:'提示',msg:'极值为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
							return false;
						};
					
					/**
					if((scoreMethodCode=="I")||(scoreMethodCode=="A")||(scoreMethodCode=="D")){
						extreMum = trim(extreMum);
						if(extreMum==""){
							Ext.Msg.show({title:'提示',msg:'极值为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
							return false;
						};
					}else{
						extreMum="";
					}
					**/
				}else{
				    //CalUnitField.disable();
					//dimTypeDr="";
					//scoreMethodCode="";
					calUnitDr="";
					extreMum="";
				}
				var order = OrderField.getValue();
				var IsKPI = (isKPI.getValue()==true)?'Y':'N';
				
				name = trim(name);
				code = trim(code);
				if(name==""){
					Ext.Msg.show({title:'提示',msg:'指标名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
				};
				if(order==1){
					if (dataSource=="")
					{
					Ext.Msg.show({title:'提示',msg:'指标名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
					}
				};
				
				var data =code+"^"+name+"^"+py+"^"+dimTypeDr+"^"+target+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+IsHospKPI+"^"+IsDeptKPI+"^"+IsMedKPI+"^"+IsNurKPI+"^"+IsPostKPI+"^"+parent+"^"+level+"^"+IsStop+"^"+IsEnd+"^"+order+"^"+IsKPI+"^"+calculation;
				//alert(data);
				data = trim(data);
				if(data==""){
					Ext.Msg.show({title:'提示',msg:'空数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};
		
				Ext.Ajax.request({
					url: '../csp/dhc.pa.kpiindexexe.csp?action=edit&data='+data+'&rowid='+rowid,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
							globalStr3="";
							expreField.setValue(""); //清空公式
							
							expre ="";  
							expreDescField.setValue("");
												
							if(node.attributes.parent==0){
								node.attributes.parent="roo";
							}
							Ext.getCmp('detailReport').getNodeById(node.attributes.parent).reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='RepName') message='指标名称重复!';
							if(jsonData.info=='dataEmpt') message='空数据!';
							if(jsonData.info=='rowidEmpt') message='数据有错!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
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
				title: '修改指标记录',
				width: 420,
				height:650,
				minWidth: 420,
				minHeight: 650,
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
edit=function(){

		//定义并初始化行对象
		//var rowObj=KPITargetTab.getSelections();
		var rowObj=KPITargetTab.getSelectionModel().getSelections();
		console.log(rowObj);
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		
		
	var unitFields = new Ext.form.ComboBox({
		id: 'unitField',
		fieldLabel: '指标名称',
		anchor: '90%',
		allowBlank: false,
		store: KPIIndexDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择指标...',
		name: 'unitField',
		minChars:1,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});	
/*
		var targetNameField = new Ext.form.ComboBox({
			id:'targetNameField',
			fieldLabel: '目标类型名称',
			editable:false,
			anchor: '90%',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','同期均值'],['2','年平均']]
			}),
			listeners :{
				select :function(field,e){
						if(targetNameField.getValue() =="1"){
							targetCodeField.setValue(1)
						}
						if(targetNameField.getValue() =="2"){
							targetCodeField.setValue(2)
						}
	
				}
			}		
		});
	
	*/
		var targetNameField=new Ext.form.RadioGroup({
			name:'targetNameField',
			fieldLabel:'目标类型名称',
			//columns: 4,
			items:[{
				boxLabel:'同期均值',
				inputValue:'1',
				name:'targetNameField',
				style:'height:14px;',
				checked:true
			},{
				boxLabel:'年平均',
				inputValue:'2',
				style:'height:14px;',
				name:'targetNameField'
			}],
			listeners :{
				change :function(radioGroupObj,checkedObj){
					//console.log(checkedObj);
					targetCodeField.setValue(checkedObj.inputValue);
				}
			}		
		});
		var targetCodeField = new Ext.form.TextField({
			id:'targetCodeField',
			fieldLabel: '目标类别代码',
			allowBlank: false,
			width:220,
			listWidth : 220,
			emptyText:'目标分类编码...',
			anchor: '90%',
			disabled:true
			
		});
		var coefficientField = new Ext.form.NumberField({
			id:'coefficientField',
			fieldLabel:'年数',
			allowBlank:false,
			emptyText:'年数...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			allowNegative:false,
			allowDecimals:false,
			name:'coefficient',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(coefficientField.getValue()!=""){
							changeNumField.focus();
						}else{
							Handler = function(){coefficientField.focus();}
							Ext.Msg.show({title:'错误',msg:'年数不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var changeNumField = new Ext.form.TextField({
			id:'changeNumField',
			fieldLabel: '增长率',
			width:180,
			listWidth : 180,
			emptyText:'增长率...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'changeNum',
			regex:/^(-)?[0-9]\.[0-9]{1,3}$/,
			regexText:'请输入小数',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				unitFields,
				targetNameField,
				targetCodeField,
				coefficientField,
				changeNumField
			]
		});
	
		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			targetNameField.setValue(rowObj[0].get("targetCode"));
			targetCodeField.setValue(rowObj[0].get("targetCode"));
			unitFields.setValue(rowObj[0].get("kpiDr"));
			//alert(rowObj[0].get("kpiDr"));
		});
		
		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	
		//定义修改按钮响应函数
		editHandler = function(){
			var kpiDr = unitFields.getValue();
			var kpiname = unitFields.getRawValue();
			
			if(kpiDr==kpiname){
				kpiDr="";
				}
			
			//var targetName = targetNameField.getValue();
			var targetName = formPanel.getForm().findField('targetNameField').getValue().boxLabel;
			var targetNamecode = targetNameField.getRawValue();
			if(targetName==targetNamecode){
				targetName="";
				}
			var targetCode = targetCodeField.getValue();
			var coefficient = coefficientField.getValue();
			var changeNum = changeNumField.getValue();
			kpiDr = trim(kpiDr);
			targetName = trim(targetName);
			targetCode = trim(targetCode);
		
			if(targetCode==""){
				Ext.Msg.show({title:'错误',msg:'目标分类编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(changeNumField.isValid()==false){
				Ext.Msg.show({title:'错误',msg:'增长率格式错误:应填入小数',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: '../csp/dhc.pa.nYearKPITargetexe.csp?action=edit&rowid='+rowid+'&kpiDr='+kpiDr+'&targetName='+targetName+'&targetCode='+targetCode+'&coefficient='+coefficient+'&changeNum='+changeNum,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){unitField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						KPITargetTabDs.load({params:{start:0,limit:KPITargetTabPagingToolbar.pageSize}});
						editwin.close();
					}
						if(jsonData.info=='RepkpiDr'){
							Handler = function(){targetCodeField.focus();}
							Ext.Msg.show({title:'错误',msg:'指标已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						
					
				},
				scope: this
			});
		}
	
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消修改'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改目标分类记录',
			width: 380,
			height:260,
			minWidth: 380, 
			minHeight: 260,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//窗口显示
		editwin.show();
}

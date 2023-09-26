add=function(){
	var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '指标名称',
	anchor: '90%',
	//allowBlank: false,
	store: KPIIndexDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择指标...',
	name: 'unitField',
	minChars: 1,
	//pageSize: 10,
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
				'select' :function(field,e){
					
					if(targetNameField.getValue() =="1"){
						targetCodeField.setValue(1);
						coefficientField.focus();
					}
					if(targetNameField.getValue() =="2"){
						targetCodeField.setValue(2);
						coefficientField.focus();
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
			fieldLabel:'目标类型代码',
			allowBlank:false,
			emptyText:'目标类型的代码...',
			anchor:'90%',
			width:220,
			listWidth:220,
			selectOnFocus:true,
			disabled:true,
			value:"1"
			
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
			emptyText:'请填入小数',
			anchor: '90%',
			selectOnFocus:'true',
			regex:/^(-)?[0-9]\.[0-9]{1,3}$/,
			regexText:'请输入小数',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});
		
		
		//初始化面板
		formPanels = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				unitField,
				targetNameField,
				targetCodeField,
				coefficientField,
				changeNumField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
			var kpiDr = unitField.getValue();
			var targetName = formPanels.getForm().findField('targetNameField').getValue().boxLabel;;
			//alert(targetName);
			var targetCode = targetCodeField.getValue();
			var coefficient = coefficientField.getValue();
			var changeNum = changeNumField.getValue();
			kpiDr = trim(kpiDr);
			targetName = trim(targetName);
			targetCode = trim(targetCode);
			if(kpiDr==""){
				Ext.Msg.show({title:'错误',msg:'指标名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(targetName==""){
				Ext.Msg.show({title:'错误',msg:'目标分类名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(coefficient==""){
				Ext.Msg.show({title:'错误',msg:'年数为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			if(changeNumField.isValid()==false){
				Ext.Msg.show({title:'错误',msg:'增长率格式错误:应填入小数',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			//alert('code='+code+'&name='+name+'&order='+order+'&appSysDr='+appSysDr+'&desc='+desc);
			Ext.Ajax.request({
				url: '../csp/dhc.pa.nYearKPITargetexe.csp?action=add&kpiDr='+kpiDr+'&targetName='+targetName+'&targetCode='+targetCode+'&coefficient='+coefficient+'&changeNum='+changeNum,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){unitField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){unitField.focus();}
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						KPITargetTabDs.load({params:{start:0,limit:KPITargetTabPagingToolbar.pageSize}});
					}else{
						if(jsonData.info=='RepkpiDr'){
							Handler = function(){targetCodeField.focus();}
							Ext.Msg.show({title:'错误',msg:'此指标已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						
					}
				},
				scope: this
			});
		}
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwins.close();
		}
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwins = new Ext.Window({
			title: '添加目标分类记录',
			width: 380,
			height:250,
			minWidth: 380, 
			minHeight: 250,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanels,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//窗口显示
		addwins.show();
	
};
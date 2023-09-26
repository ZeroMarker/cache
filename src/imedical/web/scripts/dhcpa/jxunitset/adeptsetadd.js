addFun = function(parent,dataStore,pagingTool){
    var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: '代码',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'请填写代码...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'错误',msg:'代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: '名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'请填写名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							pyField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

        var pyField = new Ext.form.TextField({
			id:'pyField',
			fieldLabel: '拼音',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'请填写拼音...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						remarkField.focus();
					}
				}
			}
		});

		var remarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '备注',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'请填写备注...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						endField.focus();
					}
				}
			}
		});

    var endField = new Ext.form.Checkbox({
		id: 'endField',
		fieldLabel: '末端标志',
		allowBlank: false,
		//checked: (rowObj[0].data['end'])=='Y'?true:false,
        selectOnFocus:'true',
        listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					orderField.focus();
				}
			}
		}
	});

	var orderField = new Ext.form.NumberField({
		id:'orderField',
    	fieldLabel:'顺序',
    	allowBlank:false,
    	emptyText:'顺序...',
    	anchor:'90%',
		width:220,
		listWidth:220,
		selectOnFocus:true,
		allowNegative:false,
		allowDecimals:false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(orderField.getValue()!=""){
						addButton.focus();
					}else{
						Handler = function(){orderField.focus();}
						Ext.Msg.show({title:'错误',msg:'顺序不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

		//面板????
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				codeField,
				nameField,
                pyField,
                remarkField,
                endField,
                orderField
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
            var shortcut=code+"-"+name;
            var remark = remarkField.getValue();
            var endAction = (endField.getValue()==true)?'Y':'N';
            var order =  orderField.getValue();
            var flag = "";
            if (type=="0"){
				if(parent==0){flag="0";}
			}else{
				if(parent==0){flag="1";}
			}
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'提示',msg:'代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'提示',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            var data=code+"^"+name+"^"+py+"^"+shortcut+"^"+remark+"^"+endAction+"^"+parent+"^"+order+"^"+flag;
            if(data==""){
                Ext.Msg.show({title:'提示',msg:'数据为空,不能添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
            }
			Ext.Ajax.request({
				url: deptSetUrl+'?action=add&data='+data,
				waitMsg:'添加中..',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
						dataStore.load({params:{start:0, limit:pagingTool.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'提示',msg:'同根下代码重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
                        if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'提示',msg:'同根下名称重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='dataEmpt'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'提示',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='unParnet'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'提示',msg:'上级节点为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			title: '添加'+rooText+'窗口',
			width: 400,
			height:250,
			minWidth: 400,
			minHeight: 250,
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
};
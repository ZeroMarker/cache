addDeptFun = function(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef){
     var orderField = new Ext.form.NumberField({
		id:'orderField',
    	fieldLabel:'部门顺序',
    	allowBlank:false,
    	emptyText:'部门顺序...',
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
						unitTypeField.focus();
					}else{
						Handler = function(){orderField.focus();}
						Ext.Msg.show({title:'错误',msg:'部门顺序不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

    var unitTypeDs = new Ext.data.Store({
            autoLoad:true,
            proxy:"",
            reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','remark','flag','active'])
        });

        unitTypeDs.on('beforeload', function(ds, o){
            ds.proxy=new Ext.data.HttpProxy({
                url:deptSetUrl+'?action=unittype&searchValue='+Ext.getCmp('unitTypeField').getRawValue()+'&active=Y',method:'POST'})
        });

        var unitTypeField = new Ext.form.ComboBox({
            id: 'unitTypeField',
            fieldLabel: '单位类别',
            width:213,
            listWidth : 213,
            allowBlank: false,
            store: unitTypeDs,
            valueField: 'rowid',
            displayField: 'name',
            triggerAction: 'all',
            emptyText:'请选择单位类别...',
            name: 'unitTypeField',
            minChars: 1,
            pageSize: 10,
            selectOnFocus:true,
            forceSelection:'true',
            editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(unitTypeField.getValue()!=""){
							unitField.focus();
						}else{
							Handler = function(){unitTypeField.focus();}
							Ext.Msg.show({title:'错误',msg:'单位类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
        });

        var unitDs = new Ext.data.Store({
            autoLoad:true,
            proxy:"",
            reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','py','shortcut','address','phone','contact','remark','unitTypeDr','active'])
        });

        unitDs.on('beforeload', function(ds, o){
            ds.proxy=new Ext.data.HttpProxy({
                url:deptSetUrl+'?action=unit&searchValue='+Ext.getCmp('unitField').getRawValue()+'&unittypedr='+Ext.getCmp('unitTypeField').getValue()+'&active=Y',method:'POST'})
        });

        var unitField = new Ext.form.ComboBox({
            id: 'unitField',
            fieldLabel: '所属单位',
            width:213,
            listWidth : 213,
            allowBlank: false,
            store: unitDs,
            valueField: 'rowid',
            displayField: 'name',
            triggerAction: 'all',
            emptyText:'请选择所属单位...',
            name: 'unitField',
            minChars: 1,
            pageSize: 10,
            selectOnFocus:true,
            forceSelection:'true',
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
            reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','shortcut','parref'])
        });

        deptDs.on('beforeload', function(ds, o){
            ds.proxy=new Ext.data.HttpProxy({
                url:deptSetUrl+'?action=dept&searchValue='+Ext.getCmp('deptField').getRawValue()+'&unitDr='+Ext.getCmp('unitField').getValue()+'&deptSetDr='+parRef,method:'POST'})
        });

        var deptField = new Ext.form.ComboBox({
            id: 'deptField',
            fieldLabel: '实体部门',
            width:213,
            listWidth : 213,
            allowBlank: false,
            store: deptDs,
            valueField: 'rowid',
            displayField: 'shortcut',
            triggerAction: 'all',
            emptyText:'请选择实体部门...',
            name: 'deptField',
            minChars: 1,
            pageSize: 10,
            selectOnFocus:true,
            forceSelection:'true',
            editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(deptField.getValue()!=""){
							recFlag.focus();
						}else{
							Handler = function(){deptField.focus();}
							Ext.Msg.show({title:'错误',msg:'实体部门不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
        });

   unitTypeField.on("select",function(cmb,rec,id ){
		unitField.setRawValue("");
		unitField.setValue("");
		deptField.setValue("");
		unitDs.load({params:{start:0, limit:cmb.pageSize}});
	});
	unitField.on("select",function(cmb,rec,id ){
			deptDs.load({params:{start:0, limit:deptField.pageSize}});
	});


    var recFlag = new Ext.form.Checkbox({
		id: 'recFlag',
		fieldLabel: '接受标志',
		allowBlank: false,
		checked:true,
        listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
                    distFlag.focus();
				}
			}
		}
	});
	var distFlag = new Ext.form.Checkbox({
		id: 'distFlag',
		fieldLabel: '分摊标志',
		allowBlank: false,
		checked:true,
        listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
                    addButton.focus();
				}
			}
		}
	});
	
	if(type==0){
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
                orderField,
				unitTypeField,
				unitField,
                deptField,
                recFlag,
                distFlag
			]
		});
	}else{
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
                orderField,
				unitTypeField,
				unitField,
                deptField
			]
		});
	}

		//定义添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添加'
		});

		//添加处理函数
		addHandler = function(){
			var order = orderField.getValue();
            var deptDr = Ext.getCmp('deptField').getValue();
			if(type==0){
				var recflag = (recFlag.getValue()==true)?'Y':'N';
				var distflag = (distFlag.getValue()==true)?'Y':'N';
			}
            var parref=parRef;

			if(order==""){
				Ext.Msg.show({title:'提示',msg:'顺序为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            if(deptDr==""){
				Ext.Msg.show({title:'提示',msg:'部门为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};

            if(parref==""){
				Ext.Msg.show({title:'提示',msg:'成本核算分层套为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            if(type==0){
				var data=parref+"^"+order+"^"+deptDr+"^"+recflag+"^"+distflag;
			}else{
				var data=parref+"^"+order+"^"+deptDr+"^^";
			}
            if(data==""){
				Ext.Msg.show({title:'提示',msg:'数据为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: deptSetUrl+'?action=adddept&data='+data,
				waitMsg:'数据添加中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){orderField.focus();}
						Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
					    ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:""}});
                        deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:""}});
					}else{
							if(jsonData.info=='RepDept'){
							Handler = function(){deptField.focus();}
							Ext.Msg.show({title:'提示',msg:'同根下部门重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				},
				scope: this
			});
		}

		//添加按钮的响应事件
		addButton.addListener('click',addHandler,false);

		//定义取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});

		//取消处理函数
		cancelHandler = function(){
			win.close();
		}

		//取消按钮的响应事件
		cancelButton.addListener('click',cancelHandler,false);

		if(type==0){
			var width=380;
		}else{
			var width=380
		}
		
		if(type==0){
			var height=280;
		}else{
			var height=200
		}
		
		var win = new Ext.Window({
			title: '添加分层部门窗口',
			width: width,
			height:height,
			minWidth: 380,
			minHeight: 280,
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
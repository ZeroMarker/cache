editDeptFun = function(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef){
    var rowObj = formPanel.getSelectionModel().getSelections();
        var len = rowObj.length;

        if(len < 1){
            Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            return;
        }
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
        name:'order',
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
            displayField: 'shortcut',
            valueNotFoundText:rowObj[0].get("unitTypeName"),
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
            displayField: 'shortcut',
            valueNotFoundText:rowObj[0].get("unitName"),
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
            valueNotFoundText:rowObj[0].get("deptName"),
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
							recField.focus();
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


    var recField = new Ext.form.Checkbox({
		id: 'recField',
		fieldLabel: '接受标志',
		allowBlank: false,
		checked: (rowObj[0].data['recFlag'])=='Y'?true:false,
        listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
                    distField.focus();
				}
			}
		}
	});
	var distField = new Ext.form.Checkbox({
		id: 'distField',
		fieldLabel: '分摊标志',
		allowBlank: false,
		checked: (rowObj[0].data['distFlag'])=='Y'?true:false,
        listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
                    editButton.focus();
				}
			}
		}
	});
   //面板
	if(type==0){
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
                orderField,
				unitTypeField,
				unitField,
                deptField,
                recField,
                distField
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

    formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
        deptField.setValue(rowObj[0].get("deptDr"));
        unitTypeField.setValue(rowObj[0].get("unitTypeDr"));
        unitField.setValue(rowObj[0].get("unitDr"));
	});


    editButton = new Ext.Toolbar.Button({
		text:'修改'
	});

    //添加处理函数??
	editHandler = function(){
      	var order = orderField.getValue();
            var deptDr = Ext.getCmp('deptField').getValue();
			if(type==0){
				var recflag = (recField.getValue()==true)?'Y':'N';
				var distflag = (distField.getValue()==true)?'Y':'N';
			}

            var rowid=rowObj[0].get("rowid");
			if(deptDr==""){
				Ext.Msg.show({title:'提示',msg:'部门为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(order==""){
				Ext.Msg.show({title:'提示',msg:'顺序为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(type==0){
				var data=order+"^"+deptDr+"^"+recflag+"^"+distflag;
			}else{
				var data=order+"^"+deptDr+"^"+"^"+"^"+"^";
			}
            if(data==""){
                Ext.Msg.show({title:'提示',msg:'数据为空,不能添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
            }
        if (formPanel.form.isValid()) {
			Ext.Ajax.request({
				url: deptSetUrl+'?action=editdept&rowid='+rowid+'&data='+data,
				waitMsg:'数据修改中...',
			    failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
					    Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
					    ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:""}});
                        deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:""}});
						window.close();
					}else{
						if(jsonData.info=='RepCode') message='同根下代码重复!';
						if(jsonData.info=='RepName') message='同根下名称重复!';
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
        }else{
		    Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
    };
    //添加按钮的响应事件
	editButton.addListener('click',editHandler,false);
    //定义取消按钮
	cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});

	//取消处理函数
	cancelHandler = function(){
	    window.close();
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

    // define window and show it in desktop
    var window = new Ext.Window({
  	    title: '修改实体部门记录',
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
        buttons: [editButton,cancelButton]
    });

    window.show();
};
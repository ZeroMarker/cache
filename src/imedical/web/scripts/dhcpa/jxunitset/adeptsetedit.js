editFun = function(ds,grid,pagingToolbar){
    var rowObj = grid.getSelections();
	var len = rowObj.length;

	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
        parent= rowObj[0].get("parent");
	}

    var codeField = new Ext.form.TextField({
        id:'codeField',
        fieldLabel: '代码',
        allowBlank: false,
        width:150,
        listWidth : 150,
        emptyText:'请填写代码...',
        anchor: '90%',
        name:'code',
        selectOnFocus:'true',
        listeners :{
            specialKey :function(field,e){
                if (e.getKey() == Ext.EventObject.ENTER){
                    if(codeField.getValue()!=""){
                        nameField.focus();
                    }else{
                        Handler = function(){codeField.focus();}
                        message='代码不能为空!';
                        Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
        name:'name',
        listeners :{
            specialKey :function(field,e){
                if (e.getKey() == Ext.EventObject.ENTER){
                    if(nameField.getValue()!=""){
                        pyField.focus();
                    }else{
                        Handler = function(){nameField.focus();}
						message='名称不能为空!';
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
            name:'py',
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
        name:'remark',
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
		checked: (rowObj[0].data['end'])=='Y'?true:false,
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
        name:'order',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(orderField.getValue()!=""){
						editButton.focus();
					}else{
						Handler = function(){orderField.focus();}
						Ext.Msg.show({title:'错误',msg:'顺序不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var formPanel = new Ext.form.FormPanel({
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

	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});


    editButton = new Ext.Toolbar.Button({
		text:'修改'
	});

    //添加处理函数??
	editHandler = function(){
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
        if (formPanel.form.isValid()) {
			Ext.Ajax.request({
				url: deptSetUrl+'?action=edit&data='+data+'&rowid='+rowid,
				waitMsg:'修改中..',
			    failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
					    Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
						ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
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


    // define window and show it in desktop
    var window = new Ext.Window({
  	    title: '修改'+rooText+'记录',
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
        buttons: [editButton,cancelButton]
    });

    window.show();
}

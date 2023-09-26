addDeptFun = function(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef){
     var orderField = new Ext.form.NumberField({
		id:'orderField',
    	fieldLabel:'����˳��',
    	allowBlank:false,
    	emptyText:'����˳��...',
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
						Ext.Msg.show({title:'����',msg:'����˳����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
            fieldLabel: '��λ���',
            width:213,
            listWidth : 213,
            allowBlank: false,
            store: unitTypeDs,
            valueField: 'rowid',
            displayField: 'name',
            triggerAction: 'all',
            emptyText:'��ѡ��λ���...',
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
							Ext.Msg.show({title:'����',msg:'��λ�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
            fieldLabel: '������λ',
            width:213,
            listWidth : 213,
            allowBlank: false,
            store: unitDs,
            valueField: 'rowid',
            displayField: 'name',
            triggerAction: 'all',
            emptyText:'��ѡ��������λ...',
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
							Ext.Msg.show({title:'����',msg:'������λ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
            fieldLabel: 'ʵ�岿��',
            width:213,
            listWidth : 213,
            allowBlank: false,
            store: deptDs,
            valueField: 'rowid',
            displayField: 'shortcut',
            triggerAction: 'all',
            emptyText:'��ѡ��ʵ�岿��...',
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
							Ext.Msg.show({title:'����',msg:'ʵ�岿�Ų���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
		fieldLabel: '���ܱ�־',
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
		fieldLabel: '��̯��־',
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

		//������Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'���'
		});

		//��Ӵ�����
		addHandler = function(){
			var order = orderField.getValue();
            var deptDr = Ext.getCmp('deptField').getValue();
			if(type==0){
				var recflag = (recFlag.getValue()==true)?'Y':'N';
				var distflag = (distFlag.getValue()==true)?'Y':'N';
			}
            var parref=parRef;

			if(order==""){
				Ext.Msg.show({title:'��ʾ',msg:'˳��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            if(deptDr==""){
				Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};

            if(parref==""){
				Ext.Msg.show({title:'��ʾ',msg:'�ɱ�����ֲ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            if(type==0){
				var data=parref+"^"+order+"^"+deptDr+"^"+recflag+"^"+distflag;
			}else{
				var data=parref+"^"+order+"^"+deptDr+"^^";
			}
            if(data==""){
				Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: deptSetUrl+'?action=adddept&data='+data,
				waitMsg:'���������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){orderField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
					    ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:""}});
                        deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:""}});
					}else{
							if(jsonData.info=='RepDept'){
							Handler = function(){deptField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'ͬ���²����ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				},
				scope: this
			});
		}

		//��Ӱ�ť����Ӧ�¼�
		addButton.addListener('click',addHandler,false);

		//����ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});

		//ȡ��������
		cancelHandler = function(){
			win.close();
		}

		//ȡ����ť����Ӧ�¼�
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
			title: '��ӷֲ㲿�Ŵ���',
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
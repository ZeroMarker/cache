editFun = function(ds,grid,pagingToolbar){
    var rowObj = grid.getSelections();
	var len = rowObj.length;

	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
        parent= rowObj[0].get("parent");
	}

    var codeField = new Ext.form.TextField({
        id:'codeField',
        fieldLabel: '����',
        allowBlank: false,
        width:150,
        listWidth : 150,
        emptyText:'����д����...',
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
                        message='���벻��Ϊ��!';
                        Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
                    }
                }
		    }
        }
    });

    var nameField = new Ext.form.TextField({
        id:'nameField',
        fieldLabel: '����',
        allowBlank: false,
        width:180,
        listWidth : 180,
        emptyText:'����д����...',
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
						message='���Ʋ���Ϊ��!';
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

    var pyField = new Ext.form.TextField({
			id:'pyField',
			fieldLabel: 'ƴ��',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����дƴ��...',
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
		fieldLabel: '��ע',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'����д��ע...',
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
		fieldLabel: 'ĩ�˱�־',
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
    	fieldLabel:'˳��',
    	allowBlank:false,
    	emptyText:'˳��...',
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
						Ext.Msg.show({title:'����',msg:'˳����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
		text:'�޸�'
	});

    //��Ӵ�����??
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
				Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            var data=code+"^"+name+"^"+py+"^"+shortcut+"^"+remark+"^"+endAction+"^"+parent+"^"+order+"^"+flag;
            if(data==""){
                Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��,�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
            }
        if (formPanel.form.isValid()) {
			Ext.Ajax.request({
				url: deptSetUrl+'?action=edit&data='+data+'&rowid='+rowid,
				waitMsg:'�޸���..',
			    failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
					    Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
						ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
						window.close();
					}else{
						if(jsonData.info=='RepCode') message='ͬ���´����ظ�!';
						if(jsonData.info=='RepName') message='ͬ���������ظ�!';
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
        }else{
		    Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
    };
    //��Ӱ�ť����Ӧ�¼�
	editButton.addListener('click',editHandler,false);
    //����ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});

	//ȡ��������
	cancelHandler = function(){
	    window.close();
	}

	//ȡ����ť����Ӧ�¼�
	cancelButton.addListener('click',cancelHandler,false);


    // define window and show it in desktop
    var window = new Ext.Window({
  	    title: '�޸�'+rooText+'��¼',
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

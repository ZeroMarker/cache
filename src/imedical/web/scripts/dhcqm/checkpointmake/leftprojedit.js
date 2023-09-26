
editProjFun = function(dataStore,grid) {
	
   	//���岢��ʼ���ж���
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		var rowid = rowObj[0].get("rowid");
		var linker = rowObj[0].get("linker");
	}
			
	var nameDs = new Ext.data.Store({   //��������Դ
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'	
		},['Rowid','name']),
		remoteSort: true	
	});	

		nameDs.on('beforeload',function(ds,o){  //����Դ�����������ú�̨�෽����ѯ����
		
			ds.proxy = new Ext.data.HttpProxy({
				url:'dhc.qm.checkpointmakeexe.csp'+'?action=listcheckproj&fuzzyquery='+encodeURIComponent(Ext.getCmp('linkerField').getRawValue()),method:'POST'
			 });	
		});	

		var rowObj=itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{	

			var rowid = rowObj[0].get("rowid");
			var code =rowObj[0].get("schemcode");
			var name =rowObj[0].get("schemname");
			var linker =rowObj[0].get("linker");
			
			var active = rowObj[0].get("active");
			var checkType =rowObj[0].get("checkType");
			var importType =rowObj[0].get("importType");
			var schemeType =rowObj[0].get("schemeType");
		}
		var rowField = new Ext.form.TextField({
			id: 'rowid',
			fieldLabel: 'ID',
			width:25,
			//listWidth : 220,
			triggerAction: 'all',
			emptyText:'',
			//name: 'CodeField',
			minChars: 1,
			pageSize: 10,
			editable:true
		});
		var CodeField = new Ext.form.TextField({
			id: 'CodeField',
			fieldLabel: '��Ŀ����',
			width:325,
			//listWidth : 300,
			triggerAction: 'all',
			emptyText:'',
			//name: 'CodeField',
			minChars: 1,
			pageSize: 10,
			editable:true
		});
		var NameField = new Ext.form.TextField({
			id: 'NameField',
			fieldLabel: '��Ŀ����',
			width:325,
			//listWidth : 300,
			triggerAction: 'all',
			emptyText:'',
			//name: 'NameField',
			minChars: 1,
			pageSize: 10,
			editable:true
		});
		var linkerField = new Ext.form.ComboBox({
			id: 'linkerField',
			fieldLabel: '����ҽ��',
			width:305,
			listWidth : 305,
			//allowBlank: false,
			store: nameDs,
			valueField: 'Rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ��ҽ��...',
			//name: 'linkerField',
			minChars: 1,
			pageSize: 500,
			selectOnFocus:true,
			forceSelection:'true',
			//showSelectAll :false,
			//typeAhead : true
			editable:true
						
		});
	
		var eChkUserGrid = new Ext.grid.GridPanel({
			id:'eChkUserGrid',
			store: new Ext.data.Store({
			autoLoad:true,
			proxy: new Ext.data.HttpProxy({
			url:'dhc.qm.checkpointmakeexe.csp'+'?action=listleftedit&start='+0+'&limit='+99999+'&rowid='+rowid,
			method:'POST'}),
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['Rowid','name'])

			}),
			colModel: new Ext.grid.ColumnModel({
				defaults: {
					width: 50,
					sortable: true
				},
				columns: [
					{id: 'Rowid', header: 'ҽ��ID', width: 18, sortable: true, dataIndex: 'Rowid',hidden:true},
					{header: 'ҽ������', dataIndex: 'name',align:'center',width: 350}
				]
			}),
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			width: 408,
			height: 130,
			viewConfig:{
				forceFit:true
			}
	
	//plugins:[rowEditing]
	//tbar:[{text:'���',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
		});
///////////////��Ӷ��ҽ����ť////////////////
	var addeParticipants  = new Ext.Button({
		text: '��ӹ���ҽ��',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('linkerField').getValue();
			var ChkName = Ext.getCmp('linkerField').getRawValue();
			//alert("id:"+id);
			var ptotal = eChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = eChkUserGrid.getStore().getAt(i).get('Rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'����',msg:'��ѡ������ͬ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'��ʾ',msg:'��ѡ����Ҫ��ӵ�ҽ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ��ӵ�ҽ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'Rowid':ChkUserId,'name':ChkName});
			eChkUserGrid.stopEditing(); 
			eChkUserGrid.getStore().insert(0,data);
		}
	});	
	var deleParticipants = new Ext.Button({
		text:'ɾ������ҽ��',
		style:'margin-left:5px;padding:0 5px 0 5px;',
		handler: function() {  
			var rows = eChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����ҽ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = eChkUserGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				eChkUserGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}		
		}
	});
	//=====================2016-04-11 ���=====================//
	var activeRadioGroup=new Ext.form.RadioGroup({
		name:'activeRadio',
		columns: 4,
		fieldLabel:'��Ŀ�Ƿ�����',
		items:[{

			boxLabel:'����',
			inputValue:'Y',
			style:'height:14px;',
			name:'activeRadio'
			
		},{
			boxLabel:'����',
			inputValue:'N',
			style:'height:14px;',
			name:'activeRadio'
		}]
	});
	var schemeTypeRadioGroup=new Ext.form.RadioGroup({
		name:'schemeTypeRadio',
		fieldLabel:'��Ŀ��������',
		columns: 4,
		items:[{
			boxLabel:'�·�',
			inputValue:'M',
			style:'height:14px;',
			name:'schemeTypeRadio'
		
		},{
			boxLabel:'����',
			inputValue:'Q',
			style:'height:14px;',
			name:'schemeTypeRadio'
		},{
			boxLabel:'����',
			inputValue:'H',
			style:'height:14px;',
			name:'schemeTypeRadio'
			
		},{
			boxLabel:'ȫ��',
			inputValue:'Y',
			style:'height:14px;',
			name:'schemeTypeRadio'
		}]
	});
	var importTypeRadioGroup=new Ext.form.RadioGroup({
		name:'importTypeRadio',
		fieldLabel:'������Դ����',
		columns: 4,
		items:[{
			boxLabel:'���Զ�',
			inputValue:'2',
			style:'height:14px;',
			name:'importTypeRadio'
			
		},{
			boxLabel:'�ƶ���',
			inputValue:'1',
			style:'height:14px;',
			name:'importTypeRadio'
		}]
	});
	var checkTypeRadioGroup=new Ext.form.RadioGroup({
		name:'checkTypeRadio',
		fieldLabel:'��Ŀ��¼����',
		columns: 4,
		items:[{
			boxLabel:'���ϸ��¼',
			inputValue:'1',
			style:'height:14px;',
			name:'checkTypeRadio'
			
		},{
			boxLabel:'ȫ����¼',
			inputValue:'2',
			style:'height:14px;',
			name:'checkTypeRadio'
		},{
			boxLabel:'�������',
			inputValue:'3',
			style:'height:14px;',
			name:'checkTypeRadio'
		}]
	});
	var checkTypeBZ=new Ext.form.DisplayField({
		value:'<span style="color:red;"></span><span style="color:red;">�����ϸ��¼��</span><span style="color:;">��ʾ��һ����¼����һ��Ϊ����������¼���ϸ�'+
						'</br><span style="color:red;">��ȫ����¼��&nbsp;&nbsp;&nbsp;</span>��ʾ����������ݣ���Ϊ���ϸ��¼;</br><span style="color:red;">��������㡱</span>��ʾ����¼�����������������ʱ��Ϊ�������¼��'
	});
	//========================================================//

	var colItems =[
			 CodeField,
			 NameField,
			 activeRadioGroup,
			 importTypeRadioGroup,
			 schemeTypeRadioGroup,
			 checkTypeRadioGroup,
			 {columnWidth : .9,
			 xtype: 'fieldset',
			 layout : "column",
			 title:'��ʾ',
			 items : [
				checkTypeBZ
			 ]},
			 {//����ҽ��
				columnWidth:.9,
				xtype:'fieldset',
				title:'����ҽ��',
				items:[
					linkerField,
					{
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [
						addeParticipants,
						deleParticipants
					]
					},
					eChkUserGrid
				]	
				} 
		]


var formPanel = new Ext.form.FormPanel({
				labelWidth:90,
				frame: true,
				items:colItems
			});
		                                                                                           //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
			//this.getForm().loadRecord(rowObj[0]);
			CodeField.setValue(rowObj[0].get("schemcode"));	
			NameField.setValue(rowObj[0].get("schemname"));
			activeRadioGroup.setValue(active);
			schemeTypeRadioGroup.setValue(schemeType);
			importTypeRadioGroup.setValue(importType);
			checkTypeRadioGroup.setValue(checkType);

	 }); 		
	//���岢��ʼ�������޸İ�ť
	var editButton = new Ext.Toolbar.Button({
		text:'����'
	});                                                                                                                                            //
	//�����޸İ�ť��Ӧ����
	editHandler = function(){
		var rowObj=itemGrid.getSelectionModel().getSelections();
		var rowId = rowObj[0].get("rowid");          
		var code = CodeField.getValue();
		var name = NameField.getValue(); 
		var schemeTypeRadio=formPanel.getForm().findField('schemeTypeRadio').getValue().inputValue;
		var importTypeRadio=formPanel.getForm().findField('importTypeRadio').getValue().inputValue;
		var checkTypeObj=formPanel.getForm().findField('checkTypeRadio').getValue();
		if(checkTypeObj==null || checkTypeObj==""){
			Ext.Msg.show({title:'����',msg:'��ѡ����Ŀ��¼����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		}else{
			var checkTypeRadio=formPanel.getForm().findField('checkTypeRadio').getValue().inputValue;
		}
		var activeRadio=formPanel.getForm().findField('activeRadio').getValue().inputValue;
		var utotal = eChkUserGrid.getStore().getCount();
		
		var urawValue="";
		if(utotal>0){
			 urawValue = eChkUserGrid.getStore().getAt(0).get('Rowid');
			//alert(urawValue);
			for(var i=1;i<utotal;i++){
			  var urow = eChkUserGrid.getStore().getAt(i).get('Rowid');//ÿ�ж���rowid��ֵ
			  urawValue = urawValue+","+urow;
			}
		}
		var RelyUnit = urawValue;
		
	
			Ext.Ajax.request({
			url:'dhc.qm.checkpointmakeexe.csp?action=editproj&rowid='+rowId+'&schemcode='+code
				+'&schemname='+encodeURIComponent(name)+'&linker='+RelyUnit+'&schemeType='+schemeTypeRadio+'&importType='+importTypeRadio+'&checkType='+checkTypeRadio+'&active='+activeRadio,
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//console.log(jsonData.info);
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
					editwin.close();
				}else{
					/*��ӱ����ظ��������ظ� 20160517 cyl add
						jsonData=RefSchemCode^RefSchemName
						*/
						var message = "";
						//�ȷֽ�jsonData
						var jsonInfo=jsonData.info;
						var errorObj=jsonInfo.split("^");
						for(var i=1;i<errorObj.length;i++){
							var errorStr=errorObj[i];
							if(errorStr=="RefSchemCode"){
								message = message+"��Ŀ�����ظ���<br/>";
							}else if(errorStr=="RefSchemName"){
								message = message+"��Ŀ�����ظ���<br/>";
							}else{
								var ti=importTypeRadio==1?'<span style="color:blue">�ɼ������</span>':'<span style="color:blue">¼���Excel����</span>';
								message =message+"�뽫���¼����ռ���ʽ��Ϊ��<br/>&nbsp;&nbsp;&nbsp;&nbsp;"+ti+errorStr;
							}
						}
					//var message="�Ѵ�����ͬ��¼";
					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,maxWidth:300});
				}
			},
			scope: this
		});
		
			
		
		//editwin.close();
	};
	
	//��ӱ����޸İ�ť�ļ����¼�
	editButton.addListener('click',editHandler,false);

	//���岢��ʼ��ȡ���޸İ�ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	
	//����ȡ���޸İ�ť����Ӧ����
	cancelHandler = function(){
		editwin.close();
	};
	
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
	
	//���岢��ʼ������
	var editwin = new Ext.Window({
		title: '�޸ļ�¼',
		width : 470,
		height : 555,    
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		resizable:false,
		buttons: [
			editButton,
			cancelButton
		]
	});
	//������ʾ
	
	editwin.show();

};

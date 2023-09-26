
addProjFun = function(dataStore,grid) {
	

	var uCodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '��Ŀ����',
		width:325,
		allowBlank:false,
		//listWidth : 295,
		triggerAction: 'all',
		emptyText:'',
		name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var uNameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '��Ŀ����',
		width:325,
		allowBlank:false,
		//listWidth : 295,
		triggerAction: 'all',
		emptyText:'',
		name: 'NameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var nameDs = new Ext.data.Store({   //��������Դ
		proxy: "",
		reader: new Ext.data.JsonReader({
			totalProperty: 'results',
			root: 'rows'	
		},['Rowid','name']),
		//remoteSort: true	
		autoLoad:true
		
	});
	nameDs.on('beforeload',function(ds,o){  //����Դ�����������ú�̨�෽����ѯ����
		ds.proxy = new Ext.data.HttpProxy({
			url:'dhc.qm.checkpointmakeexe.csp'+'?action=listcheckproj&fuzzyquery='+encodeURIComponent(Ext.getCmp('linkerField').getRawValue()),method:'POST'
		});
	});

	var linkerField = new Ext.form.ComboBox({
		id: 'linkerField',
		fieldLabel: 'ѡ�����ҽ��',
		width:305,
		listWidth : 305,
		resizable:true,
		//allowBlank: false,
		store: nameDs,
		valueField: 'Rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ��ҽ��...',
		name: 'linkerField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		//showSelectAll :true,
		editable:true
	});


	
	var aChkUserGrid = new Ext.grid.GridPanel({
		id:'aChkUserGrid',
		store: new Ext.data.Store({
			proxy: new Ext.data.MemoryProxy(),
			reader: new Ext.data.ArrayReader({}, [  
				 {name: 'Rowid'},  
				 {name: 'name'}
			 ])  
		}),
		colModel: new Ext.grid.ColumnModel({
			defaults: {
				width:50,
				sortable: true
			},
			columns: [
				{id: 'Rowid', header: 'ҽ��ID', width: 18, sortable: true, dataIndex: 'Rowid',hidden:true},
				{header: 'ҽ���б�', dataIndex: 'name',align:'center',width: 350}
			]
		}),
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		width: 408,
		height: 130
	});
///////////////��Ӷ�������˰�ť////////////////
	var addParticipants  = new Ext.Button({
		text: '��ӹ���ҽ��',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('linkerField').getValue();
			var ChkName = Ext.getCmp('linkerField').getRawValue();

			var ptotal = aChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = aChkUserGrid.getStore().getAt(i).get('Rowid');
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
			aChkUserGrid.stopEditing(); 
			aChkUserGrid.getStore().insert(0,data);
		}
	});	
	var delParticipants = new Ext.Button({
		text:'ɾ������ҽ��',
		style:'margin-left:5px;padding:0 5px 0 5px;',
		handler: function() {  
			var rows = aChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			
			if(length < 1)
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ����ҽ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = aChkUserGrid.getStore().indexOf(rows[0]); //����кţ�������rowid
				aChkUserGrid.getStore().removeAt(rRowid);//�Ƴ���ѡ�е�һ��
			}		
		}
	});
	
	//=====================2016-04-11 ���=====================//
	var activeRadioGroup=new Ext.form.RadioGroup({
		name:'activeRadio',
		fieldLabel:'��Ŀ�Ƿ�����',
		columns: 4,
		items:[{
			boxLabel:'����',
			inputValue:'Y',
			name:'activeRadio',
			style:'height:14px;',
			checked:true
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
			name:'schemeTypeRadio',
			style:'height:14px;',
			checked:true
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
			name:'importTypeRadio',
			style:'height:14px;',
			checked:true
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
		style:"maginTop:0px;",
		 
		items:[{
			boxLabel:'���ϸ��¼',
			inputValue:'1',
			name:'checkTypeRadio',
			style:'height:14px;',
			checked:true
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
						'</br><span style="color:red;">��ȫ����¼��&nbsp;&nbsp;&nbsp;</span>��ʾ����������ݣ���Ϊ���ϸ��¼;</br><span style="color:red;">��������㡱</span>��ʾ����¼�����������������ʱ��Ϊ���ϸ��¼��'
	});
	//========================================================//
	
	var colItems =[
			uCodeField,
			uNameField,
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
					addParticipants,
					delParticipants
				]
				},
				aChkUserGrid
			]	
			}
		]

	var formPanel = new Ext.form.FormPanel({
		labelWidth:90,
		frame: true,
		items:colItems
	});
			
	//��ʼ����Ӱ�ť
	add1Button = new Ext.Toolbar.Button({
		text:'�� ��'
	});
	
	var auser="";
	//������Ӱ�ť��Ӧ����
	add1Handler = function(){
	
		var adesc = uNameField.getValue();
		//var auint = aunitField.getValue();
		var auint="";
		var chknamecount = aChkUserGrid.getStore().getCount();
		  if(chknamecount>0){
			var id = aChkUserGrid.getStore().getAt(0).get('Rowid');
			auser = id;
			for(var i=1;i<chknamecount;i++){
			  var tmpid = aChkUserGrid.getStore().getAt(i).get('Rowid');
			  auser = auser+","+tmpid;
			   };
		   }
		var code = uCodeField.getValue();
		//var uisStop = linkerField.getValue();     		
		Cname = adesc.trim();
		Code = code.trim();
		//��õ�ѡ��ťѡ�е�ֵ
		var schemeTypeRadio=formPanel.getForm().findField('schemeTypeRadio').getValue().inputValue;
		var importTypeRadio=formPanel.getForm().findField('importTypeRadio').getValue().inputValue;
		var checkTypeRadio=formPanel.getForm().findField('checkTypeRadio').getValue().inputValue;
		var activeRadio=formPanel.getForm().findField('activeRadio').getValue().inputValue;
		//console.log(schemeTypeRadio+"^"+importTypeRadio+"^"+checkTypeRadio+"^"+activeRadio);
			
		var data =encodeURIComponent(Code)+'^'+encodeURIComponent(Cname)+'^'+encodeURIComponent(auser)+'^'+schemeTypeRadio+"^"+importTypeRadio+"^"+checkTypeRadio+"^"+activeRadio;
			
		if (formPanel.form.isValid()) {
			Ext.Ajax.request({
				url: projUrl+'?action=addleft&data='+data,
				failure: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					console.log(jsonData);
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						//itemGridDs.load({params:{start:0}});
						itemGridDs.load({params:{start:0, limit:25}});		
						//window.close();
					}else{
						/*��ӱ����ظ��������ظ� 20160517 cyl add
						jsonData=RefSchemCode^RefSchemName
						*/
						var message = "";
						//�ȷֽ�jsonData
						var jsonInfo=jsonData.info;
						var errorObj=jsonInfo.split("^");
						for(var i=0;i<errorObj.length;i++){
							var errorStr=errorObj[i];
							if(errorStr=="RefSchemCode"){
								message = message+"��Ŀ�����ظ���<br/>";
							}else if(errorStr=="RefSchemName"){
								message = message+"��Ŀ�����ظ���";
							}
							
						}
						if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
						if(jsonData.info=='RepKPI') message='�ظ�!';
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
        }else{
			Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	},
    	
    {
		text: 'ȡ��',
        handler: function(){window.close();}
    }

	//��ӱ��水ť�ļ����¼�
	add1Button.addListener('click',add1Handler,false);

	//��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});

	//����ȡ����ť����Ӧ����
	cancelHandler = function(){
		addwin.close();
	};

	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);

	//��ʼ������
	addwin = new Ext.Window({
		title: '��Ӽ�¼',
		width: 470,
		height:555,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		resizable:false,
		buttons: [
			add1Button,
			cancelButton
		]
	});

	//������ʾ
	addwin.show();
	
};
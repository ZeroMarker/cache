function ManfHisSearch(ManfId){
	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ������Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					ManHisInfoStore.load({params:{start:0,limit:15,ManfId:ManfId}});
				}
			});
	//���̱༭����
    function CreateEditWin(rowid){
	
	//���̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>���̴���</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'���̴���...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('codeField').getValue()==""){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'����',msg:'���̴��벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						nameField.focus();
					}
				}
			}
		}
	});
	
	//��������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>��������</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��������...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('nameField').getValue()==""){
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						addressField.focus();
					}
				}
			}
		}
	});
	
	//���̵�ַ
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'���̵�ַ',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'���̵�ַ...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						phoneField.focus();
				}
			}
		}
	});
	
	//���̵绰
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
		fieldLabel:'���̵绰',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'���̵绰...',
		anchor:'90%',
		regex:/^[^\u4e00-\u9fa5]{0,}$/,
		regexText:'����ȷ�ĵ绰����',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						lastPhManfField.focus();
				}
			}
		}
	});
	
	//�ϼ�����
	var lastPhManfField = new Ext.form.ComboBox({
		id:'lastPhManfField',
		fieldLabel:'�ϼ�����',
		width:298,
		listWidth:298,
		allowBlank:true,
		store:PhManufacturerStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'�ϼ�����...',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						drugProductPermitField.focus();
				}
			}
		}
	});
	
	//ҩ���������
	var drugProductPermitField = new Ext.form.TextField({
		id:'drugProductPermitField',
		fieldLabel:'ҩ���������',
		width:200,
		listWidth:200,
		//emptyText:'ҩ���������...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductPermitField').getValue()==""){
						Handler = function(){drugProductPermitField.focus();}
						Ext.Msg.show({title:'����',msg:'ҩ��������ɲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						drugProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//ҩ�����������Ч��
	var drugProductExpDate = new Ext.ux.DateField({ 
		id:'drugProductExpDate',
		fieldLabel:'ҩ�����������Ч��',  
		allowBlank:true,
		width:298,
		listWidth:298,    
		format:App_StkDateFormat,        
		//emptyText:'ҩ�����������Ч�� ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductExpDate').getValue()==""){
						Handler = function(){drugProductExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'ҩ�����������Ч�ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductPermitField.focus();
					}
				}
			}
		}      
	});  
	
	//�����������
	var matProductPermitField = new Ext.form.TextField({
		id:'matProductPermitField',
		fieldLabel:'�����������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�����������...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductPermitField').getValue()==""){
						Handler = function(){matProductPermitField.focus();}
						Ext.Msg.show({title:'����',msg:'����������ɲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//�������������Ч��
	var matProductExpDate = new Ext.ux.DateField({ 
		id:'matProductExpDate',
		fieldLabel:'�������������Ч��',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'�������������Ч�� ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductExpDate').getValue()==""){
						Handler = function(){matProductExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'�������������Ч�ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicField.focus();
					}
				}
			}
		}        
	});
	
	//����ִ�����
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'����ִ�����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ִ�����...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicField').getValue()==""){
						Handler = function(){comLicField.focus();}
						Ext.Msg.show({title:'����',msg:'����ִ����ɲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicExpDate.focus();
					}
				}
			}
		}
	});
	
	//����ִ�������Ч��
	var comLicExpDate = new Ext.ux.DateField({ 
		id:'comLicExpDate',
		fieldLabel:'����ִ�������Ч��',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'����ִ�������Ч�� ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicExpDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'����ִ�������Ч�ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	var StartDate = new Ext.ux.DateField({ 
		id:'StartDate',
		fieldLabel:'��ʼ����',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('StartDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'��ʼ���ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	var EndDate = new Ext.ux.DateField({ 
		id:'EndDate',
		fieldLabel:'��ֹ����',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('StartDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'��ֹ���ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	
	
	//��ʼ�����
	editForm = new Ext.form.FormPanel({
		baseCls:'x-plain',
		labelWidth:150,
		labelAlign : 'right',
		items:[
			codeField,
			nameField,
			addressField,
			phoneField,
			lastPhManfField,
			drugProductPermitField,
			drugProductExpDate,
			matProductPermitField,
			matProductExpDate,
			comLicField,
			comLicExpDate,
			StartDate,
			EndDate
		]
	});
	
	//��ʼ����Ӱ�ť
	editButton = new Ext.Toolbar.Button({
		text:'ȷ��',
		iconCls : 'page_save',
		handler:function(){
			editHandler();	
		}
	});
	//��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
		iconCls : 'page_close',
		text:'�ر�'
	});
	
	//����ȡ����ť����Ӧ����
	cancelHandler = function(){
		win.close();
	};
	
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
	//��ʼ������
	var win = new Ext.Window({
		title:'����ά��',
		width:500,
		height:455,
		minWidth:500,
		minHeight:455,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:editForm,
		buttons:[
			editButton,
			cancelButton
		],
		listeners:{
			'show':function(thisWin){
				Select(rowid);
			}
		}
	});

	win.show();
	//����
	
	
	//�޸�
    var editHandler= function(){
		
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') {drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);}
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') {matProductExpDate=matProductExpDate.format(App_StkDateFormat);}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate!='') {comLicExpDate=comLicExpDate.format(App_StkDateFormat);}
		var StartDate = Ext.getCmp('StartDate').getValue();
		var StartDateB,EndDateB;
		if (StartDate!='') {
			StartDateB=StartDate.format('Y-m-d');
			StartDate=StartDate.format(App_StkDateFormat);
		}
		var EndDate = Ext.getCmp('EndDate').getValue();
		if (EndDate!='') {
			EndDateB=EndDate.format('Y-m-d');
			EndDate=EndDate.format(App_StkDateFormat);
		}
		if ((EndDateB!="")&&(StartDateB!="")&&(EndDateB<StartDateB)){
			Msg.info("warning", "��ʼ���ڴ��ڽ�ֹ����!");
			return;
		}
		if(code.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'���̴���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ�����������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'�����������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'�������������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		//ƴdata�ַ���
		var data=rowid+"^"+code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+StartDate+"^"+EndDate;
		Ext.Ajax.request({
			url:PhManfGridUrl+'?actiontype=updateManfHis&data='+encodeURI(data),
			waitMsg:'������...',
			failure:function(result, request) {
				Msg.info("error","������������!");
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success","���³ɹ�!");
					ManfHisInfoStore.load({params:{start:PhManfPagingToolbar.cursor,limit:PhManfPagingToolbar.pageSize,ManfId:ManfId}});
					win.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","�����ظ�!");
					}
					if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
					}
				}
			},
			scope: this
		});
	};
	
	
	function Select(rowid){
		Ext.Ajax.request({
			url: PhManfGridUrl+'?actiontype=GetManfHis&rowid='+rowid,
			failure: function(result, request) {
				Msg.info("error", "������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					//��ѯ�ɹ�,��ֵ���ؼ�
					var value = jsonData.info;
					var arr = value.split("^");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					Ext.getCmp('lastPhManfField').setValue(arr[4]);
					Ext.getCmp('lastPhManfField').setRawValue(arr[5]);
					Ext.getCmp('drugProductPermitField').setValue(arr[6]);
					Ext.getCmp('drugProductExpDate').setValue(arr[7]);
					Ext.getCmp('matProductPermitField').setValue(arr[8]);
					Ext.getCmp('matProductExpDate').setValue(arr[9]);
					Ext.getCmp('comLicField').setValue(arr[10]);
					Ext.getCmp('comLicExpDate').setValue(arr[11]);
					Ext.getCmp('StartDate').setValue(arr[12]);
					Ext.getCmp('EndDate').setValue(arr[13]);
					//s Data1=Code_"^"_Name_"^"_Address_"^"_Tel_"^"_ManfAddId_"^"_$g(ParManfId)_"^"_$g(ParManf)_"^"_$g(DrugProductP)_"^"_$g(DrugProductE)_"^"_$g(MatProductP)_"^"_$g(MatProductE)_"^"_$g(ComLic)_"^"_$g(ComLicDate)_"^"_Active
				}else{
					Msg.info("error", "��ѯʧ��!" +rowid);
				}
			},
			scope: this
		});
	}
}

	// �༭��ť
	var editPhManfHis = new Ext.Toolbar.Button({
	text:'�༭',
    tooltip:'�༭',
    id:'EditManfHisBt',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	hidden:true,
	handler:function(){
		var rowObj = ManfHisInfoGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
					
			CreateEditWin(rowObj[0].get("ManfHisId"));
		}
      }
    });
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '����ر�',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	
	// ����·��
	var ManfHisInfoUrl = DictUrl	+ 'phmanfaction.csp?actiontype=GetManfHisInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : ManfHisInfoUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["ManfHisId","ManfHisCode", "ManfHisDesc", "ManfHisAddress","ManfHisTel","ManfHisPar","ManfHisDProductP", "ManfHisDProductE", "ManfHisMProductP",
			"ManfHisMProductE","ManfHisComLic","ManfHisComLicDate","ManfHisStDate","ManfHisEdDate"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "manfhisinfo",
				fields : fields
			});
	// ���ݼ�
	var ManfHisInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	ManfHisInfoStore.load({params:{start:0,limit:15,ManfId:ManfId}});
	var nm = new Ext.grid.RowNumberer();
	var ManfHisInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "ManfHisId",
				dataIndex : 'ManfHisId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			},{
				header : "����",
				dataIndex : 'ManfHisCode',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "����",
				dataIndex : 'ManfHisDesc',
				width : 250,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "��ַ",
				dataIndex : 'ManfHisAddress',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "�绰",
				dataIndex : 'ManfHisTel',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "�ϼ�����",
				dataIndex : 'ManfHisPar',
				width : 120,
				align : 'left',
				sortable : true
			
	        }, {
				header : "ҩ���������",
				dataIndex : 'ManfHisDProductP',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "ҩ�����������Ч��",
				dataIndex : 'ManfHisDProductE',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "�����������",
				dataIndex : 'ManfHisMProductP',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "�������������Ч��",
				dataIndex : 'ManfHisMProductE',
				width : 120,
				align : 'left',
				sortable : true
			
	        }, {
				header : "����ִ�����",
				dataIndex : 'ManfHisComLic',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "����ִ�������Ч��",
				dataIndex : 'ManfHisComLicDate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "��ʼ����",
				dataIndex : 'ManfHisStDate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "��ֹ����",
				dataIndex : 'ManfHisEdDate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        ]);
	var ManfHisInfoGrid = new Ext.grid.GridPanel({
				id : 'ManfHisInfoGrid',
				title : '',
				height : 170,
				cm : ManfHisInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : ManfHisInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				listeners:{
		            'rowdblclick':function(){
			             Ext.getCmp('EditManfHisBt').handler();
			
		             }
	
	             }
				//bbar:[GridPagingToolbar]
			});
	ManfHisInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : ManfHisInfoStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
					emptyMsg : "No results to display",
					prevText : "��һҳ",
					nextText : "��һҳ",
					refreshText : "ˢ��",
					lastText : "���ҳ",
					firstText : "��һҳ",
					beforePageText : "��ǰҳ",
					afterPageText : "��{0}ҳ",
					emptyMsg : "û������",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='Rowid';
						B[A.dir]='desc';
						B['ManfId']=ManfId;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
	var window = new Ext.Window({
				title : '������ʷ��Ϣ',
				width : 700,
				height : 400,
				layout : 'border',
				items :[
				    {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: ManfHisInfoGrid        
		               
		            }
	            ],
	            tbar : [editPhManfHis,'-',closeBT]
	});
	window.show();
	}

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

	}
	var rowField = new Ext.form.TextField({
		id: 'rowid',
		fieldLabel: 'ID',
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		emptyText:'',
		//name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var CodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '����',
		width:260,
		listWidth : 300,
		triggerAction: 'all',
		emptyText:'',
		//name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var NameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '����',
		width:260,
		listWidth : 300,
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
		width:260,
		listWidth : 300,
		allowBlank: false,
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
		url:'dhc.qm.checkpointmakeexe.csp'+'?action=listleftedit&start='+0+'&limit='+25+'&rowid='+rowid,
		method:'POST'}),
	    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['Rowid','name'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 300,
            sortable: true
        },
        columns: [
            {id: 'Rowid', header: 'ҽ��ID', width: 129, sortable: true, dataIndex: 'Rowid',hidden:true},
            {header: 'ҽ������', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 330,
    height: 130
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
	
var colItems =[{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [{
							 xtype: 'fieldset',
							 autoHeight: true,
							 items: [
							 //rowField,
							 CodeField,
							 NameField,
							 eChkUserGrid,
					         linkerField,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [
						         {
							       xtype : 'displayfield',
							       columnWidth : .05
							     },
							     addeParticipants,
							     {
							       xtype : 'displayfield',
							       columnWidth : .07
							     },
							    deleParticipants
					            ]							    
						    }				 
								]
							 }]
				}]		

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 60,
				//layout: 'form',
				frame: true,
				items:colItems
				//items: [CodeField,NameField,eChkUserGrid,linkerField,addeParticipants,deleParticipants]
		        //items:	[CodeField,NameField,eChkUserGrid, linkerField,{ items: [ {xtype : 'displayfield', columnWidth : .05,align:'left'},addeParticipants,{ xtype : 'displayfield',columnWidth : .07,align:'right' },deleParticipants]}] 
							       
			});
		                                                                                           //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
     
	    
			//this.getForm().loadRecord(rowObj[0]);
			CodeField.setValue(rowObj[0].get("schemcode"));	
			NameField.setValue(rowObj[0].get("schemname"));
			//linkerField.setValue(rowObj[0].get("linker")); 	
	 }); 		
    //var euser="";
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
                //var edesc = linkerField.getValue();
				
			var utotal = eChkUserGrid.getStore().getCount();
			//alert(utotal);
			if(utotal>0){
				urawValue = eChkUserGrid.getStore().getAt(0).get('Rowid');
				//alert(urawValue);
				for(var i=1;i<utotal;i++){
				  var urow = eChkUserGrid.getStore().getAt(i).get('Rowid');//ÿ�ж���rowid��ֵ
				  urawValue = urawValue+","+urow;
				};
			}
			var RelyUnit = urawValue;
			//alert(RelyUnit);
          
                Ext.Ajax.request({
				url:'dhc.qm.checkpointmakeexe.csp?action=editproj&rowid='+rowId+'&schemcode='+code
				+'&schemname='+encodeURIComponent(name)+'&linker='+RelyUnit,
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
				}
				else
					{
						var message="�Ѵ�����ͬ��¼";
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			},
				scope: this
			});
			editwin.close();
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
			width : 400,
			height : 340,    
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		//������ʾ
		
		editwin.show();
};

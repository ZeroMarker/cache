

srmMonographEditFun = function(IsSigDept,MonTra) {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
    if(rowObj[0].get("DataStatus")=="�ύ")
	 {
		      Ext.Msg.show({title:'ע��',msg:'���ύ��¼�޷��޸ģ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{			
		var tmpEditorDr =rowObj[0].get("EditorName");
		var tmpDeptDr="";		
		var PressDr="";
	}
	

	var NameField = new Ext.form.TextField({
		id: 'Name',
		fieldLabel: 'ר������',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'Name',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	//��ȡ��������
	var unitdeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	unitdeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.monographinfoexe.csp'
		                     + '?action=deptList&str='
		                     + encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unitdeptField = new Ext.form.ComboBox({
			id: 'unitdeptField',
			fieldLabel: '��������',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '��ѡ���������...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true

	});
	unitdeptField.on('select',function(combo, record, index){
	       tmpDeptDr = combo.getValue();
	});

//����
	var unituserDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
     });
     
	unituserDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.monographinfoexe.csp'
		         +'?action=userList&str='
		         +encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
		         method:'POST'
		       });
	});

	var unituserField = new Ext.ux.form.LovCombo({
			id: 'unituserField',
			fieldLabel: '����',
			width:200,
			listWidth :220,
			//allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			hideOnSelect:false,

			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ����Ա����...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10
			//selectOnFocus:true,
			//hideOnSelect:false ,
		//	forceSelection:'true',
		//	editable:false
	});
	
	var TotalNum = new Ext.form.TextField({
		id: 'TotalNum',
		fieldLabel: '��������ǧ�֣�',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'TotalNum',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
var PressDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
});


PressDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.monographinfoexe.csp'
	                     + '?action=deptList&str='
	                     + encodeURIComponent(Ext.getCmp('PressField').getRawValue()),
	               method:'POST'
	              });
	});

var PressField = new Ext.form.ComboBox({
		id: 'PressField',
		fieldLabel: '������',
		width:200,
		listWidth : 220,
		allowBlank: false,
		store: PressDs,
		displayField: 'name',
		valueField: 'rowid',
		triggerAction: 'all',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '��ѡ�������...',
		name: 'PressField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true
});
PressField.on('select',function(combo, record, index){

	//console.log("this is combo "+combo.displayField);
	PressDr = combo.getValue();
});
	var PubTime = new Ext.form.DateField({
		id : 'PubTime',
		fieldLabel:'��������',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	
	var ISBN = new Ext.form.TextField({
		id: 'ISBN',
		fieldLabel: 'ISBN��',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'ISBN',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var PublishFreqField = new Ext.form.NumberField({
		id: 'PublishFreq',
		fieldLabel: '������',
		width:200,
		allowBlank: false,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'TotalNum',
		minChars: 1,
		pageSize: 10,
		editable:true
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls : 'x-plain',
		labelWidth : 100,
		items : [NameField,unitdeptField,unituserField,TotalNum,PressField,PubTime,ISBN,PublishFreqField]
	});			                                                                                            //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
    	 var rowObj=itemGrid.getSelectionModel().getSelections();    
    	 ////'rowid','Name','DeptDr','IsSigDept','Editor','MonTra','TotalNum','WriteWords','Press','PubTime','PriTime','ISBN','SubUser','SubDate','DataStatus','SysNo','ChkResult'
			this.getForm().loadRecord(rowObj[0]);
			NameField.setValue(rowObj[0].get("Name"));
			unitdeptField.setValue(rowObj[0].get("DeptName"));
			unituserField.setRawValue(rowObj[0].get("EditorName"));
            TotalNum.setValue(rowObj[0].get("TotalNum"));
			PressField.setValue(rowObj[0].get("PressName"));
			PubTime.setValue(rowObj[0].get("PubTime"));
			ISBN.setValue(rowObj[0].get("ISBN"));
			PublishFreqField.setValue(rowObj[0].get("PublishFreq"));
   });   

	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
			    	var rowObj=itemGrid.getSelectionModel().getSelections();
					//���岢��ʼ���ж��󳤶ȱ���
					
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     

		        var name = NameField.getValue();
				var deptdr = tmpDeptDr;
				var editor = unituserField.getValue();
				var totalnum = TotalNum.getValue();
				var press = PressDr;
				var pubtime = PubTime.getValue();
				var isbn = ISBN.getValue();
				var publishfreq=PublishFreqField.getValue();
				if (pubtime!==""){
					//pubtime=pubtime.format ('Y-m-d');
				}
                Ext.Ajax.request({
				url:'herp.srm.monographinfoexe.csp?action=edit&rowid='+rowid+'&name='+encodeURIComponent(name)+'&deptdr='+encodeURIComponent(deptdr)+'&editor='+encodeURIComponent(editor)+'&totalnum='+encodeURIComponent(totalnum)+'&press='+encodeURIComponent(press)+'&pubtime='+encodeURIComponent(pubtime)+'&isbn='+encodeURIComponent(isbn)+'&publishfreq='+encodeURIComponent(publishfreq),
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize,userdr:userdr}});		
				}
				else
					{
					var message="�ظ����";
					if(jsonData.info=='RepISBN') message="ISBN���ظ���";
					if(jsonData.info=='RepName') message="�����ظ���";
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
			height : 420,    
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
		
		//MontraField.focus();
		
		
	//	unituserField.statesave();
		
//		var unituserDs = new Ext.data.Store({
//			autoLoad : true,
//			proxy : "",
//			reader : new Ext.data.JsonReader({
//			           totalProperty:'results',
//			           root:'rows'
//			       },['rowid','name'])
//     });
		
//		for(p in unituserDs.reader.root){
//			
//			console.log("unituserDs"+p);
//		}
//		
//		console.log("expand"+unituserField.expand());
	};

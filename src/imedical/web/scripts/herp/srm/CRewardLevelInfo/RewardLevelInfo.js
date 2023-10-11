var itemGridUrl = '../csp/herp.srm.rewardlevelinfoexe.csp';

//�������Դ

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'stype',
		'slevel', 
		'stypename',
		'slevelname',
        'IsValid'
	]),
    remoteSort: true
});
var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 18,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,
});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

//��ʼ����Ӱ�ť
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	    id:'rowid',
    	header: 'id',
        dataIndex: 'rowid',
        width: 180,		  
        hidden: true,
        sortable: true
	    
    },
    {
	    id:'stype',
	    header:'�������rowid:',
	    dataIndex:'stype',
	    width: 180,
	    hidden: true
	    //sortable:true
	    
	    
	},
	{
	    id:'slevel',
	    header:'������Ŀrowid:',
	    dataIndex:'slevel',
	    width: 100,
	    hidden: true
	    //sortable:true
	    
	    
	},
    {
        id:'stypename',
    	header: '��������',
        dataIndex: 'stypename',
        width: 100
        //sortable: true
    },
    {
        id:'slevelname',
    	header: '������Ŀ',
        dataIndex: 'slevelname',
        width: 240
        //sortable: true
    }
   
]);
//��ʼ��Ĭ��������
itemGridCm.defaultSortable = true;
var addButton = new Ext.Toolbar.Button({
	text: '����',
    //tooltip:'����',        
    iconCls: 'edit_add',
	handler:function(){

      var ClassDs1 = new Ext.data.Store({
	                //autoLoad:true,
	                  proxy:"",
	                  reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
                      });


           ClassDs1.on('beforeload', function(ds, o){
	          ds.proxy=new Ext.data.HttpProxy({
	          url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetClass&str='+encodeURIComponent(Ext.getCmp('ClassField1').getRawValue()),method:'POST'});
              });

var ClassField1 = new Ext.form.ComboBox({
	id: 'ClassField1',
	fieldLabel: '��������',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:ClassDs1,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	name: 'ClassField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});

var PerionDs1 = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


PerionDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField1').getRawValue()),method:'POST'});
});

var PerionField1 = new Ext.form.ComboBox({
	id: 'PerionField1',
	fieldLabel: '������Ŀ',
	width:200,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs1,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ������Ŀ...',
	name: 'PerionField1',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			labelAlign:'right',
			items: [                              
                                ClassField1,
                                PerionField1			
				//aField
			]
		});
		//aField.setDisabled(true);   
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'����',
			iconCls: 'save'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
            
			var Class = ClassField1.getValue();
			var Perion = PerionField1.getValue();      
			if(Class==""){
				Ext.Msg.show({title:'����',msg:'�������Ͳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			
			if(Perion ==""){
		
				Ext.Msg.show({title:'����',msg:'������Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}			
			//encodeURI
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.srm.rewardlevelinfoexe.csp?action=add&Class='+Class+'&Perion='+Perion),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){ClassField1.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){ClassField1.focus();};
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						itemGridDs.load({params:{start:0, limit:25}});
						
						//addwin.close();
					}
					else
							{
								var message="�ظ����";
								message = "SQLErr: " + jsonData.info;
								if(jsonData.info=='RecordExist') message="����ļ�¼�Ѿ�����!";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '�������������Ϣ',
			iconCls: 'edit_add',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 200,
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
	
		//������ʾ
		addwin.show();
	}	
});



//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls: 'pencil',
	handler:function(){
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
		    var tmpClass=rowObj[0].get("stype");
		    var tmpPerion=rowObj[0].get("slevel");
		}	
		var ClassDs2 = new Ext.data.Store({
	        proxy:"",
	        reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
        });


        ClassDs2.on('beforeload', function(ds, o){
	    ds.proxy=new Ext.data.HttpProxy({
	    url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetClass&str='+encodeURIComponent(Ext.getCmp('ClassField2').getRawValue()),method:'POST'});
        });

         var ClassField2 = new Ext.form.ComboBox({
	     id: 'ClassField2',
	     fieldLabel: '��������',
	     width:200,
	     listWidth : 250,
		//allowBlank: false,
	     store:ClassDs2,
	     valueField: 'code',
	     displayField: 'name',
	     triggerAction: 'all',
	     value:tmpClass,
	     name: 'ClassField2',
	     minChars: 1,
	     pageSize: 10,
	     selectOnFocus:true,
	     forceSelection:'true',
	     editable:true,
	     labelSeparator:''
         });
        ClassField2.on('select',function(combo, record, index){
		    tmpClass = combo.getValue();
		    
		});
		var PerionDs2 = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
		});
		PerionDs2.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField2').getRawValue()),method:'POST'});
		});
		
		
		var PerionField2 = new Ext.form.ComboBox({
			id: 'PerionField2',
			fieldLabel: '������Ŀ',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store:PerionDs2,
			valueField: 'code',
			displayField: 'name',
			triggerAction: 'all',
		    value:tmpPerion,
			name: 'PerionField2',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:'true',
			forceSelection:'true',
			editable:true,
			labelSeparator:''
		});
		
		PerionField2.on('select',function(combo, record, index){
		    tmpPerion = combo.getValue();
		    //alert(tmpPerion);
			});	

		

		//��ʼ�����
		formPanel2 = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			labelAlign:'right',
			items: [
                               
                                ClassField2,
                                PerionField2
				               
			]
		});
	
		//������
             
		formPanel2.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
		
			ClassField2.setRawValue(rowObj[0].get("stypename"));	
			PerionField2.setRawValue(rowObj[0].get("slevelname"));
		
		});
		
//���岢��ʼ�������޸İ�ť
   var editButton = new Ext.Toolbar.Button({
			text:'����',
			iconCls: 'save'

		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){

            var rowObj=itemGrid.getSelectionModel().getSelections();
            var rowid = rowObj[0].get("rowid"); 
            //alert("rowid");
         
			var Class     = ClassField2.getValue();
			var Perion     = PerionField2.getValue();
			
           

		
			if(Class==""){
				Ext.Msg.show({title:'����',msg:'�������Ͳ���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(Perion ==""){
				Ext.Msg.show({title:'����',msg:'������Ŀ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
          
			Ext.Ajax.request({
				url:encodeURI('../csp/herp.srm.rewardlevelinfoexe.csp?action=editd&rowid='+rowid+'&Class='+Class+'&Perion='+Perion),
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();};
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				
				},
				
				success: function(result, request){
				   	var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){ClassField2.focus();};
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						itemGridDs.load({params:{start:0, limit:25}});
						
					}
					else
						{
							var message="����ļ�¼�Ѿ�����";
							//message = "SQLErr: " + jsonData.info;
							//if(jsonData.info=='RecordExist') message="����ļ�¼�Ѿ�����!";
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
			editwin.close();
		};
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸Ľ��������Ϣ',
			iconCls: 'pencil',
			width: 350,
			height:150,
			minWidth: 350, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel2,
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//������ʾ
		editwin.show();
	}
});		
//�޸İ�ť

var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
   // tooltip:'ɾ��',       
    id:'delButton', 
    iconCls: 'edit_remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.srm.rewardlevelinfoexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:25}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});


//��ȡ��Ŀ���� 

var PerionDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


PerionDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetPerion&str='+encodeURIComponent(Ext.getCmp('PerionField').getRawValue()),method:'POST'});
});

var PerionField = new Ext.form.ComboBox({
	id: 'PerionField',
	fieldLabel: '������Ŀ',
	width:180,
	listWidth : 250,
	//allowBlank: false,
	store:PerionDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ������Ŀ...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});
//�ڿ����
var ClassDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});


ClassDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.rewardlevelinfoexe.csp'+'?action=GetClass&str='+encodeURIComponent(Ext.getCmp('ClassField').getRawValue()),method:'POST'});
});

var ClassField = new Ext.form.ComboBox({
	id: 'ClassField',
	fieldLabel: '��������',
	width:180,
	listWidth : 250,
	//allowBlank: false,
	store:ClassDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'��ѡ��������...',
	name: 'sfasdfafd',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''
});





var SearchButton = new Ext.Toolbar.Button({
        text: '��ѯ', 
        tooltip:'��ѯ',        
        iconCls: 'search',
	handler:function(){	
        var stype = ClassField.getValue();
        var slevel = PerionField.getValue();
      
    

	itemGridDs.load(({params:{start:0,limit:18,stype:stype,slevel:slevel}}));

	
	}
});
var itemGrid = new Ext.grid.GridPanel({
	title: '���������Ϣά��',
	iconCls: 'list',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
    url: 'herp.srm.rewardlevelinfoexe.csp',
    atLoad : true, // �Ƿ��Զ�ˢ��
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['','�������','',ClassField,'','������Ŀ','',PerionField,'-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
	bbar:itemGridPagingToolbar
});
itemGridDs.load({params:{start:0, limit:25}});
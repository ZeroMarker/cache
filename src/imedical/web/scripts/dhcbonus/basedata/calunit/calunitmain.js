/**
  *name:tab of database
  *author:liuyang
  *Date:2011-1-17
 */
 
var CalUnitTabUrl = '../csp/dhc.bonus.calunitexe.csp';
function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ

var CalUnitTabProxy= new Ext.data.HttpProxy({url:CalUnitTabUrl + '?action=list'});
var CalUnitTabDs = new Ext.data.Store({
	proxy: CalUnitTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'valid'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
CalUnitTabDs.setDefaultSort('rowid', 'name');

//���ݿ�����ģ��
var CalUnitTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
    	header: '����',
        dataIndex: 'code',
        width: 100,		  
        sortable: true
    },{
    	header: '����',
        dataIndex: 'name',
        width: 100,
        sortable: true
    }
    
]);

//��ʼ��Ĭ��������
CalUnitTabCm.defaultSortable = true;


//��ʼ�������ֶ�
var CalUnitSearchField ='name';

//����������
var CalUnitFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'code',
			checked: false ,
			group: 'CalUnitFilter',
			checkHandler: onCalUnitItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'name',
			checked: true,
			group: 'CalUnitFilter',
			checkHandler: onCalUnitItemCheck 
		})
	]}
});

//����������Ӧ����
function onCalUnitItemCheck (item, checked){
	if(checked) {
		CalUnitSearchField = item.value;
		CalUnitFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var CalUnitSearchBox = new Ext.form.TwinTriggerField({
	width: 180,
	trigger1Class: 'x-form-clear-trigger',
	trigger2Class: 'x-form-search-trigger',
	emptyText:'����...',
	listeners: {
		specialkey: {
			fn:function(field, e) {
				var key = e.getKey();
	      	  		if(e.ENTER === key) {
					this.onTrigger2Click();
				}
			}
		}
	},
	grid: this,
	onTrigger1Click: function() {
		if(this.getValue()) {
			this.setValue('');    
			CalUnitTabDs.proxy = new Ext.data.HttpProxy({url:  CalUnitTabUrl + '?action=list'});
			CalUnitTabDs.load({params:{start:0, limit:CalUnitTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
				CalUnitTabDs.proxy = new Ext.data.HttpProxy({
				url: CalUnitTabUrl + '?action=list&searchField=' + CalUnitSearchField + '&searchValue=' + this.getValue()});
	        	CalUnitTabDs.load({params:{start:0, limit:CalUnitTabPagingToolbar.pageSize}});
	    	}
	}
});


//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){

		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����...',
			anchor: '90%',
			selectOnFocus:'true',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'����',msg:'���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
		});

		//��ʼ�����
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				cField,
				nField
			]
		});
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){

			var code = cField.getValue();
			var name = nField.getValue();
			code = trim(code);
			name = trim(name);

			if(code==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.calunitexe.csp?action=add&code='+code+'&name='+name,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){nField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){nField.focus();}
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					recordLogsFun("sss");
						CalUnitTabDs.load({params:{start:0, limit:CalUnitTabPagingToolbar.pageSize}});
						//addwin.close();
					}
					else
							{
								var message="";
								if(jsonData.info=='RepCode') message='����ı����Ѿ�����!';
								if(jsonData.info=='RepName') message='����������Ѿ�����!';
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
		}
	
		//��ӱ��水ť�ļ����¼�
		addButton.addListener('click',addHandler,false);
	
		//��ʼ��ȡ����ť
		cancelButton = new Ext.Toolbar.Button({
			text:'ȡ��'
		});
	
		//����ȡ����ť����Ӧ����
		cancelHandler = function(){
			addwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//��ʼ������
		addwin = new Ext.Window({
			title: '��Ӽ�¼',
			width: 400,
			height:200,
			minWidth: 400, 
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
    iconCls: 'option',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=CalUnitTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
	
	
		var c1Field = new Ext.form.TextField({
			id:'c1Field',
			fieldLabel: '����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:rowObj[0].get("code"),
			emptyText:'����...',
			anchor: '90%',
			selectOnFocus:'true',
			
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(c1Field.getValue()!=""){
							n1Field.focus();
						}else{
							Handler = function(){c1Field.focus();}
							Ext.Msg.show({title:'����',msg:'���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var n1Field = new Ext.form.TextField({
			id:'n1Field',
			fieldLabel: '����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			valueNotFoundText:rowObj[0].get("name"),
			emptyText:'����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		

		
		//���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				c1Field,
				n1Field
			]
		});
	
		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			c1Field.setValue(rowObj[0].get("code"));
			n1Field.setValue(rowObj[0].get("name"));	
		});
		
		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){

			var code = c1Field.getValue();
			var name = n1Field.getValue();
			code = trim(code);
			name = trim(name);
				
			if(code==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			Ext.Ajax.request({
				url: '../csp/dhc.bonus.calunitexe.csp?action=edit&rowid='+rowid+'&code='+code+'&name='+name,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){activeFlag.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						CalUnitTabDs.load({params:{start:0, limit:CalUnitTabPagingToolbar.pageSize}});
						editwin.close();						
					}
					else
						{
							var message="";
							if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
							if(jsonData.info=='RepName') message='����������Ѿ�����!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
				},
				scope: this
			});
		}
	
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ���޸�'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		}
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ļ�¼',
			width: 400,
			height:250,
			minWidth: 400, 
			minHeight: 250,
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
	}
});


//ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=CalUnitTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
				
					Ext.Ajax.request({
						url:'../csp/dhc.bonus.calunitexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								CalUnitTabDs.load({params:{start:0, limit:CalUnitTabPagingToolbar.pageSize}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});



//��ҳ������
var CalUnitTabPagingToolbar = new Ext.PagingToolbar({
    store: CalUnitTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',CalUnitFilterItem,'-',CalUnitSearchBox]
	
	
});


//���
var CalUnitTab = new Ext.grid.EditorGridPanel({
	title: '������λ',
	store: CalUnitTabDs,
	cm: CalUnitTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar:CalUnitTabPagingToolbar
});
CalUnitTabDs.load({params:{start:0, limit:CalUnitTabPagingToolbar.pageSize}});

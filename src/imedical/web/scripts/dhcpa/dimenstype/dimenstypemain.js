/**
  *name:tab of database
  *author:limingzhong
  *Date:2010-09-6
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//�������Դ
var DimensTypeTabUrl = '../csp/dhc.pa.dimenstypeexe.csp';
var DimensTypeTabProxy= new Ext.data.HttpProxy({url:DimensTypeTabUrl + '?action=list'});
var DimensTypeTabDs = new Ext.data.Store({
	proxy: DimensTypeTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'code',
		'name',
		'shortcut',
		'order',
		'appSysDr',
		'appSysName',
		'desc',
		'isInner',
		'active'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
DimensTypeTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var DimensTypeTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
    	header: '����',
        dataIndex: 'code',
        width: 100,
        sortable: true
    },{
        header: "����",
        dataIndex: 'name',
        width: 120,
        align: 'left',
        sortable: true
    },{
        header: "˳��",
        dataIndex: 'order',
        width: 150,
        align: 'left',
        sortable: true
    }/*,{
        header: "Ӧ��ϵͳ���",
        dataIndex: 'appSysName',
        width: 150,
        align: 'left',
        sortable: true/*,
		editor:new Ext.form.ComboBox({
			editable:false,
			valueField: 'key',
			displayField:'value',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['key','value'],
				data:[['1','1-ȫԺ'],['2','2-����'],['3','3-����'],['4','4-ҽ��'],['5','5-����']]
			})
		})
		
    }*/,{
        header: "����",
        dataIndex: 'desc',
        width: 150,
        align: 'left',
        sortable: true
    },{
        header:'���ñ�־',
		width:100,
		dataIndex:'isInner',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'��Ч��־',
		width:100,
		dataIndex:'active',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }
]);

//��ʼ��Ĭ��������
DimensTypeTabCm.defaultSortable = true;

//��Ӱ�ť
var addDimensType = new Ext.Toolbar.Button({
	text: '���ά�����',
    tooltip:'���ά�����',        
    iconCls:'add',
	handler:function(){
		var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: 'ά�ȷ������',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'ά�ȷ������...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ�����벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: 'ά�ȷ�������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'ά�ȷ�������...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							orderField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var orderField = new Ext.form.NumberField({
			id:'orderField',
			fieldLabel:'ά�ȷ���˳��',
			allowBlank:false,
			emptyText:'ά�ȷ���˳��...',
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
							appSysField.focus();
						}else{
							Handler = function(){orderField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ���˳����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var appSysStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['1','1-ȫԺ'],['2','2-����'],['3','3-����'],['4','4-ҽ��'],['5','5-����']]
		});
		var appSysField = new Ext.form.ComboBox({
			id: 'appSysField',
			fieldLabel: 'Ӧ��ϵͳ���',
			listWidth : 230,
			selectOnFocus: true,
			allowBlank: false,
			store: appSysStore,
			anchor: '90%',
			value:'1', //Ĭ��ֵ
			valueNotFoundText:'1-ȫԺ',
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'ѡ���־...',
			mode: 'local', //����ģʽ
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(appSysField.getValue()!=""){
							descField.focus();
						}else{
							Handler = function(){appSysField.focus();}
							Ext.Msg.show({title:'����',msg:'Ӧ��ϵͳ���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var descField = new Ext.form.TextField({
			id:'descField',
			fieldLabel: 'ά�ȷ�������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'ά�ȷ�������...',
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
				codeField,
				nameField,
				orderField,
				//appSysField,
				descField
			]
		});
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
			var code = codeField.getValue();
			var name = nameField.getValue();
			var order = orderField.getValue();
			//var appSysDr = Ext.getCmp('appSysField').getValue();
			var desc = descField.getValue();
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'����',msg:'ά�ȷ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'����',msg:'ά�ȷ�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			//alert('code='+code+'&name='+name+'&order='+order+'&appSysDr='+appSysDr+'&desc='+desc);
			Ext.Ajax.request({
				url: '../csp/dhc.pa.dimenstypeexe.csp?action=add&code='+code+'&name='+name+'&order='+order+'&appSysDr='+2+'&desc='+desc,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
						DimensTypeTabDs.load({params:{start:0,limit:DimensTypeTabPagingToolbar.pageSize}});
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'��ά�ȷ�������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'��ά�ȷ��������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
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
			title: '���ά�ȷ����¼',
			width: 380,
			height:250,
			minWidth: 380, 
			minHeight: 250,
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

edit=function(){

		//���岢��ʼ���ж���
		var rowObj=DimensTypeTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
		}
		var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: 'ά�ȷ������',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'ά�ȷ������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'code',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ�����벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: 'ά�ȷ�������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'ά�ȷ�������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'name',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							orderField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var orderField = new Ext.form.NumberField({
			id:'orderField',
			fieldLabel:'ά�ȷ���˳��',
			allowBlank:false,
			emptyText:'ά�ȷ���˳��...',
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
							appSysField.focus();
						}else{
							Handler = function(){orderField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ���˳����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var appStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['1','1-ȫԺ'],['2','2-����'],['3','3-����'],['4','4-ҽ��'],['5','5-����']]
		});
		var appField = new Ext.form.ComboBox({
			id: 'appField',
			fieldLabel: 'Ӧ��ϵͳ���',
			listWidth : 230,
			selectOnFocus: true,
			allowBlank: false,
			store: appStore,
			anchor: '90%',
			value:'1', //Ĭ��ֵ
			valueNotFoundText:rowObj[0].get("appSysName"),
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'ѡ���־...',
			mode: 'local', //����ģʽ
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			name:'order',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(appField.getValue()!=""){
							descField.focus();
						}else{
							Handler = function(){appField.focus();}
							Ext.Msg.show({title:'����',msg:'Ӧ��ϵͳ���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var descField = new Ext.form.TextField({
			id:'descField',
			fieldLabel: 'ά�ȷ�������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'ά�ȷ�������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'desc',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						isInnerField.focus();
					}
				}
			}
		});
		
		var isInnerField = new Ext.form.Checkbox({
			id: 'isInnerField',
			labelSeparator: '���ñ�־:',
			allowBlank: false,
			checked: (rowObj[0].data['isInner'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
		
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '��Ч��־:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
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
				codeField,
				nameField,
				orderField,
				//appField,
				descField,
				isInnerField,
				activeField
			]
		});
	
		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			appField.setValue(rowObj[0].get("appSysDr"));
		});
		
		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){
			var code = codeField.getValue();
			var name = nameField.getValue();
			var order = orderField.getValue();
			//var appSysDr = Ext.getCmp('appField').getValue();
			var desc = descField.getValue();
			var isInner = (isInnerField.getValue()==true)?'Y':'N';
			var active = (activeField.getValue()==true)?'Y':'N';
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'����',msg:'ά�ȷ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'����',msg:'ά�ȷ�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: '../csp/dhc.pa.dimenstypeexe.csp?action=edit&rowid='+rowid+'&code='+code+'&name='+name+'&order='+order+'&appSysDr='+2+'&desc='+desc+'&isInner='+isInner+'&active='+active,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						DimensTypeTabDs.load({params:{start:0,limit:DimensTypeTabPagingToolbar.pageSize}});
						editwin.close();
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ�������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'ά�ȷ��������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
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
			title: '�޸�ά�ȷ����¼',
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
			buttons: [
				editButton,
				cancelButton
			]
		});
	
		//������ʾ
		editwin.show();
}

//�޸İ�ť
var editDimensType = new Ext.Toolbar.Button({
	text: '�޸�ά�����',
    tooltip:'�޸�ά�����',        
    iconCls:'add',
	handler:function(){
		edit();
	}
});

//ɾ����ť
var delDimensType = new Ext.Toolbar.Button({
	text: 'ɾ��ά�����',
    tooltip:'ɾ��ά�����',        
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=DimensTypeTab.getSelections();
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
				var isInner = rowObj[0].get("isInner");
				//�ж��Ƿ�����������,�����������ɾ��,������Ա�ɾ��
				if(isInner=="Y"||isInner=="Yes"||isInner=="y"||isInner=="yes"){
					Ext.Msg.show({title:'ע��',msg:'��������,������ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				}else{
					Ext.Ajax.request({
						url:'../csp/dhc.pa.dimenstypeexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DimensTypeTabDs.load({params:{start:0,limit:DimensTypeTabPagingToolbar.pageSize}});
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});

//��ʼ�������ֶ�
var DimensTypeSearchField ='name';

//����������
var DimensTypeFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'code',
			checked: false ,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'name',
			checked: false,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		})/*,
		new Ext.menu.CheckItem({ 
			text: 'Ӧ��ϵͳ���',
			value: 'appSysName',
			checked: false,
			group: 'DimensTypeFilter',
			checkHandler: onDimensTypeItemCheck 
		})*/
	]}
});

//����������Ӧ����
function onDimensTypeItemCheck(item, checked){
	if(checked) {
		DimensTypeSearchField = item.value;
		DimensTypeFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var DimensTypeSearchBox = new Ext.form.TwinTriggerField({
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
			DimensTypeTabDs.proxy = new Ext.data.HttpProxy({url: DimensTypeTabUrl + '?action=list'});
			DimensTypeTabDs.load({params:{start:0, limit:DimensTypeTabPagingToolbar.pageSize}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			DimensTypeTabDs.proxy = new Ext.data.HttpProxy({
				url: DimensTypeTabUrl + '?action=list&searchField=' + DimensTypeSearchField + '&searchValue=' + this.getValue()});
	        	DimensTypeTabDs.load({params:{start:0, limit:DimensTypeTabPagingToolbar.pageSize}});
	    	}
	}
});

//��ҳ������
var DimensTypeTabPagingToolbar = new Ext.PagingToolbar({
    store: DimensTypeTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',DimensTypeFilterItem,'-',DimensTypeSearchBox]
});

//���
var DimensTypeTab = new Ext.grid.EditorGridPanel({
	title: 'ά�ȷ���ά������',
	store: DimensTypeTabDs,
	cm: DimensTypeTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:[addDimensType,'-',editDimensType,'-',delDimensType],
	bbar:DimensTypeTabPagingToolbar
});

//����
DimensTypeTabDs.load({params:{start:0, limit:DimensTypeTabPagingToolbar.pageSize}});

/*
DimensTypeTab.on('contextmenu',function(e){
    if(!this.menu){
		this.menu = new Ext.menu.Menu({
			items:[
				{
					text: 'Add Product',
					handler: addProduct
				},{
					text: 'Edit Product(s)'
					//handler: editProduct
				},{
					text: 'Delete Product(s)'
					//handler: deleteProduct
				}
			]
		});
    }
	e.preventDefault(); 
    this.menu.showAt(e.getXY());
});
	
addProduct=function(){
	alert("�������!");
	edit();
}

*/

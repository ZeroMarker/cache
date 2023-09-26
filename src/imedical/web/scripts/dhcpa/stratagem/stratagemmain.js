/**
  *name:tab of database
  *author:limingzhong
  *Date:2009-11-6
 */

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

//========================================================================================

var value = "http: //www.baidu.com";

function DomUrl(){
	//alert("aaaaaaaaaaa");
	/*
	var row = grid.getSelectionModel().selectRow(startrow);//ѡ�е�ǰ��
	var rownum = grid.getSelectionModel().getSelected();//��ȡ��ǰ��
	startrow ++;
	var strurl = "abc.jsp?id=" + rownum.get('id');//��ȡ��ǰѡ���е�ֵ������֯�����ַ���
	return "<a href='"+strurl+"'>"+value+"</a>";
	*/
	return "<a href=>"+value+"</a>";
} 
//========================================================================================
 
var unitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=unit&str='+Ext.getCmp('unitField').getRawValue(),method:'POST'})
});

var unitField = new Ext.form.ComboBox({
	id: 'unitField',
	fieldLabel: '������λ',
	width:180,
	listWidth : 200,
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
	editable:true
});

var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '��������',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var currStratagemStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [['Y','��ǰս��'],['N','�ǵ�ǰս��']]
});
var currStratagemField = new Ext.form.ComboBox({
	id: 'currStratagemField',
	fieldLabel: '��ǰս��',
	listWidth : 130,
	listWidth : 200,
	selectOnFocus: true,
	allowBlank: false,
	store: currStratagemStore,
	anchor: '90%',
	value:'Y', //Ĭ��ֵ
	valueNotFoundText:'��ǰս��',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���־...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});

//�������Դ
var StratagemTabUrl = 'dhc.pa.stratagemexe.csp';
var StratagemTabProxy= new Ext.data.HttpProxy({url:StratagemTabUrl + '?action=list'});
var StratagemTabDs = new Ext.data.Store({
	proxy: StratagemTabProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'unitDr',
		'unitName',
		'cycleDr',
		'cycleName',
		'code',
		'name',
		'shortcut',
		'isVFlag',
		'state',
		'stateName',
		'monthDr',
		'monthName',
		'desc',
		'linkFile',
		'nurFlag',
		'medFlag',
		'postFlag',
		'currStratagem'
	]),
    // turn on remote sorting
    remoteSort: true
});

//����Ĭ�������ֶκ�������
StratagemTabDs.setDefaultSort('rowid', 'desc');

//���ݿ�����ģ��
var StratagemTabCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 /*{
    	header: '��λ',
        dataIndex: 'unitName',
        width: 70,
        sortable: true
    },*/{
    	header: '���',
        dataIndex: 'cycleName',
        width: 70,
        sortable: true
    },{
    	header: '����',
        dataIndex: 'code',
        width: 70,
        sortable: true
    },{
        header: "����",
        dataIndex: 'name',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header:'��ǰս��',
		width:60,
		dataIndex:'currStratagem',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'�����־',
		width:60,
		dataIndex:'isVFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header: "���Ҽ�Ч״̬",
        dataIndex: 'stateName',
        width: 80,
        align: 'left',
        sortable: true
    },{
        header: "��ǰ������",
        dataIndex: 'monthName',
        width: 80,
        align: 'left',
        sortable: true,
		editor:new Ext.form.ComboBox({
			id:'editcom',
			editable:false,
			valueField: 'key',
			displayField:'value',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['key','value'],
				data:[['1','1��'],['2','2��'],['3','3��'],['4','4��'],['5','5��'],['6','6��'],['7','7��'],['8','8��'],['9','9��'],['10','10��'],['11','11��'],['12','12��']]
			}),
			listeners :{
				specialKey :function(field,e){
					if (e.getKey()==Ext.EventObject.ENTER){
						//��ȡ������¼���޸ĵ��ֶ�ֵ
						var monthDr = Ext.getCmp('editcom').getValue();
						//��ȡ������¼��rowid
						var rowObj=StratagemTab.getSelections();
						var len = rowObj.length;
						var rowid = rowObj[0].get("rowid");
						
						var unitdr=Ext.getCmp('unitField').getValue();
						var cycledr=Ext.getCmp('cycleField').getValue();
						var currstratagem=Ext.getCmp('currStratagemField').getValue();
						
						//�жϸ���ս���Ƿ��Ѿ����ر�
						var state = rowObj[0].get("state");
						if(state=="close"){
							Ext.Msg.show({title:'��ʾ',msg:'��ս���Ѿ����ر�,�������ٱ��޸Ļ�ˢ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr,currstratagem:currstratagem}});
							return false;						
						}else{
							Ext.Ajax.request({
								url:'dhc.pa.stratagemexe.csp?action=refresh&rowid='+rowid+'&monthDr='+monthDr,
								waitMsg:'ˢ����...',
								failure: function(result, request){
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										Ext.Msg.show({title:'ע��',msg:'ˢ�³ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr,currstratagem:currstratagem}});
									}else{
										Ext.Msg.show({title:'����',msg:'ˢ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
								scope: this
							});
						}
					}
				}
			}
		})
    }/*,{
        header:'����״̬��־',
		width:80,
		dataIndex:'nurFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'ҽ��״̬��־',
		width:80,
		dataIndex:'medFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:'��λ״̬��־',
		width:80,
		dataIndex:'postFlag',
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }*/,{
        header: "Ŀ���Ҫ",
        dataIndex: 'desc',
        width: 120,
        align: 'left',
        sortable: true
    }
/**
,{
        header: "˵���ļ�",
        dataIndex: 'linkFile',
        width: 180,
        align: 'left',
        sortable: true,
		renderer : function(v, p, record){
			return '<font color=blue>�ļ�˵��</font>';
		}
    }

**/
]);

//��ʼ��Ĭ��������
StratagemTabCm.defaultSortable = true;

//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
		var unitdr=Ext.getCmp('unitField').getValue();
		var cycledr=Ext.getCmp('cycleField').getValue();
		var currstratagem=Ext.getCmp('currStratagemField').getValue();
		StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr,currstratagem:currstratagem}});
	}
});

//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
	text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
		
		var unitds = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		unitds.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=unit&str='+Ext.getCmp('uField').getRawValue(),method:'POST'})
		});

		var uField = new Ext.form.ComboBox({
			id: 'uField',
			fieldLabel: '������λ',
			width:231,
			listWidth : 231,
			allowBlank: false,
			store: unitds,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ��������λ...',
			name: 'uField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(uField.getValue()!=""){
							cField.focus();
						}else{
							Handler = function(){uField.focus();}
							Ext.Msg.show({title:'����',msg:'��λ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var cycleds = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
		});

		cycleds.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cField').getRawValue()+'&active=Y',method:'POST'})
		});

		var cField = new Ext.form.ComboBox({
			id: 'cField',
			fieldLabel: '��������',
			width:231,
			listWidth : 231,
			allowBlank: false,
			store: cycleds,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ�񿼺�����...',
			name: 'cField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!=""){
							codeField.focus();
						}else{
							Handler = function(){cField.focus();}
							Ext.Msg.show({title:'����',msg:'�������ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		
		var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: 'Ŀ�����',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'Ŀ�����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'Ŀ����벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: 'Ŀ������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'Ŀ������...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							currStrField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'Ŀ�����Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var currStrStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['Y','��ǰս��'],['N','�ǵ�ǰս��']]
		});
		var currStrField = new Ext.form.ComboBox({
			id: 'currStrField',
			fieldLabel: '��ǰս��',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: currStrStore,
			anchor: '90%',
			value:'Y', //Ĭ��ֵ
			valueNotFoundText:'��ǰս��',
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
						if(currStrField.getValue()!=""){
							stateField.focus();
						}else{
							Handler = function(){currStrField.focus();}
							Ext.Msg.show({title:'����',msg:'��ǰս�Բ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var stateStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['close','�ѹر�'],['new','����'],['confirm','���´�']]
		});
		var stateField = new Ext.form.ComboBox({
			id: 'stateField',
			fieldLabel: '���Ҽ�Ч��ʾ',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: stateStore,
			anchor: '90%',
			value:'new', //Ĭ��ֵ
			valueNotFoundText:'����',
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
						if(stateField.getValue()!=""){
							monthField.focus();
						}else{
							Handler = function(){stateField.focus();}
							Ext.Msg.show({title:'����',msg:'���Ҽ�Ч��ʾ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var monthStore = new Ext.data.SimpleStore({
			fields:['key','keyValue'],
			data:[['1','1��'],['2','2��'],['3','3��'],['4','4��'],['5','5��'],['6','6��'],['7','7��'],['8','8��'],['9','9��'],['10','10��'],['11','11��'],['12','12��']]
		});
		var monthField = new Ext.form.ComboBox({
			id: 'monthField',
			fieldLabel: '��ǰ������',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: monthStore,
			anchor: '90%',
			value:'1', //Ĭ��ֵ
			valueNotFoundText:'1��',
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
						if(monthField.getValue()!=""){
							descField.focus();
						}else{
							Handler = function(){monthField.focus();}
							Ext.Msg.show({title:'����',msg:'Ӧ��ϵͳ���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var descField = new Ext.form.TextField({
			id:'descField',
			fieldLabel: 'Ŀ���Ҫ',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'Ŀ���Ҫ...',
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
				//uField,
				cField,
				codeField,
				nameField,
				currStrField,
				stateField,
				monthField,
				descField
			]
		});
		
		//��ʼ����Ӱ�ť
		addButton = new Ext.Toolbar.Button({
			text:'�� ��'
		});
		
		//������Ӱ�ť��Ӧ����
		addHandler = function(){
			//var unitdr = Ext.getCmp('uField').getValue();
			var cycledr = Ext.getCmp('cField').getValue();
			var code = codeField.getValue();
			var name = nameField.getValue();
			var currStratagem = Ext.getCmp('currStrField').getValue();
			var state = Ext.getCmp('stateField').getValue();
			var monthDr = Ext.getCmp('monthField').getValue();
			var desc = descField.getValue();
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'����',msg:'ս��Ŀ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'����',msg:'ս��Ŀ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			
			Ext.Ajax.request({
				url: 'dhc.pa.stratagemexe.csp?action=add&code='+code+'&name='+name+'&unitdr=&cycledr='+cycledr+'&state='+state+'&desc='+desc+'&monthDr='+monthDr+'&currstratagem='+currStratagem,
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
						//var unitdr=Ext.getCmp('unitField').getValue();
						var cycledr=Ext.getCmp('cycleField').getValue();
						var currstratagem=Ext.getCmp('currStratagemField').getValue();
						StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,cycledr:cycledr,currstratagem:currstratagem}});
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'��ս��Ŀ������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'��ս��Ŀ�������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			title: '���ս��Ŀ���¼',
			width: 400,
			height:330,
			minWidth: 400, 
			minHeight: 330,
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
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=StratagemTab.getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			var state = rowObj[0].get("state");
			if(state=="close"){
				Ext.Msg.show({title:'ע��',msg:'���������Ѿ����ر�,���������޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
			if(state=="confirm"){
				Ext.Msg.show({title:'ע��',msg:'��ս�����´�,�������ٱ༭!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return false;
			}
		}
		var UnitDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		UnitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=unit&str='+Ext.getCmp('Unit').getRawValue(),method:'POST'})
		});

		var Unit = new Ext.form.ComboBox({
			id:'Unit',
			fieldLabel:'������λ',
			width:231,
			listWidth:231,
			allowBlank:false,
			store:UnitDs,
			valueField:'rowid',
			displayField:'name',
			triggerAction:'all',
			emptyText:'��ѡ��������λ...',
			name:'Unit',
			minChars:1,
			pageSize:10,
			selectOnFocus:true,
			forceSelection:'true',
			valueNotFoundText:rowObj[0].get("unitName"),
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(Unit.getValue()!=""){
							Cycle.focus();
						}else{
							Handler = function(){Unit.focus();}
							Ext.Msg.show({title:'����',msg:'��λ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var CycleDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
		});

		CycleDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('Cycle').getRawValue()+'&active=Y',method:'POST'})
		});

		var Cycle = new Ext.form.ComboBox({
			id: 'Cycle',
			fieldLabel: '��������',
			width:231,
			listWidth : 231,
			allowBlank: false,
			store: CycleDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ�񿼺�����...',
			name: 'Cycle',
			valueNotFoundText:rowObj[0].get("cycleName"),
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(Cycle.getValue()!=""){
							CodeField.focus();
						}else{
							Handler = function(){Cycle.focus();}
							Ext.Msg.show({title:'����',msg:'�������ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		
		var CodeField = new Ext.form.TextField({
			id:'CodeField',
			fieldLabel: 'Ŀ�����',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'Ŀ�����...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'code',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(CodeField.getValue()!=""){
							NameField.focus();
						}else{
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'����',msg:'Ŀ����벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
	
		var NameField = new Ext.form.TextField({
			id:'NameField',
			fieldLabel: 'Ŀ������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'Ŀ������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'name',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(NameField.getValue()!=""){
							CurrField.focus();
						}else{
							Handler = function(){NameField.focus();}
							Ext.Msg.show({title:'����',msg:'Ŀ�����Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var CurrField = new Ext.form.Checkbox({
			id: 'CurrField',
			labelSeparator: 'ս��״̬:',
			allowBlank: false,
			checked: (rowObj[0].data['currStratagem'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						isVFField.focus();
					}
				}
			}
		});
		
		var isVFField = new Ext.form.Checkbox({
			id: 'isVFField',
			labelSeparator: '�����־:',
			allowBlank: false,
			checked: (rowObj[0].data['isVFlag'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						StateField.focus();
					}
				}
			}
		});
		
		var stateFlagStore = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['close','�ѹر�'],['new','����'],['confirm','���´�']]
		});
		var StateField = new Ext.form.ComboBox({
			id: 'StateField',
			fieldLabel: '���Ҽ�Ч��ʾ',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: stateFlagStore,
			anchor: '90%',
			//value:'new', //Ĭ��ֵ
			valueNotFoundText:rowObj[0].get("stateName"),
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
						if(StateField.getValue()!=""){
							MonthField.focus();
						}else{
							Handler = function(){StateField.focus();}
							Ext.Msg.show({title:'����',msg:'���Ҽ�Ч��ʾ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var MonthStore = new Ext.data.SimpleStore({
			fields:['key','keyValue'],
			data:[['1','1��'],['2','2��'],['3','3��'],['4','4��'],['5','5��'],['6','6��'],['7','7��'],['8','8��'],['9','9��'],['10','10��'],['11','11��'],['12','12��']]
		});
		var MonthField = new Ext.form.ComboBox({
			id: 'MonthField',
			fieldLabel: '��ǰ������',
			listWidth : 231,
			selectOnFocus: true,
			allowBlank: false,
			store: MonthStore,
			anchor: '90%',
			//value:'1', //Ĭ��ֵ
			valueNotFoundText:rowObj[0].get("monthName"),
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
						if(MonthField.getValue()!=""){
							DescField.focus();
						}else{
							Handler = function(){MonthField.focus();}
							Ext.Msg.show({title:'����',msg:'Ӧ��ϵͳ���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var DescField = new Ext.form.TextField({
			id:'DescField',
			fieldLabel: 'Ŀ���Ҫ',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'Ŀ���Ҫ...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'desc',
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
				//Unit,
				Cycle,
				CodeField,
				NameField,
				CurrField,
				isVFField,
				StateField,
				MonthField,
				DescField
			]
		});
	
		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			//Unit.setValue(rowObj[0].get("unitDr"));
			Cycle.setValue(rowObj[0].get("cycleDr"));
			StateField.setValue(rowObj[0].get("state"));
			MonthField.setValue(rowObj[0].get("monthDr"));
		});
		
		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	
		//�����޸İ�ť��Ӧ����
		editHandler = function(){
			//var unitdr = Ext.getCmp('Unit').getValue();
			var cycledr = Ext.getCmp('Cycle').getValue();
			var code = CodeField.getValue();
			var name = NameField.getValue();
			var currstratagem = (CurrField.getValue()==true)?'Y':'N';
			var isVFlag = (isVFField.getValue()==true)?'Y':'N';
			var state = Ext.getCmp('StateField').getValue();
			var monthDr = Ext.getCmp('MonthField').getValue();
			var desc = DescField.getValue();
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'����',msg:'ս��Ŀ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'����',msg:'ս��Ŀ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			Ext.Ajax.request({
				url: 'dhc.pa.stratagemexe.csp?action=edit&rowid='+rowid+'&code='+code+'&name='+name+'&unitdr=&cycledr='+cycledr+'&state='+state+'&desc='+desc+'&monthDr='+monthDr+'&currstratagem='+currstratagem+'&isVFlag='+isVFlag,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						//var unitdr=Ext.getCmp('unitField').getValue();
						var cycledr=Ext.getCmp('cycleField').getValue();
						var currstratagem=Ext.getCmp('currStratagemField').getValue();
						StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,cycledr:cycledr,currstratagem:currstratagem}});
						editwin.close();
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'ս��Ŀ������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'ս��Ŀ�������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			title: '�޸�ս��Ŀ���¼',
			width: 400,
			height:330,
			minWidth: 400, 
			minHeight: 330,
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
/*
//ɾ����ť
var delStratagem = new Ext.Toolbar.Button({
	text: 'ɾ��ս��',
    tooltip:'ɾ��ս��',        
    iconCls:'add',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=StratagemTab.getSelections();
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
				var unitdr=Ext.getCmp('unitField').getValue();
				var cycledr=Ext.getCmp('cycleField').getValue();
				Ext.Ajax.request({
					url:'dhc.pa.stratagemexe.csp?action=del&rowid='+rowid,
					waitMsg:'ɾ����...',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							StratagemTabDs.load({params:{start:0,limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr}});
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
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ������ս��Ŀ���¼��?',handler);
	}
});
*/
var importFile = new Ext.Toolbar.Button({
	text: '����',
    tooltip:'����',        
    iconCls:'add',
	handler:function(){
		//�ļ��ϴ�����
		var excelUpload = new Ext.form.TextField({   
			id:'excelUpload', 
			name:'Excel',   
			anchor:'90%',   
			height:20,   
			inputType:'file',
			fieldLabel:'�ļ�ѡ��'
		});
		
		
		var form = new Ext.form.FormPanel({
			title:'Excel���ݵ���',
			labelWidth:80,
			bodyStyle:'padding:5 5 5 5',
			height:360,
			width:503,
			frame:true,
			fileUpload:true,
			items:excelUpload/*,
			buttons:[{text:'����Excel����',handler:handler}]*/
		})
		
		//���岢��ʼ��ȡ���޸İ�ť
		var button = new Ext.Toolbar.Button({
			text:'����'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		handler = function(){
			alert("aaaaaaaaaaaa");
			var excelName = Ext.getCmp('excelUpload').getRawValue();//�ϴ��ļ����Ƶ�·��
			if(excelName==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ���ļ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFOR});
				return false;
			}else{ 
				var array=new Array();
				array=excelName.split("\\");
				var fileName="";
										var i=0;
										for(i=0;i<array.length;i++){
											if(fileName==""){
												fileName=array[i];
											}else{
												fileName=fileName+"/"+array[i];
											}
										}
										var uploadUrl = "http://172.16.2.20:8080/dhcpaverify/uploadfile";
										var upUrl = uploadUrl+'?fileName='+encodeURI(encodeURI(fileName));
										
										form.getForm().submit({
											url:upUrl,
											method:'POST',
											waitMsg:'���ݵ�����, ���Ե�...',
											success:function(form, action, o) {
												Ext.MessageBox.alert("��ʾ��Ϣ","���ݳɹ�����!");
												//Ext.MessageBox.alert("Information",action.result.mess);
											},
											failure:function(form, action) {
												Ext.MessageBox.alert("Error",action.result.mess);
											}
										}); 
										/*
										
										Ext.Ajax.request({
											url:upUrl,
											waitMsg:'������...',
											failure: function(result, request){
												Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											},
											success: function(result, request){
												alert("aaaaaaaaaaaaaaaaa");
											},
											scope: this
										}); 
										*/
									}
		}
	
		//���ȡ����ť�ļ����¼�
		button.addListener('click',handler,false);
		
		var win = new Ext.Window({
			title: '�޸�ս��Ŀ���¼',
			width: 400,
			height:310,
			minWidth: 400, 
			minHeight: 310,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: form,
			buttons: [button
			]
		});
	
		//������ʾ
		win.show();
	}
});


//��ʼ�������ֶ�
var StratagemSearchField ='name';

//����������
var StratagemFilterItem = new Ext.Toolbar.MenuButton({
	text: '������',
	tooltip: '�ؼ����������',
	menu: {items: [
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'code',
			checked: false ,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '����',
			value: 'name',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '��ǰ������',
			value: 'monthName',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '���Ҽ�Ч��ʾ',
			value: 'stateName',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		}),
		new Ext.menu.CheckItem({ 
			text: '��������',
			value: 'cycleName',
			checked: false,
			group: 'StratagemFilter',
			checkHandler: onStratagemItemCheck 
		})
	]}
});

//����������Ӧ����
function onStratagemItemCheck(item, checked){
	if(checked) {
		StratagemSearchField = item.value;
		StratagemFilterItem.setText(item.text + ':');
	}
};

//���Ұ�ť
var StratagemSearchBox = new Ext.form.TwinTriggerField({
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
			var unitdr=Ext.getCmp('unitField').getValue();
			var cycledr=Ext.getCmp('cycleField').getValue();
			StratagemTabDs.proxy = new Ext.data.HttpProxy({url: StratagemTabUrl + '?action=list'+'&unitdr='+unitdr+'&cycledr='+cycledr+'&currstratagem='+Ext.getCmp('currStratagemField').getValue()});
			StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr}});
		}
	},
	onTrigger2Click: function() {
		if(this.getValue()) {
			var unitdr=Ext.getCmp('unitField').getValue();
			var cycledr=Ext.getCmp('cycleField').getValue();
			StratagemTabDs.proxy = new Ext.data.HttpProxy({
				url: StratagemTabUrl + '?action=list&searchField=' + StratagemSearchField + '&searchValue=' + this.getValue()+'&unitdr='+unitdr+'&cycledr='+cycledr+'&currstratagem='+Ext.getCmp('currStratagemField').getValue()});
	        	StratagemTabDs.load({params:{start:0, limit:StratagemTabPagingToolbar.pageSize,unitdr:unitdr,cycledr:cycledr}});
	    	}
	}
});

//��ҳ������
var StratagemTabPagingToolbar = new Ext.PagingToolbar({
    store: StratagemTabDs,
	pageSize:25,
    displayInfo: true,
    displayMsg: '�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg: "û�м�¼",
	buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
	doLoad:function(C){
		var B={},
		A=this.paramNames;
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['unitdr']=Ext.getCmp('unitField').getValue();
		B['cycledr']=Ext.getCmp('cycleField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
var StratagemTab = new Ext.grid.EditorGridPanel({
	title: 'ս��Ŀ��ά��',
	store: StratagemTabDs,
	cm: StratagemTabCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//tbar:['��λ:',unitField,'-','���:',cycleField,'-','ս��״̬:',currStratagemField,'-',findButton,'-',addButton,'-',editButton,'-',importFile],
	tbar:['���:',cycleField,'-','ս��״̬:',currStratagemField,'-',findButton,'-',addButton,'-',editButton],

	bbar:StratagemTabPagingToolbar
});

/*
StratagemTab.on('cellclick',function(grid,rowIndex,columnIndex,e){
	alert(columnIndex);
	if(columnIndex==9){
		accPeriodsEditor(grid);
	}else if(columnIndex==10){
		copyOtherMon(grid);
	}
	var uploadUrl = "http://172.16.2.20:8080/dhcpaverify/download";
	var fileName="mm.txt";
	var checkFileExist="Y";
	var is="N";
	var upUrl = uploadUrl+"?fileName="+encodeURI(encodeURI(fileName))+'&checkFileExist='+checkFileExist+'&is='+is;
    Ext.Ajax.request({
		url:upUrl,
		waitMsg:'������...',
		failure: function(result, request){
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if(jsonData.info=="success"){
				function handler(id){
					if(id=="yes"){
						is="Y";
						window.location.href = 'http://172.16.2.20:8080/dhcpaverify/download?fileName='+encodeURI(encodeURI(fileName))+'&checkFileExist='+checkFileExist+'&is='+is;  
					}else{
						return false;
					}
				}
				Ext.MessageBox.confirm('��ʾ','ȷʵҪ���ظ��ļ���?',handler);
			}else{
				Ext.Msg.show({title:'��ʾ',msg:'�ļ�������!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			} 
		},
		scope: this
	}); 
});
*/


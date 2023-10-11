var itemGridUrl = '../csp/herp.srm.srmdeptuserexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'deptdr',
			'deptname',
			'userdr',
			'username',
			'IsDirector',
			'IsDirectorlist',
			'mngdr',
			'mngname',
			'IsValid',
			'IsValidlist',
			'IsSecretary',
			'IsSecretarylist'
		]),
	    remoteSort: true
});

Ext.ns("dhc.herp");

dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});

var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		plugins : new dhc.herp.PageSizePlugin(),
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

//��ѯ��������
var deptDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])
     });


deptDs.on('beforeload', function(ds, o){
	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.srmdeptuserexe.csp'
	                     +'?action=caldept&str='
	                     + encodeURIComponent(Ext.getCmp('deptField').getRawValue()),
	               method:'POST'
	              });
     });

var deptField = new Ext.form.ComboBox({
			id: 'deptField',
			fieldLabel: '��������',
			width:120,
			listWidth : 250,
			//allowBlank: false,
			store: deptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '��ѡ���������...',
			name: 'deptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
	    	editable:true
});

//��ѯ��Ա����
var userDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
	     });
     
 userDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('userField').getRawValue()),
		   method:'POST'
		});
});

var userField = new Ext.form.ComboBox({
			id: 'userField',
			fieldLabel: '��Ա����',
			width:120,
			listWidth :250,
			//allowBlank: false,
			store: userDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'��ѡ������...',
			name: 'userField',
			pageSize : 10,
			minChars : 1,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
});

//��ѯ�Ƿ������
var DirectorStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '��'], ['Y', '��']]
		});
var DirectorField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ������',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			//allowBlank : false,
			store : DirectorStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			selectOnFocus : true,
			forceSelection : true
		});

//��ѯ�Ƿ������
var IsSecretaryStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '��'], ['Y', '��']]
		});
var IsSecretaryField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ������',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsSecretaryStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // ����ģʽ
			editable : true,
			selectOnFocus : true,
			forceSelection : true
		});
//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
					{
					    id:'rowid',
				    	header: 'id',
				        dataIndex: 'rowid',
				        width: 80,		  
				        hidden: true
				        //sortable: true
				    },{
					    id:'deptdr',
				    	header: '��������',
				        dataIndex: 'deptdr',
				        width: 180,		  
				        hidden: true
				        //sortable: true
				    },{
					    id:'deptname',
				    	header: '��������',
				        dataIndex: 'deptname',
				        width: 180	  
				        //sortable: true
				    },{ 
				        id:'userdr',
				    	header: '��Ա����',
				        dataIndex: 'userdr',
				        width: 120	,  
				        hidden:true
				        //sortable: true
				    },{ 
				        id:'username',
				    	header: '��Ա����',
				        dataIndex: 'username',
				        width: 100  
				        //sortable: true
				    },{ 
				        id:'IsDirector',
				    	header: '�Ƿ������',
				        dataIndex: 'IsDirector',
				        width: 80,
				        hidden:true	  
				        //sortable: true
				    },{ 
				        id:'mngdr',
				    	header: '�ϼ��쵼',
				        dataIndex: 'mngdr',
				        width: 100	,  
				        hidden:true
				        //sortable: true
				    },{ 
				        id:'mngname',
				    	header: '�ϼ��쵼',
				        dataIndex: 'mngname',
				        width: 100	  
				        //sortable: true
				    },{ 
				        id:'IsDirectorlist',
				    	header: '�Ƿ������',
				        dataIndex: 'IsDirectorlist',
				        width: 80	  
				        //sortable: true
				    },{           
				         id:'IsValid',
				         header: '�Ƿ���Ч',
				         allowBlank: false,
				         width:80,
				         hidden:true,
				         dataIndex: 'state'
				    },{           
				         id:'IsValidlist',
				         header: '�Ƿ���Ч',
				         allowBlank: false,
				         hidden:true,
				         width:60,
				         dataIndex: 'IsValidlist'
				    },{           
				         id:'IsSecretary',
				         header: '�Ƿ������',
				         allowBlank: false,
				         width:100,
				         hidden:true,
				         dataIndex: 'state'
				    },{           
				         id:'IsSecretarylist',
				         header: '�Ƿ������',
				         allowBlank: false,
				         width:80,
				         dataIndex: 'IsSecretarylist'
				    }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '����',
					iconCls : 'edit_add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls : 'pencil',
					handler : function() {
						srmdeptuserEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			//tooltip : 'ɾ��',
			iconCls : 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫɾ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : 'ɾ����...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '����',
												msg : '������������!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : 'ע��',
													msg : '�����ɹ�!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGridDs.load({
													params : {
														start : 0,
														limit : itemGridPagingToolbar.pageSize
													}
												});
									} else {
										Ext.Msg.show({
													title : '����',
													msg : '����',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					})
				}
			}
});

var SearchButton = new Ext.Toolbar.Button({
    text: '��ѯ', 
    //tooltip:'��ѯ',        
    iconCls:'search',
	handler:function(){	
	    var deptdr = deptField.getValue();
        var userdr = userField.getValue();
        var IsDirector= DirectorField.getValue();
        var IsSecretary=IsSecretaryField.getValue();
	//itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,deptdr:deptdr,userdr:userdr,IsDirector:IsDirector,IsSecretary:IsSecretary}}));
	itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : itemGridUrl+'?action=list&deptdr='+ encodeURIComponent(deptdr)+ 
								'&userdr='+encodeURIComponent(userdr)+
								'&IsDirector='+ encodeURIComponent(IsDirector)+
								'&IsSecretary='+ encodeURIComponent(IsSecretary),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : 25,
									sortDir:'',
									sortField:''
								}
							});
	}
});

var itemGrid = new Ext.grid.GridPanel({
			title: '��֯��ϵ��Ϣά��',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmdeptuserexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['','����','',deptField,'','����','',userField,'','�Ƿ������','',DirectorField,'','�Ƿ������','',IsSecretaryField,'','-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
});


itemGridDs.load({	params:{start:0, limit:itemGridPagingToolbar.pageSize}});

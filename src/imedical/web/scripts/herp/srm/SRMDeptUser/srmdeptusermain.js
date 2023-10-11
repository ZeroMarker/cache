var itemGridUrl = '../csp/herp.srm.srmdeptuserexe.csp';
//配件数据源
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
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

//查询科室名称
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
			fieldLabel: '科室名称',
			width:120,
			listWidth : 250,
			//allowBlank: false,
			store: deptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '请选择科室名称...',
			name: 'deptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
	    	editable:true
});

//查询人员姓名
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
			fieldLabel: '人员名称',
			width:120,
			listWidth :250,
			//allowBlank: false,
			store: userDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'请选择姓名...',
			name: 'userField',
			pageSize : 10,
			minChars : 1,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
});

//查询是否科主任
var DirectorStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '否'], ['Y', '是']]
		});
var DirectorField = new Ext.form.ComboBox({
			fieldLabel : '是否科主任',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			//allowBlank : false,
			store : DirectorStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			selectOnFocus : true,
			forceSelection : true
		});

//查询是否科秘书
var IsSecretaryStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '否'], ['Y', '是']]
		});
var IsSecretaryField = new Ext.form.ComboBox({
			fieldLabel : '是否科秘书',
			width : 80,
			listWidth : 80,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsSecretaryStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			selectOnFocus : true,
			forceSelection : true
		});
//数据库数据模型
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
				    	header: '科室名称',
				        dataIndex: 'deptdr',
				        width: 180,		  
				        hidden: true
				        //sortable: true
				    },{
					    id:'deptname',
				    	header: '科室名称',
				        dataIndex: 'deptname',
				        width: 180	  
				        //sortable: true
				    },{ 
				        id:'userdr',
				    	header: '人员姓名',
				        dataIndex: 'userdr',
				        width: 120	,  
				        hidden:true
				        //sortable: true
				    },{ 
				        id:'username',
				    	header: '人员姓名',
				        dataIndex: 'username',
				        width: 100  
				        //sortable: true
				    },{ 
				        id:'IsDirector',
				    	header: '是否科主任',
				        dataIndex: 'IsDirector',
				        width: 80,
				        hidden:true	  
				        //sortable: true
				    },{ 
				        id:'mngdr',
				    	header: '上级领导',
				        dataIndex: 'mngdr',
				        width: 100	,  
				        hidden:true
				        //sortable: true
				    },{ 
				        id:'mngname',
				    	header: '上级领导',
				        dataIndex: 'mngname',
				        width: 100	  
				        //sortable: true
				    },{ 
				        id:'IsDirectorlist',
				    	header: '是否科主任',
				        dataIndex: 'IsDirectorlist',
				        width: 80	  
				        //sortable: true
				    },{           
				         id:'IsValid',
				         header: '是否有效',
				         allowBlank: false,
				         width:80,
				         hidden:true,
				         dataIndex: 'state'
				    },{           
				         id:'IsValidlist',
				         header: '是否有效',
				         allowBlank: false,
				         hidden:true,
				         width:60,
				         dataIndex: 'IsValidlist'
				    },{           
				         id:'IsSecretary',
				         header: '是否科秘书',
				         allowBlank: false,
				         width:100,
				         hidden:true,
				         dataIndex: 'state'
				    },{           
				         id:'IsSecretarylist',
				         header: '是否科秘书',
				         allowBlank: false,
				         width:80,
				         dataIndex: 'IsSecretarylist'
				    }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '增加',
					iconCls : 'edit_add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls : 'pencil',
					handler : function() {
						srmdeptuserEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			//tooltip : '删除',
			iconCls : 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
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
													title : '错误',
													msg : '错误',
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
    text: '查询', 
    //tooltip:'查询',        
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
			title: '组织关系信息维护',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmdeptuserexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['','科室','',deptField,'','姓名','',userField,'','是否科主任','',DirectorField,'','是否科秘书','',IsSecretaryField,'','-',SearchButton,'-',addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
});


itemGridDs.load({	params:{start:0, limit:itemGridPagingToolbar.pageSize}});

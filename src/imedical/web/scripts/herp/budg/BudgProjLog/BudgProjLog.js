
	//安全组 
var uNameField = new Ext.form.TextField({
	id: 'uNameField',
	fieldLabel: '安全组',
	width:120,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'uNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

	//用户名 
var userNameField = new Ext.form.TextField({
	id: 'userNameField',
	fieldLabel: '用户名',
	width:120,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'userNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

	//用户名 
var cNameField = new Ext.form.TextField({
	id: 'cNameField',
	fieldLabel: '类名称/描述',
	width:120,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'cNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});
	//用户名 
var objectField = new Ext.form.TextField({
	id: 'objectField',
	fieldLabel: '对象描述',
	width:120,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'模糊查询...',
	name: 'objectField',
	minChars: 1,
	pageSize: 10,
	editable:true
});
var updateField = new Ext.form.DateField({
	id:'updateField',
	fieldLabel: '修改日期',
	width:120,
	allowBlank:true,
	format:'Y-m-d',
	renderer : function(v, p, r, i) {			
	if (v instanceof Date) {
		return new Date(v).format("Y-m-d");
	} else {
		return v;
	}
	},
	selectOnFocus:'true'
});

	var btnSearch = new Ext.Button({
	id : 'btnSearch',
	text : '查询',
	handler : function() {
	var CName=cNameField.getValue();
	var ODesc=objectField.getValue();
	var UName=uNameField.getValue();
	var name=userNameField.getValue();//用户名
	if(updateField.getValue()===""){
	var Date="";
	}else{
	Date=updateField.getValue().format('Y-m-d');
	}
	//alert(Date);
	itemGrid.load(({params:{start:0, limit:25,ClassName:CName,ObjectDesc:ODesc,UpdateUserName:UName,UpdateDate:Date,name:name}}));			

				}
			});
var delButton = new Ext.Toolbar.Button({
	text: '删除', 
    tooltip : '可同时删除多条',      
    iconCls:'add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
		var len = selectedRow.length;
		var str="";
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var i=0;i<len;i++){
			str+=selectedRow[i].data['rowid']+ "^";
		}
 		Ext.MessageBox.confirm('提示', '确定要删除选定的行吗', function(btn) {
			if (btn == 'yes') {
						Ext.Ajax.request({
							url:'../csp/dhc.sync.syncchangelogexe.csp?action=del&rowid='+str,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}else
						{
							Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});}
						});
			}
});

	var tb = new Ext.Toolbar({
				id : 'tb',
				items : ['类名称/描述:', cNameField, '-',
						'对象描述:', objectField, '-',
						'用户名:',userNameField,
						'安全组:',uNameField, '-',
						'更新日期:',updateField,
						'-', btnSearch, '-',delButton
				]
			});

var itemGrid = new dhc.herp.Grid({
        title: '码表数据日志管理',
        width: 400, 
        readerModel:'remote',
        region: 'center',
        atLoad: true,
        url: 'herp.budg.budgprojlogexe.csp',
        tbar : tb,
        fields: [new Ext.grid.CheckboxSelectionModel({editable:false}),
						{
							id:'rowid',
							header:'rowid',
							dataIndex : 'rowid',
							hidden : true
						},{
           	 				id:'CompName',
           					header: '医疗单位',
							calunit:true,
							allowBlank: false,
							width:120,
							hidden : true,
            				dataIndex: 'CompName'
        				}, {
							id:'TableName',
							header : '表名称',
							dataIndex : 'TableName',
							editable:false,
							width : 180
						}, {
							id:'ClassName',
							header : '类名称',
							dataIndex : 'ClassName',
							editable:false,							
							width : 180
						},{
							id:'ClassNameDesc',
							header : '类描述',
							dataIndex : 'ClassNameDesc',
							editable:false,
							width : 150
						},{
							id:'ObjectReference',
							header : '对象ID',
							dataIndex : 'ObjectReference',
							editable:false,
							width : 220
						},{
							id:'ObjectDesc',
							header : '对象描述',
							width : 250,
							editable:false,
							dataIndex : 'ObjectDesc'
						}, {
							id:'UpdateUserDR',
							header : '用户',
							width : 60,
							editable:false,
							dataIndex : 'UpdateUserDR'
						}, {
							id:'UpdateUserName',
							header : '安全组',
							editable:false,
							dataIndex : 'UpdateUserName'
						}, {
							id:'UpdateDate',
							header : '更新日期',
							editable:false,
							dataIndex : 'UpdateDate'
						}, {
							id:'UpdateTime',
							header : '更新时间',
							editable:false,
							dataIndex : 'UpdateTime'
						}, {
							id:'OperateType',
							header : '操作类型',
							editable:false,
							dataIndex : 'OperateType',
							renderer : function(v){
								if(v=='R'){return ""+"   读取";}
								if(v=='U'){return ""+"   修改";}
								if(v=='D'){return ""+"   删除";}
								if(v=='A'){return ""+"   新增";}
							}
						}, {
							id:'NewValue',
							header : '修正的数据',
							editable:false,
							dataIndex : 'NewValue',
							width : 250
						}] 
});
	
	itemGrid.btnAddHide(); 	//隐藏增加按钮
	itemGrid.btnSaveHide();	//隐藏保存按钮
	itemGrid.btnResetHide(); 	//隐藏重置按钮
	itemGrid.btnDeleteHide(); //隐藏删除按钮
	itemGrid.btnPrintHide(); 	//隐藏打印按钮



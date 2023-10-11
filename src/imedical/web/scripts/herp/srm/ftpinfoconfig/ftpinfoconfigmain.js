
//配置数据源
var itemGridUrl = '../csp/herp.srm.ftpinfoconfigexe.csp';
var itemGridProxy = new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,//定义一个url的访问请求
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'TypeDR',
			'Type',
			'FtpUser',
			'FtpPassWord',
			'FtpIP',
			'FtpDesc'
		]),
	    remoteSort: true
});

//设置的分页-右下角
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
				width : 40//右下角页面显示数据条数框的宽度
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

//定义分页刷新
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		plugins : new dhc.herp.PageSizePlugin(),
		emptyMsg: "没有数据"//,

});

//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

//var tmpTitle='柏儒练习';




//数据显示列表cm—定义输出数据列表
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{

            id:'TypeDR',
            header: 'TypeDR',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'TypeDR'
       },{

            id:'Type',
            header: '配置类型',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Type'
       }, {
            id:'FtpIP',
            header: 'IP(含端口)',
            allowBlank: false,
            width:150,
            editable:false,
            dataIndex: 'FtpIP'
       }, {
            id:'FtpUser',
            header: '用户名',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'FtpUser'
       }/*, {
            id:'FtpPassWord',
            header: '密码',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'FtpPassWord',
            renderer : function(FtpPassWord) {return '****'}
       }*/,{
            id:'FtpDesc',
            header: '描述',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'FtpDesc'
       }
			    
]);


	
	



//工具条按钮tbar---定义功能按钮
var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '添加',
					iconCls: 'edit_add',
					handler : function() {
						srmftpinfoconfigAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls: 'pencil',
					handler : function() {
						srmftpinfoconfigEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			//tooltip : '删除',
			iconCls: 'edit_remove',
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

var itemGrid = new Ext.grid.GridPanel({
			title: '科研配置',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.ftpinfoconfigexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,/*数据来源store*/
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton],/*这里添加的是按钮-工具条按钮tbar*/
			bbar:itemGridPagingToolbar/*这里添加的是下面分页和刷新的-分页刷新bbar*/
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});


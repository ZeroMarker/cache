
//��������Դ
var itemGridUrl = '../csp/herp.srm.ftpinfoconfigexe.csp';
var itemGridProxy = new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,//����һ��url�ķ�������
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

//���õķ�ҳ-���½�
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
				width : 40//���½�ҳ����ʾ����������Ŀ��
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

//�����ҳˢ��
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		plugins : new dhc.herp.PageSizePlugin(),
		emptyMsg: "û������"//,

});

//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

//var tmpTitle='������ϰ';




//������ʾ�б�cm��������������б�
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
            header: '��������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Type'
       }, {
            id:'FtpIP',
            header: 'IP(���˿�)',
            allowBlank: false,
            width:150,
            editable:false,
            dataIndex: 'FtpIP'
       }, {
            id:'FtpUser',
            header: '�û���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'FtpUser'
       }/*, {
            id:'FtpPassWord',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'FtpPassWord',
            renderer : function(FtpPassWord) {return '****'}
       }*/,{
            id:'FtpDesc',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'FtpDesc'
       }
			    
]);


	
	



//��������ťtbar---���幦�ܰ�ť
var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '���',
					iconCls: 'edit_add',
					handler : function() {
						srmftpinfoconfigAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls: 'pencil',
					handler : function() {
						srmftpinfoconfigEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			//tooltip : 'ɾ��',
			iconCls: 'edit_remove',
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

var itemGrid = new Ext.grid.GridPanel({
			title: '��������',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.ftpinfoconfigexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,/*������Դstore*/
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton],/*������ӵ��ǰ�ť-��������ťtbar*/
			bbar:itemGridPagingToolbar/*������ӵ��������ҳ��ˢ�µ�-��ҳˢ��bbar*/
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});




//��������Դ
var itemGridUrl = '../csp/herp.srm.SRMSystemModexe.csp';
var itemGridProxy = new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,//����һ��url�ķ�������
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'code',
			'name'
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
       }, {
            id:'code',
            header: 'ϵͳģ���',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'code'
       }, {
            id:'name',
            header: 'ϵͳģ������',
            allowBlank: false,
            width:120,
            editable:false,
            dataIndex: 'name'
       }
			    
]);


	
	



//��������ťtbar---���幦�ܰ�ť
var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '����',
					iconCls : 'edit_add',
					handler : function() {
						SRMSystemModAddFun();
					}
				});

var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    title: 'ϵͳģ����Ϣά��',
			iconCls: 'list',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.SRMSystemModexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,/*������Դstore*/
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton],/*������ӵ��ǰ�ť-��������ťtbar*/
			bbar:itemGridPagingToolbar/*������ӵ��������ҳ��ˢ�µ�-��ҳˢ��bbar*/
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

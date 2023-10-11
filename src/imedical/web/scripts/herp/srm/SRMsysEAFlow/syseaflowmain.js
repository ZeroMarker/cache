/////////////////////////////////////////////////

//var itemGridUrl = '../csp/herp.srm.syseaflowexe.csp';
var itemGridUrl = 'herp.srm.syseaflowexe.csp';

//�г��������ݵĵ��÷���
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});

//�������Դ
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'TypeID',
			'Type',
			'SysModuleID',
			'SysModuleName',
			'EAFMDr',
			'EAFMName'
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
		
//����ҳ�����ݸ���pageSizeȷ��ҳ����PagingToolbar����ÿҳ�����Ŀؼ�
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
itemGridDs.setDefaultSort('rowid');

	
//ColumnModel�����ģʽ
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            //id:'rowid',  //id�ɲ�д��������Ҳ�����
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            //sortable:true,
            dataIndex: 'rowid'   //����...exe.csp�е�$Get(%request.Data("rowid",1))
                                 // �����̨�е�jsonTitle="rowid^SysModuleID^EAFMDr"һ��
       },{
            id:'TypeID ',
            header: '����ID', //��ΰѸ������� ????
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            //sortable:true,
            dataIndex: 'TypeID'
       }, 
       {
            id:'Type',
            header: '����', //��ΰѸ������� ????
            allowBlank: false,
            width:80,
            editable:false,
            //sortable:true,
            dataIndex: 'Type'
       },  {
            id:'SysModuleID',
            header: 'ϵͳģ������', //��ΰѸ������� ????
            allowBlank: false,
            width:200,
            editable:false,
            hidden:true,
            //sortable:true,
            dataIndex: 'SysModuleID'
       }, 
       {
            id:'SysModuleName',
            header: 'ϵͳģ������', //��ΰѸ������� ????
            allowBlank: false,
            width:180,
            editable:false,
            //sortable:true,
            dataIndex: 'SysModuleName'
       }, {
            id:'EAFMDr',
            header: '����������',
            allowBlank: false,
            width:180,
            editable:false,
            //sortable:true,
            hidden:true,
            dataIndex: 'EAFMDr'
       }, {
            id:'EAFMName',
            header: '����������',
            allowBlank: false,
            width:180,
            editable:false,
            //sortable:true, 
            dataIndex: 'EAFMName'
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '����',  //�����ڰ�ť��ʱҳ���Զ���ʾ������
					iconCls : 'edit_add',   //��ť��ͼ��
					handler : function() {
						syseaflowAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls : 'pencil',
					handler : function() {
						syseaflowEditFun();
					}
				});
				
var delButton = new Ext.Toolbar.Button({
			        text : 'ɾ��',
					//tooltip : 'ɾ��',
					iconCls : 'edit_remove',
					handler : function() {
					syseaflowdelFun()
					}
				});

//��������
var itemGrid = new Ext.grid.GridPanel({
			title: 'ҵ����������Ϣά��',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.syseaflowexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,  //ʵ��������о���ʱ�Ĺ켣Ч��
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

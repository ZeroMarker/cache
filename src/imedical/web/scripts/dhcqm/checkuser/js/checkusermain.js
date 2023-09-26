////�Բ����ͳ��

var projUrl = 'dhc.qm.checkuserexe.csp';
var itemGridUrl = '../csp/dhc.qm.checkuserexe.csp';
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'CheckDr',
			'name',
			'active'
		]),
	    remoteSort: true
	    //��������صĲ�������remoteSort���������������ʵ�ֺ�̨�����ܵġ�������Ϊ remoteSort:trueʱ��store�������̨��������ʱ�Զ�����sort��dir�����������ֱ��Ӧ������ֶκ�����ķ�ʽ���ɺ�̨��ȡ�������������������ں�̨���������ݽ������������remoteSort:trueҲ�ᵼ��ÿ��ִ��sort()ʱ��Ҫȥ��̨���¼������ݣ�������ֻ�Ա������ݽ�������
});
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 20,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

var codefield = new Ext.form.TextField({
	id: 'codefield',
	fieldLabel: '����',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'codefield',
	minChars: 1,
	pageSize: 10,
	editable:true	
});
var namefield = new Ext.form.TextField({
	id: 'namefield',
	fieldLabel: '����',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'namefield',
	minChars: 1,
	pageSize: 10,
	editable:true	
});

var querypanel = new Ext.FormPanel({
			height:50,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
			items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						xtype:'displayfield',
						value:'����:',
						columnWidth:.05
					},
					namefield,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.02
					},
					{
						columnWidth:0.05,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							query();
						},
						iconCls:'find'
					}	
		     	]
			}]
});
 var query=function(){	
		var name = namefield.getValue();
		itemGridDs.proxy = new Ext.data.HttpProxy({   	
								url : 'dhc.qm.checkuserexe.csp?action=list&name='+encodeURIComponent(name),							
								method : 'GET'
								});		
		itemGridDs.load({
						params : {
							start : 0,
							limit : itemGridPagingToolbar.pageSize,
							dir:'',
							sort:''
						}
		});				
	};
var addButton = new Ext.Toolbar.Button({
					text : '���',
					iconCls:'add',
					handler : function() {
						 addfun();
				   }
  });
var updateButton = new Ext.Toolbar.Button({
					text : '�޸�',
					iconCls:'update',
					handler : function() {
						 updatefun();
				   }
  });
var delButton = new Ext.Toolbar.Button({
					text : 'ɾ��',
					iconCls : 'delete',//ָ��css��ʽ
					//icon : '../scripts/herp/srm/common/icons/delete.gif',ָ��·��
					handler : function() {
						 delfun();
				   }
 });
	//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        //new Ext.grid.CheckboxSelectionModel ({singleSelect : false}),
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {

            id:'name',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'name'
       }, {

            id:'active',
            header: '�Ƿ���Ч',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'active'
       }
]);

var itemGrid = new Ext.grid.GridPanel({
		    region: 'center',
		    layout:'fit',
		    //width:400,
		    height:575,
		    //autoHeight:true,//��ֻ��ʾһ�����ݣ������ô���
		    readerModel:'local',
		    url: 'dhc.qm.checkuserexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.CheckboxSelectionModel ({singleSelect : true}), 
			loadMask: true,
			tbar:[addButton,'-',updateButton,'-',delButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
})
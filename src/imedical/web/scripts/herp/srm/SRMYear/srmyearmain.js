
//��������Դ
var itemGridUrl = '../csp/herp.srm.yearexe.csp';
var itemGridProxy = new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,//����һ��url�ķ�������
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'Code',
			'Name',
			'StrDate',
			'EndDate',
			'IsValid'
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
       }, {
            id:'Code',
            header: '��ȱ���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Code'
       }, {
            id:'Name',
            header: '�������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Name'
       }, {
            id:'StrDate',
            header: '��ʼ����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'StrDate'
       },{
            id:'EndDate',
            header: '��������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'EndDate'
       }/*,{
            id:'IsValid',
            header: '�Ƿ���Ч',
			      //allowBlank: false,
			      //editable:false,
			      width:100,
            dataIndex: 'IsValid',
            type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }*/
			    
]);


	
	



//��������ťtbar---���幦�ܰ�ť
var addButton = new Ext.Toolbar.Button({
					text : '����',
					//tooltip : '����',
					iconCls: 'edit_add',
					handler : function() {
						srmyearnewAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					//tooltip : '�޸�',
					iconCls : 'pencil',
					handler : function() {
						srmyearnewEditFun();
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

var itemGrid = new Ext.grid.GridPanel({
			title: '�����Ϣά��',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.yearexe.csp',
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


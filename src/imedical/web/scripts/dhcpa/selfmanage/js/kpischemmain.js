///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/dhc.pa.kpiSchemexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'code',
			'name',
			'shortcut',
			'frequency',
			'desc'
		]),
	    remoteSort: true
});



var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid','code');

var tmpTitle='�Բ鶨������';	
	
//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        new Ext.grid.CheckboxSelectionModel({singelSelect:false}),
        {

            id:'rowid',
            header: '�Բ���ĿID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{

            id:'code',
            header: '���',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'code'
       }, {
            id:'name',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'name'
            						
       }, {
            id:'shortcut',
            header: '��д',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'shortcut'			
            
       }, {
            id:'frequency',
            header: '����Ƶ��',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'frequency'
           
       }, {
            id:'desc',
            header: '����',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'desc'
            
       }
			    
]);


var addButton = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���',
					iconCls : 'add',
					handler : function() {
						kpischemAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler : function() {
						kpischemEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : 'ɾ��',
			iconCls : 'remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				//var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : 'ע��',
								msg : '��ѡ����Ҫɾ��������!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
				return;
				} else {
					
					
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
						if (btn == 'yes') {
							for(var i = 0; i < len; i++){   
				        	 var tmpRowid=rowObj[i].get("rowid");
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
						}
					})
				}
			
		}
});

var itemGrid = new Ext.grid.GridPanel({
			
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.pa.kpiSchemexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.CheckboxSelectionModel(),
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
  

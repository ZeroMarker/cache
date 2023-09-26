var itemGridUrl = '../csp/dhc.qm.uCycleexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'Rowid',
			'Cyclecode',
			'Cyclename',
			'Cycleactive'
			
		]),
	    remoteSort: true
});

//��Ӹ�ѡ��
var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('Rowid', 'Cyclename');
//��ѯ�����ȼ�����

var uCodedField = new Ext.form.TextField({
	id: 'uCodedField',
	fieldLabel: '��ȴ���',
	width:100,
	listWidth : 245,
	
	triggerAction: 'all',
	emptyText:'',
	name: 'uCodedField',
	minChars: 1,
	pageSize: 10,
	editable:false
});
//��ѯ�����ȼ�����

var uNamedField = new Ext.form.TextField({
	id: 'uNamedField',
	fieldLabel: '�������',
	width:100,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'',
	name: 'uNamedField',
	minChars: 1,
	pageSize: 10,
	editable:true
});




var tmpTitle='���';

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
    sm,
        new Ext.grid.RowNumberer(), 
        {

            id:'Rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Rowid',
            hidden:'true'
           
       }, {
            id:'Cyclecode',
            header: '��ȴ���',
            
            allowBlank: false,
            width:100,
           editable:false,
           
            dataIndex: 'Cyclecode'
            
       }, {
            id:'Cyclename',
            header: '�������',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Cyclename'
            
       }, {
            id:'Cycleactive',
            header: '�Ƿ���Ч',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Cycleactive'
          
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '���',
					iconCls : 'add',
					handler : function() {
						sysorgaffiaddFun();
					}
				});
var editButton = new Ext.Toolbar.Button({
					text : '�޸�',
					tooltip : '�޸�',
					iconCls : 'option',
					handler : function() {
						SRMSystemModEditFun();
					}
				});

var delButton = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : 'ɾ��',
			iconCls : 'remove',
			handler : function() {
				var records = itemGrid.getSelectionModel().getSelections();
				var len = records.length;
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
					
					//tmpRowid = records[0].get("Rowid");
					Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
						if (btn == 'yes') {
							for(var i = 0; i < len; i++){
							Ext.Ajax.request({												      
								url : itemGridUrl + '?action=del&rowId=' + records[i].get("Rowid"),
					       
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
//��ѯ����
var SearchButton = new Ext.Toolbar.Button({
    text: '��ѯ', 
    tooltip:'��ѯ',        
    iconCls:'find',
	handler:function(){	

	    var Code= uCodedField.getValue();
                        var Name = uNamedField.getValue();
       
	itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,Cyclecode:Code,Cyclename:Name}}));
	
	}
});
var itemGrid = new Ext.grid.GridPanel({
			//title: 'ϵͳģ�鶨��',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'dhc.qm.uCycle.csp',
		    //atLoad : true, // �Ƿ��Զ�ˢ��
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			tbar:['���code','-',uCodedField,'-','�������','-',uNamedField,'-',SearchButton,'-',addButton,'-',delButton,'-',editButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});





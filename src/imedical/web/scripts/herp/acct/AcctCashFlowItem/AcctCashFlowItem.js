//var userdr = session['LOGON.USERID'];
var acctbookid=IsExistAcctBook();


var itemGridUrl = '../csp/herp.acct.acctcashflowitemmainexe.csp';
var projUrl='../csp/herp.acct.acctcashflowitemmainexe.csp';

//�����ģ����ѯ
var acctcashitemField = new Ext.form.TextField({
	id: 'acctcashitemField ',
	fieldLabel: '',
	width:200,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'����/ ����/ ƴ����ģ����ѯ...',
	name: 'acctcashitemField ',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'+'&acctbookid='+acctbookid});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'ItemCode',
		'ItemName',
		'supers',
                'Cilevel',
                'isLast',
                'isStop',
                'cfdirection',
                'spell',
                'acctbookid' 
	]),
    remoteSort: true
});
itemGridDs.on('beforeload',function(store,op){
	var acctcashitem=acctcashitemField.getValue();
	//alert(acctcashitem);
	 itemGridDs.baseParams = {
                                acctcashitem: acctcashitem, 
								acctbookid:acctbookid
                        }

});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	plugins : new dhc.herp.PageSizePlugin(),
	atLoad : false,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"
});

//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');


//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ', 
    tooltip:'��ѯ',        
    iconCls:'find',
	width:80,
	height:25,
	handler:function(){	
	var acctcashitem=acctcashitemField.getValue();
	 var limit=Ext.getCmp("PageSizePlugin").getValue();
	if(limit==""||limit==0){limit=25};
	//alert(Ext.getCmp("ext-comp-1001").getValue());
	itemGridDs.load(({params:{start:0,limit:limit,acctcashitem:acctcashitem,acctbookid:acctbookid}}));
	
	}
});

//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){        
            funadd();
	}	
});

//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
    text: '�޸�',
    tooltip:'�޸�',        
    iconCls:'edit',
	handler:function(){ 
		var rowObj=itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }else if (len==1){
			for(var i = 0; i < len; i++){
			  funedit(); 
			  }
			
			}else {Ext.Msg.show({title:'ע��',msg:'ѡ����Ҫ�޸ĵ����ݹ���! ',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;}   
	}	
});

//ɾ����ť
var delButton  = new Ext.Toolbar.Button({
    text: 'ɾ��',
    tooltip:'ɾ��',        
    iconCls:'remove',
	handler:function(){     
            fundel();
	}	
});

//���밴ť 
var uploadButton = new Ext.Toolbar.Button({
	text: '����', 
    tooltip:'����',        
    iconCls:'in',
	handler:function(){	
	doimport();
	
	}
});

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
		id: 'rowid',
		header: '<div style="text-align:center">rowid</div>',
    	dataIndex: 'rowid',
    	width: 150,		  
   		hidden: true,
    	sortable: true
	    
    },{ 
        id:'ItemCode',
    	header: '<div style="text-align:center">��Ŀ����</div>',
        dataIndex: 'ItemCode',
        width: 100,
        align:'left',	
        hidden: false,	  
        sortable: true
    },{
        id:'ItemName',
    	header: '<div style="text-align:center">��Ŀ����</div>',
    	allowBlank: true,
        dataIndex: 'ItemName',
        width: 350,
        align:'left',
        hidden: false,
        sortable: true
    },{           
         id:'supers',
         header: '<div style="text-align:center">�ϼ�����</div>',
         allowBlank: true,
         width:100,
         align:'left',
         hidden: false,
         dataIndex: 'supers'
    
    },{           
         id:'Cilevel',
         header: '<div style="text-align:center">��Ŀ����</div>',
         allowBlank: true,
         width:100,
         align:'center',
         hidden: false,
         dataIndex: 'Cilevel'
    
    },{           
         id:'isStop',
         header: '<div style="text-align:center">�Ƿ�ͣ��</div>',
         allowBlank: true,
         hidden: false,
         width:100,
         align:'center',
         dataIndex: 'isStop'
    },{           
         id:'isLast',
         header: '<div style="text-align:center">�Ƿ�ĩ��</div>',
         allowBlank: true,
         hidden: false,
         width:100,
         align:'center',
         dataIndex: 'isLast'
    
    },{           
         id:'cfdirection',
         header: '<div style="text-align:center">��������</div>',
         allowBlank: true,
         width:100,
         align:'center',
         hidden: false,
         dataIndex: 'cfdirection'
    
    },{           
         id:'spell',
         header: '<div style="text-align:center">ƴ����</div>',
         allowBlank: true,
         hidden: false,
         align:'center',
         width:150,
         dataIndex: 'spell'
    
    }
    
]);



//��ʼ��Ĭ��������
itemGridCm.defaultSortable = true;

var queryPanel = new Ext.form.FormPanel({
		title: '�ֽ�������Ŀά��',
		iconCls:'maintain',
		height: 70,
		width: 400,
		region: 'north',
		frame: true,
		labelWidth: 140,
		// labelAlign:'right',
		// autoHeight:true,
		defaults: {
			bodyStyle: 'padding:5px'
		},
		items: [{
            xtype : 'panel',
            layout : 'column',
            items : [
				acctcashitemField,{
           		xtype : 'displayfield',
           		value : '',
           		width : 50
           	},findButton]
        }]
});


//���
var itemGrid = new Ext.grid.GridPanel({
    //title: '�ֽ�������Ŀ��ά��',
	iconCls:'maintain',
    region: 'center',
    layout:'fit',
    width:800,
    readerModel:'local',
    url: 'herp.acct.acctcashflowitemmainexe.csp',
    atLoad : false, // �Ƿ��Զ�ˢ��
    store: itemGridDs,
    cm: itemGridCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    loadMask: true,
    tbar:[addButton,'-',editButton,'-',uploadButton],
    bbar:itemGridPagingToolbar
});

  itemGridDs.load({	
	params:{start:0, limit:itemGridPagingToolbar.pageSize,acctbookid:acctbookid},
    callback:function(record,options,success ){
	}
});
	


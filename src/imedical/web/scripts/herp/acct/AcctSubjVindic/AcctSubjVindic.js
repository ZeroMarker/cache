var itemGridUrl = '../csp/herp.acct.acctsubjvindicmainexe.csp';

//�������Դ

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'rowid',
		'SubjCode',
		'SubjName',
		'SubjNature',
                'SubjType',
                'SubjLevel',
                'BalanceDirc',
                'SubjNameAll',
                'SuperCode',
                'Spell',
                'SelfCode',
                'IsLast',
                'Iscrash',
                'Unit',
                'ischeck'
	]),
    remoteSort: true
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('rowid', 'name');

var sysStore = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','Ԥ�����'],['1','��Ŀ֧��']]
});
var syscomb = new Ext.form.ComboBox({
	id: 'sysno',
	fieldLabel: 'Ӧ��ϵͳ',
	width:180,
	listWidth : 180,
	selectOnFocus: true,
	allowBlank: false,
	store: sysStore,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	emptyText:'ѡ���ڼ�����...',
	mode: 'local', //����ģʽ
	editable:false,
	pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});



//�����
var acctsubjField = new Ext.form.TextField({
	id: 'acctsubjField ',
	fieldLabel: '',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	//store: yearDs,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'ģ����ѯ...',
	name: 'acctsubjField ',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ', 
        tooltip:'��ѯ',        
        iconCls:'find',
	handler:function(){	
	var acctsubj=acctsubjField.getValue();
	itemGridDs.load(({params:{start:0,limit:25,acctsubj:acctsubj}}));
	
	}
});



//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	id:'rowid',
    	header: 'id',
        dataIndex: 'rowid',
        width: 150,		  
        hidden: true,
        sortable: true
	    
    },{ 
        id:'SubjCode',
    	header: '��Ŀ����',
        dataIndex: 'SubjCode',
        width: 80,		  
        sortable: true
    },{
        id:'SubjName',
    	header: '��Ŀ����',
        dataIndex: 'SubjName',
        width: 150,
        sortable: true
    },{           
         id:'SubjNature',
         header: '��Ŀ����',
         width:100,
         hidden: true,
         dataIndex: 'SubjNature',
         type: syscomb
    
    },{           
         id:'SubjType',
         header: '��Ŀ���',
   ///   allowBlank: false,
         width:80,
         dataIndex: 'SubjType',
         type: syscomb
    
    },{           
         id:'SubjLevel',
         header: '��Ŀ����',
         width:60,
         align:'right',
         hidden: true,
         dataIndex: 'SubjLevel',
         type: syscomb
    
    },{           
         id:'BalanceDirc',
         header: '����',
         allowBlank: true,
         width:60,
         dataIndex: 'BalanceDirc',
         type: syscomb
    
    },{           
         id:'SubjNameAll',
         header: '��Ŀȫ��',
         allowBlank: true,
         width:170,
         dataIndex: 'SubjNameAll',
         type: syscomb
    
    },{           
         id:'SuperCode',
         header: '�ϼ�����',
         allowBlank: true,
         width:80,
         dataIndex: 'SuperCode',
         type: syscomb
    
    },{           
         id:'Spell',
         header: 'ƴ����',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'Spell',
         type: syscomb
    
    },{           
         id:'SelfCode',
         header: '�Զ������',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'SelfCode',
         type: syscomb
    
    },{           
         id:'IsLast',
         header: '�Ƿ�ĩ��',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'IsLast',
         type: syscomb
    
    },{           
         id:'Iscrash',
         header: '�ֽ��־',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'Iscrash',
         type: syscomb
    
    },{           
         id:'Unit',
         header: '������λ',
         allowBlank: true,
         hidden: true,
         width:80,
         dataIndex: 'Unit',
         type: syscomb
    
    },{           
         id:'ischeck',
         header: '',
         hidden: true,
         width:40,
         dataIndex: 'ischeck',
         type: syscomb
    
    }
    
]);



//��ʼ��Ĭ��������
itemGridCm.defaultSortable = true;


//��Ӱ�ť
var addButton = new Ext.Toolbar.Button({
    text: '���',
    tooltip:'���',        
    iconCls:'add',
	handler:function(){
         
            addFun();
      
	}	
});





//�޸İ�ť
var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
    tooltip:'�޸�',        
    iconCls: 'option',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid     = rowObj[0].get("rowid");
                        var SubjCode  = rowObj[0].get("SubjCode");
                        var SubjName  = rowObj[0].get("SubjName");
                        var SubjNature= rowObj[0].get("SubjNature");
                        var SubjType  = rowObj[0].get("SubjType");
                        var SubjNameAll= rowObj[0].get("SubjNameAll");
    
                        var SuperCode = rowObj[0].get("SuperCode");
                        var Spell     = rowObj[0].get("Spell");
                        var SelfCode  = rowObj[0].get("SelfCode");
                        var IsLast    = rowObj[0].get("IsLast");
                        var Iscrash   = rowObj[0].get("Iscrash");
                        var Unit      = rowObj[0].get("Unit");
    
                        var SubjLevel  = rowObj[0].get("SubjLevel");
                        var BalanceDirc= rowObj[0].get("BalanceDirc");
                        
                        var ischeck    = rowObj[0].get("ischeck");
                        
                        editFun(rowid,SubjCode,SubjName,SubjNature,SubjType,SubjLevel,BalanceDirc,SubjNameAll,SuperCode,Spell,SelfCode,IsLast,Iscrash,Unit,ischeck);
		}
	
	       	       
	}

});


///ɾ����ť
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
   // tooltip:'ɾ��',       
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
			//alert(rowid);
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(rowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  itemGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.acct.acctsubjvindicmainexe.csp?action=del&rowid='+rowid,
						waitMsg:'ɾ����...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								Ext.Msg.show({title:'����',msg:'ɾ��ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ��������¼��?',handler);
	}
});


//���
var itemGrid = new Ext.grid.GridPanel({
    title: '��ƿ�Ŀά��',
    region: 'center',
    layout:'fit',
    width:800,
    readerModel:'local',
    url: 'herp.acct.acctsubjvindicmainexe.csp',
    atLoad : true, // �Ƿ��Զ�ˢ��
    store: itemGridDs,
    cm: itemGridCm,
    trackMouseOver: true,
    stripeRows: true,
    sm: new Ext.grid.RowSelectionModel({singleSelect:false}),
    loadMask: true,
    tbar:[addButton,'-',editButton,'-',delButton,'-',acctsubjField,'-',findButton],
    bbar:itemGridPagingToolbar
});
//itemGridDs.load({params:{start:0, limit:25}});

  itemGridDs.load({	
	params:{start:0, limit:itemGridPagingToolbar.pageSize},
        callback:function(record,options,success ){
	///itemGrid.fireEvent('rowclick',this,0);
	}
});
	
itemGrid.on('rowclick',function(grid,rowIndex,e){
	
	//var object = itemGrid.getSelectionModel().getSelections();
	//var rowid = object[0].get("rowid");
	
	var selectedRow = itemGridDs.data.items[rowIndex];
	var rowids = selectedRow.data['rowid'];
        var ischeck = selectedRow.data['ischeck'];
        ///alert(rowids);
        if(ischeck==1)
        {
	detailGrid.load({params:{start:0,limit:12,AcctSubjID:rowids}});
        } 
	
});



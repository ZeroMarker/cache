
var BudgProInquiryNWUrl = '../csp/herp.budg.budgproinquirynwexe.csp';
var UserID = session['LOGON.USERID'];

//�������
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:BudgProInquiryNWUrl+'?action=yearlist',method:'POST'});
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '�������',
	width:100,
	listWidth : 100,
	//allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'��ѡ�����...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var searchButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
	
	var Year=yearField.getValue();

	itemNW.load(({params:{start:0, limit:25,Year:Year,UserID:UserID}}));
	
	}
});
var itemNW = new dhc.herp.Grid({
    title: '��ĿԤ���ѯ',
    //width: 400,
    region : 'north',
    atLoad : true, // �Ƿ��Զ�ˢ��
    url: 'herp.budg.budgproinquirynwexe.csp',
    minSize : 350,
	maxSize : 450,
	height:225,
	
	tbar:['�������:',yearField,'-',searchButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'projyear',
        header: '�������',
        dataIndex: 'projyear',
        width:75,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: true
    },{ 
        id:'projcode',
        header: '��Ŀ����',
        dataIndex: 'projcode',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'projname',
        header: '��Ŀ����',
        width:250,
		//tip:true,
		//allowBlank: false,
        editable:false,
        allowBlank: true,
        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
    	    cellmeta.css="cellColor3";
        	var rid = record.data['rowid'];  
                if ( rid!=="") {
                	cellmeta.css="cellColor2";// ���ÿɱ༭�ĵ�Ԫ�񱳾�ɫ
                    return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
              }else{
					return '<span style="color:black;cursor:hand">'+value+'</span>';
				}

        	},
        dataIndex: 'projname'
		
    }, {
        id:'projdutydr',
        header: '��Ŀ������(��)',
        width:150,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'projdutydr',	
        hidden: true
    }, {
        id:'projdeptdr',
        header: '��Ŀ���ο���(��)',
        width:100,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'projdeptdr',	
        hidden: true
    }, {
        id:'username',
        header: '������',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'username'
    }, {
        id:'deptname',
        header: '���ο���',
        width:200,
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'deptname'
    },  {
        id:'projfundtotal',
        header: 'Ԥ���ܽ��',
        width:120,
        align:'right',
		//tip:true,
		allowBlank: true,
		editable:false,
        dataIndex: 'projfundtotal'
		
    },{
    	id:'projfundown',
        header: '�Գ���',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'projfundown'
    },{
    	id:'projfundgov',
        header: '����֧��',
        width:120,
        align:'right',
	    //tip:true,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'projfundgov'
    }
	],
	
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	viewConfig : {
		forceFit : true
	},
	
	height:230,
	trackMouseOver: true,
	stripeRows: true

});
itemNW.load(({params:{start:0, limit:25, UserID:UserID}}));

itemNW.btnAddHide();  //�������Ӱ�ť
itemNW.btnSaveHide();  //���ر��水ť
itemNW.btnResetHide();  //�������ð�ť
itemNW.btnDeleteHide(); //����ɾ����ť
itemNW.btnPrintHide();  //���ش�ӡ��ť

itemNW.load({	
	params:{start:0, limit:12},

	callback:function(record,options,success ){
		//alert("a")
	itemNE.fireEvent('cellclick',this,0);
	itemSW.fireEvent('cellclick',this,0);
	}
});

itemNW.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var id='';
    //alert(rowIndex);
	var selectedRow = itemNW.getSelectionModel().getSelections();
	id=selectedRow[0].data['rowid'];
	//alert(id);
	itemNE.load({params:{start:0, limit:12,ID:id}});
	itemSW.load({params:{start:0, limit:12,ID:id}});
				
});

//����gird�ĵ�Ԫ���¼�
itemNW.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	if (columnIndex == 5) {
		//alert(columnIndex);
		var records = itemNW.getSelectionModel().getSelections();
		var childid = records[0].get("rowid");
		//alert(childid);

		// ά������ҳ��
		ChildFun(childid);
		//connectFun(offshootID);
		
	}
});




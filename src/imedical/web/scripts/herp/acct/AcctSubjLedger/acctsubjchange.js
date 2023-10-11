

//��ȡ��Ƹ����������//
var CheckTypeNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

CheckTypeNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.acct.acctsubjledgerfcexe.csp'+'?action=GetAcctCheckType',method:'POST'});
});

var CheckTypeName = new Ext.form.ComboBox({
	id: 'CheckTypeNameField',
	fieldLabel: '������������',
	width:180,
	listWidth : 180,
	store: CheckTypeNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���������...',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
		select:function(combo,record,index){
			CheckItemNameDs.removeAll();
			CheckItemName.setValue('');
			CheckItemNameDs.proxy=new Ext.data.HttpProxy({
			url:'herp.acct.acctsubjledgerfcexe.csp'+'?action=GetTypeItemName&str='+encodeURIComponent(Ext.getCmp('CheckItemName').getRawValue())+'&TypeID='+combo.value+'&bookID='+bookID,method:'POST'})
			CheckItemNameDs.load({params:{start:0,limit:10}});				
		}
	}	
});
	   
	   
//��ȡ��������

var CheckItemNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});
//��������
CheckItemNameDs.on('beforeload', function(ds, o){
	var CheckTypeID=CheckTypeName.getValue();
	if(!CheckTypeID){
		Ext.Msg.show({title:'ע��',msg:'����ѡ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}});

var CheckItemName = new Ext.form.ComboBox({
	id: 'CheckItemName',
	fieldLabel: '��������',
	width:180,
	listWidth : 220,
	store: CheckItemNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����������',
	name: 'CheckItemName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//��ȡ��������
var CurrNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});

CurrNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.acct.acctsubjledgerfcexe.csp'+'?action=GetCurrNameFc&str='+encodeURIComponent(Ext.getCmp('CurrName').getRawValue()),method:'POST'});
});

var CurrName = new Ext.form.ComboBox({
	id: 'CurrName',
	fieldLabel: '��������',
	width:150,
	listWidth : 220,
	allowBlank: true,
	store: CurrNameDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���������',
	name: 'CurrName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	

var cmItems = [     new Ext.grid.RowNumberer(),
			        //new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
				       id:'rowid',
           	           header: '<div style="text-align:center">ID</div>',
                       allowBlank: true,
                       width:60,
                       editable:false,
                       hidden:true,
                       dataIndex: 'rowid'
                    },{
				       id:'AcctSubjID',
           	           header: '<div style="text-align:center">AcctSubjID</div>',
                       allowBlank: true,
                       width:100,
                       editable:false,
                       hidden:true,
                       dataIndex: 'AcctSubjID'
                    },{
						id : 'AcctSubjCode',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 100,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjCode'
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 120,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjName'
					},{
						id : 'BeginSum',
						header: '<div style="text-align:center">������</div>',
						width : 100,
						//editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSum'

					},{
						id : 'DirectionList',
						header: '<div style="text-align:center">�������</div>',
						width : 80,
						editable:false,
						align: 'center',
						dataIndex : 'DirectionList'
					},{
						id : 'TotalDebitSum',
						header: '<div style="text-align:center">�ۼƽ跽���</div>',
						width : 100,
						//editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSum'
					},{
						id : 'TotalCreditSum',
						header: '<div style="text-align:center">�ۼƴ������</div>',
						width : 100,
						//editable:false,
						//align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSum'
					},{
						id : 'EndSum',
						header: '<div style="text-align:center">�ڳ����</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSum'

					},{
						id : 'IsLast',
						header: '<div style="text-align:center">�Ƿ�ĩ��</div>',
						width : 100,
						hidden:true,
						dataIndex : 'IsLast'
					},{
						id : 'IsCheck',
						header: '<div style="text-align:center">�Ƿ�������</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsCheck'
					}];
					
	//	������				
	var cmItems2 = [	new Ext.grid.RowNumberer(),
					//new Ext.grid.CheckboxSelectionModel({editable:false}),
					{
				        id:'rowid',
           	           header: '<div style="text-align:center">ID</div>',
                       allowBlank: true,
                       width:60,
                       editable:false,
                       hidden:true,
                       dataIndex: 'rowid'
                    },{
				       id:'AcctSubjID',
           	           header: '<div style="text-align:center">AcctSubjID</div>',
                       allowBlank: true,
                       width:100,
                       editable:false,
                       hidden:true,
                       dataIndex: 'AcctSubjID'
                    },{
						id : 'AcctSubjCode',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 100,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjCode'
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 140,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjName'
					},{
						id : 'BeginNum',
						header: '<div style="text-align:center">�������</div>',
						width : 140,
						align: 'right',
						dataIndex : 'BeginNum'
					},{
						id : 'BeginSum',
						header: '<div style="text-align:center">������</div>',
						width : 140,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSum'

					},{
						id : 'DirectionList',
						header: '<div style="text-align:center">�������</div>',
						width : 60,
						editable:false,
						align: 'center',
						dataIndex : 'DirectionList'
					},{
						id : 'TotalDebitSum',
						header: '<div style="text-align:center">�ۼƽ跽���</div>',
						width : 140,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSum'
					},{
						id : 'TotalCreditSum',
						header: '<div style="text-align:center">�ۼƴ������</div>',
						width : 140,
						//align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSum'
					},{
						id : 'TotalDebitNum',
						header: '<div style="text-align:center">�ۼƽ跽����</div>',
						width : 140,
						align: 'center',
						dataIndex : 'TotalDebitNum'
					},{
						id : 'TotalCreditNum',
						header: '<div style="text-align:center">�ۼƴ�������</div>',
						width : 140,
						align: 'center',
						dataIndex : 'TotalCreditNum'
					},{
						id : 'EndNum',
						header: '<div style="text-align:center">�ڳ�����</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndNum'

					},{
						id : 'EndSum',
						header: '<div style="text-align:center">�ڳ����</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSum'

					},{
						id : 'IsLast',
						header: '<div style="text-align:center">�Ƿ�ĩ��</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsLast'
					},{
						id : 'IsCheck',
						header: '<div style="text-align:center">�Ƿ�������</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsCheck'
					}]	;	
	
							
	//�����										
	var cmItems3 = [	new Ext.grid.RowNumberer(),
					//new Ext.grid.CheckboxSelectionModel({editable:false}),
					{
				       id:'rowid',
           	           header: '<div style="text-align:center">ID</div>',
                       allowBlank: true,
                       width:60,
                       editable:false,
                       hidden:true,
                       dataIndex: 'rowid'
                    },{
				       id:'AcctLedgerID',
           	           header: '<div style="text-align:center">AcctLedgerID</div>',
                       allowBlank: true,
                       width:60,
                       editable:false,
                       hidden:true,
                       dataIndex: 'AcctLedgerID'
                    },{
				       id:'AcctSubjID',
           	           header: '<div style="text-align:center">AcctSubjID</div>',
                       allowBlank: true,
                       width:140,
                       editable:false,
                       hidden:true,
                       dataIndex: 'AcctSubjID'
                    },{
						id : 'AcctSubjCode',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 200,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjCode'
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">��Ŀ����</div>',
						width : 200,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjName'
					},{
						id : 'CurrCode',
						header: '<div style="text-align:center">���ֱ���</div>',
						width : 60,
						hidden:true,
						editable:false,
						align: 'center',
						dataIndex : 'CurrCode'
					},{
						id : 'CurrName',
						header: '<div style="text-align:center">����</div>',
						width : 100,
						//editable:false,
						align: 'center',
						type:CurrName,
						dataIndex : 'CurrName'
					},{
						id : 'BeginSumF',
						header: '<div style="text-align:center">ԭ��������</div>',
						width : 200,
						editable:true,
						align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSumF'
					},{
						id : 'BeginSum',
						header: '<div style="text-align:center">����������</div>',
						width : 200,
						editable:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSum'
					},{
						id : 'DirectionList',
						header: '<div style="text-align:center">�������</div>',
						width : 100,
						editable:false,
						align: 'center',
						dataIndex : 'DirectionList'
					},{
						id : 'TotalDebitSumF',
						header: '<div style="text-align:center">ԭ���ۼƽ跽���</div>',
						width : 200,
						//editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
						return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSumF'
					},{		
						id : 'TotalCreditSumF',
						header: '<div style="text-align:center">ԭ���ۼƴ������</div>',
						width : 200,
						editable:true,
						align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
						return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSumF'
					},{
						id : 'TotalDebitSum',
						header: '<div style="text-align:center">�����ۼƽ跽���</div>',
						width : 200,
						editable:true,
						align: 'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
						return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSum'
					},{
						id : 'TotalCreditSum',
						header: '<div style="text-align:center">�����ۼƴ������</div>',
						width : 200,
						//editable:false,
						editable:true,
						align: 'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSum'
					},{
						id : 'EndSumF',
						header: '<div style="text-align:center">�ڳ�ԭ�����</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSumF'

					},{
						id : 'EndSum',
						header: '<div style="text-align:center">�ڳ��������</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSum'

					},
					{
						id : 'IsLast',
						header: '<div style="text-align:center">�Ƿ�ĩ��</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsLast'
					},{
						id : 'IsCheck',
						header: '<div style="text-align:center">�Ƿ�������</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsCheck'
					}]	
		
		

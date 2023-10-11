

//获取会计辅助核算类别//
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
	fieldLabel: '辅助核算类型',
	width:180,
	listWidth : 180,
	store: CheckTypeNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择核算类型...',
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
	   
	   
//获取科室名称

var CheckItemNameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name'])
});
//科室名称
CheckItemNameDs.on('beforeload', function(ds, o){
	var CheckTypeID=CheckTypeName.getValue();
	if(!CheckTypeID){
		Ext.Msg.show({title:'注意',msg:'请先选择核算类别',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}});

var CheckItemName = new Ext.form.ComboBox({
	id: 'CheckItemName',
	fieldLabel: '机构名称',
	width:180,
	listWidth : 220,
	store: CheckItemNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择所属名称',
	name: 'CheckItemName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});



//获取币种名称
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
	fieldLabel: '币种名称',
	width:150,
	listWidth : 220,
	allowBlank: true,
	store: CurrNameDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择币种类型',
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
						header: '<div style="text-align:center">科目编码</div>',
						width : 100,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjCode'
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">科目名称</div>',
						width : 120,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjName'
					},{
						id : 'BeginSum',
						header: '<div style="text-align:center">年初余额</div>',
						width : 100,
						//editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSum'

					},{
						id : 'DirectionList',
						header: '<div style="text-align:center">借贷方向</div>',
						width : 80,
						editable:false,
						align: 'center',
						dataIndex : 'DirectionList'
					},{
						id : 'TotalDebitSum',
						header: '<div style="text-align:center">累计借方金额</div>',
						width : 100,
						//editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSum'
					},{
						id : 'TotalCreditSum',
						header: '<div style="text-align:center">累计贷方金额</div>',
						width : 100,
						//editable:false,
						//align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSum'
					},{
						id : 'EndSum',
						header: '<div style="text-align:center">期初余额</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSum'

					},{
						id : 'IsLast',
						header: '<div style="text-align:center">是否末级</div>',
						width : 100,
						hidden:true,
						dataIndex : 'IsLast'
					},{
						id : 'IsCheck',
						header: '<div style="text-align:center">是否辅助核算</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsCheck'
					}];
					
	//	数量账				
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
						header: '<div style="text-align:center">科目编码</div>',
						width : 100,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjCode'
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">科目名称</div>',
						width : 140,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjName'
					},{
						id : 'BeginNum',
						header: '<div style="text-align:center">年初数量</div>',
						width : 140,
						align: 'right',
						dataIndex : 'BeginNum'
					},{
						id : 'BeginSum',
						header: '<div style="text-align:center">年初余额</div>',
						width : 140,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSum'

					},{
						id : 'DirectionList',
						header: '<div style="text-align:center">借贷方向</div>',
						width : 60,
						editable:false,
						align: 'center',
						dataIndex : 'DirectionList'
					},{
						id : 'TotalDebitSum',
						header: '<div style="text-align:center">累计借方金额</div>',
						width : 140,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSum'
					},{
						id : 'TotalCreditSum',
						header: '<div style="text-align:center">累计贷方金额</div>',
						width : 140,
						//align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSum'
					},{
						id : 'TotalDebitNum',
						header: '<div style="text-align:center">累计借方数量</div>',
						width : 140,
						align: 'center',
						dataIndex : 'TotalDebitNum'
					},{
						id : 'TotalCreditNum',
						header: '<div style="text-align:center">累计贷方数量</div>',
						width : 140,
						align: 'center',
						dataIndex : 'TotalCreditNum'
					},{
						id : 'EndNum',
						header: '<div style="text-align:center">期初数量</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndNum'

					},{
						id : 'EndSum',
						header: '<div style="text-align:center">期初余额</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSum'

					},{
						id : 'IsLast',
						header: '<div style="text-align:center">是否末级</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsLast'
					},{
						id : 'IsCheck',
						header: '<div style="text-align:center">是否辅助核算</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsCheck'
					}]	;	
	
							
	//外币账										
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
						header: '<div style="text-align:center">科目编码</div>',
						width : 200,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjCode'
					},{
						id : 'AcctSubjName',
						header: '<div style="text-align:center">科目名称</div>',
						width : 200,
						editable:false,
						align: 'left',
						dataIndex : 'AcctSubjName'
					},{
						id : 'CurrCode',
						header: '<div style="text-align:center">币种编码</div>',
						width : 60,
						hidden:true,
						editable:false,
						align: 'center',
						dataIndex : 'CurrCode'
					},{
						id : 'CurrName',
						header: '<div style="text-align:center">币种</div>',
						width : 100,
						//editable:false,
						align: 'center',
						type:CurrName,
						dataIndex : 'CurrName'
					},{
						id : 'BeginSumF',
						header: '<div style="text-align:center">原币年初余额</div>',
						width : 200,
						editable:true,
						align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSumF'
					},{
						id : 'BeginSum',
						header: '<div style="text-align:center">本币年初余额</div>',
						width : 200,
						editable:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'BeginSum'
					},{
						id : 'DirectionList',
						header: '<div style="text-align:center">借贷方向</div>',
						width : 100,
						editable:false,
						align: 'center',
						dataIndex : 'DirectionList'
					},{
						id : 'TotalDebitSumF',
						header: '<div style="text-align:center">原币累计借方金额</div>',
						width : 200,
						//editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
						return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSumF'
					},{		
						id : 'TotalCreditSumF',
						header: '<div style="text-align:center">原币累计贷方金额</div>',
						width : 200,
						editable:true,
						align: 'right',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
						return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalCreditSumF'
					},{
						id : 'TotalDebitSum',
						header: '<div style="text-align:center">本币累计借方金额</div>',
						width : 200,
						editable:true,
						align: 'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						
						return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'TotalDebitSum'
					},{
						id : 'TotalCreditSum',
						header: '<div style="text-align:center">本币累计贷方金额</div>',
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
						header: '<div style="text-align:center">期初原币余额</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSumF'

					},{
						id : 'EndSum',
						header: '<div style="text-align:center">期初本币余额</div>',
						width : 180,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
					     return '<span style="float:right;">'+Ext.util.Format.number(value,'0,000.00')+'</span>';
						},
						dataIndex : 'EndSum'

					},
					{
						id : 'IsLast',
						header: '<div style="text-align:center">是否末级</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsLast'
					},{
						id : 'IsCheck',
						header: '<div style="text-align:center">是否辅助核算</div>',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'IsCheck'
					}]	
		
		

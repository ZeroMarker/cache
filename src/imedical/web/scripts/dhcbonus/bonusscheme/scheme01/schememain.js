//rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'��������',dataIndex:'code'}, 					//1
	{header:'��������',dataIndex:'name'},               //2
	{header:'��������',dataIndex:'desc'},               //3
	{header:'�������',dataIndex:'SchemeTypeName'},               //4
	{header:'������Ա',dataIndex:'createPerson'},       //5
	{header:'������Ա',dataIndex:'adjustPerson'},       //6
	{header:'����״̬',dataIndex:'schemeState'},        //7
	{header:'����ʱ��',dataIndex:'adjustDate'},         //8
	{header:'�����Ա',dataIndex:'auditingPerson'},     //9
	{header:'���ʱ��',dataIndex:'auditingDate'},       //10
	{header:'�Ƿ���Ч',dataIndex:'isValid'},	        //11
	{header:'�������ID',dataIndex:'SchemeTypeID'},			//12
	{header:'���ȼ�',dataIndex:'Priority'},			//13 
	{header:'�����ʾID',dataIndex:'calFlagId'},  //14
	//{header:'�����ʾ',dataIndex:'calFlagName'}  //15
	{header:'�����ʾ',dataIndex:'CalculateFlag'}  //15
);



var schemeUrl = 'dhc.bonus.scheme01exe.csp';
var schemeProxy = new Ext.data.HttpProxy({url: schemeUrl + '?action=schemelist&start=0&limit=25'});

var schemeDs = new Ext.data.Store({
	proxy: schemeProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		schemeValue[0].dataIndex,
		schemeValue[1].dataIndex,
		schemeValue[2].dataIndex,
		schemeValue[3].dataIndex,
		schemeValue[4].dataIndex,
		schemeValue[5].dataIndex,
		schemeValue[6].dataIndex,
	    schemeValue[7].dataIndex,
		schemeValue[8].dataIndex,
		schemeValue[9].dataIndex,
		schemeValue[10].dataIndex,
		schemeValue[11].dataIndex,
		schemeValue[12].dataIndex,
		schemeValue[13].dataIndex,
		schemeValue[14].dataIndex,
		schemeValue[15].dataIndex
	]),
	remoteSort: true
});

//schemeDs.setDefaultSort('Priority', 'ASE');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '���ȼ�',
		dataIndex: 'Priority',
		width: 30,
		sortable: true
	},
	{
		header: '��������',
		dataIndex: 'code',
		width: 60,
		sortable: true
	},{
		header: '��������',
		dataIndex:'name',
		width: 120,
		align: 'left',
		sortable: true
	},
	{
		header: '�������',
		dataIndex: 'SchemeTypeName',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[7].header,
		dataIndex:schemeValue[7].dataIndex,
		width: 80,
		align: 'left',
		renderer:function(value,metadata,record,rowIndex,colIndex,store){
			return schemeStateValue[value];
		},
		sortable: true
	},
	{
		header: '��������',
		dataIndex: 'desc',
		width: 120,
		align: 'left',
		sortable: true
	}
]);


var schemePagingToolbar = new Ext.PagingToolbar({
	pageSize: 10,
	store: schemeDs,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,

});
var schemeTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '�������',
			name : 'schemeTypeCombo',
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			//mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��ѡ��',
			selectOnFocus : true,
			anchor : '100%'
		});
schemeTypeCombo.on('select', function() {
			schemeDs.proxy = new Ext.data.HttpProxy({
						url : schemeUrl + '?action=schemelist&start=0&limit=25&searchField=SchemeType&searchValue='
								+ schemeTypeCombo.getValue(),
						method : 'GET'
					});
			itemDs.removeAll();
			// -------------------
			schemeDs.load({
						params : {
							start : 0,
							limit : 25
						},
						callback : function(record, options, success) {
							// schemeMain.fireEvent('rowclick',this,0);
							// schemeMain.getSelectionModel().selectAll();
							inDeptsCm.fireEvent('rowselect', this, 0);
						}
					});

});
var addButton = new Ext.Toolbar.Button({
	text: '����',
	tooltip: '����',
	iconCls: 'add',
	handler: function(){
		schemeAddFun();
		
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
	tooltip: '�����ɺ󲻿��޸�',
	iconCls: 'option',
	handler: function(){
		var rowObj = schemeMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(rowObj[0].get("schemeState")==1)
		{
			Ext.Msg.show({title:'ע��',msg:'�����,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		schemeEditFun();
	}
});

var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = schemeMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(rowObj[0].get("schemeState")==1)
		{
			Ext.Msg.show({title:'ע��',msg:'�����,����ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			
			Ext.MessageBox.confirm(
				'��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemeUrl + '?action=schemedel&rowid='+tmpRowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeDs.load({params:{start:0, limit:schemePagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'����',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	}
});

schemeSM=new Ext.grid.RowSelectionModel({singleSelect:true});

var schemeMain = new Ext.grid.GridPanel({
	title:'������㷽��',
	region:'north',
	height:250,
	store: schemeDs,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: schemeSM,
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:['�������:',schemeTypeCombo,'-',addButton,'-',editButton,'-',delButton],
	bbar: schemePagingToolbar
	

});

schemeDs.load({
	params:{start:0, limit:schemePagingToolbar.pageSize},
	callback:function(record,options,success ){
		schemeMain.fireEvent('rowclick',this,0);
		//schemeSM.selectFirstRow();
		//schemeMain.getSelectionModel().selectFirstRow();
		
	}
});


var tmpSelectedScheme='';


schemeMain.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = schemeDs.data.items[rowIndex];

	//�����ӿں��㲿�ź�ˢ�½ӿں��㲿�ŵ�Ԫ
	tmpSelectedScheme=selectedRow.data['rowid'];
	itemDs.proxy = new Ext.data.HttpProxy({url: itemUrl + '?action=itemlist&type='+tmpSelectedScheme});
	itemDs.load({params:{start:0, limit:itemPagingToolbar.pageSize}});
	
});
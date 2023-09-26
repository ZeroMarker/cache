//rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusUnitID^BonusUnitCode^BonusUnitName^BonusUnitTypeID^BonusUnitTypeName
var scheme02Value = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'',dataIndex:'BonusSchemeID'}, 				//1
	{header:'',dataIndex:'BonusSchemeCode'},    		//2
	{header:'',dataIndex:'BonusSchemeName'},    		//3
	{header:'',dataIndex:'BonusUnitID'},        		//4
	{header:'��Ԫ����',dataIndex:'BonusUnitCode'},      //5
	{header:'��Ԫ����',dataIndex:'BonusUnitName'},    	//6
	{header:'',dataIndex:'BonusUnitTypeID'},        	//7
	{header:'��Ԫ���',dataIndex:'BonusUnitTypeName'} ,  //8
	{header:'�ϼ���Ԫ',dataIndex:'SuperUnitName'},//9
	{header:'�ϼ���ԪID',dataIndex:'SuperiorUnitID'}
);

var scheme02Url = 'dhc.bonus.scheme02exe.csp';
//var scheme02Proxy = new Ext.data.HttpProxy({url: scheme02Url + '?action=scheme02list'});

var scheme02Ds = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		scheme02Value[0].dataIndex,
		scheme02Value[1].dataIndex,
		scheme02Value[2].dataIndex,
		scheme02Value[3].dataIndex,
		scheme02Value[4].dataIndex,
		scheme02Value[5].dataIndex,
		scheme02Value[6].dataIndex,
	    scheme02Value[7].dataIndex,
		scheme02Value[8].dataIndex,
		scheme02Value[9].dataIndex,
		scheme02Value[10].dataIndex
	]),
	remoteSort: true
});

scheme02Ds.setDefaultSort('BonusUnitCode', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: scheme02Value[5].header,
		dataIndex: scheme02Value[5].dataIndex,
		width: 100,
		sortable: true
	},
	{
		header: scheme02Value[6].header,
		dataIndex:scheme02Value[6].dataIndex,
		width: 110,
		align: 'left',
		sortable: true
	},
	{
		header: scheme02Value[8].header,
		dataIndex: scheme02Value[8].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: scheme02Value[9].header,
		dataIndex: scheme02Value[9].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	}
]);


var scheme02PagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: scheme02Ds,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,
});

var codeField = new Ext.form.TextField({
	id: 'codeField',
	name:'code',
	fieldLabel: '��������',
	allowBlank: false,
	emptyText: '����',
	anchor: '100%'
});

var nameField = new Ext.form.TextField({
	id: 'nameField',
	name:'name',
	fieldLabel: '��������',
	allowBlank: false,
	emptyText: '����',
	anchor: '100%'
});

var descField = new Ext.form.TextField({
	id: 'descField',
	name:'desc',
	fieldLabel: '��������',
	emptyText: '',
	anchor: '100%'
});

var addButton = new Ext.Toolbar.Button({
	text: '���',
	tooltip: '���',
	iconCls: 'add',
	handler: function(){
	var rowObj = scheme1Main.getSelectionModel().getSelections();
	if(rowObj.length==0){
			schemeSM.selectFirstRow();
			rowObj = scheme1Main.getSelectionModel().getSelections();
		}
			if(rowObj[0].get("schemeState")==1)
			{
				Ext.Msg.show({title:'ע��',msg:'�����,�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
		
	scheme02AddFun();}
});

var editButton = new Ext.Toolbar.Button({
	text: '�޸�',
	tooltip: '�޸�',
	iconCls: 'option',
	handler: function(){
	var rowObj = scheme1Main.getSelectionModel().getSelections();
	if(rowObj.length==0){
			schemeSM.selectFirstRow();
			rowObj = scheme1Main.getSelectionModel().getSelections();
		}
			if(rowObj[0].get("schemeState")==1)
			{
				Ext.Msg.show({title:'ע��',msg:'�����,�����޸�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
		
		scheme02EditFun();}
});

var delButton = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'remove',
	handler: function(){
	var rowObj = scheme1Main.getSelectionModel().getSelections();
	if(rowObj.length==0){
			schemeSM.selectFirstRow();
			rowObj = scheme1Main.getSelectionModel().getSelections();
		}
			if(rowObj[0].get("schemeState")==1)
			{
				Ext.Msg.show({title:'ע��',msg:'�����,����ɾ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
		
		var rowObj = scheme02Main.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
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
							url: scheme02Url + '?action=scheme02del&rowid='+tmpRowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									scheme02Ds.load({params:{start:scheme02PagingToolbar.cursor, limit:scheme02PagingToolbar.pageSize}});
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

var scheme02Main = new Ext.grid.GridPanel({
	//title:'�������㵥Ԫ',
	region:'center',
	//width:450,
	store: scheme02Ds,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	//viewConfig: {forceFit:true},
	tbar:[/*'���𷽰����:',schemeTypeCombo,'-','���𷽰�:',schemeCombo,'-',*/addButton,'-',editButton,'-',delButton],
	bbar: scheme02PagingToolbar
});

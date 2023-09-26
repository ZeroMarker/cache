var StratagemTabUrl = 'dhc.bonus.deptbonuscalcexe.csp';

periodStore = new Ext.data.SimpleStore({
	data:[
			['M01','01��'],
			['M02','02��'],
			['M03','03��'],
			['M04','04��'],
			['M05','05��'],
			['M06','06��'],
			['M07','07��'],
			['M08','08��'],
			['M09','09��'],
			['M10','10��'],
			['M11','11��'],
			['M12','12��'],
			['Q01','01����'],
			['Q02','02����'],
			['Q03','03����'],
			['Q04','04����'],
			['H01','�ϰ���'],
			['H02','�°���'],
			['0','00']
		],
	fields:['key','keyValue']
});


var searchPeriodValue=function(key){
	var arr=periodStore.data;
	for(i=0;i<arr.length;i++){
		if(arr.items[i].data.key==key){
			return arr.items[i].data.keyValue
		}
	}
	return null
}

//rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusPeriod^BonusYear^AdjustDesc^AdjustDate^BonusTargetID^BonusTargetCode^BonusTargetName^rowid2
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'',dataIndex:'BonusSchemeID'}, 				//1
	{header:'',dataIndex:'BonusSchemeCode'}, 			//2
	{header:'��������',dataIndex:'BonusSchemeName'}, 	//3
	{header:'�����ڼ�',dataIndex:'BonusPeriod'},    		//4
	{header:'���',dataIndex:'BonusYear'},    			//5
	{header:'����˵��',dataIndex:'AdjustDesc'},        	//6
	{header:'����ʱ��',dataIndex:'AdjustDate'},      	//7
	{header:'',dataIndex:'BonusTargetID'},    			//8
	{header:'',dataIndex:'BonusTargetCode'},    		//9
	{header:'�漰Ŀ��',dataIndex:'BonusTargetName'},    //10
	{header:'',dataIndex:'rowid2'}        				//11
);

var schemeStateValue = new Array(
	'����',							//0
	'������',						//1
	'��������'						//2
);

var schemeUrl = 'dhc.bonus.scheme04exe.csp';
var schemeProxy = new Ext.data.HttpProxy({url: schemeUrl + '?action=schemelist'});

var scheme04Ds = new Ext.data.Store({
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
		schemeValue[11].dataIndex
	]),
	remoteSort: true
});

scheme04Ds.setDefaultSort('rowid', 'Desc');

var inDeptsCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: schemeValue[3].header,
		dataIndex: schemeValue[3].dataIndex,
		width: 200,
		sortable: true
	},
	{
		header: schemeValue[4].header,
		dataIndex:schemeValue[4].dataIndex,
		renderer:function(value,metadata,record,rowIndex,colIndex,store){
			return searchPeriodValue(value);
		},
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[5].header,
		dataIndex: schemeValue[5].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[6].header,
		dataIndex: schemeValue[6].dataIndex,
		width: 300,
		sortable: true
	},
	{
		header: schemeValue[7].header,
		dataIndex:schemeValue[7].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: schemeValue[10].header,
		dataIndex: schemeValue[10].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	}
]);


var schemePagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: scheme04Ds,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,
});


var addButton = new Ext.Toolbar.Button({
	text: '��������',
	tooltip: '��������',
	iconCls: 'add',
	handler: function(){scheme04AddFun();}
});

var editButton = new Ext.Toolbar.Button({
	text: '�����޸�',
	tooltip: '�����޸�',
	iconCls: 'option',
	handler: function(){schemeEditFun();}
});

var delButton = new Ext.Toolbar.Button({
	text:'����ɾ��',
	tooltip:'����ɾ��',
	iconCls:'remove',
	handler: function(){
		var rowObj = scheme04Main.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			tmpRowid2 = rowObj[0].get("rowid2");
			Ext.MessageBox.confirm(
				'��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemeUrl + '?action=schemedel&rowid='+tmpRowid+'&rowid2='+tmpRowid2,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�����ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									scheme04Ds.load({params:{start:0, limit:schemePagingToolbar.pageSize}});
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

var scheme04Main = new Ext.grid.GridPanel({
	region:'center',
	store: scheme04Ds,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:[addButton,'-',editButton,'-',delButton],
	bbar: schemePagingToolbar
});

scheme04Ds.load({params:{start:0, limit:schemePagingToolbar.pageSize}});

scheme04Main.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = scheme04Ds.data.items[rowIndex];
	//�޸��Ƿ���Ч
	if(selectedRow.data["schemeState"]==1){
		editButton.setDisabled(true);
	}else{
		editButton.setDisabled(false);
	}
	//�����ӿں��㲿�ź�ˢ�½ӿں��㲿�ŵ�Ԫ

});
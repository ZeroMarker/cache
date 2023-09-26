var StratagemTabUrl = 'dhc.bonus.deptbonuscalcexe.csp';

periodStore = new Ext.data.SimpleStore({
	data:[
			['M01','01月'],
			['M02','02月'],
			['M03','03月'],
			['M04','04月'],
			['M05','05月'],
			['M06','06月'],
			['M07','07月'],
			['M08','08月'],
			['M09','09月'],
			['M10','10月'],
			['M11','11月'],
			['M12','12月'],
			['Q01','01季度'],
			['Q02','02季度'],
			['Q03','03季度'],
			['Q04','04季度'],
			['H01','上半年'],
			['H02','下半年'],
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
	{header:'方案名称',dataIndex:'BonusSchemeName'}, 	//3
	{header:'核算期间',dataIndex:'BonusPeriod'},    		//4
	{header:'年度',dataIndex:'BonusYear'},    			//5
	{header:'调整说明',dataIndex:'AdjustDesc'},        	//6
	{header:'调整时间',dataIndex:'AdjustDate'},      	//7
	{header:'',dataIndex:'BonusTargetID'},    			//8
	{header:'',dataIndex:'BonusTargetCode'},    		//9
	{header:'涉及目标',dataIndex:'BonusTargetName'},    //10
	{header:'',dataIndex:'rowid2'}        				//11
);

var schemeStateValue = new Array(
	'新增',							//0
	'审核完成',						//1
	'方案调整'						//2
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
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});


var addButton = new Ext.Toolbar.Button({
	text: '方案调整',
	tooltip: '方案调整',
	iconCls: 'add',
	handler: function(){scheme04AddFun();}
});

var editButton = new Ext.Toolbar.Button({
	text: '调整修改',
	tooltip: '调整修改',
	iconCls: 'option',
	handler: function(){schemeEditFun();}
});

var delButton = new Ext.Toolbar.Button({
	text:'调整删除',
	tooltip:'调整删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = scheme04Main.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			tmpRowid2 = rowObj[0].get("rowid2");
			Ext.MessageBox.confirm(
				'提示', 
				'确定要删除选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemeUrl + '?action=schemedel&rowid='+tmpRowid+'&rowid2='+tmpRowid2,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									scheme04Ds.load({params:{start:0, limit:schemePagingToolbar.pageSize}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
	//修改是否有效
	if(selectedRow.data["schemeState"]==1){
		editButton.setDisabled(true);
	}else{
		editButton.setDisabled(false);
	}
	//单击接口核算部门后刷新接口核算部门单元

});
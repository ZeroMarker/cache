//rowid^BonusDeptGroupID^BonusUnit^BonusUnitCode^BonusUnitName
var cValue = new Array(
	{header:'',dataIndex:'BonusSubDeptGroupMapID'},										//0
	{header:'',dataIndex:'BonusDeptGroupID'}, 		//1
	{header:'',dataIndex:'BonusUnit'},         		//2
	{header:'科室编码',dataIndex:'BonusUnitCode'},			//3
	{header:'科室名称',dataIndex:'BonusUnitName'},        	//4
	{header:'',dataIndex:'BonusUnitTypeID'},			//5
	{header:'',dataIndex:'UnitTypeName'}        	//6
);

var cUrl = 'dhc.bonus.bonussubdeptgroupexe.csp';
var cProxy = new Ext.data.HttpProxy({url: cUrl + '?action=clist&parRef=1'});

var cDs = new Ext.data.Store({
	proxy: cProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		cValue[0].dataIndex,
		cValue[1].dataIndex,
		cValue[2].dataIndex,
		cValue[3].dataIndex,
		cValue[4].dataIndex,
		cValue[5].dataIndex,
		cValue[6].dataIndex
	]),
	remoteSort: true
});

cDs.setDefaultSort('BonusSubDeptGroupMapID', 'Desc');

var cCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: cValue[3].header,
		dataIndex: cValue[3].dataIndex,
		width: 150,
		align: 'left',
		sortable: true
	},
	{
		header: cValue[4].header,
		dataIndex:cValue[4].dataIndex,
		width: 250,
		align: 'left',
		sortable: true
	}
]);


var cAddButton = new Ext.Toolbar.Button({
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
		cAddFun();
	}
});

var cEditButton  = new Ext.Toolbar.Button({
	text: '修改',
	tooltip: '修改',
	iconCls: 'option',
	handler: function(){
		cEditFun();
	}
});

var cDelButton  = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = cMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var myId = "";
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			Ext.MessageBox.confirm(
				'提示', 
				'确定要删除选定的行?', 
				function(btn){
					if(btn == 'yes'){
						myId = rowObj[0].get("BonusSubDeptGroupMapID");
						Ext.Ajax.request({
							url: cUrl + '?action=cdel&rowid='+myId,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if(jsonData.success=='true'){
									Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									cDs.load({params:{start:0, limit:cPagingToolbar.pageSize}});
								}else{
									var message="";
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
					}
				}
			); 
		}
	}
});

var cPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: cDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"
});

cSM=new Ext.grid.RowSelectionModel({singleSelect:true});

var cMain = new Ext.grid.GridPanel({
	title:'科室单元',
	region:'center',
	store: cDs,
	cm: cCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:cSM ,
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: [cAddButton,'-',cEditButton,'-',cDelButton],
	bbar: cPagingToolbar
});

//cDs.load({params:{start:0, limit:cPagingToolbar.pageSize}});
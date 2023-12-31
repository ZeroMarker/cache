//rowid^code^name^desc^type^createPerson^adjustPerson^schemeState^adjustDate^auditingPerson^auditingDate^isValid
var schemeValue = new Array(
	{header:'',dataIndex:'rowid'},						//0
	{header:'方案代码',dataIndex:'code'}, 					//1
	{header:'方案名称',dataIndex:'name'},               //2
	{header:'方案描述',dataIndex:'desc'},               //3
	{header:'方案类别',dataIndex:'SchemeTypeName'},               //4
	{header:'创建人员',dataIndex:'createPerson'},       //5
	{header:'调整人员',dataIndex:'adjustPerson'},       //6
	{header:'方案状态',dataIndex:'schemeState'},        //7
	{header:'调整时间',dataIndex:'adjustDate'},         //8
	{header:'审核人员',dataIndex:'auditingPerson'},     //9
	{header:'审核时间',dataIndex:'auditingDate'},       //10
	{header:'是否有效',dataIndex:'isValid'},	        //11
	{header:'方案类别ID',dataIndex:'SchemeTypeID'},			//12
	{header:'优先级',dataIndex:'Priority'},			//13 
	{header:'核算标示ID',dataIndex:'calFlagId'},  //14
	//{header:'核算标示',dataIndex:'calFlagName'}  //15
	{header:'核算标示',dataIndex:'CalculateFlag'}  //15
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
		header: '优先级',
		dataIndex: 'Priority',
		width: 30,
		sortable: true
	},
	{
		header: '方案代码',
		dataIndex: 'code',
		width: 60,
		sortable: true
	},{
		header: '方案名称',
		dataIndex:'name',
		width: 120,
		align: 'left',
		sortable: true
	},
	{
		header: '方案类别',
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
		header: '方案描述',
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
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,

});
var schemeTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '方案类别',
			name : 'schemeTypeCombo',
			store : schemeTypeSt,
			displayField : 'name',
			allowBlank : false,
			valueField : 'rowid',
			typeAhead : true,
			//mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择',
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
	text: '添加',
	tooltip: '添加',
	iconCls: 'add',
	handler: function(){
		schemeAddFun();
		
	}
});

var editButton = new Ext.Toolbar.Button({
	text: '修改',
	tooltip: '审核完成后不可修改',
	iconCls: 'option',
	handler: function(){
		var rowObj = schemeMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(rowObj[0].get("schemeState")==1)
		{
			Ext.Msg.show({title:'注意',msg:'已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		schemeEditFun();
	}
});

var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = schemeMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(rowObj[0].get("schemeState")==1)
		{
			Ext.Msg.show({title:'注意',msg:'已审核,不能删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			tmpRowid = rowObj[0].get("rowid");
			
			Ext.MessageBox.confirm(
				'提示', 
				'确定要删除选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemeUrl + '?action=schemedel&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeDs.load({params:{start:0, limit:schemePagingToolbar.pageSize}});
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

schemeSM=new Ext.grid.RowSelectionModel({singleSelect:true});

var schemeMain = new Ext.grid.GridPanel({
	title:'奖金核算方案',
	region:'north',
	height:250,
	store: schemeDs,
	cm: inDeptsCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: schemeSM,
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar:['方案类别:',schemeTypeCombo,'-',addButton,'-',editButton,'-',delButton],
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

	//单击接口核算部门后刷新接口核算部门单元
	tmpSelectedScheme=selectedRow.data['rowid'];
	itemDs.proxy = new Ext.data.HttpProxy({url: itemUrl + '?action=itemlist&type='+tmpSelectedScheme});
	itemDs.load({params:{start:0, limit:itemPagingToolbar.pageSize}});
	
});

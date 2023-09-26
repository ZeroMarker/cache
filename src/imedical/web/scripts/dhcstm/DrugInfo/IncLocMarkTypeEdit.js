
function IncLocMarkTypeEdit(InciRowid){
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gHospId=session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var MTCommStore = new Ext.data.JsonStore({
	url : 'dhcstm.drugutil.csp?actiontype=MarkType',
	totalProperty : "results",
	root : 'rows',
	fields : ['Description', 'RowId']
	});
	var MTComm = new Ext.form.ComboBox({
	fieldLabel : '定价类型',
	id : 'MTComm',
	name : 'MTComm',
	anchor : '90%',
	width : 120,
	store : MTCommStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '定价类型...',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : ''
	
	});
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'Loc',
		name : 'Loc',
		anchor:'90%',
		groupId:gGroupId
	});
	
var saveMarkType = new Ext.ux.Button({
	text:'保存',
	iconCls:'page_save',
	handler:function(){
		var ListData = MasterInfoGrid.getModifiedInfo();
		if(ListData===false){
			return;
		}
		Ext.Ajax.request({
				url:'dhcstm.druginfomaintainaction.csp?actiontype=SaveMarkType',
				params:{InciRowid:InciRowid,ListData:ListData},
				failure: function(result, request) {
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
							MasterInfoGrid.reload();
					}
				},
				scope: this
			});
	}
});

	var MasterInfoCm =[{
				header : "Rowid",
				dataIndex : 'Rowid',
				saveColIndex : 0,
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header:"科室",
				dataIndex:'Loc',
				saveColIndex :1,
				xtype:'combocolumn',
				width:120,
				align:'left',
				sortable:true,
				valueField: "Loc",
				displayField: "LocDesc",
				editor:Loc
			}, {
				header:"定价类型",
				dataIndex:'MtDr',
				saveColIndex : 2,
				xtype:'combocolumn',
				width:120,
				align:'left',
				sortable:true,
				valueField: "MtDr",
				displayField: "MtDesc",
				editor:MTComm
		}];
	MasterInfoCm.defaultSortable = true;
	
	var MasterInfoGrid = new Ext.dhcstm.EditorGridPanel({
				id : 'MasterInfoGrid',
				title : '',
				tbar:[saveMarkType],
				autoLoadStore:true,
				valueParams:{InciRowid:InciRowid},
				contentColumns : MasterInfoCm,
				smType : "cell",
				actionUrl : "dhcstm.druginfomaintainaction.csp",
				queryAction : "QueryMarkType",
				selectFirst : false,
				delRowAction : "DeleteMarkType",
				delRowParam : "Rowid",
				idProperty : 'Rowid',
				checkProperty : 'Loc',
				paging : false
			});
	var window = new Ext.Window({
				title : '科室定价类型维护',
				width :300,
				height : 400,
				modal:true,
				layout : 'fit',
				items : [MasterInfoGrid]
			});
	window.show();
	//自动显示库存项规格
}
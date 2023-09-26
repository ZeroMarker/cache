
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
	fieldLabel : '��������',
	id : 'MTComm',
	name : 'MTComm',
	anchor : '90%',
	width : 120,
	store : MTCommStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '��������...',
	selectOnFocus : true,
	forceSelection : true,
	listWidth : 200,
	valueNotFoundText : ''
	
	});
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'Loc',
		name : 'Loc',
		anchor:'90%',
		groupId:gGroupId
	});
	
var saveMarkType = new Ext.ux.Button({
	text:'����',
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
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","����ɹ�!");
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
				header:"����",
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
				header:"��������",
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
				title : '���Ҷ�������ά��',
				width :300,
				height : 400,
				modal:true,
				layout : 'fit',
				items : [MasterInfoGrid]
			});
	window.show();
	//�Զ���ʾ�������
}
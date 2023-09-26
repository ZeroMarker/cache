Ext.MessageBox.buttonText.yes = 'ȷ��';
Ext.MessageBox.buttonText.no = 'ȡ��';

var itembothDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubexpendrateexe.csp?action=listitemboth&type=2',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['ItemID','ItemName'])
});

var itemBothComboUp = new Ext.form.ComboBox({
	fieldLabel:'itemBothComboUp',
	name:'ItemName',
	store: itembothDs,
	displayField:'ItemName',
	listWidth:220,
	valueField:'ItemID',
	typeAhead: true,
	pageSize: 10,
	width:130,
	triggerAction: 'all',
	emptyText:'',
	selectOnFocus:true,
	anchor: '100%'
});

var itemBothCombo = new Ext.form.ComboBox({
	fieldLabel:'itemBothCombo',
	name:'ItemName',
	store: itembothDs,
	displayField:'ItemName',
	listWidth:220,
	valueField:'ItemID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	minChars : 1,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

/*
var itembothDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubexpendrateexe.csp?action=listitemboth&type=2',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['ItemID','ItemName'])
});
*/

itembothDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.bonussubexpendrateexe.csp?action=listitemboth&type=2&str='+itemBothCombo.getRawValue(),
						method : 'POST'
					})
		});
		

var deptbothDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubexpendrateexe.csp?action=listdeptboth',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['DeptID','DeptName'])
});

var deptBothCombo = new Ext.form.ComboBox({
	fieldLabel:'keshi',
	name:'DeptName',
	store: deptbothDs,
	displayField:'DeptName',
	valueField:'DeptID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});


var deptBothComboUp = new Ext.form.ComboBox({
	fieldLabel:'keshi',
	name:'DeptName',
	store: deptbothDs,
	displayField:'DeptName',
	valueField:'DeptID',
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:130,
	triggerAction: 'all',
	emptyText:'',
	selectOnFocus:true,
	anchor: '100%'
});

var calunitDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubexpendrateexe.csp?action=listcalunit',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
});

var calunitCombo = new Ext.form.ComboBox({
	fieldLabel:'����ɭ',
	name:'name',
	store: calunitDs,
	displayField:'name',
	listWidth:220,
	valueField:'rowid',
	typeAhead: true,
	allowBlank: false,
	pageSize: 10,
	width:130,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});


var tmpRecord = Ext.data.Record.create([
	{
		name: 'BonusUnit',
		type: 'string'
	}, {
		name: 'BonusSubItem',
		type: 'string'
	}, {
		name: 'CalculateUnit',
		type: 'string'
	}, {
		name: 'CalculateRate',
		type: 'float'
	}, {
		name: 'ExecuteRate',
		type: 'float'
	}
]);

var actDirectInvImputSt = new Ext.data.Store({ 
	proxy:new Ext.data.HttpProxy({url:'dhc.bonus.bonussubexpendrateexe.csp?action=list', method:'GET'}),
	reader:new Ext.data.JsonReader({totalProperty:"results",root:'rows'}, ['BonusSubExpendRateID','BonusUnit','BonusSubItem','CalculateUnit','CalculateRate','BonusUnitName','BonusSubItemName','CalculateUnitName','ExecuteRate']),
	remoteSort: true
});
	
var actDirectInvImputCM = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
	header : '�������(��)',
	dataIndex:'BonusUnit',
	width : 180,
	sortable : true,
	editor:deptBothCombo ,
	renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('BonusUnitName'); 
		}	
	},
	{header : '����������Ŀ(��)',dataIndex:'BonusSubItem',width : 180,sortable : true,
	editor:itemBothCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('BonusSubItemName'); 
		}		
	},
	{header : '���㵥λ ',dataIndex:'CalculateUnit',width : 180,sortable : true,editor:calunitCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('CalculateUnitName'); 
		}		
	},
	{header : '��������ϵ�� ',dataIndex:'CalculateRate',width : 180,sortable : true,align:'right',
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return Ext.util.Format.number(value,'0,000.00'); 
		},			
		editor: {
			xtype: 'numberfield'//,
            //allowBlank: false
        }	
	},
	{header : 'ִ�м���ϵ�� ',dataIndex:'ExecuteRate',width : 180,sortable : true,align:'right',
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return Ext.util.Format.number(value,'0,000.00'); 
		},			
		editor: {
			xtype: 'numberfield'//,
            //allowBlank: false
        }	
	}
]);

function checkFun(){
	actDirectInvImputSt.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubexpendrateexe.csp?action=list&filter='+deptBothComboUp.getValue()+'^'+itemBothComboUp.getValue(), method:'GET'});
	actDirectInvImputSt.load({params:{start:0, limit:25}});
};
	
var checkButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',        
	iconCls: 'add',
	handler: function(){
			checkFun();
		}
});
	
var addButton = new Ext.Toolbar.Button({
	text: '���',
	tooltip: '���',        
	iconCls: 'add',
	handler: function(){
        var e = new tmpRecord({
            BonusUnit: '',
			BonusSubItem: '',
			CalculateUnit: '',
			CalculateRate: 0,
			ExecuteRate:0
        });
        editor.stopEditing();
        actDirectInvImputSt.insert(0, e);
        actDirectInvImputMain.getView().refresh();
        actDirectInvImputMain.getSelectionModel().selectRow(0);
        editor.startEditing(0);
    }
});
	
var delButton = new Ext.Toolbar.Button({
	text: 'ɾ��',
	tooltip: 'ɾ��',        
	iconCls: 'remove',
	handler: function(){
		var tmpRec = actDirectInvImputMain.getSelectionModel().getSelected();
		if(tmpRec!=undefined){
			Ext.MessageBox.confirm(
				'��ʾ', 
				'ȷ��Ҫɾ��ѡ������?', 
				function(btn){
					if(btn == 'yes'){
						var tmpRowid = tmpRec.get('BonusSubExpendRateID');
						Ext.Ajax.request({
							url:'dhc.bonus.bonussubexpendrateexe.csp?action=del&rowid='+tmpRowid,
							waitMsg:'...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								//Ext.Msg.show({title:'��ȷ',msg:'������ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								actDirectInvImputSt.load({params:{start:0, limit:25}});
							},
							scope: this
						});		
					}
				}
			);
		}
	}
});

var editor = new Ext.ux.grid.RowEditor({
    saveText: '����',
	cancelText:'ȡ��',
	commitChangesText: '�����ȡ��',
    errorText: '����',
	showTooltip:function(){}
});

editor.on('validateedit',function(reditor,obj,record,rowIndex){

	var tmpBonusSubExpendRateID = record.get('BonusSubExpendRateID');
	//alert(tmpBonusSubExpendRateID);
	/***20140926��Сΰ ������������ϵͳ-���ݽӿ�����-֧��������ϵ��-�޸ĳ��������֮�������һ�
	 ����󣬺������Ϊ�ա�,��Ӵ���:
	var tmpRec = actDirectInvImputMain.getSelectionModel().getSelected();
	BonusUnitCode = tmpRec.get('BonusUnit');
	�޸Ĵ���:tmpData = tmpBonusUnit+"^"+tmpBonusSubItem+"^"+tmpCalculateUnit+"^"+tmpCalculateRate+"^"+tmpExecuteRate;
	Ϊ��tmpData = tmpBonusUnit+"^"+tmpBonusSubItem+"^"+tmpCalculateUnit+"^"+tmpCalculateRate+"^"+tmpExecuteRate+"^"+BonusUnitCode;
	����ԭ���޸ĺ����ݿ���Ӧ�浥Ԫ�����ԭ������ȥ���ǵ�Ԫ���ơ�
	 ***/
	var tmpRec = actDirectInvImputMain.getSelectionModel().getSelected();
	BonusUnitCode = tmpRec.get('BonusUnit');

	var tmpBonusUnit = (typeof(obj.BonusUnit) == "undefined")?record.get('BonusUnit'):obj.BonusUnit;
	
	var tmpBonusSubItem = (typeof(obj.BonusSubItem) == "undefined")?record.get('BonusSubItem'):obj.BonusSubItem;
	var tmpCalculateUnit = (typeof(obj.CalculateUnit) == "undefined")?record.get('CalculateUnit'):obj.CalculateUnit;
	var tmpCalculateRate= (typeof(obj.CalculateRate) == "undefined")?record.get('CalculateRate'):obj.CalculateRate;
	var tmpExecuteRate= (typeof(obj.ExecuteRate) == "undefined")?record.get('ExecuteRate'):obj.ExecuteRate;

	if(typeof(tmpCalculateRate) == "undefined"){
		tmpCalculateRate=0
	}
	if(typeof(tmpExecuteRate) == "undefined"){
		tmpExecuteRate=0
	}
	var tmpData = tmpBonusUnit+"^"+tmpBonusSubItem+"^"+tmpCalculateUnit+"^"+tmpCalculateRate+"^"+tmpExecuteRate+"^"+BonusUnitCode;
	if(typeof(tmpBonusSubExpendRateID) == "undefined"){
		Ext.Ajax.request({
			url:'dhc.bonus.bonussubexpendrateexe.csp?action=add&data='+tmpData,
			waitMsg:'...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				//Ext.Msg.show({title:'��ȷ',msg:'������ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				actDirectInvImputSt.load({params:{start:0, limit:25}});
			},
			scope: this
		});
	}else{
		Ext.Ajax.request({
			url:'dhc.bonus.bonussubexpendrateexe.csp?action=edit&rowid='+tmpBonusSubExpendRateID+'&data='+tmpData,
			waitMsg:'...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {
				//Ext.Msg.show({title:'��ȷ',msg:'������ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
				actDirectInvImputSt.load({params:{start:0, limit:25}});
			},
			scope: this
		});
	}
});

editor.on('canceledit',function(){
	actDirectInvImputSt.load({params:{start:0, limit:25}});
});

var cPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: actDirectInvImputSt,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"
});

var actDirectInvImputMain = new Ext.grid.GridPanel({
	title: '֧������ϵ������',
	store: actDirectInvImputSt,
	cm: actDirectInvImputCM,
	trackMouseOver: true,
	stripeRows: true,
	autoScroll:true,
	clicksToEdit: 1,
    plugins: [editor],
	sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
	loadMask: true,
	tbar: ['�������:',deptBothComboUp ,'������Ŀ:',itemBothComboUp ,checkButton,'-',addButton,delButton],
	bbar: cPagingToolbar
});

actDirectInvImputSt.load({params:{start:0, limit:25}});
itembothDs.load({params:{start:0, limit:100}});
deptbothDs.load({params:{start:0, limit:100}});
calunitDs.load({params:{start:0, limit:100}});
Ext.MessageBox.buttonText.yes = 'ȷ��';
Ext.MessageBox.buttonText.no = 'ȡ��';
//1������ ��2��סԺ��3������
var expensesTypeSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[    
				['0','ȫ��'],	
				['1','����'],            
				['2','סԺ'],            
				['3','����']	
			]                                 
});                                           

var expensesTypeCombo = new Ext.form.ComboBox({
	fieldLabel:'',
	name:'type',
	store: expensesTypeSt,
	displayField:'name',
	valueField:'rowid',
	allowBlank: false,
	typeAhead: true,
	mode: 'local',
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

//1���Էѡ�2��ҽ����3����ũ��
var sickTypeSt = new Ext.data.ArrayStore({
	fields: ['rowid', 'name'],                
	data: 	[       
				['0','ȫ��'],	
				['1','�Է�'],            
				['2','ҽ��'],            
				['3','��ũ��']	
			]                                 
});                                           

var sickTypeCombo = new Ext.form.ComboBox({
	fieldLabel:'',
	name:'type',
	store: sickTypeSt,
	displayField:'name',
	valueField:'rowid',
	allowBlank: false,
	typeAhead: true,
	mode: 'local',
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});


var itembothDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubincomerateexe.csp?action=listitemboth&type=1',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['ItemID','ItemName'])
});

var itemBothComboUp = new Ext.form.ComboBox({
	fieldLabel:'',
	name:'ItemName',
	store: itembothDs,
	displayField:'ItemName',
	listWidth:220,
	valueField:'ItemID',
	typeAhead: true,
	pageSize: 10,
	width:100,
	triggerAction: 'all',
	emptyText:'',
	selectOnFocus:true,
	anchor: '100%'
});

var itemBothCombo = new Ext.form.ComboBox({
	fieldLabel:'',
	name:'ItemName',
	store: itembothDs,
	displayField:'ItemName',
	listWidth:220,
	width:100,
	valueField:'ItemID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});


var deptbothDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubincomerateexe.csp?action=listdeptboth',method:'GET'}),
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
	width:100,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

var deptBothCombo2 = new Ext.form.ComboBox({
	fieldLabel:'keshi',
	name:'DeptName',
	store: deptbothDs,
	displayField:'DeptName',
	valueField:'DeptID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

var deptBothCombo3 = new Ext.form.ComboBox({
	fieldLabel:'keshi',
	name:'DeptName',
	store: deptbothDs,
	displayField:'DeptName',
	valueField:'DeptID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
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
	width:100,
	triggerAction: 'all',
	emptyText:'',
	selectOnFocus:true,
	anchor: '100%'
});

var deptBothComboUp2 = new Ext.form.ComboBox({
	fieldLabel:'keshi',
	name:'DeptName',
	store: deptbothDs,
	displayField:'DeptName',
	valueField:'DeptID',
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
	triggerAction: 'all',
	emptyText:'',
	selectOnFocus:true,
	anchor: '100%'
});

var deptBothComboUp3 = new Ext.form.ComboBox({
	fieldLabel:'keshi',
	name:'DeptName',
	store: deptbothDs,
	displayField:'DeptName',
	valueField:'DeptID',
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
	triggerAction: 'all',
	emptyText:'',
	selectOnFocus:true,
	anchor: '100%'
});


var doctorbothDs = new Ext.data.Store({
	proxy: new Ext.data.HttpProxy({url:'dhc.bonus.bonussubincomerateexe.csp?action=listdoctorboth',method:'GET'}),
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['DoctorID','DoctorName'])
});

var doctorBothCombo = new Ext.form.ComboBox({
	fieldLabel:'doctor',
	name:'DoctorName',
	store: doctorbothDs,
	displayField:'DoctorName',
	valueField:'DoctorID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

var doctorBothCombo2 = new Ext.form.ComboBox({
	fieldLabel:'doctor',
	name:'DoctorName',
	store: doctorbothDs,
	displayField:'DoctorName',
	valueField:'DoctorID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

var doctorBothCombo3 = new Ext.form.ComboBox({
	fieldLabel:'doctor',
	name:'DoctorName',
	store: doctorbothDs,
	displayField:'DoctorName',
	valueField:'DoctorID',
	allowBlank: false,
	typeAhead: true,
	pageSize: 10,
	listWidth:220,
	width:100,
	forceSelection: true,
	triggerAction: 'all',
	emptyText:'��ѡ',
	selectOnFocus:true,
	anchor: '100%'
});

var tmpRecord = Ext.data.Record.create([
	{
		name: 'BonusSubItemID',
		type: 'string'
	}, {
		name: 'MakeBillDept',
		type: 'string'
	}, {
		name: 'ExecuteDept',
		type: 'string'
	}, {
		name: 'SickDept',
		type: 'string'
	}, {
		name: 'ExpensesType',
		type: 'string'
	}, {
		name: 'SickType',
		type: 'string'
	}, {
		name: 'ChiefDoctor',
		type: 'string'
	}, {
		name: 'MakeBillDoctor',
		type: 'string'
	}, {
		name: 'ExecuteDoctor',
		type: 'string'
	}, {
		name: 'MakeBillDeptRate',
		type: 'float'
	}, {
		name: 'ExecuteDeptRate',
		type: 'float'
	},{
		name: 'SickDeptRate',
		type: 'float'
	}
]);

var actDirectInvImputSt = new Ext.data.Store({ 
	proxy:new Ext.data.HttpProxy({url:'dhc.bonus.bonussubincomerateexe.csp?action=list', method:'GET'}),
	reader:new Ext.data.JsonReader({totalProperty:"results",root:'rows'}, ['BonusSubIncomeRateID','BonusSubItemID','MakeBillDept','ExecuteDept','SickDept','ChiefDoctor','MakeBillDoctor','ExecuteDoctor','SubItemName','ExpensesType','SickType','MakeBillDeptRate','ExecuteDeptRate','SickDeptRate','BonusSubItemName','MakeBillDeptName','ExecuteDeptName','SickDeptName','ChiefDoctorName','MakeBillDoctorName','ExecuteDoctorName']),
	remoteSort: true
});
	
var actDirectInvImputCM = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{header : '�շ���Ŀ(��)',dataIndex:'BonusSubItemID',width : 100,sortable : true,editor:itemBothCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('BonusSubItemName'); 
		}
	},
	{header : '��������(��)',dataIndex:'MakeBillDept',width : 100,sortable : true,editor:deptBothCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('MakeBillDeptName'); 
		}	
	},
	{header : 'ִ�п�����(��)',dataIndex:'ExecuteDept',width : 100,sortable : true,editor:deptBothCombo2,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('ExecuteDeptName'); 
		}		
	},
	{header : '���˿���(��)',dataIndex:'SickDept',width : 100,sortable : true,editor:deptBothCombo3,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('SickDeptName'); 
		}		
	},
	{header : '�������',dataIndex:'ExpensesType',width : 100,sortable : true,editor:expensesTypeCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			var name = "";
			if(value=='0'){
				name='ȫ��';
			}			
			if(value=='1'){
				name='����';
			}
			if(value=='2'){
				name='סԺ';
			}
			if(value=='3'){
				name='����';
			}			
			return name; 
		}			
	},
	{header : '������� ',dataIndex:'SickType',width : 100,sortable : true,editor:sickTypeCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			var name = "";
			if(value=='0'){
				name='ȫ��';
			}			
			if(value=='1'){
				name='�Է�';
			}
			if(value=='2'){
				name='ҽ��';
			}
			if(value=='3'){
				name='��ũ��';
			}			
			return name; 
		}		
	},
	{header : '����ҽ��(��)',dataIndex:'ChiefDoctor',width : 100,sortable : true,editor:doctorBothCombo3,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('ChiefDoctorName'); 
		}			
	},
	{header : '����ҽ��(��)',dataIndex:'MakeBillDoctor',width : 100,sortable : true,editor:doctorBothCombo,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('MakeBillDoctorName'); 
		}			
	},
	{header : 'ִ��ҽ��(��)',dataIndex:'ExecuteDoctor',width : 100,sortable : true,editor:doctorBothCombo2,
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return record.get('ExecuteDoctorName'); 
		}			
	},
	{header : '��������ϵ�� ',dataIndex:'MakeBillDeptRate',width : 100,sortable : true,align:'right',
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return Ext.util.Format.number(value,'0,000.00'); 
		},			
		editor: {
			xtype: 'numberfield'//,
            //allowBlank: false
        }
	},
	{header : 'ִ�м���ϵ�� ',dataIndex:'ExecuteDeptRate',width : 100,sortable : true,align:'right',
		renderer:	function(value,metadata,record,rowIndex,colIndex,store){
			return Ext.util.Format.number(value,'0,000.00'); 
		},			
		editor: {
			xtype: 'numberfield'//,
            //allowBlank: false
        }	
	},
	{header : '���˿��Ҽ���ϵ��',dataIndex:'SickDeptRate',width : 100,sortable : true,align:'right',
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
	actDirectInvImputSt.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonussubincomerateexe.csp?action=list&filter='+itemBothComboUp.getValue()+'^'+deptBothComboUp.getValue()+'^'+deptBothComboUp2.getValue()+'^'+deptBothComboUp3.getValue(), method:'GET'});
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
            BonusSubItemID: '',
			MakeBillDept: '',
			ExecuteDept: '',
			SickDept: '',
			ExpensesType: '',
			SickType: '',
			ChiefDoctor: '',
			MakeBillDoctor: '',
			ExecuteDoctor: '',
            MakeBillDeptRate: 0,
			ExecuteDeptRate: 0,
			SickDeptRate: 0
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
						var tmpRowid = tmpRec.get('BonusSubIncomeRateID');
						Ext.Ajax.request({
							url:'dhc.bonus.bonussubincomerateexe.csp?action=del&rowid='+tmpRowid,
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
//BonusSubIncomeRateID BonusSubItemID MakeBillDept ExecuteDept SickDept ChiefDoctor MakeBillDoctor ExecuteDoctor SubItemName ExpensesType SickType MakeBillDeptRate ExecuteDeptRate SickDeptRate
// 
	var tmpBonusSubIncomeRateID = record.get('BonusSubIncomeRateID');
	var tmpBonusSubItemID = (typeof(obj.BonusSubItemID) == "undefined")?record.get('BonusSubItemID'):obj.BonusSubItemID;
	var tmpMakeBillDept = (typeof(obj.MakeBillDept) == "undefined")?record.get('MakeBillDept'):obj.MakeBillDept;
	var tmpExecuteDept = (typeof(obj.ExecuteDept) == "undefined")?record.get('ExecuteDept'):obj.ExecuteDept;
	var tmpSickDept = (typeof(obj.SickDept) == "undefined")?record.get('SickDept'):obj.SickDept;
	var tmpChiefDoctor = (typeof(obj.ChiefDoctor) == "undefined")?record.get('ChiefDoctor'):obj.ChiefDoctor;
	var tmpMakeBillDoctor = (typeof(obj.MakeBillDoctor) == "undefined")?record.get('MakeBillDoctor'):obj.MakeBillDoctor;
	var tmpExecuteDoctor= (typeof(obj.ExecuteDoctor) == "undefined")?record.get('ExecuteDoctor'):obj.ExecuteDoctor;
	var tmpSubItemName = (typeof(obj.SubItemName) == "undefined")?record.get('SubItemName'):obj.SubItemName;
	var tmpExpensesType = (typeof(obj.ExpensesType) == "undefined")?record.get('ExpensesType'):obj.ExpensesType;
	var tmpSickType = (typeof(obj.SickType) == "undefined")?record.get('SickType'):obj.SickType;
	var tmpMakeBillDeptRate = (typeof(obj.MakeBillDeptRate) == "undefined")?record.get('MakeBillDeptRate'):obj.MakeBillDeptRate;
	var tmpExecuteDeptRate = (typeof(obj.ExecuteDeptRate) == "undefined")?record.get('ExecuteDeptRate'):obj.ExecuteDeptRate;
	var tmpSickDeptRate = (typeof(obj.SickDeptRate) == "undefined")?record.get('SickDeptRate'):obj.SickDeptRate;
	//alert(tmpInvName+","+tmpInvNum+","+tmpInvPrice+","+tmpInvMny);
	var tmpData = tmpBonusSubItemID+"^"+tmpMakeBillDept+"^"+tmpExecuteDept+"^"+tmpSickDept+"^"+tmpChiefDoctor+"^"+tmpMakeBillDoctor+"^"+tmpExecuteDoctor+"^^"+tmpExpensesType+"^"+tmpSickType+"^"+tmpMakeBillDeptRate+"^"+tmpExecuteDeptRate+"^"+tmpSickDeptRate;

		if(typeof(tmpBonusSubIncomeRateID) == "undefined"){
			Ext.Ajax.request({
				url:'dhc.bonus.bonussubincomerateexe.csp?action=add&data='+tmpData,
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
				url:'dhc.bonus.bonussubincomerateexe.csp?action=edit&rowid='+tmpBonusSubIncomeRateID+'&data='+tmpData,
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
	title: '��������ϵ������',
	store: actDirectInvImputSt,
	cm: actDirectInvImputCM,
	trackMouseOver: true,
	stripeRows: true,
	autoScroll:true,
	clicksToEdit: 1,
    plugins: [editor],
	sm: new Ext.grid.RowSelectionModel({ singleSelect: true }),
	loadMask: true,
	tbar: ['�շ���Ŀ(��):',itemBothComboUp,'��������(��):',deptBothComboUp,'ִ�п�����(��):',deptBothComboUp2,'���˿���(��):',deptBothComboUp3,checkButton,'-',addButton,delButton],
	bbar: cPagingToolbar
});

actDirectInvImputSt.load({params:{start:0, limit:25}});
itembothDs.load({
	params:{start:0, limit:100}
});
deptbothDs.load({
	params:{start:0, limit:100}
});
doctorbothDs.load({
	params:{start:0, limit:100}
});

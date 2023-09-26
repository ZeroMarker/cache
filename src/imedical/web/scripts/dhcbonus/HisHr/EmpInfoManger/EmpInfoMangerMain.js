
var EmpDeptUrl="dhc.bonus.hishr.empinformangerexe.csp"
// ��Ա����
var EMPTypeStore2 = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['YS', 'ҽ��'], ['HS', '��ʿ'], ['QT', '����']]
		});
var EMPTypeField2 = new Ext.form.ComboBox({
			id : 'EMPTypeField2',
			fieldLabel : '��Ա���',
			width : 60,
			listWidth : 40,
			//selectOnFocus : true,
			allowBlank : false,
			store : EMPTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

// ��Ա��������
var EmpDetpeField = new Ext.form.TextField({
	id: 'EmpDetpeField',
	fieldLabel: '��������',
	width:80,
	listWidth : 245,
	
	triggerAction: 'all',
	emptyText:'���������',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});


// ��Աѧ�� HighStudy
var HighStudyDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

HighStudyDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:EmpDeptUrl+'?action=GetHighStudy&start=0&limit=25',method:'POST'})
		});

var HighStudyField = new Ext.form.ComboBox({
	id: 'HighStudyField',
	fieldLabel: '��Աѧ��',
	width:80,
	listWidth : 100,
	// allowBlank: false,
	store: HighStudyDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��Աѧ��',
	name: 'HighStudyField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.12,
	forceSelection:'true',
	editable:true
});
// ��Ա��� 
var EmpTypeDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});
/*
EmpTypeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:EmpDeptUrl+'?action=GetEmpType',method:'POST'})
		});

var EmpTypeField = new Ext.form.ComboBox({
	id: 'EmpTypeField',
	fieldLabel: '��Ա���',
	width:80,
	listWidth : 120,
	// allowBlank: false,
	store: EmpTypeDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��Ա���',
	name: 'EmpTypeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.12,
	forceSelection:'true',
	editable:true
});
*/
var EMPTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['YS', 'ҽ��'], ['HS', '��ʿ'], ['QT', '����']]
		});
var EmpTypeField = new Ext.form.ComboBox({
			id : 'EmpTypeField',
			fieldLabel : '��Ա���',
			width : 60,
			listWidth : 100,
			//selectOnFocus : true,
			allowBlank : false,
			store : EMPTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			pageSize : 10,
			minChars : 1,
			columnWidth:.12
			//selectOnFocus : true,
			//forceSelection : true
		});
// ��Ա���롢��Ա����
var EmpNameField = new Ext.form.TextField({
	id: 'EmpNameField',
	fieldLabel: '��Ա����',
	width:80,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'���������',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});

// ����ϵ��
var BonusRateField = new Ext.form.NumberField({
	id: 'BonusRateField',
	fieldLabel: '����ϵ��',
	width:80,
	listWidth : 245,
	
	triggerAction: 'all',
	emptyText:'',
	name: 'BonusRateField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});

var JionDateField= new Ext.form.DateField({
	format:'Y-m-d',
	width:80,
	columnWidth:.12,
	minChars: 1,
	pageSize: 10,
	dateFormat: 'Y-m-d',
	triggerAction: 'all',
	emptyText:'��ְ����...',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	}
});

var WorkDateField= new Ext.form.DateField({
	format:'Y-m-d',
	width:80,
	columnWidth:.12,
	minChars: 1,
	pageSize: 10,
	emptyText:'ת������...',
	 dateFormat: 'Y-m-d',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	}
});

var PeriodDateField= new Ext.form.DateField({
	format:'Y-m-d',
	width:80,
	columnWidth:.12,
	minChars: 1,
	pageSize: 10,
	emptyText:'��Ч����...',
	 dateFormat: 'Y-m-d',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	}
});


var queryPanel = new Ext.FormPanel({
	height : 100,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [ {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{   	xtype : 'displayfield',
					value : '��������:',
					columnWidth : .05
				}
				, EmpDetpeField
				, {
					xtype : 'displayfield',
					value : '��Ա����:',
					columnWidth : .05
				}
				, EmpNameField
				, {
					xtype : 'displayfield',
					value : '��Աѧ��:',
					columnWidth : .05
				}
				,HighStudyField
				, {
					xtype : 'displayfield',
					value : '��Ա���:',
					columnWidth : .05
				}
				,EmpTypeField
				, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .05
				}
				]
	},
	{
		xtype: 'panel',
		columnWidth : 1,
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '��ְ����:',
					columnWidth : .05
				}
				,JionDateField
				,{
					xtype : 'displayfield',
					value : 'ת������:',
					columnWidth : .05
				}
				, WorkDateField
				,{
					xtype : 'displayfield',
					value : '����ϵ��:',
					columnWidth : .05
				}
				, BonusRateField
				,{
					xtype : 'displayfield',
					value : '��Ч����:',
					columnWidth : .05
				}
				, PeriodDateField
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .05
				},{
					columnWidth:.05,
					xtype:'button',
					text: '��ѯ',
					handler:function(b){
						
					
					var empName=EmpNameField.getValue();
					var deptName=EmpDetpeField.getValue();
					var empStudy=HighStudyField.getValue();
					var empType=EmpTypeField.getValue();
					var jionDate=JionDateField.getValue();	
					var workDate=WorkDateField.getValue();	
					var BonusRate=BonusRateField.getValue();
					var PeriodDate=PeriodDateField.getValue();
					//var daysDate=DayCombo.getValue();
					if(jionDate!=""){jionDate=jionDate.format("Y-m-d");}
					if(workDate!=""){workDate=workDate.format("Y-m-d");}
					if(PeriodDate!=""){PeriodDate=PeriodDate.format("Y-m-d");}
					
					var sdata=empName+"^"+deptName+"^"+empStudy+"^"+empType+"^"+jionDate+"^"+workDate+"^"+BonusRate+"^"+PeriodDate
					//alert(sdata)
					itemGrid.load(({params:{start:0, limit:25,sData:sdata}}));
						
					},
					
					iconCls: 'add'
				}	
				]
		}

		
		]
		
	});




var startDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'��ʼʱ��...',
	columnWidth:1
});
var endDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'����ʱ��...',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	},
	columnWidth:1
});

var VenDorTypeCom2 = new Ext.form.ComboBox({	
			id:'VenDorTypeCom2',											
			fieldLabel: '��Ա���',
			width:110,
			listWidth : 70,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['YS', 'ҽ��'], ['HS', '��ʿ'],['QT','����']
					]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '��Ա���',
			selectOnFocus:'true'
		
		
});

var itemGrid = new dhc.herp.Grid({
        //title: '��������',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.hishr.empinformangerexe.csp',
        /*listeners : {
		    'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                 var record = grid.getStore().getAt(rowIndex);
		                 if (columnIndex<11) {
		                      return false;
		                  }
		                  else {return true;}
		               },
		    'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
	                 if (columnIndex<11) {
		                      return false;
		                  }
		                  else {return true;}
				}
        	},	 */ 
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
	        editable:false,
            header: 'ID',
            dataIndex: 'rowid',
			sortable:true,	
			edit:false,
            hidden: true
        },{
	        editable:false,
            id:'DeptCode',
            header: '���ұ���',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'DeptCode'
        },{
	        editable:false,
            id:'DeptName',
            header: '��������',
			allowBlank: true,
			sortable:true,	
			width:100,
            dataIndex: 'DeptName'
        },{
	        editable:false,
            id:'EmpCardID',
            header: '��Ա����',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'EmpCardID'
        },{
	        editable:false,
            id:'Name',
            header: '��Ա����',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'Name'
        },{
	        editable:false,
            id:'Sex',
            header: '�Ա�',
			sortable:true,	
			allowBlank: true,
			width:70,
            dataIndex: 'Sex'
        },{
	        editable:false,
            id:'HighStudy',
            header: 'ѧ��',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'HighStudy'
        },{
            id:'SkillDuty',
            header: '��Աְ��',
			allowBlank: true,
			sortable:true,	
			width:100,
            dataIndex: 'SkillDuty'
        },{
	        
            id:'EmpTypeName',
            header: '��Ա���',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'EmpTypeName',
            type:VenDorTypeCom2
        },{
	        editable:false,
            id:'StartWorkDay',
            header: '��ְ����',
			allowBlank: true,
			sortable:true,	
			width:110,
            dataIndex: 'StartWorkDay'
        },{
            id:'TryOutDay',
            header: 'ת������',
			allowBlank: true,
			width:120,
			sortable:true,	
            dataIndex: 'TryOutDay',
           // type: startDateField,
            type: "dateField"
            /*
			renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
			}*/
        },{
            id:'BonusRate',
            header: '����ϵ��',
			allowBlank: true,
			width:70,
			sortable:true,	
			//editable:false,
            dataIndex: 'BonusRate'
        },{
            id:'PeriodDate',
            header: '��Ч����',
			allowBlank: true,
			width:120,
			sortable:true,	
            dataIndex: 'PeriodDate',
           // type: startDateField,
            type: "dateField"
            /*
			renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
			}*/
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
	itemGrid.btnAddHide() 	//�������Ӱ�ť
		//btnSaveHide() 	//���ر��水ť
		//btnResetHide() 	//�������ð�ť
	itemGrid.btnDeleteHide() //����ɾ����ť
		//btnPrintHide() 	//���ش�ӡ��ť
		
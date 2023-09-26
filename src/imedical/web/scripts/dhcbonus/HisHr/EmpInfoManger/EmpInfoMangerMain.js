
var EmpDeptUrl="dhc.bonus.hishr.empinformangerexe.csp"
// 人员科室
var EMPTypeStore2 = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['YS', '医生'], ['HS', '护士'], ['QT', '其他']]
		});
var EMPTypeField2 = new Ext.form.ComboBox({
			id : 'EMPTypeField2',
			fieldLabel : '人员类别',
			width : 60,
			listWidth : 40,
			//selectOnFocus : true,
			allowBlank : false,
			store : EMPTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

// 人员所属科室
var EmpDetpeField = new Ext.form.TextField({
	id: 'EmpDetpeField',
	fieldLabel: '所属科室',
	width:80,
	listWidth : 245,
	
	triggerAction: 'all',
	emptyText:'编码或名称',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});


// 人员学历 HighStudy
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
	fieldLabel: '人员学历',
	width:80,
	listWidth : 100,
	// allowBlank: false,
	store: HighStudyDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'人员学历',
	name: 'HighStudyField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.12,
	forceSelection:'true',
	editable:true
});
// 人员类别 
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
	fieldLabel: '人员类别',
	width:80,
	listWidth : 120,
	// allowBlank: false,
	store: EmpTypeDs,
	valueField: 'code',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'人员类别',
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
			data : [['YS', '医生'], ['HS', '护士'], ['QT', '其他']]
		});
var EmpTypeField = new Ext.form.ComboBox({
			id : 'EmpTypeField',
			fieldLabel : '人员类别',
			width : 60,
			listWidth : 100,
			//selectOnFocus : true,
			allowBlank : false,
			store : EMPTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			columnWidth:.12
			//selectOnFocus : true,
			//forceSelection : true
		});
// 人员编码、人员姓名
var EmpNameField = new Ext.form.TextField({
	id: 'EmpNameField',
	fieldLabel: '人员姓名',
	width:80,
	listWidth : 245,
	triggerAction: 'all',
	emptyText:'编码或名称',
	name: 'codeField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});

// 享受系数
var BonusRateField = new Ext.form.NumberField({
	id: 'BonusRateField',
	fieldLabel: '享受系数',
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
	emptyText:'入职日期...',
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
	emptyText:'转正日期...',
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
	emptyText:'有效日期...',
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
					value : '所属科室:',
					columnWidth : .05
				}
				, EmpDetpeField
				, {
					xtype : 'displayfield',
					value : '人员姓名:',
					columnWidth : .05
				}
				, EmpNameField
				, {
					xtype : 'displayfield',
					value : '人员学历:',
					columnWidth : .05
				}
				,HighStudyField
				, {
					xtype : 'displayfield',
					value : '人员类别:',
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
					value : '入职日期:',
					columnWidth : .05
				}
				,JionDateField
				,{
					xtype : 'displayfield',
					value : '转正日期:',
					columnWidth : .05
				}
				, WorkDateField
				,{
					xtype : 'displayfield',
					value : '享受系数:',
					columnWidth : .05
				}
				, BonusRateField
				,{
					xtype : 'displayfield',
					value : '有效日期:',
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
					text: '查询',
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
	emptyText:'开始时间...',
	columnWidth:1
});
var endDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'结束时间...',
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
			fieldLabel: '人员类别',
			width:110,
			listWidth : 70,
			anchor: '95%',
			store : new Ext.data.ArrayStore({
					fields : ['code', 'name'],
					data : [['YS', '医生'], ['HS', '护士'],['QT','其他']
					]
				}),
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '人员类别',
			selectOnFocus:'true'
		
		
});

var itemGrid = new dhc.herp.Grid({
        //title: '年月设置',
        width: 400,
        //edit:false,                   //是否可编辑
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
		atLoad : true, // 是否自动刷新
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
            header: '科室编码',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'DeptCode'
        },{
	        editable:false,
            id:'DeptName',
            header: '科室名称',
			allowBlank: true,
			sortable:true,	
			width:100,
            dataIndex: 'DeptName'
        },{
	        editable:false,
            id:'EmpCardID',
            header: '人员卡号',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'EmpCardID'
        },{
	        editable:false,
            id:'Name',
            header: '人员姓名',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'Name'
        },{
	        editable:false,
            id:'Sex',
            header: '性别',
			sortable:true,	
			allowBlank: true,
			width:70,
            dataIndex: 'Sex'
        },{
	        editable:false,
            id:'HighStudy',
            header: '学历',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'HighStudy'
        },{
            id:'SkillDuty',
            header: '人员职务',
			allowBlank: true,
			sortable:true,	
			width:100,
            dataIndex: 'SkillDuty'
        },{
	        
            id:'EmpTypeName',
            header: '人员类别',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'EmpTypeName',
            type:VenDorTypeCom2
        },{
	        editable:false,
            id:'StartWorkDay',
            header: '入职日期',
			allowBlank: true,
			sortable:true,	
			width:110,
            dataIndex: 'StartWorkDay'
        },{
            id:'TryOutDay',
            header: '转正日期',
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
            header: '享受系数',
			allowBlank: true,
			width:70,
			sortable:true,	
			//editable:false,
            dataIndex: 'BonusRate'
        },{
            id:'PeriodDate',
            header: '有效日期',
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
	itemGrid.btnAddHide() 	//隐藏增加按钮
		//btnSaveHide() 	//隐藏保存按钮
		//btnResetHide() 	//隐藏重置按钮
	itemGrid.btnDeleteHide() //隐藏删除按钮
		//btnPrintHide() 	//隐藏打印按钮
		
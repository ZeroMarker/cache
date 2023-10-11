var userdr = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgsetenddateexe.csp';
// 年度///////////////////////////////////
var YearDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, [ 'year', 'year' ])
});

YearDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
		url : commonboxUrl + '?action=year&flag=',
		method : 'POST'
	});
});

var yearCombo = new Ext.form.ComboBox({
	fieldLabel : '预算年度',
	store : YearDs,
	displayField : 'year',
	valueField : 'year',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 120,
	listWidth : 245,
	pageSize : 10,
	minChars : 1,
	columnWidth : .12,
	selectOnFocus : true
});

//调整序号
var BSMnameDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['AdjustNo','AdjustNo'])
});

BSMnameDs.on('beforeload', function(ds, o){
  
	 var year =yearCombo.getValue();

          if(!year) 
          {
         	Ext.Msg.show({title:'注意',msg:'请先选择年度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
         	return;
          }
});


var adjustnumber = new Ext.form.ComboBox({
	id: 'adjustnumber',
	fieldLabel: '调整序号',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	disabled:true,
	store: BSMnameDs,
	valueField: 'AdjustNo',
	displayField: 'AdjustNo',
	triggerAction: 'all',
	emptyText:'请先选择年度....',
	name: 'adjustnumber',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});	




var ChangeFlagStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '期初预算'], ['2', '调整后预算']]
		});
var ChangeFlagField = new Ext.form.ComboBox({
			id : 'ChangeFlagField',
			fieldLabel : '是否期初',
			width : 100,
			listWidth : 245,
			selectOnFocus : true,
			allowBlank : false,
			store : ChangeFlagStore,
			anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			columnWidth : .12,
			selectOnFocus : true,
			forceSelection : true,
            listeners:{
	            select:{
		            fn:function(combo,record,index) { 
	                    if(combo.value==2){
		                    
		                    adjustnumber.enable();
	 						var year =yearCombo.getValue();
		                    BSMnameDs.removeAll();     				
		                 	BSMnameDs.proxy= new Ext.data.HttpProxy({url:commonboxUrl+'?action=adjustno&flag=&year='+year+'&start=0'+'&limit=10',method:'POST'});      
			                BSMnameDs.load({params:{start:0,limit:10}});   
	                    }else{
		                    adjustnumber.setValue('');
		                    adjustnumber.disable();
		                	return;    
		                }
	                    
            		}
            	}
            }

		});
		
	

///////////////科室名称////////////////////////
var audnameDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

audnameDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : commonboxUrl+'?action=dept&flag=1&str='+encodeURIComponent(Ext.getCmp('audnamefield').getRawValue()),
		method : 'POST'
		});
});
var audnamefield = new Ext.form.ComboBox({
			id: 'audnamefield',
			name: 'audnamefield',
			fieldLabel : '科室名称',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});
		
var EndDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'截止日期...',
	columnWidth:.1
});


var findButton = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '查询',
	iconCls : 'option',
	handler : function() {
		var year = yearCombo.getValue();
		var ChangeFlag=ChangeFlagField.getValue();
		var adjustNo=adjustnumber.getValue();
		var deptdr = audnamefield.getValue();
		var enddate = EndDateField.getValue();

        if(year=="") {
         	Ext.Msg.show({title:'注意',msg:'请先选择年度！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
         	return;
         }
		itemGrid.load({
			params : {
				start : 0,
				limit : 25,
				year : year,
				ChangeFlag:ChangeFlag,
				adjustNo:adjustNo,
				deptdr : deptdr
			}
		});
	}
});

var addButton = new Ext.Toolbar.Button({
	text : '保存',
	tooltip : '保存',
	iconCls : 'save',
	handler : function() {	 
		var Year = yearCombo.getValue();
		var ChangeFlag=ChangeFlagField.getValue();
		var adjustNo=adjustnumber.getValue();
		var Deptdr = audnamefield.getValue();
		var Enddate = EndDateField.getValue();
		 	Enddate=Enddate.format('Y-m-d');
	 	var selectedRow=itemGrid.getSelectionModel().getSelections();
	    for(i=0;i<selectedRow.length;i++){
		 	var year=selectedRow[i].data['year'];
		 	var deptdr=selectedRow[i].data['deptdr'];
		 	
			addFun(year,ChangeFlag,adjustNo,deptdr,Enddate,Year,Deptdr,Enddate);
		}
		
	}

});

var queryPanel = new Ext.FormPanel(
		{
			height : 90,
			region : 'north',
			frame : true,

			defaults : {
				bodyStyle : 'padding:5px'
			},
			items : [
					{
						xtype : 'panel',
						layout : "column",
						items : [ {
							xtype : 'displayfield',
							value : '<center><p style="font-weight:bold;font-size:120%">设置科室年预算分解到月截止日期</p></center>',
							columnWidth : 1,
							height : '32'
						} ]
					}, {
						columnWidth : 1,
						xtype : 'panel',
						layout : "column",
						items : [  {
							xtype : 'displayfield',
							value : '预算年度:',
							columnWidth : .05
						}, yearCombo,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},{
							xtype : 'displayfield',
							value : '是否期初:',
							columnWidth : .05
						}, ChangeFlagField,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},{
							xtype : 'displayfield',
							value : '调整序号:',
							columnWidth : .05
						}, adjustnumber,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},{
							xtype : 'displayfield',
							value : '科室名称:',
							columnWidth : .05
						}, audnamefield,{
							xtype : 'displayfield',
							value : '',
							columnWidth : .02
						},{
							xtype : 'displayfield',
							value : '截止日期:',
							columnWidth : .05
						}, EndDateField
						]
					} ]
		});

var itemGrid = new dhc.herp.Grid(
		{
			atload : true,
			region : 'center',
			url : projUrl,
			fields : [
    				new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
						id : 'CompName',
						header : '医疗单位',
						width : 90,
						editable : false,
						dataIndex : 'CompName'

					},{
						id : 'year',
						header : '年份',
						width : 90,
						editable : false,
						dataIndex : 'year'

					},{
			        	  id : 'deptdr',
			        	  header : 'id',
			        	  width : 90,
			        	  hidden:true,
			        	  editable : false,
			        	  dataIndex : 'deptdr'
			        },{
						id : 'deptname',
						header : '科室名称',
						width : 90,
						editable : false,
						dataIndex : 'deptname'

					},{
			            id:'enddate',
			            header: '截止日期',
						allowBlank: false,
						width:200,
			        	editable : false,
			            dataIndex: 'enddate',
			            type: 'dateField'
			            //renderer: Ext.util.Format.dateRenderer('Y-m-d')

            			//dateFormat: 'Y-m-d'             
						/*
						renderer : function(v, p, r, i) {			
							if (v instanceof Date) {
								return new Date(v).format("Y-m-d");
							} else {
								return v;
							}
						}*/
			        }],
			xtype : 'grid',
			loadMask : true,
			// viewConfig : {forceFit : true},
		tbar : [ findButton, '-', addButton]

		});

itemGrid.btnAddHide(); // 隐藏增加按钮
itemGrid.btnSaveHide(); // 隐藏保存按钮
itemGrid.btnResetHide(); // 隐藏重置按钮
itemGrid.btnDeleteHide(); // 隐藏删除按钮
itemGrid.btnPrintHide(); // 隐藏打印按钮

itemGrid.load({
	params : {
		start : 0,
		limit : 12,
		year: yearCombo.getValue(),
		deptdr: audnamefield.getValue()
	}
	
});


/*
// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {


});
*/
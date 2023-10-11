var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var projUrl = 'herp.budg.budgprojchecktrecexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '立项年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 100,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ////////////项目名称////////////////////////
var projDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

projDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=projList',
						method : 'POST'
					});
		});

var projCombo = new Ext.form.ComboBox({
			fieldLabel : '项目名称',
			store : projDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 200,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
/////////////////////申请单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

		});


var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){

	      	var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			var billcode = applyNo.getValue();

		itemGrid.load({params:{start:0,limit:25,year:year,projname:projname,billcode:billcode,userdr:userdr}});
	}
});


var detailButton = new Ext.Toolbar.Button({
	text: '明细',
	tooltip: '明细',
	iconCls: 'option',
	handler: function(){
	
	    EditFun(itemGrid);
	}
});

var queryPanel = new Ext.FormPanel({
	height : 90,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:120%">项目资金审核</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{
					xtype : 'displayfield',
					value : '立项年度:',
					columnWidth : .05
				}, yearCombo,

				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .05
				}, projCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请单号:',
					columnWidth : .05
				}, applyNo

		]
	}]
});
function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?projdr={1}&year={2}&report=HERPBUDGProjAdjDetail.raq&reportName=HERPBUDGProjAdjDetail.raq&ServerSideRedirect=dhccpmrunqianreport.csp\" >{0}</a></b>",
	            value, record.data.projDr,record.data.Year);
//下面这个东西是个数组，猜的，value是这个单元格的值，record是整个记录，record.data.Year可以获得记录的某一条的值通过如year={2}这样的东西传递{2}就是record.data.Year	            
}
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : 'herp.budg.budgprojchecktrecexe.csp',		
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 ChkStep' 'StepNO'
		                 var chk=record.get('IsCurStep');
		                 var no=record.get('IsCurStep');
		                 if (((record.get('IsCurStep') =="0")||(record.get('BillState')=="新建")||(chk!=no))&& (columnIndex ==3)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						var chk=record.get('IsCurStep');
		                var no=record.get('IsCurStep');
						if (((record.get('IsCurStep') =="0")||(record.get('BillState')=="新建")||(chk!=no)) && (columnIndex == 3)) {						
							return false;
						} else {
							return true;
						}
					}
            },
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
	                                                                                id : 'CompName',
	                                                                                header : '医疗单位',
                                                                                                width : 90,
	                                                                                editable : false,
                                                                                                dataIndex : 'CompName'

	                                                                 },{
						id : 'submit',
						header : '选择',
						dataIndex : 'submit',
						width : 80,
						align:'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsCurStep'];
						var cf = record.data['BillState'];
						var chk = record.data['ChkStep'];
						var no = record.data['StepNO'];
						//alert(sf+"|"+cf+"|"+chk+"|"+no);
						if ((sf == "是")&&(cf=="提交")&&(chk==no)) {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>审核</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand">审核</span>';
						}},
						hidden : false

					}, {
						id : 'Year',
						header : '年度',
						width : 80,
						editable:false,
						dataIndex : 'Year'

					}, {
						id : 'Code',
						header : '申请单号',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'

					},{
						id : 'Name',
						header : '项目名称',
						editable:false,
						width : 200,
						/*renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},*/
						dataIndex : 'Name',
						renderer : renderTopic

					}, {
						id : 'deptDr',
						header : '科室id',
						editable : false,
						//align : 'center',
						width : 60,
						hidden : true,
						dataIndex : 'deptDr'

					}, {
						id : 'dname',
						header : '申请科室',
						editable:false,
						width : 120,
						dataIndex : 'dname'

					}, {
						id : 'ApplyerDR',
						header : '申请人id',
						editable : false,
						//align : 'center',
						width : 60,
						hidden : true,
						dataIndex : 'ApplyerDR'

					},{
						id : 'uName',
						header : '申请人',
						width : 100,
						editable:false,
						dataIndex : 'uName'

					}, {
						id : 'ApplyMoney',
						header : '申请额度',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ApplyMoney'
						
					},{
						id : 'ApplyDate',
						header : '申请时间',
						width : 80,
						editable : false,
						dataIndex : 'ApplyDate'
					},{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						align : 'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "新建") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else if (sf == "提交"){
							return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
						}else {
							return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'ChkState',
						header : '审核状态',
						width : 80,
						editable:false,
						dataIndex : 'ChkState'

					},{
						id : 'Desc',
						header : '资金申请说明',
						width : 200,
						editable:false,
						//hidden:true,
						dataIndex : 'Desc'

					},{
						id : 'budgco',
						header : '预算结余',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 80,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'FundTotal',
						header : '项目总预算',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'FundTotal'

					},{
						id : 'ReqMoney',
						header : '申请资金总额',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ReqMoney'

					},{
						id : 'ActPayWait',
						header : '在途报销额',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ActPayWait'
					},{
						id : 'ActPayMoney',
						header : '已执行预算',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ActPayMoney'

					},{
						id : 'IsCurStep',
						header : '当前步骤',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsCurStep'

					},{
						id : 'projDr',
						header : 'projid',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'projDr'

					},{
						id : '登录人步奏号',
						header : 'ChkStep',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ChkStep'

					},{
						id : 'StepNO',
						header : '当前步奏号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'StepNO'

					},{
						id : 'maxno',
						header : '最大审批号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'maxno'

					},{
						id : 'chkStepNO',
						header : '审批顺序号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'chkStepNO'

					}],
					xtype : 'grid',
					loadMask : true,
					//viewConfig : {forceFit : true},
					tbar : ['-',findButton,'-',detailButton,'-']

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:12,userdr:userdr}});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	
	if (columnIndex == 6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name		 = records[0].get("Name");
		//detailFun(FundBillDR,Name);
	}
	
	if (columnIndex == 13) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("Code");
		var Name		 = records[0].get("Name");
		stateFun(FundBillDR,Code,Name);
	}

	if (columnIndex == 3) {		
		var records = itemGrid.getSelectionModel().getSelections();
		var sf = records[0].get("IsCurStep");
		var cf = records[0].get("BillState");
		var chk = records[0].get("ChkStep");
		var no = records[0].get("StepNO");
		var maxno = records[0].get("maxno");
		var chkStepNO = records[0].get("chkStepNO");
		if ((sf == "是")&&(cf=="提交")&&(chk==no)&&(maxno==chkStepNO)) {
			var records = itemGrid.getSelectionModel().getSelections();
			var IsCurStep = records[0].get("IsCurStep");
			var rowid = records[0].get("rowid");
			//alert("abc");
			checkFun(rowid);
		}else if(cf!=="提交"){
			Ext.Msg.show({title:'错误',msg:'只有提交状态的单据需要审核！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}else if(maxno!=chkStepNO){
			Ext.Msg.show({title:'错误',msg:'不具有审核权限！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	}
});



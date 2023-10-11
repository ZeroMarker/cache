/**
*审核按钮权限说明
*1.按钮可用：
*	有审核权限、当前审核人是登录人
*2.其他不可用
**/
var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgauditfundapplyexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :commonboxUrl+'?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '申请年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
//////////////////  科室名称  ////////////////////////

var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=dept', 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


/////////////////  申请人  ////////////////////////
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=username&flag=2',
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			fieldLabel : '申请人',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

///////////////// 申请单号 //////////////
var billcodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['billcode', 'billcode'])
		});

billcodeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=billcodeList'+'&userdr='+userdr,
						method : 'POST'
					});
		});

var billcode = new Ext.form.ComboBox({
			fieldLabel : '申请单号',
			store : billcodeDs,
			displayField : 'billcode',
			valueField : 'billcode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

/////////////////// 查询按钮 //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var year  = yearCombo.getValue();
        var dept  = deptCombo.getValue();
	    var user  = userCombo.getValue();
	    var bcode = billcode.getValue();
	    
		itemGrid.load({params:{start:0,limit:25,year:year,userdr:userdr,dept:dept,user:user,bcode:bcode}});
	}
});


var itemGrid = new dhc.herp.Grid({
		    title: '一般支出借款管理审核',
		    region : 'north',
		    url: 'herp.budg.budgauditfundapplyexe.csp',
			fields : [{
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'select',
						header : '选择',
						editable:false,
						width : 70,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
	                    
	                    var checkstat = "";
						var iscur = record.data['IsCurStep'];
						var step = record.data['ChkStep'];
						var sc = record.data['StepNOC'];
						var sf = record.data['StepNOF'];
                        billstate = record.data['BillState'];
                        if ((sc==sf)&&(iscur==1)&&(billstate=="提交")) {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>审核</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand">审核</span>';
						}},
						dataIndex : 'select'
					},{
						id : 'filedesc',
						header : '附件',
						editable:false,
						width : 120,
						dataIndex : 'filedesc',
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			 			}
					},{
						id : 'CompName',
						header : '医疗单位',
						width : 100,
						editable:false,
						dataIndex : 'CompName'

					},{
						id : 'YearMonth',
						header : '年月',
						width : 80,
						editable:false,
						dataIndex : 'YearMonth'

					},{
						id : 'BillCode',
						header : '申请单号',
						editable:false,
						width : 120,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:purple;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'BillCode'

					}, {
						id : 'Dept',
						header : '申请科室',
						editable:false,
						width : 120,
						dataIndex : 'Dept',
						hidden : false
					}, {
						id : 'User',
						header : '申请人',
						editable:false,
						width : 120,
						dataIndex : 'User'
					},{
						id : 'ReqPay',
						header : '申请额度',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
                        align:'right',
						dataIndex : 'ReqPay'
					}, {
						id : 'ReqPayRes',
						header : '审批额度',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ReqPayRes'
						
					},{
						id : 'BillDate',
						header : '申请时间',
						width : 120,
						editable:false,
						dataIndex : 'BillDate'

					},{
						id : 'ChkResult',
						header : '审核状态',
						width : 120,
						editable:false,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
  							return '<span style="color:black;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'ChkResult'

					},{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "新建") {
							return '<span style="color:blue;cursor:hand">'+value+'</span>';
						} else {
							return '<span style="color:gray;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'Desc',
						header : '资金申请说明',
						width : 120,
						editable:false,
						dataIndex : 'Desc'

					},{
						id : 'BudgBal',
						header : '审批后结余',
						//xtype:'numbercolumn',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'BudgBal'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
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
						id : 'CheckNo',
						header : '支票号',
						width : 100,
						editable:false,
						dataIndex : 'CheckNo'

					},{
						id : 'CheckDate',
						header : '支票发放日期',
						width : 120,
						editable:false,
						dataIndex : 'CheckDate'

					},{
						id : 'CheckUDR',
						header : '发放人',
						width : 100,
						editable:false,
						dataIndex : 'CheckUDR'

					},{
						id : 'ChkStep',
						header : '当前审核步骤',
						width : 100,
						editable:false,
						dataIndex : 'ChkStep'

					},{
						id : 'StepNOC',
						header : '当前审批顺序号',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'StepNOC'

					},{
						id : 'StepNOF',
						header : '审批顺序号',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'StepNOF'
					},{
						id : 'IsCurStep',
						header : '是否当前审批',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsCurStep'
					},{
						id : 'deptID',
						header : '申请科室ID',
						editable:false,
						width : 60,
						hidden:true,
						dataIndex : 'deptID'
					},{
						id : 'CheckDR',
						header : '审批流名称',
						width : 100,
						editable:false,
						dataIndex : 'CheckDR'
					}, {
						id : 'audname',
						header : '归口科室',
						editable:false,
						width : 120,
						dataIndex : 'audname',
						hidden:false
					}, {
						id : 'audeprdr',
						header : '归口科室dr',
						editable:false,
						width : 120,
						dataIndex : 'audeprdr',
						hidden:true
					}, {
						id : 'ChkResult1',
						header : '审核状态',
						editable:false,
						width : 60,
						dataIndex : 'ChkResult1',
						hidden:true
					}, {
						id : 'Checkdr',
						header : '审批流ID',
						editable:false,
						width : 60,
						dataIndex : 'Checkdr',
						hidden:true
					}, {
						id : 'UserDR',
						header : '申请人ID',
						editable:false,
						width : 60,
						dataIndex : 'UserDR',
						hidden:true
					}],

					tbar:['申请年度:',yearCombo,'-','科室:',deptCombo,'-','申请人:',userCombo,'-','申请单号:',billcode,'-',findButton]
                                               
						
		});

   	itemGrid.btnAddHide();    //隐藏增加按钮
   	itemGrid.btnSaveHide();   //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
		params:{start:0, limit:25,userdr:userdr},

		callback:function(record,options,success ){

		itemGrid.fireEvent('rowclick',this,0);
	}
});



// 单击单据状态 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	// alert(columnIndex);
	
	if (columnIndex == 12) 
	{
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var BillCode     = records[0].get("BillCode");
		var Dept		 = records[0].get("Dept");
		stateFun(FundBillDR,BillCode,Dept);

	}
	
	if (columnIndex == 2) {  /// 审核步骤
                	
		var records = itemGrid.getSelectionModel().getSelections();
		
		var rowid      = records[0].get("rowid");
        
        var iscur = records[0].get('IsCurStep');
		var step = records[0].get('ChkStep');
		var sc = records[0].get('StepNOC');
		var sf = records[0].get('StepNOF');
        billstate = records[0].get('BillState');
        ChkselfResult = records[0].get('ChkResult1');
        
        if((sc==sf)&&(iscur==1)&&(billstate=="提交"))
        {
           auditFun(rowid);
        }else if((billstate=="完成")||(ChkselfResult==2)){
	       Ext.Msg.show({title:'错误',msg:"不可重复审核！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR}); 
        }else if(sc!==sf){
	       Ext.Msg.show({title:'错误',msg:"不是权限指定的审核人！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});   
        }else if(iscur!==1){
	       Ext.Msg.show({title:'错误',msg:"不是当前审核人！",buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});   
        }
	}

	
//单击申请单号单元格
   if (columnIndex == 6) {
          EditFun(itemGrid);
	}
//附件图片的显示
	if (columnIndex == 3) {

		var records = itemGrid.getSelectionModel().getSelections();
		var rowid   = records[0].get("rowid");
		projuploadFun(rowid);
		
	}			
/*// 显示审批流	
	if (columnIndex == 5) {
          auditshowFun();
	}
 */
	
});



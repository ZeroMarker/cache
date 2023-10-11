var userid = session['LOGON.USERID'];
// 年度///////////////////////////////////
var projUrl = 'herp.budg.costclaimexamiexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '申请年月',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
//////科室名称

var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList', 

					//	method : 'POST'

                             ///   url:'herp.budg.costclaimexamiexe.csp?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
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
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//////申请人
var applyerDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

applyerDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var applyerCombo = new Ext.form.ComboBox({
			fieldLabel : '申请人',
			store : applyerDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

//////查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var year    = yearCombo.getValue();
            var dept    = deptCombo.getValue();
	    var applyer = applyerCombo.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,userid:userid,dept:dept,applyer:applyer}});
	}
});

//////添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加',
        tooltip:'添加',        
        iconCls:'add',
	handler:function(){
	addFun();
	}
	
});


///////删除按钮
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'add',
	handler:function(){
	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
		var len = selectedRow.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
        rowid	=selectedRow[0].data['rowid'];
	delFun(rowid);
	}
	
});


//////撤销
var backout = new Ext.Toolbar.Button({
	text: '撤销',
        tooltip:'撤销',        
        iconCls:'add',
	handler:function(){
        var selectedRow = itemGrid.getSelectionModel().getSelections();
	var len = selectedRow.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要撤销的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
         rowid	=selectedRow[0].data['rowid'];
	backoutfun(rowid,userid);
	}
	
});

//////提交
var submit = new Ext.Toolbar.Button({
	text: '提交',
        tooltip:'提交',        
        iconCls:'add',
	handler:function(){
        var selectedRow = itemGrid.getSelectionModel().getSelections();
        var len = selectedRow.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要撤销的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});

			return;
		}
		
         rowid	=selectedRow[0].data['rowid'];
         billcodes	=selectedRow[0].data['billcode'];
	submitfun(rowid,userid,billcodes);
	}
	
});

//////附件按钮
var adjunct = new Ext.Toolbar.Button({
	text: '附件',
        tooltip:'附件',        
        iconCls:'add',
	handler:function(){
	accessoryFun();
	}
	
});


var itemGrid = new dhc.herp.Grid({
		    title: '一般支出报销审批',
		    region : 'north',
		    url: 'herp.budg.costclaimexamiexe.csp',
                   /*
                    listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if ((record.get('IsCurStep') =="0")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if (((record.get('IsCurStep') =="0")||(record.get('billstate')=="新建")) && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            },
             */
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
						var sf = record.data['IsCurStep'];
						var cf = record.data['checkStep'];
                        checkstat = record.data['checkstate'];
                        //alert(checkstat);
                        sf=cf=1;
                        if (sf==cf&&checkstat=="审批通过") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:gray;cursor:hand">审核</span>';
							
						} else {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>审核</u></span>';
						}},
						dataIndex : 'select'
					},{
						id : 'checkyearmonth',
						header : '核算年月',
						width : 80,
						editable:false,
						dataIndex : 'checkyearmonth'
					},{
						id : 'billcode',
						header : '报销单号',
						editable:false,
						width : 150,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billcode'

					}, {
						id : 'dname',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'dname',
						hidden : false
					}, {
						id : 'applyer',
						header : '申请人',
						editable:false,
						width : 120,
						dataIndex : 'applyer'

					},{
						id : 'reqpay',
						header : '报销金额',
						width : 100,
						editable:false,
                                                align:'right',
						dataIndex : 'reqpay'

					}, {
						id : 'actpay',
						header : '审批金额',
						width : 100,
						editable : false,
						align:'right',
						dataIndex : 'actpay'
						
					},{
						id : 'applydate',
						header : '申请时间',
						width : 120,
						align : 'left',
						editable:false,
						dataIndex : 'applydate'

					},{
						id : 'billstate',
						header : '单据状态',
						width : 80,
						///align : 'right',
						editable:false,
                        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
						dataIndex : 'billstate'

					},{
                        id : 'checkstate',
						header : '审核状态',
						width : 80,
						editable:false,                                  
						dataIndex : 'checkstate'

                                        },{
						id : 'applydecl',
						header : '资金申请说明',
						width : 120,
						////align : 'right',
						editable:false,
						dataIndex : 'applydecl'

					},{
						id : 'budgetsurplus',
						header : '审批后结余',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'budgetsurplus'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "预算内") {
							return '<span style="color:blue;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:red;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'IsCurStep',
						header : '当前步奏',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsCurStep'

					},{
						id : 'checkStep',
						header : '审批步骤',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'checkStep'

					},{
                        id : 'applycode',
						header : '资金申请单号',
						width : 100,
						editable:false,
						align:'right',
                        hidden:true,
						dataIndex : 'applycode'

                      }, {
						id : 'deprdr',
						header : '报销科室',
						editable:false,
						width : 120,
						dataIndex : 'deprdr',
						hidden:true
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
						id : 'CheckDR',
						header : '审批流',
						editable:false,
						width : 120,
						dataIndex : 'CheckDR',
						hidden:true
					}, {
						id : 'FundSour',
						header : '资金来源',
						editable:false,
						width : 120,
						dataIndex : 'FundSour',
						hidden:true
					}, {
						id : 'FundSourN',
						header : '资金来源',
						editable:false,
						width : 120,
						dataIndex : 'FundSourN'
					}],

						tbar:['申请年月:',yearCombo,'-','科室','-',deptCombo,'-','申请人','-',applyerCombo,'-',findButton]
                                               
						
		});

    itemGrid.btnAddHide();    //隐藏增加按钮
    itemGrid.btnSaveHide();   //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	
	params:{start:0, limit:25,userdr:userid},

	callback:function(record,options,success ){

	itemGrid.fireEvent('rowclick',this,0);
	}
});



// 单击单据状态 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	if (columnIndex == 10) {
                	
		var records = itemGrid.getSelectionModel().getSelections();
	
		var rowids  = records[0].get("rowid");
	
                billstate(rowids);


	}
//单击报销单号单元格
       else if (columnIndex == 4) {            	
                EditFun(itemGrid);
	}
       else if (columnIndex == 2) {
                var checkstat = "";	
		var records   = itemGrid.getSelectionModel().getSelections();
		var accessor  = records[0].get("accessory");
		var rowids    = records[0].get("rowid");
        var iscurrstep= records[0].get("IsCurStep");
        var checkstep = records[0].get("checkStep");
        checkstat = records[0].get("checkstate");
        iscurrstep=checkstep=1;
        if(iscurrstep==checkstep&&checkstat=="没有通过")
        {
           checkFun(rowids);
        }else{
           nocheck(rowids);
           alert("不可重复操作!");
        }
	}



});



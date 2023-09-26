CommFindFun = function() {

	//============================================================面板控件=============================================================
	if(monthDr==""){
		Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	//20090612
	var tmpUId="";
	var findCommTabProxy = new Ext.data.HttpProxy({url: incomeDatasUrl + '?action=listremain&monthDr='+monthDr});
	var tmpMonth="";
	var myAct="";
	
	var findCommTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'rowid',
			'intervalDr',
			'intervalName',
			{name:'feeDate',type:'date',dateFormat:'Y-m-d'},
			'patType',
			'itemCode',
			'itemName',
			'itemDr',
			'inItemCode',
			'inItemName',
			'fee',
			'cost',
			'fDeptCode',
			'fDeptName',
			'fDeptDr',
			'inFDeptCode',
			'inFDeptName',
			'tDeptCode',
			'tDeptName',
			'tDeptDr',
			'inTDeptCode',
			'inTDeptName',
			'patDeptCode',
			'patDeptName',
			'patDeptDr',
			'inPatDeptCode',
			'inPatDeptName',
			'inType',
			'personDr',
			'personName',
			'remark',
			{name:'inDate',type:'date',dateFormat:'Y-m-d'}
		]),
		remoteSort: true
	});

	findCommTabDs.setDefaultSort('RowId', 'Desc');

	var editDataTypesButton = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改选择的收入数据',        
		iconCls: 'add',
		handler: function(){editFun(findCommTabDs,formPanel,findCommTabPagingToolbar);}
	});
	var delDataTypesButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的收入数据表',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(findCommTabDs,formPanel,findCommTabPagingToolbar);}
	});
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
			{
				header: '类型',
				dataIndex: 'patType',
				width: 40,
				align: 'left',
				sortable: true
			},
			{
				header: '项目代码',
				dataIndex: 'itemCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '项目名称',
				dataIndex: 'itemName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '内部项目名称',
				dataIndex: 'inItemName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '金额',
				dataIndex: 'fee',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '开单部门代码',
				dataIndex: 'fDeptCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '开单部门名称',
				dataIndex: 'fDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '内部开单部门名称',
				dataIndex: 'inFDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '接收部门代码',
				dataIndex: 'tDeptCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '接收部门名称',
				dataIndex: 'tDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '内部接收部门名称',
				dataIndex: 'inTDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '病人部门代码',
				dataIndex: 'patDeptCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '病人部门名称',
				dataIndex: 'patDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '内部病人部门名称',
				dataIndex: 'inPatDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '录入类型',
				dataIndex: 'inType',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '备注',
				dataIndex: 'remark',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '采集日期',
				dataIndex: 'inDate',
				width: 70,
				renderer:formatDate,
				align: 'left',
				sortable: true
			}
		]);
		
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 25,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B['monthdr']=monthDr;

				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}

		});


		//==========================================================面板==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: findCommTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:[editDataTypesButton,delDataTypesButton],
			bbar: findCommTabPagingToolbar
		});
		//============================================================窗口========================================================

		
		var window = new Ext.Window({
			title: '未刷新数据',
			width: 700,
			height:500,
			minWidth: 1100,
			minHeight:500,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				{
					text: '确定',
					//handler: function(){window.close();}	//zhw 20160821 修改
					handler: function(){Ext.Ajax.request({
							url:incomeDatasUrl+'?action=List&monthDr='+monthDr});
							incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
							var winclosed=window.close();}
					
				}]
			});

			window.show();
			findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize, monthDr:monthDr}});
		};
CommFindIncomeFun = function() {

	//============================================================面板控件=============================================================
	if(monthDr==""){
		Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	//20090612
	var tmpUId="";
	var findCommTabProxy = new Ext.data.HttpProxy({url: incomeDatasUrl + '?action=listIncome'});
	var tmpMonth="";
	var myAct="";
	
	var findCommTabDs = new Ext.data.Store({
		proxy: findCommTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'patType',
			'counts',
			'fees'
		]),
		remoteSort: true
	});

	findCommTabDs.setDefaultSort('patType', 'Desc');

	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
			{
				header: '类型',
				dataIndex: 'patType',
				width: 80,
				align: 'left',
				sortable: true
			},
			{
				header: '条数',
				dataIndex: 'counts',
				width: 80,
				align: 'left',
				sortable: true
			},
			{
				header: '金额',
				dataIndex: 'fees',
				width: 100,
				align: 'left',
				sortable: true
			}
		]);
		
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 25,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}共计{2}',
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
			//tbar:[editDataTypesButton,delDataTypesButton],    //20150716  zjw 屏蔽
			bbar: findCommTabPagingToolbar
		});
		//============================================================窗口========================================================

		
		var window = new Ext.Window({
			title: '收入查询',
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
					text: '取消',
					handler: function(){window.close();}
				}]
			});

			window.show();
			findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize, monthDr:monthDr}});
		};
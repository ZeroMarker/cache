CommFindIncomeFun = function() {

	//============================================================���ؼ�=============================================================
	if(monthDr==""){
		Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				header: '����',
				dataIndex: 'patType',
				width: 80,
				align: 'left',
				sortable: true
			},
			{
				header: '����',
				dataIndex: 'counts',
				width: 80,
				align: 'left',
				sortable: true
			},
			{
				header: '���',
				dataIndex: 'fees',
				width: 100,
				align: 'left',
				sortable: true
			}
		]);
		
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 25,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}����{2}',
			emptyMsg: "û������",
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


		//==========================================================���==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: findCommTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[editDataTypesButton,delDataTypesButton],    //20150716  zjw ����
			bbar: findCommTabPagingToolbar
		});
		//============================================================����========================================================

		
		var window = new Ext.Window({
			title: '�����ѯ',
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
					text: 'ȡ��',
					handler: function(){window.close();}
				}]
			});

			window.show();
			findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize, monthDr:monthDr}});
		};
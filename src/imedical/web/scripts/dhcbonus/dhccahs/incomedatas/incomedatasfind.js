CommFindFun = function() {

	//============================================================���ؼ�=============================================================
	if(monthDr==""){
		Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		text: '�޸�',
		tooltip: '�޸�ѡ�����������',        
		iconCls: 'add',
		handler: function(){editFun(findCommTabDs,formPanel,findCommTabPagingToolbar);}
	});
	var delDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ�����������ݱ�',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(findCommTabDs,formPanel,findCommTabPagingToolbar);}
	});
	var findCommTabCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
			{
				header: '����',
				dataIndex: 'patType',
				width: 40,
				align: 'left',
				sortable: true
			},
			{
				header: '��Ŀ����',
				dataIndex: 'itemCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '��Ŀ����',
				dataIndex: 'itemName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '�ڲ���Ŀ����',
				dataIndex: 'inItemName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '���',
				dataIndex: 'fee',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '�������Ŵ���',
				dataIndex: 'fDeptCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '������������',
				dataIndex: 'fDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '�ڲ�������������',
				dataIndex: 'inFDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '���ղ��Ŵ���',
				dataIndex: 'tDeptCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '���ղ�������',
				dataIndex: 'tDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '�ڲ����ղ�������',
				dataIndex: 'inTDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '���˲��Ŵ���',
				dataIndex: 'patDeptCode',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '���˲�������',
				dataIndex: 'patDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '�ڲ����˲�������',
				dataIndex: 'inPatDeptName',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '¼������',
				dataIndex: 'inType',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '��ע',
				dataIndex: 'remark',
				width: 100,
				align: 'left',
				sortable: true
			},
			{
				header: '�ɼ�����',
				dataIndex: 'inDate',
				width: 70,
				renderer:formatDate,
				align: 'left',
				sortable: true
			}
		]);
		
		var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 25,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
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
			tbar:[editDataTypesButton,delDataTypesButton],
			bbar: findCommTabPagingToolbar
		});
		//============================================================����========================================================

		
		var window = new Ext.Window({
			title: 'δˢ������',
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
					text: 'ȷ��',
					//handler: function(){window.close();}	//zhw 20160821 �޸�
					handler: function(){Ext.Ajax.request({
							url:incomeDatasUrl+'?action=List&monthDr='+monthDr});
							incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
							var winclosed=window.close();}
					
				}]
			});

			window.show();
			findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize, monthDr:monthDr}});
		};
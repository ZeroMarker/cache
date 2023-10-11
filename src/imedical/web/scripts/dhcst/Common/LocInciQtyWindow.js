	/*
	*��ʾgrid����������ʾ���ҿ�������п��ҿ������
	*Creator:LiangQiang
	*CreatDate:2013-11-20
	*/
function ShowAllLocStkQtyWin(e,grid,ShowInCellIndex,desc,inci)
{
       	Ext.QuickTips.init();
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		//�������ҿ����Ϣ
		// ����·��
		var AllLocStkUrl ='dhcst.drugutil.csp?actiontype=GetAllLocStk&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var AllLocStkProxy = new Ext.data.HttpProxy({
					url : AllLocStkUrl,
					method : "POST"
				});
		// ָ���в���
		var AllLocStkFields = [ "Loc","Uom","StkQty","MaxQty","MinQty","RepQty"];
				
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var AllLocStkReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Loc",
					fields : AllLocStkFields
				});
		var AllLocStkStore = new Ext.data.Store({
					proxy : AllLocStkProxy ,
					reader : AllLocStkReader
				});

		var AllLocStkNm = new Ext.grid.RowNumberer();
		var AllLocStkCm = new Ext.grid.ColumnModel([AllLocStkNm, {
					
					header : $g("����"),
					dataIndex : 'Loc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g('��λ'),
					dataIndex : 'Uom',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : $g('���'),
					dataIndex : 'StkQty',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('�������'),
					dataIndex : 'MaxQty',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('�������'),
					dataIndex : 'MinQty',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('��׼���'),
					dataIndex : 'RepQty',
					width : 80,
					align : 'left',
					sortable : true
				}]);
		AllLocStkCm.defaultSortable = false;

		var AllLocStkGrid = new Ext.grid.GridPanel({
			        id:'AllLocStkGrid',
					region : 'center',
					title : '',
					cm : AllLocStkCm,
					store : AllLocStkStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					height:250,
					layout : 'fit',
					sm : new Ext.grid.RowSelectionModel({singleSelect:true})

				});

			AllLocStkStore.removeAll();
		
            Ext.destroy(this.win); //ע������
			var cellIndex = grid.getView().findCellIndex(e.getTarget());
			if (cellIndex!=ShowInCellIndex)
			{
				return;

			}

			this.win = new Ext.Window({
							id:'alllocwin',
							title : $g('�����ҿ��'),
							width : 650,
							//autoHeight: true,
							//layout : 'fit',
							height:250,
							border : false,
							closeAction: 'close',
							closable:false,
							items:[AllLocStkGrid]
			})

            Ext.getCmp("alllocwin").setTitle(desc);
            if (inci)
			{
				AllLocStkStore.load({params:{start:0,limit:200,Inci:inci}});
			}
			//��ʾ�����λ��
			//alert(AllLocStkGrid.getSize().width);
			this.win.setPosition(e.xy[0],e.xy[1]-260); 
			//this.win.show.defer(100,this.win); 
			this.win.show();
			//��2����ʾ�Ĵ����Զ��ر�  
			//this.win.close.defer(2000,this.win);
			//this.win.hide.defer(5000,this.win);

			
}

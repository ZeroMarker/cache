	/*
	*显示grid悬浮窗体显示科室库存项所有科室库存数量
	*Creator:LiangQiang
	*CreatDate:2013-11-20
	*/
function ShowAllLocStkQtyWin(e,grid,ShowInCellIndex,desc,inci)
{
       	Ext.QuickTips.init();
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		//其他科室库存信息
		// 访问路径
		var AllLocStkUrl ='dhcst.drugutil.csp?actiontype=GetAllLocStk&start=&limit=';
		// 通过AJAX方式调用后台数据
		var AllLocStkProxy = new Ext.data.HttpProxy({
					url : AllLocStkUrl,
					method : "POST"
				});
		// 指定列参数
		var AllLocStkFields = [ "Loc","Uom","StkQty","MaxQty","MinQty","RepQty"];
				
		// 支持分页显示的读取方式
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
					
					header : $g("科室"),
					dataIndex : 'Loc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g('单位'),
					dataIndex : 'Uom',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : $g('库存'),
					dataIndex : 'StkQty',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('库存上限'),
					dataIndex : 'MaxQty',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('库存下限'),
					dataIndex : 'MinQty',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('标准库存'),
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
		
            Ext.destroy(this.win); //注销窗体
			var cellIndex = grid.getView().findCellIndex(e.getTarget());
			if (cellIndex!=ShowInCellIndex)
			{
				return;

			}

			this.win = new Ext.Window({
							id:'alllocwin',
							title : $g('各科室库存'),
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
			//显示窗体的位置
			//alert(AllLocStkGrid.getSize().width);
			this.win.setPosition(e.xy[0],e.xy[1]-260); 
			//this.win.show.defer(100,this.win); 
			this.win.show();
			//过2秒显示的窗体自动关闭  
			//this.win.close.defer(2000,this.win);
			//this.win.hide.defer(5000,this.win);

			
}

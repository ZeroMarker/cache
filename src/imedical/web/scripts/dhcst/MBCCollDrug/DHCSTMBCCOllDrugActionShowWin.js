	/*
	*显示grid悬浮窗体显示处方历次更新操作
	*Creator:wyx
	*CreatDate:2014-10-15
	*/
function ShowAllMBCAcrtionWin(e,grid,ShowInCellIndex,Presc,MBCid)
{
       	Ext.QuickTips.init();
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		//其他科室库存信息
		// 访问路径
		var AllPreMBCUrl ='dhcst.mbccolldrugaction.csp?action=GetAllPrescMBC&start=&limit=';
		// 通过AJAX方式调用后台数据
		var AllPreMBCProxy = new Ext.data.HttpProxy({
					url : AllPreMBCUrl,
					method : "POST"
				});
		// 指定列参数
		var AllPreMBCFields = ["MBCItmId","PatLoc","PatNo","PatName","Prescno","State","User","UDate","UTime"];
				
		// 支持分页显示的读取方式
		var AllPreMBCReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "MBCItmId",
					fields : AllPreMBCFields
				});
		var AllPreMBCStore = new Ext.data.Store({
					proxy : AllPreMBCProxy ,
					reader : AllPreMBCReader
				});

		var AllPreMBCNm = new Ext.grid.RowNumberer();
		var AllPreMBCCm = new Ext.grid.ColumnModel([AllPreMBCNm, {
        	header:"rowid",
        	dataIndex:'MBCId',
        	width:100,
        	align:'left',
        	sortable:true,
        	hidden:true
	 }, {
        	header:"科室",
        	dataIndex:'PatLoc',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"登记号",
        	dataIndex:'PatNo',
        	width:80,
        	align:'left',
        	sortable:true,
        	hidden:true
	 },{
        	header:"患者姓名",
        	dataIndex:'PatName',
        	width:80,
        	align:'left',
        	sortable:true,
        	hidden:true
	 },{
        	header:"处方号",
        	dataIndex:'Prescno',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"状态",
        	dataIndex:'State',
        	width:80,
        	align:'left',
        	sortable:true
	 },{
        	header:"操作人",
        	dataIndex:'User',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"操作日期",
        	dataIndex:'UDate',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"操作时间",
        	dataIndex:'UTime',
        	width:100,
        	align:'left',
        	sortable:true
	 }
	 ]);
		AllPreMBCCm.defaultSortable = false;

		var AllPreMBCGrid = new Ext.grid.GridPanel({
			        id:'AllPreMBCGrid',
					region : 'center',
					title : '',
					cm : AllPreMBCCm,
					store : AllPreMBCStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					height:250,
					layout : 'fit',
					sm : new Ext.grid.RowSelectionModel({singleSelect:true})

				});

			AllPreMBCStore.removeAll();
		
            Ext.destroy(this.win); //注销窗体
			var cellIndex = grid.getView().findCellIndex(e.getTarget());
			if (cellIndex!=ShowInCellIndex)
			{
				return;

			}

			this.win = new Ext.Window({
							id:'allprembc',
							title : '处方历史操作',
							width : 800,
							//autoHeight: true,
							//layout : 'fit',
							height:250,
							border : false,
							closeAction: 'close',
							closable:false,
							items:[AllPreMBCGrid]
			})

            Ext.getCmp("allprembc").setTitle(Presc);
            if (MBCid)
			{
				AllPreMBCStore.load({params:{start:0,limit:200,MBCid:MBCid}});
			}
			//显示窗体的位置
			this.win.setPosition(e.xy[0],e.xy[1]-220); 
			this.win.show();
			//过2秒显示的窗体自动关闭  
			//this.win.close.defer(2000,this.win);
			//this.win.hide.defer(5000,this.win);

			
}

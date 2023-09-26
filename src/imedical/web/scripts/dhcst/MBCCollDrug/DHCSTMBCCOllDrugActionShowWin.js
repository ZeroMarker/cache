	/*
	*��ʾgrid����������ʾ�������θ��²���
	*Creator:wyx
	*CreatDate:2014-10-15
	*/
function ShowAllMBCAcrtionWin(e,grid,ShowInCellIndex,Presc,MBCid)
{
       	Ext.QuickTips.init();
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		//�������ҿ����Ϣ
		// ����·��
		var AllPreMBCUrl ='dhcst.mbccolldrugaction.csp?action=GetAllPrescMBC&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var AllPreMBCProxy = new Ext.data.HttpProxy({
					url : AllPreMBCUrl,
					method : "POST"
				});
		// ָ���в���
		var AllPreMBCFields = ["MBCItmId","PatLoc","PatNo","PatName","Prescno","State","User","UDate","UTime"];
				
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
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
        	header:"����",
        	dataIndex:'PatLoc',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"�ǼǺ�",
        	dataIndex:'PatNo',
        	width:80,
        	align:'left',
        	sortable:true,
        	hidden:true
	 },{
        	header:"��������",
        	dataIndex:'PatName',
        	width:80,
        	align:'left',
        	sortable:true,
        	hidden:true
	 },{
        	header:"������",
        	dataIndex:'Prescno',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"״̬",
        	dataIndex:'State',
        	width:80,
        	align:'left',
        	sortable:true
	 },{
        	header:"������",
        	dataIndex:'User',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"��������",
        	dataIndex:'UDate',
        	width:100,
        	align:'left',
        	sortable:true
	 },{
        	header:"����ʱ��",
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
		
            Ext.destroy(this.win); //ע������
			var cellIndex = grid.getView().findCellIndex(e.getTarget());
			if (cellIndex!=ShowInCellIndex)
			{
				return;

			}

			this.win = new Ext.Window({
							id:'allprembc',
							title : '������ʷ����',
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
			//��ʾ�����λ��
			this.win.setPosition(e.xy[0],e.xy[1]-220); 
			this.win.show();
			//��2����ʾ�Ĵ����Զ��ر�  
			//this.win.close.defer(2000,this.win);
			//this.win.hide.defer(5000,this.win);

			
}

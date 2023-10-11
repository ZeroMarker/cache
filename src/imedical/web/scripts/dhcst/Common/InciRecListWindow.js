	/*
	*��ʾgrid����������ʾ���ҿ�������п��ҿ������
	*Creator:LiangQiang
	*CreatDate:2013-11-20
	*
	*/
function ShowInciRecListWin(e,grid,ShowInCellIndex,desc,inci,phaloc)
{
       	Ext.QuickTips.init();
	    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
        
		//�������ҿ����Ϣ
		// ����·��
		var InciRecListUrl ='dhcst.drugutil.csp?actiontype=GetInciRecList&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var InciRecListProxy = new Ext.data.HttpProxy({
					url : InciRecListUrl,
					method : "POST"
				});
		// ָ���в���
		var InciRecListFields = [ "Rp","BatNo","ExpDate","Vendor","Manf","RecDate","Ingri","LocInciQtyUom"];
				
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var InciRecListReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Ingri",
					fields : InciRecListFields
				});
		var InciRecListStore = new Ext.data.Store({
					proxy : InciRecListProxy ,
					reader : InciRecListReader
				});

		var InciRecListNm = new Ext.grid.RowNumberer();
		var InciRecListCm = new Ext.grid.ColumnModel([InciRecListNm, {
					
					header : "����",
					dataIndex : 'RecDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '����',
					dataIndex : 'Rp',
					width : 70,
					align : 'right',
					sortable : true
				}, {
					header : '����',
					dataIndex : 'BatNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : 'Ч��',
					dataIndex : 'ExpDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '��Ӫ��ҵ',
					dataIndex : 'Vendor',
					width : 130,
					align : 'left',
					sortable : true
				}, {
					header : '������ҵ',
					dataIndex : 'Manf',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : 'Ingri',
					dataIndex : 'Ingri',
					width : 90,
					align : 'left',
				    hidden : true,
					sortable : true
				}]);
		InciRecListCm.defaultSortable = false;

		var InciRecListGrid = new Ext.grid.GridPanel({
			        id:'InciRecListGrid',
					region : 'center',
					title : '',
					cm : InciRecListCm,
					store : InciRecListStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					margins:'3 3 3 3',
					sm : new Ext.grid.RowSelectionModel({singleSelect:true})

				});

			InciRecListStore.removeAll();
		
            Ext.destroy(this.win); //ע������
			var cellIndex = grid.getView().findCellIndex(e.getTarget());
			if (cellIndex!=ShowInCellIndex)
			{
				return;
			}
			if (inci=="")
			{
				return;
			}

			this.win = new Ext.Window({
							id:'incireclistwin',
							title : '�����ҿ��',
							width : 600,
							//autoHeight: true,
							layout : 'fit',
							height:250,
							border : false,
							closeAction: 'close',
							closable:false,
							items:[InciRecListGrid]
			})
			InciRecListGrid.getView().on('refresh',function(Grid){
				 if (InciRecListGrid.getStore().getCount()>0)
				 {
					var InciRecListRowData = InciRecListStore.getAt(0);
					var LocInciQtyUom = InciRecListRowData.get("LocInciQtyUom"); 
	   	 			var TmpDescInfo=desc+"�������������:"+LocInciQtyUom
	   	 			Ext.getCmp("incireclistwin").setTitle(TmpDescInfo);
				 }
			})
            Ext.getCmp("incireclistwin").setTitle(desc);
            if (inci)
			{
				InciRecListStore.load({params:{start:0,limit:200,Inci:inci,LocId:phaloc}});
				
				
			}
			
			//��ʾ�����λ��
			this.win.setPosition(e.xy[0],e.xy[1]-260); 
			//this.win.show.defer(100,this.win); 
			this.win.show();
			//��2����ʾ�Ĵ����Զ��ر�  
			//this.win.close.defer(2000,this.win);
			//this.win.hide.defer(5000,this.win);
			
}

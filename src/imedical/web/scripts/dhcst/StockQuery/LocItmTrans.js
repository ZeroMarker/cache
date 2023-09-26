// /����: ̨����Ϣ��ѯ������ѯ������ã�
// /����: ̨����Ϣ��ѯ������ѯ������ã�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.10

function TransQuery(Incil,StkDate,IncInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
	
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo=replaceAll(IncInfo," ","��"); //��ȫ�ǿո�����ǿո񣬷�ֹlabelչʾ��ʱ���Զ�����ǿո���˵�
	
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 200,
			value : new Date()
	});

	// ��������
	var EndDate = new Ext.ux.DateField({
			fieldLabel : '��������',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 200,
			value : StkDate
	});
	
    var Inc=new Ext.form.Label({
    	text:IncInfo,
		align:'center',
		cls: 'classImportant'
    })
	
	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯҩƷ̨��',
				iconCls : 'page_find',
				handler : function() {
					searchData();
				}
			});
			
	/**
	 * ��ѯ����
	 */
	function searchData() {
		// ��ѡ����
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", "����������ѡ��ĳһ����¼�鿴��̨����Ϣ��");
			return;
		}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var size=StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({params:{start:0,limit:size,incil:Incil,startdate:StartDate,enddate:EndDate}});
	}

	
	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// ָ���в���
	//ҵ������^����^��λ^�ۼ�^����^��������(������λ)^��������(����λ)^��������(������λ)
	//^��������(����λ)^�������(����)^�������(�ۼ�)^�����^������^ժҪ
	//^��ĩ���(����)^��ĩ���(�ۼ�)^��Ӧ��^����^������	
	var fields = ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "TrId",
				fields : fields
			});
	// ���ݼ�
	var DetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����",
				dataIndex : 'TrDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '����Ч��',
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'PurUom',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 65,
				align : 'right',
				
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 65,
				
				align : 'right'
			}, {
				header : "��������",
				dataIndex : 'EndQtyUom',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'TrQtyUom',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'TrNo',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : "������Ϣ",
				dataIndex : 'TrAdm',
				width : 65,
				align : 'right',
				sortable : true
			}, {
				header : "ҵ������",
				dataIndex : 'TrMsg',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "������(����)",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "������(�ۼ�)",
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',				
				sortable : true
			}, {
				header : "������",
				dataIndex : 'OperateUser',
				width : 65,
				align : 'left',				
				sortable : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : DetailInfoStore,
			pageSize : PageSize,
			displayInfo : true,
			displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			emptyMsg : "No results to display",
			prevText : "��һҳ",
			nextText : "��һҳ",
			refreshText : "ˢ��",
			lastText : "���ҳ",
			firstText : "��һҳ",
			beforePageText : "��ǰҳ",
			afterPageText : "��{0}ҳ",
			emptyMsg : "û������",
			doLoad:function(C){
				var B={},
				A=this.getParams();
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B[A.sort]='Rowid';
				B[A.dir]='desc';
				B['incil']=Incil;
				B['startdate']=Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();
				B['enddate']=Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}
		});
	var DetailInfoGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				region:'center',
				cm : DetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : DetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar : StatuTabPagingToolbar
			});
	var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			height : 150,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [searchBT],		
			items : [{
				autoHeight : true,
					items : [{
						xtype : 'fieldset',
						title : '��ѯ����',
						autoHeight : true,
						items : [{
							layout : 'column',
							items : [
								{columnWidth:.4,layout:'form',items:[StartDate]},
								{columnWidth:.4,layout:'form',items:[EndDate]}
							]}]
						},Inc]
			}]	
		});

	var window = new Ext.Window({
				title : '̨����Ϣ',
				width : 800,
				height : 600,
				layout:'border',
				items : [HisListTab, DetailInfoGrid]
			});
	window.show();
	
}
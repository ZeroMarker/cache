// /����: ����׷����Ϣ��ѯ������ѯ������ã�
// /����: ����׷����Ϣ��ѯ������ѯ������ã�
// /��д�ߣ�hulihua
// /��д����: 2016.01.10

function BatTransQuery(Inclb,StkDate,InclbInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
	var HospId=session['LOGON.HOSPID'];
	
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	InclbInfo=replaceAll(InclbInfo," ","��"); //��ȫ�ǿո�����ǿո񣬷�ֹlabelչʾ��ʱ���Զ�����ǿո���˵�
	
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
	
    var Inclbinfo=new Ext.form.Label({
    	text:'',
    	id:'Inclbinfo',
		align:'center',
		cls: 'classImportant'
    })
    Ext.getCmp('Inclbinfo').setText(InclbInfo,false)
    // ��水ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '���ΪExcel',
				iconCls : 'page_excel',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(DetailInfoGrid);
				}
			});
	
	// ������ť
	var SearchBT = new Ext.Toolbar.Button({
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
		if (Inclb == null || Inclb.length <= 0) {
			Msg.info("warning", "�������ν���ѡ��ĳһ���μ�¼�鿴��׷����Ϣ��");
			return;
		}
		
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var size=StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({params:{start:0,limit:size,inclb:Inclb,startdate:StartDate,enddate:EndDate,hospId:HospId}});
	}

	
	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmBatTransDetail&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// ָ���в���
	//ҵ��ID^ҵ������^ժҪ^��������^��������^����(��浥λ)^�ۼ�(��浥λ)^�������(����)^�������(�ۼ�)
	//�����^������^������^��ע
	var fields = ["TrId","TrDate","TrMsg","TrQtyUom","EndQtyUom","PurUomRp","PurUomSp","TrRpAmt", "TrSpAmt"
			,"TrNo","TrAdm","TrMark","TrQtyB","OperateUser","EndRpAmt","EndSpAmt"];
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
				width : 130,
				align : 'left',
				sortable : true
			}, {
				header : "ժҪ",
				dataIndex : 'TrMsg',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'TrQtyUom',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'EndQtyUom',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'PurUomRp',
				width : 80,
				
				align : 'right'
			}, {
				header : "�ۼ�",
				dataIndex : 'PurUomSp',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'TrRpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'TrSpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "������۽��",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�����ۼ۽��",
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'TrNo',
				width : 180,
				align : 'right',
				sortable : true
			}, {
				header : "������ز���(��)",
				dataIndex : 'TrAdm',
				width : 120,
				align : 'right',
				sortable : true
			},{
				header : "������",
				dataIndex : 'OperateUser',
				width : 65,
				align : 'left',				
				sortable : true
			},{
				header : "��ע",
				dataIndex : 'TrMark',
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
				B[A.sort]='TrId';
				B[A.dir]='desc';
				B['inclb']=Inclb;
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
			height : 160,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT,'-',SaveAsBT],		
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
						},Inclbinfo]
			}]	
		});

	var window = new Ext.Window({
				title : '������Ϣ׷��',
				width : 800,
				height : 600,
				layout:'border',
				items : [HisListTab, DetailInfoGrid]
			});
	window.show();
	
}
// /����: ������Ϣ��ѯ
// /����: ������Ϣ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.08

function BatchQuery(Incil,StkDate,IncInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	gStrParam="";
	
		/**
	* ȫ���滻����
	*
	* @param {}
	* str
	* @param {}
	* rgExp
	* @param {}
	* replaceStr
	*/
	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo=replaceAll(IncInfo," ","��"); //��ȫ�ǿո�����ǿո񣬷�ֹlabelչʾ��ʱ���Զ�����ǿո���˵�

	/**
	 * ��ѯ����
	 */
	function searchData() {
		// ��ѡ����
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", "����������ѡ��ĳһ����¼�鿴��������Ϣ��");
			return;
		}
		
		gStrParam=Incil+"^"+StkDate;
		
		var pageSize=StatuTabPagingToolbar.pageSize;
		BatchStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

	}

	
		var nm = new Ext.grid.RowNumberer();
		var BatchCm = new Ext.grid.ColumnModel([nm,  {
					header : "Inclb",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'BatNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "Ч��",
					dataIndex : 'ExpDate',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "���ο��",
					dataIndex : 'QtyUom',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '����(������λ)',
					dataIndex : 'BRp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "����(��װ��λ)",
					dataIndex : 'PRp',
					width : 80,
					align : 'left',
					
					sortable : true
				}]);
		BatchCm.defaultSortable = false;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=Batch&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["BatNo", "ExpDate", "QtyUom", "BRp","PRp", "Inclb"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fields
				});
		// ���ݼ�
		var BatchStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : BatchStore,
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
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var BatchGrid = new Ext.grid.GridPanel({
					cm : BatchCm,
					store : BatchStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					tbar:[{
							xtype:'label',
							text:IncInfo,
							align:'center',
							cls: 'classDiv2',
							style:{
								//font:'padding-left:12px'
							}
						}
					]
				});
	var window = new Ext.Window({
				title : '������Ϣ',
				width : 600,
				height : 600,
				layout:'fit',
				items : [ BatchGrid ]
			});
	window.show();
	//document.write( ' <font   id= "AAA "   style= "font-family:����;font-size:8pt; "> '+IncInfo+'</font> ');
	searchData();
}
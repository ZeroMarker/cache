// /����: ȫԺ����ѯ������ѯ������ã�
// /����: ȫԺ����ѯ������ѯ������ã�
// /��д�ߣ�hulihua
// /��д����: 2013.12.31

function DayTotalQuery(Incil,IncInfo) {
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
	
    var Inc=new Ext.form.Label({
    	text:IncInfo,
		align:'center',
		cls: 'classImportant'
    })
			
	/**
	 * ��ѯ����
	 */
	function searchData() {
		// ��ѡ����
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", $g("����������ѡ��ĳһ����¼�鿴��ȫԺ�����Ϣ��"));
			return;
		}
		
		var size=StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({params:{start:0,limit:size,incil:Incil}});
	}

	
	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmDayTotalDetail&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	
	// ָ���в���
	//����^��λ^����(������λ)
	var fields = ["TrId","loc", "pctuom", "qty"];
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
			},{
				header : $g('����'),
				dataIndex : 'loc',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : $g("��λ"),
				dataIndex : 'pctuom',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'qty',
				width : 120,
				align : 'right',
				sortable : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : DetailInfoStore,
			pageSize : PageSize,
			displayInfo : true,
			displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
			emptyMsg : "No results to display",
			prevText : $g("��һҳ"),
			nextText : $g("��һҳ"),
			refreshText : $g("ˢ��"),
			lastText : $g("���ҳ"),
			firstText : $g("��һҳ"),
			beforePageText : $g("��ǰҳ"),
			afterPageText : $g("��{0}ҳ"),
			emptyMsg :$g( "û������"),
			doLoad:function(C){
				var B={},
				A=this.getParams();
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B[A.sort]='Rowid';
				B[A.dir]='desc';
				B['incil']=Incil;
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
			height : 50,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			layout : 'fit', 
		    items:[Inc] 
		});

	var window = new Ext.Window({
				title : $g('ȫԺ���ҿ��'),
				width : 550,
				height : 500,
				layout:'border',
				items : [ HisListTab, DetailInfoGrid]
			});
	window.show();
	
	searchData();
	
}
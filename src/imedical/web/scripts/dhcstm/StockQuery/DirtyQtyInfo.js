// /����: ռ��������Ϣ��ѯ
// /����: ռ��������Ϣ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.17

function DirtyQtyQuery(Inclb,IncInfo) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
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
		if (Inclb == null || Inclb.length <= 0) {
			Msg.info("warning", "����������ѡ��ĳһ����¼�鿴��ռ����Ϣ��");
			return;
		}
		
		DirtyQtyStore.load({params:{Params:Inclb}});
	}

	function renderType(value){
		if(value=='T'){
			return '���ⵥ';
		}else if(value=='R'){
			return '�˻���';
		}else if(value=='C'){
			return '���ҷ��ŵ�';
		}else if(value=='D'){
			return '����';
		}
	}
	var nm = new Ext.grid.RowNumberer();
	var Cm = new Ext.grid.ColumnModel([nm,  {
			header : "Rowid",
			dataIndex : 'Rowid',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '����',
			dataIndex : 'No',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Qty',
			width : 100,
			align : 'right',
			sortable : true
		}, {
			header : "��λ",
			dataIndex : 'Uom',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'Date',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'Type',
			width : 80,
			align : 'left',
			renderer:renderType,
			sortable : true
		}]);
	Cm.defaultSortable = false;

	// ����·��
	var DspPhaUrl = DictUrl
				+ 'locitmstkaction.csp?actiontype=GetDirtyQtyInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DspPhaUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["Rowid","No", "Qty", "Uom", "Date","Type"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Rowid",
				fields : fields
			});
	// ���ݼ�
	var DirtyQtyStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});

	var DirtyQtyGrid = new Ext.ux.GridPanel({
				cm : Cm,
				store : DirtyQtyStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : new Ext.grid.CheckboxSelectionModel(),
				loadMask : true,
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
				title : 'ռ�õ�����Ϣ',
				width : 600,
				height : 600,
				modal : true,
				layout:'fit',
				items : [ DirtyQtyGrid ]
			});
	window.show();
	//document.write( ' <font   id= "AAA "   style= "font-family:����;font-size:8pt; "> '+IncInfo+'</font> ');
	searchData();
}
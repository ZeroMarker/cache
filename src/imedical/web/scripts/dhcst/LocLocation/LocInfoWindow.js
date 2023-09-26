GetLocInfoWindow = function(Input,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	var LocInfoUrl = 'dhcst.drugutil.csp?actiontype=GetLocInfoForDialog&Input='
			+ encodeURI(Input) + '&start=' + 0
			+ '&limit=' + 15;
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : LocInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["RowId", "Code", "Desc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciItem",
				fields : fields
			});
	// ���ݼ�
	var LocInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : LocInfoStore,
				pageSize : 15,
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
				emptyMsg : "û������"
			});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true,hidden:true});
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '������',
   		dataIndex: 'NotUseFlag',
   		width: 45,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var LocInfoCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "����",
				dataIndex : 'Code',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : '����',
				dataIndex : 'Desc',
				width : 400,
				align : 'left',
				sortable : true
			}]);
	LocInfoCm.defaultSortable = true;

	// ���ذ�ť
	var returnBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
				iconCls : 'page_goto',
				handler : function() {
					returnData();
				}
			});
	/**
	 * ��������
	 */
	function returnData() {
		var selectRows = LocInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ��Ҫ���ص�ҩƷ��Ϣ��");
		} else if (selectRows.length > 1) {
			Msg.info("warning", "����ֻ����ѡ��һ����¼��");
		} else {
			flg = true;
			window.close();
			
		}
		//Ext.getCmp('SearchBT').focus(); //�ܽ���궨�嵽��ѯ��ť����������Ҫ��ÿһ����ѯ��ť�϶����id��SearchBT 
		                                 // ������ò�Ҫ�ڹ����ķ�����ģ���Ϊ�������еĽ������ҩƷ�س����ǲ�ѯ�� add by myq 20140418
	}

	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '����ر�',
				iconCls : 'page_delete',
				handler : function() {
					flg = false;
					window.close();
				}
			});

	var LocInfoGrid = new Ext.grid.GridPanel({
				cm : LocInfoCm,
				store : LocInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : sm, //new Ext.grid.CheckboxSelectionModel(),
				loadMask : true,
				tbar : [returnBT, '-', closeBT],
				bbar : StatuTabPagingToolbar,
				deferRowRender : false
			});

	// ˫���¼�
	LocInfoGrid.on('rowdblclick', function() {
				returnData();
			});
	// �س��¼�
	LocInfoGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
				}
			});
if(!window){
	var window = new Ext.Window({
				title : '������Ϣ',
				width : 600,
				height : 400,
				layout : 'fit',
				plain : true,
				modal : true,
				buttonAlign : 'center',
//				autoScroll : true,
				items : LocInfoGrid,
				listeners: {
                                             
                        "show" : function () {

							LoadLocInfoStore(); //���ⵯ�����役�㶪ʧLiangQiang 2013-11-22
							
							}
                    }
			});
}
	window.show();

	window.on('close', function(panel) {
				var selectRows = LocInfoGrid.getSelectionModel()
						.getSelections();
				if (selectRows.length == 0) {
					Fn("");
				} else if (selectRows.length > 1) {
					Fn("");
				} else {
					if (flg) {
						Fn(selectRows[0]);
					} else {
						Fn("");
					}
				}
			});
    /*
	PhaOrderStore.load({
				callback : function(r, options, success) {
					if (success == false) {
						Msg.info('warning','û���κη��ϵļ�¼��');
			 	        if(window){window.close();}

					} else {
						PhaOrderGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
						row = PhaOrderGrid.getView().getRow(0);
						var element = Ext.get(row);
						if (typeof(element) != "undefined" && element != null) {
							element.focus();
						}
					}
				}
			});

	*/


	function LoadLocInfoStore()
	{
			LocInfoStore.load({
				callback : function(r, options, success) {
					if (success == false) {
						Msg.info('warning','û���κη��ϵļ�¼��');
			 	        if(window){window.close();}

					} else {
						LocInfoGrid.getSelectionModel().selectFirstRow();// ѡ�е�һ�в���ý���
						row = LocInfoGrid.getView().getRow(0);
						var element = Ext.get(row);
						if (typeof(element) != "undefined" && element != null) {
							element.focus();
						}
						var rownum=LocInfoGrid.getStore().getCount()
						if(rownum==1){
							returnData();
							}
					}
				}
			});

	}



}

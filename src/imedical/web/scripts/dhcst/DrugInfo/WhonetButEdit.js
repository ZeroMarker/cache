// WhonetButEdit.js
// ����ά��WHONET��
// hulihua 2014-09-18(��һ���±���)
function WhonetButEdit(Input, Fn){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;
	// �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	// ����·��
	var WhonetInfoUrl = DictUrl	+ 'druginfomaintainaction.csp?actiontype=GetWhonetInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : WhonetInfoUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["AntCode","AntName", "AntEName"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "whonetinfo",
				fields : fields
			});
	// ���ݼ�
	var WhonetStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	WhonetStore.load({
		params:{Input:Input,start:0,limit:85},
		callback : function(o,response,success) { 
			if (success == false){  
				Ext.MessageBox.alert("��ѯ����",WhonetStore.reader.jsonData.Error);  
			}
		}
	});
	var nm = new Ext.grid.RowNumberer();
	var WhonetInfoCm = new Ext.grid.ColumnModel([nm,{
				header : "����",
				dataIndex : 'AntCode',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "��������",
				dataIndex : 'AntName',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "Ӣ������",
				dataIndex : 'AntEName',
				width : 150,
				align : 'left',
				sortable : true
			
	        }]);
	WhonetInfoCm.defaultSortable = true;
	        
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : WhonetStore,
					pageSize : 85,
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
	var WhonetInfoGrid = new Ext.grid.GridPanel({
				id : 'WhonetInfoGrid',
				title : '',
				height : 170,
				ds: WhonetStore,
				cm : WhonetInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : WhonetStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});
			
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '����ر�',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					flg = false;
					window.close();
				}
			});
	/**
	 * ��������
	 */
	function returnData() {
		var selectRows = WhonetInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ��Ҫ���ص�Whonet����Ϣ��");
		} else if (selectRows.length > 1) {
			Msg.info("warning", "����ֻ����ѡ��һ����¼��");
		} else {
			flg = true;
			window.close();
		}
	}
    // ˫�����¼�  
	WhonetInfoGrid.on('rowdblclick', function() {
				returnData();
			});
	// �س��¼�
	WhonetInfoGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
				}
			});	
	var window = new Ext.Window({
				title : 'WHONET����Ϣ----˫��ѡ��WHONET��',
				width : 460,
				height : 400,
				layout : 'border',
				items :[
				    {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: WhonetInfoGrid        
		               
		            }
	            ],
	            tbar : [closeBT]
	});
	window.show();
	
	window.on('close', function(panel) {
			var selectRows = WhonetInfoGrid.getSelectionModel()
					.getSelections();
			if (selectRows.length == 0) {
				Fn("");
			} else if (selectRows.length > 1) {
				Fn("");
			} else {
				if (flg) {
					var AntCode = selectRows[0].get("AntCode");				
				    Fn(AntCode);
				} else {
					Fn("");
				}
			}
		});
	}
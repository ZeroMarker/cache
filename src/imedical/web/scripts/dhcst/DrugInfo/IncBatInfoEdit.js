function IncBatSearch(inci){
	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������������Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					var locid=session['LOGON.CTLOCID'];
					BatInfoStore.load({params:{start:0,limit:15,InciId:inci,LocId:locid}});
				}
			});
	// ���水ť
	var saveBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������������Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					saveBatInfo();
				}
			});
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '����ر�',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	function saveBatInfo(){
		var rowCount = BatInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = BatInfoStore.getAt(i);
			var Inclb = rowData.get("Inclb");
			var NotUseFlag = rowData.get("NotUseFlag");
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=SaveBatInfo";
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Inclb:Inclb,NotUseFlag:NotUseFlag},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								//Msg.info("success", "����ɹ�!");
								window.close();
							} else {
								var ret=jsonData.info;
								if(ret=="-1"){
								Msg.info("error", "����ʧ��!");
								}
							}
						},
						scope : this
					});
			loadMask.hide();	
		}
		}
	// ����·��
	var BatInfoUrl = DictUrl	+ 'druginfomaintainaction.csp?actiontype=GetBatInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : BatInfoUrl,
				method : "POST"
			});

	// ָ���в���
	var fields = ["Inclb","Inci", "InciCode", "InciDesc","StockQty","StkBin","Btno", "Expdate", "PurStockQty",
			"Spec","NotUseFlag"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "batinfo",
				fields : fields
			});
	// ���ݼ�
	var BatInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var locid=session['LOGON.CTLOCID'];
	BatInfoStore.load({params:{start:0,limit:15,InciId:inci,LocId:locid}});
	var nm = new Ext.grid.RowNumberer();
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '������',
   		dataIndex: 'NotUseFlag',
   		width: 45,
   		sortable:true,
   		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
		    return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
	});
	var BatInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "Inclb",
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "Inci",
				dataIndex : 'Inci',
				width : 120,
				align : 'left',
				sortable : true,
			    hidden : true,
				hideable : false
	        }
	        , {
				header : "����",
				dataIndex : 'InciCode',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "����",
				dataIndex : 'InciDesc',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "�������(������λ)",
				dataIndex : 'StockQty',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "��λ",
				dataIndex : 'StkBin',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "����",
				dataIndex : 'Btno',
				width : 120,
				align : 'left',
				sortable : true
			
	        }, {
				header : "Ч��",
				dataIndex : 'Expdate',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "�������(��ⵥλ)",
				dataIndex : 'PurStockQty',
				width : 120,
				align : 'left',
				sortable : true
			
	        }
	        , {
				header : "���",
				dataIndex : 'Spec',
				width : 120,
				align : 'left',
				sortable : true
			
	        },ColumnNotUseFlag]);
	var BatInfoGrid = new Ext.grid.GridPanel({
				id : 'BatInfoGrid',
				title : '',
				height : 170,
				cm : BatInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : BatInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				plugins:ColumnNotUseFlag
				//bbar:[GridPagingToolbar]
			});
	BatInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : BatInfoStore,
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
						B['InciId']=InciId;
						B['LocId']=LocId;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
	var window = new Ext.Window({
				title : '������Ϣ',
				width : 1100,
				height : 600,
				layout : 'border',
				items :[
				    {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: BatInfoGrid        
		               
		            }
	            ],
	            tbar : [saveBT,'-',closeBT]
	});
	window.show();
	}
// /����: ��ѯδת����
// /����: ������ѯδת����
// /��д�ߣ�yunhaibao
// /��д����: 20150711
var TransNotMove=function(transno,reqno) {
	var CreateTimes=0;
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	var CreateReqBT = new Ext.Toolbar.Button({
				text : '��������',
				tooltip : '��������',
				iconCls : 'page_save',
				anchor : '90%',
				width : 120,
				handler : function() {
					var count= NotMoveDetailGridS.getStore().getCount();
					if(count==0){
					    Msg.info("warning", "��ϸΪ��!�޿�������!");
						return false;
					}
					if(CreateTimes>0){
						Msg.info("warning", "�����������һ��!");
						return false;
					}
					var reqitmstr
					reqitmstr=""
					for(var index=0;index<count;index++)
					{
						var reqdata = NotMoveDetailStore.getAt(index);
						var	reqid=reqdata.data['rowid']
						var reqqty=reqdata.data['NotTransQty']
						if (reqitmstr==""){reqitmstr=reqid+"^"+reqqty;}
						else {reqitmstr=reqitmstr+xRowDelim()+reqid+"^"+reqqty;}
					}
					var url = 'dhcst.inrequestaction.csp?actiontype=InsertReqByNotMove';
					var loadMask=ShowLoadMask(Ext.getBody(),"������...");
					Ext.Ajax.request({
								url : url,
								method : 'POST',
								params:{ReqItmStr:reqitmstr},
								waitMsg : '������...',
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										CreateTimes=CreateTimes+1;
										Ext.Msg.show({
													title : '�������󵥳ɹ�!',
													msg : "���󵥺�:"+jsonData.info,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.SUCCESS
												});	
										NotMoveWin.close()

									} else {
										Msg.info("error",jsonData.info);
									}
								},
								scope : this
							});
					
					loadMask.hide();
				}
	});
	
	var ExportBTS = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '���ΪExcel',
				iconCls : 'page_export',
				width : 70,
				height : 30,
				handler : function() {
					ExportAllToExcel(NotMoveDetailGridS)
				}
			});
	var ExportBTS = new Ext.Toolbar.Button({
			text : 'ɾ��',
			iconCls : 'page_delete',
			width : 70,
			height : 30,
			handler : function() {
				var selectlist=NotMoveDetailGridS.getSelectionModel().getSelections();
				if ((selectlist.length==null)||(selectlist.length<0)){
					Msg.info("error","��ѡ������!");
					return false;
				}
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ����¼?',
					function(btn) {
						if(btn == 'yes'){
							var selectlength=selectlist.length
							for (var selecti=0;selecti<selectlength;selecti++){
								var selectrecord=selectlist[selecti];
								NotMoveDetailStore.remove(selectrecord);				
							}
							NotMoveDetailGridS.getView().refresh();
						}
					}
				 )

			}
		});
	var CloseBTS = new Ext.Toolbar.Button({
				id : "CloseBTS",
				text : '�ر�',
				tooltip : '����ر�',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					NotMoveWin.close()
				}
			});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'inrequestaction.csp?actiontype=queryDetail';  //ѡȡ���󵥵�csp
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["rowid", "inci", "code","desc","qty","NotTransQty","uomDesc", "spec",
			 "manf","sp","reqqty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "rowid",
				fields : fields
			});
	// ���ݼ�
	var NotMoveDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var NotMoveDetailCm = new Ext.grid.ColumnModel([
			{
				header : "RowId",
				dataIndex : 'rowid',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҩƷRowId",
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'desc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true				
			}, {
				header : "δת������",
				dataIndex : 'NotTransQty',
				width : 100,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {								
								var transqty = field.getValue();
								if (transqty == null || transqty.length <= 0) {
									Msg.info("warning", "ת����������Ϊ��!");
									return;
								}
								if (transqty <= 0) {
									Msg.info("warning", "ת����������С�ڻ����0!");
									return;
								}
							}
							//���¼�����
							if(e.getKey()==Ext.EventObject.UP){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=38;} 
								var rowrecord = NotMoveDetailGridS.getSelectionModel().getSelected();
								var recordrow = NotMoveDetailStore.indexOf(rowrecord)
								var colIndex=GetColIndex(NotMoveDetailGridS,"NotTransQty");
								var row=recordrow-1;
								if(row>=0){
									//NotMoveDetailGridS.getSelectionModel().select(row, colIndex);
									NotMoveDetailGridS.getSelectionModel().selectRow(row);
									NotMoveDetailGridS.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.DOWN){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=40;} 
								var rowCount=NotMoveDetailGridS.getStore().getCount();
								var rowrecord = NotMoveDetailGridS.getSelectionModel().getSelected();
								var recordrow = NotMoveDetailStore.indexOf(rowrecord)
								var colIndex=GetColIndex(NotMoveDetailGridS,"NotTransQty");
								var row=recordrow+1;
								if(row<rowCount){
									//NotMoveDetailGridS.getSelectionModel().select(row, colIndex);
									NotMoveDetailGridS.getSelectionModel().selectRow(row);
									NotMoveDetailGridS.startEditing(row, colIndex);
								}
							}

						}
						}
					})
			
			}, {
				header : "��λ",
				dataIndex : 'uomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "���󷽿��",
				dataIndex : 'reqqty',
				width : 180,
				align : 'left',
				sortable : true
			}]);
 var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:NotMoveDetailStore,
		pageSize:999,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});

	var NotMoveDetailGridS = new Ext.grid.EditorGridPanel({
				id : 'NotMoveDetailGridS',
				region : 'center',
				title : '',
				cm : NotMoveDetailCm,
				sm:new Ext.grid.RowSelectionModel({}),
				store : NotMoveDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1,
				bbar:GridDetailPagingToolbar,
				listeners:{
						'beforeedit':function(e)
						{
							if (e.field=='NotTransQty'){	
								var currecord=e.record
								var recordrow = NotMoveDetailStore.indexOf(currecord)
								NotMoveDetailGridS.getSelectionModel().selectRow(recordrow);
							}
						}
				}

			});

	var NotMoveWin = new Ext.Window({
		title:'<font size=3 color=Blue><p>'+'ת�Ƶ���:'+transno+'-----------���󵥺�:'+reqno+'</p></font>',
		id:'NotMoveWin',
		width:1000,
		height:520,
		minWidth:1000, 
		minHeight:620,
		plain:true,
		modal:true,
		layout : 'border',
		items : [            // create instance immediately
			{
	            region: 'center',
	            title: '������ϸ',
	            layout: 'fit', // specify layout manager for items
	            items: NotMoveDetailGridS       
	           
	        }
		],
		tbar : [CreateReqBT,'-',ExportBTS,'-',CloseBTS]
		
	});
		
	//��ʾ����
	NotMoveWin.show();
	var ReqId = tkMakeServerCall("web.DHCST.INRequest","GetInReqIdByNo",reqno)
	var show=0  //�Ƿ���ʾ��ת����ɵ�������ϸ��1����ʾ��0������ʾ��
	NotMoveDetailStore.removeAll();
	NotMoveDetailStore.setBaseParam('req',ReqId);
	NotMoveDetailStore.setBaseParam('TransferedFlag',show);
	NotMoveDetailStore.load({params:{start:0,limit:999,sort:'req',dir:'Desc'}});
	
}
// /����: ת��������
// /����: ת��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
		// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('������'),
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',					
				anchor: '90%',
				emptyText:$g('������'),
				groupId:gGroupId
				//defaultLoc:''
			});

	// ��������
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('��������'),
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',	
				emptyText:$g('��������'),
				anchor : '90%',
				//groupId:gGroupId
				defaultLoc:''
			});

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel :$g( '��ֹ����'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				width : 120,
				value : DefaultEdDate()
			});

	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : $g('��ѯ'),
				tooltip : $g('�����ѯ'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if (requestphaLoc == null || requestphaLoc.length <= 0) {
			Msg.info("warning", $g("��ѡ��������!"));
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var statue = "21";
		
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^Y^'+statue+'^^';
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({params:{start:0, limit:Page}});
		MasterStore.on('load',function(){
			if (MasterStore.getCount()>0){
				MasterGrid.getSelectionModel().selectFirstRow();
				MasterGrid.getView().focusRow(0);
			}
		});
	}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text : $g('����'),
				tooltip : $g('�������'),
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		SetLogInDept(PhaDeptStore, "RequestPhaLoc");
		Ext.getCmp("SupplyPhaLoc").setValue("");
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ������ť
	var CheckBT = new Ext.Toolbar.Button({
				id : "CheckBT",
				text :$g( '����'),
				tooltip : $g('�������'),
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					AuditPart();
				}
			});

	/**
	 * ����ת�Ƶ����
	 */
	 ///���ֽ���
	function AuditPart(){
		var j=0
		var strrowid=""
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		//sm.selectAll() 
		for (var i = 0; i < rowCount; i++) {			
			      
				//ѭ��ÿ��ѡ�������
				if(sm.isSelected(i)==false){
					var record = store.getAt(i);
					var detailId = record.get('initi');
					j=j+1
					if(j==1){strrowid=detailId}
					else{strrowid=strrowid + "!" + detailId}
				}
		}
		if(j>0){
			if(rowCount>j){
			   Ext.Msg.show({
				   title:$g('��ʾ'),
				   msg: $g("��") + j +$g( "����ϸ�´ν��գ�ȷ����"),
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){AuditEx(strrowid);}
				   },
				   icon: Ext.MessageBox.QUESTION
			   });
			}else if(rowCount==j){
			     Msg.info("warning", $g("�빴ѡ��Ҫ���յ���ϸ!"));
			}
		}else {
			AuditEx(strrowid);
		}
	}
	function AuditEx(strrowid) {		
		// �ж�ת�Ƶ��Ƿ������
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", $g("��ѡ��Ҫ���յ�ת�Ƶ�!"));
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21" && INITState != "32") {
			Msg.info("warning", $g("ת�Ƶ����Ǵ�����״̬�����ʵ!"));
			return;
		}
		
		var Init = rowData.get("init");
//		var url = DictUrl
//				+ "dhcinistrfaction.csp?actiontype=AuditInPart&Rowid="
//				+ Init + "&User=" + userId + "&Strrowid=" + strrowid;
				
		Ext.Ajax.request({
					//url : url,
					url : DictUrl + "dhcinistrfaction.csp?actiontype=AuditInPart",
					params:{Rowid:Init ,User: userId,Strrowid: strrowid} ,
					
					method : 'POST',
					waitMsg : $g('��ѯ��...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", $g("���ճɹ�!"));
							Query();
							//���ݲ��������Զ���ӡ
							if(gParam[5]=='Y'){
								PrintInIsTrf.defer(300,this,[Init,gParam[8]]);
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", $g("���ⵥ���Ǵ�����״̬!"));
							}else if(Ret==-99){
								Msg.info("error",$g( "����ʧ��!"));
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", $g("���³��ⵥ״̬ʧ��!"));
							}else if(Ret==-3){
								Msg.info("error", $g("������ʧ��!"));
							}else if(Ret==-4){
								Msg.info("error", $g("����̨��ʧ��!"));
							}else{
								Msg.info("error", $g("����ʧ��:")+Ret);
							}
						}
					},
					scope : this
				});
	}
	function Audit() {
		
		
		// �ж�ת�Ƶ��Ƿ������
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning",$g( "��ѡ��Ҫ���յ�ת�Ƶ�!"));
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning",$g( "ת�Ƶ����Ǵ�����״̬�����ʵ!"));
			return;
		}
		var Init = rowData.get("init");
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ Init + "&User=" + userId;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : $g('��ѯ��...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", $g("���ճɹ�!"));
							Query();
							//���ݲ��������Զ���ӡ
							if(gParam[5]=='Y'){
								PrintInIsTrf(Init,gParam[8]);
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", $g("���ⵥ���Ǵ�����״̬!"));
							}else if(Ret==-99){
								Msg.info("error", $g("����ʧ��!"));
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", $g("���³��ⵥ״̬ʧ��!"));
							}else if(Ret==-3){
								Msg.info("error", $g("������ʧ��!"));
							}else if(Ret==-4){
								Msg.info("error", $g("����̨��ʧ��!"));
							}else if(Ret==-5){
								Msg.info("error", $g("����ת���������ʧ��!"));
							}else{
								Msg.info("error", $g("����ʧ��:")+Ret);
							}
						}
					},
					scope : this
				});
	}

	// �����˾ܾ���ť
	var AuditNoBT = new Ext.Toolbar.Button({
				id : "AuditNoBT",
				text : $g('�ܾ�����'),
				tooltip : $g('����ܾ�����'),
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					AuditNo();
				}
			});
	/**
	 * ��ⵥ��˲�ͨ��
	*/
	function AuditNo() {
		// �ж�ת�Ƶ��Ƿ������
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", $g("��ѡ����Ҫ�ܾ���ת�Ƶ�!"));
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning",$g( "ת�Ƶ����Ǵ�����״̬�����ʵ!"));
			return;
		}
		var Init = rowData.get("init");
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditInNo&Rowid="
				+ Init + "&User=" + userId;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : $g('��ѯ��...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", $g("�ɹ�!"));
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", $g("���ⵥ���Ǵ�����״̬!"));
							}else if(Ret==-99){
								Msg.info("error", $g("����ʧ��!"));
							}else if(Ret==-1){
								Msg.info("error", $g("���³��ⵥ״̬ʧ��!"));
							}else if(Ret==-3){
								Msg.info("error", $g("�ָ���棬����̨��ʧ��!"));
							}else if(Ret==-4){
								Msg.info("error", $g("�ָ�ռ������ʧ��!"));
							}else if(Ret==-5){
								Msg.info("error", $g("���³�����ϸ״̬ʧ��!"));
							}else if(Ret==-6){
								Msg.info("error", $g("��˺�۸�仯���ܾ������������������"));
							}else if(Ret==-7){
								Msg.info("error", $g("�����½�����:���½�ֹ�ܾ�����!"));
							}else if(Ret==-201){
								Msg.info("error", $g("��������Ѿ��½ᣬ������ܾ���⣡"));
							}else if(Ret==-202){
								Msg.info("error", $g("�ó��ⵥ�Ѿ����˲��ֽ��գ��������پܾ����գ�"));
							}else{
								Msg.info("error", $g("ʧ��:"+Ret));
							}
						}
					},
					scope : this
				});
	}


			
		/* �����ð�ť */
		var GridColSetBT = new Ext.Toolbar.Button({
			text:$g('������'),
			tooltip:$g('������'),
			iconCls:'page_gear',
			handler:function(){
				GridSelectWin.show();
			}
		});

		// ȷ����ť
		var returnColSetBT = new Ext.Toolbar.Button({
			text : $g('ȷ��'),
			tooltip : $g('���ȷ��'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(MasterGrid,"DHCSTTRANSFER");						
					}
					else {
						GridColSet(DetailGrid,"DHCSTTRANSFER");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// ȡ����ť
		var cancelColSetBT = new Ext.Toolbar.Button({
				text : $g('ȡ��'),
				tooltip : $g('���ȡ��'),
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

		//ѡ��ť
		var GridSelectWin=new Ext.Window({
			title:$g('ѡ��'),
			width : 210,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				xtype:'radiogroup',
				id:'GridSelectModel',
				anchor: '95%',
				columns: 2,
				style: 'padding:10px 10px 10px 10px;',
				items : [{
						checked: true,				             
							boxLabel: $g('���ⵥ'),
							id: 'GridSelectModel1',
							name:'GridSelectModel',
							inputValue: '1' 							
						},{
						checked: false,				             
							boxLabel: $g('���ⵥ��ϸ'),
							id: 'GridSelectModel2',
							name:'GridSelectModel',
							inputValue: '2' 							
						}]
					}],
			
			buttons:[returnColSetBT,cancelColSetBT]
		})


	
	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
	"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "init",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
    var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("ת�Ƶ���"),
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g('���󵥺�'),
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("������"),
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("ת������"),
				dataIndex : 'dd',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g("����״̬"),
				dataIndex : 'StatusCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("�Ƶ���"),
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : $g("���۽��"),
				dataIndex : 'RpAmt',
				width : 80,
				align : 'right',				
				sortable : true,
				renderer:FormatGridRpAmount
			}, {
				header : $g("�ۼ۽��"),
				dataIndex : 'SpAmt',
				width : 80,
				align : 'right',				
				sortable : true,
				renderer:FormatGridSpAmount
			}, {
				header : $g("�������"),
				dataIndex : 'MarginAmt',
				width : 80,
				align : 'right',				
				sortable : true,
				renderer:FormatGridRpAmount
			}, {
				header : $g("��ע"),
				dataIndex : 'Remark',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var InIt = MasterStore.getAt(rowIndex).get("init");
		DetailStore.setBaseParam('Parref',InIt+"^21")
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
	});
	// ����·��
	var DetailUrl =  DictUrl
				+ 'dhcinistrfaction.csp?actiontype=QueryInIsTrfDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["initi", "inrqi", "inci","inciCode",
			"inciDesc", "inclb", "batexp", "manf","manfName",
			 "qty", "uom", "sp","status","remark",
			"reqQty", "inclbQty", "reqLocStkQty", "reqstkbin",
			"pp", "spec", "gene", "formDesc","newSp",
			"spAmt", "rp","rpAmt", "ConFac", "BUomId", 
			"inclbDirtyQty", "inclbAvaQty","TrUomDesc","InsuCode","InsuDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "initi",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	// hulihua 2016-01-06 ���Ӳ��ֽ���ѡ��Ĺ��ܣ�		
	DetailStore.addListener('load', function(st, rds, opts) {
    	var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		sm.selectAll() 
    });
       
	// ת����ϸ��ѡ���
	var detailSM = new Ext.grid.CheckboxSelectionModel(); 
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,detailSM, {
				header : $g("ת��ϸ��RowId"),
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("ҩƷId"),
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : $g('ҩƷ����'),
				dataIndex : 'inciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'inciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("����Id"),
				dataIndex : 'inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����/Ч��"),
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : $g("������ҵ"),
				dataIndex : 'manfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("���ο��"),
				dataIndex : 'inclbQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("ת������"),
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("ת�Ƶ�λ"),
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("�ۼ�"),
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'reqQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("��λ��"),
				dataIndex : 'reqstkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("���󷽿��"),
				dataIndex : 'reqLocStkQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("ռ������"),
				dataIndex : 'inclbDirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'inclbAvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("�����ۼ�"),
				dataIndex : 'newSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("���"),
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("����ͨ����"),
				dataIndex : 'gene',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'formDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("�ۼ۽��"),
				dataIndex : 'spAmt',
				width : 100,
				align : 'right',				
				sortable : true,
				renderer:FormatGridSpAmount
			}, {
				header : $g("���۽��"),
				dataIndex : 'rpAmt',
				width : 100,
				align : 'right',				
				sortable : true,
				renderer:FormatGridRpAmount
			}, {
				header : $g("����ҽ������"),
				dataIndex : 'InsuCode',
				width : 100,
				align : 'right',					
				sortable : true,
			}, {
				header : $g("����ҽ������"),
				dataIndex : 'InsuDesc',
				width : 100,
				align : 'right',					
				sortable : true,
			}]);
   var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:999,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
	});
	var DetailGrid = new Ext.grid.GridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				sm :detailSM,
				bbar:GridDetailPagingToolbar,
				loadMask : true
			});

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT,'-',AuditNoBT,'-',GridColSetBT],
		items:[{
			xtype:'fieldset',
			title:$g('��ѯ����'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {border:false,width: 220},    // Default config options for child items
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [SupplyPhaLoc]
				
			},{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [RequestPhaLoc]
				
			},{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [StartDate]
				
			},{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [EndDate]
				
			}]
		}]			
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		            	title:$g('ת��������'),
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: $g('���ⵥ'),			               
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'south',
		                split: true,
            			height: 300,
            			collapsible: true,
		                title: $g('���ⵥ��ϸ'),
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
	RefreshGridColSet(MasterGrid,"DHCSTTRANSFER");   
	RefreshGridColSet(DetailGrid,"DHCSTTRANSFER"); 	
	Query();
	

})

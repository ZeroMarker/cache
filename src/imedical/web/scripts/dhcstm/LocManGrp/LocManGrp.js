// /����: ���ҹ�����ά��
// /����: ���ҹ�����ά��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var groupId=session['LOGON.GROUPID'];
	var gLocId=null;


	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});

		/**
		 * ��ѯ����
		 */
		function Query() {
			// ��ѡ����
			var Code = Ext.getCmp("LocCode").getValue();
			var Desc = Ext.getCmp("LocDesc").getValue();

			gStrParam=Code+"^"+Desc;
			var PageSize=LocPagingToolbar.pageSize;
			LocStore.load({params:{start:0,limit:PageSize,StrParam:gStrParam,GroupId:groupId}});

		}

		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			gLocId="";
			Ext.getCmp("LocCode").setValue('');
			Ext.getCmp("LocDesc").setValue('');
			LocManGrpGrid.store.removeAll();
			LocGrid.store.removeAll();
			LocGrid.getView().refresh();
		}

		//�½�
		var AddBT=new Ext.Toolbar.Button({
			id:'AddBT',
			text:'����',
			tooltip:'�������',
			width:70,
			height:30,
			iconCls:'page_add',
			handler:function(){

				if(gLocId==null || gLocId.length<1){
					Msg.info("warning","����ѡ�����!");
					return;
				}

				AddNewRow();
			}
		});

		function AddNewRow(){
			var record=Ext.data.Record.create([{name:'Rowid'},{name:'Code'},{name:'Desc'}]);
			var newRecord=new Ext.data.Record({
				Rowid:'',
				Code:'',
				Desc:''
			});

			LocManGrpStore.add(newRecord);
			var lastRow=LocManGrpStore.getCount()-1;
			LocManGrpGrid.startEditing(lastRow,2);
		}
		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// ������ҿ�������Ϣ
						save();
					}
				});
		function save(){
			if(gLocId==null || gLocId.length<1){
				Msg.info("warning","���Ҳ���Ϊ��!")
				return;
			}
			var ListDetail="";
			var rowCount = LocManGrpGrid.getStore().getCount();

			for (var i = 0; i < rowCount; i++) {
				var rowData = LocManGrpStore.getAt(i);
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var Rowid = rowData.get("Rowid");
					var Code = rowData.get("Code").trim();
					var Desc=rowData.get("Desc").trim();
					if(Code!="" && Desc!=""){
						var str = Rowid + "^" + Code+"^"+Desc;
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if(ListDetail==""){
				Msg.info("warning","û���޸Ļ����������!");
				return false;
			}
			var url = DictUrl
					+ "locmangrpaction.csp?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
						url : url,
						params: {LocId:gLocId,Detail:ListDetail},
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {

								Msg.info("success", "����ɹ�!");
								// ˢ�½���
								LocManGrpStore.load({params:{LocId:gLocId}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "û����Ҫ���������!");
								}else {
									Msg.info("error", "������ϸ���治�ɹ���"+ret);
								}

							}
						},
						scope : this
					});

		}

	var DeleteBT=new Ext.Toolbar.Button({
		id:'DeleteBT',
		text:'ɾ��',
		width:'70',
		height:'30',
		tooltip:'���ɾ��',
		iconCls:'page_delete',
		handler: function(){
			Delete();
		}
	});

	function Delete(){
		var cell=LocManGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ��Ҫɾ���ļ�¼��");
			return;
		}
		var row=cell[0];
		var record=LocManGrpStore.getAt(row);
		var rowid=record.get("Rowid");
		if(rowid==null || rowid.length<1){
			Msg.info("warning","��ѡ��¼��δ���棬����ɾ��!");
			return;
		}else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���ù�������Ϣ',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}

		function showResult(btn) {
			if (btn == "yes") {
		var url = DictUrl	+ "locmangrpaction.csp?actiontype=Delete";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			method:'post',
			waitMsg:'������...',
			params:{Rowid:rowid},
			success: function(response,opts){

				var jsonData=Ext.util.JSON.decode(response.responseText);
				  mask.hide();
				if (jsonData.success=='true'){
					Msg.info("success","ɾ���ɹ�!");
					LocManGrpStore.load({params:{LocId:gLocId}});
				}else {
					Msg.info("error","ɾ��ʧ��!");
				}

			}
		});

	}}}
	//��������Դ
	var locUrl =DictUrl+'locmangrpaction.csp?actiontype=QueryLoc';
	var LocGridProxy= new Ext.data.HttpProxy({url:locUrl,method:'POST'});
	var LocStore = new Ext.data.Store({
		proxy:LocGridProxy,
	    reader:new Ext.data.JsonReader({
			totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'Rowid'},
			{name:'Code'},
			{name:'Desc'}
		]),
	    remoteSort:true
	});

	//ģ��
	var LocGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"����",
	        dataIndex:'Code',
	        width:200,
	        align:'left',
	        sortable:true
	    },{
	        header:"����",
	        dataIndex:'Desc',
	        width:200,
	        align:'left',
	        sortable:true
	    }
	]);
	//��ʼ��Ĭ��������
	LocGridCm.defaultSortable = true;
	var LocPagingToolbar = new Ext.PagingToolbar({
	    store:LocStore,
		pageSize:PageSize,
	    displayInfo:true,
	    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	    emptyMsg:"û�м�¼",
		doLoad:function(C){
			var B={},
			A=this.getParams();
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B[A.sort]='Rowid';
			B[A.dir]='desc';
			B['StrParam']=gStrParam;
			B['GroupId']=groupId;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});

	var LocCode=new Ext.form.TextField({
		id:'LocCode',
		name:'LocCode',
		width:100
	});

	var LocDesc=new Ext.form.TextField({
		id:'LocDesc',
		name:'LocDesc',
		width:120
	});

	//���
	LocGrid = new Ext.grid.GridPanel({
		store:LocStore,
		cm:LocGridCm,
		trackMouseOver:true,
		height:500,
		stripeRows:true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask:true,
		bbar:LocPagingToolbar,
		tbar:['����:',LocCode,'����:',LocDesc,'-',SearchBT,'-',RefreshBT]
	});

	LocGrid.addListener("rowclick",function(grid,rowindex,e){
		var selectRow=LocStore.getAt(rowindex);
		gLocId=selectRow.get("Rowid");
		LocManGrpStore.load({params:{LocId:gLocId}});
	});

		var nm = new Ext.grid.RowNumberer();
		var LocManGrpCm = new Ext.grid.ColumnModel([nm, {
					header : "Rowid",
					dataIndex : 'Rowid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'Code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : false,
					editor:new Ext.form.TextField({
						allowBlank:false,
						listeners:{
							specialkey: function(field,e){
								var keycode=e.getKey();
								if(keycode==e.ENTER){
									var cell=LocManGrpGrid.getSelectionModel().getSelectedCell();
									var row=cell[0];
									LocManGrpGrid.startEditing(row,3);
								}
							}
						}
					})
				}, {
					header : "����",
					dataIndex : 'Desc',
					width : 200,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
						allowBlank:false,
						listeners:{
							specialkey: function(field,e){
								var keycode=e.getKey();
								if(keycode==e.ENTER){
									AddNewRow();
								}
							}
						}
					})
			}]);
		LocManGrpCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locmangrpaction.csp?actiontype=Query&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : ["Rowid","Code","Desc"]
				});
		// ���ݼ�
		var LocManGrpStore = new Ext.data.Store({
					pruneModifiedRecords:true,
					proxy : proxy,
					reader : reader
				});
		var LocManGrpGrid = new Ext.grid.EditorGridPanel({
					id:'LocManGrpGrid',
					cm : LocManGrpCm,
					store : LocManGrpStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					tbar:[AddBT,'-',SaveBT],		//,'-',DeleteBT
					loadMask : true
				});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 500,
                			minSize: 450,
                			maxSize: 550,
                			collapsible: true,
			                title: '����',
			                layout: 'fit', // specify layout manager for items
			                items: LocGrid

			            }, {
			                region: 'center',
			                title: '������',
			                layout: 'fit', // specify layout manager for items
			                items: LocManGrpGrid

			            }
	       			],
					renderTo : 'mainPanel'
				});
	Query();
})
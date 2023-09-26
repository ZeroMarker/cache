// /����: ʵ�̣�¼�뷽ʽһ�������������ݰ��������ʵ������
// /����:  ʵ�̣�¼�뷽ʽһ�������������ݰ��������ʵ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.30
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParams='';
	var gStrDetailParams='';
	var gRowid='';
	var url=DictUrl+'instktkaction.csp';
	var PhaLoc = new Ext.form.ComboBox({
				fieldLabel : '����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				//anchor : '95%',
				width : 140,
				store : GetGroupDeptStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '����...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				hideLabel:true,
				valueNotFoundText : ''
			});
	// ��¼����Ĭ��ֵ
	SetLogInDept(GetGroupDeptStore, "PhaLoc");
	
	var LocManaGrp = new Ext.form.ComboBox({
				fieldLabel : '������',
				id : 'LocManaGrp',
				name : 'LocManaGrp',
				//anchor : '95%',
				width : 140,
				store : LocManGrpStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				emptyText : '������...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				listeners:{
					'expand':function(combox){
							var LocId=Ext.getCmp('PhaLoc').getValue();
							LocManGrpStore.load({params:{start:0,limit:20,locId:LocId}});	
					}
				}
			});		
		
	var PhaWindow = new Ext.form.ComboBox({
			fieldLabel : 'ʵ�̴���',
			id : 'PhaWindow',
			name : 'PhaWindow',
			//anchor : '95%',
			width : 140,
			store : PhaWindowStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			emptyText : 'ʵ�̴���...',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			listeners:{
				'beforequery':function(e){
					var desc=Ext.getCmp('PhaWindow').getRawValue();
					if(desc!=null || desc.length>0){
						PhaWindowStore.load({params:{start:0,limit:20,Desc:desc}});
					}
				}
			}
		});	
		
	var Complete=new Ext.form.Checkbox({
		fieldLabel:'���',
		id:'Complete',
		name:'Complete',
		width:80,
		disabled:true
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:"G",     //��ʶ��������
		width : 140
	}); 

	var DHCStkCatGroup = new Ext.form.ComboBox({
				fieldLabel : '������',
				id : 'DHCStkCatGroup',
				name : 'DHCStkCatGroup',
				anchor : '90%',
				width : 140,
				store : StkCatStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				valueNotFoundText : ''
			});

	StkGrpType.on('select', function(e) {
		Ext.getCmp('DHCStkCatGroup').setValue("");
		StkCatStore.proxy = new Ext.data.HttpProxy({
			url : 'dhcst.drugutil.csp?actiontype=StkCat&StkGrpId='+ Ext.getCmp('StkGrpType').getValue()+ '&start=0&limit=999'
		});
		StkCatStore.reload();
	});
		
	var StkBin = new Ext.form.ComboBox({
		fieldLabel : '��λ',
		id : 'StkBin',
		name : 'StkBin',
		anchor : '90%',
		width : 140,
		store : LocStkBinStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 20,
		listWidth : 250,
		valueNotFoundText : '',
		enableKeyEvents : true,
		listeners : {
			'expand' : function(e) {
				var LocId=Ext.getCmp("PhaLoc").getValue();
				LocStkBinStore.load({params:{LocId:LocId,Desc:Ext.getCmp('StkBin').getRawValue(),start:0,limit:20}});					
			}
		}
	});	
	
	// ��ʼ����
	var StartDate = new Ext.form.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				format : 'Y-m-d',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// ��������
	var EndDate = new Ext.form.DateField({
				fieldLabel : '��������',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				format : 'Y-m-d',
				width : 80,
				value : new Date()
			});
			
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					QueryDetail();
				}
			});
	
	// ��ѯ��ť
	var QueryBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});
	
	//����δ��������������
	var SetDefaultBT2 = new Ext.Toolbar.Button({
				text : '����δ��������������',
				tooltip : '�������δ��������������',
				iconCls : 'page_save',
				width : 70,
				height : 30,
				handler : function() {
					SetDefaultQty(2);
				}
			});
			
	//����δ��������0
	var SetDefaultBT = new Ext.Toolbar.Button({
				text : '����δ��������0',
				tooltip : '�������δ��������0',
				iconCls : 'page_save',
				width : 70,
				height : 30,
				handler : function() {
					SetDefaultQty(1);
				}
			});
	
	//����δ��ʵ����
	function SetDefaultQty(flag){
		if(gRowid==''){
			Msg.info('Warning','û��ѡ�е��̵㵥��');
			return;
		}
		var UserId=session['LOGON.USERID'];
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'SetDefaultQty',Inst:gRowid,UserId:UserId,Flag:flag},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					Msg.info('success','�ɹ�!');
					QueryDetail();
				}else{
					var ret=jsonData.info;					
					Msg.info('error','����δ���¼ʵ����ʧ��:'+ret);
					
				}
			}		
		});
	}
	
	//��ѯ�̵㵥
	function Query(){
	
		var StartDate = Ext.getCmp("StartDate").getValue().format('Y-m-d').toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format('Y-m-d').toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ���̵����!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
			return;
		}
		var CompFlag='Y';
		var TkComplete='N';  //ʵ����ɱ�־
		var AdjComplete='N';	//������ɱ�־
		var Page=GridPagingToolbar.pageSize;
		gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.load({params:{actiontype:'Query',start:0, limit:Page,sort:'instNo',dir:'asc',Params:gStrParams}});
	}
	
	// ��հ�ť
	var RefreshBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '������',
				iconCls : 'page_refresh',
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
		
		gStrParams='';
		Ext.getCmp("DHCStkCatGroup").setValue('');
		Ext.getCmp("StkBin").setValue('');
		Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("PhaWindow").setValue('');
		Ext.getCmp("LocManaGrp").setValue('');
		
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}

	var SaveBT=new Ext.Toolbar.Button({
		text:'����',
		tooltip:'�������',
		iconCls:'page_add',
		width:70,
		height:30,
		handler:function(){
			save();
		}
	});
	
	//����ʵ������
	function save(){
		var rowCount=InstDetailStore.getCount();
		var ListDetail='';
		for(var i=0;i<rowCount;i++){
			var rowData=InstDetailStore.getAt(i);
			//�������޸Ĺ�������
			if(rowData.dirty || rowData.data.newRecord){
				var Parref=rowData.get('insti');
				var Rowid=rowData.get('instw');
				var UserId=session['LOGON.USERID'];
				var CountQty=rowData.get('countQty');
				var CountUomId=rowData.get('uom');
				var StkBin='';
				var PhaWin=Ext.getCmp('PhaWindow').getValue();
				var Detail=Parref+'^'+Rowid+'^'+UserId+'^'+CountQty+'^'+CountUomId+'^'+StkBin+'^'+PhaWin;
				if(ListDetail==''){
					ListDetail=Detail;
				}else{
					ListDetail=ListDetail+','+Detail;
				}
			}
		}
		if(ListDetail==''){
			Msg.info('Warning','û����Ҫ���������!');
			return;
		}
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'SaveTkItmWd',Params:ListDetail},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData=='true'){
					Msg.info('success','����ɹ�!');
					QueryDetail();
				}else{
					var ret=jsonData.info;
					if(ret=='-1'){
						Msg.info('warning','û����Ҫ���������!');
					}else if(ret=='-2'){
						Msg.info('error','����ʧ��!');
					}else{
						Msg.info('error','�������ݱ���ʧ��:'+ret);
					}
				}
			}		
		});
	}
	
	//�����������ݲ���ʵ���б�
	function create(inst){
		if(inst==null || inst==''){
			Msg.info('warning','��ѡ���̵㵥');
			return;
		}
		var UserId=session['LOGON.USERID'];
	
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'CreateTkItmWd',Inst:inst,UserId:UserId},
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					QueryDetail(inst);    //����ʵ���б�
				}else{
					var ret=jsonData.info;					
					Msg.info("error","��ȡʵ���б�ʧ�ܣ�"+ret);					
				}
			}			
		});
	}
		
	//�����̵㵥����ϸ��Ϣ
	function QueryDetail(){
		
		//��ѯ�̵㵥��ϸ
		var StkGrpId=Ext.getCmp('StkGrpType').getValue();
		var StkCatId=Ext.getCmp('DHCStkCatGroup').getValue();
		var StkBinId=Ext.getCmp('StkBin').getValue();
		var PhaWinId=Ext.getCmp('PhaWindow').getValue();
		var ManaGrpId=Ext.getCmp('LocManaGrp').getValue();
		var size=StatuTabPagingToolbar.pageSize;
		
		gStrDetailParams=gRowid+'^'+ManaGrpId+'^'+StkGrpId+'^'+StkCatId+'^'+StkBinId+'^'+PhaWinId;
		InstDetailStore.load({params:{actiontype:'INStkTkItmWd',start:0,limit:size,sort:'desc',dir:'ASC',Params:gStrDetailParams}});
	}
	
	var CompleteBT=new Ext.Toolbar.Button({
		text:'ȷ�����',
		tooltip:'���ȷ�����',
		iconCls:'page_gear',
		width:70,
		height:30,
		handler:function(){
			InstComplete();
		}
	});
	
	//ȷ�����
	function InstComplete(){
		if(gRowid==null){
			Msg.info("warning","û����Ҫ��ɵ��̵㵥!");
			return;
		}
		Ext.Ajax.request({
			url:url,
			params:{actiontype:'ChangeInputStatus',Inst:gRowid,Complete:'Y'},
			method:'post',
			waitMsg:'������...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					Msg.info("success","�����ɹ�!");
					Ext.getCmp('Complete').setValue(true);
					Ext.getCmp('Save').setDisabled(true);
					Ext.getCmp('SetDefaultQty').setDisabled(true);
					Ext.getCmp('SetDefaultQty2').setDisabled(true);
				}else{
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error","����ʧ��!");
					}else if(ret==-2){
						Msg.info("error","�̵㵥�Ѿ�����!");
					}else if(ret==-3){
						Msg.info("error","�̵㵥������δ���!");
					}else if(ret==-4){
						Msg.info("error","����δ¼��ʵ�����ļ�¼�����ʵ!");
					}else{
						Msg.info("error","����ʧ��!");
					}
				}
			}			
		});
	}

	// ָ���в���
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// ���ݼ�
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : url,
				method : "POST"
			});
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});	
	
	function renderCompFlag(value){
		if(value=='Y'){
			return '���';
		}else{
			return 'δ���'
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return '����ҩ';
		}else{
			return '�ǹ���ҩ'
		}	
	}
	function renderYesNo(value){
		if(value=='Y'){
			return '��';
		}else{
			return '��'
		}	
	}
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "�̵㵥��",
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�̵�����",
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�̵�ʱ��',
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '�̵���',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '������ɱ�־',
				dataIndex : 'comp',
				width : 50,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '����ҩ��־',
				dataIndex : 'manFlag',
				width : 50,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "���̵�λ",
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return '��ⵥλ';
					}else{
						return '������λ';
					}
				},
				sortable : true
			}, {
				header : "����������",
				dataIndex : 'includeNotUse',
				width : 50,
				align : 'left',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 50,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��ʼ��λ",
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��ֹ��λ",
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
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
						B['Params']=gStrParams;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
	var MasterInfoGrid = new Ext.grid.GridPanel({
				id : 'MasterInfoGrid',
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// ˫���¼�
	MasterInfoGrid.on('rowdblclick', function(grid,rowindex,e) {
		Ext.Msg.show({
		   title:'��ʾ',
		   msg: '���̵㵥��δ¼��ʵ�����ݣ���Ҫ¼����',
		   buttons: Ext.Msg.YESNOCANCEL,
		   fn: function(btn,text,opt){
		   		if(btn=='yes'){
		   			var selectRow=MasterInfoStore.getAt(rowindex);
					gRowid=selectRow.get('inst');
					Create(gRowid);
		   		}
		   },
		   animEl: 'elId',
		   icon: Ext.MessageBox.QUESTION
		});
		
	});
	
	MasterInfoGrid.on('rowclick',function(grid,rowindex,e){
		var selectRow=MasterInfoStore.getAt(rowindex);
		gRowid=selectRow.get('inst');
		QueryDetail();
	});
			
	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
				header : "rowid",
				dataIndex : 'instw',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "parref",
				dataIndex : 'insti',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header:"inclb",
				dataIndex:'inclb',
				width:80,
				align:'left',
				sortable:true,
				hidden:true				
			},{
				header : '����',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'desc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "���",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'����',
				dataIndex:'batNo',
				width:80,
				align:'right',
				sortable:true
			}, {
				header:'Ч��',
				dataIndex:'expDate',
				width:100,
				align:'right',
				sortable:true
			}, {
				header : "��λ",
				dataIndex : 'uomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'freQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header:'ʵ������',
				dataIndex:'countQty',
				width:80,
				align:'right',
				sortable:true,
				editor:new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners:{
						'specialkey':function(field,e){
								var keyCode=e.getKey();
								var col=GetColIndex(InstDetailGrid,'countQty');
								var cell=InstDetailGrid.getSelectionModel().getSelectedCell();
								var rowCount=InstDetailGrid.getStore().getCount();
								if(keyCode==Ext.EventObject.ENTER){
									var qty=field.getValue();
									if(qty<0){
										Msg.info('warning','ʵ����������С����!');
										return;
									}
									var row=cell[0]+1;
									if(row<rowCount){
										InstDetailGrid.startEditing(row,col);
									}
								}
								if(keyCode==Ext.EventObject.UP){
									var row=cell[0]-1;
									if(row>=0){
										InstDetailGrid.startEditing(row,col);
									}
								}
								if(keyCode==Ext.EventObject.DOWN){
									var row=cell[0]+1;
									if(row<rowCount){
										InstDetailGrid.startEditing(row,col);
									}
								}
						}
					}
				})
			},{
				header : "����",
				dataIndex : 'manf',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header:'ʵ������',
				dataIndex:'countDate',
				width:80,
				align:'right',
				sortable:true
			},{
				header : "ʵ��ʱ��",
				dataIndex : 'countTime',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'ʵ����',
				dataIndex:'userName',
				width:80,
				align:'right',
				sortable:true
			}]);
	InstDetailGridCm.defaultSortable = true;

	// ���ݼ�
	var InstDetailStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
					url : url,
					method : "POST"
				}),
				reader :  new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "instw",
					fields : ["instw","insti", "inclb", "code", "desc","spec", "manf", "batNo", "expDate",
							"freQty", "uom", "uomDesc","buom","buomDesc", "rp", "sp", "countQty",
							"countDate","countTime","userName"]
				})
	});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : InstDetailStore,
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
					B['Params']=gStrDetailParams;
					B['actiontype']='INStkTkItmWd';
					if(this.fireEvent("beforechange",this,B)!==false){
						this.store.load({params:B});
					}
				}
			});
		
	StatuTabPagingToolbar.addListener('beforechange',function(toolbar,params){
		var records=InstDetailStore.getModifiedRecords();
		var nextPage=true;
		if(records.length>0){
			Ext.Msg.show({
			   title:'��ʾ',
			   msg: '��ҳ���ݷ����ı䣬�Ƿ���Ҫ���棿',
			   buttons: Ext.Msg.YESNOCANCEL,
			   fn: function(btn,text,opt){
			   		if(btn=='yes'){
			   			save();
			   			nextPage=false;
			   		}
			   },
			   animEl: 'elId',
			   icon: Ext.MessageBox.QUESTION
			});
		}
		
		if(nextPage==false){
			return false;
		}
	});
	
	var InstDetailGrid = new Ext.grid.EditorGridPanel({
				id:'InstDetailGrid',
				region : 'center',
				cm : InstDetailGridCm,
				store : InstDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : new Ext.grid.CellSelectionModel(),
				loadMask : true,
				bbar : StatuTabPagingToolbar,
				clicksToEdit:1
			});
	
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			style: 'padding:0 0 0 0;',
			tbar:[SearchBT,'-',SaveBT,'-',CompleteBT,'-',RefreshBT,'-',SetDefaultBT,'-',SetDefaultBT2],
			items:[{
					xtype:'fieldset',
					//title:'��ѯ����',
					layout: 'column',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:5px 0 0 0;',
					items : [{ 				
						columnWidth: 0.34,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 180, border:false},    // Default config options for child items
		            	//defaultType: 'textfield',
		            	autoHeight: true,
		            	boderStyle: 'padding:0 0 0 0;',
		            	style: 'padding:0 0 0 0;',
		            	border: false,
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
		               	//	"margin-bottom": "10px"
		            	//},
		            	items: [LocManaGrp,StkBin]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [StkGrpType,DHCStkCatGroup]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [PhaWindow,Complete]
						
					}]
				}]  	
		});
	
		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [{
			                region: 'west',
			                split: true,
                			width: 420,
                			minSize: 200,
                			maxSize: 420,
                			//collapsible: true,                			
                			tbar:[PhaLoc,'����:',StartDate,EndDate,QueryBT],
			                layout: 'fit', // specify layout manager for items
			                items: MasterInfoGrid      
			               
			            }, {             
			                region: 'center',	                	
		                	layout: 'border', // specify layout manager for items
		                	items: [{
		                		region:'north',
		                		height:140,
		                		layout:'fit',
		                		items:[form ]
		                	},{
		                		region:'center',
		                		layout:'fit',
		                		items:[InstDetailGrid]
		                	}]    
			            
			            }
	       			],
					renderTo : 'mainPanel'
		});
		
	//�Զ������̵㵥
	Query();
})
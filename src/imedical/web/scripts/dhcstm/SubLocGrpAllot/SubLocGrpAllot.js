// /����: רҵ�����ʷ���
// /����: רҵ���쵽�����ʸ���Ȩ�ؽ����÷��䵽ҽ������
// /��д�ߣ�	wangjiabin
// /��д����:2014-02-20
//gAllotId:csp�д��ݲ���(���䵥rowid)
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var gUserId = session['LOGON.USERID'];
		var gLocId=session['LOGON.CTLOCID'];
		var gGroupId=session['LOGON.GROUPID'];

		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
			disabled:true
		});
		
		var uGroupList=new Ext.data.Store({		 
			url:"dhcstm.sublocusergroupaction.csp?actiontype=FilterLocGroupList",
			reader:new Ext.data.JsonReader({
				totalProperty:'results',
				root:"rows",
				idProperty:'RowId'
			},['RowId','Description'])
		});
		//רҵ��
		var UserGroup = new Ext.ux.ComboBox({
			fieldLabel : 'רҵ��',
			id : 'UserGroup',
			name : 'UserGroup',
			store:uGroupList,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'PhaLoc'},
			disabled:true
		});
		
		var CreateDate = new Ext.ux.DateField({
			fieldLabel : '�Ƶ�����',
			id : 'CreateDate',
			name : 'CreateDate',
			anchor : '90%',
			
			disabled : true
		});
		
		var CreateTime = new Ext.form.TextField({
			fieldLabel : '�Ƶ�ʱ��',
			id : 'CreateTime',
			name : 'CreateTime',
			anchor : '90%',
			regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
			disabled : true
		});

		var AllotNo = new Ext.form.TextField({
			fieldLabel : '���䵥��',
			id : 'AllotNo',
			name : 'AllotNo',
			anchor : '90%',
			width : 120,
			disabled : true
		});

		var CreateUser = new Ext.form.TextField({
			id:'CreateUser',
			fieldLabel:'�Ƶ���',
			anchor:'90%',
			disabled:true
		});
		
		var StkGrpType = new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor : '90%',
//			LocId:gLocId,
//			UserId:gUserId,
			disabled : true
		});

		var AllotMon = new Ext.form.TextField({
			id:'AllotMon',
			fieldLabel:'���䵥�·�',
			anchor:'90%',
			disabled:true
		});
		
		// ��ɱ�־
		var CompleteFlag = new Ext.form.Checkbox({
			boxLabel : '���',
			hideLabel : true,
			id : 'CompleteFlag',
			name : 'CompleteFlag',
			anchor : '90%',
			checked : false,
			disabled:true
		});
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				GrpAllotFind(Query);
			}
		});

		/**
		 * ��ѯ����
		 */
		function Query(slga) {
			if (slga == null || slga.length <= 0 || slga <= 0) {
				return;
			}
			var url = DictUrl
					+ "sublocgrpallotaction.csp?actiontype=Select&slga=" + slga;
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						var list = jsonData.info.split("^")
						if (list.length > 0) {
							gAllotId=slga;
							addComboData(Ext.getCmp("PhaLoc").getStore(),list[6],list[7]);
							Ext.getCmp("PhaLoc").setValue(list[6]);
							addComboData(Ext.getCmp("UserGroup").getStore(),list[8],list[9]);
							Ext.getCmp("UserGroup").setValue(list[8]);
							Ext.getCmp("AllotNo").setValue(list[1]);
							Ext.getCmp("CreateUser").setValue(list[5]);
							Ext.getCmp("CreateDate").setValue(list[2]);
							Ext.getCmp("CreateTime").setValue(list[3]);
							addComboData(Ext.getCmp("StkGrpType").getStore(),list[16],list[17],StkGrpType);
							Ext.getCmp("StkGrpType").setValue(list[16]);
							Ext.getCmp("CompleteFlag").setValue(list[14]=='Y'?true:false);
							Ext.getCmp("AllotMon").setValue(list[18]);
							if (Ext.getCmp("CompleteFlag").getValue()){changeButtonEnable("0^0^0^1");}
							else{changeButtonEnable("1^1^1^1");}
							// ��ʾ���䵥��ϸ����
							getDetail(slga);
						}
					} else {
						Msg.info("warning", jsonData.info);
					}
				},
				scope : this
			});
		}
		
		function getDetail(slga) {
			if (slga == null || slga.length <= 0 || slga <= 0) {
				return;
			}
			DetailStore.load({params:{start:0,limit:999,slga:slga}});
			ScaleStore.load({params:{start:0,limit:999,sort:'',dir:'',slga:slga}});
		}
		
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
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
			Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
				f.setValue("");
			});
			DetailStore.removeAll();
			ScaleStore.removeAll();
			gAllotId="";
			//������ܴ���href����
			CheckLocationHref();
			changeButtonEnable("1^1^1^1");
		}

		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
			id : 'SaveBT',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				var CompFlag = Ext.getCmp("CompleteFlag").getValue();
				if (CompFlag != null && CompFlag != 0) {
					Msg.info("warning", "���䵥�����!");
					return;
				}
				if(ScaleGrid.activeEditor != null){
					ScaleGrid.activeEditor.completeEdit();
				}
				saveData();
			}
		});
		
		function saveData(){
			var count = ScaleStore.getCount();
			var ListScaleStr = "";
			for (var i = 0; i < count; i++) {
				var rowData = ScaleStore.getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var slgas = rowData.get('slgas');
					var UserId = rowData.get('UserId');
					var ScaleValue = rowData.get('ScaleValue');
					var ScaleStr = slgas+"^"+UserId+"^"+ScaleValue;
					if(ListScaleStr==""){
						ListScaleStr = ScaleStr;
					}else{
						ListScaleStr = ListScaleStr + RowDelim + ScaleStr;
					}
				}
			}
			if(ListScaleStr==null || ListScaleStr==""){
				Msg.info("warning","û����Ҫ�������ϸ!");
				return;
			}
			
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
				url: DictUrl+"sublocgrpallotaction.csp?actiontype=SaveScale",
				method:'POST',
				waitMsg : '������...',
				params:{slga:gAllotId,ListScaleStr:ListScaleStr},
				success:function(result,request) {
					loadMask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if(jsonData.success=='true'){
						Msg.info("success","����ɹ�!");
						Query(gAllotId);
						changeButtonEnable("1^1^1^1");
					}else{
						Msg.info("error","����ʧ��"+jsonData.info);
					}
				}
			})
		}
		
		var DeleteBT = new Ext.Toolbar.Button({
			id : "DeleteBT",
			text : 'ɾ��',
			tooltip : '���ɾ��',
			width : 70,
			height : 30,
			iconCls : 'page_delete',
			handler : function() {
				deleteData();
			}
		});
		
		function deleteData() {
			var CompFlag = Ext.getCmp("CompleteFlag").getValue();
			if (CompFlag != null && CompFlag != 0) {
				Msg.info("warning", "���䵥����ɲ���ɾ��!");
				return;
			}
			if (gAllotId == "") {
				Msg.info("warning", "û����Ҫɾ���ķ��䵥!");
				return;
			}
			Ext.MessageBox.show({
				title : '��ʾ',
				msg : '�Ƿ�ȷ��ɾ�����ŷ��䵥?',
				buttons : Ext.MessageBox.YESNO,
				fn : showDeleteGr,
				icon : Ext.MessageBox.QUESTION
			});
		}

		/**
		 * ɾ�����䵥��ʾ
		 */
		function showDeleteGr(btn) {
			if (btn == "yes") {
				var url = DictUrl
						+ "sublocgrpallotaction.csp?actiontype=Delete&slga=" + gAllotId;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '��ѯ��...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									// ɾ������
									Msg.info("success", "���䵥ɾ���ɹ�!");
									clearData();
									changeButtonEnable("1^1^1^1");
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", "���䵥�Ѿ���ɣ�����ɾ��!");
									}else if(ret==-2){
										Msg.info("error", "���䵥�Ѿ���ˣ�����ɾ��!");
									}else{
										Msg.info("error", "ɾ��ʧ��,��鿴������־!");
									}
								}
							},
							scope : this
						});
			}
		}
		
		// ��ɰ�ť
		var CompleteBT = new Ext.Toolbar.Button({
					id : "CompleteBT",
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						SetComplete("Y");
					}
				});

		// ȡ����ɰ�ť
		var CancleCompleteBT = new Ext.Toolbar.Button({
					id : "CancleCompleteBT",
					text : 'ȡ�����',
					tooltip : '���ȡ�����',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						SetComplete("N");
					}
				});
		/**
		 * ���(ȡ�����)���䵥
		 */
		function SetComplete(Comp) {
			// �жϷ��䵥�Ƿ������
			var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
			if (Comp=="Y" && CompleteFlag==true) {
				Msg.info("warning", "���䵥�����!");
				return;
			}
			if (Comp=="N" && CompleteFlag==false) {
				Msg.info("warning", "���䵥��δ���!");
				return;
			}
			if (gAllotId == null || gAllotId == "") {
				Msg.info("warning", "û����Ҫ�����ķ��䵥!");
				return;
			}
			var url = DictUrl
					+ "sublocgrpallotaction.csp?actiontype=setComplete&slga="
					+ gAllotId + "&CompFlag=" + Comp;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "�ɹ�!");
								Query(gAllotId);
								changeButtonEnable("0^0^0^1");
							} else {
								var Ret=jsonData.info;
								if(Ret==-1){
									Msg.info("error", "���䵥Ȩ��֮�Ͳ���Ϊ0!");
								}else if(Ret==-2){
									Msg.info("error", "���䵥�Ѿ����!");
								}else if(Ret==-3){
									Msg.info("error", "���䵥�Ѿ����!");
								}else {
									Msg.info("error", "����ʧ��:"+Ret);
								}
							}
						},
						scope : this
					});
		}
		// �����ť�Ƿ����
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			//����^ɾ��^���^ȡ�����
			SaveBT.setDisabled(list[0]);
			DeleteBT.setDisabled(list[1]);
			CompleteBT.setDisabled(list[2]);
			CancleCompleteBT.setDisabled(list[3]);
		}
		var DeleteDetailBT = new Ext.Toolbar.Button({
			id:'DeleteDetailBT',
			text:'ɾ��һ��',
			tooltip:'���ɾ��',
			width:70,
			height:30,
			iconCls:'page_delete',
			handler:function(){
				deleteDetail();
			}
		});
		
		function deleteDetail() {
			var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
			if (CmpFlag != null && CmpFlag != false) {
				Msg.info("warning", "���䵥����ɲ���ɾ��!");
				return;
			}
			var SelRecord = DetailGrid.getSelectionModel().getSelected();
			if (SelRecord == null) {
				Msg.info("warning", "û��ѡ����!");
				return;
			}
			var slgai = SelRecord.get("slgai");
			if (slgai == "" ) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
			} else {
				Ext.MessageBox.show({
					title : '��ʾ',
					msg : '�Ƿ�ȷ��ɾ����������Ϣ?',
					buttons : Ext.MessageBox.YESNO,
					fn : showResult,
					icon : Ext.MessageBox.QUESTION
				});
			}
		}
		function showResult(btn) {
			if (btn == "yes") {
				var SelRecord = DetailGrid.getSelectionModel().getSelected();
				var slgai = SelRecord.get("slgai");

				// ɾ����������
				var url = DictUrl
						+ "sublocgrpallotaction.csp?actiontype=DeleteDetail&slgai=" + slgai;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '��ѯ��...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "ɾ���ɹ�!");
									DetailStore.reload();
									ScaleStore.reload();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", "���䵥�Ѿ���ɣ�����ɾ��!");
									}else if(ret==-2){
										Msg.info("error", "���䵥�Ѿ���ˣ�����ɾ��!");
									}else{
										Msg.info("error", "ɾ��ʧ��,��鿴������־!");
									}
								}
							},
							scope : this
						});
			}
		}
		
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([
				nm,{
					header : "�����id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'inciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'inciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'Abbrev',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : 'Ʒ��',
					dataIndex : 'Brand',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�ͺ�",
					dataIndex : 'Model',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '���۽��',
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					sortable : false
				}, {
					header : '�ۼ۽��',
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					sortable : false
				}
		]);
		DetailCm.defaultSortable = true;
		
		// ����·��
		var DetailUrl = DictUrl
					+ 'sublocgrpallotaction.csp?actiontype=queryItem';
		// ͨ��AJAX��ʽ���ú�̨����
		var DetailProxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���
		var fieldsDetail = ["slgai","inci","inciCode","inciDesc","qty","uom","uomDesc","rpAmt","spAmt","Abbrev","Brand","Model","Spec"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var DetailReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "slgai",
					fields : fieldsDetail
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : DetailProxy,
					reader : DetailReader
				});
				
		var DetailGrid = new Ext.grid.GridPanel({
			region:'center',
			title:'���䵥��ϸ',
			cm : DetailCm,
			store : DetailStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask : true,
			tbar : [DeleteDetailBT]
		});
		
		var nmScale = new Ext.grid.RowNumberer();
		var ScaleCm = new Ext.grid.ColumnModel([
				nmScale, {
					header : "����Ȩ��Id",
					dataIndex : 'slgas',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "��Աid",
					dataIndex : 'UserId',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "��Ա",
					dataIndex : 'UserName',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����Ȩ��",
					dataIndex : 'ScaleValue',
					width : 140,
					align : 'right',
					sortable : true,
					editable : true,
					editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false
					})
				},{
					header : "������(����)",
					dataIndex : 'ScaleRpAmt',
					width : 100,
					align : 'right',
					sortable : true
				},{
					header : "������(�ۼ�)",
					dataIndex : 'ScaleSpAmt',
					width : 100,
					align : 'right',
					sortable : true
				}
		]);
		ScaleCm.defaultSortable = false;
		
		var ScaleStore = new Ext.data.JsonStore({
			autoDestroy: true,
			url : DictUrl + 'sublocgrpallotaction.csp?actiontype=queryScale',
			fields : ["slgas","UserId","UserName","ScaleValue","ScaleRpAmt","ScaleSpAmt"],
			root:'rows'
		});
		
		var ScaleGrid = new Ext.grid.EditorGridPanel({
			region:'south',
			title:'רҵ�鹫֧����Ȩ��',
			height:gGridHeight,
			collapsible : true,
			cm : ScaleCm,
			store : ScaleStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			clicksToEdit : 1,
			listeners : {
				beforeedit:function(e){
					if(Ext.getCmp("CompleteFlag").getValue()==true){
						return false;
					}
				}
			}
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			id : 'HisListTab',
			title: 'רҵ��Ȩ�ط���',
			tbar : [SearchBT, '-', ClearBT, '-', SaveBT, '-', DeleteBT, '-', CompleteBT, '-', CancleCompleteBT],
			items:[{
				xtype : 'fieldset',
				title : '���䵥��Ϣ',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items:[{
						columnWidth:0.25,
						items:[PhaLoc,UserGroup]
					},{
						columnWidth:0.22,
						items:[AllotNo,AllotMon]
					},{
						columnWidth:0.21,
						items:[CreateDate,CreateTime]
					},{
						columnWidth:0.22,
						items:[CreateUser,StkGrpType]
					},{
						columnWidth:0.1,
						items:[CompleteFlag]
					}]
			}]
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,DetailGrid,ScaleGrid],
			renderTo : 'mainPanel'
		});
		
		if(gAllotId!=null && gAllotId!=''){
			Query(gAllotId);
		}
})
// /名称: 专业组物资分配
// /描述: 专业组领到的物资根据权重将费用分配到医生个人
// /编写者：	wangjiabin
// /编写日期:2014-02-20
//gAllotId:csp中传递参数(分配单rowid)
Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var gUserId = session['LOGON.USERID'];
		var gLocId=session['LOGON.CTLOCID'];
		var gGroupId=session['LOGON.GROUPID'];

		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
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
		//专业组
		var UserGroup = new Ext.ux.ComboBox({
			fieldLabel : '专业组',
			id : 'UserGroup',
			name : 'UserGroup',
			store:uGroupList,
			valueField:'RowId',
			displayField:'Description',
			params:{SubLoc:'PhaLoc'},
			disabled:true
		});
		
		var CreateDate = new Ext.ux.DateField({
			fieldLabel : '制单日期',
			id : 'CreateDate',
			name : 'CreateDate',
			anchor : '90%',
			
			disabled : true
		});
		
		var CreateTime = new Ext.form.TextField({
			fieldLabel : '制单时间',
			id : 'CreateTime',
			name : 'CreateTime',
			anchor : '90%',
			regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText:'时间格式错误，正确格式hh:mm:ss',
			disabled : true
		});

		var AllotNo = new Ext.form.TextField({
			fieldLabel : '分配单号',
			id : 'AllotNo',
			name : 'AllotNo',
			anchor : '90%',
			width : 120,
			disabled : true
		});

		var CreateUser = new Ext.form.TextField({
			id:'CreateUser',
			fieldLabel:'制单人',
			anchor:'90%',
			disabled:true
		});
		
		var StkGrpType = new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor : '90%',
//			LocId:gLocId,
//			UserId:gUserId,
			disabled : true
		});

		var AllotMon = new Ext.form.TextField({
			id:'AllotMon',
			fieldLabel:'分配单月份',
			anchor:'90%',
			disabled:true
		});
		
		// 完成标志
		var CompleteFlag = new Ext.form.Checkbox({
			boxLabel : '完成',
			hideLabel : true,
			id : 'CompleteFlag',
			name : 'CompleteFlag',
			anchor : '90%',
			checked : false,
			disabled:true
		});
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				GrpAllotFind(Query);
			}
		});

		/**
		 * 查询方法
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
				waitMsg : '查询中...',
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
							// 显示分配单明细数据
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
		
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			iconCls : 'page_clearscreen',
			width : 70,
			height : 30,
			handler : function() {
				clearData();
			}
		});

		/**
		 * 清空方法
		 */
		function clearData() {
			Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
				f.setValue("");
			});
			DetailStore.removeAll();
			ScaleStore.removeAll();
			gAllotId="";
			//清除可能存在href变量
			CheckLocationHref();
			changeButtonEnable("1^1^1^1");
		}

		// 保存按钮
		var SaveBT = new Ext.Toolbar.Button({
			text : '保存',
			tooltip : '点击保存',
			id : 'SaveBT',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				var CompFlag = Ext.getCmp("CompleteFlag").getValue();
				if (CompFlag != null && CompFlag != 0) {
					Msg.info("warning", "分配单已完成!");
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
				//新增或数据发生变化时执行下述操作
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
				Msg.info("warning","没有需要保存的明细!");
				return;
			}
			
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
				url: DictUrl+"sublocgrpallotaction.csp?actiontype=SaveScale",
				method:'POST',
				waitMsg : '处理中...',
				params:{slga:gAllotId,ListScaleStr:ListScaleStr},
				success:function(result,request) {
					loadMask.hide();
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if(jsonData.success=='true'){
						Msg.info("success","保存成功!");
						Query(gAllotId);
						changeButtonEnable("1^1^1^1");
					}else{
						Msg.info("error","保存失败"+jsonData.info);
					}
				}
			})
		}
		
		var DeleteBT = new Ext.Toolbar.Button({
			id : "DeleteBT",
			text : '删除',
			tooltip : '点击删除',
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
				Msg.info("warning", "分配单已完成不可删除!");
				return;
			}
			if (gAllotId == "") {
				Msg.info("warning", "没有需要删除的分配单!");
				return;
			}
			Ext.MessageBox.show({
				title : '提示',
				msg : '是否确定删除整张分配单?',
				buttons : Ext.MessageBox.YESNO,
				fn : showDeleteGr,
				icon : Ext.MessageBox.QUESTION
			});
		}

		/**
		 * 删除分配单提示
		 */
		function showDeleteGr(btn) {
			if (btn == "yes") {
				var url = DictUrl
						+ "sublocgrpallotaction.csp?actiontype=Delete&slga=" + gAllotId;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '查询中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									// 删除单据
									Msg.info("success", "分配单删除成功!");
									clearData();
									changeButtonEnable("1^1^1^1");
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", "分配单已经完成，不能删除!");
									}else if(ret==-2){
										Msg.info("error", "分配单已经审核，不能删除!");
									}else{
										Msg.info("error", "删除失败,请查看错误日志!");
									}
								}
							},
							scope : this
						});
			}
		}
		
		// 完成按钮
		var CompleteBT = new Ext.Toolbar.Button({
					id : "CompleteBT",
					text : '完成',
					tooltip : '点击完成',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						SetComplete("Y");
					}
				});

		// 取消完成按钮
		var CancleCompleteBT = new Ext.Toolbar.Button({
					id : "CancleCompleteBT",
					text : '取消完成',
					tooltip : '点击取消完成',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						SetComplete("N");
					}
				});
		/**
		 * 完成(取消完成)分配单
		 */
		function SetComplete(Comp) {
			// 判断分配单是否已完成
			var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
			if (Comp=="Y" && CompleteFlag==true) {
				Msg.info("warning", "分配单已完成!");
				return;
			}
			if (Comp=="N" && CompleteFlag==false) {
				Msg.info("warning", "分配单尚未完成!");
				return;
			}
			if (gAllotId == null || gAllotId == "") {
				Msg.info("warning", "没有需要操作的分配单!");
				return;
			}
			var url = DictUrl
					+ "sublocgrpallotaction.csp?actiontype=setComplete&slga="
					+ gAllotId + "&CompFlag=" + Comp;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '查询中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "成功!");
								Query(gAllotId);
								changeButtonEnable("0^0^0^1");
							} else {
								var Ret=jsonData.info;
								if(Ret==-1){
									Msg.info("error", "分配单权重之和不可为0!");
								}else if(Ret==-2){
									Msg.info("error", "分配单已经完成!");
								}else if(Ret==-3){
									Msg.info("error", "分配单已经审核!");
								}else {
									Msg.info("error", "操作失败:"+Ret);
								}
							}
						},
						scope : this
					});
		}
		// 变更按钮是否可用
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			//保存^删除^完成^取消完成
			SaveBT.setDisabled(list[0]);
			DeleteBT.setDisabled(list[1]);
			CompleteBT.setDisabled(list[2]);
			CancleCompleteBT.setDisabled(list[3]);
		}
		var DeleteDetailBT = new Ext.Toolbar.Button({
			id:'DeleteDetailBT',
			text:'删除一条',
			tooltip:'点击删除',
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
				Msg.info("warning", "分配单已完成不能删除!");
				return;
			}
			var SelRecord = DetailGrid.getSelectionModel().getSelected();
			if (SelRecord == null) {
				Msg.info("warning", "没有选中行!");
				return;
			}
			var slgai = SelRecord.get("slgai");
			if (slgai == "" ) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
			} else {
				Ext.MessageBox.show({
					title : '提示',
					msg : '是否确定删除该物资信息?',
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

				// 删除该行数据
				var url = DictUrl
						+ "sublocgrpallotaction.csp?actiontype=DeleteDetail&slgai=" + slgai;
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '查询中...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "删除成功!");
									DetailStore.reload();
									ScaleStore.reload();
								} else {
									var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", "分配单已经完成，不能删除!");
									}else if(ret==-2){
										Msg.info("error", "分配单已经审核，不能删除!");
									}else{
										Msg.info("error", "删除失败,请查看错误日志!");
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
					header : "库存项id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'inciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'inciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "简称",
					dataIndex : 'Abbrev',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '品牌',
					dataIndex : 'Brand',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "型号",
					dataIndex : 'Model',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					sortable : false
				}, {
					header : '售价金额',
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					sortable : false
				}
		]);
		DetailCm.defaultSortable = true;
		
		// 访问路径
		var DetailUrl = DictUrl
					+ 'sublocgrpallotaction.csp?actiontype=queryItem';
		// 通过AJAX方式调用后台数据
		var DetailProxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fieldsDetail = ["slgai","inci","inciCode","inciDesc","qty","uom","uomDesc","rpAmt","spAmt","Abbrev","Brand","Model","Spec"];
		// 支持分页显示的读取方式
		var DetailReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "slgai",
					fields : fieldsDetail
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : DetailProxy,
					reader : DetailReader
				});
				
		var DetailGrid = new Ext.grid.GridPanel({
			region:'center',
			title:'分配单明细',
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
					header : "分配权重Id",
					dataIndex : 'slgas',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "人员id",
					dataIndex : 'UserId',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "人员",
					dataIndex : 'UserName',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "分配权重",
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
					header : "分配金额(进价)",
					dataIndex : 'ScaleRpAmt',
					width : 100,
					align : 'right',
					sortable : true
				},{
					header : "分配金额(售价)",
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
			title:'专业组公支分配权重',
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
			title: '专业组权重分配',
			tbar : [SearchBT, '-', ClearBT, '-', SaveBT, '-', DeleteBT, '-', CompleteBT, '-', CancleCompleteBT],
			items:[{
				xtype : 'fieldset',
				title : '分配单信息',
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

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab,DetailGrid,ScaleGrid],
			renderTo : 'mainPanel'
		});
		
		if(gAllotId!=null && gAllotId!=''){
			Query(gAllotId);
		}
})
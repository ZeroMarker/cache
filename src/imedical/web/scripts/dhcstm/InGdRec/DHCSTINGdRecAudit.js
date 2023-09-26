// /名称:入库审核
// /描述: 入库审核
// /编写者：zhangdongmei
// /编写日期: 2012.07.05
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var actionUrl = DictUrl+"ingdrecaction.csp"
	
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}
	//取高值管理参数
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// 入库部门
		var PhaLoc=new Ext.ux.LocComboBox({
			fieldLabel : '入库部门',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			width : 120,
			emptyText : '入库部门...',
			groupId:gGroupId,
			childCombo : 'Vendor'
		});
		
		var VirtualFlag = new Ext.form.Checkbox({
			hideLabel:true,
			boxLabel : G_VIRTUAL_STORE,
			id : 'VirtualFlag',
			name : 'VirtualFlag',
			anchor : '90%',
			checked : false,
			listeners:{
				check:function(chk,bool){
					if(bool){
						var phaloc=Ext.getCmp("PhaLoc").getValue();
						var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
						var response=ExecuteDBSynAccess(url);
						var jsonData=Ext.util.JSON.decode(response);
						if(jsonData.success=='true'){
							var info=jsonData.info;
							var infoArr=info.split("^");
							var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
							addComboData(Ext.getCmp("PhaLoc").getStore(),vituralLoc,vituralLocDesc);
							Ext.getCmp("PhaLoc").setValue(vituralLoc);
						}
					}else{
						SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
					}
				}
			}
		});
		
		var Vendor = new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			params : {LocId : 'PhaLoc'}
		});
		
		// 起始日期
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 100,
			value : DefaultStDate()
		});

		// 截止日期
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '截止日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 100,
			value : DefaultEdDate()
		});

		// 审批
		var InGrFlag = new Ext.form.Checkbox({
			fieldLabel : '已审批',
			id : 'InGrFlag',
			name : 'InGrFlag',
			anchor : '90%',
			width : 120,
			checked : false
		});
		
		//是否打印
		var Printflagdata = [['全部','1'],['已打印','2'],['未打印','3']];
	    
		var PrintflagStore = new Ext.data.SimpleStore({
			fields : ['PrintDesc','PrintId'],
			data :  Printflagdata
		});

		var PrintFlag = new Ext.form.ComboBox({
		    fieldLabel : '是否打印',
		    mode: 'local',
		    id : 'PrintFlag',
		    name : 'PrintFlag',
		    anchor : '90%',
		    emptyText : '',
		    store : PrintflagStore,
		    displayField : 'PrintDesc',
		    valueField : 'PrintId',
		    triggerAction :'all'/**/
		});
		Ext.getCmp("PrintFlag").setValue("1");
		
        var FindTypeData=[['全部','All'],['赠送','G'],['调价换票','A']];
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});
		var FindTypeFlag = new Ext.form.ComboBox({
			store: FindTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'FindTypeFlag',
			fieldLabel : '赠送或调价换票',
			triggerAction:'all',
			valueField : 'typeid'
		});
		Ext.getCmp("FindTypeFlag").setValue("All");
		function GiftFlagRender(value) {
			if (value == "Y") {
				return '赠送';
			}
		}
		function AdjChequeRender(value) {
			if (value == "Y") {
				return '调价换票';
			}
		}
		var CreateUser = new Ext.ux.ComboBox({
			id : 'CreateUser',
			fieldLabel : '制单人',
			store : UStore,
			params : {locId : 'PhaLoc'},
			filterName : 'name'
		});
		
		var RequestLoc = new Ext.ux.LocComboBox({
			fieldLabel : '接收科室',
			id : 'RequestLoc',
			anchor:'90%',
			emptyText : '接收科室...',
			defaultLoc:{}
		});
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			id:"SearchBT",
			text : '查询',
			tooltip : '点击查询',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				MasterGrid.load();
			}
		});
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			id:'ClearBT',
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});
		// 审核确认按钮
		var CheckBT = new Ext.Toolbar.Button({
			id:'CheckBT',
			text : '审核通过',
			tooltip : '点击审核通过',
			width : 70,
			height : 30,
			iconCls : 'page_gear',
			disabled : true,
			handler : function() {
				if(IngrParamObj.ConfirmBeforeAudit == 'Y'){
					Ext.MessageBox.show({
						title : '提示',
						msg : '是否审核该入库单?',
						buttons : Ext.MessageBox.YESNO,
						fn: function(b,t,o){
							if (b=='yes'){
								Audit();
							}
						},
						icon : Ext.MessageBox.QUESTION
					});
				}else{
					Audit();
				}
			}
		});

		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
			id:'PrintBT',
			text : '打印',
			tooltip : '点击打印',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "请选择需要打印的入库单!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var DhcIngr=record.get("IngrId");
					var HVflag=GetCertDocHVFlag(DhcIngr,"G");
					if (HVflag=="Y"){
					 PrintRecHVCol(DhcIngr);
					}else{
					PrintRec(DhcIngr);
					}
				}
			}
		});
		// 打印按钮
		var PrintHVCol = new Ext.Toolbar.Button({
			id:'PrintHVCol',
			text : '高值汇总打印',
			tooltip : '打印高值入库单票据',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "请选择需要打印的入库单!");
					return;
				}
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var DhcIngr=record.get("IngrId");
					var HVflag=GetCertDocHVFlag(DhcIngr,"G");
					if (HVflag=="Y"){
						PrintRecHVCol(DhcIngr);
					}else{
						Msg.info("warning","非高值单据使用打印按钮即可!");
						return;
					}
				}
			}
		});

		var SaveInvBT = new Ext.ux.Button({
			id:'SaveInvBT',
			text : '保存发票信息',
			tooltip : '点击保存发票信息',
			width : 70,
			height : 30,
			iconCls : 'page_save',
			handler : function() {
				if(DetailGrid.activeEditor!=null){
					DetailGrid.activeEditor.completeEdit();
				}
				var successNum = 0, gTrType = 'G';
				var rowCount = DetailGrid.getStore().getCount();
				var mr = DetailGrid.getModifiedRecords();
				var len = mr.length;
				if (rowCount<=0||len<=0){
					Msg.info("waring","没有需要保存的明细!");
				}
				for (var i=0; i<len; i++){
					var rowData = mr[i];
					var RowId = rowData.get('Ingri');
					var invNo = rowData.get("InvNo");
					var invAmt = rowData.get("InvMoney");
					var invDate = Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
					var sxNo = '';
					var StrParam = gTrType+"^"+RowId+"^"+invNo+"^"+invAmt+"^"+invDate
								+"^"+sxNo;
					var ret = tkMakeServerCall("web.DHCSTM.DHCINGdRecInv","UpdateINV",StrParam);
					if(ret != 0){
						var InciDesc = rowData.get('IncDesc');
						Msg.info("error", IncDesc+"发票信息保存失败!");
					}else if(++successNum == len){
						Msg.info("success","保存成功!");
						DetailGrid.getStore().commitChanges();
						DetailGrid.getStore().reload();
					}
				}
			}
		});
		
		/**
		 * 清空方法
		 */
		function clearData() {
			clearPanel(HisListTab);
			HisListTab.getForm().setValues({StartDate:DefaultStDate(),EndDate:DefaultEdDate()});
			MasterGrid.removeAll();
			DetailGrid.removeAll();
			CheckBT.setDisabled(true);
			PrintBT.setDisabled(true);
			PrintHVCol.setDisabled(true);
		}
		
		/**
		 * 审核方法
		 */
		function Audit() {
			var InGrStr=""
			var rowDataArr = MasterGrid.getSelectionModel().getSelections();
			if (rowDataArr.length<1) {   
				Msg.info("warning", "请选择需要审核的入库单!");
				return;
			}
			var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			if (InGrFlag || InGrFlag == "true") {
				Msg.info("warning", "入库单已审核!");
				return;
			}
			for(i=0;i<rowDataArr.length;i++){
				var rowData=rowDataArr[i];
				var DhcIngr = rowData.get("IngrId");
				///检查高值材料标签录入情况,非补录入库单审核才检查
			    var oerecflag=tkMakeServerCall("web.DHCSTM.DHCINGdRec","GetOeriRecFlag",DhcIngr);
			    if((oerecflag!="Y")&&(UseItmTrack) && (CheckHighValueLabels("G",DhcIngr)==false)){
				    //loadMask.hide();
				    return;
			    }
				if (InGrStr==""){
					InGrStr=DhcIngr;
				}else{
					InGrStr=InGrStr+"^"+DhcIngr;
				}
			}
			if(InGrStr==""){Msg.info("warning", "没有可以审核的单据!");return}
			var loadMask=ShowLoadMask(document.body,"审核中...");	
			var url = DictUrl
					+ "ingdrecaction.csp?actiontype=AuditStr&RowidStr="
					+ InGrStr + "&User=" + userId;
            Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					loadMask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success", "审核成功!");
						MasterGrid.load();
						Print(InGrStr)
					}
					else{
						var ret=jsonData.info;// 审核单据
						var retarr=ret.split(",");
						var suc=Number(retarr[0]);
						var fail=Number(retarr[1]);
						var sucret=retarr[2];
						var failret=retarr[3];
						if (suc==0){Msg.info("error", "共"+(fail+suc)+"张,失败"+fail+"张!"+failret);}
						else{Msg.info("error", "共"+(fail+suc)+"张,成功"+suc+"张,失败"+fail+"张!"+failret);}
						MasterGrid.load();
						Print(sucret)
					}
				},
				scope : this
			});
		}

		function Print(InGrStr)
		{
		    //根据参数设置自动打印
			if(gParam[4]=='Y'){
				var InGrStr = InGrStr.split("^");
				for(j=0;j<InGrStr.length;j++){
					var Ingr=InGrStr[j]
					var HVflag=GetCertDocHVFlag(Ingr,"G");
					if (HVflag=="Y"){
						PrintRecHVCol.defer(300,this,[Ingr,'Y']);
					}else{
						PrintRec.defer(300,this,[Ingr,'Y']);
					}
				}
			}
		}
		
		var MasterCm = [ {
					header : "rowid",
					dataIndex : 'IngrId',
					width : 60,
					hidden : true
				}, {
					header : "单号",
					dataIndex : 'IngrNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '入库部门',
					dataIndex : 'RecLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '接收科室',
					dataIndex : 'ReqLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '供货商',
					dataIndex : 'Vendor',
					width : 170,
					align : 'left'
				}, {
					header : '资金来源',
					dataIndex : 'SourceOfFund',
					width : 80,
					renderer : SourceOfFundRender
				},  {
					header : "入库日期",
					dataIndex : 'CreateDate',
					width : 80,
					align : 'left'
				}, {
					header : "制单人",
					dataIndex : 'CreateUser',
					width : 60,
					align : 'left'
				}, {
					header : "入库类型",
					dataIndex : 'IngrType',
					width : 70,
					align : 'left'
				}, {
					header : "审核人",
					dataIndex : 'AuditUser',
					width : 60,
					align : 'left'
				}, {
					header : '审核日期',
					dataIndex : 'AuditDate',
					width : 80,
					align : 'left'
				}, {
					header : "订单号",
					dataIndex : 'PoNo',
					width : 110,
					align : 'left'
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 80,
					xtype:'numbercolumn'
				}, {
					header : "售价金额",
					dataIndex : 'SpAmt',
					xtype : 'numbercolumn',
					width : 80,
					align : 'right'
				}, {
					header : "进销差价",
					xtype : 'numbercolumn',
					dataIndex : 'Margin',
					width : 80
				}, {
					header : "备注",
					dataIndex : 'InGrRemarks',
					width : 160,
					align : 'left'
				},{
					dataIndex:"Complete",
					hidden : true,
					hideable : false
				},{
					dataIndex:"ReqLoc",
					hidden : true,
					hideable : false
				},{
					dataIndex : "StkGrp",
					hidden : true,
					hideable : false
				},{
					header: "赠送标志",
					dataIndex: 'GiftFlag',
					width: 120,
					align: 'left',
					sortable: false,
					renderer: GiftFlagRender
				},{
					header: "调价换票标志",
					dataIndex: 'AdjCheque',
					width: 120,
					align: 'left',
					sortable: false,
					renderer: AdjChequeRender
				}];
		
		var MasterGrid = new Ext.dhcstm.EditorGridPanel({
			region : 'center',
			title: '入库单',
			id:'MasterGrid',
			childGrid : "DetailGrid",
			region : 'center',
			editable : false,
			contentColumns : MasterCm,
			smType : 'checkbox',
			singleSelect : false,
			checkOnly : true,
			smRowSelFn : rowSelFn,
			autoLoadStore : true,
			actionUrl : actionUrl,
			queryAction : "Query",
			paramsFn : GetMasterParams,
			idProperty : 'IngrId',
			showTBar : false
		});
		
		function rowSelFn(sm, rowIndex, r) {
			var rowData = sm.grid.getAt(rowIndex);
			var InGrRowId = rowData.get("IngrId");
			DetailGrid.load({params:{Parref:InGrRowId}});
			
			var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			if (InGrFlag || InGrFlag == "true") {
				CheckBT.setDisabled(true);
				PrintBT.setDisabled(false);
				PrintHVCol.setDisabled(false);
			} else {
				CheckBT.setDisabled(false);
				PrintBT.setDisabled(true);
				PrintHVCol.setDisabled(true);
				/* 单选
				var model=MasterGrid.getSelectionModel();
				var rowCount = MasterGrid.getStore().getCount();
				for (var i = 0; i < rowCount; i++) {
					if(i!=rowIndex){
						model.deselectRow(i,false)
					}						
				}
				*/
			}
		}
				
		function GetMasterParams(){
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			var Vendor = Ext.getCmp("Vendor").getValue();
			var StartDate = Ext.getCmp("StartDate").getValue();
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(PhaLoc==""){
				Msg.info("warning", "请选择入库部门!");
				return false;
			}
			if(StartDate==""){
				Msg.info("warning", "请选择开始日期!");
				return false;
			}else{
				StartDate=StartDate.format(ARG_DATEFORMAT).toString();
			}
			if(EndDate==""){
				Msg.info("warning", "请选择截止日期!");
				return false;
			}else{
				EndDate=EndDate.format(ARG_DATEFORMAT).toString();
			}
			var Findtype=Ext.getCmp("FindTypeFlag").getValue();
			var InGrFlag = (Ext.getCmp("InGrFlag").getValue()==true?'Y':'N');
			var PrintFlag =Ext.getCmp("PrintFlag").getValue();
			var CreateUser = Ext.getCmp("CreateUser").getValue();
			var RequestLoc = Ext.getCmp("RequestLoc").getValue();  //接收科室
			var ListParam=StartDate+'^'+EndDate+'^'+''+'^'+Vendor+'^'+PhaLoc
				+'^Y^^'+InGrFlag+"^"+""+"^"+userId
				+'^'+CreateUser+"^"+"audit"+"^"+PrintFlag+"^"+Findtype+"^"+RequestLoc;
			
			return {"ParamStr":ListParam};
		}
		
		var DetailCm = [{
					header : "Ingri",
					dataIndex : 'Ingri',
					width : 80,
					hidden : true
				}, {
					header : "IncId",
					dataIndex : 'IncId',
					width : 70,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "物资代码",
					dataIndex : 'IncCode',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : '物资名称',
					dataIndex : 'IncDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : '高值条码',
					dataIndex : 'HVBarCode',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : '规格',
					dataIndex : 'Spec',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "生产厂商",
					dataIndex : 'Manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "批次Id",
					dataIndex : 'Inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "批号",
					dataIndex : 'BatchNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "有效期",
					dataIndex : 'ExpDate',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '单位',
					dataIndex : 'IngrUom',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : "数量",
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "进价",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "发票号",
					dataIndex : 'InvNo',
					width : 80,
					align : 'left',
					sortable : true,
					editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var invNo = field.getValue();
									if (invNo == null || invNo.length <= 0) {
										Msg.info("warning", "发票号不能为空!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var col = GetColIndex(DetailGrid,"InvDate")
									DetailGrid.startEditing(cell[0], col);
								}
							}
						}
					})
				}, {
					header : "发票日期",
					dataIndex : 'InvDate',
					xtype : 'datecolumn',
					width : 90,
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var invDate = field.getValue();
									if (invDate == null || invDate.length <= 0) {
										Msg.info("warning", "发票日期不能为空!");											
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var col = GetColIndex(DetailGrid,"InvMoney")
									DetailGrid.startEditing(cell[0], col);
								}
							}
						}
					})
				}, {
					header : "发票金额",
					dataIndex : 'InvMoney',
					width : 80,
					align : 'left',
					sortable : true,
					editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : true,
						allowNegative : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var InvMoney= field.getValue();
									if (Number(InvMoney) <= 0) {
										Msg.info("warning", "发票金额不能为空!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									if(!Ext.isEmpty(DetailGrid.getAt(cell[0]+1))){
										var col = GetColIndex(DetailGrid,"InvNo")
										DetailGrid.startEditing(cell[0]+1, col);
									}
								}
							}
						}
					})
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					xtype : 'numbercolumn'
				}, {
					header : "售价金额",
					dataIndex : 'SpAmt',
					xtype : 'numbercolumn'
				}, {
					header : "进销差价",
					dataIndex : 'Margin',
					xtype : 'numbercolumn'
				},{
					header : "备注",
					dataIndex : 'Remarks',
					width : 90,
					align : 'left',
					sortable : true
	            }];
		
		var DetailGrid = new Ext.dhcstm.EditorGridPanel({
			region: 'south',
			height : gGridHeight,
			split: true,
			minSize: 200,
			maxSize: 350,
			collapsible: true,
			title: '入库单明细',
			id : 'DetailGrid',
			contentColumns : DetailCm,
			actionUrl : actionUrl,
			queryAction : "QueryDetail",
			selectFirst : false,
			idProperty : "Ingri",
			checkProperty : "IncId",
			paging : false,
			showTBar : false
		});
		
		var HisListTab = new Ext.ux.FormPanel({
			labelWidth : 60,
			title:'入库单审核',
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [SearchBT, '-', ClearBT, '-', CheckBT, '-', PrintBT, '-',PrintHVCol, '-',SaveInvBT],
			items:[{
				xtype:'fieldset',
				title:'查询条件',
				layout: 'column',
				style:'padding:5px 0px 0px 0px;',
				defaults: {width: 220, border:false},
				items : [{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [PhaLoc, CreateUser,RequestLoc]
					},{
						columnWidth: UseItmTrack?0.1:0.01,
						xtype: 'fieldset',
						items: UseItmTrack?[VirtualFlag]:[]
					},{
						columnWidth: 0.2,
						xtype: 'fieldset',
						items: [StartDate,EndDate]
					},{
						columnWidth: 0.25,
						xtype: 'fieldset',
						items: [Vendor,FindTypeFlag]
					},{
						columnWidth: 0.2,
						xtype: 'fieldset',
						items: [InGrFlag,PrintFlag]
					}]
			}]
		});

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterGrid, DetailGrid],
			renderTo : 'mainPanel'
		});
	}
})
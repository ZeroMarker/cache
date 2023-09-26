// /名称: 调价单生效与修改
// /描述: 调价单生效与修改
// /编写者：zhangdongmei
// /编写日期: 2013.01.07

Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ItmDesc = new Ext.ux.TextField({
				fieldLabel : '物资名称',
				id : 'ItmDesc',
				name : 'ItmDesc',
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == 13) {
							var item=field.getValue();
							if (item != null && item.length > 0) {
								GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", gHospId,getDrugList);
								
							}
						}
					}
				}
			});

	// 调价单号
	var AspBatNo = new Ext.ux.TextField({
				fieldLabel : '调价单号',
				id : 'AspBatNo',
				name : 'AspBatNo'
				
			});

	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			value : new Date().add(Date.DAY,-1)
		});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
			fieldLabel : '结束日期',
			id : 'EndDate',
			name : 'EndDate',
			value : new Date()
		});

	var TypeStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [ ['A', '已审核未生效'],
						['Y', '已生效']]
			});
	var Type = new Ext.ux.LocalComboBox({
				fieldLabel : '调价单状态',
				id : 'Type',
				name : 'Type',
				store : TypeStore
			});
	Ext.getCmp("Type").setValue("A");
	
	// 查询
	var SearchBT = new Ext.ux.Button({
				id : "SearchBT",
				text : '查询',
				iconCls : 'page_find',
				handler : function() {
					getAspBatDetail();
				}
			});

	// 清空按钮
	var ClearBT = new Ext.ux.Button({
				id : "ClearBT",
				text : '清空',
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * 清空方法
	 */
	function clearData() {
		gInciRowId="";
		Ext.getCmp("AspBatNo").setValue("");
		Ext.getCmp("ItmDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("Type").setValue("A");
		//Ext.getCmp("SupplyPhaLoc").setDisabled(0);

		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		// 变更按钮是否可用
		//changeButtonEnable("1^1^1^1^1^0^0^0");
	}

	// 立即生效按钮
	var ExecuteBT = new Ext.ux.Button({
				id : "ExecuteBT",
				text : '立即生效',
				iconCls : 'page_gear',
				handler : function() {					
					// 立即生效调价单
					ExecuteAspBat();
				}
			});

	/**
	 * 立即生效调价单
	 */
	function ExecuteAspBat() {
		//获得选择项
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		var StrAspBatId="";
		for (var i = 0; i < rowCount; i++) {				
			//循环每条选择的数据
			if(sm.isSelected(i)){
				var record = store.getAt(i);
				var status=record.get("Status");
				if(status=="已生效"){
					Msg.info("warning","已经生效的记录不能重复生效!");
					return;
				}
				if(record.dirty){
					Msg.info("warning","存在修改过的记录，请先保存!");
					return;
				}
				var detailId = record.get('AspBatId');	
				if(StrAspBatId==""){
					StrAspBatId=detailId;
				}
				else{
					StrAspBatId=StrAspBatId+"^"+detailId;
				}
			}
		}
		if(StrAspBatId==""){
			Msg.info("warning","没有需要立即生效的数据!");
			return;
		}		
		var mask=ShowLoadMask(Ext.getBody(),"处理中...");
		var Params=gGroupId+"^"+gLocId+"^"+gUserId
		//提交数据库执行审批
		Ext.Ajax.request({
			url : DictUrl+'inadjpricebatchaction.csp?actiontype=Execute',
			method : 'POST',
			params:{StrAspBatId:StrAspBatId,Params:Params},
			success : function(response) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", "成功！");
				}else if(jsonData.info==-3){
					Msg.info("warning", "错误：存在已生效的调价单,不能重复生效!");
					return;
				}else{
					Msg.info("error", "错误:"+jsonData.info);
					return;
				}
				
				getAspBatDetail();
			},
			failure : function(response){
				Msg.info("error", "发生错误："+response.responseText);					
				return;
			}
		});		
	}
	
	// 提交修改
	var UpdateBT = new Ext.ux.Button({
		id : "UpdateBT",
		text : '保存',
		iconCls : 'page_save',
		handler : function() {					
			// 修改调后售价
			UpdateAsp();
		}
	});
	
	// 修改调后售价
	function UpdateAsp(){
		var count=DetailGrid.getStore().getCount();
		var strdata=null;
		for(var i=0;i<count;i++){
			var record=DetailGrid.getStore().getAt(i);
			//数据发生变化时执行下述操作
			if(record.dirty){
				var aspBatId=record.get("AspBatId");
				var resultSp=record.get("ResultSpUom");
				var resultRp=record.get("ResultRpUom");
				var status=record.get("Status");
				var exedate=record.get("ExecuteDate");
				
				var today=new Date().format(DateFormat);
				if((status=="已生效")&&(exedate!=today)){
					continue;     //对于已生效记录，只允许该当天生效的调后价格
				}
				if(strdata==null){
					strdata=aspBatId+"^"+resultSp+"^"+resultRp;
				}else{
					strdata=strdata+xRowDelim()+aspBatId+"^"+resultSp+"^"+resultRp;
				}
			}
		}
		if(strdata==null){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}
		var Params=gGroupId+"^"+gLocId+"^"+gUserId
		var mask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url:DictUrl+ 'inadjpricebatchaction.csp?actiontype=UpdatePriceAPB',
			method:'POST',
			params:{ListData:strdata,Params:Params},
			success:function(response){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", "更新成功！");
				}else{
					Msg.info("error", "错误:"+jsonData.info);
					return;
				}
				
				getAspBatDetail();
			}
		});
	}
	// 调价明细
	// 访问路径
	var DetailUrl =DictUrl+ 'inadjpricebatchaction.csp?actiontype=QueryAspBatInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
					
	// 指定列参数
	var fields = ["AspBatId", "AspBatNo","Incib","StkCatDesc", "InciId", "InciCode","InciDesc", 
			 "AspUomDesc","PriorSpUom", "ResultSpUom", "DiffSpUom",
			"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate","Status","ExecuteDate",
			"PreExecuteDate", "AdjReason","Remark",  "AdjUserName","MarkType", "PriceFileNo", "MaxSp","BatExp","AspUomId"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "AspBatId",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					StartDate:'',
					EndDate:'',
					Others:''
				}
			});
			
	//录入调后进价和售价后重新计算差价
	DetailStore.on("update",function(store,record,opt){
		var priorsp=record.get("PriorSpUom");
		var resultsp=record.get("ResultSpUom");
		var priorrp=record.get("PriorRpUom");
		var resultrp=record.get("ResultRpUom");
		record.set("DiffSpUom",Math.round((resultsp-priorsp)*10000)/10000);
		record.set("DiffRpUom",Math.round((resultrp-priorrp)*10000)/10000);
	});
	var detailSM = new Ext.grid.CheckboxSelectionModel();
	//注册选择监听事件
	/*
	detailSM.on('selectionchange',function(thisSM){
			var selRows=thisSM.getCount();
			if(selRows<=0){
				deleteBT.disable();
			}else{
				deleteBT.enable();
			}
	});
	*/
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, detailSM,{
				header : "AspBatId",
				dataIndex : 'AspBatId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "调价单号",
				dataIndex : 'AspBatNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {   
			       header : "Incib",
				dataIndex : 'Incib',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "状态",
				dataIndex : 'Status',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "库存分类",
				dataIndex : 'StkCatDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资代码',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'InciDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "调价单位",
				dataIndex : 'AspUomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
			       header : "批次/效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "调前进价",
				dataIndex : 'PriorRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "调前售价",
				dataIndex : 'PriorSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "调后进价",
				dataIndex : 'ResultRpUom',
				width : 90,
				align : 'right',
				sortable : true,
				editor:new Ext.ux.NumberField({
					formatType : 'FmtRP',
					allowBlank:false
				})
			}, {
				header : "调后售价",
				dataIndex : 'ResultSpUom',
				width : 80,
				align : 'right',
				sortable : true,
				editor:new Ext.ux.NumberField({
					formatType : 'FmtSP',
					allowBlank:false
				})
			}, {
				header : "差价(售价)",
				dataIndex : 'DiffSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "差价(进价)",
				dataIndex : 'DiffRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "制单日期",
				dataIndex : 'AdjDate',
				width : 80,
				align : 'left',
				sortable : true				
			}, {
				header : "计划生效日期",
				dataIndex : 'PreExecuteDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "实际生效日期",
				dataIndex : 'ExecuteDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "调价原因",
				dataIndex : 'AdjReason',
				width : 100,
				align : 'left',					
				sortable : true
			}, {
				header : "调价人",
				dataIndex : 'AdjUserName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "定价类型",
				dataIndex : 'MarkType',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "物价文件号",
				dataIndex : 'PriceFileNo',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "最高售价",
				dataIndex : 'MaxSp',
				width : 90,
				align : 'right',
				sortable : true
			}]);

	var DetailPageToolBar=new Ext.ux.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize
	});
	DetailPageToolBar.addListener('beforechange',function(ptbar,params){
		var records=DetailGrid.getStore().getModifiedRecords();
		if(records.length>0){
			Msg.info("warning","当前有记录数据发生变化,请先处理在翻页!!");
			return false;
			}
	})
	var DetailGrid = new Ext.ux.EditorGridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '调价单(批次)明细',
		cm : DetailCm,
		store : DetailStore,
		sm :detailSM,
		bbar:DetailPageToolBar,
		listeners:{
			'afteredit':function(e){
				if(e.field=='ResultRpUom'){
					var resultRpNew = e.value;
					if (resultRpNew == null || resultRpNew.length <= 0) {
						Msg.info("warning", "调后进价不能为空!");
						return;
					}else if (resultRpNew<0) {
						Msg.info("warning", "调后进价不能小于0!");
						return;
					}else{
						SetMtSpINCIB(resultRpNew,e.record );
					}
				}else if(e.field=='ResultSpUom'){
					var resultSpNew = e.value;
					if(resultSpNew == null || resultSpNew.length <= 0) {
						Msg.info("warning", "调后售价不能为空!");
						return;
					}else if(resultSpNew<0) {
						Msg.info("warning", "调后售价不能小于0!");
						return;
					}else{
						var resultRpNew = e.record.get("ResultRpUom");
						if(resultSpNew<resultRpNew){
							Msg.info("error", "第"+(e.row+1)+"行调后售价小于调后进价!");
						}
					}
				}
			}
			
			
			
		}
	});
	DetailGrid.addListener('beforeedit',function(e){
	   var status=e.record.get("Status");
	   var exedate=e.record.get("ExecuteDate");
	   var today=new Date().format(DateFormat);
		if(status=="已审核"){
	   		Msg.info("warning","此记录尚未生效，请取消审核后修改价格！");
	   		e.cancel=true;
			return;
	   }
		if((status=="已生效")&(exedate!=today)){
	   		Msg.info("warning","此记录不是今天生效，不能修改价格！");
	   		e.cancel=true;
			return;
	   }
	});
	
	//录入调后进价后设置调后售价
	function SetMtSpINCIB(Rp,record){
		var uomId=record.get("AspUomId");
		var inci=record.get("InciId");
		if(inci==null || inci==""){
			return;
		}
		if(uomId==null || uomId==""){
			return;
		}
		if(Rp==null || Rp==""){
			return;
		}
		//根据定价类型计算售价
		if(GetCalSpFlag()==1){
			var sp=tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMtSp",inci,uomId,Rp);      //ExecuteDBSynAccess(url); 返回值有空格导致数据保存不成功
			if(sp==0){
				Msg.info("warning","调后售价为0，请检查该物资定价类型是否正确！");
			}
			record.set("ResultSpUom",sp);  
		}
	}		
	/**
	 * 返回方法
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		;
		Ext.getCmp("ItmDesc").setValue(inciDesc);
		gInciRowId=inciDr;		
	}
	
	// 显示调价单数据
	function getAspBatDetail() {
		DetailStore.removeAll();
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if(InciDesc==null || InciDesc==""){
			gInciRowId="";
		}
		var InciRowid=gInciRowId;
		if(InciRowid!=""&InciRowid!=null){
			InciDesc="";
		}
		var AspBatNo=Ext.getCmp("AspBatNo").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		var Status=Ext.getCmp("Type").getValue();
		var Others=AspBatNo+"^"+Status+"^"+InciRowid+"^^"+InciDesc
		if (StartDate == null || StartDate.length <= 0 ) {
			Msg.info("warning", "开始日期不能为空！");
			Ext.getCmp("StartDate").focus();
			return;
		}
		else{
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		if (EndDate == null || EndDate.length <= 0 ) {
			Msg.info("warning", "截止日期不能为空！");
			Ext.getCmp("EndDate").focus();
			return;
		}
		else{
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		var pagesize=DetailPageToolBar.pageSize;
		DetailStore.load({
			params:{start:0,limit:pagesize},
			callback : function(r,options,success) {
				if(success==false){
		 			Msg.info("error", "查询错误，请查看日志!");
		 		}         				
			}
		});
	}
	
	var MainForm = new Ext.ux.FormPanel({
		title:'调价单(批次)生效',
		tbar : [SearchBT, '-', ClearBT, '-',  ExecuteBT, '-',UpdateBT],
		items : [{					
			xtype : 'fieldset',
			title : '查询条件',
			defaults:{border:false,xtype:'fieldset'},
			layout : 'column',
			style : 'padding:5px 0px 0px 5px',
			items : [{
				columnWidth : .22,
				items : [StartDate,EndDate]
			},{
				columnWidth : .22,
				items : [Type]
			},{
				columnWidth : .28,
				items : [AspBatNo]
			},{
				columnWidth : .28,
				items : [ItmDesc]
			}]								
		}]
	});
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [MainForm, DetailGrid]
	});			
	getAspBatDetail();    //页面加载后显示已审核单据
});
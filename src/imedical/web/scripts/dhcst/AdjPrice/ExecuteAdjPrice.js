// /名称: 调价单生效与修改
// /描述: 调价单生效与修改
// /编写者：zhangdongmei
// /编写日期: 2013.01.07
var rpdecimal=8;
var spdecimal=8;
Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ItmDesc = new Ext.form.TextField({
				fieldLabel : $g('药品名称'),
				id : 'ItmDesc',
				name : 'ItmDesc',
				anchor:'90%',
				width : 140,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == 13) {
							//alert(App_StkTypeCode)
							var item=field.getValue();
							if (item != null && item.length > 0) {
								GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",getDrugList);
								
							}
						}
					}
				}
			});

	// 调价单号
	var AdjSpNo = new Ext.form.TextField({
				fieldLabel : $g('调价单号'),
				id : 'AdjSpNo',
				name : 'AdjSpNo',
				anchor:'90%',
				width : 100
			});

	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel : $g('起始日期'),
			id : 'StartDate',
			name : 'StartDate',
			anchor:'90%',
			width : 120,
			value : new Date().add(Date.DAY,-1)
		});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
			fieldLabel : $g('结束日期'),
			id : 'EndDate',
			name : 'EndDate',
			anchor:'90%',
			width : 120,
			value : new Date()
		});

	var TypeStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [ ['Audit', $g('已审核未生效')],
						['Yes', $g('已生效')]]
			});
	var Type = new Ext.form.ComboBox({
				fieldLabel : $g('调价单状态'),
				id : 'Type',
				name : 'Type',
				width : 120,
				anchor:'90%',
				store : TypeStore,
				triggerAction : 'all',
				mode : 'local',
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				editable : false,
				valueNotFoundText : ''
			});
	Ext.getCmp("Type").setValue("Audit");
	
	// 查询
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : $g('查询'),
				tooltip : $g('点击查询'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					getAspDetail();
				}
			});

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : $g('清屏'),
				tooltip : $g('点击清屏'),
				width : 70,
				height : 30,
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
		Ext.getCmp("AdjSpNo").setValue("");
		Ext.getCmp("ItmDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1).format(App_StkDateFormat));
		Ext.getCmp("EndDate").setValue(new Date().format(App_StkDateFormat));
		Ext.getCmp("Type").setValue("Audit");
		//Ext.getCmp("SupplyPhaLoc").setDisabled(0);

		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		// 变更按钮是否可用
		//changeButtonEnable("1^1^1^1^1^0^0^0");
	}

	// 立即生效按钮
	var ExecuteBT = new Ext.Toolbar.Button({
				id : "ExecuteBT",
				text : $g('立即生效'),
				tooltip : $g('点击立即生效'),
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {					
					// 立即生效调价单
					//ExecuteAsp();
					CheckIfHavenAdjDay();
				}
			});
	
		// 生效之前判断今日是否有已经的调价记录  2020-01013 yangsj
	function CheckIfHavenAdjDay()
	{
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		var StrAspId="";
		var sureExeflag=""
		for (var i = 0; i < rowCount; i++) {				
			//循环每条选择的数据
			if(sm.isSelected(i)){
					var record = store.getAt(i);
					var status=record.get("Status");
					if(status=="已生效"){
						Msg.info("warning",$g("已经生效的记录不能重复生效!"));
						return;
					}
					if(record.dirty){
						Msg.info("warning",$g("存在修改过的记录，请先保存!"));
						return;
					}
					var detailId = record.get('AspId');	
					var incidesc=record.get('InciDesc');	
					var ret=tkMakeServerCall("web.DHCST.INAdjSalePrice","CheckIfHavenAdjDay",detailId)
					if  (ret=="Y") 
					{
						Msg.info("warning",incidesc+$g("药品今日存在已经生效的记录，请确认是否继续生效!"));
						record.set("Status","今日已有生效记录");
						sureExeflag=1;
						record.dirty = false;  
						//DetailGrid.getView().getRow(i).style.backgroundColor = "red";
					}
				
				}
			}
		if(sureExeflag==1) 
		{
			    Ext.Msg.confirm($g('提示'),$g('存在今日已生效的调价药品，是否继续调价？')+"<br>"+"<font color='red'>"+$g("注意：多次生效会导致一个完整的业务流程周期中出现多个价格；如发药前后价格不一致。如医保上传价格后调价导致调后价格和医保上传不一致。请谨慎操作！")+"</font>",
							      function(btn){
								if(btn=='yes'){
								  ExecuteAsp();					
								}else{
								  return;
								}
							 },this);
		}
		else ExecuteAsp();		
	}		

	/**
	 * 立即生效调价单
	 */
	function ExecuteAsp() {
		//获得选择项
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		var StrAspId="";
		for (var i = 0; i < rowCount; i++) {				
			//循环每条选择的数据
			if(sm.isSelected(i)){
				var record = store.getAt(i);
				var status=record.get("Status");
				if(status=="已生效"){
					Msg.info("warning",$g("已经生效的记录不能重复生效!"));
					return;
				}
				if(record.dirty){
					Msg.info("warning",$g("存在修改过的记录，请先保存!"));
					return;
				}
				var detailId = record.get('AspId');	
				if(StrAspId==""){
					StrAspId=detailId;
				}
				else{
					StrAspId=StrAspId+"^"+detailId;
				}
			}
		}
		if(StrAspId==""){
			Msg.info("warning",$g("没有需要立即生效的数据!"));
			return;
		}		
		var mask=ShowLoadMask(Ext.getBody(),$g("处理中..."));
		//提交数据库执行审批
		Ext.Ajax.request({
			url : DictUrl+'inadjpriceaction.csp?actiontype=Execute',
			method : 'POST',
			params:{StrAspId:StrAspId},
			success : function(response) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				var jsonDataArr=jsonData.info.split("^")
				if(jsonDataArr[0]==0){
					Msg.info("success", $g("成功！"));
				}else if(jsonDataArr[0]==-3){
					Msg.info("warning", $g("错误：存在已生效的调价单,不能重复生效!"));
					return;
				}else if(jsonDataArr[0]==-7){
					Msg.info("warning", $g("错误：")+jsonDataArr[1]+$g("今日存在已生效的调价单,今日不能再生效!"));
					return;
				}else{
					Msg.info("error", $g("错误:")+jsonData.info);
					return;
				}
				
				getAspDetail();
			},
			failure : function(response){
				Msg.info("error", $g("发生错误：")+response.responseText);					
				return;
			}
		});		
	}
	
	// 提交修改
	var UpdateBT = new Ext.Toolbar.Button({
		id : "UpdateBT",
		text : $g('保存'),
		tooltip : $g('点击保存'),
		width : 70,
		height : 30,
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
				var aspId=record.get("AspId");
				var resultSp=record.get("ResultSpUom");
				var resultRp=record.get("ResultRpUom");
				var status=record.get("Status");
				var exedate=record.get("ExecuteDate");
				var today=new Date().format(App_StkDateFormat);
				if (resultSp<resultRp) {
					Msg.info("warning",$g( "第")+(i+1)+$g("行调后售价小于调后进价!"));
					return false;
					break;
				}
				if((status=="已生效")&&(exedate!=today)){
					continue;     //对于已生效记录，只允许该当天生效的调后价格
				}
				if(strdata==null){
					strdata=aspId+"^"+resultSp+"^"+resultRp;
				}else{
					strdata=strdata+xRowDelim()+aspId+"^"+resultSp+"^"+resultRp;
				}
			}
		}
		if(strdata==null){
			Msg.info("warning",$g("没有需要保存的数据!"));
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),$g("处理中..."));
		Ext.Ajax.request({
			url:DictUrl+ 'inadjpriceaction.csp?actiontype=UpdatePrice',
			method:'POST',
			params:{ListData:strdata},
			success:function(response){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", $g("更新成功！"));
				}else{
					Msg.info("error", $g("错误:")+jsonData.info);
					return;
				}
				
				getAspDetail();
			}
		});
	}
	
		function StatusColorRenderer(val,meta){
			if (val==$g("今日已有生效记录"))
			meta.css='classRed';
			return val
		
		}
	
	// 调价明细
	// 访问路径
	var DetailUrl =DictUrl+ 'inadjpriceaction.csp?actiontype=QueryAspInfo';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
					
	// 指定列参数
	var fields = ["AspId", "AspNo","StkCatDesc", "InciId", "InciCode","InciDesc","AspUomId",
			 "AspUomDesc","PriorSpUom", "ResultSpUom", "DiffSpUom",
			"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate","Status","ExecuteDate",
			"PreExecuteDate", "AdjReason","Remark",  "AdjUserName","MarkType", "PriceFileNo", "MaxSp"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "AspId",
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
				header : "AdjSpRowId",
				dataIndex : 'AspId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("调价单号"),
				dataIndex : 'AspNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("状态"),
				dataIndex : 'Status',
				width : 130,
				align : 'center',
				sortable : true,
				renderer:StatusColorRenderer
			},{
				header : $g("库存分类"),
				dataIndex : 'StkCatDesc',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "InciId",
				dataIndex : 'InciId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('药品代码'),
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('药品名称'),
				dataIndex : 'InciDesc',
				width : 230,
				align : 'left',
				sortable : true
			},  {
				header : "AspUomId",
				dataIndex : 'AspUomId',
				width : 230,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : $g("调价单位"),
				dataIndex : 'AspUomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : $g("调前进价"),
				dataIndex : 'PriorRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("调前售价"),
				dataIndex : 'PriorSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("调后进价"),
				dataIndex : 'ResultRpUom',
				width : 90,
				align : 'right',
				sortable : true,
				editor:new Ext.form.NumberField({
					id:'ResultRpUomEditor',
					allowBlank:false,
					decimalPrecision:rpdecimal,
				})
			}, {
				header : $g("调后售价"),
				dataIndex : 'ResultSpUom',
				width : 80,
				align : 'right',
				sortable : true,
				editor:new Ext.form.NumberField({
					id:'ResultSpUomEditor',
					allowBlank:false,
					decimalPrecision:spdecimal,
				})
			}, {
				header : $g("差价(售价)"),
				dataIndex : 'DiffSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("差价(进价)"),
				dataIndex : 'DiffRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : $g("制单日期"),
				dataIndex : 'AdjDate',
				width : 80,
				align : 'left',
				sortable : true				
			}, {
				header : $g("计划生效日期"),
				dataIndex : 'PreExecuteDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("实际生效日期"),
				dataIndex : 'ExecuteDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("调价原因"),
				dataIndex : 'AdjReason',
				width : 100,
				align : 'left',					
				sortable : true
			}, {
				header : $g("调价人"),
				dataIndex : 'AdjUserName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("定价类型"),
				dataIndex : 'MarkType',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("物价文件号"),
				dataIndex : 'PriceFileNo',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("最高售价"),
				dataIndex : 'MaxSp',
				width : 90,
				align : 'right',
				sortable : true
			}]);

	var DetailPageToolBar=new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g('没有记录'),
		firstText:$g('第一页'),
		lastText:$g('最后一页'),
		nextText:$g('下一页'),
		prevText:$g('上一页')		
	});
	DetailPageToolBar.addListener('beforechange',function(ptbar,params){
		var selrows=DetailGrid.getSelectionModel().getCount();
		if(selrows>0){
			Msg.info("warning",$g("当前页记录发生了变化，请先处理后再翻页！"));
			return false;
		}
	})
	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : $g('调价单明细'),
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm :detailSM,
				//clicksToEdit : 1,
				bbar:DetailPageToolBar,
				listeners:{
						'beforeedit':function(e)
						{
							/*取配置,动态设置小数保留位数
							if((e.field=="ResultRpUom")||(e.field=="ResultSpUom")){
								  var adjpriceuomid=e.record.get('AspUomId');
								  var adjpriceinci=e.record.get('InciId');
								  var decimalstr=tkMakeServerCall("web.DHCST.Common.AppCommon","GetDecimalCommon",gGroupId,gLocId,gUserId,adjpriceinci,adjpriceuomid);
								  var decimalarr=decimalstr.split("^");
								  Ext.getCmp("ResultRpUomEditor").decimalPrecision=decimalarr[0];
								  Ext.getCmp("ResultSpUomEditor").decimalPrecision=decimalarr[2];
							}*/
						}
					}
			});
	DetailGrid.addListener('beforeedit',function(e){
	   var status=e.record.get("Status");
	   var exedate=e.record.get("ExecuteDate");
	   var today=new Date().format(App_StkDateFormat);
		//if((status=="已生效")&(exedate!=today)){
		if((status==$g("已生效"))){
	   		//Msg.info("warning","此记录不是今天生效，不能修改价格！");
	   		e.cancel=true;
	   }
	   return;
	});
	
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
	function getAspDetail() {
		DetailStore.removeAll();
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		var InciRowid="";
		if(InciDesc!=null & InciDesc!="" & InciDesc.length >0){
			InciRowid=gInciRowId;
		}else{
			gInciRowId="";
		}
		var AspNo=Ext.getCmp("AdjSpNo").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		var Status=Ext.getCmp("Type").getValue();
		var Others=AspNo+"^"+Status+"^"+InciRowid+"^"
		if (StartDate == null || StartDate.length <= 0 ) {
			Msg.info("warning", $g("开始日期不能为空！"));
			Ext.getCmp("StartDate").focus();
			return;
		}
		else{
			StartDate=StartDate.format(App_StkDateFormat);
		}
		if (EndDate == null || EndDate.length <= 0 ) {
			Msg.info("warning", $g("截止日期不能为空！"));
			Ext.getCmp("EndDate").focus();
			return;
		}
		else{
			EndDate=EndDate.format(App_StkDateFormat);
		}
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		var pagesize=DetailPageToolBar.pageSize;
		DetailStore.load({
			params:{start:0,limit:pagesize},
			callback : function(r,options,success) {
				if(success==false){
		 			Msg.info("error", $g("查询错误，请查看日志!"));
		 		}         				
			}
		});
	}
	
	var MainForm = new Ext.form.FormPanel({
		labelWidth : 90,
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		title:$g('调价单生效'),
		tbar : [SearchBT, '-', ClearBT, '-', UpdateBT , '-',ExecuteBT],
		items : [{					
				xtype : 'fieldset',
				title : $g('查询条件'),
				style: DHCSTFormStyle.FrmPaddingV,
				defaults:{border:false},
				layout : 'column',									
				items : [{
					columnWidth : .18,
					xtype : 'fieldset',
					items : [StartDate]
				},{
					columnWidth : .18,
					xtype : 'fieldset',
					items : [EndDate]
				},{
					columnWidth : .2,
					xtype : 'fieldset',
					items : [Type]
				},{
					columnWidth : .2,
					xtype : 'fieldset',
					items : [AdjSpNo]
				},{
					columnWidth : .2,
					xtype : 'fieldset',
					items : [ItmDesc]
				}]								
		}]
				
	});

	// 页签
	var panel = new Ext.Panel({
				activeTab : 0,
				height : DHCSTFormStyle.FrmHeight(1),
				region : 'north',
				layout:'fit',
				items : [MainForm]
			});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [panel, DetailGrid]
			});			
	getAspDetail();    //页面加载后显示已审核单据
});
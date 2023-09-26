// /名称: 物资批次价格统计
// /描述: 物资批次价格统计
// /编写者：lxt
// /编写日期: 2017.09.26
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:sssStkGrpType,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 
	
	var DHCStkCatGroup = new Ext.ux.form.LovCombo({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		listWidth : 200,
		anchor: '90%',
		separator:',',	//库存分类id用,连接
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'},
		triggerAction : 'all'
	});
	
	var InciDr = new Ext.form.TextField({
		fieldLabel : '物资RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});
	
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stkGrp=Ext.getCmp("StkGrpType").getValue();
					var inputText=field.getValue();
					GetPhaOrderInfo(inputText,stkGrp);
				}
			}
		}
	});
	
	function GetPhaOrderInfo(item, group) {			
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
				getDrugList);
		}
	}

	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(inciDesc);
		Ext.getCmp("InciDr").setValue(inciDr);
	}
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		params : {ScgId : 'StkGrpType'}
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '厂商',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {ScgId : 'StkGrpType'}
	});
	
	var BatNo = new Ext.ux.TextField({
		id : 'BatNo',
		fieldLabel : '批号',
		formatType : 'BatNo',
		width : '70',
		valueNotFoundText : ''
	});
	
	var MaxRp = new Ext.ux.NumberField({
		id : 'MaxRp',
		formatType : 'FmtRP',
		width : '70',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.ux.NumberField({
		id : 'MinRp',
		formatType : 'FmtRP',
		width : '70',
		valueNotFoundText : ''
	});
	
	// 高值标志
	var hvFlag = new Ext.form.RadioGroup({
		id : 'hvFlag',
		items : [
			{boxLabel:'全部',name:'hv_Flag',id:'all',inputValue:'',checked:true},
			{boxLabel:'高值',name:'hv_Flag',id:'hv',inputValue:'Y'},
			{boxLabel:'非高值',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});
	
	// 收费标志
	var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		items : [
			{boxLabel:'全部',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'收费',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'不收费',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});	
	
	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '统计',
				tooltip : '点击统计',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					ShowReport();
				}
			});
	
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
						f.setValue("");
					});
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					Ext.getCmp("Vendor").getStore().load();
					Ext.getCmp("PhManufacturer").getStore().load();
					Ext.getCmp("MinRp").setValue("");
					Ext.getCmp("MaxRp").setValue("");
					Ext.getCmp("BatNo").setValue("");
					FlagItmBatRp.setValue(true);
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});

    function ShowReport() {
		
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","开始日期或截止日期不能为空！");
			return;
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		if(StkCatId!=""&StkCatId!=null){
			StkCatId=","+StkCatId+",";
		}
		
		var VendorId=Ext.getCmp("Vendor").getValue();				//供应商id
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//生产厂商id
		var MinRp=Ext.getCmp("MinRp").getValue();				//最低进价
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//最高进价
		var BatNo=Ext.getCmp("BatNo").getValue();				//最高进价
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		
		var inciDr=Ext.getCmp("InciDr").getValue();	
		var InciDesc=Ext.getCmp("InciDesc").getValue();	
		if (InciDesc==null || InciDesc=="") {
			inciDr = "";
		}
		
		var Others=inciDr+"^"+BatNo+"^"+ManfId+"^"+VendorId+"^"+MinRp
			+"^"+MaxRp+"^"+hvFlag+"^"+charge;

		//取出查询条件
		var Conditions="";
		if(StartDate!=""){
			Conditions=Conditions+" 统计时间: "+StartDate
		}
		if(EndDate!=""){
			Conditions=Conditions+"~ "+EndDate
		}
		if(GrpType!=""){
			Conditions=Conditions+" 类组: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(StkCatId!=""){
			Conditions=Conditions+" 库存分类: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		if(MinRp!=""||MaxRp!=""){
			Conditions=Conditions+" 进价范围: "+MinRp+" ~ "+MaxRp
		}
		//取出查询条件
		var p = Ext.getCmp("main-tabs").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = PmRunQianUrl+'?reportName=DHCSTM_ItmBatRp.raq&StartDate='+
			StartDate +'&EndDate=' +EndDate +'&GrpType=' +GrpType +
			'&StkCatId='+StkCatId+'&Conditions='+Conditions+'&Others='+Others;
	}
	
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		tbar : [OkBT, "-", ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			items : [DateFrom,DateTo,StkGrpType,DHCStkCatGroup,InciDesc,Vendor,PhManufacturer,BatNo,
			{xtype:'compositefield',fieldLabel:'进价范围',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
			hvFlag,M_ChargeFlag]
		}]
	});
	
	var tabs=new Ext.TabPanel({
			id:'main-tabs',
			activeTab:0,
			region:'center',
			enableTabScroll:true,
			resizeTabs: true,
			tabWidth:130,
			minTabWidth:120,
			resizeTabs:true,
			plugins: new Ext.ux.TabCloseMenu(), //右键关闭菜单
			items:[{
				title:'报表',	
					html:'<iframe id="reportFrame" height="100%" width="100%" scrolling="auto" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
				}]
		});
	
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:'批次价格变动统计',
					width:300,
					minSize:250,
					maxSize:350,
					split:true,
					collapsible:true,
					layout:'fit',
					items:HisListTab
				},{
					region:'center',
					layout:'fit',
					items:tabs
				}]
			});
});
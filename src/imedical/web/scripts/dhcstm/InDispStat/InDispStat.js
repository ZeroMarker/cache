// /名称: 科室领消统计
// /编写者：徐超
// /编写日期: 2015.5.20
var IncRowid=""
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
    // 科室
var RecLoc= new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>统计科室</font>',
	id : 'RecLoc',
	name : 'RecLoc',
	anchor:'90%',
	emptyText : '统计科室...',
	stkGrpId : "StkGrpType",
	groupId:gGroupId
});

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>开始日期</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :new Date
	});

	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>截止日期</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : new Date
	});
	
	
	
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 

	var InciDr = new Ext.form.TextField({
		fieldLabel : '物资RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : '物资编码',
		id : 'InciCode',
		name : 'InciCode',
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

	/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {
					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
					getDrugList);
		}
	}
	
	/**
	 * 返回方法
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		IncRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		
		Ext.getCmp("InciDr").setValue(InciDr);
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
		
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
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
					
					SetLogInDept(RecLoc.getStore(),'RecLoc');
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("StkGrpType").getStore().load();
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	
			
	function ShowReport() {
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//库存分类id
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//库存项id
		if (InciDesc==null || InciDesc=="") {
			IncRowid = "";
		}
		var RecLocId=Ext.getCmp("RecLoc").getValue();			//
		if(RecLocId==""){
			Msg.info("warning","科室不能为空！");
			return;
			}
		var hvFlag=(Ext.getCmp("hvFlag").getValue()==true?"Y":"N");
		var chargeFlag=(Ext.getCmp("chargeFlag").getValue()==true?"Y":"N");
		var Param=StartDate+"^"+EndDate+"^"+GrpType+"^"+StkCatId+"^"+IncRowid+"^"+RecLocId+"^"+hvFlag+"^"+chargeFlag;
		var reportframe=document.getElementById("reportFrame")
		var p_URL="";
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
		var RecLocDesc=Ext.getCmp("RecLoc").getRawValue();
		//取出查询条件
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_InDispStat.raq&Param='+
				Param+'&Conditions='+Conditions+'&RecLocDesc='+RecLocDesc;
		
		reportframe.src=p_URL;
	}

	var HisListTab = new Ext.ux.FormPanel({
		id : 'HisListTab',
		tbar : [OkBT, "-", ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			items : [RecLoc,DateFrom,DateTo,StkGrpType,DHCStkCatGroup,InciDesc,
				{
					xtype:'checkbox',
					boxLabel : '高值标志',
					id : 'hvFlag',
					name : 'hvFlag',
					anchor : '90%',
					checked : false
				},{
					xtype:'checkbox',
					boxLabel : '收费材料',
					id : 'chargeFlag',
					name : 'chargeFlag',
					anchor : '90%',
					checked : false
				}
			]
		}]
	});

	var reportPanel=new Ext.Panel({
		autoScroll:true,
		frame:true,
		html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:'科室领消汇总',
					width:320,
					split:true,
					collapsible:true,
					layout:'fit',
					items:HisListTab
				},{
					region:'center',
					layout:'fit',
					items:reportPanel
				}]
			});
});
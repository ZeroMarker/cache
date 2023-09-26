//名称:	 请求科室操作盘点功能
//编写者：		lihui
//编写日期:	20170608

	var gIncId='';
	var Url = DictUrl + 'reqlocstktkaction.csp';
	var gGroupId = session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var ReqLocStkTkId = '';
    var InRequestParamObj = GetAppPropValue('DHCSTINREQM'); 
    //科室类型全局变量
    var INREQUEST_LOCTYPE1 = ''; //判断盘点科室是否使用关联科室
    if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	    INREQUEST_LOCTYPE1 = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
    }
var StkTkLoc = new Ext.ux.LocComboBox({
		fieldLabel : '盘点科室',
		id : 'StkTkLoc',
		name : 'StkTkLoc',
		anchor : '90%',
		emptyText : '盘点科室...',
		//defaultLoc : {},
		protype : INREQUEST_LOCTYPE1,
	    linkloc:gLocId,
	    groupId:gGroupId,
		listeners : {
			'select' : function(cb){
				var StkTkLoc = cb.getValue();
				Ext.getCmp('StkGrpType').setFilterByLoc(StkTkLoc,"");
			}
		}
	});

	var SubSTNo = new Ext.form.TextField({
		id : 'SubSTNo',
		fieldLabel : '单号',
		anchor : '90%',
		disabled : true
	});

	var CreateUser = new Ext.form.TextField({
		fieldLabel : '制单人',
		id : 'CreateUser',
		anchor : '90%',
		disabled : true
	});

	var CreateDate = new Ext.ux.DateField({
		fieldLabel : '制单日期',
		id : 'CreateDate',
		anchor : '90%',
		
		value : new Date(),
		disabled : true
	});

	var CreateTime = new Ext.form.TextField({
		fieldLabel : '制单时间',
		id : 'CreateTime',
		anchor : '90%',
		disabled : true
	});

	// 物资类组
	var StkGrpType = new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		StkType : App_StkTypeCode,
		LocId : gLocId,
		UserId : gUserId,
		anchor : '90%',
		childCombo : 'DHCStkCatGroup'
	});

	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '库存分类',
		id : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});

	var Completed = new Ext.form.Checkbox({
		id : 'Completed',
		hideLabel : true,
		boxLabel : '完成',
		disabled : true
	});

	var CountCompleted = new Ext.form.Checkbox({
		id : 'CountCompleted',
		hideLabel : true,
		boxLabel : '实盘完成',
		disabled : true
	});

	var AdjCompleted = new Ext.form.Checkbox({
		id : 'AdjCompleted',
		hideLabel : true,
		boxLabel : '调整完成',
		disabled : true
	});

	var CreateStkTkBT = new Ext.ux.Button({
		id : 'CreateStkTkBT',
		text : '生成盘点单',
		iconCls : 'page_save',
		handler : function() {
			var StkTkLoc = Ext.getCmp('StkTkLoc').getValue();
			if(Ext.isEmpty(StkTkLoc)){
				Msg.info('warning', '盘点科室不可为空!');
				return false;
			}
			var StkTkLocDesc = Ext.getCmp('StkTkLoc').getRawValue();
			Ext.Msg.show({
				title : '提示',
				msg : '是否为 ' + StkTkLocDesc + ' 生成盘点单?',
				buttons : Ext.Msg.YESNO,
				fn : function(b, t, o){
					if (b == 'yes'){
						CreateStkTk();
					}
				},
				icon: Ext.MessageBox.QUESTION
			});
		}
	});

	/**
	 * 生成便易盘点单
	 */
	function CreateStkTk(){
		var StkTkLoc = Ext.getCmp('StkTkLoc').getValue();
		var Scg = Ext.getCmp('StkGrpType').getValue();
		var Incsc = Ext.getCmp('DHCStkCatGroup').getValue();
		var StrParam = StkTkLoc + '^' + gUserId + '^' + Scg + '^' + Incsc;
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:Url,
			params:{actiontype:'Create',StrParam:StrParam},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				mask.hide();
				var ret=jsonData.info;
				if(jsonData.success=='true'){
					Msg.info('success','成功!');
					Select(ret);
				}else if(ret == -11){
					Msg.info('error', '保存主信息失败!');
				}else if(ret == -12){
					Msg.info('error', '保存明细信息失败!');
				}else if(ret == -13){
					Msg.info('error', '没有可生成的明细!');
				}else{
					Msg.info('error', '保存失败:' + ret);
				}
			}		
		});
	}

	function Select(RowId){
		ReqLocStkTkId = RowId;
		var MainInfo = tkMakeServerCall('web.DHCSTM.DHCReqLocStktk','Select',RowId);
		MainInfo = Ext.util.JSON.decode(MainInfo);
		HisListTab.getForm().setValues(MainInfo);
		SetEditDisabled(true);
		ChangeButtonStatus();
		QueryDetail();

	}
	function SetEditDisabled(bool){
		bool = !!bool;
		Ext.getCmp('StkTkLoc').setDisabled(bool);
		Ext.getCmp('StkGrpType').setDisabled(bool);
		Ext.getCmp('DHCStkCatGroup').setDisabled(bool);
	}
	var Filter=new Ext.Toolbar.Button({
		id:'filter',
		text:'过滤',
		iconCls : 'page_find',
		anchor:'90%',
		handler:function(){
			    gIncId = "";
				QueryDetail();
			}
	});
	//根据物资名称查找
	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		emptyText:'物资名称',
		width:150,
		listeners:{
			'specialkey':function(field,e){
				if(e.getKey()==Ext.EventObject.ENTER){
					var stkgrp = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(field.getValue(), stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
				}
			}
		}
	});
		/**
	 * 返回方法
	 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gIncId = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("IncDesc").setValue(inciDesc);
		QueryDetail();
	}
	//按照名称过滤
	function QueryDetail() {
		var incidesc = Ext.getCmp('IncDesc').getValue();
		var StkGrpId = Ext.getCmp('StkGrpType').getValue();
		var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
		var CountStatus = '0';
		if(Ext.getCmp('onlySurplus').getValue()){
			CountStatus = '1';
		}else if(Ext.getCmp('onlyLoss').getValue()){
			CountStatus = '2';
		}else if(Ext.getCmp('onlyCount').getValue()){
			CountStatus = '3';
		}
		gStrDetailParams = gIncId + '^' + StkGrpId + '^' + StkCatId+ '^' + incidesc;
		DetailStore.removeAll();
		DetailStore.setBaseParam('sort', 'code');
		DetailStore.setBaseParam('dir', 'ASC');
		DetailStore.setBaseParam('Parref', ReqLocStkTkId);
		DetailStore.setBaseParam('CountStatus', CountStatus);
		DetailStore.setBaseParam('Params', gStrDetailParams);
		DetailStore.load({
			params : {start : 0, limit : DetailPagingToolbar.pageSize},
			callback : function(r,options,success){
				if(!success){
					Msg.info('error', '查询有误!')
				}
			}
		});
	}

	
    //设置未填数等于帐盘数
	var ReqLocSetDefaultBT2 = new Ext.Toolbar.Button({
		text : '设置未填数等于帐盘数',
		tooltip : '点击设置未填数等于帐盘数',
		iconCls : 'page_save',
		width : 70,
		height : 30,
		handler : function() {
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: '设置未填实盘数等于帐盘数将修改此盘点单所有未录入的记录，是否继续？',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
				   if (b=='yes'){
					   ReqLocSetDefaultQty(2);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});

	//设置未填数等于0
	var ReqLocSetDefaultBT = new Ext.Toolbar.Button({
		text : '设置未填数等于0',
		tooltip : '点击设置未填数等于0',
		iconCls : 'page_save',
		width : 70,
		height : 30,
		handler : function() {
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: '设置未填实盘数等于0将修改此盘点单所有未录入的记录，是否继续？',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
				   if (b=='yes'){
					   ReqLocSetDefaultQty(1);
				   }
			   },
			   icon: Ext.MessageBox.QUESTION
			});
		}
	});
	
	//设置未填实盘数
	function ReqLocSetDefaultQty(flag){
		if(ReqLocStkTkId==''){
			Msg.info('Warning','没有选中的盘点单！');
			return;
		}
		var Completed = Ext.getCmp('Completed').getValue();
		var CountCompleted = Ext.getCmp('CountCompleted').getValue();
		if(!Completed || CountCompleted){
			Msg.info('warning', '单据未账盘完成或已实盘确认,不可以统一处理实盘数!');
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:Url,
			params:{actiontype:'ReqLocSetDefaultQty',Inst:ReqLocStkTkId,Flag:flag},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info('success','成功!');
					Select(ReqLocStkTkId);
				}else{
					var ret=jsonData.info;					
					Msg.info('error','设置未填记录实盘数失败:'+ret);
				}
			}		
		});
	}
	var SaveBT = new Ext.ux.Button({
		id : 'SaveBT',
		text : '保存盘点数据',
		iconCls : 'page_save',
		handler : function() {
			Save();
		}
	});

	function Save(){
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		var rowCount = DetailStore.getCount();
		var ListDetail = '';
		for(var i = 0; i < rowCount; i++){
			var rowData = DetailStore.getAt(i);
			//新增或修改过的数据
			if(rowData.dirty || rowData.data.newRecord){
				var RowId = rowData.get('RowId');
				var CountQty = rowData.get('CountQty');
				if(CountQty == ""){
					CountQty=0;
				}
				var Qty = rowData.get('Qty');
				var Remarks = rowData.get('Remarks');
				var Detail = RowId + '^' + CountQty + '^' + Remarks;
				if(ListDetail == ''){
					ListDetail = Detail;
				}else{
					ListDetail = ListDetail + xRowDelim() + Detail;
				}
			}
		}
		if(ListDetail == ''){
			Msg.info('warning', '没有需要保存的数据!');
			return;
		}
		var mask = ShowLoadMask(Ext.getBody(), '处理中请稍候...');
		Ext.Ajax.request({
			url : Url,
			params : {actiontype : 'SaveStkTkItm', ListDetail : ListDetail},
			method : 'post',
			waitMsg : '处理中...',
			success : function(response,opt){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.success == 'true'){
					Msg.info('success', '保存成功!');
					Select(ReqLocStkTkId);
				}else{
					var ret = jsonData.info;
					if(ret == '-1'){
						Msg.info('warning','没有需要保存的数据!');
					}else if(ret == '-2'){
						Msg.info('error','保存失败!');
					}else{
						Msg.info('error','部分数据保存失败:'+ret);
					}
				}
			}
		});
	}

	var AdjBT = new Ext.ux.Button({
		text : '盘点调整',
		id : 'AdjBT',
		iconCls : 'page_gear',
		handler : function() {
			if(Ext.isEmpty(ReqLocStkTkId)){
				Msg.info('warning', '没有需要处理的单据!');
				return false;
			}
			var mr = DetailGrid.getStore().getModifiedRecords();
			if(!Ext.isEmpty(mr)){
				Ext.Msg.show({
					title : '提示',
					msg : '数据已录入或修改, 你当前的操作将丢失这些结果, 是否继续?',
					buttons : Ext.Msg.YESNO,
					fn : function(b, t, o){
						if (b == 'yes'){
							AdjAndInit();
						}else{
							Msg.info('warning', '请先点击保存!');
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				Ext.Msg.show({
					title : '提示',
					msg : '将要进行盘点调整, 是否继续?',
					buttons : Ext.Msg.YESNO,
					fn : function(b, t, o){
						if (b == 'yes'){
							AdjAndInit();
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}
		}
	});

	function AdjAndInit(){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:Url,
			params:{actiontype:'AdjStktk',ReqLocStkTkId:ReqLocStkTkId,UserId:gUserId},
			method:'post',
			waitMsg:'处理中...',
			success:function(response,opt){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				mask.hide();
				var ret=jsonData.info;
				if(jsonData.success=='true'){
					Msg.info('success','调整成功!');
					HisListTab.getForm().setValues({
						AdjCompleted: true
					});
					ChangeButtonStatus();
				}else if(ret == -11){
					Msg.info('error', '盘点调整失败!');
				}else{
					Msg.info('error', '操作错误:' + ret);
				}
			}		
		});
	}

	var QueryBT = new Ext.Toolbar.Button({
		text : '查询盘点单',
		tooltip : '点击查询盘点单',
		iconCls : 'page_find',
		width : 70,
		height : 30,
		handler : function() {
			SubLocStkTkFind(Select);
		}
	});

	var CompleteBT = new Ext.ux.Button({
		text : '账盘完成',
		tooltip : '点击确认完成',
		iconCls : 'page_refresh',
		handler : function() {
			Complete();
		}
	});

	function Complete(){
		if(Ext.isEmpty(ReqLocStkTkId)){
			Msg.info('warning', '没有需要完成的单据!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCReqLocStktk', 'Complete', ReqLocStkTkId);
		if(result === '0'){
			Msg.info('success', '完成成功!');
			HisListTab.getForm().setValues({Completed : true});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '完成失败:' + result);
		}
	}

	var CancelCompleteBT = new Ext.ux.Button({
		text : '取消账盘完成',
		tooltip : '点击取消完成',
		iconCls : 'page_refresh',
		handler : function() {
			CancelComplete();
		}
	});

	function CancelComplete(){
		if(Ext.isEmpty(ReqLocStkTkId)){
			Msg.info('warning', '没有需要取消完成的单据!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCReqLocStktk', 'CancelComplete', ReqLocStkTkId);
		if(result === '0'){
			Msg.info('success', '取消完成成功!');
			HisListTab.getForm().setValues({Completed : false});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '完成失败:' + result);
		}
	}

	var CountCompleteBT = new Ext.ux.Button({
		text : '实盘完成',
		tooltip : '点击确认实盘录入完成',
		iconCls : 'page_refresh',
		handler : function() {
			CountComplete();
		}
	});

	function CountComplete(){
		if(Ext.isEmpty(ReqLocStkTkId)){
			Msg.info('warning', '没有需要完成的单据!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCReqLocStktk', 'CountComplete', ReqLocStkTkId);
		if(result === '0'){
			Msg.info('success', '完成成功!');
			HisListTab.getForm().setValues({CountCompleted : true});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '完成失败:' + result);
		}
	}

	var CountCancelCompleteBT = new Ext.ux.Button({
		text : '实盘取消完成',
		tooltip : '点击取消实盘录入完成',
		iconCls : 'page_refresh',
		handler : function() {
			CountCancelComplete();
		}
	});

	function CountCancelComplete(){
		if(Ext.isEmpty(ReqLocStkTkId)){
			Msg.info('warning', '没有需要取消完成的单据!');
			return false;
		}
		var result = tkMakeServerCall('web.DHCSTM.DHCReqLocStktk', 'CountCancelComplete', ReqLocStkTkId);
		if(result === '0'){
			Msg.info('success', '取消完成成功!');
			HisListTab.getForm().setValues({CountCompleted : false});
			ChangeButtonStatus();
		}else{
			Msg.info('error', '完成失败:' + result);
		}
	}

	var RefreshBT = new Ext.Toolbar.Button({
		text : '清空',
		tooltip : '点击清空',
		iconCls : 'page_clearscreen',
		width : 70,
		height : 30,
		handler : function() {
			ClearData();
		}
	});

	function ClearData() {
		ReqLocStkTkId = '';
		gIncId='';
		Ext.getCmp("IncDesc").setValue("");
		clearPanel(HisListTab);
		SetEditDisabled(false);
		HisListTab.getForm().setValues({CreateDate : new Date()});
		Ext.getCmp("StkTkLoc").setValue(gLocId); 
		Common_ClearPaging(DetailPagingToolbar);
		DetailStore.removeAll();
		DetailGrid.getView().refresh();
		ChangeButtonStatus();
	}

	var DeleteBT = new Ext.ux.Button({
		text : '删除',
		tooltip : '点击删除单据',
		iconCls : 'page_delete',
		width : 70,
		height : 30,
		handler : function() {
			if(Ext.isEmpty(ReqLocStkTkId)){
				Msg.info('warning', '没有需要删除的单据!');
				return fasle;
			}else{
				Ext.Msg.show({
					title : '提示',
					msg : '是否删除该盘点单?',
					buttons : Ext.Msg.YESNO,
					fn : function(b, t, o){
						if (b == 'yes'){
							DeleteData(ReqLocStkTkId);
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}
		}
	});

	function DeleteData(RowId){
		var result = tkMakeServerCall('web.DHCSTM.DHCReqLocStktk', 'Delete', RowId);
		if(result === '0'){
			Msg.info('success', '删除成功');
			ClearData();
		}else{
			Msg.info('error', '删除失败:' + result);
		}
	}

	function ChangeButtonStatus(){
		var AdjCompleted = Ext.getCmp('AdjCompleted').getValue();
		var CountCompleted = Ext.getCmp('CountCompleted').getValue();
		var Completed = Ext.getCmp('Completed').getValue();
		if(AdjCompleted){
			ChangeButtonEnable('0^0^0^0^0^0^0^0');
		}else if(CountCompleted){
			ChangeButtonEnable('0^0^0^0^0^1^1^0');
		}else if(Completed){
			ChangeButtonEnable('0^0^1^1^1^0^0^0');
		}else if(!Ext.isEmpty(ReqLocStkTkId)){
			ChangeButtonEnable('0^1^0^0^0^0^0^1');
		}else{
			ChangeButtonEnable('1^0^0^0^0^0^0^0');
		}
	}

	function ChangeButtonEnable(str) {
		var list = str.split('^');
		for (var i = 0; i < list.length; i++) {
			if (list[i] == "1") {
				list[i] = false;
			} else {
				list[i] = true;
			}
		}
		//生成^完成^取消完成^保存^实盘完成^取消实盘完成^调整&出库^删除
		CreateStkTkBT.setDisabled(list[0]);
		CompleteBT.setDisabled(list[1]);
		CancelCompleteBT.setDisabled(list[2]);
		SaveBT.setDisabled(list[3]);
		CountCompleteBT.setDisabled(list[4]);
		CountCancelCompleteBT.setDisabled(list[5]);
		AdjBT.setDisabled(list[6]);
		DeleteBT.setDisabled(list[7]);
	}

	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		region : 'north',
		autoHeight : true,
		title : '申请科室简易盘点',
		labelAlign : 'right',
		frame : true,
		trackResetOnLoad : true,
		bodyStyle : 'padding:5px 0px 0px 0px;',
		tbar : [CreateStkTkBT, '-', QueryBT, '-', CompleteBT, '-', CancelCompleteBT, '-', SaveBT,
			'-', CountCompleteBT, '-', CountCancelCompleteBT, '-', AdjBT, '-', RefreshBT, '-', DeleteBT],
		items : [{
				style : 'padding:5px 0px 0px 0px',
				layout : 'column',
				xtype : 'fieldset',
				title : '申请科室盘点选项',
				defaults : {border : false},
				items : [{
						columnWidth : .2,
						xtype : 'fieldset',
						items : [StkTkLoc] 
					}, {
						columnWidth : .2,
						xtype : 'fieldset',
						items : [SubSTNo, CreateUser]
					}, {
						columnWidth : .2,
						xtype : 'fieldset',
						items : [CreateDate, CreateTime]
					}, {
						columnWidth : .2,
						xtype : 'fieldset',
						items : [StkGrpType, DHCStkCatGroup]
					}, {
						columnWidth : .1,
						xtype : 'fieldset',
						items : [Completed, CountCompleted]
					}, {
						columnWidth : .1,
						xtype : 'fieldset',
						items : [AdjCompleted]
					}
				]
			}]
	});

	var DetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header : 'RowId',
			dataIndex : 'RowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : 'Incil',
			dataIndex : 'Incil',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : '物资代码',
			dataIndex : 'InciCode',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : '物资名称',
			dataIndex : 'InciDesc',
			width : 200,
			align : 'left',
			sortable : true
		},{
			header : '规格',
			dataIndex : 'Spec',
			width : 80,
			align : 'left'
		},{
			header : '冻结数量',
			dataIndex : 'FreezeQty',
			width : 80,
			align : 'right',
			sortable : true
		},{
			header : '单位',
			dataIndex : 'PUomDesc',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header : '进价金额',
			dataIndex : 'RpAmt',
			xtype : 'numbercolumn',
			align : 'right',
			sortable : true
		},{
			header : '售价金额',
			dataIndex : 'SpAmt',
			xtype : 'numbercolumn',
			align : 'right',
			sortable : true
		},{
			header  :  '实盘数量',
			dataIndex : 'CountQty',
			width : 100,
			align : 'right',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowNegative : false
			})
		},{
			header  :  '标准库存',
			dataIndex : 'RepQty',
			width : 100,
			align : 'right',
			sortable : true
		},{
			header : '备注',
			dataIndex : 'Remarks',
			width : 180,
			align : 'left',
			sortable : true,
			editable : true,
			editor : new Ext.form.TextField({
				maxLength : 40
			})
		}
	]);

	var DetailStore = new Ext.data.JsonStore({
		url : Url + '?actiontype=QueryDetail',
		root : 'rows',
		pruneModifiedRecords:true,
		totalProperty : 'results',
		fields : ['RowId','InciCode','InciDesc','Spec','RepLev','RepQty',
				'Incil','FreezeQty','PUomDesc','CountQty','RpAmt','SpAmt','Remarks'],
		remoteSort : false
	});

	var DetailPagingToolbar = new Ext.PagingToolbar({
		store : DetailStore,
		pageSize : PageSize,
		displayInfo : true
	});

	var onlySurplus = {xtype:'radio',boxLabel:'仅盘盈',name:'LossStatus',id:'onlySurplus',inputValue:1,
		listeners : {
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(ReqLocStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var onlyLoss = {xtype:'radio',boxLabel:'仅盘亏',name:'LossStatus',id:'onlyLoss',inputValue:2,
		listeners :　{
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(ReqLocStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var onlyCount = {xtype:'radio',boxLabel:'有实盘数据',name:'LossStatus',id:'onlyCount',inputValue:3,
		listeners :　{
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(ReqLocStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};
	var allStatus = {xtype:'radio',boxLabel:'全部',name:'LossStatus',inputValue:0,id:'allStatus',checked:true,
		listeners :　{
			check : function(radio, checked){
				if(checked && !Ext.isEmpty(ReqLocStkTkId)){
					DetailStore.setBaseParam('CountStatus', this.inputValue);
					DetailStore.load({params : {start : 0, limit : DetailPagingToolbar.pageSize}});
				}
			}
		}
	};

	var DetailGrid = new Ext.ux.EditorGridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '明细',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.ux.CellSelectionModel(),
		loadMask : true,
		bbar : DetailPagingToolbar,
		tbar : [onlySurplus,onlyLoss,onlyCount,allStatus,'-',ReqLocSetDefaultBT,'-',ReqLocSetDefaultBT2,'-',IncDesc,'-',Filter],
		listeners : {
			afteredit : function(e){
			},
			beforeedit : function(e){
				var Completed = Ext.getCmp('Completed').getValue();
				var CountCompleted = Ext.getCmp('CountCompleted').getValue();
				var AdjCompleted = Ext.getCmp('AdjCompleted').getValue();
				if(AdjCompleted){
					return false;
				}else if(e.field == 'CountQty'){
					//未制单完成,或已实盘完成, 不可修改实盘数
					if(!Completed || CountCompleted){
						e.cancel = true;
						Msg.info('warning', '单据未账盘完成或已实盘确认, 不可编辑!');
					}
				}
			}
		}
	});

	Ext.onReady(function() {
		Ext.QuickTips.init();

		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, DetailGrid],
			renderTo : 'mainPanel'
		});

		ChangeButtonStatus();
	});
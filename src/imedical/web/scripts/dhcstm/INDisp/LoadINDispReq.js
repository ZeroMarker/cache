function LoadReq(loc)
{
	var subLoc=loc;
	var url = 'dhcstm.indispreqaction.csp';
	var jReq = "";
	var currRow='';
	//起始日期
	var startDate = new Ext.ux.DateField({
		id:'startDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'起始日期',
		anchor:'90%',
		value:new Date().add(Date.DAY, -7)
	});
	//截止日期
	var endDate = new Ext.ux.DateField({
		id:'endDate',
		//width:210,
		listWidth:210,
		allowBlank:true,
		fieldLabel:'截止日期',
		anchor:'90%',
		value:new Date()
	});
	
	var LoadINDSToLoc = new Ext.ux.ComboBox({
		id:'LoadINDSToLoc',
		fieldLabel:'接收科室',
		emptyText:'接收科室...',
		triggerAction : 'all',
		store : LeadLocStore,
		valueParams : {groupId : gGroupId},
		filterName : '',
		childCombo : ['UserGrpX']
	});
	var INDSToLocId = Ext.getCmp('INDSToLoc').getValue();
	if(INDSToLocId != ''){
		INDSToLocDesc = Ext.getCmp('INDSToLoc').getRawValue()
		addComboData(LeadLocStore, INDSToLocId, INDSToLocDesc);
		LoadINDSToLoc.setValue(INDSToLocId);
	}
	
	var UserGrpX=new Ext.ux.ComboBox({
		fieldLabel:'专业组',	
		id:'UserGrpX',
		anchor : '90%',
		store:UserGroupStore,
		params:{SubLoc:'LoadINDSToLoc'}
	});
	
	var chkStatus=new Ext.form.Checkbox({
		fieldLabel:'所有状态',
		id:'AllStatus'
	});
	
	var NotDisp = new Ext.form.Checkbox({
		fieldLabel : '未发放',
		id : 'NotDisp',
		name : 'NotDisp',
		//anchor : '90%',
		//width : 100,
		checked : true
	});
	var PartlyDisp = new Ext.form.Checkbox({
		fieldLabel : '部分发放',
		id : 'PartlyDisp',
		name : 'PartlyDisp',
		//anchor : '90%',
		//width : 100,
		checked : true
	});
	var AllDisp = new Ext.form.Checkbox({
		fieldLabel : '全部发放',
		id : 'AllDisp',
		name : 'AllDisp',
		//anchor : '90%',
		checked : false
	});
	
	var startDispButton = new Ext.ux.Button({
		text:'确认发放',
		tooltip:'确认发放该请领单的物品',
		height:30,
		width:70,
		iconCls:'page_gear',
		handler:function(){
			var record=dsrqGrid.getSelectionModel().getSelected();
			if(record && record.get('status')=="X"){
				Msg.info("warning","当前所选择请领单已经取消, 不可发放!");
				return;
			}
			if(record && record.get('status')=="R"){
				Msg.info("warning","当前所选择请领单已经拒绝, 不可发放!");
				return;
			}
			CreateNewDisp();
		}
	});
	
	function CreateNewDisp()
	{
		if ((jReq==null)||(jReq=='') ) return;
		if(IndsRqItmGrid.activeEditor!=null){
			IndsRqItmGrid.activeEditor.completeEdit();
		}
		//准备子表数据	
		var data='';
		var st=IndsRqItmGrid.getStore();
		var rd=xRowDelim();
		var records = IndsRqItmGrid.getSelectionModel().getSelections();
		for(var i=0,len=records.length;i<len;i++){
			rec = records[i];
			var RQI=rec.get('rowid');
			var uom=rec.get('uom');
			var dispQty=rec.get('dispQty');
			var moveStatus = rec.get('moveStatus');
			var rowIndex = st.indexOf(rec)+1;
			if(moveStatus=="X"){
				Msg.info("warning","第"+rowIndex+"行已取消,不可发放!");
				return;
			}else if(moveStatus=="R"){
				Msg.info("warning","第"+rowIndex+"行已拒绝,不可发放!");
				return;
			}
			
			if (dispQty<=0) {	
				Msg.info('warning','第'+rowIndex+'行发放数量不正确!');
				return;
			}
			if (data==''){
				data =RQI+"^"+ dispQty+"^"+ uom;
			}else{
				data=data+ rd+ RQI+"^"+ dispQty+"^"+ uom;
			}
		}
		
		if (data==''){
			Msg.info('error','没有明细数据！');
			return;
		}
		//创建
		Ext.Ajax.request({
			url:'dhcstm.indispaction.csp?actiontype=CreateDispByReq',
			params:{dsrq:jReq,userId:session['LOGON.USERID'],detailData:data,DispLoc:subLoc},
			success:function(result,request){
				var jsonData = Ext.util.JSON.decode(result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					mainRowId=jsonData.info   //rowid - 主表rowid
					select(mainRowId);
					if (findWin) findWin.close();
				}else{
					Msg.info("error","保存失败:"+jsonData.info);
				}
			},
			failure:function(){
				Msg.info("failure","保存失败!");
			}
		});
	}
	var fB = new Ext.Toolbar.Button({
		text:'查询',
		tooltip:'查询',
		iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			currRow='';
			var startDate = Ext.getCmp('startDate').getValue();
			if((startDate!="")&&(startDate!=null)){
				startDate = startDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDate').getValue();
			if((endDate!="")&&(endDate!=null)){
				endDate = endDate.format(ARG_DATEFORMAT);
			}else{
				Msg.info("error","请选择截止日期!");
				return false;
			}
			var frLocId = Ext.getCmp('LoadINDSToLoc').getValue();
			if(Ext.isEmpty(frLocId)){
				var frLocId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadSubLoc",subLoc);
				var frLocArr = frLocId.split("^");
				frLocId = frLocArr.join("%");		//科室及时支配科室组成的id串, %隔开
			}
			
			var comp='Y';  //完成
			var status="O";  //状态
			
			if (chkStatus.getValue()==true) status="";
			var UserGrp=Ext.getCmp("UserGrpX").getValue();
			var NotDisp = (Ext.getCmp("NotDisp").getValue()==true?'0':'');
			var PartlyDisp = (Ext.getCmp("PartlyDisp").getValue()==true?'1':'');
			var AllDisp = (Ext.getCmp("AllDisp").getValue()==true?'2':'');
			var dispStatus=NotDisp+','+PartlyDisp+','+AllDisp;
			//起始日期^截止日期^科室rowid^用户rowid^完成标志^专业组^发放状态
			var strPar = startDate+"^"+endDate+"^"+frLocId+"^^"+comp+"^"+status+"^"+UserGrp+"^"+dispStatus;
			
			dsrqitmDs.removeAll();
			dsrqDs.removeAll();
			dsrqDs.setBaseParam('sort','');
			dsrqDs.setBaseParam('dir','');
			dsrqDs.setBaseParam('strPar',strPar);
			
			dsrqDs.load({params:{start:0,limit:pagingToolbar3.pageSize}});
		}
	});
	
	var cB = new Ext.Toolbar.Button({
		text:'清空',
		tooltip:'清空',
		iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			dsrqDs.removeAll();
			dsrqitmDs.removeAll();
		}
	});

	var RejectBT = new Ext.Toolbar.Button({
		id:'RejectBT',
		text:'拒绝',
		tooltip:'拒绝请领单',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			if(jReq=="" || jReq==null){
				Msg.info("warning","请选择需要拒绝的请领单!");
				return;
			}
			var selRecord=dsrqGrid.getSelectionModel().getSelected();
			var status=selRecord.get('status');
			if(status=="C"){
				Msg.info("warning","该单据已处理, 不可拒绝!");
				return;
			}
			Ext.Msg.show({
				title:'拒绝请领单',
				msg:'确定拒绝当前请领单？',
				buttons:Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn:RejectInDispReq
			})
		}
	});
	
	function RejectInDispReq(b,txt){
		if(b=="yes"){
			Ext.Ajax.request({
				url:'dhcstm.indispreqaction.csp?actiontype=RejectInDispReq',
				params:{dsrq:jReq},
				success:function(result,request){
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success=='true') {
						Msg.info("success","拒绝请领单成功!");
						IndsRqItmGrid.getStore().removeAll();
						dsrqDs.reload();
					}else{
						if(jsonData.info==-96){
							Msg.info("error","该请领单已发放制单,不可拒绝!");
						}else{
							Msg.info("error","拒绝失败!"+jsonData.info);
						}
					}
				}
			});
		}
	}
	
	var closeB = new Ext.Toolbar.Button({
		iconCls:'page_delete',
		height:30,
		width:70,
		text:'关闭',
		tooltip:'关闭',
		handler:function(){
			findWin.close();
		}
	});
	
	var dsrqProxy= new Ext.data.HttpProxy({url:url+'?actiontype=DispReqList',method:'GET'});
	var dsrqDs = new Ext.data.Store({
		proxy:dsrqProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'dsrq'},
			{name:'no'},
			{name:'loc'},
			{name:'locDesc'},
			{name:'user'},
			{name:'userName'},
			{name:'reqUserName'},
			{name:'reqGrpDesc'},
			{name:'date'},
			{name:'time'},
			{name:'scg'},
			{name:'scgDesc'},
			{name:'status'},
			{name:'comp'},
			{name:'remark'},
			'loc','locDesc'
		]),
		remoteSort: false,
		listeners:{
			'load':function(ds){
				if (dsrqDs.getCount()>0){
					dsrqGrid.getSelectionModel().selectFirstRow();
					dsrqGrid.getView().focusRow(0);
				}
			}
		}
	});
	
	var dsrqCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{	
			header: 'rowid',
			dataIndex: 'dsrq',
			width: 100,
			hidden:true,
			align: 'left'
		},{
			header: '请领单号',
			dataIndex: 'no',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header:'请领科室',
			dataIndex:'locDesc',
			width:120,
			align:'left'
		},{
			header: "制单人",
			dataIndex: 'userName',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "请领单日期",
			dataIndex: 'date',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "请领单时间",
			dataIndex: 'time',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header:'类组',
			width:100,
			dataIndex:'scgDesc'
		},
			{header:'请领人',dataIndex:'reqUserName'},
			{header:'专业组',dataIndex:'reqGrpDesc'},
		{
			header:'完成',
			dataIndex:'comp',
			align:'center',
			width:50,
			sortable:true,
			xtype : 'checkcolumn'
		},{
			header: "状态",
			dataIndex: 'status',
			width: 60,
			align: 'left',
			renderer:function(value){
				var status=value;
				if(value=="C"){
					status="已处理";
				}else if(value=="O"){
					status="待处理";
				}else if(value=="X"){
					status="已取消";
				}else if(value=="R"){
					status="已拒绝";
				}
				return status;
			},
			sortable: true
		},{		 
			header:'备注',
			dataIndex:'remark',
			width:130,
			align:'left'
		}
	]);
	
	var pagingToolbar3 = new Ext.PagingToolbar({
		store:dsrqDs,
		pageSize:20,
		displayInfo:true
	});

	var dsrqGrid = new Ext.ux.GridPanel({
		id : 'dsrqGrid',
		region:'center',
		store:dsrqDs,
		cm:dsrqCm,
		trackMouseOver: true,
		stripeRows: true,
		split:true,
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners : {
				'rowselect' : function(sm,rowIndex,rec){
					dsrqitmDs.removeAll();
					currRow=rowIndex;
					jReq = dsrqDs.data.items[rowIndex].data["dsrq"];
					dsrqitmDs.setBaseParam('dsrq',jReq);
					dsrqitmDs.setBaseParam('sort','RowId');
					dsrqitmDs.setBaseParam('dir','desc');
					dsrqitmDs.load({params:{start:0,limit:999}});
				}
			}
		}),
		loadMask: true,
		bbar:pagingToolbar3
	});
	
	var dsrqitmProxy= new Ext.data.HttpProxy({url:url+'?actiontype=SelDispReqItm',method:'GET'});
	var dsrqitmDs = new Ext.data.Store({
		proxy:dsrqitmProxy,
		reader:new Ext.data.JsonReader({
			totalProperty:'results',
			root:'rows'
		}, [
			{name:'rowid',mapping:'dsrqi'},
			{name:'inci'},
			{name:'code',mapping:'inciCode'},
			{name:'desc',mapping:'inciDesc'},
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'remark'},
			{name:'StkQty'},
			{name:'dispMadeQty'},
			{name:'dispedQty'},
			{name:'dispQty'},
			"moveStatus"
		]),
		remoteSort: false
	});
	
	var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly:true,
		listeners:{
			'rowselect':function(t,ind,rec){
				var reqQty=Number(rec.get('qty'));
				var dispMadeQty=Number(rec.get('dispMadeQty'));
				var leftReqQty=reqQty-dispMadeQty;
				var stkQty=Number(rec.get('StkQty'));
				var dispQty=rec.get('dispQty');
				if(dispQty==""){
					rec.set('dispQty',Math.max(Math.min(leftReqQty,stkQty),0));
				}else{
					rec.set('dispQty',Math.min(stkQty,Number(dispQty)));
				}
			},
			'rowdeselect':function(t,ind,rec){
				rec.set('dispQty','');
			}
		}
	});
	
	var IndsRqDetailCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),sm,
		{
			header: '代码',
			dataIndex: 'code',
			width: 72,
			sortable:true,
			align: 'left'
		},{
			header: '名称',
			dataIndex: 'desc',
			width: 140,
			sortable:true,
			align: 'left'
		},{
			header:'规格',
			dataIndex:'spec',
			align:'left',
			width:80
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 80,
			align: 'left',
			sortable: true
		},{
			header: "数量",
			dataIndex: 'qty',
			width: 50,
			align: 'right'
		},{
			header: "单位",
			dataIndex: 'uomDesc',
			width: 72,
			align: 'left'
		},{
			header:'备注',
			dataIndex:'remark',
			align:'left',
			width:80
		},{
			header:'库存',
			dataIndex:'StkQty',
			id:'StkQty',
			align:'right',
			width:80
		},{
			header: "已制单",
			dataIndex: 'dispMadeQty',
			width: 50,
			align: 'right'
		},{
			header: "已发放",
			dataIndex: 'dispedQty',
			width: 50,
			align: 'right'
		},{
			header:'确认发放数量',
			dataIndex:'dispQty',
			align:'right',
			selectOnFocus:true,
			width:100,
			editor:new Ext.form.NumberField({
				allowNegative : false
			})
		},{
			header : '状态',
			dataIndex : 'moveStatus',
			align : 'left',
			width : 60,
			renderer : function(value){
				var status="";
				if(value=="G"){
					status="未发放";
				}else if(value=="D"){
					status="已发放";
				}else if(value=="X"){
					status="已取消";
				}else if(value=="R"){
					status="已拒绝";
				}
				return status;
			}
		}
	]);
	
	var RejectItmBT = new Ext.Toolbar.Button({
		id:'RejectItmBT',
		text:'拒绝明细',
		tooltip:'拒绝请领单明细',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			var records = IndsRqItmGrid.getSelectionModel().getSelections();
			if(records == null){
				Msg.info("warning","请选择需要拒绝的明细!");
				return;
			}
			Ext.Msg.show({
				title:'拒绝请领单',
				msg:'确定拒绝当前所选明细?',
				buttons:Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn:RejectInDispReqItm
			})
		}
	});
	
	function RejectInDispReqItm(b,txt){
		if(b=="yes"){
			var records = IndsRqItmGrid.getSelectionModel().getSelections();
			Ext.each(records,function(item,index,allItems){
				var dsrqiDesc = item.get('desc');
				var moveStatus = item.get('moveStatus');
				if(moveStatus=="D"){
					Msg.info("warning",dsrqiDesc+"已发放处理, 不可拒绝!");
					return;
				}else if(moveStatus=='R'){
					Msg.info("warning",dsrqiDesc+"已拒绝, 不可重复处理!");
					return;
				}
				var dsrqi = item.get('rowid');
				var url = 'dhcstm.indispreqaction.csp?actiontype=HandleItm&dsrqi='+dsrqi+'&moveStatus=R';
				var result = ExecuteDBSynAccess(url);
				var jsonData = Ext.util.JSON.decode(result);
				if(jsonData.success=='true'){
					Msg.info("success",dsrqiDesc+"拒绝成功!");
					item.set('moveStatus','R');
					item.commit();
				}else{
					var info = jsonData.info;
					if(info==-96){
						Msg.info("warning",dsrqiDesc+"已发放制单,不可拒绝!");
					}else if(info==-95){
						Msg.info("warning","该请求单已作废,不可拒绝明细!");
						return false;	//停止迭代
					}else if(info==-94){
						Msg.info("warning","该请求单已拒绝,不可拒绝明细!");
						return false;	//停止迭代
					}else if(info==-93){
						Msg.info("warning",dsrqiDesc+"已发放,不可拒绝!");
						return;
					}else if(info==-92){
						Msg.info("warning",dsrqiDesc+"已拒绝,不可重复处理!");
						return;
					}else{
						Msg.info("error",dsrqiDesc+"拒绝失败:"+jsonData.info);
					}
				}
			});
		}
	}
	
	var IndsRqItmGrid = new Ext.ux.EditorGridPanel({
		id : 'IndsRqItmGrid',
		region:'south',
		height:gGridHeight,
		store:dsrqitmDs,
		cm:IndsRqDetailCm,
		trackMouseOver: true,
		stripeRows: true,
		sm:sm,
		loadMask: true,
		clicksToEdit:1,
		tbar:[RejectItmBT],
		split:true,
		//bbar:pagingToolbar4,		//不适合使用分页工具条
		listeners:{
			afteredit:function(e){
				if(e.field=='dispQty'){
					if(parseFloat(e.value)>parseFloat(e.record.get('StkQty'))){
						e.record.set('dispQty',e.originalValue);
						Msg.info('error','发放数量超过当前库存!');
					}
				}
			}
		}
	});
	
	var conPanel = new Ext.ux.FormPanel({
		tbar:[fB,'-',startDispButton,'-',RejectBT,'-',closeB],
		bodyStyle:'padding:5px 0 0 0',
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			autoHeight:true,
			labelWidth:60,
			layout:'column',
			items:[
				{columnWidth:.25,layout:'form',items:[startDate,endDate]},
				{columnWidth:.3,layout:'form',items:[LoadINDSToLoc,UserGrpX]},
				{columnWidth:.15,layout:'form',items:[NotDisp,chkStatus]},
				{columnWidth:.15,layout:'form',items:[PartlyDisp]},
				{columnWidth:.15,layout:'form',items:[AllDisp]}
			]
		}]
	});
	
	var findWin = new Ext.Window({
		title:'发放制单--依据请领单',
		width:gWinWidth,	
		height:gWinHeight,
		layout:'border',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items : [conPanel, dsrqGrid, IndsRqItmGrid],
		listeners:{
			'afterrender':function(){
				if (fB) {fB.handler();}
			}
		}
	});

	//显示窗口
	findWin.show();
	
}

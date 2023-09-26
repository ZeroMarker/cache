// /名称: 生成月报
// /描述: 生成月报
// /编写者：zhangdongmei
// /编写日期: 2012.11.15

Ext.onReady(function() {
	Ext.Ajax.timeout = 300000;	//响应时间改为5min
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl	+ 'stkmonaction.csp?';
	var today=new Date();
	
	// 删除按钮
	var DeleteBT = new Ext.Toolbar.Button({
				id : "DeleteBT",
				text : '删除',
				tooltip : '点击删除',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					var selectRow = MainGrid.getSelectionModel().getSelected();
					if(Ext.isEmpty(selectRow)){
						Msg.info("warning","请选择要删除的月报!");
						return false;
					}
					Ext.Msg.show({
						title:'提示',
						msg: '确定删除 ' + selectRow.get('locDesc') + selectRow.get('mon') + ' 的月报吗?',
						buttons: Ext.Msg.YESNO,
						fn: function(b,t,o){
							if (b=='yes'){
								Delete();
							}
						},
						icon: Ext.MessageBox.QUESTION
					});
				}
			});
			
		// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					QueryRep();
				}
			});
	var ClearBT = new Ext.Button({
		text : '清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function(){
			MainGrid.getStore().removeAll();
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		}
	});
	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '生成月报',
				tooltip : '点击生成月报',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					CreateReport();
				}
			});
	
	var RefreshBT = new Ext.Toolbar.Button({
		id : "RefreshBT",
		text : '刷新',
		tooltip : '刷新',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			Query();
		}
	});
	
	/**
	 * 生成月报
	 */
	function CreateReport() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		var selections=DetailGrid.getSelectionModel().getSelections();
		var CreateUser = gUserId;
		
		var CheckInfoStr = '';
		var listParams="";
		for(var i=0;i<selections.length;i++){
			var record=selections[i];
			var Loc=record.get("LocId");
			var LocDesc=record.get("LocDesc");
			if(Loc==null||Loc==""){
				return;
			}
			var CurMonth=record.get("CurMonth")+"-"+"01";
			var StartDate = record.get("CurStartDate").format(ARG_DATEFORMAT);
			var StartTime = record.get("CurStartTime");
			var EndDate = record.get("CurEndDate").format(ARG_DATEFORMAT);
			var EndTime = record.get("CurEndTime");
			if((StartDate>EndDate)||(StartDate==EndDate && StartTime>=EndTime)){
				//Msg.info("warning",LocDesc+"截止时间要晚于开始时间!");
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+"截止时间要晚于开始时间!";
				continue;
			}
			if(EndDate >= today.format(ARG_DATEFORMAT)){
				//Msg.info("error",LocDesc+"本期截止日期不能超过当天!");
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+"本期截止日期不能超过当天!";
				continue;
			}
			/*
			if(EndDate > today.format(ARG_DATEFORMAT)){
				Msg.info("error",LocDesc+"本期截止日期不能超过当天!");
				return;
			}else if(EndDate==today.format(ARG_DATEFORMAT)){
				if(EndTime>new Date().format('H:i:s')){
					Msg.info("error",LocDesc+"本期截止时间不能为晚于当前时间!");
					return;
				}
			}
			*/
			var Params=Loc+"^"+CurMonth+"^"+CreateUser+"^"+StartDate+"^"+EndDate+"^"+StartTime+"^"+EndTime;
			var ExistFlag=CheckIfExist(Loc,CurMonth);
			if(ExistFlag==true){
				//Msg.info("warning",LocDesc+'本月月报已经生成，如需重新生成的话请先删除后再生成!');
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+'本月月报已经生成，如需重新生成的话请先删除后再生成!';
				continue;
			}
			var CheckStrParam = Loc + "^" + StartDate + "^" + EndDate;
			var CheckInfo = CheckMonCond(CheckStrParam);
			if(CheckInfo!=""){
				//Msg.info("warning",LocDesc+CheckInfo);
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+CheckInfo;
				continue;
			}
			if(listParams==""){
				listParams=Params;
			}else{
				listParams=listParams+RowDelim+Params;
			}
		}
		if(listParams==""){
			Msg.info("warning","请选择需要生成月报的科室!");
			return;
		}
		
		if(!Ext.isEmpty(CheckInfoStr) && confirm(CheckInfoStr + '\r\n是否继续?')==false){
			return false;
		}
		
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url:Url+"actiontype=CreateReport",
			params:{Params:listParams},
			method:'POST',
			success:function(response,opts){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				loadMask.hide();
				if (jsonData.success == 'true') {
					// 刷新界面
					Msg.info("success", "生成月报成功!");
					Query();  //月报都生成后执行查询
					QueryRep();
				} else {
					var ret=jsonData.info;
					Msg.info("error", "生成月报失败："+ret);
				}
			}
		})
	}

	//检测某科室某月份月报是否已经存在
	function CheckIfExist(LocId,CurMon){
		var flag=false;
		var NewUrl=Url+"actiontype=CheckIfExist&LocId="+LocId+"&CurMonth="+CurMon;
		var responseText=ExecuteDBSynAccess(NewUrl);
		var jsonData=Ext.util.JSON.decode(responseText);
		if(jsonData.success=='true'){
			flag= true;
		}
		
		return flag;
	}
	
	//检测是否具有生成月报的条件(是否有未处理完毕的库存转移单)
	function CheckMonCond(StrParam){
		var MsgInfo = "";
		var NewUrl=Url+"actiontype=CheckMonCond&StrParam="+StrParam;
		var responseText=ExecuteDBSynAccess(NewUrl);
		var Ret=jsonData=Ext.util.JSON.decode(responseText).info;
		if(Ret!=="0"){
			if(Ret==-10){
				MsgInfo = "有对方未接受的库存转移单!";
			}else if(Ret==-20){
				MsgInfo = "有未入库接收的库存转移单!";
			}else{
				MsgInfo = "检查有误!";
			}
		}
		return MsgInfo;
	}
	
	//查询
	function Query(){
		var GroupId=session['LOGON.GROUPID'];
		DetailStore.load({params:{actiontype:'GrpLocForStkMon',GroupId:GroupId,start:0,limit:999}});
	}

	var selcol=new Ext.grid.CheckboxSelectionModel({checkOnly:true});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, selcol,{
			header : "rowid",
			dataIndex : 'Rowid',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '科室',
			dataIndex : 'LocDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '上期月份',
			dataIndex : 'Month',
			width : 80,
			align : 'left',
			sortable : true,
			renderer:function(value, metaData, record, rowIndex, colIndex, store){
				if(value==null || value==""){
					return value;
				}
				var newValue=value.substring(0,7);
				return newValue;
			}
		}, {
			header : '上期起始日期',
			dataIndex : 'StartDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "上期起始时间",
			dataIndex : 'StartTime',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "上期截止日期",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "上期截止时间",
			dataIndex : 'EndTime',
			width : 100,
			align : 'center',
			sortable : true
		},{
			header:'本期月份',
			dataIndex:'CurMonth',
			width:100,
			align:'center',
			sortable:false,
			renderer:function(value, metaData, record, rowIndex, colIndex, store){
				return '<span style="color:green;">' + value + '</span>';
			},
			useRenderExport : false,
			editor:new Ext.form.TextField({
			})
		},{
			header:'本期开始日期',
			dataIndex:'CurStartDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false
			})
		},{
			header:'本期开始时间',
			dataIndex:'CurStartTime',
			width:100,
			sortable:false,
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'时间格式错误，正确格式hh:mm:ss',
				width : 120
			})
		},{
			header:'本期截止日期',
			dataIndex:'CurEndDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false
			})
		},{
			header:'本期截止时间',
			dataIndex:'CurEndTime',
			width:100,
			sortable:false,
			editable : false,		//2014-09-29 截止时间不允许修改
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'时间格式错误，正确格式hh:mm:ss',
				width : 120
			})
		}]);
	//根据上期截止日期和时间计算本期开始日期
	function curstartdate(value,rec){
		var curStartDate=today.add(Date.DAY,-30);
		if(rec!=null){
			if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
				//上期截止日期时间转换成Date类型后加1秒
				curStartDate=toDate(rec.lastToDate+" "+rec.lastToTime).add(Date.SECOND,1);
			}
		}
		return curStartDate;
	}
	
	function curstarttime(value,rec){
		var curStartTime="";
		if(rec!=null){
			if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
				//上期截止日期时间转换成Date类型后加1秒
				curStartTime=toDate(rec.lastToDate+" "+rec.lastToTime).add(Date.SECOND,1);
			}
		}
		if(curStartTime==""){
			return "00:00:00";
		}
		return curStartTime.format("H:i:s");
	}
	
	var CurEndDate = today.add(Date.DAY,-1);
	var CurMonth = CurEndDate.getFullYear()+"-"+(CurEndDate.getMonth()+1);
	//lastStkMonRowid^lastMonth^lastFrDate^lastFrTime^lastToDate^lastToTime
	var DetailStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: Url,
		storeId: 'DetailStore',
		root: 'rows',
		totalProperty : "results",
		idProperty: 'Rowid',  
		fields: [
			{name:'Rowid',mapping:'lastStkMonRowid'},
			{name:'LocId',mapping:'RowId'},
			{name:'LocDesc',mapping:'Description'},
			{name:'Month',mapping:'lastMonth'},
			{name:'StartDate',mapping:'lastFrDate'},
			{name:'StartTime',mapping:'lastFrTime'},
			{name:'EndDate',mapping:'lastToDate'},
			{name:'EndTime',mapping:'lastToTime'},
			{name:'CurMonth',defaultValue: CurMonth},
			{name:'CurStartDate',type:'date',dateFormat:DateFormat,convert:curstartdate},
			{name:'CurStartTime',defaultValue:"00:00:00",convert:curstarttime},
			{name:'CurEndDate',type:'date',dateFormat:DateFormat,defaultValue:CurEndDate.format(DateFormat)},
			{name:'CurEndTime',defaultValue:"23:59:59"}
		]
	});
	
	var DetailGrid = new Ext.ux.EditorGridPanel({
			id : 'DetailGrid',
			region : 'center',
			title : '生成月报',
			tbar : [OkBT, '-', RefreshBT],
			cm : DetailCm,
			store : DetailStore,
			sm : selcol,
			listeners : {
				beforeedit : function(e){
					var field=this.getColumnModel().getDataIndex(e.column);
					if(field=="CurStartDate" || field=="CurStartTime"){
						if(e.record.get("Rowid")!=""){
							e.cancel=true;      //存在上期月报的话，本期开始日期和本期开始时间不能修改
						}
					}
				},
				afteredit : function(e){
					this.getSelectionModel().selectRow(e.row,true);
					if(e.field == 'CurEndDate'){
						var CurEndDate = e.value;
						var CurStartDate = e.record.get('CurStartDate');
						if((CurEndDate.format(ARG_DATEFORMAT) >= today.format(ARG_DATEFORMAT))
						|| (CurEndDate.format(ARG_DATEFORMAT) <= CurStartDate.format(ARG_DATEFORMAT))
						){
							Msg.info('error', '本期截止日期不能超过当天, 不能小于起始日期!');
							e.record.set('CurEndDate', e.originalValue);
							return;
						}
						
						var NewCurMonth = CurEndDate.getFullYear()+"-"+(CurEndDate.getMonth()+1);
						e.record.set('CurMonth', NewCurMonth);
						
						//填充其他科室
						FillOtherLocInfo(e.record);
					}else if(e.field == 'CurStartDate'){
						FillOtherLocInfo(e.record);
					}
				}
			}
		});
	
	//填充其他科室
	function FillOtherLocInfo(BasicRecord){
		var CurLocId = BasicRecord.get('LocId');
		var CurStartDate = BasicRecord.get('CurStartDate');
		var CurEndDate = BasicRecord.get('CurEndDate');
		var NewCurMonth = BasicRecord.get('CurMonth');
		var Sels = DetailGrid.getSelectionModel().getSelections();
		for(var i = 0, Len = Sels.length; i < Len; i++){
			var Record = Sels[i];
			if(Record.get('LocId') == CurLocId){
				continue;
			}
			Record.set('CurEndDate', CurEndDate);
			Record.set('CurMonth', NewCurMonth);
			if(Ext.isEmpty(Record.get('Month'))){
				Record.set('CurStartDate', CurStartDate);
			}
		}
	}
	
	//查询月报
	function QueryRep(){
		var stYear=Ext.getCmp('StYear').getValue();
		var stMonth=Ext.getCmp('StMonth').getValue();
		var stDate=stYear+'-'+stMonth+'-'+'01';
		var edYear=Ext.getCmp('EdYear').getValue();
		var edMonth=Ext.getCmp('EdMonth').getValue();
		var edDate=edYear+'-'+edMonth+'-'+'01';
		var Loc=Ext.getCmp('PhaLoc').getValue();
		MainStore.setBaseParam("LocId",Loc);
		MainStore.setBaseParam("StartDate",stDate);
		MainStore.setBaseParam("EndDate",edDate);
		MainStore.load({params:{actiontype:'Query',start:0,limit:999}});
	}
	//删除某月报
	function Delete(){
		var rowid=null;
		var selectRow=MainGrid.getSelectionModel().getSelected();
		if(selectRow){
			rowid=selectRow.get("smRowid");
		}
		if(rowid==null || rowid==""){
			Msg.info("warning","请选择要删除的月报!");
			return false;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url:Url,
			method:'POST',
			params:{actiontype:'Delete',Rowid:rowid},
			success:function(response,request){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					Msg.info('success','删除成功!');
					Query();
					MainStore.load();
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info('warning','该月报不是最后一份月报，不允许删除!');
					}
					else if(ret==-8)
					{
						Msg.info('warning','该月报已提交，不允许删除!');
					}
					else{
						Msg.info('error','删除失败!');
					}			
				}
				
				loadMask.hide();
			}
		});
	}
	
	var StYear=new Ext.form.TextField({
		id:'StYear',
		anchor:'90%',
		width:60,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		anchor:'90%',
		width:40,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		id:'EdYear',
		anchor:'90%',
		width:60,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		id:'EdMonth',
		anchor:'90%',
		width:40,
		value:(today.getMonth()+1)
	});
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		width : 200,
		fieldLabel : '科室',
		listWidth : 400,
		anchor: '90%',
		//separator:'^',	//科室id用^连接
		store : GetGroupDeptStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// 登录设置默认值
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	var MainStore = new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url,
		sotreId:'MainStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'smRowid',
		fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime',
				'StkMonNo','AcctVoucherCode','AcctVoucherDate','AcctVoucherStatus','PdfFile'
		]
	});
	
	var mainChkCol=new Ext.grid.CheckboxSelectionModel({checkOnly:true,singleSelect:true});
	var MainGrid = new Ext.ux.GridPanel({
		region:'south',
		height:300,
		split:true,
		id:'MainGrid',
		title:'历史月报',
		store:MainStore,
		tbar:['科室:',PhaLoc,{xtype:'tbtext',text:'月报范围:'},
				StYear,{xtype:'tbtext',text:'年'},StMonth,{xtype:'tbtext',text:'月----'},
				EdYear,{xtype:'tbtext',text:'年'},EdMonth,{xtype:'tbtext',text:'月'},
				SearchBT,'-',DeleteBT,'-',ClearBT],
		cm:new Ext.grid.ColumnModel([mainChkCol,{
				header:'Rowid',
				dataIndex:'smRowid',
				width:100,
				align:'left',
				hidden:true
			},{
				header:'科室',
				dataIndex:'locDesc',
				width:120,
				align:'left',
				sortable:true
			},{
				header:'月份',
				dataIndex:'mon',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'月报起始日期',
				dataIndex:'frDate',
				width:150,
				align:'left',
				sortable:true,
				renderer:function(value,metaData,record,rowIndex,colIndex,store){
					var StDateTime=value+" "+record.get('frTime');
					return StDateTime;
				}
			},{
				header:'月报截止日期',
				dataIndex:'toDate',
				width:150,
				align:'left',
				sortable:true,
				renderer:function(value,metaData,record,rowIndex,colIndex,store){
					var EdDateTime=value+" "+record.get('toTime');
					return EdDateTime;
				}
			},{
				header:'月报号',
				dataIndex:'StkMonNo',
				width:140,
				align:'left',
				sortable:true
			},{
				header:'凭证号',
				dataIndex:'AcctVoucherCode',
				width:120,
				align:'left',
				sortable:true
			},{
				header:'凭证日期',
				dataIndex:'AcctVoucherDate',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'凭证处理状态',
				dataIndex:'AcctVoucherStatus',
				width:80,
				align:'left',
				sortable:true
			},{
				header:'Pdf文件名称',
				dataIndex:'PdfFile',
				width:100,
				align:'left',
				sortable:true
			}
		]),
		sm:mainChkCol,
		viewConfig : {forceFit : true}
	});

	var myPanel = new Ext.ux.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [DetailGrid, MainGrid]
	});
	
	QueryRep();
	Query();
})
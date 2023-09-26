// /名称: 生成付款月报
// /描述: 生成付款月报
// /编写者：zhangdongmei
// /编写日期: 2012.11.15

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl	+ 'paymonaction.csp?';
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
					Delete();
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
					QueryPay();
				}
			});
			
	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '生成付款月报',
				tooltip : '点击生成付款月报',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					CreateReport();
				}
			});
	
	/**
	 * 生成付款月报
	 */
	function CreateReport() {
		if(PayDetailGrid.activeEditor != null){
			PayDetailGrid.activeEditor.completeEdit();
		}
		var selections=PayDetailGrid.getSelectionModel().getSelections();
		var CreateUser = gUserId;
		
		var listParams="";
		for(var i=0;i<selections.length;i++){
			var record=selections[i];
			var Loc=record.get("LocId");
			var LocDesc=record.get("LocDesc");
			if(Loc==null||Loc==""){
				return;
			}
			
			if (record.get("CurEndDate")==null ||record.get("CurEndDate")=="")
			{
				Msg.info("warning",LocDesc+"请填写截止日期!");
				return;
			}
			if (record.get("CurStartDate")==null ||record.get("CurStartDate")=="")
			{
				Msg.info("warning",LocDesc+"请填写开始日期!");
				return;
			}
			var CurMonth=record.get("CurMonth")+"-"+"01";
			var StartDate = record.get("CurStartDate").format(ARG_DATEFORMAT);
			var EndDate = record.get("CurEndDate").format(ARG_DATEFORMAT);;
			if(StartDate>EndDate){
				Msg.info("warning",LocDesc+"截止日期要晚于开始日期!");
				return;
			}
			if(EndDate>today.format(ARG_DATEFORMAT)){
				Msg.info("error",LocDesc+"本期截止日期不能超过当天!");
				return;
			}
			var Params=Loc+"^"+CurMonth+"^"+CreateUser+"^"+StartDate+"^"+EndDate;
			var ExistFlag=CheckIfExist(Loc,CurMonth);
			if(ExistFlag==true){
				Msg.info("warning",LocDesc+'本月付款月报已经生成，如需重新生成的话请先删除后再生成!');
				return;
			}
			var CheckStrParam = Loc + "^" + EndDate;
			var CheckInfo = CheckMonCond(CheckStrParam);
			if(CheckInfo!=""){
				Msg.info("warning",LocDesc+CheckInfo);
				return;
			}
			if(listParams==""){
				listParams=Params;
			}else{
				listParams=listParams+RowDelim+Params;
			}
		}
		if(listParams==""){
			Msg.info("warning","请选择需要生成付款月报的科室!");
			return;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url:Url+"actiontype=CreatePayReport",
			params:{Params:listParams},
			method:'POST',
			success:function(response,opts){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				loadMask.hide();
				if (jsonData.success == 'true') {
					// 刷新界面
					Msg.info("success", "生成付款月报成功!");
					Query();  //付款月报都生成后执行查询
					QueryPay();
				} else {
					var ret=jsonData.info;
					Msg.info("error", "生成付款月报失败："+ret);
				}
			}
		})
	}

	//检测某科室某月份付款月报是否已经存在
	function CheckIfExist(LocId,CurMon){
		var flag=false;
		var NewUrl=Url+"actiontype=CheckIfExistPayMon&LocId="+LocId+"&CurMonth="+CurMon;
		var responseText=ExecuteDBSynAccess(NewUrl);
		var jsonData=Ext.util.JSON.decode(responseText);
		if(jsonData.success=='true'){
			flag= true;
		}
		
		return flag;
	}
	
	//检测是否具有生成付款月报的条件(是否具有完成单未会计确认的付款单)
	function CheckMonCond(StrParam){
		var MsgInfo = "";
		var NewUrl=Url+"actiontype=CheckPayMonCond&StrParam="+StrParam;
		var responseText=ExecuteDBSynAccess(NewUrl);
		var Ret=jsonData=Ext.util.JSON.decode(responseText).info;
		if(Ret!=="0"){
			if(Ret==-3){
				MsgInfo = "存在完成但是未会计确认的付款单!";
			}else{
				MsgInfo = "检查有误!";
			}
		}
		return MsgInfo;
	}
	
	//查询
	function Query(){
		var GroupId=session['LOGON.GROUPID'];
		PayDetailStore.load({params:{actiontype:'GrpLocForPayMon',GroupId:GroupId,start:0,limit:999}});
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
			header : "上期截止日期",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
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
			header:'本期截止日期',
			dataIndex:'CurEndDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false
			})
		}]);
	//根据上期截止日期计算本期开始日期
	function curstartdate(value,rec){
		var curStartDate=today.add(Date.DAY,-30);
		if(rec!=null){
			if(rec.lastToDate!=null & rec.lastToDate!=""){
				//上期截止日期日期转换成Date类型后加1秒
				curStartDate=toDate(rec.lastToDate).add(Date.DAY,1);
			}
		}
		return curStartDate;
	}
	
	
	var PayDetailStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: Url,
		storeId: 'PayDetailStore',
		root: 'rows',
		totalProperty : "results",
		idProperty: 'Rowid',  
		fields: [{name:'Rowid',mapping:'lastPayMonRowid'},{name:'LocId',mapping:'RowId'}, {name:'LocDesc',mapping:'Description'}, {name:'Month',mapping:'lastMonth'}, 
			{name:'StartDate',mapping:'lastFrDate'},{name:'EndDate',mapping:'lastToDate'},
			{name:'CurMonth',defaultValue:today.getFullYear()+"-"+(today.getMonth()+1)},{name:'CurStartDate',type:'date',dateFormat:DateFormat,convert:curstartdate},
			{name:'CurEndDate',type:'date',dateFormat:DateFormat,defaultValue:today.add(Date.DAY,-1).format(ARG_DATEFORMAT)}]
	});
	
	var PayDetailGrid = new Ext.ux.EditorGridPanel({
			id : 'PayDetailGrid',
			region : 'center',
			title : '生成付款月报',
			tbar : [OkBT],
			cm : DetailCm,
			store : PayDetailStore,
			sm : selcol,
			listeners : {
				beforeedit : function(e){
					var field=this.getColumnModel().getDataIndex(e.column);
					if(field=="CurStartDate"){
						if(e.record.get("Rowid")!=""){
							e.cancel=true;      //存在上期付款月报的话，本期开始日期不能修改
						}
					}
				},
				afteredit : function(e){
					this.getSelectionModel().selectRow(e.row,true);
				}
			}
		});
	
	//查询付款月报
	function QueryPay(){
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
	//删除某付款月报
	function Delete(){
		var rowid=null;
		var selectRow=PayMainGrid.getSelectionModel().getSelected();
		if(selectRow){
			rowid=selectRow.get("pmRowid");
		}
		if(rowid==null || rowid==""){
			Msg.info("warning","请选择要删除的付款月报!");
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
					QueryPay();
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info('warning','该付款月报不是最后一份付款月报，不允许删除!');
					}else{
						Msg.info('error','删除失败!');
					}			
				}
				
				loadMask.hide();
			}
		});
	}
	
	var StYear=new Ext.form.TextField({
		fieldLabel:'月份',
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:60,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:40,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdYear',
		name:'EdYear',
		anchor:'90%',
		width:60,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		anchor:'90%',
		width:40,
		value:(today.getMonth()+1)
	});
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		fieldLabel : '科室',
		width : 200,
		listWidth : 400,
		anchor: '90%',
		separator:'^',	//科室id用^连接
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
		idProperty:'pmRowid',
		fields:['pmRowid','locDesc','MonthDate','frDate','toDate','LastRpAmt','ArrearRpAmt','PayedRpAmt','EndRpAmt','createDate','userName']
	});
	
	var mainChkCol=new Ext.grid.CheckboxSelectionModel({checkOnly:true,singleSelect:true});
	var PayMainGrid = new Ext.ux.GridPanel({
		region:'south',
		height:300,
		split:true,
		id:'PayMainGrid',
		title:'历史付款月报',
		store:MainStore,
		tbar:['科室:',PhaLoc,{xtype:'tbtext',text:'付款月报范围:'},
			StYear,{xtype:'tbtext',text:'年'},StMonth,{xtype:'tbtext',text:'月----'},
			EdYear,{xtype:'tbtext',text:'年'},EdMonth,{xtype:'tbtext',text:'月'},
			SearchBT,'-',DeleteBT
		],
		cm:new Ext.grid.ColumnModel([mainChkCol,{
				header:'Rowid',
				dataIndex:'pmRowid',
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
				dataIndex:'MonthDate',
				width:100,
				align:'left',
				sortable:true
			},{
				header : "上期结余金额",
				dataIndex : 'LastRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "本期增加金额",
				dataIndex : 'ArrearRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "本期付款金额",
				dataIndex : 'PayedRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "本期结余金额",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header:'付款月报起始日期',
				dataIndex:'frDate',
				width:150,
				align:'left',
				sortable:true
			},{
				header:'付款月报截止日期',
				dataIndex:'toDate',
				width:150,
				align:'left',
				sortable:true
			}
		]),
		sm:mainChkCol,
		autoScroll:true
	})

	var myPanel = new Ext.ux.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [PayDetailGrid, PayMainGrid]
	});
	
	QueryPay();
	Query();
})
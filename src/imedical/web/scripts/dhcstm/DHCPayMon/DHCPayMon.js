// /����: ���ɸ����±�
// /����: ���ɸ����±�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.15

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl	+ 'paymonaction.csp?';
	var today=new Date();
	
	// ɾ����ť
	var DeleteBT = new Ext.Toolbar.Button({
				id : "DeleteBT",
				text : 'ɾ��',
				tooltip : '���ɾ��',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					Delete();
				}
			});
			
		// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					QueryPay();
				}
			});
			
	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '���ɸ����±�',
				tooltip : '������ɸ����±�',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					CreateReport();
				}
			});
	
	/**
	 * ���ɸ����±�
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
				Msg.info("warning",LocDesc+"����д��ֹ����!");
				return;
			}
			if (record.get("CurStartDate")==null ||record.get("CurStartDate")=="")
			{
				Msg.info("warning",LocDesc+"����д��ʼ����!");
				return;
			}
			var CurMonth=record.get("CurMonth")+"-"+"01";
			var StartDate = record.get("CurStartDate").format(ARG_DATEFORMAT);
			var EndDate = record.get("CurEndDate").format(ARG_DATEFORMAT);;
			if(StartDate>EndDate){
				Msg.info("warning",LocDesc+"��ֹ����Ҫ���ڿ�ʼ����!");
				return;
			}
			if(EndDate>today.format(ARG_DATEFORMAT)){
				Msg.info("error",LocDesc+"���ڽ�ֹ���ڲ��ܳ�������!");
				return;
			}
			var Params=Loc+"^"+CurMonth+"^"+CreateUser+"^"+StartDate+"^"+EndDate;
			var ExistFlag=CheckIfExist(Loc,CurMonth);
			if(ExistFlag==true){
				Msg.info("warning",LocDesc+'���¸����±��Ѿ����ɣ������������ɵĻ�����ɾ����������!');
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
			Msg.info("warning","��ѡ����Ҫ���ɸ����±��Ŀ���!");
			return;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url:Url+"actiontype=CreatePayReport",
			params:{Params:listParams},
			method:'POST',
			success:function(response,opts){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				loadMask.hide();
				if (jsonData.success == 'true') {
					// ˢ�½���
					Msg.info("success", "���ɸ����±��ɹ�!");
					Query();  //�����±������ɺ�ִ�в�ѯ
					QueryPay();
				} else {
					var ret=jsonData.info;
					Msg.info("error", "���ɸ����±�ʧ�ܣ�"+ret);
				}
			}
		})
	}

	//���ĳ����ĳ�·ݸ����±��Ƿ��Ѿ�����
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
	
	//����Ƿ�������ɸ����±�������(�Ƿ������ɵ�δ���ȷ�ϵĸ��)
	function CheckMonCond(StrParam){
		var MsgInfo = "";
		var NewUrl=Url+"actiontype=CheckPayMonCond&StrParam="+StrParam;
		var responseText=ExecuteDBSynAccess(NewUrl);
		var Ret=jsonData=Ext.util.JSON.decode(responseText).info;
		if(Ret!=="0"){
			if(Ret==-3){
				MsgInfo = "������ɵ���δ���ȷ�ϵĸ��!";
			}else{
				MsgInfo = "�������!";
			}
		}
		return MsgInfo;
	}
	
	//��ѯ
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
			header : '����',
			dataIndex : 'LocDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '�����·�',
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
			header : '������ʼ����',
			dataIndex : 'StartDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ�ֹ����",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true
		},{
			header:'�����·�',
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
			header:'���ڿ�ʼ����',
			dataIndex:'CurStartDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false
			})
		},{
			header:'���ڽ�ֹ����',
			dataIndex:'CurEndDate',
			width:100,
			sortable:false,
			renderer:Ext.util.Format.dateRenderer(DateFormat),
			editor:new Ext.ux.DateField({
				allowBlank:false
			})
		}]);
	//�������ڽ�ֹ���ڼ��㱾�ڿ�ʼ����
	function curstartdate(value,rec){
		var curStartDate=today.add(Date.DAY,-30);
		if(rec!=null){
			if(rec.lastToDate!=null & rec.lastToDate!=""){
				//���ڽ�ֹ��������ת����Date���ͺ��1��
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
			title : '���ɸ����±�',
			tbar : [OkBT],
			cm : DetailCm,
			store : PayDetailStore,
			sm : selcol,
			listeners : {
				beforeedit : function(e){
					var field=this.getColumnModel().getDataIndex(e.column);
					if(field=="CurStartDate"){
						if(e.record.get("Rowid")!=""){
							e.cancel=true;      //�������ڸ����±��Ļ������ڿ�ʼ���ڲ����޸�
						}
					}
				},
				afteredit : function(e){
					this.getSelectionModel().selectRow(e.row,true);
				}
			}
		});
	
	//��ѯ�����±�
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
	//ɾ��ĳ�����±�
	function Delete(){
		var rowid=null;
		var selectRow=PayMainGrid.getSelectionModel().getSelected();
		if(selectRow){
			rowid=selectRow.get("pmRowid");
		}
		if(rowid==null || rowid==""){
			Msg.info("warning","��ѡ��Ҫɾ���ĸ����±�!");
			return false;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url:Url,
			method:'POST',
			params:{actiontype:'Delete',Rowid:rowid},
			success:function(response,request){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				if(jsonData.success=='true'){
					Msg.info('success','ɾ���ɹ�!');
					Query();
					QueryPay();
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info('warning','�ø����±��������һ�ݸ����±���������ɾ��!');
					}else{
						Msg.info('error','ɾ��ʧ��!');
					}			
				}
				
				loadMask.hide();
			}
		});
	}
	
	var StYear=new Ext.form.TextField({
		fieldLabel:'�·�',
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
		fieldLabel : '����',
		width : 200,
		listWidth : 400,
		anchor: '90%',
		separator:'^',	//����id��^����
		store : GetGroupDeptStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// ��¼����Ĭ��ֵ
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
		title:'��ʷ�����±�',
		store:MainStore,
		tbar:['����:',PhaLoc,{xtype:'tbtext',text:'�����±���Χ:'},
			StYear,{xtype:'tbtext',text:'��'},StMonth,{xtype:'tbtext',text:'��----'},
			EdYear,{xtype:'tbtext',text:'��'},EdMonth,{xtype:'tbtext',text:'��'},
			SearchBT,'-',DeleteBT
		],
		cm:new Ext.grid.ColumnModel([mainChkCol,{
				header:'Rowid',
				dataIndex:'pmRowid',
				width:100,
				align:'left',
				hidden:true
			},{
				header:'����',
				dataIndex:'locDesc',
				width:120,
				align:'left',
				sortable:true
			},{
				header:'�·�',
				dataIndex:'MonthDate',
				width:100,
				align:'left',
				sortable:true
			},{
				header : "���ڽ�����",
				dataIndex : 'LastRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "�������ӽ��",
				dataIndex : 'ArrearRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "���ڸ�����",
				dataIndex : 'PayedRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "���ڽ�����",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header:'�����±���ʼ����',
				dataIndex:'frDate',
				width:150,
				align:'left',
				sortable:true
			},{
				header:'�����±���ֹ����',
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
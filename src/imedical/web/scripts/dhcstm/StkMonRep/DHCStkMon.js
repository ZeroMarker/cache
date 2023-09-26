// /����: �����±�
// /����: �����±�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.15

Ext.onReady(function() {
	Ext.Ajax.timeout = 300000;	//��Ӧʱ���Ϊ5min
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url=DictUrl	+ 'stkmonaction.csp?';
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
					var selectRow = MainGrid.getSelectionModel().getSelected();
					if(Ext.isEmpty(selectRow)){
						Msg.info("warning","��ѡ��Ҫɾ�����±�!");
						return false;
					}
					Ext.Msg.show({
						title:'��ʾ',
						msg: 'ȷ��ɾ�� ' + selectRow.get('locDesc') + selectRow.get('mon') + ' ���±���?',
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
			
		// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					QueryRep();
				}
			});
	var ClearBT = new Ext.Button({
		text : '���',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function(){
			MainGrid.getStore().removeAll();
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		}
	});
	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : '�����±�',
				tooltip : '��������±�',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					CreateReport();
				}
			});
	
	var RefreshBT = new Ext.Toolbar.Button({
		id : "RefreshBT",
		text : 'ˢ��',
		tooltip : 'ˢ��',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			Query();
		}
	});
	
	/**
	 * �����±�
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
				//Msg.info("warning",LocDesc+"��ֹʱ��Ҫ���ڿ�ʼʱ��!");
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+"��ֹʱ��Ҫ���ڿ�ʼʱ��!";
				continue;
			}
			if(EndDate >= today.format(ARG_DATEFORMAT)){
				//Msg.info("error",LocDesc+"���ڽ�ֹ���ڲ��ܳ�������!");
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+"���ڽ�ֹ���ڲ��ܳ�������!";
				continue;
			}
			/*
			if(EndDate > today.format(ARG_DATEFORMAT)){
				Msg.info("error",LocDesc+"���ڽ�ֹ���ڲ��ܳ�������!");
				return;
			}else if(EndDate==today.format(ARG_DATEFORMAT)){
				if(EndTime>new Date().format('H:i:s')){
					Msg.info("error",LocDesc+"���ڽ�ֹʱ�䲻��Ϊ���ڵ�ǰʱ��!");
					return;
				}
			}
			*/
			var Params=Loc+"^"+CurMonth+"^"+CreateUser+"^"+StartDate+"^"+EndDate+"^"+StartTime+"^"+EndTime;
			var ExistFlag=CheckIfExist(Loc,CurMonth);
			if(ExistFlag==true){
				//Msg.info("warning",LocDesc+'�����±��Ѿ����ɣ������������ɵĻ�����ɾ����������!');
				CheckInfoStr = CheckInfoStr + '\r\n' + LocDesc+'�����±��Ѿ����ɣ������������ɵĻ�����ɾ����������!';
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
			Msg.info("warning","��ѡ����Ҫ�����±��Ŀ���!");
			return;
		}
		
		if(!Ext.isEmpty(CheckInfoStr) && confirm(CheckInfoStr + '\r\n�Ƿ����?')==false){
			return false;
		}
		
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url:Url+"actiontype=CreateReport",
			params:{Params:listParams},
			method:'POST',
			success:function(response,opts){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				loadMask.hide();
				if (jsonData.success == 'true') {
					// ˢ�½���
					Msg.info("success", "�����±��ɹ�!");
					Query();  //�±������ɺ�ִ�в�ѯ
					QueryRep();
				} else {
					var ret=jsonData.info;
					Msg.info("error", "�����±�ʧ�ܣ�"+ret);
				}
			}
		})
	}

	//���ĳ����ĳ�·��±��Ƿ��Ѿ�����
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
	
	//����Ƿ���������±�������(�Ƿ���δ������ϵĿ��ת�Ƶ�)
	function CheckMonCond(StrParam){
		var MsgInfo = "";
		var NewUrl=Url+"actiontype=CheckMonCond&StrParam="+StrParam;
		var responseText=ExecuteDBSynAccess(NewUrl);
		var Ret=jsonData=Ext.util.JSON.decode(responseText).info;
		if(Ret!=="0"){
			if(Ret==-10){
				MsgInfo = "�жԷ�δ���ܵĿ��ת�Ƶ�!";
			}else if(Ret==-20){
				MsgInfo = "��δ�����յĿ��ת�Ƶ�!";
			}else{
				MsgInfo = "�������!";
			}
		}
		return MsgInfo;
	}
	
	//��ѯ
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
			header : "������ʼʱ��",
			dataIndex : 'StartTime',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ�ֹ����",
			dataIndex : 'EndDate',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���ڽ�ֹʱ��",
			dataIndex : 'EndTime',
			width : 100,
			align : 'center',
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
			header:'���ڿ�ʼʱ��',
			dataIndex:'CurStartTime',
			width:100,
			sortable:false,
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
				width : 120
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
		},{
			header:'���ڽ�ֹʱ��',
			dataIndex:'CurEndTime',
			width:100,
			sortable:false,
			editable : false,		//2014-09-29 ��ֹʱ�䲻�����޸�
			editor:new Ext.form.TextField({
				regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
				regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
				width : 120
			})
		}]);
	//�������ڽ�ֹ���ں�ʱ����㱾�ڿ�ʼ����
	function curstartdate(value,rec){
		var curStartDate=today.add(Date.DAY,-30);
		if(rec!=null){
			if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
				//���ڽ�ֹ����ʱ��ת����Date���ͺ��1��
				curStartDate=toDate(rec.lastToDate+" "+rec.lastToTime).add(Date.SECOND,1);
			}
		}
		return curStartDate;
	}
	
	function curstarttime(value,rec){
		var curStartTime="";
		if(rec!=null){
			if(rec.lastToDate!=null & rec.lastToDate!="" & rec.lastToTime!=null & rec.lastToTime!=""){
				//���ڽ�ֹ����ʱ��ת����Date���ͺ��1��
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
			title : '�����±�',
			tbar : [OkBT, '-', RefreshBT],
			cm : DetailCm,
			store : DetailStore,
			sm : selcol,
			listeners : {
				beforeedit : function(e){
					var field=this.getColumnModel().getDataIndex(e.column);
					if(field=="CurStartDate" || field=="CurStartTime"){
						if(e.record.get("Rowid")!=""){
							e.cancel=true;      //���������±��Ļ������ڿ�ʼ���ںͱ��ڿ�ʼʱ�䲻���޸�
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
							Msg.info('error', '���ڽ�ֹ���ڲ��ܳ�������, ����С����ʼ����!');
							e.record.set('CurEndDate', e.originalValue);
							return;
						}
						
						var NewCurMonth = CurEndDate.getFullYear()+"-"+(CurEndDate.getMonth()+1);
						e.record.set('CurMonth', NewCurMonth);
						
						//�����������
						FillOtherLocInfo(e.record);
					}else if(e.field == 'CurStartDate'){
						FillOtherLocInfo(e.record);
					}
				}
			}
		});
	
	//�����������
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
	
	//��ѯ�±�
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
	//ɾ��ĳ�±�
	function Delete(){
		var rowid=null;
		var selectRow=MainGrid.getSelectionModel().getSelected();
		if(selectRow){
			rowid=selectRow.get("smRowid");
		}
		if(rowid==null || rowid==""){
			Msg.info("warning","��ѡ��Ҫɾ�����±�!");
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
					MainStore.load();
				}else{
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info('warning','���±��������һ���±���������ɾ��!');
					}
					else if(ret==-8)
					{
						Msg.info('warning','���±����ύ��������ɾ��!');
					}
					else{
						Msg.info('error','ɾ��ʧ��!');
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
		fieldLabel : '����',
		listWidth : 400,
		anchor: '90%',
		//separator:'^',	//����id��^����
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
		title:'��ʷ�±�',
		store:MainStore,
		tbar:['����:',PhaLoc,{xtype:'tbtext',text:'�±���Χ:'},
				StYear,{xtype:'tbtext',text:'��'},StMonth,{xtype:'tbtext',text:'��----'},
				EdYear,{xtype:'tbtext',text:'��'},EdMonth,{xtype:'tbtext',text:'��'},
				SearchBT,'-',DeleteBT,'-',ClearBT],
		cm:new Ext.grid.ColumnModel([mainChkCol,{
				header:'Rowid',
				dataIndex:'smRowid',
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
				dataIndex:'mon',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'�±���ʼ����',
				dataIndex:'frDate',
				width:150,
				align:'left',
				sortable:true,
				renderer:function(value,metaData,record,rowIndex,colIndex,store){
					var StDateTime=value+" "+record.get('frTime');
					return StDateTime;
				}
			},{
				header:'�±���ֹ����',
				dataIndex:'toDate',
				width:150,
				align:'left',
				sortable:true,
				renderer:function(value,metaData,record,rowIndex,colIndex,store){
					var EdDateTime=value+" "+record.get('toTime');
					return EdDateTime;
				}
			},{
				header:'�±���',
				dataIndex:'StkMonNo',
				width:140,
				align:'left',
				sortable:true
			},{
				header:'ƾ֤��',
				dataIndex:'AcctVoucherCode',
				width:120,
				align:'left',
				sortable:true
			},{
				header:'ƾ֤����',
				dataIndex:'AcctVoucherDate',
				width:100,
				align:'left',
				sortable:true
			},{
				header:'ƾ֤����״̬',
				dataIndex:'AcctVoucherStatus',
				width:80,
				align:'left',
				sortable:true
			},{
				header:'Pdf�ļ�����',
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

var ShowTrfWin=function(Status,HVFlag,Paramstr,DeskStore) {
	var userId = session['LOGON.USERID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		id : "closeBT",
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'page_delete',
		width : 70,
		height : 30,
		handler : function() {
			DeskStore.reload()
			findWin.close();
		}
	});
	
	// ��ɰ�ť
	var CompleteBT = new Ext.Toolbar.Button({
		id : "CompleteBT",
		text : '���',
		tooltip : 'ֻ��ѡ��һ���������',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			Complete();
		}
	});
	
	// ��˰�ť
	var AuditBT = new Ext.ux.Button({
		id : "AuditBT",
		text : '���',
		tooltip : 'ֻ��ѡ��һ���������',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			Audit();
		}
	});
	
	// ���հ�ť
	var RecAuditBT = new Ext.ux.Button({
		id : "RecAuditBT",
		text : '����',
		tooltip : 'ֻ��ѡ��һ�����н���',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			RecAudit();
		}
	});
	
	function Complete(){
		var gGroupId=session['LOGON.GROUPID'];
		var selectRows = MasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ�񵥾ݽ��в���");
			return;
		}
		var RowId = selectRows[0].get("RowId");
		Ext.Ajax.request({
			url : 'dhcstm.dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='+RowId+'&Status=11&Complete=Y&GroupId='+gGroupId,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "���óɹ�!");
					Query();
				}else{
					Msg.info("error", "����ʧ��:"+jsonData.info);
					return false;
				}
			},
			failure:function(){Msg.info('failure','����ʧ��!');}
		});
	}
	
	function Audit(){
		var gUserId = session['LOGON.USERID'];
		var selectRows = MasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ�񵥾ݽ��в���");
			return;
		}
		var RowId = selectRows[0].get("RowId");
		Ext.Ajax.request({
			url:"dhcstm.dhcinistrfaction.csp?actiontype=AuditStr&RowidStr="
				+ RowId + "&User=" + gUserId,
			success:function(result, request){
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true'){
					Msg.info('success','��˳ɹ�!');
					Query();
				}else{
					if(jsonData.info==-100){
						Msg.info("error", "���ⵥ���Ǵ����״̬!");
					}else if(jsonData.info==-99){
						Msg.info("error", "����ʧ��!");
					}else if(jsonData.info==-1){
						Msg.info("error", "���³��ⵥ״̬ʧ��!");
					}else if(jsonData.info==-3){
						Msg.info("error", "������ʧ��!");
					}else if(jsonData.info==-4){
						Msg.info("error", "����̨��ʧ��!");
					}else if(jsonData.info==-5){
						Msg.info("error", "�����ӱ�״̬ʧ��!");
					}else if(jsonData.info==-6){
						Msg.info("error", "����ռ������ʧ��!");
					}else if(jsonData.info==-7){
						Msg.info("error", "�Զ����ճ��ⵥʧ�ܣ����ֶ�����!");
					}else{
						Msg.info("error", "���ʧ��:"+Ret);
					}
				}
			 },
			failure:function(){Msg.info('failure','���ʧ��!');}
		})
	}
	
	function RecAudit(){
		var gUserId = session['LOGON.USERID'];
		var selectRows = MasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "��ѡ�񵥾ݽ��в���");
			return;
		}
		var RowId = selectRows[0].get("RowId");
		Ext.Ajax.request({
			url:"dhcstm.dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ RowId + "&User=" + gUserId,
			success:function(result, request){
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true'){
					Msg.info('success','��˳ɹ�!');
					Query();
				}else{
					if(jsonData.info==-100){
						Msg.info("error", "���ⵥ���Ǵ�����״̬!");
					}else if(jsonData.info==-99){
						Msg.info("error", "����ʧ��!");
					}else if(jsonData.info==-1 || jsonData.info==-2){
						Msg.info("error", "���³��ⵥ״̬ʧ��!");
					}else if(jsonData.info==-3){
						Msg.info("error", "������ʧ��!");
					}else if(jsonData.info==-4){
						Msg.info("error", "����̨��ʧ��!");
					}else{
						Msg.info("error", "����ʧ��:"+jsonData.info);
					}
				}
			 },
			failure:function(){Msg.info('failure','���ʧ��!');}
		})
	}
	
	function setBTStatus(Status){
		var StatusArr=Status.split("^");
		var compstatus=StatusArr[0];
		var auditstatus=StatusArr[1];
		var recauditstatus=StatusArr[2];
		
		if(compstatus=="Y"){Ext.getCmp("CompleteBT").enable();}
		else{Ext.getCmp("CompleteBT").disable();}
		
		if(auditstatus=="Y"){Ext.getCmp("AuditBT").enable();}
		else{Ext.getCmp("AuditBT").disable();}
		
		if(recauditstatus=="Y"){Ext.getCmp("RecAuditBT").enable();}
		else{Ext.getCmp("RecAuditBT").disable();}
	}
	// ��ʾ��������
	function Query() {
		if(Status=="NoComp"){
			setBTStatus("Y^N^N")
		}else if(Status=="NoHVComp"){
			setBTStatus("Y^N^N")
		}else if(Status=="NoOutAudit"){
			setBTStatus("N^Y^N")
		}else{
			setBTStatus("N^N^Y")
		}
		var MainInfo=Status+"^"+HVFlag;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('MainStr',MainInfo);
		MasterStore.setBaseParam('ParamStr',Paramstr);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(success==false){
					Msg.info("error", "��ѯ������鿴��־!");
				}else{
					if(r.length>0){
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			}
		});
	}
	
	// ����·��
	var MasterUrl = 'dhcstm.deskaction.csp?actiontype=QueryTrf';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : MasterUrl,
		method : "POST"
	});
	// ָ���в���
	var fields = ["RowId","No","FrLocDesc","ToLocDesc","UserName","Date","Time","CompFlag","OutAuditFlag","InAuditFlag","ScgDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
	});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var nm = new Ext.grid.RowNumberer();
	var	sm=new Ext.grid.RowSelectionModel({
		singleSelect : true
	});
	var MasterCm = new Ext.grid.ColumnModel([nm,{
			header : "RowId",
			dataIndex : 'RowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "����",
			dataIndex : 'No',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'FrLocDesc',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : "������",
			dataIndex : 'ToLocDesc',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'ScgDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "�Ƶ���",
			dataIndex : 'UserName',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Date',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "ʱ��",
			dataIndex : 'Time',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��ɱ�־",
			dataIndex : 'CompFlag',
			width : 80,
			align : 'left'
		}, {
			header : "���״̬",
			dataIndex : 'OutAuditFlag',
			width : 80,
			align : 'left'
		}, {
			header : "����״̬",
			dataIndex : 'InAuditFlag',
			width : 80,
			align : 'left'
		}]);
	MasterCm.defaultSortable = true;

	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});

	var MasterGrid = new Ext.grid.GridPanel({
		id:'MasterGrid',
		region: 'center',
		split: true,
		height: 250,
		margins: '0 5 0 0',
		layout: 'fit',
		cm : MasterCm,
		sm: sm,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar
	});
	
	var findWin = new Ext.Window({
		title:'������',
		id:'findWin',
		width:gWinWidth,
		height:gWinHeight,
		plain:true,
		modal:true,
		layout : 'border',
		items : [MasterGrid],
		tbar : [CompleteBT,'-',AuditBT,'-',RecAuditBT,'-',closeBT]
		
	});
	
	//��ʾ����
	findWin.show();
	Query();
}
// /����: ���۵���Ч���޸�
// /����: ���۵���Ч���޸�
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.07

Ext.onReady(function(){
	var gUserId = session['LOGON.USERID'];
	var gHospId=session['LOGON.HOSPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var ItmDesc = new Ext.ux.TextField({
				fieldLabel : '��������',
				id : 'ItmDesc',
				name : 'ItmDesc',
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == 13) {
							var item=field.getValue();
							if (item != null && item.length > 0) {
								GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", gHospId,getDrugList);
								
							}
						}
					}
				}
			});

	// ���۵���
	var AspBatNo = new Ext.ux.TextField({
				fieldLabel : '���۵���',
				id : 'AspBatNo',
				name : 'AspBatNo'
				
			});

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			name : 'StartDate',
			value : new Date().add(Date.DAY,-1)
		});

	// ��������
	var EndDate= new Ext.ux.DateField({
			fieldLabel : '��������',
			id : 'EndDate',
			name : 'EndDate',
			value : new Date()
		});

	var TypeStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [ ['A', '�����δ��Ч'],
						['Y', '����Ч']]
			});
	var Type = new Ext.ux.LocalComboBox({
				fieldLabel : '���۵�״̬',
				id : 'Type',
				name : 'Type',
				store : TypeStore
			});
	Ext.getCmp("Type").setValue("A");
	
	// ��ѯ
	var SearchBT = new Ext.ux.Button({
				id : "SearchBT",
				text : '��ѯ',
				iconCls : 'page_find',
				handler : function() {
					getAspBatDetail();
				}
			});

	// ��հ�ť
	var ClearBT = new Ext.ux.Button({
				id : "ClearBT",
				text : '���',
				iconCls : 'page_clearscreen',
				handler : function() {
					clearData();
				}
			});
	/**
	 * ��շ���
	 */
	function clearData() {
		gInciRowId="";
		Ext.getCmp("AspBatNo").setValue("");
		Ext.getCmp("ItmDesc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("Type").setValue("A");
		//Ext.getCmp("SupplyPhaLoc").setDisabled(0);

		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		// �����ť�Ƿ����
		//changeButtonEnable("1^1^1^1^1^0^0^0");
	}

	// ������Ч��ť
	var ExecuteBT = new Ext.ux.Button({
				id : "ExecuteBT",
				text : '������Ч',
				iconCls : 'page_gear',
				handler : function() {					
					// ������Ч���۵�
					ExecuteAspBat();
				}
			});

	/**
	 * ������Ч���۵�
	 */
	function ExecuteAspBat() {
		//���ѡ����
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		var StrAspBatId="";
		for (var i = 0; i < rowCount; i++) {				
			//ѭ��ÿ��ѡ�������
			if(sm.isSelected(i)){
				var record = store.getAt(i);
				var status=record.get("Status");
				if(status=="����Ч"){
					Msg.info("warning","�Ѿ���Ч�ļ�¼�����ظ���Ч!");
					return;
				}
				if(record.dirty){
					Msg.info("warning","�����޸Ĺ��ļ�¼�����ȱ���!");
					return;
				}
				var detailId = record.get('AspBatId');	
				if(StrAspBatId==""){
					StrAspBatId=detailId;
				}
				else{
					StrAspBatId=StrAspBatId+"^"+detailId;
				}
			}
		}
		if(StrAspBatId==""){
			Msg.info("warning","û����Ҫ������Ч������!");
			return;
		}		
		var mask=ShowLoadMask(Ext.getBody(),"������...");
		var Params=gGroupId+"^"+gLocId+"^"+gUserId
		//�ύ���ݿ�ִ������
		Ext.Ajax.request({
			url : DictUrl+'inadjpricebatchaction.csp?actiontype=Execute',
			method : 'POST',
			params:{StrAspBatId:StrAspBatId,Params:Params},
			success : function(response) {
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", "�ɹ���");
				}else if(jsonData.info==-3){
					Msg.info("warning", "���󣺴�������Ч�ĵ��۵�,�����ظ���Ч!");
					return;
				}else{
					Msg.info("error", "����:"+jsonData.info);
					return;
				}
				
				getAspBatDetail();
			},
			failure : function(response){
				Msg.info("error", "��������"+response.responseText);					
				return;
			}
		});		
	}
	
	// �ύ�޸�
	var UpdateBT = new Ext.ux.Button({
		id : "UpdateBT",
		text : '����',
		iconCls : 'page_save',
		handler : function() {					
			// �޸ĵ����ۼ�
			UpdateAsp();
		}
	});
	
	// �޸ĵ����ۼ�
	function UpdateAsp(){
		var count=DetailGrid.getStore().getCount();
		var strdata=null;
		for(var i=0;i<count;i++){
			var record=DetailGrid.getStore().getAt(i);
			//���ݷ����仯ʱִ����������
			if(record.dirty){
				var aspBatId=record.get("AspBatId");
				var resultSp=record.get("ResultSpUom");
				var resultRp=record.get("ResultRpUom");
				var status=record.get("Status");
				var exedate=record.get("ExecuteDate");
				
				var today=new Date().format(DateFormat);
				if((status=="����Ч")&&(exedate!=today)){
					continue;     //��������Ч��¼��ֻ����õ�����Ч�ĵ���۸�
				}
				if(strdata==null){
					strdata=aspBatId+"^"+resultSp+"^"+resultRp;
				}else{
					strdata=strdata+xRowDelim()+aspBatId+"^"+resultSp+"^"+resultRp;
				}
			}
		}
		if(strdata==null){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var Params=gGroupId+"^"+gLocId+"^"+gUserId
		var mask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url:DictUrl+ 'inadjpricebatchaction.csp?actiontype=UpdatePriceAPB',
			method:'POST',
			params:{ListData:strdata,Params:Params},
			success:function(response){
				var jsonData = Ext.util.JSON.decode(response.responseText);
				mask.hide();
				if(jsonData.info==0){
					Msg.info("success", "���³ɹ���");
				}else{
					Msg.info("error", "����:"+jsonData.info);
					return;
				}
				
				getAspBatDetail();
			}
		});
	}
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+ 'inadjpricebatchaction.csp?actiontype=QueryAspBatInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
					
	// ָ���в���
	var fields = ["AspBatId", "AspBatNo","Incib","StkCatDesc", "InciId", "InciCode","InciDesc", 
			 "AspUomDesc","PriorSpUom", "ResultSpUom", "DiffSpUom",
			"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate","Status","ExecuteDate",
			"PreExecuteDate", "AdjReason","Remark",  "AdjUserName","MarkType", "PriceFileNo", "MaxSp","BatExp","AspUomId"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "AspBatId",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{
					StartDate:'',
					EndDate:'',
					Others:''
				}
			});
			
	//¼�������ۺ��ۼۺ����¼�����
	DetailStore.on("update",function(store,record,opt){
		var priorsp=record.get("PriorSpUom");
		var resultsp=record.get("ResultSpUom");
		var priorrp=record.get("PriorRpUom");
		var resultrp=record.get("ResultRpUom");
		record.set("DiffSpUom",Math.round((resultsp-priorsp)*10000)/10000);
		record.set("DiffRpUom",Math.round((resultrp-priorrp)*10000)/10000);
	});
	var detailSM = new Ext.grid.CheckboxSelectionModel();
	//ע��ѡ������¼�
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
				header : "AspBatId",
				dataIndex : 'AspBatId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���۵���",
				dataIndex : 'AspBatNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {   
			       header : "Incib",
				dataIndex : 'Incib',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "״̬",
				dataIndex : 'Status',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "������",
				dataIndex : 'StkCatDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '���ʴ���',
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'InciDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "���۵�λ",
				dataIndex : 'AspUomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
			       header : "����/Ч��",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��ǰ����",
				dataIndex : 'PriorRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "��ǰ�ۼ�",
				dataIndex : 'PriorSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'ResultRpUom',
				width : 90,
				align : 'right',
				sortable : true,
				editor:new Ext.ux.NumberField({
					formatType : 'FmtRP',
					allowBlank:false
				})
			}, {
				header : "�����ۼ�",
				dataIndex : 'ResultSpUom',
				width : 80,
				align : 'right',
				sortable : true,
				editor:new Ext.ux.NumberField({
					formatType : 'FmtSP',
					allowBlank:false
				})
			}, {
				header : "���(�ۼ�)",
				dataIndex : 'DiffSpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "���(����)",
				dataIndex : 'DiffRpUom',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "�Ƶ�����",
				dataIndex : 'AdjDate',
				width : 80,
				align : 'left',
				sortable : true				
			}, {
				header : "�ƻ���Ч����",
				dataIndex : 'PreExecuteDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "ʵ����Ч����",
				dataIndex : 'ExecuteDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����ԭ��",
				dataIndex : 'AdjReason',
				width : 100,
				align : 'left',					
				sortable : true
			}, {
				header : "������",
				dataIndex : 'AdjUserName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'MarkType',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����ļ���",
				dataIndex : 'PriceFileNo',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "����ۼ�",
				dataIndex : 'MaxSp',
				width : 90,
				align : 'right',
				sortable : true
			}]);

	var DetailPageToolBar=new Ext.ux.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize
	});
	DetailPageToolBar.addListener('beforechange',function(ptbar,params){
		var records=DetailGrid.getStore().getModifiedRecords();
		if(records.length>0){
			Msg.info("warning","��ǰ�м�¼���ݷ����仯,���ȴ����ڷ�ҳ!!");
			return false;
			}
	})
	var DetailGrid = new Ext.ux.EditorGridPanel({
		id : 'DetailGrid',
		region : 'center',
		title : '���۵�(����)��ϸ',
		cm : DetailCm,
		store : DetailStore,
		sm :detailSM,
		bbar:DetailPageToolBar,
		listeners:{
			'afteredit':function(e){
				if(e.field=='ResultRpUom'){
					var resultRpNew = e.value;
					if (resultRpNew == null || resultRpNew.length <= 0) {
						Msg.info("warning", "������۲���Ϊ��!");
						return;
					}else if (resultRpNew<0) {
						Msg.info("warning", "������۲���С��0!");
						return;
					}else{
						SetMtSpINCIB(resultRpNew,e.record );
					}
				}else if(e.field=='ResultSpUom'){
					var resultSpNew = e.value;
					if(resultSpNew == null || resultSpNew.length <= 0) {
						Msg.info("warning", "�����ۼ۲���Ϊ��!");
						return;
					}else if(resultSpNew<0) {
						Msg.info("warning", "�����ۼ۲���С��0!");
						return;
					}else{
						var resultRpNew = e.record.get("ResultRpUom");
						if(resultSpNew<resultRpNew){
							Msg.info("error", "��"+(e.row+1)+"�е����ۼ�С�ڵ������!");
						}
					}
				}
			}
			
			
			
		}
	});
	DetailGrid.addListener('beforeedit',function(e){
	   var status=e.record.get("Status");
	   var exedate=e.record.get("ExecuteDate");
	   var today=new Date().format(DateFormat);
		if(status=="�����"){
	   		Msg.info("warning","�˼�¼��δ��Ч����ȡ����˺��޸ļ۸�");
	   		e.cancel=true;
			return;
	   }
		if((status=="����Ч")&(exedate!=today)){
	   		Msg.info("warning","�˼�¼���ǽ�����Ч�������޸ļ۸�");
	   		e.cancel=true;
			return;
	   }
	});
	
	//¼�������ۺ����õ����ۼ�
	function SetMtSpINCIB(Rp,record){
		var uomId=record.get("AspUomId");
		var inci=record.get("InciId");
		if(inci==null || inci==""){
			return;
		}
		if(uomId==null || uomId==""){
			return;
		}
		if(Rp==null || Rp==""){
			return;
		}
		//���ݶ������ͼ����ۼ�
		if(GetCalSpFlag()==1){
			var sp=tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMtSp",inci,uomId,Rp);      //ExecuteDBSynAccess(url); ����ֵ�пո������ݱ��治�ɹ�
			if(sp==0){
				Msg.info("warning","�����ۼ�Ϊ0����������ʶ��������Ƿ���ȷ��");
			}
			record.set("ResultSpUom",sp);  
		}
	}		
	/**
	 * ���ط���
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
	
	// ��ʾ���۵�����
	function getAspBatDetail() {
		DetailStore.removeAll();
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if(InciDesc==null || InciDesc==""){
			gInciRowId="";
		}
		var InciRowid=gInciRowId;
		if(InciRowid!=""&InciRowid!=null){
			InciDesc="";
		}
		var AspBatNo=Ext.getCmp("AspBatNo").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		var Status=Ext.getCmp("Type").getValue();
		var Others=AspBatNo+"^"+Status+"^"+InciRowid+"^^"+InciDesc
		if (StartDate == null || StartDate.length <= 0 ) {
			Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
			Ext.getCmp("StartDate").focus();
			return;
		}
		else{
			StartDate=StartDate.format(ARG_DATEFORMAT);
		}
		if (EndDate == null || EndDate.length <= 0 ) {
			Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
			Ext.getCmp("EndDate").focus();
			return;
		}
		else{
			EndDate=EndDate.format(ARG_DATEFORMAT);
		}
		DetailStore.setBaseParam("StartDate",StartDate);
		DetailStore.setBaseParam("EndDate",EndDate);
		DetailStore.setBaseParam("Others",Others);
		var pagesize=DetailPageToolBar.pageSize;
		DetailStore.load({
			params:{start:0,limit:pagesize},
			callback : function(r,options,success) {
				if(success==false){
		 			Msg.info("error", "��ѯ������鿴��־!");
		 		}         				
			}
		});
	}
	
	var MainForm = new Ext.ux.FormPanel({
		title:'���۵�(����)��Ч',
		tbar : [SearchBT, '-', ClearBT, '-',  ExecuteBT, '-',UpdateBT],
		items : [{					
			xtype : 'fieldset',
			title : '��ѯ����',
			defaults:{border:false,xtype:'fieldset'},
			layout : 'column',
			style : 'padding:5px 0px 0px 5px',
			items : [{
				columnWidth : .22,
				items : [StartDate,EndDate]
			},{
				columnWidth : .22,
				items : [Type]
			},{
				columnWidth : .28,
				items : [AspBatNo]
			},{
				columnWidth : .28,
				items : [ItmDesc]
			}]								
		}]
	});
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [MainForm, DetailGrid]
	});			
	getAspBatDetail();    //ҳ����غ���ʾ����˵���
});
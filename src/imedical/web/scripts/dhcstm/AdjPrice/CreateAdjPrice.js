// /����: ���۵�
// /����: �༭���۵�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.02.06

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var LocId=session['LOGON.CTLOCID'];
	var GroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	if(gParam.length<1){
		GetParams();		//��ʼ����������
	}
	
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		fieldLabel:'<font color=blue>��     ��</font>',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:LocId,
		UserId:userId,
		anchor:'90%'
	}); 
	
	// ���۵���
	var AdjSpNo = new Ext.form.TextField({
		fieldLabel : '���۵���',
		id : 'AdjSpNo',
		name : 'AdjSpNo',
		anchor:'90%'
	});

	var StartDate=new Ext.ux.DateField({
		id:'StartDate',
		name:'StartDate',
		fieldLabel:'��ʼ����',
		value:new Date().add(Date.DAY,-1)
	})
	
	var EndDate=new Ext.ux.DateField({
		id:'EndDate',
		name:'EndDate',
		fieldLabel:'��ֹ����',
		value:new Date()
	})
	
	var IncId=new Ext.form.TextField({
		id:'IncId',
		name:'IncId',
		value:''
	});
	
	var IncDesc=new Ext.form.TextField({
		id:'IncDesc',
		name:'IncDesc',
		fieldLabel:'��������',
		anchor:'90%',
		listeners:{
			'specialkey':function(field,e){
				var keycode=e.getKey();
				if(keycode==13){
					var input=field.getValue();
					var stkgrpid=Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderWindow(input, stkgrpid, App_StkTypeCode, "", "N","", HospId, getDrug);
				}
			}
		}
	});
	
	/**
	 * ���ط���
	*/
	function getDrug(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("IncId").setValue(inciDr);
		Ext.getCmp("IncDesc").setValue(inciDesc);
	}
	
	// ��ѯ
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '��ѯ',
		tooltip : '�����ѯ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			AdjPriceSearch();
		}
	});

	//��ѯ������Ϣ
	function AdjPriceSearch(){
		var stkgrpid=Ext.getCmp("StkGrpType").getValue();
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			return;			
		}
		var stdate=Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT);
		var eddate=Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT);		
		var inciDesc=Ext.getCmp("IncDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var incid=Ext.getCmp("IncId").getValue();
		if(incid!=""&incid!=null){
			inciDesc="";
		}
		var aspno=Ext.getCmp("AdjSpNo").getValue();		
		var params=aspno+"^No^"+incid+"^"+stkgrpid+"^"+inciDesc;
		DetailStore.load({params:{start:0,limit:999,StartDate:stdate,EndDate:eddate,Others:params}});
	}
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			if (isDataChanged(HisListTab,DetailGrid)){
				Ext.Msg.show({
					title:'��ʾ',
					msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
					buttons: Ext.Msg.YESNO,
					fn: function(btn){
						if (btn=='yes') {
							clearData();
							SetFormOriginal(HisListTab);
						}
					}
				})
			}else{
				clearData(); 
				SetFormOriginal(HisListTab);
			}
		}
	});
	/**
	 * ��շ���
	 */
	function clearData() {
		StkGrpType.setDisabled(false);
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").setValue("");
		StkGrpType.store.load();
		Ext.getCmp("AdjSpNo").setValue("");
		Ext.getCmp("IncDesc").setValue("");
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	
	var AddDetailBT=new Ext.Button({
		text:'����һ��',
		tooltip:'',
		iconCls:'page_add',
		height : 30,
		width : 70,
		handler:function(){
                        var stkgrptype=Ext.getCmp("StkGrpType").getValue();
		        if (stkgrptype==""||stkgrptype.length<=0){
			    Msg.info("warning","���鲻��Ϊ�գ�");
			    return false;
			    }
			addNewRow();
		}
	});

	var DelDetailBT=new Ext.Button({
		text:'ɾ��һ��',
		tooltip:'',
		iconCls:'page_delete',
		height : 30,
		width : 70,
		handler:function(){
			deleteDrug();
		}
	});

	// �½���ť
	var AddBT = new Ext.Toolbar.Button({
		id : "AddBT",
		text : '�½�',
		tooltip : '����½�',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
                        var stkgrptype=Ext.getCmp("StkGrpType").getValue();
		        if (stkgrptype==""||stkgrptype.length<=0){
			    Msg.info("warning","���鲻��Ϊ�գ�");
			    return false;
			    }
			addNewRow();
		}
	});
	/**
	 * ����һ��
	 * 
	 */
	function addNewRow() {
		if(DetailGrid.activeEditor!=null){DetailGrid.activeEditor.completeEdit();}
		StkGrpType.setDisabled(true);
		// �ж��Ƿ��Ѿ��������
		var aspReasonId="";
		var aspReason="";
		var colindex=GetColIndex(DetailGrid,"InciDesc");
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount > 0) {
			var rowData = DetailStore.data.items[rowCount - 1];
			var data = rowData.get("InciId");
			if (data == null || data.length <= 0) {
				DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
				return;
			}
			var aspno=rowData.get("AspNo");
			var curaspno=Ext.getCmp("AdjSpNo").getValue();
			if(aspno!="" & aspno!=null & (curaspno==null || curaspno=="")){
				Msg.info("warning","����׷�ӣ���ѡ��ĳһ���۵�����׷�ӣ����Ҫ�½����۵���������գ�");
				return;
			}
			//Ĭ�ϵ���ԭ��
			if(IfSetAspReason()=='Y'){
				aspReasonId=rowData.get("AdjReasonId");
				aspReason=rowData.get("AdjReason");
			}
		}
		var defaData = {
			PriorSpUom : 0,
			MaxSp : 0,
			ResultSpUom : 0,
			DiffSpUom : 0,
			PriorRpUom : 0,
			ResultRpUom : 0,
			DiffRpUom : 0,
			PreExecuteDate : new Date().add(Date.DAY,1),
			AdjReasonId : aspReasonId,
			AdjReason : aspReason
		};
		var NewRecord = CreateRecordInstance(DetailStore.fields,defaData)
		DetailStore.add(NewRecord);
		DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);
	}

	// ���水ť
	var SaveBT = new Ext.ux.Button({
		id : "SaveBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			if(CheckDataBeforeSave()==true){
				// ������۵�
				save();
			}
		}
	});

	function CheckDataBeforeSave(){
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount<=0) { 
			Msg.info("warning","û�е��ۼ�¼!");
			return false;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){
				var IncRowid = rowData.get("InciId");
				if(Ext.isEmpty(IncRowid)){
					continue;
				}
				var ResultSp = rowData.get("ResultSpUom");
				var ResultRp = rowData.get("ResultRpUom");
				var AdjSpReasonId = rowData.get("AdjReasonId");
				var AdjSpUomId = rowData.get("AspUomId");
				var MaxSp=rowData.get("MaxSp");
				var PriceFileDate =Ext.util.Format.date(rowData.get("PreExecuteDate"),ARG_DATEFORMAT);
				var AdjSpReason = rowData.get("AdjReasonId");
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ۲���Ϊ��!");
					return false;
				}
				if(ValidateMaxSp()=="Y"){
					if ((MaxSp!="")&&(ResultSp>MaxSp)) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ۲��ܴ�������ۼ�!");
					return false;}
				}
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ۲���Ϊ��!");
					return false;
				}
				if (AdjSpUomId == null || AdjSpUomId.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е�λ����Ϊ��!");
					return false;
				}
				if (PriceFileDate == null || PriceFileDate.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�мƻ���Ч���ڲ���Ϊ��!");
					return false;
				}
				var nowdate = new Date();
				if (PriceFileDate <= nowdate.format(ARG_DATEFORMAT)) {
					Msg.info("warning", "��"+(i+1)+"�мƻ���Ч���ڲ���С�ڻ���ڵ�ǰ����!");
					return false;
				}
				if(gParam[4]!="Y"&&(AdjSpReason==null||AdjSpReason=="")){
					Msg.info("warning", "��"+(i+1)+"����ԭ����Ϊ��!");
					return false;
				}
			}
		}	
		return true;
	}
	/**
	 * ������۵�
	 */
	function save() {
		//���۵���
		var AdjSpNo = Ext.getCmp("AdjSpNo").getValue();
		var StkGrp=Ext.getCmp("StkGrpType").getValue();
		var list="";	 
		//������ϸ
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);		 
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){
				var AspRowid = rowData.get("AspId");
				var IncRowid = rowData.get("InciId");				
				if(IncRowid=="" || IncRowid.length<=0){
					continue;
				}				
				var PreExecuteDate =Ext.util.Format.date(rowData.get("PreExecuteDate"),ARG_DATEFORMAT);				
				var IncDesc=rowData.get("InciDesc");
				var AdjSpUomId = rowData.get("AspUomId");
				var ResultSp = rowData.get("ResultSpUom");
				var ResultRp = rowData.get("ResultRpUom");
				var AdjSpReasonId = rowData.get("AdjReasonId");					
				var PriceFileNo = rowData.get("WarrentNo");
				var PriceFileDate =Ext.util.Format.date(rowData.get("WnoDate"),ARG_DATEFORMAT);;
				var Remark = rowData.get("Remark");
				var InvoNo = rowData.get("InvNo");
				var InvoDate = Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
				var PriorRp=rowData.get("PriorRpUom");
				var PriorSp=rowData.get("PriorSpUom");
				var data =AspRowid+"^"+ PreExecuteDate + "^" + IncRowid + "^" + AdjSpUomId + "^"
						+ ResultSp + "^" + ResultRp + "^" + userId+ "^" + AdjSpReasonId+ "^" + HospId+ "^" 
						+ PriceFileNo +"^" + PriceFileDate +"^" + Remark+ "^"+InvoNo+"^"+InvoDate+"^"+PriorRp+"^"+PriorSp;
				if(list==""){
					list=data;
				}else{
					list=list+xRowDelim()+data;
				}
			}
		}
		if (list==""){
			Msg.info("warning","û����Ҫ���������");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		var url = DictUrl+ "inadjpriceaction.csp?actiontype=Save";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params: {AspNo:AdjSpNo,StkGrp:StkGrp,LocId:LocId,list:list},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success","����ɹ�!");
					// �ش�
					if(AdjSpNo==""){
						AdjSpNo = jsonData.info;
						Ext.getCmp("AdjSpNo").setValue(AdjSpNo);
					}
					AdjPriceSearch();
				} else {
					var ret=jsonData.info;
					var arr=ret.split("^");
					ret=arr[0];
					var IncDesc=arr[1];
					if(ret==-5){
						Msg.info("error", IncDesc+"����δ��Ч�ĵ��۵��������½����۵���");
					}else if(ret==-7){
						Msg.info("error", IncDesc+"�����ѵ��ۣ������ٽ����۵���");
					}else if(ret==-1){
						Msg.info("error", "����"+IncDesc+"Id����Ϊ�գ�");
					}else if(ret==-2){
						Msg.info("error", "����"+IncDesc+"��Ч��");
					}else if(ret==-3){
						Msg.info("error", "���۵��Ų���Ϊ�գ�");
					}else if(ret==-4){
						Msg.info("error", "�ƻ���Ч���ڲ���Ϊ�գ�");
					}else{
						Msg.info("error", IncDesc+"����ʧ�ܣ�"+jsonData.info);
					}
				}
			},
			scope : this
		});
	}

	/**
	 * ɾ��ѡ��������
	 */
	function deleteDrug() {		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var AspRowId = record.get("AspId");
		if (AspRowId == null || AspRowId.length <= 0) {
			DetailGrid.getStore().remove(record);
			DetailGrid.getView().refresh();
		} else {
			Ext.MessageBox.show({
				title : '��ʾ',
				msg : '�Ƿ�ȷ��ɾ�������ʵ�����Ϣ',
				buttons : Ext.MessageBox.YESNO,
				fn : showResult,
				icon : Ext.MessageBox.QUESTION
			});
		}
	}
	/**
	 * ɾ����ʾ
	 */
	function showResult(btn) {
		if (btn == "yes") {
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var AspRowId = record.get("AspId");
			// ɾ����������
			var url = DictUrl
					+ "inadjpriceaction.csp?actiontype=DeleteAspItm&AspRowid="
					+ AspRowId;
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : 'ɾ����...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					mask.hide();
					if (jsonData.success == 'true') {
						Msg.info("success", "ɾ���ɹ�!");
						DetailGrid.getStore().remove(record);
						DetailGrid.getView().refresh();
					} else {
						Msg.info("error", "ɾ��ʧ�ܣ�"+jsonData.info);
					}
				},
				scope : this
			});
		}
	}

	// ��λ
	var CTUom = new Ext.form.ComboBox({
		fieldLabel : '��λ',
		id : 'CTUom',
		name : 'CTUom',
		anchor : '90%',
		width : 120,
		store : ItmUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false,
		triggerAction : 'all',
		emptyText : '��λ...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 10,
		listWidth : 250,
		valueNotFoundText : ''
	});
	
	/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
		var IncRowid = record.get("InciId");
		ItmUomStore.removeAll();
		ItmUomStore.load({params:{ItmRowid:IncRowid}});
	});

	/**
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);	
		var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
		var BUom = record.get("BUomId");
		var ConFac = record.get("ConFacPur");   //��λ��С��λ��ת����ϵ
		var AdjUom = record.get("AspUomId");    //Ŀǰ��ʾ�ĵ��۵�λ
		var PriorSpUom = Number(record.get("PriorSpUom"));
		var PriorRpUom = Number(record.get("PriorRpUom"));
		var ResultSpUom = Number(record.get("ResultSpUom"));
		var ResultRpUom = Number(record.get("ResultRpUom"));		
		if (value == null || value.length <= 0) {
			return;
		} else if (AdjUom == value) {
			return;
		} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
			record.set("PriorSpUom", PriorSpUom.div(ConFac));
			record.set("PriorRpUom", PriorRpUom.div(ConFac));
			record.set("ResultSpUom", ResultSpUom.div(ConFac));
			record.set("ResultRpUom", ResultRpUom.div(ConFac));
			record.set("DiffRpUom", (ResultRpUom.add(-PriorRpUom.div(ConFac))));
			record.set("DiffSpUom", (ResultSpUom.add(-PriorSpUom.div(ConFac))));
		} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
			record.set("PriorSpUom", PriorSpUom.mul(ConFac));
			record.set("PriorRpUom", PriorRpUom.mul(ConFac));
			record.set("ResultSpUom", ResultSpUom.mul(ConFac));
			record.set("ResultRpUom", ResultRpUom.mul(ConFac));
			record.set("DiffRpUom", (ResultRpUom.add(-PriorRpUom.mul(ConFac))));
			record.set("DiffSpUom", (ResultSpUom.add(-PriorSpUom.mul(ConFac))));
		}
		record.set("AspUomId", combo.getValue());
	});
			
	ReasonForAdjSpStore.load();
	var AdjSpReason = new Ext.form.ComboBox({
		fieldLabel : '����ԭ��',
		id : 'AdjSpReason',
		name : 'AdjSpReason',
		anchor : '90%',
		width : 100,
		store : ReasonForAdjSpStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all',
		emptyText : '����ԭ��...',
		selectOnFocus : true,
		forceSelection : true,
		listWidth : 150,
		minChars : 1,
		valueNotFoundText : '',
		listeners:{
			specialKey:function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					addNewRow();
				}
			}
		}
	});

	//¼�������ۺ����õ����ۼ�
	function SetMtSp(Rp){
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
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
			//var url=DictUrl+"inadjpriceaction.csp?actiontype=GetMtSp&InciId="+inci+"&UomId="+uomId+"&Rp="+Rp;
			var sp=tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMtSp",inci,uomId,Rp);      //ExecuteDBSynAccess(url); ����ֵ�пո������ݱ��治�ɹ�
			if(sp==0){
				Msg.info("warning","�����ۼ�Ϊ0����������ʶ��������Ƿ���ȷ��");
			}
			record.set("ResultSpUom",sp);  
		}
		//var colindex=GetColIndex(DetailGrid,"ResultSpUom");
		//DetailGrid.startEditing(cell[0],colindex);
	}
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+ "inadjpriceaction.csp?actiontype=QueryAspInfo";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "GET"
	});
	// ָ���в���
	var fields = ["AspId", "StkCatDesc", "InciId", "InciCode","InciDesc", "AspUomId","AspUomDesc",
		"PriorSpUom", "MaxSp", "ResultSpUom", "DiffSpUom","PriorRpUom", "ResultRpUom", "DiffRpUom",{name:'AdjDate',type:'date',dateFormat:DateFormat}, 
		{name:'PreExecuteDate',type:'date',dateFormat:DateFormat},"MarkType", "WarrentNo",{name: "WnoDate",type:'date',dateFormat:DateFormat},"InvNo", 
		{name:"InvDate",type:'date',dateFormat:DateFormat},"AdjReasonId", "AdjReason","Remark", "AspNo", "AdjUserName","BUomId","ConFacPur",
		"MarginNow","Spec",{name:'ExecuteDate',type:'date',dateFormat:DateFormat}];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "AspId",
		fields : fields
	});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	DetailStore.on("update",function(store,record,opt){
		var priorsp=record.get("PriorSpUom");
		var resultsp=record.get("ResultSpUom");
		var priorrp=record.get("PriorRpUom");
		var resultrp=record.get("ResultRpUom");
		record.set("DiffSpUom",accSub(resultsp, priorsp));
		record.set("DiffRpUom",accSub(resultrp, priorrp));
		var MarginNow = '';
		if(resultrp != 0){
			MarginNow = accDiv(resultsp, resultrp);
		}
		record.set("MarginNow",MarginNow);
	});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
			header : "AdjSpRowId",
			dataIndex : 'AspId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "���۵���",
			dataIndex : 'AspNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "RowId",
			dataIndex : 'InciId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
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
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {								
							var group = Ext
									.getCmp("StkGrpType")
									.getValue();
							GetPhaOrderInfo(field.getValue(),
									group);
						}
					}
				}
			}))
		},{
			header : "���",
			dataIndex : 'Spec',
			width : 80,
			//align : 'left',
			sortable : true
		}, {
			header : "���۵�λ",
			dataIndex : 'AspUomId',
			width : 80,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(CTUom),
			renderer : Ext.util.Format.comboRenderer2(CTUom,"AspUomId","AspUomDesc")
		}, {
			header : "��ǰ�ۼ�",
			dataIndex : 'PriorSpUom',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "��ǰ����",
			dataIndex : 'PriorRpUom',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : "�������",
			dataIndex : 'ResultRpUom',
			id:'ResultRpUom',
			width : 90,
			align : 'right',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.ux.NumberField({
				formatType : 'FmtRP',
				selectOnFocus : true,
				allowBlank : false,
				allowNegative : false,
				listeners : {
					'specialkey': function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell=DetailGrid.getSelectionModel().getSelectedCell();
							var rowData = DetailGrid.getStore().getAt(cell[0]);
							var AllowAdjSp = gParam[3];
							if(AllowAdjSp == 'N'){
								var colindex=GetColIndex(DetailGrid,"PreExecuteDate");
							}else{
								var colindex=GetColIndex(DetailGrid,"ResultSpUom");
							}
							DetailGrid.startEditing(cell[0],colindex);
						}
					}
				}
			}))
		}, {
			header : "�����ۼ�",
			dataIndex : 'ResultSpUom',
			id:'ResultSpUom',
			width : 80,
			align : 'right',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.ux.NumberField({
				formatType : 'FmtSP',
				selectOnFocus : true,
				allowBlank : false,
				allowNegative : false,
				listeners : {
					'specialkey': function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var colindex=GetColIndex(DetailGrid,"PreExecuteDate")
							DetailGrid.startEditing(cell[0], colindex);
						}
					}
				}
			}))
		}, {
			header : "��ǰ�ӳ�",
			dataIndex : 'MarginNow',
			width : 90,
			align : 'right',
			sortable : true,
			xtype : 'numbercolumn',
			format : '0.000'
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
			header : "����ۼ�",
			dataIndex : 'MaxSp',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "�ƻ���Ч����",
			dataIndex : 'PreExecuteDate',
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : new Ext.ux.DateField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					'specialkey': function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var colindex=GetColIndex(DetailGrid,"AdjReasonId");
							DetailGrid.startEditing(cell[0], colindex);
						}
					}
				}
			})
		}, {
			header : "�Ƶ�����",
			dataIndex : 'AdjDate',
			width : 80,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat)					
		}, {
			header:'ʵ����Ч����',
			width : 80,
			dataIndex:'ExecuteDate',
			align : 'left',
			renderer : Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : "��������",
			dataIndex : 'MarkType',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����ļ���",
			dataIndex : 'WarrentNo',
			width : 80,
			align : 'left',
			sortable : true,
			editor: new Ext.form.TextField({
			allowBlank: true,
				listeners : {
					'specialkey': function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel()
									.getSelectedCell();
							var col = GetColIndex(DetailGrid,'WnoDate');
							DetailGrid.startEditing(cell[0], col);
						}
					}
				}
			})
		}, {
			header : "����ļ�����",
			dataIndex : 'WnoDate',
			width : 160,
			align : 'left',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : new Ext.ux.DateField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					'specialkey': function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel()
									.getSelectedCell();
							var col = GetColIndex(DetailGrid,'InvNo')
							DetailGrid.startEditing(cell[0], col);
						}
					}
				}
			})
		}, {
			header : "��Ʊ��",
			dataIndex : 'InvNo',
			width : 80,
			align : 'left',
			sortable : true,
			editor: new Ext.form.TextField({
				allowBlank: true
			})
		}, {
			header : "��Ʊ����",
			dataIndex : 'InvDate',
			width : 80,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(DateFormat),
			editor: new Ext.ux.DateField({
			})
		},{
			header : "����ԭ��",
			dataIndex : 'AdjReasonId',
			width:80,
			align:'left',
			sortable:true,
			editor:new Ext.grid.GridEditor(AdjSpReason),
			renderer : Ext.util.Format.comboRenderer2(AdjSpReason,'AdjReasonId','AdjReason')
		}, {
			header : "������",
			dataIndex : 'AdjUserName',
			width : 80,
			align : 'left',
			sortable : true
		},{
			header : "������",
			dataIndex : 'StkCatDesc',
			width : 80,
			align : 'left',
			sortable : true
		}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
		region:'center',
		id : 'DetailGrid',
		title : '���۵���ϸ',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{height:30,width:70,text:'������',iconCls:'page_gear',handler:function(){	GridColSet(DetailGrid,"DHCSTADJSPM");}}]},
		sm : new Ext.grid.CellSelectionModel({}),
		clicksToEdit : 1,
		listeners:{
			'beforeedit':function(e){
				var AllowAdjRp = gParam[2];		//����������۵Ĳ���
				var AllowAdjSp = gParam[3];		//��������ۼ۵Ĳ���
				if(e.field == 'ResultRpUom' && AllowAdjRp == 'N'){
					e.cancel = true;
				}
				if(e.field == 'ResultSpUom' && AllowAdjSp == 'N'){
					e.cancel = true;
				}
			},
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
						SetMtSp(resultRpNew);
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
				}else if(e.field=='PreExecuteDate'){
					var PreExeDate = e.value;
					if (Ext.isEmpty(PreExeDate)) {
						Msg.info("warning", "�ƻ���Ч���ڲ���Ϊ��!");
						e.record.set('PreExecuteDate', e.originalValue);
					}else if (PreExeDate.format(ARG_DATEFORMAT) <= new Date().format(ARG_DATEFORMAT)) {
						Msg.info("warning", "�ƻ���Ч���ڲ���С�ڻ���ڵ�ǰ����!");
						e.record.set('PreExecuteDate', e.originalValue);
					}
				}
			}			
		}
	});

	DetailGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
		e.preventDefault();
		menu.showAt(e.getXY());		
	});
	DetailGrid.addListener("rowclick",function(grid,rowindex,e){
		if(rowindex>=0){
			var record=DetailGrid.getStore().getAt(rowindex);
			var aspno=record.get("AspNo");
			if(aspno!=null & aspno!=""){
				Ext.getCmp("AdjSpNo").setValue(aspno);
			}
		}
	});
	var menu=new Ext.menu.Menu({
		id:'rightMenu',
		height:30,
		items:[{
			id:'delete',
			text:'ɾ��',
			handler:deleteDrug
		}]
	});
	
	/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
					getDrugList);
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
		var WarrentNo=record.get("WarrentNo");
		var WnoDate=record.get("WnoDate");
		var findHVIndex = DetailGrid.getStore().findExact('InciId',inciDr,0);
		if(findHVIndex >= 0){
			Msg.info("warning","�����ʵ��ۼ�¼�Ѿ�¼�룬�����ظ�¼��");
			return;
		}
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		// ѡ����
		var row = cell[0];
		var rowData = DetailGrid.getStore().getAt(row);
		rowData.set("InciId",inciDr);
		rowData.set("InciCode",inciCode);
		rowData.set("InciDesc",inciDesc);
		rowData.set("WarrentNo",WarrentNo);
		rowData.set("WnoDate",Date.parseDate(WnoDate,ARG_DATEFORMAT));		
		//ȡ����������Ϣ
		var url = DictUrl
			+ "inadjpriceaction.csp?actiontype=GetItmInfo&InciId="
			+ inciDr+"&Params="+GroupId+"^"+LocId+"^"+userId;
		Ext.Ajax.request({
			url : url,
			method : 'GET',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {					
					var data=jsonData.info.split("^");
					rowData.set("StkCatDesc", data[3]);
					rowData.set("MarkType", data[5]);
					rowData.set("PriceFileNo", data[10]);
					rowData.set("MaxSp", data[13]);
					var BUomId=data[6];
					var BUomDesc=data[7];
					var PurUomId=data[8];
					var PurUomDesc=data[9];
					var ConFacPur=data[14];     //��λ��С��λ֮���ת����ϵ					
					addComboData(ItmUomStore,PurUomId,PurUomDesc);
					rowData.set("AspUomId", PurUomId);    //Ĭ��Ϊ��λ����
					rowData.set("PriorSpUom", data[11]); 
					rowData.set("PriorRpUom", data[12]); 
					rowData.set("BUomId", BUomId); 
					rowData.set("ConFacPur", ConFacPur); 					
					var ss=new Date().format(ARG_DATEFORMAT)
					rowData.set("AdjDate", Date.parseDate(ss,ARG_DATEFORMAT)); 
					rowData.set("ResultSpUom", data[11]);
					rowData.set("ResultRpUom", data[12]);     //����۸�Ĭ��Ϊ��ǰ�۸�
					//������������ۼ�
					var AllowAdjRp = gParam[2];		//�Ƿ������������
					if(AllowAdjRp == "N"){
						ColDataIndex = "ResultSpUom";
					}else{
						ColDataIndex = "ResultRpUom";
					}
					var colindex=GetColIndex(DetailGrid,ColDataIndex);
					DetailGrid.startEditing(row, colindex);
				} 
			},
			scope : this
		});
	}
	
	function SetPriceColEditable()
	{
		if("undefined" == typeof sssAspType)
		{
			return;
		}
		if (sssAspType=='RP') 
		{
			var cm=DetailGrid.getColumnModel() ;
			if (cm)
			{ 
				var col=cm.getIndexById('ResultRpUom');
				var col2=cm.getIndexById('ResultSpUom');
				cm.setEditable(col,true);
				cm.setEditable(col2,false);
				HisListTab.setTitle("���۵�¼��"+"-����");
			}
		}
		if (sssAspType=='SP') 
		{
			var cm=DetailGrid.getColumnModel() ;
			if (cm)
			{ 
				var col=cm.getIndexById('ResultRpUom');
				var col2=cm.getIndexById('ResultSpUom');
				cm.setEditable(col,false);
				cm.setEditable(col2,true);
				HisListTab.setTitle("���۵�¼��"+"-�ۼ�");
			}
		}	
	}
	
	var HisListTab = new Ext.ux.FormPanel({
		title:'���۵�¼��',
		id : "HisListTab",
		tbar : [SearchBT, '-', ClearBT, '-', AddBT,	'-', SaveBT],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ��Ϣ--<font color=blue>��ɫ������ʾ����Ŀ���ǲ�ѯ����Ҳ�ǵ���¼����������</font>',
			layout : 'column',
			style:'padding:5px 0px 0px 5px',
			defaults:{xtype:'fieldset',border:false},
			items : [{
					columnWidth : .3,
					items : [StartDate,EndDate]
				}, {
					columnWidth : .35,
					items : [StkGrpType,AdjSpNo]
				}, {
					columnWidth : .35,
					items : [IncDesc]
				}]
			
		}]
	});

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab,DetailGrid],
		renderTo:'mainPanel'
	});
	
	RefreshGridColSet(DetailGrid,"DHCSTADJSPM");
	SetPriceColEditable();
})
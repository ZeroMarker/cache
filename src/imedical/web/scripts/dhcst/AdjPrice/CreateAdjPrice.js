// /����: ���۵�
// /����: �༭���۵�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.02.06
var rpdecimal=2;
var spdecimal=2;
var colArr=[];
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var LocId=session['LOGON.CTLOCID'];
	var GroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    if(gParam.length<1){
		GetParams();  //��ʼ����������
	}	
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ�������������� wyx ��������ȡ��������gParamCommon[9]

	}
	
		// ҩƷ����
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			fieldLabel:'<font color=blue>�ࡡ����</font>',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:LocId,
			UserId:userId,
			//width : 150
			anchor:'90%'
		}); 
		
		// ���۵���
		var AdjSpNo = new Ext.form.TextField({
					fieldLabel : '���۵���',
					id : 'AdjSpNo',
					name : 'AdjSpNo',
					//width : 160
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
			fieldLabel:'ҩƷ����',
			width:250,
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
			var stdate=Ext.getCmp("StartDate").getValue().format("Y-m-d");
			var eddate=Ext.getCmp("EndDate").getValue().format("Y-m-d");
			
			var inciDesc=Ext.getCmp("IncDesc").getValue();
			if (inciDesc==""){
				Ext.getCmp("IncId").setValue("");
			}
			var incid=Ext.getCmp("IncId").getValue();
			if(Ext.getCmp("IncDesc").getValue()==""){incid="";}			
			var aspno=Ext.getCmp("AdjSpNo").getValue();
			
			var params=aspno+"^No^"+incid+"^"+stkgrpid;
			DetailStore.load({params:{start:0,limit:999,StartDate:stdate,EndDate:eddate,Others:params}});
		}
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					id : "ClearBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		/**
		 * ��շ���
		 */
		function clearData() {	
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("StkGrpType").setValue("");
			StkGrpType.store.load();
			Ext.getCmp("AdjSpNo").setValue("");
			Ext.getCmp("IncDesc").setValue("");			
			//Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// �����ť�Ƿ����
			//changeButtonEnable("1^1^1^1^1^0^0^0");
		}
		 // ��շ���2 �������½���ʹ��
		 //
		function clearData2() {	
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-1));
			Ext.getCmp("EndDate").setValue(new Date());
			//Ext.getCmp("StkGrpType").setValue("");
			//StkGrpType.store.load();
			Ext.getCmp("AdjSpNo").setValue("");
			Ext.getCmp("IncDesc").setValue("");			
			//Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// �����ť�Ƿ����
			//changeButtonEnable("1^1^1^1^1^0^0^0");
		}
  var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{	
		addNewRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
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
						clearData2();
						addNewRow();                        // ����һ��
							
					}
				});
		/**
		 * ����һ��
		 * 
		 */
		function addNewRow() {
			// �ж��Ƿ��Ѿ��������
			var aspReasonId="";
			var aspReason="";
			var aspRemark="";
			var preexedate="";
			var preexedate=new Date().add(Date.DAY,1);
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("InciId");
				if (data == null || data.length <= 0) {
					Msg.info("warning", "�Ѵ����½���!");
					return;
				}
				var aspno=rowData.get("AspNo");
				var curaspno=Ext.getCmp("AdjSpNo").getValue();
				aspRemark=rowData.get("Remark");
				if(aspno!="" & aspno!=null & (curaspno==null || curaspno=="")){
					Msg.info("warning","����׷�ӣ���ѡ��ĳһ���۵�����׷�ӣ����Ҫ�½����۵���������գ�");
					return;
				}
				//Ĭ�ϵ���ԭ��
				if(IfSetAspReason()=='Y'){
					aspReasonId=rowData.get("AdjReasonId");
					aspReason=rowData.get("AdjReason");
				}
				//Ĭ�ϼƻ���Ч����
				if(gParam[2]=='Y'){
					preexedate=rowData.get("PreExecuteDate");
				}
			}
			var record = Ext.data.Record.create([{
						name : 'AspId',
						type : 'string'
					}, {
						name : 'StkCatDesc',
						type : 'string'
					}, {
						name : 'InciId',
						type : 'string'
					}, {
						name : 'InciCode',
						type : 'string'
					}, {
						name : 'InciDesc',
						type : 'string'
					}, {
						name : 'AspUomId',
						type : 'string'
					}, {
						name : 'PriorSpUom',
						type : 'double'
					}, {
						name : 'MaxSp',
						type : 'double'
					},{
						name : 'ResultSpUom',
						type : 'double'
					},{
						name : 'DiffSpUom',
						type : 'double'
					}, {
						name : 'PriorRpUom',
						type : 'double'
					}, {
						name : 'ResultRpUom',
						type : 'double'
					},{
						name : 'DiffRpUom',
						type : 'double'
					}, {
						name : 'AdjDate',
						type : 'date'
					}, {
						name : 'PreExecuteDate',  //�ƻ���Ч����
						type : 'date'
					}, {
						name : 'ExeDate',  //ʵ����Ч����
						type : 'date'
					}, {
						name : 'AdjReasonId',
						type : 'string'
					},{
						name:'AdjReason',
						type:'string'
					},{
						name : 'MarkType',
						type : 'string'
					}, {
						name : 'WarrentNo',      //����ļ���
						type : 'string'
					}, {
						name : 'WnoDate',      //����ļ�����
						type : 'string'
					},{
						name : 'InvNo',      		//��Ʊ�ţ���Ʊ��
						type : 'string'
					}, {
						name : 'InvDate',      	//��Ʊ����,��Ʊ����
						type : 'string'
					}, {
						name : 'Remark',
						type : 'string'
					}, {
						name : 'AspNo',
						type : 'string'
					}, {
						name : 'AdjUserName',
						type : 'string'
					}, {
			            name: 'FreeDrugFlag',
			            type: 'string'
			        }]);
			var NewRecord = new record({
						AspId : '',
						StkCatDesc: '',
						InciId : '',
						InciCode : '',
						InciDesc : '',
						AspUomId : '',
						PriorSpUom : 0,
						MaxSp : 0,
						ResultSpUom : 0,
						DiffSpUom : 0,
						PriorRpUom : 0,
						ResultRpUom : 0,
						DiffRpUom : 0,
						AdjDate : new Date(),
						PreExecuteDate : preexedate,
						AdjReasonId:aspReasonId,
						AdjReason:aspReason,
						MarkType : '',
						WarrentNo : '',
						WarrentDate:'',
						InvNo:'',
						InvDate:'',
						Remark : aspRemark,
						AspNo : '',
						AdjUserName : '',
						FreeDrugFlag:''
					});
			DetailStore.add(NewRecord);
			var colindex=GetColIndex(DetailGrid,"InciDesc");
			DetailGrid.getSelectionModel().select(DetailStore.getCount() - 1, colindex);
			DetailGrid.startEditing(DetailStore.getCount() - 1, colindex);

		};

		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
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
							// �����ť�Ƿ����
							//changeButtonEnable("0^0^1^1^1^1^1^1");
						}
					}
				});

	function CheckDataBeforeSave(){
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount<=0) 
			{ 
				Msg.info("warning","û�е��ۼ�¼!");	return false;}			
		 
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			 
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){
				
				var ResultSp = rowData.get("ResultSpUom");
				var ResultRp = rowData.get("ResultRpUom");
				var AdjSpReasonId = rowData.get("AdjReasonId");
				var AdjSpUomId = rowData.get("AspUomId");
				var PriceFileDate =Ext.util.Format.date(rowData.get("PreExecuteDate"),"Y-m-d");;
				var WnoDate=Ext.util.Format.date(rowData.get("WnoDate"),"Y-m-d");
				var freedrugflag=rowData.get('FreeDrugFlag');
				
				if((freedrugflag=="Y")&&((ResultRp!=0)||(ResultSp!=0))){
					Msg.info("warning", "��"+(i+1)+"�����ҩ������ۺ͵����ۼ۶�����Ϊ0!");
					return false;
					break;
				}
				var unequalflag=CheckRpEqualSp(i);
				if (unequalflag==false)
				{	
					Msg.info("warning","��"+(i+1)+"��ҩƷΪ��ӳ�,���ۼ۲���,���ʵ��");

				}
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ۲���Ϊ��!");
					return false;
					break;
				}
				
				if (ResultSp == null || ResultSp.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ۲���Ϊ��!");
					return false;
					break;
				}
				if ((ResultSp*1000)<(ResultRp*1000)) {
					Msg.info("warning", "��"+(i+1)+"�е����ۼ�С�ڵ������!");
					return false;
					break;
				}
				if (AdjSpUomId == null || AdjSpUomId.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е�λ����Ϊ��!");
					return false;
					break;
				}
				if (PriceFileDate == null || PriceFileDate.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�мƻ���Ч���ڲ���Ϊ��!");
					return false;
					break;
				}
				var nowdate = new Date();
				if (PriceFileDate <= nowdate.format("Y-m-d")) {
					Msg.info("warning", "��"+(i+1)+"�мƻ���Ч���ڲ���С�ڻ���ڵ�ǰ����!");
					return false;
					break;
				}
				if (AdjSpReasonId == null || AdjSpReasonId.length <= 0) {
					Msg.info("warning", "��"+(i+1)+"�е���ԭ����Ϊ��!");
					return false;
					break;
				}
					
			}	
		}	
		return true;
	}
	/*����ҩƷ�ж��Ƿ���ӳ�*/
	function CheckRpEqualSp(rownum)
	{
		var adjsaleData = DetailStore.getAt(rownum);
		var adjsaleInci = adjsaleData.get("InciId");  //ҩƷid
		///�ж�ҩƷ����
		var equalflag=tkMakeServerCall("web.DHCST.Common.AppCommon","GetZeroMarginByInci",adjsaleInci,GroupId,LocId,userId)   //�Ƿ���Ҫ�ۼ۵��ڽ���
		if (equalflag!="Y")
		{
			return true;
		}
	    var ResultSp = adjsaleData.get("ResultSpUom");
		var ResultRp = adjsaleData.get("ResultRpUom");
		if (ResultSp!=ResultRp)
		{
			return false;
		}	
	}
		/**
		 * ������۵�
		 */
		function save() {
			//���۵���
			var AdjSpNo = Ext.getCmp("AdjSpNo").getValue();
			var StkGrp=Ext.getCmp("StkGrpType").getValue();
			if((StkGrp=="")&&(gParamCommon[9]=='N')){
			    Msg.info("warning","��ǰ�����������鲻����Ϊ��!");	
				return ;
			}
			var list="";
		 
			//������ϸ
			var rowCount = DetailGrid.getStore().getCount();
			
			if (rowCount==0) 
			
			{Msg.info("warning","û�е��ۼ�¼!");	return ;}			
		 
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
			 
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					
					
					var AspRowid = rowData.get("AspId");
					var IncRowid = rowData.get("InciId");
					
					if(IncRowid=="" || IncRowid.length<=0)
					{
						//�Ƴ�����
						DetailGrid.getStore().remove(rowData);
						break;
					}
					
					var PreExecuteDate =Ext.util.Format.date(rowData.get("PreExecuteDate"),App_StkDateFormat);
					/*
					if((PreExecuteDate!="")&(PreExecuteDate!=null)){
						PreExecuteDate=PreExecuteDate.format('Y-m-d');
					}*/
					var IncDesc=rowData.get("InciDesc");
					var AdjSpUomId = rowData.get("AspUomId");
					var ResultSp = rowData.get("ResultSpUom");
					var ResultRp = rowData.get("ResultRpUom");
					var AdjSpReasonId = rowData.get("AdjReasonId");
					//alert(AdjSpReasonId)
					
					var PriceFileNo = rowData.get("WarrentNo");
					var PriceFileDate =Ext.util.Format.date(rowData.get("WnoDate"),App_StkDateFormat);
					var Remark = rowData.get("Remark");
					var InvoNo = rowData.get("InvNo");
					var InvoDate = Ext.util.Format.date(rowData.get("InvDate"),App_StkDateFormat);
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
							Msg.info("error", "ҩƷ"+IncDesc+"Id����Ϊ�գ�");
						}else if(ret==-2){
							Msg.info("error", "ҩƷ"+IncDesc+"��Ч��");
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
		 * ɾ��ѡ����ҩƷ
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
							msg : '�Ƿ�ȷ��ɾ����ҩƷ������Ϣ',
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
				;
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
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '����ԭ��...',
					selectOnFocus : true,
					forceSelection : true,
					listWidth : 150,
					minChars : 1,
					valueNotFoundText : ''
				});
				
		
				
		function rendererReason(value, p, r) {
			var combo = Ext.getCmp('AdjSpReason');
			var index = ReasonForAdjSpStore.find(combo.valueField, value);
			var record = ReasonForAdjSpStore.getAt(index);
			var recordv = combo.findRecord(combo.valueField, value);
			if (value == '' || !recordv) {
				return value;
			}
			var displayText = "";
			if (record == null) {
				displayText = value;
			} else {
				displayText = recordv.get(combo.displayField);
			}
			return displayText;
		}
		
		var ADJRSNCommStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
		});
		
		ADJRSNCommStore.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url : 'dhcst.otherutil.csp?actiontype=ReasonForAdjSpStore&start=0&limit=1000',method:'GET'});
			
		});
		
		var ADJRSNComm = new Ext.form.ComboBox({
			fieldLabel : '����ԭ��',
			id : 'ADJRSNComm',
			name : 'ADJRSNComm',
			anchor : '90%',
			width : 120,
			store : ADJRSNCommStore,
			valueField : 'RowId',
			displayField : 'Description',
			//allowBlank : false,
			triggerAction : 'all',
			emptyText : '����ԭ��...',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			//pageSize : 10,
			listWidth : 250,
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
						}
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
			//��ӳ�Ĭ���ۼ۵��ڽ���
			var equalflag=tkMakeServerCall("web.DHCST.Common.AppCommon","GetZeroMarginByInci",inci,GroupId,LocId,userId)   //�Ƿ���Ҫ�ۼ۵��ڽ���
			if (equalflag=="Y")
			{
				record.set("ResultSpUom",Rp);
			}
			//���ݶ������ͼ����ۼ�
			if((equalflag!="Y")&&(GetCalSpFlag()==1)){
				var url=DictUrl+"inadjpriceaction.csp?actiontype=GetMtSp&InciId="+inci+"&UomId="+uomId+"&Rp="+Rp;
				var sp=ExecuteDBSynAccess(url);
				if(sp==0){
					Msg.info("warning","�����ۼ�Ϊ0�������ҩƷ���������Ƿ���ȷ��");
				}
				record.set("ResultSpUom",sp);
			}
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
				"PriorSpUom", "MaxSp", "ResultSpUom", "DiffSpUom","PriorRpUom", "ResultRpUom", "DiffRpUom",{name:'AdjDate',type:'date',dateFormat:App_StkDateFormat}, 
				{name:'PreExecuteDate',type:'date',dateFormat:App_StkDateFormat},"MarkType", "WarrentNo",{name: "WnoDate",type:'date',dateFormat:App_StkDateFormat},"InvNo", 
					{name:"InvDate",type:'date',dateFormat:App_StkDateFormat},"AdjReasonId", "AdjReason","Remark", "AspNo", "AdjUserName","BUomId","ConFacPur","FreeDrugFlag"];
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
			record.set("DiffSpUom",Math.round((resultsp-priorsp)*10000)/10000);
			record.set("DiffRpUom",Math.round((resultrp-priorrp)*10000)/10000);
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
					align : 'right',
					sortable : true
				}, {
					header : "RowId",
					dataIndex : 'InciId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : 'ҩƷ����',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : 'ҩƷ����',
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
				}, {
					header : "���۵�λ",
					dataIndex : 'AspUomId',
					width : 80,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(CTUom),
					renderer : Ext.util.Format.comboRenderer2(CTUom,"AspUomId","AspUomDesc") // pass combo instance to reusable renderer					
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
					width : 90,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						id:'ResultRpUomEditor',
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false,
						decimalPrecision:rpdecimal,
						listeners : {
							'blur' : function(field, e) {
									// ������֤��ʾдblur����
									var resultRpNew = field.getValue();
									if (resultRpNew == null || resultRpNew.length <= 0) {
										Msg.info("warning", "������۲���Ϊ��!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultRpNew!=0)){
										Msg.info("warning","��"+(cell[0]+1)+"�����ҩ������۱���Ϊ0!");
										return;
									}
								},
							'change':function(field,e){
									var resultRpNew = field.getValue();
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultRpNew!=0)){
									//	Msg.info("warning", "���ҩ������۱���Ϊ0!");
										return;
									}
									SetMtSp(resultRpNew);
							},
							'specialkey': function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var resultRpNew = field.getValue();
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var freedrugflag=record.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultRpNew!=0)){
										//Msg.info("warning", "���ҩ������۱���Ϊ0!");
										return;
									}
									SetMtSp(resultRpNew);
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
									
								}
							}
						}
					}))
				}, {
					header : "�����ۼ�",
					dataIndex : 'ResultSpUom',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						id:'ResultSpUomEditor',
						allowBlank : false,
						allowNegative : false,
						decimalPrecision:spdecimal,
						listeners : {
							'change' : function(field, newValue,oldValue) {
									var resultSpNew = field.getValue();
									if (resultSpNew == null || resultSpNew.length <= 0) {
										Msg.info("warning", "�����ۼ۲���Ϊ��!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(resultSpNew!=0)){
										//Msg.info("warning", "���ҩ�����ۼ۱���Ϊ0!");
										return;
									}
							},
							'blur':function(field,e){
									var resultSpNew = field.getValue();
									if (resultSpNew == null || resultSpNew.length <= 0) {
										Msg.info("warning", "�����ۼ۲���Ϊ��!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var rowData = DetailStore.getAt(cell[0]);
									var ResultSp = field.getValue();
					                var ResultRp = rowData.get("ResultRpUom");
					                var freedrugflag=rowData.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(ResultSp!=0)){
										Msg.info("warning", "��"+(cell[0]+1)+"�����ҩ�����ۼ۱���Ϊ0!");
										return;
									}
					                var MaxSp= rowData.get("MaxSp");
					                if((ResultSp<ResultRp)&(MaxSp!="")){
					                	Msg.info("warning", "��"+(cell[0]+1)+"�е����ۼ�С�ڵ������!");
					                	return;
				                    }
					                if((MaxSp<ResultSp)&(MaxSp!="")){
					                 	Msg.info("warning", "��"+(cell[0]+1)+"�е����ۼ۴�������ۼ�!");
				                        return;
				                     }
				                     var colindex=GetColIndex(DetailGrid,"ResultSpUom");
									DetailGrid.stopEditing(cell[0], colindex);
				                    var unequalflag=CheckRpEqualSp(cell[0]);
									if (unequalflag==false)
									{	
										Msg.info("warning","��ҩƷΪ��ӳ�,���ۼ۲���,���ʵ!");
									}		
							},
							'specialkey': function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var ResultSp = field.getValue();
									var freedrugflag=record.get('FreeDrugFlag');
									if((freedrugflag=="Y")&&(ResultSp!=0)){
										//Msg.info("warning", "���ҩ�����ۼ۱���Ϊ0!");
										return;
									}
									var MaxSp=record.get("MaxSp")
									if((MaxSp!="")&&(MaxSp<ResultSp)){
										Msg.info("warning", "�����ۼ۴�������ۼ�!");
										return;
									}								
									if(setEnterSort(DetailGrid,colArr)){
										addNewRow();
									}									
								}
							}
						}
					}))
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
					align : 'right',
					sortable : true,
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							///specialkey : function(field, e) {
							'change' :function(field, e) {
								///if (e.getKey() == Ext.EventObject.ENTER) {
									
									var expDate = field.getValue();
									if (expDate == null || expDate.length <= 0) {
										Msg.info("warning", "�ƻ���Ч���ڲ���Ϊ��!");
										return;
									}

									var nowdate = new Date();
									if (expDate.format("Y-m-d") <= nowdate
											.format("Y-m-d")) {
										Msg.info("warning", "�ƻ���Ч���ڲ���С�ڻ���ڵ�ǰ����!");
										return;
									}
									///addNewRow();
								///}
							},
							'specialkey': function(field, e) {
								
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
										addNewRow();
									}

									
								}
							}
						}
					})
				}, {
					header : "�Ƶ�����",
					dataIndex : 'AdjDate',
					width : 80,
					align : 'right',
					sortable : true,
					renderer:Ext.util.Format.dateRenderer(App_StkDateFormat)					
				}, {
					header:'ʵ����Ч����',
					width : 80,
					dataIndex:'ExeDate',
					align : 'right',
					renderer:Ext.util.Format.dateRenderer(App_StkDateFormat)
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
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
                	})
				}, {
					header : "����ļ�����",
					dataIndex : 'WnoDate',
					width : 80,
					align : 'right',
					sortable : true,
					renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
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
                    allowBlank: true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
                	})
				}, {
					header : "��Ʊ����",
					dataIndex : 'InvDate',
					width : 80,
					align : 'left',
					sortable : true,
					renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor: new Ext.ux.DateField({
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
					})
				},{
					header : "����ԭ��",
					dataIndex : 'AdjReasonId',
					width:80,
		        	align:'left',
		        	sortable:true,
					renderer:rendererReason,
					editor:new Ext.grid.GridEditor(ADJRSNComm)
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
				},{
					header : "��ע",
					dataIndex : 'Remark',
					width : 350,
					align : 'left',
					sortable : true,
					renderer:formatQtip,
					editor: new Ext.form.TextField({
                    	allowBlank: true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									if(setEnterSort(DetailGrid,colArr)){
											addNewRow();
									}
								}
							}
						}
					})
				 }, {
		            header: "���ҩ��ʶ",
		            dataIndex: 'FreeDrugFlag',
		            width: 80,
		            align: 'left',
		            sortable: true
		        }
			]);
		var GridColSetBT = new Ext.Toolbar.Button({
	      text:'������',
          tooltip:'������',
          iconCls:'page_gear',
          //	width : 70,
         //	height : 30,
	      handler:function(){
		    GridColSet(DetailGrid,"DHCSTADJSP");
	      }
        });
		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title : '���۵���ϸ',
					region:'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					listeners:{
						'beforeedit':function(e)
						{
							if (e.field=='AdjReasonId'){
								if (e.record.data['AdjReasonId']!='') ADJRSNComm.setValue(e.record.data['AdjReasonId']);
							}
							/*ȡ����,��̬����С������λ��,yunhaibao201511224*/
							if((e.field=="ResultRpUom")||(e.field=="ResultSpUom")){
								  var adjpriceuomid=e.record.get('AspUomId');
								  var adjpriceinci=e.record.get('InciId');
								  var decimalstr=tkMakeServerCall("web.DHCST.Common.AppCommon","GetDecimalCommon",GroupId,LocId,userId,adjpriceinci,adjpriceuomid);
								  var decimalarr=decimalstr.split("^");
								  Ext.getCmp("ResultRpUomEditor").decimalPrecision=decimalarr[0];
								  Ext.getCmp("ResultSpUomEditor").decimalPrecision=decimalarr[2];
							}
						}
					
						
					}
				});

		/*DetailGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
			e.preventDefault();
			menu.showAt(e.getXY());
			
		});*/
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
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, group) {
						
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
						getDrugList);
			}
		}

		function addComboData(store, id, desc) {
			var defaultData = {
			RowId : id,
			Description : desc
			};
			var r = new store.recordType(defaultData);
			store.add(r);
		}	

		//����Ƿ��Ѿ�¼����ĳҩƷ�ĵ��ۼ�¼
		function CheckRepeatItm(inci){
			var flag=false;  //���ظ�
			var rowCount=DetailGrid.getStore().getCount()-1;
			for(var i=rowCount-1;i>=0;i--){
				var rowData=DetailGrid.getStore().getAt(i);
				var inciDr=rowData.get("InciId");
				if(inciDr==inci){
					flag=true;
					break;
				}
			}
			
			return flag;
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
			if(CheckRepeatItm(inciDr)==true){
				Msg.info("warning","��ҩƷ���ۼ�¼�Ѿ�¼�룬�����ظ�¼��");
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			// ѡ����
			var row = cell[0];
			var rowData = DetailGrid.getStore().getAt(row);
			rowData.set("InciId",inciDr);
			rowData.set("InciCode",inciCode);
			rowData.set("InciDesc",inciDesc);
			;
			//ȡ����ҩƷ��Ϣ
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
								rowData.set("WarrentNo", data[15]);
								rowData.set("WnoDate", Date.parseDate(data[16],App_StkDateFormat));
								var ss=new Date().format(App_StkDateFormat)
								rowData.set("AdjDate", Date.parseDate(ss,App_StkDateFormat)); 
								if(data[17]=="Y"){
									rowData.set("ResultSpUom", 0); 
									rowData.set("ResultRpUom", 0);
								}else{
									rowData.set("ResultSpUom", data[11]); 
									rowData.set("ResultRpUom", data[12]);     //����۸�Ĭ��Ϊ��ǰ�۸�
								}
								rowData.set("FreeDrugFlag", data[17]);
								if(setEnterSort(DetailGrid,colArr)){
										addNewRow();
									}
							} 
						},
						scope : this
					});
			
			/*
			//���ص��۵�λ
			ItmUomStore.proxy = new Ext.data.HttpProxy({
								url : DictUrl
										+ 'orderutil.csp?actiontype=INCIUom&ItmRowid='
										+ inciDr
							});
			ItmUomStore.reload();
			//ȡҩƷ��Ϣ
			getItmInfo(inciDr);  */
			
		}
		
		/**
		 * ��λչ���¼�
		 */
		CTUom.on('expand', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var IncRowid = record.get("InciId");
					/*
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ IncRowid;
					ItmUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							});*/
					ItmUomStore.removeAll();		
					ItmUomStore.load({params:{ItmRowid:IncRowid}});
				});

		/**
		 * ��λ�任�¼�
		 * var fields = ["AspId", "StkCatDesc", "InciId", "InciCode",
				"InciDesc", "MarkType", "PriceFileNo", "AspUomId",
				"PriorSpUom", "MaxSp", "ResultSpUom", "DiffSpUom",
				"PriorRpUom", "ResultRpUom", "DiffRpUom", "AdjDate",
				"PreExecuteDate", "Remark", "AspNo", "AdjUserName",
				"BUomId","ConFacPur"];
		 */
		CTUom.on('select', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					
					var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFacPur");   //��λ��С��λ��ת����ϵ					
					var AdjUom = record.get("AspUomId");    //Ŀǰ��ʾ�ĵ��۵�λ
					var PriorSpUom = record.get("PriorSpUom");
					var PriorRpUom = record.get("PriorRpUom");
					var ResultSpUom = record.get("ResultSpUom");
					var ResultRpUom = record.get("ResultRpUom");
					
					if (value == null || value.length <= 0) {
						return;
					} else if (AdjUom == value) {
						return;
					} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
						record.set("PriorSpUom", PriorSpUom/ConFac);
						record.set("PriorRpUom", PriorRpUom/ConFac);
						record.set("DiffRpUom", (ResultRpUom-PriorRpUom/ConFac));
						record.set("DiffSpUom", (ResultSpUom-PriorSpUom/ConFac));
					} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
						record.set("PriorSpUom", PriorSpUom*ConFac);
						record.set("PriorRpUom", PriorRpUom*ConFac);
						record.set("DiffRpUom", (ResultRpUom-PriorRpUom*ConFac));
						record.set("DiffSpUom", (ResultSpUom-PriorSpUom*ConFac));
					}
					record.set("AspUomId", combo.getValue());
				});

		// �任����ɫ
		function changeBgColor(row, color) {
			DetailGrid.getView().getRow(row).style.backgroundColor = color;
		}

		// �����ť�Ƿ����
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
		}
		//������ʾ
		function formatQtip(data,metadata){   
		    var title ="��ע";  
		    var tip =data;   
		    metadata.attr = 'ext:qtitle="' + title + '"' + ' ext:qtip="' + tip + '"';    
		    return data;    
		}

		var HisListTab = new Ext.form.FormPanel({
			height:DHCSTFormStyle.FrmHeight(2),
			region:"north",
			labelWidth : 60,
			labelAlign : 'right',
			title:'���۵�¼��',
			frame : true,
			tbar : [SearchBT, '-', ClearBT, '-', AddBT,	'-', SaveBT],
			items : [{
				xtype : 'fieldset',
				title : '��ѯ��Ϣ', //--<font color=blue>��ɫ������ʾ����Ŀ���ǲ�ѯ����Ҳ�ǵ���¼����������</font>',
				layout : 'column',
				defaults:{border:false},
				style: DHCSTFormStyle.FrmPaddingV,
				items : [{
						columnWidth : .3,
						labelAlign : 'right',		
						xtype: 'fieldset',
						items : [StartDate,EndDate]
					}, {
						columnWidth : .3,
						labelAlign : 'right',		
						xtype: 'fieldset',	
						items : [StkGrpType,AdjSpNo]
					}, {
						columnWidth : .4,
						labelAlign : 'right',		
						xtype: 'fieldset',	
						autoHeight: true,
						items : [IncDesc]
					}]
				
			}]		
						
		});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[HisListTab,DetailGrid],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(DetailGrid,"DHCSTADJSP");  
	colArr=sortColoumByEnterSort(DetailGrid); //���س��ĵ���˳���ʼ����
	
	var RpRule=tkMakeServerCall("web.DHCSTCOMMPARA","GetRpRule",HospId)
	if(RpRule==3){
		Msg.info("warning","���μ�ģʽ�������μ۵��۲˵�!!!");
		SearchBT.setDisabled(true);
		ClearBT.setDisabled(true);
		AddBT.setDisabled(true);
		SaveBT.setDisabled(true);
		AddDetailBT.setDisabled(true);
		DelDetailBT.setDisabled(true);
		return;
	}
	
})
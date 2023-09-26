// ����:�ɹ��ƻ���
// ��д����:2012-06-19

var purId = planNnmber;
var PlanGridUrl = 'dhcstm.inpurplanaction.csp';
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var Msg_LostModified='������¼����޸ģ��㵱ǰ�Ĳ�������ʧ��Щ������Ƿ����?';

if(gParam.length<1){
	GetParam();
}

function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	var inciDr = record.get("InciDr");
	var cell = PlanGrid.getSelectionModel().getSelectedCell();
	// ѡ����
	var row = cell[0];
//	var findIndex=PlanGrid.store.findExact('IncId',inciDr,0);
//	if(findIndex>=0 && findIndex!=row){
//		Msg.info("warning","���ʲ����ظ�¼��!");
//		var col=GetColIndex(PlanGrid,"IncDesc");
//		PlanGrid.startEditing(row, col);
//		return;
//	}
	var rowData = PlanGrid.getAt(row);
	
	//ȡ����������Ϣ
	var locId = Ext.getCmp('locField').getValue();
	if(locId==""){
		Msg.info("error", "��ѡ�����!");
		return;
	}
	var Params=session['LOGON.GROUPID']+'^'+locId+'^'+UserId;
	Ext.Ajax.request({
		url : 'dhcstm.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ inciDr+'&Params='+Params,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
			if (jsonData.success == 'true') {
				var data=jsonData.info.split("^");
				
				//���ж�������Ϣ, �ٽ��к����ĸ�ֵ
				var VenId = data[0];
				var ManfId = data[2];
				var inciDesc = record.get("InciDesc");
				var DataList=VenId+"^"+inciDr+"^"+ManfId;
				var url = 'dhcstm.utilcommon.csp?actiontype=Check&DataList=' + DataList;
				var CheckResult = ExecuteDBSynAccess(url);
				var CheckJsonData = Ext.util.JSON.decode(CheckResult)
				if (CheckJsonData.success == 'true') {
					if(CheckJsonData.info != ""){
						Msg.info("warning", inciDesc + ':' + CheckJsonData.info);
						if(CommParObj.StopItmBussiness == 'Y'){
							return;
						}
					}
				}
				
				rowData.set("IncId",inciDr);
				rowData.set("IncCode",record.get("InciCode"));
				rowData.set("IncDesc",record.get("InciDesc"));
				var VenId = data[0];
				var Vendor = data[1];
				addComboData(Ext.getCmp("Vendor").getStore(),VenId,Vendor);
				rowData.set("VenId", VenId);    //��Ӧ��
				var ManfId = data[2];
				var Manf = data[3];
				addComboData(PhManufacturerStore,ManfId,Manf);
				rowData.set("ManfId", ManfId);    //������
				var CarrierId = data[4];
				var Carrier = data[5];
				addComboData(CarrierStore,CarrierId,Carrier);
				rowData.set("CarrierId", CarrierId);    //������
				var UomId=data[6];
				var Uom=data[7];
				addComboData(ItmUomStore,UomId,Uom);
				rowData.set("UomId", UomId);    //Ĭ��Ϊ��λ����
				rowData.set("Rp", data[8]);
				rowData.set("StkQty", data[10]);
				rowData.set("MaxQty", data[11]);
				rowData.set("MinQty", data[12]);
				rowData.set("Spec", data[16]);
				rowData.set("BUomId", data[17]);
				rowData.set("ConFacPur", data[18]);
				
				var col=GetColIndex(PlanGrid,'Qty');
				PlanGrid.startEditing(PlanGrid.getCount() - 1, col);
			}
		},
		scope : this
	});
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", HospId,getDrugList2);
	}
}

// ��ӡ�ɹ���ť
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '�����ӡ�ɹ���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintInPur(purId);
	}
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	allowBlank:false,
	fieldLabel:'����',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var planNumField = new Ext.form.TextField({
	id:'planNum',
	fieldLabel:'�ƻ�����',
	allowBlank:true,
	emptyText:'�ƻ�����...',
	disabled:true,
	anchor:'90%',
	selectOnFocus:true
});
		
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'����',
	anchor:'90%',
	listWidth:210,
	allowBlank:true,
	emptyText:'����...',
	groupId:gGroupId,
	stkGrpId : 'groupField',
	childCombo : ['Vendor','PHMNFName']
});

// ��������
var groupField=new Ext.ux.StkGrpComboBox({
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //��ʶ��������
	anchor : '90%',
	LocId:CtLocId,
	UserId:UserId
});

var Complete=new Ext.form.Checkbox({
	fieldLabel : '���',
	id : 'Complete',
	name : 'Complete',
	anchor : '90%',
	width : 150,
	checked : false,
	disabled:true,
	listeners:{
		check : function(checkbox,checked){
			PlanGrid.AddNewRowButton.setDisabled(checked);
			PlanGrid.DelRowButton.setDisabled(checked);			
			savePlan.setDisabled(checked);
			deletePlan.setDisabled(checked);
			finishPlan.setDisabled(checked);
		}
	}
});
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
	fieldLabel:'��ע',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'��ע...',
	anchor:'90%',
	selectOnFocus:true
});
var Uom = new Ext.ux.ComboBox({
	fieldLabel : '��λ',
	id : 'Uom',
	name : 'Uom',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var cell=PlanGrid.getSelectedCell();
				var col=GetColIndex(PlanGrid,"Qty");
				PlanGrid.startEditing(cell[0], col);
			}
		}
	}
});

Uom.on('beforequery', function(combo) {
	var cell = PlanGrid.getSelectedCell();
	var ItmId = PlanGrid.getCell(cell[0],"IncId");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:ItmId}});
});

Uom.on('select', function(combo) {
	var cell = PlanGrid.getSelectionModel().getSelectedCell();
	var rowData = PlanGrid.getStore().getAt(cell[0]);
	var qty = rowData.get('Qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("Rp"); //ԭ����
	var buom=rowData.get("BUomId");
	var confac=rowData.get("ConFacPur");
	var uom=rowData.get("UomId");
	if(seluom!=uom){
		if(seluom!=buom){     //ԭ��λ�ǻ�����λ��Ŀǰѡ�������ⵥλ
			rowData.set("Rp", Number(rp).mul(confac)); 
			rowData.set("RpAmt", Number(rp).mul(confac).mul(qty)); //������
		}else{					//Ŀǰѡ����ǻ�����λ��ԭ��λ����ⵥλ
			rowData.set("Rp", Number(rp).div(confac)); 
			rowData.set("RpAmt", Number(rp).div(confac).mul(qty)); //������
		}
	}
	rowData.set("UomId", seluom);
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	listWidth : 250,
	params : {LocId : 'locField',ScgId : 'groupField'},
	listeners:{
		beforequery : function(){
			var cell = PlanGrid.getSelectedCell();
			if (Ext.isEmpty(cell)) {
				return false;
			}
			var ItmId = PlanGrid.getCell(cell[0],"IncId");
			var ApcInciFilter=(Ext.isEmpty(CommParObj.ApcInciFilter)?"":CommParObj.ApcInciFilter);
			this.store.setBaseParam('Incid', ItmId);
			this.store.setBaseParam('ApcInciFilter', ApcInciFilter);
			this.store.removeAll();
			this.store.load();
		},
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				PlanGrid.addNewRow();
			}
		}
	}
});

var Carrier = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'Carrier',
	name : 'Carrier',
	store : CarrierStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '������...',
	filterName:'CADesc'
});

var SpecDesc = new Ext.form.ComboBox({
	fieldLabel : '������',
	id : 'SpecDesc',
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	emptyText : '������...',
	listWidth : 250,
	pageSize : 20,
	listeners : {
		beforequery : function(){
			var cell = PlanGrid.getSelectedCell();
			if (Ext.isEmpty(cell)) {
				return false;
			}
			var ItmId = PlanGrid.getCell(cell[0],"IncId");
			this.store.setBaseParam('SpecItmRowId', ItmId);
			this.store.setBaseParam('desc', this.getRawValue());
			this.store.removeAll();
			this.store.load({params : {start:0,limit:this.pageSize}});
		}
	}
});

var Manf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Manf',
	name : 'Manf',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : ' ����...',
	filterName:'PHMNFName',
	params : {LocId : 'locField',ScgId : 'groupField'}
});		

var ReqLoc = new Ext.ux.LocComboBox({
	fieldLabel : '�깺����',
	id : 'ReqLoc',
	name : 'ReqLoc',
	defaultLoc:''
});

//ģ��
var PlanGridCm = [
	{
		header:"RowId",
		dataIndex:'RowId',
		saveColIndex : 0,
		hidden:true,
		hideable:false,
		sortable:true
	}, {
		header:"IncId",
		dataIndex:'IncId',
		saveColIndex : 1,
		hidden:true,
		hideable:false
	}, {
		header:"���ʴ���",
		dataIndex:'IncCode',
		width:100,
		align:'left',
		renderer :Ext.util.Format.InciPicRenderer('IncId'),
		sortable:true
	},{
		header:"��������",
		dataIndex:'IncDesc',
		id:'IncDesc',
		width:250,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(field.getValue(),Ext.getCmp("groupField").getValue());
					}
				}
			}
		})
	},{
		header:"���",
		dataIndex:'Spec',
		width:120,
		align:'left'
	},{
		header:"������",
		dataIndex : "SpecDesc",
		xtype:'combocolumn',
		saveColIndex : 9,
		valueField: "SpecDesc",
		displayField: "SpecDesc",
		editor:SpecDesc
	},{
		header:"��λ",
		dataIndex : "UomId",
		xtype:'combocolumn',
		saveColIndex : 3,
		valueField: "UomId",
		displayField: "Uom",
		editor:Uom
	}, {
		header : "����ɹ���",
		dataIndex : 'ProPurQty',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header:"�ɹ�����",
		dataIndex:'Qty',
		saveColIndex : 2,
		allowBlank : false,
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var col=GetColIndex(PlanGrid,"VenId")
						var cell=PlanGrid.getSelectionModel().getSelectedCell();
						PlanGrid.startEditing(cell[0], col);	
					}
				}
			}
		})
	},{
		header:"����",
		dataIndex:'Rp',
		align : 'right',
		saveColIndex : 5,
		width:80,
		sortable:true,
		editor:new Ext.ux.NumberField({
			formatType : 'FmtRP',
			selectOnFocus : true,
			//allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if ((cost == null || cost=="")&(gParam[0]=="Y")) {
							Msg.info("warning", "���۲���Ϊ��!");
							return;
						}
						if (cost < 0) {
							Msg.info("warning", "���۲���С��0!");
							return;
						}
						// ����һ��
						var col=GetColIndex(PlanGrid,"VenId");
						var cell=PlanGrid.getSelectedCell();
						PlanGrid.startEditing(cell[0], col);
					}
				}
			}
		})
	},{
		header:"��Ӧ��",
		dataIndex:'VenId',
		saveColIndex : 4,
		width:250,
		xtype:'combocolumn',
		valueField: "VenId",
		displayField: "Vendor",
		editor:Vendor
	},{
		header:"������",
		dataIndex:'CarrierId',
		saveColIndex : 7,
		width:200,
		xtype:'combocolumn',
		valueField: "CarrierId",
		displayField: "Carrier",
		editor:Carrier
	},{
		header:"����",
		dataIndex : "ManfId",
		saveColIndex : 6,
		width:200,
		xtype:'combocolumn',
		valueField: "ManfId",
		displayField: "Manf",
		editor:Manf
	},{
		header:"�깺����",
		saveColIndex : 8,
		width:150,
		xtype:'combocolumn',
		valueField: "ReqLocId",
		displayField: "ReqLoc",
		editor:ReqLoc
	},{
		header:"�������",
		dataIndex:'MinQty',
		width:100,
		align:'right'
	},{
		header:"�������",
		dataIndex:'MaxQty',
		width:100,
		align:'right'
	},{
		header:"������",
		dataIndex:'RpAmt',
		width:120,
		align : 'right'
	},{
		header:"����������",
		dataIndex:'LocQty',
		width:100,
		align:'right'
	},{
		header:"�����ҿ�������",
		dataIndex:'LocAvaQty',
		width:120,
		align : 'right'
	},{
		header:"��������",
		dataIndex:'ReqQty',
		width:120,
		align : 'right'
	},{
		header:"��ת������",
		dataIndex:'TrfQty',
		width:120,
		align : 'right'
	},{
		header:"������λId",
		dataIndex:'BUomId',
		width:60,
		hidden : true
	},{
		header:"��λת��ϵ��",
		dataIndex:'ConFacPur',
		width:60,
		hidden : true
	}, {
		header : "Ҫ���ͻ�����",
		dataIndex : 'DemandDate',
		xtype: 'datecolumn',
		width : 100,
		align : 'center',
		sortable : true,
		saveColIndex : 10,
		//renderer : Ext.util.Format.dateRenderer(ARG_DATEFORMAT),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var completeFlag=Ext.getCmp('Complete').getValue();
						if (completeFlag != null && completeFlag != false) {
							Msg.info("warning", "���������!");
							return;
						}
					}
				}
			}
		})
	},{
		header:"�ɹ���ע",
		dataIndex:'remark',
		id:'remark',
		width:250,
		align:'left',
		saveColIndex : 11,
		sortable:true,
		editor:new Ext.form.TextField({
			allowBlank:false
		})
	}];
	
var findPlan = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindPlan(Select);
	}
});

var savePlan = new Ext.ux.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		var mod=Modified();
		if (mod==false){
			Msg.info('warning','û����Ҫ���������!')
			return;
		}
		var purNo = Ext.getCmp('planNum').getValue();
		var locId = Ext.getCmp('locField').getValue();
		var stkGrpId = Ext.getCmp('groupField').getValue();
		var Remark=Ext.getCmp("RemarkField").getValue();
		var userId = UserId;
		if(locId==null || locId==""){
			Msg.info("warning","���Ҳ���Ϊ��!");
			return;
		}
		if(stkGrpId==null || stkGrpId==""){
			Msg.info("warning","���鲻��Ϊ��!");
			return;
		}
		var data = PlanGrid.getModifiedInfo();
		if(data===false){
			return;
			
		}
	
		var Count=PlanGrid.getCount()
		for(i=0;i<Count;i++){
			var rowData=PlanGrid.getAt(i)
			var UomId=rowData.get("UomId");
			var IncId=rowData.get("IncId");
			var VenId=rowData.get("VenId");
			if ((UomId=="")&&(IncId!="")){
				Msg.info("warning","��"+(i+1)+"�е�λΪ��");
				PlanGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			if(IncId!=""&&VenId==""&&gParam[4]!="N"){
				Msg.info('error','��'+(i+1)+'�й�Ӧ�̲���Ϊ�գ�');
				return;
			}
		}
		if ((data=="")&& (mod==false) ){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}else{
			Ext.Ajax.request({
				url: PlanGridUrl+'?actiontype=save',
				params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data,Remark:Remark},
				failure: function(result, request) {
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","����ɹ�!");
						//�µ����¼���, ����reload
						if(Ext.isEmpty(purId)){
							purId=jsonData.info;
							Select(purId);
						}else{
							PlanGrid.reload();
						}
					}else{
						if(jsonData.info==-1){
							Msg.info("error","���һ���ԱΪ��!");
						}else if(jsonData.info==-99){
							Msg.info("error","����ʧ��!");
						}else if(jsonData.info==-2){
							Msg.info("error","���ɼƻ�����ʧ��!");
						}else if(jsonData.info==-3){
							Msg.info("error","����ƻ���ʧ��!");
						}else if(jsonData.info==-4){
							Msg.info("error","δ�ҵ�����µļƻ���!");
						}else if(jsonData.info==-5){
							Msg.info("error","����ƻ�����ϸʧ��,�������ɼƻ���!");
						}else if(jsonData.info==-7){
							Msg.info("error","ʧ�����ʣ�������ϸ���治�ɹ�����ʾ���ɹ�������!");
						}else{
							Msg.info("error","����ʧ��!");
						}
					}
				},
				scope: this
			});
		}
	}
});
// �任����ɫ
function changeBgColor(row, color) {
	PlanGrid.getView().getRow(row).style.backgroundColor = color;
}
var deletePlan = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(purId==null || purId==""){
			Msg.info("warning","��ѡ��Ҫɾ���ļƻ���!");
			return;
		}
		var compFlag=Ext.getCmp('Complete').getValue();
		var mod=Modified();
		if ( (mod) &&(!compFlag) ) {
			Ext.Msg.show({
				title:'��ʾ',
				msg: Msg_LostModified,
				buttons: Ext.Msg.YESNO,
				fn: function(b,t,o){
					if (b=='yes'){Delete();}
				},
				icon: Ext.MessageBox.QUESTION
			});
		}else{
			Delete();
		}	
	}
});

function Delete(){
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=delete&rowid='+purId,
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						Msg.info("error", "������������!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "ɾ���ɹ�!");
							clearData();
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "�����Ѿ���ɣ�����ɾ��!");
								return false;
							}
							if(jsonData.info==-2){
								Msg.info("error", "�����Ѿ���ˣ�����ɾ��!");
								return false;
							}
							if(jsonData.info==-3){
								Msg.info("error", "ɾ���ƻ�������ʧ��!");
								return false;
							}
							if(jsonData.info==-4){
								Msg.info("error", "ɾ���ƻ�����ϸʧ��!");
								return false;
							}
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
	)
}

function FinishPurPlan(){
	var completeFlag=Ext.getCmp('Complete').getValue();
	if (completeFlag==true) {
		Msg.info('error','��ǰ�ɹ��ƻ����Ѿ����!')
		return;
	}
	
	var Count=PlanGrid.getCount()
	for(i=0;i<Count;i++){
		var rowData=PlanGrid.getAt(i)
		var Rp=Number(rowData.get("Rp"))
		if(Rp==0 && confirm('��'+(i+1)+'�н���Ϊ0,�Ƿ����?') == false){
			return;
		}
	}
	
	//Ԥ������ж�
	var HRPBudgResult = HRPBudg();
	if(HRPBudgResult === false){
		return;
	}
	
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ��ɸüƻ�����?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=finsh&rowid='+purId,
					waitMsg:'������...',
					failure: function(result, request) {
						Msg.info("error", "������������!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "�ƻ������!");
							Ext.getCmp("Complete").setValue(true);
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "�ƻ����Ѿ����!");
								return false;
							}else if(jsonData.info==-4){
								Msg.info("error", "�Զ�����ʧ��!");
								return false;
							}else if(jsonData.info==-11){
								Msg.info("error", "���ڹ�Ӧ��Ϊ�յļ�¼,������ɼƻ���!");
								return false;
							}else if(jsonData.info==-12){
								Msg.info("error", "���ڽ���С��0�ļ�¼,������ɼƻ���!");
								return false;
							}else{
								Msg.info("error", "����ʧ��:"+jsonData.info);
								return false;
							}
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
	)
}
var finishPlan = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", "�ƻ���Ϊ��!");
			return false;
		}else{
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
					title:'��ʾ',
					msg: Msg_LostModified,
					buttons: Ext.Msg.YESNO,
					fn: function(b,t,o){
						if (b=='yes'){FinishPurPlan();}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				FinishPurPlan();
			}
		}
	}
});

function CancelFinish(){
	var completeFlag=Ext.getCmp('Complete').getValue();
	if(completeFlag==false){
		Msg.info('error','��ǰ�ɹ��ƻ�����δ���!')
		return;
	}
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫȡ����ɸüƻ�����?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=noFinsh&rowid='+purId,
					waitMsg:'������...',
					failure: function(result, request) {
						Msg.info("error", "������������!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "�ɹ�ȡ���ƻ������״̬!");
							Ext.getCmp('Complete').setValue(false);
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "�ƻ�����δ���!");
								return false;
							}
							if(jsonData.info==-2){
								Msg.info("error", "�����Ѿ���ˣ�����ȡ�����!");
								return false;
							}
							if(jsonData.info==-3){
								Msg.info("error", "����ʧ��!");
								return false;
							}
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
	)
}

var noFinshPlan = new Ext.Toolbar.Button({
	text:'ȡ�����',
	tooltip:'ȡ�����',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", "�ƻ���Ϊ��!");
			return false;
		}else{
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
					title:'��ʾ',
					msg: Msg_LostModified,
					buttons: Ext.Msg.YESNO,
					fn: function(b,t,o){
						if (b=='yes'){CancelFinish();}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				CancelFinish();
			}
		}
	}
});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
			id : "ClearBT",
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				var compFlag = Ext.getCmp('Complete').getValue();
				var mod = Modified();
				if (mod && (!compFlag)) {
					Ext.Msg.show({
								title : '��ʾ',
								msg : Msg_LostModified,
								buttons : Ext.Msg.YESNO,
								fn : function(b, t, o) {
									if (b == 'yes') {
										clearData();
									}
								},
								icon : Ext.MessageBox.QUESTION
							});
				} else {
					clearData();
				}
			}
		});


function clearData(){
	clearPanel(formPanel);
	formPanel.getForm().setValues({dateField:new Date()});
	
	PlanGrid.AddNewRowButton.setDisabled(false);
	PlanGrid.removeAll();
	purId='';
	purNo='';
	finishPlan.setDisabled(false);   //���
	savePlan.setDisabled(false);
	deletePlan.setDisabled(false);
	setEditDisabled(false);
	//������ܴ���href����
	CheckLocationHref();
}

var formPanel = new Ext.form.FormPanel({
	id:'MainForm',
	title:'�ɹ��ƻ��Ƶ�',
	autoHeight : true,
	region:'north',
	labelAlign : 'right',
	frame : true,
	trackResetOnLoad : true,
	bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar:[findPlan,'-',savePlan,'-',deletePlan,'-',finishPlan,'-',noFinshPlan,'-',ClearBT,'-',PrintBT],
	items : [{
			style:'padding:5px 0px 0px 0px',
			layout : 'column',
			xtype : 'fieldset',
			title : '�ɹ���Ϣ',
			defaults:{border:false},
			items : [{
					columnWidth : .25,
					xtype : 'fieldset',
					items : [locField,dateField]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [planNumField,RemarkField]
				},{
					columnWidth : .25,
					xtype : 'fieldset',
					items : [groupField]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [Complete]
			}]			
		}]
});

//���
PlanGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'PlanGrid',
	title:'�ɹ��ƻ�����ϸ',
	contentColumns : PlanGridCm,
	actionUrl : "dhcstm.inpurplanaction.csp",
	queryAction : "queryItem",
	selectFirst : false,
	delRowAction : "deleteItem",
	delRowParam : "rowid",
	idProperty : 'RowId',
	checkProperty : 'IncId',
	beforeAddFn : beforeAddFn,
	afterAddFn : setEditDisabled,
	paging : false,
	region:'center',
	listeners : {
		beforeedit : function(e){
			if(Ext.getCmp("Complete").getValue()){
				return false;
			}
			if(e.field=="UomId"){
				var inci=e.record.get("IncId");
				if(inci==null || inci==""){
					Msg.info("warning","����¼������!");
					e.cancel=true;
				}
			}
		},
		afteredit : function(e){
			var InciId = e.record.get('IncId');
			if(e.field=='Qty'){
				var qty = e.value;
				e.record.set("RpAmt", accMul(e.record.get('Rp'),qty)); //������
				HRPBudg(InciId);
			}else if(e.field=='Rp'){
				e.record.set("RpAmt", accMul(e.value,e.record.get('Qty'))); //������
				HRPBudg(InciId);
			}
		}
	}
});

/*
 * Ԥ�����,����HRPԤ��ӿ�
 */
function HRPBudg(CurrInciId){
	CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
	var LocId = Ext.getCmp('locField').getValue();
	if(Ext.isEmpty(LocId)){
		return;
	}
	var DataStr = '';
	var Count = PlanGrid.getCount();
	for(i = 0; i < Count; i++){
		var RowData = PlanGrid.getAt(i);
		var Inppi = RowData.get('RowId');
		var UomId = RowData.get('UomId');
		var IncId = RowData.get('IncId');
		var RpAmt = RowData.get('RpAmt');
		if ((UomId == '') || (IncId == '') || !(RpAmt > 0)){
			continue;
		}
		var Data = Inppi + '^' + IncId + '^' + RpAmt;
		if(DataStr == ''){
			DataStr = Data;
		}else{
			DataStr = DataStr + RowDelim + Data;
		}
	}
	if(DataStr != ''){
		var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'InppBalance', CurrInciId, LocId, DataStr);
		if(!Ext.isEmpty(Result)){
			Msg.info('error', '��ǰ�ɹ�����Ԥ��,���ʵ�޸�:' + Result);
			return false;
		}
	}
	return true;
}

//�Ҽ��˵�  bianshuai 2014-04-24
	function rightClickFn(grid,rowindex,e){
		grid.getSelectionModel().select(rowindex,0);
		//grid.getSelectionModel().selectRow(rowindex);
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
		{ 
			id: 'mnumodTransBat',   //�����޸����� bianshuai 2014-04-23
			handler: mQueryBusDetail, 
			text: '������ʷ' 
		}
		] 
	});
	PlanGrid.addListener('rowcontextmenu', rightClickFn);  //�����Ҽ��¼� bianshuai 2014-04-24
	//ҩƷ��ʷ���� bianshuai 2014-04-24
	function mQueryBusDetail()
	{
		var cell = PlanGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = PlanGrid.getStore().getAt(row);
		var desc = record.get("IncDesc"); //ҩƷ����
		var inci = record.get("IncId");      //���ID
		var purlocid=Ext.getCmp("locField").getValue(); //�ɹ�����
		BusInvoDetailWin(inci,desc,purlocid);
	}

//zdm,2013-03-1,��ѯ�ɹ�������Ϣ
function Select(purid){
	Ext.Ajax.request({
		url : 'dhcstm.inpurplanaction.csp?actiontype=select&purId='+purid,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			formPanel.getForm().setValues(jsonData);
		},
		scope : this
	});
	PlanGrid.load({params:{parref:purid}});
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,PlanGrid],
		renderTo:'mainPanel'
	});
	//���ݼƻ�����purId��ѯ�����Ϣ
	if((purId!="")&&(purId!=null)&&(purId!=0)){
		Select.defer(500,this,[purId]); //��Ĭ�����������ͻ���� Ĭ�����������ִ������  ��ʱ����
	}
});

/*���Ƿ��޸�*/
function Modified(){
	if(PlanGrid.activeEditor!=null){
		PlanGrid.activeEditor.completeEdit();
	}
	var detailCnt=0
	var rowCount=PlanGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++){
		var item = PlanGrid.getStore().getAt(i).get("IncId");
		if (item != "") {
			detailCnt++;
		}
	}
	var result=false;
	//��Ϊ�µ�(purId="")�����ӱ��Ƿ��в���
	if ((purId<=0)||(purId==''))
	{
		if (detailCnt==0) {
			result=false;
		} else{
			result= true;
		}		
	}else{  //����Ϊ�µ�����������ӱ�	
		var mod=Ext.getCmp('MainForm').getForm().isDirty();
		var modGrid=false;
		var rowsModified=PlanGrid.getStore().getModifiedRecords();
		if (rowsModified.length>0) modGrid=true
		if  (mod||modGrid) {
			result = true
		}else {
			result = false
		}
	}
	return result;
}

//���ÿɱ༭�����disabled����
function setEditDisabled(bool){
	var bool = typeof(bool)=='undefined'?true:false;
	Ext.getCmp('groupField').setDisabled(bool);
	Ext.getCmp('locField').setDisabled(bool);
}

function beforeAddFn(){
	var defaData = {};
	var LocId = Ext.getCmp('locField').getValue();
	if((LocId=="")||(LocId==null)){
		Msg.info("error","��ѡ�����!");
		return false;
	}
	if(Ext.getCmp('groupField').getValue()==""){
		Msg.info("warning","��ѡ������!");
		return false;
	}
}
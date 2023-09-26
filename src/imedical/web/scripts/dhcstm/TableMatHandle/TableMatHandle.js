// ����:��ֵ��̨��¼����
// ��д����:2016-12-07
// ��д��:wangjiabin
var gUserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var gIncId = '';
var CURRENT_INGR = '', CURRENT_INIT = '';		//���β�¼��ⵥrowidStr, ���ⵥrowidStr
var TableMatUrl = 'dhcstm.tablemathandleaction.csp';

var StkGrpType=new Ext.ux.StkGrpComboBox({
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,	 //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor:'90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor:'90%',
	params : {ScgId : 'StkGrpType'},
	valueParams : {LocId : gLocId, UserId : gUserId}
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
	 GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
	}
}

/**
 * ���ط���
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gIncId = record.get("InciDr");
	var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);

	findhaveMatord.handler();
}

var reclocField = new Ext.ux.LocComboBox({
	id:'reclocField',
	fieldLabel:'������',
	name:'reclocField',
	groupId:gGroupId,
	anchor:'90%'
});

var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'ҽ�����տ���',
	anchor:'90%',
	defaultLoc:{},
	listeners : {
		select : function(combo, record, index){
			var OrdLocId = record.get(combo.valueField);
			var OrdLocDesc = record.get(combo.displayField);
			var MainLocInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLocInfo', OrdLocId);
			if(MainLocInfo == '' || MainLocInfo.split('^')[0] == ''){
				MainLocId = OrdLocId;
				MainLocDesc = OrdLocDesc;
			}else{
				MainLocId = MainLocInfo.split('^')[0];
				MainLocDesc = MainLocInfo.split('^')[1];
			}
			addComboData(null, MainLocId, MainLocDesc, Ext.getCmp('RequestedLoc'));
			Ext.getCmp('RequestedLoc').setValue(MainLocId);
		}
	}
});

var RequestedLoc = new Ext.ux.LocComboBox({
	id:'RequestedLoc',
	fieldLabel:'��¼���տ���',
	emptyText:'��¼���տ���...',
	anchor:'90%',
	defaultLoc:{},
	disabled:true
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:100,
	allowBlank:false,
	fieldLabel:'ҽ����ʼ����',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:100,
	allowBlank:false,
	fieldLabel:'ҽ����������',
	value:new Date()
});

var IngrFlag = new Ext.form.RadioGroup({
	id:'IngrFlag',
	columns:3,
	hideLabel : true,
	itemCls: 'x-check-group-alt',
	items:[
		{boxLabel:'ȫ��',name:'IngrFlag',id:'AllFlag',inputValue:0},
		{boxLabel:'δ��¼',name:'IngrFlag',id:'NoIngrFlag',inputValue:1,checked:true},
		{boxLabel:'�Ѳ�¼',name:'IngrFlag',id:'IngredFlag',inputValue:2}
	]
});
// ����ܺϼ�
var totalrp = new Ext.form.TextField({
	fieldLabel : '���ϼ�',
	id : 'totalrp',
	name : 'totalrp',
	anchor : '90%',
	readOnly : true
});
// ����ܺϼ�
var invno = new Ext.form.TextField({
	fieldLabel : '��Ʊ��',
	id : 'invno',
	name : 'invno',
	anchor : '90%' ,
			listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					websys_setfocus("invdate")
				}
			}
		}
});
var invdate = new Ext.ux.DateField({
	fieldLabel : '��Ʊ����',
	id : 'invdate',
	name : 'invdate',
	anchor : '90%'
});

var findhaveMatord = new Ext.Toolbar.Button({
	text:'��ѯҽ����Ϣ',
	tooltip:'��ѯҽ����Ϣ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var LocId = Ext.getCmp('reclocField').getValue();
		if(LocId == ''){
			Msg.info('warning', '��ѡ�����!');
			return false;
		}
		var ordlocField = Ext.getCmp('ordlocField').getValue();
		/*if(Ext.isEmpty(ordlocField)){
			Msg.info('warning', '��ѡ��ҽ�����տ���!');
			return false;
		}*/
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		var Vendor = Ext.getCmp('Vendor').getValue();
		var StkGrpType = Ext.getCmp('StkGrpType').getValue();
		var InciDesc = Ext.getCmp('InciDesc').getValue();
		if(InciDesc == ''){
			gIncId = '';
		}
		var IngrFlag = Ext.getCmp('IngrFlag').getValue().getGroupValue();
		var strPar = startDate+"^"+endDate+"^"+Vendor+"^"+StkGrpType+"^"+gIncId
			+"^"+LocId+"^"+IngrFlag+"^"+ordlocField;
		var ActiveTab=tabPanel.getActiveTab().getId();
		if (ActiveTab=="HVMatPanel"){
		MatordGridDs.setBaseParam('strPar',strPar);
		MatordGridDs.removeAll();
		MatordGridDs.load({
			params:{start:0,limit:9999},
			callback:function(r,options,success){
				if(success==false){
					Msg.info("error","��ѯ����, ��鿴��־!");
				}
			}
		});
		}else if (ActiveTab=="MatordSumPanel"){
			MatordSumGridDs.setBaseParam('strPar',strPar);
			MatordSumGridDs.removeAll();
			MatordSumGridDs.load({
				params:{start:0,limit:9999},
				callback:function(r,options,success){
					if(success==false){
						Msg.info("error","��ѯ����, ��鿴��־!");
					}
				}
			});
		}
	}
});

var clearMatord = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		CURRENT_INGR = '';
		CURRENT_INIT = '';
		GrMasterInfoGrid.getStore().removeAll();
		GrDetailInfoGrid.getStore().removeAll();
		MatordGridDs.removeAll();
		clearPanel(formPanel);
		startDateField.setValue(new Date());
		endDateField.setValue(new Date());
		Ext.getCmp('NoIngrFlag').setValue(true)
	}
});

var createMatord = new Ext.Toolbar.Button({
	text:'������ⵥ',
	tooltip:'������ⵥ',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
			var LocId = Ext.getCmp("reclocField").getValue();
			if(LocId == ''){
				Msg.info('warnging', '�����Ҳ���Ϊ��!');
			}
			var RequestedLoc = Ext.getCmp('RequestedLoc').getValue();
			var RequestedLocDesc = Ext.getCmp('RequestedLoc').getRawValue();
			/*if(Ext.isEmpty(RequestedLoc)){
				Msg.info('warning', '������տ���Ϊ��!');
				return false;
			}else if(confirm('������տ���Ϊ ' + RequestedLocDesc + ', �Ƿ����?') == false){
				return false;
			}*/
			var SourceOfFund = '';
			var MainInfo = LocId+"^"+SourceOfFund+"^"+RequestedLoc;
			
			var ListDetail="";
			var sm = MatordGrid.getSelectionModel();
			var rowCount = MatordGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				if(sm.isSelected(i)){
					var rowData = MatordGrid.getStore().getAt(i);
					var IngrFlag = rowData.get('ingrFlag');
					if (IngrFlag=="Y"){
						Msg.info("warning", "��"+(i+1)+"����������ⵥ!");
						sm.deselectRow(i);
						return;
					}
					var InvNo = rowData.get("invno");
					if(InvNo==''){
						//Msg.info('error', '��'+(i+1)+'��û��¼�뷢Ʊ��!');
						//return false;
					}
					var InvDate = Ext.util.Format.date(rowData.get("invdate"),ARG_DATEFORMAT);
					var InvAmt = rowData.get("invamt");
					var intr = rowData.get('intr');
					var str = intr + '^' + InvNo + '^' + InvDate  + '^' + InvAmt;
					if(ListDetail==""){
						ListDetail=str;
					}else{
						ListDetail=ListDetail+RowDelim+str;
					}
				}
			}

			if (ListDetail==""){
				Msg.info("error", "û����Ҫ������ⵥ����Ϣ!");
				return;
			}
			var url = TableMatUrl + "?actiontype=Create";
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{MainInfo:MainInfo, ListDetail:ListDetail, user:gUserId},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							loadMask.hide();
							if (jsonData.success == 'true') {
								// ˢ�½���
								Msg.info("success", "����ɹ�!");
								findhaveMatord.handler();
								var CurrentInfo = jsonData.info;
								var CurrentInfoArr = CurrentInfo.split(xRowDelim());
								CURRENT_INGR = CurrentInfoArr[0];
								CURRENT_INIT = CurrentInfoArr[1];
								if(CURRENT_INGR != ''){
									tabPanel.activate('CurrentIngrPanel');
								}
							} else {
								var ret=jsonData.info;
								loadMask.hide();
								if(ret==-99){
									Msg.info("error", "����ʧ��,���ܱ���!");
								}else {
									Msg.info("error", "����ʧ�ܣ�"+ret);
								}
							}
						},
						scope : this
					});
	}
});

var PrintIngrButton = new Ext.Toolbar.Button({
	text:'��ӡ��ⵥ',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var rowData = GrMasterInfoGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
			return;
		}
		var DhcIngr = rowData.get("IngrId");
		PrintRec(DhcIngr);
	}
});

var PrintInitButton = new Ext.Toolbar.Button({
	text:'��ӡ���ⵥ',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var rowData = InitMasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ�ĳ��ⵥ!");
			return;
		}
		var init = rowData.get("init");
		PrintInIsTrf(init);
	}
});
var CancelNorMatord = new Ext.Toolbar.Button({
		text: '������¼',
		tooltip: '������¼',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var ParamInfo = tkMakeServerCall("web.DHCSTM.HVMatOrdItm", "GetParamProp", gGroupId, gLocId, gUserId);
			var paramarr = ParamInfo.split("^");
			var IfCanDoCancelOeRec = paramarr[1];
			if (IfCanDoCancelOeRec != "Y") {
				Msg.info("warning", "��û��Ȩ�޳�����¼!");
				return false;
			}
			CancelNorMatRec();
		}
	});
function CancelNorMatRec() {
	var CancelListDetail = "";
	var Cancelsm = MatordGrid.getSelectionModel();
	var Matordstore = MatordGrid.getStore();
	var rowCount = MatordGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		if (Cancelsm.isSelected(i)) {
			var rowData = MatordGridDs.getAt(i);
			var IngrFlag = rowData.get('ingrFlag');
			if (IngrFlag != "Y") {
				Msg.info("warning", "δ������ⵥ�����Գ�����¼!");
				Cancelsm.deselectRow(i);
				return;
			}
			var intr = rowData.get('intr');
			if (CancelListDetail == "") {
				CancelListDetail = intr;
			} else {
				CancelListDetail = CancelListDetail + "^" + intr;
			}
		}
	}
	if (CancelListDetail == "") {
		Msg.info("error", "û����Ҫ������¼����Ϣ!");
		return false;
	};
	alert(CancelListDetail)
	var url = TableMatUrl+"?actiontype=CancelNorMatRecStr";
	var loadMask = ShowLoadMask(Ext.getBody(), "������...");
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			IntrStr: CancelListDetail,
			user: gUserId
		},
		waitMsg: '������...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				// ˢ�½���
				CURRENT_INGR = "";
				CURRENT_INIT = "";
				var retinfoarr=jsonData.info.split("^");
				var allcount=retinfoarr[0];
				var succount=retinfoarr[1];
				Msg.info("success", "��"+allcount+"����¼,�ɹ�����"+succount+"����¼!");
				findhaveMatord.handler();
			}
		},
		scope: this
	});
}
var formPanel = new Ext.form.FormPanel({
	title : '��ֵ������ⲹ¼',
	labelAlign : 'right',
	region:'north',
	autoHeight : true,
	frame : true,
	tbar:[findhaveMatord,'-',createMatord,'-',clearMatord,'-',PrintIngrButton,'-',PrintInitButton,'-',CancelNorMatord],
	items : [{
		xtype : 'fieldset',
		title : '����ѡ��',
		layout : 'column',
		defaults : {layout : 'form', labelWidth : 60},
		items : [{
			columnWidth : .3,
			labelWidth : 100,
			items : [reclocField, RequestedLoc, ordlocField]
		}, {
			columnWidth : .2,
			labelWidth : 100,
			items : [startDateField, endDateField]
		}, {
			columnWidth : .25,
			items : [StkGrpType, InciDesc]
		}, {
			columnWidth : .25,
			items : [Vendor,IngrFlag]
		}]
	}]
});

var sm=new Ext.grid.CheckboxSelectionModel({
	checkOnly:true,
	listeners : {
		rowselect : function(sm, rowIndex) {
			var selectedRow = MatordGridDs.data.items[rowIndex];
			var IngrFlag = selectedRow.data["ingrFlag"];
			/*if (IngrFlag=="Y"){
				Msg.info("warning", "��������ⵥ!");
				sm.deselectRow(rowIndex);
				return
			}
			else
				{
				var selarr=this.getSelections();
				var len=selarr.length
				if (len>1){
							var invno=selarr[len-2].data["invno"];
							var invnodate=selarr[len-2].data["invdate"];
							selectedRow.set("invno",invno);
							selectedRow.set("invdate",invnodate);
							}
			}*/
			var selarr=this.getSelections();
			var len=selarr.length
			if (len>1){
				var invno=selarr[len-2].data["invno"];
				var invnodate=selarr[len-2].data["invdate"];
				selectedRow.set("invno",invno);
				selectedRow.set("invdate",invnodate);
					}
		getTotalrp()
		},
	rowdeselect:function(sm,rowIndex,record) {
		record.set("invno","");
		record.set("invdate","");
		getTotalrp()
	}
	}
});


var MatordGridDs = new Ext.data.JsonStore({
	url : TableMatUrl+'?actiontype=query',
	root : 'rows',
	totalProperty : 'results',
	id : 'orirowid',
	fields : ['intr', 'vendordr', 'vendor', 'inci', 'code', 'desc', 'spec', 'specdesc', 'inclb', 'batno',
		{name:'expdate',type:'date',dateFormat:DateFormat}, 'uomdr', 'uomdesc', 'qty', 'rp', 'rpAmt', 'sp', 'spAmt', 'oeori', 'doctor',
			'pano', 'paname', 'ingrFlag', 'invno', {name:'invdate',type:'date',dateFormat:DateFormat}, 'invamt'
	],
	pruneModifiedRecords : true
});

var MatordGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 sm,{
		header:"intr",
		dataIndex:'intr',
		width:90,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"��Ӧ��",
		dataIndex:'vendor',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"���ʴ���",
		dataIndex:'code',
		width:90,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'desc',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"���",
		dataIndex:'spec',
		width:80,
		align:'left'
	},{
		header:"������",
		dataIndex:'specdesc',
		width:80,
		align:'left'
	},{
		header:"��¼���",
		dataIndex:'ingrFlag',
		width:60,
		xtype : 'checkcolumn',
		isPlugin : false,
		align:'center'
	},{
		header:"inclb",
		dataIndex:'inclb',
		hidden : true
	},{
		header:"��λ",
		dataIndex:'uomdesc',
		width:40,
		align:'left'
	},{
		header:"����",
		dataIndex:'qty',
		width:50,
		align:'right'
	},{
		header:"����",
		dataIndex:'batno',
		width:100,
		align:'left',
		editable : false,		//2015-06-16 �������޸Ľ���,����,Ч��
		editor: new Ext.form.TextField({
			id:'batnoField',
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"��Ч��",
		dataIndex:'expdate',
		width:100,
		align:'left',
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editable : false,		//2015-06-16 �������޸Ľ���,����,Ч��
		editor: new Ext.ux.DateField()
	},{
		header:"����",
		dataIndex:'rp',
		width:80,
		align:'right',
		editable : false,		//2015-06-16 �������޸Ľ���,����,Ч��
		editor: new Ext.form.TextField({
			allowBlank:false,
			selectOnFocus:true,
			tabIndex:1
		})
	},{
		header:"�ۼ�",
		dataIndex:'sp',
		width:80,
		align:'right'
	},{
		header:"<font color=blue>��Ʊ���</font>",
		dataIndex:'invamt',
		width:80,
		align:'right',
		editor: new Ext.form.NumberField({
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"<font color=blue>��Ʊ��</font>",
		dataIndex:'invno',
		width:100,
		align:'left',
		editor: new Ext.form.TextField({
			id:'invnoField',
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"<font color=blue>��Ʊ����</font>",
		dataIndex:'invdate',
		width:80,
		align:'left',
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField()
	},{
		header:"���ߵǼǺ�",
		dataIndex:'pano',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'paname',
		width:80,
		align:'left'
	},{
		header:"ҽ��",
		dataIndex:'doctor',
		width:60,
		align:'left'
	}
]);
function getTotalrp(){
	var selarr = MatordGrid.getSelectionModel().getSelections();
	var totalrp=0
	for (var i = 0; i < selarr.length; i++) {
		var rowData = selarr[i];
		var Rp = rowData.get("rp");
		totalrp=accAdd(totalrp,Rp)
	}
	Ext.getCmp("totalrp").setValue(totalrp);
}
var InvNoBT = new Ext.Toolbar.Button({
			text : '��д��Ʊ�źͷ�Ʊ����',
			tooltip : '�����д��Ʊ��',
			height:30,
			width:70,
			iconCls : 'page_refresh',
			handler : function() {
				InvNoInput();
			}
		});

function InvNoInput() {
	var rs = sm.getSelections();
	var count=rs.length;
	if(count>0){
		var invno=Ext.getCmp('invno').getValue();
		var InvDate =Ext.getCmp('invdate').getValue();
		for (var i = 0; i < count; i++) {
			var rowData = rs[i];
			rowData.set('invno',invno);
			rowData.set('invdate',InvDate);
		}
		Msg.info('warning', '��Ʊ��Ϣ��¼����,�뱣��!');
	}else{
		Msg.info('error', '��ѡ����Ҫ¼�뷢Ʊ�ļ�¼!');
	}
}

var MatordGrid = new Ext.ux.EditorGridPanel({
	id : 'MatordGrid',
	store:MatordGridDs,
	tbar:['��Ʊ��:','-',invno,'-','��Ʊ����:',invdate,'-',InvNoBT,'->','���ϼ�:','-',totalrp],
	cm:MatordGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : sm,
	loadMask:true,
	clicksToEdit:1,
	listeners:{
		beforeedit : function(e){
			var IngrFlag = e.record.get('ingrFlag');
			if(IngrFlag=="Y"){
				return false ;
			}
		},
		afteredit:function(e){
			if(e.field=='invno'){
				var invnoFlag=InvNoValidator(e.value,"");
				if(!invnoFlag){
					Msg.info("warning","��Ʊ��'"+e.value+"'�Ѵ�����������ⵥ��!");
					//e.record.set('invno',e.originalValue);
				}
			}
		}
	}
});

var MatordSumGridDs = new Ext.data.JsonStore({
	url : TableMatUrl+'?actiontype=QuerySum',
	root : 'rows',
	totalProperty : 'results',
	id : 'orirowid',
	fields : ['vendordr', 'vendor', 'inci', 'code', 'desc', 'spec','uomdr', 'uomdesc', 'qty','rpAmt','spAmt'
	]
});
var smsum=new Ext.grid.RowSelectionModel({
							singleSelect : true
						})
var MatordSumGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header:"��Ӧ��",
		dataIndex:'vendor',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"���ʴ���",
		dataIndex:'code',
		width:90,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'desc',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"���",
		dataIndex:'spec',
		width:80,
		align:'left'
	},{
		header:"��λ",
		dataIndex:'uomdesc',
		width:40,
		align:'left'
	},{
		header:"����",
		dataIndex:'qty',
		width:50,
		align:'right'
	},{
		header:"���۽��",
		dataIndex:'rpAmt',
		width:50,
		align:'right'
	},{
		header:"�ۼ۽��",
		dataIndex:'spAmt',
		width:50,
		align:'right'
	}
]);
var MatordSumGrid = new Ext.ux.EditorGridPanel({
	id : 'MatordSumGrid',
	store:MatordSumGridDs,
	cm:MatordSumGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : smsum,
	loadMask:true,
	clicksToEdit:1
});
//>>>>>>>>>>��ⵥ���Բ���>>>>>>>>>>
var GrMasterInfoStore = new Ext.data.JsonStore({
	url : DictUrl	+ 'ingdrecaction.csp?actiontype=QueryIngrStr',
	totalProperty : "results",
	root : 'rows',
	fields : ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
		"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
		"StkGrp","RpAmt","SpAmt","AcceptUser","InvAmt"],
	listeners : {
		load : function(store, records, option){
			if(records.length > 0){
				GrMasterInfoGrid.getSelectionModel().selectFirstRow();
				GrMasterInfoGrid.getView().focusRow(0);
			}
		}
	}
});

var GrMasterInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'IngrId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : "��ⵥ��",
		dataIndex : 'IngrNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : '��ⲿ��',
		dataIndex : 'RecLoc',
		width : 120,
		align : 'left',
		sortable : true
	},  {
		header : "��Ӧ��",
		dataIndex : 'Vendor',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		dataIndex : "StkGrp",
		hidden : true,
		hideable : false
	}, {
		header : '�ɹ�Ա',
		dataIndex : 'PurchUser',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "��ɱ�־",
		dataIndex : 'Complete',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ���",
		dataIndex : 'InvAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		xtype : 'numbercolumn',
		width : 80,
		align : 'right'
	}, {
		header : "��ע",
		dataIndex : 'InGrRemarks',
		width : 160,
		align : 'left'
	}
]);

var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
	id : 'GrMasterInfoGrid',
	title : '',
	cm : GrMasterInfoCm,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var InGr = r.get("IngrId");
				GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:InGr}});
			}
		}
	}),
	store : GrMasterInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:[GridPagingToolbar]
});

var GrDetailInfoStore = new Ext.data.JsonStore({
	url : DictUrl + 'ingdrecaction.csp?actiontype=QueryDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
		"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
		"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
		"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:DateFormat},"AdmNo",
		{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"CheckPack","InvMoney"]
});

var GrDetailInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "Ingri",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : '���ʴ���',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'Manf',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'BatchNo',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "��Ч��",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'IngrUom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'RecQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "�ۼ�",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "��Ʊ��",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ����",
		dataIndex : 'InvDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��Ʊ���",
		dataIndex : 'InvMoney',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var GrDetailInfoGrid = new Ext.grid.GridPanel({
	id : 'GrDetailInfoGrid',
	title : '',
	height : 170,
	cm : GrDetailInfoCm,
	store : GrDetailInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true
});

var IngrInfoPanel = new Ext.Panel({
	layout : 'border',
	items : [{region:'north',layout:'fit',height:200,items:GrMasterInfoGrid},
			{region:'center',layout:'fit',items:GrDetailInfoGrid}]
});
//<<<<<<<<<<��ⵥ���Բ���<<<<<<<<<<

//>>>>>>>>>>���ⵥ���Բ���>>>>>>>>>>
var InitMasterStore = new Ext.data.JsonStore({
	url : DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryTrans',
	totalProperty : "results",
	root : 'rows',
	fields : ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
			"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","confirmFlag"],
	listeners:{
		load:function(store,records,options){
			if(records.length>0){
				InitMasterGrid.getSelectionModel().selectFirstRow();
				InitMasterGrid.getView().focusRow(0);
			}
		}
	}
});

var InitMasterCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'init',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "ת�Ƶ���",
		dataIndex : 'initNo',
		width : 160,
		align : 'left',
		sortable : true
	}, {
		header : "������",
		dataIndex : 'toLocDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'frLocDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "ת������",
		dataIndex : 'dd',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : "�Ƶ���",
		dataIndex : 'userName',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'RpAmt',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'SpAmt',
		width : 80,
		align : 'right',
		sortable : true
	}
]);

var InitMasterPagingToolbar = new Ext.PagingToolbar({
	store:InitMasterStore,
	pageSize:PageSize,
	displayInfo:true
});
var InitMasterGrid = new Ext.grid.GridPanel({
	title : '',
	height : 170,
	cm : InitMasterCm,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var InIt = r.get("init");
				InitDetailStore.setBaseParam('Parref',InIt);
				InitDetailStore.removeAll();
				InitDetailStore.load({params:{start:0,limit:InitDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}})
			}
		}
	}),
	store : InitMasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar : InitMasterPagingToolbar
});

var InitDetailStore = new Ext.data.JsonStore({
	url : DictUrl + 'dhcinistrfaction.csp?actiontype=QueryDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["initi", "inrqi", "inci","inciCode",
		"inciDesc", "inclb", "batexp", "manf","manfName",
		 "qty", "uom", "sp","status","remark",
		"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec","newSp",
		"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"]
});

var InitDetailCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "ת��ϸ��RowId",
		dataIndex : 'initi',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "����Id",
		dataIndex : 'inci',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '���ʴ���',
		dataIndex : 'inciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'inciDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "����Id",
		dataIndex : 'inclb',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "����/Ч��",
		dataIndex : 'batexp',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'manfName',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "���ο��",
		dataIndex : 'inclbQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "ת������",
		dataIndex : 'qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "ת�Ƶ�λ",
		dataIndex : 'TrUomDesc',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "�ۼ�",
		dataIndex : 'sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'reqQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��λ��",
		dataIndex : 'stkbin',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "���󷽿��",
		dataIndex : 'reqLocStkQty',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "ռ������",
		dataIndex : 'inclbDirtyQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'inclbAvaQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "�����ۼ�",
		dataIndex : 'newSp',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "���",
		dataIndex : 'spec',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "�ۼ۽��",
		dataIndex : 'spAmt',
		width : 100,
		align : 'right',

		sortable : true
	}, {
		header : "���۽��",
		dataIndex : 'rpAmt',
		width : 100,
		align : 'right',
		sortable : true
	}
]);

var InitDetailPagingToolbar = new Ext.PagingToolbar({
	store:InitDetailStore,
	pageSize:PageSize,
	displayInfo:true
});

var InitDetailGrid = new Ext.grid.GridPanel({
	title : '',
	height : 200,
	cm : InitDetailCm,
	store : InitDetailStore,
	trackMouseOver : true,
	stripeRows : true,
	bbar:InitDetailPagingToolbar,
	loadMask : true
});

var InitInfoPanel = new Ext.Panel({
	layout : 'border',
	items : [{region:'north',layout:'fit',height:200,items:InitMasterGrid},
			{region:'center',layout:'fit',items:InitDetailGrid}]
});
//<<<<<<<<<<���ⵥ���Բ���<<<<<<<<<<

var tabPanel = new Ext.TabPanel({
	region : 'center',
	activeTab: 0,
	items:[
		{title: '��̨��ֵҽ����Ϣ',id:'HVMatPanel',layout:'fit',items:MatordGrid},
		{title: '��ֵҽ��������Ϣ',id:'MatordSumPanel',layout:'fit',items:MatordSumGrid},
		{title: '���β�¼�����Ϣ',id:'CurrentIngrPanel',layout:'fit',items:IngrInfoPanel},
		{title: '���β�¼������Ϣ',id:'CurrentInitPanel',layout:'fit',items:InitInfoPanel}
	],
	listeners:{
		'tabchange' : function(t,p){
			if (p.getId()=='CurrentIngrPanel'){
				if (CURRENT_INGR!=""){
					GrMasterInfoGrid.getStore().load({params:{IngrStr:CURRENT_INGR}});
				}
			}else if (p.getId()=='CurrentInitPanel'){
				if (CURRENT_INIT!=""){
					InitMasterGrid.getStore().load({params:{InitStr:CURRENT_INIT}});
				}
			}
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel, tabPanel]
	});
});
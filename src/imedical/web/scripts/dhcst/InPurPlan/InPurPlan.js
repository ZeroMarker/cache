// ����:�ɹ��ƻ���
// ��д����:2012-06-19

var deptId = locId;
var deptName = "";
var purId = planNnmber;
var purNo = "";
var PurPlan="";
var PlanPageSize=9999
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";
var Msg_LostModified='������¼����޸ģ��㵱ǰ�Ĳ�������ʧ��Щ������Ƿ����?';

if(gParam.length<1){
	GetParam();
}
if(gParamCommon.length<1){
	GetParamCommon();  
}
function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	inciDr = record.get("InciDr");
	// ѡ����
	var rowrecord = PlanGrid.getSelectionModel().getSelected();
	var row = PlanGridDs.indexOf(rowrecord)
	var findIndex=PlanGridDs.findExact ('IncId',inciDr,0);
	
	if(findIndex>=0 && findIndex!=row){
		Msg.info("warning","ҩƷ�ظ�¼��!");
		var col=GetColIndex(PlanGrid,"Qty");
		PlanGrid.startEditing(row, col);
	}
	
	var rowData = PlanGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("IncCode",record.get("InciCode"));
	rowData.set("IncDesc",record.get("InciDesc"));
	//��Ӧ��id^��Ӧ������^����id^��������^������id^����������^��ⵥλid^��ⵥλ^����^�ۼ�^�깺���ҿ����^�������^�������^ͨ����^��Ʒ��^����^���
	//{success:'true',info:'7^GAYY-�����㰲ҽҩ��������^61^bjymzy-����������ҩ��^^^26^��[20Ƭ]^0^0^0^^^��˾����Ƭ^^��ͨƬ��^[1mg*20]'}
	//ȡ����ҩƷ��Ϣ
	var locId = Ext.getCmp('locField').getValue();
	var Params=session['LOGON.GROUPID']+'^'+locId+'^'+UserId;	
	if(locId!=""){
		Ext.Ajax.request({
			url : 'dhcst.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ inciDr+'&Params='+Params,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
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
					rowData.set("Sp", data[9]); 
					rowData.set("CurStkQty", data[10]); 
					rowData.set("MaxQty", data[11]);     
					rowData.set("MinQty", data[12]);  
					rowData.set("Gene", data[13]);     
					rowData.set("GoodName", data[14]);     
					rowData.set("Form", data[15]);     
					rowData.set("Spec", data[16]); 
					rowData.set("BUomId", data[17]); 
					rowData.set("ConFacPur", data[18]); 
				    //===========�ж�������Ϣ===========
				    var inci=record.get("InciDr")
				    var DataList=VenId+"^"+inci+"^"+ManfId
				    //alert(DataList)
				   // var urldh = DictUrl+ "ingdrecaction.csp?actiontype=Check&DataList="+ DataList
				               
			        Ext.Ajax.request({
						url : 'dhcst.inpurplanaction.csp?actiontype=Check&DataList='+ DataList,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								var ret=jsonData.info
								//alert("data="+data)
								if(ret==1)  
								{Msg.info("warning", "��Ӧ�̹���ִ�ս���30���ڹ���!");
										return;}
								if(ret==3)  
								{Msg.info("warning", "��Ӧ��˰��ǼǺŽ���30���ڹ���!");
										return;}
							    if(ret==4)  
								{Msg.info("warning", "��Ӧ��ҩƷ��Ӫ���֤����30���ڹ���!");
										return;}
										
								if(ret==5)  
								{Msg.info("warning", "��Ӧ��ҽ����е��Ӫ���֤����30���ڹ���!");
										return;}
								if(ret==6)  
								{Msg.info("warning", "��Ӧ��ҽ����еע��֤����30���ڹ���!");
										return;}
								if(ret==7)  
								{Msg.info("warning", "��Ӧ���������֤����30���ڹ���!");
										return;}
								if(ret==8)  
								{Msg.info("warning", "��Ӧ����֯�������뽫��30���ڹ���!");
										return;}
								if(ret==9)  
								{Msg.info("warning", "��Ӧ��GSP��֤����30���ڹ���!");
										return;}
								if(ret==10)  
								{Msg.info("warning", "��Ӧ��ҽ����е�������֤����30���ڹ���!");
										return;}
								if(ret==11)  
								{Msg.info("warning", "��Ӧ�����������Ͽɱ���30���ڹ���!");
										return;}
								if(ret==12)  
								{Msg.info("warning", "��Ӧ�̽���ҽ����еע��֤����30���ڹ���!");
										return;}
								if(ret==13)  
								{Msg.info("warning", "��Ӧ�̽���ע��ǼǱ���30���ڹ���!");
										return;}
								if(ret==14)  
								{Msg.info("warning", "��Ӧ�̴���������Ȩ�齫��30���ڹ���!");
										return;}
								if(ret==15)  
								{Msg.info("warning", "��Ӧ��������ŵ�齫��30���ڹ���!");
										return;}
								if(ret==16)  
								{Msg.info("warning", "��Ӧ��ҵ��Ա��Ȩ�齫��30���ڹ���!");
										return;}
								if(ret==19)  
								{Msg.info("warning", "����ҩƷ�������֤����30���ڹ���!");
										return;}
								if(ret==20)  
								{Msg.info("warning", "���������������֤����30���ڹ���!");
										return;}
								if(ret==21)  
								{Msg.info("warning", "���̹���ִ����30���ڹ���!");
										return;}
								if(ret==22)  
								{Msg.info("warning", "���̹���ע��Ž���30���ڹ���!");
										return;}
								if(ret==23)  
								{Msg.info("warning", "������֯�������뽫��30���ڹ���!");
										return;}																																							
								if(ret==24)		
								{Msg.info("warning", "������е��Ӫ���֤����30���ڹ���!");
										return;}
								if(ret==26)		
								{Msg.info("warning", "������׼�ĺŽ���30���ڹ���!");
										return;}
							    if(ret==27)		
								{Msg.info("warning", "���ʽ���ע��֤����30���ڹ���!");
										return;}
							 
								
							} 
						},
						scope : this
					});  
				    //===========�ж�������Ϣ===========	
				} 
			},
			scope : this
		});
	}else{
		Msg.info("error", "��ѡ�����!");
	}
	var col=GetColIndex(PlanGrid,'Qty');
	var rowrecord = PlanGrid.getSelectionModel().getSelected();
	var recordrow = PlanGridDs.indexOf(rowrecord)
	PlanGrid.startEditing(recordrow,col);
}
	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList2);
	}
}

//=========================�ɹ��ƻ���=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
    allowBlank:false,
	fieldLabel:'����',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

// ��ӡ�ɹ���ť
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '�����ӡ�ɹ���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
	  var zbflagstr=getZBflag();
		
		PrintInPur(PurPlan,zbflagstr);
	}
});
 //���ư�ť
var CopyBT = new Ext.Toolbar.Button({
			text : '���Ʋɹ��ƻ�',
			width : 70,
			height : 30,
			iconCls : 'page_copy',
			handler : function() {
				FindPlan(Copy);
			}
		});
// ���տ��ҿ�����ɲɹ��ƻ���
var ConWinBT = new Ext.Toolbar.Button({
	id : "ConWinBT",
	text : '���ɲɹ��ƻ���',
	tooltip : '���ɲɹ��ƻ���',
	iconCls : 'page_goto',
	width : 70,
	height : 30,
	handler : function() {
		InPurPlanConWin(Select);
	}
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
// ҩƷ����
var groupField=new Ext.ux.StkGrpComboBox({ 
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //��ʶ��������
	anchor : '90%',
	LocId:CtLocId,
	UserId:UserId
}); 
		
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'����',
	anchor:'90%',
	listWidth:210,
	allowBlank:true,
	emptyText:'����...',
	groupId:gGroupId,
	listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('locField').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                          groupField.getStore().removeAll();
                          groupField.getStore().setBaseParam("locId",SelLocId)
                          groupField.getStore().setBaseParam("userId",UserId)
                          groupField.getStore().setBaseParam("type",App_StkTypeCode)
                          groupField.getStore().load();
			}
	}
});

		   // �б�
		var ZBFlag = new Ext.form.Radio({
			boxLabel : '�б�',
			id : 'ZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // ���б�
		var NotZBFlag = new Ext.form.Radio({
			boxLabel : '���б�',
			id : 'NotZBFlag',
			name : 'ZBType',
			anchor : '80%'
				});
					   // ȫ��
		var AllFlag = new Ext.form.Radio({
			boxLabel : 'ȫ��',
			id : 'AllFlag',
			name : 'ZBType',
			anchor : '80%',
			checked : true
				});	
		
//====================================================
var Uom = new Ext.form.ComboBox({
	fieldLabel : '��λ',
	id : 'Uom',
	name : 'Uom',
	anchor : '90%',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '��λ...',
	triggerAction : 'all',
	forceSelection : true,
	allowBlank : false,
	selectOnFocus : true,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var rowrecord = PlanGrid.getSelectionModel().getSelected();
				var row = PlanGridDs.indexOf(rowrecord)
				var col=GetColIndex(PlanGrid,"Qty");
				PlanGrid.startEditing(row, col);		
			}
		},
		'focus':function(field){
			var rowrecord = PlanGrid.getSelectionModel().getSelected();
			var row = PlanGridDs.indexOf(rowrecord)
			var record = PlanGrid.getStore().getAt(row);
			var ItmId=record.get("IncId");
			if(ItmId==null||ItmId==""){
				Msg.info("warning","����¼��ҩƷ����!");
				return;
			}		
			ItmUomStore.removeAll();
			ItmUomStore.load({
				params:{ItmRowid:ItmId}
			});
		}
	}
});		
ItmUomStore.on("load",function(store){
	var rowrecord = PlanGrid.getSelectionModel().getSelected();
	var row = PlanGridDs.indexOf(rowrecord);
	var record = PlanGrid.getStore().getAt(row);
	var UomId=record.get("UomId");	
	Uom.setValue(UomId);
})
/**
 * ��λչ���¼�
 */
Uom.on('beforequery', function(combo) {
			var rowrecord = PlanGrid.getSelectionModel().getSelected();
			var row = PlanGridDs.indexOf(rowrecord);
			var record = PlanGrid.getStore().getAt(row);
			var ItmId = record.get("IncId");
			var UomId=record.get("UomId");		
			ItmUomStore.removeAll();
			ItmUomStore.load({
				params:{ItmRowid:ItmId}
			});
		});
Uom.on('select', function(combo) {
	var rowrecord = PlanGrid.getSelectionModel().getSelected();
	var row = PlanGridDs.indexOf(rowrecord)
	var rowData = PlanGrid.getStore().getAt(row);
	var qty = rowData.get('Qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("Rp"); //ԭ����
	var sp = rowData.get("Sp"); //ԭ�ۼ�
	var buom=rowData.get("BUomId")
	var confac=rowData.get("ConFacPur")
	var uom=rowData.get("UomId")
	if(seluom!=uom){
		if(seluom!=buom){     //ԭ��λ�ǻ�����λ��Ŀǰѡ�������ⵥλ
			rowData.set("Rp", Number(rp).mul(confac)); 
			rowData.set("Sp", Number(sp).mul(confac));
			rowData.set("RpAmt", Number(rp).mul(confac).mul(qty)); //������
			rowData.set("SpAmt", Number(sp).mul(confac).mul(qty)); //���۽��
		}else{					//Ŀǰѡ����ǻ�����λ��ԭ��λ����ⵥλ
			rowData.set("Rp", Number(rp).div(confac)); 
			rowData.set("Sp", Number(sp).div(confac));
			rowData.set("RpAmt", Number(rp).div(confac).mul(qty)); //������
			rowData.set("SpAmt", Number(sp).div(confac).mul(qty)); //���۽��
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
	listeners:{
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				addNewRow();		
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
			
var Manf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'Manf',
	name : 'Manf',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '����...',
	filterName:'PHMNFName'
});		

var ReqLoc = new Ext.ux.LocComboBox({
	fieldLabel : '�깺����',
	id : 'ReqLoc',
	name : 'ReqLoc',
	defaultLoc:''//,
     //disabled:true
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
		'check':function(chk,v){
			setGridEditable(PlanGrid,!v);
		}	
	}
});

//====================================================

function addNewRow() {
	var rowCount =PlanGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = PlanGridDs.data.items[rowCount - 1];
		var data=rowData.get("IncId")
		if(data=="" || data.length<=0){
			var col=GetColIndex(PlanGrid,'IncDesc');
			PlanGrid.getSelectionModel().selectRow(PlanGridDs.getCount() - 1)
			PlanGrid.startEditing(PlanGridDs.getCount() - 1, col);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'IncId',
			type : 'int'
		}, {
			name : 'IncCode',
			type : 'string'
		}, {
			name : 'IncDesc',
			type : 'string'
		}, {
			name : 'Spec',
			type : 'string'
		}, {
			name : 'ManfId',
			type : 'int'
		}, {
			name : 'Manf',
			type : 'string'
		}, {
			name : 'Qty',
			type : 'string'
		}, {
			name : 'UomId',
			type : 'int'
		}, {
			name : 'Uom',
			type : 'string'
		}, {
			name : 'Rp',
			type : 'double'
		}, {
			name : 'Sp',
			type : 'double'
		}, {
			name : 'RpAmt',
			type : 'double'
		}, {
			name : 'SpAmt',
			type : 'double'
		}, {
			name : 'VenId',
			type : 'int'
		}, {
			name : 'Vendor',
			type : 'string'
		}, {
			name : 'CarrierId',
			type : 'int'
		}, {
			name : 'Carrier',
			type : 'string'
		}, {
			name : 'Gene',
			type : 'string'
		}, {
			name : 'GoodName',
			type : 'string'
		}, {
			name : 'Form',
			type : 'string'
		}, {
			name : 'PoId',
			type : 'int'
		}, {
			name : 'ReqLocId',
			type : 'int'
		}, {
			name : 'ReqLoc',
			type : 'string'
		}, {
			name : 'StkQty',
			type : 'int'
		}, {
			name : 'MaxQty',
			type : 'int'
		}, {
			name : 'MinQty',
			type : 'int'
		}, {
			name : 'ProPurQty',
			type : 'string'
		}, {
			name : 'CurStkQty',
			type : 'string'
		}, 
	]);
	
	var NewRecord = new record({
		RowId:'',
		IncId:'',
		IncCode:'',
		IncDesc:'',
		Spec:'',
		ManfId:'',
		Manf:'',
		Qty:'',
		UomId:'',
		Uom:'',
		Rp:'',
		Sp:'',
		RpAmt:'',
		SpAmt:'',
		VenId:'',
		Vendor:'',
		CarrierId:'',
		Carrier:'',
		Gene:'',
		GoodName:'',
		Form:'',
		PoId:'',
		ReqLocId:'',
		ReqLoc:'',
		StkQty:'',
		MaxQty:'',
		MinQty:'',
		ProPurQty:'',
		CurStkQty:''
	});
					
	PlanGridDs.add(NewRecord);
	PlanGrid.getSelectionModel().selectRow(PlanGridDs.getCount() - 1);
	var col=GetColIndex(PlanGrid,'IncDesc');
	PlanGrid.startEditing(PlanGridDs.getCount() - 1, col);
}

var PlanGrid="";
//��������Դ
var PlanGridUrl = 'dhcst.inpurplanaction.csp';
var PlanGridProxy= new Ext.data.HttpProxy({url:PlanGridUrl+'?actiontype=queryItem',method:'POST'});
var PlanGridDs = new Ext.data.Store({
	proxy:PlanGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
	/*
	�ӱ�Rowid^�����id^����^����^���^����id^����^����^��λid^��λ
/// ^����^�ۼ�^���۽��^�ۼ۽��^��Ӧ��id^��Ӧ��^������id^������^ͨ����^��Ʒ��^����^����RowId
/// ^�깺����id^�깺��������^�깺���ҿ����^�������^�������
*/
		{name:'RowId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'Spec'},
		{name:'ManfId'},
		{name:'Manf'},
		{name:'Qty'},
		{name:'UomId'},
		{name:'Uom'},
		{name:'Rp'},
		{name:'Sp'},
		{name:'RpAmt'},
		{name:'SpAmt'},
		{name:'VenId'},
		{name:'Vendor'},
		{name:'CarrierId'},
		{name:'Carrier'},
		{name:'Gene'},
		{name:'GoodName'},
		{name:'Form'},
		{name:'PoId'},
		{name:'ReqLocId'},
		{name:'ReqLoc'},
		{name:'StkQty'},
		{name:'MaxQty'},
		{name:'MinQty'},
		{name:'BUomId'},
		{name:'ConFacPur'},
		{name:'ProPurQty'},
		{name:'CurStkQty'},
	]),
    remoteSort:true,
    pruneModifiedRecords:true,
    baseParams:{
    	parref:''
    }
});

//ģ��
var PlanGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"RowId",
        dataIndex:'RowId',
        width:100,
        align:'left',
        hidden:true,
        sortable:true
    }, {
        header:"����",
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'IncDesc',
        id:'IncDesc',
        width:250,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
			selectOnFocus : true,
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp("groupField").getValue());
					}
				}
			}
        })
    },{
        header:"��λ",
        dataIndex:'UomId',
        id:'UomId',
        width:80,
        align:'left',
		editor : new Ext.grid.GridEditor(Uom),
		renderer : Ext.util.Format.comboRenderer2(Uom,"UomId","Uom")
    },{
        header:"�ɹ�����",
        dataIndex:'Qty',
        id:'Qty',
        width:80,
        align:'right',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			selectOnFocus:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var col=GetColIndex(PlanGrid,"VenId")
						var rowrecord = PlanGrid.getSelectionModel().getSelected();
						var row = PlanGridDs.indexOf(rowrecord)
						PlanGrid.startEditing(row, col);	
					}
				},
				'change':function() { 
					var rowrecord = PlanGrid.getSelectionModel().getSelected();
					var row = PlanGridDs.indexOf(rowrecord)
					var rowData = PlanGrid.getStore().getAt(row);
					var qty = rowData.get('Qty');
					rowData.set("RpAmt", rowData.get('Rp')*qty); //������
					rowData.set("SpAmt", rowData.get('Sp')*qty); //���۽��
				} 
			}
        })
    },{
        header:"����",
        dataIndex:'Rp',
        id:'Rp',
        width:80,
        align:'right',
        sortable:true,
        editor:new Ext.ux.NumberField({
			selectOnFocus : true,
			allowBlank : false,
			formatType: 'FmtRP',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if ((cost == null || cost=="" || cost==0)&(gParam[0].trim()=="Y")) {
							Msg.info("warning", "���۲���Ϊ�ջ���!");
							return;
						}
						if (cost < 0) {
							Msg.info("warning",
									"���۲���С��0!");
							return;
						}
					
					
						// ����ָ���еĽ������
						var rowrecord = PlanGrid.getSelectionModel().getSelected();
						var row = PlanGridDs.indexOf(rowrecord)
						var rowData = PlanGrid.getStore().getAt(row);
						var spcost = rowData.get('Sp');
						if (Number(cost)>Number(spcost)){
						   Msg.info("warning","���۲��ܴ����ۼ�!");
						   var colIndex=GetColIndex(PlanGrid,"Rp");
						   PlanGrid.startEditing(row, colIndex);
						   rowData.set("Rp","");
						   return;
							}
						
						var qty = rowData.get('Qty');
						rowData.set("RpAmt", Number(cost).mul(qty)); //������
						
						// ����һ��
						var col=GetColIndex(PlanGrid,"VenId")
						PlanGrid.startEditing(row, col);	
					}
				}
			}
		})

    },{
        header:"�ۼ�",
        dataIndex:'Sp',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"��Ӧ��",
        dataIndex:'VenId',
        id:'VenId',
        width:250,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(Vendor),
		renderer : Ext.util.Format.comboRenderer2(Vendor,"VenId","Vendor")
    },{
        header:"������",
        dataIndex:'CarrierId',
        id:'CarrierId',
        width:200,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(Carrier),
		renderer : Ext.util.Format.comboRenderer2(Carrier,"CarrierId","Carrier")
    },{
        header:"����",
        dataIndex:'ManfId',
        id:'ManfId',
        width:200,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(Manf),
		renderer : Ext.util.Format.comboRenderer2(Manf,"ManfId","Manf")
    },{
        header:"�깺����",
        dataIndex:'ReqLocId',
        id:'ReqLocId',
        width:150,
        align:'left',
        sortable:true,
		editor : new Ext.grid.GridEditor(ReqLoc),
		renderer : Ext.util.Format.comboRenderer2(ReqLoc,"ReqLocId","ReqLoc")
    },{
        header:"���",
        dataIndex:'Spec',
        width:120,
        align:'left'
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
        header:"����ͨ����",
        dataIndex:'Gene',
        width:150,
        align:'left'
    },{
        header:"������",
        dataIndex:'RpAmt',
        width:120,
        align:'right',
        renderer: FormatGridRpAmount
    },{
        header:"���۽��",
        dataIndex:'SpAmt',
        width:120,
        align:'right', 
        renderer: FormatGridSpAmount 
    },{
        header:"��Ʒ��",
        dataIndex:'GoodName',
        width:150,
        align:'left'
    },{
    	header:"����ɹ���",
    	dataIndex:'ProPurQty',
    	width:100,
    	align:'right',
    	sortable:true
    },{
    	header:"�깺���ҿ��",
    	dataIndex:'StkQty',
    	width:100,
    	align:'right',
    	sortable:true
    },{
    	header:"�ɹ����ҿ��",
    	dataIndex:'CurStkQty',
    	width:100,
    	align:'right',
    	sortable:true
    }
]);
//��ʼ��Ĭ��������
//PlanGridCm.defaultSortable = true;

var findPlan = new Ext.Toolbar.Button({
	id:'findbtn',
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindPlan(Select);
	}
});

var addPlan = new Ext.Toolbar.Button({
	text:'����һ��',
    tooltip:'����һ��',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		var v = Ext.getCmp('locField').getValue();
		if((v=="")||(v==null)){
			Msg.info("error","��ѡ�����!");
		}else{
			groupField.setDisabled(true);
			addNewRow();
		}
	}
});

var savePlan = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(PlanGrid.activeEditor != null){
			PlanGrid.activeEditor.completeEdit();
		} 
		var mod=Modified();
		if (mod==false)
		{
			Msg.info('warning','û����Ҫ���������!')
			return;
		}
		var purNo = Ext.getCmp('planNum').getValue();
		var locId = Ext.getCmp('locField').getValue();
		var stkGrpId = Ext.getCmp('groupField').getValue();
		var userId = UserId;
		if(locId==null || locId==""){
			Msg.info("warning","���Ҳ���Ϊ��!");
			return;
		}
		if((stkGrpId==null || stkGrpId=="")&(gParamCommon[9]=="N")){
			Msg.info("warning","���鲻��Ϊ��!");
			return;
		}
		var rowCount =PlanGridDs.getCount();
		//��ȡ���е��¼�¼
		var mr=PlanGridDs.getModifiedRecords();
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowid = mr[i].data["RowId"];
			var incId = mr[i].data["IncId"];
			var qty = mr[i].data["Qty"];
			var uomId = mr[i].data["UomId"];
			var vendorId = mr[i].data["VenId"];
			if(incId!="" && vendorId==""){Msg.info("warning","��"+(PlanGridDs.indexOf(mr[i])+1)+"���й�Ӧ��Ϊ��!");
							return}
			var rp = mr[i].data["Rp"];
			var sp = mr[i].data["Sp"];
			var desc=mr[i].data["IncDesc"]
			if(incId!=""){
				if ((rp == null || rp=="" || rp==0)&(gParam[0].trim()=="Y")) {
					Msg.info("warning", "���۲���Ϊ�ջ���!");
					return;
				}
				if (rp<0){
					Msg.info("warning","���۲���С��0");
					return;
				}
			}
			if(Number(rp)>Number(sp)){
				Msg.info("warning",desc+",���۲��ܴ����ۼ�!");
				return;
			}							
							
							
			var manfId = mr[i].data["ManfId"];
			var carrierId = mr[i].data["CarrierId"];
			var reqLocId = mr[i].data["ReqLocId"];
			if(incId!="" && qty==""){
				Msg.info("warning","��"+(PlanGridDs.indexOf(mr[i])+1)+"�вɹ�����Ϊ��!");
				return;
			}
			if(qty!="" && incId!=""){
				var dataRow = rowid+"^"+incId+"^"+qty+"^"+uomId+"^"+vendorId+"^"+rp+"^"+manfId+"^"+carrierId+"^"+reqLocId;
				if(data==""){
					data = dataRow;
				}else{
					data = data+xRowDelim()+dataRow;
				}
			}
			// �ж��ظ�����ҩƷ,��Ӧ��&����&ҩƷ����,���ж�����,yunhaibao20151117
			var mrrow=PlanGridDs.indexOf(mr[i])
			for (var j =0; j < rowCount; j++) {
				if (j==mrrow){continue;}
				var item_inci = PlanGridDs.getAt(j).get("IncId");
				var item_manf = PlanGridDs.getAt(j).get("ManfId");
				var item_vendor = PlanGridDs.getAt(j).get("VenId");
				var jcnt=j+1;
				var incidesc=PlanGridDs.getAt(j).get("IncDesc");
				if (item_inci == incId && item_manf == manfId && item_vendor == vendorId) {
					changeBgColor(mrrow, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", incidesc+",��"+(mrrow+1)+","+(j+1)+"��"+"ҩƷ�����Ϣ¼���ظ�������������!");
					return;
				}
			}
			
		}
		if ((data=="")&& (mod==false) ){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
	//	if(data!=""){  //alert(stkGrpId);
			Ext.Ajax.request({
				url: PlanGridUrl+'?actiontype=save',
				params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data},
				failure: function(result, request) {
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","����ɹ�!");
						purId=jsonData.info;
						Select(purId);
						
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
							Msg.info("error","ʧ��ҩƷ��������ϸ���治�ɹ�����ʾ���ɹ���ҩƷ!");
						}else if(jsonData.info==-8){
							Msg.info("error","�ɹ��ƻ������!");
						}else if(jsonData.info==-9){
							Msg.info("error","�ɹ��ƻ������!");
						}else{
							Msg.info("error","����ʧ��!");
						}
					}
				},
				scope: this
			});
		//}
    }
});

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
		if  ( (mod) &&(!compFlag) ) {
				Ext.Msg.show({
				   title:'��ʾ',
				   msg: Msg_LostModified,
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){Delete();}
				   },
				   //animEl: 'elId',
				   icon: Ext.MessageBox.QUESTION
				});
		}
		else
		{Delete();}	
	}
});

function Delete()
{
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���òɹ��ƻ���?',
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
function FinishPurPlan()
{
	var completeFlag=Ext.getCmp('Complete').getValue();
	if (completeFlag==true) {	
		Msg.info('error','��ǰ�ɹ��ƻ����Ѿ����!')
		return;
	}

	//��ȡ���е��¼�¼
	var mr=PlanGridDs.getCount();
	if(mr<1){
		Msg.info('warning','�ɹ��ƻ���ϸ������,�������!')
		return;
	}
	var data="";

	for(var i=0;i<mr;i++){
		
	    var record=PlanGridDs.getAt(i)
	    var incId = record.get("IncId");
           var vendorId = record.get("VenId");
           var rp = record.get("Rp");
           var icnt=i+1
           if(incId!="" && vendorId==""){Msg.info("warning","��"+icnt+"���й�Ӧ��Ϊ��!");
							return}
			if(incId!=""){
				if ((rp == null || rp=="" || rp==0)&(gParam[0].trim()=="Y")) {
					Msg.info("warning", "���۲���Ϊ�ջ���!");
					return;
				}
				if (rp<0){
					Msg.info("warning","���۲���С��0");
					return;
				}
			}
							
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
							addPlan.setDisabled(true);   //��������
							savePlan.setDisabled(true);   //���ɱ���
							deletePlan.setDisabled(true);   //����ɾ��
							finishPlan.setDisabled(true);   //�������
							Select(purId);
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "�ƻ����Ѿ����!");
								return false;
							}else if(jsonData.info==-4){
								Msg.info("error", "�Զ�����ʧ��!");
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
	disabled:true,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", "�ƻ���Ϊ��!");
			return false;
		}else{
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
			        title: '��ʾ',
			        msg: "�����ѷ����ı䣬���ȱ���!",
			        buttons: Ext.Msg.OK,
			        icon: Ext.MessageBox.INFO
			    });
			    return;
			    
				Ext.Msg.show({
				   title:'��ʾ',
				   msg: Msg_LostModified,
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){FinishPurPlan();}
				   },
				   //animEl: 'elId',
				   icon: Ext.MessageBox.QUESTION
				});
			}			
			else
			{
				FinishPurPlan();
			}
		}
	}
});

function CancelFinish()
{
	var completeFlag=Ext.getCmp('Complete').getValue();
	if (completeFlag==false) 
	{	Msg.info('error','��ǰ�ɹ��ƻ�����δ���!')
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
							finishPlan.setDisabled(false);   //���
							savePlan.setDisabled(false);
							deletePlan.setDisabled(false);
							addPlan.setDisabled(false);
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
				   //animEl: 'elId',
				   icon: Ext.MessageBox.QUESTION
				});
			}else
			{CancelFinish();}
		}
	}
});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	id : "ClearBT",
	text : '����',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		var compFlag=Ext.getCmp('Complete').getValue();
		var mod=Modified();
		if  ( mod&&(!compFlag) ) {
			Ext.Msg.show({
			   title:'��ʾ',
			   msg: Msg_LostModified,
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){
			   		if (b=='yes'){clearData() ;}			   		
			   	},
	 		   //animEl: 'elId',
			   icon: Ext.MessageBox.QUESTION
			});
		}
		else
		{	clearData() ;}
	}
});


function clearData(){
	Ext.getCmp("dateField").setValue(new Date());
	Ext.getCmp("planNum").setValue("");
	Ext.getCmp("Complete").setValue(false);
	addPlan.setDisabled(false);
	groupField.setDisabled(false);
	PlanGridDs.removeAll();
	PlanGrid.getView().refresh();
	purId='';
	purNo='';
	finishPlan.setDisabled(true);   //���
	savePlan.setDisabled(false);
	deletePlan.setDisabled(false);
	addPlan.setDisabled(false);
	
	setOriginalValue('MainForm');
}
// �任����ɫ
function changeBgColor(row, color) {
	PlanGrid.getView().getRow(row).style.backgroundColor = color;
}
 ///��������
function Copy(purid){
	Ext.Ajax.request({
		url: PlanGridUrl+'?actiontype=Copy',
		params:{parref:purid,userId:UserId},
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","���Ƴɹ�!");
				purId=jsonData.info;
				Select(purId);
				
			}else{
				Msg.info("success","����ʧ��!");
				}
		}
	})

}
var formPanel = new Ext.form.FormPanel({
	id:'MainForm',
	labelWidth : 60,
	autoScroll:false,
	labelAlign : 'right',
	frame : true,
    tbar:[findPlan,'-',ClearBT,'-',savePlan,'-',finishPlan,'-',noFinshPlan,'-',ConWinBT,'-',CopyBT,'-',PrintBT,'-',deletePlan],
	items : [{
			layout : 'column',		
			xtype : 'fieldset',
			title : '�ɹ���Ϣ',
			defaults:{border:false},
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{				
					columnWidth : .25,
					xtype : 'fieldset',
					items : [locField,dateField]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [planNumField] //,ZBFlag]
				},{
					columnWidth : .25,
					xtype : 'fieldset',
					items : [groupField] //NotZBFlag]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [Complete] //AllFlag]
			}]			
		}],
	listeners:{
	'afterrender':function(){
		//alert('afterrender');
		//setOriginalValue('MainForm');
	}
	
	}
	
});

//��ҳ������
var PlanPagingToolbar = new Ext.PagingToolbar({
    store:PlanGridDs,
	pageSize:PlanPageSize,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//��ҳ֮ǰ���ȼ����û����Ҫ���������
PlanPagingToolbar.on("beforechange",function(toolbar,params){
	PlanGridDs.commitChanges();
	var records=PlanGridDs.getModifiedRecords();
	if(records!=null){
		if(records.length>0){
			Msg.info("warning","��ǰҳ�����Ѿ������仯������б����ˢ�£�");
			return false;
		}
	}
	
	return true;
});

var DelItmBT=new Ext.Toolbar.Button({
	id:'DelItmBT',
	iconCls:'page_delete',
	tooltip:'ɾ��ѡ�м�¼',
	text:'ɾ����¼',
	width : 70,
	height : 30,
	handler:function(){
		DeleteItem();
	}
});
var GridColSetBT = new Ext.Toolbar.Button({
	text:'������',
    tooltip:'������',
    iconCls:'page_gear',
    //	width : 70,
    //	height : 30,
	handler:function(){
		GridColSet(PlanGrid,"DHCSTPURPLANAUDIT");
	}
    });
var newsm = new Ext.grid.CheckboxSelectionModel({  
        singleSelect : false, 
        ///yunhaibao20151118.shift,ctrl��ѡ����ͻ
		handleMouseDown : function(g, rowIndex, e){  
		        if (e.button !== 0 || this.isLocked()) {  
		               return;  
		        }  
		        var view = this.grid.getView();  
		        if (e.shiftKey && !this.singleSelect) {  
		             var last = this.last;  
		             this.selectRange(last, rowIndex, e.ctrlKey|| e.shiftKey);  
		             this.last = last;  
		             view.focusRow(rowIndex);  
		        }else{  
		             var isSelected = this.isSelected(rowIndex);  
		             if (e.ctrlKey && isSelected) {  
		                  this.deselectRow(rowIndex);  
		             }else if(!isSelected || this.getCount() > 0){  
		                  this.selectRow(rowIndex, e.ctrlKey || e.shiftKey);   
		                  view.focusRow(rowIndex);  
		             }  
		        }  
		  },
		onEditorKey : function(field, e){  
	        var k = e.getKey(),   
	        newCell,   
	        g = this.grid,   
	        last = g.lastEdit,  
	        ed = g.activeEditor,  
	        ae, last, r, c;  
	        var shift = e.shiftKey;  
	        if(k == e.TAB){  
	            e.stopEvent();  
	            ed.completeEdit();  
	            if(shift){  
	                newCell = g.walkCells(ed.row, ed.col-1, -1, this.acceptsNav, this);  
	            }else{  
	                newCell = g.walkCells(ed.row, ed.col+1, 1, this.acceptsNav, this);  
	            }  
	        }else if(k == e.ENTER){  
	            if(this.moveEditorOnEnter !== false){ 
	                if(shift){  
	                    newCell = g.walkCells(last.row - 1, last.col, -1, this.acceptsNav, this);  
	                }else{  
	            //CheckboxSelectionModel���ø���Ext.grid.RowSelectionModel��onEditorKey����  
	            //newCell = g.walkCells(last.row+1, last.col, 1, this.acceptsNav, this);  
	                    newCell = g.walkCells(last.row , last.col, 1, this.acceptsNav, this);  
	                }  
	            }  
	        }  
	        if(newCell){  
	            r = newCell[0];  
	            c = newCell[1];  
	            if(last.row != r){  
	                this.selectRow(r);   
	            }  
  
	            if(g.isEditor && g.editing){   
	                ae = g.activeEditor;  
	                if(ae && ae.field.triggerBlur){  
	                    ae.field.triggerBlur();  
	                }  
	            }
	            var noeditcol=GetColIndex(this.grid,"IncDesc");
	            if (c!=noeditcol)  //���IE11��������
	            { 
	            	g.startEditing(r, c);
	            } 
	        }  
	    }  
}); 
//���
PlanGrid = new Ext.grid.EditorGridPanel({
	store:PlanGridDs,
	title:'�ɹ��ƻ�����ϸ',
	cm:PlanGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : newsm,
	loadMask:true,
	bbar:PlanPagingToolbar,
	tbar:[addPlan,'-',DelItmBT,'-',GridColSetBT],
	clicksToEdit:1
});

PlanGrid.on('beforeedit',function(e){
	if(e.field=="UomId"){
		var inci=e.record.get("IncId");
		if(inci==null || inci==""){
			Msg.info("warning","����¼��ҩƷ!");
			e.cancel=true;
		}
	}
});
PlanGrid.on('headerclick',function(grid,columnIndex ,e)
	{
		var count=0
		count=grid.getStore().getCount()
		
		for(i=0;i<count;i++)
		{
		var record=grid.getStore().getAt(i)
		var rowid=record.get('RowId')       ///grid rowid
		if(Ext.isEmpty(rowid))
			{return false}
		}
	})
function DeleteItem(){	
		var completedFlag=Ext.getCmp('Complete').getValue();
		if (completedFlag) {
			Msg.info('error','��ǰ�ɹ��ƻ�����"���"����ֹɾ��');
			return;
		}
		var selectlist=PlanGrid.getSelectionModel().getSelections();
		if ((selectlist.length==null)||(selectlist.length<0)){
			Msg.info("error","��ѡ������!");
			return false;
		}
		else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ����¼?',
				function(btn) {
					if(btn == 'yes'){
						var selectlength=selectlist.length
						for (var selecti=0;selecti<selectlength;selecti++){
							var selectrecord=selectlist[selecti];
							var planItm = selectrecord.data['RowId'];
							if ((planItm!="")&&(planItm!=null)){  //�����첽,����refresh��������).
					            var deleteret=tkMakeServerCall("web.DHCST.INPurPlanItm","Delete",planItm);
					            if (deleteret=="0")
					            {
									PlanGridDs.remove(selectrecord);
					            }
					            else
					            {
						            if  (deleteret=="-1"){
						            	Msg.info("error","�ɹ��ƻ������!");
						            }
						            else if (deleteret=="-2"){
							            Msg.info("error","�ɹ��ƻ������!");							            
							        }
							        else if (deleteret=="-4"){
							            Msg.info("error","ɾ���ɹ��ƻ���ʧ��!");							            
							        }
							        else{
								    	Msg.info("error","ɾ��ʧ��!");
								    }
						        	return false;
						        }
							}
							else{
								PlanGridDs.remove(selectrecord);
							}
				
						}
						PlanGrid.getView().refresh();
					    //����ֻ��һ��ɾ����������������
						var rowCount =PlanGridDs.getCount();
						if(rowCount<1){
							if(purId) //���ڲɹ���ɾ�����һ����ϸ��ɾ������
								Delete();
						}
					}
				}
			 )
			}
	}

//zdm,2013-03-1,��ѯ�ɹ�������Ϣ
function Select(purid){
	Ext.Ajax.request({
		url : 'dhcst.inpurplanaction.csp?actiontype=select&purId='+purid,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var arr = jsonData.info.split("^");
			purNo = arr[1];
			Ext.getCmp('planNum').setValue(purNo);
			addComboData(Ext.getCmp("locField").getStore(),arr[2],arr[3]);
			Ext.getCmp("locField").setValue(arr[2]);	
			Ext.getCmp("dateField").setValue(arr[4]);
			deptName = arr[3];
			Ext.getCmp('groupField').setValue(arr[15]);
			Ext.getCmp('groupField').setRawValue(arr[16]);
			Ext.getCmp('Complete').setValue(arr[11]=='Y'?true:false);	
			setOriginalValue('MainForm');  //
			if(arr[11]=='Y'){
				addPlan.setDisabled(true);   //��������
				savePlan.setDisabled(true);   //���ɱ���
				deletePlan.setDisabled(true);   //����ɾ��
				finishPlan.setDisabled(true);   //�������
			}else{
				addPlan.setDisabled(false);   //��������
				savePlan.setDisabled(false);   //���ɱ���
				deletePlan.setDisabled(false);   //����ɾ��
				finishPlan.setDisabled(false);   //�������
			}
			groupField.setDisabled(true);
		},
		scope : this
	});
	PurPlan=purid;
	PlanGridDs.setBaseParam("parref",purid);
	PlanGridDs.removeAll();
	PlanGridDs.load({params:{start:0,limit:PlanPagingToolbar.pageSize,sort:'RowId',dir:'asc'}});
}


//���ݼƻ�����purId��ѯ�����Ϣ
if((purId!="")&&(purId!=null)&&(purId!=0)){
	Select(purId);
}
//=========================�ɹ��ƻ���=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'�ɹ��ƻ��Ƶ�',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(2),
		layout: 'fit', 
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,PlanGrid],
		renderTo:'mainPanel'
	});
	setZBflag(); //add wyx 2013-09-24
	RefreshGridColSet(PlanGrid,"DHCSTPURPLANAUDIT");   //�����Զ�������������������	
});
//===========ģ����ҳ��=============================================
//��һ��grid�еĿɱ༭��(editor��Ϊnull����)���б༭�趨��
// 
// grid - gridpanel
// b - true ,false
function setGridEditable(grid,b)
{	
	var cm=grid.getColumnModel();
	var colCount=cm.getColumnCount();
	
	for (var i=0;i<colCount;i++)
	{
		var colId=cm.getColumnId(i)
		var col=cm.getColumnById(colId);
		if (col.editor!=null)
		{
			cm.setEditable(i,b);
		}
	}
}

/*���Ƿ��޸�*/
function Modified(){
	var detailCnt=0
	var rowCount=PlanGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
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
		}
		else {
			result = false
		}
	}
	return result;
}
/*����ԭʼֵ��ά�ֳ�ʼδ�޸�״̬*/
function setOriginalValue(formId)
{
	if (formId=="") return;
	Ext.getCmp(formId).getForm().items.each(function(f){ 		
		f.originalValue=String(f.getValue()); 
	});
}
function setZBflag(){
     if (zbFlag==1) {Ext.getCmp("AllFlag").setValue(true);}
else if (zbFlag==2) {Ext.getCmp("ZBFlag").setValue(true);}
else if (zbFlag==3) {Ext.getCmp("NotZBFlag").setValue(true);}
else {Ext.getCmp("AllFlag").setValue(true);}

}
function getZBflag(){

		var ZBFlag=Ext.getCmp("ZBFlag").getValue();
		var NotZBFlag=Ext.getCmp("NotZBFlag").getValue();
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		
		if (AllFlag==true){
			var zbflagstr=1;
			}
		else if(ZBFlag==true){
			var zbflagstr=2;
			}
		else{
			var zbflagstr=3;
			}

    return zbflagstr;
}
	//-------------------Events-------------------//

    //����Grid������ʾ����
	//Creator:LiangQiang 2013-11-20
    PlanGrid.on('mouseover',function(e){
		
		var rowCount = PlanGrid.getStore().getCount();
		if (rowCount>0)
		{  
			var ShowInCellIndex=GetColIndex(PlanGrid,"IncCode")  //�ڵڼ�����ʾ
			var index = PlanGrid.getView().findRowIndex(e.getTarget());
			var record = PlanGrid.getStore().getAt(index);
			if (record)
			{
				var desc=record.data.IncDesc;
				var inci=record.data.IncId;
			}
			ShowAllLocStkQtyWin(e,PlanGrid,ShowInCellIndex,desc,inci);
		}

	},this,{buffer:200});


   
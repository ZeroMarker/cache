// ����:��������
// ��д����:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var abConsumeReq = reqByabConsume;		//ҳ����ת����
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gHospId=session['LOGON.HOSPID'];
var URL = 'dhcstm.inrequestaction.csp';
var req = "";		//����ȫ�ֱ���:����rowid
var defaReqType="O";
var byTemplate=false;	//����ģ���Ƶ���־

gHVInRequest = typeof(gHVInRequest)=='undefined'?false:gHVInRequest;		//2016-04-29 ��Ӹ�ֵ��־
//ȡ��ֵ�������
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}

if(gParam.length<1){
		GetParam();  //��ʼ����������
	}
var requestNnmber = new Ext.form.TextField({
	id:'requestNnmber',
	fieldLabel:'���󵥺�',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// ������
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '������',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '������...',
	groupId:gGroupId,
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
	listeners:{
		'select':function(cb){
			var requestLoc=cb.getValue();
			var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
			var mainArr=defprovLocs.split("^");
			var defprovLoc=mainArr[0];
			var defprovLocdesc=mainArr[1];
			if(!Ext.isEmpty(defprovLoc) && !Ext.isEmpty(defprovLocdesc)){
				addComboData(Ext.getCmp('supplyLocField').getStore(),defprovLoc,defprovLocdesc);
				Ext.getCmp("supplyLocField").setValue(defprovLoc);
				var provLoc=Ext.getCmp('supplyLocField').getValue();
				Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);
			}
		}
	}
	//defaultLoc:{}    //Ĭ��ֵΪ��
});

//����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:CtLocId,
	anchor:'90%',
	UserId:UserId
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	listWidth:150,
	fieldLabel:'�Ƶ�����',
	anchor:'90%',
	value:new Date(),
	disabled:true
});

var timeField=new Ext.form.TextField({
	id:'timeField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'�Ƶ�ʱ��'
});

var userField=new Ext.form.TextField({
	id:'userField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'�Ƶ���'
});

var supplyLocField = new Ext.ux.ComboBox({
	id:'supplyLocField',
	fieldLabel:'��������',
	anchor:'90%',
	store:frLocListStore,
	displayField:'Description',
	valueField:'RowId',
	listWidth:210,
	emptyText:'��������...',
	params:{LocId:'LocField'},
	filterName : 'FilterDesc',
	listeners:{
		'select':function(cb){
			var provLoc=cb.getValue();
			var requestLoc=Ext.getCmp('LocField').getValue();
			Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);
		}
	}
});

var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'��ע',
	anchor:'90%',
	height:100,
	selectOnFocus:true
});
function startedit (row, colIndex){
	InRequestGrid.startEditing(row, colIndex);
	}
var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	boxLabel : '���',
	hideLabel : true,
	anchor:'100%',
	disabled:true,
	allowBlank:true,
	listeners : {
		check : function(checkbox,checked){
			if(checked){
				Ext.getCmp("save").disable();
				Ext.getCmp("delete").disable();
				Ext.getCmp("complete").disable();
				Ext.getCmp("cancelComp").enable();
			}else{
				Ext.getCmp("save").enable();
				Ext.getCmp("delete").enable();
				Ext.getCmp("complete").enable();
				Ext.getCmp("cancelComp").disable();
			}
		}
	}
});
var templateFlag=new Ext.form.Checkbox({
	id: 'template',
	boxLabel : 'ģ���־',
	hideLabel : true,
	anchor:'100%',
	allowBlank:true
});
//20180914
var ExpressFlag=new Ext.form.Checkbox({
	id: 'ExpressFlag',
	boxLabel : '�ͻ���־',
	hideLabel : true,
	anchor:'100%',
	allowBlank:true
});
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

CTUom.on('expand', function(combo) {
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
	var record = InRequestGrid.getStore().getAt(cell[0]);
	var IncRowid = record.get("inci");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:IncRowid}});
});

CTUom.on('select', function(combo) {
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
	var record = InRequestGrid.getStore().getAt(cell[0]);
	var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
	var uom=value;
	var inci=record.get("inci");
	var LocId=Ext.getCmp('LocField').getValue();
	var frLoc = Ext.getCmp('supplyLocField').getValue();
	var params=gGroupId+"^"+LocId+"^"+UserId+"^"+uom+"^"+frLoc;
	GetItmInfo(inci,params,record);
});

var Specom = new Ext.form.ComboBox({
	fieldLabel : '������',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	width : 120,
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '������...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function()

			{	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
				var record = InRequestGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("inci");
				var desc=this.getRawValue();
				this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
				this.store.setBaseParam('SpecItmRowId',IncRowid)
				this.store.setBaseParam('desc',desc)
				this.store.load({params:{start:0,limit:this.pageSize}})
			}
	})
});

var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','��ʱ����'],['C','����ƻ�']]
})
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'��������',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	value : 'O',
	triggerAction:'all',
	anchor:'90%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local',
	disabled:true
});
///ȡ����Ӧ�õĲ���ֵ
var appname="DHCSTINREQM";
var proloc=Ext.getCmp('supplyLocField').getValue();
var reqparams=GetAppPropValue(appname,proloc);   //����ģ��Ӧ�ò�������

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						findRec(refresh);
					}
				}
			})
		} else {
			findRec(refresh);
		}
	}
});

var clear = new Ext.Toolbar.Button({
	id:'clear',
	text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						SetFormOriginal(formPanel);
					}
				}
			})
		}else{
			clearReq();
			SetFormOriginal(formPanel);
		}
	}
});

function clearReq()
{
	req="";
	InRequestGridDs.removeAll();
	remark.setValue("");
	requestNnmber.setValue("");  //groupField
	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");
	reqType.setValue("");
	reqType.setValue(defaReqType)  //���ó�ʼ
	Ext.getCmp('template').setValue(false);
	Ext.getCmp('template').setDisabled(false);
	Ext.getCmp('ExpressFlag').setValue(false);
	Ext.getCmp('save').enable();
	add.setDisabled(false);
	
	if(!Ext.isEmpty(LocField.protype)){
		//Ext.getCmp('LocField').setValue("");  //�������ʹ�ù�������,�������ʾ��½����
		LocField.getStore().reload();
	}else{
		SetLogInDept(LocField.getStore(),'LocField');
	}
	supplyLocField.setValue("");
	groupField.store.load();
	setEditEnable();
	//���csp�����ı���
	if(reqByabConsume>0){
		location.href="dhcstm.inrequest.csp";
	}
}

function changeBgColor(row, color) {
	InRequestGrid.getView().getRow(row).style.backgroundColor = color;
}

function getDrugList2(records) {
	records = [].concat(records);
	if (records == null || records == "") {
	return;
	}
	Ext.each(records,function(record,index,allItems){
		var inciDr = record.get("InciDr");
		var findIndex = InRequestGridDs.findExact('inci',inciDr);
		if(findIndex>=0){
			changeBgColor(findIndex,"yellow");
			Msg.info("warning",record.get("InciDesc")+"�Ѵ����ڵ�"+(findIndex+1)+"��!");
			return;
		}
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		// ѡ����
		var row = cell[0];
		var rowData = InRequestGridDs.getAt(row);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("stkQty",record.get("PAvaQty"));		//PuomQty
		rowData.set("reqPuomQty",record.get("reqPuomQty"));
		rowData.set("inciRemarks",record.get("remarks"));

		//��Ӧ��id^��Ӧ������^����id^��������^������id^����������^��ⵥλid^��ⵥλ^����^�ۼ�^�깺���ҿ����^�������^�������^ͨ����^��Ʒ��^����^���
		//{success:'true',info:'7^GAYY-�����㰲ҽҩ��������^61^bjymzy-����������ҩ��^^^26^��[20Ƭ]^0^0^0^^^��˾����Ƭ^^��ͨƬ��^[1mg*20]'}
		//ȡ����������Ϣ

		var locId = Ext.getCmp('LocField').getValue();
		if(locId!=""){
			var uom="";
			var frLoc = Ext.getCmp('supplyLocField').getValue();
			var params=gGroupId+"^"+locId+"^"+UserId+"^"+uom+"^"+frLoc
			GetItmInfo(record.get("InciDr"),params,rowData)
		}else{
			Msg.info("error","��ѡ�����!");
		}

		addNewRow()
	})
	var colIndex=GetColIndex(InRequestGrid,"qty");
	if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
	var count=InRequestGridDs.getCount()
		var row
		for(i=0;i<count;i++){
			if(Ext.isEmpty(InRequestGridDs.getAt(i).get('qty')))
			{row=i;break}
		}
		InRequestGrid.getSelectionModel().select(row, colIndex);
		InRequestGrid.startEditing(row, colIndex);
	}
}

function GetItmInfo(inci,paramstr,rowData){
	var url=URL+'?actiontype=GetItmInfo&IncId='+ inci +'&Params='+paramstr;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var data=jsonData.info.split("^");
		var ManfId = data[0];
		var Manf = data[1];
		rowData.set("manf", Manf);
 
		var UomId=data[2];
		var Uom=data[3];
		addComboData(ItmUomStore,data[2],data[3]);
		rowData.set("uom", UomId);
		rowData.set("sp", data[5]);
		rowData.set("rp", data[4]);
		rowData.set("spAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('sp'))));
		rowData.set("rpAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('rp'))));
		rowData.set("repLev", data[10]);
	}
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		//��������
		var frLoc = Ext.getCmp('supplyLocField').getValue();
		//������
		var toLoc = Ext.getCmp('LocField').getValue();
		var HV = gHVInRequest?'Y':UseItmTrack?'N':'';
		var frLocInRequestParamObj=GetAppPropValue('DHCSTINREQM',frLoc); ///���ݿⷿ�ж�
		var QtyFlag = (frLocInRequestParamObj.QtyFlag && frLocInRequestParamObj.QtyFlag =='Y') ? '1' : '0';
		GetPhaOrderWindow(item, group, App_StkTypeCode, frLoc, "N",
			QtyFlag, gHospId,getDrugList2,toLoc,"",
			"","","O","N","Y",
			"",HV,gParam[7]);
	}
}

function addNewRow() {
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ���������');
		return;
	}
	var rowCount =InRequestGrid.getStore().getCount();
	if(rowCount==0 || InRequestGridDs.getAt(rowCount - 1).get("inci")!=''){
		var defaData = {};
		var NewRecord = CreateRecordInstance(InRequestGridDs.fields,defaData);
		InRequestGridDs.add(NewRecord);
	}
	var colIndex=GetColIndex(InRequestGrid,"desc");
	if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
		InRequestGrid.getSelectionModel().select(InRequestGridDs.getCount() - 1, colIndex);
		InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, colIndex);
	}
	setEditDisable();
}

var InRequestGrid="";
//��������Դ
var InRequestGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryDetail',method:'GET'});
var InRequestGridDs = new Ext.data.Store({
	proxy:InRequestGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
		}, [
		{name:'rowid'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'repLev'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'spec'},
		{name:'SpecDesc'},
		{name:'manf'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'remark'},
		{name:'stkQty'},
		{name:'inciRemarks'},
		{name:'reqPuomQty'}
	]),
	remoteSort:false,
    listeners : {
		load : function(ds){
			//����ģ���Ƶ�ʱ,��rowid�ÿ�
			if (byTemplate){
				var cnt=ds.getCount();
				for (var i=0;i<cnt;i++){
					var rec=ds.getAt(i);
					rec.set('rowid','');
				}
				byTemplate=false;
			}
		}
	}
});

//ģ��
var InRequestGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"��ϸrowid",
        dataIndex:'rowid',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����rowid",
        dataIndex:'inci',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"���ʴ���",
        dataIndex:'code',
        width:100,
        align:'left',
        renderer :Ext.util.Format.InciPicRenderer('inci'),
        sortable:true
    },{
        header:"��������",
        dataIndex:'desc',
        id:'colDesc',
        width:150,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stkGrp=Ext.getCmp("groupField").getValue();
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),stkGrp);
					}
				}
			}
        })
    },{
        header:"���",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"�������ÿ����",
        dataIndex:'stkQty',
        width:100,
        align:'right',
        sortable:true
	},{
        header:"�������",
        dataIndex:'repLev',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��������",
        dataIndex:'qty',
        id:'colQty',
		xtype:'numbercolumn',
		//format:'0',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {						
						var qty = field.getValue();
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
						var itm=InRequestGridDs.getAt(cell[0]).get('inci');
						if (itm=='') {return;}
						var repLev = InRequestGridDs.getAt(cell[0]).get('repLev');
						var stkQty = InRequestGridDs.getAt(cell[0]).get('stkQty');
						if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
						if ((repLev!=""&repLev!=null&repLev!=0)&&(reqparams.IfAllowReqBQtyUsed=="Y")){
							Msg.info("error", "����������Ҫ�����������������!");
							return;
						}else if ((gParam[8]!="Y")&&((qty-stkQty)>0)){
							Msg.info("error", "�������������Դ��ڿ����!");
							return;
						}else{
							var colIndex=GetColIndex(InRequestGrid,"qty");
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
								var count=InRequestGridDs.getCount();
								var row;
								for(i=0;i<count;i++){
									if(Ext.isEmpty(InRequestGridDs.getAt(i).get('qty'))){row=i;break;}
								}
								if (row>=0){
									if(Ext.isEmpty(InRequestGridDs.getAt(row).get('inci'))){
										colIndex=GetColIndex(InRequestGrid,"desc");
									}
									InRequestGrid.getSelectionModel().select(row, colIndex);
									startedit.defer(20,this,[row, colIndex]);  /////��ʱ������   ��ֹ��grid���¼���ͻ����startEditingʧ�ܵ�����
								}
							}else{
								addNewRow();
							}
						}
					}
					else if(e.getKey() == Ext.EventObject.DOWN)	{
						var cs=InRequestGrid.getSelectionModel();
						var ss=cs.getSelectedCell () ;
						var row=ss[0];
						var col=ss[1];
						var cnt=InRequestGrid.store.getCount();
						if ((row+1)<cnt){
							cs.select(row+1,col,'',false);
							InRequestGrid.startEditing(row+1,col);
						}
						
					}
					else if (e.getKey() == Ext.EventObject.UP)	{
						var colIndex=GetColIndex(InRequestGrid,"qty");
						var cs=InRequestGrid.getSelectionModel();
						var ss=cs.getSelectedCell () ;
						var row=ss[0];
						var col=ss[1];
						if (row>0){
							cs.select(row-1,col,'',false);
							InRequestGrid.startEditing(row-1,col);
						}
					}
				}
			}
        })
    },{
        header:"���۵���",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.grid.GridEditor(CTUom),
		renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc")
    },{
        header:"����ע",
        dataIndex:'remark',
        id:'colRemark',
        width:200,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'remarkField',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
						if(InRequestGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","������������Ϊ0!");

							var colIndex=GetColIndex(InRequestGrid,"qty");
							if (!InRequestGrid.getColumnModel().isHidden(colIndex))
							{
								InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, colIndex);
							}
							return false;
						}else{
							//����һ��
							addNewRow();
						}
					}
				}
			}
        })
    },{
        header:"���ʱ�ע",
        dataIndex:'inciRemarks',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"������",
        dataIndex:'SpecDesc',
        width:100,
        align:'left',
        sortable:true,
        editor : new Ext.grid.GridEditor(Specom),
        renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
    },{
        header:"�����ҿ����",
        dataIndex:'reqPuomQty',
        width:100,
        align:'right',
        sortable:true
	}
]);

var add = new Ext.Toolbar.Button({
	text:'�½�',
	id:'newReq',
	iconCls:'page_add',
    tooltip:'�½����ת������',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
			   		if (btn=='yes') {clearReq();}
			   }
			})
		}
		else {
			clearReq();
		}
	}
});

function CheckBefore(tempFlag){
	if (tempFlag){
		var remark=Ext.getCmp('remark').getValue();
		var xx=remark.trim();
		if ((xx=="")||(xx==null)){
			Msg.info('error',"����<��ע>��дģ�����ơ�");
			return;
		}
	}
	//������Ϣ
	//��������
	var frLoc = Ext.getCmp('supplyLocField').getValue();
	if((frLoc=="")||(frLoc==null)){
		Msg.info("error", "��ѡ�񹩸�����!");
		return false;
	}
	//������
	var toLoc = Ext.getCmp('LocField').getValue();
	if((toLoc=="")||(toLoc==null)){
		Msg.info("error", "��ѡ��������!");
		return false;
	}
	if(frLoc == toLoc){
		Msg.info("warning", "�����ź͹�Ӧ���Ų�����ͬ!");
		return;
	}
	//��½�û�
	var user = UserId;
	//����
	var scg = Ext.getCmp('groupField').getValue();
	if(Ext.isEmpty(scg) && gParam[5]!='Y'){
		Msg.info("error", "��ѡ������!");
		return false;
	}
	//��ɱ�־(��ʱΪ��)
	var status =Ext.getCmp('reqType').getValue();
	//��ע
	var remark = Ext.getCmp('remark').getValue();
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var ExpressFlag=Ext.getCmp('ExpressFlag').getValue()?'Y':'N';
	//������Ϣ�ַ���
	var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark+"^"+(tempFlag?'Y':'')+"^^^^"+ExpressFlag;
	if(RowDelim==null){
		Msg.info("error", "�зָ������󣬲��ܱ���!");
		return false;
	}
	if(InRequestGrid.activeEditor != null){
		InRequestGrid.activeEditor.completeEdit();
	}
	//�ӱ���ϸ
	var data = "";
	var count= InRequestGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InRequestGridDs.getAt(index);
				//���������ݷ����仯ʱִ����������
	    if(rec.data.newRecord || rec.dirty){
			var inc = rec.data['inci'];
			var qty = rec.data['qty'];
			var colRemark=rec.data['remark'];
			var SpecDesc=rec.data['SpecDesc'];
			var repLev=rec.data['repLev'];
			var stkqty=rec.data['stkQty'];
			if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
			if((inc!="")&&(inc!=null)){
				if(qty==0){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"��������������Ϊ�ջ�0!");
					return;
				}
				if((repLev!=""&repLev!=null&repLev!=0)&&(reqparams.IfAllowReqBQtyUsed=="Y")){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"�����������������������������!");
					return;
				}
				if((gParam[8]!="Y")&&((qty-stkqty)>0)){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"�������������ܴ��ڿ����!");
					return;
				}
				var tmp = rec.data['rowid']+"^"+inc+"^"+rec.data['uom']+"^"+qty+"^"+colRemark+"^"+scg+"^"+SpecDesc;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
	}
	if ( (req=='')&& (data=="")) {Msg.info("error", "û��������Ҫ����!");return false;};
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "û��������Ҫ����!");return false;};
	saveReq(req,reqInfo,data);
    /*
    Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=ChecklimitReqDetail',
		params:{ListDetail:data,LocId:toLoc},
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var responseText22=jsonData.info;
				if(responseText22!=0){
                   var res=responseText22.split("^");
                   for (var ii=0;ii<res.length;ii++){
                       changeBgColor(res[ii]-1, "yellow");
                   }
                   Msg.info("warning", "��ɫ���������ڱ������������������������Ƶ�����ϵ�ⷿ!");
                   return false;
        
                }else{
	                saveReq(req,reqInfo,data);
                }
			}
		},
		scope : this
	});*/
	
}


function saveReq(req,reqInfo,data){
    
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=save',
		params:{req:req,reqInfo:reqInfo,data:data},
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "����ɹ�!");
				req = jsonData.info;
				refresh(req);
			}else{
				if(jsonData.info==-1){
					Msg.info("error", "������ʧ��!");
				}else if(jsonData.info==-99){
					Msg.info("error", "�������ʧ��!");
				}else if(jsonData.info==-2){
					Msg.info("error", "�������ʧ��!");
				}else if(jsonData.info==-5){
					Msg.info("error", "��ϸ����ʧ��!");
				}else if(jsonData.info==-4){
					Msg.info("error", "����������ʧ��!");
				}else if(jsonData.info==-3){
					Msg.info("error", "������ʧ��!");
				}else{
					Msg.info("error", "����ʧ��!");
				}
			}
		},
		scope : this
	});
	complete.enable();
	add.enable();
}

var save = new Ext.ux.Button({
	text:'����',
	id:'save',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(abConsumeReq>0){
			req = abConsumeReq;
		}
		//����ʱ���������ַ���
		//1.����rowid
		//2.�������Ϣ��frLoc��toLoc��user��scg��status��remark
		//3.�ӱ���ϸ��Ϣ��req����ϸ�ַ���rows(rows��Ϣ��reqi(��ϸrowid)��data(inci��uom��qty))
		var templateFlag=Ext.getCmp('template').getValue();
		CheckBefore(templateFlag);
	}
});
var findTemplate = new Ext.Toolbar.Button({
	text:'ģ��༭',
	id:'findTemplate',
	iconCls:'page_gear',
	tooltip:'�鿴���༭ģ��',
	width : 70,
	height : 30,
	handler:function(){
		findReqTemplateWin(Ext.getCmp('reqType').getValue(),(gHVInRequest==true?'Y':'N'));
	}
});

var ReqByTemplate=new Ext.Toolbar.Button({
	text:'ģ���Ƶ�',
	id:'reqByTemplate',
	iconCls:'page_add',
	tooltip:'����ģ���Ƶ�',
	width : 70,
	height : 30,
	handler:function(){
		xReqByTemplateWin(Ext.getCmp('reqType').getValue(),(gHVInRequest==true?'Y':'N'));
	}
});
function refresh(req){
	Select(req);
	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
}

function importReqTem(req,Reqdetailidstr){
	byTemplate=true;
	//���formPanel�Ͽ��Ƹ�ֵ
	clearReq();
	SetFormOriginal(formPanel);
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=select&ReqId='+req,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data=jsonData.info;
				if(data.length>0){
					var dataArr=data.split("^");
					addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
					Ext.getCmp('LocField').setValue(dataArr[2]);
					Ext.getCmp('userField').setValue(dataArr[14]);
					Ext.getCmp('reqType').setValue(dataArr[5]);
					addComboData(Ext.getCmp('supplyLocField').getStore(),dataArr[8],dataArr[12]);
					Ext.getCmp('supplyLocField').setValue(dataArr[8]);
					addComboData(groupField.getStore(),dataArr[15],dataArr[16],groupField);
					Ext.getCmp('groupField').setValue(dataArr[15]);
				}
			}
		}
	});

	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req,Reqdetailidstr:Reqdetailidstr}});
}
function Select(reqid){
	if(reqid==null || reqid==''){
		return;
	}
	req=reqid;
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=select&ReqId='+reqid,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data=jsonData.info;
				if(data.length>0){
					var dataArr=data.split("^");
					Ext.getCmp('requestNnmber').setValue(dataArr[1]);
					addComboData(Ext.getCmp('supplyLocField').getStore(),dataArr[8],dataArr[12]);
					Ext.getCmp('supplyLocField').setValue(dataArr[8]);
					addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
					Ext.getCmp('LocField').setValue(dataArr[2]);
					Ext.getCmp('dateField').setValue(dataArr[6]);
					Ext.getCmp('timeField').setValue(dataArr[9]);
					Ext.getCmp('userField').setValue(dataArr[14]);
					Ext.getCmp('reqType').setValue(dataArr[5]);
					addComboData(groupField.getStore(),dataArr[15],dataArr[16],groupField);
					Ext.getCmp('groupField').setValue(dataArr[15]);
					Ext.getCmp("completeCK").setValue(dataArr[11]=="Y");
					Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),(dataArr[11]=="Y"));
					Ext.getCmp('remark').setValue(handleMemo(dataArr[10],xMemoDelim()));
					Ext.getCmp('template').setValue(dataArr[18]=='Y'?true:false);
					Ext.getCmp('template').setDisabled(true);
					Ext.getCmp('ExpressFlag').setValue(dataArr[22]=='Y'?true:false);
					setEditDisable();
					SetFormOriginal(formPanel);
				}
			}
		},
		scope : this
	});
}

var complete = new Ext.Toolbar.Button({
	id:'complete',
	text:'ȷ�����',
    tooltip:'ȷ�����',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (req=='') {
			Msg.info('warning','û���κ����󵥣�');
			return ;
		}
		var rowCount = InRequestGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var rowdata=InRequestGridDs.getAt(i);
			var UseLocLimitQty=InRequestParamObj.UseLocLimitQty;
			if(UseLocLimitQty=="Y"){
				var ReqLocid=Ext.getCmp("LocField").getValue();
				var inci=rowdata.get('inci');
				var Uomid=rowdata.get('uom');
				var Qty=rowdata.get('qty');
				var LimitQtyStr=tkMakeServerCall("web.DHCSTM.LocLimitAmt","GetLimitQty",ReqLocid,inci,Uomid);
				var OnceReqQty=Number(LimitQtyStr.split("^")[0]);
				var AddReqQty=Number(LimitQtyStr.split("^")[1]);
				var AllReqQty=Number(LimitQtyStr.split("^")[2]);
				if ((OnceReqQty>0)&&(Qty>OnceReqQty)){
					Msg.info("warning","��������������������"+OnceReqQty);
					changeBgColor(i,"yellow");
					return false;
				}
				if ((AllReqQty>0)&&(AddReqQty>AllReqQty)){
					Msg.info("warning","��ʱ���������������������"+AllReqQty);
					changeBgColor(i,"yellow");
					return false;
				}
			}
			var item = InRequestGridDs.getAt(i).get("inci");
			if (item != undefined && item !='') {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", "��������ϸ!");
			return false;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=SetComp&req='+req,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȷ����ɳɹ�!");
				        refresh(req);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "����ʧ��!");
						}else if(jsonData.info==-1){
							Msg.info("error", "����ʧ��!");
						}else{
							Msg.info("error", "����ʧ��!");
						}
					}
				},
				scope : this
			});
		}
	}
});

var cancelComplete = new Ext.Toolbar.Button({
	text:'ȡ�����',
    tooltip:'ȡ�����',
    id:'cancelComp',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (req=='') {
			Msg.info('warning','û���κ����󵥣�');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=CancelComp&req='+req,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ����ɳɹ�!");
						completeCK.setValue(false);
						Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),false);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "����ʧ��!"+jsonData.info);
						}else if(jsonData.info==-1){
							Msg.info("error", "��ǰ������תΪ��ʽ���ת�Ƶ�,��ֹȡ�����!");
						}else if (jsonData.info==-99) {
							Msg.info("error", "����ʧ��!");
						}else if (jsonData.info==-11) {
							Msg.info("error", "�����,��ֹȡ�����!");
						}else{
							Msg.info("error", "����ʧ��!"+jsonData.info);
						}
					}
				},
				scope : this
			});
		}
	}
});

function delReq()
{
	if(req==null || req==""){
		Msg.info("warning","��ѡ��Ҫɾ��������!");
		return;
	}

	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ��ɾ����',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no')	{return;}
			else
			{
				Ext.Ajax.request({
					url:DictUrl+"inrequestaction.csp?actiontype=Delete",
					method:'POST',
					params:{req:req},
					success:function(response,opts){
						var jsonData=Ext.util.JSON.decode(response.responseText);
						if(jsonData.success=='true'){
							Msg.info("success","ɾ���ɹ�!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","����������ɣ�������ɾ����");
							}else{
								Msg.info("error","ɾ��ʧ��:"+jsonData.info);
							}
						}
					},
					failure:function(response,opts){
						Msg.info("error","server-side failure with status code��"+response.status);
					}
				});
			}
		}
	});

}

var del = new Ext.Toolbar.Button({
	text:'ɾ��',
	id:'delete',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		delReq();
	}
});

var printBT = new Ext.Toolbar.Button({
	text : '��ӡ',
	tooltip : '��ӡ����',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(req==null || req==""){
			Msg.info("warning","û����Ҫ��ӡ������!");
			return;
		}
		if((gParam[6]=="N")&&(Ext.getCmp('completeCK').getValue()==false)){
			Msg.info('warning','�������ӡδ��ɵ�����!');
			return;
		}
		PrintINRequest(req);
	}
});

//ɾ��ת��������ϸ
function DeleteDetail(){
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ���������');
		return;
	}

	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}else{
		var record = InRequestGridDs.getAt(cell[0]);
		var reqItm = record.get("rowid");
		if(reqItm!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcstm.inrequestaction.csp?actiontype=del&reqItm='+reqItm,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "��ϸIdΪ�գ�ɾ��ʧ��!");
										return false;
									}else if(jsonData.info==-2){
										Msg.info("error", "������ɾ��!");
										return false;
									}else{
										Msg.info("error", "ɾ��ʧ��!");
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
		}else{
			InRequestGridDs.remove(record);
			InRequestGrid.getView().refresh();
		}

		if (InRequestGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//��ʼ��Ĭ��������
InRequestGridCm.defaultSortable = true;

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	height : 30,
	width : 70,
	tooltip:'�������',
	iconCls:'page_add',
	handler:function(){
		var toLoc = Ext.getCmp('LocField').getValue();
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "��ѡ��������!");
			return ;
		}
		var frLoc = Ext.getCmp('supplyLocField').getValue();
		if((frLoc=="")||(frLoc==null)){
			Msg.info("warning", "��ѡ�񹩸�����!");
			return ;
		}
		if (toLoc == frLoc) {
			Msg.info("warning", "�����ź͹�Ӧ���Ų�����ͬ!");
			return;
		}
		//����
		var scg = Ext.getCmp('groupField').getValue();
		if(Ext.isEmpty(scg) && gParam[5]!='Y'){
			Msg.info("warning", "��ѡ������!");
			return false;
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	height : 30,
	width : 70,
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
})

var GridColSetBT = new Ext.Toolbar.Button({
	text:'������',
    tooltip:'������',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		GridColSet(InRequestGrid,"DHCSTINREQM");
	}
});

//���
InRequestGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	id:'reqItmEditGrid',
	title:'��������',
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	listeners:{
		beforeedit:function(e){
			if(Ext.getCmp("completeCK").getValue()){
				return false;
			}
		},
		afteredit:function(e){
			if(e.field=='qty'){
				e.record.set('spAmt',accMul(e.value,e.record.get('sp')));
				var UseLocLimitQty=InRequestParamObj.UseLocLimitQty;
				if(UseLocLimitQty=="Y"){
					var ReqLocid=Ext.getCmp("LocField").getValue();
					var inci=e.record.get('inci');
					var Uomid=e.record.get('uom');
					var Qty=e.record.get('qty');
					var LimitQtyStr=tkMakeServerCall("web.DHCSTM.LocLimitAmt","GetLimitQty",ReqLocid,inci,Uomid);
					var OnceReqQty=Number(LimitQtyStr.split("^")[0]);
					var AddReqQty=Number(LimitQtyStr.split("^")[1]);
					var AllReqQty=Number(LimitQtyStr.split("^")[2]);
					if ((OnceReqQty>0)&&(Qty>OnceReqQty)){
						Msg.info("warning","��������������������"+OnceReqQty);
						return false;
					}
					if ((AllReqQty>0)&&(AddReqQty>AllReqQty)){
						Msg.info("warning","��ʱ���������������������"+AllReqQty);
						return false;
					}
				}
			}
		}
	}
});

//zdm,�����Ҽ�ɾ����ϸ����
InRequestGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	e.preventDefault();
	grid.getSelectionModel().select(rowindex,1);
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'ɾ��',handler:DeleteDetail}]
});

var formPanel = new Ext.ux.FormPanel({
	title:gHVInRequest?'���������Ƶ�(��ֵ)':'���������Ƶ�',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT,'-',findTemplate,'-',ReqByTemplate],
	items : [{
		layout : 'column',
		xtype : 'fieldset',
		title : '������Ϣ',
		style:'padding:5px 0px 0px 5px',
		defaults:{xtype:'fieldset',border:false},
		items : [{
			columnWidth:0.3,
			items : [LocField,supplyLocField,groupField,reqType]
		},{
			columnWidth : 0.25,
			items : [requestNnmber,dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			items : [remark]
		},{
			columnWidth : 0.2,
			items : [completeCK,templateFlag,ExpressFlag]
		}]
	}]

});

//�鿴���������Ƿ����޸�
function isDataChanged()
{
	var changed=false;
	var count1= InRequestGrid.getStore().getCount();
	//�����������Ƿ����޸�
	//�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;
	}
	if (changed) return changed;
	//����ϸ�����Ƿ����޸�
	var count= InRequestGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InRequestGridDs.getAt(index);
				//���������ݷ�?���??�ִ�����??��?
		if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel, InRequestGrid]
	});

	RefreshGridColSet(InRequestGrid,"DHCSTINREQM");   //�����Զ�������������������
	//ҳ����ת��ʱ ȷ����ɰ�ť�Ŀ���
	if(abConsumeReq>0){
		complete.enable();
		Select(abConsumeReq);
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:abConsumeReq}});
	};

});

 ///���ÿɱ༭�����disabled����
function setEditDisable(){
	Ext.getCmp('LocField').setDisabled(true);
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('supplyLocField').setDisabled(true);
}
 ///�ſ��ɱ༭�����disabled����
function setEditEnable(){
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('supplyLocField').setDisabled(false);
}



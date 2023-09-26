// ����:�¶�����ƻ��Ƶ�
// ��д����:2012-07-19

var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gHospId=session['LOGON.HOSPID'];
var URL = 'dhcstm.inrequestaction.csp';
var strParam = "";
var req = "";			//����ȫ�ֱ���:����rowid
var statu = "N";		//����ȫ�ֱ���:���״̬(Ĭ��״̬:N)
var byTemplate=false;	//����ģ���Ƶ���־
var opaId=opaId	//��������Id
var requestNumber = new Ext.form.TextField({
	id:'requestNumber',
	fieldLabel:'����ƻ�����',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '���첿��',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '���첿��...',
	groupId:gGroupId,
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
	listeners:{
		'select':function(cb){
			temStore.setBaseParam("locId",Ext.getCmp('LocField').getValue());
			temStore.removeAll();
			temStore.reload();
		}
	}
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
	params:{LocId:'LocField'}
});

var remark = new Ext.form.TextField({
	id:'remark',
	fieldLabel:'��ע',
	anchor:'100%',
	selectOnFocus:true
});

var temName = new Ext.form.TextField({
	id:'temName',
	fieldLabel:'ģ������',
	anchor:'100%',
	selectOnFocus:true
});

var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	fieldLabel:'���',
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
	fieldLabel:'ģ���־',
	anchor:'100%',
	allowBlank:true
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
	valueNotFoundText : '',
	listeners:({
		'beforequery':function(){
			var cell = InRequestGrid.getSelectionModel().getSelectedCell();
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
	data:[['O','���쵥'],['C','����ƻ�']]
});
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'��������',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'��������...',
	triggerAction:'all',
	anchor:'90%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local',
	disabled:true,
	disabled:true
});
Ext.getCmp('reqType').setValue('C');

var find = new Ext.Toolbar.Button({
	text:'���쵥״̬��ѯ',
	tooltip:'���쵥״̬��ѯ',
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
						if(IsSplit()=="Y"){
							findReqSplit(refresh);
						}else{
							findReq(refresh);
						}
					}
				}
			});
		}else{
			if(IsSplit()=="Y"){
				findReqSplit(refresh);
			}else{
				findReq(refresh);
			}
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

function clearReq(){
	req="";
	InRequestGridDs.removeAll();
	remark.setValue("");
	requestNumber.setValue("");
	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	Ext.getCmp('template').setValue(false);
	Ext.getCmp('template').setDisabled(false);
	timeField.setValue("");
	userField.setValue("");
	reqType.setValue("C");
	Ext.getCmp('save').enable();
	add.setDisabled(false);
}

function changeBgColor(row, color) {
	InRequestGrid.getView().getRow(row).style.backgroundColor = color;
}

function getDrugList2(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return false;
	}
	Ext.each(records,function(record,index,allItms){
		var inciDr = record.get("InciDr");
		var findIndex = InRequestGridDs.findExact('inci',inciDr);
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		// ѡ����
		var row = cell[0];
		var rowData = InRequestGridDs.getAt(row);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("provloc",record.get("provLoc"));
		rowData.set("provlocid",record.get("provLocid"));
		rowData.set("HVFlag",record.get("HVFlag"));
		rowData.set("ZeroStkFlag",record.get("ZeroStkFlag"));
		//��Ӧ��id^��Ӧ������^����id^��������^������id^����������^��ⵥλid^��ⵥλ^����^�ۼ�^�깺���ҿ����^�������^�������^ͨ����^��Ʒ��^����^���
		//ȡ����������Ϣ
		var locId = Ext.getCmp('LocField').getValue();
		if(locId!=""){
			var inci=record.get("InciDr");
			var uom="";
			var params=gGroupId+"^"+locId+"^"+UserId+"^"+uom;
			GetItmInfo(inci,params,rowData)
		}else{
			Msg.info("error","��ѡ�����!");
		}
 		addNewRow();
    })		
    var colIndex=InRequestGrid.getColumnModel().getIndexById('colQty');
    if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
    var count=InRequestGridDs.getCount()
        var row
        for(i=0;1<count;i++){
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
		rowData.set("uom", UomId);
		rowData.set("uomDesc", Uom);
		rowData.set("sp", data[5]);
		rowData.set("rp", data[4]);
		rowData.set("spAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('sp'))));
		rowData.set("rpAmt",accMul(Number(rowData.get('qty')),Number(rowData.get('rp'))));
		rowData.set("repLev", data[10]);
	}
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var toloc=Ext.getCmp('LocField').getValue()
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,getDrugList2,toloc,"","","","C","N","Y");
	}
}

function addNewRow() {
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true)){
		Msg.info('warning','��ǰ����ƻ��������');
		return;
	}
	var rowCount =InRequestGrid.getStore().getCount();
	if(rowCount==0 || InRequestGridDs.getAt(rowCount - 1).get("inci")!=''){
		var defaData = {};
		var NewRecord = CreateRecordInstance(InRequestGridDs.fields,{});		
		InRequestGridDs.add(NewRecord);
	}
	var colIndex=GetColIndex(InRequestGrid,'desc');
	if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
		InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, colIndex);
	}
}

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
		var params=gGroupId+"^"+LocId+"^"+UserId+"^"+uom;
		GetItmInfo(inci,params,record);
	});

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
		{name:'manf'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'generic'},
		{name:'drugForm'},
		{name:'remark'},
		{name:'provloc'},
		{name:'HVFlag'},
		{name:'ZeroStkFlag'},
		{name:'SpecDesc'},
		{name:'provlocid'}
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
						var stkGrp='';
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
		format:'0',
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
						var repLev = InRequestGridDs.getAt(cell[0]).get('repLev');
						if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
						if (repLev!=""&repLev!=null&repLev!=0){
							Msg.info("error", "����������Ҫ�����������������!");
							return;
						}
						else{
							//var colIndex=InRequestGrid.getColumnModel().getIndexById('colRemark');
							var colIndex=InRequestGrid.getColumnModel().getIndexById('colDesc');
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
							InRequestGrid.startEditing(InRequestGridDs.getCount() - 1,colIndex ); }
						}		
					}
				}
			}
		})
	},{
		header:"���۵���",
		dataIndex:'sp',
		xtype:'numbercolumn',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"�ۼ۽��",
		dataIndex:'spAmt',
		xtype:'numbercolumn',
		width:100,
		align:'right',
		sortable:true,
		hidden:true
	},{
		header:'����',
		dataIndex:'rp',
		xtype:'numbercolumn',
		width:100,
		aligh:'right'
	},{
		header:'���۽��',
		dataIndex:'rpAmt',
		xtype:'numbercolumn',
		width:100,
		aligh:'right',
		hidden:true
	},{
		header:"��λ",
		dataIndex:'uom',
		id:'colUom',
		width:100,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(CTUom),
		renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc")
	},{
		header:"��ע",
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
							
							var colIndex=InRequestGrid.getColumnModel().getIndexById('colQty');
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
								InRequestGrid.startEditing(InRequestGridDs.getCount() - 1,colIndex );
							}
						}else{
							//����һ��
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header:"��Ӧ�ֿ�",
		dataIndex:'provloc',
		width:150,
		align:'left',
		renderer:function(v,cellmeta){
		return '<span style="color:red;font-weight:bold">'+v+'</span>';
		},
		sortable:true
	},{
		header:"��Ӧ�ֿ�id",
		dataIndex:'provlocid',
		width:60,
		align:'left',
		hidden:true
	},{
		header:"��ֵ��־",
		dataIndex:'HVFlag',
		width:80,
		align:'center',
		renderer :function(v){
			if(v=="Y"){return "��"}
			else{return "��"}
		},
		sortable:true
	},{
		header:"�����־",
		dataIndex:'ZeroStkFlag',
		width:80,
		align:'center',
		renderer :function(v){
			if(v=="Y"){return "��"}
			else{return "��"}
		},
		sortable:true
	},{
		header:"������",
		dataIndex:'SpecDesc',
		width:100,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
	}
]);

var add = new Ext.Toolbar.Button({
	text:'�½�',
	id:'newReq',
	iconCls:'page_add',
	tooltip:'�½�����ƻ���',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
					}
				}
			})
		} else {
			clearReq();
		}
	}
});

function saveReq(tempFlag,comp)
{  
	if(InRequestGrid.activeEditor != null){
		InRequestGrid.activeEditor.completeEdit();
	}
	
	if (tempFlag){
		var remark=Ext.getCmp('remark').getValue();
		var xx=remark.trim();
		if ((xx=="")||(xx==null)){
			Msg.info('error',"����<��ע>��дģ�����ơ�");
			return;
		}
	}
	
	//������
	var toLoc = Ext.getCmp('LocField').getValue(); 
	if((toLoc=="")||(toLoc==null)){
		Msg.info("error", "��ѡ�����첿��!");
		return false;
	}
	/* ������=��Ӧ����  */
	var frLoc =toLoc;
	//��½�û�
	var user = UserId;
	var scg="";  /* ����="" */
	
	//��ɱ�־(��ʱΪ��)
	var status =Ext.getCmp('reqType').getValue(); 
	//��ע
	var remark = Ext.getCmp('remark').getValue(); 
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	//������Ϣ�ַ���
	var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark+"^"+(tempFlag?'Y':'')+"^^^"+opaId;
	
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
			var provloc=rec.data['provloc'];
			var provlocid=rec.data['provlocid'];
			if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}
			if((inc!="")&&(inc!=null)){
				if(qty==0){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"��������������Ϊ�ջ�0!");
					return;
				}
				if(qty<0){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"��������������С��0!");
					return;
				}
				if(provloc==""||provloc==null){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"�й�Ӧ�ֿ�Ϊ��!");
					return;
				}
				var Creqparams=GetAppPropValue("DHCSTINREQM",provlocid);
				if((repLev!=""&repLev!=null&repLev!=0)&&(Creqparams.IfAllowReqBQtyUsed=="Y")){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"�����������������������������!");
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
	if(comp=="Y"){
	if ( (req=='')&& (data=="")) {return false;};	
	if(!IsFormChanged(formPanel) && data==""){return false;};	
	}
	else
	{
	if ( (req=='')&& (data=="")) {Msg.info("error", "û��������Ҫ����!");return false;};	
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "û��������Ҫ����!");return false;};	
	}
	Ext.Ajax.request({
		url : 'dhcstm.inrequestaction.csp?actiontype=save',
		params:{req:req,reqInfo:reqInfo,data:data},
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "����ɹ�!");
				req = jsonData.info;
				refresh(req);
				temStore.load()
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
		var templateFlag=Ext.getCmp('template').getValue();
		saveReq(templateFlag);
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
		findReqTemplateWin(Ext.getCmp('reqType').getValue(),"");
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
		xReqByTemplateWin(Ext.getCmp('reqType').getValue(),"");
	}
});

function refresh(req){
	Select(req);
	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
}

function importReqTem(req){
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
					//Ext.getCmp('userField').setValue(dataArr[14]); 
					Ext.getCmp('reqType').setValue(dataArr[5]);
				}
			}
		}
	});
	
	InRequestGridDs.removeAll();
	InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
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
					Ext.getCmp('requestNumber').setValue(dataArr[1]);
					addComboData(Ext.getCmp('LocField').getStore(),dataArr[2],dataArr[13]);
					Ext.getCmp('LocField').setValue(dataArr[2]);
					Ext.getCmp('dateField').setValue(dataArr[6]);
					Ext.getCmp('timeField').setValue(dataArr[9]);
					Ext.getCmp('userField').setValue(dataArr[14]);
					Ext.getCmp('template').setValue(dataArr[18]=='Y'?true:false);
					Ext.getCmp('reqType').setValue(dataArr[17]);
					Ext.getCmp("completeCK").setValue(dataArr[11]=="Y");
					Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),(dataArr[11]=="Y"));
					Ext.getCmp('remark').setValue(handleMemo(dataArr[10],xMemoDelim()));
					SetFormOriginal(formPanel);
					Ext.getCmp('template').setDisabled(true);
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
		if (req=='') 
		{
			Msg.info('warning','û���κε��ݣ�');
			return ;
		}
		var templateFlag=Ext.getCmp('template').getValue();
		//ȷ�����ʱ�򱣴�
		saveReq(templateFlag,"Y");
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=SetComp',
				params : {req : req},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȷ����ɳɹ�!");
						completeCK.setValue(true);
						Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),true);
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
		if (req=='') 
		{
			Msg.info('warning','û���κ�����ƻ�����');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=CancelComp',
				params : {req : req},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ����ɳɹ�!");
						completeCK.setValue(false);
						Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),false);
					}else{
						if(jsonData.info==-21){
							Msg.info("error", "�ѻ����ύ����ƻ�,��ֹȡ�����!");
						}else if(jsonData.info==-1){
							Msg.info("error", "��ǰ������תΪ��ʽ���ת�Ƶ�,��ֹȡ�����!");
						}else if (jsonData.info==-11) {
							Msg.info("error", "��ǰ���������,��ֹȡ�����!");
						}else if (jsonData.info==-99) {
							Msg.info("error", "����ʧ��!");
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
var SplitPlan = new Ext.Toolbar.Button({
	text:'��ּƻ���',
	tooltip:'��ּƻ���',
	id:'SplitPlan',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	//disabled:true,
	handler:function(){
		if (req=='') 
		{
			Msg.info('warning','û���κ�����ƻ�����');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="N"){
		    Msg.info('warning','�ƻ���δ��ɣ�');
		    return ;
		}else if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.inrequestaction.csp?actiontype=SplitPlan',
				params : {req : req},
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "�ƻ�����ֳɹ�!");
					}else{
						if (jsonData.info==-99) {
							Msg.info("error", "�ƻ����Ѿ����!");
						}else{
							Msg.info("error", "�ƻ������ʧ��!");
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
		Msg.info("warning","��ѡ��Ҫɾ���ĵ�!");
		return;
	}
	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ��ɾ����',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='yes'){
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
								Msg.info("warning","������ƻ�������ɣ�������ɾ����");
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
	tooltip : '��ӡ����ƻ���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(req==null || req==""){
			Msg.info("warning","û����Ҫ��ӡ������ƻ���!");
			return;
		}
		if((gParam[6]=="N")&&(Ext.getCmp('completeCK').getValue()==false)){
			Msg.info('warning','�������ӡδ��ɵ�����!');
			return;
		}
		PrintINRequest(req);
	}
});

//ɾ��ת������ƻ���ϸ
function DeleteDetail(){
	if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ����ƻ��������');
		return;
	}
	
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}
	else{
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
	}
}

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'�������',
	iconCls:'page_add',
	height : 30,
	width : 70,
	handler:function(){
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "��ѡ�����첿��!");
			return ;
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'',
	iconCls:'page_delete',
	height : 30,
	width : 70,
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
var HelpBT = new Ext.ux.Button({
	text:'������ʹ��˵����F1)',
	tooltip:'������ʹ��˵����F1)',
	iconCls:'page_gear',
	key:Ext.EventObject.F1,
	ctrl:false,
	alt:false,
	handler:function(){
		window.onhelp = function(){return false;}
		Msg.info("warning","������");
	}
});
//���
InRequestGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	id:'InRequestGrid',
	title:'����ƻ���',
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	listeners : {
		beforeedit : function(e){
			if(Ext.getCmp('completeCK').getValue()==true){
				return false;
			}
		},
		afteredit : function(e){
			if(e.field == 'qty'){
				e.record.set("spAmt",accMul(e.value, e.record.get('sp')));
				e.record.set("rpAmt",accMul(e.value, e.record.get('rp')));
			}
		}
	}
});

//zdm,�����Ҽ�ɾ����ϸ����
InRequestGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	e.preventDefault();
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'ɾ��',handler:DeleteDetail}]
});

var formPanel = new Ext.form.FormPanel({
	labelAlign : 'right',
	title:'����ƻ��Ƶ�',
	region:'center',
	frame : true,
	bodyStyle : 'padding:5px;',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT,'-',findTemplate,'-',ReqByTemplate],
	items : [{
		layout : 'column',
		xtype : 'fieldset',
		title : '����ƻ���Ϣ',
		style:'padding:5px 0px 0px 0px',
		defaults:{border:false},
		items : [{
			columnWidth:0.3,
			xtype:'fieldset',
			items : [LocField,reqType,requestNumber]
		},{
			columnWidth : 0.25,
			xtype:'fieldset',
			items : [dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			xtype:'fieldset',
			items : [remark]
		},{
			columnWidth : 0.2,
			xtype:'fieldset',
			items : [completeCK,templateFlag]
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
				//���������ݷ����仯ʱִ����������
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

var temCm=new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header:'req',
		dataIndex:'req',
		hidden:true
	},{
		header:"ģ������(��ע)",
		dataIndex:'Remark',
		width:150
	}
]);
var temStore=new Ext.data.Store({
		url:URL+'?actiontype=GetTemplate',
		autoLoad:true,
		baseParams:{
					locId:Ext.getCmp('LocField').getValue(),
					reqType:Ext.getCmp('reqType').getValue(),
					HVflag:''
				},
		reader:new Ext.data.JsonReader({
			totalProperty:'result',
			root:'rows',
			fields:['req','reqNo','Date','Time','User','Remark','completed']
		})
	});
var temGrid=new Ext.grid.GridPanel({
	title:'ģ��',
	region:'east',
	width:180,
	store:temStore,
	cm:temCm,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	deferRowRender : false,
	listeners:{
		'rowdblclick':function(Grid ,rowIndex ,e){
			var record=Grid.getStore().getAt(rowIndex);
			var req=record.get("req");
			importReqTem(req);
		}
	}
});	
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var panel=new Ext.Panel({
		region:'north',
		height:210,
		layout:'border',
		items:[formPanel,temGrid]
	})
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[panel,InRequestGrid]
	});
	
	RefreshGridColSet(InRequestGrid,"DHCSTINREQM");   //�����Զ�������������������
});
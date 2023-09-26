// ����:��������
// ��д����:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var abConsumeReq = reqByabConsume;		//ҳ����ת����
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.inrequestaction.csp';
var strParam = "";
var req = "";		//����ȫ�ֱ���:����rowid
var statu = "N";	//����ȫ�ֱ���:���״̬(Ĭ��״̬:N)
var defaReqType="O";

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
	listeners:{
		'select':function(cb){
			var requestLoc=cb.getValue();
			var provLoc=Ext.getCmp('supplyLocField').getValue();
			Ext.getCmp("groupField").setFilterByLoc(requestLoc,provLoc);			
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

supplyLocField.on("select",function(cmb,rec,id ){
    add.disable();
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
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '������...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function(){
			var cell = InRequestGrid.getSelectionModel().getSelectedCell();
			var record = InRequestGrid.getStore().getAt(cell[0]);
			var IncRowid = record.get("inci");	
			var desc=this.getRawValue();
			this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
			this.store.setBaseParam('SpecItmRowId',IncRowid);
			this.store.setBaseParam('desc',desc);
			this.store.load({params:{start:0,limit:this.pageSize}});
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
var showoffen = new Ext.Toolbar.Button({
	id:'showoffen',
	text:'����',
    tooltip:'����',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	
	handler:function(){
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
	     var user = UserId;
      	//����
	      var scg = Ext.getCmp('groupField').getValue(); 

	    //��ɱ�־(��ʱΪ��)
	     var status =Ext.getCmp('reqType').getValue(); 
	     //��ע
      	 var remark = Ext.getCmp('remark').getValue(); 
	     var ss=remark.replace(/\r\n/g,xMemoDelim());
	     var remark=ss;
	     
	     //������Ϣ�ַ���
	     var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark;
	     ShowEjPhaOrderWindow(toLoc,user,frLoc,reqInfo,refresh);
	}
});
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
	supplyLocField.setValue("");
	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");
	reqType.setValue("");
	reqType.setValue(defaReqType)  //���ó�ʼ
	Ext.getCmp('save').enable();
	add.setDisabled(false);
	SetLogInDept(LocField.getStore(),'LocField');
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
		PUOMID=UomId;
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
		//��������
		var frLoc = Ext.getCmp('supplyLocField').getValue(); 
		//������
	    var toLoc = Ext.getCmp('LocField').getValue(); 
		GetPhaOrderWindow(item, group, App_StkTypeCode, frLoc, "N", "0", "",getDrugList2,toLoc,"","","","O","N","Y");
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
		{name:'generic'},
		{name:'drugForm'},
		{name:'remark'},
		{name:'stkQty'},
		{name:'inciRemarks'} //,mapping:'remarks'}
	]),
    remoteSort:false
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
        header:"�������",
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
							var colIndex=GetColIndex(InRequestGrid,"qty");
							if (!InRequestGrid.getColumnModel().isHidden(colIndex)){
								var count=InRequestGridDs.getCount()
								var row
								for(i=0;1<count;i++){
									if(Ext.isEmpty(InRequestGridDs.getAt(i).get('qty'))){row=i;break}
								}
								if(Ext.isEmpty(InRequestGridDs.getAt(i).get('inci'))){colIndex=GetColIndex(InRequestGrid,"desc")}
								InRequestGrid.getSelectionModel().select(row, colIndex);
								startedit.defer(20,this,[row, colIndex])   /////��ʱ������   ��ֹ��grid���¼���ͻ����startEditingʧ�ܵ�����
							}else{
								addNewRow();
							}
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
        header:"��λ",
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
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

function saveReq(){  
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
	
	//������Ϣ�ַ���
	var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark;
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
			if (repLev!=""&repLev!=null&repLev!=0){repLev=qty%repLev;}			
			if((inc!="")&&(inc!=null)){
				if(qty==0){
					Msg.info("warning","��"+(InRequestGridDs.indexOf(rec)+1)+"��������������Ϊ�ջ�0!");
					return;
				}
				if(repLev!=""&repLev!=null&repLev!=0){
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
	
	if ( (req=='')&& (data=="")) {Msg.info("error", "û��������Ҫ����!");return false;};	
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "û��������Ҫ����!");return false;};
	
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
		saveReq();
	}
});

function refresh(req){
	Select(req);
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
	id:'reqItmEditGrid',
	title:'��������',
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	height:476,
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
				e.record.set('spAmt',accMul(e.value,e.record.get('sp')))
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

var formPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	labelAlign : 'right',
	title:'���������Ƶ�',
	frame : true,
	bodyStyle : 'padding:5px;',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT,'-',showoffen],
	//layout:'fit',
	items : [{
		layout : 'column',			
		xtype : 'fieldset',
		title : '������Ϣ',
		style:'padding:5px 0px 0px 0px',
		defaults:{border:false},
		items : [{
			columnWidth:0.3,
			xtype:'fieldset',
			items : [LocField,supplyLocField,groupField,reqType]
		},{
			columnWidth : 0.25,
			xtype:'fieldset',
			items : [requestNnmber,dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			xtype:'fieldset',
			items : [remark]
		},{
			columnWidth : 0.2,
			xtype:'fieldset',
			items : [completeCK]
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
	};
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
		collapsible:true,
		split: true,
		items:[{
			region:'north',
			layout:'fit',
			height:230,
			items:[formPanel]
		},{
			region:'center',
			layout:'fit',
			items:[InRequestGrid]
		}],
		renderTo:'mainPanel',
		
		listeners:{'afterrender':function(){
			INIT_LOAD=true;
		}}
	});	
	
	RefreshGridColSet(InRequestGrid,"DHCSTINREQM");   //�����Զ�������������������
	//ҳ����ת��ʱ ȷ����ɰ�ť�Ŀ���
	if(abConsumeReq>0){
		complete.enable();
		Select(abConsumeReq);
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:abConsumeReq}});
	};
//	Ext.getCmp('clear').handler(); ҳ����ת����clear
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



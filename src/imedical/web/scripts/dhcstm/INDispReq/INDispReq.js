// ����:��������
// ��д����:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var gHospId = session['LOGON.HOSPID'];
var URL = 'dhcstm.indispreqaction.csp';

//�������ֵ��object
var InDispReqParamObj = GetAppPropValue('DHCINDISPREQM');

var strParam = "";
var INDispReqRowId = ""; //����ȫ�ֱ���:����rowid
var statu = "N"; //����ȫ�ֱ���:���״̬(Ĭ��״̬:N)

var dsrqNo = new Ext.form.TextField({
	id:'dsrqNo',
	fieldLabel:'���쵥��',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
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
	fieldLabel:'����',
	anchor:'90%',
	value:new Date(),
	disabled:true
});

var timeField=new Ext.form.TextField({
	id:'timeField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'ʱ��'
});
var userField=new Ext.form.TextField({
	id:'userField',
	disabled:true,
	anchor:'90%',
	fieldLabel:'������'
});

var sublocField = new Ext.ux.LocComboBox({
	id:'sublocField',
	fieldLabel:'����',
	anchor:'90%',
	listWidth:210,
	emptyText:'����...',
	groupId:gGroupId,
	stkGrpId : 'groupField'
});

sublocField.on("select",function(cmb,rec,id ){
	add.disable();
});

var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'��ע',
	anchor:'90%',
	height:100,
	selectOnFocus:true,
	maxLength:40
});

var statusCombo=new Ext.form.ComboBox({
	fieldLabel:'״̬',
	id:'reqStatus',
	anchor:'90%',
	mode:'local',
	disabled:true,
	store:new Ext.data.ArrayStore({
		id:0,
		fields: ['code','description'],
		data:[['C','�Ѵ���'],['O','������'],['X','������'],['R','�Ѿܾ�']]
	}),
	valueField:'code',
	displayField:'description',
	triggerAction: 'all',
	forceSelection : true
});

var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	boxLabel : '���',
	anchor:'90%',
	disabled:true,
	allowBlank:true,
	listeners : {
		check : function(checkbox,checked){
			Ext.getCmp("CancelDetailBT").setDisabled(!checked);
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

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//find.btnEl.mask() 
		var subLoc=Ext.getCmp('sublocField').getValue();
		if ((subLoc==null)||(subLoc=='')){
			Msg.info('warning','��ѡ�����!');
			return;
		}
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						findDispReq(subLoc,refresh);
					}
				}
			});
		}else{
			findDispReq(subLoc,refresh);
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
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearReq();SetFormOriginal(formPanel);}
				}
			})
		}
		else{
			clearReq(); 
			SetFormOriginal(formPanel);
		}
	}
});

function clearReq()
{
	INDispReqRowId="";  //��������ֵ
	INDispReqGridDs.removeAll();
	remark.setValue("");
	dsrqNo.setValue("");  //groupField
	//sublocField.setValue("");
	//sublocField.setRawValue("");
	//dateField.setValue(new Date());
	dateField.setValue('');
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");
	//reqType.setValue("");
	byUser.setValue(true);
	byUserGrp.setValue(false);
	GrpList.setValue('');
	statusCombo.setValue('');
	
	Ext.getCmp('save').enable();
	add.setDisabled(false);
	//SetLogInDept(LocField.getStore(),'LocField');

	groupField.store.load();
	setEditEnable();
}

function getDrugLists(records) {
	if (records == null || records == "") {
		return false;
	}
	Ext.each(records,function(item, index, allItems){
		getDrugList2(item);
	});
	
	var count = INDispReqGridDs.getCount()
	var row;
	var col=GetColIndex(INDispReqGrid,'qty');
	for(i=0; i<count; i++){
		if(Ext.isEmpty(INDispReqGridDs.getAt(i).get('qty'))){
			row = i;
			break;
		}
	}
	INDispReqGrid.startEditing(row, col);
}

function getDrugList2(record) {
//	if (record == null || record == "") {
//		return false;
//	}
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	// ѡ����
	var row = cell[0];
	var inciDr=record.get("InciDr");
	var findIndex=INDispReqGridDs.findExact('inci',inciDr,0);
	if(findIndex>=0 && findIndex!=row){
		Msg.info("warning",record.get("InciDesc")+"�Ѵ����ڵ�"+(findIndex+1)+"��");
		return;
	}
	var rowData = INDispReqGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	
	var locId = Ext.getCmp('sublocField').getValue();
	//var locId=session['LOGON.CTLOCID'] ;
	if(locId!=""){
		var url = 'dhcstm.indispreqaction.csp?actiontype=GetItmInfo&IncId='+ record.get("InciDr")+'&LocId='+locId;
		var result = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(result.replace(/\r/g,"").replace(/\n/g,""));
		if (jsonData.success == 'true') {
			var data=jsonData.info.split("^");
			var ManfId = data[2];
			var Manf = data[3];
			rowData.set("manf", data[3]);    //������
					
			var UomId=data[6];
			var Uom=data[7];
			addComboData(ItmUomStore,data[6],data[7]);
			rowData.set("uom", UomId);    //��λId
			rowData.set("uomDesc", Uom);    //��λ����
			rowData.set("sp", data[9]);
			rowData.set("spec", data[11]);
			rowData.set("BUomId",data[12]);
			rowData.set("ConFac",data[13]);
		}
		var lastIndex=INDispReqGridDs.getCount()-1;
		if(INDispReqGridDs.getAt(lastIndex).get('inci')!=""){
			addNewRow();
		}else{
			var col=GetColIndex(INDispReqGrid,'desc');
			INDispReqGrid.startEditing(lastIndex,col);
		}
	}else{
		Msg.info("error","��ѡ�����!");
	}
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var LocId = Ext.getCmp("sublocField").getValue();
		//ȡ��֧�����(defloc)
		LocId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",LocId);
		GetPhaOrderWindow(item, group, App_StkTypeCode, LocId, "N",
			"1", gHospId,getDrugLists,"","",
			"","","","","Y");
	}
}

function addNewRow() {
	//alert(INDispReqRowId);
	//alert(Ext.getCmp('completeCK').getValue());	
	if ((INDispReqRowId!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ���쵥���ύ');
		return;
	}
	var col=GetColIndex(INDispReqGrid,'desc');
	// �ж��Ƿ��Ѿ��������
	var rowCount = INDispReqGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INDispReqGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			INDispReqGrid.startEditing(INDispReqGridDs.getCount() - 1, col);
			return;
		}
	}
	
	var NewRecord = CreateRecordInstance(INDispReqGridDs.fields);
	INDispReqGridDs.add(NewRecord);
	INDispReqGrid.startEditing(INDispReqGridDs.getCount() - 1, col);
	
	setEditDisable();
}

//��������Դ
var INDispReqGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=SelDispReqItm',method:'GET'});
var INDispReqGridDs = new Ext.data.Store({
	proxy:INDispReqGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
		}, [
		{name:'rowid',mapping:'dsrqi'},
		{name:'inci'},
		{name:'code',mapping:'inciCode'},
		{name:'desc',mapping:'inciDesc'},
		{name:'spec'},
		{name:'manf'},		
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'remark'},
		"BUomId","ConFac","moveStatus"
	]),
	remoteSort:false
});

var uGroupList=new Ext.data.Store({
	url:"dhcstm.sublocusergroupaction.csp?actiontype=getGrpListByUser",
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:"rows"	,
		idProperty:'RowId'
	},['RowId','Description']),
	listeners:{
		'beforeload':function(ds){
			ds.setBaseParam('user',UserId);
			ds.setBaseParam('subloc',Ext.getCmp('sublocField').getValue());
			ds.setBaseParam('reqFlag',1);
		},
		'load':function(ds){
			if (ds.getCount()==1){
			var rec=ds.getAt(0);
			var grp=rec.get('RowId');
			if (GrpList){
				GrpList.setValue(grp);}
			}
		}
	}
});

var GrpList = new Ext.ux.ComboBox({
	fieldLabel:'רҵ��',
	id:'UserGrp',
	anchor : '90%',
	disabled:true,
	store:uGroupList,
	valueField:'RowId',
	displayField:'Description'
});

var byUserGrp=new Ext.form.Radio({
	name:'dispMode',
	id:'byUserGrpMode',
	boxLabel:'רҵ������',
	inputValue:0,
	listeners:{
		'check':function(b){
			if (b.getValue()==1) {
				Ext.getCmp('UserGrp').setDisabled(false);
				Ext.getCmp('UserGrp').getStore().load();
			}else{
				Ext.getCmp('UserGrp').setValue('');
				Ext.getCmp('UserGrp').setDisabled(true);
			}
		}
	}
})

var byUser=new Ext.form.Radio({
	name:'dispMode',
	id:'byUserMode',
	boxLabel:'��������',
	inputValue:1,
	checked:true
})

var selectDSRQMode=new Ext.form.RadioGroup
({
	id:'dsMode',
	fieldLabel:'���췽ʽ',
	items:[byUserGrp,byUser]
})

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
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	var record = INDispReqGrid.getStore().getAt(cell[0]);
	var InciDr = record.get("inci");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:InciDr}});
});

CTUom.on('select', function(combo) {
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	var rowData = INDispReqGrid.getStore().getAt(cell[0]);
	var seluom = combo.getValue();		//Ŀǰѡ��ĵ�λid
	var BUom = rowData.get("BUomId");
	var qty = rowData.get('qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var sp = rowData.get("sp"); //ԭ�ۼ�
	var buom=rowData.get("BUomId");
	var confac=rowData.get("ConFac");
	var uom=rowData.get("uom");
	if(seluom!=uom){
		if(seluom!=buom){     //ԭ��λ�ǻ�����λ��Ŀǰѡ�������ⵥλ
			rowData.set("sp", Number(sp).mul(confac));
			rowData.set("spAmt", Number(sp).mul(confac).mul(qty)); //���۽��
		}else{					//Ŀǰѡ����ǻ�����λ��ԭ��λ����ⵥλ
			rowData.set("sp", Number(sp).div(confac));
			rowData.set("spAmt", Number(sp).div(confac).mul(qty)); //���۽��
		}
	}
	rowData.set("uom", seluom);
});
		
//ģ��
var INDispReqGridCm = new Ext.grid.ColumnModel([
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
		sortable:true
	},{
		header:"��������",
		dataIndex:'desc',
		id:'colDesc',
		width:150,
		align:'left',
		sortable:true,
		editor:new Ext.grid.GridEditor(new Ext.form.TextField({
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
		}))
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
		header:"��������",
		dataIndex:'qty',
		id:'colQty',
		width:100,
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			allowNegative:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(INDispReqGrid,"remark");
						INDispReqGrid.startEditing(cell[0], col);
					}
				}
			}
		})
	},{
		header:"���۵���",
		dataIndex:'sp',
		width:100,
		align:'right',
		sortable:true,
		hidden:true
	},{
		header:"�ۼ۽��",
		dataIndex:'spAmt',
		width:100,
		align:'right',
		sortable:true,
		hidden:true
	},{
		header:"��λrowid",
		dataIndex:'uom',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"��λ",
		dataIndex:'uom',
		width:100,
		align:'left',
		sortable:true,
		renderer :Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),					
		editor : new Ext.grid.GridEditor(CTUom)
	},{
		header:"��ע",
		dataIndex:'remark',
		id:'colRemark',
		width:200,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			id:'remarkField',
			allowBlank:false,
			maxLength:30,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
						if(INDispReqGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","������������Ϊ0!");
							var col = GetColIndex(INDispReqGrid,'qty');
							INDispReqGrid.startEditing(cell[0], col);
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
		header : '״̬',
		dataIndex : 'moveStatus',
		width : 60,
		aligh : 'left',
		renderer : function(value){
			var status="";
			if(value=="G"){
				status="δ����";
			}else if(value=="D"){
				status="�ѷ���";
			}else if(value=="X"){
				status="��ȡ��";
			}else if(value=="R"){
				status="�Ѿܾ�";
			}
			return status;
		}
	}
]);

var add = new Ext.Toolbar.Button({
	text:'�½�',
	id:'newReq',
	iconCls:'page_add',
	tooltip:'�½����쵥',
	width : 70,
	height : 30,
	//disabled:true,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {
						clearReq();
						addNewRow();
					}
				}
			})
		}else {
			clearReq();
			addNewRow();
		}
	}
});
function saveReq(){
	//������Ϣ
	//��������
	var subLoc = Ext.getCmp('sublocField').getValue(); 
	if((subLoc=="")||(subLoc==null)){
		Msg.info("error", "��ѡ�񹩸�����!");
		return false;
	}
	var dsrqNo=Ext.getCmp('dsrqNo').getValue(); 
	
	//��½�û�
	var user = UserId;
	//����
	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "��ѡ������!");
		return false;
	}
	//��ɱ�־(��ʱΪ��)
	//var status =Ext.getCmp('reqType').getValue(); 
	//var reqMode=Ext.getCmp("dsMode").getValue().getGroupValue();
	var reqMode = Ext.getCmp("formPanel").getForm().findField('dispMode').getGroupValue();
	if(reqMode==""){
		Msg.info("warning","��ѡ�����췽ʽ!");
		return;
	}
	var userGrp=Ext.getCmp('UserGrp').getValue();
	if(reqMode==0 && userGrp==""){
		Msg.info("warning","��ѡ��רҵ��!");
		return;
	}
	
	//��ע
	var remark = Ext.getCmp('remark').getValue(); 
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	
	//������Ϣ�ַ���
	var reqInfo =INDispReqRowId+'^'+dsrqNo +"^"+ subLoc+"^"+user+"^"+scg+"^"+remark+"^"+reqMode+"^"+userGrp+"^"+user;
	//alert(reqInfo)
	
	if(RowDelim==null){
		Msg.info("error", "�зָ������󣬲��ܱ���!");
		return false;
	}
	
	if(INDispReqGrid.activeEditor != null){
		INDispReqGrid.activeEditor.completeEdit();
	}
	//�ӱ���ϸ
	var data = "";
	var count= INDispReqGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INDispReqGridDs.getAt(index);	
				//���������ݷ����仯ʱִ����������
		if(rec.data.newRecord || rec.dirty){
			var inc = rec.data['inci'];
			var qty = rec.data['qty'];
			var colRemark=rec.data['remark'];
			if((inc!="")&&(inc!=null)&&(qty!="")&&(qty!=null)&&(qty!=0)){
				var tmp = rec.data['rowid']+"^"+inc+"^"+rec.data['uom']+"^"+qty+"^"+colRemark;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
	}
	
	if ( (INDispReqRowId=='')&& (data=="")) {Msg.info("error", "û��������Ҫ����!");return false;}
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "û��������Ҫ����!");return false;}
	
	Ext.Ajax.request({
		url : 'dhcstm.indispreqaction.csp?actiontype=SaveDispReq',
		params:{dsrq:INDispReqRowId,mData:reqInfo,dData:data},
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "����ɹ�!");
				INDispReqRowId = jsonData.info;
				//alert(INDispReqRowId);
				refresh(INDispReqRowId);
			}else{
				if(jsonData.info==-1){
					Msg.info("error", "������ʧ��!");
				}else if(jsonData.info==-99){
					Msg.info("error", "�������ʧ��!");
				}else if(jsonData.info==-2){
					Msg.info("error", "��ϸ����ʧ��!");
				}else if(jsonData.info==-4){
					Msg.info("error", "����������ʧ��!");
				}else if(jsonData.info==-3){
					Msg.info("error", "������ʧ��!");
				}else{
					Msg.info("error", "����ʧ��,"+jsonData.info);
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
		if(INDispReqGrid.avtiveEditor!=null){
			INDispReqGrid.activeEditor.completeEdit();
		}
		//����ʱ���������ַ���
		//1.����rowid
		//2.�������Ϣ��subLoc��toLoc��user��scg��status��remark
		//3.�ӱ���ϸ��Ϣ��req����ϸ�ַ���rows(rows��Ϣ��reqi(��ϸrowid)��data(inci��uom��qty))
		
		saveReq();
	}
});

function refresh(dsrq){
	INDispReqRowId=dsrq;
	Select(INDispReqRowId);
	INDispReqGridDs.load({params:{start:0,limit:999,sort:'',dir:'asc',dsrq:INDispReqRowId}});
}

function Select(reqid){
	if(reqid==null || reqid==''){
		return;
	}
	INDispReqRowId=reqid;
	Ext.Ajax.request({
		url : 'dhcstm.indispreqaction.csp?actiontype=SelectDsReq&dsrq='+reqid,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				var data=jsonData.info;
				if(data.length>0){
					var dataArr=data.split("^");
					var no=dataArr[1];
					var loc=dataArr[2];
					var scg=dataArr[4];
					var scgDesc=dataArr[5];
					var d=dataArr[6];
					var t=dataArr[7];
					var opUser=dataArr[8];
					var opUserName=dataArr[9];
					var mode=dataArr[10];
					var reqGrp=dataArr[11];
					var reqUser=dataArr[12];
					var status=dataArr[13];
					var remark=dataArr[14];
					remark=handleMemo(remark,xMemoDelim());
					var comp=dataArr[15];
					var reqGrpDesc=dataArr[16];
					
					//dsrq_"^"_rqno_"^"_loc_"^"_locDesc_"^"_scg_"^"_scgDesc_"^"_d_"^"_t_"^"_opuser_"^"_opuserName_"^"_mode_"^"_grp_"^"_requser_"^"_status_"^"_remark_"^"_comp
					
					Ext.getCmp('dsrqNo').setValue(no);
					Ext.getCmp('sublocField').setValue(loc);
					Ext.getCmp('dateField').setValue(d);
					Ext.getCmp('timeField').setValue(t);
					Ext.getCmp('userField').setValue(opUserName);
					addComboData(groupField.getStore(),scg,scgDesc,groupField);
					Ext.getCmp('groupField').setValue(scg);
					Ext.getCmp('remark').setValue(remark);
					Ext.getCmp('reqStatus').setValue(status);
					
					if (mode==0) {
						byUser.setValue(false) ;
						byUserGrp.setValue(true);
						addComboData(GrpList.getStore(),reqGrp,reqGrpDesc);
						GrpList.setValue(reqGrp);
					}
					else {
						byUserGrp.setValue(false) ;
						byUser.setValue(true) ;
					}
					Ext.getCmp("completeCK").setValue(comp=="Y");
					Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),(comp=="Y"));
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
	text:'�ύ',
	tooltip:'�ύ',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (INDispReqRowId=='') 
		{
			Msg.info('warning','û���κ����쵥��');
			return ;
		}
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			statu = "Y";
			Ext.Ajax.request({
				url : 'dhcstm.indispreqaction.csp?actiontype=SetComp&dsrq='+INDispReqRowId,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "�ύ�ɹ�!");
						statu = "Y";
						completeCK.setValue(statu=='Y'?true:false);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "����ʧ��!");
						}else if(jsonData.info==-1){
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

var cancelComplete = new Ext.Toolbar.Button({
	text:'ȡ���ύ',
	tooltip:'ȡ���ύ',
	id:'cancelComp',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		if (INDispReqRowId=='') 
		{
			Msg.info('warning','û���κ����쵥��');
			return ;
		}
		var reqStatus=Ext.getCmp("reqStatus").getValue()
		if(reqStatus=="X"){
			Msg.info("error","����������, �����޸�!");
			return;
		}
		if(reqStatus=="C"){
			Msg.info("error","�����Ѵ���, ����ȡ���ύ!");
			return;
		}
		
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(statu=="Y"){
			Ext.Ajax.request({
				url : 'dhcstm.indispreqaction.csp?actiontype=CancelComp&dsrq='+INDispReqRowId,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ���ύ�ɹ�!");
						refresh(INDispReqRowId);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "����ʧ��!"+jsonData.info);
						}else if(jsonData.info==-1){
							Msg.info("error", "��ǰ���쵥��תΪ��ʽ��,��ֹȡ���ύ!");
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

function delReq()
{
	if(INDispReqRowId==null || INDispReqRowId==""){
		Msg.info("warning","��ѡ��Ҫɾ�������쵥!");
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
					url:URL+ "?actiontype=DelDispReq",
					method:'POST',
					params:{DSRQ:INDispReqRowId},
					success:function(response,opts){
						 
						var jsonData=Ext.util.JSON.decode(response.responseText);
						//alert(jsonData.success);
						
						if(jsonData.success=='true'){
							Msg.info("success","ɾ���ɹ�!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","�����쵥���ύ��������ɾ����");
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

var cancelButton= new Ext.Toolbar.Button({
	text:'�������쵥',
	id:'cancelReq',
	tooltip:'�������쵥',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		cancelReq();
	}
});

var printBT = new Ext.Toolbar.Button({
	text : '��ӡ',
	tooltip : '��ӡ���쵥',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(INDispReqRowId==null || INDispReqRowId==""){
			Msg.info("warning","û����Ҫ��ӡ�����쵥!");
			return;
		}
		PrintINDispReq(INDispReqRowId);
	}
});

function cancelReq()
{
	if(INDispReqRowId==null || INDispReqRowId==""){
		Msg.info("warning","��ѡ��Ҫ���ϵ����쵥!");
		return;
	}
	Ext.Msg.show({
		title:'��ʾ',
		msg:'�Ƿ�ȷ�����ϵ�ǰ���쵥��',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no')	{return;}
			else 	
			{
				Ext.Ajax.request({
					url:URL+ "?actiontype=CancelDispReq",
					method:'POST',
					params:{dsrq:INDispReqRowId},
					success:function(response,opts){
						 
						var jsonData=Ext.util.JSON.decode(response.responseText);
						//alert(jsonData.success);
						
						if(jsonData.success=='true'){
							Msg.info("success","���ϳɹ�!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
						}else{
							if(jsonData.info=='-99'){
								Msg.info('warning','����ʧ��!');
							}
							else if (jsonData.info=='-98'){
								Msg.info('warning','�Ѵ�����������!');
							}
							else if (jsonData.info=='-97'){
								Msg.info('warning','δ��ɣ���������!');
							}
							else if (jsonData.info=='-96'){
								Msg.info('warning','�Ѵ�����������!');
							}
							else if (jsonData.info=='-95'){
								Msg.info('warning','�����ϣ������ٴ�����!');
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
//ɾ��ת��������ϸ
function DeleteDetail(){
	if ((INDispReqRowId!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ���쵥���ύ');
		return;
	}
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}
	else{
		var record = INDispReqGridDs.getAt(cell[0]);
		var reqItm = record.get("rowid");
		//alert(reqItm);
		if(reqItm!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcstm.indispreqaction.csp?actiontype=DelDispReqItm&DSRQI='+reqItm,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									INDispReqGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsrq:INDispReqRowId}});
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "��ϸIdΪ�գ�ɾ��ʧ��!");
										return false;
									}else if(jsonData.info==-2){
										Msg.info("error", "�Ѵ���, ������ɾ��!");
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
		}
		else{
			INDispReqGridDs.remove(record);
			INDispReqGrid.getView().refresh();
		}
	
		if (INDispReqGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//��ʼ��Ĭ��������
INDispReqGridCm.defaultSortable = true;

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'�������',
	iconCls:'page_add',
	height:30,
	width:70,
	handler:function(){
		/*
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "��ѡ�����첿��!");
			return ;
		}
		*/
		
		var subLoc = Ext.getCmp('sublocField').getValue(); 
		if((subLoc=="")||(subLoc==null)){
			Msg.info("warning", "��ѡ�񹩸�����!");
			return ;
		}
		
		//����
		var scg = Ext.getCmp('groupField').getValue(); 
		if((scg=="")||(scg==null)){
			Msg.info("warning", "��ѡ������!");
			return false;
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'',
	iconCls:'page_delete',
	height:30,
	width:70,
	handler:function()
	{
		DeleteDetail();
	}
})

var CancelDetailBT = new Ext.Button({
	id : 'CancelDetailBT',
	text : 'ȡ��һ��',
	iconCls : 'page_edit',
	height : 30,
	width : 70,
	checked : false,
	handler : function(){
		CancelItm();
	}
});

function CancelItm(){
	var cell = INDispReqGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}
	if(Ext.getCmp('completeCK').getValue()!==true){
		Msg.info('warning','��ǰ���쵥��δ�ύ,ֱ���޸ļ���!');
		return;
	}
	var reqStatus = Ext.getCmp('reqStatus').getValue();
	if(reqStatus=="O"){
		Msg.info("warning","�����쵥��δ����,ȡ���ύ��ֱ���޸ļ���!");
		return;
	}else if(reqStatus=="X"){
		Msg.info("warning","�����쵥�Ѿ�����,����ȡ����ϸ!");
		return;
	}else if(reqStatus=="R"){
		Msg.info("warning","�����쵥�ѱ��ܾ�,����ȡ����ϸ!");
		return;
	}
	var record = INDispReqGridDs.getAt(cell[0]);
	var reqItm = record.get("rowid");
	var moveStatus = record.get("moveStatus");
	var dsrqiDesc = record.get("desc");
	if(moveStatus!="G"){
		Msg.info("warning","����ϸ�Ѿ�����,����ȡ��!");
		return;
	}
	if(reqItm!=""){
		Ext.MessageBox.confirm('��ʾ','ȷ��Ҫȡ���ü�¼?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url : 'dhcstm.indispreqaction.csp?actiontype=HandleItm&dsrqi='+reqItm+'&moveStatus=X',
						waitMsg:'ȡ����...',
						failure: function(result, request) {
							Msg.info("error", "������������!");
							return false;
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success","ȡ���ɹ�!");
								INDispReqGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsrq:INDispReqRowId}});
							}else{
								var info = jsonData.info;
								if(info==-96){
									Msg.info("warning",dsrqiDesc+"�ѷ����Ƶ�,����ȡ��!");
								}else if(info==-95){
									Msg.info("warning","������������,����ȡ����ϸ!");
									return false;	//ֹͣ����
								}else if(info==-94){
									Msg.info("warning","�������Ѿܾ�,����ȡ����ϸ!");
									return false;	//ֹͣ����
								}else if(info==-93){
									Msg.info("warning",dsrqiDesc+"�ѷ���,����ȡ��!");
									return;
								}else if(info==-92){
									Msg.info("warning",dsrqiDesc+"�Ѿܾ�,�����ظ�����!");
									return;
								}else{
									Msg.info("error",dsrqiDesc+"ȡ��ʧ��:"+jsonData.info);
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
		Msg.info("warning","����ϸ��δ����,ֱ��ɾ������!");
	}
}

//���
INDispReqGrid = new Ext.ux.EditorGridPanel({
	id:'reqItmEditGrid',
	title:'��������������',
	store:INDispReqGridDs,
	cm:INDispReqGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({
		singleSelect:true,
		listeners : {
			cellselect : function(sm,rowIndex,colIndex){
				var comp = Ext.getCmp("completeCK").getValue();
				var enalbeValue = comp && (INDispReqGridDs.getAt(rowIndex).get('rowid')!="");
				CancelDetailBT.setDisabled(!enalbeValue);
			}
		}
	}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',CancelDetailBT],
	listeners:{
		afteredit:function(e){
			if(e.field=="qty"){	
				e.record.set("spAmt",accMul(e.value,Number(e.record.get('sp')))); 
			}
		},
		beforeedit : function(e){
			if(Ext.getCmp("completeCK").getValue()===true){
				return false;
			}
		}
	}
});

//zdm,�����Ҽ�ɾ����ϸ����
INDispReqGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	grid.getSelectionModel().select(rowindex,0);
	e.preventDefault();
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'ɾ��',handler:DeleteDetail}]
});

//===========ģ����ҳ��===========================================

var formPanel = new Ext.ux.FormPanel({
	id:'formPanel',
	title:'��������������',
	tbar:[find,'-',add,'-',save,'-',del,'-',cancelButton,'-',complete,'-',cancelComplete,'-',clear,'-',printBT],
	items : [{
		xtype : 'fieldset',
		title : '���쵥��Ϣ',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
			columnWidth:0.3,
			items : [sublocField,groupField,byUser,{
				anchor:'90%',
				layout:'column',
				items:[{columnWidth:0.4,layout:'fit',items:byUserGrp},
					{columnWidth:0.6,layout:'fit',items:GrpList}]
			}]
		},{
			columnWidth : 0.25,
			items : [dsrqNo,userField,dateField,timeField]
		},{
			columnWidth : 0.25,
			items : [remark]
		},{
			columnWidth : 0.2,
			items : [completeCK,statusCombo]
		}]
	}]
});

//�鿴���쵥�����Ƿ����޸�
function isDataChanged()
{
	var changed=false;
	var count1= INDispReqGrid.getStore().getCount();
	//�����������Ƿ����޸�
	//�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	}
	if (changed) return changed;
	//����ϸ�����Ƿ����޸�
	var count= INDispReqGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INDispReqGridDs.getAt(index);	
				//���������ݷ����仯ʱִ����������
		if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,{
			region:'center',
			layout:'fit',
			items:[INDispReqGrid]
		}]
	});
});

//===========ģ����ҳ��===========================================
///���ÿɱ༭�����disabled����
function setEditDisable()
{
	Ext.getCmp('groupField').setDisabled(true);
}
///�ſ��ɱ༭�����disabled����
function setEditEnable()
{
	Ext.getCmp('groupField').setDisabled(false);
}

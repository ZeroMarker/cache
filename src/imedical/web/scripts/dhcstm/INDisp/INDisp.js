// ����:������Ա�����Ƶ�
// ��д����:2012-08-27

var mainRowId="";
var selectedDSRQ=""  //ѡȡ�����쵥
var findWin;

var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var inciDr = "";

//�������ֵ��object
var InDispParamObj = GetAppPropValue('DHCSTINDISPM');

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'����',
	listWidth:200,
	emptyText:'����...',
	groupId:gGroupId,
	anchor:'90%'
});

var INDSToLoc = new Ext.ux.ComboBox({
	id:'INDSToLoc',
	fieldLabel:'���տ���',
	emptyText:'���տ���...',
	triggerAction : 'all',
	store : LeadLocStore,
	valueParams : {groupId : gGroupId},
	filterName : 'locDesc',
	childCombo : ['receiveUser', 'UserGrp']
});
//SetLogInDept(INDSToLoc.getStore(),'INDSToLoc');

var indsUserField = new Ext.form.TextField({
	id:'indsUserField',
	fieldLabel:'�Ƶ���',
	anchor:'90%',
	disabled:true
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	width:210,
	listWidth:210,
    allowBlank:false,
	fieldLabel:'�Ƶ�����',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
	allowBlank:false,
	fieldLabel:'�Ƶ�ʱ��',
	anchor:'90%',
	disabled:true
});

var indsNumField = new Ext.form.TextField({
	id:'indsNumField',
	fieldLabel:'���ŵ���',
	allowBlank:true,
	emptyText:'���ŵ���...',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:'��ע',
	allowBlank:true,
	width:200,
	height:50,
	emptyText:'��ע...',
	anchor:'90%',
	selectOnFocus:true
});

var reqNo=new Ext.form.TextField({
	id:'dsrqNo',
	fieldLabel:'���쵥',
	readOnly:true,
	disabled:true,
	anchor:'90%'
});

// ��������
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:CtLocId,
	UserId:UserId,
	anchor : '90%'
});

var GrpList = new Ext.ux.ComboBox({
	fieldLabel:'רҵ��',	
	id:'UserGrp',
	anchor : '90%',
	disabled:true,
	store:UserGroupStore,
	valueField:'RowId',
	displayField:'Description',
	params:{SubLoc:'INDSToLoc'}		//2015-01-16 locField-->INDSToLoc �Խ��տ���Ϊ׼
});

var UserList = new Ext.ux.ComboBox({
	fieldLabel:'������',	
	id:'receiveUser',
	anchor : '90%',
	disabled:true,
	store:UStore,
	pageSize:10,
	valueField:'RowId',
	displayField:'Description',
	filterName:'name',
	params:{locId:'INDSToLoc'}		//2015-01-16 locField-->INDSToLoc �Խ��տ���Ϊ׼
});

var byUserGrp = new Ext.form.Radio({
	name:'dispMode',
	boxLabel:'רҵ��',
	inputValue:0,
	anchor:'90%',
	listeners:{
		'check':function(b){
			if (b.getValue()==1){
				Ext.getCmp('UserGrp').setDisabled(false);
			}else{
				Ext.getCmp('UserGrp').setValue('');
				Ext.getCmp('UserGrp').setDisabled(true);
			}
		}
	}
});

var byUser = new Ext.form.Radio({
	name:'dispMode',
	boxLabel:'����&nbsp;&nbsp;&nbsp;',
	inputValue:1,
	listeners:{
		'check':function(b){
			if (b.getValue()==1){
				Ext.getCmp('receiveUser').setDisabled(false);
				Ext.getCmp('receiveUser').getStore().load();	
			}else{
				Ext.getCmp('receiveUser').setValue('');
				Ext.getCmp('receiveUser').setDisabled(true);
			}			
		}
	}
});

var indsComplete=new Ext.Toolbar.Button({
	text:'�������',
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		setComplete();	
	}
});

var cancelindsComplete=new Ext.Toolbar.Button({
	text:'ȡ���������',
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		cancelComplete();
	}
});

var printInadj = new Ext.Toolbar.Button({
	id : "printInadj",
	text : '��ӡ',
	tooltip : '��ӡ���ŵ�',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId==null || mainRowId=="") {
			Msg.info("warning", "û����Ҫ��ӡ�ķ��ŵ�!");
			return;
		}
		PrintInDisp(mainRowId);
	}
});

var finishCK = new Ext.form.Checkbox({
	id: 'finishCK',
	boxLabel : '���',
	disabled:true,
	allowBlank:true
});

var auditCK = new Ext.form.Checkbox({
	id: 'auditCK',
	boxLabel : '���',
	disabled:true,
	allowBlank:true
});

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	height:30,
	width:70,
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{	
		addNewRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'ɾ��һ����ϸ��¼',
	height:30,
	width:70,
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
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
	var cell = INDispGrid.getSelectionModel().getSelectedCell();
	var record = INDispGrid.getStore().getAt(cell[0]);
	var InciDr = record.get("inci");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:InciDr}});
});

CTUom.on('select', function(combo) {
	var cell = INDispGrid.getSelectionModel().getSelectedCell();
	var rowData = INDispGrid.getStore().getAt(cell[0]);
	var seluom = combo.getValue();		//Ŀǰѡ��ĵ�λid
	var BUom = rowData.get("BUomId");
	var qty = rowData.get('qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("rp");
	var sp = rowData.get("sp"); //ԭ�ۼ�
	var Inclbqty = rowData.get('Inclbqty');
	var buom=rowData.get("BUomId");
	var confac=rowData.get("ConFac");
	var uom=rowData.get("uom");
	var AvaQty=rowData.get("AvaQty");
	if(seluom!=uom){
		if(seluom!=buom){     //ԭ��λ�ǻ�����λ��Ŀǰѡ�������ⵥλ
			rowData.set("rp", Number(rp).mul(confac));
			rowData.set("rpAmt", Number(rp).mul(confac).mul(qty));
			rowData.set("sp", Number(sp).mul(confac));
			rowData.set("spAmt", Number(sp).mul(confac).mul(qty)); //���۽��
			rowData.set("Inclbqty", Number(Inclbqty).div(confac));
			rowData.set("AvaQty", Number(AvaQty).div(confac));
		}else{					//Ŀǰѡ����ǻ�����λ��ԭ��λ����ⵥλ
			rowData.set("rp", Number(rp).div(confac));
			rowData.set("rpAmt", Number(rp).div(confac).mul(qty)); //���۽��
			rowData.set("sp", Number(sp).div(confac));
			rowData.set("spAmt", Number(sp).div(confac).mul(qty)); //���۽��
			rowData.set("Inclbqty", Number(Inclbqty).mul(confac));
			rowData.set("AvaQty", Number(AvaQty).mul(confac));
		}
	}
	rowData.set("uom", seluom);
});

//��������Դ
var INDispGridUrl = 'dhcstm.indispaction.csp';
var INDispGridProxy= new Ext.data.HttpProxy({url:INDispGridUrl+'?actiontype=queryItem',method:'GET'});
var INDispGridDs = new Ext.data.Store({
	proxy:INDispGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'indsitm'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qtyBUOM'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'RQI'},
		{name:'Inclbqty'},
		'ConFac','BUomId','IndsiRemarks','AvaQty','DirtyQty'
	]),
    remoteSort:false
});

//ģ��
var INDispGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"��ϸrowid",
        dataIndex:'indsitm',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����rowid",
        dataIndex:'inclb',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����rowid",
        dataIndex:'inci',
        width:150,
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
        id:'desc',
        width:200,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp('groupField').getValue());
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
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����~Ч��",
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'uom',
        width:100,
        align:'left',
        renderer :Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),					
		editor : new Ext.grid.GridEditor(CTUom)
    },{
        header:"��λRowid",
        dataIndex:'uom',
        width:100,
        align:'right',
        sortable:true,
		hidden:true
    },{
        header:"���ο��",
        dataIndex:'Inclbqty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��������",
        id:'dspQty',
        dataIndex:'qty',        
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
            allowNegative:false,
            listeners:{
            	specialkey:function(field,e){
            		if(e.getKey()==e.ENTER){
            			if(field.getValue()=="" || field.getValue()==0){
            				Msg.info("warning","������������Ϊ0!");
            				return;
            			}else{
            				addNewRow();
            			}
            		}
            	}
            }
        })
    },{
        header:"�ۼ�",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true,
        hidden:true,
        hideable:false
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        hidden:true,
        hideable:false
    },{
        header:"����",
        dataIndex:'rp',
        width:60,
        align:'right',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��ע",
        dataIndex:'IndsiRemarks',
        width:200,
        align:'left',
		editor:new Ext.form.TextField({
			id:'indsiRemark',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INDispGrid.getSelectionModel().getSelectedCell();
						if(INDispGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","������������Ϊ0!");
							var col = GetColIndex(INDispGrid,'qty');
							INDispGrid.startEditing(INDispGridDs.getCount() - 1, col);
							return false;
						}else{
							addNewRow();
						}
					}
				}
			}
		})
	},{
		header : '���ÿ��',
		dataIndex : 'AvaQty',
		align : 'right',
		xtype : 'numbercolumn',
		width : 80
	},{
		header : '����ռ��',
		dataIndex : 'DirtyQty',
		align : 'right',
		xtype : 'numbercolumn',
		hidden : true
	}, {
		header : "��������",
		dataIndex : 'INCLBBarCode',
		width : 180,
		align : 'left',
		sortable : true,
		editable : true,
		editor : new Ext.grid.GridEditor(new Ext.form.TextField({
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					var Barcode=field.getValue();
					if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
						var row=INDispGrid.getSelectionModel().getSelectedCell()[0];
						var RowRecord = INDispGrid.store.getAt(row);
						var findHVIndex=INDispGridDs.findExact('INCLBBarCode',Barcode,0);
						if(findHVIndex>=0 && findHVIndex!=row){
							Msg.info("warning","�����ظ�¼��!");
							field.setValue("");
							return;
						}
						Ext.Ajax.request({
								url : 'dhcstm.dhcinistrfaction.csp?actiontype=GetinclbByINCLBBarCode',
								method : 'POST',
								params : {Barcode:Barcode},
								waitMsg : '��ѯ��...',
								success : function(result, request){
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if(jsonData.success == 'true'){
										var itmArr=jsonData.info.split("^");
										var inclb=itmArr[0],inciDr=itmArr[1],inciCode=itmArr[2],inciDesc=itmArr[3];
										if(inclb==""){
											Msg.info("warning","�����벻����,�����Ƶ�!");
											RowRecord.set("INCLBBarCode","");
											return;
										}
										var record = Ext.data.Record.create([{
													name : 'InciDr',
													type : 'string'
												}, {
													name : 'InciCode',
													type : 'string'
												}, {
													name : 'InciDesc',
													type : 'string'
												}, {
													name : 'Barcode',
													type : 'string'
												}, {
													name : 'OperQty',
													type : 'string'
												}]);
										var InciRecord = new record({
													InciDr : inciDr,
													InciCode : inciCode,
													InciDesc : inciDesc,
													Barcode:Barcode,
													OperQty:1
												});
										var phaLoc = Ext.getCmp("locField").getValue();
										var phaLocRQ ="";
										var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
											+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
										var LBResult=ExecuteDBSynAccess(url);
										var info=Ext.util.JSON.decode(LBResult);
										if(info.results=='0'){
											Msg.info("warning","�ò���û����Ӧ����¼,�����Ƶ�!");
											INDispGrid.store.getAt(row).set("INCLBBarCode","");
											return;
										}
										var inforows=info.rows[0];
										
										Ext.applyIf(InciRecord.data,inforows);
										returnInfo2(InciRecord);
									}
								}
						});
					}
				}
			}
		}))
	}
]);
//��ʼ��Ĭ��������
INDispGridCm.defaultSortable = true;

var addINDispM = new Ext.Toolbar.Button({
	text:'�½�',
	tooltip:'����һ���µĵ���',
	iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {newINAdj();}
				}
			})
		}
		else
		{newINAdj();}
	}
});

function newINAdj(){
	mainRowId='';
	clearPage();
	addNewRow();
}

var findINDispM = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ�ѱ�����ĵ���',
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
						clearPage();
						FindINDisp(INDispGridDs,locField,select);
					}
				}
			})
		}else{
			clearPage();
			FindINDisp(INDispGridDs,locField,select);
		}
	}
});

var saveINDispM = new Ext.ux.Button({
	text:'����',
	tooltip:'���浱ǰҳ����ʾ�ĵ���',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(INDispGrid.activeEditor != null){
			INDispGrid.activeEditor.completeEdit();
		}
		save();
	}
});

var deleteINDispM = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ����ǰҳ����ʾ�ĵ���',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		deleteAdj();
	}
});

var clearINDispM = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'��յ�ǰҳ�����ʾ����',
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
					if (btn=='yes') {clearPage();SetFormOriginal(formPanel);}
				}
			})
		}
		else
		{
			clearPage();
			SetFormOriginal(formPanel);
		}
	}
});

 ///�鿴����Ӧ�����쵥
var getDispReqBt=new Ext.Toolbar.Button({
	text:'���쵥...',
	tooltip:'�鿴����Ӧ�����쵥',
	iconCls:'page_refresh',
	width : 70,
	height : 30,
	handler:function(){
		var LocId = Ext.getCmp('locField').getValue();
		if(LocId==''){
			Msg.info("warning","��ѡ�����!");
			return;
		}
		LoadReq(LocId);
	}
})

var INDispByInitInBtn = new Ext.Button({
	text:'���ת�Ƶ�...',
	tooltip:'�鿴�ѽ��յĿ��ת�Ƶ�',
	iconCls:'page_refresh',
	width : 70,
	height : 30,
	handler:function(){
		var LocId = Ext.getCmp('locField').getValue();
		var toLocId = Ext.getCmp('INDSToLoc').getValue();
		if(LocId==''){
			Msg.info("warning","��ѡ�����!");
			return;
		}
		if(toLocId==''){
			Msg.info("warning","��ѡ����տ���!");
			return;
		}
		LoadInitIn(LocId,toLocId, select);
	}
});

function checkBeforeSave()
{	
	//����Ƿ�����ϸ��¼
	if (mainRowId=='')
	{
		if (INDispGrid.getStore().getCount()==0)
		{
			Msg.info('error','û���κ���ϸ��¼!');
			return false;
		}
	}
	
	//�Ƿ�ѡ�񷢷ŷ�ʽ�Ѿ�ѡ�񣨸��˻���רҵ�飩
	
	if ((byUserGrp.getValue()=='')&&(byUser.getValue()=='') )
	{
		Msg.info('error','���ŷ�ʽ����ѡ��');
		return false;
	}
	
	//�����ϸ���
	return true;
}

function save()
{
	if (!checkBeforeSave()) return;
	
	var indsUser = UserId;
	var indsStkType = App_StkTypeCode
	var adjInst = "";
	var indsLoc = Ext.getCmp('locField').getValue();
	if((indsLoc=="")||(indsLoc==null)){
		Msg.info("error","��ѡ��Ӧ����!");
		return false;
	}
	
	var indsScg = Ext.getCmp('groupField').getValue();
	if((indsScg=="")||(indsScg==null)){
		Msg.info("error","��ѡ������!");
		return false;
	}
	
	var indsComp = (Ext.getCmp('finishCK').getValue()==true?'Y':'N');
	var indsState = (Ext.getCmp('auditCK').getValue()==true?'Y':'N');
	var indsReason='';
	
	var remark = Ext.getCmp('remarkField').getValue();
	remark = remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	
	var INDSToLoc = Ext.getCmp('INDSToLoc').getValue();
	if(INDSToLoc==''){
		Msg.info('warning','��ѡ����տ���!');
		return;
	}
    var dispUser=Ext.getCmp('receiveUser').getValue();
    var dispLug=Ext.getCmp('UserGrp').getValue();
    if(byUserGrp.getValue()==true && dispLug==""){
    	Msg.info("warning","��ѡ��רҵ��!");
    	return;
    }
	if(byUser.getValue()==true && dispUser==""){
		Msg.info("warning","��ѡ��������!");
		return;
	}
	var dispMode=formPanel.getForm().findField('dispMode').getGroupValue();
	
	var mainData = indsLoc+"^"+indsUser+"^"+indsReason+"^"+indsScg+"^"+indsStkType
			+"^"+adjInst+"^"+indsComp+"^"+indsState+"^"+remark+"^"+dispLug
			+"^"+dispUser+"^"+dispMode+"^"+selectedDSRQ+"^"+INDSToLoc;
	//��֯��ϸ����
	var detailData="";
	var count = INDispGridDs.getCount();
	for(var index=0;index<count;index++){		
		var rec = INDispGridDs.getAt(index);
		if (rec.data.newRecord || rec.dirty){		
			var indsitm = rec.get('indsitm'); //�ӱ���ϸrowid
			var inclb = rec.get('inclb');//����rowid
			var Inclbqty=rec.get("Inclbqty");
		
			if((inclb!="")&&(inclb!=null)){
				var qty = rec.get('qty');
				
				if ((qty=='')||(parseFloat(qty)==0)){
					Msg.info('error','��ǰ�з�����������Ϊ��!');
					var qtyColIndex=Ext.getCmp('INDispGrid').getColumnModel().getIndexById('dspQty');
					Ext.getCmp('INDispGrid').getSelectionModel().select(index,qtyColIndex);	
					return;
				}
					         
				var uom = rec.get('uom');
				var sp = rec.get('sp');
				var spAmt = rec.get('spAmt');
				var rp = rec.get('rp');
				var rpAmt = rec.get('rpAmt');
				var RQI = rec.get('RQI');
				var IndsiRemarks = rec.get('IndsiRemarks');
				var tmp = indsitm+"^"+inclb+"^"+qty+"^"+uom+"^"+rp+"^"+sp+"^"+rpAmt+"^"+spAmt+"^"+RQI+"^"+IndsiRemarks;
				if(detailData!=""){
					detailData = detailData+xRowDelim()+tmp;
				}else{
					detailData = tmp;
				}
			}
		}
	}
	
	if ( (mainRowId=='')&& (detailData=="")) {Msg.info("error", "û��������Ҫ����!");return false;}
	if(!IsFormChanged(formPanel) && detailData==""){
		Msg.info("error", "û��������Ҫ����!");
		return false;
	}
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url: INDispGridUrl+'?actiontype=SaveDisp',
		params:{inds:mainRowId,mainData:mainData,detailData:detailData},
		failure: function(result,request) {
			Msg.info("error","������������!");
		},
		success: function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","����ɹ�!");
				mainRowId=jsonData.info   //rowid - ����rowid
				select(mainRowId);
				loadMask.hide();
			}else{
				if(jsonData.info==-1){
					Msg.info("error","�������!");
				}else{
					Msg.info("error","����ʧ��!"+jsonData.info);
				}
				loadMask.hide();
			}
		},
		scope: this
	});
}

//������������ݵ��ؼ�
function select(rowid){
	mainRowId=rowid;
	Ext.Ajax.request({
		url:INDispGridUrl+"?actiontype=select&disp="+rowid,
		failure:function(){alert('failure');},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.results>0) {
				data=jsonData.rows;
				if (!data) return;
				var loc=data[0]['INDS_CTLOC_DR'];
				var locDesc=data[0]['locDesc'];
				var INDSToLocId = data[0]['INDS_TOLOC_DR'], INDSToLoc = data[0]['INDSToLoc'];
				var scg=data[0]['INDS_SCG_DR'];
				var scgDesc=data[0]['scgDesc'];
				var no=data[0]['INDS_No'];
				var dispDate=data[0]['INDS_Date'];
				var dispTime=data[0]['INDS_Time'];
				var completeFlag=data[0]['INDS_Completed']; 
				var auditFlag=data[0]['INDS_AckFlag'];
				var remark=data[0]['INDS_Remarks'];
				remark=handleMemo(remark,xMemoDelim());
				
				var userName=data[0]['userName'];
				var auditUserName=data[0]['INDS_SSUSR_Ack_DR'];
				var chkDate=data[0]['INDS_AckDate'];
				var chkTime=data[0]['INDS_AckTime'];
				var dsrqNo=data[0]['dsrqNo'];
				
				var dispMode=data[0]['INDS_DispMode'];
				var dispUser=data[0]['INDS_DispUser_DR'];
				var DispRecUser=data[0]['DispRecUser'];
				var dispGrp=data[0]['INDS_DispUserGrp_DR'];
				var dispGrpDesc=data[0]['LUG_GroupDesc'];
				
				addComboData(Ext.getCmp('locField').getStore(),loc,locDesc);
				Ext.getCmp('locField').setValue(loc);
				Ext.getCmp('locField').setDisabled(true);
				addComboData(Ext.getCmp('INDSToLoc').getStore(),INDSToLocId,INDSToLoc);
				Ext.getCmp('INDSToLoc').setValue(INDSToLocId);
				selectedDSRQ=data[0]['INDS_RQ_DR'];
				
				Ext.getCmp('indsNumField').setValue(no);
				Ext.getCmp('dateField').setValue(dispDate);
				Ext.getCmp('indsUserField').setValue(userName);
				Ext.getCmp('timeField').setValue(dispTime);
				Ext.getCmp('finishCK').setValue(((completeFlag=='Y')?'true':'false'));			 	
				//alert(completeFlag);
				Ext.getCmp('dsrqNo').setValue(dsrqNo);
				
				if (dispMode=='1') {
					byUser.setValue(true);
					addComboData(UserList.getStore(),dispUser,DispRecUser);
					Ext.getCmp('receiveUser').setValue(dispUser);
				}else{
					byUserGrp.setValue(true);
					addComboData(GrpList.getStore(),dispGrp,dispGrpDesc);
					Ext.getCmp('UserGrp').setValue(dispGrp);
				}
				
				//�������쵥����,������ɵ���, �����޸ķ���ģʽ����Ϣ
				if (!Ext.isEmpty(dsrqNo) || completeFlag=='Y') {
					byUser.setDisabled(true);
					byUserGrp.setDisabled(true);
					Ext.getCmp('receiveUser').setDisabled(true);
					Ext.getCmp('UserGrp').setDisabled(true);
					Ext.getCmp('INDSToLoc').setDisabled(true);
				}else{
					byUser.setDisabled(false);
					byUserGrp.setDisabled(false);
					Ext.getCmp('receiveUser').setDisabled(!byUser.getValue());
					Ext.getCmp('UserGrp').setDisabled(!byUserGrp.getValue());
					Ext.getCmp('INDSToLoc').setDisabled(false);
				}
				Ext.getCmp('auditCK').setValue(((auditFlag=='Y')?'true':'false'));
				addComboData(null,scg,scgDesc,groupField);
				Ext.getCmp('groupField').setValue(scg);
				Ext.getCmp('remarkField').setValue(remark);  //��ע
				if(auditFlag=='Y'){
					indsComplete.setDisabled(true);
					saveINDispM.setDisabled(true);
					deleteINDispM.setDisabled(true);
					cancelindsComplete.setDisabled(true);
				}else if(completeFlag=='Y'){
					indsComplete.setDisabled(true);
					saveINDispM.setDisabled(true);
					deleteINDispM.setDisabled(true);
					cancelindsComplete.setDisabled(false);
				}else{
					indsComplete.setDisabled(false);
					saveINDispM.setDisabled(false);
					deleteINDispM.setDisabled(false);
					cancelindsComplete.setDisabled(true);
				}
				Ext.getCmp('INDispGrid').getStore().load({params:{start:0,limit:999,disp:rowid}});
			}else{
				if(jsonData.info==-1){
					Msg.info("error","�����������!");
				}else{
					Msg.info("error","��������ʧ��!"+jsonData.info);
				}
			}
			
			setEditDisable();
			SetFormOriginal(formPanel);
		}
	});
}
	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "0", HospId,"",returnInfo);
	}
}

//ɾ��һ��(��ϸ)
function DeleteDetail()
{	
	var complete=Ext.getCmp('finishCK').getValue();
	if (complete==true){
		Msg.info('warning','�Ѿ����,��ֹɾ����ϸ��¼!');
		return;
	}
	
	var cell = INDispGrid.getSelectionModel().getSelectedCell();

	if(cell==null){
		Msg.info("warning","��ѡ������!");
		return false;
	}else{
		var record = INDispGridDs.getAt(cell[0]);
		var rowid = record.get("indsitm");
		if(rowid!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcstm.indispaction.csp?actiontype=deleteItem&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									INDispGridDs.load({params:{start:0,limit:999,disp:mainRowId}});
								}else{
									Msg.info("error", "ɾ��ʧ��!");
									return false;
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
			//Msg.info("error", "��ϸIdΪ��,������ɾ��!");
			INDispGridDs.remove(record);
			INDispGrid.getView().refresh();
		}
	
		if (INDispGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//���ҿ����������Ϣ���ڹر�ʱ�ص�����
function returnInfo(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records,function(record,index,allItems){
		inciDr = record.get("InciDr");
		var cell = INDispGrid.getSelectionModel().getSelectedCell();
		var recordInclb = record.get("Inclb");
		var findIndex = INDispGridDs.findExact('inclb',recordInclb,0);
		if(findIndex!=-1 && findIndex!=cell[0]){
			var batInfo = record.get("InciCode")+":"+record.get("BatExp");
			Msg.info("warning",batInfo+" �Ѵ����ڵ�"+(findIndex+1)+"��!");
			return;
		}
		var rowData = INDispGrid.getStore().getAt(cell[0]);
        var HVFlag= record.get("HVFlag");
		if(HVFlag=="Y")
		{
			Msg.info("warning","��ֵ����,���ܽ��з���!");
			return;
			}
		rowData.set("inci",inciDr);
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("batNo",record.get("BatExp"));
		rowData.set("manf",record.get("Manf"));
		addComboData(ItmUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
		rowData.set("uom",record.get("PurUomId"));
		rowData.set("uomDesc",record.get("PurUomDesc"));
		rowData.set("sp",record.get("Sp"));
		rowData.set("spAmt",accMul(record.get("Sp"),record.get('OperQty')));
		rowData.set("rp",record.get("Rp"));
		rowData.set("rpAmt",accMul(record.get("Rp"),record.get('OperQty')));
		rowData.set("inclb",record.get("Inclb"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("Inclbqty",record.get("InclbQty"));
		rowData.set("AvaQty", record.get("AvaQty"));
		rowData.set('ConFac',record.get('ConFac'));
		rowData.set('BUomId',record.get('BUomId'));
		rowData.set('qty',record.get('OperQty'));
		var lastIndex = INDispGridDs.getCount()-1;
		if(INDispGridDs.getAt(lastIndex).get('inci')!=""){
			addNewRow();
		}else{
			var col=GetColIndex(INDispGrid,'desc')
			INDispGrid.startEditing(lastIndex,col);
		}
	});
}
//���ҿ����������Ϣ���ڹر�ʱ�ص�����
function returnInfo(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records,function(record,index,allItems){
		inciDr = record.get("InciDr");
		var cell = INDispGrid.getSelectionModel().getSelectedCell();
		var recordInclb = record.get("Inclb");
		var findIndex = INDispGridDs.findExact('inclb',recordInclb,0);
		if(findIndex!=-1 && findIndex!=cell[0]){
			var batInfo = record.get("InciCode")+":"+record.get("BatExp");
			Msg.info("warning",batInfo+" �Ѵ����ڵ�"+(findIndex+1)+"��!");
			return;
		}
		var rowData = INDispGrid.getStore().getAt(cell[0]);
		var HVFlag= record.get("HVFlag");
		if(HVFlag=="Y")
		{
			Msg.info("warning","��ֵ����,���ܽ��з���!");
			return;
			}
		rowData.set("inci",inciDr);
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		rowData.set("batNo",record.get("BatExp"));
		rowData.set("manf",record.get("Manf"));
		addComboData(ItmUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
		rowData.set("uom",record.get("PurUomId"));
		rowData.set("uomDesc",record.get("PurUomDesc"));
		rowData.set("sp",record.get("Sp"));
		rowData.set("spAmt",accMul(record.get("Sp"),record.get('OperQty')));
		rowData.set("rp",record.get("Rp"));
		rowData.set("rpAmt",accMul(record.get("Rp"),record.get('OperQty')));
		rowData.set("inclb",record.get("Inclb"));
		rowData.set("spec",record.get("Spec"));
		rowData.set("Inclbqty",record.get("InclbQty"));
		rowData.set("AvaQty", record.get("AvaQty"));
		rowData.set('ConFac',record.get('ConFac'));
		rowData.set('BUomId',record.get('BUomId'));
		rowData.set('qty',record.get('OperQty'));
		if(!Ext.isEmpty(record.get('Barcode'))){
		rowData.set('INCLBBarCode',record.get('Barcode'));
		}
		var lastIndex = INDispGridDs.getCount()-1;
		if(INDispGridDs.getAt(lastIndex).get('inci')!=""){
			addNewRow();
		}else{
			var col=GetColIndex(INDispGrid,'desc')
			INDispGrid.startEditing(lastIndex,col);
		}
	});
}

//��������(��ϸ)
function addNewRow() {
	if ((mainRowId!="")&&(Ext.getCmp('finishCK').getValue()==true)){
		Msg.info('warning','��ǰ���ŵ������,��ֹ������ϸ��¼!');
		return;
	}
	var rowCount=INDispGrid.getStore().getCount();
	var col=GetColIndex(INDispGrid,"desc");
	if(rowCount>0){
		var rowData = INDispGridDs.data.items[rowCount-1]
		var inci = rowData.get("inci");
		if(Ext.isEmpty(inci)){
			INDispGrid.startEditing(rowCount - 1, col);
			return;
		}
	}
	
	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "��ѡ������!");
		return ;
	}
	var SpecialValue = {DirtyQty : 0};
	var NewRecord = CreateRecordInstance(INDispGridDs.fields, SpecialValue);
	INDispGridDs.add(NewRecord);
	INDispGrid.startEditing(INDispGridDs.getCount() - 1, col);
	setEditDisable();
}

 //ɾ�����ŵ�
function deleteAdj()
{
	if (mainRowId=='')
	{
		Msg.info('warning','û���κη��ŵ�!');return false;	
	}
	var complete=Ext.getCmp('finishCK').getValue();
	if (complete==true)
	{
		Msg.info('warning','�õ��Ѿ����,��ֹɾ��!');	return false;
	}

	var rowid=mainRowId;
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���÷��ŵ�?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url : 'dhcstm.indispaction.csp?actiontype=delete&disp='+rowid,
					waitMsg:'ɾ����...',
					failure: function(result, request) {
						Msg.info("error", "������������!");
						return false;
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success",'ɾ���ɹ�!');
							clearPage();
							return true;
						}else{
							Msg.info("error", "ɾ��ʧ��!"+jsonData.info);
							return false;
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

//���ҳ��
function clearPage(){
	SetLogInDept(locField.getStore(),'locField');
//	SetLogInDept(INDSToLoc.getStore(),'INDSToLoc');
	mainRowId="";
	selectedDSRQ="";
	Ext.getCmp('indsNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('indsUserField').setValue("");	
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('finishCK').setValue("");
	Ext.getCmp('remarkField').setValue("");
	Ext.getCmp('auditCK').setValue("");
	Ext.getCmp('dsrqNo').setValue("");
	INDispGridDs.removeAll();
	saveINDispM.enable();
	setEditEnable();

	byUser.setValue(false);
	byUserGrp.setValue(false);
	byUser.setDisabled(false);
	byUserGrp.setDisabled(false);
	
	Ext.getCmp("UserGrp").setValue("");
	Ext.getCmp("UserGrp").setDisabled(true);
	Ext.getCmp("receiveUser").setValue("");
	Ext.getCmp("receiveUser").setDisabled(true);
	Ext.getCmp('locField').setDisabled(false);
	Ext.getCmp('INDSToLoc').setDisabled(false);
}

//���õ������
function setComplete(){
	if (mainRowId=='') {return;}
	if (Ext.getCmp('finishCK').getValue()==true){
		Msg.info('warning','��ǰ���������!');return;
	}
	Ext.Ajax.request({
		url:INDispGridUrl+'?actiontype=setComplete'+"&disp="+mainRowId,
		failure:function(){
			Msg.info('error','��������!');return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info('success','���óɹ���');
				select(mainRowId);
			}else{
				Msg.info("error", "����ʧ��!"+jsonData.info);
				return false;
			}			
		}
	});
}

//ȡ�����
function cancelComplete(){
	if (mainRowId=='') {
		Msg.info('warning','û���κε���,���Ȳ�ѯ!');
		return;
	}
	if (Ext.getCmp('finishCK').getValue()==false){
		Msg.info('error','�õ�����δ���!');
		return;
	}
	Ext.Ajax.request({
		url:INDispGridUrl+'?actiontype='+'cancelComplete'+'&disp='+mainRowId,
		failure:function(){
			Msg.info('error','��������!');
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info('success','���óɹ���');
				select(mainRowId);
			}else{
				Msg.info("error", "����ʧ��!"+jsonData.info);
				return;
			}
		}
	});
}

var formPanel = new Ext.ux.FormPanel({
	id:'formPanel',
	title:'���ʷ����Ƶ�',
	tbar:[addINDispM,'-',findINDispM,'-',saveINDispM,'-',deleteINDispM,'-',indsComplete,
		'-',cancelindsComplete,'-',clearINDispM,'-',printInadj,'-',getDispReqBt,'-',INDispByInitInBtn],
	items : [{
		xtype : 'fieldset',
		title : '���ŵ���Ϣ',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .30,
				items : [locField,INDSToLoc,
					{
						anchor:'90%',
						layout:'column',
						items:[{columnWidth:0.35,layout:'fit',height : 30,items:byUser},
							{columnWidth:0.65,layout:'fit',items:UserList}]
					}, {
						anchor:'90%',
						layout:'column',
						items:[{columnWidth:0.35,layout:'fit',height : 30,items:byUserGrp},
							{columnWidth:0.65,layout:'fit',items:GrpList}]
					}
				]
			}, {
				columnWidth : .25,
				labelWidth : 60,
				items : [groupField,dateField,timeField,indsUserField]
			}, {
				columnWidth : .25,
				items : [indsNumField,reqNo,remarkField]
			}, {
				columnWidth : .2,
				items : [finishCK,auditCK]
		}]
	}]
});

//���
var INDispGrid = new Ext.ux.EditorGridPanel({
	title:'��ϸ��¼',
	store:INDispGridDs,
	cm:INDispGridCm,
	id:'INDispGrid',
	trackMouseOver:true,
	region:'center',
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT],
	listeners:{
		afteredit:function(e){
			if(e.field=='qty'){
				if ((e.value-Number(e.record.get('DirtyQty')))>Number(e.record.get('AvaQty'))){
					Msg.info("warning","�����������ܳ������ÿ��!");
					e.record.set(e.field,e.originalValue);
					return false;
				}
				e.record.set("spAmt",accMul(e.value,Number(e.record.get('sp')))); 
				e.record.set("rpAmt",accMul(e.value,Number(e.record.get('rp'))));
			}
		},
		beforeedit : function(e){
			if(Ext.getCmp('finishCK').getValue()===true){
				return false;
			}
		}
	}
});

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'���ʷ����Ƶ�',
		activeTab:0,
		layout:'fit',
		region:'north',
		height:230,
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INDispGrid],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=============================================

 //���ÿɱ༭�����disabled����
function setEditDisable()
{
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('locField').setDisabled(true);
}
 //�ſ��ɱ༭�����disabled����
function setEditEnable()
{
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('locField').setDisabled(false);
}

//�鿴���������Ƿ����޸�
function isDataChanged()
{
	var changed=false;
	var count1= INDispGrid.getStore().getCount();
	//�����������Ƿ����޸�
	//�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	}
	if (changed) return changed;
	//����ϸ�����Ƿ����޸�
	var count= INDispGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INDispGrid.getStore().getAt(index);	
				//���������ݷ����仯ʱִ����������
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}
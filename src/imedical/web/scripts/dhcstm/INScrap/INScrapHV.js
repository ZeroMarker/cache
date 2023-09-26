// ����:��汨���Ƶ�
// ��д����:2012-08-14
var mainRowId="";
var reasonId = "";
var inscrapUrl='dhcstm.inscrapaction.csp';

//�������ֵ��object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');

//ȡ��ֵ�������
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}
//��ʹ�ø�ֵ����,��һ�㱨��͸�ֵ���������˵�,����������
UseItmTrack=UseItmTrack&&gHVInScrap;

var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var inciDr = "";

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'����',
	//width:200,
	listWidth:210,
	emptyText:'����...',
	groupId:gGroupId,
	anchor:'90%',
	stkGrpId:'groupField'
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	//width:200,
	listWidth:200,
    allowBlank:false,
	fieldLabel:'�Ƶ�����',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
	//width:200,
    allowBlank:false,
	fieldLabel:'�Ƶ�ʱ��',
	//format:'HH-MM-SS',
	anchor:'90%',
	//value:new Time(),
	disabled:true
});

var userField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:'�Ƶ���',
	width:200,
	anchor:'90%',
	disabled:true
});

var inscrapNumField = new Ext.form.TextField({
	id:'inscrapNumField',
	fieldLabel:'���𵥺�',
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:'���𵥺�...',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// ��������
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:'����',
	//width:200,
	anchor:'90%',
	listWidth:200,
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:CtLocId,
	UserId:UserId
});

// ����ԭ��
var causeField = new Ext.form.ComboBox({
	id:'causeField',
	fieldLabel:'����ԭ��',
	//width:200,
	anchor:'90%',
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'����ԭ��...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'',
	height : 30,
	width : 70,
	iconCls:'page_add',
	handler:function()
	{
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'',
	height : 30,
	width : 70,
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});


var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:'��ע',
	allowBlank:true,
	//width:200,
	height:50,
	emptyText:'��ע...',
	anchor:'90%',
	selectOnFocus:true
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	fieldLabel:'���',
	disabled:true,
	allowBlank:true
});

var HVBarCodeEditor = new Ext.form.TextField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var row=INScrapMGrid.getSelectionModel().getSelectedCell()[0];
				var RowRecord = INScrapMGrid.store.getAt(row);
				var findHVIndex=INScrapMGridDs.findExact('HVBarCode',Barcode,0);
				if(findHVIndex>=0 && findHVIndex!=row){
					Msg.info("warning","�����ظ�¼��!");
					field.setValue("");
					return;
				}
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
					method : 'POST',
					params : {Barcode:Barcode},
					waitMsg : '��ѯ��...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
							var OriginalStatus=itmArr[29]
							RowRecord.set('OriginalStatus',OriginalStatus);
							if(OriginalStatus=="NotUnique"){
								var LocId = Ext.getCmp("locField").getValue();
								inclb=tkMakeServerCall("web.DHCSTM.DHCItmTrack","GetInclbByInclb",LocId,inclb)  //��ȡ��ȷ��inclb
							}
							var groupField=Ext.getCmp("groupField").getValue();
							if(!CheckScgRelation(groupField,scgID)){
								Msg.info("warning","����"+Barcode+"����"+scgDesc+"����,�뵱ǰ����!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(inclb==""){
								Msg.info("warning","�ø�ֵ����û����Ӧ����¼,�����Ƶ�!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(lastDetailAudit!="Y" && OriginalStatus!="NotUnique"){
								Msg.info("warning","�ø�ֵ������δ��˵�"+lastDetailOperNo+",���ʵ!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(type=="T" && OriginalStatus!="NotUnique"){
								Msg.info("warning","�ø�ֵ�����Ѿ�����,�����Ƶ�!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(status!="Enable"){
								Msg.info("warning","�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!");
								RowRecord.set("HVBarCode","");
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
								}]);
							var InciRecord = new record({
								InciDr : inciDr,
								InciCode : inciCode,
								InciDesc : inciDesc
							});
							var phaLoc = Ext.getCmp("locField").getValue();
							var phaLocRQ = "";
							var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
								+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
							var LBResult=ExecuteDBSynAccess(url);
							var info=Ext.util.JSON.decode(LBResult);
							if(info.results=='0'){
								Msg.info("warning","�ø�ֵ����û����Ӧ����¼,�����Ƶ�!");
								RowRecord.set("HVBarCode","");
								return;
							}
							var inforows=info.rows[0];
							Ext.applyIf(InciRecord.data,inforows);
							returnInfo(InciRecord, RowRecord);
						}else{
							Msg.info("warning","��������δע��!");
							RowRecord.set("HVBarCode","");
							return;
						}
					}
				});
			}
		}
	}
});

var INScrapMGrid="";
//��������Դ
var INScrapMGridUrl = 'dhcstm.inscrapaction.csp';
var INScrapMGridProxy= new Ext.data.HttpProxy({url:INScrapMGridUrl+'?actiontype=queryItem',method:'GET'});
var INScrapMGridDs = new Ext.data.Store({
	proxy:INScrapMGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'inspi'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'pp'},
		{name:'ppAmt'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'inclbQty'},
		"OriginalStatus",
		"HVFlag","HVBarCode"
	]),
    remoteSort:false
});

//ģ��
var INScrapMGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'inspi',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"����Id",
        dataIndex:'inclb',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"incirowid",
        dataIndex:'inci',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
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
        editable:!UseItmTrack,
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
        header:"��ֵ��־",
        dataIndex:'HVFlag',
        width:60,
        align:'center',
        sortable:true,
        hidden:true
    },{
    	header:"��ֵ����",
    	dataIndex:'HVBarCode',
    	id:'HVBarCode',
    	width:150,
    	align:'left',
        hidden:!UseItmTrack,
        editable:UseItmTrack,
    	editor:HVBarCodeEditor
    },{
        header:"����~Ч��",
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"���ο��",
        dataIndex:'inclbQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��������",
        dataIndex:'qty',
        id:'adjQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
            allowNegative :false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
						var rowData = INScrapMGridDs.getAt(cell[0]);
						if(field.getValue()>Number(rowData.get('inclbQty'))){
							var col=GetColIndex(INScrapMGrid,'qty');
							INScrapMGrid.startEditing(cell[0], col);
						}else{
							addNewRow();
						}
					}
				}
			}
        })
    },{
        header:"��λrowid",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"��λ",
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�ۼ�",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        summaryType:'sum'
    },{
        header:"����",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        summaryType:'sum'
    },{
        header:"����",
        dataIndex:'pp',
        width:100,
        align:'right',
        hidden:true,
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'ppAmt',
        width:100,
        align:'right',
        hidden:true,
        sortable:true,
        summaryType:'sum'
    }, {
		header : "��������",
		dataIndex : 'OriginalStatus',
		width : 100,
		align : 'left',
		sortable : true
	}
]);
//��ʼ��Ĭ��������
INScrapMGridCm.defaultSortable = true;

var addINScrapM = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
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
			   		if (btn=='yes') {newInscrap();}
				}
			})		
		}else{
			newInscrap();
		}
	}
});
function newInscrap()
{
	mainRowId='';
	clearPage();
	addNewRow();
}
var findINScrapM = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			{
				Ext.Msg.show({
					title:'��ʾ',
					msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
					buttons: Ext.Msg.YESNO,
					fn: function(btn){
				   		if (btn=='yes') {clearPage();find();}
				   }
				})
			}	
		}else{
			find();
		}
	}
});
function find()
{
	if (Ext.getCmp('scrapWinFind')) {
		Ext.getCmp('scrapWinFind').show();
	}else{
		FindINScrap(selectInscrap);
	}
}

var clearINScpM = new Ext.Toolbar.Button({
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
					if (btn=='yes') {clearPage();SetFormOriginal(formPanel);}
				}
			})
		}else{
			clearPage();
			SetFormOriginal(formPanel);
		}
	}
});

var saveINScrapM = new Ext.ux.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(INScrapMGrid.activeEditor != null){
			INScrapMGrid.activeEditor.completeEdit();
		}
		if(CheckDataBeforeSave()==true){
			// ���汨��
			save();
		}
	}
});


var deleteINScrapM = new Ext.Toolbar.Button({
	text:'ɾ��',
	tooltip:'ɾ��',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var rowid=mainRowId;
		if(rowid!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ����ǰ����?',function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url : 'dhcstm.inscrapaction.csp?actiontype=delete&inscrap='+mainRowId,
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Msg.info("error", "������������!");
							return false;
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "ɾ���ɹ�!");
								clearPage();
								//INScrapMGridDs.load({params:{inscrap:mainRowId}});
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
			})
		}else{
			Msg.info('warning','û�б��𵥣����Ȳ�ѯ��');
			return;
		}
	}
});

var finshScp = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "����Ϊ��!���Ȳ�ѯ.");
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==true){return;}
			
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ��ɸñ�����?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcstm.inscrapaction.csp?actiontype=finish&InscpId='+mainRowId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "�������!");
									selectInscrap(mainRowId);
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "�����Ѿ����!");
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
				})
		}
	}
});

var noFinshScp = new Ext.Toolbar.Button({
	id:'noFinshScp',
	text:'ȡ�����',
	tooltip:'ȡ�����',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "����Ϊ��!���Ȳ�ѯ.");
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==false)	{	Msg.info("error", "�ñ�����δ���!");return;	}
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫȡ����ɸñ�����?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcstm.inscrapaction.csp?actiontype=noFinish&InscpId='+mainRowId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "�ɹ�ȡ���������״̬!");
									selectInscrap(mainRowId);
									
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "������δ���!");
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
	}
});

var printScp = new Ext.Toolbar.Button({
	text : '��ӡ',
	tooltip : '��ӡ����',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId ==null || mainRowId=="") {
			Msg.info("warning", "û����Ҫ��ӡ�ı���!");
			return;
		}
		PrintINScrap(mainRowId);
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:gHVInScrap?'��汨���Ƶ�(��ֵ)':'��汨���Ƶ�',
	tbar:[addINScrapM,'-',findINScrapM,'-',saveINScrapM,'-',deleteINScrapM,'-',clearINScpM,'-',finshScp,'-',noFinshScp,'-',printScp],
	items : [{
		xtype : 'fieldset',
		title : '������Ϣ',
		items : [{
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : .25,
				items : [inscrapNumField,locField,causeField]
			}, {
				columnWidth : .25,
				items : [dateField,timeField,userField]
			}, {
				columnWidth : .25,
				items : [groupField,remarkField]
			}, {
				columnWidth : .2,
				items : [finshCK]
			}]
		}]
	}]
});

//���
INScrapMGrid = new Ext.grid.EditorGridPanel({
	title:'��ϸ��¼',
	store:INScrapMGridDs,
	id:'INScrapMGrid',
	cm:INScrapMGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins : new Ext.grid.GridSummary(),
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{text:'������',iconCls:'page_gear',height:30,width:70,handler:function(){GridColSet(INScrapMGrid,"DHCSTINSCRAPM");}}]},
	clicksToEdit:1,
	listeners:{
		beforeedit:function(e){
			if(Ext.getCmp("finshCK").getValue()){
				return false;
			}
			if(e.field=="desc"|| e.field=="uom"){
				if(e.record.get("HVBarCode")!=""){
					e.cancel=true;
				}
			}
			if(e.field=="qty"){
				if(e.record.get("HVBarCode")!="" && e.record.get("OriginalStatus")!="NotUnique"){
					e.cancel=true;
				}
			}
			if(e.field=="HVBarCode" && e.record.get("inclb")!=""){
				e.cancel=true;
			}
		},
		afteredit:function(e){
			if(e.field=='qty'){
				if(e.value>Number(e.record.get('inclbQty'))){
					Msg.info("error","�����������ܴ������ο��!");
					return;
				}else{
					e.record.set("spAmt",accMul(e.value,e.record.get('sp')));
					e.record.set("rpAmt",accMul(e.value,e.record.get('rp')));
				}
			}
		}
	}
});

/***
**����Ҽ��˵�
**/
INScrapMGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
var rightClick = new Ext.menu.Menu({ 
	id:'rightClickCont', 
	items: [ 
		{ 
			id: 'mnuDelete', 
			handler: DeleteDetail, 
			text: 'ɾ��' 
		}
	] 
}); 
		
//�Ҽ��˵�����ؼ����� 
function rightClickFn(grid,rowindex,e){ 
	e.preventDefault(); 
	rightClick.showAt(e.getXY()); 
}

//=========================��汨���Ƶ�=============================	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "1", HospId,"",	returnInfo);	
	}
}
		
function addNewRow() {
	var descIndex = GetColIndex(INScrapMGrid,"desc");
	var barcodeIndex = GetColIndex(INScrapMGrid,"HVBarCode");
	var colIndex = gHVInScrap?barcodeIndex:descIndex;
	var rowCount = INScrapMGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = INScrapMGridDs.data.items[rowCount - 1];
		var data=rowData.get("inci")
		if(data=="" || data.length<=0){
			INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, colIndex);
		    return;
		}
	}
	//�ж������Ƿ��Ѿ�
	if  (Ext.getCmp('groupField').getRawValue()==''){
		Ext.getCmp('groupField').setValue(null);
	}

	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "��ѡ������!");
		return ;
	}
	var NewRecord = CreateRecordInstance(INScrapMGridDs.fields);
	INScrapMGridDs.add(NewRecord);
	INScrapMGrid.getSelectionModel().select(INScrapMGridDs.getCount() - 1, colIndex);
	INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, colIndex);
	
	setEditDisable();
}		

function clearPage()
{
	mainRowId="";
	//Ext.getCmp('locField').setValue("");
	//Ext.getCmp('locField').setRawValue("");
	Ext.getCmp('inscrapNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('adjUserField').setValue("");
		
	Ext.getCmp('causeField').setValue("");
	Ext.getCmp('causeField').setRawValue("");
	Ext.getCmp('remarkField').setValue("");
	
	Ext.getCmp('finshCK').setValue("");
	
	INScrapMGridDs.removeAll();
	
	this.deleteINScrapM.enable();
	this.saveINScrapM.enable();
	
	setEditEnable();
}

//���ҿ����������Ϣ���ڹر�ʱ�ص�����
function returnInfo(record, rowData) {
	if (Ext.isEmpty(record) || Ext.isEmpty(rowData)) {
		return;
	}
	var HVFlag=record.get("HVFlag");
	var inclb = record.get("Inclb");
	inciDr = record.get("InciDr");
	rowData.set("inci",inciDr);
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	rowData.set("batNo",record.get("BatExp"));
	rowData.set("manf",record.get("Manf"));
	rowData.set("uom",record.get("PurUomId"));
	rowData.set("uomDesc",record.get("PurUomDesc"));
	rowData.set("sp",record.get("Sp"));
	rowData.set("rp",record.get("Rp"));
	rowData.set("inclbQty",record.get("InclbQty"));
	rowData.set("inclb",record.get("Inclb"));
	
	if(record.get("InclbQty")<1){
		Msg.info("warning","���ÿ�治��!");
		return;
	}else{
		rowData.set("qty", 1);
		rowData.set("rpAmt", record.get("Rp"));
		rowData.set("spAmt", record.get("Sp"));
		addNewRow();
	}
}

function CheckDataBeforeSave(){
	var user = UserId;
	var locId = Ext.getCmp('locField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error","��ѡ��Ӧ����!");
		return false;
	}
	var scg = Ext.getCmp('groupField').getValue();
	if((scg=="")||(scg==null)){
		Msg.info("error","��ѡ������!");
		return false;
	}
	var scpReason = Ext.getCmp('causeField').getValue();
	if((scpReason=="")||(scpReason==null)){
		Msg.info("error","��ѡ����ԭ��!");
		return false;
	}
	
	//����Ƿ�����ϸ(�������½��ĵ���)
	if (mainRowId==''){
		var ListDetail="";
		var rowCnt=0;
		var rowCount = INScrapMGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				if (inclb=='') break;
				var uom = rowData.get("uom");
				if (uom=='') break;
				var qty = rowData.get("qty");
				if (qty=='') {
					Msg.info("warning","��"+(i+1)+"�б�������Ϊ��!");
					return;
				}
				var rpAmt = rowData.get("rpAmt");
				if (rpAmt=='') {
					Msg.info("warning","��"+(i+1)+"�н��۽��Ϊ��!");
					return;
				}
				
				rowCnt++;
			}
		}
		if (rowCnt==0){Msg.info('warning','û���κ���ϸ!��ֹ����.');return false;}
	}
	
	return true;
}

function save(){
	var scpUser = UserId;
	var scpNo = Ext.getCmp("inscrapNumField").getValue();
	var scpLoc = Ext.getCmp('locField').getValue();
	var scpComp = Ext.getCmp('finshCK').getValue()==true?'Y':'N';
	var scpReason = Ext.getCmp('causeField').getValue();
	var scpScg = Ext.getCmp('groupField').getValue();
	var remark = Ext.getCmp('remarkField').getValue();  //��ע
	var inscrapno = Ext.getCmp('inscrapNumField').getValue();
	
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	
	var tmpData = scpUser+"^"+scpLoc+"^"+scpComp+"^"+scpReason+"^"+scpScg+"^"+remark+"^"+inscrapno;
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INScrapMGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				var uom = rowData.get("uom");
				var qty = rowData.get("qty");
				var inclbQty=rowData.get("inclbQty");
				if(qty>inclbQty){
					Msg.info("warning","�����������ܴ������ο��");
					return;
				}
				if(qty<0){
					Msg.info("warning","������������С��0");
					return;
				}
				var Rp = rowData.get("rp");
				var rpAmt = rowData.get("rpAmt");
				var Sp = rowData.get("sp");
				var spAmt =rowData.get("spAmt");
				var Pp = rowData.get("pp");
				var ppAmt = rowData.get("ppAmt");
				var HVBarCode = rowData.get("HVBarCode");
				var rowStr = Inspi + "^" + inclb + "^"	+ uom + "^" + qty + "^"	+ Rp + "^" + rpAmt + "^"  + Pp + "^" + ppAmt + "^" + Sp+ "^" + spAmt
							+ "^" + HVBarCode;
				if(ListDetail==""){
					ListDetail=rowStr;
				}
				else{
					ListDetail=ListDetail+ xRowDelim() + rowStr;
				}
			}
		}
		
		Ext.Ajax.request({
			//url: INScrapMGridUrl+'?actiontype=save&inscrap='+mainRowId+'&MainInfo='+tmpData+'&ListDetail='+ListDetail,
			url: INScrapMGridUrl+'?actiontype=save',
			params: {inscrap:mainRowId,MainInfo:tmpData,ListDetail:ListDetail},
			method : 'POST',
			waitMsg : '������...',
			failure: function(result,request) {
				Msg.info("error","������������!");
			},
			success: function(result,request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );			
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					mainRowId = jsonData.info;
					
					selectInscrap(mainRowId);
				}	
				if(jsonData.success=='false'){
					Msg.info("error","����ʧ��!");
				}
			},
			scope: this
		});
	}	
}

		
// ��ʾ������ϸ����
function getDetail(InscpRowid) {

	if (InscpRowid == null || InscpRowid.length <= 0 || InscpRowid <= 0) {
		return;
	}
	INScrapMGridDs.removeAll();
	INScrapMGridDs.load({params:{start:0,limit:999,inscrap:InscpRowid}});
	

	// �����ť�Ƿ����
	//��ѯ^���^����^����^ɾ��^���^ȡ�����
	//var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	//if(inGrFlag==true){
		//Ext.getCmp("noFinshScp").setDisabled(false);
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
		//Ext.getCmp("noFinshScp").setDisabled(true);
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
		/**
		 * ɾ��ѡ��������
		 */
function DeleteDetail() {
	// �жϱ����Ƿ������
	var CmpFlag = Ext.getCmp("finshCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", "���������,��ֹɾ����ϸ��¼!");
		return;
	}
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "��ѡ������!");
		return;
	}
	// ѡ����
	var row = cell[0];
	var record = INScrapMGrid.getStore().getAt(row);
	var Inspi = record.get("inspi");
	if (Inspi == "" ) {
		INScrapMGrid.getStore().remove(record);
		INScrapMGrid.getView().refresh();
		if (INScrapMGrid.getStore().getCount()==0){
			setEditEnable();
		}			
	} else {
		Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȷ��ɾ����������Ϣ?',
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
		var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = INScrapMGrid.getStore().getAt(row);
		var Inspi = record.get("inspi");

		// ɾ����������
		var url = DictUrl+ "inscrapaction.csp?actiontype=deldetail&RowId=" + Inspi;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : 'ɾ����...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "ɾ���ɹ�!");
					INScrapMGrid.getStore().remove(record);
					INScrapMGrid.getView().refresh();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "�����Ѿ���ɣ�����ɾ��!");
					}else if(ret==-2){
						Msg.info("error", "�����Ѿ���ˣ�����ɾ��!");
					}else{
						Msg.info("error", "ɾ��ʧ��,��鿴������־!");
					}
				}
				if (INScrapMGrid.getStore().getCount()==0){
					setEditEnable();
				}	
			},
			scope : this
		});
	}
}


//����һ��(��ϸ)
function addDetailRow(){
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true)){
		Msg.info('warning','��ǰ�����������,��ֹ������ϸ��¼!');
		return;
	}
	addNewRow();
}
//ȡ��������������ݣ�����䵽�����
function selectInscrap(rowid)
{
	mainRowId=rowid;
	Ext.Ajax.request({
		url:inscrapUrl+'?actiontype=Select'+'&InscpId='+rowid,
		failure:function(){},
		success:function(result,request){
			
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.results>0) {
				data=jsonData.rows  ;
				var loc=data[0]['INSCP_CTLOC_DR'];
				var locDesc=data[0]['locDesc'];
				var scg=data[0]['INSCP_SCG_DR'];
				var scgDesc=data[0]['scgDesc'];
				var reason=data[0]['INSCP_Reason'];
				var reasonDesc=data[0]['reason'];
				var inscrapNo=data[0]['INSCP_NO'];
				var adjDate=data[0]['INSCP_Date'];
				var adjTime=data[0]['INSCP_Time'];
				var completeFlag=data[0]['INSCP_Completed'];
				var auditFlag=data[0]['INSCP_ChkFlag'];
				var remark=data[0]['INSCP_Remarks'];
				var userName=data[0]['userName'] ;
				var auditUserName=data[0]['INSCP_ChkUser_DR'];
				var chkDate=data[0]['INSCP_ChkDate'];
				var chkTime=data[0]['INSCP_ChkTime'];
			
				inscrapNumField.setValue(inscrapNo);
				locField.setValue(loc);
				locField.setRawValue(locDesc);
				dateField.setValue(adjDate);
				timeField.setValue(adjTime);
				userField.setValue(userName);
				
				if(completeFlag=='Y'){
					finshCK.setValue(true);
					saveINScrapM.disable();
					deleteINScrapM.disable();
					finshScp.disable();
				}else{
					finshCK.setValue(false);
					saveINScrapM.enable();
					deleteINScrapM.enable();
					finshScp.enable();
				}
				
				causeField.setValue(reason);
				causeField.setRawValue(reasonDesc);
				remark=handleMemo(remark,xMemoDelim());
				remarkField.setValue(remark);
				addComboData(null,scg,scgDesc,groupField);
				groupField.setValue(scg);
				SetFormOriginal(formPanel);
			
				//������ϸ
				getDetail(mainRowId);
			}	
		
			if (mainRowId>0)
			{
				setEditDisable();
			}
		}
	})
}

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INScrapMGrid],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INScrapMGrid,"DHCSTINSCRAPM");   //�����Զ�������������������
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
	var count1= INScrapMGrid.getStore().getCount();
	//�����������Ƿ����޸�
	//�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	};
	if (changed) return changed;
	//����ϸ�����Ƿ����޸�
	var count= INScrapMGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INScrapMGrid.getStore().getAt(index);	
				//���������ݷ����仯ʱִ����������
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}	
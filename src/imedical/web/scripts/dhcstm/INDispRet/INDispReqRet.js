// ����:�����˻�
// ��д����:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var gHospId = session['LOGON.HOSPID'];

//�������ֵ��object
var InDispReqRetParamObj = GetAppPropValue('DHCSTINDISPRETM');
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.indispretaction.csp';
var strParam = "";
var dsr = ""; //����ȫ�ֱ���:����rowid
var gDsrRetLocId = "";	//�˻ص����տ���

var DsrNo = new Ext.form.TextField({
	id:'DsrNo',
	fieldLabel:'�˻ص���',
	listWidth:150,
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// �˻ز���
var LocField= new Ext.ux.LocComboBox({
	fieldLabel : '�˻ز���',
	id : 'LocField',
	name : 'LocField',
	anchor:'90%',
	emptyText : '�˻ز���...',
	groupId:gGroupId
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

var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'��ע',
	anchor:'90%',
	height:75,
	selectOnFocus:true
});

var completeCK = new Ext.form.Checkbox({
	id: 'completeCK',
	boxLabel : '���',
	anchor:'90%',
	disabled:true,
	listeners : {
		check : function(checkBox, checked){
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

var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','���쵥'],['C','����ƻ�']]
})

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//find.btnEl.mask() 
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearDsRet();FindINDispRet(Ext.getCmp('LocField').getValue(),refresh);}
			   }	
			})	
		}else{
			FindINDispRet(Ext.getCmp('LocField').getValue(),refresh);
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
			   			clearDsRet();
			   			SetFormOriginal(formPanel);
					}
				}
			});
		}else{
			clearDsRet(); 
			SetFormOriginal(formPanel);
		}
	}
});

function clearDsRet()
{
	dsr="";
	gDsrRetLocId = "";
	InDsRetGridDs.removeAll();
	remark.setValue("");
	DsrNo.setValue("");  //groupField

	dateField.setValue(new Date());
	completeCK.setValue(false);
	del.enable();
	groupField.setValue("");
	groupField.setRawValue("");
	timeField.setValue("");
	userField.setValue("");

	Ext.getCmp('save').enable();
	add.setDisabled(false);
	Ext.getCmp('LocField').setDisabled(false);
	SetLogInDept(LocField.getStore(),'LocField');
	groupField.store.load();
	setEditEnable();
}

function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
	// ѡ����
	var row = cell[0];
	var rowData = InDsRetGridDs.getAt(row);
	rowData.set("inci",record.get("InciDr"));
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	
	//��Ӧ��id^��Ӧ������^����id^��������^������id^����������^��ⵥλid^��ⵥλ^����^�ۼ�^�깺���ҿ����^�������^�������^ͨ����^��Ʒ��^����^���
	//{success:'true',info:'7^GAYY-�����㰲ҽҩ��������^61^bjymzy-����������ҩ��^^^26^��[20Ƭ]^0^0^0^^^��˾����Ƭ^^��ͨƬ��^[1mg*20]'}
	//ȡ����������Ϣ
	
	var locId = Ext.getCmp('LocField').getValue();
	if(locId!=""){
		Ext.Ajax.request({
			url : 'dhcstm.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ record.get("InciDr")+'&locId='+locId,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
					var ManfId = data[2];
					var Manf = data[3];
					rowData.set("manf", data[3]);    //������
					
					var UomId=data[6];
					var Uom=data[7];
					rowData.set("uom", UomId);    //��λId
					rowData.set("uomDesc", Uom);    //��λ����
					rowData.set("sp", data[9]);     
					rowData.set("generic", data[13]);     
					rowData.set("drugForm", data[15]);   
					rowData.set("spec", data[16]);
				}
			},
			scope:this
		});
	}else{
		Msg.info("error","��ѡ�����!");
	}
	InDsRetGrid.startEditing(InDsRetGridDs.getCount() - 1, 6);
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,getDrugList2);
	}
}
//=========================����ȫ�ֱ���=================================
//=========================�˻ص�����Ϣ=================================
function addNewRow() {
	if ((dsr!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ�˻ص������');
		return false;
	}
	var NewRecord = CreateRecordInstance(InDsRetGridDs.fields);
	InDsRetGridDs.add(NewRecord);
	var col=GetColIndex(InDsRetGrid,'desc');
	InDsRetGrid.startEditing(InDsRetGridDs.getCount() - 1, col);
	setEditDisable();
}

//��������Դ
var InDsRetGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'GET'});
var InDsRetGridDs = new Ext.data.Store({
	proxy:InDsRetGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    	}, [
		{name:'rowid',mapping:'dsritm'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'manf'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'remark'},
		{name:'dispQty'},
		{name:'inclb'},
		{name:'indsi',mapping:'dsi'},
		{name:'availQty'},
		{name:'dsiRetQty'},
		{name:'retDirtyQty'},
		"Brand","Model","Abbrev"
	]),
	remoteSort:false
});

//ģ��
var InDsRetGridCm = new Ext.grid.ColumnModel([
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
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stkGrp=Ext.getCmp("groupField").getValue();
						//���Ҳ�ȷ�����˻�������
						InDispItmBat(Ext.getCmp('descField').getValue(),stkGrp,App_StkTypeCode,Ext.getCmp("LocField").getValue(),"",
								"","",HandleRet,gDsrRetLocId);
					}
				}
			}
        })
    },{
        header:"���",
        dataIndex:'Abbrev',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"Ʒ��",
        dataIndex:'Brand',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�ͺ�",
        dataIndex:'Model',
        width:100,
        align:'left',
        sortable:true
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
    	header:'����~Ч��',
    	dataIndex:'batNo',
    	width:200,
    	aligh:'left'
    },{
    	header:'Ч��',
    	dataIndex:'expDate',
    	width:80,
    	aligh:'left',
    	hidden:true
    },{
    	header:'��������',
    	dataIndex:'dispQty',
    	align:'right'
    },{
        header:"�˻�����",
        dataIndex:'qty',
        id:'colQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(InDsRetGrid,"remark");
						InDsRetGrid.startEditing(cell[0], col);
					}
				}
			}
        })
    },{
    	header:'����ռ��',
    	dataIndex:'dsiRetQty',
    	width:60,
    	align:'right',
    	hidden:true
    },{
    	header:'����ռ��',
    	dataIndex:'retDirtyQty',
    	width:60,
    	align:'right'
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
        sortable:true
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
						var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
						if(InDsRetGridDs.getAt(cell[0]).get('qty')==0){
							Msg.info("error","�˻���������Ϊ0!");
							var col=GetColIndex(InDsRetGrid,"qty");
							InDsRetGrid.startEditing(InDsRetGridDs.getCount() - 1, col);
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
    	header:'inclb',
    	dataIndex:'inclb',
    	hidden:true
    },{
    	header:'indsi',
    	dataIndex:'indsi',
    	hidden:true
    }
]);

var add = new Ext.Toolbar.Button({
	text:'�½�',
	id:'newReq',
	iconCls:'page_add',
	tooltip:'�½����ת���˻ص�',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'��ʾ',
				msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
			   		if (btn=='yes') {clearDsRet();}
				}
			})
		}else {
			clearDsRet();
		}
	}
});

function saveDsRet()
{  
	//������Ϣ
	//�˻ز���
	var toLoc = Ext.getCmp('LocField').getValue(); 
	if((toLoc=="")||(toLoc==null)){
		Msg.info("error", "��ѡ���˻ز���!");
		return false;
	}
	//��½�û�
	var user = UserId;
	//����
	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "��ѡ������!");
		return false;
	}
	
	//��ע
	var remark = Ext.getCmp('remark').getValue(); 
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var RetLocId = gDsrRetLocId;
	if(RetLocId==""){
		RetLocId = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",toLoc);
		if(RetLocId==""){
			Msg.info("warning","�˻ؿ���Ϊ��!");
			return;
		}
	}
	//������Ϣ�ַ���
	var dsrInfo = toLoc+"^"+user+"^"+scg+"^"+App_StkTypeCode+"^"+remark+"^"+RetLocId;
	//�ӱ���ϸ
	var data = "";
	var count= InDsRetGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InDsRetGridDs.getAt(index);	
		//���������ݷ����仯ʱִ����������
		if(rec.data.newRecord || rec.dirty){
			var inc = rec.data['inci'];
			var rowid= rec.data['rowid']
			var inclb= rec.data['inclb'];
			var qty = rec.data['qty'];
			var uom=rec.data['uom'];
			var rp= rec.data['rp'];
			var sp= rec.data['sp'];
			var rpAmt= rec.data['rpAmt'];
			var spAmt= rec.data['spAmt'];
			var indsi= rec.data['indsi'];
			var colRemark=rec.data['remark'];
			if((inclb!="")&&(inclb!=null)&&(qty!="")&&(qty!=null)&&(qty!=0)){
				var tmp = rowid+"^"+inclb+"^"+qty +"^"+uom+"^"+rp+"^"+rpAmt+"^"+sp+"^"+spAmt+"^"+indsi+"^"+colRemark;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
	}
	
	if ( (dsr=='')&& (data=="")) {Msg.info("error", "û��������Ҫ����!");return false;};	
	if(!IsFormChanged(formPanel) && data==""){Msg.info("error", "û��������Ҫ����!");return false;};
	
	Ext.Ajax.request({
		url : URL+'?actiontype=SaveDispRet',
		params:{dsr:dsr,mainData:dsrInfo,detailData:data},
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "����ɹ�!");
				dsr = jsonData.info;
				refresh(dsr);
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
}

var save = new Ext.ux.Button({
	text:'����',
	id:'save',
	tooltip:'����',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(InDsRetGrid.activeEditor!=null){
			InDsRetGrid.activeEditor.completeEdit();
		}
		//����ʱ���������ַ���
		//1.����rowid
		//2.�������Ϣ��frLoc��toLoc��user��scg��status��remark
		//3.�ӱ���ϸ��Ϣ��dsr����ϸ�ַ���rows(rows��Ϣ��reqi(��ϸrowid)��data(inci��uom��qty))
		saveDsRet();
	}
});

function refresh(dsr){
	Select(dsr);
	InDsRetGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsr:dsr}});
}

function Select(dsrId){
	if(dsrId==null || dsrId==''){
		return;
	}
	dsr=dsrId;
	Ext.Ajax.request({
		url : URL+'?actiontype=select&dsr='+dsrId,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);

			if (jsonData.results>0) {
				var data=jsonData.rows;
				if (!data) return;
				gDsrRetLocId = data[0]['DSR_RetLOC_DR'];
				Ext.getCmp('DsrNo').setValue(data[0]['DSR_No']);
				addComboData(Ext.getCmp('LocField').getStore(),data[0]['DSR_CTLOC_DR'],data[0]['locDesc']);
				Ext.getCmp('LocField').setValue(data[0]['DSR_CTLOC_DR']);
				Ext.getCmp('LocField').setDisabled(true);
				Ext.getCmp('dateField').setValue(data[0]['DSR_Date']);
				Ext.getCmp('timeField').setValue(data[0]['DSR_Time']); 
				Ext.getCmp('userField').setValue(data[0]['userName']); 
				addComboData(groupField.getStore(),data[0]['DSR_SCG_DR'],data[0]['scgDesc']);
				Ext.getCmp('groupField').setValue(data[0]['DSR_SCG_DR']);
				
				var completedFlag=data[0]['DSR_Completed'];
				Ext.getCmp("completeCK").setValue(completedFlag=="Y");
				Ext.getCmp("completeCK").fireEvent('check',Ext.getCmp("completeCK"),completedFlag=="Y");
				var remark=data[0]['remark'];
				remark=handleMemo(remark,xMemoDelim());
				Ext.getCmp('remark').setValue(remark);
				setEditDisable();
				SetFormOriginal(formPanel);
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
		if (dsr=='') 
		{
			Msg.info('warning','û���κ��˻ص���');
			return ;
		}
		var completedFlag=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((completedFlag=="N")||(completedFlag=="")||(completedFlag==null)){
			Ext.Ajax.request({
				url : URL+'?actiontype=setComplete&dsr='+dsr+'&completedFlag=Y',
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȷ����ɳɹ�!");
						completeCK.setValue(true);
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
		if (dsr=='') 
		{
			Msg.info('warning','û���κ��˻ص���');
			return ;
		}
		var completedFlag=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if(completedFlag=="Y"){
			Ext.Ajax.request({
				url : URL+'?actiontype=cancelComplete&dsr='+dsr+'&completedFlag=N',
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ����ɳɹ�!");
						completeCK.setValue(false);
					}else{
						if(jsonData.info==-2){
							Msg.info("error", "����ʧ��!"+jsonData.info);
						}else if(jsonData.info==-1){
							Msg.info("error", "��ǰ�˻ص���תΪ��ʽ���ת�Ƶ�,��ֹȡ�����!");
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

function delReq(){
	if(dsr==null || dsr==""){
		Msg.info("warning","��ѡ��Ҫɾ�����˻ص�!");
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
					url:URL+"?actiontype=Delete",
					method:'POST',
					params:{dsr:dsr},
					success:function(response,opts){
						var jsonData=Ext.util.JSON.decode(response.responseText);
						if(jsonData.success=='true'){
							Msg.info("success","ɾ���ɹ�!");
							Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
				   			clearDsRet();
				   			SetFormOriginal(formPanel);
						}else{
							if(jsonData.info==-1){
								Msg.info("warning","���˻ص�����ɣ�������ɾ����");
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
	tooltip : '��ӡ�˻ص�',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if(dsr==null || dsr==""){
			Msg.info("warning","û����Ҫ��ӡ���˻ص�!");
			return;
		}
		PrintDsr(dsr);
	}
});

//ɾ��ת���˻���ϸ
function DeleteDetail(){
	if ((dsr!="")&&(Ext.getCmp('completeCK').getValue()==true))
	{
		Msg.info('warning','��ǰ�˻ص������');
		return;
	}
	
	var cell = InDsRetGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("error","��ѡ������!");
		return false;
	}
	else{
		var record = InDsRetGridDs.getAt(cell[0]);
		var reqItm = record.get("rowid");
		if(reqItm!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : URL+'?actiontype=deleteItem&rowid='+reqItm,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									InDsRetGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',dsr:dsr}});
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
		}
		else{
			InDsRetGridDs.remove(record);
			InDsRetGrid.getView().refresh();
		}
	
		if (InDsRetGridDs.getCount()==0){
			setEditEnable();
		}
	}
}

//��ʼ��Ĭ��������
InDsRetGridCm.defaultSortable = true;

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'����һ����ϸ��¼',
	height : 30,
	width : 70,
	iconCls:'page_add',
	handler:function(){
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("warning", "��ѡ���˻ز���!");
			return ;
		}

		//����
		var scg = Ext.getCmp('groupField').getValue(); 
		if((scg=="")||(scg==null)){
			Msg.info("warning", "��ѡ������!");
			return false;
		}
		var rowCount =InDsRetGrid.getStore().getCount();
		if(rowCount>0){
			var rowData = InDsRetGridDs.data.items[rowCount - 1];
			var data=rowData.get("inci")
			if(data=="" || data.length<=0){
				Msg.info("warning","�Ѵ����½���");
				return;
			}
		}
		addNewRow();
	}
})
var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'ɾ��һ����ϸ��¼',
	height : 30,
	width : 70,
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
})

var InDsRetGrid = new Ext.ux.EditorGridPanel({
	region : 'center',
	id:'reqItmEditGrid',
	store:InDsRetGridDs,
	cm:InDsRetGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	sm:new Ext.grid.CellSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT],
	listeners:{
		beforeedit : function(e){
			return !Boolean(Ext.getCmp('completeCK').getValue());
		},
		afteredit:function(e){
			if(e.field=="qty"){
				var dispQty=Number(e.record.get('dispQty'));	//��������
				var retDirtyQty=Number(e.record.get('retDirtyQty'));
				
				if(e.value-retDirtyQty-dispQty>0){
					Msg.info('error','�˻�����������!');
					e.record.set('qty',e.originalValue);
					return;
				}
				e.record.set("rpAmt",accMul(e.value,e.record.get('rp')));
				e.record.set("spAmt",accMul(e.value,e.record.get('sp'))); 
			}
		}
	}
});

//zdm,�����Ҽ�ɾ����ϸ����
InDsRetGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
	e.preventDefault();
	rightClickMenu.showAt(e.getXY());
});

var rightClickMenu=new Ext.menu.Menu({
	id:'rightClickMenu',
	items:[{id:'mnuDelete',text:'ɾ��',handler:DeleteDetail}]
});

//=========================�˻ص�����Ϣ=================================

//===========ģ����ҳ��===========================================

var formPanel = new Ext.ux.FormPanel({
	title:'�����˻��Ƶ�',
	tbar:[find,'-',add,'-',save,'-',del,'-',complete,'-',cancelComplete,'-',clear,'-',printBT],
	items : [{
		xtype : 'fieldset',
		title : '�˻ص���Ϣ',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
			columnWidth:0.3,
			items : [LocField,groupField,DsrNo]
		},{
			columnWidth : 0.25,
			items : [dateField,timeField,userField]
		},{
			columnWidth : 0.25,
			items : [remark]
		},{
			columnWidth : 0.2,
			items : [completeCK]
		}]
	}]
	
});

//�鿴�˻ص������Ƿ����޸�
function isDataChanged()
{
	var changed=false;
	var count1= InDsRetGrid.getStore().getCount();
	//�����������Ƿ����޸�
	//�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	}
	if (changed) return changed;
	//����ϸ�����Ƿ����޸�
	var count= InDsRetGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = InDsRetGridDs.getAt(index);	
				//���������ݷ����仯ʱִ����������
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
		items : [formPanel,InDsRetGrid]
	});
});

//===========ģ����ҳ��===========================================
 ///���ÿɱ༭�����disabled����
function setEditDisable(){
	Ext.getCmp('LocField').setDisabled(true);
	Ext.getCmp('groupField').setDisabled(true);
}
 ///�ſ��ɱ༭�����disabled����
function setEditEnable(){
	Ext.getCmp('LocField').setDisabled(false);
	Ext.getCmp('groupField').setDisabled(false);
}

function HandleRet(selectRows)
{
	var rowCnt=selectRows.length;
	for (var i=0;i<rowCnt;i++)
	{
		var rec=selectRows[i];
		var inclb = rec.get('inclb');
		var indsi =rec.get('indsi');
		var retqty =rec.get('retQty');
		var dispQty = rec.get('dispQty');
		var dsiRetQty = rec.get('dsiRetQty');
		//var retDirtyQty = rec.get('retDirtyQty');
		var uom =rec.get('dispUom');
		var uomDesc =rec.get('dispUomDesc');
		var inci=rec.get('inci');
		var code=rec.get('inciCode');
		var desc=rec.get('inciDesc');
		var spec=rec.get('spec');
		var batNo=rec.get('batNo');
		var expDate=rec.get('expDate');
 		var manf=rec.get('manf');
		var rp =rec.get('rp');
		var sp=rec.get('sp');
		
		var rpAmt=accMul(rp,retqty)
		var spAmt=accMul(sp,retqty)
		
		var findIndex=InDsRetGridDs.findExact('indsi',indsi,0);
		var curRow=InDsRetGrid.getSelectionModel().getSelectedCell()[0];
		if(findIndex>=0 && findIndex!=curRow){
			Msg.info("warning",desc+":"+batNo+"~"+expDate+"�Ѵ����ڵ�"+(findIndex+1)+"��,�����½���¼!");
			continue;
		}else if(findIndex>=0 && findIndex==curRow){
			var recX=InDsRetGridDs.getAt(curRow);
		}else{
			if (i>0){addNewRow();}
			var lastRow=InDsRetGridDs.getCount()-1;
			var recX=InDsRetGridDs.getAt(lastRow);
		}
		
		recX.set('inclb',inclb);
		recX.set('indsi',indsi);
		recX.set('dispQty',dispQty);
		recX.set('qty',retqty);
		recX.set('dsiRetQty',dsiRetQty);
		recX.set('retDirtyQty',0);
		recX.set('uom',uom);
		recX.set('uomDesc',uomDesc);
		recX.set('inci',inci);
		recX.set('code',code);
		recX.set('desc',desc);
		recX.set('spec',spec);
		recX.set('manf',manf);
		recX.set('batNo',batNo+"~"+expDate);
		recX.set('expDate',expDate);
		recX.set('rp',rp);
		recX.set('rpAmt',rpAmt);
		recX.set('sp',sp);
		recX.set('spAmt',spAmt);
		recX.set('Brand',rec.get('Brand'));
		recX.set('Model',rec.get('Model'));
		recX.set('Abbrev',rec.get('Abbrev'));
	}
	
	var lastIndex=InDsRetGridDs.getCount()-1;
	if(InDsRetGridDs.getAt(lastIndex).get('indsi')!=""){
		addNewRow();
	}else{
		var col=GetColIndex(InDsRetGrid,'desc')
		InDsRetGrid.startEditing(lastIndex,col);
	}
}

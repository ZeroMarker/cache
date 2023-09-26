// ����:�ɹ��ƻ���----����ת��
// ��д����:2012-06-27
//=========================����ȫ�ֱ���=================================
var InRequestId = "";
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var GroupId=session['LOGON.GROUPID']
var arr = window.status.split(":");
var length = arr.length;
var URL = 'dhcst.inpurplanaction.csp';
var strParam = "";
var scgflag=""
var stkGrpId=""
if(gParamCommon.length<1){
	GetParamCommon();  
}
var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'��Ӧ����',
	anchor:'90%',
	listWidth:210,
	emptyText:'��Ӧ����...',
	groupId:session['LOGON.GROUPID']
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'��ʼ����',
	anchor:'90%',
	value:DefaultStDate()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'��ֹ����',
	anchor:'90%',
	value:DefaultEdDate()
});

var planNnmber = new Ext.form.TextField({
	id:'planNnmber',
	fieldLabel:'�ƻ�����',
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

var onlyRequest = new Ext.form.Checkbox({
	id: 'onlyRequest',
	fieldLabel:'������ƻ�',
	checked:true,
	allowBlank:true
});

var onlyNoTrans = new Ext.form.Checkbox({
	id: 'onlyNoTrans',
	fieldLabel:'��δת��ҩƷ',
	checked:true,
	allowBlank:true
});

var find = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		InRequestGridDs.removeAll();
		var locId = Ext.getCmp('LocField').getValue();
		if(locId==""){
			Msg.info("warning","��ѡ����Ҫ��ѯ�Ĺ�Ӧ����!");
			return;
		}
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}
		var requestType = (Ext.getCmp('onlyRequest').getValue()==true?'C':"");
		//strParam:��Ӧ����RowId^��ʼ����^��ֹ����^��������
		strParam = locId+"^"+startDate+"^"+endDate+"^"+requestType+"^"+UserId;
		InRequestGridDs.setBaseParam('strParam',strParam);
		
		InRequestDetailGrid.store.removeAll();
		grid.store.removeAll();
		InRequestGridDs.removeAll();
		InRequestGridDs.load({params:{start:0,limit:InRequestPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
	}
});

var clear = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		SetLogInDept(LocField.getStore(),"LocField")
		Ext.getCmp('startDateField').setValue(DefaultStDate());
		Ext.getCmp('endDateField').setValue(DefaultEdDate());
		Ext.getCmp('onlyRequest').setValue(true);
		Ext.getCmp('onlyNoTrans').setValue(true);
		Ext.getCmp('planNnmber').setValue("");		
		InRequestGrid.getStore().removeAll();
		InRequestGrid.getView().refresh();		
		InRequestDetailGrid.getStore().removeAll();
		InRequestDetailGrid.getView().refresh();
		grid.getStore().removeAll();
		grid.getView().refresh();
	}
});

var edit = new Ext.Toolbar.Button({
	text:'���ɲɹ��ƻ�',
    tooltip:'���ɲɹ��ƻ�',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('LocField').getValue();
		var count = gridDs.getCount();
		var listReqId = "";
		for(var k=0;k<count;k++){
			if(listReqId==""){
				listReqId = gridDs.getAt(k).get('DetailIdStr');
			}else{
				listReqId = listReqId +"^"+ gridDs.getAt(k).get('DetailIdStr');
			}
		}
		if(listReqId==""){
			Msg.info("warning","��ѡ����Ҫ���ɲɹ��ƻ�������!");
			return;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url:URL,
			method:'POST',
			params:{actiontype:'create',userId:UserId,locId:locId,listReqId:listReqId,stkGrpId:stkGrpId},
			success:function(result,request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if(jsonData.success=='true'){
					window.location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
				}else{
					if(jsonData.info==-1){
						Msg.info("error","���һ���ԱΪ��!");
					}else if(jsonData.info==-99){
						Msg.info("error","����ʧ��!");
					}else if(jsonData.info==-2){
						Msg.info("error","���ɼƻ�����ʧ��!");
					}else if(jsonData.info==-3){
						Msg.info("error","���ɼƻ���ʧ��!");
					}else if(jsonData.info==-4){
						Msg.info("error","���ɼƻ�����ϸʧ��!"+jsonData.info);
					}else{
						Msg.info("error","���ɲɹ��ƻ���ʧ��!"+jsonData.info);
					}
				}
				loadMask.hide();
			},
			scope:this
		});
	}
});
//=========================����ȫ�ֱ���=================================
//=========================��������Ϣ=================================
var sm = new Ext.grid.CheckboxSelectionModel({
	header:"",
	checkOnly:true,
	listeners:{
		beforerowselect:function(sm){if(sm.getCount()==0){scgflag=""}}
	}
}); 

var InRequestGrid="";
//��������Դ
var InRequestGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=INReqM',method:'GET'});
var InRequestGridDs = new Ext.data.Store({
	proxy:InRequestGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty : "results",
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'ReqNo'},
		{name:'ReqLocId'},
		{name:'ReqLoc'},
		{name:'StkGrpId'},
		{name:'StkGrp'},
		{name:'Date'},
		{name:'Time'},
		{name:'User'}
	]),
    remoteSort:false
});
//ģ��
var InRequestGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"���󵥺�",
        dataIndex:'ReqNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"������",
        dataIndex:'ReqLoc',
        width:130,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'StkGrp',
        width:70,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ�����",
        dataIndex:'Date',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ�ʱ��",
        dataIndex:'Time',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ���",
        dataIndex:'User',
        width:60,
        align:'left',
        sortable:true
    }//,sm
]);

//��ʼ��Ĭ��������
InRequestGridCm.defaultSortable = true;

var InRequestPagingToolbar = new Ext.PagingToolbar({
    store:InRequestGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
InRequestGrid = new Ext.grid.EditorGridPanel({
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	height:220,
	stripeRows:true,
	sm:sm,
	loadMask:true,
	bbar:InRequestPagingToolbar
});
//=========================��������Ϣ=================================

//=========================������ϸ=============================
var sm1 = new Ext.grid.CheckboxSelectionModel({
	checkOnly:true
});
var InRequestDetailGrid="";
//��������Դ
var InRequestDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=INReqD',method:'GET'});
var InRequestDetailGridDs = new Ext.data.Store({
	proxy:InRequestDetailGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty : "results",
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'Locqty'},
		{name:'ReqQty'},
		{name:'TransQty'},
		{name:'ReqUomId'},
		{name:'ReqUom'}
	]),
    remoteSort:true,
    pruneModifiedRecords:true
});

//ģ��
var InRequestDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:"����",
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'IncDesc',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'ReqUom',
        width:80,
        align:'left',
        sortable:true
     },{
        header:"����������",
        dataIndex:'Locqty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��������",
        dataIndex:'ReqQty',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"��ת������",
        dataIndex:'TransQty',
        width:100,
        align:'right',
        sortable:true
    },sm1
]);

//��ʼ��Ĭ��������
InRequestDetailGridCm.defaultSortable = true;

var InRequestDetailPagingToolbar = new Ext.PagingToolbar({
    store:InRequestDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼"
});

//���
InRequestDetailGrid = new Ext.grid.EditorGridPanel({
	store:InRequestDetailGridDs,
	cm:InRequestDetailGridCm,
	trackMouseOver:true,
	height:220,
	stripeRows:true,
	sm:sm1,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false
	//���ʺ�ʹ�÷�ҳ������
//	,
//	bbar:InRequestDetailPagingToolbar
});
//=========================������ϸ=============================

//=========================�ɹ���ϸ===============================
function addNewMXRow() {
	var mxRecord = Ext.data.Record.create([
		{
			name : 'IncId',
			type : 'int'
		},{
			name : 'IncCode',
			type : 'string'
		}, {
			name : 'IncDesc',
			type : 'string'
		}, {
			name : 'UomId',
			type : 'int'
		}, {
			name : 'Uom',
			type : 'string'
		}, {
			name : 'Qty',
			type : 'int'
		}, {
			name : 'Rp',
			type : 'double'
		}, {
			name : 'VendorId',
			type : 'int'
		}, {
			name : 'Vendor',
			type : 'string'
		}, {
			name : 'DetailIdStr',
			type : 'string'
		}
	]);
					
	var MXRecord = new mxRecord({
		IncId:'',
		IncCode:'',
		IncDesc:'',
		UomId:'',
		Uom:'',
		Qty:'',
		Rp:'',
		VendorId:'',
		Vendor:'',
		DetailIdStr:''
	});
		
	gridDs.add(MXRecord);
	grid.getSelectionModel().selectRow(gridDs.getCount()-1,true); 
}

//��������Դ
var gridProxy= new Ext.data.HttpProxy({url:URL,method:'GET'});
var gridDs = new Ext.data.Store({
	proxy:gridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'UomId'},
		{name:'Uom'},
		{name:'Locqty'},
		{name:'Qty'},
		{name:'Rp'},
		{name:'VendorId'},
		{name:'Vendor'},
		{name:'DetailIdStr'},
		{name:'ManfredId'},
		{name:'Manf'}
	]),
    remoteSort:false
});

//ģ��
var gridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
        header:"ҩƷId",
        dataIndex:'IncId',
        width:180,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'IncCode',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'IncDesc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"��λId",
        dataIndex:'UomId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"��λ",
        dataIndex:'Uom',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����������",
        dataIndex:'Locqty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��������",
        dataIndex:'Qty',
        width:100,
        align:'right',
        sortable:true
   },{
        header:"��ת������",
        dataIndex:'TransQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����",
        dataIndex:'Rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"��Ӧ��Id",
        dataIndex:'VendorId',
        width:200,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"��Ӧ��",
        dataIndex:'Vendor',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"������ϸrowId",
        dataIndex:'DetailIdStr',
        width:300,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����Id",
        dataIndex:'ManfId',
        width:200,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'Manf',
        width:200,
        align:'left',
        sortable:true
    }
]);

//��ʼ��Ĭ��������
gridCm.defaultSortable = true;
//���
grid = new Ext.grid.EditorGridPanel({
	store:gridDs,
	cm:gridCm,
	trackMouseOver:true,
	height:260,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel(),
	loadMask:true,
	clicksToEdit:1
});
//=========================�ɹ���ϸ===============================
//ѡ��������ϸ
var singleSelectFun = function(record){
	//����ͬһ����ϸ��ʱ��,���������ٱ����
	var bool = false;
	//ҩƷId
	var IncId = record.get('IncId');
	var index = gridDs.findExact('IncId',IncId);
	//��ϸId
	var rowId = record.get('RowId');
	if((Ext.getCmp('onlyNoTrans').getValue()==true)&&(record.get('TransQty')==record.get('ReqQty'))){return;}
	if(gridDs.getCount()!=0){
		if(index>=0){
			var arr = gridDs.getAt(index).get('DetailIdStr').split("^");
			var length = arr.length;
			for(var j=0;j<length;j++){
				if(arr[j]==rowId){
					bool = true;
				}
			}
		}
	}
	///���鲻�����ʱ,���������,yunhaibao20151012
	if (gridDs.getCount()>0){
		var tmpRowData = grid.getStore().getAt(gridDs.getCount()-1);
		var AddIncId=tmpRowData.get("IncId");
		var tmpscgdescstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetIncStkCatGrp",IncId)  //��ϸ����
		var tmpstkgrpdescstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetIncStkCatGrp",AddIncId)  //�Ѽ����б�����
		if(gParamCommon[9]!="Y"){
			if (tmpstkgrpdescstr!=tmpscgdescstr){
				//Msg.info("warning", "��ѡ��������ͬ�����ɲɹ��ƻ���!");
				return;
			}
		}		
	}		
	if(bool==false){
		if(index>=0){
			var rowData = gridDs.getAt(index);
			rowData.set("Qty",accAdd(rowData.get('Qty'),record.get('ReqQty')));
			rowData.set("TransQty",accAdd(rowData.get('TransQty'),record.get('TransQty')));
			rowData.set("DetailIdStr",rowData.get('DetailIdStr')+"^"+rowId);
		}else{
			addNewMXRow();
			var rowData = grid.getStore().getAt(gridDs.getCount()-1);
			rowData.set("IncId",IncId);
			rowData.set("IncCode",record.get('IncCode'));
			rowData.set("IncDesc",record.get('IncDesc'));
			rowData.set("UomId",record.get('ReqUomId'));
			rowData.set("Uom",record.get('ReqUom'));
			rowData.set("Locqty",record.get('Locqty'));
			rowData.set("TransQty",record.get('TransQty'));
			rowData.set("Qty",record.get('ReqQty'));
			rowData.set("DetailIdStr",rowId);
			//���������ȡ
			var LocId = Ext.getCmp('LocField').getValue();
			
           var Params=GroupId+"^"+LocId+"^"+UserId
			if(LocId!=""){
				Ext.Ajax.request({
					url : 'dhcst.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ IncId+'&locId='+LocId,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
						if (jsonData.success == 'true') {
							var data=jsonData.info.split("^");
							rowData.set("Rp",data[8]);
							rowData.set("VendorId",data[0]);
							rowData.set("Vendor",data[1]);
							rowData.set("ManfId",data[2]);
							rowData.set("Manf",data[3]);
							//==========��Ӧ�������ж�==========
							var vendor=data[0]
							var inci=rowData.get("IncId")
							var phmanf=data[2]
							var DataList=vendor+"^"+inci+"^"+phmanf
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
							//==========��Ӧ�������ж�==========
						} 
					},
					scope : this
				});
			}else{
				Msg.info("error", "��ѡ�����!");
			}
		}
	}
};

//ȡ��������ϸ
var singleDeSelectFun = function(record){
	//��ȡҩƷ��Id��Index
	var index = gridDs.findExact('IncId',record.get('IncId'));
	if(index>=0){
		var rowData = grid.getStore().getAt(index);
		var qty = accAdd(rowData.get('Qty'),-record.get('ReqQty'));
		var TransQty = accAdd(rowData.get('TransQty'),-record.get('TransQty'));
		if(qty==0){
			gridDs.remove(rowData);
		}else{
			rowData.set("Qty",qty);
			rowData.set("TransQty",TransQty);
		
			var rowId = record.get('RowId');
			var arr = rowData.get('DetailIdStr').split("^");
			var length = arr.length;
			var newDetailId = "";
			for(var i=0;i<length;i++){
				detailId = arr[i];
				if(detailId!=rowId){
					if(newDetailId==""){
						newDetailId = detailId;
					}else{
						newDetailId = newDetailId+"^"+detailId;
					}
				}
			}
			rowData.set("DetailIdStr",newDetailId);
		}
	}
};

//=============��������Ϣ��������ϸ��������===================
InRequestGrid.on('cellclick',function(grid, rowIndex, columnIndex, e) {
	
	///if(sm.getCount()==0){scgflag="";};
	var selectedRow = InRequestGridDs.data.items[rowIndex];
	InRequestId = selectedRow.data["RowId"];
	var scgdesc=selectedRow.data["StkGrp"];	
	///���鲻�����ʱ,���������,yunhaibao20151012
	if (gridDs.getCount()>0){
		var tmpRowData = gridDs.getAt(gridDs.getCount()-1);
		var AddIncId=tmpRowData.get("IncId");
		var tmpstkgrpdescstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetIncStkCatGrp",AddIncId)  //�Ѽ����б�����
		if (tmpstkgrpdescstr.indexOf(scgdesc)<0){
			Msg.info("warning", "��ѡ��������ͬ�����ɲɹ��ƻ���!");
			return;
		}		
	}
	if (scgflag==""||scgflag==scgdesc){
		stkGrpId=selectedRow.data["StkGrpId"];
		InRequestDetailGridDs.proxy = new Ext.data.HttpProxy({url:URL+'?actiontype=INReqD',method:'GET'});
		InRequestDetailGridDs.setBaseParam('parref',InRequestId);
		var LocId = Ext.getCmp('LocField').getValue();
		InRequestDetailGridDs.setBaseParam('locId',LocId);
		InRequestDetailGridDs.setBaseParam('start',0);
		//InRequestDetailGridDs.setBaseParam('limit',InRequestDetailPagingToolbar.pageSize);
		InRequestDetailGridDs.setBaseParam('limit',999);
		InRequestDetailGridDs.setBaseParam('sort','RowId');
		InRequestDetailGridDs.setBaseParam('dir','desc')
		
		if(columnIndex==7){
			if(sm.isSelected(rowIndex)==true){
				InRequestDetailGridDs.load({
					callback:function(){
						sm1.selectAll();
					}
				})
			}else{
				InRequestDetailGridDs.load({
					callback:function(){
						var end=InRequestDetailGridDs.getCount();
						sm1.deselectRange(0,end);
					}
				});
			}
		}else{
			InRequestDetailGridDs.load({
					callback:function(){
						if(Ext.getCmp('onlyNoTrans').getValue()==true){
							sm1.selectAll();
						}
					}
				});
		}
	}else{
		Msg.info("warning", "��ѡ��������ͬ�����ɲɹ��ƻ���!");
		sm.deselectRow(rowIndex);
	}
});

//=============������ϸ��ɹ���ϸ��������===================
InRequestDetailGrid.getSelectionModel().on("rowselect",function(sm1,rowIndex,record){
	singleSelectFun(record);
});
InRequestDetailGrid.getSelectionModel().on("rowdeselect",function(sm1,rowIndex,record){
	singleDeSelectFun(record);
});
//=============������ϸ��ɹ���ϸ��������===================

//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 90,
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		title:'�ɹ��ƻ�-��������',
		//bodyStyle : 'padding:5px;',
		tbar:[find,'-',clear,'-',edit],
		items : [{
			layout : 'column',
			xtype:'fieldset',
			title:'��ѯ����',
			defaults:{border:false},
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{
						columnWidth : .2,
						xtype:'fieldset',
						items : [LocField]
					},{
						columnWidth : .2,
						xtype:'fieldset',
						items : [startDateField]
					},{
						columnWidth : .2,
						xtype:'fieldset',
						items : [endDateField]
					
					},{
						columnWidth : .1,
						xtype:'fieldset',
						items : [onlyRequest]
					},{
						columnWidth : .12,
						xtype:'fieldset',
						items : [onlyNoTrans]
					}]
		}]
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(1),
			layout:'fit',
			items:[formPanel]
		},{
			region:'west',
			title:'������Ϣ----<font color=blue>��ѡ����ͬ��������һ���ɹ��ƻ���</font>',
			width:650,
			minSize:150,
			maxSize:300,
			split:true,
			collapsible:true,
			layout:'fit',
			items:[InRequestGrid]
		},{
			region:'center',
			title:'������ϸ��Ϣ',
			layout:'fit',
			items:[InRequestDetailGrid]
		},{
			region:'south',
			title:'�ɹ��ƻ�����ϸ��Ϣ',
			height:250,
			minSize:200,
			maxSize:350,
			split:true,
			layout:'fit',
			items:[grid]
		}]
	});
});
//===========ģ����ҳ��===========================================
// ����:����¼��
// ��д����:2013-01-21
var deptId = 0;
var deptName = "";
var poId = "";
var poNo = "";
var mainRowId="";
var reasonId = "";
//var newqty="";
var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";
var rpdecimal=2;
var spdecimal=2;
var GroupId=session['LOGON.GROUPID']
function addComboData(store, id, desc) {
	var defaultData = {
		RowId : id,
		Description : desc
	};
	var r = new store.recordType(defaultData);
	store.add(r);
}

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'��������',
	listWidth:210,
	allowBlank:true,
	emptyText:'��������...',
	triggerAction:'all',
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%',
	groupId:GroupId,
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
// ��ӡ������ť
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '��ӡ',
	tooltip : '�����ӡ����',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintInPo(mainRowId);
	}
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	if((deptId!=null)&&(deptId!="")&&(deptId!=0)){
		Ext.getCmp('locField').setValue(deptId);
		Ext.getCmp('locField').setRawValue(deptName);
		INPoItmGridDs.proxy = new Ext.data.HttpProxy({url:INPoItmGridUrl+'?actiontype=queryItem',method:'GET'});
		INPoItmGridDs.removeAll();
		INPoItmGridDs.load({params:{start:0,limit:999,sort:'RowId',dir:'IncDesc',parref:mainRowId}});
            
     }else{ 
             
	}
});	

function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	inciDr = record.get("InciDr");
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	// ѡ����
	var row = cell[0];
	var rowData = INPoItmGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("IncCode",record.get("InciCode"));
	rowData.set("IncDesc",record.get("InciDesc"));
	//����id^��������^������id^����������^��ⵥλid^��ⵥλ^����^�ۼ�^�깺���ҿ����^�������^�������^ͨ����^��Ʒ��^����^���
	//{success:'true',info:'7^GAYY-�����㰲ҽҩ��������^61^bjymzy-����������ҩ��^^^26^��[20Ƭ]^0^0^0^^^��˾����Ƭ^^��ͨƬ��^[1mg*20]'}
	//ȡ����ҩƷ��Ϣ
	var locId = Ext.getCmp('locField').getValue();
	var Params=session['LOGON.GROUPID']+'^'+CtLocId+'^'+UserId;	
	if(locId!=""){
		Ext.Ajax.request({
			url : INPoItmGridUrl+'?actiontype=GetItmInfo&IncId='+ inciDr+'&Params='+Params,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
					var ManfId = data[0];
					var Manf = data[1];
					addComboData(PhManufacturerStore,ManfId,Manf);
					//alert(ManfId)
					rowData.set("ManfId", ManfId);    //������
					rowData.set("Manf", Manf);    
					var UomId=data[4];
					var Uom=data[5];

					addComboData(ItmUomStore,UomId,Uom);
					rowData.set("PurUomId",UomId);//Ĭ��Ϊ��λ����
					rowData.set("PurUom",Uom);

					rowData.set("Sp", data[7]);   
					rowData.set("Rp", data[6]); 

					
					rowData.set("Spec", data[14]);
					rowData.set("BUom", data[15]);
					rowData.set("ConFac", data[16]);
                    //==============�����ж�==========
                    var venId = Ext.getCmp('Vendor').getValue();
                    var inci=record.get("InciDr")
                    var DataList=venId+"^"+inci+"^"+ManfId
                    var urldh = INPoItmGridUrl+'?actiontype=Check&DataList='+ DataList
                    Ext.Ajax.request({
						url : urldh,
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
					//==============�����ж�==========
				} 
			},
			scope : this
		});
	}else{
		Msg.info("error", "��ѡ��!");
	}
	//�����������
		var colindex=GetColIndex(INPoItmGrid,"PurQty");
			INPoItmGrid.getSelectionModel().select(row,colindex);
			INPoItmGrid.startEditing(row, colindex);
	
}

/*function getDrugList2(record) {
	// ѡ����
	var row = cell[0];
	var rowData = PlanGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("IncCode",record.get("InciCode"));
	rowData.set("IncDesc",record.get("InciDesc"));
	
}

*/
var Uom = new Ext.form.ComboBox({
	fieldLabel : '��λ',
	id : 'Uom',
	name : 'Uom',
	anchor : '90%',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '��λ...',
	mode:'local',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var cell=INPoItmGrid.getSelectionModel().getSelectedCell();
				var col=GetColIndex(INPoItmGrid,"Qty");
				INPoItmGrid.startEditing(cell[0], col);		
			}
		},
		'focus':function(field){
			var cell = INPoItmGrid.getSelectionModel().getSelectedCell();			
			var record = INPoItmGrid.getStore().getAt(cell[0]);
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
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();	
	var record = INPoItmGrid.getStore().getAt(cell[0]);
	var UomId=record.get("PurUomId");	
	Uom.setValue(UomId);
});
Uom.on('beforequery', function(combo) {
			var cell = INPoItmGrid.getSelectionModel().getSelectedCell();	
			var record = INPoItmGrid.getStore().getAt(cell[0]);
			var ItmId = record.get("IncId");		
			ItmUomStore.removeAll();
			ItmUomStore.load({
				params:{ItmRowid:ItmId}
			});
		});		
Uom.on('select', function(combo) {
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	var rowData = INPoItmGrid.getStore().getAt(cell[0]);

	var qty = rowData.get('PurQty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("Rp"); //ԭ����
	var sp = rowData.get("Sp"); //ԭ�ۼ�
	var uom = rowData.get("PurUomId");
	var buom = rowData.get("BUom");
	var confac = Number(rowData.get("ConFac"));
	if(seluom!=uom){
		if(seluom!=buom){     //ԭ��λ�ǻ�����λ��Ŀǰѡ�������ⵥλ
			rowData.set("Rp", Number(rp).mul(confac)); 
			rowData.set("Sp", Number(sp).mul(confac));
			rowData.set("rpAmt", Number(rp).mul(confac).mul(qty)); //������
			rowData.set("spAmt", Number(sp).mul(confac).mul(qty)); //���۽��
		}else{					//Ŀǰѡ����ǻ�����λ��ԭ��λ����ⵥλ
			rowData.set("Rp", Number(rp).div(confac)); 
			rowData.set("Sp", Number(sp).div(confac));
			rowData.set("rpAmt", Number(rp).div(confac).mul(qty)); //������
			rowData.set("spAmt", Number(sp).div(confac).mul(qty)); //���۽��
		}
	}
	rowData.set("PurUomId", seluom);
});

	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",getDrugList2);	
	}
}

//=========================����¼��=============================
var needDateField = new Ext.ux.DateField({
	id:'needDateField',
	//width:210,
	listWidth:210,
    //allowBlank:false,
	fieldLabel:'Ҫ�󵽻�����',
	anchor:'90%',
	value:new Date()
});

var inpoNoField = new Ext.form.TextField({
	id:'inpoNoField',
	fieldLabel:'������',
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:'������...',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

		// ҩƷ����
var groupField=new Ext.ux.StkGrpComboBox({ 
		id : 'groupField',
		name : 'groupField',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:CtLocId,
		UserId:UserId,
		anchor:'90%'
	}); 

var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%'
		//,
		//width : 200
	});

var remarkField = new Ext.form.TextField({
	id:'remarkField',
	fieldLabel:'��ע',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'��ע...',
	anchor:'90%',
	selectOnFocus:true
});

var finishCK = new Ext.form.Checkbox({
	id: 'finishCK',
	fieldLabel:'���',
	disabled:true,
	allowBlank:true,
	anchor:'90%',
	listeners:{
		'check':function(chk,v){
			//alert('check');
			//var grid=Ext.getCmp('INScrapMGrid');
			setGridEditable(INPoItmGrid,!v);
		}	
	}
	
});



var INPoItmGrid="";

//���ҿ����������Ϣ���ڹر�ʱ�ص�����
function returnInfo(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	var rowData = INPoItmGrid.getStore().getAt(cell[0]);
	rowData.set("PurUomId",record.get("PurUomId"));
	rowData.set("PurUom",record.get("PurUomDesc"));
	rowData.set("Sp",record.get("Sp"));
	rowData.set("Rp",record.get("Rp"));
	
	INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, 9);
}
//====================================================
//====================================================
function addNewRow() {

	if ((mainRowId!="")&&(Ext.getCmp('finishCK').getValue()==true))
	{
		Msg.info('warning','��ǰ���������,��ֹ������ϸ��¼!');
		return;
	}	
    var rowCount =INPoItmGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = INPoItmGridDs.data.items[rowCount - 1];
		var data=rowData.get("IncId")
		if(data=="" || data.length<=0){
			var colindex=GetColIndex(INPoItmGrid,"IncDesc");
			INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, colindex);
			return;
		}
	}
	
	var record = Ext.data.Record.create([
		{
			name : 'PoItmId',
			type : 'string'
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
			name : 'PurUomId',
			type : 'string'
		},{
			name : 'PurUom',
			type : 'string'
		},{
			name : 'Spec',
			type : 'string'
		}, {
			name : 'ManfId',
			type : 'int'
		}, {
			name : 'Manf',
			type : 'string'
		},{
			name : 'PurQty',
			type : 'int'
		}, {
			name : 'Rp',
			type : 'double'
		}, {
			name : 'rpAmt',
			type : 'double'
		}, {
			name : 'Sp',
			type : 'double'
		}, {
			name : 'spAmt',
			type : 'double'
		}, {
			name : 'pp',
			type : 'double'
		}, {
			name : 'ppAmt',
			type : 'double'
		}, {
			name : 'ConFac',
			type : 'double'
		}
	]);
	
	var NewRecord = new record({
		PoItmId:'',
		IncId:'',
		IncCode:'',
		IncDesc:'',
		PurUomId:'',
		PurUom:'',
		Spec:'',
		ManfId:'',
		Manf:'',
		PurQty:'',
		Rp:'',
		rpAmt:'',
		Sp:'',
		spAmt:'',
		pp:'',
		ppAmt:'',
		ConFac:''
	});
					
	INPoItmGridDs.add(NewRecord);
	//�����������
	groupField.setDisabled(true);
	var colindex=GetColIndex(INPoItmGrid,"IncDesc");
	INPoItmGrid.getSelectionModel().select(INPoItmGridDs.getCount() - 1, colindex);
	INPoItmGrid.startEditing(INPoItmGridDs.getCount() - 1, colindex);
	
}

//��������Դ
var INPoItmGridUrl = 'dhcst.inpoaction.csp';
var INPoItmGridProxy= new Ext.data.HttpProxy({url:INPoItmGridUrl+'?actiontype=QueryDetail',method:'GET'});
var INPoItmGridDs = new Ext.data.Store({
	proxy:INPoItmGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'PoItmId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'PurUomId'},
		{name:'PurUom'},
		{name:'Spec'},
		{name:'ManfId'},
		{name:'Manf'},
		{name:'PurQty'},
		{name:'Rp'},
		{name:'rpAmt'},
		{name:'Sp'},
		{name:'spAmt'},
		{name:'pp'},
		{name:'ppAmt'},
		{name:'BUom'},
		{name:'ConFac'}
	]),
    remoteSort:false,
    listeners:{
    //'datachanged':function(){alert('datachanged')}
    }
    
});

//ģ��
var INPoItmGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'PoItmId',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"incirowid",
        dataIndex:'IncId',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"����",
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        id:'eIncDesc',
        dataIndex:'IncDesc',
        width:250,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var poLoc = Ext.getCmp('locField').getValue();
						var poNeeddate=Ext.getCmp('needDateField').getValue();
						if(poNeeddate!="" && poNeeddate!=""){
							poNeeddate=poNeeddate.format("Y-m-d");
						}
						if((poLoc=="")||(poLoc==null)){
							Msg.info("error","��ѡ�񶩵�����!");
							return false;
						}
						if((poNeeddate=="")||(poNeeddate==null)){
							Msg.info("error","��ѡ�񵽻�����") ;
							return false;
						}
						var venId = Ext.getCmp('Vendor').getValue();
						if((venId=="")||(venId==null)){
							Msg.info("error","��ѡ��Ӧ��!");
							return false;
						}
						var group=Ext.getCmp("groupField").getValue();
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),group);
					}
				}
			}
        })
    },{
        header:"���",
        dataIndex:'Spec',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"manfid",
        dataIndex:'ManfId',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"����",
        dataIndex:'Manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"����",
        id:'ePurQty',
        dataIndex:'PurQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			listeners:{
				specialKey:function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell=INPoItmGrid.getSelectionModel().getSelectedCell();
						var colindex=GetColIndex(INPoItmGrid,"Rp");
						INPoItmGrid.startEditing(cell[0],colindex);
					}
				}
			}
        })
    },{
        header:"��λ",
        dataIndex:'PurUomId',
        id:'ePurUomId',
        width:100,
        align:'left',
        sortable:true,
         editor : new Ext.grid.GridEditor(Uom),
		renderer : Ext.util.Format.comboRenderer2(Uom,"PurUomId","PurUom")       
     },{
        header:"��λ",
        dataIndex:'PurUom',
        width:100,
        align:'left',
		hidden:true
    },/*{
        header:"�ۼ�",
        dataIndex:'Sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true
    },*/{
        header:"����",
        dataIndex:'Rp',
        id:'eRp',
        width:100,
        align:'right',
        sortable:true,
    	editor : new Ext.grid.GridEditor(new Ext.ux.NumberField({
			selectOnFocus : true,
			allowBlank : false,
			id:'PoRp',
			//decimalPrecision:rpdecimal,
			formatType: 'FmtRP',
			listeners : {						      
				'specialkey': function(field, e) {
					//enter��
					if (e.getKey() == Ext.EventObject.ENTER) {
						var resultRpNew = field.getValue();
						if (resultRpNew == null|| resultRpNew.length <= 0) {
			               Msg.info("warning", "���۲���Ϊ��!");
			               return;
	               		}
			   			if (resultRpNew <= 0) {
				   			Msg.info("warning",	"���۲���С�ڻ����0!");
				    		return;
			            }
			            else{
						    addNewRow();
						}
					}
				}
			}
		})
	)
					
        //----------
    },{
        header:"���۽��",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer: FormatGridRpAmount
    },{
        header:"ConFac",
        dataIndex:'ConFac',
        width:100,
        align:'right',
        sortable:true,
        hidden:true
    }/*,{
        header:"����",
        dataIndex:'pp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'ppAmt',
        width:100,
        align:'right',
        sortable:true
    }*/
]);
		
//��ʼ��Ĭ��������
INPoItmGridCm.defaultSortable = true;

var addINPoM = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		//addNewRow();
		clearData();
		Ext.getCmp('Vendor').focus();
	}
});

var findINPoM = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindINPo(Query);
	}
});


var clearINPoM = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		clearData();
	}
});

var saveINPoM = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()==true){
				// ���涩��
				save();
		}		
	}	
});

function CheckDataBeforeSave(){
		var user = UserId;
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�񶩵�����!");
			return false;
		}
		var scg = Ext.getCmp('groupField').getValue();
		if(((scg=="")||(scg==null))&(gParamCommon[9]=="N")){
			Msg.info("error","��ѡ������!");
			return false;
		}
		var venId = Ext.getCmp('Vendor').getValue();
		if((venId=="")||(venId==null)){
			Msg.info("error","��ѡ��Ӧ��!");
			return false;
		}
		return true;
}

function save(){
	var poUser = UserId;
	var poInst = "";
	var poNo = Ext.getCmp("inpoNoField").getValue();
	var poLoc = Ext.getCmp('locField').getValue();
	var poComp = (Ext.getCmp('finishCK').getValue()==true?'Y':'N');
	var poScg = Ext.getCmp('groupField').getValue();
	var poVendor = Ext.getCmp("Vendor").getValue();
	var remark = Ext.getCmp('remarkField').getValue();
	var poNeeddate = Ext.getCmp('needDateField').getRawValue();
	var tmpData = poVendor+"^"+poLoc+"^"+poUser+"^"+poScg+"^"+poComp+"^"+remark+"^"+poNeeddate;
	//alert(tmpData);	
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INPoItmGrid.getStore().getCount();
		// 3.�ж��ظ�����ҩƷ
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = INPoItmGridDs.getAt(i).get("IncId");;
				var item_j = INPoItmGridDs.getAt(j).get("IncId");;
				if (item_i != "" && item_j != ""
						&& item_i == item_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", "ҩƷ�ظ�������������!");
					return false;
				}
			}
		}
		
		for (var i = 0; i < rowCount; i++) {
			var rowData = INPoItmGridDs.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Inpoi=rowData.get("PoItmId");
				var inci = rowData.get("IncId");
				var uom = rowData.get("PurUomId");
				var qty = rowData.get("PurQty");
				if(qty==""){
					Msg.info("error","����д����!");
					var colindex=GetColIndex(INPoItmGrid,"PurQty");
					INPoItmGrid.startEditing(i,colindex);
					return false;
				}
				var Rp = rowData.get("Rp");
				var icnt = i + 1;
				if (Rp <= 0) {
		   			Msg.info("warning",	"��"+icnt+"�н��۲���С�ڻ����0!");
		    		return;
	            }
				var reqQty=qty  ; //��ʱʹ�ù�������
				
				var str = Inpoi + "^" + inci + "^"	+ uom + "^" + Rp+"^"+qty +"^"+ reqQty;
						//alert(ListDetail)
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		
		if(ListDetail==""){
			//alert(mainRowId);
			if (mainRowId=='')
			{
				Msg.info("error","û����ϸ!");
				return ;
			}
 		}
        var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
		    url: INPoItmGridUrl+"?actiontype=Save",
		    params:{Main:mainRowId,MainInfo:tmpData,ListDetail:ListDetail},
			method : 'POST',
			waitMsg : '������...',
			failure: function(result,request) {
				 mask.hide();
				Msg.info("error","������������!");
			},
			success: function(result,request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					mainRowId = jsonData.info;
					Query(mainRowId);
				}else{
					Msg.info("error","����ʧ��!"+jsonData.info);
				}
				mask.hide();
			},
			scope: this
		});
	}
}

// ��ʾ��������
function Query(InpoRowid) {
	mainRowId=InpoRowid;  //��һ�����Ҫ��������
	if (InpoRowid == null || InpoRowid.length <= 0 || InpoRowid <= 0) {
		return;
	}
	Ext.Ajax.request({
		url : INPoItmGridUrl	+ "?actiontype=Select&InpoId=" + InpoRowid,
		method : 'POST',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.results>0) {
			var data=jsonData.rows[0];			
			//alert(data);
			if(data){
				Ext.getCmp('inpoNoField').setValue(data['INPO_No']);
				locField.setValue(data['PoLoc']);
				locField.setRawValue(data['PoLocDesc']);
				needDateField.setValue(data['INPO_DateNeeded']);
				
				addComboData(Vendor.getStore(),data['INPO_APCVM_DR'],data['vendorName']);
				Vendor.setValue(data['INPO_APCVM_DR']);
				//Vendor.setRawValue(data['vendorName']);
				groupField.setValue(data['StkGrpId']);
				groupField.setRawValue(data['StkGrpDesc']);
				//remark=handleMemo(remark,xMemoDelim());
				//remarkField.setValue(remark);	
				if( data['INPO_Completed']=="Y"){
					finishCK.setValue(true);
					saveINPoM.disable();
					deleteINPoM.disable();
				}
				else{
					finishCK.setValue(false);
					saveINPoM.enable();
					deleteINPoM.enable();
				}
	 
				Ext.getCmp('remarkField').setValue(handleMemo(data['INPO_Remarks'],xMemoDelim()));
				
				//������ϸ
				getDetail(InpoRowid);
			}				
			}
			groupField.setDisabled(true);
		},
		scope : this
	});	
}
		
// ��ʾ������ϸ����
function getDetail(InpoRowid) {
	if (InpoRowid == null || InpoRowid.length <= 0 || InpoRowid <= 0) {
		return;
	}
	INPoItmGridDs.removeAll();
	INPoItmGridDs.load({params:{start:0,limit:999,Parref:InpoRowid}});

	// �����ť�Ƿ����
	//��ѯ^���^����^����^ɾ��^���^ȡ�����
	//var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	//i/f(inGrFlag==true){
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
/**
 * ɾ��ѡ����ҩƷ
 */
function deleteDetail() {
	// �ж϶����Ƿ������
	var CmpFlag = Ext.getCmp("finishCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", "��ǰ���������,��ֹɾ����ϸ��¼!");
		return;
	}
	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "û��ѡ����!");
		return;
	}
	// ѡ����
	var row = cell[0];
	var record = INPoItmGrid.getStore().getAt(row);
	var Inpoi = record.get("PoItmId");
	if (Inpoi == "" ) {
		INPoItmGrid.getStore().remove(record);
		INPoItmGrid.getView().refresh();
	} else {
		Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȷ��ɾ����ҩƷ��Ϣ',
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
		var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = INPoItmGrid.getStore().getAt(row);
		var Inpoi = record.get("PoItmId");
		//alert("Inpoi="+Inpoi)

		// ɾ����������
		var url = INPoItmGridUrl	+ "?actiontype=deleteItem&InPoi=" + Inpoi;

		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : 'ɾ����...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
								//alert("jsonData="+jsonData)
						if (jsonData.success == 'true') {
							Msg.info("success", "ɾ���ɹ�!");
							INPoItmGrid.getStore().remove(record);
							INPoItmGrid.getView().refresh();
						} else {
							var ret=jsonData.info;
							if(ret==-1){
								Msg.info("error", "�����Ѿ���ɣ�����ɾ��!");
							}else{
								Msg.info("error", "ɾ��ʧ��,��鿴������־!");
							}
						}
					},
					scope : this
				});
	}
}

var deleteINPoM = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
	/*	var cell = INPoItmGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","��ѡ������!");
			return false;
		}else{  */
			
			var rowid = mainRowId
			if(rowid!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ö���?',
					function(btn) {
							if(btn == "yes"){
							Ext.Ajax.request({
								//url : INPoItmGridUrl + "?actiontype=delete&InpoId=" +mainRowId,
								url : INPoItmGridUrl + "?actiontype=delete&InpoId=" +rowid,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Msg.info("error", "������������!");
									return false;
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										//INPoItmGridDs.load({params:{Parref:mainRowId}});
										Msg.info("success", "����ɾ���ɹ�!");
									    clearData();
									}else{
										var ret=jsonData.info;
									if(ret==-1){
										Msg.info("error", "�����Ѿ���ɣ�����ɾ��!");
									}if(ret==-3){
										Msg.info("error", "ɾ������ʧ��!");
									}if(ret==-4){
										Msg.info("error", "ɾ���������ӱ�ʧ��!");
									}else{
										Msg.info("error", "ɾ��ʧ��,��鿴������־!");
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
				Msg.info("error", "����IdΪ��,������ɾ��!");
				return false;
			}
		//}
	}
});
//--------------------
function clearData(){
	SetLogInDept(GetGroupDeptStore,'locField')
	mainRowId='';
	Ext.getCmp('needDateField').setValue(new Date());
	Ext.getCmp('inpoNoField').setValue("");
	Ext.getCmp('remarkField').setValue("");
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("finishCK").setValue(false);
	groupField.setDisabled(false);
	groupField.getStore().load();
	INPoItmGridDs.removeAll();
	saveINPoM.enable();
	deleteINPoM.enable();
}

var finshInpo = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "����Ϊ��!");
			return false;
		}else{
			if(Ext.getCmp("finishCK").getValue()==true){
				Msg.info("warning","�ö����Ѿ����!")
				return;
			}
		   	
		var count=INPoItmGrid.getStore().getCount();
		if (count==0) {Msg.info("warning","�ö���û����ϸ!");return;}	
		    for (var i=0;i<count;i++){
		    var rowData=INPoItmGrid.getStore().getAt(i);
		     //���������ݷ����仯ʱִ����������
		    if(rowData.data.newRecord || rowData.dirty){  
		       Msg.info("warning","������ϸ�ѷ����ı�,���ȱ�������!");
		       return;
		           }
		       
		       }
			
			
			
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ��ɸö�����?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inpoaction.csp?actiontype=finish&InpoId='+mainRowId+'&Usr='+UserId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "��������Ϊ���״̬!");
									Query(mainRowId);
								}else{
									
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
   // �任����ɫ
	function changeBgColor(row, color) {
		INPoItmGrid.getView().getRow(row).style.backgroundColor = color;
	}
var noFinshInpo = new Ext.Toolbar.Button({
	text:'ȡ�����',
    tooltip:'ȡ�����',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "����Ϊ��!");
			return false;
		}else{
			if(Ext.getCmp("finishCK").getValue()==false){
				Msg.info("warning","�õ�����δ���!!")
				return;
			}
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫȡ����ɸö�����?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inpoaction.csp?actiontype=noFinish&InpoId='+mainRowId+'&Usr='+UserId,
							waitMsg:'������...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "��������Ϊδ���״̬!");
									Query(mainRowId);
								}else{
									if(jsonData.info==-2){
										Msg.info("error", "�ö����Ѿ�ת���,��ֹ�޸�״̬!");
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

var formPanel = new Ext.form.FormPanel({
	labelWidth : 90,
	labelAlign : 'right',
	//autoScroll:true,
	autoHeight : true,
	frame : true,
	layout:'fit',
	//bodyStyle : 'padding:5px;',
    tbar:[findINPoM,'-',clearINPoM,'-',addINPoM,'-',saveINPoM,'-',finshInpo,'-',noFinshInpo,'-',PrintBT,'-',deleteINPoM],
	items : [{
		xtype : 'fieldset',
		title : '��������Ϣ',
		layout : 'column',	
		style:DHCSTFormStyle.FrmPaddingV,	
		autoHeight : true,
		items : [{
			columnWidth : .25,
			layout : 'form',
			items : [locField,Vendor]
		}, {
			columnWidth : .25,
			layout : 'form',
			items : [inpoNoField,needDateField]
		}, {
			columnWidth : .25,
			layout : 'form',
			items : [groupField,remarkField]
		}, {
			columnWidth : .25,
			layout : 'form',
			items : [finishCK]
		}]
	}]

});

var AddDetailBT=new Ext.Button({
	text:'����һ��',
	tooltip:'',
	height:30,
	width:70,
	iconCls:'page_add',
	handler:function()
	{	
		addNewRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	tooltip:'',
	height:30,
	width:70,
	iconCls:'page_delete',
	handler:function()
	{
		deleteDetail();
	}
});

//���
INPoItmGrid = new Ext.grid.EditorGridPanel({
	title:'������ϸ',
	store:INPoItmGridDs,
	cm:INPoItmGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	loadMask:true,
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{text:'������',height:30,width:70,iconCls:'page_gear',handler:function(){	GridColSet(INPoItmGrid,"DHCSTPO");}}]},
	clicksToEdit:1,
	sm:new Ext.grid.CellSelectionModel({}),
	listeners:{
		afteredit:function(e){
			if(e.field=='PurQty'){
				var newqty = e.value;
				//ʹҳ������б���2λС��
				//С��λ������
				var pos = 3;
				e.record.set("spAmt",Math.round(newqty*e.record.get('Sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
				e.record.set("rpAmt",Math.round(newqty*e.record.get('Rp')*Math.pow(10,pos))/Math.pow(10,pos)); 
				e.record.set("ppAmt",Math.round(newqty*e.record.get('pp')*Math.pow(10,pos))/Math.pow(10,pos)); 
			}
			if(e.field=='Rp'){
				var resultRpNew = e.value;
				var newQty=e.record.get("PurQty");
				var pos = 3;
				e.record.set("rpAmt",Math.round(resultRpNew*newQty*Math.pow(10,pos))/Math.pow(10,pos)); 	
			}
		},
		beforeedit:function(e){
			var pouomid=e.record.get('PurUomId');
			var poinci=e.record.get('IncId');			
			var decimalstr=tkMakeServerCall("web.DHCST.Common.AppCommon","GetDecimalCommon",GroupId,CtLocId,UserId,poinci,pouomid);
			var decimalarr=decimalstr.split("^");
			Ext.getCmp("PoRp").decimalPrecision=decimalarr[0];
		}
	}
});

/***
		**����Ҽ��˵�
		**/
		
	INPoItmGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: deleteDetail, 
				text: 'ɾ��' 
			}
		] 
	}); 
		
				//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
//=========================����¼��=============================

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  
	}
	var panel = new Ext.Panel({
		title:'����¼��',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(2),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,INPoItmGrid],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INPoItmGrid,"DHCSTPO");   //�����Զ�������������������
});

function setGridEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('eIncDesc');
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('ePurUomId');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('ePurQty');	        
	grid.getColumnModel().setEditable(colId,b);
	
	var colId=grid.getColumnModel().getIndexById('eRp');	        
	grid.getColumnModel().setEditable(colId,b);
	
}
//===========ģ����ҳ��=============================================
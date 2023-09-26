// ����:�˻�����
// ��д����:2012-07-6

var IncId="";
var URL = 'dhcst.ingdretaction.csp';
var vendorId="";
var vendorName = "";
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var arr = window.status.split(":");
var length = arr.length;
var ret = "";

function getDrugList(record) {
	if (record == null || record == "") {
		return false;
	}else{
		Ext.getCmp("pName").setValue(record.get("InciDesc"));	
		IncId = record.get("InciDr");
	}		
}
		
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, "G", "", "N", "0", "",getDrugList);
	}
}

var dateField = new Ext.form.DateField({
	id:'dateField',
	width:150, 
	listWidth:150,
    allowBlank:false,
	fieldLabel:'����',
	format:'Y-m-d',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var dretField = new Ext.form.TextField({
	id:'dret',
	fieldLabel:'�˻�����',
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});



var locField = new Ext.form.ComboBox({
	id:'locField',
	fieldLabel:'�˻�����',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GetGroupDeptStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'�˻�����...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:999,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	Ext.getCmp('locField').setRawValue(arr[length-1]);
	Ext.getCmp('locField').setValue(locId);
});	
		
var GroupStore = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});
GroupStore.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url : 'dhcst.extux.csp?actiontype=StkCatGroup&type=G',method:'GET'});
});	
var groupField = new Ext.form.ComboBox({
	id:'groupField',
	fieldLabel:'����',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GroupStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'����...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var Vendor = new Ext.form.ComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	width : 127,
	store : APCVendorStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : true,
	triggerAction : 'all',
	emptyText : '',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 210,
	valueNotFoundText : ''
});



var pNameField = new Ext.form.TextField({
	id:'pName',
	fieldLabel:'��Ʒ����',
	allowBlank:true,
	width:150,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true,
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				//����ҩƷ����
				var group = Ext.getCmp("groupField").getValue();
				GetPhaOrderInfo(field.getValue(),group);
			}
		}
	}
});

var transOrder = new Ext.form.Checkbox({
	id: 'transOrder',
	fieldLabel:'���ۻ�Ʊ',
	allowBlank:true
});

var complete = new Ext.form.Checkbox({
	id: 'complete',
	fieldLabel:'���',
	disabled:true,
	allowBlank:true,
	listeners :{
		'check':function (obj, ischecked) {
            if (ischecked) {
				if((ret!="")&&(ret!=null)){
					Ext.Ajax.request({
						url:URL+'?actiontype=complet&ret='+ret,
						waitMsg:'ɾ����...',
						failure: function(result, request) {
							Msg.info("error","������������!");
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Msg.info("success","��ɶ����ɹ�!");
							}else{
								Msg.info("error","��ɶ���ʧ��!");
							}
						},
						scope: this
					});
				}
            }
        }        
	}
});

var noViewZeroItem = new Ext.form.Checkbox({
	id: 'noViewZeroItem',
	fieldLabel:'����ʾ���Ϊ�����',
	allowBlank:true
});

var noViewZeroVendor = new Ext.form.Checkbox({
	id: 'noViewZeroVendor',
	fieldLabel:'����ʾ���Ϊ��Ĺ�Ӧ��',
	allowBlank:true
});
//=========================�˻�����=================================

function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'MinRp',
			type : 'double'
		}, {
			name : 'MaxRp',
			type : 'double'
		}, {
			name : 'Margin',
			type : 'double'
		}, {
			name : 'MPrice',
			type : 'double'
		}, {
			name : 'MaxMargin',
			type : 'string'
		}, {
			name : 'MaxMPrice',
			type : 'double'
		}, {
			name : 'SdDr',
			type : 'int'
		}, {
			name : 'SdDesc',
			type : 'string'
		}, {
			name : 'MtDr',
			type : 'int'
		}, {
			name : 'MtDesc',
			type : 'string'
		}, {
			name : 'UseFlag',
			type : 'bool'
		}, {
			name : 'Remark',
			type : 'string'
		}
	]);
	
	var NewRecord = new record({
		RowId:'',
		Code:'',
		Desc:'',
		MinRp:'',
		MaxRp:'',
		Margin:'',
		MPrice:'',
		MaxMargin:'',
		MaxMPrice:'',
		SdDr:'',
		SdDesc:'',
		MtDr:'',
		MtDesc:'',
		UseFlag:true,
		Remark:''
	});
					
	IngDretGridDs.add(NewRecord);
	IngDretGrid.startEditing(IngDretGridDs.getCount() - 1, 12);
}
ReasonForReturnStore.load();
var Cause = new Ext.form.ComboBox({
	fieldLabel : '�˻�ԭ��',
	id : 'Cause',
	name : 'Cause',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '�˻�ԭ��...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var row = IngDretGridDs.getAt(IngDretGridDs.getCount()- 1);
				row.set('cause',field.getRawValue());
				row.set('causeName',field.getRawValue());
				row.set('causeId',field.getValue());
			}
		},
		'select':function(combo,record,index){
			var row = IngDretGridDs.getAt(IngDretGridDs.getCount()- 1);
			row.set('cause',combo.getRawValue());
			row.set('causeName',combo.getRawValue());
			row.set('causeId',combo.getValue());
		}
	}
});		

var IngDretGrid="";
//��������Դ
var IngDretGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectBatch',method:'GET'});
var IngDretGridDs = new Ext.data.Store({
	proxy:IngDretGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'INGRI'},
		{name:'code'},
		{name:'desc'},
		{name:'mnf'},
		{name:'batch'},
		{name:'expdate'},
		{name:'recqty'},
		{name:'stkqty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'pp'},
		{name:'sven'},
		{name:'idate'},
		{name:'rp'},
		{name:'sp'},
		{name:'INCLB'},
		{name:'iniflag'},
		{name:'Drugform'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:'Y-m-d'},
		{name:'invAmt'},
		{name:'dretQty'},
		{name:'cause'},
		{name:'causeName'},
		{name:'causeId'}
	]),
    remoteSort:false
});
/*{results:1,rows:[{code:'H01N006',desc:'��˾����Ƭ[���ְ���][1mg*20]',mnf:'bjymzy-����������ҩ��',batch:'20110101',expdate
:'2012-01-01',recqty:'20',uomDesc:'��[20Ƭ]',stkqty:'20',INGRI:'4319||1',pp:'1.04',sven:'GAYY-�����㰲ҽҩ����
����',idate:'2011-01-18',rp:'1.04',sp:'1.2',INCLB:'534||3||4',iniflag:'0',Drugform:'��ͨƬ��',invNo:'��ͨƬ��'
,invDate:'',invAmt:''}]}

	s code=result.Data("code")   //����
	s desc=result.Data("desc")  //����
	s mnf=result.Data("mnf")    //����
	s batch=result.Data("batch")  //����
	s expdate=result.Data("expdate")  //Ч��
	s recqty=result.Data("recqty")  //�����
	s uomDesc=result.Data("uomDesc")  //��λ
	s stkqty=result.Data("stkqty")  //�ֿ����
	s INGRI=result.Data("INGRI")  //�����ϸ��rowid(DHC_INGdRecItm)
	s pp=result.Data("pp")  //����
	s sven=result.Data("sven")  //��Ӧ������
	s idate=result.Data("idate")  //�������(����������)
	s rp=result.Data("rp")  //����
	s sp=result.Data("sp")  //�ۼ�
	s INCLB=result.Data("INCLB")  //����DR(INC_ItmLcBt)
	s iniflag=result.Data("iniflag")  //��ʼ����־
	s Drugform=result.Data("Drugform")  //����
	s invNo=result.Data("invNo")   //��Ʊ��
	s invDate=result.Data("invDate")  //��Ʊ����
	s invAmt=result.Data("invAmt")   //��Ʊ���
*/
//ģ��
var IngDretGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����DR",
        dataIndex:'INCLB',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"�����ϸ��rowid",
        dataIndex:'INGRI',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'Drugform',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'mnf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'batch',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'rp',
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
        header:"Ч��",
        dataIndex:'expdate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�������",
        dataIndex:'recqty',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"��ⵥλ",
        dataIndex:'uomDesc',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"�ֿ������",
        dataIndex:'stkqty',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"�˻�����",
        dataIndex:'dretQty',
        width:80,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'dretQtyField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					var cell = IngDretGrid.getSelectionModel().getSelectedCell();
					var row = IngDretGridDs.getAt(cell[0]);
					if (e.getKey() == Ext.EventObject.ENTER) {
						var count = field.getValue();
						if(count>row.get("stkqty")){
							field.setValue("");
							Msg.info("error","�˻��������ܴ��ڿ������!");
							IngDretGrid.startEditing(IngDretGridDs.getCount()-1,15);
						}else{
							row.set("dretAmt", count*row.get("rp")); 
							row.set("spAmt", count*row.get("sp")); 
							//row.set("invAmt", count*row.get("rp")); 
						}
					}
				},
				blur:function(field){
					var cell = IngDretGrid.getSelectionModel().getSelectedCell();
					var row = IngDretGridDs.getAt(cell[0]);
					
					var qty = field.getValue();
					if(qty>row.get("stkqty")){
						field.setValue("");
						Msg.info("error","�˻��������ܴ��ڿ������!");
						IngDretGrid.startEditing(IngDretGridDs.getCount()-1,15);
					}else{
						row.set("dretAmt", qty*row.get("rp")); 
						row.set("spAmt", qty*row.get("sp")); 
						//row.set("invAmt", count*row.get("rp")); 
					}
					
				}
			}
        })
    },{
        header:"�˻����",
        dataIndex:'dretAmt',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"�˻�ԭ��Id",
        dataIndex:'causeId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"�˻�ԭ������",
        dataIndex:'causeName',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"�˻�ԭ��",
        dataIndex:'cause',
        width:100,
        align:'left',
        sortable:true,
		editor:new Ext.grid.GridEditor(Cause),
		renderer:Ext.util.Format.comboRenderer(Cause)
    },{
        header:"�������",
        dataIndex:'idate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��Ʊ��",
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'invNoField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
									
					}
				}
			}
        })
    },{
        header:"��Ʊ����",
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer('Y-m-d'),
		editor: new Ext.form.DateField({
			id:'invDateField',
            allowBlank:false,
			format:'Y-m-d',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();			
					}
				}
			}
        })
    },{
        header:"��Ʊ���",
        dataIndex:'invAmt',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'invAmtField',
            allowBlank:true
        })
    },{
        header:"���е���",
        dataIndex:'sxNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
            allowBlank:true
        })
    }
]);

//��ʼ��Ĭ��������
IngDretGridCm.defaultSortable = true;

var addIngDret = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp("Vendor").setValue("");
		IngDretGridDs.removeAll();
		IngDretDetailGridDs.removeAll();
	}
});

var findIngDret = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		findIngDret();
	}
});

var saveIngDret = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	disabled:true,
	height : 30,
	handler:function(){
		//1.����������Ϣ
		var retNo = Ext.getCmp('dret').getValue();
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","��ѡ������!");
			return false;
		}
		if((vendorId=="")||(vendorId==null)){
			Msg.info("error","��ѡ��Ӧ��!");
			return false;
		}
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����!");
			return false;
		}
		var stkType = "";
		var adjChequeFlag = (Ext.getCmp('transOrder').getValue()==true?'Y':'N');
		var mainInfo=locId+"^"+vendorId+"^"+userId+"^"+scg+"^"+adjChequeFlag;
		var rows = "";
		var count = IngDretDetailGridDs.getCount();
		
		for(var index=0;index<count;index++){
			var row = IngDretDetailGridDs.getAt(index);
			//���������ݷ����仯ʱִ����������
			if(row.data.newRecord || row.dirty){	
				var ingrti = row.get('ingrti'); 	//�˻��ӱ�rowid(DHC_INGRtItm)
				var ingri = row.get('ingri'); 		//����ӱ�rowid(DHC_INGdRecItm)
				var qty = row.get('qty'); 			//����
				var uomId = row.get('uomId'); 		//��λ
				var rp = row.get('rp'); 			//����
				var rpAmt = row.get('rpAmt'); 		//���۽��
				var sp = row.get('sp'); 			//�ۼ�
				var spAmt = row.get('spAmt'); //�ۼ۽��
				var pp = row.get('pp'); //����
				var ppAmt = row.get('ppAmt'); //���۽��
				var oldSp = row.get('oldSp'); //�����ۼ�
				var oldSpAmt = row.get('oldSpAmt'); //�����ۼ۽��
				var invNo = row.get('invNo'); //��Ʊ��
				var invDate = row.get('invDate'); //��Ʊ����
				if((invDate!="")&&(invDate!=null)){invDate = invDate.format('Y-m-d');}
				var invAmt = row.get('invAmt'); //��Ʊ���
				var sxNo = row.get('sxNo'); //���е���
				if(sxNo=="undefined"){
					sxNo = "";
				}
				var reason = row.get('retReasonId'); //�˻�ԭ��
				var aspa = row.get('aspAmt'); //�˻����۽��
				
				//
				//�˻���ϸid^�����ϸid^����^��λ^����^�ۼ�^��Ʊ��^��Ʊ����^��Ʊ���^���е�^�˻�ԭ��
				var data =  ingrti+"^"+ingri+"^"+qty+"^"+uomId+"^"+rp+"^"+sp+"^"+invNo+"^"+invDate+"^"+invAmt+"^"+sxNo+"^"+reason;
				if(rows!=""){
					rows = rows+","+data;
				}else{
					rows = data;
				}
			}
		}
		Ext.Ajax.request({
			url: URL+'?actiontype=save&ret='+ret+'&MainData='+mainInfo+'&Detail='+rows,
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					//alert(jsonData.info);
					ret =  jsonData.info; //�˻�������Id
					Select(ret);
					IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingrti',dir:'desc',ret:ret}});
				}else{
					Msg.info("error","����ʧ��!");
				}
			},
			scope: this
		});
		
		complete.enable();
    }
});

function Select(Ingrt)
{
	if((Ingrt==null)||(Ingrt=="")){
		return;
	}
	Ext.Ajax.request({
		url:URL+'?actiontype=getOrder&rowid='+Ingrt,
		waitMsg:'��ѯ��...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.getCmp('dret').setValue(jsonData.info);
			}
		},
		scope: this
	});
	
}
var deleteIngDret = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = IngDretDetailGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
			var record = IngDretDetailGrid.getStore().getAt(cell[0]);
			var RowId = record.get("ingrti");
			if(RowId!=""){
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
					function(btn) {
						if(btn == 'yes'){
							Ext.Ajax.request({
								url:URL+'?actiontype=delete&rowid='+RowId,
								waitMsg:'ɾ����...',
								failure: function(result, request) {
									Msg.info("error","������������!");
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true') {
										Msg.info("success","ɾ���ɹ�!");
										IngDretDetailGridDs.load({params:{start:0,limit:20,sort:'ingrti',dir:'desc',ret:ret}});
									}else{
										Msg.info("error","ɾ��ʧ��!");
									}
								},
								scope: this
							});
						}
					}
				)
			}else{
				Msg.info("error","�����д�!");
			}
		}
    }
});

var IngDretPagingToolbar = new Ext.PagingToolbar({
    store:IngDretGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['strPar']=Ext.getCmp('locField').getValue()+"^"+IncId+"^"+vendorId+"^"+HospId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	cm:IngDretGridCm,
	trackMouseOver:true,
	height:200,
	stripeRows:true,
	clicksToEdit:0,
	region:'north',
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IngDretPagingToolbar
});
//=========================�˻�����=================================
var Cause2 = new Ext.form.ComboBox({
	fieldLabel : '�˻�ԭ��',
	id : 'Cause2',
	name : 'Cause2',
	anchor : '90%',
	width : 120,
	store : ReasonForReturnStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '�˻�ԭ��...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				var row = IngDretDetailGridDs.getAt(IngDretDetailGridDs.getCount()- 1);
				row.set('retReason',field.getRawValue());
				row.set('retReasonId',field.getValue());
			}
		},
		'select':function(combo,record,index){
			var row = IngDretDetailGridDs.getAt(IngDretDetailGridDs.getCount()- 1);
			row.set('retReason',combo.getRawValue());
			row.set('retReasonId',combo.getValue());
		}
	}
});		

function addRow() {
	var rec = Ext.data.Record.create([
		{name : 'ingrti',type : 'string'}, 
		{name : 'ingri',type : 'string'}, 
		{name : 'manf',type : 'string'}, 
		{name : 'inclb',type : 'string'}, 
		{name : 'uom',type : 'string'}, 
		{name : 'qty',type : 'int'}, 
		{name : 'rp',type : 'double'}, 
		{name : 'rpAmt',type : 'double'},
		{name : 'sp',type : 'double'},
		{name : 'spAmt',type : 'double'},
		{name : 'invNo',type : 'string'},
		{name : 'invDate',type : 'string'},
		{name : 'invAmt',type : 'double'},
		{name : 'sxNo',type : 'string'},
		{name : 'oldSp',type : 'double'},
		{name : 'oldSpAmt',type : 'double'},
		{name : 'aspAmt',type : 'double'},
		{name : 'code',type : 'string'},
		{name : 'desc',type : 'string'},
		{name : 'spec',type : 'string'},
		{name : 'batNo',type : 'string'},
		{name : 'expDate',type : 'string'},
		{name : 'retReasonId',type : 'int'},
		{name : 'retReason',type : 'string'},
		{name : 'pp',type : 'double'},
		{name : 'ppAmt',type : 'double'}
	]);
	var NewRec = new rec({
		ingrti:'',
		ingri:'',
		manf:'',
		inclb:'',
		uom:'',
		qty:'',
		rp:'',
		rpAmt:'',
		sp:'',
		spAmt:'',
		invNo:'',
		invDate:'',
		invAmt:'',
		sxNo:'',
		oldSp:'',
		oldSpAmt:'',
		aspAmt:'',
		code:'',
		desc:'',
		spec:'',
		batNo:'',
		expDate:'',
		retReasonId:'',
		retReason:'',
		pp:'',
		ppAmt:''
	});
					
	IngDretDetailGridDs.add(NewRec);
	IngDretDetailGrid.startEditing(IngDretDetailGridDs.getCount() - 1, 1);
}

var IngDretDetailGrid="";
//��������Դ
var IngDretDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'GET'});
var IngDretDetailGridDs = new Ext.data.Store({
	proxy:IngDretDetailGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'ingrti'},
		{name:'ingri'},
		{name:'manf'},
		{name:'inclb'},
		{name:'uom'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'invNo'},
		{name:'invDate',type:'date',dateFormat:'Y-m-d'},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'aspAmt'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'retReasonId'},
		{name:'retReason'},
		{name:'pp'},
		{name:'ppAmt'}
		
		/*
		s ingrti=result.Data("ingrti")   //�˻��ӱ�rowid(DHC_INGRtItm)
		s ingri=result.Data("ingri")    //����ӱ�rowid(DHC_INGdRecItm)
		s manf=result.Data("manf")   //���� 
		s inclb=result.Data("inclb")   //����DR(INC_ItmLcBt)
		s uom=result.Data("uom")    //��λ����
		s qty=result.Data("qty")      //����
		s rp=result.Data("rp")    //����
		s rpAmt=result.Data("rpAmt")   //���۽��
		s sp=result.Data("sp")   //�ۼ�
		s spAmt=result.Data("spAmt")   //�ۼ۽��
		s invNo=result.Data("invNo")    //��Ʊ��
		s invDate=result.Data("invDate")  //��Ʊ����
		s invAmt=result.Data("invAmt")    //��Ʊ���
		s sxNo=result.Data("sxNo")    //���е���
		s oldSp=result.Data("oldSp")   //�����ۼ�
		s oldSpAmt=result.Data("oldSpAmt")   //�����ۼ۽��
		s aspAmt=result.Data("aspAmt")     //�˻�����
		s code=result.Data("aspAmt")     //���� 
		s desc=result.Data("desc")   //����
		s spec =result.Data("spec")   //���
		s batNo=result.Data("batNo")   //����
		s expDate=result.Data("expDate")   //Ч��
		s retReason=result.Data("retReason")   //�˻�ԭ��
		*/
	]),
    remoteSort:false
});

//ģ��
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"�˻��ӱ�rowid",
        dataIndex:'ingrti',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����ӱ�rowid",
        dataIndex:'ingri',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����DR",
        dataIndex:'inclb',
        width:80,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"���",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�˻�����",
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�˻���λId",
        dataIndex:'uomId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"�˻���λ",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�˻�ԭ��Id",
        dataIndex:'retReasonId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"�˻�ԭ��",
        dataIndex:'retReasonId',
        width:100,
        align:'left',
        sortable:true,
		editor:new Ext.grid.GridEditor(Cause2),
		renderer:Ext.util.Format.comboRenderer(Cause2)
    },{
        header:"�˻�����",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�˻����",
        dataIndex:'dretAmt',
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
        header:"����",
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"Ч��",
        dataIndex:'expDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�˷�Ʊ��",
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�˷�Ʊ����",
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true,
		renderer:Ext.util.Format.dateRenderer('Y-m-d'),
		editor: new Ext.form.DateField({
			id:'invDateField2',
            allowBlank:false,
			format:'Y-m-d',
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						addNewRow();			
					}
				}
			}
        })
    },{
        header:"�˷�Ʊ���",
        dataIndex:'invAmt',
        width:100,
        align:'right',
        sortable:true,
		editor: new Ext.form.NumberField({
			id:'invAmtField2',
            allowBlank:true
        })
    },{
        header:"���е���",
        dataIndex:'sxNo',
        width:100,
        align:'left',
        sortable:true,
		editor: new Ext.form.TextField({
			id:'sxNo',
            allowBlank:true
        })
    },{
        header:"�˻�����",
        dataIndex:'aspAmt',
        width:100,
        align:'right',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'pp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'ppAmt',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'rpAmt',
        width:100,
        align:'left',
        sortable:true
    }
]);

//��ʼ��Ĭ��������
IngDretDetailGridCm.defaultSortable = true;

var findVendor = new Ext.Toolbar.Button({
	text:'���ҹ�Ӧ��',
    tooltip:'���ҹ�Ӧ��',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var scg = Ext.getCmp('groupField').getValue();
		if((scg=="")||(scg==null)){
			Msg.info("error","��ѡ������!");
			return false;
		}
		//����rowid
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����!");
			return false;
		}
		//���rowid
		if((IncId=="")||(IncId==null)){
			Msg.info("error","��ѡ������!");
			return false;
		}
		//����ʾ���Ϊ��Ĺ�Ӧ��
		var noVZV = (Ext.getCmp('noViewZeroVendor').getValue()==true?'Y':'N');
		
		//��������
		var VendorProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectVendor',method:'GET'});
		var VendorDs = new Ext.data.Store({
			proxy: VendorProxy,
			reader: new Ext.data.JsonReader({
				totalProperty:'results',
				root:'rows'
			}, [
			    {name:'vendor'},
		        {name:'vendorName'},
		        {name:'latestRecDate'},
				{name:'venStkQty'},
				{name:'puomDesc'}
			]),
			remoteSort: false
		});
		var VendorCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
		    	header: '��Ӧ������',
		        dataIndex: 'vendorName',
		        width: 250,
		        sortable:true,
		        align: 'left'
		    },{
		        header: "����������",
		        dataIndex: 'latestRecDate',
		        width: 100,
		        align: 'center',
		        sortable: true
		    },{
		        header: "�������",
		        dataIndex: 'venStkQty',
		        width: 100,
		        align: 'right',
		        sortable: true
		    },{
		        header: "��ⵥλ",
		        dataIndex: 'puomDesc',
		        width: 100,
		        align: 'center',
		        sortable: true
		    }
		]);
		grid = new Ext.grid.GridPanel({
			store:VendorDs,
			cm:VendorCm,
			trackMouseOver: true,
			stripeRows: true,
			sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
			loadMask: true
		});
		
		//strPar - ������(�����Ŀrowid^����rowid^������0���Ĺ�Ӧ��(Y/N))
		VendorDs.load({params:{strPar:IncId+"^"+locId+"^"+noVZV}});
		
		var win = new Ext.Window({
			title:'��Ӧ���б�',
			width:620,
			height:300,
			minWidth:620, 
			minHeight:300,
			layout:'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items:grid
		});

		//��ʾ����
		win.show();
		
		grid.on('rowdblclick',function(grid,rowIndex,e){
			var selectedRow = VendorDs.data.items[rowIndex];
			vendorId = selectedRow.data["vendor"];
			vendorName = selectedRow.data["vendorName"];
			Ext.getCmp('Vendor').setValue(vendorId);
			Ext.getCmp('Vendor').setRawValue(vendorName);
			IngDretGridDs.load({params:{strPar:Ext.getCmp('locField').getValue()+"^"+IncId+"^"+vendorId+"^"+HospId,start:0,limit:20}});
			win.close();
			addList.enable();
		});
	}
});

var addList = new Ext.Toolbar.Button({
	text:'�����˻��б�',
    tooltip:'�����˻��б�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	disabled:true,
	handler:function(){
		var count = IngDretGridDs.getCount();
		for(var j=0;j<count;j++){
			
			var row = IngDretGridDs.getAt(j);
			var INGRI = row.get('INGRI');
			var INCLB = row.get('INCLB');
			var code = row.get('code');
			var desc = row.get('desc');
			var mnf = row.get('mnf');
			var batch = row.get('batch');
			var sven = row.get('sven');
			var pp = row.get('pp');
			var expdate = row.get('expdate');
			var uom = row.get('uom');
			var uomDesc = row.get('uomDesc');
			var idate = row.get('idate');
			var invDate = row.get('invDate');
			var recqty = row.get('recqty');
			var stkqty = row.get('stkqty');
			var rp = row.get('rp');
			//var rpAmt = row.get('rpAmt');
			var sp = row.get('sp');
			var spAmt = row.get('spAmt');
			var invAmt = row.get('invAmt');
			var invNo = row.get('invNo');
			var qty = row.get('dretQty');
			var sxNo = row.get('sxNo');
			var dretAmt = row.get('dretAmt');
			var cause = row.get('causeName');
			var causeId = row.get('causeId');
			var Drugform = row.get('Drugform');
			//alert("cause="+cause+"^causeId="+causeId);
			/*
			s code=result.Data("code")   //����
			s desc=result.Data("desc")  //����
			s mnf=result.Data("mnf")    //����
			s batch=result.Data("batch")  //����
			s expdate=result.Data("expdate")  //Ч��
			s recqty=result.Data("recqty")  //�����
			s uomDesc=result.Data("uomDesc")  //��λ
			s stkqty=result.Data("stkqty")  //�ֿ����
			s INGRI=result.Data("INGRI")  //�����ϸ��rowid(DHC_INGdRecItm)
			s pp=result.Data("pp")  //����
			s sven=result.Data("sven")  //��Ӧ������
			s idate=result.Data("idate")  //�������(����������)
			s rp=result.Data("rp")  //����
			s sp=result.Data("sp")  //�ۼ�
			s INCLB=result.Data("INCLB")  //����DR(INC_ItmLcBt)
			s iniflag=result.Data("iniflag")  //��ʼ����־
			s Drugform=result.Data("Drugform")  //����
			s invNo=result.Data("invNo")   //��Ʊ��
			s invDate=result.Data("invDate")  //��Ʊ����
			s invAmt=result.Data("invAmt")   //��Ʊ���
			*/
			if(qty>0){
				addRow();
				var rowData = IngDretDetailGridDs.getAt(IngDretDetailGridDs.getCount()-1);
				rowData.set('code',code);
				rowData.set('desc',desc);
				rowData.set('ingri',INGRI);
				rowData.set('inclb',INCLB);
				rowData.set('invNo',invNo);
				rowData.set('qty',qty);
				rowData.set('sp',sp);
				rowData.set('rp',rp);
				rowData.set('batNo',batch);
				rowData.set('expDate',expdate);
				rowData.set('sxNo',sxNo);
				rowData.set('uomId',uom);
				rowData.set('uom',uomDesc);
				rowData.set('spAmt',spAmt);
				rowData.set('rpAmt',rp*qty);
				rowData.set('dretAmt',dretAmt);
				rowData.set('invDate',invDate);
				rowData.set('invAmt',invAmt);
				rowData.set('retReason',cause);
				rowData.set('retReasonId',causeId);
				rowData.set('spec',Drugform);
				rowData.set('manf',mnf);
				rowData.set('pp',pp);
				/*
				s ingrti=result.Data("ingrti")   //�˻��ӱ�rowid(DHC_INGRtItm)
				s ingri=result.Data("ingri")    //����ӱ�rowid(DHC_INGdRecItm)
				s manf=result.Data("manf")   //���� 
				s inclb=result.Data("inclb")   //����DR(INC_ItmLcBt)
				s uom=result.Data("uom")    //��λ����
				s qty=result.Data("qty")      //����
				s rp=result.Data("rp")    //����
				s rpAmt=result.Data("rpAmt")   //���۽��
				s sp=result.Data("sp")   //�ۼ�
				s spAmt=result.Data("spAmt")   //�ۼ۽��
				s invNo=result.Data("invNo")    //��Ʊ��
				s invDate=result.Data("invDate")  //��Ʊ����
				s invAmt=result.Data("invAmt")    //��Ʊ���
				s sxNo=result.Data("sxNo")    //���е���
				s oldSp=result.Data("oldSp")   //�����ۼ�
				s oldSpAmt=result.Data("oldSpAmt")   //�����ۼ۽��
				s aspAmt=result.Data("aspAmt")     //�˻�����
				s code=result.Data("aspAmt")     //���� 
				s desc=result.Data("desc")   //����
				s spec =result.Data("spec")   //���
				s batNo=result.Data("batNo")   //����
				s expDate=result.Data("expDate")   //Ч��
				s retReason=result.Data("retReason")   //�˻�ԭ��
				*/
			}
		}
		IngDretGridDs.removeAll();
		addList.disable();
		saveIngDret.enable();
	}
});

var IngDretDetailPagingToolbar = new Ext.PagingToolbar({
    store:IngDretGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='ingrti';
		B['dir']='desc';
		B['ret']=ret;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	height:450,
	stripeRows:true,
	region:'center',
	clicksToEdit:0,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:['��Ʒ����',pNameField,'-',findVendor,'-',addList,'-','����ʾ���Ϊ�����',noViewZeroItem,'-','����ʾ���Ϊ��Ĺ�Ӧ��',noViewZeroVendor],
	clicksToEdit:1
});

var formPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		autoScroll:true,
		labelAlign : 'right',
		region:'north',
		height:143,
		frame:true,
		tbar:[addIngDret,'-',findIngDret,'-',saveIngDret,'-',deleteIngDret],
		autoScroll : true,
		bodyStyle : 'padding:0px;',
		items : [{
			autoHeight : true,
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				title : 'ѡ��',
				width:1340,
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [{
						columnWidth : .2,
						layout : 'form',
						items : [dretField]
					}, {
						columnWidth : .25,
						layout : 'form',
						items : [locField]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [groupField]
					}, {
						columnWidth : .2,
						layout : 'form',
						items : [dateField]
					}]
				},{
					layout : 'column',
					items : [{
						columnWidth : .2,
						layout : 'form',
						items : [Vendor]
					}, {
						columnWidth : .25,
						layout : 'form',
						items : [transOrder]
					}, {
						columnWidth : .25,
						layout : 'form',
						items : [complete]
					}]
				}]
			}]
		}]
	});
//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var IngDretPanel = new Ext.Panel({
		layout:'border',
    	region:'center',
		title:'�˻�����',
		activeTab: 0,
		items:[IngDretGrid,IngDretDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[formPanel,IngDretPanel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=================================================
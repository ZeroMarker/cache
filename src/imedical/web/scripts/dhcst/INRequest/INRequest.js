// ����:��������
// ��д����:2012-07-19
var gGroupId=session['LOGON.GROUPID'];
var colArr = [];
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//=========================ҳ����ת����=================================
	var abConsumeReq = reqByabConsume;
	Ext.Ajax.timeout = 900000;
	//=========================����ȫ�ֱ���=================================
	var InRequestId = "";
	var CtLocId = session['LOGON.CTLOCID'];
	var UserId = session['LOGON.USERID'];
	
	//wyx add�������� 2014-01-22
	if(gParam.length<1){
		GetParam();  //��ʼ����������
		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ�������������� wyx ��������ȡ��������gParamCommon[9]

	}
	//var arr = window.status.split(":");
	//var length = arr.length;
	var URL = 'dhcst.inrequestaction.csp';
	var strParam = "";
	var req = ""; //����ȫ�ֱ���:����rowid
	var statu = "N"; //����ȫ�ֱ���:���״̬(Ĭ��״̬:N)
	
	var requestNnmber = new Ext.form.TextField({
		id:'requestNnmber',
		fieldLabel:$g('���󵥺�'),
		listWidth:150,
		anchor:'90%',
		selectOnFocus:true,
		disabled:true
	});
	
	
	// ������
	var LocField= new Ext.ux.LocComboBox({
		fieldLabel : $g('������'),
		id : 'LocField',
		name : 'LocField',
		anchor:'90%',
		emptyText : $g('������...'),
		groupId:gGroupId,
	    listeners : {
			'select' : function(e) {
				var SelLocId=Ext.getCmp('LocField').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
				groupField.getStore().removeAll();
				groupField.getStore().setBaseParam("locId",SelLocId)
				groupField.getStore().setBaseParam("userId",UserId)
				groupField.getStore().setBaseParam("type",App_StkTypeCode)
				groupField.getStore().load();
				GetParam(e.value);	//�޸Ĺ������Һ�,�Թ�����������Ϊ׼
			}
		}
	});
	LocField.on('select', function(e) {
	    Ext.getCmp("supplyLocField").setValue("");
	    Ext.getCmp("supplyLocField").setRawValue("");
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
		fieldLabel:$g('�Ƶ�����'),
		anchor:'90%',
		value:new Date(),
		disabled:true
	});
	
	var timeField=new Ext.form.TextField({
		id:'timeField',
		disabled:true,
		anchor:'90%',
		fieldLabel:$g('�Ƶ�ʱ��')
	});
	var userField=new Ext.form.TextField({
		id:'userField',
		disabled:true,
		anchor:'90%',
		fieldLabel:$g('�Ƶ���')
	});
	
	var supplyLocField = new Ext.ux.LocComboBox({
		id:'supplyLocField',
		fieldLabel:$g('��������'),
		anchor:'90%',
		listWidth:210,
		emptyText:$g('��������...'),
		//groupId:gGroupId,
		defaultLoc:{},
		relid:Ext.getCmp("LocField").getValue(),
		protype:'TR',
		params : {relid:'LocField'}
	});
	
	supplyLocField.on("select",function(cmb,rec,id ){
	    add.disable();
	});
	
	var remark = new Ext.form.TextArea({
		id:'remark',
		fieldLabel:$g('��ע'),
		anchor:'90%',
		height:100,
		selectOnFocus:true
	});
		
	var completeCK = new Ext.form.Checkbox({
		id: 'completeCK',
		fieldLabel:$g('���'),
		anchor:'90%',
		disabled:true,
		allowBlank:true
	});
	
	var TypeStore=new Ext.data.SimpleStore({
		fields:['RowId','Description'],
		data:[['O',$g('���쵥')],['C',$g('����ƻ�')]]
	})
	var reqType=new Ext.form.ComboBox({
		id:'reqType',
		fieldLabel:$g('��������'),
		store:TypeStore,
		valueField:'RowId',
		displayField:'Description',
		emptyText:$g('��������...'),
		triggerAction:'all',
		anchor:'90%',
		minChars:1,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local'
	});
	
	var find = new Ext.Toolbar.Button({
		text:$g('��ѯ'),
	    tooltip:$g('��ѯ'),
	    iconCls:'page_find',
		width : 70,
		height : 30,
		handler:function(){
			findRec(refresh);
		}
	});
	
	var clear = new Ext.Toolbar.Button({
		id:'clear',
		text:$g('����'),
	    tooltip:$g('����'),
	    iconCls:'page_clearscreen',
		width : 70,
		height : 30,
		handler:function(){
			clearReq();
		}
	});
	
	// ���ۺϼ�
	var rpAmount = new Ext.form.Label({
				text : $g('���ۺϼ�:'),
				id : 'rpAmount',
				width:500,
				anchor : '90%'
			});	
			
	// �ۼۺϼ�
	var spAmount = new Ext.form.Label({
				text : $g('�ۼۺϼ�:'),
				id : 'spAmount',
				anchor : '90%',
				width:200
			});
	
	
	
	function clearReq()
	{
		req="";
		InRequestGridDs.removeAll();
		remark.setValue("");
		requestNnmber.setValue("");  //groupField
		supplyLocField.setValue("");
		supplyLocField.setRawValue("");
		dateField.setValue(new Date());
		completeCK.setValue(false);
		del.enable();
		groupField.setValue("");
		groupField.setRawValue("");
		timeField.setValue("");
		userField.setValue("");
		reqType.setValue("O");
		Ext.getCmp('save').enable();
		setGridEditable(Ext.getCmp('reqItmEditGrid'),true)  //�ָ��༭
		add.setDisabled(false);
		SetLogInDept(LocField.getStore(),'LocField');
		groupField.store.load();
		if(abConsumeReq>0){
			location.href="dhcst.inrequest.csp?reqByabConsume=";
		}
		rpText=$g("���ۺϼ�:  ")
		spText=$g("�ۼۺϼ�:  ")
		Ext.getCmp("rpAmount").setText(rpText);
		Ext.getCmp("spAmount").setText(spText);
		changeElementEnable();
		
	}
	//wyx 2013-10-11		
	function CheckInciRep(InputInciDr){
		var retflag="0"
		var Count = InRequestGrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = InRequestGridDs.getAt(i);
			var rowInciDr = rowData.get("inci");
			if ((rowInciDr!="")&&(InputInciDr==rowInciDr)){
				var retflag="1";
				var cellnum=i+1;
				return retflag+"^"+cellnum;
				}
			}
		return retflag+"^"+"0"	;
	}
	function getDrugList2(record) {
		if (record == null || record == "") {
			return false;
		}
		var inputincidr=record.get("InciDr");
		var retstr=CheckInciRep(inputincidr);
		var retlist=retstr.split("^");
		var repinciflag=retlist[0];
		var cellnum=retlist[1];
		if (repinciflag=="1") {
			Msg.info("warning", $g("��ҩƷ���")+cellnum+$g("��,����ҩƷ�����ظ���"));
			return false;
			}
		//var rowrecord = InRequestGrid.getSelectionModel().getSelected();
		//var recordrow = InRequestGridDs.indexOf(rowrecord)
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     	var recordrow = cell[0];
		var rowData = InRequestGridDs.getAt(recordrow);
		rowData.set("inci",record.get("InciDr"));
		rowData.set("code",record.get("InciCode"));
		rowData.set("desc",record.get("InciDesc"));
		
		//��Ӧ��id^��Ӧ������^����id^��������^������id^����������^��ⵥλid^��ⵥλ^����^�ۼ�^�깺���ҿ����^�������^�������^ͨ����^��Ʒ��^����^���
		//{success:'true',info:'7^GAYY-�����㰲ҽҩ��������^61^bjymzy-����������ҩ��^^^26^��[20Ƭ]^0^0^0^^^��˾����Ƭ^^��ͨƬ��^[1mg*20]'}
		//ȡ����ҩƷ��Ϣ
		
		var locId = Ext.getCmp('LocField').getValue();
		var prvlocId = Ext.getCmp('supplyLocField').getValue();
		//---------------add by myq 20141104
		
		var locDesc = Ext.getCmp('LocField').getRawValue();
		var prvlocDesc = Ext.getCmp('supplyLocField').getRawValue();
		var InciDesc = record.get("InciDesc") ;
		
		var prflag=tkMakeServerCall("web.DHCST.RelLoc","ChkPRLocFlagByInci",prvlocId,locId,record.get("InciDr"))
			//	alert("prflag:"+prflag)
		if (prflag!="1"){
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     	var recordrow = cell[0];
       var record = InRequestGridDs.getAt(recordrow);
       InRequestGridDs.remove(record);
			 InRequestGrid.getView().refresh();
			
		   Msg.info('warning',locDesc+$g('������')+prvlocDesc+$g('����')+InciDesc);
			 return false ;
		
		}
		//---------------add by myq 20141104	
		var Params=""+"^"+locId+"^"+prvlocId
		if(locId!=""){
			Ext.Ajax.request({
				url : 'dhcst.inrequestaction.csp?actiontype=GetItmInfo&lncId='+ record.get("InciDr")+'&Params='+Params,
				method : 'POST',
				waitMsg : $g('��ѯ��...'),
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
					if (jsonData.success == 'true') {
						var data=jsonData.info.split("^");
						var ManfId = data[2];
						var Manf = data[3];
						rowData.set("manf", data[3]);    //������						
						var UomId=data[6];
						var Uom=data[7];
						addComboData(ItmUomStore, UomId, Uom);
                    	rowData.set("uom", UomId);
						
						rowData.set("uom", UomId);    //��λId
						rowData.set("uomDesc", Uom);    //��λ����
						rowData.set("sp", data[9]);   
						rowData.set("rp", data[8]);  
						rowData.set("generic", data[13]);     
						rowData.set("drugForm", data[15]);   
						rowData.set("spec", data[16]);
						rowData.set("reqqty", data[10]);
						rowData.set("prvqty", data[19]);
						rowData.set("buom", data[17]);
						rowData.set("confac", data[18]);
					}
				},
				scope:this
			});
		}else{
			Msg.info("error",$g("��ѡ�����!"));
		}
		 if (setEnterSort(InRequestGrid, colArr)) {
                        addNewRow();
                    }
	}
	
	function GetPhaOrderInfo2(item, group) {
		if (item != null && item.length > 0) {
			var prvlocId = Ext.getCmp('supplyLocField').getValue();
			GetPhaOrderWindow(item, group, App_StkTypeCode, prvlocId, "N", "0", "",getDrugList2);
		}
	}
	//=========================����ȫ�ֱ���=================================
	//=========================��������Ϣ=================================
	function addNewRow() {	
		if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
		{
			Msg.info('warning',$g('��ǰ���������!'));
			return;
		}
		var rowCount =InRequestGrid.getStore().getCount();
		if(rowCount>0){
			var rowData = InRequestGridDs.data.items[rowCount - 1];
			var data=rowData.get("inci")
			if(data=="" || data.length<=0){
				var col=GetColIndex(InRequestGrid,'desc');
				InRequestGrid.getSelectionModel().selectRow(InRequestGridDs.getCount() - 1);
				InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, col);
				return;
			}
		}
		
		var record = Ext.data.Record.create([
			{
				name : 'rowid',
				type : 'int'
			}, {
				name : 'inci',
				type : 'int'
			}, {
				name : 'code',
				type : 'string'
			}, {
				name : 'desc',
				type : 'string'
			}, {
				name : 'qty',
				type : 'int'
			}, {
				name : 'uom',
				type : 'int'
			}, {
				name : 'uomDesc',
				type : 'string'
			}, {
				name : 'spec',
				type : 'string'
			}, {
				name : 'manf',
				type : 'int'
			}, {
				name : 'rp',
				type : 'int'
			}, {
				name : 'rpAmt',
				type : 'double'
			}, {
				name : 'sp',
				type : 'int'
			}, {
				name : 'spAmt',
				type : 'double'
			}, {
				name : 'generic',
				type : 'string'
			}, {
				name : 'drugForm',
				type : 'string'
			}, {
				name : 'remark',
				type : 'string'
			}, {
				name : 'consumqty',
				type : 'int'
			}, {
				name : 'buom',
				type : 'string'
			}, {
				name : 'confac',
				type : 'int'
			}

		]);
		
		var NewRecord = new record({
			rowid:'',
			inci:'',
			code:'',
			desc:'',
			qty:'',
			uom:'',
			uomDesc:'',
			spec:'',
			manf:'',
			rp:'',
			rpAmt:'',
			sp:'',
			spAmt:'',
			generic:'',
			drugForm:'',
			remark:'',
			consumqty:'',
			buom:'',
			confac:''
		});
						
	InRequestGridDs.add(NewRecord);
	var col=GetColIndex(InRequestGrid,'desc');
	//InRequestGrid.getSelectionModel().selectRow(InRequestGridDs.getCount() - 1);
	InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, col);
	changeElementEnable();
	}
// ��λ
var CTUom = new Ext.form.ComboBox({
	//fieldLabel : '��λ',
	id : 'CTUom',
	name : 'CTUom',
	anchor : '90%',
	width : 120,
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : $g('��λ...'),
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250	,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				if (setEnterSort(InRequestGrid, colArr)) {
                                addNewRow();
                            }		
			}
		}
	}
});
ItmUomStore.on('beforeload',function(store){
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
    var recordrow = cell[0];
	var record = InRequestGrid.getStore().getAt(recordrow);
	var InciDr = record.get("inci");
	if (InciDr=='') {
		return false;
	}
	else{
		ItmUomStore.baseParams={ItmRowid:InciDr};
	}
	
});
/**
 * ��λչ���¼�
 */

CTUom.on('expand', function(combo) {

	combo.store.removeAll();
	combo.store.load();	

});
/**
 * ��λ�任�¼�
 */
CTUom.on('select', function(combo) {
	var cell = InRequestGrid.getSelectionModel().getSelectedCell();
    var recordrow = cell[0];
	var record = InRequestGrid.getStore().getAt(recordrow);	
	var value = combo.getValue();        //Ŀǰѡ��ĵ�λid	
	var Uom = record.get("uom");    //Ŀǰ��ʾ�ĵ�λ
	var BUom=record.get("buom"); 
	var ConFac=record.get("confac"); 
	var ReqStkQty=record.get("reqqty");
	var PrvStkQty=record.get("prvqty");
	var Rp=record.get("rp");
	var Sp=record.get("sp");
	var NewReqStkQty=ReqStkQty;
	var NewPrvStkQty=PrvStkQty;
	var NewRp=Rp
	var NewSp=Sp
	var qty=record.get("qty");
	if(value!=Uom){
		if(value==BUom){
			NewReqStkQty=ReqStkQty*ConFac;
			NewPrvStkQty=PrvStkQty*ConFac;
			NewRp=Rp/ConFac;
			NewSp=Sp/ConFac;
		}else{
			NewReqStkQty=ReqStkQty/ConFac;
			NewPrvStkQty=PrvStkQty/ConFac;
			NewRp=Rp*ConFac;
			NewSp=Sp*ConFac;
		}
		record.set("reqqty",NewReqStkQty)
		record.set("prvqty",NewPrvStkQty)
		record.set("rp",NewRp)
		record.set("sp",NewSp)
	}
   if ((qty!=null)&&(qty!=0)){
		var newSpAmt=qty*record.get('sp');
		var newRpAmt=qty*record.get('rp');
		newSpAmt=1*FormatGridSpAmount(newSpAmt);
		newRpAmt=1*FormatGridRpAmount(newRpAmt);
		record.set("spAmt",newSpAmt);
		record.set("rpAmt",newRpAmt);	
   }	
	record.set("uom", combo.getValue());		
});
	
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
			{name:'qty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'spec'},
			{name:'manf'},
			{name:'rp'},
			{name:'rpAmt'},
			{name:'sp'},
			{name:'spAmt'},
			{name:'generic'},
			{name:'drugForm'},
			{name:'remark'},
			{name:'reqqty'},
			{name:'prvqty'},
			{name:'buom'},
			{name:'confac'},
			{name:'consumqty'}
		]),
	    remoteSort:false,
	    pruneModifiedRecords:true,  //������Ҫ,ÿ����ɾ�ĺ�����޸�״̬
	    listeners:{
		    'load':function(store)
		    {
		
		    }
	    
	    }
	});
	
	function setGridEditable(grid,b)
	{
		var colId=grid.getColumnModel().getIndexById('colQty');	        
		grid.getColumnModel().setEditable(colId,b);
		var colId=grid.getColumnModel().getIndexById('colDesc');	        
		grid.getColumnModel().setEditable(colId,b);
		var colId=grid.getColumnModel().getIndexById('colRemark');	        
		grid.getColumnModel().setEditable(colId,b);
	
	}
	
	
	//ģ��
	var InRequestGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:$g("��ϸrowid"),
	        dataIndex:'rowid',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:$g("ҩƷrowid"),
	        dataIndex:'inci',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:$g("����"),
	        dataIndex:'code',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("����"),
	        dataIndex:'desc',
	        id:'colDesc',
	        width:220,
	        align:'left',
	        sortable:true,
			editor:new Ext.form.TextField({
				id:'descField',
				selectOnFocus:true,
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
	        header:$g("������ҵ"),
	        dataIndex:'manf',
	        width:150,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("��������"),
	        dataIndex:'qty',
	        id:'colQty',
	        width:100,
	        align:'right',
	        sortable:true,
			editor:new Ext.ux.NumberField({
				id:'qtyField',
				formatType:'FmtSQ',
	            allowBlank:false,
	            selectOnFocus:true,
				listeners:{
					specialKey:function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
						//InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 11);
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     					var recordrow = cell[0];
						var record = InRequestGrid.getStore().getAt(recordrow);
						var qty = field.getValue();
						if((qty == null) || (qty.length <= 0)||(qty.length == "")){
							Msg.info("warning", $g("��������Ϊ��!"));
							return;
							}
������������������������
						if (qty <= 0) {
							Msg.info("warning", $g("��������С�ڻ����0!"));
							return;
						}

						var PrQty = record.get("prvqty");
						
						if ((Number(qty) > Number(PrQty))){
						  Msg.info("warning", $g("�����������ڹ�Ӧ���������!"));
						  if(gParam[0]=='N'){
						  	InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 11);
						  	record.set("qty","");
						  	return;
						  }
						}
						var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     					var recordrow = cell[0];
						var rowData = InRequestGridDs.getAt(recordrow);
						var newSpAmt=qty*rowData.get('sp');
						var newRpAmt=qty*rowData.get('rp');
						newSpAmt=1*FormatGridSpAmount(newSpAmt);
						newRpAmt=1*FormatGridRpAmount(newRpAmt);
						rowData.set("spAmt",newSpAmt);
						rowData.set("rpAmt",newRpAmt);
						setStatAmount();��//���úϼ�
					    if (setEnterSort(InRequestGrid, colArr)) {
                       	 	addNewRow();
                    	}
						}
					}
				}
	        })
	    },{
	        header:$g("���󷽿��"),
	        dataIndex:'reqqty',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:false
	    },{
	        header:$g("��Ӧ�����"),
	        dataIndex:'prvqty',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:false
	    },{
	        header:$g("����"),
	        dataIndex:'rp',
	        width:100,
	        align:'right',
	        sortable:true
	    },{
	        header:$g("���۽��"),
	        dataIndex:'rpAmt',
	        width:100,
	        align:'right',
	        sortable:true,
	        renderer:FormatGridRpAmount
	    },{
	        header:$g("���۵���"),
	        dataIndex:'sp',
	        width:100,
	        align:'right',
	        sortable:true
	    },{
	        header:$g("�ۼ۽��"),
	        dataIndex:'spAmt',
	        width:100,
	        align:'right',
	        sortable:true,
	        renderer:FormatGridSpAmount
	    },{
	        header:$g("��λ"),
	        dataIndex:'uom',
	        id:'uom',
	        width:100,       
	        align:'left',
	        sortable:true,
	        renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
			editor : new Ext.grid.GridEditor(CTUom)
			
			
	    },{
	        header:$g("��ע"),
	        dataIndex:'remark',
	        id:'colRemark',
	        width:200,
	        align:'left',
	        sortable:true,
			editor:new Ext.form.TextField({
				id:'remarkField',
	            allowBlank:true,
				listeners:{
					specialKey:function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = InRequestGrid.getSelectionModel().getSelectedCell();
     						var recordrow = cell[0];
							if(InRequestGridDs.getAt(recordrow).get('qty')==0){
								Msg.info("error",$g("������������Ϊ0!"));
								InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 6);
								return false;
							}else{
								//����һ��
								 if (setEnterSort(InRequestGrid, colArr)) {
				                        addNewRow();
				                    }
							}
						}
					}
				}
	        })
	    },{
	        header:$g("���"),
	        dataIndex:'spec',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("����ͨ����"),
	        dataIndex:'generic',
	        width:150,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("����"),
	        dataIndex:'drugForm',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:$g("������������"),
	        dataIndex:'consumqty',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:false
	    },{
	        header:"buom",
	        dataIndex:'buom',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:"confac",
	        dataIndex:'confac',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    }

	]);
	
	var add = new Ext.Toolbar.Button({
		text:$g('�½�'),
		id:'newReq',
		iconCls:'page_add',
	    tooltip:$g('�½����ת������'),
		width : 70,
		height : 30,
		//disabled:true,
		handler:function(){
			clearReq();
			
		}
	});
	function saveReq()
	{  
		//������Ϣ
		//��������
		var frLoc = Ext.getCmp('supplyLocField').getValue(); 
		if((frLoc=="")||(frLoc==null)){
			Msg.info("error", $g("��ѡ�񹩸�����!"));
			return false;
		}
	
		//������
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if((toLoc=="")||(toLoc==null)){
			Msg.info("error", $g("��ѡ��������!"));
			return false;
		}
		//��½�û�
		var user = UserId;
		//����
		var scg = Ext.getCmp('groupField').getValue(); 
		if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
			Msg.info("error", $g("��ѡ������!"));
			return false;
		}
		//��ɱ�־(��ʱΪ��)
		var status =Ext.getCmp('reqType').getValue(); 
		//��ע
		var remark = Ext.getCmp('remark').getValue(); 
		var ss=remark.replace(/\r\n/g,xMemoDelim());
		var remark=ss;
		
		//������Ϣ�ַ���
		var reqInfo = frLoc+"^"+toLoc+"^"+user+"^"+scg+"^"+status+"^"+remark;
		if(RowDelim==null){
			Msg.info("error", $g("�зָ������󣬲��ܱ���!"));
			return false;
		}
		
		if(InRequestGrid.activeEditor != null){
			InRequestGrid.activeEditor.completeEdit();
		} 
		//�ӱ���ϸ
		var data = "";
		var count= InRequestGrid.getStore().getCount();
		if(count==0){
		    Msg.info("error", $g("��ϸ����Ϊ��!"));
			return false;
		}
		//��ȡ���е��¼�¼   bianshuai 2014-04-24
		var itmIsNull=1;
		var mr=InRequestGridDs.getModifiedRecords();
		if(mr.length==0){itmIsNull=0}
		var data="";
		for(var i=0;i<mr.length;i++){
			var rowid = mr[i].data["rowid"];
			var inc = mr[i].data["inci"];
			//------add by myq 2014104
		 var locDesc = Ext.getCmp('LocField').getRawValue();
		 var prvlocDesc = Ext.getCmp('supplyLocField').getRawValue();
		
		 var prflag=tkMakeServerCall("web.DHCST.RelLoc","ChkPRLocFlagByInci",frLoc,toLoc,inc)
	
		if (prflag!="1"){
			
		   Msg.info('warning',locDesc+$g('������')+prvlocDesc+$g('�����ҩƷ'));
			 return false ;  //
		 
		}
		
		//------add by myq 2014104
			
			var qty = mr[i].data["qty"];
			var uomId = mr[i].data["uom"];
			var colRemark= mr[i].data['remark'];
			var PrQty =  mr[i].data['prvqty'];
			var desc= mr[i].data['desc'];
			var ppqty=mr[i].data['consumqty'];
			//alert("colRemark:"+colRemark)
			if ((inc!="")&&(((qty!=null)&&(Number(qty)<0))||(qty==""))) {
				 Msg.info("warning", desc+$g(",������������С��0��Ϊ��!"));      
				 return false;
			}	
			if ((Number(qty) > Number(PrQty))&&(gParam[0]=='N') ){
				 //Msg.info("warning", desc+",�����������ܴ��ڹ�Ӧ���������!");
				 //return false;
			}
			if(desc.length!=0){
				
				itmIsNull=0;
				}
				
			if((inc!="")&&(inc!=null)&&(qty!="")&&(qty!=null)&&(qty!=0)){
				var tmp = rowid+"^"+inc+"^"+uomId+"^"+qty+"^"+colRemark+"^"+scg+"^"+ppqty;
				if(data==""){
					data = tmp;
				}else{
					data = data+xRowDelim()+tmp;
				}
			}
		}
		if(itmIsNull==1){
			Msg.info("warning", $g("��ϸ����Ϊ��!"));      
				 return false;
			}
		if ((req=="")&&(data=="")){Msg.info("warning", $g("û��������Ҫ����!"));return false;};
		if(!IsFormChanged(formPanel) && data==""){Msg.info("warning", $g("û��������Ҫ����!"));return false;};
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=save',
			params:{req:req,reqInfo:reqInfo,data:data},
			method : 'POST',
			waitMsg : $g('��ѯ��...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", $g("����ɹ�!"));
					req = jsonData.info;
					refresh(req);
				}else{
					if(jsonData.info==-1){
						Msg.info("error", $g("������ʧ��!"));
					}else if(jsonData.info==-99){
						Msg.info("error", $g("�������ʧ��!"));
					}else if(jsonData.info==-2){
						Msg.info("error", $g("�������ʧ��!"));
					}else if(jsonData.info==-5){
						Msg.info("error", $g("��ϸ����ʧ��!"));
					}else if(jsonData.info==-4){
						Msg.info("error", $g("����������ʧ��!"));
					}else if(jsonData.info==-3){
						Msg.info("error", $g("������ʧ��!"));
					}else if(jsonData.info==-1001){
						Msg.info("error", $g("��ǰ���������!"));
					}else if(jsonData.info==-1002){
						Msg.info("error", $g("��ǰ������ϸ�ѷ���ת��!"));
					}else if(jsonData.info==-1003){
						Msg.info("error", $g("��ǰ������ϸ�ѽ�Ϊ�ɹ��ƻ�!"));
					}else{
						Msg.info("error", $g("����ʧ��!"));
					}
				}
			},
			scope : this,
			scope:InRequestGridDs.commitChanges()
		});
		complete.enable();
	    add.enable();
	}
	var save = new Ext.Toolbar.Button({
		text:$g('����'),
		id:'save',
	    tooltip:$g('����'),
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
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:req}});
		
	}
	
	
	
	function Select(reqid){
		if(reqid==null || reqid==''){
			return;
		}
		req=reqid;
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=select&ReqId='+reqid,
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
	//					addComboData(Ext.getCmp('reqType').getStore(),dataArr[5]);
						Ext.getCmp('reqType').setValue(dataArr[5]);
						addComboData(groupField.getStore(),dataArr[15],dataArr[16]);
						Ext.getCmp('groupField').setValue(dataArr[15]);
						if(dataArr[11]=="Y"){
							Ext.getCmp("completeCK").setValue(true);
							Ext.getCmp("save").disable();
							Ext.getCmp("delete").disable();
							Ext.getCmp("complete").disable();
							Ext.getCmp("cancelComp").enable();
						}
						else{
							Ext.getCmp("completeCK").setValue(false);				
							Ext.getCmp("save").enable();
							Ext.getCmp("delete").enable();
							Ext.getCmp("complete").enable();
							Ext.getCmp("cancelComp").disable();
						}
	 
						Ext.getCmp('remark').setValue(handleMemo(dataArr[10],xMemoDelim()));
						var grid=Ext.getCmp('reqItmEditGrid');
						if (grid){
							//alert(Ext.getCmp("completeCK").getValue());
							setGridEditable(grid,!Ext.getCmp("completeCK").getValue());  //��grid�Ŀɱ༭��disable��
						}
						SetFormOriginal(formPanel);
						setStatAmount();
					}				
				}
			},
			scope : this
		});
	}
	
	var complete = new Ext.Toolbar.Button({
		text:$g('ȷ�����'),
		id:'complete',
	    tooltip:$g('ȷ�����'),
	    iconCls:'page_gear',
		width : 70,
		height : 30,
		disabled:true,
		handler:function(){
			var completeCK = Ext.getCmp('completeCK').getValue();
            var mod = isDataChanged();
            if (mod && (!completeCK)) {
                Ext.Msg.confirm($g('��ʾ'), $g('�����ѷ����ı�,�Ƿ���Ҫ��������?'),
                    function(btn) {
                        if (btn == 'yes') {
                            return;
                        } else {
                            Complete();
                        }

                    }, this);
            } else {
                Complete();
            }
		}
	});
	/**
	 * ���
	 */
	function Complete(){
		if (req=='') 
		{
			Msg.info('warning',$g('û���κ����󵥣�'));
			return ;
		}
		//�ӱ���ϸ
		var data = "";
		var count= InRequestGrid.getStore().getCount();
		if(count==0){
		    Msg.info("error", $g("��ϸ����Ϊ��!"));
		return ;
		}
		for(var index=0;index<count;index++){
		    var rec = InRequestGridDs.getAt(index);
			var inc = rec.data['inci'];
			var qty = rec.data['qty'];
			var colRemark=rec.data['remark'];
			var PrQty = rec.data['prvqty'];
			var desc=rec.data['desc']; 

	  	    if ((Number(qty) > Number(PrQty))){
			   Msg.info("warning", desc+$g(",�����������ڹ�Ӧ���������!")); //��ʾ������
	  		   if(gParam[0]=='N'){
			  	 InRequestGrid.startEditing(InRequestGridDs.getCount() - 1, 11);
			  	 record.set("qty","");
			  	 return;
			   }
		    }
	
	      }
		var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
		if((statu=="N")||(statu=="")||(statu==null)){
			statu = "Y";
			Ext.Ajax.request({
				url : 'dhcst.inrequestaction.csp?actiontype=set&req='+req+'&statu='+statu,
				method : 'POST',
				waitMsg :$g( '��ѯ��...'),
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", $g("ȷ����ɳɹ�!"));
						statu = "Y";
						completeCK.setValue(statu=='Y'?true:false);
						var grid=Ext.getCmp('reqItmEditGrid');
                                                    refresh(req);         //��ɳɹ������¼���
						if (grid){
							setGridEditable(grid,!Ext.getCmp("completeCK").getValue());  //��grid�Ŀɱ༭��disable��
						}
						
					}else{
						if(jsonData.info==-2){
							Msg.info("error", $g("����ʧ��!"));
						}else if(jsonData.info==-1){
							Msg.info("error", $g("����ʧ��!"));
						}else{
							Msg.info("error", $g("����ʧ��!"));
						}
					}
				},
				scope : this
			});
		}
		complete.disable();
		save.disable();
		del.disable();
		cancelComplete.enable();
	}
	
	function isDataChanged() {
	    var changed = false;
	    var count1 = InRequestGrid.getStore().getCount();
	    //�����������Ƿ����޸�
	    //�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	    if ((IsFormChanged(formPanel)) && (count1 != 0)) {
	        changed = true;
	    };
	    if (changed) return changed;
	    //����ϸ�����Ƿ����޸�
	    var count = InRequestGrid.getStore().getCount();
	    for (var index = 0; index < count; index++) {
	        var rec = InRequestGrid.getStore().getAt(index);
	        //���������ݷ����仯ʱִ����������
	        if (rec.data.newRecord || rec.dirty) {
	            changed = true;
	        }
	    }
	    return changed;
	}
	
	//ҳ����ת��ʱ ȷ����ɰ�ť�Ŀ���
	if(abConsumeReq>0){
		complete.enable();
		Select(abConsumeReq);
		InRequestGridDs.load({params:{start:0,limit:999,sort:'rowid',dir:'desc',req:abConsumeReq}});
	       
	}
	
	var cancelComplete = new Ext.Toolbar.Button({
		text:$g('ȡ�����'),
	    tooltip:$g('ȡ�����'),
	    id:'cancelComp',
	    iconCls:'page_gear',
		width : 70,
		height : 30,
		disabled:true,
		handler:function(){
			if (req=='') 
			{
				Msg.info('warning',$g('û���κ����󵥣�'));
				return ;
			}
			//alert(Ext.getCmp('completeCK').getValue());
			
			var statu=(Ext.getCmp('completeCK').getValue()==true?"Y":"N");
			//alert(statu);
			if(statu=="Y"){
				statu = "N";
				Ext.Ajax.request({
					url : 'dhcst.inrequestaction.csp?actiontype=set&req='+req+'&statu='+statu,
					method : 'POST',
					waitMsg : $g('��ѯ��...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", $g("ȡ����ɳɹ�!"));
							statu = "N";
							completeCK.setValue(statu=='Y'?true:false);
							var grid=Ext.getCmp('reqItmEditGrid');
			    				complete.enable();//ȡ����ɳɹ���״̬ ������ǰ�����ε�
			                		save.enable();
							del.enable();
							if (grid){
								setGridEditable(grid,!Ext.getCmp("completeCK").getValue());  //��grid�Ŀɱ༭��disable��
							}
							
						}else{
							if(jsonData.info==-2){
								Msg.info("error", $g("����ʧ��!")+jsonData.info);
							}else if(jsonData.info==-1){
								Msg.info("error", $g("��ǰ������תΪ��ʽ���ת�Ƶ�,��ֹȡ�����!"));
							}else if (jsonData.info==-99) {
								Msg.info("error", $g("����ʧ��!"));
							}					
							else{
								Msg.info("error", $g("����ʧ��!")+jsonData.info);
							}
						}
					},
					scope : this
				});
			}
			/*complete.enable();
			save.enable();
			del.enable();*/
		}
	});
	
	function delReq()
	{
		if(req==null || req==""){
			Msg.info("warning",$g("��ѡ��Ҫɾ��������!"));
			return;
		}
		
		Ext.Msg.show({
			title:$g('��ʾ'),
			msg:$g('�Ƿ�ȷ��ɾ�����󵥣�'),
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
								Msg.info("success",$g("ɾ���ɹ�!"));
								Ext.getCmp("clear").handler.call(Ext.getCmp("clear").scope);
								//Ext.getCmp("clear").fireEvent('click');
								//clear.fireEvent('click');
								//clear_click();
							}else{
								if(jsonData.info==-1){
									Msg.info("warning",$g("����������ɣ�������ɾ����"));
								}else{
									Msg.info("error",$g("ɾ��ʧ��:")+jsonData.info);
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
		text:$g('ɾ��'),
		id:'delete',
	    tooltip:$g('ɾ��'),
	    iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			delReq();
		}
	});
	
	var printBT = new Ext.Toolbar.Button({
		text : $g('��ӡ'),
		tooltip : $g('��ӡ����'),
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			if(req==null || req==""){
				Msg.info("warning",$g("û����Ҫ��ӡ������!"));
				return;
			}
			PrintINRequest(req);
		}
	});
	// ���տ��ҿ����������
    var ConWinBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : $g('��������'),
	tooltip :$g( '��������'),
	iconCls:'page_goto',
	width : 70,
	height : 30,
	handler : function() {
		var ProLoc=Ext.getCmp("supplyLocField").getValue()
		var toLoc = Ext.getCmp('LocField').getValue(); 
		if (ProLoc==toLoc){
			Msg.info("warning", $g("�����ź͹�Ӧ���Ų�����ͬ!"));
			return;
		}		
		var ProLocDesc=Ext.getCmp("supplyLocField").getRawValue()
		InRequestConWin(refresh,ProLoc,ProLocDesc);

		//InRequestGridDs.removeAll();
		//InRequestGridDs.load({params:{start:0,limit:PageSize,sort:'rowid',dir:'desc',req:req}});
	}
    });
    var copyBT = new Ext.Toolbar.Button({
		iconCls:'page_copy',
		height:30,
		width:70,
		text:$g('��������'),
		tooltip:$g('��������'),
		handler:function(){
			findRec(copyReq,$g("���ƿ��ת������"));
		}
	});
	function copyReq(req,transflag){
		selectReqLoc(createReq,req,transflag)
		}
	function createReq(req,reqloc,proloc,transflag)
	{
		Ext.Ajax.request({
			url : 'dhcst.inrequestaction.csp?actiontype=copy',
			params:{req:req,reqloc:reqloc,proloc:proloc,transflag:transflag},
			method : 'POST',
			waitMsg : $g('��ѯ��...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", $g("���Ƴɹ�!"));
					req = jsonData.info;
					refresh(req);
				}else{
					if(jsonData.info==-1){
						Msg.info("error", $g("������ʧ��!"));
					}else if(jsonData.info==-99){
						Msg.info("error", $g("�������ʧ��!"));
					}else if(jsonData.info==-2){
						Msg.info("error", $g("�������ʧ��!"));
					}else if(jsonData.info==-5){
						Msg.info("error", $g("��ϸ����ʧ��!"));
					}else if(jsonData.info==-4){
						Msg.info("error", $g("����������ʧ��!"));
					}else if(jsonData.info==-3){
						Msg.info("error", $g("������ʧ��!"));
					}else{
						Msg.info("error", $g("����ʧ��!"));
					}
				}
			},
			scope : this
		});
		
		}

	//ɾ��ת��������ϸ
	function DeleteDetail(){		
		if ((req!="")&&(Ext.getCmp('completeCK').getValue()==true))
		{
			Msg.info('warning',$g('��ǰ���������'));
			return;
		}
		
		//var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		
		var cell = InRequestGrid.getSelectionModel().getSelectedCell();
		if (cell==null){
			Msg.info("error",$g("��ѡ������!"));
			return false;
		}
     	var recordrow = cell[0];
		var selectrecord = InRequestGridDs.getAt(recordrow);		
		
		Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ����¼?'),
			function(btn) {
				if(btn == 'yes'){
						var reqItm = selectrecord.data['rowid'];
						if ((reqItm!="")&&(reqItm!=null)){  //�����첽,����refresh��������
				            var deleteret=tkMakeServerCall("web.DHCST.INReqItm","Delete",reqItm);
				            if (deleteret=="0"){
				            	InRequestGridDs.remove(selectrecord);
				            }
				            else{
					            if (deleteret==-1){
						          Msg.info("warning",$g("��ǰ���������!"));  
						        }else if(deleteret==-2){
							       Msg.info("warning",$g("��ǰ������ϸ�ѷ���ת��!")); 
						        }else if(deleteret==-3){
							       Msg.info("warning",$g("��ǰ������ϸ�ѽ�Ϊ�ɹ��ƻ�!")); 
						        }else{
							       Msg.info("error",$g("ɾ����ϸʧ��!"))
						        }						           
					         	return false; 
					         }
						}
						else{
							InRequestGridDs.remove(selectrecord);
						}
			
					
					InRequestGrid.getView().refresh();
					changeElementEnable();
					if (Ext.getCmp('requestNnmber').getValue()!=""){
						if (InRequestGrid.getStore().getCount()==0){
								delReq();
						}
					}
				}
			}
		 )
			
         setStatAmount();
	}
	
	function setStatAmount()
	{
		var rpAmt=0;
		var spAmt=0;
		var count = InRequestGrid.getStore().getCount();
		for (var i=0; i<count; i++)
		{
			var rowData = InRequestGridDs.getAt(i);
			rpAmt=rpAmt+rowData.get("rpAmt")*1;
			spAmt=spAmt+rowData.get("spAmt")*1;
		}
		spAmt=FormatGridSpAmount(spAmt);
		rpAmt=FormatGridRpAmount(rpAmt);
		rpText=$g("���ۺϼ�:  ")+rpAmt+$g("  Ԫ");
		spText=$g("�ۼۺϼ�:  ")+spAmt+$g("  Ԫ");
		Ext.getCmp("rpAmount").setText(rpText);
		Ext.getCmp("spAmount").setText(spText);	
	}
	///����JS������������ӣ�������λС������
	function FmtAmt(price,pos)
	{
		var price=Math.round(price*Math.pow(10,pos))/Math.pow(10,pos);
		return price;
	}
	//��ʼ��Ĭ��������
	InRequestGridCm.defaultSortable = true;
	
	var AddDetailBT=new Ext.Button({
		text:$g('����һ��'),
		tooltip:$g('�������'),
		iconCls:'page_add',
		handler:function(){
			var toLoc = Ext.getCmp('LocField').getValue(); 
			if((toLoc=="")||(toLoc==null)){
				Msg.info("warning", $g("��ѡ��������!"));
				return ;
			}
			var frLoc = Ext.getCmp('supplyLocField').getValue(); 
			if((frLoc=="")||(frLoc==null)){
				Msg.info("warning", $g("��ѡ�񹩸�����!"));
				return ;
			}
			if (toLoc == frLoc) {
				Msg.info("warning", $g("�����ź͹�Ӧ���Ų�����ͬ!"));
				return;
			}
			var rowCount =InRequestGrid.getStore().getCount();
			if(rowCount>0){
				var rowData = InRequestGridDs.data.items[rowCount - 1];
				var data=rowData.get("inci")
				if(data=="" || data.length<=0){
					Msg.info("warning",$g("�Ѵ����½���"));
					return;
				}
			}
			addNewRow();
		}
	})
	var DelDetailBT=new Ext.Button({
		text:$g('ɾ����¼'),
		tooltip:'',
		iconCls:'page_delete',
		handler:function()
		{
			DeleteDetail();
		}
	})
	
	var GridColSetBT = new Ext.Toolbar.Button({
		text:$g('������'),
	    tooltip:$g('������'),
	    iconCls:'page_gear',
//		width : 70,
//		height : 30,
		handler:function(){
			GridColSet(InRequestGrid,"DHCSTINREQ");
		}
	});

var newsm = new Ext.grid.CheckboxSelectionModel({  
        singleSelect : false, 
        ///yunhaibao20151118.shift,ctrl��ѡ����ͻ
		handleMouseDown : function(g, rowIndex, e){  
		        if (e.button !== 0 || this.isLocked()) {  
		               return;  
		        }  
		        var view = this.grid.getView();  
		        if (e.shiftKey && !this.singleSelect) {  
		             var last = this.last;  
		             this.selectRange(last, rowIndex, e.ctrlKey|| e.shiftKey);  
		             this.last = last;  
		             view.focusRow(rowIndex);  
		        }else{  
		             var isSelected = this.isSelected(rowIndex);  
		             if (e.ctrlKey && isSelected) {  
		                  this.deselectRow(rowIndex);  
		             }else if(!isSelected || this.getCount() > 0){  
		                  this.selectRow(rowIndex, e.ctrlKey || e.shiftKey);   
		                  view.focusRow(rowIndex);  
		             }  
		        }  
		  },
		onEditorKey : function(field, e){  
	        var k = e.getKey(),   
	        newCell,   
	        g = this.grid,   
	        last = g.lastEdit,  
	        ed = g.activeEditor,  
	        ae, last, r, c;  
	        var shift = e.shiftKey;  
	        if(k == e.TAB){  
	            e.stopEvent();  
	            ed.completeEdit();  
	            if(shift){  
	                newCell = g.walkCells(ed.row, ed.col-1, -1, this.acceptsNav, this);  
	            }else{  
	                newCell = g.walkCells(ed.row, ed.col+1, 1, this.acceptsNav, this);  
	            }  
	        }else if(k == e.ENTER){  
	            if(this.moveEditorOnEnter !== false){  
	                if(shift){  
	                    newCell = g.walkCells(last.row - 1, last.col, -1, this.acceptsNav, this);  
	                }else{  
	            //CheckboxSelectionModel���ø���Ext.grid.RowSelectionModel��onEditorKey����  
	            //ԭ����������newCell = g.walkCells(last.row+1, last.col, 1, this.acceptsNav, this);  
	                    newCell = g.walkCells(last.row , last.col, 1, this.acceptsNav, this);  
	                }  
	            }  
	        }  
	        if(newCell){  
	            r = newCell[0];  
	            c = newCell[1];  
  
	            if(last.row != r){  
	                this.selectRow(r);   
	            }  
  
	            if(g.isEditor && g.editing){   
	                ae = g.activeEditor;  
	                if(ae && ae.field.triggerBlur){  
                      
	                    ae.field.triggerBlur();  
	                }  
	            }  
	            var noeditcol=GetColIndex(this.grid,"desc");
	            if (c!=noeditcol)  //���IE11��������
	            { 
	            	g.startEditing(r, c);
	            }   
	        }  
	    }  
}); 

	//���
	InRequestGrid = new Ext.grid.EditorGridPanel({
		id:'reqItmEditGrid',
		title:$g('��������'),
		store:InRequestGridDs,
		cm:InRequestGridCm,
		trackMouseOver:true,
		height:476,
		stripeRows:true,
		region:'center',
		sm:new Ext.grid.CellSelectionModel({}), //newsm,
		loadMask:true,
		clicksToEdit:1,
		tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
		bbar:[rpAmount,'-',spAmount]
	});
	
	//zdm,�����Ҽ�ɾ����ϸ����
	InRequestGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
		e.preventDefault();
		rightClickMenu.showAt(e.getXY());
	});
	InRequestGrid.store.on('load',function(){
		
		setStatAmount();
	})
	
	var rightClickMenu=new Ext.menu.Menu({
		id:'rightClickMenu',
		items:[{id:'mnuDelete',text:$g('ɾ��'),handler:DeleteDetail}]
	});
	function changeElementEnable()
	{
		if (InRequestGrid.getStore().getCount()==0){
			groupField.setDisabled(false);
		}
		else{
			groupField.setDisabled(true);
		}
	}
//=========================��������Ϣ=================================

//===========ģ����ҳ��===========================================

	
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		title:$g('���������Ƶ�'),
		frame : true,
		tbar:[find,'-',clear,'-',add,'-',save,'-',complete,'-',cancelComplete,'-',ConWinBT,'-',copyBT,'-',printBT,'-',del],
		autoHeight:true,
		items : [{
			layout : 'column',			
			xtype : 'fieldset',
			title : $g('������Ϣ'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults:{border:false},
			items : [{
				columnWidth:0.3,
				xtype:'fieldset',
				//defaults:{width:200},
				items : [LocField,supplyLocField,groupField,reqType]
			},{
				columnWidth : 0.25,
				xtype:'fieldset',
				//defaults:{width:140},
				items : [requestNnmber,dateField,timeField,userField]
			},{
				columnWidth : 0.25,
				xtype:'fieldset',
				//defaults:{width:140},
				items : [remark]
			},{
				columnWidth : 0.2,
				xtype:'fieldset',
				//defaults:{width:120},
				items : [completeCK]
			}]
		}]	
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[{
			region:'north',
			layout:'fit',
			height:DHCSTFormStyle.FrmHeight(4),
			items:[formPanel]
		},{
			region:'center',
			layout:'fit',
			items:[InRequestGrid]
		}],
		renderTo:'mainPanel'
	});
	reqType.setValue("O");
	RefreshGridColSet(InRequestGrid,"DHCSTINREQ");   //�����Զ�������������������
	colArr = sortColoumByEnterSort(InRequestGrid);
});
//===========ģ����ҳ��===========================================
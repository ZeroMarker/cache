// ����:��汨���Ƶ�
// ��д����:2012-08-14
// 

var deptId = 0;
var deptName = "";
var purId = "";
var purNo = "";
var mainRowId="";
var reasonId = "";
var inscrapUrl='dhcst.inscrapaction.csp';
var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gParam = GetParam(); 

function GetParam(){
	var GetParamStr=tkMakeServerCall("web.DHCST.DHCINScrap","GetParamProp",groupId,CtLocId,userId)
	var gParamArr=GetParamStr.split('^');
	return gParamArr;
}


//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";
var colArr=[];

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('����'),
	//width:200,
	listWidth:210,
	emptyText:$g('����...'),
	groupId:gGroupId,
	anchor:'90%',
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


//=========================��汨���Ƶ�=============================
var dateField = new Ext.ux.DateField({
	id:'dateField',
	//width:200,
	listWidth:200,
    allowBlank:false,
	fieldLabel:$g('�Ƶ�����'),
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
	//width:200,
    allowBlank:false,
	fieldLabel:$g('�Ƶ�ʱ��'),
	//format:'HH-MM-SS',
	anchor:'90%',
	//value:new Time(),
	disabled:true
});

var userField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:$g('�Ƶ���'),
	width:200,
	anchor:'90%',
	disabled:true
});

var inscrapNumField = new Ext.form.TextField({
	id:'inscrapNumField',
	fieldLabel:$g('���𵥺�'),
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:$g('���𵥺�...'),
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// ҩƷ����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:$g('����'),
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
	fieldLabel:$g('����ԭ��'),
	//width:200,
	anchor:'90%',
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapurnStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:$g('����ԭ��...'),
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:0,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
ReasonForAdjustMentStore.load();
// ��ҳ����
var NumAmount = new Ext.form.TextField({
			emptyText : $g('��ҳ����'),
			id : 'NumAmount',
			name : 'NumAmount',
			anchor : '90%',
			width:200
		});	
// ���ۺϼ�
var RpAmount = new Ext.form.TextField({
			emptyText : $g('���ۺϼ�'),
			id : 'RpAmount',
			name : 'RpAmount',
			width:200,
			anchor : '90%'
		});			
// �ۼۺϼ�
var SpAmount = new Ext.form.TextField({
			emptyText : $g('�ۼۺϼ�'),
			id : 'SpAmount',
			name : 'SpAmount',
			anchor : '90%',
			width:200
		});
		
function GetAmount(){
	var RpAmt=0
	var SpAmt=0
	var Count = INScrapMGrid.getStore().getCount();
	for (var i = 0; i < Count; i++) {
		var rowData = INScrapMGridDs.getAt(i);
        if (rowData==undefined){
            continue;
        }
		var ScrapQty = rowData.get("qty");
		var Rp = rowData.get("rp");
		var Sp = rowData.get("sp");
		var RpAmt1=Number(Rp).mul(ScrapQty)
		var SpAmt1=Number(Sp).mul(ScrapQty);
	    RpAmt=accAdd(Number(RpAmt),Number(RpAmt1));
	    SpAmt=accAdd(Number(SpAmt),Number(SpAmt1));
	    //RpAmt=RpAmt+RpAmt1;
	    //SpAmt=SpAmt+SpAmt1;
		}
	RpAmt=FormatGridRpAmount(RpAmt);
	SpAmt=FormatGridSpAmount(SpAmt);
	Count=$g("��ǰ����:")+" "+Count	
	RpAmt=$g("���ۺϼ�:")+" "+RpAmt+" "+$g("Ԫ")
	SpAmt=$g("�ۼۺϼ�:")+" "+SpAmt+" "+$g("Ԫ")
	Ext.getCmp("NumAmount").setValue(Count)	
	Ext.getCmp("RpAmount").setValue(RpAmt)	
	Ext.getCmp("SpAmount").setValue(SpAmt)	
	}
var AddDetailBT=new Ext.Button({
	text:$g('����һ��'),
	tooltip:'',
	iconCls:'page_add',
	handler:function()
	{	
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:$g('ɾ��һ��'),
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});


var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:$g('��ע'),
	allowBlank:true,
	//width:200,
	height:50,
	emptyText:$g('��ע...'),
	anchor:'90%',
	selectOnFocus:true
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	boxLabel:$g('���'),
	disabled:true,
	allowBlank:true,
	listeners:{
		'check':function(chk,v){
			//alert('check');
			var grid=Ext.getCmp('INScrapMGrid');
			setGridEditable(grid,!v);
		}	
	}
});

var auditCK = new Ext.form.Checkbox({
	id: 'auditCK',
	boxLabel:$g('���'),
	disabled:true,
	allowBlank:true
});

var INScrapMGrid="";

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
	valueNotFoundText : ''
});
ItmUomStore.on('beforeload',function(store){
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	var record = INScrapMGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	
	var InciDr=inclb.split("||")[0];
	if (InciDr=='') return false;
	else
	{
		ItmUomStore.baseParams={ItmRowid:InciDr};
	}
	
});

//��λչ���¼�


CTUom.on('expand', function(combo) {

	combo.store.removeAll();
	combo.store.load();	

});

//��λ�任�¼�

CTUom.on('select', function(combo) {
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	var record = INScrapMGrid.getStore().getAt(cell[0]);
	
	var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //��λ��С��λ��ת����ϵ		
	var Uom = record.get("uom");    //Ŀǰ��ʾ�ı���λ
	var BatStkQty=record.get("inclbQty");
	var AvaStkQty=record.get("avalbQty");
	var Rp=record.get("rp");
	var Sp=record.get("sp");
	var NewStkQty=BatStkQty;
	var NewAvaStkQty=AvaStkQty;
	var NewRp=Rp
	var NewSp=Sp
	var qty=record.get("qty");
	var inclb =record.get("inclb");
	if(value!=Uom){
		var Inclb=record.get("inclb");
		var QtyAndPriceInfo = tkMakeServerCall("web.DHCST.Util.DrugUtil","GetIncilbInfo",Inclb,value)
		if (QtyAndPriceInfo=="") return;
		var InfoArr = QtyAndPriceInfo.split("^")
		record.set("sp", InfoArr[0] ); 
		record.set("rp", InfoArr[1] );
		record.set("inclbQty", InfoArr[2]);
		record.set("avalbQty", InfoArr[4]);
		
		/*
		if(value==BUom){
			NewStkQty=BatStkQty*ConFac;
			NewAvaStkQty=AvaStkQty*ConFac;
			NewRp=Rp/ConFac;
			NewSp=Sp/ConFac;
		}else{
			NewStkQty=BatStkQty/ConFac;
			NewAvaStkQty=AvaStkQty/ConFac;
			NewRp=Rp*ConFac;
			NewSp=Sp*ConFac;
		}
		record.set("inclbQty",NewStkQty)
		record.set("avalbQty",NewAvaStkQty)
		record.set("rp",NewRp)
		record.set("sp",NewSp)
		*/
	}
  
   //ʹҳ������б���2λС��
   //С��λ������
   if ((qty!=null)&&(qty!=0)){
		var newSpAmt=qty*record.get('sp');
		var newRpAmt=qty*record.get('rp');
		newSpAmt=1*FormatGridSpAmount(newSpAmt);
		newRpAmt=1*FormatGridRpAmount(newRpAmt);
		record.set("spAmt",newSpAmt);
		record.set("rpAmt",newRpAmt); 	
   }	
       //var ingri=record.get("ingri");
	record.set("uom", combo.getValue());
	GetAmount();	
	//var Uom=record.get("uom"); 
	//SetIngriPrice(record,ingri,Uom);


	
});
//====================================================
//====================================================



//��������Դ
var INScrapMGridUrl = 'dhcst.inscrapaction.csp';
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
		{name:'avalbQty'},
		{name:'buom'},
		{name:'confac'}
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
        header:"IncRowid",
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
        header:$g("����"),
        dataIndex:'code',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'desc',
        id:'desc',
        width:300,
        align:'left',
        sortable:true,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
            selectOnFocus : true,
			listeners:{
				specialKey:function(field, e) {
					setKeyEventSort(INScrapMGrid,colArr)
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp('groupField').getValue());
					}
				}
			}
        })
    },{
        header:$g("����~Ч��"),
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("������ҵ"),
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("���ο��"),
        dataIndex:'inclbQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("���ο��ÿ��"),
        dataIndex:'avalbQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("��������"),
        dataIndex:'qty',
        id:'adjQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.ux.NumberField({
			id:'qtyField',
			formatType:'FmtSQ',
            allowBlank:false,
            allowNegative :false,
            selectOnFocus : true,
			listeners:{				
				specialKey:function(field, e) {
					if (setKeyEventSort(INScrapMGrid,colArr,false)){
						var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
						var rowData = INScrapMGridDs.getAt(cell[0]);
						var col=GetColIndex(INScrapMGrid,'qty');
						var newqty=field.getValue();
						
						var buomId=rowData.get("buom")
	                    var uom=rowData.get("uom")
	                    var buomQty=newqty
	                    var fac=rowData.get("confac")
						
						if(newqty>rowData.get('inclbQty')){
							Msg.info("warning",$g("�����������ܴ������ο��!"));
							INScrapMGrid.startEditing(cell[0], col);
							return;
						}
						else if(newqty>rowData.get('avalbQty')){
							Msg.info("warning",$g("�����������ܴ������ο��ÿ��!"));			
							INScrapMGrid.startEditing(cell[0], col);
							return;
						}else if(gParam[0]!="Y")  ////�������������Ƿ�����С���ж� 2021-04-17 yangsj 1 ����¼��С��
                		{
	                		if(buomId!=uom)
		                    {
		                        buomQty=Number(fac).mul(newqty);
		                    }
		                    if((buomQty.toString()).indexOf(".")>=0)
		                    {
			                    Msg.info("warning", $g(" ������������ɻ�����λ֮�����С�������ܵ�������˶Կ���������!��������������Ϊ������λ�Ƿ�����С��"));
			                    return;
		                    }
                		}else{
							//ʹҳ������б���2λС��
							//С��λ������
							//var pos = 2;
							//rowData.set("spAmt",Math.round(newqty*rowData.get('sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							//rowData.set("rpAmt",Math.round(newqty*rowData.get('rp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							//rowData.set("ppAmt",Math.round(newqty*rowData.get('pp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							var newSpAmt=newqty*rowData.get('sp');
							var newRpAmt=newqty*rowData.get('rp');
							var newPpAmt=newqty*rowData.get('pp');
							newSpAmt=1*FormatGridSpAmount(newSpAmt);
							newRpAmt=1*FormatGridRpAmount(newRpAmt);
							newPpAmt=1*FormatGridPpAmount(newPpAmt);
							rowData.set("spAmt",newSpAmt);
							rowData.set("rpAmt",newRpAmt);
							rowData.set("ppAmt",newPpAmt);
							if(setEnterSort(INScrapMGrid,colArr)){
									addNewRow();
							}
							GetAmount();
						}

					}
					setKeyEventSort(INScrapMGrid,colArr) 
                }
			}
        })
    },{
        header:$g("��λ"),
        dataIndex:'uom',
        id:'uom',
        width:100,       
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
		editor : new Ext.grid.GridEditor(CTUom),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(INScrapMGrid,"uom");
					INScrapMGrid.startEditing(cell[0], colIndex);									
				}
			}
		}
    },{
        header:$g("�ۼ�"),
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
    }
]);
//��ʼ��Ĭ��������
INScrapMGridCm.defaultSortable = true;

var addINScrapM = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		newInscrap();
		//if (isDataChanged()){
		//	Ext.Msg.show({
		//		title:'��ʾ',
		//		msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
		//		buttons: Ext.Msg.YESNO,
		//		fn: function(btn){
		//	   		if (btn=='yes') {newInscrap();}
		//	   }

		//	})		
		//}
		//else
		//{
		//	newInscrap();
		//}
	}
});
function newInscrap()
{
		mainRowId='';
		clearPage();
		addNewRow();
	}
var findINScrapM = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		//clearPage();
		find();
		//if (isDataChanged())
		//{
		//	{
		//		Ext.Msg.show({
		//			title:'��ʾ',
		//			msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
		//			buttons: Ext.Msg.YESNO,
		//			fn: function(btn){
		//		   		if (btn=='yes') {clearPage();find();}
		//		   }
	
		//		})
			
		//	}	
		//}
		//else{
		//	find();
			//if (Ext.getCmp('scrapWinFind'))
			//{Ext.getCmp('scrapWinFind').show();}
			//else
			//{FindINScrap(INScrapMGridDs,inscrapNumField,finshCK,auditCK,mainRowId,locField,dateField,reasonId,addINScrapM,selectInscrap);}
		//}
		
	}
});
function find()
{
		if (Ext.getCmp('scrapWinFind'))
		{Ext.getCmp('scrapWinFind').show();}
		else
		{FindINScrap(INScrapMGridDs,inscrapNumField,finshCK,auditCK,mainRowId,locField,dateField,reasonId,addINScrapM,selectInscrap);}
		
	}
	
var clearINScpM = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
	
		if (isDataChanged())
		{
			Ext.Msg.show({
				title:$g('��ʾ'),
				msg: $g('�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������'),
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

var saveINScrapM = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(CheckDataBeforeSave()==true){
			// ���汨��
			save();
		}		
	}	
});


var deleteINScrapM = new Ext.Toolbar.Button({
	text:$g('ɾ��'),
    tooltip:$g('ɾ��'),
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var rowid=mainRowId;
		if(rowid!=""){
			Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫɾ����ǰ����?'),function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url : 'dhcst.inscrapaction.csp?actiontype=delete&inscrap='+mainRowId,
						waitMsg:$g('ɾ����...'),
						failure: function(result, request) {
							Msg.info("error", $g("������������!"));
							return false;
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", $g("ɾ���ɹ�!"));
								clearPage();
								//INScrapMGridDs.load({params:{inscrap:mainRowId}});
							}else{
								var ret=jsonData.info
								if(ret==-1){
									Msg.info("error", $g("�����Ѿ���ɣ�����ɾ��!"));
								}else if(ret==-2){
									Msg.info("error", $g("�����Ѿ���ˣ�����ɾ��!"));
								}else{
									Msg.info("error", $g("ɾ��ʧ��!"+ret));
								}
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
			Msg.info('warning',$g('û�б��𵥣����Ȳ�ѯ��'));
			return;
		}
	}
});

var finshScp = new Ext.Toolbar.Button({
	id:'finshScp',
	text:$g('���'),
    tooltip:$g('���'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var rowCount = INScrapMGrid.getStore().getCount();
		if(rowCount==0)
		{
			Msg.info('error',$g('û���κ���ϸ��¼!'));
			return false;
		}
		var finshCK = Ext.getCmp('finshCK').getValue();
        var mod = isDataChanged();
        if (mod && (!finshCK)) {
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
    
     // ���
     
	function Complete(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", $g("����Ϊ��!���Ȳ�ѯ"));
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==true)	{	return;	}
			
			Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫ��ɸñ�����?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inscrapaction.csp?actiontype=finish&InscpId='+mainRowId,
							waitMsg:$g('������...'),
							failure: function(result, request) {
								Msg.info("error", $g("������������!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", $g("�������!"));
									selectInscrap(mainRowId);
								}else{
									if(jsonData.info==-1){
										Msg.info("error", $g("�����Ѿ����!"));
										return false;
									}
									if(jsonData.info==-3){
										Msg.info("error", $g("����ʧ��!"));
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
var noFinshScp = new Ext.Toolbar.Button({
	text:$g('ȡ�����'),
    tooltip:$g('ȡ�����'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", $g("����Ϊ��!���Ȳ�ѯ"));
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==false)	{Msg.info("error", $g("�ñ�����δ���!"));return;	}
			Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫȡ����ɸñ�����?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcst.inscrapaction.csp?actiontype=noFinish&InscpId='+mainRowId,
							waitMsg:$g('������...'),
							failure: function(result, request) {
								Msg.info("error", $g("������������!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", $g("�ɹ�ȡ���������״̬!"));
									selectInscrap(mainRowId);
									
								}else{
									if(jsonData.info==-1){
										Msg.info("error", $g("������δ���!"));
										return false;
									}
									if(jsonData.info==-2){
										Msg.info("error", $g("�����Ѿ���ˣ�����ȡ�����!"));
										return false;
									}
									if(jsonData.info==-3){
										Msg.info("error", $g("����ʧ��!"));
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
	text : $g('��ӡ'),
	tooltip : $g('��ӡ����'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId ==null || mainRowId=="") {
			Msg.info("warning", $g("û����Ҫ��ӡ�ı���!"));
			return;
		}
		PrintINScrap(mainRowId);
	}
});


var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	layout:'fit',
	labelAlign : 'right',
	frame : true,
    tbar:[findINScrapM,'-',clearINScpM,'-',addINScrapM,'-',saveINScrapM,'-',finshScp,'-',noFinshScp,'-',printScp,'-',deleteINScrapM],
	items : [{
		xtype : 'fieldset',
		title : $g('������Ϣ'),
		//defaultWidth:200,
		autoHeight : true,
		autoScroll:true,
		style:DHCSTFormStyle.FrmPaddingV,
		//layout:'fit',
		items : [{
			layout : 'column',
			autoScroll:true,
			items : [{
				columnWidth : .263,
				labelWidth: 60,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [inscrapNumField,locField,causeField]
			}, {
				columnWidth : .25,
				labelWidth: 60,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [dateField,timeField,userField]
			}, {
				columnWidth : .25,
				labelWidth: 60,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [groupField,remarkField]
			}, {
				columnWidth : .2,
				labelWidth: 10,	
            	xtype: 'fieldset',
            	defaultType: 'textfield',
            	border: false,
				items : [finshCK,auditCK]
			}]
		}]
	}]
 
});
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('������'),
    tooltip:$g('������'),
    iconCls:'page_gear',
	handler:function(){
		GridColSet(INScrapMGrid,"DHCSTINSCRAP");
	}
});
//���
INScrapMGrid = new Ext.grid.EditorGridPanel({
	title:$g('��ϸ��¼'),
	store:INScrapMGridDs,
	id:'INScrapMGrid',
	cm:INScrapMGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT]},
	clicksToEdit:1,
	bbar:new Ext.Toolbar({items:[NumAmount,RpAmount,SpAmount]})
});
INScrapMGrid.getView().on('refresh',function(Grid){
	GetAmount()
	})

		//����Ҽ��˵�
		
		
INScrapMGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
var rightClick = new Ext.menu.Menu({ 
	id:'rightClickCont', 
	items: [ 
		{ 
			id: 'mnuDelete', 
			handler: DeleteDetail, 
			text: $g('ɾ��' )
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
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "1", "","",returnInfo);
			
	}
}
		
function addNewRow() {

	//�ж������Ƿ��Ѿ�
	if  (Ext.getCmp('groupField').getRawValue()=='')
	{	 Ext.getCmp('groupField').setValue(null);}

	var scg = Ext.getCmp('groupField').getValue(); 
	if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error", $g("��ѡ������!"));
		return ;
	}
	// �ж��Ƿ��Ѿ��������
	var rowCount = INScrapMGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INScrapMGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			var col=GetColIndex(INScrapMGrid,'desc');
			INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, col);
			return;
		}
	}
	var NewRecord=CreateRecordInstance(INScrapMGridDs.fields);				
	INScrapMGridDs.add(NewRecord);
	var col=GetColIndex(INScrapMGrid,'desc');
	INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, col);
	setEditDisable();
	GetAmount();
}		

function clearPage()
{
	mainRowId="";
	Ext.getCmp('inscrapNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('adjUserField').setValue("");		
	Ext.getCmp('causeField').setValue("");
	Ext.getCmp('causeField').setRawValue("");
	Ext.getCmp('remarkField').setValue("");
	
	Ext.getCmp('finshCK').setValue("");
	Ext.getCmp('auditCK').setValue("");
	Ext.getCmp("NumAmount").setValue("");
	Ext.getCmp("RpAmount").setValue("");
	Ext.getCmp("SpAmount").setValue("");
	
	INScrapMGridDs.removeAll();
	
	this.deleteINScrapM.enable();
	this.saveINScrapM.enable();
	
	setEditEnable();
}
function addComboData(store, id, desc) {
	var defaultData = {
		RowId : id,
		Description : desc
	};
	var r = new store.recordType(defaultData);
	store.add(r);
}
//���ҿ����������Ϣ���ڹر�ʱ�ص�����
function returnInfo(record) {
	if (record == null || record == "") {
		return;
	}
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	var rowData = INScrapMGrid.getStore().getAt(cell[0]);
	var INCLBWARNFLAG= record.get("InclbWarnFlag");
	if (INCLBWARNFLAG=="2"){
		Msg.info("warning", $g("��ҩƷ������״̬Ϊ������!"));
		return;
	}
	inciDr = record.get("InciDr");
	rowData.set("inci",inciDr);
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	rowData.set("batNo",record.get("BatExp"));
	rowData.set("manf",record.get("Manf"));
	var uom=record.get("PurUomId")
	var uomDesc=record.get("PurUomDesc")
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set("uom",record.get("PurUomId"));
	rowData.set("uomDesc",record.get("PurUomDesc"));
	rowData.set("sp",record.get("Sp"));
	rowData.set("rp",record.get("Rp"));
	rowData.set("inclbQty",record.get("InclbQty"));
	rowData.set("avalbQty",record.get("AvaQty"));
	rowData.set("inclb",record.get("Inclb"));
	var buom=record.get('BUomId');
	var confac=record.get('ConFac');
	var rp=record.get("Rp")
	var sp=record.get("Sp")
	puomRp=rp;
	puomSp=sp;
	buomRp=puomRp/confac;
	buomSp=puomSp/confac;
    rowData.set("confac",confac);
	rowData.set("buom",buom);
	rowData.set("rp",rp);
	rowData.set("sp",sp);
	var qty=rowData.get("qty")
	rowData.set("spAmt",Math.round(qty*rowData.get('sp')*Math.pow(10,2))/Math.pow(10,2)); 
	rowData.set("rpAmt",Math.round(qty*rowData.get('rp')*Math.pow(10,2))/Math.pow(10,2));
	if(setEnterSort(INScrapMGrid,colArr)){
			addNewRow();
	}
}
function CheckDataBeforeSave(){
	var user = UserId;
	var locId = Ext.getCmp('locField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error",$g("��ѡ��Ӧ����!"));
		return false;
	}
	var scg = Ext.getCmp('groupField').getValue();
	if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error",$g("��ѡ������!"));
		return false;
	}
	var scpReason = Ext.getCmp('causeField').getValue();
	if((scpReason=="")||(scpReason==null)){
		Msg.info("error",$g("��ѡ����ԭ��!"));
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
				if (inclb=='') continue;
				var uom = rowData.get("uom");
				if (uom=='') continue;
				var qty = rowData.get("qty");
				if (qty=='') {
					Msg.info("warning",$g("��")+(i+1)+$g("�б�������Ϊ��!"));
					return;
				}
				rowCnt++;
			}
		}
		if (rowCnt==0){Msg.info('warning',$g('û���κ���ϸ!��ֹ����.'));return false;}
		// �ж��ظ�����ҩƷ
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var item_i = INScrapMGridDs.getAt(i).get("inclb");;
				var item_j = INScrapMGridDs.getAt(j).get("inclb");;
				var itemdesc=INScrapMGridDs.getAt(i).get("desc");;
				var icnt=i+1;
				var jcnt=j+1;
				if (item_i != "" && item_j != ""
						&& item_i == item_j ) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", itemdesc+$g(",��")+icnt+","+jcnt+$g("��ҩƷ�ظ�������������!"));
					return false;
				}
			}
		}
	}
	
	return true;
}
// �任����ɫ
function changeBgColor(row, color) {
	INScrapMGrid.getView().getRow(row).style.backgroundColor = color;
}
function save(){
	var scpUser = UserId;
	var scpInst = "";
	var scpNo = Ext.getCmp("inscrapNumField").getValue();
	var scpLoc = Ext.getCmp('locField').getValue();
	var scpComp = (Ext.getCmp('finshCK').getValue()==true?'Y':'N');
	var scpState = (Ext.getCmp('auditCK').getValue()==true?'Y':'N');
	var scpReason = Ext.getCmp('causeField').getValue();
	var scpScg = Ext.getCmp('groupField').getValue();
	var remark = Ext.getCmp('remarkField').getValue();  //��ע
	var inscrapno = Ext.getCmp('inscrapNumField').getValue();
	
	remark=remark.replace(/\r\n/g,xMemoDelim());
	
	var tmpData = scpUser+"^"+scpLoc+"^"+scpComp+"^"+scpReason+"^"+scpScg+"^"+remark+"^"+inscrapno;
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INScrapMGrid.getStore().getCount();
		if(rowCount==0)
		{
			Msg.info('error',$g('û���κ���ϸ��¼!'));
			return false;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				if (inclb==""){
					continue;
				}
				var uom = rowData.get("uom");
				var qty = rowData.get("qty");
				var inclbQty=rowData.get("inclbQty");
				var avalbQty=rowData.get("avalbQty");
				///if(qty>inclbQty){Msg.info("warning","�����������ܴ������ο��");
				///								return }
				if(qty>avalbQty){Msg.info("warning",$g("��")+(i+1)+$g("�б����������ܴ������ο��ÿ��"));
												return }
				if(qty<=0){Msg.info("warning",$g("��")+(i+1)+$g("�б��������������0"));return }
												
				var buomId=rowData.get("buom")
	            var buomQty=qty
	            var fac=rowData.get("confac")
				if(gParam[0]!="Y")  ////�������������Ƿ�����С���ж� 2020-02-20 yangsj 1 ����¼��С��
	    		{
	        		if(buomId!=uom)
	                {
	                    buomQty=Number(fac).mul(qty);
	                }
	                if((buomQty.toString()).indexOf(".")>=0)
	                {
	                    Msg.info("warning", rowData.get("desc")+$g("������������ɻ�����λ֮�����С�������ܵ�������˶Կ��������ã�������������Ϊ������λ�Ƿ�����С��!"));
	                    return;
	                }
	    		}								
				
				var Rp = rowData.get("rp");
				var rpAmt = rowData.get("rpAmt");
				var Sp = rowData.get("sp");
				var spAmt =rowData.get("spAmt");
				var Pp = rowData.get("pp");
				var ppAmt = rowData.get("ppAmt");
				var rowStr = Inspi + "^" + inclb + "^"	+ uom + "^" + qty + "^"	+ Rp + "^" + rpAmt + "^"  + Pp + "^" + ppAmt + "^" + Sp+ "^" + spAmt
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
			waitMsg : $g('������...'),
			failure: function(result,request) {
				Msg.info("error",$g("������������!"));
			},
			success: function(result,request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );			
				if (jsonData.success=='true') {
					Msg.info("success",$g("����ɹ�!"));
					mainRowId = jsonData.info;
					
					selectInscrap(mainRowId);
				}
				if(jsonData.success=='false'){
					var ret=jsonData.info;
					if(ret==-8){
						Msg.info("error", $g("�����Ѿ����!"));
					}else if(ret==-9){
						Msg.info("error", $g("�����Ѿ����!"));
					}else{
						Msg.info("error",$g("����ʧ��!")+ret);
					}
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
	INScrapMGridDs.load({
		params:{start:0,limit:999,inscrap:InscpRowid},
		callback : function(r,options, success){
			if(success==false){
				Ext.MessageBox.alert($g("��ѯ����"),this.reader.jsonData.Error); 
 			}
		}		
	});
	

	// �����ť�Ƿ����
	//��ѯ^���^����^����^ɾ��^���^ȡ�����
	//var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	//i/f(inGrFlag==true){
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
		
		// ɾ��ѡ����ҩƷ
		 
function DeleteDetail() {
	// �жϱ����Ƿ������
	var CmpFlag = Ext.getCmp("finshCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", $g("���������,��ֹɾ����ϸ��¼!"));
		return;
	}
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", $g("��ѡ������!"));
		return;
	}
	// ѡ����
	var row = cell[0];
	var record = INScrapMGrid.getStore().getAt(row);
	var Inspi = record.get("inspi");
	if (Inspi == "" ) {
		INScrapMGrid.getStore().remove(record);
		INScrapMGrid.getView().refresh();
		GetAmount();
		if (INScrapMGrid.getStore().getCount()==0){
			setEditEnable();
		}			
	} else {
		Ext.MessageBox.show({
			title : $g('��ʾ'),
			msg : $g('�Ƿ�ȷ��ɾ����ҩƷ��Ϣ?'),
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});
	}
	

}
		
		 // ɾ����ʾ
		
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
			waitMsg : $g('ɾ����...'),
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", $g("ɾ���ɹ�!"));
					INScrapMGrid.getStore().remove(record);
					INScrapMGrid.getView().refresh();
					GetAmount();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", $g("�����Ѿ���ɣ�����ɾ��!"));
					}else if(ret==-2){
						Msg.info("error", $g("�����Ѿ���ˣ�����ɾ��!"));
					}else{
						Msg.info("error", $g("ɾ��ʧ��,��鿴������־!"));
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
function addDetailRow()
{
	
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true))
	{
		Msg.info('warning',$g('��ǰ���������,��ֹ������ϸ��¼!'));
		return;
	}
	var rowCount =INScrapMGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = INScrapMGridDs.data.items[rowCount - 1];
		var data=rowData.get("inci")
		if(data=="" || data.length<=0){
		    Msg.info("warning",$g("�Ѵ����½���")) ;
		    return;	  }
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
			 	var loc=data[0]['INSCP_CTLOC_DR']   ;			
			 	var locDesc=data[0]['locDesc']   ;
			 	var scg=data[0]['INSCP_SCG_DR'] ;
			 	var reason=data[0]['INSCP_Reason'];
			 	var reasonDesc=data[0]['reason'];
			 	addComboData(Ext.getCmp("locField").getStore(),loc,locDesc);
			 	Ext.getCmp('locField').setValue(loc);
			 	var inscrapNo=data[0]['INSCP_NO']  ;
			 	var adjDate=data[0]['INSCP_Date'];
			 	var adjTime=data[0]['INSCP_Time'] ;
			 	var completeFlag=data[0]['INSCP_Completed'] ; 
			 	var auditFlag=data[0]['INSCP_ChkFlag'] ;
			 	var remark=data[0]['INSCP_Remarks']  ;
			 	var userName=data[0]['userName'] ;
			 	var auditUserName=data[0]['INSCP_ChkUser_DR'] ;
			 	var chkDate=data[0]['INSCP_ChkDate'];
			 	var chkTime=data[0]['INSCP_ChkTime'];
			
				inscrapNumField.setValue(inscrapNo);
				locField.setValue(loc);
				//locField.setRawValue(locDesc);
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
				if(auditFlag=='Y'){
					auditCK.setValue(true);
				
				}else{
					auditCK.setValue(false);
				}
				
				causeField.setValue(reason);
				causeField.setRawValue(reasonDesc);
				remark=handleMemo(remark,xMemoDelim());
				remarkField.setValue(remark);	
				groupField.setValue(scg);
			
				//������ϸ
				getDetail(mainRowId);
				GetAmount();
				
			}	
		
		if (mainRowId>0)
		{
			setEditDisable();
			SetFormOriginal(formPanel);
		}
		}
	})


}
function setGridEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('adjQty');	        
	grid.getColumnModel().setEditable(colId,b);
	
}


//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}	
	var panel = new Ext.Panel({
		title:$g('��汨���Ƶ�'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(3),
		layout:'fit',
		//frame:true,
		items:[formPanel] //
		//autoScroll:true
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,INScrapMGrid], //
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INScrapMGrid,"DHCSTINSCRAP");   //�����Զ�������������������
	colArr=sortColoumByEnterSort(INScrapMGrid); //���س��ĵ���˳���ʼ����
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
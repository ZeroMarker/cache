// ����:�������Ƶ�
// ��д����:2012-08-27
var deptId = 0;
var deptName = "";
var purId = "";
var purNo = "";
var mainRowId="";
var reasonId = "";
//���ݼƻ�����purId��ѯ�����Ϣ
if((purId!="")&&(purId!=null)&&(purId!=0)){
	Ext.Ajax.request({
		url : 'dhcst.inpurplanauxbyrequestaction.csp?actiontype=select&purId='+purId,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var arr = jsonData.info.split("^");
			purNo = arr[1];
			deptName = arr[3];
		},
		scope : this
	});
}
var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var inciDr = "";


//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name : 'locField',
	fieldLabel:'����',
	//width:120,
	listWidth:200,
	emptyText:'����...',
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
var adjUserField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:'������',
	anchor:'90%',
	disabled:true
});


//=========================�������Ƶ�=============================
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
	//format:'HH-MM-SS',
	anchor:'90%',
	//value:new Time(),
	disabled:true
});

var adjNumField = new Ext.form.TextField({
	id:'adjNumField',
	fieldLabel:'��������',
	allowBlank:true,
	//width:120,
	emptyText:'��������...',
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
	listWidth:200,
	emptyText:'��ע...',
	anchor:'90%',
	selectOnFocus:true
});

// ҩƷ����
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:CtLocId,
	UserId:UserId,
	anchor : '90%'
});

// ����ԭ��
var causeField = new Ext.form.ComboBox({
	id:'causeField',
	fieldLabel:'����ԭ��',
	listWidth:200,
	allowBlank:true,
	store:ReasonForAdjustMentStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'����ԭ��...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%'
});
ReasonForAdjustMentStore.load();

var adjComplete=new Ext.Toolbar.Button({
	text:'�������',
	height:30,
	width:70,
	iconCls:'page_gear',
	handler:function(){
		var finshCK = Ext.getCmp('finshCK').getValue();
        var mod = isDataChanged();
        if (mod && (!finshCK)) {
            Ext.Msg.confirm('��ʾ', '�����ѷ����ı�,�Ƿ���Ҫ��������?',
                function(btn) {
                    if (btn == 'yes') {
                        return;
                    } else {
                        setComplete();
                    }

                }, this);
        } else {
            setComplete();
        }
	}
});

var cancelAdjComplete=new Ext.Toolbar.Button({
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
	tooltip : '��ӡ������',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId==null || mainRowId=="") {
			Msg.info("warning", "û����Ҫ��ӡ�ĵ�����!");
			return;
		}
		PrintInAdj(mainRowId);
	}
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	boxLabel:'���',
	disabled:true,
	allowBlank:true,
	listeners:{
		'check':function(chk,v){
			//alert('check');
			var grid=Ext.getCmp('INAdjMGrid');
			setGridEditable(grid,!v)
		}
	}
});

var auditCK = new Ext.form.Checkbox({
	id: 'auditCK',
	boxLabel:'���',
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
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'ɾ��һ��',
	height:30,
	width:70,
	tooltip:'',
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});

var GridColSetBT = new Ext.Toolbar.Button({
	text:'������',
    tooltip:'������',
    iconCls:'page_gear',
//	width : 70,
//	height : 30,
	handler:function(){
		GridColSet(INAdjMGrid,"DHCSTSTOCKADJ");
	}
});

// ���ۺϼ�
var rpAmount = new Ext.form.Label({
	text : '���ۺϼ�:',
	id : 'rpAmount',
	width:500,
	anchor : '90%'
	});	
		
// �ۼۺϼ�
var spAmount = new Ext.form.Label({
	text : '�ۼۺϼ�:',
	id : 'spAmount',
	anchor : '90%',
	width:200
	});
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
	emptyText : '��λ...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	listWidth : 250	,
	valueNotFoundText : ''
});
ItmUomStore.on('beforeload',function(store){
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var record = INAdjMGrid.getStore().getAt(cell[0]);
	var inclb = record.get("inclb");
	
	var InciDr=inclb.split("||")[0];
	if (InciDr=='') return false;
	else
	{
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
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var record = INAdjMGrid.getStore().getAt(cell[0]);
	
	var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
	var BUom = record.get("buom");
	var ConFac = record.get("confac");   //��λ��С��λ��ת����ϵ		
	var Uom = record.get("uom");    //Ŀǰ��ʾ�ĵ�����λ
	var BatStkQty=record.get("InclbAvaQty");
	var Rp=record.get("rp");
	var Sp=record.get("sp");
	var NewStkQty=BatStkQty;
	var NewRp=Rp
	var NewSp=Sp
	var qty=record.get("qty");
	var pos = 2;
	if(value!=Uom){
		if(value==BUom){
			NewStkQty=BatStkQty*ConFac;
			NewRp=Rp/ConFac;
			NewSp=Sp/ConFac;
		}else{
			NewStkQty=BatStkQty/ConFac;
			NewRp=Rp*ConFac;
			NewSp=Sp*ConFac;
		}

		record.set("InclbAvaQty",NewStkQty)
		record.set("rp",NewRp)
		record.set("sp",NewSp)
			
		
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
   		setStatAmount();
   }	
      
	record.set("uom", combo.getValue());	

	
});

//��������Դ
var INAdjMGridUrl = 'dhcst.inadjaction.csp';
var INAdjMGridProxy= new Ext.data.HttpProxy({url:INAdjMGridUrl+'?actiontype=queryItem',method:'GET'});
var INAdjMGridDs = new Ext.data.Store({
	proxy:INAdjMGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'adjitm'},
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
		{name:'insti'},
		{name:'InclbAvaQty'},  //InclbAvaQty
		{name:'buom'},
		{name:'confac'}
	]),
    remoteSort:false
});

//ģ��
var INAdjMGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"��ϸrowid",
        dataIndex:'adjitm',
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
        header:"ҩƷrowid",
        dataIndex:'inci',
        width:150,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'desc',
        id:'desc',
        width:150,
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
        width:80,
        align:'left',
        sortable:true //,
		//hidden:true
    },{
        header:"����",
        dataIndex:'manf',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����~Ч��",
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    
    },{
        header:"������λ",
        dataIndex:'uom',
        id:'uom',
        width:80,       
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.comboRenderer2(CTUom,"uom","uomDesc"),								
		editor : new Ext.grid.GridEditor(CTUom),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {	
					var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
					var colIndex=GetColIndex(INAdjMGrid,"uom");
					INAdjMGrid.startEditing(cell[0], colIndex);									
				}
			}
		}
    },{
        header:"���ο��ÿ��",
        dataIndex:'InclbAvaQty',
        width:120,
        align:'right',
        sortable:true
    },{
        header:"��������",
        id:'adjQty',
        dataIndex:'qty',        
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.ux.NumberField({
			id:'qtyField',
			formatType:'FmtSQ',
            allowBlank:false,
			listeners:{
                specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {	
						var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
						var rowData = INAdjMGridDs.getAt(cell[0]);
						var col=GetColIndex(INAdjMGrid,'qty');
						var newqty=field.getValue();
						
						var buomId=rowData.get("buom")
	                    var uom=rowData.get("uom")
	                    var buomQty=newqty
	                    var fac=rowData.get("confac")
						
						if(newqty<0 && (Math.abs(newqty)>rowData.get('InclbAvaQty'))){
							Msg.info("warning","��������Ϊ����ʱ���ܳ������ο��!");
							return false;
						}else if(gParam[0]!=1)  ////�������������Ƿ�����С���ж� 2020-02-20 yangsj 1 ����¼��С��
                		{
	                		if(buomId!=uom)
		                    {
		                        buomQty=Number(fac).mul(newqty);
		                    }
		                    if((buomQty.toString()).indexOf(".")>=0)
		                    {
			                    Msg.info("warning", " ������������ɻ�����λ֮�����С�������ܵ�������˶Կ���������!��������������Ϊ������λ�Ƿ�����С��");
			                    return;
		                    }
                		}
						
						else{
							//ʹҳ������б���2λС��
							//С��λ������
							var newSpAmt=newqty*rowData.get('sp');
							var newRpAmt=newqty*rowData.get('rp');
							newSpAmt=1*FormatGridSpAmount(newSpAmt);
							newRpAmt=1*FormatGridRpAmount(newRpAmt);
							rowData.set("spAmt",newSpAmt);
							rowData.set("rpAmt",newRpAmt);
							//rowData.set("spAmt",Math.round(newqty*rowData.get('sp')*Math.pow(10,pos))/Math.pow(10,pos)); 
							//rowData.set("rpAmt",Math.round(newqty*rowData.get('rp')*Math.pow(10,pos))/Math.pow(10,pos));							
							addNewRow();
							setStatAmount();
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
        sortable:true
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
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
        renderer:FormatGridRpAmount
    }
]);
//��ʼ��Ĭ��������
INAdjMGridCm.defaultSortable = true;

var addINAdjM = new Ext.Toolbar.Button({
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
var findINAdjM = new Ext.Toolbar.Button({
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
				   		if (btn=='yes') {clearPage();FindINAdj(INAdjMGridDs,adjNumField,mainRowId,locField,dateField,addINAdjM,finshCK,auditCK,select);}
				   }
	
				})
			
			}	
		}
		else
		{
			//clearPage();
		FindINAdj(INAdjMGridDs,adjNumField,mainRowId,locField,dateField,addINAdjM,finshCK,auditCK,select);
	}
	
	
	
		
	}
});


var saveINAdjM = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		save();
    }
});

var deleteINAdjM = new Ext.Toolbar.Button({
	text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		deleteAdj();
	}
});

var clearINAdjM = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
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


var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findINAdjM,'-',clearINAdjM,'-',addINAdjM,'-',saveINAdjM,'-',adjComplete,'-',cancelAdjComplete,'-',printInadj,'-',deleteINAdjM],
	items : [{
		//autoHeight : true,
		layout : 'fit',
		autoScroll:true,
		items : [{
			xtype : 'fieldset',
			title : '��������Ϣ',	
			autoHeight : true,
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{				
				layout : 'column',
				items : [{
					columnWidth : .26,
					xtype : 'fieldset',
					border:false,	
					items : [adjNumField,causeField,adjUserField]
				}, {
					border:false,	
					columnWidth : .25,
					xtype : 'fieldset',
					items : [locField,dateField,timeField]
				}, {
					border:false,	
					columnWidth : .25,
					xtype : 'fieldset',
					items : [groupField,remarkField]
				},{
					border:false,	
					columnWidth : .2,
					xtype : 'fieldset',	
					listWidth:10,				
					items : [finshCK,auditCK]
				}]
			}]
		}]
	}]
});

//���
var INAdjMGrid = new Ext.grid.EditorGridPanel({
	title:'��ϸ��¼',
	store:INAdjMGridDs,
	cm:INAdjMGridCm,
	id:'INAdjMGrid',
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	tbar:[AddDetailBT,'-',DelDetailBT,'-',GridColSetBT],
	bbar:[rpAmount,'-',spAmount]
});
INAdjMGrid.store.on('load',function(){
	setStatAmount();
	})
//=========================�������Ƶ�=============================

function checkBeforeSave()
{	
	//����Ƿ�����ϸ��¼
	if (mainRowId=='')
	{
		if (INAdjMGrid.getStore().getCount()==0)
		{
			Msg.info('error','û���κ���ϸ��¼!');
			return false;
		}
	}
	//�����ϸ���
	
			// 1.�ж�ҩƷ�Ƿ�Ϊ��
			var rowCount = INAdjMGrid.getStore().getCount();
			// ��Ч����
			var count = 0;
			for (var i = 0; i < rowCount; i++) {
				var item = INAdjMGridDs.getAt(i).get("inci");
				if (item != "") {
					count++;
				}
			}
			if (rowCount <= 0 || count <= 0) {
				Msg.info("warning", "������������ϸ!");
				return false;
			}
			// 2.������䱳��
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			// 3.�ж��ظ�����ҩƷ
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var item_i = INAdjMGridDs.getAt(i).get("inclb");;
					var item_j = INAdjMGridDs.getAt(j).get("inclb");;
					var itemdesc=INAdjMGridDs.getAt(i).get("desc");;
					var icnt=i+1;
					var jcnt=j+1;
					if (item_i != "" && item_j != ""
							&& item_i == item_j ) {
						changeBgColor(i, "yellow");
						changeBgColor(j, "yellow");
						Msg.info("warning", itemdesc+",��"+icnt+","+jcnt+"��"+"ҩƷ�ظ�������������!");
						return false;
					}
				}
			}
	
	
	return true;
}

		// �任����ɫ
		function changeBgColor(row, color) {
			INAdjMGrid.getView().getRow(row).style.backgroundColor = color;
		}



function save()
{
	if (!checkBeforeSave()) return;
	
	var adjUser = UserId;
	var adjStkType = App_StkTypeCode
	var adjInst = "";
	var adjLoc = Ext.getCmp('locField').getValue();
	if((adjLoc=="")||(adjLoc==null)){
		Msg.info("error","��ѡ��Ӧ����!");
		return false;
	}
	
	var adjScg = Ext.getCmp('groupField').getValue();
	if(((adjScg=="")||(adjScg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error","��ѡ������!");
		return false;
	}
	
	var adjComp = (Ext.getCmp('finshCK').getValue()==true?'Y':'N');
	var adjState = (Ext.getCmp('auditCK').getValue()==true?'Y':'N');
	
	var adjReason = Ext.getCmp('causeField').getValue();
	if((adjReason=="")||(adjReason==null)){
		Msg.info("error","��ѡ�����ԭ��!");
		return false;
	}
	var remark = Ext.getCmp('remarkField').getValue();	

	var ss=remark.replace(/\r\n/g,xMemoDelim())
    remark=ss;
    
	var tmpData = adjLoc+"^"+adjUser+"^"+adjReason+"^"+adjScg+"^"+adjStkType+"^"+adjInst+"^"+adjComp+"^"+adjState+"^"+remark;
	var mainData=tmpData;
	
	//��֯��ϸ����
	var detailData="";
	var count = INAdjMGridDs.getCount();
	for(var index=0;index<count;index++){		
		var rec = INAdjMGridDs.getAt(index);
		if (rec.data.newRecord || rec.dirty){		
			var adjitm = rec.get('adjitm'); //�ӱ���ϸrowid
			var inclb = rec.get('inclb');//����rowid
			var InclbAvaQty=rec.get("InclbAvaQty");
		
			if((inclb!="")&&(inclb!=null)){
				var qty = rec.get('qty');
				
				if ((qty=='')||(parseFloat(qty)==0)){
					Msg.info('error','��ǰ�е�����������Ϊ��!');
					var qtyColIndex=Ext.getCmp('INAdjMGrid').getColumnModel().getIndexById('adjQty');
					Ext.getCmp('INAdjMGrid').getSelectionModel().select(index,qtyColIndex);	
					return;				
				} 
				if(qty<0 && (Math.abs(qty)>InclbAvaQty)){
					         Msg.info("error","��������Ϊ����ʱ���ܳ������ο��!");
					         return;}
				var uom = rec.get('uom');
				
				var buomId=rec.get("buom")
	            var buomQty=qty
	            var fac=rec.get("confac")
				
				if(gParam[0]!=1)  ////�������������Ƿ�����С���ж� 2020-02-20 yangsj 1 ����¼��С��
	    		{
	        		if(buomId!=uom)
	                {
	                    buomQty=Number(fac).mul(qty);
	                }
	                if((buomQty.toString()).indexOf(".")>=0)
	                {
	                    Msg.info("warning", rec.get("desc")+" ������������ɻ�����λ֮�����С�������ܵ�������˶Կ��������ã�������������Ϊ������λ�Ƿ�����С��!");
	                    return;
	                }
	    		}
		
				var sp = rec.get('sp');
				var spAmt = rec.get('spAmt');
				var rp = rec.get('rp');
				var rpAmt = rec.get('rpAmt');
				var insti = rec.get('insti');			
				var tmp = adjitm+"^"+inclb+"^"+qty+"^"+uom+"^"+rp+"^"+sp+"^"+rpAmt+"^"+spAmt+"^"+insti;
				if(detailData!=""){
					detailData = detailData+xRowDelim()+tmp;
				}else{
					detailData = tmp;
				}
			}							
		}
	}

	if((!IsFormChanged(formPanel))&&(detailData=="")){
		Msg.info("error", "û��������Ҫ����!");
		return false;
	};
	
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url: INAdjMGridUrl+'?actiontype=saveAdj',
		params:{adj:mainRowId,mainData:tmpData,detailData:detailData},
		failure: function(result,request) {
			Msg.info("error","������������!");
		},
		success: function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","����ɹ�!");
				mainRowId=jsonData.info   //rowid - ����rowid	
				select(mainRowId)		
			}else{
				if(jsonData.info==-1){
					Msg.info("error","�������!");
				}else{
					Msg.info("error","����ʧ��!"+jsonData.info);
				}
			}
		},
		scope: this
	});
	loadMask.hide();

  }


//������������ݵ��ؼ�
function select(rowid)
{
	mainRowId=rowid;
	Ext.Ajax.request({
		url:INAdjMGridUrl+"?actiontype=select&adj="+rowid,
		failure:function(){alert('failure');},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.results>0) {
				data=jsonData.rows  ;
				if (!data) return;
			 	var loc=data[0]['INAD_CTLOC_DR']   ;
			 	var locdesc=data[0]['locDesc']
			 	var scg=data[0]['INAD_SCG_DR'] ;
			 	var reason=data[0]['INAD_ReasonAdj_DR'];
			 
			 	var no=data[0]['INAD_No']  ;
			 	var adjDate=data[0]['INAD_Date'];
			 	var adjTime=data[0]['INAD_Time'] ;
			 	var completeFlag=data[0]['INAD_Completed'] ; 
			 	var auditFlag=data[0]['INAD_ChkFlag'] ;
			 	var remark=data[0]['INAD_Remarks']  ;
			 	remark=handleMemo(remark,xMemoDelim());
		 		
			 	var userName=data[0]['userName'] ;
			 	var auditUserName=data[0]['INAD_ChkUser_DR'] ;
			 	var chkDate=data[0]['INAD_ChkDate'];
			 	var chkTime=data[0]['INAD_ChkTime'];
			 	addComboData(Ext.getCmp("locField").getStore(),loc,locdesc);
			 	Ext.getCmp('locField').setValue(loc);
		               
			 	Ext.getCmp('adjNumField').setValue(no);
			 
			 	Ext.getCmp('dateField').setValue(adjDate);
			 
			 	Ext.getCmp('adjUserField').setValue(userName);
			 
			 	Ext.getCmp('timeField').setValue(adjTime);
			 	Ext.getCmp('finshCK').setValue(((completeFlag=='Y')?'true':'false'));
			 	
			 	//alert(completeFlag);
			 	INAdjMGridDs.load({
				 	params:{start:0,limit:9999,adj:rowid},
					callback : function(r,options, success){
						if(success==false){
							Ext.MessageBox.alert("��ѯ����",this.reader.jsonData.Error); 
		     			}
					}
				 });
			 	
			 	if (completeFlag=='Y') 
			 	{saveINAdjM.disable();}
			 	else
			 	{saveINAdjM.enable();}
			 	
			 	Ext.getCmp('auditCK').setValue(((auditFlag=='Y')?'true':'false'));
			 	Ext.getCmp('causeField').setValue(reason);
			 	Ext.getCmp('groupField').setValue(scg);
			 	Ext.getCmp('remarkField').setValue(remark);  //��ע
			 	
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
	
	//Ext.getCmp('INAdjMGrid').getStore().load(rowid);
	
}

function addComboData(store, id, desc) {
	var defaultData = {
		RowId : id,
		Description : desc
	};
	var r = new store.recordType(defaultData);
	store.add(r);
}
	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "0", "","",returnInfo);
	}
}

//����һ��(��ϸ)
function addDetailRow()
{
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true))
	{
		Msg.info('warning','��ǰ�����������,��ֹ������ϸ��¼!');
		return;
	}	
	var rowCount=INAdjMGrid.getStore().getCount();
	if(rowCount>0){
		var rowData=INAdjMGridDs.data.items[rowCount-1]
		var data=rowData.get("inci");
		if(data==""||data.length<=0)
		{Msg.info("warning","�Ѵ����½���");
		 return;}
		}
	addNewRow();
	
}

//ɾ��һ��(��ϸ)
function DeleteDetail()
{	
	var complete=Ext.getCmp('finshCK').getValue();
	if (complete==true)
	{
		Msg.info('warning','�Ѿ����,��ֹɾ����ϸ��¼!');	return;
	}
	
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	if(cell==null){
		Msg.info("warning","��ѡ������!");
		return false;
	}else{
		var record = INAdjMGridDs.getAt(cell[0]);
		var rowid = record.get("adjitm");
		if(rowid!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : 'dhcst.inadjaction.csp?actiontype=deleteItem&rowid='+rowid,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error", "������������!");
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
								 	INAdjMGridDs.load({
									 	params:{start:0,limit:9999,adj:mainRowId},
										callback : function(r,options, success){
											if(success==false){
												Ext.MessageBox.alert("��ѯ����",this.reader.jsonData.Error); 
							     			}
										}
									 });
								}else{
									var jsonInfo=jsonData.info;
									if (jsonInfo==-5){
										Msg.info("warning", "�Ѵ���̨�˼�¼,�޷�ɾ��!");
									}else{
										Msg.info("error", "ɾ��ʧ��!");
									}
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
			INAdjMGridDs.remove(record);
			INAdjMGrid.getView().refresh();
		}
	
		if (INAdjMGridDs.getCount()==0){
 
			setEditEnable();
		}
	setStatAmount();		
	}

}
//���ҿ����������Ϣ���ڹر�ʱ�ص�����
function returnInfo(record) {
	if (record == null || record == "") {
		return;
	}
	inciDr = record.get("InciDr");
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var rowData = INAdjMGrid.getStore().getAt(cell[0]);
	var INCLBWARNFLAG= record.get("InclbWarnFlag");
	if (INCLBWARNFLAG=="2"){
		Msg.info("warning", "��ҩƷ������״̬Ϊ������!");
		return;
	}
	rowData.set("inci",inciDr);
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	rowData.set("batNo",record.get("BatExp"));
	rowData.set("manf",record.get("Manf"));

	rowData.set("sp",record.get("Sp"));
	rowData.set("rp",record.get("Rp"));
	rowData.set("inclb",record.get("Inclb"));
	rowData.set("spec",record.get("Spec"));
	//rowData.set("Inclbqty",record.get("InclbQty"));
	rowData.set("InclbAvaQty",record.get("AvaQty"));    //��Ϊȡ���ÿ��
	//INAdjMGrid.startEditing(cell[0],12);
	var uom=record.get("BUomId")
	var uomDesc=record.get("BUomDesc")
	//var uom=record.get("PurUomId")
	//var uomDesc=record.get("PurUomDesc")
	addComboData(ItmUomStore,uom,uomDesc);
	rowData.set("uom",record.get("BUomId"));
	rowData.set("uomDesc",record.get("BUomDesc"));
	//rowData.set("uom",record.get("PurUomId"));
	//rowData.set("uomDesc",record.get("PurUomDesc"));
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
	//var BatStkQty=record.get("InclbQty");
	var BatStkQty=record.get("AvaQty");
	NewStkQty=BatStkQty*confac;
	rowData.set("InclbAvaQty",NewStkQty)
	rowData.set("rp",buomRp)
	rowData.set("sp",buomSp)
	var cell = INAdjMGrid.getSelectionModel().getSelectedCell();
	var colIndex=GetColIndex(INAdjMGrid,"qty");
	INAdjMGrid.startEditing(cell[0], colIndex);	
}
//====================================================
//====================================================

//��������(��ϸ)
function addNewRow() {
	//�ж������Ƿ��Ѿ�
	if(Ext.getCmp('groupField').getRawValue()==''){	 
		Ext.getCmp('groupField').setValue(null);
	}
	var scg = Ext.getCmp('groupField').getValue(); 
	if(((scg=="")||(scg==null))&&(gParamCommon[9]=="N")){
		Msg.info("error", "��ѡ������!");
		return ;
	}
	
	// �ж��Ƿ��Ѿ��������
	var rowCount = INAdjMGrid.getStore().getCount();
	if (rowCount > 0) {
		var rowData = INAdjMGridDs.data.items[rowCount- 1];
		var data = rowData.get("inci");
		if (data == null || data.length <= 0) {
			INAdjMGrid.startEditing(INAdjMGridDs.getCount() - 1, 5);
			return;
		}
	}
	
	var record = Ext.data.Record.create([
		{
			name : 'adjitm',
			type : 'string'
		}, {
			name : 'inclb',
			type : 'string'
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
			name : 'spec',
			type : 'string'
		}, {
			name : 'manf',
			type : 'string'
		}, {
			name : 'batNo',
			type : 'string'
		}, {
			name : 'expDate',
			type : 'string'
		},{
			name : 'InclbAvaQty',
			type : 'int'
		}, {
			name : 'qty',
			type : 'int'
		}, {
			name : 'uom',
			type : 'int'
		}, {
			name : 'qtyBUOM',
			type : 'int'
		}, {
			name : 'rp',
			type : 'double'
		}, {
			name : 'rpAmt',
			type : 'double'
		}, {
			name : 'sp',
			type : 'double'
		}, {
			name : 'spAmt',
			type : 'double'
		}, {
			name : 'insti',
			type : 'stirng'
		},{
			name:'buom',
			type:'string'
		},
		{
			name:'confac',
			type:'string'	
		}
	]);
	
	var NewRecord = new record({
		adjitm:'',
		inclb:'',
		inci:'',
		code:'',
		desc:'',
		spec:'',
		manf:'',
		batNo:'',
		expDate:'',
		InclbAvaQty:'',
		qty:'',
		uom:'',
		qtyBUOM:'',
		rp:'',
		rpAmt:'',
		sp:'',
		spAmt:'',
		insti:'',
		buom:'',
		confac:''
	});
					
	INAdjMGridDs.add(NewRecord);
	INAdjMGrid.startEditing(INAdjMGridDs.getCount() - 1, 5);
	
	setEditDisable();
}

 //ɾ����������
function deleteAdj()
{
	if (mainRowId=='')
	{
		Msg.info('warning','û���κο�������!');return false;	
	}
	var complete=Ext.getCmp('finshCK').getValue();
	if (complete==true)
	{
		Msg.info('warning','�õ��Ѿ����,��ֹɾ��!');	return false;
	}

	var rowid=mainRowId;
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ÿ�������?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url : 'dhcst.inadjaction.csp?actiontype=delete&adj='+rowid,
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
							var jsonInfo=jsonData.info;
							if (jsonInfo==-5){
								Msg.info("warning", "��ϸ�Ѵ���̨�˼�¼,�޷�ɾ��!");
							}else{
								Msg.info("error", "ɾ��ʧ��!"+jsonData.info);
							}							
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
function clearPage()
{
	//Ext.getCmp('locField').setValue("");
	//Ext.getCmp('locField').setRawValue("");
	mainRowId="";
	
	Ext.getCmp('adjNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('adjUserField').setValue("");	
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('causeField').setValue("");
	Ext.getCmp('causeField').setRawValue("");
	Ext.getCmp('finshCK').setValue("");
	Ext.getCmp('remarkField').setValue("");
	Ext.getCmp('auditCK').setValue("");
	Ext.getCmp("rpAmount").setText("���۽��:");
	Ext.getCmp("spAmount").setText("�ۼ۽��:");
	INAdjMGridDs.removeAll();
	saveINAdjM.enable();
	setEditEnable();
}


//���õ������
function setComplete()
{
	//alert(mainRowId);
	if (mainRowId=='') {Msg.info('warning','û���κε���,���Ȳ�ѯ!');return; }
	if (Ext.getCmp('finshCK').getValue()==true){
		Msg.info('warning','��ǰ���������!');return;
	}
	Ext.Ajax.request({
		url:INAdjMGridUrl+'?actiontype=setComplete'+"&adj="+mainRowId,
		failure:function(){
			Msg.info('error','��������!');return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.getCmp('finshCK').setValue(true);
				saveINAdjM.disable();
				Msg.info('success','���óɹ���');
				
			}else{
				Msg.info("error", "����ʧ��!"+jsonData.info);
				return false;
			}			
		}
	
	});
}

//ȡ�����
function cancelComplete()
{
	if (mainRowId=='') {Msg.info('warning','û���κε���,���Ȳ�ѯ!');return; }
	if (Ext.getCmp('finshCK').getValue()==false){Msg.info('error','�õ�����δ���!');return;}	
	Ext.Ajax.request({
		url:INAdjMGridUrl+'?actiontype='+'cancelComplete'+'&adj='+mainRowId,
		failure:function(){Msg.info('error','��������!');return;
		},
		success:function(result,request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Ext.getCmp('finshCK').setValue(false);
				Msg.info('success','���óɹ���');
				saveINAdjM.enable();
			}else{
				if (jsonData.info==-3){
					Msg.info("warning", "�õ��������,�޷�ȡ�����!");
				}else{
					Msg.info("error", "����ʧ��!"+jsonData.info);
				}
				return;
			}		
		}
	});

}
function setGridEditable(grid,b)
{
	var colId=grid.getColumnModel().getIndexById('desc');	        
	grid.getColumnModel().setEditable(colId,b);
	var colId=grid.getColumnModel().getIndexById('adjQty');	        
	grid.getColumnModel().setEditable(colId,b);
	
}
function setStatAmount()
{
	var rpAmt=0;
	var spAmt=0;
	var count = INAdjMGrid.getStore().getCount(); 
	for (var i=0; i<count; i++)
	{
		var rowData = INAdjMGridDs.getAt(i);
		rpAmt=rpAmt+rowData.get("rpAmt")*1;
		spAmt=spAmt+rowData.get("spAmt")*1;
		rpAmt=rpAmt;
		spAmt=spAmt;
	}
	rpText="���ۺϼ�:  "+FormatGridRpAmount(rpAmt)+"  Ԫ";
	spText="�ۼۺϼ�:  "+FormatGridSpAmount(spAmt)+"  Ԫ";
	Ext.getCmp("rpAmount").setText(rpText);
	Ext.getCmp("spAmount").setText(spText);	
}
///����JS������������ӣ�������λС������
function FmtAmt(price,pos)
{
	var price=Math.round(price*Math.pow(10,pos))/Math.pow(10,pos);
	return price;
}
/*
function xMemoDelim() 
{
	var realkey  = String.fromCharCode(3);  
	return realkey;
}

function handleMemo(memo,token) 
{
	var xx='';
 	var ss=memo.split(token);
 	for (var i=0;i<ss.length;i++)
 	{
 		xx=xx+ss[i]+'\n\r';
 	}
	return xx	
}
*/
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}	
	
	var panel = new Ext.Panel({
		title:'�������Ƶ�',
		activeTab:0,
		layout:'fit',
		region:'north',
		height:DHCSTFormStyle.FrmHeight(3),
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,INAdjMGrid],
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
	var count1= INAdjMGrid.getStore().getCount();
	//�����������Ƿ����޸�
	//�޸�Ϊ�������޸����ӱ�������ʱ������ʾ
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	};
	if (changed) return changed;
	//����ϸ�����Ƿ����޸�
	var count= INAdjMGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INAdjMGrid.getStore().getAt(index);	
				//���������ݷ����仯ʱִ����������
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}	

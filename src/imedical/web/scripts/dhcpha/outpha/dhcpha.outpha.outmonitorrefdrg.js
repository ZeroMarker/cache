// ����:ҩʦ��˲�ѯ
// ��д����:2014-08-13
// ����:bianshuai
var UserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var patno=""
function setCommFlag(){ 
    patno=gPatNo;
    Ext.getCmp('patientTxt').setValue(patno);
    if ((patno!="")||(EpisodeID!="")) {QueryPatInfo();}
}

//��ʼ����
var startDateField=new Ext.form.DateField ({
	id:'startDateField',
	width:125, 
    allowBlank:false,
	fieldLabel:'��ʼ����',
	value:new Date,
	anchor:'90%'
})

//��������
var endDateField=new Ext.form.DateField ({
	id:'endDateField',
	width:125, 
    allowBlank:false,
	fieldLabel:'��������',
	value:new Date(),
	anchor:'90%'
})

//�ǼǺ�
var patientField=new Ext.form.TextField({
	width:125, 
	id:"patientTxt", 
	fieldLabel:"�ǼǺ�" ,
	listeners: {
		specialkey: function (textfield, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				SetWholePatID(); //�ǼǺŲ�0
				QueryPatInfo(); //��ѯ
			}
		}
	}
})
		//���˿��Ų�ѯ����
	var cardNoField = new Ext.form.TextField({
		width: 125,
		id: "cardNoTxt",
		fieldLabel: "����",
		listeners: {
			specialkey: function(textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var tmpcardno=Ext.getCmp('cardNoTxt').getValue()
					var lscard=tmpcardno;
					var cardlen=tmpcardno.length
					var CardTypeValue = CardTypeComBo.getValue();
					if (CardTypeValue != "") {
						var CardTypeArr = CardTypeValue.split("^");
						m_CardNoLength= CardTypeArr[17]
					}
					else {
						return
					}
					if (m_CardNoLength>cardlen){
						var lszero="";
						for (i=1;i<=m_CardNoLength-cardlen;i++)
						{
							lszero=lszero+"0"  
						}
						var lscard=lszero+lscard;
					}
					var pminofrmcardno=tkMakeServerCall("web.DHCOutPhCommon","GetPmiNoFrCardNo",lscard)	
					if (pminofrmcardno==-1){
						alert("�����ڸÿ��ţ�");
						Ext.getCmp('patientTxt').setValue("");
						Ext.getCmp('cardNoTxt').setValue("");
						return;
					}
					Ext.getCmp('patientTxt').setValue(pminofrmcardno);
					Ext.getCmp('cardNoTxt').setValue("");
					QueryPatInfo();
				}
			}
		}
	})

 //����
 var ReadCardButton = new Ext.Button({	   
     width : 70,
     id:"ReadCardBtn",
     text: '����',
     icon:"../scripts/dhcpha/img/menuopera.gif",
     width : 70,
	 height : 20,
     listeners:{
        "click":function(){    
           BtnReadCardHandler();               
        }    
    }         
 })
   
//��ѯ
var findBT = new Ext.Toolbar.Button({
	text:'��ѯ',
    icon:'../scripts/dhcpha/img/find.gif',
	width : 70,
	height : 20,
	handler:function(){
		QueryPatInfo();
	}
});

//���
var clearBT = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    icon:'../scripts/dhcpha/img/new.gif',
	width : 70,
	height : 20,
	handler:function(){
		Ext.getCmp('startDateField').setValue(new Date());
		Ext.getCmp('endDateField').setValue(new Date());
		Ext.getCmp('patientTxt').setValue(""); //��յǼǺ�
		OutMonitorRefDrgGridDs.removeAll(); //��ս�������
		//QueryPatInfo();
	}
});
 CardTypeStore = eval("(" + CardTypeArray + ')');

 ///������Store
 var CardTypeDs= new Ext.data.ArrayStore({
	autoDestroy : true,
	fields : ['desc', 'value'],
	data : CardTypeStore
 })

 var CardTypeComBo = new Ext.form.ComboBox({
	fieldLabel:'������',
	width : 120,
	typeAhead : true,
	height : 100,
	//renderTo:'LocListDiv',
	triggerAction : 'all',
	store : CardTypeDs,
	mode : 'local',
	valueField : 'value',
	displayField : 'desc',
	listeners : {
		//change: LocChangeHandler
	}
	});
	//����Ĭ�Ͽ�����
	function setDefaultCardType() {
		if (CardTypeDs.getTotalCount() > 0) {
			var cardcount = CardTypeDs.getTotalCount();
			for (i = 0; i < cardcount; i++) {
				var tmpcardvalue = CardTypeDs.getAt(i).data.value;
				var tmpcardarr = tmpcardvalue.split("^");
				var defaultflag = tmpcardarr[8];
				if (defaultflag == "Y") {
					CardTypeComBo.setValue(CardTypeDs.getAt(i).data.value);
				}
			}
			if (CardTypeComBo.getValue() == "") {
				CardTypeComBo.setValue(CardTypeDs.getAt(0).data.value);
			}
		}
	}

setDefaultCardType();  //����Ĭ�Ͽ�����

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	autoScroll:true,
	labelAlign : 'right',
	//autoHeight : true,
	region:'north',
	frame : true,
	//bodyStyle : 'padding:5px;',
    bbar:[findBT,'-',ReadCardButton,'-',clearBT,'-'],
    layout:'fit',
	items : [{	
		xtype : 'fieldset',
		title : '����ѡ��',
		//width:1330,
		autoHeight : true,
		items : [{
			layout : 'column',
			items : [{
				columnWidth : .2,
				layout : 'form',
				items : [startDateField]
			}, {
				columnWidth : .2,
				layout : 'form',
				items : [endDateField]
			}, {
				columnWidth : .15,
				layout : 'form',
				items : [patientField]
			}, {
				columnWidth : .15,
				layout : 'form',
				items : [cardNoField]
			}, {
				columnWidth : .15,
				layout : 'form',
				items : [CardTypeComBo]
			}]
		}]
	}]
});

//====================================================
//��������Դ
var OutMonitorRefDrgGridUrl = 'dhcpha.outpha.outmonitorrefdrgaction.csp';
var OutMonitorRefDrgGridProxy= new Ext.data.HttpProxy({url:OutMonitorRefDrgGridUrl+'?Action=OutMonitorRefDrg',method:'GET'});
var OutMonitorRefDrgGridDs = new Ext.data.Store({
	proxy:OutMonitorRefDrgGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'MonitorID'},
		{name:'PatNo'},
		{name:'PatName'},
		{name:'PhcDesc'},
		{name:'Qty'},
		{name:'Unit'},
		{name:'DoseQty'},
		{name:'Instruce'},
		{name:'Durtion'},
		{name:'RefReason'},
		{name:'RefPharmacy'},
		{name:'RefTime'},
		{name:'AppType'},
		{name:'Oeori'}
	]),
    remoteSort:false
    
});
//ģ��
var OutMonitorRefDrgGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"rowid",
        dataIndex:'MonitorID',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"����",
        dataIndex:'Appeal',
        width:100,
        align:'center',
        hidden:(IfDoctor=="Y")?false:true,
        renderer : function(val,params,record,rowIndex) {
	        html="";
	        if(record.get("PatNo")!=""){
	        	html='<a href="#" onclick="Meth_Appeal('+record.get("MonitorID")+')"><span style="margin:0px 5px 0px 5px">����</span></a>';
	        	html=html+'|'+'<a href="#"  onclick="Meth_Agree('+record.get("MonitorID")+')"><span style="margin:0px 5px 0px 5px">����</span></a>';
	        }
		    return html;
	    },
        sortable:true
    },{
        header:"�ǼǺ�",
        dataIndex:'PatNo',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'PatName',
        width:110,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'PhcDesc',
        width:220,
        align:'left',
        sortable:true,
        renderer : function(val,params,record,rowIndex) {
			return '<div style="white-space:normal">' + val + "</div>";  
	    }
    },{
        header:"����",
        dataIndex:'Qty',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'Unit',
        width:100,
        align:'center',
        sortable:true,
        hidden:true
    },{
        header:"����",
        dataIndex:'DoseQty',
        width:90,
        align:'right',
        sortable:true
    },{
        header:"�÷�",
        dataIndex:'Instruce',
        width:90,
        align:'center',
        sortable:true
    },{
        header:"�Ƴ�",
        dataIndex:'Durtion',
        width:90,
        align:'center',
        sortable:true
    },{
        header:"�ܾ�ԭ��",
        dataIndex:'RefReason',
        width:300,
        align:'left',
        sortable:true,
        renderer : function(val,params,record,rowIndex) {
			return '<div style="white-space:normal">' + val + "</div>";  //�Զ�����
	    }
    },{
        header:"�ܾ���",
        dataIndex:'RefPharmacy',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"�ܾ�ʱ��",
        dataIndex:'RefTime',
        width:150,
        align:'center',
        sortable:true
    },{
        header:"�ܾ���ʶ",
        dataIndex:'AppType',
        width:150,
        align:'center',
        sortable:true
    },{
        header:"Oeori",
        dataIndex:'Oeori',
        width:150,
        align:'center',
        sortable:true,
        hidden:true
    }
]);

//��ʼ��Ĭ��������
OutMonitorRefDrgGridCm.defaultSortable = true;

var OutMonitorRefDrgPagingToolbar = new Ext.PagingToolbar({
	store:OutMonitorRefDrgGridDs,
	pageSize:35,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
});

//���
OutMonitorRefDrgGrid = new Ext.grid.EditorGridPanel({
	title:'ҩʦ��˾ܾ��б�',
	store:OutMonitorRefDrgGridDs,
	cm:OutMonitorRefDrgGridCm,
	trackMouseOver:true,
	region:'center',
	height:300,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:OutMonitorRefDrgPagingToolbar
});

//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	setCommFlag();
	var panel = new Ext.Panel({
		title:'ҩʦ��˲�ѯ',
		activeTab:0,
		region:'north',
		height:150,
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var detailPanel = new Ext.Panel({
		activeTab:0,
		region:'center',
		height:150,
		layout:'fit',
		items:[OutMonitorRefDrgGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:(EpisodeID!="")?[detailPanel]:[panel,detailPanel],
		renderTo:'mainPanel'
	});
});

///��ѯ
function QueryPatInfo()
{
	var StartDate = Ext.getCmp('startDateField').getValue();
	if((StartDate!="")&&(StartDate!=null)){
		StartDate = StartDate.format(websys_DateFormat);
	}else{
		Msg.info("error","��ѡ����ʼ����!");
		return false;
	}
	var EndDate = Ext.getCmp('endDateField').getValue();
	if((EndDate!="")&&(EndDate!=null)){
		EndDate = EndDate.format(websys_DateFormat);
	}else{
		Msg.info("error","��ѡ���ֹ����!");
		return false;
	}
		
	var PatNo = Ext.getCmp('patientTxt').getValue();	// �ǼǺ�
	var LocID=session['LOGON.CTLOCID']; 				// ��¼����ID
	var DoctorID=session['LOGON.USERID']; 				// ��¼�û�ID
	var Limit=OutMonitorRefDrgPagingToolbar.pageSize;
	OutMonitorRefDrgGridDs.setBaseParam("StartDate",StartDate);
	OutMonitorRefDrgGridDs.setBaseParam("EndDate",EndDate);
	OutMonitorRefDrgGridDs.setBaseParam("LocID",LocID);
	OutMonitorRefDrgGridDs.setBaseParam("PatNo",PatNo);
	OutMonitorRefDrgGridDs.setBaseParam("Doctor",DoctorID);
	OutMonitorRefDrgGridDs.setBaseParam("EpisodeID",EpisodeID);
	OutMonitorRefDrgGridDs.removeAll();
	OutMonitorRefDrgGridDs.load({
		params:{start:0, limit:Limit},
		callback:function(r,options, success){
			if(success==false){
 				Ext.MessageBox.alert("��ѯ����",OutMonitorRefDrgGridDs.reader.jsonData.Error);  
 			}
		}
	});
}

///����
function Meth_Appeal(MonitorID)
{
	var selrow=OutMonitorRefDrgGrid.getSelectionModel().getSelected();
	var oeori=selrow.get("Oeori") ;
	var apptype=selrow.get("AppType") ;
	if (apptype=="��ҩ�ܾ�")
	{
			if (CheckOrdDsp(oeori)=="Y")
			{
				alert("�ѷ�ҩ,�����ٽ��в�����");
				return;
			}
	}

	CreateAppealWin(MonitorID);
}

/// ����ҽ����˴���
function CreateAppealWin(MonitorID)
{
	///ҽ����Ϣ
	var LocStkLabel=new Ext.form.Label({
		id:'LocStkLabel',
		html:'<div style="color:#F00; font-weight=bold;"></div>',
		width:30
	})
	
	//ȷ��
	var sureBT = new Ext.Toolbar.Button({
		text:'ȷ��',
	    tooltip:'ȷ��',
	    icon:'../scripts/dhcpha/img/filesave.png',
		handler:function(){
			var AppealInfo=Ext.getCmp('textarea').getValue();
			if(AppealInfo!="")
			{
				var sstr=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","saveAppealReason",MonitorID,AppealInfo,session['LOGON.USERID']);
				if(sstr=="0"){
					window.update(AutoLoadHtmlPage(MonitorID)); //����ɹ�����½���������Ϣ����
					Ext.getCmp('textarea').setValue("");
					OutMonitorRefDrgGridDs.load({
						params:{start:0, limit:999},
						callback:function(r,options, success){
							if(success==false){
			 					//Msg.info("error", "��ѯ������鿴��־!");
			 				}
						}
					});
					if (window){window.close();}
					if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
					return;
				}				
			}else{
				alert("�������������ɣ�");
			}
		}
	});
	
	//����
	var receptBT = new Ext.Toolbar.Button({
		text:'����',
	    tooltip:'����',
	    icon:'../scripts/dhcpha/img/ok.png',
		handler:function(){
			Meth_Agree(MonitorID);
			//���³ɹ���رս���
			if (window){window.close();}
		}
	});
	
	//�ر�
	var closeBT = new Ext.Toolbar.Button({
		text:'�ر�',
	    tooltip:'�ر�',
	    icon:'../scripts/dhcpha/img/cancel.png',
		handler:function(){
			if (window){window.close();}
			
		}
	});
	
	///text
	var textarea=new Ext.form.TextArea({
		name:'textarea',
		width:800,
		id:'textarea',
		emptyText:'������������Ϣ...',
		preventScrollbars:false
	})
	
	var mk = new Ext.LoadMask(document.body, {  
		msg: '���ڲ������ݣ����Ժ�',  
		removeMask: true //��ɺ��Ƴ�  
	});
	
	var window=new Ext.Window({
		title:'ҽ�������ʷ',
		width:814,
		id:'win',
		height:480,
		resizable:false,
		closeAction: 'close' ,
		tbar:[LocStkLabel],
		bbar:[textarea,closeBT],
		buttons:[sureBT,receptBT,closeBT],
		autoScroll: true //�Զ���ʾ������
	})

	///��ʼ����������
	InitRefOrdInfo(MonitorID)
	window.html=AutoLoadHtmlPage(MonitorID);
	window.show();
}

//��ȡ��˾ܾ�ҽ��
function InitRefOrdInfo(MonitorID)
{
	var sstr=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","getOutMonitorOrdInfo",MonitorID);
	if(sstr==""){
		alert("��ȡҽ����Ϣʧ�ܣ�");
		return;
	}
	var oeoriArr=sstr.split("^");
	var drghtmlstr="";
	for(var i=0;i<oeoriArr.length;i++){
		drghtmlstr=drghtmlstr+"<span style='font-weight:bold; color:red; font-size:20;margin:5px'>"+oeoriArr[i]+"<span>";
	}
	Ext.getCmp('LocStkLabel').setText('<div style="font-weight:bold; color:red; font-size:20;">'+drghtmlstr+'</div>',false);
}

//��˾ܾ�ԭ��
function AutoLoadHtmlPage(MonitorID)
{
	var sstr=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","getOutMonitorReason",MonitorID);
	if(sstr==""){
		alert("��ȡҽ����Ϣʧ�ܣ�");
		return;
	}
	
	var reasonArr=sstr.split("^");
	var htmlstr="";
	htmlstr="<div style='background-color:#FFFFFF;width:100%;border: 1px solid #CCC;height:380;margin:5px;'>";
	for(var i=0;i<reasonArr.length;i++){
		htmlstr=htmlstr+"<div style='font-size:16pt;font-family:���Ŀ���;border: 1px solid #CCC;background: none repeat scroll 0% 0% #F5F5F5;padding: 15px 20px 15px 20px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;'>"+reasonArr[i]+"</div>";
	}
	htmlstr=htmlstr+"</div>";
	return htmlstr;
}

///����
function Meth_Agree(MonitorID)
{
	var selrow=OutMonitorRefDrgGrid.getSelectionModel().getSelected();
	var oeori=selrow.get("Oeori") ;
	var apptype=selrow.get("AppType") ;
	if (apptype=="��ҩ�ܾ�")
	{
			if (CheckOrdDsp(oeori)=="Y")
			{
				alert("�ѷ�ҩ,�����ٽ��в�����");
				return;
			}
	}
	
	var ret=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","AgreeRefDrg",MonitorID);
	if(ret==0){
		alert("���³ɹ���");
		if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
		//���³ɹ���ˢ��
		OutMonitorRefDrgGridDs.load({
			params:{start:0, limit:999},
			callback:function(r,options, success){
				if(success==false){
 					//Msg.info("error", "��ѯ������鿴��־!");
 				}
			}
		});
	}else{
		alert("����ʧ�ܣ�");
	}
}

///��0���˵ǼǺ�
function SetWholePatID()
{
	var PatNo = Ext.getCmp('patientTxt').getValue();  //�ǼǺ�
	if (PatNo==""){return RegNo;}

	var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");

	var plen=PatNo.length;
	if (plen>patLen){
		Ext.Msg.show({title:'����',msg:'����ǼǺŴ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}

	for (i=1;i<=patLen-plen;i++)
	{
		PatNo="0"+PatNo;  
	}
	Ext.getCmp('patientTxt').setValue(PatNo);
}

//ȡ������
function GetCardTypeRowId() 
{
	var CardTypeRowId = "";
	var CardTypeValue = CardTypeComBo.getValue();

	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	return CardTypeRowId;
}

//����
function BtnReadCardHandler()
{
	var CardTypeRowId = GetCardTypeRowId();
	var myoptval = CardTypeComBo.getValue();
	var myrtn;
	myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	
	if (myrtn==-200){ //����Ч
		Ext.Msg.show({title:'����',msg:'����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}

	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//����Ч
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
		var NewCardTypeRowId = myary[8];
		Ext.getCmp('patientTxt').setValue(PatientNo);
		FindWardList();
	break;
	case "-200":
		//����Ч
		Ext.Msg.show({title:'����',msg:'����Ч!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		break;
	case "-201":
		//�ֽ�
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
		var NewCardTypeRowId = myary[8];
		Ext.getCmp('patientTxt').setValue(PatientNo);
		FindWardList();
	break;
	default:

	}
}

function CheckOrdDsp(oeori)
{
	var dspflag = tkMakeServerCall("web.DHCSTOutMonitorRefDrg", "CheckOrdDsp",oeori);
	return dspflag;
}

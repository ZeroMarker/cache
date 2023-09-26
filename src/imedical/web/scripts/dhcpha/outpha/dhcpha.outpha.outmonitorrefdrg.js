// 名称:药师审核查询
// 编写日期:2014-08-13
// 作者:bianshuai
var UserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var patno=""
function setCommFlag(){ 
    patno=gPatNo;
    Ext.getCmp('patientTxt').setValue(patno);
    if ((patno!="")||(EpisodeID!="")) {QueryPatInfo();}
}

//开始日期
var startDateField=new Ext.form.DateField ({
	id:'startDateField',
	width:125, 
    allowBlank:false,
	fieldLabel:'开始日期',
	value:new Date,
	anchor:'90%'
})

//结束日期
var endDateField=new Ext.form.DateField ({
	id:'endDateField',
	width:125, 
    allowBlank:false,
	fieldLabel:'结束日期',
	value:new Date(),
	anchor:'90%'
})

//登记号
var patientField=new Ext.form.TextField({
	width:125, 
	id:"patientTxt", 
	fieldLabel:"登记号" ,
	listeners: {
		specialkey: function (textfield, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				SetWholePatID(); //登记号补0
				QueryPatInfo(); //查询
			}
		}
	}
})
		//病人卡号查询工具
	var cardNoField = new Ext.form.TextField({
		width: 125,
		id: "cardNoTxt",
		fieldLabel: "卡号",
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
						alert("不存在该卡号！");
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

 //读卡
 var ReadCardButton = new Ext.Button({	   
     width : 70,
     id:"ReadCardBtn",
     text: '读卡',
     icon:"../scripts/dhcpha/img/menuopera.gif",
     width : 70,
	 height : 20,
     listeners:{
        "click":function(){    
           BtnReadCardHandler();               
        }    
    }         
 })
   
//查询
var findBT = new Ext.Toolbar.Button({
	text:'查询',
    icon:'../scripts/dhcpha/img/find.gif',
	width : 70,
	height : 20,
	handler:function(){
		QueryPatInfo();
	}
});

//清空
var clearBT = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    icon:'../scripts/dhcpha/img/new.gif',
	width : 70,
	height : 20,
	handler:function(){
		Ext.getCmp('startDateField').setValue(new Date());
		Ext.getCmp('endDateField').setValue(new Date());
		Ext.getCmp('patientTxt').setValue(""); //清空登记号
		OutMonitorRefDrgGridDs.removeAll(); //清空界面数据
		//QueryPatInfo();
	}
});
 CardTypeStore = eval("(" + CardTypeArray + ')');

 ///卡类型Store
 var CardTypeDs= new Ext.data.ArrayStore({
	autoDestroy : true,
	fields : ['desc', 'value'],
	data : CardTypeStore
 })

 var CardTypeComBo = new Ext.form.ComboBox({
	fieldLabel:'卡类型',
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
	//设置默认卡类型
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

setDefaultCardType();  //设置默认卡类型

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
		title : '条件选项',
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
//配置数据源
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
//模型
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
        header:"申诉",
        dataIndex:'Appeal',
        width:100,
        align:'center',
        hidden:(IfDoctor=="Y")?false:true,
        renderer : function(val,params,record,rowIndex) {
	        html="";
	        if(record.get("PatNo")!=""){
	        	html='<a href="#" onclick="Meth_Appeal('+record.get("MonitorID")+')"><span style="margin:0px 5px 0px 5px">申诉</span></a>';
	        	html=html+'|'+'<a href="#"  onclick="Meth_Agree('+record.get("MonitorID")+')"><span style="margin:0px 5px 0px 5px">接受</span></a>';
	        }
		    return html;
	    },
        sortable:true
    },{
        header:"登记号",
        dataIndex:'PatNo',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"姓名",
        dataIndex:'PatName',
        width:110,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'PhcDesc',
        width:220,
        align:'left',
        sortable:true,
        renderer : function(val,params,record,rowIndex) {
			return '<div style="white-space:normal">' + val + "</div>";  
	    }
    },{
        header:"数量",
        dataIndex:'Qty',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"单位",
        dataIndex:'Unit',
        width:100,
        align:'center',
        sortable:true,
        hidden:true
    },{
        header:"剂量",
        dataIndex:'DoseQty',
        width:90,
        align:'right',
        sortable:true
    },{
        header:"用法",
        dataIndex:'Instruce',
        width:90,
        align:'center',
        sortable:true
    },{
        header:"疗程",
        dataIndex:'Durtion',
        width:90,
        align:'center',
        sortable:true
    },{
        header:"拒绝原因",
        dataIndex:'RefReason',
        width:300,
        align:'left',
        sortable:true,
        renderer : function(val,params,record,rowIndex) {
			return '<div style="white-space:normal">' + val + "</div>";  //自动换行
	    }
    },{
        header:"拒绝人",
        dataIndex:'RefPharmacy',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"拒绝时间",
        dataIndex:'RefTime',
        width:150,
        align:'center',
        sortable:true
    },{
        header:"拒绝标识",
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

//初始化默认排序功能
OutMonitorRefDrgGridCm.defaultSortable = true;

var OutMonitorRefDrgPagingToolbar = new Ext.PagingToolbar({
	store:OutMonitorRefDrgGridDs,
	pageSize:35,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});

//表格
OutMonitorRefDrgGrid = new Ext.grid.EditorGridPanel({
	title:'药师审核拒绝列表',
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

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	setCommFlag();
	var panel = new Ext.Panel({
		title:'药师审核查询',
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

///查询
function QueryPatInfo()
{
	var StartDate = Ext.getCmp('startDateField').getValue();
	if((StartDate!="")&&(StartDate!=null)){
		StartDate = StartDate.format(websys_DateFormat);
	}else{
		Msg.info("error","请选择起始日期!");
		return false;
	}
	var EndDate = Ext.getCmp('endDateField').getValue();
	if((EndDate!="")&&(EndDate!=null)){
		EndDate = EndDate.format(websys_DateFormat);
	}else{
		Msg.info("error","请选择截止日期!");
		return false;
	}
		
	var PatNo = Ext.getCmp('patientTxt').getValue();	// 登记号
	var LocID=session['LOGON.CTLOCID']; 				// 登录科室ID
	var DoctorID=session['LOGON.USERID']; 				// 登录用户ID
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
 				Ext.MessageBox.alert("查询错误",OutMonitorRefDrgGridDs.reader.jsonData.Error);  
 			}
		}
	});
}

///申诉
function Meth_Appeal(MonitorID)
{
	var selrow=OutMonitorRefDrgGrid.getSelectionModel().getSelected();
	var oeori=selrow.get("Oeori") ;
	var apptype=selrow.get("AppType") ;
	if (apptype=="发药拒绝")
	{
			if (CheckOrdDsp(oeori)=="Y")
			{
				alert("已发药,不能再进行操作！");
				return;
			}
	}

	CreateAppealWin(MonitorID);
}

/// 创建医嘱审核窗体
function CreateAppealWin(MonitorID)
{
	///医嘱信息
	var LocStkLabel=new Ext.form.Label({
		id:'LocStkLabel',
		html:'<div style="color:#F00; font-weight=bold;"></div>',
		width:30
	})
	
	//确认
	var sureBT = new Ext.Toolbar.Button({
		text:'确认',
	    tooltip:'确认',
	    icon:'../scripts/dhcpha/img/filesave.png',
		handler:function(){
			var AppealInfo=Ext.getCmp('textarea').getValue();
			if(AppealInfo!="")
			{
				var sstr=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","saveAppealReason",MonitorID,AppealInfo,session['LOGON.USERID']);
				if(sstr=="0"){
					window.update(AutoLoadHtmlPage(MonitorID)); //保存成功后更新界面申诉信息内容
					Ext.getCmp('textarea').setValue("");
					OutMonitorRefDrgGridDs.load({
						params:{start:0, limit:999},
						callback:function(r,options, success){
							if(success==false){
			 					//Msg.info("error", "查询错误，请查看日志!");
			 				}
						}
					});
					if (window){window.close();}
					if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
					return;
				}				
			}else{
				alert("请输入申诉理由！");
			}
		}
	});
	
	//接受
	var receptBT = new Ext.Toolbar.Button({
		text:'接受',
	    tooltip:'接受',
	    icon:'../scripts/dhcpha/img/ok.png',
		handler:function(){
			Meth_Agree(MonitorID);
			//更新成功后关闭界面
			if (window){window.close();}
		}
	});
	
	//关闭
	var closeBT = new Ext.Toolbar.Button({
		text:'关闭',
	    tooltip:'关闭',
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
		emptyText:'请输入申诉信息...',
		preventScrollbars:false
	})
	
	var mk = new Ext.LoadMask(document.body, {  
		msg: '正在查找数据，请稍候！',  
		removeMask: true //完成后移除  
	});
	
	var window=new Ext.Window({
		title:'医嘱审核历史',
		width:814,
		id:'win',
		height:480,
		resizable:false,
		closeAction: 'close' ,
		tbar:[LocStkLabel],
		bbar:[textarea,closeBT],
		buttons:[sureBT,receptBT,closeBT],
		autoScroll: true //自动显示滚动条
	})

	///初始化界面数据
	InitRefOrdInfo(MonitorID)
	window.html=AutoLoadHtmlPage(MonitorID);
	window.show();
}

//获取审核拒绝医嘱
function InitRefOrdInfo(MonitorID)
{
	var sstr=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","getOutMonitorOrdInfo",MonitorID);
	if(sstr==""){
		alert("读取医嘱信息失败！");
		return;
	}
	var oeoriArr=sstr.split("^");
	var drghtmlstr="";
	for(var i=0;i<oeoriArr.length;i++){
		drghtmlstr=drghtmlstr+"<span style='font-weight:bold; color:red; font-size:20;margin:5px'>"+oeoriArr[i]+"<span>";
	}
	Ext.getCmp('LocStkLabel').setText('<div style="font-weight:bold; color:red; font-size:20;">'+drghtmlstr+'</div>',false);
}

//审核拒绝原因
function AutoLoadHtmlPage(MonitorID)
{
	var sstr=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","getOutMonitorReason",MonitorID);
	if(sstr==""){
		alert("读取医嘱信息失败！");
		return;
	}
	
	var reasonArr=sstr.split("^");
	var htmlstr="";
	htmlstr="<div style='background-color:#FFFFFF;width:100%;border: 1px solid #CCC;height:380;margin:5px;'>";
	for(var i=0;i<reasonArr.length;i++){
		htmlstr=htmlstr+"<div style='font-size:16pt;font-family:华文楷体;border: 1px solid #CCC;background: none repeat scroll 0% 0% #F5F5F5;padding: 15px 20px 15px 20px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;'>"+reasonArr[i]+"</div>";
	}
	htmlstr=htmlstr+"</div>";
	return htmlstr;
}

///接受
function Meth_Agree(MonitorID)
{
	var selrow=OutMonitorRefDrgGrid.getSelectionModel().getSelected();
	var oeori=selrow.get("Oeori") ;
	var apptype=selrow.get("AppType") ;
	if (apptype=="发药拒绝")
	{
			if (CheckOrdDsp(oeori)=="Y")
			{
				alert("已发药,不能再进行操作！");
				return;
			}
	}
	
	var ret=tkMakeServerCall("web.DHCSTOutMonitorRefDrg","AgreeRefDrg",MonitorID);
	if(ret==0){
		alert("更新成功！");
		if(top && top.HideExecMsgWin) {top.HideExecMsgWin();}
		//更新成功后刷新
		OutMonitorRefDrgGridDs.load({
			params:{start:0, limit:999},
			callback:function(r,options, success){
				if(success==false){
 					//Msg.info("error", "查询错误，请查看日志!");
 				}
			}
		});
	}else{
		alert("更新失败！");
	}
}

///补0病人登记号
function SetWholePatID()
{
	var PatNo = Ext.getCmp('patientTxt').getValue();  //登记号
	if (PatNo==""){return RegNo;}

	var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");

	var plen=PatNo.length;
	if (plen>patLen){
		Ext.Msg.show({title:'错误',msg:'输入登记号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}

	for (i=1;i<=patLen-plen;i++)
	{
		PatNo="0"+PatNo;  
	}
	Ext.getCmp('patientTxt').setValue(PatNo);
}

//取卡类型
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

//读卡
function BtnReadCardHandler()
{
	var CardTypeRowId = GetCardTypeRowId();
	var myoptval = CardTypeComBo.getValue();
	var myrtn;
	myrtn = DHCACC_GetAccInfo(CardTypeRowId, myoptval);
	
	if (myrtn==-200){ //卡无效
		Ext.Msg.show({title:'错误',msg:'卡无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}

	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//卡有效
		PatientID = myary[4];
		var PatientNo = myary[5];
		var CardNo = myary[1]
		var NewCardTypeRowId = myary[8];
		Ext.getCmp('patientTxt').setValue(PatientNo);
		FindWardList();
	break;
	case "-200":
		//卡无效
		Ext.Msg.show({title:'错误',msg:'卡无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		break;
	case "-201":
		//现金
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

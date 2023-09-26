///Creator:BianShuai
///CreateDate:2013-10-01
///护士配液申请

var unitsUrl = 'DHCST.PIVAOUT.SAVEURL.csp';
function showWin(value)
{
	var index=value.indexOf("^");
        if  (index>=0) {
           var tmparr=value.split("^");
	   var dodis=tmparr[0];

        }else{
           var dodis=value;
        }
	OpenShowStatusWin("",dodis);
}

function showPatInfoWin(value)
{
	var index=value.indexOf("^");
        if  (index>=0) {
           var tmparr=value.split("^");
	   var dodis=tmparr[0];

        }else{
           var dodis=value;
        }

	OpenShowPatInfoWin(dodis);
}

Ext.onReady(function(){
	///主模块
	Ext.QuickTips.init();// 浮动信息提示
	Ext.Ajax.timeout = 900000;
	
	//设置默认科室
	function setDefaultLoc()
	{
		
		if (phlocInfo.getTotalCount() > 0){
			PhaLocSelecter.setValue(phlocInfo.getAt(0).data.rowId);
		}
	}

	//设置默认卡类型
	function setDefaultCardType()
	{
		if (CardTypeDs.getTotalCount() > 0){
			var cardcount=CardTypeDs.getTotalCount();
			for (i=0;i<cardcount;i++)
			{
				var tmpcardvalue=CardTypeDs.getAt(i).data.value;
				var tmpcardarr=tmpcardvalue.split("^");
				var defaultflag=tmpcardarr[8];
				if (defaultflag=="Y")
				{
					CardTypeComBo.setValue(CardTypeDs.getAt(i).data.value);
				}
			}
			if (CardTypeComBo.getValue()=="")
			{
				CardTypeComBo.setValue(CardTypeDs.getAt(0).data.value);
			}
			
		}
	}

	///药房科室控件
	var phlocInfo = new Ext.data.Store({
		autoLoad: true,
		reader: new Ext.data.JsonReader({
			totalProperty:"results",root:'rows',id: 'rowId'},['phlocdesc','rowId'])
	});

	phlocInfo.on('beforeload',function(ds,o){
		var grpdr=session['LOGON.GROUPID'] ;		
		ds.proxy = new Ext.data.HttpProxy({
			url:unitsUrl+'?action=GetStockPhlocDs&GrpDr='+grpdr, method:'GET'});
		}
	);

	//取卡类型
	function GetCardTypeRowId() 
	{
		var CardTypeRowId = "";
		var CardTypeValue = CardTypeComBo.getValue();
		if (CardTypeValue != "")
		{
			var CardTypeArr = CardTypeValue.split("^");
			CardTypeRowId = CardTypeArr[0];
		}
		return CardTypeRowId;
	}

	///药房科室
	var PhaLocSelecter = new Ext.form.ComboBox({
		id:'PhaLocSelecter',
		fieldLabel:'药房科室',
		store: phlocInfo,
		valueField:'rowId',
		displayField:'phlocdesc',
		width : 180,
		listWidth:250,
		emptyText:'选择药房科室...',
		allowBlank: false,
		name:'PhaLocSelecter',
		mode: 'local'
	});
	

	//设置默认科室
	phlocInfo.on("load",function(store,record,opts){ setDefaultLoc();});

	//留观科室
	var EmAreaInfo = new Ext.data.Store({
		autoLoad: false,
		proxy:"",
		reader: new Ext.data.JsonReader({
			totalProperty:"results",root:'rows',id: 'rowId'},['locdesc','rowId'])
	});

	EmAreaInfo.on('beforeload',function(ds,o){
		ds.proxy = new Ext.data.HttpProxy({
			url:unitsUrl+'?action=GetGetLgAreaDs', method:'GET'});
		}
	);

	///留观
	var EmAreaSelecter = new Ext.form.ComboBox({
		id:'EmAreaSelecter',
		fieldLabel:'留观室',
		store: EmAreaInfo,
		valueField:'rowId',
		displayField:'locdesc',
		width : 180,
		emptyText:'选择留观科室...',
		//allowBlank: false,
		name:'EmAreaSelecter',
		mode: 'local'
	});
	
	EmAreaInfo.load();
	//开始日期
	var StartDate=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '开始日期',
		name: 'startdt',
		id: 'startdt',
		invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		value:new Date
	})	

	///截止日期
	var EndDate=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '截止日期',
		name: 'enddt',
		id: 'enddt',
		invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		value:new Date
	})

	//查询
	var RefreshButton = new Ext.Button({
		width : 70,
		id:"RefreshBtn",
		text: '查询',
		icon:"../scripts/dhcpha/img/find.gif",
		listeners:{
			"click":function(){  
			 	var RegNo=GetWholePatID(Ext.getCmp('patientTxt').getValue());
				FindPatOrdDetailInfo(RegNo);
			}   
		}
	})

	//读卡
	var  ReadCardButton = new Ext.Button({
		width : 70,
		id:"ReadCardBtn",
		text: '读卡',
		icon:"../scripts/dhcpha/img/menuopera.gif",
		listeners:{
			"click":function(){   
				BtnReadCardHandler();
			}   
		}
	})

	///申请
	var OkButton = new Ext.Button({
		width : 65,
		id:"OkButton",
		text: '申请',
		icon:"../scripts/dhcpha/img/accept.png",
		listeners:{
			"click":function(){   
				SaveRequest();
			}   
		}
	})
	///修改打包状态
	var ChangeButton = new Ext.Button({
		width : 65,
		id:"ChangeButton",
		text: '修改打包状态',
		icon:"../scripts/dhcpha/img/accept.png",
		listeners:{
			"click":function(){   
				ChangeRequestPack();
			}   
		}
	})
	//已申请
	var OnlyReqChkbox=new Ext.form.Checkbox({
		boxLabel : '已申请',
		id : 'OnlyReqChk',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
				//document.getElementById("TDSelectOrdItm").disabled="true";
			}
		}
	})
	//已配伍
	var OnlyPivaAuditbox=new Ext.form.Checkbox({
		boxLabel : '配伍审核',
		id : 'OnlyPivaAudit',
		inputValue : '1',
		checked : false,
		listeners:{
			'check': function(){
				//document.getElementById("TDSelectOrdItm").disabled="true";
			}
		}
	})
	///卡类型
	CardTypeStore =eval("(" + CardTypeArray + ')');

	///卡类型Store
	var CardTypeDs= new Ext.data.ArrayStore({
		autoDestroy : true,
		fields : ['desc', 'value'],
		data : CardTypeStore
	})

	///卡类型
	var CardTypeComBo = new Ext.form.ComboBox({
		fieldLabel:'卡类型',
		width : 120,
		typeAhead : true,
		height : 100,
		triggerAction :'all',
		store: CardTypeDs,
		mode: 'local',
		valueField : 'value',
		displayField : 'desc',
		listeners : {
			//change: LocChangeHandler
		}
	});

	setDefaultCardType();

	function selectbox(re,params,record,rowIndex){
		//var disableflag="";
		//var reqflag=record.data.requser;
		//if(reqflag!=""){
		//disableflag="disabled=true";}
		return '<input type="checkbox" id="TSelectz'+rowIndex+'" name="TSelectz'+rowIndex+'"  value="'+re+'"  >';
	}

	function packflagbox(re,params,record,rowIndex){

		var ch=record.get("pack")
		if (ch=="Y")
		{
			var chk="true"
			return '<input type="checkbox" id="Tpackflagz'+rowIndex+'" name="Tpackflagz'+rowIndex+'" checked="'+chk+'" value="'+re+'"  >';
		}else{
			var chk="false"
			return '<input type="checkbox" id="Tpackflagz'+rowIndex+'" name="Tpackflagz'+rowIndex+'" value="'+re+'"  >';
		}

		
	} 

	function showUrl(value, cellmeta, record, rowIndex, colIndex, store) {
		return "<a href='javascript:showWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
	}

	function showPatInfoUrl(value, cellmeta, record, rowIndex, colIndex, store) {
		return "<a href='javascript:showPatInfoWin(\""+record.get("dsprowid")+"\")'/>"+value+"</a>";
	}

	///登记号
	var PatRegNoField=new Ext.form.TextField({
		width:120, 
		id:"patientTxt", 
		fieldLabel:"登记号" ,
		listeners: {
			specialkey: function (textfield, e) {
				if (e.getKey() == Ext.EventObject.ENTER){
					var RegNo=GetWholePatID(Ext.getCmp('patientTxt').getValue());
					FindPatOrdDetailInfo(RegNo);
				}
			}
		}
	})

	///配置数据源
	var PatReqDetailGridDr = new Ext.data.Store({
		proxy:"",
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		}, [
			'select',
			'packflag',
			'patno',
			'patname',
			'adm',
			'orddate',
			'prescno',
			'prescnoT',
			'incidesc',
			'qty',
			'uomdesc',
			'dosage',
			'freq',
			'spec',
			'instruc',
			'dura',
			'form',
			'doctor',
			'remark',
			'selectflag',
			'requser',
			'reqdate',
			'dsprowid',
			'psname',
			'pack'
		]),
		// turn on remote sorting
		remoteSort: true
	});

	///Grid列模型
	var PatReqDetailGridCm = new Ext.grid.ColumnModel([
		{
			header:'<input type="checkbox" id="TDSelectOrdItm" >',
			width:40,
			menuDisabled:true,
			dataIndex:'select',
			renderer:selectbox
		},{
			header:'打包',
			width:40,
			menuDisabled:true,
			dataIndex:'packflag',
			renderer:packflagbox
		},{
			header:'登记号',
			dataIndex:'patno',
			width: 80,
			menuDisabled :'false',
			renderer:showPatInfoUrl
		},{
			header:'姓名',
			dataIndex:'patname',
			width: 60,
			menuDisabled :'false'
		},{
			header:'adm',
			dataIndex:'adm',
			width: 60,
			menuDisabled :'false',
			hidden:true
		},{
			header:'用药日期',
			dataIndex:'orddate',
			width:140
		},{
			header:'处方号',
			dataIndex:'prescno',
			width:100,
			renderer:showUrl
		},{
			header:'处方号hide',
			dataIndex:'prescnoT',
			width:85,
			renderer:showUrl,
			hidden:true
		},{
			header:'药品名称',
			dataIndex:'incidesc',
			width:200
		},{
			header:'数量',
			dataIndex:'qty',
			width:40
		},{
			header:'单位',
			dataIndex:'uomdesc',
			width:60
		},{
			header:'剂量',
			dataIndex:'dosage',
			width:80
		},{
			header:'频次',
			dataIndex:'freq',
			width:40
		},{
			header:'规格',
			dataIndex:'spec',
			width:80
		},{
			header:'用法',
			dataIndex:'instruc',
			width:80
		},{
			header:'用药疗程',
			dataIndex:'dura',
			width:60
		},{
			header:'剂型',
			dataIndex:'form',
			width:100
		},{
			header:'医生',
			dataIndex:'doctor',
			width:60
		},{
			header:'医嘱备注',
			dataIndex:'remark',
			width:60
		},{
			header:'selectflag',
			dataIndex:'selectflag',
			width:60
			//hidden:true
		},{
			header:'申请人',
			dataIndex:'requser',
			width:60
		},{
			header:'申请日期',
			dataIndex:'reqdate',
			width:135
		},{
			header:'dsprowid',
			dataIndex:'dsprowid',
			width:60
		},{
			header:'当前状态',
			dataIndex:'psname',
			width:80
		},{
			header:'打包标志',
			dataIndex:'pack',
			width:60
		}
				
	]);

	///查询条件Panel
	var ConditionForm = new Ext.form.FormPanel({
		autoScroll:true,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding:5px;', 
		labelWidth:'60px',
	    bbar:[RefreshButton,'-',OkButton,'-',ReadCardButton,'-',ChangeButton],
		items : [{
			layout : "column",
			items : [{
				labelAlign : 'right',
				columnWidth :.2,
				layout : "form",
				items : [StartDate]
				},{ 
				labelAlign : 'right',
				columnWidth : .25,
				layout : "form",
				items : [PhaLocSelecter]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [PatRegNoField]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [OnlyPivaAuditbox]
			}]
		},{
			layout : "column",
			items : [{
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [EndDate]
				},{ 
				labelAlign : 'right',
				columnWidth : .25,
				layout : "form",
				items : [EmAreaSelecter]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [CardTypeComBo]
			},{ 
				labelAlign : 'right',
				columnWidth : .2,
				layout : "form",
				items : [OnlyReqChkbox]
			}]
		}]
	})

	var PatReqDetailGridCmPagingToolbar = new Ext.PagingToolbar({	
		store:PatReqDetailGridDr,
		pageSize:200,
		//显示右下角信息
		displayInfo:true,
		displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
		prevText:"上一页",
		nextText:"下一页",
		refreshText:"刷新",
		lastText:"最后页",
		firstText:"第一页",
		beforePageText:"当前页",
		afterPageText:"共{0}页",
		emptyMsg: "没有数据"
	});

	///Grid
	var PatReqDetailGrid = new Ext.grid.EditorGridPanel({
		stripeRows: true,
		region:'center',
		margins:'0 0 3 3', 
		autoScroll:true,
		id:'orddetailtbl',
		enableHdMenu : false,
		ds:PatReqDetailGridDr,
		cm:PatReqDetailGridCm,
		enableColumnMove : false,
		clicksToEdit: 1,
		trackMouseOver:'true',
		bbar:PatReqDetailGridCmPagingToolbar,
		listeners : {
			'rowdblclick':function(){}
		}  
	});

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

	///补0病人登记号
	function GetWholePatID(RegNo)
	{    
		if (RegNo=="") {
			return RegNo;
		}
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen=RegNo.length;
		if (plen>patLen){
			Ext.Msg.show({title:'错误',msg:'输入登记号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return;
		}
		for (i=1;i<=patLen-plen;i++)
		{
			RegNo="0"+RegNo;  
		}
		Ext.getCmp('patientTxt').setValue(RegNo);
		return RegNo;
	}

	///保存申请数据
	function SaveRequest()
	{
		var view = PatReqDetailGrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
	if(CheckDataBeforeSave()==true){
		for (i=0;i<=rows;i++)
		{
			var cellselected=document.getElementById("TSelectz"+i).checked
			if (cellselected){
				var record = PatReqDetailGrid.getStore().getAt(i);
				var dsprowid =record.data.dsprowid ;
				if (document.getElementById("Tpackflagz"+i).checked){
					packflag="Y" ;
				}else{
					packflag="N" ;
					}
				SaveData(i,dsprowid,packflag);
			}
		}
	 }
	}
	
		///修改打包状态,针对选中行
	function ChangeRequestPack()
	{
		var view = PatReqDetailGrid.getView();
		var rows=view.getRows().length-1 ;
		if (rows==-1) return;
		for (i=0;i<=rows;i++)
		{
			var cellselected=document.getElementById("TSelectz"+i).checked
			if (cellselected){
				var record = PatReqDetailGrid.getStore().getAt(i);
				var dsprowid =record.data.dsprowid ;
				var requeststat=record.data.psname;
				if (requeststat=="待申请"){
					Ext.Msg.alert("提示","第"+(i+1)+"行非已申请状态!无法修改打包状态!");
					return	
				}
				if (document.getElementById("Tpackflagz"+i).checked){
					packflag="Y" ;
				}else{
					packflag="N" ;
					}
				UpdatePackData(i,dsprowid,packflag);
			}
		}
	}
	///数据库交互
	function UpdatePackData(i,dsprowid,packflag)
	{
		var requesr=session['LOGON.USERID'] ;
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "UpdateRequestPack",dsprowid,packflag,requesr);
		if (ret>0){
			var patreqrecord = PatReqDetailGrid.getStore().getAt(i);
			patreqrecord.set("pack",packflag);
			PatReqDetailGrid.getView().getRow(i).style.backgroundColor='#fe7287';
			
		}
		else if(ret==-1){
			Ext.Msg.alert("提示","第"+(i+1)+"行尚未申请，不能修改打包状态!");
			}
		else if(ret==-3){
			Ext.Msg.alert("提示","第"+(i+1)+"行不是已申请状态，不能修改打包状态!");
			}
		else if(ret==-5){
			///申请人员未修改打包状态的情况下,不执行下列操作 bianshuai 2015-12-07
			Ext.Msg.alert("提示","<font style='color:red;font-weight:bold;font-size:20px;'>第"+(i+1)+"行\"打包状态\"未发生变化,请确认修改状态后重试!</font>");
			}
		else{
			Ext.Msg.alert("提示","更新失败!返回值:"+ret);
		}
	} 

function CheckDataBeforeSave()
 {
           var view = PatReqDetailGrid.getView();
  	       var rows=view.getRows().length ;
  	       var retvalue=""
  	       var dsprowidstr=""
	 	       for (i=0;i<=rows-1;i++)
      	       { 
      	        var cellselected=document.getElementById("TSelectz"+i).checked
      	   	   	if (cellselected){
	      	      var record = PatReqDetailGrid.getStore().getAt(i);
                  var prescno =record.data.prescno;
                  var dsprowid =record.data.dsprowid;
                  if (dsprowidstr==""){dsprowidstr=dsprowid;}
                  else {dsprowidstr=dsprowidstr+"^"+dsprowid;}
      	   	   	}
      	      }
      	  if (dsprowidstr!="")  {var retvalue=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "CheckBillStatus",dsprowidstr);}  
      	  if (retvalue!="") { 
      	    Ext.Msg.show({title:'错误',msg:'患者'+retvalue+'押金不足，不能申请!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      	     return false;
      	    }   

	return true;  	  
	 
 }  

	///数据库交互
	function SaveData(i,dsprowid,packflag)
	{
		var requesr=session['LOGON.USERID'] ;
		var ret=tkMakeServerCall("web.DHCSTPIVAOUTDISPREQ", "SaveRequest",dsprowid,packflag,requesr);
		if (ret>0){
			var patreqrecord = PatReqDetailGrid.getStore().getAt(i);
			patreqrecord.set("psname","已申请");
			patreqrecord.set("requser",session['LOGON.USERNAME']);
			patreqrecord.set("reqdate",getCurrentDateTime());
			patreqrecord.set("pack",packflag);
			PatReqDetailGrid.getView().getRow(i).style.backgroundColor='#fe7287';
		}
		else if(ret==-1){
			Ext.Msg.alert("提示","已申请过，不能重复申请");
			}
		else{
			Ext.Msg.alert("提示","保存失败!返回值:"+ret);
		}
	} 

	function FindPatOrdDetailInfo(RegNo)
	{
	document.getElementById("TDSelectOrdItm").checked=false
		PatReqDetailGridDr.removeAll(); ///清屏
	  	    var sdate=Ext.getCmp("startdt").getRawValue().toString();
	        var edate=Ext.getCmp("enddt").getRawValue().toString();
	        var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		   if (sdate=="") {Ext.Msg.show({title:'注意',msg:'开始日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (edate=="") {Ext.Msg.show({title:'注意',msg:'结束日期不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
		if (phlocdr=="") {Ext.Msg.show({title:'注意',msg:'科室不能为空 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});return;}
				     
		
		var input=GetListInput();
		waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据,请稍候..." }); 
		waitMask.show();

		PatReqDetailGridDr.proxy = new Ext.data.HttpProxy({url: unitsUrl + '?action=QueryWaitReqPatInfo&RegNo='+RegNo+"&Input="+input });		
		PatReqDetailGridDr.load({
			params:{start:0, limit:PatReqDetailGridCmPagingToolbar.pageSize},
			callback: function(r, options, success){
				waitMask.hide();
				if (success==false){
					Ext.Msg.show({title:'注意',msg:'查询失败 !',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});       
				}
			}
		});
	}

	//返回查询条件
	function GetListInput()
	{
		var sdate=Ext.getCmp("startdt").getRawValue().toString();
		var edate=Ext.getCmp("enddt").getRawValue().toString();
		var phlocdr=Ext.getCmp('PhaLocSelecter').getValue();
		var onlyreq=Ext.getCmp('OnlyReqChk').getValue();
		var emlocdr=Ext.getCmp('EmAreaSelecter').getValue();
		var pivaaudit=Ext.getCmp('OnlyPivaAudit').getValue();
		var listinputstr=sdate+"^"+edate+"^"+phlocdr+"^"+onlyreq+"^"+emlocdr+"^"+pivaaudit;
		return listinputstr;
	}

	///设置主面板单击事件
	PatReqDetailGrid.on('cellclick',OrddetailGridCellClick);
	PatReqDetailGrid.on('headerclick', function(grid, columnIndex, e){
		if (columnIndex==0){
			SelectAllRows();
		};
	});

	//全选/全销事件 bianshuai
	function SelectAllRows()
	{
		var selectflag=document.getElementById("TDSelectOrdItm").checked ;
		var view = PatReqDetailGrid.getView();
		var rows=view.getRows().length ;
		if (rows==0) return;
		for (var i=0;i<=rows-1;i++)
		{
			document.getElementById("TSelectz"+i).checked=selectflag;
		}
	}

	//设置列单击事件 bianshuai
	function OrddetailGridCellClick(grid, rowIndex, columnIndex, e)
	{
		var IndexID="";
		if(columnIndex==0)
		{
			IndexID="TSelectz";
		}
		else if(columnIndex==1)
		{
			IndexID="Tpackflagz";
		}
		else{return;}

		var record = PatReqDetailGrid.getStore().getAt(rowIndex);
		var tmpmdisp =record.data.selectflag ;
		var tmpprescnoT =record.data.prescnoT ;

		var view = PatReqDetailGrid.getView();
		var store = PatReqDetailGrid.getStore();
		var checkflag=document.getElementById(IndexID+rowIndex).checked;

		for (var i=0;i<=view.getRows().length-1;i++)    //i=1
		{
			var record = PatReqDetailGrid.getStore().getAt(i);
			var disp =record.data.selectflag ; 
			var prescnoT =record.data.prescnoT ; 
			if ((tmpmdisp==disp)||(tmpprescnoT==prescnoT)){
				document.getElementById(IndexID+i).checked=checkflag;
			}
			else
			{
				if (i>rowIndex) break;
			}
		}
	}

	function getCurrentDateTime()
	{
	
		var d=new Date();
		var pt="";
		var c=":";	
		pt+=d.getFullYear()+"-";	
		pt+=(d.getMonth()+1)+"-";
		pt+=d.getDate();
		pt+=" "
		pt+=d.getHours()+c;
		pt+=d.getMinutes()+c;
		pt+=d.getSeconds();
		return pt
	}
	var ConditionPanel = new Ext.Panel({
		title:'护士申请',
		activeTab:0,
		region:'north',
		height:150,
		layout:'fit',
		items:[ConditionForm]                                
	});

	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[ConditionPanel,PatReqDetailGrid]//,
		//renderTo:'mainPanel'
	});
});
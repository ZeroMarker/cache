//dhcpha.outpha.prescfy.js
//门诊发药界面
//Creator:liangjiaquan 
//CreatDate:2016-03-01

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var htmlstr='<div <span style="font-size:12pt;font-family:华文楷体;">'+'您没有选中处方！'+'</span> </div>';
	var PhLocDesc;
	var PhWinDesc;
	var FyUserName;
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	Ext.Ajax.timeout = 900000;
	
	var Url='dhcpha.outpha.prescfy.action.csp?';
	
	var title=GetPhTitle();
	if(title=="false"){Ext.Msg.show({title:'错误',msg:'加载出错，请重新登录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return;}
	
	//待发病人列表
	var PatListStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=PatListQuery",
		sotreId:'PatListStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'PatID',
		fields:['PatID','PatNo','PatName','Staus']
	});
	
	// 同步按钮
	var FindBT = new Ext.Toolbar.Button({
		id : "FindBT",
		text : '同步',
		tooltip : '点击同步待发药列表',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			QueryPatList();  //刷新列表
		}
	});
	
	// 叫号按钮
	var CallBT = new Ext.Toolbar.Button({
		id : "CallBT",
		text : '叫号',
		tooltip : '点击叫号',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			//QueryPatList();  //刷新列表
			CallVioce();     //叫号
		}
	});
	
	// 过号按钮
	var DelayBT = new Ext.Toolbar.Button({
		id : "DelayBT",
		text : '过号',
		tooltip : '点击过号',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			Delay()
			QueryPatList();  //刷新列表
		}
	});
	
	//自动刷新
    var AutoFindChk=new Ext.form.Checkbox({
		boxLabel : '自动刷新',
		id : 'AutoFindChk',
		inputValue : '1',
		checked : true,
		listeners:{
			'check': function(){
				if (Ext.getCmp("AutoFindChk").getValue())
				{
					StartAutoLoad();
				}
				else{
					StopAutoLoad();
				}
			}
		}
	})
	var patcm=new Ext.grid.ColumnModel([{
			header:'Rowid',
			dataIndex:'PatID',
			width:50,
			align:'left',
			hidden:true
		},{
			header:'姓名',
			dataIndex:'PatName',
			width:100,
			align:'left'
		},{
			header:'登记号',
			dataIndex:'PatNo',
			width:80,
			align:'left'
		},{
			header:'Staus',
			dataIndex:'Staus',
			width:100,
			align:'left',
			hidden:true
		}])
	
	var PatListGrid=new Ext.grid.GridPanel({
		id:'PatListGrid',
		//title:'<span style="color:red">'+'待发病人列表'+'</span>',
		store:PatListStore,
		//collapsible:true,
		tbar:[FindBT,'-',AutoFindChk],   //[CallBT,'-',DelayBT],
		cm:patcm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		viewConfig : {
			getRowClass: function(record, rowIndex,rowParams,store){
				var flag=record.get('Staus');
				if(flag=="1"){return 'classPurple'}   //待发
				else if(flag=="2") {return 'classOrange'}   //过号
				else {return 'classGrassGreen'}   //等待配药
			}
		}
	})
	
	patcm.setRenderer(1, getColor);   //病人姓名字体大小
	
	PatListGrid.addListener('rowclick',function(grid,rowindex,e){
		
		var rowData=PatListGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			//Msg.info("warning", "请选择需要发药的处方!");
			return;
		}
		var PatNo=rowData.get("PatNo");
		Ext.getCmp("PatNo").setValue(PatNo);
		Query();
		
	});
	
	
	
	// 开始日期
	var stdatef=new Ext.form.DateField ({
		width : 120,
		xtype: 'datefield',
		format:'j/m/Y' ,
		fieldLabel: '开始日期',
		name: 'startdt',
		id: 'startdt',
		invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		value:new Date().add(Date.DAY, -1)
	})
	
	
	//截止日期
	var enddatef=new Ext.form.DateField ({
		width : 120,
		format:'j/m/Y' ,
		fieldLabel: '截止日期',
		name: 'enddt',
		id: 'enddt',
		invalidText:'无效日期格式,正确格式是:日/月/年,如:15/02/2011',
		value:new Date().add(Date.DAY, 1)
	})
	
	//登记号
	var PatNo = new Ext.form.TextField({
		fieldLabel : '登记号',
		id : 'PatNo',
		name : 'PatNo',
		//anchor : '90%',
		width : 120,
		disabled : false,
		listeners:{
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var patno=field.getValue();
					//if (patno == null|| patno.length <= 0){return;}
					GetPapmiNo(patno);
					Query();
				}
			}
		}
	});
	
	
	// 快捷键
	PatNo.on('keydown', function(e) {
		alert(e.getKey())
		if (e.getKey() == Ext.EventObject.F2) {   //发药
			DispAll();
		}
		if (e.getKey() == Ext.EventObject.F6) {   //读卡
			ReadCard_click();
		}
	})
	
	function stopDefault(e)
	{
		if (e&&e.preventDefault)
		{
			e.preventDefault();
			e.stopPropagation()
		}
		else
		{
			e.keyCode=0;
			e.cancelBubble=true
			window.event.returnValue = false;
		}
	}

	
	//卡号
	var CardNo = new Ext.form.TextField({
		fieldLabel : '卡号',
		id : 'CardNo',
		name : 'CardNo',
		//anchor : '90%',
		width : 120,
		disabled : false,
		listeners:{
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var cardno=field.getValue();
					if (cardno == null|| cardno.length <= 0){return;}
					GetPatNoFrCard(cardno);
				}
			}
		}
	});
	
	CardTypeStore = eval("(" + CardTypeArray + ')');
    
	var CardTypeComBo = new Ext.form.ComboBox({
			fieldLabel:'卡类型',
			width : 90,
			typeAhead : true,
			height : 100,
			triggerAction : 'all',
			store : new Ext.data.ArrayStore({
				autoDestroy : true,
				fields : ['desc', 'value'],
				data : CardTypeStore
			
			}),
			mode : 'local',
			valueField : 'value',
			displayField : 'desc',
			listeners : {
				//change: LocChangeHandler
			}
		});
	
	//读卡
	var  ReadCardButton = new Ext.Button({
         width : 70,
         id:"ReadCardBtn",
         text: '读卡',
         icon:"../scripts/dhcpha/img/menuopera.gif",
         listeners:{
         	"click":function(){   
				ReadCard_click();
         	}   
         }
	})
	
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
	
	//已发药
	var DispFlag = new Ext.form.Checkbox({
		boxLabel : '已发药',
		id : 'DispFlag',
		inputValue : '1',
		checked : false,
		listeners:{
			check:function(obj,ischecked){
				if(ischecked==true)
				{
					
				}
			}
		}
	});
	
	
	//全部
	var AllFlag = new Ext.form.Checkbox({
		boxLabel : '全部窗口',
		id : 'AllFlag',
		inputValue : '1',
		checked : false,
		listeners:{
			check:function(obj,ischecked){
				if(ischecked==true)
				{
					
				}
			}
		}
	});
	
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '查询',
		tooltip : '点击查询',
		width : 70,
		height : 30,
		//iconCls : 'page_find',
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});
	
	// 发药按钮
	var DispBT = new Ext.Toolbar.Button({
		id : "DispBT",
		text : '发药',
		tooltip : '点击发药',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Disp();
		}
	});
	
	// 全发按钮
	var DispAllBT = new Ext.Toolbar.Button({
		id : "DispAllBT",
		text : '全发',
		tooltip : '点击全发',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			DispAll();
		}
	});
	
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_refresh',
		handler : function() {
			clearData();
		}
	});
	
	function clearData()
	{
		Ext.getCmp("PatNo").setValue("");
		Ext.getCmp("PatNo").setValue("");
		Ext.getCmp("startdt").setValue(new Date);
		Ext.getCmp("enddt").setValue(new Date);
		PrescGrid.store.removeAll();
		//htmlstr=OutPrescViewXY(45);
		htmlstr='<div style="width:785px;height:48px;background:#FFFFFF;">'+'<span style="margin:0px 0px 10px 15px;font-size:12pt;font-family:华文楷体;">'+'您没有选中处方！'+'</span>'+'</div>';
		Ext.getCmp('reportPanel').body.update(htmlstr);
	}
	
	// 打印按钮
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '打印',
		tooltip : '点击打印',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var rowData=PrescGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择需要打印的处方!");
				return;
			}
			var prescno=rowData.get("PrescNo");			
		}
	});
	
	// 拒发按钮
	var BadButton = new Ext.Button({
		id:"BadButton",
		text: '拒绝',
		icon:"../scripts/dhcpha/img/cancel.png",
		listeners:{
		"click":function(){
				RefuseDisp();
			}
		}

	})
	
	//处方列表
	var PrescStore=new Ext.data.JsonStore({
		auroDestroy:true,
		url:Url+"actiontype=PrescQuery",
		sotreId:'PrescStore',
		root:'rows',
		totalProperty:'results',
		idProperty:'PatID',
		fields:['phd','PatNo','PatName','PrescNo','InvNo','FYFlag','prt','FYStaus']
	});
	
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:PrescStore,
		pageSize:9999,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var cm=new Ext.grid.ColumnModel([{
			header:'Rowid',
			dataIndex:'phd',
			width:100,
			align:'left',
			hidden:true
		},{
			header:'登记号',
			dataIndex:'PatNo',
			width:80,
			align:'left'
			//sortable:true
		},{
			header:'姓名',
			dataIndex:'PatName',
			width:90,
			align:'left'
			//sortable:true
		},{
			header:'处方号',
			dataIndex:'PrescNo',
			width:100,
			align:'left'
			//sortable:true
		},{
			header:'发票号',
			dataIndex:'InvNo',
			width:80,
			align:'left',
			//sortable:true,
			hidden:true
		},{
			header:'发药标志',
			dataIndex:'FYFlag',
			width:70,
			align:'left',
			//sortable:true,
			hidden:true
		},{
			header:'prt',
			dataIndex:'prt',
			width:70,
			align:'left',
			//sortable:true,
			hidden:true
		},{
			header:'发药',
			dataIndex:'FYStaus',
			width:40,
			align:'left',
			sortable:true
		}])
	
	var PrescGrid=new Ext.grid.GridPanel({
		id:'PrescGrid',
		//height:495,
		store:PrescStore,
		cm:cm,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		autoScroll:true,
		viewConfig : {
			getRowClass: function(record, rowIndex,rowParams,store){
				var fyflag=record.get('FYFlag');
				if(fyflag=="1"){return 'classOrange'}
				else{return 'classGrassGreen'}
				return '<font color=blue></font><span style="color:red;">' + Ext.util.Format.usMoney(val) + '</span>';
			}
		},
		bbar:[GridPagingToolbar]
	})
	
	function getColor(val) {  
	if (val != "") {  
			return '<span style="font-size:22px;">' + val + '</span> ' 
		}  
	}  
	cm.setRenderer(2, getColor);   //病人姓名字体大小
	
	// 添加表格单击行事件
	PrescGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var rowData = PrescStore.data.items[rowIndex];
		var phd = rowData.get("phd");
		htmlstr=OutPrescView(phd);
		Ext.getCmp('reportPanel').body.update(htmlstr);
	});
	
			
	var reportPanel=new Ext.Panel({
		id:'reportPanel',
		autoScroll:true,
		title:'<span style="color:red">'+'处方预览'+'</span>',
		frame:true,
		defaults : {//设置默认属性   
            bodyStyle:'background-color:#FFFFFF;padding:15px'//设置面板体的背景色   
        } ,  
        items: [   
            {   
                html : htmlstr,   
                id : 'p1'  
            }  
        ]
        
		//html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
	})
	
	var nbsp='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+
		'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'

	var titleloc='<span style="font-size:12pt;">'+PhLocDesc+'</span>';
	var titlewin='<span style="font-size:12pt;font-family:华文楷体;">'+'发药窗口:'+PhWinDesc+'</span>';
	var titlefyuser='<span style="font-size:12pt;font-family:华文楷体;">'+'发药人:'+FyUserName+'</span>';
	var title=titleloc+nbsp+titlewin+nbsp+titlefyuser
	var TitlePanel= new Ext.form.FormPanel({
		labelwidth : 30,
		title: title
	})
	
	
	function Query()
	{
		PrescGrid.store.removeAll();
		htmlstr='<div style="width:785px;height:48px;background:#FFFFFF;">'+'<span style="margin:0px 0px 10px 15px;font-size:12pt;font-family:华文楷体;">'+'您没有选中处方！'+'</span>'+'</div>';
		Ext.getCmp('reportPanel').body.update(htmlstr);
		var StartDate=Ext.getCmp("startdt").getValue().format('j/m/Y').toString();
		var EndDate=Ext.getCmp("enddt").getValue().format('j/m/Y').toString();
		var PatNo=Ext.getCmp("PatNo").getValue();
		//PatNo=GetWholePatID(PatNo);
		var DispFlag=Ext.getCmp("DispFlag").getValue();
		if(DispFlag==true){DispFlag="1";}
		else{DispFlag="0";}
		var AllFlag=Ext.getCmp("AllFlag").getValue();
		if(AllFlag==true){AllFlag="1";}
		else{AllFlag="0";}
		var ListParam=GPhl+'^'+GPhw+'^'+StartDate+'^'+EndDate+'^'+PatNo+'^'+DispFlag+'^'+AllFlag;
		Ext.getCmp("PatNo").setValue("");
		Ext.getCmp("CardNo").setValue("");
		var Page=9999 //GridPagingToolbar.pageSize;;
		PrescStore.setBaseParam("ParamStr",ListParam);
		PrescStore.removeAll();
		PrescGrid.store.removeAll();
		PrescStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "查询错误，请查看日志!");
     			}else{
     				if(r.length>0){
	     				PrescGrid.getSelectionModel().selectFirstRow();
	     				PrescGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				PrescGrid.getView().focusRow(0);
	     				//Ext.getCmp('PatNo').focus(false, 100);  //默认光标
     				}
     			}
			}
		});

	}
	
	
	
	function QueryPatList()
	{
		var ListParam=GPhl+'^'+GPhw
		//var Page=GridPagingToolbar.pageSize;
		var Page=9999;
		PatListStore.setBaseParam("ParamStr",ListParam);
		PatListStore.removeAll();
		PatListGrid.store.removeAll();
		PatListStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "检索病人列表错误，请查看日志!");
     			}else{
     				if(r.length>0){
	     				//Ext.getCmp('PatNo').focus(false, 100);  //默认光标
     				}
     			}
			}
		});

	}
	
	//全发
	function DispAll()
	{
		var rowCount = PrescGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var prescno = PrescStore.getAt(i).get("PrescNo");
			var prt=PrescStore.getAt(i).get("prt");
			/*
			var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  处方审核
			adtresult="S";
			if (adtresult=="N"){
				Msg.info("warning", prescno+"该处方审核不通过,禁止发药!");
				continue;
		    } 
	     	if (adtresult=="S"){
		     	if(!confirm("提示：该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。")) continue;
		     	
		     	//var conflag="0";
				//Ext.MessageBox.confirm(prescno+"提示",prescno+"该处方医生已提交申诉,点击'是'将同意申诉继续发药，点击'否'将放弃发药操作。",function(e){if(e=="no")conflag="1";});
		    	//if(conflag=="1")continue;
		    }
		    var ref = GetPrescNoRefRet(prescno);   //LiangQiang 2014-12-22  处方拒绝
		    if (ref=="N"){
				Msg.info("warning", prescno+"该处方已被拒绝,禁止发药!");
				continue;
			}
			if (ref=="A"){
				Msg.info("warning", prescno+"该处方已被拒绝,禁止发药!");
				continue;
			}
			if (ref=="S"){
				if(!confirm("提示：该处方医生已提交申诉,点击'确定'将同意申诉继续发药，点击'取消'将放弃发药操作。"))continue;
		     	
				//var conflag="0";
				//Ext.MessageBox.confirm("提示",prescno+"该处方医生已提交申诉,点击'是'将同意申诉继续发药，点击'否'将放弃发药操作。",function(e){if(e=="no")conflag="1";});
				//if(conflag=="1")continue;
			}
			*/
			var shdr="";
			var pwin="";
			var newwin="";
			var usercode="";
			var retval=Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
		    if (retval<0) {continue;}
		    Msg.info("success", "发药成功!");
		    //发药成功改变底色
		    changeBgColor(i,"#FFCC99");
		    var record = PrescGrid.getStore().getAt(i);
		    record.set("FYStaus","OK");
		}
		QueryPatList();  //发药后刷新待发药列表
		Ext.getCmp('PatNo').focus(false, 100);  //默认光标
	}
	
	//发药
	function Disp()
	{
		var rowData=PrescGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要发药的处方!");
			return;
		}
		var prescno=rowData.get("PrescNo");
		/*
		var adtresult=ChkAdtResult(prescno) ;   //LiangQiang 2014-12-22  处方审核
		if (adtresult=="N"){
			Msg.info("warning", "该处方审核不通过,禁止发药!");
			return;
	    } 
     	if (adtresult=="S"){
			Ext.MessageBox.confirm("提示","该处方医生已提交申诉,点击'是'将同意申诉继续发药，点击'否'将放弃发药操作。",function(e){if(e=="no")return;});
	    }
	    var ref = GetPrescNoRefRet(prescno);   //LiangQiang 2014-12-22  处方拒绝
	    if (ref=="N"){
			Msg.info("warning", "该处方已被拒绝,禁止发药!");
			return;
		}
		if (ref=="A"){
			Msg.info("warning", "该处方已被拒绝,禁止发药!");
			return;
		}
		if (ref=="S"){
			Ext.MessageBox.confirm("提示","该处方医生已提交申诉,点击'是'将同意申诉继续发药，点击'否'将放弃发药操作。",function(e){if(e=="no")return;});
		}
		*/
		var shdr="";
		var pwin="";
		var newwin="";
		var usercode="";
		var prt=rowData.get("prt");
		var retval=Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
     	if (retval<0) {return;}
     	//发药成功改变底色
     	var rowCount = PrescGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var item = PrescStore.getAt(i).get("PrescNo");
			if (item == prescno) {
				changeBgColor(i,"#FFCC99")
				Msg.info("success", "发药成功!");
				var record = PrescGrid.getStore().getAt(i);
		    	record.set("FYStaus","OK");
				QueryPatList();  //发药后刷新待发药列表
				return ;
			}
		}
		
	}
	
	function Dispensing(prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode)
	{
		var retval=tkMakeServerCall("web.DHCOutPhDisp","UpdatePyd",prt,GPhl,GPydr,GFydr,prescno,shdr,pwin,newwin,usercode,"0")
		if (retval==-20)
		{
			Msg.info("error", "该处方已作废,不能发药");
			return -20;
		}
		if (retval==-21)
		{
			Msg.info("error", "该处方药品已发,不能重复发药");
			return -21;
		}
		if (retval==-4)
		{
			Msg.info("error", "该处方医嘱已停,不能发药");
			return -4;
		}
		if (retval==-7)
		{
			Msg.info("error", "发药失败,"+"失败原因: 库存不足,请核查");
			return -7;
		}
		if (retval==-24)
		{
			Msg.info("error", "发药失败,"+"失败原因: 库存不足,请核查");
			return -24;
		}
		if (retval<0)
		{
			Msg.info("error", "发药失败,"+"错误代码: "+retval);
			return -24;
		}
		if (!(retval>0))
		{
			Msg.info("error", "发药失败,"+"错误代码: "+retval);
			return -24;
		}
     	return retval;
	}
	
	// 变换行颜色
	function changeBgColor(row, color) {
		PrescGrid.getView().getRow(row).style.backgroundColor = color;
	}
	
	/*
	获取处方拒绝结果 LiangQiang 2014-12-22
	*/
	function GetPrescNoRefRet(prescno)
	{
		var ref = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdRefResultByPresc",prescno);
		return ref;
	}
	
	 //检查是否拒绝发药
	function ChkAdtResult(prescno)
	{
        var retval=tkMakeServerCall("web.DHCOutPhCommon","GetOrdAuditResultByPresc",prescno)
        return retval ;
	}
	
	function RefuseDisp()
	{
		var rowData=PrescGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要拒发的处方!");
			return;
		}
		var prescno=prescno=rowData.get("PrescNo");
		var ref = GetPrescNoRefRet(prescno);　　 //LiangQiang 2014-12-22  处方拒绝
		if (ref=="N"){
			Msg.info("warning", "该处方已被拒绝,不能重复操作!");
			return;
		}
		if (ref=="A"){
			Msg.info("warning", "该处方已被拒绝,不能重复操作!");
			return;
		}
		var adtresult=ChkAdtResult(prescno) ;
		if ((adtresult!="Y")&(adtresult!="")){
			Msg.info("warning", "该处方审核不通过,禁止操作!");
			return;
	    } 
	    var waycode ="8"
	    var retstr=showModalDialog('dhcpha.comment.selectreason.csp?orditm='+prescno+'&waycode='+waycode,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	    if (!(retstr)){
        	return;
        }
        if (retstr==""){
        	return;
        }
        retarr=retstr.split("@");
        var ret="N";
		var reasondr=retarr[0];
		var advicetxt=retarr[2];
		var factxt=retarr[1];
		var phnote=retarr[3];
		var User=session['LOGON.USERID'] ;
		var grpdr=session['LOGON.GROUPID'] ;
		var input=ret+"^"+User+"^"+advicetxt+"^"+factxt+"^"+phnote+"^"+grpdr+"^"+prescno+"^OR"  //orditm;
		if (reasondr.indexOf("$$$")=="-1")
		{
			reasondr=reasondr+"$$$"+prescno ;
		}
		var retval=tkMakeServerCall("web.DHCSTCNTSOUTMONITOR","SaveOPAuditResult",reasondr,input)
		if(retval==0)
		{
			Msg.info("success", "拒发成功!");
			var patno=rowData.get("PatNo");
			Ext.getCmp("PatNo").setValue(patno);
			Query();  
		}
		else
		{
			Msg.info("error", "拒绝失败!");
			return;
		}
	}
	
	//补全登记号
	function GetPapmiNo(patno)
	{
		var len=tkMakeServerCall("web.DHCOutPhAdd","GetPminoLen")
		var plen=patno.length;
		if(plen>len)
		{
			Msg.info("warning", "登记号输入错误！");
			return;
		}
		var lszero=""
		if (plen<=len){
			for (i=1;i<=len-plen;i++)
		  	{
				lszero=lszero+"0"  
		    }
		    patno=lszero+patno;
		}
	 	Ext.getCmp("PatNo").setValue(patno);
	}
	
	///回车卡号 GetPatNoFrCard
	function GetPatNoFrCard(cardno)
	{
		///var myoptval=CardTypeComBo.getValue();
		//if(myoptval == null|| myoptval.length <= 0) return;
		var m_CardNoLength=12 //myoptval.split("^")[17];
		cardlen=cardno.length
		if (m_CardNoLength>cardlen){
			var lszero="";
			for (i=1;i<=m_CardNoLength-cardlen;i++)
			{
				lszero=lszero+"0"  
			}
			var cardno=lszero+cardno;
		}
		var patno=tkMakeServerCall("web.DHCOutPhCommon","GetPmiNoFrCardNo",cardno)
		Ext.getCmp("PatNo").setValue(patno);
		Query();
		Ext.getCmp("CardNo").setValue("");
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
	 		Ext.Msg.show({title:'错误',msg:'输入ID号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	return;
	 	 }
	     var retflag=tkMakeServerCall("web.DHCSTInterfacePH", "GetPapmiByPatno",RegNo);
	     if(retflag=="")
	     {
		     Ext.Msg.show({title:'错误',msg:'输入ID号错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	 	 	 return;
		 }
	 	 Ext.getCmp('PatNo').setValue(RegNo);
	 	 return RegNo;
	
	}
	
	function GetPhTitle()
	{
		PhLocDesc=tkMakeServerCall("web.DHCOutPhDispFY","GetPhLocDesc",GPhl)
		if(PhLocDesc=="-1"){Ext.Msg.show({title:'错误',msg:'药房科室错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		if(PhLocDesc=="-2"){Ext.Msg.show({title:'错误',msg:'药房科室错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		PhWinDesc=tkMakeServerCall("web.DHCOutPhDispFY","GetPhWinDesc",GPhw)
		if(PhWinDesc=="-1"){Ext.Msg.show({title:'错误',msg:'窗口错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		FyUserName=tkMakeServerCall("web.DHCOutPhDispFY","GetFyUserName",GFydr)
		if(FyUserName=="-1"){Ext.Msg.show({title:'错误',msg:'人员错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		if(FyUserName=="-2"){Ext.Msg.show({title:'错误',msg:'该人员已无效!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		if(FyUserName=="-3"){Ext.Msg.show({title:'错误',msg:'该工号没有发药权限，请核实!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});return false;}
		return true;
	}
	
	function CheckPhlUser()
	{
		if(GPhl==""){}
	}
	
	function ReadCard_click()
	{
		var CardInform=DHCACC_ReadMagCard("4","","","");   //医保卡
		var myary=CardInform.split("^");
		var rtn=myary[0];
		if(rtn=="0")
		{
			var cardno=myary[1];
			GetPatNoFrCard(cardno);
		}
		else
		{
			var CardInform=DHCACC_GetAccInfo("2","2^01^注册医疗卡^NP^N^^^Y^Y^61091^^IE^N^ReadCard^2^^Read^12^Y^N^Name^N^ReadCard^Y^CA^UDHCCardInvPrt^^Y^PC^^CQU^Y^Y^Y^^")
    		var myary=CardInform.split("^");
    		var rtn=myary[0];
    		if(rtn=="0")
    		{
	    		var PatNo=myary[5];
	    		Ext.getCmp("PatNo").setValue(PatNo);
				Query();
	    	}
	    	else
	    	{
		    	Msg.info("warning", "读卡错误!");
		    	Ext.getCmp('PatNo').focus(false, 100);  //默认光标
		    }
		}
	}
	
	
	function CallVioce()
	{
		var rowCount = PatListGrid.getStore().getCount();
		if (rowCount == 0) {
			Msg.info("warning", "没有需要的病人!");
			return;
		}
		var pat_name = PatListStore.getAt(0).get("PatName");
		var IPAddress=GetComputerIp()
		var call_room=PhWinDesc;
		var dept_name=PhLocDesc;
		var input="<patient_info><IPaddress>"+IPAddress+"</IPaddress><pat_name>"+pat_name+"</pat_name>"+
			"<call_room>"+call_room+"</call_room><dept_name>"+dept_name+"</dept_name><pass_name></pass_name></patient_info>"
		var ret=tkMakeServerCall("web.DHCENS.BLL.CallStation.Method.CallPatientInfo","SetCallPatientInfo",input)
	}
	
	
	//过号
	function Delay()
	{
		var rowData=PatListGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要过号的病人!");
			return;
		}
		var PatNo=rowData.get("PatNo");
		var PatID=rowData.get("PatID");
		var ret=tkMakeServerCall("web.DHCOutPhDispFY","Delay",GPhl,GPhw,PatNo,PatID)
		
	}
	
	function GetComputerIp() 
	{
	   var ipAddr="";
	   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
	   var service = locator.ConnectServer("."); //连接本机服务器
	   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration");  //查询使用SQL标准 
	   var e = new Enumerator (properties);
	   var p = e.item ();

	   for (;!e.atEnd();e.moveNext ())  
	   {
	  	var p = e.item ();  
	 	//document.write("IP:" + p.IPAddress(0) + " ");//IP地址为数组类型,子网俺码及默认网关亦同
		ipAddr=p.IPAddress(0); 
		if(ipAddr) break;
		}

		return ipAddr;
	}
	
	var mainForm = new Ext.form.FormPanel({
		id:'mainForm',
		//title:'<span style="color:red">'+'发药查询'+'</span>',
		tbar : [ClearBT,'-',SearchBT,'-',DispBT,'-',DispAllBT],
		bbar : [DispFlag,'-',AllFlag,'-',ReadCardButton,'-',PrintBT],
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items:[{
			layout:'column',
			xtype: 'fieldset',
			title:'查询条件',
			style:'padding:0px 20px 0px 0px',
			items:[{
				//columnWidth: 0.5,
		    	border: false,
		    	items: [{
				    	layout : "form",
				    	items: [stdatef]
			    	},{
				    	layout : "form",
				    	items: [enddatef]
			    	},{
				    	layout : "form",
				    	items: [PatNo]
			    	},{
				    	layout : "form",
				    	items: [CardNo]
			    	}]
			}]
		}]						
	});
	
	
	var myPanel = new Ext.Viewport({
		renderTo:'mainPanel',
		layout : 'border',
		items : [{
			region:'north',
			layout:'fit',
			items:TitlePanel,
			height:30
		},{
			region:'west',
			width:190,
			collapsible:true,
			layout:'fit',
			title:'<span style="color:red">'+'待发病人列表'+'</span>',
			items:PatListGrid
		},{
			region:'center',
			title:'<span style="color:red">'+'发药查询'+'</span>',
			collapsible: true,
			layout:'border',
			items:[{  
                region:'north',
                layout: 'fit',
                items:mainForm,
                height:250            
            },{
	            region:'center',  
	            layout:'fit',
                items:PrescGrid
                }]
		},{
			region:'east',  
			width:800,
			layout:'fit',
			items:reportPanel
		}]
	})
	Ext.getCmp('PatNo').focus(false, 100);  //默认光标
	QueryPatList();
	
	var task_RealTimeMointor = {
		run : QueryPatList,  //执行任务时执行的函数
		interval : 10000 
		//任务间隔，毫秒为单位，这里是10秒
    }
   
    //开启自动	
    function StartAutoLoad()
    {		
		Ext.TaskMgr.start(task_RealTimeMointor);
    }
   
    //关闭自动
    function StopAutoLoad()
    {
		Ext.TaskMgr.stop(task_RealTimeMointor);       
    } 
    StartAutoLoad();
    
     /*
	// 快捷键
	PrescGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.F2) {   //发药
			Disp();
		}
		if (e.getKey() == Ext.EventObject.F4) {   //全发
			DispAll();
		}
		if (e.getKey() == Ext.EventObject.F6) {   //读卡
			ReadCard_click();
		}
	})
	*/
	// 快捷键
 	var map=new Ext.KeyMap(document,[{
		 	key:Ext.EventObject.F2,  //发药
		 	fn:Disp,
		 	alt:false,
		 	scope:true
		}, {
			key:17,  //ctrl全发
		 	fn:DispAll,
		 	alt:false,
		 	scope:true
		}, {
			key:Ext.EventObject.F6,  //读卡
		 	fn:ReadCard_click,
		 	alt:false,
		 	scope:true
		}
	])
	map.enable();
})

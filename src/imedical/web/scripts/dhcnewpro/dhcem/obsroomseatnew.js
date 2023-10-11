///creator:qqa
///creatDate:2017-10-24
var IsInitTable=false;
var ThisBedDataId="";
var seatWith="",seatHeight="";
var HOSOPEN = ""; //用户大会
$(function(){
	initParam();
	
	initPage();
	
	initSet();
	
	initTabs();
	
	initCombo();
	
	initSeat();
	
	initMethod();
	
	//LoadMoreScr(); //用户大会

})

function initSet(){
	if(UPDSEATNEEDPAS==1){
		$("#planPatTable-UserPas").removeAttr("disabled");
		$("#planPatTable-UserPas").val("");
	}else{
		$("#planPatTable-UserPas").attr("disabled","disabled");
		$("#planPatTable-UserPas").val("");
	}
}

function initPage(){
	
	if(BEDLAYOUTDEF==1){
		$HUI.switchbox("#switch2").setValue(false);
	}
	
	return;
}

function initParam(){
	
	HOSOPEN = getParam("hosOpen");  // 是否是HOS调用 //用户大会
	
	obsPatTable = {
		table:"",
		checkIndex:"",  //指针：指向datagrid当前选中的行	
	};
	
	selObsPat={        //指向选中的等候区病人,占时不用
		adm:""
	};
	
	selSeatPat={  	  //指向选中的床位病人
		seatID:"",	  //通过这个字段可以判断床位是否选中
		adm:"",		  //通过两个字段可以判定选中床位是否有人
		planSeatID:"" //安排的时候将要安排的床位ID
	};
	
	selMovePat={      //通过移动换床病人指针
		seatID:"",	  //通过这个字段可以判断床位是否选中
		adm:"",		  //通过两个字段可以判定选中床位是否有人
		planSeatID:"" //安排的时候将要安排的床位ID
	}
	
	globleParam={
		planMode:"",   //P：安排到床位   C:安排到等候区  U:换床  UP:转移
	};
	
	curWrad={
		wardId:"",	
		wardDesc:""
	};
	
	
	seatNum={
		allSeatNum:0,  //人数
		chkLevOne:0,
		chkLevTwo:0,
		chkLevThree:0,
		chkLevFourA:0,
		chkLevFourB:0,
		hasPatSeatNum:0, //在床人数
		makeSeatNum:0,//包床人数
	}
	
	obsRoom = {
		width:0,
		height:0	
	}
	
	seatPointer=0 ; //代表加载床位第几张床：暂时不用
	
	DateFormat=4;
	
	seatTimeCount=0;  //获取病人和图标分开来，这是获取图标部分
	
	lastRowY="";  	  //最后一排床位
	
	var Params=0;
	runClassMethod("web.DHCEMObsRoomSeat","GetGlobleParams",{"Params":Params},function(ret){
		var retArr=ret.split("^");
		curDate=retArr[0];
		curTime=retArr[1];
	},'text',false)

}

//初始化所有界面元素的方法
function initMethod(){
	addObsAreaMethod();	  //等候区点击方法
//	$(".planPat-Btn:contains('安排')").on('click',planOrClearPat);   //安排按钮
//	$(".planPat-Btn:contains('取消')").on('click',closeWindow);   //安排按钮
//	$(".dis-Btn:contains('更新')").on('click',disHospPat);
//	$(".cancel-Btn:contains('更新')").on('click',cancelAccPat);
	$("#PlanBtn").on('click',planOrClearPat);   //安排按钮 //hxy 2022-12-19 改描述为ID
	$("#AboliBtn").on('click',closeWindow);   //安排按钮
	$("#UpdBtn").on('click',disHospPat);  // 离院更新按钮
	$("#DisAboliBtn").on('click',closeWindow);   // 离院取消按钮
	$("#UpdaBtn").on('click',cancelAccPat);
	$("#top_btn_ord").on({
		mouseover : function(){topBtnOrdOver()} ,
		mouseout : function(){topBtnOrdOut()} 
	})
	$(".opbtn-makeSeatBtn").on('click',makeSeat);
	$(".opbtn-upSeatBtn").on('click',upSeatWin);
	$(".opbtn-cancelAcc").on('click',cancelAcc);
	$("#disHosp").on('click',disHospWin);/*hxy 2018-07-02*/
	$("#upObsBtn").on('click',planPatToObs);/*hxy 2018-07-02*/
	$("#prtStraps").on('click',prtStraps);
	$("#transBed").on('click',transtBed);
	$("#patGreenWay").on('click',showGreenRec);
	$('#filterValue').on('keypress',filterValue_KeyPress);
	$("#emPatChange").on('click',emPatChange);
	$("#doccancel").bind('click',DoCancel);  /// 主管医生取消
	$("#docsure").bind('click',DocSure);  /// 主管医生确定
}

function topBtnOrdOver(){
	if($(".hasSyOrd").length){
		$(".hasSyOrd").find(".seatBody").css("background","yellow");
	}
}
function topBtnOrdOut(){
	if($(".hasSyOrd").length){
		$(".hasSyOrd").find(".seatBody").css("background","#fff");
	}
}

//换床
function upSeatWin(){
	var patAdm="";
	var selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板
	if(selPatData.length){
		$.messager.alert("提示","换床操作只能操作已在床患者！");
		return;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("提示","请选中一个在床患者！");
		return;
	}
	globleParam.planModel = "UP";  
	loadPlanPatWin(patAdm);
	return; 	
}

function emPatChange(){

	var patAdm="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("提示","未选留观室病人！");	
		return;
	}
	
	var lnk = "dhcem.visitstat.csp?EpisodeID="+patAdm;
	var winwidth="1200";
	if(screen.availWidth-50<winwidth){
		winwidth=screen.availWidth-50;
	}
	var iLeft = ($(window).width()-winwidth)/2; //获得窗口的水平位置;
	var iTop=($(window).height()-700)/2; //获得窗口的垂直位置;
	websys_showModal({
		url: lnk,
		width:winwidth,
		height:700,
		left:iLeft,
		top:iTop,
		iconCls:"icon-w-paper",
		title: $g('急诊患者状态改变'),
		closed: true,
		onClose:function(){
				
		}
	});
	
	return ;
		
}

//撤销结算
function cancelAcc(){
	
	var canAccData = $("#disHospTable").datagrid("getSelections"); 
	var Adm = canAccData[0].AdmID;
	if(!canAccData.length){
		$.messager.alert("提示","请选中一个离院患者！");
		return;
	}
	
	runClassMethod("web.DHCEMPatChange","GetFinalStat",
	{
		"EpisodeID":Adm
	},function(data){
		if(data!="0"){
			$.messager.alert("提示",data);
			return;
		}else{
			$HUI.window("#cancelWin").open();
			initCancelWinCombobox();
		}
	},'text')	
}

function initCancelWinCombobox(){
	$HUI.combobox("#cancelWin-cancelCause",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=PayoutreasonTojson",
		valueField:'text',
   		textField:'text',
   		editable:false,
   		onLoadSuccess:function(data){
	   		$HUI.combobox("#cancelWin-cancelCause").setValue(data[0].text);
	   	}
	})	
}

function disHospWin(){
	var patAdm="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("提示","选中要离院的病人！");	
		return;
	}
	var isControl=0,abnOrdInfo="";
	
	//var retInfo=serverCall("web.DHCEMPatChange","GetAbnormalOrder",{'EpisodeID':patAdm,'LgParams':LgParams});
	runClassMethod("web.DHCEMPatChange","GetAbnormalOrder",
		{
			"EpisodeID":patAdm,
			"LgParams":LgParams
		},function(data){
			var retInfo=data;
			if(retInfo.length!=0){
				isControl=retInfo[0].ifCanOper;
				abnOrdInfo=(retInfo[0].abnormalMsgs)[0].abnormalMsg;
			}
		},'json',false)	
	
	if(abnOrdInfo!=""){
		if(isControl!=0){
			$.messager.alert("提示:","有医嘱需要处理，请先处理！","info",function(){/// 2022-07-29 cy  请先处理需关注医嘱！需关注医嘱信息:  +abnOrdInfo
				websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+patAdm+"&defaultTypeCode=D","","width='"+window.screen.availHeight-100+"' height='"+window.screen.availWidth-100+"'");
			});
			return;
		}
	}
	/// 2022-11-03 cy  获取入观时间
	var InSeatDateInfo=serverCall("web.DHCEMObsRoomSeat","GetFirstInSeatDateDesc",{'Adm':patAdm});
	var InSeatDate="",InSeatTime="";
	if(InSeatDateInfo!=""){
		InSeatDate=InSeatDateInfo.split(" ")[0];
		InSeatTime=InSeatDateInfo.split(" ")[1];
	}
	
	if((isControl==0)&&(abnOrdInfo!="")){			///需关注医嘱未配置管控，只提示。
		$.messager.confirm('提示', '存在需处理医嘱，是否确定离院操作?', function(result){  
        	if(result) {
	        	openDisWin(patAdm,curDate,curTime,InSeatDate,InSeatTime);
	        }
	    })
	}else{
		openDisWin(patAdm,curDate,curTime,InSeatDate,InSeatTime);
	}
	
}

function openDisWin(patAdm,curDate,curTime,InSeatDate,InSeatTime){
	$("#disPatWin").window("open");
	$("#disPatWin-disPatAdm").val(patAdm);
	$("#disPatWin-disStDate").datebox("setValue",InSeatDate); /// 2022-11-03 cy  离院弹窗 开始日期应显示入观日期
	$('#disPatWin-disStTime').timespinner('setValue',InSeatTime); /// 2022-11-03 cy  离院弹窗 开始时间应显示入观日时间
	$("#disPatWin-disDate").datebox("setValue",curDate);
	$('#disPatWin-disTime').timespinner('setValue',curTime);
	$('#disPatWin-DischargeNote').combobox("setValue","");	
}

function transtBed(){	
	var patAdm="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("提示","未选留观室病人！");	
		return;
	}
	
	var lnk = "dhcem.rotatingbed.csp?EpisodeID="+patAdm;
	var winwidth="1200";
	if(screen.availWidth-50<winwidth){
		winwidth=screen.availWidth-50;
	}
	var iLeft = ($(window).width()-winwidth)/2; //获得窗口的水平位置;
	var iTop=($(window).height()-700)/2; //获得窗口的垂直位置;

	websys_showModal({
		url: lnk,
		width:winwidth,
		left:iLeft,
		height:700,
		top:iTop,
		iconCls:"icon-w-paper",
		title: $g('留观患者床位转移'),
		closed: true,
		onClose:function(){}
	});
	
	return ;	
}

//撤销结算更新
function cancelAccPat(){
	var canAccData = $("#disHospTable").datagrid("getSelections");
	var Adm = canAccData[0].AdmID;
	var reverseDesc = $HUI.combobox("#cancelWin-cancelCause").getValue();
	
	if(reverseDesc===""){
		$.messager.alert("提示","撤销原因不能为空！");
		return;	
	}
	
	runClassMethod("web.DHCEMPatChange","DelDisorReversePay",
		{
			"Adm":Adm,
			"userId":UserID,
			"reverseDesc":reverseDesc
		},function(data){
			if(data==0){
				$.messager.alert("提示","撤销成功！");	
				reloadObsAreaAndSeat(curWrad.wardId); 
			}else{
				$.messager.alert("提示",data);	
			}
		},'text',false)	
}

//离院更新
function disHospPat(){
	var Adm = $("#disPatWin-disPatAdm").val();  //Adm
	var disHospDate = $HUI.datebox("#disPatWin-disDate").getValue("");
	var disHospTime =  $HUI.timespinner('#disPatWin-disTime').getValue();
	var dischargeNote = $('#disPatWin-DischargeNote').combobox("getText");
	if(dischargeNote==""){
		$.messager.alert("提示","离院原因不能为空!");
		return;
	}
	runClassMethod("web.DHCEMPatChange","SetPatChargeStatusNew",
		{"EpisodeID":Adm,
		"StatusDate":disHospDate,
		"StatusTime":disHospTime,
		"userID":UserID,
		"WardDesc":"",
		"Notes":dischargeNote
		},function(data){
		if (data==="0") {
			$.messager.alert("提示","成功！");
			reloadObsAreaAndSeat(curWrad.wardId); 
		}else{
			$.messager.alert("提示",data);
		}
	},'text',false)
}

//包床
function makeSeat(){
	websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=PACWardRoom.ListUnocc&WardID='+curWrad.wardId+'&AvailableBeds=true&SortOrder=1',false,'top=40,left=40,width=640,height=480');
}

//左上角安排按钮
function planPatToObs(){
	
	if(selSeatPat.adm==="") {
		//$.messager.alert("提示","未选中床位图病人！");
		return;
	}
	globleParam.planModel = "C";  
	loadPlanPatWin(selSeatPat.adm);
	return ;	
}

function closeWindow(){
	$HUI.window("#planPatWin").close();	
	$HUI.window("#disPatWin").close();
}

//安排病人窗口
function planOrClearPat(){
	// Param:UserID^BedID^DocDr^PatAdm^Date^Time
	if(UPDSEATNEEDPAS==1){
		var userCode = $("#planPatTable-UserId").val();
		var userPas = $("#planPatTable-UserPas").val();
		if(userPas==""){
			$.messager.alert("提示","密码不能为空！");
			return;
		}
		var validPas="";
		runClassMethod("web.DHCEMSkinTest","ConfirmPassWord", {'userCode':userCode,'passWord':userPas},function(data){
			validPas=data;
		},'text',false)
		if (validPas.split("^")[0] != 0) {
			$.messager.alert("提示",validPas);
			return;
		}
		
	}
	
	
	var planBedID="",patAdm="";
	if((globleParam.planModel==="UP")||(globleParam.planModel==="P")||(globleParam.planModel==="U")){ 
		var bedSelRow = $('#planWinPat-SeatNo').combogrid('grid').datagrid('getSelected');
		if(!bedSelRow){
			$.messager.alert("提示","请选择一个床！");
			return ;
		}
		
		if((globleParam.planModel==="UP")||(globleParam.planModel==="U")){
			patAdm = selSeatPat.adm;
			planBedID = bedSelRow.BedID;
		}
		if(globleParam.planModel==="P"){
			var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板
			patAdm = selPatData[0].AdmID;
			planBedID = bedSelRow.BedID;
		}
	}

	if(globleParam.planModel==="C"){
		planBedID="";
		patAdm= selSeatPat.adm;
	}
	
	if(globleParam.planModel==="M"){    //拖动换座位
		planBedID=selMovePat.seatID;
		patAdm= selMovePat.adm;
	}

	var DocSelRow = $('#planPatTable-Doc').combogrid('grid').datagrid('getSelected');
	var DocCode = DocSelRow?DocSelRow.CtPcpCode:"";
	var Nur1SelRow = $('#planPatTable-Nur1').combogrid('grid').datagrid('getSelected');
	var Nur1Id = Nur1SelRow?Nur1SelRow.NurId:"";
	var Nur2SelRow = $('#planPatTable-Nur2').combogrid('grid').datagrid('getSelected');
	var Nur2Id = Nur2SelRow?Nur2SelRow.NurId:"";
	var stDate = $HUI.datebox('#planWinPat-StDate').getValue();
	var stTime = $HUI.timespinner('#planWinPat-StTime').getValue();
	var param =UserID+"^"+planBedID+"^"+DocCode+"^"+patAdm+"^"+stDate+"^"+stTime+"^"+Nur1Id+"^"+Nur2Id+"^"+curWrad.wardId

	runClassMethod("web.DHCEMObsRoomSeat","PlanPat",{"Param":param},function(data){
		if (data==="0") {
			$.messager.alert("提示","安排成功！");
			reloadObsAreaAndSeat();
			clearPlanWin();			  //清除面板
		}else{
			$.messager.alert("提示",data);		
		}
	},'text',false)
}

function reloadObsAreaAndSeat(){
	var CurWardDr = curWrad.wardId; 
	$HUI.datagrid('#obsPatTable').load({
		WardDr:CurWardDr
	})
	
	$HUI.datagrid('#disHospTable').load({
		WardDr:CurWardDr
	})
	
	loadBedView(CurWardDr);
}

///其他界面操作刷新床位图提供局部刷新方法
function localRefresh(){
	reloadObsAreaAndSeat();	
}

function loadBedView(CurWardDr){
	loadSeat(CurWardDr);

	obsPatTable.checkIndex="";
	obsPatTable.table="";
	selObsPat.adm="";
	selSeatPat.seatID="";
	selSeatPat.adm="";
	selMovePat.seatID="";
	selMovePat.adm="";
	globleParam.planMode="";
	seatNum.makeSeatNum=0;
	seatNum.hasPatSeatNum=0;
	seatNum.allSeatNum=0;
	$HUI.window("#planPatWin").close();
	$HUI.window("#disPatWin").close();
	$HUI.window("#cancelWin").close();
	$HUI.datagrid('#obsPatTable').resize();
	$HUI.datagrid('#disHospTable').resize();	
}

///初始化table:只走一遍
function initTable(){
	
	if(IsInitTable) return;	
	IsInitTable=true;
	
	var CurWardDr = curWrad.wardId;
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'',width:obsRoom.width-10,formatter:setCellLabelNormal}
	]];

	$HUI.datagrid('#obsPatTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetCurWardObsPat&WardDr="+CurWardDr+"&LgParams="+LgParams,
		fit:true,
		height:'150px',
		rownumbers:false,
		columns:columns,
		pageSize:5,
		pageList:[5,10,15],
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		showHeader:false,
		pagination:false,
    	onSelect: function (rowIndex, rowData) {
         	checkOrUnCheck("obsPatTable",rowIndex);
         	setEprMenuForm(rowData.AdmID,rowData.PatientID);
     	},
     	onLoadSuccess:function(rowData){
	     	$("#waitNumber").html(rowData.total);
	    	initDragAndDrop();
	    },
	    onRowContextMenu: function (e, rowIndex, rowData) { 
	    	/// 增加右键菜单 2019-02-21 bianshuai
			e.preventDefault(); //阻止浏览器捕获右键事件
			$(this).datagrid("clearSelections"); //取消所有选中项
            		$(this).datagrid("selectRow", rowIndex); //根据索引选中该行
			if(!validIsCheckPat()){
				$.messager.alert("提示","未选中任何留观室病人！");
				return;
			}
			disableMenuItm($g("等候")+","+$g("腕带"));
			$HUI.menu('#menu').show({ 
	           //显示右键菜单  
	           left: e.pageX,//在鼠标点击处显示菜单  
	           top: e.pageY  
			});
			return true;
	    }
	});
	
	var columns=[[
		{field:'PatLabel',title:'',width:obsRoom.width-10,formatter:setCellLabelNoDrag}
	]];
	$HUI.datagrid('#disHospTable',{
		url:LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetCurWardDisHospPat&WardDr="+CurWardDr,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:true,
		pageSize:40,  
		pageList:[40,80], 
	    singleSelect:true,
		loadMsg: $g('正在加载信息...'),
		showHeader:false,
		rownumbers : false,
		showPageList : false,
		onSelect: function (rowIndex, rowData) {
			checkOrUnCheck("disHospTable",rowIndex);
         	setEprMenuForm(rowData.AdmID,rowData.PatientID);
     	},
     	onLoadSuccess:function(rowData){
	    	$("#disHospNumber").html(rowData.total);
	    }
	});
}

function disableMenuItm(menuDesc){
	
	var allMenuArr = [$g("出院"),$g("状态改变"),$g("等候"),$g("腕带"),$g("转移"),$g("绿色通道")]; 
	var menuArr=menuDesc.split(",");
	for(i in allMenuArr){
		var item = $('#menu').menu('findItem', allMenuArr[i]);
		if(menuArr.indexOf(allMenuArr[i])<0){
			$('#menu').menu('enableItem', item.target);
		}else{
			$('#menu').menu('disableItem', item.target);
		}
	}
	return;
}

function validIsCheckPat(){
	var patAdm="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm==""){
		return false;	
	}	
	return true;
}

function initDragAndDrop(){
	$HUI.droppable(('.onDroppable'),{
		accept: '.onDraggable',
		onDragEnter:function(e,source){
			//$(this).find(".seatcontent").css({"border":"3px solid #6b6fc7"});
		},
		onDragLeave: function(e,source){
			//$(this).find(".seatcontent").css({"border":"1px solid #ccc"});
		},
		onDrop: function(e,source){
			$(this).find(".seatcontent").css({"border":"1px solid #ccc"});
			globleParam.planModel="M";
			selMovePat.seatID=$(this).attr("data-id");
			loadPlanPatWin(selMovePat.adm);
		}
	})

	$HUI.draggable(('.onDraggable'),{
		revert:true,
		deltaX:10,
		deltaY:10,
		proxy:function(source){
			var n = $('<div class="proxy"></div>');
			n.html($(source).html()).appendTo('body');
			return n;
		},
		onStartDrag:function(event){
			selMovePat.adm = $(this).attr("data-adm")
		}
	});
	
	/*
	$HUI.droppable(('.seatOnDrop'),{
		accept: '.seatOnDrag',
		onDragEnter:function(e,source){
			//$(this).find(".seatcontent").css({"border":"3px solid #6b6fc7"});
		},
		onDragLeave: function(e,source){
			//$(this).find(".seatcontent").css({"border":"1px solid #ccc"});
		},
		onDrop: function(e,source){
			//$(this).find(".seatcontent").css({"border":"1px solid #ccc"});
			//globleParam.planModel="M";
			//selMovePat.seatID=$(this).attr("data-id");
			//loadPlanPatWin(selMovePat.adm);
			
		}
	})

	$HUI.draggable(('.seatOnDrag'),{
		revert:true,
		deltaX:10,
		deltaY:10,
		proxy:function(source){
			var n = $('<div class="proxy"></div>');
			n.html($(source).parent().html()).appendTo('body');
			return n;
		},
		onStartDrag:function(event){
			//selMovePat.adm = $(this).attr("data-adm")
			console.log("开始");
		}
	});
	*/
	
}

//datagrid 点击选中,再次取消选中
function checkOrUnCheck(id,rowIndex){
	
	if((obsPatTable.table=="")||((obsPatTable.table!="")&&(obsPatTable.table!=id))){
		obsPatTable.table=id;
		obsPatTable.checkIndex="";
	}
	
	if (obsPatTable.checkIndex==="") {
	 	obsPatTable.checkIndex = rowIndex;
	 	if(selSeatPat.seatID!==""){
			checkOrUnCheckSeat($(".seatcontent.active").children(".seatcontent"));	
		}
	}else if((obsPatTable.checkIndex!=="")&&(obsPatTable.checkIndex!==rowIndex)){
		obsPatTable.checkIndex=rowIndex;
		if(selSeatPat.seatID!==""){
			checkOrUnCheckSeat($(".seatcontent.active").children(".seatcontent"));	
		}
	}else if(obsPatTable.checkIndex===rowIndex){
		$("#"+id).datagrid("unselectRow", rowIndex);
		obsPatTable.checkIndex="";
	}
	
	if(id=="obsPatTable"){
		$("#disHospTable").datagrid("uncheckAll");
	}
	if(id=="disHospTable"){
		$("#obsPatTable").datagrid("uncheckAll");
	}
	return ;	
}

function checkOrUnCheckAll(){
	$("#disHospTable").datagrid("uncheckAll");
	$("#obsPatTable").datagrid("uncheckAll");
	return;
}

//Seat 点击选中,再次取消选中
function checkOrUnCheckSeat($this)
{
	var $seatCont = $this.children(".seatcontent")
	$seatCont.toggleClass("active");   //选中效果实现
	if($seatCont.hasClass("active")){  //指针赋
		selSeatPat.seatID =$this.attr("data-id");
		selSeatPat.adm =$this.attr("data-adm");
		setEprMenuForm($this.attr("data-adm"),"");   
		LoadMoreScr(); //用户大会
		setPanelPatInfo(selSeatPat.adm, ""); //用户大会
		
	}else{
		setPanelPatInfo(selSeatPat.adm, ""); //用户大会
		selSeatPat.seatID ="";
		selSeatPat.adm =""; 
		setEprMenuForm("","");  
		
		LoadLoginScr(); //用户大会
	}
	
	$(".seat").not($this).each(function(){
		$(this).children(".seatcontent").removeClass("active")	
	})	
}

///初始化床位
function initSeat(){
	var CurWardID = curWrad.wardId ;
	$(".obsseat").css({"max-height":$(".center").height(),"height":$(".center").height(),"overflow":"auto"});
	//获取床位信息
	loadSeat(CurWardID);
}

function initPatIncon(CurWardID){
	PatInconData="";
	runClassMethod("web.DHCEMObsRoomSeat","GetWardIconInfo",{"WardID":CurWardID,"LgParams":LgParams},function(data){
		PatInconData = data;
		showSeatIcon();
	})
}


///**生成床位
function loadSeat(CurWardID){
	clearAllSeat();   			//清除床位
	addAllSeat(CurWardID);  	//加载床位
}


function showSeatIcon(){
	for (var i=0;i<PatInconData.length;i++){
		var itm = PatInconData[i];
		var seatID = itm.SeatID;
		var iconHtmlText = itm.IconHtmlText;
		if($(".seatbodyicon[seatID='"+seatID+"']").parent().parent().parent().parent().attr("data-adm")){
			$(".seatbodyicon[seatID='"+seatID+"']").html(iconHtmlText);
			if(itm.IsHasSyOrd){
				seatNum.hasAllOrdNum++;
				$(".seatbodyicon[seatID='"+seatID+"']").parent().parent().parent().parent().addClass("hasSyOrd");
			}
		}
	}
	
	///设置含有未执行医嘱人数
	if($("#filterValue").val()){
		return;	
	}
	if($(".queryItmActive").length){
		return;	
	}
	$("#top_btn_ord").html(seatNum.hasAllOrdNum);
}

function showCurWardPatNum(){
	$(".online").html($g("病区床数")+":"+seatNum.allSeatNum);
	$(".unline").html($g("安排人数")+":"+seatNum.hasPatSeatNum);
	$(".makeseat").html($g("包床人数")+":"+seatNum.makeSeatNum);	
}

function setCellLabelNoDrag(value, rowData, rowIndex){
	return setCellLabel(value, rowData, rowIndex,"");
}

function setCellLabelNormal(value, rowData, rowIndex){
	return setCellLabel(value, rowData, rowIndex,1);
}

/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex, mode){
	var dragClass="";
	mode==1?dragClass="onDraggable":"";
	
	var tooltipStr =rowData.PatName+","+rowData.PatSex+","+rowData.PatAge+","+rowData.PatType;
	var htmlstr =  	    '<div class="celllabel '+""+'" title="'+tooltipStr+'" class="hisui-tooltip" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.AdmID+'">'
	var htmlstr = htmlstr+'<span class="">';
	//var htmlstr = htmlstr+'</span><span class="l-btn-icon icon-readothercard">&nbsp;</span></span>';
	if((rowData.PatSex==$g("男"))||(rowData.ChPatSex=="男")){//hxy
		var htmlstr = htmlstr+'<span class="pat_man">&nbsp;</span>';
	}else if((rowData.PatSex==$g("女"))||(rowData.ChPatSex=="女")){
		var htmlstr = htmlstr+'<span class="pat_woman">&nbsp;</span>';
	}else{
		var htmlstr = htmlstr+'<span class="pat_noman">&nbsp;</span>';	
	}
	var htmlstr = htmlstr+'<span class="pat_name">'+rowData.PatName+'</span>';
	if(rowData.DischargeDate){
		htmlstr = htmlstr+' '+rowData.DischargeDate+' '+rowData.DischargeTime;	
	}
	if(rowData.IsNewObsPat=="Y"){
		var htmlstr = htmlstr+'<span class="obsPatTableTag">'+$g('新入')+'</span>'
	}
	if(rowData.IsHasSyOrd=="1"){
		var htmlstr = htmlstr+'<span class="obsPatTableTag">'+$g('需执')+'</span>';
	}
	if(rowData.IsReCall=="Y"){
		var htmlstr = htmlstr+'<span class="obsPatTableTag">'+$g('召回')+'</span>';
	}
	if(rowData.IsTransPat=="Y"){
		var htmlstr = htmlstr+'<span class="obsPatTableTag">'+$g('转入')+'</span>';	
	}
	var htmlstr = htmlstr+'</span>';
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

function clearAllSeat(){
	$(".obsseat").empty();
	seatNum={
		allSeatNum:0,  //人数
		chkLevOne:0,
		chkLevTwo:0,
		chkLevThree:0,
		chkLevFourA:0,
		chkLevFourB:0,
		hasAllOrdNum:0,
		hasAllOrdNum:0,
		hasPatSeatNum:0, //在床人数
		makeSeatNum:0,//包床人数
	}
	seatPointer=0;
}
function addAllSeat(CurWardID){
	loadingShowOrHide("show");
	var filterValue = $("#filterValue").val();
	var filterType = $("#filterCombo").combobox("getValue");
	if($(".queryItmActive").length){
		filterType=$(".queryItmActive").attr("filterType");
		filterValue=$(".queryItmActive").attr("filterValue");
	}
	
	var otherParams=filterType+"^"+filterValue;
	runClassMethod("web.DHCEMObsRoomSeat","GetWardSeatInfo",{"WardID":CurWardID,"LgParams":LgParams,"OtherParams":otherParams},function(data){
		
		setLastRowY(data.SeatData);
		
		//初始化床铺
		for(i=0;i<data.SeatData.length;i++){
			addSeat(data.SeatData[i]);	
		}
		setTopNumber();
		addObsRoom(data.ObsRoomData); //初始化等候区
		InitLocNum(data.AdmLocData);	
		showCurWardPatNum();
		addSeatMethod();      		//床位点击方法
		initPatIncon(CurWardID); 	//初始化图标数据	
		initAccordion();
		initTable();
		loadingShowOrHide("hide");
		initChangeBedViewPosition();
		showBlankBed();
	},'json',true)		
}

function initChangeBedViewPosition(){
	var obj={value:$HUI.switchbox("#switch2").getValue()};
	changeBedViewPosition(obj);
}

function setTopNumber(){
	if($("#filterValue").val()){
		return;	
	}
	if($(".queryItmActive").length){
		return;	
	}
	$("#top_btn_all").html(seatNum.allSeatNum);
	$("#top_btn_one").html(seatNum.chkLevOne);
	$("#top_btn_two").html(seatNum.chkLevTwo);
	$("#top_btn_three").html(seatNum.chkLevThree);
	$("#top_btn_foura").html(seatNum.chkLevFourA);
	$("#top_btn_fourb").html(seatNum.chkLevFourB);
	//$("#top_btn_ord").html(seatNum.hasAllOrdNum);
}

function setLastRowY(seatData){
	var itmSeatTop="";
	for(i=0;i<seatData.length;i++){
		itmSeatTop = parseInt(seatData[i].BEDPositionTop);
		lastRowY==""?lastRowY=itmSeatTop:"";
		lastRowY<itmSeatTop?lastRowY=itmSeatTop:"";
	}
	return "";
}

function loadingShowOrHide(mode){
	if(mode=="hide"){
		$("#Loading").fadeOut("fast");	
	}else{
		$("#Loading").fadeIn("fast");	
	}
}

function showBlankBed(){
	if(($("#filterValue").val())||($(".queryItmActive").length)){
		$(".seat").each(function(){
			$(this).find(".patName").text()?"":$(this).hide();
		})
	}
	return;
}

function InitLocNum(data){
	
	if($("#filterValue").val()){
		return;	
	}
	if($(".queryItmActive").length){
		return;	
	}
	showAdmLoc(data);		
}

function showAdmLoc(data){
	var jsonObjArr = data;
	var thisHtml="";
	for (var i=0; i<jsonObjArr.length; i++){
		var LocDesc=jsonObjArr[i].LocDesc;
		var LocDescOld=LocDesc;
		var filterType="AdmLoc";
		if (LocDesc==$g("超过72小时")){
			filterType="Out72Hours";
			LocDesc = '<span style="color:red;font-weight: 500;">'+$g('超过72小时')+'</span>'
		}
		
		thisHtml==""?"":thisHtml=thisHtml+"<span class='dymLocDom' style='display: inline-block;width:15px;'></span>";
		thisHtml=thisHtml+"<span class='queryItm' onclick='clickQueryItm(this)' filterType='"+filterType+"' filterValue='"+LocDescOld+"'>"
		thisHtml=thisHtml+	"<span style='color:black;' class='dymLocDom'>"+LocDesc+"</span><span class='showNumberSpan dymLocDom'>"+jsonObjArr[i].Num+"</span>";
		thisHtml=thisHtml+"</span>";
	}
	if($(".dymLocDom").length) $(".dymLocDom").remove();
	$("#topLoc").after(thisHtml);
	return;
}


function addObsRoom(data){
	//下面是dom操作
	
	//这里初始化有些问题
	if(data===""){
		$("#obsRoom").css({width:0,height:0});     //没有配置等候区
		return; 
	}
	
	$("#obsRoom").show();
	
	var obsRoomId = data.PACRoom;
	var obsRoomLeft=data.BEDPositionLeft;
	var obsRoomTop=data.BEDPositionTop;
	var obsRoomWidth=data.BEDPositionWidth;
	var obsRoomHeight=data.BEDPositionHeight;
	if(obsRoom.width!=""){
		obsRoomWidth = obsRoom.width;
		obsRoomHeight = obsRoom.height;
	}else{
		obsRoom.width=obsRoomWidth;
		obsRoom.height = obsRoomHeight;
	}
	
	$("#obsRoom").data("roomId",obsRoomId);
	$("#obsRoom").css(
		{
		 "left":obsRoomLeft,
		 "top":obsRoomTop,
		 "width":200,
		 "height":obsRoomHeight,
		
		}
	)
	
}	


//给床位和等候区绑定方法
function addSeatMethod(){
	$(".seat").each(function(){
		$(this).on('click',function(){
			if(($(this).attr("data-make")==="Y")){  //包床不能操作
				return ;   	
			}
			///判断由等候区安排到床上
			var SelData = $("#obsPatTable").datagrid("getSelections");  //加载面板
			var DisSelData = $("#disHospTable").datagrid("getSelections");  //加载面板
			if(($(this).attr("data-adm")!=="")&&(SelData.length||DisSelData.length)){   //选中等候区病人再选中床位上病人
				checkOrUnCheckAll();
				checkOrUnCheckSeat($(this));
				return;
			}
			if(SelData.length){
				var Adm = SelData[0].AdmID;
				if(Adm===""){
					$.messager.alert("提示","病人当前就诊为空！");
					return;
				}
				globleParam.planModel = "P"; 
				selSeatPat.planSeatID = $(this).attr("data-id");
				loadPlanPatWin(Adm);
				return;                    //这个return能在弹出window阻止接下来的seat选中效果
			}
			
			///判断由一个床安排到另外一个床上
			if((selSeatPat.adm!="")&&($(this).attr("data-adm")==="")){
				globleParam.planModel = "U";  
				selSeatPat.planSeatID = $(this).attr("data-id");  
				loadPlanPatWin(selSeatPat.adm);
				return;                    //这个return能在弹出window阻止接下来的seat选中效果
			}
			
			if(($(this).attr("data-adm")==="")){   //无人床不能选中
				return ;
			}	
			//下面设置选中css以及对床位指针赋值
			checkOrUnCheckSeat($(this));
		}).bind("contextmenu", function(e){
			/// 增加右键菜单 2019-02-21 bianshuai
			e.preventDefault(); //阻止浏览器捕获右键事件
			
			if(!validIsCheckPat()){
				if(ThisBedDataId){
					$(".seat[data-id='"+ThisBedDataId+"']").click();
				}else{
					$.messager.alert("提示","未选中任何留观室病人！");
					return;
				}
			}else{
				if($(".seat[data-id='"+ThisBedDataId+"']").attr("data-adm")){
					if(!$(".seat[data-id='"+ThisBedDataId+"']").find(".seatcontent").hasClass("active")){
						$(".seat[data-id='"+ThisBedDataId+"']").click();
					}
				}else{
					return;	
				}	
			}
			disableMenuItm("");
			$HUI.menu('#menu').show({ 
	           //显示右键菜单  
	           left: e.pageX,//在鼠标点击处显示菜单  
	           top: e.pageY  
			});
		});
		
		
		$(this).on({
			mouseover : function(){
				if(!$(this).attr("data-adm")){
					return;	
				}
				$(this).find(".sickbedOpPanel").show();
				ThisBedDataId=$(this).attr("data-id");
			} ,
			mouseout : function(){
				if(!$(this).attr("data-adm")){
					return;	
				}
				$(this).find(".sickbedOpPanel").hide();
				ThisBedDataId="";
			} 
		}) ;
		
	})

}

function addObsAreaMethod(){
	$("#obsKeptArea").on("click",function (){
		if(selSeatPat.adm!==""){
			globleParam.planModel = "C";  
			loadPlanPatWin(selSeatPat.adm);
			return ;
		}
	})
}

function loadPlanPatWin(Adm){
	if(validPatIsDeath(Adm)==1){
		$.messager.alert("提示","注意,患者已故！","info",function(){
			loadPlanPatInfoWin(Adm);
		});	
	}else{
		loadPlanPatInfoWin(Adm);
	}
}

function loadPlanPatInfoWin(Adm){
	//加载安排座位的win
	clearDate();
	$HUI.window("#planPatWin").open();
	runClassMethod("web.DHCEMObsRoomSeat","GetPlanPatJsonData",{"Adm":Adm},function(data){
		$HUI.datebox("#planWinPat-StDate").setValue(curDate);
		$HUI.timespinner("#planWinPat-StTime").setValue(curTime);
		$("#planPatTable-Name").val(data.PatName);
		$("#planWinPat-RegNo").val(data.PatNo);
		$("#planPatTable-Sex").val(data.PatSex);
		$("#planWinPat-WardDesc").val(data.WardDesc);
		$("#planPatTable-Loc").val(data.QueDepDesc);
		$("#planPatTable-Balance").val(data.Deposit);
		initCombogrid(data);   //在打开window时候加载数据 
		$("#planPatTable-UserId").val(UserCode);
	},'json');
}

function validPatIsDeath(Adm){
	var patIsDeath="";
	runClassMethod("web.DHCEMNurExecImg","GetPatIsDeath",
		{"EpisodeID":Adm
		},function(ret){
			patIsDeath = ret ;
		},'text',false)
	return patIsDeath;
}

function clearDate(){
	$HUI.datebox("#planWinPat-StDate").setValue(curDate);
	$HUI.timespinner("#planWinPat-StTime").setValue("");
	$("#planPatTable-Name").val("");
	$("#planWinPat-RegNo").val("");
	$("#planPatTable-Sex").val("");
	$("#planWinPat-WardDesc").val("");
	$("#planPatTable-Loc").val("");
	$("#planPatTable-Balance").val("");
	
	$("#planPatTable-UserId").val("");
	$("#planPatTable-UserPas").val("");
	return;
}

function clearPlanWin(){
	$("#planWinPat-StDate").datebox("setValue","");
	$('#planWinPat-StTime').timespinner('setValue',"");
	$("#planWinPat-Name").html("");
	$("#planWinPat-RegNo").html("");
	$("#planWinPat-Sex").html("");
	$("#planWinPat-WardDesc").val("");
	$("#planPatTable-Loc").val("");
	$("#planWinPat-deposit").html("");
	$('#planWinPat-SeatNo').combogrid('setValue',"");	
	$("#planPatTable-Doc").combogrid("setValue","");
	$("#planPatTable-Nur1").combogrid("setValue","");
	$("#planPatTable-Nur2").combogrid("setValue","");
	$("#planPatTable-UserId").val("");	
}

/// 初始化病人历史就诊记录
function initCombogrid(data){
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListUnPatBed&WardId="+curWrad.wardId;

	///  定义columns
	var columns=[[
		{field:'BedID',title:'床位ID',width:50},
		{field:'BedCode',title:'床号',width:70},
		{field:'WardDesc',title:'病区',width:150},
		{field:'WardRoomDesc',title:'房间名称',width:150},
		{field:'BedType',title:'床位类型',width:150}
		//{field:'unavailReason',title:'不可用原因'},
		//{field:'unavailStDate',title:'开始日期'},
		//{field:'unavailStTime',title:'开始时间'},
		//{field:'unavailEndDate',title:'结束日期'},
		//{field:'unavailEndTime',title:'结束时间'}
	]];
	
	$('#planWinPat-SeatNo').combogrid({
		url:url,    
	    panelWidth:550,
	    mode: 'remote',
	    idField:'BedID',
	    textField:'BedCode',
	    blurValidValue:true,
	    columns:columns,
	    pagination:false,
        onSelect: function (rowIndex, rowData) {
	        
        },
        onLoadSuccess:function(data){
	        if(globleParam.planModel === "UP"){   //UP:转移按钮
		        if(data.rows.length){
			    	$('#planWinPat-SeatNo').combogrid("setValue",data.rows[0].BedID)
			    }
	        }  
	    }
	});
	
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetPNurList&DepRowId="+CurLocID;

	///  定义columns
	var columns=[[
		{field:'NurId',title:'NurID',width:100},
		{field:'NurDesc',title:'用户',width:130}
	]];
	
	$('#planPatTable-Nur1').combogrid({
		url:url,    
	    panelWidth:250,
	    mode: 'remote',
	    idField:'NurId',
	    textField:'NurDesc',
	    //blurValidValue:true,
	    columns:columns,
	    pagination:false,
        onSelect: function (rowIndex, rowData) {
	        
        }
	});
	
	$('#planPatTable-Nur2').combogrid({
		url:url,    
	    panelWidth:250,
	    mode: 'remote',
	    idField:'NurId',
	    textField:'NurDesc',
	    //blurValidValue:true,
	    columns:columns,
	    pagination:false,
        onSelect: function (rowIndex, rowData) {
	        
        }
	});

	if(globleParam.planModel === "C"){
		$('#planWinPat-SeatNo').combogrid('setValue',$g("等候区"));
		$("#planWinPat-SeatNo").combogrid("disable");
	}else if (globleParam.planModel === "M"){
		$('#planWinPat-SeatNo').combogrid('setValue',selMovePat.seatID);	
	}else if(globleParam.planModel === "UP"){
			
	}else{
		$('#planWinPat-SeatNo').combogrid('setValue',selSeatPat.planSeatID);
	}
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListDocInfo&LocDr="+CurLocID;
	
	///  定义columns
	var columns=[[
		{field:'CtPcpName',title:'医生姓名',width:100},
		{field:'CtPcpCode',title:'医生Code',width:150},
		{field:'CtCarPrvTp',title:'职称',width:150}
	]];
		
	$("#planPatTable-Doc").combogrid({
		panelWidth: 400,
		idField: 'CtPcpName',
		textField: 'CtPcpName',
		mode: 'remote',
		blurValidValue:true,
		url: url,
		method: 'get',
		columns: columns
	})
	
	
	if(data.MainNurID=="0") data.MainNurID="";
	if(data.MainNurID2=="0") data.MainNurID2="";
	//$("#planPatTable-Doc").combogrid("setValue",data.AdmInfo.QueDocCode);
	$("#planPatTable-Doc").combogrid("setValue",data.QueDocDesc);
	$("#planPatTable-Nur1").combogrid("setValue",data.MainNurID);
	$("#planPatTable-Nur2").combogrid("setValue",data.MainNurID2);
}

///增加床位
function addSeat(data){
	statPatNum(data);
	bedIsStop(data.BedTipMessage);
	seatWith = data.BEDPositionWidth;     	//床宽
	seatHeight= data.BEDPositionHeight;		//床高
	var seatContWith=parseInt(seatWith)-4; 
	var seatContHeight=parseInt(seatHeight)-4;
	var seatBorderWith=parseInt(seatWith)+100; 
	var seatBorderHeight=parseInt(seatHeight)+100;
	var seatTop = data.BEDPositionTop;			//TOP值
	var seatLeft = data.BEDPositionLeft;		//LEFT值
	var seatID = data.BedID;					//床ID
	var seatTitleHeight=33;						//Title高度
	var sestTitleFontSize=12;					//Title字体大小
	var seatTitleColor="#000"				    //界面title的颜色
	var seatTitleHtml="" ;                      //床位Title的Html
	var seatBodyHeight = seatHeight-20;			//Body高度
	var seatBodyNameHeight = "";				//姓名高度
	var seatBodyIconHeight =""; //图标高度
	//var curWardName= $("#obsLocTabs").dhccTabs("getSelectTab").attr("title");  //当前病区名字
	var curWardName= curWrad.wardDesc;
	var seatName = data.BEDCode;				//床名字
	var patInfoHtmlText = getTableHtml(data.PatInfo,seatWith)    //显示病人信息
	var hasPatFlag = Object.keys(data.PatInfo).length===0?false:true; //有人标志
	var patSex=hasPatFlag===true?data.PatInfo.PatSex:"";
	var drop="";
	var seadDrop="";
	var seatColor ="#FFF"; 							//界面床的颜色
	var isMakeFlag="";							//包床标志
	var patAdm ="" ; 							//绑定床位Adm
    var seatTitleBgColor="rgb(147, 112, 219)"              //界面title的背景色 hxy 2018-04-25
	var patObsDateColor="#000";				    //留观时间字体颜色
	var setImgUrl="";
	var sexcontent="";
	if (hasPatFlag) {
		seadDrop="seatOnDrag"
		drop = "";
		//seatColor = patSex==="男"?"#8EDBFF":"#FAC8D4";
		if((patSex===$g("男"))||(data.PatInfo.ChPatSex=="男")){
			if(HISUIStyleCode==="lite"){
				setImgUrl = "../images/man_lite.png";
			}else{
				setImgUrl = "../images/man.png";
			}
			sexcontent="mancontent"	;
		}else if((patSex===$g("女"))||(data.PatInfo.ChPatSex=="女")){
			if(HISUIStyleCode==="lite"){
				setImgUrl = "../images/woman_lite.png";
			}else{
				setImgUrl = "../images/woman.png";
			}
			sexcontent="womancontent"	;
		}else{
			if(HISUIStyleCode==="lite"){
				setImgUrl = "../images/unman_lite.png";
			}else{
				setImgUrl = "../images/unman.png";
			}
			sexcontent="unmancontent";
		}
	}
	if (!hasPatFlag) {
		drop = "onDroppable";
		seadDrop="";
		
	}
	if(data.BEDStatus.statusCode==="U"){   		//包床
		data.PatInfo.PatName =data.PatInfo.PatName+$g("包床");
		isMakeFlag="Y";			
	}else{
		isMakeFlag="N" ;                       //包床标志  				
	}
	
	if(Object.keys(data.PatInfo).length){
		patAdm = data.PatInfo.PaAdm;
	}
	
	var PatNameHtml="",IconHtml="";
	if(hasPatFlag){    
		//病人姓名的html 
		PatNameHtml = PatNameHtml+'<span>';
		PatNameHtml = PatNameHtml+	'<span>'+data.PatInfo.PatName+'</span>';
		PatNameHtml = PatNameHtml+'</span>';
	}
	
	
	var patName = data.PatInfo.PatName==undefined?"":data.PatInfo.PatName;
	var PatObsDate = data.PatInfo.PatObsDate==undefined?"":data.PatInfo.PatObsDate;
	var PatCareLevel = data.PatInfo.CareLevel==undefined?"":data.PatInfo.CareLevel;
	//var titleName = patName.length>3?patName.substring(0,3)+"..":patName;
	var titleName = patName;
	var nurseLevel=(data.PatInfo.NurseLevel||"");
	var isHasSyOrd=(data.PatInfo.IsHasSyOrd||"");
	if(nurseLevel){
		if(nurseLevel==1) seatTitleBgColor=	"red";
		if(nurseLevel==2) seatTitleBgColor=	"orange";
		if(nurseLevel==3) seatTitleBgColor=	"#d0d018";
		if(nurseLevel==4) seatTitleBgColor=	"#66d466";
		if(nurseLevel==5) seatTitleBgColor=	"#66d466";
	}
	
	if(hasPatFlag){
		if(data.BEDStatus.statusCode==="U") IconHtml = "";
		if(data.BEDStatus.statusCode!=="U") IconHtml = data.IconHtmlText
		if(isMakeFlag==="Y") IconHtml="<A HREF=\"#\"><IMG align='top' SRC='../images/webemr/inactivelarge.gif' title='包床' border=0></A>"+patName;  //包床标志
		if(isMakeFlag==="Y") patName="",PatObsDate="";
	}
	
	seatTitleHtml = 			  ""
	seatTitleHtml = seatTitleHtml+	"<span class='saatName' style='font-weight: 700;color:"+seatTitleBgColor+"'>"+seatName+"</span>"
	seatTitleHtml = seatTitleHtml+	"<span class='patName disBlock'>"+titleName+"&nbsp;</span>"
	seatTitleHtml = seatTitleHtml+	"<span class='obsDate disBlock'>"+PatObsDate+"</span>"
	
	var htmlStr = 		   "<div class='seat "+drop+" "+(isHasSyOrd?"hasSyOrd":"")+"' data-id='"+seatID+"' data-adm='"+patAdm+"' data-make='"+isMakeFlag+"' style='position:absolute;width:"+seatWith+";height:"+seatHeight+";top:"+seatTop+";left:"+seatLeft+"'>"
	var htmlStr = htmlStr+		"<div class='seatcontent "+sexcontent+"' style='position:relative;'>" //seatColor hxy 2018-04-25
	var htmlStr = htmlStr+			"<div class='seatSelectBorder' style='width:"+seatBorderWith+"px;height:"+seatBorderHeight+"px;'></div>"
	var htmlStr = htmlStr+			"<div class='sickbedOpPanel'>";
	var htmlStr = htmlStr+			"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/check_reg.png' onclick='smalOpClick(\"ly\")'/>";
	var htmlStr = htmlStr+			"<div style='height:5px;'></div>";
	var htmlStr = htmlStr+			"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/print.png' onclick='smalOpClick(\"wd\")'/>";
	var htmlStr = htmlStr+			"<div style='height:5px;'></div>";
	var htmlStr = htmlStr+			"<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/change_loc.png'/ onclick='smalOpClick(\"zy\")'><br/>";
	var htmlStr = htmlStr+			"</div>";
	var htmlStr = htmlStr+			"<div class='bedBody "+sexcontent+"' style='width:"+seatContWith+"px;height:"+seatContHeight+"px;position: absolute;top:2px;left:2px;z-index:1;'>"
	var htmlStr = htmlStr+				"<div class='seattitle "+seadDrop+"' style='color:"+seatTitleColor+";height:"+seatTitleHeight+";font-size:"+sestTitleFontSize+";line-height:"+seatTitleHeight+"px'>"+seatTitleHtml+"</div>"
	var htmlStr = htmlStr+				"<div class='seatbody' style='width:100%'>"
	var htmlStr = htmlStr+					"<div class='seatbodyname' style='height:"+seatBodyNameHeight+"'>";
	var htmlStr = htmlStr+						"<IMG class='seatSexImg' align='top' SRC='"+setImgUrl+"' title='' border=0/>";
	var htmlStr = htmlStr+						patInfoHtmlText;
	var htmlStr = htmlStr+					"</div>"   //姓名部分
	var htmlStr = htmlStr+					"<div class='seatbodyicon' style='height:"+seatBodyIconHeight+"' seatID='"+seatID+"'>";
	var htmlStr = htmlStr+						IconHtml
	var htmlStr = htmlStr+					"</div>"          //图标部分
	var htmlStr = htmlStr+				"</div>"
	var htmlStr = htmlStr+			"</div>"
	var htmlStr = htmlStr+		"</div>"
	var htmlStr = htmlStr+"</div>";
	//console.log(data.PatInfo.MRDiagnos.replace(",","222"));
	//alert(data.PatInfo.MRDiagnos==undefined?"":data.PatInfo.MRDiagnos.replace(",","<br>"));
	$(".obsseat").append($(htmlStr));
	
	var tooltipPos="bottom";
	//parseInt(seatLeft)<50?tooltipPos="right":"";
	lastRowY>parseInt(seatTop)?"":tooltipPos="top";
	//lastRowY>parseInt(seatTop)?tooltipPos="bottom":tooltipPos="top";
	
	if(data.PatInfo.PaAdm!=undefined){
		if(isMakeFlag=="Y") return;
		$(".seat[data-id='"+seatID+"']").tooltip({
			position: tooltipPos,
			trackMouse:true,
		    content:'<div style="width:250px;">' +
		    			'<div>'+$g('登记号')+'：'+data.PatInfo.PatNo+'</div>' +
		    			'<div class="tool-bar-line" style="margin-top:3px;border-bottom-color:#cccccc;border-bottom-width:1px; border-bottom-style:dashed;"></div>'+
		               	'<div>'+$g('级别')+'：'+setCell(data.PatInfo.NurseLevel)+'</div>' +
		                '<div>'+$g('类型')+'：'+data.PatInfo.PatType+'</div>' +
		                '<div>'+$g('费别')+'：'+data.PatInfo.AdmReason+'</div>' +
		                '<div>'+$g('诊断')+'：'+(data.PatInfo.MRDiagnos==undefined?"":data.PatInfo.MRDiagnos.replace(/##/g,","))+'</div>' +  //<br>
		            	'<div>'+$g('号别')+'：'+data.PatInfo.QueDepDesc+"("+data.PatInfo.AdmCare+")"+'</div>' +
		            	'<div>'+$g('入留观时间')+'：'+data.PatInfo.PatObsDateDesc+'</div>' +
		            '</div>',
		    onShow: function(){
				
		    }	
		})
	}
}

function getTableHtml(itmPatData,seatWith){
	if(itmPatData.PatNo==undefined){
		return "";
	}
	var patSex =itmPatData.PatSex
	patSex.length>1?patSex=patSex.substring(0,2):"";
	var tableWidth=parseInt(seatWith)-60+"px";
	var PatInfoHtml = "<table class='bedtable' style='table-layout:fixed;width:"+tableWidth+"'>"
	//PatInfoHtml =PatInfoHtml+"<tr><td style='white-space:nowrap;width:40px;text-align: right;'>ID:</td><td>"+itmPatData.PatNo+"</td></tr>" 
	//PatInfoHtml =PatInfoHtml+"<tr><td style='white-space:nowrap;width:40px;text-align: right;'>"+$g("姓名")+":</td><td>"+itmPatData.PatName+"</td></tr>"
	PatInfoHtml =PatInfoHtml+"<tr><td style='white-space:nowrap;width:40px;text-align: right;'>"+patSex+";</td><td>"+itmPatData.PatAge+"</td></tr>"	//sex and age
	//PatInfoHtml =PatInfoHtml+"<tr><td style='white-space:nowrap;width:40px;text-align: right;'>分级:</td><td>"+setCell(itmPatData.NurseLevel)+"</td></tr>"   //name and regNo hxy 2018-04-25 ed
	PatInfoHtml =PatInfoHtml+"<tr><td class='bedtdtext'>"+$g("费别")+":</td><td>"+itmPatData.AdmReason+"</td></tr>"
	PatInfoHtml =PatInfoHtml+"<tr><td class='bedtdtext'>"+$g("诊断")+":</td><td style='white-space:nowrap;text-overflow:ellipsis;overflow: hidden;'>"+itmPatData.MRDiagnos.split("##")[0]+"</td></tr>"
	PatInfoHtml =PatInfoHtml+"<tr><td class='bedtdtext'>"+$g("入观")+":</td><td style='white-space:nowrap;text-overflow:ellipsis;overflow: hidden;'>"+itmPatData.PatObsDateDesc.split(" ")[0]+"</td></tr>"
	PatInfoHtml =PatInfoHtml+"</table>"
	return PatInfoHtml;
}


function setCell(value){
	var thisBackColor="";
	if(value=="1"){value=$g("Ⅰ级"),thisBackColor="red";}
	if(value=="2"){value=$g("Ⅱ级"),thisBackColor="orange";}
	if(value=="3"){value=$g("Ⅲ级"),thisBackColor="#d0d018";}
	if(value=="4"){value=$g("Ⅳa级"),thisBackColor="#66d466";}
	if(value=="5"){value=$g("Ⅳb级"),thisBackColor="#66d466";}
	
	return "<span style='border-radius:5px;color:"+thisBackColor+"'>"+value+"</span>";
}

function bedIsStop(){
	if(arguments[0]!==""){
		$.messager.alert("提示",arguments[0]);	
	}	
	return;
}

function statPatNum(data){
	if(data.PatInfo.PaAdm!=undefined){
		seatNum.allSeatNum++;
		var nurseLevel=data.PatInfo.NurseLevel;
		var isHasSyOrd=data.PatInfo.IsHasSyOrd;
		if(nurseLevel==1){
			seatNum.chkLevOne++;
		}
		if(nurseLevel==2){
			seatNum.chkLevTwo++;
		}
		if(nurseLevel==3){
			seatNum.chkLevThree++;
		}
		if(nurseLevel==4){
			seatNum.chkLevFourA++;
		}
		if(nurseLevel==5){
			seatNum.chkLevFourB++;
		}
		if(isHasSyOrd=="1"){
			seatNum.hasAllOrdNum++;
		}
	}
	if(data.BEDStatus.statusCode==="U") seatNum.makeSeatNum++;
	if(data.PatInfo===""){
		if(data.BEDStatus.statusCode!=="U") seatNum.hasPatSeatNum++;
	}	
}

function initCombo(){
	var obsLocData="";
	runClassMethod("web.DHCEMObsRoomSeat","GetCurWard",{"Loc":CurLocID},function(data){
		curWrad.wardId = data[data.length-1].id;
		curWrad.wardDesc = data[data.length-1].text;
		obsLocData=data;
	},'json',false)
	
	$HUI.combobox("#obsLoc",{
		url:"",
		data:obsLocData,
		valueField:'id',
		textField:'text',
		onSelect:function(option){
			var wardId =option.id;
			curWrad.wardId = option.id;
			curWrad.wardDesc = option.text;		
			if($(".queryItmActive").length){
				$(".queryItmActive").removeClass("queryItmActive");
			}
			$("#filterValue").val("");
			reloadObsAreaAndSeat();
	    },
	    onLoadSuccess:function(data){
			$HUI.combobox("#obsLoc").setValue(curWrad.wardId);	       
		}
	})
	
	
	$HUI.combobox("#disPatWin-DischargeNote",{
		url:LINK_CSP+"?ClassName=web.DHCEMDicItem&MethodName=jsonConsItem&mCode=Discharge&HospID="+CurHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			
	    },
	    onLoadSuccess:function(data){
			      
		}
	})
	
	//主管医生
	$HUI.combobox("#ChargDoc",{
		url:$URL+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListDocInfo&LocDr="+CurLocID,
		valueField:'CtPcpId',
		textField:'CtPcpName',
		mode:'remote',
		onSelect:function(option){
			
	    }	
	})
	
	var comboData = [
		{ "id": "PatNo", "text": $g("登记号") }, 
		{ "id": "PatName", "text": $g("姓名") },
		{ "id": "PatSex", "text": $g("性别") },
		{ "id": "Diagnos", "text": $g("诊断") },
		{ "id": "AdmLoc", "text": $g("就诊科室") },
		{ "id": "Care", "text": $g("号别") }
	];
	$HUI.combobox('#filterCombo',{
		valueField:'id',
		textField:'text',
		data:comboData
	});
	$HUI.combobox('#filterCombo').setValue("PatNo");
}



///初始化tabs
function initTabs(){
	
}

//打开病人相信信息面板
function openPatInfoWin(){
	$('#patInfoWin').window('open');
	event.stopPropagation();  //防止冒泡
}


//function websys_lu(param){
//	window.open(param);
//	event.stopPropagation();
//}

///HISUI折叠面板
function initAccordion(){
	$HUI.accordion("#obsRoomAccordion",{
		selected:true,
		fit:true,
		border:false	
	})
}

var setEprMenuForm = function(adm,papmi){
/*if ((!(typeof window.parent.SetChildPatNo == "function"))&&(!(typeof window.parent.ChangePerson === "function"))) {
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}*/
	var frm=window.parent.document.forms["fEPRMENU"];	
	if((frm) &&(frm.EpisodeID)){
		frm.EpisodeID.value=adm;
	}		
}


///打印腕带
function prtStraps(){
	if(selSeatPat.adm==="") {
		//$.messager.alert("提示","患者必须安排床位后才能打印腕带！");
		return;
	}
	newProPrtWd("",selSeatPat.adm,CurHospID);
	return;
}

function showGreenRec(){
	
	var patAdm="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm==="") {
		$.messager.alert("提示","未选中患者！");
		return;
	}
	
	// var LinkUrl ='dhcem.green.rec.csp?EpisodeID='+adm
	var lnk = 'dhcem.green.rec.csp?EpisodeID='+patAdm;
	var winwidth="1200";
	if(screen.availWidth-50<winwidth){
		winwidth=screen.availWidth-50;
	}
	var iLeft = ($(window).width()-winwidth)/2; //获得窗口的水平位置;
	var iTop=($(window).height()-700)/2; //获得窗口的垂直位置;
	websys_showModal({
		url: lnk,
		width:winwidth,
		height:700,
		left:iLeft,
		top:iTop,
		iconCls:"icon-w-paper",
		title: $g('绿色通道'),
		closed: true,
		onClose:function(){
			initPatIncon(curWrad.wardId);	
		}
	});
	return;
}

function smalOpClick(type){
	event.stopPropagation();
	if(!$(".seat[data-id='"+ThisBedDataId+"']").find(".seatcontent").hasClass("active")){
		$(".seat[data-id='"+ThisBedDataId+"']").click();
	}
	if(type=="ly"){
		$("#disHosp").click();	
	}
	if(type=="wd"){
		$("#prtStraps").click();	
	}
	if(type=="zy"){
		$("#transBed").click();	
	}
	return false;
}


function qBarOp(type){
	var qBarNowValue=$(".qBarVal").text();
	var qBarChangedValue="";
	if(type==="add"){
		qBarChangedValue=parseInt(qBarNowValue)+5;
	}
	if(type==="sub"){
		qBarChangedValue=parseInt(qBarNowValue)-5;
	}
	if(type==="reset"){
		qBarChangedValue=100;
	}
	qBarChangedValue=qBarChangedValue+"%";
	$(".qBarVal").text(qBarChangedValue);
	$(".seat").css("zoom",qBarChangedValue);
}

function changeSeatView(obj){
	return;
	//var seatWith="",seatHeight="";
	if(obj.value){
		$(".seat").css({"height":"37px","transition":"height 0.2s"});
		$(".seatBody").css({"height":"33px","transition":"height 0.2s"});
		$(".seat").each(function(){
			var thisTop=parseInt($(this).css("top"));
			var changeTop=thisTop-(parseInt(seatHeight)-43);
			if(changeTop>0){
				$(this).css("top",changeTop+"px");	
			}
		})
	}else{
		
	}
	return;
}


function filterValue_KeyPress(e){
	if(e.keyCode == 13){
		$HUI.tooltip(".seat").hide();
		//$(".seat").each(function(){$(this).tooltip("hide")})
		
		if($(".queryItmActive").length){
			$(".queryItmActive").removeClass("queryItmActive");
		}
		
		var filterType=$HUI.combobox('#filterCombo').getValue();
		
		if(filterType==="PatNo"){
			var filterValue=$('#filterValue').val();
			$('#filterValue').val(GetWholePatNo(filterValue));
		}
		
		var CurWardID = curWrad.wardId ;
		loadSeat(CurWardID);
	}
}


///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

function changeBedViewPosition(obj){
	if(obj.value){
		$('.seat').each(function(){
			$(this).css("position","absolute");
			//$(this).removeCss("float");
			$(this).removeCss("margin");
		})
	}else{
		$('.seat').each(function(){
			$(this).removeCss("position");
			//$(this).removeCss("top");
			//$(this).removeCss("left");
			$(this).css({margin:"6px"});		
		})
	}
	return;
}

function clickQueryItm(_this){
	$("#filterValue").val("");
	//if(!$(_this).hasClass("queryItmActive")){ //hxy 2022-09-30 st 选了分级再选需处理==分级+需处理，未显示分级的选中样式
	if((!$(_this).hasClass("queryItmActive"))&&($(_this).attr("filterType")!="HasNoExecOrd")){ //ed
		$(".queryItm").removeClass("queryItmActive");
	}
	$(_this).toggleClass("queryItmActive");
	
	///速度太慢走前台
	if($(".queryItmActive").length){
		//if($(".queryItmActive:eq(1)").attr("filterType")=="HasNoExecOrd"){ //hxy 2022-09-30 st
		if(($(".queryItmActive:eq(0)").attr("filterType")=="HasNoExecOrd")||($(".queryItmActive:eq(1)").attr("filterType")=="HasNoExecOrd")){ //ed
			$(".seat").not(".hasSyOrd").hide();
			return;
		}
	}
	
	
	var CurWardID = curWrad.wardId ;
	loadSeat(CurWardID);
}

function ChargeDoc(){
	$HUI.window("#DocWin").open();	
	loadGetPrvDoc()
}

/// 主管医生
function loadGetPrvDoc(){
	var EpisodeID="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		EpisodeID = selPatData[0].AdmID;
	}else{
		EpisodeID = selSeatPat.adm;
	}
	
	if(EpisodeID===""){
		$.messager.alert("提示","未选患者！");	
		return;
	}
	$HUI.combobox("#ChargDoc").setValue("");
	$("#nowChargDocid").val("");
	$("#nowChargDoc").html("");
	runClassMethod("web.DHCEMObsRoomSeat","GetPrvDoc",{"EpisodeID": EpisodeID},function(retData){
		$("#nowChargDocid").val(retData.split("^")[0]);
		$("#nowChargDoc").html(retData.split("^")[1]);
		$('#ChargDoc').combobox('reload',$URL+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListDocInfo&LocDr="+retData.split("^")[2]);  
	},"text")
}

function  DoCancel(){
	$HUI.window("#DocWin").close();
	
}

/// 指定主管医生 yangyongtao 2019-04-19
function  DocSure(){
	var EpisodeID="";
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //加载面板

	if(selPatData.length){
		EpisodeID = selPatData[0].AdmID;
	}else{
		EpisodeID = selSeatPat.adm;
	}
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
	var nowChargDocid=$("#nowChargDocid").val();
	var ChargDoc = $HUI.combobox("#ChargDoc").getValue();
	ChargDoc?"":ChargDoc="";
	if((nowChargDocid!="")&&(ChargDoc!="")&&(nowChargDocid==ChargDoc)){
		$.messager.alert("提示:","指定主管医生重复，请重新选择主管医生！","warning");
		return;
	}
	runClassMethod("web.DHCEMObsRoomSeat","UpdPrvDoc",{'EpisodeID':EpisodeID,'ChargDoc':ChargDoc},
  	function(data){
    	if(data=="0"){ 
        	$.messager.alert("提示:","修改成功！","success");
        	$HUI.window("#DocWin").close();
    	}
   	},"text");
}

///扩展功能，针对jq提供删除某个css元素的功能
$.fn.removeCss=function(toDelete) {
	var props = $(this).attr('style').split(';');
	var tmp = -1;
	for( var p=0; p<props.length; p++) {
		if(props[p].indexOf(toDelete)!== -1 ) {
		    tmp=p
		}
	}
	if(tmp !== -1) {
        props.splice(tmp,1);
    }
    
	return $(this).attr('style',props.join(';'));
}

/// 设置病人信息到框架中  hos   bianshuai  2022-11-10
function setPanelPatInfo(EpisodeID, PatientID){

    if(HOSOPEN){
	    if(window.opener){
		   var nowUrl = window.opener.location.href;
		   window.opener.location.href = changeURLArgs(nowUrl,{EpisodeID:EpisodeID,PatientID:PatientID});
		}
		window.close();
	}
}

/// 病历查看:超融合
function LoadMoreScr(){

	var Obj={
		EpisodeID:selSeatPat.adm
	}
	
	websys_emit("onObsRoomSeat",Obj);
}


/// 
function LoadLoginScr(){

	var Obj={
		
	}
	
	//websys_emit("onHISLogonSuccess",Obj);
}




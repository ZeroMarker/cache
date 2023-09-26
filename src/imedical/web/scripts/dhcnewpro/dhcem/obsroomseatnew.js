///creator:qqa
///creatDate:2017-10-24
var IsInitTable=false;
$(function(){
	initParam();
	
	initSet();
	
	initTabs();
	
	initCombo();
	
	initSeat();
	
	initMethod();

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

function initParam(){
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
	$(".planPat-Btn:contains('安排')").on('click',planOrClearPat);   //安排按钮
	$(".planPat-Btn:contains('取消')").on('click',closeWindow);   //安排按钮
	$(".dis-Btn:contains('更新')").on('click',disHospPat);
	$(".cancel-Btn:contains('更新')").on('click',cancelAccPat);
	
	$(".opbtn-makeSeatBtn").on('click',makeSeat);
	$(".opbtn-upSeatBtn").on('click',upSeatWin);
	$(".opbtn-cancelAcc").on('click',cancelAcc);
	$("#disHosp").on('click',disHospWin);/*hxy 2018-07-02*/
	$("#upObsBtn").on('click',planPatToObs);/*hxy 2018-07-02*/
	$("#prtStraps").on('click',prtStraps);
	$("#transBed").on('click',transtBed);
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
	
	var retInfo=serverCall("web.DHCEMPatChange","GetAbnormalOrder",{'EpisodeID':patAdm});
	if(retInfo!=0){
		isControl=retInfo.split(",")[0];
		abnOrdInfo=retInfo.substring(2,retInfo.length);
	}
	if(abnOrdInfo!=""){
		if(isControl!=0){
			$.messager.alert("提示:","请先处理需关注医嘱！需关注医嘱信息:"+abnOrdInfo,"info",function(){
				websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+patAdm+"&defaultTypeCode=D","","width='"+window.screen.availHeight-100+"' height='"+window.screen.availWidth-100+"'");
			});
			return;
		}
	}
	
	
	if((isControl==0)&&(abnOrdInfo!="")){			///需关注医嘱未配置管控，只提示。
		$.messager.confirm('提示', '存在需处理医嘱，是否确定离院操作?', function(result){  
        	if(result) {
	        	openDisWin(patAdm,curDate,curTime);
	        }
	    })
	}else{
		openDisWin(patAdm,curDate,curTime);
	}
	
}

function openDisWin(patAdm,curDate,curTime){
	$("#disPatWin").window("open");
	$("#disPatWin-disPatAdm").val(patAdm);
	$("#disPatWin-disStDate").datebox("setValue",curDate);
	$('#disPatWin-disStTime').timespinner('setValue',curTime);
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
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: '留观患者床位转移',
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
		$.messager.alert("提示","未选中床位图病人！");
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
		url:LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetCurWardObsPat&WardDr="+CurWardDr,
		fit:true,
		height:'150px',
		rownumbers:false,
		columns:columns,
		pageSize:5,
		pageList:[5,10,15],
	    singleSelect:true,
		loadMsg: '正在加载信息...',
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
	    	return true;
	    	/// 增加右键菜单 2019-02-21 bianshuai
			e.preventDefault(); //阻止浏览器捕获右键事件
				
			if(!validIsCheckPat()){
				$.messager.alert("提示","未选中任何留观室病人！");
				return;
			}
			
			$HUI.menu('#menu').show({ 
	           //显示右键菜单  
	           left: e.pageX,//在鼠标点击处显示菜单  
	           top: e.pageY  
			});
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
		loadMsg: '正在加载信息...',
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
			$(this).find(".seatcontent").css({"border":"3px solid #6b6fc7"});
		},
		onDragLeave: function(e,source){
			$(this).find(".seatcontent").css({"border":"1px solid #ccc"});
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
	}else{
		selSeatPat.seatID ="";
		selSeatPat.adm =""; 
		setEprMenuForm("","");  
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
	runClassMethod("web.DHCEMObsRoomSeat","GetWardIconInfo",{"WardID":CurWardID},function(data){
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

	if(PatInconData==""){
		if(seatTimeCount<10){
			setTimeout("showSeatIcon()",500);
			seatTimeCount++;
			return;
		}else{
			seatTimeCount=0;	
		}
		
	}
		
	for (var i=0;i<PatInconData.length;i++){
		var itm = PatInconData[i];
		var seatID = itm.SeatID;
		var iconHtmlText = itm.IconHtmlText;
		$(".seatbodyicon[seatID='"+seatID+"']").html(iconHtmlText);
	}
}

function showCurWardPatNum(){
	$(".online").html("病区床数:"+seatNum.allSeatNum);
	$(".unline").html("安排人数:"+seatNum.hasPatSeatNum);
	$(".makeseat").html("包床人数:"+seatNum.makeSeatNum);	
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
	var htmlstr =  	    '<div class="celllabel '+dragClass+'" title="'+tooltipStr+'" class="hisui-tooltip" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.AdmID+'">'
	var htmlstr = htmlstr+'<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">';
	var htmlstr = htmlstr+rowData.PatName;
	//var htmlstr = htmlstr+'</span><span class="l-btn-icon icon-readothercard">&nbsp;</span></span>';
	if(rowData.PatSex=="男"){//hxy
		var htmlstr = htmlstr+'</span><span class="l-btn-icon pat_man">&nbsp;</span></span>';
	}else if(rowData.PatSex=="女"){
		var htmlstr = htmlstr+'</span><span class="l-btn-icon pat_woman">&nbsp;</span></span>';
	}else{
		var htmlstr = htmlstr+'</span><span class="l-btn-icon pat_noman">&nbsp;</span></span>';	
	}
	htmlstr = htmlstr +'</div>';
	return htmlstr;
}

function clearAllSeat(){
	$(".obsseat").empty();
	seatNum.allSeatNum=0;
	seatNum.makeSeatNum=0;
	seatNum.hasPatSeatNum=0;
	seatPointer=0;
}
function addAllSeat(CurWardID){
	loadingShowOrHide("show");
	
	runClassMethod("web.DHCEMObsRoomSeat","GetWardSeatInfo",{"WardID":CurWardID},function(data){
		
		
		setLastRowY(data.SeatData);
		
		//初始化床铺
		for(i=0;i<data.SeatData.length;i++){
			addSeat(data.SeatData[i]);	
		}
		
		addObsRoom(data.ObsRoomData); //初始化等候区
		InitLocNum(data.Pid);	
		showCurWardPatNum();
		addSeatMethod();      		//床位点击方法
		initPatIncon(CurWardID); 	//初始化图标数据	
		initAccordion();
		initTable();
		loadingShowOrHide("hide");
	},'json',true)		
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

function InitLocNum(SumPid){
	
	SumPid=SumPid;    //Pid
	runClassMethod("web.DHCEMObsRoomSeat","GetLocBySeatNum",{"pid":SumPid},function(data){
		var jsonObjArr = data;
		var htmlstr="";
		htmlstr="<span style='font-weight:bold;font-size:15px!important;'>在床情况:</span>";
		var ToalNum=0; //
		for (var i=0; i<jsonObjArr.length; i++){
			if(htmlstr==""){
				htmlstr="<span style='font-weight:bold;font-size:15px!important;'>"+jsonObjArr[i].LocDesc+"："+"</span>"+"<span style='font-size:12px!important;font-weight:bold;'>"+jsonObjArr[i].Num+"人"+"</span>";	
			}else{
				if(jsonObjArr[i].LocDesc.indexOf("72小时")>-1){
					htmlstr=htmlstr+"<br>"+"<span style='font-weight:bold;font-size:15px!important;'>"+jsonObjArr[i].LocDesc+"："+"</span>"+"<span style='font-size:13px!important;font-weight:bold;'>"+jsonObjArr[i].Num+"人"+"</span>";				
				}else{
					htmlstr=htmlstr+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<span style='font-weight:bold;font-size:15px!important;'>"+jsonObjArr[i].LocDesc+"："+"</span>"+"<span style='font-size:13px!important;font-weight:bold;'>"+jsonObjArr[i].Num+"人"+"</span>";		
				}
			}
			//计算
			if(jsonObjArr[i].LocDesc.indexOf("72小时")<0){
				if(ToalNum==0){
				   ToalNum=parseInt(jsonObjArr[i].Num);
				}else{
				   ToalNum=	parseInt(ToalNum)+parseInt(jsonObjArr[i].Num);
				}
			}
		}
		
		$("#LocAdmNum").html(htmlstr+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<span style='font-weight:bold;font-size:18px!important;'>在床总人数：</span>"+"<span style='font-weight:bold;font-size:15px!important;'>"+ToalNum+"人"+"</span>");
	},'json',false)
		
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
			return true;
			/// 增加右键菜单 2019-02-21 bianshuai
			e.preventDefault(); //阻止浏览器捕获右键事件
			if(!validIsCheckPat()){
				$.messager.alert("提示","未选中任何留观室病人！");
				return;
			}
			$HUI.menu('#menu').show({ 
	           //显示右键菜单  
	           left: e.pageX,//在鼠标点击处显示菜单  
	           top: e.pageY  
			});
		});
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
	runClassMethod("web.DHCEMObsRoomSeat","GetPlanPatInfo",{"Adm":Adm},function(data){
		$HUI.datebox("#planWinPat-StDate").setValue(curDate);
		$HUI.timespinner("#planWinPat-StTime").setValue(curTime);
		$("#planPatTable-Name").val(data.PatInfo.PatName);
		$("#planWinPat-RegNo").val(data.PatInfo.PatNo);
		$("#planPatTable-Sex").val(data.PatInfo.PatSex);
		$("#planWinPat-WardDesc").val(data.AdmInfo.WardDesc);
		$("#planPatTable-Loc").val(data.AdmInfo.QueDepDesc);
		$("#planPatTable-Balance").val(data.AdmInfo.Deposit);
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
		$('#planWinPat-SeatNo').combogrid('setValue',"等候区");
		$("#planWinPat-SeatNo").combogrid("disable");
	}else if (globleParam.planModel === "M"){
		$('#planWinPat-SeatNo').combogrid('setValue',selMovePat.seatID);	
	}else if(globleParam.planModel === "UP"){
			
	}else{
		$('#planWinPat-SeatNo').combogrid('setValue',selSeatPat.planSeatID);
	}
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListDocInfo&LocDr="+data.AdmInfo.QueDepDr;
	
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
	
	
	if(data.AdmInfo.MainNurID=="0") data.AdmInfo.MainNurID="";
	if(data.AdmInfo.MainNurID2=="0") data.AdmInfo.MainNurID2="";
	//$("#planPatTable-Doc").combogrid("setValue",data.AdmInfo.QueDocCode);
	$("#planPatTable-Doc").combogrid("setValue",data.AdmInfo.QueDocDesc);
	$("#planPatTable-Nur1").combogrid("setValue",data.AdmInfo.MainNurID);
	$("#planPatTable-Nur2").combogrid("setValue",data.AdmInfo.MainNurID2);
}

///增加床位
function addSeat(data){
	statPatNum(data);
	bedIsStop(data.BedTipMessage);
	var seatWith = data.BEDPositionWidth;     	//床宽
	var seatHeight= data.BEDPositionHeight;		//床高
	var seatTop = data.BEDPositionTop;			//TOP值
	var seatLeft = data.BEDPositionLeft;		//LEFT值
	var seatID = data.BedID;					//床ID
	var seatTitleHeight=35;						//Title高度
	var sestTitleFontSize=12;					//Title字体大小
	var seatTitleColor="#000"				    //界面title的颜色
	var seatTitleHtml="" ;                      //床位Title的Html
	var seatBodyHeight = seatHeight-20;			//Body高度
	var seatBodyNameHeight = "";				//姓名高度
	var seatBodyIconHeight =""; //图标高度
	//var curWardName= $("#obsLocTabs").dhccTabs("getSelectTab").attr("title");  //当前病区名字
	var curWardName= curWrad.wardDesc;
	var seatName = data.BEDCode;				//床名字
	var patInfoHtmlText = data.PatInfoHtmlText     //显示病人信息
	var hasPatFlag = data.PatInfo===""?false:true; //有人标志
	var patSex=hasPatFlag===true?data.PatInfo.PatSex:"";
	var drop="";
	var seadDrop="";
	var seatColor ="#FFF"; 							//界面床的颜色
	var isMakeFlag="";							//包床标志
	var patAdm ="" ; 							//绑定床位Adm
    var seatTitleBgColor=""              //界面title的背景色 hxy 2018-04-25
	var patObsDateColor="#000";				    //留观时间字体颜色
	var setImgUrl="";
	if (hasPatFlag) {
		seadDrop="seatOnDrag"
		drop = "";
		//seatColor = patSex==="男"?"#8EDBFF":"#FAC8D4";
		if(patSex==="男"){
			setImgUrl = "../images/man.png";	
		}else if(patSex==="女"){
			setImgUrl = "../images/woman.png";
		}else{
			setImgUrl = "../images/unman.png";	
		}
	}
	if (!hasPatFlag) {
		drop = "onDroppable";
		seadDrop="";
		
	}
	if(data.BEDStatus.statusCode==="U"){   		//包床
		data.PatInfo.PatName =data.PatInfo.PatName+"包床";
		seatTitleBgColor="#BBBBBB"  //hxy 2018-04-25
		isMakeFlag="Y";			
	}else{
		isMakeFlag="N" ;                       //包床标志  				
	}
	
	if(data.PatInfo!==""){
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
	var titleName = patName.length>3?patName.substring(0,3)+"..":patName;
	if (PatCareLevel == "特级"){
		seatTitleBgColor="#F0F0F0";
		patObsDateColor="#fff";
		seatTitleColor="#fff";
	}
	if (PatCareLevel == "一级"){
		seatTitleBgColor="#F0F0F0";
	}
	if (PatCareLevel == "二级"){seatTitleBgColor="#FFB746";}
	if (PatCareLevel == "三级"){seatTitleBgColor="#2AB66A";}
	
	if(hasPatFlag){
		if(data.BEDStatus.statusCode==="U") IconHtml = "";
		if(data.BEDStatus.statusCode!=="U") IconHtml = data.IconHtmlText
		if(isMakeFlag==="Y") IconHtml="<A HREF=\"#\"><IMG align='top' SRC='../images/webemr/inactivelarge.gif' title='包床' border=0></A>"+patName;  //包床标志
		if(isMakeFlag==="Y") patName="",PatObsDate="";
	}
	
	seatTitleHtml = 			  ""
	seatTitleHtml = seatTitleHtml+	"<span class='saatName' style='background:"+seatTitleBgColor+"'>"+seatName+"</span>"
	seatTitleHtml = seatTitleHtml+	"<span class='patName disBlock'>"+titleName+"</span>"
	seatTitleHtml = seatTitleHtml+	"<span class='obsDate disBlock'>"+PatObsDate+"</span>"
	
	var htmlStr = 		   "<div class='seat "+drop+"' data-id='"+seatID+"' data-adm='"+patAdm+"' data-make='"+isMakeFlag+"' style='width:"+seatWith+";height:"+seatHeight+";top:"+seatTop+";left:"+seatLeft+"'>"
	var htmlStr = htmlStr+		"<div class='seatcontent' style='background:"+seatColor+"'>" //seatColor hxy 2018-04-25
	var htmlStr = htmlStr+			"<div class='seattitle "+seadDrop+"' style='color:"+seatTitleColor+";height:"+seatTitleHeight+";font-size:"+sestTitleFontSize+";line-height:"+seatTitleHeight+"px'>"+"&nbsp;"+seatTitleHtml+"</div>" //hxy 2018-04-25
	var htmlStr = htmlStr+			"<div class='seatbody' style='width:100%'>"
	var htmlStr = htmlStr+				"<div class='seatbodyname' style='height:"+seatBodyNameHeight+"'>";
	var htmlStr = htmlStr+					"<IMG class='seatSexImg' align='top' SRC='"+setImgUrl+"' title='' border=0/>";
	var htmlStr = htmlStr+					patInfoHtmlText;
	var htmlStr = htmlStr+				"</div>"   //姓名部分
	var htmlStr = htmlStr+				"<div class='seatbodyicon' style='height:"+seatBodyIconHeight+"' seatID='"+seatID+"'>";
	var htmlStr = htmlStr+					IconHtml
	var htmlStr = htmlStr+				"</div>"          //图标部分
	var htmlStr = htmlStr+			"</div>"
	var htmlStr = htmlStr+		"</div>"
	var htmlStr = htmlStr+"</div>";
	//console.log(data.PatInfo.MRDiagnos.replace(",","222"));
	//alert(data.PatInfo.MRDiagnos==undefined?"":data.PatInfo.MRDiagnos.replace(",","<br>"));
	$(".obsseat").append($(htmlStr));
	
	var tooltipPos="";
	lastRowY>parseInt(seatTop)?tooltipPos="bottom":tooltipPos="top";
	
	if(data.PatInfo.PaAdm!=undefined){
		if(isMakeFlag=="Y") return;
		$(".seat[data-id='"+seatID+"']").tooltip({
			position: tooltipPos,
			trackMouse:true,
		    content:'<div style="">' +
		                '<div>姓名：'+data.PatInfo.PatName+'</div>' +
		                '<div>年龄：'+data.PatInfo.PatAge+'</div>' +
		                '<div>性别：'+data.PatInfo.PatSex+'</div>' +
		                '<div>类型：'+data.PatInfo.PatType+'</div>' +
		                '<div>费别：'+data.PatInfo.AdmReason+'</div>' +
		                '<div>登记号：'+data.PatInfo.PatNo+'</div>' +
		                '<div>诊断：<br>'+(data.PatInfo.MRDiagnos==undefined?"":data.PatInfo.MRDiagnos.replace(/##/g,"<br>"))+'</div>' +
		            	'<div>号别：'+data.PatInfo.QueDepDesc+"("+data.PatInfo.AdmCare+")"+'</div>' +
		            	'<div>余额：'+data.PatInfo.Deposit+'</div>' +
		            	'<div>入留观时间：'+data.PatInfo.PatObsDateDesc+'</div>' +
		            '</div>',
		    onShow: function(){
				
		    }	
		})
	}
}


function bedIsStop(){
	if(arguments[0]!==""){
		$.messager.alert("提示",arguments[0]);	
	}	
	return;
}

function statPatNum(data){
	seatNum.allSeatNum++;
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
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if(frm.PPRowId) frm.PPRowId.value = "";
	}
}


///打印腕带
function prtStraps(){
	if(selSeatPat.adm==="") {
		$.messager.alert("提示","患者必须安排床位后才能打印腕带！");
		return;
	}
	newProPrtWd("",selSeatPat.adm,CurHospID);
	return;
}
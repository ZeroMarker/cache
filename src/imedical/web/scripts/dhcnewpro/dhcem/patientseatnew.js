var dragFlag=true;   /// 拖动标记
var TmpTrsSeat = ""; /// 转移座位
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var defaultCardTypeDr //默认卡类型
$(function(){
	
	initParam();
	
	initPage();
	
	//初始化combobox
	initCombo(); 
	
	initOneMethod();
	
	initPageDomMethod();
	
    ///初始化界面，座位图的生成和等待区病人的生成,以及easyui组件
    InitBedPage();
	
	//
	beginrefresh(); 
	 
	initMondelMethod(); 
	
	initWaitArea(); /// 初始化等候区 bianshuai 2019-02-19
	 
	//时钟显示  暂时注销
	setInterval("beginrefresh()",1000);

})

function initOneMethod(){
	$("#plantObsRoomBtn").on("click",plantObsRoomBtn);
}

function initPage(){
	
	if(SEATVIEWDEF==1){
		$HUI.switchbox("#switch1").setValue(false);
	}	
	if(SEATLAYOUTDEF==1){
		$HUI.switchbox("#switch2").setValue(false);
	}
	return;
}

function initPageDomMethod(){
	$("#patRegNo").bind('keypress',PatRegNo_KeyPress);
	$('#filterValue').on('keypress',filterValue_KeyPress);
}

function initParam (){
	seatObj={
		seatWidth:228, //210
		seatHeight:46 //45
	}
	
	if(SEATVIEWDEF==1){
		seatObj.seatHeight=201; //216
	}
	
	//当前选中床位信息
	curSelSeat={
		seatRowId:"",
		cardNo:"",
		patName:"",
		regNo:"",
		secretLev:"",
		patLev:"",
		patId:"",	
		admId:""			
	}
	
	//当前选中床位信息
	curDropSeat={
		seatRowId:"",
		cardNo:"",
		patName:"",
		regNo:"",
		secretLev:"",
		patLev:"",
		patId:"",	
		admId:""			
	}
	
	//安排模式
	planModel="";
	
	obsPatTable = {
		checkIndex:"",  //指针：指向datagrid当前选中的行	
	};
	
	selSeatPat={  	  //指向选中的床位病人
		seatID:"",	  //通过这个字段可以判断床位是否选中
		adm:"",		  //通过两个字段可以判定选中床位是否有人
		planSeatID:"" //安排的时候将要安排的床位ID
	};
	dataFormat="";
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},
		function(data){
			dataFormat=data;
		},"text",false);
}

function InitBedPage() {	
    //调用方法执行后台代码
    var patRegNo=$("#patRegNo").val();
    var filterValue = $("#filterValue").val();
	var filterType = $("#filterCombo").combobox("getValue");
	runClassMethod(
		"web.DHCEMPatientSeat","SelAllBedNew",{
			'LgParams':LgParams,
			"PatRegNo":patRegNo,
			"FilterType":$(".queryItmActive").length?$(".queryItmActive").attr("filterType"):filterType,
			"FilterValue":$(".queryItmActive").length?$(".queryItmActive").attr("filterValue"):filterValue
		},function(data){ 
		var noPerple = data.allSeat-data.useSeat;
		var str = data.text;
		var seatSize = data.size;
		var seatNorms = data.widAndHei;
		var row = seatSize.split("*")[0];
		var cow = seatSize.split("*")[1];
		//seatObj.seatWidth = seatNorms.split("*")[0];
		//seatObj.seatHeight = seatNorms.split("*")[1];
		if((str=="")&&(patRegNo=="")){
			$.messager.alert("提示","没有座位！");
			return;	
		}

		initpatient(row,cow);  //初始化座位
		initPatientText(row,cow,str,noPerple);  //座位中显示的内容
	});
  
}

//初始化座位
function initpatient(row,cow){
	var $BedDiv  = $('#transSeatArea');
	var bedHeight=seatObj.seatHeight==""?43:seatObj.seatHeight;
	
	bedDivWidth=parseInt(seatObj.seatWidth+12)*cow
	$BedDiv.css("width",bedDivWidth+"px");
	//seatObj.seatWidth!=""?$("#lef-bottom").css("width",(parseInt(seatObj.seatWidth)+12)*parseInt(cow)):$("#lef-bottom").css("width",222*parseInt(cow));
	$BedDiv.empty();
	var thisSeatHtml="";
	for (i = 1; i <= row*cow; i++) {
		thisSeatHtml=
		"<div class='sickbed' style='visibility:hidden;' id='sickbed"+i+"'>" +
			"<div class='hasSyOrdMes'>"+$g("医")+"</div>"+
			"<div class='sickbedBorder'></div>"+
			"<div class='sickbedOpPanel' style='display:none;'><a href='#' onclick='plantPatBtn()' style='font-weight:600;border-radius:5px;border:none'>"+$g("安排")+"</a></div>"+
			"<div class='sickbedContent'>"+
				"<span class='posInline bedName' id='bedName"+i+"' style='line-height:28px;font-weight:700;'></span>"+
				"<span class='posInline' id='patName1' style='line-height:28px;width:77px;font-weight:700;'></span>"+
				"<span class='posInline' id='planDate"+i+"' style='line-height:28px;width:40px;text-align:right;font-weight:700;'></span>"+
				"<span class='seat-btn-icon' id='patSexImg"+i+"'>&nbsp;</span>"+
				"<div id='patInfo2' style='height:150px;padding-left:10px;'>"+
					"<div><span class='bed-span'>"+$g("姓名")+"：</span><span id='patName2'></span><span id='patSex2'></span><span id='patAge2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("费别")+"：</span><span id='patFei2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("登记号")+"：</span><span id='patRegNo2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("诊断")+"：</span><span id='MRDiagnos2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("过敏原")+"：</span><span id='AllergyInfo2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("就诊科室")+"：</span><span id='PatInDep2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("就诊时间")+"：</span><span id='PaAdmTime2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("主管医生")+"：</span><span id='MainDoc2'></span></div>" +
	                "<div id='patInfoIcon2'></div>" +
				"</div>"+
			"</div>"+
			"<div class='sickbedBorder hideItm' id='sickbedBorder"+i+"'>"+
				"<div id='seattitle'>"+
				"	<div class='patientNum' id='patientNum"+i+"'></div>" +
				"</div>" +
				"<div style='clear: both'></div>"+
				"<div class='patientBody' id='patientBody"+i+"'></div>" +
			"</div>"+
			"<div class='ArrangeBtn hideItm' id='ArrangeBtn"+i+"'></div>"+       //这个参数只为了存储数据
		 "</div>"
		 
		$(thisSeatHtml).appendTo($BedDiv); 
		if(i%cow==0&&i!=cow*row){
			$("<div class='seatClear' style='clear:both'></div>").appendTo($BedDiv); 
		}
	}
	
	
	
	
	if(seatObj.seatWidth!=""){
		$('.sickbed').css('width',seatObj.seatWidth);
		$('.sickbed').css('height',seatObj.seatHeight);
		$('.sickbedBorder,.sickbedOpPanel').css('width',seatObj.seatWidth);
		$('.sickbedBorder,.sickbedOpPanel').css('height',seatObj.seatHeight);
		$('.sickbedContent').css('width',parseInt(seatObj.seatWidth)-4);
		$('.sickbedContent').css('height',parseInt(seatObj.seatHeight)-4);
	}else{
		$('.sickbed').css('width',228);
		$('.sickbed').css('height',46);	//45
		$('.sickbedBorder,.sickbedOpPanel').css('width',228);
		$('.sickbedBorder,.sickbedOpPanel').css('height',46); //45
		$('.sickbedContent').css('width',224); //206
		$('.sickbedContent').css('height',42); //41
	}
	
	initMethod();
}

function initMethod(){
	$("#plantBtn").unbind();
	$("#ClearArrBtn").unbind();
	$('#winArrBtn').unbind();
	$('#TransBtn').unbind();
	$('#PrintSeatCardBtn').unbind();
	
	$('#readCardBtn').unbind();
	$('#wriArea').unbind();
	$("#PatNo").unbind();
	$("#doccancel").unbind(); /// 主管医生取消
	$("#docsure").unbind(); /// 主管医生确定
	
	$("#plantBtn").bind('click',ArrPatSeat);  /// planPat
	$("#ClearArrBtn").bind('click',clearSeat);
	$('#winArrBtn').bind('click',arrangePat);
	$('#TransBtn').bind('click',transfuse);
	$('#readCardBtn').bind('click',readCardNo);
	$('#wriArea').bind('click',InsPatWaitArea); /// 等候
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	$("#doccancel").bind('click',DoCancel);  /// 主管医生取消
	$("#docsure").bind('click',DocSure);  /// 主管医生确定
	$('#PrintSeatCardBtn').bind('click',newPrintXmlMode);
}

/// 登记号 回车事件
function PatRegNo_KeyPress(e){

	if(e.keyCode == 13){
		var TmpPatNo = $("#patRegNo").val();
		if (!TmpPatNo.replace(/[\d]/gi,"")&(TmpPatNo != "")){
			///  登记号补0
			TmpPatNo = GetWholePatNo(TmpPatNo);
			$("#patRegNo").val(TmpPatNo);
		}
		againData(LgLocID,TmpPatNo);
	}
}

function againData(filterType,filterValue){
	$("#obsPatTable").datagrid("load",{"LgLocID":LgLocID,"TmpPatNo":"","FilterType":filterType,"FilterValue":filterValue}); 
	InitBedPage();		
}

function filterValue_KeyPress(e){
	if(e.keyCode == 13){
		var filterValue = $("#filterValue").val();
		var filterType = $("#filterCombo").combobox("getValue");
		$(".queryItmActive").length?$(".queryItmActive").removeClass("queryItmActive"):"";
		againData(filterType,filterValue);
	}
}

/// 登记号 回车事件
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var TmpPatNo = $("#PatNo").val();
		if (!TmpPatNo.replace(/[\d]/gi,"")&(TmpPatNo != "")){
			///  登记号补0
			TmpPatNo = GetWholePatNo(TmpPatNo);
			$("#PatNo").val(TmpPatNo);
		}
		$("#obsPatTable").datagrid("load",{"LgLocID":LgLocID,"TmpPatNo":TmpPatNo}); 
		
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

//chushihuachuangneirong 
function initPatientText(row,cow,str,noPerple){
	var ManSeatNum=0;
	var WomanSeatNum=0;
	var UnknownSeatNum=0;
	var AllPersonNum=0;
	var HasNoExecOrdNum=0;
	var strArr = str.split("$$");
	var popTipNumber = 0;
	var SexNumberObj={};
	for(i=0;i<strArr.length-1;i++){
		var hasPat = strArr[i].split("^")[6];  //NY
		var seatDesc  = strArr[i].split("^")[1];
		var seatColor = strArr[i].split("^")[3];  //床位类型
		var seatID = strArr[i].split("^")[4];  //
		var seatName = strArr[i].split("^")[5];
		//$.messager.alert("提示"strArr[i].split("^")[1]);
		var num = (strArr[i].split("^")[1].split("-")[0]-1)*cow+parseInt(strArr[i].split("^")[1].split("-")[1]);
		if(seatColor=="") seatColor="#77AAFF";
		$("#sickbed"+num).attr("seatId",seatID);
		$(".sickbed #bedName"+num).text(seatName);
		if(seatColor!=""){
			$(".sickbed #bedName"+num).css("color",seatColor);
			//$(".sickbed #bedName"+num).css("background",seatColor); //2023-01-12
		}
		$(".sickbed #ArrangeBtn"+num).attr("seatId",seatID);
		$(".sickbed #ArrangeBtn"+num).attr("seat",seatName);
		$("#sickbed"+num).css('visibility','visible');
		$(".sickbed #patientNum"+num).css("background-color",seatColor);
		$(".sickbed #ArrangeBtn"+num).attr("hasPat",hasPat);
		if(hasPat=="N"){			
			$(".sickbed #ArrangeBtn"+num).attr("regNo","");
			$(".sickbed #ArrangeBtn"+num).attr("patName","");
			$(".sickbed #ArrangeBtn"+num).attr("cardNo","");
			$(".sickbed #Transfuse"+num).attr("patFlag","");
			$("#sickbed"+num).css("background-color","#ffffff");   //nsj 2016-11-29
			$(".sickbed #sickbedBorder"+num).css("background-color","rgb(230, 226, 226)");
			$("#ArrangeBtn"+num).css("background-color","#BEBEBE");
			$("#Transfuse"+num).css("background-color","#BEBEBE");
			$(".sickbed #patientNum"+num).text(seatName);	    //QQA 2017-01-10
			$(".sickbed #patientNum"+num).css("color","#000")   //nsj 2016-11-29
			$("#sickbed"+num).addClass("onDroppable");   //设置放置事件
			$("#sickbed"+num).find("#patInfo2").html("");
			$("#sickbed"+num).find(".sickbedOpPanel").show();
		}
		
	   if(hasPat=="YY"){ ///座位图被病人占用  yyt 2019-05-01
			var patName  = strArr[i].split("^")[8];
			var regNo  = strArr[i].split("^")[9];
			var PaAdmDate  = strArr[i].split("^")[10];
			var PaAdmTime  = strArr[i].split("^")[11];
			var PrvDoc  = strArr[i].split("^")[12];
			
			var sexHtmlStr=""
			sexHtmlStr = 			 '<div style="margin-top:5px;margin-left:8px;">';
			sexHtmlStr = sexHtmlStr +'<span style="color:red">'+$g("留观病人占用");
			sexHtmlStr = sexHtmlStr +'	</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("姓名")+"："+ patName +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div style="margin-top:5px">';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("登记号")+"："+ regNo +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("日期")+"："+ PaAdmDate +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("时间")+"："+ PaAdmTime +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("医生")+"："+ PrvDoc +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div>';

			$(".sickbed #patientBody"+num).append(sexHtmlStr);
		    ///$("#sickbed"+num).find(".patientNum").addClass("onDraggable");
			
		}

		if(hasPat=="Y"){
			var thisPatInfo=strArr[i].split("!!")[0];
			var otherInfo=strArr[i].split("!!")[1];
			var admId  = thisPatInfo.split("^")[7];
			var patName  = thisPatInfo.split("^")[8];
			var cardNo  = thisPatInfo.split("^")[9]; 
			var patId  = thisPatInfo.split("^")[10]; 
			var regNo  = thisPatInfo.split("^")[11];
			var secretLev = thisPatInfo.split("^")[12];
			var patLev = thisPatInfo.split("^")[13];
			var patSex  = thisPatInfo.split("^")[14]; 
			var patAge  = thisPatInfo.split("^")[15]; 
			var patFei  = thisPatInfo.split("^")[16];
			var MRDiagnos = thisPatInfo.split("^")[17];
			var PatInDep = thisPatInfo.split("^")[18];
			var PaAdmTime = thisPatInfo.split("^")[19];   /// 新加 2019-03-04 bianshuai
			var MainDoc = thisPatInfo.split("^")[20];     /// 新加 2019-05-30 bianshuai
			var InSeatDateLimit = thisPatInfo.split("^")[21];
			var AllergyInfo = thisPatInfo.split("^")[22];
			var AdmAbnormal = thisPatInfo.split("^")[23];
			var PatSexDesc = thisPatInfo.split("^")[24];  ///性别
			
			if(AdmAbnormal=="Y"){
				popTipNumber++;
				$.messager.popover({
					msg: $g('座位号')+seatName+$g('的患者')+patName+$g('无法获取有效就诊(未挂号或者挂号失效(退号)),请核实!'),
					type: 'error',
					style: {
						bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
						right: 10
					},
					timeout:5000*popTipNumber
				});
			}
			
			$(".sickbed #Transfuse"+num).attr("admId",admId);
			$(".sickbed #ArrangeBtn"+num).attr("regNo",regNo);
			$(".sickbed #ArrangeBtn"+num).attr("patName",patName);
			$(".sickbed #ArrangeBtn"+num).attr("cardNo",cardNo);
			$(".sickbed #Transfuse"+num).attr("patFlag",$g("有人"));
			$(".sickbed #Transfuse"+num).attr("regNo",regNo);
			$(".sickbed #ArrangeBtn"+num).attr("secretLev",secretLev);
			$(".sickbed #ArrangeBtn"+num).attr("patLev",patLev);
			$(".sickbed #ArrangeBtn"+num).attr("patId",patId);
			$(".sickbed #ArrangeBtn"+num).attr("admId",admId);
			
			$("#sickbed"+num).find("#patName2").html(patName);
			$("#sickbed"+num).find("#patAge2").html("("+patAge+")");
			//$("#sickbed"+num).find("#patSex2").html(PatSexDesc);
			$("#sickbed"+num).find("#patFei2").html(patFei);
			$("#sickbed"+num).find("#patRegNo2").html(regNo);
//			$("#sickbed"+num).find("#MRDiagnos2").html(MRDiagnos);
//			$("#sickbed"+num).find("#AllergyInfo2").html(AllergyInfo);
			if(MRDiagnos===""){
				$("#sickbed"+num).find("#MRDiagnos2").html("<span style='color:#fff'>"+$g("无")+"</span>");
			}else{
				$("#sickbed"+num).find("#MRDiagnos2").html(MRDiagnos);
			}
			if(AllergyInfo===""){
				$("#sickbed"+num).find("#AllergyInfo2").html("<span style='color:#fff'>"+$g("无")+"</span>");
			}else{
				$("#sickbed"+num).find("#AllergyInfo2").html(AllergyInfo);
			}
			$("#sickbed"+num).find("#PatInDep2").html(PatInDep);
			$("#sickbed"+num).find("#PaAdmTime2").html(PaAdmTime);
			$("#sickbed"+num).find("#MainDoc2").html(MainDoc);
			if(otherInfo!=""){
				$("#sickbed"+num).find(".hasSyOrdMes").show();
				$("#sickbed"+num).addClass("hasSyOrd");
				HasNoExecOrdNum++;
			}
			
			var sexHtmlStr = "",sexIcon="",sexCon="";
			AllPersonNum++
			SexNumberObj[PatSexDesc]=(SexNumberObj[PatSexDesc]?SexNumberObj[PatSexDesc]+1:1); ///记录性别
			
			if(PatSexDesc==$g("男")){  //男 	ManSeatNum++;
				sexIcon="pat_mannew";
				sexCon="mancontent";
			}else if(PatSexDesc==$g("女")){   //女 WomanSeatNum++;
				sexIcon="pat_womannew";
				sexCon="womancontent";
			}else {	//未知 UnknownSeatNum++;
				sexIcon="pat_nomannew";
			}
			
			
			sexHtmlStr = 			 '<div>';
			sexHtmlStr = sexHtmlStr +'	<span class="l-btn-left l-btn-icon-left">';
			sexHtmlStr = sexHtmlStr +'	<span class="l-btn-text">'+patName;
			sexHtmlStr = sexHtmlStr +'	</span><span class="l-btn-icon '+sexIcon+'">&nbsp;</span></span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+ regNo +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+ PatSexDesc +'</span><span style="margin-left:20px">'+ patAge +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text" style="text-overflow:ellipsis;overflow:hidden;width:165px;">';
			//sexHtmlStr = sexHtmlStr + '		<span>'+ PatInDep +'</span>';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("诊断")+'：'+ MRDiagnos +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			//sexHtmlStr = sexHtmlStr + '		<span>'+ PaAdmTime +'</span>';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("医生")+'：'+ MainDoc+ '</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			$(".sickbed #patientBody"+num).append(sexHtmlStr);
			$(".sickbed #patientNum"+num).text(seatName);
			var seatShowName="";
			patName.length>5?seatShowName=patName.substring(0,5)+"..":seatShowName=patName;
			
			//$(".sickbed #patName"+num).text(seatShowName);
			$("#sickbed"+num).find("#patName1").html(seatShowName);
			$(".sickbed #patSexImg"+num).addClass(sexIcon);
			$(".sickbed #planDate"+num).text(InSeatDateLimit);
			
			$("#sickbed"+num).addClass(sexCon); //hxy 2023-01-29
			$("#sickbed"+num+" .sickbedContent").addClass(sexCon); //hxy 2023-01-29
			
			$("#sickbed"+num).find(".patientNum").addClass("onDraggable");
			
			$HUI.tooltip("#sickbed"+num,{
				position: 'bottom',
				trackMouse:true,
			    content:  
				    '<div style="color: #ffffff;">' +
	                '<div>'+$g('姓名')+'：'+patName+'</div>' +
	                '<div>'+$g('年龄')+'：'+patAge+'</div>' +
	                '<div>'+$g('性别')+'：'+PatSexDesc+'</div>' +
	                '<div>'+$g('费别')+'：'+patFei+'</div>' +
	                '<div>'+$g('登记号')+'：'+regNo+'</div>' +
	                '<div>'+$g('诊断')+'：'+MRDiagnos+'</div>' +
	                '<div style="width:200px">'+$g('过敏原')+'：'+AllergyInfo+'</div>' +
	                '<div>'+$g('就诊科室')+'：'+PatInDep+'</div>' +
	                '<div>'+$g('就诊时间')+'：'+PaAdmTime+'</div>' +
	                '<div>'+$g('主管医生')+'：<span id="TipMainDoc">'+MainDoc+'</span></div>' +
	                '</div>',
			    onShow: function(){
					
			    }	
			})
		}
	}
	
	
	if(!$("#filterValue").val()&&!$(".queryItmActive").length){
		$('#top_btn_no').html(noPerple);
		//$('#top_btn_man').html(ManSeatNum);
		//$('#top_btn_woman').html(WomanSeatNum);
		//$('#top_btn_unman').html(UnknownSeatNum);
		$('#top_btn_all').html(AllPersonNum);
		$('#top_btn_ord').html(HasNoExecOrdNum);
		
		$(".sexArea").html("");
		for (key in SexNumberObj){
			var thisHtml = 
			'<span style="display: inline-block;width:15px;"></span>'+
				'<span class="queryItm" onclick="clickQueryItm(this)" filterType="PatSex" filterValue="'+key+'">'+
				'<span style="color:333333;">'+key+'</span><span class="showNumberSpan" id="top_btn_man">'+SexNumberObj[key]+'</span>'+
			'</span>'
			$(".sexArea").append(thisHtml)
		}
	}
	
	initSeatClick();
	initDragAndDrop();
	
	///配置和紧凑
	var obj={value:$HUI.switchbox("#switch2").getValue()};
	changeSeatViewPosition(obj);
	//SeatClickInfo();//yyt
}

function initDragAndDrop(){
	

	$HUI.draggable(('.onDraggable'),{
		revert:true,
		deltaX:-70,
		deltaY:-30,
		proxy:function(source){
			var n = $('<div class="proxy"></div>');
			n.html($(source).parents(".sickbed").html()).appendTo('body');
			return n;
		},
		onStartDrag:function(event){
			var $obj = $(event.target).parents(".sickbed").find(".ArrangeBtn");
			setCurDropSeat($obj);
		}
	});	


	$HUI.droppable(('.onDroppable'),{
		accept: '.onDraggable, .onDraggable1',
		onDragEnter:function(e,source){
			$(this).find(".sickbedBorder,.sickbedOpPanel").css({"border":"2px solid #6b6fc7"});
		},
		onDragLeave: function(e,source){
			$(this).find(".sickbedBorder,.sickbedOpPanel").css({'border':'1px solid #ccc'});
		},
		onDrop: function(e,source){
			var hasPat=$(this).find(".ArrangeBtn").attr("hasPat") 
			if(hasPat=="YY"){
				  $.messager.alert("提示","该座位已占用，不能分配！","warning");
				  $(this).find(".sickbedBorder").css({'border':'1px solid #ccc'});
				  return  
			}
			$(this).css({top:0,left:0})
			$(this).find(".sickbedBorder").css({'border':'1px solid #ccc'});
			var seatID = $(this).find(".ArrangeBtn").attr("seatID");
			planPatByMove(seatID);
			clearCurDropSeat();
			return;
			
		}
	}) 
	
	
}

/// 病人列表拖动事件
function initDragAndDropPat(){
	
	$HUI.draggable(('.onDraggable1'),{
		revert:true,
		deltaX:-70,
		deltaY:-30,
  		proxy:function(source){
			var n = $('<div class="proxy"></div>');
			n.html($(source).parent().html()).appendTo('body');
			return n;

		}, 
		onStartDrag:function(event){
			$(".proxy").css("display","block");
			var PatBaseObj = GetPatBaseInfo($(this).attr("data-adm"));
			if (PatBaseObj) InitCurSeatObject(PatBaseObj);  /// 设置座位对象
			
		},
		stop:function(){
	   	   $(".proxy").css("display","none");
	    }
	});		
}
function initSeatClick(){
	
	$('.sickbed').on('click',function(){    //无人的时候点击座位可以安排
		seatClickFun(this,"");
	}).bind("contextmenu", function(e){
			/// 增加右键菜单 2019-02-21 bianshuai
			e.preventDefault(); //阻止浏览器捕获右键事件
			if (!$(this).hasClass("sickbed-selected")){
				if($(this).find(".ArrangeBtn").attr("patId")){
					$(this).click();
				}else{
					clearCurSelSeat();
					if(obsPatTable.checkIndex!==""){
						$("#obsPatTable").datagrid("unselectRow", obsPatTable.checkIndex);
						obsPatTable.checkIndex="";
					}
					seatClickFun(this,"plantPatBtn");
				}
			}
			$HUI.menu('#menu').show({ 
	           //显示右键菜单  
	           left: e.pageX,//在鼠标点击处显示菜单  
	           top: e.pageY  
			});
	});
	
	$(".sickbed").on({
		mouseover : function(){
			if($(this).find(".ArrangeBtn").attr("patId")){
				return;	
			}
			var cssObj={
				"z-index":1,
				"opacity": 0.5,
				"line-height":(parseInt($(this).height()))+"px"
			}
			$(this).find(".sickbedOpPanel").css(cssObj);
			lantNoPatSeatId=$(this).attr("id");
		} ,
		mouseout : function(){
			if($(this).find(".ArrangeBtn").attr("patId")){
				return;	
			}
			var cssObj={
				"z-index":-1,
				"opacity": 0
			}
			$(this).find(".sickbedOpPanel").css(cssObj);
			lantNoPatSeatId="";
		} 
	}) ;
	
	event.stopPropagation();	
}

function seatClickFun(_this,type){
	var hasPat=$(_this).find(".ArrangeBtn").attr("hasPat") 	  
	if(hasPat=="YY"){
	   $.messager.alert("提示","该座位已占用，不能分配！","warning");
	     return  
	}
	if(($(_this).find(".ArrangeBtn").attr("patId")===undefined)&&(curSelSeat.patId==="")&&(type!="plantPatBtn")){
		return;	
	}

	if(($(_this).find(".ArrangeBtn").attr("patId")===undefined)&&(curSelSeat.patId!=="")){
		curSelSeat.seatRowId=$(_this).find(".ArrangeBtn").attr("seatId");
		TmpTrsSeat=$(_this).find(".ArrangeBtn").attr("seat");
		planModel="U";
		ArrPatSeat();  /// planPat();
		return;	
	}

	if(!$(_this).hasClass("sickbed-selected")&&$(".sickbed-selected").length){
		$(".sickbed-selected").toggleClass("sickbed-selected");
	}

	if($(_this).hasClass("sickbed-selected")){
		clearCurSelSeat();	
	}

	$(_this).toggleClass("sickbed-selected");

	//设置当前
	if($(_this).hasClass("sickbed-selected")){
		var $obj=$(_this).find(".ArrangeBtn");
		setCurSelSeat($obj);		
	}
	setEprMenuForm(curSelSeat.admId,curSelSeat.patId);
	///根据列表安排  yyt
	var SelData = $("#obsPatTable").datagrid("getSelections");  //加载面板
	if(($(_this).find(".ArrangeBtn").attr("patId")===undefined)&&(SelData.length)){   //选中等候区病人再选中床位上病人
		$HUI.combobox("#UserTradeSeatBt").setValue($(_this).find(".ArrangeBtn").attr("seat"));
		$('#SeatRowId').val($(_this).find(".ArrangeBtn").attr("seatId"));
		$('#CardNum').val($(_this).find(".ArrangeBtn").attr("CardNo"));	
		loadPlanPatWin(SelData)
		return;
	}
	checkOrUnCheck(obsPatTable.checkIndex)  //清除选中行

	return false;
		
}

//界面显示时间，1s钟刷新一次
function beginrefresh(){
	var time=new Date();
	var y=time.getFullYear(); //获取年
	var m=time.getMonth()+1; //获取月
	var d=time.getDate(); //获取日
	var h=time.getHours(); //获取小时
	var M=time.getMinutes(); //获取分
	var s=time.getSeconds(); //获取秒
	m=coverPosition(m.toString(),2,"0");
	d=coverPosition(d.toString(),2,"0");
	h=coverPosition(h.toString(),2,"0");
	M=coverPosition(M.toString(),2,"0");
	s=coverPosition(s.toString(),2,"0");
									
	if(dataFormat==3){
		$("#showNowYear").text(y+"-"+m+"-"+d+" "+h+":"+M+"");
    }else if(dataFormat==4){
	    $("#showNowYear").text(d+"/"+m+"/"+y+" "+h+":"+M+"");
	}else{
		return;
	}
	var str = "";  					//nsj 2016-11-30
	var week = time.getDay(); 
	if (week == 0) {  
        str = $g("星期日");  
	} else if (week == 1) {  
        str = $g("星期一");  
	} else if (week == 2) {  
        str = $g("星期二");  
	} else if (week == 3) {  
        str = $g("星期三");  
	} else if (week == 4) {  
        str = $g("星期四");  
	} else if (week == 5) {  
        str = $g("星期五");  
	} else if (week == 6) {  
        str = $g("星期六");  
	}  
  	$("#showNowWeek").text(str);
}


function clearData(){
	//alert("清除数据");
	dragPatInfo.seatId="";
	dragPatInfo.regNo="";
	}

//点击安排的时候
function planPat(e){
	//信息直接dom操作，少去了后天交互，速度变快'
	e=e||event;
	CleanModel();  											//清空面板数据
	$HUI.window("#wind").open();
	$('#SeatRowId').val(curSelSeat.seatRowId);
	$('#CardNum').val(curSelSeat.cardNo);
	$('#UserName').val(curSelSeat.patName);
	$('#RegiNum').val(curSelSeat.regNo);
	$('#UserSecRank').val(curSelSeat.secretLev);
	$('#UserRank').val(curSelSeat.patLev);
	$('#PatId').val(curSelSeat.patId);	
	$('#PaAdm').val(curSelSeat.admId);
	
	clearCurSelSeat();  /// 清空选中对象 bianshuai 2019-03-04
	
	if(curSelSeat.patId===""){
		$HUI.combobox("#UserTradeSeatBt").setValue(curSelSeat.seatRowId);
	}
	
	if(planModel==="U"){
		$HUI.combobox("#UserTradeSeatBt").setValue(curSelSeat.seatRowId);
	}
	
	if (curSelSeat.seatRowId == ""){
		$HUI.combobox("#UserTradeSeatBt").disable();
	}
	
	var PatBaseObj = GetPatBaseInfo(curDropSeat.admId);
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// 设置面板内容 2019-03-04 bianshuai
	
	return false;
}


//移动操作安排面板
function planPatByMove(seatID){
	
	CleanModel();  				//清空面板数据
	$HUI.window("#wind").open();
	$('#SeatRowId').val(seatID);
	$('#CardNum').val(curDropSeat.cardNo);
	$('#UserName').val(curDropSeat.patName);
	$('#RegiNum').val(curDropSeat.regNo);
	$('#UserSecRank').val(curDropSeat.secretLev);
	$('#UserRank').val(curDropSeat.patLev);
	$('#PatId').val(curDropSeat.patId);	
	$('#PaAdm').val(curDropSeat.admId);
	
	$HUI.combobox("#PatSeatNo").disable();
	
	$HUI.combobox("#UserTradeSeatBt").setValue(seatID);
	$HUI.combobox("#UserTradeSeatBt").disable();
	
	
	var PatBaseObj = GetPatBaseInfo(curDropSeat.admId);
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// 设置面板内容 2019-03-04 bianshuai
	$("#wriArea").linkbutton('disable');      /// 等候按钮不可用  bt_waitarea
	clearCurDropSeat();	
	return false;
}
/// 读卡 新
function readCardNo() {
	DHCACC_GetAccInfo7(ReadCardCallback);
}
/// 读卡
function ReadCardCallback(rtnValue){
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
		case '0':
			$('#CardNum').val(myAry[1]);
			$('#RegiNum').val(myAry[5]);
			$('#PatId').val(myAry[4]);			
			$('#CardTypeRowId').val(myAry[8]);
			patientId = myAry[4];
			break;
		case '-200':
			$.messager.alert("提示", "卡无效", "info", function() {
				$("#CardNo").focus();
			});
			break;
		case '-201':
			$('#CardNum').val(myAry[1]);
			$('#RegiNum').val(myAry[5]);
			$('#PatId').val(myAry[4]);
			$('#CardTypeRowId').val(myAry[8]);
			patientId = myAry[4];
			break;
		default:
		}
	if (patientId != "") {
		GetEmRegPatInfo("");
	}
}


function GetEmRegPatInfo(){
	runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
	    {'CardNo':'','RegNo':$('#RegiNum').val(),'LgHospID':LgHospID},
		    function(data){
			    SettingModel(data);
		},"text",false);
}

//取消安排
function clearSeat(){
	var patAdm = $('#PaAdm').val();
	if(patAdm==""){
		$.messager.alert("提示","请选中患者！");
		return;
	}
    //判断病人是否在等候区   yyt   2019-05-11
	var ID=MyRunClassMethod("web.DHCEMPatientSeat","GetPatWaitID",{'EpisodeID':patAdm,'LgLocID':LgCtLocID}); //等候区病人离开
    if(ID!=""){
	  $.messager.confirm('确认对话框','当前病人，是否离开等候区？', function(r){
			if (r){
			    MyRunClassMethod("web.DHCEMPatientSeat","UpdWaitAreaFlag",{'ID':ID}); //等候区病人离开
		        CleanModel();
		        clearCurSelSeat();                     /// 清空 curSelSeat 对象 
		        $HUI.window("#wind").close();
		        $("#obsPatTable").datagrid("reload");  /// 刷新等候区队列
			}
		});
	}else{
		$.messager.confirm('确认对话框','当前病人，是否离开？', function(r){
			if (r){
			  	MyRunClassMethod("web.DHCEMPatientSeat","ClearPatSeat",{'adm':patAdm,'loc':LgCtLocID,'user':LgUserID});
				clearCurSelSeat();  /// 清空 curSelSeat 对象
				CleanModel(); 
				$HUI.window("#wind").close();
				loadComboChangeSeat();
				InitBedPage();
				$("#obsPatTable").datagrid("reload");  /// 刷新等候区队列
			}
		});
	}
}

/// 窗口中安排操作
function arrangePat(){
	
	var SeatRowId = $("#SeatRowId").val();
	
	var EpisodeID = $("#PaAdm").val(); /// 就诊ID
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！");
		return;
	}
	
	if (SeatRowId == ""){
		$.messager.confirm('确认对话框','当前座位为空，是否加入到等候区？', function(r){
			if (r){
				InsPatWaitArea();   /// 加入等候区 bianshuai 2019-02-21
			}
		});
	}else{
		InsPatSeat();
	}
}

/// 窗口中安排操作
function InsPatSeat(){
	
	var SeatRowId = $('#SeatRowId').val();   //座位
	var CardNum = $('#CardNum').val();		 //卡号
	var RegNum = $('#RegiNum').val(); 		 //登记号
	var Adm="";
	if ((CardNum=="")&&(RegNum=="")){
        $.messager.alert("提示","请读卡或输入登记号","warning")
        return;
	}
	
	var PrvDoc = $HUI.combobox("#PrvDoc").getValue();

	var Datas = {
	   'CardNo':CardNum,
	   'RegNo':RegNum,
	   'LgHospID':LgHospID
	}
	
    PatAdmInfo = MyRunClassMethod("web.DHCEMPatientSeat","GetCurrAdm",Datas); 
    if(PatAdmInfo==""){
	    $.messager.alert("提示",'病人没有就诊记录!'); 
		return false;
	}
	var PatientID = PatAdmInfo.split("^")[6];
	var EpisodeID = PatAdmInfo.split("^")[0];
	var SelItems = $("#obsPatTable").datagrid('getSelections');
	var WaitListID="";
	if(SelItems.length) WaitListID=SelItems[0].ID;
	
	var fromSeatId = $(".sickbed-selected").length?$(".sickbed-selected").attr("seatid"):"";

	var Parr="^"+LgCtLocID+"^"+PatientID+"^"+EpisodeID+"^"+SeatRowId+"^"+LgUserID+"^"+"Y"+"^"+PrvDoc+"^"+WaitListID+"^"+fromSeatId;
	var rs = MyRunClassMethod("web.DHCEMPatientSeat","save",{'parr':Parr});
	if(rs=="0"){
   		$.messager.alert("提示","安排成功！");
   		clearCurSelSeat();  /// 清空 curSelSeat 对象
    }else if(rs==-1){
		$.messager.alert("提示","座位已经有人！");   
	}else{
		$.messager.alert("提示","安排失败,CODE:"+rs);   
	}
    $HUI.window("#wind").close();
    CleanModel(); 
    loadComboChangeSeat();    //换座内容重新加载
    loadGetPrvDoc() /// 主管医生
    InitBedPage();
    $("#obsPatTable").datagrid("reload");  /// 刷新等候区队列	   
}

function transfuse(){
	var $obj=$(".sickbed-selected").find(".Transfuse");
		if($(".sickbed-selected").length==0){
		 $.messager.alert("提示","请选择一个座位!");
		 return false;
	}
	if(curSelSeat.admId===""){
		$.messager.alert("提示","没有病人,不能进行输液操作");
		return false;
	}else if(curSelSeat.admId!==$g("有人")){
		var EpisodeID = curSelSeat.admId;
		var PatientID = curSelSeat.patId;
		setEprMenuForm(EpisodeID,PatientID); 
		window.location.href="dhcem.nur.main.hisui.csp";
	}
	return false;
}
	
function CarTypeSetting(value){
	//$.messager.alert("提示","执行");
	m_SelectCardTypeDR = value.split("^")[0];
	var CardTypeDefArr = value.split("^");
    m_CardNoLength = CardTypeDefArr[17];

    if (CardTypeDefArr[16] == "Handle"){
    	$('#CardNum').attr("readOnly",false);
    }else{
		$('#CardNum').attr("readOnly",true);
	}
	$('#CardNum').val("");  /// 清空内容
	$('#CardNum').focus();
}
//实现选中效果,这里是选中病人实现换座位
function toggleClass(){
	
	//alert($(this).attr('id'));
	//当点击没有人的座位上时候，判断有无选中病人
	if(!$(this).find(".Transfuse").attr("patFlag")){
		var regNo=$(".sickClick").find(".Transfuse").attr("regno");
		$(".sickClick").removeClass("sickClick");
		if(regNo){
			planPat($(this).find(".ArrangeBtn").attr("seatid"));
			runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
		    {'patCardNo':'','regNo':regNo,'LgHospID':LgHospID}, 
			    function(data){
				    if(data==""){
					    $.messager.alert("提示","病人没有就诊信息");
					    $('#RegiNum').val("") ;
					}
				    //$.messager.alert("提示",data);
					//CurrAdm_"^"_regNo_"^"_patName_"^"_patCardNo
					$('#RegiNum').val(data.split("^")[1]) ;    
					$('#UserName').val(data.split("^")[2]);
					$('#CardNum').val(data.split("^")[3]);
				},"text",false);
		}
		return false;
	}
		
	if($(this).find(".Transfuse").attr("patFlag")){	
		$(this).toggleClass("sickClick");
		var thisId = "#"+$(this).attr("id");
		$(".sickbed").not(thisId).each(function(){
				$(this).removeClass("sickClick");		
			})
		}
	}

function initCombo(){
	
	var comboData = [
		{ "id": "PatNo", "text": $g("登记号") }, 
		{ "id": "PatName", "text": $g("姓名") },
		{ "id": "PatSex", "text": $g("性别") },
		{ "id": "PatSeat", "text": $g("座位") }
	];
	$HUI.combobox('#filterCombo',{
		valueField:'id',
		textField:'text',
		data:comboData
	});
	
	$HUI.combobox('#filterCombo').setValue("PatNo");
	
	
	$HUI.combobox("#UserTradeSeatBt",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatientSeat&MethodName=SeatDatasByJson2&Loc="+LgCtLocID,
		valueField:'id',
   		textField:'text',
   		onSelect:function(res){
	   		$('#SeatRowId').val(res.id);
	   	},
	   	onLoadSuccess:function(data){
			if(data.length===0){
				$HUI.combobox("#UserTradeSeatBt").disable();	
			}else{
				$HUI.combobox("#UserTradeSeatBt").enable();
			}
		} 
	})
	
	///急诊医生
	$HUI.combobox("#PrvDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgCtLocID+"&ProvType=DOCTOR",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	    }	
	})
	//主管医生
	$HUI.combobox("#ChargDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgCtLocID+"&ProvType=DOCTOR",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
			
	    }	
	})
	
	
	
	/// 座位
	var option = {
		//panelHeight:"auto",
        onSelect:function(option){
	        $('#SeatRowId').val(option.value);
	    },
	    onLoadSuccess: function () { //数据加载完毕事件
        }
	};
	var url = $URL+"?ClassName=web.DHCEMPatientSeat&MethodName=SeatDatasByJson2&Loc="+LgCtLocID;
	new ListCombobox("PatSeatNo",url,'',option).init();	
}

function loadComboChangeSeat(loc){
	$HUI.combobox("#UserTradeSeatBt").reload(LINK_CSP+"?ClassName=web.DHCEMPatientSeat&MethodName=SeatDatasByJson2&Loc="+LgCtLocID);
} 
 
function initMondelMethod(){
	$('#RegiNum').on('keypress', function(e){   
        // 监听回车按键   
       e=e||event;
       if(e.keyCode=="13"){
	     if($('#RegiNum').val()==""){
		    $.messager.alert("提示","登记号为空");  
		    CleanModel();  
		 	return;
		 }
		 
		runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
	    {'CardNo':'','RegNo':$('#RegiNum').val(),'LgHospID':LgHospID},
		    function(data){
			    SettingModel(data);
			},"text",false);
	    }
	   });
	   
	$('#CardNum').on('keypress', function(e){     
		e=e||event;
		if(e.keyCode=="13"){
			var CardNo = $("#CardNum").val();
			if (CardNo == "") return;
			DHCACC_GetAccInfo("", CardNo, "", "", ReadCardCallback);
		}
	});	
	
}    

//设置Model模板数据    
function SettingModel(data){
	
	NoPatCleanModel();	 ///先清除一波数据
	
	if(data==""){
		$.messager.alert("提示","未找到该病人或病人当前无就诊信息!");	
		return;
	}
	
	$('#PaAdm').val(data.split("^")[0]);
	$('#CardNum').val(data.split("^")[1]);
	$('#RegiNum').val(data.split("^")[2]);
	$('#UserName').val(data.split("^")[3]);
	$('#UserSecRank').val(data.split("^")[4]);
	$('#UserRank').val(data.split("^")[5]);
	$('#PatId').val(data.split("^")[6]);        /// 病人ID
	$('#PatSex').val(data.split("^")[7]);       /// 性别
	$('#PatAge').val(data.split("^")[8]);       /// 年龄
	$('#PatLoc').val(data.split("^")[9]);       /// 就诊科室
	$('#PaAdmTime').val(data.split("^")[10]);   /// 就诊时间
	$('#PatSeatNo').combobox("setValue",data.split("^")[12]);
	if(((data.split("^")[11])!="")&&(((data.split("^")[11])!=undefined))){              /// 卡类型ID   yyt  2019-05-11
	    GetEmPatCardTypeDefine(data.split("^")[11]);  ///  设置卡类型
	}
}
    
function clearCurDropSeat(){
	curDropSeat.seatRowId="";
	curDropSeat.seat="";
	curDropSeat.regNo="";
	curDropSeat.patName="";
	curDropSeat.cardNo="";
	curDropSeat.secretLev="";
	curDropSeat.patLev="";
	curDropSeat.patId="";	
	curDropSeat.admId="";	
}
    
function setCurDropSeat($obj){
	var seatRowId = ($obj.attr("seatId")==""||$obj.attr("seatId")==undefined)?arguments[0]:$obj.attr("seatId");
	var seat = ($obj.attr("seat")==""||$obj.attr("seat")==undefined)?arguments[0]:$obj.attr("seat");
	var regNo = ($obj.attr("regNo")==""||$obj.attr("regNo")==undefined)?"":$obj.attr("regNo");
	var patName = ($obj.attr("patName")==""||$obj.attr("patName")==undefined)?"":$obj.attr("patName");
	var cardNo = ($obj.attr("cardNo")==""||$obj.attr("cardNo")==undefined)?"":$obj.attr("cardNo");
	var secretLev = ($obj.attr("secretLev")==""||$obj.attr("secretLev")==undefined)?"":$obj.attr("secretLev");
	var patLev = ($obj.attr("patLev")==""||$obj.attr("patLev")==undefined)?"":$obj.attr("patLev");
	var patId=($obj.attr("patId")==""||$obj.attr("patId")==undefined)?"":$obj.attr("patId");
	var admId=($obj.attr("admId")==""||$obj.attr("admId")==undefined)?"":$obj.attr("admId");
	curDropSeat.seatRowId=seatRowId;
	curDropSeat.seat=seat;
	curDropSeat.regNo=regNo;
	curDropSeat.patName=patName;
	curDropSeat.cardNo=cardNo;
	curDropSeat.secretLev=secretLev;
	curDropSeat.patLev=patLev;
	curDropSeat.patId=patId;	
	curDropSeat.admId=admId;		
}

function clearCurSelSeat(){
	curSelSeat.seatRowId="";
	curSelSeat.seat="";
	curSelSeat.regNo="";
	curSelSeat.patName="";
	curSelSeat.cardNo="";
	curSelSeat.secretLev="";
	curSelSeat.patLev="";
	curSelSeat.patId="";	
	curSelSeat.admId="";
	setEprMenuForm("","");
}

function setCurSelSeat($obj){
	var seatRowId="",seat="",regNo="",patName="",cardNo="",secretLev="",patLev="",patId="",admId=""

	if(typeof $obj === 'object'){
		seatRowId = $obj.attr("seatId");
		seat = $obj.attr("seat");
		regNo = $obj.attr("regNo");
		patName = $obj.attr("patName");
		cardNo = $obj.attr("cardNo");
		secretLev = $obj.attr("secretLev");
		patLev = $obj.attr("patLev");
		patId = $obj.attr("patId");
		admId = $obj.attr("admId");
	}
	
	curSelSeat.seatRowId=seatRowId;
	curSelSeat.seat=seat;
	curSelSeat.regNo=regNo;
	curSelSeat.patName=patName;
	curSelSeat.cardNo=cardNo;
	curSelSeat.secretLev=secretLev;
	curSelSeat.patLev=patLev;
	curSelSeat.patId=patId;	
	curSelSeat.admId=admId;		
}
    
function CleanModel(){	
	$("#filterValue").val("");
	$('#RegiNum').val("") ;    
	$('#UserName').val("");
	$('#CardNum').val("");
	$('#UserSecRank').val("");
	$('#UserRank').val("");
	$('#patId').val("");
	$('#PaAdm').val("");
	$('#SeatRowId').val("");
	$('#CardTypeNew').val("");
	$('#CardTypeRowId').val("");
	$HUI.combobox("#PatSeatNo").enable();
	$HUI.combobox("#PatSeatNo").setValue("");
	$HUI.combobox("#UserTradeSeatBt").enable();
	$HUI.combobox("#UserTradeSeatBt").setValue("");
	$HUI.combobox("#PrvDoc").setValue("");
		
	$('#PatSex').val("");       /// 性别
	$('#PatAge').val("");       /// 年龄
	$('#PaAdmTime').val("");    /// 就诊时间
	$('#PatLoc').val("");       /// 就诊科室
	$("#wriArea").linkbutton('enable');
} 

function NoPatCleanModel(){
	$('#RegiNum').val("") ;    
	$('#UserName').val("");
	$('#CardNum').val("");
	$('#UserSecRank').val("");
	$('#UserRank').val("");
	$('#patId').val("");
	$('#PaAdm').val("");
	
	$("#PrvDoc").combobox("setValue","");
	$("#PatSeatNo").combobox("setValue","");
	
	$('#PatSex').val("");       /// 性别
	$('#PatAge').val("");       /// 年龄
	$('#PaAdmTime').val("");    /// 就诊时间
	$('#PatLoc').val("");       /// 就诊科室
	$("#wriArea").linkbutton('enable');
}
    
///这个方法是直接运行后将结果返回
function MyRunClassMethod(ClassName,MethodName,Datas){
   Datas=Datas||{};
   var RtnStr = "";
   runClassMethod(ClassName,MethodName,
   Datas,
   function (data){
	  	RtnStr=data;
	  },
	"text",false
	);
	return RtnStr;
}

function regFocus(){
	setTimeout(function () {
                   $('#RegiNum').focus();
                }, 200);
	
	}

//补位的方法
//第一个目标数
//第二个参数位数
//第三个是填充的元素
function coverPosition(par1,par2,par3){
		if(par1.length<par2){
			for(i=1;i<par2;i++){
				par1=par3+""+par1;
			}
		}
		return par1;
}

/// 初始化等候区 bianshuai 2019-02-19
function initWaitArea(){
	
	///  定义columns
	var columns=[[
		{field:'PatLabel',title:'病人',width:200,formatter:setCellLabel}
	]];
	
	///  定义datagrid
	var option = {
		showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
	    onLoadSuccess:function (data) { //数据加载完毕事件
			initDragAndDropPat();  /// 病人列表拖动事件
			(!$("#filterValue").val()&&!$(".queryItmActive").length)?$("#top_btn_wait").html(data.total):"";
        },
        onClickRow: function (index, rowData){   //yyt
			$(".sickbed").removeClass("sickbed-selected");
			clearCurSelSeat();
         	checkOrUnCheck(index);
         	checkOrUnCheckSeat($(this));
         	setEprMenuForm(rowData.EpisodeID,rowData.PatientID);
	    },
	    onDblClickRow:function(index,row){
			remvoeWaitPat(row.ID);
		}
	}
	
   	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMPatientSeat&MethodName=JsLocPatWaitArea&LgParams="+ LgParams;
	new ListComponent('obsPatTable', columns, uniturl, option).Init();
}

/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex){
	var IsHasSyOrd=rowData.IsHasSyOrd;
	var tooltipStr =rowData.PatName+","+rowData.PatSex+","+rowData.PatAge+","+rowData.BillType;
	//var htmlstr =  	    '<div style="position: relative;" class="celllabel onDraggable1" title="'+tooltipStr+'" ';
	var htmlstr =  	    '<div style="position: relative;" class="celllabel" title="'+tooltipStr+'" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.EpisodeID+'">'
	var htmlstr = htmlstr + '<div class="hasSyOrdMes" style="'+(IsHasSyOrd?"display:block":"")+'">'+$g('医')+'</div>';
	var htmlstr = htmlstr +'<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">';
	var htmlstr = htmlstr + rowData.PatName + '</span>';
	var htmlstr = htmlstr + '<span class="l-btn-text" style="color:#666;margin-left:1px;padding:0">' + rowData.PatNo + '</span>';

	if(rowData.PatSex==$g("男")){
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_man">&nbsp;</span>';
	}else if(rowData.PatSex==$g("女")){
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_woman">&nbsp;</span>';
	}else{
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_noman">&nbsp;</span>';	
	}
	htmlstr = htmlstr +'</span></div>';
	return htmlstr;
}

/// 加入等候区 bianshuai 2019-02-21
function InsPatWaitArea(){
	
	var EpisodeID = $("#PaAdm").val(); /// 就诊ID
    if ($('#SeatRowId').val() != ""){  /// 从座位图迁到等候区，就诊ID取选定对象的病人就诊ID
		curSelSeat.admId?EpisodeID = curSelSeat.admId:"";   
	} 
	
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！");
		return;
	}
	
	runClassMethod("web.DHCEMPatientSeat","InsPatWaitArea",{"EpisodeID": EpisodeID, "LgLocID":LgLocID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("提示:","该病人已在等候区队列，不允许重复添加！","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("提示:","安排失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","安排成功！","success",function(){
					
			});
			$HUI.window("#wind").close();
			CleanModel();   /// 清空面板
			loadComboChangeSeat();
			loadGetPrvDoc() /// 主管医生
			InitBedPage();
			clearCurSelSeat();  /// 清空 curSelSeat 对象
			$("#obsPatTable").datagrid("reload");  /// 刷新等候区队列
		}
	},'text',false)	
}

/// 生命体征 bianshuai 2019-02-21
function TempMeaSin(){
	
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
	var viewName = "TemperatureMeasureSingle";
	var seatFlag = "true";		//2019-04-26 add by dl 添加是否是座位图病人的标志,处理生命体征病人列表不是座位图病人列表的问题
	var LinkUrl = 'dhc.nurse.vue.mainentry.csp?EpisodeID='+ EpisodeID +'&ViewName='+ viewName+'&SeatFlag='+seatFlag;
	window.open(LinkUrl,$g('生命体征'),'top=25,left=25,width='+(window.screen.availWidth-50)+',height='+(window.screen.availHeight-50));
}

/// 护士执行 bianshuai 2019-02-21
function NurExec(){
	if(PlanPatModel==1){
		$.messager.alert("提示:","安排座位弹出界面不允许再次弹出护士执行界面！","warning");
		return;	
	}	
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	var PatientID = curSelSeat.patId;
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
	
	var LinkUrl = 'dhcem.nur.main.hisui.csp';
	setEprMenuForm(EpisodeID,PatientID);
	websys_showModal({
		url: LinkUrl,
		width: (window.screen.availWidth-50)+'px',
		height: (window.screen.availHeight-50)+'px',
		iconCls:"icon-w-paper",
		title: $g('护士执行'),
		closed: true,
		onClose:function(){}
	});
}

/// 安排 bianshuai 2019-02-21
function ArrPatSeat(){
	CleanModel();  		 /// 清空面板数据
	$HUI.window("#wind").open();
	$("#SeatRowId").val(curSelSeat.seatRowId);
	$HUI.combobox("#UserTradeSeatBt").setValue(curSelSeat.seatRowId)
	$('#CardNum').val(curSelSeat.cardNo);
	$('#UserName').val(curSelSeat.patName);
	$('#RegiNum').val(curSelSeat.regNo);
	$('#UserSecRank').val(curSelSeat.secretLev);
	$('#UserRank').val(curSelSeat.patLev);
	$('#PatId').val(curSelSeat.patId);	
	$('#PaAdm').val(curSelSeat.admId);
	
	loadGetPrvDoc()       //主管医生
	
	///当前床位信息加载
	if((curSelSeat.seat!="")&&(curSelSeat.seat!=undefined)){
		$HUI.combobox("#PatSeatNo").setText(curSelSeat.seat);
	}else{
		$("#wriArea").linkbutton('disable');      /// 等候按钮不可用  bt_waitarea	
	}
	$HUI.combobox("#PatSeatNo").disable();
	
	///将要安排的床位信息加载
	$HUI.combobox("#UserTradeSeatBt").setText(TmpTrsSeat);
	TmpTrsSeat = "";  /// 清空临时座位
	
	///空白床点击安排:清空当前床位，设置安排床位
	if(curSelSeat.patId==""){
		$HUI.combobox("#PatSeatNo").setText("");
		$HUI.combobox("#UserTradeSeatBt").setText(curSelSeat.seat);
	}
	
	var PatBaseObj = GetPatBaseInfo(curSelSeat.admId);
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// 设置面板内容 2019-03-04 bianshuai

}

/// 离开座位
function ClrPatSeat(){
	
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
	
	$.messager.confirm('确认对话框','确定移除当前座位的病人吗？', function(r){
		if (r){
			removePatSeat();   /// 离开座位
		}
	});
}
		
/// 离开座位
function removePatSeat(){
	
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
	
	runClassMethod("web.DHCEMPatientSeat","ClearPatSeat",{"adm": EpisodeID, 'loc':LgCtLocID, 'user':LgUserID},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("提示:","操作失败，失败原因:"+jsonString,"warning");
		}else{
			$.messager.alert("提示:","操作成功！","success");
			clearCurSelSeat();  /// 清空 curSelSeat 对象
			$("#obsPatTable").datagrid("reload");  /// 刷新等候区队列
		}
	},'',false)	
	
	loadComboChangeSeat();
	//loadGetPrvDoc()
	InitBedPage();
	
}

var setEprMenuForm = function(adm,papmi){
	/*var frm = dhcsys_getmenuform();
	var menuWin=websys_getMenuWin();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = adm; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if(frm.PPRowId) frm.PPRowId.value = "";
	}*/
	var frm=window.parent.document.forms["fEPRMENU"];	
	if(frm.EpisodeID){
		frm.EpisodeID.value=adm;
	}
}

/// 病人就诊信息
function GetPatBaseInfo(EpisodeID){
	
	var jsonObject = "";
	runClassMethod("web.DHCEMPatientSeat","GetPatEssInfo",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonObject != null){
			jsonObject = jsonString;
		}
	},'json',false)
	return jsonObject;
}

/// 设置座位对象
function InitCurSeatObject(jsonObject){
	
	if (jsonObject != "") {
		curDropSeat.regNo = jsonObject.PatNo;
		curDropSeat.patName = jsonObject.PatName;
		curDropSeat.cardNo = jsonObject.cardNo;
		curDropSeat.secretLev = jsonObject.PatSLv;
		curDropSeat.patLev = jsonObject.PatLv;
		curDropSeat.patId = jsonObject.PatientID;	
		curDropSeat.admId = jsonObject.EpisodeID;
	}
}

/// 设置面板内容
function InitPatPopPanel(jsonObject){
	if (jsonObject != "") {
		$('#PatSex').val(jsonObject.PatSex);       /// 性别
		$('#PatAge').val(jsonObject.PatAge);       /// 年龄
		$('#PaAdmTime').val(jsonObject.PaAdmTime); /// 就诊时间
		$('#PatLoc').val(jsonObject.PatLoc);       /// 就诊科室
		$('#CardNum').val(jsonObject.PatCardNo);   /// 卡号
		$('#PaAdm').val(jsonObject.EpisodeID);     /// 就诊ID 
		$('#CardTypeRowId').val(jsonObject.CardTypeID);   /// 卡类型ID
		$('#CardTypeNew').val(jsonObject.CardTypeNew);     /// 卡类型描述
	}
}


function ChargeDoc(){
	$HUI.window("#DocWin").open();	
	loadGetPrvDoc()
}

function  DoCancel(){
	$HUI.window("#DocWin").close();
	
}

/// 指定主管医生 yangyongtao 2019-04-19
function  DocSure(){
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
	var ChargDoc = $HUI.combobox("#ChargDoc").getValue();
	var ChargDocDesc = $HUI.combobox("#ChargDoc").getText();
	runClassMethod("web.DHCEMPatientSeat","UpdPrvDoc",{"Loc":LgLocID,'EpisodeID':EpisodeID,'ChargDoc':ChargDoc},
	  function(data){
         if(data=="0"){ 
             $.messager.alert("提示:","修改成功！","success");
             if($(".sickbed-selected").length){
	             $(".sickbed-selected").find("#MainDoc2").html(ChargDocDesc);
	             
	             var seatId = $(".sickbed-selected").attr("id");
	             var contentHtml = $HUI.tooltip("#"+seatId).options().content;
	             var $dom = $(contentHtml);
	             $dom.find("#TipMainDoc").html(ChargDocDesc);
	             $HUI.tooltip("#"+seatId).options().content = $dom.html();
	             $HUI.tooltip("#"+seatId,{});
	         }
             $HUI.window("#DocWin").close();
             //InitBedPage();
          }
	   },"text"); 
	
}

/// 主管医生
function loadGetPrvDoc(){
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	//var SeatRowId = $('#SeatRowId').val();   //座位
	 runClassMethod("web.DHCEMPatientSeat","GetPrvDoc",{"EpisodeID": EpisodeID},function(jsonString){
		if (jsonString !=""){
		   $HUI.combobox("#PrvDoc").setValue(jsonString);
		   $HUI.combobox("#ChargDoc").setValue(jsonString);
		}else{
			$HUI.combobox("#PrvDoc").setValue("");
		   	$HUI.combobox("#ChargDoc").setValue("");
		}
	 },"text")
}

//datagrid 点击选中,再次取消选中
function checkOrUnCheck(rowIndex){
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
		$("#obsPatTable").datagrid("unselectRow", rowIndex);
		obsPatTable.checkIndex="";
	}
}
//Seat 点击选中,再次取消选中
function checkOrUnCheckSeat($this)
{
	var $seatCont = $this.children(".seatcontent")
	$seatCont.toggleClass("active");   //选中效果实现

	$(".seat").not($this).each(function(){
		$(this).children(".seatcontent").removeClass("active")	
	})
	
	var selItems = $("#obsPatTable").datagrid('getSelections')
	if(selItems.length>0){
		curSelSeat.seatRowId="";
		curSelSeat.seat="";
		curSelSeat.regNo=selItems[0].PatNo;
		curSelSeat.patName=selItems[0].PatName;
		curSelSeat.cardNo=selItems[0].CardNo;
		curSelSeat.secretLev="";
		curSelSeat.patLev="";
		curSelSeat.patId=selItems[0].PatientID;	
		curSelSeat.admId=selItems[0].EpisodeID;
		setEprMenuForm(selItems[0].EpisodeID,selItems[0].PatientID);
	}else{
		setCurSelSeat("");
		setEprMenuForm("","");
	}
}

function loadPlanPatWin(SelData){
	//加载安排座位的win
	$HUI.window("#wind").open(); 
	var PatBaseObj = GetPatBaseInfo(SelData[0].EpisodeID);
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// 设置面板内容 2019-03-04 bianshuai	
	$('#UserName').val(SelData[0].PatName);
	$('#RegiNum').val(SelData[0].PatNo);
	$('#PatId').val(SelData[0].PatNo);	
    $("#wriArea").linkbutton('disable');      /// 等候按钮不可用  bt_waitarea
    //$HUI.combobox("#PatSeatNo").disable();
    $HUI.combobox("#PatSeatNo").disable(); 
    loadGetPrvDoc()	
}



//病人列表
function SeatClickInfo(){
	
	$('.sickbed').on('click',function(){

	     if(($(this).find(".ArrangeBtn").attr("patId")===undefined)){
		   $HUI.window("#wind").open();  
		 }
		 var selItems = $("#obsPatTable").datagrid('getSelections');  // yyt 2019-04-27  选中列表安排座位
		 if (!selItems.length){
			//$.messager.alert("提示:","请选中行,重试！");
			//return;
		 }else{
			$(this).removeClass("sickbed-selected")
			/// 清空面板数据
			CleanModel();
			$HUI.combobox("#PatSeatNo").setValue($(this).find(".ArrangeBtn").attr("seat"));
			$('#SeatRowId').val($(this).find(".ArrangeBtn").attr("seatId"));
			$('#UserName').val(selItems[0].PatName);
			$('#RegiNum').val(selItems[0].PatNo);
			$('#PatId').val(selItems[0].PatNo);	
			$('#PaAdm').val(selItems[0].EpisodeID);
			$('#PatSex').val(selItems[0].PatSex);
			$('#PatAge').val(selItems[0].PatAge);
		     var PatBaseObj = GetPatBaseInfo(selItems[0].EpisodeID);
	        if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// 设置面板内容 2019-03-04 bianshuai
	        $("#bt_waitarea").linkbutton('disable');      /// 等候按钮不可用
	        //$HUI.combobox("#PatSeatNo").disable();
	        $HUI.combobox("#UserTradeSeatBt").disable(); 
	        loadGetPrvDoc()
		 }
	 })
	
}

function remvoeWaitPat(ID){
	$.messager.confirm('确认对话框','当前病人，是否离开？', function(r){
		if (r){
		  	MyRunClassMethod("web.DHCEMPatientSeat","RemoveWaitArea",{'ID':ID});
			clearCurSelSeat();  /// 清空 curSelSeat 对象
			$("#obsPatTable").datagrid("reload");  /// 刷新等候区队列
		}
	});
	return;
}



function newPrintXmlMode(){
	var EpisodeID = curSelSeat.admId;  /// 就诊ID
	if (EpisodeID == ""){
		$.messager.alert("提示:","请先选择病人，再进行此操作！","warning");
		return;
	}
		
	
	var parLimit=String.fromCharCode(2);
	var tmpName="DHCEM_NurSeat";
	var printData="";
	runClassMethod("web.DHCEMPatientSeat","GetPrintSeatCard",{"AdmID":EpisodeID,"HospID":LgHospID},function(jsonString){
		printData=jsonString;
	},'json',false)
	if (printData=="") return;
	
	var LODOP = getLodop();
	LODOP.PRINT_INIT("CST PRINT");
	DHCP_GetXMLConfig("InvPrintEncrypt",tmpName);
	var myPara="";
	myPara="PatName"+String.fromCharCode(2)+printData.PatName;
	myPara=myPara+"^SeatNo"+String.fromCharCode(2)+printData.SeatNo;
	myPara=myPara+"^PatSex"+String.fromCharCode(2)+printData.PatSex;
	myPara=myPara+"^Loc"+String.fromCharCode(2)+printData.Loc;
	myPara=myPara+"^PatDate"+String.fromCharCode(2)+printData.UpdDate;
	myPara=myPara+"^PatTime"+String.fromCharCode(2)+printData.UpdTime;
	myPara=myPara+"^RegNoCode"+String.fromCharCode(2)+printData.PatNo;
	myPara=myPara+"^HospName"+String.fromCharCode(2)+printData.Hosp;
	myPara=myPara+"^RegNo"+String.fromCharCode(2)+printData.PatNo;
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
	LODOP.PRINT();
	
	return;
}	


function changeSeatView(obj){
	if(obj.value){
		$(".sickbed,.sickbedBorder").css({"height":"46px","transition":"height 0.2s"}); //45px
		$(".sickbedContent").css({"height":"42px","transition":"height 0.2s"}); //41px
		seatObj.seatHeight="46px"; //45px
	}else{
		$(".sickbed,.sickbedBorder").css({"height":"201px","transition":"height 0.2s"}); //220px
		$(".sickbedContent").css({"height":"197px","transition":"height 0.2s"}); //216px
		seatObj.seatHeight="201px"; //220px
	}
	return;
}

function changeSeatViewPosition(obj){
	if(obj.value){
		$('.seatClear').show();
		$('#transSeatArea').css("width",bedDivWidth+"px");
		$('.sickbed').each(function(){
			$(this).css("visibility")==="hidden"?$(this).removeCss("display"):"";
		})
	}else{
		$('.seatClear').hide();
		$('#transSeatArea').removeCss("width");
		$('.sickbed').each(function(){
			$(this).css("visibility")==="hidden"?$(this).hide():"";
		})
	}
	return;
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
	//$(".sickbed").css("zoom",qBarChangedValue); //hxy 2023-01-12 st
	$("#transSeatArea").css("zoom",qBarChangedValue);  //ed
}

function plantObsRoomBtn(){
	if($(".sickbed-selected").length){
		$(".sickbed-selected").click();	
	}
	ArrPatSeat();
}

function plantPatBtn(){
	if (!$("#"+lantNoPatSeatId).hasClass("sickbed-selected")){
		seatClickFun($("#"+lantNoPatSeatId),"plantPatBtn");
	}
	ArrPatSeat();
}


function clickQueryItm(_this){
	$("#filterValue").val("");
	
	if(!$(_this).hasClass("queryItmActive")){
		$(".queryItm").removeClass("queryItmActive");
	}
	$(_this).toggleClass("queryItmActive");
	
	///速度太慢走前台
	if($(".queryItmActive").length){
		if($(".queryItmActive").attr("filterType")=="HasNoExecOrd"){
			$(".sickbed").not(".hasSyOrd").hide();
			return;
		}
	}

	var filterValue = $(".queryItmActive").length?$(_this).attr("filterValue"):"";
	var filterType = $(_this).attr("filterType");
	againData(filterType,filterValue);
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

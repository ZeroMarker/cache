var dragFlag=true;   /// 拖动标记
var TmpTrsSeat = ""; /// 转移座位
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var defaultCardTypeDr //默认卡类型
$(function(){
	
	initParam();
	//初始化combobox
	initCombo(); 
	
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

function initPageDomMethod(){
	$("#patRegNo").bind('keypress',PatRegNo_KeyPress);
}

function initParam (){
	seatObj={
		seatWidth:210,
		seatHeight:45
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
	runClassMethod("web.DHCEMPatientSeat","SelAllBedNew",
	{'LocId':LgCtLocID,"PatRegNo":patRegNo},
	function(data){ 
		var noPerple = data.allSeat-data.useSeat;
		var str = data.text;
		var seatSize = data.size;
		var seatNorms = data.widAndHei;
		var row = seatSize.split("*")[0];
		var cow = seatSize.split("*")[1];
		seatObj.seatWidth = seatNorms.split("*")[0];
		seatObj.seatHeight = seatNorms.split("*")[1];
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
	var $BedDiv  = $('#lef-bottom');
	var bedHeight=seatObj.seatHeight==""?43:seatObj.seatHeight;
	seatObj.seatWidth!=""?$("#lef-bottom").css("width",(parseInt(seatObj.seatWidth)+12)*parseInt(cow)):$("#lef-bottom").css("width",222*parseInt(cow));
	$BedDiv.empty();
	for (i = 1; i <= row*cow; i++) {
		$("<div class='sickbed' style='visibility:hidden' id='sickbed" +i+"'>" +
			"<div style='height:100%;'>"+
				"<span class='posInline' id='bedName"+i+"' style='line-height:"+bedHeight+"px;width:35px;font-weight:700;padding-left:10px;'></span>"+
				"<span class='posInline' id='patName"+i+"' style='line-height:"+bedHeight+"px;width:80px;font-weight:700;'></span>"+
				"<span class='posInline' id='planDate"+i+"' style='line-height:"+bedHeight+"px;font-weight:700;'></span>"+
				"<span class='seat-btn-icon' id='patSexImg"+i+"'>&nbsp;</span>"+
				//"<span class='posInline' style='line-height:"+bedHeight+"px;'>01</span>"+
			"</div>"+
			"<div class='sickbedBorder hideItm' id='sickbedBorder"+i+"'>"+
				"<div id='seattitle'>"+
				"	<div class='patientNum' id='patientNum"+i+"'></div>" +
				"</div>" +
				"<div style='clear: both'></div>"+
				"<div class='patientBody' id='patientBody"+i+"'></div>" +
			"</div>"+
			"<div class='ArrangeBtn hideItm' id='ArrangeBtn"+i+"'></div>"+       //这个参数只为了存储数据
		 "</div>").appendTo($BedDiv); 
		if(i%cow==0&&i!=cow*row){
			$("<div style='clear:both'></div>").appendTo($BedDiv); 
		}
	}
	if(seatObj.seatWidth!=""){
		$('.sickbed').css('width',seatObj.seatWidth);
		$('.sickbed').css('height',seatObj.seatHeight);
	}else{
		$('.sickbed').css('width',210);
		$('.sickbed').css('height',45);	
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
		$("#obsPatTable").datagrid("load",{"LgLocID":LgLocID,"TmpPatNo":TmpPatNo}); 
		InitBedPage();
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
	var strArr = str.split("$$");
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
		$(".sickbed #ArrangeBtn"+num).attr("seatId",seatID);
		$(".sickbed #ArrangeBtn"+num).attr("seat",seatName);
		$("#sickbed"+num).css('visibility','visible');
		$(".sickbed #patientNum"+num).css("background-color",seatColor);
		$(".sickbed #ArrangeBtn"+num).attr("hasPat",hasPat);
		if(hasPat!="Y"){			
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
			
		}
		
	   if(hasPat=="YY"){ ///座位图被病人占用  yyt 2019-05-01
			var patName  = strArr[i].split("^")[8];
			var regNo  = strArr[i].split("^")[9];
			var PaAdmDate  = strArr[i].split("^")[10];
			var PaAdmTime  = strArr[i].split("^")[11];
			var PrvDoc  = strArr[i].split("^")[12];
			
			var sexHtmlStr=""
			sexHtmlStr = 			 '<div style="margin-top:5px;margin-left:8px;">';
			sexHtmlStr = sexHtmlStr +'<span style="color:red">'+"留观病人占用";
			sexHtmlStr = sexHtmlStr +'	</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"姓&nbsp;&nbsp;&nbsp;名："+ patName +'</span>';
			sexHtmlStr = sexHtmlStr + '</div style="margin-top:5px">';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"登记号："+ regNo +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"日&nbsp;&nbsp;&nbsp;期："+ PaAdmDate +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"时&nbsp;&nbsp;&nbsp;间："+ PaAdmTime +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"医&nbsp;&nbsp;&nbsp;生："+ PrvDoc +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';

			$(".sickbed #patientBody"+num).append(sexHtmlStr);
		    ///$("#sickbed"+num).find(".patientNum").addClass("onDraggable");
			
		}

		if(hasPat=="Y"){
			var admId  = strArr[i].split("^")[7];
			var patName  = strArr[i].split("^")[8];
			var cardNo  = strArr[i].split("^")[9]; 
			var patId  = strArr[i].split("^")[10]; 
			var regNo  = strArr[i].split("^")[11];
			var secretLev = strArr[i].split("^")[12];
			var patLev = strArr[i].split("^")[13];
			var patSex  = strArr[i].split("^")[14]; 
			var patAge  = strArr[i].split("^")[15]; 
			var patFei  = strArr[i].split("^")[16];
			var MRDiagnos = strArr[i].split("^")[17];
			var PatInDep = strArr[i].split("^")[18];
			var PaAdmTime = strArr[i].split("^")[19];   /// 新加 2019-03-04 bianshuai
			var MainDoc = strArr[i].split("^")[20];     /// 新加 2019-05-30 bianshuai
			var InSeatDateLimit = strArr[i].split("^")[21];
			var PatSexDesc = "";     //性别描述

			$(".sickbed #Transfuse"+num).attr("admId",admId);
			$(".sickbed #ArrangeBtn"+num).attr("regNo",regNo);
			$(".sickbed #ArrangeBtn"+num).attr("patName",patName);
			$(".sickbed #ArrangeBtn"+num).attr("cardNo",cardNo);
			$(".sickbed #Transfuse"+num).attr("patFlag","有人");
			$(".sickbed #Transfuse"+num).attr("regNo",regNo);
			$(".sickbed #ArrangeBtn"+num).attr("secretLev",secretLev);
			$(".sickbed #ArrangeBtn"+num).attr("patLev",patLev);
			$(".sickbed #ArrangeBtn"+num).attr("patId",patId);
			$(".sickbed #ArrangeBtn"+num).attr("admId",admId);
			
			var sexHtmlStr = "",sexIcon=""
			AllPersonNum++;
			if(patSex.trim()=="1"){  //男
				PatSexDesc="男";
				ManSeatNum++;
				sexIcon="pat_mannew";
			}else if(patSex.trim()=="2"){   //女
				PatSexDesc="女";
				WomanSeatNum++;
				sexIcon="pat_womannew";
			}else {							//未知
				PatSexDesc="未知";
				UnknownSeatNum++;
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
			sexHtmlStr = sexHtmlStr + '		<span>诊断：'+ MRDiagnos +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			//sexHtmlStr = sexHtmlStr + '		<span>'+ PaAdmTime +'</span>';
			sexHtmlStr = sexHtmlStr + '		<span>医生：'+ MainDoc+ '</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			$(".sickbed #patientBody"+num).append(sexHtmlStr);
			$(".sickbed #patientNum"+num).text(seatName);
			var seatShowName="";
			patName.length>5?seatShowName=patName.substring(0,5)+"..":seatShowName=patName;
			
			$(".sickbed #patName"+num).text(seatShowName);
			$(".sickbed #patSexImg"+num).addClass(sexIcon);
			$(".sickbed #planDate"+num).text(InSeatDateLimit);
			
			
			$("#sickbed"+num).find(".patientNum").addClass("onDraggable");
			
			$HUI.tooltip("#sickbed"+num,{
				position: 'bottom',
				trackMouse:true,
			    content:  
				    '<div style="color: #ffffff;">' +
	                '<div>姓名：'+patName+'</div>' +
	                '<div>年龄：'+patAge+'</div>' +
	                '<div>性别：'+PatSexDesc+'</div>' +
	                '<div>费别：'+patFei+'</div>' +
	                '<div>登记号：'+regNo+'</div>' +
	                '<div>诊断：'+MRDiagnos+'</div>' +
	                '<div>就诊科室：'+PatInDep+'</div>' +
	                '<div>就诊时间：'+PaAdmTime+'</div>' +
	                '<div>主管医生：'+MainDoc+'</div>' +
	                '</div>',
			    onShow: function(){
					
			    }	
			})
		}
	}
	
	
	
	$('#top_btn_no').html(noPerple);
	$('#top_btn_man').html("男人:"+ManSeatNum);
	$('#top_btn_woman').html("女人:"+WomanSeatNum);
	$('#top_btn_unman').html("未知:"+UnknownSeatNum);
	$('#top_btn_all').html(AllPersonNum);
	
	
	initSeatClick();
	initDragAndDrop();
	
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
			$(this).find(".sickbedBorder").css({"border":"2px solid #6b6fc7"});
		},
		onDragLeave: function(e,source){
			$(this).find(".sickbedBorder").css({'border':'1px solid #ccc'});
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
	
	   var hasPat=$(this).find(".ArrangeBtn").attr("hasPat") 	  
	   if(hasPat=="YY"){
		   $.messager.alert("提示","该座位已占用，不能分配！","warning");
		     return  
	   }
	   
		if(($(this).find(".ArrangeBtn").attr("patId")===undefined)&&(curSelSeat.patId!=="")){
			curSelSeat.seatRowId=$(this).find(".ArrangeBtn").attr("seatId");
			TmpTrsSeat=$(this).find(".ArrangeBtn").attr("seat");
			planModel="U";
			ArrPatSeat();  /// planPat();
			return;	
		}
	  
		if(!$(this).hasClass("sickbed-selected")&&$(".sickbed-selected").length){
			$(".sickbed-selected").toggleClass("sickbed-selected");
		}
		
		if($(this).hasClass("sickbed-selected")){
			clearCurSelSeat();	
		}
		
		$(this).toggleClass("sickbed-selected");
		
		//设置当前
		if($(this).hasClass("sickbed-selected")){
			var $obj=$(this).find(".ArrangeBtn");
			setCurSelSeat($obj);		
		}
		setEprMenuForm(curSelSeat.admId,curSelSeat.patId);
		///根据列表安排  yyt
		var SelData = $("#obsPatTable").datagrid("getSelections");  //加载面板
		if(($(this).find(".ArrangeBtn").attr("patId")===undefined)&&(SelData.length)){   //选中等候区病人再选中床位上病人
			$HUI.combobox("#UserTradeSeatBt").setValue($(this).find(".ArrangeBtn").attr("seat"));
			$('#SeatRowId').val($(this).find(".ArrangeBtn").attr("seatId"));
			$('#CardNum').val($(this).find(".ArrangeBtn").attr("CardNo"));	
			loadPlanPatWin(SelData)
			return;
		}
		checkOrUnCheck(obsPatTable.checkIndex)  //清除选中行

		return false;
	}).bind("contextmenu", function(e){
			/// 增加右键菜单 2019-02-21 bianshuai
			e.preventDefault(); //阻止浏览器捕获右键事件
			
			if (!$(this).hasClass("sickbed-selected")){
				$.messager.alert("提示","请先选择病人！","warning");
				return;
			}
//			if(curSelSeat.admId == ""){   //无人座位不能选中
//				return ;
//			}
			$HUI.menu('#menu').show({ 
	           //显示右键菜单  
	           left: e.pageX,//在鼠标点击处显示菜单  
	           top: e.pageY  
			});
	});
	event.stopPropagation();	
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
        str = "星期日";  
	} else if (week == 1) {  
        str = "星期一";  
	} else if (week == 2) {  
        str = "星期二";  
	} else if (week == 3) {  
        str = "星期三";  
	} else if (week == 4) {  
        str = "星期四";  
	} else if (week == 5) {  
        str = "星期五";  
	} else if (week == 6) {  
        str = "星期六";  
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

/// 读卡
function readCardNo(){

	runClassMethod ("web.DHCOPConfig","GetVersion",{},function(myVersion){
		
			if (myVersion=="12"){
				M1Card_InitPassWord();
   			}
   			
   			var CardTypeRowId = "";
			var CardTypeValue = $("#EmCardType").combobox("getValue");
			var m_CCMRowID=""
			if (CardTypeValue != "") {
				var CardTypeArr = CardTypeValue.split("^");
				m_CCMRowID = CardTypeArr[14];
				CardTypeRowId=CardTypeArr[0];
			}
			//var rtn=DHCACC_ReadMagCard(m_CCMRowID,"R", "2");  //QQA
			var rtn=DHCACC_GetAccInfo(CardTypeRowId,CardTypeValue);
   			var myary=rtn.split("^");
   			if (myary[0]!="0"){
	   			$.messager.alert("提示","卡无效!");
	   		}
			if ((myary[0]=="0")&&(myary[1]!="undefined")){
				$('#CardNum').val(myary[1]);
				GetValidatePatbyCard();
			}			
		},"text",false
	)


/* 	/// 卡类型ID
	var CardTypeRowId = "";
	var CardTypeValue = $("#EmCardType").val();
	
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardTypeValue);
	if (myrtn==-200){ //卡无效
		$.messager.alert("提示","卡无效-1!");
		return;
	}
	
	var myary = myrtn.split("^");
	var rtn = myary[0];
	
	switch (rtn) {
		case "0":
			//卡有效
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#CardNum').val(CardNo);
			$('#RegiNum').val(PatientNo);
			GetEmRegPatInfo();
			break;
		case "-200":
			//卡无效
			$.messager.alert("提示","卡无效!");
			break;
		case "-201":
			//现金
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#CardNum').val(CardNo);     /// 卡号
			$('#RegiNum').val(PatientNo);   /// 登记号
			GetEmRegPatInfo();
			break;
		default:
	} */
}


function M1Card_InitPassWord()
{
	try{
		var myobj=document.getElementById("ClsM1Card");
		if (myobj==null) return;
		var rtn=myobj.M1Card_Init();
  }catch(e)
  {
  	}
}

function GetValidatePatbyCard()
{
	
	var myCardNo = $('#CardNum').val();   //卡号
	var SecurityNo=""
	var myExpStr=""
	var CardTypeRowId=""
	
	var CardTypeValue =$("#EmCardType").combobox("getValue");

	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}

	runClassMethod("web.DHCBL.CARDIF.ICardRefInfo","ReadPatValidateInfoByCardNo",
		{'CardNO':myCardNo,
		 'SecurityNo':SecurityNo,
		 'CardTypeDR':CardTypeRowId,   //全局变量
		 'ExpStr':myExpStr
		},
		function(data){
			if (data=="") { return;}
			var myary=data.split("^");
			if(myary[0]=="0"){
				
			}else if(myary[0]=="-341"){
				runClassMethod("web.DHCEMPatientSeat","GetPatInfo",{'CardNo':$('#CardNum').val(),'RegNo':''},
					function(myData){
						var myDataArr= myData.split("^");
						if(myDataArr[0]=="0"){
						
								$("#RegiNum").val(myDataArr[2]);      /// 登记号;
								$("#PatId").val(myDataArr[3]);  /// 病人ID
								GetEmRegPatInfo("");
								return;
						}
					},"text"
				)
			}else{
				clearCurDropSeat();  //清空卡号信息
				switch(myary[0]){
					case "-340":
						$.messager.alert("提示","发卡时,此卡已经有对应的登记号了,不能在新增了");
						break;
					case "-350":
						$.messager.alert("提示","此卡已经使用,不能重复发卡!");
						break;
					case "-351":
						$.messager.alert("提示","此卡已经被挂失,不能使用!");
						break;
					case "-352":
						$.messager.alert("提示","此卡已经被作废?不能使用!");
						break;
					case "-356":
						$.messager.alert("提示","发卡时,配置要求新增卡记录,但是此卡数据被预先生成错误!");
						break;
					case "-357":
						$.messager.alert("提示","发卡时,配置要求更新卡记录,但是此卡数据没有预先生成!");
						break;
					case "-358":
						$.messager.alert("提示","发卡时,此卡已经有对应的登记号了,不能在新增了");
						break;
					default:
						$.messager.alert("Error Code:" +myary[0]);
						break;
				}
				
					
			}
			
		},"text",false
	)
}


function GetEmRegPatInfo(){
	runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
	    {'CardNo':'','RegNo':$('#RegiNum').val()},
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
	   'RegNo':RegNum
	}
	
    PatAdmInfo = MyRunClassMethod("web.DHCEMPatientSeat","GetCurrAdm",Datas); 
    if(PatAdmInfo==""){
	    $.messager.alert("提示",'病人没有就诊记录!'); 
		return false;
	}
	var PatientID = PatAdmInfo.split("^")[6];
	var EpisodeID = PatAdmInfo.split("^")[0];
	
	var Parr="^"+LgCtLocID+"^"+PatientID+"^"+EpisodeID+"^"+SeatRowId+"^"+LgUserID+"^"+"Y"+"^"+PrvDoc;
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
	}else if(curSelSeat.admId!=="有人"){
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
		    {'patCardNo':'','regNo':regNo},
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
	$HUI.combobox("#EmCardType",{
		url:LINK_CSP+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=CardTypeDefineListBroker",
		valueField:'value',
   		textField:'text',
   		onSelect:function(res){
	   		CarTypeSetting(res.value);
	   	}
	})
	
	
	/// 获取默认卡类型
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
        m_CCMRowID = CardTypeDefArr[14];
        if (CardTypeDefArr[16] == "Handle"){
	    	$('#CardNum').attr("readOnly",false);
	    }else{
			$('#CardNum').attr("readOnly",true);
		}
		$HUI.combobox("#EmCardType").setValue(defaultCardTypeDr);
	},'',false)
	
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
	    {'CardNo':'','RegNo':$('#RegiNum').val()},
		    function(data){
			    SettingModel(data);
			},"text",false);
	    }
	   });
	   
	$('#CardNum').on('keypress', function(e){     
       e=e||event;
       if(e.keyCode=="13"){
	     var CardNo = $('#CardNum').val()
	     if(CardNo==""){
		    $.messager.alert("提示","卡号为空");
		    CleanModel();
		 	return
		 }
		 
		var CardNoLen = CardNo.length;

		if (m_CardNoLength < CardNoLen){
			$.messager.alert("提示","卡号输入错误,请重新录入！");
			CleanModel();     
			return;
		}

		/// 卡号不足位数时补0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		 
		$('#CardNum').val(CardNo);
		runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
	    {'CardNo':CardNo,'RegNo':''},
		    function(data){
			   SettingModel(data);
			},"text",false);
       }
	});	   
}    

//设置Model模板数据    
function SettingModel(data){
	
	NoPatCleanModel();	 ///先清除一波数据
	
	if(data=="-1"){
		$.messager.alert("提示","未找到该病人!");	
		return;
	}
	
	if(data=="-2"){
		$.messager.alert("提示","病人当前无就诊信息!");	
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
	var seatRowId = ($obj.attr("seatId")==""||$obj.attr("seatId")==undefined)?arguments[0]:$obj.attr("seatId");
	var seat = ($obj.attr("seat")==""||$obj.attr("seat")==undefined)?arguments[0]:$obj.attr("seat");
	var regNo = ($obj.attr("regNo")==""||$obj.attr("regNo")==undefined)?"":$obj.attr("regNo");
	var patName = ($obj.attr("patName")==""||$obj.attr("patName")==undefined)?"":$obj.attr("patName");
	var cardNo = ($obj.attr("cardNo")==""||$obj.attr("cardNo")==undefined)?"":$obj.attr("cardNo");
	var secretLev = ($obj.attr("secretLev")==""||$obj.attr("secretLev")==undefined)?"":$obj.attr("secretLev");
	var patLev = ($obj.attr("patLev")==""||$obj.attr("patLev")==undefined)?"":$obj.attr("patLev");
	var patId=($obj.attr("patId")==""||$obj.attr("patId")==undefined)?"":$obj.attr("patId");
	var admId=($obj.attr("admId")==""||$obj.attr("admId")==undefined)?"":$obj.attr("admId");
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
	
	$('#RegiNum').val("") ;    
	$('#UserName').val("");
	$('#CardNum').val("");
	$('#UserSecRank').val("");
	$('#UserRank').val("");
	$('#patId').val("");
	$('#PaAdm').val("");
	$('#SeatRowId').val("");
	$HUI.combobox("#PatSeatNo").enable();
	$HUI.combobox("#PatSeatNo").setValue("");
	$HUI.combobox("#UserTradeSeatBt").enable();
	$HUI.combobox("#UserTradeSeatBt").setValue("");
	$HUI.combobox("#PrvDoc").setValue("");
	
	//$HUI.combobox("#EmCardType").setValue("");
	
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
			$("#waitNumber").html(data.total);
        },
        onClickRow: function (index, rowData){   //yyt
			$(".sickbed").removeClass("sickbed-selected");
			clearCurSelSeat();
         	checkOrUnCheck(index);
         	checkOrUnCheckSeat($(this));
         	setEprMenuForm(rowData.EpisodeID,rowData.PatientID);
	    }
	}
	
   	/// 就诊类型
	var uniturl = $URL+"?ClassName=web.DHCEMPatientSeat&MethodName=JsLocPatWaitArea&LgLocID="+ LgLocID;
	new ListComponent('obsPatTable', columns, uniturl, option).Init();
}

/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex){
	
	var tooltipStr =rowData.PatName+","+rowData.PatSex+","+rowData.PatAge+","+rowData.BillType;
	var htmlstr =  	    '<div class="celllabel onDraggable1" title="'+tooltipStr+'" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.EpisodeID+'">'
	var htmlstr = htmlstr +'<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">';
	var htmlstr = htmlstr + rowData.PatName + '</span>';
	var htmlstr = htmlstr + '<span class="l-btn-text" style="color:#ccc;margin-left:1px;padding:0">' + rowData.PatNo + '</span>';

	if(rowData.PatSex=="男"){
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_man">&nbsp;</span>';
	}else if(rowData.PatSex=="女"){
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
		if(curSelSeat.admId!="") EpisodeID = curSelSeat.admId;   
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
	window.open(LinkUrl,'生命体征','top=25,left=25,width='+(window.screen.availWidth-50)+',height='+(window.screen.availHeight-50));
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
	window.open(LinkUrl,'护士执行','top=25,left=25,width='+(window.screen.availWidth-50)+',height='+(window.screen.availHeight-50));
}

/// 安排 bianshuai 2019-02-21
function ArrPatSeat(){
	CleanModel();  		 /// 清空面板数据
	$HUI.window("#wind").open();
	var EmCardType =$("#EmCardType").combobox("getValue");
	$HUI.combobox("#EmCardType").setValue(defaultCardTypeDr);  //默认卡类型	
	//if(EmCardType==""){   
	//	$HUI.combobox("#EmCardType").setValue(defaultCardTypeDr);  //默认卡类型	
	//}
	
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
	var frm = dhcsys_getmenuform();
	if((frm) &&(frm.EpisodeID.value != adm)){
		frm.EpisodeID.value = ""; 			//DHCDocMainView.EpisodeID;
		frm.PatientID.value = papmi; 		//DHCDocMainView.PatientID;
		if(frm.AnaesthesiaID) frm.AnaesthesiaID.value = "";
		if(frm.PPRowId) frm.PPRowId.value = "";
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
		if (jsonObject.CardTypeID != ""){
			GetEmPatCardTypeDefine(jsonObject.CardTypeID);  ///  设置卡类型
		}
	}
}

/// 获取病人对应卡类型数据
function GetEmPatCardTypeDefine(CardTypeID){

	runClassMethod("web.DHCEMPatCheckLevCom","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#CardNum').attr("readOnly",false);
			}else{
				$('#CardNum').attr("readOnly",true);
			}
			m_CardNoLength = CardTypeDefArr[17];   /// 卡号长度
			m_CCMRowID = CardTypeDefArr[14];
			$("#EmCardType").combobox("setValue",CardTypeDefine);
		}
	},'',false)
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
	runClassMethod("web.DHCEMPatientSeat","UpdPrvDoc",{"Loc":LgLocID,'EpisodeID':EpisodeID,'ChargDoc':ChargDoc},
	  function(data){
         if(data=="0"){ 
             $.messager.alert("提示:","修改成功！","success");
             $HUI.window("#DocWin").close();
             InitBedPage();
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
		 var selItems = $("#obsPatTable").datagrid('getSelections')  // yyt 2019-04-27  选中列表安排座位
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


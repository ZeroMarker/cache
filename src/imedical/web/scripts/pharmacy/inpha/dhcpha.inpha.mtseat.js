/*
模块:		移动药房
子模块:		移动药房-待摆药病区列表
Creator:	hulihua
CreateDate:	2016-10-07
*/

$(function(){
	/* 初始化插件 start*/
	//时钟显示
	beginrefresh();
	setInterval("beginrefresh()",1000);
	
    //初始化界面，病区的生成
    InitWardSeatPage(); 
    /* 初始化插件 end*/
    
    /* 绑定按钮事件 start*/
    AutoRefresh();
    
	$("#btn_set").on("click",function(){
		$("#modal-windowset").modal('show');
		$("#modal-windowset").draggable();	//实现窗口的移动
		InitWardSeatSet();
	});
    /* 绑定按钮事件 end*/
    if(window.screen) {
	    window.moveTo(0, 0);          
    	window.resizeTo(screen.availWidth, screen.availHeight);   
    }
     
    var wscript = new ActiveXObject("WScript.Shell"); 
    wscript.SendKeys("{F11}");  
})

//调用后台获取上一次设置的数据填充设置框！
function InitWardSeatSet() {
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){ 
		var seatSize = data.size;
		var row = seatSize.split("*")[0];
		var col = seatSize.split("*")[1];
		$('#sel-row').val(row);
		$('#sel-col').val(col);
	});	
}

function InitWardSeatPage() {
	//调用方法执行后台代码
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){ 
		var seatSize = data.size;
		var row = seatSize.split("*")[0];
		var col = seatSize.split("*")[1];
		var str = data.text;
		initWardSeat(row,col);  			//初始化病区
		initWardSeatText(row,col,str,"0");  //病区中显示的内容	
	});	
}

//定时刷新病区列表上面的数值
function AutoRefresh(){
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){ 
		var seatRefreshTime = data.refreshtime;
		var RefreshTime=parseInt(seatRefreshTime*1000);
		setInterval("RefreshWardSeat()",RefreshTime);
	});	
}

function RefreshWardSeat() {
	runClassMethod("web.DHCINPHA.MTWardSeat.SetWardConfig","SelAllWardSeatInfo",
	{'params':gGroupId+"^"+gLocId+"^"+gUserID},
	function(data){
		var seatSize = data.size;
		var row = seatSize.split("*")[0];
		var col = seatSize.split("*")[1];
		var str = data.text;
		initWardSeatText(row,col,str,"1");  
	});	
}

//初始化床
function initWardSeat(row,col){
	var a=($(window).width()-40)/col;    	//病区列表的宽
	var b=($(window).height()-10)/row;    	//病区列表的高
	var $BedDiv  = $('#lef-bottom');
	for (i = 1; i <= row*col; i++) {
		$("<div class='sickbed' style='visibility:false;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin:2px;float:left;border:2px solid #C1C1C1;width:"+a+"px;height:"+b+"px;border-radius:3px;' id='sickbed" +i+"'>" +
			"<div class='seattitle' style='height:"+(b-120)+"px;line-height:"+(b-120)+"px;text-align:center;margin-bottom:0px;margin-left:0px;background-color:#AEAEAE;' id='seattitle"+i+"'></div>"+
			"<div style='clear: both'></div>" +
			"<div class='patientBody' id='patientBody"+i+"'>"+
				"<div style='width:100%' >"+
					"<div style='float:left;width:50%;height:55px;text-align:center;line-height:35px;border-right:1px solid #C1C1C1;font-size:32px;' id='songyao"+i+"'></div>" +
					"<div style='float:right;width:50%;height:55px;text-align:center;line-height:35px;font-size:32px;' id='quyao"+i+"'></div>" +
				"</div>"+
				"<div style='width:100%' >"+
					"<div style='float:left;width:50%;height:60px;text-align:center;line-height:35px;border-top:1px solid #C1C1C1;border-right:1px solid #C1C1C1;font-size:32px;' id='duma"+i+"'></div>"+
					"<div style='float:right;width:50%;height:60px;text-align:center;line-height:35px;border-top:1px solid #C1C1C1;font-size:32px;' id='jingshen"+i+"'></div>"+
				"</div>"+
			"</div>"+
		"</div>").appendTo($BedDiv); 
		
		if(i%col==0&&i!=col*row){
			$("<div style='clear:both'></div>").appendTo($BedDiv); 
		}
	}	
	$("<div style='clear: both'></div>").appendTo($BedDiv); //清除浮动
	if(col=="6"){
		$('.sickbed').css('width','16.2%');
	}
	else if(col=="5"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="4"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="3"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="2"){
		$('.sickbed').css('width','16.5%');
	}
	else if(col=="1"){
		$('.sickbed').css('width','16.5%');
	}
	else{
		$('.sickbed').css('width',a+'px');
		//var bodyWidth=145*col+"px";
		//$('body').css({'width':bodyWidth,'overflow-x':'auto'})
	}	
}

///病区列表中显示数据
///WardCode_"^"_WardDesc_"^"_WardLoc_"^"_WardId
function initWardSeatText(row,cow,str,type){
	var strArr = str.split("$$");
	var num=0
	for(i=0;i<strArr.length-1;i++){
		var seatWardCode=strArr[i].split("^")[1];	//病区代码
		var seatWardDesc=strArr[i].split("^")[2];	//病区名称
		var seatWardLoc=strArr[i].split("^")[3];	//病区LocID
		var seatWardId=strArr[i].split("^")[4];		//病区ID
		var SendDrugNum=strArr[i].split("^")[5];	//送药请领单张数
		var TakeDrugNum=strArr[i].split("^")[6];	//取药请领单张数
		var ToxAnesDrugNum=strArr[i].split("^")[7];	//毒麻请领单张数
		var PsychoDrugNum=strArr[i].split("^")[8];	//精神请领单张数
		var AuditConFlag=strArr[i].split("^")[9];	//领药审核确认标志
		var num=num+1;	
		//填充病区标题和相关条件改变背景色！
		//$(".sickbed #seattitle"+num).append('&nbsp;&nbsp;<span style="font-family:华文行楷; font-size:30px; color:#000000;">'+seatWardCode+'</span>'); 
		if(type=="0"){
			$(".sickbed #seattitle"+num).append('&nbsp;&nbsp;<span style="font-family:微软雅黑; font-size:36px; font-weight:bold; color:#000000;">'+seatWardCode+'</span>'); 
			$("#sickbed"+num).css('visibility','visible');
		}	

		//病区背景颜色的控制
		if(AuditConFlag=="1"){
			$("#seattitle"+num).css("background-color","#F36D6A");
		}else{
			$("#seattitle"+num).css("background-color","#AEAEAE");
		}
		 
		//将界面为0的全部变为空！
		if(SendDrugNum=="0"){
			SendDrugNum="";
		}
		if(TakeDrugNum=="0"){
			TakeDrugNum="";
		}
		if(ToxAnesDrugNum=="0"){
			ToxAnesDrugNum="";
		}
		if(PsychoDrugNum=="0"){
			PsychoDrugNum="";
		}
		//将请领单张数放在界面位置并控制背景色！
		$(".sickbed #songyao"+num).text(SendDrugNum);
		if(SendDrugNum!=""){
			$("#songyao"+num).css("color","#F88C7C");
		}
		$(".sickbed #quyao"+num).text(TakeDrugNum);
		if(TakeDrugNum!=""){
			$("#quyao"+num).css("color","#64BF01");
		}
		$(".sickbed #duma"+num).text(ToxAnesDrugNum);
		if(ToxAnesDrugNum!=""){
			$("#duma"+num).css("color","#582F78");
		}
		$(".sickbed #jingshen"+num).text(PsychoDrugNum);
		if(PsychoDrugNum!=""){
			$("#jingshen"+num).css("color","#FFB400");
		}
		
		//绑定需要传入到弹框里面的值！
		$(".sickbed #seattitle"+num).attr("seatWardLoc",seatWardLoc);
		$(".sickbed #seattitle"+num).attr("seatWardCode",seatWardCode);	
		$(".sickbed #seattitle"+num).attr("SendDrugNum",SendDrugNum);
		$(".sickbed #seattitle"+num).attr("TakeDrugNum",TakeDrugNum);
		$(".sickbed #seattitle"+num).attr("ToxAnesDrugNum",ToxAnesDrugNum);
		$(".sickbed #seattitle"+num).attr("PsychoDrugNum",PsychoDrugNum);
		
		//请领单列表
		InitGirdReqDispList();
	}
	 
	//切换选择样式！
	$('.sickbed').unbind("click"); 
	$('.sickbed').click(function(){
		$(".sickbed-selected").each(function(){
			$(this).removeClass("sickbed-selected")	
		})
		$(this).addClass("sickbed-selected");
		//弹出病区请领单列表窗口！
		ShowWinReq();			
		return false;		
	});	
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
	var str="";
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
	//日期格式走配置
	var timestr = "";
	runClassMethod("web.DHCINPHA.MTCommon.CommonUtil","DateFormat", 
			{},
			function(data){
				if(data==3){
					timestr = y+"-"+m+"-"+d+" "+h+":"+M+"";
			    }else if(data==4){
				    timestr = d+"/"+m+"/"+y+" "+h+":"+M+"";
				}else{
					return ;
				}
					var showtimestr= timestr+"&nbsp&nbsp&nbsp&nbsp"+str;
				  	$("#showNowTime").html(showtimestr);	
	});			
}

function ShowWinReq(){
	var $obj=$(".sickbed-selected").find(".seattitle");
	var SendDrugFlag = ($obj.attr("SendDrugNum")==""||$obj.attr("SendDrugNum")==undefined)?"":$obj.attr("SendDrugNum");
	var TakeDrugFlag = ($obj.attr("TakeDrugNum")==""||$obj.attr("TakeDrugNum")==undefined)?"":$obj.attr("TakeDrugNum");
	var ToxAnesDrugFlag = ($obj.attr("ToxAnesDrugNum")==""||$obj.attr("ToxAnesDrugNum")==undefined)?"":$obj.attr("ToxAnesDrugNum");
	var PsychoDrugFlag = ($obj.attr("PsychoDrugNum")==""||$obj.attr("PsychoDrugNum")==undefined)?"":$obj.attr("PsychoDrugNum");
	if((SendDrugFlag=="")&&(TakeDrugFlag=="")&&(ToxAnesDrugFlag=="")&&(PsychoDrugFlag=="")){
		CleanModel();
		RefreshWardSeat();
		dhcphaMsgBox.alert("亲，你选择的病区没有请领单哦!") ;
		$("#modal-windowinreqlist").modal('show');
		return false;
	}else{
		$("#modal-windowinreqlist").modal('show');
		$("#modal-windowinreqlist").draggable();	//实现窗口的移动
    	$("#modal-windowinreqlist").css("overflow", "hidden"); // 防止出现滚动条，出现的话，你会把滚动条一起拖着走的
	}
	
	//初始化日期控件
    var opt = {
        preset: 'date', 		//日期
        //theme: 'android', 		//皮肤样式
        display: 'bubble', 		//显示方式 
        //mode: 'clickpick', 		//日期选择模式
        dateFormat: 'yy-mm-dd', // 日期格式
        setText: '确定', 		//确认按钮名称
        cancelText: '取消',		//取消按钮名称
        dateOrder: 'yymmdd', 	//面板中日期排列格式
        dayText: '日', 
        monthText: '月', 
        yearText: '年', 		//面板中年月日文字
        endYear:2100 			//结束年份
    }; 
    $('#startdate').mobiscroll(opt);
    $('#enddate').mobiscroll(opt);
	
	//给日期控件赋初始化值！
	var configstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaflag",gLocId);
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	startdate=FormatDateYMD(startdate);
	enddate=FormatDateYMD(enddate);
	$('#startdate').val(startdate);
	$('#enddate').val(enddate);
	
	//添加病区标题！
	var WardCode = ($obj.attr("seatWardCode")==""||$obj.attr("seatWardCode")==undefined)?"":$obj.attr("seatWardCode");
	$('#title-ward').text(WardCode);
	
	//控制弹出的框是否可以编辑选择的勾！
	if(SendDrugFlag==""){
		$('#chk-senddrug').iCheck('disable')
	}else{
    	$('#chk-senddrug').iCheck('enable');
    } 
	if(TakeDrugFlag==""){
		$('#chk-takedrug').iCheck('disable');
	}else{
    	$('#chk-takedrug').iCheck('enable');
    }
	if(ToxAnesDrugFlag==""){
		$('#chk-toxanesdrug').iCheck('disable');
	}else{
    	$('#chk-toxanesdrug').iCheck('enable');
    }
	if(PsychoDrugFlag==""){
		$('#chk-psychodrug').iCheck('disable');
	}else{
    	$('#chk-psychodrug').iCheck('enable');
    }

	//给请领单列表赋值！
	QueryReqDispList();
}

//初始化请领单列表table
function InitGirdReqDispList(){
	var columns=[
		{header:'ID',index:'TPhRid',name:'TPhRid',hidden:true},
		{header:'请领单号',index:'TInphReqNo',name:'TInphReqNo',width:230,align:'left',
			formatter:function(cellvalue, options, rowObject){
			    return "<a onclick=\"ShowInphReqNoItemWindow("+rowObject.TPhRid+")\" style='text-decoration:underline;'>"+cellvalue+"</a>";
			}
		},
		{header:'请领类型',index:'TInphReqType',name:'TInphReqType',width:60,align:'left'}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url:LINK_CSP+'?ClassName=web.DHCINPHA.MTWardSeat.GetReqDispQuery&MethodName=GetInPhReqNoList',		
	    height: 350,
	    multiselect: false,
	    //autowidth: true,
	    shrinkToFit: true,
	    gridComplete:function(){
    		$(this).parents(".ui-jqgrid-bdiv").css("overflow-x","hidden");
	    }
	};
	
	$("#grid-reqsenddrug").dhcphaJqGrid(jqOptions);
	$("#grid-reqtakedrug").dhcphaJqGrid(jqOptions);
	$("#grid-reqtoxanesdrug").dhcphaJqGrid(jqOptions);
	$("#grid-reqpsychodrug").dhcphaJqGrid(jqOptions);
}

//请领单明细信息窗口
function ShowInphReqNoItemWindow(inphReqId){
	var columns=[
		{header:'药品名称',index:'TArcimDesc',name:'TArcimDesc',align:'left'},
	    {header:'处方号',index:'TPrescno',name:'TPrescno'},
		{header:'请领数量',index:'TDspQty',name:'TDspQty'},
		{header:'单位',index:'TDspUom',name:'TDspUom'},
		{header:'登记号',index:'TPatNo',name:'TPatNo'},
		{header:'病人姓名',index:'TPatName',name:'TPatName'},
		{header:'床号',index:'TBedNo',name:'TBedNo'},
		{header:'要求执行时间',index:'TDspDate',name:'TDspDate'}
	]; 
	var jqOptions={
	    colModel: columns, //列
	    url: LINK_CSP+'?ClassName=web.DHCINPHA.MTWardSeat.GetReqDispQuery&MethodName=GetInPhReqItemById', //查询后台
	    height: '120%',
	    autowidth:true,
	    datatype:'local'
	};
	$("#grid-inphreqitem").dhcphaJqGrid(jqOptions);
	$("#modal-getinphreqitem").on('shown.bs.modal', function () {
		$("#grid-inphreqitem").setGridWidth($("#modal-getinphreqitem .modal-body").width())
		$("#grid-inphreqitem").HideJqGridScroll({hideType:"X"});		
	});
	$("#grid-inphreqitem").setGridParam({
		datatype:'json',
		page:1,
		postData:{
			params:inphReqId
		}
	}).trigger("reloadGrid")
	$('#modal-getinphreqitem').modal('show');
	$("#modal-getinphreqitem").draggable();	//实现窗口的移动
    $("#modal-getinphreqitem").css("overflow", "hidden"); // 防止出现滚动条，出现的话，你会把滚动条一起拖着走的
}

//关闭弹出请领单明细窗口
function CloseReqItem(){
	$('#modal-getinphreqitem').modal('hide');
}

//关闭弹出病区请领单窗口
function CloseReqListWin(){
	CleanModel();
	$('#modal-windowinreqlist').modal('hide');
	RefreshWardSeat();
}
 
//点击确认固化请领单打印标签
function ConfSoliInPhReq(){
	//先判断四个类型的勾是否至少有一个！
	if ($('#chk-senddrug').is(':checked')||$('#chk-takedrug').is(':checked')||$('#chk-toxanesdrug').is(':checked')||$('#chk-psychodrug').is(':checked')){	
		//组合已经选中的类型的请领单串！
		var phridstr1="";phridstr2="";
		if($('#chk-senddrug').is(':checked')){
			var senddrugphridstr=GetInPhReqNoStr("#grid-reqsenddrug");
			phridstr1=senddrugphridstr;
		}
		if($('#chk-takedrug').is(':checked')){
			var takedrugphridstr=GetInPhReqNoStr("#grid-reqtakedrug");
			phridstr2=takedrugphridstr;
		}
		if($('#chk-toxanesdrug').is(':checked')){
			var toxanesdrugphridstr=GetInPhReqNoStr("#grid-reqtoxanesdrug");
			if(phridstr2==""){
				phridstr2=toxanesdrugphridstr;
			}else{
				phridstr2=phridstr2+"^"+toxanesdrugphridstr;
			}
		}
		if($('#chk-psychodrug').is(':checked')){
			var psychodrugphridstr=GetInPhReqNoStr("#grid-reqpsychodrug");
			if(phridstr2==""){
				phridstr2=psychodrugphridstr;
			}else{
				phridstr2=phridstr2+"^"+psychodrugphridstr;
			}
		}
		if((phridstr1=="")&&(phridstr2=="")){
			dhcphaMsgBox.alert("您所选的类型目前没有对应的请领单，请核实!") ;
			return;
		}
		var phridstr=phridstr1+"#"+phridstr2;
		var PrintInPhReqConNoStr=TempSaveInPhReq(phridstr);
		
		PrintInPhReqLabel(PrintInPhReqConNoStr);
		CloseReqListWin();
		
	}else{
		dhcphaMsgBox.alert("您没有选中请领单类型，请核实!") ;
		return;
	}
}

//后台固化请求单并返回固化的关联单号
function TempSaveInPhReq(phridstr){
	var InPhReqConNoStr=tkMakeServerCall("web.DHCINPHA.MTWardSeat.GetReqDispQuery","SaveInPhReqTmpConNo",phridstr)
	if(InPhReqConNoStr==""){
		dhcphaMsgBox.alert("固化请领单失败，请核实!") ;
		return;
	}else{
		return InPhReqConNoStr;
	}
}

//打印固化请领单的标签
function  PrintInPhReqLabel(PrintConNoStr){
	var PrintConNoStrArr = PrintConNoStr.split("$$");
	for(j=0;j<PrintConNoStrArr.length;j++){
		var InPhReqConNo=PrintConNoStrArr[j];
		var PrintInfoStr=tkMakeServerCall("web.DHCINPHA.MTWardSeat.GetReqDispQuery","GetPrintLabelInfo",InPhReqConNo,gLocId);
		if(PrintInfoStr==""){
			continue;
		}else{
			PrintInPhLabel(PrintInfoStr,InPhReqConNo);
		}		
	}
}

//获取界面上显示的请领单的单号串！
function GetInPhReqNoStr(grid){
	var tmpphridstr="";
	var dispgridrows=$(grid).getGridParam('records');
	for(var i=1;i<=dispgridrows;i++){
		var tmpselecteddata=$(grid).jqGrid('getRowData',i)
		var tmpphrid=tmpselecteddata["TPhRid"];
		if(tmpphridstr==""){
			tmpphridstr=tmpphrid;
		}else{
			tmpphridstr=tmpphridstr+"^"+tmpphrid;
		}
	}
	return tmpphridstr;
}
 
//关闭设置窗口
function CloseSeatSetWin(){
	$('#modal-windowset').modal('hide');
}

//请领单查询
function QueryReqDispList(){
	var startdate=$("#startdate").val();
	var enddate=$("#enddate").val();	
	var $obj=$(".sickbed-selected").find(".seattitle");
	var wardlocid = ($obj.attr("seatWardLoc")==""||$obj.attr("seatWardLoc")==undefined)?"":$obj.attr("seatWardLoc");
	
	var inphreqtypestr="1^2^3^4";
	var gridstr="#grid-reqsenddrug&#grid-reqtakedrug&#grid-reqtoxanesdrug&#grid-reqpsychodrug"
	var strlen = inphreqtypestr.split("^");
	for(i=0;i<strlen.length;i++){
		var inphreqtype=inphreqtypestr.split("^")[i];
		var grid=gridstr.split("&")[i];
		
		var params=startdate+"^"+enddate+"^"+gLocId+"^"+wardlocid+"^"+inphreqtype;
		
		$(grid).setGridParam({
			datatype:'json',
			postData:{
				'params':params
			}
		}).trigger("reloadGrid");
		
	}		 	 
}

//保存设置数据
function SaveSeatSetData(){
	var seltime=$("#sel-time").val();
	var selcustomtime=$("#sel-customtime").val();
	var selrow=$("#sel-row").val();
	var selcol=$("#sel-col").val();
	var refreshtime=seltime;
	if(refreshtime==""){
		refreshtime=selcustomtime;	
	}
	var InPut=selrow+"*"+selcol+"^"+refreshtime;
	var retval=tkMakeServerCall("web.DHCINPHA.MTWardSeat.SetWardConfig","SaveSetWardSeat",InPut,gLocId);
	if(retval=="0"){
		dhcphaMsgBox.alert("设置成功！");
		CloseSeatSetWin();
		$('#lef-bottom div.sickbed').remove();	
	}
	InitWardSeatPage();
}

function CleanModel(){	
	$('#seatWardLoc').val("") ;    
	$('#seatWardCode').val("");
	$('#title-ward').text("");
	$('#chk-senddrug').iCheck('uncheck');
	$('#chk-takedrug').iCheck('uncheck');
	$('#chk-toxanesdrug').iCheck('uncheck');
	$('#chk-psychodrug').iCheck('uncheck');
	$("#grid-reqsenddrug").clearJqGrid();
	$("#grid-reqtakedrug").clearJqGrid();
	$("#grid-reqtoxanesdrug").clearJqGrid();
	$("#grid-reqpsychodrug").clearJqGrid();
}  

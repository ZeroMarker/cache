/// Creator: congyue
/// CreateDate: 2017-09-29
//  Descript: 首页

var url = "dhcadv.repaction.csp";
var StrParam="";
var StDate="";
var EndDate="";
$(function(){
	InitPageComponent(); 	  /// 初始化界面控件内容
	InitPageDataList();		  /// 初始化页面表格,图形分析 数据
	InitPageStyle();          /// 初始化页面样式
})
/// 初始化界面控件内容
function InitPageComponent(){
	 //hxy 2017-09-05 填报、统计、查询点击后显示面板的隐藏
	 $("#w_click_show,#c_click_show,#s_click_show").mouseleave(function(){
	   $(this).hide();
	 });
	$("#gologin").hide(); //2017-11-23 cy 隐藏首页按钮
	/* var myDate = new Date();
	if(DateFormat=="4"){ //日期格式 4:"DMY" DD/MM/YYYY
		StDate="01"+"/"+"01"+"/"+"2018";  //当年开始日期
		EndDateByYear="31"+"/"+"12"+"/"+myDate.getFullYear()
	}else if(DateFormat=="3"){ //日期格式 3:"YMD" YYYY-MM-DD
		StDate="2018"+"-"+"01"+"-"+"01";  //当年开始日期
		EndDateByYear=myDate.getFullYear()+"-"+"12"+"-"+"31"
	}else if(DateFormat=="1"){ //日期格式 1:"MDY" MM/DD/YYYY
		StDate="01"+"/"+"01"+"/"+"2018";  //当年开始日期
		EndDateByYear="12"+"/"+"31"+"/"+myDate.getFullYear()
	} */
	if((LgGroupDesc=="护理部")||(LgGroupDesc=="Nursing Manager")){
		$('#cancel').show();  //其他查询界面链接展现
	}else{
		$('#cancel').hide(); 
	} 
	runClassMethod("web.DHCADVCOMMON","GetStaEndDate",{'LgParam':LgParam},function(data){
		var tmp=data.split("^"); 
		StDate=tmp[0];
		EndDate=tmp[1];
	},'',false)
}

/// 初始化页面表格,图形分析 数据
function InitPageDataList(){
	var DateList=StDate+"^"+EndDate;
	StaticbyType(DateList);//不良事件按类型统计
	StaticbyMon(DateList); //不良事件按月统计
	WardInfo(DateList); //初始化统计列表  病区分布
}
/// 初始化页面样式
function InitPageStyle(){
	 //hxy 2017-09-05 填报、统计、查询点击后面板的自适应位置
	 $("#w_click_show").css("left",102+($(window).width()-1164)/2);
	 $("#w_click_show,#c_click_show,#s_click_show").css("top",95);//2017-10-12 add 兼容ie8(仅)
	 $("#c_click_show").css("left",507+($(window).width()-1164)/2);
	 $("#s_click_show").css("left",900+($(window).width()-1164)/2);
	 //hxy 2017-08-21 控制小数字自适应padding
	 $(".index-function-button-one i").each(function(){
	    if($(this).text()!=""){
		    $(this).addClass("index-function-button-num")
		}else{
 			$(this).next().css("margin-top","17px");//hxy 2017-09-29
		}
	 });
	 $(".index-function-button-two i").each(function(){
	    if($(this).text()!=""){
		    $(this).addClass("index-function-button-num")
		}else{
			$(this).parent().find("p").css("margin-top","17px");//09-29 动态赋值数字后有上下偏移
		}
	 });//hxy end	
}
// 待办报告初始化列表
function UntreatedInfo(param){
		//定义columns
	var columns=[[
		{field:'name',title:$g("报告类型"),width:150,align:'center'},
		{field:'value',title:$g("报告数量"),width:150,align:'center'}
	]];
	//定义datagrid
	$('#untreated').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=UntreatedList'+'&param='+param,
		//url:'',
		fit:true,
		columns:columns,
		rownumbers:true,
	    singleSelect:false,
		loadMsg: $g("正在加载信息..."),
		showFooter:true,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#untreated");//初始化显示横向滚动条
	}

//初始化统计列表
function WardInfo(param)
{
	//定义columns
	var columns=[[
		{field:"name",title:$g("病区/科室"),width:150,align:'center',sortable:true},
		{field:'reptype',title:$g("报告类型"),width:150,align:'center'},
		{field:'value',title:$g("报告数量"),width:150,align:'center'}
	]];
	//定义datagrid
	$('#warddg').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=StaticPreAlert'+'&params='+param+'&LgParam='+LgParam,
		fit:true,
		columns:columns,
		rownumbers:true,
		remoteSort:false,  //问题所在
		sortName:'name',
		sortOrder:'asc',
	    singleSelect:false,
		loadMsg: $g("正在加载信息..."),
		showFooter:true,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],
		pagination:true
	});
	initScroll("#warddg");//初始化显示横向滚动条
	
}

//获取当前日期
function CurentTime()
{ 
	var now=new Date();
	var year=now.getFullYear();  //年
	var month=now.getMonth() + 1;  //月
	var day=now.getDate();  //日
	var clock=year+"-";
	
	if(month<10)
	clock+="0";
	clock+=month+"-";
	if(day<10)
	clock+="0";
	clock+=day;
 	return(clock);
}
///事件填报 联动
function JumpBtn(){
	$("#w_click_show").show();
	var UserList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+LgHospID;
    $.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRepTypeByWFList'+'&UserList='+UserList,		
		async: false, //同步
		dataType: "json", 
		success: function(data){
		var htmlname='<img style="margin-top:-30px" src="../scripts/dhcadvEvt/images/adv_top.png" alt="" width="28" height="28">';
		    var htmlstr = "";
			for (var i=0; i<data.length; i++){
		        htmlstr = htmlstr +'<div class="w_click_row"><div class="w_click_par"><div class="w_click" id="'+ data[i].id +'" onclick="HomeInterfaceJump(this.id,this.innerText)">'+ data[i].value +'</div></div></div>'
		    }
		    $('#w_click_show').html(htmlname+htmlstr);   //InterfaceJump(this.id)
		}});
}

///统计分析 联动 2017-11-15
function StaticBtn(){
	$("#c_click_show").show();
	//不良事件动态统计
	$("#reportbydt").click(function(){
	   //var Rel='dhcadv.reportbymon.csp';   //qqa
	   var Rel='dhcadv.statisticsdhcadv.csp';
		location.href=Rel;
	});
	
	/* //按等级统计
	$("#reportbylevel").click(function(){
	   var Rel='dhcadv.reportbylevel.csp';
		location.href=Rel;
	});
	//按事件类型统计
	$("#reportbyevent").click(function(){
	   var Rel='dhcadv.reportbyevent.csp';
		location.href=Rel;
	});
	//不良事件按月统计
	$("#reportbymon").click(function(){
	   var Rel='dhcadv.reportbymon.csp';   //qqa
	   //var Rel='dhcadv.statisticsdhcadv.csp';
		location.href=Rel;
	});
	//不良事件按季度统计
	$("#reportbyqau").click(function(){
	   var Rel='dhcadv.reportbyqau.csp';
		location.href=Rel;
	});
	//按科室/科室类型数量统计
	$("#reportbyctloc").click(function(){
	   var Rel='dhcadv.reportbyctloc.csp';
		location.href=Rel;
	});
	//压疮发生率季报
	$("#PreSorePerQuarter").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreSorePerQuarter.raq';
		location.href=Rel;
	});
	//用药错误例数按月统计
	$("#MedErrorPerMonth").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_MedErrorPerMonth.raq';
		location.href=Rel;
	});
	//全年各月各级压疮统计
	$("#PreSoresAtLevel").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreSoresAtLevel.raq';
		location.href=Rel;
	});
	//全年各月各级跌倒事件统计
	$("#FallEventsAtLevels").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_FallEventsAtLevels.raq';
		location.href=Rel;
	});
	//分期院内发生压疮率统计
	$("#InPerPSore").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_InPerPSore.raq';
		location.href=Rel;
	});
	//院内各部位压疮率统计
	$("#InPartPSore").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_InPartPSore.raq';
		location.href=Rel;
	});
	//高危患者跌倒发生率月报
	$("#HRPatFallIncidence").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_HRPatFallIncidence.raq';
		location.href=Rel;
	});
	//有伤害跌倒发生率月报
	$("#HurtFall").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_HurtFall.raq';
		location.href=Rel;
	});
	//外院带入压疮数统计
	$("#OutPressureNumber").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_OutPressureNumber.raq';
		location.href=Rel;
	});
	//压疮发生率月报
	$("#PreUlcer").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreUlcer.raq';
		location.href=Rel;
	});
	//跌倒发生率月报
	$("#PreSlip").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreSlip.raq';
		location.href=Rel;
	});
	//高危压疮发生率月报
	$("#PreHighScore").click(function(){
	   var Rel='dhccpmrunqianreport.csp?reportName=DHCADV_PreHighScore.raq';
		location.href=Rel;
	}); */
	
	$("#reportbyml").click(function(){
	   var Rel='dhcadv.exportbylocmon.csp';
		location.href=Rel;
	});
	$("#reportbyqm").click(function(){
	   var Rel='dhcadv.reportbymon.csp';
		location.href=Rel;
	});
	
	$("#compstaquery").click(function(){
	   var Rel="dhcadv.model.report.csp?&code=" +""+'&quoteflag=1';
		location.href=Rel;
	});
}

///报告综合查询 联动
function QueryBtn(){
	$("#s_click_show").show();
	$("#querylink").click(function(){
	   var Rel='dhcadv.reportquery.csp?StrParam='+"";
		location.href=Rel;
	});
	$("#auditlink").click(function(){
	   var Rel='dhcadv.reportaudit.csp?StrParam='+"";
		location.href=Rel;
	});
	$("#cancellink").click(function(){
	   var Rel='dhcadv.repcancel.csp?cancelflag='+"Y";
		location.href=Rel;
	});
	
}

//收件一览 联动  （接收标识为1 且属于自己待审批报告  即为本人接收过的报告）
function RecListBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^1^Y^^^^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(收件一览)"));
	location.href=Rel;
}
//已报事件 联动  （本人在本科室已提交的报告）
function CompleBt(){
	var StrParam=StDate+"^"+EndDate+"^"+LgCtLocID+"^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^Y^^^^^^^^^^^^Y^^N^^1";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+encodeURI(encodeURI("(已报事件)"));
	location.href=Rel;
}
// 重点关注 联动
function RepImpBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^Y^^^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(重点关注)"));
	location.href=Rel;
}
//草稿箱 联动
function DraftsBt(){
	var StrParam=StDate+"^"+EndDate+"^"+LgCtLocID+"^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^N^^^^^^^^^^^^N^^N^^1";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+encodeURI(encodeURI("(草稿箱)"));
	location.href=Rel;
}
//归档事件
function FileBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^Y^^^^^^^2";  //24
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(归档事件)"));
	location.href=Rel;
}
//待审批报告
function PendAuditBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^Y^^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(待审批报告)"));
	location.href=Rel;
}
//被退回报告 联动
function BackBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^2^^^^Y^^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(被退回报告)"));
	location.href=Rel;
}
//填写时限
function FillTimeBt(){
	var RepLoc=LgCtLocID;
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^^^^^Y^^^1";
	var Rel='dhcadv.reportquery.csp?StrParam='+StrParam+'&querytitle='+encodeURI(encodeURI("(填写时限)"));
	location.href=Rel;
}
//受理时限
function AcceptTimeBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^^^^Y^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(受理时限)"));
	location.href=Rel;
}
//全部已处理报告
function AuditBt(){
	var StrParam=StDate+"^"+EndDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^^^^^^^^Y^^^^^^^^2";
	var Rel='dhcadv.reportaudit.csp?StrParam='+StrParam+'&audittitle='+encodeURI(encodeURI("(全部已处理报告)"));
	location.href=Rel;
}
//不良事件按类型统计
function StaticbyType(DateList)
{
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYEVENT&MethodName=AnalysisReport'+'&params='+DateList+'&LgParam='+LgParam,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Blt(ListDataObj,"","#"); 
			option.title ={
				
			}
			var container = document.getElementById('typecharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}

//不良事件按类型统计
function StaticbyTypeLoc(DateList)
{
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYEVENT&MethodName=AnalysisReport'+'&params='+DateList+'&LgParam='+LgParam,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Bars(ListDataObj,"","#"); 
			option.title ={
				
			}
			var container = document.getElementById('typeloccharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}


//不良事件按月统计
 function StaticbyMon(DateList)
{

	var params=DateList+"^"+"";
	var columns=[[
		{field:"name",title:$g("月份"),width:150,align:'center'},
		{field:'value',title:$g("数量"),width:150,align:'center'}
	]];
	//定义datagrid
	$('#dgbymon').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=StatAllRepByMon'+'&params='+params+'&LgParam='+LgParam,		
		fit:true,
		columns:columns,
	    singleSelect:false,
		loadMsg: $g("正在加载信息..."),
		showFooter:true,
		pageSize:10,  // 每页显示的记录条数
		pageList:[10,20,30],
		pagination:true,
		height:200

	});
	initScroll("#dgbymon");//初始化显示横向滚动条
		
	$.ajax({
		type: "POST",
		url:'dhcapp.broker.csp?ClassName=web.DHCADVREPBYMON&MethodName=AnalysisRepByMon'+'&params='+params+'&LgParam='+LgParam,	
		//url: url+"?action=AnalysisRepByMon&params="+params,
		success: function(jsonString){
			var ListDataObj = jQuery.parseJSON(jsonString);
			var option = ECharts.ChartOptionTemplates.Lines(ListDataObj); 
			option.title ={
				//text: '不良反应事件统计分析',
				//subtext: '饼状图',
				//x:'center'
			}
			var container = document.getElementById('moncharts');
			opt = ECharts.ChartConfig(container, option);
			ECharts.Charts.RenderChart(opt);
		}
	});
}
//congyue 2019-01-22 点击首页填报类型跳转页面
function HomeInterfaceJump(code,desc){
	if (code=="index"){
		Gologin();
	}else{
		var Rel='dhcadv.layoutform.csp?code='+code+'&desc='+desc+'&freshflag=0'+"&TmpEpisodeID=";
		location.href=Rel;
	}
}
//congyue 2017-09-06 点击首页图标，返回首页
function Gologin(){
	location.href='dhcadv.homepage.csp';
}

/// 病人概览  yuliping 2017-10-10
/// 页面初始化函数 
//EpisodeID=1135
var EmPCLvID=""
var parInfoArr=""  //病人基本信息
var parCheckInfo="" // 病人分诊信息
var GlobalObj={};
$(function(){
	initPanelHeight();
	getPatInfo(EpisodeID);	//病人基本信息
	GetPatcurdetail();//当前明细信息
	getPatCheckInfo();//病人分诊信息
})

function initPanelHeight(){

	var pannelHeight=$(window).height()/2;
	$(".topPanel").css({"height":pannelHeight-15});
	$(".bottomPanel").css({"height":pannelHeight-20});
	$(".body-height").each(function(){
		$(this).css({"height":$(this).parent().height()-30});
	})
}

	
/// 通过病人Id查找病人信息
function getPatInfo(){
	//alert(EpisodeID)
	if(EpisodeID ==""){
		return;
	}else{
		//
		runClassMethod("web.DHCEMPatOverview","GetEmRegPatInfo",{"EpisodeID":EpisodeID,"UserCode":session['LOGON.USERCODE']},function(jsonString){
		
		parInfoArr = jsonString.split("^");
		
		var htmStr=""
		htmStr=htmStr+"<table class='table' id='patInfoTable'><tr>"
		htmStr=htmStr+"<td class='tdWidth'>姓名：<span>"+parInfoArr[7]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>性别：<span>"+parInfoArr[9]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>ID：<span>"+parInfoArr[6]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>年龄：<span>"+parInfoArr[11]+"</span></td>";
		htmStr=htmStr+"</tr>";
		
		htmStr=htmStr+"<tr>"
		htmStr=htmStr+"<td class='tdWidth'>民族：<span>"+parInfoArr[12]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>费别：<span>"+parInfoArr[18]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth' colspan='2'>保密级别：<span>"+parInfoArr[22]+"</span></td>";
		htmStr=htmStr+"</tr>";

		htmStr=htmStr+"<tr>";
		htmStr=htmStr+"<td class='tdWidth' colspan='2'>电话：<span>"+parInfoArr[16]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>体重(KG)：<span>"+parInfoArr[35]+"</span></td>";
		htmStr=htmStr+"</tr>";
		
		htmStr=htmStr+"<tr>";	
		htmStr=htmStr+"<td class='tdWidth' colspan='3'>家庭地址：<span>"+parInfoArr[17]+"</span></td></tr> </table>";
				htmStr=htmStr+"<div style='width:100%;border-bottom:2px dotted #D1D1D1'></div>"
		
		htmStr=htmStr+"<table class='table' style='margin:5px;' ><tr>"
		
		htmStr=htmStr+"<td>检验：";
		htmStr=htmStr+"<span id='Lab'>"
		htmStr=htmStr+"<img  style='margin-bottom:-3px;' src='../scripts/dhcnewpro/images/sandglasst.png'/><span id='Lab_1' class='checkSpan'>"+parInfoArr[29]+"</span>"
		htmStr=htmStr+"<img style='margin-bottom:-4px;'  src='../scripts/dhcnewpro/images/sandglassf.png'/><span id='Lab_2' class='checkSpan'>"+parInfoArr[30]+"</span>";
		htmStr=htmStr+"<img style='margin-bottom:-3px;' src='../scripts/dhcnewpro/images/sandglassp.png'/><span id='Lab_3' class='checkSpan'>"+parInfoArr[31]+"</span>";
		htmStr=htmStr+"</span>";
		htmStr=htmStr+"</td>";
		
		
		htmStr=htmStr+"<td>检查："
		htmStr=htmStr+"<span id='Exam'>"
		htmStr=htmStr+"<img style='margin-bottom:-3px;'  src='../scripts/dhcnewpro/images/sandglasst.png'/><span id='Exam_1' class='checkSpan'>"+parInfoArr[32]+"</span>";
		htmStr=htmStr+"<img style='margin-bottom:-4px;' src='../scripts/dhcnewpro/images/sandglassf.png'/><span id='Exam_2' class='checkSpan'>"+parInfoArr[33]+"</span>";
		htmStr=htmStr+"<img style='margin-bottom:-3px;' src='../scripts/dhcnewpro/images/sandglassp.png'/><span id='Exam_3' class='checkSpan'>"+parInfoArr[34]+"</span>";
		htmStr=htmStr+"</span>";
		
		htmStr=htmStr+"<td style='width:150px;'>危急值：<span id='CVR' class='checkSpan'>"+parInfoArr[26]+"</span></td></tr>";
		
		htmStr=htmStr+"<tr>"
		htmStr=htmStr+"</tr>";
		htmStr=htmStr+"</table>"
		htmStr=htmStr+"<div style='width:100%;border-bottom:2px dotted #D1D1D1'></div>"
		/*htmStr=htmStr+"<tr><td colspan='4'></td></tr>";
		htmStr=htmStr+"<tr>";*/
		htmStr=htmStr+"<table class='table' style='margin:5px;'><td class='tdWidth'>医生：<span>"+parInfoArr[23]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>主管护士：<span>"+parInfoArr[24]+"</span></td>";
		htmStr=htmStr+"<td style='display:none' class='tdWidth'>护理级别：<span>"+parInfoArr[25]+"</span></td>";
		htmStr=htmStr+"<td style='display:none' class='tdWidth'>特殊护理：<span>"+parInfoArr[27]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>留观滞留时间："+parInfoArr[28]+"</td>";
		htmStr=htmStr+"</tr></table>";
	
        $("#patInfo").append(htmStr);
       	//EmPCLvID=parInfoArr[19]
        
        InitPannelEvent();
		},"","false");
		
	}
	 

}
//通过分诊ID，获取病人分诊信息
function getPatCheckInfo(){

	if(EpisodeID =="" ){
		return;
	}else{
	
		runClassMethod("web.DHCEMPatOverview","getPatCheckLevInfo",{"EpisodeID":EpisodeID,"TypeMode":1},function(jsonString){
		
		parCheckInfo = jsonString.split("^");
		
		var htmlStr="";// 分诊信息
		htmStr="<tr><td class='tdWidth'>分诊时间：</td><td class='tdFontWeight' style='width:200px;'>";
		htmStr=htmStr+parCheckInfo[1]+" "+parCheckInfo[2]+"</td><td class='tdWidth'>护士分级：</td><td class='tdFontWeight'><a ";
		/*if((parCheckInfo[0]==1)||(parCheckInfo[0]==2)){ //hxy 2020-02-21 st
			htmStr=htmStr+"style='color:red;";
			htmStr=htmStr+"'>"+parCheckInfo[0]+"级</a></td></tr>";
			}else if(parCheckInfo[0]==3){
			htmStr=htmStr+"style='color:#ffcc00;";
			htmStr=htmStr+"'>"+parCheckInfo[0]+"级</a></td></tr>";
			}else if(parCheckInfo[0]==4){
				htmStr=htmStr+"style='color:green;";
				htmStr=htmStr+"'>"+parCheckInfo[0]+"级</a></td></tr>";*/
		if(parCheckInfo[0]==1){
			htmStr=htmStr+"style='color:red;";
			htmStr=htmStr+"'>"+setCell(parCheckInfo[0])+"级</a></td></tr>";
		}else if(parCheckInfo[0]==2){
			htmStr=htmStr+"style='color:orange;";
			htmStr=htmStr+"'>"+setCell(parCheckInfo[0])+"级</a></td></tr>";
		}else if(parCheckInfo[0]==3){
			htmStr=htmStr+"style='color:#ffcc00;";
			htmStr=htmStr+"'>"+setCell(parCheckInfo[0])+"级</a></td></tr>";
		}else if(parCheckInfo[0]==4){
			htmStr=htmStr+"style='color:green;";
			htmStr=htmStr+"'>"+setCell(parCheckInfo[0])+"级</a></td></tr>";
		}else if(parCheckInfo[0]==5){
			htmStr=htmStr+"style='color:green;";
			htmStr=htmStr+"'>"+setCell(parCheckInfo[0])+"级</a></td></tr>"; //ed		
		}else{
			htmStr=htmStr+"style='";
			htmStr=htmStr+"'>"+"</a></td></tr>";
			}
		
		htmStr=htmStr+"<tr><td class='tdWidth'>病人去向：</td><td class='tdFontWeight'>";
		
		if(parCheckInfo[23]=="红区"){
			htmStr=htmStr+"<span class='redSpan'>"
			}else if(parCheckInfo[23]=="橙区"){ //hxy 2020-02-21 st
				htmStr=htmStr+"<span class='orangeSpan'>" //ed
				}else if(parCheckInfo[23]=="黄区"){
					htmStr=htmStr+"<span class='yellowSpan'>"
					}else if(parCheckInfo[23]=="绿区"){
						htmStr=htmStr+"<span class='greenSpan'>"
						}else{
							htmStr=htmStr+"<span>"
							}
		
		htmStr=htmStr+parCheckInfo[23]+"</span><span style='margin-left:20px;color:#000000;'>"+parCheckInfo[28]+"</span></td><td class='tdWidth'>分诊护士：</td><td class='tdFontWeight'>";
		htmStr=htmStr+parCheckInfo[24]+"</td></tr>";
		
		htmStr=htmStr+"<tr><td class='tdWidth'>绿色通道：</td><td class='tdFontWeight'>";
		htmStr=htmStr+parCheckInfo[25]+"</td><td class='tdWidth'>三无病人：</td><td class='tdFontWeight'>";
		htmStr=htmStr+parCheckInfo[26]+"</td></tr>";
		
		
		var htmPCBStr=""
		htmPCBStr="<tr class='trCenter'><th style='border-left:1px solid #FFFFFF;'>体温</th><th>心率</th><th>脉搏</th><th>收缩压</th><th>舒张压</th><th>呼吸</th><th>SPO2</th></tr>";		// 生命体征
		htmPCBStr=htmPCBStr+"<tr class='trCenter' style='height:35px;'><td style='border-left:1px solid #FFFFFF;'>"+parCheckInfo[10]+"</td><td>"+parCheckInfo[11]+"</td><td>"+parCheckInfo[12]+"</td>"	
	
		if((parCheckInfo[13]!="")){
			var str=parCheckInfo[13].split(":");
			}else{
				var str="/ "
			}
		
		var sstr=str[0].split("/")
		htmPCBStr=htmPCBStr+"<td>"+sstr[0]+"</td><td>"+sstr[1]+"</td><td>"+str[1]+"</td><td>"+parCheckInfo[14]+"</td></tr>";	
		htmPCBStr=htmPCBStr+"<tr class='trCenter'> <td style='border-left:1px solid #FFFFFF;'>℃</td><td>次/分</td><td>次/分</td><td>mmHg</td><td>mmHg</td><td>次/分</td><td>%</td></tr>"
		var htmScoStr=parCheckInfo[29];
		showScoreTable(htmScoStr);
		$("#patChcekLevInfo").append(htmStr);
		},"text","false");
	}
}

function showScoreTable(htmScoStr){
	if(htmScoStr==""){
		$HUI.datagrid("#scoreTable").appendRow({code: "",lev: "",itm:"",score:""});
		return;
	}
	
	AutoScoreStrArr=htmScoStr.split("$$")
	for(var i=0;i<AutoScoreStrArr.length;i++){
		if(AutoScoreStrArr[i]!=""){
			var tmpArr=AutoScoreStrArr[i].split("||");
			$HUI.datagrid("#scoreTable").appendRow({code: tmpArr[5],lev: tmpArr[2],itm:tmpArr[4],score:tmpArr[3]});
		}
	}
	return;	
}

// 病人诊断
function getDiagnos(){
	
	if(EpisodeID =="" ){
		return;
	}else{
	
		runClassMethod("web.DHCEMPatOverview","getDiagnosis",{"MRADMID":EpisodeID},function(jsonString){
		
		var DiagnosArr = jsonString.split("!");
		var htmStr="<tr class='trLeft'><th style='width:150px;border-left:1px solid #FFFFFF;'><span>诊断类型</span></th><th style='border-right:1px solid #FFFFFF;'><span>诊断</span></th></tr>";// 分诊信息
		for(var i=0;i<DiagnosArr.length;i++){
			var diagnos = DiagnosArr[i].split("^");
			htmStr=htmStr+"<tr class='trLeft' style='height:30px;'><td style='border-left:1px solid #FFFFFF;'><span>"+trsUndefinedToEmpty(diagnos[5])+"</span></td>"+"<td style='border-right:1px solid #FFFFFF;'><span>"+trsUndefinedToEmpty(diagnos[0])+"</span></td></tr>";
		}
		$("#patDiagnos").append(htmStr)
		},"","false");
	}
}

//病人流转状态
function getPatCurStatus(){
	if(EpisodeID =="" ){
		return;
	}else{
	
		runClassMethod("web.DHCEMPatCurStatus","FindAdmstatusTotal",{"EpisodeID":EpisodeID},function(jsonString){
		
		var CurStatus = jsonString.split("$$");
		var htmStr="";
		htmStr="<tr><th>时间</th><th>状态</th><th>操作人员</th></tr>";
		
		for(var i=0;i<CurStatus.length-1;i++){
			var staArr=CurStatus[i].split("^");
			if(staArr.length==4){
				htmStr=htmStr+"<tr><td>"+staArr[0]+" "+staArr[1]+"</td><td>"+staArr[3]+"</td><td>"+staArr[2]+"</td><td>";
			}else{
				htmStr=htmStr+"<tr><td>"+staArr[0]+" "+staArr[1]+"</td><td>"+staArr[2]+"</td><td></td><td>";
				}			
			}
		$("#patRoam").append(htmStr)
		},"","false");
	
	}
}
//病人信息刷新
function refreshDiv(){
	$("#patInfo").empty();
	getPatInfo();
	}
//隐藏病人详情
function hideDiv(){
	
	$('.box').hide()
}
function hideDivT(){
	$('.boxT').hide()
	
}

// 显示状态明细
function GetPatcurdetail(){
		runClassMethod("web.DHCEMPatCurStatus","FindAdmstatusTotal",{'EpisodeID':EpisodeID},
		function(data){
				var list=data.split("$$"); 
				var listlen=list.length;
				var singlelist=list[listlen-2].split("^")
				$('.show-status').append('<li style="padding-left:30px;" id="current-time">'+singlelist[0]+'&nbsp;&nbsp;&nbsp;'+singlelist[1]+'</li>')
				var singlelen=singlelist.length;
				if(singlelen>3){
					$('#current-status').html(singlelist[3])
				}
				else if(singlelen=3){
					$('#current-status').html(singlelist[2])
				}
				
				
				for(var i=0;i<list.length-1;i++){
						$(".status-list").append('<li>'+
  						 '<div class="circle"></div>'+
  						 '<span class="inittxt">'+list[i].split("^")[2]+'</span>'+
						 '<span class="time">'+list[i].split("^")[0]+'&nbsp;&nbsp;&nbsp;'+list[i].split("^")[1]+'</span>'+
						 '<span class="txt">'+list[i].split("^")[3]+'&nbsp;&nbsp;&nbsp;'+"操作人:"+list[i].split("^")[4]+'</span>'+
						 '</li>')
					}
					//$(".status-list li:last-child .circle").css("background-position","0 -72px")
					$(".status-list li:last-child > div").removeClass("circle");
					$(".status-list li:last-child > div").addClass("playcircle")
					
		},"text",false);
}

function initPatCheInfo(){
	$("#detailDivT").empty()
	$("#detTitleT").empty();
	if(EpisodeID =="" ){
		return;
	}else{
		
		runClassMethod("web.DHCEMPatOverview","getPatCheckLevInfo",{"EpisodeID":EpisodeID,"TypeMode":2},function(jsonString){
		parCheckInfo = jsonString.split("^");
		
		var htmlStr="";// 分诊信息
		htmStr="<tr><td >分诊时间：</td><td class='tdWidthl'>";
		htmStr=htmStr+parCheckInfo[1]+"</td><td class='tdWidth' >护士分级：</td><td>";
		htmStr=htmStr+parCheckInfo[0]+"</td>";
		
		htmStr=htmStr+"<td class='tdWidth'>病人去向：</td><td>";
		htmStr=htmStr+parCheckInfo[23]+"</td></tr><tr><td >分诊护士：</td><td class='tdWidthl'>";
		htmStr=htmStr+parCheckInfo[24]+"</td>";
		
		htmStr=htmStr+"<td class='tdWidth'>绿色通道：</td><td>";
		htmStr=htmStr+parCheckInfo[25]+"</td><td class='tdWidth'>三无病人：</td><td>";
		htmStr=htmStr+parCheckInfo[26]+"</td></tr>";
		
		
		htmStr=htmStr+"<tr><td >来诊方式：</td><td class='tdWidthl'>";
		htmStr=htmStr+parCheckInfo[6]+"</td><td class='tdWidth' >意识状态：</td><td>";
		htmStr=htmStr+parCheckInfo[8]+"</td>";
	
		htmStr=htmStr+"<td class='tdWidth'>特殊人群：</td><td>";
		htmStr=htmStr+parCheckInfo[27]+"</td></tr>"
		htmStr=htmStr+"<tr><td class='tdWidth'>既往史：</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[19]+"</td></tr>";

		htmStr=htmStr+"<tr><td class='tdWidth'>症状：</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[3]+"</td></tr>";
		
		htmStr=htmStr+"<tr><td colspan='6' style='border-bottom:1px solid #333333'></td></tr>"
		htmStr=htmStr+"<tr><td class='tdWidth'>创伤评分：</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[20]+"</td></tr>";
		htmStr=htmStr+"<tr><td class='tdWidth'>格拉斯哥：</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[22]+"</td></tr>";
		htmStr=htmStr+"<tr><td class='tdWidth'>疼痛评分：</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[21]+"</td></tr>";
		
		var htmPCBStr=""
		htmPCBStr="<tr><th>体温(T)</th><th>心率(HR)</th><th>脉搏(R)</th><th>血压(BP)收缩压</th><th>呼吸频率(R)</th><th>血氧饱和度(SPO2)</th></tr>";		// 生命体征
		htmPCBStr=htmPCBStr+"<tr><td>"+parCheckInfo[10]+"℃</td><td>"+parCheckInfo[11]+"(次/分)</td><td>"+parCheckInfo[12]+"(次/分)</td>"
		var str=parCheckInfo[13].split(":");
		htmPCBStr=htmPCBStr+"<td>"+str[0]+"(mmHg)</td><td>"+str[1]+"(次/分)</td><td>"+parCheckInfo[14]+"(%)</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>";	
		var htmScoStr="";
		htmScoStr=htmScoStr+"<tr><td>创伤评分</td><td>格拉斯哥评分</td><td>疼痛评分</td></tr>";	
		htmScoStr=htmScoStr+"<tr><td>"+parCheckInfo[20]+"</td><td>"+parCheckInfo[22]+"</td><td>"+parCheckInfo[21]+"</td></tr>";	
		
		$("#detailDivT").append(htmStr);
		$("#detTitleT").append("病人分诊信息");
		
			},"","false");
	}
}
	
	//unde转为空
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}
function linkToCsp(){
	
	var lnk = "dhcem.emerpatientinfom.csp?EpisodeID="+ EpisodeID+"&EmPCLvID="+EmPCLvID;
	var blankWidth="",blankHeight="";
	if(window.top==window.self){
		blankWidth = $(window).width();
		blankHeight = $(window).height();
	}else{
		blankWidth = $(window.parent).width();
		blankHeight = $(window.parent).height();
	}
	
	window.open(lnk,"_blank","top=100,left=0,width="+(blankWidth-20)+"px,height="+(blankHeight-60)+"px,menubar=yes,scrollbars=yes,toolbar=no,status=no");
	//window.open(lnk, "_blank", "dialogHeight: " + (top.screen.height - 530) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
	}

/// 悬浮Panel
function InitPannelEvent(){


	$('#Lab,#Exam,#CVR').each(function(){
		var that = $(this)
		that.parent().on({
			mouseenter:function(){
				if(that.attr("id")=="Lab"){/*hxy 2018-07-06 都为0时，不泡芙*/
					var num=$("#Lab_1").text()+$("#Lab_2").text()+$("#Lab_3").text();
					if(num=="000"){return;}
				}
				if(that.attr("id")=="Exam"){
					var num=$("#Exam_1").text()+$("#Exam_2").text()+$("#Exam_3").text();
					if(num=="000"){return;}
				}
				if(that.attr("id")=="CVR"){
					var num=$("#CVR").text();
					if(num=="0"){return;}
				}/*hxy ed*/

				if (LoadPopover("Load",that.attr("id"))){
					var HTML=GetPannelHTML(that.attr("id"));
					if (HTML.innerHTML==""){return;}
					that.webuiPopover({
						title:HTML.Title,
						content:HTML.innerHTML,
						trigger:'hover',
						placement:'bottom-right',
						width:710,
						height:280,
						onShow:function(){
							//alert(that.attr("id"))
							if (LoadPopover("Show",that.attr("id"))){
								if (typeof HTML.CallFunction == "function"){
									HTML.CallFunction.call();
								}
							}
						}
					});
					that.webuiPopover('show');
				}
			}
		});
	})
	/*
	return;
	$('.status-list li .inittxt').each(function(){

		if (($(this).text().indexOf("检查") == "-1")&($(this).text().indexOf("检验") == "-1")){
			return;
		}
		
		if (LoadPopover("Load",$(this).text())){
			var HTML=GetPannelHTML($(this).text());
			if (HTML.innerHTML==""){return;}
			$(this).webuiPopover({
				title:HTML.Title,
				content:HTML.innerHTML,
				trigger:'hover',
				placement:'top-left',
				width:660,
				height:320,
				onShow:function(){
					//if (LoadPopover("Show",$(this).text())){
						if (typeof HTML.CallFunction == "function"){
							HTML.CallFunction.call();
						}
					//}
				}
			});
			//$(this).webuiPopover('show');
		}
	})
	*/
}

///获取动态写入的HTML代码
function GetPannelHTML(LinkID){
	var innerHTML="";
	var CallFunction={};
	var Title="";
	if (LinkID.indexOf("Lab") != "-1"){
		//检验
		//if ($("#LabCount").text()>0){
			innerHTML+='<div style="background:#F7F7F7;width:700px;height:29px;border:none;padding:6px 0 0 10px"><b>检验列表</b></div><div style="padding:10px;"><table id="LabOrdGrid"></table></div>';<!--hxy 2018-07-06-->
			CallFunction=LoadLabOrdGrid;
		//}
	}
	if (LinkID.indexOf("Exam") != "-1"){
		//检查
		//if ($("#ExamCount").text()>0){
			//innerHTML+='<table id="ExamOrdGrid"></table>';
			innerHTML+='<div style="background:#F7F7F7;width:700px;height:29px;border:none;padding:6px 0 0 10px"><b>检查列表</b></div><div style="padding:10px;"><table id="ExamOrdGrid"></table></div>';<!--hxy 2018-07-06-->
			CallFunction=LoadExamOrdGrid;
		//}
	}
	if (LinkID.indexOf("CVR") != "-1"){
		//危急值 yuliping 2018-03-23
		//if ($("#ExamCount").text()>0){
			//innerHTML+='<table id="CVReportGrid"></table>';
			innerHTML+='<div style="background:#F7F7F7;width:700px;height:29px;border:none;padding:6px 0 0 10px"><b>危急值</b></div><div style="padding:10px;"><table id="CVReportGrid"></table></div>';<!--hxy 2018-07-06-->
			CallFunction=LoadCVReportGrid;
		//}
	}
	return {
		"innerHTML":innerHTML,
		"CallFunction":CallFunction,
		"Title":Title
	}
}
  
function LoadLabOrdGrid(){

	var LabOrdColumns=[[    
		{field:'Index', hidden:true},
		{title:'状态',field:'Title',width:90,formatter:function(value,rec){
			if(rec.ARCIMDesc!=""){
				return "";
			}else{
				return value;
			}
		}},
		{title:'医嘱名称',field:'ARCIMDesc',width:90},
		{title:'医嘱名称',field:'TestSetName',width:90,hidden:true},
		{title:'状态',field:'Status',hidden:true},
		{title:'医嘱id',field:'OrderId',width:90,hidden:true},
		{title:'报告id',field:'ReportId',width:90,hidden:true},
		{title:'检验号',field:'VisitNumber',width:90},
		{title:'采血时间',field:'SpecCollDate',width:90},
		{title:'申请时间',field:'RequestTime',width:90,hidden:true},
		{title:'接收时间',field:'ReceiveTime',width:90},
		{title:'报告时间',field:'ReportTime',width:90},
		{title:'报告链接',field:'labReportLink',width:90,
			formatter:function(value,rec){
				
 				var BtnHTML="";
 				 ///已申请 1 ，已接收 2 ，已报告 3
 				if (rec.Status!="3"){
	 				return BtnHTML;
	 			}else{
		 			var BtnHTML = '<a href="#" class="editcls" onclick="switchTabByEMR(\'' + rec.OrderId + '\')">操作</a>'; //'<a class="editcls" onclick="ipdoc.pattreatinfo.view.OpenLabReport(\'' + rec.ReportId + '\')">操作</a>';
		 		}
		       return BtnHTML;
            }
		}
    ]];
   
	$.m({
	    ClassName:"web.DHCDocInPatPortalCommon",
	    MethodName:"GetLabGridData",
	    EpisodeID:EpisodeID
	},function(val){
		var GridData=eval('(' + val + ')'); 
		//$HUI.treegrid('#LabOrdGrid',{
		$HUI.treegrid('#LabOrdGrid',{
		    data:GridData,
		    title:'', //检验列表 hxy
		    headerCls:'panel-header-gray',
		    idField:'Index',
		    treeField:'Title',
		    fit : false,
		    width:680,
		    height:200, //280 hxy
		    border: false,
		    columns:LabOrdColumns
		});
	});
}

function switchTabByEMR(OrderId){
	//parent.switchTabByEMR("检验结果");
	parent.switchTabByEMR("检验结果",{"oneTimeValueExp":"OEORIID="+OrderId});	
}
function switchInspectTab(OrderId){
	//parent.switchTabByEMR("检查报告");
	parent.switchTabByEMR("检查报告",{"oneTimeValueExp":"OEORIID="+OrderId});	
}

///检查医嘱分类树状列表
function LoadExamOrdGrid(){
	var ExamOrdColumns=[[    
        {title:'Index',field:'Index',hidden:true},
        {title:'Oeori',field:'Oeori',hidden:true},
        {title:'状态',field:'Title',width:80},
        {title:'医嘱项名称',field:'ItemLabel',width:200},
        {title:'部位/标本',field:'ItemSpec',width:100},
        {title:'执行科室',field:'ItemLoc',width:100},
        {title:'时间',field:'ItemTime',width:120},
        {title:'报告链接',field:'ExamReportLink',width:100,
			formatter:function(value,rec){
 				var BtnHTML="";
 				///已申请 A ，（"登记"、"预约"） ，已报告 C
		
		 		if((rec.ItemLabel)&&(rec._parentId=="报告")){
			 		var BtnHTML = '<a href="#" class="editcls" onclick="switchInspectTab(\'' + rec.Oeori + '\')">操作</a>';     // '<a class="editcls" onclick="ipdoc.pattreatinfo.view.OpenExamReport(\'' + rec.StudyNo + '\')">操作</a>';	
			 	}
				return BtnHTML;
            }
		}
		
		
    ]];
	$.m({
	    ClassName:"web.DHCEMPatCurStatus",
	    MethodName:"QueryExaReqDetList",
	    EpisodeID:EpisodeID,
	    LgUserCode:session['LOGON.USERCODE']
	},function(val){
		var GridData=eval('(' + val + ')'); 
		$HUI.treegrid('#ExamOrdGrid',{
		//$('#ExamOrdGrid').treegrid({
		    data:GridData,
		    title:'', //检查列表 hxy
		    headerCls:'panel-header-gray',
		    idField:'Index',    
		    treeField:'Title',
		    fit : false,
		    width:680,
		    height:200, //280
		    border: false,   
		    columns:ExamOrdColumns
		});
	});
	
}
	
var LoadPopover=(function(){
	///防止多次初始化数据
	var AlreadLoadObj={};	//初始化元素
	var AlreadShowObj={};	//初始化显示数据
	return function(Type,ID){
		if (Type=="Load"){
			if (typeof AlreadLoadObj[ID] =="undefined"){
				AlreadLoadObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}else if (Type=="Show"){
			if (typeof AlreadShowObj[ID] =="undefined"){
				AlreadShowObj[ID] ="1";
				return true;
			}else{
				return false;
			}
		}
		
	}
})();
function LoadCVReportGrid(){
		var CVReportColumns=[[    
			{field:'Index', hidden:true},
			{title:'报告ID',field:'ReportId', hidden:true},
	        {title:'医嘱名称',field:'TSName',width:200},
	        {title:'危急值类型名称',field:'ReportType',width:120},
	        {title:'危急值类型代码',field:'DPRPType', hidden:true},
	        {title:'警示提示',field:'DPRPAlert',width:120},
	        {title:'报告状态',field:'ReportStatus', hidden:true},
	        {title:'报告日期',field:'DateTime', hidden:true},
	        {title:'申请日期',field:'ApplyDT', hidden:true},
	        {title:'采样时间',field:'SamplingDT', hidden:true},
	        {title:'接收时间',field:'ReceiveDT', hidden:true},
	        {title:'审核时间',field:'AuditDT', hidden:true},
	        {title:'标本',field:'Specimen', hidden:true},
	        {title:'操作',field:'CVReportBtn',
 				formatter:function(value,rec){
                   var btn = '<a class="editcls" style="cursor: pointer;" onclick="CVReportBtnClickHandler(\'' + rec.ReportId + '\',\'' + rec.DPRPType + '\')">操作</a>';
			       return btn;
                }
 			},
	    ]];
	    
		$.q({
		    //ClassName:"web.DHCDocInPatPortalCommon",
		    ClassName:"web.DHCCVCommon",
		    QueryName:"CVReportFromAdm",
		    EpisodeId:EpisodeID,
		    TransStatus:"C"
		},function(GridData){
			$HUI.datagrid('#CVReportGrid',{
			    data:GridData,
			    title:'',//危急值 hxy
			    headerCls:'panel-header-gray',
			    idField:'Index',
			    treeField:'Title',
			    fit : false,
			    width:680, //500
			    height:200, //300
			    border: false,
			    columns:CVReportColumns
			});
		});
	}
 function CVReportBtnClickHandler(ReportId,DPRPType){
	 var lnk="criticalvalue.trans.hisui.csp?ReportId="+ReportId+"&RepType="+DPRPType;
	 websys_showModal({
		url:lnk,
		title:'危急值操作',
		width:760,
		height:500,
		onClose: function() {
			
		}
	});
	}
	

//使用局部刷新,这样除第一次渲染较慢重复使用较快
function xhrRefresh(papmi,adm,madm){
	var papmi=GetMenuPara("PatientID");
	var adm=GetMenuPara("EpisodeID");
	if ((adm==GlobalObj.EpisodeID)||(adm=="")){
		return;
	}
	var Url=window.location.href;
    Url=rewriteUrl(Url, {
        EpisodeID:adm,
    	PatientID:papmi,
    	mradm:adm,
    	EpisodeIDs:"",
    	copyOeoris:"",
    	copyTo:""});
    history.pushState("", "", Url);
    window.location.reload();
}

/// 协议包装,2014-05-30,by xp,End
///得到菜单参数
function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
	    if (eval("frm." + ParaName)){
        	myrtn = eval("frm." + ParaName + ".value");
        }
    }
    return myrtn;
}

//hxy 2020-02-21
function setCell(value){
	if(value==1){value="Ⅰ";}
	if(value==2){value="Ⅱ";}
	if(value==3){value="Ⅲ";}
	if(value==4){value="Ⅳa";}
	if(value==5){value="Ⅳb";}
	return value;
}
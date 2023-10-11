/// ���˸���  yuliping 2017-10-10
/// ҳ���ʼ������ 
//EpisodeID=1135
var EmPCLvID=""
var parInfoArr=""  //���˻�����Ϣ
var parCheckInfo="" // ���˷�����Ϣ
var GlobalObj={};
$(function(){
	initPanelHeight();
	initPage();
	getPatInfo(EpisodeID);	//���˻�����Ϣ
	GetPatcurdetail();//��ǰ��ϸ��Ϣ
	getPatCheckInfo();//���˷�����Ϣ
	initMethod();
	LoadMoreScr(); //2023-03-07
})

function initMethod(){
	window.onresize=function(){
		$HUI.panel(".bootPanel").resize({});
		$HUI.datagrid(".hisui-datagrid").resize({});
		initPanelHeight();
	}
}

function initPanelHeight(){

	var pannelHeight=$(window).height()/2;
	$(".topPanel").css({"height":pannelHeight-15});
	$(".bottomPanel").css({"height":pannelHeight-20,"margin-top":"10px"});
	$(".body-height").each(function(){
		$(this).css({"height":$(this).parent().height()-30});
	})
}

function initPage(){
	if(ENABKEUPDLOC==1){
		$("#changeLoc").show();	
	}	
}
	
/// ͨ������Id���Ҳ�����Ϣ
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
		htmStr=htmStr+"<td class='tdWidth'>"+$g("����")+"��<span>"+parInfoArr[7]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>"+$g("�Ա�")+"��<span>"+parInfoArr[9]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>ID��<span>"+parInfoArr[6]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>"+$g("����")+"��<span>"+parInfoArr[11]+"</span></td>";
		htmStr=htmStr+"</tr>";
		
		htmStr=htmStr+"<tr>"
		htmStr=htmStr+"<td class='tdWidth'>"+$g("����")+"��<span>"+parInfoArr[12]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>"+$g("�ѱ�")+"��<span>"+parInfoArr[18]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth' colspan='2'>"+$g("���ܼ���")+"��<span>"+parInfoArr[22]+"</span></td>";
		htmStr=htmStr+"</tr>";

		htmStr=htmStr+"<tr>";
		htmStr=htmStr+"<td class='tdWidth' colspan='2'>"+$g("�绰")+"��<span>"+parInfoArr[16]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>"+$g("����")+"(KG)��<span>"+parInfoArr[35]+"</span></td>";
		htmStr=htmStr+"</tr>";
		
		htmStr=htmStr+"<tr>";	
		htmStr=htmStr+"<td class='tdWidth' colspan='3'>"+$g("��ͥ��ַ")+"��<span>"+parInfoArr[17]+"</span></td></tr> </table>";
				htmStr=htmStr+"<div style='width:100%;border-bottom:1px dashed #E2E2E2'></div>"
		
		htmStr=htmStr+"<table class='table' style='margin:5px;' ><tr>"
		if(HISUIStyleCode==="lite"){
			htmStr=htmStr+"<td>"+$g("����")+"��";
			htmStr=htmStr+"<span id='Lab'>"
			htmStr=htmStr+"<span id='Lab_01' class='icon-funnel-empty'></span><span id='Lab_1' class='checkSpan'>"+parInfoArr[29]+"</span>";
			htmStr=htmStr+"<span id='Lab_02' class='icon-funnel-half'></span><span id='Lab_2' class='checkSpan'>"+parInfoArr[30]+"</span>";
			htmStr=htmStr+"<span id='Lab_03' class='icon-funnel-eye'></span><span id='Lab_3' class='checkSpan'>"+parInfoArr[31]+"</span>";
			htmStr=htmStr+"</span>";
			htmStr=htmStr+"</td>";
			
			
			htmStr=htmStr+"<td>"+$g("���")+"��"
			htmStr=htmStr+"<span id='Exam'>"
			htmStr=htmStr+"<span id='Exam_01' class='icon-funnel-empty'></span><span id='Exam_1' class='checkSpan'>"+parInfoArr[32]+"</span>";
			htmStr=htmStr+"<span id='Exam_02' class='icon-funnel-half'></span><span id='Exam_2' class='checkSpan'>"+parInfoArr[33]+"</span>";
			htmStr=htmStr+"<span id='Exam_03' class='icon-funnel-eye'></span><span id='Exam_3' class='checkSpan'>"+parInfoArr[34]+"</span>";
			htmStr=htmStr+"</span>";
		}else{
			
			htmStr=htmStr+"<td>"+$g("����")+"��";
			htmStr=htmStr+"<span id='Lab'>"
			htmStr=htmStr+"<span id='Lab_01' style='padding-left: 20px;' class='icon-funnel-empty'></span><span id='Lab_1' class='checkSpan'>"+parInfoArr[29]+"</span>";
			htmStr=htmStr+"<span id='Lab_02' style='padding-left: 20px;' class='icon-funnel-half'></span><span id='Lab_2' class='checkSpan'>"+parInfoArr[30]+"</span>";
			htmStr=htmStr+"<span id='Lab_03' style='padding-left: 20px;' class='icon-funnel-eye'></span><span id='Lab_3' class='checkSpan'>"+parInfoArr[31]+"</span>";
			htmStr=htmStr+"</span>";
			htmStr=htmStr+"</td>";
			
			
			htmStr=htmStr+"<td>"+$g("���")+"��"
			htmStr=htmStr+"<span id='Exam'>"
			htmStr=htmStr+"<span id='Exam_01' style='padding-left: 20px;' class='icon-funnel-empty'></span><span id='Exam_1' class='checkSpan'>"+parInfoArr[32]+"</span>";
			htmStr=htmStr+"<span id='Exam_02' style='padding-left: 20px;' class='icon-funnel-half'></span><span id='Exam_2' class='checkSpan'>"+parInfoArr[33]+"</span>";
			htmStr=htmStr+"<span id='Exam_03' style='padding-left: 20px;' class='icon-funnel-eye'></span><span id='Exam_3' class='checkSpan'>"+parInfoArr[34]+"</span>";
			htmStr=htmStr+"</span>";
		}

		htmStr=htmStr+"<td style='width:150px;'>"+$g("Σ��ֵ")+"��<span id='CVR' class='checkSpan'>"+parInfoArr[26]+"</span></td></tr>";
		
		htmStr=htmStr+"<tr>"
		htmStr=htmStr+"</tr>";
		htmStr=htmStr+"</table>"
		htmStr=htmStr+"<div style='width:100%;border-bottom:1px dashed #E2E2E2'></div>"
		/*htmStr=htmStr+"<tr><td colspan='4'></td></tr>";
		htmStr=htmStr+"<tr>";*/
		htmStr=htmStr+"<table class='table' style='margin:5px;'><td class='tdWidth'>"+$g("ҽ��")+"��<span>"+parInfoArr[23]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>"+$g("���ܻ�ʿ")+"��<span>"+parInfoArr[24]+"</span></td>";
		htmStr=htmStr+"<td style='display:none' class='tdWidth'>"+$g("������")+"��<span>"+parInfoArr[25]+"</span></td>";
		htmStr=htmStr+"<td style='display:none' class='tdWidth'>"+$g("���⻤��")+"��<span>"+parInfoArr[27]+"</span></td>";
		htmStr=htmStr+"<td class='tdWidth'>"+$g("��������ʱ��")+"��"+parInfoArr[28]+"</td>";
		htmStr=htmStr+"</tr>";
		htmStr=htmStr+"<tr>";
		htmStr=htmStr+"<td colspan=5>"+$g("����ʱ��")+"��<span>"+parInfoArr[36]+"</span></td>";
		htmStr=htmStr+"</tr>";
		htmStr=htmStr+"</table>";
	
        $("#patInfo").append(htmStr);
       	//EmPCLvID=parInfoArr[19]
        
        InitPannelEvent();
		},"","false");
		
	}
	 

}
//ͨ������ID����ȡ���˷�����Ϣ
function getPatCheckInfo(){

	if(EpisodeID =="" ){
		return;
	}else{
	
		runClassMethod("web.DHCEMPatOverview","getPatCheckLevInfo",{"EpisodeID":EpisodeID,"TypeMode":1},function(jsonString){
		
		parCheckInfo = jsonString.split("^");
		
		var htmlStr="";// ������Ϣ
		htmStr="<tr><td class='tdWidth'>"+$g("����ʱ��")+"��</td><td class='tdFontWeight' style='width:200px;'>";
		htmStr=htmStr+parCheckInfo[1]+" "+parCheckInfo[2]+"</td><td class='tdWidth'>"+$g("��ʿ�ּ�")+"��</td><td class='tdFontWeight'><a ";
		/*if((parCheckInfo[0]==1)||(parCheckInfo[0]==2)){ //hxy 2020-02-21 st
			htmStr=htmStr+"style='color:red;";
			htmStr=htmStr+"'>"+parCheckInfo[0]+"��</a></td></tr>";
			}else if(parCheckInfo[0]==3){
			htmStr=htmStr+"style='color:#ffcc00;";
			htmStr=htmStr+"'>"+parCheckInfo[0]+"��</a></td></tr>";
			}else if(parCheckInfo[0]==4){
				htmStr=htmStr+"style='color:green;";
				htmStr=htmStr+"'>"+parCheckInfo[0]+"��</a></td></tr>";*/
		if(parCheckInfo[0]==1){
			htmStr=htmStr+"style='color:red;";
			htmStr=htmStr+"'>"+$g(setCell(parCheckInfo[0])+"��")+"</a></td></tr>";
		}else if(parCheckInfo[0]==2){
			htmStr=htmStr+"style='color:orange;";
			htmStr=htmStr+"'>"+$g(setCell(parCheckInfo[0])+"��")+"</a></td></tr>";
		}else if(parCheckInfo[0]==3){
			htmStr=htmStr+"style='color:#ffcc00;";
			htmStr=htmStr+"'>"+$g(setCell(parCheckInfo[0])+"��")+"</a></td></tr>";
		}else if(parCheckInfo[0]==4){
			htmStr=htmStr+"style='color:green;";
			htmStr=htmStr+"'>"+$g(setCell(parCheckInfo[0])+"��")+"</a></td></tr>";
		}else if(parCheckInfo[0]==5){
			htmStr=htmStr+"style='color:green;";
			htmStr=htmStr+"'>"+$g(setCell(parCheckInfo[0])+"��")+"</a></td></tr>"; //ed		
		}else{
			htmStr=htmStr+"style='";
			htmStr=htmStr+"'>"+"</a></td></tr>";
			}
		
		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("����ȥ��")+"��</td><td class='tdFontWeight'>";
		
		if(parCheckInfo[23]==$g("����")){
			htmStr=htmStr+"<span class='redSpan'>"
			}else if(parCheckInfo[23]==$g("����")){ //hxy 2020-02-21 st
				htmStr=htmStr+"<span class='orangeSpan'>" //ed
				}else if(parCheckInfo[23]==$g("����")){
					htmStr=htmStr+"<span class='yellowSpan'>"
					}else if(parCheckInfo[23]==$g("����")){
						htmStr=htmStr+"<span class='greenSpan'>"
						}else{
							htmStr=htmStr+"<span>"
							}
		
		htmStr=htmStr+parCheckInfo[23]+"</span><span style='margin-left:20px;color:#000000;'>"+parCheckInfo[28]+"</span></td><td class='tdWidth'>"+$g("���ﻤʿ")+"��</td><td class='tdFontWeight'>";
		htmStr=htmStr+parCheckInfo[24]+"</td></tr>";
		
		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("��ɫͨ��")+"��</td><td class='tdFontWeight'>";
		htmStr=htmStr+parCheckInfo[25]+"</td><td class='tdWidth'>"+$g("���޲���")+"��</td><td class='tdFontWeight'>";
		htmStr=htmStr+parCheckInfo[26]+"</td></tr>";
		
		
		var htmPCBStr=""
		htmPCBStr="<tr class='trCenter'><th style='border-left:1px solid #FFFFFF;'>����</th><th>����</th><th>����</th><th>����ѹ</th><th>����ѹ</th><th>����</th><th>SPO2</th></tr>";		// ��������
		htmPCBStr=htmPCBStr+"<tr class='trCenter' style='height:35px;'><td style='border-left:1px solid #FFFFFF;'>"+parCheckInfo[10]+"</td><td>"+parCheckInfo[11]+"</td><td>"+parCheckInfo[12]+"</td>"	
	
		if((parCheckInfo[13]!="")){
			var str=parCheckInfo[13].split(":");
			}else{
				var str="/ "
			}
		
		var sstr=str[0].split("/")
		htmPCBStr=htmPCBStr+"<td>"+sstr[0]+"</td><td>"+sstr[1]+"</td><td>"+str[1]+"</td><td>"+parCheckInfo[14]+"</td></tr>";	
		htmPCBStr=htmPCBStr+"<tr class='trCenter'> <td style='border-left:1px solid #FFFFFF;'>��</td><td>"+$g("��/��")+"</td><td>"+$g("��/��")+"</td><td>mmHg</td><td>mmHg</td><td>"+$g("��/��")+"</td><td>%</td></tr>"
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

// �������
function getDiagnos(){
	
	if(EpisodeID =="" ){
		return;
	}else{
	
		runClassMethod("web.DHCEMPatOverview","getDiagnosis",{"MRADMID":EpisodeID},function(jsonString){
		
		var DiagnosArr = jsonString.split("!");
		var htmStr="<tr class='trLeft'><th style='width:150px;border-left:1px solid #FFFFFF;'><span>�������</span></th><th style='border-right:1px solid #FFFFFF;'><span>���</span></th></tr>";// ������Ϣ
		for(var i=0;i<DiagnosArr.length;i++){
			var diagnos = DiagnosArr[i].split("^");
			htmStr=htmStr+"<tr class='trLeft' style='height:30px;'><td style='border-left:1px solid #FFFFFF;'><span>"+trsUndefinedToEmpty(diagnos[5])+"</span></td>"+"<td style='border-right:1px solid #FFFFFF;'><span>"+trsUndefinedToEmpty(diagnos[0])+"</span></td></tr>";
		}
		$("#patDiagnos").append(htmStr)
		},"","false");
	}
}

//������ת״̬
function getPatCurStatus(){
	if(EpisodeID =="" ){
		return;
	}else{
	
		runClassMethod("web.DHCEMPatCurStatus","FindAdmstatusTotal",{"EpisodeID":EpisodeID},function(jsonString){
		
		var CurStatus = jsonString.split("$$");
		var htmStr="";
		htmStr="<tr><th>ʱ��</th><th>״̬</th><th>������Ա</th></tr>";
		
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
//������Ϣˢ��
function refreshDiv(){
	$("#patInfo").empty();
	getPatInfo();
	}
//���ز�������
function hideDiv(){
	
	$('.box').hide()
}
function hideDivT(){
	$('.boxT').hide()
	
}

// ��ʾ״̬��ϸ
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
						 '<span class="txt">'+list[i].split("^")[3]+'&nbsp;&nbsp;&nbsp;'+$g("������")+":"+list[i].split("^")[4]+'</span>'+
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
		
		var htmlStr="";// ������Ϣ
		htmStr="<tr><td >"+$g("����ʱ��")+"��</td><td class='tdWidthl'>";
		htmStr=htmStr+parCheckInfo[1]+"</td><td class='tdWidth' >"+$g("��ʿ�ּ�")+"��</td><td>";
		htmStr=htmStr+parCheckInfo[0]+"</td>";
		
		htmStr=htmStr+"<td class='tdWidth'>"+$g("����ȥ��")+"��</td><td>";
		htmStr=htmStr+parCheckInfo[23]+"</td></tr><tr><td >"+$g("���ﻤʿ")+"��</td><td class='tdWidthl'>";
		htmStr=htmStr+parCheckInfo[24]+"</td>";
		
		htmStr=htmStr+"<td class='tdWidth'>"+$g("��ɫͨ��")+"��</td><td>";
		htmStr=htmStr+parCheckInfo[25]+"</td><td class='tdWidth'>"+$g("���޲���")+"��</td><td>";
		htmStr=htmStr+parCheckInfo[26]+"</td></tr>";
		
		
		htmStr=htmStr+"<tr><td >"+$g("���﷽ʽ")+"��</td><td class='tdWidthl'>";
		htmStr=htmStr+parCheckInfo[6]+"</td><td class='tdWidth' >"+$g("��ʶ״̬")+"��</td><td>";
		htmStr=htmStr+parCheckInfo[8]+"</td>";
	
		htmStr=htmStr+"<td class='tdWidth'>"+$g("������Ⱥ")+"��</td><td>";
		htmStr=htmStr+parCheckInfo[27]+"</td></tr>"
		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("����ʷ")+"��</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[19]+"</td></tr>";

		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("֢״")+"��</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[3]+"</td></tr>";
		
		htmStr=htmStr+"<tr><td colspan='6' style='border-bottom:1px solid #333333'></td></tr>"
		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("��������")+"��</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[20]+"</td></tr>";
		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("����˹��")+"��</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[22]+"</td></tr>";
		htmStr=htmStr+"<tr><td class='tdWidth'>"+$g("��ʹ����")+"��</td><td colspan='5'>";
		htmStr=htmStr+parCheckInfo[21]+"</td></tr>";
		
		var htmPCBStr=""
		htmPCBStr="<tr><th>����(T)</th><th>����(HR)</th><th>����(R)</th><th>Ѫѹ(BP)����ѹ</th><th>����Ƶ��(R)</th><th>Ѫ�����Ͷ�(SPO2)</th></tr>";		// ��������
		htmPCBStr=htmPCBStr+"<tr><td>"+parCheckInfo[10]+"��</td><td>"+parCheckInfo[11]+"("+$g("��/��")+")</td><td>"+parCheckInfo[12]+"("+$g("��/��")+")</td>"
		var str=parCheckInfo[13].split(":");
		htmPCBStr=htmPCBStr+"<td>"+str[0]+"(mmHg)</td><td>"+str[1]+"("+$g("��/��")+")</td><td>"+parCheckInfo[14]+"(%)</td></tr><tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>";	
		var htmScoStr="";
		htmScoStr=htmScoStr+"<tr><td>"+$g("��������")+"</td><td>"+$g("����˹������")+"</td><td>"+$g("��ʹ����")+"</td></tr>";	
		htmScoStr=htmScoStr+"<tr><td>"+parCheckInfo[20]+"</td><td>"+parCheckInfo[22]+"</td><td>"+parCheckInfo[21]+"</td></tr>";	
		
		$("#detailDivT").append(htmStr);
		$("#detTitleT").append($g("���˷�����Ϣ"));
		
			},"","false");
	}
}
	
	//undeתΪ��
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
	if ('undefined'!==typeof websys_getMWToken){
		lnk += "&MWToken="+websys_getMWToken();
	}
	window.open(lnk,"_blank","top=100,left=0,width="+(blankWidth-20)+"px,height="+(blankHeight-180)+"px,menubar=yes,scrollbars=yes,toolbar=no,status=no");
	//window.open(lnk, "_blank", "dialogHeight: " + (top.screen.height - 530) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
	}

/// ����Panel
function InitPannelEvent(){


	$('#Lab,#Exam,#CVR').each(function(){
		var that = $(this)
		var thatwidth="710px ";
		that.parent().on({
			mouseenter:function(){
				if(that.attr("id")=="Lab"){/*hxy 2018-07-06 ��Ϊ0ʱ������ܽ*/
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
					thatwidth="520px";
				}/*hxy ed*/

				if (LoadPopover("Load",that.attr("id"))){
					var HTML=GetPannelHTML(that.attr("id"));
					if (HTML.innerHTML==""){return;}
					that.popover({
						title:HTML.Title,
						content:HTML.innerHTML,
						trigger:'hover',
						placement:'bottom-right',
						width:thatwidth,
						delay:{show: null,hide:500},
						onShow:function(){
							//alert(that.attr("id"))
							if (LoadPopover("Show",that.attr("id"))){
								if (typeof HTML.CallFunction == "function"){
									HTML.CallFunction.call();
								}
							}
						}
					});
					that.popover('show');
				}
			}
		});
	})
	/*
	return;
	$('.status-list li .inittxt').each(function(){

		if (($(this).text().indexOf("���") == "-1")&($(this).text().indexOf("����") == "-1")){
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

///��ȡ��̬д���HTML����
function GetPannelHTML(LinkID){
	var innerHTML="";
	var CallFunction={};
	var Title="";
	if (LinkID.indexOf("Lab") != "-1"){
		//����
		//if ($("#LabCount").text()>0){
			Title=$g("�����б�");
			innerHTML+='<table id="LabOrdGrid"></table>'; /// hxy 2018-07-06
			CallFunction=LoadLabOrdGrid;
		//}
	}
	if (LinkID.indexOf("Exam") != "-1"){
		//���
		//if ($("#ExamCount").text()>0){
			//innerHTML+='<table id="ExamOrdGrid"></table>';
			Title=$g("����б�");
			innerHTML+='<table id="ExamOrdGrid"></table>'; /// hxy 2018-07-06 
			CallFunction=LoadExamOrdGrid;
		//}
	}
	if (LinkID.indexOf("CVR") != "-1"){
		//Σ��ֵ yuliping 2018-03-23
		//if ($("#ExamCount").text()>0){
			//innerHTML+='<table id="CVReportGrid"></table>';
			Title=$g("Σ��ֵ");
			innerHTML+='<table id="CVReportGrid"></table>'; ///  hxy 2018-07-06
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
		{title:'״̬',field:'Title',width:90,formatter:function(value,rec){
			if(rec.ARCIMDesc!=""){
				return "";
			}else{
				return $g(value);
			}
		}},
		{title:'ҽ������',field:'ARCIMDesc',width:90},
		{title:'ҽ������',field:'TestSetName',width:90,hidden:true},
		{title:'״̬',field:'Status',hidden:true},
		{title:'ҽ��id',field:'OrderId',width:90,hidden:true},
		{title:'����id',field:'ReportId',width:90,hidden:true},
		{title:'�����',field:'VisitNumber',width:90},
		{title:'��Ѫʱ��',field:'SpecCollDate',width:90},
		{title:'����ʱ��',field:'RequestTime',width:90,hidden:true},
		{title:'����ʱ��',field:'ReceiveTime',width:90},
		{title:'����ʱ��',field:'ReportTime',width:90},
		{title:'��������',field:'labReportLink',width:90,
			formatter:function(value,rec){
				
 				var BtnHTML="";
 				 ///������ 1 ���ѽ��� 2 ���ѱ��� 3
 				if (rec.Status!="3"){
	 				return BtnHTML;
	 			}else{
		 			var BtnHTML = '<a href="#" class="editcls" onclick="switchTabByEMR(\'' + rec.OrderId + '\')">'+$g("����")+'</a>'; //'<a class="editcls" onclick="ipdoc.pattreatinfo.view.OpenLabReport(\'' + rec.ReportId + '\')">����</a>';
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
		    title:'', //�����б� hxy
		    headerCls:'panel-header-gray',
		    bodyCls:'panel-header-gray',  //hxy 2023-02-02
		    idField:'Index',
		    treeField:'Title',
		    fit : false,
		    width:690,
		    height:225, //280 hxy
		    border: true, //false
		    columns:LabOrdColumns
		});
	});
}

function switchTabByEMR(OrderId){
	//parent.switchTabByEMR("������");
	parent.switchTabByEMR($g("������"),{"oneTimeValueExp":"OEORIID="+OrderId});	
}
function switchInspectTab(OrderId){
	//parent.switchTabByEMR("��鱨��");
	parent.switchTabByEMR($g("��鱨��"),{"oneTimeValueExp":"OEORIID="+OrderId});	
}

///���ҽ��������״�б�
function LoadExamOrdGrid(){
	var ExamOrdColumns=[[    
        {title:'Index',field:'Index',hidden:true},
        {title:'Oeori',field:'Oeori',hidden:true},
        {title:'״̬',field:'Title',width:80},
        {title:'ҽ��������',field:'ItemLabel',width:200},
        {title:'��λ/�걾',field:'ItemSpec',width:100},
        {title:'ִ�п���',field:'ItemLoc',width:100},
        {title:'ʱ��',field:'ItemTime',width:120},
        {title:'��������',field:'ExamReportLink',width:100,
			formatter:function(value,rec){
 				var BtnHTML="";
 				///������ A ����"�Ǽ�"��"ԤԼ"�� ���ѱ��� C
		
		 		if((rec.ItemLabel)&&(rec._parentId=="����")){
			 		var BtnHTML = '<a href="#" class="editcls" onclick="switchInspectTab(\'' + rec.Oeori + '\')">'+$g("����")+'</a>';     // '<a class="editcls" onclick="ipdoc.pattreatinfo.view.OpenExamReport(\'' + rec.StudyNo + '\')">����</a>';	
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
		    title:'', //����б� hxy
		    headerCls:'panel-header-gray',
		    bodyCls:'panel-header-gray', //hxy 2023-02-02
		    idField:'Index',    
		    treeField:'Title',
		    fit : false,
		    width:690, //680
		    height:225, //280 //200
		    border: true, //false  
		    columns:ExamOrdColumns
		});
	});
	
}
	
var LoadPopover=(function(){
	///��ֹ��γ�ʼ������
	var AlreadLoadObj={};	//��ʼ��Ԫ��
	var AlreadShowObj={};	//��ʼ����ʾ����
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
			{title:'����ID',field:'ReportId', hidden:true},
	        {title:'ҽ������',field:'TSName',width:200},
	        {title:'Σ��ֵ��������',field:'ReportType',width:120},
	        {title:'Σ��ֵ���ʹ���',field:'DPRPType', hidden:true},
	        {title:'��ʾ��ʾ',field:'DPRPAlert',width:120},
	        {title:'����״̬',field:'ReportStatus', hidden:true},
	        {title:'��������',field:'DateTime', hidden:true},
	        {title:'��������',field:'ApplyDT', hidden:true},
	        {title:'����ʱ��',field:'SamplingDT', hidden:true},
	        {title:'����ʱ��',field:'ReceiveDT', hidden:true},
	        {title:'���ʱ��',field:'AuditDT', hidden:true},
	        {title:'�걾',field:'Specimen', hidden:true},
	        {title:'����',field:'CVReportBtn',
 				formatter:function(value,rec){
                   var btn = '<a class="editcls" style="cursor: pointer;" onclick="CVReportBtnClickHandler(\'' + rec.ReportId + '\',\'' + rec.DPRPType + '\')">'+$g("����")+'</a>';
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
			    title:'',//Σ��ֵ hxy
			    headerCls:'panel-header-gray',
			    bodyCls:'panel-header-gray', //hxy 2023-02-02
			    idField:'Index',
			    treeField:'Title',
			    fit : false,
			    width:500, //500
			    height:225, //300
			    border: true, //false
			    columns:CVReportColumns
			});
		});
	}
 function CVReportBtnClickHandler(ReportId,DPRPType){
	 var lnk="criticalvalue.trans.hisui.csp?ReportId="+ReportId+"&RepType="+DPRPType;
	 websys_showModal({
		url:lnk,
		iconCls:"icon-w-paper",
		title:$g('Σ��ֵ����'),
		width:760,
		height:500,
		onClose: function() {
			
		}
	});
	}
	
function changeLoc(){
	_showChangeAdmLocPanel(EpisodeID);
}

//ʹ�þֲ�ˢ��,��������һ����Ⱦ�����ظ�ʹ�ýϿ�
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

/// Э���װ,2014-05-30,by xp,End
///�õ��˵�����
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
	if(value==1){value="��";}
	if(value==2){value="��";}
	if(value==3){value="��";}
	if(value==4){value="��a";}
	if(value==5){value="��b";}
	return value;
}

/// �����鿴:���ں�
function LoadMoreScr(){

	var Obj={
		EpisodeID:EpisodeID
	}
	
	websys_emit("onPatOverViews",Obj);
}

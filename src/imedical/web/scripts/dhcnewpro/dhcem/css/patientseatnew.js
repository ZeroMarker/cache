var dragFlag=true;   /// �϶����
var TmpTrsSeat = ""; /// ת����λ
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgParams=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
var defaultCardTypeDr //Ĭ�Ͽ�����
$(function(){
	
	initParam();
	
	initPage();
	
	//��ʼ��combobox
	initCombo(); 
	
	initOneMethod();
	
	initPageDomMethod();
	
    ///��ʼ�����棬��λͼ�����ɺ͵ȴ������˵�����,�Լ�easyui���
    InitBedPage();
	
	//
	beginrefresh(); 
	 
	initMondelMethod(); 
	
	initWaitArea(); /// ��ʼ���Ⱥ��� bianshuai 2019-02-19
	 
	//ʱ����ʾ  ��ʱע��
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
		seatWidth:210,
		seatHeight:45
	}
	
	if(SEATVIEWDEF==1){
		seatObj.seatHeight=216;
	}
	
	//��ǰѡ�д�λ��Ϣ
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
	
	//��ǰѡ�д�λ��Ϣ
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
	
	//����ģʽ
	planModel="";
	
	obsPatTable = {
		checkIndex:"",  //ָ�룺ָ��datagrid��ǰѡ�е���	
	};
	
	selSeatPat={  	  //ָ��ѡ�еĴ�λ����
		seatID:"",	  //ͨ������ֶο����жϴ�λ�Ƿ�ѡ��
		adm:"",		  //ͨ�������ֶο����ж�ѡ�д�λ�Ƿ�����
		planSeatID:"" //���ŵ�ʱ��Ҫ���ŵĴ�λID
	};
	dataFormat="";
	runClassMethod("web.DHCEMCommonUtil","DateFormat",{},
		function(data){
			dataFormat=data;
		},"text",false);
}

function InitBedPage() {	
    //���÷���ִ�к�̨����
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
			$.messager.alert("��ʾ","û����λ��");
			return;	
		}

		initpatient(row,cow);  //��ʼ����λ
		initPatientText(row,cow,str,noPerple);  //��λ����ʾ������
	});
  
}

//��ʼ����λ
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
			"<div class='hasSyOrdMes'>"+$g("ҽ")+"</div>"+
			"<div class='sickbedBorder'></div>"+
			"<div class='sickbedOpPanel' style='display:none;'><a href='#' onclick='plantPatBtn()' style='font-weight:600;border-radius:5px;border:none'>"+$g("����")+"</a></div>"+
			"<div class='sickbedContent'>"+
				"<span class='posInline bedName' id='bedName"+i+"' style='line-height:32px;font-weight:700;'></span>"+
				"<span class='posInline' id='patName1' style='line-height:32px;width:59px;font-weight:700;'></span>"+
				"<span class='posInline' id='planDate"+i+"' style='line-height:32px;width:40px;text-align:right;font-weight:700;'></span>"+
				"<span class='seat-btn-icon' id='patSexImg"+i+"'>&nbsp;</span>"+
				"<div id='patInfo2' style='height:150px;padding-left:10px;'>"+
					"<div><span class='bed-span'>"+$g("����")+"��</span><span id='patName2'></span><span id='patSex2'></span><span id='patAge2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("�ѱ�")+"��</span><span id='patFei2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("�ǼǺ�")+"��</span><span id='patRegNo2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("���")+"��</span><span id='MRDiagnos2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("����ԭ")+"��</span><span id='AllergyInfo2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("�������")+"��</span><span id='PatInDep2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("����ʱ��")+"��</span><span id='PaAdmTime2'></span></div>" +
	                "<div><span class='bed-span'>"+$g("����ҽ��")+"��</span><span id='MainDoc2'></span></div>" +
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
			"<div class='ArrangeBtn hideItm' id='ArrangeBtn"+i+"'></div>"+       //�������ֻΪ�˴洢����
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
		$('.sickbed').css('width',210);
		$('.sickbed').css('height',45);	
		$('.sickbedBorder,.sickbedOpPanel').css('width',210);
		$('.sickbedBorder,.sickbedOpPanel').css('height',45);
		$('.sickbedContent').css('width',206);
		$('.sickbedContent').css('height',41);
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
	$("#doccancel").unbind(); /// ����ҽ��ȡ��
	$("#docsure").unbind(); /// ����ҽ��ȷ��
	
	$("#plantBtn").bind('click',ArrPatSeat);  /// planPat
	$("#ClearArrBtn").bind('click',clearSeat);
	$('#winArrBtn').bind('click',arrangePat);
	$('#TransBtn').bind('click',transfuse);
	$('#readCardBtn').bind('click',readCardNo);
	$('#wriArea').bind('click',InsPatWaitArea); /// �Ⱥ�
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	$("#doccancel").bind('click',DoCancel);  /// ����ҽ��ȡ��
	$("#docsure").bind('click',DocSure);  /// ����ҽ��ȷ��
	$('#PrintSeatCardBtn').bind('click',newPrintXmlMode);
}

/// �ǼǺ� �س��¼�
function PatRegNo_KeyPress(e){

	if(e.keyCode == 13){
		var TmpPatNo = $("#patRegNo").val();
		if (!TmpPatNo.replace(/[\d]/gi,"")&(TmpPatNo != "")){
			///  �ǼǺŲ�0
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

/// �ǼǺ� �س��¼�
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var TmpPatNo = $("#PatNo").val();
		if (!TmpPatNo.replace(/[\d]/gi,"")&(TmpPatNo != "")){
			///  �ǼǺŲ�0
			TmpPatNo = GetWholePatNo(TmpPatNo);
			$("#PatNo").val(TmpPatNo);
		}
		$("#obsPatTable").datagrid("load",{"LgLocID":LgLocID,"TmpPatNo":TmpPatNo}); 
		
	}
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
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
		var seatColor = strArr[i].split("^")[3];  //��λ����
		var seatID = strArr[i].split("^")[4];  //
		var seatName = strArr[i].split("^")[5];
		//$.messager.alert("��ʾ"strArr[i].split("^")[1]);
		var num = (strArr[i].split("^")[1].split("-")[0]-1)*cow+parseInt(strArr[i].split("^")[1].split("-")[1]);
		if(seatColor=="") seatColor="#77AAFF";
		$("#sickbed"+num).attr("seatId",seatID);
		$(".sickbed #bedName"+num).text(seatName);
		if(seatColor!=""){
			//$(".sickbed #bedName"+num).css("color",seatColor);
			$(".sickbed #bedName"+num).css("background",seatColor); //2023-01-12
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
			$("#sickbed"+num).addClass("onDroppable");   //���÷����¼�
			$("#sickbed"+num).find("#patInfo2").html("");
			$("#sickbed"+num).find(".sickbedOpPanel").show();
		}
		
	   if(hasPat=="YY"){ ///��λͼ������ռ��  yyt 2019-05-01
			var patName  = strArr[i].split("^")[8];
			var regNo  = strArr[i].split("^")[9];
			var PaAdmDate  = strArr[i].split("^")[10];
			var PaAdmTime  = strArr[i].split("^")[11];
			var PrvDoc  = strArr[i].split("^")[12];
			
			var sexHtmlStr=""
			sexHtmlStr = 			 '<div style="margin-top:5px;margin-left:8px;">';
			sexHtmlStr = sexHtmlStr +'<span style="color:red">'+$g("���۲���ռ��");
			sexHtmlStr = sexHtmlStr +'	</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("����")+"��"+ patName +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div style="margin-top:5px">';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("�ǼǺ�")+"��"+ regNo +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("����")+"��"+ PaAdmDate +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("ʱ��")+"��"+ PaAdmTime +'</span>'; //&nbsp;&nbsp;&nbsp;
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("ҽ��")+"��"+ PrvDoc +'</span>'; //&nbsp;&nbsp;&nbsp;
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
			var PaAdmTime = thisPatInfo.split("^")[19];   /// �¼� 2019-03-04 bianshuai
			var MainDoc = thisPatInfo.split("^")[20];     /// �¼� 2019-05-30 bianshuai
			var InSeatDateLimit = thisPatInfo.split("^")[21];
			var AllergyInfo = thisPatInfo.split("^")[22];
			var AdmAbnormal = thisPatInfo.split("^")[23];
			var PatSexDesc = thisPatInfo.split("^")[24];  ///�Ա�
			
			if(AdmAbnormal=="Y"){
				popTipNumber++;
				$.messager.popover({
					msg: $g('��λ��')+seatName+$g('�Ļ���')+patName+$g('�޷���ȡ��Ч����(δ�ҺŻ��߹Һ�ʧЧ(�˺�)),���ʵ!'),
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
			$(".sickbed #Transfuse"+num).attr("patFlag",$g("����"));
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
				$("#sickbed"+num).find("#MRDiagnos2").html("<span style='color:#fff'>"+$g("��")+"</span>");
			}else{
				$("#sickbed"+num).find("#MRDiagnos2").html(MRDiagnos);
			}
			if(AllergyInfo===""){
				$("#sickbed"+num).find("#AllergyInfo2").html("<span style='color:#fff'>"+$g("��")+"</span>");
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
			
			var sexHtmlStr = "",sexIcon=""
			AllPersonNum++
			SexNumberObj[PatSexDesc]=(SexNumberObj[PatSexDesc]?SexNumberObj[PatSexDesc]+1:1); ///��¼�Ա�
			
			if(PatSexDesc==$g("��")){  //�� 	ManSeatNum++;
				sexIcon="pat_mannew";
			}else if(PatSexDesc==$g("Ů")){   //Ů WomanSeatNum++;
				sexIcon="pat_womannew";
			}else {	//δ֪ UnknownSeatNum++;
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
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("���")+'��'+ MRDiagnos +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			//sexHtmlStr = sexHtmlStr + '		<span>'+ PaAdmTime +'</span>';
			sexHtmlStr = sexHtmlStr + '		<span>'+$g("ҽ��")+'��'+ MainDoc+ '</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			$(".sickbed #patientBody"+num).append(sexHtmlStr);
			$(".sickbed #patientNum"+num).text(seatName);
			var seatShowName="";
			patName.length>5?seatShowName=patName.substring(0,5)+"..":seatShowName=patName;
			
			//$(".sickbed #patName"+num).text(seatShowName);
			$("#sickbed"+num).find("#patName1").html(seatShowName);
			$(".sickbed #patSexImg"+num).addClass(sexIcon);
			$(".sickbed #planDate"+num).text(InSeatDateLimit);
			
			$("#sickbed"+num).find(".patientNum").addClass("onDraggable");
			
			$HUI.tooltip("#sickbed"+num,{
				position: 'bottom',
				trackMouse:true,
			    content:  
				    '<div style="color: #ffffff;">' +
	                '<div>'+$g('����')+'��'+patName+'</div>' +
	                '<div>'+$g('����')+'��'+patAge+'</div>' +
	                '<div>'+$g('�Ա�')+'��'+PatSexDesc+'</div>' +
	                '<div>'+$g('�ѱ�')+'��'+patFei+'</div>' +
	                '<div>'+$g('�ǼǺ�')+'��'+regNo+'</div>' +
	                '<div>'+$g('���')+'��'+MRDiagnos+'</div>' +
	                '<div style="width:200px">'+$g('����ԭ')+'��'+AllergyInfo+'</div>' +
	                '<div>'+$g('�������')+'��'+PatInDep+'</div>' +
	                '<div>'+$g('����ʱ��')+'��'+PaAdmTime+'</div>' +
	                '<div>'+$g('����ҽ��')+'��<span id="TipMainDoc">'+MainDoc+'</span></div>' +
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
	
	///���úͽ���
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
				  $.messager.alert("��ʾ","����λ��ռ�ã����ܷ��䣡","warning");
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

/// �����б��϶��¼�
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
			if (PatBaseObj) InitCurSeatObject(PatBaseObj);  /// ������λ����
			
		},
		stop:function(){
	   	   $(".proxy").css("display","none");
	    }
	});		
}
function initSeatClick(){
	
	$('.sickbed').on('click',function(){    //���˵�ʱ������λ���԰���
		seatClickFun(this,"");
	}).bind("contextmenu", function(e){
			/// �����Ҽ��˵� 2019-02-21 bianshuai
			e.preventDefault(); //��ֹ����������Ҽ��¼�
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
	           //��ʾ�Ҽ��˵�  
	           left: e.pageX,//�����������ʾ�˵�  
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
	   $.messager.alert("��ʾ","����λ��ռ�ã����ܷ��䣡","warning");
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

	//���õ�ǰ
	if($(_this).hasClass("sickbed-selected")){
		var $obj=$(_this).find(".ArrangeBtn");
		setCurSelSeat($obj);		
	}
	setEprMenuForm(curSelSeat.admId,curSelSeat.patId);
	///�����б���  yyt
	var SelData = $("#obsPatTable").datagrid("getSelections");  //�������
	if(($(_this).find(".ArrangeBtn").attr("patId")===undefined)&&(SelData.length)){   //ѡ�еȺ���������ѡ�д�λ�ϲ���
		$HUI.combobox("#UserTradeSeatBt").setValue($(_this).find(".ArrangeBtn").attr("seat"));
		$('#SeatRowId').val($(_this).find(".ArrangeBtn").attr("seatId"));
		$('#CardNum').val($(_this).find(".ArrangeBtn").attr("CardNo"));	
		loadPlanPatWin(SelData)
		return;
	}
	checkOrUnCheck(obsPatTable.checkIndex)  //���ѡ����

	return false;
		
}

//������ʾʱ�䣬1s��ˢ��һ��
function beginrefresh(){
	var time=new Date();
	var y=time.getFullYear(); //��ȡ��
	var m=time.getMonth()+1; //��ȡ��
	var d=time.getDate(); //��ȡ��
	var h=time.getHours(); //��ȡСʱ
	var M=time.getMinutes(); //��ȡ��
	var s=time.getSeconds(); //��ȡ��
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
        str = $g("������");  
	} else if (week == 1) {  
        str = $g("����һ");  
	} else if (week == 2) {  
        str = $g("���ڶ�");  
	} else if (week == 3) {  
        str = $g("������");  
	} else if (week == 4) {  
        str = $g("������");  
	} else if (week == 5) {  
        str = $g("������");  
	} else if (week == 6) {  
        str = $g("������");  
	}  
  	$("#showNowWeek").text(str);
}


function clearData(){
	//alert("�������");
	dragPatInfo.seatId="";
	dragPatInfo.regNo="";
	}

//������ŵ�ʱ��
function planPat(e){
	//��Ϣֱ��dom��������ȥ�˺��콻�����ٶȱ��'
	e=e||event;
	CleanModel();  											//����������
	$HUI.window("#wind").open();
	$('#SeatRowId').val(curSelSeat.seatRowId);
	$('#CardNum').val(curSelSeat.cardNo);
	$('#UserName').val(curSelSeat.patName);
	$('#RegiNum').val(curSelSeat.regNo);
	$('#UserSecRank').val(curSelSeat.secretLev);
	$('#UserRank').val(curSelSeat.patLev);
	$('#PatId').val(curSelSeat.patId);	
	$('#PaAdm').val(curSelSeat.admId);
	
	clearCurSelSeat();  /// ���ѡ�ж��� bianshuai 2019-03-04
	
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
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// ����������� 2019-03-04 bianshuai
	
	return false;
}


//�ƶ������������
function planPatByMove(seatID){
	
	CleanModel();  				//����������
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
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// ����������� 2019-03-04 bianshuai
	$("#wriArea").linkbutton('disable');      /// �Ⱥ�ť������  bt_waitarea
	clearCurDropSeat();	
	return false;
}

/// ����
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
	   			$.messager.alert("��ʾ","����Ч!");
	   		}
			if ((myary[0]=="0")&&(myary[1]!="undefined")){
				$('#CardNum').val(myary[1]);
				GetValidatePatbyCard();
			}			
		},"text",false
	)


/* 	/// ������ID
	var CardTypeRowId = "";
	var CardTypeValue = $("#EmCardType").val();
	
	if (CardTypeValue != "") {
		var CardTypeArr = CardTypeValue.split("^");
		CardTypeRowId = CardTypeArr[0];
	}
	
	var myrtn = DHCACC_GetAccInfo(CardTypeRowId, CardTypeValue);
	if (myrtn==-200){ //����Ч
		$.messager.alert("��ʾ","����Ч-1!");
		return;
	}
	
	var myary = myrtn.split("^");
	var rtn = myary[0];
	
	switch (rtn) {
		case "0":
			//����Ч
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#CardNum').val(CardNo);
			$('#RegiNum').val(PatientNo);
			GetEmRegPatInfo();
			break;
		case "-200":
			//����Ч
			$.messager.alert("��ʾ","����Ч!");
			break;
		case "-201":
			//�ֽ�
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#CardNum').val(CardNo);     /// ����
			$('#RegiNum').val(PatientNo);   /// �ǼǺ�
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
	
	var myCardNo = $('#CardNum').val();   //����
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
		 'CardTypeDR':CardTypeRowId,   //ȫ�ֱ���
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
						
								$("#RegiNum").val(myDataArr[2]);      /// �ǼǺ�;
								$("#PatId").val(myDataArr[3]);  /// ����ID
								GetEmRegPatInfo("");
								return;
						}
					},"text"
				)
			}else{
				clearCurDropSeat();  //��տ�����Ϣ
				switch(myary[0]){
					case "-340":
						$.messager.alert("��ʾ","����ʱ,�˿��Ѿ��ж�Ӧ�ĵǼǺ���,������������");
						break;
					case "-350":
						$.messager.alert("��ʾ","�˿��Ѿ�ʹ��,�����ظ�����!");
						break;
					case "-351":
						$.messager.alert("��ʾ","�˿��Ѿ�����ʧ,����ʹ��!");
						break;
					case "-352":
						$.messager.alert("��ʾ","�˿��Ѿ�������?����ʹ��!");
						break;
					case "-356":
						$.messager.alert("��ʾ","����ʱ,����Ҫ����������¼,���Ǵ˿����ݱ�Ԥ�����ɴ���!");
						break;
					case "-357":
						$.messager.alert("��ʾ","����ʱ,����Ҫ����¿���¼,���Ǵ˿�����û��Ԥ������!");
						break;
					case "-358":
						$.messager.alert("��ʾ","����ʱ,�˿��Ѿ��ж�Ӧ�ĵǼǺ���,������������");
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
	    {'CardNo':'','RegNo':$('#RegiNum').val(),'LgHospID':LgHospID},
		    function(data){
			    SettingModel(data);
		},"text",false);
}

//ȡ������
function clearSeat(){
	var patAdm = $('#PaAdm').val();
	if(patAdm==""){
		$.messager.alert("��ʾ","��ѡ�л��ߣ�");
		return;
	}
    //�жϲ����Ƿ��ڵȺ���   yyt   2019-05-11
	var ID=MyRunClassMethod("web.DHCEMPatientSeat","GetPatWaitID",{'EpisodeID':patAdm,'LgLocID':LgCtLocID}); //�Ⱥ��������뿪
    if(ID!=""){
	  $.messager.confirm('ȷ�϶Ի���','��ǰ���ˣ��Ƿ��뿪�Ⱥ�����', function(r){
			if (r){
			    MyRunClassMethod("web.DHCEMPatientSeat","UpdWaitAreaFlag",{'ID':ID}); //�Ⱥ��������뿪
		        CleanModel();
		        clearCurSelSeat();                     /// ��� curSelSeat ���� 
		        $HUI.window("#wind").close();
		        $("#obsPatTable").datagrid("reload");  /// ˢ�µȺ�������
			}
		});
	}else{
		$.messager.confirm('ȷ�϶Ի���','��ǰ���ˣ��Ƿ��뿪��', function(r){
			if (r){
			  	MyRunClassMethod("web.DHCEMPatientSeat","ClearPatSeat",{'adm':patAdm,'loc':LgCtLocID,'user':LgUserID});
				clearCurSelSeat();  /// ��� curSelSeat ����
				CleanModel(); 
				$HUI.window("#wind").close();
				loadComboChangeSeat();
				InitBedPage();
				$("#obsPatTable").datagrid("reload");  /// ˢ�µȺ�������
			}
		});
	}
}

/// �����а��Ų���
function arrangePat(){
	
	var SeatRowId = $("#SeatRowId").val();
	
	var EpisodeID = $("#PaAdm").val(); /// ����ID
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����");
		return;
	}
	
	if (SeatRowId == ""){
		$.messager.confirm('ȷ�϶Ի���','��ǰ��λΪ�գ��Ƿ���뵽�Ⱥ�����', function(r){
			if (r){
				InsPatWaitArea();   /// ����Ⱥ��� bianshuai 2019-02-21
			}
		});
	}else{
		InsPatSeat();
	}
}

/// �����а��Ų���
function InsPatSeat(){
	
	var SeatRowId = $('#SeatRowId').val();   //��λ
	var CardNum = $('#CardNum').val();		 //����
	var RegNum = $('#RegiNum').val(); 		 //�ǼǺ�
	var Adm="";
	if ((CardNum=="")&&(RegNum=="")){
        $.messager.alert("��ʾ","�����������ǼǺ�","warning")
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
	    $.messager.alert("��ʾ",'����û�о����¼!'); 
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
   		$.messager.alert("��ʾ","���ųɹ���");
   		clearCurSelSeat();  /// ��� curSelSeat ����
    }else if(rs==-1){
		$.messager.alert("��ʾ","��λ�Ѿ����ˣ�");   
	}else{
		$.messager.alert("��ʾ","����ʧ��,CODE:"+rs);   
	}
    $HUI.window("#wind").close();
    CleanModel(); 
    loadComboChangeSeat();    //�����������¼���
    loadGetPrvDoc() /// ����ҽ��
    InitBedPage();
    $("#obsPatTable").datagrid("reload");  /// ˢ�µȺ�������	   
}

function transfuse(){
	var $obj=$(".sickbed-selected").find(".Transfuse");
		if($(".sickbed-selected").length==0){
		 $.messager.alert("��ʾ","��ѡ��һ����λ!");
		 return false;
	}
	if(curSelSeat.admId===""){
		$.messager.alert("��ʾ","û�в���,���ܽ�����Һ����");
		return false;
	}else if(curSelSeat.admId!==$g("����")){
		var EpisodeID = curSelSeat.admId;
		var PatientID = curSelSeat.patId;
		setEprMenuForm(EpisodeID,PatientID); 
		window.location.href="dhcem.nur.main.hisui.csp";
	}
	return false;
}
	
function CarTypeSetting(value){
	//$.messager.alert("��ʾ","ִ��");
	m_SelectCardTypeDR = value.split("^")[0];
	var CardTypeDefArr = value.split("^");
    m_CardNoLength = CardTypeDefArr[17];

    if (CardTypeDefArr[16] == "Handle"){
    	$('#CardNum').attr("readOnly",false);
    }else{
		$('#CardNum').attr("readOnly",true);
	}
	$('#CardNum').val("");  /// �������
	$('#CardNum').focus();
}
//ʵ��ѡ��Ч��,������ѡ�в���ʵ�ֻ���λ
function toggleClass(){
	
	//alert($(this).attr('id'));
	//�����û���˵���λ��ʱ���ж�����ѡ�в���
	if(!$(this).find(".Transfuse").attr("patFlag")){
		var regNo=$(".sickClick").find(".Transfuse").attr("regno");
		$(".sickClick").removeClass("sickClick");
		if(regNo){
			planPat($(this).find(".ArrangeBtn").attr("seatid"));
			runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
		    {'patCardNo':'','regNo':regNo,'LgHospID':LgHospID}, 
			    function(data){
				    if(data==""){
					    $.messager.alert("��ʾ","����û�о�����Ϣ");
					    $('#RegiNum').val("") ;
					}
				    //$.messager.alert("��ʾ",data);
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
	
	var comboData = [
		{ "id": "PatNo", "text": $g("�ǼǺ�") }, 
		{ "id": "PatName", "text": $g("����") },
		{ "id": "PatSex", "text": $g("�Ա�") },
		{ "id": "PatSeat", "text": $g("��λ") }
	];
	$HUI.combobox('#filterCombo',{
		valueField:'id',
		textField:'text',
		data:comboData
	});
	
	$HUI.combobox('#filterCombo').setValue("PatNo");
	
	/// ��ȡĬ�Ͽ�����
	runClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{},function(jsonString){
		defaultCardTypeDr = jsonString;
		var CardTypeDefArr = defaultCardTypeDr.split("^");
        m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
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
	
	///����ҽ��
	$HUI.combobox("#PrvDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgCtLocID+"&ProvType=DOCTOR",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	    }	
	})
	//����ҽ��
	$HUI.combobox("#ChargDoc",{
		url:$URL+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLocCareProv&LocID="+LgCtLocID+"&ProvType=DOCTOR",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
			
	    }	
	})
	
	
	
	/// ��λ
	var option = {
		//panelHeight:"auto",
        onSelect:function(option){
	        $('#SeatRowId').val(option.value);
	    },
	    onLoadSuccess: function () { //���ݼ�������¼�
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
        // �����س�����   
       e=e||event;
       if(e.keyCode=="13"){
	     if($('#RegiNum').val()==""){
		    $.messager.alert("��ʾ","�ǼǺ�Ϊ��");  
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
	     var CardNo = $('#CardNum').val()
	     if(CardNo==""){
		    $.messager.alert("��ʾ","����Ϊ��");
		    CleanModel();
		 	return
		 }
		 
		var CardNoLen = CardNo.length;
		if((m_CardNoLength!="")&&(m_CardNoLength!=0)){
			if (m_CardNoLength < CardNoLen){
				$.messager.alert("��ʾ","�����������,������¼�룡");
				CleanModel();     
				return;
			}

			/// ���Ų���λ��ʱ��0
			for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
				CardNo="0"+CardNo;  
			}
		}
		 
		$('#CardNum').val(CardNo);
		runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
	    {'CardNo':CardNo,'RegNo':'','LgHospID':LgHospID},
		    function(data){
			   SettingModel(data);
			},"text",false);
       }
	});	
	
}    

//����Modelģ������    
function SettingModel(data){
	
	NoPatCleanModel();	 ///�����һ������
	
	if(data==""){
		$.messager.alert("��ʾ","δ�ҵ��ò��˻��˵�ǰ�޾�����Ϣ!");	
		return;
	}
	
	$('#PaAdm').val(data.split("^")[0]);
	$('#CardNum').val(data.split("^")[1]);
	$('#RegiNum').val(data.split("^")[2]);
	$('#UserName').val(data.split("^")[3]);
	$('#UserSecRank').val(data.split("^")[4]);
	$('#UserRank').val(data.split("^")[5]);
	$('#PatId').val(data.split("^")[6]);        /// ����ID
	$('#PatSex').val(data.split("^")[7]);       /// �Ա�
	$('#PatAge').val(data.split("^")[8]);       /// ����
	$('#PatLoc').val(data.split("^")[9]);       /// �������
	$('#PaAdmTime').val(data.split("^")[10]);   /// ����ʱ��
	$('#PatSeatNo').combobox("setValue",data.split("^")[12]);
	if(((data.split("^")[11])!="")&&(((data.split("^")[11])!=undefined))){              /// ������ID   yyt  2019-05-11
	    GetEmPatCardTypeDefine(data.split("^")[11]);  ///  ���ÿ�����
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
	$HUI.combobox("#PatSeatNo").enable();
	$HUI.combobox("#PatSeatNo").setValue("");
	$HUI.combobox("#UserTradeSeatBt").enable();
	$HUI.combobox("#UserTradeSeatBt").setValue("");
	$HUI.combobox("#PrvDoc").setValue("");
	
	//$HUI.combobox("#EmCardType").setValue("");
	
	$('#PatSex').val("");       /// �Ա�
	$('#PatAge').val("");       /// ����
	$('#PaAdmTime').val("");    /// ����ʱ��
	$('#PatLoc').val("");       /// �������
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
	
	$('#PatSex').val("");       /// �Ա�
	$('#PatAge').val("");       /// ����
	$('#PaAdmTime').val("");    /// ����ʱ��
	$('#PatLoc').val("");       /// �������
	$("#wriArea").linkbutton('enable');
}
    
///���������ֱ�����к󽫽������
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

//��λ�ķ���
//��һ��Ŀ����
//�ڶ�������λ��
//������������Ԫ��
function coverPosition(par1,par2,par3){
		if(par1.length<par2){
			for(i=1;i<par2;i++){
				par1=par3+""+par1;
			}
		}
		return par1;
}

/// ��ʼ���Ⱥ��� bianshuai 2019-02-19
function initWaitArea(){
	
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:'����',width:200,formatter:setCellLabel}
	]];
	
	///  ����datagrid
	var option = {
		showHeader:false,
		fitColumn:true,
		rownumbers:false,
		singleSelect:true,
		pagination:false,
		fit:true,
	    onLoadSuccess:function (data) { //���ݼ�������¼�
			initDragAndDropPat();  /// �����б��϶��¼�
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
	
   	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMPatientSeat&MethodName=JsLocPatWaitArea&LgParams="+ LgParams;
	new ListComponent('obsPatTable', columns, uniturl, option).Init();
}

/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	var IsHasSyOrd=rowData.IsHasSyOrd;
	var tooltipStr =rowData.PatName+","+rowData.PatSex+","+rowData.PatAge+","+rowData.BillType;
	//var htmlstr =  	    '<div style="position: relative;" class="celllabel onDraggable1" title="'+tooltipStr+'" ';
	var htmlstr =  	    '<div style="position: relative;" class="celllabel" title="'+tooltipStr+'" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.EpisodeID+'">'
	var htmlstr = htmlstr + '<div class="hasSyOrdMes" style="'+(IsHasSyOrd?"display:block":"")+'">'+$g('ҽ')+'</div>';
	var htmlstr = htmlstr +'<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">';
	var htmlstr = htmlstr + rowData.PatName + '</span>';
	var htmlstr = htmlstr + '<span class="l-btn-text" style="color:#666;margin-left:1px;padding:0">' + rowData.PatNo + '</span>';

	if(rowData.PatSex==$g("��")){
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_man">&nbsp;</span>';
	}else if(rowData.PatSex==$g("Ů")){
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_woman">&nbsp;</span>';
	}else{
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_noman">&nbsp;</span>';	
	}
	htmlstr = htmlstr +'</span></div>';
	return htmlstr;
}

/// ����Ⱥ��� bianshuai 2019-02-21
function InsPatWaitArea(){
	
	var EpisodeID = $("#PaAdm").val(); /// ����ID
    if ($('#SeatRowId').val() != ""){  /// ����λͼǨ���Ⱥ���������IDȡѡ������Ĳ��˾���ID
		curSelSeat.admId?EpisodeID = curSelSeat.admId:"";   
	} 
	
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����");
		return;
	}
	
	runClassMethod("web.DHCEMPatientSeat","InsPatWaitArea",{"EpisodeID": EpisodeID, "LgLocID":LgLocID, "LgUserID":LgUserID},function(jsonString){
		
		if (jsonString == -1){
			$.messager.alert("��ʾ:","�ò������ڵȺ������У��������ظ���ӣ�","warning");
			return;
		}
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","���ųɹ���","success",function(){
					
			});
			$HUI.window("#wind").close();
			CleanModel();   /// ������
			loadComboChangeSeat();
			loadGetPrvDoc() /// ����ҽ��
			InitBedPage();
			clearCurSelSeat();  /// ��� curSelSeat ����
			$("#obsPatTable").datagrid("reload");  /// ˢ�µȺ�������
		}
	},'text',false)	
}

/// �������� bianshuai 2019-02-21
function TempMeaSin(){
	
	var EpisodeID = curSelSeat.admId;  /// ����ID
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����","warning");
		return;
	}
	var viewName = "TemperatureMeasureSingle";
	var seatFlag = "true";		//2019-04-26 add by dl ����Ƿ�����λͼ���˵ı�־,�����������������б�����λͼ�����б������
	var LinkUrl = 'dhc.nurse.vue.mainentry.csp?EpisodeID='+ EpisodeID +'&ViewName='+ viewName+'&SeatFlag='+seatFlag;
	window.open(LinkUrl,$g('��������'),'top=25,left=25,width='+(window.screen.availWidth-50)+',height='+(window.screen.availHeight-50));
}

/// ��ʿִ�� bianshuai 2019-02-21
function NurExec(){
	if(PlanPatModel==1){
		$.messager.alert("��ʾ:","������λ�������治�����ٴε�����ʿִ�н��棡","warning");
		return;	
	}	
	var EpisodeID = curSelSeat.admId;  /// ����ID
	var PatientID = curSelSeat.patId;
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����","warning");
		return;
	}
	
	var LinkUrl = 'dhcem.nur.main.hisui.csp';
	setEprMenuForm(EpisodeID,PatientID);
	websys_showModal({
		url: LinkUrl,
		width: (window.screen.availWidth-50)+'px',
		height: (window.screen.availHeight-50)+'px',
		iconCls:"icon-w-paper",
		title: $g('��ʿִ��'),
		closed: true,
		onClose:function(){}
	});
}

/// ���� bianshuai 2019-02-21
function ArrPatSeat(){
	CleanModel();  		 /// ����������
	$HUI.window("#wind").open();
	var EmCardType =$("#EmCardType").combobox("getValue");
	$HUI.combobox("#EmCardType").setValue(defaultCardTypeDr);  //Ĭ�Ͽ�����
	if(defaultCardTypeDr!=""){
		if(defaultCardTypeDr.split("^")[16] == "Handle"){
			$('#CardNum').attr("readOnly",false);
		}else{
			$('#CardNum').attr("readOnly",true);
		}
	}
	
	//if(EmCardType==""){   
	//	$HUI.combobox("#EmCardType").setValue(defaultCardTypeDr);  //Ĭ�Ͽ�����	
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
	
	loadGetPrvDoc()       //����ҽ��
	
	///��ǰ��λ��Ϣ����
	if((curSelSeat.seat!="")&&(curSelSeat.seat!=undefined)){
		$HUI.combobox("#PatSeatNo").setText(curSelSeat.seat);
	}else{
		$("#wriArea").linkbutton('disable');      /// �Ⱥ�ť������  bt_waitarea	
	}
	$HUI.combobox("#PatSeatNo").disable();
	
	///��Ҫ���ŵĴ�λ��Ϣ����
	$HUI.combobox("#UserTradeSeatBt").setText(TmpTrsSeat);
	TmpTrsSeat = "";  /// �����ʱ��λ
	
	///�հ״��������:��յ�ǰ��λ�����ð��Ŵ�λ
	if(curSelSeat.patId==""){
		$HUI.combobox("#PatSeatNo").setText("");
		$HUI.combobox("#UserTradeSeatBt").setText(curSelSeat.seat);
	}
	
	var PatBaseObj = GetPatBaseInfo(curSelSeat.admId);
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// ����������� 2019-03-04 bianshuai

}

/// �뿪��λ
function ClrPatSeat(){
	
	var EpisodeID = curSelSeat.admId;  /// ����ID
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����","warning");
		return;
	}
	
	$.messager.confirm('ȷ�϶Ի���','ȷ���Ƴ���ǰ��λ�Ĳ�����', function(r){
		if (r){
			removePatSeat();   /// �뿪��λ
		}
	});
}
		
/// �뿪��λ
function removePatSeat(){
	
	var EpisodeID = curSelSeat.admId;  /// ����ID
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����","warning");
		return;
	}
	
	runClassMethod("web.DHCEMPatientSeat","ClearPatSeat",{"adm": EpisodeID, 'loc':LgCtLocID, 'user':LgUserID},function(jsonString){
		
		if (jsonString < 0){
			$.messager.alert("��ʾ:","����ʧ�ܣ�ʧ��ԭ��:"+jsonString,"warning");
		}else{
			$.messager.alert("��ʾ:","�����ɹ���","success");
			clearCurSelSeat();  /// ��� curSelSeat ����
			$("#obsPatTable").datagrid("reload");  /// ˢ�µȺ�������
		}
	},'',false)	
	
	loadComboChangeSeat();
	//loadGetPrvDoc()
	InitBedPage();
	
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

/// ���˾�����Ϣ
function GetPatBaseInfo(EpisodeID){
	
	var jsonObject = "";
	runClassMethod("web.DHCEMPatientSeat","GetPatEssInfo",{"EpisodeID":EpisodeID},function(jsonString){
		
		if (jsonObject != null){
			jsonObject = jsonString;
		}
	},'json',false)
	return jsonObject;
}

/// ������λ����
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

/// �����������
function InitPatPopPanel(jsonObject){
	if (jsonObject != "") {
		$('#PatSex').val(jsonObject.PatSex);       /// �Ա�
		$('#PatAge').val(jsonObject.PatAge);       /// ����
		$('#PaAdmTime').val(jsonObject.PaAdmTime); /// ����ʱ��
		$('#PatLoc').val(jsonObject.PatLoc);       /// �������
		$('#CardNum').val(jsonObject.PatCardNo);   /// ����
		$('#PaAdm').val(jsonObject.EpisodeID);     /// ����ID 
		if (jsonObject.CardTypeID){
			GetEmPatCardTypeDefine(jsonObject.CardTypeID);  ///  ���ÿ�����
		}
	}
}

/// ��ȡ���˶�Ӧ����������
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
			m_CardNoLength = CardTypeDefArr[17];   /// ���ų���
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

/// ָ������ҽ�� yangyongtao 2019-04-19
function  DocSure(){
	var EpisodeID = curSelSeat.admId;  /// ����ID
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����","warning");
		return;
	}
	var ChargDoc = $HUI.combobox("#ChargDoc").getValue();
	var ChargDocDesc = $HUI.combobox("#ChargDoc").getText();
	runClassMethod("web.DHCEMPatientSeat","UpdPrvDoc",{"Loc":LgLocID,'EpisodeID':EpisodeID,'ChargDoc':ChargDoc},
	  function(data){
         if(data=="0"){ 
             $.messager.alert("��ʾ:","�޸ĳɹ���","success");
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

/// ����ҽ��
function loadGetPrvDoc(){
	var EpisodeID = curSelSeat.admId;  /// ����ID
	//var SeatRowId = $('#SeatRowId').val();   //��λ
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

//datagrid ���ѡ��,�ٴ�ȡ��ѡ��
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
//Seat ���ѡ��,�ٴ�ȡ��ѡ��
function checkOrUnCheckSeat($this)
{
	var $seatCont = $this.children(".seatcontent")
	$seatCont.toggleClass("active");   //ѡ��Ч��ʵ��

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
	//���ذ�����λ��win
	$HUI.window("#wind").open(); 
	var PatBaseObj = GetPatBaseInfo(SelData[0].EpisodeID);
	if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// ����������� 2019-03-04 bianshuai	
	$('#UserName').val(SelData[0].PatName);
	$('#RegiNum').val(SelData[0].PatNo);
	$('#PatId').val(SelData[0].PatNo);	
    $("#wriArea").linkbutton('disable');      /// �Ⱥ�ť������  bt_waitarea
    //$HUI.combobox("#PatSeatNo").disable();
    $HUI.combobox("#PatSeatNo").disable(); 
    loadGetPrvDoc()	
}



//�����б�
function SeatClickInfo(){
	
	$('.sickbed').on('click',function(){

	     if(($(this).find(".ArrangeBtn").attr("patId")===undefined)){
		   $HUI.window("#wind").open();  
		 }
		 var selItems = $("#obsPatTable").datagrid('getSelections');  // yyt 2019-04-27  ѡ���б�����λ
		 if (!selItems.length){
			//$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
			//return;
		 }else{
			$(this).removeClass("sickbed-selected")
			/// ����������
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
	        if (PatBaseObj) InitPatPopPanel(PatBaseObj);  /// ����������� 2019-03-04 bianshuai
	        $("#bt_waitarea").linkbutton('disable');      /// �Ⱥ�ť������
	        //$HUI.combobox("#PatSeatNo").disable();
	        $HUI.combobox("#UserTradeSeatBt").disable(); 
	        loadGetPrvDoc()
		 }
	 })
	
}

function remvoeWaitPat(ID){
	$.messager.confirm('ȷ�϶Ի���','��ǰ���ˣ��Ƿ��뿪��', function(r){
		if (r){
		  	MyRunClassMethod("web.DHCEMPatientSeat","RemoveWaitArea",{'ID':ID});
			clearCurSelSeat();  /// ��� curSelSeat ����
			$("#obsPatTable").datagrid("reload");  /// ˢ�µȺ�������
		}
	});
	return;
}



function newPrintXmlMode(){
	var EpisodeID = curSelSeat.admId;  /// ����ID
	if (EpisodeID == ""){
		$.messager.alert("��ʾ:","����ѡ���ˣ��ٽ��д˲�����","warning");
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
	DHC_CreateByXML(LODOP,myPara,"",[],"PRINT-CST-NT");  //MyPara Ϊxml��ӡҪ��ĸ�ʽ
	LODOP.PRINT();
	
	return;
}	


function changeSeatView(obj){
	if(obj.value){
		$(".sickbed,.sickbedBorder").css({"height":"45px","transition":"height 0.2s"});
		$(".sickbedContent").css({"height":"41px","transition":"height 0.2s"});
		seatObj.seatHeight="45px";
	}else{
		$(".sickbed,.sickbedBorder").css({"height":"220px","transition":"height 0.2s"});
		$(".sickbedContent").css({"height":"216px","transition":"height 0.2s"});
		seatObj.seatHeight="220px";
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
	
	///�ٶ�̫����ǰ̨
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



///��չ���ܣ����jq�ṩɾ��ĳ��cssԪ�صĹ���
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
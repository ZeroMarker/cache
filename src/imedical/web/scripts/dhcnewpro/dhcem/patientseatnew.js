var dragFlag=true;   /// �϶����
var TmpTrsSeat = ""; /// ת����λ
var LgUserID = session['LOGON.USERID'];  /// �û�ID
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var defaultCardTypeDr //Ĭ�Ͽ�����
$(function(){
	
	initParam();
	//��ʼ��combobox
	initCombo(); 
	
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

function initPageDomMethod(){
	$("#patRegNo").bind('keypress',PatRegNo_KeyPress);
}

function initParam (){
	seatObj={
		seatWidth:210,
		seatHeight:45
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
			$.messager.alert("��ʾ","û����λ��");
			return;	
		}

		initpatient(row,cow);  //��ʼ����λ
		initPatientText(row,cow,str,noPerple);  //��λ����ʾ������
	});
  
}

//��ʼ����λ
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
			"<div class='ArrangeBtn hideItm' id='ArrangeBtn"+i+"'></div>"+       //�������ֻΪ�˴洢����
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
		$("#obsPatTable").datagrid("load",{"LgLocID":LgLocID,"TmpPatNo":TmpPatNo}); 
		InitBedPage();
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
	var strArr = str.split("$$");
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
			$("#sickbed"+num).addClass("onDroppable");   //���÷����¼�
			
		}
		
	   if(hasPat=="YY"){ ///��λͼ������ռ��  yyt 2019-05-01
			var patName  = strArr[i].split("^")[8];
			var regNo  = strArr[i].split("^")[9];
			var PaAdmDate  = strArr[i].split("^")[10];
			var PaAdmTime  = strArr[i].split("^")[11];
			var PrvDoc  = strArr[i].split("^")[12];
			
			var sexHtmlStr=""
			sexHtmlStr = 			 '<div style="margin-top:5px;margin-left:8px;">';
			sexHtmlStr = sexHtmlStr +'<span style="color:red">'+"���۲���ռ��";
			sexHtmlStr = sexHtmlStr +'	</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"��&nbsp;&nbsp;&nbsp;����"+ patName +'</span>';
			sexHtmlStr = sexHtmlStr + '</div style="margin-top:5px">';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"�ǼǺţ�"+ regNo +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"��&nbsp;&nbsp;&nbsp;�ڣ�"+ PaAdmDate +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"ʱ&nbsp;&nbsp;&nbsp;�䣺"+ PaAdmTime +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			sexHtmlStr = sexHtmlStr + '		<span>'+"ҽ&nbsp;&nbsp;&nbsp;����"+ PrvDoc +'</span>';
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
			var PaAdmTime = strArr[i].split("^")[19];   /// �¼� 2019-03-04 bianshuai
			var MainDoc = strArr[i].split("^")[20];     /// �¼� 2019-05-30 bianshuai
			var InSeatDateLimit = strArr[i].split("^")[21];
			var PatSexDesc = "";     //�Ա�����

			$(".sickbed #Transfuse"+num).attr("admId",admId);
			$(".sickbed #ArrangeBtn"+num).attr("regNo",regNo);
			$(".sickbed #ArrangeBtn"+num).attr("patName",patName);
			$(".sickbed #ArrangeBtn"+num).attr("cardNo",cardNo);
			$(".sickbed #Transfuse"+num).attr("patFlag","����");
			$(".sickbed #Transfuse"+num).attr("regNo",regNo);
			$(".sickbed #ArrangeBtn"+num).attr("secretLev",secretLev);
			$(".sickbed #ArrangeBtn"+num).attr("patLev",patLev);
			$(".sickbed #ArrangeBtn"+num).attr("patId",patId);
			$(".sickbed #ArrangeBtn"+num).attr("admId",admId);
			
			var sexHtmlStr = "",sexIcon=""
			AllPersonNum++;
			if(patSex.trim()=="1"){  //��
				PatSexDesc="��";
				ManSeatNum++;
				sexIcon="pat_mannew";
			}else if(patSex.trim()=="2"){   //Ů
				PatSexDesc="Ů";
				WomanSeatNum++;
				sexIcon="pat_womannew";
			}else {							//δ֪
				PatSexDesc="δ֪";
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
			sexHtmlStr = sexHtmlStr + '		<span>��ϣ�'+ MRDiagnos +'</span>';
			sexHtmlStr = sexHtmlStr + '</div>';
			sexHtmlStr = sexHtmlStr + '<div class="pat-text">';
			//sexHtmlStr = sexHtmlStr + '		<span>'+ PaAdmTime +'</span>';
			sexHtmlStr = sexHtmlStr + '		<span>ҽ����'+ MainDoc+ '</span>';
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
	                '<div>������'+patName+'</div>' +
	                '<div>���䣺'+patAge+'</div>' +
	                '<div>�Ա�'+PatSexDesc+'</div>' +
	                '<div>�ѱ�'+patFei+'</div>' +
	                '<div>�ǼǺţ�'+regNo+'</div>' +
	                '<div>��ϣ�'+MRDiagnos+'</div>' +
	                '<div>������ң�'+PatInDep+'</div>' +
	                '<div>����ʱ�䣺'+PaAdmTime+'</div>' +
	                '<div>����ҽ����'+MainDoc+'</div>' +
	                '</div>',
			    onShow: function(){
					
			    }	
			})
		}
	}
	
	
	
	$('#top_btn_no').html(noPerple);
	$('#top_btn_man').html("����:"+ManSeatNum);
	$('#top_btn_woman').html("Ů��:"+WomanSeatNum);
	$('#top_btn_unman').html("δ֪:"+UnknownSeatNum);
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
	
	   var hasPat=$(this).find(".ArrangeBtn").attr("hasPat") 	  
	   if(hasPat=="YY"){
		   $.messager.alert("��ʾ","����λ��ռ�ã����ܷ��䣡","warning");
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
		
		//���õ�ǰ
		if($(this).hasClass("sickbed-selected")){
			var $obj=$(this).find(".ArrangeBtn");
			setCurSelSeat($obj);		
		}
		setEprMenuForm(curSelSeat.admId,curSelSeat.patId);
		///�����б���  yyt
		var SelData = $("#obsPatTable").datagrid("getSelections");  //�������
		if(($(this).find(".ArrangeBtn").attr("patId")===undefined)&&(SelData.length)){   //ѡ�еȺ���������ѡ�д�λ�ϲ���
			$HUI.combobox("#UserTradeSeatBt").setValue($(this).find(".ArrangeBtn").attr("seat"));
			$('#SeatRowId').val($(this).find(".ArrangeBtn").attr("seatId"));
			$('#CardNum').val($(this).find(".ArrangeBtn").attr("CardNo"));	
			loadPlanPatWin(SelData)
			return;
		}
		checkOrUnCheck(obsPatTable.checkIndex)  //���ѡ����

		return false;
	}).bind("contextmenu", function(e){
			/// �����Ҽ��˵� 2019-02-21 bianshuai
			e.preventDefault(); //��ֹ����������Ҽ��¼�
			
			if (!$(this).hasClass("sickbed-selected")){
				$.messager.alert("��ʾ","����ѡ���ˣ�","warning");
				return;
			}
//			if(curSelSeat.admId == ""){   //������λ����ѡ��
//				return ;
//			}
			$HUI.menu('#menu').show({ 
	           //��ʾ�Ҽ��˵�  
	           left: e.pageX,//�����������ʾ�˵�  
	           top: e.pageY  
			});
	});
	event.stopPropagation();	
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
        str = "������";  
	} else if (week == 1) {  
        str = "����һ";  
	} else if (week == 2) {  
        str = "���ڶ�";  
	} else if (week == 3) {  
        str = "������";  
	} else if (week == 4) {  
        str = "������";  
	} else if (week == 5) {  
        str = "������";  
	} else if (week == 6) {  
        str = "������";  
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
	    {'CardNo':'','RegNo':$('#RegiNum').val()},
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
	   'RegNo':RegNum
	}
	
    PatAdmInfo = MyRunClassMethod("web.DHCEMPatientSeat","GetCurrAdm",Datas); 
    if(PatAdmInfo==""){
	    $.messager.alert("��ʾ",'����û�о����¼!'); 
		return false;
	}
	var PatientID = PatAdmInfo.split("^")[6];
	var EpisodeID = PatAdmInfo.split("^")[0];
	
	var Parr="^"+LgCtLocID+"^"+PatientID+"^"+EpisodeID+"^"+SeatRowId+"^"+LgUserID+"^"+"Y"+"^"+PrvDoc;
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
	}else if(curSelSeat.admId!=="����"){
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
		    {'patCardNo':'','regNo':regNo},
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
		    $.messager.alert("��ʾ","����Ϊ��");
		    CleanModel();
		 	return
		 }
		 
		var CardNoLen = CardNo.length;

		if (m_CardNoLength < CardNoLen){
			$.messager.alert("��ʾ","�����������,������¼�룡");
			CleanModel();     
			return;
		}

		/// ���Ų���λ��ʱ��0
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

//����Modelģ������    
function SettingModel(data){
	
	NoPatCleanModel();	 ///�����һ������
	
	if(data=="-1"){
		$.messager.alert("��ʾ","δ�ҵ��ò���!");	
		return;
	}
	
	if(data=="-2"){
		$.messager.alert("��ʾ","���˵�ǰ�޾�����Ϣ!");	
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
	
   	/// ��������
	var uniturl = $URL+"?ClassName=web.DHCEMPatientSeat&MethodName=JsLocPatWaitArea&LgLocID="+ LgLocID;
	new ListComponent('obsPatTable', columns, uniturl, option).Init();
}

/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	
	var tooltipStr =rowData.PatName+","+rowData.PatSex+","+rowData.PatAge+","+rowData.BillType;
	var htmlstr =  	    '<div class="celllabel onDraggable1" title="'+tooltipStr+'" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.EpisodeID+'">'
	var htmlstr = htmlstr +'<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">';
	var htmlstr = htmlstr + rowData.PatName + '</span>';
	var htmlstr = htmlstr + '<span class="l-btn-text" style="color:#ccc;margin-left:1px;padding:0">' + rowData.PatNo + '</span>';

	if(rowData.PatSex=="��"){
		var htmlstr = htmlstr+'<span class="l-btn-icon pat_man">&nbsp;</span>';
	}else if(rowData.PatSex=="Ů"){
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
		if(curSelSeat.admId!="") EpisodeID = curSelSeat.admId;   
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
	window.open(LinkUrl,'��������','top=25,left=25,width='+(window.screen.availWidth-50)+',height='+(window.screen.availHeight-50));
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
	window.open(LinkUrl,'��ʿִ��','top=25,left=25,width='+(window.screen.availWidth-50)+',height='+(window.screen.availHeight-50));
}

/// ���� bianshuai 2019-02-21
function ArrPatSeat(){
	CleanModel();  		 /// ����������
	$HUI.window("#wind").open();
	var EmCardType =$("#EmCardType").combobox("getValue");
	$HUI.combobox("#EmCardType").setValue(defaultCardTypeDr);  //Ĭ�Ͽ�����	
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
		frm.EpisodeID.value = ""; 			//DHCDocMainView.EpisodeID;
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
		if (jsonObject.CardTypeID != ""){
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
	runClassMethod("web.DHCEMPatientSeat","UpdPrvDoc",{"Loc":LgLocID,'EpisodeID':EpisodeID,'ChargDoc':ChargDoc},
	  function(data){
         if(data=="0"){ 
             $.messager.alert("��ʾ:","�޸ĳɹ���","success");
             $HUI.window("#DocWin").close();
             InitBedPage();
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
		 var selItems = $("#obsPatTable").datagrid('getSelections')  // yyt 2019-04-27  ѡ���б�����λ
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


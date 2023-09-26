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
		checkIndex:"",  //ָ�룺ָ��datagrid��ǰѡ�е���	
	};
	
	selObsPat={        //ָ��ѡ�еĵȺ�������,ռʱ����
		adm:""
	};
	
	selSeatPat={  	  //ָ��ѡ�еĴ�λ����
		seatID:"",	  //ͨ������ֶο����жϴ�λ�Ƿ�ѡ��
		adm:"",		  //ͨ�������ֶο����ж�ѡ�д�λ�Ƿ�����
		planSeatID:"" //���ŵ�ʱ��Ҫ���ŵĴ�λID
	};
	
	selMovePat={      //ͨ���ƶ���������ָ��
		seatID:"",	  //ͨ������ֶο����жϴ�λ�Ƿ�ѡ��
		adm:"",		  //ͨ�������ֶο����ж�ѡ�д�λ�Ƿ�����
		planSeatID:"" //���ŵ�ʱ��Ҫ���ŵĴ�λID
	}
	
	globleParam={
		planMode:"",   //P�����ŵ���λ   C:���ŵ��Ⱥ���  U:����  UP:ת��
	};
	
	curWrad={
		wardId:"",	
		wardDesc:""
	};
	
	
	seatNum={
		allSeatNum:0,  //����
		hasPatSeatNum:0, //�ڴ�����
		makeSeatNum:0,//��������
	}
	
	obsRoom = {
		width:0,
		height:0	
	}
	
	seatPointer=0 ; //������ش�λ�ڼ��Ŵ�����ʱ����
	
	DateFormat=4;
	
	seatTimeCount=0;  //��ȡ���˺�ͼ��ֿ��������ǻ�ȡͼ�겿��
	
	lastRowY="";  	  //���һ�Ŵ�λ
	
	var Params=0;
	runClassMethod("web.DHCEMObsRoomSeat","GetGlobleParams",{"Params":Params},function(ret){
		var retArr=ret.split("^");
		curDate=retArr[0];
		curTime=retArr[1];
	},'text',false)

}

//��ʼ�����н���Ԫ�صķ���
function initMethod(){
	addObsAreaMethod();	  //�Ⱥ����������
	$(".planPat-Btn:contains('����')").on('click',planOrClearPat);   //���Ű�ť
	$(".planPat-Btn:contains('ȡ��')").on('click',closeWindow);   //���Ű�ť
	$(".dis-Btn:contains('����')").on('click',disHospPat);
	$(".cancel-Btn:contains('����')").on('click',cancelAccPat);
	
	$(".opbtn-makeSeatBtn").on('click',makeSeat);
	$(".opbtn-upSeatBtn").on('click',upSeatWin);
	$(".opbtn-cancelAcc").on('click',cancelAcc);
	$("#disHosp").on('click',disHospWin);/*hxy 2018-07-02*/
	$("#upObsBtn").on('click',planPatToObs);/*hxy 2018-07-02*/
	$("#prtStraps").on('click',prtStraps);
	$("#transBed").on('click',transtBed);
}

//����
function upSeatWin(){
	var patAdm="";
	var selPatData= $("#obsPatTable").datagrid("getSelections");  //�������
	if(selPatData.length){
		$.messager.alert("��ʾ","��������ֻ�ܲ������ڴ����ߣ�");
		return;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("��ʾ","��ѡ��һ���ڴ����ߣ�");
		return;
	}
	globleParam.planModel = "UP";  
	loadPlanPatWin(patAdm);
	return; 	
}

//��������
function cancelAcc(){
	
	var canAccData = $("#disHospTable").datagrid("getSelections"); 
	var Adm = canAccData[0].AdmID;
	if(!canAccData.length){
		$.messager.alert("��ʾ","��ѡ��һ����Ժ���ߣ�");
		return;
	}
	
	runClassMethod("web.DHCEMPatChange","GetFinalStat",
	{
		"EpisodeID":Adm
	},function(data){
		if(data!="0"){
			$.messager.alert("��ʾ",data);
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
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //�������

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("��ʾ","ѡ��Ҫ��Ժ�Ĳ��ˣ�");	
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
			$.messager.alert("��ʾ:","���ȴ������עҽ�������עҽ����Ϣ:"+abnOrdInfo,"info",function(){
				websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+patAdm+"&defaultTypeCode=D","","width='"+window.screen.availHeight-100+"' height='"+window.screen.availWidth-100+"'");
			});
			return;
		}
	}
	
	
	if((isControl==0)&&(abnOrdInfo!="")){			///���עҽ��δ���ùܿأ�ֻ��ʾ��
		$.messager.confirm('��ʾ', '�����账��ҽ�����Ƿ�ȷ����Ժ����?', function(result){  
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
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //�������

	if(selPatData.length){
		patAdm = selPatData[0].AdmID;
	}else{
		patAdm = selSeatPat.adm;
	}
	
	if(patAdm===""){
		$.messager.alert("��ʾ","δѡ�����Ҳ��ˣ�");	
		return;
	}
	
	var lnk = "dhcem.rotatingbed.csp?EpisodeID="+patAdm;
	websys_showModal({
		url: lnk,
		iconCls:"icon-w-paper",
		title: '���ۻ��ߴ�λת��',
		closed: true,
		onClose:function(){}
	});
	
	return ;	
}

//�����������
function cancelAccPat(){
	var canAccData = $("#disHospTable").datagrid("getSelections");
	var Adm = canAccData[0].AdmID;
	var reverseDesc = $HUI.combobox("#cancelWin-cancelCause").getValue();
	
	if(reverseDesc===""){
		$.messager.alert("��ʾ","����ԭ����Ϊ�գ�");
		return;	
	}
	
	runClassMethod("web.DHCEMPatChange","DelDisorReversePay",
		{
			"Adm":Adm,
			"userId":UserID,
			"reverseDesc":reverseDesc
		},function(data){
			if(data==0){
				$.messager.alert("��ʾ","�����ɹ���");	
				reloadObsAreaAndSeat(curWrad.wardId); 
			}else{
				$.messager.alert("��ʾ",data);	
			}
		},'text',false)	
}

//��Ժ����
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
			$.messager.alert("��ʾ","�ɹ���");
			reloadObsAreaAndSeat(curWrad.wardId); 
		}else{
			$.messager.alert("��ʾ",data);
		}
	},'text',false)
}

//����
function makeSeat(){
	websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=PACWardRoom.ListUnocc&WardID='+curWrad.wardId+'&AvailableBeds=true&SortOrder=1',false,'top=40,left=40,width=640,height=480');
}

//���Ͻǰ��Ű�ť
function planPatToObs(){
	if(selSeatPat.adm==="") {
		$.messager.alert("��ʾ","δѡ�д�λͼ���ˣ�");
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

//���Ų��˴���
function planOrClearPat(){
	// Param:UserID^BedID^DocDr^PatAdm^Date^Time
	if(UPDSEATNEEDPAS==1){
		var userCode = $("#planPatTable-UserId").val();
		var userPas = $("#planPatTable-UserPas").val();
		if(userPas==""){
			$.messager.alert("��ʾ","���벻��Ϊ�գ�");
			return;
		}
		var validPas="";
		runClassMethod("web.DHCEMSkinTest","ConfirmPassWord", {'userCode':userCode,'passWord':userPas},function(data){
			validPas=data;
		},'text',false)
		if (validPas.split("^")[0] != 0) {
			$.messager.alert("��ʾ",validPas);
			return;
		}
		
	}
	
	
	var planBedID="",patAdm="";
	if((globleParam.planModel==="UP")||(globleParam.planModel==="P")||(globleParam.planModel==="U")){ 
		var bedSelRow = $('#planWinPat-SeatNo').combogrid('grid').datagrid('getSelected');
		if(!bedSelRow){
			$.messager.alert("��ʾ","��ѡ��һ������");
			return ;
		}
		
		if((globleParam.planModel==="UP")||(globleParam.planModel==="U")){
			patAdm = selSeatPat.adm;
			planBedID = bedSelRow.BedID;
		}
		if(globleParam.planModel==="P"){
			var  selPatData= $("#obsPatTable").datagrid("getSelections");  //�������
			patAdm = selPatData[0].AdmID;
			planBedID = bedSelRow.BedID;
		}
	}

	if(globleParam.planModel==="C"){
		planBedID="";
		patAdm= selSeatPat.adm;
	}
	
	if(globleParam.planModel==="M"){    //�϶�����λ
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
			$.messager.alert("��ʾ","���ųɹ���");
			reloadObsAreaAndSeat();
			clearPlanWin();			  //������
		}else{
			$.messager.alert("��ʾ",data);		
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

///��ʼ��table:ֻ��һ��
function initTable(){
	
	if(IsInitTable) return;	
	IsInitTable=true;
	
	var CurWardDr = curWrad.wardId;
	///  ����columns
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
		loadMsg: '���ڼ�����Ϣ...',
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
	    	/// �����Ҽ��˵� 2019-02-21 bianshuai
			e.preventDefault(); //��ֹ����������Ҽ��¼�
				
			if(!validIsCheckPat()){
				$.messager.alert("��ʾ","δѡ���κ������Ҳ��ˣ�");
				return;
			}
			
			$HUI.menu('#menu').show({ 
	           //��ʾ�Ҽ��˵�  
	           left: e.pageX,//�����������ʾ�˵�  
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
		loadMsg: '���ڼ�����Ϣ...',
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
	var  selPatData= $("#obsPatTable").datagrid("getSelections");  //�������

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
			console.log("��ʼ");
		}
	});
	*/
	
}

//datagrid ���ѡ��,�ٴ�ȡ��ѡ��
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

//Seat ���ѡ��,�ٴ�ȡ��ѡ��
function checkOrUnCheckSeat($this)
{
	var $seatCont = $this.children(".seatcontent")
	$seatCont.toggleClass("active");   //ѡ��Ч��ʵ��
	if($seatCont.hasClass("active")){  //ָ�븳
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

///��ʼ����λ
function initSeat(){
	var CurWardID = curWrad.wardId ;
	$(".obsseat").css({"max-height":$(".center").height(),"height":$(".center").height(),"overflow":"auto"});
	//��ȡ��λ��Ϣ
	loadSeat(CurWardID);
}

function initPatIncon(CurWardID){
	PatInconData="";
	runClassMethod("web.DHCEMObsRoomSeat","GetWardIconInfo",{"WardID":CurWardID},function(data){
		PatInconData = data;
		showSeatIcon();
	})
}


///**���ɴ�λ
function loadSeat(CurWardID){
	clearAllSeat();   			//�����λ
	addAllSeat(CurWardID);  	//���ش�λ
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
	$(".online").html("��������:"+seatNum.allSeatNum);
	$(".unline").html("��������:"+seatNum.hasPatSeatNum);
	$(".makeseat").html("��������:"+seatNum.makeSeatNum);	
}

function setCellLabelNoDrag(value, rowData, rowIndex){
	return setCellLabel(value, rowData, rowIndex,"");
}

function setCellLabelNormal(value, rowData, rowIndex){
	return setCellLabel(value, rowData, rowIndex,1);
}

/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex, mode){
	var dragClass="";
	mode==1?dragClass="onDraggable":"";
	
	var tooltipStr =rowData.PatName+","+rowData.PatSex+","+rowData.PatAge+","+rowData.PatType;
	var htmlstr =  	    '<div class="celllabel '+dragClass+'" title="'+tooltipStr+'" class="hisui-tooltip" ';
	var htmlstr = htmlstr +'data-adm="'+rowData.AdmID+'">'
	var htmlstr = htmlstr+'<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">';
	var htmlstr = htmlstr+rowData.PatName;
	//var htmlstr = htmlstr+'</span><span class="l-btn-icon icon-readothercard">&nbsp;</span></span>';
	if(rowData.PatSex=="��"){//hxy
		var htmlstr = htmlstr+'</span><span class="l-btn-icon pat_man">&nbsp;</span></span>';
	}else if(rowData.PatSex=="Ů"){
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
		
		//��ʼ������
		for(i=0;i<data.SeatData.length;i++){
			addSeat(data.SeatData[i]);	
		}
		
		addObsRoom(data.ObsRoomData); //��ʼ���Ⱥ���
		InitLocNum(data.Pid);	
		showCurWardPatNum();
		addSeatMethod();      		//��λ�������
		initPatIncon(CurWardID); 	//��ʼ��ͼ������	
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
		htmlstr="<span style='font-weight:bold;font-size:15px!important;'>�ڴ����:</span>";
		var ToalNum=0; //
		for (var i=0; i<jsonObjArr.length; i++){
			if(htmlstr==""){
				htmlstr="<span style='font-weight:bold;font-size:15px!important;'>"+jsonObjArr[i].LocDesc+"��"+"</span>"+"<span style='font-size:12px!important;font-weight:bold;'>"+jsonObjArr[i].Num+"��"+"</span>";	
			}else{
				if(jsonObjArr[i].LocDesc.indexOf("72Сʱ")>-1){
					htmlstr=htmlstr+"<br>"+"<span style='font-weight:bold;font-size:15px!important;'>"+jsonObjArr[i].LocDesc+"��"+"</span>"+"<span style='font-size:13px!important;font-weight:bold;'>"+jsonObjArr[i].Num+"��"+"</span>";				
				}else{
					htmlstr=htmlstr+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<span style='font-weight:bold;font-size:15px!important;'>"+jsonObjArr[i].LocDesc+"��"+"</span>"+"<span style='font-size:13px!important;font-weight:bold;'>"+jsonObjArr[i].Num+"��"+"</span>";		
				}
			}
			//����
			if(jsonObjArr[i].LocDesc.indexOf("72Сʱ")<0){
				if(ToalNum==0){
				   ToalNum=parseInt(jsonObjArr[i].Num);
				}else{
				   ToalNum=	parseInt(ToalNum)+parseInt(jsonObjArr[i].Num);
				}
			}
		}
		
		$("#LocAdmNum").html(htmlstr+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"<span style='font-weight:bold;font-size:18px!important;'>�ڴ���������</span>"+"<span style='font-weight:bold;font-size:15px!important;'>"+ToalNum+"��"+"</span>");
	},'json',false)
		
}

function addObsRoom(data){
	//������dom����
	
	//�����ʼ����Щ����
	if(data===""){
		$("#obsRoom").css({width:0,height:0});     //û�����õȺ���
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


//����λ�͵Ⱥ����󶨷���
function addSeatMethod(){
	$(".seat").each(function(){
		$(this).on('click',function(){
			if(($(this).attr("data-make")==="Y")){  //�������ܲ���
				return ;   	
			}
			///�ж��ɵȺ������ŵ�����
			var SelData = $("#obsPatTable").datagrid("getSelections");  //�������
			var DisSelData = $("#disHospTable").datagrid("getSelections");  //�������
			if(($(this).attr("data-adm")!=="")&&(SelData.length||DisSelData.length)){   //ѡ�еȺ���������ѡ�д�λ�ϲ���
				checkOrUnCheckAll();
				checkOrUnCheckSeat($(this));
				return;
			}
			if(SelData.length){
				var Adm = SelData[0].AdmID;
				if(Adm===""){
					$.messager.alert("��ʾ","���˵�ǰ����Ϊ�գ�");
					return;
				}
				globleParam.planModel = "P"; 
				selSeatPat.planSeatID = $(this).attr("data-id");
				loadPlanPatWin(Adm);
				return;                    //���return���ڵ���window��ֹ��������seatѡ��Ч��
			}
			
			///�ж���һ�������ŵ�����һ������
			if((selSeatPat.adm!="")&&($(this).attr("data-adm")==="")){
				globleParam.planModel = "U";  
				selSeatPat.planSeatID = $(this).attr("data-id");  
				loadPlanPatWin(selSeatPat.adm);
				return;                    //���return���ڵ���window��ֹ��������seatѡ��Ч��
			}
			
			if(($(this).attr("data-adm")==="")){   //���˴�����ѡ��
				return ;
			}	
			//��������ѡ��css�Լ��Դ�λָ�븳ֵ
			checkOrUnCheckSeat($(this));
		}).bind("contextmenu", function(e){
			return true;
			/// �����Ҽ��˵� 2019-02-21 bianshuai
			e.preventDefault(); //��ֹ����������Ҽ��¼�
			if(!validIsCheckPat()){
				$.messager.alert("��ʾ","δѡ���κ������Ҳ��ˣ�");
				return;
			}
			$HUI.menu('#menu').show({ 
	           //��ʾ�Ҽ��˵�  
	           left: e.pageX,//�����������ʾ�˵�  
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
		$.messager.alert("��ʾ","ע��,�����ѹʣ�","info",function(){
			loadPlanPatInfoWin(Adm);
		});	
	}else{
		loadPlanPatInfoWin(Adm);
	}
}

function loadPlanPatInfoWin(Adm){
	//���ذ�����λ��win
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
		initCombogrid(data);   //�ڴ�windowʱ��������� 
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

/// ��ʼ��������ʷ�����¼
function initCombogrid(data){
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListUnPatBed&WardId="+curWrad.wardId;

	///  ����columns
	var columns=[[
		{field:'BedID',title:'��λID',width:50},
		{field:'BedCode',title:'����',width:70},
		{field:'WardDesc',title:'����',width:150},
		{field:'WardRoomDesc',title:'��������',width:150},
		{field:'BedType',title:'��λ����',width:150}
		//{field:'unavailReason',title:'������ԭ��'},
		//{field:'unavailStDate',title:'��ʼ����'},
		//{field:'unavailStTime',title:'��ʼʱ��'},
		//{field:'unavailEndDate',title:'��������'},
		//{field:'unavailEndTime',title:'����ʱ��'}
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
	        if(globleParam.planModel === "UP"){   //UP:ת�ư�ť
		        if(data.rows.length){
			    	$('#planWinPat-SeatNo').combogrid("setValue",data.rows[0].BedID)
			    }
	        }  
	    }
	});
	
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetPNurList&DepRowId="+CurLocID;

	///  ����columns
	var columns=[[
		{field:'NurId',title:'NurID',width:100},
		{field:'NurDesc',title:'�û�',width:130}
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
		$('#planWinPat-SeatNo').combogrid('setValue',"�Ⱥ���");
		$("#planWinPat-SeatNo").combogrid("disable");
	}else if (globleParam.planModel === "M"){
		$('#planWinPat-SeatNo').combogrid('setValue',selMovePat.seatID);	
	}else if(globleParam.planModel === "UP"){
			
	}else{
		$('#planWinPat-SeatNo').combogrid('setValue',selSeatPat.planSeatID);
	}
	var url = LINK_CSP+"?ClassName=web.DHCEMObsRoomSeat&MethodName=GetListDocInfo&LocDr="+data.AdmInfo.QueDepDr;
	
	///  ����columns
	var columns=[[
		{field:'CtPcpName',title:'ҽ������',width:100},
		{field:'CtPcpCode',title:'ҽ��Code',width:150},
		{field:'CtCarPrvTp',title:'ְ��',width:150}
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

///���Ӵ�λ
function addSeat(data){
	statPatNum(data);
	bedIsStop(data.BedTipMessage);
	var seatWith = data.BEDPositionWidth;     	//����
	var seatHeight= data.BEDPositionHeight;		//����
	var seatTop = data.BEDPositionTop;			//TOPֵ
	var seatLeft = data.BEDPositionLeft;		//LEFTֵ
	var seatID = data.BedID;					//��ID
	var seatTitleHeight=35;						//Title�߶�
	var sestTitleFontSize=12;					//Title�����С
	var seatTitleColor="#000"				    //����title����ɫ
	var seatTitleHtml="" ;                      //��λTitle��Html
	var seatBodyHeight = seatHeight-20;			//Body�߶�
	var seatBodyNameHeight = "";				//�����߶�
	var seatBodyIconHeight =""; //ͼ��߶�
	//var curWardName= $("#obsLocTabs").dhccTabs("getSelectTab").attr("title");  //��ǰ��������
	var curWardName= curWrad.wardDesc;
	var seatName = data.BEDCode;				//������
	var patInfoHtmlText = data.PatInfoHtmlText     //��ʾ������Ϣ
	var hasPatFlag = data.PatInfo===""?false:true; //���˱�־
	var patSex=hasPatFlag===true?data.PatInfo.PatSex:"";
	var drop="";
	var seadDrop="";
	var seatColor ="#FFF"; 							//���洲����ɫ
	var isMakeFlag="";							//������־
	var patAdm ="" ; 							//�󶨴�λAdm
    var seatTitleBgColor=""              //����title�ı���ɫ hxy 2018-04-25
	var patObsDateColor="#000";				    //����ʱ��������ɫ
	var setImgUrl="";
	if (hasPatFlag) {
		seadDrop="seatOnDrag"
		drop = "";
		//seatColor = patSex==="��"?"#8EDBFF":"#FAC8D4";
		if(patSex==="��"){
			setImgUrl = "../images/man.png";	
		}else if(patSex==="Ů"){
			setImgUrl = "../images/woman.png";
		}else{
			setImgUrl = "../images/unman.png";	
		}
	}
	if (!hasPatFlag) {
		drop = "onDroppable";
		seadDrop="";
		
	}
	if(data.BEDStatus.statusCode==="U"){   		//����
		data.PatInfo.PatName =data.PatInfo.PatName+"����";
		seatTitleBgColor="#BBBBBB"  //hxy 2018-04-25
		isMakeFlag="Y";			
	}else{
		isMakeFlag="N" ;                       //������־  				
	}
	
	if(data.PatInfo!==""){
		patAdm = data.PatInfo.PaAdm;
	}
	
	var PatNameHtml="",IconHtml="";
	if(hasPatFlag){    
		//����������html 
		PatNameHtml = PatNameHtml+'<span>';
		PatNameHtml = PatNameHtml+	'<span>'+data.PatInfo.PatName+'</span>';
		PatNameHtml = PatNameHtml+'</span>';
	}
	
	
	var patName = data.PatInfo.PatName==undefined?"":data.PatInfo.PatName;
	var PatObsDate = data.PatInfo.PatObsDate==undefined?"":data.PatInfo.PatObsDate;
	var PatCareLevel = data.PatInfo.CareLevel==undefined?"":data.PatInfo.CareLevel;
	var titleName = patName.length>3?patName.substring(0,3)+"..":patName;
	if (PatCareLevel == "�ؼ�"){
		seatTitleBgColor="#F0F0F0";
		patObsDateColor="#fff";
		seatTitleColor="#fff";
	}
	if (PatCareLevel == "һ��"){
		seatTitleBgColor="#F0F0F0";
	}
	if (PatCareLevel == "����"){seatTitleBgColor="#FFB746";}
	if (PatCareLevel == "����"){seatTitleBgColor="#2AB66A";}
	
	if(hasPatFlag){
		if(data.BEDStatus.statusCode==="U") IconHtml = "";
		if(data.BEDStatus.statusCode!=="U") IconHtml = data.IconHtmlText
		if(isMakeFlag==="Y") IconHtml="<A HREF=\"#\"><IMG align='top' SRC='../images/webemr/inactivelarge.gif' title='����' border=0></A>"+patName;  //������־
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
	var htmlStr = htmlStr+				"</div>"   //��������
	var htmlStr = htmlStr+				"<div class='seatbodyicon' style='height:"+seatBodyIconHeight+"' seatID='"+seatID+"'>";
	var htmlStr = htmlStr+					IconHtml
	var htmlStr = htmlStr+				"</div>"          //ͼ�겿��
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
		                '<div>������'+data.PatInfo.PatName+'</div>' +
		                '<div>���䣺'+data.PatInfo.PatAge+'</div>' +
		                '<div>�Ա�'+data.PatInfo.PatSex+'</div>' +
		                '<div>���ͣ�'+data.PatInfo.PatType+'</div>' +
		                '<div>�ѱ�'+data.PatInfo.AdmReason+'</div>' +
		                '<div>�ǼǺţ�'+data.PatInfo.PatNo+'</div>' +
		                '<div>��ϣ�<br>'+(data.PatInfo.MRDiagnos==undefined?"":data.PatInfo.MRDiagnos.replace(/##/g,"<br>"))+'</div>' +
		            	'<div>�ű�'+data.PatInfo.QueDepDesc+"("+data.PatInfo.AdmCare+")"+'</div>' +
		            	'<div>��'+data.PatInfo.Deposit+'</div>' +
		            	'<div>������ʱ�䣺'+data.PatInfo.PatObsDateDesc+'</div>' +
		            '</div>',
		    onShow: function(){
				
		    }	
		})
	}
}


function bedIsStop(){
	if(arguments[0]!==""){
		$.messager.alert("��ʾ",arguments[0]);	
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



///��ʼ��tabs
function initTabs(){
	
}

//�򿪲���������Ϣ���
function openPatInfoWin(){
	$('#patInfoWin').window('open');
	event.stopPropagation();  //��ֹð��
}


//function websys_lu(param){
//	window.open(param);
//	event.stopPropagation();
//}

///HISUI�۵����
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


///��ӡ���
function prtStraps(){
	if(selSeatPat.adm==="") {
		$.messager.alert("��ʾ","���߱��밲�Ŵ�λ����ܴ�ӡ�����");
		return;
	}
	newProPrtWd("",selSeatPat.adm,CurHospID);
	return;
}
/// 2016-11-28 bianshuai ҽ�������б���� 
var SelectedRowData = "";
/// ҳ���ʼ������
function initPageDefault(){

	initCombobox();  /// ��ʼ��ҳ��ѡ���б�
	initBlButton();  /// ��ʼ��ҳ�水ť�¼�
	initPatListTable(); /// ��ʼ�������б�ؼ�
    //initLgUserPriConfig(); /// ��ʼ���û�Ȩ��
}

/// ��ʼ�������б�ؼ�
function initPatListTable(){
	$('#patTable').dhccTable({
	    height:$(window).height()-142,
	    showHeader:false,
		pageSize:10,
		pagination: true,     //�Ƿ���ʾ��ҳ��*��
		clickToSelect: true,    //�Ƿ����õ��ѡ����
		formatRecordsPerPage:function(pageNumber){return ''},
	    formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmDocMainPatList',
	    queryParam: {
            params: "^^^E^^^^^^^^^"+LgCtLocID+"^"+LgUserID+"^^"+EpisodeID                 //QQA 2017-02-21
        },
        columns: [
        {
            field: 'ff',
            formatter:'patFormatter'
        }],
        onLoadSuccess:function(data){

	        ///  ���÷�������	        
            if (typeof data.EmPatLevTotal == "undefined"){return;}
        	$(".btn-toolbar .btn-success").text(data.EmPatLevCnt3+"/"+data.EmPatLevTotal);
			$(".btn-toolbar .btn-warning").text(data.EmPatLevCnt2+"/"+data.EmPatLevTotal);
			$(".btn-toolbar .btn-danger").text(data.EmPatLevCnt1+"/"+data.EmPatLevTotal);
			$('strong:contains("δ����")').html("δ���"+data.EmPatLevNotCnt+"��");

			if ($('#unfold').hasClass("fa-chevron-up")){
	         	 $('.fixed-table-container').attr("style","height:"+($(window).height()-174)+"px");
			}else{
	            $('.fixed-table-container').attr("style","height:"+($(window).height()-292)+"px");
			}

			if(data.rows.length != 0){
				setPatInfoPanel(data.rows[0]);
		   		/// ���ؿ��
				LoadPatInfoFrame(data.rows[0]);
				SelectedRowData = data.rows[0];
		
				}
		
	    },
	    onClickRow:function(rowData, $element, field){
		    
		    /// ����ɫ����
		    $($element).addClass("row-background");
		    $($element).siblings().removeClass("row-background");
		    /// ������Ϣ
		    setPatInfoPanel(rowData);
		    /// ���ؿ��
			LoadPatInfoFrame(rowData);
			SelectedRowData = rowData;
		}
    });
}

/// table td ��ʽ ������Ϣ��Ƭ
function patFormatter(value, rowData) {

    	var htmlstr =  '<div class="celllabel"><h3 style="float:left"><span style="color:#f22613;margin-right:10px;">'+ rowData.LocSeqNo +'</span>'+ rowData.PatName +'</h3><h3 style="float:right"><span>'+ rowData.PatSex +'/'+ rowData.PatAge +'</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left">ID:'+ rowData.PatNo +'</h4>';
		var classstyle="color: #18bc9c";
		if(rowData.PatLevel==3) {classstyle="color: #f9bf3b"};
		if(rowData.PatLevel==1) {classstyle="color: #f22613"};
		if(rowData.PatLevel==2) {classstyle="color: #f22613"};
		var level=""
		if(rowData.PatLevel>0){
			level=rowData.PatLevel+"��";
		}
		htmlstr = htmlstr +'<h4 style="float:right"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+level+'</span></h4></div>';

		return htmlstr;
}

/// ҳ��Combobox��ʼ����
function initCombobox(){
	
	runClassMethod("web.DHCEMPatCheckLevCom","CardTypeDefineListBroker",{},function (data){
		
		var CardTypeArr=[]; //�����ҵ�
		var objDefult  = new Object();
		for (var i=0;i<data.length;i++){
			var obj = new Object();
			if(data[i].value.split("^")[8]=="N"){
				obj.id=data[i].value;
				obj.text=data[i].text;
				CardTypeArr.push(obj);
			}else if(data[i].value.split("^")[8]=="Y"){
				objDefult.id=data[i].value;
				objDefult.text=data[i].text;
				CarTypeSetting(objDefult.id);
			}
		}
		CardTypeArr.unshift(objDefult);

		$("#CardType").dhccSelect({
   			data:CardTypeArr,
   			minimumResultsForSearch:-1
		});
		$('#CardType').on('select2:select', function (evt) {
  			CarTypeSetting(this.value);
		}); 
	});
}


function CarTypeSetting(value){

	m_SelectCardTypeDR = value.split("^")[0];
	var CardTypeDefArr = value.split("^");
    m_CardNoLength = CardTypeDefArr[17];

    if (CardTypeDefArr[16] == "Handle"){
    	$('#CardNo').attr("readOnly",false);
    }else{
		$('#CardNo').attr("readOnly",true);
	}
	$('#CardNo').val("");  /// �������
	$('#PatNo').val("");   /// �������
}

/// ҳ�� Button ���¼�
function initBlButton(){

	///  ����
	//$('a:contains("����")').bind("click",readCard);
		
	///	 �ǼǺ�
	$('#PatNo').bind('keypress',GetEmPatInfo);
	
	///  ����
	$('#CardNo').bind('keypress',GetEmPatInfoByCardNo);	
	
	///	 ����
	$('#AdmReqNo').bind('keypress',GetEmPatList);
	
	/// ��ʼ����
	$('#startdate').dhccDate();
	$("#startdate").setDate(new Date().Format("yyyy-MM-dd"));
	
	/// ��������
	$('#enddate').dhccDate();
	$("#enddate").setDate(new Date().Format("yyyy-MM-dd"));
	
	/// ��ѯ��ť
	$("#queryBtn").bind('click',function(){
		search("");
	});
	
	/// �ּ�����ť����¼�
	$(".btn-toolbar button").bind('click',function(){
		search(this.id);
	});
	
	/// չ��/������ť
	$('#unfold').bind('click',function(){
		if ($(this).hasClass("fa-chevron-up")){
			$(this).removeClass("fa-chevron-up");
            $(this).addClass("fa-chevron-down");
            $('.fixed-table-container').attr("style","height:"+($(window).height()-292)+"px");
		}else{
			$(this).removeClass("fa-chevron-down");
            $(this).addClass("fa-chevron-up");
            $('.fixed-table-container').attr("style","height:"+($(window).height()-174)+"px");
		}
	})
	
	/// չ��/������ť
	$('#fold').bind('click',function(){
		if ($(this).hasClass("fa-angle-left")){
			$(this).removeClass("fa-angle-left");
            $(this).addClass("fa-angle-right");
            $(".sidebar-menu").hide();
		}else{
			$(this).removeClass("fa-angle-right");
            $(this).addClass("fa-angle-left");
            $(".sidebar-menu").show();
		}
	})
	
	/// ����״̬��ť�¼�
	$("#PriCon a").bind('click',showModPanel)
	
	/// ���²���״̬
	$("#update").bind('click',function(){
		modPatStatus();
	});
	
	/// ����
	$('#EmBed').bind('click',BedPopUpWin);	
	
	/// ���ﲡ��
	$("#EmWard").change(function(){
		$("#EmBed").val("");   /// ��λ����
		$("#EmBedID").val("");   /// ��λID
	})
	
	/// Tabs ����¼�
	$(".J_menuTabs").on("click", ".J_menuTab", TabsEvent);
}

///  �ǼǺŻس�
function GetEmPatInfo(e){
			
	 if(e.keyCode == 13){
		var EmPatNo = $("#PatNo").val();
		///  �ǼǺŲ�0
		var EmPatNo = GetWholePatNo(EmPatNo);
		//clearEmPanel();				///  ���
		$("#PatNo").val(EmPatNo);
		
		runClassMethod("web.DHCEMPatCheckLevCom","CheckPatNo",{"EmPatNo":EmPatNo},function(jsonString){
			
			if (jsonString ==-1){
				dhccBox.alert("��ǰ����Ч,�����ԣ�","register-one");
				return;

			}else{
				$("#PatAdmInfoOne").css("display","none")
				GetEmRegPatInfo();
			}
			
		},'text',false)
		
	}
}

///  ���Żس�
function GetEmPatInfoByCardNo(e){
	if(e.keyCode == 13){
		var CardNo = $("#CardNo").val();
		var CardNoLen = CardNo.length;
		if (m_CardNoLength < CardNoLen){
			//$("#emcardno").focus().select();
			dhccBox.alert("�����������,������¼�룡","register-one");
			return;
		}

		/// ���Ų���λ��ʱ��0
		for (var k=1;k<=m_CardNoLength-CardNoLen;k++){
			CardNo="0"+CardNo;  
		}
		
		clearEmPanel();				///  ���
		
		$("#CardNo").val(CardNo);

		///  ���ݿ���ȡ�ǼǺ�
		var EmPatNo = "";
		runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){

			if (jsonString ==-1){
				dhccBox.alert("��ǰ����Ч,�����ԣ�","register-one");
				return;

			}else{
				EmPatNo = jsonString;
				$("#PatNo").val(EmPatNo);
			}
			
		},'text',false)

		GetEmRegPatInfo();
	}
}

/// ��ȡ������Ϣ
function GetEmRegPatInfo(){
	
	var EmPatNo = $("#PatNo").val();        /// �ǼǺ�;
	var PatientID = $("#PatientID").val();  /// ����ID
	runClassMethod("web.DHCEMDocMainOutPat","GetEmRegPatInfo",{"EmPatNo":EmPatNo,"PatientID":PatientID},function(jsonString){
		
		if (jsonString != null){
			var rowData = jsonString;
			setPatInfoPanel(rowData);
			search("");
		}
	},'json',false)
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
			dhccBox.alert("�ǼǺ��������","register-one");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// ���õǼ��������
function setPatInfoPanel(rowData){
	if(rowData.PatSex=="��")
	{
		htmlstr='<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;" src="../scripts/dhcnewpro/images/nursemano.png" />'
	}else
	{
		htmlstr='<img style="width:30px;heigth:30px;border-radius:50%;margin:3px 15px 5px -2px;background-color:#EEEEEE;border:0;" src="../scripts/dhcnewpro/images/nursewomano.png" />'
	}
	classstyle="color: #18bc9c";
	classtext="����"
	if(rowData.EmPatLev==3) {classstyle="color: #f9bf3b";classtext="����"};
	if(rowData.EmPatLev==1) {classstyle="color: #f22613";classtext="����"};
	if(rowData.EmPatLev==2) {classstyle="color: #f22613";classtext="����"};
	var htmlstr = htmlstr +'<span style="font-size:16px;color:#000;">'+ rowData.PatName +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		htmlstr = htmlstr + '<div class="badge " style="background-'+classstyle+';margin: 3px 5px 3px 0px; border-radius: 5px;height:20px;width:28px;"><span style="font-size: 11px; margin-left: -5px;">'+classtext+'</span></div>';
	    htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PatLevel +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
	    /*htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PAAdmBed +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';*/
	    htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PAAdmReason +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PatSex +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		htmlstr = htmlstr + '<span style="color:#758697">'+ rowData.PatBDay +'</span><span style="margin-left:8px;margin-right:8px;color:#758697">|</span>';
		/* htmlstr = htmlstr + '<ul id="PriCon" class="nav navbar-top-links pull-right" style="margin-right:5px;">';
		htmlstr = htmlstr +	'<li><a href="#" class="btn-primary" style="color:#fff;width:80px;height:28px;text-align:center;" data-id="Salvage">����</a></li>';
		htmlstr = htmlstr +	'<li><a href="#" class="btn-primary" style="color:#fff;width:80px;height:28px;text-align:center;" data-id="Stay">����</a></li></ul>'; */
	/* 	htmlstr = htmlstr + '<span style="color:red;font-weight:bold;color:##758697;display:none">'+ rowData.BillType +'</span>';
		htmlstr = htmlstr + '<span id="EpisodeID" style="display:none;">'+ rowData.EpisodeID +'</span>';
		htmlstr = htmlstr + '<span id="PAAdmType" style="display:none;">'+ rowData.PAAdmType +'</span>'; */
	$("#PatAdmInfo").html(htmlstr);
	
	
	/*if (rowData.PatSex == "Ů"){
		$("#seximg").attr("src","../scripts/dhcnewpro/images/nursewomano.png");
	}else{
		$("#seximg").attr("src","../scripts/dhcnewpro/images/nursemano.png");
	}*/
	
	var htmlstr = "";
	htmlstr = htmlstr + '<span id="EpisodeID" style="display:none;">'+ rowData.EpisodeID +'</span>';
	htmlstr = htmlstr + '<span id="PAAdmType" style="display:none;">'+ rowData.PAAdmType +'</span>';
	$(".page-title form").append(htmlstr);

	$("#CardNo").val(rowData.PatCardNo);   		    /// ����
	$("#PatNo").val(rowData.PatNo);   		        /// �ǼǺ�
	
	/*$("#PatName").val(rowData.PatName);   		    /// ����
	$("#PatSex").val(rowData.PatSex);   		    /// �Ա�
	$("#PatCardBal").val(rowData.PatCardBal);   		    /// ���
	$("#PatLevel").val(rowData.PatLevel);   		    /// ����
	$("#BillType").val(rowData.BillType);   		    /// �ѱ� */
	//$("#PatientID").val(rowData.PatientID);   		/// PatientID
	//$("#PatientID").val(rowData.PatientID);   		/// PatientID
	
	//GetEmPatCardTypeDefine(rowData.CardTypeID);  ///  ���ÿ�����
}

/// ��ȡ���˶�Ӧ����������
function GetEmPatCardTypeDefine(CardTypeID){

	runClassMethod("web.DHCEMPatCheckLevCom","GetEmPatCardTypeDefine",{"CardTypeID":CardTypeID},function(jsonString){
		
		if (jsonString != null){
			var CardTypeDefine = jsonString;
			var CardTypeDefArr = CardTypeDefine.split("^");
			if (CardTypeDefArr[16] == "Handle"){
				$('#CardNo').attr("readOnly",false);
			}else{
				$('#CardNo').attr("readOnly",true);
			}
			$("#CardType").combobox("setValue",CardTypeDefine);
		}
	},'',false)
}

///	 ���
function clearEmPanel(){

	$("#CardNo").val(""); /// ����
	$("#PatNo").val("");  /// �ǼǺ�
}	

/// �����س��¼�����
function GetEmPatList(e){
	
	if(e.keyCode == 13){
			
		$("#CardNo").val(""); /// ����
		$("#PatNo").val("");  /// �ǼǺ�
		search("");
	}
}

/// ����
function search(btn_id){
	
	$("#PatAdmInfoOne").css("display","none");
	/// ����
	var CardNo = $("#CardNo").val();
	
	/// �ǼǺ�
	var PatNo = "" //$("#PatNo").val();
	/// ��ʼ����
	var startdate = $('#startdate input').val();
	/// ��������
	var enddate = $('#enddate input').val();
	/// ��������
	var PatType = "E";
	/// �Ѿ���
	var OutArrivedQue=$("#admstatues").is(':checked')?"on":"";
	/// ����
	var AdmReqNo = $("#AdmReqNo").val();;

	/// �ּ�
	var EmPatLev = "";
	if (btn_id == "btn_danger"){EmPatLev = "1"; }
	if (btn_id == "btn_warning"){EmPatLev = "2"; }
	if (btn_id == "btn_success"){EmPatLev = "3"; }

	var param = PatNo +"^^^"+ PatType +"^"+ CardNo +"^"+ startdate +"^"+ enddate+"^"+ OutArrivedQue +"^^^^"+ AdmReqNo +"^"+LgCtLocID +"^"+ LgUserID +"^"+ EmPatLev+"^"+EpisodeID;
	$('#patTable').bootstrapTable('refresh',{
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocMainOutPat&MethodName=JSonQryEmDocMainPatList&params='+param
	});
}

/// ����
function callPatient(){

	///���ýкŹ�˾��webervice���к���
	runClassMethod("web.DHCDocOutPatientList","SendCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
			if(retArr[0]=="0"){
				search("");  /// ��ѯ�����б�
				return;
			}else{
				return;
			}
		}
	},'',false)
}

/// �ظ�����
function reCallPatient(){

	///���ýкŹ�˾��webervice�����ظ�����
	runClassMethod("web.DHCDocOutPatientList","SendReCallInfo",{"UserId":LgUserID},function(jsonString){
		
		if (jsonString != null){
			var retArr = jsonString.split("^");
		}
	},'',false)
}

/// ����
function outCallQueue(){
	
	//var rowData = $('#patTable').bootstrapTable('getAllSelections');
	if (SelectedRowData == ""){
		dhccBox.alert("����ѡ��Ҫ���ŵĲ��˺����ԣ�","register-one");
		return;
	}
	var AdmDate=SelectedRowData.PAAdmDate;
	if (CheckAdmDate(AdmDate)==false) {
		dhccBox.alert("��ѡ���վ��ﲡ�ˣ�","register-one");
		return;
	}
	if(SelectedRowData.Called == ""){
		dhccBox.alert("û�к��еĲ��˲��ܹ��ţ�","register-one");
		return;
	}

	var PatName=SelectedRowData.PatName;
	var Patient="�ǼǺ�: "+SelectedRowData.PatNo+" ����: "+PatName;
	dhccBox.confirm("�Ի���",Patient + "�Ƿ���Ҫ����?","my-modalone",function(res){
		if (res){
			var EpisodeID = SelectedRowData.EpisodeID; /// ����ID
			var DoctorId = SelectedRowData.RegDocDr;   /// ҽ��ID
			runClassMethod("web.DHCDocOutPatientList","SetSkipStatus",{"Adm":CardTypeID,"DocDr":DocDr},function(jsonString){
	
				if (jsonString != ""){
					dhccBox.alert("����ʧ�ܣ�ʧ��ԭ��:" + jsonString,"register-one");
				}
			},'',false)

			search(""); /// ���²�ѯ�����б�	
		}
	})
}

/// ����Ƿ��ǵ������
function CheckAdmDate(AdmDate)	{

	var ToDay= new Date();
	var Year=ToDay.getFullYear();
	var Month=ToDay.getMonth();
	Month=Month+1;
	if (Month<10) {Month='0'+Month;}
	var Day=ToDay.getDate();
	if (Day<10) Day='0'+Day;
	var StrDate=Year+'-'+Month+'-'+Day
	if (StrDate==AdmDate) {return true}
	else  {return false;}	
}

/// ˢ�¿������
function LoadPatInfoFrame(rowData){

	$(".J_menuTab").each(function(){
		$(this).attr("data-regno",rowData.CardNo);
		$(this).attr("data-episodeid",rowData.EpisodeID);
		$(this).attr("data-patientid",rowData.PatientID);
	})
	var csp = $("iframe:visible").data("id")+"?RegNo="+rowData.CardNo+"&EpisodeID="+rowData.EpisodeID //+"&Allgryflag="+rowData.Allgryflag;
	$("iframe:visible").attr("src",csp)	
	
}

/// ��ʼ���û�Ȩ��
function initLgUserPriConfig(){

	/// ����
	runClassMethod("web.DHCEMDocMainOutPat","GetEmPatStatusAcc",{"userid":LgUserID,"GroupID":LgGroupID,"AuthCode":"Stay"},function(res){
		if (res == 1){
			$("#PriCon").append('<li><a href="#" class="btn-success" style="color:#fff;width:70px;height:35px;text-align:center;border-radius:5px;" data-id="Inhospital">����</a></li>');
		}
	},'',false)
	
	/// ����
	runClassMethod("web.DHCEMDocMainOutPat","GetEmPatStatusAcc",{"userid":LgUserID,"GroupID":LgGroupID,"AuthCode":"Salvage"},function(res){
		if (res == 1){
			$("#PriCon").append('<li><a href="#" class="btn-danger" style="color:#fff;width:70px;height:35px;text-align:center;border-radius:5px;" data-id="Displace">����</a></li>');
		}
	},'',false)
}

/// ����״̬��ť�¼�
function showModPanel(){
	
	var EpisodeID = $("#EpisodeID").text();
	if (EpisodeID == ""){
		//dhccBox.alert("����ѡ����Ҫ�޸�״̬�Ĳ��ˣ�","report-timeone");	
		//return ;
	}
	var type=$(this).attr("data-id");
	$("#CommonModel .modal-title").html($(this).html()+"( ������ﲡ��״̬ )");
	//����
	if(type == "Stay"){
		runClassMethod("web.DHCEMPatChange","GetAbnormalConsultAlert",{"EpisodeID":EpisodeID},function(res){
			res = 0
			if (res != '0') {
				dhccBox.alert(res,"report-two");
				return;
			}else{
				conceal();
				$('#changedate').css("display","");
				$('#changetime').css("display","");	
				$('#patarea').css("display","");
				$('#emarea').css("display","");
				$('#embed').css("display","");
				$('#update').attr("data-type","Stay")
				$("#CommonModel .modal-header").addClass("bg-success")
				$('#CommonModel').modal()
			}
		},'',false)
		
		/// ��Ժ����
		$('#InHosWard').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpWardTojson"
		})
		
		/// ���ﲡ��
		$('#EmWard').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpWardTojson&locType=EM"
		})
	
		/// ���ﴲλ
		$('#EmBed').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpCtlocTojson"
		})
	}
	
	/// ����
	if(type == "Salvage"){
		runClassMethod("web.DHCEMPatChange","GetAbnormalConsultAlert",{"EpisodeID":EpisodeID},function(res){
			res = 0
			if (res != '0') {
				dhccBox.alert(res,"report-two");
				return;
			}else{
				conceal();
				$('#changedate').css("display","");
				$('#changetime').css("display","");	
				$('#patarea').css("display","");
				$('#update').attr("data-type","Salvage")
				$("#CommonModel .modal-header").addClass("bg-danger")
				$('#CommonModel').modal()
			}
		},'',false)
		
		/// ��Ժ����������
		$('#InHosWard').dhccSelect({
			url:LINK_CSP+"?ClassName=web.DHCEMPatChange&MethodName=LookUpCtlocTojson"
		})
	}
}

/// �޸Ĳ���״̬
function modPatStatus(){
	
	var PAAdmType = $("#PAAdmType").text();
	if (PAAdmType != "E"){
		var PAAdmType = (PAAdmType == "E"?"����":"����")
		//dhccBox.alert("�˲���ֻ����Լ��ﲡ�˽���,���ʵ����״̬����ǰ����״̬Ϊ��" + PAAdmType,"register-one");
		//return;
	}
	var type = $(this).attr("data-type");
	if(type == "Stay"){
		SetPatSatyStatus();    /// ���²�������״̬
	}else{
		SetPatSalvageStatus(); /// ���²��˼���״̬
	}
}

/// ���²�������״̬
function SetPatSatyStatus(){
	
	var EpisodeID = $("#EpisodeID").text();
	var StatusDate=$('#StatusDate input').val();  /// �������
	var StatusTime=$('#StatusTime input').val();  /// ���ʱ��
	if ((StatusDate=="" )||(StatusTime=="")){
		dhccBox.alert("���ڻ�ʱ�䲻��Ϊ�գ�","report-timeone");	
		return ;
	}
	/// ��Ժ����
	var InHosWard=$('#InHosWard option:selected').text();

	/// ���۲���
	var EmWardID=$('#EmWard option:selected').attr("value");
	
	/// ��λ
	var EmBedID=$('#EmBedID').val();
	
	/// ����״̬
	runClassMethod("web.DHCEMPatChange","setPatSatyStatus",{"EpisodeID":EpisodeID,"StatusDate":StatusDate,'StatusTime':StatusTime,'userID':LgUserID,'WardDesc':InHosWard,'LocID':LgCtLocID,'EmWardID':EmWardID,'EmBedID':EmBedID},function(res){
		if (res != 0){
			dhccBox.alert("����״̬����!","report-inserttwo");
			return;
		}
	},'',false);
}

/// ���²��˼���״̬
function SetPatSalvageStatus(){
	
	var EpisodeID = $("#EpisodeID").text();
	var StatusDate=$('#StatusDate input').val();  /// �������
	var StatusTime=$('#StatusTime input').val();  /// ���ʱ��
	if ((StatusDate=="" )||(StatusTime=="")){
		dhccBox.alert("���ڻ�ʱ�䲻��Ϊ�գ�","report-timeone");	
		return ;
	}

	/// ��Ժ����
	var InHosWard=$('#InHosWard option:selected').text();
	/// ����״̬
	runClassMethod("web.DHCEMPatChange","InsertVis",{"EpisodeID":EpisodeID,"visStatCode":"Salvage","avsDateStr":StatusDate,'avsTimeStr':StatusTime,'userId':LgUserID,'wardDesc':InHosWard},function(res){
		if (res != 0){
			dhccBox.alert("����״̬����!","report-inserttwo");
		}else{
			dhccBox.alert("�޸ĳɹ�!","report-inserttwo");
		}
	},'',false)	
}

//����modal����Ԫ��
function conceal(){
	
	$("#CommonModel .modal-header").removeClass("bg-success");
	$("#CommonModel .modal-header").removeClass("bg-danger");
	$('#changedate').css("display","none");
	$('#changetime').css("display","none");
	$('#patarea').css("display","none");
	$('#emarea').css("display","none");
	$('#embed').css("display","none");
	
	$('#StatusDate').dhccDate();
	$("#StatusDate").setDate(new Date().Format("yyyy-MM-dd"))
	
	$('#tp-time').timepicker({minuteStep:1,showMeridian:false});	
}

/// ��λ����¼�
function BedPopUpWin(e){
	
	var BedUrl = 'dhcapp.broker.csp?ClassName=web.DHCEMPatChange&MethodName=JSonQryEmWardBed';

	var BedColumns = [
		{checkbox: true,title:'ѡ��'},
		{field:'BedID',title:'��λID',visible:false},
	    {field:'BedDesc',title:'��λ'},
	    {field:'WardDesc',title:'����'},
	    {field:'RoomDesc',title:'����'},
		{field:'BedType',title:'��λ����'},
		{field:'RoomType',title:'��������'}
	];
	
	var EmWardID = $('#EmWard option:selected').attr("value");
	if (typeof EmWardID == "undefined"){EmWardID="";}
	var unitUrl = BedUrl+"&WardID="+EmWardID+"&EpisodeID=11";
	/// ����ҽ�����б���
	new PopUpWin($("#EmBed"), "760", "260" , unitUrl, BedColumns, setCurrArcEditRowCellVal).init();

}

/// ����ǰ�༭����ֵ
function setCurrArcEditRowCellVal(rowObj){
	if (rowObj == null){
		$("#EmBed").focus().select();  ///���ý��� ��ѡ������
		return;
	}

	$("#EmBed").val(rowObj.BedDesc);   /// ��λ����
	$("#EmBedID").val(rowObj.BedID);   /// ��λID
}

/// tab����¼�����
function TabsEvent() {
    
    if (!$(this).hasClass("active")) {
        var k = $(this).data("id");
        regno=$(this).attr("data-regno");
        episodeid=$(this).attr("data-episodeid");
        patientid=$(this).attr("data-patientid");
        if (patientid == ""){
			dhccBox.alert("����ѡ���ˣ�","report-timeone");	
			return ;
        }
        $(".J_mainContent .J_iframe").each(function() {
            if ($(this).data("id") == k) {
                
                if($(this).attr("src").indexOf("?")==-1){
	               $(this).attr("src",k+"?RegNo="+regno+"&EpisodeID="+episodeid+"&PatientID="+patientid) 
	            }else{
		            if(checkUrlParam($(this).attr("src"),regno)==0){
			             $(this).attr("src",k+"?RegNo="+regno+"&EpisodeID="+episodeid+"&PatientID="+patientid)
			         }   
		        }
                
                $(this).show().siblings(".J_iframe").hide();
                return false
            }
        });
        $(this).addClass("active").siblings(".J_menuTab").removeClass("active");
        g(this)
    }
}
    
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
<!--js  bill.einv.validblankpaper.js -->
<!-- ��ں��� -->


var PUBLIC_CONSTANT = {
	SESSION: {
		GUSER_ROWID: session['LOGON.USERID'],
		HOSP_ROWID: session['LOGON.HOSPID'],
		GROUP_ROWID:session['LOGON.GROUPID']
	},
	VARIABLE:{
		m_CurInvNo: "",
 		m_EndInvNo: "",
		m_AbortEndInvNo: ""	
	}
};

$(document).ready(function () {
	setItemReadOnly();
	initTypeCombo();
	setElementEvent();
});

function setElementEvent(){
	
	$HUI.linkbutton('#Determine', {
		onClick: function () {
			Determine_click();
		}
	});	
	
	$HUI.linkbutton('#Cancle', {
		onClick: function () {
			Cancel_click();
		}
	});
	
	
	//$('#CancleNum').off('keydown').on('keydown', function () { 
	$('#CancleNum').bind('input propertychange', function() {  
		CancleNumKeyDown();
	});
}
//������
var initTypeCombo = function () {
	$HUI.combobox('#IUDPayAdmType',{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	method:"GET",
    	onBeforeLoad:function(param)
    	{
	    	param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
	    	param.QueryName="QueryDicDataInfo"
	    	param.ResultSetType="array";
	    	param.Type="LogicIUDType"          
	    },
	    
	     onChange:function(){
		     setIUDPayAdmType();
		} 
	});
	
	$('#IUDPayAdmType').combobox('setValue','PO');

}
/*
///��ȡ��ǰֽ��Ʊ�ݴ����Ʊ�ݺ�
function GetStockBillNo(LogicIUDType){
	if (LogicIUDType==""){
		var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	}
	var UserID=PUBLIC_CONSTANT.SESSION.GUSER_ROWID;
	var InputPam=UserID+"^"+LogicIUDType;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetStockBillNo",
		InputPam:InputPam,
		PathCode:"PaperNo"
		},function(rtn){
			//alert(rtn)
			if(rtn<0){
	        	$.messager.show({title:'��ʾ',msg:'��ȡ��ǰƱ��ʧ�ܣ�',timeout:1000,showType:'slide'});
	        }else{
		        //rtn.split("^")[1]
		        $("#IBBCode").val(rtn.split("^")[0]);			//ֽ��Ʊ�ݴ���
		        $("#IBBNo").val(rtn.split("^")[1]);			//ֽ��Ʊ�ݺ���
		        $("#DIBBCode").val(rtn.split("^")[1]);		//��ǰֽ��Ʊ�ݺ���
	   		}
	});		
	
}

*/
///��ȡ��ǰƱ��(���ű��ȡ��ǰƱ��)
///w ##class(web.udhcOPBillIF).GetreceipNO("dddddd","","1^^1^PO")
function GetStockBillNo(LogicIUDType){
	/*
	if (LogicIUDType==""){
		var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	}
	*/
	var LogicIUDType=$('#IUDPayAdmType').combobox('getValue');
	
	var UserID=PUBLIC_CONSTANT.SESSION.GUSER_ROWID;
	var GroupId=PUBLIC_CONSTANT.SESSION.GROUP_ROWID;
	var HosptalId=PUBLIC_CONSTANT.SESSION.HOSP_ROWID;

	var AdmReasonId=""
	var OutMsg=""
	var InputPam=UserID+"^"+LogicIUDType+"^"+GroupId+"^"+AdmReasonId+"^"+HosptalId;
	//alert("InputPam="+InputPam);
	  $.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetPaperBillNo",
		InputData:InputPam,
		OutMsg:OutMsg
		},function(rtn){
			//alert(rtn);
			var RtnFlg=rtn.split("^")[0];
			if(RtnFlg!="-1"){
		        $("#IBBCode").val(rtn.split("^")[3]);
		        $("#IBBNo").val(rtn.split("^")[0]);
				$("#DIBBCode").val(rtn.split("^")[0]);
				$("#endInvNo").val(rtn.split("^")[2]);   //��������
			}else{
				var errMsg=rtn.split("^")[1];
				alert(errMsg);
			}
	  });	

}

function setIUDPayAdmType(){
	var InvType=$('#IUDPayAdmType').combobox('getValue');
	GetStockBillNo(InvType);
}


function Determine_click(){
	var receiptType=$('#IUDPayAdmType').combobox('getValue');
	if (receiptType==""){
		$.messager.alert('��֤', 'Ʊ�����Ͳ�����Ϊ��');
		return false;
	}
	var CancelNum=$('#CancleNum').val();
	if (CancelNum==""){
		$.messager.alert('��֤', '��������������.');
		$('#CancleNum').focus();
		return false;
	}
	
	var CancleReason=$('#CancleReason').val();
	if (CancleReason==""){
		$.messager.alert('��֤', '����ԭ����Ϊ��.');
		return false;
	}
	var CancelEndInvNo=$('#OIBBNo').val();
	var CurrInvNO=$('#DIBBCode').val();
	
	//alert(parseInt(CancelEndInvNo, 10));
	//alert(parseInt(CurrInvNO, 10));
	if (parseInt(CancelEndInvNo, 10) < parseInt(CurrInvNO, 10)) {
		$.messager.alert('��֤', '�������벻��С�ڿ�ʼ����,����������.');
		return false;
	}

	//InputPam(�շ�ԱID^ֽ��Ʊ�ݴ���^��ʼֽ��Ʊ�ݺ�^��ֹֽ��Ʊ�ݺ�^����ԭ��...)
	var UserID=PUBLIC_CONSTANT.SESSION.GUSER_ROWID;
	var GroupId=PUBLIC_CONSTANT.SESSION.GROUP_ROWID;
	var HosptalId=PUBLIC_CONSTANT.SESSION.HOSP_ROWID;
	var PaperCode=$('#IBBCode').val();				//ֽ��Ʊ�ݴ���
	var StPaperNo=$('#IBBNo').val();				//ֽ��Ʊ�ݺ���
	var EndPaperNo=$('#OIBBNo').val();				//��ǰֽ��Ʊ�ݺ�
	var endInvNo=""                                 //������Ʊ��
	var title=""
    var admReason=""                                // �ѱ�ID
    //var receiptType=""                               //�շ�����
    var Hospital=HosptalId                                  //Ժ��
	var InputPam=UserID+"^"+GroupId+"^"+StPaperNo+"^"+CancleReason+"^"+EndPaperNo+"^"+CancelNum+"^"+endInvNo+"^"+title+"^"+admReason+"^"+receiptType+"^"+Hospital
	alert(InputPam);
	alert("PaperCode="+PaperCode);
	//return 0;
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"ValidPaper",
		InputPam:InputPam,
		pBillBatchCode:PaperCode
		},function(rtn){
			if(rtn=="0"){
				 GetStockBillNo("");
				 $("#CancleNum").val("");				//ֽ��Ʊ�ݺ���
			     $("#CancleReason").val("");			//��ǰֽ��Ʊ����
				 $("#OIBBNo").val("");			        //����ֽ�ʺ���
				 $("#DIBBCode").val("");			    //ֽ��Ʊ�ݴ���
	         	 GetStockBillNo("");
	         	 alert("���ϳɹ�!");
			}else{
				alert("����ʧ��!");
			}
      window.close();
	});
	
}

function Cancel_click(){
	window.close();
}

///�����ı���ֻ��
function setItemReadOnly(){
	$('#CancleNum').focus();
	$("#IBBNo").attr("readOnly", true);				//ֽ��Ʊ�ݺ���
	$("#DIBBCode").attr("readOnly", true);			//��ǰֽ��Ʊ����
	$("#OIBBNo").attr("readOnly", true);			//����ֽ�ʺ���
	$("#IBBCode").attr("readOnly", true);			//ֽ��Ʊ�ݴ���
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0) {
			return false;
		}
	}
	return true;
}

function AbortNum_KeyPress(e) {
	var keyCode = websys_getKey(e);
	if ((keyCode < 48) || (keyCode > 57)) {
		window.event.keyCode = 0;
		return websys_cancel();
	}
}

function AbortNum_OnKeyUp() {
	var num = $('#CancleNum').val();
	if (num == "" || (parseInt(num, 10) == 0)) {
		return;
	}
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	var CurInvNo = PUBLIC_CONSTANT.VARIABLE.m_CurInvNo;
	var index = CurInvNo.search(/\d/);      
	var snost = CurInvNo.substring(0, index);
	var snoend = CurInvNo.substring(index);
	if (checkno(num) && (m_CurInvNo != "") && checkno(snoend)) {
		ssno1 = parseInt(snoend, 10) + parseInt(num, 10) - 1;
		ssno = ssno1.toString();
		slen = snoend.length;
		sslen = ssno.length;
		for (i = slen; i > sslen; i--) {
			ssno = '0' + ssno;
		}
		var CancleEndInvNo = PUBLIC_CONSTANT.VARIABLE.m_AbortEndInvNo;
		CancleEndInvNo= snost + ssno;
		var EndPaperNo = PUBLIC_CONSTANT.VARIABLE.m_EndInvNo;
		$('#OIBBNo').val('[' + CancleEndInvNo + ']');
		
	}
}
	
/*function CancleNumKeyDownOld(e){
	//alert(1234)
	var e = event ? event : (window.event ? window.event : null);
	var eSrc = window.event.srcElement;
	var key = websys_getKey(e);
	if (key == 13) 
	{
		var num=$('#CancleNum').val();
		
		var DIBBCode=$('#DIBBCode').val();
		$('#OIBBNo').val(parseInt(DIBBCode)+parseInt(num)-1);
	}
	
}*/

function CancleNumKeyDown(){
	var num=$('#CancleNum').val();
	if(num==""){
		return 0;
	}
	
	var DIBBCode=$('#DIBBCode').val();
	var endInvNo=$("#endInvNo").val();
	var endInvNoNum=parseInt(endInvNo, 10)
	//alert("endInvNoNum="+endInvNoNum);
	
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	var index = DIBBCode.search(/\d/);      //+2018-02-12 ZhYW ȡ��һ���������ַ��������ڵ�λ��
	var snost = DIBBCode.substring(0, index);
	var snoend = DIBBCode.substring(index);
	//alert("index="+index+"|snost="+snost+"|snoend="+snoend);
	if (checkno(num) && (DIBBCode != "") && checkno(snoend)) {
		ssno1 = parseInt(snoend, 10) + parseInt(num, 10) - 1;
		if(ssno1>endInvNoNum){
			$('#OIBBNo').val("");
			alert("�����˽�������!");
			return 0
		}
		
		ssno = ssno1.toString();
		slen = snoend.length;
		sslen = ssno.length;
		for (i = slen; i > sslen; i--) {
			ssno = '0' + ssno;
		}
		m_AbortEndInvNo = snost + ssno;
		$('#OIBBNo').val(m_AbortEndInvNo);
	}	
	
}
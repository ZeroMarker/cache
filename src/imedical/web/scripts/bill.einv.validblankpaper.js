<!--js  bill.einv.validblankpaper.js -->
<!-- 入口函数 -->


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
//下拉框
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
///获取当前纸质票据代码和票据号
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
	        	$.messager.show({title:'提示',msg:'获取当前票号失败！',timeout:1000,showType:'slide'});
	        }else{
		        //rtn.split("^")[1]
		        $("#IBBCode").val(rtn.split("^")[0]);			//纸质票据代码
		        $("#IBBNo").val(rtn.split("^")[1]);			//纸质票据号码
		        $("#DIBBCode").val(rtn.split("^")[1]);		//当前纸质票据号码
	   		}
	});		
	
}

*/
///获取当前票号(发放表获取当前票号)
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
				$("#endInvNo").val(rtn.split("^")[2]);   //结束号码
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
		$.messager.alert('验证', '票据类型不允许为空');
		return false;
	}
	var CancelNum=$('#CancleNum').val();
	if (CancelNum==""){
		$.messager.alert('验证', '请输入作废张数.');
		$('#CancleNum').focus();
		return false;
	}
	
	var CancleReason=$('#CancleReason').val();
	if (CancleReason==""){
		$.messager.alert('验证', '作废原因不能为空.');
		return false;
	}
	var CancelEndInvNo=$('#OIBBNo').val();
	var CurrInvNO=$('#DIBBCode').val();
	
	//alert(parseInt(CancelEndInvNo, 10));
	//alert(parseInt(CurrInvNO, 10));
	if (parseInt(CancelEndInvNo, 10) < parseInt(CurrInvNO, 10)) {
		$.messager.alert('验证', '结束号码不能小于开始号码,请重新输入.');
		return false;
	}

	//InputPam(收费员ID^纸质票据代码^起始纸质票据号^终止纸质票据号^作废原因...)
	var UserID=PUBLIC_CONSTANT.SESSION.GUSER_ROWID;
	var GroupId=PUBLIC_CONSTANT.SESSION.GROUP_ROWID;
	var HosptalId=PUBLIC_CONSTANT.SESSION.HOSP_ROWID;
	var PaperCode=$('#IBBCode').val();				//纸质票据代码
	var StPaperNo=$('#IBBNo').val();				//纸质票据号码
	var EndPaperNo=$('#OIBBNo').val();				//当前纸质票据号
	var endInvNo=""                                 //结束发票号
	var title=""
    var admReason=""                                // 费别ID
    //var receiptType=""                               //收费类型
    var Hospital=HosptalId                                  //院区
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
				 $("#CancleNum").val("");				//纸质票据号码
			     $("#CancleReason").val("");			//当前纸质票号码
				 $("#OIBBNo").val("");			        //结束纸质号码
				 $("#DIBBCode").val("");			    //纸质票据代码
	         	 GetStockBillNo("");
	         	 alert("作废成功!");
			}else{
				alert("作废失败!");
			}
      window.close();
	});
	
}

function Cancel_click(){
	window.close();
}

///控制文本框只读
function setItemReadOnly(){
	$('#CancleNum').focus();
	$("#IBBNo").attr("readOnly", true);				//纸质票据号码
	$("#DIBBCode").attr("readOnly", true);			//当前纸质票号码
	$("#OIBBNo").attr("readOnly", true);			//结束纸质号码
	$("#IBBCode").attr("readOnly", true);			//纸质票据代码
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
	var index = DIBBCode.search(/\d/);      //+2018-02-12 ZhYW 取第一个数字在字符串中所在的位置
	var snost = DIBBCode.substring(0, index);
	var snoend = DIBBCode.substring(index);
	//alert("index="+index+"|snost="+snost+"|snoend="+snoend);
	if (checkno(num) && (DIBBCode != "") && checkno(snoend)) {
		ssno1 = parseInt(snoend, 10) + parseInt(num, 10) - 1;
		if(ssno1>endInvNoNum){
			$('#OIBBNo').val("");
			alert("超过了结束号码!");
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
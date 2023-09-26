/// DHCOPBillInvInsuList.js
///Lid
///2014-07-08

function BodyLoadHandler() {
	RefreshDoc();
	init_Layout();
}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	/*if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value
			}
		}
	}*/
	var rtn=DHCWeb_GetDatagridInfo('#tDHCOPBillInvInsuList',Row,ColName);
	return rtn;
}
function BulidPLStr(){
	var myRLStr="";
	var myRows=$HUI.datagrid('#tDHCOPBillInvInsuList').getRows().length;//DHCWeb_GetTBRows("tDHCOPBillInvInsuList");
	for (var i=0;i<myRows;i++){		
		var mySelFlag=$("input[type='checkbox']")[i].checked
		if (mySelFlag){
			var myRLRowID=GetColumnData("PLRowID",i);
			var myPrtRowID=GetColumnData("PrtRowID",i);
			var myFairType=GetColumnData("TFairType",i);
			var myAdmSource=GetColumnData("TAdmSource",i);
			var myInsTypeDR=GetColumnData("TInsTypeDR",i);
			var tmp=myRLRowID+"^"+myPrtRowID+"^"+myFairType+"^"+myInsTypeDR+"^"+myAdmSource;
			myRLStr+=tmp+"!"
		}
	}
	return 	myRLStr;
}
function SetSelFlagDis()
{
	var myRLStr="";
	var myRows=$HUI.datagrid('#tDHCOPBillInvInsuList').getRows().length
	for (var i=0;i<myRows;i++){
		var obj=document.getElementById("SelFlagz"+i);
		obj.disabled=true;
	}
}

function SelectRowHandler(index,rowData) {
	RefreshDoc();
}
function RefreshDoc(){
	var myRLStr = BulidPLStr();
	//alert(myRLStr)

}
function SelectAll(myCheck) {
	var myRows =$HUI.datagrid('#tDHCOPBillInvInsuList').getRows().length;
	var table=$HUI.datagrid('#tDHCOPBillInvInsuList').getRows();
	for (var i = 0; i < myRows; i++) {
		//alert(table[i].SelFlag)
		$("input[type='checkbox']")[i].checked=myCheck
		//if(myCheck) $HUI.datagrid('#tDHCOPBillInvInsuList').selectAll();
		//else $HUI.datagrid('#tDHCOPBillInvInsuList').unselectAll();
		//$HUI.datagrid('#tDHCOPBillInvInsuList').selectAll()
		//var obj = document.getElementById("SelFlagz" + i);
		///var mySelFlag=DHCWebD_GetCellValue(obj);
		//DHCWebD_SetListValueA(obj, myCheck);
	}
	//SelectRowHandler();

}

function init_Layout(){
	DHCWeb_ComponentLayout();
	$('#tDHCOPBillInvInsuList').datagrid({
		fitColumns:true,
		onLoadSuccess:function(data){
			$('.panel-body-noheader')[0].style.height = parseInt($('.panel-body-noheader')[0].style.height) + 1  + 'px';
			var o = $('#tDHCOPBillInvInsuList');
			if (data.rows && data.rows.length>0){
				for(var i=0; i<data.rows.length; i++){
					o.datagrid('beginEdit', i)}
			}
			$('.datagrid-sort-icon').text(''); // ����� ���ֺͽ���Ҷ���
			$("input[type='checkbox']").click(function(e){
				var rowIndex=this.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.rowIndex;	
				SelectRowHandler(rowIndex,"");
			})
		},
	})
}
function NoHideAlert(info){
	//alert(1)
	//
	$.messager.popover({
		msg:info,
		style:{
			right:'50%',
			top:'30%',
		}	
	});	
}

function BtnInvPrint_OnClick() {
	var mywin = parent.frames["DHCOPBillInvInsuPatInfo"].window;
	var BtnInvPrintobj = mywin.document.getElementById("BtnInvPrint");
	if (BtnInvPrintobj) {
		//disableById("BtnInvPrint");
		//DHCWeb_DisBtn(BtnInvPrintobj);
	}
	var myGuserDr = session['LOGON.USERID'];
	var myGroupDr = session['LOGON.GROUPID'];
	var myCTLocDr = session['LOGON.CTLOCID'];
	var myHospitalDr = session['LOGON.HOSPID'];
	//var mywin = parent.frames["DHCOPBillInvInsuList"].window;
	var myPLInfo = BulidPLStr();
	//listobj.NoHideAlert(myPLInfo);
	if (myPLInfo == "") {
		NoHideAlert("��ѡ��֧����¼��");
		return;
	}
	var invCount = myPLInfo.split("!").length;
	//ѭ����ӡ��Ʊ
	var UnYBPatTypeobj = mywin.document.getElementById('UnYBPatType');
	var UnYBPatType = UnYBPatTypeobj.checked;
	//listobj.NoHideAlert("������ӡ" + (invCount - 1) + "�ŷ�Ʊ");
	for (var i = 0; i < invCount - 1; i++) {
		var tmpInvAry = myPLInfo.split("!")[i].split("^");
		var plRowID = tmpInvAry[0];
		var prtRowID = tmpInvAry[1];
		var fairType = tmpInvAry[2];
		var insTypeDR = tmpInvAry[3];
		var admSource = tmpInvAry[4];
		var RegInsuFlag = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "CheckRegInsu", prtRowID);
      if (RegInsuFlag != "Y") {
         $.messager.confirm('��ʾ', "���νɷѵĹҺ���δҽ���ֽ�,�Ƿ��ӡ�Էѷ�Ʊ", function (BoolRtn) {
            if (!BoolRtn) {
               return;
            } else {
               //UnYBPatTypeobj.checked = true;
               UnYBPatType = true; //UnYBPatTypeobj.checked;
               var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
               var insuChargeFlag = InsuCharge.split("^")[0];  //�Ѿ��ֽ��С�������ϴ���Ʊ
               // ����ҽ���ӿ�
               if ((admSource > 0) && (RegInsuFlag == "Y") && (UnYBPatType == false) && (insuChargeFlag == "0")) {
                  //����ҽ���ӿ�
                  //�ҺŲ�����ҽ���ӿ�
                  //StrikeFlag^��ȫ��Dr^InsuNo^CardType^YLLB^DicCode^DYLB^�����^����ԱID^����ID^ҽԺID��Money^MoneyType��Money^MoneyType
                  var myYBHand = "";
                  var myCPPFlag = "A"; //�գ���ͨ�����շѣ�Y:���д�ӡ��Ʊ��A:֧�������д�ӡ��Ʊ
                  var LeftAmt = "";
                  var StrikeFlag = "N";
                  var GroupDR = myGroupDr;
                  var InsuNo = "";
                  var CardType = ""; //""document.getElementById('cardMode').value;
                  var YLLB = "";
                  var DicCode = ""; //document.getElementById('InsurDiagnos').value;
                  var PatAdmStat = "";
                  var DYLB = "";
                  var MoneyType = ""; //������
                  var YDFLAG = ""; //document.getElementById('YDFlg').value;
                  var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
                  //var myExpStrYB = StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^"+DYLB+"^"+"^^^^"+YDFLAG+"^"+LeftAmtStr
                  var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
                  var myYBINS = admSource;
                  var myCurrentInsType = insTypeDR;
                  //listobj.NoHideAlert("׼������ҽ��"+myYBHand+"=="+myCPPFlag+"=="+prtRowID+"=="+myYBExpStr+"=="+myYBINS+"=="+PatAdmStat)
                  var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myCPPFlag, prtRowID, myYBExpStr, myYBINS, PatAdmStat);
                  //var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand,myGuserDr, prtRowID, myYBINS,myCurrentInsType,myExpStrYB, myCPPFlag);
                  //listobj.NoHideAlert(myYBrtn)
                  var myYBarry = myYBrtn.split("^");
                  if (myYBarry[0] == "YBCancle") {
                     listobj.NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ��!��Ҫ���·ֽ�");
                     return;
                  }
                  if (myYBarry[0] == "HisCancleFailed") {
                     listobj.NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ��!��Ҫ���·ֽ�");
                     return;
                  }
               }
               //��ӡ��Ʊ
               var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
               var papmiDr = DHCWebD_GetObjValue("PAPMIRowID");
               var accMDr = DHCWebD_GetObjValue("PAPMIRowID");
               //var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
               //listobj.NoHideAlert(myrtn);
               if ((admSource == 0) || (UnYBPatType == true) || (admSource == "") || (admSource == "0")) {
                  //BillPrintNew(myrtn);
                  mywin.BillPrintNew("^" + prtRowID);
               }
               NoHideAlert("��ӡ���");
            }
            // ClearWin_Click();
         });
      } else { 
         var InsuCharge = tkMakeServerCall("web.DHCOPBillInvPrtInsu", "IsInsuCharge", prtRowID);
         var insuChargeFlag = InsuCharge.split("^")[0];  //�Ѿ��ֽ��С�������ϴ���Ʊ
          // ����ҽ���ӿ�
         if ((admSource > 0) && (RegInsuFlag == "Y") && (UnYBPatType == false) && (insuChargeFlag == "0")) {
            //����ҽ���ӿ�
            //�ҺŲ�����ҽ���ӿ�
            //StrikeFlag^��ȫ��Dr^InsuNo^CardType^YLLB^DicCode^DYLB^�����^����ԱID^����ID^ҽԺID��Money^MoneyType��Money^MoneyType
            var myYBHand = "";
            var myCPPFlag = "A"; //�գ���ͨ�����շѣ�Y:���д�ӡ��Ʊ��A:֧�������д�ӡ��Ʊ
            var LeftAmt = "";
            var StrikeFlag = "N";
            var GroupDR = myGroupDr;
            var InsuNo = "";
            var CardType = ""; //""document.getElementById('cardMode').value;
            var YLLB = "";
            var DicCode = ""; //document.getElementById('InsurDiagnos').value;
            var PatAdmStat = "";
            var DYLB = "";
            var MoneyType = ""; //������
            var YDFLAG = ""; //document.getElementById('YDFlg').value;
            var LeftAmtStr = LeftAmt + "^" + myGuserDr + "^" + myCTLocDr + "^" + myHospitalDr + "!" + LeftAmt + "^" + MoneyType;
            //var myExpStrYB = StrikeFlag+"^"+GroupDR+"^"+InsuNo+"^"+CardType+"^"+YLLB+"^"+DicCode+"^"+DYLB+"^"+"^^^^"+YDFLAG+"^"+LeftAmtStr
            var myYBExpStr = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + insTypeDR + "^" + myCTLocDr + "^" + myHospitalDr + "^" + myGuserDr;
            var myYBINS = admSource;
            var myCurrentInsType = insTypeDR;
            //listobj.NoHideAlert("׼������ҽ��"+myYBHand+"=="+myCPPFlag+"=="+prtRowID+"=="+myYBExpStr+"=="+myYBINS+"=="+PatAdmStat)
            var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, myCPPFlag, prtRowID, myYBExpStr, myYBINS, PatAdmStat);
            //var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand,myGuserDr, prtRowID, myYBINS,myCurrentInsType,myExpStrYB, myCPPFlag);
            //listobj.NoHideAlert(myYBrtn)
            var myYBarry = myYBrtn.split("^");
            if (myYBarry[0] == "YBCancle") {
               NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ��!��Ҫ���·ֽ�");
               return;
            }
            if (myYBarry[0] == "HisCancleFailed") {
               NoHideAlert("֧����¼��:" + prtRowID + ", ҽ���ֽ�ʧ��!��Ҫ���·ֽ�");
               return;
            }
         }
         //��ӡ��Ʊ
         var myExpStr = myCTLocDr + "^" + myGroupDr + "^" + myHospitalDr + "^^^";
         var papmiDr = DHCWebD_GetObjValue("PAPMIRowID");
         var accMDr = DHCWebD_GetObjValue("PAPMIRowID");
         //var myrtn = tkMakeServerCall("web.UDHCAccPrtPayFoot", "PrintAPInv", accMDr, papmiDr, prtRowID, myGuserDr, myExpStr);
         //listobj.NoHideAlert(myrtn);
         if ((admSource == 0) || (UnYBPatType == true) || (admSource == "") || (admSource == "0")) {
             //BillPrintNew(myrtn);
            mywin.BillPrintNew("^" + prtRowID);
         }
         listobj.NoHideAlert("��" + (i + 1) + "��ӡ���"); 
      }
	}
}
document.body.onload=BodyLoadHandler;
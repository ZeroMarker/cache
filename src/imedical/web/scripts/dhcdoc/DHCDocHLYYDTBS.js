/**!
* ����:   2016-04-03
* ����������ҩjs���°�ҽ��¼��ʹ�á�
* 
* V2.0
* Update 2018-11-01
* tanjishan
* ��װ������ҩϵͳ��������ֹ������Ⱦ;�����÷������Ա�ҽ��¼��Ͳ�ҩ¼��ͬʱ����
*/

// ͨ�õ�����ҩƷ֪ʶ��
function HLYYYDTS_Click(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//ѡ��һ��
		var ids=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow"); 			
		if(ids==null || ids.length==0 || ids.length > 1) {  
			$.messager.alert("����","��ѡ��һ��ҽ��");  
			return;  
		}
		var OrderARCIMRowid = GetCellData(ids[0], "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("����","��ѡ��һ��ҽ��");  
		return;  
	}
	PassFuncs.DTCSFuncs.DTYDTS(OrderARCIMRowid, 1);
}

///ͨ��ҩƷ�໥����
function XHZYClickHandler_HLYY(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.DTCSFuncs.DaTongXHZYHander();
	}else{
		PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
	}
}

///��鷽��
function HYLLUpdateClick_HLYY(callBackFun){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHander();
	}else{
		XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
	}
	HLYYCheckFlag =1 ;
	if (XHZYRetCode > 0){
		$.messager.confirm("ȷ�϶Ի���", t['DT_Question'], function (r) {
			callBackFun(r);
		});
	}else{
		callBackFun(true);
	}
	/*if (GlobalObj.HLYYLayOut=="OEOrd"){
		XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHander();
	}else{
		XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
	}
	HLYYCheckFlag =1 ;
	
	if (HLYYCheckFlag==1){
		if (XHZYRetCode > 0){
			var PrescCheck =dhcsys_confirm("������ҩ����о��棬��ȷ��ͨ����?", true);
			if (PrescCheck ==false) {
				return "-1"
			}
		}
		return 0;
	}else{
		return 100
	}*/
}


//���������װ��������Ļ���������һ����ʶ��
var McRecipeDataList="";
var PassFuncs={
	DTCSFuncs:{
		//��ͨ ˵����
		DTYDTS:function (Para, ShowType) {
		    var itemid=Para;
			//web.DHCDocHLYYDTBS.GetDTYDTS
			var myDTYDTSXML=cspRunServerMethod(GlobalObj.GetDTYDTS,itemid);
		  	if(GlobalObj.PAAdmType=="I")AdmType="ip";
			if(GlobalObj.PAAdmType!="I")AdmType="op";
			var myDTYDTS="<details_xml><hosp_flag>"+AdmType+"</hosp_flag>"+myDTYDTSXML+"</details_xml>"
			
		  	var result=this.dtywzxUI(5,GlobalObj.BaseInfo,myDTYDTS);
			return;
		},
		///ҽ��¼�������ҩ���
		DaTongXHZYHander:function () {
		    var Orders="";
			var Para1="";
			var myrtn=0;
			var rowids=$('#Order_DataGrid').getDataIDs();
			//alert(rowids.length)
			for(var i=0;i<rowids.length;i++){
				//���������
				var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
				var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
				if(OrderItemRowid != "" || OrderARCIMRowid == ""){continue;}

				var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
				var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
				var OrderType=GetCellData(rowids[i],"OrderType");
				var OrderDurRowid=GetCellData(rowids[i],"OrderDurRowid");
				var OrderFreqRowid=GetCellData(rowids[i],"OrderFreqRowid");
				var OrderInstrRowid=GetCellData(rowids[i],"OrderInstrRowid");
				var OrderDoseQty=GetCellData(rowids[i],"OrderDoseQty");
				var OrderDoseUOMRowid=GetCellData(rowids[i],"OrderDoseUOMRowid");
				var OrderDrugFormRowid=GetCellData(rowids[i],"OrderDrugFormRowid");
				var OrderPHPrescType=GetCellData(rowids[i],"OrderPHPrescType")
				var OrderStartDate=GetCellData(rowids[i],"OrderStartDate")
				var OrderStartTime=GetCellData(rowids[i],"OrderStartTime")
				var OrderPriorRowid=GetCellData(rowids[i],"OrderPriorRowid");
				//�����
		    	var MasterSeqNo="";
		    	var OrderSeqNo=GetCellData(rowids[i],"id");
		    	var OrderMasterSeqNo=GetCellData(rowids[i],"OrderMasterSeqNo");
		    	//if(OrderMasterSeqNo!="")MasterSeqNo=OrderMasterSeqNo;	
		    	if(OrderMasterSeqNo!=""){
			    	var OrderMasterSeqNoArr=OrderMasterSeqNo.split('.')	
			    	var MasterSeqNo=OrderMasterSeqNoArr[0];
			    	}	
			    else {
				    var MasterSeqNo=OrderSeqNo
				    }	
				//�ж��Ƿ����ҩ
				//if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

				Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
				Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime;
				if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
					if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
				}
			}
			if (Orders!=""){
				var EpisodeID=GlobalObj.EpisodeID;
				if (EpisodeID!=""){
					//var UploadFlag="0";	
					var DocCode=session['LOGON.USERCODE'];
					var UserID=session['LOGON.USERID'];
					//web.DHCDocHLYYDTBS.GetPrescXML
					var myPrescXML=cspRunServerMethod(GlobalObj.GetPrescXML,Orders,EpisodeID,DocCode,UserID,0);
					//alert("BaseInfo="+GlobalObj.BaseInfo);
					//alert("myPrescXML="+myPrescXML);
					myrtn=this.dtywzxUI(6,GlobalObj.BaseInfo,myPrescXML);	
				}
			}
			return myrtn;
		},
		///��ҩ�ݴ�ͨ������ҩ���
		DaTongXHZYHanderCM:function (){
			var Orders = "";
		    var Para1 = "";
		    var myrtn = 0;
		    var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
			var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
			var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			
			var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime",PageLogicObj.defaultDataCache, "1");
		    var CurrDateTimeArr = CurrDateTime.split("^");
		    var CurrDate = CurrDateTimeArr[0];
		    var CurrTime = CurrDateTimeArr[1];
			
		    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
				   if (OrderARCIMRowid!=""){
					    var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
						var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
						var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
						OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
						
						var OrderHiddenPara = $("#"+i+"_OrderHiddenPara"+j+"").val();
						var OrderDrugFormRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2);
						var PHCDoseUOMDesc = mPiece(OrderHiddenPara, String.fromCharCode(3), 9);
		                var PHCDoseUOMRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 10);
						var MasterSeqNo="";
						if (Orders!=""){
							var MasterSeqNo=1;
						}
						Para1 = OrderARCIMRowid + "!" + OrderDoseQty + "!" + PHCDoseUOMRowid;
				        Para1 = Para1 + "!" + PrescFrequenceRowid + "!" + PrescDurationRowid + "!" + PrescInstructionID + "!" + OrderDrugFormRowid + "!" + MasterSeqNo + "!" + OrderPriorRowid + "!" + CurrDate + "!" + CurrTime;
				        if (Orders == "") { Orders = Para1 } else { Orders = Orders + "^" + Para1 }
				   }
			    }
			}
		    var EpisodeID = GlobalObj.EpisodeID;
		    if (EpisodeID != "") {
		        //var UploadFlag="0";   
		        var DocCode = session['LOGON.USERCODE'];
		        var UserID = session['LOGON.USERID'];
		        //web.DHCDocHLYYDTBS.GetPrescXML 
		        var myPrescXML = cspRunServerMethod(GlobalObj.GetPrescXML, Orders, EpisodeID, DocCode, UserID,0);
		        //alert("BaseInfo="+GlobalObj.BaseInfo);
				//alert("myPrescXML="+myPrescXML);
				myrtn=this.dtywzxUI(6,GlobalObj.BaseInfo,myPrescXML);
		    }
		    return myrtn;
		},
		//��ͨ���ù�������
		dtywzxUI:function (nCode, lParam, sXML) {
		    var result="";
			if (DtObject){
				try {
					result = DtObject.CRMS_UI(nCode, lParam, sXML,"");
				}catch(e){
					$.messager.alert("����","���ô�ͨ������ҩ�ӿ�ʧ��;ʧ��λ��:DHCDocHLYYDTBS.js��PassFuncs.DTCSFuncs.dtywzxUI"); 
				}
			}
			return result;
		}
	}
}

///��ͨ�໥���ñ��浽��ͨ������
function DaTongXHZYSave(){
	if (GlobalObj.DTDepNotDoUpLoad==1) return 0; 
	var Orders="";
	var Para1="";
	var myrtn=0;
	var rowids=$('#Order_DataGrid').getDataIDs();
	for(var i=0;i<rowids.length;i++){
		//���������
		var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
		var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
		if(OrderItemRowid != "" || OrderARCIMRowid == ""){continue;}

		var OrderItemRowid=GetCellData(rowids[i],"OrderItemRowid");
		var OrderARCIMRowid=GetCellData(rowids[i],"OrderARCIMRowid");
		var OrderType=GetCellData(rowids[i],"OrderType");
		var OrderDurRowid=GetCellData(rowids[i],"OrderDurRowid");
		var OrderFreqRowid=GetCellData(rowids[i],"OrderFreqRowid");
		var OrderInstrRowid=GetCellData(rowids[i],"OrderInstrRowid");
		var OrderDoseQty=GetCellData(rowids[i],"OrderDoseQty");
		var OrderDoseUOMRowid=GetCellData(rowids[i],"OrderDoseUOMRowid");
		var OrderDrugFormRowid=GetCellData(rowids[i],"OrderDrugFormRowid");
		var OrderPHPrescType=GetCellData(rowids[i],"OrderPHPrescType")
		var OrderStartDate=GetCellData(rowids[i],"OrderStartDate")
		var OrderStartTime=GetCellData(rowids[i],"OrderStartTime")
		var OrderPriorRowid=GetCellData(rowids[i],"OrderPriorRowid");
		//�����
    	var MasterSeqNo="";
    	var OrderSeqNo=GetCellData(rowids[i],"id");
    	var OrderMasterSeqNo=GetCellData(rowids[i],"OrderMasterSeqNo");
    	//if(OrderMasterSeqNo!="")MasterSeqNo=OrderMasterSeqNo;
    	if(OrderMasterSeqNo!=""){
	    	var OrderMasterSeqNoArr=OrderMasterSeqNo.split('.')	
	    	var MasterSeqNo=OrderMasterSeqNoArr[0];
	    	}	
	    else {
		    var MasterSeqNo=OrderSeqNo
		    }		
		//�ж��Ƿ����ҩ
		//if ((OrderPHPrescType==3)&&(DTCheckCNMed!="1")){continue;} 

		Para1=OrderARCIMRowid+"!"+OrderDoseQty+"!"+OrderDoseUOMRowid;
		Para1=Para1+"!"+OrderFreqRowid+"!"+OrderDurRowid+"!"+OrderInstrRowid+"!"+OrderDrugFormRowid+"!"+MasterSeqNo+"!"+OrderPriorRowid+"!"+OrderStartDate+"!"+OrderStartTime;
		if ((OrderARCIMRowid!="")&&(OrderItemRowid=="")&&(OrderType=="R")){
			if (Orders==""){Orders=Para1}else{Orders=Orders+"^"+Para1}
		}
	}
	if (Orders!=""){
		//dhcsys_alert("Orders="+Orders);
		var EpisodeID=GlobalObj.EpisodeID;
		if ((EpisodeID!="")){	
			var DocCode=session['LOGON.USERCODE'];
			var UserID=session['LOGON.USERID'];
			var myPrescXML=cspRunServerMethod(GlobalObj.GetPrescXML,Orders,EpisodeID,DocCode,UserID,1);
			myrtn=dtywzxUI(6,GlobalObj.BaseInfo,myPrescXML);	
		}
	}
	return myrtn;
}




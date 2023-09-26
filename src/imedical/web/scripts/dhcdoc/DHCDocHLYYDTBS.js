/**!
* 日期:   2016-04-03
* 美康合理用药js【新版医嘱录入使用】
* 
* V2.0
* Update 2018-11-01
* tanjishan
* 封装合理用药系统方法，防止变量污染;修正该方法可以被医嘱录入和草药录入同时引用
*/

// 通用第三方药品知识库
function HLYYYDTS_Click(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		//选中一行
		var ids=$('#Order_DataGrid').jqGrid("getGridParam", "selarrrow"); 			
		if(ids==null || ids.length==0 || ids.length > 1) {  
			$.messager.alert("警告","请选择一条医嘱");  
			return;  
		}
		var OrderARCIMRowid = GetCellData(ids[0], "OrderARCIMRowid");
	}else{
		var OrderARCIMRowid=$("#"+FocusRowIndex+"_OrderARCIMID"+FocusGroupIndex+"").val();
	}
	if (typeof OrderARCIMRowid=="undefined" || OrderARCIMRowid==null || OrderARCIMRowid==""){
		$.messager.alert("警告","请选择一条医嘱");  
		return;  
	}
	PassFuncs.DTCSFuncs.DTYDTS(OrderARCIMRowid, 1);
}

///通用药品相互作用
function XHZYClickHandler_HLYY(){
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		PassFuncs.DTCSFuncs.DaTongXHZYHander();
	}else{
		PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
	}
}

///审查方法
function HYLLUpdateClick_HLYY(callBackFun){
	var XHZYRetCode =0,HLYYCheckFlag=0;
	if (GlobalObj.HLYYLayOut=="OEOrd"){
		XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHander();
	}else{
		XHZYRetCode =PassFuncs.DTCSFuncs.DaTongXHZYHanderCM();
	}
	HLYYCheckFlag =1 ;
	if (XHZYRetCode > 0){
		$.messager.confirm("确认对话框", t['DT_Question'], function (r) {
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
			var PrescCheck =dhcsys_confirm("合理用药检查有警告，你确认通过吗?", true);
			if (PrescCheck ==false) {
				return "-1"
			}
		}
		return 0;
	}else{
		return 100
	}*/
}


//这个变量封装到对象里的话，美康不一定能识别
var McRecipeDataList="";
var PassFuncs={
	DTCSFuncs:{
		//大通 说明书
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
		///医嘱录入合理用药审查
		DaTongXHZYHander:function () {
		    var Orders="";
			var Para1="";
			var myrtn=0;
			var rowids=$('#Order_DataGrid').getDataIDs();
			//alert(rowids.length)
			for(var i=0;i<rowids.length;i++){
				//过滤已审核
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
				//传组号
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
				//判断是否处理草药
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
		///中药草大通合理用药审查
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
		//大通调用公共方法
		dtywzxUI:function (nCode, lParam, sXML) {
		    var result="";
			if (DtObject){
				try {
					result = DtObject.CRMS_UI(nCode, lParam, sXML,"");
				}catch(e){
					$.messager.alert("警告","调用大通合理用药接口失败;失败位置:DHCDocHLYYDTBS.js下PassFuncs.DTCSFuncs.dtywzxUI"); 
				}
			}
			return result;
		}
	}
}

///大通相互作用保存到大通服务器
function DaTongXHZYSave(){
	if (GlobalObj.DTDepNotDoUpLoad==1) return 0; 
	var Orders="";
	var Para1="";
	var myrtn=0;
	var rowids=$('#Order_DataGrid').getDataIDs();
	for(var i=0;i<rowids.length;i++){
		//过滤已审核
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
		//传组号
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
		//判断是否处理草药
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




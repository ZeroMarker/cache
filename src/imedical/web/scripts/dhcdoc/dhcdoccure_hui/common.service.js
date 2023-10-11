/**
*Description:	iMedical 8.3及以上版本医嘱录入调用治疗站接口方法
*Creator:		nk
*CreadDate:		20200903
**/
var DHCDocCure_Service=(function(){
	//治疗项目判断  康复治疗控制
	function CheckDHCDocTreatItem(Row) {
	    try {
	        var OrderName = GetCellData(Row, "OrderName");
	        var OrderDoseQty = $.trim(GetCellData(Row, "OrderDoseQty"));
	        var OrderPackQty = $.trim(GetCellData(Row, "OrderPackQty"));
	        var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
	        var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
	        var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
			var OrderFreqRowID=GetCellData(Row,"OrderFreqRowid");
	        var CureItemFlag = CheckIsCureItem(OrderARCIMRowid, OrderRecDepRowid);
	        if ((CureItemFlag != "1")) return true;
	        if ((OrderPriorRowid != GlobalObj.LongOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid)) {
		        if (OrderPackQty == "") {
		            dhcsys_alert(OrderName + "为治疗项目,数量必须填写")
		            return false;
		        }else if ((!isInteger(OrderPackQty)) || (parseFloat(OrderPackQty) == 0)) {
				    if((OrderFreqRowID!="")&&(OrderFreqRowID!=GlobalObj.ONCEFreqRowid)&&(OrderFreqRowID!=GlobalObj.STFreqRowid)){
				        dhcsys_alert(OrderName + "为治疗项目,数量必须是正整数");
			            SetFocusCell(Row, "OrderPackQty");
			            return false;
			        }
			    }
		    }
	    } catch (e) {
	        return true;
	    }
	}
	
	function CheckCureItemConfig(rowid,CureItemConfigArg) {
		var OrderPackQtyStyleObj={};
		var OrderFreqStyle="";
		if (typeof CureItemConfigArg=="object"){
			var OrderPriorRowid=CureItemConfigArg.OrderPriorRowid;
			var OrderPriorRemarks = CureItemConfigArg.OrderPriorRemarks;
			var OrderFreqRowid = CureItemConfigArg.OrderFreqRowid;
			var OrderARCIMRowid = CureItemConfigArg.OrderARCIMRowid;
			var OrderRecDepRowid = CureItemConfigArg.OrderRecDepRowid;
			var OrderMasterARCIMRowid=CureItemConfigArg.OrderMasterARCIMRowid;
			var NotChangeCellFlag=CureItemConfigArg.NotChangeCellFlag;
			var NotResetPackQtyFlag=CureItemConfigArg.NotResetPackQtyFlag;
			var OrderPHPrescType=CureItemConfigArg.OrderPHPrescType;
			var OrderHiddenPara=CureItemConfigArg.OrderHiddenPara;
			var OrderVirtualtLong=(typeof CureItemConfigArg.OrderVirtualtLong!="undefined")?CureItemConfigArg.OrderVirtualtLong:"N";
			var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
			var OrderType=CureItemConfigArg.OrderType;
			var OrderCureItemFlag=CureItemConfigArg.OrderCureItemFlag;
			var IsNotChangeFirstDayTimeFlag=CureItemConfigArg.IsNotChangeFirstDayTimeFlag;
			var DCARowIDStr=CureItemConfigArg.DCARowIDStr;
			OrderFreqStyle=CureItemConfigArg.OrderFreqStyle;
			var CureItemConfigArg=null;
			var OrderNeedPIVAFlag="";
			var ContrlOrderPackQtArg={
				OrderPriorRowid:OrderPriorRowid,
				OrderPriorRemarks:OrderPriorRemarks,
				OrderARCIMRowid:OrderARCIMRowid,
				OrderFreqRowid:OrderFreqRowid,
				OrderRecDepRowid:OrderRecDepRowid,
				OrderMasterARCIMRowid:OrderMasterARCIMRowid,
				OrderVirtualtLong:OrderVirtualtLong
			};
		}else{
		    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
		    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
		    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
		    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
		    var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
		    var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
		    var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
			var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarks");
			var OrderType = GetCellData(rowid, "OrderType");
			var OrderNeedPIVAFlag = GetCellData(rowid, "OrderNeedPIVAFlag");
			var OrderVirtualtLong=GetCellData(rowid, "OrderVirtualtLong");
			var OrderMasterARCIMRowid="";
			var OrderMasterSeqNo = GetCellData(rowid, "OrderMasterSeqNo");
			var OrderCureItemFlag="",IsNotChangeFirstDayTimeFlag="";
			var DCARowIDStr = mPiece(OrderHiddenPara, String.fromCharCode(1), 20);
			if (OrderMasterSeqNo!=""){
				var rowids = GetAllRowId();
		        for (var i = 0; i < rowids.length; i++) {
					var OrderSeqNo = GetCellData(rowids[i], "id")
		            var OrderSeqNoMasterLink = GetCellData(rowids[i], "id");
		            if (OrderSeqNoMasterLink == OrderMasterSeqNo) {
		            	OrderMasterARCIMRowid=GetCellData(rowids[i], "OrderARCIMRowid");
		            	break;
		            }
		        }
			}
		    var NotChangeCellFlag="";
			var NotResetPackQtyFlag="";
			var ContrlOrderPackQtArg={
				OrderPriorRowid:OrderPriorRowid,
				OrderPriorRemarks:OrderPriorRemarks,
				OrderARCIMRowid:OrderARCIMRowid,
				OrderFreqRowid:OrderFreqRowid,
				OrderRecDepRowid:OrderRecDepRowid,
				OrderMasterARCIMRowid:OrderMasterARCIMRowid,
				OrderVirtualtLong:OrderVirtualtLong
			};
		}
	    //走治疗申请单的治疗项目控制总数量不可填写
	    if ((OrderRecDepRowid != "") && (OrderItemCatRowid != "") && (OrderARCIMRowid != "")) {
		    var DCARowID="",DCAAssScaleID="";
		    if(DCARowIDStr!=""){
			    var tDCARowIdStr=DCARowIDStr.split("&")[0];
				DCARowID=tDCARowIdStr.split("#")[0];
				DCAAssScaleID=tDCARowIdStr.split("#")[1];
				//DCARowIdStr:ChildDCA & MainDCA
				//ChildDCA ChildDCA#AssScaleID 包含当前(绑定关联的)医嘱的治疗申请ID(DCARowID)#治疗评定申请ID
				//MainDCA  MainDCA#AssScaleID  被关联的治疗申请ID(MainDCARowID,绑定的医嘱可能不会生成治疗申请)#治疗评定申请ID
			}
			if(DCARowID!=""){
				var CureItemFlag = "1";
			}else{
				if(OrderCureItemFlag!=""){
					var CureItemFlag = OrderCureItemFlag;
				}else{
	        		var CureItemFlag = CheckIsCureItem(rowid,OrderARCIMRowid,OrderRecDepRowid);
				}
			}
			if(DCAAssScaleID!=""){
				var OrderPackQtyStyleObj = { OrderPackQty: false, OrderPackUOM: false ,OrderDoseQty:false,OrderFreq:false,OrderDur:false,OrderFirstDayTimes:false}
			}else if (CureItemFlag == "1") {
		        var IdOrderFreq = rowid + "_" + "OrderFreq";
	            var objFreq = document.getElementById(IdOrderFreq);
		        if(((GlobalObj.PAAdmType != "I")||((GlobalObj.PAAdmType == "I")&&(IsLongPrior(OrderPriorRowid))))
		        &&((OrderPHPrescType=="4")||((objFreq) && (OrderFreqStyle)) || (OrderFreqRowid != "")))
		        {
		            var OrderPackQtyStyleObj = { OrderPackQty: false, OrderPackUOM: false ,OrderDoseQty:true}
		            SetPackQty(rowid,{
						IsNotChangeFirstDayTimeFlag:"Y"
					});
		        }
		        else if((GlobalObj.PAAdmType == "I")&&(!IsLongPrior(OrderPriorRowid))){
			        var OrderPackQtyStyleObj = { OrderPackQty: true, OrderPackUOM: true ,OrderDoseQty:false}
			    }
	        }else {
	            if(NotResetPackQtyFlag!="Y"){
		            var OrderPackQtyStyleObj = ContrlOrderPackQty(rowid, ContrlOrderPackQtArg);
		            //配液医嘱不可以录入整包装数量
		            if (OrderNeedPIVAFlag == "Y") {
		                OrderPackQtyStyleObj = { OrderPackQty: false, OrderPackUOM: false }
		            }
	            }
				$.extend(OrderPackQtyStyleObj, { OrderDoseQty: true });
				if (OrderType!="R"){
					$.extend(OrderPackQtyStyleObj, { OrderDoseQty: false });
					if (OrderPHPrescType=="4"){
						if (GlobalObj.PAAdmType!="I"){
							$.extend(OrderPackQtyStyleObj, { OrderDoseQty: true });
						}else if (IsLongPrior(OrderPriorRowid)){
							$.extend(OrderPackQtyStyleObj, { OrderDoseQty: true });
						}
					}
					if (OrderPackQtyStyleObj.OrderDoseQty==false){
						SetCellData(rowid, "OrderDoseQty", "");
					}
				}
				/*
				if (!IsLongPrior(OrderPriorRowid)&&(OrderType!="R")) {
		            SetCellData(rowid, "OrderDoseQty", "");
					$.extend(OrderPackQtyStyleObj, { OrderDoseQty: false });
		        }
				*/
	            
		        if (GlobalObj.PAAdmType!="I") {
				    var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarksRowId");
				    if ((OrderPriorRemarks=="OM")||(OrderPriorRemarks=="ZT")){
					    $.extend(OrderPackQtyStyleObj, { OrderPackQty: false });
					}
				}
	        }
	        if(NotChangeCellFlag!="Y"){
	        	ChangeRowStyle(rowid, OrderPackQtyStyleObj);
	        	ChangeCellDisable(rowid, OrderPackQtyStyleObj);
	        }
	    }
	    return OrderPackQtyStyleObj
	}
	
	function CheckIsCureItem(rowid,ARCIMRowid,RecDepRowid){
		if((ARCIMRowid=="")||(typeof(ARCIMRowid)=="undefined")){
			ARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
		}
		if((RecDepRowid=="")||(typeof(RecDepRowid)=="undefined")){
			RecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
		}
		var hospitalId = session['LOGON.HOSPID'];
		var CureItemFlag = $.cm({
			ClassName:"DHCDoc.DHCDocCure.Service",
			MethodName:"CheckItem",
			ItemMastId:ARCIMRowid,
			LocId:RecDepRowid,
			HospID:hospitalId,
			dataType:"text"
		},false)
		return CureItemFlag;
	}
	
	function DocCureTreeShow(){
		var wid='95%';
		var hit='99%';
	    var href = "doccure.applytree.hui.csp?EpisodeID=" + GlobalObj.EpisodeID+"&ParaType=OEOrdEntry"+"&EmConsultItm="+GlobalObj.EmConsultItm+"&PPRowId="+GlobalObj.PPRowId;
	 	websys_showModal({
			url:href,
			iconCls:"icon-w-paper",
			title:'治疗申请',
			width:wid,height:hit,
			AddCopyItemToList:AddCopyItemToList
		});
	}
	function CureApplyReport(argObj,CureNeedMatchAry,callBackFun) {
	    var UpdateOrderItemStr="",result="";
	    var LocID=session['LOGON.CTLOCID']; 
	    var DoctorID=session['LOGON.USERID'];//GetEntryDoctorId();
	    var HospID=session['LOGON.HOSPID'];
	    var OrderItemStr=argObj.OrderItemStr;
	    var EpisodeID=argObj.EpisodeID;
	    var PPRowId=argObj.PPRowId;
	    var CureJob=$.cm({
			ClassName:"DHCDoc.DHCDocCure.ApplyTree",
		    MethodName:"GetCureItemARCIMStr",
		    EpisodeID:EpisodeID,
		    OrderItemStr:OrderItemStr,
		    DoctorID:DoctorID,
		    LocID:LocID,
		    HospID:HospID,
		    dataType:"text"
		},false);
	    if (CureJob!=""){
		    new Promise(function(resolve,rejected){
			    //var ARCIMStr=encodeURI(ARCIMStrInfo);
		        if (CureJob!="") {
		            var href = "doccure.applytree.hui.csp?EpisodeID=" + EpisodeID+"&ParaType=OEOrdEntryUpdate&CureJob="+CureJob+"&PPRowId="+PPRowId; 
				 	websys_showModal({
						url:href,
						iconCls:"icon-w-paper",
						title:'治疗申请',
						width:'90%',height:'99%',
						closable:false,
						CallBackFunc:function(rtnStr){
							websys_showModal("close");
							if (typeof rtnStr=="undefined"){
								rtnStr="";
							}
							if (rtnStr=="") {
								$.messager.alert("提示","治疗未填写申请单,请再次点击【审核医嘱】申请或删除治疗医嘱.","info",function(){
									callBackFun("");
								});  
							}else{
								result=rtnStr;
								resolve();
							}
						}
					});
		        }else{
			        resolve();
			    }
		    }).then(function(){
			    if (result!="") {
				    var DCAAppendOrderItemStr="";
				    var resultAry=result.split(String.fromCharCode(3));
			        var DCARowIDStr=resultAry[0];
			        var DCAAppendOrderItemStr=resultAry[1];
			        if(DCARowIDStr!=""){
				        var DCARowIDArr=DCARowIDStr.split("@");
			            for (var i=0;i<DCARowIDArr.length;i++) {
			                var oneDCARowID=DCARowIDArr[i].split('^');
			                var DCARowID=oneDCARowID[0];
			                var OrderSeqNo=oneDCARowID[1];
			                CureNeedMatchAry[OrderSeqNo]=DCARowID;
			            }
			            var MaxOrderSeqNo="";
			            var OrderItemAry=OrderItemStr.split(String.fromCharCode(1));
			            for (var i=0;i<OrderItemAry.length;i++) {
			                var oneOrderItemAry=OrderItemAry[i].split('^');
			                var ArcimId=oneOrderItemAry[0];
			                var OrderSeqNo=oneOrderItemAry[19];
			                if (CureNeedMatchAry[OrderSeqNo]) {
			                    oneOrderItemAry[59]=CureNeedMatchAry[OrderSeqNo];
			                }
			                MaxOrderSeqNo=OrderSeqNo;
			                var oneOrderItemStr=oneOrderItemAry.join('^');
			                if (UpdateOrderItemStr=="") {UpdateOrderItemStr=oneOrderItemStr;}else{UpdateOrderItemStr=UpdateOrderItemStr+String.fromCharCode(1)+oneOrderItemStr}
			            }
			        }
		            if(DCAAppendOrderItemStr!=""){
			            // 循环治疗单绑定的医嘱串，更新各个医嘱串中序号字段，防止和医嘱录入页面其他医嘱序号相同
			            var NewDCAAppendOrderItemStr="";
			            var DCAAppendOrderItemArr=DCAAppendOrderItemStr.split(String.fromCharCode(1));
			            for (var i=0;i<DCAAppendOrderItemArr.length;i++) {
				            var oneDCAAppendOrderItemArr=DCAAppendOrderItemArr[i].split("^");
				            oneDCAAppendOrderItemArr[19]=parseInt(MaxOrderSeqNo)+i+1;
				            var oneDCAAppendOrderItemStr=oneDCAAppendOrderItemArr.join('^');
				            if (NewDCAAppendOrderItemStr=="") {NewDCAAppendOrderItemStr=oneDCAAppendOrderItemStr;}else{NewDCAAppendOrderItemStr=NewDCAAppendOrderItemStr+String.fromCharCode(1)+oneDCAAppendOrderItemStr}
				        }
			        	UpdateOrderItemStr=UpdateOrderItemStr+ String.fromCharCode(1) + NewDCAAppendOrderItemStr;
		            }
		            callBackFun(UpdateOrderItemStr);
				}else{
					callBackFun(OrderItemStr);
				}
			})
	    }else{
	        callBackFun(OrderItemStr);
	    }
	}
	
	
	return{
		"CheckDHCDocTreatItem":CheckDHCDocTreatItem,
		"CheckCureItemConfig":CheckCureItemConfig,
		"CheckIsCureItem":CheckIsCureItem,
		"DocCureTreeShow":DocCureTreeShow,
		"CureApplyReport":CureApplyReport
	}
})()
/**
*Description:	iMedical 8.3之前版本医嘱录入调用治疗站接口方法
*Creator:		nk
*CreadDate:		20200903
**/
var DHCDocCure_Service_V80=(function(){
	//治疗项目判断  康复治疗控制
	function CheckDHCDocTreatItem(Row) {
	    try {
	        var OrderName = GetCellData(Row, "OrderName");
	        var OrderDoseQty = $.trim(GetCellData(Row, "OrderDoseQty"));
	        var OrderPackQty = $.trim(GetCellData(Row, "OrderPackQty"));
	        var OrderPriorRowid = GetCellData(Row, "OrderPriorRowid");
	        var OrderARCIMRowid = GetCellData(Row, "OrderARCIMRowid");
	        var OrderRecDepRowid = GetCellData(Row, "OrderRecDepRowid");
			var OrderFreqRowID=GetCellData(Row,"OrderFreqRowid");
	        var CureItemFlag = CheckIsCureItem(OrderARCIMRowid, OrderRecDepRowid);
	        if ((CureItemFlag != "1")) return true;
	        if ((OrderPriorRowid != GlobalObj.LongOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid)) {
		        if (OrderPackQty == "") {
		            dhcsys_alert(OrderName + "为治疗项目,数量必须填写")
		            return false;
		        }else if ((!isInteger(OrderPackQty)) || (parseFloat(OrderPackQty) == 0)) {
				    if((OrderFreqRowID!="")&&(OrderFreqRowID!=GlobalObj.ONCEFreqRowid)&&(OrderFreqRowID!=GlobalObj.STFreqRowid)){
				        dhcsys_alert(OrderName + "为治疗项目,数量必须是正整数");
			            SetFocusCell(Row, "OrderPackQty");
			            return false;
			        }
			    }
		    }
	    } catch (e) {
	        return true;
	    }
	}
	
	function CheckCureItemConfig(rowid) {
	    var OrderHiddenPara = GetCellData(rowid, "OrderHiddenPara");
	    var OrderItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(1), 2);
	    var OrderARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
	    var OrderRecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
	    var OrderPHPrescType = GetCellData(rowid, "OrderPHPrescType");
	    var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
	    //走治疗申请单的治疗项目控制总数量不可填写
	    if ((OrderRecDepRowid != "") && (OrderItemCatRowid != "") && (OrderARCIMRowid != "")) {
	        var CurRowOrderPriorRowid=GetCellData(rowid, "OrderPriorRowid");
	        var CureItemFlag = CheckIsCureItem(OrderARCIMRowid, OrderRecDepRowid);
	        if (CureItemFlag == "1") {
		        var IdOrderFreq = rowid + "_" + "OrderFreq";
	            var objFreq = document.getElementById(IdOrderFreq);
		        if((GlobalObj.PAAdmType != "I")&&
		        ((OrderPHPrescType=="4")||((objFreq) && (!objFreq.disabled)) || (OrderFreqRowid != ""))
		        ){
		            var OrderPackQtyStyleObj = { OrderPackQty: false, OrderPackUOM: false }
		            SetPackQty(rowid);
		        }
	        } else {
	            var OrderPriorRowid = GetCellData(rowid, "OrderPriorRowid");
	            var OrderPriorRemarks = GetCellData(rowid, "OrderPriorRemarks");
	            var OrderType = GetCellData(rowid, "OrderType");
	            var OrderFreqRowid = GetCellData(rowid, "OrderFreqRowid");
	            var OrderPackQtyStyleObj = ContrlOrderPackQty(rowid, OrderPriorRowid, OrderPriorRemarks, OrderType, OrderFreqRowid);
	            //配液医嘱不可以录入整包装数量
	            var OrderNeedPIVAFlag = GetCellData(rowid, "OrderNeedPIVAFlag");
	            if (OrderNeedPIVAFlag == "Y") {
	                var OrderPackQtyStyleObj = { OrderPackQty: false, OrderPackUOM: false }
	            }
	        }
	        ChangeCellDisable(rowid, OrderPackQtyStyleObj);
	    }
	}
	
	function CheckIsCureItem(rowid,ARCIMRowid,RecDepRowid){
		if((ARCIMRowid=="")||(typeof(ARCIMRowid)=="undefined")){
			ARCIMRowid = GetCellData(rowid, "OrderARCIMRowid");
		}
		if((RecDepRowid=="")||(typeof(RecDepRowid)=="undefined")){
			RecDepRowid = GetCellData(rowid, "OrderRecDepRowid");
		}
		var hospitalId = session['LOGON.HOSPID'];
		var CureItemFlag = tkMakeServerCall("DHCDoc.DHCDocCure.Apply", "CheckItem", ARCIMRowid, RecDepRowid);
		return CureItemFlag;
	}
	
	
	return{
		"CheckDHCDocTreatItem":CheckDHCDocTreatItem,
		"CheckCureItemConfig":CheckCureItemConfig,
		"CheckIsCureItem":CheckIsCureItem
	}
})()

/**
*Description:	iMedical 8.3及以上版本信息总览调用治疗站接口方法
*Creator:		nk
*CreadDate:		20200903
**/
var DHCDocCure_InpatTreat_Service=(function(){
	function ShowCureDetail(Type,RowID){
		if(Type=="Record"){
			ShowCureRecordDetail(RowID);
			return;
		}else if(Type=="Ass"){
			ShowCureAssListDetail(RowID);
			return;
		}else{
			var title="治疗方案";	
		}
		var content=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetCurePlanAndAss",
			Type:Type,
			DCARowId:RowID,
			dataType:"text"
		},false)
		if(content==""){
			content="暂无内容";
		}else{
			content=content.replace(/\\n/g,"<br/>");
			content=content.replace(/\\r/g,"<br/>");
		}
		var dhwid=($(document.body).width()-800)/2;
		var dhhei=($(document.body).height()-500)/2;
		content="<div style='height:100%;width:100%;padding:10px'><div class='hisui-panel panel-header-gray' data-options='border:true,fit:true'>"+content+"</div></div>";
		
		websys_showModal({
			content:content,
			title:$g(title),
			iconCls:'icon-w-paper',
			width:'60%',height:'60%'
		});
		/*
		$("#cure-detail-panel").append(content)
		$('#cure-detail-dialog').window({
			isTopZindex:true,
			iconCls:'icon-w-paper',
			title:title,
			onClose:function(){$("#cure-detail-panel").empty()}
		})
		$('#cure-detail-dialog').window('open').window('resize',{width:800,height:500,top: dhhei,left:dhwid});
		*/
	}
	
	
	function ShowCureAssListDetail(id){
		var OperateType="";
		var href="doccure.cureassessmentlist.csp?OperateType="+OperateType+"&DCARowIdStr="+id+"&PageShowFromWay="+ServerObj.PageShowFromWay;
	    websys_showModal({
			url:href,
			title:$g('治疗评估'),
			iconCls:'icon-w-list',
			width:'90%',height:'80%'
		});
	}

	function ShowCureRecordDetail(id){
		var href="doccure.workreport.execview.hui.csp?OperateType=&DCARowId="+id+"&PageShowFromWay="+ServerObj.PageShowFromWay;
	    websys_showModal({
			url:href,
			title:$g('治疗记录明细'),
			iconCls:'icon-w-list',
			width:'90%',height:'80%'
		});
	}
	
	return {
		"ShowCureDetail":ShowCureDetail	
	}
})()
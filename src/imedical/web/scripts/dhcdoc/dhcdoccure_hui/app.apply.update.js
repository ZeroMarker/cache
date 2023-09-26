var PageApplyUpdateObj={
	PrintData:"",
	UserID:session['LOGON.USERID'],
	GroupID:session['LOGON.GROUPID'],
	CTLocID:session['LOGON.CTLOCID'],
	HospID:session['LOGON.HOSPID'],
	CureAppendItemListDataGrid:""
}
var dw=$(window).width(),dh=$(window).height();
$(window).load(function(){
	InitInfo();
})
$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
});

function Init(){
	InitItem();
	PageApplyUpdateObj.CureAppendItemListDataGrid=InitCureAppendItemList();
}

function InitEvent(){
	$('#btnSave').click(SaveCureApply);
	$('#btnPrint').click(btnPrint); 
	if(ServerObj.DCARowId!=""){
		$('#btnCancel').bind("click",function(){
			CancelApply(ServerObj.DCARowId);	
		}); 
	}
	document.onkeydown = Page_OnKeyDown;
}

function SetPrice(){
	if(ServerObj.DCARowId!="")return;
	$('#OrderPrice').val("");
	var ItemRowID=$('#ItemRowid').val();
	if(ItemRowID==""){
		return;	
	}
	var OrderQty=$('#OrderQty').val();
	if(OrderQty==""){
		return;		
	}
	var OrderQty=parseFloat(OrderQty);
	var BillingUOM=$("#BillingUOM").combobox('getValue');
	var BillingUOMDr=CheckComboxSelData("BillingUOM",BillingUOM);
	if(BillingUOMDr==""){
		return;	
	}
	var OrderReLoc=$("#OrderReLoc").combobox('getValue');
	var OrderReLocDr=CheckComboxSelData("OrderReLoc",OrderReLoc);
	if (OrderReLocDr==""){
		//return;	
	}
	var OrderBillType=$("#OrderBillType").combobox('getValue');
	var OrderBillTypeDr=CheckComboxSelData("OrderBillType",OrderBillType);
	if(OrderBillTypeDr==""){
		//return;	
	}
	//ArcimRowid, OrderRecDepRowid, OrderPackUOMRowid, OrdRowID)
	if (ServerObj.GetPriceMethod != "") {
        //var ret = cspRunServerMethod(ServerObj.GetPriceMethod, ServerObj.EpisodeID, ItemRowID, OrderReLocDr,BillingUOMDr,"");
        var ret=$.cm({
	    	ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetPrice",
			dataType:"text",
			'EpisodeID':ServerObj.EpisodeID,
			'ArcimRowid':ItemRowID, 
			'OrderRecDepRowid':OrderReLocDr, 
			'OrderPackUOMRowid':BillingUOMDr, 
			'OrdRowID':"",    
	    },false)
	    //alert(OrderQty+","+ret)
        var sum=OrderQty*parseFloat(ret)
        $('#OrderPrice').val(sum);
	}
}

function PageHandle(){
	if(ServerObj.DCARowId==""){
		$('#btnCancel').linkbutton("disable");
		
		var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
		var ObjScope=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"CheckAfterInit",
			'EpisodeID':ServerObj.EpisodeID,
			'ExpStr':ExpStr,
		},false);
		var value=ObjScope.result;
		if((typeof(value)!='undefined')&&(value!="0")){
			$("#warning").prop("innerText","提示信息:"+value);
			$('#btnSave').linkbutton("disable");
			$('#btnPrint').linkbutton("disable");
			$('#btnSave').unbind();
			$('#btnPrint').unbind();
		}
	}else{
		$("#warning_panel").remove();
		$('#apply_form_region').layout('panel', 'north').panel('resize',{
			height:63
		})	
	}
	var PanelWidth = $("#apply_form_panel").innerWidth();
	var ItemWidth=PanelWidth*0.85;
	$(".form-table textarea").width(ItemWidth)
	$("#apply_append_panel").panel('resize',{height: 255});	
	$('#apply_form_region').layout('panel', 'south').panel('resize',{
		height:dh-450
	})
	$('#apply_form_region').layout("resize");
	$("#ChronicDiag,#label_ChronicDiag").hide();
}

function InitInfo(){
	var DCARowId=ServerObj.DCARowId;
	var EpisodeID=ServerObj.EpisodeID;
	if(DCARowId!=""){
		initCureApplyInfo(DCARowId,"");
	}else{
		if(EpisodeID!=""){
			initCureApplyInfo("",EpisodeID)	
		}
		
	}	
}

function CancelApply(DCARowId){
	if(DCARowId!=""){
		$.messager.confirm('撤销',"确认要撤销该申请单吗",function(r){
			if (r){
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Apply",
					MethodName:"CancelCureApply",
					'DCARowId':DCARowId,
					'UserID':session['LOGON.USERID'],
				},function testget(value){
					if(value == "0"){
						$.messager.show({title:"提示",msg:"撤销成功"});
						//window.returnValue = true;
						websys_showModal('hide');
						websys_showModal('options').CureApplyDataGridLoad();
						websys_showModal("close");
					}else{
						if(value=="100")value="已经有预约记录或者治疗记录,不允许撤销";
						else if(value=="101")value="该治疗申请已经完成,不允许撤销";
						else if(value=="102")value="该治疗申请存在已治疗的记录,不允许撤销"
						else if(value=="103")value="该治疗申请已撤销,不允许撤销"
						else if(value=="104")value="该治疗申请已分配,不允许撤销"
						$.messager.alert("提示","撤销失败,"+value);
						return false;
					}				
					
				});
			}
		})
	}else{
		$.messager.alert("提示","申请单信息获取错误");
		return false;
	}
			
}
function initCureApplyInfo(DCARowId,EpisodeID){
	PageApplyUpdateObj.PrintData="";
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		MethodName:"GetPatientBaseInfo",
		'DCARowId':DCARowId,
		'adm':EpisodeID,
	},function testget(value){
		if (value!=""){
			DisplayPatInfo(value);
		}
	});
	if(DCARowId!=""){
		var CureInfo=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetCureApply",
			dataType:"text",
			'DCARowId':DCARowId,
		},false);
		if(CureInfo != ""){
			PageApplyUpdateObj.PrintData=CureInfo;
			var CureApplyArr="",CureApplyArr="";
			var TempArr=CureInfo.split(String.fromCharCode(1));
			DisableAllElement();
			DisplayCureInfo(TempArr[1],TempArr[2]);
			LoadCureAppendItemListData(DCARowId);
		}
	}
}

function DisplayCureInfo(val,oval){
	var CureApplyArr=val.split("^");
	var CureApplyOtherArr=oval.split("^")
	var ArcimDesc="",OrderQty="",BillingUOM="",OrderReLoc="",ApplyStatus="",ApplyUser="",ApplyDate="";
	var ApplyDate="",ApplyRemarks="",ApplyPlan="";
	var ApplyNo="";
	if(CureApplyArr!=""){
		var ArcimDesc=CureApplyArr[0];
		var OrderQty=CureApplyArr[2];
		var BillingUOM=CureApplyArr[3];
		var OrderReLoc=CureApplyArr[4];
		var ApplyStatus=CureApplyArr[6];
		var ApplyUser=CureApplyArr[7];
		var ApplyDate=CureApplyArr[8];
		var ApplyRemarks=CureApplyArr[13];
		var ApplyPlan=CureApplyArr[14];	
		var OrderBillType=CureApplyArr[26];	
		var OrderPrice=CureApplyArr[16];	
		var DDCISRowid=CureApplyArr[28];	
		var ItemCatDesc=CureApplyArr[29];		
		var ApplyNo=CureApplyArr[30];		
		$("#OrderArcimDesc").val(ArcimDesc);
		$("#OrderQty").val(OrderQty);
		$("#ApplyStatus").val(ApplyStatus);
		$("#ApplyUser").val(ApplyUser);
		$("#ApplyDate").val(ApplyDate);
		$("#ApplyRemark").val(ApplyRemarks);
		$("#ApplyPlan").val(ApplyPlan);
		$("#OrderPrice").val(OrderPrice);
		$("#CureApplyNo").val(ApplyNo);
		$HUI.combobox("#OrderBillType").setValue(OrderBillType);
		$HUI.combobox("#BillingUOM").setValue(BillingUOM);
		$HUI.combobox("#OrderReLoc").setValue(OrderReLoc);
		CureItemPlanCombCreat(DDCISRowid);
	}
	if(CureApplyOtherArr!=""){
		//s ret=OrderDoseQty_"^"_OrderDoseUnitID_"^"_OrderDoseUnit_"^"_PriorityDR_"^"_PriorityDesc
		//s ret=ret_"^"_PHFreqDr_"^"_PHFreqDesc1_"^"_instrDr_"^"_instrDesc1
		var OrderDoseQty=CureApplyOtherArr[0];
		var OrderDoseUnitID=CureApplyOtherArr[1];
		var OrderDoseUnit=CureApplyOtherArr[2];
		var PriorityDR=CureApplyOtherArr[3];
		var PriorityDesc=CureApplyOtherArr[4];
		var PHFreqDr=CureApplyOtherArr[5];
		var PHFreqDesc1=CureApplyOtherArr[6];
		var instrDr=CureApplyOtherArr[7];
		var instrDesc1=CureApplyOtherArr[8];
		var DuratDR=CureApplyOtherArr[9];
		var DuratDesc=CureApplyOtherArr[10];
		var StDate=CureApplyOtherArr[11];
		var FirstDayTimes=CureApplyOtherArr[12];
		var EndDate=CureApplyOtherArr[13];
		var CoverMainInsFlag=CureApplyOtherArr[15];
		$("#OrderDoseQty").val(OrderDoseQty);
		$("#OrderStartDate").datetimebox("setValue",StDate);
		$("#OrderEndDate").datetimebox("setValue",EndDate);
		$("#OrderFirstDayTimes").val(FirstDayTimes);
		$HUI.combobox("#OrderPrior").setValue(PriorityDesc);
		$HUI.combobox("#OrderDoseUOM").setValue(OrderDoseUnit);
		$("#OrderFreq").lookup("setText",PHFreqDesc1);
		$("#OrderDur").lookup("setText",DuratDesc);
		$HUI.checkbox("#CureItemCoverMainIns").setValue(false);
		if(CoverMainInsFlag=="Y"){
			$HUI.checkbox("#CureItemCoverMainIns").setValue(true);
		}
	}
	
}

function DisableAllElement(){
	var StyleConfigObj = {
		OrderPrior:false,
		OrderReLoc:false,
		OrderBillType:false,
		OrderStartDate:false,
		OrderEndDate:false,
        OrderDur: false,
        OrderFreq: false,
        OrderQty: false,
        BillingUOM: false,
        OrderDoseQty: false,
        OrderDoseUOM: false,
        OrderFirstDayTimes: false,
        CureItemCoverMainIns: false
    }
	ChangeElementStyle(StyleConfigObj);	
}
function ChangeElementStyle(StyleConfigObj) {
    for (var key in StyleConfigObj) {
        var name = key;
        var value = StyleConfigObj[key];
        if (value == undefined) { continue; }
        
        var className=$("#"+name).attr("class")
		if(typeof className =="undefined"){
			continue;
		}
		if(className.indexOf("hisui-lookup")>=0){
	        if (value == false) {
		        $("#" + name).lookup('disable');
		    }else{
			    $("#" + name).lookup('enable');
			}
        }else if(className.indexOf("hisui-combobox")>=0){
	        if (value == false) {
		        $HUI.combobox("#"+name).disable();  
		    }else{
			    $HUI.combobox("#"+name).enable();
			}
	    }else if(className.indexOf("hisui-datetimebox")>=0){
	        if (value == false) {
		        $HUI.datetimebox("#"+name).disable();  
		    }else{
			    $HUI.datetimebox("#"+name).enable();
			}
	    }else if(className.indexOf("hisui-checkbox")>=0){
	        if (value == false) {
		        $HUI.checkbox("#"+name).disable();  
		    }else{
			    $HUI.checkbox("#"+name).enable();
			}
	    }else{
            if (value == false) {
                $("#" + name).attr('disabled', true);
            } else if (value == true) {
                $("#" + name).attr('disabled', false);
            }
        }
	}
}

function DisplayPatInfo(val){
	var PatInfoObj=eval("("+val+")");
	if(typeof(PatInfoObj.baseInfoName)=='undefined'){return}
	var PatNo=PatInfoObj.baseInfoRegNo;
	var PatName=PatInfoObj.baseInfoName;
	var PatSex=PatInfoObj.baseInfoSex;
	var PatAge=PatInfoObj.baseInfoAge;
	var PatType=PatInfoObj.baseInfoInsu;
	var patBed=PatInfoObj.baseInfoBedno;
	if(patBed=="")patBed="-";
	var PatTel="";
	var PatAddress="";
	var PatNoi=PatNo
	var InfoAdmDays=PatInfoObj.baseInfoAdmDays;
	var charge="￥"+PatInfoObj.baseInfoCharge;
	var Diagnosis=PatInfoObj.baseInfoDiag;
	var IconProfile=PatInfoObj.baseIconProfile;
	$("#patNo").prop("innerText",PatNoi);
	$("#patName").prop("innerText",PatName);
	$("#patSex").prop("innerText",PatSex);
	$("#patSeximg :last-child").remove();
	if(PatSex=="男"){
		var imghtml="<img src='../images/man.png' alt=''/>"
		$("#patSeximg").append(imghtml)
	}else if(PatSex=="女"){
		var imghtml="<img src='../images/woman.png' alt=''/>";
		$("#patSeximg").append(imghtml)
	}
	$("#patAge").prop("innerText",PatAge);
	$("#patType").prop("innerText",PatType);
	$("#patBed").prop("innerText",patBed);
	$("#charge").prop("innerText",charge);
	$("#Diagnosis").prop("innerText",Diagnosis);
	//$("#InfoAdmDays").prop("innerText",InfoAdmDays);
	//$("#patAddress").prop("innerText",PatAddress);
	//$("#IconProfile").prop("innerText",IconProfile);
	if(ServerObj.DCARowId==""){
		var trs = $("tr[class='ifhidden']"); 
		for(i = 0; i < trs.length; i++){ 
			trs[i].style.display = "none"; //这里获取的trs[i]是DOM对象而不是jQuery对象，因此不能直接使用hide()方法 
		}
	}
}
function SaveCureApply()
{
    var DCARowId=ServerObj.DCARowId;
	var EpisodeID=ServerObj.EpisodeID;
	var ApplyPlan=$("#ApplyPlan").val();
	if (ApplyPlan==""){
		//$.messager.alert("提示","治疗方案不能为空");
		//return;
	}
	var ApplyRemark=$("#ApplyRemark").val();
	if((DCARowId!="")&&(DCARowId!=undefined)){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"SaveCureApply",
			'DCARowId':DCARowId,
			'ApplyPlan':ApplyPlan,
			'ApplyRemark':ApplyRemark,
			'UserID':session['LOGON.USERID'],
		},function testget(value){
			if(value==0){
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				InitInfo();
			}else{
				$.messager.alert('提示','保存失败,错误代码:'+value);
			}	
		})
	}else{
		$.messager.alert('提示','获取治疗申请ID失败',"info");
	}
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="ArcimDesc"){
			var CombValue=Data[i].ArcimRowID;
		 	var CombDesc=Data[i].ArcimDesc;
	     }else{
		    var CombValue=Data[i].CombValue  
		 	var CombDesc=Data[i].CombDesc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}

function InitItem(){
	$("#OrderFreq").lookup({});
	$("#OrderDur").lookup({});
	ItemBillUOMCombCreat("") //整包装单位		
	DHCDocOrderRecLocCombCreat("","",0);
	DHCDocOrderBillTypeCombCreat();
	CureItemPlanCombCreat("");
}

function Clear_Mes(){
	$HUI.combobox("#OrderReLoc").setValue("");
	$HUI.combobox("#BillingUOM").setValue("");
	$HUI.combobox("#CureItemPlan").setValue("");
	$('#ItemRowid').val("");
	$HUI.numberbox("#OrderQty").setValue("")
	$HUI.combobox("#BillingUOM").setValue("")
	$HUI.combobox("#OrderReLoc").setValue("")
	//$HUI.combobox("#OrderBillType").setValue("")
	$('#ApplyPlan').val("");
	$('#ApplyRemark').val("");
	$("#OrderQty").attr("disabled",false);
	$('#OrderPrice').val("");
	$('#CureApplyNo').val("");
	$('#ArcimDesc').val("");
}

//接收科室
function DHCDocOrderRecLocCombCreat(ArcimID,DefaultOrdRecLoc,DefaultFlag){
	//ServerObj.EpisodeID
	//session['LOGON.CTLOCID']
	$HUI.combobox("#OrderReLoc",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=DHCDocOrderRecLoc"+"&Inpute1="+ArcimID+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3="+DefaultFlag+"&Inpute4="+ServerObj.EpisodeID+"&Inpute5="+session['LOGON.CTLOCID']+"&ResultSetType=array",
    	onChange:function(){
			//SetPrice();	
		},onLoadSuccess:function(data){
	    	var DefRecLoc="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefRecLoc = data[i].CombValue;
			    	break;
			    }
		    }
		    //若接收科室只有一个，则默认选择，否则必须手动选择
		    if((DefRecLoc=="")&&(data.length==1)){
				DefRecLoc=data[0].CombValue;    
			}
	    	if(DefRecLoc!=""){$HUI.combobox("#OrderReLoc").setValue(DefRecLoc);}
	    }
	})
}

//费别
function DHCDocOrderBillTypeCombCreat(){
	$HUI.combobox("#OrderBillType",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=OrderBillType"+"&Inpute1="+ServerObj.EpisodeID+"&Inpute2="+""+"&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	var DefBillType="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefBillType = data[i].CombValue;
			    }
		    }
		    if((DefBillType=="")&&(data.length==1)){
				DefBillType=data[0].CombValue;    
			}
	    	if(DefBillType!=""){$HUI.combobox("#OrderBillType").setValue(DefBillType);}
	    },onChange:function(){
			//SetPrice();	
		}
	})
}

function CureItemPlanCombCreat(DDCISRowid){
	$HUI.combobox("#CureItemPlan",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=CureItemPlan&Inpute1="+DDCISRowid+"&Inpute2="+""+"&Inpute3=&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	$HUI.combobox("#CureItemPlan").setValue("");
	    },onLoadError:function(data){
	    	alert(data)
	    },onSelect:function(record){
            var ID=record['CombValue'];
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"GetPlanDetailByID",
				dataType:"text",
				'DDCISPRowid':ID,
			},false);
			if(ret!=""){
				$("#ApplyPlan").val("");
				$("#ApplyPlan").val(ret);
			}
		}
	})
}

//整包装单位
function ItemBillUOMCombCreat(ArcimDr)
{
	var Edit=true
	var INPut="N"
	var ChoseType=""
	$HUI.combobox("#BillingUOM",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=ItemBillUOM&Inpute1="+INPut+"&Inpute2="+ArcimDr+"&Inpute3=&ResultSetType=array",
		onHidePanel:function(){
			 var SubDesc=$('#BillingUOM').combobox('getText')
			 if ((SubDesc!="")&&(SubDesc.indexOf("-")>0)){
				var SetDesc=SubDesc.split("-")[1]
				if (SetDesc==""){SetDesc=SubDesc}
				$('#BillingUOM').combobox('setText',SetDesc)	
			}
		},
		onChange:function(){
			//SetPrice();	
		},onLoadSuccess:function(data){
			var DefBillUOM="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefBillUOM = data[i].CombValue;
			    	break;
			    }
		    }
		    if((DefBillUOM=="")&&(data.length>0)){
				DefBillUOM=data[0].CombValue;    
			}
	    	if(DefBillUOM!=""){$HUI.combobox("#BillingUOM").setValue(DefBillUOM);}
		}
	})
}

function mPiece(s1, sep, n) {
    //Getting wanted piece, passing (string,separator,piece number)
    //First piece starts from 0
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
}

//Excel打印方法
function btnPrint()
{	
	var DCARowId=ServerObj.DCARowId; //$('#DCARowId').val()
	if (DCARowId==""){
		$.messager.alert("提示","请选择需要打印的申请单据")
		return false
	}
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureApplyNew");
	var RtnStr=PageApplyUpdateObj.PrintData;
	var RtnStrArry=RtnStr.split(String.fromCharCode(1));
	var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
	var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息
	var CureApplyOtherArr=RtnStrArry[2].split("^"); //预约单其他医嘱信息
	
	var PatID=PatientArr[0]
	var PatNo=PatientArr[1];
	var PatName=PatientArr[2];
	var PatSex=PatientArr[3];
	var PatAge=PatientArr[4];
	var PatType=PatientArr[6];
	var PatTel=PatientArr[24];
	var PatAddress=PatientArr[10];
	
	var ArcimDesc=CureApplyArr[0]
	var AppOrderQty=CureApplyArr[2]
	var AppOrderUom=CureApplyArr[3]
	AppOrderQty=AppOrderQty+AppOrderUom;
	var RelocID=CureApplyArr[5]
	var AppReloc=CureApplyArr[4]
	var ApplyStatus=CureApplyArr[6]
	var ApplyUser=CureApplyArr[7]
	var ApplyDate=CureApplyArr[8]
	var ApplyRemarks=CureApplyArr[13]
	var ApplyPlan=CureApplyArr[14]
	var AdmID=CureApplyArr[15]
	var Price=CureApplyArr[16]
	var UnitPrice=CureApplyArr[18]	
	var AppLoc=CureApplyArr[25]
	var DocCurNO=CureApplyArr[30];	
	var InsertDate=CureApplyArr[27];
	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
	var Title=Hospital+"治疗申请凭证";
	
	var OrderDoseQty=CureApplyOtherArr[0];
	var OrderDoseUnitID=CureApplyOtherArr[1];
	var OrderDoseUnit=CureApplyOtherArr[2];
	var PriorityDR=CureApplyOtherArr[3];
	var PriorityDesc=CureApplyOtherArr[4];
	var PHFreqDr=CureApplyOtherArr[5];
	var PHFreqDesc1=CureApplyOtherArr[6];
	var instrDr=CureApplyOtherArr[7];
	var instrDesc1=CureApplyOtherArr[8];
	var DuratDR=CureApplyOtherArr[9];
	var DuratDesc=CureApplyOtherArr[10];
	var StDate=CureApplyOtherArr[11];
	var FirstDayTimes=CureApplyOtherArr[12];
	var PDlime=String.fromCharCode(2);
    var MyPara="HospName"+PDlime+Title;
    	MyPara=MyPara+"^"+"PatName"+PDlime+PatName;
    	MyPara=MyPara+"^"+"PatSex"+PDlime+PatSex;
    	MyPara=MyPara+"^"+"PatPhone"+PDlime+PatTel;
    	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatNo;
    	MyPara=MyPara+"^"+"PatAdress"+PDlime+PatAddress;
    	MyPara=MyPara+"^"+"ApplyUser"+PDlime+ApplyUser;
    	MyPara=MyPara+"^"+"ApplyDept"+PDlime+AppReloc;
    	MyPara=MyPara+"^"+"OrderPrior"+PDlime+PriorityDesc;
    	MyPara=MyPara+"^"+"DoseQty"+PDlime+OrderDoseQty+OrderDoseUnit;
    	MyPara=MyPara+"^"+"Freq"+PDlime+PHFreqDesc1;
    	MyPara=MyPara+"^"+"Duration"+PDlime+DuratDesc;
    	MyPara=MyPara+"^"+"Qty"+PDlime+AppOrderQty;
    	MyPara=MyPara+"^"+"CureRecloc"+PDlime+AppReloc;
    	MyPara=MyPara+"^"+"SttDate"+PDlime+ApplyDate;
    	MyPara=MyPara+"^"+"CureItem"+PDlime+ArcimDesc;
    	MyPara=MyPara+"^"+"ApplyPlan"+PDlime+ApplyPlan;
    	MyPara=MyPara+"^"+"Notes"+PDlime+ApplyRemarks;
    	MyPara=MyPara+"^"+"DocCureNO"+PDlime+DocCurNO;
    DHC_PrintByLodop(getLodop(),MyPara,"","","");
	/*var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
	var Template=getpath+"DHCDocCureApplyPrt.xls";
	var xlApp,xlsheet,xlBook
 
	//左右边距
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;  //lgl+
    xlsheet.PageSetup.RightMargin=0;
 
	
	var xlsrow=2; //用来指定模板的开始行数位置
	var xlsCurcol=1;  //用来指定开始的列数位置
	
	
	var RtnStr=PageApplyUpdateObj.PrintData; //tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
	var RtnStrArry=RtnStr.split(String.fromCharCode(1));
	var PatientArr=RtnStrArry[0].split("^"); //患者基本信息
	var CureApplyArr=RtnStrArry[1].split("^"); //预约单信息
	var CureApplyOtherArr=RtnStrArry[2].split("^"); //预约单其他医嘱信息
	
	var PatID=PatientArr[0]
	var PatNo=PatientArr[1];
	var PatName=PatientArr[2];
	var PatSex=PatientArr[3];
	var PatAge=PatientArr[4];
	var PatType=PatientArr[6];
	var PatTel=PatientArr[24];
	var PatAddress=PatientArr[10];
	
	var ArcimDesc=CureApplyArr[0]
	var AppOrderQty=CureApplyArr[2]
	var AppOrderUom=CureApplyArr[3]
	AppOrderQty=AppOrderQty+AppOrderUom;
	var RelocID=CureApplyArr[5]
	var AppReloc=CureApplyArr[4]
	var ApplyStatus=CureApplyArr[6]
	var ApplyUser=CureApplyArr[7]
	var ApplyDate=CureApplyArr[8]
	var ApplyRemarks=CureApplyArr[13]
	var ApplyPlan=CureApplyArr[14]
	var AdmID=CureApplyArr[15]
	var Price=CureApplyArr[16]
	var UnitPrice=CureApplyArr[18]	
	var AppLoc=CureApplyArr[25]
	var DocCurNO=CureApplyArr[30];	
	var InsertDate=CureApplyArr[27];
	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
	var Title=Hospital+"治疗申请凭证";
	
	var OrderDoseQty=CureApplyOtherArr[0];
	var OrderDoseUnitID=CureApplyOtherArr[1];
	var OrderDoseUnit=CureApplyOtherArr[2];
	var PriorityDR=CureApplyOtherArr[3];
	var PriorityDesc=CureApplyOtherArr[4];
	var PHFreqDr=CureApplyOtherArr[5];
	var PHFreqDesc1=CureApplyOtherArr[6];
	var instrDr=CureApplyOtherArr[7];
	var instrDesc1=CureApplyOtherArr[8];
	var DuratDR=CureApplyOtherArr[9];
	var DuratDesc=CureApplyOtherArr[10];
	var StDate=CureApplyOtherArr[11];
	var FirstDayTimes=CureApplyOtherArr[12];
	
	xlsheet.cells(1,2)=Title;
	xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
	xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
	xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
	xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+6)=AppLoc
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyUser
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=PriorityDesc
	xlsheet.cells(xlsrow,xlsCurcol+4)=OrderDoseQty+""+OrderDoseUnit
	xlsheet.cells(xlsrow,xlsCurcol+6)=PHFreqDesc1
	xlsheet.cells(xlsrow,xlsCurcol+8)=DuratDesc
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=AppOrderQty
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
	xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyDate
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ArcimDesc
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyPlan
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyRemarks
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyUser
	xlsheet.cells(xlsrow,xlsCurcol+6)=InsertDate

	
    xlBook.PrintOut()
    xlBook.Close (savechanges=false);
    xlApp.Quit();
	xlApp=null;
	xlsheet=null;*/
}
//在excel表格中画线的方法。
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}
///xml打印方法-未具体实现,可整合到单据打印中
function PrintCureApply()
{
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureApply");
    if(PageApplyUpdateObj.PrintData=="")return;
    var TempArrApply=PageApplyUpdateObj.PrintData.split("^");
    var PatNo=TempArrApply[0];
    var PatName=TempArrApply[1];
    var PatSex=TempArrApply[2];
    var PatAge=TempArrApply[3];
    var PatType=TempArrApply[4];
    var PatTel=TempArrApply[5];
    var PatAddress=TempArrApply[6];
    var ArcimDesc=TempArrApply[7];
    var OrderQty=TempArrApply[8];
    var BillingUOM=TempArrApply[9];
    var OrderReLoc=TempArrApply[10];
    var ApplyUser=TempArrApply[11];
    var ApplyDate=TempArrApply[12];
    var ApplyRemarks=TempArrApply[13];
    var ApplyPlan=TempArrApply[14];
    var PDlime=String.fromCharCode(2);
    var MyPara="ArcimDesc"+PDlime+ArcimDesc
    var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo
    var MyPara=MyPara+"^"+"PatName"+PDlime+PatName
    var MyPara=MyPara+"^"+"PatSex"+PDlime+PatSex
    var MyPara=MyPara+"^"+"PatAge"+PDlime+PatAge
    var MyPara=MyPara+"^"+"PatType"+PDlime+PatType
    var MyPara=MyPara+"^"+"PatTel"+PDlime+PatTel
    var MyPara=MyPara+"^"+"PatAddress"+PDlime+PatAddress
    var MyPara=MyPara+"^"+"ArcimDesc"+PDlime+ArcimDesc
    var MyPara=MyPara+"^"+"OrderQty"+PDlime+OrderQty
    var MyPara=MyPara+"^"+"BillingUOM"+PDlime+BillingUOM
    var MyPara=MyPara+"^"+"OrderReLoc"+PDlime+OrderReLoc
    var MyPara=MyPara+"^"+"ApplyUser"+PDlime+ApplyUser
    var MyPara=MyPara+"^"+"ApplyDate"+PDlime+ApplyDate
    var MyPara=MyPara+"^"+"ApplyRemarks"+PDlime+ApplyRemarks
    var MyPara=MyPara+"^"+"ApplyPlan"+PDlime+ApplyPlan
    //alert(MyPara);
    var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
}


//初始化绑定医嘱列表
function InitCureAppendItemList(){
	var CureAppendItemListDataGrid=$('#CureAppendItemList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : false,
		checkOnSelect:true,
		fitColumns : true,
		autoRowHeight : false,
		nowrap: false,
		collapsible:false,
		url : '',
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"CureAppRowId",
		pageSize : 10,
		pageList : [10,20],
		columns :[[ 
				{field:'CureAppItemID',title:'',width:35,align:'left',hidden:true},   
				{field:'CureAppItemDesc',title:'绑定医嘱名称',width:150,align:'left'},   
				{field:'CureAppItemQty',title:'绑定数量',width:80,align:'left'},   
				{field:'CureAppItemRecLoc',title:'接收科室',width:100,align:'left'},
				{field:'CureAppItemRecLocID',title:'',width:100,align:'left',hidden:true,editor:{type:'text'}},
				{field:'Price',title:'单价',width:60,align:'left',hidden:true},
				{field:'TotalPrice',title:'价格',width:60,align:'left',editor:{type:'textReadonly'}},
				{field:'RecLocStr',title:'',width:100,align:'left',hidden:true},
				{field:'CureAppItemType',title:'',width:100,align:'left',hidden:true},
				{field:'baseuom',title:'',width:100,align:'left',hidden:true},
				{field:'Baseuomdesc',title:'',width:100,align:'left',hidden:true},
				{field:'CureAppRowId',title:'',width:100,align:'left',hidden:true}
			]]
	});
	return CureAppendItemListDataGrid;
}

function LoadCureAppendItemListData(Rowid){
	$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		QueryName:"FindCureItemAppendItem",
		DCARowId:Rowid,
		Episodeid:ServerObj.EpisodeID,
		Pagerows:PageApplyUpdateObj.CureAppendItemListDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageApplyUpdateObj.CureAppendItemListDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',GridData); 
	})
}

function Page_OnKeyDown(e){
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
   	var keyEvent;   
   	if(e.keyCode==8){   
       	var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}
}

function SetOrderFirstDayTimes(){}
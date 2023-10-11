var ItemzLookupGrid; //��������Grid��¼
var m_idoseqtystr="";
var m_ArcimClassification="";
var m_iorderSubCatID="";
var m_Itemcat="";
var SearchLimitType=""; //����ҽ������ϸ�޸�ʱ,ҽ����ֻ���޸�Ϊҽ����,ҽ����ֻ���滻Ϊҽ����
var PageLogicObj = {
	m_SameFreqDifferentDosesFlag:"N",
	m_PHPrescType:""
}
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
//ArcimClassification,iorderSubCatID,idoseqtystr
function BodyLoadHandler(){
	//��ʼ��
	Init();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
}
function Init(){
	IntItemDescLookUp();
	ComCreat();
	/*
	$('#ItemDesc').keydown(LookUpItem); //����ҽ������
	$('#imgItemDesc').click(LookUpItem); //����ҽ������
	*/
}
function InitEvent(){
	//����
	$('#Save').click(AddClickHandler);
	//�˳�  
	$('#Back').click(BackClickHandler); 
	//����
	$('#Clear').click(ClearClickHandler); 
	$('#ItemQty').keypress(ItemQtyKeyHandler); 
	document.onkeydown = Doc_OnKeyDown;
	var $inp = $('input:text'); 
	$inp.bind('keydown', function (e) { 
		var key = e.which; 
		if (key == 13) { 
			e.preventDefault(); 
			var nxtIdx = $inp.index(this) + 1; 
			if ($(":input:text:eq(" + nxtIdx + ")").css("display")=="none"){
				nxtIdx=nxtIdx+1;
			}
			$(":input:text:eq(" + nxtIdx + ")").focus(); 
		} 
	});
}
function PageHandle(){
	setTimeout(function(){
		SetARCOSItemMes(ARCOSItemRowid,ARCIMRowid) //�������������ʼ��֮��
	});
	if (CelerType=="Y"){
		$HUI.checkbox('#RemoveCeler').enable();
	}else{
		$HUI.checkbox('#RemoveCeler').disable();
	}
	$('input:text:first').focus(); 
}
function Doc_OnKeyDown(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	if ((SrcObj) && ((SrcObj.id=="OrderSpeedFlowRate")||(SrcObj.id=="ItemDoseQty")||(SrcObj.id=="ItemQty"))) {
		if (((keyCode >= 46) && (keyCode < 58))|| ((keyCode >= 96) && (keyCode < 106))|| (keyCode==8)|| (keyCode==37)|| (keyCode==39) || (keyCode==190) || (keyCode==110) || ((keyCode==189)&&(SrcObj.id=="OrderSpeedFlowRate"))) {
		}else{
			window.event.keyCode = 0;
            return websys_cancel();
		}
	}
}
function ItemQtyKeyHandler(e) {
	try { keycode = websys_getKey(e); } catch (e) { keycode = websys_getKey(); }
	if ((keycode == 8) || (keycode == 9) || (keycode == 46) || (keycode == 13) || ((keycode > 47) && (keycode < 58)) || ((keycode > 95) && (keycode < 106))) {
        if (keycode==46){
	       var OrderARCIMRowid=$("#ItemRowid").val();
	       if (OrderARCIMRowid!=""){
		       var SubCatID = cspRunServerMethod(GetARCItemSubCatID, '', '', OrderARCIMRowid);
		       var AllowEntryDecimalItemCatStr = "^" + AllowEntryDecimalItemCat + "^";
			   if ((AllowEntryDecimalItemCatStr.indexOf("^" + SubCatID + "^")) == -1) {
				   return websys_cancel();
			   }
		    } 
	    }
	}else {
        return websys_cancel();
    }
}
//����
function AddClickHandler()
{
	if(ARCOSRowid==""){
		$.messager.alert('��ʾ','ȱ��ҽ������Ϣ�������'); 
		return;
	}
	if (!CheckBeforeSave()) return;
	var ARCIMRowid=$("#ItemRowid").val();
	var ItemQty=$("#ItemQty").val();
	if (ItemQty!=""){
		ItemQty=ChangeNum(ItemQty);
	}
	var ItemBillUOMRowId=$("#ItemBillUOM").combobox('getValue')
	var ItemDoseQty=$("#ItemDoseQty").val();
	if (ItemDoseQty!=""){
		ItemDoseQty=ChangeNum(ItemDoseQty);
	}
	var ItmLinkDoctor=$("#ItmLinkDoctor").val(); //����
	if (ItmLinkDoctor!=""){
		if(isNaN(ItmLinkDoctor)||(parseFloat(ItmLinkDoctor)<1)){
			$.messager.alert('��ʾ','��������ȷ�Ĺ������','info',function(){
				$("#ItmLinkDoctor").select();
			}); 
			return;
		}
	}
	var ItemDoseUOMID=$("#ItemDoseUOM").combobox('getValue');
	var ItemFrequenceID=$("#ItemFrequence").combobox('getValue');
	var ItemDurationID=$("#ItemDuration").combobox('getValue');
	var ItemInstructionID=$("#ItemInstruction").combobox('getValue');
	var remark=$("#remark").combobox('getText');
	var DHCDocOrderTypeID=$("#DHCDocOrderType").combobox('getValue'); //ҽ������
	var sampleType=$("#sampleType").combobox('getValue'); //�걾
	//���տ���
	var DHCDocOrderRecLoc=$("#DHCDocOrderRecLoc").combobox('getValue');
	var DHCDocOrderStageID=$("#DHCDocOrderStage").combobox('getValue'); //ҽ���׶�	
	var OrderPriorRemarks=$("#OrderPriorRemarks").combobox('getValue');
	var MustEnter=$("#MustEnter").checkbox("getValue")?"Y":"N";
	//��Һ����
	var OrderSpeedFlowRate=$.trim($("#OrderSpeedFlowRate").val());
	//���ٵ�λ
	var OrderFlowRateUnit=$("#OrderFlowRateUnit").combobox('getValue');
	//��鲿λ
	var OrderBodyPartLabel=$("#OrderBodyPartLabel").val();
	var SkinTest=$("#SkinTest").checkbox("getValue")?"Y":"N";
	var SkinActionID=$("#SkinAction").combobox('getValue');
	var NotifyClinician=$("#NotifyClinician").checkbox("getValue")?"Y":"N";
	var RemoveCeler=$("#RemoveCeler").checkbox("getValue")?"Y":"N";
	var OrderFreqTimeDoseStr=$("#OrderFreqTimeDoseStr").val();
	if (OrderFreqTimeDoseStr!="") ItemDoseQty=""
	var OrderFreqDispTimeStr=$("#OrderFreqDispTimeStr").val();
	//tkMakeServerCall�����θ���Ϊ16��,�����Ժ���ܼ�������ά���ֶ�,��ƴ��ExpStr�ֶ�,��̨���
	var ExpStr="";
	ExpStr=DHCDocOrderStageID+"^"+MustEnter+"^"+ItemBillUOMRowId;
	ExpStr=ExpStr+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnit+"^"+OrderBodyPartLabel;
	ExpStr=ExpStr+"^"+SkinTest+"^"+SkinActionID+"^"+NotifyClinician+"^"+RemoveCeler+"^"+OrderFreqTimeDoseStr+"^"+OrderFreqDispTimeStr;
	//ͨ���Ƿ�����ҽ������ϸID�����ָ��º�����
	if (ARCOSItemRowid==""){
		var RtnARCOSItemRowid=$.cm({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"InsertItem",
			ARCOSRowid:ARCOSRowid, ARCIMRowid:ARCIMRowid, ItemQty:ItemQty, ItemDoseQty:ItemDoseQty, 
			ItemDoseUOMID:ItemDoseUOMID, ItemFrequenceID:ItemFrequenceID, ItemDurationID:ItemDurationID, ItemInstructionID:ItemInstructionID, 
			ItmLinkDoctor:ItmLinkDoctor, remark:remark, DHCDocOrderTypeID:DHCDocOrderTypeID, SampleId:sampleType,
			ARCOSItemNO:"", OrderPriorRemarksDR:OrderPriorRemarks, DHCDocOrderRecLoc:DHCDocOrderRecLoc, ExpStr:ExpStr,
			dataType:"text"
		 },false);
		//var RtnARCOSItemRowid=tkMakeServerCall("web.DHCARCOrdSets","InsertItem",ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,sampleType,"",OrderPriorRemarks,DHCDocOrderRecLoc,ExpStr)
		if (RtnARCOSItemRowid=='-1') {
			$.messager.alert('��ʾ','����ҽ����Ŀʧ��'); return false;
		}else{
			$.messager.popover({msg: '����ҽ����Ŀ�ɹ�!',type:'success'});
			ClearClickHandler();
			if ((ARCOSPrescType=="")||(ARCOSPrescType=="CNMedItem")) {
				ARCOSPrescType=tkMakeServerCall("web.UDHCFavItemNew","GetARCOSPrescType",ARCOSRowid,session['LOGON.HOSPID']);
				ARCOSPrescType=ARCOSPrescType.split("^")[0];
			}
			if (window.name=="ARCOrdIetmEdit"){
				Clear_Mes();
				try{
					window.opener.LoadUDHCARCOrderSetItemEditDataGrid()
				}catch(e){}
				BackClickHandler()
			}
			if ("function" === typeof window.parent.LoadUDHCARCOrderSetItemEditDataGrid){
				window.parent.LoadUDHCARCOrderSetItemEditDataGrid("Add");
				Clear_Mes();
				$("#ItemDesc").focus();
				//window.parent.destroyDialog("ARCOSEdit");
			}else if(websys_showModal('options')&&websys_showModal('options').LoadUDHCARCOrderSetItemEditDataGrid){
				websys_showModal('options').LoadUDHCARCOrderSetItemEditDataGrid("Add");
				Clear_Mes();
				$("#ItemDesc").focus();
			}
		}
	}else{
		var Err=$.cm({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"UpdateItem",
			ARCOSItemRowid:ARCOSItemRowid, ARCIMRowid:ARCIMRowid, ItemQty:ItemQty, 
			ItemDoseQty:ItemDoseQty, ItemDoseUOMID:ItemDoseUOMID, ItemFrequenceID:ItemFrequenceID,
			ItemDurationID:ItemDurationID, ItemInstructionID:ItemInstructionID, 
			ItmLinkDoctor:ItmLinkDoctor, remark:remark, DHCDocOrderTypeID:DHCDocOrderTypeID, SampleID:sampleType, 
			OrderPriorRemarksDR:OrderPriorRemarks, DHCDocOrderRecLoc:DHCDocOrderRecLoc, ExpStr:ExpStr,
			dataType:"text"
		 },false);
		//var Err=tkMakeServerCall("web.DHCARCOrdSets","UpdateItem",ARCOSItemRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,sampleType,OrderPriorRemarks,DHCDocOrderRecLoc,ExpStr)
		if (Err=='-1') {$.messager.alert('��ʾ','����ҽ����Ŀʧ��'); return false;	}
		else{
			$.messager.popover({msg: '���³ɹ�!',type:'success'});
			if (window.name=="ARCOrdIetmEdit"){
				try{
					window.opener.LoadUDHCARCOrderSetItemEditDataGrid()
				}catch(e){}
				BackClickHandler()
			}
			if ("function" === typeof window.parent.LoadUDHCARCOrderSetItemEditDataGrid){
				window.parent.LoadUDHCARCOrderSetItemEditDataGrid();
				//window.parent.destroyDialog("ARCOSEdit");
				window.parent.websys_showModal("close");
			}
		}
	}	
}

function CheckPriorAllow(OrderPriorRowid,OrderARCIMRowid,OrderName)
{
	var PriorCheckRet = tkMakeServerCall("web.DHCDocOrderCommon", "CheckPriorAllowRange","",OrderPriorRowid,OrderARCIMRowid);
    if (parseFloat(PriorCheckRet) >= 1) {
        if ((PriorCheckRet == 1) || (PriorCheckRet == 2)) {
            $.messager.alert("����", OrderName + "��Ժ��ҩ�����¸�����͹��Ʒ��࣡");
        } else if (PriorCheckRet == 3) {
            $.messager.alert("����", OrderName + "�������������ʱҽ��,���޸�");
        } else if (PriorCheckRet == 4) {
            $.messager.alert("����", OrderName + "�ǳ�Ժҽ��,ֻ�ܿ���ʱ!");
        } else if (PriorCheckRet == 5) {
            $.messager.alert("����", OrderName + ",���ܽ��÷�ҩƷҽ����Ϊ��Ժ��ҩҽ��.");
        }else if (PriorCheckRet == 6) {
            $.messager.alert("����", OrderName + ",���������֮��ͣ���г��ڵ�ҽ��,ֻ�ܿ���ʱ!");
        }else if (PriorCheckRet == 7) {
            $.messager.alert("����", OrderName + ",����Ŀ���ܿ���ʱ!");
        }else {
            $.messager.alert("����", OrderName + "��������ҽ�����ȼ�,���޸�");
        }
        return false;
    }
    return true;
}
function ReSetOrderPriorRowid(OrderPriorRowid, OrderPriorRemarks) {
    switch (OrderPriorRemarks) {
        case "PRN":
            OrderPriorRowid = PRNOrderPriorRowid;
            break;
        case "ONE":
            OrderPriorRowid = OneOrderPriorRowid;
            break;
        case "OM":
            /*if (OrderPriorRowid==ShortOrderPriorRowid) {
                OrderPriorRowid=OMOrderPriorRowid;
            }else{
                OrderPriorRowid=OMSOrderPriorRowid;
            }*/
            if (OrderPriorRowid != LongOrderPriorRowid) {
                OrderPriorRowid = OMOrderPriorRowid;
            } else {
                OrderPriorRowid = OMSOrderPriorRowid;
            }
            break;
        case "ZT":
            /*if (OrderPriorRowid==ShortOrderPriorRowid) {
                OrderPriorRowid=OMLSZTOrderPriorRowid;
            }else{
                OrderPriorRowid=OMCQZTOrderPriorRowid;
            }*/
            if (OrderPriorRowid != LongOrderPriorRowid) {
                OrderPriorRowid = OMLSZTOrderPriorRowid;
            } else {
                OrderPriorRowid = OMCQZTOrderPriorRowid;
            }
            break;
        case "OUT":
            OrderPriorRowid = OutOrderPriorRowid;
            break;
        default:
    }
    return OrderPriorRowid;
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 var CombValue=Data[i].CombValue
		 var CombDesc=Data[i].CombDesc
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}
//����ǰ��Ϣ��֤
function CheckBeforeSave() {
	var ARCIMRowid=$("#ItemRowid").val();
	if (ARCIMRowid=='') {
		$.messager.alert('��ʾ','ȱ��ҽ����Ϣ,��¼��ҽ�����ڱ���'); 
		return false;
	}
	if (ARCOSRowid=='') {
		$.messager.alert('��ʾ','ȱ��ҽ������Ϣ�������'); 
		return false;
	}
	var reg = /^(?!(0[0-9]{0,}$))[0-9]{1,}[.]{0,}[0-9]{0,}$/;
	var ItemDoseQty=$("#ItemDoseQty").val();
	if (ItemDoseQty.indexOf("-")>=0) ItemDoseQty="";
	if ((ItemDoseQty!="")&&(!reg.test(ItemDoseQty))) {
		$.messager.alert('��ʾ','��������Ч�ĵ��μ���!',"info",function(){
			$("#ItemDoseQty").focus();
		}); 
		return false;
	}
	var OldItemDoseUOMID=$("#ItemDoseUOM").combobox('getValue');
	if ($("#ItemDoseUOM").combobox('getText')=="") OldItemDoseUOMID="";
	var ItemDoseUOMID=CheckComboxSelData("ItemDoseUOM",OldItemDoseUOMID);
	if (((OldItemDoseUOMID!=undefined)&&(OldItemDoseUOMID!="")&&(ItemDoseUOMID==""))||(OldItemDoseUOMID==undefined)){
		$.messager.alert('��ʾ','��ѡ����ȷ�ļ�����λ!',"info",function(){
			$('#ItemDoseUOM').next('span').find('input').focus();
		}); 
		return false;
	}
	var ItemQty=$("#ItemQty").val();
	if ((ItemQty!="")&&(!reg.test(ItemQty))) {
		$.messager.alert('��ʾ','��������Ч������!',"info",function(){
			$("#ItemQty").focus();
		}); 
		return false;
	}
	var OldItemBillUOMRowId=$("#ItemBillUOM").combobox('getValue'); //������λ
	if ($("#ItemBillUOM").combobox('getText')=="") OldItemBillUOMRowId="";
	var ItemBillUOMRowId=CheckComboxSelData("ItemBillUOM",OldItemBillUOMRowId);
	if ((OldItemBillUOMRowId!=undefined)&&(OldItemBillUOMRowId!="")&&(ItemBillUOMRowId=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ������װ����!',"info",function(){
			$('#ItemBillUOM').next('span').find('input').focus();
		}); 
		return false;
	}
	
	var OldItemFrequenceID=$("#ItemFrequence").combobox('getValue');
	if ($("#ItemFrequence").combobox('getText')=="") OldItemFrequenceID="";
	var FreqRowid=CheckComboxSelData("ItemFrequence",OldItemFrequenceID);
	if (((OldItemFrequenceID!=undefined)&&(OldItemFrequenceID!="")&&(FreqRowid==""))||(OldItemFrequenceID==undefined)){
		$.messager.alert('��ʾ','��ѡ����ȷ��Ƶ��!',"info",function(){
			$('#ItemFrequence').next('span').find('input').focus();
		}); 
		return false;
	}
	var OldItemDurationID=$("#ItemDuration").combobox('getValue');
	if ($("#ItemDuration").combobox('getText')=="") OldItemDurationID="";
	var ItemDurationID=CheckComboxSelData("ItemDuration",OldItemDurationID);
	if (((OldItemDurationID!=undefined)&&(OldItemDurationID!="")&&(ItemDurationID==""))||(OldItemDurationID==undefined)){
		$.messager.alert('��ʾ','��ѡ����ȷ���Ƴ�!',"info",function(){
			$('#ItemDuration').next('span').find('input').focus();
		}); 
		return false;
	}
	var OldItemInstructionID=$("#ItemInstruction").combobox('getValue');
	if ($("#ItemInstruction").combobox('getText')=="") OldItemInstructionID="";
	var ItemInstructionID=CheckComboxSelData("ItemInstruction",OldItemInstructionID);
	if ((OldItemInstructionID!="")&&(ItemInstructionID=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ���÷�!',"info",function(){
			$('#ItemInstruction').next('span').find('input').focus();
		}); 
		return false;
	}
	var OldDHCDocOrderTypeID=$("#DHCDocOrderType").combobox('getValue'); //ҽ������
	if ($("#DHCDocOrderType").combobox('getText')=="") OldDHCDocOrderTypeID="";
	var DHCDocOrderTypeID=CheckComboxSelData("DHCDocOrderType",OldDHCDocOrderTypeID);
	if ((OldDHCDocOrderTypeID!="")&&(DHCDocOrderTypeID=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ��ҽ������',"info",function(){
			$('#DHCDocOrderType').next('span').find('input').focus();
		}); 
		return false;
	}
	var OldOrderPriorRemarks=$("#OrderPriorRemarks").combobox('getValue');
	if ($("#OrderPriorRemarks").combobox('getText')=="") OldOrderPriorRemarks="";
	var OrderPriorRemarks=CheckComboxSelData("OrderPriorRemarks",OldOrderPriorRemarks);
	if ((OldOrderPriorRemarks!="")&&(OrderPriorRemarks=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ�ĸ���˵��',"info",function(){
			$('#OrderPriorRemarks').next('span').find('input').focus();
		}); 
		return false;
	}
	
	var OldsampleType=$("#sampleType").combobox('getValue'); //�걾
	if ($("#sampleType").combobox('getText')=="") OldsampleType="";
	var sampleType=CheckComboxSelData("sampleType",OldsampleType);
	if ((OldsampleType!="")&&(sampleType=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ�ı걾!',"info",function(){
			$('#sampleType').next('span').find('input').focus();
		}); 
		return false;
	}
	//���տ���
	var OldDHCDocOrderRecLoc=$("#DHCDocOrderRecLoc").combobox('getValue');
	if ($("#DHCDocOrderRecLoc").combobox('getText')=="") OldDHCDocOrderRecLoc="";
	var DHCDocOrderRecLoc=CheckComboxSelData("DHCDocOrderRecLoc",OldDHCDocOrderRecLoc);
	if (((OldDHCDocOrderRecLoc==undefined)||(OldDHCDocOrderRecLoc!=""))&&(DHCDocOrderRecLoc=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ�Ľ��տ���!',"info",function(){
			$('#DHCDocOrderRecLoc').next('span').find('input').focus();
		}); 
		return false;
	}
	var OldDHCDocOrderStageID=$("#DHCDocOrderStage").combobox('getValue'); //ҽ���׶�
	if ($("#DHCDocOrderStage").combobox('getText')=="") OldDHCDocOrderStageID="";
	var DHCDocOrderStageID=CheckComboxSelData("DHCDocOrderStage",OldDHCDocOrderStageID);
	if (((OldDHCDocOrderStageID==undefined)||(OldDHCDocOrderStageID!=""))&&(DHCDocOrderStageID=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ��ҽ���׶�!',"info",function(){
			$('#DHCDocOrderStage').next('span').find('input').focus();
		}); 
		return false;
	}
	//��Һ����
	var OrderSpeedFlowRate=$.trim($("#OrderSpeedFlowRate").val());
	if (OrderSpeedFlowRate!="") {
		var OrderSpeedFlowRateArr=OrderSpeedFlowRate.split("-");
		if (OrderSpeedFlowRateArr.length>=3) {
			$.messager.alert('��ʾ','��������Ч����Һ����������Χ!����2-9',"info",function(){
				$("#OrderSpeedFlowRate").focus();
			});
			return false; 
		}else if(OrderSpeedFlowRateArr.length==2){
			if ((!reg.test(OrderSpeedFlowRateArr[0]))||(!reg.test(OrderSpeedFlowRateArr[1]))){
				$.messager.alert('��ʾ','��������Ч����Һ����������Χ!����2-9',"info",function(){
					$("#OrderSpeedFlowRate").focus();
				}); 
				return false;
			}
		}else{
			if (!reg.test(OrderSpeedFlowRate)) {
				$.messager.alert('��ʾ','��Һ������������Ч������!',"info",function(){
					$("#OrderSpeedFlowRate").focus();
				}); 
				return false; 
			}
		}
	}
	//���ٵ�λ
	var OldOrderFlowRateUnit=$("#OrderFlowRateUnit").combobox('getValue');
	if ($("#OrderFlowRateUnit").combobox('getText')=="") OldOrderFlowRateUnit="";
	var OrderFlowRateUnit=CheckComboxSelData("OrderFlowRateUnit",OldOrderFlowRateUnit);
	if (((OldOrderFlowRateUnit==undefined)||(OldOrderFlowRateUnit!=""))&&(OrderFlowRateUnit=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ�����ٵ�λ!',"info",function(){
			$('#DHCDocOrderStage').next('span').find('input').focus();
		}); 
		return false;
	}
	if ((DrippingSpeedInstr!="")&&(DrippingSpeedInstr.indexOf("^"+ItemInstructionID+"^")>=0)){
		if (OrderSpeedFlowRate =="" ){
			$.messager.alert('��ʾ','�����÷�,����д��Һ����!',"info",function(){
				$("#OrderSpeedFlowRate").focus();
			}); 
			return false;
		}
		if (OrderFlowRateUnit =="" ){
			$.messager.alert('��ʾ','�����÷�,��ѡ�����ٵ�λ!',"info",function(){
			$('#OrderFlowRateUnit').next('span').find('input').focus();
		}); 
			return false;
		}
		if ((OrderSpeedFlowRate=="")&&(OrderFlowRateUnit!="")){
			$.messager.alert('��ʾ','����д��Һ����!',"info",function(){
				$("#OrderSpeedFlowRate").focus();
			}); 
			return false;
		}
		if ((OrderSpeedFlowRate!="")&&(OrderFlowRateUnit=="")){
			$.messager.alert('��ʾ','��ѡ�����ٵ�λ!',"info",function(){
			$('#OrderFlowRateUnit').next('span').find('input').focus();
		}); 
			return false;
		}
	}
	var OldSkinActionID=$("#SkinAction").combobox('getValue');
	if ($("#SkinAction").combobox('getText')=="") OldSkinActionID="";
	var SkinActionID=CheckComboxSelData("SkinAction",OldSkinActionID);
	if (((OldSkinActionID==undefined)||(OldSkinActionID!=""))&&(SkinActionID=="")){
		$.messager.alert('��ʾ','��ѡ����ȷ��Ƥ�Ա�ע!',"info",function(){
			$('#SkinAction').next('span').find('input').focus();
		}); 
		return false;
	}
	
	var OrderPriorRemarks=$("#OrderPriorRemarks").combobox('getValue');
	var OrderPriorRemarksText=$("#OrderPriorRemarks").combobox('getText');
	if ((OrderPriorRemarksText!=$g("ȡҩҽ��"))&&(OrderPriorRemarksText!=$g("�Ա�ҩ"))&&(OrderPriorRemarksText!=$g("��Ժ��ҩ"))&&(OrderPriorRemarksText!=$g("����"))&&(OrderPriorRemarksText!="")){
		$.messager.alert('��ʾ','��ѡ����ȷ�ĸ���˵��'); 
		return false;
	}
	var OrderPriorRemarks=$("#OrderPriorRemarks").combobox('getValue');
	var OrdName=$("#ItemDesc").val();
	var OrderPriorRowid = ReSetOrderPriorRowid(DHCDocOrderTypeID, OrderPriorRemarks);
	if (!CheckPriorAllow(DHCDocOrderTypeID, ARCIMRowid, OrdName)) return false;
	if (ARCIMRowid.indexOf("||")>=0){
		var OrderType=tkMakeServerCall("web.DHCDocOrderCommon","GetOrderType",ARCIMRowid);
		var ItmLinkDoctor=$("#ItmLinkDoctor").val();
		var OrderPriorRemarks=$("#OrderPriorRemarks").combobox('getValue');
		if (OrderPriorRemarks=="ONE"){
			if (OrderType!="R"){
				$.messager.alert('��ʾ',"��ҩƷҽ��,������ѡ��ȡҩҽ��","info",function(){
					websys_setfocus('OrderPriorRemarks');
				});
				return false;
			}
			if (ItmLinkDoctor!="") {
				$.messager.alert('��ʾ',"ȡҩҽ�����������!","info",function(){
					websys_setfocus('ItmLinkDoctor');
				});
				return false;
			}
		}
		if ((ItmLinkDoctor!="")&&((("^" + NotLinkItemCat + "^").indexOf("^" + m_Itemcat + "^") >= 0))){ //&&(OrderType!="R")
			$.messager.alert('��ʾ',OrdName+"ҽ�����ܹ���","info",function(){
				websys_setfocus('ItmLinkDoctor');
			});
			return false;
		}else{
			var ItmLinkDoctor=$("#ItmLinkDoctor").val(); //����
			var rtn=ItmLinkUnique(ARCOSRowid,ItmLinkDoctor,ARCOSItemRowid,ARCIMRowid)
			if (rtn!="") {
				$.messager.alert('��ʾ',rtn); 
				return false;
			}
		}
		
		if (OrderType!="R") {
			var IsHourItem=tkMakeServerCall("web.DHCDocOrderCommon","IsHourItem",ARCIMRowid)
			if ((FrequencedItemCat!="")&&(("^"+FrequencedItemCat+"^").indexOf("^"+m_iorderSubCatID+"^")>=0)){
				if ((IsHourItem!="1")&&(FreqRowid=="")) {
					$.messager.alert('��ʾ',"��ѡ��Ƶ��!","info",function(){
						$('#ItemFrequence').next('span').find('input').focus();
					});
					return false;
				}
				if ((IsHourItem!="1")&&(ItemDurationID=="")) {
					$.messager.alert('��ʾ',"��ѡ���Ƴ�!","info",function(){
						$('#ItemDuration').next('span').find('input').focus();
					});
					return false;
				}
			}
		}else{
			if (ARCOSPrescType=="Other") {
				if (FreqRowid=="") {
					$.messager.alert('��ʾ',"��ѡ��Ƶ��!","info",function(){
						$('#ItemFrequence').next('span').find('input').focus();
					});
					return false;
				}
				if ((ItemDurationID=="")&&((WYInstr=="")||(WYInstr.indexOf("^"+ItemInstructionID+"^")<0))){
					$.messager.alert('��ʾ',"��ѡ���Ƴ�!","info",function(){
						$('#ItemDuration').next('span').find('input').focus();
					});
					return false;
				}
				if (ItemInstructionID=="") {
					$.messager.alert('��ʾ',"��ѡ���÷�!","info",function(){
						$('#ItemInstruction').next('span').find('input').focus();
					});
					return false;
				}
			}
			if ((WYInstr=="")||(WYInstr.indexOf("^"+ItemInstructionID+"^")<0)){
				var ItemDoseQty=$("#ItemDoseQty").val();
				if ((ItemDoseQty=="")&&(ItemDoseQty.indexOf("-")<0)) {
					$.messager.alert('��ʾ','��������Ч�ĵ��μ���!',"info",function(){
						if (PageLogicObj.m_SameFreqDifferentDosesFlag=="Y") {
							$("#ItemDoseQty").click();
						}else{
							$("#ItemDoseQty").focus();
						}
					}); 
					return false;
				}
			}
		}
		var remark=$("#remark").combobox('getText');
		if (remark=="") {
			var ARCIMRequireNoteFlag=tkMakeServerCall("web.DHCDocOrderCommon","GetARCIMRequireNoteFlag",ARCIMRowid);
			if (ARCIMRequireNoteFlag=="Y"){
				$.messager.alert('��ʾ',"����д��ע!","info",function(){
					$('#remark').next('span').find('input').focus();
				});
				return false;
			}
		}
		var ItemQty=$("#ItemQty").val();
		var ItemDoseQty=$("#ItemDoseQty").val();
		if((ARCOSPrescType=='CNMedItemCat')&&!isPositiveInteger(ItemDoseQty)){
			var CMAllowEntryDecimalItemCat=tkMakeServerCall("web.DHCOEOrdItemCMView","CheckAllowEntryDecimalItem",ARCIMRowid);
			if(CMAllowEntryDecimalItemCat=='N'){
				$.messager.alert('��ʾ',"��ҽ�����μ���ӦΪ����!","info",function(){
					websys_setfocus('ItemDoseQty');
				});
				return false;
			}
		}
		if((ARCOSPrescType=='Other')&&!isPositiveInteger(ItemQty)){
			var SubCatID = cspRunServerMethod(GetARCItemSubCatID, '', '', ARCIMRowid);
			var AllowEntryDecimalItemCatStr = "^" + AllowEntryDecimalItemCat + "^";
			if (((AllowEntryDecimalItemCatStr.indexOf("^" + SubCatID + "^")) == -1)) {
				$.messager.alert('��ʾ',"��ҽ������װ����ӦΪ����!","info",function(){
					websys_setfocus('ItemQty');
				});
			   	return false;
			}
		}
	}
	
	return true;
}
//�Ƿ�Ϊ������
function isPositiveInteger(s){
   var re = /^[0-9]+$/ ;
   return re.test(s)
} 
//�˳�
function BackClickHandler()
{
	window.close();
	window.open=null;	
}

function ClearClickHandler()
{
	Clear_Mes();
	$('#ItemDesc').focus();
}

//��ʼ��Comb���
function ComCreat(Type){

	FreqCombCreat() //Ƶ�γ�ʼ��
	InsTructionCombCreat() //�÷�
	DurationCombCreat(); //�Ƴ�
	PriorRemarksCombCreat(); //��ע
	DHCDocOrderTypeCombCreat(); //ҽ������
	DHCDocOrderStageCombCreat();//ҽ���׶�
	remarkCombCreat("") //��ע
	OrderFlowRateUnitCombCreat();//���ٵ�λ
	SkinActionCombCreat();//Ƥ�Ա�ע
	if (Type=="ALL"){
		ItemDoseUOMCombCreat("","") //���μ�����λ
		ItemBillUOMCombCreat("","") //����װ��λ		
		sampleTypeCombCreat("","",0) //�걾
		$('#sampleType').combobox('select','')
		DHCDocOrderRecLocCombCreat("","",0);
	}else{
		var cbox = $HUI.combobox("#ItemDoseUOM,#ItemBillUOM,#sampleType,#DHCDocOrderRecLoc", {});
	}
}
//���� 
function Clear_Mes(){
	ComCreat("ALL");
	$("#ItemRowid").val(""); //ҽ����ID
	$("#ItemDesc").lookup("setText",""); //ҽ������
	$("#ItemDoseQty,#ItemQty,#ItmLinkDoctor,#OrderSpeedFlowRate,#OrderBodyPartLabelText,#OrderBodyPartLabel,#OrderFreqDispTimeStr,#OrderFreqTimeDoseStr").val("");
	$("#MustEnter,#SkinTest,#NotifyClinician,#RemoveCeler").checkbox('uncheck');
	$("#MustEnter,#SkinTest,#NotifyClinician").checkbox("enable");
}

//����װ��λ
function ItemBillUOMCombCreat(ArcimDr,DefPackQtyUomRowId)
{
	var Edit=true
	var INPut="N"
	if (ARCOSPrescType!="Other"){
		INPut="Y"
	}
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemBillUOM", Inpute1:INPut, Inpute2:ArcimDr, 
		Inpute3:$("#DHCDocOrderRecLoc").combobox('getValue'), Inpute4:DefPackQtyUomRowId,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemBillUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					if (data.length>0){
						var DHCDocOrderRecLoc=$("#DHCDocOrderRecLoc").combobox('getValue');
						if (DHCDocOrderRecLoc!=""){
							$(this).combobox('select',data[0]['CombValue']);
						}else{
							$(this).combobox('select',DefPackQtyUomRowId);
						}
					}
				}
		 });
	});
}
//��ע
function remarkCombCreat(Tremark)
{
	var Edit=true
	var INPut="^N"
	if (ARCOSPrescType!="Other"){
		INPut="^Y";Edit=false;
	}
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"remark", Inpute1:INPut,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#remark", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					if (Tremark!=""){
						$(this).combobox('setText',Tremark);
					}
				}
		 });
	});
}
function OrderFlowRateUnitCombCreat(){
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"OrderFlowRateUnit", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#OrderFlowRateUnit", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}
//ҽ������
function DHCDocOrderTypeCombCreat()
{
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderType", 
		Inpute1:m_ArcimClassification,
		Inpute2:session['LOGON.CTLOCID'],
		rows:99999
	},false);
	var cbox = $HUI.combobox("#DHCDocOrderType", {
		valueField: 'CombValue',
		textField: 'CombDesc', 
		editable:true,
		data: GridData["rows"],
		filter: function(q, row){
			return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onLoadSuccess:function(){
			//$(this).combobox('select',"");
		},onSelect:function(){
			ChangeFormStyle(m_ArcimClassification,m_iorderSubCatID,m_idoseqtystr);
		},onChange:function(newValue,oldValue){
			if (newValue==""){
				ChangeFormStyle(m_ArcimClassification,m_iorderSubCatID,m_idoseqtystr);
			}
		}
    });
}
//ҽ���׶�
function DHCDocOrderStageCombCreat()
{
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderStage", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#DHCDocOrderStage", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}
	 });
}
//���տ���
function DHCDocOrderRecLocCombCreat(ArcimID,DefaultOrdRecLoc,DefaultFlag){
	
	/*$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderRecLoc", 
		Inpute1:ArcimID, Inpute2:DefaultOrdRecLoc, Inpute3:DefaultFlag,
		rows:99999
	},function(GridData){*/
		var cbox = $HUI.combobox("#DHCDocOrderRecLoc", {
				url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=DHCDocOrderRecLoc&Inpute1="+ArcimID+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3="+DefaultFlag,
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				mode:"remote",
				//data: GridData["rows"],
				loadFilter:function(data){
				    return data['rows'];
				},
				onBeforeLoad:function(param){
					param = $.extend(param,{Inpute4:param['q']});
				}/*,
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}*/,onLoadSuccess:function(){
					//$(this).combobox('select',DefaultOrdRecLoc);
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$('#DHCDocOrderRecLoc').combobox('select',"");
						$('#ItemBillUOM').combobox('select',""); 
						var ArcimID=$("#ItemRowid").val();
						ItemBillUOMCombCreat(ArcimID,"")
					}
				},onSelect:function(record){
					var ArcimID=$("#ItemRowid").val();
					ItemBillUOMCombCreat(ArcimID,"");
				}
		 });
	//});
}
//����˵��
function PriorRemarksCombCreat()
{
	
	var INPut="^N"
	if (ARCOSPrescType!="Other"){
		INPut="^Clear";
	}
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"OrderPriorRemarks", 
		Inpute1:INPut,
		rows:99999
	},false);
	var cbox = $HUI.combobox("#OrderPriorRemarks", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}
//�Ƴ�
function DurationCombCreat()
{
	var INPut="^N"
	if (ARCOSPrescType!="Other"){
		INPut="^Clear";
	}
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemDuration", 
		Inpute1:INPut,
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ItemDuration", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}
//�÷�
function InsTructionCombCreat()
{
	var INPut="^N"
	if (ARCOSPrescType!="Other"){
		INPut="^Clear";
	}
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemInstruction", 
		Inpute1:INPut,Inpute2:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ItemInstruction", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				//return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CombCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			},onSelect: function(rec){ 
				if (rec) {
					$("#SkinTest").checkbox('enable');
					$("#SkinAction").combobox('enable');
					if (m_ArcimClassification =="RC") {
						
						$("#SkinTest").checkbox('enable');
						$("#SkinAction").combobox('enable');
					}
					if (m_ArcimClassification !="RW") {
						$("#SkinTest").checkbox('disable')
						$("#SkinAction").combobox('setValue',"").combobox('disable');
					}
					if ((SkinTestInstr!="")&&(SkinTestInstr.indexOf("^"+rec.CombValue+"^")>=0)) {
						$("#SkinAction").combobox('setValue',"").combobox('disable');
						$("#SkinTest").checkbox('setValue', true);
						//$("#SkinTest").checkbox('disable').checkbox('uncheck');
					}
					if ((WYInstr!="")&&(WYInstr.indexOf("^"+rec.CombValue+"^")>=0)){
						$("#ItemDoseQty,#OrderFreqTimeDoseStr").val("");
					}
					var disabled=$("#OrderFlowRateUnit").combobox('options').disabled;
					var OrderFlowRateUnit=$("#OrderFlowRateUnit").combobox('getValue');
					if (!disabled&&(OrderFlowRateUnit=="")) {
						$.cm({
						    ClassName:"web.DHCOEOrdItemView",
						    MethodName:"GetInstrDefSpeedRateUnit",
						    InstrRowId:rec.CombValue,
						    dataType:"text"
						},function(OrderFlowRateUnitRowId){
							if (OrderFlowRateUnitRowId!=""){
								$("#OrderFlowRateUnit").combobox('select',OrderFlowRateUnitRowId);
						    }
						})
					}
				}  
			},onChange:function(newValue, oldValue){
				if (newValue=="") {
					$("#SkinTest").checkbox('enable');
					$("#SkinAction").combobox('enable');
				}
			}
	 });
}
//Ƶ��
function FreqCombCreat()
{
	var INPut="^N"
	if (ARCOSPrescType!="Other"){
		INPut="^Clear";
	}
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemFrequence", 
		Inpute1:INPut,Inpute2:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ItemFrequence", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				//return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CombCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			},
			onSelect: function(rec){ 
				if (rec) {
					/**/
				}  
			},onChange:function(newValue, oldValue){
				if (newValue=="") {
					$("#OrderFreqDispTimeStr").val("");
					ChangeOrderFreqTimeDoseStr();
				}
			},
			onHidePanel:function(){
				ItemFrequenceChange();
			}
	 });
}
//Ƥ�Ա�ע
function SkinActionCombCreat()
{
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"OrderAction", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#SkinAction", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect: function(rec){ 
				if (rec) {
					$("#SkinTest").checkbox('enable');
					if ((rec.CombCode=="YY")||(rec.CombCode=="PSJ")) {
						$("#SkinTest").checkbox('disable').checkbox('check');
					}else if((rec.CombCode == "MS") || (rec.CombCode == "XZ") || (rec.CombCode == "TM")|| (rec.CombCode == "YX")) {
						$("#SkinTest").checkbox('disable').checkbox('uncheck');
					}
				}  
			},onChange:function(newValue, oldValue){
				if (newValue=="") $("#SkinTest").checkbox('enable');
			}
	 });
}
function LookUpItem(e){
	try{
	var obj=websys_getSrcElement(e);
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var OrderName=$("#ItemDesc").val().replace(/(^\s*)|(\s*$)/g,'');
	if (key>64 && key<91){
		OrderName=OrderName+e.key; //if (OrdNameDesc=="") 
	}
	if ((key == 13) || (type == 'dblclick')||((OrderName.length>1)&&((key>64 && key<91)||(e.target.id=="imgItemDesc")))) {
        var GroupID=session['LOGON.GROUPID']
        if (ItemzLookupGrid && ItemzLookupGrid.store) {
	        ItemzLookupGrid.searchAndShow([function() { return $("#ItemDesc").val(); }, GroupID, ARCOSPrescType]);
	    } else {
	        ItemzLookupGrid = new dhcc.icare.Lookup({
	            lookupListComponetId: 1872,
	            lookupPage: "ҽ����ѡ��",
	            lookupName: "ItemDesc",
	            listClassName: 'web.DHCARCOrdSets',
	            listQueryName: 'LookUpItem',
	            resizeColumn: true,
	            listProperties: [function() { return $("#ItemDesc").val(); }, GroupID, ARCOSPrescType],
	            //listProperties: [OrderName, GroupID, catID, subCatID, P5, LogonDep, OrderPriorRowid, GlobalObj.EpisodeID, P9, P10, session["LOGON.USERID"], OrdCatGrp, "", CurLogonDep],
	            listeners: { 
	                'selectRow': OrderItemLookupSelect
	            },
	            isCombo: true
	        });
	    }
    }
   }catch(e){}
}
function IntItemDescLookUp(){
	$("#ItemDesc").lookup({
		width:$("#ItemDesc").parent().width(),
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimRowID',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'����',width:300,sortable:true},
           {field:'ItemPrice',title:'����',width:70,sortable:true},
           {field:'ArcimRowID',hidden:true}
        ]],
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{Item:desc,GroupID:session['LOGON.GROUPID'],OrderPrescType:ARCOSPrescType,SearchLimitType:SearchLimitType,ParamARCOSRowid:ARCOSRowid});
	    },onSelect:function(ind,item){
		   $("#ItemRowid").val(item['ArcimRowID']);
		   var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			OrderItemLookupSelect(ItemArr.join("^"));
		}
    });
}
//������λ
function ItemDoseUOMCombCreat(ArcimID,DefaultDosUomDr,callBackFun)
{
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemDoseUOM", 
		Inpute1:ArcimID,Inpute2:DefaultDosUomDr,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemDoseUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$(this).combobox('select',DefaultDosUomDr);
					if(callBackFun) callBackFun();
				}
		 });
	});
}
//��ʼ���걾
function sampleTypeCombCreat(ArcimDr,SampleID,Flag)
{
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"sampleType", 
		Inpute1:ArcimDr,Inpute2:SampleID,Inpute3:Flag,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#sampleType", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					$(this).combobox('select',SampleID);
					if ((Flag==1)&&(data.length>0)){
						$(this).combobox('select',data[0]['CombValue']);
					}
				}
		 });
	});
}
function OrderItemLookupSelect(txt)
{
	Clear_Mes();
	setTimeout(function(){
		var adata=txt.split("^");
		var idesc=adata[0];
		var icode=adata[1];
		var ifreq=adata[2];
		var iordertype=adata[3];
		var ialias=adata[4];
		var isubcatcode=adata[5];
		var iorderCatID=adata[6];
		var iSetID=adata[7];
		var mes=adata[8];
		var irangefrom=adata[9];
		var irangeto=adata[10]
		var iuom=adata[11];
		var idur=adata[12];
		var igeneric=adata[13];
		var match="notfound";
		var SetRef=1;
		var OSItemIDs=adata[15];
		var iorderSubCatID=adata[16];
		if (ARCOSPrescType!="Other"){
			var ibilluom=adata[19]
		}else{
			var ibilluom=adata[20]
		}
	    if (iordertype=="ARCOS") {
		    //ҽ����ID
			$("#ItemRowid").val(icode); 
			//ҽ������
			$("#ItemDesc").lookup("setText",idesc);
			setTimeout(function(){
				ChangeFormStyle("ARCOS","","");
			});
		    return;
		}
		if (iordertype=="ARCIM") iSetID="";
		var idoseqtystr=""
		var DefaultDoseQty="",DefaultDoseUOMRowid="";
		var ArcimClassification="";
		var ArcItemCat="";
		var ret=$.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"GetARCIMDetail",
			ArcimRowid:icode, 
			dataType:"text",
		},false);
		//var ret=tkMakeServerCall("web.DHCDocOrderCommon","GetARCIMDetail",icode);
		if (ret!=""){
			var idesc=mPiece(ret,"^",0);
			var OrderType=mPiece(ret,"^",1);
			var ArcItemCat=mPiece(ret,"^",2);
			m_Itemcat=ArcItemCat
			var ipackqtystr=mPiece(ret,"^",5);
			var iformstr=mPiece(ret,"^",6);
			var idoseqtystr=mPiece(ret,"^",7);
			m_idoseqtystr=idoseqtystr;
			var ifrequencestr=mPiece(ret,"^",8);
			var iinstructionstr=mPiece(ret,"^",9);
			var idurationstr=mPiece(ret,"^",10);
			var ArcimClassification=mPiece(ret,"^",12);
			var NotifyClinician=mPiece(ret,"^",13);
			var ARCIMDefSensitive=mPiece(ret,"^",14);
			var PHPrescType=mPiece(ret,"^",16);
			PageLogicObj.m_SameFreqDifferentDosesFlag=mPiece(ret,"^",15);//ͬƵ�β�ͬ����ҽ����־
			PageLogicObj.m_PHPrescType=PHPrescType;
			var OrderPackQty=mPiece(ipackqtystr,String.fromCharCode(1),0);
			var OrderPackUOM=mPiece(ipackqtystr,String.fromCharCode(1),1);
			var OrderPackUOMRowid=mPiece(ipackqtystr,String.fromCharCode(1),2);
			var OrderFreq=mPiece(ifrequencestr,String.fromCharCode(1),0);
			var OrderFreqRowid=mPiece(ifrequencestr,String.fromCharCode(1),1);
			var OrderFreqFactor=mPiece(ifrequencestr,String.fromCharCode(1),2);
			var OrderFreqInterval=mPiece(ifrequencestr,String.fromCharCode(1),3);
			var OrderInstr=mPiece(iinstructionstr,String.fromCharCode(1),0);
			var OrderInstrRowid=mPiece(iinstructionstr,String.fromCharCode(1),1);
			var OrderDur=mPiece(idurationstr,String.fromCharCode(1),0);
			var OrderDurRowid=mPiece(idurationstr,String.fromCharCode(1),1);
			var OrderDurFactor=mPiece(idurationstr,String.fromCharCode(1),2); 
			var DefaultDoseQty="";
			var DefaultDoseUOMRowid="";
			if (idoseqtystr!=""){
				var ArrData=idoseqtystr.split(String.fromCharCode(2));
				for (var i=0;i<ArrData.length;i++) {
					 var ArrData1=ArrData[i].split(String.fromCharCode(1));
					 if (i==0) {
					 	var DefaultDoseQty=ArrData1[0];
					 	var DefaultDoseQtyUOM=RowidData=ArrData1[1];
					 	var DefaultDoseUOMRowid=RowidData=ArrData1[2];
					}
				}
			}
		}
		//ҽ����ID
		$("#ItemRowid").val(icode); 
		//ҽ������
		$("#ItemDesc").lookup("setText",idesc); 
		//�Ӽ���־
		if(NotifyClinician!="Y") {
			$("#NotifyClinician").checkbox("setValue",false)
			$HUI.checkbox('#NotifyClinician').disable();
		}else{
			$HUI.checkbox('#NotifyClinician').enable();
		}
		if (ARCIMDefSensitive=="Y"){
			$("#NotifyClinician").checkbox("check");
		}else{
			$("#NotifyClinician").checkbox("uncheck");
		}
		//��ʼ��������λ
		ItemDoseUOMCombCreat(icode,DefaultDoseUOMRowid,function(){
			if (ARCOSPrescType=="Other"){
				if (OrderFreqRowid!="")  {
					$('#ItemFrequence').combobox('select',OrderFreqRowid);//Ƶ��
					ItemFrequenceChange();
				}
			}
		}); 
		//����װ��λ
		ItemBillUOMCombCreat(icode,OrderPackUOMRowid);
		DefaultDoseQty=ChangeNum(DefaultDoseQty)
		//���μ���
		if (DefaultDoseQty!="") $("#ItemDoseQty").val(DefaultDoseQty);
		//���տ���
	    DHCDocOrderRecLocCombCreat(icode,"",0); 
		//��ҩ�����²����и�ֵ
		if (ARCOSPrescType=="Other"){
			//��ʼ���걾
			sampleTypeCombCreat(icode,"",1);
			OrderPackQty=ChangeNum(OrderPackQty)
			if (OrderInstrRowid!="")  $('#ItemInstruction').combobox('select',OrderInstrRowid); //�÷�
			if (OrderDurRowid!="")  $('#ItemDuration').combobox('select',OrderDurRowid);
			if (OrderPackQty!="")  $("#ItemQty").val(OrderPackQty);
		}
		m_ArcimClassification=ArcimClassification;
		DHCDocOrderTypeCombCreat();
		setTimeout(function(){
			ChangeFormStyle(ArcimClassification,iorderSubCatID,idoseqtystr);
		});
		InitBodyPartLabel(true);
		if (PageLogicObj.m_SameFreqDifferentDosesFlag=="Y") {
			OrdDoseQtyBindClick();
		}
	});
}

function InitBodyPartLabel(ShowPartWinFlag){
	var ARCIMRowid=$("#ItemRowid").val(); 
	if (ARCIMRowid==""){
		return;
	}
	var ItemServiceFlag = $cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"GetItemServiceFlag",
		InStr:ARCIMRowid,
		dataType:"text"
	},false);
	var isExistPart=0;
	if (ItemServiceFlag=="1"){
		isExistPart=$cm({
			ClassName:"web.DHCAPPInterface",
			MethodName:"isExistPart",
			itmmastid:ARCIMRowid,
			dataType:"text"
		},false);
	}
	if ((isExistPart=="1")&&(ItemServiceFlag=="1")){
		if (ShowPartWinFlag==true){
			OrderBodyPartLabelTextFocusHandler();
		}
		setTimeout(function(){
			$("#OrderBodyPartLabelText").prop("disabled",false);
		});
		$("#OrderBodyPartLabelText").click(function(){
		    OrderBodyPartLabelTextFocusHandler();
		});
	}else{
		setTimeout(function(){
			$("#OrderBodyPartLabelText").prop("disabled",true);
		});
		$("#OrderBodyPartLabelText").val("");
		$("#OrderBodyPartLabel").val("");
		$("#OrderBodyPartLabelText").unbind("click");
	}
}
function OrderBodyPartLabelTextFocusHandler(){
	var ARCIMRowid=$("#ItemRowid").val(); 
	if (ARCIMRowid==""){
		return;
	}
	var selOrdBodyPartStr=$("#OrderBodyPartLabel").val();
	var selOrdBodyPartDescStr=$("#OrderBodyPartLabelText").val();
	var linkUrl = "dhcapp.appreppartwin.csp?itmmastid="+ARCIMRowid+"&selOrdBodyPartStr="+selOrdBodyPartStr+"&selOrdBodyPartDescStr="+selOrdBodyPartDescStr;
	/*var reppartStr=window.showModalDialog(linkUrl,"","dialogwidth:800px;dialogheight:600px;status:no;center:1;resizable:yes");
	//��λ����λ�ͺ���������^��λ����λ��^����ID
	if (typeof reppartStr !="undefined"){
		var reppartArr=reppartStr.split("^");
		var Text=reppartArr[0];
		var value=reppartArr.slice(1).join("*");
		$("#OrderBodyPartLabelText").val(Text);
		$("#OrderBodyPartLabel").val(value);
	}*/
	 websys_showModal({
		iconCls:'icon-w-pen-paper',
		url:linkUrl,
		title:'��λѡ��',
		width:1200,height:700,
		CallBackFunc:function(reppartStr){
			var reppartArr=reppartStr.split("^");
			var Text=reppartArr[0];
			var value=reppartArr.slice(1).join("*");
			$("#OrderBodyPartLabelText").val(Text);
			$("#OrderBodyPartLabel").val(value);
		}
	})
}
function ChangeFormStyle(ArcimClassification,ArcItemSubCat,idoseqtystr) { 
	if (ArcimClassification=="ARCOS"){
		$(".textbox").not("#ItemDesc").prop("disabled",true);  
		$(".hisui-combobox").combobox('disable'); 
		$("#ItemDoseUOM,#DHCDocOrderRecLoc,#ItemBillUOM,#sampleType").combobox('disable'); 
		$(".hisui-checkbox").checkbox('disable');
		return;
	}
	m_idoseqtystr=idoseqtystr;
	m_ArcimClassification=ArcimClassification;
	m_iorderSubCatID=ArcItemSubCat;
	$(".textbox").prop("disabled",false);  
	$(".hisui-combobox").combobox('enable'); 
	var InstructionRowID=$("#ItemInstruction").combobox('getValue');
	var ActionCode=GetActionCode();
	if ((ArcimClassification !="RW")||(ActionCode == "MS") || (ActionCode == "XZ") || (ActionCode == "TM")|| (ActionCode == "YX")) {
		$("#SkinTest").checkbox('disable')
		if((ArcimClassification !="RW")) $("#SkinAction").combobox('setValue',"").combobox('disable');
	}else{
		$("#SkinTest").checkbox('enable')
		if ((SkinTestInstr!="")&&(SkinTestInstr.indexOf(InstructionRowID)>=0)) {
			$("#SkinAction").combobox('setValue',"").combobox('disable');
			//$("#SkinTest").checkbox('disable').checkbox('uncheck');
		}else{
			$("#SkinAction").combobox('enable');
		}
	}
	if ((("^" + NotLinkItemCat + "^").indexOf("^" + m_iorderSubCatID + "^") >= 0)){ 
		$("#ItmLinkDoctor").val("").prop("disabled",true);
	}
	//���顢���ҽ��
	if((ArcimClassification=="L")||(ArcimClassification=="E")) {
		//������λ��Ƶ�Ρ��Ƴ̡��÷�������˵�� ���ɱ༭
		$("#ItemDoseUOM,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderPriorRemarks").combobox('disable');
		//���μ��������� ���ɱ༭
		$("#ItemDoseQty").prop("disabled",true);
		//ҽ������ ǿ����ʱ
		$("#DHCDocOrderType").combobox('select',ShortOrderPriorRowid);
	}
	//��ҩƷ����顢����ҽ��,�ж�ά��ҽ���׵�Ƶ�κ��÷��ǲ��ǿ�ѡ Ƶ�κ��Ƴ�ͬ��,������Ƶ��Ҳ����ά���Ƴ�
	var DisPlayFreq="N",DisInstr="N";
	if ((ArcItemSubCat!="")&&(ArcimClassification!="RW")){
		//¼��Ƶ�εķ�ҩƷ����
		//if ((FrequencedItemCat!="")&&(("^"+FrequencedItemCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){
		if (PageLogicObj.m_PHPrescType =="4"){
			DisPlayFreq="Y";
		}
		//��ѡ���÷��ķ�ҩƷ�ӷ���
		if ((inputInstrNotDrugCat!="")&&(("^"+inputInstrNotDrugCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){
			DisInstr="Y";
		}
		if (DisPlayFreq!="Y"){
			$("#ItemFrequence,#ItemDuration").combobox('disable');
		}else{
            $("#ItemFrequence,#ItemDuration").combobox('enable');
        }
		if (DisInstr!="Y"){
			$("#ItemInstruction").combobox('disable');
		}
	}
	//���������ҩ Ҳ���ǲ�ҩ �򵥴μ�����λ����¼��
	if ((ArcimClassification!="RW")&&(ArcimClassification!="RC")){
		$("#ItemDoseUOM").prop("disabled",true);
	}
	//���������λ��Ϊ���ҷ�¼��Ƶ�εķ�ҩƷ���࣬������¼�����
	if ((idoseqtystr=="")&&(DisPlayFreq=="N")){ 
		$("#ItemDoseQty").prop("disabled",true);
	}
	//����ҩ ����ά����Һ���� ���ٵ�λ
	if (ArcimClassification!="RW"){
		$("#OrderSpeedFlowRate").prop("disabled",true);
		$("#OrderFlowRateUnit").combobox('disable');
		if (ArcimClassification=="RC"){
			//��ҩ ������λ���걾������˵����ҽ���׶�
			$("#ItemBillUOM,#sampleType,#OrderPriorRemarks,#DHCDocOrderStage").combobox('disable');
			//����װ����������
			$("#ItemQty,#ItmLinkDoctor").prop("disabled",true);
		}
	}else{
		$("#sampleType").combobox('disable');
	}
	if (ArcimClassification=="O"){
		if ($("#DHCDocOrderType").combobox('getValue')==LongOrderPriorRowid){
			var PHPrescType=$.cm({
				ClassName:"web.DHCDocOrderCommon",
				MethodName:"GetPHPrescType",
				ItemCatRowid:ArcItemSubCat, 
				dataType:"text",
			},false);
			if (PHPrescType==4){
				$("#ItemDoseQty").prop("disabled",false);
				if (idoseqtystr==""){
					//#ItemBillUOM  CombValue CombDesc
					var data=$("#ItemBillUOM").combobox('getData');
					$("#ItemDoseUOM").combobox('loadData',data);
					if (data.length==1){
						$("#ItemDoseUOM").combobox('select',data[0]['CombValue']);
					}
				}
			}
		}else{
			if ((idoseqtystr=="")&&(DisPlayFreq=="N")){
				$("#ItemDoseQty").val('');
				$("#ItemDoseUOM").combobox('loadData',[]);
				$("#ItemDoseUOM").combobox('select',"");
			}
		}
	}
	//ChangePrescTypeLayout();
	
	/*//����label
	$("#CsampleType").hide();
	//����comboԪ��
	$("#sampleType").next(".combo").hide();
	//����textbox
	//��ʾcombo��label
	$("#CItemDoseQty,#CItemDoseUOM,#CItmLinkDoctor,#CItemFrequence,#CItemDuration,#CItemInstruction,#COrderPriorRemarks").show();
	$("#CItemDoseQty").parent().show();
	//��ʾcomboԪ��
	$("#ItemDoseQty,#ItemDoseUOM,#ItmLinkDoctor,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderPriorRemarks").next(".combo").show();
	//��ʾtextbox
	$("#ItemDoseQty,#ItmLinkDoctor").show();
	
	//ҽ������ ǿ����ʱ
	//$("#DHCDocOrderType").combobox('setValue','');
	if((ArcimClassification=="L")||(ArcimClassification=="E")) {
		//����label
		$("#CItemDoseQty,#CItemDoseUOM,#CItmLinkDoctor,#CItemFrequence,#CItemDuration,#CItemInstruction,#COrderPriorRemarks").hide();
		//����comboԪ��
		$("#ItemDoseUOM,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderPriorRemarks").next(".combo").hide();
		//����textx		box
		$("#ItemDoseQty,#ItmLinkDoctor").hide();
		//��ʾcombo��label
		$("#CsampleType").show();
		//��ʾcomboԪ��
		$("#sampleType").next(".combo").show();
		//��ʾtextbox
		//ҽ������ ǿ����ʱ
		$("#DHCDocOrderType").combobox('setValue',ShortOrderPriorRowid);
	}
	
	//��������ҩƷͬʱ���Ǽ�����ҽ��,�ж�ά��ҽ���׵�Ƶ�κ��÷��ǲ��ǿ�ѡ Ƶ�κ��Ƴ�ͬ��������Ƶ��Ҳ����ά���Ƴ�
	if ((ArcItemSubCat!="")&&(ArcimClassification!="RW"))
	{
		var DisPlayFreq="N"
		var DisInstr="N"
		if ((FrequencedItemCat!="")&&(("^"+FrequencedItemCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){DisPlayFreq="Y"}
		if ((SelectInstrNotDrugCat!="")&&(("^"+SelectInstrNotDrugCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){DisInstr="Y"}
		if (DisPlayFreq=="Y"){
			$("#CItemFrequence").show();$("#ItemFrequence").next(".combo").show();
			$("#CItemDuration").show();$("#ItemDuration").next(".combo").show();
			$("#CItemFrequence").parent().parent().show();
		}
		else{
			$("#CItemFrequence").hide();$("#ItemFrequence").next(".combo").hide();
			$("#CItemDuration").hide();$("#ItemDuration").next(".combo").hide();
			$("#CItemFrequence").parent().parent().hide();
		}
		if (DisInstr=="Y"){$("#CItemInstruction").show();$("#ItemInstruction").next(".combo").show();}else{$("#CItemInstruction").hide();$("#ItemInstruction").next(".combo").hide();}
		
	}
	//���������ҩ Ҳ���ǲ�ҩ �򵥴μ�����λ����¼��
	if ((ArcimClassification!="RW")&&(ArcimClassification!="RC")){
		$("#CItemDoseUOM").hide();$("#ItemDoseUOM").next(".combo").hide();
	}
	//���������λ��Ϊ�գ�������¼�����
	if (idoseqtystr==""){ 
		$("#CItemDoseQty").hide();$("#ItemDoseQty").hide();
	}else{
	}
	if (ArcimClassification=="RW"){
		$("#COrderSpeedFlowRate,#OrderSpeedFlowRate").show();
		$("#COrderFlowRateUnit").show();$("#OrderFlowRateUnit").next(".combo").show();
	}else{
		$("#COrderSpeedFlowRate,#OrderSpeedFlowRate").hide();
		$("#COrderFlowRateUnit").hide();$("#OrderFlowRateUnit").next(".combo").hide();
	}
	ChangePrescTypeLayout();*/
}
function ChangePrescTypeLayout(){
	if (ARCOSPrescType!="Other") {
		//��ҩҽ�� ����ά��ҽ�����桢����˵�����걾��������λ��������λ\Ƶ�Ρ��Ƴ̡��÷������ٵ�λ
		$("#DHCDocOrderStage,#OrderPriorRemarks,#sampleType,#ItemBillUOM,#ItemDoseUOM,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderFlowRateUnit").combobox('disable');
		$("#OrderSpeedFlowRate").prop("disabled",true);
		m_ArcimClassification="RC"
		DHCDocOrderTypeCombCreat();
	}else{
		$("#DHCDocOrderStage,#OrderPriorRemarks,#sampleType,#ItemBillUOM,#ItemFrequence,#ItemDuration,#ItemInstruction").combobox('enable'); 
	}
}
//��������ʼ����ҽ������Ϣ
function SetARCOSItemMes(ARCOSItemRowid,ARCIMRowid)
{
	var ArcimClassification="",ARCOSItemSubCatDR="",idoseqtystr="";
	if (ARCOSItemRowid!=""){
		 var Str=$.cm({
			ClassName:"web.UDHCFavItemNew",
			MethodName:"GetOneARCOSItem",
			ARCOSItemRowid:ARCOSItemRowid,
			ARCIMRowid:ARCIMRowid,
			dataType:"text"
		 },false);
		 if (ARCIMRowid.indexOf("||")>=0){
			 SearchLimitType="ARCIM";
			 //var Str=tkMakeServerCall("web.UDHCFavItemNew","GetOneARCOSItem",ARCOSItemRowid);
			 var ARCIMDesc=mPiece(Str,"^",0)
			 var ARCOSItemQty=mPiece(Str,"^",1)
			 var ARCOSItemBillUOM=mPiece(Str,"^",2)
			 var ARCOSItemDoseQty=mPiece(Str,"^",3)
			 var ARCOSItemUOM=mPiece(Str,"^",4)
			 var ARCOSItemFrequence=mPiece(Str,"^",5)
			 var ARCOSItemDuration=mPiece(Str,"^",6)
			 var ARCOSItemInstruction=mPiece(Str,"^",7)
			 var ARCOSItemRowid=mPiece(Str,"^",8)
			 var ARCIMRowid=mPiece(Str,"^",9)
			 var ARCOSItemUOMDR=mPiece(Str,"^",10)
			 var ARCOSItemFrequenceDR=mPiece(Str,"^",11)
			 var ARCOSItemDurationDR=mPiece(Str,"^",12)
			 var ARCOSItemInstructionDR=mPiece(Str,"^",13)
			 var ARCOSItemCatDR=mPiece(Str,"^",14)
			 m_Itemcat=ARCOSItemCatDR
			 var ARCOSItemSubCatDR=mPiece(Str,"^",15)
			 m_iorderSubCatID=ARCOSItemSubCatDR;
			 var ARCOSItemOrderType=mPiece(Str,"^",16)
			 var ARCOSItmLinkDoctor=mPiece(Str,"^",17)
			 var Tremark=mPiece(Str,"^",18)
			 var ARCOSDHCDocOrderType=mPiece(Str,"^",19)
			 var ARCOSDHCDocOrderTypeDR=mPiece(Str,"^",20)
			 var SampleID=mPiece(Str,"^",21)
			 var SampleDesc=mPiece(Str,"^",22)
			 var ITMSerialNo=mPiece(Str,"^",23)
			 var OrderPriorRemarksDR=mPiece(Str,"^",24)
			 var OrderPriorRemarks=mPiece(Str,"^",25)
			 var CMSubCategoryFlag=mPiece(Str,"^",26)
			 var DHCDocOrdRecLocDr=mPiece(Str,"^",27)
			 var DHCDocOrderStageCode=mPiece(Str,"^",28)
			 var DHCOrderMustEnter=mPiece(Str,"^",29)
			 if(DHCOrderMustEnter=="Y"){DHCOrderMustEnter=true;}
			 else{DHCOrderMustEnter=false;}
			 var idoseqtystr=mPiece(Str,"^",30)
			 m_idoseqtystr=idoseqtystr;
			 var PackQtyUomRowId=mPiece(Str,"^",31)
			 var SpeedFlowRate=mPiece(Str,"^",32)
			 var FlowRateUnit=mPiece(Str,"^",33)
			 var OrderBodyPartLabel=mPiece(Str,"^",34);
			 var OrderBodyPartLabelText=mPiece(Str,"^",35);
			 var SkinTest=mPiece(Str,"^",36);
			 var SkinTestAction=mPiece(Str,"^",37);
			 var Sensitive=mPiece(Str,"^",38);
			 var NotifyClinician=mPiece(Str,"^",39);
			 var RemoveCeler=mPiece(Str,"^",40);
			 var OrderFreqTimeDoseStr=mPiece(Str,"^",41);
			 var OrderFreqDispTimeStr=mPiece(Str,"^",42);
			 PageLogicObj.m_SameFreqDifferentDosesFlag=mPiece(Str,"^",43);
			 PageLogicObj.m_PHPrescType=mPiece(Str,"^",44);
			 //var ret=tkMakeServerCall("web.DHCDocOrderCommon","GetARCIMDetail",ARCIMRowid);
			 ItemDoseUOMCombCreat(ARCIMRowid,ARCOSItemUOMDR) //��ʼ��������λ
			 sampleTypeCombCreat(ARCIMRowid,SampleID,0) //��ʼ���걾
			 remarkCombCreat(Tremark)//��ע
			 DHCDocOrderRecLocCombCreat(ARCIMRowid,DHCDocOrdRecLocDr,1) //���տ���
			 ARCOSItemDoseQty=ChangeNum(ARCOSItemDoseQty)
			 ARCOSItemQty=ChangeNum(ARCOSItemQty)
			$("#ItemDesc").val(ARCIMDesc);
			$("#ItemRowid").val(ARCIMRowid);
			$("#ItemQty").val(ARCOSItemQty);
			$("#ItmLinkDoctor").val(ARCOSItmLinkDoctor); //����
			$("#ItemDoseUOM").combobox('select',ARCOSItemUOMDR);
			$("#ItemFrequence").combobox('setValue',ARCOSItemFrequenceDR);
			$("#ItemFrequence").combobox('setText',ARCOSItemFrequence);
			$("#ItemDuration").combobox('select',ARCOSItemDurationDR);
		    $("#ItemInstruction").combobox('select',ARCOSItemInstructionDR);
			$("#ItemDoseQty").val(ARCOSItemDoseQty);
			//$("#remark").combobox('setValue',Tremark); //��עѡ��Ϊ�����ȡ����
			
			//$("#sampleType").combobox('select',SampleID); //�걾
			$("#OrderPriorRemarks").combobox('select',OrderPriorRemarksDR); //����˵��
			setTimeout(function(){
				if ($.hisui.indexOfArray($("#DHCDocOrderRecLoc").combobox('getData'),"CombValue",DHCDocOrdRecLocDr)>=0) {
					$("#DHCDocOrderRecLoc").combobox('select',DHCDocOrdRecLocDr); //���տ���
				}
			},500)
			ItemBillUOMCombCreat(ARCIMRowid,PackQtyUomRowId) //����װ��λ
			$("#DHCDocOrderStage").combobox('select',DHCDocOrderStageCode); //ҽ���׶�
			$("#MustEnter").checkbox('setValue', DHCOrderMustEnter); //�ؿ�
			$("#OrderSpeedFlowRate").val(SpeedFlowRate);
			$("#OrderFlowRateUnit").combobox('select',FlowRateUnit);
			if (SkinTest=="Y"){$("#SkinTest").checkbox('setValue', true);}
			$("#SkinAction").combobox('select',SkinTestAction);
			if (NotifyClinician=="Y"){$("#NotifyClinician").checkbox('setValue', true);}
			if (Sensitive!="Y"){$HUI.checkbox('#NotifyClinician').disable();}
			if (RemoveCeler=="Y"){
				$("#RemoveCeler").checkbox('setValue', true);
			}else{
				$("#RemoveCeler").checkbox('setValue', false);
			}
			$("#OrderFreqTimeDoseStr").val(OrderFreqTimeDoseStr);
			$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
			var ArcimClassification=$.cm({
				ClassName:"web.DHCDocOrderCommon",
				MethodName:"GetArcimClassification",
				ArcimRowid:ARCIMRowid,
				dataType:"text"
			 },false);
			 m_ArcimClassification=ArcimClassification;
			 
			 DHCDocOrderTypeCombCreat();
			//var ArcimClassification=tkMakeServerCall("web.DHCDocOrderCommon","GetArcimClassification",ARCIMRowid);
			setTimeout(function(){
				$("#DHCDocOrderType").combobox('select',ARCOSDHCDocOrderTypeDR); //ҽ������
				ChangeFormStyle(ArcimClassification,ARCOSItemSubCatDR,idoseqtystr);
			});
			$("#OrderBodyPartLabelText").val(OrderBodyPartLabelText);
			$("#OrderBodyPartLabel").val(OrderBodyPartLabel);
			InitBodyPartLabel(false);
			if (PageLogicObj.m_SameFreqDifferentDosesFlag=="Y"){
				OrdDoseQtyBindClick();
			}else{
				$("#OrderFreqTimeDoseStr").val("");
				}
		}else{
			var ARCIMDesc=mPiece(Str,"^",0);
			var ARCOSItemRowid=mPiece(Str,"^",8)
			var ARCIMRowid=mPiece(Str,"^",9)
			$("#ItemDesc").val(ARCIMDesc);
			$("#ItemRowid").val(ARCIMRowid);
			SearchLimitType="ARCOS";
			setTimeout(function(){
				ChangeFormStyle("ARCOS","","");
			});
		}
	}else{
		ChangePrescTypeLayout();
	}
}

function ChangeNum(InputNum)
{
	InputNum=InputNum.replace(/(^\s*)|(\s*$)/g,'');
	if (InputNum==""){return ""}
	if (InputNum.indexOf("-")>=0) {
		var NewInputNum="";
		for (var i=0;i<InputNum.split("-").length;i++){
			var FormateInputNum=tkMakeServerCall("web.UDHCFavItemNew","ChangeQty",InputNum.split("-")[i]);
			if (NewInputNum=="") NewInputNum=FormateInputNum;
			else  NewInputNum=NewInputNum+"-"+FormateInputNum;
		}
		return NewInputNum;
	}else{
		InputNum=tkMakeServerCall("web.UDHCFavItemNew","ChangeQty",InputNum);
		return InputNum;
	}
}

function mPiece(Input1,Input2,Input3){
	var OutValue="";
	try{
		 OutValue=Input1.split(Input2)[Input3];
	}catch(e){
		return OutValue;
	}
	return OutValue	
}
function ItmLinkUnique(ARCOSRowid,ItmLinkDoctor,ARCOSItemRowid,ARCIMRowid){
	var rtn=$.cm({
		ClassName:"web.DHCARCOrdSets",
		MethodName:"ItmLinkUnique",
		ARCOSRowid:ARCOSRowid,
		ItmLinkDoctor:ItmLinkDoctor,
		ARCOSItemRowid:ARCOSItemRowid,
		ARCIMRowid:ARCIMRowid,
		dataType:"text"
	},false)
	return rtn;
}
//ͬƵ�β�ͬ�������--start
function OrdDoseQtyBindClick(){
	//�Ƚ���󶨷�ʽclick��ֹ�ظ���
	$("#ItemDoseQty").unbind('click');
	$("#ItemDoseQty").click(function(){
		new Promise(function(resolve,rejected){
			ChangeOrderFreqTimeDoseStr(resolve);
		}).then(function(){
			//SetPackQty(rowid);
		})
	});
}
function ChangeOrderFreqTimeDoseStr(callBackFun){
	var OldItemInstructionID=$("#ItemInstruction").combobox('getValue');
	if ($("#ItemInstruction").combobox('getText')=="") OldItemInstructionID="";
	var ItemInstructionID=CheckComboxSelData("ItemInstruction",OldItemInstructionID);
	if ((WYInstr!="")&&(WYInstr.indexOf("^"+ItemInstructionID+"^")>=0)){
		$("#ItemDoseQty,#OrderFreqTimeDoseStr").val("");
		if (callBackFun) callBackFun();
		return;
	}
	var OrderFreqRowid=$("#ItemFrequence").combobox('getValue');
	var OrderFreqDispTimeStr=$("#OrderFreqDispTimeStr").val();
    if (PageLogicObj.m_SameFreqDifferentDosesFlag=="Y"){
	    var FreqDispTimeDoseQtyStr=$("#OrderFreqTimeDoseStr").val();
	    var FreqDispTimeStr=$.m({
		    ClassName:"web.DHCOEOrdItemView",
		    MethodName:"GetFreqFreqDispTimeStr",
		    OrderFreqRowid:OrderFreqRowid,
		    OrderFreqDispTimeStr:OrderFreqDispTimeStr,
		    type:"text"
		},false);
		if (FreqDispTimeStr.split("!").length==1) {
			$("#OrderFreqTimeDoseStr").val("");
			var OrderDoseQty=$("#ItemDoseQty").val();
			if (OrderDoseQty!="") {
				$("#ItemDoseQty").val(OrderDoseQty.split("-")[0]);
			}
			$("#ItemDoseQty").prop("readonly",false);
			if (callBackFun) callBackFun();
			return;
		}
		var OrderARCIMRowid=$("#ItemRowid").val();
		var OrderName=$("#ItemDesc").lookup('getText');
		var OrderDoseUOM=$("#ItemDoseUOM").combobox('getText');
		new Promise(function(resolve,rejected){
		    ShowFreqQty(FreqDispTimeStr,OrderName,FreqDispTimeDoseQtyStr,OrderDoseUOM,resolve);
		}).then(function(OrderFreqTimeDoseStr){
			if (OrderFreqTimeDoseStr!=""){
				$("#OrderFreqTimeDoseStr").val(OrderFreqTimeDoseStr);
			    var DoseQtyStr=GetDoseQty(OrderFreqTimeDoseStr);
			    $("#ItemDoseQty").val(DoseQtyStr).prop("readonly",true);
			}else{
				$("#OrderFreqTimeDoseStr,#ItemDoseQty").val("");
				$.messager.alert("��ʾ"," ͬƵ�β�ͬ����ҽ������ذ��շַ�ʱ����д����!","info",function(){
					$("#ItemDoseQty").prop("readonly",false);
				})
			}
			if (callBackFun) callBackFun();
		})
	}else{
		if (callBackFun) callBackFun();
	}
}
function ShowFreqQty(FreqDispTimeStr,OrderName,FreqDispTimeDoseQtyStr,OrderDoseUOM,callBackFun) {
	if (FreqDispTimeDoseQtyStr!=""){
		FreqDispTimeDoseQtyStr=FreqDispTimeDoseQtyStr.replace("/||/g","_");	
	}
	var lnk = "dhcdocshowfreq.csp?FreqDispTimeStr=" + FreqDispTimeStr+"&FreqDispTimeDoseQtyStr="+FreqDispTimeDoseQtyStr+"&OrderDoseUOM="+OrderDoseUOM;
	websys_showModal({
		url:lnk,
		title:OrderName+$g(' ������д'),
		width:400,height:300,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
 }
 function GetDoseQty(OrderFreqTimeDoseStr){
	var DoseQtyStr="";
	if (OrderFreqTimeDoseStr=="") return "";
	for (var i=0;i<OrderFreqTimeDoseStr.split("!").length;i++){
		var DoseQty=OrderFreqTimeDoseStr.split("!")[i].split("$")[1];
		if (DoseQtyStr=="") DoseQtyStr=DoseQty;
		else  DoseQtyStr=DoseQtyStr+"-"+DoseQty;
	}
	return DoseQtyStr;
}
//ͬƵ�β�ͬ�������--end

//��Ƶ�����--start
function GetOrderFreqWeekStr(OrderFreqRowid,OrderFreqDispTimeStr,callBackFun){
	var OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(1)).join("A");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(2)).join("B");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.replace(/:/g,"C");
	websys_showModal({
		url:"doc.weekfreqselector.csp?OrderFreqDispTimeStr=" + OrderFreqDispTimeStr+"&OrderFreqRowid="+OrderFreqRowid,
		title:'��Ƶ��ѡ��',
		width:300,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
//��Ƶ�����--end
/**
* @description: ���û�ѡ�񲻹���ַ�ʱ��Ƶ�εķַ�ʱ�䲢����
* @param {String} 
* @return: {String} 
*/
function GetOrderFreqFreeTimeStr(OrderFreqRowid,OrderFreqDispTimeStr,callBackFun){
	var OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(1)).join("A");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.split(String.fromCharCode(2)).join("B");
	OrderFreqDispTimeStr=OrderFreqDispTimeStr.replace(/:/g,"C");
	websys_showModal({
		url:"dhcdoc.freq.disptime.csp?OrderFreqDispTimeStr=" + OrderFreqDispTimeStr+"&OrderFreqRowid="+OrderFreqRowid,
		title:'�ַ�ʱ��ѡ��',
		width:370,height:410,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
	
}

function ItemFrequenceChange(){
	var OrderFreqRowid=$("#ItemFrequence").combobox('getValue');
	 if ($("#ItemFrequence").combobox('getText')=="") OrderFreqRowid="";
	 if (OrderFreqRowid!="") {
		 var FreqInfoStr="";
		 var Data=$("#ItemFrequence").combobox('getData');
		 for(var i=0;i<Data.length;i++){
			 var CombValue=Data[i].CombValue
			 var CombDesc=Data[i].CombDesc
			  if(CombValue==OrderFreqRowid){
				  FreqInfoStr=Data[i].CombValueInfo;
				  break;
		      }
		  }
		  if (FreqInfoStr!="") {
			    var Split_Value = FreqInfoStr.split("!"); //String.fromCharCode(1)
				var WeekFlag = Split_Value[8];
				var FreeTimeFreqFlag = Split_Value[12];
				if (WeekFlag=="Y") {
					new Promise(function(resolve,rejected){
						//��Ƶ��
						var OrderFreqDispTimeStr=""; //$("#OrderFreqDispTimeStr").val();
						GetOrderFreqWeekStr(OrderFreqRowid,OrderFreqDispTimeStr,resolve);
					}).then(function(OrderFreqWeekInfo){
						var OrderFreqDispTimeStr=mPiece(OrderFreqWeekInfo, "^", 0);
						if (OrderFreqDispTimeStr==""){
				            $.messager.alert("��ʾ","��Ƶ�������ѡ��ʹ������!","info",function(){
					            $("#ItemFrequence").combobox('setValue',"");
				            	$("#OrderFreqDispTimeStr").val("");
					        });
				            return;
						}
						var OrderFreqWeekDesc=mPiece(OrderFreqWeekInfo, "^", 1);
						var CalOrderStartDateStr=mPiece(OrderFreqWeekInfo, "^", 2);
						$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
						var OrderFreq=$("#ItemFrequence").combobox('getText')+" "+OrderFreqWeekDesc;
						$("#ItemFrequence").combobox('setText',OrderFreq);
						ChangeOrderFreqTimeDoseStr();
					})
				}else if (FreeTimeFreqFlag=="Y"){
					new Promise(function(resolve,rejected){
						//������ַ�ʱ��
						var OrderFreqDispTimeStr=""; //$("#OrderFreqDispTimeStr").val();
						GetOrderFreqFreeTimeStr(OrderFreqRowid,OrderFreqDispTimeStr,resolve);
					}).then(function(OrderFreqFreeTimeInfo){
						var OrderFreqDispTimeStr=mPiece(OrderFreqFreeTimeInfo, "^", 0);
						if (OrderFreqDispTimeStr==""){
				            $.messager.alert("��ʾ","������ַ�ʱ��Ƶ�������ѡ��ַ�ʱ��!","info",function(){
					            $("#ItemFrequence").combobox('setValue',"");
				            	$("#OrderFreqDispTimeStr").val("");
					        });
				            return;
						}
						var OrderFreqFactor=OrderFreqDispTimeStr.split(String.fromCharCode(1)).length;
						var OrderFreqWeekDesc=mPiece(OrderFreqFreeTimeInfo, "^", 1);
						$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
						var OrderFreq=$("#ItemFrequence").combobox('getText')+" "+OrderFreqWeekDesc;
						$("#ItemFrequence").combobox('setText',OrderFreq);
						ChangeOrderFreqTimeDoseStr();
					})
					
				}else{
					$("#OrderFreqDispTimeStr").val("");
					ChangeOrderFreqTimeDoseStr();
				}
				
		  }
	  }
}
function GetActionCode()
{
	var ActionCode="";
	var ActionID=$('#SkinAction').combobox('getValue');
	if(ActionID){
		var ActionData=$('#SkinAction').combobox('getData');
		$.each(ActionData,function(){
			if(this.CombValue==ActionID){
				ActionCode=this.CombCode;
				return false;
			}
		});
	}
	return ActionCode;
}
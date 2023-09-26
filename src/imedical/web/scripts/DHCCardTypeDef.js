//增加6个属性 2007-12-3
//SearchCardNoMode
//CardNamePlateStr
//ValidateMode
//SupportLossFlag
//SupportExChangeFlag
//SupportFillFlag

//var SearchCardNoModeobj
var CardNamePlateStrobj
var ValidateModeobj
var SupportLossFlagobj
var SupportExChangeFlagobj
var SupportFillFlagobj

var Code;
var Desc;
var PrtINVFlag;
var FareType;
var UseINVType;
var ReclaimFlag;
var DateFrom;
var DateTo;
var DefaultFlag;
var HardComDR;
var BarCodeDR;
var ActiveFlag;
var ReadCardMode;
var CardNoLength;
var SecrityNoFlag;
var UsePANoToCardNO
var CardPayNeedCheckFlag
//var CTD;

var MAdd;
var MUpdate;
var MDelete;
var MId;
var MHardComDR;
var MBarCodeDR;

var mPrtINVFlag,mDefaultFlag,mReclaimFlag,mActiveFlag,mSecrityNoFlag;
var ReadCardFocusElement,CardRefFocusElement,OverWriteFlag,PANoCardRefFlag;
var SearchMasFlag,SetFocusElement,PreCardFlag,CardAccountRelation,CardFareCost;
var INVPRTXMLName,PatPageXMLName,StChangeValidateFlag,mStChangeValidateFlag;
var mSearchCardNoMode,mCardNamePlateStr,mValidateMode;
var mSupportLossFlag,mSupportExChangeFlag,mSupportFillFlag;
var mUsePANoToCardNO,mCardPayNeedCheckFlag

function BodyLoadHandler()
{
	MHardComDR = '';
	MBarCodeDR = '';
	Code = document.getElementById("Code");
	Desc = document.getElementById("Desc");
	UseINVType = document.getElementById("UseINVType");
	PrtINVFlag = document.getElementById("PrtINVFlag");
	if(PrtINVFlag){
		PrtINVFlag.onpropertychange = PrtINVFlagchange;
	}
	FareType = document.getElementById("FareType");
	ReclaimFlag = document.getElementById("ReclaimFlag");
	DateFrom = document.getElementById("DateFrom");
	DateTo = document.getElementById("DateTo");
	DefaultFlag = document.getElementById("DefaultFlag");
	HardComDR = document.getElementById("HardComDR");
	BarCodeDR = document.getElementById("BarCodeComDR");
	ActiveFlag = document.getElementById("ActiveFlag");
	CardNoLength = document.getElementById("CardNoLength");
	ReadCardMode = document.getElementById("ReadCardMode");
	SecrityNoFlag = document.getElementById("SecrityNoFlag");
	
	//SearchCardNoModeobj= document.getElementById("SearchCardNoMode");
	CardNamePlateStrobj= document.getElementById("CardNamePlateStr");
	ValidateModeobj= document.getElementById("ValidateMode");
	SupportLossFlagobj= document.getElementById("SupportLossFlag");
	SupportExChangeFlagobj= document.getElementById("SupportExChangeFlag");
	SupportFillFlagobj= document.getElementById("SupportFillFlag");
	UsePANoToCardNO=document.getElementById("UsePANoToCardNO");
    CardPayNeedCheckFlag=document.getElementById("CardPayNeedCheckFlag");
	//CTD = document.getElementById("CTD");
	MAdd = document.getElementById("MAdd");
	MUpdate = document.getElementById("MUpdate");
	MDelete = document.getElementById("MDelete");
	
	var obj = document.getElementById("Add");
	if (obj) obj.onclick = add_click;
	
	var obj = document.getElementById("Update");
	if (obj) obj.onclick = update_click;
	
	var obj = document.getElementById("Delete");
	if (obj) obj.onclick = delete_click;
	
	if (HardComDR) HardComDR.onchange = HardComDR_changeHandler;	
	if (BarCodeDR) BarCodeDR.onchange = BarCodeDR_changeHandler;
	ReadCardFocusElement = document.getElementById("ReadCardFocusElement");
	CardRefFocusElement = document.getElementById("CardRefFocusElement");
	OverWriteFlag = document.getElementById("OverWriteFlag");
	PANoCardRefFlag = document.getElementById("PANoCardRefFlag");
	
	SearchMasFlag = document.getElementById("SearchMasFlag");
	SetFocusElement = document.getElementById("SetFocusElement");
	PreCardFlag = document.getElementById("PreCardFlag");
	CardAccountRelation = document.getElementById("CardAccountRelation");
	CardFareCost = document.getElementById("CardFareCost");
	
	INVPRTXMLName = document.getElementById("INVPRTXMLName");
	PatPageXMLName = document.getElementById("PatPageXMLName");
	StChangeValidateFlag = document.getElementById("StChangeValidateFlag");
    var obj=document.getElementById("SearchCardNoModeConfig");
	if(obj){
		obj.onclick=SearchCardNoModeConfigclick;
	}
	initList();
	if (UsePANoToCardNO){
		UsePANoToCardNO.onclick=UsePANoToCardNO_Click;
	}
}
function SearchCardNoModeConfigclick()
{
	window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHCCardTypeDefExt", '', "top=200,left=700,width=300,height=200,status=yes,scrollbars=yes");
}
function HardComDR_changeHandler()
{
	if (HardComDR.value.trim() == '')	 MHardComDR='';
}
function BarCodeDR_changeHandler()
{
		if (BarCodeDR.value.trim() == '')	 MBarCodeDR='';
		
}
function initList()
{
	if (FareType)	
	{
		FareType.size = 1;
		FareType.multiple = false;
		//FareType.options.add(new Option("NOPay","NP"));
		//FareType.options.add(new Option("Charge","C"));			
	}
	
	if (UseINVType)
	{
			UseINVType.size = 1;
			UseINVType.multiple = false;
			if(PrtINVFlag.checked){UseINVType.disabled = false;}
			else{UseINVType.disabled = true;}
			//UseINVType.options.add(new Option("InPatient","I"));
			//UseINVType.options.add(new Option("OutPatient","O"));	
			//UseINVType.options.add(new Option("Emergency","E"));			
	}

	if (ReadCardMode)
	{
			ReadCardMode.size = 1;
			ReadCardMode.multiple = false;
	}
	
	if (ReadCardFocusElement)
	{
			ReadCardFocusElement.size = 1;
			ReadCardFocusElement.multiple = false;
	}
	
	if (CardRefFocusElement)
	{
			CardRefFocusElement.size = 1;
			CardRefFocusElement.multiple = false;
	}
	
	if (OverWriteFlag)
	{
			OverWriteFlag.size = 1;
			OverWriteFlag.multiple = false;
	}
	
	if (PANoCardRefFlag)
	{
			PANoCardRefFlag.size = 1;
			PANoCardRefFlag.multiple = false;
	}

	if (SearchMasFlag)
	{
			SearchMasFlag.size = 1;
			SearchMasFlag.multiple = false;
	}
	
	if (SetFocusElement)
	{
			SetFocusElement.size = 1;
			SetFocusElement.multiple = false;
	}
	
	if (PreCardFlag)
	{
			PreCardFlag.size = 1;
			PreCardFlag.multiple = false;
	}
	
	if (CardAccountRelation)
	{
			CardAccountRelation.size = 1;
			CardAccountRelation.multiple = false;
	}
	
	if (StChangeValidateFlag)
	{
		StChangeValidateFlag.size = 1;
		StChangeValidateFlag.multiple = false;	
	}
	/*if (SearchCardNoModeobj){
		SearchCardNoModeobj.size=1;
		SearchCardNoModeobj.multiple=false;
	}*/

	if (ValidateModeobj){
		ValidateModeobj.size=1;
		ValidateModeobj.multiple=false;
	}
}


function SelectRowHandler()
{
	//try
	//{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCApptSchedule_List');
	var tables = document.getElementsByTagName("table");
	if (!objtbl) objtbl = tables[2];
	if (!objtbl) return ;
	var rows=objtbl.rows.length;

	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	var Sel_Code=document.getElementById("TCodez"+selectrow);
	var Sel_Desc=document.getElementById('TDescz'+selectrow);
	var Sel_PrtINVFlag=document.getElementById('TPrtINVFlagz'+selectrow);
	var Sel_FareType=document.getElementById('TFareTypez'+selectrow);
	var Sel_UseINVType=document.getElementById('TUseINVTypez'+selectrow);
	var Sel_ReclaimFlag=document.getElementById('TReclaimFlagz'+selectrow);
	var Sel_DateFrom=document.getElementById('TDateFromz'+selectrow);
	var Sel_DateTo=document.getElementById('TDateToz'+selectrow);
	var Sel_DefaultFlag = document.getElementById('TDefaultFlagz'+selectrow);
	var Sel_Id = document.getElementById('TIdz'+selectrow);
	var Sel_HardComDR = document.getElementById('THardComDRz'+selectrow);
	var Sel_BarCodeDR = document.getElementById('TBarCodeDRz'+selectrow);
	var Sel_HardComName = document.getElementById('THardComNamez'+selectrow);
	var Sel_BarCodeName = document.getElementById('TBarCodeNamez'+selectrow);
	var Sel_ActiveFlag = document.getElementById('TActiveFlagz'+selectrow);
	var Sel_ReadCardMode = document.getElementById('TReadCardModez'+selectrow);
	var Sel_CardNoLength = document.getElementById('TCardNoLengthz'+selectrow);
	var Sel_SecrityNoFlag = document.getElementById('TSecrityNoFlagz'+selectrow);
	//var Sel_CTD = document.getElementById('TCTDz'+selectrow);
  var Sel_ReadCardFocusElement = document.getElementById('TReadCardFocusElementz'+selectrow);
  var Sel_CardRefFocusElement = document.getElementById('TCardRefFocusElementz'+selectrow);
  var Sel_OverWriteFlag = document.getElementById('TOverWriteFlagz'+selectrow);
  var Sel_PANoCardRefFlag = document.getElementById('TPANoCardRefFlagz'+selectrow);
  
  var Sel_SearchMasFlag = document.getElementById('TSearchMasFlagz'+selectrow);
  var Sel_SetFocusElement = document.getElementById('TSetFocusElementz'+selectrow);
  var Sel_PreCardFlag = document.getElementById('TPreCardFlagz'+selectrow);
  var Sel_CardAccountRelation = document.getElementById('TCardAccountRelationz'+selectrow);
  var Sel_CardFareCost =  document.getElementById('TCardFareCostz'+selectrow);
  
  var Sel_INVPRTXMLName =  document.getElementById('TINVPRTXMLNamez'+selectrow);
  var Sel_PatPageXMLName =  document.getElementById('TPatPageXMLNamez'+selectrow);
  var Sel_StChangeValidateFlag =  document.getElementById('TStChangeValidateFlagz'+selectrow);
  
  var Sel_SearchCardNoMode =  document.getElementById('TSearchCardNoModez'+selectrow);
  var Sel_CardNamePlateStr =  document.getElementById('TCardNamePlateStrz'+selectrow);
  var Sel_ValidateMode =  document.getElementById('TValidateModez'+selectrow);
  var Sel_SupportLossFlag =  document.getElementById('TSupportLossFlagz'+selectrow);
  var Sel_SupportExChangeFlag =  document.getElementById('TSupportExChangeFlagz'+selectrow);
  var Sel_SupportFillFlag =  document.getElementById('TSupportFillFlagz'+selectrow);
  var Sel_UsePANoToCardNO=  document.getElementById('TUsePANoToCardNOz'+selectrow);
  var Sel_CardPayNeedCheckFlag=  document.getElementById('TCardPayNeedCheckFlagz'+selectrow);

  
	if (rowObj.className != "clsRowSelected")
	{
		Code.value = '';
		Desc.value = '';
		PrtINVFlag.checked = false;
		FareType.selectedIndex = 0;
		UseINVType.selectedIndex = 0;
		ReclaimFlag.checked = false;
		DateFrom.value = '';
		DateTo.value = '';
		DefaultFlag.checked = false;
		MId = '';
		MHardComDR = '';
		MBarCodeDR = '';
		HardComDR.value = '';
		BarCodeDR.value = '';
		ActiveFlag.checked = false;
		ReadCardMode.selectedIndex = 0;
		CardNoLength.value = '';
		SecrityNoFlag.checked = false;
		//CTD.checked = false;
		ReadCardFocusElement.selectedIndex = -1;
		CardRefFocusElement.selectedIndex = -1;	
		OverWriteFlag.selectedIndex = 0;
		PANoCardRefFlag.selectedIndex = 0;
		
		SearchMasFlag.selectedIndex = 0;
		SetFocusElement.selectedIndex = -1;
		PreCardFlag.selectedIndex = 0;
		CardAccountRelation.selectedIndex = 0;
		CardFareCost.value = '';
		
		INVPRTXMLName.value = '';
		PatPageXMLName.value = '';
		StChangeValidateFlag.selectedIndex = 0;
		
		//SearchCardNoModeobj.selectedIndex = 0;
	   CardNamePlateStrobj.value='';
	   ValidateModeobj.selectedIndex = 0;
	   SupportLossFlagobj.checked = false;
	   SupportExChangeFlagobj.checked = false;
	   SupportFillFlagobj.checked = false;
	   UsePANoToCardNO.checked=false;
	   CardPayNeedCheckFlag.checked=false;
	}
	else
	{
		Code.value = Sel_Code.innerText.trim();
		Desc.value = Sel_Desc.innerText.trim();
		PrtINVFlag.checked = (Sel_PrtINVFlag.innerText.trim()=='Y');
		selectedList(FareType,Sel_FareType.innerText.trim());
		selectedList(UseINVType,Sel_UseINVType.innerText.trim());
		ReclaimFlag.checked = (Sel_ReclaimFlag.innerText.trim()=='Y');
		DateFrom.value = Sel_DateFrom.innerText.trim();
		DateTo.value = Sel_DateTo.innerText.trim();
		DefaultFlag.checked = (Sel_DefaultFlag.innerText.trim() == 'Y');
		
		MId = Sel_Id.value;
		MHardComDR = Sel_HardComDR.value;
		MBarCodeDR = Sel_BarCodeDR.value;
		HardComDR.value = Sel_HardComName.value;
		BarCodeDR.value = Sel_BarCodeName.value;
		
		ActiveFlag.checked = (Sel_ActiveFlag.value.trim() == 'IE');
		selectedList(ReadCardMode,Sel_ReadCardMode.value.trim());
		CardNoLength.value = Sel_CardNoLength.value;
		SecrityNoFlag.checked = (Sel_SecrityNoFlag.value.trim() == 'Y');
		//CTD.checked = (Sel_DefaultFlag.innerText.trim() == 'Y');
		
		selectedList(ReadCardFocusElement,Sel_ReadCardFocusElement.value.trim());
		selectedList(CardRefFocusElement,Sel_CardRefFocusElement.value.trim());
		selectedList(OverWriteFlag,Sel_OverWriteFlag.value.trim());
		selectedList(PANoCardRefFlag,Sel_PANoCardRefFlag.value.trim());
		
		selectedList(SearchMasFlag,Sel_SearchMasFlag.value.trim());
		selectedList(SetFocusElement,Sel_SetFocusElement.value.trim());
		selectedList(PreCardFlag,Sel_PreCardFlag.value.trim());
		selectedList(CardAccountRelation,Sel_CardAccountRelation.value.trim());
		CardFareCost.value = Sel_CardFareCost.value.trim();
		
		INVPRTXMLName.value = Sel_INVPRTXMLName.value.trim();
		PatPageXMLName.value = Sel_PatPageXMLName.value.trim();
		selectedList(StChangeValidateFlag,Sel_StChangeValidateFlag.value.trim());
		
		//SearchCardNoModeobj.value = Sel_SearchCardNoMode.value.trim();
	  CardNamePlateStrobj.value=Sel_CardNamePlateStr.value.trim();
	  ValidateModeobj.value = Sel_ValidateMode.value.trim();
	  SupportLossFlagobj.checked = (Sel_SupportLossFlag.value.trim() == 'Y');
	  SupportExChangeFlagobj.checked = (Sel_SupportExChangeFlag.value.trim() == 'Y');
	  SupportFillFlagobj.checked = (Sel_SupportFillFlag.value.trim() == 'Y');
	  UsePANoToCardNO.checked=(Sel_UsePANoToCardNO.value.trim() == 'Y');
      CardPayNeedCheckFlag.checked=(Sel_CardPayNeedCheckFlag.value.trim() == 'Y');
	}	
	UsePANoToCardNO_Click()
	SelectedRow = selectrow;
	
}

function SelectHardCom(str)
{
	if (str)
	{
		var strArray = str.split("^");	
		if (strArray.length>1)
		{
			MHardComDR = strArray[1];	
		}
	}
}

function SelectBarCodeCom(str)
{
	if (str)
	{
		var strArray = str.split("^");	
		if (strArray.length>1)
		{
			MBarCodeDR = strArray[1];	
		}
	}
}
function selectedList(obj,str)
{
	if (!obj) return ;
	if (!obj.length) return ;
	obj.selectedIndex = -1;
	for(var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].value == str)	
		{
			obj.selectedIndex = i;
			break;	
		}
	}
}
function add_click()
{
	if (!validate()) return false;
	
	//alert(mPrtINVFlag + ':' + mDefaultFlag + ':' +mReclaimFlag);
	
	if (MAdd) {
		if (MAdd.value == '')	 return ;
		try
		{
		//alert(MAdd.value+'\r\n'+Code.value+':'+Desc.value+':'+mPrtINVFlag+':'+FareType.value+':'
		//+UseINVType.value+':'+mReclaimFlag+':'+DateFrom.value+':'+DateTo.value+':'+mDefaultFlag);
		
		var mReadCardFocusElement = '',mCardRefFocusElement = '',mOverWriteFlag = '',mPANoCardRefFlag = '';
		if (ReadCardFocusElement.selectedIndex != -1) 			
			mReadCardFocusElement = ReadCardFocusElement.options[ReadCardFocusElement.selectedIndex].value;
			
		if (CardRefFocusElement.selectedIndex != -1) 		
			mCardRefFocusElement = CardRefFocusElement.options[CardRefFocusElement.selectedIndex].value;
			
		if (OverWriteFlag.selectedIndex != -1) 			
			mOverWriteFlag = OverWriteFlag.options[OverWriteFlag.selectedIndex].value;
			
		if (PANoCardRefFlag.selectedIndex != -1) 		
			mPANoCardRefFlag = PANoCardRefFlag.options[PANoCardRefFlag.selectedIndex].value;
		
		var mSearchMasFlag = '',mSetFocusElement = '',mPreCardFlag = '',mCardAccountRelation = '';
		if (SearchMasFlag.selectedIndex != -1) 		
			mSearchMasFlag = SearchMasFlag.options[SearchMasFlag.selectedIndex].value;
			
		if (SetFocusElement.selectedIndex != -1) 		
			mSetFocusElement = SetFocusElement.options[SetFocusElement.selectedIndex].value;
			
		if (PreCardFlag.selectedIndex != -1) 		
			mPreCardFlag = PreCardFlag.options[PreCardFlag.selectedIndex].value;
			
		if (CardAccountRelation.selectedIndex != -1) 		
			mCardAccountRelation = CardAccountRelation.options[CardAccountRelation.selectedIndex].value;
			
		if (StChangeValidateFlag.selectedIndex != -1)
			mStChangeValidateFlag = StChangeValidateFlag.options[StChangeValidateFlag.selectedIndex].value;
		
		
		//if (SearchCardNoModeobj.selectedIndex != -1)
			mSearchCardNoMode = "" //SearchCardNoModeobj.options[SearchCardNoModeobj.selectedIndex].value;
			
		mCardNamePlateStr = CardNamePlateStrobj.value;
			
		if (ValidateModeobj.selectedIndex != -1)
			mValidateMode = ValidateModeobj.options[ValidateModeobj.selectedIndex].value;
		
		var ret = cspHttpServerMethod(MAdd.value,Code.value.trim(),Desc.value.trim(),mPrtINVFlag,FareType.options[FareType.selectedIndex].value,
												UseINVType.options[UseINVType.selectedIndex].value,mReclaimFlag,DateFrom.value.trim(),DateTo.value.trim(),
												mDefaultFlag,MHardComDR,MBarCodeDR,mActiveFlag,ReadCardMode.options[ReadCardMode.selectedIndex].value,CardNoLength.value,
												mSecrityNoFlag,mReadCardFocusElement,mCardRefFocusElement,mOverWriteFlag,mPANoCardRefFlag,
												mSearchMasFlag,mSetFocusElement,mPreCardFlag,mCardAccountRelation,CardFareCost.value,
												INVPRTXMLName.value,PatPageXMLName.value,mStChangeValidateFlag,
												mSearchCardNoMode,mCardNamePlateStr,mValidateMode,
												mSupportLossFlag,mSupportExChangeFlag,mSupportFillFlag,mUsePANoToCardNO,mCardPayNeedCheckFlag);

		switch (parseInt(ret))										
		{
			case 0:
				alert('新增卡类型成功!');
				var lnk="websys.csp?a=a&TMENU=50104&TPAGID=128072910"
				location.href = lnk;
				break;	
			default:
				alert('新增卡类型发生错误!');
				break;
		}
	}
	catch(ex)
	{
			alert(ex.message);
		}												
	}
}

function update_click()
{
		if (MId == '')	
		{
				alert('请选中要更新的记录!');
				return ;
		}		
	if (!validate()) return false;
	//alert(mPrtINVFlag + ':' + mDefaultFlag + ':' +mReclaimFlag);
	if (MUpdate) {
		if (MUpdate.value == '')	 return ;		
		
		//alert(MUpdate.value+'\r\n'+MId+':'+Code.value+':'+Desc.value+':'+mPrtINVFlag+':'+FareType.value+':'
		//+UseINVType.value+':'+mReclaimFlag+':'+DateFrom.value+':'+DateTo.value+':'+mDefaultFlag+':'
		//+ReadCardFocusElement.selectedIndex);
		
		//alert(MHardComDR+':'+MBarCodeDR);
		
		try
		{
		//2007-11-29
		var mReadCardFocusElement = '',mCardRefFocusElement = '',mOverWriteFlag = '',mPANoCardRefFlag = '';
		if (ReadCardFocusElement.selectedIndex != -1) 			
			mReadCardFocusElement = ReadCardFocusElement.options[ReadCardFocusElement.selectedIndex].value;
				
		if (CardRefFocusElement.selectedIndex != -1) 		
			mCardRefFocusElement = CardRefFocusElement.options[CardRefFocusElement.selectedIndex].value;
			
		if (OverWriteFlag.selectedIndex != -1) 			
			mOverWriteFlag = OverWriteFlag.options[OverWriteFlag.selectedIndex].value;
			
		if (PANoCardRefFlag.selectedIndex != -1) 		
			mPANoCardRefFlag = PANoCardRefFlag.options[PANoCardRefFlag.selectedIndex].value;
		
		//2007-11-30
		var mSearchMasFlag = '',mSetFocusElement = '',mPreCardFlag = '',mCardAccountRelation = '';
		if (SearchMasFlag.selectedIndex != -1) 		
			mSearchMasFlag = SearchMasFlag.options[SearchMasFlag.selectedIndex].value;
			
		if (SetFocusElement.selectedIndex != -1) 		
			mSetFocusElement = SetFocusElement.options[SetFocusElement.selectedIndex].value;
			
		if (PreCardFlag.selectedIndex != -1) 		
			mPreCardFlag = PreCardFlag.options[PreCardFlag.selectedIndex].value;
			
		if (CardAccountRelation.selectedIndex != -1) 		
			mCardAccountRelation = CardAccountRelation.options[CardAccountRelation.selectedIndex].value;
		
		if (StChangeValidateFlag.selectedIndex != -1)
			mStChangeValidateFlag = StChangeValidateFlag.options[StChangeValidateFlag.selectedIndex].value;
			
		
		//if (SearchCardNoModeobj.selectedIndex != -1)
			mSearchCardNoMode = "" //SearchCardNoModeobj.options[SearchCardNoModeobj.selectedIndex].value;
			
		mCardNamePlateStr = CardNamePlateStrobj.value;
			
		if (ValidateModeobj.selectedIndex != -1)
			mValidateMode = ValidateModeobj.options[ValidateModeobj.selectedIndex].value;	
		
		var ret = cspHttpServerMethod(MUpdate.value,MId,Code.value.trim(),Desc.value.trim(),mPrtINVFlag,FareType.options[FareType.selectedIndex].value,
												UseINVType.options[UseINVType.selectedIndex].value,mReclaimFlag,DateFrom.value.trim(),DateTo.value.trim(),
												mDefaultFlag,MHardComDR,MBarCodeDR,mActiveFlag,ReadCardMode.options[ReadCardMode.selectedIndex].value,CardNoLength.value,mSecrityNoFlag,
												mReadCardFocusElement,mCardRefFocusElement,mOverWriteFlag,mPANoCardRefFlag,
												mSearchMasFlag,mSetFocusElement,mPreCardFlag,mCardAccountRelation,CardFareCost.value,
												INVPRTXMLName.value,PatPageXMLName.value,mStChangeValidateFlag,
												mSearchCardNoMode,mCardNamePlateStr,mValidateMode,
												mSupportLossFlag,mSupportExChangeFlag,mSupportFillFlag,mUsePANoToCardNO,mCardPayNeedCheckFlag);
		
		switch (parseInt(ret))										
		{
			case 0:
				alert('修改卡类型成功!');
				window.location.reload();
				break;	
			default:
				alert('修改卡类型发生错误!');
				break;
		}
	}catch(ex)
	{
		alert(ex.message);
		}
	}
	return websys_cancel();
}

function delete_click()
{
	//if (!validate()) return false;
	if (MId)
	{
		if (MId == '')	
		{
				alert('请选中要删除的记录!');
				return ;
		}
		
		if (MDelete)
		{
				var ret = cspHttpServerMethod(MDelete.value,MId);
				switch (parseInt(ret))										
				{
					case 1:
						alert('删除卡类型成功!');
						location.href = location.href;
						break;	
					default:
						alert('删除卡类型发生错误!');
						break;
				}
		}
	}
}

function validate()
{
	
	if (Code.value.trim() == '')	
	{
		alert('类型代码不能为空!');
		Code.focus();
		return false;
	}
	if (Desc.value.trim() == '')	
	{
		alert('类型描述不能为空!');
		Desc.focus();
		return false;
	}
	if (DateFrom.value.trim() == '')	
	{
		alert('生效日期不能为空!');
		DateFrom.focus();
		return false;
	}
	/*
	//DHCC_DateCompare方法在DHCOPAdm.Common.js中
	var DateFrom=DHCC_GetElementData("DateFrom");
	var DateTo=DHCC_GetElementData("DateTo");
	var DateCompare=DHCC_DateCompare(DateTo,DateFrom);
	if (!DateCompare) {
		alert('生效日期不能大于失效日期!');
		if (DateFrom) DateFrom.focus();
		return false;
	}
	*/
	
	mPrtINVFlag  = (PrtINVFlag.checked?'Y':'N');
	mDefaultFlag  = (DefaultFlag.checked?'Y':'N');
	mReclaimFlag  = (ReclaimFlag.checked?'Y':'N');
	mActiveFlag  = (ActiveFlag.checked?'IE':'SU');
	mSecrityNoFlag  = (SecrityNoFlag.checked?'Y':'N');		
	mSupportLossFlag = (SupportLossFlagobj.checked?'Y':'N');		
	mSupportExChangeFlag = (SupportExChangeFlagobj.checked?'Y':'N');		
	mSupportFillFlag = (SupportFillFlagobj.checked?'Y':'N');
	mUsePANoToCardNO = (UsePANoToCardNO.checked?'Y':'N');
	mCardPayNeedCheckFlag=(CardPayNeedCheckFlag.checked?'Y':'N');
	var FareType = document.getElementById("FareType");
	var FareType=FareType.options[FareType.selectedIndex].value
	var CardFareCost=document.getElementById("CardFareCost").value
	if((FareType=="C")&&(+CardFareCost=="0")){
		alert(Desc.value.trim()+"收费标志是Charge,支付的金额不能为空或0")
		return false;
	}
	return true;
	
}

function PrtINVFlagchange(){
	if(PrtINVFlag.checked){UseINVType.disabled = false;}
	else{UseINVType.disabled = true;}
}

document.body.onload = BodyLoadHandler;

String.prototype.trim = function() {
	var str;
	var i;
	//left	
	str = this;
	for(i=0;i<str.length;i++)
	{
		if(str.charAt(i)!=" " && str.charAt(i)!=" ") break;
	}
	str=str.substring(i,str.length);
	
	//right
	for(i=str.length-1;i>=0;i--)
	{
		if(str.charAt(i)!=" " && str.charAt(i)!=" ") break;
	}
	str=str.substring(0,i+1);	
	return str;
}

///使用登记号作为卡号卡长度设置改为登记号长度
function UsePANoToCardNO_Click()
{
	
	var Obj= document.getElementById("PAPMONOLength");
	if (Obj){
		if (UsePANoToCardNO.checked){
			var PAPMONOLength=Obj.value
			if (CardNoLength){
				CardNoLength.value=PAPMONOLength
				CardNoLength.disabled=true
			}
		}else{
			CardNoLength.disabled=false
		}
		
	}
	
	
}
///---------------------------
///Modified By ZY 2010-8-18
///��������:GetLookUpID_Table
///	    TTime_changehandler
///	    TDate_changehandler
///	    LookUpTableDate
///	    HiddenTblColumn	   
///---------------------------
///Modified By JDL 2010-8-18
///��������:ReadOnlyElements
///	    Standard_TableKeyUp
///	    GetColCaption
///	    SourceInfo
///	    HiddenObj	    	
///---------------------------
///�޸�?ZY 2009-10-28 ZY0013
///�޸ĺ���:GetModel,GetManuFactory,GetProvider
///��������:GetPYCode
///---------------------------
///Modified by JDL JDL0011
///Modified Method GetShortName
///------------------------------
var curUserID,curUserCode,curUserName,curLocID,curLocName  // add by zx 20181021 ȫ�ֱ������ı�
var EquipGlobalLen=95; //2009-11-16 ���� DJ0035
var errcode=1000;
var BElement   //=new array;
//Modified by JDL �޸���ʽ������
//document.styleSheets[0].addImport("DHCEQStyle.css",0);
//document.write("<LINK REL='stylesheet' TYPE='text/css' HREF='../scripts/DHCEQStyle.css'></LINK>")
///modify by lmm 2018-08-01
///������Σ�vBuss ҵ�����
function InitUserInfo(vBuss)
{
	var userInfo=getSessionIDByMap("userinfo",session['LOGON.USERID']).split("^");
	curUserID=userInfo[0];
	curUserCode=userInfo[1];
    curUserName=userInfo[2];
    var locInfo=getSessionIDByMap("deptinfo",session['LOGON.CTLOCID']).split("^");
    curLocID=locInfo[0]
    curLocName=locInfo[1]
    BElement=new Array;
    BElementDeclare();
    InitMessage(vBuss);
    GetDisabledElement();
    //�˵�������
    
    var obj=document.getElementById("GetMenuName");
    if (obj)
    {
	    var GetMenuName=GetElementValue("GetMenuName")
	    var obj=document.getElementById("cEQTitle");
	    if ((obj)&&(GetMenuName!=""))
	    {
		    SetCElement("cEQTitle",GetMenuName)  //add by lmm 2018-08-13
	    }
    }
    /*
    var obj=document.getElementById("BUpdate");		//Add By DJ 2016-11-21
    if (obj)
    {
	    var innerHTMLStr=obj.innerHTML;
	    innerHTMLStr=innerHTMLStr.replace("����","����");
	    obj.innerHTML=innerHTMLStr
    }
    */   
}
function EQCommon_HiddenElement(name)
{
	var obj=document.getElementById(name);
	if (obj){	
	obj.style.visibility="hidden";
	//obj.style.display="none";
	}
}



function SetEnableStyle(obj,value)
{
	if (obj){
		if (obj.type=="checkbox") return;	//disabledField
		//obj.className= (value==true)?"EQDisabledINPUT":"EQEnabledINPUT";	//modified by czf	
		}		
}
function DisableLookup(name,value)
{
	DisableElement(name,value);
	DisableElement("ld"+GetElementValue("GetComponentID")+"i"+name,value);
}

function GetLookupName(name)
{
	return "ld"+GetElementValue("GetComponentID")+"i"+name
}

//modify by lmm 2018-02-01
function DisableBElement(vElementID,vValue)
{ 
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//��ť�һ�����
			jQuery("#"+vElementID).linkbutton("disable")

			//���ť�¼�
			//jQuery("#"+vElementID).unbind();
			//var ibtncss=jQuery("#"+vElementID).attr("class")
			//ibtncss=ibtncss+" l-btn-disabled"
			//jQuery("#"+vElementID).attr("class",ibtncss)
			
		}
		else
		{
			//��ť����
			jQuery("#"+vElementID).linkbutton("enable")
			//ibtncss="hisui-linkbutton l-btn l-btn-small l-btn-disabled"
			//jQuery("#"+vElementID).attr("class",ibtncss)
		}
	}
}

function LinkDisable(evt) {
}

function SetDefaultValue(ename,evalue)
{
	var obj;
	obj=document.getElementById(ename);
	if (obj){
		if (!obj.disabled&obj.value=="") obj.value=evalue;	
		}
}

function SetCElement(ename,evalue)
{
	
	var obj;
	obj=document.getElementById(ename);

	if(obj)        
	{
		SetElement(ename,evalue)
	}
}
//modify by lmm 2018-02-01
function SetChkElement(vElementID,vValue)
{	
	
		var objType=jQuery("#"+vElementID).prop("type")
		var objClassInfo=jQuery("#"+vElementID).prop("class")
	if ((vValue=="1")||(vValue=="true")||(vValue=="Y"))
	{
		jQuery("#"+vElementID).checkbox("setValue",true);  
	}
	if ((vValue=="0")||(vValue=="false")||(vValue=="N")||(vValue==""))
	{
		jQuery("#"+vElementID).checkbox("setValue",false);
	}
	
	
		/*
	var obj;
	obj=document.getElementById(ename);
	if (obj)	
	{	
		if (evalue==1) 
			{obj.checked=1;	}
		else
			{obj.checked=0;	}
	}*/

}
//modify by lmm 2018-02-01
function GetCElementValue(vElementID)  
{
	
	var obj=document.getElementById(vElementID);
	if (obj) return jQuery("#"+vElementID).text();
	return ""
		
}

function GetChkElementValue(ename)
{
	var obj,evalue;
	evalue="";
	obj=document.getElementById(ename);
	if (obj)	{	evalue=obj.checked;	}
	return evalue;
}


///���¸���Look Upȡ�豸������ID

function GetCatID(value)
{
	GetLookUpID('EquiCatDR',value);
}

function GetModelID(value)
{
	GetLookUpID('ModelDR',value);
}

function GetToDeptID(value)
{
		GetLookUpID('ToDeptDR',value);
	//('ToDeptDR',value);
}

function GetFromDeptID(value)
{	
	GetLookUpID('FromDeptDR',value);
}

function GetPurchaseTypeID(value)
{
	GetLookUpID('PurchaseTypeDR',value);	
}

function GetDepreMethodID(value)
{
	GetLookUpID('DepreMethodDR',value);	
}

function GetOriginID(value)
{
	GetLookUpID('OriginDR',value);	
}

function GetBuyTypeID(value)
{
	GetLookUpID('BuyTypeDR',value);	
}

function GetUseLocID(value)
{
	GetLookUpID('UseLocDR',value);
}

function GetManageLocID(value)
{
	GetLookUpID('ManageLocDR',value);	
}

function GetInstallLocID(value)
{
	GetLookUpID('InstallLocDR',value);	
}

function GetMaintUserID(value)
{
	GetLookUpID('MaintUserDR',value);	
}

function GetCountryID(value)
{
	GetLookUpID('CountryDR',value);	
}

function GetWorkLoadUnitID(value)
{
	GetLookUpID('WorkLoadUnitDR',value);	
}

function GetUnitID(value)
{
	GetLookUpID('UnitDR',value);	
}

function GetManuFactoryID(value)
{
	GetLookUpID('ManuFactoryDR',value);	
}

function GetProviderID(value)
{
	GetLookUpID('ProviderDR',value);	
}

function GetEquipStatusID(value)
{
	GetLookUpID('Status',value);	
}
///modify by lmm 2020-06-29
///���ӻس���ֵ����ת��һ�����
function GetLookUpID(ename,value)
{
	var val=value.split("^");
	var obj=document.getElementById(ename);
	if (obj)	{	obj.value=val[1];
	//modify by lmm 2020-07-01
		var event = event||window.event;
		if (event)
		{
			var keyCode=event.which||event.keyCode
			if (keyCode==13)
			{
				var vElementID=String(ename)
				if ($("#"+vElementID.substr(0,vElementID.length-2)).attr("id")!=undefined)
				{
					var vElementID=$("#"+vElementID.substr(0,vElementID.length-2)).attr("id")
					lookuptab(vElementID)
					tabflag=1
				}
			}	
		}
	}
	else {messageShow("","","",ename);}		
}

function ClearComboData(ElementName)
{
	SetElement(ElementName+"DR","")
}
	
function GetDisabledElement()
{
	GetOneTypeDisabledElement( "input" );
	GetOneTypeDisabledElement( "textarea" );
}
function GetOneTypeDisabledElement(Name)
{
	var All = document.getElementsByTagName( Name );
	var Length = All.length;
	var BReturn=false;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].disabled)
		{
			var Name=All[I].name;
			var obj=document.getElementById(Name);
			SetEnableStyle(obj,true)
		}
	}
}


function DisableAllTxt()
{
	var All = document.getElementsByTagName("input");
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		All[I].disabled=true;
	}
	All = document.getElementsByTagName("textarea");
	Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		All[I].disabled=true;
	}
}

///����״̬�ж���Щ��ť������
function SetDisableButton(status,needsubmit)
{
	if (status==0)	
	{
		if (needsubmit)
		{
			DisableBElement("BCancelSubmit",true);
			DisableBElement("BAudit",true);
		}
	}
	else if (status==1)		//�ύ
	{	
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	else if (status==2)   //���
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
}

function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}


function SetEQStyle()
{
	document.styleSheets[0].addImport("DHCEQStyle.css",0);	
	var All = document.getElementsByTagName( "INPUT" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		try
		{
			if (All[I].type!="checkbox")
			{
				//All[I].style.border="none";
				All[I].className="EQINPUT";
				//All[I].style.width="16px";
			}
		}
		catch(e)
		{}
	}
}
///"Opinion_"+Role+"_"+Step
function PageInsertRows(ElementName,ValList)
{
	if (ValList=="") return;
	var Rows=+GetElementValue("BeginInsertRow");
	var ColSpanNum=+GetElementValue("ColSpanNum");
	var tbl=GetParentTable(ElementName);
	if (tbl)
	{
		OneRecord=ValList.split("^");
		for(var i = 0;i < OneRecord.length;i++)
		{
			var Row1=Rows - 1 ;
			var Row2=Rows;
			tbl.insertRow(Row2);
			tbl.rows[Row2].insertCell();
			tbl.rows[Row2].insertCell();
			tbl.rows[Row2].cells[0].align="right";
			tbl.rows[Row2].cells[0].vAlign="top";
			tbl.rows[Row2].cells[1].colSpan=ColSpanNum;
			Rows=Rows + 1;
			var val=OneRecord[i].split(",");
			tbl.rows[Row1].cells[0].innerHTML="<label id='cOpinion_"+val[1]+"_"+val[0]+"'  Style='HEIGHT: 24px'>"+val[2]+"</label>";
			tbl.rows[Row1].cells[1].innerHTML="<textarea id='Opinion_"+val[1]+"_"+val[0]+"' name='Opinion_"+val[1]+"_"+val[0]+"' class='textareabox-text' style='WIDTH: 700px; '></textarea>";	//modified by czf 20181119
			DisableElement('Opinion_'+val[1]+"_"+val[0],true);
		}
		tbl.deleteRow(Row2)	//modified by czf 20181119 ɾ������Ķ������
	}
	
}
function FillApprovedOpinion(ValList)
{
	ValList=ValList.replace(/\\n/g,"\n");
	var OneList=ValList.split("^");
	for (var i=0;i<OneList.length;i++)
	{
		var OneRecord=OneList[i].split(",");
		var Role=OneRecord[0];
		var Step=OneRecord[1];
		var Opinion=OneRecord[2];
		var ElementName="Opinion_"+Role+"_"+Step;
		SetElement(ElementName,Opinion);
	}
}
function InitStyle(ElementName,Type)
{
	var ApproveSet=GetElementValue("ApproveSetDR");
	if (ApproveSet=="") return;
	var encmeth=GetElementValue("GetApproveFlow");
	var ValList=cspRunServerMethod(encmeth,ApproveSet);
	PageInsertRows(ElementName,ValList);
	var ApproveRole=GetElementValue("CurRole");
	var CurStep=GetElementValue("RoleStep");
	DisableElement("Opinion_"+ApproveRole+"_"+CurStep,false);
	var RowID=GetElementValue("RowID");
	var encmeth=GetElementValue("GetApproveByResource");
	var ValList=cspRunServerMethod(encmeth,Type,RowID);
	FillApprovedOpinion(ValList);	
}
///�õ�excel�������
function GetExcelValue(xlsheet,x,y)
{
	var obj=xlsheet.cells(x,y).value
	if (!obj) return ""
	return obj;
}
///
function BElementDeclare()
{
	//BElement=new Array;
	BElement[0]="BAdd";
	BElement[1]="BUpdate";
	BElement[2]="BDelete";
	BElement[3]="BSubmit";
	BElement[4]="BCancelSubmit";
	BElement[5]="BAudit";
	BElement[6]="BBillAudit" ;//
	BElement[7]="BInAudit";
	BElement[8]="BOutAudit";
	BElement[9]="BBAudit";
}
function BElementEnableByVal(val)
{
	if (val=="") return;
	var vallist=val.split("^");
	var i=vallist.length;
	for (var j=0;j<i;j++)
	{
		DisableBElement(BElement[vallist[j]],true);
	}
}

///�س�������ѡ�񴰿ڵ���Muilt_LookUp��һ��������"BuyLoc^Loc"
///��װ���¼�д��Muilt_LookUp("BuyLoc^Loc")����
function Muilt_LookUp(Value)
{
	var value=Value.split("^");
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) obj.onkeydown=KeyDown_LookUp;
	}
}
function KeyDown_LookUp()
{
	if (event.keyCode==13)
	{
		var eSrc=window.event.srcElement;
		var lobj=document.getElementById(GetLookupName(eSrc.id));
		if (lobj) lobj.click();
	}
}


///�س�ת��ΪTab��?ֻ����װ���¼����øú���  eNameΪ����ϵ�һ���������
function EnterToTab(eName)
{
	var obj=GetParentTable(eName);
	if (obj) obj.onkeydown=EnterKeyDown;
}
function EnterKeyDown()
{
		if (window.event.keyCode==13){
		 window.event.keyCode=9;}
}


function EquipInfo(rowid)
{
	//encmeth="TU/PDV2jI8pqO3SK9WkkGcX46dIH7L3XI/6zBxvbxrxIfH0bEOipcF6QBSHKapF8"
	encmeth="o2YB2UDOqqtibndaU_BYQP_Wal76ZurUfgxUXRuiRMYp0VF0LiikK8/RzNcxGIDp"
	var result=cspRunServerMethod(encmeth,'','',rowid);	
	//alertShow('a'+result+'b');
	var list=result.split("^");
	var sort=EquipGlobalLen;
	this.Name=list[0];
	this.ABCType=list[1];
}

function GetEquipOBJ(rowid,methodElement)
{
	if (methodElement=="") methodElement="GetOneEquip";
	var encmeth=GetElementValue(methodElement);
	var result=cspRunServerMethod(encmeth,'','',rowid);	
	var list=result.split("^");
	var sort=EquipGlobalLen;
	this.Name=list[0];
	this.ABCType=list[1];
	this.UseLocDR=list[18];
	this.UseLoc=list[sort+7]
	this.KeeperDR=list[65];
	this.Keeper=list[sort+25];
	this.MaintUserDR=list[39];
	this.MaintUser=list[sort+19];
	///messageShow("","","",this.MaintUserDR+" "+this.MaintUser);
}

///Modified By JDL 20150820 GetSpellCode���ϣ�ͳһʹ��GetPYCode
///Creator:Mozy
///Date:2009-03-19
/// ת����ƴ����(��ƴ���ĵ�һ����ĸ)
function GetSpellCode(strInput)
{  
	var rtnStr="-1"
	var DHCEQPYObj = new ActiveXObject("HZ2PY.PinYinZH")
	var rtnStr=DHCEQPYObj.GetChineseSpellCode(strInput);
	return rtnStr;
}


///Creator:Jdl
///Date:2009-04-20
///����Ԫ�����ֻ�ȡԪ��ֵ
///ename:Ԫ������
///etype:Ԫ������ 1:INPUT/TEXTAREA 2:CheckBox  3:LABEL	4:SELECT
function GetElementValueNew(ename,etype)
{
	var evalue="";
	var obj=document.getElementById(ename);
	if (!etype) etype=""

	if (obj)
	{
		//messageShow("","","",obj.tagName);
		//messageShow("","","",obj.type);
		//SetElement("Loc",obj.tagName);
		if ((etype=="1")||(etype=="4"))
		{	evalue=obj.value;}
		else if (etype=="2")
		{	evalue=obj.checked;}
		else if (etype=="3") 
		{	evalue=obj.innerText;}
		else if (etype=="")
		{	
			if (obj.tagName=="TEXTAREA")
			{	evalue=obj.value;}
			else if (obj.tagName=="INPUT")
			{				
				if (obj.type=="checkbox")
				{	evalue=obj.checked}
				else
				{	evalue=obj.value;}
			}
			else if (obj.tagName=="LABEL")
			{	evalue=obj.innerText}
			else if (obj.tagName=="SELECT")
			{	evalue=obj.value}
		}
	}
	return evalue;
}



///ͳһ����ĳ�����͵�Ԫ�ص���ʽ
///ElementType?Ԫ������?��?*,TH,label,TABLE,INPUT��
///ClassName:��ʽ��Ҫ������DHCEQStyle.css
function SetItemStyle(ElementType,ClassName)
{
	var All = document.getElementsByTagName(ElementType);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		//messageShow("","","",All[I].style.fontSize);
		//All[I].style.fontSize="24pt";
		All[I].className=ClassName;
	}
}

///ͳһ����ĳ�����͵�Ԫ�ص�����
///ElementType?Ԫ������?��?*,TH,label,TABLE,INPUT��
///Size:����ߴ�
function SetItemFontSize(ElementType,Size)
{
	var All = document.getElementsByTagName(ElementType);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		//messageShow("","","",All[I].style.fontSize);
		All[I].style.fontSize=Size;
		//All[I].className=ClassName;
	}
}


///Creator:Jdl
///Date:2009-08-14
///����Ԫ����������Ԫ��ֵ
///ename:Ԫ������
///etype:Ԫ������ 1:INPUT/TEXTAREA 2:CheckBox  3:LABEL	4:SELECT
function SetElementValueNew(ename,evalue,etype)
{
	var obj=document.getElementById(ename);
	if (!etype) etype=""

	if (obj)
	{
		//messageShow("","","",obj.tagName);
		//messageShow("","","",obj.type);
		//SetElement("Loc",obj.tagName);
		if ((etype=="1")||(etype=="4"))
		{	obj.value=evalue;}
		else if (etype=="2")
		{	obj.checked=evalue;}
		else if (etype=="3") 
		{	obj.innerText=evalue;}
		else if (etype=="")
		{	
			if (obj.tagName=="TEXTAREA")
			{	obj.value=evalue;}
			else if (obj.tagName=="INPUT")
			{				
				if (obj.type=="checkbox")
				{	obj.checked=evalue}
				else
				{	obj.value=evalue;}
			}
			else if (obj.tagName=="LABEL")
			{	obj.innerText=evalue}
			else if (obj.tagName=="SELECT")
			{	obj.value=evalue}
		}
	}
}
///�޸�:ZY 2009-10-26 ZY0013
///����:��ȡ����¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������»��ͱ�
///Creator:����
///Date:2009-08-14
///����Ԫ����������Ԫ��ֵ
function GetModelRowID(type,i)
{
	var ModelName="Model";
	var ModelDRName="ModelDR"
	var ItemDRName="ItemDR"
	if ((i)&&(i!=""))
	{
		ModelName="T"+ModelName+"z"+i;
		ModelDRName="T"+ModelDRName+"z"+i;
		ItemDRName="T"+ItemDRName+"z"+i;
	}	
	
	if (GetElementValue(ModelDRName)!="")
	{
		return GetElementValue(ModelDRName)
	}
	else
	{
		if ((type==0)||(type==""))  return "";
		var Model=GetElementValue(ModelName);
		var ItemDR=GetElementValue(ItemDRName);
		var encmeth=GetElementValue("UpdModel");
		if ((Model=="")||(ItemDR=="")) return "";
		var rtn=cspRunServerMethod(encmeth,Model,ItemDR);
		return rtn
	} 
}
///����:ZY 2009-10-26 ZY0013
///����:��ȡ����¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������»��ͱ�
function GetManuFactoryRowID(type,i)
{		
	var ManuFactoryName="ManuFactory"
	var ManuFactoryDRName="ManuFactoryDR"
	if ((i)&&(i!=""))
	{
		ManuFactoryName="T"+ManuFactoryName+"z"+i;
		ManuFactoryDRName="T"+ManuFactoryDRName+"z"+i;
	}	
	
 	if (GetElementValue(ManuFactoryDRName)!="")
 	{
  		return GetElementValue(ManuFactoryDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type==""))  return "";
	 	var ManuFactory=GetElementValue(ManuFactoryName);
	 	if (ManuFactory=="") return "";
	 	var FirmType=3
	 	var val=GetPYCode(ManuFactory)+"^"+ManuFactory+"^^^"+FirmType;	//modified by CZF0093 2020-03-17
	 	//var encmeth=GetElementValue("UpdManuFactory");
	 	var encmeth=GetElementValue("UpdProvider");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
 } 
}
///����:ZY 2009-10-26 ZY0013
///����:��ȡ��Ӧ��¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������¹�Ӧ�̱� 2:
function GetProviderRowID(type,i)
{
	var ProviderName="Provider"
	var ProviderDRName="ProviderDR"
	if ((i)&&(i!=""))
	{
		ProviderName="T"+ProviderName+"z"+i;
		ProviderDRName="T"+ProviderDRName+"z"+i;
	}	

	if (GetElementValue(ProviderDRName)!="")
	{
		return GetElementValue(ProviderDRName)
	}
	else
	{
	 	if ((type==0)||(type==""))  return "";
	 	var Provider=GetElementValue(ProviderName);
	 	if (Provider=="") return "";
	 	var ProviderHandler=""		//2013-01-14 DJ begin
	 	var ProviderTel=""
	 	var obj=document.getElementById("ProviderHandler");
	 	if (obj)
	 	{
		 	ProviderHandler=GetElementValue("ProviderHandler");
	 	}
	 	var obj=document.getElementById("ProviderTel");
	 	if (obj)
	 	{
		 	ProviderTel=GetElementValue("ProviderTel");
	 	}
	 	var FirmType=2	
	 	var val=GetPYCode(Provider)+"^"+Provider+"^"+ProviderHandler+"^"+ProviderTel+"^"+FirmType;	//modified by CZF0093 2020-03-17
	 	var encmeth=GetElementValue("UpdProvider");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	}
}
///20150825  Mozy0163	��ŵص�
///����:��ȡ��ŵص�¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������¹�Ӧ�̱� 2:
function GetLocationRowID(type,i)
{
	var LocationName="Location"
	var LocationDRName="LocationDR"
	if ((i)&&(i!=""))
	{
		LocationName="T"+LocationName+"z"+i;
		LocationDRName="T"+LocationDRName+"z"+i;
	}
	
 	if (GetElementValue(LocationDRName)!="")
 	{
  		return GetElementValue(LocationDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var Location=GetElementValue(LocationName);
	 	if (Location=="") return "";
	 	var val=GetPYCode(Location)+"^"+Location;
	 	var encmeth=GetElementValue("UpdLocation");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	} 
}



function TransDisableToReadOnly(tagName)
{	
	var All = document.getElementsByTagName(tagName);
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].disabled)
		{
			if ((All[I].type!="checkbox")&&(All[I].tagName!="A"))
			{			
				All[I].disabled=false;
				All[I].readOnly=true;
				//All[I].className= "EQReadOnlyINPUT";
			}
		}
	}	
}

function InitLast()
{
	TransDisableToReadOnly("*");
}

///add by jdl 2009-9-21
///���������ı���س��󵯳�����ѡ��
///����ʱ,Ԫ�ص�onkeydown�¼�����Ϊ�˷�������
function LookUpDate()
{
	if (event.keyCode==13)
	{
		var obj=window.event.srcElement
		if (!obj) return;
		var objID=obj.id;
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID='+objID+'&STARTVAL=';
		url += '&DATEVAL=' + escape(obj.value);
		var tmp=url.split('%');
		url=tmp.join('%25');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

//�����ͼ���Ԫ����ͬһ����,Ҫ����Ԫ�صĿ��
function AdjustWidth(objwidth,offsetwidth)
{
  if (objwidth!="")
  {
  	 var objwidtharr=objwidth.split("px");
  	 var objwidthnum=objwidtharr[0];
  	 if (offsetwidth)
  	 {
	  	 objwidthnum=objwidthnum-offsetwidth;
  	 }
  	 else
  	 {
	  	 objwidthnum=objwidthnum-20;
	 }
  	 objwidth=objwidthnum+"px"
  }
	return objwidth
}

function ChangeRowStyleTest(RowObj)
{
	var html;
	for (var j=0;j<RowObj.cells.length;j++) 
	{
    	if (!RowObj.cells[j].firstChild) {continue} 
		var Id=RowObj.cells[j].firstChild.id;
		var arrId=Id.split("z");
		var objindex=arrId[1];
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (arrId[0]=="TEquip")
		{
         	html=CreatElementHtml(2,Id,objwidth,objheight,"","")
         	//messageShow("","","",html);
         	RowObj.cells[j].innerHTML=html;
		}
		else if (arrId[0]=="TUseYearsNum")
		{
			html=CreatElementHtml(1,Id,objwidth,objheight,"","")
         	//messageShow("","","",html);
         	RowObj.cells[j].innerHTML=html;
		}
		else if (arrId[0]=="TStatCat")
		{
			html=CreatElementHtml(4,Id,objwidth,objheight,"","ChangeTest","1^��еר���豸&2^��еһ���豸")
         	//messageShow("","","",html);
         	RowObj.cells[j].innerHTML=html;
		}
	}
}

function ChangeTest()
{
	alertShow("Change");
}

/// add by lmm 2019-09-01
/// ����:hisui����ʵ�ֻس���һ������� 
/// ��ע:�ı���,������,�����б�,���ڿ�,ʱ�����ʵ��,���ı���֧��
/// modify by lmm 2020-06-29 ȥ��lookup�س���һ������¼�
function Muilt_Tab()
{
	muilt_Tab()		
}

function KeyDown_Tab()
{
	if (event.keyCode==13)
	{
		window.event.keyCode=9
	}
}
///Function:Funds	2012-2-16 �����ʽ���Դ��Ϣ
///����:2009-11-19 ���� DJ0036
///����:��ȡ��ǰ�б��еĵ�ǰ�к�
function GetTableCurRow()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return "";
	
	//Modified by jdl 2011-01-29 JDL0069
	if ((eSrc.tagName=="IMG")&&(eSrc.id==""))
	{
		var TDesc=eSrc.parentElement.id.split("z");
	}
	else
	{
		var TDesc=eSrc.id.split("z");		
	}	
	
	var currow=TDesc[TDesc.length-1];
	return currow
}

///Add by Mozy
///������������
function NumberPressHandler(e)
{
	try
	{
		keycode=websys_getKey(e);
	}
	catch(e)
	{
		keycode=websys_getKey();
	}
	if (((keycode>47)&&(keycode<58))||(keycode==46))
	{
	}else
	{
		window.event.keyCode=0;
		return websys_cancel();
	}
}

//����Ƿ�Ϊ�� Type?1ָ����  CNameΪ��ʾ��Ϣ
function CheckItemNull(Type,Name,CName)
{
	var CValue=GetCElementValue("c"+Name);
	if (CName!=""&&CName!=null) {var CValue=CName;}
	if (Type=="1") //����DR
	{
		if ((GetElementValue(Name+"DR"))=="")
		{
			SetFocus(Name);		
			messageShow("","","",CValue+t[-4005]);
			return true;
		}
	}
	else
	{
		if ((GetElementValue(Name))=="")
		{
			SetFocus(Name);
			messageShow("","","",CValue+t[-4005]);
			return true;
		}
	}
	return false;
}
///Add by Mozy
///������һ������
function SetFocusColumn(ColName,Row)
{
	var obj=document.getElementById(ColName+"z"+Row);
	if (obj){websys_setfocus(ColName+"z"+Row)};
}

///Add by JDL 2010-8-9
///����SourceType,SourceID��Ϣ����
function SourceInfo(SourceType,SourceID)
{
	this.SourceType=SourceType;
	this.SourceID=SourceID;
}


function Standard_TableKeyUp()
{
	var eSrc=window.event.srcElement;
	if (!eSrc) return;
	var Id=eSrc.id
	var offset=Id.lastIndexOf("z");
	var index=Id.substring(offset+1);
	var colName=Id.substring(0,offset);	
	var obj=document.getElementById(colName+"DRz"+index);
	if (obj) obj.value="";	
}

///����һ��Ԫ�ص�ֻ������
///names:Ԫ�����ƴ�,��"^"�ָ�
///value:ֻ��Ϊtrue,����Ϊfalse
function ReadOnlyElements(names,value)
{
	var nameList=names.split("^")
	for (i=0;i<nameList.length;i++)
	{
		ReadOnlyElement(nameList[i],value);
	}	
}

///����:2010-05-23 ����
///����:����豸�����Ƿ������ȷ, 0:��ȷ, -1:����
function CheckEquipCat(EquipCatRowID)
{
	if (EquipCatRowID=="") return 0;
	var encmeth=GetElementValue("CheckEquipCat");
	var rtn=cspRunServerMethod(encmeth,EquipCatRowID);
	if (rtn=="") return -1;
	return rtn
}

///����:2010-07-08 ZY
///modified by csj 2018-09-07 HIUSI��̬����datagrid����� Objtbl��Ϊdatagrid����id
///����:JSҳ�����ʵ������Table����
///��Σ�Objtbl �����id
///      ColName ����id
function HiddenTblColumn(Objtbl,ColName)
{
	$HUI.datagrid("#"+Objtbl).hideColumn(ColName);
}
///add by jdl 2010-7-15
///�����б��������ı���س��󵯳�����ѡ��
///����ʱ,Ԫ�ص�onkeydown�¼�����Ϊ�˷�������
///���ô˺���ʱҪ����?����_lookupSelect(dateval)?�¼���selectRow����
function LookUpTableDate(vClickEventFlag)
{
	var eValue;
	if (event.keyCode==13||event.keyCode==0||vClickEventFlag==1)
	{
		var obj=window.event.srcElement
		if (!obj) return;
		var objID=obj.id;
		var offset=objID.lastIndexOf("z");
		selectRow=objID.substring(offset+1);
		objID=objID.substring(0,offset);
		if(obj.tagName=="IMG")
		{
			objID=objID.substring(3,offset);
			obj=document.getElementById(objID+"z"+selectRow);
		}
		eValue=obj.value;
		if (!IsValidDate(obj)) return;
		var url='websys.lookupdate.csp?ID='+obj.id+'&STARTVAL=';	//�����:262030 add by kdf 2016-09-28
		url += '&DATEVAL=' + escape(eValue);
		var tmp=url.split('%');
		websys_lu(url,1,'top=200,left=200,width=370,height=230');
		return websys_cancel();
	}
}

///add by zy 2010-7-15
///�����б��������ı���onchange�¼�
///����ʱ,Ԫ�ص�onchange�¼�����Ϊ�˷�������
function TDate_changehandler(e) 
{
	var eSrc=websys_getSrcElement(e);
	if (!IsValidDate(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return  websys_cancel();
	} 
	else 
	{
		eSrc.className='';
	}
}

///add by zy 2010-7-15
///�����б��������ı���onchange�¼�
///����ʱ,Ԫ�ص�onchange�¼�����Ϊ�˷�������
function TTime_changehandler(e) 
{
	var eSrc=websys_getSrcElement(e);
	if (!IsValidTime(eSrc)) {
		eSrc.className='clsInvalid';
		websys_setfocus(eSrc.id);
		return websys_cancel();
	}
	else
	{
		eSrc.className='';
	}
}

///add by zy 2010-7-15
///�����б��зŴ󾵵ĸ�ֵ
function GetLookUpID_Table(ename,value)
{	
	var val=value.split("^");
	var obj=document.getElementById(ename);
	if (obj)	
	{
		obj.value=val[1];
	}
	else 
	{
		messageShow("","","",ename);
	}
	var offset=ename.lastIndexOf("z");
	var Index=ename.substring(offset+1);
	var ColName=ename.substring(0,offset-2);
	ename=ColName+"z"+Index
	var obj=document.getElementById(ename);
	if (obj)	
	{
		obj.value=val[0];
	}
	else 
	{
		messageShow("","","",ename);
	}
}

///�޸�:ZY 2010-08-27
///����:��ȡƾ֤¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������»��ͱ�
///Creator:zy
///Date:2010-08-27
///����Ԫ����������Ԫ��ֵ
function GetCertificateRowID(type,i)
{
	var CertificateNo="Certificate";
	var CertificateDRName="CertificateDR"
	if ((i)&&(i!=""))
	{
		CertificateNo="T"+CertificateNo+"z"+i;
		CertificateDRName="T"+CertificateDRName+"z"+i;
	}	
	
	if (GetElementValue(CertificateDRName)!="")
	{
		return GetElementValue(CertificateDRName)
	}
	else
	{
		if ((type==0)||(type==""))  return "";
		var CertificateNo=GetElementValue(CertificateNo);
		var encmeth=GetElementValue("UpdCertificate");
		if (CertificateNo=="") return "";
		var rtn=cspRunServerMethod(encmeth,CertificateNo);
		return rtn
	} 
}
///add by zy 2010-7-28
///����ȡlistbox��ֵ
///type: 1 value  2 text
function GetSelectedElementValue(name,type)
{
	var value="";
	var obj=document.getElementById(name);
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (value!="") value=value+",";
		if (type==1)
		{	value=value+obj.options[i].value;}
		else
		{	value=value+obj.options[i].text;}
	}
	return value;
}
/// Add By DJ 2010-10-22
/// ����:�ж��豸�����Ƿ�ѡ����ĩ��
/// ����ֵ:0:�� 1:�� 2:����ĩ��ʱ��ʾ��������
function CheckEqCatIsEnd(CatID)
{
	if (CatID=="") return 1
	var encmeth=GetElementValue("CheckEqCatIsEnd");
	if (encmeth=="") return 1;
	var result=cspRunServerMethod(encmeth,CatID);
	return result
}

///Add By JDL 2011-03-10
///�豸����ͨ����Ϣ��ʾ
function EQMsg(Desc,Code)
{
	var MsgInfo="";
	if (Desc!="") MsgInfo=Desc;
	if (MsgInfo!="")
	{
		MsgInfo=MsgInfo+"  ��ϸ:";
	}
	if (t[Code])
	{
		MsgInfo=MsgInfo+t[Code];
	}
	else
	{
		MsgInfo=MsgInfo+Code;
	}
	return MsgInfo;
}

///Add by jdl 2011-3-22
///�ж��Ƿ�Ϊ����
///���?NumStr��֤���ַ���
///		AllowEmpty:�Ƿ�����Ϊ��
///		AllowDecimal?�Ƿ�����С��
///		AllowNegative?�Ƿ�������
///		AllowZero:�Ƿ�������
///	����ֵ?0:��Ч
///			1:��Ч
function IsValidateNumber(NumStr,AllowEmpty,AllowDecimal,AllowNegative,AllowZero)
{
	if (NumStr=="")
	{
		if (AllowEmpty=="1")
		{
			return "1";
		}
		else
		{
			return "0";
		}
	}
	if (isNaN(NumStr)) return "0";
	//�ж��Ƿ���
	if ((NumStr<0)&&(AllowNegative!="1")) return "0";
	//�ж��Ƿ�����
	if ((parseInt(NumStr)!=NumStr)&&(AllowDecimal!="1")) return "0";
	if ((parseFloat(NumStr)==0)&&(AllowZero=="0")) return "0";
	return "1";	
}

///add by jdl 2011-7-13 
function ReplaceTitle(FromStr,ToStr)
{
	var All = document.getElementsByTagName( "label" );
	var Length = All.length;
	var ReplaceNum=0;
	if (FromStr=="") return;
	var FromList=FromStr.split("^");
	var FromLen=FromList.length;
	var ToList=ToStr.split("^");
	
	for(var I = 0; I < Length; I++)
	{
		if (All[I].id.indexOf("c")!=0) continue;
		var OldStr=All[I].innerText;
		///messageShow("","","",All[I].id);		
		for(var J = 0; J < Length; J++)
		{
			var NewStr=OldStr.replace(FromList[J],ToList[J]);
			if (NewStr!=OldStr)
			{
				All[I].innerText=NewStr;
				ReplaceNum=ReplaceNum+1;
			}
		}
	}
	
	var All = document.getElementsByTagName( "TABLE" );
	var Length = All.length;
	for(var K = 0; K < Length; K++)
	{
		if (!All[K]) continue;
		if (!All[K].tHead) continue;
		if (!All[K].tHead.children[0]) continue;
		var head=All[K].tHead.children[0];
		var Length=head.children.length;
		for(var I = 0; I < Length; I++)
		{
			///messageShow("","","",head.children[I].innerText);
			var OldStr=head.children[I].innerText;		
			for(var J = 0; J < Length; J++)
			{
				var NewStr=OldStr.replace(FromList[J],ToList[J]);
				if (NewStr!=OldStr)
				{
					head.children[I].innerText=NewStr;
					ReplaceNum=ReplaceNum+1;
				}
			}
		}
	}
	///messageShow("","","",ReplaceNum);
	return ReplaceNum;	
}



/// Add By HZY 2012-02-24 HZY0023
/// ����:��ȡ�о�����¼�뷽ʽ 0:�Ŵ�ѡ��ģʽ 1:�ֹ�¼��ģʽ,���Զ������о������ 2:���־���
function GetIssueRowID(type,i)
{
	var IssueName="Issue"
	var IssueDRName="IssueDR"
	if ((i)&&(i!=""))
	{
		IssueName="T"+IssueName+"z"+i;
		IssueDRName="T"+IssueDRName+"z"+i;
	}	

	if (GetElementValue(IssueDRName)!="")
	{
		return GetElementValue(IssueDRName)
	}
	else
	{
	 	if ((type==0)||(type==""))  return "";
	 	var Issue=GetElementValue(IssueName);
	 	if (Issue=="") return "";
	 	var val=GetPYCode(Issue)+"^"+Issue;
	 	var encmeth=GetElementValue("UpdIssue");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	}
}

function GetLookupNameT(name)
{
	return "lt"+GetElementValue("GetComponentID")+"i"+name
}
/// Mozy0103	20130716
function GetFileNameToTXT()
{
	try 
	{
		// Scripting.FileSystemObject
		var xls = new ActiveXObject("Excel.Application");
		var fName = xls.GetSaveAsFilename("","�ı��ĵ�(*.txt),*.txt");
		if (fName==false)
		{
			fName="";
		}
		return fName;
	}
	catch(e)
	{
		messageShow("","","",e.message);
		return "";
	}
}

/*
//var websys_windows=new Array();GR0026 �´��ڴ�ģ̬����
function websys_createWindow(url, wname, features) {
	if ((url.indexOf("websys.csp?")==0)&&(websys_locked())) url+="&TLOCKED=1";
	if (typeof features != 'undefined') {
		features=features.toUpperCase();
		if (features.indexOf('STATUS=')==-1) features="status,"+features;
		if (features.indexOf('SCROLLBARS=')==-1) features="scrollbars,"+features;
		if (features.indexOf('RESIZABLE=')==-1) features="resizable,"+features;
	}
	if (url.indexOf("DHCEQMWindow=1")>0)
	{
		var scrWidth = screen.availWidth; var scrHeight = screen.avaiHeight; 
		window.showModalDialog(url,'',"dialogWidth=" + scrWidth + ";dialogHeight="+ scrHeight);
		
		location.reload();
	}
	else
	{		
		websys_windows[wname]=window.open(url, wname, features);
		websys_windows[wname].focus();
		return websys_windows[wname];
	}
}
*/


///Add By JDL 20150820 JDL0139
///����:������������е�Ԫ�ص��������ͣ������ж�Ԫ��ֵ�Ƿ���Ч��
///		��ǰ������Float���͵����ݡ�	
///		����ֵ��true�зǷ���false�޷Ƿ�����
function CheckItemValueIllegal()
{	
	var GetItemDataTypeInfo=GetElementValue("GetItemDataTypeInfo");
	if (GetItemDataTypeInfo!="")
	{
		var ItemInfos=GetItemDataTypeInfo.split('&');
		for (var i=0;i<ItemInfos.length;i++)
		{
			var ItemInfo=ItemInfos[i];
			if (ItemInfo!="")
			{
				var Item=ItemInfo.split('=');
				var ItemName=Item[0];
				var DataType=Item[1];
				//Ŀǰ����֤���ֵ���Ч��
				if (DataType.indexOf("Float")>=0)
				{
					var Value=GetElementValue(ItemName);
					if ((Value!="")&&(isNaN(Value)))
					{
						var CValue=GetCElementValue("c"+ItemName);
						if (""==CValue) CValue=ItemName;
						SetFocus(ItemName);
						messageShow("","","",t[-4008]+CValue+"!");
						return true;
					}
				}
			}
		}
	}	
	return false;	
}

//add By HHM 2015-08-24 HHM0001
///����:�����������ô�С
///modify by lmm 2018-07-30
///������Σ�vtitle �������  
function SetWindowSize(url,vDefaultFlag,vWidth,vHeight,vTop,vLeft,vtitle,vModal,vIsTopZindex,vContent)
{
	//add by lmm 2018-07-30 begin
	if (1==vDefaultFlag)
	{
		///modified by zy 2018-12-26 ZY0182
		if ((vWidth=="")||(typeof(vWidth)=="undefined")) var vWidth=window.screen.width*0.7;         //�������ڵĿ��;
		if ((vHeight=="")||(typeof(vHeight)=="undefined")) var vHeight=window.screen.height*0.7;      //�������ڵĸ߶�;
		if ((vtitle=="")||(typeof(vtitle)=="undefined"))  var vtitle="�̶��ʲ�ϵͳ"
	}
	//modify by lmm 2018-12-12 begin
	var icon="icon-w-paper"
	var showtype="modal"
	showWindow(url,vtitle,vWidth,vHeight,icon,showtype)  
	//modify by lmm 2018-12-12 end
	/*
	if (vModal=="")  //true
	{
		if (vtitle=="")  var vtitle="_blank"
		//var features="toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes"
		//websys_createWindow(url,vtitle,features)
		websys_lu(url,false,'width=1080,height=650,left=130,top=3,hisui=true')
		//websys_lu(url,false,'width='+vWidth+',height='+vHeight+',left=130,top=3,hisui=true')
	}
	else
	{
		var options={
				url:url,
				title:vtitle,
				width:vWidth,
				height:vHeight,
				modal:vModal,
				content:vContent,
				isTopZindex:false,
				iconCls:'icon-w-paper'   //modify by lmm 2018-11-19
			}		
		websys_showModal(options);
	}
	//add by lmm 2018-07-30 end
	*/
	
	
	
	
	
	
	
	
  	//var vTop = (window.screen.height-30-vHeight)/2;       //��ô��ڵĴ�ֱλ��;
	//var vLeft = (window.screen.width-10-vWidth)/2;        //��ô��ڵ�ˮƽλ��;
}

function GetTableName()
{
	var TableName="";
	var All = document.getElementsByTagName( "TABLE" );
	var Length = All.length;
	for(var K = 0; K < Length; K++)
	{
		if (All[K].id!="")
		{
			TableName=All[K].id;
			break;
		}
	}
	return TableName;
}

///Add By DJ 2016-07-21
///����:��ȡƷ��¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������¹�Ӧ�̱� 2:
function GetBrandRowID(type,i)
{
	var BrandName="Brand"
	var BrandDRName="BrandDR"
	if ((i)&&(i!=""))
	{
		BrandName="T"+BrandName+"z"+i;
		BrandDRName="T"+BrandDRName+"z"+i;
	}
	
 	if (GetElementValue(BrandDRName)!="")
 	{
  		return GetElementValue(BrandDRName)
 	}
 	else
 	{
	 	if ((type==0)||(type=="")) return "";
	 	var Brand=GetElementValue(BrandName);
	 	if (Brand=="") return "";
	 	var val=GetPYCode(Brand)+"^"+Brand;
	 	var encmeth=GetElementValue("UpdBrand");
		var rtn=cspRunServerMethod(encmeth,val);
  		return rtn
	} 
}
/**
*���һ���ַ���
*2017-07-19
*JYP
*���Խ�AKB222,AKB235~40���ΪAKB222,AKB235��AKB236��AKB237��AKB238��AKB239��AKB240
*��Σ�String��Ҫ��ֵ��ַ���   
*      StringSeparator���ַ����ָ��
*      BreakUpSeparator:����ַ����ָ��
*����ֵ��StringNew��������ַ�����
**/
function StringBreakUp(String,StringSeparator,BreakUpSeparator)
{	
	var List=String.split(StringSeparator);                                   //���ַ�����StringSeparator�ָ
	var BreakList=""
	var StringNew=""
	for(
			var i=0;i<=List.length-1;i++){
			var listStart=List[i].split(BreakUpSeparator);                      //���ָ���ÿһ���ַ����ٰ���BreakUpSeparator�ָ
			var listBegin=listStart[0];                                         //����ֵ��ַ����Ŀ�ʼ����
			var listEnd=listStart[1];                               			//����ֵ��ַ����Ľ�������
			if((listStart.length>1)){                                           //�жϷָ����ַ�����������ν����ֳ���	
				var BreakList=BreakUp(listBegin,listEnd,StringSeparator);
				if (BreakList=="")                                              //��ֲ��ɹ����ز��ǰ�ĸ�ʽ
				{
					BreakList=ConnectionString(listBegin,listEnd,BreakUpSeparator);
				}	
				StringNew=ConnectionString(StringNew,BreakList,StringSeparator);
		    }
		    else
		    {
				StringNew=ConnectionString(StringNew,List[i],StringSeparator);
			}
		}
	return StringNew
}
/**
*���һ���ַ���
*2017-04-15
*JYP
*������������Ӧ������ַ���(ack35,40)����һ���ַ���(ack35,ack36,ack37,ack38,ack39,ack40)
*��Σ�StringBefore�����ǰ����ʼ�ַ���   
*      StringAfter�����ǰ�Ľ����ַ���
*����ֵ��String��������ַ�����
**/
function BreakUp(StringBefore,StringAfter,StringSeparator)
{	
	var StringStart=StringBefore.substr(StringBefore.length-StringAfter.length)       //��ʼ�ַ�
	var Stringprefix=StringBefore.substr(0,StringBefore.length-StringAfter.length)    //ǰ׺
	var ListString=""                                                                 //��ֺ��ÿ���ַ���
	var String=""
	for(var j=0;j<=StringAfter-StringStart;j++){
		ListString=parseInt(StringStart)+j;
		ListString=ListString.toString()
		for(var k=ListString.length;k<StringAfter.length;k++){
			ListString="0"+ListString                                                 //�ַ���ת������
		}
        String=ConnectionString(String,Stringprefix+ListString,StringSeparator)
	}
	return String
}
/**
*���������ַ���
*2017-04-15
*JYP
*�������ַ����ӷָ����ӳ�һ���ַ�����
*��Σ�StringBefore����ǰ���ַ���(StringA)
*      StringAfter���ں���ַ���(StringB)
*      Separator���ָ���(,)
*����ֵ��AfterConnectionString�����Ӻ���ַ���(StringA,StringB)
**/
function ConnectionString(StringBefore,StringAfter,Separator)
{	
    var AfterConnectionString
	if(StringBefore=="")
	{
		AfterConnectionString=StringAfter
	}
	else
	{
		AfterConnectionString=StringBefore+Separator+StringAfter
	}
   return AfterConnectionString
}

/**
*2018-06-26
*lmm
*���������б������
**/
function SetComboboxRequired(Names)
{
	if ((Names!="")&&(Names!=undefined))		//modified by czf 20181101
	{
		var name=Names.split("^")
		for (var i=0;i<name.length;i++)
		{
			var Requireflag=$("#c"+name[i]).find("span").html()
			if (Requireflag="*")
			{
				$("#"+name[i]).attr("data-required",true).attr("title","������");
			}
		}
	}
	else{
		$('.hisui-combobox').each(function(ind,item){
			var id = $(this).attr("id");
			if (id!="")
			{
				var Requireflag=$("#c"+id).find("span").html()
				if (Requireflag="*")
				{
					$("#"+id).attr("data-required",true).attr("title","������");
				}
			}
			
		});
	}
}

//modify by lmm 2018-07-25
function ReadOnlyElement(name,value)
{
	
	var obj=document.getElementById(name);
	if (obj)
	{
		disableElement(name,value)
	}
}
///�滻����ĸ���� ��ʼ��
function DisableElement(name,value)   
{
	disableElement(name,value)
}


//modify by lmm 2018-02-01
//type:class  ��ť��checkbox:hisui-checkbox ���������textarea:textareabox-text hidden
//            ������text:combogrid-f/datebox-f/hisui-validatebox validatebox-text// 
///modify by lmm 2020-06-29 ������ӷŴ󾵻س���ֵ�������һ�����
function SetElement(vElementID,vValue)
{
	setElement(vElementID,vValue)
	var event = window.event||event
	//modify by lmm 2020-07-01
	if(event)
	{
		var keyCode=event.which||event.keyCode
		if (keyCode==13)
		{
			var vElementID=String(vElementID)
			if(vElementID.lastIndexOf("_")>=0)
			{
				var vElementID=$("#"+vElementID.substr(0,vElementID.lastIndexOf("_"))).attr("id")	
			}		
			else if ($("#"+vElementID.substr(0,vElementID.length-2)).attr("id")!=undefined)
			{
				var vElementID=$("#"+vElementID.substr(0,vElementID.length-2)).attr("id")
			}
			lookuptab(vElementID)
			tabflag=1
		}
	}
	
	
	
	/*
	var result=""
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		var objType=jQuery("#"+vElementID).prop("type")
		var objClassInfo=jQuery("#"+vElementID).prop("class")
		
		//alertShow("vElementID"+vElementID+"objType"+objType+"objClassInfo"+objClassInfo)
		if (objType=="checkbox")
		{
			if ((vValue=="1")||(vValue==true)||(vValue=="Y"))
			{
				jQuery("#"+vElementID).checkbox("setValue",true);  
			}
			if ((vValue=="0")||(vValue==false)||(vValue=="N")||(vValue==""))
			{
				jQuery("#"+vElementID).checkbox("setValue",false);
			}
		}
		else if (objType=="select-one")
		{
			//jQuery("#"+vElementID).combobox("setText",vValue);
			jQuery("#"+vElementID).combobox("setValue",vValue);
			//alertShow("ss"+jQuery("#"+vElementID).combobox("getValue"))
		}
		else if (objType=="text")
		{
			
			if (objClassInfo.indexOf("combogrid")>=0)   //combogrid
			{
				jQuery("#"+vElementID).combogrid('setText',vValue);
				jQuery("#"+vElementID).combogrid('setValue',vValue); 
			}
			else if (objClassInfo.indexOf("datebox-f")>=0)
			{
				jQuery("#"+vElementID).datebox('setValue',vValue)  
			}
			else if (objClassInfo.indexOf("combobox")>=0)
			{
				jQuery("#"+vElementID).combobox('setValue',vValue);
			}
			//else if (objClassInfo.indexOf("lookup")>=0)
			//{
				//alertShow("aaa:"+vValue)
				//jQuery("#"+vElementID).lookup('setText',vValue);
				//jQuery("#"+vElementID).lookup('setValue',vValue);
			//}
			else
			{
				//alertShow("vValue"+vValue)
				jQuery("#"+vElementID).val(vValue)  
			}
			
		}
		else  //hidden areatext
		{
			//add by lmm 2018-07-20 begin
			if (objClassInfo.indexOf("linkbutton")>=0)
			{
				jQuery("#"+vElementID).linkbutton({text:vValue})
			}
			else
			{
				jQuery("#"+vElementID).val(vValue)  
			}
			//add by lmm 2018-07-20
		}
	}*/
}

//modify by lmm 2018-02-01
function GetElementValue(vElementID)
{
	return getElementValue(vElementID)
	/*
	var result=""
	var obj=document.getElementById(vElementID);
	if (!obj) return ""
	var objType=jQuery("#"+vElementID).prop("type")  //prop
	//alertShow("vElementID"+vElementID+"objType"+objType+"objClassInfo"+objClassInfo)
	var objClassInfo=jQuery("#"+vElementID).prop("class")
	//�����б��ǩ�ж�
	var tabs = document.getElementsByTagName( "select" );
	var Length = tabs.length;	
	
	if (objType=="checkbox")
	{
		//result=jQuery("#"+vElementID).is(':checked')
		result=jQuery("#"+vElementID).checkbox("getValue",true);
	}
	else if (objType=="select-one")
	{
		//alertShow("objClassInfo"+objClassInfo+"^vElementID"+vElementID+"objType"+objType)
		result=jQuery("#"+vElementID).combobox("getValue");
		//alertShow("resultGET"+result)
	}
	else if (objType=="text")
	{
		//var objClass=objClassInfo.split(" ")
		//var objType=objClass[0].split("-")
		if (objClassInfo.indexOf("combogrid")>=0)
		{
			result=jQuery("#"+vElementID).combogrid("getText");
		}
		else if (objClassInfo.indexOf("datebox-f")>=0)
		{
			result=jQuery("#"+vElementID).datebox('getText');
		}
		else if (objClassInfo.indexOf("combobox")>=0)
		{
			result=jQuery("#"+vElementID).combobox("getValue");
		}
		else
		{
			result=jQuery("#"+vElementID).val()
				
		}
		
	}
	else  //textarea,text,hidden
	{
			result=jQuery("#"+vElementID).val()
		

	}
	return result*/
}
function CheckMustItemNull(Strs)
{
	return checkMustItemNull(Strs)
}
///��ȡ��Ԫ�����ڵ�Table
function GetParentTable(ename)
{
	return getParentTable(ename)
}

///Add by JDL 2010-8-3
///Show or hide object
///objID:
///hidden: 0 show ,  1 hidden
function HiddenObj(objID,hidden) 
{
	hiddenObj(objID,hidden)
}

/// 20150918  Mozy0166	���ر��ͼ�꣬���������غϼ���ͼ��
/// ComponentName:	�����
/// val:	��ӦԪ��ֵΪ�������ظ�ͼ��
/// Item:	ͼ�����ڵ�Ԫ����
//modify by lmm 2018-02-01
function HiddenTableIcon(ComponentName,val,Item)
{  
	hiddenTableIcon(ComponentName,val,Item)
	
}
///���ÿؼ�����
function SetFocus(Name)
{
	setFocus(Name)
}

///Add By DJ 2015-08-17 DJ0156
///����:����ǰ̨ҳ���¼��ʾ����ɫ
//modify by lmm 2018-02-01
function SetBackGroupColor(vComponentTableName)
{ 
	setBackgroundColor(vComponentTableName)
}
///Modified By JDL 20150820 GetSpellCode���ϣ�ͳһʹ��GetPYCode
/// ȡ���ö�̬��ת��ƴ���룬���ú�̨����������ƴ����
///-------------------------------------------------
///����:ZY 2009-10-26 ZY0013
///ת����ƴ����
function GetPYCode(strInput)
{
	return getPYCode(strInput)
}


///��Ҫ������϶���GetColCaption?s val=##Class(%CSP.Page).Encrypt($lb("web.DHCEQCommon.GetColumnCaption"))
///					GetComponentID?s val=##class(web.DHCEQCommon).GetComponentID("DHCEQInStockNew")
function GetColCaption(colName)
{
	return getColCaption(colName)
}
function InitMessage(vBuss)
{
	t[0]="�����ɹ�";
	//-1��-500ΪSQL Error Code
	t[-104]="����Ч�ֶ�,�޷���������!";
	t[-105]="����Ч�ֶ�,�޷���������!";
	//-10000��-12000ΪSQL Error Code
	
	//-1001��-1999Ϊ�����෵��ʧ�ܴ���?������message��
	//-2001��-2999Ϊ�����෵��ʧ�ܴ���?Ϊͨ�ô��붨��������
	t[-2001]="�޷��ҵ��ü�¼!";
	t[-2002]="�ü�¼��δ�ύ,�޷����!";
	
	t[-2005]="���豸�Ѿ�����,���ܲ���!";	
	
	t[-2011]="�ü�¼�Ѿ��ύ,�޷��޸�!";
	t[-2012]="�ü�¼�Ѿ��ύ,�޷�ɾ��!";
	t[-2013]="�ü�¼�����ύ,����״̬!";
	t[-2014]="�ü�¼�����ύ״̬,����ȡ���ύ!";
	
	t[-2015]="�ü�¼״̬������,����ִ�в���!";
	
	t[-2021]="�ü�¼�Ѿ����,�޷��޸�!";
	t[-2022]="�ü�¼�Ѿ����,�޷�ɾ��!";
	t[-2023]="�ü�¼�Ѿ����,���������!";
	
	t[-2101]="���ܲ���,����ü�¼״̬!";
	t[-2102]="�������úõ������ɹ���!"

	t[-2200]="�����ɹ�!";
	t[-2201]="����ʧ��!";
	t[-2210]="���²����ɹ�!";
	t[-2211]="���²���ʧ��!";
	t[-2220]="�ύ�����ɹ�!";
	t[-2221]="�ύ����ʧ��!";
	t[-2230]="���������ɹ�!";
	t[-2231]="��������ʧ��!";
	t[-2240]="ȡ���ύ�����ɹ�!";
	t[-2241]="ȡ���ύ����ʧ��!";
	//-3001��-3999Ϊҳ�洦����ʾ����?������message��
	//-4001��-4999Ϊҳ�洦����ʾ����?Ϊͨ�ô��붨��������
	t[-4001]="û�����ô�����!";
	t[-4002]="��ѡ��Ҫ�����ļ�¼!";
	t[-4003]="��ȷ��Ҫɾ���ü�¼��?";
	t[-4004]="����ѡ���豸!";
	t[-4005]="����Ϊ��!";
	t[-4006]="�����豸��Ψһ,�����ύ"
	t[-4007]="û����������"
	t[-4008]="��������Ч��"
	initMessage(vBuss)
}
///add by lmm 2018-09-12
///��������ť�������¸�ֵ
function setButtonText(vExcludesids)
{
	
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		if ((","+vExcludesids+",").indexOf(","+id+",")==-1)
		{
			if (getValueById(id)=="����")
			{
				jQuery("#"+id).linkbutton({text:"����"})	
			}
			else if ((getValueById(id)=="�޸�")||(getValueById(id)=="����"))
			{
				jQuery("#"+id).linkbutton({text:"����"})	
			}
			//add by lmm 2019-11-22 begin LMM0050	
			else if (getValueById(id)=="ȡ���ύ")
			{
				jQuery("#"+id).linkbutton({text:"�˻�"})	
			}	
			//add by lmm 2019-11-22 end LMM0050	
		}	

		
	})
}
///add by lmm 2018-09-18
///���������ݵ���״̬���ð�ť�һ�
///��Σ�status������״̬ 0������ 1���ύ 2����� ��Ϊδ������
///modify by lmm 2018-10-23 �������ݲ�����ɾ����ť
function hideButton(status)
{
	
	if (status=="")
	{
		hiddenObj("BAudit",1);
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BCancel",1); 
		hiddenObj("BDelete",1);	
		hiddenObj("BSubmit",1); 
	}
	else if (status==0)
	{
		hiddenObj("BAudit",1);
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BCancel",1); 	
	}
	else if (status==1)
	{
		hiddenObj("BSubmit",1); 
		hiddenObj("BUpdate",1);
		hiddenObj("BDelete",1);	
	}
	else if (status==2)
	{
		hiddenObj("BCancelSubmit",1);
		hiddenObj("BAudit",1);
		hiddenObj("BSubmit",1); 
		hiddenObj("BUpdate",1);
		hiddenObj("BDelete",1);	
		
	}
	
}

/*
 * description ��Ա������ͳһת��;��Ҫ�õ�sessionת�����������GetSessionIDByMapԪ��
 * param type sessionֵ���� sessionID:sessionֵid
 * author zouxuan 2018-08-13
 * return ���ڶ��ձ�id
*/
function getSessionIDByMap(type,sessionID)
{
	var result=tkMakeServerCall("web.DHCEQCommon","getMapIDBySource",type,sessionID)
	return result;
}

/*
 * description �ж�Str�Ƿ���Strs���� ��true ��false
 * add by czf 20181211
*/
function StrIsInStrs(Strs,Str,Split)
{
	var OneStr="";
	var StrArray=Strs.split(Split);
	var i=StrArray.length;
	for (var j=0;j<i;j++)
	{
		OneStr=StrArray[j];
		if (OneStr==Str) return true;
	}
	return false;
}

/*
 * ����edittile�ı��margin-bottom����Ϊ8px
 * add by czf 20181211
*/
function SetTableMarginbottom()
{
	$('td[class="edittitle"]').each(function(){
		var obj = $(this);
		var tabobj=obj.closest("table");
		if(tabobj){
			tabobj.attr('style','margin-bottom:8px;')
		}
	})
}
//"1:YYYY-MM-DD"
//"11:YYYY��MM��DD��"
//"12:dd/mm/yyyy"
//"2:0.00"
//"3:�����Ƹ���-��ȡ
//"4:�ı���ʽ?��Ҫ�������豸��ŵȿ�ѧ��������ʾ������?
function ColFormat(val,format)
{
	if (format=="1")
	{
		return FormatDate(val,"","");
	}
	else if (format=="2")
	{
		val=val*100;
		val=Math.round(val,2);
		val=val/100;
		val=val.toFixed(2);
		return val;
	}
	else if (format=="3")
	{
		val=GetShortName(val,"-");
		return val;
	}
	else
	{
		return val
	}
	
}
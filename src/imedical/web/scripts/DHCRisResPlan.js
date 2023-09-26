
//DHCRisResPlan.js

var gBKUseTypeDR="";
function BodyLoadHandler()
{
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	var CreateSchuldeObj=document.getElementById("CreateSchulde");
	if (CreateSchuldeObj)
	{
		CreateSchuldeObj.onclick=CreateSchulde_click;
		
	}
	
	var deletePlanObj=document.getElementById("deletePlan");
	if (deletePlanObj)
	{
		deletePlanObj.onclick=DeletePlan_click;
	}
	//alert("H1")
	//��ѯ���Ե�½�Ŀ��Һ��ϴ�ѡ��Ŀ���
	GetLocName();
	//alert("H2")
	//��ѯ���ڵ�����
    GetWeekDesc();
    //alert("H3")
	//��ȡʱ��ε�����
    GetTimePeriodDesc();
    //alert("H4")
    //��ȡ������
    GetServiceGroup();
    //alert("H5")
    //������Դ���ɵĿ�ʼ�B��������
    GetResCreateDate();
    //alert("H6")
    //��ȡԤԼʹ�÷�ʽID��������ʽ
    GetUseType();
    //alert("H7")	
    var patTypeListObj=document.getElementById("patTypeList");
	if (patTypeListObj)
	{
		patTypeListObj.ondblclick=patTypeList_dblclick;
	}	
 
 	var showNotAvailObj=document.getElementById("ShowNotAvailPlan");
	if (showNotAvailObj)
	{
		showNotAvailObj.onclick=clickShowNotAvail;
	}
	
	if (document.getElementById("FindNotAvail").value=="Y")
	{
		document.getElementById("ShowNotAvailPlan").checked=true;
	}
}


function clickShowNotAvail()
{
	//var FindNotAvail="";
	//alert(document.getElementById("FindNotAvial").value);
	if (document.getElementById("ShowNotAvailPlan").checked)
		document.getElementById("FindNotAvail").value="Y";
	else
		document.getElementById("FindNotAvail").value="";
	//var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisBookTime&FindNotAvail="+FindNotAvail;
	//alert(lnk);
   	//location.href=lnk; 
}


function Add_click()
{
	var ErrorInfo;
	var LocId=document.getElementById("LocId").value;
	
	var ResourceId=document.getElementById("ResourceId").value;
	
	if (ResourceId=="")
	{
		alert("����ѡ����Դ!��");
		return;
	}
	
	//��������(1,2,3,4,5,6,7)
	var WeekNum=document.getElementById("Week").value;
	//ʱ��δ���
	var TimePeriodCode=document.getElementById("TimeDesc").value;
	//������ID
	var ServiceGroupId=document.getElementById("ServiceGroup").value;
	//alert("1");
	var StartTime=document.getElementById("StartTime").value;
	var ret=isTime(StartTime);
	if (ret==false)
	{
		ErrorInfo="��ʼʱ���ʽ����,ʱ���ʽӦΪ[xx:xx:xx]";
		alert(ErrorInfo);
		return ;
	}
	var EndTime=document.getElementById("EndTime").value;
	var ret=isTime(StartTime);
	if (ret==false)
	{
		ErrorInfo="����ʱ���ʽ����,ʱ���ʽӦΪ[xx:xx:xx]";
		alert(ErrorInfo);
		return ;
	}
	
	var BookMaxNumber=document.getElementById("MaxNumber").value;
	//if((BookMaxNumber=="")&(gBKUseTypeDR=="1"))
	if(BookMaxNumber=="")
	{
		alert("���������ԤԼ��!");
		return;
	}
	
	var BookAutoNumber=document.getElementById("AutoNumber").value;
	//if((BookAutoNumber=="")&(gBKUseTypeDR=="1"))
	if(BookAutoNumber=="")
	{
		alert("�������Զ�ԤԼ��!");
		return;
	}
	//alert("2")
    var intMaxNumber=parseInt(BookMaxNumber);
    var intAutoNumber=parseInt(BookAutoNumber);
    
    
    	
	if(intAutoNumber > intMaxNumber)
	{
		alert("�Զ�ԤԼ�����ܴ������ԤԼ��");
		return ;
	}
	
	var inChargeTime=document.getElementById("inChargeTime").value;
	if  (inChargeTime!="")
	{
		var ret=isTime(inChargeTime);
		if (ret==false)
		{
			ErrorInfo="ֹͣԤԼʱ���ʽ����,ʱ���ʽӦΪ[xx:xx:xx]";
			alert(ErrorInfo);
			return ;
		}
	}
	else
	{
		alert("ֹͣԤԼʱ�䲻��Ϊ�գ�");
		return;
	}
	
	//alert("3")
	
	//�жϸ�ʱ���Ƿ��Ѿ��������Դ�ƻ�
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisResPlan');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
    for (i=1;i<rows;i++)
    {
	    var iWeek=document.getElementById("WeekNumz"+i).value;
	    var TimeDescCode=document.getElementById("TimePeriodCodez"+i).value;
	    
	    var AddServiceGroupId=document.getElementById("ServiceGroupIdz"+i).value;
	    
	    if ((TimePeriodCode==TimeDescCode)&&(WeekNum==iWeek)&&(ServiceGroupId==AddServiceGroupId))
	    {
		    alert("��Դ�ƻ�����,�����ظ����");
		    return;
	    }
	}
	 var UseLock="N";
	 /*
	 if (document.getElementById("UseLock").checked)
     {
  	     var UseLock="Y";
     }
     else
     {
  	     var UseLock="N";
     }
     */
     var NotAllowIPBK="N";
     /*
	 if (document.getElementById("NotAllowIPBook").checked)
     {
  	     var NotAllowIPBK="Y";
     }
     else
     {
  	     var NotAllowIPBK="N";
     }
     */
     //alert("4")
     var availTime=document.getElementById("AvailTime").value;
     availTime=cTrim(availTime,0)
    var availPatTypeCode=document.getElementById("patTypeCode").value;
    availPatTypeCode=cTrim(availPatTypeCode,0)
    
    var notAvail="";
	if ( document.getElementById("notAvail").checked)
		notAvail="Y";
		
	var Info=LocId+"^"+ResourceId+"^"+WeekNum+"^"+ServiceGroupId+"^"+TimePeriodCode+"^"+StartTime+"^"+EndTime+"^"+BookMaxNumber+"^"+BookAutoNumber+"^"+inChargeTime+"^"+UseLock+"^"+availTime+"^"+NotAllowIPBK+"^"+availPatTypeCode+"^"+notAvail;
	//alert(Info);
	//web.DHCRisResourceApptSchudle.InsertResoucePlan
	var InsertResPlanInfoFun=document.getElementById("InsertResPlanInfo").value;
	var value=cspRunServerMethod(InsertResPlanInfoFun,Info);
	var Ret=value.split("^")
	if (Ret[0]!="0")
	{
		var Info="������Դ�ƻ�ʧ��:SQLCODE="+Ret[0];
		alert(Info);
	}
	else
	{
		var Resource=document.getElementById("Resource").value
		
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisResPlan&LocId="+LocId+"&ResourceId="+ResourceId+"&Resource="+Resource;
   		location.href=lnk; 
	}
	
	
}
function Delete_click()
{
	var SelRowid=document.getElementById("SelRowid").value;
	if (SelRowid=="")
	{
		alert("����ѡ��һ���Ű��¼!��");
		return;
	}
	var DeleteResPlanInfoFun=document.getElementById("DeleteResPlanInfo").value;
	var ret=cspRunServerMethod(DeleteResPlanInfoFun,SelRowid);
	if (ret!="0")
	{
		var Info="��Դ�ƻ��Ѿ����ɣ�����ɾ��";
		alert(Info);
	}
	else
	{
		var Resource=document.getElementById("Resource").value;
		var LocId=document.getElementById("LocId").value;
	
		var ResourceId=document.getElementById("ResourceId").value;
	

		
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisResPlan&LocId="+LocId+"&ResourceId="+ResourceId+"&Resource="+Resource;
   		location.href=lnk; 
	}

	
}

function Modi_click()
{
	var ErrorInfo;
	var LocId=document.getElementById("LocId").value;
	
	var ResourceId=document.getElementById("ResourceId").value;
	
	if (ResourceId=="")
	{
		alert("����ѡ����Դ!��");
		return;
	}
	
	//��������(1,2,3,4,5,6,7)
	var WeekNum=document.getElementById("Week").value;
	//ʱ��δ���
	var TimePeriodCode=document.getElementById("TimeDesc").value;
	//������ID
	var ServiceGroupId=document.getElementById("ServiceGroup").value;
	
	var StartTime=document.getElementById("StartTime").value;
	var ret=isTime(StartTime);
	if (ret==false)
	{
		ErrorInfo="��ʼʱ���ʽ����,ʱ���ʽӦΪ[xx:xx:xx]";
		alert(ErrorInfo);
		return ;

	}
	var EndTime=document.getElementById("EndTime").value;
	var ret=isTime(StartTime);
	if (ret==false)
	{
		ErrorInfo="����ʱ���ʽ����,ʱ���ʽӦΪ[xx:xx:xx]";
		alert(ErrorInfo);
		return ;

	}
	
	var BookMaxNumber=document.getElementById("MaxNumber").value;
	
	var BookAutoNumber=document.getElementById("AutoNumber").value;
	if(BookMaxNumber=="")
	{
		alert("���������ԤԼ��!");
		return;
	}
	
	if(BookAutoNumber=="")
	{
		alert("�������Զ�ԤԼ��!");
		return;
	}
	
	var intMaxNumber=parseInt(BookMaxNumber);
    var intAutoNumber=parseInt(BookAutoNumber);
    
    if(intAutoNumber > intMaxNumber)
	{
		alert("�Զ�ԤԼ�����ܴ������ԤԼ��");
		return ;
	}
	
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("����ѡ��һ���Ű��¼!��");
		return;
	}
	
	var inChargeTime=document.getElementById("inChargeTime").value;
	if  (inChargeTime!="")
	{
		var ret=isTime(inChargeTime);
		if (ret==false)
		{
			ErrorInfo="ֹͣԤԼʱ���ʽ����,ʱ���ʽӦΪ[xx:xx:xx]";
			alert(ErrorInfo);
			return ;
		}
	}
	else
	{
		alert("ֹͣԤԼʱ�䲻��Ϊ�գ�");
		return;
	}
	
	 var UseLock="N";
	 /*
	 if (document.getElementById("UseLock").checked)
     {
  	     var UseLock="Y";
     }
     else
     {
  	     var UseLock="N";
     }
     */
     var NotAllowIPBK="N";
     /*
	 if (document.getElementById("NotAllowIPBook").checked)
     {
  	     var NotAllowIPBK="Y";
     }
     else
     {
  	     var NotAllowIPBK="N";
     }
	*/
	var availTime=document.getElementById("AvailTime").value;
    availTime=cTrim(availTime,0);
    var availPatTypeCode=document.getElementById("patTypeCode").value;
    availPatTypeCode=cTrim(availPatTypeCode,0);
    
    var notAvail="";
	if ( document.getElementById("notAvail").checked)
		notAvail="Y";
    
	var Info=LocId+"^"+ResourceId+"^"+WeekNum+"^"+ServiceGroupId+"^"+TimePeriodCode+"^"+StartTime+"^"+EndTime+"^"+BookMaxNumber+"^"+BookAutoNumber+"^"+SelRowid+"^"+inChargeTime+"^"+UseLock+"^"+availTime+"^"+NotAllowIPBK+"^"+availPatTypeCode+"^"+notAvail;
	
	//web.DHCRisResourceApptSchudle.UpdateResoucePlan
	var UpdateResPlanInfoFun=document.getElementById("UpdateResPlanInfo").value;
	var ret=cspRunServerMethod(UpdateResPlanInfoFun,Info);
	if (ret!="0")
	{
	     var Info="������Դ�ƻ�ʧ��:SQLCODE="+ret;
		alert(Info);
	}
	else
	{
		var Resource=document.getElementById("Resource").value
		
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisResPlan&LocId="+LocId+"&ResourceId="+ResourceId+"&Resource="+Resource;
   		location.href=lnk; 
	}
	
}

function CreateSchulde_click()
{
	//var Resource=document.getElementById("Resource").value;
	var LocId=document.getElementById("LocId").value;
	var ResourceId=document.getElementById("ResourceId").value;
	var StartDate=document.getElementById("StartDate").value;
	var EndDate=document.getElementById("EndDate").value;
	var Info;
	
	if (document.getElementById("IsLocCreateSchulde").checked)
    {
	   ConFlag=confirm('ȷ������ǰ���Ҷ������豸�����Ű�!');
	   if (ConFlag==false){return}
  	   var GetResIdByFun=document.getElementById("GetResIdByLocRowid").value;
	   ResourceId=cspRunServerMethod(GetResIdByFun,LocId);
    }
     
    Info=LocId+"^"+ResourceId+"^"+StartDate+"^"+EndDate;
	
	//web.DHCRisResourceApptSchudle.CreateResApptSchulde
	var CreateResApptSchuldeFun=document.getElementById("CreateResApptSchulde").value;
	var ret=cspRunServerMethod(CreateResApptSchuldeFun,Info);
	if (ret=="0")
	{
		alert("������Դ�ƻ��ɹ�!");
	}
	else
	{
		alert("������Դ�ƻ�ʧ��!");
	}
	
}



function DeletePlan_click()
{
	//var Resource=document.getElementById("Resource").value;
	var LocId=document.getElementById("LocId").value;
	var ResourceId=document.getElementById("ResourceId").value;
	var StartDate=document.getElementById("StartDate").value;
	var EndDate=document.getElementById("EndDate").value;
	
	var Info;
	var hint = "�Ƿ�ɾ��";
	if (document.getElementById("IsLocCreateSchulde").checked)
    {
	   hint = hint + " ����ȫ����Դ ";
	   //web.DHCRisCommFunction.GetResIdByLocRowid
  	   var GetResIdByFun=document.getElementById("GetResIdByLocRowid").value;
	   ResourceId=cspRunServerMethod(GetResIdByFun,LocId);
    }
    else
    {
	    hint=hint+" "+document.getElementById("Resource").value+" ";
    }
     
    if ( ResourceId=="")
    {
	    alert("��ѡ����Դ");
	    return;
    }
    
    var stDateList=StartDate.split("/");
    var endDateList=EndDate.split("/");
    var stDate="";
    var eDate="";
    if (stDateList.length==3)
    {
     	stDate=stDateList[2]+"-"+stDateList[1]+"-"+stDateList[0];
    }
    else
    {
	    stDate=StartDate
    }
    if (endDateList.length==3)
    {
    	eDate=endDateList[2]+"-"+endDateList[1]+"-"+endDateList[0];
    }
    else
    {
	    eDate=EndDate;
    }
    hint=hint+" "+stDate+"��"+eDate+" ��ԤԼ�ƻ�?";
    if ( false==confirm(hint))
    	return;
    
    Info=LocId+"^"+ResourceId+"^"+StartDate+"^"+EndDate;
	//alert(Info);
	
	var rets=tkMakeServerCall("web.DHCRisResourceApptSchudle","deleteResApptSchulde",Info);
  	//alert(rets);
  	var ret = rets.replace("^","\r\n");
  	//alert(ret);
  	if (ret!="")
  		alert(ret);
  	else
  		alert("ɾ���ɹ�!");
  	
	
}

function GetLocName()
{
	var LocID=document.getElementById("LocId");
    if (LocID.value=="")
    {
       var GetLocSessionFunction=document.getElementById("GetLocSession").value;
	   var Getlocicvalue=cspRunServerMethod(GetLocSessionFunction,"SelLocID");
	   if (Getlocicvalue=="")
         LocID.value=session['LOGON.CTLOCID'];
       else 
 		 LocID.value=Getlocicvalue;
	}
    var LocName=document.getElementById("LocName").value;
	if (LocName=="")
	{
	   var GetLocNameFunction=document.getElementById("FunLocName").value;
	   var value=cspRunServerMethod(GetLocNameFunction,LocID.value);
       var LocName=document.getElementById("LocName");
       LocName.value=value;
	}
}

//select special location 
function GetSelectedLocInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("LocName").value=Item[0];
  document.getElementById("LocId").value=Item[1];
  
  //put selected locid into session
   var SetSessionLocid=document.getElementById("SetLocsession").value;
   cspRunServerMethod(SetSessionLocid,"SelLocID",Item[1]);
}

//select special location 
function GetResEndDateInfo(Info)
{
  Item=Info.split("^");
  document.getElementById("ResEndDate").value=Item[0]+": "+Item[1];
}

function GetLocResource(Info)
{
	Item=Info.split("^");
    document.getElementById("Resource").value=Item[0];
    document.getElementById("ResourceId").value=Item[1];
}

//��ѯ���ڵ�����
function GetWeekDesc()
{
    WeekObj=document.getElementById("Week");
    if (WeekObj)
    {
	    //WeekObj.onchange=onSexchange;
    	//WeekObj.onkeydown =onSexkeydown;
 		combo("Week");
		var GetWeekInfoFunction=document.getElementById("GetWeekInfo").value;
		var Info1=cspRunServerMethod(GetWeekInfoFunction);
    	AddItem("Week",Info1);
    }
}

//��ȡʱ��ε�����
function GetTimePeriodDesc()
{
    TimeDescObj=document.getElementById("TimeDesc");
    if (TimeDescObj)
    {
	    //TimeDescObj.onchange=onSexchange;
    	//TimeDescObj.onkeydown =onSexkeydown;
    	TimeDescObj.onchange=changeTimeDesc;
    
    	
 		combo("TimeDesc");
 		//web.DHCRisResourceApptSchudle.GetTimePeriodInfo
		var GetTimePeriodInfoFunction=document.getElementById("GetTimePeriodInfo").value;
		var Info1=cspRunServerMethod(GetTimePeriodInfoFunction);
    	AddItem("TimeDesc",Info1);
    	changeTimeDesc();
    }
}

//��ȡ������
function GetServiceGroup()
{
    ServiceGroupObj=document.getElementById("ServiceGroup");
    if (ServiceGroupObj)
    {
	    //ServiceGroupObj.onchange=onSexchange;
    	//ServiceGroupObj.onkeydown =onSexkeydown;
 		combo("ServiceGroup");
		var GetTimePeriodInfoFunction=document.getElementById("GetServiceGroupInfo").value;
		var Info1=cspRunServerMethod(GetTimePeriodInfoFunction);
    	AddItem("ServiceGroup",Info1);
    }
}



function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
	} 
}

//������Դ���ɵĿ�ʼ�B��������
function GetResCreateDate()
{
	
	var StdateObj=document.getElementById("StartDate");
	var eddateObj=document.getElementById("EndDate");

	if (StdateObj.value=="")
	{
		StdateObj.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","0");
		eddateObj.value=tkMakeServerCall("web.DHCRisCommFunctionEx","getDateHtml","30");
	}
	
}

function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisResPlan');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	var TWeek= document.getElementById("TWeekz"+selectrow).innerText;
	var WeekNum=document.getElementById("WeekNumz"+selectrow).value;
	var TperiodTime= document.getElementById("TperiodTimez"+selectrow).innerText;
	var TimePeriodCode =document.getElementById("TimePeriodCodez"+selectrow).value;
	var TServiceGroup= document.getElementById("TServiceGroupz"+selectrow).innerText;
	var ServiceGroupId= document.getElementById("ServiceGroupIdz"+selectrow).value;
	var TStartTime= document.getElementById("TStartTimez"+selectrow).innerText;
	var TEndTime = document.getElementById("TEndTimez"+selectrow).innerText;
	var TMaxBookNumber= document.getElementById("TMaxBookNumberz"+selectrow).innerText;
	//alert("1");
	TMaxBookNumber=cTrim(TMaxBookNumber,0)
	//alert("2");
	var TAutoNumber= document.getElementById("TAutoNumberz"+selectrow).innerText;
	TAutoNumber=cTrim(TAutoNumber,0)
	var Rowid=document.getElementById("RowIdz"+selectrow).value;
	var ChargeTime=document.getElementById("ChargeEndTimez"+selectrow).innerText;
	//var UseLock=document.getElementById("TUseLockz"+selectrow).innerText;
	var AvailTime=document.getElementById("TAvailTimez"+selectrow).innerText;
	AvailTime=cTrim(AvailTime,0)
	//alert("3");
	//var NotAllowIPBK=document.getElementById("TNotAllowIPBookz"+selectrow).innerText;
	var availPatType=document.getElementById("TAvailPatTypez"+selectrow).innerText;
	availPatType=cTrim(availPatType,0);
	var availPatTypeCode=document.getElementById("TAvailPatTypeCodez"+selectrow).value;
	availPatTypeCode=cTrim(availPatTypeCode,0);
	
	var notAvail=document.getElementById("TNotAvailz"+selectrow).innerText;
	
	if (notAvail=="Y")
		document.getElementById("notAvail").checked=true;
	else
		document.getElementById("notAvail").checked=false;

	var Weekobj=document.getElementById("Week");
	if (Weekobj)
	{
		Weekobj.value=WeekNum;
		Weekobj.text=TWeek;
	
	}
	//ʱ��δ���
	var TimeDescObj=document.getElementById("TimeDesc");
	if (TimeDescObj)
	{
		TimeDescObj.value=TimePeriodCode;
		TimeDescObj.text=TperiodTime;
		
	}

	//������ID
	var ServiceGroupObj=document.getElementById("ServiceGroup");
	if (ServiceGroupObj)
	{
		ServiceGroupObj.value=ServiceGroupId;
		ServiceGroupObj.text=TServiceGroup;
	}
	
	var StartTimeObj=document.getElementById("StartTime");
	if (StartTimeObj)
	{
		StartTimeObj.value=TStartTime;
		
	}
	
	var EndTimeObj=document.getElementById("EndTime");
	if (EndTimeObj)
	{
		EndTimeObj.value=TEndTime;
	}
	
	var MaxNumberObj=document.getElementById("MaxNumber");
	if (MaxNumberObj)
	{
		MaxNumberObj.value=TMaxBookNumber;
		
	}
	var AutoNumberObj=document.getElementById("AutoNumber");
	if (AutoNumberObj)
	{
		AutoNumberObj.value=TAutoNumber;
	}
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=Rowid;
	}
	
		
	var inChargeTimeObj=document.getElementById("inChargeTime");
	if  (inChargeTimeObj)
	{
		inChargeTimeObj.value=ChargeTime;
		if (inChargeTimeObj.value==" ") inChargeTimeObj.value="";
	}
	/*
	if(UseLock=="Y")
	{
	  document.getElementById("UseLock").checked=true;	
	}
	else
	{
	  document.getElementById("UseLock").checked=false;	
	}
	*/
	
	var availTimeObj=document.getElementById("AvailTime");
	if ( availTimeObj)
		availTimeObj.value=AvailTime
	/*
    if(NotAllowIPBK=="Y")
	{
	  document.getElementById("NotAllowIPBook").checked=true;	
	}
	else
	{
	  document.getElementById("NotAllowIPBook").checked=false;	
	}
	*/
	var availPatTypeCodeObj=document.getElementById("patTypeCode");
	if (availPatTypeCodeObj)
		availPatTypeCodeObj.value=availPatTypeCode;
		
	var availPatTypeObj=document.getElementById("patType");
	if (availPatTypeObj)
		availPatTypeObj.value=availPatType;
		
     
}

function isTime(str) 
{ 
	var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/); 
	if (a == null)
	{
		return false;
	} 
	if (a[1]>24 || a[3]>60 || a[4]>60) 
	{ 
		return false 
	} 
	return true; 
} 

function DateDemo()
{
   var d, s="";           // ��������?
   d = new Date(); 
   var sDay="",sMonth="",sYear="";
   sDay = d.getDate();			// ��ȡ��?
   if(sDay < 10)
   sDay = "0"+sDay;
    
   sMonth = d.getMonth()+1;		// ��ȡ�·�?
   if(sMonth < 10)
   sMonth = "0"+sMonth;
   
   sYear  = d.getFullYear();		// ��ȡ���?
   s = sDay + "/" + sMonth + "/" + sYear;
   return(s); 
   
}

function getRelaDate(offset)
{
	var obj=new Date();
	var ms=obj.getTime();
	var offsetms=60*60*24*offset*1000;
	var newms=ms+offsetms;
	var newdate=new Date(newms);
	return formatDate(newdate);
}

function formatDate(dateobj)
{
	var sep="/";
	var day=dateobj.getDate();
	if (day<10) day="0"+day;
	var mon=dateobj.getMonth()+1;
	if (mon<10) mon="0"+mon ;
	var year=dateobj.getFullYear();
	return day+sep+mon+sep+year

}

function changeTimeDesc()
{
	//TimeDesc
	var TimeDescObj=document.getElementById("TimeDesc");
	if (TimeDescObj)
	{
		var TimeRowid=TimeDescObj.value; 
		var GetTimeInfoFunction=document.getElementById("GetTimeInfo").value;
	    var value=cspRunServerMethod(GetTimeInfoFunction,TimeRowid);
    	Info=value.split("^");
    	var StartTimeObj=document.getElementById("StartTime");
		if (StartTimeObj)
		{
			StartTimeObj.value=Info[2];
		}
	
		var EndTimeObj=document.getElementById("EndTime");
		if (EndTimeObj)
		{
			EndTimeObj.value=Info[3];
		}

		var inChargeTimeObj=document.getElementById("inChargeTime");
		if  (inChargeTimeObj)
		{
			inChargeTimeObj.value=Info[4];
			if (inChargeTimeObj.value==" ") inChargeTimeObj.value="";
		}
     }

}

function GetUseType()
{
	var LocID=document.getElementById("LocId").value;
    var BKTypeFunction=document.getElementById("GetBKUseFlagbyLoc").value;
	    gBKUseTypeDR=cspRunServerMethod(BKTypeFunction,LocID);
	/*    
	if (gBKUseTypeDR=="2")
    {
	   document.getElementById("MaxNumber").disabled=true;
	   document.getElementById("AutoNumber").disabled=true;
	} 
	else
	{
		document.getElementById("AvailTime").disabled=true;
	}  */
	if (gBKUseTypeDR=="1")
	{
		document.getElementById("AvailTime").disabled=true;
	}
}

function patTypeList_dblclick()
{
	var patTypeSel=this.options[this.selectedIndex].text;
	var patCodeSel=this.options[this.selectedIndex].value;
	var patType=document.getElementById("patType").value;
	var patCode=document.getElementById("patTypeCode").value;
	//alert(patTypeSel);
	//alert(patType);
	document.getElementById("patType").value=dealString(patTypeSel,patType);
	document.getElementById("patTypeCode").value=dealString(patCodeSel,patCode);
	
}

function dealString(value,list)
{
	var listArray=list.split(";");
	var length=listArray.length;
	var listRet="";
	var hasValue=0;
	for (j=0;j<length;j++)
	{
		if (listArray[j]=="")
		{
			continue;
		}
		if (listArray[j]!=value)
		{
			if (listRet=="")
				listRet=listArray[j];
			else
				listRet=listRet+";"+listArray[j];
		}
		else
			hasValue=1;
	}
	if(hasValue==0)
	{
		if (listRet=="")
			listRet=value;
		else
			listRet=listRet+";"+value;
	}
	return listRet;
}

document.body.onload = BodyLoadHandler;


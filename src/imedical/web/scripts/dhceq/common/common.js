///ȥ�����˿ո�
function trim(s)
{ 
	return s.replace(/(^\s*)|(\s*$)/g, ""); 
} 

///Mozy		929782	2019-06-13	��ʽ����������
function GetCurrentDate()			
{
	var yy, mm, dd, s="";
   	var d = new Date();							// ��������Date
   	yy = d.getFullYear();						// ��ȡ���
   	mm = d.getMonth()+1;						// ��ȡ�·�
	mm = mm < 10 ? "0" + mm : mm;
	dd = d.getDate();							// ��ȡ��
	dd = dd < 10 ? "0" + dd : dd;
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat");
	if ((SysDateFormat=="")||(SysDateFormat==4))
	{
	   	s = dd + "/" + mm + "/" + yy;
	}
	if (SysDateFormat=="1")
	{
	   	s = mm + "/" + dd + "/" + yy;
	}
	if (SysDateFormat=="3")
	{
	   	s = yy + "-" + mm + "-" + dd;
	}
   return(s);                                // ��������
}

/*****************************************************
ȡָ�������x����
*****************************************************/
function getx(e){
  var l=e.offsetLeft;
  while(e=e.offsetParent){
    l+=e.offsetLeft;
    }
  return(l);
  }
/*****************************************************
ȡָ�������y����
*****************************************************/
function gety(e){
  var t=e.offsetTop;
  while(e=e.offsetParent){
    t+=e.offsetTop;
    }
  return(t);
  }
  
  ///�õ������ļ�·��  Add 2007-01-11
function GetFileName()
{
	if (getElementValue("ChromeFlag")=="1")  //Moidefied by zc0068 ��Ԫ��ȡֵGetElementValue�ĳ�getElementValue
	{
		var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"   
		Str +="var fName = xlApp.GetSaveAsFilename('','Excel File(*.xls),*.xls');"
		Str +="if (fName==false){return ''}"
		Str += "return fName}());";
		CmdShell.notReturn =0;   //�����޽�����ã�����������
		var rtn = CmdShell.EvalJs(Str);   //ͨ���м������
		return rtn.rtn
	}
	else
	{
		try 
		{
			var xls = new ActiveXObject("Excel.Application");   
			var fName = xls.GetSaveAsFilename("","Excel File(*.xls),*.xls")
			if (fName==false)
			{
			 fName=""
			}
			return fName
		}
		catch(e)
		{
			return "";
		}
	}
}

function ChangeDateFormat(DateStr)
{
	if (DateStr=="") return "";
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat")
	if ((SysDateFormat=="")||(SysDateFormat==4))
	{
		var DateList=DateStr.split("/");
		var NewDateStr=DateList[2]+"��"+DateList[1]+"��"+DateList[0]+"��";
	}
	if (SysDateFormat=="1")
	{
		var DateList=DateStr.split("/");
		var NewDateStr=DateList[2]+"��"+DateList[0]+"��"+DateList[1]+"��";
	}
	if (SysDateFormat=="3")
	{
		var DateList=DateStr.split("-");
		var NewDateStr=DateList[0]+"��"+DateList[1]+"��"+DateList[2]+"��";
	}
	return NewDateStr;
}


///��18/01/2007תΪ2007��1��18��
function FormatDate(DateStr,FromFormat,ToFormat)
{
	if (DateStr=="") return "";
	var year,month,day
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat")
	if ((SysDateFormat=="")||(SysDateFormat==4))
	{
		var DateList=DateStr.split("/");
		year=DateList[2];
		month=DateList[1];
		day=DateList[0]
	}
	if (SysDateFormat=="1")
	{
		var DateList=DateStr.split("/");
		year=DateList[2];
		month=DateList[0];
		day=DateList[1]
	}
	if (SysDateFormat=="3")
	{
		var DateList=DateStr.split("-");
		year=DateList[0];
		month=DateList[1];
		day=DateList[2]
	}
	if(year.length==2) year="19"+year;
	var NewDateStr=year+"-"+month+"-"+day;
	return NewDateStr;
}


///Modified by JDL 2009-06-4  JDL0011
/// ����ָ���ָ���?��ȡ�����ַ�,���±�д?�����ж���ָ�������
///��"xyk-��ҩ��"תΪ"��ҩ��"
function GetShortName(NameStr,SplitStr)
{
	var strnew=""
	var list=NameStr.split(SplitStr)
	for (var i=0;i<list.length;i++)
 	{
	 	var mid=list.length/2;
	 	mid=parseInt(mid);
	 	if (i>mid-1)
	 	{
		 	if (""!=strnew) strnew=strnew+SplitStr;
		 	strnew=strnew+list[i]
		}
 	}
	return strnew;
}

///�ж�Str�Ƿ���Strs���� ��true ��false
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


function IncludeJs($script){
   var script = document.createElement('script');
   script.src = "../scripts/" + $script;
   script.type = 'text/javascript';
   var head = document.getElementsByTagName('head').item(0);
   head.appendChild(script);
}

///Add by DJ 2009-05-20  DJ0002
///���ݴ��������
function PackageData(value)
{
 	var ElementName=value.split("^")
 	var valuestr=""
 	for (var i=0;i<ElementName.length;i++)
 	{
  		var obj=document.getElementById(ElementName[i])
  		if (obj)
  		{
   			valuestr=valuestr+"^"+ElementName[i]+"="+getElementValue(ElementName[i],"");  //modify by lmm 2018-10-30
  		}
 	}
 	return valuestr
}


///Add by JDL 2009-06-24  JDL0019
///���ݽ���,����Ԫ�����ƴ����ݰ����ȡ����
function GetValueByName(value,name)
{
	var List=value.split("^");
	var ElementInfo,ElementName,ElementValue;
	ElementValue="";
	for (var i=0;i<List.length;i++)
	{
		ElementInfo=List[i];
		ElementInfo=ElementInfo.split("=");
		ElementName=ElementInfo[0];
		ElementValue=ElementInfo[1];
		if (ElementName==name) return ElementValue;
	}
	return ElementValue;
}

function CloseWindow()
{
	if (window.parent)
	{
		window.parent.close();
	}
	else
	{
		window.close();
	}
}

///��������Ԫ��
///type:���� 0��ǩ  1�ı���  2���Ŵ󾵵��ı���  3����  4������
///listInfo:������Ϊ������ʱ?��������Ϣ value1^text1&value2^text2.......
function CreatElementHtml(type,id,width,height,keydownEvent,changeEvent,listInfo,keyupEvent,keypressEvent)
{
	var html;
	html="";	
	var Style="";
		var ComponentItemInfo=getElementValue("GetComponentItemInfo");  //modify by lmm 2018-1030
		if (ComponentItemInfo!="")
		{
			var offset=id.lastIndexOf("z");
			var objindex=id.substring(offset+1);
			var colName=id.substring(0,offset);
			var DataType=GetDataByName(ComponentItemInfo,colName,"&","=")
			if (DataType=="%Library.Float") Style=" ; TEXT-ALIGN: right; padding-right:2px "
		}
	if (!keypressEvent) keypressEvent=""; 	//ZY0055 2011-2-15
	if (0==type)
	{
		html="<label id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height + Style +"\" value=\"\">"
	}
	else if (1==type)
	{
		html="<input type=text id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height + Style +"\" value=\"\"";
		if (keyupEvent!="")
		{html=html+" onkeyup=\""+keyupEvent+"()\"";}
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		if (keypressEvent!="")
		{html=html+" onkeypress=\""+keypressEvent+"()\"";}
		html=html+">"
	}
	else if (2==type)
	{
		width=AdjustWidth(width);
		html="<input type=text id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height +"\" value=\"\"";
		if (keyupEvent!="")
		{html=html+" onkeyup=\""+keyupEvent+"()\"";}
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		html=html+">"
		var IMGId="ldi"+id;
		html=html+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookup.gif\"";
		if (keydownEvent!="")
		{html=html+" onclick=\""+keydownEvent+"(1)\"";}
		html=html+">"
	}
	else if (3==type)
	{
		width=AdjustWidth(width,25);
		html="<input type=text id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height +"\" value=\"\"";
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		html=html+">"
		var IMGId="ldi"+id;
		html=html+"<IMG id=\""+IMGId+"\" name=\""+IMGId+ "\" src=\"../images/websys/lookupdate.gif\"";
		if (keydownEvent!="")
		{html=html+" onclick=\""+keydownEvent+"(1)\"";}
		html=html+">"
	}
	else if (4==type)
	{
		html="<select name=\""+id+"\" id=\""+id+"\" style=\"WIDTH:"+width+" ;HEIGHT:"+height+"\""
		if (keydownEvent!="")
		{html=html+" onkeydown=\""+keydownEvent+"()\"";}		
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}
		html=html+">"
		var list=listInfo.split("&")
		for (var Row=0;Row<list.length;Row++)
		{
			var option=list[Row].split("^");
			html=html+"<option value="+option[0]+">"+option[1]+"</option>"
		}
		html=html+"</select>"
	}
	else if (5==type)
	{
		html="<input type=checkbox id=\""+id+"\" name=\""+id+ "\" style=\"WIDTH:" + width + " ;HEIGHT:" + height +"\" value=\"\"";
		if (keyupEvent!="")
		{html=html+" onkeyup=\""+keyupEvent+"()\"";}
		if (changeEvent!="")
		{html=html+" onchange=\""+changeEvent+"()\"";}	
		if (keydownEvent!="")
		{html=html+" onclick=\""+keydownEvent+"()\"";}
		html=html+">"
	}
	return html;
}

function DateDiff(sDate1, sDate2) 
{
	 //sTime1��sTime2��18/12/2002��ʽ
	if ((sDate1=="")||(sDate2=="")) return 0
    var aDate, oDate1, oDate2, iDays;
     
	var SysDateFormat=tkMakeServerCall("websys.Conversions","DateFormat")  
	if ((SysDateFormat=="")||(SysDateFormat==4))
	{
	    aDate = sDate1.split("/");
	    oDate1 = new Date(aDate[2],aDate[1]-1,aDate[0]);
	    aDate = sDate2.split("/");   
	    oDate2 = new Date(aDate[2],aDate[1]-1,aDate[0]);  
	} 
	if (SysDateFormat=="1")
	{
	    aDate = sDate1.split("/");
	    oDate1 = new Date(aDate[2],aDate[0]-1,aDate[1]);
	    aDate = sDate2.split("/");   
	    oDate2 = new Date(aDate[2],aDate[0]-1,aDate[1]);  
	}
	if (SysDateFormat=="3")
	{
	    aDate = sDate1.split("-");
	    oDate1 = new Date(aDate[0],aDate[1]-1,aDate[2]);
	    aDate = sDate2.split("-");   
	    oDate2 = new Date(aDate[0],aDate[1]-1,aDate[2]);  
	}
	
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 /24).toFixed(0);     
    if((oDate1 - oDate2)<0)
    {
        return -iDays;
    }   
    return iDays;  
}
function TimeDiff(sTime1, sTime2) 
{ //sDate1��sDate2��10:59��ʽ     
	if ((sTime1=="")||(sTime2=="")) return 0
    var aTime, oTime1, oTime2, iHours;   
    aTime = sTime1.split(":");
    oTime1 = new Time(aTime[0],aTime[1]);
    aTime = sTime2.split(":");   
    oTime2 = new Time(aTime[0],aTime[1]); 
    iHours=((oTime1.Hour - oTime2.Hour)+(oTime1.Minute - oTime2.Minute)/ 60).toFixed(0)
    if((iHours)<0)
    {
        return parseInt(iHours);
    }
    iHours = parseInt(Math.abs(iHours));
    return iHours;
}
///����ʱ�����
function Time(hour,minute)
{
	this.Hour=hour;
	this.Minute=minute;
}

///add by jdl 2011-12-9 JDL0104
///��IDs���Ƴ�ָ��ID,IDs�ķָ���Ĭ��Ϊ","
function RemoveIDFromIDs(IDs,ID,SplitStr)
{
	if (IDs=="") return IDs;
	if (SplitStr=="") SplitStr=",";
	IDs=SplitStr+IDs+SplitStr;
	ID=SplitStr+ID+SplitStr;
	IDs=IDs.replace(ID,SplitStr);
	IDs=IDs.substring(1,IDs.length - 1);
	if (IDs==SplitStr) IDs="";
	return IDs;
}

///add by jdl 2011-12-9 JDL0104
///��IDs���Ƴ�ָ��ID,IDs�ķָ���Ĭ��Ϊ","
function AddIDToIDs(IDs,ID,SplitStr)
{
	if (IDs=="") return ID;
	if (SplitStr=="") SplitStr=",";
	IDs=SplitStr+IDs+SplitStr;
	if (IDs.indexOf(SplitStr+ID+SplitStr)<0)
	{					
		IDs=IDs+ID+SplitStr;
	}
	IDs=IDs.substring(1,IDs.length - 1);
	return IDs;
}


///Add By DJ 2015-08-07
///����:����������ȡ��Ϣ���е���ֵ
///����:vStrInfo   ��ʽ:��1=ֵ1&��2=ֵ2&��3=ֵ3&��4=ֵ4&
///		vFiledName  ����
///		vRecordFlag ������֮��ָ��"&"
///		vFiledFlag  ��������ֵ֮��ָ���"="
function GetDataByName(vStrInfo,vFiledName,vRecordFlag,vFiledFlag)
{
	if (vStrInfo=="")	return ""
	var FiledStr=vStrInfo.split(vRecordFlag)
	for (var i=0;i<FiledStr.length;i++)
	{
		var OneFiledStr=FiledStr[i]
		if (OneFiledStr!="")
		{
			var FiledInfo=OneFiledStr.split(vFiledFlag)
			var FiledName=FiledInfo[0]
			var FiledValue=FiledInfo[1]
			if (FiledName==vFiledName)
			{
				return FiledValue
			}
		}
	}
}


///add by zy 2015-9-22
///���ֽ��ת��д���
///num  ������
function ChineseNum(num) 
{
	num=num.toFixed(2)
	if (!/^(0|[1-9]\d*)(\.\d+)?$/.test(num))  return "���ݷǷ�";
	var unit = "ǧ��ʰ��ǧ��ʰ��ǧ��ʰԪ�Ƿ�";
	var str = ""; 
	num += "00";
	var p = num.indexOf('.');
	if (p >= 0) 
	{
		num = num.substring(0, p) + num.substr(p+1, 2);
		unit = unit.substr(unit.length - num.length);
	}	
	for (var i=0; i < num.length; i++)
	{
		str += '��Ҽ��������½��ƾ�'.charAt(num.charAt(i)) + unit.charAt(i);
	}
	return str.replace(/��(ǧ|��|ʰ|��)/g, "��").replace(/(��)+/g, "��").replace(/��(��|��|Ԫ)/g, "$1").replace(/(��)��|Ҽ(ʰ)/g, "$1$2").replace(/^Ԫ��?|���/g, "").replace(/Ԫ$/g, "Ԫ��");
} 

//add by HHM 20150910 HHM0013
//���ҵ�񵥾ݲ����ɹ����Ƿ���ʾ
function ShowMessage(msg)
{
	if ((!msg)||(""==msg))
	{
		msg="�����ɹ���"
	}
	var rtn=getElementValue("GetSuccessMsg");  //modify by lmm 2018-10-30
	if(rtn=="1") {	messageShow("","","",msg);	}
}
function isNumber(value) {
    var patrn = /^[0-9]*$/;
    if (patrn.exec(value) == null || value == "") {
        return false
    } else {
        return true
    }
}
/*******************************************************************************************/
/*******************************************************************************************/
/*******************************************************************************************/
///Add By DJ 2018-07-30
///����:JSҳ���ʼ�������û��Զ������͵�JSͨ����Ϣ��JSҵ����Ϣ
///���:vBuss ҵ����
///����ֵ:��
function initMessage(vBuss)
{
	var PromptJsonInfo=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetPromptInfo",vBuss)
	var PromptObj=JSON.parse(PromptJsonInfo)
	for (var key in PromptObj)
	{
		t[key]=PromptObj[key]
	}
	initTooltipInfo()
}
///Add By DJ 2018-07-30
///����:�����ַ�����Ӧ��ƴ����,����Ϊ��������ĸ
///���:streInput �ַ���
///����ֵ:�����ַ�����Ӧ��ƴ������ĸ�ַ���
function getPYCode(strInput)
{
	var rtnStr=tkMakeServerCall("web.DHCEQ.Plat.CTCHanZiEncoding","GetEncoding",strInput,'4','','U');
	var obj = JSON.parse(rtnStr);
	return obj.Data;
}
///Add By DJ 2018-07-30
///����:��ȡ���Ԫ�ض�Ӧ�ı�����
///���:ename ҳ��Ԫ����
///����ֵ:ʧ�ܷ���null  �ɹ����ر�����
function getParentTable(ename)
{
	var obj=document.getElementById(ename);
	if (!obj) return null;
	while(obj!=null)
	{
		obj=obj.parentElement;
		if ((obj)&&(obj.tagName.toUpperCase()=="TABLE")) return obj;
	}
	return null;
}
function checkEvaluate(vSourceType,vSourceID,vCurRole,vEvaluateGroup,vAuditFlag,vCurUser,vAction)
{
	var CheckEvaluate=tkMakeServerCall("web.DHCEQ.EM.BUSEvaluate","CheckEvaluateFlag",vSourceType,vSourceID,vCurRole,vEvaluateGroup,vAuditFlag,vCurUser,vAction)
	return CheckEvaluate
}
///add by czf 2018-02-02
///����:���������ֵ�ı䣬������DR����¼�
///��Σ�Values  ���id��
///		showmsg  Y,N ����δ����keyup��յ���ʾ�� ����js���ڴ˲������ݱ���
function KeyUp(Value,showmsg)
{
	
	var value=Value.split("^")
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) {obj.onchange=Standard_KeyUp;}
		else{
			if (showmsg!="N")messageShow("","","",value[i])}
			
	}
}
///add by czf 2018-02-02
///����:������DR����¼�
function Standard_KeyUp()
{
	var eSrc=window.event.srcElement;   //���ش����¼���Ԫ�ض���
	var objDR=document.getElementById(eSrc.name+"DR");
	objDR.value="";
}

/// add by zx sessionֵ����
function initUserInfo()
{
	 //modify by lmm 2018-10-24 �ض���ϵͳ�Ự��������curSS��ǰ׺
	 //ǰ���var������ȫ�ֱ���
	curSSUserID=session['LOGON.USERID']; 
	curSSLocID=session['LOGON.CTLOCID'];      
    curSSHospitalID=session['LOGON.HOSPID'];  //modify by wl 2019-11-11 WL0010 ��������ֵ
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetMapIDBySource",curSSUserID,curSSLocID,curSSHospitalID);
    jsonData=jQuery.parseJSON(jsonData);
    //add by csj 2020-03-16 ��¼��Ա��Ϣ��HIS��һ����ʾͬ��
    if (jsonData.Data["SyncFlag"]=="Y"&&localStorage.getItem("SyncFlag")!="N"){
	    messageShow("confirm","","","�Ƿ�ͬ����ǰ��Ա��Ϣ��","",confirmFun,cancelFun)
	}
    curUserID=jsonData.Data["MapUserID"];
	curUserCode=jsonData.Data["MapUserCode"];
    curUserName=jsonData.Data["MapUserName"];
	curLocID=jsonData.Data["MapLocID"];
	curLocCode=jsonData.Data["MapLocCode"];
    curLocName=jsonData.Data["MapLocName"];
    curSSGroupID=session['LOGON.GROUPID'];
    curSSHospitalCode=jsonData.Data["SSHospitalCode"];
	curSSHospitalName=jsonData.Data["SSHospitalName"];
	curGroupID=session['LOGON.GROUPID'];
	curHospitalID=session['LOGON.HOSPID'];
	curHospitalCode=jsonData.Data["SSHospitalCode"];
	curHospitalName=jsonData.Data["SSHospitalName"];
	session['EQ.USERID']=curUserID
	session['EQ.DEPTID']=curLocID
	session['EQ.GROUPID']=curGroupID
	session['EQ.HOSPID']=curHospitalID
	//add by csj 2020-03-16 ȷ��ͬ���ص�
	function confirmFun(){
		var jsonData=JSON.parse(tkMakeServerCall("web.DHCEQ.Plat.CTUser","SyncUserSingle",curSSUserID));
		if(jsonData.SQLCODE=="0"){
			messageShow("popover","","","ͬ���ɹ���","")
			setTimeout(function(){
				location.reload()
			},1000)
		}else{
			messageShow("popover","","","ͬ��ʧ�ܣ�"+jsonData.SQLCODE,"")
		}
	}
	//ȡ���ص�
	function cancelFun(){
		localStorage.setItem("SyncFlag", "N");
	}
}

///Creator: zx
///CreatDate: 2018-09-07
///Description: input���������ƴ�� field:value,filed:vale
///modify by jyp �޸�ƴ����ƴtextarea
/// modify by zx �������ݸ�Ϊjson��ʽ����ҵ�����⴦���޸�
function getInputList()
{
	var combinData={};
	$("input").each(function(){
		var objID=$(this)[0].id;
		if ((objID!=undefined)&&(objID!=""))
		{
			//if (combinData!="") combinData=combinData+",";
			//combinData=combinData+objID+":"+getElementValue(objID);
			combinData[objID]=getElementValue(objID);
		}
	});
	//begin add by jyp 2018-11-23
	$("textarea").each(function(){
		var objID=$(this)[0].id;
		if ((objID!=undefined)&&(objID!=""))
		{
			//if (combinData!="") combinData=combinData+",";
			//combinData=combinData+objID+":"+getElementValue(objID);
			combinData[objID]=getElementValue(objID);
		}
	});
	//end add by jyp 2018-11-23
	return combinData;
}

/// ��������ʾ��ͳһ����
/// add by zx 2018-10-30
/// ������
/// 	messageShow('alert','error','��ʾ','��ʾ����','','','')
/// 	alertType:��������  alert,popover,confirm,prompt,show �ش�����
/// 	type:������ʽ 'success','info','alert','error'  �ش�����
/// 	title:����  �ش�����
/// 	msg:����  �ش�����
/// 	showType:��ʾ��ʽ  'slide','fade','show' popover��showѡ�����
/// 	confirmFun: ȷ�ϵ�����ú���
/// 	cancelFun: ȡ��������ú���
function messageShow(alertType,type,title,msg,showType,confirmFun,cancelFun)
{
	//Ĭ�ϸ�ֵ
	if(alertType=="") alertType="alert";
	if(type=="") type="info";
	if(title=="") title="��ʾ";
    switch(alertType){
		case 'alert':
			//Modify by zx 2020-03-16 alert��ʾ�ص�����
			$.messager.alert(title, msg, type, function () { 
				if ((confirmFun)&&(confirmFun!=undefined)&&(confirmFun!=""))
				{
					confirmFun();
				} 
			});
			break;
		case 'popover':
			if (showType=="") showType="show";
			$.messager.popover({msg: msg,type:type,timeout: 2000,showType: showType});
			break;
		case 'confirm':	
			$.messager.confirm(title, msg, function (r) {
				if (r) {
					if ((confirmFun)&&(confirmFun!=undefined)&&(confirmFun!=""))
					{
						confirmFun();
					}
				} else {
					if ((cancelFun)&&(cancelFun!=undefined)&&(cancelFun!=""))
					{
						cancelFun();
					}
				}
     		});
			break;
		case 'prompt':		
			$.messager.prompt(title, msg, function (r) {
				if (r) {
					if ((confirmFun)&&(confirmFun!=undefined)&&(confirmFun!=""))
					{
						confirmFun(r);
					}
				} else {
					if ((cancelFun)&&(cancelFun!=undefined)&&(cancelFun!=""))
					{
						cancelFun(r);
					}
				}
			});
		case 'progress':
			//$.messager.progress({title: "��ʾ",msg: '���ڵ�������',text: '������....'});
			break;
		case 'show':
			if (showType=="") showType="slide";
			$.messager.show({title: title,msg: msg,timeout: 3000,showType: showType});
			break;
		default:
			break;
    }
}

/// add by zx 2018-11-21
/// ��Ч������֤,����С����,С�������Ϊ0
function validateNamber(value) {
    var reg = /^[0-9]+.?[0]*$/;
    if (!reg.test(value)) {
        return false;
    }
    return true;
}
/// Add By Mozy003006	2020-04-03
/// ����:
/// 	msg			չ�ֵ���ʾ��Ϣ
/// 	ptimeout	��ʱ(����),������Ϊ�ջ�0��Ĭ��Ϊ3000����
function alertShow(msg, ptimeout)
{
	messageShow("alert", "info", "��ʾ", msg);
	if ((ptimeout==undefined)||(ptimeout=="")||(ptimeout==0)) ptimeout=3000; //�ӳ�3��
	setTimeout(function(){}, ptimeout);
}

///add by ZY 2020-04-01 ZY0215
///���õ�ǰ����input��textareaԪ�ص�tooltip��Ϣ;
///tooltip ��Ϣ������DHC_EQCPromptInfo����,
///Source=5 
///Buss������ҵ����
///Code������Ԫ��id��ͬ���ֶ�����
///Desc��tooltip��ʾ��Ϣ
function initTooltipInfo()
{
	$("input").each(function(){
		var objID=$(this)[0].id;
		if ((objID!=undefined)&&(objID!=""))
		{
			if (!(objID in t)) return
			setTooltip(objID,t[objID])
		}
	});
	$("textarea").each(function(){
		var objID=$(this)[0].id;
		if ((objID!=undefined)&&(objID!=""))
		{
			if (!(objID in t)) return
			setTooltip(objID,t[objID])
		}
	});
}

///add by ZY 2020-04-01 ZY0215
///����һ��Ԫ�ص�tooltip��Ϣ
function setTooltip(id,content)
{
	$HUI.tooltip('#'+id,{
		position: 'bottom',
		content: function(){
				return content; //��ʾֵ�ӷ��������л�ȡ
			},
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#88a8c9',
				borderColor: '#4f75aa',
				boxShadow: '1px 1px 3px #4f75aa'
			});
		 },
		onPosition: function(){
			$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
			$(this).tooltip('arrow').css('bottom', 20);
		}
	});
}

function filepath(oldpath,findstr,replacestr)
{
	if (oldpath=="") return ""
	var newpath=""
	var pathcount=oldpath.length
	for (var i=0;i<pathcount;i++)
	{
		var curchar=oldpath.substr(0,1)
		if (curchar==findstr)
		{
			newpath=newpath+replacestr
		}
		else
		{
			newpath=newpath+curchar
		}
		oldpath=oldpath.substr(1,oldpath.length)
	}
	return newpath
}
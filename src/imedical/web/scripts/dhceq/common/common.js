var HospFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051")		//CZF0138 2021-06-06 多院区

///去掉两端空格
function trim(s)
{ 
	return s.replace(/(^\s*)|(\s*$)/g, ""); 
} 

/// Mozy		929782	2019-06-13	格式化处理日期
/// modified by czf 2022-01-22 增加时间处理
/// format=2返回datetime，format=3返回time，format=其他返回date
function GetCurrentDate(format)			
{
	var yy, mm, dd, s="";
   	var d = new Date();							// 创建对象Date
   	yy = d.getFullYear();						// 获取年份
   	mm = d.getMonth()+1;						// 获取月份
	mm = mm < 10 ? "0" + mm : mm;
	dd = d.getDate();							// 获取日
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
	var hour = d.getHours();//时
	var minu = d.getMinutes();//分
	var sec = d.getSeconds();//秒
	var t = hour + ":" + minu + ":" + sec;
	if(format==1){
		return s;
	}else if(format==2){
		return s+ " "+t;
	}else if(format==3){
		return t;
	}
	return s;
}
/*****************************************************
取指定对象的x坐标
*****************************************************/
function getx(e){
  var l=e.offsetLeft;
  while(e=e.offsetParent){
    l+=e.offsetLeft;
    }
  return(l);
  }
/*****************************************************
取指定对象的y坐标
*****************************************************/
function gety(e){
  var t=e.offsetTop;
  while(e=e.offsetParent){
    t+=e.offsetTop;
    }
  return(t);
  }
  
  ///得到保存文件路径  Add 2007-01-11
function GetFileName()
{
	if (getElementValue("ChromeFlag")=="1")  //Moidefied by zc0068 将元素取值GetElementValue改成getElementValue
	{
		var Str ="(function test(x){"
		Str +="var xlApp = new ActiveXObject('Excel.Application');"   
		Str +="var fName = xlApp.GetSaveAsFilename('','Excel File(*.xls),*.xls');"
		Str +="if (fName==false){return ''}"
		Str += "return fName}());";
		CmdShell.notReturn =0;   //设置无结果调用，不阻塞调用
		var rtn = CmdShell.EvalJs(Str);   //通过中间件运行
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
		var NewDateStr=DateList[2]+"年"+DateList[1]+"月"+DateList[0]+"日";
	}
	if (SysDateFormat=="1")
	{
		var DateList=DateStr.split("/");
		var NewDateStr=DateList[2]+"年"+DateList[0]+"月"+DateList[1]+"日";
	}
	if (SysDateFormat=="3")
	{
		var DateList=DateStr.split("-");
		var NewDateStr=DateList[0]+"年"+DateList[1]+"月"+DateList[2]+"日";
	}
	return NewDateStr;
}


///把18/01/2007转为2007年1月18日
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
/// 按照指定分隔符?截取后半段字符,重新编写?处理含有多个分割符的情况
///把"xyk-西药库"转为"西药库"
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

///判断Str是否在Strs里面 在true 否false
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
///数据打包及解析
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
///数据解析,根据元素名称从数据包里获取数据
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

///创建界面元素
///type:类型 0标签  1文本框  2带放大镜的文本框  3日期  4下拉框
///listInfo:当类型为下拉框时?下拉框信息 value1^text1&value2^text2.......
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
	 //sTime1和sTime2是18/12/2002格式
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
{ //sDate1和sDate2是10:59格式     
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
///创建时间对象
function Time(hour,minute)
{
	this.Hour=hour;
	this.Minute=minute;
}

///add by jdl 2011-12-9 JDL0104
///从IDs中移除指定ID,IDs的分隔符默认为","
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
///从IDs中移除指定ID,IDs的分隔符默认为","
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
///描述:根据列名获取信息串中的列值
///参数:vStrInfo   格式:列1=值1&列2=值2&列3=值3&列4=值4&
///		vFiledName  列名
///		vRecordFlag 列与列之间分割符"&"
///		vFiledFlag  列名与列值之间分隔符"="
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
///数字金额转大写金额
///num  数字型
function ChineseNum(num) 
{
	num=num.toFixed(2)
	if (!/^(0|[1-9]\d*)(\.\d+)?$/.test(num))  return "数据非法";
	var unit = "千百拾亿千百拾万千百拾元角分";
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
		str += '零壹贰叁肆伍陆柒捌玖'.charAt(num.charAt(i)) + unit.charAt(i);
	}
	return str.replace(/零(千|百|拾|角)/g, "零").replace(/(零)+/g, "零").replace(/零(万|亿|元)/g, "$1").replace(/(亿)万|壹(拾)/g, "$1$2").replace(/^元零?|零分/g, "").replace(/元$/g, "元整");
} 

//add by HHM 20150910 HHM0013
//添加业务单据操作成功，是否提示
function ShowMessage(msg)
{
	if ((!msg)||(""==msg))
	{
		msg="操作成功！"
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
///描述:JS页面初始化加载用户自定义类型的JS通用消息及JS业务消息
///入参:vBuss 业务名
///返回值:无
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
///描述:生成字符串对应的拼音码,规则为汉字首字母
///入参:streInput 字符串
///返回值:输入字符串对应的拼音首字母字符串
function getPYCode(strInput)
{
	var rtnStr=tkMakeServerCall("web.DHCEQ.Plat.CTCHanZiEncoding","GetEncoding",strInput,'4','','U');
	var obj = JSON.parse(rtnStr);
	return obj.Data;
}
///Add By DJ 2018-07-30
///描述:获取入参元素对应的表格对象
///入参:ename 页面元素名
///返回值:失败返回null  成功返回表格对象
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
///描述:下拉输入框值改变，下拉框DR清除事件
///入参：Values  清空id串
///		showmsg  Y,N 用作未设置keyup清空的提示的 部分js存在此参数，暂保留
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
///描述:下拉框DR清除事件
function Standard_KeyUp()
{
	var eSrc=window.event.srcElement;   //返回触发事件的元素对象
	var objDR=document.getElementById(eSrc.name+"DR");
	objDR.value="";
}

///add by czf 2022-11-01
///lookup改变时清空DR的值
///Value:SMFromLocDR_CTLocDesc^SMToLocDR_CTLocDesc
function KeyUpNew(Value)
{
	var value=Value.split("^")
	for (var i=0;i<value.length;i++)
	{
		var elementName=value[i];
		var elementID=elementName.split("_")[0];
		$('#'+elementName).bind("input propertychange change",function(event){setElement(elementID,"");})
	}
}

/// add by zx session值处理
function initUserInfo()
{
	 //modify by lmm 2018-10-24 重定义系统会话变量：以curSS做前缀
	 //前面加var不可做全局变量
	curSSUserID=session['LOGON.USERID']; 
	curSSLocID=session['LOGON.CTLOCID']; 
	curSSLocDesc=session['LOGON.CTLOCDESC'];
    curSSHospitalID=session['LOGON.HOSPID'];  //modify by wl 2019-11-11 WL0010 修正错误赋值
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetMapIDBySource",curSSUserID,curSSLocID,curSSHospitalID);
    jsonData=jQuery.parseJSON(jsonData);
    //czf 2021-04-21 同步登录科室 1878102
	if (jsonData.Data["MapLocID"]=="")
	{
		result = tkMakeServerCall("web.DHCEQ.Plat.CTDepartment","SyncDeptSingle",curSSLocID)
		eval("result="+result)
		if(result.SQLCODE!="0"){
			var ErrStr=curSSLocDesc+"同步科室错误,错误信息:"+result.Data
			messageShow("popover","","",ErrStr,"")
		}
	}
	
    //add by csj 2020-03-16 登录人员信息与HIS不一致提示同步
    if (jsonData.Data["SyncFlag"]=="Y"&&localStorage.getItem("SyncFlag")!="N"){
	    confirmFun()
	    //messageShow("confirm","","","是否同步当前人员信息？","",confirmFun,cancelFun)  // czf 20210421 不提示直接同步
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
	//add by csj 2020-03-16 确认同步回调
	function confirmFun(){
		var jsonData=JSON.parse(tkMakeServerCall("web.DHCEQ.Plat.CTUser","SyncUserSingle",curSSUserID));
		if(jsonData.SQLCODE=="0"){
			messageShow("popover","","","同步成功！","")
			setTimeout(function(){
				location.reload()
			},1000)
		}else{
			messageShow("popover","","","同步失败！"+jsonData.SQLCODE,"")
		}
	}
	//取消回调
	function cancelFun(){
		localStorage.setItem("SyncFlag", "N");
	}
}

///Creator: zx
///CreatDate: 2018-09-07
///Description: input输入框数据拼串 field:value,filed:vale
///modify by jyp 修改拼串加拼textarea
/// modify by zx 返回数据改为json格式便于业务特殊处理修改
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

/// 描述：提示框统一调用
/// add by zx 2018-10-30
/// 参数：
/// 	messageShow('alert','error','提示','提示内容','','','')
/// 	alertType:弹窗类型  alert,popover,confirm,prompt,show 必传参数
/// 	type:窗口样式 'success','info','alert','error'  必传参数
/// 	title:标题  必传参数
/// 	msg:内容  必传参数
/// 	showType:显示样式  'slide','fade','show' popover和show选择参数
/// 	confirmFun: 确认点击调用函数
/// 	cancelFun: 取消点击调用函数
/// Modify by zx 2021-04-28 增加按钮文本参数 BUG ZX0131
///     confirmButtonText 'Ok'按钮文本描述
///     cancelButtonText 'cancel'按钮文本描述
function messageShow(alertType,type,title,msg,showType,confirmFun,cancelFun,confirmButtonText,cancelButtonText)
{
	//Modify by zx 2021-04-28 增加按钮文本处理
	//按钮默认宽度只支持两个文字,修改宽度无效
	confirmButtonText=(confirmButtonText==""||confirmButtonText==undefined||confirmButtonText==null)?"确认":confirmButtonText;
	cancelButtonText=(cancelButtonText==""||cancelButtonText==undefined||cancelButtonText==null)?"取消":cancelButtonText;
	$.messager.defaults = { ok: confirmButtonText, cancel: cancelButtonText};
	//默认赋值
	if(alertType=="") alertType="alert";
	if(type=="") type="info";
	if(title=="") title="提示";
    switch(alertType){
		case 'alert':
			//Modify by zx 2020-03-16 alert提示回调处理
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
			//$.messager.progress({title: "提示",msg: '正在导入数据',text: '导入中....'});
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
/// 有效整数验证,可有小数点,小数点后需为0
function validateNamber(value) {
    var reg = /^[0-9]+.?[0]*$/;
    if (!reg.test(value)) {
        return false;
    }
    return true;
}
/// Add By Mozy003006	2020-04-03
/// 参数:
/// 	msg			展现的提示信息
/// 	ptimeout	延时(毫秒),不传、为空或0则默认为3000毫秒
function alertShow(msg, ptimeout)
{
	messageShow("alert", "info", "提示", msg);
	if ((ptimeout==undefined)||(ptimeout=="")||(ptimeout==0)) ptimeout=3000; //延迟3秒
	setTimeout(function(){}, ptimeout);
}

///add by ZY 2020-04-01 ZY0215
///设置当前界面input和textarea元素的tooltip信息;
///tooltip 信息定义在DHC_EQCPromptInfo表中,
///Source=5 
///Buss：根据业务定义
///Code：界面元素id，同表字段名称
///Desc：tooltip显示信息
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
///设置一个元素的tooltip信息
function setTooltip(id,content)
{
	$HUI.tooltip('#'+id,{
		position: 'bottom',
		content: function(){
				return content; //显示值从返回数据中获取
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

///CZF0138 2021-05-08
///重写基础平台数据关联医院
function genHospWinNew(objectName,objectId,callback,opt){
	if ($("#_HospListWin").length==0){
		$("<div id=\"_HospListWin\" />").prependTo("body");
	}
	var singleSelect = false;
	if (opt){
		singleSelect = opt.singleSelect||false;
	}
	var gridObj = "";
	var obj = $HUI.dialog('#_HospListWin',{
		width:550,
		modal:true,
		height:350,
		title:'医院权限分配',
		content:'<table id="_HospListGrid"></table>',
		buttons:[{
			text:'确定',
			handler:function(){
				var HospIDs = "";
				var rows = gridObj.getData().rows;
				var checkRow = gridObj.getChecked();
				if (rows.length>0){
					for(var i=0;i<rows.length;i++){
						if ($.hisui.indexOfArray(checkRow,"HOSPRowId",rows[i]["HOSPRowId"])==-1){
							HospIDs +="^"+rows[i]["HOSPRowId"]+"$N"; 
						}else{
							HospIDs +="^"+rows[i]["HOSPRowId"]+"$Y";
						}
					}
				}
				//保存医院关联
				$cm({
					ClassName:"web.DHCEQ.Util.BDPCommonUtil",
					MethodName:"UpdateHOSP",
					tableName:objectName,
					dataid:objectId,
					HospIDs:HospIDs,
					dataType:'text'
				},function(rtn){
					if(rtn==1){
						if ("function" == typeof callback) callback(checkRow);
						$HUI.dialog("#_HospListWin").close();
					}else{
						if (rtn.split("^").length>0){
							$.messager.popover({msg:rtn.split("^")[1],type:'alert',timeout: 2000});
						}else{
							$.messager.popover({msg:rtn,type:'alert',timeout: 2000});
						}
					}
				});
			}
		},{
			text:'取消',
			handler:function(){
				$HUI.dialog("#_HospListWin").close();
			}
		}],
		onOpen:function(){
			gridObj = $HUI.datagrid("#_HospListGrid",{
				mode: 'remote',
				fit:true,
				border:false,
				pagination:false,
				showPageList:false,
				showRefresh:false,
				singleSelect:singleSelect,
				queryParams:{ClassName:_BDPHOSPCLS,QueryName: 'GetHospDataForCloud',tablename:objectName,dataid:objectId},
				url: $URL,
				columns: [[
					{field:"LinkFlag",title:"授权情况",align:"center",width:100,checkbox:true},
					{field:"HOSPRowId",title:"HOSPRowId",align:"left",hidden:true,width:100},
					{field:"HOSPDesc",title:"医院名称",align:"left",width:300},
					{field:"MappingID",title:"ObjectId",align:"left",hidden:true,width:100}
				]],
				onLoadSuccess:function(row){               
		                var rowData = row.rows;
		                $.each(rowData,function(idx,val){
		                      if(val.LinkFlag=="Y"){
		                        $("#_HospListGrid").datagrid("selectRow", idx);
		                      }
		                });              
		            }
				})
		}
	});
	return gridObj;
}

///CZF0138 2021-05-08
//是否开启平台医院授权
function initBDPHospComponent(TableName)
{
	if (HospFlag==2)
	{
		if ((TableName=="")||(TableName==null)||(TableName==undefined)) return;
		hospComp = GenHospComp(TableName);		//初始化平台医院 CZF0138 begin
		HospBT=GenHospWinButton(TableName);	//初始化数据关联医院按钮
		hospComp.options().onSelect = function(){		//医院选择事件
			onBDPHospSelectHandler();
		}
		if (jQuery("#_HospListLabel").length>0)
		{
			jQuery("#_HospListLabel").hide();
		}
		var TableType=tkMakeServerCall("web.DHCEQ.Util.BDPCommonUtil","GetTableType",TableName)
		if (TableType!="C")
		{
			jQuery("#_HospBtn").hide();
		}
		else
		{
			//管控类型绑定数据关联医院按钮事件
			if (jQuery("#_HospBtn").length>0)		//数据关联医院点击事件定义
			{
				jQuery("#_HospBtn").linkbutton({iconCls: 'icon-w-key'});
				jQuery("#_HospBtn").on("click", HospitalHandle);
				jQuery("#_HospBtn").linkbutton({text:'数据关联医院'});
			}		
		}
	}
	else
	{
		if ($("#_HospListLabel").length!=0){
			$("#_HospListLabel").hide();
		}
		if (jQuery("#_HospBtn").length>0)
		{
			jQuery("#_HospBtn").hide();
		}
		if (jQuery("#c_HospList").length>0)
		{
			$('#c_HospList').hide();
		}
		if (jQuery("#_HospList").length>0)
		{
			$('#_HospList').hide();
			$('#_HospList').next(".combo").hide();
		}
		if (jQuery("#_HospListLabel").length>0)
		{
			jQuery("#_HospListLabel").hide();
		}
	}
}

///CZF0138 2021-05-08
//获取平台医院ID
function GetBDPHospValue(Element)
{
	var BDPHospDR=""
	if (HospFlag==2)
	{
		BDPHospDR=$("#"+Element).combogrid('getValue');
	}
	else
	{
		BDPHospDR=getElementValue(Element);
	}
	return BDPHospDR
}

/// Add by czf
/// 获取月份天数
/// YearMonth:yyyy-mm格式
function GetMonthEndDate(YearMonth)
{
	var EndDay=""
	if(YearMonth)
	{
		var Year=YearMonth.split("-")[0];
		var Month=YearMonth.split("-")[1];
		if ((Month=="01")||(Month=="03")||(Month=="05")||(Month=="07")||(Month=="08")||(Month=="10")||(Month=="12"))
		{
			EndDay="31"
		}
		else if ((Month=="04")||(Month=="06")||(Month=="09")||(Month=="11"))
		{
			EndDay="30"
		}
		else (Month=="02")
		{
			if ((Year%400==0)||((Year%4==0) && (Year%100!=0)))	//闰年
			{
				EndDay="29"
			}
			else
			{
				EndDay="28"
			}
		}
	}
	return EndDay
}
///add by mwz 20211115 mwz0053 
///增加Chrome浏览器多页签导入公共方法
///入参：excelName：excel名称 ;  async 0:同步  1 异步 ; sheetNames：页签名称：""，isText 是否文本格式
function EQReadExcel(excelName, async, sheetNames,isText) 
{
	//if (getElementValue("ChromeFlag")==1)
	//{
	//	if (!websys_isIE) return ChromeReadExcel(excelName, async, sheetNames,isText) ;
	//}
	//return IEReadExcel(excelName, async, sheetNames,isText) ;
	return ChromeReadExcel(excelName, async, sheetNames,isText) ;
}

function ChromeReadExcel(excelName, async, sheetNames,isText)
{ 
    var async = 0;
	var isText=false;
    var strArr = [];
    strArr.push('Function vbs_Test');
    strArr.push('Set xlApp = CreateObject("Excel.Application")');
    if (excelName == "") { ;
        strArr.push('fName=xlApp.GetSaveAsFilename ("","Excel xlsx (*.xlsx), *.xlsx,Excel xls (*.xls), *.xls",,"' + websys_unicode_trans.selectImportFile + '")');
        strArr.push("If fName=False Then");
        strArr.push(" xlApp.Quit");
        strArr.push(" Set xlApp=Nothing");
        strArr.push(" vbs_Test=0");
        strArr.push(" Exit Function");
        strArr.push("End If");
        strArr.push('Set xlBook = xlApp.Workbooks.Open(fName)');
    } else { ;
        strArr.push('Set xlBook = xlApp.Workbooks.Open("' + excelName + '")');
    };
    strArr.push(' sheetNames = "'+sheetNames+'"');
    strArr.push(' Arrr = Split(sheetNames,",")');
    strArr.push(' Arrlen = UBound(Arrr)');
    strArr.push('rtnstr = "["');
    strArr.push('for i=0 To Arrlen');
    strArr.push('Set xlsheet =xlBook.Worksheets(Arrr(i))');
    strArr.push('rtn = "["');
    strArr.push('rc=xlSheet.UsedRange.Rows.Count');
    strArr.push('cc=xlSheet.UsedRange.Columns.Count');
    if (false === isText) {
        strArr.push('arr = xlSheet.Range(xlSheet.Cells(1,1),xlSheet.Cells(rc,cc)).Value2');
    }
    strArr.push('For ri = 1 To rc');
    strArr.push(' rowstr = "["');
    strArr.push(' For ci = 1 To cc');
    if (isText) {
        strArr.push('  cellVal = xlSheet.Cells(ri,ci).Text');
    } else {
        strArr.push('  cellVal = arr(ri,ci)');
    }
    strArr.push('  colstr="""" & Replace(cellVal,"""","\\""") & """"');
    strArr.push('    If rowstr <> "[" Then');
    strArr.push('        rowstr = rowstr & ","');
    strArr.push('     End If');
    strArr.push('       rowstr = rowstr & colstr');
    strArr.push(' Next');
    strArr.push(' rowstr = rowstr & "]"');
    strArr.push(' If rtn = "[" Then');
    strArr.push('    rtn = rtn & rowstr');
    strArr.push(' Else');   
    strArr.push('    rtn = rtn & "," & rowstr');
    strArr.push(' End If');
    strArr.push('Next');
    strArr.push('rtn = rtn & "]"');
    strArr.push(' If rtnstr = "[" Then');
    strArr.push('    rtnstr = rtnstr & rtn');
    strArr.push(' Else');
    strArr.push('    rtnstr = rtnstr & "," & rtn');
    strArr.push(' End If');
    strArr.push('Next');   
    strArr.push('rtnstr = rtnstr & "]"');
    strArr.push('rtn = rtnstr');
    strArr.push('xlBook.Close(False)');
    strArr.push('xlApp.Quit');
    strArr.push('Set xlSheet= Nothing');
    strArr.push('Set xlBook= Nothing');
    strArr.push('Set xlApp=Nothing');
    strArr.push('vbs_Test=rtn');
    strArr.push('End Function\n');
    var rtn = "";
    var exec = strArr.join("\n");
    //alert(exec)
    var o;
    if (websys_isIE) {
        var IECmdShell = new ActiveXObject("MSScriptControl.ScriptControl");
        IECmdShell.Language = 'VBScript';
        IECmdShell.Timeout = 10 * 60 * 1000;
        IECmdShell.AddCode(exec);
        try {
	      
            rtn = IECmdShell.Run("vbs_Test");
            eval("var o=(" + rtn + ")");
        } catch (e) {
            o = [];
            alert(e.message);
        }
    } else {
        CmdShell.notReturn = async;
        rtn = CmdShell.EvalJs(exec, "VBScript");
        if (rtn.status == 200) {
            eval("var o=(" + rtn.rtn + ")");
        } else {
            o = [];
            alert(rtn.msg);
        }
    };
    return o || [];
}
//add by mwz 20211115 mwz0053 
//增加IE浏览器多页签导入公共方法
//预留方法暂不使用
function IEReadExcel(excelName, async, sheetNames,isText)
{
	var FileName=GetFileName();
	if (FileName=="") {return 0;}
	var xlApp,xlsheet,xlBook
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(FileName);
	xlsheet =xlBook.Worksheets(sheetNames);
	xlsheet = xlBook.ActiveSheet;

}

///Add By ZY0304 20220616
///描述:保存前校验填写的字符串是否合规,先把全角符号转换成半角符号,再判断括号等是否匹配
///入参:Value  传一个元素串 例如"BuyLoc^Loc"
///返回值:true/false   true :合规  false  ：不合规
function charLegalCheck(Value)
{
	var value=Value.split("^");
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj)
		{
			var curValue=obj.value;
			curValue=halfChar2fullChar(curValue);
			var isMatch=bracketMatch(curValue)
			if (isMatch==true)
			{
				obj.value=curValue
			}
			else
			{
                var CValue=getElementValue("c"+value[i]);
				messageShow("","","",CValue+"符号不匹配");
				return false;
			}
		}
	}
	return true
}
///Add By ZY0304 20220616
///描述:全角转半角
///入参:str  字符串
///返回值:result
function fullChar2halfChar(str)
{
	var result = '';
	for (i=0 ; i<str.length; i++)
	{
		code = str.charCodeAt(i);//获取当前字符的unicode编码
		if (code >= 65281 && code <= 65373)//在这个unicode编码范围中的是所有的英文字母已经各种字符
		{
			result += String.fromCharCode(str.charCodeAt(i) - 65248);//把全角字符的unicode编码转换为对应半角字符的unicode码
		}else if (code == 12288)//空格
		{
			result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
		}else
		{
			result += str.charAt(i);
		}
	}
	return result;
}

///Add By ZY0304 20220616
///描述:全角转半角
///入参:str  字符串
///返回值:result
function halfChar2fullChar(str)
{
    var result = '';
    for (i=0 ; i<str.length; i++)
    {
        code = str.charCodeAt(i);//获取当前字符的unicode编码
        ///modified by ZY20221115 buy:3081922
        if ((code >= 33 && code <= 47)||(code >= 58 && code <= 63))//在这个unicode编码范围中的是所有的英文字母已经各种字符
        {
            result += String.fromCharCode(str.charCodeAt(i) + 65248);//把半角字符的unicode编码转换为对应全角字符的unicode码
        }else if (code == 32)//空格
        {
            //result += String.fromCharCode(str.charCodeAt(i) - 12288 + 32);
            result += String.fromCharCode(str.charCodeAt(i) + 12288);
        }else
        {
            result += str.charAt(i);
        }
    }
    return result;
}
///Add By ZY0304 20220616
///描述:判断双符号(（[{'是否完整
///入参:str  字符串
///返回值:result
///返回值:true/false   true :合规  false  ：不合规
function bracketMatch(str) 
{
    var length = str.length;
    if (length === 0) return true
    var stack = []; // 借助数组模拟栈
    var leftBracket = "(（[{'"; // 定义左括号
    var rightBracket = ")）]}'"; // 定义右括号
    for (var index = 0; index < length; index++) 
    {
        var s = str[index];
        //ie不兼容includes函数
        //if (leftBracket.includes(s)) 
        if (leftBracket.indexOf(s)!= -1) 
        {
            // 如果出现左括号，压栈
            stack.push(s)
        //} else if (rightBracket.includes(s)) 
        } else if (rightBracket.indexOf(s)!= -1) 
        {
            // 如果出现右括号，需要判断栈顶元素与之是否匹配，是否需要出栈
            var top = stack[stack.length - 1]; // 栈顶元素
            // 左右括号是否匹配
            if (isEQMatch(top, s))
	        {
	    		stack.pop(); // 出栈，注意这儿没有压栈操作
        	}
      	}
    }
    return stack.length === 0; // 长度为 0 代表括号匹配
}
///modified by ZY20221115 bug:  避免函数重名
///Add By ZY0304 20220616
///描述:判断左右括号是否匹配
///入参:str  字符串
///返回值:true/false   true :匹配  false  ：不匹配
function isEQMatch(left, right) 
{
    if (left === '{' && right === '}') {
      return true;
    } else if (left === '（' && right === '）') {
      return true;
    } else if (left === '[' && right === ']') {
      return true;
    } else if (left === '(' && right === ')') {
      return true;
    } else if (left === "'" && right === "'") {
      return true;
    } else {
      return false
    }
}

/**
 * lodop打印公共函数
 * @author add by ZY 2023-02-23  bug: 3295367
 */
/**
*@author : wanghc 

*@param : {DLLObject} LODOP 
*		   expample: var LODOP = getLodop();

*@param : {String}   inpara 
*          expample: name_$c(2)_zhangsha^patno_$c(2)_000009
*
*@param : {String}   inlist 
*         expample: DrugName^Price^DrugUnit^Qty^PaySum_$c(1)_img_$c(2)_DrugName2^Price2^DrugUnit2^Qty2^PaySum2
*
*@param : {Object} jsonArr
*         expample: [
					{type:"invoice",PrtDevice:"pdfprinter"},
					{type:"line",sx:1,sy:1,ex:100,ey:100},
					{type:"text",name:"patno",value:"1024988919",x:10,y:10,isqrcode:true,lineHeigth:5},
					{type:"text",name:"invno",value:"1024988919",x:140,y:12,width:24,height:11,barcodetype:"128C"}
					]
*        <text>=>name,value,x,y is require
*@param : {String}  reportNote     print task name,  example: PrintText
*
*@param : {Object}  otherCfg  
          example: {LetterSpacing:-2,printListByText:false,tdnowrap:true, preview:0,PrtDevice:'强制打印机名称',onPrintEnd:myPrintEnd,onCreatePDFBase64:mypdfBase64,pdfPath:'C:\\imedical\\xmlprint\\'}
		  listHtmlTableWordWrapFlag:true; 打印 list 使用HTML打印的时候，文字自动根据宽度换行。宽度由两列的X坐标差决定。
		  listHtmlTableBorder:1; 打印 list 使用HTML打印的时候，table的border大小。是否有边框。
		  tdnowrap:true ---> not break line 
		  pdfDownload:false 
		  onCreatePDFBase64:undefined
		  PFlag:"打印模板的ID" // 1、可以不调用加载模板的方法了。2、一次打印多个模板的时候，避免模板覆盖，必须送这个，避免风险。
		  rightMarginNum:打印区域相对于纸张的右边距,已毫米为单位，请送数字，不带单位的。产品组反馈，定义右边距，可以自动调整列宽，均匀分布列。
		  DHC_PrintByLodop("","","",[],"YKYZLYYPrescriptPrint",{onCreatePDFBase64:function(b){console.log(b);}});
*
*/
function printByLodop(xmlName,inpara,inlist,jsonArr,reportNote,otherCfg)
{
	if ((xmlName=="")||(xmlName=="undifend"))
	{
		alertShow("打印模板不能为空!");
		return;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt",xmlName);
	var LODOP = getLodop();
	DHC_PrintByLodop(LODOP,inpara,inlist,jsonArr,reportNote,otherCfg)
}

///add by ZY20230307 bug:3297547
///desc:用于检测输入的数据中是否包含特殊符号
function checkLegalChar(elments)
{
    var re =/[`~!@#$%^&*_+<>{}\/'[\]]/im;
    var elments=elments.split("^")
    var i=0;
    for (i=0;i<elments.length;i++)
    {
        var valueStr=getElementValue(elments[i]);
        if (re.test(valueStr))
        {
            var cName=$("label[for='"+elments[i]+"']").html()
            alert('"'+cName+'"存在特殊字符');
            return false;
        }
    }
    return true;
}

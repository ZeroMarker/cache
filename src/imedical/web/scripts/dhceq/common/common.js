///去掉两端空格
function trim(s)
{ 
	return s.replace(/(^\s*)|(\s*$)/g, ""); 
} 

///Mozy		929782	2019-06-13	格式化处理日期
function GetCurrentDate()			
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
   return(s);                                // 返回日期
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

/// add by zx session值处理
function initUserInfo()
{
	 //modify by lmm 2018-10-24 重定义系统会话变量：以curSS做前缀
	 //前面加var不可做全局变量
	curSSUserID=session['LOGON.USERID']; 
	curSSLocID=session['LOGON.CTLOCID'];      
    curSSHospitalID=session['LOGON.HOSPID'];  //modify by wl 2019-11-11 WL0010 修正错误赋值
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetMapIDBySource",curSSUserID,curSSLocID,curSSHospitalID);
    jsonData=jQuery.parseJSON(jsonData);
    //add by csj 2020-03-16 登录人员信息与HIS不一致提示同步
    if (jsonData.Data["SyncFlag"]=="Y"&&localStorage.getItem("SyncFlag")!="N"){
	    messageShow("confirm","","","是否同步当前人员信息？","",confirmFun,cancelFun)
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
function messageShow(alertType,type,title,msg,showType,confirmFun,cancelFun)
{
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
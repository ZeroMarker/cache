/// 名称: DHCHAI.Utils.CommonSrv
/// 描述: 公共服务类
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.Utils.CommonSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-01-04
/// Description:  获取一组数据的标准差
/// Input:        %List
/// Return：      标准差
/// w ##Class(DHCHAI.Utils.CommonSrv).GetStandDev()
ClassMethod GetStandDev(aArray As %Library.ArrayOfDataTypes) As %Float
{
	New (aArray)
	Set return=""
	Quit:(aArray="") return
	// 计算平均值
	Set AvgValue=..GetAverage(aArray)
	// 计算方差
	Set Variance=0,SqrtSum=0
	Set Length=aArray.Count()
	For xKey=1:1:Length {
		Set Value=aArray.GetAt(xKey)
		Continue:Value=""
		Set SqrtSum=SqrtSum+$ZPOWER((Value-AvgValue),2)
	}
	Set:SqrtSum'=0 Variance=$FN(SqrtSum/Length,"",2)
	Set return=$FN($ZSQR(Variance),"",2)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-01-13
/// Description:  计算平均值
/// Input：       %List
/// Return：      平均值
/// w ##class(DHCHAI.Utils.CommonSrv).GetAverage()
ClassMethod GetAverage(aArray As %Library.ArrayOfDataTypes) As %Float
{
	New (aArray)
	Set return=""
	Quit:(aArray="") return
	// 计算平均值
	Set AvgValue=0,Sum=0
	Set Length = aArray.Count()
	For xKey=1:1:Length {
		Set Value=aArray.GetAt(xKey)
		Continue:Value=""
		Set Sum=Sum+Value
	}
	Set:Sum'=0 AvgValue=Sum/Length
	Set:$e(AvgValue,1)="." AvgValue = "0"_AvgValue
	Quit AvgValue
}

/// Creator：     mayanpeng
/// CreatDate：   2017-12-14
/// Description:  去掉重复数据
/// Input：       字符串列表 分隔符
/// Return：      返回相同分隔符分割的字符串
/// w ##class(DHCHAI.Utils.CommonSrv).RemoveRepet("1,2,3,4,2,3,5,1",",")
ClassMethod RemoveRepet(InStr As %String, aSeparete As %String = "") As %String
{
	New (InStr,aSeparete)
	Set return=""
	Quit:(InStr="")||(aSeparete="") return
	
	For i=1:1:$l(InStr,aSeparete){
		Set SepStr = $p(InStr,aSeparete,i)
		Continue:SepStr=""
		Continue:$ListFind(return,SepStr)>0
		Set return = return_$lb(SepStr)
	}
	Quit:return="" return
	Set returnTemp=""
	For j=1:1:$listLength(return){
		Set returnTemp = returnTemp_aSeparete_$List(return,j)
	}
	Set return=$e(returnTemp,2,$l(returnTemp))
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-03
/// Description:  取当月的起止日期
/// Input：       aDate：任意一天(YYYY-MM 或 YYYY-MM-DD 或 YYYY 或 MM)
/// 			  aIsOriginal：是否返回原生格式 0:YYYY-MM-DD格式(默认) 1:数字格式
/// Return：      该月起止日期2018-02-01^2018-02-28
/// w ##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay("2018-02")
ClassMethod GetMonthStaLastDay(aDate As %String = "", aIsOriginal As %String = "0") As %String
{
	New (aDate,aIsOriginal)
	Set return="^"
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(aDate)
	Set:(aDate="") aDate=$e($zd(+$h,3),1,7)
	Set $ZT="GetMonthLastDayErr"
	
	Set aYear=$p(aDate,"-",1)
	Set aMonth=$p(aDate,"-",2)
	If (aYear="")||($l(aYear)<4){
		Set aMonth=aYear
		Set aYear=$e($zd($h,3),1,4)
	}
	Set:aMonth="" aMonth=$e($zd($h,3),6,7)
	
	Set StartDay=aYear_"-"_aMonth_"-"_"01"
	Set StartDayOrig=+$zdh(StartDay,3)
	
	Set nextMonth=$zd(StartDayOrig+32,3)
	Set nextMonth=$e(nextMonth,1,7)_"-"_"01"
	
	Set lastDay=+$zdh(nextMonth,3)-1
	If (aIsOriginal="0") {
		Set lastDay=$zd(lastDay,3)
	} Else {
		Set StartDay=StartDayOrig
	}
	Quit StartDay_"^"_lastDay
GetMonthLastDayErr
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-03
/// Description:  取下月的年-月
/// Input：       aDate : YYYY 或 YYYY-MM-DD 或 YYYY-MM
/// 			  aIsOriginal：是否返回原生格式 0:YYYY-MM-DD格式(默认) 1:数字格式
/// Return：      该月起止日期
/// w ##class(DHCHAI.Utils.CommonSrv).GetNextMonth("2018-02")
ClassMethod GetNextMonth(aDate As %String = "", aIsOriginal As %String = "") As %String
{
	New (aDate,aIsOriginal)
	Set return=""
	Set:(aDate="") aDate=$zd(+$h,3)
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(aDate)
	Set $ZT="GetNextMonthErr"
	Set Year=$p(aDate,"-",1)
	Set:$Length(Year)'=4 Year=$e($zd($h,3),1,4)
	Set Month=""
	If $p(aDate,"-",2)'=""{
		Set Month=$p(aDate,"-",2)
	} Else {
		Set Month=$e($zd($h,3),6,7)
	}
	Set Day=""
	Set:$p(aDate,"-",3)'="" Day=$p(aDate,"-",3)
	
	Set StartDay=Year_"-"_Month_"-"_"01"
	Set StartDayOrig=+$zdh(StartDay,3)
	Set nextMonth=$zd(StartDayOrig+32,3)
	Set nextMonth=$e(nextMonth,1,7)
	Set:Day'="" nextMonth=nextMonth_"-"_Day
	If aIsOriginal="1"{
		Set:Day="" nextMonth=nextMonth_"-01"
		Set nextMonth=$zdh(nextMonth,3)
	}
	Quit nextMonth
GetNextMonthErr
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-09-17
/// Description:  月份比较(是否小于)
/// Input：       aDate : YYYY 或 YYYY-MM-DD 或 YYYY-MM
/// 			  aDate : YYYY 或 YYYY-MM-DD 或 YYYY-MM
/// Return：      0大于,1小于,2等于
/// w ##class(DHCHAI.Utils.CommonSrv).MonthLessThan("2018-02","2018-03")
ClassMethod MonthLessThan(aFirstDate As %String, aSecondDate As %String) As %String
{
	New (aFirstDate,aSecondDate)
	Set return=""
	Set $ZT="MonthLessThanErr"
	Set:(aFirstDate["-")&&($p(aFirstDate,"-",3)="") aFirstDate=aFirstDate_"-01"
	Set:(aSecondDate["-")&&($p(aSecondDate,"-",3)="") aSecondDate=aSecondDate_"-01"
	Set aFirstDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aFirstDate)
	Set aSecondDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aSecondDate)
	Quit:(aFirstDate="")||(aSecondDate="") return
	
	If aFirstDate<aSecondDate{
		Set return=1
	} ElseIf (aFirstDate=aSecondDate) {
		Set return=2
	} Else {
		Set return=0
	}
	Quit return
MonthLessThanErr
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-10-18
/// Description:  计算某个时间几小时前后的时间
/// Input：       aDate ：日期  YYYY-MM-DD 或者 数字格式
///               aTime : 时间  HH:MM:SS   或者 数字格式
///               aHours：前、后几小时
///               aFlag : 1: 返回YYYY-MM-DD HH:MM:SS格式 0或空：数字格式(23242,34234)
/// Return:		  换算后的时间 YYYY-MM-DD HH:MM:SS 或者数字格式
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours("2017-10-19","01:00:00","0.5","1")
///               w ##class(DHCHAI.Utils.CommonSrv).GetTimeByHours("2017-10-19","03:34:30","-2")
ClassMethod GetTimeByHours(aDate As %String, aTime As %String, aHours As %String, aFlag As %String = "") As %String
{
	New (aDate,aTime,aHours,aFlag)
	Set return=""
	Quit:(aDate="")||(aTime="")||(aHours="") return

	Set:aDate["-" aDate = $zdh(aDate,3)
	Set:aTime[":" aTime = $zth(aTime,1)
	Set Second       = aDate*24*3600+aTime
	Set ChangeSecond = aHours*3600
	Set Second       = Second+ChangeSecond
	Set Hours = Second\3600
	Set Date  = Hours\24
	Set Time  = Second-(Date*24*3600)
	If (aFlag=1) {
		Set Date  = $zd(Date,3)
		Set Time  = $zt(Time,1)
		Set DateTime = Date_" "_Time
	}Else {
		Set DateTime = Date_","_Time
	}
	Set return=DateTime
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-09-11
/// Description:  去字符串中的特殊字符
/// Input：       aInputStr
///               aFlag   去掉特殊字符配置
/// Return：      去除特殊字符的字符串
/// w ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr("dsfe345fdghsdh")
ClassMethod ChangeKeyStr(aInputStr As %String, aExceptChar As %String = "") As %String
{
	New (aInputStr,aExceptChar)
	Quit:aInputStr="" aInputStr
	set:aExceptChar'["^" aInputStr = $tr(aInputStr,"^","ˋ")         // ^
	set:aExceptChar'[$c(0) aInputStr = $tr(aInputStr,$c(0),"")      // 不可见字符
	set:aExceptChar'[$c(1) aInputStr = $tr(aInputStr,$c(1),"")      // 不可见字符
	set:aExceptChar'[$c(2) aInputStr = $tr(aInputStr,$c(2),"")      // 不可见字符
	set:aExceptChar'[$c(3) aInputStr = $tr(aInputStr,$c(3),"")      // 不可见字符
	set:aExceptChar'[$c(4) aInputStr = $tr(aInputStr,$c(4),"")      // 不可见字符
	set:aExceptChar'[$c(5) aInputStr = $tr(aInputStr,$c(5),"")      // 不可见字符
	set:aExceptChar'[$c(6) aInputStr = $tr(aInputStr,$c(6),"")      // 不可见字符
	set:aExceptChar'[$c(7) aInputStr = $tr(aInputStr,$c(7),"")      // 不可见字符
	set:aExceptChar'[$c(8) aInputStr = $tr(aInputStr,$c(8),"")      // 不可见字符
	set:aExceptChar'[$c(9) aInputStr = $tr(aInputStr,$c(9),"")      // 水平制表符
	set:aExceptChar'[$c(10) aInputStr = $tr(aInputStr,$c(10),"")   	// 换行
	set:aExceptChar'[$c(13) aInputStr = $tr(aInputStr,$c(13),"")    // 回车
	set:aExceptChar'["  " aInputStr = $tr(aInputStr,"  ","")        // 不可见字符
	set:aExceptChar'["'" aInputStr = $tr(aInputStr,"'","")        // '字符
	set:aExceptChar'["""" aInputStr = $tr(aInputStr,"""","")        // "字符
	
	Quit aInputStr
}

/// Creator：     mayanpeng
/// CreatDate：   2020-10-14
/// Description:  Query调用封装，避免变量冲突
/// Input:		  aClassName:类名,aQueryName:Query名,aInputStr:调用Query的参数(多个)
/// Return：      %ArrayOfDataTypes
/// 			  第一行取值示例: return.GetAt(1).GetAt("ColumnName")
/// s a=##class(DHCHAI.Utils.CommonSrv).GetQryDataByMethod("DHCHAI.BTS.DictionarySrv","QryDictionary","2")
/// zw a.GetAt(1)
ClassMethod GetQryDataByMethod(aClassName As %String, aQueryName As %String, aInputStr...) As %ArrayOfDataTypes
{
	New (aClassName,aQueryName,aInputStr)
	Set return=##Class(%ArrayOfDataTypes).%New()
	Quit:(aClassName="")||(aQueryName="") return
	
	Set ParamStr = ""
	For ParamIndex=1:1:$g(aInputStr,0){
		Set @("Param"_ParamIndex)=$g(aInputStr(ParamIndex),"")
		Set ParamStr=ParamStr_","_"Param"_ParamIndex
	}
	Set:ParamStr'="" ParamStr=$e(ParamStr,2,$l(ParamStr))
	
	Set rs=##Class(%ResultSet).%New(aClassName_":"_aQueryName)
	XECUTE "Set sc=rs.Execute("_ParamStr_")"
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	Set ColumnCount = rs.GetColumnCount()
  	Set xCount=0
    While (rs.Next()){
	    Set ResInfo=##Class(%ArrayOfDataTypes).%New()
		For xColumnIndex = 1:1:ColumnCount {
			Set ColumnName = rs.GetColumnName(xColumnIndex)
			Set ColumnDate = rs.GetData(xColumnIndex)
			
			Do ResInfo.SetAt(ColumnDate,ColumnName)
		}
	    Set xCount=xCount+1
		Do return.SetAt(ResInfo,xCount)
    }
	Do rs.Close()
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2020-11-11
/// Description:  发起http请求
/// Input:		  url:完整的请求地址,type:请求方法(POST/GET),data:请求数据,contentType:请求类型
/// Return：      Response	//如果返回中文乱码请转码：$ZCVT(return,"I","UTF8")
/// w ##class(DHCHAI.Utils.CommonSrv).SendHttpRequest("http://127.0.0.1:8085/user","POST","{""name"":""中文""}","application/json;charset=utf-8")
ClassMethod SendHttpRequest(url As %String, type As %String, data As %String, contentType As %String = "") As %String
{
	New (url,type,data,contentType)
	Set return=""
	Set:contentType["application/json" return="{}"
	Set:type="" type="POST"
	Set:data="" data="{}"
	Quit:(url="") return
	
	// 解析url
	Set (IP,Port)="",Path=url
	Set:(Path["//") Path=$p(Path,"//","2")
	If (Path[":") {
		Set IP=$p(Path,":",1),Path=$Replace(Path,IP_":",""),Port=$p(Path,"/",1)
		Set Path=$Replace(Path,Port,"")
	} Else {
		Set IP=$p(Path,"/",1),Port=80,Path=$Replace(Path,IP,"")
		Set:(url["https:") Port=443
	}
	Set:(Path="") Path="/"
	Quit:(IP="")||(Port="") return
	
	// 初始化接口
	Set httprequest=##class(%Net.HttpRequest).%New()
	Set:contentType'="" httprequest.ContentType=contentType   //格式
    Set httprequest.Server=IP
    Set httprequest.Port=Port
	// 参数
	If contentType'["application/json" {
		Do ##class(ext.util.JsonObject).ParseJSON(data,"",.ObjData)
		Do:$d(ObjData) ObjData.%CopyToArray(.ArrData)
		If ($d(ArrData)) {
			Set xIndexName=""
			For {
				Set xIndexName=$o(ArrData(xIndexName))
				Quit:xIndexName=""
				
				Do httprequest.InsertFormData(xIndexName,$g(ArrData(xIndexName)))
			}
		}
	} Else {
		Do httprequest.EntityBody.Write(data)
	}
	// 调用接口
	If ($zcvt(type,"U")="POST") {
		Set tSc=httprequest.Post(Path)
	} Else {
		Set tSc=httprequest.Get(Path)
	}
	Set response=httprequest.HttpResponse
	Quit:response="" return
	Set OutStream=##class(%Stream.GlobalCharacter).%New()
	Set streamSize=response.Data.Size
	While 'response.Data.AtEnd {
		Do OutStream.Write(response.Data.Read(streamSize))
		Set return=OutStream.Read(streamSize)
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-09
/// Description:  计算年龄
/// Input：       aBirthday  : 出生日期
///               aDate      : 日期
///               aEpisodeID : 就诊号
/// Return:		  返回String 格式：*岁*月*天
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetPatAge()
ClassMethod GetPatAge(objEpisode As DHCHAI.DP.PAAdm, aAgeDate As %String = "") As %String
{
	New (objEpisode,aAgeDate)
	Set return=""
	Quit:objEpisode="" return
	Quit:'$IsObject(objEpisode) return
	
	Set $ZT="CalAgeErr"
	
	Set Birthday=objEpisode.PABirthday
	Quit:Birthday="" return
	Set:aAgeDate["-" aAgeDate=$zdh(aAgeDate,3)
	Set:aAgeDate["/" aAgeDate=$zdh(aAgeDate,4)
	Set:aAgeDate="" aAgeDate=objEpisode.PADeathDate
	Set:aAgeDate="" aAgeDate=objEpisode.PADischDate
	
	Set IBirth=Birthday
	Set IToday=$s(aAgeDate'="":aAgeDate,1:+$h)
	
	n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
	s IBirth=$g(IBirth),IToday=$g(IToday)
	i IBirth>2980000 s IBirth=""
	i IBirth<0 s IBirth=""
	q:'$G(IBirth) ""
	s XBirth=$ZD(IBirth)
	s XToday=$ZD(IToday)
	s AgeMth=XToday-XBirth
	s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
	s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
	s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
	s AgeYear=CurrYear-BirthYear
	i AgeDay<0 d
	. s AgeMth=AgeMth-1
	. s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	. q:XToday'=2
	. s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0  d
	.s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 d
	..s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	i AgeYear>0 d
	.s AgeDay=0
	Set:AgeYear>=15 return=AgeYear_"岁"
	Set:((AgeYear<15) && (AgeYear'=0)) return=AgeYear_"岁"_AgeMth_"月"
	Set:((AgeYear=0)&&(AgeMth'=0)) return=AgeMth_"月"_AgeDay_"天"
	Set:((AgeYear=0)&&(AgeMth=0)) return=AgeDay_"天"
	Quit return
CalAgeErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2017-05-05
/// Description:  通过名称取对应参数值
/// Input：       aParams ：参数列表 格式："参数1=值1,参数2=值2"
///               aParamName : 参数名称
/// Return:		  返回String
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetParamByName()
ClassMethod GetParamByName(aParams As %String, aParamName As %String) As %String
{
	New (aParams,aParamName)
	Set return=""
	
	For indP=1:1:$l(aParams,",") {
		Set tParam=$p(aParams,",",indP)
		Continue:tParam=""
		Set tParamName=$p(tParam,"=",1)
		Set tParamValue=$p(tParam,"=",2)
		Continue:tParamName'=aParamName
		Set return=tParamValue
		Quit
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-04
/// Description:  计算两个时间的间隔小时数（时差-小时）
/// Input：       aFromDate ：开始日期  YYYY-MM-DD 或者 数字格式
///               aFromTime : 开始时间  HH:MM:SS   或者 数字格式
///               aEndDate  ：结束日期  YYYY-MM-DD 或者 数字格式
///               aEndTime  : 结束时间  HH:MM:SS   或者 数字格式
/// Return:		  时间间隔小时数
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime("2017-08-04","01:00:00","2017-08-04","05:00:00")
ClassMethod GetHourByDateTime(aFromDate As %String, aFromTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aFromDate,aFromTime,aEndDate,aEndTime)
	Set return=0
	Quit:(aFromDate="")||(aFromTime="")||(aEndDate="")||(aEndTime="") return
	Set Hours=0
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	Set:aEndTime[":" aEndTime=$zth(aEndTime,1)
	Quit:(aFromDate>aEndDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aEndDate)&&(aFromTime>aEndTime) return
	
	If (aFromDate=aEndDate) {
		Set HoursNumber = $Number((aEndTime-aFromTime)/3600,1) 
		If (HoursNumber["."){
			Set Hours = $e(HoursNumber,0,1)+1
		}else{
			Set Hours = $e(HoursNumber,0,1)
		}
		
		//Set Hours=$Number((aEndTime-aFromTime)/3600,0)+1     // 向上取整
	} Else {  // aFromDate<aEndDate
		Set DayHours=(aEndDate-aFromDate)*24
		//Set tmpHours=$Number((aEndTime-aFromTime)/3600,0)+1  // 向上取整
		Set tmpHours=$Number((aEndTime-aFromTime)/3600,1)  // 向上取整
		If (tmpHours["."){
			Set Hours = $e(tmpHours,0,1)+1
		}else{
			Set Hours = $e(tmpHours,0,1)
		}
		Set Hours=DayHours+tmpHours
	}
	Set return = Hours
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-07
/// Description:  随机生成一个32位的编码
/// Return：      返回32位字符串
/// w ##Class(DHCHAI.Utils.CommonSrv).GetGUIDCode()
ClassMethod GetGUIDCode() As %String
{
	Set return=""
	Set GUIDCode=$system.Util.CreateGUID()
	Set:GUIDCode'="" GUIDCode=$tr(GUIDCode,"-","") 
	Set return=GUIDCode
	
	Quit return
}

/// 通过数语集取电子病历数据
/// w ##class(DHCHAI.Utils.CommonSrv).GetEPRData(892,"HDSD00.11.056",.ArrGlossary)
ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,ArrGlossary)
	Set return=""
	Quit:(aEpisodeID="")||(aElCode="") return
	
	Set $ZT="GetEPRDataErr"
	
	Set Count=0    // 二版、三版电子病历标志  默认三版电子病历
	If Count>0 {
		//二版电子病历，GetEPRData方法即可通过模板单元调用，也可通过术语集调用
		Set return=##class(EPRservice.BOScatterData).GetEPRData(aEpisodeID,aElCode)
		
		//二版电子病历，GetDataByGlossary方法为术语集调用接口
		//Set return=##Class(EPRservice.BOScatterData).GetDataByGlossary(aEpisodeID,aElCode)
	} Else {
		//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
		Set Category=$e(aElCode,1,9)
		Quit:Category="" return
		If ArrGlossary.GetAt(Category)'=aEpisodeID {
			Set ArrGlossary=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(aEpisodeID,Category)
			Do ArrGlossary.SetAt(aEpisodeID,Category)
		}
		Set return=ArrGlossary.GetAt(aElCode)
		
	}
	Quit return
	
GetEPRDataErr
	Quit ""
}

/// w ##class(DHCHAI.Utils.CommonSrv).ListFromString()
ClassMethod ListFromString(STR As %String, SEPA As %String) As %List
{
	New (STR,SEPA)
	Set return=""
	Quit:STR="" return
	For Ind=1:1:$l(STR,SEPA) {
		Set StrSub=$p(STR,SEPA,Ind)
		Set return=return_$lb(StrSub)
	}
	Quit return
}

/// w ##class(DHCHAI.Utils.CommonSrv).ListToString()
ClassMethod ListToString(STR As %List, SEPA As %String) As %String
{
	New (STR,SEPA)
	Set return=""
	For Ind=1:1:$listlength(STR) {
		Set StrSub=$listget(STR,Ind)
		Set return=return_SEPA_StrSub
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// 要求被替换的内容不能=""
/// w ##class(DHCHAI.Utils.CommonSrv).Replace()
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	New (instr,substr,replacement)
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// 取浏览器版本
/// w ##class(DHCHAI.Utils.CommonSrv).GetIEVersion()
ClassMethod GetIEVersion()
{
	New
	;Mozilla/4.0 (compatible; MSIE 6.0;
	;Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64;Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET4.0C; .NET4.0E; .NET CLR 3.5.30729;.NET CLR 3.0.30729)"
	;Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)like Gecko
	Set UserAgent = $G(%request.CgiEnvs("HTTP_USER_AGENT"))
	Set IEVersion="IE11"
	if UserAgent["Mozilla/4.0 (compatible; MSIE 6.0;" {
		Set IEVersion = "IE6"
	}elseif UserAgent["Mozilla/4.0 (compatible; MSIE 8.0;" {
		Set IEVersion = "IE8"
	}elseif UserAgent["Mozilla/4.0 (compatible; MSIE 9.0;" {
		Set IEVersion = "IE9"
	}
	Quit IEVersion
}

/// @other 获得当前请求路径 
/// 	http://localhost:80/dthealth/web/csp/test/csrpathtest.csp
ClassMethod GetCacheURL()
{
	New
	Set cspUrl = ""
	if ($d(%request.CgiEnvs("CACHE_URL"))){
		Set cspUrl=$g(%request.CgiEnvs("CACHE_URL"))
	}elseif($d(%request.CgiEnvs("HTTP_URL"))){
		Set cspUrl="http://"_%request.CgiEnvs("HTTP_HOST")_%request.CgiEnvs("HTTP_URL")
	}elseif($d(%request.CgiEnvs("REQUEST_URI"))){
		Set cspUrl="http://"_%request.CgiEnvs("HTTP_HOST")_%request.CgiEnvs("REQUEST_URI")
	}else{
		
	}
	quit cspUrl
}

/// @param path {String} 图片路径
/// @return sgc {%Stream.GlobalCharacter} 返回字符流对象
/// @other 把图片转成base64的字符流对象
/// s sgc = ##class(DHCHAI.Utils.CommonSrv).Img2Base64("E:\DtHealth\app\dthis\web\skin\default\images\logon\1.jpg")
/// while('sgc.AtEnd){
///    w sgc.Read(16384)
/// }
ClassMethod Img2Base64(path) As %Stream.GlobalCharacter
{
	New (path)
 	#dim sgc As %Stream.GlobalCharacter
 	Set sgc = ##class(%Stream.GlobalCharacter).%New()
    Set path = ##Class(%File).NormalizeFilename(path)
    if '##class(%File).Exists(path) {
	    do sgc.Write("NotExistsFile")
	    Quit sgc
    }
    set img = ##class(%FileBinaryStream).%New()  
    set img.Filename = $g(path)   
    set byteList = img.Read(12288)      ;要为3的倍数,这样补0才不会出问题. 12288 = 3*4*1024，12k  
    while(byteList'=""){ 
    	set baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList)
    	;w $l(baseStr)->16814->读时要用
        do sgc.Write(baseStr)
        set byteList = ""         
        set byteList = img.Read(12288)
    }     
    do img.%Close()  
    set img=""  
    quit sgc
}

/// @param sgc {%Stream.GlobalCharacter || String} sgc可以为字符流也可为字符串
/// @param path {String} 图片路径 d:\1.jpg
/// @return 1
/// @other 把sgc保存成path图片
/// /
/// w ##class(DHCHAI.Utils.CommonSrv).Base642Img(str1,"d:1.jpg")
/// w ##class(DHCHAI.Utils.CommonSrv).Base642Img(sgc,"d:1.jpg")
ClassMethod Base642Img(sgc, path As %String) As %Boolean
{
	New (sgc, path)
	if (sgc'=""){
		Set path = ##Class(%File).NormalizeFilename(path)
		Set img = ##class(%FileBinaryStream).%New()
		set img.Filename = $g(path)
		if ($IsObject(sgc)) {	;sgc字符流
			do sgc.Rewind()
			while ('sgc.AtEnd){			
				Set baseStr = sgc.Read(16814) ;不能用16k
				Set byteList = ##class(%SYSTEM.Encryption).Base64Decode(baseStr)
				do img.Write(byteList)	
			}
		}else{	;sgc字符串
			Set byteList = ##class(%SYSTEM.Encryption).Base64Decode(sgc)
			do img.Write(byteList)
		}
		do img.SaveStream()
		do img.%Close()
		set img = ""
	}
	quit $$$OK
}

ClassMethod ServerIP()
{
	New
	Set SERVER=""
	Set SERVER = %request.GetCgiEnv("LOCAL_ADDR") ;%request.CgiEnvs("SERVER_ADDR")
	Quit SERVER
}

/// 把点变成英文点
ClassMethod Point2NamePoint(Name)
{
	New (Name)
	Quit $tr(Name,$c(183),$c(63))
}

/// @判断Chinese的长度.汉字为2
/// w ##class(DHCHAI.Utils.CommonSrv).Length("IMedical，系统")
/// w ##class(DHCHAI.Utils.CommonSrv).Length("{｛")
ClassMethod Length(Chinese)
{
	New (Chinese)
	;19968至40869
	Set Len = 0
	for j=1:1:$l(Chinese) Do
	.Set CurrentWord = $e(Chinese,j)
	.if (..IsChinese(CurrentWord)) Set Len = Len+1
	.
	.Set Len = Len+1
	Quit Len
}

/// w ##class(DHCHAI.Utils.CommonSrv).IsChinese("密")
/// w ##class(DHCHAI.Utils.CommonSrv).IsChinese("｛{")
ClassMethod IsChinese(Char)
{
	New (Char)
	Quit:(($a(Char)>=19968) && ($a(Char)<=40869)) 1
	Quit:("￥…｛｝。，？”“《》：！——-、；（）"[Char) 1
	Quit 0
}

/// @author: wanghc 
/// @param: App 虚拟路径, /dthealth/web or  /trakcarelive/trak/web   or trakcare/web
/// @param: [AddPath] 增加路径 如/key , /html/help/
/// @return: 物理路径,  
/// 如 1. AddPath 为空时,    /dthealth/app/dthis/web/  
/// 如 2. AddPath = key       /dthealth/app/dthis/web/key/ 
/// 如 3. AddPath = html/help /dthealth/app/dthis/web/html/help/ 
/// w ##class(DHCHAI.Utils.CommonSrv).GetPhysicalPath("/dtheath/web","key")
ClassMethod GetPhysicalPath(AppPath, AddPath = "")
{
	New (AppPath, AddPath)
	if AppPath = ""{
		Set Config = $o(^websys.ConfigurationD(""))
		Set App = $lg(^websys.ConfigurationD(Config),2)
	}Else{
		Set App = AppPath
	}
	If App="" Set App="/dthealth/web"
	Set dir=""
	Set CurNS=$namespace
	zn "%sys"
	if $d(^SYS("Security","ApplicationsD",App),g){
		Set dir = $lg(g,17)
	}else{
		Set App1 = $p(App,"/",1,$l(App,"/")-1)
		if $d(^SYS("Security","ApplicationsD",App1),g){
			Set dir = $lg(g,17)_"/"_$p(App,"/",$l(App,"/"))
		}else{
			Set App2 = $p(App,"/",1,$l(App,"/")-2)
			if $d(^SYS("Security","ApplicationsD",App2),g){
				Set dir = $lg(g,17)_"/"_$p(App,"/",$l(App,"/")-1,$l(App,"/"))
			}
		}
	}
	zn CurNS
	Set dir = ##class(%File).NormalizeDirectory(dir_"/"_AddPath)
	Quit dir
}

/// @author: wanghc 
/// @param: Chinese 汉字
/// @return: SpellStr 拼音首字母
/// w ##class(DHCHAI.Utils.CommonSrv).ToChineseSpell("yyy--东华软件医疗事业部")
ClassMethod ToChineseSpell(Chinese)
{
	New (Chinese)
    Quit:Chinese="" ""
	;汉字拼音首字母列表 本列表包含了20902个汉字,用于配合 ToChineseSpell ,本表收录的字符的Unicode编码范围为19968至40869
	set str1 = "YDYQSXMWZSSXJBYMGCCZQPSSQBYCDSCDQLDYLYBSSJGYZZJJFKCCLZDHWDWZJLJPFYYNWJJTMYHZWZHFLZPPQHGSCYYYNJQYXXGJHHSDSJNKKTMOMLCRXYPSNQSECCQZGGLLYJLMYZZSECYKYYHQWJSSGGYXYZYJWWKDJHYCHMYXJTLXJYQBYXZLDWRDJRWYSRLDZJPCBZJJBRCFTLECZSTZFXXZHTRQHYBDLYCZSSYMMRFMYQZPWWJJYFCRWFDFZQPYDDWYXKYJAWJFFXYPSFTZYHHYZYSWCJYXSCLCXXWZZXNBGNNXBXLZSZSBSGPYSYZDHMDZBQBZCWDZZYYTZHBTSYYBZGNTNXQYWQSKBPHHLXGYBFMJEBJHHGQTJCYSXSTKZHLYCKGLYSMZXYALMELDCCXGZYRJXSDLTYZCQKCNNJWHJTZZCQLJSTSTBNXBTYXCEQXGKWJYFLZQLYHYXSPSFXLMPBYSXXXYDJCZYLLLSJXFHJXPJBTFFYABYXBHZZBJYZLWLCZGGBTSSMDTJZXPTHYQTGLJSCQFZKJZJQNLZWLSLHDZBWJNCJZYZSQQYCQYRZCJJWYBRTWPYFTWEXCSKDZCTBZHYZZYYJXZCFFZZMJYXXSDZZOTTBZLQWFCKSZSXFYRLNYJMBDTHJXSQQCCSBXYYTSYFBXDZTGBCNSLCYZZPSAZYZZSCJCSHZQYDXLBPJLLMQXTYDZXSQJTZPXLCGLQTZWJBHCTSYJSFXYEJJTLBGXSXJMYJQQPFZASYJNTYDJXKJCDJSZCBARTDCLYJQMWNQNCLLLKBYBZZSYHQQLTWLCCXTXLLZNTYLNEWYZYXCZXXGRKRMTCNDNJTSYYSSDQDGHSDBJGHRWRQLYBGLXHLGTGXBQJDZPYJSJYJCTMRNYMGRZJCZGJMZMGXMPRYXKJNYMSGMZJYMKMFXMLDTGFBHCJHKYLPFMDXLQJJSMTQGZSJLQDLDGJYCALCMZCSDJLLNXDJFFFFJCZFMZFFPFKHKGDPSXKTACJDHHZDDCRRCFQYJKQCCWJDXHWJLYLLZGCFCQDSMLZPBJJPLSBCJGGDCKKDEZSQCCKJGCGKDJTJDLZYCXKLQSCGJCLTFPCQCZGWPJDQYZJJBYJHSJDZWGFSJGZKQCCZLLPSPKJGQJHZZLJPLGJGJJTHJJYJZCZMLZLYQBGJWMLJKXZDZNJQSYZMLJLLJKYWXMKJLHSKJGBMCLYYMKXJQLBMLLKMDXXKWYXYSLMLPSJQQJQXYXFJTJDXMXXLLCXQBSYJBGWYMBGGBCYXPJYGPEPFGDJGBHBNSQJYZJKJKHXQFGQZKFHYGKHDKLLSDJQXPQYKYBNQSXQNSZSWHBSXWHXWBZZXDMNSJBSBKBBZKLYLXGWXDRWYQZMYWSJQLCJXXJXKJEQXSCYETLZHLYYYSDZPAQYZCMTLSHTZCFYZYXYLJSDCJQAGYSLCQLYYYSHMRQQKLDXZSCSSSYDYCJYSFSJBFRSSZQSBXXPXJYSDRCKGJLGDKZJZBDKTCSYQPYHSTCLDJDHMXMCGXYZHJDDTMHLTXZXYLYMOHYJCLTYFBQQXPFBDFHHTKSQHZYYWCNXXCRWHOWGYJLEGWDQCWGFJYCSNTMYTOLBYGWQWESJPWNMLRYDZSZTXYQPZGCWXHNGPYXSHMYQJXZTDPPBFYHZHTJYFDZWKGKZBLDNTSXHQEEGZZYLZMMZYJZGXZXKHKSTXNXXWYLYAPSTHXDWHZYMPXAGKYDXBHNHXKDPJNMYHYLPMGOCSLNZHKXXLPZZLBMLSFBHHGYGYYGGBHSCYAQTYWLXTZQCEZYDQDQMMHTKLLSZHLSJZWFYHQSWSCWLQAZYNYTLSXTHAZNKZZSZZLAXXZWWCTGQQTDDYZTCCHYQZFLXPSLZYGPZSZNGLNDQTBDLXGTCTAJDKYWNSYZLJHHZZCWNYYZYWMHYCHHYXHJKZWSXHZYXLYSKQYSPSLYZWMYPPKBYGLKZHTYXAXQSYSHXASMCHKDSCRSWJPWXSGZJLWWSCHSJHSQNHCSEGNDAQTBAALZZMSSTDQJCJKTSCJAXPLGGXHHGXXZCXPDMMHLDGTYBYSJMXHMRCPXXJZCKZXSHMLQXXTTHXWZFKHCCZDYTCJYXQHLXDHYPJQXYLSYYDZOZJNYXQEZYSQYAYXWYPDGXDDXSPPYZNDLTWRHXYDXZZJHTCXMCZLHPYYYYMHZLLHNXMYLLLMDCPPXHMXDKYCYRDLTXJCHHZZXZLCCLYLNZSHZJZZLNNRLWHYQSNJHXYNTTTKYJPYCHHYEGKCTTWLGQRLGGTGTYGYHPYHYLQYQGCWYQKPYYYTTTTLHYHLLTYTTSPLKYZXGZWGPYDSSZZDQXSKCQNMJJZZBXYQMJRTFFBTKHZKBXLJJKDXJTLBWFZPPTKQTZTGPDGNTPJYFALQMKGXBDCLZFHZCLLLLADPMXDJHLCCLGYHDZFGYDDGCYYFGYDXKSSEBDHYKDKDKHNAXXYBPBYYHXZQGAFFQYJXDMLJCSQZLLPCHBSXGJYNDYBYQSPZWJLZKSDDTACTBXZDYZYPJZQSJNKKTKNJDJGYYPGTLFYQKASDNTCYHBLWDZHBBYDWJRYGKZYHEYYFJMSDTYFZJJHGCXPLXHLDWXXJKYTCYKSSSMTWCTTQZLPBSZDZWZXGZAGYKTYWXLHLSPBCLLOQMMZSSLCMBJCSZZKYDCZJGQQDSMCYTZQQLWZQZXSSFPTTFQMDDZDSHDTDWFHTDYZJYQJQKYPBDJYYXTLJHDRQXXXHAYDHRJLKLYTWHLLRLLRCXYLBWSRSZZSYMKZZHHKYHXKSMDSYDYCJPBZBSQLFCXXXNXKXWYWSDZYQOGGQMMYHCDZTTFJYYBGSTTTYBYKJDHKYXBELHTYPJQNFXFDYKZHQKZBYJTZBXHFDXKDASWTAWAJLDYJSFHBLDNNTNQJTJNCHXFJSRFWHZFMDRYJYJWZPDJKZYJYMPCYZNYNXFBYTFYFWYGDBNZZZDNYTXZEMMQBSQEHXFZMBMFLZZSRXYMJGSXWZJSPRYDJSJGXHJJGLJJYNZZJXHGXKYMLPYYYCXYTWQZSWHWLYRJLPXSLSXMFSWWKLCTNXNYNPSJSZHDZEPTXMYYWXYYSYWLXJQZQXZDCLEEELMCPJPCLWBXSQHFWWTFFJTNQJHJQDXHWLBYZNFJLALKYYJLDXHHYCSTYYWNRJYXYWTRMDRQHWQCMFJDYZMHMYYXJWMYZQZXTLMRSPWWCHAQBXYGZYPXYYRRCLMPYMGKSJSZYSRMYJSNXTPLNBAPPYPYLXYYZKYNLDZYJZCZNNLMZHHARQMPGWQTZMXXMLLHGDZXYHXKYXYCJMFFYYHJFSBSSQLXXNDYCANNMTCJCYPRRNYTYQNYYMBMSXNDLYLYSLJRLXYSXQMLLYZLZJJJKYZZCSFBZXXMSTBJGNXYZHLXNMCWSCYZYFZLXBRNNNYLBNRTGZQYSATSWRYHYJZMZDHZGZDWYBSSCSKXSYHYTXXGCQGXZZSHYXJSCRHMKKBXCZJYJYMKQHZJFNBHMQHYSNJNZYBKNQMCLGQHWLZNZSWXKHLJHYYBQLBFCDSXDLDSPFZPSKJYZWZXZDDXJSMMEGJSCSSMGCLXXKYYYLNYPWWWGYDKZJGGGZGGSYCKNJWNJPCXBJJTQTJWDSSPJXZXNZXUMELPXFSXTLLXCLJXJJLJZXCTPSWXLYDHLYQRWHSYCSQYYBYAYWJJJQFWQCQQCJQGXALDBZZYJGKGXPLTZYFXJLTPADKYQHPMATLCPDCKBMTXYBHKLENXDLEEGQDYMSAWHZMLJTWYGXLYQZLJEEYYBQQFFNLYXRDSCTGJGXYYNKLLYQKCCTLHJLQMKKZGCYYGLLLJDZGYDHZWXPYSJBZKDZGYZZHYWYFQYTYZSZYEZZLYMHJJHTSMQWYZLKYYWZCSRKQYTLTDXWCTYJKLWSQZWBDCQYNCJSRSZJLKCDCDTLZZZACQQZZDDXYPLXZBQJYLZLLLQDDZQJYJYJZYXNYYYNYJXKXDAZWYRDLJYYYRJLXLLDYXJCYWYWNQCCLDDNYYYNYCKCZHXXCCLGZQJGKWPPCQQJYSBZZXYJSQPXJPZBSBDSFNSFPZXHDWZTDWPPTFLZZBZDMYYPQJRSDZSQZSQXBDGCPZSWDWCSQZGMDHZXMWWFYBPDGPHTMJTHZSMMBGZMBZJCFZWFZBBZMQCFMBDMCJXLGPNJBBXGYHYYJGPTZGZMQBQTCGYXJXLWZKYDPDYMGCFTPFXYZTZXDZXTGKMTYBBCLBJASKYTSSQYYMSZXFJEWLXLLSZBQJJJAKLYLXLYCCTSXMCWFKKKBSXLLLLJYXTYLTJYYTDPJHNHNNKBYQNFQYYZBYYESSESSGDYHFHWTCJBSDZZTFDMXHCNJZYMQWSRYJDZJQPDQBBSTJGGFBKJBXTGQHNGWJXJGDLLTHZHHYYYYYYSXWTYYYCCBDBPYPZYCCZYJPZYWCBDLFWZCWJDXXHYHLHWZZXJTCZLCDPXUJCZZZLYXJJTXPHFXWPYWXZPTDZZBDZCYHJHMLXBQXSBYLRDTGJRRCTTTHYTCZWMXFYTWWZCWJWXJYWCSKYBZSCCTZQNHXNWXXKHKFHTSWOCCJYBCMPZZYKBNNZPBZHHZDLSYDDYTYFJPXYNGFXBYQXCBHXCPSXTYZDMKYSNXSXLHKMZXLYHDHKWHXXSSKQYHHCJYXGLHZXCSNHEKDTGZXQYPKDHEXTYKCNYMYYYPKQYYYKXZLTHJQTBYQHXBMYHSQCKWWYLLHCYYLNNEQXQWMCFBDCCMLJGGXDQKTLXKGNQCDGZJWYJJLYHHQTTTNWCHMXCXWHWSZJYDJCCDBQCDGDNYXZTHCQRXCBHZTQCBXWGQWYYBXHMBYMYQTYEXMQKYAQYRGYZSLFYKKQHYSSQYSHJGJCNXKZYCXSBXYXHYYLSTYCXQTHYSMGSCPMMGCCCCCMTZTASMGQZJHKLOSQYLSWTMXSYQKDZLJQQYPLSYCZTCQQPBBQJZCLPKHQZYYXXDTDDTSJCXFFLLCHQXMJLWCJCXTSPYCXNDTJSHJWXDQQJSKXYAMYLSJHMLALYKXCYYDMNMDQMXMCZNNCYBZKKYFLMCHCMLHXRCJJHSYLNMTJZGZGYWJXSRXCWJGJQHQZDQJDCJJZKJKGDZQGJJYJYLXZXXCDQHHHEYTMHLFSBDJSYYSHFYSTCZQLPBDRFRZTZYKYWHSZYQKWDQZRKMSYNBCRXQBJYFAZPZZEDZCJYWBCJWHYJBQSZYWRYSZPTDKZPFPBNZTKLQYHBBZPNPPTYZZYBQNYDCPJMMCYCQMCYFZZDCMNLFPBPLNGQJTBTTNJZPZBBZNJKLJQYLNBZQHKSJZNGGQSZZKYXSHPZSNBCGZKDDZQANZHJKDRTLZLSWJLJZLYWTJNDJZJHXYAYNCBGTZCSSQMNJPJYTYSWXZFKWJQTKHTZPLBHSNJZSYZBWZZZZLSYLSBJHDWWQPSLMMFBJDWAQYZTCJTBNNWZXQXCDSLQGDSDPDZHJTQQPSWLYYJZLGYXYZLCTCBJTKTYCZJTQKBSJLGMGZDMCSGPYNJZYQYYKNXRPWSZXMTNCSZZYXYBYHYZAXYWQCJTLLCKJJTJHGDXDXYQYZZBYWDLWQCGLZGJGQRQZCZSSBCRPCSKYDZNXJSQGXSSJMYDNSTZTPBDLTKZWXQWQTZEXNQCZGWEZKSSBYBRTSSSLCCGBPSZQSZLCCGLLLZXHZQTHCZMQGYZQZNMCOCSZJMMZSQPJYGQLJYJPPLDXRGZYXCCSXHSHGTZNLZWZKJCXTCFCJXLBMQBCZZWPQDNHXLJCTHYZLGYLNLSZZPCXDSCQQHJQKSXZPBAJYEMSMJTZDXLCJYRYYNWJBNGZZTMJXLTBSLYRZPYLSSCNXPHLLHYLLQQZQLXYMRSYCXZLMMCZLTZSDWTJJLLNZGGQXPFSKYGYGHBFZPDKMWGHCXMSGDXJMCJZDYCABXJDLNBCDQYGSKYDQTXDJJYXMSZQAZDZFSLQXYJSJZYLBTXXWXQQZBJZUFBBLYLWDSLJHXJYZJWTDJCZFQZQZZDZSXZZQLZCDZFJHYSPYMPQZMLPPLFFXJJNZZYLSJEYQZFPFZKSYWJJJHRDJZZXTXXGLGHYDXCSKYSWMMZCWYBAZBJKSHFHJCXMHFQHYXXYZFTSJYZFXYXPZLCHMZMBXHZZSXYFYMNCWDABAZLXKTCSHHXKXJJZJSTHYGXSXYYHHHJWXKZXSSBZZWHHHCWTZZZPJXSNXQQJGZYZYWLLCWXZFXXYXYHXMKYYSWSQMNLNAYCYSPMJKHWCQHYLAJJMZXHMMCNZHBHXCLXTJPLTXYJHDYYLTTXFSZHYXXSJBJYAYRSMXYPLCKDUYHLXRLNLLSTYZYYQYGYHHSCCSMZCTZQXKYQFPYYRPFFLKQUNTSZLLZMWWTCQQYZWTLLMLMPWMBZSSTZRBPDDTLQJJBXZCSRZQQYGWCSXFWZLXCCRSZDZMCYGGDZQSGTJSWLJMYMMZYHFBJDGYXCCPSHXNZCSBSJYJGJMPPWAFFYFNXHYZXZYLREMZGZCYZSSZDLLJCSQFNXZKPTXZGXJJGFMYYYSNBTYLBNLHPFZDCYFBMGQRRSSSZXYSGTZRNYDZZCDGPJAFJFZKNZBLCZSZPSGCYCJSZLMLRSZBZZLDLSLLYSXSQZQLYXZLSKKBRXBRBZCYCXZZZEEYFGKLZLYYHGZSGZLFJHGTGWKRAAJYZKZQTSSHJJXDCYZUYJLZYRZDQQHGJZXSSZBYKJPBFRTJXLLFQWJHYLQTYMBLPZDXTZYGBDHZZRBGXHWNJTJXLKSCFSMWLSDQYSJTXKZSCFWJLBXFTZLLJZLLQBLSQMQQCGCZFPBPHZCZJLPYYGGDTGWDCFCZQYYYQYSSCLXZSKLZZZGFFCQNWGLHQYZJJCZLQZZYJPJZZBPDCCMHJGXDQDGDLZQMFGPSYTSDYFWWDJZJYSXYYCZCYHZWPBYKXRYLYBHKJKSFXTZJMMCKHLLTNYYMSYXYZPYJQYCSYCWMTJJKQYRHLLQXPSGTLYYCLJSCPXJYZFNMLRGJJTYZBXYZMSJYJHHFZQMSYXRSZCWTLRTQZSSTKXGQKGSPTGCZNJSJCQCXHMXGGZTQYDJKZDLBZSXJLHYQGGGTHQSZPYHJHHGYYGKGGCWJZZYLCZLXQSFTGZSLLLMLJSKCTBLLZZSZMMNYTPZSXQHJCJYQXYZXZQZCPSHKZZYSXCDFGMWQRLLQXRFZTLYSTCTMJCXJJXHJNXTNRZTZFQYHQGLLGCXSZSJDJLJCYDSJTLNYXHSZXCGJZYQPYLFHDJSBPCCZHJJJQZJQDYBSSLLCMYTTMQTBHJQNNYGKYRQYQMZGCJKPDCGMYZHQLLSLLCLMHOLZGDYYFZSLJCQZLYLZQJESHNYLLJXGJXLYSYYYXNBZLJSSZCQQCJYLLZLTJYLLZLLBNYLGQCHXYYXOXCXQKYJXXXYKLXSXXYQXCYKQXQCSGYXXYQXYGYTQOHXHXPYXXXULCYEYCHZZCBWQBBWJQZSCSZSSLZYLKDESJZWMYMCYTSDSXXSCJPQQSQYLYYZYCMDJDZYWCBTJSYDJKCYDDJLBDJJSODZYSYXQQYXDHHGQQYQHDYXWGMMMAJDYBBBPPBCMUUPLJZSMTXERXJMHQNUTPJDCBSSMSSSTKJTSSMMTRCPLZSZMLQDSDMJMQPNQDXCFYNBFSDQXYXHYAYKQYDDLQYYYSSZBYDSLNTFQTZQPZMCHDHCZCWFDXTMYQSPHQYYXSRGJCWTJTZZQMGWJJTJHTQJBBHWZPXXHYQFXXQYWYYHYSCDYDHHQMNMTMWCPBSZPPZZGLMZFOLLCFWHMMSJZTTDHZZYFFYTZZGZYSKYJXQYJZQBHMBZZLYGHGFMSHPZFZSNCLPBQSNJXZSLXXFPMTYJYGBXLLDLXPZJYZJYHHZCYWHJYLSJEXFSZZYWXKZJLUYDTMLYMQJPWXYHXSKTQJEZRPXXZHHMHWQPWQLYJJQJJZSZCPHJLCHHNXJLQWZJHBMZYXBDHHYPZLHLHLGFWLCHYYTLHJXCJMSCPXSTKPNHQXSRTYXXTESYJCTLSSLSTDLLLWWYHDHRJZSFGXTSYCZYNYHTDHWJSLHTZDQDJZXXQHGYLTZPHCSQFCLNJTCLZPFSTPDYNY"
	set str2 = "LGMJLLYCQHYSSHCHYLHQYQTMZYPBYWRFQYKQSYSLZDQJMPXYYSSRHZJNYWTQDFZBWWTWWRXCWHGYHXMKMYYYQMSMZHNGCEPMLQQMTCWCTMMPXJPJJHFXYYZSXZHTYBMSTSYJTTQQQYYLHYNPYQZLCYZHZWSMYLKFJXLWGXYPJYTYSYXYMZCKTTWLKSMZSYLMPWLZWXWQZSSAQSYXYRHSSNTSRAPXCPWCMGDXHXZDZYFJHGZTTSBJHGYZSZYSMYCLLLXBTYXHBBZJKSSDMALXHYCFYGMQYPJYCQXJLLLJGSLZGQLYCJCCZOTYXMTMTTLLWTGPXYMZMKLPSZZZXHKQYSXCTYJZYHXSHYXZKXLZWPSQPYHJWPJPWXQQYLXSDHMRSLZZYZWTTCYXYSZZSHBSCCSTPLWSSCJCHNLCGCHSSPHYLHFHHXJSXYLLNYLSZDHZXYLSXLWZYKCLDYAXZCMDDYSPJTQJZLNWQPSSSWCTSTSZLBLNXSMNYYMJQBQHRZWTYYDCHQLXKPZWBGQYBKFCMZWPZLLYYLSZYDWHXPSBCMLJBSCGBHXLQHYRLJXYSWXWXZSLDFHLSLYNJLZYFLYJYCDRJLFSYZFSLLCQYQFGJYHYXZLYLMSTDJCYHBZLLNWLXXYGYYHSMGDHXXHHLZZJZXCZZZCYQZFNGWPYLCPKPYYPMCLQKDGXZGGWQBDXZZKZFBXXLZXJTPJPTTBYTSZZDWSLCHZHSLTYXHQLHYXXXYYZYSWTXZKHLXZXZPYHGCHKCFSYHUTJRLXFJXPTZTWHPLYXFCRHXSHXKYXXYHZQDXQWULHYHMJTBFLKHTXCWHJFWJCFPQRYQXCYYYQYGRPYWSGSUNGWCHKZDXYFLXXHJJBYZWTSXXNCYJJYMSWZJQRMHXZWFQSYLZJZGBHYNSLBGTTCSYBYXXWXYHXYYXNSQYXMQYWRGYQLXBBZLJSYLPSYTJZYHYZAWLRORJMKSCZJXXXYXCHDYXRYXXJDTSQFXLYLTSFFYXLMTYJMJUYYYXLTZCSXQZQHZXLYYXZHDNBRXXXJCTYHLBRLMBRLLAXKYLLLJLYXXLYCRYLCJTGJCMTLZLLCYZZPZPCYAWHJJFYBDYYZSMPCKZDQYQPBPCJPDCYZMDPBCYYDYCNNPLMTMLRMFMMGWYZBSJGYGSMZQQQZTXMKQWGXLLPJGZBQCDJJJFPKJKCXBLJMSWMDTQJXLDLPPBXCWRCQFBFQJCZAHZGMYKPHYYHZYKNDKZMBPJYXPXYHLFPNYYGXJDBKXNXHJMZJXSTRSTLDXSKZYSYBZXJLXYSLBZYSLHXJPFXPQNBYLLJQKYGZMCYZZYMCCSLCLHZFWFWYXZMWSXTYNXJHPYYMCYSPMHYSMYDYSHQYZCHMJJMZCAAGCFJBBHPLYZYLXXSDJGXDHKXXTXXNBHRMLYJSLTXMRHNLXQJXYZLLYSWQGDLBJHDCGJYQYCMHWFMJYBMBYJYJWYMDPWHXQLDYGPDFXXBCGJSPCKRSSYZJMSLBZZJFLJJJLGXZGYXYXLSZQYXBEXYXHGCXBPLDYHWETTWWCJMBTXCHXYQXLLXFLYXLLJLSSFWDPZSMYJCLMWYTCZPCHQEKCQBWLCQYDPLQPPQZQFJQDJHYMMCXTXDRMJWRHXCJZYLQXDYYNHYYHRSLSRSYWWZJYMTLTLLGTQCJZYABTCKZCJYCCQLJZQXALMZYHYWLWDXZXQDLLQSHGPJFJLJHJABCQZDJGTKHSSTCYJLPSWZLXZXRWGLDLZRLZXTGSLLLLZLYXXWGDZYGBDPHZPBRLWSXQBPFDWOFMWHLYPCBJCCLDMBZPBZZLCYQXLDOMZBLZWPDWYYGDSTTHCSQSCCRSSSYSLFYBFNTYJSZDFNDPDHDZZMBBLSLCMYFFGTJJQWFTMTPJWFNLBZCMMJTGBDZLQLPYFHYYMJYLSDCHDZJWJCCTLJCLDTLJJCPDDSQDSSZYBNDBJLGGJZXSXNLYCYBJXQYCBYLZCFZPPGKCXZDZFZTJJFJSJXZBNZYJQTTYJYHTYCZHYMDJXTTMPXSPLZCDWSLSHXYPZGTFMLCJTYCBPMGDKWYCYZCDSZZYHFLYCTYGWHKJYYLSJCXGYWJCBLLCSNDDBTZBSCLYZCZZSSQDLLMQYYHFSLQLLXFTYHABXGWNYWYYPLLSDLDLLBJCYXJZMLHLJDXYYQYTDLLLBUGBFDFBBQJZZMDPJHGCLGMJJPGAEHHBWCQXAXHHHZCHXYPHJAXHLPHJPGPZJQCQZGJJZZUZDMQYYBZZPHYHYBWHAZYJHYKFGDPFQSDLZMLJXKXGALXZDAGLMDGXMWZQYXXDXXPFDMMSSYMPFMDMMKXKSYZYSHDZKXSYSMMZZZMSYDNZZCZXFPLSTMZDNMXCKJMZTYYMZMZZMSXHHDCZJEMXXKLJSTLWLSQLYJZLLZJSSDPPMHNLZJCZYHMXXHGZCJMDHXTKGRMXFWMCGMWKDTKSXQMMMFZZYDKMSCLCMPCGMHSPXQPZDSSLCXKYXTWLWJYAHZJGZQMCSNXYYMMPMLKJXMHLMLQMXCTKZMJQYSZJSYSZHSYJZJCDAJZYBSDQJZGWZQQXFKDMSDJLFWEHKZQKJPEYPZYSZCDWYJFFMZZYLTTDZZEFMZLBNPPLPLPEPSZALLTYLKCKQZKGENQLWAGYXYDPXLHSXQQWQCQXQCLHYXXMLYCCWLYMQYSKGCHLCJNSZKPYZKCQZQLJPDMDZHLASXLBYDWQLWDNBQCRYDDZTJYBKBWSZDXDTNPJDTCTQDFXQQMGNXECLTTBKPWSLCTYQLPWYZZKLPYGZCQQPLLKCCYLPQMZCZQCLJSLQZDJXLDDHPZQDLJJXZQDXYZQKZLJCYQDYJPPYPQYKJYRMPCBYMCXKLLZLLFQPYLLLMBSGLCYSSLRSYSQTMXYXZQZFDZUYSYZTFFMZZSMZQHZSSCCMLYXWTPZGXZJGZGSJSGKDDHTQGGZLLBJDZLCBCHYXYZHZFYWXYZYMSDBZZYJGTSMTFXQYXQSTDGSLNXDLRYZZLRYYLXQHTXSRTZNGZXBNQQZFMYKMZJBZYMKBPNLYZPBLMCNQYZZZSJZHJCTZKHYZZJRDYZHNPXGLFZTLKGJTCTSSYLLGZRZBBQZZKLPKLCZYSSUYXBJFPNJZZXCDWXZYJXZZDJJKGGRSRJKMSMZJLSJYWQSKYHQJSXPJZZZLSNSHRNYPZTWCHKLPSRZLZXYJQXQKYSJYCZTLQZYBBYBWZPQDWWYZCYTJCJXCKCWDKKZXSGKDZXWWYYJQYYTCYTDLLXWKCZKKLCCLZCQQDZLQLCSFQCHQHSFSMQZZLNBJJZBSJHTSZDYSJQJPDLZCDCWJKJZZLPYCGMZWDJJBSJQZSYZYHHXJPBJYDSSXDZNCGLQMBTSFSBPDZDLZNFGFJGFSMPXJQLMBLGQCYYXBQKDJJQYRFKZTJDHCZKLBSDZCFJTPLLJGXHYXZCSSZZXSTJYGKGCKGYOQXJPLZPBPGTGYJZGHZQZZLBJLSQFZGKQQJZGYCZBZQTLDXRJXBSXXPZXHYZYCLWDXJJHXMFDZPFZHQHQMQGKSLYHTYCGFRZGNQXCLPDLBZCSCZQLLJBLHBZCYPZZPPDYMZZSGYHCKCPZJGSLJLNSCDSLDLXBMSTLDDFJMKDJDHZLZXLSZQPQPGJLLYBDSZGQLBZLSLKYYHZTTNTJYQTZZPSZQZTLLJTYYLLQLLQYZQLBDZLSLYYZYMDFSZSNHLXZNCZQZPBWSKRFBSYZMTHBLGJPMCZZLSTLXSHTCSYZLZBLFEQHLXFLCJLYLJQCBZLZJHHSSTBRMHXZHJZCLXFNBGXGTQJCZTMSFZKJMSSNXLJKBHSJXNTNLZDNTLMSJXGZJYJCZXYJYJWRWWQNZTNFJSZPZSHZJFYRDJSFSZJZBJFZQZZHZLXFYSBZQLZSGYFTZDCSZXZJBQMSZKJRHYJZCKMJKHCHGTXKXQGLXPXFXTRTYLXJXHDTSJXHJZJXZWZLCQSBTXWXGXTXXHXFTSDKFJHZYJFJXRZSDLLLTQSQQZQWZXSYQTWGWBZCGZLLYZBCLMQQTZHZXZXLJFRMYZFLXYSQXXJKXRMQDZDMMYYBSQBHGZMWFWXGMXLZPYYTGZYCCDXYZXYWGSYJYZNBHPZJSQSYXSXRTFYZGRHZTXSZZTHCBFCLSYXZLZQMZLMPLMXZJXSFLBYZMYQHXJSXRXSQZZZSSLYFRCZJRCRXHHZXQYDYHXSJJHZCXZBTYNSYSXJBQLPXZQPYMLXZKYXLXCJLCYSXXZZLXDLLLJJYHZXGYJWKJRWYHCPSGNRZLFZWFZZNSXGXFLZSXZZZBFCSYJDBRJKRDHHGXJLJJTGXJXXSTJTJXLYXQFCSGSWMSBCTLQZZWLZZKXJMLTMJYHSDDBXGZHDLBMYJFRZFSGCLYJBPMLYSMSXLSZJQQHJZFXGFQFQBPXZGYYQXGZTCQWYLTLGWSGWHRLFSFGZJMGMGBGTJFSYZZGZYZAFLSSPMLPFLCWBJZCLJJMZLPJJLYMQDMYYYFBGYGYZMLYZDXQYXRQQQHSYYYQXYLJTYXFSFSLLGNQCYHYCWFHCCCFXPYLYPLLZYXXXXXKQHHXSHJZCFZSCZJXCPZWHHHHHAPYLQALPQAFYHXDYLUKMZQGGGDDESRNNZLTZGCHYPPYSQJJHCLLJTOLNJPZLJLHYMHEYDYDSQYCDDHGZUNDZCLZYZLLZNTNYZGSLHSLPJJBDGWXPCDUTJCKLKCLWKLLCASSTKZZDNQNTTLYYZSSYSSZZRYLJQKCQDHHCRXRZYDGRGCWCGZQFFFPPJFZYNAKRGYWYQPQXXFKJTSZZXSWZDDFBBXTBGTZKZNPZZPZXZPJSZBMQHKCYXYLDKLJNYPKYGHGDZJXXEAHPNZKZTZCMXCXMMJXNKSZQNMNLWBWWXJKYHCPSTMCSQTZJYXTPCTPDTNNPGLLLZSJLSPBLPLQHDTNJNLYYRSZFFJFQWDPHZDWMRZCCLODAXNSSNYZRESTYJWJYJDBCFXNMWTTBYLWSTSZGYBLJPXGLBOCLHPCBJLTMXZLJYLZXCLTPNCLCKXTPZJSWCYXSFYSZDKNTLBYJCYJLLSTGQCBXRYZXBXKLYLHZLQZLNZCXWJZLJZJNCJHXMNZZGJZZXTZJXYCYYCXXJYYXJJXSSSJSTSSTTPPGQTCSXWZDCSYFPTFBFHFBBLZJCLZZDBXGCXLQPXKFZFLSYLTUWBMQJHSZBMDDBCYSCCLDXYCDDQLYJJWMQLLCSGLJJSYFPYYCCYLTJANTJJPWYCMMGQYYSXDXQMZHSZXPFTWWZQSWQRFKJLZJQQYFBRXJHHFWJJZYQAZMYFRHCYYBYQWLPEXCCZSTYRLTTDMQLYKMBBGMYYJPRKZNPBSXYXBHYZDJDNGHPMFSGMWFZMFQMMBCMZZCJJLCNUXYQLMLRYGQZCYXZLWJGCJCGGMCJNFYZZJHYCPRRCMTZQZXHFQGTJXCCJEAQCRJYHPLQLSZDJRBCQHQDYRHYLYXJSYMHZYDWLDFRYHBPYDTSSCNWBXGLPZMLZZTQSSCPJMXXYCSJYTYCGHYCJWYRXXLFEMWJNMKLLSWTXHYYYNCMMCWJDQDJZGLLJWJRKHPZGGFLCCSCZMCBLTBHBQJXQDSPDJZZGKGLFQYWBZYZJLTSTDHQHCTCBCHFLQMPWDSHYYTQWCNZZJTLBYMBPDYYYXSQKXWYYFLXXNCWCXYPMAELYKKJMZZZBRXYYQJFLJPFHHHYTZZXSGQQMHSPGDZQWBWPJHZJDYSCQWZKTXXSQLZYYMYSDZGRXCKKUJLWPYSYSCSYZLRMLQSYLJXBCXTLWDQZPCYCYKPPPNSXFYZJJRCEMHSZMSXLXGLRWGCSTLRSXBZGBZGZTCPLUJLSLYLYMTXMTZPALZXPXJTJWTCYYZLBLXBZLQMYLXPGHDSLSSDMXMBDZZSXWHAMLCZCPJMCNHJYSNSYGCHSKQMZZQDLLKABLWJXSFMOCDXJRRLYQZKJMYBYQLYHETFJZFRFKSRYXFJTWDSXXSYSQJYSLYXWJHSNLXYYXHBHAWHHJZXWMYLJCSSLKYDZTXBZSYFDXGXZJKHSXXYBSSXDPYNZWRPTQZCZENYGCXQFJYKJBZMLJCMQQXUOXSLYXXLYLLJDZBTYMHPFSTTQQWLHOKYBLZZALZXQLHZWRRQHLSTMYPYXJJXMQSJFNBXYXYJXXYQYLTHYLQYFMLKLJTMLLHSZWKZHLJMLHLJKLJSTLQXYLMBHHLNLZXQJHXCFXXLHYHJJGBYZZKBXSCQDJQDSUJZYYHZHHMGSXCSYMXFEBCQWWRBPYYJQTYZCYQYQQZYHMWFFHGZFRJFCDPXNTQYZPDYKHJLFRZXPPXZDBBGZQSTLGDGYLCQMLCHHMFYWLZYXKJLYPQHSYWMQQGQZMLZJNSQXJQSYJYCBEHSXFSZPXZWFLLBCYYJDYTDTHWZSFJMQQYJLMQXXLLDTTKHHYBFPWTYYSQQWNQWLGWDEBZWCMYGCULKJXTMXMYJSXHYBRWFYMWFRXYQMXYSZTZZTFYKMLDHQDXWYYNLCRYJBLPSXCXYWLSPRRJWXHQYPHTYDNXHHMMYWYTZCSQMTSSCCDALWZTCPQPYJLLQZYJSWXMZZMMYLMXCLMXCZMXMZSQTZPPQQBLPGXQZHFLJJHYTJSRXWZXSCCDLXTYJDCQJXSLQYCLZXLZZXMXQRJMHRHZJBHMFLJLMLCLQNLDXZLLLPYPSYJYSXCQQDCMQJZZXHNPNXZMEKMXHYKYQLXSXTXJYYHWDCWDZHQYYBGYBCYSCFGPSJNZDYZZJZXRZRQJJYMCANYRJTLDPPYZBSTJKXXZYPFDWFGZZRPYMTNGXZQBYXNBUFNQKRJQZMJEGRZGYCLKXZDSKKNSXKCLJSPJYYZLQQJYBZSSQLLLKJXTBKTYLCCDDBLSPPFYLGYDTZJYQGGKQTTFZXBDKTYYHYBBFYTYYBCLPDYTGDHRYRNJSPTCSNYJQHKLLLZSLYDXXWBCJQSPXBPJZJCJDZFFXXBRMLAZHCSNDLBJDSZBLPRZTSWSBXBCLLXXLZDJZSJPYLYXXYFTFFFBHJJXGBYXJPMMMPSSJZJMTLYZJXSWXTYLEDQPJMYGQZJGDJLQJWJQLLSJGJGYGMSCLJJXDTYGJQJQJCJZCJGDZZSXQGSJGGCXHQXSNQLZZBXHSGZXCXYLJXYXYYDFQQJHJFXDHCTXJYRXYSQTJXYEFYYSSYYJXNCYZXFXMSYSZXYYSCHSHXZZZGZZZGFJDLTYLNPZGYJYZYYQZPBXQBDZTZCZYXXYHHSQXSHDHGQHJHGYWSZTMZMLHYXGEBTYLZKQWYTJZRCLEKYSTDBCYKQQSAYXCJXWWGSBHJYZYDHCSJKQCXSWXFLTYNYZPZCCZJQTZWJQDZZZQZLJJXLSBHPYXXPSXSHHEZTXFPTLQYZZXHYTXNCFZYYHXGNXMYWXTZSJPTHHGYMXMXQZXTSBCZYJYXXTYYZYPCQLMMSZMJZZLLZXGXZAAJZYXJMZXWDXZSXZDZXLEYJJZQBHZWZZZQTZPSXZTDSXJJJZNYAZPHXYYSRNQDTHZHYYKYJHDZXZLSWCLYBZYECWCYCRYLCXNHZYDZYDYJDFRJJHTRSQTXYXJRJHOJYNXELXSFSFJZGHPZSXZSZDZCQZBYYKLSGSJHCZSHDGQGXYZGXCHXZJWYQWGYHKSSEQZZNDZFKWYSSTCLZSTSYMCDHJXXYWEYXCZAYDMPXMDSXYBSQMJMZJMTZQLPJYQZCGQHXJHHLXXHLHDLDJQCLDWBSXFZZYYSCHTYTYYBHECXHYKGJPXHHYZJFXHWHBDZFYZBCAPNPGNYDMSXHMMMMAMYNBYJTMPXYYMCTHJBZYFCGTYHWPHFTWZZEZSBZEGPFMTSKFTYCMHFLLHGPZJXZJGZJYXZSBBQSCZZLZCCSTPGXMJSFTCCZJZDJXCYBZLFCJSYZFGSZLYBCWZZBYZDZYPSWYJZXZBDSYUXLZZBZFYGCZXBZHZFTPBGZGEJBSTGKDMFHYZZJHZLLZZGJQZLSFDJSSCBZGPDLFZFZSZYZYZSYGCXSNXXCHCZXTZZLJFZGQSQYXZJQDCCZTQCDXZJYQJQCHXZTDLGSCXZSYQJQTZWLQDQZTQCHQQJZYEZZZPB"
	set str3 = "WKDJFCJPZTYPQYQTTYNLMBDKTJZPQZQZZFPZSBNJLGYJD"
	set str4 = "XJDZZKZGQKXDLPZJTCJDQBXDJQJSTCKNXBXZMSLYJCQMTJQWWCJQNJNLLLHJCWQTBZQYDZCZPZZDZYDDCYZZZCCJTTJFZDPRRTZTJDCQTQZDTJNPLZBCLLCTZSXKJZQZPZLBZRBTJDCXFCZDBCCJJLTQQPLDCGZDBBZJCQDCJWYNLLZYZCCDWLLXWZLXRXNTQQCZXKQLSGDFQTDDGLRLAJJTKUYMKQLLTZYTDYYCZGJWYXDXFRSKSTQTENQMRKQZHHQKDLDAZFKYPBGGPZREBZZYKZZSPEGJXGYKQZZZSLYSYYYZWFQZYLZZLZHWCHKYPQGNPGBLPLRRJYXCCSYYHSFZFYBZYYTGZXYLXCZWXXZJZBLFFLGSKHYJZEYJHLPLLLLCZGXDRZELRHGKLZZYHZLYQSZZJZQLJZFLNBHGWLCZCFJYSPYXZLZLXGCCPZBLLCYBBBBUBBCBPCRNNZCZYRBFSRLDCGQYYQXYGMQZWTZYTYJXYFWTEHZZJYWLCCNTZYJJZDEDPZDZTSYQJHDYMBJNYJZLXTSSTPHNDJXXBYXQTZQDDTJTDYYTGWSCSZQFLSHLGLBCZPHDLYZJYCKWTYTYLBNYTSDSYCCTYSZYYEBHEXHQDTWNYGYCLXTSZYSTQMYGZAZCCSZZDSLZCLZRQXYYELJSBYMXSXZTEMBBLLYYLLYTDQYSHYMRQWKFKBFXNXSBYCHXBWJYHTQBPBSBWDZYLKGZSKYHXQZJXHXJXGNLJKZLYYCDXLFYFGHLJGJYBXQLYBXQPQGZTZPLNCYPXDJYQYDYMRBESJYYHKXXSTMXRCZZYWXYQYBMCLLYZHQYZWQXDBXBZWZMSLPDMYSKFMZKLZCYQYCZLQXFZZYDQZPZYGYJYZMZXDZFYFYTTQTZHGSPCZMLCCYTZXJCYTJMKSLPZHYSNZLLYTPZCTZZCKTXDHXXTQCYFKSMQCCYYAZHTJPCYLZLYJBJXTPNYLJYYNRXSYLMMNXJSMYBCSYSYLZYLXJJQYLDZLPQBFZZBLFNDXQKCZFYWHGQMRDSXYCYTXNQQJZYYPFZXDYZFPRXEJDGYQBXRCNFYYQPGHYJDYZXGRHTKYLNWDZNTSMPKLBTHBPYSZBZTJZSZZJTYYXZPHSSZZBZCZPTQFZMYFLYPYBBJQXZMXXDJMTSYSKKBJZXHJCKLPSMKYJZCXTMLJYXRZZQSLXXQPYZXMKYXXXJCLJPRMYYGADYSKQLSNDHYZKQXZYZTCGHZTLMLWZYBWSYCTBHJHJFCWZTXWYTKZLXQSHLYJZJXTMPLPYCGLTBZZTLZJCYJGDTCLKLPLLQPJMZPAPXYZLKKTKDZCZZBNZDYDYQZJYJGMCTXLTGXSZLMLHBGLKFWNWZHDXUHLFMKYSLGXDTWWFRJEJZTZHYDXYKSHWFZCQSHKTMQQHTZHYMJDJSKHXZJZBZZXYMPAGQMSTPXLSKLZYNWRTSQLSZBPSPSGZWYHTLKSSSWHZZLYYTNXJGMJSZSUFWNLSOZTXGXLSAMMLBWLDSZYLAKQCQCTMYCFJBSLXCLZZCLXXKSBZQCLHJPSQPLSXXCKSLNHPSFQQYTXYJZLQLDXZQJZDYYDJNZPTUZDSKJFSLJHYLZSQZLBTXYDGTQFDBYAZXDZHZJNHHQBYKNXJJQCZMLLJZKSPLDYCLBBLXKLELXJLBQYCXJXGCNLCQPLZLZYJTZLJGYZDZPLTQCSXFDMNYCXGBTJDCZNBGBQYQJWGKFHTNPYQZQGBKPBBYZMTJDYTBLSQMPSXTBNPDXKLEMYYCJYNZCTLDYKZZXDDXHQSHDGMZSJYCCTAYRZLPYLTLKXSLZCGGEXCLFXLKJRTLQJAQZNCMBYDKKCXGLCZJZXJHPTDJJMZQYKQSECQZDSHHADMLZFMMZBGNTJNNLGBYJBRBTMLBYJDZXLCJLPLDLPCQDHLXZLYCBLCXZZJADJLNZMMSSSMYBHBSQKBHRSXXJMXSDZNZPXLGBRHWGGFCXGMSKLLTSJYYCQLTSKYWYYHYWXBXQYWPYWYKQLSQPTNTKHQCWDQKTWPXXHCPTHTWUMSSYHBWCRWXHJMKMZNGWTMLKFGHKJYLSYYCXWHYECLQHKQHTTQKHFZLDXQWYZYYDESBPKYRZPJFYYZJCEQDZZDLATZBBFJLLCXDLMJSSXEGYGSJQXCWBXSSZPDYZCXDNYXPPZYDLYJCZPLTXLSXYZYRXCYYYDYLWWNZSAHJSYQYHGYWWAXTJZDAXYSRLTDPSSYYFNEJDXYZHLXLLLZQZSJNYQYQQXYJGHZGZCYJCHZLYCDSHWSHJZYJXCLLNXZJJYYXNFXMWFPYLCYLLABWDDHWDXJMCXZTZPMLQZHSFHZYNZTLLDYWLSLXHYMMYLMBWWKYXYADTXYLLDJPYBPWUXJMWMLLSAFDLLYFLBHHHBQQLTZJCQJLDJTFFKMMMBYTHYGDCQRDDWRQJXNBYSNWZDBYYTBJHPYBYTTJXAAHGQDQTMYSTQXKBTZPKJLZRBEQQSSMJJBDJOTGTBXPGBKTLHQXJJJCTHXQDWJLWRFWQGWSHCKRYSWGFTGYGBXSDWDWRFHWYTJJXXXJYZYSLPYYYPAYXHYDQKXSHXYXGSKQHYWFDDDPPLCJLQQEEWXKSYYKDYPLTJTHKJLTCYYHHJTTPLTZZCDLTHQKZXQYSTEEYWYYZYXXYYSTTJKLLPZMCYHQGXYHSRMBXPLLNQYDQHXSXXWGDQBSHYLLPJJJTHYJKYPPTHYYKTYEZYENMDSHLCRPQFDGFXZPSFTLJXXJBSWYYSKSFLXLPPLBBBLBSFXFYZBSJSSYLPBBFFFFSSCJDSTZSXZRYYSYFFSYZYZBJTBCTSBSDHRTJJBYTCXYJEYLXCBNEBJDSYXYKGSJZBXBYTFZWGENYHHTHZHHXFWGCSTBGXKLSXYWMTMBYXJSTZSCDYQRCYTWXZFHMYMCXLZNSDJTTTXRYCFYJSBSDYERXJLJXBBDEYNJGHXGCKGSCYMBLXJMSZNSKGXFBNBPTHFJAAFXYXFPXMYPQDTZCXZZPXRSYWZDLYBBKTYQPQJPZYPZJZNJPZJLZZFYSBTTSLMPTZRTDXQSJEHBZYLZDHLJSQMLHTXTJECXSLZZSPKTLZKQQYFSYGYWPCPQFHQHYTQXZKRSGTTSQCZLPTXCDYYZXSQZSLXLZMYCPCQBZYXHBSXLZDLTCDXTYLZJYYZPZYZLTXJSJXHLPMYTXCQRBLZSSFJZZTNJYTXMYJHLHPPLCYXQJQQKZZSCPZKSWALQSBLCCZJSXGWWWYGYKTJBBZTDKHXHKGTGPBKQYSLPXPJCKBMLLXDZSTBKLGGQKQLSBKKTFXRMDKBFTPZFRTBBRFERQGXYJPZSSTLBZTPSZQZSJDHLJQLZBPMSMMSXLQQNHKNBLRDDNXXDHDDJCYYGYLXGZLXSYGMQQGKHBPMXYXLYTQWLWGCPBMQXCYZYDRJBHTDJYHQSHTMJSBYPLWHLZFFNYPMHXXHPLTBQPFBJWQDBYGPNZTPFZJGSDDTQSHZEAWZZYLLTYYBWJKXXGHLFKXDJTMSZSQYNZGGSWQSPHTLSSKMCLZXYSZQZXNCJDQGZDLFNYKLJCJLLZLMZZNHYDSSHTHZZLZZBBHQZWWYCRZHLYQQJBEYFXXXWHSRXWQHWPSLMSSKZTTYGYQQWRSLALHMJTQJSMXQBJJZJXZYZKXBYQXBJXSHZTSFJLXMXZXFGHKZSZGGYLCLSARJYHSLLLMZXELGLXYDJYTLFBHBPNLYZFBBHPTGJKWETZHKJJXZXXGLLJLSTGSHJJYQLQZFKCGNNDJSSZFDBCTWWSEQFHQJBSAQTGYPQLBXBMMYWXGSLZHGLZGQYFLZBYFZJFRYSFMBYZHQGFWZSYFYJJPHZBYYZFFWODGRLMFTWLBZGYCQXCDJYGZYYYYTYTYDWEGAZYHXJLZYYHLRMGRXXZCLHNELJJTJTPWJYBJJBXJJTJTEEKHWSLJPLPSFYZPQQBDLQJJTYYQLYZKDKSQJYYQZLDQTGJQYZJSUCMRYQTHTEJMFCTYHYPKMHYZWJDQFHYYXWSHCTXRLJHQXHCCYYYJLTKTTYTMXGTCJTZAYYOCZLYLBSZYWJYTSJYHBYSHFJLYGJXXTMZYYLTXXYPZLXYJZYZYYPNHMYMDYYLBLHLSYYQQLLNJJYMSOYQBZGDLYXYLCQYXTSZEGXHZGLHWBLJHEYXTWQMAKBPQCGYSHHEGQCMWYYWLJYJHYYZLLJJYLHZYHMGSLJLJXCJJYCLYCJPCPZJZJMMYLCQLNQLJQJSXYJMLSZLJQLYCMMHCFMMFPQQMFYLQMCFFQMMMMHMZNFHHJGTTHHKHSLNCHHYQDXTMMQDCYZYXYQMYQYLTDCYYYZAZZCYMZYDLZFFFMMYCQZWZZMABTBYZTDMNZZGGDFTYPCGQYTTSSFFWFDTZQSSYSTWXJHXYTSXXYLBYQHWWKXHZXWZNNZZJZJJQJCCCHYYXBZXZCYZTLLCQXYNJYCYYCYNZZQYYYEWYCZDCJYCCHYJLBTZYYCQWMPWPYMLGKDLDLGKQQBGYCHJXY"
	set str = str1_str2_str3_str4
	set SpellStr = ""
	for j=1:1:$l(Chinese) Do
	.Set CurrentWord = $e(Chinese,j),CurrentSpell = $e(str,$ascii(CurrentWord)-19967)
	.If CurrentSpell="" Set CurrentSpell = $zcvt(CurrentWord,"U")
	.If j=1 Set SpellStr = CurrentSpell
	.Else  set SpellStr = SpellStr_CurrentSpell
	Quit SpellStr
}

/// w ##class(DHCHAI.Utils.CommonSrv).Split("code^desc^13.5","^")
/// w ##class(DHCHAI.Utils.CommonSrv).Split("abacad","a")
/// 把一个字符串分割 回传一个数组
ClassMethod Split(instr As %String, separator As %String) As %String
{
	New (instr,separator)
	s myary(1)=""
	s mylen=$l(instr,separator)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,separator, myIdx)
	}
	q myary
}

/// 传入一个数组  返回一个字符串
/// w ##class(DHCHAI.Utils.CommonSrv).Join(.myary,"^")
ClassMethod Join(instrarray As %String, separator As %String) As %String
{
	New (instrarray,separator)
	s mystr=""
	s myIdx=""
	s myIdx=$o(instrarray(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(instrarray(myIdx))=""){
			s myrepstr=instrarray(myIdx)
		}else{
			s myrepstr=instrarray(myIdx)_separator
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(instrarray(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

/// w ##class(DHCHAI.Utils.CommonSrv).GetEpisodeID(4939742)
ClassMethod GetEpisodeID(argMRAdm As %String) As %String
{
	New (argMRAdm)
	Set return=$p($g(^MR(+argMRAdm,"PRO",1)),"^",9)
	Quit return
}

/// w ##class(DHCHAI.Utils.CommonSrv).GetMRAdm(4939148)
ClassMethod GetMRAdm(argEpisodeID As %String) As %String
{
	New (argEpisodeID)
	Set return=$p($g(^PAADM(+argEpisodeID)),"^",61)
	Quit return
}

/// w ##class(DHCHAI.Utils.CommonSrv).MoveSpaceKey("    123456    ")
ClassMethod MoveSpaceKey(str As %String)
{
	New (str)
	Set return=""
	Quit:str="" return
	
	//去左空格
	Set len=0
	For indSK=1:1:$l(str) {
		Set key=$e(str,indSK)
		Quit:key'=" "
		Set len=len+1
	}
	Set str=$e(str,len+1,$l(str))
	
	//去右空格
	Set len=0
	For indSK=$l(str):-1:1 {
		Set key=$e(str,indSK)
		Quit:key'=" "
		Set len=len+1
	}
	Set str=$e(str,1,$l(str)-len)
	
	Set return=str
	Quit return
}

/// 判断类是否存在
/// w ##class(DHCHAI.Utils.CommonSrv).IsValidClassName("DHCHAI.Utils.CommonSrv")
ClassMethod IsValidClassName(classname As %Library.String) As %Library.Boolean
{
    
    n (classname)
    s $ZT="ClassErr"
    
    q:(classname="") 0
    
    s clsobj=##class(%Dictionary.CompiledClass).%OpenId(classname,0)
    s rtn=0
    i ($IsObject(clsobj)){
        s clsobj=""
        s rtn = 1
    }
    
    q rtn
ClassErr
   Quit 0
}

/// 判断类方法是否存在
/// w ##class(DHCHAI.Utils.CommonSrv).IsValidMethodName("MA.IPMR.SS.VolPaadm","GetPatObjByAdm")
ClassMethod IsValidMethodName(classname As %Library.String, methodname As %Library.String) As %Library.Boolean
{
    n (classname, methodname)
    s $ZT="MethodErr"
    q:(classname="") 0
    s clsobj=##class(%Dictionary.CompiledClass).%OpenId(classname,0)
    q:$IsObject(clsobj) 0
    q:(methodname="") 0
    
    s mthobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname,0)
   s rtn=0
    
    i ($IsObject(mthobj)){
        s mthobj=""
        s rtn = 1
    }
    q rtn
MethodErr
   Quit 0
}

/// 判断query方法是否存在
/// w ##class(DHCHAI.Utils.CommonSrv).IsValidQueryName("DHCHAI.IRS.EnviHyReportSrv","QryEnviPrintRepInfo")
ClassMethod IsValidQueryName(classname As %Library.String, queryname As %Library.String) As %Library.Boolean
{
    n (classname, queryname)
    s $ZT="QueryErr"
    
    q:(classname="") 0
    s clsobj=##class(%Dictionary.CompiledClass).%OpenId(classname,0)
    q:'$IsObject(clsobj) 0
    q:(queryname="") 0
    
    s qryobj=##class(%Dictionary.CompiledQuery).%OpenId(classname_"||"_queryname,0)
    s rtn=0
    
    i ($IsObject(qryobj)){
        s qryobj=""
        s rtn = 1
    }
    q rtn
QueryErr
   Quit 0
}

}

/// 名称: DHCMA.Util.IO.CommonSrv
/// 描述: 公共服务类
/// 编写者: mayanpeng
/// 编写日期: 2021-10-18
Class DHCMA.Util.IO.CommonSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2020-10-14
/// Description:  Query调用封装，避免变量冲突
/// Input：       aClassName:类名,aQueryName:Query名,aInputStr:调用Query的参数(多个)
/// Return：      %ArrayOfDataTypes
/// 			  第一行取值示例: return.GetAt(1).GetAt("ColumnName")
/// s a=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("DHCHAI.BTS.DictionarySrv","QryDictionary","2")
/// zw a.GetAt(1)
ClassMethod GetArrayOfQueryData(aClassName As %String, aQueryName As %String, aInputStr...) As %ArrayOfDataTypes
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
/// Input:		  url:完整的请求地址,type:请求方法(POST/GET),data:请求数据,contentType:请求类型,timeout:超时时间(秒)，默认30秒
/// Return：      Response	//如果返回中文乱码需请求后转码：$ZCVT(return,"I","UTF8")
/// w ##class(DHCMA.Util.IO.CommonSrv).SendHttpRequest("http://127.0.0.1:8085/user","POST","{""name"":""中文""}","application/json;charSet=utf-8")
ClassMethod SendHttpRequest(url As %String, type As %String, data As %String, contentType As %String = "", timeout As %String = "") As %String
{
	New (url,type,data,contentType,timeout)
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
    Set:(+timeout)'=0 httprequest.Timeout=+timeout
    
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
	// 是否中文转码
	If (contentType["charSet=utf-8")||(contentType["charSet=utf8") {
		Set return=$ZCVT(return,"I","UTF8")
	}
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2021-10-27
/// Description:  保存文件到FTP服务器
/// Input:		  url:完整的请求地址,type:请求方法(POST/GET),data:请求数据,contentType:请求类型,timeout:超时时间(秒)，默认30秒
/// Return：      Response	//如果返回中文乱码需请求后转码：$ZCVT(return,"I","UTF8")
/// w ##class(DHCMA.Util.IO.CommonSrv).SaveFileToFTPServer("http://127.0.0.1:8085/user","POST","{""name"":""中文""}","application/json;charSet=utf-8")
ClassMethod SaveFileToFTPServer(aFileName As %String, aFileStream As %CSP.BinaryStream, IP As %String, UserName As %String, Password As %String, Port As %String = "", DirPath As %String = "") As %String
{
	New (aFileName,aFileStream,IP,UserName,Password,Port,DirPath)
	Set return=0
	Quit:(aFileName="" || aFileStream="" || IP="" || UserName="" || Password="") return
	Set:Port="" Port=21
	//Set aFileStream.FileName = aFileName
	
	Set ftp=##class(%Net.FtpSession).%New()
	Do ftp.CommandTranslateTableSet("GB18030")
	If 'ftp.Connect(IP,UserName,Password,+Port) q "-1^"_ftp.ReturnMessage
	If 'ftp.Binary() q "-2^"_ftp.ReturnMessage
	
	If DirPath'="" {
		Set DirPath = ##class(ext.util.String).Replace(DirPath,"//","/")
		If DirPath["/" Set DirLen = $l(DirPath,"/"),sep="/"
		If DirPath["\" Set DirLen = $l(DirPath,"\"),sep="\"
		For i=1:1:DirLen {
			Set CurrentDir = $p(DirPath,sep,i)
			If $l(CurrentDir)>0 {
				If ftp.SetDirectory(CurrentDir){
				}Else{
					Set MakeDir = ftp.MakeDirectory(CurrentDir)
					Set cdFlag = ftp.SetDirectory(CurrentDir)
				}
			}
		}
	}
	If 'ftp.Store(aFileName,aFileStream) q "-3^"_ftp.ReturnMessage
	If 'ftp.Logout() Quit "-4^"_ftp.ReturnMessage
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2021-12-14
/// Description:  保存Base64图片到服务器文件
/// Input:		  Sgc {%Stream.GlobalCharacter || String} 可以为字符流也可为字符串
/// 				  Path {String} 图片存储的服务器路径 d:\1.jpg
/// Return：      Response
/// w ##class(DHCMA.Util.IO.CommonSrv).Base642Img(Sgc,"d:1.jpg")
ClassMethod Base642Img(Sgc, Path As %String) As %Boolean
{
	New (Sgc,Path)
	Set return=0
	Quit:(Sgc="")||(Path="") return
	
	Set Path = ##Class(%File).NormalizeFilename(Path)
	Set img = ##class(%FileBinaryStream).%New()
	Set img.Filename = $g(Path)
	If ($IsObject(Sgc)) {	;Sgc字符流
		Do Sgc.Rewind()
		while ('Sgc.AtEnd){
			Set baseStr = Sgc.Read(16814) ;不能用16k
			Set byteList = ##class(%SYSTEM.Encryption).Base64Decode(baseStr)
			Do img.Write(byteList)
		}
	} Else {	;Sgc字符串
		Set byteList = ##class(%SYSTEM.Encryption).Base64Decode(Sgc)
		Do img.Write(byteList)
	}
	Do img.SaveStream()
	Do img.%Close()
	Set img = ""
	Set return=1
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2023-01-16
/// Description:  服务器文件转换为Base64图片字符串(前台显示需自行拼接data:image/png;base64,)
/// Input:		  Path {String} 图片存储的服务器路径 d:\1.jpg
/// 			  IsWholePath 是否完整路径
/// Return：      Response
/// w ##class(DHCMA.Util.IO.CommonSrv).Img2Base64("/scripts/DHCMA/img/cancel.png","0")
ClassMethod Img2Base64(Path As %String, IsWholePath As %String = 1) As %String
{
    New (Path,IsWholePath)
	Set return=""
	Quit:Path="" return
	If (IsWholePath="0") {
		Set Filename="",FolderPath=""
		If Path["/" {
			Set Filename=$p(Path,"/",$Length(Path,"/"))
		} ElseIf Path["\" {
			Set Filename=$p(Path,"\",$Length(Path,"\"))
		}
		Set FolderPath=$Replace(Path,Filename,"",1,1)
		Set PhysicalPath = ##class(ext.util.String).GetPhysicalPath("",FolderPath)
		Set Path = PhysicalPath_Filename
	}
    Set Path = ##Class(%File).NormalizeFilename(Path)
    throw:('##class(%File).Exists(Path)) ##class(%Exception.SystemException).%New("文件不存在")
    Set img = ##class(%FileBinaryStream).%New()
    Set img.Filename = $g(Path)
    Set byteList = img.Read(12288)
    While(byteList'=""){
        Set baseStr = ##class(%SYSTEM.Encryption).Base64Encode(byteList)
        Set return=return_baseStr
        Set byteList = ""
        Set byteList = img.Read(12288)
    }
    Do img.%Close()
    Quit return
}

/// week		获取周 开始结束日期
/// month		获取月 开始结束日期
/// quarter		获取季度 开始结束日期
/// year		获取年 开始结束日期
/// last12month	获取近一年开始截止日期（不算当月）
/// PS:如果有传参日期 则取传入日期的对应维度的开始结束日期
/// w ##class(DHCMA.Util.IO.CommonSrv).GetCurDimSEDate("last12month")
ClassMethod GetCurDimSEDate(aDimens As %String, aDate As %String = "") As %String
{
	new (aDimens,aDate)
	Set aDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aDate="" aDate=+$h
	Set return=""
	Quit:aDimens="" return
	Set FormatDate=$zd(aDate,3)
	//获取当前年 月 季度 周
	Set year	= $p(FormatDate,"-",1)
	set month	= $p(FormatDate,"-",2)
	Set weekday	= $zd(aDate,10)
	Set (startdate,enddate)=""
	If (aDimens="week") {
		Set startdate=aDate-weekday+1
		Set enddate=startdate+6
	}elseif (aDimens="month") {
		Set tstartdate=year_"-"_month_"-01"
		Set startdate=$zdh(tstartdate,3)
		Set enddate=..GetMonthLastDay(tstartdate)
	}elseif (aDimens="quarter") {
		Set quarter=$s(month<4:1,month<7:2,month<10:3,1:"4") 
		Set tstartdate=$s(quarter=1:year_"-01-01",quarter=2:year_"-04-01",quarter=3:year_"-07-01",quarter=4:year_"-10-01")
		Set tenddate=$s(quarter=1:year_"-03-31",quarter=2:year_"-04-30",quarter=3:year_"-07-31",quarter=4:year_"-12-31")
		Set startdate=$zdh(tstartdate,3)
		Set enddate=$zdh(tenddate,3)
	}elseif (aDimens="year") {
		Set tstartdate=year_"-01-01"
		Set tenddate=year_"-12-31"
		Set startdate=$zdh(tstartdate,3)
		Set enddate=$zdh(tenddate,3)
	}elseif (aDimens="last12month"){
		Set month=month-1
		Set:month=0 month=12
		Set:month<10 month="0"_month
		Set lastyear=year-1
		Set tstartdate=lastyear_"-"_month_"-01"
		Set startdate=$zdh(tstartdate,3)
		Set enddate=..GetMonthLastDay(year_"-"_month_"-01")
	}
	Set:enddate>+$h enddate=+$h
	Set:enddate'="" return=startdate_"^"_enddate
	Quit return
}

/// 获取月份最后一天
/// w ##class(DHCMA.Util.IO.CommonSrv).GetMonthLastDay("")
ClassMethod GetMonthLastDay(aDate As %String = "") As %String
{
	new (aDate)
	Set aDate=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aDate="" aDate=+$h
	Set FormatDate=$zd(aDate,3)
	//获取年 月
	Set year	= $p(FormatDate,"-",1)
	set month	= $p(FormatDate,"-",2)
	Set tstartdate=year_"-"_month_"-01"
	Set startdate=$zdh(tstartdate,3)
	Set tdate=startdate+32
	Set formattdate=$zd(tdate,3)
	Set tdate=$e(formattdate,1,7)_"-01"
	set lastmonthdate=$zdh(tdate,3)-1
	Quit lastmonthdate
}

/// 清除输入字符串中的常见特殊字符
/// w ##class(DHCMA.Util.IO.CommonSrv).CleanSpecialChar("质控科.")
ClassMethod CleanSpecialChar(inputStr) As %String
{
	new (inputStr)
	;chr(9)  是制表符
	;chr(10) 是个换行符
	;chr(13) 是一个回车
	;chr(34) 双引号    
	;chr(39) 单引号    
	;chr(47) /  作废该特殊字符  形如：12/03/2022日期格式替换有问题
	;chr(92) \
	Set inputStr=$tr(inputStr,$char(9),"")
	Set inputStr=$tr(inputStr,$char(10),"")
	Set inputStr=$tr(inputStr,$char(13),"")
	Set inputStr=$tr(inputStr,$char(34),"")
	Set inputStr=$tr(inputStr,$char(39),"")
	Set inputStr=$tr(inputStr,$char(92),"")
	Quit inputStr
}

/// Creator     : mayanpeng
/// CreateDate  : 2020-07-16
/// Description : 获取随机字符串/随机数
/// Input:		 aLength:生成长度, aType:1、字符串 2、纯数字
/// w ##class(DHCMA.Util.IO.CommonSrv).GetRandom(5,1)
ClassMethod GetRandom(aLength As %Integer, aType As %String = "1") As %String
{
	New (aLength,aType)
	Set RandByte=##class(%SYSTEM.Encryption).GenCryptRand(aLength,1)
	Set HEX=..ByteToHex(RandByte)
	If aType=1 {
		Set Ciphertext=$e(HEX,1,aLength)
	} Else {
		Set Ciphertext=$e($ZHEX(HEX),1,aLength)
	}
	Quit Ciphertext
}

/// Creator     : mayanpeng
/// CreateDate  : 2020-07-16
/// Description : 获取当前Unix时间戳
/// Input		: aMillisecond是否携带毫秒
/// w ##class(DHCMA.Util.IO.CommonSrv).GetUNIXTimeStamp(1)
ClassMethod GetUNIXTimeStamp(aMillisecond As %Integer = 0) As %Integer
{
	New (aMillisecond)
	Set return=""
	Set TimeStamp = $ZTIMESTAMP	//毫秒级内部时间戳(UTC)
	
	Set date = $p(TimeStamp,",",1)		//日期
	Set tmpTime = $e(TimeStamp,$l(date)+2,$l(TimeStamp))
	Set tmpTime = $FN(tmpTime,"",3)		//毫秒尾数为0时会隐藏
	Set time = $p(tmpTime,".",1)		//时间
	Set millisecond = $p(tmpTime,".",2)	//毫秒
	//转时区(UTC+8)
	Set time = time + (8*3600)
	If (time > 86400) {
		Set date = date + 1
		Set time = time - 86400
	}
	//Unix时间戳是从1970-01-01开始，M时间从1841-01-01
	Set Difference = 4070937600		//固定时间差
	Set return = (date*24*3600) + time - Difference
	Set:aMillisecond=1 return=return_millisecond
	Quit return
}

/// Creator     : mayanpeng
/// CreateDate  : 2022-06-01
/// Description : 自动补零
/// Input		: aInput输入值, aLength需要输出的总长度
/// w ##Class(DHCMA.Util.IO.CommonSrv).ZeroFilling(12,5)
ClassMethod ZeroFilling(aInput As %String, aLength As %String) As %String
{
	New (aInput,aLength)
	Set return=""
	Quit:(aInput="")||(aLength="") return
	Set $p(return,"0",aLength-$l(aInput)+1)=aInput
	Quit return
}

/// Creator     : mayanpeng
/// CreateDate  : 2020-07-16
/// Description : 对Url进行ASCII码字典序排序
/// Input		: aUrl:&分隔的参数串
/// w ##class(DHCMA.Util.IO.CommonSrv).GetUrlSort("")
ClassMethod GetUrlSort(aUrl As %String) As %String
{
	New (aUrl)
	Set return=""
	Quit:aUrl="" return
	Quit:$l(aUrl,"&")<=1 aUrl
	
	Kill arrRes
	For xIndex=1:1:$l(aUrl,"&") {
		Set xUrl = $p(aUrl,"&",xIndex)
		Continue:xUrl=""
		Set xParam = $p(xUrl,"=",1)
		Set xValue = $p(xUrl,"=",2)
		Set arrRes(xParam) = $g(xValue)
	}
	Quit:'$d(arrRes) return
	
	Set xxParam=""
	For {
		Set xxParam = $o(arrRes(xxParam))
		Quit:xxParam=""
		
		Set xxValue = arrRes(xxParam)
		Set return=return_"&"_xxParam_"="_xxValue
	}
	Set:return'="" return = $e(return,2,$l(return))
	Quit return
}

/// jiangpengpeng
/// 二进制转十六进制
/// w ##class(DHCMA.Util.IO.CommonSrv).ByteToHex(a)
ClassMethod ByteToHex(val)
{
	New (val)
	s ret = ""
	For i=1:1:$l(val) {
		Set Ascii=$a($e(val,i))
		If (Ascii<16) {
			Set ret=ret_"0"_$zh(Ascii)
		} Else {
			Set ret=ret_$zh(Ascii)
		}
	}
	Quit ret
}

/// list去重
/// zw ##class(DHCMA.Util.IO.CommonSrv).RmvDupItemToList($lb("a","b","a","aa","","c","d"),1)
ClassMethod RmvDupItemToList(aList As %List, aIsRmvNull As %String = 0) As %List
{
	New (aList,aIsRmvNull)
	Set return = ""
	Quit:aList="" return
	
	For index=1:1:$ll(aList){
		Set xItem = $li(aList,index)
		Continue:(aIsRmvNull=1)&&(xItem="")
		Set:$lf(return,xItem)<1 return=return_$lb(xItem) 	
	}
	Quit return
}

/// Creator：      	chenrui
/// CreatDate：    	2023-02-22
/// Description： 	获取某科某段时间内住院人数
/// Table/Global：  ^MRIPdaily("MRIPloc",{MRIP_loc_dr},"MRIPdate",{MRIP_date},{MRIP_rowid})
/// Input:			
/// Return：       	
/// w ##class(DHCMA.Util.IO.CommonSrv).GetZYRSByLocDate("2019-01-01","2019-12-01","","2")
ClassMethod GetZYRSByLocDate(aSttDate As %String, aEndDate As %String, aLocID As %String, aHospID As %String) As %String
{
	New (aSttDate,aEndDate,aLocID,aHospID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="") "-1"
	
	Set aSttDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aSttDate)
	Set aEndDate=##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	Quit:+aSttDate>+aEndDate "-2"
	// 当科室ID为空时，默认获取全院的住院人数
	if (aLocID=""){
		Set xLocID = ""
		For {
			Set xLocID = $o(^CTLOC(xLocID))	
			Continue:xLocID=0
			Quit:xLocID=""
			// 过滤非住院科室
			Continue:'$d(^PAC("ADMLOC",0,"AdmType","I",xLocID))
			Continue:'$d(^MRIPdaily("MRIPloc",xLocID))
			// 增加医院过滤
			Set HospID=$p(^CTLOC(xLocID),"^",22)
			Continue:(aHospID'="")&(aHospID'[HospID)
			For xDate=aSttDate:1:aEndDate {
				Set xMRID=0
				For {
					Set xMRID=$o(^MRIPdaily("MRIPloc",xLocID,"MRIPdate",xDate,xMRID))
					Quit:xMRID=""
					Set InHospNum=$p(^MRIPdaily(xMRID),"^",18)  // 住院人数
					Continue:InHospNum=""
					
					Set return=return+InHospNum
				}	
			}
		}
	}else{
		For xDate=aSttDate:1:aEndDate {
			Set xMRID=0
			For {
				Set xMRID=$o(^MRIPdaily("MRIPloc",+aLocID,"MRIPdate",xDate,xMRID))
				Quit:xMRID=""
				Set InHospNum=$p(^MRIPdaily(xMRID),"^",18)  // 住院人数
				Set return=return+InHospNum
			}	
		}
	}
	Quit return
}

}

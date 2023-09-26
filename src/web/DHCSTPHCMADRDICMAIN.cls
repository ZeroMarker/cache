Import SQLUser

/// Creator: bianshuai
/// CreateDate: 2014-10-21
/// Descript: 不良反应字典维护类
Class web.DHCSTPHCMADRDICMAIN Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:保存[不良反应/事件名称]
/// w ##class(web.DHCSTPHCMADRDICMAIN).SaveUpdAdrEvent("^SDFASDF^ASD")
ClassMethod SaveAdrEvent(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrEvent(TmpStr)
	.e  d
	..s ret=..InsAdrEvent(TmpStr)
	q 0
}

/// Descript:更新[不良反应/事件名称]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrEvent("^SDFASDF^ASD")
ClassMethod UpdAdrEvent(DataList As %String) As %String
{
	N (DataList)
	S AdrEventID=$p(DataList,"^",1)
	S AdrEventCode=$p(DataList,"^",2)
	S AdrEventDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHAdrEvent Set ADRE_Code=:AdrEventCode,ADRE_Desc=:AdrEventDesc WHERE ADRE_RowID=:AdrEventID)
 	Q SQLCODE
}

/// Descript:增加[不良反应/事件名称]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrEvent("^SDFASDF^ASD")
ClassMethod InsAdrEvent(DataList As %String) As %String
{
	N (DataList)
	S AdrEventCode=$p(DataList,"^",2)
	S AdrEventDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHAdrEvent(ADRE_Code,ADRE_Desc) VALUES(:AdrEventCode,:AdrEventDesc))
 	Q SQLCODE
}

/// Descript:删除[不良反应/事件名称]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrEvent("1")
ClassMethod DelAdrEvent(AdrEventID As %String) As %String
{
	N (AdrEventID)
	&SQL(Delete From DHC_PHAdrEvent Where ADRE_RowID=:AdrEventID)
	Q SQLCODE
}

/// Descript:查询[不良反应/事件名称]
/// Table:DHC_PHAdrEvent
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrEvent("12","1","")
ClassMethod QueryAdrEvent(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s adrEventCode=$p(params,"^",1)
    s adrEventDesc=$p(params,"^",2)
	s h=0,count=0
	s ID="0"
	f  s ID=$o(^DHCPHADRE(ID)) q:ID=""  d
	.s Code=$p(^DHCPHADRE(ID),"^",1) //代码
	.s Desc=$p(^DHCPHADRE(ID),"^",2) //描述
	.q:(adrEventCode'="")&(Code'[adrEventCode)
	.q:(adrEventDesc'="")&(Desc'[adrEventDesc)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).SaveAdrPatImpoInfo("^SDFASDF^ASD")
ClassMethod SaveAdrPatImpoInfo(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrPatImpoInfo(TmpStr)
	.e  d
	..s ret=..InsAdrPatImpoInfo(TmpStr)
	q 0
}

/// Descript:更新[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrPatImpoInfo("^SDFASDF^ASD")
ClassMethod UpdAdrPatImpoInfo(DataList As %String) As %String
{
	N (DataList)
	S AdrIIID=$p(DataList,"^",1)
	S AdrIICode=$p(DataList,"^",2)
	S AdrIIDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHAdrPatImpoInfo Set ADRII_Code=:AdrIICode,ADRII_Desc=:AdrIIDesc WHERE ADRII_RowID=:AdrIIID)
 	Q SQLCODE
}

/// Descript:增加[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrPatImpoInfo("^SDFASDF^ASD")
ClassMethod InsAdrPatImpoInfo(DataList As %String) As %String
{
	N (DataList)
	S AdrIICode=$p(DataList,"^",2)
	S AdrIIDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHAdrPatImpoInfo(ADRII_Code,ADRII_Desc) VALUES(:AdrIICode,:AdrIIDesc))
 	Q SQLCODE
}

/// Descript:删除[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrPatImpoInfo("1")
ClassMethod DelAdrPatImpoInfo(AdrIIID As %String) As %String
{
	N (AdrIIID)
	&SQL(Delete From DHC_PHAdrPatImpoInfo Where ADRII_RowID=:AdrIIID)
	Q SQLCODE
}

/// Descript:查询[患者相关重要信息]
/// Table:DHC_PHAdrPatImpoInfo
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrPatImpoInfo("12","1","")
ClassMethod QueryAdrPatImpoInfo(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s adrPIICode=$p(params,"^",1)
    s adrPIIDesc=$p(params,"^",2)
	s h=0,count=0
	s ID="0"
	f  s ID=$o(^DHCPHADRII(ID)) q:ID=""  d
	.s Code=$p(^DHCPHADRII(ID),"^",1) //代码
	.s Desc=$p(^DHCPHADRII(ID),"^",2) //描述
	.q:(adrPIICode'="")&(Code'[adrPIICode)
	.q:(adrPIIDesc'="")&(Desc'[adrPIIDesc)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrPatImpoInfo",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrPatImpoInfo",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrPatImpoInfo",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN)SaveAdrReasonForMed("^SDFASDF^ASD")
ClassMethod SaveAdrReasonForMed(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrReasonForMed(TmpStr)
	.e  d
	..s ret=..InsAdrReasonForMed(TmpStr)
	q 0
}

/// Descript:更新[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrReasonForMed("^SDFASDF^ASD")
ClassMethod UpdAdrReasonForMed(DataList As %String) As %String
{
	N (DataList)
	S AdrRMID=$p(DataList,"^",1)
	S AdrRMCode=$p(DataList,"^",2)
	S AdrRMDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHAdrReasonForMed Set ADRRM_Code=:AdrRMCode,ADRRM_Desc=:AdrRMDesc WHERE ADRRM_RowID=:AdrRMID)
 	Q SQLCODE
}

/// Descript:增加[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrReasonForMed("^SDFASDF^ASD")
ClassMethod InsAdrReasonForMed(DataList As %String) As %String
{
	N (DataList)
	S AdrRMCode=$p(DataList,"^",2)
	S AdrRMDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHAdrReasonForMed(ADRRM_Code,ADRRM_Desc) VALUES(:AdrRMCode,:AdrRMDesc))
 	Q SQLCODE
}

/// Descript:删除[患者相关重要信息]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrReasonForMed("1")
ClassMethod DelAdrReasonForMed(AdrRMID As %String) As %String
{
	N (AdrRMID)
	&SQL(Delete From DHC_PHAdrReasonForMed Where ADRRM_RowID=:AdrRMID)
	Q SQLCODE
}

/// Descript:查询[患者相关重要信息]
/// Table:DHC_PHAdrReasonForMed
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrReasonForMed("12","1","")
ClassMethod QueryAdrReasonForMed(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start=(page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s adrRMCode=$p(params,"^",1)
    s adrRMDesc=$p(params,"^",2)
	s h=0,count=0
	s ID=""
	f  s ID=$o(^DHCPHADRRM(ID)) q:ID=""  d
	.s Code=$p(^DHCPHADRRM(ID),"^",1) //代码
	.s Desc=$p(^DHCPHADRRM(ID),"^",2) //描述
	.q:(adrRMCode'="")&(Code'[adrRMCode)
	.q:(adrRMDesc'="")&(Desc'[adrRMDesc)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrReasonForMed",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrReasonForMed",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrReasonForMed",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存[填报意愿]
/// w ##class(web.DHCSTPHCMADRDICMAIN).SaveAdrWishes("^SDFASDF^ASD")
ClassMethod SaveAdrWishes(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrWishes(TmpStr)
	.e  d
	..s ret=..InsAdrWishes(TmpStr)
	q 0
}

/// Descript:更新[填报意愿]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrWishes("^SDFASDF^ASD")
ClassMethod UpdAdrWishes(DataList As %String) As %String
{
	N (DataList)
	S AdrWID=$p(DataList,"^",1)
	S AdrWCode=$p(DataList,"^",2)
	S AdrWDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHAdrWishes Set ADRW_Code=:AdrWCode,ADRW_Desc=:AdrWDesc WHERE ADRW_RowID=:AdrWID)
 	Q SQLCODE
}

/// Descript:增加[填报意愿]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrWishes("^SDFASDF^ASD")
ClassMethod InsAdrWishes(DataList As %String) As %String
{
	N (DataList)
	S AdrWCode=$p(DataList,"^",2)
	S AdrWDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHAdrWishes(ADRW_Code,ADRW_Desc) VALUES(:AdrWCode,:AdrWDesc))
 	Q SQLCODE
}

/// Descript:删除[填报意愿]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrReasonForMed("1")
ClassMethod DelAdrWishes(AdrWID As %String) As %String
{
	N (AdrWID)
	&SQL(Delete From DHC_PHAdrWishes Where ADRW_RowID=:AdrWID)
	Q SQLCODE
}

/// Descript:查询[填报意愿]
/// Table:DHC_PHAdrReasonForMed
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrWishes("12","1","")
ClassMethod QueryAdrWishes(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start = (page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s adrWCode=$p(params,"^",1)
    s adrWDesc=$p(params,"^",2)
	s h=0,count=0
	s ID=""
	f  s ID=$o(^DHCPHADRW(ID)) q:ID=""  d
	.s Code=$p(^DHCPHADRW(ID),"^",1) //代码
	.s Desc=$p(^DHCPHADRW(ID),"^",2) //描述
	.q:(adrWCode'="")&(Code'[adrWCode)
	.q:(adrWDesc'="")&(Desc'[adrWDesc)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrWishes",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrWishes",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrWishes",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存[不良反应报告状态]
/// w ##class(web.DHCSTPHCMADRDICMAIN).SaveAdrStatus("^SDFASDF^ASD")
ClassMethod SaveAdrStatus(DataList As %String) As %String
{
	n (DataList)
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrStatus(TmpStr)
	.e  d
	..s ret=..InsAdrStatus(TmpStr)
	q 0
}

/// Descript:更新[不良反应报告状态]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrStatus("^SDFASDF^ASD")
ClassMethod UpdAdrStatus(DataList As %String) As %String
{
	N (DataList)
	S AdrSID=$p(DataList,"^",1)
	S AdrSCode=$p(DataList,"^",2)
	S AdrSDesc=$p(DataList,"^",3)
	&SQL(Update DHC_PHAdrStatus Set ADRS_Code=:AdrSCode,ADRS_Desc=:AdrSDesc WHERE ADRS_RowID=:AdrSID)
 	Q SQLCODE
}

/// Descript:增加[不良反应报告状态]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrStatus("^SDFASDF^ASD")
ClassMethod InsAdrStatus(DataList As %String) As %String
{
	N (DataList)
	S AdrSCode=$p(DataList,"^",2)
	S AdrSDesc=$p(DataList,"^",3)
 	&SQL(INSERT INTO DHC_PHAdrStatus(ADRS_Code,ADRS_Desc) VALUES(:AdrSCode,:AdrSDesc))
 	Q SQLCODE
}

/// Descript:删除[不良反应报告状态]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrStatus("1")
ClassMethod DelAdrStatus(AdrWID As %String) As %String
{
	N (AdrWID) 
	s tmp=0   
	s ID="0"                    //wangxuejian 2016,08,25 修改
	f  s ID=$o(^DHCPHADRP(ID)) q:ID=""  d
	.s ADRPStatusDR=$p(^DHCPHADRP(ID),"^",1)
	.s ADRPNextStatDR=$p(^DHCPHADRP(ID),"^",2)
	.i ((ADRPStatusDR=AdrWID)||(ADRPNextStatDR=AdrWID)) d 
	..s tmp=1
	i tmp=0 d
	. &SQL(Delete From DHC_PHAdrStatus Where ADRS_RowID=:AdrWID)
	q 0
	;Q:SQLCODE
}

/// Descript:查询[不良反应报告状态]
/// Table:DHC_PHAdrStatus
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrStatus("12","1","")
ClassMethod QueryAdrStatus(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start = (page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s adrSCode=$p(params,"^",1)
    s adrSDesc=$p(params,"^",2)
	s h=0,count=0
	s ID="0"
	f  s ID=$o(^DHCPHADRS(ID)) q:ID=""  d
	.s Code=$p(^DHCPHADRS(ID),"^",1) //代码
	.s Desc=$p(^DHCPHADRS(ID),"^",2) //描述
	.q:(adrSCode'="")&(Code'[adrSCode)
	.q:(adrSDesc'="")&(Desc'[adrSDesc)
	.s h=h+1
	.s TempStr=ID_"^"_Code_"^"_Desc
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatus",pid,h)=TempStr
	.;s ^TMP("a")=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^Code^Desc"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatus",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatus",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:保存[状态授权]
/// w ##class(web.DHCSTPHCMADRDICMAIN).SaveAdrStatus("^SDFASDF^ASD")
ClassMethod SaveAdrStatusGrant(adrStatusGrantDataList As %String) As %String
{
	n (adrStatusGrantDataList)
	s len=$L(adrStatusGrantDataList,"!!")
	f i=1:1:len d
	.s TmpStr=$p(adrStatusGrantDataList,"!!",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrStatusGrant(TmpStr)
	.e  d
	..s ret=..InsAdrStatusGrant(TmpStr)
	q 0
}

/// Descript:更新[状态授权]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrStatusGrant("^SDFASDF^ASD")
ClassMethod UpdAdrStatusGrant(adrStatGrantDataList As %String) As %String
{
	N (adrStatGrantDataList)                        //wangxuejian 2016-09-06
	s tmp=0
	S parref=$p(adrStatGrantDataList,"^",2)
	S type=$p(adrStatGrantDataList,"^",3)            
	S pointerID=$p(adrStatGrantDataList,"^",4)
	S AdrSgID=$p(adrStatGrantDataList,"^",1)
	s ADRSGRowID=""
 f  s ADRSGRowID=$o(^DHCPHADRS(0,"TypePointer",type,pointerID,ADRSGRowID)) q:ADRSGRowID=""  d
  .i ADRSGRowID=parref d
 .. s tmp=1
 i tmp'=1 d
	.&SQL(Update DHC_PHAdrStatusGrant Set ADRSG_Type=:type,ADRSG_Pointer=:pointerID WHERE ADRSG_RowID=:AdrSgID)
	
 	;Q SQLCODE
 	q tmp
}

/// Descript:增加[状态授权]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrStatusGrant("^SDFASDF^ASD")
ClassMethod InsAdrStatusGrant(adrStatGrantDataList As %String) As %String
{
	 N (adrStatGrantDataList)                      //wangxuejian 2016-09-06
 s tmp=0
 S parref=$p(adrStatGrantDataList,"^",2)
 S type=$p(adrStatGrantDataList,"^",3)
 S pointerID=$p(adrStatGrantDataList,"^",4)
 s ADRSGRowID=""
 f  s ADRSGRowID=$o(^DHCPHADRS(0,"TypePointer",type,pointerID,ADRSGRowID)) q:ADRSGRowID=""  d
 .;s ^T("1")=ADRSGRowID
 .i ADRSGRowID=parref d
 .. s tmp=1
 i tmp'=1 d
 .S childSub=$o(^DHCPHADRS(parref,"I",""),-1)+1
 .&SQL(INSERT INTO DHC_PHAdrStatusGrant(ADRSG_ADRS_Parref,ADRSG_ChildSub,ADRSG_Type,ADRSG_Pointer)
 		 VALUES(:parref,:childSub,:type,:pointerID))
 ;Q SQLCODE
 q tmp
}

/// Descript:删除[状态授权]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrStatusGrant("1")
ClassMethod DelAdrStatusGrant(AdrSgID As %String) As %String
{
	N (AdrSgID)
	&SQL(Delete From DHC_PHAdrStatusGrant Where ADRSG_RowID=:AdrSgID)
	Q SQLCODE
}

/// Descript:查询[状态授权]
/// Table:DDHC_PHAdrStatusGrant
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrStatusGrant()
ClassMethod QueryAdrStatusGrant(AdrSgID As %String) As %String
{
	N (AdrSgID)
	
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCPHADRS(AdrSgID,"I",CH)) q:CH=""  d
	.s Type=$p(^DHCPHADRS(AdrSgID,"I",CH),"^",1) //类型
	.s Pointer=$p(^DHCPHADRS(AdrSgID,"I",CH),"^",2) //指针
	.s TypeName=$S(Type="G":"安全组",Type="L":"科室",Type="U":"人员",1:"")
	.s PointerName = ..FindPointer(Pointer,Type)
	.s h=h+1
	.s TempStr=AdrSgID_"||"_CH_"^"_Type_"^"_TypeName_"^"_PointerName_"^"_Pointer
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatusGrant",pid,h)=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^TypeID^Type^Pointer^PointID"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatusGrant",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatusGrant",pid,index))
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Creator:bianshuai
/// CreateDate:2014-12-11
/// Descritp:状态字典表
ClassMethod SelAdrStatus() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT * FROM DHC_PHAdrStatus"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("ADRS_RowID")
		s Desc = result.Data("ADRS_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("val^text",tmp)
	}
	w "]"
}

/// Descript:保存[流程定义]
/// w ##class(web.DHCSTPHCMADRDICMAIN).SaveAdrProcess("^SDFASDF^ASD")
ClassMethod SaveAdrProcess(adrProcessDataList As %String) As %String
{
	n (adrProcessDataList)
	s len=$L(adrProcessDataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(adrProcessDataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdAdrProcess(TmpStr)
	.e  d
	..s ret=..InsAdrProcess(TmpStr)
	q ret
}

/// Descript:更新[流程定义]
/// w ##class(web.DHCSTPHCMADRDICMAIN).UpdAdrProcess("^SDFASDF^ASD")
ClassMethod UpdAdrProcess(DataList As %String) As %String
{
	N (DataList)
	s temp=0 
	s ID="0"    
	f  s ID=$o(^DHCPHADRP(ID)) q:ID=""  d
	.s StatusID=$p(^DHCPHADRP(ID),"^",1)   //流程
	.s NextStatID=$p(^DHCPHADRP(ID),"^",2) //下一流程
	.s CombDepend=$p(^DHCPHADRP(ID),"^",3) //被组合依赖
	.S adrProID=$p(DataList,"^",1)
	.s TempStr=adrProID_"^"_StatusID_"^"_NextStatID_"^"_CombDepend
	.i DataList=TempStr d
	..s temp=1
	.q:temp=1
	i temp'=1 d 
	.S adrProID=$p(DataList,"^",1)
	.S StatusID=$p(DataList,"^",2)
	.S NextStatID=$p(DataList,"^",3)
	.S CombDepend=$p(DataList,"^",4)  //被组合依赖
	.&SQL(Update DHC_PHAdrProcess Set ADRP_Status_DR=:StatusID,ADRP_NextStat_DR=:NextStatID,ADRP_CombDepend=:CombDepend WHERE ADRP_RowID=:adrProID)
 	q temp
}

/// Descript:增加[流程定义]
/// w ##class(web.DHCSTPHCMADRDICMAIN).InsAdrProcess("^SDFASDF^ASD")
ClassMethod InsAdrProcess(DataList As %String) As %String
{
	N (DataList)
	s temp=0 
	s ID="0"    
	f  s ID=$o(^DHCPHADRP(ID)) q:ID=""  d
	.s StatusID=$p(^DHCPHADRP(ID),"^",1)   //流程
	.s NextStatID=$p(^DHCPHADRP(ID),"^",2) //下一流程
	.s CombDepend=$p(^DHCPHADRP(ID),"^",3) //被组合依赖
	.s TempStr="^"_StatusID_"^"_NextStatID_"^"_CombDepend
	.i DataList=TempStr d
	..s temp=1
	.q:temp=1
	i temp'=1 d 
	.S StatusID=$p(DataList,"^",2)
	.S NextStatID=$p(DataList,"^",3)
	.S CombDepend=$p(DataList,"^",4)  //被组合依赖
 	.&SQL(INSERT INTO DHC_PHAdrProcess(ADRP_Status_DR,ADRP_NextStat_DR,ADRP_CombDepend) VALUES(:StatusID,:NextStatID,:CombDepend))
 	q temp
}

/// Descript:删除[流程定义]
/// w ##class(web.DHCSTPHCMADRDICMAIN).DelAdrProcess("1")
ClassMethod DelAdrProcess(adrProID As %String) As %String
{
	N (adrProID)
	&SQL(Delete From DHC_PHAdrProcess Where ADRP_RowID=:adrProID)
	Q SQLCODE
}

/// Descript:查询[不流程定义]
/// Table:DHC_PHAdrStatus
/// w ##class(web.DHCSTPHCMADRDICMAIN).QueryAdrProcess("12","1","")
ClassMethod QueryAdrProcess(rows As %String, page As %String, params As %String) As %String
{
	N (rows,page,params)
	s End = page*rows
	s Start = (page-1)*rows+1
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	s h=0,count=0
	s ID="0"
	f  s ID=$o(^DHCPHADRP(ID)) q:ID=""  d
	.s StatusID=$p(^DHCPHADRP(ID),"^",1)   //流程
	.s NextStatID=$p(^DHCPHADRP(ID),"^",2) //下一流程
	.s CombDepend=$p(^DHCPHADRP(ID),"^",3) //被组合依赖
	.q:'$d(^DHCPHADRS(StatusID))
	.s:StatusID'="" Status=$p(^DHCPHADRS(StatusID),"^",2) //状态描述
	.s:NextStatID'="" NextStat=$p(^DHCPHADRS(NextStatID),"^",2) //状态描述
	.s h=h+1
	.s TempStr=ID_"^"_StatusID_"^"_Status_"^"_NextStatID_"^"_NextStat_"^"_CombDepend
	.s ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrProcess",pid,h)=TempStr
	s ^TMP("a")=TempStr
	
	q:h=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(h) //输出json结尾符
	
	///转换数据为Json格式
	S Title="ID^StatusID^Status^NextStatusID^NextStatus^CombDepend"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrProcess",pid,index)) q:index=""  d
	.s mdate=$g(^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrProcess",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdate)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:   查询类型值
/// Creater:    LiMingzhong
/// CreateDate: 2012-7-5
/// Table:DHC_StkSysAPropPref
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod FindPointer(Pointer As %String, Type As %String) As %Library.String
{
    n (Pointer,Type)
 
    q:Pointer="" ""
    q:Type="" ""
    
    s PointerName = ""
    s sql = ""
    i Type="G" d
    .s sql = "select SSGRP_Desc AS Name from SS_Group where SSGRP_RowId="_Pointer
    i Type="L" d
    .s sql="select CTLOC_DESC AS Name from CT_Loc WHERE CTLOC_ROWID="_Pointer
    i Type="U" d
    .s sql="select  ssusr_name as Name from SS_user where ssusr_rowid="_Pointer
    
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sql)
    d result.Execute()
    While(result.Next())
    {
        s PointerName = result.Data("Name")
    }
    Q PointerName
}

/// Creator:bianshuai
/// CreatDate:2014-12-03
/// Description: 权限指向ComboBox
/// input:  Start, Limit
/// output: String "RowId^Description"
/// others:
ClassMethod GetSSPPoint(Start As %Integer, Limit As %Integer, params As %Integer)
{
    n (Start,Limit,params)
    s Type=$p(params,"^",1)
    s Group=$p(params,"^",2)
    s Desc=$p(params,"^",3)
    ;G,L,U
    ;SS_Group,CT_Loc,SS_User
    i Type="G"  d       //按安全组
    .d ..GetGroup(Start,Limit,Desc)
    i Type="L"  d       //按科室
    .d ..GetGroupDept(Start,Limit,Group,Desc)
    i Type="U"  d       //按人员
    .d ..GetGroupUserByGroupId(Start,Limit,Group,Desc)
    i Type="D"  d       //按全院
    .w "["
    .w ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text","DHC^全院")
    .w "]"
    q ""
}

/// Creator:bianshuai
/// CreatDate:2014-12-03
/// description: 安全组
/// input:  Start(起始数值)  Limit(增长数值),安全组名称
/// output: String "RowId^Description"
/// others:
ClassMethod GetGroup(Start As %Integer, Limit As %Integer, Desc As %String)
{
    n (Start,Limit,Desc)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SSGRP_RowId,SSGRP_Desc FROM SS_Group WHERE SSGRP_Desc like '%"_Desc_"%'"
    d result.Prepare(sqlStr)
    d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("SSGRP_RowId")
		s Desc = result.Data("SSGRP_Desc")
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Creator:bianshuai
/// CreatDate:2014-12-03
/// description: 安全组能访问的科室ComboBox
/// input:  Start(起始数值)  Limit(增长数值),安全组id,科室名称
/// output: String "RowId^Code^Description"
/// others:
ClassMethod GetGroupDept(Start As %Integer, Limit As %Integer, GroupId As %String, LocDesc As %String, Type As %String = "")
{
    n (Start,Limit,GroupId,LocDesc,Type)
    s result = ##class(%Library.ResultSet).%New()
    s Type=$g(Type)
    /*
    s sqlStr="Select st_ctloc_dr AS RowId,st_ctloc_dr->ctloc_desc  AS Description from ss_groupstocklocations where st_parref="_GroupId
    i Type'="" d
    .s sqlStr = sqlStr_" and st_ctloc_dr->ctloc_type="_Type
    i LocDesc'="" d
    .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    .s sqlStr = sqlStr_" and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH "_"'"_LocDesc_"'"
    s sqlStr = sqlStr_" ORDER BY st_ctloc_dr"
    */
    s sqlStr="Select CTLOC_RowID,CTLOC_Desc from CT_LOC"
    i LocDesc'="" d
    .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    .s sqlStr = sqlStr_" and %ALPHAUP(CTLOC_Desc) %STARTSWITH "_"'"_LocDesc_"'"

    d result.Prepare(sqlStr)
    d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s RowId = result.Data("CTLOC_RowID")
		s Description = result.Data("CTLOC_Desc")
		s tmp=RowId_"^"_Description
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Creator:bianshuai
/// CreatDate:2014-12-03
/// description:某安去组下的人(采购员ComboBox)
/// input:  Start(起始数值)  Limit(增长数值),"采购员"
/// output: String "Description"
/// others:
ClassMethod GetGroupUserByGroupId(Start As %Integer, Limit As %Integer, Group As %String, Desc As %String) As %String
{
    n (Start,Limit,Group,Desc)
    s result = ##class(%Library.ResultSet).%New()
    //s sqlStr = "select ssusr_rowid as Rowid,ssusr_name as Name from SS_user where ssusr_group="_Group_
    //" and ssusr_name like '%"_Desc_"%'"
    s sqlStr = "select ssusr_rowid as Rowid,ssusr_name as Name from SS_user"
    i Desc'="" d
    .s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
    .s sqlStr = sqlStr_" and %ALPHAUP(ssusr_name) %STARTSWITH "_"'"_LocDesc_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		s Name = result.Data("Name")
		s tmp=Rowid_"^"_Name
		s count = count+1
		I count=1 d
		.W ##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCSTPHCMCOMMON).getJsonData("value^text",tmp)
	}
	w "]"
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrEvent",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrPatImpoInfo",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrReasonForMed",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrWishes",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatus",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrStatusGrant",pid)
	k ^TMP("DHCST","web.DHCSTPHCMADRDICMAIN","QueryAdrProcess",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^TMP("PHCMADRDICMAIN"))
}

}

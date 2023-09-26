/// CTOR: QP
/// DATE: 2017-02-28
/// DESC: 抗菌药物功能配置表操作类
Class DHCAnt.KSS.Config.Function Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     QP
/// CreatDate：   2017-02-28
/// Description:  根据类型和父类型查找所有的子类集合
/// Table：  DHCAnt_Base.MainConfig     
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Function","QryFuncConfigByParentCode","SUPERPARA")
Query QryFuncConfigByParentCode(parentCode As %String = "", inValue As %String = "") As %Query(ROWSPEC = "id:%String,type:%String,parCode:%String,code:%String,mcgDesc:%String,active:%String,controlType:%String,controlValue:%String,processNext:%String,mcgNoteB:%String,mcgNoteC:%String,mcgNoteD:%String")
{
}

ClassMethod QryFuncConfigByParentCodeExecute(ByRef qHandle As %Binary, parentCode As %String = "", inValue As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	q:parentCode="" $$$OK
 	k ^TEMP("DHCAnt","KSS",$j)
 	set rowId=0
 	s superFlag=0,superNum=0
 	i parentCode="PARAMATER" s parentCode="PARA"
	i parentCode="SUPERPARA" s superFlag=1,parentCode="PARA"
	s inValue=$zcvt(inValue,"U")
	
 	f  set rowId=$o(^DHCAntBaseMainConfigI("MCGParentCode",parentCode,rowId)) Q:rowId=""  d
 	.s type=$p(^DHCAntBaseMainConfigD(rowId),"^",1)
 	.Q:(type="SUPERPARA")&&(superFlag=0)
 	.q:(type'="SUPERPARA")&&(superFlag=1)
 	.s parCode=$p(^DHCAntBaseMainConfigD(rowId),"^",2)	//父
 	.s code=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3)
 	.s mcgDesc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4) 
 	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5) 
 	.S controlType=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",8)
 	.s controlValue=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",9)
 	.s processNext=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",10)
 	.s mcgNoteB=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",11)
 	.q:(inValue'="")&&((code'[inValue)&&(mcgDesc'[inValue)&&(mcgNoteB'[inValue)&&(controlValue'[inValue))
 	.s mcgNoteC=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",12)
 	.s mcgNoteD=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",13)
 	.i mcgNoteC="" s mcgNoteC="0"	//处理显示顺序没有维护
 	.i (superFlag=1)||(parentCode="BASECFG") d
 	..s ^TEMP("DHCAnt","KSS",$j,mcgNoteC,code)=rowId_"^"_type_"^"_parCode_"^"_code_"^"_mcgDesc_"^"_active_"^"_controlType_"^"_controlValue_"^"_processNext_"^"_mcgNoteB_"^"_mcgNoteC_"^"_mcgNoteD
 	..s superNum=superNum+1
 	.e  d output1
 	i superNum>0 d
 	.s seqnum=""
 	.f  s seqnum=$O(^TEMP("DHCAnt","KSS",$j,seqnum)) q:seqnum=""  d
	..s curCode=""
	..f  s curCode=$O(^TEMP("DHCAnt","KSS",$j,seqnum,curCode)) q:curCode=""  d
	...s rowId=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",1)
	...s type=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",2)
	...s parCode=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",3)
	...s code=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",4)
	...s mcgDesc=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",5)
	...s active=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",6)
	...s controlType=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",7)
	...s controlValue=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",8)
	...s processNext=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",9)
	...s mcgNoteB=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",10)
	...s mcgNoteC=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",11)
	...s mcgNoteD=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",12)
	...d output1
	k ^TEMP("DHCAnt","KSS",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(rowId,type,parCode,code,mcgDesc,active,controlType,controlValue,processNext,mcgNoteB,mcgNoteC,mcgNoteD)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryFuncConfigByParentCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFuncConfigByParentCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFuncConfigByParentCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFuncConfigByParentCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     DYP
/// CreatDate：   2017-02-28
/// Description:  根据类型和父类型查找所有的子类集合
/// Table：  DHCAnt_Base.MainConfig     
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Function","QryFuncConfigByType","SYS","","")
Query QryFuncConfigByType(type As %String, parentCode As %String = "", code As %String = "") As %Query(ROWSPEC = "id:%String,type:%String,ParentCode:%String,Code:%String,Mcgdesc:%String,active:%String,controlType:%String,controlValue:%String,processNext:%String")
{
}

ClassMethod QryFuncConfigByTypeExecute(ByRef qHandle As %Binary, type As %String, parentCode As %String = "", code As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	q:type="" $$$OK
 	set rowId=0
 	s ParentCode="",Code="",Mcgdesc="",active="",controlType="",controlValue="",processNext=""
 	f  set rowId=$o(^DHCAntBaseMainConfigI("MCGType",type,rowId)) Q:rowId=""  d
 	.s ParentCode=$p(^DHCAntBaseMainConfigD(rowId),"^",2) 
 	.q:(parentCode'="")&&(ParentCode'=parentCode)
 	.s Code=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3) 
 	.q:(code'="")&&(Code'=code)
 	.s Mcgdesc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4) 
 	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5) 
 	.q:active'=1
 	.S controlType=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",8)
 	.s controlValue=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",9)
 	.s processNext=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",10)
 	.d output
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
	Set Data=$lb(rowId,type,ParentCode,Code,Mcgdesc,active,controlType,controlValue,processNext)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryFuncConfigByTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFuncConfigByTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFuncConfigByTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFuncConfigByTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     QP
/// CreatDate：   2017-02-28
/// w ##class(DHCAnt.KSS.Config.Function).GeTreeFuncConfig("PARA")
ClassMethod GeTreeFuncConfig(code) As %String
{
	n (code)
	s h=0
	s SHUI=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SHUI")
	s rowId=0
	k ^TEMP("DHCAnt","KSS",$j)
	f  s rowId=$o(^DHCAntBaseMainConfigI("MCGParentCode",code,rowId)) q:rowId=""  d
	.s mcode=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3)
	.s type=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",1)
	.s desc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4)
	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5) 
	.q:active'=1
	.s sqeno=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",12)	//显示顺序
	.s url=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",13)
	.i url="" d
	..i SHUI=1 s url="dhcant.kss.config.function.center.hui.csp"
	..e  s url="dhcant.kss.config.function.center.csp"
	.s hasChild=..ComHasChild(mcode)
	.;i type="PARAMATER" d 
	.;.s ^TEMP("DHCAnt","KSS",$j,1,"PARAMATER")="系统参数" 
	.;.s h=h+1
	.i mcode="OSPARA" d
	..s ^TEMP("DHCAnt","KSS",$j,sqeno,"PARAMATER")=desc_"^"_mcode_"^"_url
	..s h=h+1
	.;i type="SUPERPARA" d
	.;.s ^TEMP("DHCAnt","KSS",$j,2,"SUPERPARA")="大类配置" 
	.;.s h=h+1
	.i mcode="SMENU" d
	..s ^TEMP("DHCAnt","KSS",$j,sqeno,"SUPERPARA")=desc_"^"_mcode_"^"_url
	..s h=h+1
	.i ('hasChild)&&(type="SUPERPARA")&&(mcode'="OSPARA")&&(mcode'="SMENU") d
	..s ^TEMP("DHCAnt","KSS",$j,sqeno,mcode)=desc_"^"_mcode_"^"_url //没有子节点，但类型为SUPERPARA
	..s h=h+1
	.i (hasChild) d 
	..s ^TEMP("DHCAnt","KSS",$j,sqeno,mcode)=desc_"^"_mcode_"^"_url	//有子节点
	..s h=h+1
	q:h=0 "[]"
	w "["
	s num=0,seqnum=""
	f  s seqnum=$O(^TEMP("DHCAnt","KSS",$j,seqnum)) q:seqnum=""  d
	.s curCode=""
	.f  s curCode=$O(^TEMP("DHCAnt","KSS",$j,seqnum,curCode)) q:curCode=""  d
	..s num=num+1
	..s resultStr=$g(^TEMP("DHCAnt","KSS",$j,seqnum,curCode))
	..s mcode=$p(resultStr,"^",2),value=$p(resultStr,"^",1),url=$p(resultStr,"^",3)
	..;s value=num_"、"_value
	..i num=1 d
	...w "{"""_"id"_""":"""_curCode_""","""_"text"":"""_value_""","_""""_"url"":"""_url_"?type="_curCode_"""}",!
	..e  d
	...w ",{"""_"id"_""":"""_curCode_""","""_"text"":"""_value_""","_""""_"url"":"""_url_"?type="_curCode_"""}",!
	w "]"
	q ""
}

// w ##class(DHCAnt.KSS.Config.Function).GetFuncConfigByType()

/// Creator：     QP
/// CreatDate：   2017-02-28
/// 判断是否有儿子
/// w ##class(DHCAnt.KSS.Config.Function).ComHasChild("LABWAY")
ClassMethod ComHasChild(code) As %String
{
	n (code)
	s h=0,rtn=0
	s id=0
	f  s id=$o(^DHCAntBaseMainConfigI("MCGParentCode",code,id)) q:id=""  d
	.s h=h+1
	i h>0 s rtn=1
 	q rtn
}

/// Creator：     QP
/// CreatDate：   2017-02-28
/// 判断配置大类型是否为SUPERPARA
/// w ##class(DHCAnt.KSS.Config.Function).ComCodeIsSUPERPARA("LABWAY")
ClassMethod ComCodeIsSUPERPARA(code) As %String
{
	n (code)
	s rtn=0
	s rowId=$o(^DHCAntBaseMainConfigI("MCGCode",code,""))
	q:rowId="" rtn
	s type=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",1)
	i type="SUPERPARA" s rtn=1
 	q rtn
}

/// Creator：     QP
/// CreatDate：   2017-02-28
ClassMethod GetFuncConfigByType2() As %String
{
	s h=0
 	set rowId=0
 	k ^TempDHCAntFuncConfig("DHCAnt",$j)
 	s ParentCode="",Code="",Mcgdesc="",active="",controlType="",controlValue="" 
 	;s subrowid=0,subtype="",subParentCode="",subcode="",subMcgdesc="",subcontrolType="",subcontrolValue=""
 	//SUPERPARA
 	f  s rowId=$o(^DHCAntBaseMainConfigI("MCGType","SUPERPARA",rowId))  q:rowId=""  d
 	.s type=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",1)
 	.s Code=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3)
 	.s ParentCode=$p(^DHCAntBaseMainConfigD(rowId),"^",2)
 	.s Mcgdesc=$p(^DHCAntBaseMainConfigD(rowId),"^",4)
 	.s controlType=$p(^DHCAntBaseMainConfigD(rowId),"^",8)
 	.s controlValue=$p(^DHCAntBaseMainConfigD(rowId),"^",9)
 	.q:Code="" 
 	.s subh=0
 	.s ret=""
 	.s subrowid=0,subtype="",subParentCode="",subcode="",subMcgdesc="",subcontrolType="",subcontrolValue=""
 	.f  s subrowid=$o(^DHCAntBaseMainConfigI("MCGParentCode",Code,subrowid))   q:subrowid=""  d
 	..s subtype=$p(^DHCAntBaseMainConfigD(subrowid),"^",1)
 	..s subParentCode=Code
 	..s subcode=$p(^DHCAntBaseMainConfigD(subrowid),"^",3)
 	..s subMcgdesc=$p(^DHCAntBaseMainConfigD(subrowid),"^",4)
 	..s subcontrolType=$p(^DHCAntBaseMainConfigD(subrowid),"^",8)
 	..s subcontrolValue=$p(^DHCAntBaseMainConfigD(subrowid),"^",9)
 	..if ret="" s ret=subrowid_"^"_subtype_"^"_subParentCode_"^"_subcode_"^"_subMcgdesc_"^"_subcontrolType_"^"_subcontrolValue
 	..e  s ret=ret_"!"_subrowid_"^"_subtype_"^"_subParentCode_"^"_subcode_"^"_subMcgdesc_"^"_subcontrolType_"^"_subcontrolValue
 	..s subh=subh+1
 	.s data=type_"^"_ParentCode_"^"_Code_"^"_Mcgdesc_"^"_controlType_"^"_controlValue_"^"_rowId_"^"_ret
 	.s h=h+1
 	.s ^TempDHCAntFuncConfig("DHCAnt","SUPERPARA",$j,h)=data
 	s m=0
 	f  set rowId=$o(^DHCAntBaseMainConfigI("MCGType","PARAMATER",rowId)) Q:rowId=""  d
 	.s ParentCode=$p(^DHCAntBaseMainConfigD(rowId),"^",2) 
 	.s Code=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3) 
 	
 	.s Mcgdesc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4) 
 	.S controlType=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",8)
 	.s controlValue=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",9)
 	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5) 
 	.q:active'=1
 	
 	.s data=type_"^"_ParentCode_"^"_Code_"^"_Mcgdesc_"^"_controlType_"^"_controlValue_"^"_rowId
 	.s m=m+1
 	.s ^TempDHCAntFuncConfig("DHCAnt","PARAMATER",$j,m)=data
 	q:(m=0)&(h=0) ##class(web.DHCSTEXTCOMMON).GetNoJson()
 	b 
    s maxrow=h+m
    s submaxrow=subh
    s count=0
    s subcount=0
    s h=""
    f  s h=$o(^TempDHCAntFuncConfig("DHCAnt","SUPERPARA",$j,h))   q:h=""  d
    .s data=^TempDHCAntFuncConfig("DHCAnt","SUPERPARA",$j,h)
    .s Type=$p(data,"^",1)
    .s ParentCode=$p(data,"^",2)
    .s Code=$p(data,"^",3)
    .s Mcgdesc=$p(data,"^",4)
    .s ControlType=$p(data,"^",5)
    .s ControlValue=$p(data,"^",6)
    .s RowId=$p(data,"^",7)
    
    
    .s id=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("id",RowId)
    .s type=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("type",Type)
    .s parentCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("parentCode",ParentCode)
    .s code=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("code",Code)
    .s mcgdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("mcgdesc",Mcgdesc)
    .s controlType=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("controlType",ControlType)
    .s controlValue=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("controlValue",ControlValue)
    .;s subrowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subrowid",subrowid)
    .;s subtype=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subtype",subtype)
    .;s subParentCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subParentCode",subParentCode)
    .;s subcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subcode",subcode)
    .;s subMcgdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subMcgdesc",subMcgdesc)
    .;s subcontrolType=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subcontrolType",subcontrolType)
    .;s subcontrolValue=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("subcontrolValue",subcontrolValue)
    
    .;s tmpStr=id_type_parentCode_code_mcgdesc_controlType_controlValue_subrowid_subtype_subParentCode_subcode_subMcgdesc_subcontrolType_subcontrolValue
    .s tmpStr=id_type_parentCode_code_mcgdesc_controlType_controlValue
 	.s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpStr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpStr)
 	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
   
   	.s ret=$p(data,"^",8)
    .if ret'="" d
    ..s len=$l(ret,"!")
    ..f i=1:1:len  d
    ...s substr=$p(ret,"^",i)
    ...;b ;222
    ...s subrowid=$p(substr,"^",1)
    ...s subtype=$p(substr,"^",2)
    ...s subParentCode=$p(substr,"^",3)
    ...s subcode=$p(substr,"^",4)
    ...s subMcgdesc=$p(substr,"^",5)
    ...s subcontrolType=$p(substr,"^",6)
    ...s subcontrolValue=$p(substr,"^",7)
    ...s subrowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subrowid",subrowid)
    ...s subtype=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subtype",subtype)
    ...s subParentCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subParentCode",subParentCode)
    ...s subcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subcode",subcode)
    ...s subMcgdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subMcgdesc",subMcgdesc)
    ...s subcontrolType=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("subcontrolType",subcontrolType)
    ...s subcontrolValue=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("subcontrolValue",subcontrolValue)
    ...s subtmpStr=subrowid_subtype_subParentCode_subcode_subMcgdesc_subcontrolType_subcontrolValue
    ...s substartString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(submaxrow)
    ...s subfirstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(subtmpStr)
    ...s sublastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(subtmpStr)
 	...s subcount=subcount+1
	...i subcount=1 w substartString
    ...i subcount<submaxrow w subfirstrow
    ...i subcount=submaxrow w sublastrow
    
   k ^TempDHCAntFuncConfig("DHCAnt",$j)
   q ""
}

// w ##class(DHCAnt.KSS.Config.Function).GetFuncConfigByType3("PARA")

ClassMethod GetFuncConfigByType3(code As %String) As %String
{
	q:code="" ""
	k ^TempDHCAntFuncConfig("DHCAnt",$j)
	set rowId=0 ,h=0
 	s ParentCode="",Mcgdesc="",active="",controlType="",controlValue=""
 	f  set rowId=$o(^DHCAntBaseMainConfigI("MCGParentCode",code,rowId)) Q:rowId=""  d
 	.;b ;22
 	.s type=$p(^DHCAntBaseMainConfigD(rowId),"^",1) 
 	.s ParentCode=code 
 	.s mcgcode=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3) 
 	.s Mcgdesc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4) 
 	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5) 
 	.;q:active'=1
 	.S controlType=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",8)
 	.s controlValue=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",9)	
 	.s data=rowId_"^"_type_"^"_ParentCode_"^"_mcgcode_"^"_Mcgdesc_"^"_controlType_"^"_controlValue
 	.s ^TempDHCAntFuncConfig("DHCAnt",$j,h)=data
 	.s h=h+1
 	q:(h=0) ##class(DHCAnt.Util.ConvertJson).GetNoDataJson()
 	s maxrow=h
 	s h="",count=0
 	f  s h=$o(^TempDHCAntFuncConfig("DHCAnt",$j,h))   q:h=""  d
 	.s data=^TempDHCAntFuncConfig("DHCAnt",$j,h)
 	.s rowid=$p(data,"^",1)
 	.s type=$p(data,"^",2)
    .s ParentCode=$p(data,"^",3)
    .s mcgcode=$p(data,"^",4)
    .s Mcgdesc=$p(data,"^",5)
    .s ControlType=$p(data,"^",6)
    .s ControlValue=$p(data,"^",7)
    
    .s id=##class(DHCAnt.Util.ConvertJson).GetDataJson("id",rowid)
    .s type=##class(DHCAnt.Util.ConvertJson).GetDataJson("type",type)
    .s parentCode=##class(DHCAnt.Util.ConvertJson).GetDataJson("parentCode",ParentCode)
    .s mcgcode=##class(DHCAnt.Util.ConvertJson).GetDataJson("code",mcgcode)
    .s mcgdesc=##class(DHCAnt.Util.ConvertJson).GetDataJson("mcgdesc",Mcgdesc)
    .s controlType=##class(DHCAnt.Util.ConvertJson).GetDataJson("controlType",ControlType)
    .s controlValue=##class(DHCAnt.Util.ConvertJson).GetLastDataJson("controlValue",ControlValue)
    
    .s tmpStr=id_type_parentCode_mcgcode_mcgdesc_controlType_controlValue
 	.;s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(DHCAnt.Util.ConvertJson).GetJsonFirstRow(tmpStr)
    .s lastrow=##class(DHCAnt.Util.ConvertJson).GetJsonLastRow(tmpStr)
 	.s count=count+1
	.;i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
   
 	 k ^TempDHCAntFuncConfig("DHCAnt",$j)
   q ""
}

/// Creator：     hw
/// CreatDate：   2017-3-1
/// Description:  保存抗菌药物申请流程
/// Table：       
/// Input：		  type : 配置类型	ParentCode : 父级代码	
/// 			valueStr : 流程串(需要科室预审^需要会诊审核^需要科室审核^需要最终审核)	loc : 最终审核科室 
/// output: 0 : 成功 "PROCESS@KSS2APP@1110@"
/// w ##Class(DHCAnt.KSS.Config.test123).DBInsertProcessConfig("PROCESS","KSS3APPNOA","1^1^1^1",22)
/// w ##Class(DHCAnt.KSS.Config.Function).DBInsertProcessConfig("PROCESS","KSS3APPA","1^0^0^0","")
ClassMethod DBInsertProcessConfig(type, ParentCode, valueStr, loc)
{
	s CodeStr="A^F^H^S^U"
	s ControlType="A"
	s ^TEMP("QP",1)=type_"@"_ParentCode_"@"_valueStr_"@"_loc
	f i=1:1:4 d
	.s value=$p(valueStr,"^",i)
	.i value=1 s ControlType=ControlType_"-"_$p(CodeStr,"^",i+1)
	
	s valueStr="1^"_valueStr
	f j=1:1:5 d
	.s ControlValue=$p(CodeStr,"^",j)
	.s MCGCode=ParentCode_ControlValue
	.s MCGActive=$p(valueStr,"^",j)
	.s MCGRowId=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	.s NextStr=$p(ControlType,ControlValue,2)
	.i NextStr'="" d
	..s NextStr=$p(NextStr,"-",2)
	..s ProcessNext=$o(^DHCAntBaseMainConfigI("MCGCode",ParentCode_NextStr,""))
	.e  s ProcessNext=""
	.i MCGActive="0" s ControlValue=""
	.s MCGControlType=""
	.i j=1 s MCGControlType=ControlType
	.i j=5 s MCGControlType=loc
	.s Id=..DBUpdataMainConfig(MCGRowId,type,ParentCode,MCGCode,"",MCGActive,"","",MCGControlType,ControlValue,ProcessNext,"","","")
	.b ;001
	q 0
}

/// Creator：     hw
/// CreatDate：   2017-3-1
/// Description:  保存或更新抗菌药物配置表
/// Table：       DHCAnt_Base.MainConfig
/// Input：		  DHCAnt_Base.MainConfig表字段
/// output: -2 : 配置代码为空 -1 : 配置代码已经存在 其他 : 配置表ID 
/// w ##Class(DHCAnt.KSS.Config.Function).DBUpdataMainConfig("31","PARAMATER","PARA","SAMEKSSONCE","填写一次目的或会诊",1,"","","","1","","","","")
ClassMethod DBUpdataMainConfig(MCGRowId, MCGType, MCGParentCode, MCGCode, MCGDesc, MCGActive, MCGDateFrom = "", MCGDateTo = "", MCGControlType = "", MCGControlValue = "", MCGProcessNext = "", MCGStrB = "", MCGStrC = "", MCGStrD = "", action = "", MHosp = "")
{
	n (MCGRowId, MCGType, MCGParentCode, MCGCode, MCGDesc, MCGActive, MCGDateFrom , MCGDateTo , MCGControlType, MCGControlValue, MCGProcessNext, MCGStrB, MCGStrC, MCGStrD, action,MHosp)
	q:MCGCode="" "-2"
	s isRepeat=0
	//s MCGCodeID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))	//表里有无记录
	;q:MHosp="" "-3"	//
	i MHosp="" s MCGCodeID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
	e  s MCGCodeID=$o(^DHCAntBaseMainConfigI("MCGHospAndCode",MHosp,MCGCode,""))
	
	q:(MCGCodeID'="")&&(MCGRowId'=MCGCodeID) "-1"	//
	i MCGRowId="" s a=##class(DHCAnt.Base.MainConfig).%New()
	e  s a=##class(DHCAnt.Base.MainConfig).%OpenId(MCGRowId)
	s a.MCGType=MCGType
	s a.MCGParentCode=MCGParentCode
	s a.MCGCode=MCGCode
	i MCGDesc'="" s a.MCGDesc=MCGDesc ;处理通过code 或ID 更改Control 信息
	s a.MCGActive=MCGActive
	s a.MCGDateFrom=MCGDateFrom
	s a.MCGDateTo=MCGDateTo
	s a.MCGControlType=MCGControlType
	s a.MCGControlValue=MCGControlValue
	s a.MCGProcessNext=MCGProcessNext
	s a.MCGStrB=MCGStrB
	s a.MCGStrC=MCGStrC
	s a.MCGStrD=MCGStrD
	s a.MCGHosp=MHosp
	s sc=a.%Save()
	If $$$ISERR(sc) {	//QP
		d $system.OBJ.DisplayError(sc) 
		TRollback
		Quit "-100"
	}
		
	q a.%Id()
}

ClassMethod QryProcessConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProcessConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryProcessConfigExecute(ByRef qHandle As %Binary, ParentCodeList As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	i ParentCodeList="" s ParentCodeList="KSS2APP^KSS3APPNOA^KSS3APPA"
 	s len=$l(ParentCodeList,"^")
 	f i=1:1:len d
 	.s ParentCode=$p(ParentCodeList,"^",i)
 	.s ParentId=$o(^DHCAntBaseMainConfigI("MCGCode",ParentCode,""))
 	.s ParentDesc=$p(^DHCAntBaseMainConfigD(ParentId),"^",4)
 	.s ParentType=$p(^DHCAntBaseMainConfigD(ParentId),"^",1)	//QP
 	
 	.s CodeStr="F^H^S^U",MCGType=""
 	.s ULocID="",ULocDesc=""
 	.s DescStr="1"
 	.f j=1:1:4 d
 	..s MCGCode=ParentCode_$p(CodeStr,"^",j)
 	..s MCGRowID=$o(^DHCAntBaseMainConfigI("MCGCode",MCGCode,""))
 	..s MCGType=$p(^DHCAntBaseMainConfigD(MCGRowID),"^",1)	//QP
 	..s MCGActive=$p(^DHCAntBaseMainConfigD(MCGRowID),"^",5)
 	..s DescStr=DescStr_"^"_MCGActive
 	..i j=4 d
 	...s ULocID=$p(^DHCAntBaseMainConfigD(MCGRowID),"^",8)
 	...i ULocID=" " s ULocID="" ;保护处理
 	...i ULocID'="" d
 	....s ULocDesc=$P(^CTLOC(ULocID),"^",2)
 	....i ULocDesc["-" s ULocDesc=$p(ULocDesc,"-",2)
 	.s CodeF=$p(DescStr,"^",2)
 	.s CodeH=$p(DescStr,"^",3)
 	.s CodeS=$p(DescStr,"^",4)
 	.s CodeU=$p(DescStr,"^",5)
 	
   	.Do OutwardRow
	Quit $$$OK
OutwardRow
	set Data=$lb(ParentId,ParentCode,ParentDesc,CodeF,CodeH,CodeS,CodeU,ULocID,ULocDesc,MCGType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryProcessConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProcessConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ParentId,ParentCode,ParentDesc,CodeF,CodeH,CodeS,CodeU,ULocID,ULocDesc
/// Creator：     hw
/// CreatDate：   2017-3-1
/// Description:  查询抗菌药物流程
/// Table：       DHCAnt_Base.MainConfig
/// Input：		  ParentCodeList : 流程Code传("KSS2APP^KSS3APPNOA^KSS3APPA") 可为空
/// output: 	  ParentId 流程ID ,ParentCode 流程Code ,ParentDesc 流程名称 ,
/// 		CodeF 需要科室预审 ,CodeH 需要会诊审核 ,CodeS 需要科室审核 ,CodeU 需要最终审核 ,ULocID 最终审核科室ID ,ULocDesc 最终审核科室名称
/// d ##Class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Function","QryProcessConfig","")
Query QryProcessConfig(ParentCodeList As %String) As %Query(ROWSPEC = "ParentId,ParentCode,ParentDesc,CodeF,CodeH,CodeS,CodeU,ULocID,ULocDesc,MCGType")
{
}

/// 返回0表示没有重复，1有重复。
/// w ##class(DHCAnt.KSS.Config.Function).CheckCodeIsHave("LABWAY")
ClassMethod ComCheckCodeIsHave(code As %String) As %String
{
	q:code="" 0
	s flag=0
	s rowid=0
	s rowid=$o(^DHCAntBaseMainConfigI("MCGCode",code,rowid))  
	if (rowid'=0)&&(rowid'="")  q 1
	e  q 0
}

// ========================================================================================

// ==================================新版本================================================

// ========================================================================================

/// Creator：     QP
/// CreatDate：   2017-02-28
/// w ##class(DHCAnt.KSS.Config.Function).GeTreeFuncConfigNew("PARA")
ClassMethod GeTreeFuncConfigNew(code, hosp = "") As %String
{
	n (code,hosp,%session)
	i hosp="" s hosp=%session.Get("LOGON.HOSPID")
	s OLDCFG=0 //##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("OLDCFG",hosp)
	
	w "["
	
	w "{""id"": 1,""text"": ""基础设置"",""state"": ""open"",""children"": "
	w "["
	w "{""id"": ""PARAMATER"",""text"": ""常规设置"",""url"":""dhcant.kss.config.func.bsnormal.csp?type=BSNormal""}"
	w ",{""id"": ""PROCESS"",""text"": ""流程设置"",""url"":""dhcant.kss.config.process.csp?type=Process""}"
	w ",{""id"": ""OEORI"",""text"": ""医嘱项设置"",""url"":""dhcant.kss.config.func.bsarcimset.csp?type=BSArcimset""}"
	w ",{""id"": ""PHPO"",""text"": ""管制分类设置"",""url"":""dhcant.kss.config.poison.csp?type=PHPO""}"
	w ",{""id"": ""LocalConfig"",""text"": ""本地化参数设置"",""url"":""dhcant.kss.config.func.local.csp?type=LocalConfig""}"
	w ",{""id"": ""UsePurposeManage"",""text"": ""使用目的管控设置"",""url"":""dhcant.kss.config.upmanage.csp?type=UsePurposeManage""}"
	w "]"
	w "}"
	
	w ",{""id"": 2,""text"": ""系统设置"",""state"": ""closed"",""children"": "
	w "["
	w "{""id"": ""OSPARA"",""text"": ""系统参数"",""url"":""dhcant.kss.config.func.ospara.csp?type=PARAMATER""}"
	w ",{""id"": ""PSTATUS"",""text"": ""申请状态"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PSTATUS""}"
	w ",{""id"": ""PTYPE"",""text"": ""流程状态"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PTYPE""}"
	w ",{""id"": ""BASECFG"",""text"": ""基础数据菜单"",""url"":""dhcant.kss.config.function.center.basedata.hui.csp?type=BASECFG""}"
	w "]"
	w "}"
	if (OLDCFG=1) {
	w ",{""id"": 3,""text"": ""旧版配置"",""state"": ""closed"",""children"": "
	w "["
	w "{""id"": ""BASECFG"",""text"": ""基础数据菜单"",""url"":""dhcant.kss.config.function.center.basedata.hui.csp?type=BASECFG""}"
	w ",{""id"": ""PARAMATER"",""text"": ""系统参数"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PARAMATER""}"
	w ",{""id"": ""LABWAY"",""text"": ""送检方式判断"",""url"":""dhcant.kss.config.function.center.hui.csp?type=LABWAY""}"
	w ",{""id"": ""SMANYCONSULT"",""text"": ""多科会诊"",""url"":""dhcant.kss.config.function.center.hui.csp?type=SMANYCONSULT""}"
	w ",{""id"": ""FUNCFG"",""text"": ""功能类型维护"",""url"":""dhcant.kss.config.function.center.hui.csp?type=FUNCFG""}"
	w ",{""id"": ""PSTATUS"",""text"": ""申请状态"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PSTATUS""}"
	w ",{""id"": ""CONDOCGRADE"",""text"": ""会诊医生级别"",""url"":""dhcant.kss.config.function.center.hui.csp?type=CONDOCGRADE""}"
	w ",{""id"": ""SMENU"",""text"": ""菜单配置"",""url"":""dhcant.kss.config.function.center.menu.hui.csp?type=SUPERPARA""}"
	w ",{""id"": ""PTYPE"",""text"": ""流程状态"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PTYPE""}"
	w ",{""id"": ""NOAUTHDOC"",""text"": ""医生处方权"",""url"":""dhcant.kss.config.function.center.hui.csp?type=NOAUTHDOC""}"
	w "]"
	w "}"
	}
	w "]"
	
	q ""
}

/// Creator：     QP
/// CreatDate：   2017-02-28
/// w ##class(DHCAnt.KSS.Config.Function).GetBaseTree("PARA")
ClassMethod GetOSTree(code = "") As %String
{
	n (code)
	w "["
	
	w "{""id"": ""OSPARA"",""text"": ""系统参数"",""url"":""dhcant.kss.config.func.ospara.csp?type=PARAMATER""}"
	w ",{""id"": ""PSTATUS"",""text"": ""申请状态"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PSTATUS""}"
	w ",{""id"": ""PTYPE"",""text"": ""流程状态"",""url"":""dhcant.kss.config.function.center.hui.csp?type=PTYPE""}"
	w ",{""id"": ""BASECFG"",""text"": ""基础数据菜单"",""url"":""dhcant.kss.config.function.center.basedata.hui.csp?type=BASECFG""}"
	w "]"
	
	q ""
}

/// Creator：     QP
/// CreatDate：   2017-02-28
/// w ##class(DHCAnt.KSS.Config.Function).GetBaseTree("PARA")
ClassMethod GetBaseTree(code = "") As %String
{
	n (code)
	
	w "["
	
	w "{""id"": ""PARAMATER"",""text"": ""常规设置"",""url"":""dhcant.kss.config.func.bsnormal.csp?type=BSNormal""}"
	w ",{""id"": ""PROCESS"",""text"": ""流程设置"",""url"":""dhcant.kss.config.process.csp?type=Process""}"
	w ",{""id"": ""OEORI"",""text"": ""医嘱项设置"",""url"":""dhcant.kss.config.func.bsarcimset.csp?type=BSArcimset""}"
	w ",{""id"": ""PHPO"",""text"": ""管制分类设置"",""url"":""dhcant.kss.config.poison.csp?type=PHPO""}"
	w ",{""id"": ""LocalConfig"",""text"": ""本地化参数设置"",""url"":""dhcant.kss.config.func.local.csp?type=LocalConfig""}"
	w ",{""id"": ""UsePurposeManage"",""text"": ""使用目的管控设置"",""url"":""dhcant.kss.config.upmanage.csp?type=UsePurposeManage""}"
	
	w "]"
	
	q ""
}

/// Creator：     QP
/// CreatDate：   2017-02-28
/// Description:  根据类型和父类型查找所有的子类集合
/// Table：  DHCAnt_Base.MainConfig     
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCAnt.KSS.Config.Function","QryOSPara","PARAMATER")
Query QryOSPara(parentCode As %String = "", inValue As %String = "") As %Query(ROWSPEC = "id:%String,type:%String,parCode:%String,code:%String,mcgDesc:%String,active:%String,controlType:%String,controlValue:%String,processNext:%String,mcgNoteB:%String,mcgNoteC:%String,mcgNoteD:%String")
{
}

ClassMethod QryOSParaExecute(ByRef qHandle As %Binary, parentCode As %String = "", inValue As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	q:parentCode="" $$$OK
 	k ^TEMP("DHCAnt","KSS",$j)
 	set rowId=0
 	s superFlag=0,superNum=0
 	i parentCode="PARAMATER" s parentCode="PARA"
	i parentCode="SUPERPARA" s superFlag=1,parentCode="PARA"
	s inValue=$zcvt(inValue,"U")
	
 	f  set rowId=$o(^DHCAntBaseMainConfigI("MCGParentCode",parentCode,rowId)) Q:rowId=""  d
 	.s type=$p(^DHCAntBaseMainConfigD(rowId),"^",1)
 	.Q:(type="SUPERPARA")&&(superFlag=0)
 	.q:(type'="SUPERPARA")&&(superFlag=1)
 	.s parCode=$p(^DHCAntBaseMainConfigD(rowId),"^",2)	//父
 	.s code=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",3)
 	.s mcgDesc=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",4) 
 	.s active=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",5) 
 	.S controlType=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",8)
 	.q:controlType'=1
 	.s controlValue=$p($g(^DHCAntBaseMainConfigD(rowId)),"^",9)
 	.s processNext=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",10)
 	.s mcgNoteB=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",11)
 	.q:(inValue'="")&&((code'[inValue)&&(mcgDesc'[inValue)&&(mcgNoteB'[inValue)&&(controlValue'[inValue))
 	.s mcgNoteC=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",12)
 	.s mcgNoteD=$P($g(^DHCAntBaseMainConfigD(rowId)),"^",13)
 	.i mcgNoteC="" s mcgNoteC="0"	//处理显示顺序没有维护
 	.i (superFlag=1)||(parentCode="BASECFG") d
 	..s ^TEMP("DHCAnt","KSS",$j,mcgNoteC,code)=rowId_"^"_type_"^"_parCode_"^"_code_"^"_mcgDesc_"^"_active_"^"_controlType_"^"_controlValue_"^"_processNext_"^"_mcgNoteB_"^"_mcgNoteC_"^"_mcgNoteD
 	..s superNum=superNum+1
 	.e  d output8
 	i superNum>0 d
 	.s seqnum=""
 	.f  s seqnum=$O(^TEMP("DHCAnt","KSS",$j,seqnum)) q:seqnum=""  d
	..s curCode=""
	..f  s curCode=$O(^TEMP("DHCAnt","KSS",$j,seqnum,curCode)) q:curCode=""  d
	...s rowId=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",1)
	...s type=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",2)
	...s parCode=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",3)
	...s code=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",4)
	...s mcgDesc=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",5)
	...s active=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",6)
	...s controlType=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",7)
	...s controlValue=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",8)
	...s processNext=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",9)
	...s mcgNoteB=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",10)
	...s mcgNoteC=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",11)
	...s mcgNoteD=$p(^TEMP("DHCAnt","KSS",$j,seqnum,curCode),"^",12)
	...d output8
	k ^TEMP("DHCAnt","KSS",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output8
	Set Data=$lb(rowId,type,parCode,code,mcgDesc,active,controlType,controlValue,processNext,mcgNoteB,mcgNoteC,mcgNoteD)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryOSParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOSParaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOSParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOSParaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}

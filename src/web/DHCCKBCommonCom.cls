Import sqluser

/// Creator: 	qunianpeng
/// CreateDate: 2020-11-24
/// Descript: 	安全用药公共类
Class web.DHCCKBCommonCom Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:	职称
/// w ##Class(web.DHCCKBCommonCom).JsonPrvTp()
ClassMethod JsonPrvTp() As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTCPT_RowId ,CTCPT_Desc FROM CT_CarPrvTp"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	w "["
	While(result.Next())
	{	
		s ID = result.Data("CTCPT_RowId")
		s Desc = result.Data("CTCPT_Desc")
		Continue:Desc=""
		s tmp=ID_"^"_Desc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	Q ""
}

/// Descritp:	科室
/// w ##Class(web.DHCCKBCommonCom).JsonLoc(2)
ClassMethod JsonLoc(q As %String = "", HospID As %String) As %String
{
	n (q, HospID)

	s input=q 
	s input=$ZCVT(input,"U")
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT CTLOC_ROWID as locDr,CTLOC_DateActiveTo as DateActiveTo,CTLOC_DESC as locDesc,CTLOC_Hospital_DR as HospitalId FROM CT_LOC"
	i input'=""  d
	.s sqlStr=sqlStr_" WHERE CTLOC_ContactName LIKE """_""_input_""_"%"_""" OR CTLOC_Desc LIKE """_""_input_""_"%"_""_""" "
	
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s curDate=$p(($h),",",1)
	w "["
	While(result.Next())
	{	
		s locDr = result.Data("locDr")
		s locDesc = result.Data("locDesc")
		s DateActiveTo=result.Data("DateActiveTo")
		i DateActiveTo'="" continue:DateActiveTo<curDate //过期退出
		continue:(HospID'="")&(HospID'=$p(^CTLOC(locDr),"^",22))
		continue:(locDesc["停")||(locDesc["工作量")
		s tmp=locDr_"^"_locDesc
		s count = count+1
		I count=1 d
		.W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
		e  d
		.W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
	
#;	s count=0
#;	w "["
#;	s LocDr=""
#;	f  s LocDr=$o(^CTLOC(0,"LocType","E",LocDr)) q:LocDr=""  d
#;	.Q:$d(^CTLOC(LocDr))=0
#;	.s DateFrom=$p(^CTLOC(LocDr),"^",24)
#;	.s DateTo=$p(^CTLOC(LocDr),"^",25)
#;	.Q:(DateFrom>+$H)&(DateFrom'="")
#;	.Q:(DateTo<+$H)&(DateTo'="")
#;	.s LocDesc = $p(^CTLOC(LocDr),"^",2)
#;	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
#;	.s tmp=LocDr_"^"_LocDesc
#;	.s count = count+1
#;	.I count=1 d
#;	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
#;	.e  d
#;	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
#;	w "]"
#;	q ""
}

/// Descritp:	医生
/// w ##Class(web.DHCCKBCommonCom).JsonLocCareProv(333)
ClassMethod JsonLocCareProv(q = "", LocID As %String, PrvTpID As %String, ProvType As %String, LgUserID As %String) As %String
{
	n (q, LocID, PrvTpID, ProvType, LgUserID)
	s count=0
	s ProvType=$zcvt(ProvType,"U")
	s ProvType=$s(ProvType["NUR":"NURSE",1:"DOCTOR")
	w "["
	s ProvTypeID=""
	F  s ProvTypeID=$o(^CT("CPT",ProvTypeID)) Q:ProvTypeID=""  D
	.Q:$p(^CT("CPT",ProvTypeID),"^",3)'="Y"
	.Q:$p(^CT("CPT",ProvTypeID),"^",4)'=ProvType //"DOCTOR"
	.s CareProvID=""
	.F  s CareProvID=$o(^CTPCP(0,"CareProvType",ProvTypeID,CareProvID)) Q:CareProvID=""  D 
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..Q:UserID=""
	..Q:(LgUserID'="")&(LgUserID=UserID)
	..s otherFlag=..GetUserOtherLoc(UserID,LocID)
	..Q:($p(^SSU("SSUSR",UserID),"^",4)'=LocID)&(otherFlag'=1)
	..s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	..Q:$p(^CTPCP(CareProvID,1),"^",9)'="Y"
	..q:(PrvTpID'="")&&(CTPCPCTId'=PrvTpID)
	..s UserName=$p(^CTPCP(CareProvID,1),"^",2)
	..Q:UserName'[q
	..s tmp=CareProvID_"^"_UserName
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	..e  d
	...W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

/// Descritp:	用户的其他登录科室
/// w ##Class(web.DHCCKBCommonCom).GetUserOtherLoc("","")
ClassMethod GetUserOtherLoc(userid As %String, mLocID As %String) As %String
{
	n (userid, mLocID)
	s othusr="0",quitflag=0
	f  s othusr=$o(^SSU("SSUSR",userid,"OTHLL",othusr)) q:(othusr="")||(quitflag=1)  d
	.s LocID=+$p(^SSU("SSUSR",userid,"OTHLL",othusr),"^",1)
	.Q:mLocID'=LocID
	.s quitflag=1
	.
	Q quitflag
}

/// Descritp:	获取系统当前日期
/// w ##Class(web.DHCCKBCommonCom).GetCurSystemDate(2)
ClassMethod GetCurSystemDate(offset As %String) As %String
{
	n (offset)
	s SystemDate=+$H+offset
	s SystemDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(SystemDate)
	Q SystemDate
}

/// Creator: 		qunianpeng
/// CreateDate: 	2020-1-14
/// Descript: 		获取知识库的项目属性值(如：药品的成分、商品等字典属性的值),对于成组的值,默认取模板第一个位置
/// Input:			DicID:项目ID	Prop:属性id	Flag:0取描述 1 取id  
/// w ##class(web.DHCCKBCommonCom).GetSysPropDataValue(160,"39")
ClassMethod GetSysPropDataValue(dicID, prop, flag = 1) As %String
{
	n (dicID,prop,flag)
	
	s linkPropId=##class(web.DHCCKBCommon).GetLinkProp()
	s propValue = ""
	if $d(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",prop,linkPropId))  d		//属性关联模板
	.s linkAttrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",prop,linkPropId,""))
	.s parrefPropId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(linkAttrId)),4)
	.s count = 0
	.s subId=""
	.for  s subId=$o(^CT.CKB.PDSS.CommonDictionI("Parref",parrefPropId,subId))  Q:(subId="")||(count>0)  d
	..// 考虑到成分={成分编码:含量:单位}这种:特殊的模板数据,只需要取成分编码,因此默认取模板下的第一个属性值
	..s count = count + 1
	..s attrId=""
	..for  s attrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,subId,attrId))  Q:attrId=""  d
	...s dicAttrCode=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),3)	
	...s dicAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)
	...q:dicAttrId=""
	...s dicRes=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5)
	...s groupFlag=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),6)
	...i flag = 1 d
	....s dicLinkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:dicLinkDr'="" $list(propValue,*+1)=dicLinkDr
	....s:dicLinkDr="" $list(propValue,*+1)=dicAttrId
	...e  d
	....s dicLinkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),5)
	....s:dicLinkDr'="" $list(propValue,*+1)=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicLinkDr)),3)
	....s:dicLinkDr="" $list(propValue,*+1)=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicAttrId)),3)
	e  d	// 没有模板,直接取值
	.s attrId=""
	.for  s attrId=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkDicAttrCode",dicID,prop,attrId))  Q:attrId=""  d
	..s linkAttrId=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),4)	
	..s res=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(attrId)),5)	
	..q:linkAttrId=""
	..s dicLinkDr = $lg($g(^CT.CKB.PDSS.CommonDictionD(linkAttrId)),5)
	..i flag = 1 d	
	...s:dicLinkDr'="" $list(propValue,*+1)=dicLinkDr
	...s:dicLinkDr="" $list(propValue,*+1)=linkAttrId
	..e  d
	...s:dicLinkDr'="" $list(propValue,*+1)=$lg($g(^CT.CKB.PDSS.CommonDictionD(dicLinkDr)),3)
	...s:dicLinkDr="" $list(propValue,*+1)=$lg($g(^CT.CKB.PDSS.CommonDictionD(linkAttrId)),3)
	
	q propValue
}

/// Descript: 西药编码
/// Creator:		QuNianpeng
/// CreateDate:		2021-05-20
/// w ##Class(web.DHCCKBCommonCom).XYCode()
ClassMethod XYCode() As %String
{
	s num = $I(^DHCCKB("CommonCom","XY"))
	s:num=0 num=num+1
	
	s num = ..AddStrPrefix(num,8,"0")
	s num = "XY"_num
	
	q num
}

/// Descript:	中成药编码
/// Creator:		QuNianpeng
/// CreateDate:		2021-05-20
/// w ##Class(web.DHCCKBCommonCom).ZCYCode()
ClassMethod ZCYCode() As %String
{
	s num = $I(^DHCCKB("CommonCom","ZCY"))
	s:num=0 num=num+1
	
	s num = ..AddStrPrefix(num,7,"0")
	s num = "ZCY"_num
	
	q num
}

/// Descript:	中药饮片编码
/// Creator:		QuNianpeng
/// CreateDate:		2021-05-20
/// w ##Class(web.DHCCKBCommonCom).ZYYPCode()
ClassMethod ZYYPCode() As %String
{
	s num = $I(^DHCCKB("CommonCom","ZYYP"))
	s:num=0 num=num+1
	
	s num = ..AddStrPrefix(num,6,"0")
	s num = "ZYYP"_num
	
	q num
}

/// Description:	字符串补充前缀
/// Creator:		QuNianpeng
/// CreateDate:		2021-05-20
/// Input:			操作字符串,限定长度,补充字符
/// return:			字符串
/// w ##Class(web.DHCCKBCommonCom).AddStrPrefix("1",8,"0")
ClassMethod AddStrPrefix(str, len, sign) As %String
{
	n (str,len,sign)
	s strLen = $Length(str)
	f i=1:1:(len-strLen) d
	.s str=sign_str
	
	q str
}

}

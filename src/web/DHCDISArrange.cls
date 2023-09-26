Import SQLUSER

/// Creator:       zhaowuqiang
/// CreateDate:    2016-02-15
/// Description:   配送直接安排
Class web.DHCDISArrange Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description:   配送直接安排保存(修改)
/// Creator:       zhaowuqiang
/// CreatDate；    2016-02-15
/// Descript:   将json字符串转换成json对象，再转换为实体类对象保存
/// w ##class(web.DHCDISGoodsRequest).save("{""REQCreateUser"":""4"",""REQLocDr"":""100"",""REQRecLocDr"":null,""REQRemarks"":"""",""REQExeDate"":""2017-01-18"",""REQExeTime"":"""",""REQCreateDate"":""2017-01-18"",""REQCreateTime"":""""}","")
ClassMethod save(mainStr, subStr)
{
	n (mainStr, subStr)
	TS	
	s obj=##class(web.DHCAPPJsonObject).ObjectFromJSON(mainStr,"User.DHCDisGoodsRequest")
	s obj.REQCurStatus=##class(web.DHCDISGoodsRequest).getNextStatus(0)
	s obj.REQNo=##class(web.DHCDISGoodsRequest).getVerfiyCode()
	s sc=obj.%Save()
	If $$$ISERR(sc) {
      Do $System.Status.DisplayError(sc)
 	  TRollBack
 	  q -1
 	}
 	s mainId=obj.%Id()
 	s newObj=##class(User.DHCDisGoodsRequest).%OpenId(mainId)
 	s err=0
 	s mis=0	
	f i=1:1:$l(subStr,"^") d
	.q:err'=0
	.q:mis'=0
	.q:$p(subStr,"^",i)=""
	.s subobj=##class(web.DHCAPPJsonObject).ObjectFromJSON($p(subStr,"^",i),"User.DHCDisGoodsReqItm")
	.s subobj.REQParRefDr=newObj
	.s subobj.REQChildSub=$o(^DHCDISGRE(mainId,"ITM",""),-1)+1
	.s sc=subobj.%Save()
	.If $$$ISERR(sc) s err=-2
	.s sub=subobj.REQChildSub
	.s reqi=mainId_"||"_sub
	.s itm=$p(^DHCDISGRE(mainId,"ITM",sub),"^",3)
	.;zhaowuqiang  2017-02-16
	.s userobj=##class(web.DHCAPPJsonObject).ObjectFromJSON($p(subStr,"^",i),"User.DHCDisPeople") //插入表DHC_DisPeople
	.s userobj.DPReqType=1
	.s userobj.DPPointer=reqi
	.s sd=userobj.%Save()
	.If $$$ISERR(sd) s mis=-2
	i err'=0 {
		TRollBack
		q err
	} 
	i mis'=0 {
		TRollBack
		q mis
	} 
	TC
	q 0
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   获取配送下个状态
/// DO ##class(User.DHCDisStatusAdd).%BuildIndices()
/// w ##class(web.DHCDISGoodsRequest).getNextStatus()
ClassMethod getNextStatus(id)
{
	n (id)
	s currstatdr=0
	s:+id'=0 currstatdr=+$p(^DHCDISGRE(id),"^",3)
	s currcode=0
	s:+currstatdr'=0 currcode=$p(^DHCDISSA(currstatdr),"^",1)
	s nextcode=""
	s nextcode=$o(^DHCDISSA("0","TypeCode",1,"Y","Y",currcode))
	q:nextcode="" 0
	s next=$o(^DHCDISSA("0","TypeCode",1,"Y","Y",nextcode,""))
	q next
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-18
/// Descript:   获取配送验证码
/// DO ##class(User.DHCDisStatusAdd).%BuildIndices()
/// w ##class(web.DHCDISGoodsRequest).getVerfiyCode()
ClassMethod getVerfiyCode(type)
{
	n (type)
	s text=$SYSTEM.Encryption.GenCryptRand(5,1)
 	s text=$SYSTEM.Encryption.Base64Encode(text) 
	q text
}

}

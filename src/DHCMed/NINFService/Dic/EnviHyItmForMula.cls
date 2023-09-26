/// 名称: DHCMed.NINFService.Dic.EnviHyItmForMula
/// 描述: 环境卫生学计算公式的常用操作
/// 编写者：yhb
/// 编写日期: 2013-11-11
Class DHCMed.NINFService.Dic.EnviHyItmForMula Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  保存环境卫生学计算公式
/// Table：       DHCMed.NINF.Dic.EnviHyItmForMula
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.EnviHyItmForMula).SaveRec("2^1^50000N/(AXT)^1^test","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveRecErr"
	Set SubID=$p(aInput,aSeparate,1)
	Set ParRef=$p(aInput,aSeparate,2)
	if (SubID'=""){
		Set $p(aInput,aSeparate,1) = ParRef_"||"_SubID
	}
	Set Formula=$p(aInput,aSeparate,3)
	Quit:(Formula="")||(ParRef="") return
	Set return=##Class(DHCMed.NINF.Dic.EnviHyItmForMula).Update(aInput,aSeparate)
	Quit return
	
SaveRecErr
	Quit "-999"
}

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  查询环境卫生学计算公式
/// Table：       DHCMed.NINF.Dic.EnviHyItmForMula
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyItmForMula","QryEnviHyItmForMula","1")
Query QryEnviHyItmForMula(ItemID As %String) As %Query(ROWSPEC = "ForMulaID:%String,ForMula:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QryEnviHyItmForMulaExecute(ByRef qHandle As %Binary, ItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    Set obj=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ItemID)
	Quit:'$IsObject(obj) $$$OK
	
	Set MulaID=0 //2014-12-19 zhoubo fixbug:1550
	For {
		Set MulaID=$o(^DHCMed.NINFi("EHI",0,"FM","IndexParRef",ItemID,MulaID))
		Quit:MulaID=""
		Set objSub=##class(DHCMed.NINF.Dic.EnviHyItmForMula).GetObjById(ItemID_"||"_MulaID)
		Set EHIFIsActiveDesc=$s(objSub.EHIFIsActive=1:"是",1:"否")
		Set Data=$lb(MulaID,objSub.EHIFForMula,EHIFIsActiveDesc,objSub.EHIFResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	/*
	Set SubCount = obj.ChildMula.Count()
	for subID = 1:1:SubCount {
		Set objSub=##class(DHCMed.NINF.Dic.EnviHyItmForMula).GetObjById(ItemID_"||"_subID)
		Set EHIFIsActiveDesc=$s(objSub.EHIFIsActive=1:"是",1:"否")
		Set Data=$lb(subID,objSub.EHIFForMula,EHIFIsActiveDesc,objSub.EHIFResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	*/
	Quit $$$OK
}

ClassMethod QryEnviHyItmForMulaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyItmForMulaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyItmForMulaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyItmForMulaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {	
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     yhb
/// CreatDate：   2013-11-11
/// Description:  导入Excel环境卫生学计算公式  未实现
/// Table：       DHCMed.NINF.Dic.EnviHyItmForMula
/// Input：       监控项目字符串,"^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINFService.Dic.EnviHyItmForMula).ImportDic("^01^非洁净区域空气消毒^空气消毒效果监测^1次/月^cfu/m3^1^","^")
ClassMethod ImportDic(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ItemCode=$p(aInput,aSeparate,2)
	Set ItemID=$o(^DHCMed.NINFDi("EHI",0,"IndexCode"," "_ItemCode,0))
	Set objItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ItemID)
	If $IsObject(objItem) {
		Set ItemID=objItem.%Id()
	} Else {
		Set ItemID=""
	}
	Set ItemCateg=$p(aInput,aSeparate,5)
	Set:ItemCateg'="" ItemCateg=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHyItemCategory",ItemCateg)
	Set:ItemCateg'="" ItemCateg=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ItemCateg,"NINFEnviHyItemCategory")
	Set ItemFreq=$p(aInput,aSeparate,6)
	Set:ItemFreq'="" ItemFreq=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHyItemFrequency",ItemFreq)
	Set:ItemFreq'="" ItemFreq=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ItemFreq,"NINFEnviHyItemFrequency")
	Set ItemNormUom=$p(aInput,aSeparate,7)
	Set:ItemNormUom'="" ItemNormUom=##Class(DHCMed.SSService.DictionarySrv).GetIDByDesc("","NINFEnviHyNormUom",ItemNormUom)
	Set:ItemNormUom'="" ItemNormUom=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(ItemNormUom,"NINFEnviHyNormUom")
	
	Set InputStr=ItemID
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,2)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,3)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,4)
	Set InputStr=InputStr_aSeparate_ItemCateg
	Set InputStr=InputStr_aSeparate_ItemFreq
	Set InputStr=InputStr_aSeparate_ItemNormUom
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,8)
	Set InputStr=InputStr_aSeparate_$p(aInput,aSeparate,9)
	Set return=##Class(DHCMed.NINF.Dic.EnviHyItem).Update(InputStr, aSeparate)
	
	Quit return
}

}

/// 名称: DHCMed.INFService.InfAntiMappingSrv
/// 描述: DHCMed.INF.InfAntiMapping 辅助检查抗菌药物对照维护的常用操作
/// 编写者：liuyh
/// 编写日期: 2010-05-26
Class DHCMed.INFService.InfAntiMappingSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// *************************************************************
/// CreateDate  ：2009-11-14 Add By ZF
/// Description ：取抗生素字典
/// Table       ：[LabData]CT_Antibiotics
/// Input       ：Code,Desc,IsActive
/// Output      ：AntCode 抗生素代码,AntDesc 抗生素名称
/// Others      ：d ##class(%ResultSet).RunQuery("web.DHCMedCommon.GetLabResult","QryAntibioticsDic","","","Y")
/// *************************************************************
Query QryAntibioticsDic(Code As %String, Alias As %String, IsActive As %String) As %Query(ROWSPEC = "AntCode:%String,AntDesc:%String")
{
}

ClassMethod QryAntibioticsDicExecute(ByRef qHandle As %Binary, Code As %String, Alias As %String, IsActive As %String) As %Status
{
 	Set repid=$i(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set IsActive=$Select(IsActive["Y":"Y",IsActive["N":"N",1:"")
	If (Code'="")
	{
	 	Set AntDesc=$Piece($Get(^TTAB("ANT",Code)),"\",1)
	 	Quit:(Alias'="")&(AntDesc'[Alias) $$$OK
	 	Set AntActive=$Piece($Get(^TTAB("ANT",Code)),"\",4)
	 	Quit:(IsActive'="")&(IsActive'=AntActive) $$$OK
	 	Set Data=$ListBuild(Code,AntDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}Else{
	 	Set AntCode=""
	 	For	{
		 	Set AntCode=$o(^TTAB("ANT",AntCode))
		 	Quit:AntCode=""
			Set AntDesc=$Piece($Get(^TTAB("ANT",AntCode)),"\",1)
	 		Continue:(Alias'="")&((AntDesc'[Alias)&(AntCode'[Alias))
	 		Set AntActive=$Piece($Get(^TTAB("ANT",AntCode)),"\",4)
	 		Continue:(IsActive'="")&(IsActive'=AntActive)
	 		Set Data=$ListBuild(AntCode,AntDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 		}
	}
	
	Quit $$$OK
}

ClassMethod QryAntibioticsDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntibioticsDicExecute ]
{
	
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryAntibioticsDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntibioticsDicExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2010-05-26
/// Description:  辅助检查的抗菌素对照表信息
/// Table：       DHCMed.INF.InfAntiMapping
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.InfAntiMappingSrv","QueryAntiMapInfo","")
Query QueryAntiMapInfo(Alias As %String) As %Query(ROWSPEC = "rowid:%String,AntCode:%String,AntDesc:%String,InfAntID:%String,InfAntDesc:%String,Active:%String")
{
}

ClassMethod QueryAntiMapInfoExecute(ByRef qHandle As %Binary, Alias As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s AntCode=""
	
	f  s AntCode=$o(^TTAB("ANT",AntCode)) Quit:AntCode=""  d
	.s AntDesc=$Piece($Get(^TTAB("ANT",AntCode)),"\",1)
	.q:((Alias'="")&((AntDesc_"-"_AntCode)'[Alias))
	.s AntActive=$Piece($Get(^TTAB("ANT",AntCode)),"\",4)
	.q:AntActive'="Y"
	.s AntiMapID=$o(^DHCMed.INF.InfAntiMappingI("Code"," "_AntCode,""))
	.i AntiMapID="" d
	..s $li(data,1)=""			// 对照表rowid
	..s $li(data,2)=AntCode		// 辅助检查抗生素字典表code
	..s $li(data,3)=AntDesc		// 辅助检查描述
	..s $li(data,4)=""			// DHCMed.INF.InfAntiDic表rowid
	..s $li(data,5)=""			// 抗菌药描述
	..s $li(data,6)="Y"			// 是否有效
	.e  d
	..s $li(data,1)=AntiMapID
	..s obj=##class(DHCMed.INF.InfAntiMapping).%OpenId(AntiMapID)
	..s $li(data,2)=AntCode
	..s $li(data,3)=AntDesc
	..s $li(data,4)=obj.AntiID
	..s AntiObj=##class(DHCMed.INF.InfAntiDic).GetObjById(obj.AntiID)
	..q:'$IsObject(AntiObj)
	..s $li(data,5)=AntiObj.Description
	..s $li(data,6)=$s(obj.Active=1:"Y",obj.Active=0:"N",1:"Y")
 	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1	
	
	q $$$OK
}

ClassMethod QueryAntiMapInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAntiMapInfoExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAntiMapInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAntiMapInfoExecute ]
{
	Set AtEnd=$li(qHandle,1)
 	Set repid=$li(qHandle,2)
 	Set ind=$li(qHandle,3)
 	
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 描述：		 把表抗生素CT_Antibiotics 中的数据插入到 表 DHCMed.INF.InfAntiDic中
/// 调用方法：	 w ##Class(DHCMed.INFService.InfAntiMappingSrv).InsertLabAntiToDic()
ClassMethod InsertLabAntiToDic() As %String
{
	k ^DHCMed.INF.InfAntiDicD		//清除表中数据
	k ^DHCMed.INF.InfAntiDicI
	s AntCode=""
	
	f  s AntCode=$o(^TTAB("ANT",AntCode)) Quit:AntCode=""  d
	.s AntDesc=$Piece($Get(^TTAB("ANT",AntCode)),"\",1)
	.s AntActive=$Piece($Get(^TTAB("ANT",AntCode)),"\",4)
	.q:AntActive'="Y"
	.d ##class(DHCMed.INF.InfAntiDic).Update("^"_AntCode_"^"_AntDesc_"^"_"1"_"^","^")
	
	q $$$OK
}

/// 描述：		 自动匹配检验中的抗生素和DHCMed.INF.InfAntiDic中的抗生素
/// 调用方法：	 w ##Class(DHCMed.INFService.InfAntiMappingSrv).AutoMapLabAntiToDic()
ClassMethod AutoMapLabAntiToDic() As %String
{
	k ^DHCMed.INF.InfAntiMappingD
	k ^DHCMed.INF.InfAntiMappingI
	
	s AntCode=""
	
	f  s AntCode=$o(^TTAB("ANT",AntCode)) Quit:AntCode=""  d
	.s AntDesc=$Piece($Get(^TTAB("ANT",AntCode)),"\",1)
	.s AntActive=$Piece($Get(^TTAB("ANT",AntCode)),"\",4)
	.q:AntActive'="Y"
	.q:'$d(^DHCMed.INF.InfAntiDicI("Code"," "_AntCode))
	.s DicID=$o(^DHCMed.INF.InfAntiDicI("Code"," "_AntCode,""))
	.q:DicID=""
	.d ##Class(DHCMed.INF.InfAntiMapping).Update("^"_AntCode_"^"_AntDesc_"^"_DicID_"^"_1_"^^^^","^")
	
	q $$$OK
}

}

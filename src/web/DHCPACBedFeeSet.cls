/// 名称: web.DHCPACBedFeeSet
/// 描述: 用于设定床位费
Class web.DHCPACBedFeeSet Extends DHCDoc.Util.RegisteredObject
{

// 取得所有病区的所有床位信息并转化为树型Json

ClassMethod GetWardAndBedInfo() As %String
{
	  Set lstBed = ##class(%ResultSet).%New("web.DHCPACBedFeeSet:GetBed")
	  Set sc = lstBed.Execute()
	  set infor = ""
	  set wardIdNow = ""
	  set wardDescNow = ""
	  set wardBedNow = ""
	  Write "<script type='text/javascript'>",!
	  Write "var treeData=["
	  while lstBed.Next() '=0
	  {
		 set wardId =lstBed.Data("BED_WARD_ParRef")
		 set bedId =lstBed.Data("BED_RowID")
		 set bedName =lstBed.Data("BED_Code")
		 if (wardIdNow '= wardId)
		 {
			 if (wardBedNow'="")
			 {
			 	set:infor'="" infor=infor_","
			 	Write infor
				set infor = ""
		  		set infor = infor_"{"
		  		set infor = infor_"id:'"_wardIdNow_"',"
		  		set infor = infor_"text:'"_##class(web.DHCExtUtil).ReplaceCharacterForJS(wardDescNow)_"',"
		  		set infor = infor_"children:["_wardBedNow_"]}"
		  		
			 }
			 set wardBedNow = ""
			 s obj=##class(User.PACWard).%OpenId(wardId)
			 if $G(obj) '= ""
			 {
		  		set wardIdNow = wardId
		  		set wardDescNow = obj.WARDDesc
		  		if ($F(wardDescNow, "-") > 0)
		 		{
			  		set wardDescNow =  $p(wardDescNow,"-",2)
		 		}
		 	  	set wardBedNow = wardBedNow_"{"
			  	set wardBedNow = wardBedNow_"id:"
			  	set wardBedNow = wardBedNow_"'"_bedId_"',"
			  	set wardBedNow = wardBedNow_"checked: false,"
			  	set wardBedNow = wardBedNow_"text:"
			  	set wardBedNow = wardBedNow_"'"_##class(web.DHCExtUtil).ReplaceCharacterForJS(bedName)_"',"
			  	set wardBedNow = wardBedNow_"leaf: true}"
			 }
		 }
		 else
		 {
			  set:wardBedNow'="" wardBedNow=wardBedNow_","
			  set wardBedNow = wardBedNow_"{"
			  set wardBedNow = wardBedNow_"id:"
			  set wardBedNow = wardBedNow_"'"_bedId_"',"
			  set wardBedNow = wardBedNow_"checked: false,"
			  set wardBedNow = wardBedNow_"text:"
			  set wardBedNow = wardBedNow_"'"_##class(web.DHCExtUtil).ReplaceCharacterForJS(bedName)_"',"
			  set wardBedNow = wardBedNow_"leaf: true}"
		 }
	  }
	  if (wardBedNow'="")
	  {
		set:infor'="" infor=infor_","
		Write infor
		set infor = ""
		set infor = infor_"{"
		set infor = infor_"id:'"_wardIdNow_"',"
		set infor = infor_"text:'"_##class(web.DHCExtUtil).ReplaceCharacterForJS(wardDescNow)_"',"
		set infor = infor_"children:["_wardBedNow_"]}"
		Write infor
	  }
	  do lstBed.%Close()
	  Write "]",!
	  //set:infor'="" infor= "["_infor_"]"
	  
	  ;输出是否启用空调费收取和暖气费收取的变量
	  s CFEnableAir=..GetConfig("EnableAir")
	  s CFEnableHeat=..GetConfig("EnableHeat")
	  i CFEnableAir="" s CFEnableAir="N"
	  i CFEnableHeat="" s CFEnableHeat="N"
	  w !
	  w "var CFEnableAir="""_CFEnableAir_"""",!
	  w "var CFEnableHeat="""_CFEnableHeat_"""",!
	  Write "</script>"
	  quit ""
}

/// 描述: 保存床位费用项目
ClassMethod SaveBedFeeItem(feeArcIm As %String, feeType As %String, startDate As %String, endDate As %String, wardId As %String, bedId As %String) As %Boolean
{
	s feeStartDate = ""
	s feeEndDate = ""
	if (startDate '= "")
	{
		s feeStartDate = ..%ZDH(startDate) //$ZDATEH(startDate,3)
	}
	if (endDate '= "")
	{
		s feeEndDate = ..%ZDH(endDate) //$ZDATEH(endDate,3)
	}
	&sql(Insert into SQLUser.DHC_PAC_BedFeeItem(BEDI_BED_ParRef,BEDI_BED_Childsub,BEDI_FeeType,BEDI_ARCIM_DR,BEDI_StartDate,BEDI_EndDate) 
	     Values(:wardId,:bedId,:feeType,:feeArcIm,:feeStartDate,:feeEndDate))
	i SQLCODE'=0  quit 0
	Quit 1
}

/// 描述: 删除床位费用项目
ClassMethod DeleteBedFeeItem(rowID As %String) As %Status
{
	Set sc = ##class(User.DHCPACBedFeeItem).%DeleteId(rowID)
	Quit sc
}

/// 描述: 更新床位费用项目
ClassMethod UpdateBedFeeItem(feeArcIm As %String, feeType As %String, startDate As %String, endDate As %String, rowID As %String) As %Boolean
{
	//Set obj = ##class(User.DHCPACBedFeeItem).%OpenId(rowID)
	s feeStartDate = ""
	s feeEndDate = ""
	if (startDate '= "")
	{
		s feeStartDate = ..%ZDH(startDate) //$ZDATEH(startDate,3)
	}
	if (endDate '= "")
	{
		s feeEndDate = ..%ZDH(endDate) //$ZDATEH(endDate,3)
	}
	&sql(update SQLUser.DHC_PAC_BedFeeItem set BEDI_FeeType=:feeType,BEDI_ARCIM_DR=:feeArcIm,BEDI_StartDate=:feeStartDate,BEDI_EndDate=:feeEndDate where BEDI_RowId = :rowID)
	i SQLCODE'=0  quit 0
	Quit 1
}

/// 描述: 保存床位类型费用项目
ClassMethod SaveBedTypeFeeItem(feeArcIm As %String, feeType As %String, startDate As %String, endDate As %String, bedTypeId As %String) As %Boolean
{
	s feeStartDate = ""
	s feeEndDate = ""
	if (startDate '= "")
	{
		s feeStartDate = ..%ZDH(startDate) //$ZDATEH(startDate,3)
	}
	if (endDate '= "")
	{
		s feeEndDate = ..%ZDH(endDate) //$ZDATEH(endDate,3)
	}
	&sql(Insert into SQLUser.DHC_PAC_BedTypeFeeItem(BEDTPI_BEDTP_ParRef,BEDTPI_FeeType,BEDTPI_ARCIM_DR,BEDTPI_StartDate,BEDTPI_EndDate) 
	     Values(:bedTypeId,:feeType,:feeArcIm,:feeStartDate,:feeEndDate))
	i SQLCODE'=0  quit 0
	Quit 1
}

/// 描述: 更新床位类型费用项目
ClassMethod UpdateBedTypeFeeItem(feeArcIm As %String, feeType As %String, startDate As %String, endDate As %String, bedTypeId As %String, rowID As %String) As %Boolean
{
	s feeStartDate = ""
	s feeEndDate = ""
	if (startDate '= "")
	{
		s feeStartDate = ..%ZDH(startDate) //$ZDATEH(startDate,3)
	}
	if (endDate '= "")
	{
		s feeEndDate = ..%ZDH(endDate) //$ZDATEH(endDate,3)
	}
	&sql(update SQLUser.DHC_PAC_BedTypeFeeItem set BEDTPI_FeeType=:feeType,BEDTPI_ARCIM_DR=:feeArcIm,BEDTPI_StartDate=:feeStartDate,BEDTPI_EndDate=:feeEndDate,BEDTPI_BEDTP_ParRef=:bedTypeId where BEDTPI_RowId = :rowID)
	i SQLCODE'=0  quit 0
	Quit 1
}

/// 保存配置节点
ClassMethod SaveConfig(Coninfo As %String) As %String
{
	q ##class(web.DHCDocConfig).SaveConfig(Coninfo)
}

/// 得到配置节点
ClassMethod GetConfig(Node As %String) As %String
{
	Q ..%GetConfig(Node)
}

/// 描述: 删除床位类型费用项目
ClassMethod DeleteBedTypeFeeItem(rowID As %String) As %Status
{
	Set sc = ##class(User.DHCPACBedTypeFeeItem).%DeleteId(rowID)
	Quit sc
}

/// 描述: 取得床位信息
/// 入参：wardId 病区ID
Query GetBed() As %SQLQuery(CONTAINID = 1)
{
		SELECT BED_WARD_ParRef,BED_RowID,BED_Code FROM SQLUser.PAC_Bed  
		order by BED_WARD_ParRef
}

/// 描述: 取得床位费用信息
/// 入参：wardId 病区ID,bedId 床位ID
/// 		SELECT BEDI_Childsub,BEDI_FeeType,BEDI_ARCIM_DR,BEDI_StartDate,BEDI_EndDate FROM SQLUser.DHC_PAC_BedFeeItem  
Query GetBedFeeList(wardId As %String, bedId As %String) As %SQLQuery(CONTAINID = 1)
{
		SELECT A.BEDI_RowId,A.BEDI_FeeType,B.FT_Desc,A.BEDI_ARCIM_DR,C.ARCIM_Desc,A.BEDI_StartDate as startDate,A.BEDI_EndDate as endDate FROM SQLUser.DHC_PAC_BedFeeItem as A left join SQLUser.DHC_PACBed_FeeType as B on A.BEDI_FeeType = B.FT_RowId left join
		SQLUser.ARC_ItmMast as C on A.BEDI_ARCIM_DR = C.ARCIM_RowId where A.BEDI_BED_ParRef=:wardId AND A.BEDI_BED_Childsub =:bedId
}

/*
	SELECT A.BEDTPI_RowId,A.BEDTPI_BEDTP_ParRef,D.BEDTP_Desc,A.BEDTPI_FeeType,B.FT_Desc,A.BEDTPI_ARCIM_DR,C.ARCIM_Desc,{fn CONVERT(A.BEDTPI_StartDate,SQL_VARCHAR)} as startDate,{fn CONVERT(A.BEDTPI_EndDate,SQL_VARCHAR)} as endDate FROM SQLUser.DHC_PAC_BedTypeFeeItem as A left join SQLUser.DHC_PACBed_FeeType as B on A.BEDTPI_FeeType = B.FT_RowId left join
	SQLUser.ARC_ItmMast as C on A.BEDTPI_ARCIM_DR = C.ARCIM_RowId left join SQLUser.PAC_BedType AS D on A.BEDTPI_BEDTP_ParRef = D.BEDTP_RowId

*/
/// 描述: 取得床位类型费用信息
/// 入参：wardId 病区ID
Query GetBedTypeFeeList() As %SQLQuery(CONTAINID = 1)
{
		SELECT A.BEDTPI_RowId,A.BEDTPI_BEDTP_ParRef,D.BEDTP_Desc,A.BEDTPI_FeeType,B.FT_Desc,A.BEDTPI_ARCIM_DR,C.ARCIM_Desc,A.BEDTPI_StartDate as startDate,A.BEDTPI_EndDate as endDate FROM SQLUser.DHC_PAC_BedTypeFeeItem as A left join SQLUser.DHC_PACBed_FeeType as B on A.BEDTPI_FeeType = B.FT_RowId left join
		SQLUser.ARC_ItmMast as C on A.BEDTPI_ARCIM_DR = C.ARCIM_RowId left join SQLUser.PAC_BedType AS D on A.BEDTPI_BEDTP_ParRef = D.BEDTP_RowId
}

/// 描述: 取得床位类型费用信息
/// 入参：wardId 病区ID
/// {fn CONVERT(A.BEDTPI_StartDate,SQL_VARCHAR)} as startDate
Query GetBedTypeFeeListByType(bedTypeId As %String) As %SQLQuery(CONTAINID = 1)
{
		SELECT A.BEDTPI_RowId,A.BEDTPI_BEDTP_ParRef,D.BEDTP_Desc,A.BEDTPI_FeeType,B.FT_Desc,A.BEDTPI_ARCIM_DR,C.ARCIM_Desc,A.BEDTPI_StartDate as startDate,A.BEDTPI_EndDate as endDate FROM SQLUser.DHC_PAC_BedTypeFeeItem as A left join SQLUser.DHC_PACBed_FeeType as B on A.BEDTPI_FeeType = B.FT_RowId left join
		SQLUser.ARC_ItmMast as C on A.BEDTPI_ARCIM_DR = C.ARCIM_RowId left join SQLUser.PAC_BedType AS D on A.BEDTPI_BEDTP_ParRef = D.BEDTP_RowId where A.BEDTPI_BEDTP_ParRef =:bedTypeId
}

/// 描述: 取得床位类型信息
Query GetBedTypeList() As %SQLQuery(CONTAINID = 1)
{
		SELECT BEDTP_RowId,BEDTP_Desc FROM SQLUser.PAC_BedType where (BEDTP_DateTo is null or BEDTP_DateTo>+$h) and (BEDTP_DateFrom is null or BEDTP_DateFrom<=+$H)
}

/// 描述: 床位附加费用类型信息
Query GetBedFeeTypeList() As %SQLQuery(CONTAINID = 1)
{
		SELECT FT_RowId,FT_Desc,FT_StartDate,FT_EndDate FROM SQLUser.DHC_PACBed_FeeType where FT_RowId>0
}

Storage Default
{
<Data name="DHCPACBedFeeSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPACBedFeeSetD</DataLocation>
<DefaultData>DHCPACBedFeeSetDefaultData</DefaultData>
<IdLocation>^web.DHCPACBedFeeSetD</IdLocation>
<IndexLocation>^web.DHCPACBedFeeSetI</IndexLocation>
<StreamLocation>^web.DHCPACBedFeeSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/*Query GetARCItmMastList(desc As %String) As %SQLQuery(CONTAINID = 1)
{
		SELECT A.ARCIM_RowId,A.ARCIM_Desc,A.ARCIM_Code,B.ALIAS_Text FROM SQLUser.ARC_ItmMast AS A left join SQLUser.ARC_Alias AS B on A.ARCIM_RowId = B.ALIAS_ARCIM_DR AND B.ALIAS_Type='ARCIM' 
		where (A.ARCIM_Desc like '%'_:desc_'%' or A.ARCIM_Desc %STARTSWITH :desc Or B.ALIAS_Text %STARTSWITH :desc)
		      and (A.ARCIM_EffDate is null or A.ARCIM_EffDate<=+$h)
		      and (A.ARCIM_EffDateTo is null or A.ARCIM_EffDateTo>+$h)
			  group by A.ARCIM_RowId
}*/
/// 描述: 费用医嘱信息
/// 描述: 费用医嘱信息
/// d ##class(%ResultSet).RunQuery("web.DHCPACBedFeeSet","GetARCItmMastList","zyzc")
ClassMethod GetARCItmMastListExecute(ByRef qHandle As %Binary, desc As %String, FeeType As %String = "") As %Status
{
	s UserID=%session.Get("LOGON.USERID")
	;s FeeType=$g(^TMPSaveFeeType(UserID))
	s ^tmplj("GetARCItmMastList")=desc_","_FeeType
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s ARCIMMain=0 f  s ARCIMMain=$o(^ARCIM(ARCIMMain)) q:ARCIMMain=""  d
	.s ARCIMSub=0 f  s ARCIMSub=$o(^ARCIM(ARCIMMain,ARCIMSub)) q:ARCIMSub=""  d
	..s ARCIMRowID=ARCIMMain_"||"_ARCIMSub
	..s ARCIMCode=$p($g(^ARCIM(ARCIMMain,ARCIMSub,1)),"^",1)
	..s ARCIMDesc=$p($g(^ARCIM(ARCIMMain,ARCIMSub,1)),"^",2)
	..s AliasFlag="N"
	..s AliasRowID=0 f  s AliasRowID=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowID,AliasRowID)) q:AliasRowID=""  d
	...s AliasType=$p($g(^ARC("ALIAS",AliasRowID)),"^",5)
	...q:AliasType'="ARCIM"
	...s AliasText=$p($g(^ARC("ALIAS",AliasRowID)),"^",6)
	...i (AliasText[desc)&&(desc'="") s AliasFlag="Y"
	..q:(ARCIMDesc'[desc)&&(AliasFlag="N")&&(desc'="")
	..s FeeTypeCode=""
	..i FeeType'="" s FeeTypeCode=$p($g(^PAC("FEETP",FeeType)),"^",1)
	..s ExpStr=""_"^"_""_"^"_""_"^"_""_"^^"
	..s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice("", "", ARCIMRowID, +$h, "", "", "", "","","","",ExpStr)
	..s Price=$fn($P(retPrice,"^",1),"",2)
	..d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(ARCIMRowID,ARCIMDesc,ARCIMCode,"",Price)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetARCItmMastListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetARCItmMastListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

Query GetARCItmMastList(desc As %String, FeeType As %String = "") As %Query(ROWSPEC = "ARCIM_RowId:%String,ARCIM_Desc:%String,ARCIM_Code:%String,ALIAS_Text:%String,ARCIM_Price:%String")
{
}

}

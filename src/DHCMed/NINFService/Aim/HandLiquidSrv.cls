Class DHCMed.NINFService.Aim.HandLiquidSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 根据开始日期和结束日期,查询各科室洗手液、速干手消毒液的领用量
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.HandLiquidSrv","QryLocGetLiquid","2010-01-01","2012-09-10")
Query QryLocGetLiquid(SDate As %String, EDate As %String) As %Query(ROWSPEC = "LocDesc:%String,Type1Amount:%String,Type2Amount:%String,BedDays:%String,Type1Bed:%String,Type2Bed:%String,TotalBedDays:%String,LastTotalBedDays:%String") [ SqlProc ]
{
}

ClassMethod QryLocGetLiquidExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	set (SYear,SMonth,EYear,EMonth)=""
	
	s:SDate["-" SYear=$p(SDate,"-",1)
	s:SDate["-" SMonth=$p(SDate,"-",2)
	s:EDate["-" EYear=$p(EDate,"-",1)
	s:EDate["-" EMonth=$p(EDate,"-",2)
	s:SDate["/" SYear=$p(SDate,"/",1)
	s:SDate["/" SMonth=$p(SDate,"/",2)
	s:EDate["/" EYear=$p(EDate,"/",1)
	s:EDate["/" EMonth=$p(EDate,"/",2)

	set SYear=+$g(SYear)
	set LastSYear=SYear-1
	set SMonth=+$g(SMonth)
	set LastSMonth=SMonth-1
	set EYear=+$g(EYear)
	set LastEYear=EYear-1
	set EMonth=+$g(EMonth)
	set LastEMonth=EMonth-1
	set:SYear'="" SYear=" "_SYear-1
	set:SMonth'="" SMonth=" "_SMonth-1
	set ImportExcelID=""
	kill ^CacheTmp("QryLocGetLiquid")
	for {
		
		set SYear=$o(^DHCMed.NINF.Aim.HandLiquidINI("IndexOfDateTime",SYear))
		Quit:((SYear>EYear)||(SYear=""))
	 
		for {
			set SMonth=$o(^DHCMed.NINF.Aim.HandLiquidINI("IndexOfDateTime",SYear,SMonth))
			Quit:((SYear=EYear)&(SMonth>EMonth))
			Quit:SMonth=""
		
			set ImportExcelID=$o(^DHCMed.NINF.Aim.HandLiquidINI("IndexOfDateTime",SYear,SMonth,""),-1)			
			continue:ImportExcelID=""
			 
			set LocID=""
			for {
				set LocID=$o(^DHCMed.NINF.Aim.HandLiquidDepI("IndexOfImportDR"," "_ImportExcelID,LocID))
				Quit:LocID=""
				 
				set DepObj=##class(DHCMed.NINF.Aim.HandLiquidDep).GetObjById(LocID)
				q:'$IsObject(DepObj)
			 
				set DepCode=DepObj.DepCode
				set LocCode=$E(DepCode,0,18)
				set LocDesc=$e(DepCode,20,$length(DepCode))
				set LocDesc=$tr(LocDesc," ","")
				set LiquidId=""
				 
				for {
					set TypeThisAmount=""
					set TypeBfAmount=""
					set TypeAmount=""
					set LiquidId=$o(^DHCMed.NINF.Aim.HandLiquidUseI("IndexOfCTLocDR"," "_LocID,LiquidId))
					Quit:LiquidId=""
				 
					set LiquidUseID=$o(^DHCMed.NINF.Aim.HandLiquidUseI("IndexOfCTLocDR"," "_LocID,LiquidId,""))
					set LiquidUseObj=##class(DHCMed.NINF.Aim.HandLiquidUse).GetObjById(LiquidUseID)
					q:'$IsObject(LiquidUseObj)
				 
					set UseNum=LiquidUseObj.HandLiquidNum
				
					set LiquidDr=$tr(LiquidId," ","")
					set LiquidTypeObj=##class(DHCMed.NINF.Aim.HandLiquidType).GetObjById(LiquidDr)
					q:'$IsObject(LiquidTypeObj)
				  
					set HlVolume=LiquidTypeObj.HlVolume
					set HlVolume=+$g(HlVolume)
					set Type=LiquidTypeObj.Type
					quit:Type=""
				 
					set TypeThisAmount=HlVolume*UseNum
					set TypeBfAmount=$g(^CacheTmp("QryLocGetLiquid",LocDesc,Type))
					set TypeAmount=TypeThisAmount+TypeBfAmount
				 
					set ^CacheTmp("QryLocGetLiquid",LocDesc,Type)=TypeAmount
			
				}
			}
			
			
			}
	}
	set:LastSYear'="" LastSYear=" "_LastSYear-1
	set:LastSMonth'="" LastSMonth=" "_LastSMonth-1
	set ImportExcelID=""
	kill ^CacheTmp("LastQryLocGetLiquid")
	for {
		
		set LastSYear=$o(^DHCMed.NINF.Aim.HandLiquidINI("IndexOfDateTime",LastSYear))
		Quit:((LastSYear>LastEYear)||(LastSYear=""))
		
		for {
			set LastSMonth=$o(^DHCMed.NINF.Aim.HandLiquidINI("IndexOfDateTime",LastSYear,LastSMonth))
			Quit:((LastSYear=LastEYear)&(LastSMonth>LastEMonth))
			
			Quit:LastSMonth=""
		
			set ImportExcelID=$o(^DHCMed.NINF.Aim.HandLiquidINI("IndexOfDateTime",LastSYear,LastSMonth,ImportExcelID))			
			Continue:ImportExcelID=""
			set LocID=""
			for {
				set LocID=$o(^DHCMed.NINF.Aim.HandLiquidDepI("IndexOfImportDR"," "_ImportExcelID,LocID))
				Quit:LocID=""
				
				set DepObj=##class(DHCMed.NINF.Aim.HandLiquidDep).GetObjById(LocID)
				q:'$IsObject(DepObj)
				set DepCode=DepObj.DepCode
				set LocCode=$E(DepCode,0,18)
				set LocDesc=$e(DepCode,20,$length(DepCode))
				set LiquidId=""
				for {
					set TypeThisAmount=""
					set TypeBfAmount=""
					set TypeAmount=""
					set LiquidId=$o(^DHCMed.NINF.Aim.HandLiquidUseI("IndexOfCTLocDR"," "_LocID,LiquidId))
					Quit:LiquidId=""

					set LiquidUseID=$o(^DHCMed.NINF.Aim.HandLiquidUseI("IndexOfCTLocDR"," "_LocID,LiquidId,""))
					set LiquidUseObj=##class(DHCMed.NINF.Aim.HandLiquidUse).GetObjById(LiquidUseID)
					q:'$IsObject(LiquidUseObj)
					set UseNum=LiquidUseObj.HandLiquidNum
				
					set LiquidDr=$tr(LiquidId," ","")
					set LiquidTypeObj=##class(DHCMed.NINF.Aim.HandLiquidType).GetObjById(LiquidDr)
					q:'$IsObject(LiquidTypeObj)
				
					set HlVolume=LiquidTypeObj.HlVolume
					set HlVolume=+$g(HlVolume)
					set Type=LiquidTypeObj.Type
					quit:Type=""
					set TypeThisAmount=HlVolume*UseNum
					set TypeBfAmount=$g(^CacheTmp("LastQryLocGetLiquid",LocDesc,Type))
					set TypeAmount=TypeThisAmount+TypeBfAmount
				 
					set ^CacheTmp("LastQryLocGetLiquid",LocDesc,Type)=TypeAmount
			
				}
				}

			}
	}
	set LocDesc=""
	set Type1Amount="0"
	set Type2Amount="0"
	for {
		set LocDesc=$o(^CacheTmp("QryLocGetLiquid",LocDesc))
		quit:LocDesc=""
		set Type1Amount=$g(^CacheTmp("QryLocGetLiquid",LocDesc,1))
		set Type2Amount=$g(^CacheTmp("QryLocGetLiquid",LocDesc,2))
		set LastType1Amount=$g(^CacheTmp("LastQryLocGetLiquid",LocDesc,1))
		set LastType2Amount=$g(^CacheTmp("LastQryLocGetLiquid",LocDesc,2)) 
		set:Type1Amount="" Type1Amount="0"
		set:Type2Amount="" Type2Amount="0"
		set:LastType1Amount="" LastType1Amount="0"
		set:LastType2Amount="" LastType2Amount="0"
		//实际占用床日数按10000来统计
		set BedDays="10000"
		set Type1Bed=$fn(Type1Amount/10000,"",2)
		set Type2Bed=$fn(Type2Amount/10000,"",2)
		set LastType1Bed=$fn(LastType1Amount/10000,"",2)
		set LastType2Bed=$fn(LastType2Amount/10000,"",2)
		set TotalBedDays=Type1Bed+Type2Bed
		set LastTotalBedDays=LastType1Bed+LastType2Bed
		//b:LastTotalBedDays'=TotalBedDays
		set Data=$lb(LocDesc,Type1Amount,Type2Amount,BedDays,Type1Bed,Type2Bed,TotalBedDays,LastTotalBedDays)  
		s ^CacheTemp(repid,ind)=Data
		s ind=ind+1
		}
	Quit $$$OK
}

ClassMethod QryLocGetLiquidClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocGetLiquidExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocGetLiquidFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocGetLiquidExecute ]
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

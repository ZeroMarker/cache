/// 名称: DHCMed.INFService.EnvironmentSrv
/// 描述: 环境卫生学基本操作
/// 编写者：liuyh
/// 编写日期: 2011-10-27
Class DHCMed.INFService.EnvironmentSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2011-10-27
/// Description:  查询环境报告学信息
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.EnvironmentSrv","QueryEnviInfoByLocDate","","")
Query QueryEnviInfoByLocDate(CtlocID As %String, sRepDate As %String) As %Query(ROWSPEC = "rowid:%String,CtlocDR:%String,LocDesc:%String,RepDate:%String")
{
}

ClassMethod QueryEnviInfoByLocDateExecute(ByRef qHandle As %Binary, CtlocID As %String, sRepDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s:sRepDate["-" sRepDate=$zdh(sRepDate,3)
	s:sRepDate["/" sRepDate=$zdh(sRepDate,1)
	s LocID=""
	f  s LocID=$o(^DHCMed.INF.EnvironmentI("CtlocDR",LocID),-1) q:LocID=""  d
	.q:(CtlocID'="")&(CtlocID'=LocID)
	.s rowid=""
	.f  s rowid=$o(^DHCMed.INF.EnvironmentI("CtlocDR",LocID,rowid),-1) q:rowid=""  d
	..s obj=##class(DHCMed.INF.Environment).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s CtlocDR=obj.CtlocDR
	..s RepDate=obj.RepDate
	..q:(sRepDate'="")&(sRepDate'=RepDate)
	..s CtlocDRID=""
	..s:CtlocDR'="" CtlocDRID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CtlocDR,"EnviCtloc")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CtlocDRID)
    ..s:$IsObject(objDic) LocDesc=objDic.Description
	
	..s:RepDate'="" RepDate=$zd(RepDate,3)
	..s Data=$lb(rowid,CtlocDR,LocDesc,RepDate)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryEnviInfoByLocDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEnviInfoByLocDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEnviInfoByLocDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEnviInfoByLocDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2011-10-27
/// Description:  查询环境报告学子表信息
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.EnvironmentSrv","QueryEnviSubInfo","")
Query QueryEnviSubInfo(EnviID As %String) As %Query(ROWSPEC = "rowid:%String,EnviID:%String,EnviPath:%String,EnviPathDesc:%String,EnviPathValue:%String,ResumeText:%String")
{
}

ClassMethod QueryEnviSubInfoExecute(ByRef qHandle As %Binary, EnviID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	q:EnviID="" $$$OK
	q:'$d(^DHCMed.INF.EnvironmentSubI("EnviID",EnviID)) $$$OK
	s rowid=0
	f  s rowid=$o(^DHCMed.INF.EnvironmentSubI("EnviID",EnviID,rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.EnvironmentSub).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s EnviPath=obj.EnviPath
	.s EnviPathValue=obj.EnviPathValue
	.s ResumeText=obj.ResumeText
	.s EnviPathDR="",EnviPathDesc=""
	.s:EnviPath'="" EnviPathDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EnviPath,"EnviPath")
    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(EnviPathDR)
    .s:$IsObject(objDic) EnviPathDesc=objDic.Description
	.s Data=$lb(rowid,EnviID,EnviPath,EnviPathDesc,EnviPathValue,ResumeText)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryEnviSubInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEnviSubInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEnviSubInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEnviSubInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2011-11-28      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.EnvironmentSrv","QueryAllLocTypeMaping")
Query QueryAllLocTypeMaping() As %Query(ROWSPEC = "EnviMapID:%String,LocID:%String,LocDesc:%String,EnviType:%String,EnviTypeDesc:%String")
{
}

ClassMethod QueryAllLocTypeMapingExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s DicID=0
	f  s DicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," ENVICTLOC",DicID)) q:DicID=""  d
	.s objLoc=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
	.q:'$IsObject(objLoc)
	.s Active=objLoc.Active
	.q:Active'=1
	.s Code=objLoc.Code
	.s Description=objLoc.Description
	.s EnviMapID=$o(^DHCMed.INF.EnviLocTypeMapI("CtlocDR",Code,""))
	.s $li(data,1)=EnviMapID
	.s $li(data,2)=Code
	.s $li(data,3)=Description
	.s $li(data,4)=""
	.s $li(data,5)=""
	.i EnviMapID'="" d
	..s obj=##class(DHCMed.INF.EnviLocTypeMap).GetObjById(EnviMapID)
	..q:'$IsObject(obj)
	..s EnviType=obj.EnviType
	..s EnviTypeDR="",EnviTypeDesc=""
	..s:EnviType'="" EnviTypeDR=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(EnviType,"EnviType")
    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(EnviTypeDR)
    ..s:$IsObject(objDic) EnviTypeDesc=objDic.Description
	..s $li(data,4)=EnviType
	..s $li(data,5)=EnviTypeDesc
	.s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
	q $$$OK
}

ClassMethod QueryAllLocTypeMapingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllLocTypeMapingExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllLocTypeMapingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllLocTypeMapingExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.EnvironmentSrv","QueryDicInfoByCode")
Query QueryDicInfoByCode() As %Query(ROWSPEC = "rowid:%String,Code:%String,Description:%String")
{
}

ClassMethod QueryDicInfoByCodeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s sCode=""
	f  s sCode=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," ENVITYPE",sCode)) q:sCode=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCMed.SS.DictionaryI("IndexTypeCode"," ENVITYPE",sCode,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.SS.Dictionary).GetObjById(rowid)
	..q:'$IsObject(obj)
	..s Code=obj.Code
	..s Description=obj.Description
	..s $li(data,1)=rowid
	..s $li(data,2)=Code
	..s $li(data,3)=Description
	..s ^CacheTemp(repid,ind)=data
    ..s ind=ind+1
   
	q $$$OK
}

ClassMethod QueryDicInfoByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicInfoByCodeExecute ]
{
	Set repid=$li(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDicInfoByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicInfoByCodeExecute ]
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

/// Creator：     liuyh
/// CreatDate：   2011-10-27
/// Description:  查询环境报告学信息
/// Input
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.EnvironmentSrv","QueryEnviInfo","","","")
Query QueryEnviInfo(DateFrom As %String, DateTo As %String, CtlocID As %String, EnviStandard As %String) As %Query(ROWSPEC = "rowid:%String,LocDesc:%String,RepDate:%String,Res1:%String,Res2:%String,Res3:%String,Res4:%String,Res5:%String,ret:%String")
{
}

ClassMethod QueryEnviInfoExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtlocID As %String, EnviStandard As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateFrom["/" DateFrom=$zdh(DateFrom,1)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	s:DateTo["/" DateTo=$zdh(DateTo,1)
	s rowid=""
	f  s rowid=$o(^DHCMed.INF.EnvironmentD(rowid),-1) q:rowid=""  d
	.s obj=##class(DHCMed.INF.Environment).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s CtlocDR=obj.CtlocDR
	.q:(CtlocID'="")&(CtlocID'=CtlocDR)
	.s RepDate=obj.RepDate
	.q:(DateTo'="")&(RepDate>DateTo)
	.q:(DateFrom'="")&(RepDate<DateFrom)
	.s SubID=""
	.q:'$d(^DHCMed.INF.EnvironmentSubI("EnviID",rowid))
	.k ^TEMP("ENVI")
	.f  s SubID=$o(^DHCMed.INF.EnvironmentSubI("EnviID",rowid,SubID)) q:SubID=""  d
	..s SubObj=##class(DHCMed.INF.EnvironmentSub).GetObjById(SubID)
	..s EnviPath=SubObj.EnviPath
	..s EnviPathValue=SubObj.EnviPathValue
	..s ^TEMP("ENVI",EnviPath,SubID)=$i(^TEMP("ENVI",EnviPath))
	.s EnviPath="",(TotalScore1,TotalScore2,TotalScore3,TotalScore4,TotalScore5)=0
	.f  s EnviPath=$o(^TEMP("ENVI",EnviPath)) q:EnviPath=""  d
	..s EnviSubID="",TotalScore=0
	..f  s EnviSubID=$o(^TEMP("ENVI",EnviPath,EnviSubID)) q:EnviSubID=""  d
	...s SubObj=##class(DHCMed.INF.EnvironmentSub).GetObjById(EnviSubID)
	...s EnviPathValue=SubObj.EnviPathValue
	...i EnviPath=1 d
	....s:TotalScore1'=0 TotalScore1=TotalScore1+EnviPathValue
	....s:TotalScore1=0 TotalScore1=EnviPathValue
	...i EnviPath=2 d
	....s:TotalScore2'=0 TotalScore2=TotalScore1+EnviPathValue
	....s:TotalScore2=0 TotalScore2=EnviPathValue
	...i EnviPath=3 d
	....s:TotalScore3'=0 TotalScore3=TotalScore1+EnviPathValue
	....s:TotalScore3=0 TotalScore3=EnviPathValue
	...i EnviPath=4 d
	....s:TotalScore4'=0 TotalScore4=TotalScore1+EnviPathValue
	....s:TotalScore4=0 TotalScore4=EnviPathValue
	...i EnviPath=5 d
	....s:TotalScore5'=0 TotalScore5=TotalScore1+EnviPathValue
	....s:TotalScore5=0 TotalScore5=EnviPathValue
	.s StandardValue1=..GetStandardValue(CtlocDR,1)
	.s StandardValue2=..GetStandardValue(CtlocDR,2)
	.s StandardValue3=..GetStandardValue(CtlocDR,3)
	.s StandardValue4=..GetStandardValue(CtlocDR,4)
	.s StandardValue5=..GetStandardValue(CtlocDR,5)
	.s (AvgScore1,AvgScore2,AvgScore3,AvgScore4,AvgScore5)=0
	.s Num1=$g(^TEMP("ENVI",1))
	.s Num2=$g(^TEMP("ENVI",2))
	.s Num3=$g(^TEMP("ENVI",3))
	.s Num4=$g(^TEMP("ENVI",4))
	.s Num5=$g(^TEMP("ENVI",5))
	.s:+Num1'=0 AvgScore1=$fn(TotalScore1/+Num1,"",2)
	.s:+Num2'=0 AvgScore2=$fn(TotalScore2/+Num2,"",2)
	.s:+Num3'=0 AvgScore3=$fn(TotalScore3/+Num3,"",2)
	.s:+Num4'=0 AvgScore4=$fn(TotalScore4/+Num4,"",2)
	.s:+Num5'=0 AvgScore5=$fn(TotalScore5/+Num5,"",2)
	
	.s CtlocDRID=""
	.s:CtlocDR'="" CtlocDRID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(CtlocDR,"EnviCtloc")
    .s objDic=##class(DHCMed.SS.Dictionary).GetObjById(CtlocDRID)
    .s:$IsObject(objDic) LocDesc=objDic.Description	
	.s:RepDate'="" RepDate=$zd(RepDate,3)
	.s Res1=AvgScore1_"/"_StandardValue1
	.s Res2=AvgScore2_"/"_StandardValue2
	.s Res3=AvgScore3_"/"_StandardValue3
	.s Res4=AvgScore4_"/"_StandardValue4
	.s Res5=AvgScore5_"/"_StandardValue5
	.s (ComRes1,ComRes2,ComRes3,ComRes4,ComRes5)=""
	.s:+StandardValue1'=0 ComRes1=AvgScore1/StandardValue1
	.s:+StandardValue2'=0 ComRes2=AvgScore2/StandardValue2
	.s:+StandardValue3'=0 ComRes3=AvgScore3/StandardValue3
	.s:+StandardValue4'=0 ComRes4=AvgScore4/StandardValue4
	.s:+StandardValue5'=0 ComRes5=AvgScore5/StandardValue5
	.s ret=0
	.s:(ComRes1>1)||(ComRes2>1)||(ComRes3>1)||(ComRes4>1)||(ComRes5>1) ret=1
	.q:(EnviStandard'="")&(ret'=EnviStandard)	//EnviStandard=0：达标 1：不达标
	.s Data=$lb(rowid,LocDesc,RepDate,Res1,Res2,Res3,Res4,Res5,ret)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1

	Quit $$$OK
}

ClassMethod QueryEnviInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEnviInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEnviInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEnviInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 描述：通过科室ID、监测标本代码 取标准值
/// 调试：w ##class(DHCMed.INFService.EnvironmentSrv).GetStandardValue(1,1)
ClassMethod GetStandardValue(LocID As %String, EnviPathCode As %String) As %String
{
	
	n (LocID,EnviPathCode)
	
	s ret=-1,EnviType=3		//默认为Ⅲ类
	q:(LocID="")||(EnviPathCode="") ret
	
	i $d(^DHCMed.INF.EnviLocTypeMapI("CtlocDR",LocID)) d
	.s rowid=$o(^DHCMed.INF.EnviLocTypeMapI("CtlocDR",LocID,""),-1)
	.s obj=##class(DHCMed.INF.EnviLocTypeMap).GetObjById(rowid)
	.q:'$IsObject(obj)
	.s EnviType=obj.EnviType
	s EnviTypeScoreStr=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("EnviTypeScore")
	q:EnviTypeScoreStr="" ret
	
	s EnviTypeScore=$p(EnviTypeScoreStr,"||",EnviType)
	q:EnviTypeScore="" ret
	
	s val=$p(EnviTypeScore,"-",EnviPathCode)
	
	q val
}

/// w ##Class(DHCMed.INFService.EnvironmentSrv).GetEnviInfo("fillxlSheet","^^^^")
ClassMethod GetEnviInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
	s Count=0
	 
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s CtlocID=$p(strArguments,"^",3)
	s EnviStandard =$p(strArguments,"^",4)

	s ds = ##class(%Library.ResultSet).%New("DHCMed.INFService.EnvironmentSrv:QueryEnviInfo")
	d ds.Execute(DateFrom,DateTo,CtlocID,EnviStandard)
	s StartRow=4
	while(ds.Next())
	{
		s rowid=ds.Data("rowid")
		s LocDesc=ds.Data("LocDesc")
		s RepDate=ds.Data("RepDate")
		s Res1=ds.Data("Res1")
		s Res2=ds.Data("Res2")
		s Res3=ds.Data("Res3")
		s Res4=ds.Data("Res4")
		s Res5=ds.Data("Res5")
		s ret=ds.Data("ret")
		s valCells=LocDesc_$c(1)_RepDate_$c(1)_Res1_$c(1)_Res2_$c(1)_Res3
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	q Count
}

}

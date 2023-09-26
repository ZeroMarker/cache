Import SQLUser

Class web.CSSDHUI.Stat.ExpireQueryStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Descript:过期包查询
/// Creator:lxt
/// CreateDate:20221117
/// Table:CSSD_Trans
/// Input:查询条件
/// Return：过期包数据
/// d ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.ExpireQueryStat","GetExpiredPkgs",^templxt("GetExpiredPkgs"))
Query GetExpiredPkgs(Params As %Text) As web.CSSDHUI.Query(ROWSPEC = "TransId:%Integer,Label,PkgId,PkgDesc,AttributeId,AttributeDesc,Status,StatusDesc,CurLocId,CurLocDesc,PackDate,ExpDate,MinusDate,DealDate,DealTime,DealUserId,DealUserName,DealCleanDetailId,DealCleanNo") [ SqlProc ]
{
}

ClassMethod GetExpiredPkgsExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s CurDate=$p($h,",",1)
	s PJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s PTxtDays=+PJObj.%Get("TxtDays")
	s PLocationLocId=PJObj.%Get("LocationLoc")
	s PLabel=PJObj.%Get("Label")
	s PStartDate=PJObj.%Get("StartDate")
	s PPkgStatus=PJObj.%Get("Status")
	s PStartDate=..DH2L(PStartDate)
	
	s DeptCenterId=$o(^User.CSSDDeptCenterI("CSSDDLocIndex",gLocId,""))
	f Date=PStartDate:1:CurDate d
	.s TransId=0
	.f  s TransId=$o(^User.CSSDTransI("IndexCSSDTDate",Date,TransId)) q:TransId=""  d
	..s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
	..d TransObj.%Reload()
	..q:'$IsObject(TransObj)
	..s PackDate=TransObj.CSSDTDate
	..s ExpDate=TransObj.CSSDTExpDate
	..s Status=TransObj.CSSDTStatus
	..s Label=TransObj.CSSDTLabel
	..s PackObj=TransObj.CSSDTPack
	..s DispObj=TransObj.CSSDTDisp
	..s PkgObj=TransObj.CSSDTPackage
	..s DealDate=TransObj.CSSDTExpDealDate
	..s DealTime=TransObj.CSSDTExpDealTime
	..s DealUserObj=TransObj.CSSDTExpDealUserDr
	..s DealCleanDetailObj=TransObj.CSSDTExpDealCleanDetailDr
	..q:Status="C"	//回收
	..q:((PLabel'="")&&(PLabel'=Label))
	..; PPkgStatus:0 全部 1已过期 2已处理 3已灭菌 4未发放 5已发放
	..q:(PPkgStatus="0")&&(ExpDate>(CurDate+PTxtDays))
	..q:(PPkgStatus="1")&&((Status="TC")||(ExpDate>CurDate))
	..q:(PPkgStatus="2")&&(Status'="TC")
	..q:(PPkgStatus="3")&&((ExpDate>(CurDate+PTxtDays))||(Status'="S"))
	..q:(PPkgStatus="4")&&(($IsObject(DispObj))||(Status="TC")||((PTxtDays'=0)&&(ExpDate>(CurDate+PTxtDays)))||(ExpDate-CurDate<=0))
	..q:(PPkgStatus="5")&&(('$IsObject(DispObj))||((PTxtDays'=0)&&(ExpDate>(CurDate+PTxtDays))))
	..q:(PTxtDays>0)&&(ExpDate<CurDate)&&((PPkgStatus="0")||(PPkgStatus="3")||(PPkgStatus="4")||(PPkgStatus="5"))
	..
	..s PkgId=PkgObj.%Id()
	..s PkgDesc=PkgObj.CSSDPDesc
	..s AttributeId=PkgObj.CSSDPPackTypeDetail	//属性
	..s ShowDataFlag =##class(web.CSSDHUI.HospMap).GetShowDataFlag("CSSD_Package",PkgId,gHospId)
	..q:ShowDataFlag="N"
	..
	..s CurLocId=""
	..s PackLocId=PackObj.CSSDPPLocDrGetObjectId()
	..i $IsObject(DispObj) d
	...s CurLocId=DispObj.CSSDPDParrefDr.CSSDPDMToLocDrGetObjectId()
	..e  d
	...s CurLocId=PackLocId
	..q:((DeptCenterId="")&&(CurLocId'=gLocId))	;非供应中心的,只取本科室
	..q:((DeptCenterId'="")&&(PackLocId'=gLocId))	//登录科室为供应室，且打包科室不是当前科室的
	..q:((PLocationLocId'="")&&(DeptCenterId'="")&&(PLocationLocId'=CurLocId))	//查询科室不为空时，按查询科室和所在科室查询
	..
	..s (CurLocDesc,DealUserId,DealUserName,DealCleanDetailId,DealCleanNo)=""
	..i AttributeId=1 s PkgDesc=##Class(web.CSSDHUI.Common.PackageInfoCommon).GetCodeDictName(Label)
	..s CurLocDesc=$p(^CTLOC(CurLocId),"^",2)
	..s AttributeDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetPackageDetailDesc(AttributeId)
	..s StatusDesc=##class(web.CSSDHUI.Common.PackageInfoCommon).GetStatusChinese(Status)
	..s DealDate=..DL2H(DealDate)
	..s DealTime=..TL2H(DealTime)
	..i $IsObject(DealUserObj) d
	...s DealUserId=DealUserObj.%Id()
	...s DealUserName=DealUserObj.SSUSRName
	..i $IsObject(DealCleanDetailObj) d
	...s DealCleanDetailId=DealCleanDetailObj.%Id()
	...s DealCleanNo=DealCleanDetailObj.CSSDCDPCleanMain.CSSDCNo
	..s MinusDate=ExpDate-CurDate
	..s ExpDate=..DL2H(ExpDate)
	..s PackDate=..DL2H(PackDate)
	..d OutputRowExpire
	
	q $$$OK
OutputRowExpire
	s Data=$lb(
		TransId,Label,PkgId,PkgDesc,AttributeId,AttributeDesc,
		Status,StatusDesc,CurLocId,CurLocDesc,PackDate,ExpDate,MinusDate,
		DealDate,DealTime,DealUserId,DealUserName,DealCleanDetailId,DealCleanNo
		)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Creator:why
/// CreatDate:2020.4.21
/// Description:处理过期包
/// Table:CSSD_Trans
/// Input:Params
/// Output:
/// Return:RtnObj
/// others:
/// w ##class(web.CSSDHUI.Stat.ExpireQueryStat).Exp("[{""steDate"":""66024"",""expDate"":""2021-10-14"",""label"":""00032021100700001"",""pkgId"":""3"",""statusDesc"":""已灭菌"",""minusDate"":""0"",""PkgDesc"":""骨科小标牌追溯包"",""packTypeDetail"":""非标牌追溯包"",""curloc"":""供应中心无菌区"",""expDealDate"":"""",""expDealTime"":"""",""expDealUserName"":""""}]","{""LocationLoc"":"""",""gUserId"":""15030"",""gLocId"":""37"",""gGroupId"":""363"",""gHospId"":""2"",""chkDisped"":"""",""chkUnDisped"":""on"",""chkWillOverDate"":"""",""chkHasExpired"":"""",""chkHasDeal"":"""",""txtDays"":""2""}")
ClassMethod jsExpDeal(Main As %String, Detail As %String) As %String [ SqlProc ]
{
	n (Main,Detail)
	s $ZT=..sssError()
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	ts
	s RtnObj=..ExpDeal(Main,Detail)
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

ClassMethod ExpDeal(Main As %String, Detail As %String) As web.CSSDHUI.RtnObj
{
	n (Main,Detail)
	s MethodName=$ClassName()_"Exp"
	s RtnObj=##class(web.CSSDHUI.RtnObj).%New()
	
	s MPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=MPJObj.%FromJSON(Main)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败:"_MethodName)
	s gLocId=MPJObj.%Get("PoLoc")
	s gUserId=MPJObj.%Get("gUserId")
	s gGroupId=MPJObj.%Get("gGroupId")
	s gHospId=MPJObj.%Get("gHospId")
	
	s DPJObj=##class(web.CSSDHUI.Common.FromJson).%New()
	s Sc=DPJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-2,"","入参解析失败!:"_MethodName)
	
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	
	while(RtnObj.success=0){
		s Obj=DPJObj.%Pop()
		q:Obj=""
		s Label=Obj.%Get("Label")
		s TransId=Obj.%Get("TransId")
		s MinusDate=Obj.%Get("MinusDate")
		
		i MinusDate>0 d RtnObj.Err(-2,"","该包未过期，不能做过期处理！","",0)
		q:RtnObj.success'=0
		
		s Status=Obj.%Get("Status")
		i Status="TC" d RtnObj.Err(-1,"","存在已过期处理的包，请核对！","",0)
		q:RtnObj.success'=0
		
		s TransObj=##class(User.CSSDTrans).%OpenId(TransId)
		d TransObj.%Reload()
		s CodeDict=TransObj.CSSDTCodeDict
		s IsExt=TransObj.CSSDTPackage.CSSDPIsExt
		s MaxRowId=""
		i CodeDict'="" d
		.i IsExt="Y" d
		..s CodeLength=$l(CodeDict)
		..s NewLabel=$e(Label,1,CodeLength+6)	;标牌编码号加上6位流水号
		..&sql(select max(cssdt_rowid) into :MaxRowId from cssd_trans where CSSDT_CodeDict=:CodeDict)
		..s MaxTransObj=##class(User.CSSDTrans).%OpenId(MaxRowId)
		..d MaxTransObj.%Reload()
		..s MaxLabel=MaxTransObj.CSSDTLabel
		..s MaxNewLabel=$e(MaxLabel,1,CodeLength+6)
		..i NewLabel'=MaxNewLabel d RtnObj.Err(-1,"","当前标签不是该标牌追溯包对应最新标签，不能进行过期处理","",0)
		.e  d
		..&sql(select max(cssdt_rowid) into :MaxRowId from cssd_trans where CSSDT_CodeDict=:CodeDict)
		..i TransId'=MaxRowId d RtnObj.Err(-1,"","当前标签不是该标牌追溯包对应最新标签，不能进行过期处理","",0)
		q:RtnObj.success'=0
		
		&sql(update CSSD_Trans set CSSDT_Status='TC',CSSDT_ExpDealDate=:CurDate,CSSDT_ExpDealTime=:CurTime,CSSDT_ExpDealUser_DR=:gUserId where CSSDT_Rowid=:TransId)
		i SQLCODE'=0 d RtnObj.Err(-3,"","过期处理失败！")
		q:RtnObj.success'=0
	}
	
	q RtnObj
}

}

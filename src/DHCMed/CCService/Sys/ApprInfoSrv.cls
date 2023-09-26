/// 评价管理
Class DHCMed.CCService.Sys.ApprInfoSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

//w ##class(DHCMed.CCService.Sys.ApprInfoSrv).SaveApprInfo()

ClassMethod SaveApprInfo(SubjectID, paadmStoreRepid, SubjectItmIDList, EvalInfo, EvalUser, EvalLoc, EvalDate, EvalTime)
{
	n (SubjectID, paadmStoreRepid, SubjectItmIDList, EvalInfo, EvalUser, EvalLoc, EvalDate, EvalTime)
	
	Set:EvalDate["-" EvalDate=$zdh(EvalDate,3)
	Set:EvalDate["/" EvalDate=$zdh(EvalDate,4)
	Set EvalDate=+EvalDate
	Set:EvalTime[":" EvalTime=$zth(EvalTime,1)
	
	Set ret=##class(DHCMed.CCService.System.VM).Process(SubjectID,paadmStoreRepid,SubjectItmIDList)
	Quit:$li(ret,1)'="OK" ret
	
	s handle=$li(ret,2)
	Set Paadm=""
	For {
		Set Paadm=$o(^CacheTemp(handle,"Paadm",Paadm))
		Quit:Paadm=""
		Set result=$g(^CacheTemp(handle,"Paadm",Paadm))
		Set TotalScore=$p(result,"^",1)
		Set FireCnt=$p(result,"^",2)
		Set FireTypeCnt=$p(result,"^",3)
		
		Set objApp=##class(DHCMed.CC.Evaluation).%New()
		Set objApp.SubjectDr=SubjectID
		Set objApp.PaadmDr=Paadm
		Set objApp.EvalDate=$s(EvalDate=0:+$h,1:EvalDate)
		Set objApp.EvalTime=$s(EvalTime=0:$p($h,",",2),1:EvalTime)
		Set objApp.EvalUser=EvalUser
		Set objApp.EvalLoc=EvalLoc
		Set objApp.EvalInfo=EvalInfo
		Set objApp.IsActive=1
		Set objApp.Resume=""
		Set objApp.SubjectItmIDList=SubjectItmIDList
		Set objApp.Score=TotalScore
		Set objApp.FiredCount=FireCnt
		Set objApp.FiredTypeCount=FireTypeCnt
		d objApp.%Save()
		d objApp.%Close()
		Set AppID=objApp.%Id()
		Set ItemDic=""
		For {
			Set ItemDic=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",ItemDic))
			Quit:ItemDic=""
			Set Index=""
			For {
				Set Index=$o(^CacheTemp(handle,"Paadm",Paadm,"Detail",ItemDic,Index))
				Quit:Index=""
				Set objAppDetail=##class(DHCMed.CC.EvaluationDetail).%New()
				Set objAppDetail.Parref=AppID
				Set objAppDetail.ItemDic=ItemDic
				Set objAppDetail.ItemDetail=$g(^CacheTemp(handle,"Paadm",Paadm,"Detail",ItemDic,Index))
				d objAppDetail.%Save()
				d objAppDetail.%Close()
			}
		}
		
	}
	Kill ^CacheTemp(paadmStoreRepid)
	Kill ^CacheTemp(handle)
	Quit $lb("OK")
}

// w ##class(DHCMed.CCService.Sys.ApprInfoSrv).WriteApprInfo(522)

ClassMethod WriteApprInfo(ID)
{
	n (ID)
	Set objApp=##class(DHCMed.CC.Evaluation).%OpenId(ID)
	Quit:$IsObject(objApp)=0
	Do objApp.%Close()
	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,"Paadm",objApp.PaadmDr)=objApp.Score_"^"_objApp.FiredCount_"^"_objApp.FiredTypeCount
	Set RowID=""
	For {
		Set RowID=$o(^DHCMed.CCi("IApprDtl",0,"ParrefIndex",ID,RowID))
		Quit:RowID=""
		Set objDetail=##class(DHCMed.CC.EvaluationDetail).%OpenId(RowID)
		Continue:$IsObject(objDetail)=0
		Do objDetail.%Close()
		Set objItemDic=##class(DHCMed.CC.ItemDic).%OpenId(objDetail.ItemDic)
		Do objItemDic.%Close()
		Set Index=$o(^CacheTemp(repid,"Paadm",objApp.PaadmDr,"Detail",objDetail.ItemDic,""),-1)
		Set Index=Index+1
		Set ^CacheTemp(repid,"Paadm",objApp.PaadmDr,"Detail",objDetail.ItemDic,Index)=objDetail.ItemDetail
		Set ^CacheTemp(repid,"Paadm",objApp.PaadmDr,"type",objItemDic.IDSubCatDr)=$g(^CacheTemp(repid,"Paadm",objApp.PaadmDr,"type",objItemDic.IDSubCatDr))+1
		Set ^CacheTemp(repid,"Paadm",objApp.PaadmDr,objDetail.ItemDic)=objItemDic.IDDesc
	}
	Quit repid
}

ClassMethod EvalSinglePerson(SubjectID, Paadm, SubjectItmIDList, EvalInfo, EvalUser, EvalLoc, EvalDate, EvalTime)
{
	n (SubjectID, Paadm, SubjectItmIDList, EvalInfo, EvalUser, EvalLoc, EvalDate, EvalTime)
	Set repid=$I(^CacheTemp)
	do ##class(DHCMed.CCService.System.VMShell).SaveStorePaadm(repid,Paadm)
	Quit ..SaveApprInfo(SubjectID, repid, SubjectItmIDList, EvalInfo, EvalUser, EvalLoc, EvalDate, EvalTime)
}

//w ##class(DHCMed.CCService.Sys.ApprInfoSrv).Test()

ClassMethod Test()
{
	Set PaadmStoreID=##class(DHCMed.EPDService.Control).CreatePaadmList("2008-08-01","2008-08-01",1)
	Set result=..SaveApprInfo(3,PaadmStoreID,"","AppInfo~~~",1,1,"","")
	Quit result
}

}

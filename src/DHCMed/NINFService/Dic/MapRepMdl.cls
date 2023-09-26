/// 名称: DHCMed.NINFService.Dic.MapRepMdl
/// 描述: 报告分类与模块映射
/// 编写者：zhufei
/// 编写日期: 2012-06-26
Class DHCMed.NINFService.Dic.MapRepMdl Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  取报告对应模块
/// Table：       DHCMed.NINF.Rep.MapRepMdl
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.MapRepMdl).GetInfRepMdl(4395)
ClassMethod GetInfRepMdl(aRepTypeID As %String) As %String
{
	New (aRepTypeID)
	Set return=""
	Quit:aRepTypeID="" return
	
	Set ModuleList="BASE,INFPOS,OPR,LAB,ANTI"  //其他报告
	Set objRepCat=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFReportCateg","Inf","")
	If $IsObject(objRepCat) {
		Set RepCatID=objRepCat.%Id()
		Set RowID=$o(^DHCMed.NINFDi("MapRepMdl",0,"IndexCategType",RepCatID,aRepTypeID,0))
		Set objRec=##class(DHCMed.NINF.Dic.MapRepMdl).GetObjById(RowID)
		If $IsObject(objRec) {
			Set ModuleList=objRec.ModuleList   //NICU报告 "NICU,LAB"
		}
	}
	Set ModuleList=$tr(ModuleList,",","^")
	Set return=ModuleList
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  取报告对应模块
/// Table：       DHCMed.NINF.Rep.MapRepMdl
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.MapRepMdl).GetAimRepMdl(130)
ClassMethod GetAimRepMdl(aLocID As %String) As %String
{
	New (aLocID)
	Set return=""
	Quit:aLocID="" return
	
	Set ModuleList="UC,PICC,VAP,OPR,MDR"  //其他科室
	Set objRepCat=##Class(DHCMed.SS.Dictionary).GetByTypeCode("NINFReportCateg","Aim","")
	If $IsObject(objRepCat) {
		Set RepCatID=objRepCat.%Id()
		Set RowID=$o(^DHCMed.NINFDi("MapRepMdl",0,"IndexCategLoc",RepCatID,aLocID,0))
		Set objRec=##class(DHCMed.NINF.Dic.MapRepMdl).GetObjById(RowID)
		If $IsObject(objRec) {
			Set ModuleList=objRec.ModuleList  //儿科 "MDR^NICU"
		}
	}
	Set ModuleList=$tr(ModuleList,",","^")
	Set return=ModuleList
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  取报告对应模块
/// Table：       DHCMed.NINF.Rep.MapRepMdl
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.MapRepMdl).GetAimModules(3966770)
ClassMethod GetAimModules(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	
	Set $ZT="GetAimModulesErr"
	
	Set ModuleList="UC^PICC^VAP^OPR^MDR"
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set AdmLocID=$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set AdmLocDesc=$p($g(^CTLOC(+AdmLocID)),"^",2)
	//Set AdmDate=$p($g(^PAADM(+aEpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(+aEpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	If AdmLocDesc["儿科" {
		Set Birthday=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
		Set:Birthday'="" Birthday=$zd(Birthday,3)
		
		//update by zf 20150228 统一调用年龄计算方法
		//Set AdmDate=$p($g(^PAADM(+aEpisodeID)),"^",6)
		//Set AdmTime=$p($g(^PAADM(+aEpisodeID)),"^",7)
		//upadte by pylian 2016-02-18 修改入院时间取值方式
    	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(+aEpisodeID)
		Set AdmDate=$p(AdmDateTime,"^",1)
		Set AdmTime=$p(AdmDateTime,"^",2)
		Set ageData=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PAPMIRowId,aEpisodeID,AdmDate,AdmTime)	//返回值为“*岁*月*天”
		set AgeYear=0,AgeMonth=0,AgeDay=0
		if ageData["岁" {
			set AgeYear=+ageData
		} else {
			if ageData["月" {
				set AgeMonth=+ageData
				set AgeDay=+$p(ageData,"月",2)
			} else {
				set AgeDay=+ageData
			}
		}
		If (AgeYear<1)&&(AgeMonth<1)&&(AgeDay<29){
			Set ModuleList="MDR^NICU"
		}
	}
	Set return=ModuleList
	Quit return
	
GetAimModulesErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  保存报告分类模块对照
/// Table：       DHCMed.NINF.Rep.MapRepMdl
/// Input：       aRepTypeCode : 报告类型代码
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.MapRepMdl).SaveMapRec("1^5242^^5070^BASE,INFPOS,OPR,LAB,ANTI","^")
ClassMethod SaveMapRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	
	Set $ZT="SaveMapRecErr"
	
	Set RowID=$p(aInput,aSeparate,1)
	Set RepCat=$p(aInput,aSeparate,2)
	Set RepLoc=$p(aInput,aSeparate,3)
	Set RepType=$p(aInput,aSeparate,4)
	Set ModuleList=$p(aInput,aSeparate,5)
	Quit:(RepCat="")||(ModuleList="") return
	Quit:(RepLoc="")&&(RepType="") return
	
	Set return=-100
	If (RepLoc'="") {
		Set xRowID=0,IsError=0
		For {
			Set xRowID=$o(^DHCMed.NINFDi("MapRepMdl",0,"IndexCategLoc",RepCat,RepLoc,xRowID))
			Quit:xRowID=""
			Continue:(RowID'="")&&(RowID=xRowID)
			Set IsError=1
		}
		Quit:IsError=1 return
	}
	
	Set return=-200
	If (RepType'="") {
		Set xRowID=0,IsError=0
		For {
			Set xRowID=$o(^DHCMed.NINFDi("MapRepMdl",0,"IndexCategType",RepCat,RepType,xRowID))
			Quit:xRowID=""
			Continue:(RowID'="")&&(RowID=xRowID)
			Set IsError=1
		}
		Quit:IsError=1 return
	}
	
	Set return=##Class(DHCMed.NINF.Dic.MapRepMdl).Update(aInput,aSeparate)
	
	Quit return
	
SaveMapRecErr
	Quit "-999"
}

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  报告分类与模块映射
/// Table：       DHCMed.NINF.Dic.MapRepMdl
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.MapRepMdl","QryMapRepMdl")
Query QryMapRepMdl() As %Query(ROWSPEC = "RowID:%String,RepCatID:%String,RepCatDesc:%String,RepLocID:%String,RepLocDesc:%String,RepTypeID:%String,RepTypeDesc:%String,ModuleList:%String")
{
}

ClassMethod QryMapRepMdlExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ID=0
 	For {
	 	Set ID=$o(^DHCMed.NINFD("MapRepMdl",ID))
	 	Quit:ID=""
	 	
	 	Set obj=##class(DHCMed.NINF.Dic.MapRepMdl).GetObjById(ID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set (RepCatID,RepCatDesc,RepLocID,RepLocDesc,RepTypeID,RepTypeDesc,ModuleList)=""
	 	
	 	If $IsObject(obj.RepCat) {
			Set RepCatID=obj.RepCat.%Id()
			Set RepCatDesc=obj.RepCat.Description
		}
		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(obj.RepLoc)
		If $IsObject(objLoc) {
			Set RepLocID=objLoc.Rowid
			Set RepLocDesc=objLoc.Descs
		}
		If $IsObject(obj.RepType) {
			Set RepTypeID=obj.RepType.%Id()
			Set RepTypeDesc=obj.RepType.Description
		}
		Set ModuleList=obj.ModuleList
		
		Set Data=$lb(ID,RepCatID,RepCatDesc,RepLocID,RepLocDesc,RepTypeID,RepTypeDesc,ModuleList)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMapRepMdlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapRepMdlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMapRepMdlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapRepMdlExecute ]
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

Import DHCMed.EPD

/// 创建者：李阳
/// 创建日期：2011-06-10
/// 功能：存储传染病字典项目
Class DHCMed.EPDService.InfectionSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 查询传染病疾病字典
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryInfection","","")
Query QryInfection(argAlias As %String, argID As %String) As %Query(ROWSPEC = "RowID:%String,ICD:%String:ICD,MIFDisease:%String:疾病名称,MIFKind:%String:类别,MIFRank:%String:等级,MIFAppendix:%String:传染病附卡,MIFMulti:%String:多次患病,MIFDependence:%String:MIFDependence,MIFTimeLimit:%String:上报时限,MIFResume:%String:备注") [ SqlProc ]
{
}

ClassMethod QryInfectionExecute(ByRef qHandle As %Binary, argAlias As %String, argID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set aIFKind=""
	If argID'="" {
		Set objDic=##class(DHCMed.EPD.Infection).GetObjById(argID)
		If $IsObject(objDic){
			Set aIFKind=objDic.MIFKind
		}
		Set argAlias=""
	}
	
	Set argAlias=$ZConvert(argAlias,"T")
	Set IFRowid=0,EpdIFList=""
	For {
		Set IFRowid=$o(^DHCMed.EPDC("IF",IFRowid))
		Quit:IFRowid=""
		Set objIF=##class(DHCMed.EPD.Infection).GetObjById(IFRowid)
		Continue:'$IsObject(objIF)
		Continue:objIF.MIFIsActive'="Y"
		
		Set IFICD=objIF.MIFICD
		Set IFDesc=objIF.MIFDisease
		
		Set:IFDesc'="" IFDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.EPD.Infection","MIFDisease","",IFDesc)
		//关键字和别名过滤
		Set IsEff="N"
		If (argAlias'=""){
			Set:($ZConvert(IFDesc,"T")[argAlias) IsEff="Y"
			If IsEff'="Y" {
				Set aliasRowid=0
				For {
					Set aliasRowid=$o(^DHCMed.EPDC("IF",IFRowid,"InfAlias",aliasRowid))
					Quit:(aliasRowid="")||(IsEff="Y")
					Set tmpAlias=$g(^DHCMed.EPDC("IF",IFRowid,"InfAlias",aliasRowid))
					Set tmpAlias=$p(tmpAlias,"^",1)
					Set:($ZConvert(tmpAlias,"T")[argAlias) IsEff="Y"
				}
			}
		}
		Continue:(argAlias'="")&&(IsEff'="Y")
		
		Set IFKind=objIF.MIFKind
		Continue:(aIFKind'="")&&(aIFKind'=IFKind)  //不符合类别,过滤
		If IFKind'="" {
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,1)
			If $IsObject(objDic){
				Set IFKind=objDic.Description
			}
		}
		Set IFRank=objIF.MIFRank
		If IFRank'="" {
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",IFRank,1)
			If $IsObject(objDic){
				Set IFRank=objDic.Description
			}
		}
		Set IFAppendix=objIF.MIFAppendix
		If IFAppendix'="" {
			Set objAppendix=##class(DHCMed.EPD.AppendixCard).GetObjById(IFAppendix)
			If $IsObject(objAppendix){
				Set IFAppendix=objAppendix.MACDesc
			}
		}
		Set IFMulti=$s(objIF.MIFMulti="Y":"是",1:"否")
		Set IFDependence=$s(objIF.MIFDependence="Y":"是",1:"否")
		Set IFTimeLimit=objIF.MIFTimeLimit
		If IFTimeLimit'="" {
			Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTTIMELIMIT",IFTimeLimit,1)
			If $IsObject(objDic){
				Set IFTimeLimit=objDic.Description
			}
		}
		Set IFResume=objIF.MIFResume
		
		Set Data=$lb(IFRowid,IFICD,IFDesc,IFKind,IFRank,IFAppendix,IFMulti,IFDependence,IFTimeLimit,IFResume)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInfectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfectionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfectionExecute ]
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

/// 通过RowID取得别名列表
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryAliasByRowID",165)
Query QryAliasByRowID(Parref As %String) As %Query(ROWSPEC = "RowID:%String,Alias:%String:别名,IsKeyWord:%String,IsKeyWordDesc:%String")
{
}

ClassMethod QryAliasByRowIDExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)	
	
	Set ZIndex=$zn,JIndex=$j
	Kill ^TMP(ZIndex,JIndex,"QryAliasByRowID")
	Set ChildSub=0
	For {
		Set ChildSub=$o(^DHCMed.EPDC("IF",Parref,"InfAlias",ChildSub))
		Quit:ChildSub=""
		Set objAlias=##class(DHCMed.EPD.InfectionAlias).GetObjById(Parref_"||"_ChildSub)
		Continue:'$IsObject(objAlias)
		Set IsKeyword=objAlias.MIFAIsKeyword
		Set ^TMP(ZIndex,JIndex,"QryAliasByRowID",+IsKeyword,Parref_"||"_ChildSub)=""
	}
	
	Set IsKeyWord=""
	For {
		Set IsKeyWord=$o(^TMP(ZIndex,JIndex,"QryAliasByRowID",IsKeyWord))
		Quit:IsKeyWord=""
		Set IsKeyWordDesc=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDINFALIASTYPE",IsKeyWord,"")
		If $IsObject(objDic){
			Set IsKeyWordDesc=objDic.Description
		}
		Set Rowid=""
		For {
			Set Rowid=$o(^TMP(ZIndex,JIndex,"QryAliasByRowID",IsKeyWord,Rowid))
			Quit:Rowid=""
			Set objAlias=##class(DHCMed.EPD.InfectionAlias).GetObjById(Rowid)
			Continue:'$IsObject(objAlias)
			Set AliasDesc=objAlias.MIFAAlias
			
			Set Data=$lb(Rowid,AliasDesc,IsKeyWord,IsKeyWordDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(ZIndex,JIndex,"QryAliasByRowID")
	
	Quit $$$OK
}

ClassMethod QryAliasByRowIDClose(ByRef qHandle As %Binary, Parref As %String) As %Status [ PlaceAfter = QryAliasByRowIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAliasByRowIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAliasByRowIDExecute ]
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

/// 查询传染病疾病字典
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.EPDService.InfectionSrv","QryIFList","","","","","","","ture","false")
Query QryIFList(aICD As %String, aName As %String, aKind As %String, aRank As %String, aAppendixID As %String, aTimeLimit As %String, aMulti As %String, aWork As %String, aReport As %String, aChronic As %String) As %Query(ROWSPEC = "RowID:%String,ICD:%String:ICD,MIFDisease:%String:疾病名称,MIFKind:%String:类别,MIFRank:%String:等级,MIFAppendix:%String:传染病附卡,MIFMulti:%String:多次患病,MIFDependence:%String:MIFDependence,MIFTimeLimit:%String:上报时限,MIFResume:%String:备注,MIFIsActive:%String,MIFIsForce:%String,MIFIsChronic:%String")
{
}

ClassMethod QryIFListExecute(ByRef qHandle As %Binary, aICD As %String, aName As %String, aKind As %String, aRank As %String, aAppendixID As %String, aTimeLimit As %String, aMulti As %String, aWork As %String, aReport As %String, aChronic As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set RowID=0
	Set:aMulti'="" aMulti=$s(aMulti="true":"是",aMulti="false":"否",1:"")
	Set:aWork'="" aWork=$s(aWork="true":"是",aWork="false":"否",1:"")
	For {
		Set RowID=$o(^DHCMed.EPDC("IF",RowID))
		Quit:RowID=""
		Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(RowID)
		Continue:'$IsObject(objInf)
		//Continue:objInf.MIFIsActive'="Y"
		
		Set IFRowID=objInf.%Id()
		Set IFICD=objInf.MIFICD
		Continue:(aICD'="")&&($ZCVT($g(IFICD),"U")'[$ZCVT($g(aICD),"U"))
		Set IFName=objInf.MIFDisease
		Continue:(aName'="")&&(IFName'[aName) //Modified By LiYang 2012-03-13 FixBug:37 传染病管理-传染病字典维护-【传染病名称】和【上报时限】查询条件不起作用
		Set IFKind=objInf.MIFKind
		Continue:(aKind'="")&&(IFKind'=aKind)
		Set objIFKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",IFKind,"")
		If $IsObject(objIFKind){
			Set IFKind=objIFKind.Description
		}
		Set IFRank=objInf.MIFRank
		Continue:(aRank'="")&&(IFRank'=aRank)
		Set objIFRank=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",IFRank,"")
		If $IsObject(objIFRank){
			Set IFRank=objIFRank.Description
		}
		Set IFAppendix=objInf.MIFAppendix
		Continue:(aAppendixID'="")&&(IFAppendix'=aAppendixID)
		Set objIFAppendix=##class(DHCMed.EPD.AppendixCard).GetObjById(IFAppendix)
		If $IsObject(objIFAppendix){
			Set IFAppendix=objIFAppendix.MACDesc
		}
		Set IFMulti=$s(objInf.MIFMulti="Y":"是",1:"否")
		Continue:(aMulti'="")&&(aMulti'=objInf.MIFMulti)
		Set IFDependence=$s(objInf.MIFDependence="Y":"是",1:"否")
		Set IFTimeLimit=objInf.MIFTimeLimit
		//Set objIFTimeLimit=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICREPORTTIMELIMIT",objInf.MIFTimeLimit,"")
		//Set (TimeLimitID,TimeLimitDesc) =""
		//If $IsObject(objIFTimeLimit){
		 //   Set TimeLimitID = objIFTimeLimit.%Id()
			//Set TimeLimitDesc = objIFTimeLimit.Description
		//}
		//Continue:(aTimeLimit'="")&&(TimeLimitID'=aTimeLimit)   
		Continue:(aTimeLimit'="")&&(IFTimeLimit'[aTimeLimit)
		Set IFResume=objInf.MIFResume
		Set IFIsActive=$s(objInf.MIFIsActive="Y":"是",1:"否")
		Continue:(aWork'="")&&(aWork'=IFIsActive)
		Set IsForceReport=$s(objInf.MIFIsForceReport="Y":"是",1:"否")
		Continue:(aReport'="")&&(aReport'=IsForceReport)
		Set IsChronic=$s(objInf.MIFIsChronic="N":"否",1:"是")
		Continue:(aChronic'="")&&(aChronic'=IsChronic)
		
		
		Set Data=$lb(IFRowID)
		Set Data=Data_$lb(IFICD)
		Set Data=Data_$lb(IFName)
		Set Data=Data_$lb(IFKind)
		Set Data=Data_$lb(IFRank)
		Set Data=Data_$lb(IFAppendix)
		Set Data=Data_$lb(IFMulti)
		Set Data=Data_$lb(IFDependence)
		//Set Data=Data_$lb(TimeLimitDesc)
		Set Data=Data_$lb(IFTimeLimit)
		Set Data=Data_$lb(IFResume)
		Set Data=Data_$lb(IFIsActive)
		Set Data=Data_$lb(IsForceReport)
		Set Data=Data_$lb(IsChronic)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryIFListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIFListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIFListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIFListExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-09-12
/// Description:  根据诊断ID获取诊断类型
/// Table：       DHCMed.EPD.Infection
/// Input：       aDiseaseID:传染诊断ID
/// w ##class(DHCMed.EPDService.InfectionSrv).GetMIFKind(25)
ClassMethod GetMIFKind(aDiseaseID As %String) As %String
{
	New (aDiseaseID)
	Set return=""
	Quit:(aDiseaseID="") return
	
	Set objInf=##Class(DHCMed.EPD.Infection).GetObjById(aDiseaseID)
	Quit:'$IsObject(objInf) return
	Quit:objInf.MIFIsActive'="Y" return	
	Set MIFKind=objInf.MIFKind
	Set IFKind =""
    Set objIFKind=##class(DHCMed.SS.Dictionary).GetByTypeCode("EPDEMICTYPE",MIFKind,"")
	If $IsObject(objIFKind){
		Set IFKind=objIFKind.Description
	}
		
	Set return =IFKind 		
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-10-08
/// Description:  根据诊断描述获取诊断ID
/// Table：       DHCMed.EPD.Infection
/// Input：       aDiseaseID:传染诊断ID
/// w ##class(DHCMed.EPDService.InfectionSrv).GetInfectIDByDesc("发热伴血小板减少综合征")
ClassMethod GetInfectIDByDesc(aDiseaseDesc As %String) As %String
{
	New (aDiseaseDesc)
	Set return=""
	Quit:(aDiseaseDesc="") return
	
	Set xInfectID = ""
	For{
		Set xInfectID = $o(^DHCMed.EPDC("IF",xInfectID))
		Quit:xInfectID=""
		Set InfectInfo = $g(^DHCMed.EPDC("IF",xInfectID))
		Continue:InfectInfo=""
		Set InfectDesc = $p(InfectInfo,"^",2)
		Continue:(aDiseaseDesc'=InfectDesc)
		Set return =xInfectID 		 
	}	
	
	Quit return
}

}

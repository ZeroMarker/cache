/// 名称: DHCMed.SMDService.PsychDrugSrv
/// 描述: 精神类药品字典相关内容
/// 编写者：zhufei
/// 编写日期: 2015-05-14
Class DHCMed.SMDService.PsychDrugSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-05-14
/// Description:  查询精神类药品字典
/// Table：       DHCMed.SMD.PsychDrug
/// Input：       Alias : 别名
/// Return：      ROWSPEC = ""
/// Do ##class(%ResultSet).RunQuery("DHCMed.SMDService.PsychDrugSrv","QryPsychDrug","复方")
Query QryPsychDrug(aAlias As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Desc1:%String,Spec:%String,PackUnit:%String,ArcimID:%String") [ SqlProc ]
{
}

ClassMethod QryPsychDrugExecute(ByRef qHandle As %Binary, aAlias As %String) As %Status
{
	Set repid = $I(^CacheTemp)
	Set ind = 1
	Set qHandle = $ListBuild(0,repid,0)
	
	Kill arrPsychDrug
	Set xAlias=""
	For {
		Set xAlias=$o(^DHCMed.SMD.PsychDrugI("Alias","IndexAlias",xAlias))
		Quit:xAlias=""
		Continue:xAlias'[$zcvt(aAlias,"U")
		Set xID=0
		For {
			Set xID=$o(^DHCMed.SMD.PsychDrugI("Alias","IndexAlias",xAlias,xID))
			Quit:xID=""
			Set objPsychDrug=##class(DHCMed.SMD.PsychDrug).GetObjById(xID)
			Continue:'$IsObject(objPsychDrug)
			Continue:objPsychDrug.PDIsActive'=1
			Set PDCode=objPsychDrug.PDCode
			Set PDDesc=objPsychDrug.PDDesc
			Set PDDesc1=objPsychDrug.PDDesc_"["_objPsychDrug.PDSpec_"]"
			Set PDSpec=objPsychDrug.PDSpec
			if (PDSpec["/"){
				Set LPDSpec = $e(PDSpec,1,$l(PDSpec)-3)
				Set TPDSpec = $e(PDSpec,$l(PDSpec)-2,$l(PDSpec))
				Set TPDSpec = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","EN",TPDSpec)
				Set PDSpec  = LPDSpec_TPDSpec
			}else{
				Set LPDSpec = $e(PDSpec,1,$l(PDSpec)-2)
				Set TPDSpec = $e(PDSpec,$l(PDSpec)-1,$l(PDSpec))
				Set TPDSpec = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","EN",TPDSpec)
				Set PDSpec  = LPDSpec_TPDSpec
			}
			Set PDPackUnit=objPsychDrug.PDPackUnit
			Set PDPackUnit=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",PDPackUnit)
			Set PDArcimID=objPsychDrug.PDArcimID
			Set xPDDesc = PDDesc
			Set PDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SMD.PsychDrug","PDDesc","",PDDesc)
			Set arrPsychDrug(xPDDesc,xID)=$lb(xID,PDCode,PDDesc,PDDesc1,PDSpec,PDPackUnit,PDArcimID)
		}
	}
	
	Set xDesc=""
	For {
		Set xDesc=$o(^DHCMed.SMD.PsychDrugI("IndexDesc",xDesc))
		Quit:xDesc=""
		Continue:xDesc'[$zcvt(aAlias,"U")
		Set xID=0
		For {
			Set xID=$o(^DHCMed.SMD.PsychDrugI("IndexDesc",xDesc,xID))
			Quit:xID=""
			Set objPsychDrug=##class(DHCMed.SMD.PsychDrug).GetObjById(xID)
			Continue:'$IsObject(objPsychDrug)
			Continue:objPsychDrug.PDIsActive'=1
			Set PDCode=objPsychDrug.PDCode
			Set PDDesc=objPsychDrug.PDDesc
			Set PDDesc1=objPsychDrug.PDDesc_"["_objPsychDrug.PDSpec_"]"
			Set PDSpec=objPsychDrug.PDSpec
			if (PDSpec["/"){
				Set LPDSpec = $e(PDSpec,1,$l(PDSpec)-3)
				Set TPDSpec = $e(PDSpec,$l(PDSpec)-2,$l(PDSpec))
				Set TPDSpec = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","EN",TPDSpec)
				Set PDSpec  = LPDSpec_TPDSpec
			}else{
				Set LPDSpec = $e(PDSpec,1,$l(PDSpec)-2)
				Set TPDSpec = $e(PDSpec,$l(PDSpec)-1,$l(PDSpec))
				Set TPDSpec = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","EN",TPDSpec)
				Set PDSpec  = LPDSpec_TPDSpec
			}
			Set PDPackUnit=objPsychDrug.PDPackUnit
			Set PDPackUnit=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description","",PDPackUnit)
			Set PDArcimID=objPsychDrug.PDArcimID
			Set xPDDesc = PDDesc
			Set PDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SMD.PsychDrug","PDDesc","",PDDesc)
			Set arrPsychDrug(xPDDesc,xID)=$lb(xID,PDCode,PDDesc,PDDesc1,PDSpec,PDPackUnit,PDArcimID)
		}
	}
	
	Set xCode=""
	For {
		Set xCode=$o(arrPsychDrug(xCode))
		Quit:xCode=""
		Set xID=0
		For {
			Set xID=$o(arrPsychDrug(xCode,xID))
			Quit:xID=""
			Set Data=$g(arrPsychDrug(xCode,xID))
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill arrPsychDrug
	
	Quit $$$OK
}

ClassMethod QryPsychDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPsychDrugExecute ]
{
	Set repid = $List(qHandle,2)
 	Kill ^CacheTemp(repid)
 	
	Quit $$$OK
}

ClassMethod QryPsychDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPsychDrugExecute ]
{
	Set AtEnd = $List(qHandle,1)
 	Set repid = $List(qHandle,2)
 	Set ind = $List(qHandle,3)
 	
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd = 1
 		Set Row = ""
 	} Else {
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	Set qHandle = $ListBuild(AtEnd,repid,ind)
 	
	Quit $$$OK
}

/// Creator     : zhufei
/// CreatDate   : 2015-05-14
/// Description : 导入精神类药品字典数据
/// Table       : DHCMed.SMD.PsychDrug
/// Input       : InputStr ：精神类药品字典数据
/// Return      : String
/// w ##class(DHCMed.SMDService.PsychDrugSrv).ImportDrug("0001^复方丹参片^0.32g*60片^瓶^^1^^FFDSP")
ClassMethod ImportDrug(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	
	Set PDCode=$p(aInputStr,"^",1)
	Set PDDesc=$p(aInputStr,"^",2)
	Set PDSpec=$p(aInputStr,"^",3)
	Set PDPackUnit=$p(aInputStr,"^",4)
	Set PDArcimID=$p(aInputStr,"^",5)
	Set PDIsActive=+$p(aInputStr,"^",6)
	Set PDResume=$p(aInputStr,"^",7)
	Set PDAlias=$p(aInputStr,"^",8)
	Quit:(PDCode="")||(PDDesc="") return
	
	Set ID=$o(^DHCMed.SMD.PsychDrugI("IndexCode"," "_$ZCVT(PDCode,"U"),0))
	
	Set InputStr=ID_"^"_PDCode_"^"_PDDesc_"^"_PDSpec_"^"_PDPackUnit_"^"_PDArcimID_"^"_PDIsActive_"^"_PDAlias
	
	Set return=##class(DHCMed.SMD.PsychDrug).Update(InputStr,"^")
	If return<0 {
		Quit return
	} Else {
		Set ID=return
	}
	
	For indAlias=1:1:$l(PDAlias,",") {
		Set tmpAlias=$p(PDAlias,",",indAlias)
		Continue:tmpAlias=""
		Set InputStr=ID_"^"_""_"^"_tmpAlias
		Set flg=##class(DHCMed.SMD.PsychDrugAlias).Update(InputStr,"^")
	}
	
	Quit return
}

}

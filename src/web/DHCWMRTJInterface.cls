Import SQLUser

Class web.DHCWMRTJInterface Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 60;

ClassMethod GetMainByRegNo(RegNo) As %String
{
	quit ##Class(web.DHCWMRMainCtl).GetMainByRegNo(RegNo)
}

ClassMethod GetWMRMainPatient(RegNo) As %String
{
	n (RegNo)
	set ret = ""
	set MrType = 7
	set Patient = ##class(web.DHCWMRMedBaseCtl).GetPatInfo2(RegNo)
	set AdmList = ##class(web.DHCWMRMainCtl).GetNoVolAdm(+$p(Patient, $c(2), 22), "I", MrType)
	set ret= Patient _ $c(1) _ AdmList
	quit ret
}

ClassMethod GetWMRMainPatientByMrNo(MrNo) As %String
{
	n (MrNo)
	set ret = ""
	set MrType = 7
	set PatientHIS = ""
	set MainInfo = ##class(web.DHCWMRMainCtl).GetMainByTypeNo(MrType, +MrNo, "Y")
	set Patient = ##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+$p(MainInfo,"^",1))
	set RegNo = $p(Patient, "^", 27)
	set:RegNo'="" PatientHIS = ##class(web.DHCWMRMedBaseCtl).GetPatInfo2(RegNo)
	set AdmList = ##class(web.DHCWMRMainCtl).GetNoVolAdm(+$p(Patient, $c(2), 22), "I", MrType)
	set ret= Patient _ $c(1) _ PatientHIS _ $c(1) _ AdmList
	quit ret
}

ClassMethod GetAdmsByPatNo(PatientID, ADMType) As %String
{
	n (PatientID, ADMType)
	
    set ret = ""
    set AdmList = ""
	set AdmList =##Class(web.DHCWMRMedBasePaadmCtl).GetAdmsByPatNo(PatientID, ADMType)
	quit ret
}

ClassMethod GetOrdsDrugArcim(paadm, OrderType) As %String
{
       n (paadm,OrderType)
       //s num=0,s="ssssss"
       quit:'$d(^OEORD(0,"Adm",+paadm)) s
       
       kill ^CacheTemp("GetOrdsDrugArcim", $j)
       set orderID = $o(^OEORD(0, "Adm", +paadm, ""))
       set arcim = ""
 	   set arcim=$o(^OEORDi(0,"ARCIM",+orderID,arcim))
 	   set intCnt = 0
 	   while (arcim '= "")
 	   {
	 	   set ItmCat = $g(^ARCIM(+arcim, "1", 1))
	 	   set ItmCatID = +$p(ItmCat, "^", 10)
	 	   
	 	   set OrdCat = +$p($g(^ARC("IC", +ItmCatID)), "^", 8)
	 	   set Type=$p($g(^OEC("ORCAT",OrdCat)),"^",2)
	 	   set arcimDesc=$p($g(^ARCIM(+arcim,"1",1)),"^",2)
	 	   set ordDate=$o(^OEORDi(0,"ARCIM",+orderID,arcim,""))
	 	   set arcim = $o(^OEORDi(0, "ARCIM", +orderID, arcim))
	 	   if ((OrderType[Type)!(OrderType=""))
	 	   {
	 	   		set ^CacheTemp("GetOrdsDrugArcim", $j, intCnt) = arcimDesc_"^"_Type_"^"_$zd(ordDate,3)
	 	   		set intCnt = intCnt + 1
	 	   }
	   }
	   q $j
}

ClassMethod GetOrdsDrugArcimData(JIndex) As %String
{
 	n (JIndex)
 	set intCounter = ""
 	set ret = ""
 	set intCnt = 1
 	do
 	{
	 	set intCounter = $o(^CacheTemp("GetOrdsDrugArcim", JIndex, intCounter))
	 	if (intCounter '= "")!(intCnt < 50)
	 	{
		 	set str = $g(^CacheTemp("GetOrdsDrugArcim", JIndex, +intCounter))
		 	set:ret'="" ret=ret_$c(1)
		 	set ret = ret _ str
		 	kill ^CacheTemp("GetOrdsDrugArcim", JIndex, +intCounter)
		 	set intCnt = intCnt + 1
		}
	} while(+intCounter '= 0)
	quit ret
}

ClassMethod GetCurrAdmID(Regno, AdmitDate) As %String
{
	n (Regno,AdmitDate)
	set:AdmitDate'="" AdmitDate=$zdh(AdmitDate,3) 
    set ret = ""
    set intCounter = 0
    zn "MEDDATA"
	set AdmList =##Class(web.DHCWMRMedBasePaadmCtl).GetAdmsByPatNo(Regno, "I")
	zn "WEBSOURCE"
	
	for intCounter=1:1:$l(AdmList,$c(1))
	{
		set AdmID = $p(AdmList,$c(1),intCounter)
		continue:AdmID=""
		set AdmInfo = ##class(web.DHCWMRMedBasePaadmCtl).GetAdmInfo(AdmID)
		set tmpDate = $p(AdmInfo,"^",4)
		set:tmpDate'="" tmpDate=$zdh(tmpDate,3)
		continue:tmpDate'=AdmitDate
		set ret=AdmID
	}
	
	quit ret
}

ClassMethod Operation(MrNo, MainStatus, DetailList) As %String
{
	n (MrNo, MainStatus, DetailList)
	quit:MrNo="" -999
	set MainID = $o(^DHCWMRMAIN(0,"TypeNO",7, MrNo, ""))
	quit:MainID="" -998
	set MainStatus = MainID_MainStatus
	quit ##class(web.DHCWMROperation).Operation(0, 10, MainID, "", MainStatus, DetailList, "")
}

ClassMethod Operation1(MrNo, MainStatus, DetailList) As %String
{
	n (MrNo, MainStatus, DetailList)
	quit:MrNo="" -999
	set MainID = $o(^DHCWMRMAIN(0,"TypeNO",7, MrNo, ""))
	quit:MainID="" -998
	set MainStatus = MainID_MainStatus
	quit ##class(web.DHCWMROperation).Operation(0, 13, MainID, "", MainStatus, DetailList, "")
}

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}

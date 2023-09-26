Class web.DHCPdaNurRec Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetSurgeryRec(par As %String, rw As %String) As %String
{
   
	   //s a=##class(web.DHCPdaNurRec).GetSurgeryRec()
	    s arr=^Nur.DHCNurSurgeryNurseRecD(par,rw)
        s cdate=$listget(arr,4),ctime=$listget(arr,6)
		s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		s tmp("Temperature")=$listget(arr,16)
		s tmp("HeartRate")=$listget(arr,8)
		s tmp("Breath")=$listget(arr,3)
		s tmp("HPressure")=$listget(arr,7)
		s tmp("LPressure")=$listget(arr,9)
		s tmp("SPO2")=$listget(arr,14)
		s tmp("Wound")=$listget(arr,21)
		s tmp("SetTubeName")=$listget(arr,15)
		s tmp("TubeTend")=$listget(arr,20)
		s tmp("TractName")=$listget(arr,19)
		s tmp("TractStatus")=$listget(arr,18)
		s tmp("TractAmount")=$listget(arr,17)
		s tmp("NurQt")=$listget(arr,10)
		s tmp("CaseMeasure")=$listget(arr,5) //
		s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		s ret=""
		b
		s itm=""  f  s itm=$O(tmp(itm)) q:itm=""  d
		.s ret=ret_itm_"|"_tmp(itm)_"^"
		q ret
}

ClassMethod GetIntensiveRec(par As %String, rw As %String) As %String
{
  //##class(web.DHCPdaNurRec).GetIntensiveRec()
	    s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
   		s cdate=$listget(arr,9),ctime=$listget(arr,10)
        s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
        s tmp("Temperature")=$listget(arr,39)
		s tmp("HeartRate")=$listget(arr,16)
		s tmp("Breath")=$listget(arr,8)
		s tmp("HPressure")=$listget(arr,15)
		s tmp("LPressure")=$listget(arr,21)
		s tmp("SPO2")=$listget(arr,36)
		s tmp("Mind")=$listget(arr,25)
		s tmp("LPupilScale")=$listget(arr,23)
		s tmp("RPupilScale")=$listget(arr,32)
		s tmp("LPupilEcho")=$listget(arr,22)
		s tmp("RPupilEcho")=$listget(arr,31)
		s tmp("AbsorbPhlegm")=$listget(arr,3)
		s tmp("Atomization")=$listget(arr,6)
		s tmp("AbsorbOMth")=$listget(arr,2)
		s tmp("AbsorbRate")=$listget(arr,4)
		s tmp("Wound")=$listget(arr,42)
		s tmp("SetTubeName")=$listget(arr,37)
		s tmp("TubeTend")=$listget(arr,41)
		s tmp("TractName")=$listget(arr,40)
		s tmp("CurePump")=$listget(arr,12)
		s tmp("InDruggery")=$listget(arr,17)
		s tmp("InDruggeryAmount")=$listget(arr,18)
		s tmp("InQt")=$listget(arr,19)
		s tmp("InQtAmount")=$listget(arr,20)
		s tmp("Emiction")=$listget(arr,14)
		s tmp("OutQt")=$listget(arr,29) //其他出量名
		s tmp("OutQtAmount")=$listget(arr,30)  //其他出量
		s tmp("MornNurse")=$listget(arr,26)  //晨间护理
		s tmp("NightNurse")=$listget(arr,27)  //晚间护理
		s tmp("NurseDirect")=$listget(arr,28) //护理指导
		s tmp("SkinNurse")=$listget(arr,38)  //皮肤护理
		s tmp("SkinHealth")=$listget(arr,44)
		s tmp("BodyPos")=$listget(arr,7) //体位
		s tmp("DrainageNur")=$listget(arr,13)  //排泄护理
		s tmp("MRestrict")=$listget(arr,24)  //约束
		s tmp("InformDoc")=$listget(arr,43)  //通知医生
		s tmp("CaseMeasure")=$listget(arr,11) //
		s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		s ret=""
		b
		s itm=""  f  s itm=$O(tmp(itm)) q:itm=""  d
		.s ret=ret_itm_"|"_tmp(itm)_"^"
		q ret
}

ClassMethod GetCommRec(par As %String, rw As %String) As %String
{
  //##class(web.DHCPdaNurRec).GetIntensiveRec()
       s tmp=""
       s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)

        s cdate=tmp("CareDate"),ctime=tmp("CareTime")
      	s cdate=$ZD(cdate,3),ctime=$ZT(ctime,2)
		s CaseMeasure=tmp("CaseMeasure")
		s tmp("CareDate")=cdate,tmp("CareTime")=ctime
		s recuserId=tmp("RecUser")
		i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		e  s tmp("User")=""
		s recaudituserId=tmp("RecAuditUser")
		i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		e  s AuditUser=""
		i AuditUser'="" d
		.s tmp("User")=tmp("User")_" "_AuditUser
		s reccanceluserId=tmp("RecCancelUser")
		//q:(IfCancelRec="true")&(reccanceluserId="")
		//q:(IfCancelRec'="true")&(reccanceluserId'="")
		i reccanceluserId'="" d
		.s CancelUser=$p($g(^SSU("SSUSR",reccanceluserId)),"^",2)
		.s reccanceldate=tmp("RecCancelDate")
		.i reccanceldate'="" s reccanceldate=$ZD(reccanceldate,3)
		.s reccanceltime=tmp("RecCancelTime")
		.i reccanceltime'="" s reccanceltime=$ZT(reccanceltime)
		.s tmp("User")=tmp("User")_" 作废记录:"_CancelUser_" "_reccanceldate_" "_reccanceltime

		s ret=""
		b
		s itm=""  f  s itm=$O(tmp(itm)) q:itm=""  d
		.s ret=ret_itm_"|"_tmp(itm)_"^"
		q ret
}

}

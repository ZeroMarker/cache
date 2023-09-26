Class web.DHCEMOrdExecDetail Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCEMOrdExecDetail).GetExecDetailByOEORIDr("1167||4")
ClassMethod GetExecDetailByOEORIDr(OEORIDr)
{
	n (OEORIDr)
	q:OEORIDr="" ""
	s Count=0,Del=""""
	w "{"_Del_"OEOREInfo"_Del_":"_"["
	s Ord=+OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s AdmDr = $p(^OEORD(Ord),"^",1)
	s PatDr = $p(^PAADM(AdmDr),"^",1)
	s PatInfo = ##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
	s ArciName = ##class(web.DHCEMInComUseMethod).GetAllOrdDesc(OEORIDr)
	s Str = "ExecFlag^NeedExecDate^NeedExecTime^ExecDate^ExecTime^ArciName"
	s Sub=0
	f  s Sub = $o(^OEORD(Ord,"I",Itm,"X",Sub)) q:Sub=""  d
	.q:$p(^OEORD(Ord,"I",Itm,11),"^",39)'=""   //判断子医嘱过滤掉
	.s NeedExecDate = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",1)
	.s NeedExecTime = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",2)
	.s:NeedExecDate'="" NeedExecDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(NeedExecDate) //$zd(NeedExecDate,3)
	.s:NeedExecTime'="" NeedExecTime = $zt(NeedExecTime,2)
	.s ExecDate="",ExecTime="",ExecFlag=""    //医嘱执行标记
    	.s ExecStatusId=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",16) //执行状态
	.s ExecStatusCode=$p($g(^OEC("STAT",+ExecStatusId)),"^",1) 
	.i ExecStatusCode="F" d  //已经执行
	..s ExecDate = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",19)
	..s ExecTime = $p(^OEORD(Ord,"I",Itm,"X",Sub),"^",20)
	..s:ExecDate'="" ExecDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(ExecDate) //$zd(ExecDate,3)
	..s:ExecTime'="" ExecTime = $zt(ExecTime,2)
	..s ExecFlag="Y" 
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s Data = ExecFlag_"^"_NeedExecDate_"^"_NeedExecTime_"^"_ExecDate_"^"_ExecTime_"^"_ArciName
	.w ##class(web.DHCAPPJsonCommon).getJsonData(Str,Data)
	w "]"
	w ","_Del_"patInfo"_Del_":"
	w ##class(web.DHCAPPJsonCommon).getJsonData("patInfo",PatInfo,"&")
	w "}"
	q ""
}

}

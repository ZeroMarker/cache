Class web.DHCEMChangeLoc Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod QueryLoc()
{
	 
	 n (%session)
  	 s loc=$G(%session.Data("LOGON.CTLOCID"))
  	 w "{""rows"":["
  	 s locdesc=$p(^CTLOC(loc),"^",2)
	 s:$f(locdesc,"-") locdesc=$p(locdesc,"-",2) 
  	 w ##class(web.DHCAPPJsonCommon).getJsonData("locId^locName",loc_"^"_locdesc) 
     s tmploc=0,count=1
	 f  s tmploc=$o(^CTLOC(loc,"LINK",tmploc)) q:(tmploc="")||(tmploc=0)  d						
	 .s tmplinkloc=$p(^CTLOC(loc,"LINK",tmploc),"^",1)
	 .q:tmplinkloc=loc	
	 .s tmplinklocdesc=$p(^CTLOC(tmplinkloc),"^",2)
	 .i $f(tmplinklocdesc,"-") s tmplinklocdesc=$p(tmplinklocdesc,"-",2)  //liangqiang
  	 .s count=count+1
  	 .w ","
  	 .w ##class(web.DHCAPPJsonCommon).getJsonData("locId^locName",tmplinkloc_"^"_tmplinklocdesc)
  	 w "],""total"":"_count_"}"
  	 q ""
}

/// Description: 取切换科室
/// Creator:     huaxiaoying
/// CreateDate:  2018-11-02
/// w ##class(web.DHCEMChangeLoc).QueryLocCombo()
ClassMethod QueryLocCombo()
{
	 n (%session)
  	 s loc=$G(%session.Data("LOGON.CTLOCID"))
  	 w "["
  	 s locdesc=$p(^CTLOC(loc),"^",2)
  	 s locdesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",locdesc) 
	 s:$f(locdesc,"-") locdesc=$p(locdesc,"-",2) 
  	 w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",loc_"^"_locdesc) 
     s tmploc=0
	 f  s tmploc=$o(^CTLOC(loc,"LINK",tmploc)) q:(tmploc="")||(tmploc=0)  d						
	 .s tmplinkloc=$p(^CTLOC(loc,"LINK",tmploc),"^",1)
	 .q:tmplinkloc=loc	
	 .s tmplinklocdesc=$p(^CTLOC(tmplinkloc),"^",2)
	 .s tmplinklocdesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",tmplinklocdesc)
	 .i $f(tmplinklocdesc,"-") s tmplinklocdesc=$p(tmplinklocdesc,"-",2)  //liangqiang
  	 .w ","
  	 .w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmplinkloc_"^"_tmplinklocdesc)
  	 w "]"
  	 q ""
}

}

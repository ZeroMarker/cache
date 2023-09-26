Import SQLUser

/// 取就诊信息
/// by wuqk 2007-03
/// 处理病人就诊信息
Class web.DHCDocIPBBasePaadm Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 86;

/// 取出院时间，各家医院取的时间不一样
/// 日期和时间“,”分割
ClassMethod GetDisDateTime(Paadm)
{
	n (Paadm)
	s cDisDate="",cDisTime=""
	s cDisDate=+$p($g(^PAADM(+Paadm)),"^",17)
	s cDisTime=+$p($g(^PAADM(+Paadm)),"^",18)
	q cDisDate_","_cDisTime
}

/// 通过病区的ID获取病区信息
/// Ctloc：病区的RowID
ClassMethod GetCtlocStr(ctloc)
{
	
     n (ctloc)
     q:(ctloc="") ""
     q:(+ctloc=0) ""
     q:'$d(^CTLOC(+ctloc)) ""
     s LocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
     s LocDesc=$s(LocDesc["-":$p(LocDesc,"-",2),1:LocDesc)
     s s=ctloc_"/"_LocDesc
     q s
}

ClassMethod GetSSUSERByCode(SSUSRInitials)
{
   ;n (SSUSRInitials)
   q:SSUSRInitials="" ""
   ;^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId})
   ;s SSUSRInitials=$ZCVT(SSUSRInitials,"U")
   s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
   q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials)) ""
   s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
   q ssusr
}

ClassMethod GetUserByCTCP(CTCPDR)
{
	       ;CT_CareProv
    q:'$d(^CTPCP(CTCPDR)) ""
 s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
 s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
 s ssusr=..GetSSUSERByCode(Code)
 s s=ssusr_"/"_Code_"/"_Desc
 q s
}

/// 取就诊信息
ClassMethod GetAdmInfo(paadm)
{
    n (paadm)
    q:paadm="" ""
    q:'$d(^PAADM(+paadm)) ""
    s LocDesc="",DocDesc="",WardDesc="",RoomDesc="",BedDesc="",DischgDate="",DischgTime=""
    s tmp=$g(^PAADM(+paadm))
    s AdmType=$p(tmp,"^",2),AdmNo=$p(tmp,"^",81)
    s AdmDate=$zd($p(tmp,"^",6),3),AdmTime=$zt($p(tmp,"^",7))
    s papmi=+$p(tmp,"^",1),CTLoc=+$p(tmp,"^",4),Doc=+$p(tmp,"^",9)
    s Ward=+$p(tmp,"^",70),Room=+$p(tmp,"^",69),Bed=$p(tmp,"^",73)
    ;s:$p(tmp,"^",17)'="" DischgDate=$zd($p(tmp,"^",17),3),DischgTime=$zt($p(tmp,"^",18))
    s DischgDate=+$p(..GetDisDateTime(+paadm),",",1)
    s DischgTime=+$p(..GetDisDateTime(+paadm),",",2)
    s:DischgDate=0 DischgDate=""
    s:DischgTime=0 DischgTime=""
    s:DischgDate'="" DischgDate=$zd(DischgDate,3)
    s:DischgTime'="" DischgTime=$zt(DischgTime) ;modify by liuxuefeng 2009-03-04
    
    s:CTLoc'=0 LocDesc=..GetCtlocStr(CTLoc)  
    s:Doc'=0 DocDesc=..GetUserByCTCP(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    s VisitStatus=$p(tmp,"^",20)
    s:VisitStatus="A" VisitStatus="在院"
    s:VisitStatus="C" VisitStatus="取消"
    s:VisitStatus="D" VisitStatus="出院"
	
    s s=paadm_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime_"^"_VisitStatus
    q s
}

}

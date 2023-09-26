Import SQLUser

Class web.DHCDocIPBBasePaadmCtl Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right ]
{

Parameter BUILD = 22;

ClassMethod GetAdmInfo(paadm)
{
    ;n (paadm,%session)
    q:'$d(^PAADM(+paadm)) ""
	Set langid=..%LanguageID()
    s LocDesc="",DocDesc="",WardDesc="",RoomDesc="",BedDesc="",DischgDate="",DischgTime=""
    s tmp=$g(^PAADM(+paadm))
    s AdmType=$p(tmp,"^",2),AdmNo=$p(tmp,"^",81)
    s AdmDate=$p(tmp,"^",6)
    i AdmDate'="" s AdmDate=..%ZD(AdmDate) //$zd(AdmDate,3)
    s AdmTime=..%ZT($p(tmp,"^",7))
    s papmi=+$p(tmp,"^",1),CTLoc=+$p(tmp,"^",4),Doc=+$p(tmp,"^",9)
    s Ward=+$p(tmp,"^",70),Room=+$p(tmp,"^",69),Bed=$p(tmp,"^",73)
    //$zd($p(tmp,"^",17),3)
    s:$p(tmp,"^",17)'="" DischgDate=..%ZD($p(tmp,"^",17)),DischgTime=..%ZT($p(tmp,"^",18))
    
    s:CTLoc'=0 LocDesc=..GetCtlocStr(CTLoc)    
    s:Doc'=0 DocDesc=..GetUserByCTCP(Doc)
    s:Ward'=0 WardDesc=$p($g(^PAWARD(Ward)),"^",2)
    s WardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc",WardDesc,langid)
    s:Room'=0 RoomDesc=$p($g(^PAROOM(Room)),"^",2)
    s:Bed'="" BedDesc=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
    
    s s=paadm_"^"_AdmType_"^"_AdmNo_"^"_AdmDate_"^"_AdmTime_"^"_papmi_"^"_LocDesc_"^"_DocDesc_"^"_WardDesc_"^"_RoomDesc_"^"_BedDesc_"^"_DischgDate_"^"_DischgTime
    q s
}

ClassMethod GetCtlocStr(ctloc)
{
    ; n (ctloc)
     q:(ctloc="") ""
     q:(+ctloc=0) ""
     q:'$d(^CTLOC(+ctloc)) ""
     Set langid=..%LanguageID()
     s LocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
     s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
     s LocDesc=$s(LocDesc["-":$p(LocDesc,"-",2),1:LocDesc)
     s LocTel=$p($g(^CTLOC(+ctloc)),"^",40)
     s s=ctloc_"/"_LocDesc_"/"_LocTel
     q s
}

ClassMethod GetUserByCTCP(CTCPDR)
{
    q:'$d(^CTPCP(CTCPDR)) ""
    Set langid=..%LanguageID()
	s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
	s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
	Set Desc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",Desc,langid)
	s ssusr=..GetSSUSERByCode(Code)
	s s=ssusr_"/"_Code_"/"_Desc
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

}

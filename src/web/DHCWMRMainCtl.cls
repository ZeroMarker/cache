Import SQLUser

/// 对病案主信息的存取
/// By wuqk 2007-03
Class web.DHCWMRMainCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 49;

/// Add by wuqk 2012-02-08
/// 通过病案类型/登记号查询病案信息
/// w ##Class(web.DHCWMRMainCtl).GetMainByTypeRegNo(MrType, RegNo)
ClassMethod GetMainByTypeRegNo(MrType, RegNo)
{
   n (MrType,RegNo)
   s ret=""
   q:RegNo="" ret
   s RegNo=##class(web.DHCMedBaseCtl).RegNoCon(RegNo)    ;update by zf 2008-05-04
   q:'$d(^PAPERi("PAPMI_PatNo",RegNo)) ret
   s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
   q:Papmi="" ret
   s ret=##class(web.DHCWMRMainQry).GetMainByPapmi(MrType,Papmi)
   q ret
}

ClassMethod UpdateMain(Instring)
{
	n (Instring)
    s MainRowid=$p(Instring,"^",1)         ;DHC_WMR_MainRowID   
    s PLIST(2)=$p(Instring,"^",2)          ;病案类型           
    s PLIST(3)=$p(Instring,"^",3)          ;住院病案号码         
    s PLIST(4)=$p(Instring,"^",4)          ;病人基本信息     
    s PLIST(5)=$p(Instring,"^",5)          ;历史基本信息   
    s PLIST(6)=$p(Instring,"^",6)          ;是否死亡           
    s PLIST(6)=$s($p(Instring,"^",6)["Y":"Y",1:"N")  
    s PLIST(7)=$p(Instring,"^",7)          ;活动(未被删除)   
    s PLIST(7)=$s($p(Instring,"^",7)["Y":"Y",1:"N")  
    s PLIST(8)=$p(Instring,"^",8)          ;病案是否已归架   
    s PLIST(8)=$s($p(Instring,"^",8)["Y":"Y",1:"N")  
    s PLIST(9)=$p(Instring,"^",9)          ;生成日期        
    s:PLIST(9)'="" PLIST(9)=$zdh(PLIST(9),3)     
    s:PLIST(9)="" PLIST(9)=+$h
    s PLIST(10)=$p(Instring,"^",10)        ;备注    
    i MainRowid="" d
    .&sql(Insert into DHC_WMR_Main values :PLIST())
    e  d
    .&sql(Update DHC_WMR_Main values :PLIST() where Rowid=:MainRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetMainById(MainRowid As %String)
{
	n (MainRowid)
	
    s s=""
    q:MainRowid="" s
    q:'$d(^DHCWMRMAIN(MainRowid)) s
    s s=$g(^DHCWMRMAIN(MainRowid))
    s s=MainRowid_"^"_s
    s:$p(s,"^",9)'="" $p(s,"^",9)=$zd($p(s,"^",9),3)
	/*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
	s s=$$GetMainById^DHCWMRMain(MainRowid)
	zn CurrentNS
	*/
	q s
}

ClassMethod UpdateMainStatus(Instring)
{
	
    n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=+$p(Instring,"^",3)        ;病案操作项目/状态
    s PLIST(4)=$p(Instring,"^",4)        ;转交人   
    s PLIST(5)=$p(Instring,"^",5)        ;操作日期   
    s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),3)
    s:PLIST(5)="" PLIST(5)=+$h
    s PLIST(6)=$p(Instring,"^",6)        ;操作时间   
    s:PLIST(6)'="" PLIST(6)=$zth(PLIST(6))
    s:PLIST(6)="" PLIST(6)=$p($h,",",2) 
    s PLIST(7)=$p(Instring,"^",7)        ;接收人     
    i ChildSub="" d
    .&sql(insert into DHC_WMR_MainStatus values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .&sql(update DHC_WMR_MainStatus values :PLIST() where Parref=:ParRef and ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetMainStatus(MainRowid, ChildSub)
{
    n (MainRowid,ChildSub)
    s s=""
    q:'$d(^DHCWMRMAIN(MainRowid,"S",ChildSub)) s
    s s=$g(^DHCWMRMAIN(MainRowid,"S",ChildSub))
    s s=MainRowid_"||"_ChildSub_"^"_s
    
    s status=$p(s,"^",2)
    s ItemString=##class(web.DHCWMRWorkItemCtl).GetDataById(status)
    s ItemString=$tr(ItemString,"^","/")
    s $p(s,"^",2)=ItemString
   
    s:$p(s,"^",4)'="" $p(s,"^",4)=$zd($p(s,"^",4),3)
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zt($p(s,"^",5),2)   
    s:$p(s,"^",3)'="" $p(s,"^",3)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",3))
    s:$p(s,"^",6)'="" $p(s,"^",6)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(s,"^",6))
    q s
}

ClassMethod UpdateMainStatusDtl(Instring)
{
    
    n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=+$p(Instring,"^",3)        ;突发项目明细
    s PLIST(4)=$p(Instring,"^",4)         ;突发项目值  
    s PLIST(5)=$p(Instring,"^",5)         ;备注
    s PLIST(6)=$p(Instring,"^",6)         ;WorkItemListDr
    i ChildSub="" d
    .&sql(insert into DHC_WMR_MainStatusDtl values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .&sql(update DHC_WMR_MainStatusDtl values :PLIST() where Parref=:ParRef and ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetMainStatusDtl(MainRowid, sSub, ChildSub)
{

    n (MainRowid,sSub,ChildSub)
    s s=""
    q:'$d(^DHCWMRMAIN(MainRowid,"S",sSub,"D",ChildSub)) s
    s s=$g(^DHCWMRMAIN(MainRowid,"S",sSub,"D",ChildSub))
    s s=MainRowid_"||"_sSub_"||"_ChildSub_"^"_s
    s DetailDr=$p(s,"^",2)    
    q s
}

ClassMethod GetMainByTypeNo(MrType, MrNo, IsActive)
{
	n (MrType,MrNo,IsActive)
	s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))    //add by zf 2008-04-14
	s s=""
	q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo)) s
	
	s MainRowid=""
	f  s MainRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,MainRowid)) q:MainRowid=""  d
	.s MainString=..GetMainById(+MainRowid)
	.s TempActive=$p(MainString,"^",7)
	.q:(TempActive'=IsActive)&(IsActive'="")
	.s s=s_MainString_$c(1)
	q s
}

/// 通过登记号查询病案信息
/// w ##Class(web.DHCWMRMainCtl).GetMainByRegNo(RegNo)
ClassMethod GetMainByRegNo(RegNo)
{
	n (RegNo)
	s ret=""
	
	;通过登记号查询Papmi
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	q:RegNo="" ret
	/*
	q:$l(RegNo)>8 ret
	s $p(tmp,"0",9-$l(RegNo))=RegNo
	s RegNo=tmp
	*/
	s RegNo=##class(web.DHCWMRMedBaseCtl).RegNoCon(RegNo)    ;update by zf 2008-05-04
	q:'$d(^PAPERi("PAPMI_PatNo",RegNo)) ret
	s Papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	q:Papmi="" ret
	
	;通过Papmi查询病案信息
	;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	q:'$d(^DHCWMRMAIN(0,"PAPMI",Papmi)) ret
	s ID=0,TMP=""
	f  s ID=$o(^DHCWMRMAIN(0,"PAPMI",Papmi,ID)) q:ID=""  d
	.s tmp=..GetMainById(ID)
	.q:tmp=""
	.s tmpActive=$p(tmp,"^",7)
	.q:tmpActive="N"
	.s TMP=TMP_$c(1)_tmp
	s ret=$e(TMP,2,$l(TMP))
	q ret
}

ClassMethod GetWMRMainPatient(PatNo)
{
	n (PatNo)
	s ret=""
	s tmp=""
	q:PatNo="" ret
	/*
	q:$l(PatNo)>8 ret
	s $p(tmp,"0",9-$l(PatNo))=PatNo
	*/
	s PatNo=##class(web.DHCWMRMedBaseCtl).RegNoCon(PatNo)    ;update by zf 2008-05-30
	s PatNo=tmp
	
	s sPatInfo=##class(web.DHCWMRMedBaseCtl).GetPatInfo2(PatNo)
	s sMain=..GetMainByRegNo(PatNo)
	
	s ret=sPatInfo_$c(1)_sMain
	q ret
}

ClassMethod GetNoVolAdm(papmi, AdmType, MrType)
{
	n (papmi,AdmType,MrType)
	s ret=""
	q:'$d(^PAPERdr(papmi,"ADM",AdmType)) ret
	s paadm=""
	f  s paadm=$o(^PAPERdr(papmi,"ADM",AdmType,paadm),-1) q:paadm=""  d
	.s VisitStatus=$p($g(^PAADM(+paadm)),"^",20)
	.q:VisitStatus="C"                           ;Cancel
	.q:$$CheckActiveVol(paadm,MrType)=1
	.s ret=ret_##class(web.DHCWMRMedBasePaadmCtl).GetAdmInfo(paadm)_$c(1)
	
	q ret
CheckActiveVol(paadm,MrType)
    n (paadm,MrType)
    s flag=0
    q:'$d(^DHCWMRVOL(0,"VolAdm",paadm)) flag
    s VolRowid=+$o(^DHCWMRVOL(0,"VolAdm",paadm,""),-1)
    s sVolume=##class(web.DHCWMRVolumeCtl).GetVolume(VolRowid)
    s:$p(sVolume,"^",8)'="Y" flag=1
    q:flag flag
    s MainRowid=$p(sVolume,"^",2)
    q:MainRowid="" 1
    s sMain=..GetMainById(MainRowid)
    s:$p(sMain,"^",7)'="Y" flag=1
    q:flag flag
    q flag
}

/// 添加病案号修改,病案转移日志
ClassMethod UpdateMainLog(Instring)
{
	n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=$p(Instring,"^",3)        ;MrNo
    s PLIST(4)=$p(Instring,"^",4)       ;Papmi
    s PLIST(5)=$p(Instring,"^",5)        ;User_Dr
    s PLIST(6)=$p(Instring,"^",6)        ;UpdateDate   
    s:PLIST(6)'="" PLIST(6)=$zdh(PLIST(5),3)
    s:PLIST(6)="" PLIST(6)=+$h
    s PLIST(7)=$p(Instring,"^",7)        ;UpdateTime 
    s:PLIST(7)'="" PLIST(7)=$zth(PLIST(6))
    s:PLIST(7)="" PLIST(7)=$p($h,",",2)  
    
    i ChildSub="" d
    .&sql(insert into DHC_WMR_MainLog values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .s MainLogRowid=ParRef_"||"_ChildSub
    .&sql(update DHC_WMR_MainLog values :PLIST() where Rowid=:MainLogRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetMainLogById(MainRowid, ChildSub)
{
	n (MainRowid ,ChildSub)
	
    s s=""
    q:(MainRowid="")||(ChildSub="") s
    q:'$d(^DHCWMRMAIN(MainRowid,"L",ChildSub)) s
    s s=$g(^DHCWMRMAIN(MainRowid,"L",ChildSub))
    s s=MainRowid_"||"_ChildSub_"^"_s
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3)
    s:$p(s,"^",6)'="" $p(s,"^",6)=$zt($p(s,"^",6),2)
	q s
}

}

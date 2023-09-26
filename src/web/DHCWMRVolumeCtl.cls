Import SQLUser

/// 卷信息的相关操作
/// By wuqk 2007-03
/// Modify by 2007-05-22  for Structure Rebuild
Class web.DHCWMRVolumeCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 103;

ClassMethod UpdateVol(Instring)
{
	n (Instring)
    ;s PLIST(0)=$p(Instring,"^",2)
    s VolRowid=$p(Instring,"^",1)
    s PLIST(2)=$p(Instring,"^",2)        ;指向DHC_WMR_Main
    s PLIST(3)=$p(Instring,"^",3)        ;病人就诊基本信息  paadm     
    s PLIST(4)=$p(Instring,"^",4)        ;历史卷信息 
    s PLIST(5)=$s($p(Instring,"^",5)["Y":"Y",1:"N")  ;是否复印
    s PLIST(6)=$s($p(Instring,"^",6)["Y":"Y",1:"N")  ;是否被封存
    s PLIST(7)=+$p(Instring,"^",7)        ;病案操作项目/状态
    s PLIST(8)=$s($p(Instring,"^",8)["Y":"Y",1:"N")  ;是否有效
    s PLIST(9)=$s($p(Instring,"^",9)["Y":"Y",1:"N")  ;流是否完成
    s PLIST(10)=$p(Instring,"^",10)      ;备注 
    s PLIST(11)=$p(Instring,"^",11)    ;volNo          
    i VolRowid="" d
    .&sql(insert into DHC_WMR_MainVolume values :PLIST())
    e  d
    .;s ParRef=PLIST(0)
    .&sql(update DHC_WMR_MainVolume values :PLIST() where Rowid=:VolRowid)
  
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateVolLog(Instring)
{
	n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=+$p(Instring,"^",3)        ;Pa_Adm.Rowid 
    s PLIST(4)=$p(Instring,"^",4)        ;User_Dr
    s PLIST(5)=$p(Instring,"^",5)        ;UpdateDate   
    s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),3)
    s:PLIST(5)="" PLIST(5)=+$h
    s PLIST(6)=$p(Instring,"^",6)        ;UpdateTime 
    s:PLIST(6)'="" PLIST(6)=$zth(PLIST(6))
    s:PLIST(6)="" PLIST(6)=$p($h,",",2)  
    i ChildSub="" d
    .&sql(insert into DHC_WMR_VolLog values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .s VolLogRowid=ParRef_"||"_ChildSub
    .&sql(update DHC_WMR_VolLog values :PLIST() where Rowid=:VolLogRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateVolAdm(Instring)
{
	n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=+$p(Instring,"^",3)        ;Pa_Adm.Rowid  
    i ChildSub="" d
    .&sql(insert into DHC_WMR_VolAdm values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .s VolAdmRowid=ParRef_"||"_ChildSub
    .&sql(update DHC_WMR_VolAdm values :PLIST() where Rowid=:VolAdmRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateVolStatus(Instring)
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
    .&sql(insert into DHC_WMR_VolStatus values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .&sql(update DHC_WMR_VolStatus values :PLIST() where Parref=:ParRef and ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateVolStatusDtl(Instring)
{
	n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=+$p(Instring,"^",3)        ;突发项目明细
    s PLIST(4)=$p(Instring,"^",4)         ;突发项目值  
    s PLIST(5)=$p(Instring,"^",5)         ;备注
    s PLIST(6)=$p(Instring,"^",6)         ;WorkItemListDr
    i ChildSub="" d
    .&sql(insert into DHC_WMR_VolStatusDtl values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .&sql(update DHC_WMR_VolStatusDtl values :PLIST() where Parref=:ParRef and ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateVolStatusEva(Instring)
{
	n (Instring)
    s PLIST(0)=$p(Instring,"^",1)
    s ChildSub=$p(Instring,"^",2)
    s PLIST(3)=$p(Instring,"^",3)        ;病案操作项目评价项目
    s PLIST(4)=+$p(Instring,"^",4)        ;评价人
    s PLIST(5)=$p(Instring,"^",5)         ;评价日期  
    s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),3)
    s:PLIST(5)="" PLIST(5)=+$h
    s PLIST(6)=$p(Instring,"^",6)         ;评价时间  
    s:PLIST(6)'="" PLIST(6)=$zth(PLIST(6))
    s:PLIST(6)="" PLIST(6)=$p($h,",",2) 
    s PLIST(7)=$p(Instring,"^",7)         ;备注
    i ChildSub="" d
    .&sql(insert into DHC_WMR_VolStatusEva values :PLIST())
    e  d
    .s ParRef=PLIST(0)
    .s EvaRowid=ParRef_"||"_ChildSub
    .&sql(update DHC_WMR_VolStatusEva values :PLIST() where Rowid=:EvaRowid)
    .;&sql(update DHC_WMR_VolStatusEva values :PLIST() where Parref=:ParRef and ChildSub=:ChildSub)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateVolInfo(Instring)
{
	n (Instring)
    s HisRowid=$p(Instring,"^",1)        ;DHC_WMR_VolInfo RowID
    s PLIST(2)=$p(Instring,"^",2)        ;病人姓名           
    s PLIST(3)=$$ALPHAUP^SSUTIL4($p(Instring,"^",3))        ;姓名拼音码           
    s PLIST(4)=$p(Instring,"^",4)        ;性别                       
    s PLIST(5)=$p(Instring,"^",5)        ;生日 
    s:PLIST(5)'="" PLIST(5)=$zdh(PLIST(5),3)                 
    s PLIST(6)=+$p(Instring,"^",6)        ;年龄                       
    s PLIST(7)=$p(Instring,"^",7)        ;婚姻                   
    s PLIST(8)=$p(Instring,"^",8)        ;职业                
    s PLIST(9)=$p(Instring,"^",9)        ;出生市                    
    s PLIST(10)=$p(Instring,"^",10)      ;出生县                 
    s PLIST(11)=$p(Instring,"^",11)      ;民族                   
    s PLIST(12)=$p(Instring,"^",12)      ;国籍              
    s PLIST(13)=$p(Instring,"^",13)      ;身份证号         
    s PLIST(14)=$p(Instring,"^",14)      ;工作单位              
    s PLIST(15)=$p(Instring,"^",15)      ;工作单位电话       
    s PLIST(16)=$p(Instring,"^",16)      ;工作单位邮编       
    s PLIST(17)=$p(Instring,"^",17)      ;家庭住址          
    s PLIST(18)=$p(Instring,"^",18)      ;家庭电话              
    s PLIST(19)=$p(Instring,"^",19)      ;家庭邮编              
    s PLIST(20)=$p(Instring,"^",20)      ;与联系人关系     
    s PLIST(21)=$p(Instring,"^",21)      ;联系人           
    s PLIST(22)=$p(Instring,"^",22)      ;联系人电话        
    s PLIST(23)=$p(Instring,"^",23)      ;联系人地址    
    s PLIST(24)=$p(Instring,"^",24)      ;是否有效  
    s PLIST(24)=$s(PLIST(24)["Y":"Y",1:"N")             
    s PLIST(25)=$p(Instring,"^",25)      ;备注             
    s PLIST(26)=$p(Instring,"^",26)     ;病案的卷  
    i HisRowid="" d
    .&sql(Insert into DHC_WMR_VolInfo values :PLIST())
    e  d
    .&sql(Update DHC_WMR_VolInfo values :PLIST() where Rowid=:HisRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetVolume(VolRowid As %String)
{
   ;4.2 病案卷表 DHC_WMR_MainVolume
   n (VolRowid)
   s sVolume=""
   q:+VolRowid=0 sVolume
   q:'$d(^DHCWMRVOL(+VolRowid)) sVolume
   s sVolume=VolRowid_"^"_$g(^DHCWMRVOL(VolRowid))
   q sVolume
   /*
   
   ;GetVolume(MainRowid,ChildSub)
   n (MainRowid,ChildSub)
   s sVolume=""
   q:'$d(^DHCWMRMAIN(MainRowid,"V",ChildSub)) sVolume
   ;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"V",{ChildSub})
   s sVolume=MainRowid_"||"_ChildSub_"^"_$g(^DHCWMRMAIN(MainRowid,"V",ChildSub))
   ;s status=$p(sVolume,"^",5)
   ;s ItemString=##class(web.DHCWMRWorkItemCtl).GetDataById(status)
   ;s ItemString=$tr(ItemString,"^","/")
   ;s $p(sVolume,"^",5)=ItemString
   q sVolume
   */
}

ClassMethod GetVolAdm(VolRowid, ChildSub)
{
   ;4.2.1 卷就诊列表信息表 DHC_WMR_VolAdm
   n (VolRowid,ChildSub)
   s sVolAdm=""
   q:'$d(^DHCWMRVOL(+VolRowid,"ADM",ChildSub)) sVolAdm 
   s sVolAdm=VolRowid_"||"_ChildSub_"^"_$g(^DHCWMRVOL(+VolRowid,"ADM",ChildSub))
   q sVolAdm
	/*
   
   ;GetVolAdm(VolRowid,ChildSub)
   n (VolRowid,ChildSub)
   s sVolAdm=""
   s MainRowid=$p(VolRowid,"||",1)
   s VolChildSub=$p(VolRowid,"||",2)
   q:'$d(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM",ChildSub)) sVolAdm 
   s sVolAdm=VolRowid_"||"_ChildSub_"^"_$g(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"ADM",ChildSub))
   q sVolAdm
   */
}

ClassMethod GetVolStatus(VolRowid, ChildSub)
{
	set ^CacheTemp("DDDD")=VolRowid_"||"_ChildSub
   ;4.2.2 病案卷状态表 DHC_WMR_VolStatus
   n (VolRowid,ChildSub)
   s sVolStatus=""
   q:'$d(^DHCWMRVOL(+VolRowid,"S",ChildSub)) sVolStatus
   s sVolStatus=VolRowid_"||"_ChildSub_"^"_$g(^DHCWMRVOL(+VolRowid,"S",ChildSub))
   
   s status=$p(sVolStatus,"^",2)
   s ItemString=##class(web.DHCWMRWorkItemCtl).GetDataById(status)
   s ItemString=$tr(ItemString,"^","/")
   s $p(sVolStatus,"^",2)=ItemString
   
   s:$p(sVolStatus,"^",3)'="" $p(sVolStatus,"^",3)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(sVolStatus,"^",3))
   s:$p(sVolStatus,"^",4)'="" $p(sVolStatus,"^",4)=$zd($p(sVolStatus,"^",4),3)
   s:$p(sVolStatus,"^",5)'="" $p(sVolStatus,"^",5)=$zt($p(sVolStatus,"^",5))
   s:$p(sVolStatus,"^",6)'="" $p(sVolStatus,"^",6)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(sVolStatus,"^",6))
   q sVolStatus
   /*
   ;GetVolStatus(VolRowid,ChildSub)
   n (VolRowid,ChildSub)
   s sVolStatus=""
   s MainRowid=$p(VolRowid,"||",1)
   s VolChildSub=$p(VolRowid,"||",2)
   q:'$d(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"S",ChildSub)) sVolStatus
   s sVolStatus=VolRowid_"||"_ChildSub_"^"_$g(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"S",ChildSub))
   
   s status=$p(sVolStatus,"^",2)
   s ItemString=##class(web.DHCWMRWorkItemCtl).GetDataById(status)
   s ItemString=$tr(ItemString,"^","/")
   s $p(sVolStatus,"^",2)=ItemString
   
   s:$p(sVolStatus,"^",3)'="" $p(sVolStatus,"^",3)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(sVolStatus,"^",3))
   s:$p(sVolStatus,"^",4)'="" $p(sVolStatus,"^",4)=$zd($p(sVolStatus,"^",4),3)
   s:$p(sVolStatus,"^",5)'="" $p(sVolStatus,"^",5)=$zt($p(sVolStatus,"^",5))
   s:$p(sVolStatus,"^",6)'="" $p(sVolStatus,"^",6)=##class(web.DHCWMRMedBaseCtl).GetUsrStr($p(sVolStatus,"^",6))
   q sVolStatus
   */
}

ClassMethod GetVolStatusDtl(StatusRowid, ChildSub)
{
   ;4.2.2.1 突发项目内容明细表 DHC_WMR_VolStatusDtl
   n (StatusRowid,ChildSub)
   s sStatusDtl=""
   s VolRowid=+$p(StatusRowid,"||",1)
   s StatusSub=$p(StatusRowid,"||",2)
   q:'$d(^DHCWMRVOL(VolRowid,"S",StatusSub,"D",ChildSub)) sStatusDtl
   s sStatusDtl=StatusRowid_"||"_ChildSub_"^"_$g(^DHCWMRVOL(VolRowid,"S",StatusSub,"D",ChildSub))
   q sStatusDtl
   /*
   ;GetVolStatusDtl(StatusRowid,ChildSub)
   n (StatusRowid,ChildSub)
   s sStatusDtl=""
   s MainRowid=$p(StatusRowid,"||",1)
   s VolChildSub=$p(StatusRowid,"||",2)
   s StatusChildSub=$p(StatusRowid,"||",3)
   q:'$d(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"S",StatusChildSub,"D",ChildSub)) sStatusDtl
   s sStatusDtl=StatusRowid_"||"_ChildSub_"^"_$g(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"S",StatusChildSub,"D",ChildSub))
   q sStatusDtl
   */
}

ClassMethod GetVolStatusEva(StatusRowid, ChildSub)
{
   ;4.2.2.2 病案卷状态评价列表 DHC_WMR_VolStatusEva
   n (StatusRowid,ChildSub)
   s sStatusEva=""
   s VolRowid=+$p(StatusRowid,"||",1)
   s StatusSub=$p(StatusRowid,"||",2)
   q:'$d(^DHCWMRVOL(VolRowid,"S",StatusSub,"E",ChildSub)) sStatusEva
   s sStatusEva=StatusRowid_"||"_ChildSub_$g(^DHCWMRVOL(VolRowid,"S",StatusSub,"E",ChildSub))
   q sStatusEva
   /*
   ;GetVolStatusEva(StatusRowid,ChildSub)
   n (StatusRowid,ChildSub)
   s sStatusEva=""
   s MainRowid=$p(StatusRowid,"||",1)
   s VolChildSub=$p(StatusRowid,"||",2)
   s StatusChildSub=$p(StatusRowid,"||",3)
   q:'$d(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"S",StatusChildSub,"E",ChildSub)) sStatusEva
   s sStatusEva=StatusRowid_"||"_ChildSub_"^"_$g(^DHCWMRMAIN(MainRowid,"V",VolChildSub,"S",StatusChildSub,"E",ChildSub))
   s:$p(sStatusEva,"^",4)'="" $p(sStatusEva,"^",4)=$zd($p(sStatusEva,"^",4),3)
   s:$p(sStatusEva,"^",5)'="" $p(sStatusEva,"^",5)=$zt($p(sStatusEva,"^",5),2)
   q sStatusEva
   */
}

ClassMethod GetVolInfo(Rowid)
{
   ;5 卷基本信息表 DHC_WMR_VolInfo
   ;GetVolInfo(Rowid)
   n (Rowid)
   ;^DHCWMRVOLINFO({Rowid})
   s sVolInfo=""
   q:Rowid="" sVolInfo
   q:'$d(^DHCWMRVOLINFO(Rowid)) sVolInfo
   s sVolInfo=$g(^DHCWMRVOLINFO(Rowid))
   s sVolInfo=Rowid_"^"_sVolInfo
   s:$p(sVolInfo,"^",5)'="" $p(sVolInfo,"^",5)=$zd($p(sVolInfo,"^",5),3) 
   q sVolInfo
}

ClassMethod GetVolInfoByVol(VolRowid)
{
   n (VolRowid)
   ;^DHCWMRVOLINFO(0,"VOL",{Volume_Dr},{Rowid})
   s sVolInfo=""
   q:'$d(^DHCWMRVOLINFO(0,"VOL",VolRowid)) sVolInfo
   s Rowid=$o(^DHCWMRVOLINFO(0,"VOL",VolRowid,""),-1)
   s sVolInfo=..GetVolInfo(Rowid)
   q sVolInfo
}

ClassMethod QueryByNameSpell(JIndex, NameSpell)
{
	;^DHCWMRVOLINFO(0,"NameSpell",{NameSpell},{Rowid})
    n (JIndex,NameSpell)
    s:JIndex="" JIndex=$j
    q:NameSpell="" JIndex
    ;k ^CacheTemp("DHCWMRHistory",JIndex)
    
    s NameSpell=$$ALPHAUP^SSUTIL4(NameSpell)
    
    i $d(^DHCWMRVOLINFO(0,"NameSpell",NameSpell)) d xxxx(JIndex,NameSpell)
    
    s NameSpell0=NameSpell
    f  s NameSpell0=$o(^DHCWMRVOLINFO(0,"NameSpell",NameSpell0)) q:(NameSpell0'[NameSpell)!(NameSpell0="")  d
    .s err=$$xxxx(JIndex,NameSpell0)
    q JIndex
    
xxxx(JIndex,NameSpell)
    n (JIndex,NameSpell)
    
    s VolInfoRowid="0"
    f  s VolInfoRowid=$o(^DHCWMRVOLINFO(0,"NameSpell",NameSpell,VolInfoRowid)) q:VolInfoRowid=""  d
    .s VolRowid=$p($g(^DHCWMRVOLINFO(+VolInfoRowid)),"^",25)
	.s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolRowid)
	.s MainRowid=$p(VolumeInfo,"^",2)
    .;s MainRowid=+VolRowid
    .s ^CacheTemp("DHCWMRHistory",JIndex,+MainRowid)=""
    q 0
}

/// 根据paadm查询卷
ClassMethod GetVolumeByAdm(paadm)
{
	n (paadm)
	
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	s s=""
	q:'$d(^DHCWMRVOL(0,"VolAdm",paadm)) s
    s VolRowid=+$o(^DHCWMRVOL(0,"VolAdm",paadm,""),-1)
    s s=..GetVolume(VolRowid)
	q s
	/*
    ;^DHCWMRMAIN(0,"VolAdm",{Paadm_Dr},{DHC_WMR_Main.Rowid},{DHC_WMR_MainVolume.ChildSub},{ChildSub})
    s s=""
    q:'$d(^DHCWMRMAIN(0,"VolAdm",paadm)) s
    s MainRowid=$o(^DHCWMRMAIN(0,"VolAdm",paadm,""),-1)
    s VolSub=$o(^DHCWMRMAIN(0,"VolAdm",paadm,MainRowid,""),-1)
    s s=..GetVolume(MainRowid,VolSub)
	q s
	*/
}

//2008-5-4 by liyang 能够通过MainVolumeID查到该卷下所有的Paadm号码~~

ClassMethod GetVolumeAdmList(VolID)
{
	n (VolID)
	s childSub = "0",adm=""
	f  s childSub=$o(^DHCWMRVOL(VolID,"ADM",childSub)) q:childSub=""  d
	.s adm=adm_^DHCWMRVOL(VolID,"ADM",childSub)_"^"
	q adm
}

/// 2008-09-24 LiYang 获取住院、出院信息（考虑到了中间结账问题）
ClassMethod GetVolAdmInfo(VolID)
{
	n (VolID)
	set FirstAdm = ""
	set LastAdm = ""
	
	set childSub = $o(^DHCWMRVOL(VolID, "ADM", 0))
	quit:childSub="" ""
	set FirstAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+$g(^DHCWMRVOL(VolID, "ADM", childSub)))
	
	set childSub = $o(^DHCWMRVOL(VolID, "ADM", ""), -1)
	quit:childSub="" ""	
	set LastAdm = ##class(web.DHCWMRBasePaadm).GetAdmInfo(+$g(^DHCWMRVOL(VolID, "ADM", childSub)))

	set $p(LastAdm, "^", 4) = $p(FirstAdm, "^", 4)
	set $p(LastAdm, "^", 5) = $p(FirstAdm, "^", 5)
	quit LastAdm
}

/// 创建者：王成山
/// 日期：2013-05-03
/// 描述：判断是否最后一个状态  1最后一个状态和非顺序工作流状态， 其他不是
/// Debug:w ##Class(web.DHCWMRVolumeCtl).IsLastStatus(7,9)
ClassMethod IsLastStatus(MrType As %String, CurrStatus As %String) As %String
{
	New (MrType,CurrStatus)
	Set Rtn=1
	Set sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
	Set Len=$l(sFlow,$c(1))
	For i=1:1:Len {
		Set sTemp=$p(sFlow,$c(1),i)
	    Set ItemDr=$p(sTemp,"^",3)
	    ;Set:(ItemDr=CurrStatus)&&(len=i) Rtn=1
	    Set:(ItemDr=CurrStatus)&&(Len>i) Rtn=0
	}
	Quit Rtn
}

/// 创建者：王成山
/// 批量更新顺序工作流状态
/// 2010-12-06
/// w ##Class(web.DHCWMRVolumeCtl).BatchUpdateVolStatus(MrType, CurrStatus, UserID, LocID, VolRowidStr)
ClassMethod BatchUpdateVolStatus(MrType, CurrStatus, UserID, LocID, VolRowidStr)
{
	n (MrType,CurrStatus,UserID,LocID,VolRowidStr)
	;set ^CacheTemp("BatchUpdateVolStatus")=MrType_","_CurrStatus_","_UserID_","_LocID_","_VolRowidStr
	//s ^lxf("Batch")=MrType_"^"_CurrStatus_"^"_UserID_"^"_LocID_"^"_VolRowidStr
	s ret=-1
	q:+MrType=0 ret
	q:+CurrStatus=0 ret
	q:+UserID=0 ret
	q:+LocID=0 ret
	q:+VolRowidStr=0 ret
	s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
    s sFlowLength=$l(sFlow,$c(1))
    s findFlag="N"
    s CurrStatusPos=""
    
    s ret=-2
    f i=1:1:sFlowLength d
    .s sTmp=$p(sFlow,$c(1),i)
    .s ItemDr=$p(sTmp,"^",3)
    .i ItemDr=CurrStatus d 
    ..s findFlag="Y"
    ..s CurrStatusPos=i

    s ret=-3
    q:findFlag'="Y" ret
    s sNextStatusTmp=$p(sFlow,$c(1),CurrStatusPos+1)
    s NextStatus=+$p(sNextStatusTmp,"^",3)
    q:NextStatus=0 ret
    
    s LastItemFlag="" //是否为工作流最后一个操作项标志
    s:CurrStatusPos+1=sFlowLength LastItemFlag="Y" //如果当前状态的下一个操作项目为工作流最后操作项目，标志置为Y
    
	s len=$l(VolRowidStr,"*")
	f i=1:1:len d
	.s VolRowid=+$p(VolRowidStr,"*",i)
	.q:VolRowid<=0
	.s sVolume=..GetVolume(VolRowid)
	.s $p(sVolume,"^",7)=NextStatus
	.s:LastItemFlag="Y" $p(sVolume,"^",9)="N" //InFlow字段设为“N”
	.s ret=..UpdateVol(sVolume)
	.s sVolStatus=VolRowid_"^^"_NextStatus_"^"_UserID_"^"_$zd(+$h,3)_"^"_$zt($p($h,",",2))
	.s ret=..UpdateVolStatus(sVolStatus)
	q ret
}

}

Import SQLUser

/// 历史病案信息
/// By wuqk 2007-03
Class web.DHCWMRHistoryCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 94;

ClassMethod UpdateHistory(Instring)
{
	n (Instring)
    s HisRowid=$p(Instring,"^",1)        ;DHC_WMR_History RowID    
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
    i HisRowid="" d
    .&sql(Insert into DHC_WMR_History values :PLIST())
    e  d
    .&sql(Update DHC_WMR_History values :PLIST() where Rowid=:HisRowid)
    i SQLCODE d
    .b
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod UpdateAdm(Instring)
{
	 n (Instring)
    s AdmRowid=$p(Instring,"^",1)          ;DHC_WMR_HistoryAdm RowID 
    s PLIST(2)=$p(Instring,"^",2)          ;历史基本信息        
    s PLIST(3)=$p(Instring,"^",3)          ;就诊日期  
    s:PLIST(3)'="" PLIST(3)=$zdh(PLIST(3),3)
    s PLIST(4)=$p(Instring,"^",4)          ;就诊时间             
    s PLIST(5)=$p(Instring,"^",5)          ;就诊科室              
    s PLIST(6)=$p(Instring,"^",6)          ;就诊时状态         
    s PLIST(7)=$p(Instring,"^",7)          ;出院日期         
    s:PLIST(7)'="" PLIST(7)=$zdh(PLIST(7),3)
    s PLIST(8)=$p(Instring,"^",8)          ;出院时间         
    s PLIST(9)=$p(Instring,"^",9)          ;出院科室          
    s PLIST(10)=$p(Instring,"^",10)        ;诊断                 
    s PLIST(11)=$p(Instring,"^",11)        ;是否有效   
    s PLIST(11)=$s(PLIST(11)["Y":"Y",1:"N")   
    s PLIST(12)=$p(Instring,"^",12)        ;备注                       
    i AdmRowid="" d
    .&sql(Insert into DHC_WMR_HistoryAdm values :PLIST())
    e  d
    .&sql(Update DHC_WMR_HistoryAdm values :PLIST() where Rowid=:AdmRowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod GetHistoryById(Id)
{
	n (Id)	
    s s=""
    q:'$d(^DHCWMRHISTORY(Id)) s
    s s=$g(^DHCWMRHISTORY(Id))
    s s=Id_"^"_s
    s:$p(s,"^",5)'="" $p(s,"^",5)=$zd($p(s,"^",5),3) 
	q s
}

ClassMethod GetHistoryAdmById(Id)
{
    n (Id)
    s s=""
    q:'$d(^DHCWMRHISADM(Id)) s
    s s=$g(^DHCWMRHISADM(Id))
    s s=Id_"^"_s
    s:$p(s,"^",3)'="" $p(s,"^",3)=$zd($p(s,"^",3),3) 
    s:$p(s,"^",7)'="" $p(s,"^",7)=$zd($p(s,"^",7),3)    
    q s
}

ClassMethod QueryByNameSpell(JIndex, NameSpell)
{
	;^DHCWMRHISTORY(0,"NameSpell",{NameSpell},{Rowid})
    n (JIndex,NameSpell)
    s:JIndex="" JIndex=$j
    q:NameSpell="" JIndex
    ;k ^CacheTemp("DHCWMRHistory",JIndex)
    
    s NameSpell=$$ALPHAUP^SSUTIL4(NameSpell)
    
    i $d(^DHCWMRHISTORY(0,"NameSpell",NameSpell)) d xxxx(JIndex,NameSpell)
    
    s NameSpell0=NameSpell
    f  s NameSpell0=$o(^DHCWMRHISTORY(0,"NameSpell",NameSpell0)) q:(NameSpell0'[NameSpell)!(NameSpell0="")  d
    .s err=$$xxxx(JIndex,NameSpell0)
    q JIndex
    
xxxx(JIndex,NameSpell)
    n (JIndex,NameSpell)
    
    s HistoryRowid="0"
    f  s HistoryRowid=$o(^DHCWMRHISTORY(0,"NameSpell",NameSpell,HistoryRowid)) q:HistoryRowid=""  d
    .;^DHCWMRMAIN(0,"HISTORY",{History_DR},{Rowid})
    .q:'$d(^DHCWMRMAIN(0,"HISTORY",+HistoryRowid))
    .s MainRowid="0"
    .f  s MainRowid=$o(^DHCWMRMAIN(0,"HISTORY",+HistoryRowid,MainRowid)) q:MainRowid=""  d
    ..s ^CacheTemp("DHCWMRHistory",JIndex,+MainRowid)=""
    q 0
}

/// *****************************************************************
/// 事务           :  SaveHistory
/// 功能描述       ： 保存手工录入的历史数据
///                   1、保存历史信息DHC_WMR_History
///                   2、保存病案主信息DHC_WMR_Main
///                   3、保存卷历史就诊信息DHC_WMR_HistoryAdm
///                   4、保存卷DHC_WMR_MainVolume
/// by ZF 2007-05
/// 入参           ：
/// sHistory       :  DHC_WMR_History串
/// sMain          :  DHC_WMR_Main串
/// sHisVolList    :  $c(1) 分隔 包含DHC_WMR_HistoryAdm和DHC_WMR_MainVolume信息
/// 返回值         ： ret=0 成功    ret<0 失败
/// 
/// update by zf 2008-05-30
/// Papmi不为空的情况  
/// 不对历史基本信息表中插入数据
/// 不更新病案主表中的History_Dr字段
/// *****************************************************************
ClassMethod SaveHistory(sHistory, sMain, sHisVolList, LocId, UserId)
{
	n (sHistory, sMain, sHisVolList,LocId,UserId)
	
    /***********************************
    /sHisVolList
    ; AdmitDate	就诊日期
    ; AdmitTime	就诊时间
    ; AdmitDep	就诊科室
    ; AdmitStatus	就诊时状态
    ; DischargeDate	出院日期
    ; DischargeTime	出院时间
    ; DischargeDep	出院科室
    ; Diagnose	诊断
	***********************************/
	s ret=-100
	s MrType=$p(sMain,"^",2)
	s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
	;s LastItemDr=+$p(sFlow,$c(1),$l(sFlow,$c(2)))
	s LastItemDr=+$p($p(sFlow,$c(1),$l(sFlow,$c(1))),"^",3)
	q:LastItemDr=0 ret
	s xMrNo=$p(sMain,"^",3)
	q:xMrNo="" ret
	q:'$d(^DHCWMRNO(0,"TypeNo",+MrType)) ret
	q:(+LocId=0)||(+UserId=0) ret
	
	TStart
	s ret=-1
	s xPapmi=+$p(sMain,"^",4)
	s:xPapmi=0 xPapmi=""
	s HistoryRowid=0
	//Modify By LiYang 2009-12-03 记录日志
	s ret=##class(web.DHCWMRHistoryLogCtl).Update(+$p(sMain,"^",1),sHistory,sHisVolList,UserId)
	s:xPapmi="" HistoryRowid=..UpdateHistory(sHistory)
	i HistoryRowid<0 TRollBack
    q:HistoryRowid<0 ret
    
    s ret=-1.5
    s xMrNoStr=""
    ;^DHCWMRNO(0,"TypeNo",{MrType_Dr},{MrNo},{Rowid})
    i $d(^DHCWMRNO(0,"TypeNo",+MrType,xMrNo))  d
    .s xId=$o(^DHCWMRNO(0,"TypeNo",+MrType,xMrNo,0))
    .q:+xId=0
    .s xMrNoStr=##class(web.DHCWMRNoCtl).GetDataById(xId)
    .s $p(xMrNoStr,"^",4)="N"
    e  d
	.s $p(xMrNoStr,"^",2)=MrType	  ;病案类型
	.s $p(xMrNoStr,"^",3)=xMrNo	      ;病案号
	.s $p(xMrNoStr,"^",4)="N"	      ;是否有效
	.s $p(xMrNoStr,"^",5)=LocId	      ;所属接诊科室
	.s $p(xMrNoStr,"^",6)=UserId	      ;发放操作员
	.s $p(xMrNoStr,"^",7)=$zd(+$h,3)	      ;发放日起
	.s $p(xMrNoStr,"^",8)=$zt($p($h,",",2))	      ;发放时间
	s NoFlag=##class(web.DHCWMRNoCtl).Update(xMrNoStr)
	i NoFlag<0 TRollBack
	
	s ret=-2
	s:xPapmi="" $p(sMain,"^",5)=+HistoryRowid
	s $p(sMain,"^",7)="Y"
	s $p(sMain,"^",8)="Y"
	s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	i MainRowid<0 TRollBack
    q:MainRowid<0 ret
	
	s ret=-3
	s flag=0
	f index=1:1:$l(sHisVolList,$c(1)) q:flag<0  d
	.s sAdm=$p(sHisVolList,$c(1),index)
	.q:sAdm=""
	.s xVolId=+$p(sAdm,"^",1)
	.s xIPNum=+$p(sAdm,"^",2)
	.s $p(sAdm,"^",1)=""
	.s $p(sAdm,"^",2)=""
	.s AdmitDate=$p(sAdm,"^",3)
	.s AdmitTime=$p(sAdm,"^",4)
	.s AdmitDep=$p(sAdm,"^",5)
	.s AdmitStatus=$p(sAdm,"^",6)
	.s DischargeDate=$p(sAdm,"^",7)
	.s DischargeTime=$p(sAdm,"^",8)
	.s DischargeDep=$p(sAdm,"^",9)
	.s Diagnose=$p(sAdm,"^",10)
	.
	.s ret=-3.1_index
	.s sAdm=""
	.i xVolId=0 d
	..s $p(sAdm,"^",2)=HistoryRowid
	..s $p(sAdm,"^",3)=AdmitDate
	..s $p(sAdm,"^",4)=AdmitTime
	..s $p(sAdm,"^",5)=AdmitDep
	..s $p(sAdm,"^",6)=AdmitStatus
	..s $p(sAdm,"^",7)=DischargeDate
	..s $p(sAdm,"^",8)=DischargeTime
	..s $p(sAdm,"^",9)=DischargeDep
	..s $p(sAdm,"^",10)=Diagnose
	.e  d
	..s xAdmId=+$p($g(^DHCWMRVOL(xVolId)),"^",3)
	..q:xAdmId=0
	..s xtmp=xAdmId_"^"_$g(^DHCWMRHISADM(xAdmId))
	..s sAdm=xtmp
	..s $p(sAdm,"^",3)=AdmitDate
	..s $p(sAdm,"^",4)=AdmitTime
	..s $p(sAdm,"^",5)=AdmitDep
	..s $p(sAdm,"^",6)=AdmitStatus
	..s $p(sAdm,"^",7)=DischargeDate
	..s $p(sAdm,"^",8)=DischargeTime
	..s $p(sAdm,"^",9)=DischargeDep
	..s $p(sAdm,"^",10)=Diagnose
	.
	.s AdmRowid=0
	.s:sAdm'="" AdmRowid=..UpdateAdm(sAdm)
	.i AdmRowid<0 d
	..s flag=AdmRowid
	..TRollBack
	.q:AdmRowid<0
	.
	.s ret=-3.2_index
	.s sVolume=""
	.i xVolId'=0 d
	..s sVolume=##Class(web.DHCWMRVolumeCtl).GetVolume(xVolId)
	.e  d
	..s $p(sVolume,"^",2)=+MainRowid
	..s $p(sVolume,"^",4)=AdmRowid
	..s $p(sVolume,"^",7)=LastItemDr
	..s $p(sVolume,"^",8)="Y"
	..s $p(sVolume,"^",9)="N"
	.;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	.;s $p(sVolume,"^",10)=##Class(web.DHCWMRReceipt).GetIPCount("",MainRowid)
	.s $p(sVolume,"^",10)=+xIPNum
	.
	.s VolRowid=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
	.i VolRowid<0 d
	..s flag=VolRowid
	..TRollBack
	.q:VolRowid<0
	
	TCommit
	s ret=0
	q ret
	
	/*
    ;取住院次数
GetIPCount(IPCount,MainRowid)
    n (IPCount,MainRowid)
    if +IPCount>0 d      ;如果录入住院次数，取录入的数据
    .s IPCount=+IPCount
    e  d
    .;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})   ;未录入，且无历史，默认为首次
    .if '$d(^DHCWMRVOL(0,"Main",MainRowid)) s IPCount=1
    .e  d
    ..s VolRowid="",IPCount=0      ;未录入，取最后一次的住院次数，加1
    ..f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid),-1)  q:(+VolRowid=0)!(IPCount>0)  d
    ...s Active=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
    ...q:Active'="Y"
    ...s Count=+$p($g(^DHCWMRVOL(+VolRowid)),"^",9)
    ...s IPCount=Count+1
    
    q IPCount
    */
}

}

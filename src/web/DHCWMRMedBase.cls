Import SQLUser

/// 医政系统的公共函数库 
Class web.DHCWMRMedBase Extends (%Library.RegisteredObject, websys.Abstract) [ Not ProcedureBlock ]
{

Parameter BUILD = 23;

ClassMethod BeginTran()
{
 ;开始一个事务
 Tstart
 q
}

ClassMethod Commit()
{
 ;提交事务
 TCommit
 q
}

ClassMethod RollBack()
{
 ;事务回滚
 TRo
 q
}

//获取病区列表       

ClassMethod getctloc()
{
      
   k PLIST 
   n ctlocRowid,ctlctype,ctlcDesc,i
   s i=0
   s ctlocRowid=0 f  s ctlocRowid=$o(^CTLOC(ctlocRowid)) q:ctlocRowid=""  d
   .s ctlocRowid=+ctlocRowid
   .s ctlctype=$p(^CTLOC(ctlocRowid),"^",13)
   .;q:(ctlctype="W")!(ctlctype="D")!(ctlctype="C")!(ctlctype="O")
   .;q:(ctlctype="EM")!(ctlctype="DS")
   .s ctlcDesc=$p(^CTLOC(ctlocRowid),"^",2)
   .s i=i+1
   . s PLIST(i)=ctlocRowid_$c(2)_ctlcDesc
   s P1=i
   q 0
}

//获取所有的科室列表

ClassMethod getDepartmentALL()
{
   k PLIST 
   n depRowid,ctlctype,dep2Desc,i
   s i=0
   s depRowid=0 f  s depRowid=$o(^RBC("DEP",depRowid)) q:depRowid=""  d
   .s depRowid=+depRowid
   .s dep2Desc=$p(^RBC("DEP",+depRowid),"^",2)
   .s i=i+1
   . s PLIST(i)=depRowid_$c(2)_dep2Desc
   s P1=i
   q 0
}

//获取科室信息

//parlocid：父科室ID

ClassMethod getDepartment(parlocid)
{
	n (parlocid)
    k PLIST 
    s depdr=$P(^CTLOC(parlocid),"^",19)  
    s depdrdesc=$p($g(^RBC("DEP",+depdr)),"^",2)
    s PLIST(1)=depdr_$c(2)_depdrdesc
    s P1=1
    q P1
}

ClassMethod GetDepartmentOrLocation(Locid)
{
	 ;********************start*********************
     ;2007-12-18 ZF Add
    ;根据基础数据配置取科室/部门组信息
    ;功能同$$getDepartment^DHCWMRMedBase()
    ;^DHCMedHosptial(0)第二个数据
    ;（0-部门组/科室，1-科室/科室）
    n (Locid)
    s ret=""
    s tmpConfig=$g(^DHCMedHosptial(0))
    s DepGroup=+$p(tmpConfig,"/",2)
    i DepGroup=1 d
    .s Rowid=+Locid
    .s Desc=$P($g(^CTLOC(+Locid)),"^",2)
    e  d
    .s Rowid=$P($g(^CTLOC(+Locid)),"^",19)
    .s Desc=$p($g(^RBC("DEP",+Rowid)),"^",2)
    s ret=Rowid_$c(2)_Desc
    q ret
 ;********************end***********************
                                         
 ;getdoc(loc)             
         ;q:loc="" 0
         ;k PLIST,P1
         ;n ctlocRowid,ctlctype,ctlcDesc,i,ssusrRowid,ssusrDeptDR,ssusrName,numb
         ;n resrid,resctpcp,SSusrgroup,SSusrActive
         ;n CpTypDR,CpTyp,CpTyp,curctpcpdesc
         ;s numb=0
         ;s ctlocRowid=0
         ;s ctlocRowid=0
         ;;s loc=$$ALPHAUP^SSUTIL4(loc) ;
         ;;s ctlocRowid=$o(^CTLOC(0,"Desc",loc,ctlocRowid)) 
         ;s ctlocRowid=$g(loc)
         ;s ctlocRowid=+ctlocRowid
         ;q:ctlocRowid="" 0
         ;s resrid=0 f  s resrid=$o(^RB("RES",0,"CTLOC",ctlocRowid,resrid)) q:resrid=""  d
         .;s resctpcp=$p(^RB("RES",resrid),"^",2)
         .;s resctpcp=+resctpcp  
         .;q:resctpcp=0 
         .;s SSusrActive=$P(^CTPCP(resctpcp,1),"^",9)  
         .;q:SSusrActive'="Y"       
         .;s CpTypDR=$P(^CTPCP(resctpcp,1),"^",4)  
         .;q:(CpTypDR="")
         .;s CpTypDR=+CpTypDR
         .;;s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
         .;;q:($G(CpTyp)'="DOCTOR")
         .;s curctpcpdesc=$P(^CTPCP(resctpcp,1),"^",2)    
         .;q:($g(curctpcpdesc)="")
         .;;s ssusrName=$p(^SSU("SSUSR",ssusrRowid),"^",2)
         .;s numb=numb+1
         . ;s PLIST(numb)=$g(CpTypDR)_$c(2)_$g(curctpcpdesc)
         ;s P1=numb
         ;q numb
}

ClassMethod getSingleCtloc(SingleCtloc)
{
  n (SingleCtloc)
  k P5 
  n ctlocRowid,ctlcDesc
  s ctlocRowid=+SingleCtloc
  s ctlcDesc=$p(^CTLOC(ctlocRowid),"^",2)
  s P5=ctlocRowid_$c(2)_ctlcDesc
  q 0
}

ClassMethod getdoc(loc)
{
   n (loc)   
   q:loc="" 0
   k PLIST,P1
   n ctlocRowid,ctlctype,ctlcDesc,i,ssusrRowid,ssusrDeptDR,ssusrName,numb
   n resrid,resctpcp,SSusrgroup,SSusrActive
   n CpTypDR,CpTyp,CpTyp,curctpcpdesc
   k ^dhctempgetdoc($j)
   s numb=0
   s ctlocRowid=0
   s ctlocRowid=0
   s ctlocRowid=$g(loc)
   s ctlocRowid=+ctlocRowid
   q:ctlocRowid="" 0
   s resrid=0 f  s resrid=$o(^RB("RES",0,"CTLOC",ctlocRowid,resrid)) q:resrid=""  d
   .s resctpcp=$p(^RB("RES",resrid),"^",2)
   .s resctpcp=+resctpcp  
   .q:resctpcp=0 
   .s SSusrActive=$P(^CTPCP(resctpcp,1),"^",9)  
   .q:SSusrActive'="Y"  
   .s ssusrID="" s ssusrID=$o(^SSU("SSUSR",0,"CTPCP",resctpcp,ssusrID))
   .q:(+ssusrID)=0   
   .s ssInitials=$p(^SSU("SSUSR",ssusrID),"^",1)
   .q:ssInitials=""
   .s ssName=$p(^SSU("SSUSR",ssusrID),"^",2) 
   .s ^dhctempgetdoc($j,ssInitials,ssusrID)=$g(ssName)
   i $d(^dhctempgetdoc($j))'=0 d
   .s tempssInitials="" f  s tempssInitials=$o(^dhctempgetdoc($j,tempssInitials))  q:tempssInitials=""  d
   ..s tempssusrID="" f  s tempssusrID=$o(^dhctempgetdoc($j,tempssInitials,tempssusrID))  q:tempssusrID=""  d
   ...s tempssName=$g(^dhctempgetdoc($j,tempssInitials,tempssusrID))
   ...s numb=numb+1
   ...s PLIST(numb)=$g(tempssusrID)_$c(2)_$g(tempssInitials)_"!"_$g(tempssName)
   k ^dhctempgetdoc($j)
   s P1=numb
   q numb
}

/// w ##Class(web.DHCWMRMedBase).GetgroupLocDesc2(2)
ClassMethod GetgroupLocDesc2(CTLOCDepDR)
{
	n (CTLOCDepDR)
    k PLIST       
    s num=0
    ;s CTLOCDepDR=+$p(^CTLOC(ctlocrd),"^",19)       ;CTLOC_Dep_DR
    Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set LABDATA=Config.LabDataNamespace
	Set CurrentNS=$ZNSPACE
	d Config.%Close()
	zn MEDDATA
    s err=$$open^MVBCTLO4("","",CTLOCDepDR,"","") 
          
    f  s err=$$fetch^MVBCTLO4("","",CTLOCDepDR,"","") q:(err=100)  d
    .s num=num+1
    .s WARDLocationDR=PLIST(1)      ;ctlocrowid
    .s locdesc=PLIST(3)
    .s MLIST(num)=WARDLocationDR_$c(2)_locdesc
    s err=$$close^MVBCTLO4()
    zn CurrentNS
    k PLIST
    m PLIST=MLIST
    k MLIST
    s P1=num 
    q num
}

//查询出院病人

//date1：开始日期

//date2：结束日期

//parctloc ：病区           

ClassMethod getDischpa(date1, date2, parctloc)
{
   n (date1,date2,parctloc,MLIST,PLIST)
   k MLIST,PLIST
   s date1=$zdh(date1,3)
   s date2=$zdh(date2,3)
   s tmpNum=0
   f curdate=date1:1:date2  d
   .s admrowid=0 f  s admrowid=$o(^PAADMi("DischDate",curdate,admrowid)) q:(admrowid="")  d
   ..q:(admrowid="")
   ..s admrowid=+admrowid
   ..s admtype=$p(^PAADM(admrowid),"^",2)
   ..s admtype=$g(admtype)
   ..q:(admtype'="I") 
   ..;s DischgDoc=$p(^PAADM(admrowid),"^",19)
   ..;q:(DischgDoc="")  
   ..s PAPMIDR=$p($g(^PAADM(admrowid)),"^",1)
   ..s PAPMIDR=+PAPMIDR   
   ..;s MedDischDoc=$p($g(^PAADM(admrowid)),"^",63)
   ..s MedDischDoc=$p($g(^PAADM(admrowid)),"^",79)
   ..q:MedDischDoc=""
   ..s mradmid=$p($g(^PAADM(admrowid)),"^",61)
   ..q:mradmid=""
   ..s mradmid=+mradmid
   ..s diccharDescID=$p(^MR(mradmid,"PRO",1),"^",10)
   ..s diccharDescID=+$g(diccharDescID)
   ..q:diccharDescID'=3
   ..i MedDischDoc'="" s MedDischDocDesc=$p(^CTPCP(+MedDischDoc,1),"^",2)
   ..s DepCodeDR=$p($g(^PAADM(admrowid)),"^",4)
   ..q:(parctloc'="")&(parctloc'=DepCodeDR)
   ..q:(DepCodeDR="")
   ..s Depdesc=$p($g(^CTLOC(+DepCodeDR)),"^",2)
   ..s Depdesc=$g(Depdesc)
   ..i Depdesc["-" s Depdesc=$p(Depdesc,"-",2)
   ..s papmicur=$p($g(^PAADM(admrowid)),"^",1)
   ..s depdr=$P(^CTLOC(+DepCodeDR),"^",19)  
   ..s depdrdesc=$p(^RBC("DEP",+depdr),"^",2)
   ..;b
   ..s DeceasedTM=$p($g(^PAPER(+papmicur,"ALL")),"^",8)
   ..s DeceasedDT=$p($g(^PAPER(+papmicur,"ALL")),"^",13)
   ..q:(DeceasedDT'="")&(DeceasedDT<date1)
   ..i DeceasedDT'="" s DeceasedDT=$zd(DeceasedDT,3)
   ..i DeceasedTM'="" s DeceasedTM=$zt(DeceasedTM,3)
   ..s DischgDate=$p($g(^PAADM(admrowid)),"^",17)
   ..i DischgDate'="" s DischgDate=$zd(DischgDate,3)
   ..s papmino=$p(^PAPER(PAPMIDR,"PAT",1),"^",1) 
   ..s paname =$p(^PAPER(PAPMIDR,"ALL"),"^",1)  
   ..s tmpNum=tmpNum+1
   ..s MLIST(tmpNum)=$g(Depdesc)_$c(2)_$g(depdrdesc)_$c(2)_$g(papmino)_$c(2)_$g(paname)_$c(2)_$g(DeceasedDT)_$c(2)_$g(DeceasedTM)
   q tmpNum
}

ClassMethod Getform(row1, row2)
{
   n (row1,row2)           
   K PLIST
   s m=0
   f i=row1:1:row2 d
   . s m=m+1
   . s PLIST(m)=MLIST(i) 
   . k MLIST(i)  
   s P0=m
   q 0
}

//查询出院病人

//date1：开始日期

//date2：结束日期

//parctloc ：病区 

//parDepartment：科室              

ClassMethod getDischpa2(date1, date2, parctloc, parDepartment)
{
   n (date1,date2,parctloc,parDepartment,MLIST,PLIST)
   k MLIST,PLIST
   s date1=$zdh(date1,3)
   s date2=$zdh(date2,3)
   s tmpNum=0
   f curdate=date1:1:date2  d
   .s admrowid=0 f  s admrowid=$o(^PAADMi("DischDate",curdate,admrowid)) q:(admrowid="")  d
   ..q:(admrowid="")
   ..s admrowid=+admrowid
   ..s admtype=$p(^PAADM(admrowid),"^",2)
   ..s admtype=$g(admtype)
   ..q:(admtype'="I") 
   ..;s DischgDoc=$p(^PAADM(admrowid),"^",19)
   ..;q:(DischgDoc="")  
   ..s PAPMIDR=$p($g(^PAADM(admrowid)),"^",1)
   ..s PAPMIDR=+PAPMIDR   
   ..;s MedDischDoc=$p($g(^PAADM(admrowid)),"^",63)
   ..s MedDischDoc=$p($g(^PAADM(admrowid)),"^",79)
   ..q:MedDischDoc=""                             ;医疗结算
   ..s mradmid=$p($g(^PAADM(admrowid)),"^",61)
   ..q:mradmid=""
   ..s mradmid=+mradmid
   ..s diccharDescID=$p(^MR(mradmid,"PRO",1),"^",10)      ;十分死亡
   ..s diccharDescID=+$g(diccharDescID)
   ..q:diccharDescID'=3
   ..s warddescCur=""
   ..i MedDischDoc'="" s MedDischDocDesc=$p(^CTPCP(+MedDischDoc,1),"^",2)
   ..s DepCodeDR=$p($g(^PAADM(admrowid)),"^",4)
   ..;q:(parctloc'="")&(parctloc'=DepCodeDR)
   ..q:(DepCodeDR="")
   ..s Depdesc=$p($g(^CTLOC(+DepCodeDR)),"^",2)
   ..s Depdesc=$g(Depdesc)
   ..i Depdesc["-" s Depdesc=$p(Depdesc,"-",2)
   ..s papmicur=$p($g(^PAADM(admrowid)),"^",1)       
   ..s depdr=$P(^CTLOC(+DepCodeDR),"^",19)  
   ..s depdr=+depdr
   ..;b
   ..q:(parDepartment'="")&(parDepartment'=depdr)
   ..s depdrdesc=$p(^RBC("DEP",depdr),"^",2)
   ..s flagward=0,curloctype=""
   ..i parctloc'="" d
   ...b
   ...s curloctype=$P(^CTLOC(+parctloc),"^",13)    ;ctloctype  
   ...i curloctype="W" d
   ....b
   ....s parwardid=$o(^PAWARD(0,"WARD_LocationDR",parctloc,"")) 
   ....s parwardid=+$g(parwardid)
   ....s paadmwardid=$p(^PAADM(admrowid),"^",70)
   ....s paadmwardid=+$g(paadmwardid)
   ....i paadmwardid=0 d
   .....s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",""),-1) 
   .....i TRANSChildsub'="" s paadmwardid=$p(^PAADM(admrowid,"TRANS",+TRANSChildsub),"^",9)
   .....s paadmwardid=+$g(paadmwardid)
   ....i (parwardid'=paadmwardid) s flagward=1
   ...e  d
   ....i (parctloc'=DepCodeDR) s flagward=1
   ..q:flagward=1
   ..s paadmwardid=$p(^PAADM(admrowid),"^",70)
   ..s paadmwardid=+$g(paadmwardid)
   ..i paadmwardid=0 d
   ...s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",""),-1) 
   ...i TRANSChildsub'="" s paadmwardid=$p(^PAADM(admrowid,"TRANS",+TRANSChildsub),"^",9)
   ..s paadmwardid=+$g(paadmwardid)
   ..i paadmwardid'=0 s warddescCur=$p(^PAWARD(paadmwardid),"^",2) 
   ..i warddescCur["-" s warddescCur=$p(warddescCur,"-",2)
   ..i (curloctype="W")!(parctloc="") s Depdesc=$g(warddescCur)
   ..;b
   ..s DeceasedTM=$p($g(^PAPER(+papmicur,"ALL")),"^",8)
   ..s DeceasedDT=$p($g(^PAPER(+papmicur,"ALL")),"^",13)
   ..q:(DeceasedDT'="")&(DeceasedDT<date1)
   ..i DeceasedDT'="" s DeceasedDT=$zd(DeceasedDT,3)
   ..i DeceasedTM'="" s DeceasedTM=$zt(DeceasedTM,3)
   ..s DischgDate=$p($g(^PAADM(admrowid)),"^",17)
   ..i DischgDate'="" s DischgDate=$zd(DischgDate,3)
   ..s papmino=$p(^PAPER(PAPMIDR,"PAT",1),"^",1) 
   ..s paname =$p(^PAPER(PAPMIDR,"ALL"),"^",1)  
   ..s tmpNum=tmpNum+1
   ..s MLIST(tmpNum)=$g(depdrdesc)_$c(2)_$g(Depdesc)_$c(2)_$g(papmino)_$c(2)_$g(paname)_$c(2)_$g(DeceasedDT)_$c(2)_$g(DeceasedTM)
   q tmpNum
}

ClassMethod getDischpa3(date1, date2, parctloc, parDepartment)
{
   n (date1,date2,parctloc,parDepartment,MLIST,PLIST)
   k MLIST,PLIST,P0
   s date1=$zdh(date1,3)
   s date2=$zdh(date2,3)
   s frmdat11=date1-15
   s frmdat22=date2+15
   s tmpNum=0
   s admrowid=0 
   Set Config=##Class(websys.Configuration).%OpenId(1)
   Set MEDDATA=Config.DataNamespace
   Set LABDATA=Config.LabDataNamespace
   Set CurrentNS=$ZNSPACE
   d Config.%Close()
   
   f  s admrowid=$o(^PAADMi("PAADM_Type","I",admrowid)) q:(admrowid="")  d  
   .q:(admrowid="")
   .s admrowid=+admrowid
   .;4442983
   .;i admrowid="3338965" w !,"12" b
   .s warddescCur=""
   .s tmpDischDate=$p($g(^PAADM(admrowid)),"^",17)
   .q:(tmpDischDate'="")&((tmpDischDate'>frmdat11)!(tmpDischDate'<frmdat22))
   .;i admrowid="3414298" w !,"1222" b
   .s tmpadmDate=$p($g(^PAADM(admrowid)),"^",6)
   .q:(tmpadmDate'="")&(tmpadmDate'<frmdat22)
   .i tmpadmDate'="" s tmpadmDate=$zd(tmpadmDate,3)
   .s PAPMIDR=$p($g(^PAADM(admrowid)),"^",1)
   .s PAPMIDR=+PAPMIDR   
   .s mradmid=$p($g(^PAADM(admrowid)),"^",61)
   .;i admrowid="4441689" w !,"16" b
   .q:mradmid=""
   .s mradmid=+mradmid
   .s DepCodeDR=$p($g(^PAADM(admrowid)),"^",4)
   .q:(DepCodeDR="")
   .s Depdesc=$p($g(^CTLOC(+DepCodeDR)),"^",2)
   .s Depdesc=$g(Depdesc)
   .i admrowid="3338968" w !,"12" b
   .;i Depdesc["-" s Depdesc=$p(Depdesc,"-",2)
   .s papmicur=$p($g(^PAADM(admrowid)),"^",1)
   .s depdr=$P(^CTLOC(+DepCodeDR),"^",19)  
   .s depdr=+depdr
   .q:(parDepartment'="")&(parDepartment'=depdr)
   .s depdrdesc=$p(^RBC("DEP",depdr),"^",2)
   .s flagward=0,curloctype=""
   .i parctloc'="" d
   ..s curloctype=$P(^CTLOC(+parctloc),"^",13)    ;ctloctype  
   ..i curloctype="W" d
   ...s parwardid=$o(^PAWARD(0,"WARD_LocationDR",parctloc,"")) 
   ...s parwardid=+$g(parwardid)
   ...s paadmwardid=$p(^PAADM(admrowid),"^",70)
   ...s paadmwardid=+$g(paadmwardid)
   ...i paadmwardid=0 d
   ....s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",""),-1) 
   ....i TRANSChildsub'="" s paadmwardid=$p(^PAADM(admrowid,"TRANS",+TRANSChildsub),"^",9)
   ....s paadmwardid=+$g(paadmwardid)
   ...i (parwardid'=paadmwardid) s flagward=1
   ..e  d
   ...i (parctloc'=DepCodeDR) s flagward=1
   .;i admrowid="4441689" w !,"13" b
   .q:flagward=1
   .s paadmwardid=$p(^PAADM(admrowid),"^",70)
   .s paadmwardid=+$g(paadmwardid)
   .;i admrowid="3338968" w !,"1342" b
   .s falgward=0
   .i paadmwardid=0 d
   ..s TRANSChildsub="" f  s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",TRANSChildsub),-1) q:(TRANSChildsub="")!(falgward=1)  d 
   ...s paadmwardid=$p(^PAADM(admrowid,"TRANS",TRANSChildsub),"^",9)
   ...;i admrowid="3338968" b
   ...s paadmwardid=+$g(paadmwardid)
   ...i paadmwardid'=0 s falgward=1
   .e  d
   ..s Depdesc=$p(^PAWARD(paadmwardid),"^",2)
   ..;i warddescCur["-" s Depdesc=$p(warddescCur,"-",2)
   .i falgward=1 d
   ..s warddescCur=$p(^PAWARD(paadmwardid),"^",2) 
   ..;i warddescCur["-" s warddescCur=$p(warddescCur,"-",2)
   ..i (curloctype="W")!(parctloc="") s Depdesc=$g(warddescCur)
   .;i admrowid="3338968" w !,"Depdesc=",Depdesc b
   .k PLIST
   .s dignoseAll=""
   .;i admrowid="4441689" w !,"mradmid=",mradmid b
   .zn MEDDATA
   .s err=$$open^MVBMRDIA(mradmid,"","","") f  s err=$$fetch^MVBMRDIA(mradmid,"","","") q:(err=100)  d
   ..s dignoseDesc=$P(PLIST(4),$C(1),2)
   ..s dignoseCode=$P(PLIST(4),$C(1),3)
   ..s dignosedate=$P(PLIST(14),$C(1),1)
   ..q:(dignosedate'="")&((dignosedate'>frmdat11)!(dignosedate'<frmdat22))
   ..i dignosedate'="" s dignosedate=$zd(dignosedate,3)
   ..s dignosetime=$P(PLIST(15),$C(1),1)
   ..i dignosetime'="" s dignosetime=$zt(dignosetime,2)
   ..s dignoseTypeID=PLIST(1)
   ..s dignoseDOC=$P(PLIST(19),$C(1),2)
   ..s dignoseDOCID=$P(PLIST(19),$C(1),1)
   ..;s digtyeDr=PLIST(1)
   ..s aa=$$getdesc^MVBMRDIA()
   ..s dignosememo=$g(PLIST)
   ..s dignoseTypeDESC=""
   ..s err=$$open^MVBMRDIT(dignoseTypeID) f  s err=$$fetch^MVBMRDIT(dignoseTypeID) q:(err=100)  d
   ...s dignoseTypeDESC=$P(PLIST(3),$C(1),2)
   ..s bb=$$close^MVBMRDIT()
   ..s dignoseAll=dignoseAll_"@"_dignoseTypeDESC_" "_dignosememo_"\"_dignoseDesc_"\"_dignoseCode_"\"_dignosedate_"\"_dignosetime_"\"_dignoseDOC_"\"_dignoseDOCID
   .s cc=$$close^MVBMRDIA()
   .zn CurrentNS
   .q:(dignoseAll="")
   .s dignoseAll=$p(dignoseAll,"@",2,20)
   .;i admrowid="4484583" w !,"dignoseAll",dignoseAll b
   .s papmino=$p(^PAPER(PAPMIDR,"PAT",1),"^",1) 
   .s paname =$p(^PAPER(PAPMIDR,"ALL"),"^",1) 
   .;s curdateTemp=$zd(curdate,3) 
   .s tmpNum=tmpNum+1
   .s MLIST(tmpNum)=$g(tmpadmDate)_$c(2)_$g(papmino)_$c(2)_$g(paname)_$c(2)_$g(Depdesc)_$c(2)_$g(depdrdesc)_$c(2)_$g(dignoseAll)
   s P0=tmpNum
   q tmpNum
}

ClassMethod getDischpa4(date1, date2, parctloc, parDepartment)
{
   n (date1,date2,parctloc,parDepartment,MLIST,PLIST)
   k MLIST,PLIST,P0
   s date1=$zdh(date1,3)
   s date2=$zdh(date2,3)
   s frmdat11=date1-15
   s frmdat22=date2+15
   s tmpNum=0
   Set Config=##Class(websys.Configuration).%OpenId(1)
   Set MEDDATA=Config.DataNamespace
   Set LABDATA=Config.LabDataNamespace
   Set CurrentNS=$ZNSPACE
   d Config.%Close()
   
 s admrowid=0 
 f  s admrowid=$o(^PAADMi("PAADM_Type","I",admrowid)) q:(admrowid="")  d  
 .q:(admrowid="")
 .s admrowid=+admrowid
 .;4442983
 .;i admrowid="3338965" w !,"12" b
 .s warddescCur=""
 .s tmpDischDate=$p($g(^PAADM(admrowid)),"^",17)
 .q:(tmpDischDate'="")&((tmpDischDate'>frmdat11)!(tmpDischDate'<frmdat22))
 .;i admrowid="3414298" w !,"1222" b
 .s tmpadmDate=$p($g(^PAADM(admrowid)),"^",6)
 .q:(tmpadmDate'="")&(tmpadmDate'<frmdat22)
 .i tmpadmDate'="" s tmpadmDate=$zd(tmpadmDate,3)
 .s PAPMIDR=$p($g(^PAADM(admrowid)),"^",1)
 .s PAPMIDR=+PAPMIDR   
 .s mradmid=$p($g(^PAADM(admrowid)),"^",61)
 .;i admrowid="4441689" w !,"16" b
 .q:mradmid=""
 .s mradmid=+mradmid
 .s DepCodeDR=$p($g(^PAADM(admrowid)),"^",4)
 .q:(DepCodeDR="")
 .s Depdesc=$p($g(^CTLOC(+DepCodeDR)),"^",2)
 .s Depdesc=$g(Depdesc)
 .i admrowid="3338968" w !,"12" b
 .;i Depdesc["-" s Depdesc=$p(Depdesc,"-",2)
 .s papmicur=$p($g(^PAADM(admrowid)),"^",1)
 .s depdr=$P(^CTLOC(+DepCodeDR),"^",19)  
 .s depdr=+depdr
 .q:(parDepartment'="")&(parDepartment'=depdr)
 .s depdrdesc=$p(^RBC("DEP",depdr),"^",2)
 .s flagward=0,curloctype=""
 .i parctloc'="" d
 ..s curloctype=$P(^CTLOC(+parctloc),"^",13)    ;ctloctype  
 ..i curloctype="W" d
 ...s parwardid=$o(^PAWARD(0,"WARD_LocationDR",parctloc,"")) 
 ...s parwardid=+$g(parwardid)
 ...s paadmwardid=$p(^PAADM(admrowid),"^",70)
 ...s paadmwardid=+$g(paadmwardid)
 ...i paadmwardid=0 d
 ....s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",""),-1) 
 ....i TRANSChildsub'="" s paadmwardid=$p(^PAADM(admrowid,"TRANS",+TRANSChildsub),"^",9)
 ....s paadmwardid=+$g(paadmwardid)
 ...i (parwardid'=paadmwardid) s flagward=1
 ..e  d
 ...i (parctloc'=DepCodeDR) s flagward=1
 .;i admrowid="4441689" w !,"13" b
 .q:flagward=1
 .s paadmwardid=$p(^PAADM(admrowid),"^",70)
 .s paadmwardid=+$g(paadmwardid)
 .;i admrowid="3338968" w !,"1342" b
 .s falgward=0
 .i paadmwardid=0 d
 ..s TRANSChildsub="" f  s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",TRANSChildsub),-1) q:(TRANSChildsub="")!(falgward=1)  d 
 ...s paadmwardid=$p(^PAADM(admrowid,"TRANS",TRANSChildsub),"^",9)
 ...;i admrowid="3338968" b
 ...s paadmwardid=+$g(paadmwardid)
 ...i paadmwardid'=0 s falgward=1
 .i falgward=1 d
 ..s warddescCur=$p(^PAWARD(paadmwardid),"^",2) 
 ..;i warddescCur["-" s warddescCur=$p(warddescCur,"-",2)
 ..i (curloctype="W")!(parctloc="") s Depdesc=$g(warddescCur)
 .;i admrowid="3338968" w !,"Depdesc=",Depdesc b
 .k PLIST
 .s dignoseAll=""
 .;i admrowid="4441689" w !,"mradmid=",mradmid b
 .zn MEDDATA
 .s err=$$open^MVBMRDIA(mradmid,"","","") f  s err=$$fetch^MVBMRDIA(mradmid,"","","") q:(err=100)  d
 ..s dignoseDesc=$P(PLIST(4),$C(1),2)
 ..s dignoseCode=$P(PLIST(4),$C(1),3)
 ..s dignosedate=$P(PLIST(14),$C(1),1)
 ..;q:(dignosedate'="")&((dignosedate'>frmdat11)!(dignosedate'<frmdat22))
 ..i dignosedate'="" s dignosedate=$zd(dignosedate,3)
 ..s dignosetime=$P(PLIST(15),$C(1),1)
 ..i dignosetime'="" s dignosetime=$zt(dignosetime,2)
 ..s dignoseTypeID=PLIST(1)
 ..s dignoseDOC=$P(PLIST(19),$C(1),2)
 ..s dignoseDOCID=$P(PLIST(19),$C(1),1)
 ..;s digtyeDr=PLIST(1)
 ..s aa=$$getdesc^MVBMRDIA()
 ..s dignosememo=$g(PLIST)
 ..s dignoseTypeDESC=""
 ..s err=$$open^MVBMRDIT(dignoseTypeID) f  s err=$$fetch^MVBMRDIT(dignoseTypeID) q:(err=100)  d
 ...s dignoseTypeDESC=$P(PLIST(3),$C(1),2)
 ..s bb=$$close^MVBMRDIT()
 ..s dignoseAll=dignoseAll_"@"_dignoseTypeDESC_" "_dignosememo_"\"_dignoseDesc_"\"_dignoseCode_"\"_dignosedate_"\"_dignosetime_"\"_dignoseDOC_"\"_dignoseDOCID
 .s cc=$$close^MVBMRDIA()
 .zn CurrentNS
 .q:(dignoseAll="")
 .s dignoseAll=$p(dignoseAll,"@",2,20)
 .;i admrowid="4484583" w !,"dignoseAll",dignoseAll b
 .s papmino=$p(^PAPER(PAPMIDR,"PAT",1),"^",1) 
 .s paname =$p(^PAPER(PAPMIDR,"ALL"),"^",1) 
 .;s curdateTemp=$zd(curdate,3) 
 .s tmpNum=tmpNum+1
 .s MLIST(tmpNum)=$g(tmpadmDate)_$c(2)_$g(papmino)_$c(2)_$g(paname)_$c(2)_$g(Depdesc)_$c(2)_$g(depdrdesc)_$c(2)_$g(dignoseAll)
 s P0=tmpNum
 q tmpNum
}

ClassMethod getlabcodeno(date1, date2, labcodeno)
{
 n (date1,date2,labcodeno,MLIST,PLIST)
 k MLIST,PLIST,P0
 s date1=$zdh(date1,3)
 s date2=$zdh(date2,3)
 s tmpNum=0
 s labcodeno=$g(labcodeno)
 q:(labcodeno="") 0
 s oeorderid=0 
 s oeorderid= $o(^OEORD(0,"EpisNo",labcodeno,oeorderid)) 
 q:(oeorderid="") 0
 s warddesc="",curDEPtDESC=""
 s admdr= $p($g(^OEORD(oeorderid)),"^",1)
 s admdr=+admdr
 s paadmtype=$p($g(^PAADM(admdr)),"^",2)
 q:(paadmtype'="I")&(paadmtype'="O")
 i paadmtype="O" s paadmtypedesc="Out Patient"
 i paadmtype="I" s paadmtypedesc="In Patient"
 s papmi=$p($g(^PAADM(admdr)),"^",1)
 s regno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
 s name=$p($g(^PAPER(papmi,"ALL")),"^",1)
 s ward=$p($g(^PAADM(admdr)),"^",70)
 i ward'="" s warddesc=$p($g(^PAWARD(ward)),"^",2)
 s curDEPt=$p($g(^PAADM(admdr)),"^",4)
 i curDEPt'="" s curDEPtDESC=$p(^CTLOC(curDEPt),"^",2)
 i warddesc="" s warddesc=curDEPtDESC
 s depdr2=$P(^CTLOC(curDEPt),"^",19)  
 s depdrdesc2=$p(^RBC("DEP",+depdr2),"^",2)
 s oeorisub=0  
 s oeorisub= $o(^OEORD(0,"EpisNo",labcodeno,oeorderid,oeorisub))
 s doctor="",doctorcode=""
 s docrowid=$p($g(^OEORD(oeorderid,"I",oeorisub,1)),"^",11)
 i docrowid'="" s doctor=$p($g(^CTPCP((docrowid),1)),"^",2)
 s doctorcode=$p($g(^CTPCP((docrowid),1)),"^",1)
 s updatedate2=$p($g(^OEORD(oeorderid,"I",oeorisub,3)),"^",7)
 i updatedate2'="" s updatedate2=$zd(updatedate2,3)
 s updatetime2=$p($g(^OEORD(oeorderid,"I",oeorisub,1)),"^",17)
 i updatetime2'="" s updatetime2=$zt(updatetime2)
    
 s tmpNum=tmpNum+1
 s MLIST(tmpNum)=$g(paadmtypedesc)_$c(2)_$g(updatedate2)_$c(2)_$g(updatetime2)_$c(2)_$g(doctor)_$c(2)_$g(doctorcode)_$c(2)_$g(regno)_$c(2)_$g(name)_$c(2)_$g(depdrdesc2)_$c(2)_$g(warddesc)
 s P0=tmpNum
 q tmpNum
}

ClassMethod sysdate()
{
  ;服务器时间
  k PLIST
  s aa=$h
  s PLIST(0)=$Zd($h,3)_" "_$Zt($P($h,",",2),1)
  s P2=$Zd($h,3),P3=$Zt($P($h,",",2),1)
  q
}

ClassMethod GetgroupLoc(CTLOCDepDR, cType)
{
  n (CTLOCDepDR,cType)
  k ^CacheTemp("DepLoc",$j)
  Set Config=##Class(websys.Configuration).%OpenId(1)
  Set MEDDATA=Config.DataNamespace
  Set LABDATA=Config.LabDataNamespace
  Set CurrentNS=$ZNSPACE
  d Config.%Close()
  
  zn MEDDATA
  ;s CTLOCDepDR=+$p(^CTLOC(ctlocrd),"^",19)       ;CTLOC_Dep_DR
  s err=$$open^MVBCTLO4("","",CTLOCDepDR,"","") f  s err=$$fetch^MVBCTLO4("","",CTLOCDepDR,"","") q:(err=100)  d
  .s WARDLocationDR=PLIST(1)      ;ctlocrowid
  .q:(PLIST(27)'=cType)&(cType'="")
  .s ^CacheTemp("DepLoc",$j,WARDLocationDR)=""
  .;s locdesc=PLIST(3)
  .;s MLIST(num)=WARDLocationDR_$c(2)_locdesc
  s err=$$close^MVBCTLO4()
  zn CurrentNS
  q
}

//查询用户信息

//usrId：用户的ID

ClassMethod GetUsrStr(usrId)
{
  n (usrId)
  q:usrId="" ""
  q:'$d(^SSU("SSUSR",+usrId)) ""
  s s=usrId_"/"_$p($g(^SSU("SSUSR",+usrId)),"^",1)_"/"_$p($g(^SSU("SSUSR",+usrId)),"^",2)
  q s
}

//获取病区信息

//ctloc病区ID    

ClassMethod GetCtlocStr(ctloc)
{
   n (ctloc)
   q:(ctloc="") ""
   q:(+ctloc=0) ""
   q:'$d(^CTLOC(+ctloc)) ""
   s LocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
   s LocDesc=$s(LocDesc["-":$p(LocDesc,"-",2),1:LocDesc)
   s LocTel=$p($g(^CTLOC(+ctloc)),"^",40)
   s s=ctloc_"/"_LocDesc_"/"_LocTel
   q s
}

//判断loc是否属于条件中的cdep和cloc

ClassMethod Checkctloc(cDep, cLoc, Loc)
{
    n (cDep,cLoc,Loc)
    s yFlag="1"
    /*,nFlag="0"
     q:Loc="" yFlag
        
     q:(cLoc'="")&(cLoc'=Loc) nFlag
     q:(cDep="")&(cLoc="") yFlag
    */
        
     q:Loc="" "0"
     i cLoc'=""  d
     .s:cLoc'=Loc yFlag="0"
     i (cLoc="")&(cDep'="") d
     .s CTLOCDepDR=+$p(^CTLOC(+Loc),"^",19)       ;CTLOC_Dep_DR
     .s:cDep'=CTLOCDepDR yFlag="0"         
     q yFlag
}

//判断admrowid 的Dep Loc是否属于查询条件中的qDep  qLoc       

ClassMethod CheckLoc(qDep, qLoc, Dep, Loc, admrowid)
{
  n (qDep,qLoc,Dep,Loc,admrowid)
  q:(qDep'="")&(qDep'=Dep) "1"
  s flag="0"
  i qLoc'="" d
  .s curloctype=$P(^CTLOC(+qLoc),"^",13)    ;ctloctype  
  .i curloctype="W" d
  ..s qWardid=$o(^PAWARD(0,"WARD_LocationDR",qLoc,"")) 
  ..s paadmwardid=$p(^PAADM(admrowid),"^",70)
  ..i paadmwardid=0 d
  ...s TRANSChildsub=$o(^PAADM(admrowid,"TRANS",""),-1) 
  ...i TRANSChildsub'="" s paadmwardid=$p(^PAADM(admrowid,"TRANS",+TRANSChildsub),"^",9)
  ..s:(qWardid'=paadmwardid) flag="1"
  .e  d
  ..s:qLoc'=Loc flag="1"    
  q flag
}

//通过登记号获取病人信息

ClassMethod GetPapmi(regno)
{
	n (regno)
    s regno=##Class(web.DHCWMRMedBase01).RegNoCon(regno)    //add by zf 2008-10-08  十位登记号
    s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",regno,""))
    q PAPMIRowId
}

//通过病人ID获取病人信息

ClassMethod GetPatInfo(PAPMIRowId)
{
     n (PAPMIRowId)
     ;s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
     s papmino=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
     s s=..GetPatInfo2(papmino,"","")
     q s
}

ClassMethod GetPatInfo2(regno, arglocID, argdepartID)
{
    n (regno,arglocID,argdepartID)
    s regno=##Class(web.DHCWMRMedBase01).RegNoCon(regno)    //add by zf 2008-10-08  十位登记号
    k P5,P6                 ;GetPatInfo(regno,paadmID)
    s regno=$$ALPHAUP^SSUTIL4(regno)
    ;Add by wuqk 2008-04-25
    ;s regno=##Class(web.DHCWMRMedBase01).RegNoCon(regno)
    s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
    s PAPMIRowId= $o(^PAPERi("PAPMI_PatNo",regno,-1)) 
    s PAPMIRowId=+PAPMIRowId
    s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","I",-1))
    i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","O",-1))
    i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","E",-1))
    i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","H",-1)) //Add By LiYang 2009-4-20
    q:paadmID="" ""
    s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
    s today=$p($h,",",1)
    s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
    i birth'="" s birthdate=$zd(birth,3)
    s age=..CalAge(birth,today)
    s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
    s SocialStatusDR=+SocialStatusDR
    i SocialStatusDR=0  d
    .s SocialDESC="3自费医疗"
    e  d
    .s SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
    .i (SocialDESC'["医疗保险")&(SocialDESC'["公费医疗") d
    ..s SocialDESC="3自费医疗"
    s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
    s ProvinceDR=+ProvinceDR        
    i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
    i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
    //s GovernCardNo= $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
    s GovernCardNo=..xGetGVCardNo(PAPMIRowId)
    s gvCardNo=GovernCardNo
    ;s SecondAddress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18) 
    s SecondAddress=..xGetHomeAddress(PAPMIRowId)
    s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
    s CityBirthDR=+CityBirthDR
    i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
    i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
    s DepCodeDR=$p($g(^PAADM(paadmID)),"^",4)
    q:DepCodeDR="" ""
    s DeptDesc=$p(^CTLOC(DepCodeDR),"^",2)
    s DepCodeDR=+DepCodeDR
    i $g(DeptDesc)["-" s DeptDesc=$p(DeptDesc,"-",2)
    ;s P6=0
    ;i (arglocID'="")&(arglocID'=DepCodeDR) s P6=1
    ;q:(P6=1) $g(DeptDesc)
    s curdepdr=$P(^CTLOC(DepCodeDR),"^",19)  
    s curdepdrdesc=$p(^RBC("DEP",+curdepdr),"^",2)
    ;i (argdepartID'="")&(argdepartID'=curdepdr) s P6=2
    ;q:(P6=2) $g(curdepdrdesc)
    s admDate=$p(^PAADM(paadmID),"^",6)
    i admDate'="" s admDate=$zd(admDate,3)
    s papmiId=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
    s papersonGX=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
    s papersonGXAdress=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",5)
    s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
    s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
    s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
    i Marital'="" s MaritalDesc=$p($g(^CT("MAR",+Marital)),"^",2)        //add $g by wuqk 2009-12-29 沈阳此global无数据
    s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
    i nationdr'="" s nationDesc=$p($g(^CT("NAT",+nationdr)),"^",2) 
    i $g(nationDesc)'="" d
    .i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
    s telphone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
    s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
    i educationdr'="" s educationDesc=$p(^CT("EDU",+Marital),"^",2) 
    ;i $d(^PAPER(PAPMIRowId,"PER","ADD",1))'=0 d 
    ;.s workAdress= $g(^PAPER(PAPMIRowId,"PER","ADD",1))   ;同MEM
    s workAdress=..xGetCompany(PAPMIRowId)
    ;PAC_PatientCategory
    s PatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8) 
    s PatCategoryDR=+PatCategoryDR
    i PatCategoryDR'=0 s PatCategoryDesc=$p(^PAC("PCAT",PatCategoryDR),"^",2 )
    s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
    i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
    i $g(ProvinceDesc)=$g(CityBirthDesc) s CityBirthDesc=""
    ;s gvCardNo=$p(^PAPER(PAPMIRowId,"PER",4),"^",4) 
    s ret=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_$g(countryDesc)_$c(2)_$g(gvCardNo)_$c(2)_$g(SocialDESC)_$c(2)_PAPMIRowId_$c(2)_regno
    q ret
}

//通过病人ID获取病人信息        

ClassMethod GetPatInfos(PAPMIRowId)
{
	n (PAPMIRowId)
    s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
    s papmino=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
    s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
    s today=$p($h,",",1)
    s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
    i birth'="" s birthdate=$zd(birth,3)
    s age=..CalAge(birth,today)
    s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
    s SocialStatusDR=+SocialStatusDR
    i SocialStatusDR=0  d
    .s SocialDESC="3自费医疗"
    e  d
    .s SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
    .i (SocialDESC'["医疗保险")&(SocialDESC'["公费医疗") d
    ..s SocialDESC="3自费医疗"
    s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
    s ProvinceDR=+ProvinceDR        
    i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
    i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
    //s GovernCardNo= $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
    s GovernCardNo=..xGetGVCardNo(PAPMIRowId)
    ;s SecondAddress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18) 
    s SecondAddress=..xGetHomeAddress(PAPMIRowId)
    s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
    s CityBirthDR=+CityBirthDR
    i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
    i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
    ;s DepCodeDR=$p(^PAADM(paadmID),"^",4)
    ;i DepCodeDR'="" s DeptDesc=$p(^CTLOC(DepCodeDR),"^",2)
    ;i $g(DeptDesc)["-" s DeptDesc=$p(DeptDesc,"-",2)
    s DeptDesc=""
    s papmiId=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
    s papersonGX=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
    ;s papersonGXAdress=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",5)
    s papersonGXAdress=..xGetGXAddress(PAPMIRowId) ;Modified By liuxuefeng 2009-06-01
    s papersonGXman=..xGetGXMan(PAPMIRowId) //Modified By LiYang 2008-11-11 华西医院的联系人位置与众不同
    ;s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
    s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
    s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
    s MaritalDesc=""      ;add by wuqk 2008-07-01
    i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2) 
    s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
    i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
    i $g(nationDesc)'="" d
    .i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
    s telphone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
    s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
    s educationDesc=""
    i educationdr'="" s educationDesc=$p(^CT("EDU",+Marital),"^",2) 
    ;s workAdress=""
    ;i $d(^PAPER(PAPMIRowId,"PER","ADD",1))'=0 d 
    ;.s workAdress= $g(^PAPER(PAPMIRowId,"PER","ADD",1))   ;同MEM
    s workAdress=..xGetCompany(PAPMIRowId)
    ;PAC_PatientCategory
    s PatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8) 
    s PatCategoryDR=+PatCategoryDR
    i PatCategoryDR'=0 s PatCategoryDesc=$p(^PAC("PCAT",PatCategoryDR),"^",2 )
    s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
    s countryDesc=""
    i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
    i $g(ProvinceDesc)=$g(CityBirthDesc) s CityBirthDesc=""
    ;s P2=papmino_$c(2)_$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_$g(countryDesc)
    s P2=papmino_$c(2)_name_$c(2)_sex_$c(2)_birthdate_$c(2)_age_$c(2)_papmiId_$c(2)_ProvinceDesc_$c(2)_CityBirthDesc_$c(2)_MaritalDesc_$c(2)_nationDesc_$c(2)_telphone_$c(2)_educationDesc_$c(2)_workAdress_$c(2)_papersonGX_$c(2)_papersonGXAdress_$c(2)_papersonGXman_$c(2)_papersonGXTel_$c(2)_PatCategoryDesc_$c(2)_DeptDesc_$c(2)_SecondAddress_$c(2)_countryDesc
    q P2
}

ClassMethod CalAge(IBirth, IToday)
{
   n (IBirth,IToday)
   n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
   s IBirth=$g(IBirth),IToday=$g(IToday)
   i IBirth>2980000 s IBirth=""
   i IBirth<0 s IBirth=""
   q:'$G(IBirth) ""
   s XBirth=$ZD(IBirth)
   s XToday=$ZD(IToday)
   s AgeMth=XToday-XBirth
   s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
   s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
   s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
   s AgeYear=CurrYear-BirthYear
   i AgeDay<0 d
   . s AgeMth=AgeMth-1
   . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
   . q:XToday'=2
   . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
   i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
   s $P(AgeYr,"|",12)=AgeYear
   s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
   i $p(AgeYr,"|",12)>0  d
   .s reage=$p(AgeYr,"|",12)_"岁"
   e  d
   .i AgeMth>0 d
   ..s reage=AgeMth_"月"
   .e  d
   ..s reage=AgeDay_"天"
   q reage
}

ClassMethod GetSSUSERByCode(SSUSRInitials)
{
   n (SSUSRInitials)
   q:SSUSRInitials="" ""
   ;^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP({SSUSR_Initials}),{SSUSR_RowId})
   ;s SSUSRInitials=$ZCVT(SSUSRInitials,"U")
   s SSUSRInitials=$$ALPHAUP^SSUTIL4(SSUSRInitials)
   q:'$d(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials)) ""
   s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",SSUSRInitials,""),-1)
   q ssusr
}

//更新病人的身份证号

ClassMethod UpdatePapmiID(PAPMIRowId, papmiId)
{
      n (PAPMIRowId,papmiId)
      q:'$d(^PAPER(PAPMIRowId)) -100
      &sql(update pa_patmas set papmi_id=:papmiId where papmi_rowid=:PAPMIRowId)
      q SQLCODE
}

ClassMethod GetUserByCTCP(CTCPDR)
{
  n (CTCPDR)
  ;CT_CareProv
  q:'$d(^CTPCP(CTCPDR)) ""
  s Code=$p($g(^CTPCP((CTCPDR),1)),"^",1)
  s Desc=$p($g(^CTPCP((CTCPDR),1)),"^",2)
  s ssusr=..GetSSUSERByCode(Code)
  s s=ssusr_"/"_Code_"/"_Desc
  q s
}

//家庭住址

ClassMethod xGetHomeAddress(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    ;BJYY
    s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    ;BJDT
    s:HospCode="BeiJing_DT" ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    ;成都华西医院
    s:HospCode="ChengDu_HX" ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    ;潍坊市人民医院
    s:HospCode="WeiFang_RMYY" ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    ;沈阳医大一院
    s:HospCode="ShenYang_YDYFY" ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    ;妇产医院
    s:HospCode="BeiJing_FC" ret=$g(^PAPER(xPapmi,"PER","ADD",1))
    q ret
}

//工作单位

/// w ##Class(web.DHCWMRMedBase).xGetCompany("374")
ClassMethod xGetCompany(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$g(^PAPER(xPapmi,"PER","ADD",1))
	;BJDT
    ;s:HospCode="BeiJing_DT" ret=$p($g(^PAPER(xPapmi,"PER",3)),"^",2)
    ;成都华西医院
    s:HospCode="ChengDu_HX" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    ;潍坊市人民医院
    s:HospCode="WeiFang_RMYY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    ;沈阳医大一院
    s:HospCode="ShenYang_YDYFY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    ;妇产医院
    s:HospCode="BeiJing_FC" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    q ret
}

//住院病历号

ClassMethod xGetGVCardNo(xPapmi)
{
    n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",4)
	;BJZYY
    s:HospCode="BeiJing_ZYY" ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)
    s:HospCode="WeiFang_RMYY" ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)
    s:HospCode="ShenYang_YDYFY" ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)
    s:HospCode="NingXia_NX" ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)
    s:HospCode="BeiJing_FC" ret=$p($g(^PAPER(xPapmi,"PAT",1)),"^",22)  
    q ret
}

//通过病人的ID取得其联系人的信息 

//Create By LiYang 2008-11-11    

ClassMethod xGetGXMan(xPapmi)
{
	n (xPapmi)
    s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",13)
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1)
	;BJZYY
    s:HospCode="ChengDu_HX" ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",13)
    ;潍坊市人民医院
    s:HospCode="WeiFang_RMYY" ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",13)
    ;沈阳医大一院
    s:HospCode="ShenYang_YDYFY" ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",13)
    ;妇产医院
    s:HospCode="BeiJing_FC" ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",13)
    q ret
}

//通过病人的ID取得其联系人地址 

//Create By liuxuefeng 2009-06-01    		

ClassMethod xGetGXAddress(xPapmi)
{
	n (xPapmi)
	s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1) ;字段：PAPER_ForeignAddress
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"ALL")),"^",5)
    ;潍坊市人民医院
    s:HospCode="WeiFang_RMYY" ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1) ;字段：PAPER_ForeignAddress
    ;沈阳医大一院
    s:HospCode="ShenYang_YDYFY" ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1) ;字段：PAPER_ForeignAddress
    ;妇产医院
    s:HospCode="BeiJing_FC" ret=$p($g(^PAPER(xPapmi,"PER",1)),"^",1) ;字段：PAPER_ForeignAddress
    q ret
}

//通过病人的ID取得其联系人电话

//Create By liuxuefeng 2009-06-01  

ClassMethod xGetGXTel(xPapmi)
{
 	n (xPapmi)
	s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$p($g(^PAPER(xPapmi,"ALL")),"^",4)
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"PER",2)),"^",8)
    ;潍坊市人民医院
    s:HospCode="WeiFang_RMYY" ret=$p($g(^PAPER(xPapmi,"ALL")),"^",4) 	;字段：PAPER_ForeignPhone
    ;沈阳医大一院
    s:HospCode="ShenYang_YDYFY" ret=$p($g(^PAPER(xPapmi,"ALL")),"^",4) 	;字段：PAPER_ForeignPhone
    ;妇产医院
    s:HospCode="BeiJing_FC" ret=$p($g(^PAPER(xPapmi,"ALL")),"^",4) 	;字段：PAPER_ForeignPhone
    q ret
}

//通过病人的ID取得病人与联系人关系

//Create By liuxuefeng 2009-06-01    

ClassMethod xGetGX(xPapmi)
{
 	n (xPapmi)
	s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s GXRowId=+$p($g(^PAPER(xPapmi,"EMP")),"^",4) ;字段：PAPER_CTRLT_DR 指向表CT_Relation
    s CTRLTDesc=$p($g(^CT("RLT",GXRowId)),"^",2) ;关系描述对应字段CTRLT_Desc
    s ret=CTRLTDesc
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"ALL")),"^",4)
    ;潍坊市人民医院、沈阳医大一院
    i (HospCode="WeiFang_RMYY")||(HospCode="ShenYang_YDYFY")||(HospCode="BeiJing_FC")  d
    .s GXRowId=+$p($g(^PAPER(xPapmi,"EMP")),"^",4) ;字段：PAPER_CTRLT_DR 指向表CT_Relation
    .q:GXRowId=0
    .s CTRLTDesc=$p($g(^CT("RLT",GXRowId)),"^",2) ;关系描述对应字段CTRLT_Desc
    .s ret=CTRLTDesc 
    q ret
}

//通过病人的ID取得病人手机号(公司电话)

//Create By liuxuefeng 2009-06-01       

ClassMethod xGetMobPhone(xPapmi)
{
 	n (xPapmi)
	s ret=""
    q:xPapmi="" ret
    s HospCode=##Class(web.DHCWMRMedBase01).GetHospitalCode()
    ;默认
    s ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",21) 	;字段：PAPER_MobPhone
    ;BJYY
	s:HospCode="BeiJing_YY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",18)
    ;潍坊市人民医院
    s:HospCode="WeiFang_RMYY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",21) 	;字段：PAPER_MobPhone
    ;沈阳医大一院
    s:HospCode="ShenYang_YDYFY" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",21) 	;字段：PAPER_MobPhone
    ;妇产医院
    s:HospCode="BeiJing_FC" ret=$p($g(^PAPER(xPapmi,"PER",4)),"^",21) 	;字段：PAPER_MobPhone
    q ret
}

}

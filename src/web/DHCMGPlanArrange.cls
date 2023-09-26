Class web.DHCMGPlanArrange Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetArrange(parr As %String) As %String
{
  //取排班列表
   //s parr="1079^2009-03-2^2009-03-4"

    s loc=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    
    s ret=##class(web.DHCMGPerArrange).GetDepPerson(loc)
    s ln=$L(ret,"^")
    for i=1:1:ln
    {
	  s str=$P(ret,"^",i)
	  s per=$P(str,"|",1)
	  if per="" continue
	  s MNur(i)=per
	  s MNurSort(per)=i
	}
	f date=stdate:1:edate
    {
	   s r="" f  s r=$O(MNur(r)) q:r=""  d
	   .s MNurPost(MNur(r),date)=""
    }
    f date=stdate:1:edate
    {
	    s par="" f  s par=$O(^User.DHCMGPersonPlanArrangeI("DepDate"," "_loc,date,par)) q:par=""  d
	    .s arr=^User.DHCMGPersonPlanArrangeD(par)
	    .s Nur=$List(arr,5)
	    .w !,Nur
	    .s PostDr=$List(arr,6)
	    .s Post=$List(^User.DHCMGPostD(PostDr),3)
	    .s pflag=$List(^User.DHCMGPostD(PostDr),7)
	    .if $G(MNurPost(Nur,date))="" d
	    ..s MNurPost(Nur,date)=PostDr
	    .e  s MNurPost(Nur,date)=MNurPost(Nur,date) _"+"_PostDr
	    .s mnurdnum(Nur)=$G(mnurdnum(Nur))+1
	    .if pflag="Y" s nightdnum(Nur)=$G(nightdnum(Nur))+1
	    //	   . s sortno=..GetPerSortNo(rw)
    }
    s nur="" f  s nur=$O(MNurPost(nur)) q:nur=""  d
    .s ret=""
    .s date="" f  s date=$O(MNurPost(nur,date)) q:date=""  d
    ..
    ..s ret=ret_##class(web.DHCMGPerArrange).getstr(MNurPost(nur,date))_"^"
    .s no=MNurSort(nur)
    .s MNurArr(no,nur)=ret
    s ret=""
    s no="" f  s no=$O(MNurArr(no)) q:no=""  d
    .s nur=""  f  s nur=$O(MNurArr(no,nur)) q:nur=""  d
    ..s parr=^User.DHCMGPersonsD(nur)
    ..s nurse=$list(parr,21)
    ..s subnur=##class(web.DHCMGPerArrange).GetSubPerson(nur,stdate,loc)
    ..s subnurse=""
    ..if subnur'="" s subnurse=$list(^User.DHCMGPersonsD(subnur),21)
    ..s ret=ret_nur_"^"_nurse_$C(3)_$G(subnurse)_"^"_MNurArr(no,nur)_$G(mnurdnum(nur))_"^"_$G(nightdnum(nur))_$C(1)
 q ret
}

ClassMethod getperhol(Dep, stdate, edate, plrw) As %String
{
   //s Dep="1082",stdate="2009-3-11",edate="2009-3-25"
    s a=^User.DHCMGAuditArrangeD(plrw)
    s ADate=$List(a,2)
    s Atime=$List(a,6)
   s stdate=$ZDH(stdate,3),edate=$ZDH(edate,3)
   s d=""  f  s d=$O(^User.DHCMGPersonHolidayI("DepDate"," "_Dep,d)) q:d=""  d
    .s rw=""  f  s rw=$O(^User.DHCMGPersonHolidayI("DepDate"," "_Dep,d,rw)) q:rw=""  d
    ..s perhol=^User.DHCMGPersonHolidayD(rw)
    ..s per=$List(perhol,6)
    ..s RecDate=$List(perhol,7)
    ..if ADate>RecDate q
    ..s hl=$List(perhol,4)
    ..s a=^User.DHCMGCHolidayD(hl)
    ..s Code=$List(a,2)
    ..s Desc=$List(a,4)
    ..s hlstdate=$List(perhol,3),hledate=$List(perhol,2)
    ..if hlstdate'<stdate s sd=hlstdate
    ..if stdate'<hlstdate s sd=stdate
    ..if edate'>hledate s ed=edate
    ..if hledate'>edate s ed=hledate
    ..//w !,$zd(hlstdate,3),",",$ZD(hledate,3),",",$ZD(stdate,3),",",$ZD(edate,3)
    ..b //
    ..if hlstdate>edate q
    ..if hledate<stdate q
    ..s hol(per)=$G(hol(per))_Desc_"^"_$ZD(sd,3)_"^"_$ZD(ed,3)_$C(1)
    s ret=""
    s per="" f  s per=$O(hol(per)) q:per=""  d
    .s ret=ret_per_$C(1)_hol(per)_$C(3)
    q ret
}

ClassMethod GetMenu() As %String
{
 
   s m1="代码维护^人力资源代码|NurseManager.FrmMgCode^假期代码|NurseManager.frmholidayCode^职称代码|NurseManager.frmpostcode^职责代码|NurseManager.frmduty^岗位代码|NurseManager.frmpost^系统设置|NurseManager.FrmArrangeSystemSet^产妇维护|NurseManager.frmsucklewomen"
   s m2="统计查询^值班补贴|NurseManager.frmReportDutyParr^全部排班查询|NurseManager.frmreportposttyp"_$C(2)_"TOTAL^医生排班查询|NurseManager.frmreportposttyp"_$C(2)_"DOC^护士排班查询|NurseManager.frmreportposttyp"_$C(2)_"NUR^总排班查询|NurseManager.frmReportDepDateArr^休假统计|NurseManager.frmReportHoliday^科室排序|NurseManager.frmDepSort^排班查询(按人)|NurseManager.frmReportDepPost^封账|NurseManager.frmmgbill"
   s m3="人力资源^人员信息|NurseManager.frmpersonlist"
   s m4="排班^排班|NurseManager.FrmArrange^自动排班|NurseManager.frmarrangeSet^排班关联|NurseManager.frmrelperson^休假记录|NurseManager.frmPersonholiday^加班记录|NurseManager.frmOvRest^排班计划|NurseManager.frmAuditRecord^补贴方案|NurseManager.frmallowance"
   s m5=m1_$C(1)_m2_$C(1)_m3_$C(1)_m4
   q m5
}

Storage Default
{
<Data name="DHCMGPlanArrangeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMGPlanArrangeD</DataLocation>
<DefaultData>DHCMGPlanArrangeDefaultData</DefaultData>
<IdLocation>^web.DHCMGPlanArrangeD</IdLocation>
<IndexLocation>^web.DHCMGPlanArrangeI</IndexLocation>
<StreamLocation>^web.DHCMGPlanArrangeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

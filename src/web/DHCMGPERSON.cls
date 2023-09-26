Import SQLUSER

Class web.DHCMGPERSON Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ExportSSData() As %String
{
  //s a=##class(web.DHCMGPERSON).ExportSSData()
 // q 0
 // n
   s rw=0 f  s rw=$O(^SSU("SSUSR",rw)) q:rw=""  d
   .s name=$P(^SSU("SSUSR",rw),"^",2)
   .s workno=$P(^SSU("SSUSR",rw),"^",1)
   .s dep=$P(^SSU("SSUSR",rw),"^",4)
   .s ctcptdr=$P(^SSU("SSUSR",rw),"^",14)
   .s loc=""
   .if ctcptdr'="" s loc=$O(^RB("RES",0,"CTPCP",ctcptdr,loc))
   .q:$D(^User.DHCMGPersonsI("SSDR"," "_rw))
   .if loc'="" s dep=loc
   .s parr=rw_"^"_name_"^^"_workno_"^^^^^^^^^^^^^"_dep_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
   .s a=##class(User.DHCMGPersons).Insert1(parr)
   .q:a'=0
}

ClassMethod Importschool() As %String
{
	//s a=##class(web.DHCMGPERSON).Importschool()
	s rwid=0 f  s rwid=$o(^tempfxschool(rwid)) q:rwid=""  d
    .s schcode=$p($g(^tempfxschool(rwid)),"^",1)
    .s schdesc=$p($g(^tempfxschool(rwid)),"^",2)
    .s parr=""_"^"_"2"_"^"_schcode_"^"_schdesc_"^"_"2010-11-29"_"^"_""
    .s a=##class(User.DHCMGCCode).Save(parr)
    q 0
}

ClassMethod ImportSSData() As %String
{
  //s a=##class(web.DHCMGPERSON).ImportSSData()
 // q 0
 ; ----1-------2-----3------4-----5------6-------7------8----
 ;   科室rowid 姓名 工资号  工号  性别   民族  婚姻    护士种类
   ;PLIST 3      4               17         11      31   || 31      10
   ;    --9--------10--------11---------12------------13---
   ;    身份证  手机电话   政治面目  来院工作时间   注册号
   ;-----14---15------------16-------17 ----------18----------------19 -----20------21-------
   ; 现在地址  现住址邮编   户籍地址  户籍邮编    参加护理工作时间   身高   鞋号    白衣号
   s rw=0 f  s rw=$O(^zTSA5566q(rw)) q:rw=""  d
   .q:$D(^User.DHCMGPersonsI("SSDR"," "_rw))
   .s name=$p(^zTSA5566q(rw),"^",2)
   .i name="李玲飞" b //4
   .s regno=$p(^zTSA5566q(rw),"^",13)
   .s id=$p(^zTSA5566q(rw),"^",4)
   .;s id=""
   .s sex=$p(^zTSA5566q(rw),"^",5)
   .s identity=$p(^zTSA5566q(rw),"^",9) 
   .i identity'="" d
   ..i $l(identity)=15 d
   ...s birth=19_$e(identity,7,8)_"-"_$e(identity,9,10)_"-"_$e(identity,11,12)
   ..e  d
   ...s birth=$e(identity,7,10)_"-"_$e(identity,11,12)_"-"_$e(identity,13,14)
   .e  s birth=""
   .s marr=$p(^zTSA5566q(rw),"^",7)
   .s professpost=""
   .s TeachPost=""
   .s Mentor=""
   .s WorkDateTime=$p(^zTSA5566q(rw),"^",12)
   .s Typ=""
   .s TelHome=""
   .s TelHand=$p(^zTSA5566q(rw),"^",10)
   .s Address=$p(^zTSA5566q(rw),"^",14)
   .s NativePl=""
   .s Dep=$p(^zTSA5566q(rw),"^",1)
   .s flag=""
   .s RowID=""
   .s datefrom=""
   .s dateend=""
   .s appduty=""
   .s headship=""
   .s peple=$p(^zTSA5566q(rw),"^",6)
   .s politic=$p(^zTSA5566q(rw),"^",11)
   .s schage=""
   .s degree=""
   .s graduate=""
   .s shcool=""
   .s language=""
   .s rydate=""
   .s entdep=""
   .s nurtyp=$p(^zTSA5566q(rw),"^",8)
   .s nurqualdate=""
   .s nurpref=""
   .s prefqualdate=""
   .s dutydate=""
   .s engdate=""
   .s hosendmth=""
   .s hosengdate=""
   .s posttyp=""
   .s retiredate=""
   .s pertyp=""
   .s wageno=$p(^zTSA5566q(rw),"^",3)
   .;s wageno=""
   .s profession=""
   .s secedu=""
   .s leaveunit=""
   .s teachHolidayFlag="" 
   .s PersonPresentZipCode=$p(^zTSA5566q(rw),"^",15)
   .s PersonHouseholdAdd=$p(^zTSA5566q(rw),"^",16)
   .s PersonHouseZipCode=$p(^zTSA5566q(rw),"^",17)
   .s PersonCareDate=$p(^zTSA5566q(rw),"^",18)
   .s PersonHeight=$p(^zTSA5566q(rw),"^",19)
   .s PersonShoeNO=$p(^zTSA5566q(rw),"^",20)
   .s PersonClothesNO=$p(^zTSA5566q(rw),"^",21)
   .s tmprw=rw
   .;s tmprw=""
   .;i name="李玲飞" b //99
  .s parr=tmprw_"^"_name_"^"_regno_"^"_id_"^"_sex_"^"_birth_"^"_marr_"^"_professpost_"^"_TeachPost_"^"_Mentor_"^"_WorkDateTime_"^"_Typ_"^"_TelHome_"^"_TelHand_"^"_Address_"^"_NativePl_"^"_Dep_"^"_flag_"^"_RowID_"^"_datefrom_"^"_dateend_"^"_identity_"^"_headship_"^"_appduty_"^"_peple_"^"_politic_"^"_schage_"^"_degree_"^"_graduate_"^"_shcool_"^"_language_"^"_rydate_"^"_entdep_"^"_nurtyp_"^"_nurqualdate_"^"_nurpref_"^"_prefqualdate_"^"_engdate_"^"_dutydate_"^"_hosendmth_"^"_hosengdate_"^"_posttyp_"^"_retiredate_"^"_pertyp_"^"_wageno_"^"_profession_"^"_secedu_"^"_leaveunit_"^"_teachHolidayFlag
  .s parr=parr_"^"_PersonPresentZipCode_"^"_PersonHouseholdAdd_"^"_PersonHouseZipCode_"^"_PersonCareDate_"^"_PersonHeight_"^"_PersonShoeNO_"^"_PersonClothesNO
  .s a=##class(User.DHCMGPersons).Insert1(parr)
  .q:a'=0
  q 0
}

ClassMethod Importxhnurschool() As %String
{
	//s a=##class(web.DHCMGPERSON).Importxhnurschool()
	s rwid=0 f  s rwid=$o(^tempnurschool(rwid)) q:rwid=""  d
	.s rw=""
	.s rw=$o(^User.DHCMGPersonsI("SSDR"," "_rwid,rw))
	.i rw=""  s ^tmoe23nurscherror(rwid)=""
	.i rw'="" d
	..s id=""
    ..s SchoolGraduateDate=""
    ..s SchoolGraduateSchool=$p($g(^tempnurschool(rwid)),"^",3)
    ..s SchoolAgeDr=$p($g(^tempnurschool(rwid)),"^",2)
    ..s SchoolDegreeDR=""
    ..s SchoolProfession=""
    ..s SchoolLanguage=""
    ..s SchoolCurrent=$p($g(^tempnurschool(rwid)),"^",4)
    ..s SchoolReading=""
    ..s Schoolmem=""
    ..i SchoolGraduateSchool'="" d
    ...s parr=id_"^"_rw_"^"_SchoolGraduateDate_"^"_SchoolGraduateSchool_"^"_SchoolAgeDr_"^"_SchoolDegreeDR_"^"_SchoolProfession_"^"_SchoolLanguage_"^"_SchoolCurrent_"^"_SchoolReading_"^"_Schoolmem
    ...s a=##class(User.DHCMGPersonSchool).saveSchool(parr)
    ...//b  //5
    ..s id=""
    ..s SchoolGraduateDate=""
    ..s SchoolGraduateSchool=$p($g(^tempnurschool(rwid)),"^",6)
    ..s SchoolAgeDr=$p($g(^tempnurschool(rwid)),"^",5)
    ..s SchoolDegreeDR=""
    ..s SchoolProfession=""
    ..s SchoolLanguage=""
    ..s SchoolCurrent=$p($g(^tempnurschool(rwid)),"^",7)
    ..s SchoolReading=""
    ..s Schoolmem=""
    ..i SchoolGraduateSchool'="" d
    ...s parr=id_"^"_rw_"^"_SchoolGraduateDate_"^"_SchoolGraduateSchool_"^"_SchoolAgeDr_"^"_SchoolDegreeDR_"^"_SchoolProfession_"^"_SchoolLanguage_"^"_SchoolCurrent_"^"_SchoolReading_"^"_Schoolmem
    ...s a=##class(User.DHCMGPersonSchool).saveSchool(parr)
    ...//b //6
    q 0
}

ClassMethod ImportxhnurschoolByper() As %String
{
	//s a=##class(web.DHCMGPERSON).ImportxhnurschoolByper()
	
	s rw=7050 f  s rw=$o(^tempXHnurschool(rw)) q:rw=""  d
	.s id=""
    .s SchoolGraduateDate=""
    .s SchoolGraduateSchool=$p($g(^tempXHnurschool(rw)),"^",1)
    .s SchoolAgeDr=$p($g(^tempXHnurschool(rw)),"^",2)
    .s SchoolDegreeDR=""
    .s SchoolProfession=""
    .s SchoolLanguage=""
    .s SchoolGraduateDate=$p($g(^tempXHnurschool(rw)),"^",3)
    .s SchoolCurrent=$p($g(^tempXHnurschool(rw)),"^",4)
    .s SchoolReading=""
    .s Schoolmem=""
    .i SchoolGraduateSchool'="" d
    ..s parr=id_"^"_rw_"^"_SchoolGraduateDate_"^"_SchoolGraduateSchool_"^"_SchoolAgeDr_"^"_SchoolDegreeDR_"^"_SchoolProfession_"^"_SchoolLanguage_"^"_SchoolCurrent_"^"_SchoolReading_"^"_Schoolmem
    ..s a=##class(User.DHCMGPersonSchool).saveSchool(parr)
	.//
	.s id=""
    .s SchoolGraduateDate=""
    .s SchoolGraduateSchool=$p($g(^tempXHnurschool(rw)),"^",5)
    .s SchoolAgeDr=$p($g(^tempXHnurschool(rw)),"^",6)
    .s SchoolDegreeDR=""
    .s SchoolProfession=""
    .s SchoolLanguage=""
    .s SchoolGraduateDate=$p($g(^tempXHnurschool(rw)),"^",7)
    .s SchoolCurrent=$p($g(^tempXHnurschool(rw)),"^",8)
    .s SchoolReading=""
    .s Schoolmem=""
    .i SchoolGraduateSchool'="" d
    ..s parr=id_"^"_rw_"^"_SchoolGraduateDate_"^"_SchoolGraduateSchool_"^"_SchoolAgeDr_"^"_SchoolDegreeDR_"^"_SchoolProfession_"^"_SchoolLanguage_"^"_SchoolCurrent_"^"_SchoolReading_"^"_Schoolmem
    ..s a=##class(User.DHCMGPersonSchool).saveSchool(parr)
    .;b
    q 0
}

ClassMethod GetPersonsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="^^^^^^^^^^^^^^^^^"_$C(1)_"^^^^^^^^^^^^^^^^^^^^^"
 	s par1=$P(parr,$C(1),1)
 	s par2=$P(parr,$C(1),2)
 	///s ^TMP("ff")=parr
 	//s regno + "^" + idno + "^" + sex + "^" + marr + "^" + professpost + "^" + teachPost + "^" + Mentor + "^" + dep + "^" + name + "^" + Typ + "^" + flag;
    s pregno=$P(par1,"^",1)
    s pidno=$P(par1,"^",2)
    s psex=$P(par1,"^",3)
    s pmarr=$P(par1,"^",4)
    s pduty=$P(par1,"^",5)
    s pteach=$P(par1,"^",6)
    s pmentor=$P(par1,"^",7)
    s pdep=$P(par1,"^",8)
    s pname=$P(par1,"^",9)
    s ptyp=$P(par1,"^",10)
    s pflag=$P(par1,"^",11)
    
    s politic = $P(par2,"^",1)
    s schage =$P(par2,"^",2)
    s degree =$P(par2,"^",3)
    s language =$P(par2,"^",4)
    s nurtyp =$P(par2,"^",5)
    s nurpref = $P(par2,"^",6)
    s posttyp =$P(par2,"^",7)
    s pertyp=$P(par2,"^",8)
    s birth1=$P(par2,"^",9)
    s birth2=$P(par2,"^",10)
    i birth1'="" s birth1=$zdh(birth1,3)
    i birth2'="" s birth2=$zdh(birth2,3)
    s workYear1=$P(par2,"^",11)
    s workYear2=$P(par2,"^",12)
    i (workYear1'="")&(workYear2="") s workYear2=workYear1
    i (workYear2'="")&(workYear1="") s workYear1=workYear2
    s appduty=$P(par2,"^",13)
    s retireflag=$P(par2,"^",14)
    s dateendflag=$P(par2,"^",15)
    s parrhead=$P(par2,"^",16)
    s retireYear=$P(par2,"^",17)
    s ^tmoe1234qw(1)=retireYear
    s perflag=""
    if pertyp'=""
    { 
      s a=^User.DHCMGCCodeD(pertyp)
	  s perflag=$list(a,2)
    }

    if pflag="N" s pflag=""
    if (pdep'="" )
   {
    s rw="" f  s rw=$O(^User.DHCMGPersonsI("Dep"," "_pdep,rw)) q:rw=""  d
    .d out
   }else
   {
	s rw="" f  s rw=$O(^User.DHCMGPersonsD(rw))  q:rw=""  d
	.d out
   }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (name,ssid,regno,idno,birth,sexDes,marrDes,DepDes,prpostdes,TeachDes,MentorDes,Typdes,Address,TelHome,TelHand,flag,ClothesNO,ShoeNO)=""
    s parr=^User.DHCMGPersonsD(rw)
    s name=$list(parr, 21)
    if (name'[pname)&(pname'="") q
    s ssid=$list(parr, 32)
    s regno=$list(parr, 30)
    q:(regno'[pregno)&(pregno'="" )
    s idno=$list(parr, 16)
    q:(idno'[pidno)&(pidno'="" )
    s fn=2
    //if perflag'="" s fn=$F(idno,perflag)
    //if (fn=0)&(perflag'="") q
    s curpertyp=$list(parr, 45)
    ;s ^tmpw23q(12)=pertyp_"^"_curpertyp
    q:(pertyp'="")&(pertyp'=curpertyp)
    s sex=$list(parr, 34)
    q:(sex'=psex)&(psex'="" )
    s birth=$list(parr, 5)
    ;i idno="121-056" s ^tmoeas23(35)=birth_"^"_birth1_"^"_birth2
    q:(birth1'="")&(birth2'="")&(birth'="")&((birth<birth1)!(birth>birth2))
    s marr=$list(parr, 42)
    q:(marr'=pmarr)&(pmarr'="" )
    s professpost=$list(parr, 29)
    q:(professpost'=pduty)&(pduty'="" )
    s appdutypost=$list(parr, 4)
    q:(appdutypost'=appduty)&(appduty'="" )
    s appdutydes=""
    if appdutypost'="" s appdutydes=$list(^User.DHCMGCPostCodeD(appdutypost),3)
    s TeachPost=$list(parr, 35)
    q:(TeachPost'=pteach)&(pteach'="" )
    s Mentor=$list(parr, 20)
    q:(Mentor'=pmentor)&(pmentor'="" )
    s WorkDateTime=$list(parr, 40)
    
    i WorkDateTime="" s WorkDateTime=21550   ;"1900-1-1"
    s workYear=##class(web.DHCMGPERSON).CalAge(WorkDateTime,+$h)
    ;i idno="128-003" s ^tmoeas23(34)=workYear_"@"_WorkDateTime_"^"_workYear1_"^"_workYear2
    q:(workYear1'="")&(workYear2'="")&((workYear<workYear1)!(workYear>workYear2))
    s Typ=$list(parr, 39)
    q:(Typ'=ptyp)&(ptyp'="" )
   s dpolitic =$list(parr, 25)
   q:(dpolitic'=politic)&(politic'="" )
   s dschage=$list(parr, 33)
   q:(dschage'=schage)&(schage'="" )
   s schageDesc=""
    i dschage'="" s schageDesc=$listget($g(^User.DHCMGCCodeD(dschage)),3)
   s ddegree =$list(parr, 6)
   q:(ddegree'=degree)&(degree'="" )
   s dlanguage=$list(parr, 19)
   q:(dlanguage'=language)&(language'="" )
   s dnurtyp=$list(parr, 23)
   q:(dnurtyp'=nurtyp)&(nurtyp'="" )
   i dnurtyp'="" s nurtypDesc=$listget($g(^User.DHCMGCCodeD(dnurtyp)),3)
   e  s nurtypDesc=""
   s dnurpref =$list(parr, 27)
   q:(dnurpref'=nurpref)&(nurpref'="" )
   s dposttyp=$list(parr, 26) 
   q:(dposttyp'=posttyp)&(posttyp'="" )
    s TelHome=$list(parr, 38)
    s TelHand=$list(parr, 37)
    s Address=$list(parr, 2)
    s NativePl=$list(parr, 22)
    s Dep=$list(parr, 7)
    s flag=$list(parr, 17)
    q:(flag'=pflag)&(pflag'="")
    q:Dep=""
    q:'$D(^CTLOC(Dep))
    if birth'="" s birth=$zd(birth,3)
    if sex'="" s sexDes=$P($g(^CT("SEX",sex)),"^",2)
    if marr'="" s marrDes=$P($g(^CT("MAR",marr)),"^",2)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    if professpost'="" s prpostdes=$list(^User.DHCMGCPostCodeD(professpost),3)
    if TeachPost'="" s TeachDes=$list(^User.DHCMGCPostCodeD(TeachPost),3)
    if Mentor'="" s MentorDes=$list(^User.DHCMGCPostCodeD(Mentor),3)
    if NativePl'="" s Native=""
    if Typ="D" s Typdes="Doctor"
    if Typ="N" s Typdes="Nurse"
    if Typ="W" s Typdes="Worker"
    s retiredate=$list(parr, 31)
    s retiredate2=retiredate
    if retiredate'="" s retiredate=$ZD(retiredate,3)
    s retiredate3=""
    i retiredate["-" s retiredate3=$p(retiredate,"-",1)
    q:(retireflag="Y")&(retiredate="")
    i rw="5566" s ^tmoe1234qw(rw)=retireYear_"^"_retireflag_"^"_retiredate_"^"_retiredate3
    i rw="5751" s ^tmoe1234qw(rw)=retireYear_"^"_retireflag_"^"_retiredate_"^"_retiredate3
    q:(retireflag="Y")&(retiredate'="")&(retireYear'="")&(retireYear'=retiredate3)
    i rw="5751" s ^tmoe1234qw(rw,2)=retireYear_"^"_retireflag_"^"_retiredate_"^"_retiredate3
    q:(retireflag="N")&(retiredate2'="")&(retiredate2'>+$h)
    s dateend=$list(parr, 8)
    if dateend'="" s dateend=$ZD(dateend,3)
    q:(dateendflag="Y")&(dateend="")
    ;q:(dateendflag="N")&(dateend'="")
    q:(dateendflag'="Y")&(dateend'="")
    s head=$list(parr, 41)
    q:(head'=parrhead)&(parrhead'="")
    s headdes=""
    if head'="" s headdes=$list(^User.DHCMGCPostCodeD(head),3)
    s posttypdes=""
    i dposttyp'="" s posttypdes=$listget($g(^User.DHCMGCCodeD(dposttyp)),3)
    s WorkDate=""
    i (WorkDateTime'="")&(WorkDateTime'=21550) s WorkDate=$zd(WorkDateTime,3)
    s ClothesNO=$listGet(parr,58)
    i ClothesNO'="" s ClothesNO=$list(^User.DHCMGCCodeD(ClothesNO),3)
    s ShoeNO=$listGet(parr,57)
    i ShoeNO'="" s ShoeNO=$list(^User.DHCMGCCodeD(ShoeNO),3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(rw,name,ssid,regno,idno,birth,$G(sexDes),$G(marrDes),$G(DepDes),$G(prpostdes),$G(TeachDes),$G(MentorDes),$G(Typdes),$G(Address),TelHome,TelHand,$G(flag),retiredate,dateend,appdutydes,schageDesc,headdes,posttypdes,WorkDate,nurtypDesc,ClothesNO,ShoeNO)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 根据工作时间计算年限
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
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
	s $p(AgeYr,"|",12)=AgeYear
	;s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	s reage=$p(AgeYr,"|",12)
	q reage
}

ClassMethod GetPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPersonsExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPersonsExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPersons(parr As %String) As %Query(ROWSPEC = "rw,name,ssid,regno,idno,birth,sexDes,marrDes,DepDes,prpostdes,TeachDes,MentorDes,Typdes,Address,TelHome,TelHand,flag,retiredate,dateend,appdutydes,schageDesc,headdes,posttypdes,WorkDate,nurtypDesc,ClothesNO,ShoeNO")
{
}

ClassMethod GetPersonInfo(parm As %String) As %String
{
   // n (parm)
    //s parm="^^^^^^^1090^^^"
    s parr=^User.DHCMGPersonsD(parm)
    s name=$list(parr, 21)
    s ssid=$list(parr, 32)
    s regno=$list(parr, 30)
    s idno=$list(parr, 16)
    s sex=$list(parr, 34)
    s birth=$list(parr, 5)
    s marr=$list(parr, 42)
    s professpost=$list(parr, 29)
    s TeachPost=$list(parr, 35)
    s Mentor=$list(parr, 20)
    s WorkDateTime=$list(parr, 40)
    s Typ=$list(parr, 39)
    s TelHome=$list(parr, 38)
    s TelHand=$list(parr, 37)
    s Address=$list(parr, 2)
    s NativePl=$list(parr, 22)
    s Dep=$list(parr, 7)
    s flag=$list(parr, 17)
    s datefrom=$list(parr, 12)
    s dateend=$list(parr, 8)
    s idcardno=$list(parr, 18)
    s appduty=$list(parr, 4)
    s head=$list(parr, 41)
    
    s perCat=$listGet(parr, 45)
    
   s peple=$list(parr, 43)
   s politic =$list(parr, 25)
   s schage=$list(parr, 33)
   s degree =$list(parr, 6)
   s graduate=$list(parr, 13)
   if graduate'="" s graduate=$ZD(graduate,3)
   s shcool =$list(parr, 14)
   s language=$list(parr, 19)
   s rydate=$list(parr, 3)
   if rydate'="" s rydate=$ZD(rydate,3)
   s entdep=$list(parr, 11)
   if entdep'=""  s entdep=$ZD(entdep,3)
   s nurtyp=$list(parr, 23)
   s nurqualdate =$list(parr, 24)
   if nurqualdate'=""  s nurqualdate=$ZD(nurqualdate,3)
   s nurpref =$list(parr, 27)
   s prefqualdate=$list(parr, 28) 
   if prefqualdate'=""  s prefqualdate=$ZD(prefqualdate,3)
   s dutydate=$list(parr,36)
   if dutydate'=""  s dutydate=$ZD(dutydate,3)
   s engdate=$list(parr, 9)
   if engdate'="" s engdate=$ZD(engdate,3)
   s hosendmth=$list(parr, 10)
   s hosengdate =$list(parr, 15)
   if hosengdate'="" s hosengdate=$ZD(hosengdate,3)
   s posttyp=$list(parr, 26) 
   s retiredate=$list(parr, 31)
   if retiredate'="" s retiredate=$ZD(retiredate,3)
   s profession=$listGet(parr,46)
   s secedu=$listGet(parr,47) 
   s wageno=$listGet(parr,48)
   s leaveunit=$listGet(parr,49)
   s PersonAppdutyDate=$listGet(parr,50)
   i PersonAppdutyDate'="" s PersonAppdutyDate=$zd(PersonAppdutyDate,3)
   s teachHolidayFlag=$listGet(parr,51)
    if sex'="" s sexDes=$P(^CT("SEX",sex),"^",2)
    if marr'="" s marrDes=$P(^CT("MAR",marr),"^",2)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    if professpost'="" s prpostdes=$list(^User.DHCMGCPostCodeD(professpost),3)
    if TeachPost'="" s TeachDes=$list(^User.DHCMGCPostCodeD(TeachPost),3)
    if Mentor'="" s MentorDes=$list(^User.DHCMGCPostCodeD(Mentor),3)
    if head'="" s headdes=$list(^User.DHCMGCPostCodeD(head),3)
    if appduty'="" s appdutydes=$list(^User.DHCMGCPostCodeD(appduty),3)
    if NativePl'="" s Native=""
    if Typ="D" s Typdes="Doctor"
    if Typ="N" s Typdes="Nurse"
    if Typ="W" s Typdes="Worker"
    if WorkDateTime'="" s WorkDateTime=$zd(WorkDateTime,3)
    IF birth'="" s birth=$ZD(birth,3)
    IF datefrom'="" s datefrom=$ZD(datefrom,3)
    IF dateend'="" s dateend=$ZD(dateend,3)
    ;*****************
    s PresentZipCode=$listGet(parr,52)
    s HouseholdAdd=$listGet(parr,53)
    s HouseZipCode=$listGet(parr,54)
    s CareDate=$listGet(parr,55)
    i CareDate'="" s CareDate=$zd(CareDate,3)
    s PersonHeight=$listGet(parr,56)
    s ClothesNO=$listGet(parr,58)
    s PersonNurHeadDate=$listGet(parr,59)
    i PersonNurHeadDate'="" s PersonNurHeadDate=$zd(PersonNurHeadDate,3)
    ;s ClothesNOdes=""
    ;i ClothesNO'="" s ClothesNOdes=$list(^User.DHCMGCCodeD(ClothesNO),3)
    s ShoeNO=$listGet(parr,57)
    s SchoolType=$listGet(parr,60)
    s SchoolMedWest=$listGet(parr,61)
    s PersonBattery=$listGet(parr,62)
    
    ;s ShoeNOdes=""
    ;i ShoeNO'="" s ShoeNOdes=$list(^User.DHCMGCCodeD(ShoeNO),3)
    ;*****************
    ;*************************
    ;s parr=peple _ "^"_ politic _ "^"_ schage _ "^"_ degree _ "^"_ graduate _ "^"_ shcool _ "^"_ language _ "^"_ rydate _ "^"_ entdep _ "^"_ nurtyp _ "^"_ nurqualdate _ "^"_ nurpref _ "^"_ prefqualdate _ "^"_ dutydate _ "^"_ engdate _ "^"_ hosendmth _ "^"_ hosengdate _ "^"_ posttyp _ "^"_ retiredate_"^"_perCat_"^"_$g(profession)_"^"_$g(secedu)_"^"_$g(wageno)_"^"_$g(leaveunit)_"^"_PersonAppdutyDate_"^"_teachHolidayFlag                                                                                                                                                                                                                         //16        17          18          19               20           21         
    ;*************************
    s parr=peple _ "^"_ politic _ "^"_ schage _ "^"_ degree _ "^"_ graduate _ "^"_ shcool _ "^"_ language _ "^"_ rydate _ "^"_ entdep _ "^"_ nurtyp _ "^"_ nurqualdate _ "^"_ nurpref _ "^"_ prefqualdate _ "^"_ dutydate _ "^"_ engdate _ "^"_ hosendmth _ "^"_ hosengdate _ "^"_ posttyp _ "^"_ retiredate_"^"_perCat_"^"_$g(profession)_"^"_$g(secedu)_"^"_$g(wageno)_"^"_$g(leaveunit)_"^"_PersonAppdutyDate_"^"_teachHolidayFlag_"^"_PresentZipCode_"^"_HouseholdAdd_"^"_HouseZipCode_"^"_CareDate_"^"_PersonHeight_"^"_ClothesNO_"^"_ShoeNO_"^"_PersonNurHeadDate_"^"_SchoolType_"^"_SchoolMedWest_"^"_PersonBattery                                                                            
    
    s ret=parm_"^"_name_"^"_ssid_"^"_regno_"^"_idno_"^"_birth_"^"_$G(sexDes)_"^"_$G(marrDes)_"^"_$G(DepDes)_"^"_$G(prpostdes)_"^"_$G(TeachDes)_"^"_$G(MentorDes)_"^"_$G(Typdes)_"^"_$G(Address)_"^"_TelHome_"^"_TelHand_"^"_$G(flag)_"^"_datefrom_"^"_dateend_"^"_$G(appdutydes)_"^"_$G(headdes)_"^"_idcardno_"^"_WorkDateTime

    q ret_$C(1)_parr
}

ClassMethod GetPostTyp(typ As %String) As %String
{
	//n (typ)
		s ret=""
		s rw="" f  s rw=$O(^User.DHCMGCPostCodeI("Typ"," "_typ,rw)) q:rw=""  d
        . s a=^User.DHCMGCPostCodeD(rw)
        . s Code=$List(a,2)
        . s Desc=$List(a,3)
        . s ret=ret_rw_"|"_Desc_"^"
        q ret
}

ClassMethod GetSortDep(typ) As %String
{
 //获取排序科室
   // n (typ)
   //k ^TMP(typ)
    if typ="D" s typ="DOC"
    if typ="N" s typ="NUR"
    if typ="A" s typ="TOTAL"
    s rw=""  f  s rw=$O(^User.DHCMGArrangPerSortI("Typ"," "_typ,rw)) q:rw=""  d
    .s dep=$List(^User.DHCMGArrangPerSortD(rw),4)
    .s sort=$List(^User.DHCMGArrangPerSortD(rw),5)
    .s m(sort)=dep
    s ret=""
    s rw="" f  s rw=$O(m(rw)) q:rw=""  d
    .;s dep=m(rw), des=$P(^CTLOC($TR(dep," ")),"^",2)
    .s dep=m(rw)
    .q:$g(^CTLOC($TR(dep," ")))=""
    .s des=$P(^CTLOC($TR(dep," ")),"^",2)
    .s ret=ret_$TR(dep," ")_"|"_des_"^"
  // s ^TMP(typ)=ret
    q ret
}

//d ##class(Nur.DHCNURLocData).getloc("DH444444")

ClassMethod getlocBig(UserId) As %String
{
	s ret=""
	q:UserId=""
	s rw="" s rw=$o(^Nur.DHCNURLocDataI("UserId"," "_UserId,rw))
	i rw'="" d
	.s chl="" f  s chl=$o(^Nur.DHCNURLocDataSubD(rw,chl)) q:chl=""  d
	..s rowid=rw_"||"_chl
	..s obj=##class(Nur.DHCNURLocDataSub).%OpenId(rowid)
	..s loc=obj.Loc
	..q:loc=""
	..s locdesc=$P($g(^CTLOC(loc)),"^",2)
	..s ret=ret_loc_"|"_locdesc_"^"
    b ;02

	q ret
}

ClassMethod GetLoc() As %String
{
 //s a=##class(web.DHCMGPERSON).GetLoc
    s ret2=""
    s typ="" f  s typ=$O(^CTLOC(0,"LocType",typ)) q:typ=""  d
    .;q:(typ="D")!(typ="O")!(typ="OR")
    .q:(typ="D")!(typ="OR")
    .s rw=""  f  s rw=$O(^CTLOC(0,"LocType",typ,rw)) q:rw=""  d
    ..s des=$P(^CTLOC(rw),"^",2)
    ..q:des["停用"
    ..q:(des["检验科")&(des'["病房")
    ..q:des["组"
    ..q:(typ="O")&(des'["治疗室")&(des'["门诊服务台")&(des'["临床药理")&(des'["门诊部门诊咨询") 
    ..s ret2=ret2_rw_"|"_des_"^"
   q ret2
}

ClassMethod GetCtloc() As %String
{
    s ret2=""
    s typ="" f  s typ=$O(^CTLOC(0,"LocType",typ)) q:typ=""  d
    .s rw=""  f  s rw=$O(^CTLOC(0,"LocType",typ,rw)) q:rw=""  d
    ..s des=$P(^CTLOC(rw),"^",2)
    ..s ret2=ret2_rw_"|"_des_"^"
  q ret2
}

ClassMethod Getcodedata(grptyp = "A") As %String
{
 //s a=##class(web.DHCMGPERSON).Getcodedata()
 //	n
 //  s ^TT=grptyp
    s ret=""
    s rw=""  f  s rw=$O(^CT("SEX",rw)) q:rw=""  d
    .s des=$P(^CT("SEX",rw),"^",2)
    .s ret=ret_rw_"|"_des_"^"
    ;b
    s ret1=""
    s rw=""  f  s rw=$O(^CT("MAR",rw)) q:rw=""  d
    .s des=$P(^CT("MAR",rw),"^",2)
    .s ret1=ret1_rw_"|"_des_"^"
    s ret2=""
    s typ="" f  s typ=$O(^CTLOC(0,"LocType",typ)) q:typ=""  d
    .s rw=""  f  s rw=$O(^CTLOC(0,"LocType",typ,rw)) q:rw=""  d
    ..s des=$P(^CTLOC(rw),"^",2)
    ..s loctype=$P(^CTLOC(rw),"^",13)
    ..q:(loctype="D")!(loctype="O")!(loctype="C")
    ..q:des["停用"
    ..q:(des["检验科")&(des'["病房")
    ..q:des["组"
    ..s ret2=ret2_rw_"|"_des_"^"
    if grptyp="D" s grptyp="DOC"
    if grptyp="N" s grptyp="NUR"
    if grptyp="A" s grptyp="TOTAL"
    s ret2=..GetSortDep(grptyp)
    s ret3=..GetPostTyp("P")  //职称
    s ret4=..GetPostTyp("T") //教学
    s ret5=..GetPostTyp("M") //导师
    s ret6=..GetPostTyp("D") //职务
    s a=""
    ;b
    s $P(a,"!",1)=ret
    s $P(a,"!",2)=ret1
    s $P(a,"!",3)=ret2
    s $P(a,"!",4)=ret3
    s $P(a,"!",5)=ret4
    s $P(a,"!",6)=ret5
    s $P(a,"!",7)=ret6
    q a
}

ClassMethod GetCatPerson() As %String
{
	//s a=##class(web.DHCMGPERSON).GetCatPerson()
	s catstr="40!"
    s ln=$l(catstr,"!")
    s ret=""
    for i=1:1:ln
    {   
        s cat=$P(catstr,"!",i)
        if cat="" continue
        b
	    s rw="" f  s rw=$O(^User.DHCMGPersonsI("Catg"," "_cat,rw)) q:rw=""  d
	    .s a=^User.DHCMGPersonsD(rw)
	    .b
	    .s name=$list(a, 21)
	    .s ret=ret_rw_"|"_name_"^"
    }
    q ret
}

ClassMethod GetCatPerson1() As %String
{
	//s a=##class(web.DHCMGPERSON).GetCatPerson()
	//n
	s catstr="40!"
    s ln=$l(catstr,"!")
    s head="Id|轮转人员"
    s colw="0|200|"
    s ret=""
    for i=1:1:ln
    {   
        s cat=$P(catstr,"!",i)
        if cat="" continue

	    s rw="" f  s rw=$O(^User.DHCMGPersonsI("Catg"," "_cat,rw)) q:rw=""  d
	    .s a=^User.DHCMGPersonsD(rw)
	    .b
	    .s name=$list(a, 21)
	    .s ret=ret_rw_"^"_name_$C(1)
    }
    q head_$C(2)_colw_$C(2)_ret
}

ClassMethod GetSortDep1(typ) As %String
{
 //获取排序科室
    //n (typ)
    s head="Id|科室"
    s colw="0|200|"
    s rw=""  f  s rw=$O(^User.DHCMGArrangPerSortI("Typ"," "_typ,rw)) q:rw=""  d
    .s dep=$List(^User.DHCMGArrangPerSortD(rw),4)
    .s sort=$List(^User.DHCMGArrangPerSortD(rw),5)
    .s m(sort)=dep
    s ret=""
    s rw="" f  s rw=$O(m(rw)) q:rw=""  d
    .;s dep=m(rw), des=$P(^CTLOC($TR(dep," ")),"^",2)
    .s dep=m(rw)
    .q:$g(^CTLOC($TR(dep," ")))=""
    .s des=$P(^CTLOC($TR(dep," ")),"^",2)
    .s ret=ret_$TR(dep," ")_"^"_des_$C(1)
  // s ^TMP(typ)=ret
    q head_$C(2)_colw_$C(2)_ret
}

ClassMethod getdepperson(pdep) As %String
{
 //轮转人员
  //s a=##class(web.DHCMGPERSON).getdepperson()
	s typ="^40^"
	s ret=""
    s rw="" f  s rw=$O(^User.DHCMGPersonsI("Dep"," "_pdep,rw)) q:rw=""  d
    .s parr=^User.DHCMGPersonsD(rw)
    .s name=$list(parr, 21)
    .s cat=$listGet(parr, 45)
    .;s dateend=$listGet(parr, 8)    //*
    .;i rw=7277 b //55
    .;i dateend'="" q               //20121101
    .;i rw=7277 b //555
    .s cc="^"_cat_"^"
    .w !,name,"-",cat
    .if typ'[cc q
    .s ret=ret_rw_"|"_name_"^"  
    b //77
    q ret
}

Query GetArrPersons(parr As %String) As %Query(ROWSPEC = "curdate,Post,arrRowID,name,sexDes,prpostdes,headdes,DepDes,birth,WorkDateTime,Postnum,nurtyp")
{
}

ClassMethod GetArrPersonsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	  Set repid=$I(^CacheTemp)
 	  s ind=1
 	  k ^TMP(repid,"MGPERSONID")
 	  s argLocID=$P(parr,"^",1)
 	  s argDate1=$P(parr,"^",2)
 	  s PostFlag=$P(parr,"^",3)
 	  i argDate1'="" s argDate1=$ZDH(argDate1,3)
 	  e  s argDate1=+$H
 	  s argDate2=$P(parr,"^",4)
 	  i argDate2'="" s argDate2=$ZDH(argDate2,3)
 	  e  s argDate2=+$H
 	  s PostSum=0
 	  f argDate=argDate1:1:argDate2 d
 	  .s arrRowID="" f  s arrRowID=$O(^User.DHCMGPersonArrangeI("Date",argDate,arrRowID)) q:arrRowID=""  d
	  ..s arr=^User.DHCMGPersonArrangeD(arrRowID)
 	  ..s PostDr=$List(arr,6)
	  ..s flag=$List(arr,4)
	  ..;i PostDr="" continue
	  ..q:PostDr=""
	  ..s ARRPerDR=$List(arr,5)
	  ..q:ARRPerDR=""
	  ..s Dep=$List(arr,3)
	  ..q:(argLocID'="")&(argLocID'=Dep)
	  ..q:Dep=""
	  ..s pflag=$List(^User.DHCMGPostD(PostDr),7)
	  ..s hours=$List(^User.DHCMGPostD(PostDr),10)
	  ..s NightHour=$ListGet(^User.DHCMGPostD(PostDr),14)
	  ..s NightFlag=0,UnExitFlag=0
	  ..i (pflag="Y")!(NightHour>0) s NightFlag=1
	  ..i (NightHour>0)&(hours>NightHour) s UnExitFlag=1
	  ..q:(PostFlag="Y")&(NightFlag=0)&(UnExitFlag=0)
	  ..q:(PostFlag="N")&(NightFlag=1)&(UnExitFlag=0)
	  ..s Post="",Postnum="",hours=""

	  ..q:$d(^TMP(repid,"MGPERSONID",Dep,ARRPerDR,argDate))
	  ..s ^TMP(repid,"MGPERSONID",Dep,ARRPerDR,argDate)=""
	  ..
	  ..s tmparrid="" f  s tmparrid=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_ARRPerDR,argDate,tmparrid)) q:tmparrid=""  d
	  ...s tmpPostDr=$List(^User.DHCMGPersonArrangeD(tmparrid),6)
	  ...q:tmpPostDr=""
	  ...s tmpDep=$List(^User.DHCMGPersonArrangeD(tmparrid),3)
	  ...q:tmpDep'=Dep
	  ...s tmpPost=$List(^User.DHCMGPostD(tmpPostDr),3)
	  ...s tmpflag=$List(^User.DHCMGPersonArrangeD(tmparrid),4)
	  ...s tmphours=$List(^User.DHCMGPostD(tmpPostDr),10)
	  ...i (tmpflag="A")!(tmpflag="P") d
	  ....s tmphours=$fn((tmphours/2),"",2)
	  ...i hours="" s hours=tmphours
	  ...e  s hours=hours+tmphours
	  ...i Post="" s Post=tmpPost
	  ...e  s Post=Post_"/"_tmpPost
	  ..s DepDes=""
	  ..q:Post=""
	  ..i hours'="" s Postnum=$fn((hours/8),"",2)
	  ..i Postnum'="" s PostSum=PostSum+Postnum
      ..;i Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
	  ..s parPerson=^User.DHCMGPersonsD(ARRPerDR)
      ..s name=$list(parPerson, 21)
      ..s sex=$list(parPerson, 34)
      ..s sexDes=""
      ..i sex'="" s sexDes=$P(^CT("SEX",sex),"^",2)
     ..;s professpost=$list(parPerson, 29)
     ..s professpost=$list(parPerson, 4)       ;聘任职称
     ..s prpostdes=""
     ..i professpost'="" s prpostdes=$list(^User.DHCMGCPostCodeD(professpost),3)
     ..s head=$list(parPerson, 41)
     ..s headdes=""
     ..i head'="" s headdes=$list(^User.DHCMGCPostCodeD(head),3)
     ..s birth=$list(parPerson, 5)
     ..i birth'="" s birth=$zd(birth,3)
     ..s WorkDateTime=$list(parPerson, 40)
   	 ..i WorkDateTime'="" s WorkDateTime=$zd(WorkDateTime,3)
   	 ..s curdate=argDate
	 ..s curdate=$zd(curdate,3)
	 ..s nurtyp=$list(parPerson, 23)
	 ..i nurtyp'="" s nurtyp=$list(^User.DHCMGCCodeD(nurtyp),3)
	 ..s ^TMP(repid,"MGPERSONID","SORT",Dep,1,name,curdate,arrRowID)=Post_"^"_sexDes_"^"_prpostdes_"^"_headdes_"^"_DepDes_"^"_birth_"^"_WorkDateTime_"^"_Postnum_"^"_nurtyp
	 ..i $d(^TMP(repid,"MGPERSONID","SORT",Dep,2,"zzzzzz","9999999999999","9999999999999"))=0 d
	 ...s ^TMP(repid,"MGPERSONID","SORT",Dep,2,"zzzzzz","9999999999999","9999999999999")=Postnum
     ..e  d
     ...s ^TMP(repid,"MGPERSONID","SORT",Dep,2,"zzzzzz","9999999999999","9999999999999")=$g(^TMP(repid,"MGPERSONID","SORT",Dep,2,"zzzzzz","9999999999999","9999999999999"))+Postnum
     //b //78
     i $d(^TMP(repid,"MGPERSONID","SORT"))'=0 d
     .s Dep="" f  s Dep=$o(^TMP(repid,"MGPERSONID","SORT",Dep))  q:Dep=""  d
     ..s numSum=0 f  s numSum=$o(^TMP(repid,"MGPERSONID","SORT",Dep,numSum))  q:numSum=""  d
     ...s tmpname="" f  s tmpname=$o(^TMP(repid,"MGPERSONID","SORT",Dep,numSum,tmpname))  q:tmpname=""  d
     ....s tmpdate="" f  s tmpdate=$o(^TMP(repid,"MGPERSONID","SORT",Dep,numSum,tmpname,tmpdate))  q:tmpdate=""  d
     .....s tmparrRowID="" f  s tmparrRowID=$o(^TMP(repid,"MGPERSONID","SORT",Dep,numSum,tmpname,tmpdate,tmparrRowID))  q:tmparrRowID=""  d
     ......s allitem=$g(^TMP(repid,"MGPERSONID","SORT",Dep,numSum,tmpname,tmpdate,tmparrRowID))
     ......i tmpname="zzzzzz"  d
     .......s Post=""
     .......s sexDes=""
     .......s prpostdes=""
     .......s headdes=""
     .......s DepDes=$P(^CTLOC(Dep),"^",2)
     .......s birth=""
     .......s WorkDateTime=""
     .......s Postnum=allitem
     .......s arrRowID=""
     .......s name=""
     .......s nurtyp=""
     .......s curdate=""
     ......e  d
     .......s Post=$p(allitem,"^",1)
     .......s sexDes=$p(allitem,"^",2)
     .......s prpostdes=$p(allitem,"^",3)
     .......s headdes=$p(allitem,"^",4)
     .......s DepDes=$P(^CTLOC(Dep),"^",2)   ;$p(allitem,"^",5)
     .......s birth=$p(allitem,"^",6)
     .......s WorkDateTime=$p(allitem,"^",7)
     .......s Postnum=$p(allitem,"^",8)
     .......s nurtyp=$p(allitem,"^",9)
     .......s arrRowID=tmparrRowID
     .......s name=tmpname
     .......s curdate=tmpdate
     ......d OutRowtyp66
     i PostSum'=0 d
     .s curdate=""
     .s Post=""
     .s arrRowID=""
     .s name=""
     .s sexDes=""
     .s prpostdes=""
     .s headdes=""
     .s DepDes=""
     .s birth=""
     .s WorkDateTime=""
     .s Postnum=PostSum
     .i (PostSum[".")&($p(PostSum,".",2)="") s PostSum=$p(PostSum,".",1)
     .;b //7777
     .s nurtyp=""
     .d OutRowtyp66
     k ^TMP(repid,"MGPERSONID")
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
  
OutRowtyp66
	set Data=$lb(curdate,Post,arrRowID,name,sexDes,prpostdes,headdes,DepDes,birth,WorkDateTime,Postnum,nurtyp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetArrPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArrPersonsExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetArrPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArrPersonsExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod updateretire() As %String
{
   s rw="" f  s rw=$O(^User.DHCMGPersonsD(rw)) q:rw=""  d
   .s parr=^User.DHCMGPersonsD(rw)
   .s birth=$listget(parr, 5)
   .i birth'="" d
   ..s birth2=$zd(birth,3)
   ..s year=$p(birth2,"-",1)
   ..s mm=$p(birth2,"-",2,3)
   ..s year2=year+55
   ..s retiredate=year2_"-"_mm
   ..s retiredate=$zdh(retiredate,3)
   ..s a=##class(User.DHCMGPersons).%OpenId(rw)
   ..s a.PersonRetireDate=retiredate
   ..d a.%Save()
}

}

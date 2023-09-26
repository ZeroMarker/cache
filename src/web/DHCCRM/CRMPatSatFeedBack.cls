Class web.DHCCRM.CRMPatSatFeedBack Extends (%Persistent, %XML.Adaptor)
{

/// w ##class(web.DHCCRM.CRMPatSatFeedBack).PatSatList("","","",0,20)
ClassMethod PatSatList(BeginDate, EndDate, LocID, start, limit)
{
	s start=$G(start)
	s limit=$G(limit)
	;s ^xh("action")=BeginDate_"^"_EndDate_"^"_LocID_"^"_ICD_"^"_RegNo_"^"_PatName_"^"_PatSexID_"^"_PatAgeFrom_"^"_PatAgeTo
	 
	s rs=##class(%ResultSet).%New("web.DHCCRM.CRMPatSatFeedBack:SearchPatSat") 
	d rs.Execute(BeginDate,EndDate,LocID)
 
 	s count=0
 	s mess=""
 	s topnum=start+limit
 	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	s ptHosLoc=rs.Get("ptHosLoc")
	 	s ptPatNum=rs.Get("ptPatNum")
	 	s ptTreNum=rs.Get("ptTreNum")
	 	s ptAvgScore=rs.Get("ptAvgScore")
	 	s ptSatisfaction=rs.Get("ptSatisfaction")
	 	s ptPatRate=rs.Get("ptPatRate")
	 	s ptDocRate=rs.Get("ptDocRate")
	 	s ptFeedBack=rs.Get("ptFeedBack")
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ptHosLoc"":"_""""_ptHosLoc_""""
		s mess=mess_","_"""ptPatNum"":"_""""_ptPatNum_""""
		s mess=mess_","_"""ptTreNum"":"_""""_ptTreNum_""""
		s mess=mess_","_"""ptAvgScore"":"_""""_ptAvgScore_""""
		s mess=mess_","_"""ptSatisfaction"":"_""""_ptSatisfaction_""""
		s mess=mess_","_"""ptPatRate"":"_""""_ptPatRate_""""
		s mess=mess_","_"""ptDocRate"":"_""""_ptDocRate_""""
		s mess=mess_","_"""ptFeedBack"":"_""""_ptFeedBack_""""
		s mess=mess_"}"
		
	}	 	 
 s mess="["_mess_"]"
 s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"

 q mess
}

/// w ##class(web.DHCCRM.CRMPatSatFeedBack).GetResultVal("满意")
ClassMethod GetResultVal(result)
{
	i result="满意"	q 95
	i result="较满意"	q 85
	;i result="满意"	q 75
	i result="不满意"	q 50
	i result="是"	q 1
	i result="否"	q 0
}

/// D ##class(%ResultSet).RunQuery("web.DHCCRM.CRMPatSatFeedBack","SearchPatSat","2013-06-05","2013-07-09","")                                                                                                                          
Query SearchPatSat(BeginDate, EndDate, LocID) As %Query(ROWSPEC = "ptHosLoc:%String, ptPatNum:%String, ptTreNum:%String, ptAvgScore:%String, ptSatisfaction:%String,ptPatRate:%String,ptDocRate:%String,ptFeedBack:%String")
{
}

ClassMethod SearchPatSatExecute(ByRef qHandle As %Binary, BeginDate, EndDate, LocID) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	/*
	for i=1:1:5  d
	.;d Clear
	.s (ptHosLoc, ptPatNum, ptTreNum, ptAvgScore, ptSatisfaction,ptPatRate,ptDocRate,ptFeedBack)=i
	.d OutputRow
	*/
	//start
	s ^tmpjl(99)=BeginDate_"  "_EndDate_"  "_LocID
	k ^TMPDHCCRM("PatSat")
	k ^TMPDHCCRM("PatSat","Patient")
	i BeginDate="" s BeginDate=+$h
	else  s BeginDate=$Zdh(BeginDate,3)
	i EndDate="" s EndDate=+$h
	else  s EndDate=$Zdh(EndDate,3)
	
	f chgdate=BeginDate:1:EndDate d
	.s paadm=0
	.f  s paadm=$o(^PAADMi("DischDate",chgdate,paadm)) q:paadm=""  d
	..s papmiid=$p(^PAADM(paadm),"^",1)
	..s papmino=$p(^PAPER(papmiid,"PAT",1),"^",1) //登记号
	
	..;s admDocDr=$p(^PAADM(paadm),"^",9)
	..;i admDocDr'="" s admDoc=$p(^CTPCP(admDocDr,1),"^",2) //主管医生
	
	..;i RegNo'=""  s RegNo=..RegNoMask(RegNo)
	..;q:(RegNo'="")&&(RegNo'=papmino)
	..s pttype=$P($g(^PAADM(paadm)),"^",2)
	..s mrmrid=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadm,pttype,.ErrMsg)  // $p(^PAPER(papmiid,"PAT",1),"^",22) //病案
	..
	..s mrname=$p(^PAPER(papmiid,"ALL"),"^",1)	//姓名
	..;q:(PatName'="")&&(mrname'[PatName)
	..s mrgender=$p(^PAPER(papmiid,"ALL"),"^",7)	//性别
	..;q:(PatSexID'="")&&(PatSexID'= mrgender)
	..i mrgender'="" s mrgender=$p(^CT("SEX",mrgender),"^",2)
	..s mrbirthday=$p(^PAPER(papmiid,"ALL"),"^",6)	//生日
	..i mrbirthday'="" s mrbirthday=##class(web.DHCLCNUREXCUTE).CalAge(mrbirthday,$P($g(^PAADM(paadm)),"^",6))
	..s Age=$P(mrbirthday,"Y",1)_"岁" 	//年龄
	..s mrcardid=$p(^PAPER(papmiid,"ALL"),"^",9)
	..;q:(PatAgeFrom'="")&&(PatAgeFrom>Age)
	..;q:(PatAgeTo'="")&&(PatAgeTo<Age)
	..s admdate=$P($g(^PAADM(paadm)),"^",6) //入院日期
	..i admdate'="" s mradmdate=$zd(admdate,3)
	..s disdate=chgdate //出院日期
	..i disdate'="" s disdate=$zd(disdate,3)
	..s mainmr=$p(^PAADM(paadm),"^",61)
	..
	..s mrsub=0,diagnos="",diagcode=""
	..f  s mrsub=$o(^MR(mainmr,"DIA",mrsub)) q:mrsub=""  d
	...s ICDCode=$p(^MR(mainmr,"DIA",mrsub),"^",1)
	...q:ICDCode=""
	...s ICDDesc=$p(^MRC("ID",ICDCode),"^",2)
	...i diagnos="" s diagnos=ICDDesc
	...e  s diagnos=diagnos_"/"_ICDDesc
	...i diagcode="" s diagcode=ICDCode
	...e  s diagcode=diagcode_"/"_ICDCode
	..s disdiag=diagnos
	..
	..;q:(ICD'="")&&(diagcode'[ICD)
	..s mrtel=$p(^PAPER(papmiid,"PER",1),"^",11)	//手机
	..s mraddress=$g(^PAPER(papmiid,"PER","ADD"))	//地址
	..s mrcd=$p(^MR(mainmr,"PRO",1),"^",10)	//
	..i mrcd'="" s admroom=$p(^PAC("DISCON",mrcd),"^",2)
	..s admdoc=$p(^PAADM(paadm),"^",9)
	..i admdoc'="" s admdiag=$p(^CTPCP(admdoc,1),"^",2)
	..
	..s disroomdr=$p(^PAADM(paadm),"^",4)	//出院科室
	..q:(LocID'="")&&(LocID'=disroomdr)
	..i disroomdr'="" s mrdisroom=$p(^CTLOC(disroomdr),"^",2)
	..s CRMFlag="O"	;出院病人
	..;下面获取随访的信息
	..s QRID=$O(^DHCCRMQR(0,"QR_PAADM_DR",paadm,0))	//阅卷记录主表
	..i QRID'="" d
	...s FUPID=$O(^DHCCRMQR(0,"QR_FUP_DR",QRID,0))	//随访计划表
	...q:FUPID=""
	...s FUPSubject=$P($O(^DHCCRMFUP(FUPID)),"^",2)
	...q:FUPSubject=2	//非信息科随访退出
	...s CRMFlag="Y"
	...s ptUserID=$P($G(^DHCCRMFUP(FUPID)),"^",5)	//随访人
	...;q:i	//不是信息科随访退出,可以通过随访主题q
	...s sub=0
	...f  s sub=$O(^DHCCRMQR(FUPID,"Detail",sub))  q:sub=""
	....s DetailData=$G(^DHCCRMQR(FUPID,"Detail",sub))
	....s SDID=$P(DetailData,"^",2)
	....s SDPar=$P(SDID,"||",1)
	....s SDSub=$P(SDID,"||",2)
	....s SDDesc=$P($G(^DHCCRMFUS(SDPar,"SD",SDSub)),"^",2)
	....q:(SDDesc'="总体感受")||(SDDesc'="主管医师是否随访")
	....i SDDesc="总体感受" d
	.....s FirResult=$P(DetailData,"^",3)
	....i SDDesc="主管医师是否随访"
	.....s SecResult=$P(DetailData,"^",3)
	..;s FUPID=$O(^DHCCRMFUP(0,"FUP_PAADM",paadm,0))	//随访计划表
	...;i FUPID'="" d
	....;s CRMFlag=""
	..s ^TMPDHCCRM("PatSat","Patient",disroomdr,paadm)=paadm_"^"_disroomdr_"^"_disdate_"^"_CRMFlag_"^"_"随访"_"^"_FirResult_"^"_SecResult
	..;s ^TMPDHCCRM("PatSat","Patient",paadm)=paadm1^   出院科室2^  出院日期3^  随访标志4^   随访医师5^问题1(总体感受)6^问题2(主管医师是否随访)7
	;下面开始计算数据
	s disroomdr=0,(FirVal,SecVal,Count,x)=0
	f  s disroomdr=$O(^TMPDHCCRM("PatSat","Patient",disroomdr)) q:disroomdr=""
	.s paadm=0
	.f  s paadm=$O(^TMPDHCCRM("PatSat","Patient",disroomdr,paadm)) q:paadm=""
	..s CurData=$G(^TMPDHCCRM("PatSat","Patient",disroomdr,paadm))
	..s paadm=$P(CurData,"^",1)
	..s disroomdr=$P(CurData,"^",2)
	..s CRMFlag=$P(CurData,"^",4)	//出院总数；计划随访数目；完成随访数目；挂起随访数目
	..s ^TMPDHCCRM("PatSat","disroomdr",disroomdr,CRMFlag)=$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr,CRMFlag))+1
	.;s ^TMPDHCCRM("PatSat","disroomdr",disroomdr)=$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr))+1
	..i CRMFlag="Y" d
	...s FirResult=$P(CurData,"^",6)
	...s FirResultVal=..GetResultVal(FirResult)
	...s FirVal=FirResultVal+FirVal
	...s SecResult=$P(CurData,"^",7)
	...s SecResultVal=..GetResultVal(SecResult)
	...s SecVal=SecResultVal+SecVal
	.s ptHosLoc=$p(^CTLOC(disroomdr),"^",2)
	.s ptPatNum=$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr,"Y"))+$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr,"O"))
	.s ptTreNum=$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr,"Y"))
	.S ptAvgScore=FirVal/$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr,"Y"))
	.s ptSatisfaction=0
	.S ptPatRate=SecVal/$G(^TMPDHCCRM("PatSat","disroomdr",disroomdr,"Y"))
	.s ptFeedBack=""
	.d OutputRow
	
	
	//end
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Clear
	set (ptHosLoc, ptPatNum, ptTreNum, ptAvgScore, ptSatisfaction,ptPatRate,ptDocRate,ptFeedBack)=""	
OutputRow
	set Data=$lb(ptHosLoc, ptPatNum, ptTreNum, ptAvgScore, ptSatisfaction,ptPatRate,ptDocRate,ptFeedBack)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchPatSatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPatSatExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }

 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchPatSatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPatSatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Storage Default
{
<Data name="CRMPatSatFeedBackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCRM.CRMPatSatFeedBackD</DataLocation>
<DefaultData>CRMPatSatFeedBackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCRM.CRMPatSatFeedBackD</IdLocation>
<IndexLocation>^web.DHCCRM.CRMPatSatFeedBackI</IndexLocation>
<StreamLocation>^web.DHCCRM.CRMPatSatFeedBackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

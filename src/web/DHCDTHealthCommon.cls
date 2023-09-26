/// Creator:      
/// CreatDate:    2011.01.08
/// Description:: DTHealth6.9版后 公共类       
/// Others:
Class web.DHCDTHealthCommon Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:格式化登记号
/// input:PatientNo 登记号
/// output:格式化后的登记号
/// other:
/// debug:w ##class(web.DHCDTHealthCommon).FormatPatientNo("12")
ClassMethod FormatPatientNo(PatientNo As %String) As %String
{
	n (PatientNo)
	s PatientNoRet=""
	Q:$Number(PatientNo)="" ""
	s PatientNoLen=+..GetPatientNoLen()
	
	if $l(PatientNo)>PatientNoLen {
		s PatientNoRet=$e(PatientNo,1,PatientNoLen)
	}else{
		s PatientNoRet=$e("0000000000000000000",1,PatientNoLen-$l(PatientNo))_PatientNo
	}
	
	Q PatientNoRet
}

/// creator:郭荣勇
/// date:2011-01-13
/// desc:得到登记号系统设置长度
/// input:
/// output:登记号系统设置长度
/// other:
/// debug:w ##class(web.DHCDTHealthCommon).GetPatientNoLen()
ClassMethod GetPatientNoLen() As %String
{
	s PatientNoLen=+$p(^CF("PATCF",1,3),"^",5)
	
	Q PatientNoLen
}

/// creator:郭荣勇
/// date:2011-01-14
/// desc:找用户登录科室(与SSUserOtherLogonLoc有个科室参数的区别)
/// input:
/// output:
/// other:
/// debug:d ##class(%ResultSet).RunQuery("web.DHCDTHealthCommon","LookUpSelectedUser",600,"","CRKMZ-传染科门诊")
Query LookUpSelectedUser(User As %Library.String, hospital As %Library.String, Department As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Loc:%String,Group:%String,HOSPDesc:%String")
{
	SELECT  OTHLL_CTLOC_DR->CTLOC_Desc, OTHLL_UserGroup_DR->SSGRP_Desc
    FROM  SQLUser.SS_UserOtherLogonLoc
    WHERE  (%ALPHAUP OTHLL_ParRef->SSUSR_Name [ %ALPHAUP :User) 
    ORDER BY OTHLL_CTLOC_DR->CTLOC_Desc
}

ClassMethod LookUpSelectedUserClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSelectedUserFetch ]
{
	 Set repid=$LIST(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod LookUpSelectedUserExecute(ByRef QHandle As %Library.Binary, user As %Library.String = "", hospital As %Library.String = "", Department As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	Set repid=$I(^CacheTemp)
	If $g(index)="" Set index=1
	k ^||TempDepartment
    Set Department=##class(web.DHCDocUtil).UnEscape(Department)
    Set Department=$zcvt(Department,"U")
	Set rset=##class(%ResultSet).%New("web.SSUserOtherLogonLoc:LookUpSelectedUser")
	d rset.Execute(user, hospital)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		s Data=""
		s LocDesc=rset.GetDataByName("Loc")
		s LocDesc=$zcvt(LocDesc,"U")
		i (Department'="")&&(LocDesc'[Department) continue
		for i=1:1:columns {
			s $List(Data,i)=rset.GetData(i)
		}
		Set ^CacheTemp(repid,index)=Data
		Set index=index+1
		;set ^||TempDepartment(" "_rset.GetDataByName("HOSPDesc"),rset.GetDataByName("Loc"),rset.GetDataByName("Group"))=Data
	 }
	d rset.Close()
	;wanghc 2012/05/04 
	;s hosp="" f  s hosp=$O(^||TempDepartment(hosp)) q:hosp=""  d
	;.s loc="" f  s loc=$O(^||TempDepartment(hosp,loc)) q:loc=""  d
	;..s group="" f  s group=$O(^||TempDepartment(hosp,loc,group)) q:group=""  d
	;...Set ^CacheTemp(repid,index)=^||TempDepartment(hosp,loc,group)
	;...Set index=index+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpSelectedUserFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSelectedUserExecute ]
{
	 Set AtEnd=$LIST(QHandle,1)
	 Set repid=$LIST(QHandle,2)
	 Set ind=$LIST(QHandle,3)
		//
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" {				// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 // Save QHandle
	 s QHandle=$lb(AtEnd,repid,ind)
	 Quit $$$OK
}

}

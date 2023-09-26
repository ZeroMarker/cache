Class web.DHCANRCCheckItem Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANRCCheckItem","FindANRCCheckItem")
Query FindANRCCheckItem(CheckItem As %String) As %Query(ROWSPEC = "RowId,Code,Desc,DefAnrcmcDr,DefAnrcmcDesc,ClcmsDr,ClcmsDesc,Type,TestCode,ExamCode,ConsultationCode,DisProject,DisDecide,DisRowColNum")
{
}

ClassMethod FindANRCCheckItemExecute(ByRef qHandle As %Binary, CheckItem As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s RowId=0
	f  s RowId=$o(^DHCANRC("CheckItem",RowId)) q:RowId=""  d
	.s Code=$li(^DHCANRC("CheckItem",RowId),1)
	.s Desc=$li(^DHCANRC("CheckItem",RowId),2)
	.q:(CheckItem'="")&&(Desc'[CheckItem)
	.s DefAnrcmcDr=$li(^DHCANRC("CheckItem",RowId),3)
	.;q:DefAnrcmcDr=""
	.i DefAnrcmcDr'="" s DefAnrcmcDesc=$li(^DHCANRC("ManageClass",DefAnrcmcDr),2)
	.e  s DefAnrcmcDesc=""
	.s ClcmsDr=$li(^DHCANRC("CheckItem",RowId),4)
	.;q:ClcmsDr=""
	.i ClcmsDr'="" s ClcmsDesc=$li(^DHCCLC("MedicalSpecialty",ClcmsDr),2)
	.e  s ClcmsDesc=""
	.s Type=$li(^DHCANRC("CheckItem",RowId),5)
	.s TestCode=$li(^DHCANRC("CheckItem",RowId),6)
	.s ExamCode=$li(^DHCANRC("CheckItem",RowId),7)
	.s ConsultationCode=$li(^DHCANRC("CheckItem",RowId),8)
	.s DisProject=$li(^DHCANRC("CheckItem",RowId),9)
	.s DisDecide=$li(^DHCANRC("CheckItem",RowId),10)
	.s DisRowColNum=$li(^DHCANRC("CheckItem",RowId),11)
	.d OutputRow 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,Code,Desc,DefAnrcmcDr,DefAnrcmcDesc,ClcmsDr,ClcmsDesc,Type,TestCode,ExamCode,ConsultationCode,DisProject,DisDecide,DisRowColNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANRCCheckItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANRCCheckItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindANRCCheckItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANRCCheckItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCANRCCheckItem).InsertANRCCheckItem("1","测试一",2,1,"E","test1","exam1","consul1")
ClassMethod InsertANRCCheckItem(Code, Desc, DefAnrcmcDr, ClcmsDr, Type, TestCode, ExamCode, ConsultationCode, DisplayTypeStr, DisIf, RowNumber) As %String
{
	;s ^tempck(1)=Code_"^"_Desc_"^"_DefAnrcmcDr_"^"_ClcmsDr_"^"_Type_"^"_TestCode_"^"_ExamCode_"^"_ConsultationCode_"^"_DisplayTypeStr_"^"_DisIf_"^"_RowNumber
	q:(Code="")!(Desc="") "代码和描述不能为空！"
	//q:(DefAnrcmcDr="")!(ClcmsDr="") "风险管理级别和医疗专业表不能为空！"
	q:DefAnrcmcDr="" "风险管理级别！"
	s ObjCheckItem=##class(User.DHCANRCCheckItem).%New()
	s ObjCheckItem.ANRCCICode=Code
	s ObjCheckItem.ANRCCIDesc=Desc
	s defAnrcmcDr=##class(User.DHCANRCManageClass).%OpenId(DefAnrcmcDr)
	s ObjCheckItem.ANRCCIDefAnrcmcDr=defAnrcmcDr
	s clcmsDr=##class(User.DHCCLCMedicalSpecialty).%OpenId(ClcmsDr)
	s ObjCheckItem.ANRCCIClcmsDr=clcmsDr
	s ObjCheckItem.ANRCCIType=Type
	s ObjCheckItem.ANRCCITestCode=TestCode
	s ObjCheckItem.ANRCCIExamCode=ExamCode
	s ObjCheckItem.ANRCCIConsultationCode=ConsultationCode
	s ObjCheckItem.ANRCCIDisplayProject=DisplayTypeStr  //保存显示方式
	s ObjCheckItem.ANRCCIDisplayDecide=DisIf  //保存显示方式
	s ObjCheckItem.ANRCCIDisplayRowColNum=RowNumber //行列描述
	s SaveStatus=ObjCheckItem.%Save()
	q:(+SaveStatus=0) "数据保存失败！"
	s ID=ObjCheckItem.%Id()
	d ObjCheckItem.%Close()
	q 0
}

/// d ##class(web.DHCANRCCheckItem).UpdateANRCCheckItem("6","xcg","血常规","1","","L","test1","exam1","consul1")
ClassMethod UpdateANRCCheckItem(RowId, Code, Desc, DefAnrcmcDr, ClcmsDr, Type, TestCode, ExamCode, ConsultationCode, DisplayTypeStr, DisIf, RowNumber) As %String
{
	q:RowId="" "RowId不能为空"
	q:(Code="")!(Desc="") "代码和描述不能为空！"
	//q:(DefAnrcmcDr="")!(ClcmsDr="") "风险管理级别和医疗专业表不能为空！"
	q:(DefAnrcmcDr="") "风险管理级别不能为空！"
	q:'##class(User.DHCANRCCheckItem).%ExistsId(RowId) "无指针对应记录"
	s ObjCheckItem=##class(User.DHCANRCCheckItem).%OpenId(RowId)
	s ObjCheckItem.ANRCCICode=Code
	s ObjCheckItem.ANRCCIDesc=Desc
	s defAnrcmcDr=##class(User.DHCANRCManageClass).%OpenId(DefAnrcmcDr)
	s ObjCheckItem.ANRCCIDefAnrcmcDr=defAnrcmcDr
	i ClcmsDr'="" s clcmsDr=##class(User.DHCCLCMedicalSpecialty).%OpenId(ClcmsDr)
	e  s clcmsDr=""
	s ObjCheckItem.ANRCCIClcmsDr=clcmsDr
	s ObjCheckItem.ANRCCIType=Type
	s ObjCheckItem.ANRCCITestCode=TestCode
	s ObjCheckItem.ANRCCIExamCode=ExamCode
	s ObjCheckItem.ANRCCIConsultationCode=ConsultationCode
	s ObjCheckItem.ANRCCIDisplayProject=DisplayTypeStr  //保存显示方式
	s ObjCheckItem.ANRCCIDisplayDecide=DisIf  //保存显示方式
	s ObjCheckItem.ANRCCIDisplayRowColNum=RowNumber //行列描述
	s UpdateStatus=ObjCheckItem.%Save()
	q:(+UpdateStatus=0) "数据修改失败！"
	d ObjCheckItem.%Close()
	q 0
}

/// w ##class(web.DHCANRCCheckItem).DeleteANRCCheckItem(6)
ClassMethod DeleteANRCCheckItem(RowId) As %String
{
	q:RowId=""
	q:'##class(User.DHCANRCCheckItem).%ExistsId(RowId) "无指针对应记录"
	s DeleteStatus=##class(User.DHCANRCCheckItem).%DeleteId(RowId)
	q:(+DeleteStatus=0) "数据删除失败！"
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCANRCCheckItem","FindMedicalSpecialty")
/// DHC_CLC_MedicalSpecialty
Query FindMedicalSpecialty() As %SQLQuery(CONTAINID = 1, ROWSPEC = "clcmsRowId:%Integer,clcmsSCode:%String,clcmsDesc:%String")
{
    select CLCMS_RowId,CLCMS_Code,CLCMS_Desc from SQLUser.DHC_CLC_MedicalSpecialty
}

}

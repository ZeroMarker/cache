Import SQLUser

Class web.DHCDocEnsCardioExam Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod CardiogramExam(OeoriRowid As %Library.String)
{
	// 心电图检查接口
	// w ##class(web.DHCXPTest).CardiogramExam("177445||3")
	s ObjCardio=##class(web.DHCDocCardioExam).%New()
	q:$l(OeoriRowid,"||")'=2 ObjCardio
	s OrderRowid=$p(OeoriRowid,"||",1)
	s ChildSub=$p(OeoriRowid,"||",2)
	q:'$d(^OEORD(OrderRowid,"I",ChildSub)) ObjCardio
	s PaadmDr=$p(^OEORD(OrderRowid),"^",1)
	s PapmiDr=$p(^PAADM(PaadmDr),"^",1)
	s PatIPNo=$p(^PAPER(PapmiDr,"PAT",1),"^",1) ;住院号
	s PatOPNo=$p(^PAPER(PapmiDr,"PAT",1),"^",2)	;门诊号
	s PatOPNo=..GetCardNoByPatientID(PapmiDr)   ;门诊号(卡号)
	s PaadmType=$p(^PAADM(PaadmDr),"^",2)		;就诊类别
	s PaadmTypeDesc=$Case(PaadmType,"":"未知","O":"门诊","I":"住院","N":"新生儿","E":"急诊","H":"体检",:"状态错误")
	i PaadmType="I" d
	.;s PatWardDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,9)),"^",2) 	;下医嘱病区
	.s PatWardDr=$p($g(^PAADM(PaadmDr)),"^",70)						;当前病区
	.s OrdWardDesc=$p($g(^PAWARD(PatWardDr)),"^",2)						;病区
	.i OrdWardDesc["-"  s OrdWardDesc=$p(OrdWardDesc,"-",2)
	e  s OrdWardDesc=""
	
	s BedID=$p($g(^PAADM(PaadmDr)),"^",73)							;住院床位号
	i BedID'="" d
	.s BedNo=$p($g(^PAWARD(+BedID,"BED",$p(BedID,"||",2))),"^",1)
	e  d
	. s BedNo=""
	s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1) 	;病人姓名
	s PatDob=+$p(^PAPER(PapmiDr,"ALL"),"^",6)	;出生日期
	s PatDob=$zd(PatDob,3)						
	s PatGenderDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
	s PatGenderDesc=$p(^CT("SEX",PatGenderDr),"^",2)	;性别
	s Height=""				;身高
	s Weight=""				;体重	
	s Race=""				;种族
	s FolkDr=$p(^PAPER(PapmiDr,"PER",2),"^",1)	;民族
	s FolkDesc=""
	i FolkDesc'=""  s FolkDesc=$p($g(^CT("NAT",FolkDr)),"^",2)
	i FolkDesc["-" s FolkDesc=$p(FolkDesc,"-",2)
	s CredID=$p(^PAPER(PapmiDr,"ALL"),"^",9)				;s身份证号
	s Address=$g(^PAPER(PapmiDr,"PER","ADD",1))				;永久通讯地址
	s Zip=$p($g(^PAPER(PapmiDr,"PER",1)),"^",7)				;对应通讯地址的邮政编码
	s TelHome=$p($g(^PAPER(PapmiDr,"PER",1)),"^",11)		;家庭电话号码 
	s TelOffice=$p($g(^PAPER(PapmiDr,"PER",1)),"^",9)		;移动电话号码
	
	s ARCIMRowid=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",2)			;OEORI_ItmMast_DR
	s ARCIMSubScript=$p(ARCIMRowid,"||",1)
	s ARCIMSubVersion=$p(ARCIMRowid,"||",2)
	s ARCIMDesc=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",2)  	;ARCIM_Desc 
	s ARCICRowId=$p($g(^ARCIM(ARCIMSubScript,ARCIMSubVersion,1)),"^",10)  	;ARCIM_ItemCat_DR  
	s ARCICDesc=$p($g(^ARC("IC",ARCICRowId)),"^",2)
	s myARCIMStr=""
	i ARCIMDesc["(" s myARCIMStr="("_$p(ARCIMDesc,"(",2)
	s ExamType=ARCICDesc_myARCIMStr											;心电检查类型?????????????
	s OrdDeptDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",3)  
	s OrdDeptDesc=$p(^CTLOC(OrdDeptDr),"^",2)						;申请科室
	i OrdDeptDesc["-"  s OrdDeptDesc=$p(OrdDeptDesc,"-",2)
	s OrdDocDr=$p($g(^OEORD(OrderRowid,"I",ChildSub,1)),"^",11)		;申请医生ID
	s OrdDocDesc=$p($g(^CTPCP(OrdDocDr,1)),"^",2)	
	i OrdDocDesc["-" s OrdDocDesc=$p(OrdDocDesc,"-",2)				;申请医生姓名
	;输出
	
	s ObjCardio.HisPatientID=PapmiDr
	s ObjCardio.HisExamID=OeoriRowid
	s ObjCardio.InHospitalID=PatIPNo
	s ObjCardio.TreadID=PatOPNo
	s ObjCardio.TreadType=PaadmTypeDesc
	s ObjCardio.Location=OrdWardDesc
	s ObjCardio.BedNo=BedNo
	s ObjCardio.Name=PatName
	s ObjCardio.Birthday=PatDob
	s ObjCardio.Gender=PatGenderDesc
	s ObjCardio.Height=Height
	s ObjCardio.Weight=Weight
	s ObjCardio.Race=Race
	s ObjCardio.Folk=FolkDesc
	s ObjCardio.IDNo=CredID
	s ObjCardio.MailingAddress=Address
	s ObjCardio.ZipCode=Zip
	s ObjCardio.PhoneNumberHome=TelHome
	s ObjCardio.PhoneNumberMobile=TelOffice
	s ObjCardio.SpiritTestType=ExamType
	s ObjCardio.ApplyDoctID=OrdDocDr
	s ObjCardio.ApplyDoctName=OrdDocDesc
	s ObjCardio.ApplyDept=OrdDeptDesc
	
	i ObjCardio.HisPatientID="" s ObjCardio.HisPatientID=" "
	i ObjCardio.HisExamID="" s ObjCardio.HisExamID=" "
	i ObjCardio.InHospitalID="" s ObjCardio.InHospitalID=" "
	i ObjCardio.TreadID="" s ObjCardio.TreadID=" "
	i ObjCardio.TreadType="" s ObjCardio.TreadType=" "
	i ObjCardio.Location="" s ObjCardio.Location=" "
	i ObjCardio.BedNo="" s ObjCardio.BedNo=" "
	i ObjCardio.Name="" s ObjCardio.Name=" "
	i ObjCardio.Birthday="" s ObjCardio.Birthday=" "
	i ObjCardio.Gender="" s ObjCardio.Gender=" "
	i ObjCardio.Height="" s ObjCardio.Height=" "
	i ObjCardio.Weight="" s ObjCardio.Weight=" "
	i ObjCardio.Race="" s ObjCardio.Race=" "
	i ObjCardio.Folk="" s ObjCardio.Folk=" "
	i ObjCardio.IDNo="" s ObjCardio.IDNo=" "
	i ObjCardio.MailingAddress="" s ObjCardio.MailingAddress=" "
	i ObjCardio.ZipCode="" s ObjCardio.ZipCode=" "
	i ObjCardio.PhoneNumberHome="" s ObjCardio.PhoneNumberHome=" "
	i ObjCardio.PhoneNumberMobile="" s ObjCardio.PhoneNumberMobile=" "
	i ObjCardio.SpiritTestType="" s ObjCardio.SpiritTestType=" "
	i ObjCardio.ApplyDoctID="" s ObjCardio.ApplyDoctID=" "
	i ObjCardio.ApplyDoctName="" s ObjCardio.ApplyDoctName=" "
	i ObjCardio.ApplyDept="" s ObjCardio.ApplyDept=" "
	q ObjCardio
}

ClassMethod UpdateStatus(OeoriRowid As %Library.String, UserRowid As %Library.String)
{
	// W ##class(web.DHCXPTest).UpdateStatus("177445||3")
	;n (OeoriRowid,UserRowid)
	q:$l(OeoriRowid,"||")'=2 "100"
	s OrderRowid=$p(OeoriRowid,"||",1)
	s ChildSub=$p(OeoriRowid,"||",2)
	q:'$d(^OEORD(OrderRowid,"I",ChildSub)) "100"
	s ExeDate=+$h
	s ExeTime=$p($h,",",2)
	k PLIST
	s ExeId=""
	s ExeId=$o(^OEC("OSTAT",0,"Code","E",stoprid))
	s PLIST(10) = ExeId		;; "6"
	s PLIST(115) = ExeDate
	s PLIST(116) = ExeTime
	s PLIST(117) = UserRowid
	s PLIST(141) = UserRowid
	&sql(UPDATE OE_OrdItem VALUES :PLIST() WHERE OEORI_RowId=:OeoriRowid)
	q SQLCODE
}

ClassMethod GetCardNoByPatientID(PatientID As %Library.String) As %Library.String
{
	s CardNo=""
	q:$g(PatientID)="" CardNo
	s CardRefRowID="0"
	f  s CardRefRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,CardRefRowID)) q:CardRefRowID=""  d
	.s ActiveFlag=$p($g(^DHCCARD("CF",CardRefRowID)),"^",10)
	.;q:ActiveFlag'="N"
	.s CardNo=$p($g(^DHCCARD("CF",CardRefRowID)),"^",2)
	.
	q CardNo
}

Storage Default
{
<Data name="DHCDocEnsCardioExamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDocEnsCardioExamD</DataLocation>
<DefaultData>DHCDocEnsCardioExamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCDocEnsCardioExamD</IdLocation>
<IndexLocation>^web.DHCDocEnsCardioExamI</IndexLocation>
<StreamLocation>^web.DHCDocEnsCardioExamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

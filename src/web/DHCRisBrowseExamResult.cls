/// 浏览医嘱结果信息
Class web.DHCRisBrowseExamResult Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/* 函数： GetReportBrowseURL
   功能： 根据医嘱的ROWID,获得报告浏览的URL
 
 */
ClassMethod GetReportBrowseURL(OrderItemRowid As %String) As %String
{
	s ResInfo=""
	s ClinicDr=0
	
	q:OrderItemRowid="" ""
	s OrderRowid=$p(OrderItemRowid,"||",1)
	s ChildSub=$p(OrderItemRowid,"||",2)
	s paadmrowid=$p($g(^OEORD(OrderRowid)),"^",1)
	q:paadmrowid="" ""
	
	s papatmasrowid=$p(^PAADM(paadmrowid),"^",1)
    s RegNo=$p($g(^PAPER(papatmasrowid,"PAT",1)),"^",1)
	s StudyNo=$o(^DHCPACRegInfoi("OEORI",OrderItemRowid,0))
	s RecLocId=$p(^OEORD(OrderRowid,"I",ChildSub,3),"^",6) 
	 
	s ClinicDr=$o(^DHCRBCi("LocClinicSet",RecLocId,ClinicDr))
	q:(ClinicDr="")
	
	s ReportFullFil=$P(^DHCRBC("ClinicSet",ClinicDr),"^",2)
	s RhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",3)
	s RRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",4)
	s RhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",5)
	s RStuyParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",6)
	s RDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",7)
	
	s RhasOther=$P(^DHCRBC("ClinicSet",ClinicDr),"^",14)      //存放医嘱的接收科室ID 
	s RhasOtherParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",15)  //前面的参数
	
	s RhasOrderItem=$P(^DHCRBC("ClinicSet",ClinicDr),"^",18)    
	s RhasOrderItemParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",19)
	
	//http://172.16.1.1/risWeb/Default.aspx?LID=83&SID=US20101102-003&OID=766||11
	s url=ReportFullFil
	i RhasOther="Yes" d
	.s url=url_RhasOtherParam_RecLocId
	i RhasStudyNo="Yes" d
	.s url=url_RStuyParam_StudyNo
	i RhasOrderItem="Yes" d
	.s url=url_RhasOrderItemParam_OrderItemRowid
	i RhasReg="Yes" d
	.s url=url_RRegParam_RegNo
   q url
}

/* 函数： GetImageBrowseURL
   功能： 根据医嘱的ROWID,获得影像浏览的URL
 */
ClassMethod GetImageBrowseURL(OrderItemRowid As %String) As %String
{
	s ResInfo=""
	s ClinicDr=0
	
	q:OrderItemRowid="" ""
	s OrderRowid=$p(OrderItemRowid,"||",1)
	s ChildSub=$p(OrderItemRowid,"||",2)
	s paadmrowid=$p($g(^OEORD(OrderRowid)),"^",1)
	q:paadmrowid="" ""
	
	s papatmasrowid=$p(^PAADM(paadmrowid),"^",1)
    s RegNo=$p($g(^PAPER(papatmasrowid,"PAT",1)),"^",1)
	s StudyNo=$o(^DHCPACRegInfoi("OEORI",OrderItemRowid,0))
	s RecLocId=$p(^OEORD(OrderRowid,"I",ChildSub,3),"^",6) 
	 
	s ClinicDr=$o(^DHCRBCi("LocClinicSet",RecLocId,ClinicDr))
	q:(ClinicDr="")

	s ImageFullFile=$P(^DHCRBC("ClinicSet",ClinicDr),"^",8)
	
	s IhasReg=$P(^DHCRBC("ClinicSet",ClinicDr),"^",9)
	s IRegParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",10)
	s IhasStudyNo=$P(^DHCRBC("ClinicSet",ClinicDr),"^",11)
	s IStudyNoParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",12)
	s IDelim=$P(^DHCRBC("ClinicSet",ClinicDr),"^",13)

	s IhasOtherParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",16)
	s IOtherParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",17)  //前面的参数
	
	s IhasOrderItem=$P(^DHCRBC("ClinicSet",ClinicDr),"^",20)    
	s IhasOrderItemParam=$P(^DHCRBC("ClinicSet",ClinicDr),"^",21)
	
	//http://172.16.1.1/risWeb/Default.aspx?LID=83&SID=US20101102-003&OID=766||11
	s url=ImageFullFile
	i IhasOtherParam="Yes" d
	.s url=url_IOtherParam_RecLocId
	i IhasStudyNo="Yes" d
	.s url=url_IStudyNoParam_StudyNo
	i IhasOrderItem="Yes" d
	.s url=url_IhasOrderItemParam_OrderItemRowid
	i IhasReg="Yes" d
	.s url=url_IRegParam_RegNo
   q url
}

Storage Default
{
<Data name="DHCRisBrowseExamResultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCRisBrowseExamResultD</DataLocation>
<DefaultData>DHCRisBrowseExamResultDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCRisBrowseExamResultD</IdLocation>
<IndexLocation>^web.DHCRisBrowseExamResultI</IndexLocation>
<StreamLocation>^web.DHCRisBrowseExamResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

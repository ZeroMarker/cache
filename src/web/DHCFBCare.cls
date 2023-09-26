Class web.DHCFBCare Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetCareService(repid As %Integer, Para As %String) As %String
{
	s del="^",RetNum=0
	S CareDr=$P(Para,del)
	q:$g(CareDr)="" 0
	s RbcServiceId=0
	f  s RbcServiceId=$o(^RBC("SER",0,"CTCP",CareDr,RbcServiceId)) q:(RbcServiceId="")  d
	.s TmpStr=$g(^RBC("SER",RbcServiceId))
	.s ArcimId=$p(TmpStr,del,1)
	.s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
	.s ArcimDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	.s RetNum=RetNum+1
	.s ^CacheTempFHQ(repid,RetNum)=$g(ArcimId)_del_$g(ArcimDesc)
 q RetNum
}

}

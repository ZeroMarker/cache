Class web.DHCPE.DHCPEOccuBaseEx Extends %Persistent
{

ClassMethod GetHarmInfoID(IADMEx)
{
	q:(IADMEx="") IADMEx
	s IDs=""
	s IADMED=$LG(^User.DHCPEPreIADMExD(IADMEx),9)
	s EDLength=$LL(IADMED)
	f i=1:1:EDLength d
	.s IADMEDId=$LG(IADMED,i)
	.s:(IDs'="") IDs=IDs_","_IADMEDId
	.s:(IDs="") IDs=IADMEDId
	q IDs
}

ClassMethod GetData(ID)
{
	q:(ID="") ID
	
	q:'$d(^User.DHCPEPreIADMExI("PreIADMID",ID)) ""
	s ID=$o(^User.DHCPEPreIADMExI("PreIADMID",ID,0))
	s HarmInfo=..GetHarmInfo(ID)
	s HarmInfoID=..GetHarmInfoID(ID)
	s PreIADM=$lg(^User.DHCPEPreIADMExD(ID),2)
	s OMETTypeID=$lg(^User.DHCPEPreIADMExD(ID),3)
	s JobNumber=$lg(^User.DHCPEPreIADMExD(ID),4)
	s WorkAge=$lg(^User.DHCPEPreIADMExD(ID),5)
	s EndangerWorkAge=$lg(^User.DHCPEPreIADMExD(ID),6)
	s IndustryID=$lg(^User.DHCPEPreIADMExD(ID),7)
	s WorkTypeID=$lg(^User.DHCPEPreIADMExD(ID),8)
	s Remark=$lg(^User.DHCPEPreIADMExD(ID),10)   
	q EndangerWorkAge_"^"_IndustryID_"^"_JobNumber_"^"_OMETTypeID_"^"_PreIADM_"^"_Remark_"^"_WorkAge_"^"_WorkTypeID_"^"_HarmInfo_"^"_HarmInfoID
}

ClassMethod GetDataNew(ID)
{
	q:(ID="") ID
	
	q:'$d(^User.DHCPEPreIADMExI("PreIADMID",ID)) ""
	s ID=$o(^User.DHCPEPreIADMExI("PreIADMID",ID,0))
	s PreIADM=$lg(^User.DHCPEPreIADMExD(ID),2)
	s OMETTypeID=$lg(^User.DHCPEPreIADMExD(ID),3)
	s JobNumber=$lg(^User.DHCPEPreIADMExD(ID),4)
	s WorkAgeY=$lg(^User.DHCPEPreIADMExD(ID),5)
	s EndangerWorkAgeY=$lg(^User.DHCPEPreIADMExD(ID),6)
	s IndustryID=$lg(^User.DHCPEPreIADMExD(ID),7)
	s WorkTypeID=$lg(^User.DHCPEPreIADMExD(ID),8)
	s HarmInfo=$LISTTOSTRING($lg(^User.DHCPEPreIADMExD(ID),9))  // ..GetHarmInfo(ID)
	s Remark=$lg(^User.DHCPEPreIADMExD(ID),10)   
	s WorkAgeM=$lg(^User.DHCPEPreIADMExD(ID),11)
	s EndangerWorkAgeM=$lg(^User.DHCPEPreIADMExD(ID),12)
	q PreIADM_"^"_OMETTypeID_"^"_JobNumber_"^"_WorkAgeY_"^"_EndangerWorkAgeY_"^"_IndustryID_"^"_WorkTypeID_"^"_HarmInfo_"^"_Remark_"^"_WorkAgeM_"^"_EndangerWorkAgeM
}

ClassMethod Insert(String)
{
	s PreIADM=$p(String,"^",1)
	q:(PreIADM="") "更新错误,没有对应预约号"
	s OMETTypeID=$p(String,"^",2)
	s JobNumber=$p(String,"^",3)
	s WorkAge=$p(String,"^",4)
	s EndangerWorkAge=$p(String,"^",5)
	s IndustryID=$p(String,"^",6)
	s WorkTypeID=$p(String,"^",7)
	s WorkAgeM=$p(String,"^",8)
	s EndangerWorkAgeM=$p(String,"^",9)
	s Remark=""
	i $d(^User.DHCPEPreIADMExI("PreIADMID",PreIADM)) d
	.&SQL(Update Sqluser.DHC_PE_PreIADMEx set PIE_EndangerWorkAgeY=:EndangerWorkAge, PIE_IndustryID=:IndustryID, PIE_JobNumber=:JobNumber, PIE_OMETTypeID=:OMETTypeID, PIE_PreIADMID=:PreIADM, PIE_Remark=:Remark, PIE_WorkAgeY=:WorkAge, PIE_WorkTypeID=:WorkTypeID where PIE_PreIADMID=:PreIADM)
	else  d
	.&SQL(Insert into Sqluser.DHC_PE_PreIADMEx (PIE_EndangerWorkAgeY,PIE_IndustryID,PIE_JobNumber,PIE_OMETTypeID,PIE_PreIADMID,PIE_Remark,PIE_WorkAgeY,PIE_WorkTypeID) values (:EndangerWorkAge, :IndustryID, :JobNumber, :OMETTypeID, :PreIADM, :Remark, :WorkAge, :WorkTypeID))
	q SQLCODE
}

ClassMethod InsertNew(String)
{
	s PreIADM=$p(String,"^",1)
	q:(PreIADM="") "更新错误,没有对应预约号"
	s IndustryID=$p(String,"^",2)
	s WorkTypeID =$p(String,"^",3)
	s JobNumber=$p(String,"^",4)
	s WorkAgeY=$p(String,"^",5)
	s WorkAgeM=$p(String,"^",6)
	s EndangerWorkAgeY=$p(String,"^",7)
	s EndangerWorkAgeM=$p(String,"^",8)
	s OMETTypeID=$p(String,"^",9)
	s Remark=""
	i $d(^User.DHCPEPreIADMExI("PreIADMID",PreIADM)) d
	.&SQL(Update Sqluser.DHC_PE_PreIADMEx set PIE_IndustryID=:IndustryID, PIE_WorkTypeID=:WorkTypeID, PIE_JobNumber=:JobNumber, PIE_WorkAgeY=:WorkAgeY, PIE_WorkAgeM=:WorkAgeM, PIE_EndangerWorkAgeY=:EndangerWorkAgeY, PIE_EndangerWorkAgeM=:EndangerWorkAgeM, PIE_OMETTypeID=:OMETTypeID, PIE_Remark=:Remark, PIE_PreIADMID=:PreIADM where PIE_PreIADMID=:PreIADM)
	else  d
	.&SQL(Insert into Sqluser.DHC_PE_PreIADMEx (PIE_IndustryID,PIE_WorkTypeID,PIE_JobNumber,PIE_WorkAgeY,PIE_WorkAgeM,PIE_EndangerWorkAgeY,PIE_EndangerWorkAgeM,PIE_OMETTypeID,PIE_Remark,PIE_PreIADMID) values (:IndustryID, :WorkTypeID, :JobNumber, :WorkAgeY, :WorkAgeM, :EndangerWorkAgeY, :EndangerWorkAgeM, :OMETTypeID, :Remark, :PreIADM))
	q SQLCODE
}

ClassMethod GetHarmInfo(IADMEx)
{
	q:(IADMEx="") IADMEx
	s Desc=""
	s IADMED=$LG(^User.DHCPEPreIADMExD(IADMEx),9)
	s EDLength=$LL(IADMED)
	f i=1:1:EDLength d
	.s IADMEDId=$LG(IADMED,i)
	.s Tmpdesc=$LG(^User.DHCPEEndangerD(IADMEDId),3)
	.s:(Desc'="") Desc=Desc_","_Tmpdesc
	.s:(Desc="") Desc=Tmpdesc
	q Desc
}

ClassMethod GetHarmInfoForReport(ID, SplitChar As %String = ",")
{
	q:(ID="") ID
	s PreTeam=$p($g(^DHCPEPreIADM(ID)),"^",3)
	if (PreTeam'="") {
		s Desc=""
		s TeamEndanger=$g(^DHCPEDataEx("DHCPEPreGADM","TeamEndanger",PreTeam))
		s EDLength=$L(TeamEndanger,",")
		f i=1:1:EDLength d
		.s IADMEDId=$p(TeamEndanger,",",i)
		.q:IADMEDId=""
		.s Tmpdesc=$LG(^User.DHCPEEndangerD(IADMEDId),3)
		.s:(Desc'="") Desc=Desc_SplitChar_Tmpdesc
		.s:(Desc="") Desc=Tmpdesc
	} else {
		q:'$d(^User.DHCPEPreIADMExI("PreIADMID",ID)) ""
		s IADMEx=$o(^User.DHCPEPreIADMExI("PreIADMID",ID,0))
		q:(IADMEx="") IADMEx
		s Desc=""
		s IADMED="" //$LG(^User.DHCPEPreIADMExD(IADMEx),9)
		
		// 多危害因素处理
		s IADMEDList=$LG(^User.DHCPEPreIADMExD(IADMEx),9)  // 危害因素  $lb($lb($lb("1","2"),"3","1"),$lb($lb("42","43"),"2",""),$lb($lb("1"),"1",""))
		f n=1:1:$LL(IADMEDList) d
		.s temEDList=$lg($lg(IADMEDList,n),1)
		.f m=1:1:$LL(temEDList) d
		..s temED=$lg(temEDList,m)
		..i (("^"_IADMED_"^")'[("^"_temED_"^")) d
		...s:IADMED'="" IADMED=IADMED_"^"_temED
		...s:IADMED="" IADMED=temED
		q:IADMED=""
		s IADMED=$LISTFROMSTRING(IADMED,"^")
		
		s EDLength=$LL(IADMED)
		f i=1:1:EDLength d
		.s IADMEDId=$LG(IADMED,i)
		.q:IADMEDId=""
		.s Tmpdesc=$LG(^User.DHCPEEndangerD(IADMEDId),3)
		.s:(Desc'="") Desc=Desc_SplitChar_Tmpdesc
		.s:(Desc="") Desc=Tmpdesc
	}
	q Desc
}

Storage Default
{
<Data name="DHCPEOccuBaseExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.DHCPEOccuBaseExD</DataLocation>
<DefaultData>DHCPEOccuBaseExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.DHCPEOccuBaseExD</IdLocation>
<IndexLocation>^web.DHCPE.DHCPEOccuBaseExI</IndexLocation>
<StreamLocation>^web.DHCPE.DHCPEOccuBaseExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

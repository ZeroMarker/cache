Class web.DHCPE.Public.Common Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/*
ClassMethod IsHasPhoto(paadm, StationIDs As %String = "")
{
	s OEORDRowId=$O(^OEORD(0,"Adm",paadm,0))
	s Flag=0
	q:OEORDRowId="" Flag
	s PhotoStation=$G(^DHCPESetting("DHCPE","PhotoStation"))
	i PhotoStation="" s PhotoStation=StationIDs
	s OEORIChildsub=0
	f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:((""=OEORIChildsub)||(Flag=1))  d
	.s OEORIRowId=OEORDRowId_"||"_OEORIChildsub
	.s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	.q:OEORIItemStatDR'=6
	.s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	.s Station=$o(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
	.s Station="^"_Station_"^"
	.q:(PhotoStation'="")&&(Station'="^^")&&(PhotoStation'[Station)
	.Set RARRowId=$o(^DHCPACRegInfoi("OEORI",OEORIRowId,0))
	.Quit:$g(RARRowId)=""
	.Set RisStudyNo=$p(^DHCPACRegInfo(RARRowId),"^",2)
	.q:RisStudyNo=""
	.set ImageNo=$o(^DHCRBStudyi("StudyNo-Images",RisStudyNo,0))
	.q:ImageNo=""
	.s Flag=1
	q Flag
}
*/
ClassMethod strGetMatchVal(FieldNames As %String = "", FieldValues As %String = "", FieldName As %String = "", Splitor As %String = "^") As %String
{
	
	q:($l(FieldNames,Splitor)'=$l(FieldValues,Splitor)) ""
	s isFind=0
	for idx=1:1:$l(FieldNames,Splitor)  {
		i ($p(FieldNames,Splitor,idx)=FieldName)  {
			s isFind=1
			q
		}
	}
	q:(isFind=0) FieldName
	s ret=$p(FieldValues,Splitor,idx)
	q ret
}

ClassMethod GetIADMByPAADM(ID)
{
	q:(ID="") ""
	s IADM=$o(^DHCPEIADM(0,"PAADM",ID,0))
	q IADM
}

ClassMethod strReArrange(sourceStr, sourceSpec, targetSpec, mySplitor) As %String
{
	Set retStr=""
	//q:$length(sourceStr,mySplitor)'=$l(sourceSpec,mySplitor) //Modified by MLH 20060828"--strReArrange Error: sourceSpec length is mismatch"
	q:$length(sourceStr,mySplitor)<$l(sourceSpec,mySplitor) //Modified by MLH 20060828
	s i=1
	//while(i<=$length(sourceStr,mySplitor)){
	while(i<=$length(sourceSpec,mySplitor)){
		s arrTemp($p(sourceSpec,mySplitor,i))=$p(sourceStr,mySplitor,i)
		s i=i+1
	}
	s i=1
	s retStr=""	
	while(i<=$l(targetSpec,mySplitor)){	
		s targetField=$p(targetSpec,mySplitor,i)
		if ($e(targetField,1,1)="_"){s retStr=retStr_mySplitor}
		elseif (targetField="") { s retStr=retStr_mySplitor }
		else { s retStr=retStr_mySplitor_arrTemp(targetField)}
		s i=i+1
	}
	
	s retStr=$EXTRACT(retStr,($l(mySplitor)+1), $l(retStr))
	q retStr
}

/// 判断是否存在检查片子
/// s flag=##class(web.DHCPE.Public.Common).IsHasPhoto("334870")
/// Return:0   没有
///        1   有
///        
///       d  ##class(web.DHCPE.Public.Common).IsHasPhoto("334870")
/// ReWrite by MLH 2008-06-03
ClassMethod IsHasPhoto(paadm) As %String
{
	Set Flag=0
	Set ret=0
	Set IADM=$o(^DHCPEIADM(0,"PAADM",paadm,0))
	Set PIADM=$p(^DHCPEIADM(IADM),"^",4)
	Set PIOIChd=""
	For  Set PIOIChd=$o(^DHCPEPreIADM(PIADM,"ORDITEM", PIOIChd)) Quit:(PIOIChd="")  Do
	.Set ARCIM=$p($g(^DHCPEPreIADM(PIADM,"ORDITEM", PIOIChd)),"^",1)
	.Quit:ARCIM=""
	.Set ItemStat=$p(^DHCPEPreIADM(PIADM,"ORDITEM", PIOIChd),"^",16)
	.Quit:ItemStat'=1
	.Set STRowId=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
	.q:STRowId=""
	.Set STORDChd=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,STRowId,0)) 
	.Set IsHas=$g(^DHCPECTDataEx("DHCPEStationOrder","Photo",STRowId_"||"_STORDChd))
    .Set Flag=$s(IsHas'="Y":0,IsHas="Y":1)
    .i Flag=1  s ret=1 
    
   	q ret
}

/// ##class(web.DHCPE.Public.Common).UpdateGADM()
ClassMethod UpdateGADM()
{
	s PIADM=1531
	s SQLCODE=0
	TSTART
	f  s PIADM=$o(^DHCPEPreIADM(0,"PGADM","37",PIADM)) q:(PIADM="")||(SQLCODE'=0)  d
	.s SQLCODE=##class(web.DHCPE.TransAdmInfo).CheckGAdmCreated(PIADM)
	TROLLBACK:SQLCODE'=0
	q:SQLCODE'=0 SQLCODE
	TCOMMIT
	q SQLCODE
}

/// w ##class(web.DHCPE.Public.Common).GetComponentRows("","DHCPEIReport")
ClassMethod GetComponentRows(context, ComponentName)
{
	s compid=""
	s Rows=""
	&SQL(select id,listrows into :compid,:Rows from websys.component where name =:ComponentName)
	q:compid="" ""
	//s uSet=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"COLUMNS",comp.Name,.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")))
	s prefs=##Class(websys.Preferences).GetDataExLE($g(%session.Data("LOGON.USERID")),$g(%session.Data("LOGON.GROUPID")),$g(%session.Data("LOGON.HOSPID")),$g(%session.Data("LOGON.SITECODE")),context,"ROWS",ComponentName,.app,.appid,.activecontext,$g(%session.Data("LOGON.TRUSTID")))
	s uRows=$lg(prefs,1)
	i uRows="" s uRows=Rows
	q uRows
}

}

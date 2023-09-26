/// 名称: DHCMed.INFService.InfDiagnose
/// 描述: DHCMed.INF.InfDiagnose感染部位的常用操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-12
Class DHCMed.INFService.InfPositionSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  查询所有的部位
/// Table：       DHCMed.INF.InfPosition
/// Input：       
/// output:       所有的部位项            
/// Return： ID Code 3: InfPosition 4: Active 5: ResumeText     
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfPositionSrv","QryConfig")
Query QryPosition() As %Query(ROWSPEC = "myid:%String,Code:%String,InfPosition:%String,Active:%String,ResumeText:%String")
{
}

ClassMethod QryPositionExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s myid=$o(^DHCMed.INF.InfPositionD(""))
 	while (myid'="")
 	{
	s myObj=##class(DHCMed.INF.InfPosition).%OpenId(myid)
	if ($IsObject(myObj))
	{    
	    
		s Code=myObj.Code
		s InfPosition=myObj.InfPosition
		s Active=myObj.Active
		s ResumeText=myObj.ResumeText
		set Data=$lb(myid,Code,InfPosition,Active,ResumeText)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
      
		  } 	
	     s myid=$o(^DHCMed.INF.InfPositionD(myid))
	 	}
	Quit $$$OK
}

ClassMethod QryPositionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPositionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPositionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPositionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     ChenJB
/// CreatDate：   2010-05-12
/// Description:  查询所有部位的诊断
/// Table：       DHCMed.INF.InfPosition
/// Input：       部位 InfPos
/// output:       所有的部位项            
/// Return： InfDiaID ICD DiasName 
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfPositionSrv","QryICDByPos","1")
Query QryICDByPos(InfPosDr As %String = "") As %Query(ROWSPEC = "InfDiaID:%String,ICD:%String,DiasName:%String,subID:%String")
{
}

ClassMethod QryICDByPosExecute(ByRef qHandle As %Binary, InfPosDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//s InfPosDr=$$ALPHAUP^SSUTIL4(InfPosDr)
 	q:InfPosDr="" $$$OK
 	//s IdxInfPosDr=" "_InfPosDr  整型
 	s IdxInfPosDr=InfPosDr
 	s subID=0
 	f  s subID=$o(^DHCMed.INF.InfPosSubDiaI("InfPosDr",IdxInfPosDr,subID)) q:(+subID=0)  d
 	.s str=##class(DHCMed.INF.InfPosSubDia).GetStringById(subID,"^")
 	.q:str=""
 	.s InfDiaID=$p(str,"^",3)
 	.s InfDiaStr=##class(DHCMed.INF.InfDiagnose).GetStringById(InfDiaID,"^")
 	.q:InfDiaStr=""
 	.s Data=$lb(InfDiaID,$p(InfDiaStr,"^",2),$p(InfDiaStr,"^",3),subID)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
	Quit $$$OK
}

ClassMethod QryICDByPosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDByPosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDByPosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDByPosExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     chenjb
/// CreatDate：   2010-05-12
/// Description:  判断对象是否存在
/// Table：       
/// Input：       InfPosID ,InfDiaID
/// Return：      返回-1 -不存在，1 存在
/// w ##class(DHCMed.INFService.InfPositionSrv).IsExist("1","1")
ClassMethod IsExist(InfPosID As %String = "", InfDiaID As %String = "") As %Integer
{
	n (InfPosID ,InfDiaID)
	s ret=-1
	q:InfPosID="" ret
	q:InfDiaID="" ret
	//s idxInfPosID=" "_InfPosID
	//s idxInfDiaID=" "_InfDiaID   为整型
	s idxInfPosID=InfPosID
	s idxInfDiaID=InfDiaID
	q:'$d(^DHCMed.INF.InfPosSubDiaI("InfPosDr",idxInfPosID)) ret
	s subID=0
	f  s subID=$o(^DHCMed.INF.InfPosSubDiaI("InfPosDr",idxInfPosID,subID)) q:(+subID=0)!(ret=1)  d
	.s str=##class(DHCMed.INF.InfPosSubDia).GetStringById(subID,"^")
	.s tmpInfDiaID=$p(str,"^",3)
	.s:tmpInfDiaID=InfDiaID ret=1
	q ret
}

}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 化疗单日期审核状态
Class DHCDoc.Chemo.BS.DateApplyStatus Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 测试
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateApplyStatus).Test("77||10","S",12215,9)
ClassMethod Test(PDAID, Status, UpdateUser, UpdateLoc)
{
	S UpdateDate=+$H
	S UpdateTime=$P($H,",",2)
	&SQL(
		UPDATE SQLUser.Chemo_PlanDateApply 
		SET PDA_Status=:Status,PDA_AuditUser=:UpdateUser,
			PDA_AuditLoc=:UpdateLoc,PDA_AuditDate=:UpdateDate,
			PDA_AuditTime=:UpdateTime
		WHERE PDA_ID=:PDAID
	)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 插入/更新,调用的触发程序
/// IN  : 
/// OUT : 1(成功)
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateStatus).OnTrigger()
ClassMethod OnTrigger(parref As %String, type As %String = "") As %Status
{
	;n (parref,type)
	;s $zt="QueueStatusErr"
	s ^QP("OnTrigger",11)=$LB(parref,type)
	s rtn=1
	s ParObj=##class(User.ChemoPlanDateApply).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		
		if type="TAfterIns" {
			/*
			s user=ParObj.PDAuditUserGetObjectId()
			s loc=ParObj.PDAuditLocGetObjectId()
			s status=ParObj.PDStatus
			*/
			s user=ParObj.PDAAuditUserGetObjectId()
			s loc=ParObj.PDAAuditLocGetObjectId()
			s status=ParObj.PDAStatus
			s rtn=..InsertTS(parref,user,loc,status)
			i rtn=0 s rtn=1
			else  s rtn=-137
		}
		if type="TAfterUpd" {
			s (user,status,loc)=""
			;B ;0022
			s status=$g(%d(5))
			s loc=$g(%d(13))
			s user=$g(%d(12))

			s oldStatus=ParObj.PDAStatus
			;B ;0011
			i ($g(%d(5))="") {
				Q 1
			}
			
			i status=oldStatus {
				Q 1
			}
			s rtn=..InsertTS(parref,user,loc,status)
			i rtn=0 s rtn=1
			else  s rtn=-137
		}
	}
	

	Q rtn
QueueStatusErr
	Q 0
}

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 插入表记录
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateStatus).InsertTS(5,"12215","9","A")
ClassMethod InsertTS(inParref, inUser, inLoc, inStatus)
{
	//n (inParref, inUser, inLoc, inStatus)
 	s cDate=$P($H,",",1)
	s cTime=$P($H,",",2)
	s mRtn=0
	s ^QP("InsertTS")=$LB(inParref, inUser, inLoc, inStatus)
	i inStatus'="" {
		&SQL(
			INSERT INTO SQLUser.Chemo_PlanDateApplyStatus(PAS_ParRef,PAS_Status,PAS_Date,PAS_Time,PAS_User,PAS_Loc) 
   			VALUES(:inParref,:inStatus,:cDate,:cTime,:inUser,:inLoc))
   		i SQLCODE'=0 {
			Q SQLCODE	
		}
		/*
		s a=##class(User.ChemoPlanDateStatus).%New(inParref)
		s a.PDSStatus=inStatus
		s a.PDSDate=cDate
		s a.PDSTime=cTime
		d a.PDSLocSetObjectId(inLoc)
		d a.PDSUserSetObjectId(inUser)
		d a.PDSParRefSetObjectId(inParref)
		s sc=a.%Save()
		if ($$$ISERR(sc)) {
			//d $system.OBJ.DisplayError(sc) 
			s mRtn=-129
		} else {
			//s mRtn=a.%Id()
		}
		d a.%Close()
		*/
		
	}
   	;B ;0043
	q mRtn
}

}

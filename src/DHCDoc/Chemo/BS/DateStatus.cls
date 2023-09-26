/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 化疗单日期状态
Class DHCDoc.Chemo.BS.DateStatus Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-08-11
/// DESC: 测试
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.DateStatus).Test(76,"S",12215,9)
ClassMethod Test(PDID, Status, UpdateUser, UpdateLoc)
{
	S UpdateDate=+$H
	S UpdateTime=$P($H,",",2)
	&SQL(
		UPDATE SQLUser.Chemo_PlanDate 
		SET PD_Status=:Status,PD_UpdateUser=:UpdateUser,
			PD_UpdateLoc=:UpdateLoc,PD_UpdateDate=:UpdateDate,
			PD_UpdateTime=:UpdateTime
		WHERE PD_ID=:PDID
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
	s ParObj=##class(User.ChemoPlanDate).%OpenId(parref)
	;B ;0011
	if $ISOBJECT(ParObj) {
		
		if type="TAfterIns" {
			/*
			s user=ParObj.PDAuditUserGetObjectId()
			s loc=ParObj.PDAuditLocGetObjectId()
			s status=ParObj.PDStatus
			*/
			s user=ParObj.PDUpdateUserGetObjectId()
			s loc=ParObj.PDUpdateLocGetObjectId()
			s status=ParObj.PDStatus
			
			s rtn=..InsertTS(parref,user,loc,status)
			i rtn=0 s rtn=1
			else  s rtn="-129"
		}
		if type="TAfterUpd" {
			s (user,status,loc)=""
			s status=$g(%d(24))
			s loc=$g(%d(28))
			s user=$g(%d(27))
			s oldStatus=ParObj.PDStatus
			i ($g(%d(24))="") {
				Q 1
			}
			i status=oldStatus {
				Q 1
			}
			s rtn=..InsertTS(parref,user,loc,status)
			i rtn=0 s rtn=1
			else  s rtn=-129
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
			INSERT INTO SQLUser.Chemo_PlanDateStatus(PDS_ParRef,PDS_Status,PDS_Date,PDS_Time,PDS_User,PDS_Loc) 
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
   	
	q mRtn
}

}

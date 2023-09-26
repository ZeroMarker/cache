/// CTOR: QP
/// DATE: 2018-05-14
/// VERN: V4.1.3
/// DESC: 抗菌药物撤销功能[DHCANT-V4.1.3++ 之后版本]
Class DHCAnt.KSS.Extend.Undo Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2018-05-14
/// DESC: 医生撤销申请
/// OUT : 1：成功，0：失败
/// EXEC: w ##class(DHCAnt.KSS.Extend.Undo).UndoApply()
ClassMethod UndoApply(aaId, InHosp = "")
{
	n (aaId,InHosp,%session)
	s $ZT="Err"
	q:aaId="" 0
	q:'$d(^DHCDAA("ANT",aaId,1)) 0
	s status=$p(^DHCDAA("ANT",aaId),"^",12)
	q:status'="A" 0
	
	//开启事务
    TS
	s processInfo=$p(^DHCDAA("ANT",aaId,1),"^",36)
	s curUser=$p(^DHCDAA("ANT",aaId),"^",9) //为了兼容portal，不取session
	if processInfo["A,H" {
		//1 撤销会诊
		s cResult=..UndoConsult(aaId,curUser,InHosp)		
		i cResult'=0 {
			TROLLBACK
			q cResult	//-102 会诊撤销失败
		}
		//2 修改状态
		s aResult=..UpdateApplyStatus(aaId,"C",curUser)
		i aResult'=0 {
			TROLLBACK
			q aResult	//-101 状态修改失败
		}
		//3 增加日志	
		s lResult=..AddUndoLog(aaId,curUser,"C")
		i lResult'=0 {
			TROLLBACK
			q aResult	//-103 日志插入失败
		}
		//4 撤销消息提示(但是会诊的消息提示不是我们来做的)
		
	} else {
		//2 修改状态
		s aResult=..UpdateApplyStatus(aaId,"C",curUser)
		i aResult'=0 {
			TROLLBACK
			q aResult	//-101 状态修改失败
		}
		//3 增加日志	
		s lResult=..AddUndoLog(aaId,curUser,"C")
		i lResult'=0 {
			TROLLBACK
			q aResult	//-103 日志插入失败
		}
		//4 撤销消息提示
		s mResult=..UndoMessage(aaId,curUser,"A",InHosp)
	}
	TC 
	q 1

Err
	q 0
}

/// CTOR: QP
/// DATE: 2018-05-14
/// DESC: 修改申请状态
/// IN  : 
/// OUT : 0：成功
/// EXEC:  w ##class(DHCAnt.KSS.Extend.Undo).DBUpdateApplyStatus("")
ClassMethod UpdateApplyStatus(aaId As %String, status As %String, user As %String) As %String
{
	n (aaId,status,user)
	s Err=0
	q:aaId="" Err
	s CurrentDate=$P($h,",",1)
	s CurrentTime=$P($h,",",2)
	&sql(UPDATE SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus=:status,
 					AA_LastUpdateUser=:user,AA_LastUpdateDate=:CurrentDate,
 					AA_LastUpdateTime=:CurrentTime
 	    	where AA_Rowid=:aaId)
 	i SQLCODE'=0 s Err=SQLCODE
 	q:Err'=0 "-101"
 	q Err
}

/// CTOR: QP
/// DATE: 2018-05-14
/// DESC: 撤销会诊
/// IN  : 
/// OUT : 0：成功，-102:失败
/// EXEC:  w ##class(DHCAnt.KSS.Extend.Undo).UndoConsult("")
ClassMethod UndoConsult(aaId As %String, user As %String, InHosp = "") As %String
{
	n (aaId,user,InHosp)
	s Err=0
	s admId=$p(^DHCDAA("ANT",aaId),"^",1)
	s consultNum=##class(DHCAnt.KSS.Common.Method).GetConsultDepNums(InHosp)
	s conId1=$p(^DHCDAA("ANT",aaId,1),"^",22)
	s conId2=$p(^DHCDAA("ANT",aaId,1),"^",26)
	s conId3=$p(^DHCDAA("ANT",aaId,1),"^",29)
	s conId="",cResult=0
	f i=1:1:consultNum {
		i i=1 s conId=conId1
		i i=2 s conId=conId2
		i i=3 s conId=conId3
		q:cResult'=0
		s cResult=##Class(web.DHCEMConsInterface).CancelCstNo(conId,user)
		//q:(cResult'="")&&(cResult'=0)
		//s cResult=##class(User.DHCConsultation).ChangeStatus(conId,"C","Y",user,admId)
			
	}
	q:cResult'=0 "-102"
 	q Err
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 插入日志
/// IN  : 
/// OUT :
/// NOTE:  
/// EXEC: w ##class(DHCAnt.KSS.Extend.Undo).AddUndoLog("")
ClassMethod AddUndoLog(aaId As %String, user As %String, status As %String, action As %String = "") As %String
{
	n (aaId,user,status,action)
	
	s CurrentDate=$P($h,",",1)
	s CurrentTime=$P($h,",",2)
	i action="" s action="Undo"	//撤销
	s Err=0
	&sql(insert into DHCAnt_Base.MainLog(MLOG_Type,MLOG_Desc,MLOG_Code,
 					MLOG_ParentCode,MLOG_QuoteDR,MLOG_User,MLOG_UpdateDate,
 					MLOG_UpdateTime,MLOG_Status,MLOG_Action,MLOG_Value) 
 			values ("KSS","抗菌医生站日志","KSSPROCESS","PROCESS",:aaId,:user,
 					:CurrentDate,:CurrentTime,"SUCCESS",:action,:status))
 	i SQLCODE'=0 s Err=SQLCODE
 	q:Err'=0 "-103"
 	q Err
}

/// CTOR: QP
/// DATE: 2016-08-19
/// DESC: 撤销消息提示
/// IN  : 
/// OUT :
/// EXEC: w ##class(DHCAnt.KSS.Extend.Undo).AddUndoLog("")
ClassMethod UndoMessage(aaId As %String, user As %String, status As %String, InHosp = "") As %String
{
	n (aaId,user,status,InHosp)
	s msgTip=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("MSGTIP",InHosp)
	q:(msgTip="")||(msgTip=0) 0
	
	s ToUserId=""
	s ActionType=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("MSGTIPKSSCODE")
	s admId=$p(^DHCDAA("ANT",aaId),"^",1)
	s OEOrdItemId=""
	s ObjectId=aaId_"-"_status
	s ExecUserDr=user
	s ExecDate=+$h
	s ExecTime=$p($h,",",2)
	s result=##class(websys.DHCMessageInterface).Cancel(ToUserId,ActionType,admId,OEOrdItemId,ObjectId,ExecUserDr,ExecDate,ExecTime)
 	q result
}

}

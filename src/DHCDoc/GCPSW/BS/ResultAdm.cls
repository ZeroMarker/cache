/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 筛选结果就诊记录
Class DHCDoc.GCPSW.BS.ResultAdm Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.ResultAdm).Save()
ClassMethod Save(RID, mList)
{
	s mRtn=0
	
	s PatientID=$p(mList,"^",1)
	s admid=$p(mList,"^",2)
	s oeori=$p(mList,"^",3)
	s arcim=$p(mList,"^",4)
	
	s id=$o(^BS.DOC.GCPSW.ResultI("ResultAdm",RID,oeori,""))
	q:id'="" 0
	i id="" {
		s a=##class(User.GCPSWResultAdm).%New(RID)
		d a.PAParRefSetObjectId(RID)
		d a.PAAdmSetObjectId(admid)
		d a.PAArcimSetObjectId(arcim)
		d a.PAOeoriSetObjectId(oeori)
		s a.PAAddDate=+$h
		s a.PAAddTime=$p($h,",",2)
		
	} else {
		//s a=##class(User.GCPSWResultAdm).%OpenId(id)
		//w "UPDATE"
	}
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

}

/// CTOR: QP
/// DATE: 2020-09-23
/// DESC: 筛选结果入选Lis记录
Class DHCDoc.GCPSW.BS.ResultLis Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.BS.ResultLis).Save()
ClassMethod Save(RID, mList)
{
	s mRtn=0
	
	s oeori=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s val=$p(mList,"^",3)
	s arcim=$p(mList,"^",4)
	s id=$o(^BS.DOC.GCPSW.ResultI("ResultLis","ArcimCode",RID,arcim,code,""))
	q:id'="" 0
	i id="" {
		s a=##class(User.GCPSWResultLis).%New(RID)
		d a.PLParRefSetObjectId(RID)
		d a.PLArcimSetObjectId(arcim)
		d a.PLOeoriSetObjectId(oeori)
		s a.PLCode=code
		s a.PLVal=val
		s a.PLAddDate=+$h
		s a.PLAddTime=$p($h,",",2)
		
	} else {
		//s a=##class(User.GCPSWResultLis).%OpenId(id)
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

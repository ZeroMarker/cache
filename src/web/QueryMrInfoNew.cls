Import SQLUser

Class web.QueryMrInfoNew Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// d ##Class(web.QueryMrInfoNew).SynchronousDate()
ClassMethod SynchronousDate(type, icdGroup)
{
	n (type,icdGroup)
	//s ^TEMPDHCWL("wk","test")=type_"^"_icdGroup
	//q "ok"
	if (type="all"){
		k ^DHCWLDiagICD
		s diagGroup="DiagEmpCode18,DiagCode30,DiagCode50,SingleDiag,HarmPoison,DiagSortCode,MalTumCode16"
		job ##Class(web.QueryMrInfoNew).GetDHCWLDiagICD(diagGroup)
		s operGroup="OperEmpCode18"
		job ##Class(web.QueryMrInfoNew).GetDHCWLOperICD(operGroup)
	}else{
		if (icdGroup="OperEmpCode18"){
			d ##Class(web.QueryMrInfoNew).GetDHCWLOperICD(icdGroup)
		}else{
			d ##Class(web.QueryMrInfoNew).GetDHCWLDiagICD(icdGroup)
		}
	}
	q "ok"
}

/// d ##Class(web.QueryMrInfoNew).GetDHCWLDiagICD()
ClassMethod GetDHCWLDiagICD(paraCodeParam)
{
	n (paraCodeParam)
	//s paraCode="DiagEmpCode18,DiagCode30,DiagCode50,SingleDiag,HarmPoison,DiagSortCode,MalTumCode16"
	s paraCode=paraCodeParam
	s mID=""
	f {
		s mID=$O(^MRC("ID",mID))
		Q:mID=""
		s ICD9=$P(^MRC("ID",mID),"^",4)
		continue:ICD9=""
		s Name=$P(^MRC("ID",mID),"^",2)
		s toDate=$P(^MRC("ID",mID),"^",7)
		continue:toDate'=""
		s ICD9=$ZCVT(ICD9,"U")
		for i=1:1:$l(paraCode,","){
			s diagGrp=$P(paraCode,",",i)
			s mICDCat=##Class(web.QueryMrInfo).GetIcdCatDesc(diagGrp,ICD9)
			continue:mICDCat=""
			//w ICD9,!
			s ^DHCWLDiagICD(0,"DiagSort","Code",ICD9,diagGrp,mICDCat)=""
		}
	}
	Q
}

/// d ##Class(web.QueryMrInfoNew).GetDHCWLOperICD()
ClassMethod GetDHCWLOperICD(paraCodeParam)
{
	n (paraCodeParam)
	s diagGrp=paraCodeParam //"OperEmpCode18"
	s mID=""
	f {
		s mID=$O(^ORC("OPER",mID))
		Q:mID=""
		s ICD9=$P(^ORC("OPER",mID),"^",14)
		continue:ICD9=""
		s Name=$P(^ORC("OPER",mID),"^",2)
		s toDate=$P(^ORC("OPER",mID),"^",6)
		continue:toDate'=""
		s ICD9=$ZCVT(ICD9,"U")
		;s ^DHCWLDiagICD(0,"OperICD",ICD9,mID)=""
		s mICDCat=##Class(web.QueryMrInfo).GetIcdCatDesc(diagGrp,ICD9)
		continue:mICDCat=""
		//w ICD9,mICDCat,!
		s ^DHCWLDiagICD(0,"DiagSort","Code",ICD9,diagGrp,mICDCat)=""
	}
	Q
}

}

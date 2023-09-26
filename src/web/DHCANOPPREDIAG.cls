Class web.DHCANOPPREDIAG Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 24;

ClassMethod MDiagnos(Adm, typ) As %String
{
  n (Adm,typ)
  s i=0
  //i typ="M" s typ="C008"
  s count=0
  s mradm=$P(^PAADM(Adm),"^",61)
  s retIcdId="",diagdes="",newDiagStr=""
  	 s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
  	 s flag=0
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.q:flag=1
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.q:curDigType'="入院诊断"
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.q:curDigMainFlag'="Y"
		.s newDiagStr=curDigId_"^"_curDigDesc
		.s flag=1


  /*
  //w ! ,mradm
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")!(i=1)  d
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .q:icddr=""
	  .q:$P(^MR(mradm,"DIA",mcl,1),"^",20)'="Y"	;不是主诊断的pass+20161009
	  .
	  .s count=count+1
	  .i (icddr'="")&(count=1)  d
	  	..s retIcdId=icddr
	  	..s diagdes=$P(^MRC("ID",icddr),"^",2)
	  .;e  d
	  .;.s diagdes=$g(^MR(mradm,"DIA",mcl,"DES",1))
	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")!(i=1)   d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp'=typ
		  ..q:diagtyp="DIS"
		  ..s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
		  ..q:icddr=""
		  ..s retIcdId=icddr
		  ..s diagdes=$P(^MRC("ID",icddr),"^",2)
		  ..s i=i+1 
		  */
  q newDiagStr
}

// 获取最近一次诊断

ClassMethod LastMDiagnos(Adm, typ) As %String
{
  n (Adm,typ)
  s i=0
  s mradm=$P(^PAADM(Adm),"^",61)
  s retIcdId=""
  s retIcdId=$o(^MR(mradm,"DIA",""),-1)
 
  s diagdes=$P($g(^MRC("ID",retIcdId)),"^",2)
  q $G(retIcdId)_"^"_$G(diagdes)
}

ClassMethod modifysaf(anrw, loguser) As %String
{
  //如果登记完成,则不允许其他人修改
	s finuser=$P(^DHCANOPArrange(anrw),"^",9)
	s stat=$P(^DHCANOPArrange(anrw),"^",27)
	s flag=0
	if ((stat="F")!(stat="N"))&(finuser'=loguser)
	{
	  s flag=1
	  	
	}
	else
	{
		s flag=0
	}
  q $G(flag)
}

ClassMethod GetAllMDiagnos(Adm) As %String
{
  n (Adm)
  q:Adm="" ""
  s i=0
  //s mainDiag=..MDiagnos(Adm, "M")
  ;获取从诊断
  s diagdes="",DiagStr=""
  s mradm=$P(^PAADM(Adm),"^",61)
  s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.q:curDigType="出院诊断"
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.q:curDigMainFlag="Y"
		.i DiagStr'="" s DiagStr=DiagStr_"$"_curPreFix_curDigDesc_"|"_curDigNote
		.e  s DiagStr=curPreFix_curDigDesc_"|"_curDigNote

  /*
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")!(i=1)   d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp="DIS"
		  ..s i=i+1
  .i icddr'=""  d
	  ..;s ^tmpYpz("diag1")=icddr
	  ..q:+icddr=+mainDiag
	  ..i diagdes'="" s diagdes=diagdes_","_$P(^MRC("ID",icddr),"^",2)
	  ..e  s diagdes=$P(^MRC("ID",icddr),"^",2)
  .e  d
	  ..;s ^tmpYpz("diag2")=icddr
	  ..i diagdes'="" s diagdes=diagdes_","_$g(^MR(mradm,"DIA",mcl,"DES",1))
	  ..e  s diagdes=$g(^MR(mradm,"DIA",mcl,"DES",1))
	  */
  q DiagStr
}

}

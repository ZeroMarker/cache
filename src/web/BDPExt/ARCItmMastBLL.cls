/// Description：单独医嘱项导入程序
/// Creator：chenying
/// CreatDate: 2020-03-20
Class web.BDPExt.ARCItmMastBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：单独医嘱项导入保存接口
/// Creator：ybq
/// CreatDate: 2019-2-16
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'ARCIMRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.ARCItmMastBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.ARCItmMastEntity) As %String
{
	n (%session,Ceobj)
	s ImportResult=""
	s arcimeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItmMast")
	s arcimhospeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItemHosp")
	Tstart		
			
	s arcimeobj.ARCIMRowId=""
	s ARCIMSaveResult=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(arcimeobj)	
	s myARCIMRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCIMSaveResult)	
	if (myARCIMRowId'="")
	{
		///医嘱项别名
		if Ceobj.ALIASText'=""
		{
			s aliaseobj=##class(web.Entity.CT.ARCAlias).%New()
			s aliaseobj.ALIASARCIMDR=myARCIMRowId
			s aliaslength=$l(Ceobj.ALIASText,"/")
			
			for i=1:1:aliaslength
			{	
				if ($p(Ceobj.ALIASText,"/",i)'="")
				{
					s aliaseobj.ALIASText=$p(Ceobj.ALIASText,"/",i)	
					s aliaseobj.ALIASDateFrom=Ceobj.ARCIMEffDate //2019-02-24
					s aliaseobj.ALIASDateTo=Ceobj.ARCIMEffDateTo
					d ##class(web.DHCBL.CT.ARCAlias).SaveEntity(aliaseobj)
				}
			}
		}
		/*
		s hosplength=$l(Ceobj.LinkHospId,"/")
		for i=1:1:hosplength 
		{
			s HospRowId=$p(Ceobj.LinkHospId,"/",i)
			if HospRowId'=""
			{	
				s arcimhospeobj.HOSPHospitalDR=HospRowId
				s arcimhospeobj.HOSPParRef=myARCIMRowId
				s ARCIMHospSaveResult=##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(arcimhospeobj)
				s myARCIMHospRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCIMHospSaveResult)
				if (myARCIMHospRowId="")
				{
					s ImportResult="医嘱项关联医院:"_ARCIMHospSaveResult
				}
			}
		}*/
	}
	else
	{
		s ImportResult="医嘱项:"_ARCIMSaveResult	
	}
	if (ImportResult="")
	{
		Tcommit
		s ImportResult="{success:'true',id:'"_myARCIMRowId_"'}" 
	}
	else
	{
		Trollback
		if ($g(myARCIMRowId)'="")&&($g(myARCIMRowId)>0)
		{
			if ($D(^ARCIM(myARCIMRowId,1,1))=0)&&($D(^ARCIM(myARCIMRowId,1))>0)
			{
				k ^ARCIM(myARCIMRowId)	
			}
		}
		
	}
	
	q ImportResult
}

/// Creator:ybq
/// CreatDate:2019-1-30
/// Description:通过医嘱项rowid获取所属医院
/// w ##class(web.BDPExt.ARCItmMastBLL).GetHospitalRowId(1,1)
ClassMethod GetHospitalRowId(ARCIMSubscript, ARCIMVersion) As %String
{
	n (ARCIMSubscript,ARCIMVersion)
	s childsub=0,HospitalStr=""
	for
	{
		s childsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",childsub)) 
		q:childsub=""
		s HospitalDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"HOSP",childsub)),"^",1)
		if (HospitalDR'=""){
			s HospitalDR=$p($g(^CT("HOSP",HospitalDR)),"^",2)
			s:HospitalStr'="" HospitalStr=HospitalStr_"/"_HospitalDR
			s:HospitalStr="" HospitalStr=HospitalDR
		}
	}
	q HospitalStr
}

/// Creator:ybq
/// CreatDate:2019-1-30
/// Description:通过医嘱项rowid获取外部代码
/// w ##class(web.BDPExt.ARCItmMastBLL).GetExternalCodes(5,1)
ClassMethod GetExternalCodes(ARCIMSubscript, ARCIMVersion) As %String
{
	n (ARCIMSubscript,ARCIMVersion)
	s childsub=0,ExternalCodesStr=""
	for
	{
		s childsub=$o(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",childsub)) 
		q:childsub=""
		s EXTCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",childsub)),"^",4)
		s EXTDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,"EXT",childsub)),"^",4)
		if (EXTCode'=""){
			s:ExternalCodesStr'="" ExternalCodesStr=ExternalCodesStr_"/"_EXTCode_","_EXTDesc
			s:ExternalCodesStr="" ExternalCodesStr=EXTCode_","_EXTDesc
		}
	}
	q ExternalCodesStr
}

}

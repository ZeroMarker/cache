/// Description：医嘱项导入程序
/// Creator：陈莹
/// CreatDate: 2016-10-18
Class web.BDPExt.YXZBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// update2020-02-11
/// Description：医嘱项导入保存接口
/// Creator：陈莹
/// CreatDate: 2016-10-18
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'ARCIMRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.YXZBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.YZXEntity) As %String
{
	n (%session,Ceobj)
	s $zt="ERROR"
	s ImportResult=""
	
	s:Ceobj.TARIStartDate="" Ceobj.TARIStartDate=Ceobj.ARCIMEffDate  //2019-02-24
	s:Ceobj.TPStartDate="" Ceobj.TPStartDate=Ceobj.TARIStartDate  //2019-02-24
	s:Ceobj.OLTStartDate="" Ceobj.OLTStartDate=Ceobj.TARIStartDate  //2019-02-24
	
	s myTARIRowId="",myARCIMRowId=""
	
	s:Ceobj.OLTQty="" Ceobj.OLTQty="1" 
	s:Ceobj.TARIActiveFlag="" Ceobj.TARIActiveFlag="Y"
	s:Ceobj.TARICode="" Ceobj.TARICode=Ceobj.ARCIMCode
	s:Ceobj.TARIDesc="" Ceobj.TARIDesc=Ceobj.ARCIMDesc
	s arcimeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.ARCItmMast")
	s tarieobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItem")
	s olteobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCOrderLinkTar")	
	s tpeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.DHCTarItemPrice")

	Tstart		
			
	///医嘱项
	s myARCIMRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("ARC_ItmMast",Ceobj.ARCIMCode,Ceobj.LinkHospId) ///已存在的医嘱项跳过
	if (myARCIMRowId="")
	{
		s arcimeobj.ARCIMRowId=""
		s arcimeobj.LinkHospId=Ceobj.LinkHospId
		s ARCIMSaveResult=##class(web.DHCBL.CT.ARCItmMast).SaveEntity(arcimeobj)	
		s myARCIMRowId=##class(web.BDPExt.FunLib).GetResultRowId(ARCIMSaveResult)
	}
	
	if (myARCIMRowId'="")
	{
	
		///收费项目
		s myTARIRowId=##class(web.DHCBL.BDP.BDPDataImport).GetRowIdByCode("DHC_TarItem",Ceobj.TARICode,Ceobj.LinkHospId)  ///已存在的收费项跳过
		s TARISaveResult=""
		if (myTARIRowId'="")
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
			///医嘱项医院 2020-06-13
			if Ceobj.LinkHospId'=""
			{
				s hospeobj=##class(web.Entity.CT.ARCItemHosp).%New()
				s hospeobj.HOSPParRef=myARCIMRowId
				s length=$l(Ceobj.LinkHospId,"/")
				
				for hospi=1:1:length
				{	
					s hospeobj.HOSPHospitalDR=$p(Ceobj.LinkHospId,"/",hospi)
					d:hospeobj.HOSPHospitalDR'="" ##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(hospeobj)
					
				}
			}
			///收费项目别名
			if Ceobj.ALIASText'=""
			{
		
				s aliaslength=$l(Ceobj.TIAAlias,"/")
				for i=1:1:aliaslength
				{
					s tiaeobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
					s tiaeobj.TIATARIDR=myTARIRowId
					s tiaeobj.TIAAlias=$p(Ceobj.TIAAlias,"/",i)	
					if ($p(Ceobj.TIAAlias,"/",i)'="")
					{
						d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(tiaeobj)
					}
				}
			}
			
			///医嘱项与收费项目关联
			s olteobj.OLTARCIMDR=myARCIMRowId
			s olteobj.OLTTariffDR=myTARIRowId
			s OLTSaveResult=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(olteobj,"Y")

			s OLTRowId=##class(web.BDPExt.FunLib).GetResultRowId(OLTSaveResult)
			i (OLTRowId'="")
			{
				s HospFlag=0
				s TPChildSub=""
				for
				{
					s TPChildSub=$o(^DHCTARI(myTARIRowId,"P",TPChildSub),-1)  q:(TPChildSub=0)||(TPChildSub="")
					s TPRowId=myTARIRowId_"||"_TPChildSub
					s TPHospitalDR=$p($g(^DHCTARI(myTARIRowId,"P",TPChildSub)),"^",16)
					if TPHospitalDR=Ceobj.LinkHospId s HospFlag=1
				}
				if (HospFlag=0)
				{
					//如果当前医院一个价格都没有，就新增价格。2020-06-13
					s tpeobj.TPTARIParRef=myTARIRowId
					s tpeobj.TPPatInsType=Ceobj.TPPatInsType
					s tpeobj.TPHospitalDR=Ceobj.LinkHospId
					s TPSaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(tpeobj,"Y") 
		
					s TPRowId=##class(web.BDPExt.FunLib).GetResultRowId(TPSaveResult)
					i (TPRowId="")
					{
						s ImportResult="收费项目价格:"_TPSaveResult				
					}
				}
			}
			else
			{
				s ImportResult="医嘱项与收费项目关联:"_OLTSaveResult				
			}
			
		}
		else
		{
			s tarieobj.TARIRowId=""
			s tarieobj.LinkHospId=Ceobj.LinkHospId
			s TARISaveResult=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(tarieobj)  
			s myTARIRowId=##class(web.BDPExt.FunLib).GetResultRowId(TARISaveResult)
		
			if (myTARIRowId'="")
			{
				///收费项目价格
				s tpeobj.TPTARIParRef=myTARIRowId
				s tpeobj.TPPatInsType=Ceobj.TPPatInsType
				s tpeobj.TPHospitalDR=Ceobj.LinkHospId
				s TPSaveResult=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(tpeobj,"Y") 
			
				s TPRowId=##class(web.BDPExt.FunLib).GetResultRowId(TPSaveResult)
				i (TPRowId'="")
				{
					///医嘱项与收费项目关联
					s olteobj.OLTARCIMDR=myARCIMRowId   ///校验重复
					s olteobj.OLTTariffDR=myTARIRowId
					s OLTSaveResult=##class(web.DHCBL.CT.DHCOrderLinkTar).SaveEntity(olteobj,"Y")
	
					s OLTRowId=##class(web.BDPExt.FunLib).GetResultRowId(OLTSaveResult)
					i (OLTRowId'="")
					{
						///医嘱项别名
						if Ceobj.ALIASText'=""
						{
							s aliaseobj=##class(web.Entity.CT.ARCAlias).%New()
							s aliaseobj.ALIASARCIMDR=myARCIMRowId
							s aliaslength=$l(Ceobj.ALIASText,"/")
							for i=1:1:aliaslength
							{	
								s aliaseobj.ALIASText=$p(Ceobj.ALIASText,"/",i)	
								s aliaseobj.ALIASDateFrom=Ceobj.ARCIMEffDate //2019-02-24
								s aliaseobj.ALIASDateTo=Ceobj.ARCIMEffDateTo
								d ##class(web.DHCBL.CT.ARCAlias).SaveEntity(aliaseobj)
							}	
						}
						///医嘱项医院 2020-06-13
						if Ceobj.LinkHospId'=""
						{
							s hospeobj=##class(web.Entity.CT.ARCItemHosp).%New()
							s hospeobj.HOSPParRef=myARCIMRowId
							s length=$l(Ceobj.LinkHospId,"/")
							
							for hospi=1:1:length
							{	
								s hospeobj.HOSPHospitalDR=$p(Ceobj.LinkHospId,"/",hospi)
								d:hospeobj.HOSPHospitalDR'="" ##class(web.DHCBL.CT.ARCItemHosp).SaveEntity(hospeobj)
								
							}
						}
					
						///收费项目别名
						if Ceobj.ALIASText'=""
						{
							s tiaeobj=##class(web.Entity.CT.DHCTarItemAlias).%New()
							s tiaeobj.TIATARIDR=myTARIRowId
							s tiaeobj.TIAAlias=$p(Ceobj.TIAAlias,"/",i)	
							d ##class(web.DHCBL.CT.DHCTarItemAlias).SaveEntity(tiaeobj)
						}
					}
					else
					{
						s ImportResult="医嘱项与收费项目关联:"_OLTSaveResult				
					}
				}
				else
				{
					s ImportResult="收费项目价格:"_TPSaveResult				
				}
			
			}	
			else
			{
				s ImportResult="收费项目:"_TARISaveResult			
			}		
		}
	
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
	}
	
	q ImportResult
ERROR
	Q "导入报错"_$ZE
}

/// Creator:陈莹
/// CreatDate:2017-07-13
/// Description:通过医嘱项rowid获取医嘱项别名
/// w ##class(web.DHCBL.CT.ARCItmMast).GetAliasByRowId("1","1")
ClassMethod GetAliasByRowId(ARCIMSubscript, ARCIMVersion) As %String
{
	n (ARCIMSubscript,ARCIMVersion)
	s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
	s ALIASRowId=0,ALIASText1=""
	for
	{
		s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ARCIMRowId,ALIASRowId))
		q:(ALIASRowId="")
		s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
		s:ALIASText1'="" ALIASText1=ALIASText1_"/"_ALIASText
		s:ALIASText1="" ALIASText1=ALIASText
	}
	q ALIASText1
}

/// Creator:陈莹
/// CreatDate:2017-07-13
/// Description:通过收费项代码获取收费项别名
/// w ##class(web.DHCBL.CT.DHCTarItem).GetTarAliasByRowId("1")
ClassMethod GetTarAliasByRowId(id) As %String
{
	n (id)
	s ALIASText1=""
	s TIARowId=0
	for
	{
		s TIARowId=$o(^DHCTARAL("A",id,TIARowId))  q:TIARowId=""
		s TIAAlias=$p($g(^DHCTARAL(TIARowId)),"^",3)
		s:ALIASText1'="" ALIASText1=ALIASText1_"/"_TIAAlias
		s:ALIASText1="" ALIASText1=TIAAlias
	}
	q ALIASText1
}

/// Creator:ybq
/// CreatDate:2019-1-30
/// Description:通过医嘱项rowid获取所属医院
/// w ##class(web.BDPExt.YXZBLL).GetHospitalRowId("1","1")
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
/// w ##class(web.BDPExt.YXZBLL).GetExternalCodes("5","1")
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

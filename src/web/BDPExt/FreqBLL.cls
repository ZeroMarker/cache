Class web.BDPExt.FreqBLL Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：频次+分发时间导入保存接口
/// Creator：陈莹
/// CreatDate: 2017-03-10
/// Input：通过Ceobj传参
/// Return:保存成功时返回 "{success:'true',id:'PHCFRRowId'}"   保存失败时返回错误信息
/// debug: w ##class(web.BDPExt.FreqBLL).SaveEntity(eobj)
ClassMethod SaveEntity(Ceobj As web.BDPExt.FreqEntity) As %String
{
	n (Ceobj,%session)
	s ImportResult="",RetResult=""
	s Ceobj.PHCFRIntervalUom=$case(Ceobj.PHCFRIntervalUom,"天":"D","小时":"H",:Ceobj.PHCFRIntervalUom)
	Ts
	///频次
	s PHCFRRowId=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Ceobj.PHCFRCode),0))
	if (PHCFRRowId="")
	{
		s freqeobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PHCFreq")
		s PHCFRSaveResult=##class(web.DHCBL.CT.PHCFreq).SaveEntity(freqeobj)
		s PHCFRRowId=##class(web.BDPExt.FunLib).GetResultRowId(PHCFRSaveResult)
		if (PHCFRRowId'="")
		{
			///分发时间
			IF Ceobj.PHCDTTime'=""
			{
				s Ceobj.PHCDTTime=$tr(Ceobj.PHCDTTime,"：",":")   //2017-04-10
				s lengthtime=$l(Ceobj.PHCDTTime,"/")
				s errortimeflag=0
				s i=0
				s PHCDTSaveResult=""
				for 
				{
					s i=i+1 q:(i>lengthtime)||(errortimeflag=1)
					s phcdtobj=##class(web.Entity.CT.PHCDispensingTime).%New()
					s phcdtobj.PHCDTPHCFRParRef=PHCFRRowId
					s phcdtobj.PHCDTRowId=""
					s phcdtobj.PHCDTTime=$p(Ceobj.PHCDTTime,"/",i)
					s phcdtobj.PHCDTTimeDesc=$p(Ceobj.PHCDTTimeDesc,"/",i)
					s PHCDTSaveResult=##class(web.DHCBL.CT.PHCDispensingTime).SaveEntity(phcdtobj)
					s PHCDTRowId=##class(web.BDPExt.FunLib).GetResultRowId(PHCDTSaveResult)
					if (PHCDTRowId="")
					{
						s errortimeflag=1			
					}	
					
				}
				if (errortimeflag=1)
				{
					s ImportResult="分发时间:"_PHCDTSaveResult				
				}
			}
		}
		else
		{
			s ImportResult="频次:"_PHCFRSaveResult	
		}
	}
	else
	{
		s ImportResult="频次:该代码已存在，校验失败"	
	}
	
	if (ImportResult="")
	{
		Tc
		s RetResult="{success:'true',id:'"_PHCFRRowId_"'}" 
	}
	else
	{
		Tro
		s PHCFRRowId=$o(^PHCFR(""),-1)
		IF (PHCFRRowId'="")&&(PHCFRRowId'=0)
		{
			if ($D(^PHCFR(PHCFRRowId))=10) k ^PHCFR(PHCFRRowId)
		}
		s RetResult=ImportResult
	}
	q RetResult
}

/// Creator:陈莹
/// CreatDate:2019-05-10
/// Description:获取对应的代码，名称的值
/// w ##class(web.BDPExt.FreqBLL).GetValueByPropertyName("5","PHCDTTime")
/// w ##class(web.BDPExt.FreqBLL).GetValueByPropertyName("5","PHCFRClinicType")
ClassMethod GetValueByPropertyName(PHCFRRowId, PropertyName) As %String
{
	n (PHCFRRowId,PropertyName)
	s value=""
	if PropertyName="PHCDTTime"
	{
		s PHCDTChildSub=0
		for
		{
			s PHCDTChildSub=$o(^PHCFR(PHCFRRowId,"DT",PHCDTChildSub)) q:PHCDTChildSub=""
			s PHCDTTime=$g(^PHCFR(PHCFRRowId,"DT",PHCDTChildSub))
			i (PHCDTChildSub>0)&&(PHCDTTime'="")
			{
				s PHCDTTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(PHCDTTime)
				if value=""
				{
					s value=PHCDTTime
					
				}
				else
				{
					s value=value_"/"_PHCDTTime
				}
				
			}
		}
	}
	if PropertyName="PHCFRClinicType"
	{
		s PHCFRClinicType = $p($g(^PHCFR(PHCFRRowId)),"^",7)         ;就诊类型
		//就诊类型 (门诊,急诊,住院,体检,新生儿) 20170612
		if PHCFRClinicType'=""
		{
			s PHCFRClinicTypeDesc=""
			if PHCFRClinicType["O"
			{
				s PHCFRClinicTypeDesc="门诊"
			}
			else
			{
				s PHCFRClinicTypeDesc=""
			}
			if PHCFRClinicType["E"
			{
				if PHCFRClinicTypeDesc=""
				{
					s PHCFRClinicTypeDesc="急诊"
				}
				else
				{
					s PHCFRClinicTypeDesc=PHCFRClinicTypeDesc_"，"_"急诊"
					
				}
			}
			
			if PHCFRClinicType["I"
			{
				if PHCFRClinicTypeDesc=""
				{
					s PHCFRClinicTypeDesc="住院"
				}
				else
				{
					s PHCFRClinicTypeDesc=PHCFRClinicTypeDesc_"，"_"住院"
					
				}
			}
			
			if PHCFRClinicType["H"
			{
				if PHCFRClinicTypeDesc=""
				{
					s PHCFRClinicTypeDesc="体检"
				}
				else
				{
					s PHCFRClinicTypeDesc=PHCFRClinicTypeDesc_"，"_"体检"
					
				}
			}
			if PHCFRClinicType["N"
			{
				if PHCFRClinicTypeDesc=""
				{
					s PHCFRClinicTypeDesc="新生儿"
				}
				else
				{
					s PHCFRClinicTypeDesc=PHCFRClinicTypeDesc_"，"_"新生儿"
					
				}
			}
			s PHCFRClinicType=PHCFRClinicTypeDesc
		}
		else
		{
			s PHCFRClinicType="门诊，急诊，住院，体检，新生儿"
		}
		s value=PHCFRClinicType
	}
	q value
}

}

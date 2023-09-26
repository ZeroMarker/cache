/// Description:数据工厂导出相关数据到global
/// Creator：李得原
/// Date： 2019-01-04
Class web.DHCBL.MKB.MKBStructedDiag Extends %RegisteredObject
{

Property Path As %String [ InitialExpression = "D:\工作\2019-04-15\" ];

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportData()
ClassMethod ExportData()
{
	k loc
	k fre
	s MKBMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	b:MKBMBRowId=""
	
	s Diagchild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 诊断",0))
	s Frechild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 频次",0))
	s LocChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 科室",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum))
		q:RowNum=""
		
		;s LocMDRowID=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum,0))
		s LocMDRowID=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_LocChild,0))
		s LocTermID=$LG($G(^User.MKBKLMappingDetailD(LocMDRowID)),2)
		s LocDesc = $LG($G(^User.MKBTermD(LocTermID)),3)
		s loc(LocDesc,RowNum)=""
	}
	s num=0
	s locDesc=""
	for
	{
		s locDesc=$O(loc(locDesc))
		q:locDesc=""
		k fre
		s path="D:\loc\"_locDesc_".csv"
		s file=##class(%File).%New(path)
		d file.Open("NWS")
		//Excel名
		d file.Write("中心词"_","_"频次")
		d file.WriteLine()
		s RowNum=0
		for
		{	
			s RowNum = $O(loc(locDesc,RowNum))
			q:RowNum=""
			
			s DiagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_Diagchild,0))
			s DiagDescId = $LG($G(^User.MKBKLMappingDetailD(DiagMDRowId)),2)
			s DiagDesc = $LG($G(^User.MKBTermD(DiagDescId)),3)
			 
			
			s FreMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_Frechild,0))
			s Fre = $LG($G(^User.MKBKLMappingDetailD(FreMDRowId)),2)
			s num=num+1
			s fre(Fre,DiagDesc)=""
			
		}
		s f=""
		for
		{
			s f=$o(fre(f),-1)
			q:f=""
			s d=""
			for
			{
				s d=$o(fre(f,d))
				q:d=""
				d file.Write(d_","_f)
				d file.WriteLine()
			}
		}
		d file.%Save()
		d file.%Close()
	}
	q num
}

/// 数据处理工厂中语料库来源数据删除
/// d ##class(web.DHCBL.MKB.MKBStructedDiag).DataSturctDeal()
ClassMethod DataSturctDeal()
{
	TS
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDDiaSource=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),10)
		if (MKBSDDiaSource="语料库")
		{
			s MKBSDRChild=0
			for
			{
				s MKBSDRChild=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild))
				q:MKBSDRChild=""
				
				s result = ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(MKBSDRowId_"||"_MKBSDRChild)	
				b:result["error"			
			}
			s sc = ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId)
			b:$$$ERROR(sc)
						
		}
		elseif (MKBSDDiaSource="语料库&语料库")
		{
			s MKBSDRChild=0
			for
			{
				s MKBSDRChild=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild))
				q:MKBSDRChild=""
				
				s result = ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(MKBSDRowId_"||"_MKBSDRChild)	
				b:result["error"			
			}
			s sc = ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId)
			b:$$$ERROR(sc)	
		}
		elseif (MKBSDDiaSource["&语料库")
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			s obj.MKBSDDiaSource = $REPLACE(MKBSDDiaSource,"&语料库","")
			s obj.MKBSDMRCDr=""
			s obj.MKBSDAlias=""
			d obj.%Save()	
		}
		else
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			s obj.MKBSDMRCDr=""
			d obj.%Save()	
		}		
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertMRCRowidToHISICD()
ClassMethod InsertMRCRowidToHISICD()
{
	Ts
	s sum=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s obj=##class(User.MKBHISICDContrast).%New()
		d obj.MKBHISICDDrSetObjectId(MRCRowid)
		s obj.MKBHISICDConStatus="N"
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s sum=sum+1
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; error
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-11
/// Description:通过ICD对照界面的描述和ICD编码对HISICD对照界面数据进行结构化
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoStructHISICDByICD()
ClassMethod AutoStructHISICDByICD()
{
	Ts
	s a=0
	s sum=0
	s kong=0
	s HISICDRowid=0
	for
	{
		s HISICDRowid=$o(^User.MKBHISICDContrastD(HISICDRowid))
		q:HISICDRowid=""
		s MRCRowid=$lg($g(^User.MKBHISICDContrastD(HISICDRowid)),2)
		s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
		s MRCICD=$p(^MRC("ID",MRCRowid),"^",4)

		s ICDRowid=0
		for
		{
			s ICDRowid=$o(^User.MKBICDContrastD(ICDRowid))
			q:ICDRowid=""
			s ICDCode=$lg($g(^User.MKBICDContrastD(ICDRowid)),4)
			s ICDDesc=$lg($g(^User.MKBICDContrastD(ICDRowid)),3)
			if (ICDCode=MRCICD)&(MRCDesc=ICDDesc)
			{
				s MKBICDWord=""
				s MKBICDUser=""
				s MKBICDInital=""
				s MKBICDStatus=""
				s MKBICDRemark=""
				s MKBICDSeg=""
				s MKBICDDate=""
				s MKBICDWord=$lg($g(^User.MKBICDContrastD(ICDRowid)),5)
				s MKBICDTermdr=$lg($g(^User.MKBICDContrastD(ICDRowid)),6)
				s MKBICDRemark=$lg($g(^User.MKBICDContrastD(ICDRowid)),7)
				s MKBICDSeg=$lg($g(^User.MKBICDContrastD(ICDRowid)),8)
				s MKBICDStatus=$lg($g(^User.MKBICDContrastD(ICDRowid)),9)
				s MKBICDDate=$lg($g(^User.MKBICDContrastD(ICDRowid)),10)
				s MKBICDUser=$lg($g(^User.MKBICDContrastD(ICDRowid)),11)
				s MKBICDOther=$lg($g(^User.MKBICDContrastD(ICDRowid)),12)
				s MKBICDInital=$lg($g(^User.MKBICDContrastD(ICDRowid)),13)
				s obj=##class(User.MKBHISICDContrast).%OpenId(HISICDRowid)
				d obj.MKBHISICDConCenterWordIDSetObjectId(MKBICDWord)
				s obj.MKBHISICDConDate=MKBICDDate
				s obj.MKBHISICDConSegmentation=MKBICDSeg
				s obj.MKBHISICDConStatus=MKBICDStatus
				d obj.MKBHISICDConUpdateUserSetObjectId(MKBICDUser)
				s obj.MKBHISICDInitialICD=MKBICDInital
				s obj.MKBHISICDOther=MKBICDOther
				d obj.MKBHISICDTermDrSetObjectId(MKBICDTermdr)
				s obj.MKBHISICDRemark=MKBICDRemark
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s sum=sum+1
				}
				else
				{
					set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
					b ; error
				}
				s MKBICDResultRowid=0
				for
				{
					s MKBICDResultRowid=$o(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",MKBICDResultRowid))
					q:MKBICDResultRowid=""
					s MKBICDResultOther=""
					s MKBHISICDConResultID=""
					s MKBHISICDConSupplement=""
					s MKBICDResultTermdr=""
					s MKBICDResultId=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",MKBICDResultRowid)),2)
					s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",MKBICDResultRowid)),4)
					s MKBICDResultSupple=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",MKBICDResultRowid)),5)
					s MKBICDResultOther=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",MKBICDResultRowid)),6)
					s sobj=##class(User.MKBHISICDContrastResult).%New(HISICDRowid)
					d sobj.MKBHISICDContrastSetObjectId(HISICDRowid)
					d sobj.MKBHISICDConOtherSetObjectId(MKBICDResultOther)
					s sobj.MKBHISICDConResultID=MKBICDResultId
					s sobj.MKBHISICDConSupplement=MKBICDResultSupple
					d sobj.MKBHISICDConTermDrSetObjectId(MKBICDResultTermdr)
					if (MKBICDStatus="Y")&(MKBICDResultId="")&(MKBICDResultTermdr="")
					{
						b
						s kong=kong+1
					}
					s ssc=sobj.%Save()
					d sobj.%Close()
					if $$$ISOK(ssc)
					{
						
					}
					else
					{
						set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ; error
					}
					
				}
				
			}
		}
	}
	w a,!


	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-11
/// Description:通过ICD对照界面的描述和ICD编码对HISICD对照界面数据进行结构化
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).SetInitICDBySameDesc()
/// HISICD对照界面诊断名和结构化结构描述一致的，设置为初始ICD
ClassMethod SetInitICDBySameDesc()
{
	Ts
	s sum=0
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBHISICDContrastResultI("ExpsIndex",MKBTRowid))
		q:MKBTRowid=""
		s MKBHISICDRowid=0
		for
		{
			s MKBHISICDRowid=$o(^User.MKBHISICDContrastResultI("ExpsIndex",MKBTRowid,-100000000000000,MKBHISICDRowid))
			q:MKBHISICDRowid=""
			
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s MKBSDStructResult=$p(strCom,"&%",1) //诊断常用名
			s MRCRowid=$lg($g(^User.MKBHISICDContrastD(MKBHISICDRowid)),2)
			s MRCDesc=$P(^MRC("ID",MRCRowid),"^",2)
			if MRCDesc=MKBSDStructResult
			{
				s obj=##class(User.MKBHISICDContrast).%OpenId(MKBHISICDRowid)
				s obj.MKBHISICDInitialICD="Y"
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s sum=sum+1
				}
				else
				{
					set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
					b ; error
				}
			}
			
		}
		
		
	}
	q sum
}

/// 安贞与国际码匹配情况
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).AnzhenICDWithNation()
ClassMethod AnzhenICDWithNation()
{
	TS
		
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		s MKBICHisNum=$LG($G(^User.MKBICDContrastD(MKBICRowId)),4)
		s MKBICHISDesc=$LG($G(^User.MKBICDContarstD(MKBICRowId)),3)	
		
		if ((MKBICHisNum=0)||(MKBICHisNum="")) ///分词为空
		{
			s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
			s obj.MKBICDRemark = "N"
			s sc1=obj.%Save()
			b:$$$ERROR(sc1)	
		}
		else
		{
			s tempICD = $E(MKBICHisNum,1,5)
			if ($D(^User.MKBTermI("DescIndex",MKBTBRowId," "_tempICD))'=0) //存在对应国际编码
			{
				s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_tempICD,0))
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				
				if (MKBTPDDesc=MKBICHISDesc)
				{
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDRemark = "Y"
					d obj.MKBICDTermDrSetObjectId(MKBTRowId)
					s sc2=obj.%Save()
					b:$$$ERROR(sc2)		
				}
				else
				{
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDRemark = "F"
					d obj.MKBICDTermDrSetObjectId(MKBTRowId)
					s sc3=obj.%Save()
					b:$$$ERROR(sc3)		
				}
			}
			else
			{
				s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDRemark = "N"
					s sc4=obj.%Save()
					b:$$$ERROR(sc4)			
			}
		}
	}
}

/// 将与数据处理工厂诊断分词结果相同的安贞icd结构化
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).StructViaDataFactory()
ClassMethod StructViaDataFactory()
{
	TS
	s num=0
	s segm = ""
	for
	{
		s segm = $O(^User.MKBICDContrastI("SegmIndex",segm))
		q:segm=""	
		continue:segm=-100000000000000
		
		if ($D(^User.MKBStructuredDataI("SegmIndex"," "_segm))'=0)
		{
			s num=num+1
			s MKBICRowId = $O(^User.MKBICDContrastI("SegmIndex",segm,0))
			b:MKBICRowId=""
			
			s MKBSDRowId = $O(^User.MKBStructuredDataI("SegmIndex"," "_segm,0))
			b:MKBSDRowId=""
			
			s MKBSDChild=0
			for
			{
				s MKBSDChild = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild))
				q:MKBSDChild=""
							
				s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
				d cobj.MKBICDConPropertyDrSetObjectId($LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),4))
				s cobj.MKBICDConResult = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),3)
				s cobj.MKBICDConResultID = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),2)
				s cobj.MKBICDConSupplement = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),5)
				s csc=cobj.%Save()
				b:$$$ERROR(csc)
			}		
		}
		
	}
	w "安贞hisICD中文释义分词结果与数据处理工厂数据相同："_num,!
}

/// 通过北京版icd对照结构化安贞icd数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).StructViaBeijing()
ClassMethod StructViaBeijing()
{
	TS
	s num=0
	s num1=0
	s num2=0
	s MKBMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 北京版ICD对照",0))
	s MKBMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 中文释义",0))
	s MKBMFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 诊断",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum))	
		q:RowNum=""
		
		s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild,0))
		s BJRowId = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
		b:BJRowId=""
		
		s BJDesc = $LG($G(^User.MKBTermD(BJRowId)),3)
		s BJPRowId=$O(^User.MKBTermPropertyI("DescIndex",BJRowId," ICD编码",0))
		s BJPDRowId=$O(^User.MKBTermProDetailI("ProIdx",BJPRowId,0))
		b:BJPDRowId=""
		s BJCode = $LG($G(^User.MKBTermProDetailD(BJPDRowId)),3)
		b:BJCode=""
		
		if ($D(^User.MKBICDContrastI("NumberIndex"," "_$ZCONVERT(BJCode,"U")))'=0)
		{
			s MKBICRowId=0
			for
			{
				s MKBICRowId=$O(^User.MKBICDContrastI("NumberIndex"," "_BJCode,MKBICRowId))	
				q:MKBICRowId=""
				
				s num=num+1
				
				s MKBICDDesc = $LG($G(^User.MKBICDContrastD(MKBICRowId)),3)
				if (BJDesc=MKBICDDesc)
				{
					s num1=num1+1
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDOther = "同码同义"
					s sc1=obj.%Save()
					b:$$$ERROR(sc1)
					
					s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild2,0))
					s MDValue = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
					s StructCN = ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MDValue)
					
					s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
					d cobj.MKBICDContrastSetObjectId(MKBICRowId)
					s cobj.MKBICDConResult = StructCN
					s cobj.MKBICDConResultID = MDValue
					s cobj.MKBICDConSupplement = ""
					d cobj.MKBICDConOtherSetObjectId(BJRowId)
					s csc=cobj.%Save()
					b:$$$ERROR(csc)
					
				}
				else
				{
					s num2=num2+1
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDOther = "同码不同义"
					s sc1=obj.%Save()
					b:$$$ERROR(sc1) ;同码不同义
					
					s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild2,0))
					s MDValue = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
					s StructCN = ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MDValue)
					
					s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
					d cobj.MKBICDContrastSetObjectId(MKBICRowId)
					s cobj.MKBICDConResult = StructCN
					s cobj.MKBICDConResultID = MDValue
					d cobj.MKBICDConOtherSetObjectId(BJRowId)
					s cobj.MKBICDConSupplement = ""
					s csc=cobj.%Save()
					b:$$$ERROR(csc)	
				}
			}	
		}
	}
	w "通过北京版ICD对照结构化数:"_num,!
	w "同码同义："_num1,!
	w "同码不同义："_num2,!
}

/// 通过数据处理工厂的诊断描述及其对应的结构化为安贞icd结构化
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).StuctViaDiagDesc()
ClassMethod StuctViaDiagDesc()
{
	TS
	s num=0
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		continue:$D(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult"))=0
		
		s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		if ($D(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDDiag,"U")))'=0)
		{
			s MKBICRowId=0
			for
			{
				s MKBICRowId=$O(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDDiag,"U"),MKBICRowId))
				q:MKBICRowId=""
			
				s num=num+1
				s child=0
				for
				{
					s child=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child))
					q:child=""
					
					s obj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
					d obj.MKBICDContrastSetObjectId(MKBICRowId)
					d obj.MKBICDConPropertyDrSetObjectId($LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),4))
					s obj.MKBICDConResult = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),3)
					s obj.MKBICDConResultID = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),2)
					s obj.MKBICDConSupplement = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),5)
					s sc=obj.%Save()
					b:$$$ERROR(sc)
				}	
			}
					
		}	
	}
	w "通过诊断查找ICD进行结构化数目：",num,!
}

/// 删除ICD对照子表重复数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteRepeateDataInICDContrastResult()
ClassMethod DeleteRepeateDataInICDContrastResult()
{
	TS
	s i=1
	s MKBICRowId = 0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		k tmp
		
		s child=0
		for
		{
			s child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",child))
			q:child=""
			

			s MKBICStructResult = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",child)),3)
			if ($D(tmp(MKBICStructResult))=0)
			{
				s tmp(MKBICStructResult)=""	
			}
			else
			{
				s i=i+1
				s sc = ##class(User.MKBICDContrastResult).%DeleteId(MKBICRowId_"||"_child)	
				if $$$ERROR(sc)
				{
					s error = $SYSTEM.Status.GetErrorText(sc)
					b		
				}
			}
		}	
	}
	w "重复数目："_i,!
}

/// 获取尚未结构化icd条数
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).UnStructData()
ClassMethod UnStructData()
{
	s num=0
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))=0)
		{
			s num=num+1	
		}	
	}
	w "尚未结构化数据："_num,!
}

/// Creator:李欣	
/// Desc:k掉医用知识库所有数据
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).Kill()
ClassMethod Kill()
{
	;d ..DeleteMKBTermBase()
	k ^User.MKBTermBaseD	//术语库注册表 
	k ^User.MKBTermBaseI	//术语库注册表 
	k ^User.MKBTermBasePropertyI	//术语库注册属性表 
	k ^User.MKBTermBasePropertyD	//术语库注册属性表
	k ^User.MKBTermBasePropertyC	//术语库注册属性表	
 	k ^User.MKBTermBaseExtendProI	//术语库注册扩展属性表
 	k ^User.MKBTermD	//术语表
 	k ^User.MKBTermI	//术语表
	k ^User.MKBTermPropertyD	//术语维护属性表
	k ^User.MKBTermPropertyI	//术语维护属性表
	k ^User.MKBTermPropertyC	//术语属性表
	k ^User.MKBTermExtendProI	//术语扩展属性表
	k ^User.MKBTermProDetailD	//术语属性内容表
	k ^User.MKBTermProDetailI	//术语属性内容表
	k ^User.MKBTermExtendProValD	//扩展属性值表
	k ^User.MKBTermExtendProValI	//扩展属性值表
	k ^User.MKBReferenceD	//引用表
	k ^User.MKBReferenceI	//引用表
	k ^User.MKBDocManageD	//文献管理
	k ^User.MKBDocManageI	//文献管理
	k ^User.BDPUserHabitHisUiD	//用户使用习惯
	k ^User.BDPUserHabitHisUiI
	k ^User.BDPDataHistoryD
	k ^User.BDPDataHistoryI
	;k ^User.BDPDataFrequencyD
	;k ^User.BDPDataFrequencyI
	k ^User.MKBKLMappingDetailD
	k ^User.MKBKLMappingDetailI
	k ^User.MKBKLMappingBaseD
	k ^User.MKBKLMappingBaseI
	k ^User.MKBKLMappingBaseC
	k ^User.MKBKLMappingBaseFieldI
	k ^User.MKBAssessmentBaseD
	k ^User.MKBAssessmentBaseI
	k ^User.MKBAssessmentBaseC
	k ^User.MKBAssessmentBaseFieldI
	k ^User.BDPMKBIndexD
	k ^User.BDPMKBIndexI
	;k ^User.SDSStructDiagnosD
	;k ^User.SDSStructDiagnosI
	;k ^User.SDSStructDiagnosLogD
	;k ^User.SDSStructDiagnosLogI
	;k ^User.SDSStructDiagnosLinkD
	;k ^User.SDSStructDiagnosLinkI
	;k ^User.SDSStructDiagnosApplyD
	;k ^User.SDSStructDiagnosApplyI
	;k ^User.SDSAssessmentD
	;k ^User.SDSAssessmentI
	k ^User.MKBDataStatisticsD
	k ^User.MKBMappingTermRelyD
	k ^User.MKBMappingSortRelyD
	k ^User.MKBDataStatisticsI
	k ^User.MKBMappingTermRelyI
	k ^User.MKBMappingSortRelyI
	
	///数据处理工厂
	k ^User.MKBStructuredDataD
	k ^User.MKBStructuredDataI
	k ^User.MKBStructuredDataResultI
	k ^User.MKBStructuredDataLocI
	k ^User.MKBStructuredDataOtherI
	/*
	///icd对照
	k ^User.MKBICDContrastD
	k ^User.MKBICDContrastI
	k ^User.MKBICDContrastResultI

		*/
		///HIS icd对照
	k ^User.MKBHISICDContrastD
	k ^User.MKBHISICDContrastI
	k ^User.MKBHISICDContrastResultI
	

	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-04
/// Description:获取数据工厂中诊断中心词和频次的临时Global和诊断中心词、属性、展示名和属性内容的临时global
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportGlobal()
ClassMethod ExportGlobal() As %String
{
	k ^TMPFlagCount
	k ^TMPSUBLOC
	k ^TMPSORTFRE
	s str=""
	s sum=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
	set rs.QueryName="GetList"
	set sc=rs.Execute("","心内科","","","","")  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	while rs.%Next() 
	{ 
		s fre=rs.Data("sumloc")
		s rowid=rs.Data("Rowid")
		s ^TMPSORTFRE(fre,rowid)=""      ;获取科室频次和诊断rowid
	}
	s n=""
	;s rowid=0
	for
	{
		s n=$o(^TMPSORTFRE(n),-1)
		q:n=""
		
		s PareRowid=0
		for
		{
			s PareRowid=$o(^TMPSORTFRE(n,PareRowid))
			q:PareRowid=""
			
			s ChildRowid=0
			s PropertyDetail=""
			for
			{
				s ChildRowid=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",PareRowid,ChildRowid))
				q:ChildRowid=""
				;^User.MKBStructuredDataD(4472,"MKBSDStructResult",2676)=$lb("","","其他术后","24008","")
				s DisplayName=""
				s DisplayName=$lg($g(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",ChildRowid)),3)    ;获取展示名
				s PropertyDr=""
				s PropertyDr=$lg($g(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",ChildRowid)),4)     ;获取属性指向
				s CenterID=""
				s CenterID= $LG($G(^User.MKBTermPropertyD(PropertyDr)),6)       ;获取中心词ID
				if CenterID=""
				{
					b
				}
				s PropertyDetail=$lg(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",ChildRowid),2)
				if PropertyDetail=""
				{
					s PropertyDetail="NULL"
				}

				if $d(^FlagCount(CenterID))
				{
					s i=$o(^FlagCount(CenterID,0))
					s sum=n+i
					k ^TMPFlagCount(CenterID)                                ;每次更新时把原来的节点Kill掉
					s ^TMPFlagCount(CenterID,sum)=""
					s ^TMPSUBLOC(CenterID,PropertyDr,DisplayName,PropertyDetail)=""

				}
				else
				{

					s ^TMPFlagCount(CenterID,n)=""
					s ^TMPSUBLOC(CenterID,PropertyDr,DisplayName,PropertyDetail)=""
				}
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-04
/// Description:把临时^FlagCount中的节点对换
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).MergeGlobal()
ClassMethod MergeGlobal()
{
	k ^TMPSortCenterid
	s CenterRowid=0
	for
	{
		s CenterRowid=$o(^TMPFlagCount(CenterRowid))
		q:CenterRowid=""
		s fre=0
		s fre=$o(^TMPFlagCount(CenterRowid,fre))
		s ^TMPSortCenterid(fre,CenterRowid)=""	
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-04
/// Description:把临时^FlagCount中的节点转换成频次和描述的^SortCenterid
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).Centerid2Desc()
ClassMethod Centerid2Desc()
{
	k ^TMPSortCenterid
	s n=0
	s CenterRowid=0
	for
	{
		s CenterRowid=$o(^TMPFlagCount(CenterRowid))
		q:CenterRowid=""
		s fre=0
		s fre=$o(^TMPFlagCount(CenterRowid,fre))
		s Desc=$lg($g(^User.MKBTermD(CenterRowid)),3) 
		s ^TMPSortCenterid(fre,Desc)=""
		s n=n+1
	}
	q n
}

/// Creator:李得原
/// CreatDate:2019-01-07
/// Description:获取^TMPInter，节点包括数据工厂心内科中心词描述、原始诊断、对应频次、结构化结果描述
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportIntegration()
ClassMethod ExportIntegration()
{
	k ^TMPIntergration
	k ^TMPInter
	s str=""
	s sum=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
	set rs.QueryName="GetList"
	set sc=rs.Execute("","心内科","")  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	while rs.%Next() 
	{ 
		s fre=rs.Data("sumloc")
		s rowid=rs.Data("Rowid")
		s diag=rs.Data("MKBSDDiag")
		s ^TMPIntergration(fre,rowid,diag)=""
	}
	s n=""
	;s rowid=0
	for
	{
		s n=$o(^TMPIntergration(n),-1)
		q:n=""
		
		s PareRowid=0
		for
		{
			s PareRowid=$o(^TMPIntergration(n,PareRowid))
			q:PareRowid=""
			;原始诊断
			s diag=$o(^TMPIntergration(n,PareRowid,""))
			;^User.MKBStructuredDataD(865,"MKBSDStructResult",1045)=$lb("","","食管反流","19721","")
			s ChildRowid=0
			s PropertyDetail=""
			for
			{
				s ChildRowid=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",PareRowid,ChildRowid))
				q:ChildRowid=""
				;^User.MKBStructuredDataD(4472,"MKBSDStructResult",2676)=$lb("","","其他术后","24008","")
				;结构化结果DisplayName
				s DisplayName=$lg(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",ChildRowid),3)   
				s PropertyDr=$lg(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",ChildRowid),4)
				s CenterID=##class(web.DHCBL.MKB.MKBStructuredData).GetTermIdByProId(PropertyDr)
				if CenterID=""
				{
					b
				}
				;诊断中心词
				s Desc=$lg($g(^User.MKBTermD(CenterID)),3) 
				s ^TMPInter(Desc,diag,n,DisplayName)=""
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-07
/// Description:把^TMPInter中的内容输出到excel，科室子集文件
/// Table:
/// Input:""
/// Return:""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).Write2Excel()
ClassMethod Write2Excel()
{
	s file=##class(%File).%New("D:\Intergration.csv")
	d file.Open("NWS")
	d file.Write("诊断中心词")
	d file.Write(",")
	d file.Write("原始诊断")
	d file.Write(",")
	d file.Write("频次")
	d file.Write(",")
	d file.Write("结构化结果")
	d file.WriteLine()
	s sortfre=""
	for
	{
		s sortfre=$o(^TMPSortCenterid(sortfre),-1)
		q:sortfre=""
		s desc=""
		for
		{
			s desc=$o(^TMPSortCenterid(sortfre,desc))
			q:desc=""
			d file.Write(desc)
			d file.Write(",")
			d file.WriteLine()
			s diag=""
			for
			{
				s diag=$o(^TMPInter(desc,diag))
				q:diag=""
				s fre=$o(^TMPInter(desc,diag,0))
				s StructResult=$o(^TMPInter(desc,diag,fre,""))
				d file.Write(",")
				d file.Write(diag)
				d file.Write(",")
				d file.Write(fre)
				d file.Write(",")
				d file.Write(StructResult)
				d file.WriteLine()
			}
		}
	}
	d file.%Save()
	d file.%Close()
	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-10
/// Description:获取数据工厂中原始诊断、结构化诊断以及相关信息
/// Table:
/// Input:""
/// Return:""
/// ^TMPMKBSTRUCTDIA(频次,子表的rowid)=非结构化的诊断名-右侧结构化的诊断名[A]诊断的code[A]检索码[A]诊断展示名[A]诊断展示名的检索码[A]诊断的备注
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportStructedDiag()
ClassMethod ExportStructedDiag()
{
	k ^TMPMKBGETDIAG
	k ^TMPMKBSTRUCTDIA
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
	set rs.QueryName="GetList"
	set sc=rs.Execute("","心内科","")  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	while rs.%Next() 
	{ 
		s fre=rs.Data("sumloc")
		s rowid=rs.Data("Rowid")
		s diag=rs.Data("MKBSDDiag")
		s ^TMPMKBGETDIAG(fre,rowid,diag)=""
	}
	
	s Frequent=""
	for
	{
		s Frequent=$o(^TMPMKBGETDIAG(Frequent),-1)  ;从大到小获取频次
		q:Frequent=""
		s PareRowid=0
		for
		{
			s PareRowid=$o(^TMPMKBGETDIAG(Frequent,PareRowid))   ;获取父表Rowid
			q:PareRowid=""
			s rowid=0
			for
			{
				s rowid=$o(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",rowid))
				q:rowid=""
				s Rowid=PareRowid_"||"_rowid                                                      ;获取子表Rowid
				s MKBSDPropertyDR=$lg(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",rowid),4)
				s MKBSDStructResult=$lg(^User.MKBStructuredDataD(PareRowid,"MKBSDStructResult",rowid),3)   ;获取结构化的诊断名
				s MKBTRowId = $LG($G(^User.MKBTermPropertyD(MKBSDPropertyDR)),6)                              ;获取中心词Rowid
				s MKBTDesc=$LG($G(^User.MKBTermD(MKBTRowId)),3)                                  ;获取诊断的code
				s MKBTNote=$LG($G(^User.MKBTermD(MKBTRowId)),7) 
				s MKBTNote=##class(web.DHCBL.BDP.FunLib).EvalJSON(MKBTNote)
				s MKBTNote=##class(web.BDP.util.String).Replace(MKBTNote,"<br/>","")                                  ;获取诊断的备注
				s strComAndAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowId)
				s strCom=$p(strComAndAlias,"[A]",1)
				s comDesc=$p(strCom,"&%",1)     ;获取常用名
				s MKBTDesc=comDesc_"("_MKBTDesc_")"
				s MKBTDesc=##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTDesc)
				s comKey=$p(strCom,"&%",2)      ;获取常用名拼音码
				s Diag=$o(^TMPMKBGETDIAG(Frequent,PareRowid,""))   ;获取原始诊断
				s DiagStr=Diag_"-"_MKBSDStructResult
				s DiagStrPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DiagStr)    ;拼音检索码
				s ^TMPMKBSTRUCTDIA(Frequent,Rowid)=DiagStr_"[A]"_MKBTRowId_"[A]"_DiagStrPY_"[A]"_MKBTDesc_"[A]"_comKey_"[A]"_MKBTNote
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-29
/// Description:把ICD11导入到知识库
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportICD11()
ClassMethod ImportICD11()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s unknown=0
	s unknownL6=0
	s l5=0
	s id=0
	Ts
	s TermBase=$o(^User.MKBTermBaseI("DescIndex"," ICD11编码",0))   ;60
	s file=##class(%File).%New("D:\工作\2020-05-11\ICD11Master.csv")
	;s file=##class(%File).%New("D:\工作\2019-01-28\ceshi.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		s code=$p(str,",",1)
		s diag=$p(str,",",2)
		s activeflag=$p(str,",",3)
		s code=$Zstrip(code,"<>W")
		s diag=$zstrip(diag,"<>W")
		s readcount=readcount+1
		if code="第X章"
		{
			q
		}
		if code'=""
		{
			s Flag=$p(code,"-",1)
			;if (ToId="") set ToId="-100000000000000"
			if (code["章")
			{
				k ^TMP("MarkRootID")
				k ^TMP("MarkL1ID")
				k ^TMP("MarkL2ID")
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				s RootId="-100000000000000"
				d obj.MKBTLastLevelSetObjectId(RootId)
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkRootID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			elseif (Flag="L1")
			{
				k ^TMP("MarkL1ID")
				k ^TMP("MarkL2ID")
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s RootFlag=""
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkRootID",RootFlag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL1ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			elseif (Flag="L2")
			{
				k ^TMP("MarkL2ID")
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L1Flag=""
				s L1Flag=$o(^TMP("MarkL1ID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL1ID",L1Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL2ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}					
			}
			elseif (Flag="L3")
			{
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L2Flag=""
				s L2Flag=$o(^TMP("MarkL2ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL2ID",L2Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL3ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}	
			}
			elseif (Flag="L4")
			{
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L3Flag=""
				s L3Flag=$o(^TMP("MarkL3ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL3ID",L3Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL4ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}	
			}
			elseif (Flag="L5")
			{
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L4Flag=""
				s L4Flag=$o(^TMP("MarkL4ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL4ID",L4Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL5ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}	
			}
			elseif ($l(code)=4)
			{
				if '$d(^TMP("MarkL1ID"))
				{
					k ^TMP("MarkL1ID")
					k ^TMP("MarkL2ID")
					k ^TMP("MarkL3ID")
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s RootFlag=""
					s RootFlag=$o(^TMP("MarkRootID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkRootID",RootFlag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				}
				elseif '$d(^TMP("MarkL2ID"))
				{					
					k ^TMP("MarkL2ID")
					k ^TMP("MarkL3ID")
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L1Flag=""
					s L1Flag=$o(^TMP("MarkL1ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL1ID",L1Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)	
				}
				elseif '$d(^TMP("MarkL3ID"))
				{					
					k ^TMP("MarkL3ID")
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L2Flag=""
					s L2Flag=$o(^TMP("MarkL2ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL2ID",L2Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)		
				}
				elseif '$d(^TMP("MarkL4ID"))
				{					
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L3Flag=""
					s L3Flag=$o(^TMP("MarkL3ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL3ID",L3Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)		
				}
				elseif '$d(^TMP("MarkL5ID"))
				{					
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L4Flag=""
					s L4Flag=$o(^TMP("MarkL4ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL4ID",L4Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)		
				}
				elseif $d(^TMP("MarkL5ID"))
				{
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L5Flag=""
					s L5Flag=$o(^TMP("MarkL5ID",""))
					s RootFlag=$o(^TMP("MarkRootID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL5ID",L5Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				}
				else
				{
					s unknownL6=unknownL6+1
				}
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL6ID",code)=id
					set result = "{success:'true',id:'"_id_"'}"
					s savecount=savecount+1 
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
				
			}
			elseif ($l(code)=5)
			{
				
				s l5=l5+1
				b ;code=5
			}
			elseif ($l(code)=6)
			{
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L6Flag=""
				s L6Flag=$o(^TMP("MarkL6ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL6ID",L6Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL7ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			elseif ($l(code)=7)
			{
				k ^TMP("MarkL8ID")
				s L7Flag=""
				s L7Flag=$o(^TMP("MarkL7ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL7ID",L7Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL8ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			else
			{
				s unknown=unknown+1
			}
		}
		else   //code为空
		{
			s nosavecount=nosavecount+1
			b ; code=none
		}
		
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "unknown:"_unknownL6,!
	w "unknownL6:"_unknownL6,!
	w l5,!
	q result
}

/// Creator:李得原
/// CreatDate:2019-01-29
/// Description:把ICD11中备注中得数据转移到active字段中
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).MoveNote2Active()
ClassMethod MoveNote2Active()
{
	;^User.MKBTermI("BaseIndex",60)
	s rowid=0
	for
	{
		s rowid=$o(^User.MKBTermI("BaseIndex",60,rowid))
		q:rowid=""
		s obj=##class(User.MKBTerm).%OpenId(rowid)
		s temp=""
		s temp=obj.MKBTNote
		if temp="是"
		{
			s obj.MKBTActiveFlag="Y"
		}
		else
		{
			s obj.MKBTActiveFlag="N"
		}
		
		s obj.MKBTNote=""
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			set id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-02-20
/// Description:把安贞ICD诊断导入到Term表中
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).MigrateICDToTerm()
ClassMethod MigrateICDToTerm()
{
	Ts
	k ^TMP("MigrateICDToTerm")
	s file=##class(%File).%New("D:\安贞诊断\2019-02-21.csv")
	d file.Open("RSU")
	d file.ReadLine()
	d file.ReadLine()
	s i=0
	while 'file.AtEnd
	{
		s line=file.ReadLine()
		q:line=""
		s Code=$p(line,"%&",2)
		s Code=$e(Code,1,*-1)
		s DescStr=$p(line,"%&",3)
		s Desc=$e(DescStr,1,*-1)
		s Num=$p(line,"%&",4)
		s Num=$e(Num,1,*-1)
		s ICDRowid=0
		s i=i+1
		s obj=##class(User.MKBTerm).%New()
		s obj.MKBTCode=Code
		s obj.MKBTDesc=Desc
		s basedr=$o(^User.MKBTermBaseI("DescIndex"," 诊断_安贞ICD",0))
		d obj.MKBTBaseDRSetObjectId(basedr)
		s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(basedr)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			set id=obj.%Id()
			s sce=##class(web.DHCBL.MKB.MKBTerm).SaveBaseExtToTerm(basedr,id)
			if (sce["false"){
				b ;sce	
			}
			set result = "{success:'true',id:'"_id_"'}" 
			s ^TMP("MigrateICDToTerm",id,Desc)=""
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b ;1
		}
		s prowid=$O(^User.MKBTermPropertyI("DescIndex",id," ICD编码",0))
		/*
		s pobj=##class(User.MKBTermProperty).%New()
		s pobj.MKBTPDesc="ICD编码"
		s pobj.MKBTPType="TA"
		s pobj.MKBTPPublic="Y"
		s pobj.MKBTPSequence=##class(web.DHCBL.MKB.MKBTermProperty).GetLastSequence(id)
		d pobj.MKBTPTermDrSetObjectId(id)
		s psc=pobj.%Save()
		d pobj.%Close()
		if $$$ISOK(psc)
		{
			set pid=pobj.%Id()
			set presult = "{success:'true',id:'"_pid_"'}" 
		}
		else
		{
			set presult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(psc)_"'}"
			b ;2
		}
		*/
		if Num'=""
		{
			s pdobj=##class(User.MKBTermProDetail).%New()
			s pdobj.MKBTPDDesc=Num
			d pdobj.MKBTPDProDRSetObjectId(prowid)
			s pdsc=pdobj.%Save()
			d pdobj.%Close()
			if $$$ISOK(pdsc)
			{
				set pdid=pdobj.%Id()
				set pdresult = "{success:'true',id:'"_pdid_"'}" 
			}
			else
			{
				set pdresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(pdsc)_"'}"
				b ;3
			}
		}
		s ^TMP("MigrateICDToTerm",id,Desc)=""
		k id
		k pid
		k pdid
		
	}
	d file.%Close()
}

/// Creator:李得原
/// CreatDate:2019-02-22
/// Description:把ICDContrast中的代码 编码 描述都用Term指针表示
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).SubstituteDescWithTermdr()
ClassMethod SubstituteDescWithTermdr()
{
	Ts
	s basedr=$o(^User.MKBTermBaseI("DescIndex"," 诊断_安贞ICD",0))
	s n=0,m=0
	s Term=""
	for
	{
		s Term=$o(^User.MKBTermI("DescIndex",basedr,Term))
		q:Term=""
		s m=m+1
		s TermDesc=$Zstrip(Term,"<>W")
		s TermDesc=$Replace(TermDesc,")","）")
		s TermDesc=$Replace(TermDesc,"(","（")
		s TermDesc=$Replace(TermDesc,",","，")
		s TermDesc=$replace(TermDesc,"?","？")
		s ICDRowid=""
		for
		{
			s ICDRowid=$o(^User.MKBICDContrastD(ICDRowid))
			q:ICDRowid=""
			s ICDDesc=$lg(^User.MKBICDContrastD(ICDRowid),3)
			s ICDDesc=$zconvert(ICDDesc,"U")
			if ICDDesc=TermDesc
			{
				s TermRowid=$o(^User.MKBTermI("DescIndex",basedr,Term,0))
				b:TermRowid=""
				s obj=##class(User.MKBICDContrast).%OpenId(ICDRowid)
				d obj.MKBICDConHisTermdrSetObjectId(TermRowid)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s ^TMP("MigrateICDToTerm",ICDRowid,ICDDesc)=""
					
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b ;false
				}
			}
		}
	}
	q m
}

/// Creator:李得原
/// CreatDate:2019-02-22
/// Description:把ICDContrast中的重复的值找出
/// Table:User.MKBICDContrast
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).CheckSame()
ClassMethod CheckSame()
{
	s rowid=0
	for
	{
		s rowid=$o(^User.MKBICDContrastD(rowid))
		q:rowid=""
		s desc=$lg($g(^User.MKBICDContrastD(rowid)),3)
		if $d(Check(desc))
		{
			w desc
		}
		else
		{
			s Check(desc)=""
		}
		
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-02-22
/// Description:把Term中的ICD后面的引号去掉
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).RemoveDoubleSign()
ClassMethod RemoveDoubleSign()
{
	s basedr=$o(^User.MKBTermBaseI("DescIndex"," 诊断_安贞ICD",0))
	s n=0
	s rowid=0
	for
	{
		s rowid=$o(^User.MKBTermI("BaseIndex",basedr,rowid))
		q:rowid=""
		s desc=$lg($g(^User.MKBTermD(rowid)),3)
		if desc[""""
		{
			s desc=$tr(desc,"""","")
			s obj=##class(User.MKBTerm).%OpenId(rowid)
			s obj.MKBTDesc=desc
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s n=n+1
			}
			else
			{
				set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;false
			}
		}
	}
	q n
}

/// Creator:李得原
/// CreatDate:2019-02-26
/// Description:把安贞Execute科室导入到term表中
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).MigrageExecuteLocToTerm()
ClassMethod MigrageExecuteLocToTerm()
{
	Ts
	s n=0
	s basedr=$o(^User.MKBTermBaseI("DescIndex"," 医疗_科室_安贞",0))
	s file=##class(%File).%New("D:\工作\2019-02-25\execute科室.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s loc=file.ReadLine()
		q:loc=""
		s eobj=##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTDesc=loc
		s eobj.MKBTBaseDR=basedr
		s result=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
		d eobj.%Close()
		if result["false"
		{
			b
		}
		else
		{
			s n=n+1
		}	
	}
	q n
}

/// Creator:李得原
/// CreatDate:2019-02-27
/// Description:把数据处理工厂中的诊断通过实际科室对照到专业科室
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).DiagToLoc3()
ClassMethod DiagToLoc3()
{
	Ts
	///遍历专业科室
	s MKBTBRowId = $O(^User.MKBTermBaseI("FlagIndex"," LOC",0))
	s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	
	///获取科室对照诊断
	s MKBLocDiagBase=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	s Loc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 科室",0))
	s Diag=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 诊断",0))
	s Fre=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 频次",0))

	k ^DDD
	k ^RLLOC
	;k ^TEST
	///获取实际科室
	s RealLocFieldChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))
	s RealLocFieldRowId = MKBKLMBRowId_"||"_RealLocFieldChild 
	
	s diagg=0
	s sum=0
	s exsum=0
	k realloc
	s MKBTRowId=0

	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
	
		if ($D(^User.MKBReferenceI("InverAllIndex","T",MKBTRowId)))
		{
			s MDRowId = 0
			///获取当前专业科室对照的所有实际科室
			for
			{
				s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",MKBTRowId,"MD",MDRowId))
				q:MDRowId=""

				continue:$D(^User.MKBKLMappingDetailI("BaseIndex",MKBKLMBRowId,MDRowId))=0
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
				s RealLocMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,RealLocFieldRowId,0))	//实际科室的MappingDetailRowId
				s RealLocTermId = $LG($G(^User.MKBKLMappingDetailD(RealLocMDRowId)),2)
				s realloc(MKBTRowId,RealLocTermId)=""
				
				
				s RealLocDesc=$lg($g(^User.MKBTermD(RealLocTermId)),3)		
				
			}	
		}
	}
	/*
	set rss=##class(%ResultSet).%New()
	set rss.ClassName="web.DHCBL.MKB.MKBStructuredData"
	set rss.QueryName="GetList"
	set scc=rss.Execute("","急诊科","","","",0)  If $$$ISERR(scc) Do DisplayError^%apiOBJ(scc) Quit

	while rss.%Next() 
	{ 
		s fre=""
		s fre=rss.Data("sumloc")
		s rowid=rss.Data("Rowid")
		s diag=rss.Data("MKBSDDiag")
		if diag=""
		{
			q
		}
		s ^TEST(diag)=""
	}
	d rss.Close()
	*/
	s SumOfEmergency=0
	s aa=""
	for
	{
		s aa=$o(^TEST(aa))
		q:aa=""
		s SumOfEmergency=SumOfEmergency+1
	}			
	
	
	s aaa=0
	s ProLoc=""
	for
	{
		s ProLoc=$o(realloc(ProLoc))
		q:ProLoc=""
		k CountFre
		k Reverse
		s RealLoc=""
		for
		{
			s RealLoc=$o(realloc(ProLoc,RealLoc))
			q:RealLoc=""
			s RealLocDesc=$lg($g(^User.MKBTermD(RealLoc)),3)
			s RealLocDesc=RealLocDesc
			s Frequent=0
			set rs=##class(%ResultSet).%New()
			set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
			set rs.QueryName="GetList"
			set sc=rs.Execute("",RealLocDesc,"","","",0)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
			while rs.%Next() 
			{ 
				s fre=""
				s fre=rs.Data("sumloc")
				s rowid=rs.Data("Rowid")
				s diag=rs.Data("MKBSDDiag")
				s StructuredResult=""
				s ^DDD(diag)=""
				b
				for
				{
					s StructuredResult=$o(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",StructuredResult))
					q:StructuredResult=""
					s PropertyRowid=$lg($g(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",StructuredResult)),4)
					s CenterWordRowid=$lg($g(^User.MKBTermPropertyD(PropertyRowid)),6)
					b:CenterWordRowid=""
					if ($d(CountFre(CenterWordRowid)))
					{
						s CenterWordFre=$o(CountFre(CenterWordRowid,0))
						s CenterWordFre=CenterWordFre+fre
						k CountFre(CenterWordRowid)
						s CountFre(CenterWordRowid,CenterWordFre)=""
					}
					else
					{
						s CountFre(CenterWordRowid,fre)=""
					}

				}
			}
		}
		s mmmm=0
		s EmDiag=""
		for
		{
			s EmDiag=$o(^TEST(EmDiag))
			q:EmDiag=""
			if $d(^DDD(EmDiag))
			{
				
			}
			else
			{
				s mmmm=mmmm+1
			}
		}
		b ; Stop

		
		s ReverseCenter=0
		for
		{
			s ReverseCenter=$o(CountFre(ReverseCenter))
			q:ReverseCenter=""
			s ReverseFre=$o(CountFre(ReverseCenter,0))
			s Reverse(ReverseFre,ReverseCenter)=""
		}

		s n=0
		s fre=""
		for
		{
			s fre=$o(Reverse(fre),-1)
			q:fre=""
			
			s CenterWordRowid=0
			for
			{
				s CenterWordRowid=$o(Reverse(fre,CenterWordRowid))
				q:CenterWordRowid=""
				if n<200
				{
					s FieldValue=Loc_"[A]"_ProLoc_"[N]"_Diag_"[A]"_CenterWordRowid_"[N]"_Fre_"[A]"_fre
					s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBLocDiagBase,FieldValue)
					s sum=sum+1
					s n=n+1
					if result["false"
					{
						b
					}	
				}
				else
				{
					s exsum=exsum+1
					s n=n+1
				}
			}

		}
		
	
		
	}
	s ddd=0
	s dd=""
	for
	{
		s dd=$o(^RLLOC(dd))
		q:dd=""
		s ddd=ddd+1
	}
	w ddd,!
	q "存入:"_sum_","_"去除:"_exsum_"一共遍历了"_diagg_"条诊断"
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TestFre()
ClassMethod TestFre()
{

	k ^DDD
	s mmmm=0
	s nnnn=0
	s ppp=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
	set rs.QueryName="GetList"
	set sc=rs.Execute("","","","","",0)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	while rs.%Next() 
	{ 
		s fre=""
		s fre=rs.Data("sumloc")
		s rowid=rs.Data("Rowid")
		s diag=rs.Data("MKBSDDiag")
		s StructuredResult=""
		s ^DDD(diag)=""
	}
	s d=""
	for
	{
		s d=$o(^DDD(d))
		q:d=""
		s ppp=ppp+1
	}
	s EmDiag=""
	for
	{
		s EmDiag=$o(^TEST(EmDiag))
		q:EmDiag=""
		if $d(^DDD(EmDiag))
		{
			s nnnn=nnnn+1
		}
		else
		{
			s mmmm=mmmm+1
		}
	}	
	b
	q ""
}

/// Creator:李得原
/// CreatDate:2019-02-27
/// Description:把科室对照诊断中的数据删除
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).DellDiagToLoc()
ClassMethod DellDiagToLoc()
{
	Ts
	s n=0
	s base=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	s DetailRowid=0
	for
	{
		s DetailRowid=$o(^User.MKBKLMappingDetailI("BaseIndex",base,DetailRowid))
		q:DetailRowid=""
		s RowNum = $LG($G(^User.MKBKLMappingDetailD(DetailRowid)),4)
		d ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(RowNum,base)
		s n=n+1
	}
	q n
}

/// Creator:李得原
/// CreatDate:2019-02-27
/// Description:把数据处理工厂中的诊断通过实际科室对照到专业科室（科室常用诊断）
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).DiagToLoc2()
ClassMethod DiagToLoc2()
{
	
	
	///遍历专业科室
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	///获取科室对照诊断
	s MKBLocDiagBase=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	s Loc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 科室",0))
	s Diag=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 诊断",0))
	s Fre=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 频次",0))

	
	///获取实际科室
	s RealLocFieldChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))
	s RealLocFieldRowId = MKBKLMBRowId_"||"_RealLocFieldChild 
	
	s sum=0
	s exsum=0
	s tt=0
	k realloc
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
	
		if ($D(^User.MKBReferenceI("InverAllIndex","T",MKBTRowId)))
		{
			s MDRowId = 0
			///获取当前专业科室对照的所有实际科室
			for
			{
				s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",MKBTRowId,"MD",MDRowId))
				q:MDRowId=""
				
				continue:$D(^User.MKBKLMappingDetailI("BaseIndex",MKBKLMBRowId,MDRowId))=0
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
				
				s RealLocMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,RealLocFieldRowId,0))	//实际科室的MappingDetailRowId
				s RealLocTermId = $LG($G(^User.MKBKLMappingDetailD(RealLocMDRowId)),2)
				s realloc(MKBTRowId,RealLocTermId)=""
				
			}	
		}
	}
	b
	s ff=0
	s ProLoc=""
	for
	{
		s ProLoc=$o(realloc(ProLoc))
		q:ProLoc=""
		k CountFre
		k Reverse
		s RealLoc=""
		for
		{
			s RealLoc=$o(realloc(ProLoc,RealLoc))
			q:RealLoc=""
			s RealLocDesc=$lg($g(^User.MKBTermD(RealLoc)),3)
			s RealLocDesc=RealLocDesc_"(安贞)"
			s Frequent=0
			set rs=##class(%ResultSet).%New()
			set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
			set rs.QueryName="GetList"
			set sc=rs.Execute("",RealLocDesc,"","","","")  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
			while rs.%Next() 
			{ 
				s fre=""
				s fre=rs.Data("sumloc")
				s rowid=rs.Data("Rowid")
				s diag=rs.Data("MKBSDDiag")
				s StructuredResult=""
				for
				{
					s StructuredResult=$o(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",StructuredResult))
					q:StructuredResult=""
					s PropertyRowid=$lg($g(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",StructuredResult)),4)
					s CenterWordRowid=$lg($g(^User.MKBTermPropertyD(PropertyRowid)),6)
					b:CenterWordRowid=""
					s ff=ff+1
					if ($d(CountFre(CenterWordRowid)))
					{
						s CenterWordFre=$o(CountFre(CenterWordRowid,0))
						s CenterWordFre=CenterWordFre+fre
						k CountFre(CenterWordRowid)
						s CountFre(CenterWordRowid,CenterWordFre)=""
					}
					else
					{
						s CountFre(CenterWordRowid,fre)=""
					}
				}
			}
		}
		
		s ReverseCenter=0
		for
		{
			s ReverseCenter=$o(CountFre(ReverseCenter))
			q:ReverseCenter=""

			s ReverseFre=$o(CountFre(ReverseCenter,0))
			s Reverse(ReverseFre,ReverseCenter)=""
			
		}

		s CenterWordRowid=0
		s n=0
		s fre=""
		for
		{
			s fre=$o(Reverse(fre),-1)
			q:fre=""

			s CenterWordRowid=0
			for
			{
				s CenterWordRowid=$o(Reverse(fre,CenterWordRowid))
				q:CenterWordRowid=""
				s tt=tt+1
				/*
				if n<200
				{
					s FieldValue=Loc_"[A]"_ProLoc_"[N]"_Diag_"[A]"_CenterWordRowid_"[N]"_Fre_"[A]"_fre
					s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBLocDiagBase,FieldValue)
					s sum=sum+1
					s n=n+1
					if result["false"
					{
						b
					}
				}	
				else
				{
					s exsum=exsum+1
					s n=n+1
				}
				*/
			}
			
		}
		
	}
	q tt_" "_ff
}

/// Creator:李得原
/// CreatDate:2019-03-07
/// Description:ICD对照界面的参考中心词和分词对应到HIS-ICD对照界面
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).SegToHis()
ClassMethod SegToHis()
{
	Ts
	s MRCRowid=""
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s MRCCode=""
		s MRCCode=$p(^MRC("ID",MRCRowid),"^",1)
		
		s ICDRowid=0
		for
		{
			s ICDRowid=$o(^User.MKBICDContrastD(ICDRowid))
			q:ICDRowid=""
			
			s ICDCode=$lg(^User.MKBICDContrastD(ICDRowid),2)
			if ICDCode=MRCCode
			{
				s obj=##class(User.MKBHISICDContrast).%New()
				d obj.MKBHISICDDrSetObjectId(MRCRowid)
				d obj.MKBHISICDConCenterWordIDSetObjectId($lg($g(^User.MKBICDContrastD(ICDRowid)),5))
				d obj.MKBHISICDTermDrSetObjectId($lg($g(^User.MKBICDContrastD(ICDRowid)),6))
				s obj.MKBHISICDRemark=$lg($g(^User.MKBICDContrastD(ICDRowid)),7)
				s obj.MKBHISICDConSegmentation=$lg($g(^User.MKBICDContrastD(ICDRowid)),8)				
				s obj.MKBHISICDConStatus=$lg($g(^User.MKBICDContrastD(ICDRowid)),9)
				s obj.MKBHISICDOther=$lg($g(^User.MKBICDContrastD(ICDRowid)),12)
				s obj.MKBHISICDInitialICD=$lg($g(^User.MKBICDContrastD(ICDRowid)),13)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=""
					set id=obj.%Id()
					if $d(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult"))
					{
						s ICDResultRowid=0
						for
						{
							s ICDResultRowid=$o(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",ICDResultRowid))
							q:ICDResultRowid=""
							s Resultobj=##class(User.MKBHISICDContrastResult).%New()
							d Resultobj.MKBHISICDContrastSetObjectId(id)
							s Resultobj.MKBHISICDConResultID=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",ICDResultRowid)),2)
							s Resultobj.MKBHISICDConResult=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",ICDResultRowid)),3)
							d Resultobj.MKBHISICDConTermDrSetObjectId($lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",ICDResultRowid)),4))
							s Resultobj.MKBHISICDConSupplement=$lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",ICDResultRowid)),5)
							d Resultobj.MKBHISICDConOtherSetObjectId($lg($g(^User.MKBICDContrastD(ICDRowid,"MKBICDContrastResult",ICDResultRowid)),6))
							s Rsc=Resultobj.%Save()
							d Resultobj.%Close()
							if $$$ISOK(Rsc)
							{
								
							}
							else
							{
								set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(Rsc)_"'}"
								b
							}
						}
					}
					
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b ;false
				}
			}
		}
		
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-07
/// Description:
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).CompareFactoryAndHis()
ClassMethod CompareFactoryAndHis()
{
	s sum=0
	s basedr=$o(^User.MKBTermBaseI("DescIndex"," 诊断_安贞ICD",0))
	s FactoryDesc=""
	for
	{
		s FactoryDesc=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",FactoryDesc))
		q:FactoryDesc=""
		s Factory=$Zstrip(FactoryDesc,"<>W")
		s HisDesc=""
		s flag=0
		for
		{
			s HisDesc=$o(^User.MKBTermI("DescIndex",basedr,HisDesc))
			q:HisDesc=""
			/*
			s His=$Replace(HisDesc,"；",";")
			s His=$Replace(His,")","）")
			s His=$Replace(His,"(","（")
			s Hiss=$Zstrip(His,"<>W")
			*/
			;b
			if (Factory=HisDesc)
			{
				s sum=sum+1
				s flag=flag+1
				q
			}
			
		}
		if flag=0
		{
			;w FactoryDesc,!
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-03-018
/// Description：比对数据处理工厂和HISICD中诊断相同个数
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).CompareFactoryAndHisRowid()
/// 0
ClassMethod CompareFactoryAndHisRowid()
{
	k ^TMPMARK("ComparedHISandFactory")
	s sum=0
	s basedr=$o(^User.MKBTermBaseI("DescIndex"," 诊断_安贞ICD",0))
	s FactoryRowid=0
	for
	{
		s FactoryRowid=$o(^User.MKBStructuredDataD(FactoryRowid))
		q:FactoryRowid=""
		s FactoryDesc=$lg($g(^User.MKBStructuredDataD(FactoryRowid)),2)
		s flag=0
		s HisRowid=0
		for
		{
			s HisRowid=$o(^User.MKBTermI("BaseIndex",basedr,HisRowid))
			q:HisRowid=""
			s HIS=$lg($g(^User.MKBTermD(HisRowid)),3)
			if HIS=FactoryDesc
			{
				s sum=sum+1
				s flag=flag+1
				s ^TMPMARK("ComparedHISandFactory",FactoryRowid)=""
				q
			}
			if flag=0
			{
				
				;w FactoryDesc,!
			}
		}
		
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-03-019
/// Description：在数据处理工厂中和HISICD相同的诊断中
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetLocFrequentDesc()
/// 1
ClassMethod GetLocFrequentDesc()
{
	k ^TMPSTRUCID
	k ^TMPSTRUCDESC
	k ^TMPMKBSTRUCTDIA
	s file=##class(%File).%New("D:\工作\2019-03-18\数据处理工厂实际科室.csv")
	d file.Open("RS")
	While 'file.AtEnd
	{
		s strs=file.ReadLine()
		s RealLocDesc=$p(strs,",",1)
		q:RealLocDesc=""
		s RealLocDesc=$zstrip(RealLocDesc,"<>W")
	
		set rs=##class(%ResultSet).%New()
		set rs.ClassName="web.DHCBL.MKB.MKBStructuredData"
		set rs.QueryName="GetList"
		set sc=rs.Execute("",RealLocDesc_"(安贞)","","","",0)  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
		while rs.%Next() 
		{ 
			s fre=""
			s fre=rs.Data("sumloc")
			s rowid=rs.Data("Rowid")
			s diag=rs.Data("MKBSDDiag") //中毒*
			if $d(^TMPMARK("ComparedHISandFactory",rowid))
			{
				s ChildRowid=0
				for
				{
					s ChildRowid=$o(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",ChildRowid))
					q:ChildRowid=""
					
					s Child=rowid_"||"_ChildRowid
					s Termdr=$lg(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",ChildRowid),4)
					if Termdr'=""
					{
						s Note=$lg(^User.MKBTermD(Termdr),7)
						
						s Result=$lg(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",ChildRowid),3)
						s ResultID=$lg(^User.MKBStructuredDataD(rowid,"MKBSDStructResult",ChildRowid),2)
						s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Termdr)
						s strCom=$p(strComAndAlisa,"[A]",1)
						s comDesc=$p(strCom,"&%",1) //诊断常用名
						s DiagPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
						s comPY=##class(web.DHCBL.BDP.FunLib).GetPYCODE(comDesc)
						
						;^TMPXXX(his科室描述，频次，his诊断)=结构化诊断描述   
						s ^TMPSTRUCDESC(RealLocDesc,fre,diag)=Result
						;^CTLOC(0,"Desc","骨科",70)=""
						;^MRC("ID",0,"Desc","先天性主动脉窦动脉瘤",4786)="先天性主动脉窦动脉瘤"
						s Diag=$$ALPHAUP^SSUTIL4(diag)
						s RealLoc=$$ALPHAUP^SSUTIL4(RealLocDesc)
						s Diagid=0
						for
						{
							s Diagid=$o(^MRC("ID",0,"Desc",Diag,Diagid))
							q:Diagid=""
							
							s DiagDesc = $P(^MRC("ID",Diagid),"^",2)
							if (DiagDesc=diag)
							{
								s Locid=0
								for
								{
									s Locid=$o(^CTLOC(0,"Desc",RealLoc,Locid))         //获取His科室ID
									q:Locid=""
									s Loc=$p(^CTLOC(Locid),"^",2)
									if Loc=RealLocDesc
									{
										;^TMPXXX(his科室id，频次，his诊断id)=结构化诊断ID
										s ^TMPSTRUCID(Locid,fre,Diagid)=ResultID
										s ^TMPMKBSTRUCTDIA(Locid,fre,Child)=diag_"[A]"_Termdr_"[A]"_DiagPY_"[A]"_comDesc_"[A]"_comPY_"[A]"_Note
									}
								}
							}
						}
					}
					q
				}
			}
		}
	}
	q ""
}

/// 测试^TMPMKBSTRUCTDIA
ClassMethod TMPMKBSTRUCTDIA()
{
}

/// Creator:李得原
/// CreatDate:2019-03-019
/// Description：	^TMPSTRUCID ^TMPSTRUCDESC取每个科室频次排序前30的
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetFrontThirtyFrequent()
/// 2
ClassMethod GetFrontThirtyFrequent()
{
	;^TMPSTRUCID(his科室id，频次，his诊断id)=结构化诊断ID
	;^TMPSTRUCDESC(his科室描述，频次，his诊断)=结构化诊断描述
	
	k ^TMPSTRUCHISDESC
	k ^TMPSTRUCHISID
	
	s LocDesc=""
	for
	{
		s LocDesc=$o(^TMPSTRUCDESC(LocDesc))
		q:LocDesc=""
		s flag=0
		s FreSum=0
		s Fre=""
		for
		{
			s Fre=$o(^TMPSTRUCDESC(LocDesc,Fre),-1)
			q:Fre=""
			
			s Diag=""
			for
			{
				s Diag=$o(^TMPSTRUCDESC(LocDesc,Fre,Diag))
				q:Diag=""
				
				s Result=^TMPSTRUCDESC(LocDesc,Fre,Diag)
				s ^TMPSTRUCHISDESC(LocDesc,Fre,Diag)=Result
				s FreSum=FreSum+1
				if FreSum>=30
				{
					s flag=1
					q
				}
			}
			q:flag=1
		}
	}
	
	
	s LocId=0
	for
	{
		s LocId=$o(^TMPSTRUCID(LocId))
		q:LocId=""
		s flag=0
		s FreSum=0
		s Fre=""
		for
		{
			s Fre=$o(^TMPSTRUCID(LocId,Fre),-1)
			q:Fre=""
			s DiagId=0
			for
			{
				s DiagId=$o(^TMPSTRUCID(LocId,Fre,DiagId))
				q:DiagId=""
				
				s ResultId=^TMPSTRUCID(LocId,Fre,DiagId)
				s ^TMPSTRUCHISID(LocId,Fre,DiagId)=ResultId
				s FreSum=FreSum+1
				if FreSum>=30
				{
					s flag=1
					q
				}
			}
			q:flag=1
		}
	}
	q ""
}

/// 3
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).WriteTMPSTRUCDESCToExcel()
ClassMethod WriteTMPSTRUCDESCToExcel()
{
	
	s file=##class(%File).%New("D:\工作\2019-03-18\科室常用诊断.csv")
	d file.Open("NWS")
	;^TMPSTRUCHISDESC(LocDesc,Fre,Diag)
	s LocDesc=""
	for
	{
		s LocDesc=$o(^TMPSTRUCHISDESC(LocDesc))
		q:LocDesc=""
		s Fre=""
		for
		{
			s Fre=$o(^TMPSTRUCHISDESC(LocDesc,Fre),-1)
			q:Fre=""
			s Diag=""
			for
			{
				s Diag=$o(^TMPSTRUCHISDESC(LocDesc,Fre,Diag))
				q:Diag=""
				d file.Write(LocDesc)
				d file.Write(",")
				d file.Write(Fre)
				d file.Write(",")
				d file.Write(Diag)
				d file.WriteLine()
			}
			
		}
		
	}
	d file.%Save()
	d file.%Close()
	q ""
}

/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).TestCount()
ClassMethod TestCount()
{
	s sum=0
	s rowid=""
	for
	{
		s rowid=$o(^TMPSTRUCDESC(rowid))
		q:rowid=""
		s sum=sum+1
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-03-15
/// Description：数据处理工厂子表字符串拼串
/// Table：User.MKBStructuredDataResult
/// Input：父表id 
/// Return：
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetValueFormat()
ClassMethod GetValueFormat(ProperyDr, SDSValue)
{
	q:SDSValue="" ""
	s result=""
	//生成临时global，同个属性不同起始节点下的便于分组
	k ^TMPCONVERTRESULT("FormatValue")
	s TermDR=$LISTGET($G(^User.MKBTermPropertyD(ProperyDr)),6) 
	if TermDR=""
	{
		w ProperyDr,!
		q ""
	} 
	d ..GetPropertyByNode(TermDR)
	s len=$Length(SDSValue,"^")
	
	for j=1:1:len{
		s progroup=$p(SDSValue,"^",j)
		s key=$p(progroup,":",1)
		s value=$p(progroup,":",2)
		if (key["M")
		{
			if key["D"     //术语
			{
				s termid=$tr($tr(key,"D",""),"TM","") 
				s terDesc=$lg($g(^User.MKBTermD(termid)),3)
				s sign=0
				s property=""
				for
				{
					s property=$o(^User.MKBTermPropertyI("TermIndex",TermDR,property))
					q:property=""
					s propertydesc=$lg($g(^User.MKBTermPropertyD(property)),2)
					
					if propertydesc=terDesc
					{
						s detailLen=$Length(value,"&")
						for k=1:1:detailLen
						{
							s detailid=$p(value,"&",k)
							s ^TMPCONVERTRESULT("FormatValue","S",property,detailid)=""
							s sign=1
						}
					}
				}
				if sign=0
				{
					s termbase=$lg($g(^User.MKBTermD(termid)),4)
					s termbaseflag=$lg($g(^User.MKBTermBaseD(termbase)),10)  //获取termbase的标识
					if termbaseflag["Part"
					{
						s property=""
						for
						{
							s property=$o(^User.MKBTermPropertyI("TermIndex",TermDR,property))
							q:property=""
							s propertydesc=$lg($g(^User.MKBTermPropertyD(property)),2)
							
							if propertydesc="部位"
							{
								s detailLen=$Length(value,"&")
								for k=1:1:detailLen
								{
									s detailid=$p(value,"&",k)
									s ^TMPCONVERTRESULT("FormatValue","S",property,detailid)=""	
								}
							}
						}	
					}
					if termbaseflag["Pathogeny"
					{
						s property=""
						for
						{
							s property=$o(^User.MKBTermPropertyI("TermIndex",TermDR,property))
							q:property=""
							s propertydesc=$lg($g(^User.MKBTermPropertyD(property)),3)
							
							if propertydesc="病因"
							{
								s detailLen=$Length(value,"&")
								for k=1:1:detailLen
								{
									s detailid=$p(value,"&",k)
									s ^TMPCONVERTRESULT("FormatValue","S",property,detailid)=""
								}
							}
						}
					}
				}
				
			}
			else   //Termbase
			{
				s termbase=$tr($tr(key,"TM",""),"M","") 
				s termbasedesc=$lg($g(^User.MKBTermBaseD(termbase)),3)
				s property=""
				for
				{
					s property=$o(^User.MKBTermPropertyI("TermIndex",TermDR,property))
					q:property=""
					s propertydesc=$lg($g(^User.MKBTermPropertyD(property)),2)
					if propertydesc[termbasedesc
					{
						s detailLen=$Length(value,"&")
						for k=1:1:detailLen
						{
							s detailid=$p(value,"&",k)
							s ^TMPCONVERTRESULT("FormatValue","S",property,detailid)=""	
						}
					}
				}
			}

		}	
		elseif (key["S"){ //引用术语类型
			s proid=$tr($tr(key,"TS",""),"S","") 
			continue:(proid="")
			s detailLen=$Length(value,"&")
			for k=1:1:detailLen{
				s detailid=$p(value,"&",k)
				s ^TMPCONVERTRESULT("FormatValue","S",proid,detailid)=""
			}
		}
		elseif (key["D"){//定义起始节点的属性
			s pronodeid=$tr($tr(key,"T",""),"D","") //起始节点id
			s proid=$g(^TEMPPROPERTYNODE("PropertyNode",TermDR,pronodeid)) 
			if proid=""
			{
				s prodiagrowid=$o(^User.MKBTermPropertyI("DescIndex",TermDR," 病情描述",0))
				if prodiagrowid'=""
				{
					s prodetail=""
					for
					{
						s prodetail=$o(^User.MKBTermProDetailI("ProIdx",prodiagrowid,prodetail))
						q:prodetail=""
						if pronodeid=prodetail
						{
							s proid=prodiagrowid
							q
						}
					}
				}
			}
			continue:proid=""
			s detailLen=$Length(value,"&")
			for k=1:1:detailLen{
				s detailid=$p(value,"&",k)
				s ^TMPCONVERTRESULT("FormatValue","D",proid,detailid)=""
			}
		}
		elseif (key["T")
		{
			s proid=$tr(key,"T","")  
			continue:(proid="")
			s detailLen=$Length(value,"&")
			for k=1:1:detailLen{
				s detailid=$p(value,"&",k)
				s ^TMPCONVERTRESULT("FormatValue","D",proid,detailid)=""
			}
		}
	}
	//格式转换
	s flag=""
	for {
		s flag=$o(^TMPCONVERTRESULT("FormatValue",flag)) q:flag=""
		s proid=""
		for {
			s proid=$o(^TMPCONVERTRESULT("FormatValue",flag,proid)) q:proid=""
			s detailItm=""
			s detailid=""
			for {
				s detailid=$o(^TMPCONVERTRESULT("FormatValue",flag,proid,detailid)) q:detailid=""
				if (flag="S"){ //引用术语、引用起始节点
					if (detailItm=""){
						s detailItm="S"_detailid
					}else{
						s detailItm=detailItm_"*S"_detailid
					}
				}else{
					if (detailItm=""){
						s detailItm=detailid
					}else{
						s detailItm=detailItm_"*"_detailid
					}
				}
			}
			if (result=""){
				s result=proid_":"_detailItm
			}else{
				s result=result_","_proid_":"_detailItm
			}
		}
	}
	q result
}

/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetPropertyByNode()
ClassMethod GetPropertyByNode(dia) As %String
{
	q:dia="" ""
	k ^TEMPPROPERTYNODE("PropertyNode",dia)
	s proId=$o(^User.MKBTermPropertyI("DescIndex",dia," 诊断模板",0))  //诊断模板的属性ID 直接根据描述来获取 
	//s proId=$o(^User.MKBTermPropertyI("FlagIndex",dia," DT",0)) //诊断模板的属性ID 直接根据标识来获取    
	if (proId'="")
	{
		s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0)) //属性内容的id
		if (proDetailId'="")
		{
			s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
			if (proDetailDesc'="")
			{
				s argsLen=$Length(proDetailDesc,",")
			    for i=1:1:argsLen   
			    {     
			        s argstr=$p(proDetailDesc,",",i)  
			        s catRowId=$p(argstr,"&",1)  //术语属性id 或者术语id 
			        s showType=$p(argstr,"&",2) //展示类型
			        s treeNode=$p(argstr,"&",3) //定义起始节点
			        s:treeNode="undefined" treeNode=""
			        if (treeNode'=""){
				        s ^TEMPPROPERTYNODE("PropertyNode",dia,treeNode)=catRowId
				    }
			    }
			}
		}	
	}
	q 1
}

/// Creator:李得原
/// CreatDate:2019-03-13
/// Description:把数据处理工厂子表的结构化结果ID串改变拼串方式
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeResultIDString()
ClassMethod ChangeResultIDString()
{
	Ts
	s PRowid=0
	for
	{
		s PRowid=$o(^User.MKBStructuredDataD(PRowid))
		q:PRowid=""
		s CRowid=0
		for
		{
			s CRowid=$o(^User.MKBStructuredDataD(PRowid,"MKBSDStructResult",CRowid))
			q:CRowid=""
			s ResultId=$lg($g(^User.MKBStructuredDataD(PRowid,"MKBSDStructResult",CRowid)),2)
			s PropertyDr=$lg($g(^User.MKBStructuredDataD(PRowid,"MKBSDStructResult",CRowid)),4)
			b:PropertyDr=""
			s results=##class(web.DHCBL.MKB.MKBStructedDiag).GetValueFormat(PropertyDr,ResultId)
			if results=""
			{
				;results=""
			}
			s ChildRowid=PRowid_"||"_CRowid
			s obj=##class(User.MKBStructuredDataResult).%OpenId(ChildRowid)
			s obj.MKBSDStructResultID=results
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-13
/// Description:把HISICD子表的结构化结果ID串改变拼串方式
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeHISResultIDString()
ClassMethod ChangeHISResultIDString()
{
	Ts
	s HISPareRowid=0
	for
	{
		s HISPareRowid=$o(^User.MKBHISICDContrastD(HISPareRowid))
		q:HISPareRowid=""
		s HISChildRowid=0
		for
		{
			s HISChildRowid=$o(^User.MKBHISICDContrastD(HISPareRowid,"MKBHISICDContrastResult",HISChildRowid))
			q:HISChildRowid=""
			s PropertyDr=$lg($g(^User.MKBHISICDContrastD(HISPareRowid,"MKBHISICDContrastResult",HISChildRowid)),4)
			s ResultID=$lg($g(^User.MKBHISICDContrastD(HISPareRowid,"MKBHISICDContrastResult",HISChildRowid)),2)
			if PropertyDr=""
			{
				w "PropertyDr is null",!
			}
			continue:PropertyDr=""  ;propertydr=""
			s results= ##class(web.DHCBL.MKB.MKBStructedDiag).GetValueFormat(PropertyDr,ResultID)
			s rowid=HISPareRowid_"||"_HISChildRowid
			
			s obj=##class(User.MKBHISICDContrastResult).%OpenId(rowid)
			s obj.MKBHISICDConResultID=results
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s a=1
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-21
/// Description:把ICD子表的结构化结果ID串改变拼串方式
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeICDResultIDString()
ClassMethod ChangeICDResultIDString()
{
	Ts
	s HISPareRowid=0
	for
	{
		s HISPareRowid=$o(^User.MKBICDContrastD(HISPareRowid))
		q:HISPareRowid=""
		s HISChildRowid=0
		for
		{
			s HISChildRowid=$o(^User.MKBICDContrastD(HISPareRowid,"MKBICDContrastResult",HISChildRowid))
			q:HISChildRowid=""
			s PropertyDr=$lg($g(^User.MKBICDContrastD(HISPareRowid,"MKBICDContrastResult",HISChildRowid)),4)
			s ResultID=$lg($g(^User.MKBICDContrastD(HISPareRowid,"MKBICDContrastResult",HISChildRowid)),2)
			if PropertyDr=""
			{
				w "PropertyDr is null",!
			}
			continue:PropertyDr=""  ;propertydr=""
			s results= ##class(web.DHCBL.MKB.MKBStructedDiag).GetValueFormat(PropertyDr,ResultID)
			s rowid=HISPareRowid_"||"_HISChildRowid
			
			s obj=##class(User.MKBICDContrastResult).%OpenId(rowid)
			s obj.MKBICDConResultID=results
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s a=1
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-13
/// Description:把数据处理工厂子表的propertydr改成Termdr
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangePropertydrToTermdr()
ClassMethod ChangePropertydrToTermdr()
{
	Ts
	s n=0
	s SDRowid=0
	for
	{
		
		s SDRowid=$o(^User.MKBStructuredDataD(SDRowid))
		q:SDRowid=""
		
		s ResultRowid=0
		for
		{
			s ResultRowid=$o(^User.MKBStructuredDataD(SDRowid,"MKBSDStructResult",ResultRowid))
			q:ResultRowid=""
			s id=SDRowid_"||"_ResultRowid
			s MKBSDPropertyDr=$lg($g(^User.MKBStructuredDataD(SDRowid,"MKBSDStructResult",ResultRowid)),4)
			s termdr=$lg($g(^User.MKBTermPropertyD(MKBSDPropertyDr)),6)
			s obj=##class(User.MKBStructuredDataResult).%OpenId(id)
			d obj.MKBSDTermDRSetObjectId(termdr)
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s n=n+1
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q n
}

/// Creator:李得原
/// CreatDate:2019-03-13
/// Description:把数据处理工厂子表的propertydr改成Termdr
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeHISPropertydrToTermdr()
ClassMethod ChangeHISPropertydrToTermdr()
{
	Ts
	s PareRowid=0
	for
	{
		s PareRowid=$o(^User.MKBHISICDContrastD(PareRowid))
		q:PareRowid=""
		s ChildRowid=0
		for
		{
			s ChildRowid=$o(^User.MKBHISICDContrastD(PareRowid,"MKBHISICDContrastResult",ChildRowid))
			q:ChildRowid=""
			s PropertyDr=$lg($g(^User.MKBHISICDContrastD(PareRowid,"MKBHISICDContrastResult",ChildRowid)),4)
			continue:PropertyDr=""
			s termdr=$lg($g(^User.MKBTermPropertyD(PropertyDr)),6)
			s rowid=PareRowid_"||"_ChildRowid
			s obj=##class(User.MKBHISICDContrastResult).%OpenId(rowid)
			d obj.MKBHISICDConTermDrSetObjectId(termdr)
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-13
/// Description:把ICD子表的propertydr改成Termdr
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeICDPropertydrToTermdr()
ClassMethod ChangeICDPropertydrToTermdr()
{
	Ts
	s PareRowid=0
	for
	{
		s PareRowid=$o(^User.MKBICDContrastD(PareRowid))
		q:PareRowid=""
		s ChildRowid=0
		for
		{
			s ChildRowid=$o(^User.MKBICDContrastD(PareRowid,"MKBICDContrastResult",ChildRowid))
			q:ChildRowid=""
			s PropertyDr=$lg($g(^User.MKBICDContrastD(PareRowid,"MKBICDContrastResult",ChildRowid)),4)
			continue:PropertyDr=""
			s termdr=$lg($g(^User.MKBTermPropertyD(PropertyDr)),6)
			continue:termdr=""
			s rowid=PareRowid_"||"_ChildRowid
			s obj=##class(User.MKBICDContrastResult).%OpenId(rowid)
			d obj.MKBICDConTermDrSetObjectId(termdr)
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q ""
}

/// 参考
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetDiagName("")
ClassMethod GetDiagName(parref As %String) As %String
{
	
	s result=""
	//生成属性(含起始节点)及属性内容的临时global
	k ^TMPDIAGNOSCHILD("DiagnosChildNode",parref)
	s SDSTermDR=$LISTGET($G(^User.SDSStructDiagnosD(parref)),2) //术语id
	;d ..GetPropertyByNode(SDSTermDR)
	s rowid=""
	for {
	 	s rowid=$o(^User.SDSStructDiagnosPropertyD(parref,rowid)) q:rowid=""
	 	s SDSPropertyDR=$LISTGET($G(^User.SDSStructDiagnosPropertyD(parref,rowid)),2)
	 	s SDSProDetail=$LISTGET($G(^User.SDSStructDiagnosPropertyD(parref,rowid)),3)
	 	s SDSFlag=$LISTGET($G(^User.SDSStructDiagnosPropertyD(parref,rowid)),4)
		;s DetailNode=..GetDetailNode(SDSTermDR,SDSProDetail)
		s:DetailNode'="" DetailTitleNode=$LISTGET($G(^User.MKBTermProDetailD(DetailNode)),4)  //诊断模板定义的起始节点
		s:DetailNode="" DetailTitleNode=""
		if (DetailTitleNode'=""){
			s ^TMPDIAGNOSCHILD("DiagnosChildNode",parref,SDSFlag,DetailTitleNode,SDSProDetail)=""
		}else{
			s ^TMPDIAGNOSCHILD("DiagnosChildNode",parref,SDSFlag,SDSPropertyDR,SDSProDetail)=""
		}
	}
	s flag=""
	for {
		s flag=$o(^TMPDIAGNOSCHILD("DiagnosChildNode",parref,flag)) q:flag=""
		s keyid=""
		for {
			s keyid=$o(^TMPDIAGNOSCHILD("DiagnosChildNode",parref,flag,keyid)) q:keyid=""
			s detailItm=""
			s detailid=""
			for{
				s detailid=$o(^TMPDIAGNOSCHILD("DiagnosChildNode",parref,flag,keyid,detailid)) q:detailid=""
				//单个属性多选以顿号分隔
				if (flag="D"){
					if ($d(^TEMPPROPERTYNODE("PropertyNode",SDSTermDR,keyid))){
						s propertyid=$g(^TEMPPROPERTYNODE("PropertyNode",SDSTermDR,keyid))
					}else{
						s propertyid=keyid
					}
					//获取属性常用名别名
					s detailDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(detailid,propertyid,"展示名") 
					s:detailDesc="" detailDesc=$listGet($g(^User.MKBTermProDetailD(detailid)),3)
					if (detailItm=""){
						s detailItm=detailDesc
					}else{
						s detailItm=detailItm_"、"_detailDesc
					}
				}else{
					if (detailItm=""){
						s detailItm=$listGet($g(^User.MKBTermD(detailid)),3)
					}else{
						s detailItm=detailItm_"、"_$listGet($g(^User.MKBTermD(detailid)),3)
					}
				}	
			}
			//其他结构化描述加括号
			if ($d(^TEMPPROPERTYNODE("PropertyNode",SDSTermDR,keyid))){
				if ($listGet($g(^User.MKBTermProDetailD(keyid)),3)="其他结构化描述"){
					s detailItm="("_detailItm_")"
				}
			}
			//多个属性以逗号分隔
			if (result=""){
				s result=detailItm	
			}else{
				s result=result_"，"_detailItm	
			}
		}
	}
	//增加补充诊断，加括号
	s SDSSupplement=$LISTGET($G(^User.SDSStructDiagnosD(parref)),6)
	if (SDSSupplement'=""){
		s result=result_",("_SDSSupplement_")"
	}
	
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(SDSTermDR)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s comDesc=$p(strCom,"&%",1) //诊断常用名
	s:comDesc="" comDesc=$listGet($g(^User.MKBTermD(SDSTermDR)),3) //诊断中心词
	if (result'=""){
		s result=comDesc_"["_result_"]"	
	}else{
		s result=comDesc
	}
	q result
}

/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).CheckWhetherTermSameMrc()
ClassMethod CheckWhetherTermSameMrc()
{
	s sum=0
	s basedr=$o(^User.MKBTermBaseI("DescIndex"," 诊断_安贞ICD",0))
	s term=""
	for
	{
		s term=$o(^User.MKBTermI("DescIndex",basedr,term))
		q:term=""
		s termdesc=$zstrip(term,"<>W")
		;s Diagid=$o(^MRC("ID",0,"Desc",Diag,Diagid))
		s termdesc=$$ALPHAUP^SSUTIL4(termdesc)
		if $d(^MRC("ID",0,"Desc",termdesc))
		{
			s sum=sum+1
		}
		else
		{
			w term
		}
	}
	q sum
}

ClassMethod SaveAll()
{
	s MKBHICRRowId=0
	for
	{
		s MKBHICRRowId=$O(^User.MKBHISICDContrastD(MKBHICRRowId))
		q:MKBHICRRowId=""
		
		s ChildSub=0
		for
		{
			s ChildSub=$O(^User.MKBHISICDContrastD(MKBHICRRowId,"MKBHISICDContrastResult",ChildSub))
			q:ChildSub=""
			
			s TermId=$LG($G(^User.MKBHISICDContrastD(MKBHICRRowId,"MKBHISICDContrastResult",ChildSub)))	
		}
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).RemoveAnzhen()
ClassMethod RemoveAnzhen()
{
	Ts
	s Rowid=0
	for
	{
		s Rowid=$o(^User.MKBStructuredDataD(Rowid))
		q:Rowid=""
		s LocRowid=0
		for
		{
			s LocRowid=$o(^User.MKBStructuredDataD(Rowid,"MKBSDStructLoc",LocRowid))
			q:LocRowid=""
			s rowid=Rowid_"||"_LocRowid
			s obj=##class(User.MKBStructuredDataLoc).%OpenId(rowid)
			s loc=obj.MKBSDLoc
			if loc["(安贞)"
			{
				s ExactLoc=$e(loc,0,*-4)
				s obj.MKBSDLoc=ExactLoc
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					
				}
				else
				{
					set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b ;error
				}
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-27
/// Description:1.在原数据处理工厂的数据中加入出院诊断标识
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertLocFlagToOutDiag()
ClassMethod InsertLocFlagToOutDiag()
{
	Ts
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDDiaSource="出院"
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b ;error
		}
	}
}

/// Creator:李得原
/// CreatDate:2019-03-28
/// Description:2.把科室、频次的拼串解开，存入到数据处理工厂子表中
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).MigrateLocFreToSonTable()
ClassMethod MigrateLocFreToSonTable()
{
	Ts
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s Fre=obj.MKBSDFrequency
		s Loc=obj.MKBSDLoc
		s FreLen=$l(Fre,",")
		s LocLen=$l(Loc,",")
		b:FreLen'=LocLen
		for i=1:1:FreLen
		{
			s f=$p(Fre,",",i)
			s l=$p(Loc,",",i)
			s Exactloc=$e(l,0,*-4)
			s sobj=##class(User.MKBStructuredDataLoc).%New()
			d sobj.MKBSDStructDataSetObjectId(MKBSDRowid)
			s sobj.MKBSDFrequency=f
			s sobj.MKBSDLoc=Exactloc
			s sobj.MKBSDLocSource="L"
			s sc=sobj.%Save()
			d sobj.%Close()
			if $$$ISOK(sc)
			{
				
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;error
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-28
/// Description:3.匹配是否已存在,父表标识拼串,子表科室对应频次，
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).SaveEmergencyData()
ClassMethod SaveEmergencyData()
{
	Ts
	s Desc=""
	for
	{
		s Desc=$o(^TempDiag(Desc))
		q:Desc=""
		s AlphaUpDesc=$zconvert(Desc,"U")
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_AlphaUpDesc))    ///已经存在的诊断
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_AlphaUpDesc,0))
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s Type=obj.MKBSDDiaSource
			s NewType=Type_"&"_"门急诊"
			s obj.MKBSDDiaSource=NewType
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ;open error
			}
			s Loc=""
			for
			{
				s Loc=$o(^TempDiag(Desc,Loc))
				q:Loc=""
				s Fre=^TempDiag(Desc,Loc)
				s sobj=##class(User.MKBStructuredDataLoc).%New()
				s sobj.MKBSDLoc=Loc
				s sobj.MKBSDFrequency=Fre
				s sobj.MKBSDLocSource="O"
				d sobj.MKBSDStructDataSetObjectId(MKBSDRowid)
				s ssc=sobj.%Save()
				d sobj.%Close()
				if $$$ISOK(ssc)
				{
					
				}
				else
				{
					set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(ssc)_"'}"
					b ;Loc open error
				}
			}
		}
		else      ///不存在的诊断
		{
			s obj=##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiaSource="门急诊"
			s obj.MKBSDDiag=Desc
			s obj.MKBSDStatus="N"
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=""
				set id=obj.%Id()
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b ; new error
			}
			s Loc=""
			for
			{
				s Loc=$o(^TempDiag(Desc,Loc))
				q:Loc=""
				s Fre=^TempDiag(Desc,Loc)
				s sobj=##class(User.MKBStructuredDataLoc).%New()
				s sobj.MKBSDLoc=Loc
				s sobj.MKBSDFrequency=Fre
				s sobj.MKBSDLocSource="O"
				d sobj.MKBSDStructDataSetObjectId(id)
				s ssc=sobj.%Save()
				d sobj.%Close()
				if $$$ISOK(ssc)
				{
					
				}
				else
				{
					set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(ssc)_"'}"
					b ;Loc new error
				}
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-03-28
/// Description:4.已有分词的跳过，没有分词的导入到数据处理工厂子表，
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertSeg()
ClassMethod InsertSeg()
{
	Ts
	s sumyes=0
	s sumno=0
	s file=##class(%File).%New("D:\工作\2019-03-25\门急诊诊断分词.csv")
	d file.Open("RS")
	d file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s SegDiag=$p(Line,",",1)
		s SegWord=$p(Line,",",2)
		s SegProperty=$p(Line,",",3)
		s SegDesc=$zcvt(SegDiag,"U")
		s SegDesc=$zstrip(SegDesc,"<>W")
		s rowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_SegDesc,0))
		s seg=$lg($g(^User.MKBStructuredDataD(rowid)),9)
		if seg'=""
		{
			s sumyes=sumyes+1
			continue	
		}
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)
		s obj.MKBSDSegmentation=SegWord_SegProperty
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s sumno=sumno+1
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b ;Seg error
		}
	}
	d file.%Close()
	q "有分词的"_sumyes_","_"没有分词的"_sumno
}

/// Creator:李得原
/// CreatDate:2019-03-28
/// Description:5.已有参考中心词的跳过，没有参考中心词的导入到数据处理工厂子表，
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertWord()
ClassMethod InsertWord()
{
	;^TempTermData(DiagTemp,MKBTRowid)=""
	s sumyes=0
	s sumno=0
	s Desc=""
	for
	{
		s Desc=$o(^TempTermData(Desc))
		q:Desc=""
		s DescWord=$zconvert(Desc,"U")
		s rowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_DescWord,0))
		s Word=$lg($g(^User.MKBStructuredDataD(rowid)),6)
		if Word'=""
		{
			s sumyes=sumyes+1
			continue	
		}
		s WordStr=""
		s WordRowid=0
		for
		{
			s WordRowid=$o(^TempTermData(Desc,WordRowid))
			q:WordRowid=""
			s:WordStr'="" WordStr=WordStr_","_WordRowid
			s:WordStr="" WordStr=WordRowid
		}
		s obj=##class(User.MKBStructuredData).%OpenId(rowid)
		s obj.MKBSDCenterWordID=WordStr
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s sumno=sumno+1
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b ;Seg error
		}
		
	}
	w "存在有"_sumyes,!
	w "新存入有"_sumno
	q ""
}

/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).Factory()
ClassMethod Factory()
{
	s obj=##class(User.MKBStructuredData).%OpenId("3597")
	s a=obj.MKBSDDiag
	s b=##class(web.DHCBL.BDP.FunLib).EvalJSON(a)
	s obj.MKBSDDiag=b
	s sc=obj.%Save()
	d obj.%Close()
	if $$$ISOK(sc)
	{
		;s sumno=sumno+1
	}
	else
	{
		set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
		b ;Seg error
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-13
/// Description:把语料库临床用语数据导入数据处理工厂
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertLibrary()
ClassMethod InsertLibrary()
{
	k ^TEMPPPP
	k ^TEMPMATCHED
	s chongfu=0
	Ts
	s a=0
	s NoMatch=0
	s InButNoMatch=0
	s InAndMatch=0
	s NotInButMatch=0
	s NotInAndNotMatch=0
	s file=##class(%File).%New("D:\工作\2019-04-08\11-15安贞医院语料处理完成表-临床用语.csv")
	d file.Open("RS")
	s str=file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s LibraryAlias=$p(Line,",",1)
		s LibraryDesc=$p(Line,",",2)
		s LibraryICD=$p(Line,",",3)
		s LibraryChinese=$p(Line,",",4)
		continue:LibraryDesc=""
		s a=a+1
		s LibraryDesc=$zstrip(LibraryDesc,"<>W")
		s LibraryChinese=$zstrip(LibraryChinese,"<>W")
		s LibraryDesc=##class(web.DHCBL.MKB.MKBStructedDiag).EvalJSON(LibraryDesc)
		
		s LibraryICD=$zstrip(LibraryICD,"<>W")
		s CaptionDesc=$zconvert(LibraryDesc,"U")
		s CaptionChinese=$zconvert(LibraryChinese,"U")
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDesc))   //如果已存在数据处理工厂
		{
			s flag=0
			s MRCRowid=0
			for
			{
				s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(CaptionChinese),MRCRowid))  
				q:MRCRowid=""
				s MRCICD=$p(^MRC("ID",MRCRowid),"^",4)
				s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
				
				s MRCICD=$zstrip(MRCICD,"<>W")
				s MRCDesc=$zstrip(MRCDesc,"<>W")
				if ((MRCICD=LibraryICD)&(LibraryChinese=MRCDesc))   //如果匹配上MRC
				{
					
					s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDesc,0))
					b:MKBSDRowid=""
					s mrcdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
					Continue:mrcdr'=""
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					d obj.MKBSDMRCDrSetObjectId(MRCRowid)
					if LibraryAlias'=""
					{
						s obj.MKBSDAlias=LibraryAlias
					}
					s temp=obj.MKBSDDiaSource
					if temp'["临床用语"
					{
						s tempa=temp_"&"_"临床用语"
						s obj.MKBSDDiaSource=tempa
					}
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						s flag=1
						s InAndMatch=InAndMatch+1
						s ^TEMPMATCHED("MATCHED",MKBSDRowid)=""
						q
					}
					else
					{
						set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ;1 error
					}
				}
			}
			if flag=0
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDesc,0))
				b:MKBSDRowid=""
				s Source=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
				if Source["临床用语"
				{
						s chongfu=chongfu+1	
				}
				else
				{
					
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					s temp=obj.MKBSDDiaSource
					s tempa=temp_"&"_"临床用语"
					if LibraryAlias'=""
					{
						s obj.MKBSDAlias=LibraryAlias
					}
					s obj.MKBSDDiaSource=tempa
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						
					}
					else
					{
						set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ;2 error
					}
				}
				s InButNoMatch=InButNoMatch+1
			}
			
		}
		else  //数据处理工厂中不存在
		{
			s flag=0
			s MRCRowid=0
			for
			{
				s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(CaptionChinese),MRCRowid))  
				q:MRCRowid=""
				s MRCICD=$p(^MRC("ID",MRCRowid),"^",4)
				s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
				s MRCICD=$zstrip(MRCICD,"<>W")
				s MRCDesc=$zstrip(MRCDesc,"<>W")
				
				if ((MRCICD=LibraryICD)&(MRCDesc=LibraryChinese))   //如果匹配上MRC
				{
					s obj=##class(User.MKBStructuredData).%New()
					s obj.MKBSDDiag=LibraryDesc
					s obj.MKBSDDiaSource="临床用语"
					if LibraryAlias'=""
					{
						s obj.MKBSDAlias=LibraryAlias
					}
					d obj.MKBSDMRCDrSetObjectId(MRCRowid)
					s obj.MKBSDStatus="N"
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						s id=obj.%Id()
						s flag=1
						s NotInButMatch=NotInButMatch+1
						s ^TEMPPPP("NotInFactoryButMatchMRC",id)=""
						s ^TEMPMATCHED("MATCHED",id)=""
						q
					}
					else
					{
						set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ;3 error
					}
				}
			}
			if flag=0      //如果没有匹配上MRC
			{
				s obj=##class(User.MKBStructuredData).%New()
				s obj.MKBSDDiag=LibraryDesc
				s obj.MKBSDDiaSource="临床用语"
				if LibraryAlias'=""
				{
					s obj.MKBSDAlias=LibraryAlias
				}
				s obj.MKBSDStatus="N"
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s ^TEMPPPP("NotInFactoryAndNotMatchMRC",id)=""
					s NotInAndNotMatch=NotInAndNotMatch+1
					
				}
				else
				{
					set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
					b ;4 error
				}
			}	
		}
	}
	d file.%Close()
	w "存在数据处理工厂，但没有匹配到MRC："_InButNoMatch,!
	w "存在数据梳理工厂，而且匹配到MRC："_InAndMatch,!
	w "不存在数据处理工厂，而且没有匹配到MRC："_NotInAndNotMatch,!
	w "不存在数据处理工厂，但匹配到MRC："_NotInButMatch,!
	w "chongfu"_chongfu,!
	w a
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-03
/// Description:数据处理工厂出院诊断和门急诊匹配MRC的指向
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).OutEmergencyMapToMRC()
ClassMethod OutEmergencyMapToMRC()
{
	Ts
	s Sum=0
	s Match=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		/*
		if ($d(^TEMPMATCHED("MATCHED",MKBSDRowid)))
		{
			//已经匹配过MRC，跳过
		}
		*/
		s mrcdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if mrcdr'=""
		{	
			//已经匹配过MRC，跳过
		}
		else
		{
			s Sum=Sum+1
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MRCRowid=0
			for
			{
				s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(MKBSDDesc),MRCRowid))  
				q:MRCRowid=""
				s MRCICD=$p(^MRC("ID",MRCRowid),"^",4)
				s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
				s MRCICD=$zstrip(MRCICD,"<>W")
				s MRCDesc=$zstrip(MRCDesc,"<>W")
				if (MRCDesc=MKBSDDesc) //如果匹配上MRC
				{
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					d obj.MKBSDMRCDrSetObjectId(MRCRowid)
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						s Match=Match+1
						q
					}
					else
					{
						set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ;2 error
					}
				}
			}
		}
		
	}
	w "一共门急诊和出院(除去语料库已经匹配上的)："_Sum,!
	w "匹配上"_Match,!
	q ""
}

/// 把数据处理工厂中，没有匹配到mrC的数据导出到excel
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportNoMRC()
ClassMethod ExportNoMRC()
{
	s sum=0
	s file=##class(%File).%New("D:\工作\2019-04-08\没有匹配到MRC的数据.csv")
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		
		s mrcdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if mrcdr=""
		{
			s sum=sum+1
			s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s desc=..EvalJSON(Diag)
			d file.Write(desc)
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-03
/// Description:把语料库的新建数据导入到excel
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportLibraryNewtoExcel()
ClassMethod ExportLibraryNewtoExcel()
{
	;^TEMPPPP("NotInFactoryAndNotMatchMRC",MKBSDRowid)
	;^TEMPPPP("NotInFactoryButMatchMRC",MKBSDRowid)
	s file=##class(%File).%New("D:\工作\2019-04-08\NewData.csv")
	d file.Open("NWS")
	s NodeSum=0
	s node=""
	for
	{
		s node=$o(^TEMPPPP(node))
		q:node=""
		s NodeSum=NodeSum+1
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^TEMPPPP(node,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s Desc=##class(web.DHCBL.MKB.MKBStructedDiag).EvalJSON(MKBSDDesc)
			d file.Write(Desc)
			d file.WriteLine()
			//b:MKBSDDesc="先天性肺动脉瓣钙化中度狭窄"
		}
	}
	d file.%Save()
	d file.%Close()
	q NodeSum
}

/// Creator:李得原
/// CreatDate:2019-04-09
/// Description:处理数据的不可见符号
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).EvalJSON()
ClassMethod EvalJSON(instr As %String) As %String
{
	s mystr = instr
	q:(mystr="") mystr	
	s mystr=$tr(mystr,"'","")	
	s mystr=$tr(mystr,"""","")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(13),"")
	s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(10),"")	
	s mystr = ##class(web.BDP.util.String).Replace(mystr,"\","\\")	
	for i=0:1:31
	{
		continue:i=10
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(i),"")
	}
	for i=158:1:170
	{
		s mystr = ##class(web.BDP.util.String).Replace(mystr,$c(i),"")
	}
	q mystr
}

/// Creator:李得原
/// CreatDate:2019-04-03
/// Description:把语料库的新建数据进行参考中心词匹配
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportLibraryNewMatchWord()
ClassMethod ExportLibraryNewMatchWord()
{
	k ^TempTermData
	s NodeSum=0
	s m=0
	s node=""
	for
	{
		s node=$o(^TEMPPPP(node))
		q:node=""
		s NodeSum=NodeSum+1
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^TEMPPPP(node,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s DiagTemp=$Zstrip(MKBSDDesc,"<>W")
			set MKBTBRowid=$o(^User.MKBTermBaseI("FlagIndex"," DIAGNOSE",0))
			s MKBTRowid = 0
			for
			{
				set MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
				quit:MKBTRowid="" 
				set TermData=$lg($g(^User.MKBTermD(MKBTRowid)),3)  ;获取中心词
				if DiagTemp[TermData
				{
					s ^TempTermData(MKBSDRowid,MKBTRowid)=""     ;存储中心词rowid
					s m=m+1
				}
				else
				{
					set AliasItem=""
					;获取未匹配到的中心词的别名
					s AliasNum=0
					set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)    
					set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
					set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
					s n=0
					for i=1:1:AliasNum
					{
						set AliasItem=$p(TermDataAlias,",",i)
						if DiagTemp[AliasItem
						{
							s ^TempTermData(MKBSDRowid,MKBTRowid)=""
							s n=n+1
							if n=1
							{
								s m=m+1
							}
						}
					}
				}
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-03
/// Description:把语料库的新建数据进行参考中心词匹配后导入到数据处理工厂父表
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertNewMatchWord()
ClassMethod InsertNewMatchWord()
{
	s MKBSDDesc=0
	for
	{
		s MKBSDDesc=$o(^TempTermData(MKBSDDesc))
		q:MKBSDDesc=""
		s str=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^TempTermData(MKBSDDesc,MKBTRowid))
			q:MKBTRowid=""
			s:str'="" str=str_","_MKBTRowid
			s:str="" str=MKBTRowid
		}
		s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$zconvert(MKBSDDesc,"U"),0))
		b:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDCenterWordID=str
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; error
		}
	}
	q ""
}

/// 诊断数据的接口：将结构化ID串转换为中文描述
/// Input：ids：结构化ID串
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs("14965:329627","15632")
ClassMethod GetChiForStrucIDs(ids, termdr)
{
	s result=""
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termdr)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s result=$p(strCom,"&%",1) //诊断常用名
	if result=""
	{
		s result=$lg($g(^User.MKBTermD(termdr)),3)
	}
	
	if ids'=""
	{
		s ValueString=""
		s ResultLen=$l(ids,",")
		for i=1:1:ResultLen
		{
			s Result=$p(ids,",",i)
			s key=$p(Result,":",1)
			s values=$p(Result,":",2)
			if ('$d(^User.MKBTermPropertyD(key)))
			{
				continue
			}
			if values["S"
			{
				s ValueLen=$l(values,"*")
				
				for j=1:1:ValueLen
				{
					s ValueDr=$p(values,"*",j)
					s ValueDr=$tr(ValueDr,"S","")
					s Value=$lg($g(^User.MKBTermD(ValueDr)),3)
					if ValueString'=""
					{
						s ValueString=ValueString_","_Value
					}
					if ValueString=""
					{
						s ValueString=Value
					}
				}
			}
			else
			{
				s ValueLen=$l(values,"*")
				for j=1:1:ValueLen
				{
					s ValueDr=$p(values,"*",j)
					s Value=$lg($g(^User.MKBTermProDetailD(ValueDr)),3)
					if ValueString'=""
					{
						s ValueString=ValueString_","_Value
					}
					if ValueString=""
					{
						s ValueString=Value
					}
				}
			}
		}
		s result=result_"["_ValueString_"]"	
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-04-04
/// Description:二、数据处理工厂未结构化数据与北京版版已结构化匹配，自动结构化
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoConstrcuctFactory()
ClassMethod AutoConstrcuctFactory()
{
	Ts
	s start=$zdt($now())
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		if MKBSDStatus="N"
		{
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBMBase=$o(^User.MKBKLMappingBaseI("DescIndex"," 北京版ICD对照",0))
			;MFRowId = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 中文释义"，0))
			s MKBMFDescRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBase," 中文释义",0))    //列号
			s MKBMFResultRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBase," 诊断",0))     //列号
			s MKBMDNRowid=0
			for
			{
				s MKBMDNRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBase,MKBMDNRowid))   //行号
				q:MKBMDNRowid=""			
				s MKBMDVRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBMDNRowid,MKBMBase_"||"_MKBMFResultRowid,0))
				q:MKBMDVRowid=""
				s ValueResult=$lg($g(^User.MKBKLMappingDetailD(MKBMDVRowid)),2)
				if ValueResult'=""
				{
					s MKBMDVDiagRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBMDNRowid,MKBMBase_"||"_MKBMFDescRowid,0))
					s ValueDesc=$lg($g(^User.MKBKLMappingDetailD(MKBMDVDiagRowid)),2)
					s Desc=$lg($g(^User.MKBTermD(ValueDesc)),3)
					s Desc=$zstrip(Desc,"<>W")
					if Desc=MKBSDDesc
					{
						s sum=sum+1
						s str=""
						s Length=$l(ValueResult,";&")
						for i=1:1:Length
						{
							s Termdr=""
							s str=""
							s OnePiece=$p(ValueResult,";&",i)
							if OnePiece["-"                     //术语-
							{ 
								s Termdr=$p(OnePiece,"-",1)  
								s other=$p(OnePiece,"-",2)
								s str=other
							}
							elseif OnePiece[":"               //属性
							{
								s str=OnePiece
							}
							else
							{                                                                   
								s Termdr=OnePiece
							}
							s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowid,"",str,"",Termdr,"")
							if result["false"
							{
								b ;savedata
							}
							else
							{
								s flag=1
								s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
								s obj.MKBSDStatus="P"
								s sc=obj.%Save()
								d obj.%Close()
								if $$$ISOK(sc)
								{
									
								}
								else
								{
									set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
									b ; error
								}
							}
						}
					}
				}
			}
		}
	}
	s end=$zdt($now())
	w start_"-->"_end,!
	w sum
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-04
/// Description:一、数据处理工厂未结构化数据与HISICD已结构化匹配，自动结构化
/// 					(1)先HISICD对照匹配（先描述，后ICD，再分词）
/// 					(2)再北京版ICD对照匹配（先描述，后ICD，再分词）
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).HISICDAutoConstrcuctFactory()
ClassMethod HISICDAutoConstrcuctFactory()
{
	Ts
	s start=$zdt($now())
	s SumNo=0
	s SumYes=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		if '$d(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid))     //遍历未结构化的数据处理工厂数据
		{	
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDMRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			s MKBSDICD=""
			s:MKBSDMRC'="" MKBSDICD=$p(^MRC("ID",MKBSDMRC),"^",4)
			s MKBSDSeg=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
			
			s flag=0                //用来标识是否已经完成结构化
			s HISICDRowid=0
			for
			{
				s HISICDRowid=$o(^User.MKBHISICDContrastI("StatusIndex","Y",HISICDRowid))
				q:HISICDRowid=""
				s HISICDStatus=$lg($g(^User.MKBHISICDContrastD(HISICDRowid)),7)

				s HISICDMRC=$lg($g(^User.MKBHISICDContrastD(HISICDRowid)),2)
				s HISICDDesc=$p(^MRC("ID",HISICDMRC),"^",2)      //取HISICD描述
				s HISICDICD=$p(^MRC("ID",HISICDMRC),"^",4)		//取HISICD编码
				s HISDesc=$zstrip(HISICDDesc,"<>W")
				if HISDesc=MKBSDDesc                        //1.HISICD对照：如果描述相同
				{
					s HISICDResultRowid=0
					for
					{
						s HISICDResultRowid=$o(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid))
						q:HISICDResultRowid=""
						s ResultID=$lg($g(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid)),2)
						s Termdr=$lg($g(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid)),4)
						s Supplement=$lg($g(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid)),5)
						s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowid,"",ResultID,"",Termdr,Supplement)     //子表保存方法
						if result["false"
						{
							b ;savedata
						}
						else
						{
							s flag=1
							s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
							s obj.MKBSDStatus="P"
							s sc=obj.%Save()
							d obj.%Close()
							if $$$ISOK(sc)
							{
								
							}
							else
							{
								set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
								b ; error
							}
						}
					}
				}
			}
			if flag=0           //如果描述不同，则继续进行匹配
			{	
				s HISICDRowid=0
				for
				{
					s HISICDRowid=$o(^User.MKBHISICDContrastI("StatusIndex","Y",HISICDRowid))
					q:HISICDRowid=""
					s HISICDStatus=$lg($g(^User.MKBHISICDContrastD(HISICDRowid)),7)

					    //如果数据处理工厂中有ICD，则通过ICD进行匹配
					s HISICDMRC=$lg($g(^User.MKBHISICDContrastD(HISICDRowid)),2)
					s HISICDSeg=$lg($g(^User.MKBHISICDContrastD(HISICDRowid)),6)
					s HISICDDesc=$p(^MRC("ID",HISICDMRC),"^",2)      //取HISICD描述
					s HISICDICD=$p(^MRC("ID",HISICDMRC),"^",4)		//取HISICD编码
					if ((HISICDICD=MKBSDICD)||(HISICDSeg=MKBSDSeg))
					{
						s HISICDResultRowid=0
						for
						{
							s HISICDResultRowid=$o(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid))
							q:HISICDResultRowid=""
							s ResultID=$lg($g(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid)),2)
							s Termdr=$lg($g(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid)),4)
							s Supplement=$lg($g(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDResultRowid)),5)
							s result=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowid,"",ResultID,"",Termdr,Supplement)
							if result["false"
							{
								b
							}
							else
							{
								s flag=1
								s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
								s obj.MKBSDStatus="P"
								s sc=obj.%Save()
								d obj.%Close()
								if $$$ISOK(sc)
								{	
								}
								else
								{
									set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
									b ; error
								}
							}
						}
					}
				}
			}
			if flag=0
			{
				s SumNo=SumNo+1
			}
			else
			{
				s SumYes=SumYes+1
			}
		}
	}
	s end=$zdt($now())
	
	w "没匹配到:"_SumNo,!
	w "匹配到:"_SumYes,!
	w start_"-->"_end
	q ""
}

/// 把数据处理工厂没有匹配到MRC的数据导出到excel
ClassMethod ExportWithOutMRC()
{
	s file=##class(%File).%New("D:\工作\2019-04-10\没有MRC指向的数据.csv")
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MRCMark=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if MRCMark=""
		{
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			d file.Write(MKBSDDesc)
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
}

/// 2019-04-08 数据处理工厂中未处理中存在已处理数据
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).TestAmount()
ClassMethod TestAmount()
{
	s sum=0
	s rowid=0
	for
	{
		s rowid=$O(^User.MKBStructuredDataD(rowid))
		q:rowid=""
		if '$d(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",rowid))
		{
			s sum=sum+1
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-08
/// Description:数据处理工厂导入语料库分词
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertLibrarySegToFactory()
ClassMethod InsertLibrarySegToFactory()
{
	Ts
	s file=##class(%File).%New("D:\工作\2019-04-08\NewData(1).csv")
	d file.Open("RS")
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		q:Line=""
		s Desc=$p(Line,",",1)
		s Word=$p(Line,",",2)
		s Pro=$p(Line,",",3)
		s str=""
		if Pro'=""                 //分词中属性为空
		{
			if Word'=""               //分词中中心词不为空
			{
				s str=Word_"("_Pro_")"
			}
			else                        //有属性无中心词
			{
				s str="("_Pro_")"
			}
		}
		else                         //分词中有属性
		{
			if Word'=""
			{
				s str=Word
			}
		}
		s Desc=$zconvert(Desc,"U")
		s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Desc,0))
		continue:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDSegmentation=str
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; error
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-09
/// Description:数据处理工厂导入语料库别名
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertLibraryAliasToFactory()
ClassMethod InsertLibraryAliasToFactory()
{
	Ts
	s file=##class(%File).%New("D:\工作\2019-04-08\11-15安贞医院语料处理完成表.csv")
	d file.Open("RS")
	d file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		s alias=$p(Line,",",2)
		s desc=$p(Line,",",3)
		continue:alias=""
		s AliasDesc=$zstrip(alias,"<>W")
		s LibraryDesc=$zstrip(desc,"<>W")
		s LibraryCaption=$zconvert(LibraryDesc,"U")
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_LibraryCaption))   //如果已存在数据处理工厂
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_LibraryCaption,0))
			
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s str=obj.MKBSDAlias
			if str'=""
			{
				s str=str_"%%"_AliasDesc
			}
			else
			{
				s str=AliasDesc
			}
			s obj.MKBSDAlias=str
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
				b ; error
			}
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-12
/// Description:数据处理工厂把子表科室总频次存入父表字段
/// Table:
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).SetTotalFreAsColumn()
ClassMethod SetTotalFreAsColumn()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s sum=sum+1
		s TotalFre=0
		s MKBSDLRowid=0
		for
		{
			s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
			q:MKBSDLRowid=""
			s Fre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)
			s TotalFre=TotalFre+Fre
		}
		
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDTotalFreq=TotalFre
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; error
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-14
/// Description:把数据处理工厂诊断短语 结构化结果 ICD ICD中文释义 科室等导出   按频次排序
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportFactoryData()
ClassMethod ExportFactoryData()
{
	s file=##class(%File).%New("D:\工作\2019-04-08\数据处理工厂11.csv")
	d file.Open("NWS")
	d file.Write("诊断短语"_","_"结构化结果"_","_"ICD"_","_"ICD中文释义"_","_"科室"_","_"频次")
	d file.WriteLine()
	s MKBSDFre=""
	for
	{
		s MKBSDFre=$o(^User.MKBStructuredDataI("TotalFreqIndex",MKBSDFre),-1)
		q:MKBSDFre=""
		s MKBSDDesc=""
		for
		{
			s MKBSDDesc=$o(^User.MKBStructuredDataI("TotalFreqIndex",MKBSDFre,MKBSDDesc))
			q:MKBSDDesc=""
			s Diag=$tr(MKBSDDesc,",","，")
			d file.Write(Diag_",")                             //第一列    描述
			s d=$zconvert(MKBSDDesc,"U")
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_d,0))
			s MKBSDMRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			s ICDDesc=""
			s ICDCode=""
			if MKBSDMRC'=""
			{
				s ICDDesc=$p(^MRC("ID",MKBSDMRC),"^",2)
				s ICDCode=$p(^MRC("ID",MKBSDMRC),"^",4)
			}
			s MKBSDResultID=""
			s MKBSDResultTermdr=""
			s Result=""
			
			s ResultString=""
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDResultID=""
				s MKBSDResultTermdr=""
				s Result=""
				s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				if MKBSDResultTermdr'=""
				{
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s Result=$tr(Result,",","，")
				}
				if ResultString'=""
				{	
					 s ResultString=ResultString_"||"_Result
				}
				s:ResultString="" ResultString=Result
				
			}
			if ResultString'=""                                //第二列 结构化结果
			{
				d file.Write(ResultString)
			}
			d file.Write(",")
			if ICDCode'=""
			{
				d file.Write(ICDCode)              //第三列  ICD
			}
			d file.Write(",")
			if ICDDesc'=""
			{
				d file.Write(ICDDesc)              //第四列  ICD中文描述
			}
			d file.Write(",")
			s LocString=""
			s LocRowid=0
			for
			{
				s LocRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid))
				q:LocRowid=""
				s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",LocRowid)),2)
				s:LocString'="" LocString=LocString_"，"_Loc
				s:LocString="" LocString=Loc
			}
			
			if LocString'=""
			{
				d file.Write(LocString)                       //第五列   科室
			}
			d file.Write(",")
			
			if MKBSDFre'=""
			{
				d file.Write(MKBSDFre)
			}
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q ""
}

ClassMethod GetDataForGlobal(basedr, desc)
{
	s result=""
	if (desc'="")
	{
		s desc=$ZCONVERT(desc,"U")
		
		s IDs=0
		for
		{
			s IDs = $O(^User.BDPMKBIndexI("DescIndex"," "_desc,IDs))
			q:IDs=""
			
			///14626D65432	
			if (IDs["D")
			{ 
				s DetailId=$P(IDs,"D",2)

			}
			continue:$D(^User.MKBTermI("BaseIndex",basedr))=0
			
			s:result'="" result=result_","_IDs
			s:result="" result=IDs
		}	
	}
	q result
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:
/// Table:
/// Input:MRCid
/// Return:Term指向，常用名(中心词),结构化结果拼串
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetData()
ClassMethod GetMRCData(MRCid As %String)
{
	s str=""
	s MKBSDRowid=0

	if $d(^User.MKBStructuredDataI("MRCIndex",MRCid))
	{
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MRCIndex",MRCid,MKBSDRowid))
			q:MKBSDRowid=""

			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",0))
			q:MKBSDRRowid=""
			s TermStr=""
			s TermDR=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(TermDR)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s ComName=$p(strCom,"&%",1) //诊断常用名
			s TermDesc=$lg($g(^User.MKBTermD(TermDR)),3)
			if ComName=""     //如果常用名为空，中心词(中心词)
			{
				s TermStr=TermDesc_"("_TermDesc_")"
			}
			else               //如果常用名不为空，常用名(中心词)
			{
				s TermStr=ComName_"("_TermDesc_")"
			}
			s Diag=$Lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MRCDesc=$p(^MRC("ID",MRCid),"^",2)
			if Diag=MRCDesc
			{
				s str=TermDR_"&&"_TermStr_"&&"_MKBSDRowid_"||"_MKBSDRRowid
				q
			}
		}	
	}
	q str
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:比对数据处理工厂中存在的实际科室和医疗_安贞_科室
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).CompareLocs()
ClassMethod CompareLocs()
{
	k ^TEMPLoc
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid))
			q:MKBSDRRowid=""
			s SDLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),2)
			s SDLoc=$zstrip(SDLoc,"<>W")
			s ^TEMPLoc(SDLoc)=""
		}
	}
	
	s sum=0
	s n=""
	for
	{
		s n=$o(^TEMPLoc(n))
		q:n=""
		s sum=sum+1
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:比对数据处理工厂中存在的实际科室和医疗_安贞_科室
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).CountAnzhenLoc()
ClassMethod CountAnzhenLoc()
{
	k ^TEMPLOC
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医疗_科室_安贞",0))
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))
		q:MKBTDesc=""
		s ^TEMPLOC(MKBTDesc)=""
	}
	
	s sum=0
	s n=""
	for
	{
		s n=$o(^TEMPLOC(n))
		q:n=""
		s sum=sum+1
	}
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).CCompare()
ClassMethod CCompare()
{
	s sum=0
	s n=0
	for
	{
		s n=$o(^TEMPLoc(n))
		q:n=""
		if $D(^TEMPLOC(" "_n))
		{
			s sum=sum+1
		}
		else
		{
			b
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:按照实际科室导出数据处理工厂诊断
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportDiagByLoc()
ClassMethod ExportDiagByLoc()
{
	s path="D:\工作\2019-04-15\loc\"
	s file=##class(%File).%New(path_"数据处理工厂"_".csv")
	d file.Open("NWS")
	d file.Write("诊断短语"_","_"结构化结果"_","_"ICD"_","_"ICD中文释义"_","_"频次"_","_"科室")
	d file.WriteLine()
	s sum=0
	s Loc=""
	for
	{
		s Loc=$o(^TEMPLoc(Loc))
		q:Loc=""
		s sum=sum+1
		k ^TEMPDIAG
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s FreCount=0
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid))
				q:MKBSDRRowid=""
				s RealLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),2)
				s RealFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDRRowid)),3)
				if RealLoc=Loc
				{
					s FreCount=FreCount+RealFre
					s ^TEMPDIAG(FreCount,MKBSDRowid)=""
				}
			}
		}


		s Fre=""
		for
		{
			s Fre=$o(^TEMPDIAG(Fre),-1)
			q:Fre=""
			s Rowid=0
			for
			{
				s Rowid=$o(^TEMPDIAG(Fre,Rowid))
				q:Rowid=""
				s diag=""
				s diag=$lg($g(^User.MKBStructuredDataD(Rowid)),2)
				s MRCdr=$lg($g(^User.MKBStructuredDataD(Rowid)),11)
				if MRCdr'=""
				{
					s MRCDesc=$p(^MRC("ID",MRCdr),"^",2)
					s ICD=$p(^MRC("ID",MRCdr),"^",4)
				}
				else
				{
					s MRCDesc=""
					s ICD=""
				}
				s result=""
				s rowid=0
				for
				{
					s rowid=$o(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid))
					q:rowid=""
					s termdr=""
					s resultid=""
					s resultdesc=""
					s resultid=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid)),2)
					s termdr=$lg($g(^User.MKBStructuredDataD(Rowid,"MKBSDStructResult",rowid)),4)
					s resultdesc=..GetChiForStrucIDs(resultid,termdr)
					s:result'="" result=result_"||"_resultdesc
					s:result="" result=resultdesc
				}
				if Fre>=5
				{
					s diag=$tr(diag,",","，")
					s result=$tr(result,",","，")
					d file.Write(diag_",")
					d file.Write(result_",")
					d file.Write(ICD_",")
					d file.Write(MRCDesc_",")
					d file.Write(Fre_",")
					d file.Write(Loc)
					d file.WriteLine()
				}
			}
		}
		d file.%Save()
		d file.%Close()
	}
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportRealLoc()
ClassMethod ExportRealLoc()
{
	s sum=0
	s file=##class(%File).%New("D:\工作\2019-04-15\数据处理工厂实际科室.csv")
	d file.Open("NWS")
	s n=""
	for
	{
		s n=$o(^TEMPLoc(n))
		q:n=""
		s sum=sum+1
		d file.Write(n)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetFenCi2Excel()
ClassMethod GetFenCi2Excel()
{
	s sum=0
	s file=##class(%File).%New(..%New().Path_"需要分词.csv")
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Seg=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
		if Seg=""
		{
			
			s Diag=$zstrip(Diag,"<>W")
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:把新分词导入到数据处理工厂
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertFenci2Factory()
ClassMethod InsertFenci2Factory()
{
	Ts
	s sum=0
	s file=##class(%File).%New(..%New().Path_"新分词.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		s str=""
		s Diag=""
		s Word=""
		s Property=""
		s Diag=$p(Line,",",1)
		q:Diag=""
		s Word=$p(Line,",",2)
		s Property=$p(Line,",",3)

		s diag=$zconvert(Diag,"U")
		s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_diag,0))
		b:MKBSDRowid=""
		if Property'=""
		{
			s str=Word_"("_Property_")"
		}
		else
		{
			s str=Word
		}
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDSegmentation=str
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s sum=sum+1
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; error
		}
		
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:把数据处理工厂中没有匹配到参考中心词的加入到临时Global
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetNoMatchedWordDesc()
ClassMethod GetNoMatchedWordDesc()
{
	k ^UniqueDiag
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDWord=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
		if MKBSDWord=""
		{
			s ^UniqueDiag(MKBSDDesc)=""
		}
	}
	
	s sum=0
	s n=""
	for
	{
		s n=$o(^UniqueDiag(n))
		q:n=""
		s sum=sum+1
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-16
/// Description:通过科室对照，把专业科室对应的诊断导出到excel
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportDiagOfProLoc()
ClassMethod ExportDiagOfProLoc()
{
	s Path="D:\工作\2019-04-15\ProLoc\"
	;诊断短语，结构化结果，ICD，ICD中文释义，频次，专业科室
		
	s file=##class(%File).%New(Path_"专业科室对应的诊断.csv")
	d file.Open("NWS")
	d file.Write("诊断"_",")
	d file.Write("结构化结果"_",")
	d file.Write("ICD"_",")
	d file.Write("ICD中文释义"_",")
	d file.Write("频次"_",")
	d file.Write("专业科室")
	d file.WriteLine()
	s SumOfPro=0

	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表专业科室
		q:MKBTDesc=""
		
		k ^UUU
		s SumOfPro=SumOfPro+1

		s MKBProDesc=$zstrip(MKBTDesc,"<>W")
		s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))   //安贞科室对照basedr
		s MKBKLMFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
		s MKBKLMFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
		;Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);
		s MKBNumRowid=0
		for
		{
			s MKBNumRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBNumRowid))
			q:MKBNumRowid=""
			;Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);
			s ProLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFProRowid,0)) // 专业科室rowid
			s RelLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFRelRowid,0))  //实际科室rowid
			
			s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocRowid)),2)
			s RelLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocRowid)),2)
			
			s ProLocDesc=$lg($g(^User.MKBTermD(ProLocdr)),3)
			s RelLocDesc=$lg($g(^User.MKBTermD(RelLocdr)),3)
			if (ProLocDesc=MKBProDesc)      //Term表专业科室和科室对照专业科室相同
			{
				
				s MKBSDRowId=0
				for
				{
					s MKBSDRowId=$O(^User.MKBStructuredDataLocI("LocIndex"," "_$ZCONVERT(RelLocDesc,"U"),MKBSDRowId))
					q:MKBSDRowId=""
					
					s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowId)),2) 
					s ^UUU(Diag,MKBSDRowId)=""	
				}
				/*
				s MKBSDRowid=0
				for
				{
					s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
					q:MKBSDRowid=""
					s MKBSDLRowid=0
					for
					{
						s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
						q:MKBSDLRowid=""
						s Loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2)
						if (Loc=RelLocDesc)               //数据处理工厂的实际科室和科室对照实际科室相同
						{
							s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)    //获取诊断
							s ^UUU(Diag,MKBSDRowid)=""
						}
					}
				}
				*/
			}
		}
		
		s Desc=""
		for
		{
			s Desc=$o(^UUU(Desc))
			q:Desc=""
			
			s MKBSDRowid=$o(^UUU(Desc,0))
			s MKBSDRRowid=0
			s str=""
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s Result=""
				s ResultId=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s Termdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(ResultId,Termdr)
				s:str'="" str=str_"||"_Result
				s:str="" str=Result
			}
			s string=$tr(str,",","，")
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			if MKBSDMDr'=""
			{
				s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
				s MKBSDICD=$p(^MRC("ID",MKBSDMDr),"^",4)                   //ICD
			}
			else
			{
				s MKBSDMrc=""
				s MKBSDICD=""
			}
			s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
			d file.Write(Desc_",")
			d file.Write(string_",")
			d file.Write(MKBSDICD_",")
			d file.Write(MKBSDMrc_",")
			d file.Write(SumLoc_",")
			d file.Write(MKBTDesc)
			d file.WriteLine()
		}


	}
	
	
	w "专业科室一共"_SumOfPro,!
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-18
/// Description:把数据处理工厂有结构化的父表标识置为1
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).SetConFlag1()
ClassMethod SetConFlag1()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataResultI("MKBSDStructDataIndex",MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDChildStructFlag=1
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s sum=sum+1
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; error
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-18
/// Description:
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).FindRealProLoc()
ClassMethod FindRealProLoc()
{
	s Path="D:\工作\2019-04-15\ProLoc\"
	s file=##class(%File).%New(Path_"还有哪些没有对照的实际科室.csv")
	d file.Open("NWS")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTDesc=""
	s MKBProDesc=$zstrip(MKBTDesc,"<>W")
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))   //安贞科室对照basedr
	s MKBKLMFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
	s MKBKLMFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
	;Index RowNumIndex On (MKBKMDKMBaseDr As Exact, MKBKMDRowNum As Exact);
	s MKBNumRowid=0
	for
	{
		s MKBNumRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBNumRowid))
		q:MKBNumRowid=""
		;Index ValIndex On (MKBKMDRowNum As Exact, MKBKMDKMBaseFieldDr As Exact);
		s ProLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFProRowid,0)) // 专业科室rowid
		s RelLocRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBNumRowid,MKBKLMBRowid_"||"_MKBKLMFRelRowid,0))  //实际科室rowid
		
		s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocRowid)),2)
		s RelLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocRowid)),2)
		
		s ProLocDesc=$lg($g(^User.MKBTermD(ProLocdr)),3)
		s RelLocDesc=$lg($g(^User.MKBTermD(RelLocdr)),3)
		
		s Pro(ProLocDesc)=""
		s Rel(RelLocDesc)=""
	}
	
	s SumPro=0
	s m=0
	for
	{
		s m=$o(Pro(m))
		q:m=""
		s SumPro=SumPro+1
	}
	s SumRel=0
	s n=0
	for
	{
		s n=$o(Rel(n))
		q:n=""
		s SumRel=SumRel+1
	}
	
	/*
	s MKBTDesc=""
	for
	{
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表专业科室
		q:MKBTDesc=""
		s Desc=$zstrip(MKBTDesc,"<>W")
		continue:$d(Pro(Desc))
		d file.Write(MKBTDesc)
		d file.WriteLine()
	}
	d file.%Save()
	d file.%Close()
	*/
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 科室_安贞",0))
	s MKBTDesc=""
	for
	{
		
	//User.MKBTermI("BaseIndex")
		s MKBTDesc=$o(^User.MKBTermI("DescIndex",MKBTBRowid,MKBTDesc))   //遍历Term表实际科室
		q:MKBTDesc=""
		s Desc=$zstrip(MKBTDesc,"<>W")
		continue:$d(Rel(Desc))
		d file.Write(MKBTDesc)
		d file.WriteLine()
	}
	b
	d file.%Save()
	d file.%Close()
}

/// Creator:李得原
/// CreatDate:2019-04-20
/// Description:
/// Table:
/// Input:
/// Return:
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).MigrageData2Copy()
ClassMethod MigrageData2Copy()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		
		s sum=sum+1
		s obj=##class(User.MKBStructuredCopy).%New()
		s obj.MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s obj.MKBSDLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
		s obj.MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),4)
		s obj.MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s obj.MKBSDCenterWordID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),6)
		s obj.MKBSDDate=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),7)
		d obj.MKBSDUpdateUserSetObjectId($lg($g(^User.MKBStructuredDataD(MKBSDRowid)),8))
		s obj.MKBSDSegmentation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),9)
		s obj.MKBSDDiaSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
		d obj.MKBSDMRCDrSetObjectId($lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11))
		s obj.MKBSDAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),12)
		s obj.MKBSDTotalFreq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		s obj.MKBSDChildStructFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),16)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
		}
		else
		{
			set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; MKBSDRowid error
		}
		s MKBSDLRowid=0
		for
		{
			s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
			q:MKBSDLRowid=""
			
			s lobj=##class(User.MKBStructuredCopyLoc).%New(id)
			d lobj.MKBSDStructDataSetObjectId(id)
			s lobj.MKBSDLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2)
			s lobj.MKBSDFrequency=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)
			s lobj.MKBSDLocSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),4)
			s lsc=lobj.%Save()
			d obj.%Close()
			if $$$ISOK(lsc)
			{
				s lid=lobj.%Id()
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(lsc)_"'}"
				b ; MKBSDLRowid error
			}
		}
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			
			s robj=##class(User.MKBStructuredCopyResult).%New(id)
			d robj.MKBSDStructDataSetObjectId(id)
			s robj.MKBSDStructResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
			s robj.MKBSDStructResult=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),3)
			s robj.MKBSDSupplement=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),5)
			d robj.MKBSDTermDRSetObjectId($lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4))
			s rsc=robj.%Save()
			d robj.%Close()
			if $$$ISOK(rsc)
			{
				s rid=robj.%Id()
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(rsc)_"'}"
				b ; MKBSDLRowid error
			}
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-05-15
/// Description：1.备份安贞科室对照界面数据
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).BackupAnzhenLocContrast()
ClassMethod BackupAnzhenLocContrast()
{
	s file=##class(%File).%New("D:\安贞科室对照.csv")
	d file.Open("WSN")
	d file.WriteLine("专业科室"_","_"实际科室")
	s sum=0
	s MKBMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	s MKBMBFRowid1=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 专业科室",0))
	s MKBMBFRowid2=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 实际科室",0))
	
	s ProFeild=MKBMBRowid_"||"_MKBMBFRowid1
	s RelFeild=MKBMBRowid_"||"_MKBMBFRowid2
	s MKBKLNum=0
	for
	{
		s MKBKLNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowid,MKBKLNum))
		q:MKBKLNum=""
		s sum=sum+1
		s MKBProRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLNum,ProFeild,0))   //专业科室
		s MKBRelRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLNum,RelFeild,0))  //实际科室
		
		s Prodr=$lg($g(^User.MKBKLMappingDetailD(MKBProRowid)),2)
		s Reldr=$lg($g(^User.MKBKLMappingDetailD(MKBRelRowid)),2)
		
		s Pro=$lg($g(^User.MKBTermD(Prodr)),3)
		s Rel=$lg($g(^User.MKBTermD(Reldr)),3)
		d file.WriteLine(Pro_","_Rel)
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-22
/// Description：2.删除科室对照界面数据
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).KillLocContrast()
ClassMethod KillLocContrast()
{
	Ts
	s sum=0
	s MKBMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	s MKBMBFRowid1=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 专业科室",0))
	s MKBMBFRowid2=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 实际科室",0))
	s MKBKLNum=0
	for
	{
		s MKBKLNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowid,MKBKLNum))
		q:MKBKLNum=""
		
		s sum=sum+1
		s MKBKLRowid=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowid,MKBKLNum,0))
		s re = ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(MKBKLNum,MKBMBRowid)
		b:re["false"
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-22
/// Description：3.把excel中的科室对照导入到科室对照界面
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportLocContrast()
ClassMethod ImportLocContrast()
{
	Ts
	s sum=0
	s chongfu=0
	s MKBMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	s MKBMBFRowid1=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 专业科室",0))
	s MKBMBFRowid2=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowid," 实际科室",0))
	s file=##class(%File).%New("D:\工作\2019-05-27\安贞科室对照-徐鹤凤版.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s RealLoc=$p(Line,",",2)
		s RealLoc=$zstrip(RealLoc,"<>W")
		s ProLoc=$p(Line,",",1)
		s ProLoc=$zstrip(ProLoc,"<>W")
		s ProBaseRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
		s RealBaseLoc=$o(^User.MKBTermBaseI("DescIndex"," 科室_安贞",0))
		
		s ProTermRowid=$o(^User.MKBTermI("DescIndex",ProBaseRowid," "_ProLoc,0))
		s RealTermRowid=$o(^User.MKBTermI("DescIndex",RealBaseLoc," "_RealLoc,0))
		
		;rowNum As %String, base As %String, fieldValueStr As %String
		;fieldValueStr-要保存的数据串(childsub[A]fieldvalue[N]childsub[A]fieldvalue)
		s str=MKBMBFRowid1_"[A]"_ProTermRowid_"[N]"_MKBMBFRowid2_"[A]"_RealTermRowid
		s result= ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBMBRowid,str)
		if result["该记录已经存在"
		{
			s chongfu=chongfu+1	
			continue
		}
		s sum=sum+1
	}
	w "重复："_chongfu,!
	w "一共"_sum
	q ""
}

/// 4.规则管理-安贞科室对照---->科室对照
/// d ##class(web.DHCBL.MKB.MKBStructedDiag).LocConMigrate()
ClassMethod LocConMigrate()
{
	TS
	k ^User.MKBLocContrastD
	k ^User.MKBLocContrastI
	
	s MKBKLMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	s ProMFChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 专业科室",0))
	s RealMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
		q:RowNum=""
		
		s ProMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_ProMFChild,0))
		s RealMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_RealMFChild,0))
		
		s ProTermId=$LG($G(^User.MKBKLMappingDetailD(ProMDRowId)),2)
		s RealTermId=$LG($G(^User.MKBKLMappingDetailD(RealMDRowId)),2)
		
		s RealLocDesc = $LG($G(^User.MKBTermD(RealTermId)),3)
		s CTLocID = $O(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(RealLocDesc),0))
		b:CTLocID=""	
		s obj=##class(User.MKBLocContrast).%New()
		d obj.MKBCTLocDrSetObjectId(CTLocID)
		d obj.MKBLocDrSetObjectId(ProTermId)
		s sc= obj.%Save()
		w sc
		b:$$$ERROR(sc)
	}
}

/// Creator:李得原
/// CreatDate:2019-04-23
/// Description：清除数据处理工厂父表科室字段值
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).RemoveLocColumn()
ClassMethod RemoveLocColumn()
{
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDLoc=""
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; MKBSDLRowid error
		}
	}
	q ""
}

/// Creator:李得原
/// CreatDate:2019-04-24
/// Description：数据处理工厂全处理成未处理
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).SetStatusAsN()
ClassMethod SetStatusAsN()
{
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDStatus="N"
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			b ; MKBSDLRowid error
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-24
/// Description：数据处理工厂通过父表科室字段中的科室ID串生成科室全文索引
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).GenerateProLocIndexinColumn()
ClassMethod GenerateProLocIndexinColumn()
{
	s sum=0
	s MKBTermBase=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s ProLocIds=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
		continue:ProLocIds=""
		s sum=sum+1
		s len=$l(ProLocIds,",")
		for i=1:1:len
		{
			s ProLocId=$p(ProLocIds,",",i)
			s ProLoc=$lg($g(^User.MKBTermD(ProLocId)),3)
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(ProLoc, MKBSDRowid_"L")
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-25
/// Description：数据处理工厂MergeFlag为D的数据看是否有ICD
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).SetMergeFlagD()
ClassMethod SetMergeFlagD()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		if MergeFlag="D"
		{
			s DMRCdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			
			if DMRCdr=""                   //如果D标记的ICD为空
			{
				s DChildStructFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)
				if DChildStructFlag=""           //如果D标记的ICD为空，结构化结果为空       
				{
					continue
				}
				else                            //如果D标记的ICD为空，结构化结果不为空
				{
					s Desc=""
					s Diag=""
					s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
					d GetUnifySign
					s Diagg=$zconvert(Diag,"U")
					s rowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Diagg,0))
					b:rowid=""   ;1
					s MRCdr=$lg($g(^User.MKBStructuredDataD(rowid)),11)
					continue:MRCdr'=""      //如果非D标记的有ICD则跳过
					s ChildStructFlag=$lg($g(^User.MKBStructuredDataD(rowid)),14)

					if (ChildStructFlag="")&(DChildStructFlag'="")
					{
						s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
						s obj.MKBSDMergeFlag=""
						s sc=obj.%Save()
						d obj.%Close()
						if $$$ISOK(sc)
						{
							s id=obj.%Id()
							s sum=sum+1
						}
						else
						{
							set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
							b ;2
						}
						
						s bobj=##class(User.MKBStructuredData).%OpenId(rowid)
						s bobj.MKBSDMergeFlag="D"
						s ssc=bobj.%Save()
						d bobj.%Close()
						if $$$ISOK(ssc)
						{
							s bid=bobj.%Id()
						}
						else
						{
							set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(ssc)_"'}"
							b ;3
						}
					}
					else
					{
						continue
					}

				}
			}
			else                //如果D标记的ICD不为空
			{
				s DChildStructFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)    //D标记的有结构化结果
				s Desc=""
				s Diag=""
				s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				d GetUnifySign
				s DD=""
				s DD=$zconvert(Diag,"U")
				s rowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_DD,0))
				b:rowid=""   ;11
				s MRCdr=$lg($g(^User.MKBStructuredDataD(rowid)),11)
				if MRCdr=""
				{
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					s obj.MKBSDMergeFlag=""
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						s id=obj.%Id()
						s sum=sum+1
					}
					else
					{
						set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ;2
					}
					
					s bobj=##class(User.MKBStructuredData).%OpenId(rowid)
					s bobj.MKBSDMergeFlag="D"
					s ssc=bobj.%Save()
					d bobj.%Close()
					if $$$ISOK(ssc)
					{
						s bid=bobj.%Id()
					}
					else
					{
						set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(ssc)_"'}"
						b ;3
					}
					continue
				}
				s ChildStructFlag=$lg($g(^User.MKBStructuredDataD(rowid)),14)
				s DICD=$p(^MRC("ID",DMRCdr),"^",4)
				s ICD=$p(^MRC("ID",MRCdr),"^",4)  ;6
				if DICD'=ICD       //如果非D标记ICD和没有D标记的ICD不同，都留下
				{
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					s obj.MKBSDMergeFlag=""
					s sc=obj.%Save()
					d obj.%Close()
					if $$$ISOK(sc)
					{
						s id=obj.%Id()
						s sum=sum+1
					}
					else
					{
						set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
						b ;2
					}
				}
				else      //如果非D标记ICD和没有D标记的ICD相同
				{
					if (ChildStructFlag="")&(DChildStructFlag'="")    //如果D标记的有结构化结果，非D没有结构化
					{
						s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
						s obj.MKBSDMergeFlag=""
						s sc=obj.%Save()
						d obj.%Close()
						if $$$ISOK(sc)
						{
							s id=obj.%Id()
							s sum=sum+1
						}
						else
						{
							set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
							b ;2
						}
						
						s bobj=##class(User.MKBStructuredData).%OpenId(rowid)
						s bobj.MKBSDMergeFlag="D"
						s ssc=bobj.%Save()
						d bobj.%Close()
						if $$$ISOK(ssc)
						{
							s bid=bobj.%Id()
						}
						else
						{
							set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(ssc)_"'}"
							b ;3
						}
					}
					else
					{
						continue
					}
				}
				
			}
		}
	}
	q sum
GetUnifySign
	s Diag=$tr(Desc,",","，")
	s Diag=$tr(Diag,"'","")	
	s Diag=$tr(Diag,"""","")	
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(13),"")
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(10),"")	
	s Diag=$tr(Diag,"(","（")
	s Diag=$tr(Diag,")","）")
}

/// Creator:李得原
/// CreatDate:2019-04-25
/// Description：数据处理工厂把MergeFlag为D的值放出来
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).SetFreeUnifySign()
ClassMethod SetFreeUnifySign()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBMerge=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		if MKBMerge="D"
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s obj.MKBSDMergeFlag=""
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s sum=sum+1
				s id=obj.%Id()
			}
			else
			{
				b ;1
			}
		}
		
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-24
/// Description：
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).UnifySign()
ClassMethod UnifySign()
{
	Ts
	s sum=0
	s count1=0
	s count2=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Diag=""
		s Desc=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Diag=$tr(Desc,",","，")
		s Diag=$tr(Diag,"'","")	
		s Diag=$tr(Diag,"""","")	
		s Diag=##class(web.BDP.util.String).Replace(Diag,$c(13),"")
		s Diag=##class(web.BDP.util.String).Replace(Diag,$c(10),"")	
		s Diag=$tr(Diag,"(","（")
		s Diag=$tr(Diag,")","）")
		for i=0:1:31
		{
			continue:i=10
			s Diag = ##class(web.BDP.util.String).Replace(Diag,$c(i),"")
		}
		for i=158:1:170
		{
			s Diag = ##class(web.BDP.util.String).Replace(Diag,$c(i),"")
		}
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDDiag=Diag
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			if result["键不唯一"
			{
				s count1=count1+1
				s bobj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				s bobj.MKBSDMergeFlag="D"
				s bobj.MKBSDDiag=Desc
				s ssc=bobj.%Save()
				if $$$ISOK(ssc)
				{
					s sid=bobj.%Id()
				}
				else
				{
					b ;1
				}
			}
			else
			{
				s count2=count2+1
				b ;2
			}
		}	
	}
	w count1,!
	w count2,!
	w sum,!
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).Test()
ClassMethod Test()
{
	
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		
		s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		if SumLoc>=2
		{
			if ($D(sum(2)))
			{
				s sum(2)=sum(2)+1	
			}
			else
			{
				s sum(2)=0	
			}
		}
		else
		{
			if ($D(sum(1)))
			{
				s sum(1)=sum(1)+1	
			}
			else
			{
				s sum(1)=0	
			}
		}
	}
	b
}

/// Creator:李得原
/// CreatDate:2019-04-25
/// Description：导出数据处理工厂频次大于2的数据
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportFre2()
ClassMethod ExportFre2()
{
	s sum=0
	s file=##class(%File).%New("D:\工作\2019-04-22\频次大于2的诊断.csv")
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Status=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)  //处理状态
		;s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
		if MKBSDMDr'=""
		{
			s MKBSDMrc=$p(^MRC("ID",MKBSDMDr),"^",2)                    //MRC中文描述
			s MKBSDICD=$p(^MRC("ID",MKBSDMDr),"^",4)                   //ICD
		}
		else
		{
			s MKBSDMrc=""
			s MKBSDICD=""
		}
		s ResultStr=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			
			s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
			s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
			s Result=..GetChiForStrucIDs(MKBSDResultID,MKBSDResultTermdr)
			s:ResultStr'="" ResultStr=ResultStr_"||"_Result
			s:ResultStr="" ResultStr=Result
		}
		s ResultStr=$tr(ResultStr,",","，")
		s MKBSDLocs=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)  //科室串
		s MKBSDLocStr=""
		if MKBSDLocs'=""
		{
			s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
			s loclen=$l(MKBSDLocs,",")
			for i=1:1:loclen
			{
				s Proid=$p(MKBSDLocs,",",i)
				s ProLocDesc=$lg($g(^User.MKBTermD(Proid)),3)
				s:MKBSDLocStr'="" MKBSDLocStr=MKBSDLocStr_"、"_ProLocDesc
				s:MKBSDLocStr="" MKBSDLocStr=ProLocDesc
			}
		}
		s AliasStr=""
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid)))  //存在别名
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","AN",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:AliasStr'="" AliasStr=AliasStr_"、"_MKBSDOAlias
				s:AliasStr="" AliasStr=MKBSDOAlias
			}
		}
		s OtherStr=""
		if ($D(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid)))  //存在其他描述
		{
			s MKBSDORowid=0
			for
			{
				s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
				q:MKBSDORowid=""
				s MKBSDOOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)
				s:OtherStr'="" OtherStr=OtherStr_"、"_MKBSDOOther
				s:OtherStr="" OtherStr=MKBSDOOther
			}
		}
		s MKBSDStatus=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
		s SumLoc=0
		s SumLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		if SumLoc>=2
		{
			s sum=sum+1
			d file.Write(MKBSDDiag_",")
			d file.Write(ResultStr_",")
			d file.Write(MKBSDICD_",")
			d file.Write(MKBSDMrc_",")
			d file.Write(AliasStr_",")
			d file.Write(OtherStr_",")
			d file.Write(MKBSDLocStr_",")
			d file.Write(Status_",")
			d file.Write(SumLoc_",")
			d file.WriteLine()
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Creator:李得原
/// CreatDate:2019-04-26
/// Description：
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).RemoveUndefined()
ClassMethod RemoveUndefined()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s result=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
			s termdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			if (termdr="undefined")
			{
				s id=""
				s id=MKBSDRowid_"||"_MKBSDRRowid
				s res= ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(id)
				b:res["false"
				s sum=sum+1
			}
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-05-07
/// Description：把csv中维护的诊断对应的专业科室追加到数据处理工厂中（有的追加，没有的诊断新增并加专业科室）
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// w ##class(web.DHCBL.MKB.MKBStructuredData).GetNewList("","血液内科","","","","0","","A","","5","1")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).AppendProLocToStructData("泌尿外科")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).AppendProLocToStructData("骨科")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).AppendProLocToStructData("血液内科")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).AppendProLocToStructData("普通外科")
ClassMethod AppendProLocToStructData(filename As %String)
{
	Ts
	s MKBTBRowid=$o(^User.MKBTermBaseI("FlagIndex"," LOC",0))
	s sum=0
	s newdata=0
	s olddata=0
	s c=0
	s file=##class(%File).%New("D:\工作\2019-05-06\"_filename_".csv")
	s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_filename,0))
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s sum=sum+1
		s Desc=$p(Line,",",1)
		s Loc=$p(Line,",",2)
		s SumLoc=$p(Line,",",6)
		if SumLoc=""
		{
			s SumLoc=0
		}
		b:Loc'=filename
		s Desc=$zconvert(Desc,"U")
		d GetUnifySign
		s Diagg=$zconvert(Diag,"U")
		//如果是已存在的诊断
		if ($d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Desc)))||($d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Diagg))) 
		{
			s MKBSDRowid=""
			if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Desc))
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Desc,0))
			}
			else
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Diagg,0))
			}
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s temp=""
			s temp=obj.MKBSDLoc
			s obj.MKBSDMergeFlag=""
			if temp'=""       //如果已有专业科室
			{
				if temp[MKBTRowid
				{
					s c=c+1
					w "重复:"_Desc,!
					continue
				}
				s temp=temp_","_MKBTRowid
			}
			else           //如果没有专业科室
			{
				s temp=MKBTRowid
			}
			s olddata=olddata+1
			s obj.MKBSDLoc=temp
		}
		else              //如果数据处理工厂中不存在此诊断，则新增
		{
			
			s obj=##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiag=Diag
			s obj.MKBSDLoc=MKBTRowid
			s obj.MKBSDStatus="N"
			s obj.MKBSDTotalFreq=SumLoc
			s newdata=newdata+1
			if $d(^MRC("ID",0,"Desc",Diag))
			{
				s MRCdr=$o(^MRC("ID",0,"Desc",Diag,0))
				d obj.MKBSDMRCDrSetObjectId(MRCdr)
				w "新增："_Diag_" "_"mrc"
			}	
			w "新增："_Diag,!
		}
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
		}
		else
		{
			b ;保存错误
		}
	}
	w $$$FormatText("一共有%1条excel数据,新增%2条数据,原%3条数据加上专业科室,已包含%4",sum,newdata,olddata,c),! 
	q ""
GetUnifySign
	s Diag=$tr(Desc,",","，")
	s Diag=$tr(Diag,"'","")	
	s Diag=$tr(Diag,"""","")	
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(13),"")
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(10),"")	
	s Diag=$tr(Diag,"(","（")
	s Diag=$tr(Diag,")","）")
}

/// Creator:李得原
/// CreatDate:2019-05-07
/// Description：清除四个专业科室内容（骨科、普通外科、泌尿外科、血液内科）
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：#小肠穿孔#	
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).Delete4ProLoc("普通外科")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).Delete4ProLoc("骨科")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).Delete4ProLoc("泌尿外科")
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).Delete4ProLoc("血液内科")
ClassMethod Delete4ProLoc(LocName As %String)
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("FlagIndex"," LOC",0))
	s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_LocName,0))
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
		if MKBSDLoc[MKBTRowid
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s temp=MKBSDLoc
			if temp=MKBTRowid   //如果专业科室只有一个
			{
				s obj.MKBSDLoc=""
			}
			else               //如果存在多个专业科室
			{
				s temp=","_temp_","
				s temp=$replace(temp,","_MKBTRowid_",",",")
				s temp=$e(temp,2,*-1)
				s obj.MKBSDLoc=temp
			}
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s sum=sum+1
				s id=obj.%Id()
			}
			else
			{
				b ;1
			}
		}
		
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-05-08
/// Description：
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).MigrageProLocToSubTable()
ClassMethod MigrageProLocToSubTable()
{
	Ts
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
		continue:MKBSDLoc=""

		s len=$l(MKBSDLoc,",")
		for i=1:1:len
		{
			continue:$p(MKBSDLoc,",",i)=""
			s obj=##class(User.MKBStructuredDataProLoc).%New(MKBSDRowid)
			d obj.MKBSDStructDataSetObjectId(MKBSDRowid)
			
			s obj.MKBSDProLoc=$p(MKBSDLoc,",",i)
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
			}
			else
			{
				b ;1
			}
		}
	}
	q ""
}

/// CreatDate:2019-05-08
/// Description：眩晕查询不到，处理换行符
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).xuanyun()
ClassMethod xuanyun()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Diagg=##class(web.DHCBL.BDP.FunLib).EvalJSON(Diag)
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDDiag=Diagg
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			b ;1
		}
	}
	q sum
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).t()
ClassMethod t()
{
	s file=##class(%File).%New("D:\HIS诊断未在处理工厂中的.csv")
	d file.Open("NSW")
	s sum=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
		if '$d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_MRCDesc))
		{
			;w MRCDesc,!
			s MRCDesc=$replace(MRCDesc,",","，")
			d file.WriteLine(MRCDesc)
		}
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).EvalSupplement()
ClassMethod EvalSupplement()
{
	s sum=0
	s MKBRowid=0
	for
	{
		s MKBRowid=$o(^User.MKBStructuredDataD(MKBRowid))
		q:MKBRowid=""
		s MKBRRowid=0
		for
		{
			s MKBRRowid=$o(^User.MKBStructuredDataD(MKBRowid,"MKBSDStructResult",MKBRRowid))
			q:MKBRRowid=""
			s Supplement=$lg($g(^User.MKBStructuredDataD(MKBRowid,"MKBSDStructResult",MKBRRowid)),5)
			s EvalSupple=##class(web.DHCBL.BDP.FunLib).EvalJSON(Supplement)
			s rowid=MKBRowid_"||"_MKBRRowid
			s obj=##class(User.MKBStructuredDataResult).%OpenId(rowid)
			s obj.MKBSDSupplement=EvalSupple
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				b ;1
			}
		}
	}
	q sum
}

/// 诊断数据的接口：将结构化ID串转换为中文描述
/// Input：ids：结构化ID串
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetChiForNewSeqStrucIDs("70446:S129243","15155")
ClassMethod GetChiForNewSeqStrucIDs(ids, termdr)
{
	s result=""
	s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termdr)
	s strCom=$p(strComAndAlisa,"[A]",1)
	s result=$p(strCom,"&%",1) //诊断常用名
	if result=""
	{
		s result=$lg($g(^User.MKBTermD(termdr)),3)
	}
	//获取诊断模板id
	s DiagTemplateDr=$o(^User.MKBTermPropertyI("FlagIndex",termdr," DT",0))
	s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",DiagTemplateDr,0))
	s Detail=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
	s len=$l(Detail,",")
	for i=1:1:len
	{
		s OnePiece=$p(Detail,",",i)
		continue:OnePiece=""
		s Prodr=$p(OnePiece,"&",1)  //属性ID
		s Type=$p(OnePiece,"&",2)
		s ProDetailDr=$p(OnePiece,"&",3) //属性内容ID
		if ProDetailDr'=""
		{
			s Sequence(i,Prodr,ProDetailDr)=""
			s str=##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(ProDetailDr,Prodr)
			s strlen=$l(str,"^")
			for j=1:1:strlen
			{
				s ProDetail=$p(str,"^",j)
				continue:ProDetail=""
				s Details(i,Prodr,ProDetailDr,ProDetail)=""
			}
		}
		else
		{
			s Sequence(i,Prodr)=""
		}
	}
	s ValueString=""
	s ResultLen=$l(ids,",")
	s seq=0
	for
	{
		s seq=$o(Sequence(seq))   //获取顺序
		q:seq=""
		s Pro=0
		for
		{
			s Pro=$o(Sequence(seq,Pro))    //获取顺序中的Prodr
			q:Pro=""
			for i=1:1:ResultLen     
			{
				s Result=$p(ids,",",i)
				s key=$p(Result,":",1)
				s Val=$p(Result,":",2)
				if Pro=key
				{
					s valueslen=$l(Val,"*")
					for k=1:1:valueslen
					{
						s val=$p(Val,"*",k)
						s values=Pro_":"_val
						if values["S"
						{
							d GetDesc
							s tempV(val)=""
							s tempK(Pro)=""
						}
						elseif $d(Sequence(seq,Pro))=1
						{
							d GetDesc
							s tempK(Pro)=""
							s tempV(val)=""
						}
						else
						{
							s DNode=0
							for
							{
								s DNode=$o(Sequence(seq,Pro,DNode))   //引用起始节点
								q:DNode=""
								if $d(Details(seq,Pro,DNode,val))
								{
									if ('$d(^User.MKBTermPropertyD(key)))
									{
										continue
									}
									d GetDesc
									s tempV(val)=""
									s tempK(Pro)=""
								}
							}
						}
					}
				}
			}
		}
	}	
	for j=1:1:ResultLen
	{
		s Result=$p(ids,",",j)
		s key=$p(Result,":",1)
		s Val=$p(Result,":",2)
		s valueslen=$l(Val,"*")
		for k=1:1:valueslen
		{
			s values=""
			s value=$p(Val,"*",k)
			s values=key_":"_value
			if '$d(tempK(key))    //诊断模板中不存在的属性
			{
				d GetDesc
			}
			else
			{
				if '$d(tempV(value))         //诊断模板中不存在的属性内容
				{
					d GetDesc
				}
			}
		}
	}
	if ValueString=""
	{
		s result=result
	}
	else
	{
		s result=result_"["_ValueString_"]"	
	}
	q result 
    
GetDesc             //串转描述
	if values["S"
	{
		s values=$tr(values,"S","")
		s ValueDr=$p(values,":",2)
		s Value=$lg($g(^User.MKBTermD(ValueDr)),3)
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}	
	}
	else
	{
		s ValueDr=$p(values,":",2)
		s Value= ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(ValueDr,key,"展示名")
		if Value=""
		{
			s Value=$lg($g(^User.MKBTermProDetailD(ValueDr)),3)
		}
		if ValueString'=""
		{
			s ValueString=ValueString_","_Value
		}
		if ValueString=""
		{
			s ValueString=Value
		}
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportGlobals()
ClassMethod ExportGlobals()
{
	d $system.OBJ.Export("^User.MKBTermBaseD.GBL","D:\temp\2019-05-13\User.MKBTermBaseD.gof")
	d $system.OBJ.Export("^User.MKBTermBaseI.GBL","D:\temp\2019-05-13\User.MKBTermBaseI.gof")
	d $system.OBJ.Export("^User.MKBTermBasePropertyI.GBL","D:\temp\2019-05-13\User.MKBTermBasePropertyI.gof")
	d $system.OBJ.Export("^User.MKBTermBasePropertyD.GBL","D:\temp\2019-05-13\User.MKBTermBasePropertyD.gof")
	d $system.OBJ.Export("^User.MKBTermBasePropertyC.GBL","D:\temp\2019-05-13\User.MKBTermBasePropertyC.gof")
	d $system.OBJ.Export("^User.MKBTermBaseExtendProI.GBL","D:\temp\2019-05-13\User.MKBTermBaseExtendProI.gof")
	d $system.OBJ.Export("^User.MKBTermD.GBL","D:\temp\2019-05-13\User.MKBTermD.gof")
	d $system.OBJ.Export("^User.MKBTermI.GBL","D:\temp\2019-05-13\User.MKBTermI.gof")
	d $system.OBJ.Export("^User.MKBTermPropertyD.GBL","D:\temp\2019-05-13\User.MKBTermPropertyD.gof")
	d $system.OBJ.Export("^User.MKBTermPropertyI.GBL","D:\temp\2019-05-13\User.MKBTermPropertyI.gof")
	d $system.OBJ.Export("^User.MKBTermPropertyC.GBL","D:\temp\2019-05-13\User.MKBTermPropertyC.gof")
	d $system.OBJ.Export("^User.MKBTermExtendProI.GBL","D:\temp\2019-05-13\User.MKBTermExtendProI.gof")
	d $system.OBJ.Export("^User.MKBTermProDetailD.GBL","D:\temp\2019-05-13\User.MKBTermProDetailD.gof")
	d $system.OBJ.Export("^User.MKBTermProDetailI.GBL","D:\temp\2019-05-13\User.MKBTermProDetailI.gof")
	d $system.OBJ.Export("^User.MKBTermExtendProValD.GBL","D:\temp\2019-05-13\User.MKBTermExtendProValD.gof")
	d $system.OBJ.Export("^User.MKBTermExtendProValI.GBL","D:\temp\2019-05-13\User.MKBTermExtendProValI.gof")
	d $system.OBJ.Export("^User.MKBReferenceD.GBL","D:\temp\2019-05-13\User.MKBReferenceD.gof")
	d $system.OBJ.Export("^User.MKBReferenceI.GBL","D:\temp\2019-05-13\User.MKBReferenceI.gof")
	d $system.OBJ.Export("^User.MKBDocManageD.GBL","D:\temp\2019-05-13\User.MKBDocManageD.gof")
	d $system.OBJ.Export("^User.MKBDocManageI.GBL","D:\temp\2019-05-13\User.MKBDocManageI.gof")
	d $system.OBJ.Export("^User.BDPUserHabitHisUiI.GBL","D:\temp\2019-05-13\User.BDPUserHabitHisUiI.gof")
	d $system.OBJ.Export("^User.BDPDataHistoryD.GBL","D:\temp\2019-05-13\User.BDPDataHistoryD.gof")
	d $system.OBJ.Export("^User.BDPDataHistoryI.GBL","D:\temp\2019-05-13\User.BDPDataHistoryI.gof")
	d $system.OBJ.Export("^User.BDPUserHabitHisUiD.GBL","D:\temp\2019-05-13\User.BDPUserHabitHisUiD.gof")
	d $system.OBJ.Export("^User.MKBKLMappingDetailD.GBL","D:\temp\2019-05-13\User.MKBKLMappingDetailD.gof")
	d $system.OBJ.Export("^User.MKBKLMappingDetailI.GBL","D:\temp\2019-05-13\User.MKBKLMappingDetail.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseD.GBL","D:\temp\2019-05-13\User.MKBKLMappingBaseD.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseI.GBL","D:\temp\2019-05-13\User.MKBKLMappingBaseI.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseC.GBL","D:\temp\2019-05-13\User.MKBKLMappingBaseC.gof")
	d $system.OBJ.Export("^User.MKBKLMappingBaseFieldI.GBL","D:\temp\2019-05-13\User.MKBKLMappingBaseFieldI.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseD.GBL","D:\temp\2019-05-13\User.MKBAssessmentBaseD.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseI.GBL","D:\temp\2019-05-13\User.MKBAssessmentBaseI.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseC.GBL","D:\temp\2019-05-13\User.MKBAssessmentBaseC.gof")
	d $system.OBJ.Export("^User.MKBAssessmentBaseFieldI.GBL","D:\temp\2019-05-13\User.MKBAssessmentBaseFieldI.gof")
	d $system.OBJ.Export("^User.BDPMKBIndexD.GBL","D:\temp\2019-05-13\User.BDPMKBIndexD.gof")
	d $system.OBJ.Export("^User.BDPMKBIndexI.GBL","D:\temp\2019-05-13\User.BDPMKBIndexI.gof")
	d $system.OBJ.Export("^User.MKBDataStatisticsD.GBL","D:\temp\2019-05-13\User.MKBDataStatisticsD.gof")
	d $system.OBJ.Export("^User.MKBMappingTermRelyD.GBL","D:\temp\2019-05-13\User.MKBMappingTermRelyD.gof")
	d $system.OBJ.Export("^User.MKBMappingSortRelyD.GBL","D:\temp\2019-05-13\User.MKBMappingSortRelyD.gof")
	d $system.OBJ.Export("^User.MKBDataStatisticsI.GBL","D:\temp\2019-05-13\User.MKBDataStatisticsI.gof")
	d $system.OBJ.Export("^User.MKBMappingTermRelyI.GBL","D:\temp\2019-05-13\User.MKBMappingTermRelyI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataD.GBL","D:\temp\2019-05-13\User.MKBStructuredDataD.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataI.GBL","D:\temp\2019-05-13\User.MKBStructuredDataI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataResultI.GBL","D:\temp\2019-05-13\User.MKBStructuredDataResultI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataLocI.GBL","D:\temp\2019-05-13\User.MKBStructuredDataLocI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataOtherI.GBL","D:\temp\2019-05-13\User.MKBStructuredDataOtherI.gof")
	d $system.OBJ.Export("^User.MKBStructuredDataD.GBL","D:\temp\2019-05-13\User.MKBStructuredDataD.gof")
	
	q ""
}

// 把MRC那张表中存在  但数据处理工厂中不存在的数据导入到数据处理工厂

// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).FillFactoryWithMRC()

ClassMethod FillFactoryWithMRC()
{
	Ts
	s sum=0
	s newone=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s MRCdesc=""
		s MRCdesc=$p(^MRC("ID",MRCRowid),"^",2)
		s MRCValid=$p(^MRC("ID",MRCRowid),"^",27)
		continue:MRCValid="N"
		d GetUnifySign
		s MRCDesc=$zconvert(Diag,"U")
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_MRCDesc)) //MRC数据已存在数据处理工厂
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_MRCDesc,0))
			s source=""
			s source=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
			b:MKBSDRowid=84866
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid) 
			if source=""
			{
				s obj.MKBSDDiaSource="HIS诊断"
			}
			elseif source'["HIS诊断"
			{
				s obj.MKBSDDiaSource=source_"&"_"HIS诊断"
			}
			d obj.MKBSDMRCDrSetObjectId(MRCRowid)
		}
		else              //MRC数据不在数据处理工厂           
		{
			s Desc=##class(web.DHCBL.BDP.FunLib).EvalJSON(Diag)
			s obj=##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiag=Desc
			s obj.MKBSDDiaSource="HIS诊断"
			s obj.MKBSDStatus="N"
			s obj.MKBSDTotalFreq=0
			d obj.MKBSDMRCDrSetObjectId(MRCRowid)
			s newone=newone+1
		}
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			b ;1
		}	
	}
	w newone,!
	q sum
GetUnifySign
	s Diag=$tr(MRCdesc,",","，")
	s Diag=$tr(Diag,"'","")	
	s Diag=$tr(Diag,"""","")	
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(13),"")
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(10),"")	
	s Diag=$tr(Diag,"(","（")
	s Diag=$tr(Diag,")","）")
}

// d ##class(web.DHCBL.MKB.MKBStructedDiag).DealMostPre()

ClassMethod DealMostPre()
{
	TS
	s num=0
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",0))
		continue:MKBSDDRowId=""
		
		s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		s TermId=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDDRowId)),4)
		s ResultId=	$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDDRowId)),2)
		s Desc = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(ResultId,TermId)
		
		if (MKBSDDesc=Desc)
		{
			s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			s obj.MKBSDInitialICD="Y"
			s sc = obj.%Save()
			b:$$$ERROR(sc)
			s num=num+1
		}
	}
	w num
}

// w ##class(web.DHCBL.MKB.MKBStructedDiag).TestMRCNumber()

ClassMethod TestMRCNumber()
{
	s sum=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s sum=sum+1
	}
	q sum
}

// w ##class(web.DHCBL.MKB.MKBStructedDiag).PYInsertToSD()

ClassMethod PYInsertToSD()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s diag=obj.MKBSDDiag
		s obj.MKBSDDiagPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			b ;1
		}
	}
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).SeqPINYIN()
ClassMethod SeqPINYIN()
{
	s c=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		b:PY=""
		s seqtemp(PY,MKBSDRowid)=""
	}
	s p=""
	for
	{
		s p=$o(seqtemp(p))
		q:p=""
		s rowid=0
		for
		{
			s rowid=$o(seqtemp(p,rowid))
			q:rowid=""
			s mod=c/20
			b:mod'["."
			
			s diag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
			w diag,!
			s c=c+1
		}
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).SeqTNB()
ClassMethod SeqTNB()
{
	k temppytnb
	s sum=0
	s file=##class(%File).%New("D:\拼音排序tnb.csv")
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		if Diag["糖尿病"
		{
			s temppytnb(PY,MKBSDRowid)=""
		}
	}
	
	s py=""
	for
	{
		s py=$o(temppytnb(py))
		q:py=""
		s rowid=0
		for
		{
			s rowid=$o(temppytnb(py,rowid))
			q:rowid=""
			s Diag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}	
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).SeqTNBAsc()
ClassMethod SeqTNBAsc()
{
	k temppytnb
	s sum=0
	s file=##class(%File).%New("D:\Ascii排序tnb.csv")
	d file.Open("NWS")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		if Diag["糖尿病"
		{
			s temppytnb(Diag,MKBSDRowid)=""
		}
	}
	s py=""
	for
	{
		s py=$o(temppytnb(py))
		q:py=""
		s rowid=0
		for
		{
			s rowid=$o(temppytnb(py,rowid))
			q:rowid=""
			s Diag=$lg($g(^User.MKBStructuredDataD(rowid)),2)
			d file.Write(Diag)
			d file.WriteLine()
			s sum=sum+1
		}	
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// CreatDate:2019-05-08
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).UnifyDiagSign1()
/// 把数据处理工厂数据符号统一处理(转中文括号后)
/// 
ClassMethod UnifyDiagSign1()
{

	Ts
	k ^TempSameSign
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		d GetUnifySign
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDDiag=Diag
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			if result["键不唯一"
			{
				
				s (EnglishStringRowid,ChineseStringRowid,ChineseStruct,EnglishStruct,EnglishFlag,ChineseFlag,ChineseMrc,EnglishMrc)=""
				s DiagDesc=$zconvert(Diag,"U")
				s DescDesc=$zconvert(Desc,"U")
				s ChineseStringRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_DiagDesc,0))
				s EnglishStringRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_DescDesc,0))
				
				s ^TempSameSign(ChineseStringRowid,EnglishStringRowid)=""
				s sum=sum+1
			}
		}
	}
	q sum
GetUnifySign
	s Diag=$tr(Desc,",","，")
	s Diag=$tr(Diag,"'","")	
	s Diag=$tr(Diag,"""","")	
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(13),"")
	s Diag=##class(web.BDP.util.String).Replace(Diag,$c(10),"")	
	s Diag=$tr(Diag,"(","（")
	s Diag=$tr(Diag,")","）")
}

/// CreatDate:2019-05-08
/// Table：User.MKBStructuredData
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).UnifyDiagSign2()
/// 把数据处理工厂数据符号统一处理(转中文括号后)
ClassMethod UnifyDiagSign2()
{
	Ts
	s sum=0
	s icd=0
	s m=0
	s mark=0
	s nn=0
	s n=0
	s mm=0
	s ChineseHasMRc=0
	s ChineseStringRowid=0
	s EnglishHasMrc=0
	s BothNoMRC=0
	s ChineseHasStruct=0
	s EnglishHasStruct=0
	s AllNoStruct=0
	for
	{
		s ChineseStringRowid=$o(^TempSameSign(ChineseStringRowid))
		q:ChineseStringRowid=""
		s EnglishStringRowid=0
		for
		{
			s EnglishStringRowid=$o(^TempSameSign(ChineseStringRowid,EnglishStringRowid))
			q:EnglishStringRowid=""
			s ChineseMrc=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid)),11)
			s EnglishMrc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),11)
			s ChineseFlag=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid)),15)   //是否有mergeflag
			s EnglishFlag=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),15)
			
			s ChineseStruct=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid)),14)
			s EnglishStruct=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),14)
			if (ChineseFlag'="")||(EnglishFlag'="")
			{
				continue
			}
			s mark=mark+1
			if (EnglishMrc'="")&(ChineseMrc'="")  //都有ICD
			{
				if EnglishMrc'=ChineseMrc    ////都有ICD但ICD不同，保留
				{
					s icd=icd+1
					w EnglishStringRowid,!
					continue
				}
				if (ChineseStruct'="")&(EnglishStruct'="")  //都有ICD，并且都结构化了，处理英文
				{	
					s ChineseChild=$o(^User.MKBStructuredDataD(ChineseStringRowid,"MKBSDStructResult",0))
					s ChineseTerm=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid,"MKBSDStructResult",ChineseChild)),4)
					s ChineseResultID=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid,"MKBSDStructResult",ChineseChild)),2)
					
					s EnglishChild=$o(^User.MKBStructuredDataD(EnglishStringRowid,"MKBSDStructResult",0))
					s EnglishTerm=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid,"MKBSDStructResult",EnglishChild)),4)
					s EnglishResultID=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid,"MKBSDStructResult",EnglishChild)),2)
					
					if (ChineseTerm=EnglishTerm)&(ChineseResultID=EnglishResultID)
					{
						s loc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),3)
						if loc'=""
						{
							s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
							s Cobj.MKBSDLoc=loc
							s csc=Cobj.%Save()
							d Cobj.%Close()
							if $$$ISOK(csc)
							{
								s Cid=Cobj.%Id()
							}
							else
							{
								b ;111
							}
						}
						s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
						s Eobj.MKBSDMergeFlag="S"
						s esc=Eobj.%Save()
						d Eobj.%Close()
						if $$$ISOK(esc)
						{
							s Eid=Eobj.%Id()
						}
						else
						{
							b ;39
						}
					}
					continue
				}
				elseif ChineseStruct'=""
				{
					s n=n+1       //都有ICD,但中文符号的结构化了
					s loc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),3)
					if loc'=""
					{
						s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
						s Cobj.MKBSDLoc=loc
						s csc=Cobj.%Save()
						d Cobj.%Close()
						if $$$ISOK(csc)
						{
							s Cid=Cobj.%Id()
						}
						else
						{
							b ;111
						}
					}
					s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
					s Eobj.MKBSDMergeFlag="S"
					s esc=Eobj.%Save()
					d Eobj.%Close()
					if $$$ISOK(esc)
					{
						s Eid=Eobj.%Id()
					}
					else
					{
						b ;30
					}
				}
				elseif EnglishStruct'=""
				{
					//都有ICD,但英文符号的结构化了
					s nn=nn+1
					s loc=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid)),3)
					if loc'=""
					{
						s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
						s Eobj.MKBSDLoc=loc
						s esc=Eobj.%Save()
						d Cobj.%Close()
						if $$$ISOK(esc)
						{
							s Eid=Eobj.%Id()
						}
						else
						{
							b ;1112
						}
					}
					s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
					s Cobj.MKBSDMergeFlag="S"
					s csc=Cobj.%Save()
					d Cobj.%Close()
					if $$$ISOK(csc)
					{
						s Cid=Cobj.%Id()
					}
					else
					{
						b ;11
					}
				}
				else
				{
					//都有ICD,但都没有结构化了
					s mm=mm+1
					s loc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),3)
					if loc'=""
					{
						s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
						s Cobj.MKBSDLoc=loc
						s csc=Cobj.%Save()
						d Cobj.%Close()
						if $$$ISOK(csc)
						{
							s Cid=Cobj.%Id()
						}
						else
						{
							b ;111
						}
					}
					s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
					s Eobj.MKBSDMergeFlag="S"
					s esc=Eobj.%Save()
					d Eobj.%Close()
					if $$$ISOK(esc)
					{
						s Eid=Eobj.%Id()
					}
					else
					{
						b ;31
					}
				}
				
			}
			elseif (EnglishMrc'="")     //英文括号的有ICD
			{
				s EnglishHasMrc=EnglishHasMrc+1  //英文有ICD
				s loc=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid)),3)
				if loc'=""
				{
					s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
					s Eobj.MKBSDLoc=loc
					s esc=Eobj.%Save()
					d Cobj.%Close()
					if $$$ISOK(esc)
					{
						s Eid=Eobj.%Id()
					}
					else
					{
						b ;1112
					}
				}
				s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
				s Cobj.MKBSDMergeFlag="S"
				s csc=Cobj.%Save()
				d Cobj.%Close()
				if $$$ISOK(csc)
				{
					s Cid=Cobj.%Id()
				}
				else
				{
					b ;12
				}
			}
			elseif (ChineseMrc'="")      //中文括号的有ICD
			{
				// 中文有ICD
				s ChineseHasMRc=ChineseHasMRc+1
				s loc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),3)
				if loc'=""
				{
					s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
					s Cobj.MKBSDLoc=loc
					s csc=Cobj.%Save()
					d Cobj.%Close()
					if $$$ISOK(csc)
					{
						s Cid=Cobj.%Id()
					}
					else
					{
						b ;111
					}
				}
				s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
				s Eobj.MKBSDMergeFlag="S"
				s esc=Eobj.%Save()
				d Eobj.%Close()
				if $$$ISOK(esc)
				{
					s Eid=Eobj.%Id()
				}
				else
				{
					b ;2
				}
			}
			else                   //都没有ICD
			{  
				//都没有ICD
				if (ChineseStruct'="")&(EnglishStruct'="")  //都没有ICD，并且都结构化了，不处理
				{	
					s BothNoMRC=BothNoMRC+1
					continue
				}
				elseif ChineseStruct'=""
				{
					s ChineseHasStruct=ChineseHasStruct+1
					s loc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),3)
					if loc'=""
					{
						s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
						s Cobj.MKBSDLoc=loc
						s csc=Cobj.%Save()
						d Cobj.%Close()
						if $$$ISOK(csc)
						{
							s Cid=Cobj.%Id()
						}
						else
						{
							b ;111
						}
					}
					s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
					s Eobj.MKBSDMergeFlag="S"
					s esc=Eobj.%Save()
					d Eobj.%Close()
					if $$$ISOK(esc)
					{
						s Eid=Eobj.%Id()
					}
					else
					{
						b ;32
					}
				}
				elseif EnglishStruct'=""
				{
					s loc=$lg($g(^User.MKBStructuredDataD(ChineseStringRowid)),3)
					if loc'=""
					{
						s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
						s Eobj.MKBSDLoc=loc
						s esc=Eobj.%Save()
						d Cobj.%Close()
						if $$$ISOK(esc)
						{
							s Eid=Eobj.%Id()
						}
						else
						{
							b ;1112
						}
					}
					s EnglishHasStruct=EnglishHasStruct+1
					s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
					s Cobj.MKBSDMergeFlag="S"
					s csc=Cobj.%Save()
					d Cobj.%Close()
					if $$$ISOK(csc)
					{
						s Cid=Cobj.%Id()
					}
					else
					{
						b ;13
					}
				}
				else
				{
					s AllNoStruct=AllNoStruct+1
					s loc=$lg($g(^User.MKBStructuredDataD(EnglishStringRowid)),3)
					if loc'=""
					{
						s Cobj=##class(User.MKBStructuredData).%OpenId(ChineseStringRowid)
						s Cobj.MKBSDLoc=loc
						s csc=Cobj.%Save()
						d Cobj.%Close()
						if $$$ISOK(csc)
						{
							s Cid=Cobj.%Id()
						}
						else
						{
							b ;111
						}
					}
					s Eobj=##class(User.MKBStructuredData).%OpenId(EnglishStringRowid)
					s Eobj.MKBSDMergeFlag="S"
					s esc=Eobj.%Save()
					d Eobj.%Close()
					if $$$ISOK(esc)
					{
						s Eid=Eobj.%Id()
					}
					else
					{
						b ;37
					}
				}
				
			}
		}
	}
	w "一共有"_mark_"个数据，icd不同的有"_icd_",都有icd,并且都结构化了有"_m ,!
	w "//都有ICD,但中文符号的结构化了"_n,!
	w "//都有ICD,但英文符号的结构化了"_nn,!
	w "//都有ICD,但都没有的结构化了"_mm,!
	w "英文有ICD "_EnglishHasMrc,!
	w "中文有ICD "_ChineseHasMRc,!
	w "都没有ICD,并且都结构化了 "_BothNoMRC,!
	w "都没有ICD，但中文结构化了 "_ChineseHasStruct,!
	w "都没有ICD，但英文结构化了 "_EnglishHasStruct,!
	w "都没有ICD，都么有结构化 "_AllNoStruct,!
	q ""
}

/// CreatDate:2019-05-17
/// Description：
/// Table：User.MKBICDContrast
/// Input：子表id 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertICD1()
ClassMethod InsertICD1()
{
	Ts
	set dir = ##class(%File).NormalizeDirectory("D:\工作\2019-05-13\四版本ICD\北京临床\")	
	s sum=0
	SET filename=$ZSEARCH(dir_"*.csv")
    WHILE filename'="" {
        WRITE !,filename
    	continue:filename'["csv"
		s file=##class(%File).%New(filename)
		d file.Open("RS")
		d file.ReadLine()
		while 'file.AtEnd
		{
			s Line=file.ReadLine()
			continue:Line=""
			s ICDNumber=""
			s ICDNumber=$p(Line,",",1)
			s ICDDesc=$p(Line,",",2)
			s ICDExtend=""
			s ICDExtend=$p(Line,",",3)
			b:ICDDesc=""
			s Desc=$zstrip(ICDDesc,"<>W")
			s ICDNumber=##class(web.DHCBL.BDP.FunLib).EvalJSON(ICDNumber)
			s Desc=##class(web.DHCBL.BDP.FunLib).EvalJSON(Desc)
			s ICDExtend=##class(web.DHCBL.BDP.FunLib).EvalJSON(ICDExtend)
			s Diag=$Replace(Desc,"(","（")
			s Diag=$Replace(Diag,")","）")
			s ICDNumber=$zstrip(ICDNumber,"<>W")
			s Diagg=$zconvert(Diag,"U")
			if ICDExtend["?"
			{
				s cc=$c(8224)
				s ICDExtend=$replace(ICDExtend,"?",cc)
			}
			if ICDNumber["?"
			{
				s cc=$c(8224)
				s ICDNumber=$replace(ICDNumber,"?",cc)
			}
			if $d(^User.MKBICDContrastI("DescIndex"," "_Diagg))   //如果统一符号存在相同诊断
			{	
				s ExistRowid=0
				for
				{
					s ExistRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diagg,ExistRowid))
					q:ExistRowid=""
					s ExistICD=""
					s ExistICD=$lg($g(^User.MKBICDContrastD(ExistRowid)),4)
					if (ExistICD=ICDNumber)      //如果ICD也一样，则加入数据来源
					{
						s obj=##class(User.MKBICDContrast).%OpenId(ExistRowid)
						s tempsource=obj.MKBICDDiaSource
						s sources=##class(%File).GetFilename(filename)
						s source=$e(sources,1,*-4)	
						s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
						if tempsource'[ICDSource
						{
							s obj.MKBICDDiaSource=tempsource_"&"_ICDSource
						}
					}
					else    //如果ICD不相同的，则保存处理符号后的
					{
						s obj=##class(User.MKBICDContrast).%New()
						s obj.MKBICDConDesc=Diag
						s obj.MKBICDConNumber=ICDNumber
						s:ICDExtend'="" obj.MKBICDConExtendNumber=ICDExtend
						s obj.MKBICDConStatus="N"
						s sources=##class(%File).GetFilename(filename)
						s source=$e(sources,1,*-4)
						s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
						s obj.MKBICDDiaSource=ICDSource
					}
				}
			}
			else
			{
				s obj=##class(User.MKBICDContrast).%New()
				s obj.MKBICDConDesc=Diag
				s obj.MKBICDConNumber=ICDNumber
				s:ICDExtend'="" obj.MKBICDConExtendNumber=ICDExtend
				s obj.MKBICDConStatus="N"
				s sources=##class(%File).GetFilename(filename)
				s source=$e(sources,1,*-4)
				s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
				s obj.MKBICDDiaSource=ICDSource
			}
			b:ICDSource["E"
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				b ;1
				
			}
		}
		SET filename=$ZSEARCH("")
	}
	w !
	q sum
}

/// 没有结构化诊断的诊断名-》如果诊断学临床实用诊断里有这个中心词，则自动匹配一个结构化诊断，并且设置为最优。
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoMatchByCenterWord()
ClassMethod AutoMatchByCenterWord()
{
	Ts
	s sum=0
	s MKBTermBase=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("StructIndex",-100000000000000,MKBSDRowid))
		q:MKBSDRowid=""
		
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTermBase,MKBTRowid))
			q:MKBTRowid=""
			s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			if MKBTDesc=MKBSDDesc
			{
				s result= ##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowid,"","","",MKBTRowid,"")
				s iresult=##class(web.DHCBL.MKB.MKBStructuredData).InitialICDUpdate(MKBSDRowid,"Y")
				s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				s obj.MKBSDChildStructFlag="1"
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1	
				}
				s sum=sum+1
				b:result["false"
				b:iresult["false"
			}
			else
			{
				set AliasItem=""
				;获取未匹配到的中心词的别名
				s AliasNum=0
				set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTRowid)    
				set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
				set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
				s n=0
				for i=1:1:AliasNum
				{
					set AliasItem=$p(TermDataAlias,",",i)
					if MKBSDDesc=AliasItem
					{
						s result= ##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDRowid,"","","",MKBTRowid,"")
						s iresult=##class(web.DHCBL.MKB.MKBStructuredData).InitialICDUpdate(MKBSDRowid,"Y")
						s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
						s obj.MKBSDChildStructFlag="1"
						s sc=obj.%Save()
						d obj.%Close()
						if $$$ISOK(sc)
						{
							s id=obj.%Id()
							s sum=sum+1
						}
						else
						{
							b ;1	
						}
						w MKBSDDesc,!
						s sum=sum+1
						b:result["false"
						b:iresult["false"
						q
					}
				}
			}
		}
	}
	q sum
}

/// 对ICD对照界面数据进行中心词匹配
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ICDContrastMatchCenterWord()
ClassMethod ICDContrastMatchCenterWord()
{
	k ^UniqueDiag
	s sum=0
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
		s MKBICDDesc=$zstrip(MKBICDDesc,"<>W")
		s ^UniqueDiag(MKBICDDesc)=""	
		s sum=sum+1
	}
	q sum
}

/// 对ICD对照界面分词导入
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ICDContrastInsertSegement()
ClassMethod ICDContrastInsertSegement()
{
	Ts
	s sum=0
	
	s m=0
	s n=0
	s file=##class(%File).%New("D:\工作\2019-05-20\ICDContrast分词.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		b:Line=""
		s m=m+1
		s MKBICDDesc=$p(Line,",",1)
		s CenterWord=$p(Line,",",2)
		s Property=$p(Line,",",3)
		s Diag=$zconvert(MKBICDDesc,"U")
		
		s str=""
		if CenterWord=""
		{
			s str="("_Property_")"
		}
		else
		{
			if Property=""
			{
				s str=CenterWord
			}
			else
			{
				s str=CenterWord_"("_Property_")"
			}
		}
		s MKBICDRowid=0
		for
		{
		 	s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diag,MKBICDRowid)) 
		 	q:MKBICDRowid=""
		 	s n=n+1
		 	s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
		 	s obj.MKBICDConSegmentation=str
		 	s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				b ;1	
			}
		}
	}
	b
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).tttt()
ClassMethod tttt()
{
	s Diag="继发性肺结核（初治，单耐药）涂阴培阳"
	s MKBICDRowid=0
	for
	{
	 	s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diag,MKBICDRowid)) 
	 	q:MKBICDRowid=""
	 	w MKBICDRowid,!
	}
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertCenterWordtoICDContrast()
ClassMethod InsertCenterWordtoICDContrast()
{
	Ts
	s Desc=""
	for
	{
		s Desc=$o(^TempTermData(Desc))
		q:Desc=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^TempTermData(Desc,MKBTRowid))
			q:MKBTRowid=""
			s Diag=$zconvert(Desc,"U")
			s MKBICDRowid=0
			for
			{
			 	s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diag,MKBICDRowid)) 
			 	q:MKBICDRowid=""
			 	s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
			 	s temp=obj.MKBICDConCenterWordID
			 	if temp=""
			 	{
			 		s obj.MKBICDConCenterWordID=MKBTRowid
			 	}
			 	else
			 	{
				 	s obj.MKBICDConCenterWordID=temp_","_MKBTRowid
				}
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1	
				}
			}
		}
	}
}

/// 把数据处理工厂子表中的顺序字段自动填充值
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoSequenceSDChild()
ClassMethod AutoSequenceSDChild()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s flag=0
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s seq=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),6)
			if seq'=""
			{
				s flag=1
				q
			}
		}
		if flag=0
		{
			s m=0
			
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s rowid=MKBSDRowid_"||"_MKBSDRRowid
				s obj=##class(User.MKBStructuredDataResult).%OpenId(rowid)
				s obj.MKBSDSequence=$i(m)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1	
				}
			}
		}
		continue:flag=1
	}
	q sum
}

/// 把ICD对照子表中的顺序字段自动填充值
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoSequenceICDChild()
ClassMethod AutoSequenceICDChild()
{
	Ts
	s sum=0
	s MKBICDRowid=0
	for
	{
		
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s flag=0
		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
			q:MKBICDRRowid=""
			s seq=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),7)
			if seq'=""
			{
				s flag=1
				q
			}
		}
		if flag=0
		{
			s m=0
			
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
				q:MKBICDRRowid=""
				s rowid=MKBICDRowid_"||"_MKBICDRRowid
				s obj=##class(User.MKBICDContrastResult).%OpenId(rowid)
				s obj.MKBICDSequence=$i(m)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1	
				}
			}
		}
		continue:flag=1
	}
	q sum
}

/// 把HISICD对照子表中的顺序字段自动填充值
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoSequenceHISICDChild()
ClassMethod AutoSequenceHISICDChild()
{
	Ts
	s sum=0
	s MKBHISICDRowid=0
	for
	{
		
		s MKBHISICDRowid=$o(^User.MKBHISICDContrastD(MKBHISICDRowid))
		q:MKBHISICDRowid=""
		s flag=0
		s MKBHISICDRRowid=0
		for
		{
			s MKBHISICDRRowid=$o(^User.MKBHISICDContrastD(MKBHISICDRowid,"MKBHISICDContrastResult",MKBHISICDRRowid))
			q:MKBHISICDRRowid=""
			s seq=$lg($g(^User.MKBHISICDContrastD(MKBHISICDRowid,"MKBHISICDContrastResult",MKBHISICDRRowid)),7)
			if seq'=""
			{
				s flag=1
				q
			}
		}
		if flag=0
		{
			s m=0
			
			s MKBHISICDRRowid=0
			for
			{
				s MKBHISICDRRowid=$o(^User.MKBHISICDContrastD(MKBHISICDRowid,"MKBHISICDContrastResult",MKBHISICDRRowid))
				q:MKBHISICDRRowid=""
				s rowid=MKBHISICDRowid_"||"_MKBHISICDRRowid
				s obj=##class(User.MKBHISICDContrastResult).%OpenId(rowid)
				s obj.MKBHISICDSequence=$i(m)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1	
				}
			}
		}
		continue:flag=1
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2018-12-10
/// Description：通过结构化结果ID串和termdr找相同的诊断
/// Table：User.MKBStructuredDataResult
/// Input：
/// Return：
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSameStructResult("ids","","")
ClassMethod GetSameStructResult(ids As %String, termdr As %String, supplement As %String)
{
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBDRowid))
		q:MKBSDRowid=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
			s MKBSDStructResultID=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),2)
			s MKBSDStructResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDStructResultID,MKBSDTermDR)
			if MKBSDSupplement'=""
			{
				s MKBSDSupplement=$zstrip(MKBSDSupplement,"<>W")
				if MKBSDStructResult["]"
				{
					s str=$e(MKBSDStructResult,1,*-1)
					s MKBSDStructResult=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s MKBSDStructResult=MKBSDStructResult_"[("_MKBSDSupplement_")]"
				}
			}
		}
	}
}

/// Creator：lideyuan
/// CreatDate: 2019-05-28
/// Description：通过结构化结果ID串和termdr找相同的诊断
/// Table：
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructedDiag","GetSameStructResult","18158:38122","15879","")
Query GetSameStructResult(ids As %String, termdr As %String, supplement As %String) As %Query(ROWSPEC = "MKBSDRowid:%String,MKBSDDiag:%String,MKBSDMrc:%String,MKBSDICD:%String,MKBSDStructResult:%String")
{
}

ClassMethod GetSameStructResultExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s MKBStruct=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(ids,termdr)
	if supplement'=""
	{
		s supplement=$zstrip(supplement,"<>W")
		if MKBSDStructResult["]"
		{
			s str=$e(MKBStruct,1,*-1)
			s MKBStruct=str_",("_supplement_")]"
		}
		else
		{
			s MKBStruct=MKBStruct_"[("_supplement_")]"
		}
	}
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid,MKBSDRRowid))
			q:MKBSDRRowid=""

			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
			s MKBSDStructResultID=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),2)
			s MKBSDStructResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDStructResultID,MKBSDTermdr)
			if MKBSDSupplement'=""
			{
				s MKBSDSupplement=$zstrip(MKBSDSupplement,"<>W")
				if MKBSDStructResult["]"
				{
					s str=$e(MKBSDStructResult,1,*-1)
					s MKBSDStructResult=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s MKBSDStructResult=MKBSDStructResult_"[("_MKBSDSupplement_")]"
				}
			}
			if MKBSDStructResult=MKBStruct
			{
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),12)    //别名字段
				if MKBSDMDr'=""
				{
					s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
					s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
				}
				else
				{
					s MKBSDMrc=""
					s MKBSDICD=""
				}
				d OutputRowCmb
			}
		}
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBSDRowid,MKBSDDiag,MKBSDMrc,MKBSDICD,MKBSDStructResult)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSameStructResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSameStructResultExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSameStructResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSameStructResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：lideyuan
/// CreatDate: 2019-05-28
/// Description：通过中心词和结构化结果id串、补充诊断查找相同中心词的，但属性不同的
/// Table：
/// Input：
/// Return：
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructedDiag","GetNotSameIdsButSameItem","18158:38122","15879","")
Query GetNotSameIdsButSameItem(ids As %String, termdr As %String, supplement As %String) As %Query(ROWSPEC = "MKBSDRowid:%String,MKBSDDiag:%String,MKBSDMrc:%String,MKBSDICD:%String,MKBSDStructResult:%String")
{
}

ClassMethod GetNotSameIdsButSameItemExecute(ByRef qHandle As %Binary, ids As %String, termdr As %String, supplement As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	/*
	s MKBStruct=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(ids,termdr)
	if supplement'=""
	{
		s supplement=$zstrip(supplement,"<>W")
		if MKBSDStructResult["]"
		{
			s str=$e(MKBStruct,1,*-1)
			s MKBStruct=str_",("_supplement_")]"
		}
		else
		{
			s MKBStruct=MKBStruct_"[("_supplement_")]"
		}
	}
	*/
	for i=1:1:$l(ids,",")
	{
		s subPro=$p(ids,",",i)
		
		s Pro=$p(subPro,":",1)
		s Detail=$p(subPro,":",2)
		for j=1:1:$l(Detail,"*")
		{
			s Det(Pro,$p(Detail,"*",i))=""
		}
	}
	s detNum=0
	s pro=0
	for
	{
		s pro=$o(Det(pro))
		q:pro=""
		s det=0
		for
		{
			s det=$o(Det(pro,det))
			q:det=""
			s detNum=detNum+1
		}
	}
	
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid,MKBSDRRowid))
			q:MKBSDRRowid=""

			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
			s MKBSDStructResultID=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),2)
			s MKBSDStructResult=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDStructResultID,MKBSDTermdr)
			if MKBSDStructResult["["
			{
				s result=$p(MKBSDStructResult,"[",2)
				s result=$p(result,"]",1)
				s resultlen=$l(result,",")
				
			}
			if MKBSDSupplement'=""
			{
				s MKBSDSupplement=$zstrip(MKBSDSupplement,"<>W")
				if MKBSDStructResult["]"
				{
					s str=$e(MKBSDStructResult,1,*-1)
					s MKBSDStructResult=str_",("_MKBSDSupplement_")]"
				}
				else
				{
					s MKBSDStructResult=MKBSDStructResult_"[("_MKBSDSupplement_")]"
				}
			}
			s Existflag=0
			s NotExistflag=0
			for m=1:1:$l(MKBSDStructResultID,",")
			{
				s subResPro=$p(MKBSDStructResultID,",",m)
				s ResPro=$p(subResPro,":",1)
				s ResDetail=$p(subResPro,":",2)
				for n=1:1:$l(ResDetail,"*")
				{
					s resD=$p(ResDetail,"*",n)
					if $d(Det(ResPro,resD))
					{
						s Existflag=Existflag+1
						continue
					}
					s NotExistflag=NotExistflag+1
				}
			}
			if (flag=detNum)&(NotExistflag>0)
			{
				s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
				s MKBSDAlias=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),12)    //别名字段
				if MKBSDMDr'=""
				{
					s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
					s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
				}
				else
				{
					s MKBSDMrc=""
					s MKBSDICD=""
				}
				d OutputRowCmb
			}
		}
		
	}
	

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(MKBSDRowid,MKBSDDiag,MKBSDMrc,MKBSDICD,MKBSDStructResult)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNotSameIdsButSameItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNotSameIdsButSameItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNotSameIdsButSameItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotSameIdsButSameItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 李欣20190410
/// 根据结构化数据获取非结构化数据
/// Input：ids
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct("15879-18158:38125,18159:330413")
ClassMethod GetDiagViaStruct(ids)
{
	s result=""
	if ids'=""
	{
		s TermId=$P(ids,"-",1)
		s ProDets=$P(ids,"-",2)
		if (ProDets'="")
		{
			///记录所有传入属性内容
			k dets
			///包含属性内容串个数
			s len = $L(ProDets,",")
			for i=1:1:len
			{
				s subProDets=$P(ProDets,",",i)
				s Pro=$P(subProDets,":",1)
				s Dets=$P(subProDets,":",2)
				for j=1:1:$L(Dets,"*")
				{
					s dets(Pro,$P(Dets,"*",j))=""	
				}
					
			}
			///记录属性内容个数	
			s detNum=0
			s pro=0
			for
			{
				s pro=$O(dets(pro))
				q:pro=""
				
				s det=0
				for
				{
					s det=$O(dets(pro,det))
					q:det=""
					
					s detNum=detNum+1	
				}	
			}
			///初始权重，每包含其中一个属性内容累加权重
			s initPriority=1/detNum
			
			///计算权重列表
			s pro=0
			for
			{
				s pro=$O(dets(pro))
				q:pro=""
				
				s det=0
				for
				{
					s det=$O(dets(pro,det))
					q:det=""
					
					s dets(pro,det)=initPriority
					
					s protype = $LG($G(^User.MKBTermPropertyD(pro)),4)
					s config=$LG($G(^User.MKBTermPropertyD(pro)),5)
					s contype=""
					if (protype="S")
					{
						s contype=$LG($G(^User.MKBTermBaseD(config)),4)	
					}
					///树性结构
					if ((protype="T")||(((protype="SS")||(protype="S"))&&(contype="T")))
					{
						///树形属性
						if (protype="T")
						{
							///先找出所有上级节点
							s tmp=det
							s tmpPrio=1
							while($LG($G(^User.MKBTermProDetailD(tmp)),4)'="")
							{
								s par=$LG($G(^User.MKBTermProDetailD(tmp)),4)
								s tmpPrio=tmpPrio-0.1
								s dets(Pro,par)=initPriority*tmpPrio
								s tmp=par
							}
							
							///所有下级节点权重暂等于当前节点
							s childs = ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(det,pro)
							if (childs'="")
							{
								for k=1:1:$L(childs,"^")
								{
									s dets(pro,$P(childs,"^",k))=initPriority	
								}		
							}
								
						}
						elseif (protype="SS")||(protype="S")
						{
							//当前选中的TermId
							s curTemrId=$P(det,"S",2)
							
							///找出所有上级节点
							s tmp=curTemrId
							s tmpPrio=1
							while($LG($G(^User.MKBTermD(tmp)),5)'="")
							{
								s par=$LG($G(^User.MKBTermD(tmp)),5)
								s tmpPrio=tmpPrio-0.1
								s dets(pro,"S"_par)=initPriority*tmpPrio
								s tmp=par
							}	
							
							///所有下级节点暂定权重不变
							
							s childs = ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(config,curTemrId)
							if (childs'="")
							{
								for k=1:1:$L(childs,"^")
								{
									s dets(pro,"S"_$P(childs,"^",k))=initPriority	
								}		
							}
						}	
					}	
				}
			}	
		
			s SortExp = ##class(web.DHCBL.MKB.MKBICDRely).SortExp(ProDets)	
			if ($D(^User.MKBStructuredDataResultI("SortIndex",TermId,SortExp))'=0) //完全匹配
			{
				s MKBSDRowId=""
				for
				{
					s MKBSDRowId=$O(^User.MKBStructuredDataResultI("SortIndex",TermId,SortExp,MKBSDRowId))	
					q:MKBSDRowId=""
					
					s MKBSDInitialICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),18) //最匹配短语
					s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
					s:Fre="" Fre=0
					if (MKBSDInitialICD="Y")
					{
						s par(100000000002,Fre,MKBSDRowId)=""
					}
					else
					{
						s par(100000000000,Fre,MKBSDRowId)=""	
					}
					
					s all(MKBSDRowId)=""
				}
			}
		}
		if ($D(all)=0)
		{
			s MKBSDRowId=0
			for
			{
				s MKBSDRowId=$O(^User.MKBStructuredDataResultI("TermIndex",TermId,MKBSDRowId))
				q:MKBSDRowId=""

				s MKBSDRRowId=0
				for
				{
					s MKBSDRRowId=$O(^User.MKBStructuredDataResultI("TermIndex",TermId,MKBSDRowId,MKBSDRRowId))	
					q:MKBSDRRowId=""
					
					s MKBSDInitialICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),18) //最匹配短语
					s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
					s ResultExp = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRRowId)),2)
					
					s:Fre="" Fre=0
					if (ProDets="")
					{
						if (ResultExp="")
						{
							if (MKBSDInitialICD="Y") 
							{
								s par(100000000001,Fre,MKBSDRowId)=""		
							}
							else
							{
								s par(1,Fre,MKBSDRowId)=""	
							}
							
						}		
						continue
					}
	
					//该条记录匹配度
					s priority=0
					
					
					if (ResultExp="")
					{	
						s par(0,Fre,MKBSDRowId)=""	
						continue	
					}
					///存储子表中结构化结果的属性内容
					k resdets
					
					for i=1:1:$L(ResultExp,",")
					{
						s Pro=$P($P(ResultExp,",",i),":",1)
						s Dets=$P($P(ResultExp,",",i),":",2)
						for j=1:1:$L(Dets,"*")
						{
							s resdets(Pro,$P(Dets,"*",j))=""	
						}	
					}
					
					///end 存储
					
					///对子表每一个内容进行判断
					s ResPro=0
					for
					{
						s ResPro=$O(resdets(ResPro))
						q:ResPro=""
						
						s ResDet=0
						for
						{
							s ResDet=$O(resdets(ResPro,ResDet))
							q:ResDet=""
							
							if ($D(dets(ResPro,ResDet)))
							{
								s priority=priority+dets(ResPro,ResDet)
							}
						}	
					}
					///按权重存储
					s par(priority*10,Fre,MKBSDRowId)=""
				}	
			}	
		}
		b
		k unique
		s result = ""
		s priority = ""
		for 
		{
			s priority = $o(par(priority),-1)
			q:priority=""
			s Fre=""
			for
			{
				s Fre=$O(par(priority,Fre),-1)	
				q:Fre=""
				
				s MKBSDRowId=""
				for
				{
					s MKBSDRowId=$O(par(priority,Fre,MKBSDRowId))
					q:MKBSDRowId=""
					
					s ICDDr = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),11)
					continue:ICDDr=""
					
					if $D(unique(MKBSDRowId))=0
					{
						s unique(MKBSDRowId)=""	
					}
					else
					{
						continue	
					}
				
					s:result'="" result=result_","_MKBSDRowId
					s:result="" result=MKBSDRowId		
				}
			}
		}		
	}

	q result
}

/// 李欣20190410
/// 根据结构化数据获取非结构化数据
/// Input：ids
/// w ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GetDiagViaStruct(14870)
ClassMethod GetDiagViaStruct1(ids)
{
	s result=""
	if ids'=""
	{
		k par
		if (ids["-")
		{
			s TermId = $P(ids,"-",1)
			s sub = ##class(web.DHCBL.MKB.MKBICDRely).SortExp($P(ids,"-",2))
			
			s MKBSDRowId=0
			for
			{
				s MKBSDRowId=$O(^User.MKBStructuredDataResultI("SortIndex",TermId,sub,MKBSDRowId))
				q:MKBSDRowId=""
				
				;s MKBSDRowId=$P(MKBSDRRowId,"||",1)
				s MKBSDInitialICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),18) //最匹配短语
				s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
				if (MKBSDInitialICD="Y")
				{
					s Fre=100000000000	
				}
				s par(Fre,MKBSDRowId)=""		
			}
		}
		else
		{
			s TermId=ids
			s MKBSDRowId=0
			for
			{
				s MKBSDRowId=$O(^User.MKBStructuredDataResultI("TermIndex",TermId,MKBSDRowId))	
				q:MKBSDRowId=""
				
				s MKBSDRRowId=0
				for
				{
					s MKBSDRRowId=$O(^User.MKBStructuredDataResultI("TermIndex",TermId,MKBSDRowId,MKBSDRRowId))	
					q:MKBSDRRowId=""
					
					continue:$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRRowId)),2)'=""
					s MKBSDInitialICD=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),18) //最匹配短语
					s Fre = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),13) ///总频次
					if (MKBSDInitialICD="Y")
					{
						s Fre=100000000000	
					}
					s par(Fre,MKBSDRowId)=""
				}
				
			}		
		}

		s fre=""
		for
		{
			s fre=$O(par(fre),-1)
			q:fre=""
			
			s parid=0
			for
			{
				s parid=$O(par(fre,parid))
				q:parid=""
				
				s:result'="" result=result_","_parid
				s:result="" result=parid	
			}		
		}
		
	}

	q result
}

/// Creator：lideyuan
/// CreatDate: 2019-05-29
/// Description：导出数据处理工厂icd为00000和icd为空的诊断到excel
/// Table：
/// Input：
/// Return：
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportIcdIsNull()
ClassMethod ExportIcdIsNull()
{
	s sum=0
	s file=##class(%File).%New("D:\temp\ICD为空.csv")
	d file.Open("NWS")
	d file.WriteLine("诊断名,ICD编码,标记,Rowid")
	s MKBSDRowid=0
	for
	{
		s (MKBSDDiag,MKBSDMDr,MKBSDMergeFlag,MKBSDICD)=""
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
		s MKBSDMergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)    //MRC指向
		if MKBSDMDr'=""
		{
			s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
		}
		else
		{
			s MKBSDMrc=""
			s MKBSDICD=""
		}
		if (MKBSDICD="00000")||(MKBSDICD="")||(MKBSDICD["-")
		{
			
			s:MKBSDICD="00000" ICD="'"_MKBSDICD
			s:MKBSDICD'="00000" ICD=MKBSDICD
			d file.WriteLine(MKBSDDiag_","_ICD_","_MKBSDMergeFlag_","_MKBSDRowid)
			s sum=sum+1
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q sum
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoStructEachVersionICD()
ClassMethod AutoStructEachVersionICD()
{
	s start=$NOW()
	s sum=0
	s subsum=0
	Ts
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s MKBICDDiag=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
		s Diag=$zconvert(MKBICDDiag,"U")
		s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_Diag,0))
		if MKBSDRowid'=""
		{
			s MKBSDRRowid=0
			for
			{
				s (MKBSDStruct,MKBSDTermdr,MKBSDSupplement,result)=""
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDStruct=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
				s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				s MKBSDSupplement=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),5)
				s result=##class(web.DHCBL.MKB.MKBICDContrast).SaveData(MKBICDRowid,"",MKBSDStruct,"",MKBSDTermdr,MKBSDSupplement)
				if result["false"
				{
					b
				}
				else
				{
					s subsum=subsum+1
				}
							
				s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
				s obj.MKBICDConStatus="P"
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1	
				}
			}
		}
	}
	s end=$NOW()
	w "开始:"_$zt(start,3)_"  结束:"_$zt(end,3),!
	w "存的结构化结果"_subsum,!
	w "结构化处理的诊断短语"_sum
	q ""
}

/// Creator:李得原
/// CreatDate:2019-06-04
/// Description:替换ICD对照界面中ICD和扩展ICD得问号为十字架
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).CrossingSign()
ClassMethod CrossingSign()
{
	Ts
	s sum=0
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s MKBICDNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
		s MKBICDExtendNumber=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)
		s Crossingsign=$c(8224)
		s flagA=0
		s flagB=0
		if MKBICDNumber["?"
		{
			s flagA=1
			s MKBICDNumber=$replace(MKBICDNumber,"?",Crossingsign)
		}
		if MKBICDExtendNumber["?"
		{
			s flagB=1
			s MKBICDExtendNumber=$replace(MKBICDExtendNumber,"?",Crossingsign)
		}
		if (flagA=1)||(flagB=1)
		{
			s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
			s obj.MKBICDConNumber=MKBICDNumber
			s obj.MKBICDConExtendNumber=MKBICDExtendNumber
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s sum=sum+1
			}
			else
			{
				set Rresult ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
				b
			}
		}
	}
	q sum
}

/// CreatDate:2019-06-03
/// Description:python调用接口导入数据
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).PythonInsertICD()
ClassMethod PythonInsertICD(icd As %String, desc As %String, extends As %String, filename As %String)
{
	s sum=0
	if extends="nan"
	{
		s ICDExtend=""
	}
	else
	{
		s ICDExtend=extends
	}
	if icd="nan"
	{
		s ICDNumber=""
	}
	else
	{
		s ICDNumber=icd
	}
	s ICDDesc=desc

	s ^ldy=ICDExtend
	q:ICDDesc="" ""
	s Desc=$zstrip(ICDDesc,"<>W")
	s ICDNumber=##class(web.DHCBL.BDP.FunLib).EvalJSON(ICDNumber)
	s Desc=##class(web.DHCBL.BDP.FunLib).EvalJSON(Desc)
	s ICDExtend=##class(web.DHCBL.BDP.FunLib).EvalJSON(ICDExtend)
	s Diag=$Replace(Desc,"(","（")
	s Diag=$Replace(Diag,")","）")
	s ICDNumber=$zstrip(ICDNumber,"<>W")
	s Diagg=$zconvert(Diag,"U")
	if $d(^User.MKBICDContrastI("DescIndex"," "_Diagg))   //如果统一符号存在相同诊断
	{	
		s ExistRowid=0
		for
		{
			s ExistRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diagg,ExistRowid))
			q:ExistRowid=""
			s ExistICD=""
			s ExistICD=$lg($g(^User.MKBICDContrastD(ExistRowid)),4)
			if (ExistICD=ICDNumber)      //如果ICD也一样，则加入数据来源
			{
				s obj=##class(User.MKBICDContrast).%OpenId(ExistRowid)
				s tempsource=obj.MKBICDDiaSource
				s source=##class(%File).GetFilename(filename)
				s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
				if tempsource'[ICDSource
				{
					s obj.MKBICDDiaSource=tempsource_"&"_ICDSource
				}
			}
			else    //如果ICD不相同的，则保存处理符号后的
			{
				s obj=##class(User.MKBICDContrast).%New()
				s obj.MKBICDConDesc=Diag
				s obj.MKBICDConNumber=ICDNumber
				s:ICDExtend'="" obj.MKBICDConExtendNumber=ICDExtend
				s obj.MKBICDConStatus="N"
				s source=##class(%File).GetFilename(filename)
				s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
				s obj.MKBICDDiaSource=ICDSource
			}
		}
	}
	else
	{
		s obj=##class(User.MKBICDContrast).%New()
		s obj.MKBICDConDesc=Diag
		s obj.MKBICDConNumber=ICDNumber
		s:ICDExtend'="" obj.MKBICDConExtendNumber=ICDExtend
		s obj.MKBICDConStatus="N"
		s source=##class(%File).GetFilename(filename)

		s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
		s obj.MKBICDDiaSource=ICDSource
	}
	s sc=obj.%Save()
	d obj.%Close()
	if $$$ISOK(sc)
	{
		s id=obj.%Id()
		s sum=sum+1
	}
	else
	{
		b ;1
		
	}
	q sum
}

/// CreatDate:2019-06-04
/// Description:把ICD对照界面得数据（导入时候全为大写）替换成原始数据
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ICDCaption2Normal()
ClassMethod ICDCaption2Normal()
{
	TS
	s sum=0
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s MKBICDDesc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)
		s desc=$o(^TempICDDesc(MKBICDRowid,""))
		continue:MKBICDDesc=desc
		s a=$zconvert(desc,"U")
		if a=MKBICDDesc
		{

			s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
			s obj.MKBICDConDesc=desc
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				b ;1
				
			}
		}
	}
	q sum
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ershizheng()
ClassMethod ershizheng()
{
	;3598 7453 14300   78337
	s a(1)=3598
	s a(2)=7453
	s a(3)=14300
	s a(4)=78337
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(a(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s temp1=obj.MKBSDDiag
		s obj.MKBSDDiag=##class(web.DHCBL.BDP.FunLib).EvalJSON(temp1)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			b ;1
			
		}
	}
}

/// Creator:李得原
/// CreatDate:2019-06-06
/// Table:User.MKBStructuredData
/// Description:把数据处理工厂中，匹配到的ICD中文描述和MRC中的中文描述对比得到的rowid重新赋值
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportICDDesc()
ClassMethod ExportICDDesc()
{
	s file=##class(%File).%New("D:\工作\2019-06-03\SDMRC.csv")
	d file.Open("NWS")
	d file.WriteLine("Rowid"_","_"Desc"_","_"中文描述"_","_"ICD")
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s OldMRCRowid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		if OldMRCRowid=""
		{
			s SignDesc=""
			s OldMRCICD=""
		}
		else
		{
			s OldMRCDesc=$p(^MRC("ID",OldMRCRowid),"^",2)
			s SignDesc=$replace(OldMRCDesc,",","，")
			s OldMRCICD=$p(^MRC("ID",OldMRCRowid),"^",4)
		}
		d file.WriteLine(MKBSDRowid_","_Desc_","_SignDesc_","_OldMRCICD)
	}
	d file.%Save()
	d file.%Close()
	k file
	q ""
}

/// Creator:李得原
/// CreatDate:2019-06-06
/// Table:User.MKBStructuredData
/// Description:郑州七院把数据处理工厂中，匹配到的ICD中文描述和MRC中的中文描述对比得到的rowid重新赋值
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).SDSubstituteMRC()
ClassMethod SDSubstituteMRC()
{
	Ts
	s (suma,sumb,sumc)=0
	s file=##class(%File).%New("D:\工作\2019-06-03\SDMRC.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s MKBSDRowid=$p(Line,",",1)
		s MKBSDDesc=$p(Line,",",2)
		s MKBICDDesc=$p(Line,",",3)
		if MKBICDDesc'=""            
		{
			s CaptionICDDesc=$zconvert(MKBICDDesc,"U")
			if $d(^MRC("ID",0,"Desc",CaptionICDDesc))           //如果在MRC中找到，则重置MRC指向
			{
				s NewMRCRowid=0
				for
				{
					s NewMRCRowid=$o(^MRC("ID",0,"Desc",CaptionICDDesc,NewMRCRowid))
					q:NewMRCRowid=""
					s activeto=$p(^MRC("ID",NewMRCRowid),"^",7)
					continue:activeto'=""
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					d obj.MKBSDMRCDrSetObjectId(NewMRCRowid)
					s suma=suma+1
				}
			}
			else                                       //如果在MRC中找不到，则置空
			{
				s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				d obj.MKBSDMRCDrSetObjectId("")	
				s sumb=sumb+1
			}
		}
		else        //如果原数据处理工厂没有匹配到ICD，重新匹配一下
		{
			s CaptionDesc=$zconvert(MKBSDDesc,"U")
			if $d(^MRC("ID",0,"Desc",CaptionDesc))
			{
				s NewMRCRowid=0
				for
				{
					s NewMRCRowid=$o(^MRC("ID",0,"Desc",CaptionDesc,NewMRCRowid))
					q:NewMRCRowid=""
					s activeto=$p(^MRC("ID",NewMRCRowid),"^",7)
					continue:activeto'=""
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					d obj.MKBSDMRCDrSetObjectId(NewMRCRowid)
					s sumc=sumc+1
				}
			}
		}
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
		}
		else
		{
			b ;1
		}	
	}
	w $$$FormatText("有%1个ICD被替换，有%2个ICD被置空，有%3个ICD新匹配 ",suma,sumb,sumc), !
	q ""
}

/// Creator:李得原
/// CreatDate:2019-06-10
/// Table:User.MKBHISICDContrast
/// Description:七院HISICD对照界面，结构化结果和父表对应
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).HISPareMappingtoChild()
ClassMethod HISPareMappingtoChild()
{
	Ts
	s start=$zdt($h)
	s sum=0
	
	s Desc=""
	for
	{
		s Desc=$o(^TempMRCtoHISICD(Desc))
		q:Desc=""
		s flag=0
		s MRCRowid=0
		for
		{
			s MRCRowid=$o(^MRC("ID",MRCRowid))
			q:MRCRowid=""
			s ActiveTo=$p(^MRC("ID",MRCRowid),"^",7)
			;continue:ActiveTo'=""
			s Valid=$p($g(^MRC("ID",MRCRowid)),"^",27)
			continue:Valid="N"
			s NewMRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
			if NewMRCDesc=Desc
			{
				s HISICDRowid=$o(^TempMRCtoHISICD(Desc,0))
				s obj=##class(User.MKBHISICDContrast).%OpenId(HISICDRowid)
				d obj.MKBHISICDDrSetObjectId(MRCRowid)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
					s flag=1
				}
				else
				{
					b ;1
				}
			}
		}
		if flag=0
		{
			s HISICDRowid=$o(^TempMRCtoHISICD(Desc,0))
			if $d(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult"))
			{
				s obj=##class(User.MKBHISICDContrast).%OpenId(HISICDRowid)
				s obj.MKBHISICDConStatus="N"
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;2
				}
				s HISICDRRowid=0
				for
				{
					s HISICDRRowid=$o(^User.MKBHISICDContrastD(HISICDRowid,"MKBHISICDContrastResult",HISICDRRowid))
					q:HISICDRRowid=""
					s rowid=HISICDRowid_"||"_HISICDRRowid
					s result= ##class(web.DHCBL.MKB.MKBHISICDContrast).DeleteData(rowid)
					if result["false"
					{
						b
					}
				}
			}
		}	
	}
	s end=$zdt($h)
	w "start:"_start,!
	w "end:"_end,!
	q sum
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportHISICDDescRowid()
ClassMethod ExportHISICDDescRowid()
{
	k ^TempMRCtoHISICD
	s sum=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
		continue:MRCDesc=""
		s HISICDRowid=$o(^User.MKBHISICDContrastI("MRCIndex",MRCRowid,0))
		continue:HISICDRowid=""
		s ^TempMRCtoHISICD(MRCDesc,HISICDRowid)=""
		s sum=sum+1
	}
	q sum
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).CountMRCtoHISICD()
ClassMethod CountMRCtoHISICD()
{
	s sum=0
	s desc=""
	for
	{
		s desc=$o(^TempMRCtoHISICD(desc))
		q:desc=""
		s sum=sum+1
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-06-11
/// Description：数据处理二场左侧是否是最适ICD，如果是 输出Y
/// Input：termdr
/// Return:如果是最适icd则返回1，如果不是返回0
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).FindTheBestMatchICD()
/// Other: w ##class(web.DHCBL.MKB.MKBStructuredSecondData).FindTheBestMatchICD()
ClassMethod FindTheBestMatchICD(termdr)
{
	s flag="N"
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataI("InitialICDIndex","Y",MKBSDRowid))
		q:MKBSDRowid=""
		if $d(^User.MKBStructuredDataResultI("TermIndex",termdr,MKBSDRowid))
		{
			 s flag="Y"
		}
	}
	q flag
}

/// Creator:李得原
/// CreatDate:2019-06-11
/// Description：数据处理工厂诊断修饰合并，看ICD是否相同，如果不同的话不合并，如果ICD相同合并
/// Input：termdr
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).MergeDecorate()
ClassMethod MergeDecorate()
{
	s sum=0
	Ts
	s (sum1,sum2,sum3,sum4,sum5,sum6)=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
		s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		continue:MergeFlag'=""
		s DescPY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		s Desc=""
		if MKBSDDesc["（待查）"
		{
			s Desc=$e(MKBSDDesc,1,*-4)
			d Update
			s sum1=sum1+1
		}
		elseif MKBSDDesc["（可能性大）"
		{
			s Desc=$e(MKBSDDesc,1,*-6)
			d Update
			s sum2=sum2+1
		}
		elseif MKBSDDesc["（术前）"
		{
			s Desc=$e(MKBSDDesc,1,*-4)
			d Update
			s sum3=sum3+1
		}
		elseif MKBSDDesc["（术后）"
		{
			s Desc=$e(MKBSDDesc,1,*-4)
			d Update
			s sum4=sum4+1
		}
		elseif MKBSDDesc["（病情需要调整用量）"
		{
			s Desc=$e(MKBSDDesc,1,*-10)
			d Update
			s sum5=sum5+1
		}
		elseif MKBSDDesc["（不除外）"
		{
			s Desc=$e(MKBSDDesc,1,*-5)
			d Update
			s sum6=sum6+1
		}
	}
	w $$$FormatText("待查有%1个,可能性有%2个,术前有%3个,术后有%4个,病情需要调整用量有%5个,一共处理%6个",sum1,sum2,sum3,sum4,sum5,sum)
	q ""
Update
	s CaptionDiag=""
	s CaptionDiag=$zcvt(Desc,"U")
	if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag))
	{
		s ShortRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag,0))
		s ShortMRC=$lg($g(^User.MKBStructuredDataD(ShortRowid)),11)
		s ShortMergeFlag=$lg($g(^User.MKBStructuredDataD(ShortRowid)),15)
		if ((MRC=ShortMRC)||((MRC="")&(ShortMRC'="")))
		{
			s sum=sum+1
			s Otherresult=##class(web.DHCBL.MKB.MKBStructuredData).OtherUpdate(ShortRowid,"", MKBSDDesc,"",DescPY ,"OD")
			b:Otherresult["false"
			s loc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
			s status=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),5)
			s structflag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)
			s Mergeresult= ##class(web.DHCBL.MKB.MKBStructuredData).EditUpdate(MKBSDRowid,status,MRC,structflag,"C",loc)
			b:Mergeresult["false"
		}
	}
}

/// Creator:李得原
/// CreatDate:2019-06-11
/// Description：
/// Input：termdr
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).Mergekuohao()
ClassMethod Mergekuohao()
{
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Desc=$replace(MKBSDDesc,"(","（")
		s Desc=$replace(Desc,")","）")
		s Desc=$replace(Desc,",","，")
		
		s CaptionDiag=$zconvert(Desc,"U")
		s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		continue:MergeFlag'=""
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag))
		{
			s rowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag,0))
			s merge=$lg($g(^User.MKBStructuredDataD(rowid)),15)
			continue:merge'=""
			if rowid'=MKBSDRowid
			{
				w rowid_","_MKBSDRowid,!
			}
		}
		
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-06-11
/// Description：查看数据处理工厂中还有多少没合并的带英文括号的
/// Input：termdr
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).YY()
ClassMethod YY()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		continue:MergeFlag'=""
		if (Desc["(")||(Desc[")")
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s Diag=$replace(Desc,"(","（")
			s Diag=$replace(Diag,")","）")
			s obj.MKBSDDiag=Diag
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1

			}
			else
			{
				w $system.OBJ.DisplayError(sc)
				b ;2
			}
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-06-12
/// Description：把数据处理工厂MRC的数据填充到ICD和ICDdesc字段中
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).SDMigrateMRC2ICD()
ClassMethod SDMigrateMRC2ICD()
{
	Ts
	s sum=0
	s MRC=0
	for
	{
		s MRC=$o(^User.MKBStructuredDataI("MRCIndex",MRC))
		q:MRC=""
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MRCIndex",MRC,MKBSDRowid))
			q:MKBSDRowid=""

			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			if MKBSDMDr'=""
			{
				s MKBSDMrc=$p($g(^MRC("ID",MKBSDMDr)),"^",2)                    //MRC中文描述
				s MKBSDICD=$p($g(^MRC("ID",MKBSDMDr)),"^",4)                   //ICD
			}
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s obj.MKBSDICD=MKBSDICD
			s obj.MKBSDICDDesc=MKBSDMrc
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				w $system.OBJ.DisplayError(sc),!
				b ;2
			}
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-06-12
/// Description：把HISICD对照的MRC的数据填充到ICD和ICDdesc字段中
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).HISICDMigrateMRC2ICD()
ClassMethod HISICDMigrateMRC2ICD()
{
	Ts
	s sum1=0
	s sum2=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",MRCRowid))
		q:MRCRowid=""
		s Valid=$p($g(^MRC("ID",MRCRowid)),"^",27)
		continue:Valid="N"
		if $d(^User.MKBHISICDContrastI("MRCIndex",MRCRowid))
		{
			s MKBSDDesc=$p($g(^MRC("ID",MRCRowid)),"^",2)               //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MRCRowid)),"^",4)                   //ICD
			s MKBHISRowid=$o(^User.MKBHISICDContrastI("MRCIndex",MRCRowid,0))
			s obj=##class(User.MKBHISICDContrast).%OpenId(MKBHISRowid)
			s obj.MKBHISICD=MKBSDICD
			s obj.MKBHISICDDesc=MKBSDDesc
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum1=sum1+1
			}
			else
			{
				w $system.OBJ.DisplayError(sc),!
				b ;2
			}
		}
		else
		{
			s MKBSDDesc=$p($g(^MRC("ID",MRCRowid)),"^",2)                    //MRC中文描述
			s MKBSDICD=$p($g(^MRC("ID",MRCRowid)),"^",4)                   //ICD
			s obj=##class(User.MKBHISICDContrast).%New()
			d obj.MKBHISICDDrSetObjectId(MRCRowid)
			s obj.MKBHISICDDesc=MKBSDDesc
			s obj.MKBHISICD=MKBSDICD
			s obj.MKBHISICDConStatus="N"
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum2=sum2+1
			}
			else
			{
				w $system.OBJ.DisplayError(sc),!
				b ;2
			}
		}
	}
	w $$$FormatText("%1个已有的MRC被填充字段，%2个新的被填充",sum1,sum2)
	q ""
}

/// Creator:李得原
/// CreatDate:2019-06-13
/// Description：数据处理工厂中根据ICD和ICD描述更改MRC指向
/// Input：
/// Return:
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).SDChangeICD2MRC()
ClassMethod SDChangeICD2MRC()
{
	Ts
	s (suma,sumb,sumc)=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)

		if MKBICDDesc'=""            
		{
			s CaptionICDDesc=$$ALPHAUP^SSUTIL4(MKBICDDesc)
			if $d(^MRC("ID",0,"Desc",CaptionICDDesc))           //如果在MRC中找到，则重置MRC指向
			{
				s NewMRCRowid=0
				for
				{
					s NewMRCRowid=$o(^MRC("ID",0,"Desc",CaptionICDDesc,NewMRCRowid))
					q:NewMRCRowid=""
					s activeto=$p(^MRC("ID",NewMRCRowid),"^",7)
					continue:activeto'=""
					s Valid=$p($g(^MRC("ID",NewMRCRowid)),"^",27)
					continue:Valid="N"
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					d obj.MKBSDMRCDrSetObjectId(NewMRCRowid)
					s suma=suma+1
				}
			}
			else                                       //如果在MRC中找不到，则置空
			{
				s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				d obj.MKBSDMRCDrSetObjectId("")	
				s obj.MKBSDICD=""
				s obj.MKBSDICDDesc=""
				s sumb=sumb+1
			}
		}
		else        //如果原数据处理工厂没有匹配到ICD，重新匹配一下
		{
			s CaptionDesc=$$ALPHAUP^SSUTIL4(MKBSDDesc)
			if $d(^MRC("ID",0,"Desc",CaptionDesc))
			{
				s NewMRCRowid=0
				for
				{
					s NewMRCRowid=$o(^MRC("ID",0,"Desc",CaptionDesc,NewMRCRowid))
					q:NewMRCRowid=""
					s activeto=$p(^MRC("ID",NewMRCRowid),"^",7)
					continue:activeto'=""
					s Valid=$p($g(^MRC("ID",NewMRCRowid)),"^",27)
					continue:Valid="N"
					s MRCDesc=$p(^MRC("ID",NewMRCRowid),"^",2)
					s MRCCode=$p(^MRC("ID",NewMRCRowid),"^",4)
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					d obj.MKBSDMRCDrSetObjectId(NewMRCRowid)
					s obj.MKBSDICD=MRCCode
					s obj.MKBSDICDDesc=MRCDesc
					s sumc=sumc+1
				}
			}
		}
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
		}
		else
		{
			b ;1
		}	
	}
	w $$$FormatText("有%1个ICD被替换，有%2个ICD被置空，有%3个ICD新匹配 ",suma,sumb,sumc), !
	q ""
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).TNBPercent()
ClassMethod TNBPercent()
{
	s sum1=0
	s sum2=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s totalFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),13)
		;s source=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
		if Desc["糖尿病"
		{
			s MKBSDLRowid=0
			for
			{
				s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
				q:MKBSDLRowid=""
				s Source=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),4)
				s Fre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)
				;continue:Source'["L"
				s sum2=sum2+Fre
				if Desc="糖尿病"
				{
					s sum1=sum1+Fre
				}
			}
		}
	}

	w $$$FormatText("所有诊断中(出院和门急诊)糖尿病频次为:%1,包含糖尿病的诊断总频次为%2",sum1,sum2),!
	s percent=sum1/sum2
	w $$$FormatText("糖尿病占比：%1",percent),!
	q ""
}

/// Creator:李得原
/// CreatDate:2019-06-19
/// Description：根据诊断短语或拼音  获取描述和rowid
/// Table：
/// Input：Desc
/// Return：Desc rowid
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructuredData","GetDataForDiaCmb","tnb")
Query GetDataForDiaCmb(desc As %String) As %Query(ROWSPEC = "MKBSDRowid,MKBSDDiag")
{
}

ClassMethod GetDataForDiaCmbExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Diag=##class(web.DHCBL.MKB.BDPMKBIndex).Filter(desc)
		
	if (Diag'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(Diag,"U"),MKBSDRowid))
			q:MKBSDRowid=""
			continue:MKBSDRowid["ICD"
			continue:MKBSDRowid["L"
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			d getCTTitle
		}
		
	}
	else
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			d getCTTitle
		}
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBSDRowid,MKBSDDiag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataForDiaCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForDiaCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDataForDiaCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForDiaCmbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).MNWKLocProDiag()
ClassMethod MNWKLocProDiag()
{
	
	s file=##class(%File).%New("D:\temp\泌尿外科诊断.csv")
	d file.Open("NSW")
	s sum=0
	///遍历专业科室
	;s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 医疗_专业科室",0))
	;s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	///获取科室对照诊断
	s MKBLocDiagBase=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室专业诊断",0))
	s Loc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 科室",0))
	s Diag=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 诊断",0))
	s Fre=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 频次",0))

	;k ^TEST
	///获取实际科室
	;s RealLocFieldChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))
	;s RealLocFieldRowId = MKBKLMBRowId_"||"_RealLocFieldChild 

		
	s RowNum=0
	for
	{
		s RowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBLocDiagBase,RowNum))
		q:RowNum=""
		s LocValdr=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBLocDiagBase_"||"_Loc,0))
		s DiagValdr=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBLocDiagBase_"||"_Diag,0))
		s Locdr=$lg($g(^User.MKBKLMappingDetailD(LocValdr)),2)
		s Diagdr=$lg($g(^User.MKBKLMappingDetailD(DiagValdr)),2)
		s LocDesc=$lg($g(^User.MKBTermD(Locdr)),3)
		continue:LocDesc'="泌尿外科"
		s DiagDesc=$lg($g(^User.MKBTermD(Diagdr)),3)
		s sum=sum+1
		d file.WriteLine(DiagDesc)
	}
	d file.%Save()
	d file.%Close()
	q sum
}

/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSDList("糖尿病","","型")
ClassMethod GetSDList(diag As %String, icd As %String, result As %String) As %String
{
	s Diag=$zstrip(diag,"<>W")
	s Icd=$zstrip(icd,"<>W")
	s Res=$$ALPHAUP^SSUTIL4(result)
	if (Diag'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(Diag,"U"),MKBSDRowid))
			q:MKBSDRowid=""
			continue:MKBSDRowid["ICD"
			continue:MKBSDRowid["L"
			s dt(MKBSDRowid)=""	
		}
	}
	if (Icd'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MRCIndex",MKBSDRowid))
			q:MKBSDRowid=""
			s MRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			s MRCDesc=$p(^MRC("ID",MRC),"^",2)
			if MRCDesc[Icd
			s it(MKBSDRowid)=""
		}
	}
	if (Res'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("StructIndex",1,MKBSDRowid))
			q:MKBSDRowid=""
			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
			if sequence'=""
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
				if MKBSDRRowid'=""
				{
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s Result=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDSupplement'=""
					{
						if Result["]"
						{
							s str=$e(Result,1,*-1)
							s Result=str_",("_MKBSDSupplement_")]"
						}
						else
						{
							s Result=Result_"[("_MKBSDSupplement_")]"
						}
					}					
				}
				else
				{
					s Result=""
				}
			}
			s Result=$$ALPHAUP^SSUTIL4(Result)
			if Result[Res
			{
				s rt(MKBSDRowid)=""
			}
		}
	}
	
	merge arr=dt
	merge arr=rt
	merge arr=it
	if $d(arr)
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(arr(MKBSDRowid))
			q:MKBSDRowid=""
			;诊断名，数据处理工厂的id，icd描述，icd编码，icddr，结构化诊断描述，结构化诊断id串，补充诊断
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
			s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)  //合并状态
			continue:MergeFlag'=""
			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
			if sequence'=""
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
				if MKBSDRRowid'=""
				{
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s Result=..GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDSupplement'=""
					{
						if Result["]"
						{
							s str=$e(Result,1,*-1)
							s Result=str_",("_MKBSDSupplement_")]"
						}
						else
						{
							s Result=Result_"[("_MKBSDSupplement_")]"
						}
					}					
				}
				else
				{
					s Result=""
				}
			}
		}	 
	}
}

/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructedDiag","GetSDList","糖尿病","","型")
/// d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBStructedDiag","GetSDList","","","")
Query GetSDList(diag As %String, icd As %String, result As %String) As %Query(ROWSPEC = "MKBSDRowid,MKBSDDiag,MKBSDMDr,MKBSDResultID,Result,MKBSDSupplement,MKBSDICD,MKBSDMrc")
{
}

ClassMethod GetSDListExecute(ByRef qHandle As %Binary, diag As %String, icd As %String, result As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s Diag=$zstrip(diag,"<>W")
	s Icd=$zstrip(icd,"<>W")
	s Res=$$ALPHAUP^SSUTIL4(result)
	if (Diag'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(Diag,"U"),MKBSDRowid))
			q:MKBSDRowid=""
			continue:MKBSDRowid["ICD"
			continue:MKBSDRowid["L"
			s dt(MKBSDRowid)=""	
		}
	}
	if (Icd'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MRCIndex",MKBSDRowid))
			q:MKBSDRowid=""
			s MRC=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			s MRCDesc=$p(^MRC("ID",MRC),"^",2)
			if MRCDesc[Icd
			s it(MKBSDRowid)=""
		}
	}
	if (Res'="")
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("StructIndex",1,MKBSDRowid))
			q:MKBSDRowid=""
			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
			if sequence'=""
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
				if MKBSDRRowid'=""
				{
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDSupplement'=""
					{
						if Result["]"
						{
							s str=$e(Result,1,*-1)
							s Result=str_",("_MKBSDSupplement_")]"
						}
						else
						{
							s Result=Result_"[("_MKBSDSupplement_")]"
						}
					}					
				}
				else
				{
					s Result=""
				}
			}
			s Result=$$ALPHAUP^SSUTIL4(Result)
			if Result[Res
			{
				s rt(MKBSDRowid)=""
			}
		}
	}
	
	merge arr=dt
	merge arr=rt
	merge arr=it
	if $d(arr)
	{
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(arr(MKBSDRowid))
			q:MKBSDRowid=""
			;诊断名，数据处理工厂的id，icd描述，icd编码，icddr，结构化诊断描述，结构化诊断id串，补充诊断
			s MKBSDDiag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s MKBSDMDr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)    //MRC指向
			s MKBSDICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)  //在ICD字段取值
			s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)  //在ICD描述字段取值
			s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)  //合并状态
			continue:MergeFlag'=""
			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
			if sequence'=""
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
				if MKBSDRRowid'=""
				{
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).GetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDSupplement'=""
					{
						if Result["]"
						{
							s str=$e(Result,1,*-1)
							s Result=str_",("_MKBSDSupplement_")]"
						}
						else
						{
							s Result=Result_"[("_MKBSDSupplement_")]"
						}
					}					
				}
				else
				{
					s Result=""
				}
				d getCTTitle
			}
		}	 
	}
		
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getCTTitle
	set Data=$lb(MKBSDRowid,MKBSDDiag,MKBSDMDr,MKBSDResultID,Result,MKBSDSupplement,MKBSDICD,MKBSDMrc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSDListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetSDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSDListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:李得原
/// CreatDate:2019-06-20
/// Description:安贞科室常用诊断界面数据导入
/// Table:User.MKBStructuredData
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).DiagToLoc4()
ClassMethod DiagToLoc4()
{
	Ts
	
	k LocList
	///遍历专业科室basedr
	s MKBTBRowId = $O(^User.MKBTermBaseI("FlagIndex"," LOC",0))
	///获取安贞科室对照basedr
	s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	
	
	///获取科室常用诊断
	s MKBLocDiagBase=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	s Loc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 科室",0))
	s Diag=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 诊断",0))
	s Fre=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 频次",0))


	///获取安贞科室对照中的实际科室
	s RealLocFieldChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))
	s RealLocFieldRowId = MKBKLMBRowId_"||"_RealLocFieldChild 
	
	s ProLocFiedldChild=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 专业科室",0))
	s ProLocFieldRowid= MKBKLMBRowId_"||"_ProLocFiedldChild
	
	s MKBLocMappingRowNum=0
	for
	{
		s MKBLocMappingRowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,MKBLocMappingRowNum))
		q:MKBLocMappingRowNum=""
		s ProLocValdr=$o(^User.MKBKLMappingDetailI("ValIndex",MKBLocMappingRowNum,ProLocFieldRowid,0))  //专业科室值rowid
		s RelLocValdr=$o(^User.MKBKLMappingDetailI("ValIndex",MKBLocMappingRowNum,RealLocFieldRowId,0)) //实际科室值rowid
		s ProLocdr=$lg($g(^User.MKBKLMappingDetailD(ProLocValdr)),2)
		s RealLocdr=$lg($g(^User.MKBKLMappingDetailD(RelLocValdr)),2)

		s LocList(ProLocdr,RealLocdr)=""
	}

	s CommonProLoc=0
	for
	{
		s CommonProLoc=$o(LocList(CommonProLoc))
		q:CommonProLoc=""
		k CenterWord
		s CommonRealLoc=0
		for
		{
			s CommonRealLoc=$o(LocList(CommonProLoc,CommonRealLoc))
			q:CommonRealLoc=""
			s ProLocDesc=$lg($g(^User.MKBTermD(CommonProLoc)),3)
			s RealLocDesc=$lg($g(^User.MKBTermD(CommonRealLoc)),3)
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(^User.MKBStructuredDataLocI("LocIndex"," "_$zconvert(RealLocDesc,"U"),MKBSDRowid))
				q:MKBSDRowid=""
				
				s DiagDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
				continue:MergeFlag'=""
				
				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
				if sequence'=""
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
					if MKBSDRRowid'=""
					{
						s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					}
				}
				continue:sequence=""
				
				s totalfre=0
				s MKBSDLRowid=0
				for
				{
					s MKBSDLRowid=$o(^User.MKBStructuredDataLocI("LocIndex"," "_$zconvert(RealLocDesc,"U"),MKBSDRowid,MKBSDLRowid))
					q:MKBSDLRowid=""
					s fre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)
					s totalfre=totalfre+fre
				}
				if $d(CenterWord(MKBSDResultTermdr))
				{
					s onefre=$o(CenterWord(MKBSDResultTermdr,0))
					s totalfre=totalfre+onefre
					
					k CenterWord(MKBSDResultTermdr)
					s CenterWord(MKBSDResultTermdr,totalfre)=""	
				}
				else
				{
					s CenterWord(MKBSDResultTermdr,totalfre)=""
				}	
			}
		}
		k Reverse
		s a=0
		for
		{
			s a=$o(CenterWord(a))
			q:a=""
			s b=0
			for
			{
				s b=$o(CenterWord(a,b))
				q:b=""
				s Reverse(b,a)=""
			}
		}
		s n=0
		s f=""
		for
		{
			s f=$o(Reverse(f),-1)
			q:f=""
			s Word=0
			for
			{
				s Word=$o(Reverse(f,Word))
				q:Word=""
				s flag=$lg($g(^User.MKBTermD(Word)),3)
				continue:flag=""
				//FieldValue=Loc_"[A]"_ProLoc_"[N]"_Diag_"[A]"_CenterWordRowid_"[N]"_Fre_"[A]"_fre
				s FieldValue=Loc_"[A]"_CommonProLoc_"[N]"_Diag_"[A]"_Word_"[N]"_Fre_"[A]"_f
				s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBLocDiagBase,FieldValue)
				s n=n+1
				q:n=200	
			}
			q:n=200
		}
		
	}
}

/// Creator:李得原
/// CreatDate:2019-06-24
/// Description:数据处理工厂根据其他描述找到原诊断短语，并把ICD和结构化结果统一成被合并到的诊断短语的ICD和结构化结果
/// Table:User.MKBStructuredData
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).UnifyOtherICDSD()
ClassMethod UnifyOtherICDSD()
{
	Ts
	k arr
	s sum1=0
	s sum2=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDMrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)   //取MRC指向
		s sum1=sum1+1
		s MKBSDORowid=0
		for
		{
			s MKBSDORowid=$o(^User.MKBStructuredDataOtherI("OtherMark","OD",MKBSDRowid,MKBSDORowid))
			q:MKBSDORowid=""
			s MKBSDOther=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructOther",MKBSDORowid)),2)   //其他描述
			s CaptionOther=$zconvert(MKBSDOther,"U")
			s CaptionOther=$replace(CaptionOther,"(","（")
			s CaptionOther=$replace(CaptionOther,")","）")
			s MKBSDrowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionOther,0))
			b:MKBSDrowid=""
			s sum2=sum2+1
			if $d(arr(MKBSDrowid))
			{
				continue
			}
			if $d(^User.MKBStructuredDataD(MKBSDrowid,"MKBSDStructResult"))   //如果被合并诊断存在结构化结果，则删除结构化结果
			{
				s MKBSDrrowid=0
				for
				{
					s MKBSDrrowid=$o(^User.MKBStructuredDataD(MKBSDrowid,"MKBSDStructResult",MKBSDrrowid))
					q:MKBSDrrowid=""
					s id=MKBSDrowid_"||"_MKBSDrrowid
					s dresult= ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(id)   //删除原结构化结果
					b:dresult["false"
				}
			}
			;w MKBSDrowid_"  "_MKBSDOther_"  "_sum,!
			if $d(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult"))  //如果主诊断存在结构化结果
			{

				s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
				if sequence'=""
				{
					s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
					if MKBSDRRowid'=""
					{

						s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)
						s MKBSDTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
						s MKBSDSupplement=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),5)
						s MKBSDSequence=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),6)
						;SaveData(Pid,Cid,StructResultID,StructResult,PropertyDR,Supplement)
						s rresult=""
						s rresult=##class(web.DHCBL.MKB.MKBStructuredData).SaveData(MKBSDrowid,"",MKBSDResultID,"",MKBSDTermdr,MKBSDSupplement) //新增结构化结果（不包含sequence）
						b:rresult["false"
						b:rresult=""
						
						s newid= $p(rresult,"'",4)
						s robj=##class(User.MKBStructuredDataResult).%OpenId(newid)
						s robj.MKBSDSequence=MKBSDSequence
						s rsc=robj.%Save()
						d robj.%Close()
						if $$$ISOK(rsc)
						{
							s rid=robj.%Id()
						}
						else
						{
							b ;1
						}
						
						;EditUpdate(rowid,MKBSDStatus,MKBSDMRCDr,MKBSDChildStructFlag,MKBSDMergeFlag,MKBSDLoc)
						s MKBSDstatus=$lg($g(^User.MKBStructuredDataD(MKBSDrowid)),5)
						s MKBSDstructflag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)
						s MKBSDmergeflag=$lg($g(^User.MKBStructuredDataD(MKBSDrowid)),15)
						s MKBSDloc=$lg($g(^User.MKBStructuredDataD(MKBSDrowid)),3)
						if MKBSDMrc'=""
						{
							s result=##class(web.DHCBL.MKB.MKBStructuredData).EditUpdate(MKBSDrowid,MKBSDstatus,MKBSDMrc,MKBSDstructflag,MKBSDmergeflag,MKBSDloc)
							b:result["false"
						}
						else
						{
							s obj=##class(User.MKBStructuredData).%OpenId(MKBSDrowid)
							d obj.MKBSDMRCDrSetObjectId("")
							s obj.MKBSDICD=""
							s obj.MKBSDICDDesc=""
							s sc=obj.%Save()
							d obj.%Close()
							if $$$ISOK(sc)
							{
								s id=obj.%Id()
							}
							else
							{
								b ;2
							}
						}
						s arr(MKBSDrowid)=""
					
					}
				}
				else    //如果主诊断不存在结构化结果
				{
					if $d(^User.MKBStructuredDataD(MKBSDrowid,"MKBSDStructResult"))   //如果被合并诊断存在结构化结果，则删除结构化结果
					{
						s MKBSDrrowid=0
						for
						{
							s MKBSDrrowid=$o(^User.MKBStructuredDataD(MKBSDrowid,"MKBSDStructResult",MKBSDrrowid))
							q:MKBSDrrowid=""
							s id=MKBSDrowid_"||"_MKBSDrrowid
							s dresult= ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(id)   //删除原结构化结果
							b:dresult["false"
						}
					}
					s MKBSDstatus=$lg($g(^User.MKBStructuredDataD(MKBSDrowid)),5)
					s MKBSDstructflag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),14)
					s MKBSDmergeflag=$lg($g(^User.MKBStructuredDataD(MKBSDrowid)),15)
					s MKBSDloc=$lg($g(^User.MKBStructuredDataD(MKBSDrowid)),3)
					s result=##class(web.DHCBL.MKB.MKBStructuredData).EditUpdate(MKBSDrowid,MKBSDstatus,MKBSDMrc,MKBSDstructflag,MKBSDmergeflag,MKBSDloc)
					b:result["false"
					s arr(MKBSDrowid)=""
				}
			}
		}
	}
	w $$$FormatText("有%1个父表id，有%2个子表id",sum1,sum2) 
	q ""
}

/// d ##class(web.DHCBL.MKB.MKBStructedDiag).UpdateICDFromAnzhen2()
ClassMethod UpdateICDFromAnzhen2()
{
	TS
	s sum=0
	s delnum=0
	s upnum=0
	s connum=0
	s file=##class(%File).%New("D:\ICDUpdate.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s Diag = $zstrip($P(str,",",1),"<>W")
		s ICDCode = $zstrip($P(str,",",5),"<>W")
		s ICDDesc = $zstrip($P(str,",",6),"<>W")
		s DelFlag = $zstrip($P(str,",",7),"<>W")
		if ((ICDCode="")&&(ICDDesc="")&&(DelFlag=""))
		{
			s connum=connum+1
			continue	
		}
		s Diag=$REPLACE($REPLACE(Diag,"(","（"),")","）")
		w Diag,!
		
		s MKBSDRowId=$O(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(Diag,"U"),0))
		b:MKBSDRowId=""
		if (DelFlag=1)
		{
			s delnum=delnum+1
			s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			d obj.MKBSDMRCDrSetObjectId("")
			s obj.MKBSDICD = ""
			s obj.MKBSDICDDesc = ""
			d obj.%Save()
			continue
		}
		s OriICDID=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),11)
		s OriICDCode=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),20)
		continue:OriICDCode'="00000"
		s OriICDDesc=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),21)
		
		s MRCID=0
		for
		{
			s MRCID=$O(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(OriICDDesc),MRCID))
			q:MRCID=""
			
			s MRCCode = $P($G(^MRC("ID",MRCID)),"^",4)
			q:MRCCode="00000"
		}
		b:MRCID=""
		s NewICDID=0
		for
		{
			s NewICDID = $O(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(ICDDesc),0))
			q:NewICDID=""	
			
			s NewICDCode=$P($G(^MRC("ID",NewICDID)),"^",4)
			q:NewICDCode=ICDCode
		}
		if NewICDID=""	
		{
			w ICDCode,"     ",ICDDesc,!	
			continue
		}
		s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
		d obj.MKBSDMRCDrSetObjectId(NewICDID)
		s obj.MKBSDICD = ICDCode
		s obj.MKBSDICDDesc = ICDDesc
		d obj.%Save()
		s upnum=upnum+1

	}
	w sum,!
	w delnum,!
	w upnum,!
	w connum,!
}

/// other: w ##class(web.DHCBL.MKB.MKBStructedDiag).BackUpFormalDatabase()
ClassMethod BackUpFormalDatabase()
{
	k List
	s List(1)="dhc.bdp.bdp.bdpdatafrequency.csp"
	s List(2)="dhc.bdp.bdp.bdpmenu.csp"
	s List(3)="dhc.bdp.bdpconfigadmin.csp"
	s List(4)="dhc.bdp.epr.default.csp"
	s List(5)="dhc.bdp.epr.frames.csp"
	s List(6)="dhc.bdp.epr.menu.csp"
	s List(7)="dhc.bdp.mkb.bdpdatachagenlog.csp"
	s List(8)="dhc.bdp.mkb.bdpdatachangelogwin.csp"
	s List(9)="dhc.bdp.mkb.bdptablemanage.csp"
	
	s List(10)="websys.SessionLogonmkb.cls"
	s List(11)="websys.SessionEventsmkb.cls"
	s List(12)="web.DHCBL.BDP.BDPDataChangeLog.cls"
	s List(13)="web.DHCBL.BDP.BDPDataFrequency.cls"
	s List(14)="web.DHCBL.BDP.BDPDataHistory.cls"
	s List(15)="web.DHCBL.BDP.BDPMenu.cls"
	s List(16)="web.DHCBL.BDP.BDPPlatformConfig.cls"
	s List(17)="web.DHCBL.BDP.BDPPlatformConfigAdmin.cls"
	s List(18)="web.DHCBL.BDP.BDPTableList.cls"
	s List(19)="web.DHCBL.BDP.BDPUploadFile.cls"
	s List(20)="web.DHCBL.BDP.BDPUserHabitHisUi.cls"
	s List(21)="web.DHCBL.BDP.FTPUploadFileLy.cls"
	s List(22)="web.DHCBL.BDP.FunLib.cls"
	s List(23)="User.BDPUserHabitHisUi.cls"
	s List(24)="User.BDPMenu.cls"
	s List(25)="User.BDPDataHistory.cls"
	s List(27)="User.BDPDataFrequency.cls"
	s i=0
	for
	{
		s n=$i(i)
		q:'$d(List(n))
		w n_" "_List(n),!
		s file=$e(List(n),1,*-3)_"xml"
		s Path="D:\工作\2019-06-24\123\"_file
		d $system.OBJ.Export(List(n),Path)
	}
}

ClassMethod ImportMiniao()
{
	Ts
	s sum=0
	s file=##class(%File).%New("D:\工作\2019-07-01\diag.csv")
	d file.Open("RS")
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s diag=$p(Line,",",1)
		s Diag=##class(web.DHCBL.BDP.FunLib).EvalJSON(diag)
		s CaptionDiag=$zconvert(Diag,"U")
		s mrc=$o(^MRC("ID",0,"Desc",CaptionDiag,0))
		
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag))
		{
			b
		}
		else
		{
			s obj=##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiag=Diag
			s obj.MKBSDDiagPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diag)
			s obj.MKBSDStatus="N"
			//如果有2诊断  则在新加个泌尿外科
			
		}
		
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportbbData()
/// 导入281条数据
ClassMethod ImportbbData()
{
	TS
	s MKBTBRowID=$O(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTRowId=$O(^User.MKBTermI("DescIndex",MKBTBRowID," 泌尿外科",0))
	b:MKBTRowId=""
	s file=##class(%File).%New("D:\bbData.csv")
	d file.Open("RS")
	s linenum=0
	s new=0
	s upd=0
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s Diag = $zstrip($P(str,",",1),"<>W")
		
		if $D(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(Diag,"U")))=0
		{
			s obj = ##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiag = Diag
			s obj.MKBSDDiagPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diag)
			s obj.MKBSDLoc = MKBTRowId
			s obj.MKBSDStatus="N"
			s obj.MKBSDTotalFreq=0
			s sc = obj.%Save()	
			b:$$$ERROR(sc)	
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diag),obj.%Id())
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Diag,obj.%Id())
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave("泌尿外科",obj.%Id()_"L")
			s new=new+1
		}
		else
		{
			s upd=upd+1
			s MKBSDRowId=$O(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(Diag,"U")),0)
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			if (obj.MKBSDLoc="")
			{
				s obj.MKBSDLoc=MKBTRowId
				s sc=obj.%Save()
				b:$$$ERROR(sc)
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave("泌尿外科",MKBSDRowId_"L")
					
			}	
			else
			{
				if (obj.MKBSDLoc'[MKBTRowId)
				{
					s obj.MKBSDLoc=obj.MKBSDLoc_","_MKBTRowId
					s sc=obj.%Save()
					b:$$$ERROR(sc)
					d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave("泌尿外科",MKBSDRowId_"L")
				}	
			}
		}
	}
	w linenum," ",new," ",upd,!
}

/// 把各版本ICD对照界面是否结构化字段填充
/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).AutoFillStructFlag()
ClassMethod AutoFillStructFlag()
{
	s sum=0
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		if $d(^User.MKBICDContrastResultI("MKBICDContrastIndex",MKBICDRowid))
		{
			s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
			s obj.MKBICDChildStructFlag=1
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				b ;1
			}
			
		}
	}
	q sum
}

/// 统计数据处理工厂有多少多于一条结构化结果的诊断
/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).CountTwoResultDiag()
ClassMethod CountTwoResultDiag()
{
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s Count=0
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s Count=Count+1
		}

		if Count>=2
		{
			s sum=sum+1
		}
	}
	w $$$FormatText("一共有%1条诊断有多于一条结构化结果",sum)
	q ""
}

/// 导入泌尿外科数据
/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertMiniaoData()
ClassMethod InsertMiniaoData()
{
	Ts
	s sum1=0
	s sum2=0
	s file=##class(%File).%New("D:\工作\2019-07-22\泌尿外科.csv")
	d file.Open("RS")
	d file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s Diag=$p(Line,",",1)
		s CaptionDiag=$zconvert(Diag,"U")
		s IcdNumber=$p(Line,",",2)
		s IcdDesc=$p(Line,",",3)
		s ProLoc=$p(Line,",",4)
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag))   //如果数据处理工厂存在此诊断短语
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag,0))
			continue:IcdNumber=""
			continue:IcdDesc=""
			s CaptionICDDesc=$$ALPHAUP^SSUTIL4(IcdDesc)
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			if $d(^MRC("ID",0,"Desc",CaptionICDDesc))        //如果MRC中存在此icd
			{
				s MRCRowid=$o(^MRC("ID",0,"Desc",CaptionICDDesc,0))
				
				s obj.MKBSDICDDesc=IcdDesc
				s obj.MKBSDICD=IcdNumber
				d obj.MKBSDMRCDrSetObjectId(MRCRowid)
				s temp=obj.MKBSDLoc
				if temp=""
				{
					s obj.MKBSDLoc="17218"
				}
				elseif temp'["17218"
				{
					s obj.MKBSDLoc=temp_","_"17218"
				}
			}
			else   //MRC中不存在此ICD
			{
				w $$$FormatText("ICD编码:%1, ICD释义:%2",IcdNumber,IcdDesc),!
				s obj.MKBSDICDDesc=IcdDesc
				s obj.MKBSDICD=IcdNumber
				s temp=obj.MKBSDLoc
				if temp=""
				{
					s obj.MKBSDLoc="17218"
				}
				elseif temp'["17218"
				{
					s obj.MKBSDLoc=temp_","_"17218"
				}
			}
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum1=sum1+1
			}
			else
			{
				b ;1
			}
			
		}
		else    //如果数据处理工厂不存在此诊断短语
		{
			b ;2
		}
	}
	w "sum1= "_sum1,!
	q ""
}

/// creater: 李欣
/// data：2018-11-23
/// description: 根据部位id获取诊断学包含描述的数据
/// input：termId
/// other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBAssInterface","GetDiagByPart","16393","","") 
Query GetDiagByPartClone(PartId, desc, deal) As %Query(ROWSPEC = "MKBTRowId,MKBTDesc,MKBPartDescF,MKBPartDesc,MKBDisDescF,MKBDisDesc,MKByn")
{
}

ClassMethod GetDiagByPartCloneExecute(ByRef qHandle As %Binary, PartId, desc, deal) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s base = $O(^User.MKBTermBaseI("FlagIndex"," PART",0))
	
	s partids = PartId_"^"_##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr(base,PartId)  //获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
	for i=1:1:$L(partids,"^")
	{
		continue:$P(partids,"^",i)=""
		s PartDesc = $LG($G(^User.MKBTermD($P(partids,"^",i))),3)
		s pd(PartDesc)=""	
	}
	
	
	s MKBTBRowId = $O(^User.MKBTermBaseI("FlagIndex"," DIAGNOSE",0))
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 部位",0))
		continue:MKBTPRowId=""	

		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
		
		continue:MKBTPDRowId=""
		s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		s MKBPartDescF = MKBTPDDesc
		s MKBPartDesc = $LG($G(^User.MKBTermD(MKBTPDDesc)),3)
		
		s MKBTPOtherRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 病因",0))
		s MKBTPDOtherRowId=""		
		s:MKBTPOtherRowId'="" MKBTPDOtherRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPOtherRowId,0))
		
		if (MKBTPDOtherRowId="")
		{
			s MKBDisDescF = ""
			s MKBDisDesc = ""	
		}
		else
		{
			s MKBTPDOtherDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDOtherRowId)),3)
			s MKBDisDescF=MKBTPDOtherDesc
			s MKBDisDesc = $LG($G(^User.MKBTermD(MKBTPDOtherDesc)),3)	
		}
		
		s PartDesc=""
		for
		{
			s PartDesc=$O(pd(PartDesc))	
			q:PartDesc=""
			
			if (MKBPartDesc=PartDesc)
			{
				if (deal=1)
				{
					if ($D(^TMP("mkbTermCR",MKBTRowId))) && (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							s MKByn=1
							d PartOutput
							s term(MKBTRowId)=""
							q
						}
							
					}		
				}
				elseif(deal=0)
				{
					if ($D(^TMP("mkbTermCR",MKBTRowId))=0) && (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							if ($D(^TMP("mkbTermCRGUM",MKBTRowId)))
							{
								s MKByn=2
							}
							else
							{
								s MKByn=0
							}
							s term(MKBTRowId)=""
							d PartOutput
							q
						}		
					}	
				}
				elseif(deal=2)
				{
					if ($D(^TMP("mkbTermCRGUM",MKBTRowId))) && (MKBTDesc[desc) &&($D(^TMP("mkbTermCR",MKBTRowId))=0)
					{
						if ($D(term(MKBTRowId))=0)
						{
							s MKByn=2
							d PartOutput
							s term(MKBTRowId)=""
							q	
						}
						
					}				
				}
				else
				{
					if (MKBTDesc[desc)
					{
						if ($D(term(MKBTRowId))=0)
						{
							if ($D(^TMP("mkbTermCR",MKBTRowId)))
							{
								s MKByn=1
							}
							else
							{
								if ($D(^TMP("mkbTermCRGUM",MKBTRowId)))
								{
									s MKByn=2
								}
								else
								{
									s MKByn=0
								}
							}
							s term(MKBTRowId)=""
							d PartOutput
							q	
						}
					}		
				}	
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PartOutput
    set Data=$lb(MKBTRowId,MKBTDesc,MKBPartDescF,MKBPartDesc,MKBDisDescF,MKBDisDesc,MKByn)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiagByPartCloneClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagByPartCloneExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDiagByPartCloneFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagByPartCloneExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 数据处理工厂结构化结果中心词里部位属于运动系统（16632包含子节点）或者属于脊柱（16601包含子节点）的诊断短语-》 专业科室标记为骨科17217
/// （ICD编码前3位的标为骨科）
/// 部位是女性生殖（16737）的诊断标记为妇产科（17231）。（ICD编码前3位的标为妇产科）
/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).Markorthopedics("16601","17217")
/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).Markorthopedics("16632","17217")
/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).Markorthopedics("16737","17231")
ClassMethod Markorthopedics(PartId As %String, Locid As %String)
{
	Ts
	s sum=0
	//d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBAssInterface","GetDiagByPart","16632","","")
	set rs=##class(%ResultSet).%New("web.DHCBL.MKB.MKBStructedDiag:GetDiagByPartClone")
	d rs.Execute(PartId,"","")
	while rs.Next()
	{
		s Termid=rs.Data("MKBTRowId")
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",Termid,MKBSDRowid))
			q:MKBSDRowid=""
			s diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s proloc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
			s icdnumber=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
			continue:proloc[Locid
			
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s loc=$lg($g(^User.MKBTermD(Locid)),3)
			if proloc=""
			{
				s obj.MKBSDLoc=Locid
			}
			else
			{
				s obj.MKBSDLoc=proloc_","_Locid
			}
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(loc, MKBSDRowid_"L")
			}
			else
			{
				b ;1
			}
			/*
			s FirstNum=$e(icdnumber,1,1)
			continue:FirstNum="Z"
			s ThreeNum=$e(icdnumber,1,3)
			continue:ThreeNum="M85"
			s rowid=0
			for
			{
				s rowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(ThreeNum,"U"),rowid))
				q:rowid=""
				continue:rowid["ICD"
				continue:rowid["L"
				s Number=$lg($g(^User.MKBStructuredDataD(rowid)),20)
				continue:$e(Number,1,3)'=ThreeNum
				s ProLoc=$lg($g(^User.MKBStructuredDataD(rowid)),3)
				s loc=$lg($g(^User.MKBTermD(Locid)),3)
				s nobj=##class(User.MKBStructuredData).%OpenId(rowid)
				if ProLoc=""
				{
					s nobj.MKBSDLoc=Locid
				}
				else
				{
					s nobj.MKBSDLoc=ProLoc_","_Locid
				}
				s nsc=nobj.%Save()
				d nobj.%Close()
				if $$$ISOK(nsc)
				{
					s nid=nobj.%Id()
					s sum=sum+1
					d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(loc, rowid_"L")
				}
				else
				{
					b ;2
				}
			}
			*/
			
		}
	}
	d rs.Close()
	s rs=""
	q sum
}

/// other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportPTWK()
ClassMethod ImportPTWK()
{
	Ts
	s sum=0
	s sum1=0
	s sum2=0
	s sum3=0
	s file=##class(%File).%New("D:\工作\2019-07-22\普通外科.csv")
	d file.Open("RS")
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		
		s diag=$p(Line,",",1)
		s diag=##class(web.DHCBL.BDP.FunLib).EvalJSON(diag)
		continue:diag=""
		s CaptionDiag=$zconvert(diag,"U")
		s CaptionDiag=$zstrip(CaptionDiag,"<>W")
		s sum3=sum3+1
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag))
		{
			s sum1=sum1+1
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag,0))
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s temp2=obj.MKBSDLoc
			if temp2=""
			{
				s obj.MKBSDLoc="17213"
			}
			elseif temp2'["17213"
			{
				s obj.MKBSDLoc=temp2_","_"17213"
			}
			
		}
		else
		{
			s sum2=sum2+1
			s obj=##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiag=diag
			s obj.MKBSDDiagPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
			s obj.MKBSDTotalFreq=0
			s obj.MKBSDStatus="N"
			s obj.MKBSDLoc="17213"
			
		}
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
			d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave("普通外科", id_"L")
		}
		else
		{
			s a=$system.OBJ.DisplayError(sc)
			b ;1
		}
	}
	w "已有的有"_sum1_"条诊断",!
	w "新增"_sum2_"条",!
	w "一共"_sum_"条",!
	w "一共"_sum3_"条",!
	q sum
}

/// 导入深圳地区术语excel
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertFuke()
ClassMethod InsertFuke()
{
	Ts
	s sum1=0
	s sum2=0
	s sum=0
	s file=##class(%File).%New("D:\工作\2019-07-22\妇科.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s Diag=$p(Line,",",1)
		s Diag=##class(web.DHCBL.BDP.FunLib).EvalJSON(Diag)
		s CaptionDiag=$zconvert(Diag,"U")
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag))
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_CaptionDiag,0))
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s temp=obj.MKBSDDiaSource
			s obj.MKBSDDiaSource=temp_"&"_"深圳地区术语"
			s sum1=sum1+1
			
		}
		else
		{
			s obj=##class(User.MKBStructuredData).%New()
			s obj.MKBSDDiag=Diag
			s obj.MKBSDDiagPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diag)
			s obj.MKBSDDiaSource="深圳地区术语"
			s obj.MKBSDTotalFreq=0
			s obj.MKBSDStatus="N"
			s sum2=sum2+1
		}
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			b ;1
		}	
	}
	w $$$FormatText("数据处理工厂已经存在%1,新增%2,一共有%3条",sum1,sum2,sum),!
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportFUKE()
ClassMethod ExportFUKE()
{
	s file=##class(%File).%New("D:\工作\2019-07-22\妇科CCDT分类.csv")
	d file.Open("RS")
	d file.ReadLine()
	s sum=0
	k ^Sort
	while 'file.AtEnd
	{
		s sum=sum+1
		s Line=file.ReadLine()
		continue:Line=""
		s diag=$p(Line,",",4)
		s diag=##class(web.DHCBL.BDP.FunLib).EvalJSON(diag)
		s diag=$zconvert(diag,"U")
		if $d(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_diag))
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_diag,0))
			s Term=""
			s Result=""
			s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))
			if sequence'=""
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,0))
				if MKBSDRRowid'=""
				{
					s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
					s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
					continue:MKBSDResultTermdr=""
					s Result=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
					s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
					if MKBSDSupplement'=""
					{
						if Result["]"
						{
							s str=$e(Result,1,*-1)
							s Result=str_",("_MKBSDSupplement_")]"
						}
						else
						{
							s Result=Result_"[("_MKBSDSupplement_")]"
						}
					}
					s Term=$lg($g(^User.MKBTermD(MKBSDResultTermdr)),3)
				}
				else
				{
					s Result=""
					s Term=""
				}
				
			}
			else
			{
				s Result=""
				s Term=""
			}
			s wLine=Line_","_Term_","_Result
			s ^Sort(sum)=wLine
		}
		else
		{
			b
		}
	}
	d file.%Save()
	d file.%Close()
	q ""
}

/// 
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportFUKEexcel()
ClassMethod ExportFUKEexcel()
{
	s file=##class(%File).%New("D:\a.csv")
	d file.Open("WNS")

	d file.WriteLine()
	s num=0
	for
	{
		s num=$o(^Sort(num))
		q:num=""
		s Line=^Sort(num)
		d file.Write(Line)
		d file.WriteLine()
		
	}
	d file.%Save()
	d file.%Close()
	q ""
}

/// 导MRC表，把没有匹配的mrc指向赋值
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ResetMrc()
ClassMethod ResetMrc()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s ICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
		s ICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)
		s ICDDesc=$zstrip(ICDDesc,"<>W")
		if ICD'=""
		{
			s mrc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),11)
			if mrc=""
			{
				s MRCRowid=$o(^MRC("ID",0,"Desc",ICDDesc,0))
				b:MRCRowid=""
				s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
				d obj.MKBSDMRCDrSetObjectId(MRCRowid)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					s id=obj.%Id()
					s sum=sum+1
				}
				else
				{
					b ;1
				}
			}
		}
	}
	w $$$FormatTextJS("sum is %1",sum),!
	q sum
}

/// 把数据处理工厂中专业科室为"普通外科"的科室清空
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).RemovePTWKLoc("普通外科")
ClassMethod RemovePTWKLoc(Loc As %String)
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTLRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_Loc,0))
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$O(^User.MKBStructIndexI("DescIndex"," "_$ZCONVERT(Loc,"U"),MKBSDRowid))
		q:MKBSDRowid=""
		continue:MKBSDRowid["ICD"
		continue:MKBSDRowid'["L"
		s lt($P(MKBSDRowid,"L",1))=""	
	}
	s MKBRowid=0
	for
	{
		s MKBRowid=$o(^User.MKBStructuredDataD(MKBRowid))
		q:MKBRowid=""
		s ProLoc=$lg($g(^User.MKBStructuredDataD(MKBRowid)),3)
		s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBRowid)),15)
		continue:MergeFlag'=""
		if ProLoc [ MKBTLRowid
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBRowid)
			if ProLoc=MKBTLRowid    //如果专业科室只有这一个
			{
				s NewLoc=""
			}
			elseif ProLoc[(","_MKBTLRowid_",")
			{
				s str=","_MKBTLRowid_","
				s NewLoc=$replace(ProLoc,str,",")
			}
			elseif ProLoc[ (","_MKBTLRowid)
			{
				s str=","_MKBTLRowid
				s NewLoc=$replace(ProLoc,str,"")
			}
			elseif (MKBTLRowid_",")
			{
				s str=MKBTLRowid_","
				s NewLoc=$replace(ProLoc,str,"")
			}
			s obj.MKBSDLoc=NewLoc
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
				d ##class(web.DHCBL.MKB.MKBStructIndex).DeleteIndex(Loc,MKBRowid_"L")
			}
			else
			{
				b ;1
			}
		}
	}
	q sum
}

/// 根据科室专业诊断-->"普通外科" 中心词去把数据处理工厂的诊断短语置为普通外科
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ProLocCenterToSDLoc("普通外科")
ClassMethod ProLocCenterToSDLoc(Loc As %String)
{
	Ts
	s sum1=0
	s sum2=0
	s sum3=0
	s MKBPLBase=$o(^User.MKBKLMappingBaseI("DescIndex"," 科室专业诊断",0))
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s MKBTLRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_Loc,0))

	s RowNum=0
	for
	{
		s RowNum=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBPLBase,RowNum))
		q:RowNum=""
		
		s ProLoc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBPLBase," 科室",0))
		s Diag=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBPLBase," 诊断",0))
		
		s LocValdr=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBPLBase_"||"_ProLoc,0))
		s DiagValdr=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBPLBase_"||"_Diag,0))
		s Locdr=$lg($g(^User.MKBKLMappingDetailD(LocValdr)),2)
		s Diagdr=$lg($g(^User.MKBKLMappingDetailD(DiagValdr)),2)
		continue:Locdr'=MKBTLRowid
		s arr(Diagdr)=""
	}
	s MKBRowid=0
	for
	{
		s MKBRowid=$o(arr(MKBRowid))
		q:MKBRowid=""
		if '$d(^User.MKBTermD(MKBRowid))
		{
			b
		}
		s active=$lg($g(^User.MKBTermD(MKBRowid)),9)
		b:active="N"
		s sum1=sum1+1
		s mark=""
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataResultI("TermIndex",MKBRowid,MKBSDRowid))
			q:MKBSDRowid=""
			if $d(mark(MKBSDRowid))
			{
				s sum3=sum3+1
				continue
			}
			;s MergeFlag=$lg($g(^User.MKBStructuredDataD(MKBRowid)),15)
			;continue:MergeFlag'=""
			s MKBSDLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),3)
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			if MKBSDLoc'=""
			{
				continue:MKBSDLoc[MKBTLRowid
				s obj.MKBSDLoc=MKBSDLoc_","_MKBTLRowid
			}
			else
			{
				s obj.MKBSDLoc=MKBTLRowid
			}
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum2=sum2+1
				s mark(MKBSDRowid)=""
				d ##class(web.DHCBL.MKB.MKBStructIndex).SingleSave(Loc,MKBSDRowid_"L")
			}
			else
			{
				b ;1
			}
		}
	}
	w "arr有"_sum1_"个."_"保存"_sum2_"次"_"重复保存"_sum3_"次",!
	q ""
}

/// 自动填充数据处理工厂basedr字段
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).FillBase()
ClassMethod FillBase()
{
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		d obj.MKBSDBaseDrSetObjectId(1)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			s id=obj.%Id()
			s sum=sum+1
		}
		else
		{
			b ;1
		}
	}
	q sum
}

/// 把数据处理工厂中MRC指向替换成term指向
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeMRCdrToTerm()
ClassMethod ChangeMRCdrToTerm()
{
	Ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MRCICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
		s MRCDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)

		s MKBTermBase=$o(^User.MKBTermBaseI("DescIndex"," 安贞ICD",0))
		s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTermBase," "_$zconvert(MRCDesc,"U"),0))
		continue:MKBTRowid=""
		s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," ICD编码",0))
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0))
		s MKBICD=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
		if MKBICD=MRCICD
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			d obj.MKBSDICDTermDrSetObjectId(MKBTRowid)
			s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				s id=obj.%Id()
				s sum=sum+1
			}
			else
			{
				b ;1
			}
		}
		
	}
	q sum
}

/// 20846
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetFileData("国家临床2.0-疾病分类与代码","北京临床-ICD10V6.01","国家临床2.0TO北京临床6.01")
ClassMethod GetFileData(Nation As %String, Peking As %String, Frame As %String)
{
	Ts
	s (SaveSum,NoNationSum,NoPekingSum)=0
	s NationBase=$o(^User.MKBTermBaseI("DescIndex"," "_$Zconvert(Nation,"U"),0))
	s PekingBase=$o(^User.MKBTermBaseI("DescIndex"," "_$Zconvert(Peking,"U"),0))
	
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," "_Frame,0))
	;^User.MKBKLMappingBaseFieldI("DescIndex",41," 国家临床2.0编码"
	s MKBKLMFNRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 国家临床2.0名称",0))
	s MKBKLMFPRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 北京临床6.01名称",0))
	
	
	s file=##class(%File).%New("D:\工作\2019-08-05\国标临床2.0To北京临床6.01-diag.csv")
	d file.Open("RS")
	d file.ReadLine()
	While 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s Line=##class(web.DHCBL.BDP.FunLib).EvalJSON(Line)
		;^User.MKBTermBaseD(73)=$lb("","SY000037","国家临床2.0-疾病分类与代码","L","","","GJLC20JBFLYDM","","41061","","57","GJLC20JBFLYDM")
		;^User.MKBTermBaseD(74)=$lb("","SY000038","北京临床-ICD10V6.01","L","","","BJLCIC    D10V601","","41061","","58","BJLCICD10V601")
		s NationCode=$p(Line,",",2)
		s NationDesc=$p(Line,",",3)
		s PekingCode=$p(Line,",",4)
		s PekingDesc=$p(Line,",",5)
		s NationCode=$zstrip(NationCode,"<>W")
		s NationDesc=$zstrip(NationDesc,"<>W")
		s PekingCode=$zstrip(PekingCode,"<>W")
		s PekingDesc=$zstrip(PekingDesc,"<>W")
		s NationFlag=0
		s PekingFlag=0
		s PekingFlags=0
		s NationFlags=0
		s (MKBTPDRowid,MKBTNDRowid,MKBTNCode,MKBTPCode)=""
		s SignNationDesc=$replace(NationDesc,"（","(")
		s SignNationDesc=$replace(SignNationDesc,"）",")")
		if ($d(^User.MKBTermI("DescIndex",NationBase," "_$zconvert(NationDesc,"U")))||($d(^User.MKBTermI("DescIndex",NationBase," "_$zconvert(SignNationDesc,"U")))))       //国家临床2.0是否存在知识库
		{
			s MKBTNDRowid=$o(^User.MKBTermI("DescIndex",NationBase," "_$zconvert(NationDesc,"U"),0))
			if MKBTNDRowid=""
			{
				s MKBTNDRowid=$o(^User.MKBTermI("DescIndex",NationBase," "_$zconvert(SignNationDesc,"U"),0))
			}
			s MKBTNPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTNDRowid," 主要编码",0))
			s MKBTNPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTNPRowid,0))
			s MKBTNPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTNPDRowid)),3)
			s MKBTNPARowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTNDRowid," 附加编码",0))
			s MKBTNPDARowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTNPARowid,0))
			if $d(^User.MKBTermProDetailD(MKBTNPDARowid))
			{
				s MKBTNPDADesc=$lg($g(^User.MKBTermProDetailD(MKBTNPDARowid)),3)
				s MKBTNPDDesc=MKBTNPDDesc_MKBTNPDADesc
				s MKBTNPDDesc=$replace(MKBTNPDDesc,"?","+")
				s MKBTNPDDesc=$replace(MKBTNPDDesc,$c(8224),"+")
			}
			if MKBTNPDDesc=NationCode
			{
				s NationFlag=1
			}
			s NationFlags=1
		}
		s SignPekingDesc=$replace(PekingDesc,"（","(")
		s SignPekingDesc=$replace(SignPekingDesc,"）",")")
		if ($d(^User.MKBTermI("DescIndex",PekingBase," "_$zconvert(PekingDesc,"U")))||($d(^User.MKBTermI("DescIndex",PekingBase," "_$zconvert(SignPekingDesc,"U")))))            //北京版是否存在知识库
		{
			s MKBTPDRowid=$o(^User.MKBTermI("DescIndex",PekingBase," "_$zconvert(PekingDesc,"U"),0))
			if MKBTPDRowid=""
			{
				s MKBTPDRowid=$o(^User.MKBTermI("DescIndex",PekingBase," "_$zconvert(SignPekingDesc,"U"),0))
			}
			s MKBTPPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTPDRowid," ICD编码",0))
			s MKBTPPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPPRowid,0))
			s MKBTPPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPPDRowid)),3)
			if MKBTPPDDesc=PekingCode
			{
				s PekingFlag=1
			}
			
			s PekingFlags=1
		}
		
		if ((NationFlags=1)&(PekingFlags=1))               //如果国家临床2.0和北京版都存在知识库
		{
			/*
			s fieldValueStr=MKBKLMFNRowid_"[A]"_MKBTNDRowid_"[N]"_MKBKLMFPRowid_"[A]"_MKBTPDRowid
			s Result= ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBKLMBRowid,fieldValueStr)	
			s SaveSum=SaveSum+1
			if Result["false"
			{
				b
			}
			*/
			s SaveSum=SaveSum+1
		}
		elseif NationFlag=0
		{
			 w $$$FormatText("国家临床2.0不存在知识库：%1",NationDesc),!
			 s NoNationSum=NoNationSum+1
		}
		elseif PekingFlag=0
		{
			w $$$FormatText("北京临床6.0不存在知识库：%1",PekingDesc),!
			s NoPekingSum=NoPekingSum+1
		}
		
	}
	q "保存"_SaveSum_"个，国家临床2.0找不到"_NoNationSum_"个，北京6.01找不到"_NoPekingSum_"个"
}

/// 给珊珊提供接口，通过描述取北京版icd
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetPekingICD("霍乱")
ClassMethod GetPekingICD(desc As %String) As %String
{
	s Desc=$zconvert(desc,"U")
	s MKBICD=""
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Desc,MKBICDRowid))
		q:MKBICDRowid=""
		s Type=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		if Type["A"
		{
			s MKBICD=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)
		}
	}
	if MKBICD=""
	{
		s NationBase=$o(^User.MKBTermBaseI("DescIndex"," "_$Zconvert("国家临床2.0-疾病分类与代码","U"),0))
		s PekingBase=$o(^User.MKBTermBaseI("DescIndex"," "_$Zconvert("北京临床-ICD10V6.01","U"),0))
		
		s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 国家临床2.0TO北京临床6.01",0))
		s MKBKLMFNRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 国家临床2.0名称",0))
		s MKBKLMFPRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 北京临床6.01名称",0))
		s NationField=MKBKLMBRowid_"||"_MKBKLMFNRowid
		s PekingField=MKBKLMBRowid_"||"_MKBKLMFPRowid
		s MKBKLRow=0
		for
		{
			s MKBKLRow=$o(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowid,MKBKLRow))    //遍历行
			q:MKBKLRow=""
			s ValueRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLRow,NationField,0))   //值rowid
			s Value=$lg($g(^User.MKBKLMappingDetailD(ValueRowid)),2)                        //值
			s MKBDesc=$lg($g(^User.MKBTermD(Value)),3)
			if MKBDesc=desc
			{
				s PekingValueRowid=$o(^User.MKBKLMappingDetailI("ValIndex",MKBKLRow,PekingField,0))   //值rowid
				s PekingValue=$lg($g(^User.MKBKLMappingDetailD(PekingValueRowid)),2)                        //值
				s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",PekingValue," ICD编码",0))
				s MKBTermProDelRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
				s MKBICD=$lg($g(^User.MKBTermProDetailD(MKBTermProDelRowid)),3)
				q
			}
		}
	}
	q MKBICD
}

/// 通过ICD代码和描述找MRCID的rowid
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetMRCIDByCode("A00.900","霍乱")
ClassMethod GetMRCIDByCode(code, desc)
{
	s code=$zstrip(code,"<>W")
	s MRCRowid=0
	for
	{
		s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(desc),MRCRowid))
		q:MRCRowid=""

		s Code=$p(^MRC("ID",MRCRowid),"^",4)
		if Code=code
		{
			q 
		}
	}
	q MRCRowid
}

/// 医疗部-李欣  16:21:38
/// d ##class(web.DHCBL.MKB.MKBStructedDiag).DealMappingExps()
ClassMethod DealMappingExps()
{
	Ts
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s MKBKLMFChild=0
		for
		{
			s MKBKLMFChild=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild))
			q:MKBKLMFChild=""
			
			s FieldConfig=$LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),5)
			continue:FieldConfig'="Exp"	
			
			s RowNum=0
			for
			{
				s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
				q:RowNum=""
				
				s MKBKLMDRowId=0
				for
				{
					s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_MKBKLMFChild,MKBKLMDRowId))
					q:MKBKLMDRowId=""
					
					s val = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
					continue:val=""
					if ((val[";&")||(val[";|"))
					{
						s sc = ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(RowNum,MKBKLMBRowId)
						b:sc["false"	
					}
				}
			}
		}
	}
}

/// Creator:李欣	
/// Desc:重新生成引用表数据-规则管理
/// d ##class(web.DHCBL.MKB.MKBReference).ReGenerateReferFromMapping()
ClassMethod ReGenerateReferFromMapping()
{

	///规则注册
	s MKBKLMBRowId = 0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s kno1 = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),5)
		s kno2 = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId)),6)
		
		if ((kno1'="D")&&(kno1'="A"))
		{
			s result1=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MB",MKBKLMBRowId,"B",kno1)
			;b:result1["error" ;result1	
		}	
		if ((kno2'="D")&&(kno2'="A"))
		{
			s result2=##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MB",MKBKLMBRowId,"B",kno2)
			;b:result2["error" ;result2	
		}
		///字段
		s MKBKLMFChild = 0
		for
		{
			s MKBKLMFChild = $O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild))
			q:MKBKLMFChild=""
			
			s MKBKLMFType = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),4)
			if ((MKBKLMFType="K1")||(MKBKLMFType="K2"))	
			{
				s MKBKLMFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",MKBKLMFChild)),5)
				if ((MKBKLMFConfig'="Exp")&&(MKBKLMFConfig'="Desc"))	
				{
					s result3 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MF",MKBKLMBRowId_"||"_MKBKLMFChild,"P",MKBKLMFConfig)	
					;b:result3["error" ;result3
				}
				if (MKBKLMFConfig="Desc")
				{
					s RowNum=0
					for
					{
						s RowNum = $O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
						q:RowNum=""
						
						///内容
						s MKBKLMDRowId=0
						for
						{
							s MKBKLMDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_MKBKLMFChild,MKBKLMDRowId))
							q:MKBKLMDRowId=""
							
							s MKBKLMDVal = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
							continue:MKBKLMDVal=""
							if ($D(^User.MKBTermD(MKBKLMDVal))=0)
							{
								w MKBKLMDVal,!
								continue	
							}
							s result4 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MD",MKBKLMDRowId,"T",MKBKLMDVal)		
							;b:result4["error" ;result4
						} 	
					}	
				}				
			}
		}
	}
}

/// 张云越 2019-08-29
/// Others：        w ##class(web.DHCBL.MKB.MKBStructedDiag).BackupAZICD("D:\","专业科室")
ClassMethod BackupAZICD(filePath As %String, fileName As %String) As %String
{
	s BackupNum = 0
	
	s MKBTBRowid= $o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s file = ##class(%File).%New(filePath_fileName_".csv")
	d file.Open("NWS") ///new write stream
	d file.Write("id,描述,父级id,父级描述")
	d file.WriteLine()
	s MKBTRowid = 0
	for
	{		
		s MKBTRowid = $o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid)) //中心词
		q:MKBTRowid=""
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		s MKBTDesc=$replace(MKBTDesc,",","，")
		s MKBTPRowid=$lg($g(^User.MKBTermD(MKBTRowid)),5)
		s MKBTPDesc=""
		s:MKBTPRowid'="" MKBTPDesc=$lg($g(^User.MKBTermD(MKBTPRowid)),3)
		s:MKBTPRowid'="" MKBTPDesc=$replace(MKBTPDesc,",","，")
		
		
		d file.Write(MKBTRowid_","_MKBTDesc_","_MKBTPRowid_","_MKBTPDesc)
		d file.WriteLine()
		s BackupNum = BackupNum+1				
	}
	w BackupNum
	d file.%Save()
	d file.%Close()
	q "读表写出csv成功"
}

/// 把各版本icd对照中的A,B,C,D改成对应的rowid
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).SubstituteRowidForABCD()
ClassMethod SubstituteRowidForABCD()
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," ICD版本",0))
	

	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s MKBTDesc=$Lg($g(^User.MKBTermD(MKBTRowid)),3)
		s arr(MKBTDesc)=MKBTRowid
	}
	
	
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s Sources=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		s sourcelen=$l(Sources,"&")
		s MKBICDSource=""
		for i=1:1:sourcelen
		{
			s Source=$p(Sources,"&",i)
			continue:Source=""
			s SourceString=$select(Source="A":"ICD-10 v6.01版",Source="B":"疾病分类与ICD代码(2015国家修订版)",Source="C":"疾病分类与代码国家临床版1.1",Source="D":"疾病分类与代码国家临床版2.0")
			if $d(arr(SourceString))
			{
				s Sources=$replace(Sources,Source,arr(SourceString))
			}
			
		}
		s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
		s obj.MKBICDDiaSource=Sources
		s sc=obj.%Save()
		s sum=sum+1
		if $$$ISERR(sc)
		{
			s result=$system.OBJ.DisplayError(sc)
			b
		}
		d obj.%Close()
	}
	q sum
}

/// 把各版本icd对照中的结构化结果拆开存到Version表中
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).TakeApartICDStructToVersion()
/// MKBVDataFlag                    MKBVDataID                  MKBVVersion
/// User.MKBTerm5                    14870 (淋巴系统恶性肿瘤)   1
/// User.MKBTermProperty14870        4998（病情描述）           1
/// User.MKBTermProDetail4998        10668（非霍奇金）          1
ClassMethod TakeApartICDStructToVersion()
{
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s MKBICDDiaSource=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)
		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
			q:MKBICDRRowid=""
			s MKBICDTerm=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4)
			s MKBICDResultId=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)
			continue:'$d(^User.MKBTermD(MKBICDTerm))
			s MKBTBRowid=$lg($g(^User.MKBTermD(MKBICDTerm)),4)    //base
			s MKBTVDataFlag="User.MKBTerm"_MKBTBRowid             //Flag标识 存入的第一个值
			s MKBTVDataID=MKBICDTerm   //获取MKBVDataID  存入的第二个值
			s MKBICDSLength=$l(MKBICDDiaSource,"&")
			for i=1:1:MKBICDSLength                 
			{
				s EachVersion=$p(MKBICDDiaSource,"&",i)
				continue:EachVersion=""
				s MKBTVVersion=EachVersion
				//VersionDataIdx On (MKBVVersion As Exact, MKBVDataFlag As Exact, MKBVDataID As Exact);
				continue:$d(^User.MKBVersionI("VersionDataIdx",MKBTVVersion,MKBTVDataFlag,MKBTVDataID))
				
				s obj=##class(User.MKBVersion).%New()               //把Term值每一个version下都存一遍
				s obj.MKBVDataFlag=MKBTVDataFlag
				s obj.MKBVDataID=MKBTVDataID
				d obj.MKBVVersionSetObjectId(MKBTVVersion)
				s sc=obj.%Save()
				if $$$ISERR(sc)
				{
					s result=$system.OBJ.DisplayError(sc)
					b ;1
				}
			}
			if MKBICDResultId'=""           //如果有属性内容
			{
				s MKBPDLength=$l(MKBICDResultId,",")
				for j=1:1:MKBPDLength
				{
					s EachProDetail=$p(MKBICDResultId,",",j)     //获取每条属性以及属性内容 
					continue:EachProDetail=""
					s Property=$p(EachProDetail,":",1)
					continue:'$d(^User.MKBTermPropertyD(Property))
					s MKBPVDataFlag="User.MKBTermProperty"_MKBICDTerm
					s MKBPVDataID=Property
					s MKBICDSLength=$l(MKBICDDiaSource,"&")
					for i=1:1:MKBICDSLength                 
					{
						s EachVersion=$p(MKBICDDiaSource,"&",i)
						continue:EachVersion=""
						s MKBPVVersion=EachVersion
						continue:$d(^User.MKBVersionI("VersionDataIdx",MKBPVVersion,MKBPVDataFlag,MKBPVDataID))
						s obj=##class(User.MKBVersion).%New()               //把Property值每一个version下都存一遍
						s obj.MKBVDataFlag=MKBPVDataFlag
						s obj.MKBVDataID=MKBPVDataID
						d obj.MKBVVersionSetObjectId(MKBPVVersion)
						s sc=obj.%Save()
						if $$$ISERR(sc)
						{
							s result=$system.OBJ.DisplayError(sc)
							b ;2
						}
						d obj.%Close()
					}
					
					s Details=$p(MKBICDResultId,":",2)
					
					for i=1:1:MKBICDSLength                 
					{
						s EachVersion=$p(MKBICDDiaSource,"&",i)
						continue:EachVersion=""
						s MKBDVVersion=EachVersion
						s MKBICDDLength=$l(Details,"*")
						for k=1:1:MKBICDDLength
						{
							s Detail=$p(Details,"*",k)
							if Detail["S"
							{
								s Detail=$replace(Detail,"S","")
								continue:'$d(^User.MKBTermD(Detail))
								s MKBTBRowid=$lg($g(^User.MKBTermD(Detail)),4)     //把属性内容为引用术语的都存一遍
								s MKBDVDataFlag="User.MKBTerm"_MKBTBRowid
								s MKBDVDataID=Detail
							}
							else
							{
								continue:'$d(^User.MKBTermProDetailD(Detail))
								s MKBDVDataFlag="User.MKBTermProDetail"_Property        //把属性内容不为术语的存一遍
								s MKBDVDataID=Detail
							}
							continue:$d(^User.MKBVersionI("VersionDataIdx",MKBTVVersion,MKBDVDataFlag,MKBDVDataID))
							s obj=##class(User.MKBVersion).%New()            
							s obj.MKBVDataFlag=MKBDVDataFlag
							s obj.MKBVDataID=MKBDVDataID
							d obj.MKBVVersionSetObjectId(MKBTVVersion)
							s sc=obj.%Save()
							if $$$ISERR(sc)
							{
								s result=$system.OBJ.DisplayError(sc)
								b ;3
							}
						}
					}
				}
			}
		}
	}
	q ""
}

/// 安贞数据处理工厂的icd那个指针数据得更新一下,指向安贞ICD界面
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).UpdateSDWithAnzhenICDFrame()
ClassMethod UpdateSDWithAnzhenICDFrame()
{
	Ts
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 安贞ICD",0))
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s (MKBICDNumber,MKBICDDesc,MKBTRowid,MKBTPRowid,MKBTPDRowid,MKBTPDDesc)=""
		s MKBICDNumber=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
		s MKBICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)
		continue:MKBICDDesc=""
		s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(MKBICDDesc,"U"),0))
		if MKBTRowid=""
		{
			b ;在安贞ICD找不到
			continue
		}
		s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," ICD编码",0))
		s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0))
		s MKBTPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
		b:MKBICDNumber=""
		if MKBTPDDesc=MKBICDNumber
		{
			s sum=$i(sum)
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			d obj.MKBSDICDTermDrSetObjectId(MKBTRowid)
			s sc=obj.%Save()
			if $$$ISERR(sc)
			{
				s result=$system.OBJ.DisplayError(sc)
				b
			}
		}
	}
	q sum
}

/// 导入医学知识分级字典表
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).GetDistickMedicalKnoClassDict()
ClassMethod GetDistickMedicalKnoClassDict()
{
	s sum=0
	k ^ldy
	s file=##class(%File).%New("D:\工作\2019-09-16\同义词字典表去重用.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		s Desc=$p(Line,",",1)
		s NodeP=$p(Line,",",2)
		s Synonym=$p(Line,",",3)
		if Desc'=""
		{
			s Desc=$zstrip(Desc,"<>W")
			s Desc=##class(web.DHCBL.BDP.FunLib).Util(Desc)
			s ^ldy(Desc)=""
			
		}
		if NodeP'=""
		{
			s NodeP=$zstrip(NodeP,"<>W")
			s NodeP=##class(web.DHCBL.BDP.FunLib).Util(NodeP)
			s ^ldy(NodeP)=""
		}
		if Synonym'=""
		{
			s Synonym=$zstrip(Synonym,"<>W")
			s Synonym=##class(web.DHCBL.BDP.FunLib).Util(Synonym)
			s ^ldy(Synonym)=""
		}
	}
	q ""
}

/// 导出医学知识分级字典表临时global
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportYXZSFJ()
ClassMethod ExportYXZSFJ()
{
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		s LastLevel=$lg($g(^User.MKBTermD(MKBTRowid)),5)
		s ^LDY(MKBTRowid,Desc)=LastLevel
		s sum=sum+1
	}
	q sum
}

/// 导入医学知识分级字典表临时global
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportYXZSFJ()
ClassMethod ImportYXZSFJ()
{
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^LDY(MKBTRowid))
		q:MKBTRowid=""
		s Desc=$o(^LDY(MKBTRowid,""))
		s LastLevel=^LDY(MKBTRowid,Desc)
		s eobj=##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTActiveFlag="Y"
		s eobj.MKBTBaseDR=MKBTBRowid
		s eobj.MKBTDesc=Desc
		s eobj.MKBTLastLevel=LastLevel
		s eresult=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
		s sum=sum+1
		if eresult["false"
		{
			b
		}
		
	}
	q sum
}

/// 通过python导入医学知识分级字典表
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportMedicalKnoClassDictPy()
ClassMethod ImportMedicalKnoClassDictPy(Desc As %String) As %String
{
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	
	s Desc=$zstrip(Desc,"<>W")
	s Desc=##class(web.DHCBL.BDP.FunLib).Util(Desc)
	
	s eobj=##class(web.Entity.MKB.MKBTerm).%New()
	s eobj.MKBTActiveFlag="Y"
	s eobj.MKBTBaseDR=MKBTBRowid
	s eobj.MKBTDesc=Desc
	
	s result=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
	q result
}

ClassMethod getSynom(desc As %String) As %String
{
	if desc=""
	{
		q "2"
	}
	s n=$o(^Pare(""),-1)
	s ^Pare(n+1) =desc
	q "1"
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).CoutLDYY()
ClassMethod CoutLDYY()
{
	s sum=0
	s rowid=""
	for
	{
		s rowid=$o(^LDYY(rowid))
		q:rowid=""
		s sum=sum+1
	}
	q sum
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ReadTxt()
ClassMethod ReadTxt()
{
	Ts
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	s n=0
	for
	{
		s n=$o(^LDYY(n))
		q:n=""
		s desc=^LDYY(n)
		s len=$l(desc,"$")
		s flag=0
		s descflag=""
		for i=1:1:len
		{
			s each=$p(desc,"$",i)
			if $d(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(each,"U")))
			{
				s desc=$replace(desc,each,"")
				s flag=1
				s descflag=each
			}
		}
		if flag=0
		{
			w desc,!
		}
		else
		{
			s le=$l(desc,"$")
			for j=1:1:le
			{
				s eachdesc=$p(desc,"$",j)
				continue:eachdesc=""
				s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(descflag,"U"),0))
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 同义词字典",0))
				;w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
				s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
				s eobj.MKBTPDDesc=eachdesc
				s eobj.MKBTPDProDR=MKBTPRowid
				s eobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(each)
				s result=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
				if result["false"
				{
					w "result:"_eachdesc_" "_MKBTRowid,!
				}
			}
		}
	}
}

/// 导入医学知识分级字典表
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportMedicalKnoClassDict()
ClassMethod ImportMedicalKnoClassDict()
{
	d DISABLE^%NOJRN
	Ts
	s sum=0
	s psum=0
	s ssum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	
	s file=##class(%File).%New("D:\工作\2019-09-16\同义词字典表-.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		s (Term,Parent,Synom)=""
		continue:Line=""
		s Term=$p(Line,",",1)
		s Parent=$p(Line,",",2)
		s Synom=$p(Line,",",3)

		s Term=##class(web.DHCBL.BDP.FunLib).Util(Term)
		s Parent=##class(web.DHCBL.BDP.FunLib).Util(Parent)
		s Synom=##class(web.DHCBL.BDP.FunLib).Util(Synom)
		
		s Term=$zstrip(Term,"<>W")
		s Parent=$zstrip(Parent,"<>W")
		s Synom=$zstrip(Synom,"<>W")
		
		
		
		if Term'=""
		{

			if '$d(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Term,"U")))
			{
				s eobj=##class(web.Entity.MKB.MKBTerm).%New()
				s eobj.MKBTActiveFlag="Y"
				s eobj.MKBTBaseDR=MKBTBRowid
				s eobj.MKBTDesc=Term
				s eresult=##class(web.DHCBL.MKB.MKBTerm).SaveData(eobj)
				if eresult["success"
				{
					s sum=sum+1
					b:Term="%/1h"
				}
				else
				{
					w result,!
					b ;1
				}
			}
				
		}
		if Parent'=""
		{

			if '$d(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Parent,"U")))
			{
	
				s pobj=##class(web.Entity.MKB.MKBTerm).%New()
				s pobj.MKBTActiveFlag="Y"
				s pobj.MKBTBaseDR=MKBTBRowid
				s pobj.MKBTDesc=Parent
				s presult=##class(web.DHCBL.MKB.MKBTerm).SaveData(pobj)
				if presult["success"
				{
					s psum=psum+1
				}
				else
				{
					w presult,!
					b ;2
				}
			}
		}
		if Synom'=""
		{

			if '$d(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Synom,"U")))
			{
	
				s pobj=##class(web.Entity.MKB.MKBTerm).%New()
				s pobj.MKBTActiveFlag="Y"
				s pobj.MKBTBaseDR=MKBTBRowid
				s pobj.MKBTDesc=Synom
				s presult=##class(web.DHCBL.MKB.MKBTerm).SaveData(pobj)
				if presult["success"
				{
					s ssum=ssum+1
				}
				else
				{
					w presult,!
					b ;2
				}
			}
		}
	}
	q sum+psum+ssum
	d ENABLE^%NOJRN
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertGlobalPare()
ClassMethod InsertGlobalPare()
{
	s sum=0
	s n=0
	for
	{
		s n=$o(^Pare(n))
		q:n=""
		s desc=^Pare(n)
		s result= ..ImportMedicalKnoClassParentDictPy(desc)
		w:result["false" result
		s sum=sum+1
	}
	q sum
}

/// python导入医学知识分级字典表NodeParent
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportMedicalKnoClassParentDictPy("妇科晚期恶性肿瘤减灭术$腹部操作与手术")
ClassMethod ImportMedicalKnoClassParentDictPy(desc As %String) As %String
{
	s result=""
	s Term=$p(desc,"$",1)
	s pare=$p(desc,"$",2)
	
	s Term=$zstrip(Term,"<>W")
	s Term=##class(web.DHCBL.BDP.FunLib).Util(Term)
	
	s pare=$zstrip(pare,"<>W")
	s pare=##class(web.DHCBL.BDP.FunLib).Util(pare)
	
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	s MKBTPRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(pare,"U"),0))
	if MKBTPRowid=""
	{ 
		s result="false"_MKBTBRowid_":"_pare
	}
	s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Term,"U"),0))
	if MKBTRowid="" 
	{
		s result="false"_MKBTRowid_":"_Term
	}
	s obj=##class(User.MKBTerm).%OpenId(MKBTRowid)
	d obj.MKBTLastLevelSetObjectId(MKBTPRowid)
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		s result="{success:'true',info:'成功！'}"
	}
	else
	{
		s info=$system.OBJ.DisplayError(sc)
		s result="{false"_info_"}"
	}
	d obj.%Close()
	q result
}

/// 导入医学知识分级字典表NodeParent
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportMedicalKnoClassParentDict()
ClassMethod ImportMedicalKnoClassParentDict()
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	
	s file=##class(%File).%New("D:\工作\2019-09-09\同义词字典表pare.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s Term=$p(Line,",",1)
		s Term=$zstrip(Term,"<>W")
		s Term=##class(web.DHCBL.BDP.FunLib).Util(Term)
		continue:Term=""
		s ParentNode=$p(Line,",",2)
		s ParentNode=$zstrip(ParentNode,"<>W")
		s ParentNode=##class(web.DHCBL.BDP.FunLib).Util(ParentNode)
		continue:ParentNode=""
		s MKBTPRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(ParentNode,"U"),0))
		b:MKBTPRowid=""
		s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Term,"U"),0))
		s obj=##class(User.MKBTerm).%OpenId(MKBTRowid)
		d obj.MKBTLastLevelSetObjectId(MKBTPRowid)
		s sc=obj.%Save()
		if $$$ISOK(sc)
		{
			s sum=sum+1
		}
		else
		{
			s result=$system.OBJ.DisplayError(sc)
			b ;1
		}
	}
	q sum
}

/// 删除医学知识分级字典表
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).DelMedicalKnoClass()
ClassMethod DelMedicalKnoClass()
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s result= ##class(User.MKBTerm).%DeleteId(MKBTRowid)
		b:result["false"
	}
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportDictRule()
ClassMethod ImportDictRule()
{
 
	s sum=0
	s str=""
	for
	{
		s str=$o(^LDYY(str))
		q:str=""
		s result=..SynonymDictPy(str)
		if result["false"
		{
			s sum=sum+1
			w result,!
		}
	}
	q sum
}

/// python同义词字典规则注册
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).SynonymDictPy()
ClassMethod SynonymDictPy(str As %String) As %String
{

	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	
	s Desc=$p(str,"$",1)
	s Synonym=$p(str,"$",2)
	
	s Desc=$zstrip(Desc,"<>W")
	s Desc=##class(web.DHCBL.BDP.FunLib).Util(Desc)
	s Synonym=$zstrip(Synonym,"<>W")
	s Synonym=##class(web.DHCBL.BDP.FunLib).Util(Synonym)
	s MKBTDRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Desc,"U"),0))
	s MKBTSRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Synonym,"U"),0))
	
	if ((MKBTDRowid'="")&&(MKBTSRowid'=""))
	{
		s MKBTDPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTDRowid," 同义词字典",0))
		s dobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
		s dobj.MKBTPDDesc=Synonym
		s dobj.MKBTPDCode=""
		s dobj.MKBTPDProDR=MKBTDPRowid
		s dobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Synonym)
		s dresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(dobj)
		if dresult["false"
		{
			w "ddresult:"_dresult,!
		}
		
		s MKBTDSRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTSRowid," 同义词字典",0))
		s sobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
		s sobj.MKBTPDCode=""
		s sobj.MKBTPDDesc=Desc
		s sobj.MKBTPDProDR=MKBTSRowid
		s sobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s sresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(sobj)
		if sresult["false"
		{
			w "ssresult:"_sresult_"Desc:"_Desc_"||"_"Synonym:"_Synonym,!
		}
	}
	elseif (MKBTDRowid'="")
	{
		s MKBTDPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTDRowid," 同义词字典",0))
		s dobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
		s dobj.MKBTPDDesc=Synonym
		s dobj.MKBTPDProDR=MKBTDPRowid
		s dobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Synonym)
		s dresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(dobj)
		if dresult["false"
		{
			w "dresult:"_dresult_"Desc:"_Desc,!
		}
	}
	elseif (MKBTSRowid'="")
	{
		s MKBTDSRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTSRowid," 同义词字典",0))
		s sobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
		s sobj.MKBTPDDesc=Desc
		s sobj.MKBTPDProDR=MKBTSRowid
		s sobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s sresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(sobj)
		if sresult["false"
		{
			w "sresult:"_sresult_"Synonym:"_Synonym,!
		}
	}
	else
	{
		w "false:"_Desc_":"_MKBTDRowid_"[N]"_Synonym_":"_MKBTSRowid,!
		
	}
	q ""
}

/// 同义词字典规则注册
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).SynonymDict()
ClassMethod SynonymDict()
{
	Ts
	s sum=0
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 同义词字典",0))
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 医学知识分级字典表",0))
	
	s MKBMBFDesc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 知识名称",0))
	s MKBMBFSyno=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 同义词项名称",0))
	s mark=""
	s file=##class(%File).%New("D:\工作\2019-09-16\同义词字典.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		s (Desc,Synonym,fieldStr)=""
		s Desc=$p(Line,",",1)
		s Synonym=$p(Line,",",2)
		continue:Synonym=""
		if $d(mark(Desc_Synonym))
		{
			continue
		}
		else
		{
			s mark(Desc_Synonym)=""
		}
		s Desc=$zstrip(Desc,"<>W")
		s Desc=##class(web.DHCBL.BDP.FunLib).Util(Desc)
		s Synonym=$zstrip(Synonym,"<>W")
		s Synonym=##class(web.DHCBL.BDP.FunLib).Util(Synonym)
		s MKBTDRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Desc,"U"),0))
		s MKBTSRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$zconvert(Synonym,"U"),0))
		if ((MKBTDRowid'="")&&(MKBTSRowid'=""))
		{
			s fieldStr=MKBMBFDesc_"[A]"_MKBTDRowid_"[N]"_MKBMBFSyno_"[A]"_MKBTSRowid
			s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("", MKBKLMBRowid, fieldStr)
			if result["false"
			{
				b ;1 保存出错
			}
		}
		else
		{
			b ;2 rowid为空没找到
		}
	}
}

/// 根据MRC表更改数据处理工厂拼音码，多个拼音码用逗号隔开
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeSDPY()
ClassMethod ChangeSDPY()
{
	Ts
	s sum=0
	s n=0
	s MRCRowid=0
	for
	{
		s MRCRowid=$O(^MRC("ID",MRCRowid))
		q:MRCRowid=""

		s PY=""
		s PYS=""
		s Num=0
		for
		{
			s Num=$o(^MRC("ID",MRCRowid,"ALIAS",Num))
			q:Num=""
			s PY=^MRC("ID",MRCRowid,"ALIAS",Num)
			s PY=$zconvert(PY,"U")
			s:PYS'="" PYS=PYS_"，"_PY
			s:PYS="" PYS=PY
		}
		s n=n+1
		s MRCDesc=$p(^MRC("ID",MRCRowid),"^",2)
		s MRCDesc=$Zstrip(MRCDesc,"<>W")
		s MKBSDRowid=$o(^User.MKBStructuredDataI("MKBSDDiagIndex",1," "_$zconvert(MRCDesc,"U"),0))
		if MKBSDRowid'=""
		{
			s note=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),16)
			s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
			s result=##class(web.DHCBL.MKB.MKBStructuredData).UpdateParDia(MKBSDRowid, MKBSDDesc, PYS,note) 
			s sum=sum+1
			if result["false"
			{
				b
			}
		}

	}
	w "MRC有"_n,!
	w "匹配到"_sum,!
	q ""
}

/// 把被合并隐藏的HIS诊断释放出来
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).SetFreeHisOnMerge()
ClassMethod SetFreeHisOnMerge()
{
	ts
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
		s MKBSDMerge=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),15)
		if (MKBSDSource["HIS")&(MKBSDMerge'="")
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
			s obj.MKBSDMergeFlag=""
			s sc=obj.%Save()
			if $$$ISERR(sc)
			{
				b
			}
			else
			{
				w MKBSDDesc,!
				s sum=sum+1
			}
		}
	}
	q sum
}

/// 数据处理工厂中HIS诊断短语和描述不一致的统计有多少
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).CountHisDiffDescAndIcd()
ClassMethod CountHisDiffDescAndIcd()
{
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s MKBSDICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)
		s MKBSDSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
		if MKBSDSource["HIS"
		{
			s MKBSDDesc=$replace(MKBSDDesc,",","，")
			s MKBSDICDDesc=$replace(MKBSDICDDesc,",","，")
			if MKBSDDesc'=MKBSDICDDesc
			{
				w MKBSDICDDesc_","_MKBSDDesc,!
				s sum=sum+1
			}
		}
	}
	q sum
}

/// 数据处理工厂把诊断来源为his的重新匹配icd'
/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).ChangeSDHisICD()
ClassMethod ChangeSDHisICD()
{
	Ts
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 安贞ICD",0))
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBSDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		
		s MKBSDICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)
		s MKBSDSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),10)
		if MKBSDSource["HIS"
		{

			if MKBSDICDDesc=""
			{
				s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$Zconvert(MKBSDDesc,"U"),0))
		
				if (MKBTRowid="")||(MKBTRowid=0)
				{
					
					
				}
				else
				{
					s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
					s MRCRowid=$o(^MRC("ID",0,"Desc",$$ALPHAUP^SSUTIL4(MKBTDesc),0))
					if MRCRowid'=""
					{
						s ActiveTo=$p(^MRC("ID",MRCRowid),"^",9)
						b:ActiveTo'=""
						
					}
					else
					{
						b ;4
					}
				
					s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," ICD编码",0))
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,0))
					s MKBTICD=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
					s obj.MKBSDICD=MKBTICD
					s obj.MKBSDICDDesc=MKBTDesc
					d obj.MKBSDICDTermDrSetObjectId(MKBTRowid)
					s sc=obj.%Save()
					if $$$ISERR(sc)
					{
						s result=$system.OBJ.DisplayError(sc)
						b ;2
					}
				}
			}
			else
			{
				s MKBSDDescd=$replace(MKBSDDesc,",","，")
				s MKBSDDescd=$replace(MKBSDDescd,"(","")
				s MKBSDDescd=$replace(MKBSDDescd,")","")
				s MKBSDDescd=$replace(MKBSDDescd,"（","")
				s MKBSDDescd=$replace(MKBSDDescd,"）","")
				s MKBSDICDDesc=$replace(MKBSDICDDesc,",","，")
				s MKBSDICDDesc=$replace(MKBSDICDDesc,"(","")
				s MKBSDICDDesc=$replace(MKBSDICDDesc,")","")
				s MKBSDICDDesc=$replace(MKBSDICDDesc,"（","")
				s MKBSDICDDesc=$replace(MKBSDICDDesc,"）","")
				s MKBSDDescd=$zstrip(MKBSDDescd,"*W")
				s MKBSDICDDesc=$zstrip(MKBSDICDDesc,"*W")
				if MKBSDDescd'=MKBSDICDDesc
				{
					s MKBTRowid=""
					s MKBTRowid=$o(^User.MKBTermI("DescIndex",MKBTBRowid," "_$Zconvert(MKBSDDesc,"U"),0))
					if (MKBTRowid="")||(MKBTRowid=0)
					{
						w MKBSDICDDesc_","_MKBSDDesc,!
						s sum=sum+1
					}
					
					
				}
			}
		}
	}
	q sum
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).CountTree()
ClassMethod CountTree()
{
	s sum=0
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("ParentIndex",83,-100000000000000,MKBTRowid))
		q:MKBTRowid=""
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		b:MKBTDesc="根节点"
		s sum=sum+1
	}
	q sum
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).GetJson()
ClassMethod GetJson()
{
	s file=##class(%File).%New("D:\工作\2019-09-09\江苏省中医院结构化诊断相关g.csv")
	d file.Open("RS")
	s Line=file.ReadLine()

	s j=$p(Line,",",2)
	s j=$replace(j,"，",",")
	
	
	
	s j=$e(j,2,*-1)
	s a=##class(%DynamicAbstractObject).%FromJSON(j)
	w j,!
	;s a=[].%ToJSON(j)
	w a
	q ""
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).GetRidOfOther()
/// 处理临床学实用诊断的数据，带其他的都加到别名里去，去掉其他的名字作为中心词
ClassMethod GetRidOfOther()
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermD(MKBTRowid))
		q:MKBTRowid=""
		s base=$lg($g(^User.MKBTermD(MKBTRowid)),4)
		continue:base'=MKBTBRowid
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		s OtherFlag=$e(MKBTDesc,1,2)
		if OtherFlag="其他"
		{
			s obj=##class(User.MKBTerm).%OpenId(MKBTRowid)
			s obj.MKBTDesc=$e(MKBTDesc,3,*)
			s sc=obj.%Save()
			if $$$ISOK(sc)
			{
				s sum=sum+1
				s result="success:true"
			}
			else
			{
				s result="success:false"_$system.OBJ.DisplayError(sc)
				b ;1
			}
			
			s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 别名",0))
			;w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
			s eobj.MKBTPDActiveFlag="Y"
			s eobj.MKBTPDCode=""
			s eobj.MKBTPDDesc=MKBTDesc
			s eobj.MKBTPDProDR=MKBTPRowid
			s eobj.MKBTPDRowId=""
			s eobj.MKBTPDSequence=""
			s eobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTDesc)
			s eresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
			if eresult["false"
			{
				w "eresult:"_eresult,!
				
			}
		}
	}
	q sum
}

/// Others：w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertTermBeforeOther()
/// 处理临床学实用诊断的数据，带其他的都加到别名里去，去掉其他的名字作为中心词,把别名中只有一个的，而且为“其他”的别名，把中心词作为第一个，其他作为第二个
ClassMethod InsertTermBeforeOther()
{
	Ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermD(MKBTRowid))
		q:MKBTRowid=""
		s base=$lg($g(^User.MKBTermD(MKBTRowid)),4)
		continue:base'=MKBTBRowid
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)

		s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 别名",0))
		;Index SeqIndex On (MKBTPDProDR, MKBTPDSequence As Exact);
		s n=0
		s sequences=0
		for
		{
			s sequences=$o(^User.MKBTermProDetailI("SeqIndex",MKBTPRowid,sequences))
			q:sequences=""
			s n=n+1
		}
		if n=1
		{
			s sequence=$o(^User.MKBTermProDetailI("SeqIndex",MKBTPRowid,0))
			s MKBTPDRowid=$o(^User.MKBTermProDetailI("SeqIndex",MKBTPRowid,sequence,0))
			s MKBTPDDesc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
			s qitaflag=$e(MKBTPDDesc,1,2)
			if qitaflag["其他"
			{
				
				s aobj=##class(User.MKBTermProDetail).%OpenId(MKBTPDRowid)
				s aobj.MKBTPDSequence=sequence+1
				s osc=aobj.%Save()
				d aobj.%Close()
				if $$$ISERR(osc)
				{
					w "error:"_$system.OBJ.DisplayError(osc),!
				}

				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 别名",0))
				;w ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
				s eobj=##class(web.Entity.MKB.MKBTermProDetail).%New()
				s eobj.MKBTPDActiveFlag="Y"
				s eobj.MKBTPDCode=""
				s eobj.MKBTPDDesc=MKBTDesc
				s eobj.MKBTPDProDR=MKBTPRowid
				s eobj.MKBTPDRowId=""
				s eobj.MKBTPDSequence=sequence
				s eobj.MKBTPDPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTDesc)
				s eresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(eobj)
				if eresult["false"
				{
					w "eresult:"_MKBTDesc_" "_eresult,!
				}
				s sum=sum+1
				;w MKBTDesc,!
			}
		}
		
	}
	q sum
}

/// （1）内分泌科，血管外科/甲状腺外科的诊断按频次导出来，并且把该诊断的诊断模板里的数据都显示出来。
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetYDYTermGlobal("血管外科/甲状腺外科")
ClassMethod GetYDYTermGlobal(realloc As %String)
{
	s sum=0
	k term
	k frequence
	s MKBSDFre=0
	for
	{
		s MKBSDFre=$o(^User.MKBStructuredDataLocI("LocFreIndex",realloc,MKBSDFre))
		q:MKBSDFre=""
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataLocI("LocFreIndex",realloc,MKBSDFre,MKBSDRowid))
			q:MKBSDRowid=""
			s MKBSDLLRowid=0
			for
			{
				s MKBSDLLRowid=$o(^User.MKBStructuredDataLocI("LocFreIndex",realloc,MKBSDFre,MKBSDRowid,MKBSDLLRowid))
				q:MKBSDLLRowid=""
				s MKBSDLSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLLRowid)),4)
				
				s MKBBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
				continue:MKBBase'=3   //医大一
				if $d(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult"))
				{
					s MKBSDRRowid=0
					for
					{
						s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))	
						q:MKBSDRRowid=""
						s MKBSDRTerm=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
						continue:MKBSDRTerm=""
						s sum=sum+1
						if $d(term(MKBSDRTerm))
						{
							s fre=$o(term(MKBSDRTerm,0))
							s fre=fre+MKBSDFre
							k term(MKBSDRTerm)
							k frequence(MKBSDRTerm,MKBSDLSource)
							s frequence(MKBSDRTerm,MKBSDLSource,fre)=""
							s term(MKBSDRTerm,fre)=""
						}
						else
						{
							s frequence(MKBSDRTerm,MKBSDLSource,MKBSDFre)=""
							s term(MKBSDRTerm,fre)=""
						}
					}
				}
			}
		}
	}
	/*
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(term(MKBTRowid))
		q:MKBTRowid=""
		s source=""
		for
		{
			s source=$o(term(MKBTRowid,source))
			q:source=""
			s Freq=0
			for
			{
				s Freq=$o(term(MKBTRowid,source,Freq))
				q:Freq=""
				s ^ldy(Freq,source,MKBTRowid)=""
			}
		}
	}
	*/
	q sum
}

/// s realloc("血管外科网络门诊")=""
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetYDYTermGlobal2(.realloc)
ClassMethod GetYDYTermGlobal2(ByRef realloc)
{
	k ^term
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s MKBBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
		continue:MKBBase'=3  //医大一
		s MKBSDRRowid=0
		for
		{
			s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
			q:MKBSDRRowid=""
			s MKBSDRRTermid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
			continue:MKBSDRRTermid=""
			continue:'$d(^User.MKBTermD(MKBSDRRTermid))
			s MKBSDLRowid=0
			for
			{
				s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
				q:MKBSDLRowid=""
				s MKBLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2) //科室名
				s MKBFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)  //频次
				s MKBSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),4) //来源
				;if (MKBLoc="血管外科/甲状腺外科")||(MKBLoc="门诊血管外科/甲状腺外科")
				
				if $d(realloc(MKBLoc))
				{
					if $d(^term(MKBSDRRTermid))
					{
						s ^term(MKBSDRRTermid,MKBSource)=$g(^term(MKBSDRRTermid,MKBSource))+MKBFre
					}
					else
					{
						s ^term(MKBSDRRTermid,MKBSource)=MKBFre
					}
				}
			}
		}
	}

	k ^ldy
	s MKBTerm=0
	for
	{
		s MKBTerm=$o(^term(MKBTerm)) q:MKBTerm=""
		s count=0
		s Source=""
		for
		{
			s Source=$o(^term(MKBTerm,Source)) q:Source=""
			s fre=$g(^term(MKBTerm,Source))
			s:fre="" fre=0
			s count=count+fre
		}
		s ^ldy(count,MKBTerm)=""
	}
	q ""
}

/// （2）内分泌科，血管外科/甲状腺外科的诊断按频次导出来，并且把该诊断的诊断模板里的数据都显示出来。
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportYDYTermProDetails()
ClassMethod ExportYDYTermProDetails(filename As %String)
{
	s name="D:\工作\2019-11-18\阳光融合\诊断模板\"_filename_".csv"
	s fname=filename_".csv"
	s file=##class(%File).%New(name)
	d file.Open("NSW")
	d file.WriteLine("频次,别名,中心词,属性,属性内容")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))   //获取baseid
	
	s Frequ=""
	for
	{
		s Frequ=$o(^ldy(Frequ),-1)
		q:Frequ=""
		;continue:Frequ<5
		s MKBTermRowid=0
		for
		{
			s MKBTermRowid=$o(^ldy(Frequ,MKBTermRowid))
			q:MKBTermRowid=""
			continue:'$d(^User.MKBTermD(MKBTermRowid))
			s MKBTermDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)  //获取临床实用诊断中心词
			s MKBTermDesc=$replace(MKBTermDesc,",","，")
			
			
			
			set AliasItem=""
			;获取未匹配到的中心词的别名
			s AliasNum=0
			set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTermRowid)    
			set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
			set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
			s AliasString=""
			for n=1:1:AliasNum
			{
				set AliasItem=$p(TermDataAlias,",",n)
				s AliasItem=$replace(AliasItem,",","，")
				s:AliasString'="" AliasString=AliasString_"，"_AliasItem
				s:AliasString="" AliasString=AliasItem
			}
			s L=0
			s O=0
			
			s LocFlag=""
			if $d(^term(MKBTermRowid,"L"))
			{
				s L=^term(MKBTermRowid,"L")
			}
			if $d(^term(MKBTermRowid,"O"))
			{
				s O=^term(MKBTermRowid,"O")
			}
			s LO=L+O
			b:LO'=Frequ
			d file.WriteLine("总频次("_Frequ_")，"_"住院("_L_")，门急诊("_O_")"_","_"别名("_AliasString_")"_","_MKBTermDesc)
			;d file.WriteLine("总频次("_Frequ_")，"_"住院("_L_")，门急诊("_O_")")
			
			s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
			s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
			s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
			s length=$l(MKBTemplate,",")
			for i=1:1:length
			{
				continue:i=""
				s OnePiece=$p(MKBTemplate,",",i)
				s TempProRowid=$p(OnePiece,"&",1)    //属性ID
				s DefineNode=$p(OnePiece,"&",3)  //定义节点
				s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
				s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
				s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
				continue:PDesc="其他描述"
				d file.WriteLine(",,,"_PDesc)
				s Desc=""
				if "TX,TA,R,CB,C,L,T,F"[MKBTPType
				{
					if DefineNode'=""
					{
						s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
						s Property=$replace(Property,",","，")
						d file.WriteLine(",,,,"_Property)
						s DescStr=##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStr(DefineNode,TempProRowid,0,1)
						continue:DescStr=""
						s desclen=$l(DescStr,"^")
						for k=1:1:desclen
						{
							continue:k=""
							s Desc=$p(DescStr,"^",k)
		
							s Desc=$replace(Desc,",","，")
							d file.WriteLine(" ,,,,,"_Desc)
						}
					}
					else
					{
						s MKBTPDRowid=0
						for
						{
							s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
							q:MKBTPDRowid=""
							s Desc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
							s Desc=$replace(Desc,",","，")
							d file.WriteLine(",,,,"_Desc)
						}
					}
				} 
				elseif MKBTPType="S"    //引用术语
				{
					
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)    
						s strCom=$p(strComAndAlisa,"[A]",1)
						s Desc=$p(strCom,"&%",1) //诊断常用名
						if Desc=""
						{
							s Desc=$lg($g(^User.MKBTermD(Term)),3)
						}
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(" ,,,,"_Desc)
					}
				}
				elseif MKBTPType="P"
				{
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(" , ,,,"_Desc)
					}
				}
				elseif MKBTPType="SS"   //引用单节点
				{
					s MKBTPDRowid=0
					for
					{
						
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						
						s str=""
						;s term=$lg($g(^User.MKBTermD(Term)),3)
						s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
						s strCom=$p(strComAndAlisa,"[A]",1)
						s term=$p(strCom,"&%",1) //诊断常用名
						if term=""
						{
							s term=$lg($g(^User.MKBTermD(Term)),3)
						}
						s term=$replace(term,",","，")
						d file.WriteLine(",,,,"_term)
						s Desc=..GetSSData(.str,MKBConfig,Term,0,1)
						s str=$replace(str,",","，")
						s len=$l(str,"^")
						for j=1:1:len
						{
							continue:j=""
							s desc=$p(str,"^",j)
							d file.WriteLine(" ,,,,,"_desc)
						}
					}
					
				}
				else
				{
					continue
				}
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q fname
}

/// w ##class(web.DHCBL.MKB.MKBTerm).GetChildOrderedIDStr("52","128958")
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSSData(.str,52,128958)
ClassMethod GetSSData(ByRef str, base As %String, id As %String, flags As %String, first As %String)
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="    "_mark
		}
	}
	s seq=0
	for
	{
		s seq=$o(^User.MKBTermI("ParSeqIndex",base,id,seq))
		
		q:seq=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParSeqIndex",base,id,seq,MKBTRowid))
			q:MKBTRowid=""
			
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s MKBTDesc=$p(strCom,"&%",1) //诊断常用名
			if MKBTDesc=""
			{
				s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			}
			s:str'="" str=str_"^"_mark_MKBTDesc
			s:str="" str=mark_MKBTDesc
			if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))  //如果有子节点
			{
				d ..GetSSData(.str,base,MKBTRowid,flags,2)
			}
		}
	}
	q str
}

ClassMethod GetChildOrderedIDStr(LastLevel As %String, property As %String, flags As %String, first As %String) As %String
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="    "_mark
		}
	}
	if (LastLevel="") s LastLevel=-100000000000000	
	s IDStr=""
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			s childStr=..GetChildOrderedIDStr(myRowID, property,flags,2)
			s desc=$lg($g(^User.MKBTermProDetailD(myRowID)),3)
			if childStr'="" s childStr=mark_desc_"^"_childStr
			if childStr="" s childStr=mark_desc
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// /// w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportYDYCommonDiag()
/// 医大一科室常用诊断（专业科室：内分泌科 血管外科、风湿免疫科）
ClassMethod ImportYDYCommonDiag()
{
	k arr
	s ProBase=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0))
	s ProRowid=0
	for
	{
		s ProRowid=$o(^User.MKBTermI("BaseIndex",ProBase,ProRowid))
		q:ProRowid=""
		s ProDesc=$lg($g(^User.MKBTermD(ProRowid)),3)
		s arr(ProDesc)=""
	}
	
	/*
	s arr("内分泌科")=""
	s arr("血管外科")=""
	s arr("风湿免疫科")=""
	*/
	s MKBProLocBase=$o(^User.MKBTermBaseI("DescIndex"," 专业科室",0)) 
	s MKBRelLocBase=$o(^User.MKBTermBaseI("DescIndex"," 实际科室",0))
	
	s MKBKLMBRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 医大一科室对照",0))
	s MKBKLFProRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 专业科室",0))
	s MKBKLFRelRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowid," 实际科室",0))
	
	s loc=""
	for
	{
		s loc=$o(arr(loc))
		q:loc=""
		
		s MKBProLocRowid=$o(^User.MKBTermI("DescIndex",MKBProLocBase," "_loc,0)) //专业科室名rowid
		k locarr
		s MKBMDRowid=0
		for
		{
			s MKBMDRowid=$o(^User.MKBKLMappingDetailD(MKBMDRowid))
			q:MKBMDRowid=""
			s MKBMBFDr=$lg($g(^User.MKBKLMappingDetailD(MKBMDRowid)),3)
			s MKBMBTDr=$lg($g(^User.MKBKLMappingDetailD(MKBMDRowid)),2)
			s Fieldstr=MKBKLMBRowid_"||"_MKBKLFProRowid
			continue:Fieldstr'=MKBMBFDr
			continue:MKBMBTDr'=MKBProLocRowid
			s RowNum=$lg($g(^User.MKBKLMappingDetailD(MKBMDRowid)),4)
			s MKBDRowid=$o(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowid_"||"_MKBKLFRelRowid,0))
			s MKBRealLocRowid=$lg($g(^User.MKBKLMappingDetailD(MKBDRowid)),2)
			s MKBLocDesc=$lg($g(^User.MKBTermD(MKBRealLocRowid)),3)
			s locarr(MKBLocDesc)=""                   //把所有对照上专业科室的实际科室中文描述放到数组里
			
		}
		
		continue:'$d(locarr)
		d ..GetYDYTermGlobal2(.locarr)
		s MKBKLMBCRowid=$o(^User.MKBKLMappingBaseI("DescIndex"," 医大一科室常用诊断",0))
		s MKBKLMBPRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBCRowid," 科室",0))
		s MKBKLMBDRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBCRowid," 诊断",0))
		s MKBKLMBFRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBCRowid," 频次",0))
		s MKBKLMBNRowid=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBCRowid," 备注",0))
		s Freq=""
		for
		{
			s Freq=$o(^ldy(Freq),-1)
			q:Freq=""
			continue:Freq<10
			s MKBTermRowid=0
			for
			{
				s MKBTermRowid=$o(^ldy(Freq,MKBTermRowid))
				q:MKBTermRowid=""
				//	s fieldValueStr="1[A]17228[N]2[A]15879[3][N]4[A]25293"
				//s result=..SaveData(rowNum,base,fieldValueStr)
				s fieldValueStr=MKBKLMBPRowid_"[A]"_MKBProLocRowid_"[N]"_MKBKLMBDRowid_"[A]"_MKBTermRowid_"[N]"_MKBKLMBNRowid_"[A]"_"[N]"_MKBKLMBFRowid_"[A]"_Freq
				s result=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MKBKLMBCRowid,fieldValueStr)
				b:result["false"
			}
		}
	}
	q ""
}

ClassMethod MakeDir()
{
	w ##class(%File).Exists()
	w ##class(%File).DirectoryExists()
	w ##class(%File).CreateDirectory()
	s file=##class(%File).%New()
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ProcessingDiagStatusDegree()
ClassMethod ProcessingDiagStatusDegree()
{
	ts
	s sum=0
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBTBBRowid=$o(^User.MKBTermBaseI("DescIndex"," 通用描述",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermD(MKBTRowid))
		q:MKBTRowid=""
		s MKBTPRowid=0
		for
		{
			s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 病情",MKBTPRowid))
			q:MKBTPRowid=""
			s ifCommonDesc=$lg($g(^User.MKBTermPropertyD(MKBTPRowid)),5)
			if ifCommonDesc=MKBTBBRowid
			{
				s obj=##class(User.MKBTermProperty).%OpenId(MKBTPRowid)
				s obj.MKBTPName="病情轻重"
				s obj.MKBTPDesc="病情轻重"
				s sc= obj.%Save()
				if $$$ISOK(sc)
				{
					s sum=sum+1
				}
				else
				{
					s result=$system.OBJ.DisplayError(sc)
					w MKBTRowid,!
					continue:result["键不唯一"
				}
			}
		}
	}
	q sum
}

/// Creator:李得原
/// CreatDate:2019-11-05
/// Description：导出临床实用诊断诊断模板中的数据
/// Input：
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportDiagTemplate(base)
ClassMethod ExportDiagTemplate(base)
{
	q:base="" ""
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if 'ifExistsDir
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s filename = $LISTGET($G(^User.MKBTermBaseD(base)),3)_"知识模板数据"_".csv"
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_filename
	s file=##class(%File).%New(PathDir)
	d file.Open("NWS")
	d file.WriteLine("中心词,属性,属性内容")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))   //获取baseid
	s MKBTermRowid=0
	for
	{
		s MKBTermRowid=$o(^User.MKBTermD(MKBTermRowid))
		q:MKBTermRowid=""
		s MKBTBase=$lg($g(^User.MKBTermD(MKBTermRowid)),4)
		continue:MKBTBase'=MKBTBRowid
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)
		d file.WriteLine(MKBTDesc)
		s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
		s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
		s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
		s length=$l(MKBTemplate,",")
		for i=1:1:length
		{
			continue:i=""
			s OnePiece=$p(MKBTemplate,",",i)
			s TempProRowid=$p(OnePiece,"&",1)    //属性ID
			s DefineNode=$p(OnePiece,"&",3)  //定义节点
			s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
			s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
			s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
			continue:PDesc="其他描述"
			d file.WriteLine(","_PDesc)
			s Desc=""
			if "TX,TA,R,CB,C,L,T,F"[MKBTPType
			{
				if DefineNode'=""
				{
					s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
					s Property=$replace(Property,",","，")
					d file.WriteLine("  , ,"_Property)
					s DescStr=##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch(DefineNode,TempProRowid,0,1)
					continue:DescStr=""
					s desclen=$l(DescStr,"^")
					for k=1:1:desclen
					{
						continue:k=""
						s Desc=$p(DescStr,"^",k)
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(" , , ,"_Desc)
					}
				}
				else
				{
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Desc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(", ,"_Desc)
					}
				}
			} 
			elseif MKBTPType="S"    //引用术语
			{
				
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(Term)),3)
					}
					s Desc=$replace(Desc,",","，")
					d file.WriteLine(" , ,"_Desc)
				}
			}
			elseif MKBTPType="P"
			{
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
					s Desc=$replace(Desc,",","，")
					d file.WriteLine(" , ,"_Desc)
				}
			}
			elseif MKBTPType="SS"   //引用单节点
			{
				s MKBTPDRowid=0
				for
				{
					
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					
					s str=""
					;s term=$lg($g(^User.MKBTermD(Term)),3)
					s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
					s strCom=$p(strComAndAlisa,"[A]",1)
					s term=$p(strCom,"&%",1) //诊断常用名
					if term=""
					{
						s term=$lg($g(^User.MKBTermD(Term)),3)
					}
					s term=$replace(term,",","，")
					d file.WriteLine(" , ,"_term)
					s Desc=..GetSSDataSeq(.str,MKBConfig,Term,0,1)
					s str=$replace(str,",","，")
					s len=$l(str,"^")
					for j=1:1:len
					{
						continue:j=""
						s desc=$p(str,"^",j)
						d file.WriteLine(" , , ,"_desc)
					}
				}
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q filename
}

/// Creator:李得原
/// CreatDate:2019-11-06
/// Description：按顺序导出树形结构起始节点的数据
/// Input：字符串str； Term表的Base指向；Term表rowid；flags第几层循环，用来加空格；first,区别第几次进入函数
/// Return:返回字符串str
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSSDataSeq()
ClassMethod GetSSDataSeq(ByRef str, base As %String, id As %String, flags As %String, first As %String) As %String
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="|----"_mark
		}
	}
	s seq=0
	for
	{
		s seq=$o(^User.MKBTermI("ParSeqIndex",base,id,seq))
		
		q:seq=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParSeqIndex",base,id,seq,MKBTRowid))
			q:MKBTRowid=""
			s MKBTDescT=$lg($g(^User.MKBTermD(MKBTRowid)),3)
			s:str'="" str=str_"^"_mark_MKBTDescT
			s:str="" str=mark_MKBTDescT
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s MKBTDesc=$p(strCom,"&%",1) //诊断常用名
			if MKBTDesc'=""
			{
				s str=str_"^"_mark_MKBTDesc
			}

			if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))  //如果有子节点
			{
				d ..GetSSDataSeq(.str,base,MKBTRowid,flags,2)
			}
		}
	}
	q str
}

/// Creator:李得原
/// CreatDate:2019-11-06
/// Description：导出非引用型数据的树形节点
/// Input：LastLevel：上级节点； property：属性id；flags第几层循环，用来加空格；first,区别第几次进入函数
/// Return:返回字符串IDStr
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSSDataSeq()
ClassMethod GetChildOrderedIDStrBatch(LastLevel As %String, property As %String, flags As %String, first As %String) As %String
{
	if first=1
	{
		s mark=""
	}
	else
	{
		s flags=flags+1
		s mark=""
		for i=1:1:flags
		{
			s mark="    "_mark
		}
	}
	if (LastLevel="") s LastLevel=-100000000000000	
	s IDStr=""
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID)) q:(myRowID="")
			
			s childStr=..GetChildOrderedIDStrBatch(myRowID, property,flags,2)
			s desc=$lg($g(^User.MKBTermProDetailD(myRowID)),3)
			if childStr'="" s childStr=mark_desc_"^"_childStr
			if childStr="" s childStr=mark_desc
			
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// 江苏省中医院界面数据不显示，处理特殊符号
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).JiangSuProvinceSpecialSign()
ClassMethod JiangSuProvinceSpecialSign()
{
	ts
	s sum=0
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermD(MKBTRowid))
		q:MKBTRowid=""
		s MKBTBRowid=$lg($g(^User.MKBTermD(MKBTRowid)),4)
		continue:MKBTBRowid'=87
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		s MKBTPY=$lg($g(^User.MKBTermD(MKBTRowid)),6)
		s Desc=##class(web.DHCBL.BDP.FunLib).Util(MKBTDesc)
		s PY=##class(web.DHCBL.BDP.FunLib).Util(MKBTPY)
		s obj=##class(User.MKBTerm).%OpenId(MKBTRowid)
		s obj.MKBTDesc=Desc
		s obj.MKBTPYCode=PY
		s sc=obj.%Save()
		d obj.%Close()
		
		if $$$ISERR(sc)
		{
			s result=$SYSTEM.Status.GetErrorText(sc)
			b
		}
		else
		{
			s sum=sum+1
		}
	}
	q sum
}

/// (1)获取临床实用诊断所有Term名和别名以及rowid  
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetAllTermAndAlias()
ClassMethod GetAllTermAndAlias()
{
	k ^GetTerm
	s sum=0
	s MKBDTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBDTRowid=0
	for
	{
		s MKBDTRowid=$o(^User.MKBTermI("BaseIndex",MKBDTBRowid,MKBDTRowid))
		q:MKBDTRowid=""
		s MKBDDesc=$lg($g(^User.MKBTermD(MKBDTRowid)),3)
		s active=$lg($g(^User.MKBTermD(MKBDTRowid)),9)
		continue:active="N"
		s MKBDDesc=$zstrip(MKBDDesc,"<>W")
		s ^GetTerm(MKBDDesc,MKBDTRowid)=""
		s sum=sum+1
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBDTRowid)
		s length=$l(strComAndAlisa,"[A]")
		continue:length=0
		for i=1:1:length
		{
			s strCom=$p(strComAndAlisa,"[A]",i)
			continue:strCom=""
			s MKBTDesc=$p(strCom,"&%",1) //诊断常用名
			s MKBTDesc=$zstrip(MKBTDesc,"<>W")
			s ^GetTerm(MKBTDesc,MKBDTRowid)=""
			s sum=sum+1
		}
	}
	q sum
}

/// (2)获取临床实用诊断中心词下所有的诊断模板数据拼串
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetAllDiagTemplateStr(15362)
ClassMethod GetAllDiagTemplateStr(MKBTermRowid)
{
	k ^DiagTemplate
	s MKBTDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)
	s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
	s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
	s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
	s length=$l(MKBTemplate,",")
	for i=1:1:length
	{
		continue:i=""
		s OnePiece=$p(MKBTemplate,",",i)
		s TempProRowid=$p(OnePiece,"&",1)    //属性ID
		s DefineNode=$p(OnePiece,"&",3)  //定义节点
		s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
		s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
		s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
		continue:PDesc="其他描述"
		s Desc=""
		if "TX,TA,R,CB,C,L,T,F"[MKBTPType
		{
			if DefineNode'=""
			{
				s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
				s Property=$replace(Property,",","，")                        //属性名
				s DescStr=##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch(DefineNode,TempProRowid,0,1)
				
				continue:DescStr=""
				s desclen=$l(DescStr,"^")
				for k=1:1:desclen
				{
					continue:k=""
					s Desc=$p(DescStr,"^",k)

					s Desc=$replace(Desc,",","，")    //属性内容
					s Desc=$zstrip(Desc,"<>W")
					s ^DiagTemplate(Desc,PDesc)=""
				}
			}
			else
			{
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Desc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					
					s Desc=$replace(Desc,",","，")
					s Desc=$zstrip(Desc,"<>W")
					s ^DiagTemplate(Desc,PDesc)=""
				}
			}
		} 
		elseif MKBTPType="S"    //引用术语
		{
			
			s MKBTPDRowid=0
			for
			{
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
				q:MKBTPDRowid=""
				s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
				continue:'$d(^User.MKBTermD(Term))
				set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)  
				s ComLength=$l(TermDataAlias,"[A]")  
				for k=1:1:ComLength
				{
					s strCom=$p(strComAndAlisa,"[A]",k)
					continue:strCom=""
					s Desc=$p(strCom,"&%",1) //诊断常用名
					s Desc=$zstrip(Desc,"<>W")
					s ^DiagTemplate(Desc,PDesc,Term)=""
				}
				s Desc=""
				s Desc=$lg($g(^User.MKBTermD(Term)),3)
				
				s Desc=$replace(Desc,",","，")
				s Desc=$zstrip(Desc,"<>W")
				s ^DiagTemplate(Desc,PDesc,Term)=""
			}
		}
		elseif MKBTPType="P"
		{
			s MKBTPDRowid=0
			for
			{
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
				q:MKBTPDRowid=""
				s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
				s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
				s Desc=$replace(Desc,",","，")
				s Desc=$zstrip(Desc,"<>W")
				s ^DiagTemplate(Desc,PDesc)=""
			}
		}
		elseif MKBTPType="SS"   //引用单节点
		{
			s MKBTPDRowid=0
			for
			{
				
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
				q:MKBTPDRowid=""
				s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
				continue:'$d(^User.MKBTermD(Term))
				s str=""
				s term=$lg($g(^User.MKBTermD(Term)),3)
				s Desc=""
				s Desc=term
				
				s ^DiagTemplate(Desc,PDesc,Term)=""
				s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
				s ComLength=$l(strComAndAlisa,"[A]")  
				s Desc=""
				for k=1:1:ComLength
				{
					s strCom=$p(strComAndAlisa,"[A]",k)
					continue:strCom=""
					s Desc=$p(strCom,"&%",1) //诊断常用名
					continue:Desc=""
					s Desc=$zstrip(Desc,"<>W")
					s ^DiagTemplate(Desc,PDesc,Term)=""
				}


				/*
				s strCom=$p(strComAndAlisa,"[A]",1)
				s term=$p(strCom,"&%",1) //诊断常用名
				if term=""
				{
					s term=$lg($g(^User.MKBTermD(Term)),3)
				}
				s term=$replace(term,",","，")
				s Desc=$zstrip(term,"<>W")
				s ^DiagTemplate(Desc,PDesc)=""
				*/
				s Desc=""
				s str=""
				s Desc=..GetSSDataSeq(.str,MKBConfig,Term,0,1)
				
				s str=$replace(str,",","，")
				s len=$l(str,"^")
				for j=1:1:len
				{
					continue:j=""
					s desc=$p(str,"^",j)
					s Desc=$zstrip(desc,"<>W")
					continue:Desc=""
					s ^DiagTemplate(Desc,PDesc,Term)=""
				}
			}
		}
	}
	q ""
}

/// (3)比较是否存在和江苏省中医相同的诊断模板数据
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ShowDiffBetweenJiangSuandDiag()
ClassMethod ShowDiffBetweenJiangSuandDiag()
{
	s MKBPTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 江苏省中医院",0))
	s MKBDTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s file=##class(%File).%New("D:/比较江苏省中医和临床实用诊断.csv")
	d file.Open("NWS")
	d file.WriteLine("省中医,病情描述,临床实用诊断,诊断模板")
	s MKBPTRowid=0
	for
	{
		s MKBPTRowid=$o(^User.MKBTermI("BaseIndex",MKBPTBRowid,MKBPTRowid))
		q:MKBPTRowid=""
		s MKBPDesc=$lg($g(^User.MKBTermD(MKBPTRowid)),3)              //省中医中心词
		s MKBPLastLevel=$lg($g(^User.MKBTermD(MKBPTRowid)),5)
		if $d(^User.MKBTermI("ParentIndex",MKBPTBRowid,MKBPTRowid))
		{
			continue
		}
		s MKBPDesc=$zstrip(MKBPDesc,"<>W")
		if $d(^GetTerm(MKBPDesc))         //存在和临床实用诊断相同的中心词
		{
			
			s MKBTRowid=$o(^GetTerm(MKBPDesc,0))
			s active=$lg($g(^User.MKBTermD(MKBTRowid)),9)
			continue:active="N"
			s TTerm=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(TTerm,"[A]",1)
			s Desc=$p(strCom,"&%",1) //诊断常用名
			d ..GetAllDiagTemplateStr(MKBTRowid)
			d file.WriteLine(MKBPDesc_",,"_Desc)             //第三列中心词 显示诊断常用名
			s MKBPTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBPTRowid," 病情描述",0))
			s DiagStatusStr= ##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch("",MKBPTPRowid,0,1)

			s ProLength=$l(DiagStatusStr,"^")
			for j=1:1:ProLength
			{
				s ProEach=$p(DiagStatusStr,"^",j)
				s ProEach=$zstrip(ProEach,"<>W")
				
				if $d(^DiagTemplate(ProEach))           //如果存在与诊断模板中的属性内容相同的数据
				{
					
					s Desc=""
					s Property=""
					for
					{
						s Property=$o(^DiagTemplate(ProEach,Property))
						q:Property=""
					
						s TermRowid=0
						/*
						for
						{
							s TermRowid=$o(^DiagTemplate(ProEach,Property,TermRowid))
							q:TermRowid=""
							;s TTerm=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(TermRowid)
							;s strCom=$p(TTerm,"[A]",1)
							;s Desc=$p(strCom,"&%",1) //诊断常用名
						
						}
						*/
						if Desc=""
						{
							s Desc=ProEach
						}
						d file.WriteLine(","_ProEach_",,"_Property_"-"_ProEach)
						
					}

				}
				else
				{
					d file.WriteLine(","_ProEach)
				}
			}
		}
		else                       //临床实用诊断中不存在此中心词
		{
			d file.WriteLine(MKBPDesc)
			s MKBPTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBPTRowid," 病情描述",0))
			s DiagStatusStr= ##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch("",MKBPTPRowid,0,1)
			s ProLength=$l(DiagStatusStr,"^")
			for j=1:1:ProLength
			{
				s ProEach=$p(DiagStatusStr,"^",j)
				s ProEach=$zstrip(ProEach,"<>W")
				d file.WriteLine(","_ProEach)
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q ""
}

/// 删除医大一科室常用诊断
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).DeleteYDYLocComDiag()
ClassMethod DeleteYDYLocComDiag()
{
	Ts
	s row=0
	for row=0:1:66040
	{
		w row_" "_##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(row,44),!
	}
	q ""
}

/// Creator: 李得原
/// CreatDate: 2019-11-20
/// Description: 导出数据处理工厂诊断模板数据
/// Input: base-某个数据处理工厂base  reallocs-实际科室拼串
/// Other: w ##class(web.DHCBL.MKB.MKBStructedDiag).GetYGRHTermGlobal(5,"儿科,血液内科,风湿免疫科,胸外科,普通外科,心脏中心")
ClassMethod GetYGRHTermGlobal(base, reallocs)
{
	s str=""
	s result=""
	s len=$l(reallocs,",")
	for i=1:1:len
	{
		s realloc=$p(reallocs,",",i)
		k ^term
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s MKBBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
			continue:MKBBase'=base   //阳光融合
			s MKBSDRRowid=0
			for
			{
				s MKBSDRRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid))
				q:MKBSDRRowid=""
				s MKBSDRRTermid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4)
				continue:MKBSDRRTermid=""
				continue:'$d(^User.MKBTermD(MKBSDRRTermid))
				s MKBSDLRowid=0
				for
				{
					s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
					q:MKBSDLRowid=""
					s MKBLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2) //科室名
					s MKBFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)  //频次
					s MKBSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),4) //来源
					;if (MKBLoc="血管外科/甲状腺外科")||(MKBLoc="门诊血管外科/甲状腺外科")
					
					if (MKBLoc[realloc)
					{
						if $d(^term(MKBSDRRTermid))
						{
							s ^term(MKBSDRRTermid,MKBSource)=$g(^term(MKBSDRRTermid,MKBSource))+MKBFre
						}
						else
						{
							s ^term(MKBSDRRTermid,MKBSource)=MKBFre
						}
					}
				}
			}
		}

		k ^TempArr
		s MKBTerm=0
		for
		{
			s MKBTerm=$o(^term(MKBTerm)) q:MKBTerm=""
			s count=0
			s Source=""
			for
			{
				s Source=$o(^term(MKBTerm,Source)) q:Source=""
				s fre=$g(^term(MKBTerm,Source))
				s:fre="" fre=0
				s count=count+fre
			}
			s ^TempArr(count,MKBTerm)=""
		}
		s str= ..ExportYDYTermProDetail(realloc)
		s:result'="" result=result_","_str
		s:result="" result=str
	}
	q result
}

/// Creator: 李得原
/// CreatDate: 2019-11-20
/// Description: 把该诊断的诊断模板里的数据都导出到excel中。
/// Input: filename-实际科室名字
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportYDYTermProDetails()
ClassMethod ExportYDYTermProDetail(filename As %String)
{
	;s User=1
	s User=%session.Get("LOGON.USERID")
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if ifExistsDir'=1
	{
		d ##class(%File).CreateDirectory("D:\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\")
	}
	s P=Disk_":\DtHealth\app\dthis\web\scripts\bdp\MKB\DataExport\"_filename_User_".csv"
	;s name="D:\工作\2019-11-18\阳光融合\诊断模板\"_filename_".csv"
	s fname=filename_User_".csv"
	s file=##class(%File).%New(name)
	d file.Open("NSW")
	d file.WriteLine("频次,别名,中心词,属性,属性内容")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))   //获取baseid
	
	s Frequ=""
	for
	{
		s Frequ=$o(^TempArr(Frequ),-1)
		q:Frequ=""
		continue:Frequ<5
		s MKBTermRowid=0
		for
		{
			s MKBTermRowid=$o(^TempArr(Frequ,MKBTermRowid))
			q:MKBTermRowid=""
			continue:'$d(^User.MKBTermD(MKBTermRowid))
			s MKBTermDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)  //获取临床实用诊断中心词
			s MKBTermDesc=$replace(MKBTermDesc,",","，")
			
			
			
			set AliasItem=""
			;获取未匹配到的中心词的别名
			s AliasNum=0
			set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProperty).GetComOrAlias(MKBTermRowid)    
			set TermDataAlias=$p(TermDataAlias,"||",1) ;获取别名
			set:TermDataAlias'="" AliasNum=$l(TermDataAlias,",")  ;获取别名个数
			s AliasString=""
			for n=1:1:AliasNum
			{
				set AliasItem=$p(TermDataAlias,",",n)
				s AliasItem=$replace(AliasItem,",","，")
				s:AliasString'="" AliasString=AliasString_"，"_AliasItem
				s:AliasString="" AliasString=AliasItem
			}
			s L=0
			s O=0
			
			s LocFlag=""
			if $d(^term(MKBTermRowid,"L"))
			{
				s L=^term(MKBTermRowid,"L")
			}
			if $d(^term(MKBTermRowid,"O"))
			{
				s O=^term(MKBTermRowid,"O")
			}
			s LO=L+O
			b:LO'=Frequ
			d file.WriteLine("总频次("_Frequ_")，"_"住院("_L_")，门急诊("_O_")"_","_"别名("_AliasString_")"_","_MKBTermDesc)
			;d file.WriteLine("总频次("_Frequ_")，"_"住院("_L_")，门急诊("_O_")")
			
			s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
			s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
			s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
			s length=$l(MKBTemplate,",")
			for i=1:1:length
			{
				continue:i=""
				s OnePiece=$p(MKBTemplate,",",i)
				s TempProRowid=$p(OnePiece,"&",1)    //属性ID
				s DefineNode=$p(OnePiece,"&",3)  //定义节点
				s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
				s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
				s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
				continue:PDesc="其他描述"
				d file.WriteLine(",,,"_PDesc)
				s Desc=""
				if "TX,TA,R,CB,C,L,T,F"[MKBTPType
				{
					if DefineNode'=""
					{
						s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
						s Property=$replace(Property,",","，")
						d file.WriteLine(",,,,"_Property)
						s DescStr=##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStr(DefineNode,TempProRowid,0,1)
						continue:DescStr=""
						s desclen=$l(DescStr,"^")
						for k=1:1:desclen
						{
							continue:k=""
							s Desc=$p(DescStr,"^",k)
		
							s Desc=$replace(Desc,",","，")
							d file.WriteLine(" ,,,,,"_Desc)
						}
					}
					else
					{
						s MKBTPDRowid=0
						for
						{
							s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
							q:MKBTPDRowid=""
							s Desc=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
							s Desc=$replace(Desc,",","，")
							d file.WriteLine(",,,,"_Desc)
						}
					}
				} 
				elseif MKBTPType="S"    //引用术语
				{
					
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)    
						s strCom=$p(strComAndAlisa,"[A]",1)
						s Desc=$p(strCom,"&%",1) //诊断常用名
						if Desc=""
						{
							s Desc=$lg($g(^User.MKBTermD(Term)),3)
						}
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(" ,,,,"_Desc)
					}
				}
				elseif MKBTPType="P"
				{
					s MKBTPDRowid=0
					for
					{
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
						s Desc=$replace(Desc,",","，")
						d file.WriteLine(" , ,,,"_Desc)
					}
				}
				elseif MKBTPType="SS"   //引用单节点
				{
					s MKBTPDRowid=0
					for
					{
						
						s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
						q:MKBTPDRowid=""
						s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
						
						s str=""
						;s term=$lg($g(^User.MKBTermD(Term)),3)
						s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
						s strCom=$p(strComAndAlisa,"[A]",1)
						s term=$p(strCom,"&%",1) //诊断常用名
						if term=""
						{
							s term=$lg($g(^User.MKBTermD(Term)),3)
						}
						s term=$replace(term,",","，")
						d file.WriteLine(",,,,"_term)
						s Desc=..GetSSData(.str,MKBConfig,Term,0,1)
						s str=$replace(str,",","，")
						s len=$l(str,"^")
						for j=1:1:len
						{
							continue:j=""
							s desc=$p(str,"^",j)
							d file.WriteLine(" ,,,,,"_desc)
						}
					}
					
				}
				else
				{
					continue
				}
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q fname
}

/// 导出阳光融合诊断短语数据
/// 儿科，血液内科，风湿免疫科，胸外科，普通外科，心脏中心
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetYGRHTermGlobal2()
ClassMethod GetYGRHTermGlobal2()
{
	s arr("儿科")=""
	s arr("血液内科")=""
	s arr("风湿免疫科")=""
	s arr("胸外科")=""
	s arr("普通外科")=""
	s arr("心脏中心")=""
	s name=""
	for
	{
		s name=$o(arr(name))
		q:name=""
		s ss=0
		k term
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
			q:MKBSDRowid=""
			s MKBBase=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
			s MKBRelation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),23)
			continue:MKBBase'=5   //阳光融合
			s ss=ss+1
			s MKBSDRRowid=0

			if $d(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc"))
			{
				s MKBSDLRowid=0
				for
				{
					s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
					q:MKBSDLRowid=""
					s MKBLoc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2) //科室名
					s MKBFre=0
					s MKBFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)  //频次
					s MKBSource=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),4) //来源
					
					if (MKBLoc[name)
					{
						if $d(term(MKBSDRowid))
						{
							s term(MKBSDRowid)=$g(term(MKBSDRowid))+MKBFre
						}
						else
						{
							s term(MKBSDRowid)=MKBFre
						}
					}
					
				}
			}
			
			
		}
		w ss,!
		s ss=0
		k ldy
		s MKBTerm=0
		for
		{
			s MKBTerm=$o(term(MKBTerm)) q:MKBTerm=""
			s count=0
			s fre=$g(term(MKBTerm))
			s ss=ss+1
			s:fre="" fre=0
			s count=count+fre
			s ldy(count,MKBTerm)=""
		}
		w ss,!
		s sum=0
		s filename="D:\工作\2019-11-18\阳光融合\诊断短语\"_name_".csv"
		s file=##class(%File).%New(filename)
		d file.Open("NWS")
		;诊断短语、结构化结果、Icd编码、icd描述、频次
		d file.WriteLine("诊断短语,结构化结果,ICD编码,ICD描述,频次")
		s Frequ=""
		for
		{
			s Frequ=$o(ldy(Frequ),-1)
			q:Frequ=""
			s MKBSDRowid=0
			for
			{
				s MKBSDRowid=$o(ldy(Frequ,MKBSDRowid))
				q:MKBSDRowid=""
				s sum=sum+1
				s Diag=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
				s ICD=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),20)
				s ICDDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),21)
				s MKBRelation=""
				s MKBRelation=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),23)
				if MKBRelation="AND"
				{
					s MKBRelation="且"
				}
				
				if MKBRelation="OR"
				{
					s MKBRelation="或"
				}
				s Result=""
				s sequence=0
				for
				{
					s sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence))
					q:sequence=""
					
					s MKBSDRRowid=0
					for
					{
						s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,sequence,MKBSDRRowid))
						q:MKBSDRRowid=""
						s MKBSDResultID=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),2)  //获取结构化结果串
						s MKBSDResultTermdr=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取结构化结果Termdr
						continue:MKBSDResultTermdr=""
						s SResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBSDResultID,MKBSDResultTermdr)
						s MKBSDSupplement=$lg(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid),5)
						if MKBSDSupplement'=""
						{
							if SResult["]"
							{
								s str=$e(SResult,1,*-1)
								s SResult=str_",("_MKBSDSupplement_")]"
							}
							else
							{
								s SResult=SResult_"[("_MKBSDSupplement_")]"
							}
						}					
						s:Result'="" Result=Result_"  "_MKBRelation_"  "_SResult
						s:Result="" Result=SResult
					}
				}
				s Diag=$replace(Diag,",","，")
				s Result=$replace(Result,",","，")
				
				d file.WriteLine(Diag_","_Result_","_ICD_","_ICDDesc_","_Frequ)
			}
		}
		d file.%Save()
		d file.%Close()
		k file
		w sum,!
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ceshi("田宏香")
ClassMethod ceshi1(arg1 As %String, arg2 As %String)
{
	s cmd="python ceshi.py "_arg1_" "_arg2
	
	s sc=$zf(-1,cmd)
	
	s file=##class(%File).%New("a.txt")
	d file.Open("RS")
	while 'file.AtEnd
	{
		w file.ReadLine(),!
	}
	q ""
}

ClassMethod ceshi2(arg As %String)
{
	k ^ldy
	s ^ldy("1")=0
	s ^TempArg(arg)=""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetRidOfSD()
ClassMethod GetRidOfSD()
{
	s sum=0
	s MKBSDRowid=0
	for
	{
		s MKBSDRowid=$o(^User.MKBStructuredDataD(MKBSDRowid))
		q:MKBSDRowid=""
		s Base=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),22)
		continue:Base'=5
		s Desc=""
		s PY=""
		s sum=sum+1
		s Desc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),2)
		s PY=$lg($g(^User.MKBStructuredDataD(MKBSDRowid)),19)
		s Desc=##class(web.DHCBL.BDP.FunLib).Util(Desc)
		s PY=##class(web.DHCBL.BDP.FunLib).Util(PY)
		s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowid)
		s obj.MKBSDDiag=Desc
		s obj.MKBSDDiagPYCode=PY
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISERR(sc)
		{
			b
		}
	}
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportICDConrastData()
ClassMethod ExportICDConrastData()
{
	s sum=0
	s file=##class(%File).%New("D:\ICDContrast.csv")
	d file.Open("NWS")
	d file.WriteLine("描述,ICD编码,中心词,别名,结构化结果,版本")
	s MKBICDRowid=0
	for
	{
		s MKBICDRowid=$o(^User.MKBICDContrastD(MKBICDRowid))
		q:MKBICDRowid=""
		s Desc=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),3)  //描述
		s Desc=$replace(Desc,",","，")
		s sum=sum+1
		s Number=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),4)  //icd编码
		s Extend=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),5)   //扩展编码

		s MKBICDRRowid=0
		for
		{
			s MKBICDRRowid=$o(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid))
			q:MKBICDRRowid=""
			s MKBTermId=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4)
			;continue:'$d(^User.MKBTermD(MKBTermId))
			s MKBTDesc=$lg($g(^User.MKBTermD(MKBTermId)),3)
			s strs=""
			
			if MKBTDesc'=""
			{
				s strs=""
				s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermId," 别名",0))
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Alias=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					s Alias=$replace(Alias,",","，")
					s:strs'="" strs=strs_"，"_Alias
					s:strs="" strs=Alias
				}
			}
		}
		
		s strs=$replace(strs,",","，")
		s Result=""
		s sequence=0
		for
		{
			s sequence=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence))
			q:sequence=""
			s MKBICDRRowid=0
			for
			{
				s MKBICDRRowid=$o(^User.MKBICDContrastResultI("SeqIndex",MKBICDRowid,sequence,MKBICDRRowid))
				q:MKBICDRRowid=""
				s MKBICDRResultID=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),2)  //获取结构化结果串
				s MKBICDResultTermdr=$lg($g(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid)),4) //获取结构化结果Termdr
				s SResult=##class(web.DHCBL.MKB.MKBStructuredData).StdGetChiForNewSeqStrucIDs(MKBICDRResultID,MKBICDResultTermdr)
				s MKBICDSupplement=$lg(^User.MKBICDContrastD(MKBICDRowid,"MKBICDContrastResult",MKBICDRRowid),5)
				if MKBICDSupplement'=""
				{
					if SResult["]"
					{
						s str=$e(SResult,1,*-1)
						s SResult=str_",("_MKBICDSupplement_")]"
					}
					else
					{
						s SResult=SResult_"[("_MKBICDSupplement_")]"
					}
				}
				s:Result'="" Result=Result_" & "_SResult
				s:Result="" Result=SResult
			}
		}
		s Result=$replace(Result,",","，")
		s Version=$lg($g(^User.MKBICDContrastD(MKBICDRowid)),6)  //版本号
		s VersionLength=$l(Version,"&")
		for j=1:1:VersionLength
		{
			s V=$p(Version,"&",j)
			continue:V=""
			s VersionDesc=$lg($g(^User.MKBTermD(V)),3)
			d file.WriteLine(Desc_","_Number_Extend_","_MKBTDesc_","_strs_","_Result_","_VersionDesc)
		}
		
	}
	d file.%Save()
	d file.%Close()
	k file
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportTermData()
ClassMethod ExportTermData()
{
	s sum=0
	s file=##class(%File).%New("D:/中心词.csv")
	d file.Open("NWS")
	d file.WriteLine("中心词,展示名")
	
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		continue:MKBTDesc=""
		s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
		s strCom=$p(strComAndAlisa,"[A]",1)
		s MKBSDStructResult=$p(strCom,"&%",1) //诊断常用名
		d file.WriteLine(MKBTDesc_","_MKBSDStructResult)
		s sum=sum+1
	}
	d file.%Save()
	d file.%Close()
	kill file
	q sum
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportTermAliasData()
ClassMethod ExportTermAliasData()
{
	s sum=0
	s file=##class(%File).%New("D:/中心词和别名.csv")
	d file.Open("NWS")
	d file.WriteLine("中心词,别名")
	
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))
	s MKBTRowid=0
	for
	{
		s MKBTRowid=$o(^User.MKBTermI("BaseIndex",MKBTBRowid,MKBTRowid))
		q:MKBTRowid=""
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
		continue:MKBTDesc=""
		if MKBTDesc'=""
		{
			s str=""
			s MKBTPRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowid," 别名",0))
			s MKBTPDRowid=0
			for
			{
				s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTPRowid,MKBTPDRowid))
				q:MKBTPDRowid=""
				s Alias=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
				d file.WriteLine(MKBTDesc_","_Alias)
				
			}
		}
		
		s sum=sum+1
	}
	d file.%Save()
	d file.%Close()
	kill file
	q sum
}

/// Creator:李得原
/// CreatDate:2019-11-05
/// Description：导出临床实用诊断诊断模板中的数据
/// Input：
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ExportDiagTemplate2(5)
ClassMethod ExportDiagTemplate2(base)
{
	q:base="" ""
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1)
	s PathDir=Disk_":\工作\2019-12-23\"
	s ifExistsDir=##class(%File).DirectoryExists(PathDir)
	if 'ifExistsDir
	{
		d ##class(%File).CreateDirectory("D:\工作\2019-12-23\")
	}
	s filename = $LISTGET($G(^User.MKBTermBaseD(base)),3)_"知识模板数据tree"_".csv"
	s PathDir=Disk_":\工作\2019-12-23\"_filename
	s file=##class(%File).%New(PathDir)
	d file.Open("NWS")
	;d file.WriteLine("ID,中文释义,上级节点")
	s MKBTBRowid=$o(^User.MKBTermBaseI("DescIndex"," 临床实用诊断",0))   //获取baseid
	s MKBTermRowid=0
	for
	{
		s MKBTermRowid=$o(^User.MKBTermD(MKBTermRowid))
		q:MKBTermRowid=""
		s MKBTBase=$lg($g(^User.MKBTermD(MKBTermRowid)),4)
		continue:MKBTBase'=MKBTBRowid
		k chongfu
		s chongfu=""
		s MKBTDesc=$lg($g(^User.MKBTermD(MKBTermRowid)),3)
		d file.WriteLine("T"_MKBTermRowid_","_MKBTDesc)
		s MKBTermProRowid=$o(^User.MKBTermPropertyI("DescIndex",MKBTermRowid," 诊断模板",0))   //获取诊断模板rowid
		s MKBTemplateRowid=$o(^User.MKBTermProDetailI("ProIdx",MKBTermProRowid,0))
		s MKBTemplate=$lg($g(^User.MKBTermProDetailD(MKBTemplateRowid)),3)    //诊断模板内容
		s length=$l(MKBTemplate,",")
		s q=0
		for i=1:1:length
		{
			s q=q+1
			continue:q'=i
			continue:i=""
			s OnePiece=$p(MKBTemplate,",",i)
			//w length_"  "_i_" "_OnePiece,!
			s TempProRowid=$p(OnePiece,"&",1)    //属性ID
			s DefineNode=$p(OnePiece,"&",3)  //定义节点
			s MKBTPType=$lg($g(^User.MKBTermPropertyD(TempProRowid)),4)   //属性类型
			s MKBConfig=$lg($g(^User.MKBTermPropertyD(TempProRowid)),5)    //配置项(basedr)
			s PDesc=$lg($g(^User.MKBTermPropertyD(TempProRowid)),3)
			continue:PDesc="其他描述"
			//b:MKBTDesc="贲门恶性肿瘤" ;2
			if DefineNode=""
			{
				d file.WriteLine(DefineNode_"P"_TempProRowid_","_PDesc_","_"T"_MKBTermRowid)
			}
			else
			{
				s Property=$lg($g(^User.MKBTermProDetailD(DefineNode)),3)
				d file.WriteLine(DefineNode_"D"_DefineNode_","_Property_","_"T"_MKBTermRowid)
			}
				//b:MKBTDesc="贲门恶性肿瘤" ;3
				//b:MKBTDesc="贲门恶性肿瘤" ;4

			s Desc=""
			if "TX,TA,R,CB,C,L,T,F"[MKBTPType
			{
				
				if DefineNode'=""
				{
					//s Property=$replace(Property,",","，")
						//b:MKBTDesc="贲门恶性肿瘤" ;5
					//d file.WriteLine(DefineNode_"D"_DefineNode_","_Property_","_DefineNode_"P"_TempProRowid)
						//b:MKBTDesc="贲门恶性肿瘤" ;7
					s DescStr=##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch2(DefineNode,TempProRowid,0,MKBTermRowid,"",DefineNode)
											
					//b:MKBTDesc="贲门恶性肿瘤" ;9
					continue:DescStr=""
					s desclen=$l(DescStr,"^")
					for k=1:1:desclen
					{
						continue:k=""
						s Desc=$p(DescStr,"^",k)
	
						;s Desc=$replace(Desc,",","，")
						d file.WriteLine(Desc)
					}

				}
				else
				{
					s MKBTPDRowid=0
					s DescStr=##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch2("",TempProRowid,0,1,"",DefineNode)
					continue:DescStr=""
					s desclen=$l(DescStr,"^")
					for k=1:1:desclen
					{
						continue:k=""
						s Desc=$p(DescStr,"^",k)
	
						;s Desc=$replace(Desc,",","，")
						d file.WriteLine(Desc)
					}
				}
			} 
			elseif MKBTPType="S"    //引用术语   Pro_S_Term
			{
				if DefineNode'=""
				{
					set TermDataAlias=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(DefineNode)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(DefineNode)),3)
					}
					s Desc=$replace(Desc,",","，")
					d file.WriteLine(TempProRowid_"S"_DefineNode_","_Desc_","_"D"_TempProRowid)
				}
				s sd=""      //用来存储选中的引用术语
				s MKBTinD=0
				for
				{
					s MKBTinD=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTinD))
					q:MKBTinD=""
					s MKBt=$lg($g(^User.MKBTermProDetailD(MKBTinD)),3)
					s sd(MKBt)=""
				}
				
				s sstr=""
				d ..GetSTermTree(.sstr, MKBConfig, DefineNode, TempProRowid,.sd,1)
				s ls=$l(sstr,"&")
				for p=1:1:ls
				{
					s Desc=$p(sstr,"&",p)
					d file.WriteLine(Desc)
				}
				
				
			}
			elseif MKBTPType="P"
			{
				s MKBTPDRowid=0
				for
				{
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Pro=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					s Desc=$lg($g(^User.MKBTermPropertyD(Pro)),3)
					s Desc=$replace(Desc,",","，")
					d file.WriteLine(MKBTPDRowid_Desc_","_Desc_","_MKBTPDRowid)
				}
			}
			elseif MKBTPType="SS"   //引用单节点   
			{
				s MKBTPDRowid=0
				for
				{
					
					s MKBTPDRowid=$o(^User.MKBTermProDetailI("ProIdx",TempProRowid,MKBTPDRowid))
					q:MKBTPDRowid=""
					s Term=$lg($g(^User.MKBTermProDetailD(MKBTPDRowid)),3)
					
					k str
					s str=""
					b:Term=""
					s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(Term)
					s strCom=$p(strComAndAlisa,"[A]",1)
					s term=$p(strCom,"&%",1) //诊断常用名
					if term=""
					{
						s term=$lg($g(^User.MKBTermD(Term)),3)
					}
					s term=$replace(term,",","，")
					d file.WriteLine(TempProRowid_"SS"_Term_","_term_","_"P"_TempProRowid)
					s Descc=..GetSSDataSeq2(.str,MKBConfig,Term,1,1,TempProRowid)
					;s str=$replace(str,",","，")
					s len=$l(str,"^")
					for j=1:1:len
					{
						continue:j=""
						s desc=$p(str,"^",j)
						d file.WriteLine(desc)
					}
				}
			}
		}
	}
	d file.%Save()
	d file.%Close()
	k file
	q filename
}

/// 引用术语递归 S
/// 定义起始节点并没有进入递归
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSTermTree(str,5,16449,8803895)
ClassMethod GetSTermTree(ByRef sstr, base, lastlevel, pro, ByRef sd, first)
{
	if first=1
	{
		if lastlevel=""
		{
			s lastlevel=-100000000000000
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("ParentIndex",base,lastlevel,MKBTRowid))
				q:MKBTRowid=""
				if $d(sd(MKBTRowid))
				{
					set strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
					}
					s Desc=$replace(Desc,",","，")
					if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))
					{
						d ..GetSTermTree(.sstr,base,MKBTRowid,pro,.sd,2)
					}
					s:sstr'="" sstr=pro_"S"_MKBTRowid_","_Desc_","_"P"_pro_"&"_sstr
					s:sstr="" sstr=pro_"S"_MKBTRowid_","_Desc_","_"P"_pro
				}
			}
		}
		else
		{
			s MKBTRowid=0
			for
			{
				s MKBTRowid=$o(^User.MKBTermI("ParentIndex",base,lastlevel,MKBTRowid))
				q:MKBTRowid=""
				if $d(sd(MKBTRowid))
				{
					set strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)    
					s strCom=$p(strComAndAlisa,"[A]",1)
					s Desc=$p(strCom,"&%",1) //诊断常用名
					if Desc=""
					{
						s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
					}
					s Desc=$replace(Desc,",","，")
					
					if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))
					{
						d ..GetSTermTree(.sstr,base,MKBTRowid,pro,.sd,2)
					}
					s:sstr'="" sstr=pro_"S"_MKBTRowid_","_Desc_","_"P"_pro_"&"_sstr
					s:sstr="" sstr=pro_"S"_MKBTRowid_","_Desc_","_"P"_pro
				}
			}
		}
	}
	else
	{
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParentIndex",base,lastlevel,MKBTRowid))
			q:MKBTRowid=""
			if $d(sd(MKBTRowid))
			{
				set strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)    
				s strCom=$p(strComAndAlisa,"[A]",1)
				s Desc=$p(strCom,"&%",1) //诊断常用名
				if Desc=""
				{
					s Desc=$lg($g(^User.MKBTermD(MKBTRowid)),3)
				}
				
				s Desc=$replace(Desc,",","，")

				if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))
				{
					d ..GetSTermTree(.sstr,base,MKBTRowid,pro,.sd,2)
				}
				s:sstr'="" sstr=pro_"S"_MKBTRowid_","_Desc_","_pro_"S"_lastlevel_"&"_sstr
				s:sstr="" sstr=pro_"S"_MKBTRowid_","_Desc_","_pro_"S"_lastlevel
			}
		}
	}
	q sstr
}

/// Creator:李得原
/// CreatDate:2019-11-06
/// Description：按顺序导出树形结构起始节点的数据
/// Input：字符串str； Term表的Base指向；Term表rowid；flags第几层循环，用来加空格；first,区别第几次进入函数
/// Return:返回字符串str
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSSDataSeq2(str,6,16700,1,1,"aa")
ClassMethod GetSSDataSeq2(ByRef str, base As %String, id As %String, flags As %String, first As %String, identi As %String) As %String
{
	s mark=identi_"SS"_id
	s seq=0
	for
	{
		s seq=$o(^User.MKBTermI("ParSeqIndex",base,id,seq))
		
		q:seq=""
		s MKBTRowid=0
		for
		{
			s MKBTRowid=$o(^User.MKBTermI("ParSeqIndex",base,id,seq,MKBTRowid))
			q:MKBTRowid=""
			s strComAndAlisa=##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(MKBTRowid)
			s strCom=$p(strComAndAlisa,"[A]",1)
			s MKBTDesc=$p(strCom,"&%",1) //诊断常用名
			s MKBTDesc=$replace(MKBTDesc,",","，")
			if MKBTDesc'=""
			{
				s:str'="" str=str_"^"_identi_"SS"_MKBTRowid_","_MKBTDesc_","_mark
				s:str="" str=identi_"SS"_MKBTRowid_","_MKBTDesc_","_mark
			}
			else
			{	
				s MKBTDescT=$lg($g(^User.MKBTermD(MKBTRowid)),3)
				s MKBTDescT=$replace(MKBTDescT,",","，")
				s:str'="" str=str_"^"_identi_"SS"_MKBTRowid_","_MKBTDescT_","_mark
				s:str="" str=identi_"SS"_MKBTRowid_","_MKBTDescT_","_mark	
			}
			
			if $d(^User.MKBTermI("ParentIndex",base,MKBTRowid))  //如果有子节点
			{
				d ..GetSSDataSeq2(.str,base,MKBTRowid,flags,2,identi)
			}
		}
	}
	q str
}

/// Creator:李得原
/// CreatDate:2019-11-06
/// Description：导出非引用型数据的树形节点
/// Input：LastLevel：上级节点； property：属性id；flags第几层循环，用来加空格；first,区别第几次进入函数
/// Return:返回字符串IDStr
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).GetChildOrderedIDStrBatch2("",864,0,1,"","病情")
ClassMethod GetChildOrderedIDStrBatch2(LastLevel As %String, property As %String, flags As %String, first As %String, c As %String, pro As %String) As %String
{
	s mark=property
	if (LastLevel="") s LastLevel=-100000000000000	
	s IDStr=""
	s childStr=""
	s mySeq=""
	for {
		s mySeq=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq)) q:(mySeq="")
		s myRowID=0
		for {
			s myRowID=$o(^User.MKBTermProDetailI("ProParSeqIndex",property,LastLevel,mySeq,myRowID))
			q:myRowID=""
			
			s childStr=..GetChildOrderedIDStrBatch2(myRowID, property,flags,2,c,pro)
			s desc=$lg($g(^User.MKBTermProDetailD(myRowID)),3)
			s desc=$replace(desc,",","，")
			if (LastLevel=-100000000000000)
			{
				if childStr'="" s childStr="D"_myRowID_","_desc_","_"P"_mark_"^"_childStr
				if childStr="" s childStr="D"_myRowID_","_desc_","_"P"_mark
			}
			else
			{
				if childStr'="" s childStr=pro_"D"_myRowID_","_desc_","_pro_"D"_LastLevel_"^"_childStr
				if childStr="" s childStr=pro_"D"_myRowID_","_desc_","_pro_"D"_LastLevel	
			}
			if IDStr="" s IDStr=childStr
			else  s IDStr=IDStr_"^"_childStr
		}
	}
	q IDStr
}

/// /w ##class(web.DHCBL.MKB.MKBStructedDiag).ttttt()
ClassMethod ttttt()
{
	s str={
	"result_code": "0",
	"result_message": {
		"GROUP_LOG": "判断1: DRG分组范围--2天/2906       .3元;判断2: 主要诊断--C85.906;判断3: 主要诊断MDC--R;判断4: 其他诊断--;判断5: 手                       术/操作--;判断6: MDCA先期分组--;判断7: MDCP新生儿先期分组--;判断8: MDCY先期分组-                        -;判断9: MDCZ先期分组--;判断10: 是否手术室手术--否;判断11: 外科分组--;判断12: 内                         科分组--RS1;判断13: ADRG分组--RS1;判断14: MCC/CC主诊排除判断--;判断15: 是否MCC--                   否;判断16: 是否CC--否;判断17: DRG分组--RS15;",
		"PATIENT_MANAGECOSTRATIO": "7.13",
		"          DRG_DESC": "淋巴瘤及非急性白血病，不伴合并症与伴随病",
		"AS_RISK_LEVEL": "中高风险",
		"matchOtherDia": null,
		"NURSCOSTRATIO": 2.22,
		"MEDCOSTRATIO": 22.14,
		"PATIENT_TECH_COST": 2589.5,
		"TECHCOSTRATIO": 22.17,
		"SIMILARDRGS": [{
			"DRG_CODE": "RS11",
			"DRG_DESC": "淋 巴瘤及非急性白血病，伴重要合并症与伴随病",
			"AVGFEE": 29802.37,
			"AVGDAYS": 10.94,
			"WEI                    GHT": 1.7,
			"RISKLEVEL": 4,
			"MEDCOST": 2546.75,
			"NURSCOST": 1040.44,
			"TECHCOST": 6869.76,
			"DRUGCOST": 16032.66,
			"MANAGECOST": 3312.77,
			"DRUGFEE": 13445.42,
			"DRUGRATIO": 45.12,
			"MATERIALFEE": 2587.24,
			"MATERIALRATIO": 8.68,
			"DRUGCOSTRATIO": 53.8,
			"MEDCOSTRATIO": 8.55,
			"NURSCOSTRATIO": 3.49,
			"TECHCOSTRATIO": 23.05,
			"MANAGECOSTRATIO": 11.12
		}],
		"AS_WEIGHT": 0.97,
		"AS_MATERIAL_RATIO": 6.71,
		"BJDRGS": [{
			"BJ_DRG_CODE": "RS15",
			"BJ_DRG_DESC": " 淋巴瘤及其他类型白血病，不伴合并症与伴随病",
			"BJ_DRG_FEE": 22939
		}],
		"ASID": "BJ_V201                     7.08.17_1_2018",
		"DRUGCOSTRATIO": 46.96,
		"PATIENT_TECHCOSTRATIO": "54.98",
		"DRG_CODE": "RS15",
		"PATIENT_MEDCOSTRATIO": "13.55",
		"AS_AVG_FEE": 18331.26,
		"PATIENT_MANAGE_COST": 336.0,
		"AS_DRG_NURS_COST": 407.83,
		"AS_DRG_DRUG_COST": 8608.48,
		"PATIENT_DRUG_COST": 1044.22,
		"AS_DRG_MANAGE_COST": 1191.83,
		"matchOpers": null,
		"MANAGECOSTRATIO": 6.5,
		"AS_DRG_MED_COST": 4058.24,
		"PATIENT_MED_COST": 638.0,
		"PATIENT_NURSCOSTRATIO": "2.17",
		"PATIENT_DRUGCOSTRATIO": "22.17",
		"PATIENT_NURS_COST": 102.0,
		"PATIENT_TOTAL_COST": 4709.72,
		"matchMainDia": "C85.906-->C85.906",
		"AS_AVG_MATERIAL_FEE": 1229.97,
		"AS_AVG_DAYS": 8.58,
		"AS_AVG_DRUG_FEE": 7378.51,
		"AS_DRUG_RATIO": 40.25,
		"AS_DRG_TECH_COST": 4064.88
	}
	}
	w str."result_message"."AS_RISK_LEVEL",!
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).tx1() 
ClassMethod tx1() As %String
{
	s obj=##class(User.DHCDSSMedicalRule).%New()
	s obj.RuleCode="diag002"
	s obj.RuleJoinDise="甲状腺毒症"
	s obj.RuleType="普通规则"
	s obj.RuleClass="诊断"
	s obj.RuleResult="关键"
	s obj.RuleRange="科室"
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
	}
	else
	{
		w $System.OBJ.DisplayError(sc)
	}
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).ty()
ClassMethod ty()
{
	s obj=##class(User.DHCDSSRuleTrigger).%New()
	d obj.RuleDRSetObjectId(2)
	s obj.TriggerConditionNum=2
	s obj.TriggerClass="主诉"
	s obj.TriggerItemCalculate="="
	s obj.TriggerItemLogic="OR"
	s obj.TriggerItem="斜视"
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
	}
	else
	{
		w $System.OBJ.DisplayError(sc)
	}
	q ""
}

ClassMethod j(a, b) As %String
{
	q a_b
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).tx()
ClassMethod tx()
{
	s obj=##class(User.DHCDSSChildRuleTrigger).%New()
	d obj.TriggerConditionNumSetObjectId(7)
	s obj.ChildConditionNum=2
	d obj.RuleDRSetObjectId(1)
	s obj.TriggerClass="检验"
	s obj.TriggerItem="RBC"
	s obj.TriggerItemCalculate=">"
	s obj.TriggerItemLogic="AND"
	s obj.TriggerItemValue="8*10**9"
	s obj.TriggerItemValUnit="L"
	
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
	}
	else
	{
		w $System.OBJ.DisplayError(sc)
	}
	q ""
}

/// QPLDMFLTYFFPEIEC
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).SendAttachMail()
ClassMethod SendAttachMail()
{
	set sever=##class(%Net.SMTP).%New() 
	set sever.smtpserver="smtp.163.com" 

	#; if SMTP server needs auth 
	set auth=##class(%Net.Authenticator).%New() ; use default authentication list 
	set auth.UserName="wechat_py@163.com" 
	set auth.Password="QPLDMFLTYFFPEIEC" 
	set sever.authenticator=auth 
	
	
	Set msg = ##class(%Net.MailMessage).%New()
	Set msg.Subject="Message with M "_$h
	Set msg.IsBinary=0
	Set msg.IsHTML=0
	Do msg.TextData.Write("学习M语言发送邮件.")
	Do msg.To.Insert("1346528238@qq.com")
	Set From=sever.authenticator.UserName
	Set msg.From = From

	//add an attachment
	Set status=msg.AttachFile("D:\", "1.csv")
	If $$$ISERR(status) 
	{
		Do $System.Status.DisplayError(status)
		Quit $$$ERROR()
	}
	
	set wstatus=sever.Send(msg)
	do sever.%Close()
    do msg.%Close()
	if $$$ISOK(wstatus)
	{
		q "发送成功"
	}
	else
	{
		w $System.Status.DisplayError(wstatus),!
		
		q "发送失败"
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).sexrel()
/// 性别：正  原发性痛经
/// 年龄  正   慢性十二指肠溃疡伴出血 
/// 血型   负   急性阑尾炎
/// 地域   正   缺锌性贫血
ClassMethod sexrel()
{
	s obj=##class(User.DHCDSSPastDiagnosis).%New()
	s obj.IDNO="ID000000001"
	s obj.PastHistoryNum=2
	s obj.PatientDR="Card00000001"
	s obj.PastDiagnosisName="天花"
	s obj.TreatmentEffect="未治愈"
	s sc =obj.%Save()
	if $$$ISERR(sc)
	{
		w $system.OBJ.DisplayError(sc),!
	}
	q ""
}

/// "ID000000001^Card00000001^IDCard0001^1^^A"
/// w ##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew("ID000000001^Card00000001^IDCard0001^1^门诊^既往史")
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TransJson("ID000000001^Card00000001^IDCard0001^1^门诊^既往史","既往史","PastDiagnosisName")
ClassMethod TransJson(Info As %String, RTClass As %String, RTItem As %String) As %String
{
	s tempjson={}
	s str=""
	//s ClassJson= ##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew(Info_"^"_RTClass)  //获取当前类别患者信息
	s PatInfo=##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew(Info_"^"_RTClass)
	//s PatInfo=[{"检验名称":"血常规","组顺序":"1","children":[{"血白细胞计数":"10000"},{"中性粒细胞计数":"4000"}]},{"检验名称":"尿常规","组顺序":"1","children":[{"尿白细胞计数":"10000"}, {"尿红细胞计数":"4000"}]}]
	s PatInfo=[].%FromJSON(PatInfo)
	s size=PatInfo.%Size()
	
	for i=0:1:size-1
	{
		s Json=PatInfo.%Get(i)
		s JsonType=PatInfo.%GetTypeOf(i)
		if JsonType="array"             //列表嵌套列表
		{
			s subsize=Json.%Size()
			for j=0:1:subsize-1
			{
				s subjson=Json.%Get(j)
				s value=subjson.%Get(RTItem)  //
				s:str'="" str=str_" "_value
				s:str="" str=value
			}
		}
		elseif JsonType="object"          //列表嵌套对象
		{
			
			if Json.%IsDefined("children")
			{
				s childstr=""
				s item=Json.%Get(RTItem)
				s children=Json.%Get("children")
				s subsize=children.%Size()
				for j=0:1:subsize-1
				{
					s subjson=children.%Get(j)
					set iter = subjson.%GetIterator()
					while iter.%GetNext(.key , .value ) {
						s:childstr'="" childstr=childstr_","_""""_key_""""_":"_""""_value_""""
						s:childstr="" childstr=""""_key_""""_":"_""""_value_""""
					}
				}
				s:str'="" str=str_","_"{"_""""_item_""""_":"_"{"_childstr_"}}"
				s:str="" str="{"_""""_item_""""_":"_"{"_childstr_"}}"
			}
			else
			{
				s value=Json.%Get(RTItem)
				s:str'="" str=str_" "_value
				s:str="" str=value
			}
		}
		else
		{
			w "特殊情况",!
		}
		 
	}
	d tempjson.%Set(RTClass,str)
	s result= tempjson.%ToJSON()
	q result
}

/// w ##class(web.DHCBL.CDSS.Practice).GetSymptomRuleData()
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetSymptomRuleData("ID000000001^Card00000001^IDCard0001^1^门诊")
/// 失明 昏睡 反应迟钝 手部痉挛 发热 黑便   血管加压剂灌注 
/// sym As %String, age As %String, blood As %String, WBC As %String, RBC As %String
ClassMethod GetSymptomRuleData(Info As %String) As %String
{
	//s args={"症状":[[{"症状名称":"发热","部位":"3","group":"1"}],[{"症状名称":"发热","部位":"3","group":"1"}],[{"症状名称":"发热","部位":"3","group":"1"}]]}

	//s args={"症状": "转移性右下腹痛 失明 反应迟钝", "年龄": "20", "检验": {"血常规": {"血白细胞计数": "10001", "中性粒细胞计数": "4000"}}}
	//s args=[].%FromJSON(args)
	s tempSym=""
	k disease
	s disall=""
	s symall=""
	s MRRowid=0
	for
	{
		s MRRowid=$o(^User.DHCDSSMedicalRuleI("TypeIndex"," 诊断",MRRowid))
		q:MRRowid=""
		s RuleDisease=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),5)
		s RuleResult=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),10)
		s RuleICD=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),19)
		s RuleWeight=$select(RuleResult="确诊":$FNUMBER(0.9,"+"),RuleResult="关键":$FNUMBER(0.6,"+"),RuleResult="主要":$FNUMBER(0.3,"+"),RuleResult="伴随":$FNUMBER(0.1,"+"),1:0)
		s RuleStar=$select(RuleResult="确诊":"三星",RuleResult="关键":"三星",RuleResult="主要":"二星",RuleResult="伴随":"一星",1:0)
		k match
		s logicnumA=0    //记录一共的and个数
		s groupA=0   //记录匹配成功的and个数
		s flagA=0    //标记or
		s RTNum=0
		for
		{
			s RTNum=$o(^User.DHCDSSRuleTriggerI("NumIndex",MRRowid,RTNum))
			q:RTNum=""
			s RTRowid = $o(^User.DHCDSSRuleTriggerI("NumIndex",MRRowid,RTNum,0))
			s RTLogic = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),9)    //and or
			s RTCalculate = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),6)   //运算符
			s RTItemField=$lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),5)
			s RTItem  = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),7)    //症状名
			s RTClass = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),4)   //类型
			s RTChild = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),11)   //是否包含子规则
			s param=Info_"^"_RTClass
			s args=..TransJson(param,RTClass,RTItemField)
			s args=[].%FromJSON(args)
			if RTLogic="AND"
			{
				s logicnumA=logicnumA+1
			}
			s RTCLength=$l(RTClass,"&")
			for i=1:1:RTCLength
			{
				s RTclass=$p(RTClass,"&",i)
				if RTclass="症状"     //把所有的症状都记录下来
				{
					s match(MRRowid,RTItem)=""
				}
			
				s items=args.%Get(RTclass)  //血常规obj	
					
				continue:items=""
				s itemslength=$l(items," ")
				for i=1:1:itemslength
				{
					s item=$p(items," ",i)
					continue:item=""
					s exp=""
					if RTCalculate="="
					{
						s exp=""""_item_""""_RTCalculate_""""_RTItem_""""
					}
					else
					{
						s exp=item_RTCalculate_RTItem
					}
					
					if @exp   //规则项匹配成功 
					{
						if RTChild=0    //如果存在子规则
						{
							s flagB=0   
							s groupB=0   //子规则组
							s logicnumB=0  //子规则一共and
							s CRTNum=0
							for
							{
								s CRTNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum))
								q:CRTNum=""
								s CRTRowid=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum,0))
								s CRTClass=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),5)  
								s CRTItemValue=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),8)
								s CRTCalculate=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),7)   
								s CRTItem=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),6) 
								s CRTLogic=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),10)
								if CRTLogic="AND"
								{
									s logicnumB=logicnumB+1
								}
								s CRTCLength=$l(CRTClass,"&")
								for j=1:1:CRTCLength
								{
									s CRTclass=$p(CRTClass,"&",j)
									continue:CRTclass=""
									s citems=args.%Get(RTclass)
									continue:citems=""
									s citemslength=$l(citems," ")
									
									for i=1:1:citemslength
									{
										if CRTclass="症状"     //把子规则中所有的主诉都记录下来
										{
											s match(MRRowid,CRTItemValue)=""
										}
										s citem=$p(citems," ",i)
										continue:citem=""
										s cexp=""""_citem_""""_CRTCalculate_""""_CRTItemValue_""""
										
										if @cexp            //当前这条子规则匹配成功
										{
											if CRTLogic="OR"
											{
												s flagB=1
											}
											if CRTLogic="AND"
											{
												s groupB=groupB+1
												s flagB=0
											}
										}
										else        
										{
											if flagB=1
											{
												if CRTLogic="AND"
												{
													s groupB=groupB+flagB
													s flagB=0
												}
												q
											}
										}
									}
								}
							}
							
							if (groupB+flagB)=(logicnumB+1)
							{
								//子规则完全匹配成功
								if RTLogic="OR"
								{
									s flagA=1
								}
								if RTLogic="AND"
								{
									s groupA=groupA+1
									s flagA=0
								}
							}
						}
						else    //规则匹配成功，没有子规则
						{
							if RTLogic="OR"
							{
								s flagA=1
							}
							if RTLogic="AND"
							{	
								s groupA=groupA+1
								s flagA=0
							}
						}
					}
					elseif $IsObject(items)
					{
						s itemssub=items.%Get(RTItem)  //{"白":"10000","黑":"12"}
						s flagB=0   
						s groupB=0   //子规则组
						s logicnumB=0  //子规则一共and
						s CRTNum=0
						for
						{
							s CRTNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum))
							q:CRTNum=""
							s CRTRowid=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum,0))
							s CRTClass=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),5)  
							s CRTItemValue=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),8)
							s CRTCalculate=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),7)   
							s CRTItem=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),6) 
							s CRTLogic=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),10)
							if CRTLogic="AND"
							{
								s logicnumB=logicnumB+1
							}
							s CRTCLength=$l(CRTClass,"&")
							for j=1:1:CRTCLength
							{
								s CRTclass=$p(CRTClass,"&",j)
								continue:CRTclass=""
								s citems=items.%Get(RTItem)
								continue:citems=""

								if CRTclass="主诉"     //把子规则中所有的主诉都记录下来
								{
									s match(MRRowid,CRTItemValue)=""
								}
								s citemvalue=citems.%Get(CRTItem)
									
								continue:citemvalue=""
								s cexp=""""_citemvalue_""""_CRTCalculate_""""_CRTItemValue_""""
								
								if @cexp            //当前这条子规则匹配成功
								{
									if CRTLogic="OR"
									{
										s flagB=1
									}
									if CRTLogic="AND"
									{
										s groupB=groupB+1
										s flagB=0
									}
								}
								else        
								{
									if flagB=1
									{
										if CRTLogic="AND"
										{
											s groupB=groupB+flagB
											s flagB=0
										}
										q
									}
								}
								
							}
						}
						
						if (groupB+flagB)=(logicnumB+1)
						{
							//子规则完全匹配成功
							if RTLogic="OR"
							{
								s flagA=1
							}
							if RTLogic="AND"
							{
								s groupA=groupA+1
								s flagA=0
							}
							
						}
						
					}
					else   //规则项没有匹配成功
					{
						if flagA=1
						{
							if RTLogic="AND"
							{
								s groupA=groupA+flagA
								s flagA=0
							}
							q
						}
					}
				}
			}
		}
		s tmpstr=""
		s disjson=""
		
		if (groupA+flagA)=(logicnumA+1)
		{	
			s ru=""
			for
			{
				s ru=$o(match(MRRowid,ru))
				q:ru=""
				s:tmpstr'="" tmpstr=tmpstr_","_""""_ru_""""
				s:tmpstr="" tmpstr=""""_ru_""""
			}
			//s disease(RuleDisease)=RuleResult
			s disjson="""疾病名"""_":"_""""_RuleDisease_""""_","_"""权重"""_":"_""""_RuleWeight_""""_","_"""因子"""_":"_""""_RuleResult_""""_","_"""ICD"""_":"_""""_RuleICD_""""_","_"""星级"""_":"_""""_RuleStar_""""_","_"""症状"""_":"_"["_tmpstr_"]"
			
			s:disall'="" disall=disall_",{"_disjson_"}"
			s:disall="" disall="{"_disjson_"}"
		}	
	}
	s result="["_disall_"]"
	q result
}

/// Creator:李得原
/// CreatDate:2020-03-30
/// Description：返回当前疾病是否符合相关性规则
/// 入参：病人信息 疾病名称
/// 返回：1 符合规则  0 不符合规则
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).DiseaseRelation("ID000000001^Card00000001^IDCard0001^1^^诊断","慢性十二指肠溃疡伴出血")
ClassMethod DiseaseRelation(Info As %String, Disease As %String)
{
    s Dis=$zstrip(Disease,"<>W")
	s DisRowid=$o(^User.DHCDSSDiseaseDictI("NameIndex"," "_$zconvert(Dis,"U"),0))
	q:DisRowid="" 0
	s group=0
	s flag=0
	s and=0
	s Num=0
	for
	{
		s Num=$o(^User.DHCDSSDiseVSConditionI("ConditionNumIndex",DisRowid,Num))
		q:Num=""
		s RelRowid=0
		s RelRowid=$o(^User.DHCDSSDiseVSConditionI("ConditionNumIndex",DisRowid,Num,RelRowid))
		q:RelRowid=""
		s DisName=$lg($g(^User.DHCDSSDiseaseDictD(DisRowid)),3)   //疾病名
		s ConLogic=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),9)   //逻辑运算符
		s ConArith=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),7)   //运算符
		s ConName=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),6)   //名称
		s ConValue=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),8)  //值
		s ConType=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),4)  //正负性
		s ConClass=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),5)  //类型（性别、年龄）
		s DbJsonValue=##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew(Info_"^"_ConClass)   //患者数据
		continue:DbJsonValue=""
		s DbJsonValue=[].%FromJSON(DbJsonValue)
		s Size=DbJsonValue.%Size()
		for i=0:1:Size-1
		{
			s (valuelist,value)=""
			s valuelist=DbJsonValue.%Get(i)
			continue:'$IsObject(valuelist)
			s value=valuelist.%Get(ConName)
			continue:value=""
		
			s ConName=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),6)   //名称  (性别名称)
			if @(""""_value_""""_ConArith_""""_ConValue_"""")    // 匹配成功
			{
				if ConType="正性"     //匹配成功
				{
					s flag=1
				}
			}
			else      //匹配失败
			{

				if ConType="负性"   //负性         //匹配成功
				{
					s flag=1	
				}
			}
		}
		if ConLogic="AND"
		{
			if flag=0  //没匹配成功
			{
				q
			}
			else    //当前这条规则匹配成功
			{
				s flag=0
			}
		}
	}
	if flag=1
	{
		q "1"   //匹配成功，要过滤
	}
	else
	{
		q "0"    //匹配不成功，
	}
}

/// 体征信息、症状、个人史、婚育史、处方、检查、检验、手术、护理、输血、饮食、处置
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TransJson("ID000000001^Card00000001^IDCard0001^1^门诊^既往史","既往史","PastDiagnosisName")
ClassMethod GetEntranceData(info As %String) As %String
{
	//体征
	//s PatientSignInfo=
}

ClassMethod GetPatientInfo()
{
}

/// Creator:tianhongxiang
/// CreatDate:2019-12-31
/// Description：获取患者检验信息表信息 
/// Table：User.DHCDSSLabInfo
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).GetPatientLabInfo("ID000000001","1","门诊")
ClassMethod GetPatientLabInfo(IDNO As %String, VisitID As %String, VisitType As %String) As %String
{
	s PatientLabInfo="",LabInfo=""
	s GroupFlag=0
	for
	{
		s GroupFlag =$o(^User.DHCDSSLabInfoI("IDNOLabIndex"," "_$zcvt(IDNO,"U"),VisitID," "_VisitType,GroupFlag)) q:GroupFlag=""
		s LabItemCode=0
		for
		{
			s LabItemCode =$o(^User.DHCDSSLabInfoI("IDNOLabIndex"," "_$zcvt(IDNO,"U"),VisitID," "_VisitType,GroupFlag,LabItemCode)) q:LabItemCode=""
			s LabID=0
			for
			{
				s LabID =$o(^User.DHCDSSLabInfoI("IDNOLabIndex"," "_$zcvt(IDNO,"U"),VisitID," "_VisitType,GroupFlag,LabItemCode,LabID)) q:LabID=""
				
				s GroupFlag=$lg($g(^User.DHCDSSLabInfoD(LabID)),6)
				s GroupSequence=$lg($g(^User.DHCDSSLabInfoD(LabID)),7)
				s InspectionCode=$lg($g(^User.DHCDSSLabInfoD(LabID)),8)
				s InspectionName=$lg($g(^User.DHCDSSLabInfoD(LabID)),9)
				s LabItemCode=$lg($g(^User.DHCDSSLabInfoD(LabID)),10)
				s LabItemName=$lg($g(^User.DHCDSSLabInfoD(LabID)),11)
				s LabResult=$lg($g(^User.DHCDSSLabInfoD(LabID)),12)
				s Unit=$lg($g(^User.DHCDSSLabInfoD(LabID)),13)
				s Reference=$lg($g(^User.DHCDSSLabInfoD(LabID)),14)
				s Specimen=$lg($g(^User.DHCDSSLabInfoD(LabID)),15)
				s ExecuteTime=$lg($g(^User.DHCDSSLabInfoD(LabID)),16)
				if ExecuteTime'="" s ExecuteTime=$zdate(ExecuteTime,3)
				s ReportTime=$lg($g(^User.DHCDSSLabInfoD(LabID)),17)
				if ReportTime'="" s ReportTime=$zdate(ReportTime,3)
				s Remarks=$lg($g(^User.DHCDSSLabInfoD(LabID)),18)
				
				s InspectionInfo="{""InspectionCode"":"""_InspectionCode_""",""InspectionName"":"""_
					InspectionName_""""	
				s LabInfo="{""LabID"":"""_LabID_""",""GroupFlag"":"""_GroupFlag_""",""GroupSequence"":"""_GroupSequence_""",""LabItemCode"":"""_LabItemCode_""",""LabItemName"":"""_LabItemName_""",""LabResult"":"""_LabResult_""",""Unit"","""_
					Unit_""",""Reference"":"""_Reference_""",""Specimen"":"""_Specimen_""",""ExecuteTime"":"""_ExecuteTime_""",""ReportTime"":"""_ReportTime_""",""Remarks"":"""_Remarks_""","""_LabItemName_""":"""_LabResult_"""}"	
				
				if (PatientLabInfo="")
				{
					s PatientLabInfo=InspectionInfo_",""children"":["_LabInfo			
				}
				elseif (PatientLabInfo[InspectionInfo)
				{
					s PatientLabInfo=PatientLabInfo_","_LabInfo			
				}
				else
				{
					s PatientLabInfo=PatientLabInfo_","_InspectionInfo_",""children"":["_LabInfo	
				}
				
			}
			
		}
		s PatientLabInfo=PatientLabInfo_"]}"
	}
	return "["_PatientLabInfo_"]"
}

// w ##class(web.DHCBL.MKB.MKBStructedDiag).HULI()

ClassMethod HULI()
{
	s obj=##class(User.DHCDSSOtherOrderInfo).%New()
	s obj.IDNO="ID000000001"
	s obj.PatientDR="YY001"
	s obj.VisitID=1
	s obj.VisitType="门诊"
	s obj.OrderDesc="阿莫西林"

	s sc=obj.%Save()
	if $$$ISERR(sc)
	{
		w $system.OBJ.DisplayError(sc),!
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).testJson()
ClassMethod testJson()
{
 //	set jsonObj=##class(ext.util.JsonObject).%New()
 //    do jsonObj.Put("id",123).Put("name","wang")
 //    set jsonStr=jsonObj.Json()       // jsonStr => {"id":123,"name":"wang"}
 //    w jsonStr,!
 //   
 	k jsonObj 
    //s str="{""id"":""123"",""name"":""wang"",""rs"":{""rows"":[{""patname"":""病人甲""},],""total"":""1""}}" 
    s str="{""id"":""123"",""name"":""wang"",""rs"":{""rows"":{""patname"":""病人甲""},""total"":""1""}}"
    set jsonObj=##class(ext.util.JsonObject).%New()
    
    
    s jsonObj=jsonObj.FromJSON(str)
    w jsonObj.Get("patname"),!
    b ;1
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).testJson2()
ClassMethod testJson2()
{
	set jsonObj=##class(ext.util.JsonObject).%New()
	set jsonObj1=##class(ext.util.JsonObject).%New()
    do jsonObj.Put("id",123).Put("name","wang").Put("1","2").Put("2","3").Put(3,4).Put(4,2).Put("A",1)
    d jsonObj.Put("age","12").Put("B",1).Put("b",1).Put("C",1).Put(100000,1)
    s dict={"cdl":"cdl"}
    s dict=dict.%ToJSON()
    w dict,!
    d jsonObj.Put("dict","["_dict_"]")
    d jsonObj1.Put("id",123).Put("name","wang")
    d jsonObj1.Put("rs","{""rows"":[{""patname"":""病人甲""}],""total"":""1""}")
    w jsonObj.Get("dict"),!
    w jsonObj.Get("rs"),!
    set jsonStr=jsonObj.Json()
    d jsonObj.FromJSON(jsonStr)
    s jsonStr1=jsonObj1.Json()
    d jsonObj1.FromJSON(jsonStr1)
    w "aaaa"_jsonObj1.Json(),!
    s str="{""id"":""123"",""name"":""wang"",""rs"":{""rows"":[{""patname"":""病人甲""}],""total"":""1""}}"
    set jsonObj2=##class(ext.util.JsonObject).%New()
	set jsonObj2=jsonObj2.FromJSON(str)
    w "aaaa"_str,!
 //    w jsonObj.Get("A"),!
 //    w jsonObj,!
    w jsonStr,!
    w jsonObj.Json(),!
    b
    w jsonObj.Get("rs"),!
 //    set jsonObj1=##class(ext.util.JsonObject).%New()
 //    set jsonObj2=##class(ext.util.JsonObject).%New()
 //    set jsonObj3=##class(ext.util.JsonObject).%New()
 //    set jsonObj4=##class(ext.util.JsonObject).%New()
 //    set jsonObj5=##class(ext.util.JsonObject).%New()
 //    d jsonObj1.Put("patname","病人甲")
 //    d jsonObj2.Put("rows",jsonObj1.Json())
 //    w jsonObj2.Get("rows","patname")
 //    w jsonObj2.Json()
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).FamilyInsert()
ClassMethod FamilyInsert()
{
	s obj=##class(User.DHCDSSFamilyHisInfo).%New()
	s obj.GeneticDiseName="皮肌炎"
	s obj.IDNO="ID000000001"
	s obj.Relationship="父亲"
	s obj.PatientDR="YY001"
	s obj.GeneticDiseNo="1"
	s sc=obj.%Save()
	if $$$ISERR(sc)
	{
		w $system.OBJ.DisplayError(sc),!
	}
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TestLength()
ClassMethod TestLength()
{
	s str=""
	for i=0:1:3640000
	{
		s a="测"
		s str=str_a
	}
	w $l(str),!
	
	q str
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TestReturn()
ClassMethod TestReturn()
{
	for i=0:1:10
	{
		for j=i:1:50
		{
			if j=4
			{
				return "##"
			}
		}
		w i,!
	}
	w "hello",!
	q ""
}

/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TestNesting()
ClassMethod TestNesting()
{
	s a= ..TestReturn()
	w a_a,!
	w "结束"
	q ""
}

/// Creator:李得原
/// CreatDate:2019-01-29
/// Description:把ICD11导入到知识库
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportICD11()
ClassMethod ImportICD111()
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	s unknown=0
	s unknownL6=0
	s l5=0
	s id=0
	Ts
	s TermBase=$o(^User.MKBTermBaseI("DescIndex"," ICD11外因",0))   ;60
	s file=##class(%File).%New("D:\工作\2020-05-11\23外因.csv")
	;s file=##class(%File).%New("D:\工作\2019-01-28\ceshi.csv")
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		s code=$p(str,",",1)
		s diag=$p(str,",",2)
		s activeflag=$p(str,",",3)
		s code=$Zstrip(code,"<>W")
		s diag=$zstrip(diag,"<>W")
		s readcount=readcount+1
		if code="第X章"
		{
			q
		}
		if code'=""
		{
			s Flag=$p(code,"-",1)
			;if (ToId="") set ToId="-100000000000000"
			if (code["章")
			{
				k ^TMP("MarkRootID")
				k ^TMP("MarkL1ID")
				k ^TMP("MarkL2ID")
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				s RootId="-100000000000000"
				d obj.MKBTLastLevelSetObjectId(RootId)
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkRootID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			elseif (Flag="L1")
			{
				k ^TMP("MarkL1ID")
				k ^TMP("MarkL2ID")
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s RootFlag=""
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkRootID",RootFlag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL1ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			elseif (Flag="L2")
			{
				k ^TMP("MarkL2ID")
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L1Flag=""
				s L1Flag=$o(^TMP("MarkL1ID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL1ID",L1Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL2ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}					
			}
			elseif (Flag="L3")
			{
				k ^TMP("MarkL3ID")
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L2Flag=""
				s L2Flag=$o(^TMP("MarkL2ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL2ID",L2Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL3ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}	
			}
			elseif (Flag="L4")
			{
				k ^TMP("MarkL4ID")
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L3Flag=""
				s L3Flag=$o(^TMP("MarkL3ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL3ID",L3Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL4ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}	
			}
			elseif (Flag="L5")
			{
				k ^TMP("MarkL5ID")
				k ^TMP("MarkL6ID")
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L4Flag=""
				s L4Flag=$o(^TMP("MarkL4ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL4ID",L4Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL5ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}	
			}
			elseif ($l(code)=4)
			{
				if '$d(^TMP("MarkL1ID"))
				{
					k ^TMP("MarkL1ID")
					k ^TMP("MarkL2ID")
					k ^TMP("MarkL3ID")
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s RootFlag=""
					s RootFlag=$o(^TMP("MarkRootID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkRootID",RootFlag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				}
				elseif '$d(^TMP("MarkL2ID"))
				{					
					k ^TMP("MarkL2ID")
					k ^TMP("MarkL3ID")
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L1Flag=""
					s L1Flag=$o(^TMP("MarkL1ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL1ID",L1Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)	
				}
				elseif '$d(^TMP("MarkL3ID"))
				{					
					k ^TMP("MarkL3ID")
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L2Flag=""
					s L2Flag=$o(^TMP("MarkL2ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL2ID",L2Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)		
				}
				elseif '$d(^TMP("MarkL4ID"))
				{					
					k ^TMP("MarkL4ID")
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L3Flag=""
					s L3Flag=$o(^TMP("MarkL3ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL3ID",L3Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)		
				}
				elseif '$d(^TMP("MarkL5ID"))
				{					
					k ^TMP("MarkL5ID")
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L4Flag=""
					s L4Flag=$o(^TMP("MarkL4ID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL4ID",L4Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)		
				}
				elseif $d(^TMP("MarkL5ID"))
				{
					k ^TMP("MarkL6ID")
					k ^TMP("MarkL7ID")
					k ^TMP("MarkL8ID")
					s L5Flag=""
					s L5Flag=$o(^TMP("MarkL5ID",""))
					s RootFlag=$o(^TMP("MarkRootID",""))
					s obj=##class(User.MKBTerm).%New()
					s obj.MKBTCode=code
					s obj.MKBTDesc=diag
					d obj.MKBTLastLevelSetObjectId(^TMP("MarkL5ID",L5Flag))
					s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
					s obj.MKBTNote=activeflag
					d obj.MKBTBaseDRSetObjectId(TermBase)
					s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				}
				else
				{
					s unknownL6=unknownL6+1
				}
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL6ID",code)=id
					set result = "{success:'true',id:'"_id_"'}"
					s savecount=savecount+1 
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
				
			}
			elseif ($l(code)=5)
			{
				
				s l5=l5+1
				b ;code=5
			}
			elseif ($l(code)=6)
			{
				k ^TMP("MarkL7ID")
				k ^TMP("MarkL8ID")
				s L6Flag=""
				s L6Flag=$o(^TMP("MarkL6ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL6ID",L6Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL7ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			elseif ($l(code)=7)
			{
				k ^TMP("MarkL8ID")
				s L7Flag=""
				s L7Flag=$o(^TMP("MarkL7ID",""))
				s RootFlag=$o(^TMP("MarkRootID",""))
				s obj=##class(User.MKBTerm).%New()
				s obj.MKBTCode=code
				s obj.MKBTDesc=diag
				d obj.MKBTLastLevelSetObjectId(^TMP("MarkL7ID",L7Flag))
				s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
				s obj.MKBTNote=activeflag
				d obj.MKBTBaseDRSetObjectId(TermBase)
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
				s sc=obj.%Save()
				d obj.%Close()
				if $$$ISOK(sc)
				{
					set id=obj.%Id()
					s ^TMP("MarkL8ID",code)=id
					set result = "{success:'true',id:'"_id_"'}" 
					s savecount=savecount+1
				}
				else
				{
					set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
					b
				}
			}
			else
			{
				s unknown=unknown+1
			}
		}
		else   //code为空
		{
			s nosavecount=nosavecount+1
			b ; code=none
		}
		
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "unknown:"_unknownL6,!
	w "unknownL6:"_unknownL6,!
	w l5,!
	q result
}

/// 2020-05-14 加班导icd11
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertIcd11()
ClassMethod InsertIcd11()
{
	s obj=##class(User.MKBTerm).%OpenId(1683328)
	d obj.MKBTLastLevelSetObjectId(-100000000000000)
	s sc=obj.%Save()
	if $$$ISOK(sc)
	{
		w "1"
	}
	else
	{
		w "2"
	}
}

/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).InsertIcd11()
ClassMethod GetKuoZhanMa(Data As %String) As %String
{
	
	s row=$p(Data,"^^",1)
	s code=$p(Data,"^^",2)
	s desc=$p(Data,"^^",3)
	s flag=$p(Data,"^^",4)
	s ^LDYICD(row,code,desc,flag)=""
	q "1"
}

/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportICD11Extend()
ClassMethod ImportICD11Extend()
{
	Ts
	k ^TempMark
	s TermBase=$o(^User.MKBTermBaseI("DescIndex"," ICD11扩展码",0))
	s Rowid=0
	for
	{
		s Rowid=$o(^LDYICD(Rowid))
		q:Rowid=""
		w Rowid,!
		if $d(^TempMark(Rowid))
		{
			continue
		}
		s Code=$o(^LDYICD(Rowid,""))
		s Desc=$o(^LDYICD(Rowid,Code,""))
		s Flag=$o(^LDYICD(Rowid,Code,Desc,""))
		
		w Code_"^"_Desc_"^"_Flag,!
		if Code="nan"    //如果Code为空
		{
			s Code=Rowid


			if $d(^TempICD11RootId("3"))
			{
				s LastLevel=^TempICD11RootId("3")
			}
			elseif $d(^TempICD11RootId("2"))
			{
				s LastLevel=^TempICD11RootId("2")
			}
			elseif $d(^TempICD11RootId("1"))
			{
				s LastLevel=^TempICD11RootId("1")
				
			}
			else
			{
				s LastLevel="-100000000000000"
			}
			s NewId=..SaveICD11Extend(LastLevel,Flag,Code,Desc,TermBase)
			s ^TempMark(Rowid)=""
			s NextCode=$o(^LDYICD(Rowid+1,""))
			if NextCode="nan"    //如果下一层Code也为空(连续两层)
			{
				s NextDesc=$o(^LDYICD(Rowid+1,"nan","")) 
				s NextCode=Rowid+1
				s Flag=$o(^LDYICD(Rowid+1,NextCode,NextDesc,""))
				s NewNextId=..SaveICD11Extend(NewId,Flag,NextCode,NextDesc,TermBase)
				s ^TempMark(Rowid+1)=""
				s ^TempICD11RootId("2")=NewNextId
				k ^TempICD11RootId("3")
				s NextNextCode=$o(^LDYICD(Rowid+2,""))
				if NextNextCode="nan"    //如果下下一层也为空(连续三层)
				{
					s NextNextDesc=$o(^LDYICD(Rowid+2,"nan",""))
					s NextNextCode=Rowid+2
					s Flag=$o(^LDYICD(Rowid+2,NextNextCode,NextNextCode,""))
					s NewNextNextId= ..SaveICD11Extend(^TempICD11RootId("2"),Flag,NextNextCode,NextNextDesc,TermBase)
					s ^TempMark(Rowid+2)=""
					s ^TempICD11RootId("3")=NewNextNextId
				}
				else
				{
					continue
				}
			}
			else
			{
				
				s NextDesc=$o(^LDYICD(Rowid+1,NextCode,"")) 
				s Flag=$o(^LDYICD(Rowid+1,NextCode,NextDesc,""))
				s NewNextId=..SaveICD11Extend(LastLevel,Flag,NextCode,NextDesc,TermBase)
				s ^TempMark(Rowid+1)=""
				k ^TempICD11RootId("3")
				k ^TempICD11RootId("2")
			}
		}
		else
		{
			if $d(^TempICD11RootId("3"))
			{
				s NewId=..SaveICD11Extend(^TempICD11RootId("3"),Flag,Code,Desc,TermBase)
				s ^TempMark(Rowid)=""
			}
			elseif $d(^TempICD11RootId("2"))
			{
				s NewId=..SaveICD11Extend(^TempICD11RootId("2"),Flag,Code,Desc,TermBase)
			
				k ^TempICD11RootId("3")
				
				s ^TempMark(Rowid)=""
			}
			elseif $d(^TempICD11RootId("1"))
			{
				s NewId=..SaveICD11Extend(^TempICD11RootId("1"),Flag,Code,Desc,TermBase)
				k ^TempICD11RootId("3")
				k ^TempICD11RootId("2")
				
				s ^TempMark(Rowid)=""
			}
			else
			{
				s NewId=..SaveICD11Extend("-100000000000000",Flag,Code,Desc,TermBase)
				s ^TempICD11RootId("1")=NewId
				s ^TempMark(Rowid)=""
			}
			
		}
	}
	q ""
}

ClassMethod SaveICD11Extend(RootId, activeflag, Code, Diag, TermBase)
{
		s obj=##class(User.MKBTerm).%New()
		s obj.MKBTCode=##class(web.DHCBL.BDP.FunLib).EvalJSON(Code)
		s Diag=##class(web.DHCBL.BDP.FunLib).EvalJSON(Diag)
		s obj.MKBTDesc=Diag
 //		s RootId="-100000000000000"
		d obj.MKBTLastLevelSetObjectId(RootId)
		
		s MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Diag)
		s MKBTPYCode=$tr(MKBTPYCode,"""","")
		s MKBTPYCode=$tr(MKBTPYCode,",","，")
		s MKBTPYCode= ##class(web.DHCBL.BDP.FunLib).EvalJSONB(MKBTPYCode)
		s obj.MKBTPYCode=MKBTPYCode
		s obj.MKBTNote=activeflag
		d obj.MKBTBaseDRSetObjectId(TermBase)
		s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(TermBase)
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			set id=obj.%Id()
			
			set result = "{success:'true',id:'"_id_"'}" 
 //			s savecount=savecount+1
			q id
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b
		}
}

/// Creator:谷雪萍
/// CreatDate:2020-05-14
/// Description:把ICD11Xcode导入到知识库
/// Table:User.MKBTerm
/// Input:
/// Return:
/// Other:w ##class(web.DHCBL.MKB.MKBStructedDiag).ImportICD11Xcode()
ClassMethod ImportICD11Xcode()
{
	s TermBase=$o(^User.MKBTermBaseI("DescIndex"," ICD11扩展码",0))   ;60
	s file=##class(%File).%New("D:\ICD11Xcode.csv")
	s count=0
	s parent=""
	d file.Open("RS")
	d file.ReadLine()
	TS 
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		s count=count+1

		s code=$p(str,",",1)
		s diag=$p(str,",",2)
		s activeflag=$p(str,",",3)
		s code=$Zstrip(code,"<>W")
		s diag=$zstrip(diag,"<>W")
		s arr(count)=code
		continue:diag=""
		s obj=##class(User.MKBTerm).%New()		
		if (code'="")  //如果代码不为空
		{
			s obj.MKBTCode=code
		}
		else  //如果代码为空则代码等于行号
		{
			s obj.MKBTCode=count
			if (count>1)&(arr(count-1)'="")  //如果上一行不为空,则把父节点置为空
			{
				s parent=""
			}
			
		}
		s obj.MKBTDesc=diag
		if (parent'="")
		{
			d obj.MKBTLastLevelSetObjectId(parent)
		}
		s obj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(diag)
		s obj.MKBTNote=activeflag
		d obj.MKBTBaseDRSetObjectId(TermBase)
		s obj.MKBTSequence=count
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			set id=obj.%Id()
			if (code="")
			{
				s parent=id
			}
			set result = "{success:'true',id:'"_id_"'}" 
		}
		else
		{
			set result ="{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"
			b
		}
	}
	q result
}

}

Class web.DHCBL.MKB.ICDRelationData Extends %RegisteredObject
{

/// d ##class(web.DHCBL.MKB.ICDRelationData).HISICD()
ClassMethod HISICD()
{
		
	s HIS = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICDHIS码",0))
	s BObj = ##class(User.MKBKLMappingBase).%New()
	s BObj.MKBKMBCode = ##class(web.DHCBL.MKB.MKBKLMappingBase).GenerateCode()
	s BObj.MKBKMBDesc = "HIS版ICD对照"
	s BObj.MKBKMBKnowledge1 = 5
	s BObj.MKBKMBKnowledge2 = HIS 
	s BObj.MKBKMBMappingRelation = 1
	s sc = BObj.%Save()
	s BID = BObj.%Id()

	s BFObj = ##class(User.MKBKLMappingBaseField).%New(BID)
	s BFObj.MKBKMBFCode=##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode(BID)
	s BFObj.MKBKMBFDesc="诊断"
	s BFObj.MKBKMBFConfig = "Exp"
	s BFObj.MKBKMBFType = "K1"
	s BFObj.MKBKMBFSequence=1
	d BFObj.ParRefSetObjectId(BID)
	d BFObj.%Save()
	s BFID1=BFObj.%Id()
	
	s BFObj = ##class(User.MKBKLMappingBaseField).%New(BID)
	s BFObj.MKBKMBFCode=##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode(BID)
	s BFObj.MKBKMBFDesc="中文释义"
	s BFObj.MKBKMBFConfig = "Desc"
	s BFObj.MKBKMBFType = "K2"
	s BFObj.MKBKMBFSequence=2
	d BFObj.ParRefSetObjectId(BID)
	d BFObj.%Save()
	s BFID2=BFObj.%Id()

	s BFObj = ##class(User.MKBKLMappingBaseField).%New(BID)
	s BFObj.MKBKMBFCode=##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode(BID)
	s BFObj.MKBKMBFDesc="ICD编码"
	s BFObj.MKBKMBFSequence=3
	s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("DescIndex",HIS," ICD编码",0))
	s BFObj.MKBKMBFConfig = MKBTBPRowId
	s BFObj.MKBKMBFType = "K2"
	d BFObj.ParRefSetObjectId(BID)
	d BFObj.%Save()
	s BFID3=BFObj.%Id()
		
	s i=1
	s TKBICDRERowId = 0
	for
	{
		s TKBICDRERowId = $O(^TKBICDRE(TKBICDRERowId))
		q:TKBICDRERowId=""
		
		if ($P($G(^TKBICDRE(TKBICDRERowId)),"^",13)="") //HIS版
		{
			continue	
		}
		s TKBICDRDiag1=$p($g(^TKBICDRE(TKBICDRERowId)),"^",1)
		s TKBICDRDiag2=$p($g(^TKBICDRE(TKBICDRERowId)),"^",2)  
		s TKBICDRDiag3=$p($g(^TKBICDRE(TKBICDRERowId)),"^",3)  
		
		s TKBICDRMRCDR=$p($g(^TKBICDRE(TKBICDRERowId)),"^",13)
		
		s MRCCode = $P($G(^MRC("ID",TKBICDRMRCDR)),"^",1)
		s MKBMRCRowId = $O(^User.MKBTermI("CodeIndex",HIS,$ZCONVERT(" "_MRCCode,"U"),0))
		s MKBMRCProId = $O(^User.MKBTermPropertyI("DescIndex",MKBMRCRowId," ICD编码",0))
		s MKBMRCDetId = $O(^User.MKBTermProDetailI("ProIdx",MKBMRCProId,0))
		s MKBMRCDetDesc = $LG($G(^User.MKBTermProDetailD(MKBMRCDetId)),3)

		s TKBICDRMRCNote = $p($g(^TKBICDRE(TKBICDRERowId)),"^",14)
		s TKBICDRMRCState = $p($g(^TKBICDRE(TKBICDRERowId)),"^",15)
		
	

		s newDiag=""
		s tempDiag=""
		if (TKBICDRDiag1'="")
		{
			s tempDiag = ..GetNewDiag(TKBICDRDiag1)
			if (tempDiag'="")
			{
				s newDiag = tempDiag	
			}	
		}
		if (TKBICDRDiag2'="")
		{
			s tempDiag = ..GetNewDiag(TKBICDRDiag2)
			if (tempDiag'="")
			{
				if (newDiag="")
				{
					s newDiag = tempDiag	
				}
				else
				{
					s newDiag = newDiag_";&"_tempDiag		
				}
			}	
		}
		if (TKBICDRDiag3'="")
		{
			s tempDiag = ..GetNewDiag(TKBICDRDiag3)
			if (tempDiag'="")
			{
				if (newDiag="")
				{
					s newDiag = tempDiag	
				}
				else
				{
					s newDiag = newDiag_";&"_tempDiag		
				}
			}	
		}
		if (newDiag="")
		{
			continue	
		}
		
		
		s BFDObj = ##class(User.MKBKLMappingDetail).%New()
		s BFDObj.MKBKMDRowNum = i
		s BFDObj.MKBKMDValue = newDiag
		d BFDObj.MKBKMDKMBaseFieldDrSetObjectId(BFID1)
		d BFDObj.MKBKMDKMBaseDrSetObjectId(BID)
		d BFDObj.%Save()
		if (newDiag'="")
		{
			if ($e(newDiag,1)=";")
			{
				b ;newDiag=";"	
			}
			if (BID="")
			{
				b ;BID=""	
			}
			d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GenerateDiagGlobal(BID,BFDObj.MKBKMDValue,BFDObj.%Id())
		}
	
		s BFDObj = ##class(User.MKBKLMappingDetail).%New()
		s BFDObj.MKBKMDRowNum = i
		s BFDObj.MKBKMDValue = MKBMRCRowId
		d BFDObj.MKBKMDKMBaseFieldDrSetObjectId(BFID2)
		d BFDObj.MKBKMDKMBaseDrSetObjectId(BID)
		d BFDObj.%Save()
		/*
		s BFDObj = ##class(User.MKBKLMappingDetail).%New()
		s BFDObj.MKBKMDRowNum = i
		s BFDObj.MKBKMDValue = MKBMRCDetId
		d BFDObj.MKBKMDKMBaseFieldDrSetObjectId(BFID3)
		d BFDObj.MKBKMDKMBaseDrSetObjectId(BID)
		d BFDObj.%Save()
		*/
		
		s i = i+1
	}
}

/// d ##class(web.DHCBL.MKB.ICDRelationData).BJICD()
ClassMethod BJICD()
{

	s BObj = ##class(User.MKBKLMappingBase).%New()
	s BObj.MKBKMBCode = "B00000001"
	s BObj.MKBKMBDesc = "HISICD对照"
	s BObj.MKBKMBKnowledge1 = 5
	s BObj.MKBKMBKnowledge2 = 23 
	s BObj.MKBKMBMappingRelation = 1
	d BObj.%Save()
	s BID = BObj.%Id()
	
	s BFObj = ##class(User.MKBKLMappingBaseField).%New(BID)
	s BFObj.MKBKMBFCode=##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode(BID)
	s BFObj.MKBKMBFDesc="诊断"
	s BFObj.MKBKMBFConfig = "Exp"
	s BFObj.MKBKMBFType = "K1"
	d BFObj.ParRefSetObjectId(BID)
	d BFObj.%Save()
	s BFID1=BFObj.%Id()
	
	s BFObj = ##class(User.MKBKLMappingBaseField).%New(BID)
	s BFObj.MKBKMBFCode=##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode(BID)
	s BFObj.MKBKMBFDesc="中文释义"
	s BFObj.MKBKMBFConfig = "Desc"
	s BFObj.MKBKMBFType = "K2"
	d BFObj.ParRefSetObjectId(BID)
	d BFObj.%Save()
	s BFID2=BFObj.%Id()
	
	s BFObj = ##class(User.MKBKLMappingBaseField).%New(BID)
	s BFObj.MKBKMBFCode=##class(web.DHCBL.MKB.MKBKLMappingBaseField).GenerateCode(BID)
	s BFObj.MKBKMBFDesc="ICD编码"
	s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("DescIndex",23," ICD编码",0))
	s BFObj.MKBKMBFConfig = MKBTBPRowId
	s BFObj.MKBKMBFType = "K2"
	d BFObj.ParRefSetObjectId(BID)
	d BFObj.%Save()
	s BFID3=BFObj.%Id()
		
	s i=1
	s TKBICDRERowId = 0
	for
	{
		s TKBICDRERowId = $O(^TKBICDRE(TKBICDRERowId))
		q:TKBICDRERowId=""
		
		if ($P($G(^TKBICDRE(TKBICDRERowId)),"^",4)="") //北京版
		{
			continue	
		}
		s TKBICDRDiag1=$p($g(^TKBICDRE(TKBICDRERowId)),"^",1)
		s TKBICDRDiag2=$p($g(^TKBICDRE(TKBICDRERowId)),"^",2)  
		s TKBICDRDiag3=$p($g(^TKBICDRE(TKBICDRERowId)),"^",3)  
		s TKBICDRTremDr=$p($g(^TKBICDRE(TKBICDRERowId)),"^",4) 
				
		s TKBBJCode = $P($G(^TKBTREM(TKBICDRTremDr)),"^",1)
		s MKBBJRowId = $O(^User.MKBTermI("CodeIndex",23," "_$ZCONVERT(TKBBJCode,"U"),0))
		
		s MKBBJProId = $O(^User.MKBTermPropertyI("DescIndex",MKBBJRowId," ICD编码",0))
		s MKBBJDetId = $O(^User.MKBTermProDetailI("ProIdx",MKBBJProId,0))
		s MKBBJDetDesc = $LG($G(^User.MKBTermProDetailD(MKBBJDetId)),3)
		w MKBBJDetDesc,!
		
		s TKBICDRNote=$p($g(^TKBICDRE(TKBICDRERowId)),"^",8) 
		s TKBICDRState=$p($g(^TKBICDRE(TKBICDRERowId)),"^",9)
		s TKBICDRMRCDR=$p($g(^TKBICDRE(TKBICDRERowId)),"^",13)
		s TKBICDRMRCNote = $p($g(^TKBICDRE(TKBICDRERowId)),"^",14)
		s TKBICDRMRCState = $p($g(^TKBICDRE(TKBICDRERowId)),"^",15)
		
	

		s newDiag=""
		if (TKBICDRDiag1'="")
		{
			s tempDiag = ..GetNewDiag(TKBICDRDiag1)
			if (tempDiag'="")
			{
				s newDiag = tempDiag	
			}	
		}
		if (TKBICDRDiag2'="")
		{
			s tempDiag = ..GetNewDiag(TKBICDRDiag2)
			if (tempDiag'="")
			{
				s newDiag = newDiag_";&"_tempDiag	
			}	
		}
		if (TKBICDRDiag3'="")
		{
			s tempDiag = ..GetNewDiag(TKBICDRDiag3)
			if (tempDiag'="")
			{
				s newDiag = newDiag_";&"_tempDiag	
			}	
		}
		if (newDiag="")
		{
			continue	
		}
		
		
		
		s BFDObj = ##class(User.MKBKLMappingDetail).%New()
		s BFDObj.MKBKMDRowNum = i
		s BFDObj.MKBKMDValue = newDiag
		d BFDObj.MKBKMDKMBaseFieldDrSetObjectId(BFID1)
		d BFDObj.MKBKMDKMBaseDrSetObjectId(BID)
		d BFDObj.%Save()
		d ##class(web.DHCBL.MKB.MKBKLMappingDetailInterface).GenerateDiagGlobal(BID,BFDObj.MKBKMDValue,BFDObj.%Id())
		
		s BFDObj = ##class(User.MKBKLMappingDetail).%New()
		s BFDObj.MKBKMDRowNum = i
		s BFDObj.MKBKMDValue = MKBBJRowId
		d BFDObj.MKBKMDKMBaseFieldDrSetObjectId(BFID2)
		d BFDObj.MKBKMDKMBaseDrSetObjectId(BID)
		d BFDObj.%Save()
	
		s BFDObj = ##class(User.MKBKLMappingDetail).%New()
		s BFDObj.MKBKMDRowNum = i
		s BFDObj.MKBKMDValue = MKBBJDetId
		d BFDObj.MKBKMDKMBaseFieldDrSetObjectId(BFID3)
		d BFDObj.MKBKMDKMBaseDrSetObjectId(BID)
		d BFDObj.%Save()
		
		s i = i+1
	}
}

/// w ##class(web.DHCBL.MKB.ICDRelationData).GetNewDiag("1064-20797:44741*43124,30100:45302")
ClassMethod GetNewDiag(old)
{
	q:old="" ""
	s continue=""
	s result=""
	s TremId = $P(old,"-",1)
	s TremCode = $P($G(^TKBTREM(TremId)),"^",1)
	s TremCode = $ZCONVERT(TremCode,"U")
	s TermId = $O(^User.MKBTermI("CodeIndex",5,$ZCONVERT(" "_TremCode,"U"),0))
	if (TermId="")
	{
		q ""	
	}
	s AllCatDetStr = $P(old,"-",2)
	if (old["-")&&(AllCatDetStr'="")&&($P(AllCatDetStr,":",2)'="")
	{
		s ACDnum = $L(AllCatDetStr,",")
		for i=1:1:ACDnum
		{
			s CatDetStr = $P(AllCatDetStr,",",i)
			s ExtId = $P(CatDetStr,":",1)
			if ($D(^TKBTREEXT(ExtId))=0)
			{	
				continue
			}
			s ExtCode = $P($G(^TKBTREEXT(ExtId)),"^",1)
			s ExtType = $P($G(^TKBTREEXT(ExtId)),"^",3)
			s ExtConfig = $P($G(^TKBTREEXT(ExtId)),"^",4)
			s ProId = $O(^User.MKBTermPropertyI("CodeIndex",TermId," "_ExtCode,0))
			if (ProId="")
			{
				s continue="Y"	
				continue
			}
			s ProConfig = $LG($G(^User.MKBTermPropertyD(ProId)),5)
			s DetStr=$P(CatDetStr,":",2)
			if (DetStr="")
			{
				b	
			}
			s DetResult=""
			if (ExtType="S")
			{
				b ;ExtType="S"
				continue	
			}
			if (ExtType="T")&&(ExtConfig'="")
			{
				s Dnum = $L(DetStr,"*")
				for j=1:1:Dnum
				{
					s ExtDetId = $P(DetStr,"*",j)
					s ExtDetDesc = $P($G(^TKBTREEXTDTL(ExtDetId)),"^",2)
					s ProTermId = 0
					
					if ($O(^User.MKBTermI("DescIndex",ProConfig," "_ExtDetDesc,0)))'=($O(^User.MKBTermI("DescIndex",ProConfig," "_ExtDetDesc,""),-1))	
					{
						s continue="Y"
						continue	
					}
					s ProTermId = $O(^User.MKBTermI("DescIndex",ProConfig," "_ExtDetDesc,0))
					if (ProTermId="")
					{
						s continue="Y"
						continue
					}
					s:DetResult'="" DetResult = DetResult_"*S"_ProTermId
					s:DetResult="" DetResult="S"_ProTermId
				}
			}
			else
			{	
				s Dnum = $L(DetStr,"*")
				for j=1:1:Dnum
				{
					s ExtDetId = $P(DetStr,"*",j)
					if ($D(^TKBTREEXTDTL(ExtDetId))=0)
					{
						s continue="Y"
						continue	
					}
					s ExtDetDesc = $P($G(^TKBTREEXTDTL(ExtDetId)),"^",2)
					s ProDetId = 0
					for
					{
						s ProDetId = $O(^User.MKBTermProDetailI("ProIdx",ProId,ProDetId))
						q:ProDetId=""
						
						s ProDetDesc = $LG($G(^User.MKBTermProDetailD(ProDetId)),3)
						if (ProDetDesc=ExtDetDesc)
						{
							q
						}
					}
					if (ProDetId="")
					{
						s continue="Y"
						continue
					}
					s:DetResult'="" DetResult = DetResult_"*"_ProDetId
					s:DetResult="" DetResult=ProDetId
				}
			}	
			if (DetResult="")
			{
				s continue="Y"
				continue
			}
			if (result="")
			{
				s result = TermId_"-"_ProId_":"_DetResult	
			}
			else
			{
				s result = result_";&"_TermId_"-"_ProId_":"_DetResult		
			}	
		}
	}
	else
	{
		s result = TermId	
	}
	q result
}

}

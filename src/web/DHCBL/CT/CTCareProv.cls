Import SQLUser

/// 名称: 医护人员
/// 描述: 医护人员维护，包含增删改查等功能
/// 编写者：基础数据平台组 、蔡昊哲 chenying
/// 编写日期: 2012-7-1
Class web.DHCBL.CT.CTCareProv Extends %RegisteredObject [ ProcedureBlock ]
{

/// update20200522 
Parameter SQLTableName = "CT_CareProv";

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年3月31日
/// Description：查询医护人员的内容，真分页
/// Table：User.CTCareProv
/// Other: w ##class(web.DHCBL.CT.CTCareProv).GetListPage("","","","","","","","","","","","0","2")
ClassMethod GetListPage(RowId1, Code, Desc, CarPrvTpDR, ActiveFlag, HICApprovedFlag, InternalType, Hospital, query, sort, dir, start, limit) As %String
{
	if (RowId1'="") //根据rowid返回该条记录
	{
		s CTPCPRowId1=RowId1
		s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //工号
		s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
		s CTPCPId=$p($g(^CTPCP(CTPCPRowId1,1)),"^",3)         //标识码
		s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,3)),"^",28)  //别名
		;s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,1)),"^",7)  //拼音检索码
		s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
		s CTCPTInternalType=""
		s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
		s:CTPCPCarPrvTpDR'="" CTPCPCarPrvTpDR=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //人员类型
		s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
		s:CTPCPSpecDR'="" CTPCPSpecDR=$p($g(^CT("SPC",CTPCPSpecDR)),"^",2)  //专长描述
		s CTPCPUnit=$p($g(^CTPCP(CTPCPRowId1,2)),"^",8)      //医生资格号
		s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
		s CTPCPSpecialistYN=$p($g(^CTPCP(CTPCPRowId1,1)),"^",16)      //专家
		s CTPCPSurgeon=$p($g(^CTPCP(CTPCPRowId1,2)),"^",18)           //外科医生
		s CTPCPHICApproved=$p($g(^CTPCP(CTPCPRowId1,3)),"^",31) 		//毒麻处方权
		s CTPCPAnaesthetist=$p($g(^CTPCP(CTPCPRowId1,2)),"^",19) 		//麻醉师
		s CTPCPMentalFlag=$p($g(^CTPCP(CTPCPRowId1,3)),"^",33) 		//精神类药物处方权
		s CTPCPDateActiveFrom=$p($g(^CTPCP(CTPCPRowId1,2)),"^",14)    //激活时间
		s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //截止时间
		s CTPCPUpdateDate=$p($g(^CTPCP(CTPCPRowId1,3)),"^",22)    //更新日期
		s CTPCPUpdateUserDR=$p($g(^CTPCP(CTPCPRowId1,3)),"^",24)  //更新人
		s:CTPCPDateActiveFrom'="" CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveFrom) //转换日期格式
		s:CTPCPDateActiveTo'="" CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveTo)
		s:CTPCPUpdateDate'="" CTPCPUpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPUpdateDate) //转换日期格式
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CareProv",CTPCPRowId1)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		//d OutputRow
		w "{""data"":["
		w "{""CTPCPRowId1"":"""_CTPCPRowId1_""",""CTPCPCode"":"""_CTPCPCode_""",""CTPCPDesc"":"""_CTPCPDesc_""",""CTPCPId"":"""_CTPCPId_""",""CTPCPOtherName"":"""_CTPCPOtherName_""",""CTPCPCarPrvTpDR"":"""_CTPCPCarPrvTpDR_""",""CTPCPSpecDR"":"""_CTPCPSpecDR_""",""CTPCPUnit"":"""_CTPCPUnit_""",""CTPCPActiveFlag"":"""_CTPCPActiveFlag_""",""CTPCPSpecialistYN"":"""_CTPCPSpecialistYN_""",""CTPCPSurgeon"":"""_CTPCPSurgeon_""",""CTPCPHICApproved"":"""_CTPCPHICApproved_""",""CTPCPAnaesthetist"":"""_CTPCPAnaesthetist_""",""CTPCPDateActiveFrom"":"""_CTPCPDateActiveFrom_""",""CTPCPDateActiveTo"":"""_CTPCPDateActiveTo_""",""CTPCPUpdateDate"":"""_CTPCPUpdateDate_""",""CTPCPUpdateUserDR"":"""_CTPCPUpdateUserDR_""",""CTPCPMentalFlag"":"""_CTPCPMentalFlag_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}" 
 		w "],""total"":""1"",""success"":""true""}"
	}
	else
	{
		s AuStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
		s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
		s AuCTPCPPrvTpDRFlag=0
		if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1 
		s AuCTPCPSpecDRFlag=0
		if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1 
		
		
		s:Code'="" Code=$ZCONVERT(Code,"U")
		s:Desc'="" Desc=$ZCONVERT(Desc,"U")
		s:query'="" query=$ZCONVERT(query,"U")
		
		k TMPCTPCP
		
		if sort="" s sort="CTPCPRowId1"
		
		//真分页计数
		s total=0
	    s start=start+1
	    
		s CTPCPRowId1=0
		for  
		{				
			s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:CTPCPRowId1=""
			
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,CTPCPRowId1,Hospital)
	  		continue:showflag="N"
			
			s strRowId = "{ID:"_CTPCPRowId1_"}"
			
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
			s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
			s strCTPCPPrvTpDRRowId = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strCTPCPSpecDRRowId = "{ID:"_CTPCPSpecDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&(((AuCTPCPPrvTpDRStr[strCTPCPPrvTpDRRowId)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strCTPCPSpecDRRowId)||(AuCTPCPSpecDRFlag=1))) ;用来筛选授权数据
			{	
				if '((CTPCPCarPrvTpDR=CarPrvTpDR)||(CarPrvTpDR="")) continue
				
				s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //代码
				s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
				s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,3)),"^",28)  //别名
				s CTCPTInternalType=""
				s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
				s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				s CTPCPHICApproved=$p($g(^CTPCP(CTPCPRowId1,3)),"^",31) 		//毒麻处方权
				if (Desc'="")
		        {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CareProv",CTPCPRowId1,CTPCPDesc,Desc)
		        }
			   	else
		        {
		         	s AliasFlag= 1    //((CTPCPDesc1[Desc)||(PINYIN[Desc)||(ALIASText1[Desc))
		        } 
				
				i '(CTCPTInternalType[InternalType) continue
				i '(CTPCPActiveFlag[ActiveFlag) continue
				i '($ZCONVERT(CTPCPCode,"U")[Code) continue
				i '(CTPCPHICApproved[HICApprovedFlag) continue
				i ((AliasFlag=1)||($ZCONVERT(CTPCPOtherName,"U")[Desc))||(($ZCONVERT(CTPCPDesc,"U")[query)&&(query'=""))
				{
					s sortvalue=CTPCPRowId1
					if (sort="CTPCPCode")
					{
						s sortvalue="S"_$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)
						s sortvalue=$zcvt(sortvalue,"U")
					}
					
					s total=total+1
					if (total<start) continue
					if ((total<(start+limit)))
					{
						s TMPCTPCP(sort,sortvalue,CTPCPRowId1)=""						
					}
				}
			}
		}
		
		s CurrentCount=0
		w "{""data"":["
		
		s sortvalue=0,sdir=1   ///ASC,正序
		if (dir="DESC")   //倒序
		{
			s sortvalue="",sdir=-1
		}
		for  
		{			
			s sortvalue=$o(TMPCTPCP(sort,sortvalue),sdir) q:sortvalue=""
			s CTPCPRowId1=0
			if (dir="DESC") s CTPCPRowId1=""
			for 
			{
				s CTPCPRowId1=$o(TMPCTPCP(sort,sortvalue,CTPCPRowId1),sdir) q:(CTPCPRowId1="")
				s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //代码
				s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
				s CTPCPId=$p($g(^CTPCP(CTPCPRowId1,1)),"^",3)         //标识码
				s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,3)),"^",28)  //别名
				;s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,1)),"^",7)  //拼音检索码
				s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
				s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
				s CTCPTInternalType=""
				s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
				s:CTPCPCarPrvTpDR'="" CTPCPCarPrvTpDR=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //人员类型
				s:CTPCPSpecDR'="" CTPCPSpecDR=$p($g(^CT("SPC",CTPCPSpecDR)),"^",2)  //专长描述
				s CTPCPUnit=$p($g(^CTPCP(CTPCPRowId1,2)),"^",8)      //医生资格号
				s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				s CTPCPSpecialistYN=$p($g(^CTPCP(CTPCPRowId1,1)),"^",16)      //专家
				s CTPCPSurgeon=$p($g(^CTPCP(CTPCPRowId1,2)),"^",18)           //外科医生
				s CTPCPHICApproved=$p($g(^CTPCP(CTPCPRowId1,3)),"^",31) 		//毒麻处方权
				s CTPCPAnaesthetist=$p($g(^CTPCP(CTPCPRowId1,2)),"^",19) 		//麻醉师
				s CTPCPMentalFlag=$p($g(^CTPCP(CTPCPRowId1,3)),"^",33) 		//精神类药物处方权
				s CTPCPDateActiveFrom=$p($g(^CTPCP(CTPCPRowId1,2)),"^",14)    //开始日期
				s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //结束日期
				s CTPCPUpdateDate=$p($g(^CTPCP(CTPCPRowId1,3)),"^",22)    //更新日期
				s CTPCPUpdateUserDR=$p($g(^CTPCP(CTPCPRowId1,3)),"^",24)  //更新人
				s:CTPCPDateActiveFrom'="" CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveFrom) //转换日期格式
				s:CTPCPDateActiveTo'="" CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveTo)
				s:CTPCPUpdateDate'="" CTPCPUpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPUpdateDate) //转换日期格式
				
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CareProv",CTPCPRowId1)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            	//d OutputRow
            	if CurrentCount'=0 w ","
            	s CurrentCount=CurrentCount+1
            	w "{""CTPCPRowId1"":"""_CTPCPRowId1_""",""CTPCPCode"":"""_CTPCPCode_""",""CTPCPDesc"":"""_CTPCPDesc_""",""CTPCPId"":"""_CTPCPId_""",""CTPCPOtherName"":"""_CTPCPOtherName_""",""CTPCPCarPrvTpDR"":"""_CTPCPCarPrvTpDR_""",""CTPCPSpecDR"":"""_CTPCPSpecDR_""",""CTPCPUnit"":"""_CTPCPUnit_""",""CTPCPActiveFlag"":"""_CTPCPActiveFlag_""",""CTPCPSpecialistYN"":"""_CTPCPSpecialistYN_""",""CTPCPSurgeon"":"""_CTPCPSurgeon_""",""CTPCPHICApproved"":"""_CTPCPHICApproved_""",""CTPCPAnaesthetist"":"""_CTPCPAnaesthetist_""",""CTPCPDateActiveFrom"":"""_CTPCPDateActiveFrom_""",""CTPCPDateActiveTo"":"""_CTPCPDateActiveTo_""",""CTPCPUpdateDate"":"""_CTPCPUpdateDate_""",""CTPCPUpdateUserDR"":"""_CTPCPUpdateUserDR_""",""CTPCPMentalFlag"":"""_CTPCPMentalFlag_""",""BDPInternalCode"":"""_BDPInternalCode_""",""BDPInternalDesc"":"""_BDPInternalDesc_""",""BDPHospNationalCode"":"""_BDPHospNationalCode_""",""BDPHospNationalDesc"":"""_BDPHospNationalDesc_"""}"
			}
		}
		w "],""total"":"""_total_""",""success"":""true""}"
	}
	q ""
}

/// Creator：蔡昊哲
/// CreatDate: 2013-3-1
/// Description：查询医护人员的内容
/// Table：User.CTCareProv
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProv","GetList","","","","","","","","","","","")
Query GetList(RowId1, Code, Desc, CarPrvTpDR, ActiveFlag, HICApprovedFlag, InternalType, Hospital, query, sort, dir) As %Query(ROWSPEC = "CTPCPRowId1,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPOtherName,CTPCPCarPrvTpDR,CTPCPSpecDR,CTPCPUnit,CTPCPActiveFlag,CTPCPSpecialistYN,CTPCPSurgeon,CTPCPHICApproved,CTPCPAnaesthetist,CTPCPDateActiveFrom,CTPCPDateActiveTo,CTPCPUpdateDate,CTPCPUpdateUserDR,CTPCPMentalFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RowId1, Code, Desc, CarPrvTpDR, ActiveFlag, HICApprovedFlag, InternalType, Hospital, query, sort, dir) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	
	if (RowId1'="") //根据rowid返回该条记录
	{
		s CTPCPRowId1=RowId1
		s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //工号
		s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
		s CTPCPId=$p($g(^CTPCP(CTPCPRowId1,1)),"^",3)         //标识码
		s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,3)),"^",28)  //别名
		;s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,1)),"^",7)  //拼音检索码
		s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
		s CTCPTInternalType=""
		s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
		s:CTPCPCarPrvTpDR'="" CTPCPCarPrvTpDR=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //人员类型
		s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
		s:CTPCPSpecDR'="" CTPCPSpecDR=$p($g(^CT("SPC",CTPCPSpecDR)),"^",2)  //专长描述
		s CTPCPUnit=$p($g(^CTPCP(CTPCPRowId1,2)),"^",8)      //医生资格号
		s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
		s CTPCPSpecialistYN=$p($g(^CTPCP(CTPCPRowId1,1)),"^",16)      //专家
		s CTPCPSurgeon=$p($g(^CTPCP(CTPCPRowId1,2)),"^",18)           //外科医生
		s CTPCPHICApproved=$p($g(^CTPCP(CTPCPRowId1,3)),"^",31) 		//毒麻处方权
		s CTPCPAnaesthetist=$p($g(^CTPCP(CTPCPRowId1,2)),"^",19) 		//麻醉师
		s CTPCPMentalFlag=$p($g(^CTPCP(CTPCPRowId1,3)),"^",33) 		//精神类药物处方权
		s CTPCPDateActiveFrom=$p($g(^CTPCP(CTPCPRowId1,2)),"^",14)    //激活时间
		s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //截止时间
		s CTPCPUpdateDate=$p($g(^CTPCP(CTPCPRowId1,3)),"^",22)    //更新日期
		s CTPCPUpdateUserDR=$p($g(^CTPCP(CTPCPRowId1,3)),"^",24)  //更新人
		s:CTPCPDateActiveFrom'="" CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveFrom) //转换日期格式
		s:CTPCPDateActiveTo'="" CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveTo)
		s:CTPCPUpdateDate'="" CTPCPUpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPUpdateDate) //转换日期格式
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CareProv",CTPCPRowId1)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
		d OutputRow
	}
	else
	{
		///医院级授权，2015-1-20
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s AuStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
		s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
		s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
		s AuCTPCPPrvTpDRFlag=0
		if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1 
		s AuCTPCPSpecDRFlag=0
		if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1 
		
		
		s:Code'="" Code=$ZCONVERT(Code,"U")
		s:Desc'="" Desc=$ZCONVERT(Desc,"U")
		s:query'="" query=$ZCONVERT(query,"U")
		s:Hospital'="" Hospital = "["_Hospital_"]"
		
		k TMPCTPCP
		
		if sort="" s sort="CTPCPRowId1"
		s CTPCPRowId1=0
		for  
		{				
			s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:CTPCPRowId1=""
			
			s HOSPChildsub=0,AuHospFlag=0
			s SSUSRRowID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId1,0))
			IF SSUSRRowID'=""
			{
				s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowID)),"^",98)      //医院DR
				s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
				i (AuHospStr[strHospitalID)
				{
					s AuHospFlag=1
				}
			}
			s HospitalDRStr=""
			s strRowId = "{ID:"_CTPCPRowId1_"}"
			for
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
				s CTHospitalDR=$g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub))
				s HospitalDRStr=HospitalDRStr_"^["_CTHospitalDR_"]"
				s strHospRowId="{ID:"_CTHospitalDR_"}"
				if (AuHospStr[strHospRowId) s AuHospFlag=1
			}
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
			s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
			s strCTPCPPrvTpDRRowId = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strCTPCPSpecDRRowId = "{ID:"_CTPCPSpecDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuHospFlag=1)||(AuHospStr=1)||((AuHospStr="off"))&&((AuCTPCPPrvTpDRStr[strCTPCPPrvTpDRRowId)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strCTPCPSpecDRRowId)||(AuCTPCPSpecDRFlag=1))) ;用来筛选授权数据
			{	
				if '((CTPCPCarPrvTpDR=CarPrvTpDR)||(CarPrvTpDR="")) continue
				
				s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //代码
				s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
				s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,3)),"^",28)  //别名
				s CTCPTInternalType=""
				s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
				s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				s CTPCPHICApproved=$p($g(^CTPCP(CTPCPRowId1,3)),"^",31) 		//毒麻处方权
				if (Desc'="")
		        {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CareProv",CTPCPRowId1,CTPCPDesc,Desc)
		        }
			   	else
		        {
		         	s AliasFlag= 1    //((CTPCPDesc1[Desc)||(PINYIN[Desc)||(ALIASText1[Desc))
		        } 
				
				i '(CTCPTInternalType[InternalType) continue
				i '(CTPCPActiveFlag[ActiveFlag) continue
				i '(HospitalDRStr[Hospital) continue
				i '($ZCONVERT(CTPCPCode,"U")[Code) continue
				i '(CTPCPHICApproved[HICApprovedFlag) continue
				i ((AliasFlag=1)||($ZCONVERT(CTPCPOtherName,"U")[Desc))||(($ZCONVERT(CTPCPDesc,"U")[query)&&(query'=""))
				{
					
					s sortvalue=CTPCPRowId1
					if (sort="CTPCPCode")
					{
						s sortvalue="S"_$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)
						s sortvalue=$zcvt(sortvalue,"U")
					}
					
					s TMPCTPCP(sort,sortvalue,CTPCPRowId1)=""
				}
				
			}
		}
		
		s sortvalue=0,sdir=1   ///ASC,正序
		if (dir="DESC")   //倒序
		{
			s sortvalue="",sdir=-1
		}
		for  
		{			
			s sortvalue=$o(TMPCTPCP(sort,sortvalue),sdir) q:sortvalue=""
			s CTPCPRowId1=0
			if (dir="DESC") s CTPCPRowId1=""
			for 
			{
				s CTPCPRowId1=$o(TMPCTPCP(sort,sortvalue,CTPCPRowId1),sdir) q:(CTPCPRowId1="")
				s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //代码
				s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
				s CTPCPId=$p($g(^CTPCP(CTPCPRowId1,1)),"^",3)         //标识码
				s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,3)),"^",28)  //别名
				;s CTPCPOtherName=$p($g(^CTPCP(CTPCPRowId1,1)),"^",7)  //拼音检索码
				s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
				s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
				s CTCPTInternalType=""
				s:CTPCPCarPrvTpDR'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
				s:CTPCPCarPrvTpDR'="" CTPCPCarPrvTpDR=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",2) //人员类型
				s:CTPCPSpecDR'="" CTPCPSpecDR=$p($g(^CT("SPC",CTPCPSpecDR)),"^",2)  //专长描述
				s CTPCPUnit=$p($g(^CTPCP(CTPCPRowId1,2)),"^",8)      //医生资格号
				s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				s CTPCPSpecialistYN=$p($g(^CTPCP(CTPCPRowId1,1)),"^",16)      //专家
				s CTPCPSurgeon=$p($g(^CTPCP(CTPCPRowId1,2)),"^",18)           //外科医生
				s CTPCPHICApproved=$p($g(^CTPCP(CTPCPRowId1,3)),"^",31) 		//毒麻处方权
				s CTPCPAnaesthetist=$p($g(^CTPCP(CTPCPRowId1,2)),"^",19) 		//麻醉师
				s CTPCPMentalFlag=$p($g(^CTPCP(CTPCPRowId1,3)),"^",33) 		//精神类药物处方权
				s CTPCPDateActiveFrom=$p($g(^CTPCP(CTPCPRowId1,2)),"^",14)    //开始日期
				s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //结束日期
				s CTPCPUpdateDate=$p($g(^CTPCP(CTPCPRowId1,3)),"^",22)    //更新日期
				s CTPCPUpdateUserDR=$p($g(^CTPCP(CTPCPRowId1,3)),"^",24)  //更新人
				s:CTPCPDateActiveFrom'="" CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveFrom) //转换日期格式
				s:CTPCPDateActiveTo'="" CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPDateActiveTo)
				s:CTPCPUpdateDate'="" CTPCPUpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPCPUpdateDate) //转换日期格式
				
				s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CareProv",CTPCPRowId1)
            	s BDPInternalCode =$p($g(resultStr),"^",1)       
            	s BDPInternalDesc = $p($g(resultStr),"^",2)  
            	s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            	s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            	d OutputRow
			}
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(CTPCPRowId1,CTPCPCode,CTPCPDesc,CTPCPId,CTPCPOtherName,CTPCPCarPrvTpDR,CTPCPSpecDR,CTPCPUnit,CTPCPActiveFlag,CTPCPSpecialistYN,CTPCPSurgeon,CTPCPHICApproved,CTPCPAnaesthetist,CTPCPDateActiveFrom,CTPCPDateActiveTo,CTPCPUpdateDate,CTPCPUpdateUserDR,CTPCPMentalFlag,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2013-07-16
/// Description：根据条件获取医护人员
/// Table：User.CTCareProv
/// Input：无
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProv","GetDataForCmb1")
Query GetDataForCmb1(Desc, query, rowid) As %Query(ROWSPEC = "CTPCPRowId1,CTPCPDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, Desc, query, rowid) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	

	
		
	//s:Code'="" Code=$ZCONVERT(Code,"U")
	s:Desc'="" Desc=$ZCONVERT(Desc,"U")
	s:query'="" query=$ZCONVERT(query,"U")
	if (rowid'="") //根据rowid返回该条记录
	{
		s CTPCPRowId1=rowid
		s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)
		s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
		s CTPCPDesc=CTPCPCode_"-"_CTPCPDesc
		d OutputRowCmb1
	}	
	else
	{
		s AuStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession()
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
		s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
		s AuCTPCPPrvTpDRFlag=0
		if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1 
		s AuCTPCPSpecDRFlag=0
		if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1 
		
		s CTPCPRowId1=0
		for  
		{				
			s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:CTPCPRowId1=""
			s HOSPChildsub=0,AuHospFlag=0
			s SSUSRRowID=$O(^SSU("SSUSR",0,"CTPCP",CTPCPRowId1,0))
			IF SSUSRRowID'=""
			{
				s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowID)),"^",98)      //医院DR
				s strHospitalID = "{ID:"_SSUSRHospitalDR_"}"
				i (AuHospStr[strHospitalID)
				{
					s AuHospFlag=1
				}
			}
			s strRowId = "{ID:"_CTPCPRowId1_"}"
			for
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
				s CTHospitalDR=$g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub))
				s strHospRowId="{ID:"_CTHospitalDR_"}"
				if (AuHospStr[strHospRowId) s AuHospFlag=1
			}		
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
			s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
			s strCTPCPPrvTpDRRowId = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strCTPCPSpecDRRowId = "{ID:"_CTPCPSpecDR_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuHospFlag=1)||(AuHospStr=1)||(AuHospStr="off"))&&((AuCTPCPPrvTpDRStr[strCTPCPPrvTpDRRowId)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strCTPCPSpecDRRowId)||(AuCTPCPSpecDRFlag=1)) ;用来筛选授权数据
			{
				s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //工号
				s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
				s CTPCPDesc=CTPCPCode_"-"_CTPCPDesc
				s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				s CTPCPDateActiveFrom=$p($g(^CTPCP(CTPCPRowId1,2)),"^",14)     //开始日期
				s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //结束日期
				continue:CTPCPActiveFlag="N"
				continue:(CTPCPDateActiveFrom'="")&&(CTPCPDateActiveFrom>+$h)
				continue:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<+$h)
				/*
				s ALIASText1=""
				s AliasRowId=0
				for{
					s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_CareProv",CTPCPRowId1,AliasRowId))
					q:AliasRowId=""
  					S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
					s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
				}*/
				if (Desc'="")
		       {
			        ;需要对描述或者别名进行检索      
			        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CareProv",CTPCPRowId1,CTPCPDesc,Desc)
		       }
			   	else
		       {
		         	s AliasFlag= 1   
		       } 
				i (($ZCONVERT(CTPCPCode,"U")[Desc)||(AliasFlag=1))&(($ZCONVERT(CTPCPCode,"U")[query)||($ZCONVERT(CTPCPDesc,"U")[query))
				/*(CTPCPDesc1[Desc)||(ALIASText1[Desc)*/
				{
					
					d OutputRowCmb1
				}
			}
		}
	}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb1
    set Data=$lb(CTPCPRowId1,CTPCPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2013-07-16
/// Description：根据条件获取医护人员  人员类型
/// Table：User.CTCareProv
/// Input：无
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProv","GetDataForCmb2","","","E")
Query GetDataForCmb2(rowid, Desc, type, hospid As %String = "") As %Query(ROWSPEC = "CTPCPRowId1,CTPCPDesc")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid, Desc, type, hospid As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if rowid'=""
	{
		s CTPCPRowId1=rowid
		s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //工号
		s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
		s CTPCPDesc=CTPCPCode_"-"_CTPCPDesc
		d OutputRowCmb2
		
		
	}
	else
	{
		s AuStr=##class(web.DHCBL.Authorize.CTCareProv).DHCGetDataByDefaultSession()
		s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
		;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
		;假设未授权情况下默认全部显示数据
		s AuFlag=0
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		s AuCTPCPPrvTpDRStr=##class(web.DHCBL.Authorize.CTCarPrvTp).DHCGetDataByDefaultSession() //医护人员类型
		s AuCTPCPSpecDRStr=##class(web.DHCBL.Authorize.CTSpec).DHCGetDataByDefaultSession() //医生专长
		s AuCTPCPPrvTpDRFlag=0
		if (AuCTPCPPrvTpDRStr="")||(AuCTPCPPrvTpDRStr["limited:0") s AuCTPCPPrvTpDRFlag=1 
		s AuCTPCPSpecDRFlag=0
		if (AuCTPCPSpecDRStr="")||(AuCTPCPSpecDRStr["limited:0") s AuCTPCPSpecDRFlag=1 
		
		s:Desc'="" Desc=$ZCONVERT(Desc,"U")
		s CTPCPRowId1=0
		for
		{
			s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) q:CTPCPRowId1=""
			s CTPCPCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //工号
			s CTPCPDesc=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
			
			//20200520 likefan
			if (hospid'="")	
			{
				s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,CTPCPRowId1,hospid)
  				continue:showflag="N"
			}
			
			s HOSPChildsub=0,AuHospFlag=0
			s strRowId = "{ID:"_CTPCPRowId1_"}"
			for
			{
				s HOSPChildsub=$o(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub)) q:(HOSPChildsub="")||(AuHospFlag=1)
				s CTHospitalDR=$g(^CTPCP(CTPCPRowId1,"HOSP",HOSPChildsub))
				s strHospRowId="{ID:"_CTHospitalDR_"}"
				if (AuHospStr[strHospRowId) s AuHospFlag=1
			}	
			s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTPCPDesc)		//20200629 lkf
			s CTPCPDesc=CTPCPCode_"-"_CTPCPDesc
			s CTPCPCode1=$ZCONVERT(CTPCPCode,"U")
			s CTPCPDesc1=$ZCONVERT(CTPCPDesc,"U")
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
			s CTPCPSpecDR=$p($g(^CTPCP(CTPCPRowId1,1)),"^",10)      //专长
			s strCTPCPPrvTpDRRowId = "{ID:"_CTPCPCarPrvTpDR_"}"
			s strCTPCPSpecDRRowId = "{ID:"_CTPCPSpecDR_"}"
			s strRowId = "{ID:"_CTPCPRowId1_"}"
			if ((AuStr[strRowId)||(AuFlag=1))&&((AuHospFlag=1)||(AuHospStr=1)||(AuHospStr="off"))&&((AuCTPCPPrvTpDRStr[strCTPCPPrvTpDRRowId)||(AuCTPCPPrvTpDRFlag=1))&&((AuCTPCPSpecDRStr[strCTPCPSpecDRRowId)||(AuCTPCPSpecDRFlag=1)) ;用来筛选授权数据
			{
				s CTPCPCarPrvTpDR1=$p($g(^CTPCP(CTPCPRowId1,1)),"^",4)    //人员类型ID
				s CTCPTDesc=""
				s:CTPCPCarPrvTpDR1'="" CTCPTDesc=$p($g(^CT("CPT",CTPCPCarPrvTpDR1)),"^",2) //人员类型
				s:CTPCPCarPrvTpDR1'="" CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR1)),"^",4)
			
				s CTPCPActiveFlag=$p($g(^CTPCP(CTPCPRowId1,1)),"^",9)      //是否激活
				s CTPCPDateActiveTo=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //结束日期
				continue:CTPCPActiveFlag="N"
				continue:(CTPCPDateActiveTo'="")&&(CTPCPDateActiveTo<+$h)
				i ((CTPCPDesc1[Desc)||(PINYINCODE[Desc))&(((CTCPTInternalType="NURSE")&(type="W"))||(type'="W"))  //只有病区可以选择护士
				{
					d OutputRowCmb2
				}
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb2
    set Data=$lb(CTPCPRowId1,CTPCPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2013-05-20
/// Description：按医护人员级别详细分布图
/// Table：User.CTCareProv
/// Input：无
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProv","GetListForChart")
Query GetListForChart() As %Query(ROWSPEC = "CareCount,CTCPTDesc")
{
}

ClassMethod GetListForChartExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	

	s CareCount=0
	s CTPCPRowId1=0
	S CTCPTRowId=0
	f  s CTCPTRowId=$o(^CT("CPT",CTCPTRowId)) q:CTCPTRowId=""  d
	.s CareCount=0
	.s CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
	.f  S CTPCPRowId1=$o(^CTPCP(0,"CareProvType",CTCPTRowId,CTPCPRowId1)) q:CTPCPRowId1=""  d	
	..s CareCount=CareCount+1
	.d OutputRowChart
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowChart
    set Data=$lb(CareCount,CTCPTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListForChartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListForChartExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListForChartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListForChartExecute ]
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

/// Creator：蔡昊哲
/// CreatDate: 2013-05-20
/// Description：按医护人员大类分布图
/// Table：User.CTCareProv
/// Input：无
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCareProv","GetListForChartDetail")
Query GetListForChartDetail() As %Query(ROWSPEC = "CareCount,CTCPTInternalType")
{
}

ClassMethod GetListForChartDetailExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s CareCount=0
	s CareCountD=0
	s CareCountN=0
	s CareCountT=0
	s CareCountP=0
	s CareCountO=0
	s CTPCPRowId1=0
	S CTCPTRowId=0
	f  s CTCPTRowId=$o(^CT("CPT",CTCPTRowId)) q:CTCPTRowId=""  d
	.;s CareCount=0
	.s CTCPTDesc=$p($g(^CT("CPT",CTCPTRowId)),"^",2)
	.s CTCPTInternalType=$p($g(^CT("CPT",CTCPTRowId)),"^",4)
	.f  S CTPCPRowId1=$o(^CTPCP(0,"CareProvType",CTCPTRowId,CTPCPRowId1)) q:CTPCPRowId1=""  d	
	..i CTCPTInternalType="DOCTOR"  d
	...s CareCountD=CareCountD+1
	..i CTCPTInternalType="NURSE"  d
	...s CareCountN=CareCountN+1
	..i CTCPTInternalType="Technician"  d
	...s CareCountT=CareCountT+1
	..i CTCPTInternalType="Pharmacist"  d
	...s CareCountP=CareCountP+1
	..i ((CTCPTInternalType="")||(CTCPTInternalType="Other"))  d
	...s CareCountO=CareCountO+1
	
	s CareCount=CareCountD
	s CTCPTInternalType="DOCTOR"
	d OutputRowChartDetail
	
	s CareCount=CareCountN
	s CTCPTInternalType="NURSE"
	d OutputRowChartDetail
	
	s CareCount=CareCountT
	s CTCPTInternalType="Technician"
	d OutputRowChartDetail
	
	s CareCount=CareCountP
	s CTCPTInternalType="Pharmacist"
	d OutputRowChartDetail

	s CareCount=CareCountO
	s CTCPTInternalType="Other"
	d OutputRowChartDetail
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowChartDetail
    set Data=$lb(CareCount,CTCPTInternalType)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListForChartDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListForChartDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListForChartDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListForChartDetailExecute ]
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

/// Creator：高姗姗
/// CreatDate: 2015-4-1
/// Description：用户关联医护人员中获取医护人员的记录
/// Table：User.CTCarPrvTp
/// Input：Id(User.CTCareProv的rowid)
ClassMethod GetData(code As %String) As %String
{
	;w ##class(web.DHCBL.CT.CTCareProv).GetData("365")
	s str=""	
	s code=$$ALPHAUP^SSUTIL4(code)
	if (code'=""){
		s RowId1 = $o(^CTPCP(0,"Code",code,0))
		if (RowId1'="")
		{
			s eobj = ##class(web.Entity.CT.CTCareProv).%New()
			s pobj = ##class(User.CTCareProv).%OpenId(RowId1)
			s eobj.CTPCPRowId1 = RowId1
			s eobj.CTPCPCode = pobj.CTPCPCode
			s eobj.CTPCPOtherName = pobj.CTPCPOtherName
			s eobj.CTPCPUnit = pobj.CTPCPUnit
			s:pobj.CTPCPCarPrvTpDR'="" eobj.CTPCPCarPrvTpDR = pobj.CTPCPCarPrvTpDR.%Id()
			s eobj.CTPCPSurgeon = pobj.CTPCPSurgeon
			s:pobj.CTPCPSpecDR'="" eobj.CTPCPSpecDR = pobj.CTPCPSpecDR.%Id()
			s eobj.CTPCPActiveFlag = pobj.CTPCPActiveFlag
			s eobj.CTPCPDesc = pobj.CTPCPDesc
			s eobj.CTPCPId = pobj.CTPCPId
			s eobj.CTPCPTextOne = pobj.CTPCPTextOne
			s eobj.CTPCPTextTwo = pobj.CTPCPTextTwo
			s eobj.CTPCPHICApproved = pobj.CTPCPHICApproved	
			s eobj.CTPCPAnaesthetist = pobj.CTPCPAnaesthetist	
			s eobj.CTPCPSpecialistYN = pobj.CTPCPSpecialistYN
			/*s eobj.CTPCPTelO=pobj.CTPCPTelO  
			s eobj.CTPCPTelH=pobj.CTPCPTelH
			s eobj.CTPCPTelOExt=pobj.CTPCPTelOExt
			s eobj.CTPCPMobilePhone=pobj.CTPCPMobilePhone
			s eobj.CTPCPEmail=pobj.CTPCPEmail
			s eobj.CTPCPFax=pobj.CTPCPFax*/
			
			s:pobj.CTPCPTitleDR'="" eobj.CTPCPTitleDR = pobj.CTPCPTitleDR.%Id()
			s eobj.CTPCPMentalFlag = pobj.CTPCPMentalFlag  //精神类药物处方权 
			;s:pobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo = $zd(pobj.CTPCPDateActiveTo,1)
			;s:pobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom = $zd(pobj.CTPCPDateActiveFrom,1)
			s:pobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPCPDateActiveTo)
			s:pobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPCPDateActiveFrom)

			d pobj.%Close()	
			k pobj	

			s:eobj.CTPCPHICApproved="Y" eobj.CTPCPHICApproved="true"
			s:eobj.CTPCPSurgeon="Y" eobj.CTPCPSurgeon="true"
			s:eobj.CTPCPActiveFlag="Y" eobj.CTPCPActiveFlag="true"	
			s:eobj.CTPCPAnaesthetist="Y" eobj.CTPCPAnaesthetist="true"
			s:eobj.CTPCPSpecialistYN="Y" eobj.CTPCPSpecialistYN="true"	
			s:eobj.CTPCPMentalFlag="Y" eobj.CTPCPMentalFlag="true"		
			s str = eobj.JsonS()
		}else{
			s str="{""CTPCPDesc"":""""}"	
		}
	}
	else
	{
		s str="{""CTPCPDesc"":""""}"		 
	}	
	q str
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-25
/// Description：获取修改时的记录
/// Table：User.CTCarPrvTp
/// Input：Id(User.CTCareProv的rowid)
/// w ##class(web.DHCBL.CT.CTCareProv).OpenData(1881)
ClassMethod OpenData(RowId1 As %String) As %String
{
	;d ##(web.DHCBL.CT.CTCareProv).OpenData("")
	
	s str=""	
	s eobj = ##class(web.Entity.CT.CTCareProv).%New()
	s pobj = ##class(User.CTCareProv).%OpenId(RowId1)
	s eobj.CTPCPRowId1 = RowId1
	;q eobj.CTPCPRowId1
	s eobj.CTPCPCode = pobj.CTPCPCode
	s eobj.CTPCPOtherName = pobj.CTPCPOtherName
	s eobj.CTPCPUnit = pobj.CTPCPUnit
	s:pobj.CTPCPCarPrvTpDR'="" eobj.CTPCPCarPrvTpDR = pobj.CTPCPCarPrvTpDR.%Id()
	s eobj.CTPCPSurgeon = pobj.CTPCPSurgeon
	s:pobj.CTPCPSpecDR'="" eobj.CTPCPSpecDR = pobj.CTPCPSpecDR.%Id()
	s eobj.CTPCPActiveFlag = pobj.CTPCPActiveFlag
	s eobj.CTPCPDesc = pobj.CTPCPDesc
	s eobj.CTPCPId = pobj.CTPCPId
	s eobj.CTPCPTextOne = pobj.CTPCPTextOne
	s eobj.CTPCPTextTwo = pobj.CTPCPTextTwo
	s eobj.CTPCPHICApproved = pobj.CTPCPHICApproved	
	s eobj.CTPCPAnaesthetist = pobj.CTPCPAnaesthetist	
	s eobj.CTPCPSpecialistYN = pobj.CTPCPSpecialistYN
	/*s eobj.CTPCPTelO=pobj.CTPCPTelO
	s eobj.CTPCPTelH=pobj.CTPCPTelH
	s eobj.CTPCPTelOExt=pobj.CTPCPTelOExt
	s eobj.CTPCPMobilePhone=pobj.CTPCPMobilePhone
	s eobj.CTPCPEmail=pobj.CTPCPEmail
	s eobj.CTPCPFax=pobj.CTPCPFax*/
	
	s:pobj.CTPCPTitleDR'="" eobj.CTPCPTitleDR = pobj.CTPCPTitleDR.%Id()
	s eobj.CTPCPMentalFlag = pobj.CTPCPMentalFlag  //精神类药物处方权 ybq 2018-10-22
	
	;s:pobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo = $zd(pobj.CTPCPDateActiveTo,1)
	;s:pobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom = $zd(pobj.CTPCPDateActiveFrom,1)
	s:pobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPCPDateActiveTo)
	s:pobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CTPCPDateActiveFrom)

	
	d pobj.%Close()	
	k pobj	
	
	s:eobj.CTPCPHICApproved="Y" eobj.CTPCPHICApproved="true"
	s:eobj.CTPCPSurgeon="Y" eobj.CTPCPSurgeon="true"
	s:eobj.CTPCPActiveFlag="Y" eobj.CTPCPActiveFlag="true"	
	s:eobj.CTPCPAnaesthetist="Y" eobj.CTPCPAnaesthetist="true"
	s:eobj.CTPCPSpecialistYN="Y" eobj.CTPCPSpecialistYN="true"	
	s:eobj.CTPCPMentalFlag="Y" eobj.CTPCPMentalFlag="true"		

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2012-12-25    
/// w ##class(web.DHCBL.CT.CTCareProv).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	
	s flag=0
    
 	s idc=0
    s:$$ALPHAUP^SSUTIL4(code)'="" idc=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(code),0))
    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志
    
	q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-12-25
/// Description：保存修改
/// Table：User.CTCareProv
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
/// Ohter：d ##class(web.DHCBL.CT.CTCareProv).SaveEntity()
/// Last: 2013-7-12 新增科室保存到资源表中
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCareProv) As %String
{
	s result=""
	s:eobj.CTPCPActiveFlag="" eobj.CTPCPActiveFlag="N"
	s:eobj.CTPCPHICApproved="" eobj.CTPCPHICApproved="N"
	s:eobj.CTPCPSpecialistYN="" eobj.CTPCPSpecialistYN="N"
	s:eobj.CTPCPSurgeon="" eobj.CTPCPSurgeon="N"
	s:eobj.CTPCPAnaesthetist="" eobj.CTPCPAnaesthetist="N"
	s:eobj.CTPCPMentalFlag="" eobj.CTPCPMentalFlag="N"
	s eobj.CTPCPUpdateDate = $p($h,",",1)
	s eobj.CTPCPUpdateTime = $p($h,",",2)
	if $d(%session) s eobj.CTPCPUpdateUserDR =$g(%session.Data("LOGON.USERID"))
	;s:eobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom=$zdh(eobj.CTPCPDateActiveFrom,15) 
  	;s:eobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo=$zdh(eobj.CTPCPDateActiveTo,15)     
  	s:eobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPCPDateActiveFrom)
  	s:eobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPCPDateActiveTo)   
	s:eobj.CTPCPDateActiveFrom="" eobj.CTPCPDateActiveFrom=+$h
	if (eobj.CTPCPActiveFlag="N")&&(eobj.CTPCPDateActiveTo="") s eobj.CTPCPDateActiveTo=+$h
	
	s flag=..FormValidate(eobj.CTPCPRowId1,eobj.CTPCPCode)  //调用重复验证
	if (flag=1)
	{
		s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	}
	else
	{
		
		if (eobj.CTPCPRowId1="")
		{	
			s obj=##class(User.CTCareProv).%New()
		}
		else  //修改
		{
 		   	s obj=##class(User.CTCareProv).%OpenId(eobj.CTPCPRowId1)
 		   	
 		   	; bobj创建一个对象，用于记录原始数据
			s bobj=##class(web.Entity.CT.CTCareProv).%New()
			s bobj.CTPCPRowId1 = eobj.CTPCPRowId1
			s bobj.CTPCPDesc = obj.CTPCPDesc
			s bobj.CTPCPCode = obj.CTPCPCode
			s bobj.CTPCPId=obj.CTPCPId
			s bobj.CTPCPOtherName=obj.CTPCPOtherName
			s bobj.CTPCPUnit=obj.CTPCPUnit
			s bobj.CTPCPTextOne = obj.CTPCPTextOne
			s bobj.CTPCPTextTwo = obj.CTPCPTextTwo
			if $IsObject(obj.CTPCPCarPrvTpDR)
			{
				s bobj.CTPCPCarPrvTpDR = obj.CTPCPCarPrvTpDR.%Id() 
			}
			if $IsObject(obj.CTPCPSpecDR)
			{
				s bobj.CTPCPSpecDR = obj.CTPCPSpecDR.%Id()
			}		
			s bobj.CTPCPActiveFlag =obj.CTPCPActiveFlag
			s bobj.CTPCPHICApproved =obj.CTPCPHICApproved
			s bobj.CTPCPSpecialistYN = obj.CTPCPSpecialistYN
			s bobj.CTPCPDateActiveFrom = obj.CTPCPDateActiveFrom
			s bobj.CTPCPDateActiveTo = obj.CTPCPDateActiveTo
			s bobj.CTPCPSurgeon = obj.CTPCPSurgeon
			s bobj.CTPCPAnaesthetist = obj.CTPCPAnaesthetist
			s bobj.CTPCPUpdateDate = obj.CTPCPUpdateDate
			s bobj.CTPCPUpdateTime = obj.CTPCPUpdateTime
			if $IsObject(obj.CTPCPUpdateUserDR)
			{
				s bobj.CTPCPUpdateUserDR = obj.CTPCPUpdateUserDR.%Id()
			}
			/*s bobj.CTPCPTelO = obj.CTPCPTelO
			s bobj.CTPCPTelH = obj.CTPCPTelH
			s bobj.CTPCPTelOExt = obj.CTPCPTelOExt
			s bobj.CTPCPMobilePhone = obj.CTPCPMobilePhone
			s bobj.CTPCPEmail = obj.CTPCPEmail
			s bobj.CTPCPFax = obj.CTPCPFax	*/
			if $IsObject(obj.CTPCPTitleDR)
			{
				s bobj.CTPCPTitleDR = obj.CTPCPTitleDR.%Id()
			}		
			s bobj.CTPCPMentalFlag =obj.CTPCPMentalFlag
		}
		s obj.CTPCPCode = eobj.CTPCPCode
		s obj.CTPCPDesc = eobj.CTPCPDesc
		s obj.CTPCPId = eobj.CTPCPId
		s obj.CTPCPOtherName = eobj.CTPCPOtherName
		s obj.CTPCPUnit = eobj.CTPCPUnit
		s obj.CTPCPTextOne = eobj.CTPCPTextOne
		s obj.CTPCPTextTwo = eobj.CTPCPTextTwo
		d obj.CTPCPCarPrvTpDRSetObjectId(eobj.CTPCPCarPrvTpDR)
		d obj.CTPCPSpecDRSetObjectId(eobj.CTPCPSpecDR)
		s obj.CTPCPActiveFlag =eobj.CTPCPActiveFlag
		s obj.CTPCPHICApproved = eobj.CTPCPHICApproved
		s obj.CTPCPSpecialistYN = eobj.CTPCPSpecialistYN
		s obj.CTPCPSurgeon =eobj.CTPCPSurgeon
		s obj.CTPCPDateActiveFrom = eobj.CTPCPDateActiveFrom
		s obj.CTPCPDateActiveTo = eobj.CTPCPDateActiveTo
		s obj.CTPCPUpdateDate = eobj.CTPCPUpdateDate
		s obj.CTPCPUpdateTime = eobj.CTPCPUpdateTime
		d obj.CTPCPUpdateUserDRSetObjectId(eobj.CTPCPUpdateUserDR)
		s obj.CTPCPAnaesthetist =eobj.CTPCPAnaesthetist
		/*
		s obj.CTPCPTelO = eobj.CTPCPTelO  
		s obj.CTPCPTelH = eobj.CTPCPTelH
		s obj.CTPCPTelOExt = eobj.CTPCPTelOExt
		s obj.CTPCPMobilePhone = eobj.CTPCPMobilePhone
		s obj.CTPCPEmail = eobj.CTPCPEmail
		s obj.CTPCPFax = eobj.CTPCPFax*/
		d obj.CTPCPTitleDRSetObjectId(eobj.CTPCPTitleDR)
		s obj.CTPCPMentalFlag = eobj.CTPCPMentalFlag  //精神类药物处方权
		
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			if (eobj.CTPCPRowId1="")
			{
				
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"A",eobj,"",id)
				
				//医护人员界面保存左上角医院；用户界面保存用户登录科室的医院
				if eobj.LinkHospId'=""
				{
					s hospeobj=##class(web.Entity.CT.CTCareProvHospitals).%New()
					s hospeobj.HOSPRowId=""
					s hospeobj.HOSPHospitalDR=eobj.LinkHospId
					s hospeobj.HOSPParRef=id
					D ##class(web.DHCBL.CT.CTCareProvHospitals).SaveEntity(hospeobj)
				}
			}
			else
			{
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"U",eobj,bobj,id)	
				;医护人员取消激活或者加结束日期
				if ((eobj.CTPCPActiveFlag="N")&&(bobj.CTPCPActiveFlag="Y"))||((eobj.CTPCPDateActiveTo'="")&&(bobj.CTPCPDateActiveTo=""))
				{
					d ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(id,"","Update",eobj.CTPCPDateActiveFrom,eobj.CTPCPDateActiveTo)
				}
				//医护人员重新激活，同时激活指定科室	2021-04-21
				if ((eobj.CTPCPActiveFlag="Y")&&(bobj.CTPCPActiveFlag="N"))||((eobj.CTPCPDateActiveTo="")&&(bobj.CTPCPDateActiveTo'=""))
				{
					d ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(id,"","Active","","")
				}			
				//修改人员姓名时，同步修改RBResource表的描述字段 2020-12-16
				if (eobj.CTPCPDesc'=bobj.CTPCPDesc)
				{
					d ##class(web.DHCBL.CT.CTCareProv).SaveRBDesc(eobj.CTPCPRowId1,eobj.CTPCPDesc)
				}
			}
			s result = "{success:'true',id:'"_id_"'}"         //返回RowId
			
			
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员","web.DHCBL.CT.CTCareProv","SaveEntity",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
	}
	q result
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.CT.CTCareProv).GetRefFlag(1826)
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	if id="" q "0^未被引用可删除！"
    
    if $d(^OEORDi(0,"DocStDate",id)) s myInfo=myInfo_"<医嘱>"   //OE_OrdItem
    i $d(^RB("RES",0,"CTPCP",id)) s myInfo=myInfo_"<资源表--医护人员关联科室>"  ; RBResource
    i $d(^SSU("SSUSR",0,"CTPCP",id)) s myInfo=myInfo_"<用户>"  ; SS_User
    i $d(^CTLOC(0,"CTPCP",id)) s myInfo=myInfo_"<医疗单元关联医护人员>" ;DHCCTLocMedUnitCareProv 		
	i myInfo="" s return="0^未被引用可删除!"
 	else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 	q return
}

/// Creator:蔡昊哲
/// CreatDate:2013-7-12
/// Description:根据id删除医护人员
/// Table:User.CTCareProv
/// Input:id(CTCareProv的CTPCPRowId1) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.CTCareProv).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
	
	s re=##class(web.DHCBL.CT.CTCareProv).GetRefFlag(id)
	s RefFlag=$p(re,"^",1)
	if (RefFlag'=0){
		s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
	}
	else
	{
		
		s eobj = ##class(web.Entity.CT.CTCareProv).%New()
		s pobj = ##class(User.CTCareProv).%OpenId(id)
		s eobj.CTPCPRowId1 = id
		s eobj.CTPCPCode = pobj.CTPCPCode
		s eobj.CTPCPOtherName = pobj.CTPCPOtherName
		s eobj.CTPCPUnit = pobj.CTPCPUnit
		s:pobj.CTPCPCarPrvTpDR'="" eobj.CTPCPCarPrvTpDR = pobj.CTPCPCarPrvTpDR.%Id()
		s eobj.CTPCPSurgeon = pobj.CTPCPSurgeon
		s:pobj.CTPCPSpecDR'="" eobj.CTPCPSpecDR = pobj.CTPCPSpecDR.%Id()
		s eobj.CTPCPActiveFlag = pobj.CTPCPActiveFlag
		s eobj.CTPCPDesc = pobj.CTPCPDesc
		s eobj.CTPCPId = pobj.CTPCPId
		s eobj.CTPCPTextOne = pobj.CTPCPTextOne
		s eobj.CTPCPTextTwo = pobj.CTPCPTextTwo
		s eobj.CTPCPHICApproved = pobj.CTPCPHICApproved	
		s eobj.CTPCPAnaesthetist = pobj.CTPCPAnaesthetist	
		s eobj.CTPCPSpecialistYN = pobj.CTPCPSpecialistYN
		/*s eobj.CTPCPTelO = pobj.CTPCPTelO
		s eobj.CTPCPTelH = pobj.CTPCPTelH
		s eobj.CTPCPTelOExt = pobj.CTPCPTelOExt
		s eobj.CTPCPMobilePhone = pobj.CTPCPMobilePhone
		s eobj.CTPCPEmail = pobj.CTPCPEmail
		s eobj.CTPCPFax = pobj.CTPCPFax*/
		s:pobj.CTPCPTitleDR'="" eobj.CTPCPTitleDR = pobj.CTPCPTitleDR.%Id()
		s eobj.CTPCPMentalFlag = pobj.CTPCPMentalFlag
		Tstart
		s sc=##class(User.CTCareProv).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"D",eobj,"",id)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员","web.DHCBL.CT.CTCareProv","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator：蔡昊哲
/// CreatDate: 2012-7-26
/// Description：根据ID停用医护人员
/// Table：User.CTCareProv
/// Input：Id(User.CTCareProv的rowid)
/// Return：成功返回"{success:'true'和停用ID}"；失败返回"{success:'false'和失败原因}
ClassMethod StopAccount(id) As %String
{
	;w ##class(web.DHCBL.CT.CTCareProv).StopAccount(1895)
	s result=""
	s pobj = ##class(User.CTCareProv).%OpenId(id)

	s eobj = ##class(web.Entity.CT.CTCareProv).%New()
	s eobj.CTPCPRowId1 = id
	s eobj.CTPCPCode = pobj.CTPCPCode
	s eobj.CTPCPOtherName = pobj.CTPCPOtherName
	s eobj.CTPCPUnit = pobj.CTPCPUnit
	s:pobj.CTPCPCarPrvTpDR'="" eobj.CTPCPCarPrvTpDR = pobj.CTPCPCarPrvTpDR.%Id()
	s eobj.CTPCPSurgeon = pobj.CTPCPSurgeon
	s:pobj.CTPCPSpecDR'="" eobj.CTPCPSpecDR = pobj.CTPCPSpecDR.%Id()
	s eobj.CTPCPActiveFlag = "N"
	s eobj.CTPCPDesc = pobj.CTPCPDesc
	s eobj.CTPCPId = pobj.CTPCPId
	s eobj.CTPCPTextOne = pobj.CTPCPTextOne
	s eobj.CTPCPTextTwo = pobj.CTPCPTextTwo
	s eobj.CTPCPHICApproved = pobj.CTPCPHICApproved	
	s eobj.CTPCPAnaesthetist = pobj.CTPCPAnaesthetist	
	s eobj.CTPCPSpecialistYN = pobj.CTPCPSpecialistYN
	s eobj.CTPCPDateActiveFrom=pobj.CTPCPDateActiveFrom
	/*s eobj.CTPCPTelO = pobj.CTPCPTelO
	s eobj.CTPCPTelH = pobj.CTPCPTelH
	s eobj.CTPCPTelOExt = pobj.CTPCPTelOExt
	s eobj.CTPCPMobilePhone = pobj.CTPCPMobilePhone
	s eobj.CTPCPEmail = pobj.CTPCPEmail
	s eobj.CTPCPFax = pobj.CTPCPFax*/
	
	s:pobj.CTPCPTitleDR'="" eobj.CTPCPTitleDR = pobj.CTPCPTitleDR.%Id()
	s eobj.CTPCPUpdateDate = +$h
	s eobj.CTPCPUpdateTime = $p($h,",",2)
	
	s result=##class(web.DHCBL.CT.CTCareProv).SaveEntity(eobj)
	q result
}

/// Creator：蔡昊哲
/// CreatDate: 2013-9-6
/// Description：上传图片(麻醉处方签名图片)
/// Table：User.CTCareProv
/// Input：Id(User.CTCareProv的rowid)
/// Return：
ClassMethod UploadPic(id) As %String
{
}

/// Creator：chenying
/// CreatDate: 2019-06-06
/// Description：医护人员关联维护功能
/// Table：User.RBResource
/// Input：医护人员rowid, 科室rowid,类型（新增数据ADD，还是同步数据SYNC,还是结束数据Update。）,ReferenceId:对应用户rowid或其他登录科室rowid
/// Return：
/// D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(1635,1,"Add",65303,"")
/// D ##class(web.DHCBL.CT.CTCareProv).UpdateRBData(1635,1,"Update",65303,65310)
ClassMethod UpdateRBData(CTPCPDR, CTLOCDR, Type, Date, DateTo, ReferenceId As %String = "") As %String
{
	q:(CTPCPDR="") ""
	if Date="" s Date=+$h
	s qresult=""
	q:(CTPCPDR="") ""
	s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTPCPDR,1)),"^",4) 
	if CTPCPCarPrvTpDR'=""
	{
		s CTCPTInternalType=$p($g(^CT("CPT",CTPCPCarPrvTpDR)),"^",4)
		if ((CTCPTInternalType="NURSE")||(CTCPTInternalType="DOCTOR"))
		{
			//新增资源表
			if Type="Add"
			{
		
				
				s validateflag=0
				s RESRowId1=0
				for
				{
					s RESRowId1=$o(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR,RESRowId1)) q:RESRowId1=""
					if $d(^RB("RES",RESRowId1))
					{
						s validateflag=1
						
						//2021-01-27 likefan
						s endflag=0
						if (DateTo'="") //停用指定科室，加判断
						{
							s SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",CTPCPDR,0))
							if (SSUSRRowId'="")
							{
								s FlagResult=..IfRBresourceEnd(SSUSRRowId,CTLOCDR)	//判断是否还有该科室的权限
								s endflag=$p(FlagResult,"^",1)
							}
							if ($p(FlagResult,"^",2)=1)&&($p(FlagResult,"^",3)=ReferenceId)	//只有这1条还有权限，该条结束日期也加上
							{
								s endflag=0
							}
						}
						continue:endflag=1	//还有该科室权限，不截止
						
						s iobj=##class(User.RBResource).%OpenId(RESRowId1)
						s iobj.RESDateActiveTo=DateTo
						s isc=iobj.%Save()
						d iobj.%Close()
						If $$$ISOK(isc){					
							s iid = iobj.%Id()
							s qresult= "{success:'true',id:'"_iid_"'}"         //返回RowId
						}else{
							Trollback
							s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(isc)_"'}"    //返回错误信息
						}
					}
				}
				if validateflag=0
				{
					s iobj=##class(User.RBResource).%New()
					s iobj.RESCode = $p($g(^CTPCP(CTPCPDR,1)),"^",1)
					s iobj.RESDesc = $p($g(^CTPCP(CTPCPDR,1)),"^",2)
					d iobj.RESCTLOCDRSetObjectId(CTLOCDR)
					d iobj.RESCTPCPDRSetObjectId(CTPCPDR)
					s iobj.RESMRRequest = "Y"
					s iobj.RESAdmittingRights="Y"
					s iobj.RESScheduleRequired = "Y"
					s iobj.RESDateActiveFrom=Date
					s iobj.RESDateActiveTo=DateTo
					s isc=iobj.%Save()
					d iobj.%Close()				
					If $$$ISOK(isc){					
						s iid = iobj.%Id()
						s qresult= "{success:'true',id:'"_iid_"'}"         //返回RowId
						
					}else{
						Trollback
						s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(isc)_"'}"    //返回错误信息
						
					}
				}
			}
		
			
			///更新资源表 添加结束日期或者去掉结束日期
			if Type="Update"
			{
				if (CTLOCDR'="")
				{
					s RESRowId1=0
					for
					{
						s RESRowId1=$o(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR,RESRowId1)) q:RESRowId1=""
						if $d(^RB("RES",RESRowId1))
						{
							//2020-12-08 likefan
							s endflag=0
							if (DateTo'="") //停用指定科室，加判断
							{
								s SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",CTPCPDR,0))
								if (SSUSRRowId'="")
								{
									s FlagResult=..IfRBresourceEnd(SSUSRRowId,CTLOCDR)	//判断是否还有该科室的权限
									if ($p(FlagResult,"^",1)=1)	//科室还有权限
									{
										s idstr=$p(FlagResult,"^",3)
										for i=1:1:$l(idstr,"&")
										{
											s OTHLLRowId1=$p(idstr,"&",i)
											continue:($p(OTHLLRowId1,"||",1)="")||($p(OTHLLRowId1,"||",2)="")
											s DateTo1=$p($g(^SSU("SSUSR",$p(OTHLLRowId1,"||",1),"OTHLL",$p(OTHLLRowId1,"||",2))),"^",5)	//截止日期
											if (DateTo1="")	//有截止期日为空的有效数据，直接跳过
											{
												s endflag=1
												q
											}
											if (DateTo1'="")&&(DateTo1>DateTo)
											{
												s DateTo=DateTo1	//截止日期取最靠后的
											}
										}
									}
								}
							}
							continue:endflag=1	//还有该科室权限，不截止
							
							s iobj=##class(User.RBResource).%OpenId(RESRowId1)
					    	s ieobj = ##class(web.Entity.CT.RBResource).%New()
					    	s iobj.RESCode =$p($g(^CTPCP(CTPCPDR,1)),"^",1)
					    	s iobj.RESDesc =$p($g(^CTPCP(CTPCPDR,1)),"^",2)
					    	if iobj.RESDateActiveFrom="" s iobj.RESDateActiveFrom=Date
					    	s iobj.RESDateActiveTo =DateTo
							s isc= iobj.%Save()
							d iobj.%Close()				
							If $$$ISOK(isc){					
								s iid = iobj.%Id()
								s qresult= "{success:'true',id:'"_iid_"'}"         //返回RowId
								
							}else{
								Trollback
								s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(isc)_"'}"    //返回错误信息
								
							}
						}
					}
				}
				else
				{
					//停医护人员，停掉所有关联
					s CTLOCDR1=0
					for
					{
						s CTLOCDR1=$o(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR1)) q:CTLOCDR1=""
						s RESRowId1=0
						for
						{
							s RESRowId1=$o(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR1,RESRowId1)) q:RESRowId1=""
							if $d(^RB("RES",RESRowId1))
							{
								s iobj=##class(User.RBResource).%OpenId(RESRowId1)
								
						    	s ieobj = ##class(web.Entity.CT.RBResource).%New()
						    	s iobj.RESCode =$p($g(^CTPCP(CTPCPDR,1)),"^",1)
						    	s iobj.RESDesc =$p($g(^CTPCP(CTPCPDR,1)),"^",2)
						    	if iobj.RESDateActiveFrom="" s iobj.RESDateActiveFrom=Date
						    	s iobj.RESDateActiveTo =DateTo
								s isc= iobj.%Save()
								d iobj.%Close()				
								If $$$ISOK(isc){					
									s iid = iobj.%Id()
									s qresult= "{success:'true',id:'"_iid_"'}"         //返回RowId
									
								}else{
									Trollback
									s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(isc)_"'}"    //返回错误信息
									
								}
							}
						}
					}
				}
			}
			
			//医护人员重新激活，同时激活指定科室	2021-04-21
			if Type="Active"
			{
				
				s SSUSRRowId=$o(^SSU("SSUSR",0,"CTPCP",CTPCPDR,0))
				if (SSUSRRowId'="")
				{
					s CTLOCDR=0
					for
					{
						s CTLOCDR=$o(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR)) q:CTLOCDR=""
						s FlagResult=..IfRBresourceEnd(SSUSRRowId,CTLOCDR)	//判断是否还有该科室的权限
						if ($p(FlagResult,"^",1)=1)	//科室还有权限，循环所有权限，将最靠后的截止日期存给指定科室
						{
							s DateTo=""
							s idstr=$p(FlagResult,"^",3)
							for i=1:1:$l(idstr,"&")
							{
								s OTHLLRowId1=$p(idstr,"&",i)
								continue:($p(OTHLLRowId1,"||",1)="")||($p(OTHLLRowId1,"||",2)="")
								s DateTo1=$p($g(^SSU("SSUSR",$p(OTHLLRowId1,"||",1),"OTHLL",$p(OTHLLRowId1,"||",2))),"^",5)	//截止日期
								if (DateTo1="")	//有截止期日为空的有效数据，直接存空
								{
									s DateTo=""
									q
								}
								if (DateTo1'="")&&(DateTo'="")&&(DateTo1>DateTo)
								{
									s DateTo=DateTo1	//截止日期取最靠后的
								}
								s:(DateTo1'="")&&(DateTo="") DateTo=DateTo1		//第一次循环到DateTo1不为空时赋值给DateTo
							}
							s RESRowId1=$o(^RB("RES",0,"CTPCP",CTPCPDR,CTLOCDR,0))
							s iobj=##class(User.RBResource).%OpenId(RESRowId1)
					    	s iobj.RESDateActiveTo =DateTo
							s isc= iobj.%Save()
							d iobj.%Close()				
							If $$$ISOK(isc){					
								s iid = iobj.%Id()
								s qresult= "{success:'true',id:'"_iid_"'}"
							}else{
								Trollback
								s qresult = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(isc)_"'}"    //返回错误信息
							}
						}
						
					}
				}
			}
		}
	}
	Q qresult
}

/// 根据用户id和科室id，判断是否还有该科室的权限（判断是否截至指定科室日期）
/// 基础数据平台-likefan 2020-12-04
/// input：用户rowid，科室rowid
/// output：1 还有该科室权限 / 0 没有该科室权限，可以截止
/// w ##class(web.DHCBL.CT.CTCareProv).IfRBresourceEnd("","")
ClassMethod IfRBresourceEnd(userid As %String, locid As %String) As %String
{
	q:userid="" ""
	q:locid="" ""
	s flag=0,count=0
	s rowidstr=""	//把存在权限的rowid返回出去
	s SSUSRDefaultDeptDR=$p($g(^SSU("SSUSR",userid)),"^",4)     //默认登录科室DR
	if SSUSRDefaultDeptDR=locid
	{
		s count=count+1
		s rowidstr=userid
		s flag=1
	}
	//其他登录科室
	s ChildSub=0
	for 
	{
		s ChildSub=$o(^SSU("SSUSR",userid,"OTHLL",ChildSub)) q:ChildSub=""  
  		s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",userid,"OTHLL",ChildSub)),"^",1)
		s OTHLLStartDate=$p($g(^SSU("SSUSR",userid,"OTHLL",ChildSub)),"^",4)
		s OTHLLEndDate=$p($g(^SSU("SSUSR",userid,"OTHLL",ChildSub)),"^",5)
		if (OTHLLCTLOCDR=locid)&&((OTHLLEndDate="")||(OTHLLEndDate>+$h))
		{
			s count=count+1
			s:rowidstr'="" rowidstr=rowidstr_"&"
			s rowidstr=rowidstr_userid_"||"_ChildSub
			s flag=1
		}
	}
	q flag_"^"_count_"^"_rowidstr
}

/// 修改人员姓名时，同步修改RBResource表的描述字段
/// 基础数据平台-likefan 2020-12-16
/// input：医护人员id，医护人员姓名
/// output：1 成功
/// w ##class(web.DHCBL.CT.CTCareProv).SaveRBDesc("1689","张三02")
ClassMethod SaveRBDesc(doctordr As %String, doctorname As %String) As %String
{
	q:doctordr="" ""
	q:doctorname="" ""
	s RBCTLocDR=0
	for
	{
		s RBCTLocDR=$o(^RB("RES",0,"CTPCP",doctordr,RBCTLocDR)) q:RBCTLocDR=""
		s RBRowId=$o(^RB("RES",0,"CTPCP",doctordr,RBCTLocDR,0))
		s obj=##class(User.RBResource).%OpenId(RBRowId)
    	s obj.RESDesc=doctorname
    	s sc=obj.%Save()
		d obj.%Close()
	}
	q 1
}

}

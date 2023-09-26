/// Desc:综合查询
/// Creator:Candy
Class DHCEPRFS.BL.BLQuery Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

/// Desc: 查询
/// Creator:Candy
/// Input:AMedRecordNo:病案号,ADisDate:出院日期,AAdmDate:入院结束日期，AResult:返回结果列
/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQuery","QueryResultList","500307","2015-8-20","2015-8-20","Name,EpisodeID,MedRecordNo,DisDate,AdmDate")
/// Output:查询结果table
Query QueryResultList(AMedRecordNo As %String, ADisDate As %String, AAdmDate As %String, AResult As %String) As %Query(ROWSPEC = "MrEpisode,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40,c41,c42,c43,c44,c45,c46,c47,c48,c49,c50,c51,c52,c53,c54,c55,c56,c57,c58,c59,c60,c61,c62,c63,c64,c65,c66,c67,c68,c69,c70,c71,c72,c73,c74,c75,c76,c77,c78,c79,c80,c81,c82,c83,c84,c85,c86,c87,c88,c89,c90,c91,c92,c93,c94,c95,c96,c97,c98,c99,c100,c101,c102,c103,c104,c105,c106,c107,c108,c109,c110,c111,c112,c113,c114,c115,c116,c117,c118,c119,c120,c121,c122,c123,c124,c125,c126,c127,c128,c129,c130,c131,c132,c133,c134,c135,c136,c137,c138,c139,c140,c141,c142,c143,c144,c145,c146,c147,c148,c149,c150,c151,c152,c153,c154,c155,c156,c157,c158,c159,c160,c161,c162,c163,c164,c165,c166,c167,c168,c169,c170,c171,c172,c173,c174,c175,c176,c177,c178,c179,c180,c181,c182,c183,c184,c185,c186,c187,c188,c189,c190,c191,c192,c193,c194,c195,c196,c197,c198,c199,c200,c201,c202,c203,c204,c205,c206,c207,c208,c209,c210,c211,c212,c213,c214,c215,c216,c217,c218,c219,c220,c221,c222,c223,c224,c225,c226,c227,c228,c229,c230,c231,c232,c233,c234,c235,c236,c237,c238,c239,c240,c241,c242,c243,c244,c245,c246,c247,c248,c249,c250,c251")
{
}

ClassMethod QueryResultListExecute(ByRef qHandle As %Binary, AMedRecordNo As %String, ADisDate As %String, AAdmDate As %String, AResult As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	q:(AMedRecordNo = "") $$$OK
 	s:(ADisDate '= "") ADisDate = $zdh(ADisDate,3)
 	s:(AAdmDate '= "") AAdmDate = $zdh(AAdmDate,3)

	s mrEpisodePatID = ""
	for {
		s mrEpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMedRecordNo"," "_AMedRecordNo,mrEpisodePatID))
		q:(mrEpisodePatID = "")
		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(mrEpisodePatID)
		s mrEpisodeID = objMREpisodePat.MREpisodeID
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s disDate = objMREpisode.DisDate
		s admDate = objMREpisode.AdmDate
		continue:(ADisDate '= disDate)
		continue:(AAdmDate '= admDate)
		s data = ..GetResult(AResult,mrEpisodeID)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1	
	} 
	
	Quit $$$OK
}

ClassMethod QueryResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResultListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc: 查询
/// Creator:Candy
/// Input:AMedRecordNo:病案号,ASDisDate:出院开始日期,AEDisDate:出院结束日期,ADisLocID:出院科室,AECondition:其他条件xml,AResult:返回结果列
/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQuery","ComplexQueryList","","","2013-05-01","2013-05-30","","")
/// Output:查询结果table
Query ComplexQueryList(AMedRecordNo As %String, ASDisDate As %String, AEDisDate As %String, ADisLocID As %String, AECondition As DHCEPRFS.Entity.EQueryItems, AResult As %String) As %Query(ROWSPEC = "MrEpisode,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40,c41,c42,c43,c44,c45,c46,c47,c48,c49,c50,c51,c52,c53,c54,c55,c56,c57,c58,c59,c60,c61,c62,c63,c64,c65,c66,c67,c68,c69,c70,c71,c72,c73,c74,c75,c76,c77,c78,c79,c80,c81,c82,c83,c84,c85,c86,c87,c88,c89,c90,c91,c92,c93,c94,c95,c96,c97,c98,c99,c100,c101,c102,c103,c104,c105,c106,c107,c108,c109,c110,c111,c112,c113,c114,c115,c116,c117,c118,c119,c120,c121,c122,c123,c124,c125,c126,c127,c128,c129,c130,c131,c132,c133,c134,c135,c136,c137,c138,c139,c140,c141,c142,c143,c144,c145,c146,c147,c148,c149,c150,c151,c152,c153,c154,c155,c156,c157,c158,c159,c160,c161,c162,c163,c164,c165,c166,c167,c168,c169,c170,c171,c172,c173,c174,c175,c176,c177,c178,c179,c180,c181,c182,c183,c184,c185,c186,c187,c188,c189,c190,c191,c192,c193,c194,c195,c196,c197,c198,c199,c200,c201,c202,c203,c204,c205,c206,c207,c208,c209,c210,c211,c212,c213,c214,c215,c216,c217,c218,c219,c220,c221,c222,c223,c224,c225,c226,c227,c228,c229,c230,c231,c232,c233,c234,c235,c236,c237,c238,c239,c240,c241,c242,c243,c244,c245,c246,c247,c248,c249,c250,c251")
{
}

ClassMethod ComplexQueryListExecute(ByRef qHandle As %Binary, AMedRecordNo As %String, ASDisDate As %String, AEDisDate As %String, ADisLocID As %String, AECondition As DHCEPRFS.Entity.EQueryItems, AResult As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	//q:((AMedRecordNo = "") && (ADisLocID = "")  && ((ASDisDate = "")||(AEDisDate = ""))) $$$OK
 	
 	s conditionMedRecordNo = ..GetConditionValueByName("MedRecordNo",AECondition)
 	s conditionMedRecordNo = $zcvt(conditionMedRecordNo,"U")
 	if (conditionMedRecordNo '= "")
 	{
 		s conditionMedRecordNo = ..AddZero(conditionMedRecordNo)
 	}
 	s conditionRegNo = ..GetConditionValueByName("RegNo",AECondition)
 	s conditionName = ..GetConditionValueByName("Name",AECondition)
 	if (conditionMedRecordNo '= "")
 	{
	 	if ($l(conditionMedRecordNo,"_")>1)
	 	{
		 	s medRecordNo = $p(conditionMedRecordNo,"_",1)
		 	s episodeCount = +$p(conditionMedRecordNo,"_",2)
		 	s count = 0
		 	s admDate = ""
		 	for {
			 	s admDate = $o(^DHCEPRFS.INST.MREpisodeI("idxMedRecordNoDisDate"," "_medRecordNo,admDate))
		 		q:(admDate = "")  	
		 		s admTime = ""
		 		for {
			 		s admTime = $o(^DHCEPRFS.INST.MREpisodeI("idxMedRecordNoDisDate"," "_medRecordNo,admDate,admTime))
		 			q:(admTime = "")  
		 			s MrEpisodeID = ""
		 			for {
			 			//b "s"
						s MrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("idxMedRecordNoDisDate"," "_medRecordNo,admDate,admTime,MrEpisodeID))
		 				q:(MrEpisodeID = "")  
		 				s count = count + 1
		 				continue:(count '= episodeCount)
		 				s checkRet = ..CheckResult(MrEpisodeID,conditionMedRecordNo,AMedRecordNo,ASDisDate,AEDisDate,ADisLocID)
	       	 			continue:(checkRet = "0")
	        			continue:($$GetConditionIsOK() = 0)
						d GetResult
		 			}
		 		}	
			}
		}
		else
		{
			s MREpisodePatID = ""
			for {
				s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMedRecordNo"," "_conditionMedRecordNo,MREpisodePatID))
		 		q:(MREpisodePatID = "")
		 		s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
	      		s MrEpisodeID = objMREpisodePat.MREpisodeID
	        	s checkRet = ..CheckResult(MrEpisodeID,conditionMedRecordNo,AMedRecordNo,ASDisDate,AEDisDate,ADisLocID)
	       	 	continue:(checkRet = "0")
	        	continue:($$GetConditionIsOK() = 0)
				d GetResult 
			}	
		}	 	
	}
	elseif (conditionRegNo '= "") 
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_conditionRegNo,MRPatientID))
		 	q:(MRPatientID = "")
		 	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
		 	s conditionMedRecordNo = objMRPatient.MedRecordNo
	      	s MrEpisodeID = ""
        	for {
	       		s MrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MrEpisodeID))
	       		q:(MrEpisodeID = "")
	            s checkRet = ..CheckResult(MrEpisodeID,conditionMedRecordNo,AMedRecordNo,ASDisDate,AEDisDate,ADisLocID)
	            continue:(checkRet = "0")
	            continue:($$GetConditionIsOK() = 0)
				d GetResult
         	}  
		}		
	}
	elseif (conditionName '= "") 
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName"," "_$zcvt(conditionName,"U"),MRPatientID))
		 	q:(MRPatientID = "")
		 	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
		 	s conditionMedRecordNo = objMRPatient.MedRecordNo
	      	s MrEpisodeID = ""
        	for {
	       		s MrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,MrEpisodeID))
	       		q:(MrEpisodeID = "")
	            s checkRet = ..CheckResult(MrEpisodeID,conditionMedRecordNo,AMedRecordNo,ASDisDate,AEDisDate,ADisLocID)
	            continue:(checkRet = "0")
	            continue:($$GetConditionIsOK() = 0)
				d GetResult
         	}  
		}		
	}
 	else 
 	{
	 	if (AMedRecordNo '= "")
	 	{
		 	s noCount = $L(AMedRecordNo,"^")
			for j=1:1:noCount
			{
			  	s curMedRecordNo = $p(AMedRecordNo, "^", j)
				continue:(curMedRecordNo = "")
			 
		    	s MREpisodePatID = ""
				for {
					s MREpisodePatID = $o(^DHCEPRFS.INST.MREpisodePatI("IdxMedRecordNo"," "_curMedRecordNo,MREpisodePatID))
			    	q:(MREpisodePatID = "")
			    	s objMREpisodePat = ##class(DHCEPRFS.INST.MREpisodePat).%OpenId(MREpisodePatID)
			    	s MrEpisodeID = objMREpisodePat.MREpisodeID
			    	continue:($$GetConditionIsOK() = 0)
			    	d GetResult 
				}	
			}
		} 
		elseif ((ASDisDate '= "") && (AEDisDate '= "") && (ADisLocID '= ""))
		{
			s startDate = ..ChangeTimeToSys(ASDisDate,"D")
		    s endDate = ..ChangeTimeToSys(AEDisDate,"D")
		    if ($f(ADisLocID,"^")=0)
		    {
			    for DisDate = startDate:1:endDate {
				    s MrEpisodeID = ""
				    for {
				        s MrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisLocDisDate"," "_ADisLocID,DisDate,MrEpisodeID))
				        q:(MrEpisodeID = "")
				        continue:($$GetConditionIsOK() = 0)
				        d GetResult	
				    }
			    }
		    }
		    else
		    {
			    s locCount = $L(ADisLocID,"^")
			    for j=1:1:locCount
			    {
				    s curDisLocID = $p(ADisLocID, "^", j)
				    continue:(curDisLocID = "")
			    
				    for DisDate = startDate:1:endDate {
					    s MrEpisodeID = ""
					    for {
					        s MrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxDisLocDisDate"," "_curDisLocID,DisDate,MrEpisodeID))
					        q:(MrEpisodeID = "")
					        continue:($$GetConditionIsOK() = 0)
					        d GetResult	
					    }
				    }
			    }
		    }	
		}
 	}
	Quit $$$OK
GetConditionIsOK()
   	s IsOk = ..GetCondition(AECondition,MrEpisodeID)
   	q IsOk
GetResult
    s data = ..GetResult(AResult,MrEpisodeID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1	
	q
}

ClassMethod ComplexQueryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ComplexQueryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ComplexQueryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ComplexQueryListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod CheckResult(AMREpisodeID As %String, AConditionMedRecordNo As %String, AMedRecordNo As %String, ASDisDate As %String, AEDisDate As %String, ADisLocID As %String)
{
	s ret = "0"
	//if (AMedRecordNo '= "")		
	//{
	//	for i=1:1:$l(AMedRecordNo,"^")
	//	{
	//	  	if (AConditionMedRecordNo = $p(AMedRecordNo, "^", i))
	//	  	{
	//			s ret = "1"  
	//			q	
	//		}
	//	}	
	//}
	
	s objMrEpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(objMrEpisode = "") ret
	
	if ((ret = "0") && (ADisLocID '= ""))
	{
		s disLocID = objMrEpisode.DisLocID
		for j=1:1:$l(ADisLocID,"^")
		{
			if (disLocID = $p(ADisLocID, "^", j))	
			{
				s ret = "1"
				q	
			}
		}
	}
	
	if ((ret = "1") && (ASDisDate '= "") && (AEDisDate '= ""))
	{
		s startDate = ..ChangeTimeToSys(ASDisDate,"D")
	    s endDate = ..ChangeTimeToSys(AEDisDate,"D")
	    if ((objMrEpisode.DisDate >= startDate) && (objMrEpisode.DisDate <= endDate))	
	    {
			s ret = "1"    
		}
		else
		{
			s ret = "0"	
		}		
	}
	
	q ret
}

/// debug: d ##class(DHCEPRFS.BL.BLQuery).GetConditionValueByConditionName("",^CacheTemp("111","1234","345"))
ClassMethod GetConditionValueByName(AName As %String, ACondition As DHCEPRFS.Entity.EQueryItems) As %String
{
	s ret = ""
	s Icount =  ACondition.QueryItems.Count()
	for i=1:1:Icount
	{
		s Items = ##Class(DHCEPRFS.Entity.EQueryItem).%New()
		s Items = ACondition.QueryItems.GetAt(i)
		s Scount = Items.Items.Count()
		 
		for j=1:1:Scount
		{
			s Condition = Items.Items.GetAt(j).Condition
			s Operator = Items.Items.GetAt(j).Operator
			s Value = Items.Items.GetAt(j).Value
			s DataType = Items.Items.GetAt(j).DataType
			if (Condition = AName)
			{
				s ret = Value
				s:(ret = $c(0)) ret = ""
				q
			}
		}
		q:(ret '= "")
	}	
	q ret
}

/// Desc:比较查询条件
/// Creator：Candy
/// Input：ACondition 查询条件，AMrEpisodeID 就诊号
ClassMethod GetCondition(ACondition As DHCEPRFS.Entity.EQueryItems, AMrEpisodeID As %String) As %String
{
	s result = 1
	s Icount =  ACondition.QueryItems.Count()
	
	for i=1:1:Icount
	{
		s Items = ##Class(DHCEPRFS.Entity.EQueryItem).%New()
		s Items = ACondition.QueryItems.GetAt(i)
		s Scount = Items.Items.Count()
		 
		for j=1:1:Scount
		{
			s Condition = Items.Items.GetAt(j).Condition
			
			s Operator = Items.Items.GetAt(j).Operator
			s Value = Items.Items.GetAt(j).Value
			if (Condition = "MedRecordNo")
			{
				//b "s"
				s Value = $zcvt(Value,"U")
				if ($l(Value,"_")>1)
				{
					s Value = $p(Value,"_",1)	
				}
			}
			s DataType = Items.Items.GetAt(j).DataType
				s:((DataType = "D")||(DataType = "T")||(DataType = "DT")) Value = ..ChangeTimeToSys(Value,DataType)
		    continue:((Value = "") || (Value = $c(0)))
			s reValue =..GetValue(Condition,AMrEpisodeID)
			if ((Condition = "TransDept")||(Condition = "MRItemName"))
			{
				s result = ..CompareMultiValue(reValue,Operator,Value,DataType)	
			}
			else
			{
		    	s result = ..CompareValue(reValue,Operator,Value,DataType)
			}
		    q:(result = 0)
		}
		q:(result = 1)
	}
    q result
}

/// Desc:取值
/// Creator:Candy
/// Input:item:取值方法名, AMrEpisodeID:就诊ID
/// Output：结果值
ClassMethod GetValue(item As %String, AMrEpisodeID As %String) As %List
{
	if (item = "Death")
	{
		
		s itemValue = $lb("")
		//s itemValue = ##CLass(DHCEPRFS.BL.BLQueryClassMethod).Death(AMrEpisodeID)
		//q itemValue
		//因为患者死亡后，每次就诊取死亡日期时都有死亡日期
		//这样就导致患者的所有就诊都被标注成死亡
		//而真正死亡的就诊应该是患者的最后一次就诊
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMrEpisodeID)
   	 	s DeathDate = objMREpisode.DeathDate
   	 	s MRPatientID = objMREpisode.MRPatientID
   	 	s DisDate = objMREpisode.DisDate
   	 	s DisTime = objMREpisode.DisTime
   	 	if ((DisDate = "") && (DeathDate '= ""))
   	 	{
	   		//有些医院死亡患者不办理出院，则没有出院日期，
	   		//那么死亡日期不为空，出院日期为空的为死亡的就诊
	   		s itemValue = $lb("Y")	
	   		
	   	}
		elseif ((DisDate '= "") && (DisDate < DeathDate))
		{
			//只有最后一次就诊死亡
			//出院日期小于死亡日期，此次就诊未死亡	
			s itemValue = $lb("N")
		}
		elseif ((DisDate '= "") && (DisDate = DeathDate))
		{
			//出院日期等于死亡日期，判断此次就诊是否是最后一次就诊	
			s mrEpisodeID = ""
			s lastDisDate = DisDate
			s lastDisTime = DisTime
			s tempMREpisodeID = AMrEpisodeID
			for {
				s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,mrEpisodeID))
				q:(mrEpisodeID = "")
				s objTemp = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				if (objTemp.DisDate > lastDisDate)
				{
					s lastDisDate = objTemp.DisDate
					s lastDisTime = objTemp.DisTime
					s tempMREpisodeID = mrEpisodeID
					continue
				}
				
				if ((objTemp.DisDate = lastDisDate) && (objTemp.DisTime > lastDisTime))
				{
					s lastDisDate = objTemp.DisDate
					s lastDisTime = objTemp.DisTime
					s tempMREpisodeID = mrEpisodeID
					continue
				}
			}
			//此次为最后一次就诊
			if (tempMREpisodeID = AMrEpisodeID)
			{
				s itemValue = $lb("Y")
			}
			else
			{
				s itemValue = $lb("N")
			}
   	 	}
   	 	q itemValue
	}
	else
	{
		s itemValue = $ZOBJCLASSMETHOD("DHCEPRFS.BL.BLQueryClassMethod",item,AMrEpisodeID)
		q itemValue
	}
}

/// Update: 比较值增加字符串的比较 2022-10-20 yangshun
/// Input：AItemValue 值,AOperator:操作符,AConditionValue:条件值,ADataType:类型
/// Other:  输入条件值为"NULL",表示前端输入的条件的值为空。
/// debug w ##Class(DHCEPRFS.BL.BLQuery).CompareValue(^tempCond(1),"like","ZXYJHYK-中西医结合一科","S")
ClassMethod CompareValue(AItemValue As %List, AOperator As %String, AConditionValue As %String, ADataType As %String) As %Boolean
{
	s result = 0
    for i=1:1:$ll(AItemValue)
    {
	  	s:(AConditionValue = "NULL") AConditionValue = ""
	  	s ItemValue = $Case(ADataType = "D",1:..ChangeTimeToSys($lg(AItemValue,i)),:$lg(AItemValue,i))
	  	if (ADataType="SC") //大小写不敏感
	  	{
		  	s ItemValue=$zcvt(ItemValue,"U")
		  	s AConditionValue=$zcvt(AConditionValue,"U")
		}
		
		//修改部分开始
		s strFlag = "1"
		s numConditionValue = +AConditionValue
		s:((numConditionValue'=0) && ($L(numConditionValue)=$L(AConditionValue))) strFlag = "0"
		//增加对字符串的比较，目前这里的大于小于只能比较数字
		if (AOperator = "=")
		{
			s result = (ItemValue = AConditionValue)
		}
		elseif (AOperator = "<>")
		{
			s result = (ItemValue '= AConditionValue)
		}
		elseif (AOperator = ">")
		{
			if (strFlag="1")
			{
				s result = ItemValue]]AConditionValue
			}
			else
			{
				s result = (ItemValue > AConditionValue)
			}
		}
		elseif (AOperator = "<")
		{
			if (strFlag="1")
			{
				s result = AConditionValue]]ItemValue
			}
			else
			{
				s result = (ItemValue < AConditionValue)
			}
		}
		elseif (AOperator = ">=")
		{
			if (strFlag="1")
			{
				s result = (ItemValue]]AConditionValue)||(ItemValue=AConditionValue)
			}
			else
			{
				s result = (ItemValue '< AConditionValue)
			}
		}
		elseif (AOperator="<=")
		{
			if (strFlag="1")
			{
				s result = (AConditionValue]]ItemValue)||(ItemValue=AConditionValue)
			}
			else
			{
				s result = (ItemValue '> AConditionValue)
			}
		}
		elseif(AOperator["like")
		{
			s index = $find(ItemValue, AConditionValue)
        	s:(AOperator = "like") result = index > 0
        	s:(AOperator = "notlike") result = index <= 0
		}
		q:(result=1)
		//修改部分结束
		
		//原有部分注释
   	    /**s:(AOperator = "=") result = (ItemValue = AConditionValue)
        s:(AOperator = "<>") result = (ItemValue '= AConditionValue)
        s:(AOperator = ">") result = (ItemValue > AConditionValue)
        s:(AOperator = "<") result = (ItemValue < AConditionValue)
        s:(AOperator = ">=") result = (ItemValue '< AConditionValue)
        s:(AOperator = "<=") result = (ItemValue '> AConditionValue)
        s index = $find(ItemValue, AConditionValue)
        s:(AOperator = "like") result = index > 0
        s:(AOperator = "notlike") result = index <= 0
        q:(result = 1)*/
    }
    q result
}

ClassMethod CompareMultiValue(AItemValue As %List, AOperator As %String, AConditionValue As %String, ADataType As %String) As %Boolean
{
	s result = 0
    for i=1:1:$ll(AItemValue)
    {
	  	//AItemVale含有多个值，类似 感染一科-ICU-感染一科，只要AConditionValue有一个符合即符合
	  	s oneItem = $lg(AItemValue,i)
	  	for j=1:1:$l(oneItem,"-")
	  	{
			s oneItemValue = $p(oneItem,"-",j)
			s oneItemList = $lb("")
			s oneItemList =  $lb(oneItemValue)
			s oneResult = ..CompareValue(oneItemList,AOperator,AConditionValue,ADataType)
			if (oneResult = 1)
			{
				s result = 1
				q	
			}
		}
        q:(result = 1)
    }
    q result
}

/// Desc:获得查询结果
/// Creator：Candy
/// Input：AResult 要取得值列表,AMrEpisodeID：就诊号
/// Output：值列表
/// w ##Class(DHCEPRFS.BL.BLQuery).GetResult(^TempCandy,1)
ClassMethod GetResult(AResult As %String, AMrEpisodeID As %String) As %List
{
	s resultValue = $lb(AMrEpisodeID)
    s count = $l(AResult,",")
    for i = 1:1:count
    {
   	    s tmp = $p(AResult,",",i)
	    s Value =..GetValue(tmp,AMrEpisodeID)
	    s Value = ..ChangeList(Value) //houj
	    s resultValue = resultValue_Value
    }
   	q resultValue
}

ClassMethod ChangeList(AInputList As %List) As %List
{
	q:(AInputList="") AInputList
	
	s count = $ll(AInputList)
	q:(count<2) AInputList
	
	s resultValue = ""
	for i = 1:1:count
    {
   	    s tmp = $lg(AInputList,i)
   	    continue:(tmp="")
   	    
   	    if (resultValue = "")
	    {	s resultValue = tmp}
	    else
	    {	s resultValue = resultValue_","_tmp}
    }
    
   	q $lb(resultValue)
}

// 工具方法

/// Desc:	将日期时间格式转换为系统格式(日期与时间之间用空格分隔);
/// Creator：Candy
/// Input：ADateTime 时间，AType 类型
/// Debug: 	w ##Class(DHCEPRFS.BL.BLQuery).ChangeTimeToSys("2010-10-10 10:10:10")
ClassMethod ChangeTimeToSys(ADateTime As %String, AType As %String = "D") As %String
{
	s ret = ""
	q:(ADateTime = "") ret
	s Date = "",Time = ""
	if (AType = "D")
	{
		s Date = $p(ADateTime," ",1)
	}
	elseif(AType = "T")
	{
		s Time=$p(ADateTime," ",1)
	}elseif (AType = "DT")
	{
	    s Date = $p(ADateTime," ",1),Time=$p(ADateTime," ",2)	
	}
	s:(Date [ "年") Date = $tr(Date,"年","-"),Date = $tr(Date,"月","-"),Date = $tr(Date,"日","")
	s:(Date [ "-") Date = $zdh(Date,3)
	s:(Date [ "/") Date = $zdh(Date,4)
	s Date = +Date
	s:(Time [ ":") Time = $zth(Time,1)
	s Time = +Time
	s ret = $case(AType,"DT":Date_" "_Time,"D":Date,"T":Time)
	q ret
}

/// Desc:获得条件xml
/// Input:Acontent 条件流数据
/// Debug:d ##Class(DHCEPRFS.BL.BLQuery).GetQueryItemFromXML("")
ClassMethod GetQueryItemFromXML(Acontent As %Stream) As DHCEPRFS.Entity.EQueryItems
{
	s result = ""
	s conStream = ##class(%GlobalCharacterStream).%New()
	d conStream.Write(Acontent)
	s xmlReader = ##class(%XML.Reader).%New()
	s sc = xmlReader.OpenStream(conStream)
    q:($$$ISERR(sc)) ""
    d xmlReader.Correlate("QueryItem","DHCEPRFS.Entity.EQueryItems")
    While xmlReader.Next(.obj,.sc)
    {
	    s:(obj '= "") result = obj
	    q:(result '= "")
	}
	q result
}

/// Desc: 从流数据中获得字符串
/// Input:Acontent 条件流数据
ClassMethod GetDataFromXML(Acontent As %Stream) As %String
{
	s data = ""	
	s obj = ##class(%GlobalCharacterStream).%New()
	d obj.Write(Acontent)
	
	do obj.Rewind()
	while (obj.AtEnd = 0) 
  	{ 	
    	set data = data_obj.Read(10240)
   	}
    d obj.%Close()
    s obj = ""   	
   	q data
}

/// Desc:将字符串返回list
/// Creator:Candy
/// Input:AValue 串 AChar 分割符
ClassMethod GetListFromString(AValue As %String, AChar As %String, AFlag As %String = "Y") As %List
{
	s ret = ""
	s $zt="GetListFromStringErr"
	s:$g(AChar)="" AChar=","
	s tmpVal="",tmpRet=""
	for Ind=1:1:$length(AValue,AChar)
	{
		s tmpVal = $p(AValue,AChar,Ind)
		continue:($zcvt(AFlag,"U") = "Y")&&(tmpVal = "")
		s tmpRet = tmpRet_$lb(tmpVal)
	}
	s ret = tmpRet
	q ret
GetListFromStringErr
   	q ""
}

ClassMethod HasGB(AIncome As %String) As %Integer
{
	s hasGB = 0
  	s comLength = $l(AIncome)
 	for i=1:1:comLength {
		s GBStr= $e(AIncome,i)  
		if (($A(GBStr) >= 19968) && ($A(GBStr) <= 40869)) ||(($A(GBStr) >= 63744) && ($A(GBStr) <= 64045))
		{
			s hasGB=1
		}
		q:(hasGB = 1)
	}
	q hasGB
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQuery","GetICDDX","肝炎")
Query GetICDDX(PQueryText As %String) As %Query(ROWSPEC = "ASequence:%String,CodeValue:%String,DescValue:%String,AliasValue:%String")
{
}

ClassMethod GetICDDXExecute(ByRef qHandle As %Binary, PQueryText As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	s i = 0
	//开始查询
		
	s result = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetMRCID")
	d result.Execute()
	while(result.Next())
	{
		s mrcID = $g(result.Data("MRCID"))
		s mrcIDInfo = ##class(%ArrayOfDataTypes).%New()
		s mrcIDInfo = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetMRCIDInfoByMRCID(mrcID)
		
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		//s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dataFrom = mrcIDInfo.GetAt("MRCIDDateActiveFrom")
		//s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s dateTo = mrcIDInfo.GetAt("MRCIDDateActiveTo")
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		
		//s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)
		s CodeValue = mrcIDInfo.GetAt("MRCIDICD9CMCode")
		
		//取描述列
		//s DescValue=$p($g(^MRC("ID",rowid)),"^",2)
		s DescValue=mrcIDInfo.GetAt("MRCIDDesc")
		
		//取别名列
		s AliasValue=""
		s resultAlias = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetAliasTextByMRCID")
		d resultAlias.Execute(mrcID)
		while(resultAlias.Next())
		{
			s AliasValue = AliasValue_$g(resultAlias.Data("AliasText"))_$c(2)
		}
		/*
		s aliasRowid=0
		for {
			s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
			q:(aliasRowid="")
			s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		}
		*/
		

		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (PQueryText '= "")
		{	
			s hasGB = ..HasGB(PQueryText)
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			s DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		//处理满足条件的结果并存入临时global
		s AliasValue = $p(AliasValue,$c(2),1)
		s data = $lb(+(i+1),CodeValue,DescValue,AliasValue)
  		s ^CacheTemp(repid,ind) = data
  		s ind = ind + 1
  		s i = i + 1
	}
	Quit $$$OK
}

ClassMethod GetICDDXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetICDDXExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetICDDXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetICDDXExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQuery","GetOperation","胸腔闭式引流术")
Query GetOperation(PQueryText As %String) As %Query(ROWSPEC = "ASequence:%String,CodeValue:%String,DescValue:%String,AliasValue:%String")
{
}

ClassMethod GetOperationExecute(ByRef qHandle As %Binary, PQueryText As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	s i = 0
	//开始查询
		
	s result = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetOPERID")
	d result.Execute()
	while(result.Next())
	{
		s operID = $g(result.Data("OPERID"))
		s operInfo = ##class(%ArrayOfDataTypes).%New()
		s operInfo = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetOPERInfoByOPERID(operID)
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		//s dateFrom=$p($g(^ORC("OPER",rowid)),"^",5)
		s dateFrom = operInfo.GetAt("OPERDateActiveFrom")
		//s dateTo=$p($g(^ORC("OPER",rowid)),"^",6)
		s dateTo = operInfo.GetAt("OPERDateActiveTo")
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		
		//取代码列和描述列
		//s CodeValue = $p($g(^ORC("OPER",rowid)),"^",14)
		s CodeValue = operInfo.GetAt("OPERICD10")
		//s DescValue = $p($g(^ORC("OPER",rowid)),"^",2)
		s DescValue = operInfo.GetAt("OPERDesc")
		
		//取别名列
		s AliasValue=""
		s resultAlias = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetAliasTextByOPERID")
		d resultAlias.Execute(operID)
		while(resultAlias.Next())
		{
			s AliasValue = AliasValue_$g(resultAlias.Data("AliasText"))_$c(2)
		}
		/*
		s aliasRowid=0
		for {
		  	s aliasRowid=$o(^ORC("OPER",rowid,"ALIAS",aliasRowid))
			q:(aliasRowid="")
			s AliasValue=AliasValue_$g(^ORC("OPER",rowid,"ALIAS",aliasRowid))_$c(2)
		}
		*/
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (PQueryText '= "")
		{	
			s hasGB = ..HasGB(PQueryText)
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			s DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		//处理满足条件的结果并存入临时global
		s AliasValue = $p(AliasValue,$c(2),1)
		s data = $lb(+(i+1),CodeValue,DescValue,AliasValue)
  		s ^CacheTemp(repid,ind) = data
  		s ind = ind + 1
  		s i = i + 1
	}
	Quit $$$OK
}

ClassMethod GetOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLQuery","GetAnesthesia","")
Query GetAnesthesia(PQueryText As %String) As %Query(ROWSPEC = "ASequence:%String,CodeValue:%String,DescValue:%String,AliasValue:%String")
{
}

ClassMethod GetAnesthesiaExecute(ByRef qHandle As %Binary, PQueryText As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	
	s i = 0
	//开始查询
	s result = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetANMETID")
	d result.Execute()
	while(result.Next())
	{
		s anmetID = $g(result.Data("ANMETID"))
		s anmetInfo = ##class(%ArrayOfDataTypes).%New()
		s anmetInfo = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetANMETInfoByANMETID(anmetID)
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		//s dateFrom=$p($g(^ORC("ANMET",rowid)),"^",5)
		s dateFrom = anmetInfo.GetAt("ANMETDateFrom")
		//s dateTo=$p($g(^ORC("ANMET",rowid)),"^",6)
		s dateTo = anmetInfo.GetAt("ANMETDateTo")
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		
		//取代码列和描述列
		//s CodeValue = $p($g(^ORC("ANMET",rowid)),"^",1)
		s CodeValue = anmetInfo.GetAt("ANMETCode")
		//s DescValue = $p($g(^ORC("ANMET",rowid)),"^",2)
		s DescValue = anmetInfo.GetAt("ANMETDesc")
		
		//取别名列
		s AliasValue=""
		s resultAlias = ##class(%ResultSet).%New("DHCEPRFS.BL.HISInfo.BLHISInfo:GetAliasTextByANMETID")
		d resultAlias.Execute(anmetID)
		while(resultAlias.Next())
		{
			s AliasValue = AliasValue_$g(resultAlias.Data("AliasText"))_$c(2)
		}
		/*
		s aliasRowid=0
		for {
		  	s aliasRowid=$o(^ORC("ANMET",rowid,"ALIAS",aliasRowid))
			q:(aliasRowid="")
			s AliasValue=AliasValue_$g(^ORC("ANMET",rowid,"ALIAS",aliasRowid))_$c(2)
		}
		*/
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (PQueryText '= "")
		{	
			s hasGB = ..HasGB(PQueryText)
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			s DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(PQueryText,"U"),hasGB)
			
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		//处理满足条件的结果并存入临时global
		s AliasValue = $p(AliasValue,$c(2),1)
		s data = $lb(+(i+1),CodeValue,DescValue,AliasValue)
  		s ^CacheTemp(repid,ind) = data
  		s ind = ind + 1
  		s i = i + 1
	}
	Quit $$$OK
}

ClassMethod GetAnesthesiaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnesthesiaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAnesthesiaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnesthesiaExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(DHCEPRFS.BL.BLQuery).AddZero(500306)
ClassMethod AddZero(AMedRecordNo As %String) As %String
{
	s medNo =""
	s mrMedNo = ""
	for {
		s mrMedNo = $o(^DHCEPRFS.INST.MRMedRecordD(mrMedNo),-1)
		q:(mrMedNo ="")
		s obj = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedNo)
		s medNo = obj.MedRecordNo
		q:(medNo '="")		
	}
	s medNo = $tr(medNo, " ")
	s medNo = $tr(medNo,$c(10),"")
	s medNo = $tr(medNo,$c(13),"")
	s length = $l(medNo)
	q:(length = $l(AMedRecordNo)) AMedRecordNo
	
	for index=1:1:(length - $l(AMedRecordNo)) 
	{
		s AMedRecordNo = "0"_AMedRecordNo
	}
	q AMedRecordNo
}

/// d ##Class(DHCEPRFS.BL.BLQuery).Test()
ClassMethod Test1()
{
	s aa = "<QueryItem><OperationItem><Items><Condition>Name</Condition><Operator>like</Operator><Value>1</Value><DataType>S</DataType></Items></OperationItem><OperationItem><Items><Condition>IDCard</Condition><Operator>like</Operator><Value>1</Value><DataType>S</DataType></Items></OperationItem></QueryItem>"
	s reader = ##class(%XML.Reader).%New()
    s xmlobj = ##class(%FileCharacterStream).%New()
    s sc = reader.OpenString(aa)
    d reader.Correlate("QueryItem","DHCEPRFS.Entity.EQueryItems")
    While reader.Next(.obj,.sc)
    {
	    if (obj '= "")
	    for i=1:1:obj.QueryItems.Count()
	    {
		    w obj.QueryItems.GetAt(i).Items
		}
	}
}

/// d ##Class(DHCEPRFS.BL.BLQuery).Test()
ClassMethod Test()
{
	s ResultColumns = "Name,EpisodeID,MedRecordNo,Gender,RegNo,Birthday,Age,IDCard,AdmLoc,DisLoc,AdmNum,InNum,AdmDate,AdmTime,DisDate,HospitalDays,DiagMainDesc,Oper01Desc,DisTime,DeathDate,DeathTime,AdmWard,DisWard,MainDoctor,TransDept,PayMode,AllPay,LocManager,SeniorDoc,InHospitlDoc,QualityDoc,Oper01Level,Oper01AnaMethod,PatientID,CompanyCode,Marriage,Nationality,InsuType,InsuNo,PhoneNo,LinkName,LinkRelation,LinkPhone,Occupation,Company,Worktel,HouseProvince,HouseCity,HouseArea,IsAdvancedSecurity"
	//s aa = "<QueryItem><OperationItem><Items><Condition>Name</Condition><Operator>like</Operator><Value>测试</Value><DataType>S</DataType></Items></OperationItem><OperationItem><Items><Condition>IDCard</Condition><Operator>like</Operator><Value>1</Value><DataType>S</DataType></Items></OperationItem></QueryItem>"
	//s aa = "<QueryItem><OperationItem><Items><Condition>DisLoc</Condition><Operator>=</Operator><Value>群力儿内科</Value><DataType>S</DataType></Items><Items><Condition>DiagDesc</Condition><Operator>like</Operator><Value>头痛</Value><DataType>S</DataType></Items></OperationItem></QueryItem>"
	//s aa = "<QueryItem><OperationItem><Items><Condition>Death</Condition><Operator>=</Operator><Value>Y</Value><DataType>S</DataType></Items><Items><Condition>MedRecordNo</Condition><Operator>like</Operator><Value>500308</Value><DataType>S</DataType></Items></OperationItem></QueryItem>"
	//s aa = "<QueryItem><OperationItem><Items><Condition>MedRecordNo</Condition><Operator>like</Operator><Value>90669638</Value><DataType>S</DataType></Items></OperationItem></QueryItem>"
	//s aa = "<QueryItem><OperationItem /></QueryItem>"
	s aa = "<QueryItem><OperationItem><Items><Condition>MedRecordNo</Condition><Operator>like</Operator><Value>500307</Value><DataType>S</DataType></Items></OperationItem></QueryItem>"
	s disLoc = "1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18^19^21^44^45^46^47^48^49^50^51^52^53^54^55^56^57^58^59^60^61^62^63^64^65^66^68^69^72^73^75^76^77^78^79^83^84^85^86^87^88^90^91^92^93^94^95^106^117^223^224^233^235^239^250^251^252^254^260^263^264^266^268^269^270^271^275^279^282^285^289^290"
	s reader = ##class(%XML.Reader).%New()
    s xmlobj = ##class(%FileCharacterStream).%New()
    s sc = reader.OpenString(aa)
    d reader.Correlate("QueryItem","DHCEPRFS.Entity.EQueryItems")
    While reader.Next(.obj,.sc)
    {
	    if (obj '= "")
	    s objlist = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLQuery:ComplexQueryList")
	    d objlist.Execute("",62188,63867,disLoc,obj,ResultColumns)
	    //d objlist.Execute("",62943,62974,disLoc,obj,ResultColumns)
        while (objlist.Next())
        {
	        w objlist.Data("MrEpisode"),objlist.Data("c1"),objlist.Data("c2"),objlist.Data("c3"),objlist.Data("c48"),objlist.Data("c98"),!
	    }
	}
}

}

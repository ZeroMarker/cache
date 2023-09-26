Class web.DHCBL.MKB.MKBICDRely Extends %RegisteredObject
{

/// w ##class(web.DHCBL.MKB.MKBICDRely).SortExp("3245:980*68,674:S86*S2")
ClassMethod SortExp(DiagStr)
{
	q:DiagStr="" ""
	s len = $L(DiagStr,",")
	for i=1:1:len
	{
		s ProDet = $P(DiagStr,",",i)
		s Pro = $P(ProDet,":",1)
		s Dets = $P(ProDet,":",2)
		s DetLen = $L(Dets,"*")
		for j=1:1:DetLen
		{
			s Det=$P(Dets,"*",j)
			if (Det["S")
			{
				s arr(Pro,$P(Det,"S",2))="S"	
			}	
			else
			{
				s arr(Pro,Det)=""	
			}
		}
	}
	s result=""
	s Pro=0
	for
	{
		s Pro=$O(arr(Pro))
		q:Pro=""
		
		s subresult=""
		s Det=0
		for
		{
			s Det=$O(arr(Pro,Det))
			q:Det=""
			
			s:subresult'="" subresult=subresult_"*"_arr(Pro,Det)_Det
			s:subresult="" subresult=arr(Pro,Det)_Det	
		}	
		s:result'="" result=result_","_Pro_":"_subresult
		s:result="" result=Pro_":"_subresult
	}
	q result
}

/// HISICD对照界面保存/修改时
/// ID:子表ID，TermId:中心词ID Exp:结构化表达式
/// d ##class(web.DHCBL.MKB.MKBICDRely).SaveData()
ClassMethod SaveData(ID, TermId, Exp)
{
	TS
	s result=""
	s MKBIRRowId=$O(^User.MKBICDRelyI("ICRIdIndex",ID,0))
	if (MKBIRRowId'="")
	{
		d ..Delete(ID)
	}
	s obj = ##class(User.MKBICDRely).%New()
	d obj.MKBIRICRIdSetObjectId(ID)
	d obj.MKBIRTermSetObjectId(TermId)
	s obj.MKBIRSortValue=..SortExp(Exp)
	s sc = obj.%Save()
	if $$$ISOK(sc)
	{
		tc
		s result = result= "{success:'true',id:'"_obj.%Id()_"'}" 
	}
	else
	{
		tro
		s result = result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
		;s result=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)	
	}	
	
	q result
}

/// HISICD对照界面子表记录删除时调取
/// 根据传入的子表ID删除对应记录
/// d ##class(web.DHCBL.MKB.MKBICDRely).Delete()
ClassMethod Delete(ID)
{
	s MKBIRRowId=$O(^User.MKBICDRelyI("ICRIdIndex",ID,0))
	d ##class(User.MKBICDRely).%DeleteId(MKBIRRowId)
}

/// d ##class(web.DHCBL.MKB.MKBICDRely).SaveAll()
ClassMethod SaveAll()
{
	TS
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
			
			s TermId=$LG($G(^User.MKBHISICDContrastD(MKBHICRRowId,"MKBHISICDContrastResult",ChildSub)),4)
			s ResultID=$LG($G(^User.MKBHISICDContrastD(MKBHICRRowId,"MKBHISICDContrastResult",ChildSub)),2)	
			
			if (ResultID'["-")
			{
				s result=..SaveData(MKBHICRRowId_"||"_ChildSub,TermId,ResultID)
				b:result["false"	
			}
		}
	}
}

}

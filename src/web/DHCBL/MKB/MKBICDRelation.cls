/// Creator:李欣
/// Date:20180410
/// Table:User.MKBICDRelation
Class web.DHCBL.MKB.MKBICDRelation Extends %RegisteredObject
{

/// Desc:获取主列表数据的query方法
/// Creator:李欣
/// Date:20180410
/// Input:rowid desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDRelation","GetRelationList","","")
Query GetRelationList(rowid As %String, desc As %String) As %Query(ROWSPEC = "MKBICDRRowId,MKBICDRDiag,MKBICDRDiagDesc,MKBICDRBJDr,MKBICDRBJICD,MKBICDRBJNote,MKBICDRBJState,MKBICDRInterCode1,MKBICDRInterCode2,MKBICDRHisICD,MKBICDRHisNote,MKBICDRHisState,MKBICDRHisDr")
{
}

ClassMethod GetRelationListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s base=..GetTermBaseIDByDesc("诊断_ICD10国际码")
	if (rowid'="")
	{
		s MKBICDRRowId=rowid
		s MKBICDRDiag = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),2)
		s MKBICDRDiagDesc = ""
		if (MKBICDRDiag["&")
		{
			s Len = $L(MKBICDRDiag,"&")
			for i=1:1:Len
			{
				s DiagIDs = $P(MKBICDRDiag,"&",i)
				s temp = ..GetDiagDesc(DiagIDs)
				s:MKBICDRDiagDesc="" MKBICDRDiagDesc=temp
				s:MKBICDRDiagDesc'="" MKBICDRDiagDesc=MKBICDRDiagDesc_"</br>"_temp
			}
		}
		else
		{
			s MKBICDRDiagDesc = ..GetDiagDesc(MKBICDRDiag)	
		}
		s MKBICDRBJDr = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),3)
		s MKBICDRBJCode= ""
		s MKBICDRBJDesc= ""
		if (MKBICDRBJDr'="")
		{
			s MKBICDRBJCode=$LG($G(^User.MKBTermD(MKBICDRBJDr)),2)
			s MKBICDRBJDesc=$LG($G(^User.MKBTermD(MKBICDRBJDr)),3) 
		}
		s MKBICDRBJICD = MKBICDRBJCode_"<br/><br/>"_MKBICDRBJDesc
		s MKBICDRBJNote = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),6)
		s MKBICDRBJState = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),7)
		
		s MKBICDRInterCode1=$LG($G(^User.MKBICDRelationD(MKBICDRRowId)),4)
		s Tip=""
		if (MKBICDRBJCode'="")
		{
			if (($ZCONVERT(MKBICDRInterCode1,"U")'=$ZCONVERT($e(MKBICDRBJCode,0,5),"U"))&($ZCONVERT(MKBICDRInterCode1,"U")'=$ZCONVERT($e(MKBICDRBJCode,0,5)_"†","U"))&($ZCONVERT(MKBICDRInterCode1,"U")'=$ZCONVERT($e(MKBICDRBJCode,0,5)_"+","U")))
			{
				s Tip="不一致"
			}
			if (base'="")&(MKBICDRInterCode1'="")
			{
				if ($O(^User.MKBTermI("DescIndex",base,MKBICDRInterCode1,""))="")
				{
					s Tip="不存在"	
					if ($D(^User.MKBTermI("DescIndex",base,MKBICDRInterCode1_"†")))||($D(^User.MKBTermI("DescIndex",base,MKBICDRInterCode1_"+")))
					{
						s Tip="少箭号"	
					}
				}
			}	
		}
		s MKBICDRInterCode2=$LG($G(^User.MKBICDRelationD(MKBICDRRowId)),5)
		s MKBICDRHis10Code = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),8)
		s MKBICDRHisDesc = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),9)
		s MKBICDRHisCode = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),12)
		s MKBICDRHisDr = ..GetMRCId(MKBICDRHis10Code,MKBICDRHisCode,MKBICDRHisDesc)
		s MKBICDRHisICD =MKBICDRHisCode_"</br></br>"_ MKBICDRHisDesc
		
		s MKBICDRHisNote=$LG($G(^User.MKBICDRelationD(MKBICDRRowId)),10)
		s MKBICDRHISState = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),11)

		d OutputRowRelation
	}
	else{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s MKBICDRRowId = 0
		for  
		{	
			s MKBICDRRowId = $O(^User.MKBICDRelationD(MKBICDRRowId)) 
			q:MKBICDRRowId="" 
			s OutFlag=""
			s MKBICDRDiag = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),2)
			s MKBICDRDiagDesc = ""
			if (MKBICDRDiag'="")
			{
				if (MKBICDRDiag'["&")
				{
					s MKBICDRDiagDesc = ..GetDiagDesc(MKBICDRDiag)	
					if (MKBICDRDiagDesc[desc)
					{
						s OutFlag="Y"	
					} 
					s Diag1=$P(MKBICDRDiag,"-",1)
					if (OutFlag'="Y")
					{
						s OutFlag=..GetComHasFlag(Diag1,desc)	
					}	
				}
				else
				{
					s Len = $L(MKBICDRDiag,"&")
					for i=1:1:Len
					{
						s DiagIDs = $P(MKBICDRDiag,"&",i)
						if (OutFlag'="Y")
						{
							s OutFlag=..GetComHasFlag($P(DiagIDs,"-",1),desc)	
						}
						s temp = ..GetDiagDesc(DiagIDs)
						s:MKBICDRDiagDesc="" MKBICDRDiagDesc=temp
						s:MKBICDRDiagDesc'="" MKBICDRDiagDesc=MKBICDRDiagDesc_"</br>"_temp
						if (OutFlag'="Y")
						{
							if (MKBICDRDiagDesc[desc)
							{
								s OutFlag="Y"	
							}	
						}
					}	
				}
			}

			
			
			s MKBICDRBJDr = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),3)
			s MKBICDRBJCode= ""
			s MKBICDRBJDesc= ""
			if (MKBICDRBJDr'="")
			{
				s MKBICDRBJCode=$LG($G(^User.MKBTermD(MKBICDRBJDr)),2)
				s MKBICDRBJDesc=$LG($G(^User.MKBTermD(MKBICDRBJDr)),3) 
			}
			s MKBICDRBJICD = MKBICDRBJCode_"<br/><br/>"_MKBICDRBJDesc
			if (OutFlag'="Y")
			{
				if (MKBICDRBJICD[desc)
				{
					s OutFlag="Y"	
				}	
			}
			s MKBICDRBJNote = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),6)
			s MKBICDRBJState = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),7)
			
			s MKBICDRInterCode1=$LG($G(^User.MKBICDRelationD(MKBICDRRowId)),4)
			s Tip=""
			if (MKBICDRBJCode'="")
			{
				if (($ZCONVERT(MKBICDRInterCode1,"U")'=$ZCONVERT($e(MKBICDRBJCode,0,5),"U"))&($ZCONVERT(MKBICDRInterCode1,"U")'=$ZCONVERT($e(MKBICDRBJCode,0,5)_"†","U"))&($ZCONVERT(MKBICDRInterCode1,"U")'=$ZCONVERT($e(MKBICDRBJCode,0,5)_"+","U")))
				{
					s Tip="不一致"
				}
				if (base'="")&(MKBICDRInterCode1'="")
				{
					if ($O(^User.MKBTermI("DescIndex",base,MKBICDRInterCode1,""))="")
					{
						s Tip="不存在"	
						if ($D(^User.MKBTermI("DescIndex",base,MKBICDRInterCode1_"†")))||($D(^User.MKBTermI("DescIndex",base,MKBICDRInterCode1_"+")))
						{
							s Tip="少箭号"	
						}
					}
				}	
			}
			s MKBICDRInterCode2=$LG($G(^User.MKBICDRelationD(MKBICDRRowId)),5)
			if (OutFlag'="Y")
			{
				if (MKBICDRInterCode1[desc)
				{
					s OutFlag="Y"	
				}	
			}
			
			s MKBICDRHis10Code = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),8)
			s MKBICDRHisDesc = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),9)
			s MKBICDRHisCode = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),12)
			
			s MKBICDRHisDr = ..GetMRCId(MKBICDRHis10Code,MKBICDRHisCode,MKBICDRHisDesc)
			s MKBICDRHisICD =MKBICDRHisCode_"</br></br>"_ MKBICDRHisDesc
			if (OutFlag'="Y")
			{
				if (MKBICDRHisICD[desc)
				{
					s OutFlag="Y"	
				}
			}
			s MKBICDRHisNote=$LG($G(^User.MKBICDRelationD(MKBICDRRowId)),10)
			s MKBICDRHisState = $LG($G(^User.MKBICDRelationD(MKBICDRRowId)),11)
			
			if (OutFlag="Y")
			{
				d OutputRowRelation
			}		
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowRelation
    set Data=$lb(MKBICDRRowId,MKBICDRDiag,MKBICDRDiagDesc,MKBICDRBJDr,MKBICDRBJICD,MKBICDRBJNote,MKBICDRBJState,MKBICDRInterCode1,MKBICDRInterCode2,MKBICDRHisICD,MKBICDRHisNote,MKBICDRHisState,MKBICDRHisDr)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRelationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRelationListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRelationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRelationListExecute ]
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

/// Desc:根据传入的术语id，判断术语常用名，别名及检索码是否包含desc
/// Creator:李欣
/// Date:20180410
/// Input:termid : 术语id desc : 要判断包含的字符串
/// Other:
ClassMethod GetComHasFlag(termid, desc)
{
	s Com = ""
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s Flag="N"
	s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",termid," 常用名",0))
	s MKBTEPChildSub = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 检索码",0))
	s MKBTEPRowId = MKBTPRowId_"||"_MKBTEPChildSub
	s MKBTPDRowId = 0
	for
	{
		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
		q:MKBTPDRowId=""
		s Com=Com_"&%"_$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		s MKBTEPVRowId = $O(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))
		s Com=Com_"&%"_$LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)
	}
	if (Com[desc)
	{
		s Flag="Y"	
	}
	q Flag
}

/// Desc:通过术语库注册描述获取术语库注册id
/// Creator:李欣
/// Date:20180410
/// Input:desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDRelation","GetRelationList","","")
ClassMethod GetTermBaseIDByDesc(desc)
{
	q:desc="" ""
	s desc= $ZCONVERT(desc,"U")
	s ID = $O(^User.MKBTermBaseI("DescIndex"," "_desc,0))
	q ID
}

/// Desc:根据传入的id串获取对应的诊断描述
/// Creator:李欣
/// Date:20180410
/// Input:ids : 诊断代码串
/// Other:w ##class(web.DHCBL.MKB.MKBICDRelation).GetDiagDesc("14626-1898:3130")
ClassMethod GetDiagDesc(ids As %String) As %String
{
	;w ##class(web.DHCBL.MKB.TKBICDRelation).GetDiagDesc("10-6:")
	s result=""
	if (ids'=""){
		s termId=$p(ids,"-",1) //诊断id
		s termDesc=..GetICDTermInfo(termId)	//获取术语描述
		s property=$p(ids,"-",2) //属性及内容多条
		if (property'=""){
			s extendDesc=""
			s propertyLen=$Length(property,",")
			for i=1:1:propertyLen
			{
				s extend=$p(property,",",i)
				s extendId=$p(extend,":",1)
				s detailIds=$p(extend,":",2)
				s detailDesc=..GetICDPDInfo(extendId,detailIds)	
				if (extendDesc="")
				{
					s extendDesc=detailDesc
				}else
				{
					s extendDesc=extendDesc_detailDesc
				}
			}
			s result=termDesc_extendDesc
		}
		else
		{
			s result=termDesc
		}
	}
	q result
}

/// 获取临床实用诊断术语描述
/// Input:termid-术语User.MKBTrem表的ID
/// return:术语描述
/// Debug: w ##class(web.DHCBL.MKB.MKBICDRelation).GetICDTermInfo(14495)
ClassMethod GetICDTermInfo(termid As %String) As %String
{
	s result=""
	if (termid'="")
	{ 
		s termDesc = $LG($G(^User.MKBTermD(termid)),3) //术语描述
		s termCode = $LG($G(^User.MKBTermD(termid)),2) //术语代码	
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",termid," 常用名",0))
		if (MKBTPRowId="")
		{
			s result=termDesc
		}
		else
		{
			S MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) 
			if (MKBTPDDesc'="")
			{
				s result=MKBTPDDesc
			}
			else
			{
				s result=termDesc	//如果常用名为空则常用名=诊断中心词
			} 	
		}	
	}
	q result
}

/// 获取属性描述及属性内容信息（多条）
/// Input:proid-属性User.MKBTermProperty表的ID  detailIds-属性内容User.MKBTermProDetail表的ID
/// return:属性描述=属性内容1,属性内容2
/// Debug: w ##class(web.DHCBL.MKB.MKBICDRelation).GetICDPDInfo("3","1*2")
ClassMethod GetICDPDInfo(proid As %String, detailIds As %String) As %String
{
	s detailDesc="",proDesc="",result=""
	if (proid'="")
	{
		s proDesc = $LG($G(^User.MKBTermPropertyD(proid)),3) //属性描述
		s MKBTPType = $LG($G(^User.MKBTermPropertyD(proid)),4) //属性类型
		/*
		if (MKBTPType="TX")  //文本型
		{
			s TKBTDRowId=$o(^TKBTREEXTDTLi(0,"Ext",proid,0))
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",proid,0))
			s:MKBTPDRowId'="" detailDesc=$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			s:detailDesc'="" detailDesc=$tr(detailDesc,$c(10),"")
		}
		elseif (MKBTPType="S")  //引用术语型
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",proid,0))
			s descids=""
			s:MKBTPDRowId'="" descids=$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			if (descids'="")
			{
				s argsLen=$Length(descids,",")
			    for i=1:1:argsLen   
			    {     
			        s MKBTRowId=$p(descids,",",i)
				    s MKBTDesc=$LG($G(^User.MKBTermD(MKBTRowId)),3)
				    s:detailDesc'="" detailDesc=detailDesc_","_TKBTRBDesc
				    s:detailDesc="" detailDesc=TKBTRBDesc
			    }
			}
		}
		elseif(MKBTPType="P")  //为引用属性型
		{ 
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",proid,0)) //属性内容表ID
			s descStr=""
			s:MKBTPDRowId'="" descStr=$LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3) //属性内容
			if (descStr'="")
			{
				s argsLen=$Length(descStr,",")
			    for i=1:1:argsLen   
			    {     
			      s descAndType=$p(descStr,",",i)  //术语属性id&展示类型
			      s TKBTERowId=$p(descAndType,"*",1)  //术语属性id
				  s TKBTEDesc=$p($g(^TKBTREEXT(TKBTERowId)),"^",2)  //术语属性描述
				  s:detailDesc'="" detailDesc=detailDesc_","_TKBTEDesc
				  s:detailDesc="" detailDesc=TKBTEDesc
			    }
			}
			
		}
		*/
		if (MKBTPType="T")||(MKBTPType="L")  //树形或列表型
		{
			if (detailIds'="")
			{ 
				s detailIdLen=$Length(detailIds,"*")
				for i=1:1:detailIdLen
				{
					s detailId=$p(detailIds,"*",i)	
					s detailDescp=$LG($G(^User.MKBTermProDetailD(detailId)),3) //属性内容描述	
					if (detailDesc="")
					{
						s detailDesc=detailDescp
					}
					else
					{
						s detailDesc=detailDesc_","_detailDescp
					}				
				}
					
			}
		}
	}
	if (detailDesc'="")
	{
		s result="("_proDesc_"="_detailDesc_")"
	}
	q result
}

/// Desc:根据传入的desc选取对应的HISICD条目
/// Creator:李欣
/// Date:20180410
/// Input:rowid,desc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDRelation","GetHisICD","","")
Query GetHisICD(rowid, desc) As %Query(ROWSPEC = "ID,ICD")
{
}

ClassMethod GetHisICDExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s total=0
	s:desc'="" desc=$ZCONVERT(desc,"U")
	if (desc[" ")
	{
		s desc1 = $p(desc," ",1)
		s desc2 = $p(desc," ",2)	
	}
	else
	{
		s desc1=""
		s desc2=desc	
	}
	if (rowid'="")
	{
		s ID = rowid
		s Code = $p($g(^MRC("ID",rowid)),"^",4)	
		s Desc = $p($g(^MRC("ID",rowid)),"^",2)	
		s ICD = Code_"   "_Desc
		s ICD = ##class(ext.util.String).EvalJSON(ICD)
		d OutputRowHisICD
	}
	else
	{
		s ID = 0
		for
		{
			s ID = $o(^MRC("ID",ID))
			q:ID=""
			s Code = $p($g(^MRC("ID",ID)),"^",4)
			s Desc = $p($g(^MRC("ID",ID)),"^",2)
			s Desc=$tr(Desc,"'","")
			//continue:Desc["'"
			s ICD = Code_"   "_Desc
			s ICD = ##class(ext.util.String).EvalJSON(ICD)
			if (ICD[desc1)&(ICD[desc2)
			{
				d OutputRowHisICD
				s total=total+1
			}
		}
	}	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowHisICD
    set Data=$lb(ID,ICD)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHisICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHisICDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHisICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHisICDExecute ]
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

ClassMethod DiagIsValid(ids)
{
}

/// Creator：李欣
/// CreatDate: 20180410
/// Description：保存修改内容
/// Table：User.MKBICDRelation
/// Input：web.Entity.MKB.MKBICDRelation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.MKB.MKBICDRelation) As %String
{
	
	s result = ""

	if $IsObject(eobj)
	{
		if (eobj.MKBICDRRowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(User.MKBICDRelation).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(User.MKBICDRelation).%OpenId(eobj.MKBICDRRowId)
			s bobj = ##class(web.Entity.MKB.MKBICDRelation).%New()
			s bobj.MKBICDRRowId = eobj.MKBICDRRowId
			s bobj.MKBICDRDiag=  obj.MKBICDRDiag
			s:obj.MKBICDRBJDr'="" bobj.MKBICDRBJDr = obj.MKBICDRBJDr.%Id()
			s bobj.MKBICDRInterCode1 = obj.MKBICDRInterCode1
			s bobj.MKBICDRInterCode2 = obj.MKBICDRInterCode2
			s bobj.MKBICDRBJNote = obj.MKBICDRBJNote
			s bobj.MKBICDRBJState = obj.MKBICDRBJState
			s bobj.MKBICDRHis10Code = obj.MKBICDRHis10Code
			S bobj.MKBICDRHisCode = obj.MKBICDRHisCode
			s bobj.MKBICDRHisDesc = obj.MKBICDRHisDesc
			s bobj.MKBICDRHisNote = obj.MKBICDRHisNote
			s bobj.MKBICDRHisState  = obj.MKBICDRHisState
		}
		if (eobj.MKBICDRDiag["ERROR")||(eobj.MKBICDRDiag="")
		{
			s result = "{success:'false',errorinfo:'有毛病'}"
			q result
		}
		s obj.MKBICDRDiag = ##class(web.DHCBL.MKB.MKBDaigCombox).DealStr(eobj.MKBICDRDiag)
		if (obj.MKBICDRDiag["ERROR")||(obj.MKBICDRDiag="")
		{
			s errori = $P(obj.MKBICDRDiag,":",2)
			s ^lee(0)=errori
			s result = "{success:'false',errorinfo:'"_errori_"'}"
			q result	
		}
		d:eobj.MKBICDRBJDr'="" obj.MKBICDRBJDrSetObjectId(eobj.MKBICDRBJDr)
		d:eobj.MKBICDRBJDr="" obj.MKBICDRBJDrSetObjectId("")
		s obj.MKBICDRInterCode1 = eobj.MKBICDRInterCode1
		s obj.MKBICDRInterCode2 = eobj.MKBICDRInterCode2
		s obj.MKBICDRBJNote = eobj.MKBICDRBJNote
		s obj.MKBICDRBJState = eobj.MKBICDRBJState
		if (eobj.MKBICDRHisDr'="")
		{
			s obj.MKBICDRHisCode = $P($G(^MRC("ID",eobj.MKBICDRHisDr)),"^",1)
			s obj.MKBICDRHisDesc = $P($G(^MRC("ID",eobj.MKBICDRHisDr)),"^",2)
			s obj.MKBICDRHis10Code = $P($G(^MRC("ID",eobj.MKBICDRHisDr)),"^",4)
		}
		s obj.MKBICDRHisNote = eobj.MKBICDRHisNote
		s obj.MKBICDRHisState = eobj.MKBICDRHisState
		Ts
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			d:eobj.MKBICDRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_ICDRelation","User.MKBICDRelation","ICD映射",id,eobj.MKBICDRDiag,"A",eobj)
			d:eobj.MKBICDRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_ICDRelation","User.MKBICDRelation","ICD映射",eobj.MKBICDRRowId,eobj.MKBICDRDiag,"U",eobj,bobj)
		}else{
			Trollback
			s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD映射","web.DHCBL.MKB.MKBICDRelation","SaveData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}	
	}	
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Creator：李欣
/// CreatDate: 20180410
/// Description：测试SaveData方法
/// Table：User.MKBICDRelation
/// Input：web.Entity.MKB.MKBICDRelation 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Debug: w ##class(web.DHCBL.MKB.MKBICDRelation).SaveTest()
ClassMethod SaveTest()
{
	s eobj=##class(web.Entity.MKB.MKBICDRelation).%New()
	s eobj.MKBICDRDiag = "14626-1898:3134"
	s eobj.MKBICDRBJDr = 32
	s eobj.MKBICDRBJNote =""
	s eobj.MKBICDRBJState = ""
	s eobj.MKBICDRHisCode = "23"
	s eobj.MKBICDRHisDesc = "23"
	s eobj.MKBICDRHisNote = "23"
	s eobj.MKBICDRHisState = "23"
	s eobj.MKBICDRInterCode1 = "23"
	s eobj.MKBICDRInterCode2 = "23"
	s sc = ..SaveData(eobj)	
	q sc
}

/// Creator：李欣
/// CreatDate: 20180410
/// Description：获取MRC表的描述
/// Table：User.MRCICDDx
/// Input：id
/// Return：ICD代码+描述
/// 	Debug: w ##class(web.DHCBL.MKB.MKBICDRelation).GetMRCDesc(56)
ClassMethod GetMRCDesc(id)
{
	q:id="" ""
	s Code = $p($g(^MRC("ID",id)),"^",4)
	s Desc = $p($g(^MRC("ID",id)),"^",2)
	s ICD = Code_"   "_Desc	
	q ICD
}

/// Creator：李欣
/// CreatDate: 20180410
/// Description：获取MRC_ICDDx表rowid
/// Table：User.MRCICDDx
/// Other: w ##class(web.DHCBL.MKB.MKBICDRelation).GetMRCId("a00.001","a00.0001","埃尔托型霍乱")
ClassMethod GetMRCId(code10, code, desc)
{
	q:code="" ""
	q:desc="" ""
	q:code10="" ""
	s:code10'="" code10=$ZCONVERT(code10,"U")
	s:code'="" code=$ZCONVERT(code,"U")
	s code = $TR(code,".","")
	s:desc'="" desc=$ZCONVERT(desc,"U")	
	if ($D(^MRC("ID",0,"Code",code))=0)
	{
		s MRCID=0
		for
		{
			//^MRC("ID",0,"Desc","伤寒性肝炎")
			s MRCID = $O(^MRC("ID",0,"Desc",desc,MRCID))
			q:MRCID=""
			s MRC10Code = $ZCONVERT($P($G(^MRC("ID",MRCID)),"^",4),"U")
			if (MRC10Code=code)
			{
				q	
			}
		}
		q MRCID
	}
	else
	{
		s MRCID = $O(^MRC("ID",0,"Code",code,0))
		s MRCDesc = $ZCONVERT($P($G(^MRC("ID",MRCID)),"^",2),"U")
		s MRC10Code = $ZCONVERT($P($G(^MRC("ID",MRCID)),"^",4),"U")
		if (MRCDesc'=desc)
		{
			q ""	
		}
		else
		{
			q MRCID
		}
	}
}

/// Creator：李欣
/// CreatDate: 20180410
/// Description：获取修改时的记录
/// Table：User.MKBICDRelation
/// Other: w ##class(web.DHCBL.MKB.MKBICDRelation).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.MKB.MKBICDRelation).%New()
	s obj = ##class(User.MKBICDRelation).%OpenId(id)
	s eobj.MKBICDRRowId = id
	//s eobj.MKBICDRDiag = obj.MKBICDRDiag
	s eobj.MKBICDRDiag = ..GetDiagDesc(obj.MKBICDRDiag)
	s eobj.MKBICDRDiagDesc=..GetDiagDesc(eobj.MKBICDRDiag)
	s:obj.MKBICDRBJDr'="" eobj.MKBICDRBJDr = obj.MKBICDRBJDr.%Id()
	s eobj.MKBICDRInterCode1 = obj.MKBICDRInterCode1
	s eobj.MKBICDRInterCode2 = obj.MKBICDRInterCode2
	s eobj.MKBICDRBJNote = obj.MKBICDRBJNote
	s eobj.MKBICDRBJState = obj.MKBICDRBJState
	s eobj.MKBICDRHisCode = obj.MKBICDRHisCode
	s eobj.MKBICDRHisDesc = obj.MKBICDRHisDesc
	s eobj.MKBICDRHis10Code = obj.MKBICDRHis10Code
	s eobj.MKBICDRHisDr = ..GetMRCId(eobj.MKBICDRHis10Code,eobj.MKBICDRHisCode,eobj.MKBICDRHisDesc)
	s eobj.MKBICDRHisNote = obj.MKBICDRHisNote
	s eobj.MKBICDRHisState = obj.MKBICDRHisState
	s str = eobj.JsonS()	
	//s str = "{""data"":["_str_"]}"
	q str
}

/// d ##Class(%ResultSet).RunQuery("web.DHCBL.MKB.MKBICDRelation","GetBJICD","","")
Query GetBJICD(rowid, desc) As %Query(ROWSPEC = "MKBTRowId,ICD")
{
}

ClassMethod GetBJICDExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s base = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10北京码",0))
	q:base="" ""
	if (rowid'="") //如果rowid不为空
	{
		s MKBTRowId=rowid
		s MKBTCode=$LG($G(^User.MKBTermD(MKBTRowId)),2) //代码
		s MKBTDesc=$LG($G(^User.MKBTermD(MKBTRowId)),3)  //描述
		//s MKBTDesc=##class(web.DHCBL.MKB.TKBTrem).EvalJSON(MKBTDesc)
		s ICD = MKBTCode_"   "_MKBTDesc
		s ICD = ##class(ext.util.String).EvalJSON(ICD)
		d OutputRowBJICD	
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		if (desc[" ")
		{
			s desc1 = $p(desc," ",1)
			s desc2 = $p(desc," ",2)	
		}
		else
		{
			s desc1=""
			s desc2=desc	
		}
		s i=1

		if ($d(^User.MKBTermI("BaseIndex",base))'=0)  //该术语库下有数据
		{
			s MKBTRowId=0
			for  
			{	
				s MKBTRowId=$O(^User.MKBTermI("BaseIndex",base,MKBTRowId))
				q:MKBTRowId="" 
				//q:i=30
				s MKBTCode=$LG($G(^User.MKBTermD(MKBTRowId)),2) //代码
				s MKBTDesc=$LG($G(^User.MKBTermD(MKBTRowId)),3)  //描述
				//s MKBTDesc=##class(web.DHCBL.MKB.TKBTrem).EvalJSON(MKBTDesc)
				s ICD = MKBTCode_"   "_MKBTDesc
				s ICD = ##class(ext.util.String).EvalJSON(ICD)
				i (ICD[desc1)&(ICD[desc2)	   //条件
				{
					d OutputRowBJICD
					s i=i+1
				}
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowBJICD
    set Data=$lb(MKBTRowId,ICD)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetBJICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBJICDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBJICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBJICDExecute ]
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

/// Creator:李欣
/// CreatDate:20180411
/// Description:根据id删除
/// Table:User.MKBICDRelation
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.MKB.MKBICDRelation).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.MKB.MKBICDRelation).%New()
		s pobj = ##class(User.MKBICDRelation).%OpenId(id)
		s eobj.MKBICDRRowId = id
		s eobj.MKBICDRDiag = pobj.MKBICDRDiag
		s:pobj.MKBICDRBJDr'="" eobj.MKBICDRBJDr = pobj.MKBICDRBJDr.%Id()
		s eobj.MKBICDRInterCode1 = pobj.MKBICDRInterCode1
		s eobj.MKBICDRInterCode2 = pobj.MKBICDRInterCode2
		s eobj.MKBICDRBJNote = pobj.MKBICDRBJNote
		s eobj.MKBICDRBJState = pobj.MKBICDRBJState
	
		s sc=##class(User.MKBICDRelation).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_ICDRelation","User.MKBICDRelation","ICD映射",id,eobj.MKBICDRDiag,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD映射","web.DHCBL.MKB.MKBICDRelation","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
		}
	q result
}

}

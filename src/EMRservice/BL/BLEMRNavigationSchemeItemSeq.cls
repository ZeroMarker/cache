/// 名称：		EMRservice.BL.BLEMRNavigationSchemeItemSeq
/// 描述：		方案明细科室排序BL层
/// 编写者：	yejian
/// 编写时间：	2019-11-4
Class EMRservice.BL.BLEMRNavigationSchemeItemSeq Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationSchemeItem","SelectCtLoc")
Query SelectCtLoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLocGroupID:%String,CTLocGroupName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectAllLoc, SqlProc ]
{
    SELECT t.CTLocGroupID,t.CTLocGroupName
    FROM EMRmeta.EMRNavigationSchemeItemSeq t
    GROUP BY CTLocGroupID
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLEMRNavigationSchemeItem","SelectAllDetails","12||1")
Query SelectAllItemByLoc(CtLocGID As %String, aSchemeCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,SchemeCode:%String,ItemCode:%String,ItemName:%String,ItemID:%String,ItemSeq:%String,CTLocGroupID:%String,CTLocGroupName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMRITEMS_SelectAllItemByLoc, SqlProc ]
{
    SELECT t.ID,t.SchemeCode,t.ItemCode,t.ItemName,t.ItemID,t.ItemSeq,t.CTLocGroupID,t.CTLocGroupName
    FROM EMRmeta.EMRNavigationSchemeItemSeq t
    WHERE t.CTLocGroupID = :CtLocGID And t.SchemeCode = :aSchemeCode
    ORDER BY t.ItemSeq
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String
{
	&sql(select max(id) into :IdexCode from EMRmeta.EMRNavigationSchemeItemSeq)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 根据科室创建项目排序
ClassMethod CreateSchemeItemsByLoc(CTLocGroupID As %String, CTLocGroupName As %String) As %String
{
	/// b "s"
	s strReslt = "1"	
	
	s SchemeCode = ""
	for
	{
		s SchemeCode = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq",SchemeCode))
		q:(SchemeCode = "")
		s itemSeq = ""
		for
		{
			s itemSeq = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq",SchemeCode,itemSeq))
			q:(itemSeq = "")
			s itemrid = ""
			for
			{
				s itemrid = $o(^DHCEMRM.EMRNavSchemeItemI("IdxItemSeq",SchemeCode,itemSeq,itemrid))
				q:(itemrid = "")
				s objItem = ##class(EMRmeta.EMRNavigationSchemeItem).%OpenId(itemrid)
				s objSchemeItemSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%New()
				S objSchemeItemSeq.SchemeCode = objItem.SchemeCode
				s objSchemeItemSeq.ItemID = objItem.%Id()
				s objSchemeItemSeq.ItemCode = objItem.ItemCode
				s objSchemeItemSeq.ItemName = objItem.ItemName
				
				s objSchemeItemSeq.CTLocGroupID = CTLocGroupID
				s objSchemeItemSeq.CTLocGroupName =CTLocGroupName
				s sc = objSchemeItemSeq.%Save()
				if ($$$ISOK(sc))
				{
				   s seqID = objSchemeItemSeq.%Id()
				   s objSchemeItemSeq.ItemSeq = seqID
				   s sc =  objSchemeItemSeq.%Save()
				}
				else
				{
					s strReslt = "-1"	
				}
			}
		}
	}
	q strReslt
}

/// 创建一个项目
ClassMethod CreateSchemeItemSeq(itemrid As %String) As %String
{
	/// b "s"
	s strReslt = "-1"	
	s ds =  ##Class(%Library.ResultSet).%New("EMRservice.BL.BLEMRNavigationSchemeItemSeq:SelectCtLoc")
	d ds.Execute()
	While (ds.Next())
	{
		s strCTLocGroupID = ds.Data("CTLocGroupID")
		s strCTLocGroupName = ds.Data("CTLocGroupName")
		s objItem = ##class(EMRmeta.EMRNavigationSchemeItem).%OpenId(itemrid)
		s objSchemeItemSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%New()
		S objSchemeItemSeq.SchemeCode = objItem.SchemeCode
		s objSchemeItemSeq.ItemID = objItem.%Id()
		s objSchemeItemSeq.ItemCode = objItem.ItemCode
		s objSchemeItemSeq.ItemName = objItem.ItemName
		
		s objSchemeItemSeq.CTLocGroupID = strCTLocGroupID
		s objSchemeItemSeq.CTLocGroupName =strCTLocGroupName
		s sc = objSchemeItemSeq.%Save()
		if ($$$ISOK(sc))
		{
		   s seqID = objSchemeItemSeq.%Id()
		   s objSchemeItemSeq.ItemSeq = seqID
		   s sc =  objSchemeItemSeq.%Save()
		}
		else
		{
			s strReslt = "-1"	
		}
	}
	
	q strReslt
}

/// 更新一个数据元范畴
/// w ##Class(EMRservice.BL.BLEMROrganSchemeDetails).UpdateSequences("13||1||24^2,13||1||27^24")
ClassMethod UpdateSequences(argStr As %String) As %String
{
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		S argstrItem= $P(argStr,",",I)
		S argID = $P(argstrItem,"^",1)
		S argSeq = $P(argstrItem,"^",2)
		if ($d(argID)=0)||($d(argSeq)=0)||(argID="")||(argSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objEntity="",result=""
		s objEntity=##class(EMRmeta.EMRNavigationSchemeItemSeq).%OpenId(argID)
		if (objEntity ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objEntity.ItemSeq=argSeq
		s result=""
		if '(objEntity.%Save())
		{
			TROLLBACK
			s strMrk = 0
		    quit
		}
	 }
	 if (strMrk = 0)
	 {
		 TROLLBACK
		 quit 0
	 }
	TCOMMIT
	Quit 1
}

/// 删除一个项目
ClassMethod DeleteSchemeItemSeqByID(aItemID As %String) As %String
{
	s result = "1"
    q:(aItemID ="") result
    s arowID = ""
    for
	{
		s arowID = $o(^DHCEMRM.EMRNavSchemeItemSeqI("IdxItemID"," "_aItemID,arowID))
		q:(arowID = "")
	    s objSchemeItemSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%OpenId(arowID)
		q:(objSchemeItemSeq="")
		s sc = ##class(EMRmeta.EMRNavigationSchemeItemSeq).%DeleteId(arowID)
		if ('$$$ISOK(sc))
		{	
			s result = "-1"
		}
	}
	q result
}

/// 删除一个项目
ClassMethod DeleteSchemeItemSeqByLoc(aCTLocGroupID As %String) As %String
{
    s result = "1"
    q:(aCTLocGroupID ="") result
    s arowID = ""
    for
	{
		s arowID = $o(^DHCEMRM.EMRNavSchemeItemSeqI("IdxLocGID"," "_aCTLocGroupID,arowID))
		q:(arowID = "")
	    s objSchemeItemSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeq).%OpenId(arowID)
		q:(objSchemeItemSeq="")
		s sc = ##class(EMRmeta.EMRNavigationSchemeItemSeq).%DeleteId(arowID)
		if ('$$$ISOK(sc))
		{	
			s result = "-1"
		}
	}
	 s arowLocID = ""
    for
	{
		s arowID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxCTLocGID"," "_aCTLocGroupID,arowID))
		q:(arowID = "")
	    s objSchemeItemSeq = ##Class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%OpenId(arowID)
		q:(objSchemeItemSeq="")
		s sc = ##class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%DeleteId(arowID)
		if ('$$$ISOK(sc))
		{	
			s result = "-1"
		}
	}
	q result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定DocID下的所有科室ID
/// Input: aSchemeCode,aItemCode
/// Return: 科室1^科室2^科室3
ClassMethod GetItemLoc(CTLocGroupID As %String) As %String
{
	q:(($d(CTLocGroupID) = 0)||(CTLocGroupID = "")) ""
	s result = ""
	
	&sql(declare myCursor cursor for
		select CTLocID into :groupid from EMRmeta.EMRNavigationSchemeItemSeqLoc
		where CTLocGroupID = :CTLocGroupID)
	&sql(open myCursor)
	for {
		&sql(fetch myCursor)
		q:(SQLCODE)
		
		if result = ""
		{	s result = groupid}
		else
		{	s result =  result_"^"_groupid}
	}
	&sql(close myCursor)
	
	q result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的科室
/// Input: aSchemeCode,aItemCode--itemcode^itemname sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(CTLocGroupID As %String, sltLocs As %String, unSltLocs As %String) As %String
{
	q:((CTLocGroupID="")|| (CTLocGroupID = $c(0))) "0"
	s reslut = "1"
	s strItemCode = $p(CTLocGroupID,"^",1)
	s strItemName = $p(CTLocGroupID,"^",2)
	if ((sltLocs = "") || (sltLocs = $c(0)))
	{
		s sltLocsCount = 0
	}
	else
	{
		s sltLocsCount = $l(sltLocs, "^")
	}
	
	if ((unSltLocs = "") || (unSltLocs = $c(0)) )
	{
		s unSltLocsCount = 0
	}
	else
	{
		s unSltLocsCount = $l(unSltLocs, "^")
	}

	//保存选中的科室
	s i = 1
	WHILE (i <= sltLocsCount) 
	{
		s curSltLocID = $p(sltLocs, "^", i)
		s strcurSltLocID = curSltLocID
		S strcurSltLocName = $p($g(^CTLOC(curSltLocID)),"^",2)
		if (curSltLocID '= "")
		{
			//添加科室关联验证是否其他分组已关联科室。
			s strGroupID = ""
			s blnCmark = "0"
			for
			{
				s strGroupID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxLocIDGID"," "_curSltLocID,strGroupID))
				q:(strGroupID="")
				S strGroupID = $tr(strGroupID," ")
				if ((strGroupID '="")&&(strGroupID'=$zcvt(strItemCode,"U")))
				{
					s reslut = reslut _"^"_strGroupID_" 已关联 "_strcurSltLocName
					s blnCmark = "1"
					s i = i + 1
					q	
				}
			}
			continue:(blnCmark ="1")
					
			s docLocRowID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxCodeCTLocID", " "_$zcvt(strItemCode,"U"), " "_strcurSltLocID, 0))
			//如果没有,则新增;有则不处理
			if (docLocRowID = "")
			{
				s objNavSchemeItemLoc = ##class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%New()
				q:(objNavSchemeItemLoc = "")
				
				s objNavSchemeItemLoc.CTLocGroupID = strItemCode
				s objNavSchemeItemLoc.CTLocGroupName = strItemName
				s objNavSchemeItemLoc.CTLocID = strcurSltLocID
				s objNavSchemeItemLoc.CTLocDesc = strcurSltLocName
				d objNavSchemeItemLoc.%Save()
				d objNavSchemeItemLoc.%Close()
				s objNavSchemeItemLoc = ""
			}
		}
		
		s i = i + 1
	}
	
	//删除未选中的科室
	s i = 1
	WHILE (i <= unSltLocsCount) 
	{
		s curUnSltLocID = $p(unSltLocs, "^", i)
		//s strcurSltLocID = $p(curUnSltLocID,"|",1)
		s strcurSltLocID =curUnSltLocID
		if (strcurSltLocID '= "")
		{
			s itemLocRowID = $o(^DHCEMRM.EMRNavSchemeItemSeqLocI("IdxCodeCTLocID", " "_$zcvt(strItemCode,"U"), " "_strcurSltLocID, 0))
			//如果有,则删除; 没有则不处理
			if (itemLocRowID '= "")
			{
				d ##class(EMRmeta.EMRNavigationSchemeItemSeqLoc).%DeleteId(itemLocRowID)
			}
		}
		
		s i = i + 1
	}
	
	//返回
	q reslut
}

}

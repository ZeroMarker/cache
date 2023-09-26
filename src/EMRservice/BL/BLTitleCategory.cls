Class EMRservice.BL.BLTitleCategory Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectAllTitleCategory() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TitleCategoryName:%String,TitleCategoryType:%String,PropertyParams:%String,Sequence:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TitleCategory_SelectAllTitleCategory, SqlProc ]
{
	SELECT ID,TitleCategoryName,TitleCategoryType,PropertyParams,Sequence
	FROM EMRmeta.TitleCategory ORDER BY Sequence ASC
}

/// 创建一个目录
ClassMethod CreateTitleCategory(aETitleCategory As EMRservice.entity.ETitleCategory) As %String [ WebMethod ]
{
	TStart
	s ret = 1
	set objTitle=##class(EMRmeta.TitleCategory).%New()
	q:(objTitle="") ""
	s objTitle.TitleCategoryName=$case(aETitleCategory.TitleCategoryName,$c(0):"",:aETitleCategory.TitleCategoryName)		
	s objTitle.TitleCategoryType=$case(aETitleCategory.TitleCategoryType,$c(0):"",:aETitleCategory.TitleCategoryType)
	s objTitle.PropertyParams=$case(aETitleCategory.PropertyParams,$c(0):"",:aETitleCategory.PropertyParams)
	s objTitle.PropertyParams=$case(aETitleCategory.PropertyParams,$c(0):"",:aETitleCategory.PropertyParams)
	if (objTitle.%Save())
	{		
		s ret=objTitle.%Id()
		s objTitle.Sequence=ret
		if (objTitle.%Save())
		{
			 TCommit
		}
		else
		{
			TRollback
			s ret=-1
		}
	}
	else
	{
		TRollback
		s ret=-1
	}
	d objTitle.%Close()	
	k objTitle
	q ret
}

/// 更新一个目录
ClassMethod UpdateTitleCategory(aETitleCategory As EMRservice.entity.ETitleCategory) As %String [ WebMethod ]
{
	/// b "s"	
	set objTitle=##class(EMRmeta.TitleCategory).%OpenId(aETitleCategory.ID)
	q:(objTitle="") ""	
	s objTitle.TitleCategoryName=$case(aETitleCategory.TitleCategoryName,$c(0):"",:aETitleCategory.TitleCategoryName)		
	s objTitle.TitleCategoryType=$case(aETitleCategory.TitleCategoryType,$c(0):"",:aETitleCategory.TitleCategoryType)
	s objTitle.PropertyParams=$case(aETitleCategory.PropertyParams,$c(0):"",:aETitleCategory.PropertyParams)
	//s objTitle.Sequence=$case(aETitleCategory.Sequence,$c(0):0,:aETitleCategory.Sequence)
	s sc = objTitle.%Save()
	if ($$$ISOK(sc))
	{		
		 q aETitleCategory.ID
	}
	else
	{
		 q "-1"	
	}
}

/// 删除一个目录
ClassMethod DeleteTitleCategory(aTitleCategoryID As %String, aTitleId As %String, aTitleConfigID As %String) As %String [ WebMethod ]
{
	
    TSTART
    q:(aTitleCategoryID ="") "-1"
    b
    s objTitleCategory = ##Class(EMRmeta.TitleCategory).%OpenId(aTitleCategoryID)
	q:(objTitleCategory="") "-1"
	s sc = ##class(EMRmeta.TitleCategory).%DeleteId(aTitleCategoryID)
	if ($$$ISOK(sc))
	{	
	    if ('$ISVALIDNUM(aTitleId) && '$ISVALIDNUM(aTitleConfigID))	   
	    {
		    TCOMMIT
			q (+sc)
		}
		else
		{
			s objTitles = ##Class(EMRmeta.Titles).%OpenId(aTitleId)
			if (objTitles="") 
			{
				TCOMMIT
				q (+sc)
			}
			s sc = ##class(EMRmeta.Titles).%DeleteId(aTitleId)
			if ($$$ISOK(sc))
			{
				s objTitleConfig = ##Class(EMRmeta.TitleConfig).%OpenId(aTitleConfigID)
				q:(objTitleConfig="") "-1"
				s sc = ##class(EMRmeta.TitleConfig).%DeleteId(aTitleConfigID)
				TCOMMIT
				q (+sc)
			}
			else
			{
				TROLLBACK
				q "-1"
			}
		}	
    }
    else
    {
	    TROLLBACK
		q "-1"
	}
}

/// 更新一个数据元范畴
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
		S argstrItem= $P(argStr,",",I)
		S argTitleCateID = $P(argstrItem,"^",1)
		S argTitleCateSeq = $P(argstrItem,"^",2)
		if ($d(argTitleCateID)=0)||($d(argTitleCateSeq)=0)||(argTitleCateID="")||(argTitleCateSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objTitleCate="",result=""
		s objTitleCate=##class(EMRmeta.TitleCategory).%OpenId(argTitleCateID)
		if (objTitleCate ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objTitleCate.Sequence=argTitleCateSeq
		s result=""
		if '(objTitleCate.%Save())
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

/// 删除一个数据元范畴
ClassMethod test() As %String [ WebMethod ]
{
	s titles = ##Class(EMRservice.entity.ETitleCategory).%New()
	s titles.TitleCategoryName = "病程记录"
	s titles.TitleCategoryType = "Category" 
	s titles.TitleParentCategoryID = "0"
	s titles.Params = "ShowOperation:true,DoctorLinkOperation:true"
	b
	d ..CreateTitleCategory(titles)
}

Storage Default
{
<Data name="BLTitleCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>TitleCode</Value>
</Value>
<Value name="4">
<Value>PageBreak</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>AutoLoad</Value>
</Value>
<Value name="7">
<Value>GroupID</Value>
</Value>
</Data>
<DataLocation>^EMRservice.BL.BLTitleCategoryD</DataLocation>
<DefaultData>BLTitleCategoryDefaultData</DefaultData>
<IdLocation>^EMRservice.BL.BLTitleCategoryD</IdLocation>
<IndexLocation>^EMRservice.BL.BLTitleCategoryI</IndexLocation>
<StreamLocation>^EMRservice.BL.BLTitleCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

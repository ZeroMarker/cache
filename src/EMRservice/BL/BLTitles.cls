/// 名称：		EMRservice.BL.BLTitles
/// 描述：		标题BL层
/// 编写者：	yejian
/// 编写时间：	2014-4-5
Class EMRservice.BL.BLTitles Extends (%RegisteredObject, %XML.Adaptor)
{

Query SELECTALLTITLES() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Description:%String,Alias:%String,Sequence:%Integer,CID:%Integer,CategoryID:%String,TemplateID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TITLES_SELECTALLTITLES, SqlProc ]
{
	SELECT t.ID,t.Code,t.Description,t.Alias,c.Sequence,c.ID,c.CategoryID,c.TemplateID
	FROM EMRmeta.Titles t left join EMRmeta.TitleConfig c
	on  t.Code = c.TitleCode ORDER BY c.Sequence
}

Query SelectAllTitle() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GroupID:%String,Code:%String,Description:%String,Alias:%String,Sequence:%String,TCID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_ALLTITLES_SelectAllTitle, SqlProc ]
{
	SELECT t.ID,c.GroupID,t.Code,t.Description,t.Alias,c.Sequence,c.ID
	FROM EMRmeta.Titles t left join EMRmeta.TitleConfig c
	on  t.Code = c.TitleCode order by c.Sequence ASC
}

Query SelectUserLevel() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_TITLES_SELECTUSERLEVEL, SqlProc ]
{
	SELECT Name, Description
    FROM EMRmeta.UserLevel
    WHERE IsValid = '1' AND (Name ='Chief' OR Name = 'Attending' OR Name ='ViceChief')
    ORDER BY ID DESC
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode   from EMRmeta.Titles)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 创建一个数据元范畴
ClassMethod CreateTitles(aETitleInfo As EMRservice.entity.ETitles, aETitleConfig As EMRservice.entity.ETitleConfig) As %String [ WebMethod ]
{
	b "s"
	TSTART
	set objTitle=##class(EMRmeta.Titles).%New()
	quit:(objTitle="") ""
	s strReslt = ""
	s objTitle.Code = $case(aETitleInfo.Code,$c(0):"",:aETitleInfo.Code)
	s objTitle.Description=$case(aETitleInfo.Description,$c(0):"",:aETitleInfo.Description)
	s objTitle.Alias=$case(aETitleInfo.Alias,$c(0):"",:aETitleInfo.Alias)
	s sc = objTitle.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objTitle.%Id()
		s objTitleConfig = ##Class(EMRmeta.TitleConfig).%New()
		quit:(objTitleConfig="") ""
		s objTitleConfig.CategoryID =$case(aETitleConfig.CategoryID,$c(0):"",:aETitleConfig.CategoryID)
		s objTitleConfig.PageBreak =$case(aETitleConfig.PageBreak,$c(0):"",:aETitleConfig.PageBreak)
		s objTitleConfig.PageNextBreak =$case(aETitleConfig.PageNextBreak,$c(0):"",:aETitleConfig.PageNextBreak)
		s objTitleConfig.TitleCode =$case(aETitleConfig.TitleCode,$c(0):"",:aETitleConfig.TitleCode)
		s objTitleConfig.AutoLoad =$case(aETitleConfig.AutoLoad,$c(0):"",:aETitleConfig.AutoLoad)
		s objTitleConfig.GroupID =$case(aETitleConfig.GroupID,$c(0):"",:aETitleConfig.GroupID)
		s objTitleConfig.TemplateID =$case(aETitleConfig.TemplateID,$c(0):"",:aETitleConfig.TemplateID)
		s objTitleConfig.UniqueCreate =$case(aETitleConfig.UniqueCreate,$c(0):"",:aETitleConfig.UniqueCreate)
		S objTitleConfig.DefaultLoad =$case(aETitleConfig.DefaultLoad,$c(0):"",:aETitleConfig.DefaultLoad)
		s objTitleConfig.Sequence =strReslt
		s sc = objTitleConfig.%Save()
		if ($$$ISOK(sc))
		{
			Set key = ""			
			do
			{ 			   
				S objTitileColConfig = aETitleConfig.ColumnConfig.GetNext(.key)
				q:(objTitileColConfig="")
				if (objTitileColConfig '= "")
				{
					
					s objTitleColCon = ##Class(EMRmeta.TitleColConfig).%New()
					s objTitleColCon.Type = $case(objTitileColConfig.Type,$c(0):"",:objTitileColConfig.Type)
					s objTitleColCon.ReadOnly = $case(objTitileColConfig.ReadOnly,$c(0):"",:objTitileColConfig.ReadOnly)
					s objTitleColCon.Format = $case(objTitileColConfig.Format,$c(0):"",:objTitileColConfig.Format)
					s objTitleColCon.LineBreak = $case(objTitileColConfig.LineBreak,$c(0):"",:objTitileColConfig.LineBreak)
					s objTitleColCon.Align = $case(objTitileColConfig.Align,$c(0):"",:objTitileColConfig.Align)
					s objTitleColCon.Visible = $case(objTitileColConfig.Visible,$c(0):"",:objTitileColConfig.Visible)
					s objTitleColCon.FontStyle = $case(objTitileColConfig.FontStyle ,$c(0):"",:objTitileColConfig.FontStyle)
					s objTitleColCon.Params = $case(objTitileColConfig.Params ,$c(0):"",:objTitileColConfig.Params)
					if ($zcvt(aETitleConfig.TitleFrist,"U")="TRUE")
					{
						if ($zcvt(objTitileColConfig.Type,"U") ="TITLE")
						{
							s objTitleColCon.SeqNum = 1
						}
						else
						{
							s objTitleColCon.SeqNum = 2
						}
					}
					else
					{
						if ($zcvt(objTitileColConfig.Type,"U") ="TITLE")
						{
							s objTitleColCon.SeqNum = 2
						}
						else
						{
							s objTitleColCon.SeqNum = 1
						}
					}
					s objTitleColCon.TitleConfig = objTitleConfig
					s sc = objTitleColCon.%Save()
					if ('$$$ISOK(sc))
					{
					 	s strReslt = "-1"
					}
				}
			} 
			while (key '="" )	
		}
		else
		{
			s strReslt = "-1"
		}
	}
	else
	{
		s strReslt = "-1"	
	}
	if (strReslt ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q strReslt
	}
}

/// 删除一个数据元范畴
ClassMethod DeleteTitlesByID(aTitleId As %String, aTitleConfigID As %String) As %String [ WebMethod ]
{
	TSTART
	q:(aTitleId ="") "-1"
	q:(aTitleConfigID ="") "-1"
	s objTitles = ##Class(EMRmeta.Titles).%OpenId(aTitleId)
	q:(objTitles="") "-1"
	s rowId = $o(^DHCEMRM.TitleLinkEventI("IdxTitleCode"," "_$zcvt(objTitles.Code,"U"),""))
	//事件编码为空删除
	if (rowId '= "")
	{
		s obj = ##class(EMRmeta.TitleLinkEvent).%OpenId(rowId)
		q:(obj="") ret
		if '(obj.%DeleteId(rowId))
		{
			TROLLBACK
			q "-1"
		}
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
		S argTitleConfigID = $P(argstrItem,"^",1)
		S argTitleConfigSeq = $P(argstrItem,"^",2)
		if ($d(argTitleConfigID)=0)||($d(argTitleConfigSeq)=0)||(argTitleConfigID="")||(argTitleConfigSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objTitleConfig="",result=""
		s objTitleConfig=##class(EMRmeta.TitleConfig).%OpenId(argTitleConfigID)
		if (objTitleConfig ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objTitleConfig.Sequence=argTitleConfigSeq
		s result=""
		if '(objTitleConfig.%Save())
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

/// 更新一个数据元范畴
ClassMethod UpdateTitles(aETitleInfo As EMRservice.entity.ETitles, aETitleConfig As EMRservice.entity.ETitleConfig) As %String [ WebMethod ]
{
	b
	TSTART
	set objTitle=##class(EMRmeta.Titles).%OpenId(aETitleInfo.ID)
	quit:(objTitle="") "0"

	s strReslt = ""
	s objTitle.Code=aETitleInfo.Code
	s objTitle.Description=$case(aETitleInfo.Description,$c(0):"",:aETitleInfo.Description)
	s objTitle.Alias=$case(aETitleInfo.Alias,$c(0):"",:aETitleInfo.Alias)

	s sc = objTitle.%Save()
	if ($$$ISOK(sc))
	{
		s strReslt = objTitle.%Id()
		s objTitleConfig = ##Class(EMRmeta.TitleConfig).%OpenId(aETitleConfig.ID)
		s objTitleConfig.CategoryID =$case(aETitleConfig.CategoryID,$c(0):"",:aETitleConfig.CategoryID)
		s objTitleConfig.TitleCode =$case(aETitleConfig.TitleCode,$c(0):"",:aETitleConfig.TitleCode)
		s objTitleConfig.PageBreak =$case(aETitleConfig.PageBreak,$c(0):"",:aETitleConfig.PageBreak)
		s objTitleConfig.PageNextBreak =$case(aETitleConfig.PageNextBreak,$c(0):"",:aETitleConfig.PageNextBreak)
		s objTitleConfig.AutoLoad =$case(aETitleConfig.AutoLoad,$c(0):"",:aETitleConfig.AutoLoad)
		s objTitleConfig.GroupID =$case(aETitleConfig.GroupID,$c(0):"",:aETitleConfig.GroupID)
		s objTitleConfig.TemplateID =$case(aETitleConfig.TemplateID,$c(0):"",:aETitleConfig.TemplateID)	
		s objTitleConfig.UniqueCreate =$case(aETitleConfig.UniqueCreate,$c(0):"",:aETitleConfig.UniqueCreate)	
		s objTitleConfig.DefaultLoad =$case(aETitleConfig.DefaultLoad,$c(0):"",:aETitleConfig.DefaultLoad)	
		
		s sc = objTitleConfig.%Save()
		if ($$$ISOK(sc))
		{	
			Set key = ""
			do
			{   
			    b
				S objTitileColConfig = aETitleConfig.ColumnConfig.GetNext(.key)	
				//q:(objTitileColConfig="")		
				if (objTitileColConfig '= "")
				{	
					S strTitleColId = aETitleConfig.ID _"||"_key
					s objTitleColCon = ##Class(EMRmeta.TitleColConfig).%OpenId(strTitleColId)
					s objTitleColCon.Type = $case(objTitileColConfig.Type,$c(0):"",:objTitileColConfig.Type)
					s objTitleColCon.ReadOnly = $case(objTitileColConfig.ReadOnly,$c(0):"",:objTitileColConfig.ReadOnly)
					s objTitleColCon.Format = $case(objTitileColConfig.Format,$c(0):"",:objTitileColConfig.Format)
					s objTitleColCon.LineBreak = $case(objTitileColConfig.LineBreak,$c(0):"",:objTitileColConfig.LineBreak)
					s objTitleColCon.Align = $case(objTitileColConfig.Align,$c(0):"",:objTitileColConfig.Align)
					s objTitleColCon.Visible = $case(objTitileColConfig.Visible,$c(0):"",:objTitileColConfig.Visible)
					s objTitleColCon.FontStyle = $case(objTitileColConfig.FontStyle ,$c(0):"",:objTitileColConfig.FontStyle)
					s objTitleColCon.Params = $case(objTitileColConfig.Params ,$c(0):"",:objTitileColConfig.Params)
					if ($zcvt(aETitleConfig.TitleFrist,"U")="TRUE")
					{
						if ($zcvt(objTitileColConfig.Type,"U") ="TITLE")
						{
							s objTitleColCon.SeqNum = 1
						}
						else
						{
							s objTitleColCon.SeqNum = 2
						}
					}
					else
					{
						if ($zcvt(objTitileColConfig.Type,"U") ="TITLE")
						{
							s objTitleColCon.SeqNum = 2
						}
						else
						{
							s objTitleColCon.SeqNum = 1
						}
					}
					s objTitleColCon.TitleConfig = objTitleConfig
					s sc = objTitleColCon.%Save()
					if ('$$$ISOK(sc))
					{
					 	s strReslt = "-1"
					}
				}
				else
				{
					q 
				}			
			} 
			while (key '="" )	
		}
		else
		{
			s strReslt = "-1"
		}
	}
	else
	{
		s strReslt = "-1"	
	}
	if (strReslt ="-1")
	{
		 TROLLBACK
		 quit "-1"
	}
	else
	{
		TCOMMIT
		q strReslt
	}
}

/// Creator:	yejian
/// CreatDate:  2014-5-13
/// Desc:		获取所有配置信息
/// Input：		
/// Return：	dataset
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTitles","SelectAllTitileConfig")
Query SelectAllTitileConfig() As %Query(ROWSPEC = "ID:%Integer,CategoryID:%String,TemplateID:%String,TitleCode:%String,PageBreak:%String,AutoLoad:%String,UniqueCreate:%String,DefaultLoad:%String,Align:%String,Sequence:%Integer,Type:%String,ReadOnly:%String,Format:%String,LineBreak:%String,Visible:%String,SeqNum:%Integer,FontStyle:%String,Params:%String,PageNextBreak:%String")
{
}

ClassMethod SelectAllTitileConfigExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	s strTitleCode = ""
	for {
		s strTitleCode = $o(^DHCEMRM.TitleConfigI("IdxTitleCode",strTitleCode))
		q:(strTitleCode = "")	
		s arowID = ""
		for {
			s arowID = $o(^DHCEMRM.TitleConfigI("IdxTitleCode",strTitleCode,arowID))
			q:(arowID = "")
			s objTitileConfig = ##Class(EMRmeta.TitleConfig).%OpenId(arowID)
			s CategoryID = objTitileConfig.CategoryID
			s TemplateID = objTitileConfig.TemplateID
			s TitleCode = objTitileConfig.TitleCode
			s PageBreak = objTitileConfig.PageBreak
			s PageNextBreak = objTitileConfig.PageNextBreak
			s Sequence = objTitileConfig.Sequence
			s AutoLoad = objTitileConfig.AutoLoad
			s UniqueCreate=objTitileConfig.UniqueCreate
			s DefaultLoad=objTitileConfig.DefaultLoad
			
			Set key = ""
 			do
 			{ 
				S objTitileColConfig = objTitileConfig.ColumnConfig.GetNext(.key)
				if (objTitileColConfig '= "")
				{
					s Type = objTitileColConfig.Type
					s ReadOnly = objTitileColConfig.ReadOnly
					s Format = objTitileColConfig.Format
					s LineBreak = objTitileColConfig.LineBreak
					s Align = objTitileColConfig.Align
					s Visible = objTitileColConfig.Visible
					s SeqNum = objTitileColConfig.SeqNum
					s FontStyle = objTitileColConfig.FontStyle
					s Params=objTitileColConfig.Params
					s Data = $lb(arowID,CategoryID,TemplateID,TitleCode,PageBreak,AutoLoad,UniqueCreate,DefaultLoad,Align,Sequence,
					  Type,ReadOnly,Format,LineBreak,Visible,SeqNum,FontStyle,Params,PageNextBreak)
					s ^CacheTemp(repid,ind) = Data
					s ind = ind + 1
				}
 			} 
 			while (key '="" )
		}
	}
	q $$$OK
}

ClassMethod SelectAllTitileConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllTitileConfigExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllTitileConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllTitileConfigExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String [ WebMethod ]
{
	
	&sql(select id into :IdexCode   from EMRmeta.Titles where Code=:Acode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

// 增加手术目录属性时设置标题唯一属性

// w ##Class(EMRservice.BL.BLTitles).updateUniqueCreateByTitleCategoryID("2","True")

ClassMethod updateUniqueCreateByTitleCategoryID(aTitleCategoryID As %String, aUniqueCreate As %String) As %String
{
	q:(aTitleCategoryID="")
	q:(aUniqueCreate="")
	&sql(update EMRmeta.TitleConfig set UniqueCreate=:aUniqueCreate where GroupID=:aTitleCategoryID)
	q SQLCODE
}

/// 删除一个数据元范畴
/// d ##Class(EMRservice.BL.BLTitles).test()
ClassMethod test() As %String [ WebMethod ]
{
	s titles = ##Class(EMRservice.entity.ETitles).%New()
	s titles.ID = "43"
	s titles.Code = "043"
	s titles.Alias = "SCBC"
	s titles.Description = "首次病程"
	s tconfig = ##Class(EMRservice.entity.ETitleConfig).%New()
	s tconfig.ID = "46"
	s tconfig.CategoryID = "107"
	s tconfig.AutoLoad = "True"
	s tconfig.TitleCode = "0316"
	s tconfig.PageBreak ="False"
	s tconfig.GroupID ="1"
	s tconfig.TitleFrist = "True"
	//s tconfig.ID = "93"
	s tconfig.Sequence = 0
	s tconfigCol = ##Class(EMRservice.entity.ETitleColConfig).%New()
	s tconfigCol.Type = "Title"
	s tconfigCol.ReadOnly= "False"
	s tconfigCol.LineBreak = "False"
	s tconfigCol.Format = ""
	s tconfigCol.Align = "Left"
	s tconfigCol.Visible = "True"
	s tconfigCol.SeqNum = 0
	s tconfigColD = ##Class(EMRservice.entity.ETitleColConfig).%New()
	s tconfigColD.Type = "DateTime"
	s tconfigColD.ReadOnly= "False"
	s tconfigColD.LineBreak = "False"
	s tconfigColD.Format = "yyyy-MM-dd HH:mm:ss"
	s tconfigColD.Align = "Left"
	s tconfigColD.Visible = "True"
	s tconfigColD.SeqNum = 0
	d ..UpdateTitles(titles,tconfig)
}

}

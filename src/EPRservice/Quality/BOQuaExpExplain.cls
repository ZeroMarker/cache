Class EPRservice.Quality.BOQuaExpExplain Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 用于返回值
Parameter ForGetValue = "EPR.TId.";

/// 返回InstanceData保存日期,时间
Parameter ForGetValueA = "EPR.IstCreateDate";

/// 返回InstanceData保存人
Parameter ForGetValueB = "EPR.IstCreateUser";

/// 用于返回True1/False0
Parameter ForGetBoolean = "EPR.IstSave.";

Parameter InstanceDataUnSave = 0;

Parameter InstanceDataSave = 1;

/// 取电子病历数据
ClassMethod GetEPRData(ARCPARA As %String, EpisodeID As %String) As %String
{
		s outstr=""
		///s ^CacheTemp("Test",ARCPARA,EpisodeID)="ARCPARA= "_ARCPARA_"EpisodeID= "_EpisodeID
		///取模版上元数据内容 取打散数据
		///s ARCPARA="EPR.TId.501.S0001"
		
		i ARCPARA [ ..#ForGetValue d
		.s TemplateID=$p(ARCPARA,".",3)
		.s SampleItemCode=$p(ARCPARA,".",4)
		.//s outstr=..GetISimpleValue(EpisodeID,TemplateID,SampleItemCode)
		.s outstr=##Class(EPRservice.BOScatterData).GetScatterData(EpisodeID,TemplateID,SampleItemCode)
		.s outstr=$tr(outstr,"Null")


        i ARCPARA [ "EPR.IstCreate" d
        .s TemplateID=$p(ARCPARA,".",3)
        .s outstr=..GetInstanceData(ARCPARA,EpisodeID,TemplateID)
		
		///取模版是否保存True1/False0
		//s ARCPARA="EPR.IstSave.501"
		i ARCPARA [ ..#ForGetBoolean  d
		.//w $p(ARCPARA,".",3)
		.s TemplateID=$p(ARCPARA,".",3)
		.s outstr=..GetInstanceDataStatus(EpisodeID,TemplateID)

		q outstr
}

/// 取EPRinstance.ISimple打散数据
ClassMethod GetISimpleValue(EpisodeID As %String, TemplateID As %String, SampleItemCode As %String) As %String
{
	s BlankEpisodeID=" "_EpisodeID
	s BlankTemplateID=" "_TemplateID
	s BlankSimpleItemCode=" "_SampleItemCode
	Set BlankInstanceDataID=$O(^DHCEPRI.ISimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSimpleItemCode,"")) 
    if (BlankInstanceDataID'="")
	    {
		  Set SingleIndex= $O(^DHCEPRI.ISimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSimpleItemCode,BlankInstanceDataID,""))   
	    }
	    elseif (BlankInstanceDataID="")
	    {
	     s SingleIndex = ""	 
		 }
	else 
	{
	 s SingleIndex = ""
	} 
	s obj=##Class(EPRinstance.ISimple).%OpenId(SingleIndex)
	s value=obj.DataValue
	q value
}

/// 取EPRinstance.InstanceData保存状态Save 1/UnSave 0 
ClassMethod GetInstanceDataStatus(EpisodeID As %String, TemplateID As %String) As %String
{
	///TemplateID->Template.CategoryID
	///Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID);
	///Index IdxECRecord On TheECRecord;
    s Status=..#InstanceDataUnSave
    s objTemplate=##Class(EPRmeta.Template).%OpenId(TemplateID)
    s CategoryID=objTemplate.TemplateCategoryID
    s objTemplateCategory=##Class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
    i objTemplateCategory.CategoryType="Normal"
    {
		s CategoryID=objTemplate.TemplateCategoryID
	}
    i objTemplateCategory.CategoryType="GroupItem"
    {
		s CategoryID=objTemplateCategory.ParentID
	}
    s BlankEpisodeID=" "_EpisodeID
	s BlankCategoryID=" "_CategoryID
	s TheEcrecordIndex="0"
	s TheEcrecordIndex= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",BlankEpisodeID,BlankCategoryID,""))
	q:TheEcrecordIndex="" Status 
	s objInstanceData=##Class(EPRinstance.ECRecord).%OpenId(TheEcrecordIndex)
	s InstanceCount=objInstanceData.InstanceCount
	f i=1:1:InstanceCount
	{
		s InstanceDataID=TheEcrecordIndex_"||"_i
		s objInstanceData=##Class(EPRinstance.InstanceData).%OpenId(InstanceDataID)
		if objInstanceData.TemplateID=TemplateID 
		{
			i ((objInstanceData.Status="Save")||(objInstanceData.Status="Commit"))  
			{
				s Status=..#InstanceDataSave
			}
		}
	}
    q Status
}

/// 取EPRinstance.InstanceData保存者(ForGetValueB)，保存日期(ForGetValueA)
ClassMethod GetInstanceData(ARCPARA As %String, EpisodeID As %String, TemplateID As %String) As %String
{
	///TemplateID->Template.CategoryID
	///Index IdxEpisodeIDCategoryID On (EpisodeID, CategoryID);
	///Index IdxECRecord On TheECRecord;
    
	i ARCPARA [..#ForGetValueA
	{
		s mValue=$h
	}
	i ARCPARA [..#ForGetValueB
	{
		s mValue=""
	}
	
    s objTemplate=##Class(EPRmeta.Template).%OpenId(TemplateID)
    s CategoryID=objTemplate.TemplateCategoryID
    s objTemplateCategory=##Class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
    i objTemplateCategory.CategoryType="Normal"
    {
		s CategoryID=objTemplate.TemplateCategoryID
	}
    i objTemplateCategory.CategoryType="GroupItem"
    {
		s CategoryID=objTemplateCategory.ParentID
	}
    s BlankEpisodeID=" "_EpisodeID
	s BlankCategoryID=" "_CategoryID
	s TheEcrecordIndex="0"
	s TheEcrecordIndex= $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID",BlankEpisodeID,BlankCategoryID,""))
	s objInstanceData=##Class(EPRinstance.ECRecord).%OpenId(TheEcrecordIndex)
	s InstanceCount=objInstanceData.InstanceCount
	f i=1:1:InstanceCount
	{
		s InstanceDataID=TheEcrecordIndex_"||"_i
		s objInstanceData=##Class(EPRinstance.InstanceData).%OpenId(InstanceDataID)
		if objInstanceData.TemplateID=TemplateID 
		{
			i ARCPARA [..#ForGetValueA
			{
				i objInstanceData.CreateDate=""
				{
					s objInstanceData.CreateDate=$p($h,",",1)
					s objInstanceData.CreateTime=$p($h,",",2)
				}
				s mValue=objInstanceData.CreateDate_","_objInstanceData.CreateTime	
				//w "objInstanceData.CreateDate=",objInstanceData.CreateDate,! 
			}
			i ARCPARA [..#ForGetValueB
			{
				s mValue=objInstanceData.CreateUser
			}
		}
	}
	
    q mValue
}

/// 取模板分类EPRmeta.TemplateCategory
ClassMethod GetTemplateCategory()
{
  s outstr=""
  s TemplateCategoryID="0"
  f  s TemplateCategoryID=$O(^DHCEPRM.TemplateCategoryD(TemplateCategoryID))  q:TemplateCategoryID=""  d
  .s objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(TemplateCategoryID)
  .s Name=objTemplateCategory.Name
  .s tmp="c"_TemplateCategoryID
  .s ParentID=""
  .s:+objTemplateCategory.ParentID'=0 ParentID="c"_objTemplateCategory.ParentID
  .s outstr =outstr_tmp_$C(2)_ParentID_$C(2)_Name_$C(1)
  q outstr
}

/// 取模板列表EPRmeta.Template  
ClassMethod GetTemplateList()
{
  s outstr=""
  s TemplateID="0" 
  f  s TemplateID=$O(^DHCEPRM.TemplateD(TemplateID)) q:TemplateID=""  d
  .s objTemplate = ##class(EPRmeta.Template).%OpenId(TemplateID)
  .s ParentID="c"_objTemplate.TemplateCategoryID
  .s Name=objTemplate.Name
  .s outstr=outstr_TemplateID_$c(2)_ParentID_$c(2)_Name_$c(1)
  q outstr
}

/// 取模板元数据列表
ClassMethod GetMetDataByTemplateID(TemplateID) As %String
{
 //s ^CacheTemp($j,TemplateID)=TemplateID
 s outstr=""
 s TemplateVersionID=##Class(EPRmeta.TemplateVersion).GetMaxPubVrnID(TemplateID)
 s objMetaData= ##class(EPRmeta.TemplateVersion).%OpenId(TemplateVersionID)   			     
 if (objMetaData="")
 {
  Q outstr
	 }	
 set ASearchStream = ##class(%GlobalCharacterStream).%New()
 d ASearchStream.CopyFrom(objMetaData.MetaData)
 
 Set newNTemplateVersion=##class(EPRmeta.Parser.NTemplateVersion).%New()
  
 S AAutoParserStream=##class(EPRservice.Util.ParserStream).%New()
 s AAutoParserStream.CdataSign=$J
  
 S DissolveStream =  AAutoParserStream.AutoMationByStr(ASearchStream)
 s AFileName=##class(EPRservice.Utility).GetFileName(TemplateID)
 
 Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=AFileName
	D stream.TranslateTableSet("UTF8")
	d DissolveStream.Rewind()
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	while (DissolveStream.AtEnd = 0)
	{ s readstring=DissolveStream.Read(1024)
	  d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	d DissolveStream.Rewind()
	
	;w AFileName,!
    
  Set sc = ##class(%XML.TextReader).ParseFile(AFileName,.reader) 
  
  If (##class(%File).Exists(AFileName))
	{ 
	 	s file = ""
	 d ##class(%File).Delete(AFileName)
	}
 
	set sc = ##class(%XML.TextReader).ParseStream(DissolveStream,.reader) 
	Set newNTemplateVersion=##class(EPRmeta.Parser.NTemplateVersion).%New()
	 
	set newNTemplateVersion.TemplateID= TemplateID
	set newNTemplateVersion.TemplateVersion=1
	set newNTemplateVersion.SessionSign=$J
	 
	if ($$$ISOK(sc)) 
	{ 
	  do reader.Read()
	  do newNTemplateVersion.XMLDeserialize(reader)
	}
	Else{ 
	Quit outstr } 
  Set ItemCount= newNTemplateVersion.SubItems.Count()
  for I = 1:1:ItemCount
 {           
    s obj= newNTemplateVersion.SubItems.GetAt(I)
    s outstr=outstr_obj.Code_$c(2)_obj.Parent.Code_$c(2)_obj.Text_$c(1)

    s SubItemCount= obj.SubItems.Count()
    f J=1:1:SubItemCount
    {  
     s objSubItem= obj.SubItems.GetAt(J)
     s outstr=outstr_objSubItem.Code_$c(2)_objSubItem.Parent.Code_$c(2)_objSubItem.Text_$c(1)
    } 
 }
 quit outstr
}

}

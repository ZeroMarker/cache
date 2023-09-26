Class EMRservice.BL.BLCommonEleValues Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLCommonEleValues","SELECTALLBYCategoryID","EMR020101","S001")
Query SELECTALLDATE() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ElemType:%String,Code:%String,DisplayName:%String,Description:%String,BindType:%String,BindCode:%String,Synch:%String,AllowNull:%String,ValidateMsg:%String,RegExp:%String,MaxLength:%String,ConfidentialityCode:%String,ReadOnly:%String,TabIndex:%String,FixedStructs:%String,Visible:%String,DynamicField:%String,IncludeDate:%String,IncludeTime:%String,DateFormat:%String,TimeFormat:%String,MinVal:%String,MaxVal:%String,HasMinVal:%String,HasMaxVal:%String,IncludeMin:%String,IncludeMax:%String,DecimalPlace:%String,WrapChoice:%String,Choices:%String,DictionaryType:%String,CodeSystem:%String,CodeSystemName:%String,CustDicClassName:%String,DisplayType:%String,Separator:%String,FirstColType:%String,SecondColType:%String,ThirdColType:%String,AllowCodeNull:%String,AllowValueNull:%String,AssociateItem:%String,AllowEdit:%String,SignatureLevel:%String,LinkCode:%String,LinkDisplayType:%String,LinkMethod:%String,ShowUnChecked:%String,UncheckedPrefix:%String,CheckedPrefix:%String,OneByOneLink:%String,TemplateCode:%String,TemplateName:%String,SectionCode:%String,SectionName:%String,ShowSignerDescription:%String,HeaderImageCode:%String,FingerImageCode:%String,IsBindImage:%String,SilentSynch:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_COMMONELEVS_SELECTALLDATE, SqlProc ]
{
	SELECT ID,ElemType,Code,DisplayName,Description,
	BindType,BindCode,Synch,AllowNull,ValidateMsg,
	RegExp,MaxLength,ConfidentialityCode,ReadOnly,TabIndex,
	FixedStructs,Visible,DynamicField,IncludeDate,IncludeTime,
	DateFormat,TimeFormat,MinVal,MaxVal,HasMinVal,
	HasMaxVal,IncludeMin,IncludeMax,DecimalPlace,WrapChoice,
	Choices,DictionaryType,CodeSystem,CodeSystemName,CustDicClassName,
	DisplayType,Separator,FirstColType,SecondColType,ThirdColType,
	AllowCodeNull,AllowValueNull,AssociateItem,AllowEdit,SignatureLevel,
	LinkCode,LinkDisplayType,LinkMethod,ShowUnChecked,UncheckedPrefix,
	CheckedPrefix,OneByOneLink,TemplateCode,TemplateName,SectionCode,
	SectionName,ShowSignerDescription,HeaderImageCode,FingerImageCode,IsBindImage,
	SilentSynch
	FROM EMRmeta.CommonEleValues
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLCommonEleValues","SELECTALLBYCategoryID","EMR020101","S001")
Query SELECTALLBYCategoryID(aTemplateCode As %String, aSectionCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ElemType:%String,Code:%String,DisplayName:%String,Description:%String,BindType:%String,BindCode:%String,Synch:%String,AllowNull:%String,ValidateMsg:%String,RegExp:%String,MaxLength:%String,ConfidentialityCode:%String,ReadOnly:%String,TabIndex:%String,FixedStructs:%String,Visible:%String,DynamicField:%String,IncludeDate:%String,IncludeTime:%String,DateFormat:%String,TimeFormat:%String,MinVal:%String,MaxVal:%String,HasMinVal:%String,HasMaxVal:%String,IncludeMin:%String,IncludeMax:%String,DecimalPlace:%String,WrapChoice:%String,Choices:%String,DictionaryType:%String,CodeSystem:%String,CodeSystemName:%String,CustDicClassName:%String,DisplayType:%String,Separator:%String,FirstColType:%String,SecondColType:%String,ThirdColType:%String,AllowCodeNull:%String,AllowValueNull:%String,AssociateItem:%String,AllowEdit:%String,SignatureLevel:%String,LinkCode:%String,LinkDisplayType:%String,LinkMethod:%String,ShowUnChecked:%String,UncheckedPrefix:%String,CheckedPrefix:%String,OneByOneLink:%String,TemplateCode:%String,TemplateName:%String,SectionCode:%String,SectionName:%String,ShowSignerDescription:%String,HeaderImageCode:%String,FingerImageCode:%String,IsBindImage:%String,SilentSynch:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_COMMONELEVS_SELECTALLBYCATEGORYID, SqlProc ]
{
	SELECT ID,ElemType,Code,DisplayName,Description,
	BindType,BindCode,Synch,AllowNull,ValidateMsg,
	RegExp,MaxLength,ConfidentialityCode,ReadOnly,TabIndex,
	FixedStructs,Visible,DynamicField,IncludeDate,IncludeTime,
	DateFormat,TimeFormat,MinVal,MaxVal,HasMinVal,
	HasMaxVal,IncludeMin,IncludeMax,DecimalPlace,WrapChoice,
	Choices,DictionaryType,CodeSystem,CodeSystemName,CustDicClassName,
	DisplayType,Separator,FirstColType,SecondColType,ThirdColType,
	AllowCodeNull,AllowValueNull,AssociateItem,AllowEdit,SignatureLevel,
	LinkCode,LinkDisplayType,LinkMethod,ShowUnChecked,UncheckedPrefix,
	CheckedPrefix,OneByOneLink,TemplateCode,TemplateName,SectionCode,
	SectionName,ShowSignerDescription,HeaderImageCode,FingerImageCode,IsBindImage,
	SilentSynch
	FROM EMRmeta.CommonEleValues
	WHERE TemplateCode = :aTemplateCode 
	and SectionCode = :aSectionCode
}

/// d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLCommonEleValues","SELECTALLBYCODES","EMR020101","S001")
Query SELECTALLBYCODES(aTemplateCode As %String, aSectionCode As %String, aCode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ElemType:%String,Code:%String,DisplayName:%String,Description:%String,BindType:%String,BindCode:%String,Synch:%String,AllowNull:%String,ValidateMsg:%String,RegExp:%String,MaxLength:%String,ConfidentialityCode:%String,ReadOnly:%String,TabIndex:%String,FixedStructs:%String,Visible:%String,DynamicField:%String,IncludeDate:%String,IncludeTime:%String,DateFormat:%String,TimeFormat:%String,MinVal:%String,MaxVal:%String,HasMinVal:%String,HasMaxVal:%String,IncludeMin:%String,IncludeMax:%String,DecimalPlace:%String,WrapChoice:%String,Choices:%String,DictionaryType:%String,CodeSystem:%String,CodeSystemName:%String,CustDicClassName:%String,DisplayType:%String,Separator:%String,FirstColType:%String,SecondColType:%String,ThirdColType:%String,AllowCodeNull:%String,AllowValueNull:%String,AssociateItem:%String,AllowEdit:%String,SignatureLevel:%String,LinkCode:%String,LinkDisplayType:%String,LinkMethod:%String,ShowUnChecked:%String,UncheckedPrefix:%String,CheckedPrefix:%String,OneByOneLink:%String,TemplateCode:%String,TemplateName:%String,SectionCode:%String,SectionName:%String,ShowSignerDescription:%String,HeaderImageCode:%String,FingerImageCode:%String,IsBindImage:%String,SilentSynch:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_COMMONELEVS_SELECTALLBYCODES, SqlProc ]
{
	SELECT ID,ElemType,Code,DisplayName,Description,
	BindType,BindCode,Synch,AllowNull,ValidateMsg,
	RegExp,MaxLength,ConfidentialityCode,ReadOnly,TabIndex,
	FixedStructs,Visible,DynamicField,IncludeDate,IncludeTime,
	DateFormat,TimeFormat,MinVal,MaxVal,HasMinVal,
	HasMaxVal,IncludeMin,IncludeMax,DecimalPlace,WrapChoice,
	Choices,DictionaryType,CodeSystem,CodeSystemName,CustDicClassName,
	DisplayType,Separator,FirstColType,SecondColType,ThirdColType,
	AllowCodeNull,AllowValueNull,AssociateItem,AllowEdit,SignatureLevel,
	LinkCode,LinkDisplayType,LinkMethod,ShowUnChecked,UncheckedPrefix,
	CheckedPrefix,OneByOneLink,TemplateCode,TemplateName,SectionCode,
	SectionName,ShowSignerDescription,HeaderImageCode,FingerImageCode,IsBindImage,
	SilentSynch
	FROM EMRmeta.CommonEleValues
	WHERE TemplateCode = :aTemplateCode 
	and SectionCode = :aSectionCode
	and Code = :aCode
}

/// 更新一个数据元
ClassMethod SelectComnonEByID(AComnonEByID As %String) As EMRservice.entity.ECommonEleValues [ WebMethod ]
{
	set objCommonEleValues=##class(EMRmeta.CommonEleValues).%OpenId(AComnonEByID)
	quit:(objCommonEleValues="") "0"

	s objECommonEleValues =  ##Class(EMRservice.entity.ECommonEleValues).%New()
	s objECommonEleValues.DisplayName = objCommonEleValues.DisplayName
	s objECommonEleValues.ElemType=objCommonEleValues.ElemType
	s objECommonEleValues.Code=objCommonEleValues.Code
	s objECommonEleValues.Description=objCommonEleValues.Description
	s objECommonEleValues.BindType=objCommonEleValues.BindType
	s objECommonEleValues.BindCode=objCommonEleValues.BindCode
	s objECommonEleValues.Synch=objCommonEleValues.Synch
	s objECommonEleValues.AllowNull=objCommonEleValues.AllowNull
	s objECommonEleValues.ValidateMsg=objCommonEleValues.ValidateMsg
	s objECommonEleValues.RegExp=objCommonEleValues.RegExp
	s objECommonEleValues.MaxLength=objCommonEleValues.MaxLength
	s objECommonEleValues.ConfidentialityCode=objCommonEleValues.ConfidentialityCode
	s objECommonEleValues.ReadOnly=objCommonEleValues.ReadOnly
	s objECommonEleValues.TabIndex=objCommonEleValues.TabIndex
	s objECommonEleValues.FixedStructs=objCommonEleValues.FixedStructs
	s objECommonEleValues.Visible=objCommonEleValues.Visible
	s objECommonEleValues.DynamicField=objCommonEleValues.DynamicField
	s objECommonEleValues.IncludeDate=objCommonEleValues.IncludeDate
	s objECommonEleValues.IncludeTime=objCommonEleValues.IncludeTime
	s objECommonEleValues.DateFormat=objCommonEleValues.DateFormat
	s objECommonEleValues.TimeFormat=objCommonEleValues.TimeFormat
	s objECommonEleValues.MinVal=objCommonEleValues.MinVal
	s objECommonEleValues.MaxVal=objCommonEleValues.MaxVal
	s objECommonEleValues.HasMinVal=objCommonEleValues.HasMinVal
	s objECommonEleValues.HasMaxVal=objCommonEleValues.HasMaxVal
	s objECommonEleValues.IncludeMin=objCommonEleValues.IncludeMin
	s objECommonEleValues.IncludeMax=objCommonEleValues.IncludeMax
	s objECommonEleValues.DecimalPlace=objCommonEleValues.DecimalPlace
	s objECommonEleValues.WrapChoice=objCommonEleValues.WrapChoice
	s objECommonEleValues.Choices=objCommonEleValues.Choices
	s objECommonEleValues.DictionaryType=objCommonEleValues.DictionaryType
	s objECommonEleValues.CodeSystem=objCommonEleValues.CodeSystem
	s objECommonEleValues.CodeSystemName=objCommonEleValues.CodeSystemName
	s objECommonEleValues.CustDicClassName=objCommonEleValues.CustDicClassName
	s objECommonEleValues.DisplayType=objCommonEleValues.DisplayType
	s objECommonEleValues.Separator=objCommonEleValues.Separator
	s objECommonEleValues.FirstColType=objCommonEleValues.FirstColType
	s objECommonEleValues.SecondColType=objCommonEleValues.SecondColType
	s objECommonEleValues.ThirdColType=objCommonEleValues.ThirdColType
	s objECommonEleValues.AllowCodeNull=objCommonEleValues.AllowCodeNull
	s objECommonEleValues.AllowValueNull=objCommonEleValues.AllowValueNull
	s objECommonEleValues.AssociateItem=objCommonEleValues.AssociateItem
	s objECommonEleValues.AllowEdit=objCommonEleValues.AllowEdit
	s objECommonEleValues.SignatureLevel=objCommonEleValues.SignatureLevel
	s objECommonEleValues.LinkCode=objCommonEleValues.LinkCode
	s objECommonEleValues.LinkDisplayType=objCommonEleValues.LinkDisplayType
	s objECommonEleValues.LinkMethod=objCommonEleValues.LinkMethod
	s objECommonEleValues.ShowUnChecked=objCommonEleValues.ShowUnChecked
	s objECommonEleValues.UncheckedPrefix=objCommonEleValues.UncheckedPrefix
	s objECommonEleValues.CheckedPrefix=objCommonEleValues.CheckedPrefix
	s objECommonEleValues.OneByOneLink=objCommonEleValues.OneByOneLink
	s objECommonEleValues.TemplateCode=objCommonEleValues.TemplateCode
	s objECommonEleValues.TemplateName=objCommonEleValues.TemplateName
	s objECommonEleValues.SectionCode=objCommonEleValues.SectionCode
	s objECommonEleValues.SectionName=objCommonEleValues.SectionName
	s objECommonEleValues.ShowSignerDescription = objCommonEleValues.ShowSignerDescription
	s objECommonEleValues.HeaderImageCode = objCommonEleValues.HeaderImageCode
	s objECommonEleValues.FingerImageCode = objCommonEleValues.FingerImageCode
	s objECommonEleValues.IsBindImage = objCommonEleValues.IsBindImage
	s objECommonEleValues.SilentSynch = objCommonEleValues.SilentSynch
	quit objECommonEleValues
}

/// 创建一个数据元
ClassMethod CreateCommonEleV(aECommonEleValues As EMRservice.entity.ECommonEleValues) As %String [ WebMethod ]
{
	set objCommonEleValues=##class(EMRmeta.CommonEleValues).%New()
	quit:(objCommonEleValues="") ""
	s objCommonEleValues.DisplayName = aECommonEleValues.DisplayName
	s objCommonEleValues.ElemType=aECommonEleValues.ElemType
	s objCommonEleValues.Code=aECommonEleValues.Code
	s objCommonEleValues.Description=aECommonEleValues.Description
	s objCommonEleValues.BindType=aECommonEleValues.BindType
	s objCommonEleValues.BindCode=aECommonEleValues.BindCode
	s objCommonEleValues.Synch=aECommonEleValues.Synch
	s objCommonEleValues.AllowNull=aECommonEleValues.AllowNull
	s objCommonEleValues.ValidateMsg=aECommonEleValues.ValidateMsg
	s objCommonEleValues.RegExp=aECommonEleValues.RegExp
	s objCommonEleValues.MaxLength=aECommonEleValues.MaxLength
	s objCommonEleValues.ConfidentialityCode=aECommonEleValues.ConfidentialityCode
	s objCommonEleValues.ReadOnly=aECommonEleValues.ReadOnly
	s objCommonEleValues.TabIndex=aECommonEleValues.TabIndex
	s objCommonEleValues.FixedStructs=aECommonEleValues.FixedStructs
	s objCommonEleValues.Visible=aECommonEleValues.Visible
	s objCommonEleValues.DynamicField=aECommonEleValues.DynamicField
	s objCommonEleValues.IncludeDate=aECommonEleValues.IncludeDate
	s objCommonEleValues.IncludeTime=aECommonEleValues.IncludeTime
	s objCommonEleValues.DateFormat=aECommonEleValues.DateFormat
	s objCommonEleValues.TimeFormat=aECommonEleValues.TimeFormat
	s objCommonEleValues.MinVal=aECommonEleValues.MinVal
	s objCommonEleValues.MaxVal=aECommonEleValues.MaxVal
	s objCommonEleValues.HasMinVal=aECommonEleValues.HasMinVal
	s objCommonEleValues.HasMaxVal=aECommonEleValues.HasMaxVal
	s objCommonEleValues.IncludeMin=aECommonEleValues.IncludeMin
	s objCommonEleValues.IncludeMax=aECommonEleValues.IncludeMax
	s objCommonEleValues.DecimalPlace=aECommonEleValues.DecimalPlace
	s objCommonEleValues.WrapChoice=aECommonEleValues.WrapChoice
	s objCommonEleValues.Choices=aECommonEleValues.Choices
	s objCommonEleValues.DictionaryType=aECommonEleValues.DictionaryType
	s objCommonEleValues.CodeSystem=aECommonEleValues.CodeSystem
	s objCommonEleValues.CodeSystemName=aECommonEleValues.CodeSystemName
	s objCommonEleValues.CustDicClassName=aECommonEleValues.CustDicClassName
	s objCommonEleValues.DisplayType=aECommonEleValues.DisplayType
	s objCommonEleValues.Separator=aECommonEleValues.Separator
	s objCommonEleValues.FirstColType=aECommonEleValues.FirstColType
	s objCommonEleValues.SecondColType=aECommonEleValues.SecondColType
	s objCommonEleValues.ThirdColType=aECommonEleValues.ThirdColType
	s objCommonEleValues.AllowCodeNull=aECommonEleValues.AllowCodeNull
	s objCommonEleValues.AllowValueNull=aECommonEleValues.AllowValueNull
	s objCommonEleValues.AssociateItem=aECommonEleValues.AssociateItem
	s objCommonEleValues.AllowEdit=aECommonEleValues.AllowEdit
	s objCommonEleValues.SignatureLevel=aECommonEleValues.SignatureLevel
	s objCommonEleValues.LinkCode=aECommonEleValues.LinkCode
	s objCommonEleValues.LinkDisplayType=aECommonEleValues.LinkDisplayType
	s objCommonEleValues.LinkMethod=aECommonEleValues.LinkMethod
	s objCommonEleValues.ShowUnChecked=aECommonEleValues.ShowUnChecked
	s objCommonEleValues.UncheckedPrefix=aECommonEleValues.UncheckedPrefix
	s objCommonEleValues.CheckedPrefix=aECommonEleValues.CheckedPrefix
	s objCommonEleValues.OneByOneLink=aECommonEleValues.OneByOneLink
	s objCommonEleValues.TemplateCode=aECommonEleValues.TemplateCode
	s objCommonEleValues.TemplateName=aECommonEleValues.TemplateName
	s objCommonEleValues.SectionCode=aECommonEleValues.SectionCode
	s objCommonEleValues.SectionName=aECommonEleValues.SectionName
	s objCommonEleValues.ShowSignerDescription = aECommonEleValues.ShowSignerDescription
	s objCommonEleValues.HeaderImageCode = aECommonEleValues.HeaderImageCode
	s objCommonEleValues.FingerImageCode = aECommonEleValues.FingerImageCode
	s objCommonEleValues.IsBindImage = aECommonEleValues.IsBindImage
	s objCommonEleValues.SilentSynch = aECommonEleValues.SilentSynch
	s sc = objCommonEleValues.%Save()
	if ($$$ISOK(sc))
	{
		quit objCommonEleValues.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个数据元
ClassMethod DeleteCommonEleVByID(aCargroyId As %String) As %String [ WebMethod ]
{
	q:(aCargroyId ="") "-1"
	s objCommonEleValues = ##Class(EMRmeta.CommonEleValues).%OpenId(aCargroyId)
	q:(objCommonEleValues="") "-1"
	s sc = ##class(EMRmeta.CommonEleValues).%DeleteId(aCargroyId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个数据元
ClassMethod UpdateCommonEleV(aECommonEleValues As EMRservice.entity.ECommonEleValues) As %String [ WebMethod ]
{
	set objCommonEleValues=##class(EMRmeta.CommonEleValues).%OpenId(aECommonEleValues.ID)
	quit:(objCommonEleValues="") "0"

	s objCommonEleValues.DisplayName = aECommonEleValues.DisplayName
	s objCommonEleValues.Description=aECommonEleValues.Description
	s objCommonEleValues.BindType=aECommonEleValues.BindType
	s objCommonEleValues.BindCode=aECommonEleValues.BindCode
	s objCommonEleValues.Synch=aECommonEleValues.Synch
	s objCommonEleValues.AllowNull=aECommonEleValues.AllowNull
	s objCommonEleValues.ValidateMsg=aECommonEleValues.ValidateMsg
	s objCommonEleValues.RegExp=aECommonEleValues.RegExp
	s objCommonEleValues.MaxLength=aECommonEleValues.MaxLength
	s objCommonEleValues.ConfidentialityCode=aECommonEleValues.ConfidentialityCode
	s objCommonEleValues.ReadOnly=aECommonEleValues.ReadOnly
	s objCommonEleValues.TabIndex=aECommonEleValues.TabIndex
	s objCommonEleValues.FixedStructs=aECommonEleValues.FixedStructs
	s objCommonEleValues.Visible=aECommonEleValues.Visible
	s objCommonEleValues.DynamicField=aECommonEleValues.DynamicField
	s objCommonEleValues.IncludeDate=aECommonEleValues.IncludeDate
	s objCommonEleValues.IncludeTime=aECommonEleValues.IncludeTime
	s objCommonEleValues.DateFormat=aECommonEleValues.DateFormat
	s objCommonEleValues.TimeFormat=aECommonEleValues.TimeFormat
	s objCommonEleValues.MinVal=aECommonEleValues.MinVal
	s objCommonEleValues.MaxVal=aECommonEleValues.MaxVal
	s objCommonEleValues.HasMinVal=aECommonEleValues.HasMinVal
	s objCommonEleValues.HasMaxVal=aECommonEleValues.HasMaxVal
	s objCommonEleValues.IncludeMin=aECommonEleValues.IncludeMin
	s objCommonEleValues.IncludeMax=aECommonEleValues.IncludeMax
	s objCommonEleValues.DecimalPlace=aECommonEleValues.DecimalPlace
	s objCommonEleValues.WrapChoice=aECommonEleValues.WrapChoice
	s objCommonEleValues.Choices=aECommonEleValues.Choices
	s objCommonEleValues.DictionaryType=aECommonEleValues.DictionaryType
	s objCommonEleValues.CodeSystem=aECommonEleValues.CodeSystem
	s objCommonEleValues.CodeSystemName=aECommonEleValues.CodeSystemName
	s objCommonEleValues.CustDicClassName=aECommonEleValues.CustDicClassName
	s objCommonEleValues.DisplayType=aECommonEleValues.DisplayType
	s objCommonEleValues.Separator=aECommonEleValues.Separator
	s objCommonEleValues.FirstColType=aECommonEleValues.FirstColType
	s objCommonEleValues.SecondColType=aECommonEleValues.SecondColType
	s objCommonEleValues.ThirdColType=aECommonEleValues.ThirdColType
	s objCommonEleValues.AllowCodeNull=aECommonEleValues.AllowCodeNull
	s objCommonEleValues.AllowValueNull=aECommonEleValues.AllowValueNull
	s objCommonEleValues.AssociateItem=aECommonEleValues.AssociateItem
	s objCommonEleValues.AllowEdit=aECommonEleValues.AllowEdit
	s objCommonEleValues.SignatureLevel=aECommonEleValues.SignatureLevel
	s objCommonEleValues.LinkCode=aECommonEleValues.LinkCode
	s objCommonEleValues.LinkDisplayType=aECommonEleValues.LinkDisplayType
	s objCommonEleValues.LinkMethod=aECommonEleValues.LinkMethod
	s objCommonEleValues.ShowUnChecked=aECommonEleValues.ShowUnChecked
	s objCommonEleValues.UncheckedPrefix=aECommonEleValues.UncheckedPrefix
	s objCommonEleValues.CheckedPrefix=aECommonEleValues.CheckedPrefix
	s objCommonEleValues.OneByOneLink=aECommonEleValues.OneByOneLink
	s objCommonEleValues.TemplateCode=aECommonEleValues.TemplateCode
	s objCommonEleValues.TemplateName=aECommonEleValues.TemplateName
	s objCommonEleValues.SectionCode=aECommonEleValues.SectionCode
	s objCommonEleValues.SectionName=aECommonEleValues.SectionName
	s objCommonEleValues.ShowSignerDescription = aECommonEleValues.ShowSignerDescription
	s objCommonEleValues.HeaderImageCode = aECommonEleValues.HeaderImageCode
	s objCommonEleValues.FingerImageCode = aECommonEleValues.FingerImageCode
	s objCommonEleValues.IsBindImage = aECommonEleValues.IsBindImage
	s objCommonEleValues.SilentSynch = aECommonEleValues.SilentSynch
	s sc = objCommonEleValues.%Save()
	if ($$$ISOK(sc))
	{

		q (objCommonEleValues.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// 得到最大code编号
ClassMethod selectMaxRowID() As %String
{
	//s IdexCode=0
	&sql(select max(id) into :IdexCode from EMRmeta.CommonEleValues)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

}

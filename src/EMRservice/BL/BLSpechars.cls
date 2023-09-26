/// Desc：特殊字符逻辑
/// Creaotr:    Candy
/// CreateDate: 2015-3-3
Class EMRservice.BL.BLSpechars Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##Class(EMRservice.BL.BLSpechars).initSpechars(3,"●","●",3)
ClassMethod initSpechars(ACatagoryID As %String, ACode As %String, ADesc As %String, ASqe As %String)
{
	q:(ACatagoryID = "")
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%OpenId(ACatagoryID)
	q:(objCatagory = "")
	s objSpechars = ##Class(EMRmeta.Spechars).%New()
	s objSpechars.Category = objCatagory
	s objSpechars.CharCode = ACode
	s objSpechars.CharDesc = ADesc
	s objSpechars.Sequence = ASqe
	d objSpechars.%Save()
}

/// Desc:       特殊字符	
/// Creaotr:    Candy
/// CreateDate: 2015-3-3
/// Output:     json
/// Debug:      w ##Class(EMRservice.BL.BLSpechars).GetSpechars()
ClassMethod GetSpechars() As %String
{
	s result = ""
	s count = 0
	s seq = ""
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	for
	{
		s seq = $o(^DHCEMRM.SpecharsCategoryI("IdxSequence",seq))
		q:(seq = "")
		s catagoryId = ""
		for
		{
			s catagoryId = $o(^DHCEMRM.SpecharsCategoryI("IdxSequence",seq,catagoryId)) 
			q:(catagoryId = "")
			s objCagagory = ##Class(EMRmeta.SpecharsCategory).%OpenId(catagoryId)
			continue:(objCagagory = "")
			s:(count '= 0) result = result_","
			s cateName =  ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.SpecharsCategory","CategoryDesc",objCagagory.CategoryDesc,langid)
			s result = result_"{"
			s result = result_"""Code"":"""_objCagagory.CategoryCode_""""
			s result = result_",""Desc"":"""_cateName_""""
			s result = result_",""Values"":["
			s cseq = ""
			s ccount = 0
			for 
			{
				s cseq = $o(^DHCEMRM.SpecharsI("IdxCategorySequence",catagoryId,cseq))
				q:(cseq = "")
				s rowId = ""
				for
				{
					s rowId = $o(^DHCEMRM.SpecharsI("IdxCategorySequence",catagoryId,cseq,rowId))
					q:(rowId = "")
					s objSpechars = ##Class(EMRmeta.Spechars).%OpenId(catagoryId_"||"_rowId)
					continue:(objSpechars = "")
					continue:(objSpechars.CharDesc = """")
					s:(ccount '= 0) result = result_","
					s result = result_"{"
					s result = result_"""Code"":"""_$ZSTRIP(objSpechars.CharCode,"*C")_""""
					s result = result_",""Desc"":"""_$ZSTRIP(objSpechars.CharDesc,"*C")_""""
					s result = result_"}"
					s ccount = ccount + 1
				}
			}
			s result = result_"]}"
			s count = count + 1
		}
	}
	q result
}

Query SelectSpecharsCategory() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,CategoryCode:%String,CategoryDesc:%String,Sequence:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_SpecharsCategory_SelectSpecharsCategory, SqlProc ]
{
	SELECT ID,CategoryCode,CategoryDesc,Sequence
	FROM EMRmeta.SpecharsCategory ORDER BY Sequence ASC
}

Query SelectAllSpechars() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,CharCode:%String,CharDesc:%String,Sequence:%String,Category:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_Spechars_SelectAllSpechars, SqlProc ]
{
	SELECT ID,CharCode,CharDesc,Sequence,Category
	FROM EMRmeta.Spechars ORDER BY Sequence ASC
}

Query SelectSpecharsByCategory(aCategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,CharCode:%String,CharDesc:%String,Sequence:%String,Category:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_Spechars_SpecharsByCategory, SqlProc ]
{
	SELECT ID,CharCode,CharDesc,Sequence,Category
	FROM EMRmeta.Spechars 
	where Category = :aCategoryID ORDER BY ID ASC
}

/// 得到最大code编号
ClassMethod GetCategroyMaxSeq() As %String
{
	&sql(select max(Sequence) into :IdexSequence from EMRmeta.SpecharsCategory)
	s:(IdexSequence="") IdexSequence=0
	q IdexSequence
}

/// 得到最大code编号
ClassMethod GetSpecharMaxSeq() As %String
{
	&sql(select max(Sequence) into :IdexSequence from EMRmeta.Spechars)
	s:(IdexSequence="") IdexSequence=0
	q IdexSequence
}

/// 创建一个目录
ClassMethod CreateSpecharsCategory(aESpecharsCategory As EMRservice.entity.ESpecharsCategory) As %String [ WebMethod ]
{
	/// b "s"	
	set objSpecharsCategory=##class(EMRmeta.SpecharsCategory).%New()
	q:(objSpecharsCategory="") ""	
	set objSpecharsCategory.CategoryCode=aESpecharsCategory.CategoryCode
	set objSpecharsCategory.CategoryDesc=aESpecharsCategory.CategoryDesc
	set objSpecharsCategory.Sequence=aESpecharsCategory.Sequence
	s sc = objSpecharsCategory.%Save()
	if ($$$ISOK(sc))
	{		
		 q objSpecharsCategory.%Id()
	}
	else
	{
		 q "-1"	
	}
}

/// 更新一个目录
ClassMethod UpdateSpecharsCategory(aESpecharsCategory As EMRservice.entity.ESpecharsCategory) As %String [ WebMethod ]
{
	/// b "s"	
	set objSpecharsCategory=##class(EMRmeta.SpecharsCategory).%OpenId(aESpecharsCategory.ID)
	q:(objSpecharsCategory="") ""	
	set objSpecharsCategory.CategoryCode=aESpecharsCategory.CategoryCode
	set objSpecharsCategory.CategoryDesc=aESpecharsCategory.CategoryDesc
	set objSpecharsCategory.Sequence=aESpecharsCategory.Sequence
	s sc = objSpecharsCategory.%Save()
	if ($$$ISOK(sc))
	{		
		 q aESpecharsCategory.ID
	}
	else
	{
		 q "-1"	
	}
}

/// 删除一个目录
ClassMethod DeleteSpecharsCategory(aSpecharsCategoryID As %String) As %String [ WebMethod ]
{
	
    q:(aSpecharsCategoryID ="") "-1"
    s objSpecharsCategory = ##Class(EMRmeta.SpecharsCategory).%OpenId(aSpecharsCategoryID)
	q:(objSpecharsCategory="") "-1"
	s sc = ##class(EMRmeta.SpecharsCategory).%DeleteId(aSpecharsCategoryID)
	if ($$$ISOK(sc))
	{	
		q (+sc)
    }
    else
    {
		q "-1"
	}
}

/// 创建一个目录
ClassMethod CreateSpechars(aSpecharsCategoryID As %String, aESpechars As EMRservice.entity.ESpechars) As %String [ WebMethod ]
{
	s strReslt = "-1"	
	q:(aSpecharsCategoryID="") strReslt	
	s objSpecharsCategory=##class(EMRmeta.SpecharsCategory).%OpenId(aSpecharsCategoryID)
	q:(objSpecharsCategory="") ""
	
	set objSpechars=##class(EMRmeta.Spechars).%New()
	q:(objSpechars="") ""	
	set objSpechars.CharCode=aESpechars.CharCode
	set objSpechars.CharDesc=aESpechars.CharDesc
	set objSpechars.Sequence=aESpechars.Sequence
	set objSpechars.Category = objSpecharsCategory
	s sc = objSpechars.%Save()
	if ($$$ISOK(sc))
	{		
		s strReslt = objSpechars.%Id()
	}
	else
	{
		s strReslt= "-1"	
	}
	q strReslt
}

/// 更新一个目录
ClassMethod UpdateSpechars(aESpechars As EMRservice.entity.ESpechars) As %String [ WebMethod ]
{
	/// b "s"	
	s strReslt = "-1"	
	set objSpechars=##class(EMRmeta.Spechars).%OpenId(aESpechars.ID)
	q:(objSpechars="") ""	
	set objSpechars.CharCode=aESpechars.CharCode
	set objSpechars.CharDesc=aESpechars.CharDesc
	set objSpechars.Sequence=aESpechars.Sequence
	s sc = objSpechars.%Save()
	if ($$$ISOK(sc))
	{		
		 s strReslt = objSpechars.%Id()
	}
	else
	{
		 s strReslt= "-1"	
	}
	q strReslt
}

/// 删除一个目录
ClassMethod DeleteSpechars(aSpecharsID As %String) As %String [ WebMethod ]
{
	
    q:(aSpecharsID ="") "-1"
    s objSpechars = ##Class(EMRmeta.Spechars).%OpenId(aSpecharsID)
	q:(objSpechars="") "-1"
	s sc = ##class(EMRmeta.Spechars).%DeleteId(aSpecharsID)
	if ($$$ISOK(sc))
	{	
		q (+sc)
    }
    else
    {
		q "-1"
	}
}

/// 测试
/// d ##Class(EMRservice.BL.BLSpechars).test()
ClassMethod test() As %String
{
	s objSpecharsCategory = ##Class(EMRmeta.SpecharsCategory).%OpenId("29")
	s OrganScheme = ##Class(EMRservice.entity.ESpechars).%New()
	s OrganScheme.ID= "29||4"
	s OrganScheme.CharCode="29"
	S OrganScheme.CharDesc ="29"
	s OrganScheme.Sequence="2"
	//s OrganScheme.Category = objSpecharsCategory
	d ..UpdateSpechars(OrganScheme)
}

/// d ##Class(EMRservice.BL.BLSpechars).setDefaultSpechars()
ClassMethod setDefaultSpechars()
{
	&SQL(delete FROM EMRmeta.SpecharsCategory)
	
	s strtsFH = "特殊符号 ＃ ＠ ＆ ＊ ※ § 〃 № 〓 ○ ● △ ▲ ◎ ☆ ★ ◇ ◆ □ ■ ▽ ▼ ㊣ ℅ ˉ ￣ ＿ ﹉ ﹊ ﹍ ﹎ ﹋ ﹌ ﹟ ﹠ ﹡ ♀ ♂ ⊕ ⊙ ↑ ↓ ← → ↖ ↗ ↙ ↘ ∥ ∣ ／ ＼ ∕ ﹨"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strtsFH," ",1)
	s objCatagory.CategoryDesc = $p(strtsFH," ",1)
	s objCatagory.Sequence = 1
	s IDCount = $l(strtsFH," ")
	For I=2:1:IDCount
	 {
		S ACode= $P(strtsFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	 }
	 s strbdFH = "标点符号 ， 、 。 ． ； ： ？ ！ ︰ … ‥ ′ ‵ 々 ～ ‖ ˇ ˉ ﹐ ﹑ ﹒ · ﹔ ﹕ ﹖ ﹗ ｜ – ︱ — ︳ ︴ ﹏ （ ） ︵ ︶｛ ｝ ︷ ︸ 〔 〕 ︹ ︺ 【 】 ︻ ︼ 《 》 ︽ ︾ 〈 〉 ︿ ﹀ 「 」 ﹁ ﹂ 『 』 ﹃ ﹄ ﹙ ﹚ ﹛ ﹜ ﹝ ﹞ ‘ ’ "" "" 〝 〞 ˋ ˊ"
	 s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strbdFH," ",1)
	s objCatagory.CategoryDesc = $p(strbdFH," ",1)
	s objCatagory.Sequence = 2
	s IDCount = $l(strbdFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strbdFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strdwFH = "单位符号 ° ′ ″ ＄ ￥ 〒 ￠ ￡ ％ ＠ ℃ ℉ ﹩ ﹪ ‰ ﹫ ㏕ ㎜ ㎝ ㎞ ㏎ ㎡ ㎎ ㎏ ㏄ ° ○ ¤"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strdwFH," ",1)
	s objCatagory.CategoryDesc = $p(strdwFH," ",1)
	s objCatagory.Sequence = 3
	s IDCount = $l(strdwFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strdwFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strszFH = "数字符号 ⅰ ⅱ ⅲ ⅳ ⅴ ⅵ ⅶ ⅷ ⅸ ⅹ Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ Ⅺ Ⅻ ⒈ ⒉ ⒊ ⒋ ⒌ ⒍ ⒎ ⒏ ⒐ ⒑ ⒒ ⒓ ⒔ ⒕ ⒖ ⒗ ⒘ ⒙ ⒚ ⒛ ⑴ ⑵ ⑶ ⑷ ⑸ ⑹ ⑺ ⑻ ⑼ ⑽ ⑾ ⑿ ⒀ ⒁ ⒂ ⒃ ⒄ ⒅ ⒆ ⒇ ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ㈠ ㈡ ㈢ ㈣ ㈤ ㈥ ㈦ ㈧ ㈨ ㈩"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strszFH," ",1)
	s objCatagory.CategoryDesc = $p(strszFH," ",1)
	s objCatagory.Sequence = 4
	s IDCount = $l(strszFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strszFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strsxFH = "数学符号 ≈ ≡ ≠ ＝ ≤ ≥ ＜ ＞ ≮ ≯ ∷ ± ＋ － × ÷ ／ ∫ ∮ ∝ ∞ ∧ ∨ ∑ ∏ ∪ ∩ ∈ ∵ ∴ ⊥ ∥ ∠ ⌒ ⊙ ≌ ∽ √ ≦ ≧ ≒ ≡ ﹢ ﹣ ﹤ ﹥ ﹦ ～ ∟ ⊿ ㏒ ㏑" 
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strsxFH," ",1)
	s objCatagory.CategoryDesc = $p(strsxFH," ",1)
	s objCatagory.Sequence = 5
	s IDCount = $l(strsxFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strsxFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strxnFH = "希腊子母 α β γ δ ε ζ η θ ι κ λ μ ν ξ ο π ρ σ τ υ φ χ ψ ω Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strxnFH," ",1)
	s objCatagory.CategoryDesc = $p(strxnFH," ",1)
	s objCatagory.Sequence = 6
	s IDCount = $l(strxnFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strxnFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
	s strxnFH = "自定义 ×10<SUP>9</SUP>/L ×10<SUP>12</SUP>/L mmol/L ㎏/㎡ mmHg └1 └2 └3 └4 └5 └6 └7 └8 └I └II └III └IV └V └VI 1┘ 2┘ 3┘ 4┘ 5┘ 6┘ 7┘ 8┘ I┘ II┘ III┘ IV┘ V┘ VI┘ 1┐ 2┐ 3┐ 4┐ 5┐ 6┐ 7┐ 8┐ I┐ II┐ III┐ IV┐ V┐ VI┐ ┌1 ┌2 ┌3 ┌4 ┌5 ┌6 ┌7 ┌8 ┌I ┌II ┌III ┌IV ┌V ┌VI"
	s objCatagory = ##Class(EMRmeta.SpecharsCategory).%New()
	s objCatagory.CategoryCode = $p(strxnFH," ",1)
	s objCatagory.CategoryDesc = $p(strxnFH," ",1)
	s objCatagory.Sequence = 7
	s IDCount = $l(strxnFH," ")
	For I=2:1:IDCount
	{
		S ACode= $P(strxnFH," ",I)
		s objSpechars = ##Class(EMRmeta.Spechars).%New()
		s objSpechars.Category = objCatagory
		s objSpechars.CharCode = ACode
		s objSpechars.CharDesc = ACode
		s objSpechars.Sequence = I-1
		d objSpechars.%Save()
	}
}

/// Desc:       获取带格式的特殊字符json串,用于组装插件命令	
/// Creaotr:    Donglulu
/// CreateDate: 2017-5-8
/// Input:      选中的特殊字符,以“^”分隔
/// Output:     带格式的特殊字符json串
/// Debug:      w ##Class(EMRservice.BL.BLSpechars).GetSpecharsStyleTextJson()
ClassMethod GetSpecharsStyleTextJson(SpecharsValues As %String) As %String
{
	s result = ""
	s json = ""
	s style = ""
    q:(SpecharsValues = "") result
    s valueCount=$l(SpecharsValues, "^")
	f i=2:1:valueCount 
	{
		s spechars = $p(SpecharsValues, "^", i)
		q:(spechars = "")
		s specharsValue = $p(spechars, "#", 1)
		continue:(specharsValue = "")
		s style = $p(spechars, "#", 2)
		continue:(style = "")
		s:(json '= "") json = json_","
		s json = json_"{"
		s json = json_"""STYLE"":["""_style_"""]"
		s json = json_",""TEXT"":"""_specharsValue_""""
		s json = json_"}"
	}
	s result = result_"{""items"":"
	s result = result_"["
	s result = result_json
	s result = result_"]}"
	s result = $ZSTRIP(result,"*C")
  	q result
}

}

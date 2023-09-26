/// 名称:导入医用知识库数据
/// 编写者：基础平台组-张云越 
/// 编写日期: 2019-09-08
Class web.DHCBL.MKB.ImportMKBData Extends %RegisteredObject
{

/// Creator:张云越(修改web.DHCBL.MKB.MKBDataImport中代码)
/// CreatDate:2019-09-24
/// Description：导入global
/// Table： 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ExportMKBData).InData("D:\测试\MKBData20190829.gof")	
ClassMethod InData(filePath As %String)
{
	d $SYSTEM.OBJ.ImportDir(filePath)
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：新增数据到各版本ICD对照界面，相同诊断时加入数据来源，不同时新增
/// Table：User.MKBICDContrast
/// Input：完整的文件路径 
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ImportMKBData).InsertICD1("E:\test\导入四版本ICD.csv")
ClassMethod InsertICD1(filePath As %String)
{
	Ts	
	s result = "" 
	s sum=1
	s file=##class(%File).%New(filePath)
	d file.Open("RS")
	s Line =  file.ReadLine()
	s TermBaseId = $o(^User.MKBTermBaseI("DescIndex"," ICD版本",0)) //ICD版本的RowId
	s TermId1 = $o(^User.MKBTermBaseI("DescIndex",TermBaseId," ICD-10 v6.01版",0))
	s TermId2 = $o(^User.MKBTermBaseI("DescIndex",TermBaseId," 疾病分类与ICD代码(2015国家修订版)",0))
	s TermId3 = $o(^User.MKBTermBaseI("DescIndex",TermBaseId," 疾病分类与代码国家临床版1.1",0))
	s TermId4 = $o(^User.MKBTermBaseI("DescIndex",TermBaseId," 疾病分类与代码国家临床版2.0",0))
	//s source = $p(Line,",",4)
	
	while 'file.AtEnd
	{
		s sum = sum+1
		s Line=file.ReadLine()
		continue:Line=""
		s ICDNumber=""
		s ICDNumber=$p(Line,",",1)
		s ICDDesc=$p(Line,",",2)
		s ICDExtend=""
		s ICDExtend=$p(Line,",",3)
		b:ICDDesc=""
		s Desc=$zstrip(ICDDesc,"<>W")
		s ICDNumber=##class(web.DHCBL.BDP.FunLib).EvalJSON(ICDNumber)
		s Desc=##class(web.DHCBL.BDP.FunLib).EvalJSON(Desc)
		s ICDExtend=##class(web.DHCBL.BDP.FunLib).EvalJSON(ICDExtend)
		s Diag=$Replace(Desc,"(","（")
		s Diag=$Replace(Diag,")","）")
		s ICDNumber=$zstrip(ICDNumber,"<>W")
		s Diagg=$zconvert(Diag,"U")
		if ICDExtend["?"
		{
			s cc=$c(8224)
			s ICDExtend=$replace(ICDExtend,"?",cc)
		}
		if ICDNumber["?"
		{
			s cc=$c(8224)
			s ICDNumber=$replace(ICDNumber,"?",cc)
		}
		if $d(^User.MKBICDContrastI("DescIndex"," "_Diagg))   //如果统一符号存在相同诊断
		{	
			s ExistRowid=0
			for
			{
				s ExistRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diagg,ExistRowid))
				q:ExistRowid=""
				s ExistICD=""
				s ExistICD=$lg($g(^User.MKBICDContrastD(ExistRowid)),4)
				if (ExistICD=ICDNumber)      //如果ICD也一样，则加入数据来源
				{
					s obj=##class(User.MKBICDContrast).%OpenId(ExistRowid)
					s tempsource=obj.MKBICDDiaSource
					s sources=##class(%File).GetFilename(filename)
					s source=$e(sources,1,*-4)	
					s ICDSource=$select(source="ICD-10 v6.01版":TermId1,source="疾病分类与ICD代码(2015国家修订版)":TermId2,source="疾病分类与代码国家临床版1.1":TermId3,source="疾病分类与代码国家临床版2.0":TermId4)
					if tempsource'[ICDSource
					{
						s obj.MKBICDDiaSource=tempsource_"&"_ICDSource
					}
				}
				else    //如果ICD不相同的，则保存处理符号后的
				{
					s obj=##class(User.MKBICDContrast).%New()
					s obj.MKBICDConDesc=Diag
					s obj.MKBICDConNumber=ICDNumber
					s:ICDExtend'="" obj.MKBICDConExtendNumber=ICDExtend
					s obj.MKBICDConStatus="N"
					s sources=##class(%File).GetFilename(filename)
					s source=$e(sources,1,*-4)
					s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
					s obj.MKBICDDiaSource=ICDSource
				}
			}
		}
		else
		{
			s obj=##class(User.MKBICDContrast).%New()
			s obj.MKBICDConDesc=Diag
			s obj.MKBICDConNumber=ICDNumber
			s:ICDExtend'="" obj.MKBICDConExtendNumber=ICDExtend
			s obj.MKBICDConStatus="N"
			s sources=##class(%File).GetFilename(filename)
			s source=$e(sources,1,*-4)
			s ICDSource=$select(source="ICD-10 v6.01版":"A",source="疾病分类与ICD代码(2015国家修订版)":"B",source="疾病分类与代码国家临床版1.1":"C",source="疾病分类与代码国家临床版2.0":"D")
			s obj.MKBICDDiaSource=ICDSource
		}
		b:ICDSource["E"
		s sc=obj.%Save()
		d obj.%Close()
		if $$$ISOK(sc)
		{
			tc
			s result = result_"^"_"成功"
			;q
			;s id=obj.%Id()
			;s sum=sum+1
		}
		else
		{
			tro
			s result = result_"^"_"失败"_"^"_sum
			q
			;b ;1			
		}
	}

	w !
	q result
	;q sum
}

/// Creator:张云越(修改李得原web.DHCBL.MKB.MKBStructedDiag中代码)
/// CreatDate:2019-09-20
/// Description：各版本ICD对照界面分词导入
/// Table：User.MKBICDContrast
/// Input：完整的文件路径
/// Return：
/// Other: w ##class(web.DHCBL.MKB.ImportMKBData).ICDContrastInsertSegement("E:\test\导入ICD对照界面的分词.csv")
ClassMethod ICDContrastInsertSegement(filePath)
{
	Ts
	s result = "" 
	;s sum=0
	
	s m=0
	s n=0
	s file=##class(%File).%New(filePath)
	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s Line=file.ReadLine()
		continue:Line=""
		s m=m+1
		s MKBICDDesc=$p(Line,",",1)
		s CenterWord=$p(Line,",",2)
		s Property=$p(Line,",",3)
		s Diag=$zconvert(MKBICDDesc,"U")
		
		s str=""
		if CenterWord=""
		{
			s str="("_Property_")"
		}
		else
		{
			if Property=""
			{
				s str=CenterWord
			}
			else
			{
				s str=CenterWord_"("_Property_")"
			}
		}
		s MKBICDRowid=0
		for
		{
		 	s MKBICDRowid=$o(^User.MKBICDContrastI("DescIndex"," "_Diag,MKBICDRowid)) 
		 	q:MKBICDRowid=""
		 	s n=n+1
		 	s obj=##class(User.MKBICDContrast).%OpenId(MKBICDRowid)
		 	s obj.MKBICDConSegmentation=str
		 	s sc=obj.%Save()
			d obj.%Close()
			if $$$ISOK(sc)
			{
				;b
				TC
				;s id=obj.%Id()
				;s sum=sum+1
				s result = result_"^"_"成功"
			}
			else
			{
				TRO
				;b ;1
				s result = result_"^"_"失败"_"^"_m
				q	
			}
		}
		if result["失败" q
	}
	;b
	;q sum
	q result
}

}

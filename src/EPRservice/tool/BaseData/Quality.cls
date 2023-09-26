Class EPRservice.tool.BaseData.Quality Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(EPRservice.tool.BaseData.Quality).Main()
ClassMethod Main()
{
	d ..InitQualityParams()
}

/// desc:公共函数
ClassMethod InitQualityParams()
{
	//系统参数
	s ResumeText = "Grade/Score(两种标准:Grade 按级别评定;Score按分数评定)"
    d SetQualityParams("EvaluationType","质控评价类型","Score","Y",ResumeText)
    
    s ResumeText = "设定病历级别(甲>scoreA,scoreB<乙<scoreA、丙<scoreB)"
	d SetQualityParams("ScoreStandard","按分数评定标准","90^70","Y",ResumeText)
	 
	s ResumeText = "注：xml参数，EPRservice.Quality.OperationLogic.GradeEvaluation类TestXML方法可生成xml" 
	s Value = "<OperationItem><Items><Level>Ⅴ级</Level><Grade>3L</Grade><Ruler><![CDATA[3L>=1]]></Ruler></Items><Items><Level>Ⅳ级</Level><Grade>2L</Grade><Ruler><![CDATA[2L>=4]]></Ruler><SpecialRuler><![CDATA[1L|1L>=6]]></SpecialRuler></Items><Items><Level>Ⅲ级</Level><Grade>2L</Grade><Ruler><![CDATA[((2L>=2)&&(2L<=3))]]></Ruler><SpecialRuler><![CDATA[1L|1L>=6]]></SpecialRuler></Items><Items><Level>Ⅱ级</Level><Grade>2L</Grade><Ruler>2L=1</Ruler><SpecialRuler><![CDATA[1L|1L>=6]]></SpecialRuler></Items><Items><Level>Ⅰ级</Level><Grade>1L</Grade><Ruler><![CDATA[((1L>=0)&&(1L<=5))]]></Ruler></Items></OperationItem>"
	d SetQualityParams("GradeStandard","按级别评定标准",Value,"Y",ResumeText)
	
	//业务参数
	d SetQualityParams("SeniorDoctor","主任医师","E1005","Y","病案首页主任医师(值为完整性检查点代码)主要用于出院质控查询显示")
	d SetQualityParams("AttendDoctor","主治医师","E1006","Y","病案首页主治医师(值为完整性检查点代码)主要用于出院质控查询显示") 
	 
SetQualityParams(code, Name, BindValue, IsActive,ResumeText)
    s id=$o(^DHCEPRM.QualityParamsI("IdxCode",code,""))
	if (id = "")	//新增系统参数
	{
		s obj=##Class(EPRmeta.Quality.QualityParams).%New()
		s obj.Code = code
		s obj.Name = Name
		s obj.BindValue = BindValue
		s obj.IsActive = IsActive
		s obj.ResumeText = ResumeText
		d obj.%Save()	
    }
	else	//更新描述
	{
		s obj=##Class(EPRmeta.Quality.QualityParams).%OpenId(id)
		s obj.Name = Name
		s obj.BindValue = BindValue
		s obj.IsActive = IsActive
		s obj.ResumeText = ResumeText
		d obj.%Save()
    }		
	q
}

/// Creator Candy
/// Desc:转移数据。用于上过可查询条目报表 将可查询条目从原来的质控标准 改了条目的一个属性
///     注：之前在质控标准中加入”H,可质控条目"标准，上过质控可查询报表的项目升级时需要运行此方法
/// debug d ##Class(EPRservice.tool.BaseData.Quality).ConvertData()
ClassMethod ConvertData() As %String
{
	s result = ""
	s RuleID = $o(^DHCEPRM.QualityRuleI("IdxCode","H",""))
	q:(RuleID = "") result = "找不到可查询条目质控标准"
	s EntryID = ""
	for {
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_RuleID,EntryID))
		q:(EntryID = "")
		s objEntry = ##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
		continue:(objEntry = "")
		s PoolID = objEntry.PoolDR
		continue:(PoolID = "")
		s objPool = ##Class(EPRmeta.Quality.QualityPool).%OpenId(PoolID)
		continue:(objPool = "")
		s objPool.IsQuery = "Y"
		s objsc = objPool.%Save()
		if ( $$$ISOK(objsc))
		{
			d ##Class(EPRmeta.Quality.QualityEntry).%DeleteId(EntryID)
		}
	}
	d ##Class(EPRmeta.Quality.QualityRule).%DeleteId(RuleID)
	q retslut = 1
}

}

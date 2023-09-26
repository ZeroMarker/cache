/// 名称：		EMRservice.BL.BLCaseGrammarFormula
/// 描述：		语法公式BL层
/// 编写者：	yejian
/// 编写时间：	2016-1-20
Class EMRservice.BL.BLCaseGrammarFormula Extends (%RegisteredObject, %XML.Adaptor)
{

Query SelectCaseGrammarFormula() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,Grammar:%String,GrammarDes:%String,GrammarSeq:%Integer,Remark:%String,DocumentType:%String,Parameter:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CaseGrammarF_SelectCaseGrammarFormula, SqlProc ]
{
	SELECT t.ID,t.Code,t.Name,t.Description,t.Grammar,t.GrammarDes,t.GrammarSeq,t.Remark,t.DocumentType,t.Parameter
	FROM EMRmeta.CaseGrammarFormula t
	order by t.GrammarSeq
}

/// 创建一个语法
ClassMethod CreateCaseGrammarFormula(aECaseGrammarF As EMRservice.entity.ECaseGrammarFormula) As %String
{
	s objCaseGrammarF=##class(EMRmeta.CaseGrammarFormula).%New()
	quit:(objCaseGrammarF="") ""
	s objCaseGrammarF.Code=aECaseGrammarF.Code
	s objCaseGrammarF.Name=aECaseGrammarF.Name
	s objCaseGrammarF.Description=aECaseGrammarF.Description
	s objCaseGrammarF.Grammar=aECaseGrammarF.Grammar
	s objCaseGrammarF.GrammarDes=aECaseGrammarF.GrammarDes
	S strGrammarSeq = ..GetMaxID()+1
	s objCaseGrammarF.GrammarSeq = strGrammarSeq
	s objCaseGrammarF.Remark = aECaseGrammarF.Remark
	s objCaseGrammarF.DocumentType = aECaseGrammarF.DocumentType
	s objCaseGrammarF.Parameter = aECaseGrammarF.Parameter
	
	s sc = objCaseGrammarF.%Save()
	if ($$$ISOK(sc))
	{
		quit objCaseGrammarF.%Id()
	}
	else
	{
		 quit "-1"
	}
}

/// 删除一个语法
ClassMethod DeleteCaseGrammarFormulaByID(aCaseGrammarFormulaId As %String) As %String
{

	q:(aCaseGrammarFormulaId ="") "-1"
	s objCaseGrammar = ##Class(EMRmeta.CaseGrammarFormula).%OpenId(aCaseGrammarFormulaId)
	q:(objCaseGrammar="") "-1"
	s sc = ##class(EMRmeta.CaseGrammarFormula).%DeleteId(aCaseGrammarFormulaId)
	if ($$$ISOK(sc))
	{
		q (+sc)
	}
	else
	{
		q "-1"
	}
}

/// 更新一个语法
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	
	 S IDCount =$L(argStr,",")
	 S strMrk= 1
	 TSTART 
	 For I=1:1:IDCount
	 {
		B
		S argstrItem= $P(argStr,",",I)
		S argCaseGrammarFID = $P(argstrItem,"^",1)
		S argCaseGrammarFSeq = $P(argstrItem,"^",2)
		if ($d(argCaseGrammarFID)=0)||($d(argCaseGrammarFSeq)=0)||(argCaseGrammarFID="")||(argCaseGrammarFSeq="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}
		s objCaseGrammarF="",result=""
		s objCaseGrammarF=##class(EMRmeta.CaseGrammarFormula).%OpenId(argCaseGrammarFID)
		if (objCaseGrammarF ="")
		{
			TROLLBACK
			s strMrk = 0
			quit
		}	
		s objCaseGrammarF.GrammarSeq=argCaseGrammarFSeq
		s result=""
		if '(objCaseGrammarF.%Save())
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

/// 更新一个语法
ClassMethod UpdateCaseGrammarFormula(aECaseGrammarF As EMRservice.entity.ECaseGrammarFormula) As %String
{
	s objCaseGrammarF=##class(EMRmeta.CaseGrammarFormula).%OpenId(aECaseGrammarF.ID)
	quit:(objCaseGrammarF="") "0"
	
	s objCaseGrammarF.Code=aECaseGrammarF.Code
	s objCaseGrammarF.Name=aECaseGrammarF.Name
	s objCaseGrammarF.Description=aECaseGrammarF.Description
	s objCaseGrammarF.Grammar=aECaseGrammarF.Grammar
	s objCaseGrammarF.GrammarDes=aECaseGrammarF.GrammarDes
	s objCaseGrammarF.GrammarSeq = aECaseGrammarF.GrammarSeq
	s objCaseGrammarF.Remark = aECaseGrammarF.Remark
	s objCaseGrammarF.DocumentType = aECaseGrammarF.DocumentType
	s objCaseGrammarF.Parameter = aECaseGrammarF.Parameter

	s sc = objCaseGrammarF.%Save()
	if ($$$ISOK(sc))
	{

		q (objCaseGrammarF.%Id())
	}
	else
	{

		 quit "-1"
	}
}

/// 通过编码获取语法
ClassMethod GetCaseGrammarFormulaByCode(aECaseGrammarFCode As %String) As EMRservice.entity.ECaseGrammarFormula
{
	s strRowID=""
	s strRowID = $O(^DHCEMRM.CaseGrammarFormulaI("IdxCode"," "_aECaseGrammarFCode,""))
	q:(strRowID="") "0"
	s aECaseGrammarF = ##Class(EMRservice.entity.ECaseGrammarFormula).%New()
	s objCaseGrammarF=##class(EMRmeta.CaseGrammarFormula).%OpenId(strRowID)
	s aECaseGrammarF.ID =aECaseGrammarFID
	s aECaseGrammarF.Code=objCaseGrammarF.Code
	s aECaseGrammarF.Name=objCaseGrammarF.Name
	s aECaseGrammarF.Description=objCaseGrammarF.Description
	s aECaseGrammarF.Grammar=objCaseGrammarF.Grammar
	s aECaseGrammarF.GrammarDes=objCaseGrammarF.GrammarDes
	s aECaseGrammarF.GrammarSeq = objCaseGrammarF.GrammarSeq
	s aECaseGrammarF.Remark = objCaseGrammarF.Remark
	s aECaseGrammarF.DocumentType = objCaseGrammarF.DocumentType
	s aECaseGrammarF.Parameter = objCaseGrammarF.Parameter

	q aECaseGrammarF
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String
{
	
	&sql(select id into :IdexCode   from EMRmeta.CaseGrammarFormula where Code=:Acode)
	s:(IdexCode="") IdexCode=0
	q IdexCode
}

/// 得到最大code编号
ClassMethod GetMaxID() As %String
{
	&sql(select max(id) into :IdexId from EMRmeta.CaseGrammarFormula)
	s:(IdexId="") IdexId=0
	q IdexId
}

}

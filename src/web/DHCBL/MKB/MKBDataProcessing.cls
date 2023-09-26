/// 李欣 201801019
/// 数据处理类
/// 基础数据平台
Class web.DHCBL.MKB.MKBDataProcessing Extends %RegisteredObject
{

/// 导出2018.01.01至2018.06.30 所有门急诊患者诊断
/// 用于结构化诊断平台数据分析
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).FindOPDiagNew()
ClassMethod FindOPDiagNew()
{
	s DateFrom=$ZDH("2018-01-01",3)
	s DateTo=$ZDH("2019-01-10",3)
	s File=##class(%File).%New("E:\18诊断.csv") //新建
	d File.Open("NWS")
	
	

	s num=0
	f Date=DateFrom:1:DateTo
	{
		s PatDiag=""
		s AdmRowid=0 
		f
		{
			s AdmRowid=$o(^PAADMi("PAADM_AdmDate",Date,AdmRowid))
			q:AdmRowid=""	
			
			s AdmType=$p(^PAADM(AdmRowid),"^",2)
			continue:((AdmType'="O")&(AdmType'="E")&(AdmType'="I"))  ;必须为门急诊病人
			s AdmStatus=$p(^PAADM(AdmRowid),"^",20)
			continue:AdmStatus="C" ;过滤退号患者
			
			s mradm=$p(^PAADM(AdmRowid),"^",61)
			continue:mradm=""
			Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
			d obj.Execute(mradm)
			while (obj.Next())
			{
				s ICDDesc=obj.Data("MRDIAICDCodeDRDesc")
				s Rowid=obj.Data("ID")
				s Note=obj.Data("MRDIADesc")
				if Note'="" s Note=$LIST(Note,1) //备注
				s Note=$replace(Note,"\","")
				s desc=""
				s:ICDDesc'="" desc=ICDDesc
				if (Note'=""){if (desc=""){s desc=Note}else{s desc=desc_"("_Note_")"}} 
				s NoteDr=""
				s NoteDesc = "NULL"
				s NoteDr=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
				b:NoteDr'="" NoteDesc = $P($G(^DHCDIAGNOTE(NoteDr)),"^",1)
				continue:desc=""
				s desc=$REPLACE(desc,",","，")
				s NoteDesc = $REPLACE(NoteDesc,",","，")
				if $D(arr(desc,NoteDesc))
				{
					s arr(desc,NoteDesc)=arr(desc,NoteDesc)+1
				}
				else
				{
					s arr(desc,NoteDesc)=0
				}	
			}
			
		 }  		
	}
	s desc=""
	f
	{
		 s desc = $O(arr(desc)) q:desc=""
		 s NoteDesc=""
		 f
		 {
			s NoteDesc=$O(arr(desc,NoteDesc)) q:NoteDesc=""
			continue:NoteDesc="NULL"
			d File.Write(desc_","_NoteDesc_","_arr(desc,NoteDesc))
			d File.WriteLine() 
			;w desc,",",NoteDesc,",",arr(desc,NoteDesc),!		 
		 }
	}
}

/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICD()
ClassMethod ImportICD()
{
	TS
	d ..ImportICDData1()
	d ..ImportICDData2()	
	d ..ImportICDData3()	
	d ..ImportICDData4()	
	d ..ImportICDData5()	
	d ..ImportICDData6()	
	d ..ImportICDData7()
	d ..ImportICDData8()
}

/// 北京临床\ICD-9手术操作分类临床版
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData1()
ClassMethod ImportICDData1()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 北京临床-ICD9手术分类临床版",0))
	s file=##class(%File).%New("E:\ICD\北京临床\ICD-9手术操作分类临床版.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s Code = $zstrip($P(str,",",1),"<>W")
		s Desc = $zstrip($P(str,",",2),"<>W")
		s Operate = $zstrip($P(str,",",3),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s CodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," ICD9编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Code
		d obj.MKBTPDProDRSetObjectId(CodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OpeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 类别",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Operate
		d obj.MKBTPDProDRSetObjectId(OpeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		 
	}
	w linenum
}

/// 北京临床\ICD-10 v6.01版
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData2()
ClassMethod ImportICDData2()
{
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 北京临床-ICD10V6.01",0))
	s file=##class(%File).%New("E:\ICD\北京临床\ICD-10 v6.01版.csv")
	d file.Open("RS")
	s linenum=0
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s Code = $zstrip($P(str,",",1),"<>W")
		s Desc = $zstrip($P(str,",",2),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s CodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," ICD编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Code
		d obj.MKBTPDProDRSetObjectId(CodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)

		 
	}
	w linenum
}

/// 北京临床\国家版icd-9字典库2011
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData3()
ClassMethod ImportICDData3()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 国家标准版-ICD9字典库2011",0))
	s file=##class(%File).%New("E:\ICD\国家标准版\国家版icd-9字典库2011.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s Code = $zstrip($P(str,",",1),"<>W")
		s Desc = $zstrip($P(str,",",2),"<>W")
		s Operate = $zstrip($P(str,",",3),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s CodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," ICD9编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Code
		d obj.MKBTPDProDRSetObjectId(CodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OpeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 类别",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Operate
		d obj.MKBTPDProDRSetObjectId(OpeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		 
	}
	w linenum
}

/// 国家标准版\疾病分类与ICD代码(2015国家修订版)
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData4()
ClassMethod ImportICDData4()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 国家标准版-疾病分类与ICD代码",0))
	s file=##class(%File).%New("E:\ICD\国家标准版\疾病分类与ICD代码(2015国家修订版).csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s Code = $zstrip($P(str,",",1),"<>W")
		s Desc = $zstrip($P(str,",",2),"<>W")
		s PYCode = $zstrip($P(str,",",3),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = $ZCONVERT(PYCode,"U")
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s CodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," ICD编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Code
		d obj.MKBTPDProDRSetObjectId(CodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
	 
	}
	w linenum
}

/// 国家临床1.1\疾病分类与代码国家临床版1.1
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData5()
ClassMethod ImportICDData5()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 国家临床1.1-疾病分类与代码",0))
	s file=##class(%File).%New("E:\ICD\国家临床1.1\疾病分类与代码国家临床版1.1.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s MainCode = $zstrip($P(str,",",1),"<>W")
		s OtherCode = $zstrip($P(str,",",2),"<>W")
		s Desc = $zstrip($P(str,",",3),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s CodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 主要编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=MainCode
		d obj.MKBTPDProDRSetObjectId(CodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OpeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 附加编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=OtherCode
		d obj.MKBTPDProDRSetObjectId(OpeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		 
	}
	w linenum
}

/// 国家临床1.1\手术操作分类代码国家临床版
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData6()
ClassMethod ImportICDData6()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 国家临床1.1-手术操作分类代码",0))
	s file=##class(%File).%New("E:\ICD\国家临床1.1\手术操作分类代码国家临床版1.1.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s MainCode = $zstrip($P(str,",",1),"<>W")
		s OtherCode = $zstrip($P(str,",",2),"<>W")
		s Desc = $zstrip($P(str,",",3),"<>W")
		s Operate = $zstrip($P(str,",",4),"<>W")
		s Option = $zstrip($P(str,",",5),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s MainCodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 主要编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=MainCode
		d obj.MKBTPDProDRSetObjectId(MainCodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OtherCodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 附加编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=OtherCode
		d obj.MKBTPDProDRSetObjectId(OtherCodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OperateTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 类别",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Operate
		d obj.MKBTPDProDRSetObjectId(OperateTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		 
		s OptionTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 录入选项",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Option
		d obj.MKBTPDProDRSetObjectId(OptionTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
	}
	w linenum
}

/// 国家临床2.0\疾病分类与代码国家临床版2.0
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData7()
ClassMethod ImportICDData7()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 国家临床2.0-疾病分类与代码",0))
	s file=##class(%File).%New("E:\ICD\国家临床2.0\疾病分类与代码国家临床版2.0.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s MainCode = $zstrip($P(str,",",1),"<>W")
		s OtherCode = $zstrip($P(str,",",2),"<>W")
		s Desc = $zstrip($P(str,",",3),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s MainCodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 主要编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=MainCode
		d obj.MKBTPDProDRSetObjectId(MainCodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OtherCodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 附加编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=OtherCode
		d obj.MKBTPDProDRSetObjectId(OtherCodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		 
	}
	w linenum
}

/// 国家临床1.1\手术操作分类代码国家临床版
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportICDData6()
ClassMethod ImportICDData8()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 国家临床2.0-手术操作分类代码",0))
	s file=##class(%File).%New("E:\ICD\国家临床2.0\手术操作分类代码国家临床版2.0.csv")
	d file.Open("RS")
	s linenum=0
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		
		s str= file.ReadLine()
		q:str=""
		s linenum=linenum+1
		s MainCode = $zstrip($P(str,",",1),"<>W")
		s OtherCode = $zstrip($P(str,",",2),"<>W")
		s Desc = $zstrip($P(str,",",3),"<>W")
		s Operate = $zstrip($P(str,",",4),"<>W")
		s Option = $zstrip($P(str,",",5),"<>W")
		s eobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s eobj.MKBTBaseDR = MKBTBRowId
		s eobj.MKBTCode=""
		s eobj.MKBTDesc=Desc
		s eobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(Desc)
		s eobj.MKBTSequence=""
		s result=..SaveData(eobj)
		b:result["false"
		s TermId=$E($P(result,"id:",2),2,*-2)
		
		s MainCodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 主要编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=MainCode
		d obj.MKBTPDProDRSetObjectId(MainCodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OtherCodeTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 附加编码",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=OtherCode
		d obj.MKBTPDProDRSetObjectId(OtherCodeTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		
		s OperateTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 类别",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Operate
		d obj.MKBTPDProDRSetObjectId(OperateTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
		 
		s OptionTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 录入选项",0))
		s obj = ##class(User.MKBTermProDetail).%New()
		s obj.MKBTPDCode=""
		s obj.MKBTPDDesc=Option
		d obj.MKBTPDProDRSetObjectId(OptionTPRowId)
		s obj.MKBTPDSequence=1
		s sc=obj.%Save()
		b:$$$ERROR(sc)
	}
	w linenum
}

/// Creator：丁亚男
/// CreatDate: 2018-03-27
/// Description：保存修改内容
/// Table：User.MKBTerm
/// Input：web.Entity.MKB.MKBTerm 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.MKB.MKBTerm) As %String
{
	
	s result = ""
	if $IsObject(eobj)
	{
		
		if (eobj.MKBTCode="")
		{
			//如果代码为空，按照编码规则生成代码
			s eobj.MKBTCode=##class(web.DHCBL.MKB.MKBTerm).GetMultiTermCode(eobj.MKBTBaseDR)
			q:eobj.MKBTCode="" "{success:'false',errorinfo:'代码不能为空！'}"
			
		}
		if (eobj.MKBTDesc="")
		{
			q "{success:'false',errorinfo:'中心词不能为空！'}"
		}
		s MKBTBType=$LISTGET($G(^User.MKBTermBaseD(eobj.MKBTBaseDR)),4)  //术语库注册-类型（树形、或者列表型）
		if (MKBTBType="L")
		{
			s flag=##class(web.DHCBL.MKB.MKBTerm).FormValidate(eobj.MKBTRowId,eobj.MKBTDesc,eobj.MKBTCode,eobj.MKBTBaseDR)  //调用重复验证
			s flag=0
		}
		else
		{
			s flag=##class(web.DHCBL.MKB.MKBTerm).FormValidateTree(eobj.MKBTRowId,eobj.MKBTBaseDR,eobj.MKBTDesc,eobj.MKBTLastLevel)  //调用重复验证	
		}
		
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在'}"
		}
		else
		{
			if (eobj.MKBTRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.MKBTerm).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.MKBTerm).%OpenId(eobj.MKBTRowId)
				s bobj = ##class(web.Entity.MKB.MKBTerm).%New()
				s bobj.MKBTRowId = eobj.MKBTRowId
				s bobj.MKBTCode = obj.MKBTCode
				s bobj.MKBTDesc = obj.MKBTDesc
				s:obj.MKBTBaseDR'="" bobj.MKBTBaseDR = obj.MKBTBaseDR.%Id()
				s bobj.MKBTPYCode=  obj.MKBTPYCode
				s bobj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(obj.MKBTNote)
				s bobj.MKBTSequence=  obj.MKBTSequence
				s:obj.MKBTLastLevel'="" bobj.MKBTLastLevel =obj.MKBTLastLevel.%Id()
				//如果是修改数据,则先删除索引表的数据
				//d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteTermIndex(eobj.MKBTRowId,"T")
			}
	
			s obj.MKBTCode = eobj.MKBTCode
			s obj.MKBTDesc = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(eobj.MKBTDesc)
			d:eobj.MKBTBaseDR'="" obj.MKBTBaseDRSetObjectId(eobj.MKBTBaseDR)
			d:eobj.MKBTBaseDR="" obj.MKBTBaseDRSetObjectId("")
			s MKBTBDesc=""
			s:eobj.MKBTBaseDR'="" MKBTBDesc=$LISTGET($G(^User.MKBTermBaseD(eobj.MKBTBaseDR)),3)
			
			if (eobj.MKBTPYCode="")&(eobj.MKBTDesc'="")
			{
				s eobj.MKBTPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(eobj.MKBTDesc,"U"))
			}
			s obj.MKBTPYCode = eobj.MKBTPYCode
			s obj.MKBTNote = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(eobj.MKBTNote)
			s:eobj.MKBTSequence'="" obj.MKBTSequence=  eobj.MKBTSequence
			if (obj.MKBTSequence="")&(eobj.MKBTBaseDR'="")
			{
				s obj.MKBTSequence=##class(web.DHCBL.MKB.MKBTerm).GetLastSequence(eobj.MKBTBaseDR)
			}
			d:eobj.MKBTLastLevel'="" obj.MKBTLastLevelSetObjectId(eobj.MKBTLastLevel)
			d:eobj.MKBTLastLevel="" obj.MKBTLastLevelSetObjectId("")
			
			Ts
			s sc=obj.%Save()
			
			d obj.%Close()
			s id =""
			If $$$ISOK(sc){
				s id = obj.%Id()
				if (eobj.MKBTRowId="")  //如果是新增则保存公有属性
				{
					//取注册术语扩展(公有)属性表User.MKBTermBaseProperty的数据保存到User.MKBTermProperty表
					s sce=##class(web.DHCBL.MKB.MKBTerm).SaveBaseExtToTerm(eobj.MKBTBaseDR,id)
					if (sce["false"){
						s result=sce	
					}

				}
			}else{
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
			}
			
			if (result["false")
			{
				Trollback
				s result = "{success:'false',errorinfo:'保存失败'}"   //返回错误信息
			}
			else
			{
				TC
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				
				//保存日志
		 		d:eobj.MKBTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Term","User.MKBTerm"_eobj.MKBTBaseDR,MKBTBDesc,id,eobj.MKBTDesc,"A",eobj)
				d:eobj.MKBTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MKB_Term","User.MKBTerm"_eobj.MKBTBaseDR,MKBTBDesc,eobj.MKBTRowId,eobj.MKBTDesc,"U",eobj,bobj)
		 		
		 		//d ##class(web.DHCBL.MKB.MKBTermProDetail).AddTermIndex(id,"T")
		 		d eobj.%Close()
			}
		}	
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	
	q result
}

/// 导出其他描述不为空
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ExportDiagsWithNotEmptyPro()
ClassMethod ExportDiagsWithNotEmptyPro()
{
	s ResultFile=##class(%File).%New("D:\其他文本描述子节点.csv") //新建
	d ResultFile.Open("NWS")
	
	d ResultFile.Write("诊断")
	d ResultFile.WriteLine() 
	
	s num=0
	s Count=""
	for
	{
		s Count=$O(^User.MKBTermI("DCountIndex",5,Count),-1)
		q:Count=""
		
		s MKBTRowId=0
		for
		{
			s MKBTRowId=$O(^User.MKBTermI("DCountIndex",5,Count,MKBTRowId))
			q:MKBTRowId=""
			
			s num=num+1
			s MKBTPRowId=$O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 其他描述",0))
			continue:MKBTPRowId=""
			
			s MKBTPDRowId=0
			for
			{
				s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
				q:MKBTPDRowId=""
				
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
				if (MKBTPDDesc="其他文本描述")
				{
					
					if ($D(^User.MKBTermProDetailI("ProParIndex",MKBTPRowId,MKBTPDRowId)))
					{
						
						s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
						d ResultFile.Write(MKBTDesc)
						d ResultFile.WriteLine() 	
					}	
				}	
			}
		}		
	}
	d ResultFile.Close()
}

/// 批量最优
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealMostPre()
ClassMethod DealMostPre()
{
	TS
	s num=0
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",0))
		continue:MKBSDDRowId=""
		
		s MKBSDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		s TermId=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDDRowId)),4)
		s ResultId=	$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDDRowId)),2)
		s Desc = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(ResultId,TermId)
		
		if (MKBSDDesc=Desc)
		{
			s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			s obj.MKBSDInitialICD="Y"
			s sc = obj.%Save()
			b:$$$ERROR(sc)
			s num=num+1
		}
	}
	w num
}

/// 处理子表表达式
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealResult()
ClassMethod DealResult()
{
	TS
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDRRowId=0
		for
		{
			s MKBSDRRowId=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRRowId))
			q:MKBSDRRowId=""
			
			s Exps=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRRowId)),2)	
			if ((Exps'="")&&(Exps'["-")&&(Exps'["TS"))
			{
				s obj = ##class(User.MKBStructuredDataResult).%OpenId(MKBSDRowId_"||"_MKBSDRRowId)
				s obj.MKBSDStructResultID=##class(web.DHCBL.MKB.MKBICDRely).SortExp(Exps)
				s sc = obj.%Save()	
				b:$$$ERROR(sc)
			}
		}	
	}
}

/// 规则管理-安贞科室对照---->科室对照
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).LocConMigrate()
ClassMethod LocConMigrate()
{
	
	;k ^User.MKBLocContrastD
	;k ^User.MKBLocContrastI
	s fresult=""
	s result=""
	s MKBKLMBRowId=$o(^User.MKBKLMappingBaseI("IdenIndex"," LL",0))
	q:MKBKLMBRowId="" "{success:'false',errorinfo:'请配置科室对照!'}"
	;s MKBKLMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 医大一科室对照",0))
	s ProMFChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 专业科室",0))
	s RealMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBKLMBRowId," 实际科室",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
		q:RowNum=""
		s str=""
		s ProMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_ProMFChild,0))
		s RealMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_RealMFChild,0))
		
		s ProTermId=$LG($G(^User.MKBKLMappingDetailD(ProMDRowId)),2)
		s RealTermId=$LG($G(^User.MKBKLMappingDetailD(RealMDRowId)),2)
		
		s RealLocDesc = $LG($G(^User.MKBTermD(RealTermId)),3)
		s CTLocID = $O(^CTLOC(0,"Desc",$ZCONVERT(RealLocDesc,"U"),0))
		if CTLocID=""
		{
			;w RealLocDesc,!
			continue
		}
		s flag=""
		s flag=##class(web.DHCBL.MKB.MKBLocContrast).JustData(ProTermId_"^"_CTLocID)
		if flag="Y"
		{
			s ProTermDesc=$lg($g(^User.MKBTermD(ProTermId)),3)
			s CTLocDesc=$p(^CTLOC(CTLocID),"^",2)
			s str = ProTermDesc_":"_CTLocDesc_"数据重复导入! "
			s:fresult'="" fresult=fresult_"&"_str
			s:fresult="" fresult=str
			continue
		}
		TS
		s obj=##class(User.MKBLocContrast).%New()
		d obj.MKBCTLocDrSetObjectId(CTLocID)
		d obj.MKBLocDrSetObjectId(ProTermId)
		s sc= obj.%Save()
		if $$$ERROR(sc)
		{
			Tro
			s str = ##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s:fresult'="" fresult=fresult_"&"_str
			s:fresult="" fresult=str
		}
		else
		{
			Tc
			s id=obj.%Id()
			set result = "{success:'true',id:'"_id_"'}"
		}
	}
	if fresult'=""
	{
		s result="{success:'false',errorinfo:'保存失败!"_fresult_"'}"
	}
	q result
}

/// d ##class(web.DHCBL.MKB.MKBDataProcessing).GetLocContrast()
ClassMethod GetLocContrast()
{
	s ResultFile=##class(%File).%New("E:\科室对照结果.csv") //新建
	d ResultFile.Open("NWS")
	
	d ResultFile.Write("实际科室,专科科室")
	d ResultFile.WriteLine() 
	
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 医疗_科室_安贞",0))
	s MKBMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	s MKBMFChild=$O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 专业科室",0))
	s num=0
	s LocDesc=""
	for
	{
		s LocDesc =$O(^User.MKBStructuredDataLocI("LocIndex",LocDesc))
		q:LocDesc=""
		

		s LocId=$O(^User.MKBTermI("DescIndex",MKBTBRowId,$ZCONVERT(LocDesc,"U"),0))
		b:LocId=""
		s num=num+1
		
		if ($D(^User.MKBReferenceI("InverAllIndex","T",LocId)))=0
		{
			w 1
			d ResultFile.Write(LocDesc_",无")
			d ResultFile.WriteLine()		
		}
		else
		{
			s MDRowId=0
			for
			{
				s MDRowId=$O(^User.MKBReferenceI("InverAllIndex","T",LocId,"MD",MDRowId))
				q:MDRowId=""
				
				if $D(^User.MKBKLMappingDetailI("BaseIndex",MKBMBRowId,MDRowId))=0
				{
					w 2
					d ResultFile.Write(LocDesc_",无")
					d ResultFile.WriteLine()	
				}
				else
				{
					s MDRowNum=$LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)	
					s MKBMDRowIdZ = $O(^User.MKBKLMappingDetailI("ValIndex",MDRowNum,MKBMBRowId_"||"_MKBMFChild,0))
					b:MKBMDRowIdZ=""
					
					s LocZDesc = $LG($G(^User.MKBTermD($LG($G(^User.MKBKLMappingDetailD(MKBMDRowIdZ)),2))),3)
					d ResultFile.Write(LocDesc_","_LocZDesc)
					d ResultFile.WriteLine()
				}
			}		
		}
		
	}
	w num
	d ResultFile.Close()
}

/// 数据处理工厂中语料库来源数据删除
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DataSturctDeal()
ClassMethod DataSturctDeal()
{
	TS
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDDiaSource=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),10)
		if (MKBSDDiaSource="语料库")
		{
			s MKBSDRChild=0
			for
			{
				s MKBSDRChild=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDRChild))
				q:MKBSDRChild=""
				
				s result = ##class(web.DHCBL.MKB.MKBStructuredData).DeleteData(MKBSDRowId_"||"_MKBSDRChild)	
				b:result["error"			
			}
			s sc = ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId)
			b:$$$ERROR(sc)
						
		}
		elseif (MKBSDDiaSource["&语料库")
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			s obj.MKBSDDiaSource = $REPLACE(MKBSDDiaSource,"&语料库","")
			s obj.MKBSDMRCDr=""
			s obj.MKBSDAlias=""
			d obj.%Save()	
		}
		else
		{
			s obj=##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
			s obj.MKBSDMRCDr=""
			d obj.%Save()	
		}		
	}
}

/// 数据处理工厂数据->全局诊断词表
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportDataFormSDToTerm()
ClassMethod ImportDataFormSDToTerm()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 全局化诊断词表",0))
	s seq=1
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBTEObj = ##class(web.Entity.MKB.MKBTerm).%New()
		s MKBTEObj.MKBTBaseDR = MKBTBRowId
		s MKBTEObj.MKBTCode=""
		s MKBTEObj.MKBTDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		s MKBTEObj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTEObj.MKBTDesc)
		s MKBTEObj.MKBTSequence = seq
		s terms = ##class(web.DHCBL.MKB.MKBTerm).SaveData(MKBTEObj)
		s TermId=$E($P(terms,"id:",2),2,$L($P(terms,"id:",2))-2)
		
		s MKBTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 别名",0)) b:MKBTPRowId=""
		
		s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPDEObj.MKBTPDDesc = MKBTEObj.MKBTDesc
		s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
		s MKBTPDEObj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDEObj.MKBTPDDesc)
		s MKBTPDEObj.MKBTPDSequence = 1
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
		
		s Alias=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),12)
		if (Alias'="")
		{
			s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s MKBTPDEObj.MKBTPDDesc = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),12)
			s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
			s MKBTPDEObj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBTPDEObj.MKBTPDDesc)
			s MKBTPDEObj.MKBTPDSequence = 2
			d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)	
		}
		
		///科室频次
		s MKBTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 科室频次",0)) b:MKBTPRowId=""
		s fresum=0
		s lseq=1
		s LocChild=0
		for
		{
			s LocChild=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",LocChild))
			q:LocChild=""
			
			s loc=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",LocChild)),2)	
			s fre=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructLoc",LocChild)),3)
			
			s FreqChild = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 频次",0))
			s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s MKBTPDEObj.MKBTPDDesc = loc
			s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
			s MKBTPDEObj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(loc)
			s MKBTPDEObj.MKBTPDExtend=FreqChild_"[A]"_fre
			s MKBTPDEObj.MKBTPDSequence = lseq
			d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
			
			s lseq=lseq+1
			s fresum=fresum+fre
		}
		///频次
		s MKBTPRowId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 频次",0)) b:MKBTPRowId=""
		s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPDEObj.MKBTPDDesc = fresum
		s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
		s MKBTPDEObj.MKBTPDSequence = 1
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
		
		s MKBSDMRCDr = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),11)
		if (MKBSDMRCDr'="")
		{
			s MKBDesc = $P($G(^MRC("ID",MKBSDMRCDr)),"^",2)
			s MKBICD = $P($G(^MRC("ID",MKBSDMRCDr)),"^",4)
			
			///ICD10中文名称
			s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," ICD10中文名称",0)) b:MKBTPRowId=""
			s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s MKBTPDEObj.MKBTPDDesc = MKBDesc
			s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
			s MKBTPDEObj.MKBTPDSequence = 1
			d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
			
			///ICD10编码
			s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," ICD10编码",0)) b:MKBTPRowId=""
			s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
			s MKBTPDEObj.MKBTPDDesc = MKBICD
			s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
			s MKBTPDEObj.MKBTPDSequence = 1
			d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)	
		}
		
		
		///数据来源
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 数据来源",0)) b:MKBTPRowId=""
		s MKBSDDiaSource=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),10)
		s sourceResult=""
		for i=1:1:$L(MKBSDDiaSource,"&")
		{
			s result=""
			if ($P(MKBSDDiaSource,"&",i)="出院")
			{
				s result="安贞2018年出院患者诊断"	
			}
			elseif ($P(MKBSDDiaSource,"&",i)="门急诊")
			{
				s result="安贞2018年门急诊患者诊断"
			}
			elseif ($P(MKBSDDiaSource,"&",i)="语料库")
			{
				s result="安贞医院语料处理完成表"	
			}
			s:sourceResult'="" sourceResult=sourceResult_","_result
			s:sourceResult="" sourceResult= result
		}
		s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPDEObj.MKBTPDDesc = sourceResult
		s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
		s MKBTPDEObj.MKBTPDSequence = 1
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
		
		
		///类型
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 类型",0)) b:MKBTPRowId=""
		s MKBSDDiaSource=$LG($G(^User.MKBStructuredDataD(MKBSDRowId)),10)
		s sourceResult=""
		for i=1:1:$L(MKBSDDiaSource,"&")
		{
			s:sourceResult'="" sourceResult=sourceResult_","_$P(MKBSDDiaSource,"&",i)
			s:sourceResult="" sourceResult= $P(MKBSDDiaSource,"&",i)
		}
		s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPDEObj.MKBTPDDesc = sourceResult
		s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
		s MKBTPDEObj.MKBTPDSequence = 1
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
		
		///	处理状态
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 处理状态",0)) b:MKBTPRowId=""
		s MKBSDStatus = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),5)
		s status=""
		s:MKBSDStatus="Y" status="已处理"
		s:MKBSDStatus="N" status="未处理"
		s:MKBSDStatus="G" status="放弃"
		s:MKBSDStatus="P" status="预处理"
		s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPDEObj.MKBTPDDesc = status
		s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
		s MKBTPDEObj.MKBTPDSequence = 1
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
		
		///结构化诊断表达式
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 结构化诊断表达式",0)) b:MKBTPRowId=""
		s TermDrChild = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 诊断DR",0))
		s IDsChild = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 结构化诊断ID串",0))
		
		s rseq=1
		s ResChild=0
		for
		{
			s ResChild=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",ResChild))
			q:ResChild=""	
			
			s MKBSDTermDR=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",ResChild)),4)
			if (MKBSDTermDR'="")
			{
				s MKBSDStructResultID=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",ResChild)),2)
				s MKBSDStructResult = ##class(web.DHCBL.MKB.MKBStructuredData).GetChiForStrucIDs(MKBSDStructResultID,MKBSDTermDR)		
				;b:MKBSDRowId=8
				s MKBTPDEObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
				s MKBTPDEObj.MKBTPDDesc = MKBSDStructResult
				s MKBTPDEObj.MKBTPDProDR = MKBTPRowId
				s MKBTPDEObj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDStructResult)
				s MKBTPDEObj.MKBTPDExtend=TermDrChild_"[A]"_MKBSDTermDR_"[N]"_IDsChild_"[A]"_MKBSDStructResultID
				s MKBTPDEObj.MKBTPDSequence = rseq
				d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDEObj)
				s rseq=rseq+1
			}
		} 
	}
}

/// 重新整理诊断词表顺序
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).SortTerm()
ClassMethod SortTerm()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 全局化诊断词表",0))
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s FreqTPRowId=$O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 频次",0))
		s MKBTPDVal=$LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",FreqTPRowId,0)))),3)
		s fre(MKBTPDVal,MKBTRowId)=""
	}
	
	s seq=1
	s freq=""
	for
	{
		s freq=$O(fre(freq),-1)
		q:freq=""
		
		s MKBTRowId=0
		for
		{
			s MKBTRowId=$O(fre(freq,MKBTRowId))
			q:MKBTRowId=""
			
			s obj=##class(User.MKBTerm).%OpenId(MKBTRowId)
			s obj.MKBTSequence=seq
			d obj.%Save()
			s seq=seq+1	
		}	
	}
}

/// 数据处理工厂-Term
/// /d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportStructToTerm()
ClassMethod ImportStructToTerm()
{

	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 诊断词表",0))
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId = $O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		s Fres = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),4)
		s Locs = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),3)
		
		k locf
		s freq=0
		if Fres[","
		{
			for i=1:1:$L(Fres,",")
			{
				s locf($P(Locs,",",i),$P(Fres,",",i))=""
				s freq = freq+$P(Fres,",",i)	
			}
		}
		else
		{
			s locf(Locs,Fres)=""
			s freq = Fres	
		}
		
		s TEobj = ##class(web.Entity.MKB.MKBTerm).%New()
		s TEobj.MKBTDesc = MKBSDDiag
		s TEobj.MKBTBaseDR = MKBTBRowId
		s TEobj.MKBTPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(MKBSDDiag)
		s result=##class(web.DHCBL.MKB.MKBTerm).SaveData(TEobj)
		
		if result'["false"
		{
			s id = $e($P(result,"id:",2),2,$L($P(result,"id:",2))-2)
			s FreqTPRowId=$O(^User.MKBTermPropertyI("DescIndex",id," 频次",0))
			b:FreqTPRowId=""
			s MKBTPDObj=##class(web.Entity.MKB.MKBTermProDetail).%New()
			s MKBTPDObj.MKBTPDDesc = freq
			s MKBTPDObj.MKBTPDProDR = FreqTPRowId
			s MKBTPDObj.MKBTPDSequence=""
			s Dresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDObj)
			b:Dresult["false"
			
			s LocFTPRowId=$O(^User.MKBTermPropertyI("DescIndex",id," 科室频次",0))
			
			b:LocFTPRowId=""
			s FreqChild = $O(^User.MKBTermExtendProI("NameIndex",LocFTPRowId," 频次",0))
			s loc=0
			for
			{
				s loc=$O(locf(loc))
				q:loc=""
				
				s freq=$O(locf(loc,0))
				b:freq=""
				s MKBTPDObj=##class(web.Entity.MKB.MKBTermProDetail).%New()
				s MKBTPDObj.MKBTPDDesc = loc
				s MKBTPDObj.MKBTPDProDR = LocFTPRowId
				s MKBTPDObj.MKBTPDSequence=""
				s MKBTPDObj.MKBTPDExtend=FreqChild_"[A]"_freq
				s Dresult=##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDObj)
				b:Dresult["false"
				
			}
			
		}
		else
		{
			b ;error	
		}
	
	}
}

/// 谷雪萍 2019-10-10
/// 遍历知识库数据删掉冗余数据
/// d ##class(web.DHCBL.BDP.ClassIOGuXueping).DealUnExistData()
/// d ##class(web.DHCBL.MKB.MKBReference).RegenerateAll()  //重新生成索引
ClassMethod DealUnExistData()
{
	s deleteTermId=""
	w "删除的术语ID如下：",!
	//术语
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermD(MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTBaseDR = $LG($G(^User.MKBTermD(MKBTRowId)),4)
		///BaseDr不存在，删除所有后删除自身
		if (MKBTBaseDR="")||($D(^User.MKBTermBaseD(MKBTBaseDR))=0)
		{				
			d ##class(User.MKBTerm).%DeleteId(MKBTRowId) 	
			w MKBTRowId_"^"
		}
	}
	
	w !,"删除的属性ID如下：",!
	s deleteProId=""
	//属性
	s MKBTPRowId=0
	for
	{
		s MKBTPRowId=$O(^User.MKBTermPropertyD(MKBTPRowId))
		q:MKBTPRowId=""

		s MKBTPTermDr = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),6)
		///TermDr为空，删除所有内容后删除自身
		if (MKBTPTermDr="")||($D(^User.MKBTermD(MKBTPTermDr))=0)
		{
			d ##class(User.MKBTermProperty).%DeleteId(MKBTPRowId)
			w MKBTPRowId_"^"
		}
	}
	w !,"删除的属性内容的ID如下：",!
	
	s deleteProDetailId=""
	///属性内容
	s MKBTPDRowId=0
	for
	{
		s MKBTPDRowId=$O(^User.MKBTermProDetailD(MKBTPDRowId))
		q:MKBTPDRowId=""
		
		s MKBTPDProDR = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),6)
		///属性Dr为空
		if (MKBTPDProDR="")||($D(^User.MKBTermPropertyD(MKBTPDProDR))=0)
		{
			d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)
			w MKBTPDRowId_"^"
		}
	}
	
	w !,"删除的扩展属性值的ID如下：",!
	///扩展属性内容
	s MKBTEPVRowId=0
	for
	{
		s MKBTEPVRowId=$O(^User.MKBTermExtendProValD(MKBTEPVRowId))
		q:MKBTEPVRowId=""
		
		s MKBTEPVDetailDr = $LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),2)
		s MKBTEPVExtendDr = $LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),3)
		s MKBTEPVValue = $LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)
		///属性Dr为空
		if (MKBTEPVDetailDr="")||($D(^User.MKBTermProDetailD(MKBTEPVDetailDr))=0)||(MKBTEPVExtendDr="")||(MKBTEPVValue="")
		{
			d ##class(User.MKBTermExtendProVal).%DeleteId(MKBTEPVRowId)
			w MKBTEPVRowId_"^"	
		}
	}
	
	w !,"删除的规则管理的数据如下：",!
	s MKBTPDRowId=0
	for
	{
		s MKBTPDRowId=$O(^User.MKBKLMappingDetailD(MKBTPDRowId))
		q:MKBTPDRowId=""
		
		s MKBKMDValue=$LG($G(^User.MKBKLMappingDetailD(MKBTPDRowId)),2)
		s MKBKMDKMBaseFieldDr=$LG($G(^User.MKBKLMappingDetailD(MKBTPDRowId)),3)
		s MKBKMDKMBaseDr = $LG($G(^User.MKBKLMappingDetailD(MKBTPDRowId)),5)
		///属性Dr为空
		if (MKBKMDKMBaseDr="")||($D(^User.MKBKLMappingBaseD(MKBKMDKMBaseDr))=0)||(MKBKMDKMBaseFieldDr="")||(MKBKMDValue="")
		{
			d ##class(User.MKBKLMappingDetail).%DeleteId(MKBTPDRowId)
			w MKBTPDRowId_"^"	
		}
	}
	
	q 1
}

/// 根据传入HIS科室查找诊断
ClassMethod GetTermsByLoc(HISLocId)
{
	s result=""
	s resultDesc = ""
	s MKBKLMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室常用诊断",0))
	s Loc=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 科室",0))
	s Diag=$o(^User.MKBKLMappingBaseFieldI("DescIndex",MKBLocDiagBase," 诊断",0))

	if (HISLocId'="")
	{
		s MKBLoc = 0
		for
		{
			s MKBLoc = $O(^User.MKBLocContrastI("LocIndex",HISLocId,MKBLoc))
			q:MKBLoc=""
			
			s MDRowId=0
			for
			{
				s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",MKBLoc,"MD",MDRowId))
				q:MDRowId=""
				
				continue:$D(^User.MKBKLMappingDetailI("BaseIndex",MKBKLMBRowId,MDRowId))=0
				s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
				
				s DiagMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMBRowId_"||"_Diag,0))	//实际科室的MappingDetailRowId
				s DiagTermId = $LG($G(^User.MKBKLMappingDetailD(DiagMDRowId)),2)
				s Diag = $LG($G(^User.MKBTermD(DiagTermId)),3)
				
				s:result'="" result=result_"&%"_DiagTermId
				s:result="" result=DiagTermId
				
				s:resultDesc'="" resultDesc=resultDesc_"&%"_Diag
				s:resultDesc="" resultDesc=Diag
			}
				
		}	
	}	
	b
}

/// 处理知识库代码字段
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealCode()
ClassMethod DealCode()
{
	TS
	///TB\TBP\TP RulesCode赋值
	s MKBTBRowId=0
	for
	{
		s MKBTBRowId=$O(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		
		s MKBTBDesc=$LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)
		
		s TBObj = ##class(User.MKBTermBase).%OpenId(MKBTBRowId)
		if (MKBTBDesc="临床实用诊断")
		{
			s TBObj.MKBTBCodeRules = "DIA"	
		}
		elseif (MKBTBDesc="主要部位")
		{
			s TBObj.MKBTBCodeRules = "PART"
		}
		elseif (MKBTBDesc="主要病因")
		{
			s TBObj.MKBTBCodeRules = "PATH"	
		}
		else
		{
			s TBObj.MKBTBCodeRules = $$ALPHAUP^SSUTIL4(##class(web.DHCBL.BDP.FunLib).GetPYCODE($LG($G(^User.MKBTermBaseD(MKBTBRowId)),3)))	
		}
		
		s scTB = TBObj.%Save()
		b:$$$ERROR(scTB)
		
		s MKBTBPRowId=0
		for
		{
			s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId))
			q:MKBTBPRowId=""
			
			s MKBTBPPYCode = $$ALPHAUP^SSUTIL4(##class(web.DHCBL.BDP.FunLib).GetPYCODE($LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3)))
			s TBPObj = ##class(User.MKBTermBaseProperty).%OpenId(MKBTBPRowId)
			s TBPObj.MKBTBPCodeRules = MKBTBPPYCode
			s scTBP = TBPObj.%Save()	
			b:$$$ERROR(scTBP)
		}
		s MKBTRowId = 0
		for
		{
			s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:MKBTRowId=""
			
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:MKBTPRowId=""
				
				s MKBTPPYCode = $$ALPHAUP^SSUTIL4(##class(web.DHCBL.BDP.FunLib).GetPYCODE($LG($G(^User.MKBTermPropertyD(MKBTPRowId)),3)))
				s TPObj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
				s TPObj.MKBTPCodeRules = MKBTPPYCode
				s scTP = TPObj.%Save()
				b:$$$ERROR(scTP)
				d TPObj.%Close()
			}		
		}
	}	
	w 1,!

	///术语系赋值
	s MKBTBRowId=0
	for
	{
		s MKBTBRowId = $O(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		s lee("TB",MKBTBRowId)=""

		s MKBTRowId=0
		for
		{
			s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))	
			q:MKBTRowId=""

			s MKBTBDesc=$LG($G(^User.MKBTermBaseD($LG($G(^User.MKBTermD(MKBTRowId)),4))),3)
			
			continue:MKBTBDesc="ICD11"
			continue:MKBTBDesc="安贞ICD"
			continue:MKBTBDesc="协和ICD"
			continue:MKBTBDesc="ICD10北京码"
			continue:MKBTBDesc="医学知识分级字典表"
			continue:MKBTBDesc="DRGs分组"
			continue:MKBTBDesc="江苏省中医院"
			
			s Rules = $LG($G(^User.MKBTermBaseD(MKBTBRowId)),12)
			s CodeNum = $i(lee("TB",MKBTBRowId))
			s len = $L(CodeNum)
			for i=1:1:6-len
			{
				s CodeNum="0"_CodeNum		
			}
			s Code = Rules_CodeNum	
			
			s TObj = ##class(User.MKBTerm).%OpenId(MKBTRowId)
			s TObj.MKBTCode = Code
			s scCodeT=TObj.%Save()
			b:$$$ERROR(scCodeT)
			d TObj.%Close()
			
			
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:MKBTPRowId=""

				s Rules=$LG($G(^User.MKBTermD(MKBTRowId)),2)
				s TPRules = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),12)
				s Code = Rules_"-"_TPRules
				s TPObj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
				b:TPObj=""
				s TPObj.MKBTPCode = Code
				s scCodeTP = TPObj.%Save()
				b:$$$ERROR(scCodeTP)
				d TPObj.%Close()
				s lee("TP",MKBTPRowId)=""
					
				s MKBTPDRowId=0
				for
				{
					s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
					q:MKBTPDRowId=""
					s ^ldya(4)=^ldya(4)+1
					s TPCode= $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),2)
					s CodeNum = $i(lee("TP",MKBTPRowId))	
					s len = $L(CodeNum)
					for i=1:1:5-len
					{
						s CodeNum="0"_CodeNum		
					}
					s Code = TPCode_"-"_CodeNum
					s TPDObj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
					s TPDObj.MKBTPDCode = Code
					s scCodeTPD = TPDObj.%Save()
					d TPDObj.%Close()
					b:$$$ERROR(scCodeTPD)
				}
			}
		}
	}
	tc
}

/// 弃用
ClassMethod GetLastCode(Flag, Id)
{
	if ((Flag'="")&&(Id'=""))
	{
		s Code=""
		if (Flag="T")
		{
			s Rules = $LG($G(^User.MKBTermBaseD(Id)),12)
			s Code = $O(^User.MKBTermI("CodeIndex",Id,""),-1)
			s Code = $REPLACE(Code,Rules,"")
			s Code=Code+1
			s len = $L(Code)
			for i=1:1:5-len
			{
				s Code="0"_Code		
			}
			s Code = Rules_Code
		}	
		q Code
	}
}

/// 处理安贞科室
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealLocData()
ClassMethod DealLocData()
{
	TS
	k ^User.MKBLocContrastD
	k ^User.MKBLocContrastI
	
	s MBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 安贞科室对照",0))
	s TermField = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 专业科室",0))
	s LocField = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 实际科室",0))
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MBRowId,RowNum))
		q:RowNum=""
		
		s TermDet = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MBRowId_"||"_TermField,0))
		s TermVal = $LG($G(^User.MKBKLMappingDetailD(TermDet)),2)
		s LocDet = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MBRowId_"||"_LocField,0))
		s LocVal = $LG($G(^User.MKBKLMappingDetailD(LocDet)),2)
		s LocDesc = $LG($G(^User.MKBTermD(LocVal)),3)
		b:$O(^CTLOC("0","Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))'=$O(^CTLOC("0","Desc",$$ALPHAUP^SSUTIL4(LocDesc),""),-1)
		s LocId = $O(^CTLOC("0","Desc",$$ALPHAUP^SSUTIL4(LocDesc),0))
		b:LocId=""
		
		s obj = ##class(User.MKBLocContrast).%New()
		d obj.MKBLocDrSetObjectId(TermVal)
		d obj.MKBCTLocDrSetObjectId(LocId)
		s sc = obj.%Save()
		b:$$$ERROR(sc)
			
	}
}

/// 科室对照诊断生成辅助索引
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).SaveRelyForLocTerm()
ClassMethod SaveRelyForLocTerm()
{
	TS
	s MBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))
	
	k mf
	s Child=0
	for
	{
		s Child = $O(^User.MKBKLMappingBaseD(MBRowId,"ChildField",Child))
		q:Child=""
		
		s MFType = $LG($G(^User.MKBKLMappingBaseD(MBRowId,"ChildField",Child)),4)
		s MFConfig = $LG($G(^User.MKBKLMappingBaseD(MBRowId,"ChildField",Child)),5)
		
		continue:((MFType'="K1")&&(MFType'="K2"))
		continue:MFConfig'="Desc"
		
		s mf(Child)=""		
	}	
	
	s RowNum = 0
	for
	{
		s RowNum = $O(^User.MKBKLMappingDetailI("RowNumIndex",MBRowId,RowNum))	
		q:RowNum=""
		
		s MFChild=0
		for
		{
			s MFChild=$O(mf(MFChild))
			q:MFChild=""
			
			s MFRowId=MBRowId_"||"_MFChild
			
			s MDRowId = 0
			for
			{
				s MDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MFRowId,MDRowId))
				q:MDRowId=""
				
				s val = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
				b:val=""
				d ##class(web.DHCBL.MKB.MKBMappingRely).SaveTerm(MBRowId,val,MDRowId)	
			}
		}
	}
	tc
}

/// lixin
/// 获取映射型属性内容
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).GetDetailForMPro(391364)
ClassMethod GetDetailForMPro(pro)
{
	s result=""
	if (pro'="")
	{
		k arr
		s config = $LG($G(^User.MKBTermPropertyD(pro)),5)
		s termid = $LG($G(^User.MKBTermPropertyD(pro)),6)
		
		s MFSearch=""
			
		s MDRowId=0
		for
		{
			s MDRowId = $O(^User.MKBMappingTermRelyI("TermIndex",config,termid,MDRowId))	
			q:MDRowId=""
			
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
			s:MFSearch="" MFSearch=$LG($G(^User.MKBKLMappingDetailD(MDRowId)),3)
			s arr(RowNum)=""
		}
		s MFSearchChild = $P(MFSearch,"||",2)
		s MFResultChild=""
		s Child=0
		for
		{
			s Child = $O(^User.MKBKLMappingBaseD(config,"ChildField",Child))
			q:Child=""
			
			if (Child'=MFSearchChild)
			{
				s MFType = $LG($G(^User.MKBKLMappingBaseD(config,"ChildField",Child)),4)	
				if ((MFType="K1")||(MFType="K2"))
				{
					s MFConfig = $LG($G(^User.MKBKLMappingBaseD(config,"ChildField",Child)),5)	
					if (MFConfig="Desc")
					{
						if (MFResultChild'="")
						{
							b	
						}
						s MFResultChild = Child	
					}
				}
			}	
		}
		
		s RowNum=0
		for	
		{
			s RowNum = $O(arr(RowNum))
			q:RowNum=""
			
			s MDRowId=0
			for
			{
				s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,config_"||"_MFResultChild,MDRowId))
				q:MDRowId=""
				
				s val = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
				s valDesc = ##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(val)	
				
				s:result'="" result=result_","_valDesc
				s:result="" result=valDesc
			}
		}
	}
	
	q result
}

/// lixin
/// 获取映射型属性内容
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).GetDetailForMPro(391364)
ClassMethod GetDetailForMPro2(pro)
{
	s result=""
	if (pro'="")
	{
		k arr
		s config = $LG($G(^User.MKBTermPropertyD(pro)),5)
		s termid = $LG($G(^User.MKBTermPropertyD(pro)),6)
		
		s MFSearch=""
			
		s MDRowId=0
		for
		{
			s MDRowId = $O(^User.MKBReferenceI("InverAllIndex","T",termid,"MD",MDRowId))	
			q:MDRowId=""
			continue:$D(^User.MKBKLMappingDetailI("BaseIndex",config,MDRowId))=0
			
			s RowNum = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),4)
			s:MFSearch="" MFSearch=$LG($G(^User.MKBKLMappingDetailD(MDRowId)),3)
			s arr(RowNum)=""
		}
		s MFSearchChild = $P(MFSearch,"||",2)
		s MFResultChild=""
		s Child=0
		for
		{
			s Child = $O(^User.MKBKLMappingBaseD(config,"ChildField",Child))
			q:Child=""
			
			if (Child'=MFSearchChild)
			{
				s MFType = $LG($G(^User.MKBKLMappingBaseD(config,"ChildField",Child)),4)	
				if ((MFType="K1")||(MFType="K2"))
				{
					s MFConfig = $LG($G(^User.MKBKLMappingBaseD(config,"ChildField",Child)),5)	
					if (MFConfig="Desc")
					{
						if (MFResultChild'="")
						{
							b	
						}
						s MFResultChild = Child	
					}
				}
			}	
		}
		
		s RowNum=0
		for	
		{
			s RowNum = $O(arr(RowNum))
			q:RowNum=""
			
			s MDRowId=0
			for
			{
				s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,config_"||"_MFResultChild,MDRowId))
				q:MDRowId=""
				
				s val = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
				s valDesc = ##class(web.DHCBL.MKB.MKBTerm).GetTreeComboDesc(val)	
				
				s:result'="" result=result_","_valDesc
				s:result="" result=valDesc
			}
		}
	}
	
	q result
}

/// 为科室对照诊断添加频次
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealFreq()
ClassMethod DealFreq()
{
	TS
	s MBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))
	s MFDiagChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 诊断",0))
	s MFFreqChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 频次",0))
	
	s Num=0
	for
	{
		s Num=$O(^User.MKBKLMappingDetailI("RowNumIndex",MBRowId,Num))
		q:Num=""
		
		s MDRowId=0
		for
		{
			s MDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",Num,MBRowId_"||"_MFDiagChild,MDRowId))
			q:MDRowId=""
			
			s val = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
			if ($D(^FlagCount(val))'=0)
			{
				s freq=$O(^FlagCount(val,""))
				s obj = ##class(User.MKBKLMappingDetail).%New()
				d obj.MKBKMDKMBaseDrSetObjectId(MBRowId)
				d obj.MKBKMDKMBaseFieldDrSetObjectId(MBRowId_"||"_MFFreqChild)
				s obj.MKBKMDRowNum = Num
				s obj.MKBKMDValue = freq
				s sc = obj.%Save()
				b:$$$ERROR(sc)
			}	
			elseif ($D(^XIEHEDiagFreq(val))'=0)
			{
				s freq=^XIEHEDiagFreq(val)	
				s obj = ##class(User.MKBKLMappingDetail).%New()
				d obj.MKBKMDKMBaseDrSetObjectId(MBRowId)
				d obj.MKBKMDKMBaseFieldDrSetObjectId(MBRowId_"||"_MFFreqChild)
				s obj.MKBKMDRowNum = Num
				s obj.MKBKMDValue = freq
				s sc = obj.%Save()
				b:$$$ERROR(sc)
			}
			else
			{
				b	
			}
		}	
	}
}

/// 处理带&%的表达式
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealExpWithAndPercent()
ClassMethod DealExpWithAndPercent()
{
	TS
	s SZMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 深圳版ICD对照"))
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		continue:MKBKLMBRowId=SZMBRowId
		
		s Child=0
		for
		{
			s Child=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child))	
			q:Child=""
			
			s MKBKLMFRowId=MKBKLMBRowId_"||"_Child
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child)),5)
			
			if ((MKBKMBFType="K1")||(MKBKMBFType="K2"))
			{
				if (MKBKMBFConfig="Exp")
				{
					s RowNum=0
					
					for
					{
						s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
						q:RowNum=""
						
						s MKBKLMDRowId=0
						for
						{
							s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMFRowId,MKBKLMDRowId))
							q:MKBKLMDRowId=""
							
							s val = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2) /// 表达式
							if (val["&%")
							{
								w val,"   "
								s val = $REPLACE(val,"&%",";&")
								w val,!
								s obj = ##class(User.MKBKLMappingDetail).%OpenId(MKBKLMDRowId)
								s obj.MKBKMDValue = val
								s sc = obj.%Save()
								b:$$$ERROR(sc)
							}
							
						}
					}
				}
			}
		}
	}
}

/// MKBExp->SDSExp子方法
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).GetSDSDetailExp("14737-3257:7581")
ClassMethod GetSDSDetailExp(Exp)
{
	s result=""
	if (Exp'["-") ///仅术语
	{
		if ($D(^User.MKBTermPropertyI("DescIndex",Exp," 诊断模板"))=0)
		{
			s result=""	
		}
		else
		{
			s result=$O(^User.MKBTermPropertyI("DescIndex",Exp," 诊断模板",0))
		}	
	}
	else
	{
		s TermId = $P(Exp,"-",1)	
		if ($D(^User.MKBTermPropertyI("DescIndex",TermId," 诊断模板"))=0) //不存在诊断模板属性
		{
			s result=""	
		}
		else //单属性多内容
		{
			s DMId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 诊断模板",0))
			s result=DMId
			
			s ProDet = $P(Exp,"-",2)
			S Pro = $P(ProDet,":",1)
			
			s DMDId = $O(^User.MKBTermProDetailI("ProIdx",DMId,0))
			s DMVal = $LG($G(^User.MKBTermProDetailD(DMDId)),3)
			s DMLen = $L(DMVal,",") ///诊断模板内容条数
			k dm ///存放诊断模板内内容
			for i=1:1:DMLen
			{
				s DMPro = $P($P(DMVal,",",i),"&",1) //诊断模板内选中的属性
				s DMType =$P($P(DMVal,",",i),"&",2)
				if ($L($P(DMVal,",",i),"&")=2)
				{
					s DMDefineDet = ""
				}
				else
				{
					s DMDefineDet = $P($P(DMVal,",",i),"&",3) //起始节点	
				}
				
				if (DMType="T")
				{
					s Childs=DMDefineDet					
					s SubChilds = ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(DMDefineDet,DMPro)
					if (SubChilds'="")
					{
						s:Childs'="" Childs=Childs_"^"_SubChilds				
						s:Childs="" Childs=SubChilds
					}					
	
					if (Childs'="")
					{
						s clen = $L(Childs,"^")
						for ci=1:1:clen
						{
							
							if (DMDefineDet="")
							{
								s dm(DMPro,$P(Childs,"^",ci),"N")=""
							}
							else
							{
								s dm(DMPro,$P(Childs,"^",ci),DMDefineDet)=""	
							}		
						}		
					}	
				}
			}
			///获取诊断模板end	
			if ($D(dm(Pro))'=0) ///表达式所选属性存在于诊断模板
			{
				s Dets=$P(ProDet,":",2)
				k tdet ///存储表达式已选的属性内容
				for k=1:1:$L(Dets,"*")
				{
					s tdet($P(Dets,"*",k))=""
				}
				s Det = 0
				s Dets="" //
				for
				{
					s Det = $O(tdet(Det))
					q:Det=""
					
					if ($D(dm(Pro,Det))'=0)
					{
						s:Dets'="" Dets=Dets_"&"_Det
						s:Dets="" Dets=Det	
					}
				}
				if (Dets'="") //所选属性you在诊断模板内
				{
					s result=result_"&%"
					s resultId=""
					
					s Det=0
					s DetDescs=""
					k DMDefine
					for Di=1:1:$L(Dets,"&")
					{
						s Det = $P(Dets,"&",Di)
						
						if ($O(dm(Pro,Det,0))'="N") ///存在起始节点
						{
							s DefineNode=$O(dm(Pro,Det,0))
							b:DefineNode=""
							s DMDefine(DefineNode,Det)="" 
						}
						else ///不存在起始节点
						{
							s DMDefineNo(Pro,Det)=""
						}
					}
					if ($D(DMDefine)'=0)
					{
						s DefineNode=0 //遍历存在初始节点
						for
						{
							s DefineNode = $O(DMDefine(DefineNode))
							q:DefineNode=""
							
							s:resultId'="" resultId=resultId_"^D"_DefineNode_"T:"
							s:resultId="" resultId="D"_DefineNode_"T:"
							
							s Dets=""
							s Det=0
							for
							{
								s Det=$O(DMDefine(DefineNode,Det))
								q:Det=""
								
								s:Dets'="" Dets=Dets_"&"_Det
								s:Dets="" Dets=Det	
							}
							s resultId=resultId_Dets
						}	
					}
					if ($D(DMDefineNo)'=0)
					{
						s Pro=$O(DMDefineNo(""))
						b:Pro="" 
						
						s:resultId'="" resultId=resultId_Pro_"T:"
						s:resultId="" resultId=Pro_"T:"
						
						s Dets=""
						s Det=0
						for
						{
							s Det=$O(DMDefineNo(Pro,Det))
							q:Det=""
							
							s:Dets'="" Dets=Dets_"&"_Det 
							s:Dets="" Dets=Det	
						}	
						s resultId=resultId_Dets
					}
					s result=result_resultId	
				}
				else
				{
					s ^lee("unExistDetInDM",Exp)=""
					s ^lee("unExistDetInDM")=^lee("unExistDetInDM")+1	
				}
			}
			else
			{
				s ^lee("unExistProInDM",Exp)="" 
				s ^lee("unExistProInDM")=^lee("unExistProInDM")+1
			}
		}	
	}	
	q result
}

/// MKBExp->SDSExp
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).Trans()
ClassMethod Trans(Exp)
{

	s result=""
	q:Exp="" ""
	if (Exp'[";&") ///单条诊断
	{
		s result = ..GetSDSDetailExp(Exp)
	}
	else //多条诊断符合
	{
		for Ei=1:1:$L(Exp,";&")
		{
			s subresult=""
			s subExp=$P(Exp,";&",Ei)	
			s subresult=..GetSDSDetailExp(subExp)
			
			s:result'="" result=result_"&&"_subresult
			s:result="" result=subresult	
		}	
	}
	q result
}

/// Lixin
/// 原表达式转SDS表达式
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).TransExpToSDSExp()
ClassMethod TransExpToSDSExp()
{
	k ^lee
	s ^lee("unExistDetInDM")=0
	s ^lee("unExistProInDM")=0
	s i=0
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		
		s Child=0
		for
		{
			s Child=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child))	
			q:Child=""
			
			s MKBKLMFRowId=MKBKLMBRowId_"||"_Child
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child)),5)
			
			if ((MKBKMBFType="K1")||(MKBKMBFType="K2"))
			{
				if (MKBKMBFConfig="Exp")
				{
					s RowNum=0
					
					for
					{
						s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
						q:RowNum=""
						
						s MKBKLMDRowId=0
						for
						{
							s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMFRowId,MKBKLMDRowId))
							q:MKBKLMDRowId=""
							
							s val = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2) /// 表达式
							s Tval = ..Trans(val)
							if (val["-")
							{
								s i = i+1
								;w val,"|||||",..Trans(val),!	
							}
							if (Tval["T")
							{
								w Tval,!	
							}
							
						}
					}
				}
			}
		}
	}
	w i
}

/// d ##class(web.DHCBL.MKB.MKBDataProcessing).CheckProNotInDm()
ClassMethod CheckProNotInDm()
{
	s Exp=""
	for
	{
		s Exp= $O(^lee("unExistProInDM",Exp))
		q:Exp=""
		
		s TermId=$P(Exp,"-",1)
		s TermDesc = $LG($G(^User.MKBTermD(TermId)),3)
		w Exp_"]]]"_"术语:"_TermDesc," || 属性:"
		s ProDet = $P(Exp,"-",2)
		s Pro = $P(ProDet,":",1)
		s ProDesc = $LG($G(^User.MKBTermPropertyD(Pro)),3)
		
		s DMId=$O(^User.MKBTermPropertyI("DescIndex",TermId," 诊断模板",0))
		s DMDId = $O(^User.MKBTermProDetailI("ProIdx",DMId,0))
		s DMVal = $LG($G(^User.MKBTermProDetailD(DMDId)),3)	
		
		w Pro_".."_ProDesc," || 诊断模板:"_DMVal,!
		if (DMVal[Pro)
		{
			b	
		}
	}
}

/// Lixin
/// 移除规则管理不合理数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).RemoveUnExistExpForMapping()
ClassMethod RemoveUnExistExpForMapping()
{
	TS
	s SZMBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 深圳版ICD对照"))
	s MKBKLMBRowId=0
	for
	{
		s MKBKLMBRowId=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId))
		q:MKBKLMBRowId=""
		continue:MKBKLMBRowId=SZMBRowId
		
		s Child=0
		for
		{
			s Child=$O(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child))	
			q:Child=""
			
			s MKBKLMFRowId=MKBKLMBRowId_"||"_Child
			s MKBKMBFType = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child)),4)
			s MKBKMBFConfig = $LG($G(^User.MKBKLMappingBaseD(MKBKLMBRowId,"ChildField",Child)),5)
			
			if ((MKBKMBFType="K1")||(MKBKMBFType="K2"))
				{
				if (MKBKMBFConfig="Exp")
				{
					s RowNum=0
					
					for
					{
						s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
						q:RowNum=""
						
						s MKBKLMDRowId=0
						for
						{
							s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBKLMFRowId,MKBKLMDRowId))
							q:MKBKLMDRowId=""
							
							s val = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2) /// 表达式
							if (val'[";&")
							{
								if (val'["-")
								{
									if ($D(^User.MKBTermD(val))=0)
									{
										s sc1=##class(User.MKBKLMappingDetail).%DeleteId(MKBKLMDRowId)
										b:$$$ERROR(sc1)
									}	
								}
								else
								{
									s TermId=$p(val,"-",1)
									if ($D(^User.MKBTermD(TermId))=0)
									{
										s sc2=##class(User.MKBKLMappingDetail).%DeleteId(MKBKLMDRowId)
										b:$$$ERROR(sc2)
									}		
									else
									{
										s ProDet = $P(val,"-",2)
										s Pro = $P(ProDet,":",1)
										if ($D(^User.MKBTermPropertyD(Pro))=0)
										{
											s obj = ##class(User.MKBKLMappingDetail).%OpenId(MKBKLMDRowId)
											s obj.MKBKMDValue = TermId
											s sc3 = obj.%Save()	
											b:$$$ERROR(sc3)
										}	
										else
										{
											k det
											s Dets = $P(ProDet,":",2)
											for i=1:1:$L(Dets,"*")
											{
												s Det = $P(Dets,"*",i)
												if (Det["S")
												{
													s Det = $P(Det,"S",2)
													if ($D(^User.MKBTermProDetailD(Det))'=0)
													{
														s det("S"_Det)=""	
													}	
												}
												else
												{
													if ($D(^User.MKBTermProDetailD(Det))'=0)
													{
														s det(Det)=""	
													}	
		
												}
											}	
											if $D(det)=0
											{
												s obj = ##class(User.MKBKLMappingDetail).%OpenId(MKBKLMDRowId)
												s obj.MKBKMDValue = TermId
												s sc4 = obj.%Save()	
												b:$$$ERROR(sc4)	
											}
											else
											{
												s Dets=""
												s detid=""
												for
												{
													s detid=$O(det(detid))
													q:detid=""
													
													s:Dets'="" Dets=Dets_"*"_detid
													s:Dets="" Dets=detid
												}	
												s Exp = TermId_"-"_Pro_":"_Dets
												s obj = ##class(User.MKBKLMappingDetail).%OpenId(MKBKLMDRowId)
												s obj.MKBKMDValue = Exp
												s sc5 = obj.%Save()	
												b:$$$ERROR(sc5)	
											}
										}		
									}
								}	
							}
							else ///[;&
							{
								s IdsLen = $L(val,";&")
								k idsarr
								for i=1:1:IdsLen
								{
									s Ids = $P(val,";&",i)
									
									if (Ids'["-")
									{
										if ($D(^User.MKBTermD(Ids))'=0)
										{
											s idsarr(Ids)=""
										}	
									}
									else
									{
										s TermId=$p(Ids,"-",1)
										if ($D(^User.MKBTermD(TermId))'=0)
										{
											s idsarr(TermId)=""
												
											s ProDet = $P(Ids,"-",2)
											s Pro = $P(ProDet,":",1)
											
											if ($D(^User.MKBTermPropertyD(Pro))'=0)
											{
												k det
												s Dets = $P(ProDet,":",2)
												for j=1:1:$L(Dets,"*")
												{
													s Det = $P(Dets,"*",j)
													if (Det["S")
													{
														s Det = $P(Det,"S",2)
														if ($D(^User.MKBTermProDetailD(Det))'=0)
														{
															s det("S"_Det)=""	
														}	
													}
													else
													{
														if ($D(^User.MKBTermProDetailD(Det))'=0)
														{
															s det(Det)=""	
														}	
			
													}
												}	
												if $D(det)'=0
												{
													s Dets=""
													s detid=""
													for
													{
														s detid=$O(det(detid))
														q:detid=""
														
														s:Dets'="" Dets=Dets_"*"_detid
														s:Dets="" Dets=detid
													}	
													s idsarr(TermId,Pro,Dets)=""
												}
											}	
										}		
									}	
								}
								s Exp=""
								s t = ""
								for
								{
									s t=$O(idsarr(t))
									q:t=""
									
									if ($O(idsarr(t,""))="")
									{
										s:Exp'="" Exp=Exp_";&"_t
										s:Exp="" Exp=t	
									}
									
									s p = ""
									for
									{
										s p=$O(idsarr(t,p))
										q:p=""
										
										s d=""
										for
										{
											s d=$O(idsarr(t,p,d))
											q:d=""
											
											s:Exp'="" Exp=Exp_";&"_t_"-"_p_":"_d
											s:Exp="" Exp=t_"-"_p_":"_d
										}	
									}	
								}
								
								w:$L(val)'=$L(Exp) val,"-----",Exp,!
								s obj=##class(User.MKBKLMappingDetail).%OpenId(MKBKLMDRowId)
								s obj.MKBKMDValue = Exp
								s sc6 = obj.%Save()
								b:$$$ERROR(sc6)
							}
						}	
					}	
				}	
			}
		}	
	}
}

/// ICD11id串
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).GetIDsForICD11()
ClassMethod GetIDsForICD11(desc)
{
	q:desc="" ""
	s result=""
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD11",0))
	s TermIds=0
	for
	{
		s TermIds = $O(^User.BDPMKBIndexI("DescIndex"," "_$ZCONVERT(desc,"U"),TermIds))
		q:TermIds=""
		
		continue:TermIds["D"
		continue:($D(^User.MKBTermI("BaseIndex",MKBTBRowId,TermIds))=0)
		s:result'="" result=result_"&%"_TermIds
		s:result="" result=TermIds	
	}	
	q result
}

/// 删除结构化表达式内不含:的存在
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ReDealNationICD()
ClassMethod ReDealNationICD()
{
	TS
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
		s obj.MKBICDRemark = "N"
		d obj.MKBICDTermDrSetObjectId("")
		s sc1=obj.%Save()
		b:$$$ERROR(sc1)	
		
		s MKBICDConHISNumber=$LG($G(^User.MKBICDContrastD(MKBICRowId)),4)
		s tempICD = $E(MKBICDConHISNumber,1,5)
		
		
		if ($D(^User.MKBTermI("DescIndex",MKBTBRowId," "_$ZCONVERT(tempICD,"U")))'=0) //存在对应国际编码
		{
			s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_tempICD,0))	
			s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
			s obj.MKBICDRemark = "Y"
			d obj.MKBICDTermDrSetObjectId(MKBTRowId)
			s sc2=obj.%Save()
			b:$$$ERROR(sc2)	
		}
		
	}
}

/// 删除结构化表达式内不含:的存在
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteTermId()
ClassMethod DeleteTermId()
{
	TS

	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))'=0)
		{
			s Child=0
			for
			{
				s Child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child))
				q:Child=""
				
				s MKBICDConResultID = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),2)
				if ((MKBICDConResultID'[":")&(MKBICDConResultID'=""))
				{
					if ($D(^User.MKBTermD(MKBICDConResultID))=0)
					{
						s temp(MKBICRowId_"||"_Child)=""
						continue
					}
					s CYM = ..GetCYM(MKBICDConResultID)
					
					if ($LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),3)=CYM)
					{
						s MKBICDConResultID=""
						s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
						s obj.MKBICDConResultID = MKBICDConResultID
						s sc=obj.%Save()
						b:$$$ERROR(sc)	;1	 	
					}
					else
					{
						b	
					}
				}
				
			}
		}
	}
	b
}

ClassMethod GetCYM(termid)
{

	s result=""
	s result=$P($P(##class(web.DHCBL.MKB.MKBTermProDetail).GetTermComAndPY(termid),"[A]",1),"&%",1)
	
	if (result="")
	{
		s result=$LG($G(^User.MKBTermD(termid)),3)	
	}
	q result
}

/// 遍历全表，将中心词改为常用名，添加诊断模板id
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).TransTermToAlias()
ClassMethod TransTermToAlias()
{
	TS
	///诊断模板id赋值
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))'=0)
		{
			s Child=0
			for
			{
				s Child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child))
				q:Child=""
				
				s MKBICDConResultID = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),2)
				s MKBICDConResult = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),3)
				s MKBICDConPropertyDr = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),4)
				
				s TermId=""
				if (MKBICDConPropertyDr="")
				{
					if (MKBICDConResultID["-")
					{
						s TermId=$P(MKBICDConResultID,"-",1)
					}
					else
					{
						s TermId=MKBICDConResultID
					}
					
					b:$D(^User.MKBTermD(TermId))=0
					s DiagModuleId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 诊断模板",0))
					b:DiagModuleId="" ;1
					
					s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
					d obj.MKBICDConPropertyDrSetObjectId(DiagModuleId)
					s sc=obj.%Save()
					b:$$$ERROR(sc)	;1	
				}
				
			}
		}
	}
	
	///替换常用名
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))'=0)
		{
			s Child=0
			for
			{
				s Child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child))
				q:Child=""
				
				s MKBICDConResultID = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),2)
				s MKBICDConResult = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),3)
				s MKBICDConPropertyDr = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),4)
				
				if (MKBICDConPropertyDr'="") ///诊断模板不为空
				{
					s TermId=$LG($G(^User.MKBTermPropertyD(MKBICDConPropertyDr)),6)
					if ($D(^User.MKBTermD(TermId))=0)
					{
						b ;TermIdNotExist	
					}	
					s CYM=..GetCYM(TermId)
					b:CYM=""
					if (MKBICDConResult["[")
					{
						s TermDesc =$P(MKBICDConResult,"[",1)
						b:TermDesc=""
						if (TermDesc'=CYM)
						{
							;b ;TermDesc'=CYM
							s MKBICDConResult = CYM_"["_$P(MKBICDConResult,"[",2)
							s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
							s obj.MKBICDConResult = MKBICDConResult
							s sc1=obj.%Save()
							b:$$$ERROR(sc1)
						}
					}
					elseif (MKBICDConResult["(")
					{
						s TermDesc = $P(MKBICDConResult,"(",1)
						b:TermDesc=""
						if (TermDesc'=CYM)
						{
							s MKBICDConResult = CYM_"("_$P(MKBICDConResult,"(",2)
							s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
							s obj.MKBICDConResult = MKBICDConResult
							s sc2=obj.%Save()
							b:$$$ERROR(sc2)
						}	
					}
					else
					{
						if (MKBICDConResult'=CYM)
						{
							s MKBICDConResult = CYM
							s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
							s obj.MKBICDConResult = MKBICDConResult
							s sc3=obj.%Save()
							b:$$$ERROR(sc3)	
						}	
					}
				}
				else
				{
					b
					s temp("诊断模板id",MKBICRowId_"||"_Child)=""	
				}
			}
		}
	}
	b
}

/// 处理已经不存在的诊断并将部分MKBExp转化为SDSExp
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealUnexistAndTrans()
ClassMethod DealUnexistAndTrans()
{
	TS
	s num=0
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))'=0)
		{
			s Child=0
			for
			{
				s Child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child))
				q:Child=""
				
				
				s MKBICDConResultID = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),2)
				s MKBICDConResult = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),3)
				s MKBICDConPropertyDr = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),4)
				s BJRowId = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),6)
				
				if ((MKBICDConResult["(")&(MKBICDConResult["="))
				{
					s num=num+1
					if (MKBICDConResultID["-")
					{
						s resultId=""
						s result=""
						s TermId=$P(MKBICDConResultID,"-",1)
						if ($D(^User.MKBTermD(TermId))=0) ///术语不存在
						{
							s temp("termnotexist",MKBICRowId_"||"_Child)=""
							s tsc=##class(User.MKBICDContrastResult).%DeleteId(MKBICRowId_"||"_Child)
							b:$$$ERROR(tsc)						
						}
						else
						{
							s DiagModuleId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 诊断模板",0))
							b:DiagModuleId="" ;1
							
							s CYM=..GetCYM(TermId)
							s result=CYM
							
							s ProDet = $P(MKBICDConResultID,"-",2)
							s Pro=$P(ProDet,":",1)
							
							if ($D(^User.MKBTermPropertyD(Pro))=0) //属性不存在
							{
								s temp("pronotexist",MKBICRowId_"||"_Child)=""
								s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
								s obj.MKBICDConResultID = ""
								s obj.MKBICDConResult = result
								
								
								d obj.MKBICDConPropertyDrSetObjectId(DiagModuleId)
								
								d obj.%Save()
							}
							else
							{
								s ProType = $LG($G(^User.MKBTermPropertyD(Pro)),4)
								if (ProType="T") //树形属性（引用术语型属性已失效）
								{
									s Dets = $P(ProDet,":",2)
									s DetLen = $L(Dets,"*")
									k tdet
									for i=1:1:DetLen
									{
										s Det = $P(Dets,"*",i)
										if ($D(^User.MKBTermProDetailD(Det))'=0)
										{
											s tdet(Det)=""
										}
									}	
									if ($D(tdet)=0) //内容都不存在
									{
										s temp("detallnotexist",MKBICRowId_"||"_Child)=""
										s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
										s obj.MKBICDConResultID = ""
										s obj.MKBICDConResult = result
										
										d obj.MKBICDConPropertyDrSetObjectId(DiagModuleId)
										
										d obj.%Save()	
									}	
									else
									{
										
										///获取诊断模板对应id
										s DiagModuleDetId = $O(^User.MKBTermProDetailI("ProIdx",DiagModuleId,0))
										if (DiagModuleDetId="") //诊断模板内容为空
										{
											s temp("DiagMoeduleNull",MKBICRowId_"||"_Child)=""
											continue
										}
										s DiagModuleDetDesc = $LG($G(^User.MKBTermProDetailD(DiagModuleDetId)),3)
										s DMLen = $L(DiagModuleDetDesc,",")
										k DM
										for DMi = 1:1:DMLen
										{
											s DMSub = $P(DiagModuleDetDesc,",",DMi)
											s DMPro = $P(DMSub,"&",1) //属性id
											s DMType = $P(DMSub,"&",2)
											s DMDefineDet = $P(DMSub,"&",3) //起始节点
											if ((DMType="T")&(DMDefineDet'=""))
											{
												s Childs = ##class(web.DHCBL.MKB.MKBTermProDetail).GetChildOrderedIDStr(DMDefineDet,DMPro)
												s:Childs'="" Childs=DMDefineDet_"^"_Childs
												s:Childs="" Childs=DMDefineDet
												if (Childs'="")
												{
													s clen = $L(Childs,"^")
													for ci=1:1:clen
													{
														s DM(DMPro,$P(Childs,"^",ci),DMDefineDet)=""	
													}		
												}
													
											}
											////DMType="C"的15347	
										}
										///获取诊断模板end		
										if ($D(DM(Pro))=0) ///已选属性不在诊断模板中
										{										
											s temp("pronotinDM",MKBICRowId_"||"_Child)=""
											s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
											s obj.MKBICDConResultID = ""
											s obj.MKBICDConResult = result
											
											d obj.MKBICDConPropertyDrSetObjectId(DiagModuleId)
											
											d obj.%Save()		
										}
										else
										{
											s Det = 0
											s Dets="" //
											for
											{
												s Det = $O(tdet(Det))
												q:Det=""
												
												if ($D(DM(Pro,Det))'=0)
												{
													s:Dets'="" Dets=Dets_"&"_Det
													s:Dets="" Dets=Det	
												}
												
											}
											if (Dets="") ///所选属性内容都不在诊断模板内	
											{
												s temp("pronotinDM",MKBICRowId_"||"_Child)=""
												s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
												s obj.MKBICDConResultID = ""
												s obj.MKBICDConResult = result
												
												d obj.MKBICDConPropertyDrSetObjectId(DiagModuleId)
												
												d obj.%Save()			
											}
											else
											{
												
												s result=result_"["
												s Det=0
												s DetDescs=""
												k DMDefine
												for Di=1:1:$L(Dets,"&")
												{
													s Det = $P(Dets,"&",Di)
													s DetDesc = ##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(Det,Pro,"展示名")
													
													s:DetDescs='"" DetDescs=DetDescs_"，"_DetDesc
													s:DetDescs="" DetDescs=DetDesc
													
													if ($O(DM(Pro,Det,0))'="") ///存在起始节点
													{
														s DefineNode=$O(DM(Pro,Det,0))
														b:DefineNode=""
														s DMDefine(DefineNode,Det)="" 
													}
													else ///不存在起始节点
													{
														s DMDefineNo(Pro,Det)=""
													}
												}
												s result=result_DetDescs
												if ($D(DMDefine)'=0)
												{
													s DefineNode=0 //遍历存在初始节点
													for
													{
														s DefineNode = $O(DMDefine(DefineNode))
														q:DefineNode=""
														
														s:resultId'="" resultId=resultId_"^D"_DefineNode_"T:"
														s:resultId="" resultId="D"_DefineNode_"T:"
														
														s Dets=""
														s Det=0
														for
														{
															s Det=$O(DMDefine(DefineNode,Det))
															q:Det=""
															
															s:Dets'="" Dets=Dets_"^"_Det
															s:Dets="" Dets=Det	
														}
														s resultId=resultId_Dets
														s temp("resultId",MKBICRowId_"||"_Child)=resultId
													}	
												}
												
												s result=result_"]"	
											
												
												
												s obj = ##class(User.MKBICDContrastResult).%OpenId(MKBICRowId_"||"_Child)
												s obj.MKBICDConResultID = resultId
												s obj.MKBICDConResult = result
												
												d obj.MKBICDConPropertyDrSetObjectId(DiagModuleId)
												
												d obj.%Save()	
											}
										}																
									}	
								}
								else
								{
									s temp("termL",MKBICRowId_"||"_Child)=""	
								}	
							}						
						}
					}	
				}
			}
		}
	}
	w "总数:"_num,!
	s tempnum=0
	s y=""
	for
	{
		s y=$O(temp(y))
		q:y=""	
		s ynum=0
		s id=0
		for
		{
			s id=$O(temp(y,id))
			q:id=""
			
			s stemp(id,y)=""
			s ynum=ynum+1
			s tempnum=tempnum+1	
		}
		w y,":",ynum,!
	}
	

	s ResultFile=##class(%File).%New("D:\MKB表达式转SDS表达式.csv") //新建
	d ResultFile.Open("NWS")
	
	d ResultFile.Write("安贞ICD中文释义,结构化诊断结果,存在问题")
	d ResultFile.WriteLine() 
	
	s id=0
	for
	{
		s id=$O(stemp(id))
		q:id=""	
		
		s y=""
		for
		{
			s y=$O(stemp(id,y))
			q:y=""
			
			s Anzhen = $LG($G(^User.MKBICDContrastD($P(id,"||",1))),3)
			s MKBICDConResult = $LG($G(^User.MKBICDContrastD($P(id,"||",1),"MKBICDContrastResult",$P(id,"||",2))),3)
			
			s reason=""
			if (y="detallnotexist")
			{
				s reason = "原属性内容不存在，仅保留中心词"
				
			}
			elseif (y="pronotexist")
			{
				s reason = "原属性不存在，仅保留中心词"	
			}
			elseif (y="pronotinDM")	
			{
				s reason="已选属性不在诊断模板内，仅保留中心词"	
			}
			elseif (y="termL")
			{
				s reason="列表型数据，所选属性在诊断模板中不存在"	
			}
			else
			{
				s reason="数据已转换"	
			}
			
			
			d ResultFile.Write(Anzhen_","_MKBICDConResult_","_reason)
			d ResultFile.WriteLine() 
		}
	}
	d ResultFile.Close()

	w tempnum,!
	b
}

/// 处理带&符号的诊断id，为诊断模板添加id
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealAnd()
ClassMethod DealAnd()
{
	TS
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))'=0)
		{
			s Child=0
			for
			{
				s Child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child))
				q:Child=""
				
				s MKBICDConResultID = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),2)
				s MKBICDConResult = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),3)
				s MKBICDConPropertyDr = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),4)
				s BJRowId = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",Child)),6)
				
				if (MKBICDConResultID[";&")
				{
					s len = $L(MKBICDConResultID,";&")
					for i=1:1:len
					{
						s Exp = $P(MKBICDConResultID,";&",i)
						continue:$D(^User.MKBTermD(Exp))=0
						b:Exp=""
						s ExpDesc = ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(Exp)	
						b:ExpDesc=""
						s:Exp["-" TermId=$P(Exp,"-",1)
						s:Exp'["-" TermId=Exp
						
						s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",TermId," 诊断模板",0))
						b:MKBTPRowId=""
						
						s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
						d cobj.MKBICDContrastSetObjectId(MKBICRowId)
						s cobj.MKBICDConResult = ExpDesc
						s cobj.MKBICDConResultID = Exp
						s cobj.MKBICDConSupplement = ""
						d cobj.MKBICDConPropertyDrSetObjectId(MKBTPRowId)
						d cobj.MKBICDConOtherSetObjectId(BJRowId)
						s csc=cobj.%Save()
						b:$$$ERROR(csc)
					}
					s sc = ##class(User.MKBICDContrastResult).%DeleteId(MKBICRowId_"||"_Child)
					b:$$$ERROR(sc)
				}
			}
		}
	}
}

/// 诊断_ICD10北京码属性添加顺序
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).SetSeqForBJ()
ClassMethod SetSeqForBJ()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10北京码",0))
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s i=1
		s MKBTPRowId=0
		for
		{
			s MKBTPRowId=$O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
			q:MKBTPRowId=""
			
			s obj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
			s obj.MKBTPSequence=i
			d obj.%Save()
			s i =i+1	
		}	
	}
}

/// 导出安贞ICD数据及类
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ExportICDContrastData()
ClassMethod ExportICDContrastData()
{

	k CList
	k myIdx
	s CList($i(CList))= "User.MKBICDContrastD.GBL"
	s CList($i(CList))= "User.MKBICDContrastI.GBL"
	s CList($i(CList))= "User.MKBICDContrastC.GBL"
	s CList($i(CList))= "User.MKBICDContrastResultI.GBL"
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = "D:\安贞ICD\MKBICDContrast"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	
	/*
	k ClassAry
	s ClassAry("User.MKBICDContrast")=""
	s ClassAry("User.MKBICDContrastResult")=""
	d ##class(web.BDP.manager.CheckInOutClass).OutClass(.ClassAry, "D:\安贞ICD", .outinfo)
	*/
}

/// 为安贞ICD数据导入分词结果
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).AnzhenICDSegm()
ClassMethod AnzhenICDSegm()
{
	///把csv中小汗腺？改为中文
	TS
	s file=##class(%File).%New("D:/安贞ICD分词.csv")
	d file.Open("RS")
	s str= file.ReadLine()
	While('file.AtEnd)
	{	
		s str= file.ReadLine()
		q:str=""
		
		s ori=$P(str,",",1)
		s diag=$P(str,",",2)
		s pro=$P(str,",",3)
		s struct=""
		
		s:pro="" struct=diag
		s:pro'="" struct=diag_"("_pro_")"
		
		continue:struct=""
		s num=0
		s id=0
		for
		{
			s id=$O(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(ori,"U"),id))
			q:id=""
			
			s obj=##class(User.MKBICDContrast).%OpenId(id)
			s obj.MKBICDConSegmentation=struct
			s sc = obj.%Save()
			b:$$$ERROR(sc)
			s num=num+1	
		}
		b:num=0
	}
	d file.Close()
}

/// 安贞与国际码匹配情况
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).AnzhenICDWithNation()
ClassMethod AnzhenICDWithNation()
{
	TS
		
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		s MKBICHisNum=$LG($G(^User.MKBICDContrastD(MKBICRowId)),4)
		s MKBICHISDesc=$LG($G(^User.MKBICDContarstD(MKBICRowId)),3)	
		
		if ((MKBICHisNum=0)||(MKBICHisNum="")) ///分词为空
		{
			s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
			s obj.MKBICDRemark = "N"
			s sc1=obj.%Save()
			b:$$$ERROR(sc1)	
		}
		else
		{
			s tempICD = $E(MKBICHisNum,1,5)
			if ($D(^User.MKBTermI("DescIndex",MKBTBRowId," "_tempICD))'=0) //存在对应国际编码
			{
				s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_tempICD,0))
				s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
				
				if (MKBTPDDesc=MKBICHISDesc)
				{
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDRemark = "Y"
					d obj.MKBICDTermDrSetObjectId(MKBTRowId)
					s sc2=obj.%Save()
					b:$$$ERROR(sc2)		
				}
				else
				{
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDRemark = "F"
					d obj.MKBICDTermDrSetObjectId(MKBTRowId)
					s sc3=obj.%Save()
					b:$$$ERROR(sc3)		
				}
			}
			else
			{
				s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDRemark = "N"
					s sc4=obj.%Save()
					b:$$$ERROR(sc4)			
			}
		}
	}
}

/// 将与数据处理工厂诊断分词结果相同的安贞icd结构化
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).StructViaDataFactory()
ClassMethod StructViaDataFactory()
{
	TS
	s num=0
	s segm = ""
	for
	{
		s segm = $O(^User.MKBICDContrastI("SegmIndex",segm))
		q:segm=""	
		continue:segm=-100000000000000
		
		if ($D(^User.MKBStructuredDataI("SegmIndex"," "_segm))'=0)
		{
			s num=num+1
			s MKBICRowId = $O(^User.MKBICDContrastI("SegmIndex",segm,0))
			b:MKBICRowId=""
			
			s MKBSDRowId = $O(^User.MKBStructuredDataI("SegmIndex"," "_segm,0))
			b:MKBSDRowId=""
			
			s MKBSDChild=0
			for
			{
				s MKBSDChild = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild))
				q:MKBSDChild=""
							
				s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
				d cobj.MKBICDConPropertyDrSetObjectId($LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),4))
				s cobj.MKBICDConResult = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),3)
				s cobj.MKBICDConResultID = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),2)
				s cobj.MKBICDConSupplement = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",MKBSDChild)),5)
				s csc=cobj.%Save()
				b:$$$ERROR(csc)
			}		
		}
		
	}
	w "安贞hisICD中文释义分词结果与数据处理工厂数据相同："_num,!
}

/// 通过北京版icd对照结构化安贞icd数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).StructViaBeijing()
ClassMethod StructViaBeijing()
{
	TS
	s num=0
	s num1=0
	s num2=0
	s MKBMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 北京版ICD对照",0))
	s MKBMFChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 中文释义",0))
	s MKBMFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MKBMBRowId," 诊断",0))
	
	s RowNum=0
	for
	{
		s RowNum=$O(^User.MKBKLMappingDetailI("RowNumIndex",MKBMBRowId,RowNum))	
		q:RowNum=""
		
		s MKBKLMDRowId=$O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild,0))
		s BJRowId = $LG($G(^User.MKBKLMappingDetailD(MKBKLMDRowId)),2)
		b:BJRowId=""
		
		s BJDesc = $LG($G(^User.MKBTermD(BJRowId)),3)
		s BJPRowId=$O(^User.MKBTermPropertyI("DescIndex",BJRowId," ICD编码",0))
		s BJPDRowId=$O(^User.MKBTermProDetailI("ProIdx",BJPRowId,0))
		b:BJPDRowId=""
		s BJCode = $LG($G(^User.MKBTermProDetailD(BJPDRowId)),3)
		b:BJCode=""
		
		if ($D(^User.MKBICDContrastI("NumberIndex"," "_$ZCONVERT(BJCode,"U")))'=0)
		{
			s MKBICRowId=0
			for
			{
				s MKBICRowId=$O(^User.MKBICDContrastI("NumberIndex"," "_BJCode,MKBICRowId))	
				q:MKBICRowId=""
				
				s num=num+1
				
				s MKBICDDesc = $LG($G(^User.MKBICDContrastD(MKBICRowId)),3)
				if (BJDesc=MKBICDDesc)
				{
					s num1=num1+1
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDOther = "同码同义"
					s sc1=obj.%Save()
					b:$$$ERROR(sc1)
					
					s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild2,0))
					s MDValue = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
					s StructCN = ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MDValue)
					
					s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
					d cobj.MKBICDContrastSetObjectId(MKBICRowId)
					s cobj.MKBICDConResult = StructCN
					s cobj.MKBICDConResultID = MDValue
					s cobj.MKBICDConSupplement = ""
					d cobj.MKBICDConOtherSetObjectId(BJRowId)
					s csc=cobj.%Save()
					b:$$$ERROR(csc)
					
				}
				else
				{
					s num2=num2+1
					s obj = ##class(User.MKBICDContrast).%OpenId(MKBICRowId)
					s obj.MKBICDOther = "同码不同义"
					s sc1=obj.%Save()
					b:$$$ERROR(sc1) ;同码不同义
					
					s MDRowId = $O(^User.MKBKLMappingDetailI("ValIndex",RowNum,MKBMBRowId_"||"_MKBMFChild2,0))
					s MDValue = $LG($G(^User.MKBKLMappingDetailD(MDRowId)),2)
					s StructCN = ##class(web.DHCBL.MKB.MKBKnoExpression).GetDiagDesc(MDValue)
					
					s cobj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
					d cobj.MKBICDContrastSetObjectId(MKBICRowId)
					s cobj.MKBICDConResult = StructCN
					s cobj.MKBICDConResultID = MDValue
					d cobj.MKBICDConOtherSetObjectId(BJRowId)
					s cobj.MKBICDConSupplement = ""
					s csc=cobj.%Save()
					b:$$$ERROR(csc)	
				}
			}	
		}
	}
	w "通过北京版ICD对照结构化数:"_num,!
	w "同码同义："_num1,!
	w "同码不同义："_num2,!
}

/// 通过数据处理工厂的诊断描述及其对应的结构化为安贞icd结构化
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).StuctViaDiagDesc()
ClassMethod StuctViaDiagDesc()
{
	TS
	s num=0
	s MKBSDRowId=0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		continue:$D(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult"))=0
		
		s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		if ($D(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDDiag,"U")))'=0)
		{
			s MKBICRowId=0
			for
			{
				s MKBICRowId=$O(^User.MKBICDContrastI("DescIndex"," "_$ZCONVERT(MKBSDDiag,"U"),MKBICRowId))
				q:MKBICRowId=""
			
				s num=num+1
				s child=0
				for
				{
					s child=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child))
					q:child=""
					
					s obj = ##class(User.MKBICDContrastResult).%New(MKBICRowId)
					d obj.MKBICDContrastSetObjectId(MKBICRowId)
					d obj.MKBICDConPropertyDrSetObjectId($LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),4))
					s obj.MKBICDConResult = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),3)
					s obj.MKBICDConResultID = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),2)
					s obj.MKBICDConSupplement = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),5)
					s sc=obj.%Save()
					b:$$$ERROR(sc)
				}	
			}
					
		}	
	}
	w "通过诊断查找ICD进行结构化数目：",num,!
}

/// 删除ICD对照子表重复数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteRepeateDataInICDContrastResult()
ClassMethod DeleteRepeateDataInICDContrastResult()
{
	TS
	s i=1
	s MKBICRowId = 0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		k tmp
		
		s child=0
		for
		{
			s child=$O(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",child))
			q:child=""
			

			s MKBICStructResult = $LG($G(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult",child)),3)
			if ($D(tmp(MKBICStructResult))=0)
			{
				s tmp(MKBICStructResult)=""	
			}
			else
			{
				s i=i+1
				s sc = ##class(User.MKBICDContrastResult).%DeleteId(MKBICRowId_"||"_child)	
				if $$$ERROR(sc)
				{
					s error = $SYSTEM.Status.GetErrorText(sc)
					b		
				}
			}
		}	
	}
	w "重复数目："_i,!
}

/// 获取尚未结构化icd条数
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).UnStructData()
ClassMethod UnStructData()
{
	s num=0
	s MKBICRowId=0
	for
	{
		s MKBICRowId=$O(^User.MKBICDContrastD(MKBICRowId))
		q:MKBICRowId=""
		
		if ($D(^User.MKBICDContrastD(MKBICRowId,"MKBICDContrastResult"))=0)
		{
			s num=num+1	
		}	
	}
	w "尚未结构化数据："_num,!
}

/// 导入血液科常用诊断
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportXYK()
ClassMethod ImportXYK()
{
	TS
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICDHIS码",0))
	
	s MBRowId=$O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))
	s MKBMFChild1 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 科室",0))
	s MKBMFChild2 = $O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 诊断",0))
	
	///血液内科科室
	s LocTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 医疗_专业科室",0))
	s LocId = $O(^User.MKBTermI("DescIndex",LocTBRowId," 血液内科",0))
	b:LocId=""
	
	s num = 0
	s freq=""
	for
	{
		s freq=$O(^XIEHELocDiag(freq),-1)
		q:freq=""
		
		s termid=0
		for
		{
			s termid=$O(^XIEHELocDiag(freq,termid))
			q:termid=""
			///w w ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveCellData("24595",1,"Extend2", "128880")
			s Result = ##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveData("",MBRowId,MKBMFChild1_"[A]"_LocId_"[N]"_MKBMFChild2_"[A]"_termid)
			b:Result["false"
		
		}	
	}
	
	w num,!
}

/// 删除数据处理工厂子表重复数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteRepeateDataInStucturedDataResult()
ClassMethod DeleteRepeateDataInStucturedDataResult()
{
	TS
	s i=1
	s MKBSDRowId = 0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		k tmp
		
		s child=0
		for
		{
			s child=$O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child))
			q:child=""
			

			s MKBSDStructResult = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),3)
			if ($D(tmp(MKBSDStructResult))=0)
			{
				s tmp(MKBSDStructResult)=""	
			}
			else
			{
				s i=i+1
				s sc = ##class(User.MKBStructuredDataResult).%DeleteId(MKBSDRowId_"||"_child)	
				if $$$ERROR(sc)
				{
					s error = $SYSTEM.Status.GetErrorText(sc)
					b		
				}
			}
		}	
	}
	w i
}

/// 删除数据处理工厂将英文括号换成中文后重复的诊断	
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteRepeate()
ClassMethod DeleteRepeate()
{
	///先在sqldbx中处理 慢性粒细胞白血病（慢性期）（T（9
	///将左括号
	TS
	s i=0
	s MKBSDRowId = 0
	for
	{
		s MKBSDRowId = $O(^User.MKBStructuredDataD(MKBSDRowId))	
		q:MKBSDRowId=""
		
		s MKBSDDiag = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)

		if ($FIND(MKBSDDiag,")")'=0)
		{
			s MKBSDDiag1 = $TR(MKBSDDiag,")","）")
			if ($D(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(MKBSDDiag1,"U")))'=0)
			{	
				s tempid = $O(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(MKBSDDiag1,"U"),0)) ///中文
				continue:tempid=MKBSDRowId
				
				;w MKBSDDiag,"||||||",$LG($G(^User.MKBStructuredDataD(tempid)),2),!
				
				if (($D(^User.MKBStructuredDataD(tempid,"MKBSDStructResult"))'=0)&&($D(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult"))'=0))
				{
					if ((MKBSDDiag1="心功能III级（NYHA分级）")||(MKBSDDiag1="心功能I级（NYHA分级）")||(MKBSDDiag1="心功能不全（慢性）"))
					{
						d ..CopyLocAndFreqFromSourceToTarget(MKBSDRowId,tempid)
						///取出英文括号记录结构化数据转移至中文括号子表
						s child = 0
						for
						{
							s child = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child))
							q:child=""
							
							s childobj = ##class(User.MKBStructuredDataResult).%New(tempid)
							d childobj.MKBSDStructDataSetObjectId(tempid)	
							d childobj.MKBSDPropertyDRSetObjectId($LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),4))
							s childobj.MKBSDStructResult = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),3)
							s childobj.MKBSDStructResultID = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),2)
							s childobj.MKBSDSupplement = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",child)),5)
							s tchildsc = childobj.%Save()
							b:$$$ERROR(tchildsc)
						}	
						
						d ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId) ///删除英文记录
						
					}
					elseif ((MKBSDDiag1="心功能Ⅱ级（NYHA分级）")||(MKBSDDiag1="高血压病2级（极高危）")||(MKBSDDiag1="原发性高血压（待查）")) //子表记录相同
					{
						d ..CopyLocAndFreqFromSourceToTarget(MKBSDRowId,tempid)	
						d ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId) ///删除英文记录
					}
					else
					{
						b ;error
					}
				}
				elseif($D(^User.MKBStructuredDataD(tempid,"MKBSDStructResult"))'=0) ///中文括号存在结构化数据
				{
					;w "中","    ",MKBSDDiag1,!
					///将英文括号的数据累加至中文括号,删除英文括号记录
					d ..CopyLocAndFreqFromSourceToTarget(MKBSDRowId,tempid)
					s sc2 = ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId) ///删除英文记录
					b:$$$ERROR(sc2)
				}
				elseif ($D(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult"))'=0) ///英文括号存在结构化数据
				{
					;w "英","    ",MKBSDDiag1,!
					d ..CopyLocAndFreqFromSourceToTarget(tempid,MKBSDRowId)
					d ##class(User.MKBStructuredData).%DeleteId(tempid)
					
					s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
					s obj.MKBSDDiag = MKBSDDiag1
					s nsc = obj.%Save()
					b:$$$ERROR(nsc)
				}
				else ///子表没有数据
				{
					w "无","    ",MKBSDRowId,!
					///将英文括号的数据累加至中文括号,删除英文括号记录
					d ..CopyLocAndFreqFromSourceToTarget(MKBSDRowId,tempid)
					s scn = ##class(User.MKBStructuredData).%DeleteId(MKBSDRowId) ///删除英文记录
					b:$$$ERROR(scn)
				}	
				s i=i+1
			}		
		}
	}
	w i
}

/// 将数据处理工厂中的一条数据(sourceid)的科室及频次累加至另一条(targetid)
ClassMethod CopyLocAndFreqFromSourceToTarget(sourceid, targetid)
{
	k target 
	s targetloc = $LG($G(^User.MKBStructuredDataD(targetid)),3)
	s targetfreq = $LG($G(^User.MKBStructuredDataD(targetid)),4)
	
	s loclen = $L(targetloc,",")
	s freqlen = $L(targetloc,",")
	b:loclen'=freqlen
	s len = loclen
	for k=1:1:len
	{
		s target($P(targetloc,",",k))=$P(targetfreq,",",k)	
	}
	
	s sourceloc = $LG($G(^User.MKBStructuredDataD(sourceid)),3)
	s sourcefreq = $LG($G(^User.MKBStructuredDataD(sourceid)),4)
	s loclen = $L(sourceloc,",")
	s freqlen = $L(sourcefreq,",")
	b:loclen'=freqlen
	s len = loclen
	
	for k=1:1:len
	{
		if ($D(target($P(sourceloc,",",k)))'=0)
		{
			s target($P(sourceloc,",",k))=target($P(sourceloc,",",k))+$P(sourcefreq,",",k)		
		}
		else
		{
			s target($P(sourceloc,",",k)) = $P(sourcefreq,",",k)		 	
		}	
	}
	s targetloc=""
	s targetfreq=""
	
	s tloc=0
	for
	{
		s tloc = $O(target(tloc))
		q:tloc=""
		
		s:targetloc'="" targetloc=targetloc_","_tloc
		s:targetloc="" targetloc=tloc
		
		s:targetfreq'="" targetfreq=targetfreq_","_target(tloc)
		s:targetfreq="" targetfreq=target(tloc)
			
	}
	s obj = ##class(User.MKBStructuredData).%OpenId(targetid)
	s obj.MKBSDLoc = targetloc
	s obj.MKBSDFrequency = targetfreq
	s sc=obj.%Save()
	b:$$$ERROR(sc)
}

/// 导出数据处理工厂数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ExportStructuredData()
ClassMethod ExportStructuredData()
{
	k CList
	k myIdx
	s CList($i(CList))= "User.MKBStructuredDataD.GBL"
	s CList($i(CList))= "User.MKBStructuredDataI.GBL"
	s CList($i(CList))= "User.MKBStructuredDataResultI.GBL"
	
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = "D:\MKBGlobal\MKBStructuredData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
}

/// 导入安贞下半年诊断数据分词结果及处理结构化结果
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ExportAnZhenData2()
ClassMethod ExportAnZhenData2()
{
	TS
	s file=##class(%File).%New("D:/安贞下半年诊断分词.csv")
	d file.Open("RS")
	s str= file.ReadLine()
	While 'file.AtEnd
	{	
		s str= file.ReadLine()
		//$zstrip(Diagstrs,"<>W")
		s oridiag = $zstrip($P(str,",",1),"<>W")
		q:str=""
		continue:oridiag="慢性粒细胞性白血病（慢性期）"
		s diag = $zstrip($P(str,",",2),"<>W")
		s det = $zstrip($P(str,",",3),"<>W")
		
		s structdiag = diag_"("_det_")"
		
		if ($D(^User.MKBStructuredDataI("SegmIndex"," "_$ZCONVERT(structdiag,"U")))'=0) ///存在此分词结果
		{
			k tmp //存放子表数据内容
			s k=1
			s MKBSDRowId = 0
			for
			{
				s MKBSDRowId = $O(^User.MKBStructuredDataI("SegmIndex"," "_$ZCONVERT(structdiag,"U"),MKBSDRowId))
				q:MKBSDRowId=""
				
				s Child=0
				for
				{
					s Child = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child))
					q:Child=""
					
					
					s MKBSDStructResultID=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),2)
					s MKBSDStructResult=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),3)
					s MKBSDPropertyDR=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),4)
					s MKBSDSupplement=$LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),5)
					s tmp(k)=MKBSDStructResultID_"&%"_MKBSDStructResult_"&%"_MKBSDPropertyDR_"&%"_MKBSDSupplement
					s k=k+1
				}
			}
			
			s DiagMKBSDRowId=$O(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(oridiag,"U"),0))
			if (DiagMKBSDRowId="")
			{
				b ;3	
			}
			s MKBSDSegmentation = $LG($G(^User.MKBSturcturedDataD(DiagMKBSDRowId)),9)
			if (MKBSDSegmentation="") ///分词结果为空,新导入的数据
			{
				///分词结果赋值
				s obj = ##class(User.MKBStructuredData).%OpenId(DiagMKBSDRowId)
				s obj.MKBSDSegmentation = structdiag
				s sc = obj.%Save()
				b:$$$ERROR(sc)
				
				d Save

				
			}
			else //分词结果不为空，以前导入的数据
			{
				if ($D(^User.MKBtructuredDataD(DiagMKBSDRowId,"MKBSDStructResult"))=0) ///不存在结构化结果
				{
					d Save
				}
			}
			
		}
		else
		{
			s MKBSDRowId = $O(^User.MKBStructuredDataI("MKBSDDiagIndex"," "_$ZCONVERT(oridiag,"U"),0)) ///根据原始诊断查找ID
			if (MKBSDRowId="")
			{
				b ;1	
			}	
			s MKBSDSegmentation = $LG($G(^User.MKBSturcturedDataD(MKBSDRowId)),9)
			if (MKBSDSegmentation="") ///表中存在的分词结果是否与现在相同
			{
				///分词结果赋值
				s obj = ##class(User.MKBStructuredData).%OpenId(MKBSDRowId)
				s obj.MKBSDSegmentation = structdiag
				s sc = obj.%Save()
				b:$$$ERROR(sc)	
			}
		}	
	}
Save
	s k=0
	for
	{
		s k=$O(tmp(k))	
		q:k=""
		
		s tmpstr=tmp(k)
		s MKBSDStructResultID = $P(tmpstr,"&%",1)
		s MKBSDStructResult = $P(tmpstr,"&%",2)
		s MKBSDPropertyDR = $P(tmpstr,"&%",3)
		s MKBSDSupplement =$P(tmpstr,"&%",4)
		s ChildObj = ##class(User.MKBStructuredDataResult).%New(DiagMKBSDRowId)
		d ChildObj.MKBSDPropertyDRSetObjectId(MKBSDPropertyDR)
		d ChildObj.MKBSDStructDataSetObjectId(DiagMKBSDRowId)
		s ChildObj.MKBSDStructResult = MKBSDStructResult
		s ChildObj.MKBSDStructResultID = MKBSDStructResultID
		s ChildObj.MKBSDSupplement = MKBSDSupplement
		s csc = ChildObj.%Save()
		b:$$$ERROR(csc)
	}
	w $LG($G(^User.MKBStructuredDataD(DiagMKBSDRowId)),2),!
}

ClassMethod WriteIntoCSV()
{
	s ResultFile=##class(%File).%New("D:\比对结果.csv")	//新建
	d ResultFile.Open("NWS")
	
	for i=1:1:10
	{
		d ResultFile.Write("诊断中心词,")
		d ResultFile.Write("安贞ICD,")
		d ResultFile.Write("HISICD,")
		d ResultFile.Write("比对结果")
		d ResultFile.WriteLine()	
	}
	d ResultFile.Close()
}

/// 对比腾讯云HISICD数据和安贞ICD数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).CompareHISICWithAnzhen()
ClassMethod CompareHISICWithAnzhen()
{
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICDHIS码",0))
	
	s ResultFile=##class(%File).%New("D:\比对结果.csv")
	d ResultFile.Open("NWS")
	
	s r1=0 ///同码同义
	s r2=0 ///同义不同码
	s r3=0 ///未找到对应hIS诊断
	
	d ResultFile.Write("诊断中心词,")
	d ResultFile.Write("安贞ICD,")
	d ResultFile.Write("HISICD,")
	d ResultFile.Write("比对结果")
	d ResultFile.WriteLine()
	
	s file=##class(%File).%New("D:/安贞ICD.csv")
	d file.Open("RS")
	s str= file.ReadLine()
	While 'file.AtEnd
	{
		s Diagstrs=""
		s Wordstr=""
		
		s str= file.ReadLine()
		s Diag=$p(str,",",2) //诊断名称
		s AnICD = $P(str,",",3)
		
		if ($D(^User.MKBTermI("DescIndex",MKBTBRowId," "_$ZCONVERT(Diag,"U")))'=0) ///存在诊断
		{
			s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_$ZCONVERT(Diag,"U"),0))
			s MKBTPRowId=$O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," ICD编码",0))
			s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
			s HISICD = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			
			d ResultFile.Write(Diag_",")
			d ResultFile.Write(AnICD_",")
			d ResultFile.Write(HISICD_",")
			if (HISICD=AnICD)
			{	
				s r1=r1+1
				d ResultFile.Write("同码同义")
				
			}
			else
			{
				s r2=r2+1
				d ResultFile.Write("同义不同码")	
			}	
			d ResultFile.WriteLine()
		}
		else
		{
			s r3=r3+1
			d ResultFile.Write(Diag_",")
			d ResultFile.Write(AnICD_",")
			d ResultFile.Write(" ,")
			d ResultFile.Write("未找到对应HIS诊断")
			d ResultFile.WriteLine()
		}
		
	}
	d ResultFile.Close()
	d file.Close()
	w "同码同义诊断:"_r1,!,"同义不同码诊断:"_r2,!,"未找到对应诊断:"_r3,!
	q ""
}

/// 为数据处理工厂生成全文检索索引
ClassMethod GenerateIndexForDataFactoru()
{
	TS
	s MKBSDRowId = 0
	for
	{
		s MKBSDRowId=$O(^User.MKBStructuredDataD(MKBSDRowId))
		q:MKBSDRowId=""
		
		s MKBSDValue = $LG($G(^User.MKBStructuredDataD(MKBSDRowId)),2)
		
		s Child=0
		for
		{
			s Child = $O(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child))	
			q:Child=""
			
			s MKBSDRValue = $LG($G(^User.MKBStructuredDataD(MKBSDRowId,"MKBSDStructResult",Child)),3)
			
			d ##class(web.DHCBL.MKB.BDPMKBIndex).SaveStrIdx(MKBSDValue_""_MKBSDRValue,MKBSDRowId_"||"_Child)
		}
			
	}
}

/// 通过索引对数据处理工厂数据查询
ClassMethod GetByDesc(desc)
{
	q:desc="" ""
	s descU = $ZCONVERT(desc,"U")
	if $D(^User.BDPMKBIndexI("DescIndex"," "_descU))'=0
	{
		s MKBSDRRowId=0
		for
		{
			s MKBSDRRowId=$O(^User.BDPMKBIndexI("DescIndex"," "_descU,MKBSDRRowId))
			q:MKBSDRRowId=""
			continue:MKBSDRRowId'["||"
			
			w MKBSDRRowId,!	
		}	
	}
}

/// 诊断HISICD码属性添加顺序
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).SetSeqForHis()
ClassMethod SetSeqForHis()
{
	TS
	s MKBTBRowId=$O(^User.MKBTermBaseI("DescIndex"," 诊断_ICDHIS码",0))
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s i=1
		s MKBTPRowId=0
		for
		{
			s MKBTPRowId=$O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
			q:MKBTPRowId=""
			
			s obj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
			s obj.MKBTPSequence=i
			d obj.%Save()
			s i =i+1	
		}	
	}
}

/// 删除可是对照诊断下所有内容
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteAllPart()
ClassMethod DeleteAllPart()
{
	TS
	s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))
	s RowNum=0
	for
	{
		s RowNum = $O(^User.MKBKLMappingDetailI("RowNumIndex",MKBKLMBRowId,RowNum))
		q:RowNum=""
		
		s result = ##class(web.DHCBL.MKB.MKBKLMappingDetail).DeleteData(RowNum,MKBKLMBRowId)
		b:result["false" 	
	}
}

/// 导入数据处理后的科室对照诊断
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportDataFromSortCenterid()
ClassMethod ImportDataFromSortCenterid()
{
	TS
	s MKBKLMBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))
	s LocId = $O(^User.MKBTermI("DescIndex",$O(^User.MKBTermBaseI("DescIndex"," 医疗_专业科室",0))," 心血管内科",0))
	s DiagChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",$O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))," 诊断",0))	
	s LocChild = $O(^User.MKBKLMappingBaseFieldI("DescIndex",$O(^User.MKBKLMappingBaseI("DescIndex"," 科室对照诊断",0))," 科室",0))
	b:((DiagChild="")||(MKBKLMBRowId="")||(LocChild=""))
	s i=1
	s seq=""
	for
	{
		s seq = $O(^SortCenterid(seq),-1)
		q:seq<50
		
		s MKBTDesc = ""
		for
		{
			s MKBTDesc = $O(^SortCenterid(seq,MKBTDesc))
			q:MKBTDesc=""
			
			s MKBTRowId=$O(^User.MKBTermI("DescIndex",$O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))," "_$ZCONVERT(MKBTDesc,"U"),0))	
			 
			if (MKBTRowId'="")
			{
				;s result1=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveCellData(i,MKBKLMBRowId,MKBKLMBRowId_"Extend"_DiagChild,MKBTRowId)
				s MDObj = ##class(User.MKBKLMappingDetail).%New()
				s MDObj.MKBKMDRowNum = i
				d MDObj.MKBKMDKMBaseDrSetObjectId(MKBKLMBRowId)
				d MDObj.MKBKMDKMBaseFieldDrSetObjectId(MKBKLMBRowId_"||"_DiagChild)
				s MDObj.MKBKMDValue = MKBTRowId
				d MDObj.%Save()
				s ID = MDObj.%Id()
				s result1 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MD",ID,"T",MKBTRowId)
				
				
				;s result2=##class(web.DHCBL.MKB.MKBKLMappingDetail).SaveCellData(i,MKBKLMBRowId,MKBKLMBRowId_"Extend"_LocChild,LocId)
				s MDObj = ##class(User.MKBKLMappingDetail).%New()
				s MDObj.MKBKMDRowNum = i
				d MDObj.MKBKMDKMBaseDrSetObjectId(MKBKLMBRowId)
				d MDObj.MKBKMDKMBaseFieldDrSetObjectId(MKBKLMBRowId_"||"_LocChild)
				s MDObj.MKBKMDValue = LocId
				d MDObj.%Save()
				s ID = MDObj.%Id()
				s result2 = ##class(web.DHCBL.MKB.MKBReference).SaveDataById("","MD",ID,"T",LocId)
				
				b:((result1["false")||(result2["false"))
				s i=i+1	
			}
			else
			{
				w MKBTDesc,!
				continue	
			}
		}	
	}
	w i
}

/// 处理肺水肿病因属性
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealFSZ()
ClassMethod DealFSZ()
{
	TS
	s DisTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 生理病理_主要病因",0))
	s DisTRowId=$O(^User.MKBTermI("DescIndex",DisTBRowId," 渗出性",0))

	S MKBTRowId = $O(^User.MKBTermI("DescIndex",5," 肺水肿",0))
	s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 病因",0))
	s MKBTPDRowId=0
	for
	{
		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
		q:MKBTPDRowId=""
		
		s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
		w MKBTPDDesc,!
	
		d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBTPDRowId)
			
	}
	s TPObj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
	s TPObj.MKBTPConfig = DisTBRowId 
	d TPObj.%Save()
	
	s MKBTPDObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
	s MKBTPDObj.MKBTPDDesc = DisTRowId
	s MKBTPDObj.MKBTPDProDR = MKBTPRowId
	d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDObj)
}

/// 删除引用及单节点引用类型不合理的属性内容
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteAllInvalid()
ClassMethod DeleteAllInvalid()
{
	s MKBTBRowId=5
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
	
		s MKBTPRowId=0
		for
		{
			s MKBTPRowId=$O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
			q:MKBTPRowId=""
			
			s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)	
			continue:((MKBTPType'="SS")&&(MKBTPType'="S"))
			
			s MKBTPDRowId=0
			for
			{
				s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
				q:MKBTPDRowId=""
				
				s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
				if ($D(^User.MKBTermD(MKBTPDDesc))=0)
				{
					d ##class(User.MKBTermProDetail).%DeleteId(MKBTPDRowId)	
				}	
			}
		}
	}
}

/// 查看病因是否存在未配置配置项
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).DealDis1()
ClassMethod DealDis1()
{
	s MKBTBRowId=5
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 病因",0))
		b:MKBTPRowId=""
		
		s MKBTPConfig = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),5)
		if MKBTPConfig=""
		{
			w $LG($G(^User.MKBTermD(MKBTRowId)),3),!
		}
	}
}

/// 查看病因属性内容是否删除彻底
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealDis2()
ClassMethod DealDis2()
{
	s MKBTBRowId=5
	s MKBTRowId=0
	for
	{
		s MKBTRowId=$O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 病因",0))
		b:MKBTPRowId=""	
		
		s MKBTPDRowId =0
		for
		{
			s MKBTPDRowId=$O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD(MKBTPDRowId)),3)
			if $D(^User.MKBTermD(MKBTPDDesc))=0
			{
				w $LG($G(^User.MKBTermD(MKBTRowId)),3),!
				q	
			}	
		}
	}
}

/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ImportDataChange()
ClassMethod ImportDataChange()
{
	s SSUSRRowId =$O(^SSU("SSUSR",0,"SSUSR_Initials","DEMO",0))
	b:SSUSRRowId=""
	s i=""
	for
	{
		s i =$O(^LeeDataChange("MKB","DataChangeLog",i))
		q:i=""
		
		s info = ^LeeDataChange("MKB","DataChangeLog",i)
		s obj = ##class(User.BDPDataChangeLog).%New()
		s obj.TableName = $LG($G(info),2)
		s obj.ClassName = $LG($G(info),3)
		s obj.ObjectReference = $LG($G(info),4)
		d obj.UpdateUserDRSetObjectId(SSUSRRowId)
		s obj.UpdateUserName = $LG($G(info),6)
		s obj.UpdateDate = $LG($G(info),7)
		s obj.UpdateTime = $LG($G(info),8)
		s obj.OperateType = $LG($G(info),9)
		s obj.NewValue = $LG($G(info),10)
		s obj.ClassNameDesc = $LG($G(info),11)
		s obj.ObjectDesc = $LG($G(info),12)
		s obj.IpAddress = $LG($G(info),13)
		s obj.OldValue = $LG($G(info),14)
		d obj.%Save()
		w i
	}
}

/// / lixin 20181213
/// Desc:到处日志表中所有医用知识库数据
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).GetDataChangeLog()	
ClassMethod GetDataChangeLog()
{
	s i=0
	s BDCLRowId = 0
	for
	{
		s BDCLRowId = $O(^User.BDPDataChangeLogD(BDCLRowId))	
		q:BDCLRowId=""
		
		s ClassName = $LG($G(^User.BDPDataChangeLogD(BDCLRowId)),3)
		continue:ClassName'["User.MKB"
		
		s ^LeeDataChange("MKB","DataChangeLog",i)=^User.BDPDataChangeLogD(BDCLRowId)
		s i=i+1
	}
}

/// Creator:李欣	
/// Desc:导出医用知识库global
/// d ##class(web.DHCBL.MKB.MKBDataImport).ExportMKBGlobal()
ClassMethod ExportMKBGlobal()
{
	k CList
	k myIdx
	s CList($i(CList))= "LeeDataChange"  //术语库注册表
	k ^LeeDataChange("MKB","DataChangeLog")
	s items = ""
	f {
		s myIdx = $i(myIdx)
		q:(myIdx>$g(CList))
		s:((items'="")&&(CList(myIdx)'="")) items= items_","

		s items = items_CList(myIdx)
	}
	s time = $zd($p($h,",",1),3)
	s filename = "D:\MKBGlobal\NewTable\MKBData"_time_".gof"
	s filename = $tr(filename,"-","")
	d $SYSTEM.OBJ.Export(items, filename, "", .log)
	s time = $zd(+$H-10,3)
	w time,!
	s filename = "D:\MKBGlobal\NewTable\MKBData"_time_".gof"
	s filename = $tr(filename,"-","")
	s flag = ##class(%Library.File).Exists(filename,"")
	d:flag=1 ##class(%Library.File).ComplexDelete(filename,"")
}

/// / lixin 20181204
/// Desc:所有术语的文本框类型改为多行文本框
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).TXTypeToTA()	
ClassMethod TXTypeToTA()
{
	TS
	s MKBTBRowId = 0
	for
	{
		s MKBTBRowId = $O(^User.MKBTermBaseD(MKBTBRowId))
		q:MKBTBRowId=""
		
		///共有属性部分
		s MKBTBPRowId=0
		for
		{
			s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId))
			q:MKBTBPRowId=""
			
			s MKBTBPType = $LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),4)
			if (MKBTBPType="TX")
			{
				s MKBTBPObj = ##class(User.MKBTermBaseProperty).%OpenId(MKBTBPRowId)
				s MKBTBPObj.MKBTBPType = "TA"
				d MKBTBPObj.%Save()	
			}	
			s MKBTBEPRowId = 0
			for
			{
				s MKBTBEPRowId = $O(^User.MKBTermBaseExtendProI("ParIndex",MKBTBPRowId,MKBTBEPRowId))
				q:MKBTBEPRowId=""
				
				if ($LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId,"ChildExt",MKBTBEPRowId)),3)="TX")
				{
					s MKBTBEPObj = ##class(User.MKBTermBaseExtendPro).%OpenId(MKBTBPRowId_"||"_MKBTBEPRowId)
					s MKBTBEPObj.MKBTBEPType = "TA"
					d MKBTBEPObj.%Save()	
				}	
			}
			
		}	
		
		s MKBTRowId = 0
		for
		{
			s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
			q:MKBTRowId=""
			
			///属性部分
			s MKBTPRowId=0
			for
			{
				s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
				q:MKBTPRowId=""
				
				if ($LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)="TX")
				{
					s MKBTPObj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
					s MKBTPObj.MKBTPType = "TA"
					d MKBTPObj.%Save()	
				}	
				
				s MKBTEPName=""
				for
				{
					s MKBTEPName = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId,MKBTEPName))
					q:MKBTEPName=""	
					
					s MKBTEPRowId = 0
					for
					{
						s MKBTEPRowId = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId,MKBTEPName,MKBTEPRowId))	
						q:MKBTEPRowId=""
						
						if ($LG($G(^User.MKBTermPropertyD(MKBTPRowId,"ChildExtPro",MKBTEPRowId)),3)="TX")
						{
							s MKBTEPObj = ##class(User.MKBTermExtendPro).%OpenId(MKBTPRowId_"||"_MKBTEPRowId)
							s MKBTEPObj.MKBTEPType = "TA"
							d MKBTEPObj.%Save()	
						}
					}
				}
				
			}
		}
	}
}

/// / lixin 20181126
/// Desc:将解剖学部位的展示名属性格式改成别名格式
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealPartPY()	
ClassMethod DealPartPY()
{
	TS
	s PartTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 解剖学_主要部位",0))
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",PartTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 别名",0))
		b:MKBTPRowId="" ;MKBTPRowId=""
		
		s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0))
		;b:MKBTPDRowId ;MKBTPDRowId=""
		s obj=""
		if (MKBTPDRowId="")
		{
			s obj = ##class(User.MKBTermProDetail).%New()
			s obj.MKBTPDCode = $LG($G(^User.MKBTermD(MKBTRowId)),3)
			s obj.MKBTPDDesc = obj.MKBTPDCode
			s obj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.MKBTPDDesc)
			d obj.MKBTPDProDRSetObjectId(MKBTPRowId)
		}
		else
		{
			s obj = ##class(User.MKBTermProDetail).%OpenId(MKBTPDRowId)
			s obj.MKBTPDPYCode = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.MKBTPDDesc)	
		}
		
		d obj.%Save()	
	}
}

/// / lixin 20181126
/// Desc:将解剖学部位的展示名属性格式改成别名格式
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealPartAlias()
ClassMethod DealPartAlias()
{
	TS
	s DiagTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s PartTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 解剖学_主要部位",0))
	
	s DiagTBPRowId = $O(^User.MKBTermBasePropertyI("DescIndex",DiagTBRowId," 别名",0))
	s PartTBPRowId = $O(^User.MKBTermBasePropertyI("DescIndex",PartTBRowId," 展示名",0))	
	s PartObj = ##class(User.MKBTermBaseProperty).%OpenId(PartTBPRowId)
	s PartObj.MKBTBPCode = "别名"
	s PartObj.MKBTBPDesc = "别名"
	s PartObj.MKBTBPFlag = "AL"
	s PartObj.MKBTBPName = "别名"
	s PartObj.MKBTBPType = "L"
	d PartObj.%Save()
	
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",PartTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 展示名",0))
		b:MKBTPRowId=""
		
		s MKBTPObj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
		s MKBTPObj.MKBTPCode = "别名"
		s MKBTPObj.MKBTPDesc = "别名"
		s MKBTPObj.MKBTPFlag = "AL"
		s MKBTPObj.MKBTPName = "别名"
		s MKBTPObj.MKBTPType = "L"
		d MKBTPObj.%Save()
	}
}

/// lixin 20181102
/// 病因处理
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealReasonPro()
ClassMethod DealReasonPro()
{
	TS
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	///术语库注册
	s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("DescIndex",MKBTBRowId," 病因",0))
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%OpenId(MKBTBPRowId)
	s MKBTBPObj.MKBTBPType = "SS"
	d MKBTBPObj.%Save()
	//术语管理
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 病因",0))
		b:MKBTPRowId=""
		
		s obj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
		s obj.MKBTPType = "SS"
		d obj.%Save()	
		
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBTPDRowId)	
		}

	}
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s TKBTBRowId = $O(^User.TKBTremBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s TKBTRowId = 0
	for
	{
		s TKBTRowId = $O(^TKBTREMi(0,"Base",TKBTBRowId,TKBTRowId))
		q:TKBTRowId=""	
		
		///获取对应的
		s TKBTDesc = ($P($G(^TKBTREM(TKBTRowId)),"^",2))
		s TKBTDesc = ..Trim(TKBTDesc)
		;continue:TKBTDesc="嗜血细胞综合征"
		s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_$ZCONVERT(TKBTDesc,"U"),0))
		;s MKBTRowId = ##class(web.DHCBL.MKB.MKBDataImport).GetNewTermID(TKBTRowId)
		;w TKBTRowId,"||",TKBTDesc,"||"	
		b:MKBTRowId=""
		s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
		s MKBTDesc = ..Trim(MKBTDesc)
		;w MKBTDesc,"||",!
		if (MKBTDesc '= TKBTDesc)
		{
			b ;	我们不一样
		}
		
		s TKBTBFChild = $O(^User.TKBTremBaseFieldI("DescIndex",TKBTBRowId," 病因",0))
		continue:TKBTBFChild=""
		s TKBTBFRowId = TKBTBRowId_"||"_TKBTBFChild
		s TKBTIRowId = $O(^TKBTREMITMi(0,"Link",TKBTRowId,TKBTBFRowId,0))
		continue:TKBTIRowId=""
		s TKBTIDesc = $P($G(^TKBTREMITM(TKBTIRowId)),"^",3)	
		;w TKBTIDesc,"||",$P($G(^TKBTREM(TKBTIDesc)),"^",2),!	
		s PartDesc = $P($G(^TKBTREM(TKBTIDesc)),"^",2)
		s PartTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 生理病因_主要病因",0))
		s MKBPartRowId = $O(^User.MKBTermI("DescIndex",PartTBRowId," "_$ZCONVERT(PartDesc,"U"),0))
		b:MKBPartRowId="" ;MKBPartRowId=""
		
		s MKBTPDObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 病因",0))
		s MKBTPDObj.MKBTPDCode = MKBPartRowId
		s MKBTPDObj.MKBTPDDesc = MKBPartRowId
		s MKBTPDObj.MKBTPDProDR = MKBTPRowId
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDObj)
	}
}

/// lixin 20181102
/// 部位处理
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DealPartPro()
ClassMethod DealPartPro()
{
	TS
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	///将所有部位属性初始为私有，改名存储
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		if $D(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 部位")) //存在部位属性
		{
			s obj = ##class(User.MKBTermProperty).%OpenId($O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 部位",0)))
			s obj.MKBTPCode = "部位1"
			s obj.MKBTPDesc = "部位1"
			s obj.MKBTPName = "部位1"
			s obj.MKBTPPublic = "N"
			d obj.%Save()	
		}	
	}
	///部位字段公有属性改名为部位
	///术语库注册
	s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("DescIndex",MKBTBRowId," 部位字段",0))
	s MKBTBPObj = ##class(User.MKBTermBaseProperty).%OpenId(MKBTBPRowId)
	s MKBTBPObj.MKBTBPCode = "部位"
	s MKBTBPObj.MKBTBPDesc = "部位"
	s MKBTBPObj.MKBTBPName = "部位"
	s MKBTBPObj.MKBTBPType = "SS"
	d MKBTBPObj.%Save()
	//术语管理
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 部位字段",0))
		b:MKBTPRowId=""
		
		s obj = ##class(User.MKBTermProperty).%OpenId(MKBTPRowId)
		s obj.MKBTPCode = "部位"
		s obj.MKBTPDesc = "部位"
		s obj.MKBTPName = "部位"
		s obj.MKBTPType = "SS"
		d obj.%Save()	
		
		s MKBTPDRowId = 0
		for
		{
			s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
			q:MKBTPDRowId=""
			d ##class(web.DHCBL.MKB.MKBTermProDetail).DeleteData(MKBTPDRowId)	
		}

	}
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s TKBTBRowId = $O(^User.TKBTremBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s TKBTRowId = 0
	for
	{
		s TKBTRowId = $O(^TKBTREMi(0,"Base",TKBTBRowId,TKBTRowId))
		q:TKBTRowId=""	
		
		///获取对应的
		s TKBTDesc = ($P($G(^TKBTREM(TKBTRowId)),"^",2))
		s TKBTDesc = ..Trim(TKBTDesc)
		continue:TKBTDesc="嗜血细胞综合征"
		s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_$ZCONVERT(TKBTDesc,"U"),0))
		;s MKBTRowId = ##class(web.DHCBL.MKB.MKBDataImport).GetNewTermID(TKBTRowId)
		;w TKBTRowId,"||",TKBTDesc,"||"	
		b:MKBTRowId=""
		s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3)
		s MKBTDesc = ..Trim(MKBTDesc)
		;w MKBTDesc,"||",!
		if (MKBTDesc '= TKBTDesc)
		{
			b ;	我们不一样
		}
		
		s TKBTBFChild = $O(^User.TKBTremBaseFieldI("DescIndex",TKBTBRowId," 部位",0))
		continue:TKBTBFChild=""
		s TKBTBFRowId = TKBTBRowId_"||"_TKBTBFChild
		s TKBTIRowId = $O(^TKBTREMITMi(0,"Link",TKBTRowId,TKBTBFRowId,0))
		continue:TKBTIRowId=""
		s TKBTIDesc = $P($G(^TKBTREMITM(TKBTIRowId)),"^",3)	
		;w TKBTIDesc,"||",$P($G(^TKBTREM(TKBTIDesc)),"^",2),!	
		s PartDesc = $P($G(^TKBTREM(TKBTIDesc)),"^",2)
		s PartTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 解剖学_主要部位",0))
		s MKBPartRowId = $O(^User.MKBTermI("DescIndex",PartTBRowId," "_$ZCONVERT(PartDesc,"U"),0))
		b:MKBPartRowId="" ;MKBPartRowId=""
		
		s MKBTPDObj = ##class(web.Entity.MKB.MKBTermProDetail).%New()
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 部位",0))
		s MKBTPDObj.MKBTPDCode = MKBPartRowId
		s MKBTPDObj.MKBTPDDesc = MKBPartRowId
		s MKBTPDObj.MKBTPDProDR = MKBTPRowId
		d ##class(web.DHCBL.MKB.MKBTermProDetail).SaveData(MKBTPDObj)
	}
}

/// w ##class(web.DHCBL.MKB.MKBDataProcessing).Trim("  asdas d    ")
ClassMethod Trim(str)
{
	while($e(str,1)=" ")
	{
		s str = $e(str,2,$L(str))	
	}	
	while ($E(str,$L(str))=" ")
	{
		s str = $E(str,1,$L(str)-1)	
	}
	q str
}

/// lixin 20181102
/// 查询所有有检索码扩展列的术语
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).IterAllForPY()
ClassMethod IterAllForPY()
{
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermD(MKBTRowId))
		q:MKBTRowId=""
		continue:$D(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))'=0
	
		s MKBTPRowId=0
		for
		{
			s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
			q:MKBTPRowId=""
			
			if ($D(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 检索码"))'=0)	
			{
				w $LG($G(^User.MKBTermD(MKBTRowId)),3),"||",$LG($G(^User.MKBTermPropertyD(MKBTPRowId)),3),"||",MKBTRowId,!	
			}
		}	
	}
}

/// lixin 20181102
/// 将诊断学临床实用诊断公有属性的所有检索码扩展列删除(以及删除新增加的术语中的检索码扩展列及内容)
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).DeleteDiagPY()
ClassMethod DeleteDiagPY()
{
	TS
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s MKBTBPRowId = 0
	for
	{
		s MKBTBPRowId = $O(^User.MKBTermBasePropertyI("TermBaseIdx",MKBTBRowId,MKBTBPRowId))
		q:MKBTBPRowId=""
		
		if ($D(^User.MKBTermBaseExtendProI("NameIndex",MKBTBPRowId,"检索码"))'=0)
		{
			s MKBTBEPRowId = $O(^User.MKBTermBaseExtendProI("NameIndex",MKBTBPRowId,"检索码",0))
			w $LG($G(^User.MKBTermBaseD(MKBTBRowId)),3),"||",$LG($G(^User.MKBTermBasePropertyD(MKBTBPRowId)),3),!
			d ##class(User.MKBTermBaseExtendPro).%DeleteId(MKBTBEPRowId)
		}	
	}
	
	///删除新加的数据中的检索码扩展列
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId =0
		for
		{
			s MKBTPRowId = $O(^User.MKBTermPropertyI("TermIndex",MKBTRowId,MKBTPRowId))
			q:MKBTPRowId=""
			
			s MKBTPType = $LG($G(^User.MKBTermPropertyD(MKBTPRowId)),4)
			continue:((MKBTPType'="L")&&(MKBTPType'="T"))

			s MKBTEPRowId = $O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 检索码",0))
			if (MKBTEPRowId="")
			{
				b ;MKBTEPROWID=""	
			}	
			s MKBTEPRowId = MKBTPRowId_"||"_$O(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 检索码",0))
			
			s MKBTPDRowId = 0
			for
			{
				s MKBTPDRowId = $O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,MKBTPDRowId))
				q:MKBTPDRowId=""
				
				s MKBTEPVRowId = $O(^User.MKBTermExtendProValI("ValIndex",MKBTPDRowId,MKBTEPRowId,0))
				if (MKBTEPVRowId="")
				{
					b ;MKBTEOVRowID=""	
				}	
				
				s MKBTEPVValue = $LG($G(^User.MKBTermExtendProValD(MKBTEPVRowId)),4)
				w MKBTEPVValue,!
				
				s sc4 = ##class(User.MKBTermExtendProVal).%DeleteId(MKBTEPVRowId)
				if $$$ERROR(sc4)
				{
					s error4 = $SYSTEM.Status.GetErrorText(sc4)
					b ;error4	
				}
			}
			s sc5 = ##class(User.MKBTermExtendPro).%DeleteId(MKBTEPRowId)
			if $$$ERROR(sc5)
			{
				s error5 = $SYSTEM.Status.GetErrorText(sc5)
				b ;error5	
			}
		}
	}
}

/// 李欣 20181102
/// 检查诊断学分型属性是否缺少别名扩展列
/// d #class(web.DHCBL.MKB.MKBDataProcessing).FXAlias()
ClassMethod FXAlias()
{
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",MKBTBRowId,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 分型",0))
		if ($D(^User.MKBTermExtendProI("NameIndex",MKBTPRowId," 别名"))=0)
		{
			w $LG($G(^User.MKBTermD(MKBTRowId)),3),!	
		}	
	}
}

/// Author:李欣 20181023
/// Desc:新表导出临床学诊断及诊断模板缺省展示效果
/// w ##class(web.DHCBL.MKB.MKBDataProcessing).ExportTermAndDefault()
ClassMethod ExportTermAndDefault()
{
	s MKBTRowId = 0
	for
	{
		s MKBTRowId = $O(^User.MKBTermI("BaseIndex",5,MKBTRowId))
		q:MKBTRowId=""
		
		s MKBTDesc = $LG($G(^User.MKBTermD(MKBTRowId)),3) //中心词
		s proId=$o(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 诊断模板",0))
		s moduleDetail = "" //诊断模板缺省展示效果
		if (proId'="")
		{
			s proDetailId=$o(^User.MKBTermProDetailI("ProIdx",proId,0))
			if (proDetailId'="")
			{
				s proDetailDesc=$LISTGET($G(^User.MKBTermProDetailD(proDetailId)),3)   //属性内容
				s argsLen=$Length(proDetailDesc,",")
			    for i=1:1:argsLen   
			    {     
			        s descAndType=$p(proDetailDesc,",",i)  //术语属性id&展示类型&起始节点
			        s catRowId=$p(descAndType,"&",1)  //术语属性id
			        s showType=$p(descAndType,"&",2) //展示类型
			        s treeNode=$p(descAndType,"&",3) //定义起始节点
			        s TreeNodeDesc=""
			        if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
			      	{
				      	s TreeNodeDesc=##class(web.DHCBL.MKB.MKBTermProDetail).GetExtendVal(treeNode,catRowId,"展示名")  //获取展示名
						s:TreeNodeDesc="" TreeNodeDesc=$LISTGET($G(^User.MKBTermProDetailD(treeNode)),3) //节点描述
			      	}
			      	s catDesc=$LISTGET($G(^User.MKBTermPropertyD(catRowId)),3)  //术语属性描述
				    s:TreeNodeDesc'="" catDesc=TreeNodeDesc 
				    s:moduleDetail'="" moduleDetail = moduleDetail_","_catDesc
				    s:moduleDetail="" moduleDetail = catDesc
			    }
			}
			else
			{
				s moduleDetail = "空"	
			}	
		}
		else
		{
			s moduleDetail = "空"	
		}
		w MKBTDesc,"  ||  ",moduleDetail,!
	}
}

/// Author:李欣 20181023
/// Desc:旧表导出临床学诊断及诊断模板缺省展示效果
/// d ##class(web.DHCBL.MKB.MKBDataProcessing).ExportOldTermAndDefault()
ClassMethod ExportOldTermAndDefault()
{
	s TKBTBRowId = $O(^User.TKBTremBaseI("DescIndex"," 诊断学_临床实用诊断",0))
	s TKBTRowId = 0
	for
	{
		s TKBTRowId = $O(^TKBTREMi(0,"Base",TKBTBRowId,TKBTRowId)) ;$O(^User.MKBTermI("BaseIndex",5,MKBTRowId))
		q:TKBTRowId=""
		
		s TKBTDesc = $P($G(^TKBTREM(TKBTRowId)),"^",2)
		s extId = $O(^TKBTREEXTi(0,"Desc",TKBTRowId,"诊断模板",0))
		s moduleDetail = "" //诊断模板缺省展示效果
		
		if (extId'="")
		{
			s extDetailId=$o(^TKBTREEXTDTLi(0,"Ext",extId,0))
			if (extDetailId'="")   ;;;;;;;;;;
			{
				////18920&T&43043,18919&T&43039,18919&T&43040,138&C&undefined
				s descStr = $P($G(^TKBTREEXTDTL(extDetailId)),"^",2)	
				if (descStr'="")
				{
					s argsLen=$Length(descStr,",")
				    for i=1:1:argsLen   
				    {     
				        s descAndType=$p(descStr,",",i)  //术语属性id&展示类型
				        s catRowId=$p(descAndType,"&",1)  //术语属性id
				        s showType=$p(descAndType,"&",2) //展示类型
				        s treeNode=$p(descAndType,"&",3) //定义起始节点
				        s TreeNodeDesc=""
				        if (treeNode'="")   //节点描述取展示名、没有展示名再取描述 谷雪萍 2018-03-01
				      	{
					      	s showLength=$d(^TKBTREEXT(0,"Cat","展示名",catRowId))
							if (showLength)
							{
								s showChildsub=$o(^TKBTREEXT(0,"Cat","展示名",catRowId,0))
								s showCatId=catRowId_"||"_showChildsub
								s TKBTEVRowId=$o(^TKBTREEXTVALi(0,"Val",treeNode,showCatId,0))
						        s:TKBTEVRowId'="" TreeNodeDesc=$p($g(^TKBTREEXTVAL(TKBTEVRowId)),"^",3)			
							}
							s:TreeNodeDesc="" TreeNodeDesc=$p($g(^TKBTREEXTDTL(treeNode)),"^",2) //节点描述
				      	}
				   		s catDesc=$p($g(^TKBTREEXT(catRowId)),"^",2)  //术语属性描述
				   		s:TreeNodeDesc'="" catDesc=TreeNodeDesc 
				   		s:moduleDetail'="" moduleDetail = moduleDetail_","_catDesc
				    	s:moduleDetail="" moduleDetail = catDesc
				    }	
				}
			}
			else
			{
				s moduleDetail = "空"	
			}	
		}
		else
		{
			s moduleDetail = "空"	
		}
		s moduleDetail = ##class(web.DHCBL.MKB.MKBContextSearch).Replace(moduleDetail," ","")
		w TKBTDesc,"  ||  ",moduleDetail,!
	}
}

/// d ##class(web.DHCBL.MKB.MKBDataProcessing).HISICDAddNation()
ClassMethod HISICDAddNation()
{
	TS
	s ^TMP("TermId不存在")=""
	s MBRowId = $O(^User.MKBKLMappingBaseI("DescIndex"," HIS版ICD对照",0))	
	s MKBTBRowId = $O(^User.MKBTermBaseI("DescIndex"," 诊断_ICD10国际码",0))
	s DescField = MBRowId_"||"_$O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 中文释义",0))
	s CodeField = MBRowId_"||"_$O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," ICD编码",0))
	s NationField = MBRowId_"||"_$O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 国际码",0))
	w NationField,!
	s FlagField = MBRowId_"||"_$O(^User.MKBKLMappingBaseFieldI("DescIndex",MBRowId," 标记",0))
	s RowNum=0
	for
	{
		s RowNum = $O(^User.MKBKLMappingDetailI("RowNumIndex",MBRowId,RowNum))
		q:RowNum=""
		
		s ICDDescID = $LG($G(^User.MKBKLMappingDetailD($O(^User.MKBKLMappingDetailI("ValIndex",RowNum,DescField,0)))),2)
		if ($D(^User.MKBTermD(ICDDescID))=0)
		{
			s ^TMP("TermId不存在")=^TMP("TermId不存在")_"&"_ICDDescID	
			continue	
		}
		s ICDDesc = $LG($G(^User.MKBTermD(ICDDescID)),3)
		
		s ICDCodeID = $O(^User.MKBTermPropertyI("DescIndex",ICDDescID," ICD编码",0))
		s ICDCode = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",ICDCodeID,0)))),3)
		;s ICDCode = $LG($G(^User.MKBTermPropertyD(ICDCodeID)),3)
		
		s SubNation = $E(ICDCode,1,5)
	
		if ($D(^User.MKBTermI("DescIndex",MKBTBRowId," "_SubNation))'=0) //存在对应国际编码
		{
			s MKBTRowId = $O(^User.MKBTermI("DescIndex",MKBTBRowId," "_SubNation,0))
			s MKBTPRowId = $O(^User.MKBTermPropertyI("DescIndex",MKBTRowId," 中文释义",0))
			s MKBTPDDesc = $LG($G(^User.MKBTermProDetailD($O(^User.MKBTermProDetailI("ProIdx",MKBTPRowId,0)))),3)
			
			if (MKBTPDDesc=ICDDesc)
			{
				s NationObj = ##class(User.MKBKLMappingDetail).%New()
				d NationObj.MKBKMDKMBaseDrSetObjectId(MBRowId)
				s NationObj.MKBKMDRowNum = RowNum
				d NationObj.MKBKMDKMBaseFieldDrSetObjectId(NationField)
				s NationObj.MKBKMDValue = SubNation
				s result1 = NationObj.%Save()
				
				if ($$$ERROR(result1))
				{
					b	
				}
				
				s FlagObj = ##class(User.MKBKLMappingDetail).%New()
				d FlagObj.MKBKMDKMBaseDrSetObjectId(MBRowId)
				s FlagObj.MKBKMDRowNum = RowNum
				d FlagObj.MKBKMDKMBaseFieldDrSetObjectId(FlagField)
				s FlagObj.MKBKMDValue = "可匹配"
				d FlagObj.%Save()
			}	
			else
			{
				s NationObj = ##class(User.MKBKLMappingDetail).%New()
				d NationObj.MKBKMDKMBaseDrSetObjectId(MBRowId)
				s NationObj.MKBKMDRowNum = RowNum
				d NationObj.MKBKMDKMBaseFieldDrSetObjectId(NationField)
				s NationObj.MKBKMDValue = SubNation
				d NationObj.%Save()
				
				s FlagObj = ##class(User.MKBKLMappingDetail).%New()
				d FlagObj.MKBKMDKMBaseDrSetObjectId(MBRowId)
				s FlagObj.MKBKMDRowNum = RowNum
				d FlagObj.MKBKMDKMBaseFieldDrSetObjectId(FlagField)
				s FlagObj.MKBKMDValue = "不匹配"
				d FlagObj.%Save()	
			}
		}
		else
		{
			s NationObj = ##class(User.MKBKLMappingDetail).%New()
			d NationObj.MKBKMDKMBaseDrSetObjectId(MBRowId)
			s NationObj.MKBKMDRowNum = RowNum
			d NationObj.MKBKMDKMBaseFieldDrSetObjectId(NationField)
			s NationObj.MKBKMDValue = SubNation
			d NationObj.%Save()
			
			s FlagObj = ##class(User.MKBKLMappingDetail).%New()
			d FlagObj.MKBKMDKMBaseDrSetObjectId(MBRowId)
			s FlagObj.MKBKMDRowNum = RowNum
			d FlagObj.MKBKMDKMBaseFieldDrSetObjectId(FlagField)
			s FlagObj.MKBKMDValue = "无匹配"
			d FlagObj.%Save()		
		}
	}
}

}

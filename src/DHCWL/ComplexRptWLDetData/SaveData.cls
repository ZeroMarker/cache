Import SQLUser

Class DHCWL.ComplexRptWLDetData.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).AddStatMode(.dim)
ClassMethod AddStatMode(ByRef dim) As %String
{
	n (dim)
	s modeCode=$g(dim("ModeCode")) 
	i modeCode="" q "统计模式代码不能为空！"
	s modeDesc=$g(dim("ModeDesc"))
	i modeDesc="" q "统计模式名称不能为空！"
	s id=..GetStatModeidByCode(modeCode)
	i id'="" q "代码不能重复！"
	s excCode=$g(dim("ModeExcCode"))
	s modeFlag=$g(dim("ModeFlag"))
	s modeObj=##class(DHCWL.ComplexRpt.StatMode).%New()
	s modeObj.StModeCode=$g(modeCode)
	s modeObj.StModeDesc=$g(modeDesc)
	s modeObj.StModeExcCode=$g(excCode)
	s modeObj.StModeFlag=$g(modeFlag)
	s modeObj.StModeUpdateDate=+$h
	s sc=modeObj.%Save()
	i sc=1  d
	.s result="ok"
	e  d
	.s result="保存失败！"
	q result
}

ClassMethod UpdateStatMode(ByRef dim) As %String
{
	n (dim)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.ComplexRpt.StatModeD(id)) "请选择要更新的行！"
	s modeCode=$g(dim("ModeCode"))
	s codeId=..GetStatModeidByCode(modeCode)
	i id'=codeId q "代码不能修改！"
	s modeDesc=$g(dim("ModeDesc"))
	i modeDesc="" q "统计模式名称不能为空！"
	s extCode=$g(dim("ModeExcCode"))
	s modeFlag=$g(dim("ModeFlag"))
	s modeObj=##class(DHCWL.ComplexRpt.StatMode).%OpenId(id)
	s modeObj.StModeCode=$g(modeCode)
	s modeObj.StModeDesc=$g(modeDesc)
	s modeObj.StModeExcCode=$g(extCode)
	s modeObj.StModeFlag=$g(modeFlag)
	s modeObj.StModeUpdateDate=+$h
	s sc=modeObj.%Save()
	i sc=1  d
	.s result="ok"
	e  d
	.s result="更新失败！"
	q result
}

ClassMethod DeleteStatMode(id) As %String
{
	n (id)
	i +id=0 q "ok"
	s modeObj=##class(DHCWL.ComplexRpt.StatMode).%OpenId(id)
	s sc=##class(DHCWL.ComplexRpt.StatMode).%DeleteId(id)
	s result="删除失败！"
	i sc=1 d
	.s result="ok"
	q result
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetStatModeidByCode("ORDDATE")
ClassMethod GetStatModeidByCode(code) As %String
{
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.ComplexRpt.StatModeI("StModeCode",code,""))
	q id
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).AddStatItem(.dim)
ClassMethod AddStatItem(ByRef dim) As %String
{
	n (dim)
	s statCode=$g(dim("StatCode")) 
	i statCode="" q "统计项代码不能为空！"
	s statDesc=$g(dim("StatDesc"))
	i statDesc="" q "统计项名称不能为空！"
	s id=..GetStatItemidByCode(statCode)
	i id'="" q "统计项代码不能重复！"
	s statType=$g(dim("StatType"))
	s statDimDr=$g(dim("StatDimDr"))
	s excCode=$g(dim("StatExcCode"))
	s statWorkLoad=$g(dim("StatWorkLoad"))
	s statFlag=$g(dim("StatFlag"))
	s statSort=$g(dim("StatSort"))
	s statObj=##class(DHCWL.ComplexRpt.StatItem).%New()
	s statObj.StCode=$g(statCode)
	s statObj.StDesc=$g(statDesc)
	s statObj.StType=$g(statType)
	s statObj.StWorkLoad=$g(statWorkLoad)
	s statObj.StDimDr=$g(statDimDr)
	s statObj.StExcCode=$g(excCode)
	s statObj.StFlag=$g(statFlag)
	s statObj.StUpdateDate=+$h
	s statObj.StStatisFlag=statSort
	s sc=statObj.%Save()
	i sc=1  d
	.s result="ok"
	e  d
	.s result="保存失败！"
	q result
}

/// %CompiledQuery  %Global  %ResultSet.SQL %SQL.Statement %XML.DataSet  %SOAP.Addressing.From
/// ;%ArrayOfObjects  %ArrayOfDataTypes  %AbstractList  %AbstractResultSet  %CacheSQLStorage
ClassMethod UpdateStatItem(ByRef dim) As %String
{
	n (dim)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.ComplexRpt.StatItemD(id)) "请选择要更新的行！"
	s statCode=$g(dim("StatCode"))
	s codeId=..GetStatItemidByCode(statCode)
	i id'=codeId q "代码不能修改！"
	s statDesc=$g(dim("StatDesc"))
	i statDesc="" q "统计项名称不能为空！"
	s statType=$g(dim("StatType"))
	s statDimDr=$g(dim("StatDimDr"))
	s extCode=$g(dim("StatExcCode"))
	s statWorkLoad=$g(dim("StatWorkLoad"))
	s statFlag=$g(dim("StatFlag"))
	s statSort=$g(dim("StatSort"))
	s statObj=##class(DHCWL.ComplexRpt.StatItem).%OpenId(id)
	s statObj.StCode=$g(statCode)
	s statObj.StDesc=$g(statDesc)
	s statObj.StType=$g(statType)
	s statObj.StWorkLoad=$g(statWorkLoad)
	s statObj.StDimDr=$g(statDimDr)
	s statObj.StExcCode=$g(extCode)
	s statObj.StFlag=$g(statFlag)
	s statObj.StUpdateDate=+$h
	s statObj.StStatisFlag=statSort
	s sc=statObj.%Save()
	i sc=1  d
	.s result="ok"
	e  d
	.s result="更新失败！"
	q result
}

ClassMethod DeleteStatItem(id) As %String
{
	n (id)
	i +id=0 q "ok"
	s modelObj=##class(DHCWL.ComplexRpt.StatItem).%OpenId(id)
	s sc=##class(DHCWL.ComplexRpt.StatItem).%DeleteId(id)
	s result="删除失败！"
	i sc=1 d
	.s result="ok"
	q result
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetStatItemidByCode("PatLoc")
ClassMethod GetStatItemidByCode(code) As %String
{
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.ComplexRpt.StatItemI("StCode",code,""))
	q id
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).AddRptDef(.rptCfgArr)
ClassMethod AddRptDef(ByRef rptCfgArr) As %String
{
	n (rptCfgArr)
	
	;s rptCfgArr("RptName")="测试2"
	;s rptCfgArr("Text")="1"
	;s condStr="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TotalPrice.TotalPrice@"
	TSTART
	s existRptName=$g(rptCfgArr("RptName"))
	s rptName=$g(rptCfgArr("Text"))
	i rptName="" q "报表名称不能为空！"
	s condStr=$g(rptCfgArr("CondStr"))
	s rptStatMode=$p(condStr,"@",1)
    s rptCol=$p(condStr,"@",2)
    s filterCon=$p(condStr,"@",3)  
    s rptCode=""
    i existRptName'="" {  //更新报表
    	&sql(update DHCWL_ComplexRptDet.ColCfg set RC_Mode=:rptStatMode,RC_ColExp=:rptCol,RC_FilterExp=:filterCon where RC_RptDr->Rpt_Name=:existRptName) 
    	i SQLCODE=0 {
	    	TCOMMIT
	    	q 0
	    }
    }
    &sql(SELECT max(ID) into:rptId FROM DHCWL_ComplexRptDet.RptCfg)
    i rptId="" s rptCode="DetRpt-1"
    e  d
    .s rptObj=##class(DHCWL.ComplexRptDet.RptCfg).%OpenId(rptId)
    .s rptCode=rptObj.RptCode
    .s seriNo=$P(rptCode,"-",2)
    .s seriNo=seriNo+1
    .s rptCode="DetRpt-"_seriNo
    
    i rptCode="" q "报表代码不能为空！"
    s id=..GetRptDefidByCode(rptCode)
	i id'="" q "报表代码不能重复！"
	&sql(SELECT ID into:rptId FROM DHCWL_ComplexRptDet.RptCfg WHERE Rpt_Name=:rptName)
    i rptId'="" q "报表名称不能重复！"     
    s rptObj=##class(DHCWL.ComplexRptDet.RptCfg).%New()
	s rptObj.RptCode=$g(rptCode)
	s rptObj.RptName=$g(rptName)
	s rptObj.RptDesc=$g(rptDesc)
	s rptObj.RptFL=$g(rptFL)
	s rptObj.RptUpdateDate=+$h
	s rptObj.RptRemark=$g(rptRemark)
	s sc=rptObj.%Save()
	i sc=0  {
		TROLLBACK
		q "保存失败"
	}
	s result=..SaveRptCfg(.rptCfgArr)	
	i (result=1){
		TROLLBACK
		q "保存失败"
	}else{
		TCOMMIT
	}
	q 0
}

/// 2016-01
/// 保存报表配置相关信息
/// d ##class(DHCWL.ComplexRptWLDetData.SaveData).SaveRptCfg("1")
ClassMethod SaveRptCfg(ByRef rptCfgArr) As %Status
{
	n (rptCfgArr)
	s condStr=$g(rptCfgArr("CondStr"))
	//s condStr="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TARI.TARIName,TotalPrice.TotalPrice,Quantity.Quantity@[{PatLoc} = 7]"
	s modeCfg=$p(condStr,"@",1)
    s colCfg=$p(condStr,"@",2)
    s filterCfg=$p(condStr,"@",3)
	
	s res=0
    &sql(SELECT max(ID) into:rptId FROM DHCWL_ComplexRptDet.RptCfg)
    q:SQLCODE'=0 1
    q:+rptId=0 1
 
	&sql(insert into DHCWL_ComplexRptDet.ColCfg (RC_RptDr,RC_Mode,RC_ColExp,RC_FilterExp) 
				values (:rptId,:modeCfg,:colCfg,:filterCfg))
	i SQLCODE'=0 s res=1
	e  s res=0
	q res
}

ClassMethod UpdateRptDef(ByRef dim) As %String
{
	n (dim)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.ComplexRpt.RptCfgD(id)) "请选择要更新的行！"
	s rptCode=$g(dim("RptCode"))
	s codeId=..GetRptDefidByCode(rptCode)
	i id'=codeId q "代码不能修改！"
	s rptName=$g(dim("RptName"))
	i rptName="" q "报表名称不能为空！"
	s rptDesc=$g(dim("RptDesc"))
	s rptFL=$g(dim("RptFL"))
	s rptRemark=$g(dim("RptRemark"))
	s rptObj=##class(DHCWL.ComplexRpt.RptCfg).%OpenId(id)
	s rptObj.RptCode=$g(rptCode)
	s rptObj.RptName=$g(rptName)
	s rptObj.RptDesc=$g(rptDesc)
	s rptObj.RptFL=$g(rptFL)
	s rptObj.RptUpdateDate=+$h
	s rptObj.RptRemark=$g(rptRemark)
	s sc=rptObj.%Save()
	i sc=1  d
	.s result="ok"
	e  d
	.s result="更新失败！"
	q result
}

ClassMethod DeleteRptDef(id) As %String
{
	n (id)
	i +id=0 q "ok"
	s modelObj=##class(DHCWL.ComplexRpt.RptCfg).%OpenId(id)
	s sc=##class(DHCWL.ComplexRpt.RptCfg).%DeleteId(id)
	s result="删除失败！"
	i sc=1 d
	.s result="ok"
	q result
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetRptDefidByCode("CWK01")
ClassMethod GetRptDefidByCode(code) As %String
{
	n (code)
	q:code="" "" 
	s id=$o(^DHCWL.ComplexRptDet.RptCfgI("RptCode",code,""))
	q id
}

/// d ##class(DHCWL.ComplexRptWLDetData.SaveData).WorkLoadInit()
/// 初始化workload字段
ClassMethod WorkLoadInit() As %String
{
	
	k ^DHCWLRptCfgInit("RptCfgWorkLoad")
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",23)="开单科室"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",3)="病人科室"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",1)="执行科室"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",25)="病人医生"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",19)="开单医生"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",4)="就诊类型"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",24)="病人病区"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",15)="数量"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",16)="费用"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",41)="核算子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",22)="收费项目"
	q
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetWorkLoadDesc(23)
/// 获得workload的字段位置对应的描述
ClassMethod GetWorkLoadDesc(pice As %String) As %String
{
	n (pice)
	q:pice="" ""
	s desc=$g(^DHCWLRptCfgInit("RptCfgWorkLoad",pice))
	q desc
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetWLDataInit()
ClassMethod GetWLDataInit() As %String
{
	s id="",str=""
	f  s id=$o(^DHCWLRptCfgInit("RptCfgWorkLoad",id)) q:id=""  d
	.s desc=$g(^DHCWLRptCfgInit("RptCfgWorkLoad",id))
	.i str="" s str="[['"_id_"','"_desc_"']"
	.e  s str=str_","_"['"_id_"','"_desc_"']"
	s str=str_"]"
	q str
}

///  生成抽象数组数据
/// hetong
/// 2015-08-07
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).InitGetWLData()
ClassMethod InitGetWLData() As %AbstractArray
{
	
	s tmpArray=##class(%ArrayOfDataTypes).%New()	
	s id="",str=""
	f  s id=$o(^DHCWLRptCfgInit("RptCfgWorkLoad",id)) q:id=""  d
	.s desc=$g(^DHCWLRptCfgInit("RptCfgWorkLoad",id))
	.d tmpArray.SetAt(desc,id)
	q tmpArray
}

///  获取抽象数组数据
/// hetong
/// 2015-08-07
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetWLData()
ClassMethod GetWLData() As %String
{
	
	s tmpArray=##class(DHCWL.ComplexRptData.SaveData).InitGetWLData()
	s i=tmpArray.Next()
	while (i)
	{	
		w tmpArray.GetAt(i),!
		s i=tmpArray.Next(i)
	}	
	q 1
}

/// d ##Class(%ResultSet).RunQuery("DHCWL.ComplexRptData.SaveData","Find","XY")
Query Find(name As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "Name:%String")
{
SELECT CTLOC_Desc
FROM CT_Loc
WHERE (%ALPHAUP CTLOC_Desc %STARTSWITH %ALPHAUP:name)
}

/// hetong
/// 2015-09-24
/// 通过统计项编码获得维度Rowid
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetDimByStatCode("PatLoc")
ClassMethod GetDimByStatCode(statCode) As %String
{
	n (statCode)
	q:statCode="" ""
	s statId=$o(^DHCWL.ComplexRpt.StatItemI("StCode",statCode,""))
 	q:statId="" ""
 	s dimCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
 	s dimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
 	q $g(dimDr)
}

/// hetong
/// 2015-12-01
/// 通过统计项编码获得描述
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetStatDescByCode("PatLoc")
ClassMethod GetStatDescByCode(statCode) As %String
{
	n (statCode)
	q:statCode="" ""
	s statId=$o(^DHCWL.ComplexRpt.StatItemI("StCode",statCode,""))
 	q:statId="" ""
 	s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3)
 	q $g(statDesc)
}

/// hetong
/// 2015-11-27
/// 通过维度编码获得维度描述
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetDimDescByCode("CTLOC")
ClassMethod GetDimDescByID(dimCode) As %String
{
	n (dimCode)
	q:dimCode="" ""
 	s dimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
 	q:dimDr="" ""
 	s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimDr),3)
 	q $g(dimDesc)
}

/// hetong
/// 2015-10-16
/// 通过统计项编码获得维度code
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetDimCodeByStatCode("PatLoc")
ClassMethod GetDimCodeByStatCode(statCode) As %String
{
	n (statCode)
	q:statCode="" ""
	s statId=$o(^DHCWL.ComplexRpt.StatItemI("StCode",statCode,""))
 	q:statId="" ""
 	s dimCode=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
 	s dimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
 	q:dimDr="" ""
 	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimDr),2)
 	q $g(dimCode)
}

/// hetong
/// 2015-09-24
/// 通过统计项编码获得维度属性Rowid
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetDimProByStatCode("PatLoc","LocCode")
ClassMethod GetDimProByStatCode(statCode, proCode = "") As %String
{
	n (statCode,proCode)
	s dimDr=..GetDimByStatCode(statCode)
 	q:$g(dimDr)="" ""
	s dimProCode="",proStr=""
	f {
		s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimProCode))
		q:$g(dimProCode)=""
		continue:(proCode'="")&&($find(","_$ZCVT(proCode,"U")_",",","_dimProCode_",")=0)
		s dimProID=""
		f {
			s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimProCode,dimProID))
			q:$g(dimProID)=""
			i proStr="" s proStr=dimProID
			e  s proStr=proStr_","_dimProID	
		}
	}
	q $g(proStr)
}

/// hetong
/// 2015-10-27
/// 通过统计项编码以及是否默认标识返回对应的维度属性编码
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetDimProCodeByStatCode("PatLoc")
ClassMethod GetDimProCodeByStatCode(statCode, flag = "Y") As %String
{
	n (statCode,flag)
	s dimDr=..GetDimByStatCode(statCode)
 	q:$g(dimDr)="" ""
	s dimProID="",proCode=""
	s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimDr,flag,dimProID))
	q:dimProID="" ""
	s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3)
	q $g(proCode)
}

/// 删除报表
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).DeleteRptCfg("测试1")
ClassMethod DeleteRptCfg(rptName As %String) As %String
{
	n (rptName)
	i rptName="" q "报表不存在！"   
	TSTART
	&sql(delete from DHCWL_ComplexRptDet.ColCfg where RC_RptDr->Rpt_Name=:rptName)
	i SQLCODE=0{
		&sql(delete FROM DHCWL_ComplexRptDet.RptCfg WHERE Rpt_Name=:rptName)
		i SQLCODE=0{
			TCOMMIT  q "ok"
		}
		else{
			TROLLBACK  q "删除报表失败！"
		}
	}else{
		TROLLBACK  q "删除报表失败！"
	}
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetRptId("测试2")
ClassMethod GetRptId(rptName As %String) As %String
{
	n (rptName) 
	s rptId=$O(^DHCWL.ComplexRptDet.RptCfgI("RptName",rptName,""))
	i rptId="" s rptId=$O(^DHCWL.ComplexRptDet.RptCfgI("RptName"," "_rptName,"")) 
	q rptId
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).IsPidExist("4284")
ClassMethod IsPidExist(pid As %String) As %String
{
	n (pid) 
	s flag=0
	s pidNo=$O(^DHCWL.ComplexRptDet.RptCfgI("RptPID",pid,""))
	i pidNo="" s pidNo=$O(^DHCWL.ComplexRptDet.RptCfgI("RptPID"," "_pid,"")) 
	i pidNo'=""  s flag=1
	q flag
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).DeleteRptCfg("测试1")
ClassMethod CreatBackgndData(rptName As %String, dataType As %String, rptCond As %String) As %String
{
	n (rptName,dataType) 
	&sql(update DHCWL_ComplexRptDet.RptCfg set Rpt_DataType=:dataType where Rpt_Name=:rptName)
	i SQLCODE'=0  q "更新生成数据类型失败！"
	q "ok"
}

/// 更新后台类型
/// Others：      
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).CreatKindsPidData("测试2","2013-07-01","2013-09-01","")
ClassMethod CreatKindsPidData(rptName As %String, startDate As %String, endDate As %String, rptCond As %String) As %String
{
	n (rptName,startDate,endDate,rptCond)
 	&sql(update DHCWL_ComplexRptDet.RptCfg set Rpt_ExecState=0,Rpt_DataType=1 where Rpt_Name=:rptName)
	i SQLCODE'=0  q 1
	q "ok"
}

/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).GetRptCond("测试2")
ClassMethod GetRptCond(rptName) As %String
{
	n (rptName)
	&sql(select RC_Mode, RC_ColExp,RC_FilterExp into:rcMode,:rcColExp,:rcFilterExp FROM DHCWL_ComplexRptDet.ColCfg where RC_RptDr->Rpt_Name=:rptName)
	q:SQLCODE'=0 ""
	s rtpCond=rcMode_"@"_rcColExp_"@"_rcFilterExp
	q rtpCond
}

/// Creator：     yw
/// CreatDate：   2016-02
/// Description： 收入明细后台数据执行 
/// Table：       DHCWL_MKPI.DHCWLMKPIData
/// Input：       rptName:报表名称,startDat:开始日期, endDate:结束日期, rptCond:报表配置信息
/// Output：      
/// Return：      feeStr:指标描述和指标汇总数据
/// Others：      
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).CreatTaskData("测试6","2013-07-01","2013-09-01","")
ClassMethod SavePid(rptName As %String) As %String
{
	n (rptName)
	
    //s startDate="2013-07-01"
 	//s endDate="2013-09-01" 
 	//s rptCond="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TotalPrice.TotalPrice@"
    s rptId=..GetRptId(rptName)
    //s rptId=44
    s rtpCfg=##class(DHCWL.ComplexRptDet.RptCfg).%OpenId(rptId)
    s pidFlag=..IsPidExist($j)
    if (pidFlag=0) {
    	s pid=$j
    }else{ 
      &sql(SELECT max(Rpt_PID)+1 into:pid FROM DHCWL_ComplexRptDet.RptCfg)
      i SQLCODE'=0 q 1
    }
    i +(rtpCfg.RptPID)=0 d
    .s rtpCfg.RptPID=pid 
    .s rtpCfg.RptExecState=0 
    s sc=rtpCfg.%Save()
	i sc=0 q "保存失败"
    q "ok"
}

/// 生成后台数据
/// w ##class(DHCWL.ComplexRptWLDetData.SaveData).CreatTaskData("测试6","2013-07-01","2013-07-02")
ClassMethod CreatTaskData(rptName As %String, startDate As %String, endDate As %String) As %String
{
	n (rptName,startDate,endDate)
	
	//s rptName="测试5"
    //s startDate="2013-07-01"
 	//s endDate="2013-09-01" 
 	//s rptCond="OrdDate@PatLoc.LocDesc,PatDoc.DocName,TotalPrice.TotalPrice@"
  

   
	s rptId=..GetRptId(rptName)
    //s rptId=44
    s rtpCfg=##class(DHCWL.ComplexRptDet.RptCfg).%OpenId(rptId)
    s pidFlag=..IsPidExist($j)
    if (pidFlag=0) {
    	s pid=$j
    }else{ 
      &sql(SELECT max(Rpt_PID)+1 into:pid FROM DHCWL_ComplexRptDet.RptCfg)
      i SQLCODE'=0 q 1
    }
    i +(rtpCfg.RptPID)=0 d
    .s rtpCfg.RptPID=pid 
    .s rtpCfg.RptExecState=0 
    s sc=rtpCfg.%Save()
	i sc=0 q "保存失败"
	;b ;00
    s queryFlag=0  
    s rptCond=..GetRptCond(rptName)
	set rs=##class(%ResultSet).%New("DHCWL.ComplexRptWLDetData.RptDetService:QueryReportData")
	set sc=rs.Execute(queryFlag,startDate,endDate,"",rptCond,"","")
	q:sc=0 1
    
    s rptId=..GetRptId(rptName)
    s rtpCfg=##class(DHCWL.ComplexRptDet.RptCfg).%OpenId(rptId)
    s rtpCfg.RptExecState=1  //执行状态初始化未完成
    s sc=rtpCfg.%Save()
	i sc=0 q "保存失败"   
	;b ;11
    q "ok"
}

}

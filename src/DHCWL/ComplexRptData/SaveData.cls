Import SQLUser

Class DHCWL.ComplexRptData.SaveData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.ComplexRptData.SaveData).AddStatMode(.dim)
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
	s oldModeCode=$lg(^DHCWL.ComplexRpt.StatModeD(id),2)
	q:oldModeCode'=modeCode "代码不能修改！"
	s modeDesc=$g(dim("ModeDesc"))
	i modeDesc="" q "统计模式名称不能为空！"
	s extCode=$g(dim("ModeExcCode"))
	s modeFlag=$g(dim("ModeFlag"))
	s oldModeFlag=$lg(^DHCWL.ComplexRpt.StatModeD(id),6)
	if ((oldModeFlag="Y")&(modeFlag="N")){
		s numValue=0
		&sql(select count(*) into :numValue from DHCWL_ComplexRpt.RowsColCfg where RC_Mode = 'OrdDate')
		if (numValue > 0){
			q "当前统计模式已经使用,不能作废"
		}
	}
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

/// w ##class(DHCWL.ComplexRptData.SaveData).GetStatModeidByCode("ORDDATE")
ClassMethod GetStatModeidByCode(code) As %String
{
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.ComplexRpt.StatModeI("StModeCode"," "_$zcvt(code,"U"),""))
	q id
}

/// w ##class(DHCWL.ComplexRptData.SaveData).AddStatItem(.dim)
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
	s statDimDr=+$g(dim("StatDimDr"))
	s excCode=$g(dim("StatExcCode"))
	s statWorkLoad=$g(dim("StatWorkLoad"))
	s statFlag=$g(dim("StatFlag"))
	s statSort=$g(dim("StatSort"))
	s statObj=##class(DHCWL.ComplexRpt.StatItem).%New()
	s statDimObj=##class(DHCWL.MKPI.MKPIDimType).%OpenId(statDimDr)
	s statObj.StCode=$g(statCode)
	s statObj.StDesc=$g(statDesc)
	s statObj.StType=$g(statType)
	s statObj.StWorkLoad=$g(statWorkLoad)
	s statObj.StDimDr=$g(statDimObj)
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
/// ;%ArrayOfObjects  %ArrayOfDataTypes  %AbstractList  %AbstractResultSet  %CacheSQLStorage  %CSP.Page
ClassMethod UpdateStatItem(ByRef dim) As %String
{
	n (dim)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.ComplexRpt.StatItemD(id)) "请选择要更新的行！"
	s statCode=$g(dim("StatCode"))
	s oldStatCode=$lg(^DHCWL.ComplexRpt.StatItemD(id),2) ;更新前code
	q:oldStatCode'=statCode "代码不能修改！"
	s statDesc=$g(dim("StatDesc"))
	i statDesc="" q "统计项名称不能为空！"
	s statType=$g(dim("StatType"))
	s statDimDr=$g(dim("StatDimDr"))
	s extCode=$g(dim("StatExcCode"))
	s statWorkLoad=$g(dim("StatWorkLoad"))
	s statFlag=$g(dim("StatFlag"))
	s statSort=$g(dim("StatSort"))
	s statObj=##class(DHCWL.ComplexRpt.StatItem).%OpenId(id)
	s statDimObj=##class(DHCWL.MKPI.MKPIDimType).%OpenId(statDimDr)
	s statObj.StCode=$g(statCode)
	s statObj.StDesc=$g(statDesc)
	s statObj.StType=$g(statType)
	s statObj.StWorkLoad=$g(statWorkLoad)
	s statObj.StDimDr=$g(statDimObj)
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

/// w ##class(DHCWL.ComplexRptData.SaveData).GetStatItemidByCode("PatLoc")
ClassMethod GetStatItemidByCode(code) As %String
{
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(code,"U"),""))
	q id
}

/// w ##class(DHCWL.ComplexRptData.SaveData).AddRptDef(.dim)
ClassMethod AddRptDef(ByRef dim) As %String
{
	n (dim)
	s rptCode=$g(dim("RptCode")) 
	i rptCode="" q "报表代码不能为空！"
	s rptName=$g(dim("RptName"))
	i rptName="" q "报表名称不能为空！"
	s id=..GetRptDefidByCode(rptCode)
	i id'="" q "报表代码不能重复！"
	s rptDesc=$g(dim("RptDesc"))
	s rptFL=$g(dim("RptFL"))
	s rptRemark=$g(dim("RptRemark"))
	s rptObj=##class(DHCWL.ComplexRpt.RptCfg).%New()
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
	.s result="保存失败！"
	q result
}

ClassMethod UpdateRptDef(ByRef dim) As %String
{
	n (dim)
	s id=$g(dim("ID"))
	q:'$d(^DHCWL.ComplexRpt.RptCfgD(id)) "请选择要更新的行！"
	s rptCode=$g(dim("RptCode"))
	s oldRptCode=$lg(^DHCWL.ComplexRpt.RptCfgD(id),2)
	i oldRptCode'=rptCode q "代码不能修改！"
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

/// w ##class(DHCWL.ComplexRptData.SaveData).GetRptDefidByCode("CWK01")
ClassMethod GetRptDefidByCode(code) As %String
{
	n (code)
	q:code="" ""
	s id=$o(^DHCWL.ComplexRpt.RptCfgI("RptCode"," "_$zcvt(code,"U"),""))
	q id
}

/// d ##class(DHCWL.ComplexRptData.SaveData).WorkLoadInit()
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
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",2)="医嘱项"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",22)="收费项"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",41)="核算子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",40)="会计子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",44)="门诊子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",42)="住院子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",43)="病案子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",9)="医嘱子分类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",45)="收费项目子类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",15)="数量"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",16)="费用"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",21)="医嘱"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",20)="账单号"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",10)="账单大类"
	s ^DHCWLRptCfgInit("RptCfgWorkLoad",11)="张单子类"
	
	q
}

/// w ##class(DHCWL.ComplexRptData.SaveData).GetWorkLoadDesc(23)
/// 获得workload的字段位置对应的描述
ClassMethod GetWorkLoadDesc(pice As %String) As %String
{
	n (pice)
	q:pice="" ""
	s desc=$g(^DHCWLRptCfgInit("RptCfgWorkLoad",pice))
	q desc
}

/// w ##class(DHCWL.ComplexRptData.SaveData).GetWLDataInit()
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
/// w ##class(DHCWL.ComplexRptData.SaveData).InitGetWLData()
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
/// w ##class(DHCWL.ComplexRptData.SaveData).GetWLData()
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
/// w ##class(DHCWL.ComplexRptData.SaveData).GetDimByStatCode("PatLoc")
ClassMethod GetDimByStatCode(statCode) As %String
{
	n (statCode)
	q:statCode="" ""
	s statId=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(statCode,"U"),""))
 	q:statId="" ""
 	s dimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
 	;s dimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
 	q $g(dimDr)
}

/// hetong
/// 2015-12-01
/// 通过统计项编码获得描述
/// w ##class(DHCWL.ComplexRptData.SaveData).GetStatDescByCode("PatLoc")
ClassMethod GetStatDescByCode(statCode) As %String
{
	n (statCode)
	q:statCode="" ""
	s statId=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(statCode,"U"),""))
 	q:statId="" ""
 	s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3)
 	q $g(statDesc)
}

/// hetong
/// 2015-11-27
/// 通过维度编码获得维度描述
/// w ##class(DHCWL.ComplexRptData.SaveData).GetDimDescByID("1")
ClassMethod GetDimDescByID(dim) As %String
{
	n (dim)
	q:dim="" ""
 	;s dimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
 	s dimDesc=$lg(^DHCWL.MKPI.MKPIDimTypeD(dim),3)
 	q $g(dimDesc)
}

/// hetong
/// 2015-10-16
/// 通过统计项编码获得维度code
/// w ##class(DHCWL.ComplexRptData.SaveData).GetDimCodeByStatCode("PatLoc")
ClassMethod GetDimCodeByStatCode(statCode) As %String
{
	n (statCode)
	q:statCode="" ""
	s statId=$o(^DHCWL.ComplexRpt.StatItemI("StCode"," "_$zcvt(statCode,"U"),""))
 	q:statId="" ""
 	s dimDr=$lg(^DHCWL.ComplexRpt.StatItemD(statId),5) ;关联维度
 	;s dimDr=$o(^DHCWL.MKPI.MKPIDimTypeI("DimTypeI",$ZCVT(dimCode,"U"),""))
 	q:dimDr="" ""
 	s dimCode=$lg(^DHCWL.MKPI.MKPIDimTypeD(dimDr),2)
 	q $g(dimCode)
}

/// hetong
/// 2015-09-24
/// 通过统计项编码获得维度属性Rowid，如果proCode为空，则返回所有维度属性的ID
/// w ##class(DHCWL.ComplexRptData.SaveData).GetDimProByStatCode("PatLoc","LocCode")
ClassMethod GetDimProByStatCode(statCode, proCode = "") As %String
{
	n (statCode,proCode)
	s dimDr=..GetDimByStatCode(statCode)
 	q:$g(dimDr)="" ""
 	s proStri="",stri=""
 	i proCode'=""{
	 	f i=1:1:$l(proCode,","){
	 		s stri=$P(proCode,",",i)
	 		i stri [ "(" s stri=$P(stri,"(",1)
	 		s $P(proStri,",",i)=stri
	 	}
 	}
	s dimProCode="",proStr=""
	f {
		s dimProCode=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimDr,dimProCode))
		q:$g(dimProCode)=""
		continue:(proStri'="")&&($find(","_$ZCVT(proStri,"U")_",",","_dimProCode_",")=0)
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
/// 如果默认维度属性为统计组，则取循环维度属性表时的第一个非统计组的维度属性作为默认维度属性
/// w ##class(DHCWL.ComplexRptData.SaveData).GetDimProCodeByStatCode("PatLoc")
ClassMethod GetDimProCodeByStatCode(statCode, flag = "Y") As %String
{
	n (statCode,flag)
	s dimDr=..GetDimByStatCode(statCode)
 	q:$g(dimDr)="" ""
	s dimProID="",proCode="",Prostring=",ItemGrp,ItemSubGrp,ItemSubGrpDesc,ItemSubGrpCode,ItemSubGrpOrder,"
	s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimDr,flag,dimProID))
	q:dimProID="" ""
	s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3) ;维度属性编码
	i $find(Prostring,","_proCode_",")'=0 {
		s dimProID=""
		f {
			s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimProDr",dimDr,"N",dimProID))
			q:dimProID=""
			s proCode=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),3) ;维度属性编码
			continue:($find(Prostring,","_proCode_",")'=0)
			q:proCode'=""
		}
	}
	q $g(proCode)
}

/// hetong
/// 2016-01-24
/// 根据类全名，搜索对应的表信息
/// d ##class(DHCWL.ComplexRptData.SaveData).GetObjsByClassName("User","DHCWorkLoad")
ClassMethod GetObjsByClassName(packageName As %String, className As %String, filter As %String = "")
{
	n (packageName,className,filter)
	s dhcwlArray=..SetObjsByClassName(packageName,className,filter)
	s str="['',''],"
	s i=dhcwlArray.Next()
	while (i)
	{	
		s propertyField=dhcwlArray.GetAt(i)
		s str=str_"['"_i_"','"_propertyField_"'],"
		s i=dhcwlArray.Next(i)
	}
	w "["_$e(str,1,$l(str)-1)_"]"
	q
}

/// hetong
/// 2016-01-24
/// 返回類的主索引名
/// w ##class(DHCWL.ComplexRptData.SaveData).getMasterIndexName("User","DHCWorkLoad")
ClassMethod GetMasterIndexName(packageName As %String, className As %String)
{
	n (packageName,className)
	s classAllName=packageName_"."_className
	s masterIndexName=""
	q:classAllName="" masterIndexName
	s dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName)
	s dsd=dcd.Storages
	s dsdCount=dsd.Count()
	f j=1:1:dsdCount {
		s sqlMapsID=dsd.GetAt(j).SQLMaps
		s sqlMapsCount=sqlMapsID.Count()
		for i=1:1:sqlMapsCount {
			s sqlMapID=sqlMapsID.GetAt(i)
			s type=sqlMapID.Type
			s indexName=sqlMapID.Name
			continue:type'="data"
			s masterIndexName=indexName
			q:type="data"
		}
	}
	q masterIndexName
}

/// hetong
/// 2016-01-24
/// 根据类全名，搜索对应的表信息，返回抽象數組數據
/// w ##class(DHCWL.ComplexRptData.SaveData).SetObjsByClassName("User","DHCWorkLoad","pat")
ClassMethod SetObjsByClassName(packageName As %String, className As %String, filter As %String = "") As %AbstractArray
{
	n (packageName,className,filter)
	s dhcwlArray=##class(%ArrayOfDataTypes).%New()
	s classAllName=packageName_"."_className
	s masterIndexName=..GetMasterIndexName(packageName,className)
	q:masterIndexName="" dhcwlArray
	s rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	d rsltSt.Execute(classAllName)
	While(rsltSt.Next()) {
		s propertyName=rsltSt.Data("Name")
		s propertyId=classAllName_"||"_propertyName
		s propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId)
		s propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		s propertyField=propObj.SqlFieldName
		s propertyColumn=propObj.SqlColumnNumber
		continue:(filter'="")&&($zcvt(propertyField,"U") '[ $zcvt(filter,"U"))
		s ssmddID=classAllName_"||SQLStorage||"_masterIndexName_"||"_propertyField
		s ssmdd=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(ssmddID)
		continue:ssmdd=""
		;s propertyNode=ssmdd.Node
		;s propertyDeli=ssmdd.Delimiter
		s propertyPiece=ssmdd.Piece
		d dhcwlArray.SetAt(propertyField,propertyPiece)
	}
	q dhcwlArray
}

/// hetong
/// 2016-01-28
/// 通过维度属性代码返回统计大组和统计子组的描述
/// w ##class(DHCWL.ComplexRptData.SaveData).GetDimProDesc("ItemSubGrpDesc(OpLoc)")
ClassMethod GetDimProDesc(dimProCode As %Text) As %String
{
	n (dimProCode)
	s ProDesc="",dimProStr=""
	q:dimProCode="" ProDesc
	i dimProCode [ "\" s dimProCode=$REPLACE(dimProCode,"\","")
	q:(dimProCode '[ "(") ProDesc
	s dimProStr=$P(dimProCode,"(",2)
	s dimProStr=$P(dimProStr,")",1)
	i $P(dimProCode,"(",1)="ItemGrp" {
		s grpId=$o(^DHCWL.CodeCfg.ItemGroupI("Code"," "_$zcvt(dimProStr,"U"),0))
		s ProDesc=$li(^DHCWL.CodeCfg.ItemGroupD(grpId),3)
	}else{
		s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_$zcvt(dimProStr,"U"),0))
		s ProDesc=$li(^DHCWL.CodeCfg.GroupD(grpId),3)
	}
	q ProDesc
}

/// Creator：     	hetong
/// CreatDate：    	2016-02-29
/// Description：	将行列条件code转化为描述
/// Table：    		DHCWL_ComplexRpt.RptCfg,DHCWL_ComplexRpt.RowsColCfg
/// Input：       	statStr：待转化的code
/// Output：  		
/// Return：  		转化后的描述    
/// Others：w ##class(DHCWL.ComplexRptData.SaveData).GetStatStrDesc("PatLoc.ItemGrp(IPCtLoc),ResLoc.ItemSubGrpDesc(OpLoc)")
ClassMethod GetStatStrDesc(statStr As %Text) As %Text
{
	n (statStr)
	s descStr=""
	s statCode=$P(statStr,".",1)
 	s dimProCode=$P(statStr,".",2)
 	q:dimProCode="" descStr
 	s statId=..GetStatItemidByCode(statCode) ;统计项ID
 	q:statId="" descStr
 	s statDesc=$lg(^DHCWL.ComplexRpt.StatItemD(statId),3) ;统计项描述
	s dimProID=..GetDimProByStatCode(statCode,dimProCode) ;维度属性Rowid
	q:dimProID="" descStr
	s dimProDesc=$lg(^DHCWL.MKPI.DimPropertyD(dimProID),5)
	i (dimProCode [ "\(")!(dimProCode [ "\)") {
		s desc=..GetDimProDesc(dimProCode)
		s descStr=statDesc_"."_dimProDesc_"("_desc_")"
	}else{
		s descStr=statDesc_"."_dimProDesc
	}
	q descStr
}

}

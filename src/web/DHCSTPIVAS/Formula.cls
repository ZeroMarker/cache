Import sqluser

/// creator:     yunhaibao
/// createdate:  2018-02-23
/// description: TPN指标以及公式维护
Class web.DHCSTPIVAS.Formula Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter AppTable [ Final ] = "PHC_DrgIngredIndex";

Parameter TableName [ Final ] = "PHC_DrgIngredIndex";

Parameter TableClassName [ Final ] = "User.PHCDrgIngredIndex";

Parameter ItmTableName [ Final ] = "PHC_DrgIngrIndItm";

Parameter ItmTableClassName [ Final ] = "User.PHCDrgIngrIndItm";

Parameter LogSign [ Final ] = "配液中心 - 药学指标公式";

/// deccription:指标列表
/// table:      User.PHCDrgIngredIndex
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Formula","PHCDrgIngredIndex")
Query PHCDrgIngredIndex(inputStr = "", HospId = "") As websys.Query(ROWSPEC = "ingIndexId,ingIndexCode,ingIndexDesc")
{
}

ClassMethod PHCDrgIngredIndexExecute(ByRef qHandle As %Binary, inputStr = "", HospId = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "Select DII_RowID as ingIndexId,DII_Code as ingIndexCode,DII_Desc as ingIndexDesc from PHC_DrgIngredIndex where DII_RowID>0"
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s ingIndexId= result.Data("ingIndexId")
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,ingIndexId,HospId) //医院级别授权
        continue:flag="N" 
        s ingIndexCode= result.Data("ingIndexCode") 
        s ingIndexDesc= result.Data("ingIndexDesc") 
        d outputPHCDrgIngredIndex
    }
    d result.Close()
    Quit $$$OK
outputPHCDrgIngredIndex
    s Data=$lb(ingIndexId,ingIndexCode,ingIndexDesc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// description: 批量保存指标
/// w ##class(web.DHCSTPIVAS.Formula).Save("^1")
ClassMethod Save(inputData, HospId = "")
{
    q:inputData="" "-1^没有需要保存的数据"
    s errCode=""
    s inputLen=$l(inputData,"!!")
    f inputI=1:1:inputLen d
    .s iData=$p(inputData,"!!",inputI)
    .q:iData=""
    .s saveRet=..SavePHCDrgIngredIndex(iData, HospId)
    .i $p(saveRet,"^",1)<0 d
    ..s saveErrInfo=$p(saveRet,"^",2)
    ..i errCode="" s errCode="-1^"_saveErrInfo
    ..e  s errCode=errCode_"</br>"_saveErrInfo
    q:errCode'="" errCode
    q 0
}

/// description: 保存指标
/// w ##class(web.DHCSTPIVAS.Formula).SavePHCDrgIngredIndex("^固定指标")
ClassMethod SavePHCDrgIngredIndex(inputStr, HospId = "")
{
    s ingIndexId=$p(inputStr,"^",1)
    s ingIndexDesc=$p(inputStr,"^",2)
    q:(ingIndexDesc = "") "-1^指标名称为空"
    s errCode=""
    s tmpId=..DescToID(ingIndexDesc, HospId)
    s:(tmpId'="")&&(tmpId'=ingIndexId) errCode="-1^指标名称已存在"
    q:errCode'="" errCode
    i ingIndexId="" d
    .&sql(insert into PHC_DrgIngredIndex (DII_Code,DII_Desc) values (:ingIndexDesc,:ingIndexDesc))
    .i SQLCODE'=0 s errCode="-1^插入失败"
    .e  d
    ..s Rowid=$p(%ROWID,$c(1))
    ..i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
    e  d
    .s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, ingIndexId)
    .&sql(update PHC_DrgIngredIndex set DII_Code=:ingIndexDesc,DII_Desc=:ingIndexDesc where DII_RowId=:ingIndexId  )
    .i SQLCODE'=0 s errCode="-1^更新失败"
    q:errCode'="" errCode
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, rowID)
	s logType = $s(ingIndexId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

    q 0_"^保存成功"
}

ClassMethod DeletePHCDrgIngredIndex(id, HospId = "")
{
    s logSignDesc=..GetDataLogSignDesc(id)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#TableName, id)

    &SQL(delete from PHC_DrgIngredIndex where DII_RowId=:id)
    i SQLCODE=0 d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,id,HospId)
	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#TableName, ..#TableClassName, ..#LogSign, id, logSignDesc, "D", delJsonStr)
    q SQLCODE
}

/// deccription:子指标列表
/// table:      User.PHCDrgIngrIndItm
/// d ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Formula","PHCDrgIngrIndItm","5")
Query PHCDrgIngrIndItm(inputStr = "") As websys.Query(ROWSPEC = "ingIndItmId,ingIndItmDesc,ingIndItmMin,ingIndItmMax,ingIndItmUom,ingIndItmFormula,ingIndItmCode,ingIndItmRemark")
{
}

ClassMethod PHCDrgIngrIndItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    k PHCDrgIngrIndItmData
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s ingIndexId=$p(inputStr,"^",1)
    q:ingIndexId="" $$$OK
    s ingIndItmId=""
    f  s ingIndItmId=$o(^PHCDII(ingIndexId,"I",ingIndItmId)) q:ingIndItmId=""  d
    .q:+ingIndItmId=0
    .s ingIndItmData=^PHCDII(ingIndexId,"I",ingIndItmId)
    .s ingIndItmRowId=ingIndexId_"||"_ingIndItmId
    .s ingIndItmDesc=$p(ingIndItmData,"^",1)
    .s ingIndItmMin=$p(ingIndItmData,"^",2)
    .s ingIndItmMax=$p(ingIndItmData,"^",3)
    .s ingIndItmUom=$p(ingIndItmData,"^",4)
    .s ingIndItmFormula=$p(ingIndItmData,"^",5)
    .s ingIndItmFormula=..FormulaLogicalToHtml(ingIndItmFormula)
    .s ingIndItmCode=$p(ingIndItmData,"^",6)
    .s ingIndItmRemark=$p(ingIndItmData,"^",7)
    .s sortIndex=ingIndItmCode
    .i sortIndex="" s sortIndex="ZZ"
    .s PHCDrgIngrIndItmData(sortIndex,ingIndItmId)=ingIndItmRowId_"^"_ingIndItmDesc_"^"_ingIndItmMin_"^"_ingIndItmMax_"^"_ingIndItmUom_"^"_ingIndItmFormula_"^"_ingIndItmCode_"^"_ingIndItmRemark
    s sortIndex=""
    f  s sortIndex=$o(PHCDrgIngrIndItmData(sortIndex)) q:sortIndex=""  d
    .s ingIndItmId=""
    .f  s ingIndItmId=$o(PHCDrgIngrIndItmData(sortIndex,ingIndItmId)) q:ingIndItmId=""  d
    ..s data=PHCDrgIngrIndItmData(sortIndex,ingIndItmId)
    ..s Data=$lfs(data,"^")
    ..s ^CacheTemp(repid,ind)=Data    
    ..s ind=ind+1
    Quit $$$OK
}

/// description: 保存指标明细
/// w ##class(web.DHCSTPIVAS.Formula).SavePHCDrgIngIndItm("^mamam")
ClassMethod SavePHCDrgIngIndItm(inputStr)
{
    s ingIndexId=$p(inputStr,"^",1)
    s ingIndItmId=$p(inputStr,"^",2)
    s ingIndItmDesc=$p(inputStr,"^",3)
    s ingIndItmMax=$p(inputStr,"^",4)
    s ingIndItmMin=$p(inputStr,"^",5)
    s ingIndItmUom=$p(inputStr,"^",6)
    s ingIndItmFormula=$p(inputStr,"^",7)
    s ingIndItmFormula=..FormulaHtmlToLogical(ingIndItmFormula)
    s ingIndItmCode=$p(inputStr,"^",8)
    s ingIndItmRemark=$p(inputStr,"^",9)
    s errCode=""
    i ingIndItmId="" d
    .&SQL(SELECT * FROM PHC_DrgIngrIndItm WHERE DIII_ParRef=:ingIndexId AND DIII_Desc=:ingIndItmDesc)
    .i SQLCODE=0 s errCode="-1^子指标名称已存在"
    .q:errCode'=""
    .s maxSub=$o(^PHCDII(ingIndexId,"I",""),-1)+1
    .&sql(
        insert into PHC_DrgIngrIndItm 
        (DIII_ParRef,DIII_ChildSub,DIII_Desc,DIII_MinIndex,DIII_MaxIndex,DIII_Uom,DIII_Formula,DIII_Code,DIII_Remark) 
        values 
        (:ingIndexId,:maxSub,:ingIndItmDesc,:ingIndItmMin,:ingIndItmMax,:ingIndItmUom,:ingIndItmFormula,:ingIndItmCode,:ingIndItmRemark)
        )
    .i SQLCODE'=0 s errCode="-1^插入失败"
    e  d
    .s oldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#ItmTableName, ingIndItmId)
    .&SQL(SELECT * FROM PHC_DrgIngrIndItm WHERE DIII_ParRef=:ingIndexId AND DIII_Desc=:ingIndItmDesc and DIII_RowID!=:ingIndItmId)
    .i SQLCODE=0 s errCode="-1^指标明细名称已存在"
    .q:errCode'=""
    .&sql(
        update PHC_DrgIngrIndItm
        set DIII_Desc=:ingIndItmDesc,DIII_MinIndex=:ingIndItmMin,DIII_MaxIndex=:ingIndItmMax,DIII_Uom=:ingIndItmUom,DIII_Formula=:ingIndItmFormula,
        DIII_Code=:ingIndItmCode,DIII_Remark=:ingIndItmRemark
        where DIII_RowID=:ingIndItmId
    )
    .i SQLCODE'=0 s errCode="-1^更新失败"
    q:errCode'="" errCode
    #; 日志
    s rowID = $g(%ROWID) 
	s logSignDesc=..GetDataLogSignDesc(+rowID)
	s newJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#ItmTableName, rowID)
	s logType = $s(ingIndItmId = "" : "A" , 1 : "U")
 	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#ItmTableName, ..#ItmTableClassName, ..#LogSign _ " - 明细", %ROWID, logSignDesc, logType, newJsonStr, $g(oldJsonStr))

    q 0_"^保存成功"
}

/// description: 删除指标明细
ClassMethod DeletePHCDrgIngIndItm(rowId)
{
    q:'$d(^PHCDII(+rowId,"I",$p(rowId,"||",2))) ""
    s logSignDesc=..GetDataLogSignDesc(rowId)
    s delJsonStr=##class(web.DHCST.Common.JsonObj).GetValue(..#ItmTableName, rowId)
    &sql(delete from PHC_DrgIngrIndItm where DIII_RowID=:rowId)
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther(..#ItmTableName, ..#ItmTableClassName, ..#LogSign _ " - 明细", rowId, logSignDesc, "D", delJsonStr)
    q SQLCODE
}

/// description: 公式转换为系统保存
/// w ##class(web.DHCSTPIVAS.Formula).FormulaHtmlToLogical("体重*总液体量")
ClassMethod FormulaHtmlToLogical(formulaHtml)
{
    s ingredId=""
    f  s ingredId=$o(^PHC("INGR",ingredId)) q:ingredId=""  d
    .s ingredDesc=$p(^PHC("INGR",ingredId),"^",2)
    .q:ingredDesc=""
    .s ingredLogical="{"_ingredId_"}"
    .s formulaHtml=$replace(formulaHtml,ingredDesc,ingredLogical)
    s formulaHtml=..FixHtmlToLogical(formulaHtml)
    q formulaHtml
}

/// description: 公式转换由系统保存至前台显示
/// w ##class(web.DHCSTPIVAS.Formula).FormulaLogicalToHtml("{5}")
ClassMethod FormulaLogicalToHtml(formulaLogical)
{
    s ingredId=""
    f  s ingredId=$o(^PHC("INGR",ingredId)) q:ingredId=""  d
    .s ingredDesc=$p(^PHC("INGR",ingredId),"^",2)
    .q:ingredDesc=""
    .s ingredLogical="{"_ingredId_"}"
    .s formulaLogical=$replace(formulaLogical,ingredLogical,ingredDesc)
    s formulaLogical=..FixLogicalToHtml(formulaLogical)
    q formulaLogical
}

/// description: 获取医嘱对应的所有指标值
/// input:       医嘱id^大指标id
/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVAS.Formula","OeoriIngrIndItm","1479||237^1")
Query OeoriIngrIndItm(inputStr = "") As websys.Query(ROWSPEC = "mOeori,ingIndItmId,ingIndItmDesc,ingIndItmMin,ingIndItmMax,ingIndItmUom,ingIndItmValue,ingIndItmOk")
{
}

ClassMethod OeoriIngrIndItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s oeori=$p(inputStr,"^",1)
    s ingIndexId=$p(inputStr,"^",2)
    q:ingIndexId="" $$$OK
    s mOeori=##class(web.DHCSTPIVAS.Common).GetMainOeori(oeori)
    s mOrd=+mOeori
    s mOrdItm=$p(mOeori,"||",2)
    q:mOrd=0 $$$OK
    s admId=$p(^OEORD(mOrd),"^",1)
    s patId=$p(^PAADM(admId),"^",1)
    s patSex=$p($g(^PAPER(patId,"ALL")),"^",7)
    s patWeight=##class(web.DHCSTPIVAS.Common).GetMrObsItm(admId,"WEIGHT","")
    i patWeight="" s patWeight=##class(web.DHCSTPIVAS.Common).GetPatWeight(admId)
    s patWeight=+patWeight  
    s patHeight=##class(web.DHCSTPIVAS.Common).GetMrObsItm(admId,"HEIGHT","")
    i patHeight="" s patHeight=##class(web.DHCSTPIVAS.Common).GetPatHeight(admId)
    s patHeight=+patHeight  
    s patArea=..CalcuSurfaceArea(patSex,patHeight,patWeight)
    s patCWeight=""
    s patData=patWeight_"^"_patHeight_"^"_patArea_"^"_patCWeight
    s doseData=..GetOeoriDoseData(mOeori)
    b //22
    s drugDataStr=doseData
    s ordItm=""
    f  s ordItm=$O(^OEORDi(0,"OEORI",mOrd,mOeori,ordItm)) Q:ordItm=""  D
    .s oeori=mOrd_"||"_ordItm
    .s doseData=..GetOeoriDoseData(oeori)
    .s drugDataStr=$s(drugDataStr="":doseData,1:drugDataStr_"!!"_doseData)
    q:drugDataStr="" $$$OK
    s calcuRet=..CalcuResult(ingIndexId, drugDataStr, patData)
    q:calcuRet="" $$$OK
    
    k OeoriIngrIndItmDATA
    // 处理排序以及需要显示的内容
    s len=$l(calcuRet,"!!")
    s i=""
    f i=1:1:len d
    .s result=$p(calcuRet,"!!",i)
    .q:result=""
    .s ingIndItmId=$p(result,"^",1)
    .s formulaValue=$p(result,"^",2)
    .q:formulaValue="" // 等于空,不显示
    .s PHCDIII=^PHCDII(+ingIndItmId,"I",+$p(ingIndItmId,"||",2))
    .s ingIndItmDesc=$p(PHCDIII,"^",1)
    .s ingIndItmMin=$p(PHCDIII,"^",2)
    .s ingIndItmMax=$p(PHCDIII,"^",3)
    .s ingIndItmUom=$p(PHCDIII,"^",4)
    .s ingIndItmFormula=$p(PHCDIII,"^",5)
    .s ingIndItmCode=$p(PHCDIII,"^",6)  // 排序用
    .s ingIndItmOk=""                   // 是否正常(1:高于,-1:低于)
    .s formulaValue=..FormatNumber(formulaValue)
    .s ingIndItmMin=..FormatNumber(ingIndItmMin)
    .s ingIndItmMax=..FormatNumber(ingIndItmMax)
    .q:formulaValue=""
    .q:+formulaValue=0
    .i (ingIndItmMin'="")&&(formulaValue'="")&&(formulaValue<ingIndItmMin) s ingIndItmOk="-1"
    .i (ingIndItmMax'="")&&(formulaValue'="")&&(formulaValue>ingIndItmMax) s ingIndItmOk="1"
    .s sortIndex=ingIndItmCode
    .s data=$lb(mOeori,ingIndItmId,ingIndItmDesc,ingIndItmMin,ingIndItmMax,ingIndItmUom,formulaValue,ingIndItmOk)
    .s OeoriIngrIndItmDATA(sortIndex,ingIndItmId)=data
    s sortIndex=""
    f  s sortIndex=$o(OeoriIngrIndItmDATA(sortIndex)) q:sortIndex=""  d
    .s id=""
    .f  s id=$o(OeoriIngrIndItmDATA(sortIndex,id)) q:id=""  d
    ..s ^CacheTemp(repid,ind)=OeoriIngrIndItmDATA(sortIndex,id)    
    ..s ind=ind+1
    Quit $$$OK
}

/// Description: 计算指标值-通用算法-仅返回结果值
/// Input:       IngIndexId(药学成分指标Id)大类
///              DrugDatas(药品信息)<医嘱项Id^数量(剂量)^单位Id!!医嘱项Id^数量(剂量)^单位Id>
///              PatData(身高^体重^体表面积^计算体重)
/// Return:      
ClassMethod CalcuResult(IngIndexId, DrugDataStr, PatData)
{
    k CalcuResultDATA
    q:IngIndexId="" ""
    q:DrugDataStr="" ""
    s patWeight=$p(PatData,"^",1)
    s patHeight=$p(PatData,"^",2)
    s patArea=$p(PatData,"^",3)
    s patCWeight=$p(PatData,"^",4)
    // 拆分药品
    s dataLen=$l(DrugDataStr,"!!")
    s dataI=""
    f dataI=1:1:dataLen d
    .s iData=$p(DrugDataStr,"!!",dataI)
    .q:iData=""
    .s arcim=$p(iData,"^",1)
    .s qty=+$p(iData,"^",2)
    .s uomId=+$p(iData,"^",3)
    .q:(qty=0)||(uomId=0)
    .s qtyML=##class(web.DHCSTPIVAS.Common).ConvertArcQtyUom(arcim,qty,uomId,"ml")
    .s CalcuResultDATA("LV")=$g(CalcuResultDATA("LV"))+qtyML    // DATA-液体量
    .s phcdf=$P($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",12)
    .q:+phcdf=0
    .s phcd=+phcdf
    .// 所有医嘱药品所含成分
    .s phcdIngr=""
    .f  s phcdIngr=$o(^PHCDINGRED(+phcd,"DI",phcdIngr)) q:phcdIngr=""  d
    ..q:+phcdIngr=0
    ..s PHCDINGREDDI=$g(^PHCDINGRED(+phcd,"DI",phcdIngr))
    ..s ingredId=$p(PHCDINGREDDI,"^",1)         // 成分Id
    ..s phcdIngrQty=$p(PHCDINGREDDI,"^",2)      // 每单位成分含量
    ..s phcdIngrUomId=$p(PHCDINGREDDI,"^",3)    // 每单位
    ..q:(+phcdIngrUomId=0)||(+phcdIngrQty=0)
    ..s phcdIngrUomDesc=$p($g(^CT("UOM",phcdIngrUomId)),"^",2)
    ..s conQty=##class(web.DHCSTPIVAS.Common).ConvertArcQtyUom(arcim,qty,uomId,phcdIngrUomDesc) // 剂量向每单位单位转换
    ..s phcdIngrQty=phcdIngrQty*conQty
    ..s CalcuResultDATA("INGR",ingredId)=$g(CalcuResultDATA("INGR",ingredId))+phcdIngrQty   // 成分总量
    s retData=""
    // 指标字典
    s ingIndItm=""
    f  s ingIndItm=$o(^PHCDII(IngIndexId,"I",ingIndItm)) q:ingIndItm=""  d
    .q:+ingIndItm=0
    .s PHCDIII=^PHCDII(IngIndexId,"I",ingIndItm)
    .s ingIndItmFormula=$p(PHCDIII,"^",5)
    .d FormatFormula    // 替换指标值
    .s formulaValue=..CalcuFormula(ingIndItmFormula)
    .s formulaValue=..FormatNumber(formulaValue)
    .s data=IngIndexId_"||"_ingIndItm_"^"_formulaValue
    .s retData=$s(retData="":data,1:retData_"!!"_data)
    q retData
FormatFormula
    s ingredId=""
    f  s ingredId=$o(^PHC("INGR",ingredId)) q:ingredId=""  d
    .q:+ingredId=0
    .s ingredLogical="{"_ingredId_"}"
    .s ingredValue=+$g(CalcuResultDATA("INGR",ingredId))
    .s ingIndItmFormula=$replace(ingIndItmFormula,ingredLogical,ingredValue)
    i ingIndItmFormula["{LV}" s ingIndItmFormula=$replace(ingIndItmFormula,"{LV}",$g(CalcuResultDATA("LV")))
    i ingIndItmFormula["{W}" s ingIndItmFormula=$replace(ingIndItmFormula,"{W}",patWeight)
    i ingIndItmFormula["{H}" s ingIndItmFormula=$replace(ingIndItmFormula,"{H}",patHeight)
    i ingIndItmFormula["{S}" s ingIndItmFormula=$replace(ingIndItmFormula,"{S}",patArea)
    i ingIndItmFormula["{CW}" s ingIndItmFormula=$replace(ingIndItmFormula,"{CW}",patCWeight)
    q
}

/// description: 公式计算
/// input:       用于x执行的公式
ClassMethod CalcuFormula(formula)
{
    s $zt="ErrCalcuFormula"
    q @formula
ErrCalcuFormula
    q ""
}

ClassMethod FormatNumber(num)
{
    i $l($p(num,".",2))>5 s num=$fn(num,"",5)
    i (num[".")&&($p(num,".",1)="") s num="0"_num
    q num
}

/// description: 获取指标列表固定指标的内容,用于前台拼接html
/// w ##class(web.DHCSTPIVAFORMULA).ConstantIngIndHtml()
ClassMethod ConstantIngIndHtml()
{
    &SQL(SELECT DII_RowId INTO :diiRowId  FROM PHC_DrgIngredIndex WHERE DII_Code like '%固定%')
    q:SQLCODE'=0 ""
    q:diiRowId="" ""
    s ingIndStr=""
    s diiiRowId=""
    f  s diiiRowId=$o(^PHCDII(diiRowId,"I",diiiRowId)) q:diiiRowId=""  d
    .q:+diiiRowId=0
    .s diiiDesc=$p(^PHCDII(diiRowId,"I",diiiRowId),"^",1)
    .i diiiDesc["-" s diiiDesc=$p(diiiDesc,"-",1)
    .q:$d(ConstantIngIndHtmlArr(diiiDesc))
    .s ConstantIngIndHtmlArr(diiiDesc)=""
    .i ingIndStr="" s ingIndStr=diiiDesc
    .e   s ingIndStr=ingIndStr_"^"_diiiDesc
    q ingIndStr
}

/// description: 固定参数
ClassMethod FixHtmlToLogical(Formula)
{
    s Formula=$replace(Formula,"体重","{W}")
    s Formula=$replace(Formula,"身高","{H}")
    s Formula=$replace(Formula,"体表面积","{S}")
    s Formula=$replace(Formula,"计算体重","{CW}")
    s Formula=$replace(Formula,"总液体量","{LV}")
    q Formula
}

/// description: 固定参数
ClassMethod FixLogicalToHtml(Formula)
{
    s Formula=$replace(Formula,"{W}","体重")
    s Formula=$replace(Formula,"{H}","身高")
    s Formula=$replace(Formula,"{S}","体表面积")
    s Formula=$replace(Formula,"{CW}","计算体重")
    s Formula=$replace(Formula,"{LV}","总液体量")
    q Formula
}

/// Description: 计算体表面积
/// 
/// w ##class(web.DHCSTPIVAS.Formula).CalcuSurfaceArea()
ClassMethod CalcuSurfaceArea(patSex, patHeight, patWeight)
{
    q:(patHeight="")||(patWeight="") ""
    s patHeight=+patHeight
    s patWeight=+patWeight
    q:(patHeight=0)||(patWeight=0) ""
    s diiRowId=$o(^PHCDII(0,"Desc","体表面积",""))
    q:diiRowId="" ""
    s formula=""
    i patSex="男" s formula=..GetFormulaByCode(diiRowId,"S02")
    e  i patSex="女" s formula=..GetFormulaByCode(diiRowId,"S03")
    i formula="" s formula=..GetFormulaByCode(diiRowId,"S01")
    q:formula="" ""
    s formula=$replace(formula,"{W}",patWeight)
    s formula=$replace(formula,"{H}",patHeight)
    s area=..CalcuFormula(formula)
    q area
}

/// Descripton: 根据代码获取公式
/// Input:      DIIRowId(指定主表Id)
ClassMethod GetFormulaByCode(DIIRowId, Code)
{
    q:DIIRowId="" ""
    s formula=""
    &SQL(
        SELECT DIII_Formula INTO :formula 
        FROM PHC_DrgIngrIndItm 
        WHERE DIII_ParRef=:DIIRowId AND DIII_Code=:Code
    )
    q formula
}

/// Description: 获取剂量,用于计算
/// w ##class(web.DHCSTPIVAS.Formula).GetOeoriDoseData("1479||237")
ClassMethod GetOeoriDoseData(Oeori)
{
    s ordId=+Oeori
    s ordItm=+$p(Oeori,"||",2)
    s arcItm=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",2)
    s arcCat=$p($g(^ARCIM(+arcItm,+$p(arcItm,"||",2),1)),"^",10)
    q:$p($g(^ARC("IC",+arcCat)),"^",7)'="R" ""
    s OEORDI2=$g(^OEORD(ordId,"I",ordItm,2))
    // 此处医嘱剂量取第一个
    s doseQty=##class(PHA.FACE.IN.Com).GetOrdDoseQty(Oeori)
    s doseQty=+doseQty
    s doseUom=$p(OEORDI2,"^",3)
    q arcItm_"^"_doseQty_"^"_doseUom
}

ClassMethod DescToID(desc, HospId)
{
    s RetRowID=""
    s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s Rowid=0
    f  s Rowid=$o(^PHCDII(0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
    .s flag="Y"
    .i BDPHospAut="Y" d
    ..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
    ..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
    .q:flag="N"
    .s RetRowID=Rowid
    q $g(RetRowID)
}

ClassMethod GetDataLogSignDesc(rowID)
{
    s parref = +rowID
	&SQL(
		SELECT DII_Desc INTO :ret
		FROM SQLUSER.PHC_DrgIngredIndex  
		WHERE %ID = :parref
	)
    #; s itm = $p(rowID , "||", 2) 
    #; if (itm '= ""){
    #;     &SQL(
    #;         SELECT DIII_Formula INTO :itmRet
    #;         FROM SQLUSER.PHC_DrgIngrIndItm  
    #;         WHERE %ID = :rowID
	#;     ) 
    #; }
	q $g(ret)
}

}

Import sqluser

/// description:一些基本信息单独更新导入的方法集合
/// others:		文件需为制表符的txt格式
Class web.DHCST.Tools.InputSomething Extends (%RegisteredObject, %XML.Adaptor, web.DHCST.StkTypeG) [ Not ProcedureBlock ]
{

/// description:本类导入统一入口
/// windows路径: w ##class(web.DHCST.Tools.InputSomething).StartInput("D:\InputIncItmBarCode.txt","InputIncItmBarCode")
/// 小机路径:    w ##class(web.DHCST.Tools.InputSomething).StartInput("/tmp/stockrec.txt","")
/// input:fileName-文件路径,inputType-导入类型
/// 
/// inputType:
/// 		   InputIncItmBarCode:药品条码(药品代码	药品条码)
ClassMethod StartInput(fileName As %String, inputType As %String) As %String
{
  n (fileName,inputType)
  s p=$zn
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,inputType,p)
  s runMethod="s runRet=##class(web.DHCST.Tools.InputSomething)."_inputType
  s cnt=0
  s successCnt=0
  s i=1
  f  s i=$O(^zTSA(p,inputType,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,inputType,i))
  .s cnt=cnt+1
  .s errmsg=""
  .tstart
  .x runMethod_"("_""""_rowStr_""""_")"
  .i $p(runRet,"|@|",1)=0 tcommit  s successCnt=successCnt+1
  .e  d
  ..w $p(runRet,"|@|",2),!
  ..tro
  k ^zTSA(p,inputType)  //删除临时global
  q cnt_"^"_successCnt
}

/// descripton: 导入药品条码
ClassMethod InputIncItmBarCode(inputData)
{
	n (inputData)
	s incicode=$p(inputData,"^",1)
	s incirowid=""
	&SQL(select inci_rowid into :incirowid from inc_itm where inci_code=:incicode)
	q:incirowid="" -1_"|@|"_incicode_"代码不存在!"
	s barcode=$p(inputData,"^",2)
	s $p(^INCI(incirowid,3),"^",9)=barcode
	q 0
}

/// description：导入基数药
/// columns：药品代码^类型(门诊/住院)^用法(描述 可空)^开单科室(描述)^取药科室(描述)^使用科室(描述)^备注
ClassMethod InputBaseMed(inputData)
{
	n (inputData)
	s inciCode=$p(inputData,"^",1)
	s baseMedType=$p(inputData,"^",2)
	s instDesc=$p(inputData,"^",3)
	s docLocDesc=$p(inputData,"^",4)
	s useLocDesc=$p(inputData,"^",5)
	s exeLocDesc=$p(inputData,"^",6)
	s remarks=$p(inputData,"^",7)
	q:baseMedType="" -1_"|@|"_inciCode_"基数类型为空！"
	q:inciCode="" -1_"|@|"_inciCode_"药品代码为空！"
	q:docLocDesc="" -1_"|@|"_inciCode_"开单科室为空"
	q:useLocDesc="" -1_"|@|"_inciCode_"取药科室为空"
	s:baseMedType="门诊" baseMedType="O"
	s:baseMedType="住院" baseMedType="I"
	q:(baseMedType'="O")&(baseMedType'="I") -1_"|@|"_inciCode_"基数类型不对！"
	s exeLocRowId="",instRowId=""
	s docLocRowId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(docLocDesc),0))
	s useLocRowId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(useLocDesc),0))
	i exeLocDesc'="" s exeLocRowId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(exeLocDesc),0))
	q:docLocRowId="" -1_"|@|"_inciCode_"开单科室不存在"
	q:useLocRowId="" -1_"|@|"_inciCode_"取药科室不存在"
	s docLocHospId="",useLocHospId="",exeLocHospId=""
	s docLocHospId=$p($g(^CTLOC(docLocRowId)),"^",22)
	s useLocHospId=$p($g(^CTLOC(useLocRowId)),"^",22)
	i exeLocRowId'="" s exeLocHospId=$p($g(^CTLOC(exeLocRowId)),"^",22)
	q:useLocHospId'=docLocHospId -1_"|@|"_inciCode_"开单科室和取药科室不属于同一个院区"
	q:(exeLocHospId'="")&(useLocHospId'=docLocHospId) -1_"|@|"_inciCode_"开单科室和使用科室不属于同一个院区"
	s hospId=$p($g(^CTLOC(docLocHospId)),"^",22)
	s incId=##class(PHA.IN.COM.Method).GetInciByCode(inciCode,hospId)
	q:incId="" -1_"|@|"_inciCode_"药品代码无效！"
	s arcItmRowId=$p($g(^INCI(incId,1)),"^",3)
	q:arcItmRowId="" -1_"|@|"_inciCode_"药品代码无效！"
	i instDesc'="" s instRowId=$o(^PHCIN(0,"Desc1",$$ALPHAUP^SSUTIL4(instDesc),0))
	
	/*s baseObj={}
	s baseObj.baseMedRowId=""
	s baseObj.baseMedType=baseMedType
	s baseObj.arcItmRowId=arcItmRowId
	s baseObj.instRowId=instRowId
	s baseObj.docLocRowId=docLocRowId
	s baseObj.useLocRowId=useLocRowId
	s baseObj.exeLocRowId=exeLocRowId
	s baseObj.remarks=remarks
	s ret=##class(PHA.OP.CfBase.OperTab).SaveBaseMed(baseObj.%ToJSON())*/
	s ret=##class(PHA.OP.CfBase.OperTab).AddBaseMed(arcItmRowId,instRowId,docLocRowId,useLocRowId,remarks,baseMedType,exeLocRowId)
	q:$p(ret,"^",1)<0 -1_"|@|"_inciCode_$p(ret,"^",2)
	q 0
}

}

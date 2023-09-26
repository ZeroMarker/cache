/// Description: 针对已经导入的药品字典,更新处方通用名以及药学项剂型
/// 可能因为上线时剂型未导入,此处用来更新
/// Attention:   V8.4 不需要此类, 此为8.3 过渡的bug修复
Class web.DHCST.Tools.UpdateGeneForm Extends %RegisteredObject
{

/// Description: 文件为基础数据导通用名,另存为制表符的txt
/// 小机:		 w ##class(web.DHCST.Tools.UpdateGeneForm).StartInput("/tmp/15药品通用名(必).txt")
/// window:		 w ##class(web.DHCST.Tools.UpdateGeneForm).StartInput("D:\tmp\15药品通用名(必).txt")
ClassMethod StartInput(fileName As %String, sub As %String = "") As %String
{
  i sub="" s sub="DHCPhcGeneric.PHCGEPHCFDr"
  s p=$zn
  s ret=##class(web.DHCST.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s i=1
  f  s i=$O(^zTSA(p,sub,i)) q:i=""  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .q:(rowStr["代码")&&(rowStr["描述")
  .q:rowStr["PHCGEPHCFDr"
  .s cnt=cnt+1
  .tstart
  .s ret=..UpdateForm(rowStr)
  .i $p(ret,"^",1)<0 d
  ..w $p(ret,"^",2)_":"_rowStr,!
  .e  d
  ..tcommit
  ..s successCnt=successCnt+1
  ..w "."
  k ^zTSA(p,sub)  //删除临时global
  q "共"_cnt_"条记录,成功更新"_successCnt_"条"
}

ClassMethod UpdateForm(rowStr)
{
	s GeneCode=$p(rowStr,"^",5)
	s FormDesc=$p(rowStr,"^",8)
	s geneId=..GetGeneIdByCode(GeneCode)
	q:$p(geneId,"^",1)<0 geneId
	q:geneId="" "-1^根据处方通用名代码取不到Id"
	s formId=..GetFormIdByDesc(FormDesc)
	q:$p(formId,"^",1)<0 formId
	q:formId="" "-1^根据剂型名称取不到Id"
	&SQL(
		UPDATE SQLUSER.DHC_PhcGeneric 
		SET PHCGE_PHCF_Dr=:formId 
		WHERE PHCGE_RowId=:geneId
	)
	q:SQLCODE'=0 "-1^更新处方通用名失败,SQLCODE:"_SQLCODE_","_$g(%msg)
	// 更新药学项剂型
	s errCode=""
	s phcd=""
	f  s phcd=$o(^PHCD(0,"Gener",geneId,phcd)) q:(phcd="")||(errCode'="")  d
	.s phcdf=phcd_"||"_1
	.&SQL(UPDATE SQLUSER.PHC_DrgForm SET PHCDF_PHCF_DR=:formId WHERE PHCDF_RowId=:phcdf)
	.i SQLCODE'=0 s errCode="-1^更新药学项剂型失败,SQLCODE:"_SQLCODE_","_$g(%msg)_",药学Id:"_phcdf
	q:errCode'="" errCode
	q 0
}

ClassMethod GetGeneIdByCode(GeneCode As %String) As %String
{
	q:GeneCode="" "-1^处方通用名代码为空"
	s geneId=""
	&SQL(SELECT PHCGE_RowId into :geneId FROM SQLUSER.PHC_Generic WHERE PHCGE_Code=:GeneCode)
	q geneId
}

ClassMethod GetFormIdByDesc(FormDesc As %String) As %String
{
	q:FormDesc="" "-1^剂型名称为空"
	s formId=""
	&SQL(SELECT PHCF_RowId into :formId FROM SQLUSER.PHC_Form WHERE PHCF_Desc=:FormDesc)
	q formId
}

}

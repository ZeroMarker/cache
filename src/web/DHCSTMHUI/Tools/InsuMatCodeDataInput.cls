Import sqluser

Class web.DHCSTMHUI.Tools.InsuMatCodeDataInput Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 导入规格型号
/// w ##class(web.DHCSTMHUI.Tools.InsuMatCodeDataInput).StartInputMatSpec("D:\GGXH.txt")		;
/// 执行导入的总入口
/// fileName: .Txt文件(Tab分隔符)
ClassMethod StartInputMatSpec(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ret=0
  s failCnt=0
  s i=1		//excel第一行英文表头,第二行中文表头
  ts
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")||(Ret'=0)  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s productId=$p(rowStr,"^",1)
  .s goodId=$p(rowStr,"^",2)
  .s spec=$p(rowStr,"^",3)
  .s model=$p(rowStr,"^",4)
  .s udi=$p(rowStr,"^",5)
  .s lsh=$p(rowStr,"^",6)
  .&sql(insert into MAT_InsuSpec (MATIS_ProductId,MATIS_GoodId,MATIS_Spec,MATIS_Model,MATIS_DICode,MATIS_SerialNo)
        values (:productId,:goodId,:spec,:model,:udi,:lsh))
  .i SQLCODE'=0 d
  ..b ;-11
  ..s Ret=-1
  .q:Ret'=0
  i Ret'=0 tro
  q:Ret'=0 Ret
  tc
  q Ret
}

/// w ##class(web.DHCSTMHUI.Tools.InsuMatCodeDataInput).StartDeleMatSpec("D:\GGXHNew.txt")		;
/// 删除单件重复数据入口
/// fileName: .Txt文件(Tab分隔符)
ClassMethod StartDeleMatSpec(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ret=0
  s failCnt=0
  s i=1		//excel第一行英文表头,第二行中文表头
  ts
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")||(Ret'=0)  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s productId=$p(rowStr,"^",1)
  .s goodId=$p(rowStr,"^",2)
  .s spec=$p(rowStr,"^",3)
  .s model=$p(rowStr,"^",4)
  .s udi=$p(rowStr,"^",5)
  .s lsh=$p(rowStr,"^",6)
  .&sql(select count(1),min(MATIS_RowId) into :num,:rowId from MAT_InsuSpec where MATIS_ProductId=:productId and MATIS_GoodId=:goodId)
  .i num>=2 d
  ..&sql(delete from MAT_InsuSpec where MATIS_RowId<>:rowId and MATIS_ProductId=:productId and MATIS_GoodId=:goodId)
  ..i SQLCODE'=0 d
  ...s Ret=-1
  .q:Ret'=0
  i Ret'=0 tro
  q:Ret'=0 Ret
  tc
  q Ret
}

/// 导入规格型号更新
/// w ##class(web.DHCSTMHUI.Tools.InsuMatCodeDataInput).StartInputMatSpecNew("D:\GGXH.txt")		;
/// fileName: .Txt文件(Tab分隔符)
ClassMethod StartInputMatSpecNew(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ret=0
  s failCnt=0
  s i=1		//excel第一行英文表头,第二行中文表头
  ts
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")||(Ret'=0)  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s productId=$p(rowStr,"^",1)
  .s goodId=$p(rowStr,"^",2)
  .s spec=$p(rowStr,"^",3)
  .s model=$p(rowStr,"^",4)
  .s udi=$p(rowStr,"^",5)
  .s lsh=$p(rowStr,"^",6)
  .s state=$p(rowStr,"^",7)
  .&sql(select count(1) from MAT_InsuSpec where MATIS_ProductId=:productId and MATIS_GoodId=:goodId)
  .&sql(insert into MAT_InsuSpec (MATIS_ProductId,MATIS_GoodId,MATIS_Spec,MATIS_Model,MATIS_DICode,MATIS_SerialNo)
        values (:productId,:goodId,:spec,:model,:udi,:lsh))
  .i SQLCODE'=0 d
  ..b ;-11
  ..s Ret=-1
  .q:Ret'=0
  i Ret'=0 tro
  q:Ret'=0 Ret
  tc
  q Ret
}

/// 导入单件
/// w ##class(web.DHCSTMHUI.Tools.InsuMatCodeDataInput).StartInputMatCode("D:\DJXX.txt")
ClassMethod StartInputMatCode(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ret=0
  s failCnt=0
  s i=1		//excel第一行英文表头,第二行中文表头
  ts
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")||(Ret'=0)  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s regcardId=$p(rowStr,"^",1)
  .q:regcardId=""
  .s productId=$p(rowStr,"^",2)
  .s inciDesc=$p(rowStr,"^",3)
  .s quality=$p(rowStr,"^",4)
  .s uomDesc=$p(rowStr,"^",5)
  .s tmpflag=$p(rowStr,"^",6)
  .s stealflag=$p(rowStr,"^",7)
  .s impflag=$p(rowStr,"^",8)
  .i tmpflag="是" d
  ..s tmpflag="Y"
  .e  d
  ..s tmpflag="N"
  .i stealflag="是" d
  ..s stealflag="Y"
  .e  d
  ..s stealflag="N"
  .i impflag="是" d
  ..s impflag="Y"
  .e  d
  ..s impflag="N"
  .s insucode=$p(rowStr,"^",9)
  .&sql(insert into MAT_InsuCode (MATIC_RegCardId,MATIC_ProductId,MATIC_GenericName,MATIC_Quality,MATIC_UomDesc,INPP_TempFlag,INPP_SterFlag,INPP_IMPFlag,MATIC_InsuCode)
        values (:regcardId,:productId,:inciDesc,:quality,:uomDesc,:tmpflag,:stealflag,:impflag,:insucode))
  .i SQLCODE'=0 d
  ..b ;-11
  ..s Ret=-1
  .q:Ret'=0
  i Ret'=0 tro
  q:Ret'=0 Ret
  tc
  q Ret
}

/// 导入注册证
/// w ##class(web.DHCSTMHUI.Tools.InsuMatCodeDataInput).StartInputRegCert("D:\ZCZ.txt")
ClassMethod StartInputRegCert(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ret=0
  s failCnt=0
  s i=1		//excel第一行英文表头,第二行中文表头
  ts
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")||(Ret'=0)  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s regcardId=$p(rowStr,"^",1)
  .s companyId=$p(rowStr,"^",2)
  .s regno=$p(rowStr,"^",3)
  .s inciDesc=$p(rowStr,"^",4)
  .s Category=$p(rowStr,"^",5)
  .s RegName=$p(rowStr,"^",6)
  .s MRCRegPerAddress=$p(rowStr,"^",7)
  .s MRCProArea=$p(rowStr,"^",8)
  .s MRCRegAgent=$p(rowStr,"^",9)
  .s MRCAgentAddress=$p(rowStr,"^",10)
  
  .s MRCSpecForm=$p(rowStr,"^",11)
  .s MRCStructure=$p(rowStr,"^",12)
  .s MRCAppliedRange=$p(rowStr,"^",13)
  
  .s MRCRemark2=$p(rowStr,"^",14)
  .s MRCRemark=$p(rowStr,"^",15)
  .s MRCApprovalDate=$p(rowStr,"^",18)
  .s:+MRCApprovalDate'>0 MRCApprovalDate=""
  
  .s:MRCApprovalDate'="" MRCApprovalDate=$zdh(MRCApprovalDate,3)
  .
  .s MRCValidUntil=$p(rowStr,"^",19)
  .s:+MRCValidUntil'>0 MRCValidUntil=""
  .s:MRCValidUntil'="" MRCValidUntil=$zdh(MRCValidUntil,3)
  .
  .s MRCProCountry=$p(rowStr,"^",20)
  .s MRManfId=$p(rowStr,"^",21)
  .&sql(insert into DHC_MatRegCert (MATIC_RegCardId,MATIC_CompanyId,MRC_No,MRC_InciDesc,MRC_Category,MRC_RegName
                    ,MRC_RegPerAddress,MRC_ProArea,MRC_RegAgent,MRC_AgentAddress,MRC_SpecForm,MRC_Structure
                    ,MRC_AppliedRange,MRC_Remark2,MRC_Remark,MRC_ApprovalDate,MRC_ValidUntil,MRC_ProCountry,MRC_ManfID)
        values (:regcardId,:companyId,:regno,:inciDesc,:Category,:RegName,
                :MRCRegPerAddress,:MRCProArea,:MRCRegAgent,:MRCAgentAddress,:MRCSpecForm,:MRCStructure,
                :MRCAppliedRange,:MRCRemark2,:MRCRemark,:MRCApprovalDate,:MRCValidUntil,:MRCProCountry,:MRManfId))
  .i SQLCODE'=0 d
  ..;s Ret=-1
  .q:Ret'=0
  i Ret'=0 tro
  q:Ret'=0 Ret
  tc
  q Ret
}

/*
/// 导入企业信息
/// w ##class(web.DHCSTMHUI.Tools.InsuMatCodeDataInput).StartInputMatVendor("D:\QYXX.txt")
ClassMethod StartInputMatVendor(fileName As %String, sub As %String = "") As %String
{
  n (fileName,sub)
  i sub="" s sub="INCITM"
  s p=$zn
  s ret=##class(web.DHCSTMHUI.Tools.LoadData).LoadData(fileName,sub,p)
  s cnt=0
  s successCnt=0
  s Ret=0
  s failCnt=0
  s i=1		//excel第一行英文表头,第二行中文表头
  ts
  f  s i=$O(^zTSA(p,sub,i)) q:(i="")||(Ret'=0)  d
  .s rowStr=$G(^zTSA(p,sub,i))
  .w rowStr,!
  .s companyId=$p(rowStr,"^",1)
  .s companyDesc=$p(rowStr,"^",2)
  .s MATICVCSocialCode=$p(rowStr,"^",3)
  .s MATICVCRegType=$p(rowStr,"^",4)
  .s MATICVCAreaCode=$p(rowStr,"^",5)
  .s MATICVCArea=$p(rowStr,"^",6)
  .s MATICVCAddress=$p(rowStr,"^",7)
  .s MATICVCPerson=$p(rowStr,"^",8)
  .s MATICVCPersonCardType=$p(rowStr,"^",9)
  .
  .s MATICVCPersonCard=$p(rowStr,"^",10)
  .s MATICVCDrugDate=$p(rowStr,"^",11)
  .s MATICVCDrugAmt=$p(rowStr,"^",12)
  .s MATICVCDrugLicArea=$p(rowStr,"^",13)
  .s MATICVCStatus=$p(rowStr,"^",14)
  .s MATICVCSCXYNo=$p(rowStr,"^",15)
  
  .s MATICVCSCXYDate=$p(rowStr,"^",16)
  .s MATICVCJYXYNo=$p(rowStr,"^",17)
  .s MATICVCJYXYDate=$p(rowStr,"^",18)
  .s MATICVCSCBANo=$p(rowStr,"^",19)
  .s MATICVCJYBANo=$p(rowStr,"^",20)
  .s MATICVCQYPerson=$p(rowStr,"^",21)
  .s MATICVCQYTel=$p(rowStr,"^",22)
  .s MATICVCQYQQ=$p(rowStr,"^",23)
  .s MATICVCQYFax=$p(rowStr,"^",24)
  
  .&sql(insert into DHC_MatRegCertVendor (MATICV_CompanyId,MATICV_CompanyName,MATICV_SocialCode,MATICV_RegType,MATICV_AreaCode
     ,MATICV_Area,MATICV_Address,MATICV_Person,MATICV_PersonCardType,MATICV_PersonCard,MATICV_DrugDate
     ,MATICV_DrugAmt,MATICV_DrugLicArea,MATICV_Status,MATICV_SCXYNo,MATICV_SCXYDate,MATICV_JYXYNo,MATICV_JYXYDate
     ,MATICV_SCBANo,MATICV_JYBANo,MATICV_QYPerson,MATICV_QYTel,MATICV_QQ,MATICV_Fax)
        values (:companyId,:companyDesc,:MATICVCSocialCode,:MATICVCRegType,:MATICVCAreaCode
        ,:MATICVCArea,:MATICVCAddress,:MATICVCPerson,:MATICVCPersonCardType,:MATICVCPersonCard,:MATICVCDrugDate
        ,:MATICVCDrugAmt,:MATICVCDrugLicArea,:MATICVCStatus,:MATICVCSCXYNo,:MATICVCSCXYDate,:MATICVCJYXYNo,:MATICVCJYXYDate
        ,:MATICVCSCBANo,:MATICVCJYBANo,:MATICVCQYPerson,:MATICVCQYTel,:MATICVCQYQQ,:MATICVCQYFax))
  .i SQLCODE'=0 d
 
  ..;s Ret=-1
  .q:Ret'=0
  i Ret'=0 tro
  q:Ret'=0 Ret
  tc
  q Ret
}
*/
}

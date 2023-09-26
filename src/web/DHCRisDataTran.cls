Class web.DHCRisDataTran Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// WARNING! Cache CDL doesn't support PROJECTION. Please review

ClassMethod DeleteByCatID(CatRowid)
{
 &sql(delete from RIS.DHCRBC_TemplDIR where DDIR_TempCat_DR=:CatRowid)
 &sql(delete from RIS.DHCRB_Template where DTL_TemplCat_DR=:CatRowid)
}

ClassMethod ExportData()
{
}

ClassMethod ImportTemplateData(Cat, HItemInfo, ItemCount, Desc, Result)
{
 s ^tmpCat=Cat
 s ^tmpHItemInfo=HItemInfo
 s ^tmpItemCount=ItemCount
 s ^tmpDesc=Desc
 s ^tmpResult=Result
 &sql(select DMC_ROWID into :CatRowid from RIS.DHCRBC_TemplCat where  DMC_Desc=:Cat)
 w !,":CatRowid"_CatRowid
 if CatRowid="" d
 .i $g(Code)="" s Code=510
 .&sql(insert into RIS.DHCRBC_TemplCat(DMC_Code,DMC_Desc)values(:Code,:Cat))
 .s Code=Code+1
 .s CatRowid=+%ROWID
 ;---------------------------------------
 s hinfo=""
 for i=ItemCount:-1:1 q:hinfo'=""  d
 .s hinfo=$p(HItemInfo,"^",i)
 .if hinfo'="" s k=i

 s GetDIRRowid="",GetPREDIRRowid=""

 for i=1:1:k-1 d
 .;s PreI=i-1
 .;s PreBody=$p(HItemInfo,"^",PreI)
 .s InBody=$p(HItemInfo,"^",i)
 .i i=1 d
 ..s GetDIRRowid=""
 ..&sql(select DDIR_RowID into :GetDIRRowid from RIS.DHCRBC_TemplDIR where DDIR_TempCat_DR=:CatRowid and DDIR_Desc=:InBody and DDIR_Level=:i)
 ..i GetDIRRowid="" d
 ...&sql(insert into RIS.DHCRBC_TemplDIR(DDIR_TempCat_DR,DDIR_Level,DDIR_Desc) values(:CatRowid,:i,:InBody))
 ...s GetDIRRowid =+%ROWID
 .else  d
 ..s GetPREDIRRowid=GetDIRRowid
 ..s GetDIRRowid=""
 ..w !,"GetDIRRowid"_GetDIRRowid
 ..&sql(select DDIR_RowID into :GetDIRRowid from RIS.DHCRBC_TemplDIR where DDIR_TempCat_DR=:CatRowid and  DDIR_TopDR=:GetPREDIRRowid and DDIR_Desc=:InBody and DDIR_Level=:i  )
 ..w !,SQLCODE_"^"_InBody
 ..i (SQLCODE=100) d
 ...&sql(insert into RIS.DHCRBC_TemplDIR(DDIR_TempCat_DR,DDIR_Level,DDIR_Desc,DDIR_TopDR) values(:CatRowid,:i,:InBody,:GetPREDIRRowid))
 ...w !,SQLCODE 
 ...s GetDIRRowid =+%ROWID

 s SICKName=$p(HItemInfo,"^",k)
 &sql(insert into RIS.DHCRB_Template (DTL_TemplDir_DR,DTL_TemplCat_DR,DTL_Name)values(:GetDIRRowid,:CatRowid,:SICKName))
 s GetTempRowid=%ROWID
 s GetTempRowid=+GetTempRowid
 s ^DHCRBTempl("Template",GetTempRowid,"SeeDescEx")=Desc
 s ^DHCRBTempl("Template",GetTempRowid,"ResultDescEx")=Result
 q SQLCODE
}

}

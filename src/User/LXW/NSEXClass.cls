Class User.LXW.NSEXClass Extends %RegisteredObject
{

// 获取指定rowid的就诊(PA_Adm)的病人(PA_PatMas)的性别描述

// creator:廉晰雯

// input: AdmRowId

// output:CTSEXDesc

// others:d ##class(User.LXW.NSEXClass).GetPAAdmSexDesc()

ClassMethod GetPAAdmSexDesc(AdmRowId As %String) As %String
{
   q:AdmRowId=" " " "  //判断是否有该rowid
   q:$d(^PAADM(AdmRowId))=0 "不存在该ID"
   s PAADMDR=$p($get(^PAADM(AdmRowId)),"^",1)
   s PAPMISexDR=$p($get(^PAPER(PAADMDR,"ALL")),"^",7)
   s CTSEXDesc=$p($get(^CT("SEX",PAPMISexDR)),"^",2)
   w "性别描述："_CTSEXDesc
}

}

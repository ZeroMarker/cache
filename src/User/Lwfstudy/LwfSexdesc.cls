Class User.Lwfstudy.LwfSexdesc Extends %RegisteredObject
{

// 创建者：刘文锋

// 编写日期：2023-9-11

// Table:PA_Adm,PA_PatMas

// input:PA_Adm的row_id

// output：无

// return:性别描述

// other:Do  ##class(User.Lwfstudy.LwfSexdesc).GetPAAdmSexDesc(1)

ClassMethod GetPAAdmSexDesc(AdmRowId As %String)
{
 //
  Set RowIdStr=$p(^PAADM(AdmRowId),"^",1)
 Set PAPatmasROwID=$p(^PAPER(RowIdStr,"ALL"),"^",7)
 Set SexDesc=$p(^CT("SEX",PAPatmasROwID),"^",2)
      w SexDesc
}

}

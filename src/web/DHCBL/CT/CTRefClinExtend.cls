/// Function: 医疗机构扩展表
/// CreateDate:2020-01-13
/// Creator:  sunfengchao
Class web.DHCBL.CT.CTRefClinExtend Extends %RegisteredObject
{

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2016-2-17
/// Creator:基础数据平台公共产品组  sunfengchao
/// Input:输入sid
/// Table:User.CTRefClinExtend
/// w ##class(web.DHCBL.CT.CTRefClinExtend).OpenData(15)
ClassMethod OpenData(id As %String) As %String
{
   s str=""
   s pobj = ##class(User.CTRefClinExtend).%OpenId(id)
   s eobj = ##class(web.Entity.CT.CTRefClinExtend).%New()
   s eobj.CTRFCRowId=id 
   s eobj.CTRFCAddress=pobj.CTRFCAddress
   s eobj.CTRFCRank=pobj.CTRFCRank
   s eobj.CTRFCChargeLevel=pobj.CTRFCChargeLevel
   s eobj.CTRFCInstitutionType=pobj.CTRFCInstitutionType 
   s eobj.CTRFCEconomyType=pobj.CTRFCEconomyType
   s eobj.CTRFCManageNature=pobj.CTRFCManageNature
   s eobj.CTRFCOwnershipForm=pobj.CTRFCOwnershipForm  
   s eobj.CTRFCSubordRelations=pobj.CTRFCSubordRelations
   s eobj.CTRFCServiceObject=pobj.CTRFCServiceObject
   s eobj.CTRFCCompetUnitName=pobj.CTRFCCompetUnitName
   s eobj.CTRFCPersonName=pobj.CTRFCPersonName
   s eobj.CTRFCCertificateType=pobj.CTRFCCertificateType
   s eobj.CTRFCCertificateCode=pobj.CTRFCCertificateCode 
   s eobj.CTRFCPersonAddress=pobj.CTRFCPersonAddress
   s eobj.CTRFCPersonPhone=pobj.CTRFCPersonPhone
   s eobj.CTRFCZipCode=pobj.CTRFCZipCode
   s eobj.CTRFCSociaCreditCode=pobj.CTRFCSociaCreditCode
   s eobj.CTRFBusinessClicenseCode=pobj.CTRFBusinessClicenseCode  
   s eobj.CTRFCInduComBusinessLicense=pobj.CTRFCInduComBusinessLicense
   s eobj.CTRFCTaxCode=pobj.CTRFCTaxCode
   s eobj.CTRFCPhaTradCertificateCode=pobj.CTRFCPhaTradCertificateCode
   s eobj.CTRFCBankCode=pobj.CTRFCBankCode
   s eobj.CTRFCBankName=pobj.CTRFCBankName
   s eobj.CTRFCBankAccount=pobj.CTRFCBankAccount
   s eobj.CTRFCConstructionArea=pobj.CTRFCConstructionArea 
   s eobj.CTRFCBusinessArea=pobj.CTRFCBusinessArea
   s eobj.CTRFCCoversArea=pobj.CTRFCCoversArea
   s eobj.CTRFCApprovedBedsNum=pobj.CTRFCApprovedBedsNum
   s eobj.CTRFCActualBedsNum=pobj.CTRFCActualBedsNum
   s eobj.CTRFCAdministDivisionCode=pobj.CTRFCAdministDivisionCode
   s eobj.CTRFCRegisteredAddress=pobj.CTRFCRegisteredAddress  
   s eobj.CTRFCRegisteredDivisionCode=pobj.CTRFCRegisteredDivisionCode
   s eobj.CTRFCInstitutionCode=pobj.CTRFCInstitutionCode
   s eobj.CTRFCInstitutionCodeNum=pobj.CTRFCInstitutionCodeNum  
   s eobj.CTRFCRegisteredCapital=pobj.CTRFCRegisteredCapital
   s eobj.CTRFCStatus=pobj.CTRFCStatus
   s eobj.CTRFCMachildLicenseCode=pobj.CTRFCMachildLicenseCode   
   s eobj.CTRFCGeneMgr=pobj.CTRFCGeneMgr
   s eobj.CTRFCParentOrgCode=pobj.CTRFCParentOrgCode
   d pobj.%Close()
   k pobj
   s str = eobj.JsonS()
   s str = "{list:["_str_"]}"
   q str
}

/// Creator： sunfengchao
/// CreatDate: 2016-2-17
/// Description：保存医疗机构信息
/// Table：User.CTRefClinExtend
/// Input：Entity
ClassMethod SaveEntity(eobj As web.Entity.CT.CTRefClinExtend) As %String
{
 
     s result=""
     if $IsObject(eobj)
     { 
       if (eobj.CTRFCRowId="")   
       {
            s obj=##class(User.CTRefClinExtend).%New()
       }
       else                  
       {
           s obj=##class(User.CTRefClinExtend).%OpenId(eobj.CTRFCRowId)
           s bobj=##class(web.Entity.CT.CTRefClinExtend).%New()
           s bobj.CTRFCRowId=eobj.CTRFCRowId 
           //s bobj.CTRFCAddress=obj.CTRFCAddress
           s bobj.CTRFCRank=obj.CTRFCRank
           s bobj.CTRFCChargeLevel=obj.CTRFCChargeLevel
           s bobj.CTRFCInstitutionType=obj.CTRFCInstitutionType 
           s bobj.CTRFCEconomyType=obj.CTRFCEconomyType
           s bobj.CTRFCManageNature=obj.CTRFCManageNature
           s bobj.CTRFCOwnershipForm=obj.CTRFCOwnershipForm  
           s bobj.CTRFCSubordRelations=obj.CTRFCSubordRelations
           s bobj.CTRFCServiceObject=obj.CTRFCServiceObject
           s bobj.CTRFCCompetUnitName=obj.CTRFCCompetUnitName
           //s bobj.CTRFCPersonName=obj.CTRFCPersonName
           s bobj.CTRFCCertificateType=obj.CTRFCCertificateType
           s bobj.CTRFCCertificateCode=obj.CTRFCCertificateCode 
           s bobj.CTRFCPersonAddress=obj.CTRFCPersonAddress
           s bobj.CTRFCPersonPhone=obj.CTRFCPersonPhone
           s bobj.CTRFCZipCode=obj.CTRFCZipCode
           //s bobj.CTRFCSociaCreditCode=obj.CTRFCSociaCreditCode
           s bobj.CTRFBusinessClicenseCode=obj.CTRFBusinessClicenseCode  
           s bobj.CTRFCInduComBusinessLicense=obj.CTRFCInduComBusinessLicense
           s bobj.CTRFCTaxCode=obj.CTRFCTaxCode
           s bobj.CTRFCPhaTradCertificateCode=obj.CTRFCPhaTradCertificateCode
           s bobj.CTRFCBankCode=obj.CTRFCBankCode
           s bobj.CTRFCBankName=obj.CTRFCBankName
           s bobj.CTRFCBankAccount=obj.CTRFCBankAccount
           s bobj.CTRFCConstructionArea=obj.CTRFCConstructionArea 
           s bobj.CTRFCBusinessArea=obj.CTRFCBusinessArea
           s bobj.CTRFCCoversArea=obj.CTRFCCoversArea
           s bobj.CTRFCApprovedBedsNum=obj.CTRFCApprovedBedsNum
           s bobj.CTRFCActualBedsNum=obj.CTRFCActualBedsNum
           s bobj.CTRFCAdministDivisionCode=obj.CTRFCAdministDivisionCode
           s bobj.CTRFCRegisteredAddress=obj.CTRFCRegisteredAddress  
           s bobj.CTRFCRegisteredDivisionCode=obj.CTRFCRegisteredDivisionCode
           s bobj.CTRFCInstitutionCode=obj.CTRFCInstitutionCode
           s bobj.CTRFCInstitutionCodeNum=obj.CTRFCInstitutionCodeNum  
           s bobj.CTRFCRegisteredCapital=obj.CTRFCRegisteredCapital
           s bobj.CTRFCStatus=obj.CTRFCStatus
           s bobj.CTRFCMachildLicenseCode=obj.CTRFCMachildLicenseCode   
           s bobj.CTRFCGeneMgr=obj.CTRFCGeneMgr
           s bobj.CTRFCParentOrgCode=obj.CTRFCParentOrgCode
       } 
       TSTART           
       //s obj.CTRFCAddress=eobj.CTRFCAddress
       s obj.CTRFCRank=eobj.CTRFCRank
       s obj.CTRFCChargeLevel=eobj.CTRFCChargeLevel
       s obj.CTRFCInstitutionType=eobj.CTRFCInstitutionType 
       s obj.CTRFCEconomyType=eobj.CTRFCEconomyType
       s obj.CTRFCManageNature=eobj.CTRFCManageNature
       s obj.CTRFCOwnershipForm=eobj.CTRFCOwnershipForm  
       s obj.CTRFCSubordRelations=eobj.CTRFCSubordRelations
       s obj.CTRFCServiceObject=eobj.CTRFCServiceObject
       s obj.CTRFCCompetUnitName=eobj.CTRFCCompetUnitName
       //s obj.CTRFCPersonName=eobj.CTRFCPersonName
       s obj.CTRFCCertificateType=eobj.CTRFCCertificateType
       s obj.CTRFCCertificateCode=eobj.CTRFCCertificateCode 
       s obj.CTRFCPersonAddress=eobj.CTRFCPersonAddress
       s obj.CTRFCPersonPhone=eobj.CTRFCPersonPhone
       s obj.CTRFCZipCode=eobj.CTRFCZipCode
       //s obj.CTRFCSociaCreditCode=eobj.CTRFCSociaCreditCode
       s obj.CTRFBusinessClicenseCode=eobj.CTRFBusinessClicenseCode  
       s obj.CTRFCInduComBusinessLicense=eobj.CTRFCInduComBusinessLicense
       s obj.CTRFCTaxCode=eobj.CTRFCTaxCode
       s obj.CTRFCPhaTradCertificateCode=eobj.CTRFCPhaTradCertificateCode
       s obj.CTRFCBankCode=eobj.CTRFCBankCode
       s obj.CTRFCBankName=eobj.CTRFCBankName
       s obj.CTRFCBankAccount=eobj.CTRFCBankAccount
       s obj.CTRFCConstructionArea=eobj.CTRFCConstructionArea 
       s obj.CTRFCBusinessArea=eobj.CTRFCBusinessArea
       s obj.CTRFCCoversArea=eobj.CTRFCCoversArea
       s obj.CTRFCApprovedBedsNum=eobj.CTRFCApprovedBedsNum
       s obj.CTRFCActualBedsNum=eobj.CTRFCActualBedsNum
       s obj.CTRFCAdministDivisionCode=eobj.CTRFCAdministDivisionCode
       s obj.CTRFCRegisteredAddress=eobj.CTRFCRegisteredAddress  
       s obj.CTRFCRegisteredDivisionCode=eobj.CTRFCRegisteredDivisionCode
       s obj.CTRFCInstitutionCode=eobj.CTRFCInstitutionCode
       s obj.CTRFCInstitutionCodeNum=eobj.CTRFCInstitutionCodeNum  
       s obj.CTRFCRegisteredCapital=eobj.CTRFCRegisteredCapital
       s obj.CTRFCStatus=eobj.CTRFCStatus
       s obj.CTRFCMachildLicenseCode=eobj.CTRFCMachildLicenseCode   
       s obj.CTRFCGeneMgr=eobj.CTRFCGeneMgr
       s obj.CTRFCParentOrgCode=eobj.CTRFCParentOrgCode
       s sc=obj.%Save() 
       d obj.%Close()
       If $$$ISOK(sc)
       {
            TCOMMIT
            s id = obj.%Id()
            s result= "{success:'true',id:'"_id_"'}"         //返回RowId
            //保存日志
            d:eobj.CTRFCRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClinExtend","User.CTRefClinExtend","医疗机构扩展表",id,eobj.CTRFCDesc,"A",eobj)
            d:eobj.CTRFCRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_RefClinExtend","User.CTRefClinExtend","医疗机构扩展表",eobj.CTRFCRowId,eobj.CTRFCDesc,"U",eobj,bobj)
           }
           else
           {
            Trollback
            s result= "{success:'false',errorinfo:'"_$SYSTEM.OBJ.DisplayError(sc)_"'}"    //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医疗机构","web.DHCBL.CT.CTRefClinExtend","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
           } 
     }
     else
     {
      s result= "{success:'false',errorinfo:'对象不存在！'}"
     }
     q result
}

}

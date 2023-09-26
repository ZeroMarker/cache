/// BDPDataTrans.InterfaceService
Class BDPDataTrans.InterfaceService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// http://10.146.9.10:57772/dthealth/web/BDPDataTrans.InterfaceService.cls?wsdl
/// Name of the WebService.
Parameter SERVICENAME = "InterfaceService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Test
Method Test() As %String [ WebMethod ]
{
    Quit "Test"
}

/// Creator：陈莹
/// CreatDate：2018—08-07
/// Description：京东方给第三方同步数据调用接口         
/// Return：xml
/// TODO:添加自变量和实施.
/// w ##class(BDPDataTrans.InterfaceService).%New().SaveRecord(^tmpInputStream,"CT_CareProv")
Method SaveRecord(InputStream As %GlobalCharacterStream, tablename As %String) As %GlobalCharacterStream [ WebMethod ]
{
    //do InputStream.Rewind()
    s ^tmpInputStream=InputStream
    //s ^tmpInputStream1=InputStream.Read()
    set ^tmpwyr("tablename")=$zt($p($h,",",2))_"_"_tablename
    set flag="",info="",rtn=""
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
 
    //1.3 科室
    if (tablename="CT_Dept")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTDept(InputStream,tablename)
    }
    //1.4 医院
    elseif (tablename="CT_Hospital")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTHospital(InputStream,tablename)
    }
    //1.5 床位
    elseif (tablename="CT_Bed")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTBed(InputStream,tablename)
    }
    //1.28 医生职称
    elseif (tablename="CT_TitleOfTech")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTTitleOfTech(InputStream,tablename)
    }
    //1.29 患者身份
    elseif (tablename="CT_PatientPosition")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTPatientPosition(InputStream,tablename)
    }
    //1.30 患者职业 
    elseif (tablename="CT_Occupation")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTOccupation(InputStream,tablename)
    }
    //1.31 患者关系
    elseif (tablename="CT_Relation")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTRelation(InputStream,tablename)
    }
    //1.32 婚姻
    elseif (tablename="CT_Marital")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTMarital(InputStream,tablename)
    }
    //1.33 性别
    elseif (tablename="CT_Sex")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTSex(InputStream,tablename)
    }
    //1.34 世界各国和地区
    elseif (tablename="CT_Country")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCountry(InputStream,tablename)
    }
    //1.35 民族 
    elseif (tablename="CT_Nation")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTNation(InputStream,tablename)
    }
    //1.36 省 
    elseif (tablename="CT_Province")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTProvince(InputStream,tablename)
    }
    //1.37 市 
    elseif (tablename="CT_City")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCity(InputStream,tablename)
    }
    //1.38 县（区）
    elseif (tablename="CT_County")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCounty(InputStream,tablename)
    }
    //1.39 频次
    elseif (tablename="CT_Freq")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTFreq(InputStream,tablename)
    }
    //1.40 用药途径
    elseif (tablename="CT_Instr")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTInstr(InputStream,tablename)
    }
    //1.41 疗程
    elseif (tablename="CT_Duration")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTDuration(InputStream,tablename)
    }
    //1.42 剂型
    elseif (tablename="CT_DoseForms")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTDoseForms(InputStream,tablename)
    }
    //1.43 宗教
    elseif (tablename="CT_Religion")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTReligion(InputStream,tablename)
    }
    //1.44 患者费别
    elseif (tablename="CT_CostCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCostCategory(InputStream,tablename)
    }
    //1.45 科室部门组
    elseif (tablename="CT_DeptDepartmentGroup")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTDeptDepartmentGroup(InputStream,tablename)
    }
    //1.46 人员
    elseif (tablename="CT_CareProv")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCareProv(InputStream,tablename)
    }
    //1.47 医护人员类型
    elseif (tablename="CT_CareProvType")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCareProvType(InputStream,tablename)
    }
    //1.69 床位类型
    elseif (tablename="CT_BedType")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTBedType(InputStream,tablename)
    }
    
    /// 1.7.收费项目字典表(CT_ChargeItem)
   elseif (tablename="CT_ChargeItem")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTChargeItem(InputStream,tablename)
   }
   /// 1.10.医嘱大类字典表(CT_Category) 
   elseif (tablename="CT_Category")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTCategory(InputStream,tablename)
   }
  
   /// 1.11.医嘱子类字典表(CT_ChildCategory)
   elseif (tablename="CT_ChildCategory")
   {
       s rtn=##class(web.DHCBL.BDP.Interface).SaveCTChildCategory(InputStream,tablename)
   } 
    /// 1.12 账单大类字典表 CT_BillCat
    elseif (tablename="CT_BillCat")
    {
         s rtn=##class(web.DHCBL.BDP.Interface).SaveCTBillCat(InputStream,tablename)
    }
     
     /// 1.13.账单子类字典表(CT_BillChildCat)
    elseif (tablename="CT_BillChildCat")
    {
         s rtn=##class(web.DHCBL.BDP.Interface).SaveCTBillChildCat(InputStream,tablename)
    } 
    /// 1.14.核算大类字典表(CT_EMChargeCategory)
    elseif (tablename="CT_EMChargeCategory")
    {
         s rtn=##class(web.DHCBL.BDP.Interface).SaveCTEMChargeCategory(InputStream,tablename)
    } 
    
   /// 1.15.核算子类字典表(CT_EMChargeChildCategory)
    elseif (tablename="CT_EMChargeChildCategory")
    {
         s rtn=##class(web.DHCBL.BDP.Interface).SaveCTEMChargeChildCategory(InputStream,tablename)
    } 
    
   /// 1.16.收费项大类字典表(CT_ChargeCategory)
    elseif (tablename="CT_ChargeCategory")
    {
         s rtn=##class(web.DHCBL.BDP.Interface).SaveCTChargeCategory(InputStream,tablename)
    } 
    /// 1.17.收费项子类字典表(CT_ChargeChildCategory)
    elseif (tablename="CT_ChargeChildCategory")
    {
         s rtn=##class(web.DHCBL.BDP.Interface).SaveCTChargeChildCategory(InputStream,tablename)
    } 
    
    /// 1.18.会计大类字典表(CT_ACChargeCategory)
    elseif (tablename="CT_ACChargeCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTACChargeCategory(InputStream,tablename)
    } 
    
    /// 1.19.会计子类字典表(CT_ACChargeChildCategory)
    elseif (tablename="CT_ACChargeChildCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTACChargeChildCategory(InputStream,tablename)
    } 
    
    ///1.20.住院大类字典表(CT_IPChargeCategory)
    elseif (tablename="CT_IPChargeCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTIPChargeCategory(InputStream,tablename)
    } 
    
    /// 1.21.住院子类字典表(CT_IPChargeChildCategory)
   elseif (tablename="CT_IPChargeChildCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTIPChargeChildCategory(InputStream,tablename)
    } 

    /// 1.22.门诊大类字典表(CT_OPChargeCategory) 
    elseif (tablename="CT_OPChargeCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTOPChargeCategory(InputStream,tablename)
    } 
    
    /// 1.23.门诊子类字典表(CT_OPChargeChildCategory)
    elseif (tablename="CT_OPChargeChildCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTOPChargeChildCategory(InputStream,tablename)
    } 
    
    /// 1.24.病案大类字典表(CT_MRChargeCategory)  
    elseif (tablename="CT_MRChargeCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTMRChargeCategory(InputStream,tablename)
    } 
    /// 1.25.病案子类字典表(CT_MRChargeChildCategory)
    elseif (tablename="CT_MRChargeChildCategory")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTMRChargeChildCategory(InputStream,tablename)
    } 
   /// 1.26.新病案大类字典表(CT_MRChargeCategoryNew)
    elseif (tablename="CT_MRChargeCategoryNew")
    {
       s rtn=##class(web.DHCBL.BDP.Interface).SaveCTMRChargeCategoryNew(InputStream,tablename)
    } 
   
   /// 1.27.新病案子类字典表(CT_MRChargeChildCategoryNew) 
    elseif (tablename="CT_MRChargeChildCategoryNew")
    {
       s rtn=##class(web.DHCBL.BDP.Interface).SaveCTMRChargeChildCategoryNew(InputStream,tablename)
    } 
   
   ///1.52.药品单位字典表(CT_PHUnit)
    elseif (tablename="CT_PHUnit")
    {
       s rtn=##class(web.DHCBL.BDP.Interface).SaveCTPHUnit(InputStream,tablename)
    }  
   /// 1.53.药品转换系数字典表(CT_PHConversionFactor)
    elseif (tablename="CT_PHConversionFactor")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTPHConversionFactor(InputStream,tablename)
    }
   /// 1.55.管制分类字典表(CT_PHCPoison)
    elseif (tablename="CT_PHCPoison")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTPHCPoison(InputStream,tablename)
    } 
   /// 1.56.邮政编码字典表(CT_Postcode)
    elseif (tablename="CT_Postcode")
    {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTPostcode(InputStream,tablename)
    } 
   /// 1.57.药品通用名字典表(CT_PHCGeneric) 
   elseif (tablename="CT_PHCGeneric")
   {
        s rtn =##class(web.DHCBL.BDP.Interface).SaveCTPHCGeneric(InputStream,tablename) 
   }
   /// 1.62.诊断字典表(CT_Diagnose)   
   elseif (tablename="CT_Diagnose")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTDiagnose(InputStream,tablename)
   } 
   /// 1.63.手术字典表(CT_Operation)
   elseif (tablename="CT_Operation")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTOperation(InputStream,tablename)
   } 
   /// 房间类型
   elseif (tablename="CT_RoomType")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTRoomType(InputStream,tablename)
   }
   ///  关联科室
   elseif (tablename="CT_DeptLinkWard")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTLocLinkLocation(InputStream,tablename)
   }
   /// 房间
   elseif (tablename="CT_Room")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTRoom(InputStream,tablename)
   }
   ///  医疗机构
   elseif (tablename="CT_RefClin")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTRefClin(InputStream,tablename)
   }
   ///  组织部门
   elseif (tablename="CT_Org")
   {
        s rtn=##class(web.DHCBL.BDP.Interface).SaveCTDepartment(InputStream,tablename)
   }else{
        s flag=-1
        s info="未订阅此字典" 
        goto response 
    }
    
    if (rtn["success:true")||(rtn["success:'true'")||(rtn["'success':'true'")
    {
        s flag=0
        s info="成功"
        goto response
    }
    else
    {
        s flag=-1
        s info=$e($p(rtn,"info:'",2),1,$l($p(rtn,"info:'",2))-2)
        s:info="" info="保存失败"
        goto response
    }
response
    s str="<Response><Header><SourceSystem/><MessageID/></Header><Body><ResultCode>"_flag_"</ResultCode><ResultContent>"_info_"</ResultContent></Body></Response>"
    set responseStream=##class(%GlobalCharacterStream).%New()
    do responseStream.Write(str)
    q responseStream
}

}

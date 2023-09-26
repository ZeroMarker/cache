/// 名称: HERP数据同步接口
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2018-08-07
Class web.DHCBL.BDP.Interface Extends %RegisteredObject
{

/// 需要查日志！
/// w ##class(web.DHCBL.BDP.Interface).Test()
ClassMethod Test()
{
    ///日期格式YYYY-MM-DD  SaveCTPHCGeneric
    set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.Write("<Request><Header><SourceSystem>30</SourceSystem><MessageID></MessageID></Header><Body><CT_HospitalList><CT_Hospital><BusinessFieldCode>00001</BusinessFieldCode><CTH_Code>Org82</CTH_Code><CTH_CodesystemCode>CT_Hospital</CTH_CodesystemCode><CTH_CreatDate></CTH_CreatDate><CTH_CreatTime></CTH_CreatTime><CTH_Desc>复旦大学附属儿科医院</CTH_Desc><CTH_EndDate></CTH_EndDate><CTH_NationalCode></CTH_NationalCode><CTH_OrganizationCode>12100000425006512Y</CTH_OrganizationCode><CTH_OriginalCode></CTH_OriginalCode><CTH_OriginalDesc></CTH_OriginalDesc><CTH_ParentCode></CTH_ParentCode><CTH_Remarks></CTH_Remarks><CTH_RowId>Org82</CTH_RowId><CTH_StartDate>1952-08-01</CTH_StartDate><CTH_Status>1</CTH_Status><CTH_UpdateDate></CTH_UpdateDate><CTH_UpdateTime></CTH_UpdateTime><CTH_UpdateUserCode>PS0000001</CTH_UpdateUserCode></CT_Hospital></CT_HospitalList></Body></Request>")
    
     
    set responseStream=##class(web.DHCBL.BDP.Interface).SaveRecord(stream,"CT_Hospital")
    
    q 1
}

/// Creator：陈莹
/// CreatDate：2018—08-07
/// Description：京东方给第三方同步数据调用接口         
/// Return：xml      
/// Others：w ##class(web.DHCBL.BDP.Interface).SaveRecord("","CT_Sex")
ClassMethod SaveRecord(InputStream As %Stream.GlobalCharacter, tablename As %String) As %Stream.GlobalCharacter
{
    s rtn="",flag="",info=""
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    if $$$ISERR(tSC)
    {
        //set responseStream=##class(%Stream.GlobalCharacter).%New()
        //do responseStream.Write("<Response><Header><SourceSystem/><MessageID/></Header><Body><ResultCode>-1</ResultCode><ResultContent>xml格式错误</ResultContent></Body></Response>")
        //q responseStream
        set flag="-1"
        set info="xml格式错误"
        goto response
    }    
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
        set ^wyr("SaveRecord",1)=tablename
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
        s rtn=..SaveCTChargeItem(InputStream,tablename)
   }
   /// 1.10.医嘱大类字典表(CT_Category) 
   elseif (tablename="CT_Category")
   {
        s rtn=..SaveCTCategory(InputStream,tablename)
   }
  
   /// 1.11.医嘱子类字典表(CT_ChildCategory)
   elseif (tablename="CT_ChildCategory")
   {
       s rtn=..SaveCTChildCategory(InputStream,tablename)
   } 
    /// 1.12 账单大类字典表 CT_BillCat
    elseif (tablename="CT_BillCat")
    {
         s rtn=..SaveCTBillCat(InputStream,tablename)
    }
     
     /// 1.13.账单子类字典表(CT_BillChildCat)
    elseif (tablename="CT_BillChildCat")
    {
         s rtn=..SaveCTBillChildCat(InputStream,tablename)
    } 
    /// 1.14.核算大类字典表(CT_EMChargeCategory)
    elseif (tablename="CT_EMChargeCategory")
    {
         s rtn=..SaveCTEMChargeCategory(InputStream,tablename)
    } 
    
   /// 1.15.核算子类字典表(CT_EMChargeChildCategory)
    elseif (tablename="CT_EMChargeChildCategory")
    {
         s rtn=..SaveCTEMChargeChildCategory(InputStream,tablename)
    } 
    
   /// 1.16.收费项大类字典表(CT_ChargeCategory)
    elseif (tablename="CT_ChargeCategory")
    {
         s rtn=..SaveCTChargeCategory(InputStream,tablename)
    } 
    /// 1.17.收费项子类字典表(CT_ChargeChildCategory)
    elseif (tablename="CT_ChargeChildCategory")
    {
         s rtn=..SaveCTChargeChildCategory(InputStream,tablename)
    } 
    
    /// 1.18.会计大类字典表(CT_ACChargeCategory)
    elseif (tablename="CT_ACChargeCategory")
    {
        s rtn=..SaveCTACChargeCategory(InputStream,tablename)
    } 
    
    /// 1.19.会计子类字典表(CT_ACChargeChildCategory)
    elseif (tablename="CT_ACChargeChildCategory")
    {
        s rtn=..SaveCTACChargeChildCategory(InputStream,tablename)
    } 
    
    ///1.20.住院大类字典表(CT_IPChargeCategory)
    elseif (tablename="CT_IPChargeCategory")
    {
        s rtn=..SaveCTIPChargeCategory(InputStream,tablename)
    } 
    
    /// 1.21.住院子类字典表(CT_IPChargeChildCategory)
   elseif (tablename="CT_IPChargeChildCategory")
    {
        s rtn=..SaveCTIPChargeChildCategory(InputStream,tablename)
    } 

    /// 1.22.门诊大类字典表(CT_OPChargeCategory) 
    elseif (tablename="CT_OPChargeCategory")
    {
        s rtn=..SaveCTOPChargeCategory(InputStream,tablename)
    } 
    
    /// 1.23.门诊子类字典表(CT_OPChargeChildCategory)
    elseif (tablename="CT_OPChargeChildCategory")
    {
        s rtn=..SaveCTOPChargeChildCategory(InputStream,tablename)
    } 
    
    /// 1.24.病案大类字典表(CT_MRChargeCategory)  
    elseif (tablename="CT_MRChargeCategory")
    {
        s rtn=..SaveCTMRChargeCategory(InputStream,tablename)
    } 
    /// 1.25.病案子类字典表(CT_MRChargeChildCategory)
    elseif (tablename="CT_MRChargeChildCategory")
    {
        s rtn=..SaveCTMRChargeChildCategory(InputStream,tablename)
    } 
   /// 1.26.新病案大类字典表(CT_MRChargeCategoryNew)
    elseif (tablename="CT_MRChargeCategoryNew")
    {
       s rtn=..SaveCTMRChargeCategoryNew(InputStream,tablename)
    } 
   
   /// 1.27.新病案子类字典表(CT_MRChargeChildCategoryNew) 
    elseif (tablename="CT_MRChargeChildCategoryNew")
    {
       s rtn=..SaveCTMRChargeChildCategoryNew(InputStream,tablename)
    } 
   
   ///1.52.药品单位字典表(CT_PHUnit)
    elseif (tablename="CT_PHUnit")
    {
       s rtn=..SaveCTPHUnit(InputStream,tablename)
    }  
   /// 1.53.药品转换系数字典表(CT_PHConversionFactor)
    elseif (tablename="CT_PHConversionFactor")
    {
        s rtn=..SaveCTPHConversionFactor(InputStream,tablename)
    }
   /// 1.55.管制分类字典表(CT_PHCPoison)
    elseif (tablename="CT_PHCPoison")
    {
        s rtn=..SaveCTPHCPoison(InputStream,tablename)
    } 
   /// 1.56.邮政编码字典表(CT_Postcode)
    elseif (tablename="CT_Postcode")
    {
        s rtn=..SaveCTPostcode(InputStream,tablename)
    } 
   /// 1.57.药品通用名字典表(CT_PHCGeneric) 
    
   elseif (tablename="CT_PHCGeneric")
   { 
        s rtn =..SaveCTPHCGeneric(InputStream,tablename) 
   }
   /// 1.62.诊断字典表(CT_Diagnose)   
   elseif (tablename="CT_Diagnose")
   {
        s rtn=..SaveCTDiagnose(InputStream,tablename)
   } 
   /// 1.63.手术字典表(CT_Operation)
   elseif (tablename="CT_Operation")
   {
        s rtn=..SaveCTOperation(InputStream,tablename)
   } 
    /// 房间类型
   elseif (tablename="CT_RoomType")
   {
        s rtn=..SaveCTRoomType(InputStream,tablename)
   }
   /// 房间
   elseif (tablename="CT_Room")
   {
        s rtn=..SaveCTRoom(InputStream,tablename)
   }
   ///  收费项目价格表
   elseif (tablename="CT_ChargeItemPrice")
   {
        s rtn=..SaveCTChargeItemPrice(InputStream,tablename)
   }
   ///  关联科室
   elseif (tablename="CT_DeptLinkWard")
   {
        s rtn=..SaveCTLocLinkLocation(InputStream,tablename)
   }
   ///  医疗机构
   elseif (tablename="CT_RefClin")
   {
        s rtn=..SaveCTRefClin(InputStream,tablename)
   }
   ///  组织部门
   elseif (tablename="CT_Org")
   {
        s rtn=..SaveCTDepartment(InputStream,tablename)
   }
   else{
        s flag=-1
        s info="未订阅此字典" 
        goto response 
    }
    b
    if (rtn["success:true")||(rtn["success:'true'")||(rtn["'success':'true'")
    {
        s flag=0
        s info="成功"
        goto response
        
    }
    else
    {
        s flag=-1
        //s info=$e($p(rtn,"info:'",2),1,$l($p(rtn,"info:'",2))-2)
        set info=tablename
        goto response
    }
response
    s str="<Response><Header><SourceSystem/><MessageID/></Header><Body><ResultCode>"_flag_"</ResultCode><ResultContent>"_info_"</ResultContent></Body></Response>"
    set responseStream=##class(%Stream.GlobalCharacter).%New()
    do responseStream.Write(str)
    q responseStream
}

/// Creator：陈莹
/// CreatDate: 2018-08-07
/// Description：设置session信息
/// d ##class(web.DHCBL.BDP.Interface).GetSession("pharmacy")
ClassMethod GetSession(UpdateUserCode) As %String
{
    q:UpdateUserCode="" ""
    q:$$ALPHAUP^SSUTIL4(UpdateUserCode)="" ""
    try
    {
        s UpdateUserDR=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),0))
        s %session.Data("LOGON.USERID")=UpdateUserDR
        s %session.Data("LOGON.USERCODE")=UpdateUserCode
        s:UpdateUserDR'="" %session.Data("LOGON.USERNAME")=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
        s %session.Data("REMOTE_ADDR")="127.0.0.1"  ///第三方服务器IP
    }
    catch(e)
    {
        
    }
    q ""
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：房间类型信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTBed(stream,tablename)
ClassMethod SaveCTRoomType(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTRT_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PACRoomType).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTRT_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMTCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.ROOMTRowId=$o(^PAC("ROOMT",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.ROOMTCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTRT_Desc","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMTDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTRT_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMTDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTRT_EndDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMTDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.PACRoomType).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：房间信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTBed(stream,tablename)
ClassMethod SaveCTRoom(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PACRoom).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.ROOMRowID=$o(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(dataeobj.ROOMCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ROOMDateTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_TypeCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        s ROOMRoomTypeDR=$tr(fieldValue,$c(0),"")
        set:ROOMRoomTypeDR'="" dataeobj.ROOMRoomTypeDR=$o(^PAC("ROOMT",0,"Code",$$ALPHAUP^SSUTIL4(ROOMRoomTypeDR),0))
    }
    s result=##class(web.DHCBL.CT.PACRoom).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：床位信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTBed(stream,tablename)
ClassMethod SaveCTBed(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PACBed).%New() 
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_WardCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        s WardCode=$tr(fieldValue,$c(0),"")
        set dataeobj.BEDWARDParRef=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(WardCode),0))
    }
    q:dataeobj.BEDWARDParRef="" "{success:'false',errorinfo:'所属病区不存在！'}"
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        s BEDRowID=0
        for
        {
            s BEDRowID=$o(^PAWARD(dataeobj.BEDWARDParRef,"BED",BEDRowID))
            q:BEDRowID=""
            s BEDCode=$p(^PAWARD(dataeobj.BEDWARDParRef,"BED",BEDRowID),"^",1)
            s:BEDCode=dataeobj.BEDCode dataeobj.BEDWARDParRef=BEDRowID_"||"_dataeobj.BEDRowID q
        }
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_BedType","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set BedType=$tr(fieldValue,$c(0),"")
        set dataeobj.BEDBedTypeDR=$o(^PAC("BEDTP",0,"BEDTP_Code",$$ALPHAUP^SSUTIL4(BedType),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_RoomCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set RoomCode=$tr(fieldValue,$c(0),"")
        set dataeobj.BEDRoomDR=$o(^PAROOM(0,"ROOM_Code",$$ALPHAUP^SSUTIL4(RoomCode),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTB_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=..SaveEntityPACBed(dataeobj)
    q result
}

/// Creator：李森
/// CreatDate: 2013-6-3
/// Updater：2016年5月10日 - 蔡昊哲
/// Description：保存修改床位的内容
/// Table：User.PACBed
/// Input：web.Entity.CT.PACBed 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACBed).SaveEntity()
ClassMethod SaveEntityPACBed(eobj As web.Entity.CT.PACBed) As %String
{
    s $zt="ERROE"
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.BEDRcFlag="" eobj.BEDRcFlag="N"
        ;s:eobj.BEDDateFrom'="" eobj.BEDDateFrom=$zdh(eobj.BEDDateFrom,15) //转换日期
        ;s:eobj.BEDDateTo'="" eobj.BEDDateTo=$zdh(eobj.BEDDateTo,15)      //转换日期
        s:eobj.BEDDateFrom'="" eobj.BEDDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDDateFrom)
        s:eobj.BEDDateTo'="" eobj.BEDDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDDateTo)     
        s:eobj.BEDDateFrom="" eobj.BEDDateFrom=+$h
        
        if (eobj.BEDRowID'="") && (eobj.BEDRcFlag'="Y") //判断禁用床位时，床位上是否有患者
        {
            s flagAdm=##class(web.DHCBL.CT.PACBed).IfCanDelete(eobj.BEDRowID)
            if (flagAdm=1)
            {
                q "{success:'false',errorinfo:'该床位上有病人，无法修改状态！'}"   
            }
        }
        if (eobj.BEDRoomDR'="") && (eobj.BEDWARDParRef'="") //判断选择房间时，是否被其他病区使用
        {
            s flagroom=##class(web.DHCBL.CT.PACBed).ReflagRoom(eobj.BEDRoomDR,eobj.BEDWARDParRef)
            if ($p(flagroom,"^",1)=1)
            {
                q "{success:'false',errorinfo:'该房间已被"_$p(flagroom,"^",2)_"病区使用！'}"  
            }
        }
        
        s flag=##class(web.DHCBL.CT.PACBed).Validate(eobj.BEDWARDParRef,eobj.BEDRowID,eobj.BEDCode)  //调用重复验证20130603LISEN
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.BEDRowID="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.PACBed).%New(eobj.BEDWARDParRef)
                
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.PACBed).%OpenId(eobj.BEDRowID)
                s bobj=##class(web.Entity.CT.PACBed).%New(eobj.BEDWARDParRef)
                s bobj.BEDRowID=eobj.BEDRowID
                s bobj.BEDWARDParRef=obj.BEDWARDParRef.%Id()
                s bobj.BEDCode = obj.BEDCode
                s:obj.BEDBedTypeDR'="" bobj.BEDBedTypeDR = obj.BEDBedTypeDR.%Id()

                s:obj'="" bobj.BEDRoomDR = obj.BEDRoomDR.%Id()
                s:obj.BEDRoomDR'="" bobj.BEDRoomDR = obj.BEDRoomDR.%Id()
                s:obj.BEDRoomDR'="" bobj.BEDRoomDR = obj.BEDRoomDR.%Id()
                s bobj.BEDRcFlag = obj.BEDRcFlag
                s bobj.BEDPositionLeft = obj.BEDPositionLeft
                s bobj.BEDPositionTop = obj.BEDPositionTop
                s bobj.BEDPositionHeight = obj.BEDPositionHeight
                s bobj.BEDPositionWidth = obj.BEDPositionWidth
                s bobj.BEDDateFrom = obj.BEDDateFrom
                s bobj.BEDDateTo = obj.BEDDateTo
                

                //s eobj.BEDRowID = id
                //s ParRef=$p(id,"||",1)
                //s rowid=$p(id,"||",2)
                //s bobj.EXPLocDR= $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",1)
                //s bobj.EXPBedOrganizationDR = $p($g(^PAWARDA(ParRef,"BED",rowid,"EXP",1)),"^",2)
                s ParRef=$p(eobj.BEDRowID,"||",1)
                s rowid=$p(eobj.BEDRowID,"||",2)
                s vfalg = $d(^PAWARDA(ParRef,"BED",rowid,"EXP"))
                if (vfalg = 0)  //扩展表是否存在该数据,不存在的情况
                {
                }
                else 
                {
                    s BedExprowid = $o(^PAWARDA(ParRef,"BED",rowid,"EXP",0))
                    //s ^tmpc1=BedExprowid
                    s Expobj=##class(User.PACBedExp).%OpenId(eobj.BEDRowID_"||"_BedExprowid)
                    //d Expobj.EXPParRefSetObjectId(eobj.BEDRowID)
                    s:Expobj.EXPBedOrganizationDR'="" bobj.EXPBedOrganizationDR = Expobj.EXPBedOrganizationDR.%Id()  //.EXPBedOrganization.%Id()
                    s:Expobj.EXPLocDR'="" bobj.EXPLocDR = Expobj.EXPLocDR.%Id() 
                    //s ^tmpc2=bobj.EXPLocDR
                    d Expobj.%Close()
                }
            }
            Ts
            d:eobj.BEDWARDParRef'="" obj.BEDWARDParRefSetObjectId(eobj.BEDWARDParRef)
            s obj.BEDCode = eobj.BEDCode
            d obj.BEDBedTypeDRSetObjectId(eobj.BEDBedTypeDR)
            d obj.BEDRoomDRSetObjectId(eobj.BEDRoomDR)
        
            
            s obj.BEDDateFrom = eobj.BEDDateFrom
            s obj.BEDDateTo = eobj.BEDDateTo
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                if (eobj.BEDRowID="")&((eobj.EXPLocDR'="")||(eobj.EXPBedOrganizationDR'=""))  //如果RowId未赋值则增加
                {
                    s Expobj=##class(User.PACBedExp).%New(id)
                    d Expobj.EXPParRefSetObjectId(id)
                    d Expobj.EXPLocDRSetObjectId(eobj.EXPLocDR)
                    d Expobj.EXPBedOrganizationDRSetObjectId(eobj.EXPBedOrganizationDR)
                    s Expsc=Expobj.%Save()  
                    d Expobj.%Close()
                }
                elseif (eobj.BEDRowID'="")
                {
                    //s BEDRowID=rowid
                    s ParRef=$p(eobj.BEDRowID,"||",1)
                    s rowid=$p(eobj.BEDRowID,"||",2)
                    s vfalg = $d(^PAWARDA(ParRef,"BED",rowid,"EXP"))
                    if (vfalg = 0)  //扩展表是否存在该数据,不存在的情况
                    {
                        s Expobj=##class(User.PACBedExp).%New(eobj.BEDRowID)
                        d Expobj.EXPParRefSetObjectId(eobj.BEDRowID)
                        d Expobj.EXPLocDRSetObjectId(eobj.EXPLocDR)
                        d Expobj.EXPBedOrganizationDRSetObjectId(eobj.EXPBedOrganizationDR)
                        s Expsc=Expobj.%Save()  
                        d Expobj.%Close()
                    }
                    else 
                    {
                        s BedExprowid = $o(^PAWARDA(ParRef,"BED",rowid,"EXP",0))
                        s Expobj=##class(User.PACBedExp).%OpenId(eobj.BEDRowID_"||"_BedExprowid)
                        //d Expobj.EXPParRefSetObjectId(eobj.BEDRowID)
                        d Expobj.EXPLocDRSetObjectId(eobj.EXPLocDR)
                        ;d Expobj.EXPBedOrganizationDRSetObjectId(eobj.EXPBedOrganizationDR)
                        s Expsc=Expobj.%Save()  
                        d Expobj.%Close()
                    }               
    
                }
                
                
                s result= "{success:'true',id:'"_id_"'}"         //返回RowId
                d:eobj.BEDRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Bed","User.PACBed","床位",eobj.BEDRowID,eobj.BEDCode,"U",eobj,bobj)
                d:eobj.BEDRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Bed","User.PACBed","床位",id,eobj.BEDCode,"A",eobj)
            }
            else
            {
                Trollback
                s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位","web.DHCBL.CT.PACBed","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS") 
            }
        }
    }
    else
    {
        s result= "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位","web.DHCBL.CT.PACBed","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：床位类型信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTBedType(stream,tablename)
ClassMethod SaveCTBedType(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBT_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PACBedType).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBT_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDTPCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.BEDTPRowId=$o(^PAC("BEDTP",0,"BEDTP_Code",$$ALPHAUP^SSUTIL4(dataeobj.BEDTPCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBT_Desc","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDTPDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBT_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDTPDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBT_EndDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.BEDTPDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=..SaveEntityPACBedType(dataeobj)
    q result
}

/// Function:对床位类型的添加，修改操作
/// CreateDate:2018-9-5
/// Creator:基础数据平台公共产品组 ybq
/// Input:输入sid
/// Tables:PAC_BedType
ClassMethod SaveEntityPACBedType(eobj As web.Entity.CT.PACBedType) As %String
{
    ;n (eobj)
    s $zt="ERROR"
    s result=""
    if $IsObject(eobj)
    {
        ;s:eobj.BEDTPDateFrom'="" eobj.BEDTPDateFrom=$zdh(eobj.BEDTPDateFrom,15)  //转换日期
        ;s:eobj.BEDTPDateTo'="" eobj.BEDTPDateTo=$zdh(eobj.BEDTPDateTo,15)      //转换日期
        s:eobj.BEDTPDateFrom'="" eobj.BEDTPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDTPDateFrom)  //转换日期
        s:eobj.BEDTPDateTo'="" eobj.BEDTPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BEDTPDateTo)      //转换日期
        s:eobj.BEDTPDateFrom="" eobj.BEDTPDateFrom=+$h
        //如果RowId未赋值则增加
        if (eobj.BEDTPRowId="")       
        {
            //RowId未赋值,增加
            s obj=##class(User.PACBedType).%New()   
            s obj.BEDTPCode =eobj.BEDTPCode
            s obj.BEDTPDesc = eobj.BEDTPDesc
            s obj.BEDTPDateFrom=eobj.BEDTPDateFrom
            s obj.BEDTPDateTo=eobj.BEDTPDateTo
            
            Tstart
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedType","User.PACBedType","床位类型",id,eobj.BEDTPDesc,"A",eobj)
                s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型","web.DHCBL.CT.PACBedType","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS") 
            }   
        }
            //如果RowId已赋值则修改
        else                           
        {
            //RowId已存在,修改
            s obj=##class(User.PACBedType).%OpenId(eobj.BEDTPRowId)
            s bobj=##class(web.Entity.CT.PACBedType).%New()
            s bobj.BEDTPRowId=eobj.BEDTPRowId
            s bobj.BEDTPCode =obj.BEDTPCode
            s bobj.BEDTPDesc = obj.BEDTPDesc
            s bobj.BEDTPDateFrom=obj.BEDTPDateFrom
            s bobj.BEDTPDateTo=obj.BEDTPDateTo
            //判断空值,前台js也已添加空值判断allowblank
            s obj.BEDTPCode =eobj.BEDTPCode
            s obj.BEDTPDesc = eobj.BEDTPDesc
            s obj.BEDTPDateFrom=eobj.BEDTPDateFrom
            s obj.BEDTPDateTo=eobj.BEDTPDateTo
            Tstart
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BedType","User.PACBedType","床位类型",id,eobj.BEDTPDesc,"U",eobj,bobj)
                s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型","web.DHCBL.CT.PACBedType","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS") 
            }                       
        }   
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
ERROR
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("床位类型","web.DHCBL.CT.PACBedType","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：医护人员类型信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTBedType(stream,tablename)
ClassMethod SaveCTCareProvType(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCPT_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTCarPrvTp).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCPT_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCPTCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTCPTRowId=$o(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTCPTCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCPT_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCPTDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCPT_StartDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCPTDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCPT_EndDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCPTDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=..SaveEntityCTCarPrvTp(dataeobj)
    q result
}

/// Creator：蔡昊哲
/// CreatDate: 2012-7-18
/// Description：保存修改医护人员类型的内容
/// Table：User.CTCarPrvTp
/// Input：web.Entity.CT.CTCarPrvTp 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntityCTCarPrvTp(eobj As web.Entity.CT.CTCarPrvTp) As %String
{
    ; d ##class(web.DHCBL.CT.CTCarPrvTp).SaveEntity()
    s $zt="EEROE"
    s result=""
    s flag=##class(web.DHCBL.CT.CTCarPrvTp).FormValidate(eobj.CTCPTRowId,eobj.CTCPTCode,eobj.CTCPTDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if $IsObject(eobj)
        {   
            s:eobj.CTCPTDateFrom="" eobj.CTCPTDateFrom=+$h
            ;s:eobj.CTCPTDateFrom'="" eobj.CTCPTDateFrom=$zdh(eobj.CTCPTDateFrom,15)  //转换日期
            ;s:eobj.CTCPTDateTo'="" eobj.CTCPTDateTo=$zdh(eobj.CTCPTDateTo,15)      //转换日期
            s:eobj.CTCPTDateFrom'="" eobj.CTCPTDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCPTDateFrom)  //转换日期
            s:eobj.CTCPTDateTo'="" eobj.CTCPTDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTCPTDateTo)      //转换日期
            if ((eobj.CTCPTRowId)="")                             //如果RowId未赋值则增加
            {   
                s obj=##class(User.CTCarPrvTp).%New()
            }
            else                                                  //如果RowId已赋值则修改
            {
                s obj=##class(User.CTCarPrvTp).%OpenId(eobj.CTCPTRowId)
                s bobj=##class(web.Entity.CT.CTCarPrvTp).%New()
                s bobj.CTCPTRowId = eobj.CTCPTRowId
                s bobj.CTCPTCode = obj.CTCPTCode                      //修改代码
                s bobj.CTCPTDesc = obj.CTCPTDesc                      //修改描述
                s bobj.CTCPTDateFrom = obj.CTCPTDateFrom
                s bobj.CTCPTDateTo = obj.CTCPTDateTo
            
            }   
            s obj.CTCPTCode = eobj.CTCPTCode                      //修改代码
            s obj.CTCPTDesc = eobj.CTCPTDesc                      //修改描述
            i eobj.CTCPTDateFrom'=""
            {
                s obj.CTCPTDateFrom = eobj.CTCPTDateFrom  //修改开始日期
            }
            else
            {
                s obj.CTCPTDateFrom = ""
            }
            i eobj.CTCPTDateTo'=""
            {
                s obj.CTCPTDateTo = eobj.CTCPTDateTo      //修改结束日期     
            }
            else
            {
                s obj.CTCPTDateTo = ""
            }   
            
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                d:eobj.CTCPTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CarPrvTp","User.CTCarPrvTp","医护人员类型",eobj.CTCPTRowId,eobj.CTCPTDesc,"U",eobj,bobj)
                d:eobj.CTCPTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CarPrvTp","User.CTCarPrvTp","医护人员类型",id,eobj.CTCPTDesc,"A",eobj)
                s result = "{success:'true',id:'"_id_"'}"         //返回RowId
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员类型","web.DHCBL.CT.CTCarPrvTp","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
            }
        
        }
        else
        {
            s result = "{success:'false',errorinfo:'对象不存在！'}"
        }
    }   
    q result
EEROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员类型","web.DHCBL.CT.CTCarPrvTp","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：人员信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTCareProv(stream,"CT_CareProv")
ClassMethod SaveCTCareProv(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    s ^TMPInputStream3=InputStream
    s ^TMPInputStream4=InputStream.Read()
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTCareProv).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_JobNumber","text()",.tRes)     //   改为解析 CTCP_JobNumber  原来为 CTCP_Code           
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTPCPCode=$tr(fieldValue,$c(0),"") /// 工号
        //获取rowid
        set dataeobj.CTPCPRowId1=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTPCPCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_Name","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTPCPDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTPCPDateActiveFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_EndDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTPCPDateActiveTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_TitleOfTechCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set Title=$tr(fieldValue,$c(0),"")
        set:Title'="" dataeobj.CTPCPTitleDR=$o(^CT("TTL",0,"Code",$$ALPHAUP^SSUTIL4(Title),0))
    }
    ///
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_CareProvTypeCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CareProvType=$tr(fieldValue,$c(0),"")
        set:CareProvType'="" dataeobj.CTPCPCarPrvTpDR=$o(^CT("CPT",0,"Code",$$ALPHAUP^SSUTIL4(CareProvType),0))
    }
    //// CTCP_DeptHierarchyCode 科室部门    原来为 CTCP_DeptCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_DeptHierarchyCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set Dept=$tr(fieldValue,$c(0),"")
        set:Dept'="" dataeobj.CTLOCDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(Dept),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_Spell","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set Spell=$tr(fieldValue,$c(0),"")
        set dataeobj.CTPCPOtherName=$tr(fieldValue,$c(0),"")
    }
    //获取主数据人员字典表的状态字段 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCP_Status","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set Status=$tr(fieldValue,$c(0),"")
        if Status="1" set dataeobj.CTPCPActiveFlag="Y"
        else  set dataeobj.CTPCPActiveFlag="N"
    }  
    s result=..SaveEntity(dataeobj) 
    s ^TMPresult="care:"_result
    q result
}

/// Creator：ybq
/// CreatDate: 2018-9-4
/// Description：保存修改
/// Table：User.CTCareProv
/// Input：RowId1, Code, Desc, CTPCPCarPrvTpDR, ActiveFlag, InternalType
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCareProv) As %String
{
    ;s $zt="EEROE"
    
    
    Set UpdateDate=$p($h,",",1)       //修改日期
    Set UpdateTime=$p($h,",",2)       //修改时间
    Set:$d(%session)>0 UpdateUserDR=%session.Get("LOGON.USERID")             //修改人
    Set:$d(%session)=0 UpdateUserDR=""
    s result=""
    s:eobj.CTPCPActiveFlag="" eobj.CTPCPActiveFlag="N"
    s:eobj.CTPCPHICApproved="" eobj.CTPCPHICApproved="N"
    s:eobj.CTPCPSpecialistYN="" eobj.CTPCPSpecialistYN="N"
    s:eobj.CTPCPSurgeon="" eobj.CTPCPSurgeon="N"
    s:eobj.CTPCPAnaesthetist="" eobj.CTPCPAnaesthetist="N"
    s eobj.CTPCPUpdateDate = UpdateDate
    s eobj.CTPCPUpdateTime = UpdateTime
    s eobj.CTPCPUpdateUserDR = UpdateUserDR
    ;s:eobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom=$zdh(eobj.CTPCPDateActiveFrom,15) 
    ;s:eobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo=$zdh(eobj.CTPCPDateActiveTo,15)     
    s:eobj.CTPCPDateActiveFrom'="" eobj.CTPCPDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPCPDateActiveFrom)
    s:eobj.CTPCPDateActiveTo'="" eobj.CTPCPDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPCPDateActiveTo)   
    s:eobj.CTPCPDateActiveFrom="" eobj.CTPCPDateActiveFrom=+$h
    
    s flag=##class(web.DHCBL.CT.CTCareProv).FormValidate(eobj.CTPCPRowId1,eobj.CTPCPCode)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        Ts
        if ((eobj.CTPCPRowId1)="")
        {   
            s obj=##class(User.CTCareProv).%New()
        }
        //修改
        else 
        {
            s obj=##class(User.CTCareProv).%OpenId(eobj.CTPCPRowId1)
            
            ; bobj创建一个对象，用于记录原始数据
            s bobj=##class(web.Entity.CT.CTCareProv).%New()
            s bobj.CTPCPRowId1 = eobj.CTPCPRowId1
            s bobj.CTPCPDesc = obj.CTPCPDesc
            s bobj.CTPCPCode = obj.CTPCPCode
            ;s bobj.CTPCPId=obj.CTPCPId
            s bobj.CTPCPOtherName=obj.CTPCPOtherName
            ;s bobj.CTPCPUnit=obj.CTPCPUnit
            ;s bobj.CTPCPTextOne = obj.CTPCPTextOne
            ;s bobj.CTPCPTextTwo = obj.CTPCPTextTwo
            if $IsObject(obj.CTPCPCarPrvTpDR)
            {
                s bobj.CTPCPCarPrvTpDR = obj.CTPCPCarPrvTpDR.%Id() 
            }       
            s bobj.CTPCPActiveFlag =obj.CTPCPActiveFlag
            ;s bobj.CTPCPHICApproved =obj.CTPCPHICApproved
            s bobj.CTPCPSpecialistYN = obj.CTPCPSpecialistYN
            s bobj.CTPCPDateActiveFrom = obj.CTPCPDateActiveFrom
            s bobj.CTPCPDateActiveTo = bobj.CTPCPDateActiveTo
            s bobj.CTPCPSurgeon = obj.CTPCPSurgeon
            s bobj.CTPCPAnaesthetist = obj.CTPCPAnaesthetist
            s bobj.CTPCPUpdateDate = obj.CTPCPUpdateDate
            s bobj.CTPCPUpdateTime = obj.CTPCPUpdateTime
            if $IsObject(obj.CTPCPUpdateUserDR)
            {
                s bobj.CTPCPUpdateUserDR = obj.CTPCPUpdateUserDR.%Id()
            }
            if $IsObject(obj.CTPCPCTLOCDR)
            {
                s bobj.CTLOCDR = obj.CTPCPCTLOCDR.%Id()
            }       
            if $IsObject(obj.CTPCPTitleDR)
            {
                s bobj.CTPCPTitleDR = obj.CTPCPTitleDR.%Id()
            }       
        }
        s obj.CTPCPCode = eobj.CTPCPCode
        s obj.CTPCPDesc = eobj.CTPCPDesc
        s obj.CTPCPOtherName = ##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CTPCPDesc) 
        ;s obj.CTPCPTextOne = eobj.CTPCPTextOne
        ;s obj.CTPCPTextTwo = eobj.CTPCPTextTwo
        d obj.CTPCPCarPrvTpDRSetObjectId(eobj.CTPCPCarPrvTpDR)
        ;d obj.CTPCPSpecDRSetObjectId(eobj.CTPCPSpecDR) 
        d obj.CTPCPCTLOCDRSetObjectId(eobj.CTLOCDR)  //caihaozhe - 2016年4月27日
        //  主数据同步医护人员信息如果原本医护人员职称不是科主任才更新，如果是则不更新CD540 add by xieyejian 20190801 start/end
        if obj.CTPCPTitleDR.TTLCode'="027"{
            d obj.CTPCPTitleDRSetObjectId(eobj.CTPCPTitleDR) //gss-2016/08/18
        }
        i eobj.CTPCPActiveFlag="Y"
        {
            s obj.CTPCPActiveFlag ="Y"
        }
        else
        {
            s obj.CTPCPActiveFlag = "N"
        }
        s obj.CTPCPSpecialistYN = "N"
		s obj.CTPCPSurgeon = "N"
		s obj.CTPCPAnaesthetist = "N"
        i eobj.CTPCPDateActiveFrom'=""
        {
            s obj.CTPCPDateActiveFrom = eobj.CTPCPDateActiveFrom
        }
        else
        {
            s obj.CTPCPDateActiveFrom =""
        }
        i eobj.CTPCPDateActiveTo'=""
        {
            s obj.CTPCPDateActiveTo = eobj.CTPCPDateActiveTo
        }
        else
        {
            s obj.CTPCPDateActiveTo =""
        }
        
        i UpdateDate'=""
        {
            s obj.CTPCPUpdateDate = UpdateDate
        }
        i UpdateTime'=""
        {
            s obj.CTPCPUpdateTime = UpdateTime
        }
        i UpdateUserDR'=""
        {
            d obj.CTPCPUpdateUserDRSetObjectId(UpdateUserDR)
            s eobj.CTPCPUpdateUserDR = UpdateUserDR
        }
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            Tc
            s id = obj.%Id()
            if (eobj.CTPCPRowId1="")
            {
                d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"A",eobj)
                if (eobj.CTLOCDR'="")
                {
                    ;s cobj=##class(User.CTCareProv).%OpenId(id)            
                    s iobj=##class(User.RBResource).%New()
                    s iobj.RESCode = eobj.CTPCPCode 
                    s iobj.RESDesc = eobj.CTPCPDesc
                    d iobj.RESCTLOCDRSetObjectId(eobj.CTLOCDR)
                    d iobj.RESCTPCPDRSetObjectId(id)
                    s iobj.RESAdmittingRights="Y"
                    s iobj.RESMRRequest = "N"   
                    s iobj.RESDateActiveFrom=eobj.CTPCPDateActiveFrom           
                    s Robj = ##class(web.Entity.CT.RBResource).%New()
                    s Robj.RESCode = eobj.CTPCPCode 
                    s Robj.RESDesc = eobj.CTPCPDesc
                    s Robj.RESMRRequest ="N"
                    s Robj.RESAdmittingRights ="Y"  
                    s Robj.RESCTPCPDR = id
                    s Robj.RESCTLOCDR = eobj.CTLOCDR
                    s isc=iobj.%Save()
                    d iobj.%Close()
                                    
                    If $$$ISOK(isc){                    
                        s iid = iobj.%Id()
                        s CTLOCDesc=$p($g(^CTLOC(eobj.CTLOCDR)),"^",2)
                        s CTPCPDesc=$p($g(^CTPCP(id,1)),"^",2)
                        s result= "{success:'true',id:'"_id_"'}"         //返回RowId
                        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("RB_Resource","User.RBResource","医护人员关联科室",iid,CTPCPDesc_"->"_CTLOCDesc,"A",Robj)
                    
                    }else{
                        Trollback
                        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员关联科室","web.DHCBL.CT.RBResource","SaveEntity",Robj)
                        s ^ERRORLOGINFO(logid)=$zconvert(isc,"O","JS") 
                    }
                    ;q result
                }   
            }
            else
            {
                d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CareProv","User.CTCareProv","医护人员",id,eobj.CTPCPDesc,"U",eobj,bobj)
                s CTLOCDR=0
                for  
                {               
                s CTLOCDR=$o(^RB("RES",0,"CTPCP",eobj.CTPCPRowId1,CTLOCDR)) q:CTLOCDR=""
                    s iid=$o(^RB("RES",0,"CTPCP",eobj.CTPCPRowId1,CTLOCDR,0))
                    s iobj=##class(User.RBResource).%OpenId(iid)
                    s iobj.RESDesc = eobj.CTPCPDesc
                    s isc=iobj.%Save()
                    d iobj.%Close() 
                }
                
                ;医护人员取消激活，指定科室截止
                if (eobj.CTPCPActiveFlag'=bobj.CTPCPActiveFlag){
                    if (eobj.CTPCPActiveFlag="Y"){
                        s RESCTLOCDR=0
                        for{
                            s RESCTLOCDR=$o(^RB("RES",0,"CTPCP",id,RESCTLOCDR)) q:RESCTLOCDR=""  
                            s RESRowId1=$o(^RB("RES",0,"CTPCP",id,RESCTLOCDR,0))
                            s rdobj=##class(User.RBResource).%OpenId(RESRowId1)
                            /*s rdobj.RESDateTo = ""
                            s scrd=rdobj.%Save()
                            d rdobj.%Close()*/
                            s rbeobj=##class(web.Entity.CT.RBResource).%New()
                            s rbeobj.RESRowId1=RESRowId1
                            s rbeobj.RESCTPCPDR=id
                            s rbeobj.RESCTLOCDR=RESCTLOCDR
                            s rbeobj.RESDateActiveTo=""
                        
                            s rbeobj.RESAdmittingRights=rdobj.RESAdmittingRights
                            s rbeobj.RESScheduleRequired=rdobj.RESScheduleForThisHospital
                            s rbeobj.RESMRRequest=rdobj.RESMRRequest
                            s rbeobj.RESDateActiveFrom=rdobj.RESDateActiveFrom
                            d ##class(web.DHCBL.CT.RBResource).SaveEntity(rbeobj)
                        }
                    }else{
                        s RESCTLOCDR=0
                        for{
                            s RESCTLOCDR=$o(^RB("RES",0,"CTPCP",id,RESCTLOCDR)) q:RESCTLOCDR=""  
                            s RESRowId1=$o(^RB("RES",0,"CTPCP",id,RESCTLOCDR,0))
                            s rdobj=##class(User.RBResource).%OpenId(RESRowId1)
                            /*s rdobj.RESDateTo = $p($h,",",1)
                            s scrd=rdobj.%Save()
                            d rdobj.%Close()*/
                            s rbeobj=##class(web.Entity.CT.RBResource).%New()
                            s rbeobj.RESRowId1=RESRowId1
                            s rbeobj.RESCTPCPDR=id
                            s rbeobj.RESCTLOCDR=RESCTLOCDR
                            s rbeobj.RESDateActiveTo=$p($h,",",1)
                        
                            s rbeobj.RESAdmittingRights=rdobj.RESAdmittingRights
                            s rbeobj.RESScheduleRequired=rdobj.RESScheduleForThisHospital
                            s rbeobj.RESMRRequest=rdobj.RESMRRequest
                            s rbeobj.RESDateActiveFrom=rdobj.RESDateActiveFrom
                            d ##class(web.DHCBL.CT.RBResource).SaveEntity(rbeobj)   
                        }
                    }   
                }
                
            }
            s result = "{success:'true',id:'"_id_"'}"         //返回RowId
        }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_$SYSTEM.Status.GetErrorText(sc)_"'}"    //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医护人员","web.DHCBL.CT.CTCareProv","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS") 
        }   
        }
        q result
    ;EEROE
    ;q "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：科室部门组信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTDeptDepartmentGroup(stream,tablename)
ClassMethod SaveCTDeptDepartmentGroup(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDDG_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.RBCDepartmentGroup).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDDG_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.DEPRowId=$o(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.DEPCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDDG_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDDG_StartDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDDG_EndDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.RBCDepartmentGroup).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：患者费别信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTCostCategory(stream,tablename)
ClassMethod SaveCTCostCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PACAdmReason).%New()   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.REACode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.REARowId=$o(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.REACode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Desc","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.READesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.READateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_EndDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.READateTo=$tr(fieldValue,$c(0),"")
    }
    s result=..SaveEntityPACAdmReason(dataeobj)
    q result
}

/// CreatDate: 2018-9-5
/// Description：保存修改患者费别的内容
/// Table：User.PACAdmReason
/// Input：web.Entity.CT.PACAdmReason 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACAdmReason).SaveEntity()
ClassMethod SaveEntityPACAdmReason(eobj As web.Entity.CT.PACAdmReason) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
    s:eobj.READateFrom'="" eobj.READateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.READateFrom)  //转换日期
    s:eobj.READateTo'="" eobj.READateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.READateTo)      //转换日期
    s:eobj.READateFrom="" eobj.READateFrom=+$h
    s flag=##class(web.DHCBL.CT.PACAdmReason).Validate(eobj.REARowId,eobj.REACode,eobj.READesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.REARowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(User.PACAdmReason).%New()
        }
        else                   //如果RowId已赋值则修改
        {
            s obj=##class(User.PACAdmReason).%OpenId(eobj.REARowId)
            s bobj=##class(web.Entity.CT.PACAdmReason).%New()
            s bobj.REARowId=eobj.REARowId
            s bobj.REACode = obj.REACode          
            s bobj.READesc = obj.READesc          
            s bobj.READateFrom = obj.READateFrom   
            s bobj.READateTo = obj.READateTo    
        }
        Ts         
        s obj.REACode = eobj.REACode          //修改代码
        s obj.READesc = eobj.READesc          //修改描述
        s obj.READateFrom = eobj.READateFrom  //修改开始日期
        s obj.READateTo = eobj.READateTo      //修改结束日期
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result= "{success:'true',id:'"_id_"'}"         //返回RowId
            //保存日志
            d:eobj.REARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmReason","User.PACAdmReason","患者费别",id,eobj.READesc,"A",eobj)
            d:eobj.REARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmReason","User.PACAdmReason","患者费别",eobj.REARowId,eobj.READesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }  
 }
 else
 {
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
  s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：宗教信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTReligion(stream,tablename)
ClassMethod SaveCTReligion(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTReligion).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLGCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTRLGRowId=$o(^CT("RLG",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTRLGCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLGDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLGDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLGDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTReligion).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：剂型信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTDoseForms(stream,tablename)
ClassMethod SaveCTDoseForms(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDF_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PHCForm).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDF_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCFCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.PHCFRowId=$o(^PHCF(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PHCFCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDF_Desc","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCFDesc=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.PHCForm).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：疗程信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTDuration(stream,tablename)
ClassMethod SaveCTDuration(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PHCDuration).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCDUCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.PHCDURowId=$o(^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PHCDUCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCDUDesc1=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Factor","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCDUFactor=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCDUDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCDUDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=..SaveEntityPHCDuration(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-9-5
/// Description：保存 疗程
/// Input: eobj As web.DHCBL.CT.PHCDuration
/// Table：User.PHCDuration
/// Return:成功返回true，失败返回false
ClassMethod SaveEntityPHCDuration(eobj As web.Entity.CT.PHCDuration) As %String
{
    s result=""
    if $IsObject(eobj)
    {   
        s:eobj.PHCDUDateFrom'="" eobj.PHCDUDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHCDUDateFrom)
        s:eobj.PHCDUDateTo'="" eobj.PHCDUDateTo =##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.PHCDUDateTo)
        if eobj.PHCDUDateFrom="" s eobj.PHCDUDateFrom=+$h   //空则默认当天
        
        s flag=##class(web.DHCBL.CT.PHCDuration).FormValidate(eobj.PHCDURowId,eobj.PHCDUCode,eobj.PHCDUDesc1)  //调用重复验证
        if (flag=1)
        {
            q "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        if (eobj.PHCDURowId="")
        {   
            s obj=##class(User.PHCDuration).%New()
        }
        else
        {
            s obj=##class(User.PHCDuration).%OpenId(eobj.PHCDURowId)
            
            s bobj = ##class(web.Entity.CT.PHCDuration).%New()
            s bobj.PHCDURowId = eobj.PHCDURowId
            s bobj.PHCDUCode = obj.PHCDUCode
            s bobj.PHCDUFactor = obj.PHCDUFactor
            s bobj.PHCDUDesc1 = obj.PHCDUDesc1  
            s bobj.PHCDUDateFrom=obj.PHCDUDateFrom
            s bobj.PHCDUDateTo=obj.PHCDUDateTo
        }   

        s obj.PHCDUCode = eobj.PHCDUCode
        s obj.PHCDUFactor = eobj.PHCDUFactor //系数
        s obj.PHCDUDesc1 = eobj.PHCDUDesc1  
        s obj.PHCDUDateFrom=eobj.PHCDUDateFrom
        s obj.PHCDUDateTo=eobj.PHCDUDateTo
        
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.PHCDURowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Duration","User.PHCDuration","疗程",id,eobj.PHCDUDesc1,"A",eobj)
            d:eobj.PHCDURowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Duration","User.PHCDuration","疗程",id,eobj.PHCDUDesc1,"U",eobj,bobj)
            if (eobj.DataAlias'="")  //2017-2-8 自动添加别名到BDPAlias表
            {
                s length=$l(eobj.DataAlias,"/")
                for aliasi=1:1:length
                {
                    s alias=$p(eobj.DataAlias,"/",aliasi)
                    s:alias'="" aliasstr=##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Duration",alias,id)
                }
            }
            
        }else{
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("疗程","web.DHCBL.CT.PHCDuration","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
        }   
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：用药途径信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTInstr(stream,tablename)
ClassMethod SaveCTInstr(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTI_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PHCInstruc).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTI_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCINCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.PHCINRowId=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PHCINCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTI_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCINDesc1=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTI_EngDesc","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCINDesc2=$tr(fieldValue,$c(0),"")
    }
    s dataeobj.PHCINActiveFlag="Y"
    b ;1
    s result=..SaveEntityPHCInstruc(dataeobj)
    b
    q result
}

/// Creator：ybq
/// CreatDate: 2018-9-5
/// Description：添加/修改 药品用法
/// Table：User.PHCInstruc
ClassMethod SaveEntityPHCInstruc(eobj As web.Entity.CT.PHCInstruc) As %String
{
    s result=""
    if $IsObject(eobj)
    {   
        s:eobj.PHCINActiveFlag="" eobj.PHCINActiveFlag="N"
        
        s flag=##class(web.DHCBL.CT.PHCInstruc).FormValidate(eobj.PHCINRowId,eobj.PHCINCode,"")  //调用重复验证
        if (flag=1)
        {
            q "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        if (eobj.PHCINRowId="")
        {   
            s obj=##class(User.PHCInstruc).%New()
        }
        else
        {
            s obj=##class(User.PHCInstruc).%OpenId(eobj.PHCINRowId)
            
            s bobj = ##class(web.Entity.CT.PHCInstruc).%New()   
            s bobj.PHCINRowId = eobj.PHCINRowId
            s bobj.PHCINCode = obj.PHCINCode
            s bobj.PHCINDesc1 = obj.PHCINDesc1
            s bobj.PHCINDesc2 = obj.PHCINDesc2
            s bobj.PHCINActiveFlag = obj.PHCINActiveFlag
    
        }
        
        s obj.PHCINCode = eobj.PHCINCode
        s obj.PHCINDesc1 = eobj.PHCINDesc1
        s obj.PHCINDesc2 = eobj.PHCINDesc2 //国外描述
        s obj.PHCINActiveFlag = eobj.PHCINActiveFlag
            
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.PHCINRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Instruc","User.PHCInstruc","药品用法",id,eobj.PHCINDesc1,"A",eobj)
            d:eobj.PHCINRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Instruc","User.PHCInstruc","药品用法",id,eobj.PHCINDesc1,"U",eobj,bobj)
            if (eobj.DataAlias'="")  //2017-2-8 自动添加别名到BDPAlias表
            {
                s length=$l(eobj.DataAlias,"/")
                for aliasi=1:1:length
                {
                    s alias=$p(eobj.DataAlias,"/",aliasi)
                    s:alias'="" aliasstr=##class(web.DHCBL.BDP.BDPAlias).Insert("PHC_Instruc",alias,id)
                }
            }
            
        }else{
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品用法","web.DHCBL.CT.PHCInstruc","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator：ybq
/// CreatDate: 2018-9-29
/// Description：关联科室保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTInstr(stream,tablename)
ClassMethod SaveCTLocLinkLocation(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDLW_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTLocLinkLocation).%New()  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDLW_DeptCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTLocCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.LINKParRef=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CTLocCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDLW_WardCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set WardCode=$tr(fieldValue,$c(0),"")
        set dataeobj.LINKCTLOCDR=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(WardCode),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTDLW_Status","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set Status=$tr(fieldValue,$c(0),"")
    }
    s childsub=$o(^CTLOC(dataeobj.LINKParRef,"LINK",0,"Loc",dataeobj.LINKCTLOCDR,0))
    s:childsub'="" dataeobj.LINKRowId=dataeobj.LINKParRef_"||"_childsub
    if (Status=1)
    {
        s result=##class(web.DHCBL.CT.CTLocLinkLocation).SaveEntity(dataeobj)
    }
    else
    {
        
        q:dataeobj.LINKRowId="" "{success:'false',info:'id为空,删除失败!'}"
        s result=##class(web.DHCBL.CT.CTLocLinkLocation).DeleteData(dataeobj.LINKRowId)
    }
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：频次信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTFreq(stream,tablename)
ClassMethod SaveCTFreq(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTF_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PHCFreq).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTF_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCFRCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.PHCFRRowId=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PHCFRCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTF_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCFRDesc2=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTF_EngDesc","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCFRDesc1=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTF_Factor","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCFRFactor=$tr(fieldValue,$c(0),"")
    }
    //S obj.PHCFRActiveFlag="Y"  add by wwd 修改状态写死,对象错误 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTF_Status","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set fieldValue =$tr(fieldValue,$c(0),"")
        i fieldValue="1" s fieldValue ="Y" d
        e  s fieldValue = "N"
        set dataeobj.PHCFRActiveFlag = fieldValue
    }
    
    s result=..SaveEntityPHCFreq(dataeobj)
    q result
}

/// Creator：ybq 
/// CreatDate: 2018-9-5
/// Description：保存 频次
/// Table：User.PHCFreq
/// Return:成功返回true，失败返回false
ClassMethod SaveEntityPHCFreq(eobj As web.Entity.CT.PHCFreq) As %String
{
    s result=""
    if $IsObject(eobj)
    {   
    
        
        s:eobj.PHCFRActiveFlag="" eobj.PHCFRActiveFlag="N"
        s:eobj.PHCFRNoDelayExecute="" eobj.PHCFRNoDelayExecute="N"
        s:eobj.PHCFRNoDelayExecuteI="" eobj.PHCFRNoDelayExecuteI="N"    
        
        //针对导入修改  20170812 
        if eobj.PHCFRClinicType["门诊" s eobj.PHCFRClinicTypeO="O"
        if eobj.PHCFRClinicType["急诊" s eobj.PHCFRClinicTypeE="E"
        if eobj.PHCFRClinicType["住院" s eobj.PHCFRClinicTypeI="I"
        if eobj.PHCFRClinicType["体检" s eobj.PHCFRClinicTypeH="H"
        if eobj.PHCFRClinicType["新生儿" s eobj.PHCFRClinicTypeN="N"
        
        ///将就诊类型拼起来， 用,分隔  20170615
        s eobj.PHCFRClinicType=eobj.PHCFRClinicTypeO_","_eobj.PHCFRClinicTypeE_","_eobj.PHCFRClinicTypeI_","_eobj.PHCFRClinicTypeH_","_eobj.PHCFRClinicTypeN
        ///如果就诊类型都没有勾选，将就诊类型置为空
        I (eobj.PHCFRClinicTypeO'="")&&(eobj.PHCFRClinicTypeE'="")&&(eobj.PHCFRClinicTypeI'="")&&(eobj.PHCFRClinicTypeH'="")&&(eobj.PHCFRClinicTypeN'="") s eobj.PHCFRClinicType=""
        ///如果就诊类型勾选，将就诊类型置为空
        I (eobj.PHCFRClinicTypeO="")&&(eobj.PHCFRClinicTypeE="")&&(eobj.PHCFRClinicTypeI="")&&(eobj.PHCFRClinicTypeH="")&&(eobj.PHCFRClinicTypeN="") s eobj.PHCFRClinicType=""
        s flag=##class(web.DHCBL.CT.PHCFreq).FormValidate(eobj.PHCFRRowId,eobj.PHCFRCode,eobj.PHCFRDesc1)  //调用重复验证
        if (flag=1)
        {
            q "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        
        if eobj.PHCFRDays'=""   ///间隔周期不为空时，校验间隔天数是否加起来等于间隔周期
        {
            
            if eobj.PHCFRIntervalDay'=""
            {
                s length=$l(eobj.PHCFRIntervalDay,"-")        ;间隔天数 2018-1-12
                s daystr=""
                s days=0
                for i=1:1:length
                {
                    s dayi=$p(eobj.PHCFRIntervalDay,"-",i)
                    s flag= ##class(web.DHCBL.BDP.FunLib).IsPositiveInteger(dayi)
                    if (dayi="")||(flag<0)
                    {
                        if (eobj.PHCFRDays=1) s daystr="{success:'false',errorinfo:'间隔天数应为正整数！'}"
                        if (eobj.PHCFRDays>1) s daystr="{success:'false',errorinfo:'间隔天数应为正整数,请用-分隔数字！'}"
                    }
                    else
                    {
                        s days=days+dayi
                    }
                }
                if daystr'="" q daystr
                if days'=eobj.PHCFRDays  q "{success:'false',errorinfo:'间隔天数加起来应该等于间隔周期！'}"
                
            }
        }
        if (eobj.PHCFRRowId="")
        {   
            s obj=##class(User.PHCFreq).%New()
        }
        else
        {
            s obj=##class(User.PHCFreq).%OpenId(eobj.PHCFRRowId)
            
            s bobj = ##class(web.Entity.CT.PHCFreq).%New()
            s bobj.PHCFRRowId = eobj.PHCFRRowId
            s bobj.PHCFRCode = obj.PHCFRCode
            s bobj.PHCFRFactor = obj.PHCFRFactor
            s bobj.PHCFRDesc1 = obj.PHCFRDesc1              
            s bobj.PHCFRDesc2 = obj.PHCFRDesc2
            s bobj.PHCFRDays = obj.PHCFRDays
            s bobj.PHCFRActiveFlag = obj.PHCFRActiveFlag
            s bobj.PHCFRNoDelayExecute = obj.PHCFRNoDelayExecute
            s bobj.PHCFRNoDelayExecuteI = obj.PHCFRNoDelayExecuteI
            s bobj.PHCFRClinicType = obj.PHCFRClinicType
            s bobj.PHCFRIntervalDay =obj.PHCFRIntervalDay         ;间隔天数 2018-1-12
        }
        s obj.PHCFRCode = eobj.PHCFRCode
        s obj.PHCFRFactor = eobj.PHCFRFactor //系数
        s obj.PHCFRDesc1 = eobj.PHCFRDesc1              
        s obj.PHCFRDesc2 = eobj.PHCFRDesc2
        s obj.PHCFRActiveFlag = eobj.PHCFRActiveFlag
            
        
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.PHCFRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Freq","User.PHCFreq","频次",id,eobj.PHCFRDesc1,"A",eobj)
            d:eobj.PHCFRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Freq","User.PHCFreq","频次",id,eobj.PHCFRDesc1,"U",eobj,bobj)
            
        }else{
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频次","web.DHCBL.CT.PHCFreq","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
        }
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：县信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTCounty(stream,tablename)
ClassMethod SaveCTCounty(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTCityArea).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CITAREACode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CITAREARowId=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CITAREACode),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CITAREADesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CITAREADateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CITAREADateTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_CCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        s CITAREACity=$tr(fieldValue,$c(0),"")
        set dataeobj.CITAREACityDR=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CITAREACity),0))
        //set dataeobj.CTCITProvinceDR=$tr(fieldValue,$c(0),"")
    }
    b
    s result=##class(web.DHCBL.CT.CTCityArea).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：市信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTCity(stream,tablename)
ClassMethod SaveCTCity(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTCity).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCITCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTCITRowId=$o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTCITCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCITDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCITDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCITDateTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_PCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        s CTCITProvince=$tr(fieldValue,$c(0),"")
        set dataeobj.CTCITProvinceDR=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(CTCITProvince),0))
        //set dataeobj.CTCITProvinceDR=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTCity).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：省信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTProvince(stream,tablename)
ClassMethod SaveCTProvince(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTProvince).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PROVCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.PROVRowId=$o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PROVCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PROVDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PROVDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PROVDateTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_CountryCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CountryCode=$tr(fieldValue,$c(0),"")
        s:CountryCode'="" dataeobj.PROVRegionDR=##class(web.DHCBL.BDP.Interface).GetRegionRowId(CountryCode)
    }
    s result=##class(web.DHCBL.CT.CTProvince).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08  
/// Description：民族信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTNation(stream,tablename)
ClassMethod SaveCTNation(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTN_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTNation).%New()   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTN_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTNATCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTNATRowId=$o(^CT("NAT",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTNATCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTN_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTNATDesc=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTNation).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：世界各国和地区信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTCountry(stream,tablename)
ClassMethod SaveCTCountry(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTCountry).%New()  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCOUCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTCOURowId=$o(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTCOUCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCOUDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCOUDateActiveFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCOUDateActiveTo=$tr(fieldValue,$c(0),"")
    }
    s eobj.CTCOUActive="Y"
    s result=##class(web.DHCBL.CT.CTCountry).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：婚姻信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTMarital(stream,tablename)
ClassMethod SaveCTMarital(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTM_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTMarital).%New()  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTM_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTMARCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTMARRowId=$o(^CT("MAR",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTMARCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTM_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTMARDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTM_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTMARDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTM_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTMARDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTMarital).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：患者关系信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTRelation(stream,tablename)
ClassMethod SaveCTRelation(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTRelation).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLTCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTRLTRowId=$o(^CT("RLT",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTRLTCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLTDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLTDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTR_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTRLTDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTRelation).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：患者职业信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTOccupation(stream,tablename)
ClassMethod SaveCTOccupation(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTOccupation).%New()   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTOCCCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTOCCRowId=$o(^CT("OCC",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTOCCCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTOCCDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTOCCDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTOCCDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTOccupation).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：患者身份信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTPatientPosition(stream,tablename)
ClassMethod SaveCTPatientPosition(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPP_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTSocialStatus).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPP_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.SSCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.SSRowId=$o(^CT("SS",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.SSCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPP_Desc","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.SSDesc=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTSocialStatus).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：医生职称信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTTitleOfTech(stream,tablename)
ClassMethod SaveCTTitleOfTech(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTTT_UpdateUserCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTTitle).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTTT_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TTLCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.TTLRowId=$o(^CT("TTL",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.TTLCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTTT_Desc","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TTLDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTTT_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TTLDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTTT_EndDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TTLDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTTitle).SaveEntity(dataeobj)
    q result
}

/// Creator：陈莹
/// CreatDate: 2018-08-07
/// Description：性别信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTSex(stream,tablename)
ClassMethod SaveCTSex(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTS_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTSex).%New()  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTS_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTSEXCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTSEXRowId=$o(^CT("SEX",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTSEXCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTS_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTSEXDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTS_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTSEXDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTS_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTSEXDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTSex).SaveEntity(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：医院信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTHospital(stream,tablename)
ClassMethod SaveCTHospital(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTH_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTHospital).%New() 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTH_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.HOSPCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.HOSPRowId=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.HOSPCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTH_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.HOSPDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTH_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.HOSPDateFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTH_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.HOSPDateTo=$tr(fieldValue,$c(0),"")
    }
    s result=..SaveEntityCTHospital(dataeobj)
    q result
}

/// Creator：ybq
/// CreatDate: 2018-9-5
/// Description：保存医院信息
/// Table：User.CTHospital
/// Input：Entity
ClassMethod SaveEntityCTHospital(eobj As web.Entity.CT.CTHospital) As %String
{
 
    s $zt="ERROR"
    s result=""
    if $IsObject(eobj)
    {
        ;s:eobj.HOSPDateFrom'="" eobj.HOSPDateFrom=$zdh(eobj.HOSPDateFrom,15)  //转换日期
        ;s:eobj.HOSPDateTo'="" eobj.HOSPDateTo=$zdh(eobj.HOSPDateTo,15)      //转换日期
        s:eobj.HOSPDateFrom'="" eobj.HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HOSPDateFrom)  //转换日期
        s:eobj.HOSPDateTo'="" eobj.HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HOSPDateTo)     //转换日期
        s:eobj.HOSPDateFrom="" eobj.HOSPDateFrom=+$h 
        if (eobj.HOSPRowId="")       
        { 
            s obj=##class(User.CTHospital).%New()
            //判断空值,前台js也已添加空值判断allowblank
            if ((eobj.HOSPCode'="")&(eobj.HOSPDesc'=""))  //判断是否为空值
            {
                s TempPLURCode=$ZCONVERT(eobj.HOSPCode,"U")   //$$ALPHAUP^SSUTIL4(eobj.RNAVCode)
                s TempCode=$d(^CT("HOSP",0,"Code",TempPLURCode))    
                if (TempCode=0)  //判断Code是否重复
                {
                    s TempPLURDesc=$ZCONVERT(eobj.HOSPDesc,"U") 
                    s TempDesc=$d(^CT("HOSP",0,"Desc",TempPLURDesc))    
                    if (TempDesc=0) //判断Desc是否重复
                    {
                        s obj.HOSPCode = eobj.HOSPCode                      //修改代码
                        s obj.HOSPDesc= eobj.HOSPDesc                      //修改描述
                        s obj.HOSPDateFrom = eobj.HOSPDateFrom 
                        s obj.HOSPDateTo=eobj.HOSPDateTo 
                        Tstart
                        s sc=obj.%Save()
                        do obj.%Close()
                        if $$$ISOK(sc){
                            Tcommit
                            s id = obj.%Id()
                            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Hospital","User.CTHospital","医院",id,eobj.HOSPDesc,"A",eobj)
                            s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
                        }else{
                            Trollback
                            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院","web.DHCBL.CT.CTHospital","SaveEntity",eobj)
                            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
                        }   
                    }
                    else  //如果Desc重复
                    {
                        s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
                    }
                }
                else //如果Code重复
                {
                    s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
                }
            }
            else //如果两者中存在空值
            {
                s result="{success:'false',errorinfo:'代码或描述不可为空，请重新填写！'}"
            }
        }
        //如果RowId已赋值则修改
        else                           
        {
            //RowId已存在,修改
            s obj=##class(User.CTHospital).%OpenId(eobj.HOSPRowId)
            s bobj=##class(web.Entity.CT.CTHospital).%New()
            s bobj.HOSPRowId=eobj.HOSPRowId
            s bobj.HOSPCode = obj.HOSPCode                     
            s bobj.HOSPDesc= obj.HOSPDesc                     
            s bobj.HOSPDateFrom = obj.HOSPDateFrom 
            s bobj.HOSPDateTo=obj.HOSPDateTo
            
            //判断空值,前台js也已添加空值判断allowblank
            if ((eobj.HOSPCode'="")&(eobj.HOSPDesc'=""))  //判断是否为空值
            {
                s TempRNAVCode=$ZCONVERT(eobj.HOSPCode,"U")
                s TempCode=$d(^CT("HOSP",0,"Code",TempRNAVCode))    
                s TempRowId1=$o(^CT("HOSP",0,"Code",TempRNAVCode,0))
                if (TempCode=0)||((TempCode'=0)&(eobj.HOSPRowId=TempRowId1)) //判断Code是否重复
                {
                    s TempRNAVDesc=$ZCONVERT(eobj.HOSPDesc,"U")
                    s TempDesc=$d(^CT("HOSP",0,"Desc",TempRNAVDesc))    
                    s TempRowId2=$o(^CT("HOSP",0,"Desc",TempRNAVDesc,0))
                    if (TempDesc=0)||((TempDesc'=0)&(eobj.HOSPRowId=TempRowId2)) //判断Desc是否重复
                    {
                        s obj.HOSPCode = eobj.HOSPCode                      //修改代码
                        s obj.HOSPDesc= eobj.HOSPDesc                      //修改描述
                        s obj.HOSPDateFrom = eobj.HOSPDateFrom 
                        s obj.HOSPDateTo=eobj.HOSPDateTo
                        Tstart
                        s sc=obj.%Save()
                        do obj.%Close()
                        if $$$ISOK(sc){
                            Tcommit
                            s id = obj.%Id()
                            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Hospital","User.CTHospital","医院",eobj.HOSPRowId,eobj.HOSPDesc,"U",eobj,bobj)
                            s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
                        }else{
                            Trollback
                            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
                            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院","web.DHCBL.CT.CTHospital","SaveEntity",eobj)
                            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
                        }   
                    }
                    else //如果Desc重复
                    {
                        s result="{success:'false',errorinfo:'该描述已经存在，请重新填写！'}"
                    }
                }
                else //如果Code重复
                {
                    s result="{success:'false',errorinfo:'该代码已经存在，请重新填写！'}"
                }   
            }
            else //如果两者中存在空值
            {
                s result="{success:'false',errorinfo:'代码或描述不可为空，请重新填写！'}"
            }
        }   
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
ERROR
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院","web.DHCBL.CT.CTHospital","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'保存失败！'}"
}

/// w ##class(web.DHCBL.BDP.Interface).Test5()
ClassMethod Test5()
{
    set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.Write(^TMPInputStream1)
    s rs= ##class(BDPDataTrans.InterfaceService).%New().SaveRecord(stream,"CT_Dept")
    q rs.Read()
    // w ##class(web.DHCBL.BDP.Interface).SaveCTDept(stream,"CT_Dept")
}

/// Creator：ybq
/// CreatDate: 2018-08-08
/// Description：科室信息保存
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTDept(^TMPInputStream1,"CT_Dept")
ClassMethod SaveCTDept(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
 
    //s ^TMPInputStream1=InputStream.Read()
     
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_UpdateUserCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTLoc).%New()  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Code","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.CTLOCRowID=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTLOCCode),0))
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Desc","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCDesc=$tr(fieldValue,$c(0),"") b 
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_CategoryCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        s CTLOCType=$tr(fieldValue,$c(0),"")
        if (CTLOCType="Ward")
        {
            s CTLOCType="W"
        }
        if (CTLOCType="Execute")
        {
            s CTLOCType="E"
        }
        if (CTLOCType="Drug Injection")
        {
            s CTLOCType="DI"
        }
        if (CTLOCType="Dispensing")
        {
            s CTLOCType="D"
        }
        if (CTLOCType="Cashier")
        {
            s CTLOCType="C"
        }
        if (CTLOCType="Other")
        {
            s CTLOCType="O"
        }
        if (CTLOCType="Operating Theatre")
        {
            s CTLOCType="OP"
        }
        if (CTLOCType="Day Surgery")
        {
            s CTLOCType="DS"
        }
        if (CTLOCType="Medical Records")
        {
            s CTLOCType="MR"
        }
        if (CTLOCType="OutPatient Consulting Room")
        {
            s CTLOCType="OR"
        }
        if (CTLOCType="Clinic")
        {
            s CTLOCType="CL"
        }
        if (CTLOCType="Admission Point")
        {
            s CTLOCType="ADM"
        }
        set dataeobj.CTLOCType=CTLOCType
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Phonetic","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCContactName=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_DepartmentGroup","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        s CTLOCDep=$tr(fieldValue,$c(0),"")
        s:CTLOCDep'="" dataeobj.CTLOCDepDR=$o(^RBC("DEP",0,"Code",$$ALPHAUP^SSUTIL4(CTLOCDep),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_StartDate","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCDateActiveFrom=$tr(fieldValue,$c(0),"")
    }   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_EndDate","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCDateActiveTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_OfficeAddress","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCAddress=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_OfficePhone","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTLOCTelephone=$tr(fieldValue,$c(0),"")
    }
    //获取主数据传过来的医院代码 add by xieyejian 2019/03/07 start
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_HosCode","text()",.tRes)                    
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTLOCHospitalCode=$tr(fieldValue,$c(0),"")
        s:CTLOCHospitalCode'="" dataeobj.CTLOCHospitalDR=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(CTLOCHospitalCode),""))
    }
    //获取主数据传过来的医院代码 add by xieyejian 2019/03/07 end
    s result=..SaveEntityCTLoc(dataeobj)
    s ^TMPresult=result
    q result
}

/// Description：科室多院区数据重复校验问题
/// Creator：	sunfengchao
/// CreatDate: 	2013-1-29
/// Input：		id, code, desc
/// Return：		"1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.BDP.Interface).CTLOCFormValidate("","","神经外科门诊","") 
ClassMethod CTLOCFormValidate(id As %String, code As %String, desc As %String, hosp As %String = "") As %String
{
    s flag=0 
 	s idc=0
    s:$$ALPHAUP^SSUTIL4(code)'="" idc=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(code),0))
    if ((id="")||((id'="")&&(idc'=id)))&&(idc>0) s flag=1  //返回重复标志 
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
			s idd=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			s CTLOCHospitalDR=$p($g(^CTLOC(idd)),"^",22)     //医院    ///2020-02-05update 同一个医院下不允许名称项同
			if ((hosp="")||((CTLOCHospitalDR=hosp)&&(hosp'="")))&&(id'=idd)
			{
				s flag=1  //返回重复标志 
			}
		} 
	} 
    q flag
}

/// Creator：sunfengchao
/// CreatDate: 2020-04-16
/// Description：保存修改科室维护的内容
/// Table：User.CTLoc
/// Input：web.Entity.CT.CTLoc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.CTLoc).SaveEntity()
ClassMethod SaveEntityCTLoc(eobj As web.Entity.CT.CTLoc, ClinicValues As %String = "") As %String
{
    s $zt="ERROE"
    s result = "" 
    if $IsObject(eobj)
    {
        s:eobj.CTLOCDateActiveFrom="" eobj.CTLOCDateActiveFrom=+$h
        s eobj.CTLOCClinicType = ClinicValues 
        s:eobj.CTLOCDateActiveFrom'="" eobj.CTLOCDateActiveFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLOCDateActiveFrom)  //转换日期
        s:eobj.CTLOCDateActiveTo'="" eobj.CTLOCDateActiveTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTLOCDateActiveTo)  //转换日期
        s:eobj.CTLOCIndex="" eobj.CTLOCIndex="N"
        s:eobj.CTLOCMedicalRecordActive="" eobj.CTLOCMedicalRecordActive="N"
        s:eobj.CTLOCExecuteConfirmation="" eobj.CTLOCExecuteConfirmation="N"
        
        s flag= ..CTLOCFormValidate(eobj.CTLOCRowID,eobj.CTLOCCode,eobj.CTLOCDesc,eobj.CTLOCHospitalDR) // 处理 多院区数据重复校验问题 
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'科室描述重复！'}"
        }
        else
        {
            if (eobj.CTLOCRowID="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.CTLoc).%New()
            }
            else
            {
                s obj=##class(User.CTLoc).%OpenId(eobj.CTLOCRowID)
                s bobj=##class(web.Entity.CT.CTLoc).%New()
                s bobj.CTLOCRowID=eobj.CTLOCRowID
                s bobj.CTLOCCode = obj.CTLOCCode          //修改代码
                s bobj.CTLOCDesc = obj.CTLOCDesc          //修改描述
                s bobj.CTLOCAddress = obj.CTLOCAddress.GetAt(1)
                s bobj.CTLOCType = obj.CTLOCType 
                s:obj.CTLOCDepDR'="" bobj.CTLOCDepDR = obj.CTLOCDepDR.%Id()
                s bobj.CTLOCDateActiveFrom = obj.CTLOCDateActiveFrom
                s bobj.CTLOCDateActiveTo = obj.CTLOCDateActiveTo
                s bobj.CTLOCTelephone = obj.CTLOCTelephone 
                
                ;科室被引用判断移除      
                ;if (testCTLOCHospitalDR'=eobj.CTLOCHospitalDR)
                ;{
                    ;s re=##class(web.DHCBL.CT.CTLoc).GetRefFlag(eobj.CTLOCRowID)
                    ;s RefFlag=$p(re,"^",1)
                    ;if (RefFlag'=0){
                        ;q "{success:'false',errorinfo:'科室已被引用，不能修改医院。'}"
                    ;}
                ;}
            }
            Ts                              
            s obj.CTLOCCode = eobj.CTLOCCode          //修改代码
            s obj.CTLOCDesc = eobj.CTLOCDesc          //修改描述
            ;s obj.CTLOCAddress = eobj.CTLOCAddress
            s AddressList=##class(%ListOfDataTypes).%New()
            do AddressList.Insert(eobj.CTLOCAddress)
            s obj.CTLOCAddress = AddressList          //保存地址
            s obj.CTLOCType = eobj.CTLOCType 
            s obj.CTLOCAgeFrom = eobj.CTLOCAgeFrom 
            s obj.CTLOCAgeTo = eobj.CTLOCAgeTo 
            s obj.CTLOCType = eobj.CTLOCType 
            d obj.CTLOCDepDRSetObjectId(eobj.CTLOCDepDR)
            s obj.CTLOCDateActiveFrom = eobj.CTLOCDateActiveFrom
            s obj.CTLOCDateActiveTo = eobj.CTLOCDateActiveTo
            s obj.CTLOCContactName = eobj.CTLOCContactName  
            s obj.CTLOCTelephone = eobj.CTLOCTelephone
            if (eobj.CTLOCType="W")
            {
                s obj.CTLOCWardFlag="Y"
            }
            else
            {
                s obj.CTLOCWardFlag="N"
            }
            //保存主数据传过来的医院代码 add by xieyejian 2019/03/07 start
            //这个方法截取##class(web.DHCBL.CT.CTLoc).SaveEntity方法中的部分逻辑实现的，逻辑中可以直接保存科室对应的医院 
            d obj.CTLOCHospitalDRSetObjectId(eobj.CTLOCHospitalDR)
            //保存主数据传过来的医院代码 add by xieyejian 2019/03/07 end     
            s sc = obj.%Save()
            d obj.%Close()
            
            If $$$ISOK(sc)
            {
                s id = obj.%Id()
                /*
                if (eobj.CTLOCType="W")||(eobj.CTLOCType="EM")||(eobj.CTLOCType="OP")       //如果科室类型为ward,添加表PAC_Ward记录
                {
                    s:eobj.WARDSingleRoom="" eobj.WARDSingleRoom="N"
                    s:eobj.WARDActive="" eobj.WARDActive="N"
                    s:eobj.WARDViewLinkedRooms="" eobj.WARDViewLinkedRooms="N"
                    s:eobj.WARDViewNextMostUrgent="" eobj.WARDViewNextMostUrgent="N"
                    
                    s WARDRowID=$o(^PAWARD(0,"WARD_LocationDR",id,0))
                    if (WARDRowID'=""){
                        s wobj = ##class(User.PACWard).%OpenId(WARDRowID)
                        s wobj = ##class(User.PACWard).%OpenId(WARDRowID)
                        s wbobj=##class(web.Entity.CT.PACWard).%New()
                        s weobj=##class(web.Entity.CT.PACWard).%New()
                        //PACWard
                        s wbobj.WARDRowID=WARDRowID
                        s wbobj.WARDCode = wobj.WARDCode
                        s wbobj.WARDDesc = wobj.WARDDesc
                        s wbobj.WARDSingleRoom = wobj.WARDSingleRoom
                        s wbobj.WARDActive = wobj.WARDActive
                        s wbobj.WARDViewLinkedRooms = wobj.WARDViewLinkedRooms
                        s wbobj.WARDViewNextMostUrgent = wobj.WARDViewNextMostUrgent
                        s wbobj.WARDInactiveDateFrom = wobj.WARDInactiveDateFrom
                        s wbobj.WARDInactiveDateTo = wobj.WARDInactiveDateTo
                        
                        s weobj.WARDRowID=WARDRowID
                        s weobj.WARDCode = wobj.WARDCode
                        s weobj.WARDDesc = wobj.WARDDesc
                        s weobj.WARDSingleRoom = eobj.WARDSingleRoom
                        s weobj.WARDActive = eobj.WARDActive
                        s weobj.WARDViewLinkedRooms = eobj.WARDViewLinkedRooms
                        s weobj.WARDViewNextMostUrgent = eobj.WARDViewNextMostUrgent
                        s weobj.WARDInactiveDateFrom = eobj.CTLOCDateActiveFrom
                        s weobj.WARDInactiveDateTo = eobj.CTLOCDateActiveTo
                        
                        s wobj.WARDSingleRoom = eobj.WARDSingleRoom
                        s wobj.WARDActive = eobj.WARDActive
                        s wobj.WARDViewLinkedRooms = eobj.WARDViewLinkedRooms
                        s wobj.WARDViewNextMostUrgent = eobj.WARDViewNextMostUrgent
                        s wobj.WARDInactiveDateFrom = eobj.CTLOCDateActiveFrom
                        s wobj.WARDInactiveDateTo = eobj.CTLOCDateActiveTo
                        s wsc=wobj.%Save()
                        d wobj.%Close()
                        If $$$ISOK(sc)
                        {
                            s wid = wobj.%Id()
                            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_Ward","User.PACWard","病区",WARDRowID,wobj.WARDDesc,"U",weobj,wbobj)
                        }
                        else
                        {
                            Trollback
                            s result= "{success:'false',errorinfo:'"_$zconvert(wsc,"O","JS")_"'}"    //
                            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病区","web.DHCBL.CT.PACWard","SaveEntity",weobj)
                            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
                        }
                    }
                }
                */
                //如果科室分类有被选中,添加表PAC_Ward记录
                if ((eobj.OutPatient'="")||(eobj.InPatient'="")||(eobj.Emergency'="")||(eobj.HealthPromotion'=""))
                {
                    
                }
                Tc                  
                s result = "{success:'true',id:'"_id_"'}"         //返回RowId
                s:eobj.CTLOCRowID'="" resultLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",eobj.CTLOCRowID,eobj.CTLOCDesc,"U",eobj,bobj)
                s:eobj.CTLOCRowID="" resultLog=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Loc","User.CTLoc","科室病区",id,eobj.CTLOCDesc,"A",eobj)
                s PortalFlag=##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPUsePortal")
                if (PortalFlag="Y"){
                    try{
                        s logid=$p(resultLog,"^",1)
                        if (##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidClassName("DtPortal.NH.CommonService")=1){
                            if (##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidMethodName("DtPortal.NH.CommonService","ImportPortal")=1){
                                s Soap=##class(DtPortal.NH.CommonService).ImportPortal(logid)
                                if ($p(Soap,"^",1)=0){
                                    s result = "{success:'true',id:'"_id_"',info:'Portal同步信息:"_$p(Soap,"^",2)_"'}"   
                                }else{
                                    s result = "{success:'false',info:'Portal同步信息:"_$p(Soap,"^",2)_"'}" //返回错误信息    
                                    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("Portal科室病区","web.DHCBL.CT.CTLoc","SaveEntity",eobj)
                                    s ^ERRORLOGINFO(logid)=$p(Soap,"^",2)
                                }
                            }   
                        }   
                    }catch myvar{
                        s result = myvar.Name
                        ;myvar.Name 会显示报错信息

                        if (result="<SYNTAX>")
                        {
                            s result="{success:'false',info:'Please conform to the Portal condition'}" 
                            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("Portal科室病区","web.DHCBL.CT.CTLoc","SaveEntity",eobj)
                            s ^ERRORLOGINFO(logid)="Please conform to the Portal condition" 
                        }   
                    }   
                }
            }
            else
            {
                Trollback
                s errorMsg=$zconvert(sc,"O","JS")
                i errorMsg["Can\'t change type"
                {
                    s errorMsg="该科室类型禁止修改！"
                }
                s result = "{success:'false',errorinfo:'"_errorMsg_"'}"    //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.CT.CTLoc","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
            }
        }           
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("科室病区","web.DHCBL.CT.CTLoc","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// w ##class(web.DHCBL.BDP.Interface).Test11()
ClassMethod Test11()
{
    ///日期格式YYYY-MM-DD
    set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.Write("<Request><Header><SourceSystem>30</SourceSystem><MessageID></MessageID></Header><Body><CT_ChargeItemList><CT_ChargeItem><BusinessFieldCode>00001</BusinessFieldCode><CTCI_ACCCCode>007</CTCI_ACCCCode><CTCI_AnoName></CTCI_AnoName><CTCI_CCCode>031</CTCI_CCCode><CTCI_CCHCode></CTCI_CCHCode><CTCI_CCode></CTCI_CCode><CTCI_Code>ABCJ0001(120400013)</CTCI_Code><CTCI_CodesystemCode>CT_ChargeItem</CTCI_CodesystemCode><CTCI_CreatDate>2018-11-29</CTCI_CreatDate><CTCI_CreatTime>00:00:01</CTCI_CreatTime><CTCI_Desc>抗肿瘤化疗药物/肠外营养液集中配置</CTCI_Desc><CTCI_EMCCCode>018</CTCI_EMCCCode><CTCI_EndDate></CTCI_EndDate><CTCI_HosCode></CTCI_HosCode><CTCI_IPCCCode>004</CTCI_IPCCCode><CTCI_MRCCCode>002</CTCI_MRCCCode><CTCI_MRCCCodeNew>002</CTCI_MRCCCodeNew><CTCI_OPCCCode>005</CTCI_OPCCCode><CTCI_OriginalCode></CTCI_OriginalCode><CTCI_OriginalDesc></CTCI_OriginalDesc><CTCI_Remarks></CTCI_Remarks><CTCI_StartDate>2018-11-29</CTCI_StartDate><CTCI_Status>1</CTCI_Status><CTCI_UnitCode>118</CTCI_UnitCode><CTCI_UpdateDate>2018-11-29</CTCI_UpdateDate><CTCI_UpdateTime>00:00:01</CTCI_UpdateTime><CTCI_UpdateUserCode>demo</CTCI_UpdateUserCode></CT_ChargeItem></CT_ChargeItemList></Body></Request>")
    set responseStream=##class(web.DHCBL.BDP.Interface).SaveCTChargeItem(stream,"CT_ChargeItem")
    q 1
}

/// Function: 1.7.收费项目字典表(CT_ChargeItem)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_ChargeItem
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTChargeItem(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarItem).%New() 
    /// 收费项目代码  CTCI_Code   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARICode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARIRowId=$o(^DHCTARI(0,"Code",dataeobj.TARICode,0))    
    } 
    
    /// 收费项目名称  CTCI_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARIDesc=$tr(fieldValue,$c(0),"")  
    }   
    /// 备注  CTCI_Remarks
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_Remarks","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARIRemark=$tr(fieldValue,$c(0),"")  
    }   

    
    ///  单位代码   CTCI_UnitCode
    set CTCIUnitCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_UnitCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIUnitCode=$tr(fieldValue,$c(0),"")  
        set:CTCIUnitCode'="" dataeobj.TARIUOM=$o(^CT("UOM",0,"Code",$zcvt(CTCIUnitCode,"U"),0))
    }   
    /// 收费子类代码  CTCI_CCCode
    set CTCICCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_CCCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCICCCode=$tr(fieldValue,$c(0),"")  
        set:CTCICCCode'="" dataeobj.TARISubCate=$o(^DHCTarC("SC",0,"Code",CTCICCCode,0))
    } 
    /// 住院收费子类代码    CTCI_IPCCCode
    set CTCIIPCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_IPCCCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIIPCCCode=$tr(fieldValue,$c(0),"")  
        set:CTCIIPCCCode'="" dataeobj.TARIInpatCate=$o(^DHCTarC("IC",0,"Code",CTCIIPCCCode,0))
    } 
    /// 核算收费子类代码    CTCI_EMCCCode
    set CTCIEMCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_EMCCCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIEMCCCode=$tr(fieldValue,$c(0),"")  
        set:CTCIEMCCCode'="" dataeobj.TARIEMCCate=$o(^DHCTarC("EC",0,"Code",CTCIEMCCCode,0))
    } 

    ///  会计收费子类代码   CTCI_ACCCCode
    set CTCIACCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_ACCCCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIACCCCode=$tr(fieldValue,$c(0),"")  
        set:CTCIACCCCode'="" dataeobj.TARIAcctCate=$o(^DHCTarC("AC",0,"Code",CTCIACCCCode,0))
    } 
 
    ///  门诊收费子类代码   CTCI_OPCCCode
    set CTCIOPCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_OPCCCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIOPCCCode=$tr(fieldValue,$c(0),"")  
        set:CTCIOPCCCode'="" dataeobj.TARIOutpatCate=$o(^DHCTarC("OC",0,"Code",CTCIOPCCCode,0))
    } 
 
    /// 病案首页费用子类代码  CTCI_MRCCCode
    set CTCIMRCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_MRCCCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIMRCCCode=$tr(fieldValue,$c(0),"")  
        set:CTCIMRCCCode'="" dataeobj.TARIMRCate=$o(^DHCTarC("MC",0,"Code",CTCIMRCCCode,0))
    } 


    /// 有效开始日期  CTCI_StartDate
    set CTCIEMCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARIStartDate=$tr(fieldValue,$c(0),"")   
    }  
    
    ///有效结束日期   CTCI_EndDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_EndDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARIEndDate=$tr(fieldValue,$c(0),"")  
    } 
    /// 新病案首页费用分类代码 CTCI_MRCCCode
    set CTCIMRCCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_MRCCCodeNew","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTCIMRCCCode=$tr(fieldValue,$c(0),"") 
        set:CTCIMRCCCode'="" dataeobj.TARIMCNew=$o(^DHCTARMRCATENEW(0,"Code",CTCIMRCCCode,0))
    }   
    //set dataeobj.TARIActiveFlag="Y"  修改可用标记写死，add by wwd 20181216
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_Status","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set fieldValue=$tr(fieldValue,$c(0),"")  
        i (fieldValue=1) s dataeobj.TARIActiveFlag="Y"  d
        e  s dataeobj.TARIActiveFlag="N" 
    } 
  /* s result=##class(web.DHCBL.CT.DHCTarItem).SaveEntity(dataeobj)
     if (result["true")
    {
        /// 别名  CTCI_AnoName 
        set tarid=$p($P(result,",",2),"id:",2)   
        set:tarid'="" tarid=$tr(tarid,")","")
        set:tarid'="" tarid=$e(tarid,2,*-2) 
        set TIAAlias=""
        set TIAAliasStr=""
        set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCI_AnoName","text()",.tRes)                 
        if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
            set fieldValue=tRes.GetAt(1).Value
            set TIAAlias=$tr(fieldValue,$c(0),"") 
            if (TIAAlias["/")
            {   
                for i=1:1:$L(TIAAlias,"/")
                {
                    set Alias=$P(TIAAlias,"/",i)
                    if (TIAAliasStr="")
                    {
                        set TIAAliasStr="^"_Alias_"^"_tarid
                    }
                    else
                    {
                         set TIAAliasStr=TIAAliasStr_"&#^"_Alias_"^"_tarid
                    }
                } 
            }
            else
            {
              set TIAAliasStr ="^"_TIAAlias_"^"_tarid
            }  
            do:TIAAliasStr'="" ##class(web.DHCBL.CT.DHCTarItemAlias).SaveAll(TIAAliasStr)  
         }  
    }  
    q result
    */
    s qresult=""
    s:dataeobj.TARIStartDate'="" dataeobj.TARIStartDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.TARIStartDate)
    s:dataeobj.TARIEndDate'="" dataeobj.TARIEndDate = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.TARIEndDate)
    s:dataeobj.TARIStartDate="" dataeobj.TARIStartDate=+$h 
    if (dataeobj.TARIEndDate="")&&(dataeobj.TARIActiveFlag="N") s dataeobj.TARIEndDate=+$h      
    S valideflag= ##class(web.DHCBL.CT.DHCTarItem).FormValidate(dataeobj.TARIRowId,dataeobj.TARICode,dataeobj.TARIDesc)
    if (valideflag=0) //判断代码或描述是否重复
    {
        //增加
        if (dataeobj.TARIRowId="")       
        {
            s obj=##class(User.DHCTarItem).%New()
        }
        //如果RowId已赋值则修改
        else                           
        {
            
                s obj=##class(User.DHCTarItem).%OpenId(dataeobj.TARIRowId)
                s bobj=##class(web.Entity.CT.DHCTarItem).%New()
            
                s bobj.TARIRowId=dataeobj.TARIRowId
                s bobj.TARICode = obj.TARICode                     
                s bobj.TARIDesc= obj.TARIDesc     
                s bobj.TARIStartDate = obj.TARIStartDate 
                s bobj.TARIEndDate=obj.TARIEndDate 
                s bobj.TARIActiveFlag=obj.TARIActiveFlag
                if $IsObject(obj.TARIUOM){
                    s bobj.TARIUOM = obj.TARIUOM.%Id() 
                }
                if $IsObject(obj.TARISubCate){
                    s bobj.TARISubCate = obj.TARISubCate.%Id() 
                }
                if $IsObject(obj.TARIInpatCate){
                    s bobj.TARIInpatCate = obj.TARIInpatCate.%Id() 
                }
                if $IsObject(obj.TARIEMCCate){
                    s bobj.TARIEMCCate = obj.TARIEMCCate.%Id() 
                }
                if $IsObject(obj.TARIAcctCate){
                    s bobj.TARIAcctCate = obj.TARIAcctCate.%Id() 
                }
                if $IsObject(obj.TARIOutpatCate){
                    s bobj.TARIOutpatCate = obj.TARIOutpatCate.%Id() 
                }
                if $IsObject(obj.TARIMRCate){
                    s bobj.TARIMRCate = obj.TARIMRCate.%Id() 
                }
           
            }   
            
            s obj.TARICode = dataeobj.TARICode                      //修改代码
            s obj.TARIDesc= dataeobj.TARIDesc                      //修改描述
            s obj.TARIInsuName= dataeobj.TARIInsuName 
            s obj.TARIExternalCode= dataeobj.TARIExternalCode 
            s obj.TARIEngName= dataeobj.TARIEngName 
            s obj.TARIChargeBasis= dataeobj.TARIChargeBasis
            s obj.TARIStartDate = dataeobj.TARIStartDate 
            s obj.TARIEndDate=dataeobj.TARIEndDate 
            s obj.TARIActiveFlag=dataeobj.TARIActiveFlag 
            d:dataeobj.TARIUOM'="" obj.TARIUOMSetObjectId(dataeobj.TARIUOM)
            d:dataeobj.TARIUOM="" obj.TARIUOMSetObjectId("")
        
            d:dataeobj.TARISubCate'="" obj.TARISubCateSetObjectId(dataeobj.TARISubCate)
            d:dataeobj.TARISubCate="" obj.TARISubCateSetObjectId("")
            d:dataeobj.TARIInpatCate'="" obj.TARIInpatCateSetObjectId(dataeobj.TARIInpatCate)
            d:dataeobj.TARIInpatCate="" obj.TARIInpatCateSetObjectId("")
            d:dataeobj.TARIAcctCate'="" obj.TARIAcctCateSetObjectId(dataeobj.TARIAcctCate)
            d:dataeobj.TARIAcctCate="" obj.TARIAcctCateSetObjectId("")
            d:dataeobj.TARIOutpatCate'="" obj.TARIOutpatCateSetObjectId(dataeobj.TARIOutpatCate)
            d:dataeobj.TARIOutpatCate="" obj.TARIOutpatCateSetObjectId("")
            d:dataeobj.TARIEMCCate'="" obj.TARIEMCCateSetObjectId(dataeobj.TARIEMCCate)
            d:dataeobj.TARIEMCCate="" obj.TARIEMCCateSetObjectId("")
        
            d:dataeobj.TARIMRCate'="" obj.TARIMRCateSetObjectId(dataeobj.TARIMRCate)
            d:dataeobj.TARIMRCate="" obj.TARIMRCateSetObjectId("") 
            s obj.TARIRemark = dataeobj.TARIRemark  //备注
 
       
            Tstart
            s sc=obj.%Save()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                s $p(^DHCTARI(id),"^",30)=dataeobj.TARIMCNew      ;;新病案首页 有些项目是没有字段的
                s qresult = "{success:'true',id:'"_id_"'}"        //保存数据后,通过RowId返回到这条数据  
            }
            else{
                Trollback
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("收费项目","web.DHCBL.CT.DHCTarItem","SaveEntity",dataeobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
                s qresult = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
            }
        }
        else //如果重复
        {
            s qresult="{success:'false',errorinfo:'收费项目代码或描述已经存在，请重新填写！'}"
        }
      
    if (qresult["true")
    {
        /// 别名  CTCI_AnoName 
        set tarid=$p($P(qresult,",",2),"id:",2)   
        set:tarid'="" tarid=$tr(tarid,")","")
        set:tarid'="" tarid=$e(tarid,2,*-2) 
        set TIAAlias=""
        set TIAAliasStr=""
        set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCI_AnoName","text()",.tRes)                 
        if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
            set fieldValue=tRes.GetAt(1).Value
            set TIAAlias=$tr(fieldValue,$c(0),"") 
            if (TIAAlias["/")
            {   
                for i=1:1:$L(TIAAlias,"/")
                {
                    set Alias=$P(TIAAlias,"/",i)
                    if (TIAAliasStr="")
                    {
                        set TIAAliasStr="^"_Alias_"^"_tarid
                    }
                    else
                    {
                         set TIAAliasStr=TIAAliasStr_"&#^"_Alias_"^"_tarid
                    }
                } 
            }
            else
            {
              set TIAAliasStr ="^"_TIAAlias_"^"_tarid
            }  
            do:TIAAliasStr'="" ##class(web.DHCBL.CT.DHCTarItemAlias).SaveAll(TIAAliasStr)  
         }  
    }  
    q qresult
}

/// Function: 1.10.医嘱大类字典表(CT_Category) 
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table: CT_Category
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    /// 最后更新人编码 CTC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.OECOrderCategory).%New()  
    /// 医嘱大类代码  CTC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ORCATCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.ORCATRowId=$o(^OEC("ORCAT",0,"Code",$zcvt(dataeobj.ORCATCode,"U"),0)) 
    }
    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ORCATDesc=$tr(fieldValue,$c(0),"")
    } 
    //s result=##class(web.DHCBL.CT.OECOrderCategory).SaveEntity(dataeobj)
     s flag=##class(web.DHCBL.CT.OECOrderCategory).FormValidate(dataeobj.ORCATRowId,dataeobj.ORCATCode,dataeobj.ORCATDesc)  
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (dataeobj.ORCATRowId="")   
        {
            s obj=##class(User.OECOrderCategory).%New()
        }
        else                    
        {
            s obj=##class(User.OECOrderCategory).%OpenId(dataeobj.ORCATRowId)
            s bobj=##class(web.Entity.CT.OECOrderCategory).%New()
            s bobj.ORCATRowId = dataeobj.ORCATRowId
            s bobj.ORCATCode = obj.ORCATCode          
            s bobj.ORCATDesc = obj.ORCATDesc   
        }
        Ts                              
        s obj.ORCATCode = dataeobj.ORCATCode           
        s obj.ORCATDesc = dataeobj.ORCATDesc          
        s sc = obj.%Save() 
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"     
            d:dataeobj.ORCATRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategory","User.OECOrderCategory","医嘱大类",id,dataeobj.ORCATDesc,"A",dataeobj)
            d:dataeobj.ORCATRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("OEC_OrderCategory","User.OECOrderCategory","医嘱大类",dataeobj.ORCATRowId,dataeobj.ORCATDesc,"U",dataeobj,bobj)
        }
        else
        {
            Trollback
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱大类","web.DHCBL.CT.OECOrderCategory","SaveEntity",dataeobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            s result = "{success:'false',errorinfo:'"_$System.OBJ.DisplayError(sc)_"'}"   
        }
    }   
    q result
}

/// Function: 1.11.医嘱子类字典表(CT_ChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_ChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.ARCItemCat).%New() 
    /// 医嘱子类代码  CTCC_Code   
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCICCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.ARCICRowId=$o(^ARC("IC",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.ARCICCode),0))    
    } 
    ///医嘱子类描述   CTCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCICDesc=$tr(fieldValue,$c(0),"")  
    }   
    /// 医嘱类型    CTCC_OrderType   Drug - D 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_OrderType","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCICOrderType=$tr(fieldValue,$c(0),"")  
    } 
    ///  医嘱大类代码 CTCC_Category
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Category","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set ORCATCode=$tr(fieldValue,$c(0),"")  
        set dataeobj.ARCICOrdCatDR =$o(^OEC("ORCAT",0,"Code",$zcvt(ORCATCode,"U"),0))   
    }   
    //s result=##class(web.DHCBL.CT.ARCItemCat).SaveEntity(dataeobj)
   s flag=##class(web.DHCBL.CT.ARCItemCat).FormValidate(dataeobj.ARCICRowId,dataeobj.ARCICCode,dataeobj.ARCICDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (dataeobj.ARCICRowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(User.ARCItemCat).%New()
        }
        else                     //如果RowId已赋值则修改
        {
            s obj=##class(User.ARCItemCat).%OpenId(dataeobj.ARCICRowId)
            s bobj=##class(web.Entity.CT.ARCItemCat).%New()
            s bobj.ARCICRowId = dataeobj.ARCICRowId
            s bobj.ARCICCode = obj.ARCICCode
            s bobj.ARCICDesc = obj.ARCICDesc
            s bobj.ARCICOrderType = obj.ARCICOrderType
            if $IsObject(obj.ARCICOrdCatDR){
                s bobj.ARCICOrdCatDR = obj.ARCICOrdCatDR.%Id() 
            }
            if $IsObject(obj.ARCICExecCategDR){
                s bobj.ARCICExecCategDR = obj.ARCICExecCategDR.%Id() 
            } 
        }                             
        s obj.ARCICCode = dataeobj.ARCICCode          //修改代码
        s obj.ARCICDesc = dataeobj.ARCICDesc          //修改描述
        s obj.ARCICOrderType = dataeobj.ARCICOrderType
        d obj.ARCICOrdCatDRSetObjectId(dataeobj.ARCICOrdCatDR) 
        s obj.ARCICCalcQtyFlag = "N"
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"         //返回RowId
            d:dataeobj.ARCICRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCat","User.ARCItemCat","医嘱子分类",id,dataeobj.ARCICDesc,"A",dataeobj)
            d:dataeobj.ARCICRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_ItemCat","User.ARCItemCat","医嘱子分类",dataeobj.ARCICRowId,dataeobj.ARCICDesc,"U",dataeobj,bobj)
        }
        else
        {
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医嘱子分类","web.DHCBL.CT.ARCItemCat","SaveEntity",dataeobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            s result ="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
        }
    }   
    q result
}

/// Function: 1.12 账单大类字典表 (CT_BillCat)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table: CT_BillCat
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTBillCat(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息 CTBC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.ARCBillGrp).%New()  
    ///账单大类代码   CTBC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCBGCode=$tr(fieldValue,$c(0),"")
        //获取rowid
        set dataeobj.ARCBGRowId=$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.ARCBGCode),0)) 
    }
    /// 账单大类描述  CTBC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCBGDesc=$tr(fieldValue,$c(0),"")
    } 
    s result=##class(web.DHCBL.CT.ARCBillGrp).SaveEntity(dataeobj)
    q result
}

/// Function: 1.13.账单子类字典表(CT_BillChildCat)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table: CT_BillChildCat
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTBillChildCat(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.ARCBillSub).%New()  
    ///  账单大类代码    CTBCC_BillCategory 去找ParRef
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBCC_BillCategory","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set ARCBGCode=$tr(fieldValue,$c(0),"")
        set:ARCBGCode'="" dataeobj.ParentRowId=$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(ARCBGCode),0))  
    } 
    /// 账单子类代码  CTBCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCSGCode=$tr(fieldValue,$c(0),"") 
        //获取rowid
        if ((dataeobj.ParentRowId'="")&(dataeobj.ARCSGCode'=""))
        {
            set childsub=$o(^ARCBG("SG_Code",0,$$ALPHAUP^SSUTIL4(dataeobj.ARCSGCode),dataeobj.ParentRowId,0))
            if (childsub'="") set dataeobj.ARCSGRowId=dataeobj.ParentRowId_"||"_childsub 
        } 
        else
        {
            set dataeobj.ARCSGRowId=""
        }
    } 
    ///账单子类描述   CTBCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTBCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.ARCSGDesc=$tr(fieldValue,$c(0),"")  
    }  
    s result=##class(web.DHCBL.CT.ARCBillSub).SaveEntity(dataeobj)
    q result
}

/// Function:1.14.核算大类字典表(CT_EMChargeCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table: CT_EMChargeCategory
/// Input：数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTEMChargeCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息 CTEMCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarEC).%New()   
    /// 核算大类代码  CTEMCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTECCode=$tr(fieldValue,$c(0),"") 
        //获取rowid
         set dataeobj.TARTECRowId=$o(^DHCTarC("TEC",0,"Code",dataeobj.TARTECCode,0))    
    } 
    /// 核算大类名称  CTEMCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTECDesc=$tr(fieldValue,$c(0),"")  
    }   
    s result=##class(web.DHCBL.CT.DHCTarEC).SaveEntity(dataeobj)
    q result
}

/// Function:1.15.核算子类字典表(CT_EMChargeChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_EMChargeChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTEMChargeChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息  CTEMCCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarEMCCate).%New()   
    // CTEMCCC_ParentCode 核算大类代码
    set TARTECCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCCC_ParentCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value 
        set TARTECCode=$tr(fieldValue,$c(0),"") 
        set dataeobj.TARECTARTECDR = $o(^DHCTarC("TEC",0,"Code",TARTECCode,0))  
    } 
    /// 核算子类代码  CTEMCCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARECCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARECRowId=$o(^DHCTarC("EC",0,"Code",dataeobj.TARECCode,0))    
    } 
    /// CTEMCCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTEMCCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARECDesc=$tr(fieldValue,$c(0),"")  
    }   
    s result=##class(web.DHCBL.CT.DHCTarEMCCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.16.收费项大类字典表(CT_ChargeCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_ChargeCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTChargeCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息 CTCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarCate).%New()    
    /// 收费大类代码  CTCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARCRowId=$o(^DHCTarC("CC",0,"Code",dataeobj.TARCCode,0))    
    } 
    /// 收费大类名称  CTCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARCDesc=$tr(fieldValue,$c(0),"")  
    }   
    s result=##class(web.DHCBL.CT.DHCTarCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.17.收费项子类字典表(CT_ChargeChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_ChargeChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTChargeChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息 CTCCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarSubCate).%New()  
    /// 收费子类代码 CTCCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARSCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARSCRowId=$o(^DHCTarC("SC",0,"Code",dataeobj.TARSCCode,0))    
    } 
    /// 收费子类名称  CTCCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARSCDesc=$tr(fieldValue,$c(0),"")  
    }   
    
    /// 收费项大类  CTCCC_ParentCode 
    set TARCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTCCC_ParentCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set TARCCode=$tr(fieldValue,$c(0),"")  
        set dataeobj.TARSCTARCDR=$o(^DHCTarC("CC",0,"Code",TARCCode,0))    
    }    
    s result=##class(web.DHCBL.CT.DHCTarSubCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.18.会计大类字典表(CT_ACChargeCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_ACChargeCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTACChargeCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息 CTACCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarAC).%New()
    /// 会计大类代码  CTACCC_Code    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTACCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARTACRowId=$o(^DHCTarC("TAC",0,"Code",dataeobj.TARTACCode,0))    
    } 
    /// 会计大类名称  CTACCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTACDesc=$tr(fieldValue,$c(0),"")  
    }   
    s result=##class(web.DHCBL.CT.DHCTarAC).SaveEntity(dataeobj)
    q result
}

/// Function:1.19.会计子类字典表(CT_ACChargeChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_ACChargeChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTACChargeChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)   
    ///修改人信息 CTACCCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarAcctCate).%New()  
    /// 收费子类代码 CTACCCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARACCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARACRowId=$o(^DHCTarC("AC",0,"Code",dataeobj.TARACCode,0))    
    } 
    /// 收费子类名称  CTACCCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARACDesc=$tr(fieldValue,$c(0),"")  
    }   
    
    /// CTACCCC_ParentCode 大类
    set TARACode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTACCCC_ParentCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set TARACode=$tr(fieldValue,$c(0),"")  
        set dataeobj.TARACTARTACDR=$o(^DHCTarC("TAC",0,"Code",TARACode,0))    
    }     
    s result=##class(web.DHCBL.CT.DHCTarAcctCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.20.住院大类字典表(CT_IPChargeCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_IPChargeCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTIPChargeCategory(InputStream,tablename)
ClassMethod SaveCTIPChargeCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
 
    ///修改人信息 CTIPCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCC_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
   
     //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarIC).%New()    
    /// 住院大类代码  CTIPCC_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTICCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARTICRowId=$o(^DHCTarC("TIC",0,"Code",dataeobj.TARTICCode,0))    
    } 
    /// 住院大类名称  CTIPCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTICDesc=$tr(fieldValue,$c(0),"")  
    }   
    s result=##class(web.DHCBL.CT.DHCTarIC).SaveEntity(dataeobj)
    q result
}

/// Function:1.21.住院子类字典表(CT_IPChargeChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_IPChargeChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTIPChargeChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTIPCCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCCC_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarInpatCate).%New()  
    /// 住院子类代码  CTIPCCC_Code  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARICCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARICRowId=$o(^DHCTarC("IC",0,"Code",dataeobj.TARICCode,0))    
    } 
    ///住院子类名称   CTIPCCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARICDesc=$tr(fieldValue,$c(0),"")  
    }   
    ///住院大类代码  CTIPCCC_ParentCode 
    set TARICCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTIPCCC_ParentCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set TARICCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid ；
        set dataeobj.TARICTARTICDR=$o(^DHCTarC("TIC",0,"Code",TARICCCode,0))    
    }  
    s result=##class(web.DHCBL.CT.DHCTarInpatCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.22.门诊大类字典表(CT_OPChargeCategory) 
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_OPChargeCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTOPChargeCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTOPCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCC_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarOC).%New()   
    /// 门诊大类名称  CTOPCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTOCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARTOCRowId=$o(^DHCTarC("TOC",0,"Code",dataeobj.TARTOCCode,0))    
    } 
    /// 门诊大类名称  CTOPCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTOCDesc=$tr(fieldValue,$c(0),"")  
    }    
    s result=##class(web.DHCBL.CT.DHCTarOC).SaveEntity(dataeobj)
    q result
}

/// Function:1.23.门诊子类字典表(CT_OPChargeChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_OPChargeChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTOPChargeChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTOPCCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCCC_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarOutpatCate).%New()
    ///收费子类代码   CTOPCCC_Code    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TAROCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TAROCRowId=$o(^DHCTarC("OC",0,"Code",dataeobj.TAROCCode,0))    
    } 
    ///收费子类名称   CTOPCCC_Desc 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TAROCDesc=$tr(fieldValue,$c(0),"")  
    }   
    ///住院大类代码   CTIPCC_ParentCode
    set TARIOCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTOPCCC_ParentCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set TARIOCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TAROCTARTOCDR=$o(^DHCTarC("TOC",0,"Code",TARIOCCode,0))    
    }  
    s result=##class(web.DHCBL.CT.DHCTarOutpatCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.24.病案大类字典表(CT_MRChargeCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_MRChargeCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTMRChargeCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTMRCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCC_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarMC).%New()  
    /// 病案大类代码  CTMRCC_Code  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTMCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARTMCRowId=$o(^DHCTarC("TMC",0,"Code",dataeobj.TARTMCCode,0))    
    } 
    /// 病案大类名称  CTMRCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARTMCDesc=$tr(fieldValue,$c(0),"")  
    }    
    s result=##class(web.DHCBL.CT.DHCTarMC).SaveEntity(dataeobj)
    q result
}

/// Function:1.25.病案子类字典表(CT_MRChargeChildCategory)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_MRChargeChildCategory
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTMRChargeChildCategory(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTMRCCC_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCC_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarMRCate).%New()  
    /// 病案子类代码  CTMRCCC_Code  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCC_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARMCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARMCRowId=$o(^DHCTarC("MC",0,"Code",dataeobj.TARMCCode,0))    
    } 
    /// 病案子类名称  CTMRCCC_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCC_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TARMCDesc=$tr(fieldValue,$c(0),"")  
    }  
    /// 病案大类代码  CTIPCC_ParentCode 
    set TARIOCCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCC_ParentCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set TARIOCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.TARMCTARTMCDR=$o(^DHCTarC("TMC",0,"Code",TARIOCCode,0))    
    }    
    s result=##class(web.DHCBL.CT.DHCTarMRCate).SaveEntity(dataeobj)
    q result
}

/// Function:1.26.新病案大类字典表(CT_MRChargeCategoryNew)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_MRChargeCategoryNew
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTMRChargeCategoryNew(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTMRCCN_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCN_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCNewTarMC).%New()    
    /// 新病案大类代码 CTMRCCN_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCN_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.NTARTMCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.NTARTMCRowId=$o(^DHCTARMCNEW(0,"Code",dataeobj.NTARTMCCode,0))    
    } 
    /// 新病案大类名称 CTMRCCN_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCN_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.NTARTMCDesc=$tr(fieldValue,$c(0),"")  
    }    
    s result=##class(web.DHCBL.CT.DHCNewTarMC).SaveEntity(dataeobj)
    q result
}

/// Function:1.27.新病案子类字典表(CT_MRChargeChildCategoryNew) 
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_MRChargeChildCategoryNew
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTMRChargeChildCategoryNew(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTMRCCCN_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCCN_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCNewTarMRCate).%New()  
    /// 新病案子类代码 CTMRCCCN_Code  
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCCN_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.NTARMCCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.NTARMCRowId=$o(^DHCTARMRCATENEW(0,"Code",dataeobj.NTARMCCode,0))    
    } 
    /// 新新病案子类名称    CTMRCCCN_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCCN_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.NTARMCDesc=$tr(fieldValue,$c(0),"")  
    }    
    /// 新病案大类代码 CTMRCCCN_ParentCode
    set CTMRCCCNParentCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTMRCCCN_ParentCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value 
        set CTMRCCCNParentCode=$tr(fieldValue,$c(0),"")  
        set:CTMRCCCNParentCode'="" dataeobj.NTARMCDR=$o(^DHCTARMCNEW(0,"Code",CTMRCCCNParentCode,0)) 
    }    
    s result=##class(web.DHCBL.CT.DHCNewTarMRCate).SaveEntity(dataeobj)
    q result
}

/// Function: 1.52.药品单位字典表(CT_PHUnit)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_PHUnit
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTPHUnit(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTPHU_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHU_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTUOM).%New()   
    /// 代码  CTPHU_Code 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHU_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTUOMCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.CTUOMRowId=$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTUOMCode),0))    
    } 
    /// 描述  CTPHU_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHU_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTUOMDesc=$tr(fieldValue,$c(0),"")  
    }    
    //s result=##class(web.DHCBL.CT.CTUOM).SaveEntity(dataeobj)
    //q result
    if (dataeobj.CTUOMRowId="")       
    {
        s obj=##class(User.CTUOM).%New()
    }
    else                           
    {
        s obj=##class(User.CTUOM).%OpenId(dataeobj.CTUOMRowId)
        s bobj = ##class(web.Entity.CT.CTUOM).%New()
        s bobj.CTUOMRowId = dataeobj.CTUOMRowId
        s bobj.CTUOMCode = obj.CTUOMCode
        s bobj.CTUOMDesc = obj.CTUOMDesc 
    } 
    s obj.CTUOMCode = dataeobj.CTUOMCode
    s obj.CTUOMDesc = dataeobj.CTUOMDesc 
    Tstart
    s sc=obj.%Save() 
    do obj.%Close()
    if $$$ISOK(sc){
        Tcommit
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"
        d:dataeobj.CTUOMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_UOM","User.CTUOM","单位",id,dataeobj.CTUOMDesc,"A",dataeobj)
        d:dataeobj.CTUOMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_UOM","User.CTUOM","单位",id,dataeobj.CTUOMDesc,"U",dataeobj,bobj)
    }
    else{
        Trollback
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("单位","web.DHCBL.CT.CTUOM","SaveEntity",dataeobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
    }   
    q result
}

/// Function: 1.53.药品转换系数字典表(CT_PHConversionFactor)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_PHConversionFactor
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTPHConversionFactor(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTPHCF_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCF_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTConFac).%New()   
    /// 源单位代码   CTPHCF_SourceCode 
    s CTPHCFSourceCode = ""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCF_SourceCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTPHCFSourceCode=$tr(fieldValue,$c(0),"") 
        set dataeobj.CTCFFrUOMDR =$o(^CT("UOM",0,"Code",$zcvt(CTPHCFSourceCode,"U"),0)) 
    } 
    ///目标代码 CTPHCF_TargetCode 
    s CTPHCToSourceCode = ""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCF_TargetCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CTPHCToSourceCode = $tr(fieldValue,$c(0),"")  
        set dataeobj.CTCFToUOMDR=$o(^CT("UOM",0,"Code",$zcvt(CTPHCToSourceCode,"U"),0)) 
    }
    
    //获取rowid 
    if (dataeobj.CTCFToUOMDR'="")&(dataeobj.CTCFFrUOMDR'="")
    {
        set dataeobj.CTCFRowId=$o(^CT("CTCF",0,"UOM",dataeobj.CTCFFrUOMDR,dataeobj.CTCFToUOMDR,0)) 
    }
    else
    {
      set dataeobj.PHCGERowId=""  
    }
    ///药品转换系数   CTPHCF_Factor
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCF_Factor","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTCFFactor = $tr(fieldValue,$c(0),"")   
    } 
    set dataeobj.CTCFActiveFlag="Y"
    s result=##class(web.DHCBL.CT.CTConFac).SaveEntity(dataeobj)
    q result
}

/// Function:1.55.管制分类字典表(CT_PHCPoison)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_PHCPoison
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTPHCPoison(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTPHCP_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCP_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PHCPoison).%New()
    /// 代码  CTPHCP_Code    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCP_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCPOCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.PHCPORowId=$o(^PHCPO(0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PHCPOCode),0))    
    } 
    /// 描述  CTPHCP_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCP_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCPODesc=$tr(fieldValue,$c(0),"")  
    }    
   // s result=##class(web.DHCBL.CT.PHCPoison).SaveEntity(dataeobj)
    s flag=##class(web.DHCBL.CT.PHCPoison).FormValidate(dataeobj.PHCPORowId,dataeobj.PHCPOCode,dataeobj.PHCPODesc)  //调用重复验证
    if (flag=1)
    {
        q "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    if (dataeobj.PHCPORowId="")
    {   
        s obj=##class(User.PHCPoison).%New()
    }
    else
    {
        s obj=##class(User.PHCPoison).%OpenId(dataeobj.PHCPORowId)
        
        s bobj = ##class(web.Entity.CT.PHCPoison).%New()
        s bobj.PHCPORowId = dataeobj.PHCPORowId 
        s bobj.PHCPOCode = obj.PHCPOCode
        s bobj.PHCPODesc = obj.PHCPODesc
    } 
    s obj.PHCPOCode =$p(dataeobj.PHCPOCode,$c(13,10),1) 
    s obj.PHCPODesc = $p(dataeobj.PHCPODesc,$c(13,10),1)  
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc){
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"
        d:dataeobj.PHCPORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Poison","User.PHCPoison","管制药品分类",id,dataeobj.PHCPODesc,"A",dataeobj)
        d:dataeobj.PHCPORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PHC_Poison","User.PHCPoison","管制药品分类",id,dataeobj.PHCPODesc,"U",dataeobj,bobj)
    }else{
        Trollback
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("管制药品分类","web.DHCBL.CT.PHCPoison","SaveEntity",dataeobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
    } 
    q result
}

/// Function: 根据国家编码去反查区域代码
/// Creator:  sunfengchao
/// CreateDate:2018-08-10
/// Debug:    w ##class(web.DHCBL.BDP.Interface).GetRegionRowId("中国")
ClassMethod GetRegionRowId(CountryCode As %String) As %String
{
    Set Result=""
    Quit:CountryCode="" ""
    Set CountryDR= $Order(^CT("COU",0,"Code",$$ALPHAUP^SSUTIL4(CountryCode),0)) 
    Quit:CountryDR="" ""
    Set CTRGRowId=0
    For
    {
        Set CTRGRowId=$Order(^CT("RG",CTRGRowId)) 
        Quit:CTRGRowId=""
        Set CTRGCountryDR=$Piece($Get(^CT("RG",CTRGRowId)),"^",4)
        if (CTRGCountryDR=CountryDR)
        { 
            ; 只考虑 区域和国家是一对一的情况 ,默认找到了之后就退出循环
           /* If (Result="")
            {
                Set Result=CTRGRowId
            }
            Else
            {
                Set Result=Result_"^"_CTRGRowId
            }*/
            Set Result=CTRGRowId
            Quit
        } 
    }
    Quit Result
}

/// Function: 1.56.邮政编码字典表(CT_Postcode)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_Postcode
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTPostcode(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTZip).%New()    
    /// 代码  CTP_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTZIPCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.CTZIPRowId=$o(^CT("ZIP",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTZIPCode),0))    
    } 
    /// 描述 CTP_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTZIPDesc=$tr(fieldValue,$c(0),"")  
    }   
    /// CTP_StartDate 有效开始日期
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTZIPDateFrom=$tr(fieldValue,$c(0),"")  
    } 
    /// CTO_EndDate 有效结束日期
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_EndDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.CTZIPDateTo=$tr(fieldValue,$c(0),"")  
    } 
     
    ///国家代码 对应 码表中的 区域代码; 根据国家代码-> 区域代码   CTP_CountryCode
    set ConntryCode=""
    set RegionCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_CountryCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set ConntryCode=$tr(fieldValue,$c(0),"") 
        ; 查询区域rowid
        set:ConntryCode'="" dataeobj.CTZIPRegionDR= ##class(web.DHCBL.BDP.Interface).GetRegionRowId(ConntryCode)
    }  
    
    /// CTP_ProvinceCode 省代码
    set ProvinceCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_ProvinceCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set ProvinceCode=$tr(fieldValue,$c(0),"") 
        set:ProvinceCode'="" dataeobj.CTZIPProvinceDR= $o(^CT("PROV",0,"Code",$$ALPHAUP^SSUTIL4(ProvinceCode),0))
    }   
    ///  CTP_CityCode 市代码 
    set CityCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_CityCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CityCode=$tr(fieldValue,$c(0),"") 
        set:CityCode'="" dataeobj.CTZIPCITYDR= $o(^CT("CIT",0,"Code",$$ALPHAUP^SSUTIL4(CityCode),0))
    }  
    /// CTP_CountyCode 县代码 
    set CityAreaCode=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTP_CountyCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set CityAreaCode=$tr(fieldValue,$c(0),"") 
        set:CityAreaCode'="" dataeobj.CTZIPCITYAREADR= $o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(CityAreaCode),0))
    }  
   // s result=##class(web.DHCBL.CT.CTZip).SaveEntity(dataeobj)
    //q result
   s flag=##class(web.DHCBL.CT.CTZip).FormValidate(dataeobj.CTZIPRowId,dataeobj.CTZIPCode,dataeobj.CTZIPDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        { 
            s:dataeobj.CTZIPDateFrom'="" dataeobj.CTZIPDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.CTZIPDateFrom)
            s:dataeobj.CTZIPDateTo'="" dataeobj.CTZIPDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.CTZIPDateTo)     
            if (dataeobj.CTZIPRowId="")       
            {
                s obj=##class(User.CTZip).%New()
            }   
            else                           
            {
                s obj=##class(User.CTZip).%OpenId(dataeobj.CTZIPRowId) 
                s bobj = ##class(web.Entity.CT.CTZip).%New()
                s bobj.CTZIPRowId = dataeobj.CTZIPRowId
                s bobj.CTZIPCode = obj.CTZIPCode
                s bobj.CTZIPDesc = obj.CTZIPDesc
                if $IsObject(obj.CTZIPRegionDR){
                    s bobj.CTZIPRegionDR = obj.CTZIPRegionDR.%Id() 
                }
                if $IsObject(obj.CTZIPProvinceDR){
                    s bobj.CTZIPProvinceDR = obj.CTZIPProvinceDR.%Id() 
                }
                if $IsObject(obj.CTZIPCITYDR){
                    s bobj.CTZIPCITYDR = obj.CTZIPCITYDR.%Id() 
                }
                if $IsObject(obj.CTZIPHCADR){
                    s bobj.CTZIPHCADR = obj.CTZIPHCADR.%Id() 
                }
                if $IsObject(obj.CTZIPCITYAREADR){
                    s bobj.CTZIPCITYAREADR = obj.CTZIPCITYAREADR.%Id() 
                }
                s bobj.CTZIPDateFrom=obj.CTZIPDateFrom
                s bobj.CTZIPDateTo=obj.CTZIPDateTo
            
            }
            s obj.CTZIPCode = dataeobj.CTZIPCode
            s obj.CTZIPDesc = dataeobj.CTZIPDesc
            d obj.CTZIPRegionDRSetObjectId(dataeobj.CTZIPRegionDR)
            d obj.CTZIPProvinceDRSetObjectId(dataeobj.CTZIPProvinceDR)
            d obj.CTZIPCITYDRSetObjectId(dataeobj.CTZIPCITYDR)
            d obj.CTZIPHCADRSetObjectId(dataeobj.CTZIPHCADR)
            d obj.CTZIPCITYAREADRSetObjectId(dataeobj.CTZIPCITYAREADR)   
            s obj.CTZIPDateFrom=dataeobj.CTZIPDateFrom
            s obj.CTZIPDateTo=dataeobj.CTZIPDateTo 
            Tstart
            s sc=obj.%Save()
            do obj.%Close()
            if $$$ISOK(sc){
                Tcommit
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"
                d:dataeobj.CTZIPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Zip","User.CTZip","邮编",id,dataeobj.CTZIPDesc,"A",dataeobj)
                d:dataeobj.CTZIPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Zip","User.CTZip","邮编",id,dataeobj.CTZIPDesc,"U",dataeobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"     
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("邮编","web.DHCBL.CT.CTZip","SaveEntity",dataeobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
            }
        }   
    q result
}

/// Function: 1.57.药品通用名字典表(CT_PHCGeneric)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_PHCGeneric
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTPHCGeneric(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTPHCG_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCG_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.PHCGeneric).%New()    
    /// 代码  CTPHCG_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCG_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCGECode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.PHCGERowId=$o(^PHCGE("GE",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.PHCGECode),0))    
    } 
     
    /// 描述  CTPHCG_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCG_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCGEName=$tr(fieldValue,$c(0),"")  
    }
     
    /// 开始日期   CTPHCG_StartDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCG_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCGEDateFrom=$tr(fieldValue,$c(0),"")  
    } 
   
    /// 有效截止日期 CTPHCG_EndDate 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTPHCG_EndDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.PHCGEDateTo= $tr(fieldValue,$c(0),"")  
    } 
    s result=##class(web.DHCBL.CT.PHCGeneric).SaveEntity(dataeobj)
    q result
}

/// Function: 1.62.诊断字典表(CT_Diagnose)  
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_Diagnose
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTDiagnose(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息 CTD_UpdateUserCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.MRCICDDx).%New()    
    /// 诊断代码 CTD_Code
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.MRCIDCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.MRCIDRowId=$o(^MRC("ID",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.MRCIDCode),0))    
    } 
    /// 诊断描述 CTD_Desc
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.MRCIDDesc=$tr(fieldValue,$c(0),"")  
    }   
    /// CTD_ICDCode ICD代码
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_ICDCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.MRCIDICD9CMCode=$tr(fieldValue,$c(0),"")  
    }   
    ///有效开始日期   CTD_StartDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.MRCIDDateActiveFrom=$tr(fieldValue,$c(0),"")  
    } 
    /// 有效结束日期  CTD_EndDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_EndDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.MRCIDDateActiveTo=$tr(fieldValue,$c(0),"")  
    } 
    set dataeobj.MRCIDValid="Y"
    
    //  肿瘤形态学状态获取 add by xieyejian 20190508 start
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTD_MetastaticSite","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.MRCIDMetastaticSite=$tr(fieldValue,$c(0),"")
    } 
    //  肿瘤形态学状态获取 add by xieyejian 20190508 end
    //s result=##class(web.DHCBL.CT.MRCICDDx).SaveEntity(dataeobj)
   // q result
   s:dataeobj.MRCIDDateActiveFrom'="" dataeobj.MRCIDDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.MRCIDDateActiveFrom)
    s:dataeobj.MRCIDDateActiveTo'="" dataeobj.MRCIDDateActiveTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.MRCIDDateActiveTo)
    s:dataeobj.MRCIDDateActiveFrom="" dataeobj.MRCIDDateActiveFrom=+$h 
    if (dataeobj.MRCIDRowId="")  //如果RowId未赋值则增加
    {
        s obj=##class(User.MRCICDDx).%New()
    }
    else                     //如果RowId已赋值则修改
    {
        s obj=##class(User.MRCICDDx).%OpenId(dataeobj.MRCIDRowId)
        s bobj=##class(web.Entity.CT.MRCICDDx).%New()
        s bobj.MRCIDRowId = dataeobj.MRCIDRowId
        s bobj.MRCIDCode = obj.MRCIDCode
        s bobj.MRCIDDesc = obj.MRCIDDesc
        s bobj.MRCIDICD9CMCode = obj.MRCIDICD9CMCode
        s bobj.MRCIDDateActiveFrom = obj.MRCIDDateActiveFrom
        s bobj.MRCIDDateActiveTo = obj.MRCIDDateActiveTo 
    }                  
    s obj.MRCIDCode = dataeobj.MRCIDCode
    s obj.MRCIDDesc = dataeobj.MRCIDDesc  
    s obj.MRCIDICD9CMCode = dataeobj.MRCIDICD9CMCode   //ICD10代码
    s obj.MRCIDDateActiveFrom = dataeobj.MRCIDDateActiveFrom
    s obj.MRCIDDateActiveTo = dataeobj.MRCIDDateActiveTo
    s obj.MRCIDMetastaticSite = dataeobj.MRCIDMetastaticSite    //肿瘤形态学 add by xieyejian 20180508 start/end 
    Ts
    s sc=obj.%Save()
    d obj.%Close()
    If $$$ISOK(sc)
    {
        Tc
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"         
        //保存日志
        d:dataeobj.MRCIDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.MRCICDDx","ICD诊断代码",id,dataeobj.MRCIDDesc,"A",dataeobj)
        d:dataeobj.MRCIDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("MRC_ICDDx","User.MRCICDDx","ICD诊断代码",dataeobj.MRCIDRowId,dataeobj.MRCIDDesc,"U",dataeobj,bobj)
    }
    else
    {
        Trollback
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("ICD诊断代码","web.DHCBL.CT.MRCICDDx","SaveEntity",dataeobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        s result= "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
    } 
  q result
}

/// Function: 1.63.手术字典表(CT_Operation)
/// Creator: sunfengchao
/// CreateDate:2018-08-07
/// Table:  CT_Operation
/// Input： 数据,tablename:第三方的表名
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveCTOperation(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
    k dataeobj
    s dataeobj=##class(web.Entity.CT.ORCOperation).%New()    
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_Code","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.OPERCode=$tr(fieldValue,$c(0),"") 
        //获取rowid 
        set dataeobj.OPERRowId=$o(^ORC("OPER",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.OPERCode),0))    
    } 
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.OPERDesc=$tr(fieldValue,$c(0),"")  
    }   
    /// CTO_ICDCode
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_ICDCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.OPERICD10=$tr(fieldValue,$c(0),"")  
    }   
    /// CTO_StartDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.OPERDateActiveFrom=$tr(fieldValue,$c(0),"")  
    } 
    /// CTO_EndDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"List/"_tablename_"/CTO_EndDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.OPERActiveDateTo=$tr(fieldValue,$c(0),"")  
    } 
    set dataeobj.OPERValid="Y"
    //s result=##class(web.DHCBL.CT.ORCOperation).SaveEntity(dataeobj)
    //q result
     s:dataeobj.OPERDateActiveFrom="" dataeobj.OPERDateActiveFrom = +$h
    s:dataeobj.OPERDateActiveFrom'="" dataeobj.OPERDateActiveFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.OPERDateActiveFrom)
    s:dataeobj.OPERActiveDateTo'="" dataeobj.OPERActiveDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(dataeobj.OPERActiveDateTo) 
    if (dataeobj.OPERRowId="")       
    {
        s obj=##class(User.ORCOperation).%New()
    }
    else                           
    {
        s obj=##class(User.ORCOperation).%OpenId(dataeobj.OPERRowId) 
        s bobj = ##class(web.Entity.CT.ORCOperation).%New()
        s bobj.OPERRowId = dataeobj.OPERRowId
        s bobj.OPERCode = obj.OPERCode
        s bobj.OPERDesc = obj.OPERDesc 
        s bobj.OPERDateActiveFrom=obj.OPERDateActiveFrom
        s bobj.OPERActiveDateTo=obj.OPERActiveDateTo  
        s bobj.OPERICD10 =obj.OPERICD10 
    } 
    s obj.OPERCode = dataeobj.OPERCode
    s obj.OPERDesc = dataeobj.OPERDesc 
    s obj.OPERDateActiveFrom=dataeobj.OPERDateActiveFrom
    s obj.OPERActiveDateTo=dataeobj.OPERActiveDateTo 
    s obj.OPERICD10 = eobj.OPERICD10 
    s obj.OPERValid = eobj.OPERValid         
    Tstart
    s sc=obj.%Save()
    do obj.%Close()
    if $$$ISOK(sc){
        Tcommit
        s id = obj.%Id()
        s result = "{success:'true',id:'"_id_"'}"
        d:dataeobj.OPERRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Operation","User.ORCOperation","手术/过程",id,dataeobj.OPERDesc,"A",dataeobj)
        d:dataeobj.OPERRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ORC_Operation","User.ORCOperation","手术/过程",id,dataeobj.OPERDesc,"U",dataeobj,bobj)
    }else{
        Trollback
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("手术/过程","web.DHCBL.CT.ORCOperation","SaveEntity",dataeobj)
        s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
    }  
    q result
}

/// Function:   1. 76. 1.收费项目价格表的列清单
/// Creator:    sunfengchao
/// CreateDate: 2018-08-20
/// TableName:  CT_ChargeItemPrice
/// Debug:      w ##class().SaveCTChargeItemPrice()
ClassMethod SaveCTChargeItemPrice(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
    set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)  
    ///修改人信息
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_UpdateUserCode","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set UpdateUserCode=$tr(fieldValue,$c(0),"")
        d ##class(web.DHCBL.BDP.Interface).GetSession(UpdateUserCode)
    }
    //同步数据信息   
 
    k dataeobj
    s dataeobj=##class(web.Entity.CT.DHCTarItemPrice).%New()   
    ///   价格表主键  CTCIP_RowId
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_RowId","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value 
        set dataeobj.TPRowId=$tr(fieldValue,$c(0),"")   
    } 
    ///  收费项代码  CTCIP_ChargeItemCode
    set TARICode=""     
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_ChargeItemCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set TARICode=$tr(fieldValue,$c(0),"")  
         //获取rowid 
        set dataeobj.TPTARIParRef=$o(^DHCTARI(0,"Code",TARICode,0))  
    }    
    ///  患者费别代码： CTCIP_CostCategoryCode
    set TPPatInsType=""
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_CostCategoryCode","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                  
        set fieldValue=tRes.GetAt(1).Value
        set TPPatInsType=$tr(fieldValue,$c(0),"")  
        set dataeobj.TPPatInsType=$o(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(TPPatInsType),0))
    } 
    
    ///  收费项价格： CTCIP_Price
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_Price","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TPPrice=$tr(fieldValue,$c(0),"")  
    }   
    /// 有效开始日期  CTCIP_StartDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_StartDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TPStartDate=$tr(fieldValue,$c(0),"")  
    } 
    ///有效结束日期  CTCIP_EndDate
    set tSC=tDocument.EvaluateExpression("/Request/Body/"_tablename_"/CTCIP_EndDate","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.TPEndDate=$tr(fieldValue,$c(0),"")  
    }   
    s result=##class(web.DHCBL.CT.DHCTarItemPrice).SaveEntity(dataeobj)
    q result
}

/// Function:收费项价格 测试 
/// w ##class(web.DHCBL.BDP.Interface).Test4()
ClassMethod Test4()
{
    ///日期格式YYYY-MM-DD
    set stream=##class(%Stream.GlobalCharacter).%New()
    do stream.Write("<Request><Header><SourceSystem>30</SourceSystem><MessageID></MessageID></Header><Body><CT_CareProvList><CT_CareProv><BusinessFieldCode>00001</BusinessFieldCode><CTCP_AdminiPosition></CTCP_AdminiPosition><CTCP_ArrivalHosDate></CTCP_ArrivalHosDate><CTCP_BirthDate></CTCP_BirthDate><CTCP_BirthPlace></CTCP_BirthPlace><CTCP_CareProvPositionCode></CTCP_CareProvPositionCode><CTCP_CareProvTypeCode>232</CTCP_CareProvTypeCode><CTCP_Code>PS0003498</CTCP_Code><CTCP_CodesystemCode>CT_CareProv</CTCP_CodesystemCode><CTCP_CreatDate></CTCP_CreatDate><CTCP_CreatTime></CTCP_CreatTime><CTCP_CurrDeptDate></CTCP_CurrDeptDate><CTCP_DeptCode></CTCP_DeptCode><CTCP_DeptHierarchyCode>820002</CTCP_DeptHierarchyCode><CTCP_Desc>测试人员2</CTCP_Desc><CTCP_EducationCode></CTCP_EducationCode><CTCP_Email></CTCP_Email><CTCP_EmploymentDate></CTCP_EmploymentDate><CTCP_EndDate></CTCP_EndDate><CTCP_ExtranetURL></CTCP_ExtranetURL><CTCP_HosCode>Org82</CTCP_HosCode><CTCP_IDCardNO></CTCP_IDCardNO><CTCP_IDCardTypeCode></CTCP_IDCardTypeCode><CTCP_ImageInfo></CTCP_ImageInfo><CTCP_IntranetURL></CTCP_IntranetURL><CTCP_JobNumber>CSRY002</CTCP_JobNumber><CTCP_Name>测试人员2</CTCP_Name><CTCP_NationCode>1</CTCP_NationCode><CTCP_NativePlace></CTCP_NativePlace><CTCP_OriginalCode></CTCP_OriginalCode><CTCP_OriginalDesc></CTCP_OriginalDesc><CTCP_PassWord></CTCP_PassWord><CTCP_PoliticalAffiliation></CTCP_PoliticalAffiliation><CTCP_PoliticalJoinDate></CTCP_PoliticalJoinDate><CTCP_PositionSeqCode></CTCP_PositionSeqCode><CTCP_PositionStatus>01</CTCP_PositionStatus><CTCP_PracCertiCode></CTCP_PracCertiCode><CTCP_QualiCertiCode></CTCP_QualiCertiCode><CTCP_RegistResidence></CTCP_RegistResidence><CTCP_Remarks></CTCP_Remarks><CTCP_RetireDate></CTCP_RetireDate><CTCP_SexCode></CTCP_SexCode><CTCP_Spell></CTCP_Spell><CTCP_StaffCat></CTCP_StaffCat><CTCP_StaffTypeCode></CTCP_StaffTypeCode><CTCP_StartDate></CTCP_StartDate><CTCP_Status>1</CTCP_Status><CTCP_Telephone></CTCP_Telephone><CTCP_TitleEmployDate></CTCP_TitleEmployDate><CTCP_TitleOfTechCode>232</CTCP_TitleOfTechCode><CTCP_TitleOfTechLevel>2</CTCP_TitleOfTechLevel><CTCP_UpdateDate></CTCP_UpdateDate><CTCP_UpdateTime></CTCP_UpdateTime><CTCP_UpdateUserCode></CTCP_UpdateUserCode><CTCP_UrbanRegiResiFlag></CTCP_UrbanRegiResiFlag></CT_CareProv></CT_CareProvList></Body></Request>")
    
    set responseStream=..SaveCTCareProv(stream,"CT_CareProv")
    q responseStream
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// Description：医疗机构信息保存
/// Input：数据,表名(CT_RefClin)
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTRefClin(stream,tablename)
ClassMethod SaveCTRefClin(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
	//同步父表信息
	k dataeobj
	s dataeobj=##class(web.Entity.CT.CTRefClin).%New() 
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_RowId","text()",.tRes)                  
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCCode=$tr(fieldValue,$c(0),"")
	    //获取rowid
	    set:dataeobj.CTRFCCode'="" dataeobj.CTRFCRowId=$o(^CT("RFC",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTRFCCode),0))
	}
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_Desc","text()",.tRes)                  
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCDesc=$tr(fieldValue,$c(0),"")
	}
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_StartDate","text()",.tRes)                 
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCDateFrom=$tr(fieldValue,$c(0),"")
	}
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_EndDate","text()",.tRes)                   
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCDateTo=$tr(fieldValue,$c(0),"")
	}
	//子表三个信息在父表保存
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_OrganizationCode","text()",.tRes)                  
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCSociaCreditCode=$tr(fieldValue,$c(0),"")
	}
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_Remarks","text()",.tRes)                 
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCAddress=$tr(fieldValue,$c(0),"")
	}
	set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_ArtificialPerson","text()",.tRes)                   
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
	    set fieldValue=tRes.GetAt(1).Value
	    set dataeobj.CTRFCPersonName=$tr(fieldValue,$c(0),"")
	}
		
	s dataeobj.CTRFCActiveFlag="Y"
	s result=##class(web.DHCBL.CT.CTRefClin).SaveEntity(dataeobj)
	if (result["success:'true'")
	{
		//同步子表信息
		k dataeobj
		s dataeobj=##class(web.Entity.CT.CTRefClinExtend).%New() 
		set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_RowId","text()",.tRes)                  
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
		    set fieldValue=tRes.GetAt(1).Value
		    set dataeobj.CTRFCCode=$tr(fieldValue,$c(0),"")
		    //获取rowid
		    set:dataeobj.CTRFCCode'="" dataeobj.CTRFCRowId=$o(^CT("RFC",0,"Code",$$ALPHAUP^SSUTIL4(dataeobj.CTRFCCode),0))
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_President","text()",.tRes)                   
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
		    set fieldValue=tRes.GetAt(1).Value
		    set dataeobj.CTRFCGeneMgr=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/CT_HospitalList/CT_Hospital/CTH_ParentCode","text()",.tRes)                   
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
		    set fieldValue=tRes.GetAt(1).Value
		    set dataeobj.CTRFCParentOrgCode=$tr(fieldValue,$c(0),"")
		}
		s result=##class(web.DHCBL.CT.CTRefClinExtend).SaveEntity(dataeobj)
	}
	q result
}

/// Creator：基础数据平台-likefan
/// CreatDate: 2020-07-25
/// Description：组织部门信息保存
/// Input：数据,表名(CT_Org)
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// w ##class(web.DHCBL.BDP.Interface).SaveCTDepartment(stream,tablename)
ClassMethod SaveCTDepartment(InputStream As %Stream.GlobalCharacter, tablename As %String) As %String
{
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(InputStream,.tDocument)
    //同步数据信息
    k dataeobj
    s dataeobj=##class(web.Entity.CT.CTDepartment).%New()
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_RowId","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPRowId=$tr(fieldValue,$c(0),"")
        //获取rowid
        set:dataeobj.DEPRowId'="" dataeobj.ID=$o(^User.CTDepartmentI("DEPRowIdRef",dataeobj.DEPRowId,0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Code","text()",.tRes)                  
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPCode=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Desc","text()",.tRes)                 
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPDesc=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Phonetic","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPAlias=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_OfficePhone","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPOfficePhone=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_MajorCat","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPCategory=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_ParentCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set DEPParentCode=$tr(fieldValue,$c(0),"")
        set:DEPParentCode'="" dataeobj.DEPParentDR=$o(^User.CTDepartmentI("DEPRowIdRef",DEPParentCode,0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_HosCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set DEPRefClinCode=$tr(fieldValue,$c(0),"")
        set:DEPRefClinCode'="" dataeobj.DEPRefClinDR=$o(^CT("RFC",0,"Code",$$ALPHAUP^SSUTIL4(DEPRefClinCode),0))
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Atrribute","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPAtrribute=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_UpdateUserCode","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPUpdateUserName=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Property","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPCharacter=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_PayType","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPPayAtrribute=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_PurchaseFlag","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPPurchaseFlag=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Share","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPShareCharacter=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_StartDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPDateFrom=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_EndDate","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPDateTo=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_Statistics","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPNationalCode=$tr(fieldValue,$c(0),"")
    }
    set tSC=tDocument.EvaluateExpression("/Request/Body/CT_DeptList/CT_Dept/CTD_OfficeAddress","text()",.tRes)                   
    if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){                 
        set fieldValue=tRes.GetAt(1).Value
        set dataeobj.DEPOfficeAddress=$tr(fieldValue,$c(0),"")
    }
    s result=##class(web.DHCBL.CT.CTDepartment).SaveEntity(dataeobj)
    q result
}

}

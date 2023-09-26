/// Function:  基础数据 数据视图
/// CreateDate:2020-10-13
/// Creator:  sunfengchao 
Class web.DHCBL.BDP.BDPDataView Extends %RegisteredObject
{

/// //////////以下为 药物不良事件接口 ////////////////
/// Function:  药物不良事件- 医嘱频次 
/// Table:     adr_his_usingTimes
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisusingTimesList")
Query GetAdrHisusingTimesList() As %Query(ROWSPEC = "usingTimesId,usingTimes,remark")
{
}

ClassMethod GetAdrHisusingTimesListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s PHCFRRowId=0
    for
    {
        s PHCFRRowId=$o(^PHCFR(PHCFRRowId)) 
        q:PHCFRRowId=""
        s usingTimesId=PHCFRRowId //    医嘱频次Id  
        s usingTimes = $p($g(^PHCFR(PHCFRRowId)),"^",4) //   医嘱频次
        s remark="" //  备注  
        d HISusingTimesOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISusingTimesOutputRow 
    set ^CacheTemp(repid,ind)=$lb(usingTimesId,usingTimes,remark)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisusingTimesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisusingTimesListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisusingTimesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisusingTimesListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  药物不良事件- 医院职工人员信息表
/// Table:     adr_his_employee 
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisEmployeeList")
Query GetAdrHisEmployeeList() As %Query(ROWSPEC = "loginId,loginName,sex,birth,departmentId,department,occupation,occupationTitle,phone,email,isEnabled,py")
{
}

ClassMethod GetAdrHisEmployeeListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s SSUSRRowId=0
    for  
    {
        
        s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""
        s loginId=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",1)       // 工号 主键，唯一标识
        s loginName=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",2)       // 姓名
        s sex =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",123)  //性别，1：男；2：女
        s:sex="1" sex="男"  
        s:sex="2" sex="女"
        s department=""             
        s departmentId=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",4)     // 所属科室ID 
        s:departmentId'="" department=$p($g(^CTLOC(departmentId)),"^",2)  // 所属科室   
        s phone =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",124)  // 电话号码 
        s SSUSRMobile =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",99)  //手机号
        s SSUSRPager =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",100)  //办公室电话
        s email =$p($g(^SSU("SSUSR",SSUSRRowId)),"^",101)  //邮箱  
        s isEnabled=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)      //是否激活  是否在职    int 1：在职，0：不在职
        s:(isEnabled="Y")||(isEnabled="1") isEnabled="在职"  
        s:(isEnabled="N")||(isEnabled="0") isEnabled="不在职"
        s birth=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",19)   // 出生日期，日期型格式：YYYY-MM-DD
        s:birth'="" birth=$zd(birth,3)   
        s SSUSRCareProvDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",14)      //医护人员DR
        s occupationTitle="",py="" 
        s occupation=""
        s:SSUSRCareProvDR="" py=##class(web.DHCBL.BDP.FunLib).GetPYCODE(loginName)  
        if (SSUSRCareProvDR'="")
        {
            s py=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",28)  //姓名拼音码
            s occupationTitle=$p($g(^CTPCP(SSUSRCareProvDR,3)),"^",29)  // 职称 如住院医师、主治医师、主任医师等
            s:occupationTitle'="" occupationTitle=$p($g(^CTPCP("TTL",occupationTitle)),"^",2)
            s occupation =$p($g(^CTPCP(SSUSRCareProvDR,1)),"^",4) //医护人员类型   职业 医院对职工的职业区分，如医生、护士、药师、其他  
            s:occupation'="" occupation= $p($g(^CT("CPT",occupation)),"^",2) 
        } 
        d AdrHisEmployeeOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
AdrHisEmployeeOutputRow 
    set ^CacheTemp(repid,ind)=$lb(loginId,loginName,sex,birth,departmentId,department,occupation,occupationTitle,phone,email,isEnabled,py)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisEmployeeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisEmployeeListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisEmployeeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisEmployeeListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  药物不良事件- 医院科室信息表 
/// Table:     adr_his_department 
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisDepartmentList")
Query GetAdrHisDepartmentList() As %Query(ROWSPEC = "departmentId,department,py,parentDepartId")
{
}

ClassMethod GetAdrHisDepartmentListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s CTLOCRowID=0
    for  
    {
        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) 
        q:CTLOCRowID=""
        s departmentId=$p($g(^CTLOC(CTLOCRowID)),"^",1)        //科室ID     主键，唯一标识 科室代码 
        s department= $p($g(^CTLOC(CTLOCRowID)),"^",2)     ///   科室名称   
        s py=##class(web.DHCBL.BDP.FunLib).GetPYCODE(department)    //  拼音编码   
        s parentDepartId =$p($g(^CTLOC(CTLOCRowID)),"^",19)  ///    上级科室ID 
        s:parentDepartId'="" parentDepartId=$p($g(^RBC("DEP",parentDepartId)),"^",2)  //科室部门组描述  
        d HISDepartmentOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISDepartmentOutputRow 
    set ^CacheTemp(repid,ind)=$lb(departmentId,department,py,parentDepartId)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisDepartmentListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisDepartmentListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisDepartmentListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisDepartmentListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// //////////以下为 医疗设备管理接口 ////////////////
/// Function:  医疗设备-收费项目 
/// Table:     V_MEIS_HIS_DictChargeItem
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetDictChargeItemList")
Query GetDictChargeItemList() As %Query(ROWSPEC = "ChargeClassCode,ChargeClassName,ChargeItemCode,ChargeItemName,PriceClassCode,PriceClassName,PriceCode,ChargeItemUnit,ChargeItemPrice,StartDate,StopDate,EnterDate")
{
}

ClassMethod GetDictChargeItemListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s TARIRowId=0
    for
    {
        s TARIRowId=$o(^DHCTARI(TARIRowId)) 
        q:TARIRowId=""
  
        s ChargeItemCode= $p($g(^DHCTARI(TARIRowId)),"^",1)      //  收费项编码   
        s ChargeItemName = $p($g(^DHCTARI(TARIRowId)),"^",2)   ///   收费项名称 
        s TARISubCate =$p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项目子类
        s ChargeClassCode=""  
        s ChargeClassName= "" 
        s:TARISubCate'="" ChargeClassCode=$p($g(^DHCTarC("SC",TARISubCate)),"^",1)  //收费类别编码
        s:TARISubCate'="" ChargeClassName=$p($g(^DHCTarC("SC",TARISubCate)),"^",2) /// 收费类别名称 
        s PriceClassCode ="" // 物价分类编码 
        s PriceClassName =""  // 物价分类名称
        s PriceCode =""  //   物价编码
        s ChargeItemUnit =$p($g(^DHCTARI(TARIRowId)),"^",3)            //  收费项目单位   
        s:ChargeItemUnit'="" ChargeItemUnit=$p($g(^CT("UOM",ChargeItemUnit)),"^",2)
        s ChargeItemPrice=##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(TARIRowId)  //收费项目单价 
        s StartDate=$p($g(^DHCTARI(TARIRowId)),"^",11)  // 启用日期，日期型格式：YYYY-MM-DD
        s:StartDate'="" StartDate=$zd(StartDate,3)    
        s StopDate=$p($g(^DHCTARI(TARIRowId)),"^",12)    // 停止日期
        s:StopDate'="" StopDate=$zd(StopDate,3)    
        s EnterDate=""     // 录入日期 
        s:EnterDate'="" EnterDate=$zd(EnterDate,3) 
        d DictChargeItemOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
DictChargeItemOutputRow  
    set ^CacheTemp(repid,ind)=$lb(ChargeClassCode,ChargeClassName,ChargeItemCode,ChargeItemName,PriceClassCode,PriceClassName,PriceCode,ChargeItemUnit,ChargeItemPrice,StartDate,StopDate,EnterDate)
    Set ind=ind+1
    quit
}

ClassMethod GetDictChargeItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDictChargeItemListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetDictChargeItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDictChargeItemListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  医疗设备- 医院科室 
/// Table:     CT_Loc
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisSectionList")
Query GetAdrHisSectionList() As %Query(ROWSPEC = "SectionCode,SectionName,pSectonCode,pSectonName")
{
}

ClassMethod GetAdrHisSectionListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s CTLOCRowID=0
    for  
    {
        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) 
        q:CTLOCRowID=""
        
        
        s SectionCode=$p($g(^CTLOC(CTLOCRowID)),"^",1)        // 科室代码 
        s SectionName= $p($g(^CTLOC(CTLOCRowID)),"^",2)     ///   科室名称  
        s parentDepartId =$p($g(^CTLOC(CTLOCRowID)),"^",19)  /// 上级科室ID 
        s pSectonName="",pSectonCode=""
        s:parentDepartId'="" pSectonName=$p($g(^RBC("DEP",parentDepartId)),"^",2)  //当科室为二级科室时，此字段为二级科室所属的一级科室
        s:parentDepartId'="" pSectonCode=$p($g(^RBC("DEP",parentDepartId)),"^",2)  //当科室为二级科室时，此字段为二级科室所属的一级科室 
        d HisSectionOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HisSectionOutputRow 
    set ^CacheTemp(repid,ind)=$lb(SectionCode,SectionName,pSectonCode,pSectonName)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisSectionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisSectionListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisSectionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisSectionListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  医疗设备- 病区 
/// Table:     V_MEIS_HIS_Ward
/// CreateDate:2020-10-14
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisWardList")
Query GetAdrHisWardList() As %Query(ROWSPEC = "WardCode,WardName,SectionCode,SectionName")
{
}

ClassMethod GetAdrHisWardListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1   
    s WARDRowID=0
    for  
    {
        s WARDRowID=$o(^PAWARD(WARDRowID)) 
        q:WARDRowID=""
        s WardCode=$p($g(^PAWARD(WARDRowID)),"^",1)        //病区代码
        s WardName= $p($g(^PAWARD(WARDRowID)),"^",2)     ///  病区名称
        s WARDLocationDR= $p($g(^PAWARD(WARDRowID)),"^",5)    ///  所属科室 
        s SectionCode="",SectionName=""
        if (WARDLocationDR'="") 
        {
            s SectionCode =$p($g(^CTLOC(WARDLocationDR)),"^",1)  ///  所属科室代码
            s SectionName=$p($g(^CTLOC(WARDLocationDR)),"^",2)  //所属科室名称
        }
        d HISWardOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISWardOutputRow 
    set ^CacheTemp(repid,ind)=$lb(WardCode,WardName,SectionCode,SectionName)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisWardListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisWardListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  医疗设备- 医院床位 
/// Table:     adr_his_Bed
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisBedList")
Query GetAdrHisBedList() As %Query(ROWSPEC = "BedCode,WardCode,WardName,SectionCode,SectionName")
{
}

ClassMethod GetAdrHisBedListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s WARDRowID=0
    for  
    {
        s WARDRowID=$o(^PAWARD(WARDRowID)) 
        q:WARDRowID="" 
        s rowid=0
        for
        {
            s rowid=$o(^PAWARD(WARDRowID,"BED",rowid)) 
            q:rowid=""
            
            s BedCode=$p($g(^PAWARD(WARDRowID,"BED",rowid)),"^",1)  /// 床位代码
            s WardCode=$p($g(^PAWARD(WARDRowID)),"^",1)        //病区代码
            s WardName= $p($g(^PAWARD(WARDRowID)),"^",2)     ///  病区名称
            s WARDLocationDR= $p($g(^PAWARDA(WARDRowID,"BED",rowid,"EXP",1)),"^",1)    ///  所属科室  EXPLocDR
            s SectionCode="",SectionName=""
            if (WARDLocationDR'="") 
            {
                s SectionCode =$p($g(^CTLOC(WARDLocationDR)),"^",1)  ///  所属科室代码
                s SectionName=$p($g(^CTLOC(WARDLocationDR)),"^",2)  //所属科室名称
            }  
            d HISBedOutputRow 
        }    
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISBedOutputRow 
    set ^CacheTemp(repid,ind)=$lb(BedCode,WardCode,WardName,SectionCode,SectionName)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisBedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisBedListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisBedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisBedListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:   医疗设备- 医生表
/// Table:     V_MEIS_HIS_Doctor
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisDoctorList")
Query GetAdrHisDoctorList() As %Query(ROWSPEC = "AccountCode,AccountName,UserCode,SectionCode ,SectionName,Telphone,JobCode,JobName,StartTime,EndTime")
{
}

ClassMethod GetAdrHisDoctorListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1  
    s CTPCPRowId1=0
    for  
    {               
        s CTPCPRowId1=$o(^CTPCP(CTPCPRowId1)) 
        q:CTPCPRowId1=""
        
        s AccountCode=$p($g(^CTPCP(CTPCPRowId1,1)),"^",1)       //工号
        s AccountName=$p($g(^CTPCP(CTPCPRowId1,1)),"^",2)       //姓名
        s UserCode=AccountCode  // 系统账号
        s SSUserID=""
        s:$$ALPHAUP^SSUTIL4(AccountCode)'="" SSUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(AccountCode),0)) 
        continue:SSUserID=""
        s departmentId=$p($g(^SSU("SSUSR",SSUserID)),"^",4)     // 所属科室ID 
        s SectionCode="",SectionName=""
        s:departmentId'="" SectionCode=$p($g(^CTLOC(departmentId)),"^",1)  // 所属科室代码
        s:departmentId'="" SectionName=$p($g(^CTLOC(departmentId)),"^",2)  // 所属科室名称
        s Telphone =$p($g(^SSU("SSUSR",SSUserID)),"^",99)  //手机号  
        s JobCode ="" //专业技术职务代码
        s JobName ="" //专业技术职务代码对应名称
        s StartTime=$p($g(^CTPCP(CTPCPRowId1,2)),"^",14)    // 角色有效时间(起始)
        s EndTime=$p($g(^CTPCP(CTPCPRowId1,2)),"^",15)     //角色有效时间(结束) 
        s:StartTime'="" StartTime=$zd(StartTime,3)   
        s:EndTime'="" EndTime=$zd(EndTime,3) 
        d HISDoctorOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISDoctorOutputRow 
    set ^CacheTemp(repid,ind)=$lb(AccountCode,AccountName,UserCode,SectionCode ,SectionName,Telphone,JobCode,JobName,StartTime,EndTime)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisDoctorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisDoctorListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisDoctorListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisDoctorListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  医疗设备-医嘱项目
/// Description:通过本接口获取医院所有的科室列表  
/// Table:     V_MEIS_HIS_DictOrderItem
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisDictOrderItemList")
Query GetAdrHisDictOrderItemList() As %Query(ROWSPEC = "POrderClassCode,POrderClassName,SOrderClassCode,SOrderClassName,OrderItemCode,OrderItemName,OrderItemUnit,OrderItemPrice,StartDate,StopDate,EnterDate")
{
}

ClassMethod GetAdrHisDictOrderItemListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    
    s ARCIMSubscript=0
    for
    {
        s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) 
        q:(ARCIMSubscript="")
        s ARCIMVersion=0
        for 
        {
            s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) 
            q:(ARCIMVersion="") 
            s OrderItemCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)    //  医嘱项目编码
            s OrderItemName=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)     //医嘱项目名称
            s OrderItemUnit=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)   // 医嘱项目单位
            s:OrderItemUnit'="" OrderItemUnit=$p($g(^CT("UOM",OrderItemUnit)),"^",2)
            s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
            S OrderItemPrice= ##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId) ///##class(web.DHCBL.CT.ARCItmMast).GetOrderPrice(ARCIMRowId,9) //医嘱项目单价
            s StartDate= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)        //  启用日期
            s:StartDate'="" StartDate=$p(StartDate,"Z",1)
            s:StartDate'="" StartDate=$p(StartDate,",",1)
            s:StartDate'="" StartDate =##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StartDate)  
            s StopDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)       // 结束日期 
            s:StopDate'="" ARCIMEffDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(StopDate) ;    停止日期
            
            s EnterDate="" // 录入日期 
            s ARCIMItemCatDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",10) ; 医嘱子分类
            s POrderClassCode="",POrderClassName="",SOrderClassCode="",SOrderClassName="" 
            if (ARCIMItemCatDR'="")
            {
                s SOrderClassCode=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)   // 医嘱项目二级类别编码
                s SOrderClassName=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",2)   // 医嘱项目二级分类名称 
                s OECOrderCatDR=$p($g(^ARC("IC",ARCIMItemCatDR)),"^",8)    
                if OECOrderCatDR'="" s POrderClassCode=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",1) // 医嘱项目一级类别编码
                if OECOrderCatDR'="" s POrderClassName=$p($g(^OEC("ORCAT",OECOrderCatDR)),"^",2) // 医嘱项目一级分类名称
            }  
            d HISDictOrderItemOutputRow     
        }
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISDictOrderItemOutputRow 
    set ^CacheTemp(repid,ind)=$lb(POrderClassCode,POrderClassName,SOrderClassCode,SOrderClassName,OrderItemCode,OrderItemName,OrderItemUnit,OrderItemPrice,StartDate,StopDate,EnterDate)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisDictOrderItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisDictOrderItemListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisDictOrderItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisDictOrderItemListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  医疗设备-医嘱项目与收费项目对照 
/// Table:     V_MEIS_HIS_DictOrderChargeItem 
/// CreateDate:2020-10-13
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetAdrHisDictOrderChargeItemList")
Query GetAdrHisDictOrderChargeItemList() As %Query(ROWSPEC = "OrderItemCode,OrderItemName,ChargeItemCode,ChargeItemName,ChargeItemAmount,ChargeItemUnit,ChargeItemPrice")
{
}

ClassMethod GetAdrHisDictOrderChargeItemListExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s arcimrowid=0
    for  
    {
        s arcimrowid=$o(^DHCOLT(0,"ARTTA",arcimrowid)) 
        q:arcimrowid=""
        s olttariffdr=0
        for
        {
            s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) 
            q:olttariffdr=""   
            s startdate=0
            for
            {
                s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) 
                q:startdate=""
                s associaterowid=0
                for
                {
                    s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) 
                    q:associaterowid=""
                    s ARCIMSubscript=$p(arcimrowid,"||",1)
                    s ARCIMVersion=$p(arcimrowid,"||",2)
                    s OrderItemCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1) //医嘱项编码
                    s OrderItemName=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)  //医嘱项名称
                    s ChargeItemCode=$P($G(^DHCTARI(olttariffdr)),"^",1)   //收费项编码
                    s ChargeItemName=$P($G(^DHCTARI(olttariffdr)),"^",2)  //收费项名称
                    s ChargeItemAmount=$p($g(^DHCOLT(associaterowid)),"^",3) //收费数量 
                    s ChargeItemUnit=$p($g(^DHCTARI(olttariffdr)),"^",3)  //收费项目单位
                    s:ChargeItemUnit'="" ChargeItemUnit=$p($g(^CT("UOM",ChargeItemUnit)),"^",2)
                    s ChargeItemPrice=##class(web.DHCBL.CT.ARCItmMast).GetTariPrice(olttariffdr) //收费项目单价
                }
              }
          }
         d HISDictOrderChargeItemOutputRow     
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
HISDictOrderChargeItemOutputRow 
    set ^CacheTemp(repid,ind)=$lb(OrderItemCode,OrderItemName,ChargeItemCode,ChargeItemName,ChargeItemAmount,ChargeItemUnit,ChargeItemPrice)
    Set ind=ind+1
    quit
}

ClassMethod GetAdrHisDictOrderChargeItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdrHisDictOrderChargeItemListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetAdrHisDictOrderChargeItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdrHisDictOrderChargeItemListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:  组织机构诊疗项目管理表  
/// Table:     t_org_treatment_info
/// CreateDate:2020-10-27
/// Creator:   sunfengchao 
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataView","GetTorgTreatmentInfoList","","")
Query GetTorgTreatmentInfoList(DateFrom As %String = "", DateTo As %String = "") As %Query(ROWSPEC = "businessno,orgcode,uploadstatusmark,unifiedsocialcreditcode,orgname,statisticalmonth,hospitalitemcode,districtscode,districtsname,hospitalitemname,nationalmedipriceitemcode,nationalmedipriceitemname,treatmentitemformat,chargingunit,chargeunitprice,usemark,specialusedescrip,instructionmanual,updatetime,businessgenertime") [ SqlProc ]
{
}

ClassMethod GetTorgTreatmentInfoListExecute(ByRef qHandle As %Binary, DateFrom As %String = "", DateTo As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    
    s:DateFrom'="" DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
    s:DateTo'="" DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
    s TARIRowId=0
    for
    {
        s TARIRowId=$o(^DHCTARI(TARIRowId)) 
        q:TARIRowId=""
        s TARIStartDate =$p($g(^DHCTARI(TARIRowId)),"^",11) ///开始日期
        s TARIEndDate = $p($g(^DHCTARI(TARIRowId)),"^",12)
        if ((TARIStartDate>=DateFrom)&(TARIEndDate<=DateTo))  //||((DateFrom="")&(DateTo=""))
        { 
            s nationalmedipriceitemcode =$p($g(^DHCTARI(TARIRowId)),"^",1)  //全国医疗服务价格项目编码       
            s nationalmedipriceitemname=$p($g(^DHCTARI(TARIRowId)),"^",2)   //全国医疗服务价格项目名称 
            s hospitalitemcode  =$p($g(^DHCTARI(TARIRowId)),"^",1)      // 医院项目代码    医院内自编唯一码    
            s hospitalitemname =$p($g(^DHCTARI(TARIRowId)),"^",2)  //  院内项目名称    该收费项目界定的名称 
            s chargingunit =$p($g(^DHCTARI(TARIRowId)),"^",3)   //计价单位  
            s:chargingunit'="" chargingunit=$p($g(^CT("UOM",chargingunit)),"^",2)
            s chargeunitprice=##class(web.DHCBL.CT.DHCTarItem).GetTariPrice(TARIRowId) //收费单价     
            s instructionmanual=$p($g(^DHCTARI(TARIRowId)),"^",33)  //备注说明  
            s usemark=$p($g(^DHCTARI(TARIRowId)),"^",7)  //    使用标志  
            s statisticalmonth =$zd(+$H,3) //统计月份    必填  符合【YYYYMM】的格式 
            s treatmentitemformat ="1"  //  诊疗项目规格 规格的文字描述 
            s orgcode="455904778" // 机构代码  默认医院代码
            s orgname="粤北人民医院"   // 机构名称    
            s unifiedsocialcreditcode ="124402004559047781" // 统一社会信用代码  
            s hospnewpromark ="N"  //    是否院内或地方新增项目    
            s districtscode  ="512026"  // 行政区划代码   必填  精确到区县级，取值：代码值："440106" 
            s districtsname="武江区"  // 行政区划名称    精确到区县级，取值：，例如：”天河区” 
            s uploadstatusmark="1" // 数据上传标识 必填  标识与该条记录相关联的操作。 1:表示新增 2:表示覆盖或更新 3:表示删除   
            s specialusedescrip =""  // 分类上或使用上的特别说明 
            s updatetime=""  //  业务数据更新时间   业务系统数据更新时间 符合【YYYYMMDDHH24MISS】 
            s businessgenertime=""  // 业务数据产生时间   必填  此条数据在业务系统的产生时间，符合【YYYYMMDDHH24MISS】 
            s businessno="455904778"_$replace($zd(+$H,3),"-","") //业务编号  填写内容为：机构代码+”_”+上传月份YYYYMM 
            d TorgTreatmentInfoOutputRow  
        }   
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
TorgTreatmentInfoOutputRow  
    set ^CacheTemp(repid,ind)=$lb(businessno,orgcode,uploadstatusmark,unifiedsocialcreditcode,orgname,statisticalmonth,hospitalitemcode,districtscode,districtsname,hospitalitemname,nationalmedipriceitemcode,nationalmedipriceitemname,treatmentitemformat,chargingunit,chargeunitprice,usemark,specialusedescrip,instructionmanual,updatetime,businessgenertime)
    Set ind=ind+1
    quit
}

ClassMethod GetTorgTreatmentInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTorgTreatmentInfoListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GetTorgTreatmentInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTorgTreatmentInfoListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}

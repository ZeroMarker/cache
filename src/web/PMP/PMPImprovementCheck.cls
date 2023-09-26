Class web.PMP.PMPImprovementCheck Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query ImprovementFindByHospital(StartDate As %String, EndDate As %String, CreatUserID As %String, over As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Emergency:%String,Situation:%String,CreateDate:%String,CreateTime:%String,CreateUser:%String,CreateLoc:%String,CreateTel:%String,Type:%String,Project:%String,Degree:%String,Flag:%String,Status:%String,IPMLRowid:%String,IPMDRowid:%String")
{
}

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementCheck","ImprovementFindByHospital","63461","63491","","on")

ClassMethod ImprovementFindByHospitalExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, CreatUserID As %String, over As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^Lx("a",2)=over
    s (Code,Name,Emergency,Situation,CreateDate,CreateTime,CreateUser,CreateLoc,CreateTel,Type,Project,Degree,Flag,Status,IPMDRowid1)=""
    i StartDate=""||EndDate=""   d  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=StartDate:1:EndDate  d //取范围时间内
    .s IPMLRowid=""
    .f  s IPMLRowid=$o(^PMPImprovementListi("CreateDate",date,IPMLRowid)) q:IPMLRowid=""  d //需求主表
    ..q:(CreatUserID'="")&&(CreatUserID'=$p(^PMPImprovementList(IPMLRowid),"^",15))
    ..s Code=$p(^PMPImprovementList(IPMLRowid),"^",1)  //赋值开始
    ..s Name=$p(^PMPImprovementList(IPMLRowid),"^",2)
    ..s Emergency=$p($d(^PMPDictionary($p(^PMPImprovementList(IPMLRowid),"^",18))),"^",2) //字典表
    ..s Situation=$p(^PMPImprovementList(IPMLRowid),"^",26)
    ..i $p(^PMPImprovementList(IPMLRowid),"^",11)'=""  d
    ...s CreateDate=$zd($p(^PMPImprovementList(IPMLRowid),"^",11),3)
    ..i $p(^PMPImprovementList(IPMLRowid),"^",14)'=""  d
    ...s CreateTime=$zt($p(^PMPImprovementList(IPMLRowid),"^",14),3)
    ..s CreateUser=$p(^SSU("SSUSR",$p(^PMPImprovementList(IPMLRowid),"^",15)),"^",2)
    ..i $p(^PMPImprovementList(IPMLRowid),"^",12)'=""  d
    ...s CreateLoc=$p($d(^CTLOC($p(^PMPImprovementList(IPMLRowid),"^",12))),"^",1)
    ..s CreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
    ..s Type=$p(^PMPImprovementList(IPMLRowid),"^",31)
    ..i Type=0  d
    ...s Type="新增菜单"
    ..e  i Type=1  d
    ...s Type="已有菜单"
    ..e  i Type=2  d
    ...s Type="其他（接口、PDA等）"
    ..i $p(^PMPImprovementList(IPMLRowid),"^",25)'=""  d
    ...s Project=$p($d(^PMPProject($p(^PMPImprovementList(IPMLRowid),"^",25))),"^",2) //项目表
    ..i $p(^PMPImprovementList(IPMLRowid),"^",25)'=""  d
    ...s Degree=$p($d(^PMPDictionary($p(^PMPImprovementList(IPMLRowid),"^",25))),"^",2)
    ..;s Flag=$p(^PMPImprovementDetail(IPMLRowid,IPMDRowid),"^",8)
    ..s (Flag1,Flag2,Flag3,Flag4)=""
    ..s Flag1=$o(^PMPDictionary(0,"DTY_Desc","医院审核",Flag1))
    ..s Flag2=$o(^PMPDictionary(0,"DTY_Desc","非审核",Flag2))
    ..s Flag3=$o(^PMPDictionary(0,"DTY_Desc","项目审核",Flag3))
    ..s Flag4=$o(^PMPDictionary(0,"DTY_Desc","沟通记录",Flag4))
    ..s Status=$p(^PMPDictionary($p(^PMPImprovementList(IPMLRowid),"^",28)),"^",2) 
    ..s Status1=$p(^PMPImprovementList(IPMLRowid),"^",28)
    ..q:(over'="on")&(Status1>93)
    ..q:(over="on")&(Status1<=93)
    ..s Flag=""
    ..s IPMDRowid1="" //赋值结束
    ..d FindBuild
    
      
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
 
FindBuild
    set Data=$lb(Code,Name,Emergency,Situation,CreateDate,CreateTime,CreateUser,CreateLoc,CreateTel,Type,Project,Degree,Flag,Status,IPMLRowid,IPMDRowid1)                                                                                    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ImprovementFindByHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ImprovementFindByHospitalExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ImprovementFindByHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ImprovementFindByHospitalExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

//d ##class(%ResultSet).RunQuery("web.DHCPAADMQuery","userFind","高岩松")

Query userFind(ssusName As %String) As %Query(ROWSPEC = "name:%String,id:%String")
{
}

ClassMethod userFindExecute(ByRef qHandle As %Binary, ssusName As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    s rowid=0
    s name=""
    s id=0
    
    f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
    .q:$p(^SSU("SSUSR",rowid),"^",2)'[ssusName
    .s name=$p(^SSU("SSUSR",rowid),"^",2)
    .s id=rowid
    .d FindBuildu
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
 
FindBuildu
    set Data=$lb(name,id)                                                                                    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod userFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = userFindExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod userFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = userFindExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod passByHospital(IPMLRowid As %String, IPMDRowid As %String) As %String
{
    s ret=""
    s (DTYRowidFlag,DTYRowidFlag1,DTYRowidFlag2)=""
    s DTYRowidFlag=$o(^PMPDictionary(0,"DTY_Desc","项目审核",DTYRowidFlag))
    s DTYRowidFlag1=$o(^PMPDictionary(0,"DTY_Desc","待审核",DTYRowidFlag1))
    s DTYRowidFlag2=$o(^PMPDictionary(0,"DTY_Desc","审核通过",DTYRowidFlag2))
    s IPMDRowid=IPMLRowid_"||"_IPMDRowid
    s userID=%session.Get("LOGON.USERID")
    
    &sql(INSERT INTO sqlUser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR) values (:IPMLRowid,:DTYRowidFlag,:DTYRowidFlag1))
    &sql(UPDATE SQLUser.PMP_ImprovementDetail SET IPMD_Status_DR=:DTYRowidFlag2 WHERE IPMD_Rowid=:IPMDRowid)
    &sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Auditor1=:userID WHERE IPML_Rowid=:IPMLRowid)
    s ret="1"
    q ret
}

ClassMethod rejectByHospital(IPMLRowid As %String, IPMDRowid As %String, reason As %String) As %String
{
    s value=""
    i reason'=""  d
    .s DTYRowidFlag2=""
    .s DTYRowidFlag2=$o(^PMPDictionary(0,"DTY_Desc","审核不通过",DTYRowidFlag2))
    .s IPMDRowid=IPMLRowid_"||"_IPMDRowid
    .s userID=%session.Get("LOGON.USERID")
    .&sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Status_DR=:DTYRowidFlag2 WHERE IPML_Rowid=:IPMLRowid)
    .&sql(UPDATE SQLUser.PMP_ImprovementDetail SET IPMD_Status_DR=:DTYRowidFlag2 WHERE IPMD_Rowid=:IPMDRowid)
    .&sql(UPDATE SQLUser.PMP_ImprovementDetail SET IPMD_Remark=:reason WHERE IPMD_Rowid=:IPMDRowid)
    .&sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Auditor1=:userID WHERE IPML_Rowid=:IPMLRowid)
    .s value="1"
    e  d
    .s value="2"
    
    q value
}

Query ImprovementFindByProject(StartDate As %String, EndDate As %String, CreatUserID As %String, over As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Emergency:%String,Situation:%String,CreateDate:%String,CreateTime:%String,CreateUser:%String,CreateLoc:%String,CreateTel:%String,Type:%String,Project:%String,Degree:%String,Flag:%String,Status:%String,IPMLRowid:%String,IPMDRowid:%String")
{
}

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementCheck","ImprovementFindByProject","63481","63481","")

ClassMethod ImprovementFindByProjectExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, CreatUserID As %String, over As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^Lx("a",2)=over
    s (Code,Name,Emergency,Situation,CreateDate,CreateTime,CreateUser,CreateLoc,CreateTel,Type,Project,Degree,Flag,Status,IPMDRowid1)=""
    i StartDate=""||EndDate=""   d  Set qHandle=$lb(0,repid,0) Quit $$$OK
    f date=StartDate:1:EndDate  d //取范围时间内
    .s IPMLRowid=""
    .f  s IPMLRowid=$o(^PMPImprovementListi("CreateDate",date,IPMLRowid)) q:IPMLRowid=""  d //需求主表
    ..q:(CreatUserID'="")&&(CreatUserID'=$p(^PMPImprovementList(IPMLRowid),"^",15))
    ..s Code=$p(^PMPImprovementList(IPMLRowid),"^",1)  //赋值开始
    ..s Name=$p(^PMPImprovementList(IPMLRowid),"^",2)
    ..s Emergency=$p($d(^PMPDictionary($p(^PMPImprovementList(IPMLRowid),"^",18))),"^",2) //字典表
    ..s Situation=$p(^PMPImprovementList(IPMLRowid),"^",26)
    ..i $p(^PMPImprovementList(IPMLRowid),"^",11)'=""  d
    ...s CreateDate=$zd($p(^PMPImprovementList(IPMLRowid),"^",11),3)
    ..i $p(^PMPImprovementList(IPMLRowid),"^",14)'=""  d
    ...s CreateTime=$zt($p(^PMPImprovementList(IPMLRowid),"^",14),3)
    ..s CreateUser=$p(^SSU("SSUSR",$p(^PMPImprovementList(IPMLRowid),"^",15)),"^",2)
    ..i $p(^PMPImprovementList(IPMLRowid),"^",12)'=""  d
    ...s CreateLoc=$p($d(^CTLOC($p(^PMPImprovementList(IPMLRowid),"^",12))),"^",1)
    ..s CreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
    ..s Type=$p(^PMPImprovementList(IPMLRowid),"^",31)
    ..i Type=0  d
    ...s Type="新增菜单"
    ..e  i Type=1  d
    ...s Type="已有菜单"
    ..e  i Type=2  d
    ...s Type="其他（接口、PDA等）"
    ..i $p(^PMPImprovementList(IPMLRowid),"^",25)'=""  d
    ...s Project=$p($d(^PMPProject($p(^PMPImprovementList(IPMLRowid),"^",25))),"^",2) //项目表
    ..i $p(^PMPImprovementList(IPMLRowid),"^",25)'=""  d
    ...s Degree=$p($d(^PMPDictionary($p(^PMPImprovementList(IPMLRowid),"^",25))),"^",2)
    ..;s Flag=$p(^PMPImprovementDetail(IPMLRowid,IPMDRowid),"^",8)
    ..s (Flag1,Flag2,Flag3,Flag4)=""
    ..s Flag1=$o(^PMPDictionary(0,"DTY_Desc","医院审核",Flag1))
    ..s Flag2=$o(^PMPDictionary(0,"DTY_Desc","非审核",Flag2))
    ..s Flag3=$o(^PMPDictionary(0,"DTY_Desc","项目审核",Flag3))
    ..s Flag4=$o(^PMPDictionary(0,"DTY_Desc","沟通记录",Flag4))
    ..s Status=$p(^PMPDictionary($p(^PMPImprovementList(IPMLRowid),"^",28)),"^",2) 
    ..s Status1=$p(^PMPImprovementList(IPMLRowid),"^",28)
    ..q:(over'="on")&(Status1>98)
    ..q:(over="on")&(Status1<=98)
    ..s Flag=""
    ..s IPMDRowid1="" //赋值结束
    ...d FindBuildp

      
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
 
FindBuildp
    set Data=$lb(Code,Name,Emergency,Situation,CreateDate,CreateTime,CreateUser,CreateLoc,CreateTel,Type,Project,Degree,Flag,Status,IPMLRowid,IPMDRowid1)                                                                                    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod ImprovementFindByProjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ImprovementFindByProjectExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod ImprovementFindByProjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ImprovementFindByProjectExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod passByProject(IPMLRowid As %String, IPMDRowid As %String, PJURowid As %String) As %String
{
    s DTYRowidFlag=""
    s DTYRowidFlag=$o(^PMPDictionary(0,"DTY_Desc","审核通过",DTYRowidFlag))
    s IPMDRowid=IPMLRowid_"||"_IPMDRowid
    s userID=%session.Get("LOGON.USERID")
    
    &sql(UPDATE SQLUser.PMP_ImprovementDetail SET IPMD_Status_DR=:DTYRowidFlag WHERE IPMD_Rowid=:IPMDRowid)
    &sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Engineer_DR=:PJURowid WHERE IPML_Rowid=:IPMLRowid)
    &sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Status_DR=:DTYRowidFlag WHERE IPML_Rowid=:IPMLRowid)
    &sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Auditor=:userID WHERE IPML_Rowid=:IPMLRowid)
    q 1
}

ClassMethod rejectByProject(IPMLRowid As %String, IPMDRowid As %String, reason As %String) As %String
{
    s value=""
    i reason'=""  d
    .s DTYRowidFlag2=""
    .s DTYRowidFlag2=$o(^PMPDictionary(0,"DTY_Desc","审核不通过",DTYRowidFlag2))
    .s IPMDRowid=IPMLRowid_"||"_IPMDRowid 
    .s userID=%session.Get("LOGON.USERID")  
    .&sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Status_DR=:DTYRowidFlag2 WHERE IPML_Rowid=:IPMLRowid)
    .&sql(UPDATE SQLUser.PMP_ImprovementDetail SET IPMD_Status_DR=:DTYRowidFlag2 WHERE IPMD_Rowid=:IPMDRowid)
    .&sql(UPDATE SQLUser.PMP_ImprovementDetail SET IPMD_Remark=:reason WHERE IPMD_Rowid=:IPMDRowid)
    .&sql(UPDATE SQLUser.PMP_ImprovementList SET IPML_Auditor=:userID WHERE IPML_Rowid=:IPMLRowid)
    .s value=1
    e  d
    .s value=2
    
    q value
}

//d ##class(%ResultSet).RunQuery("web.DHCPAADMQuery","projectUserFind","高岩松")

Query projectUserFind(ssusName As %String) As %Query(ROWSPEC = "name:%String,id:%String")
{
}

ClassMethod projectUserFindExecute(ByRef qHandle As %Binary, ssusName As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    s rowid=0
    s name=""
    s id=0
    
    f  s rowid=$o(^PMPProjectUser(rowid)) q:rowid=""  d
    .q:$p(^SSU("SSUSR",$p(^PMPProjectUser(rowid),"^",1)),"^",2)'[ssusName
    .s name=$p(^SSU("SSUSR",$p(^PMPProjectUser(rowid),"^",1)),"^",2)
    .s id=rowid
    .d FindBuildpu
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
 
FindBuildpu
    set Data=$lb(name,id)                                                                                    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod projectUserFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = projectUserFindExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod projectUserFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = projectUserFindExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator:Lid
/// CreatDate:2012-03-30
/// Desc:初始化组件Table上每行的"操作"单元格
/// w ##class(web.DHCOPBillChargExcepiton).InitOperationCell()
ClassMethod InitOperationCell() As %String
{
    s Status=rs.GetDataByName("Status")
    if Status="待审核" {
        ;Tind:%Library.Integer,TJob,TPrtRowid,TInsTypeDR,TAdmSource,TPatientNO,TPapmiName,TInsTypeDesc,TDisplayPrtDate,TDisplayPrtTime,TPrtUserName,TTotalAmt:%Library.Float,TPatientShare:%Library.Float,TDiscAmount:%Library.Float,TPayorShare:%Library.Float,TPayMStr,TException,TExceptionDesc
        Set BtnLookUP="BtnCancel_"_rs.GetDataByName("IPMDRowid")_rs.GetDataByName("IPMLRowid")
        Set BtnHandle="CompleteCharge_"_rs.GetDataByName("IPMDRowid")_rs.GetDataByName("IPMLRowid")
        Set IPMLRowid=rs.GetDataByName("IPMLRowid")
        Set IPMDRowid=rs.GetDataByName("IPMDRowid")
        //s ^Lx("a",1)=IPMLRowid_"   "_IPMDRowid

        Set Active="1"
        Set Active=$s(Active="1":"",1:"disabled")
        Set DataType="Button"
        If DataType="Button" {
            Write "<input type='button' id='"_BtnLookUP_"' name='"_BtnLookUP_"' "_Active
            Write " style='WIDTH: 40px; HEIGHT: 24px' value='审核' onClick='pass("_IPMLRowid_","_IPMDRowid_")'>"
            Write "<input type='button' id='"_BtnHandle_"' name='"_BtnHandle_"' "_Active
            Write " style='WIDTH: 40px; HEIGHT: 24px' value='拒绝' onClick='reject("_IPMLRowid_","_IPMDRowid_")'>"
        }
     }
     Quit ""
}

Storage Default
{
<Data name="PMPImprovementCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.PMPImprovementCheckD</DataLocation>
<DefaultData>PMPImprovementCheckDefaultData</DefaultData>
<IdLocation>^web.PMP.PMPImprovementCheckD</IdLocation>
<IndexLocation>^web.PMP.PMPImprovementCheckI</IndexLocation>
<StreamLocation>^web.PMP.PMPImprovementCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

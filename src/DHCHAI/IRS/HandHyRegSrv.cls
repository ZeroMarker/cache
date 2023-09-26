/// 名称: DHCHAI.IRS.HandHyRegSrv
/// 描述: 手卫生依从性登记服务
/// 编写者：zhufei
/// 编写日期: 2017-12-13
Class DHCHAI.IRS.HandHyRegSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-12-26
/// Description:  保存手卫生调查报告信息
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       inputStr : 手卫生调查报告信息
///               aInputRegTim : 手卫生时机信息
///               aInputRegCnt : 手卫生人数信息
/// Return：      DHCHAI.IR.HandHyReg.%Id()
/// w ##Class(DHCHAI.IRS.HandHyRegSrv).SaveHandHyReg()
ClassMethod SaveHandHyReg(aInputStr As %String, aInputRegTim As %String, aInputRegCnt As %String) As %String
{
    New (aInputStr,aInputRegTim,aInputRegCnt)
    Set return=0
    Quit:(aInputStr="") return

    Set $ZT="SaveHandHyRegErr"
    //处理历史错误数据问题，需重建索引
    If ($d(^DHCHAI.IR.HandHyRegI("Cnt","IndexType"))&&'$d(^DHCHAI.IR.HandHyRegI("Cnt","IndexSign"))) {
        //重建索引
        d ##class(DHCHAI.IR.HandHyRegCnt).%BuildIndices()
    }
        
    TStart
    Set return=-101
    // 保存手卫生调查报告信息
    Set flg=##Class(DHCHAI.IR.HandHyReg).Update(aInputStr,"^")
    IF (+flg)<1 TRollback
    Quit:(+flg)<1 return
    Set HHRegID=+flg
    
    Set return=-102
    // 保存手卫生调查时机信息
    Set IsError=0
    For xTim=1:1:$l(aInputRegTim,"#") {
        Set RegTimInfo=$p(aInputRegTim,"#",xTim)
        Continue:RegTimInfo=""
        Set (IsGloving,IsCorrect)=0
        Set FacilitDr=""
        Set:RegTimInfo["I3" IsGloving=1    // 是否戴手套
        Set:RegTimInfo["I4" IsCorrect=1    // 是否正确
        Set:RegTimInfo["-I2-" FacilitDr=$p($p(RegTimInfo,"-I2-",2),",",1)  // 手卫生措施(行为)
        Set TypeTime = $p(RegTimInfo,"-",1)
        Set ObsTime  = +$e(TypeTime,2,$l(TypeTime))  // 时机
        
        Set OpportList=""   // 手卫生指征
        For xItm=1:1:$l(RegTimInfo,","){
            Set ItemInfo=$p(RegTimInfo,",",xItm)
            Continue:ItemInfo'["-I1-"
            Set OpportList=OpportList_","_$p(ItemInfo,"-I1-",2)
        }
        Set:OpportList'="" OpportList=$e(OpportList,2,$l(OpportList))
        Set ObsTypeDr ="",ObsName ="",ErrResDr="",ObsSign=""
        Set:RegTimInfo["Type-" ObsTypeDr=$p($p(RegTimInfo,"Type-",2),",",1)  // 专业ID
        Set:RegTimInfo["Name-" ObsName=$p($p(RegTimInfo,"Name-",2),",",1)    // 被调查人姓名  
        Set:RegTimInfo["Sign-" ObsSign=$p($p(RegTimInfo,"Sign-",2),",",1)    // 区分标记
        
        Set ErrResList=""   // 不正确原因
        For xItm=1:1:$l(RegTimInfo,","){
            Set ItemInfo=$p(RegTimInfo,",",xItm)
            Continue:ItemInfo'["-I5-"
            Set ErrResList=ErrResList_","_$p(ItemInfo,"-I5-",2)
        }
        Set:ErrResList'="" ErrResList=$e(ErrResList,2,$l(ErrResList))     
        Set:RegTimInfo["Other-" HHErrResText=$p($p(RegTimInfo,"Other-",2),",",1)    //不正确原因其他                     
        Set InputStr = HHRegID
        Set InputStr = InputStr_"^"_""
        Set InputStr = InputStr_"^"_ObsTypeDr   // 专业ID
        Set InputStr = InputStr_"^"_ObsTime     // 调查时机
        Set InputStr = InputStr_"^"_OpportList  // 手卫生指征
        Set InputStr = InputStr_"^"_FacilitDr   // 手卫生措施(行为)
        Set InputStr = InputStr_"^"_IsGloving   // 是否戴手套
        Set InputStr = InputStr_"^"_IsCorrect   // 是否正确
        Set InputStr = InputStr_"^"_ObsName     // 被调查人姓名
        Set InputStr = InputStr_"^"_ErrResList    // 不正确原因
        Set InputStr = InputStr_"^"_ObsSign     // 区分标记
        Set InputStr = InputStr_"^"_HHErrResText     // 不正确原因其他
        
        Set flg=##Class(DHCHAI.IR.HandHyRegTim).Update(InputStr,"^")
        IF (+flg)<1 TRollback
        If (+flg)<1 {
            Set IsError=1
            Quit 
        }
    }
    Quit:IsError=1 return
    
    Set return=-103
    // 保存手卫生调查人信息
    Set IsError=0,ObsSignList=""
    For xCnt=1:1:$l(aInputRegCnt,"#") {
        Set RegCntInfo=$p(aInputRegCnt,"#",xCnt)
        Continue:RegCntInfo=""
        
        Set ObsTypeDr=$p(RegCntInfo,",",1)   // 专业ID
        Set ObsCount=$p(RegCntInfo,",",2)    // 调查人数
        Set ObsSign=$p(RegCntInfo,",",3)     // 区分标记
        
        Continue:(ObsTypeDr="")||(ObsCount="")||(ObsSign="")
        Set ObsSignList=ObsSignList_$lb(ObsSign)
        Set InputStr = HHRegID
        Set InputStr = InputStr_"^"_""
        Set InputStr = InputStr_"^"_ObsTypeDr   
        Set InputStr = InputStr_"^"_ObsCount
        Set InputStr = InputStr_"^"_ObsSign
        
        Set flg=##Class(DHCHAI.IR.HandHyRegCnt).Update(InputStr,"^")
        IF (+flg)<1 TRollback
        If (+flg)<1 {
            Set IsError=1
            Quit 
        }
    }
    
    //处理因职业修改等导致的多人问题
    Set xSign=""
    For {
        Set xSign=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexSign",HHRegID,xSign))
        Quit:xSign=""

        Set xSubID=""
        For {
            Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Cnt","IndexSign",HHRegID,xSign,xSubID))
            Quit:xSubID=""
        
            Continue:($listfind(ObsSignList,xSign)>0)
            Set ChildCntID=HHRegID_"||"_xSubID
            do ##class(DHCHAI.IR.HandHyRegCnt).DeleteById(ChildCntID)
        }
    }
    
    Quit:IsError=1 return
    
    TCommit
    Set return=HHRegID
    Quit return
    
SaveHandHyRegErr
    Quit -999_"^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2017-12-13
/// Description:  查询手卫生依从性观察表
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aLocID : 检查科室
///               aCheckDate  ：检查日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","QryHandHyReg","37","2021-06-25",352,690)
Query QryHandHyReg(aLocID As %String, aCheckDate As %String, aObsPageID As %String, aObsMethodID As %String) As %Query(ROWSPEC = "Cmp1:%String,Num1:%String,Val11:%String,Val12:%String,Val13:%String,Type1:%String,Name1:%String,Cmp2:%String,Num2:%String,Val21:%String,Val22:%String,Val23:%String,Type2:%String,Name2:%String,Cmp3:%String,Num3:%String,Val31:%String,Val32:%String,Val33:%String,Type3:%String,Name3:%String,Cmp4:%String,Num4:%String,Val41:%String,Val42:%String,Val43:%String,Type4:%String,Name4:%String,Cmp5:%String,Num5:%String,Val51:%String,Val52:%String,Val53:%String,Type5:%String,Name5:%String,Cmp6:%String,Num6:%String,Val61:%String,Val62:%String,Val63:%String,Type6:%String,Name6:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyRegExecute(ByRef qHandle As %Binary, aLocID As %String, aCheckDate As %String, aObsPageID As %String, aObsMethodID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)

    //Set:aCheckDate'="" aCheckDate=$zdh(aCheckDate,3)
    Set:aCheckDate'="" aCheckDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aCheckDate)
    Quit:(aCheckDate="")||(aLocID="")||(aObsPageID="")||(aObsMethodID="") $$$OK
    
    Kill arrResult
    
    Set RegID=$o(^DHCHAI.IR.HandHyRegI("IndexLocDatePageMethod",aLocID,aCheckDate,aObsPageID,aObsMethodID,0))
    Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(RegID)
    Set RegVer = ##class(DHCHAI.BT.Config).GetValByCode("HandHyRegVer")
    Set:RegVer="" RegVer=1
    
    If ($IsObject(objReg)){
        Set arrResult("A")=""
        Set arrResult("B")=""
        Set arrResult("C")=""
        Set arrResult("D")=""
        Set xType=""
        For {
            Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType))
            Quit:xType=""
            
            Set xTim=""
            For {
                Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim))
                Quit:xTim=""
                
                Set xSign=""
                For {
                    Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign))
                    Quit:xSign=""
                
                    Set xSubID=""
                    For {
                        Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign,xSubID))
                        Quit:xSubID=""
                        Set ChildTimID=RegID_"||"_xSubID
                        Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(ChildTimID)
                        Continue:'$IsObject(objRegTim)
                        
                        If $IsObject(objRegTim.HHObsTypeDr) {
                            Set TypeID   = objRegTim.HHObsTypeDr.%Id()  
                            Set TypeCode = objRegTim.HHObsTypeDr.BTCode
                            Set TypeDesc = objRegTim.HHObsTypeDr.BTDesc
                        }Else {
                            Set (TypeID,TypeCode,TypeDesc)=""   
                        }
                        
                        Set ObsTime = objRegTim.HHObsTime
                        If (ObsTime>5){
                            Set indRow=ObsTime-5
                            Set indCol=2
                        }Else{
                            Set indRow=ObsTime
                            Set indCol=1
                        }
                        Set OpportList = objRegTim.HHOpportList
                        If $IsObject(objRegTim.HHFacilitDr) {
                            Set FacID    = objRegTim.HHFacilitDr.%Id()  
                            Set FacCode  = objRegTim.HHFacilitDr.BTCode
                            Set FacDesc  = objRegTim.HHFacilitDr.BTDesc
                        }Else {
                            Set (FacID,FacCode,FacDesc)=""   
                        }
                        Set ErrResList = objRegTim.HHErrResDr
                        //拼接不正确原因其他
                        Set ErrResList = ErrResList_"!!"_objRegTim.HHErrResText
                        
                        Set IsGloving = objRegTim.HHIsGloving
                        Set IsCorrect = objRegTim.HHIsCorrect
                        Set ObsName = objRegTim.HHObsName
                    
                        Set arrResult(xSign,indRow,indCol)=$lb(xSign_ObsTime,ObsTime,OpportList,FacID_"!!"_IsGloving_"!!"_IsCorrect,ErrResList,TypeID,ObsName)
                    }
                }
            }
        }
    }Else {
        Set Row=5,Col=2,Type="A"
        Set:RegVer'=1 Col=1
        Set arrResult(Type)=$lb(Row,Col)
        For indRow=1:1:Row {
            For indCol=1:1:Col {
                Set num=(Row*(indCol-1))+indRow
                Set arrResult(Type,indRow,indCol)=$lb(Type_num,num,"","","","","")
            }
        }
        Set Row=5,Col=2,Type="B"
        Set:RegVer'=1 Col=1
        Set arrResult(Type)=$lb(Row,Col)
        For indRow=1:1:Row {
            For indCol=1:1:Col {
                Set num=(Row*(indCol-1))+indRow
                Set arrResult(Type,indRow,indCol)=$lb(Type_num,num,"","","","","")
            }
        }
        Set Row=5,Col=1,Type="C"
        Set arrResult(Type)=$lb(Row,Col)
        For indRow=1:1:Row {
            For indCol=1:1:Col {
                Set num=(Row*(indCol-1))+indRow
                Set arrResult(Type,indRow,indCol)=$lb(Type_num,num,"","","","","")
            }
        }
        Set Row=5,Col=1,Type="D"
        Set arrResult(Type)=$lb(Row,Col)
        For indRow=1:1:Row {
            For indCol=1:1:Col {
                Set num=(Row*(indCol-1))+indRow
                Set arrResult(Type,indRow,indCol)=$lb(Type_num,num,"","","","","")
            }
        }
    }
    Set RowMax=5
    For xRow=1:1:RowMax {
        Set Data=""
        Set xType=""
        For {
            Set xType=$o(arrResult(xType))
            Quit:xType=""
            If ("A,B"[xType){
                Set Col=2
                Set:RegVer'=1 Col=1
            }Else{
                Set Col=1
            }
            For xCol=1:1:Col {
                If ($g(arrResult(xType,xRow,xCol))=""){
                    Set num=(5*(xCol-1))+xRow
                    Set Data=Data_$lb(xType_num,num,"","","","","")
                }Else{
                    Set Data=Data_$g(arrResult(xType,xRow,xCol))
                }
            }
        }
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
    }
    Kill arrResult
    
    Quit $$$OK
}

ClassMethod QryHandHyRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHandHyRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// w ##class(DHCHAI.IRS.HandHyRegSrv).GetHandHyItems("HandHyObsPage")
ClassMethod GetHandHyItems(aTypeCode As %String) As %String
{
    New (aTypeCode)
    Set return=""
    Quit:aTypeCode="" return
    
    Set objType=##class(DHCHAI.BT.DicType).GetObjByCode(aTypeCode)
    Quit:'$IsObject(objType) return
    Set TypeID=objType.%Id()
    
    Set xCode = ""
    For {
        Set xCode = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode))
        Quit:xCode=""
        
        Set xID = ""
        For {
            Set xID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",TypeID,xCode,xID))
            Quit:xID=""
            
            Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(xID)
            Continue:'$Isobject(objDic)
            Continue:objDic.BTIsActive'=1
            
            Set DicCode  = objDic.BTCode
            Set DicDesc  = objDic.BTDesc
            //多语言处理
            Set DicDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",DicDesc,"DHCHAI.BT.Dictionary")
            Set return=return_"^"_xID_"||"_DicDesc
        }
    }
    Set:return'="" return=$e(return,2,$l(return))
    Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2018-02-06
/// Description:  统计手卫生依从率、正确率
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aLocID    : 检查科室
///               aDateFrom ：开始日期
///               aDateTo   ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","QryHandHyRegSta","","2021-02-01","2021-07-06")
Query QryHandHyRegSta(aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,TypeID:%String,TypeDesc:%String,OpportList:%String,FacID:%String,FacDesc:%String,IsGloving:%String,IsCorrect:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyRegStaExecute(ByRef qHandle As %Binary, aLocID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    
    For xDate=aDateFrom:1:aDateTo { 
        Set xPage=""
        For {
            Set xPage=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage))
            Quit:xPage=""
            
            Set xID=""
            For {
                Set xID=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage,xID))
                Quit:xID=""
                Set RegID=xID
                Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(RegID)
                Continue:'$IsObject(objReg)
                
                If $IsObject(objReg.HHLocDr) {
                    Set LocID    = objReg.HHLocDr.%Id()
                    Set LocDesc  = objReg.HHLocDr.BTDesc
                    Set LocDesc2 = objReg.HHLocDr.BTDesc2
                    Set:LocDesc2'="" LocDesc=LocDesc2
                    Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
                }Else {
                    Set (LocID,LocDesc)=""   
                }
                Continue:(aLocID'="")&&(aLocID'=LocID)
                Set IsActive=objReg.HHIsActive
                Continue:IsActive'=1
                
                Set xType=""
                For {
                    Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType))
                    Quit:xType=""
                    
                    Set xTim=""
                    For {
                        Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim))
                        Quit:xTim=""
                        
                        Set xSign=""
                        For {
                            Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign))
                            Quit:xSign=""
                        
                            Set xSubID=""
                            For {
                                Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",RegID,xType,xTim,xSign,xSubID))
                                Quit:xSubID=""
                                Set ChildTimID=RegID_"||"_xSubID
                                Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(ChildTimID)
                                Continue:'$IsObject(objRegTim)
                                
                                If $IsObject(objRegTim.HHObsTypeDr) {
                                    Set TypeID   = objRegTim.HHObsTypeDr.%Id()  
                                    Set TypeCode = objRegTim.HHObsTypeDr.BTCode
                                    Set TypeDesc = objRegTim.HHObsTypeDr.BTDesc
                                }Else {
                                    Set (TypeID,TypeCode,TypeDesc)=""   
                                }
                                Set OpportListDesc=""
                                Set OpportList = objRegTim.HHOpportList
                                If (OpportList'=""){
                                    For i=1:1:$l(OpportList,",") {
                                        Set OpportID=$p(OpportList,",",i)
                                        Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(OpportID)
                                        Set BTDesc = objDic.BTDesc
                                        Set:BTDesc'="" OpportListDesc=OpportListDesc_","_BTDesc
                                    }
                                }
                                Set OpportList=OpportListDesc
                                If $IsObject(objRegTim.HHFacilitDr) {
                                    Set FacID    = objRegTim.HHFacilitDr.%Id()
                                    Set FacDesc  = objRegTim.HHFacilitDr.BTDesc
                                }Else {
                                    Set (FacID,FacDesc)=""   
                                }
                                Set IsGloving = objRegTim.HHIsGloving
                                Set IsCorrect = objRegTim.HHIsCorrect
                                
                                Set Data=$lb(LocID,LocDesc,TypeID,TypeDesc,OpportList,FacID,FacDesc,IsGloving,IsCorrect)
                                Set ^CacheTemp(repid,ind)=Data
                                Set ind=ind+1
            
                            }
                        }
                    }
                }
            }
        }
    }
    Quit $$$OK
}

ClassMethod QryHandHyRegStaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegStaExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHandHyRegStaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegStaExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     chenrui
/// CreatDate：   20201013
/// Description:  查询手卫生依从性观察表
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aHospID : 医院ID
///               aLocID:科室ID
///               aDateFrom  ：开始日期
///               aDateTo  ：结束日期
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","QryHandHyByDate","1","1","2021-06-10","2021-06-28","")
Query QryHandHyByDate(aHospID As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String) As %Query(ROWSPEC = "HandHyObsType:%String,HandHyObsTime:%String,HandHyObsMethod:%String,HandHyOpp:%String,HandHyFac:%String,HHIsGloving:%String,HHIsCorrect:%String,HHLoc:%String,HHObsPages:%String,HHObsDates:%String,HHObsUser:%String,HHRegDate:%String,HHRegUser:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyByDateExecute(ByRef qHandle As %Binary, aHospID As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    Quit:aLocID="" "调查科室不能不空"
    
    Set HHObsDate=""
    For{
        Set HHObsDate=$o(^DHCHAI.IR.HandHyRegI("IndexLocDatePage",aLocID,HHObsDate))    //调查日期
        
        Quit:HHObsDate=""
        Continue:(HHObsDate<aDateFrom)||(HHObsDate>aDateTo)
        Set HHObsPage=""
        For{
            Set HHObsPage=$o(^DHCHAI.IR.HandHyRegI("IndexLocDatePage",aLocID,HHObsDate,HHObsPage))  //调查页数  
            Quit:HHObsPage=""   
            Set RepID=""
            For{
                Set RepID=$o(^DHCHAI.IR.HandHyRegI("IndexLocDatePage",aLocID,HHObsDate,HHObsPage,RepID))    //调查的报告ID   
                Quit:RepID=""
                Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(RepID)
                Continue:'$IsObject(objReg) 
                Set HHObsDates=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(HHObsDate)   //调查日期
                Set HHObsPages = objReg.HHObsPageDr.BTDesc  //调查页数
                Set HHLoc = objReg.HHLocDr.BTDesc //调查科室
                Set HHObsUser=objReg.HHObsUser  //调查人
                Set HHRegDate1=objReg.HHRegDate //登记日期
                Set:HHRegDate1'="" HHRegDate1=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(HHRegDate1)
                Set HHRegTime =objReg.HHRegTime //登记时间
                Set:HHRegTime'="" HHRegTime=$zt(HHRegTime,2)
                Set HHRegDate=HHRegDate1_" "_HHRegTime  //登记日期+时间
                Set HHRegUser=objReg.HHRegUserDr.BTDesc //登记人
                
                Set HandHyObsMethod=objReg.HHObsMethodDr.BTDesc //调查方式（自查or督察）
                if (aMethod'=""){
                    Continue:aMethod'=HandHyObsMethod
                }
                
                //手卫生依从性调查时机表
                Set Parref=RepID
                Set HHObsTypeDr=""
                    For{
                        Set HHObsTypeDr=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",Parref,HHObsTypeDr))  
                        Quit:HHObsTypeDr=""
                        
                        Set HHObsTime=""
                        For{
                            Set HHObsTime=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",Parref,HHObsTypeDr,HHObsTime))  
                            Quit:HHObsTime=""
                            
                            Set xSign=""
                            For {
                                Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",Parref,HHObsTypeDr,HHObsTime,xSign))
                                Quit:xSign=""
                                
                                Set Id=""
                                For{
                                    Set Id=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",Parref,HHObsTypeDr,HHObsTime,xSign,Id))    
                                    Quit:Id=""  
                                    Set RegTimID = Parref_"||"_Id
                                    Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(RegTimID)
                                    Continue:'$IsObject(objRegTim)  
                                    Set HandHyObsType = objRegTim.HHObsTypeDr.BTDesc    //调查对象
                                    Set HandHyObsTime = objRegTim.HHObsTime             //调查时机
                                    
                                    Set OpportListDesc=""
                                    Set HandHyOppDR = objRegTim.HHOpportList                //手卫生指征
                                    If (HandHyOppDR'=""){
                                        For i=1:1:$l(HandHyOppDR,",") {
                                            Set OpportID=$p(HandHyOppDR,",",i)
                                            Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(OpportID)
                                            Set BTDesc = objDic.BTDesc
                                            Set:BTDesc'="" OpportListDesc=OpportListDesc_","_BTDesc
                                        }
                                    }
                                    Set HandHyOpp=$p(OpportListDesc,",",2,HandHyOppDR)
                                    Set HandHyFac = objRegTim.HHFacilitDr.BTDesc        //手卫生行为
                                    Set HHIsGloving = objRegTim.HHIsGloving             //是否戴手套
                                    Set HHIsGloving = $s(HHIsGloving=1:"已佩戴手套",HHIsGloving=0:"未佩戴手套")
                                    Set HHIsCorrect = objRegTim.HHIsCorrect             //是否正确
                                    Set HHIsCorrect = $s(HHIsCorrect=1:"正确",HHIsCorrect=0:"错误")
                                    Set Data=$lb(HandHyObsType,HandHyObsTime,HandHyObsMethod,HandHyOpp,HandHyFac,HHIsGloving,HHIsCorrect,HHLoc,HHObsPages,HHObsDates,HHObsUser,HHRegDate,HHRegUser)
                                    Set ^CacheTemp(repid,ind)=Data
                                    Set ind=ind+1
                                }
                            }   
                        }
                    }   
                }
            }
        }

    Quit $$$OK
}

ClassMethod QryHandHyByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHandHyByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-06-25
/// Description:  查询手卫生依从调查记录
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aHospID   : 调查医院
///               aLocID    : 调查科室
///               aDateFrom ：开始日期
///               aDateTo   ：结束日期
///               aMethod   ：调查方式
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","HandHyRegQry","","","2021-02-01","2021-06-26","")
Query HandHyRegQry(aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String) As %Query(ROWSPEC = "RegID:%String,LocID:%String,LocDesc:%String,ObsDate:%String,ObsPageID:%String,ObsPageDesc:%String,ObsMethodID:%String,ObsMethodDesc:%String,ObsUser:%String,RegDate:%String,RegTime:%String,RegUserID:%String,RegUserDesc:%String") [ SqlProc ]
{
}

ClassMethod HandHyRegQryExecute(ByRef qHandle As %Binary, aHospIDs As %String, aLocID As %String, aDateFrom As %String, aDateTo As %String, aMethod As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
    Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
    Quit:(aDateFrom>aDateTo) $$$OK
    
    For xDate=aDateFrom:1:aDateTo { 
        Set xPage=""
        For {
            Set xPage=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage))
            Quit:xPage=""
            
            Set xID=""
            For {
                Set xID=$o(^DHCHAI.IR.HandHyRegI("IndexDatePage",xDate,xPage,xID))
                Quit:xID=""
                Set RegID=xID
                Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(RegID)
                Continue:'$IsObject(objReg)
                
                If $IsObject(objReg.HHLocDr) {
                    Set LocID    = objReg.HHLocDr.%Id()
                    Set LocDesc  = objReg.HHLocDr.BTDesc
                    Set LocDesc2 = objReg.HHLocDr.BTDesc2
                    Set:LocDesc2'="" LocDesc=LocDesc2
                    Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
                    If $IsObject(objReg.HHLocDr.BTHospDr){
                        Set HospID=objReg.HHLocDr.BTHospDr.%Id()            
                        Continue:(aHospIDs'="")&($listfind(aHospIDs,HospID)<1)      //医院过滤  
                    }
                }Else {
                    Set (LocID,LocDesc)=""   
                }
                Continue:(aLocID'="")&&(aLocID'=LocID)
                Set IsActive=objReg.HHIsActive
                Continue:IsActive'=1
                Set ObsDate=objReg.HHObsDate
                Set:ObsDate'="" ObsDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ObsDate)    
                If $IsObject(objReg.HHObsPageDr) {
                    Set ObsPageID    = objReg.HHObsPageDr.%Id()
                    Set ObsPageDesc  = objReg.HHObsPageDr.BTDesc
                }Else {
                    Set (ObsPageID,ObsPageDesc)=""   
                }
                If $IsObject(objReg.HHObsMethodDr) {
                    Set ObsMethodID    = objReg.HHObsMethodDr.%Id()
                    Set ObsMethodDesc  = objReg.HHObsMethodDr.BTDesc
                }Else {
                    Set (ObsMethodID,ObsMethodDesc)=""   
                }
                Continue:(aMethod'="")&&(aMethod'=ObsMethodID)
                    
                Set ObsUser=objReg.HHObsUser    //调查人
                Set RegDate=objReg.HHRegDate    //登记日期
                Set:RegDate'="" RegDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RegDate)
                Set RegTime =objReg.HHRegTime   //登记时间
                Set:RegTime'="" RegTime=$zt(RegTime,2)
            
                If $IsObject(objReg.HHRegUserDr) {
                    Set RegUserID    = objReg.HHRegUserDr.%Id()
                    Set RegUserDesc  = objReg.HHRegUserDr.BTDesc
                }Else {
                    Set (RegUserID,RegUserDesc)=""   
                }
                Set ObsPageDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ObsPageDesc,"DHCHAI.BT.Dictionary")
                Set ObsMethodDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",ObsMethodDesc,"DHCHAI.BT.Dictionary")
                Set RegUserDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",RegUserDesc,"DHCHAI.BT.Dictionary")
                
                Set Data=$lb(RegID,LocID,LocDesc,ObsDate,ObsPageID,ObsPageDesc,ObsMethodID,ObsMethodDesc,ObsUser,RegDate,RegTime,RegUserID,RegUserDesc)
                Set ^CacheTemp(repid,ind)=Data
                Set ind=ind+1
            }
        }
    }
    Quit $$$OK
}

ClassMethod HandHyRegQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HandHyRegQryExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod HandHyRegQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HandHyRegQryExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-06-28
/// Description:  查询手卫生调查报告信息
/// Table：       DHCHAI.IR.HandHyReg、DHCHAI.IR.HandHyRegTim
/// Input：       aRegID   : 调查记录ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","QryHandHyRegTim","30")
Query QryHandHyRegTim(aRegID As %String) As %Query(ROWSPEC = "RegID:%String,LocID:%String,LocDesc:%String,ObsDate:%String,ObsPageID:%String,ObsPageDesc:%String,ObsMethodID:%String,ObsMethodDesc:%String,ObsUser:%String,ObsSign:%String,ObsTime:%String,ObsType:%String,ObsName:%String,OpportCodeList:%String,FacilitCode:%String,IsGloving:%String,IsCorrect:%String,ErrResCode:%String") [ SqlProc ]
{
}

ClassMethod QryHandHyRegTimExecute(ByRef qHandle As %Binary, aRegID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aRegID="") $$$OK
    
    Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(aRegID)
    Quit:'$IsObject(objReg) $$$OK
    Set IsActive=objReg.HHIsActive
    Quit:IsActive'=1 $$$OK
    If $IsObject(objReg.HHLocDr) {
        Set LocID    = objReg.HHLocDr.%Id()
        Set LocDesc  = objReg.HHLocDr.BTDesc
        Set LocDesc2 = objReg.HHLocDr.BTDesc2
        Set:LocDesc2'="" LocDesc=LocDesc2
        Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
    }Else {
        Set (LocID,LocDesc)=""   
    }
    Set ObsDate=objReg.HHObsDate
    Set:ObsDate'="" ObsDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ObsDate)    
    If $IsObject(objReg.HHObsPageDr) {
        Set ObsPageID    = objReg.HHObsPageDr.%Id()
        Set ObsPageDesc  = objReg.HHObsPageDr.BTDesc
    }Else {
        Set (ObsPageID,ObsPageDesc)=""   
    }
    If $IsObject(objReg.HHObsMethodDr) {
        Set ObsMethodID    = objReg.HHObsMethodDr.%Id()
        Set ObsMethodDesc  = objReg.HHObsMethodDr.BTDesc
    }Else {
        Set (ObsMethodID,ObsMethodDesc)=""   
    }           
    Set ObsUser=objReg.HHObsUser    //调查人
        
    Set xObsTypeDr=""
    For{
        Set xObsTypeDr=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xObsTypeDr))    
        Quit:xObsTypeDr=""
        
        Set xObsTime=""
        For{
            Set xObsTime=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xObsTypeDr,xObsTime)) 
            Quit:xObsTime=""    
                
            Set xSign=""
            For {
                Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xObsTypeDr,xObsTime,xSign))
                Quit:xSign=""

                Set xSubID=""
                For{
                    Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xObsTypeDr,xObsTime,xSign,xSubID))  
                    Quit:xSubID=""  
                    
                    Set RegTimID = aRegID_"||"_xSubID
                    Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(RegTimID)
                    Continue:'$IsObject(objRegTim)  
                    Continue:'$IsObject(objRegTim.HHObsTypeDr)
                    Continue:'$IsObject(objRegTim.HHFacilitDr)
                    Set ObsType = objRegTim.HHObsTypeDr.BTDesc  //调查对象
                    Set ObsTime = objRegTim.HHObsTime           //调查时机
                    Set ObsName = objRegTim.HHObsName           //被调查人姓名
                    Set ObsSign = objRegTim.HHObsSign           //区分调查人标记
                    Set OppDrList = objRegTim.HHOpportList      //手卫生指征 
                    Set OpportCodeList=""
                    For indx=1:1:$l(OppDrList,",") {
                        Set OpportID=$p(OppDrList,",",indx)
                        Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(OpportID)
                        Continue:'$IsObject(objDic) 
                        Set OppCode = objDic.BTCode
                        Set OpportCodeList=OpportCodeList_","_OppCode
                    }
                    Set:OpportCodeList'="" OpportCodeList=$e(OpportCodeList,2,$l(OpportCodeList))   
                        
                    Set FacilitID = objRegTim.HHFacilitDr.%Id()      //手卫生措施
                    Set FacilitCode = objRegTim.HHFacilitDr.BTCode         
                    Set IsGloving = objRegTim.HHIsGloving            // 是否戴手套
                    Set IsCorrect = objRegTim.HHIsCorrect            // 是否正确            
                    
                    Set (ErrResID,ErrResCode)=""
                    If $IsObject(objRegTim.HHErrResDr) {
                        Set ErrResID = objRegTim.HHErrResDr.%Id()            //不正确原因
                        Set ErrResCode = objRegTim.HHErrResDr.BTCode
                    }
                    
                    Set ErrResDrList = objRegTim.HHErrResDr     //不正确原因 
                    Set ErrResList=""
                    For indx=1:1:$l(ErrResDrList,",") {
                        Set ErrResID=$p(ErrResDrList,",",indx)
                        Set objDic = ##class(DHCHAI.BT.Dictionary).GetObjById(ErrResID)
                        Continue:'$IsObject(objDic) 
                        Set ErrRes = objDic.BTCode
                        Set ErrResList=ErrResList_","_ErrRes
                    }
                    Set:ErrResList'="" ErrResList=$e(ErrResList,2,$l(ErrResList))   
                    
                    //拼接不正确原因其他
                    Set ErrResList = ErrResList_"!!"_objRegTim.HHErrResText 
                    Set Data=$lb(aRegID,LocID,LocDesc,ObsDate,ObsPageID,ObsPageDesc,ObsMethodID,ObsMethodDesc,ObsUser,ObsSign,ObsTime,ObsType,ObsName,OpportCodeList,FacilitCode,IsGloving,IsCorrect,ErrResList)
                    Set ^CacheTemp(repid,ind)=Data
                    Set ind=ind+1
                }
            }
        }
    }
    Quit $$$OK
}

ClassMethod QryHandHyRegTimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHandHyRegTimExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QryHandHyRegTimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHandHyRegTimExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-06-29
/// Description:  打印手卫生调查报告
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       aRegID   : 调查记录ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","HandHyRegPrint","30")
Query HandHyRegPrint(aRegID As %String) As %Query(ROWSPEC = "RegID:%String,LocID:%String,LocDesc:%String,ObsDate:%String,ObsPageID:%String,ObsPageDesc:%String,ObsMethodID:%String,ObsMethodDesc:%String,ObsUser:%String") [ SqlProc ]
{
}

ClassMethod HandHyRegPrintExecute(ByRef qHandle As %Binary, aRegID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aRegID="") $$$OK
    
    Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(aRegID)
    Quit:'$IsObject(objReg) $$$OK
    Set IsActive=objReg.HHIsActive
    Quit:IsActive'=1 $$$OK
    If $IsObject(objReg.HHLocDr) {
        Set LocID    = objReg.HHLocDr.%Id()
        Set LocDesc  = objReg.HHLocDr.BTDesc
        Set LocDesc2 = objReg.HHLocDr.BTDesc2
        Set:LocDesc2'="" LocDesc=LocDesc2
        Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
    }Else {
        Set (LocID,LocDesc)=""   
    }
    Set ObsDate=objReg.HHObsDate
    Set:ObsDate'="" ObsDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ObsDate)    
    If $IsObject(objReg.HHObsPageDr) {
        Set ObsPageID    = objReg.HHObsPageDr.%Id()
        Set ObsPageDesc  = objReg.HHObsPageDr.BTDesc
    }Else {
        Set (ObsPageID,ObsPageDesc)=""   
    }
    If $IsObject(objReg.HHObsMethodDr) {
        Set ObsMethodID    = objReg.HHObsMethodDr.%Id()
        Set ObsMethodDesc  = objReg.HHObsMethodDr.BTDesc
    }Else {
        Set (ObsMethodID,ObsMethodDesc)=""   
    }           
    Set ObsUser=objReg.HHObsUser    //调查人
        
    Set Data=$lb(aRegID,LocID,LocDesc,ObsDate,ObsPageID,ObsPageDesc,ObsMethodID,ObsMethodDesc,ObsUser)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
            
    Quit $$$OK
}

ClassMethod HandHyRegPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HandHyRegPrintExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod HandHyRegPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HandHyRegPrintExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-06-29
/// Description:  打印手卫生调查报告
/// Table：       DHCHAI.IR.HandHyRegTim
/// Input：       aRegID   : 调查记录ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.IRS.HandHyRegSrv","HandHyTimPrint","30")
Query HandHyTimPrint(aRegID As %String) As %Query(ROWSPEC = "ind:%Integer,RegID:%String,ObsTim:%String,ObsTypeA:%String,ObsNameA:%String,OpportListA:%String,FacilitA:%String,ObsErrResA:%String,HHErrResTextA:%String,ObsTypeB:%String,ObsNameB:%String,OpportListB:%String,FacilitB:%String,ObsErrResB:%String,HHErrResTextB:%String,ObsTypeC:%String,ObsNameC:%String,OpportListC:%String,FacilitC:%String,ObsErrResC:%String,HHErrResTextC:%String") [ SqlProc ]
{
}

ClassMethod HandHyTimPrintExecute(ByRef qHandle As %Binary, aRegID As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    Quit:(aRegID="") $$$OK
    
    Kill arrResult
    Kill arrDictory
    Kill arrTimData
    Kill arrData
    
    Set chkY="√",chkN="□" 
    Set DicTypeList=$lb("HandHyOpportunity","HandHyFacilities","HandHyErrReason")   //手卫生指征/手卫生措施/不正确原因  
    For indD=1:1:$ll(DicTypeList)  {
        Set DicType= $li(DicTypeList,indD)
        Continue:DicType=""
        Set num=0
        Set xTypeID =""
        For {
            Set xTypeID=$o(^DHCHAI.BT.DicTypeI("IdxofCode",DicType,xTypeID))
            Quit:xTypeID=""
            
            Set xCode=""
            For {
                Set xCode=$o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xTypeID,xCode))
                Quit:xCode=""
            
                Set xDicID = ""
                For {
                    Set xDicID = $o(^DHCHAI.BT.DictionaryI("IdxofTypeDrCode",xTypeID,xCode,xDicID))
                    Quit:xDicID=""
            
                    Set obj=##class(DHCHAI.BT.Dictionary).GetObjById(xDicID)
                    Continue:'$IsObject(obj)
                    Set DicDesc=obj.BTDesc
                    Set num =num+1
                    Set arrResult(DicType,num)=$lb(xDicID,DicDesc)
                }
            }           
        }       
    }
    
    For indC=1:1:6 {
        Set OpportunityData=$g(arrResult("HandHyOpportunity",indC))
        Set OpportID=$lg(OpportunityData,1)
        Set OpportDesc=$lg(OpportunityData,2)
        Set FacilitiesData=$g(arrResult("HandHyFacilities",indC))
        Set FacilitID=$lg(FacilitiesData,1)
        Set FacilitDesc=$lg(FacilitiesData,2)
        Set:indC=5 FacilitID="",FacilitDesc="戴手套"
        Set:indC=6 FacilitID="",FacilitDesc="正确"
        Set ErrReasonData=$g(arrResult("HandHyErrReason",indC))
        Set ErrResID=$lg(ErrReasonData,1)
        Set ErrResDesc=$lg(ErrReasonData,2)
        Set arrDictory(indC)=$lb(OpportID,OpportDesc,FacilitID,FacilitDesc,ErrResID,ErrResDesc)
    }

    Set arrTimData("A")=""
    Set arrTimData("B")=""
    Set arrTimData("C")=""    
    Set xType=""
    For {
        Set xType=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xType))
        Quit:xType=""
        
        Set xTim=""
        For {
            Set xTim=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xType,xTim))
            Quit:xTim=""
            
            Set xSign=""
            For {
                Set xSign=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xType,xTim,xSign))
                Quit:xSign=""
                Continue:'$d(arrTimData(xSign)) // add 20211117 处理bug:2284721老版本手卫生依从性调查使用新版展示后打印内容显示不全问题修改
            
                Set xSubID=""
                For {
                    Set xSubID=$o(^DHCHAI.IR.HandHyRegI("Tim","IndexObsTypeTime",aRegID,xType,xTim,xSign,xSubID))
                    Quit:xSubID=""
                    Set ChildTimID=aRegID_"||"_xSubID
                    Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(ChildTimID)
                    Continue:'$IsObject(objRegTim)
                    Continue:'$IsObject(objRegTim.HHObsTypeDr)
                    Continue:'$IsObject(objRegTim.HHFacilitDr)
                    Set ObsType = objRegTim.HHObsTypeDr.BTDesc      //调查对象
                    Set ObsTime = objRegTim.HHObsTime               //调查时机
                    Set ObsName = objRegTim.HHObsName               //被调查人姓名
                    Set IsGloving = objRegTim.HHIsGloving           //是否戴手套
                    Set IsCorrect = objRegTim.HHIsCorrect           //是否正确
                    Set FacilitID = objRegTim.HHFacilitDr.%Id()     //手卫生措施
                    Set OppDr = objRegTim.HHOpportList              //手卫生指征 
                    Set ErrResDr = objRegTim.HHErrResDr             //不正确原因 
                    Set HHErrResText=objRegTim.HHErrResText         //不正确原因(其他) 
                   
                    Set arrTimData(xSign,ObsTime)=$lb(ObsType,ObsName,OppDr,FacilitID,IsGloving,IsCorrect,ErrResDr,HHErrResText)
                }
            }
        }
    }
    
    For xTim=1:1:5 {
        For xCount=1:1:6 {   
            Set DicList =$g(arrDictory(xCount))         
            Set OpportID =$lg(DicList,1)
            Set OpportDesc =$lg(DicList,2)
            Set DicFacilitID =$lg(DicList,3)
            Set FacilitDesc =$lg(DicList,4)
            Set DicErrResID =$lg(DicList,5)
            Set ErrResDesc =$lg(DicList,6)
                                    
            Set xType=""
            For {
                Set xType=$o(arrTimData(xType))
                Quit:xType=""
                Set (ObsType,ObsName,OpportList,FacilitList,ErrResList)=""
               
                If ($g(arrTimData(xType,xTim))=""){   //未填写内容
                    Set OpportList=chkN_OpportDesc
                    Set FacilitList=chkN_FacilitDesc                        
                    Set:ErrResDesc'="" ErrResList=chkN_ErrResDesc
                    
                    Set arrData(xTim,xType,xCount)= $lb(ObsType,ObsName,OpportList,FacilitList,ErrResList,"")
                } Else{
                    Set TimData = $g(arrTimData(xType,xTim))
                    Set ObsType =$lg(TimData,1)
                    Set ObsName =$lg(TimData,2)
                    Set OppDr =$lg(TimData,3)
                    Set FacilitID =$lg(TimData,4)
                    Set IsGloving =$lg(TimData,5)
                    Set IsCorrect =$lg(TimData,6)
                    Set ErrResDr =$lg(TimData,7)
                    Set HHErrResText=$lg(TimData,8)
                    
                    If (","_OppDr_",")[(","_OpportID_",") {                     
                        Set OpportList=chkY_OpportDesc
                    }Else {
                        Set OpportList=chkN_OpportDesc
                    }
                    
                    If (DicFacilitID=FacilitID) {
                        Set FacilitList=chkY_FacilitDesc
                    }Else {
                        If (DicFacilitID'=""){
                            Set FacilitList=chkN_FacilitDesc                        
                        }Else {
                            If (FacilitDesc="戴手套") {
                                Set FacilitList=$s(IsGloving=1:chkY_FacilitDesc,1:chkN_FacilitDesc)
                            }
                            If (FacilitDesc="正确") {
                                Set FacilitList=$s(IsCorrect=1:chkY_FacilitDesc,1:chkN_FacilitDesc)
                            }
                        }
                    }
                
                    If (ErrResDr'="")&&((","_ErrResDr_",")[(","_DicErrResID_",")) {
                        Set ErrResList=chkY_ErrResDesc
                    }Else {
                        Set:ErrResDesc'="" ErrResList=chkN_ErrResDesc
                    }
                    
                    Set arrData(xTim,xType,xCount)= $lb(ObsType,ObsName,OpportList,FacilitList,ErrResList,HHErrResText)
                }
            }
            
            Set TypeData=""
            Set xSign=""
            For {
                Set xSign=$o(arrData(xTim,xSign))
                Quit:xSign=""
                Set TypeData = TypeData_$g(arrData(xTim,xSign,xCount))
            }
            
            Set Data=$lb(ind,aRegID,xTim)_TypeData
            Set ^CacheTemp(repid,ind)=Data
            Set ind=ind+1
        
        }   
    }
    
    Kill arrResult
    Kill arrDictory
    Kill arrTimData
    Kill arrData
            
    Quit $$$OK
}

ClassMethod HandHyTimPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HandHyTimPrintExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod HandHyTimPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HandHyTimPrintExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-07-01
/// Description:  根据调查表ID查找调查表各类调查类型的人数
/// Table：       DHCHAI.IR.HandHyReg、DHCHAI.IR.HandHyRegCnt
/// Input：       aRegID:调查表ID
/// Return：      调查人数
/// w ##class(DHCHAI.IRS.HandHyRegSrv).GetCntByReg(35)
ClassMethod GetCntByReg(aRegID As %String) As %String
{
    New (aRegID)
    Set return=""   
    Quit:(aRegID="") return
    Set (ObsCountA,ObsCountB,ObsCountC,ObsCountD)=0
    Set xCntSub=0
    For {
        Set xCntSub=$o(^DHCHAI.IR.HandHyRegD(aRegID,"Cnt",xCntSub))
        Quit:xCntSub=""
        
        Set ChildCntID=aRegID_"||"_xCntSub
        Set objRegCnt=##class(DHCHAI.IR.HandHyRegCnt).GetObjById(ChildCntID)
        Continue:'$IsObject(objRegCnt)
        Continue:'$IsObject(objRegCnt.HHObsTypeDr)
        Set ObsSign=objRegCnt.HHObsSign
        Set ObsCount=objRegCnt.HHObsCount
        Set:ObsSign="A" ObsCountA=ObsCount
        Set:ObsSign="B" ObsCountB=ObsCount
        Set:ObsSign="C" ObsCountC=ObsCount
        Set:ObsSign="D" ObsCountD=ObsCount      
    }
    Set return=ObsCountA_","_ObsCountB_","_ObsCountC_","_ObsCountD
    Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-07-01
/// Description:  处理环境卫生学版本变化导致历史数据不显示问题（新版只展示一页中的前3种调查类型）
/// Return：      处理数
/// w ##class(DHCHAI.IRS.HandHyRegSrv).UpdateRegByVer()
ClassMethod UpdateRegByVer() As %String
{
    Set return=0,RegCount=0 ,TimCount=0,CntCount=0
    Set RegVer=##class(DHCHAI.BT.Config).GetValByCode("HandHyRegVer")
    Quit:RegVer'=2 return 
    
    Set CurrTime = $h
    
    Set xRegID=0
    For {
        Set xRegID=$o(^DHCHAI.IR.HandHyRegD(xRegID))
        Quit:xRegID=""
        
        Set objReg=##class(DHCHAI.IR.HandHyReg).GetObjById(xRegID)
        Continue:'$IsObject(objReg)
        If '$IsObject(objReg.HHObsMethodDr) {   //最初版本没有调查方式        
            Set obj=##class(DHCHAI.IR.HandHyReg).%OpenId(xRegID)
            Continue:'$IsObject(obj) 
            Set objMethod = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("HandHyObsMethod","督查")
            Set obj.HHObsMethodDr=objMethod
            Set sc=obj.%Save()
            if $system.Status.IsError(sc) {        //检查Save是否成功
                Do $system.OBJ.DisplayError(sc)
                Set return=-1
            }else{
                Set RegCount=RegCount+1
                Set return=obj.%Id()
            }
            Do obj.%Close()
        }
    
        Set xTimSub=0
        For {
            Set xTimSub=$o(^DHCHAI.IR.HandHyRegD(xRegID,"Tim",xTimSub))
            Quit:xTimSub=""
            
            Set ChildTimID=xRegID_"||"_xTimSub
            Set objRegTim=##class(DHCHAI.IR.HandHyRegTim).GetObjById(ChildTimID)
            Continue:'$IsObject(objRegTim)
            Continue:'$IsObject(objRegTim.HHObsTypeDr)
            Set ObsSign=objRegTim.HHObsSign
            Continue:ObsSign'=""                 //版本2新增调查标记        
            Set ObsType = objRegTim.HHObsTypeDr.BTCode      
            Set:ObsType=1 ObsSign="A"
            Set:ObsType=2 ObsSign="B"
            Set:ObsType=3 ObsSign="C"
            Set:ObsType=4 ObsSign="D"
            Set:ObsType=5 ObsSign="E"
            Set:ObsType=6 ObsSign="F"
            
            Set objTim=##class(DHCHAI.IR.HandHyRegTim).%OpenId(ChildTimID)
            Continue:'$IsObject(objTim) 
            Set objTim.HHObsSign=ObsSign
            Set sc=objTim.%Save()
            if $system.Status.IsError(sc) {        //检查Save是否成功
                Do $system.OBJ.DisplayError(sc)
                Set return=-1
            }else{
                Set TimCount=TimCount+1
                Set return=objTim.%Id()
            }
            Do objTim.%Close()  
        }
        
        Set xCntSub=0
        For {
            Set xCntSub=$o(^DHCHAI.IR.HandHyRegD(xRegID,"Cnt",xCntSub))
            Quit:xCntSub=""
            
            Set ChildCntID=xRegID_"||"_xCntSub
            Set objRegCnt=##class(DHCHAI.IR.HandHyRegCnt).GetObjById(ChildCntID)
            Continue:'$IsObject(objRegCnt)
            Continue:'$IsObject(objRegCnt.HHObsTypeDr)
            Set ObsSign=objRegCnt.HHObsSign
            Continue:ObsSign'=""                 //版本2新增调查标记        
            Set ObsType = objRegCnt.HHObsTypeDr.BTCode      
            Set:ObsType=1 ObsSign="A"
            Set:ObsType=2 ObsSign="B"
            Set:ObsType=3 ObsSign="C"
            Set:ObsType=4 ObsSign="D"
            Set:ObsType=5 ObsSign="E"
            Set:ObsType=6 ObsSign="F"
            
            Set objCnt=##class(DHCHAI.IR.HandHyRegCnt).%OpenId(ChildCntID)
            Continue:'$IsObject(objCnt) 
            Set objCnt.HHObsSign=ObsSign
            Set sc=objCnt.%Save()
            if $system.Status.IsError(sc) {        //检查Save是否成功
                Do $system.OBJ.DisplayError(sc)
                Set return=-1
            }else{
                Set CntCount=CntCount+1
                Set return=objCnt.%Id()
            }
            Do objTim.%Close()  
        }
    }
    
    //重建索引
    d ##class(DHCHAI.IR.HandHyReg).%BuildIndices()
    d ##class(DHCHAI.IR.HandHyRegTim).%BuildIndices()
    d ##class(DHCHAI.IR.HandHyRegCnt).%BuildIndices()
    
    Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
    
    Set return="共处理："_RegCount_"^"_TimCount_"^"_CntCount
    Quit return
}

/// Creator：     chenjb
/// CreatDate：   2022-02-23
/// Description:  同步移动端保存手卫生调查报告信息
/// Table：       DHCHAI.IR.HandHyReg
/// Input：       inputStr : 手卫生调查报告信息
///               aInputRegTim : 手卫生时机信息
///               aInputRegCnt : 手卫生人数信息
/// Return：      DHCHAI.IR.HandHyReg.%Id()
/// w ##Class(DHCHAI.IRS.HandHyRegSrv).SaveHHRegByPhone()
ClassMethod SaveHHRegByPhone(aInputStr As %String, aInputRegTim As %String, aInputRegCnt As %String) As %String
{
    New (aInputStr,aInputRegTim,aInputRegCnt)
    Set return=0
    Quit:(aInputStr="") return

    Set $ZT="SaveHHRegByPhoneErr"
    //记录日志
    Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
    Set YY=$p(Date,"-",1)
    Set MM=$p(Date,"-",2)
    Set DD=+$p(Date,"-",3)
    //Set NUM=$i(^DHCHAI.IRS.HandHyRegTask(YY_"-"_MM,DD))
    //Set ^DHCHAI.IRS.HandHyRegTask(YY_"-"_MM,DD,NUM,"移动端同步入参")=$lb(aInputStr,aInputRegTim,aInputRegCnt)
    //组织保存数据
    K ^DHCHAI.IRS.HandHyRegTask("Tmp")
    Set HHLocDr= $p(aInputStr,"^",2)  //调查科室
    Set HHObsDate=$p(aInputStr,"^",3) //调查日期
    Set ObsUser =$p(aInputStr,"^",4) //调查人
    Set ObsMethodDr=+##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsMethod","自查",1)  //调查方式
    Set RegUserDr =##class(DHCHAI.BT.SysUser).GetIDByCode("med")  //写死用户
    //ID^HHLocDr^ObsMethodDr^PageDr^HHObsDate^ObsUser^1^^^RegUserDr
    Set RegTimeCnt = +$l(aInputRegTim,",")
    Set currIdx=1
    For indPage=1:1:4 {
        Set PageDr = +##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsPage","第"_indPage_"页",1)
        Continue:PageDr=0
        Continue:currIdx>RegTimeCnt
        Set (AcolCnt,BcolCnt,CcolCnt)=0  //调查人数
        Set AllPageRegInfo="",AllPageTimeInfo="",AllPageTimeCntInfo=""
        //A列5行 固定的
        //I1=手卫生指征 I2=手卫生措施(行为) I3= 戴手套 I4=正确 I5=不正确原因
        For indTime=1:1:5
        {
            Set xTimeStr = $p(aInputRegTim,",",currIdx)         
            Continue:xTimeStr=""
            Set xTimeRole=$p(xTimeStr,"^",1)
            Set xSJDesc =$p(xTimeStr,"^",3)  //时机
            Set xXwDesc =$p(xTimeStr,"^",4)
            Set xI3Dst =+$p(xTimeStr,"^",6)
            Set xI4Zq =+$p(xTimeStr,"^",5)
            Set xI5Bzq =$p(xTimeStr,"^",7)
            Set xBdcName =$p(xTimeStr,"^",8)
            Continue:xSJDesc=""
            //专业
            Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType",xTimeRole,"1")
            Continue:ObsTypeDr=""
            //行为措施
            Set xXwDescDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyFacilities",xXwDesc,"1")
            Continue:xXwDescDr=""
            Quit:'$d(^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"A",ObsTypeDr))&(indTime>1)
            Set ^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"A",ObsTypeDr)=""            
            
            //A1-I1-332,A1-I1-333,A1-I1-334,A1-I4,A1-I2-337,Type-340,Name-,Sign-A
            Set I1Str = "",I1Cnt = $l(xSJDesc,"#")
            For I1Idx=1:1:I1Cnt {
                Set xTmpSjDesc = $p(xSJDesc,"#",I1Idx)
                Set xTmpSjDr = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyOpportunity",xTmpSjDesc,"1")
                Set:I1Str'="" I1Str=I1Str_","_"A"_indTime_"-I1-"_xTmpSjDr
                Set:I1Str="" I1Str="A"_indTime_"-I1-"_xTmpSjDr
            }
            //I5-不正确原因
            Set I5Str = "",I5Cnt = $l(xI5Bzq,"#")
            if (xI5Bzq'="")
            {               
                For I5Idx=1:1:I5Cnt {
                    Set xTmpBzqDesc = $p(xI5Bzq,"#",I5Idx)
                    Set xTmpBzqDr = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyErrReason",xTmpBzqDesc,"1")
                    Set:I5Str'="" I5Str=I5Str_","_"A"_indTime_"-I5-"_xTmpBzqDr
                    Set:I5Str="" I5Str="A"_indTime_"-I5-"_xTmpBzqDr
                }
            }
            Set TmpForStr = I1Str_","_"A"_indTime_"-I2-"_xXwDescDr          
            //
            Set:xI3Dst=1 TmpForStr=TmpForStr_","_"A"_indTime_"-I3"
            Set:xI4Zq=1 TmpForStr=TmpForStr_","_"A"_indTime_"-I4"
            Set:I5Str'="" TmpForStr=TmpForStr_","_I5Str
            Set TmpForStr=TmpForStr_",Sign-A"_",Type-"_ObsTypeDr
            //人姓名
            Set TmpForStr=TmpForStr_",Name-"_xBdcName
            Set:AllPageTimeInfo'="" AllPageTimeInfo=AllPageTimeInfo_"#"_TmpForStr
            Set:AllPageTimeInfo="" AllPageTimeInfo=TmpForStr            
            Set AcolCnt=AcolCnt+1
            Set currIdx=currIdx+1
        }
        if (currIdx<=RegTimeCnt)
        {
            //B列5行 固定的
            For indTime=1:1:5
            {
                Set xTimeStr = $p(aInputRegTim,",",currIdx)             
                Continue:xTimeStr=""
                Set xTimeRole=$p(xTimeStr,"^",1)
                Set xSJDesc =$p(xTimeStr,"^",3)  //时机
                Set xXwDesc =$p(xTimeStr,"^",4)
                Set xI3Dst =+$p(xTimeStr,"^",6)
                Set xI4Zq =+$p(xTimeStr,"^",5)
                Set xI5Bzq =$p(xTimeStr,"^",7)
                Set xBdcName =$p(xTimeStr,"^",8)
                Continue:xSJDesc=""
                //专业
                Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType",xTimeRole,"1")
                Continue:ObsTypeDr=""
                //行为措施
                Set xXwDescDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyFacilities",xXwDesc,"1")
                Continue:xXwDescDr=""
                Quit:'$d(^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"B",ObsTypeDr))&(indTime>1)
                Set ^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"B",ObsTypeDr)=""            
                
                //A1-I1-332,A1-I1-333,A1-I1-334,A1-I4,A1-I2-337,Type-340,Name-,Sign-A
                Set I1Str = "",I1Cnt = $l(xSJDesc,"#")
                For I1Idx=1:1:I1Cnt {
                    Set xTmpSjDesc = $p(xSJDesc,"#",I1Idx)
                    Set xTmpSjDr = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyOpportunity",xTmpSjDesc,"1")
                    Set:I1Str'="" I1Str=I1Str_","_"B"_indTime_"-I1-"_xTmpSjDr
                    Set:I1Str="" I1Str="B"_indTime_"-I1-"_xTmpSjDr
                }
                //I5-不正确原因
                Set I5Str = "",I5Cnt = $l(xI5Bzq,"#")
                if (xI5Bzq'="")
                {               
                    For I5Idx=1:1:I5Cnt {
                        Set xTmpBzqDesc = $p(xI5Bzq,"#",I5Idx)
                        Set xTmpBzqDr = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyErrReason",xTmpBzqDesc,"1")
                        Set:I5Str'="" I5Str=I5Str_","_"B"_indTime_"-I5-"_xTmpBzqDr
                        Set:I5Str="" I5Str="B"_indTime_"-I5-"_xTmpBzqDr
                    }
                }
                Set TmpForStr = I1Str_","_"B"_indTime_"-I2-"_xXwDescDr          
                //
                Set:xI3Dst=1 TmpForStr=TmpForStr_","_"B"_indTime_"-I3"
                Set:xI4Zq=1 TmpForStr=TmpForStr_","_"B"_indTime_"-I4"
                Set:I5Str'="" TmpForStr=TmpForStr_","_I5Str
                Set TmpForStr=TmpForStr_",Sign-B"_",Type-"_ObsTypeDr
                //人姓名
                Set TmpForStr=TmpForStr_",Name-"_xBdcName
                Set:AllPageTimeInfo'="" AllPageTimeInfo=AllPageTimeInfo_"#"_TmpForStr
                Set:AllPageTimeInfo="" AllPageTimeInfo=TmpForStr
                Set BcolCnt=BcolCnt+1
                Set currIdx=currIdx+1
            }
        }
        if (currIdx<=RegTimeCnt)
        {
            //C列5行 固定的
            For indTime=1:1:5
            {
                Set xTimeStr = $p(aInputRegTim,",",currIdx)             
                Continue:xTimeStr=""
                Set xTimeRole=$p(xTimeStr,"^",1)
                Set xSJDesc =$p(xTimeStr,"^",3)  //时机
                Set xXwDesc =$p(xTimeStr,"^",4)
                Set xI3Dst =+$p(xTimeStr,"^",6)
                Set xI4Zq =+$p(xTimeStr,"^",5)
                Set xI5Bzq =$p(xTimeStr,"^",7)
                Set xBdcName =$p(xTimeStr,"^",8)
                Continue:xSJDesc=""
                //专业
                Set ObsTypeDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyObsType",xTimeRole,"1")
                Continue:ObsTypeDr=""
                //行为措施
                Set xXwDescDr=##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyFacilities",xXwDesc,"1")
                Continue:xXwDescDr=""
                Quit:'$d(^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"C",ObsTypeDr))&(indTime>1)
                Set ^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"C",ObsTypeDr)=""            
                
                //A1-I1-332,A1-I1-333,A1-I1-334,A1-I4,A1-I2-337,Type-340,Name-,Sign-A
                Set I1Str = "",I1Cnt = $l(xSJDesc,"#")
                For I1Idx=1:1:I1Cnt {
                    Set xTmpSjDesc = $p(xSJDesc,"#",I1Idx)
                    Set xTmpSjDr = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyOpportunity",xTmpSjDesc,"1")
                    Set:I1Str'="" I1Str=I1Str_","_"C"_indTime_"-I1-"_xTmpSjDr
                    Set:I1Str="" I1Str="C"_indTime_"-I1-"_xTmpSjDr
                }
                //I5-不正确原因
                Set I5Str = "",I5Cnt = $l(xI5Bzq,"#")
                if (xI5Bzq'="")
                {               
                    For I5Idx=1:1:I5Cnt {
                        Set xTmpBzqDesc = $p(xI5Bzq,"#",I5Idx)
                        Set xTmpBzqDr = ##Class(DHCHAI.BTS.DictionarySrv).GetIDByDesc("HandHyErrReason",xTmpBzqDesc,"1")
                        Set:I5Str'="" I5Str=I5Str_","_"C"_indTime_"-I5-"_xTmpBzqDr
                        Set:I5Str="" I5Str="C"_indTime_"-I5-"_xTmpBzqDr
                    }
                }
                Set TmpForStr = I1Str_","_"C"_indTime_"-I2-"_xXwDescDr          
                //
                Set:xI3Dst=1 TmpForStr=TmpForStr_","_"C"_indTime_"-I3"
                Set:xI4Zq=1 TmpForStr=TmpForStr_","_"C"_indTime_"-I4"
                Set:I5Str'="" TmpForStr=TmpForStr_","_I5Str
                Set TmpForStr=TmpForStr_",Sign-C"_",Type-"_ObsTypeDr
                //人姓名
                Set TmpForStr=TmpForStr_",Name-"_xBdcName
                Set:AllPageTimeInfo'="" AllPageTimeInfo=AllPageTimeInfo_"#"_TmpForStr
                Set:AllPageTimeInfo="" AllPageTimeInfo=TmpForStr
                Set currIdx=currIdx+1
                Set CcolCnt=CcolCnt+1
            }
        }
        //分页保存
        Quit:AllPageTimeInfo=""  //没有时机
        //
        Set AllPageRegInfo=""_"^"_HHLocDr_"^"_ObsMethodDr_"^"_PageDr_"^"_HHObsDate_"^"_ObsUser_"^1^^^"_RegUserDr
        Set xTmpObsType=$o(^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"A",""))
        Continue:xTmpObsType="" //优先排第一列无数据 退出
        Set AllPageTimeCntInfo=xTmpObsType_","_AcolCnt_",A"     
        Set xTmpObsType=$o(^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"B",""))
        if (xTmpObsType="")
        {
            Set AllPageTimeCntInfo=AllPageTimeCntInfo_"#,,#,,"
        }
        else
        {
            Set AllPageTimeCntInfo=AllPageTimeCntInfo_"#"_xTmpObsType_","_BcolCnt_",B"
            Set xTmpObsType=$o(^DHCHAI.IRS.HandHyRegTask("Tmp",PageDr,"C",""))
            if (xTmpObsType="")
            {
                Set AllPageTimeCntInfo=AllPageTimeCntInfo_"#,,"
            }
            else
            {
                Set AllPageTimeCntInfo=AllPageTimeCntInfo_"#"_xTmpObsType_","_CcolCnt_",C"
            }
        }   
        //w AllPageRegInfo,!
        //w AllPageTimeInfo,!
        //w AllPageTimeCntInfo,!    
        Set return=..SaveHandHyReg(AllPageRegInfo,AllPageTimeInfo,AllPageTimeCntInfo)
    }
    Quit return
SaveHHRegByPhoneErr
    Quit -999_"^"_$ZError
}

}

/// Description:跨科诊间预约号别配置
/// CreatTime:  2019-09-26
/// Creator:    nk
/// 适用版本：  iMedical8.2 HUI版本
Class web.DHCDocRegDocAppiont Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindRegDocAppoint(RegLocID As %String, RegDocID As %String, HospID As %String = "", AppLocID As %String = "", AppMarkID As %String = "") As %Query(ROWSPEC = "RowID:%String,RegLocID:%String,RegLocDesc:%String, AppLocID:%String,AppLocDesc:%String,AppMarkID:%String,AppMarkDesc:%String,RegDocID:%String,RegDocDesc:%String,AppNumber:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocRegDocAppiont","FindRegDocAppoint","","","3","","")
ClassMethod FindRegDocAppointExecute(ByRef QHandle As %Binary, RegLocID As %String, RegDocID As %String, HospID As %String = "", AppLocID As %String = "", AppMarkID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ^tempqujian("FindRegDocAppoint")=$LB(RegLocID, RegDocID, HospID , AppLocID, AppMarkID)
    s ind=1
    s AppMarkIDStr=AppMarkID
    i AppMarkIDStr'="" {
        i $e(AppMarkIDStr,1,1)'="^" s AppMarkIDStr="^"_AppMarkIDStr
        i $e(AppMarkIDStr,$l(AppMarkIDStr),$l(AppMarkIDStr))'="^" s AppMarkIDStr=AppMarkIDStr_"^"
    }
    
    i RegLocID'=""  d
    .s RowID=0
    .f  s RowID=$O(^User.DHCDocRegDocAppointI("RDAPPRegLocDRIndex",RegLocID,RowID)) Q:RowID=""  d
    ..s RBASDr=$LG(^User.DHCDocRegDocAppointD(RowID),3)
    ..s DocID=$LG(^User.DHCDocRegDocAppointD(RowID),4)
    ..Q:(RegDocID'="")&&(RegDocID'=DocID)
    ..s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
    ..Q:('$d(^CTLOC(LocIDsub)))
    ..Q:(AppLocID'="")&&(AppLocID'=LocIDsub)
    ..s HosptialDr=$p($g(^CTLOC(LocIDsub)),"^",22)
    ..Q:HosptialDr'=HospID
    ..s CTLOCDesc=$P(^CTLOC(LocIDsub),"^",2)
    ..Q:(AppMarkIDStr'="")&&(AppMarkIDStr'[("^"_+RBASDr_"^"))
    ..s MarkDr=$p($g(^RB("RES",+RBASDr)),"^",2)
    ..s MarkDesc=$P($G(^CTPCP(MarkDr,1)),"^",2)
    ..s AppNumber=$LG(^User.DHCDocRegDocAppointD(RowID),5)
    ..Do OutputRowRDA
    else  d
    .s RowID=0
    .f  s RowID=$O(^User.DHCDocRegDocAppointD(RowID)) Q:RowID=""  d
    ..s RegLocID=$LG(^User.DHCDocRegDocAppointD(RowID),2)
    ..s DocID=+$LG(^User.DHCDocRegDocAppointD(RowID),4)
    ..Q:(RegDocID'="")&&(RegDocID'=DocID)
    ..s RBASDr=$LG(^User.DHCDocRegDocAppointD(RowID),3)
    ..s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
    ..Q:('$d(^CTLOC(LocIDsub)))
    ..Q:(AppLocID'="")&&(AppLocID'=LocIDsub)
    ..s HosptialDr=$p($g(^CTLOC(LocIDsub)),"^",22)
    ..Q:HosptialDr'=HospID
    ..s CTLOCDesc=$P(^CTLOC(LocIDsub),"^",2)
    ..Q:(AppMarkIDStr'="")&&(AppMarkIDStr'[("^"_+RBASDr_"^"))
    ..s MarkDr=$p($g(^RB("RES",+RBASDr)),"^",2)
    ..s MarkDesc=$P($G(^CTPCP(+MarkDr,1)),"^",2)
    ..s AppNumber=$LG(^User.DHCDocRegDocAppointD(RowID),5)
    ..Do OutputRowRDA
    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowRDA
    set RegLocDesc=$P(^CTLOC(RegLocID),"^",2)
    if RegLocDesc["-" s RegLocDesc=$p(RegLocDesc,"-",2)
    set DocDesc=""
    if DocID'="" s DocDesc=$p($g(^CTPCP(DocID,1)),"^",2)
    set Data=$lb(RowID,RegLocID,RegLocDesc,LocIDsub,CTLOCDesc,RBASDr,MarkDesc,DocID,DocDesc,AppNumber)
    Set ^CacheTemp(repid,ind)=Data  
    Set ind=ind+1
    quit
}

ClassMethod FindRegDocAppointClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindRegDocAppointExecute ]
{
    // Clean up by purging the temporary node in ^CacheTemp global
    //New repid
    Set repid=$li(QHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindRegDocAppointFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRegDocAppointExecute ]
{
    //New repid,ind
    Set AtEnd=$li(QHandle,1)
    Set repid=$li(QHandle,2)
    Set ind=$li(QHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" { // if there are no more rows, finish fetching
         Set AtEnd=1
         Set Row=""
    }
    Else      { // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    s QHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 科室预约权限设置 设置可以互相约的科室号别
ClassMethod SetUserCanDo(Loc As %String, RESRowIDStr As %String, DocID As %String, AppNum As %String) As %String
{
    s ^tmpnk("SetUserCanDo")=Loc_","_RESRowIDStr_","_DocID
    s ret=0
    k retArr
    if RESRowIDStr'=""{
        s RESRowIDStrLen=$l(RESRowIDStr,"^")
        for myic=1:1:RESRowIDStrLen{
            s RESRowID=$p(RESRowIDStr,"^",myic)
            continue:RESRowID=""
            ;s RowID=$o(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",Loc,RESRowID,""))
            s RowID=..CheckUserCanDo(Loc,RESRowID,DocID)
            s RESDesc=$p(^RB("RES",RESRowID),"^",17)
            if RowID'=""{
                if DocID'=""{
                    if $d(retArr("-103")) s retArr("-103")=retArr("-103")_","_RESDesc
                    else  s retArr("-103")=RESDesc
                }else{
                    if $d(retArr("-101")) s retArr("-101")=retArr("-101")_","_RESDesc
                    else  s retArr("-101")=RESDesc 
                }
            }
            continue:RowID'=""
            s Obj=##class(User.DHCDocRegDocAppoint).%New()
            d Obj.RDAPPRegLocDRSetObjectId(Loc)
            d Obj.RDAPPAppResDRSetObjectId(RESRowID)
            if (DocID'="") d Obj.RDAPPRegDocDRSetObjectId(DocID)
            s Obj.RDAPPNumber=AppNum
            s sc=Obj.%Save()
            ;If $$$ISERR(sc)
            d Obj.%Close()
            s Obj=""
        }
    }
    if $d(retArr){
        s ret=""
        s err=""
        for {
            s err=$o(retArr(err)) Q:err=""
            if err="-101" s str=retArr(err)_",号别在所选科室已维护"
            else  if err="-103" s str=retArr(err)_",就诊医生已经对照了该号别"
            else  s str=retArr(err)_",错误代码:"_err
            if ret="" s ret=str
            else  s ret=ret_"\n"_str
        }
    }
    Quit ret
}

ClassMethod UpdateUserCanDo(RowID As %String, Loc As %String, RESRowID As %String, DocID As %String = "", AppNum As %String) As %String
{
    s ^tmpnk("UpdateUserCanDo")=RowID_","_Loc_","_RESRowID_","_DocID
    /*s myRowID=..CheckUserCanDo(Loc,RESRowID,DocID)
    if myRowID'=""{
        if DocID'="" s ret="-103"
        else  s ret="-101"
        Q ret
    }*/
    s Obj=##class(User.DHCDocRegDocAppoint).%OpenId(RowID)
    d Obj.RDAPPRegLocDRSetObjectId(Loc)
    d Obj.RDAPPAppResDRSetObjectId(RESRowID)
    d Obj.RDAPPRegDocDRSetObjectId(DocID)
    s Obj.RDAPPNumber=AppNum
    s sc=Obj.%Save()
    If $$$ISERR(sc)  Quit "-102"
    d Obj.%Close()
    s Obj=""
    Quit 0
}

ClassMethod CheckUserCanDo(Loc As %String, RESRowID As %String, DocID As %String)
{
    s myRowID=""
    if DocID'=""{
        s myRowID=$o(^User.DHCDocRegDocAppointI("RDAPPLocDocResIndex",Loc,DocID,RESRowID,""))   
    }else{
        s RowID=""
        for  s RowID=$o(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",Loc,RESRowID,RowID)) Q:(RowID="")!(myRowID'="")  d
        .s DocID=$LG(^User.DHCDocRegDocAppointD(RowID),4)
        .Q:DocID'=""
        .s myRowID=RowID
    }
    Q myRowID
}

ClassMethod DeleteUserCanDo(RowID As %String) As %String
{
    ;Set IsDeleted=##class(User.DHCDocRegDocAppoint).%DeleteId(RowID)
    &sql(delete from sqluser.DHCDoc_RegDocAppoint where ID=:RowID)
    Quit SQLCODE
}

/// 获取科室配置权限
/// 先根据医生获取配置权限，若无医生权限则取科室权限
/// w ##class(web.DHCDocRegDocAppiont).GetAppCanDo(5)
ClassMethod GetAppCanDo(RegLocID As %String, RegDocID As %String = "") As %String
{
    s Rtn=""
    i RegDocID'=""{
        s RowID=0
        f  s RowID=$O(^User.DHCDocRegDocAppointI("RDAPPRegLocDocIndex",RegLocID,RegDocID,RowID)) Q:RowID=""  d
        .s RBASDr=$LG(^User.DHCDocRegDocAppointD(RowID),3)
        .s DocID=$LG(^User.DHCDocRegDocAppointD(RowID),4)
        .s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
        .s CTLOCDesc=$P(^CTLOC(LocIDsub),"^",2)
        .s MarkDr=$p($g(^RB("RES",+RBASDr)),"^",2)
        .s MarkDesc=$P($G(^CTPCP(MarkDr,1)),"^",2)
        .s SubDesc=RBASDr_"!"_CTLOCDesc_"-"_MarkDesc
        .if Rtn="" s Rtn=SubDesc
        .else  s Rtn=Rtn_"^"_SubDesc
    }
    i (Rtn="")&&(RegLocID'=""){
        s RowID=0
        f  s RowID=$O(^User.DHCDocRegDocAppointI("RDAPPRegLocDRIndex",RegLocID,RowID)) Q:RowID=""  d
        .s RBASDr=$LG(^User.DHCDocRegDocAppointD(RowID),3)
        .s DocID=$LG(^User.DHCDocRegDocAppointD(RowID),4)
        .Q:(RegDocID'="")&&(DocID'="")&&(RegDocID'=DocID)
        .s LocIDsub=$p($g(^RB("RES",+RBASDr)),"^",1)
        .s CTLOCDesc=$P(^CTLOC(LocIDsub),"^",2)
        .s MarkDr=$p($g(^RB("RES",+RBASDr)),"^",2)
        .s MarkDesc=$P($G(^CTPCP(MarkDr,1)),"^",2)
        .s SubDesc=RBASDr_"!"_CTLOCDesc_"-"_MarkDesc
        .if Rtn="" s Rtn=SubDesc
        .else  s Rtn=Rtn_"^"_SubDesc
    }
    q Rtn
}

/// 获取科室医生判断是否可跨科预约某一资源的权限
/// 先根据医生获取配置权限，若无医生权限则取科室权限
/// Input:RegLocID 预约(登录)科室Id; RegRBASDr 预约资源ID; RegDocID预约(登录)医生
/// Output:空：无权限 非空(配置表RowID)：有权限
/// w ##class(web.DHCDocRegDocAppiont).GetAppCanDoRBAS(6,2131,1636)
ClassMethod GetAppCanDoRBAS(RegLocID As %String, RegRBASDr As %String, RegDocID As %String = "") As %String
{
    s Rtn=""
    s DataDocFlag=0
    i RegDocID'=""{
        if $d(^User.DHCDocRegDocAppointI("RDAPPLocDocResIndex",RegLocID,RegDocID)){
            s DataDocFlag=1
            s Rtn=$o(^User.DHCDocRegDocAppointI("RDAPPLocDocResIndex",RegLocID,RegDocID,RegRBASDr,"")) 
        }
    }
    Q:Rtn'="" Rtn
    i (DataDocFlag=0)&&(RegLocID'=""){
        if $d(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",RegLocID)){
            s ID=0
            for {
                s ID=$o(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",RegLocID,RegRBASDr,ID)) Q:ID=""
                s RDAPPRegDocDR=$lg(^User.DHCDocRegDocAppointD(ID),4)
                continue:(RDAPPRegDocDR'="")&&(RegDocID'="")&&(RDAPPRegDocDR'=RegDocID)
                s Rtn=ID
            }
            //s Rtn=$o(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",RegLocID,RegRBASDr,"")) 
        }
    }
    Q Rtn
}

/// 获取科室可以预约的所有资源
/// DocFlag:
///          Y    返回(CTCareProv)医护人员ID!医护人员姓名!姓名简拼
///          其它 返回(RBResource)资源ID!医护人员姓名!姓名简拼
/// w ##class(web.DHCDocRegDocAppiont).GetRBResDr(986,"Y")
ClassMethod GetRBResDr(LocID As %String, QryDesc As %String = "", DocFlag As %String = "", HospID = "") As %String
{
    K FindDocMarkStrNew
    K FindDocMarkStrSort
    s QryDesc=$$ALPHAUP^SSUTIL4(QryDesc)
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s Ret=""
    if LocID'=""  d
    .s ResRowId=0
    .f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocID,ResRowId)) quit:ResRowId=""  d
    ..s MarkID=$p($g(^RB("RES",ResRowId)),"^",2)
    ..Q:MarkID=""
    ..s Ctloc=$p($g(^RB("RES",ResRowId)),"^",1)
    ..s ScheSt=$p(^RB("RES",ResRowId),"^",6)
    ..Q:ScheSt'="Y"
    ..s DateActiveFrom=$P(^RB("RES",ResRowId),"^",22)
    ..Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
    ..s DateActiveTo=$P(^RB("RES",ResRowId),"^",23)
    ..Q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
    ..Q:$D(FindDocMarkStrNew(MarkID))
    ..s ActiveFlag=$P(^CTPCP(MarkID,1),"^",9)
    ..Q:(ActiveFlag'="Y")
    ..s MarkDesc=$p($g(^CTPCP(MarkID,1)),"^",2)
    ..s MarkDescSP=##class(web.DHCINSUPort).GetCNCODE(MarkDesc,4,"")
    ..Q:(QryDesc'="")&&($$ALPHAUP^SSUTIL4(MarkDesc)'[QryDesc)&&($$ALPHAUP^SSUTIL4(MarkDescSP)'[QryDesc)
    ..Q:$D(FindDocMarkStrNew(MarkID))
    ..s FindDocMarkStrSort(MarkDescSP,ResRowId)=MarkDesc_"!"_MarkDescSP
    ..s FindDocMarkStrNew(MarkID)=""
    s MarkDescSP=""
    for  s MarkDescSP=$o(FindDocMarkStrSort(MarkDescSP)) Q:MarkDescSP=""  d
    .s ResRowId=""
    .for  s ResRowId=$o(FindDocMarkStrSort(MarkDescSP,ResRowId)) Q:ResRowId=""  d
    ..s MarkDesc=FindDocMarkStrSort(MarkDescSP,ResRowId)
    ..if DocFlag="Y" d
    ...set DocRowId=$p($g(^RB("RES",ResRowId)),"^",2)
    ...if Ret=""  s Ret=DocRowId_"!"_MarkDesc
    ...else  s Ret=Ret_"^"_DocRowId_"!"_MarkDesc
    ..else  d
    ...if Ret=""  s Ret=ResRowId_"!"_MarkDesc
    ...else  s Ret=Ret_"^"_ResRowId_"!"_MarkDesc
    q Ret
}

ClassMethod CheckDocDesc(LocId As %String, desc As %String) As %String
{
    s FindFlag=0
    q:(LocId="")||(desc="") "1"
    s desc=$$ALPHAUP^SSUTIL4(desc)
    s CTLocContactName=$P(^CTLOC(LocId),"^",43)
    //科室检索码
    s CTLocContactName=$$ALPHAUP^SSUTIL4(CTLocContactName)
    Q:(CTLocContactName[desc) "1"
    //科室名称
    s CTLocDesc=$$ALPHAUP^SSUTIL4($P(^CTLOC(LocId),"^",2))
    Q:(CTLocDesc[desc) "1"
    //别名查找
    s FindFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName("CT_Loc",LocId,desc)
    /*s SubID=0  
    f  s SubID=$O(^User.BDPAliasI("DataRef","CT_Loc",LocId,SubID)) Q:(SubID="")||(FindFlag=1)  d
    .i $D(^User.BDPAliasD(SubID)) d
    ..s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
    ..i SUbCode[desc  d
    ...s FindFlag=1*/
    Q FindFlag
}

/// 判断跨科室预约是否超出限制数量
/// w ##class(web.DHCDocRegDocAppiont).CheckForASNumber("1633||9",10)
ClassMethod CheckForASNumber(ASRowID, LoginLocID)
{
    Q:ASRowID="" ""
    s rtn=0
    s ResRowId=+ASRowID
    s Childsub=$P(ASRowID,"||",2)
    s RegDocID=$p($g(^RB("RES",ResRowId)),"^",2)
    s RegLocID=$p($g(^RB("RES",ResRowId)),"^",1)
    if LoginLocID=RegLocID q 0
    s RowID=$O(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",LoginLocID,ResRowId,""))
    if (RowID'=""){
        s AppLimitNumber=$LG(^User.DHCDocRegDocAppointD(RowID),5)
        Q:AppLimitNumber="" 0
        s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
        s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //便捷排班
        if NoLimitLoadFlag="Y"{
        	s MethodUsedQty=##class(web.DHCRBApptSchedule).GetRegisterNum(ASRowID)
        	s MethodUsedQty=+$p(MethodUsedQty,"^",2)
        }else{
	        s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	        s len=$l(NormalQueueNoStr,",")
	        s MethodUsedQty=0
	        s AppMethodID=$O(^RBC("APTM",0,"Code","DOC",0))
	        f i=1:1:len{
	            s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
	            s QueueNo=$P(SingleQueueNoStr,":",1)
	            s QueueStatus=$P(SingleQueueNoStr,":",2)
	            s MethodID=$P(SingleQueueNoStr,":",3)
	            if ((MethodID=AppMethodID)&&("123"[QueueStatus)) s MethodUsedQty=MethodUsedQty+1
	        }
        }
        if (MethodUsedQty>=AppLimitNumber) s rtn=1
    }
    q rtn
}

Query RBResDrList(LocIDs As %String, QryDesc As %String, DocFlag As %String = "", ExtStr As %String = "", HospID As %String = "") As %Query(ROWSPEC = "LocId:%String,LocDesc:%String,DocId:%String,DocDesc:%String,DocAlias:%String,ChooseFlag:%String,RDAPPNum:%String,RDAPPNumStr:%String")
{
}

ClassMethod RBResDrListExecute(ByRef qHandle As %Binary, LocIDs As %String, QryDesc As %String, DocFlag As %String, ExtStr As %String = "", HospID As %String) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCDocRegDocAppiont","RBResDrList","","","Y","2")
    s ^temp("zhouc","1116",1)=$lb(LocIDs, QryDesc, DocFlag,ExtStr, HospID)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s index=0
    //根据就诊科室优先和挂号科室优先以及查询号别或医生 判断是否选中
    s (QListType,QRegLocs,QRegDocs,QAppDocs)=""
    s ListType=$p(ExtStr,"^",1)
    //1.就诊科室优先+查询号别 号别需选中
    if (ListType="RF")&&(DocFlag'="Y"){
        s QRegLocs=$p(ExtStr,"^",2)
        s QRegDocs=$p(ExtStr,"^",3)
        s:(QRegLocs'="")||(QRegDocs'="") QListType="Mark"
    }
    //2.预约科室优先+就诊就诊医生查询 医生需选中
    if (ListType="AF")&&(DocFlag="Y"){
        s QRegLocs=$p(ExtStr,"^",2)     ;此时QRegLocs=LocID
        s QAppDocs=$p(ExtStr,"^",3)
        s:(QRegLocs'="")&&(QAppDocs'="") QListType="Doc"
    }
    f LocInd=1:1:$l(LocIDs,"^"){
        s LocID=$p(LocIDs,"^",LocInd)
        continue:LocID=""
        s LocDesc=$p(^CTLOC(LocID),"^","2")
        s RBResDrStr=..GetRBResDr(LocID, QryDesc, DocFlag, HospID)
        f ResInd=1:1:$l(RBResDrStr,"^"){
            s RBResDr=$p(RBResDrStr,"^",ResInd)
            s DocId=$p(RBResDr,"!",1)
            continue:DocId=""
            s DocDesc=$p(RBResDr,"!",2)
            s DocAlias=$p(RBResDr,"!",3)
            s RDAPPNumStr=""
            s RDAPPNum=""
            s ChooseFlag="N"
            if (QListType="Mark"){
                //按医生查询号别
                if ($l(QRegDocs,"$")>0){
                    s FindNum=0
                    f IndexQDoc=1:1:$l(QRegDocs,"$") {
                        s QRegDoc=$p(QRegDocs,"$",IndexQDoc)
                        continue:QRegDoc=""
                        s RDAPPDr=..CheckUserCanDo(QRegLocs,DocId,QRegDoc)
                        continue:RDAPPDr=""
                        continue:'$d(^CTPCP(QRegDoc))
                        s QRegDocDesc=$p(^CTPCP(QRegDoc,1),"^",2)
                        s RDAPPNum=$LG(^User.DHCDocRegDocAppointD(RDAPPDr),5)
                        s RDAPPNumItem=QRegDocDesc_":"_RDAPPNum
                        s RDAPPNumStr=$s(RDAPPNumStr="":RDAPPNumItem,1:RDAPPNumStr_"<br/>"_RDAPPNumItem)
                        s FindNum=FindNum+1
                    }
                    s:(QRegDocs'="")&&(FindNum=$l(QRegDocs,"$")) ChooseFlag="Y"
                    s:$l(QRegDocs,"$")>1 RDAPPNum=""
                }
                //按科室查询号别
                if (QRegDocs="")&&($l(QRegLocs,"$")>0){
                    s FindNum=0
                    f IndexQLoc=1:1:$l(QRegLocs,"$"){
                        s QRegLoc=$p(QRegLocs,"$",IndexQLoc)
                        continue:QRegLoc=""
                        s RDAPPDr=..CheckUserCanDo(QRegLoc,DocId,"")
                        continue:RDAPPDr=""
                        s QRegLocDesc=$p(^CTLOC(QRegLoc),"^",2)
                        s RDAPPNum=$LG(^User.DHCDocRegDocAppointD(RDAPPDr),5)
                        s RDAPPNumItem=QRegLocDesc_":"_RDAPPNum
                        s RDAPPNumStr=$s(RDAPPNumStr="":RDAPPNumItem,1:RDAPPNumStr_"<br>"_RDAPPNumItem)
                        s FindNum=FindNum+1
                    }
                    s:(QRegLocs'="")&&(FindNum=$l(QRegLocs,"$")) ChooseFlag="Y"
                    s:$l(QRegLocs,"$")>1 RDAPPNum=""
                    ;b ;001
                }
            }
            if (QListType="Doc"){
                //按号别查医生
                s FindNum=0
                f IndexQMark=1:1:$l(QAppDocs,"$") {
                    s QAppDoc=$p(QAppDocs,"$",IndexQMark)
                    continue:QAppDoc=""
                    s RDAPPDr=..CheckUserCanDo(LocID,QAppDoc,DocId)
                    continue:RDAPPDr=""
                    s QAppDocId=$p($g(^RB("RES",QAppDoc)),"^",2)
                    continue:'$d(^CTPCP(QAppDocId))
                    s QAppDocDesc=$p(^CTPCP(QAppDocId,1),"^",2)
                    s RDAPPNum=$LG(^User.DHCDocRegDocAppointD(RDAPPDr),5)
                    s RDAPPNumItem=QAppDocDesc_":"_RDAPPNum
                    s RDAPPNumStr=$s(RDAPPNumStr="":RDAPPNumItem,1:RDAPPNumStr_"<br>"_RDAPPNumItem)
                    s FindNum=FindNum+1
                }
                s:(QAppDocs'="")&&(FindNum=$l(QAppDocs,"$")) ChooseFlag="Y"
                s:$l(QAppDocs,"$")>1 RDAPPNum=""
            }
            s index=index+1
            s ^CacheTemp(repid,index)=$lb(LocID,LocDesc,DocId,DocDesc,DocAlias,ChooseFlag,RDAPPNum,RDAPPNumStr)
        }
    }
    Quit $$$OK
}

ClassMethod RBResDrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RBResDrListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod RBResDrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBResDrListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }Else{
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// 获取批量处理就诊/预约科室列表
Query FindRDAPPLoc(UserId As %String, AdmType As %String, Desc As %String, AppMarks As %String, HospitalID As %String) As %Query(ROWSPEC = "CTCode:%String,CTDesc:%String,CTAlias:%String,ChooseFlag:%String,RDAPPNum:%String,RDAPPNumStr:%String")
{
}

ClassMethod FindRDAPPLocExecute(ByRef qHandle As %Binary, UserId As %String, AdmType As %String, Desc As %String, AppMarks As %String, HospitalID As %String) As %Status
{
    //d ##class(%ResultSet).RunQuery("web.DHCDocRegDocAppiont","FindRDAPPLoc","","O^E^I","","","")
    s ^temp("zhouc","1123",1)=$lb(UserId,AdmType,Desc,AppMarks,HospitalID)
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
    do rset.Execute("",AdmType,Desc,HospitalID)
    s columns = rset.GetColumnCount()
    s row=0
    s Index=0
    While (rset.Next()) {
        s CTCode=rset.GetData(1)
        s CTDesc=rset.GetData(2)
        s CTAlias=rset.GetData(3)
        s ChooseFlag="N"
        s RDAPPNumStr=""
        s RDAPPDr=""
        s RDAPPNum=""
        s FindNum=0
        f IndAppMark=1:1:$l(AppMarks,"$"){
            s AppMark=$p(AppMarks,"$",IndAppMark)
            continue:AppMark=""
            s RDAPPDr=..CheckUserCanDo(CTCode,AppMark,"")
            continue:RDAPPDr=""
            s RDAPPNum=$LG(^User.DHCDocRegDocAppointD(RDAPPDr),5)
            s AppDocId=$p($g(^RB("RES",AppMark)),"^",2)
            continue:'$d(^CTPCP(AppDocId))
            s QAppMarkDesc=$p(^CTPCP(AppDocId,1),"^",2)
            s RDAPPNumItem=QAppMarkDesc_":"_RDAPPNum
            s RDAPPNumStr=$s(RDAPPNumStr="":RDAPPNumItem,1:RDAPPNumStr_"<br>"_RDAPPNumItem)
            s FindNum=FindNum+1
        }
        s:(AppMarks'="")&&(FindNum=$l(AppMarks,"$")) ChooseFlag="Y"
        s:$l(AppMarks,"^")>1 RDAPPNum=""
        s Index=Index+1
        s ^CacheTemp(repid,Index)=$lb(CTCode,CTDesc,CTAlias,ChooseFlag,RDAPPNum,RDAPPNumStr)
    }
    
    Quit $$$OK
}

ClassMethod FindRDAPPLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRDAPPLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindRDAPPLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRDAPPLocExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
    }Else{
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/***
  **Description      :批量设置科室预约权限 设置可以互相约的科室号别
  **Author           :zhouc
  **Time             :2021/
  **debugger         :w ##Class(web.DHCDocRegDocAppiont).MulSetUserCanDo("2^377^3165:44^Mark^2849")
  **Parameter        AFLoc  按预约科室: 科室-号别 级别保存
  **                    号别1#号别2...^科室1$数量1#科室2$数量2...^删除科室1$删除科室2
  **                 AFDoc  按预约科室: 科室-医生-号别 级别保存
  **                    号别1#号别2...^科室1$医生1$数量1#科室2$医生2$数量2...^删除科室1$删除医生1#删除科室2$删除医生2
  **                 RFDoc  按就诊科室:科室-医生-号别 
  **                    科室1$医生1#科室2$医生2...^号别1$数量1#号别2$数量2...^删除号别1$删除号别2
  **                 RFLoc  按就诊科室:科室-号别
  **                    科室1#科室2...^号别1$数量1#号别2$数量2...^删除号别1$删除号别2
  **Returns          :
***/
ClassMethod MulSetUserCanDo(SaveData As %String, SaveType As %String)
{
    s ^temp("zhouc","1130",1)=$lb(SaveData,SaveType)
    s $ZT="MulSetUserCanDoErr"
    //RFLoc 按就诊科室:科室-号别 科室1#科室2...^号别1$数量1#号别2$数量2...^删除号别1$删除号别2...
    if (SaveType="RFLoc"){
        s SaveLocStr=$p(SaveData,"^",1)
        s SaveMarkStr=$p(SaveData,"^",2)
        s DelMarkStr=$p(SaveData,"^",3)
        f IndLoc=1:1:$l(SaveLocStr,"#"){
            s LocId=$p(SaveLocStr,"#",IndLoc)
            continue:LocId=""
            s DocId=""
            //保存
            f IndMark=1:1:$l(SaveMarkStr,"#"){
                s MarkItem=$p(SaveMarkStr,"#",IndMark)
                s MarkId=$p(MarkItem,"$",1)
                s AppNum=$p(MarkItem,"$",2)
                continue:MarkId=""
                d InsertRDAPP(LocId,MarkId,DocId,AppNum)
            }
            //删除
            f IndDelMark=1:1:$l(DelMarkStr,"#"){
                s DelMarkId=$p(DelMarkStr,"#",IndDelMark)
                continue:DelMarkId=""
                d DelRDAPP(LocId,DelMarkId,DocId)
            }
        }
    }
    
    //RFDoc 按就诊科室:科室-医生-号别  科室1$医生1#科室2$医生2...^号别1$数量1#号别2$数量2...!删除号别1$删除号别2
    if (SaveType="RFDoc"){
        s SaveLocDocStr=$p(SaveData,"^",1)
        s SaveMarkStr=$p(SaveData,"^",2)
        s DelMarkStr=$p(SaveData,"^",3)
        f IndLocDoc=1:1:$l(SaveLocDocStr,"#"){
            s LocDocItem=$p(SaveLocDocStr,"^",IndLocDoc)
            s LocId=$p(LocDocItem,"$",1)
            s DocId=$p(LocDocItem,"$",2)
            continue:(LocId="")||(DocId="")
            f IndMark=1:1:$l(SaveMarkStr,"#"){
                s MarkItem=$p(SaveMarkStr,"#",IndMark)
                s MarkId=$p(MarkItem,"$",1)
                s AppNum=$p(MarkItem,"$",2)
                continue:MarkId=""
                d InsertRDAPP(LocId,MarkId,DocId,AppNum)
            }
            for IndDelMark=1:1:$l(DelMarkStr,"#"){
                s DelMarkId=$p(DelMarkStr,"#",IndDelMark)
                continue:DelMarkId=""
                d DelRDAPP(LocId,DelMarkId,DocId)
            }
        }
    }
    
    //AFDoc  按预约科室: 科室-医生-号别 号别1#号别2...^科室1$医生1$数量1#科室2$医生2$数量2...^删除科室1$删除医生1#删除科室2$删除医生2
    if (SaveType="AFDoc"){
        s SaveMarkStr=$p(SaveData,"^",1)
        s SaveLocDocStr=$p(SaveData,"^",2)
        s DelLocDocStr=$p(SaveData,"^",3)
        f IndMark=1:1:$l(SaveMarkStr,"#"){
            s MarkId=$p(SaveMarkStr,"#",IndMark)
            continue:MarkId=""
            f IndLocDoc=1:1:$l(SaveLocDocStr,"#"){
                s LocDocItem=$p(SaveLocDocStr,"#",IndLocDoc)
                s LocId=$p(LocDocItem,"$",1)
                s DocId=$p(LocDocItem,"$",2)
                s AppNum=$p(LocDocItem,"$",3)
                continue:(LocId="")||(DocId="")
                d InsertRDAPP(LocId,MarkId,DocId,AppNum)
            }
            f IndDelLocDoc=1:1:$l(DelLocDocStr){
                s DelLocDocItem=$p(DelLocDocStr,"#",IndDelLocDoc)
                s DelLocId=$p(DelLocDocItem,"$",1)
                s DelDocId=$p(DelLocDocItem,"$",2)
                continue:(DelLocId="")||(DelDocId="")
                d DelRDAPP(DelLocId,MarkId,DelDocId)
            }
        }
    }
    //AFLoc  按预约科室: 科室-号别 级别保存 号别1#号别2...^科室1$数量1#科室2$数量2...^删除科室1$删除科室2
    if (SaveType="AFLoc"){
        s SaveMarkStr=$p(SaveData,"^",1)
        s SaveLocStr=$p(SaveData,"^",2)
        s DelLocStr=$p(SaveData,"^",3)
        f IndMark=1:1:$l(SaveMarkStr,"#"){
            s MarkId=$p(SaveMarkStr,"#",IndMark)
            s DocId=""
            continue:MarkId=""
            f IndLoc=1:1:$l(SaveLocStr,"#"){
                s LocItem=$p(SaveLocStr,"#",IndLoc)
                s LocId=$p(LocItem,"$",1)
                s AppNum=$p(LocItem,"$",2)
                continue:LocId=""
                d InsertRDAPP(LocId,MarkId,DocId,AppNum)
            }
            f IndDelLoc=1:1:$l(DelLocStr,"#"){
                s DelLocId=$p(DelLocStr,"#",IndDelLoc)
                continue:DelLocId=""
                d DelRDAPP(DelLocId,MarkId,DocId)
            }
        }
    }
    
    q "0^操作成功"
    
InsertRDAPP(Loc,Mark,Doc,Num)
    s RowID=..CheckUserCanDo(Loc,Mark,Doc)
    if (RowID'=""){
        s Obj=##class(User.DHCDocRegDocAppoint).%OpenId(RowID)
    }else{
        s Obj=##class(User.DHCDocRegDocAppoint).%New()
        d Obj.RDAPPRegLocDRSetObjectId(Loc)
        d Obj.RDAPPAppResDRSetObjectId(Mark)
        d:(Doc'="") Obj.RDAPPRegDocDRSetObjectId(Doc)
    }
    s Obj.RDAPPNumber=Num
    s sc=Obj.%Save()
    k Obj
    q
    
DelRDAPP(DelLoc,DelMark,DelDoc)
    s RowID=..CheckUserCanDo(DelLoc,DelMark,DelDoc)
    d:RowID'="" ..DeleteUserCanDo(RowID)
    q
MulSetUserCanDoErr
    s $ZT=""
    q "-1^"_$ze
}

}

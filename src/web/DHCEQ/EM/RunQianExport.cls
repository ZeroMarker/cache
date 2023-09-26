Class web.DHCEQ.EM.RunQianExport Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetColSets","85","10248","StoreMoveList")
Query GetColSets(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "") As %Query(ROWSPEC = "TColID:%String,TCaption:%String,TColName:%String,TPosition:%Integer,TFormat:%String,TColWidth:%String,TSort:%String") [ SqlProc ]
{
}

ClassMethod GetColSetsExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    
    if (CurTableName="") q $$$OK
    s vTableName=$ZCONVERT(CurTableName,"U")
    s vTableID=$o(^DHCEQCCode("DHCEQCTableData",0,"Code",vTableName,0))
    if (vTableID="") q $$$OK
    i $D(^DHCEQCCode("DHCEQCColSet",0,"Columns",vTableID,2,vcuruser))  d
    .s vSetType=2
    e  d
    .i $D(^DHCEQCCode("DHCEQCColSet",0,"Columns",vTableID,1,CurGroupID))  d
    ..s vSetType=1
    .e  d
    ..s vSetType=0
    i vSetType=2 s vSetID=vcuruser
    i vSetType=1 s vSetID=CurGroupID
    i vSetType=0 s vSetID=0
    
    s vsort=0
    s crowid=0
    f  s vsort=$o(^DHCEQCCode("DHCEQCColSet",0,"SetID",vTableID,vSetType,vSetID,vsort))  quit:vsort=""  d
    .s TSort=vsort
    .f  s crowid=$o(^DHCEQCCode("DHCEQCColSet",0,"SetID",vTableID,vSetType,vSetID,vsort,crowid))  quit:crowid=""  d
    ..d ResetVariablesGetColSets
    ..s TColID=$p($g(^DHCEQCCode("DHCEQCColSet",crowid)),"^",4)
    ..s TCaption=$p($g(^DHCEQCCode("DHCEQCColSet",crowid)),"^",5)
    ..i TCaption="" s TCaption=$p($g(^DHCEQCCode("DHCEQCColumns",TColID)),"^",4)
    ..s TColName=$p($g(^DHCEQCCode("DHCEQCColumns",TColID)),"^",2)
    ..s TPosition=$p($g(^DHCEQCCode("DHCEQCColumns",TColID)),"^",5)
    ..s TFormat=$p($g(^DHCEQCCode("DHCEQCColumns",TColID)),"^",7)
    ..s TColWidth=$p($g(^DHCEQCCode("DHCEQCColSet",crowid)),"^",8)
    ..d OutputRowGetColSets
    Quit $$$OK
    

OutputRowGetColSets
    s Data=$lb(TColID,TCaption,TColName,TPosition,TFormat,TColWidth,TSort)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetColSets
    s (TColID,TCaption,TColName,TPosition,TFormat,TColWidth)=""
    quit
}

ClassMethod GetColSetsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetColSetsExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetColSetsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetColSetsExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by ZY 20220929 
/// 通用润乾导出列query
/// 结合d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal() 方法生成临时数据
/// 传入对应的节点值,就能取到数据
/// 入参:Node  字符串：web.DHCEQStoreMoveList.GetStoreMoveStat
///      Date  日期
///      Job   进程号 $J
///      User  当前 User
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetTempGlobalList","Equip","65000","10248","85")
Query GetTempGlobalList(Node As %String = "", Date As %String = "", Job As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetTempGlobalListExecute(ByRef qHandle As %Binary, Node As %String = "", Date As %String = "", Job As %String = "", CurUserID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
	s index=1
    // MZY0149	3124641		2023-01-09
    i (Node="") Quit $$$OK
    i Date="" s Date=+$H
    i Job="" s Job=$J
    i CurUserID="" d
    .s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    e  d
    .s User=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    
    i '$Data(^TempDHCEQ(Node,Date,Job,User)) Quit $$$OK
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ(Node,Date,Job,User,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .d ResetVariablesGetTempGlobalList
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ(Node,Date,Job,User,vrowid))
    .///modified by ZY0286 替换掉数据中的全角括号
    .//s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .//s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    .d OutputRowGetTempGlobalList
    Quit $$$OK

OutputRowGetTempGlobalList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetTempGlobalList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetTempGlobalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempGlobalListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetTempGlobalListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempGlobalListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetEquipList","85","10248","Equip")
Query GetEquipList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (Job="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .d ResetVariablesGetEquipList
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))
    .///modified by ZY0286 替换掉数据中的全角括号
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    .d OutputRowGetEquipList
    Quit $$$OK

OutputRowGetEquipList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetEquipList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0144	3081000		2022-11-24		替换Global
/// Modefied by zc0107 20211115 设备附件导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetEquipListAffix","85","12214","Equip")
Query GetEquipListAffix(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String,Affixinfo:%String") [ SqlProc ]
{
}

ClassMethod GetEquipListAffixExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (Job="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s num=0  //Moedfied by zc0115 2022-01-27 初始化变量
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .s aEquipDR=""
    .s aEquipDR=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid,"EquipDR"))
    .i aEquipDR="" d
    ..d ResetVariablesGetEquipListAffix
    ..s TRowID=vrowid
    ..s TEquipDR=0
    ..s listinfo=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))
    ..d OutputRowGetEquipListAffix
    .e  d
    ..Set ocldr=$Piece($Get(^DHCEQEquip(aEquipDR)),"^",77)
    ..s num=0
    ..i ocldr'="" d
    ...i $Data(^DHCEQAffix(0,"CheckListDR",ocldr)) d
    ....Set affixRowId=0
    ....For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",ocldr,affixRowId))  Quit:affixRowId=""  Do
    .....Quit:$Piece($Get(^DHCEQAffix(affixRowId)),"^",15)'="N"
    .....Quit:$o(^DHCEQAffix(0,"OldRowID",aEquipDR,affixRowId,0))>0
    .....d ResetVariablesGetEquipListAffix
    .....s TEquipDR=aEquipDR
    .....s num=num+1
    .....s TRowID=vrowid
    .....s listinfo=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))
    .....s Affixinfo=num_"、"_$p($g(^DHCEQAffix(affixRowId)),"^",4)_" "_$p($g(^DHCEQAffix(affixRowId)),"^",5)_" "_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQAffix(affixRowId)),"^",6))_" "_$g(^DHCEQAffix(affixRowId,"EX"))
    .....d OutputRowGetEquipListAffix
    ...e  i '$Data(^DHCEQAffix(0,"Equip",aEquipDR)) d
    ....d ResetVariablesGetEquipListAffix
    ....s TRowID=vrowid
    ....s TEquipDR=aEquipDR
    ....s listinfo=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))
    ....d OutputRowGetEquipListAffix
    
    ..i $Data(^DHCEQAffix(0,"Equip",aEquipDR)) d
    ...d ResetVariablesGetEquipListAffix
    ...s affixRowId=0
    ...f  s affixRowId=$o(^DHCEQAffix(0,"Equip",aEquipDR,affixRowId))  quit:affixRowId=""  d
    ....q:$p($g(^DHCEQAffix(affixRowId)),"^",15)'="N"
    ....s num=num+1
    ....s Affixinfo=num_"、"_$p($g(^DHCEQAffix(affixRowId)),"^",4)_" "_$p($g(^DHCEQAffix(affixRowId)),"^",5)_" "_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQAffix(affixRowId)),"^",6))_" "_$g(^DHCEQAffix(affixRowId,"EX"))
    ...s TEquipDR=aEquipDR
    ...s TRowID=vrowid
    ...s listinfo=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))
    ...d OutputRowGetEquipListAffix
    ..i (ocldr="")&&('$Data(^DHCEQAffix(0,"Equip",aEquipDR))) d
    ...d ResetVariablesGetEquipListAffix
    ...s TRowID=vrowid
    ...s TEquipDR=aEquipDR
    ...s listinfo=$g(^TempDHCEQ("EquipList",+$H,Job,vcuruser,vrowid))
    ...d OutputRowGetEquipListAffix

    Quit $$$OK

OutputRowGetEquipListAffix
    s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")   //Moedfied by zc0115 2022-01-27 begin
    s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    s Data=$lb(TRowID,listinfo,Affixinfo)   //Moedfied by zc0115 2022-01-27 去掉不用的输出
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetEquipListAffix
    s (TRowID,listinfo,Affixinfo,TEquipDR)=""
    quit
}

ClassMethod GetEquipListAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListAffixExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetEquipListAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListAffixExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetInStockList","85","10248","InStockList","2756")
Query GetInStockList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (Job="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ("InStockDetail",+$H,Job,vcuruser,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .s (TRowID,listinfo)=""
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ("InStockDetail",+$H,Job,vcuruser,vrowid))
    .///modified by ZY0286 替换掉数据中的全角括号
    .//s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .//s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    .d OutputRowGetInStockList
    Quit $$$OK

OutputRowGetInStockList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetStoreMoveList","85","10248","StoreMoveList","2756")
Query GetStoreMoveList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    
    i (Job="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ("StoreMoveStat",+$H,Job,vcuruser,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .s (TRowID,listinfo)=""
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ("StoreMoveStat",+$H,Job,vcuruser,vrowid))
    .///modified by ZY0286 替换掉数据中的全角括号
    .//s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .//s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    .d OutputRowGetStoreMoveList
    Quit $$$OK

OutputRowGetStoreMoveList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetStoreMoveList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetStoreMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetStoreMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// modified by ZY 20221011 修改global
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetOpenCheckList","85","10248","OpenCheckList","66449")
Query GetOpenCheckList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "", RowIDS As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String,No:%String") [ SqlProc ]
{
}

ClassMethod GetOpenCheckListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "", RowIDS As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (Job="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    s rowIdIndex=1
    f  s vrowid=$o(^TempDHCEQ("CheckDetail",+$H,Job,vcuruser,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .i (RowIDS'="")&&($p(RowIDS,",",rowIdIndex)'=vrowid) q //add by zyq begin 2023-03-02 可选某条数据打印
    .s rowIdIndex=rowIdIndex+1 //add by zyq end 2023-03-02
    .d OutputRowGetOpenCheckList
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ("CheckDetail",+$H,Job,vcuruser,vrowid))
    .///modified by ZY0286 替换掉数据中的全角括号
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    .;modified by wy 2022-10-30 增加设备条码 2999801
    .s rowid=$p(listinfo,"^",1)
    .if rowid'="" d 
    ..s EquipDR=0
	..f  s EquipDR=$Order(^DHCEQEquip(0,"OpenCheckList",rowid,EquipDR)) q:EquipDR=""  d
	...s No=$p($g(^DHCEQEquip(EquipDR)),"^",71)   //设备编号
	...d OutputRowGetOpenCheckList
	Quit $$$OK

OutputRowGetOpenCheckList
	s Data=$lb(TRowID,listinfo,No)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheckList
    s (TRowID,listinfo,No)=""
    quit
}

ClassMethod GetOpenCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetOpenCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetReturnList","85","10248","ReturnList","2756")
Query GetReturnList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetReturnListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (Job="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ("ReturnDetail",+$H,Job,vcuruser,vrowid))  quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .s (TRowID,listinfo)=""
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ("ReturnDetail",+$H,Job,vcuruser,vrowid))
    .///modified by ZY0286 替换掉数据中的全角括号
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
    .d OutputRowGetReturnList
    Quit $$$OK

OutputRowGetReturnList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetReturnList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetReturnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReturnListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetReturnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReturnListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetMaintRequestDetail","85","10248","MaintRequestDetail","2756")
Query GetMaintRequestDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetMaintRequestDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("DHCEQMMaintRequestDetail",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetMaintRequestDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("DHCEQMMaintRequestDetail",+$H,Job,vrowid))
    .d OutputRowGetMaintRequestDetail
    Quit $$$OK

OutputRowGetMaintRequestDetail
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetMaintRequestDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetMaintRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetMaintRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintRequestDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetInventoryList","85","10248","InventoryList","2756")
Query GetInventoryList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBillEquipDR:%String,TBillNo:%String,TBillName:%String,TModel:%String,TUnit:%String,TBillOriginalFee:%String,TLeaveFactoryNo,TBillStoreLoc:%String,TManuFactory:%String,TProvider:%String,TEquipType:%String,TFileNo:%String,TStatCat:%String,TLeaveFactoryDate:%String") [ SqlProc ]
{
}

ClassMethod GetInventoryListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("InventoryList",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetInventoryList
    .s TRowID=vrowid
    .s TBillEquipDR=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",3)
    .s TBillNo=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",23)
    .s TBillName=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",21)
    .s TModel=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",25)
    .s TUnit=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",29)
    .s TBillOriginalFee=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",8)
    .s TLeaveFactoryNo=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",30)
    .s TBillStoreLoc=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",36)
    .s TManuFactory=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",40)
    .s TProvider=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",32)
    .s TEquipType=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",27)
    .s TFileNo=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",46)
    .s TStatCat=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",28)
    .s TLeaveFactoryDate=$p($g(^DHCEQTemp("InventoryList",+$H,Job,vrowid)),"^",31)
    .d OutputRowGetInventoryList
    Quit $$$OK

OutputRowGetInventoryList
    s Data=$lb(TRowID,TBillEquipDR,TBillNo,TBillName,TModel,TUnit,TBillOriginalFee,TLeaveFactoryNo,TBillStoreLoc,TManuFactory,TProvider,TEquipType,TFileNo,TStatCat,TLeaveFactoryDate)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetInventoryList
    s (TRowID,TBillEquipDR,TBillNo,TBillName,TModel,TUnit,TBillOriginalFee,TLeaveFactoryNo,TBillStoreLoc,TManuFactory,TProvider,TEquipType,TFileNo,TStatCat,TLeaveFactoryDate)=""
    quit
}

ClassMethod GetInventoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetInventoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetSnapEquipList","241","1","Equip","13956")
/// modify by mwz 20230106 mwz0067  修改数据来源为^TempDHCEQ
Query GetSnapEquipList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetSnapEquipListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ("SnapEquipList",+$H,Job,vrowid))  quit:vrowid=""  d      
    .d ResetVariablesGetSnapEquipList
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ("SnapEquipList",+$H,Job,vrowid))
    .d OutputRowGetSnapEquipList
    Quit $$$OK

OutputRowGetSnapEquipList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetSnapEquipList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetSnapEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSnapEquipListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetSnapEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSnapEquipListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetAInStockList","85","10248","AInStockList","2756")
Query GetAInStockList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetAInStockListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("AInStockDetail",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetAInStockList
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("AInStockDetail",+$H,Job,vrowid))
    .d OutputRowGetAInStockList
    Quit $$$OK

OutputRowGetAInStockList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAInStockList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetAInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetAInStockList","85","10248","AStoreMoveList","2756")
Query GetAStoreMoveList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetAStoreMoveListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    i CurUserID="" q $$$OK
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("AMoveStockStat",CurUserID,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetAStoreMoveList
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("AMoveStockStat",CurUserID,Job,vrowid))
    .d OutputRowGetAStoreMoveList
    Quit $$$OK

OutputRowGetAStoreMoveList
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAStoreMoveList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetAStoreMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStoreMoveListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAStoreMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStoreMoveListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","ResultStat","")
Query ResultStat(InventoryDR As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "TLocID:%String,TLocName:%String,TTotalQty:%String,TAmount:%String,TDiffQty:%String,TDiffAmount:%String,TLoseQty:%String,TLoseAmount:%String,TAccordQty:%String,TAccordAmount:%String") [ SqlProc ]
{
}

ClassMethod ResultStatExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s rowid=0
    
    new tmpNode
    new billStoreLocID,equipID,rowid,IncludeFlag
    new TLocID,TLocName,TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount
    new originalFee
    new TTotalQtySum,TAmountSum,TDiffQtySum,TDiffAmountSum,TLoseQtySum,TLoseAmountSum,TAccordQtySum,TAccordAmountSum
    
    //add by zy 2013-06-04 zy0107
    //增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
    s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022") //盘点是否包含预报废设备
    
    if ((InventoryDR'="")&&(+$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0))
    {
        s (TTotalQtySum,TAmountSum,TDiffQtySum,TDiffAmountSum,TLoseQtySum,TLoseAmountSum,TAccordQtySum,TAccordAmountSum)=0
        s billStoreLocID=0
        f  s billStoreLocID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID))  quit:((billStoreLocID=""))  d
        .//modified by ZY  20200625
        .//q:(StoreLocDR'="")&&(StoreLocDR'=billStoreLocID)
        .q:(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,billStoreLocID,"1")'="1")
        .s TLocID=billStoreLocID
        .s TLocName=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocID)
        .s (TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount)=0
        .s equipID=0
        .f  s equipID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID))  quit:((equipID=""))  d
        ..
        ..//add by zy 2013-06-04 zy0107
        ..//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
        ..Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(equipID)),"^",93)="2")
        ..s rowid=0
        ..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID,rowid))  quit:((rowid=""))  d
        ...s TTotalQty=TTotalQty+1
        ...s TTotalQtySum=TTotalQtySum+1
        ...s originalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",8)
        ...s TAmount=TAmount+originalFee
        ...s TAmountSum=TAmountSum+originalFee
        ...i TLocID=$p($g(^DHCEQInventoryList(rowid)),"^",6) d
        ....s TAccordQty=TAccordQty+1
        ....s TAccordAmount=TAccordAmount+originalFee
        ....s TAccordQtySum=TAccordQtySum+1
        ....s TAccordAmountSum=TAccordAmountSum+originalFee
        ....// MZY0048  2020-08-21  修正差异数及未盘数统计
        ...e  d
        ....s TDiffQty=TDiffQty+1
        ....s TDiffAmount=TDiffAmount+originalFee
        ....s TDiffQtySum=TDiffQtySum+1
        ....s TDiffAmountSum=TDiffAmountSum+originalFee
        ...if $p($g(^DHCEQInventoryList(rowid)),"^",14)="" d
        ....s TLoseQty=TLoseQty+1
        ....s TLoseAmount=TLoseAmount+originalFee
        ....s TLoseQtySum=TLoseQtySum+1
        ....s TLoseAmountSum=TLoseAmountSum+originalFee
        .d OutputRowResultStat
        
        s TLocID=""
        s TLocName=""
        s TLocName="合计"
        s TTotalQty=TTotalQtySum
        s TAmount=TAmountSum
        s TDiffQty=TDiffQtySum
        s TDiffAmount=TDiffAmountSum
        s TLoseQty=TLoseQtySum
        s TLoseAmount=TLoseAmountSum
        s TAccordQty=TAccordQtySum
        s TAccordAmount=TAccordAmountSum
        d OutputRowResultStat
    }
    Quit $$$OK
    
OutputRowResultStat
    s Data=$lb(TLocID,TLocName,TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod ResultStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResultStatExecute ]
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

ClassMethod ResultStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResultStatExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by mwz 20220117 mwz0057
/// 出入库变动导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetChangeStockDetail","85","10248","GetChangeStockDetail","2756")
Query GetChangeStockDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetChangeStockDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("ChangeStock",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetChangeStockDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("ChangeStock",+$H,Job,vrowid))
    .d OutputRowGetChangeStockDetail
    Quit $$$OK

OutputRowGetChangeStockDetail
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetChangeStockDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetChangeStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeStockDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetChangeStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeStockDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by mwz 20220117 mwz0057
/// 入库发票审核导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetInStockInvoiceDetail","85","10248","GetInStockInvoiceDetail","2756")
Query GetInStockInvoiceDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetInStockInvoiceDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("InStockDetailInvoice",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetInStockInvoiceDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("InStockDetailInvoice",+$H,Job,vrowid))
    .d OutputRowGetInStockInvoiceDetail
    Quit $$$OK

OutputRowGetInStockInvoiceDetail
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetInStockInvoiceDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetInStockInvoiceDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockInvoiceDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetInStockInvoiceDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockInvoiceDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by mwz 20220117 mwz0057
/// 未付款导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetUnPayRequestListDetail","85","10248","GetUnPayRequestListDetail","2756")
Query GetUnPayRequestListDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetUnPayRequestListDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("UnPayRequestList",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetUnPayRequestListDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("UnPayRequestList",+$H,Job,vrowid))
    .d OutputRowGetUnPayRequestListDetail
    Quit $$$OK

OutputRowGetUnPayRequestListDetail
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetUnPayRequestListDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetUnPayRequestListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnPayRequestListDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetUnPayRequestListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnPayRequestListDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by mwz 20220117 mwz0057
/// 配件减少/退货导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetAReduceDetail","85","10248","GetAReduceDetail","2756")
Query GetAReduceDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetAReduceDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i Job="" q $$$OK
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp("AReduceDetail",+$H,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetAReduceDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp("AReduceDetail",+$H,Job,vrowid))
    .d OutputRowGetAReduceDetail
    Quit $$$OK

OutputRowGetAReduceDetail
    s Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAReduceDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetAReduceDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAReduceDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {
        Set AtEnd=1
        Set Row=""
        }
    Else      {
        Set Row=^CacheTemp(repid,ind)
        }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAReduceDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAReduceDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// MZY0122 2578403     2022-04-24
/// 盘盈设备
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetInventoryExceptionDetail",85,12214,"InventoryException",3804)
Query GetInventoryExceptionDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetInventoryExceptionDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (CurTableName="")||(Job="") q $$$OK
    ;s ^DHCEQMozy("GetInventoryExceptionDetail")=CurGroupID _","_ CurUserID _","_ CurTableName _","_ Job
    ; ^DHCEQTemp("InventoryException",curuser,Job,gnum)
    
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetInventoryExceptionDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))
    .d OutputRowGetInventoryExceptionDetail
    Quit $$$OK

OutputRowGetInventoryExceptionDetail
    Set Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetInventoryExceptionDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetInventoryExceptionDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryExceptionDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetInventoryExceptionDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryExceptionDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// czf 2022-06-24
/// 报废明细数据导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetDisuseRequestDetail",85,1,"DisuseRequestDetail",17244)
Query GetDisuseRequestDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetDisuseRequestDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (CurTableName="")||(Job="") q $$$OK
    
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetDisuseRequestDetail
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))
    .d OutputRowGetDisuseRequestDetail
    Quit $$$OK

OutputRowGetDisuseRequestDetail
    Set Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetDisuseRequestDetail
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetDisuseRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetDisuseRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2022-8-1
/// 友谊盘点导出
/// 入参:
/// 		InventoryPlanDR	盘点计划ID
/// 		InventoryDR		盘点单ID
/// 		EquipTypeIDs	管理类组
/// 		StoreLocDR		设备所属库房
/// 			ILStatus		盘点状态(1-账物一致,2-科室不符,3-盘亏,4-待查找)
/// 			ExceptionFlag	盘盈标识
/// 			DisplayType		显示类型(0-盘点状态汇总,1-处理状态汇总,2-处理结果汇总)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetInventoryListExport","","291","3","63","","",83,3144)		; 盘点单
/// Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
Query GetInventoryListExport(InventoryPlanDR As %String = "", InventoryDR As %String = "", EquipTypeIDs As %String = "", StoreLocDR As %String = "", ILStatus As %String = "", ExceptionFlag As %String = "", DisplayType As %String = "", CurGroupID As %String = "", CurUserID As %String = "", EquipType As %String = "") As %Query(ROWSPEC = "Row:%String,No:%String,IStoreLoc:%String,Name:%String,Model:%String,Quantity:%String,OriginalFee:%String,TransAssetDate:%String,Brand:%String,ILStoreLocCode:%String,ILStoreLoc:%String,InventoryNum:%String,CheckNum:%String,Location:%String,PurposeType:%String,UseStatus:%String,Keeper:%String,Reason:%String,ILStatusDesc:%String,Remark:%String,InventoryPlanName:%String,IFreezeDate:%String") [ SqlProc ]
{
}

ClassMethod GetInventoryListExportExecute(ByRef qHandle As %Binary, InventoryPlanDR As %String = "", InventoryDR As %String = "", EquipTypeIDs As %String = "", StoreLocDR As %String = "", ILStatus As %String = "", ExceptionFlag As %String = "", DisplayType As %String = "", CurGroupID As %String = "", CurUserID As %String = "", EquipType As %String = "") As %Status
{
	new repid, index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	s Row=0
 	;s ^DHCEQMozy("web.DHCEQ.EM.RunQianExport")=InventoryPlanDR _","_ InventoryDR _","_ EquipTypeIDs _","_ StoreLocDR _","_ ILStatus _","_ ExceptionFlag _","_DisplayType_","_  CurGroupID _","_ CurUserID
 	i (InventoryPlanDR="")&&(InventoryDR="") Quit $$$OK
 	
 	i (InventoryPlanDR="")  d
    .s InventoryPlanName=""						// Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
    .s IFreezeDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",17),"CHNDate")  // Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
    .d BuildDataInventoryList
    e  d
    .s InventoryPlanName=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",2)  // Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
    .s FristFlag=0									// Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
    .s InventoryDR=0
    .f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,InventoryDR)) q:(InventoryDR="")  d
    ..s FristFlag=FristFlag+1  // Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
	..i FristFlag=1 d			// Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
	...s IFreezeDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",17),"CHNDate")  // Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
    ..d BuildDataInventoryList
    Quit $$$OK
    
BuildDataInventoryList
 	i ExceptionFlag=""
 	{
	 	s rowid=""
	 	f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid)) q:(rowid="")  d
	 	.s BillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	 	.;q:(##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(BillEquipDR)),"^",63),CurGroupID))
		.q:(StoreLocDR'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",4)'=StoreLocDR)
        .q:(DisplayType=0)&&(ILStatus'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",14)'=ILStatus)    	// Modefied by zc0132 2023-03-13 盘亏数据过滤
		.q:(DisplayType=1)&&(ILStatus'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",28)'=ILStatus)		// Modefied by zc0132 2023-03-13 盘亏数据过滤
		.q:(EquipTypeIDs'="")&&((","_EquipTypeIDs_",")'[(","_$p($g(^DHCEQEquip(BillEquipDR)),"^",63)_","))
		.
		.d ResetVariablesGetInventoryListExport
		.s No=$p($g(^DHCEQEquip(BillEquipDR)),"^",71)
		.s IStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInventory(InventoryDR)),"^",2))
		.i $p($g(^DHCEQEquip(BillEquipDR)),"^",63)'="" s IStoreLoc=$p($g(^DHCEQCCode("DHCEQCEquipType",$p($g(^DHCEQEquip(BillEquipDR)),"^",63))),"^",3)		;ET_Remark
		.s Name=$p($g(^DHCEQEquip(BillEquipDR)),"^",1)
		.s Model=##class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(BillEquipDR)),"^",3))
		.s Quantity = 1
		.s OriginalFee=$p($g(^DHCEQEquip(BillEquipDR)),"^",27)
		.s TransAssetDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(BillEquipDR)),"^",45),"date")
		.s Brand=##class(web.DHCEQCommon).GetTrakNameByID("barnd",$p($g(^DHCEQEquip(BillEquipDR)),"^",94))
		.i Brand="" s Brand=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(BillEquipDR)),"^",26))
		.s ILStoreLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",$p($g(^DHCEQInventoryList(rowid)),"^",4))
		.s ILStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInventoryList(rowid)),"^",4))
		.s InventoryNum=1	;盘点数
		.s CheckNum=1		;复核数
		.i ILStatus=3 d
		..s InventoryNum=0
		..s CheckNum=0
		.s ILIDR=$O(^DHCEQInventoryListInfo(0,"IList",rowid,0))
		.s Keeper=##class(web.DHCEQCommon).GetTrakNameByID("user",$p($g(^DHCEQInventoryListInfo(+ILIDR)),"^",2))
		.s Location=##class(web.DHCEQCommon).GetTrakNameByID("location",$p($g(^DHCEQInventoryListInfo(+ILIDR)),"^",3))
		.s PurposeType=$CASE($p($g(^DHCEQInventoryList(rowid)),"^",26),"1":"医院日常使用","2":"储备物资","":"")
		.s UseStatus=$CASE($p($g(^DHCEQInventoryList(rowid)),"^",25),"1":"在用","2":"拆封未使用","3":"未拆封","4":"积压闲置","5":"已盘亏","":"")
		.s Reason=$p($g(^DHCEQInventoryList(rowid)),"^",27)
		.i Reason'="" s Reason=$p($g(^DHCEQCCode("DHCEQCLossReason",Reason)),"^",2)
		.s ILStatusDesc=$CASE($p($g(^DHCEQInventoryList(rowid)),"^",14),"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")
		.i DisplayType=1 s ILStatusDesc=$CASE($p($g(^DHCEQInventoryList(rowid)),"^",28),"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","6":"盘盈","7":"计划外科室不符","":"")
		.s Remark=$p($g(^DHCEQInventoryList(rowid)),"^",15)
		.d OutputRowGetInventoryListExport
 	}
 	else
 	{
	 	s rowid=0
		f  s rowid=$o(^DHCEQInventoryException(0,"Inventory",InventoryDR,rowid)) quit:rowid=""  d
		.s data=$g(^DHCEQInventoryException(rowid))
		.;q:(##Class(web.DHCEQCommon).EquipTypeIsIn($p(data,"^",28),CurGroupID))
		.;s IEUseLocDR=$p(data,"^",8)
		.s IEStoreLocDR=$p(data,"^",9)
		.;q:(StoreLocDR'="")&&(IEUseLocDR'=StoreLocDR)
		.q:(StoreLocDR'="")&&(IEStoreLocDR'=StoreLocDR)
		.q:(EquipTypeIDs'="")&&((","_EquipTypeIDs_",")'[(","_$p(data,"^",28)_","))
		.
		.d ResetVariablesGetInventoryListExport
		.s IEStoreLocDR=$p(data,"^",9)
		.s No=$p(data,"^",3)
		.s InventoryDR=$p(data,"^",1)
		.s IStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInventory(InventoryDR)),"^",2))
		.i $p(data,"^",28)'="" s IStoreLoc=$p($g(^DHCEQCCode("DHCEQCEquipType",$p(data,"^",28))),"^",3)		;ET_Remark
		.s Name=$p(data,"^",2)
		.s Model=$p(data,"^",5)
		.s Quantity=1
		.s OriginalFee=$p(data,"^",4)
		.;s IEStartDate=##class(web.DHCEQCommon).TransValueToPage($p(data,"^",6),"date")
		.s TransAssetDate=##Class(web.DHCEQCommon).TransValueToPage($p(data,"^",7),"date")
		.s ILStoreLocCode=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",IEStoreLocDR)
		.s ILStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IEStoreLocDR)
		.;s IEStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IEStoreLocDR)
		.s InventoryNum=1	;盘点数
		.s CheckNum=1		;复核数
		.s IELocationDR=$p(data,"^",12)
		.s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location",IELocationDR)
		.s Remark=$p(data,"^",16)
		.s Brand=$p(data,"^",25)
		.s PurposeType=$CASE($p(data,"^",23),"1":"医院日常使用","2":"储备物资","":"")
		.s UseStatus=$CASE($p(data,"^",22),"1":"在用","2":"拆封未使用","3":"未拆封","4":"积压闲置","5":"已盘亏","":"")
		.s ILStatusDesc=$CASE($p(data,"^",31),"1":"科室不符","2":"盘盈","3":"计划外科室不符","":"")
		.i DisplayType=1 s ILStatusDesc=$CASE($p(data,"^",29),"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","6":"盘盈","7":"计划外科室不符","":"")	;IEDisposeStatus
		.s Keeper=##class(web.DHCEQCommon).GetTrakNameByID("user",$p(data,"^",26))
		.s Reason=$p(data,"^",27)
		.i Reason'="" s Reason=$p($g(^DHCEQCCode("DHCEQCProfitReason",Reason)),"^",2)
		.d OutputRowGetInventoryListExport
 	}
	Quit

OutputRowGetInventoryListExport
	Set Row=Row+1
    Set Data=$lb(Row,No,IStoreLoc,Name,Model,Quantity,OriginalFee,TransAssetDate,Brand,ILStoreLocCode,ILStoreLoc,InventoryNum,CheckNum,Location,PurposeType,UseStatus,Keeper,Reason,ILStatusDesc,Remark,InventoryPlanName,IFreezeDate)  // Modefied by zc0132 2023-03-13 增加计划名称与盘点冻结日期输出
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInventoryListExport
	s (No,IEStoreLocDR,IStoreLoc,Name,Model,Quantity,OriginalFee,TransAssetDate,Brand,ILStoreLocCode,ILStoreLoc,InventoryNum,CheckNum,Location,PurposeType,UseStatus,Keeper,Reason,ILStatusDesc,Remark)=""
	quit
}

ClassMethod GetInventoryListExportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryListExportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInventoryListExportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryListExportExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// cjc 2022-10-09
/// 科室级别树导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetDepartList",85,1,"Department",2900)
Query GetDepartList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetDepartListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (CurTableName="")||(Job="") q $$$OK
    
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))  quit:vrowid=""  d
    .d ResetVariablesGetDepartList
    .s TRowID=vrowid
    .s listinfo=$g(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))
    .d OutputRowGetDepartList
    Quit $$$OK

OutputRowGetDepartList
    Set Data=$lb(TRowID,listinfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetDepartList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetDepartListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetDepartListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisuseRequestDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// MZY0145	3076883		2022-11-30
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetContractList","85","12214","ContractList","")
Query GetContractList(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
    new repid,index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    i (Job="")||(CurTableName="")||(CurUserID="") Quit $$$OK
    s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
    s index=1
    s vrowid=0
    f  s vrowid=$o(^TempDHCEQ(CurTableName,+$H,Job,vcuruser,vrowid)) quit:vrowid=""  d
    .q:$ISVALIDNUM(vrowid)'=1
    .d ResetVariablesGetContractList    // MZY0153	3236987		2023-02-20
    .s TRowID=vrowid
    .s listinfo=$g(^TempDHCEQ(CurTableName,+$H,Job,vcuruser,vrowid))
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"（","(")
    .s listinfo=##class(web.DHCEQCommon).Replace(listinfo,"）",")")
	.d OutputRowGetContractList
	Quit $$$OK

OutputRowGetContractList
	Set Data=$lb(TRowID,listinfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
    s (TRowID,listinfo)=""
    quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
	{
        Set AtEnd=1
        Set Row=""
    }
    Else
	{
        Set Row=^CacheTemp(repid,ind)
    }
    Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// MZY0145	3081069		2022-11-30
/// 附件查询明细数据导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.RunQianExport","GetEQAffixDetail",85,1,"EQAffixDetail",17244)
Query GetEQAffixDetail(CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Query(ROWSPEC = "TRowID:%String,listinfo:%String") [ SqlProc ]
{
}

ClassMethod GetEQAffixDetailExecute(ByRef qHandle As %Binary, CurGroupID As %String = "", CurUserID As %String = "", CurTableName As %String = "", Job As %String = "") As %Status
{
	new repid, index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (CurTableName="")||(Job="") q $$$OK
 	
 	s vcuruser=##Class(web.DHCEQCommon).getMapIDBySource("user",CurUserID)
	s index=1
	s vrowid=0
	f  s vrowid=$o(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))  quit:vrowid=""  d
	.d ResetVariablesGetEQAffixDetail
	.s TRowID=vrowid
	.s listinfo=$g(^DHCEQTemp(CurTableName,vcuruser,Job,vrowid))
	.d OutputRowGetEQAffixDetail
	Quit $$$OK

OutputRowGetEQAffixDetail
	Set Data=$lb(TRowID,listinfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEQAffixDetail
	s (TRowID,listinfo)=""
	quit
}

ClassMethod GetEQAffixDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQAffixDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEQAffixDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQAffixDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}

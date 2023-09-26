Import SQLUser

Class web.DHCCRM.CRMBaseSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchFUSGroup",4)
Query SearchFUSGroup(fusrowid) As websys.Query(ROWSPEC = "RowId,GroupID,GroupDesc,Read,Write:%String")
{
}

ClassMethod SearchFUSGroupExecute(ByRef qHandle As %Binary, fusrowid) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    If (fusrowid="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s id=0
    f  s id=$o(^User.DHCCRMFUSGroupI("SGSubjectIndex",fusrowid,id))  q:id=""  d
    .s Group=$lg(^User.DHCCRMFUSGroupD(id),3)
    .q:Group=""
    .s GroupDesc=$p(^SSU("SSGRP",Group),"^",1)
    .s Read=$lg(^User.DHCCRMFUSGroupD(id),4)
    .s Write=$lg(^User.DHCCRMFUSGroupD(id),5)
    .d OutputGroupRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputGroupRow
    set Data=$lb(id,Group,GroupDesc,Read,Write)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

Query FindFeeTypeSuperGroup(hospId As %String = "") As websys.Query(ROWSPEC = "id:%String,desc:%String")
{
}

ClassMethod FindFeeTypeSuperGroupExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^SSU("SSGRP",id)) q:id=""  d
    .s desc=$p(^SSU("SSGRP",id),"^",1)
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_Group",id,hospId)
    .q:(HOSPshowFlag="N")
    .s ^CacheTemp(repid,ind)=$lb(id,desc)
    .s ind=ind+1
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchFUSubject")
Query SearchFUSubject(subjects, showFlag As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String,Limit:%String,Begin:%String,End:%String,FUPSRowId:%String,Active:%String,Level:%String,_parentId:%String,state:%String,alldesc:%String")
{
}

ClassMethod SearchFUSubjectExecute(ByRef qHandle As %Binary, subjects, showFlag As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s state=""
    i subjects="" d
    .s RowId=0
    .f  s RowId=$o(^DHCCRMFUS(RowId)) q:RowId=""  d
    ..s subData=$g(^DHCCRMFUS(RowId))
    ..s FUPSRowId=RowId
    ..d OutputRow
    e  d
    .f i=1:1:$l(subjects,"$") d
    ..s subject=$p(subjects,"$",i)
    ..s fusrowid=$p(subject,"^",1)
    ..s fuprowid=$p(subject,"^",2)
    ..s RowId=fusrowid
    ..s subData=$g(^DHCCRMFUS(RowId))
    ..s FUPSRowId=fuprowid_"^"_fusrowid
    ..d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    s ParSub=$p(subData,"^",9)  // 父层
    q:(showFlag="Parent")&&(ParSub'="")
    q:(showFlag="Child")&&(ParSub="")
    s Limit=$p(subData,"^",4)
    s Begin=$p(subData,"^",5)
    i Begin'="" s Begin=##class(websys.Conversions).DateLogicalToHtml(Begin)
    q:((subjects'="")&&(Limit="Y")&&(Begin'="")&&(Begin>+$h))
    s End=$p(subData,"^",6)
    i End'="" s End=##class(websys.Conversions).DateLogicalToHtml(End)
    q:((subjects'="")&&(Limit="Y")&&(End'="")&&(End<+$h))
    s Active=$p(subData,"^",7)
    s Code=$p(subData,"^",1)
    s Desc=$p(subData,"^",2)
    s Level=$p(subData,"^",8)
    
    set Data=$lb(RowId,Code,Desc,Limit,Begin,End,FUPSRowId,Active,Level,ParSub,state,Code_"-"_Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// w ##class(web.DHCCRM.CRMBaseSet).SearchFUSubject("","Parent")
ClassMethod SearchFUSubject(subject, showFlag)
{
    s jsonData=[]
    s RowId=0
    f  s RowId=$o(^DHCCRMFUS(RowId)) q:RowId=""  d
    .s subData=$g(^DHCCRMFUS(RowId))
    .q:((showFlag="Parent")&&(subject'="")&&(subject'=RowId))
    .s ParSub=$p(subData,"^",9)  // 父层
    .q:((showFlag="Child")&&(subject'=ParSub))
    .s Actice=$p(subData,"^",7)
    .;q:Actice'="Y"
    .s Limit=$p(subData,"^",4)
    .s Begin=$p(subData,"^",5)
    .;i Begin'="" s Begin=##class(websys.Conversions).DateLogicalToHtml(Begin)
    .q:((Limit="Y")&&(Begin'="")&&(Begin>+$h))
    .s End=$p(subData,"^",6)
    .;i End'="" s End=##class(websys.Conversions).DateLogicalToHtml(End)
    .q:((Limit="Y")&&(End'="")&&(End<+$h))
    .
    .s Code=$p(subData,"^",1)
    .s Desc=$p(subData,"^",2)
    .s Level=$p(subData,"^",8)
    .s LevelDesc=$case(Level,"1":"(一级)","2":"(二级)","3":"(三级)",:"")
    .s rowData={}
    .i (showFlag="Parent")&&(ParSub="") d
    ..s rowData.id=RowId
    ..s rowData.text=Desc
    ..s rowData.children=..SearchFUSubject(RowId,"Child")
    ..d jsonData.%Push(rowData)
    .e  i (showFlag="Child")&&(ParSub'="") d
    ..s rowData.id=RowId
    ..s rowData.text=Desc_LevelDesc
    ..d jsonData.%Push(rowData)
    
    q:showFlag="Child" jsonData
    q jsonData.%ToJSON()
}

ClassMethod KillAllCRMGlobal(KillBaseDataFlag As %Library.String = "")
{
    i KillBaseDataFlag=1  d
    .d KillBaseData //基本数据
    d KillCRMData   //业务数据
    q 0
KillBaseData
    k ^DHCCRMSetting
    q
KillCRMData
    k ^DHCCRMFUP
    k ^DHCCRMFUS
    k ^DHCCRMQR
    k ^User.DHCCRMFUSGroupD
    k ^User.DHCCRMFUSGroupI
    k ^User.DHCCRMContactReasonD
    k ^User.DHCCRMContactReasonI
    q
}

ClassMethod DeleteFUSICDHISUI(ID)
{
    
    s SQLCODE=0
    &sql(delete from sqlUser.DHC_CRM_FUSDiseases where SDIS_RowId=:ID)
   
    q SQLCODE
}

ClassMethod DeleteFUSICD(ID)
{
    
    
    &sql(delete from sqlUser.DHC_CRM_FUSDiseases where SDIS_RowId=:ID)
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""保存成功!""}"
    e  i (SQLCODE = "-120") d
    .s AlertInfo="代码不能重复"
    .w "{""success"":""false"",""info"":"""_AlertInfo_"""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
    
    w "{""success"":""true"",""info"":""保存成功!""}"
    q ""
}

ClassMethod SaveQTDisease(code, desc, id)
{
    s SQLCODE=0
    if (id="")
    {&sql(INSERT INTO DHC_CRM_QTDisease VALUES (:code,:desc))}
    else
    {&sql(update DHC_CRM_QTDisease (QTD_Code,QTD_Desc) VALUES (:code,:desc) where QTD_RowId=:id)}
    
    q SQLCODE
}

ClassMethod SaveICDRelate(icdid, icdqtdr, icddr)
{
    s SQLCODE=0
    if (icdid="")
    {&sql(INSERT INTO DHC_CRM_QTICDRelate VALUES (:icdqtdr,:icddr))}
    else
    {&sql(update DHC_CRM_QTICDRelate (QTR_QTDDR,QTR_ICDDR) VALUES (:icdqtdr,:icddr) where QTR_RowId=:icdid)}
    
    q SQLCODE
}

/// w ##class(web.DHCCRM.CRMBaseSet).SetFUSICD()
ClassMethod SetFUSICD(fusrowid, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
     
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchFUSICD") 
    d rs.Execute(fusrowid)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s ParRef=rs.Get("ParRef")
        s RowId=rs.Get("RowId")
        s Code=rs.Get("Code")
        s Desc=rs.Get("Desc")
        s ICDDR=rs.Get("ICDDR")
        
     
        i (mess'="") s mess=mess_","
        s mess=mess_"{""ICDParRef"":"_""""_ParRef_""""
        s mess=mess_","_"""ICDRowId"":"_""""_RowId_""""
        s mess=mess_","_"""ICDCode"":"_""""_Code_""""
        s mess=mess_","_"""ICDDesc"":"_""""_Desc_""""
        s mess=mess_","_"""ICDDR"":"_""""_ICDDR_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
    q mess
}

/// d ##class(web.DHCCRM.CRMBaseSet).InsertFUSubject()
ClassMethod InsertFUSubject(fuscode, fusdesc, limit, begin, end) As %String
{
    
    
    i begin'="" d
    .s begin=$zdh(begin,3)
    i end'="" d
    .s end=$zdh(end,3)
    
    i limit="true" d
    .s limit="Y"
    i limit="false" d
    .s limit="N"
    s fusdesc=$zcvt($zcvt(fusdesc,"I","URL"),"I","UTF8")
    s returncode =..existCode(fuscode)
    
    i (returncode'="0") d
    .w "{""success"":""false"",""info"":""编码: "_fuscode_"已存在！请更改！""}" 
    e  d
    .&sql(insert into sqlUser.DHC_CRM_FUSubject (FUS_Code,FUS_Desc,FUS_DateLimit,FUS_DateBegin,FUS_DateEnd) values(:fuscode,:fusdesc,:limit,:begin,:end))
    .i (SQLCODE = 0) d
    ..w "{""success"":""true"",""info"":"_%ROWID_"}"
    .e  d
    ..w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod InsertFUSDetail(sdparref, sdcode, sddesc, sdtype, sdsex, sdunit, sdexplain, sdactive, sdrequired, sdeffdate, sdenddate, sdsequence, sdparent, sdcascade, sdselectnum) As %String
{
    q:sdparref=""
    s sddesc=$zcvt($zcvt(sddesc,"I","URL"),"I","UTF8")
    s sdsex=$zcvt($zcvt(sdsex,"I","URL"),"I","UTF8")
    s sdtype=$zcvt($zcvt(sdtype,"I","URL"),"I","UTF8")
    s sdunit=$zcvt($zcvt(sdunit,"I","URL"),"I","UTF8")
    s sdexplain=$zcvt($zcvt(sdexplain,"I","URL"),"I","UTF8")
    
    
    
    i sdeffdate'="" d
    .s sdeffdate=$zdh(sdeffdate,3)
    i sdenddate'="" d
    .s sdenddate=$zdh(sdenddate,3)
    
    i sdactive="true" d
    .s sdactive="Y"
    e  d
    .s sdactive="N"
    
    i sdrequired="true" d
    .s sdrequired="Y"
    e  d
    .s sdrequired="N"
    s qflag=0
    i sdsex="" s sdsex="N"
    
    
    
    if $d(^DHCCRMFUS(0,"SD_Sequence",sdparref,sdsequence)) d
    .w "{""success"":""false"",""info"":""添加失败!"_"顺序号不能重复"_"""}" 
    .s qflag=1
    q:(qflag) ""
    s ^sxt("crm1")=sdparref_"^"_sdcode_"^"_sddesc_"^"_sdunit_"^"_sdexplain_"^"_sdactive_"^"_sdeffdate_"^"_sdenddate_"^"_sdrequired_"^"_sdcascade_"^"_sdsequence_"^"_sdtype_"^"_sdsex_"^"_sdparent_"^"_sdselectnum
    &sql(insert into sqlUser.DHC_CRM_FUSDetail (SD_ParRef,SD_Code,SD_Desc,SD_Unit,SD_Explain,SD_Active,SD_EffDate,SD_EffDateTo,SD_Required,SD_Cascade,SD_Sequence,SD_Type,SD_Sex,SD_Parent_DR,SD_SelectNum) values(:sdparref,:sdcode,:sddesc,:sdunit,:sdexplain,:sdactive,:sdeffdate,:sdenddate,:sdrequired,:sdcascade,:sdsequence,:sdtype,:sdsex,:sdparent,:sdselectnum))
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod InsertFUSDSelect(sdsparref, sdstextval, sdsunit, sdsdefault, sdssequence, sdsdesc) As %String
{
    q:sdsparref=""
    s sdstextval=$zcvt($zcvt(sdstextval,"I","URL"),"I","UTF8")
    s sdsunit=$zcvt($zcvt(sdsunit,"I","URL"),"I","UTF8")
    i sdsdefault="true" d
    .s sdsdefault="Y"
    e  d
    .s sdsdefault="N"
    
    i sdsdesc="true" d
    .s sdsdesc="Y"
    e  d
    .s sdsdesc="N"  
    &sql(insert into sqlUser.DHC_CRM_FUSDSelect (SDS_ParRef,SDS_TextVal,SDS_Unit,SDS_DefaultValue,SDS_Sequence,SDS_Desc) values(:sdsparref,:sdstextval,:sdsunit,:sdsdefault,:sdssequence,:sdsdesc))
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod InsertFUSDSTemplate(sdstparref, sdsttextval, sdstsequence) As %String
{
    q:sdstparref=""
            
    &sql(insert into sqlUser.DHC_CRM_FUSDSTemplate (SDST_ParRef,SDST_TextVal,SDST_Sequence) values(:sdstparref,:sdsttextval,:sdstsequence))
    
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod UpdateFUSubject(rowid, fuscode, fusdesc, limit, begin, end, FUSActive) As %String
{
    q:rowid=""
    
    i begin'="" d
    .s begin=$zdh(begin,3)
    i end'="" d
    .s end=$zdh(end,3)
    
    i limit="true" d
    .s limit="Y"
    i limit="false" d
    .s limit="N"
    
    i FUSActive="true" d
    .s FUSActive="Y"
    i FUSActive="false" d
    .s FUSActive="N"
    
    s fusdesc=$zcvt($zcvt(fusdesc,"I","URL"),"I","UTF8")
    
    &sql(update sqlUser.DHC_CRM_FUSubject set FUS_Code=:fuscode,FUS_Desc=:fusdesc,FUS_DateLimit=:limit,FUS_DateBegin=:begin,FUS_DateEnd=:end,FUS_Active=:FUSActive where FUS_RowId=:rowid )
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""保存成功!""}"
    e  i (SQLCODE = "-120") d
    .s AlertInfo="代码不能重复"
    .w "{""success"":""false"",""info"":"""_AlertInfo_"""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod DeleteFUSubject(rowid) As %String
{
    q:rowid=""
    

    &sql(delete from sqlUser.DHC_CRM_FUSubject where FUS_RowId=:rowid )
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""删除成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod DeleteFUSDetail(rowid) As %String
{
    q:rowid=""
    

    &sql(delete from sqlUser.DHC_CRM_FUSDetail where SD_RowId=:rowid )
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""删除成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod DeleteFUSDSelect(rowid) As %String
{
    q:rowid=""
    

    &sql(delete from sqlUser.DHC_CRM_FUSDSelect where SDS_RowId=:rowid )
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""删除成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod DeleteFUSDSelectHISUI(rowid) As %String
{
    s SQLCODE=0
    q:rowid="" SQLCODE
    
    &sql(delete from sqlUser.DHC_CRM_FUSDSelect where SDS_RowId=:rowid)
    
    q SQLCODE
}

ClassMethod UpdateFUSDetail(sdrowid, sdcode, sddesc, sdtype, sdsex, sdunit, sdexplain, sdactive, sdrequired, sdeffdate, sdenddate, sdsequence, sdparent, sdcascade, sdselectnum) As %String
{
    q:sdrowid=""
    /*
    if ($p(sdselectnum,".",2)'="")
    {
        w "{""success"":""false"",""info"":"_"列数不能为小数"_"}"
        
        }
        */
    i sdeffdate'="" d
    .s sdeffdate=$zdh(sdeffdate,3)
    i sdenddate'="" d
    .s sdenddate=$zdh(sdenddate,3)
    
    i sdactive="true" d
    .s sdactive="Y"
    e  d
    .s sdactive="N"
    
    i sdrequired="true" d
    .s sdrequired="Y"
    e  d
    .s sdrequired="N"
    
    i sdsex="" s sdsex="N"
    
    s sddesc=$zcvt($zcvt(sddesc,"I","URL"),"I","UTF8")
    s sdsex=$zcvt($zcvt(sdsex,"I","URL"),"I","UTF8")
    s sdtype=$zcvt($zcvt(sdtype,"I","URL"),"I","UTF8")
    s sdunit=$zcvt($zcvt(sdunit,"I","URL"),"I","UTF8")
    s sdexplain=$zcvt($zcvt(sdexplain,"I","URL"),"I","UTF8")
    s:(sdsex="不限") sdsex="N"
    s:(sdsex="女") sdsex="F"
    s:(sdsex="男") sdsex="M"
    s:(sdtype="文本") sdtype="T"
    s:(sdtype="数值") sdtype="N"
    s:(sdtype="单选") sdtype="S"
    s:(sdtype="多选") sdtype="D"
    s:(sdtype="多文本") sdtype="DT"
    s:(sdtype="多数值") sdtype="DN"
     s sub=$p(sdrowid,"||",2)
     s qflag=0
    if $d(^DHCCRMFUS(0,"SD_Sequence",+sdrowid,sdsequence)) d
    .if $o(^DHCCRMFUS(0,"SD_Sequence",+sdrowid,sdsequence,0))'=sub d
    ..w "{""success"":""false"",""info"":""添加失败!"_"顺序号不能重复"_"""}" 
    ..s qflag=1
    q:(qflag) ""
    &sql(update sqlUser.DHC_CRM_FUSDetail set SD_Code=:sdcode,SD_Desc=:sddesc,SD_Unit=:sdunit,SD_Explain=:sdexplain,SD_Active=:sdactive,SD_EffDate=:sdeffdate,SD_EffDateTo=:sdenddate,SD_Required=:sdrequired,SD_Cascade=:sdcascade,SD_Sequence=:sdsequence,SD_Type=:sdtype,SD_Sex=:sdsex,SD_Parent_DR=:sdparent,SD_SelectNum=:sdselectnum where SD_RowId=:sdrowid)
    s ^zl("sdtype",1)=SQLCODE
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""保存成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod UpdateFUSDSelect(sdsrowid, sdstextval, sdsunit, sdsdefault, sdssequence, sdsdesc) As %String
{
    q:sdsrowid=""
    s sdstextval=$zcvt($zcvt(sdstextval,"I","URL"),"I","UTF8")
    s sdsunit=$zcvt($zcvt(sdsunit,"I","URL"),"I","UTF8")
    i sdsdefault="true" d
    .s sdsdefault="Y"
    .s SDSParRef=$p(sdsrowid,"||",1,2)
    .s Type=$p(^DHCCRMFUS(+SDSParRef,"SD",$p(SDSParRef,"||",2)),"^",3)
    .i Type="S" &sql(update sqlUser.DHC_CRM_FUSDSelect set SDS_DefaultValue="N" where SDS_ParRef=:SDSParRef)
    e  d
    .s sdsdefault="N"
    
    i sdsdesc="true" d
    .s sdsdesc="Y"
    e  d
    .s sdsdesc="N"
    &sql(update sqlUser.DHC_CRM_FUSDSelect set 

SDS_TextVal=:sdstextval,SDS_Unit=:sdsunit,SDS_DefaultValue=:sdsdefault,SDS_Sequence=:sdssequence,SDS_Desc=:sdsdesc where 

SDS_RowId=:sdsrowid)
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""保存成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

/*
ClassMethod UpdateFUSDSelect(sdsrowid, sdstextval, sdsunit, sdsdefault, sdssequence, sdsdesc) As %String
{
    q:sdsrowid=""
    
    i sdsdefault="true" d
    .s sdsdefault="Y"
    e  d
    .s sdsdefault="N"
    
    i sdsdesc="true" d
    .s sdsdesc="Y"
    e  d
    .s sdsdesc="N"
    &sql(update sqlUser.DHC_CRM_FUSDSelect set SDS_TextVal=:sdstextval,SDS_Unit=:sdsunit,SDS_DefaultValue=:sdsdefault,SDS_Sequence=:sdssequence,SDS_Desc=:sdsdesc where SDS_RowId=:sdsrowid)
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""保存成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}
*/
ClassMethod UpdateFUSDSTemplate(sdstrowid, sdsttextval, sdstsequence) As %String
{
    q:sdstrowid=""

    &sql(update sqlUser.DHC_CRM_FUSDSTemplate set SDST_TextVal=:sdsttextval,SDST_Sequence=:sdstsequence where SDST_RowId=:sdstrowid)
    
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""保存成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod DeleteFUSDSTemplate(sdstrowid) As %String
{
    q:sdstrowid=""

    &sql(delete from sqlUser.DHC_CRM_FUSDSTemplate where SDST_RowId=:sdstrowid)
    
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""删除成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

ClassMethod existCode(Code) As %String
{
    q:Code="" "-1"
    s Code=$zcvt(Code,"U")
    q:$d(^DHCCRMFUS(0,"FUS_Code",Code)) "1"
    q "0"
}

/// w ##class(web.DHCCRM.CRMBaseSet).SetFUSubject()
ClassMethod SetFUSubject(subjects, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
    
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchFUSubject") 
    d rs.Execute(subjects)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s RowId=rs.Get("RowId")
        s Code=rs.Get("Code")
        s Desc=rs.Get("Desc")
        s Limit=rs.Get("Limit")
        i Limit="Y" s Limit="true"
        i Limit="N" s Limit="false"
        s Begin=rs.Get("Begin")
        s End=rs.Get("End")
        s FUPSRowId=rs.Get("FUPSRowId")
        s Active=rs.Get("Active")
        i Active="Y" s Active="true"
        i Active="N" s Active="false"
        i (mess'="") s mess=mess_","
        s mess=mess_"{""FUSRowId"":"_""""_RowId_""""
        s mess=mess_","_"""FUSCode"":"_""""_Code_""""
        s mess=mess_","_"""FUSDesc"":"_""""_Desc_""""
        s mess=mess_","_"""FUSDateLimit"":"_""""_Limit_""""
        s mess=mess_","_"""FUSDateBegin"":"_""""_Begin_""""
        s mess=mess_","_"""FUSDateEnd"":"_""""_End_""""
        s mess=mess_","_"""FUPSRowId"":"_""""_FUPSRowId_""""
        s mess=mess_","_"""FUSActive"":"_""""_Active_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
       
    q mess
}

/// w ##class(web.DHCCRM.CRMBaseSet).SetICDRelate()
ClassMethod SetICDRelate(qtid, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
    
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchICDRelate") 
    d rs.Execute(qtid)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s icdid=rs.Get("icdid")
        s qtid=rs.Get("qtid")
        s icddr=rs.Get("icddr")
        s icddesc=rs.Get("icddesc")
        i (mess'="") s mess=mess_","
        s mess=mess_"{""icdid"":"_""""_icdid_""""
        s mess=mess_","_"""icdqtdr"":"_""""_qtid_""""
        s mess=mess_","_"""icddr"":"_""""_icddr_""""
        s mess=mess_","_"""icddesc"":"_""""_icddesc_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
       
    q mess
}

/// w ##class(web.DHCCRM.CRMBaseSet).SetQTDisease()
ClassMethod SetQTDisease(start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
    
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchQTDisease") 
    d rs.Execute()
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s RowId=rs.Get("RowId")
        s Code=rs.Get("Code")
        s Desc=rs.Get("Desc")
        
        i (mess'="") s mess=mess_","
        s mess=mess_"{""QTRowId"":"_""""_RowId_""""
        s mess=mess_","_"""QTCode"":"_""""_Code_""""
        s mess=mess_","_"""QTDesc"":"_""""_Desc_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
       
    q mess
}

/// w ##class(web.DHCCRM.CRMBaseSet).SetFUSDetail()
ClassMethod SetFUSDetail(fusrowid, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
     
    s ^tmp("fusrowid")=fusrowid
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchFUSDetail") 
    d rs.Execute(fusrowid)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s ParRef=rs.Get("ParRef")
        s RowId=rs.Get("RowId")
        s Code=rs.Get("Code")
        s Desc=rs.Get("Desc")
        s Type=rs.Get("Type")
        s Unit=rs.Get("Unit")
        s Explain=rs.Get("Explain")
        s Sex=rs.Get("Sex")
        s Active=rs.Get("Active")
        i Active="Y" s Active="true"
        e  s Active="false"
        s EffDate=rs.Get("EffDate")
        s EffDateTo=rs.Get("EffDateTo")
        s Required=rs.Get("Required")
        i Required="Y" s Required="true"
        e  s Required="false"
        s Sequence=rs.Get("Sequence")
        s Parent=rs.Get("Parent")
        s Cascade=rs.Get("Cascade")
        s SelectNum=rs.Get("SelectNum")
     
     
        i (mess'="") s mess=mess_","
        s mess=mess_"{""SDParRef"":"_""""_ParRef_""""
        s mess=mess_","_"""SDRowId"":"_""""_RowId_""""
        s mess=mess_","_"""SDCode"":"_""""_Code_""""
        s mess=mess_","_"""SDDesc"":"_""""_Desc_""""
        s mess=mess_","_"""SDType"":"_""""_Type_""""
        s mess=mess_","_"""SDUnit"":"_""""_Unit_""""
        s mess=mess_","_"""SDExplain"":"_""""_Explain_""""
        s mess=mess_","_"""SDSex"":"_""""_Sex_""""
        s mess=mess_","_"""SDActive"":"_""""_Active_""""
        s mess=mess_","_"""SDEffDate"":"_""""_EffDate_""""
        s mess=mess_","_"""SDEffDateTo"":"_""""_EffDateTo_""""
        s mess=mess_","_"""SDRequired"":"_""""_Required_""""
        s mess=mess_","_"""SDSequence"":"_""""_Sequence_""""
        s mess=mess_","_"""SDParentDR"":"_""""_Parent_""""
        s mess=mess_","_"""SDCascade"":"_""""_Cascade_""""
        s mess=mess_","_"""SDSelectNum"":"_""""_SelectNum_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
    q mess
}

/// w ##class(web.DHCCRM.CRMBaseSet).SetFUSDSelect()
ClassMethod SetFUSDSelect(sdrowid, start, limit)
{
     
    s start=$G(start)
    s limit=$G(limit)
     
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchFUSDSelect")
    d rs.Execute(sdrowid)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s ParRef=rs.Get("ParRef")
        s RowId=rs.Get("RowId")
        s Text=rs.Get("Text")
        s Unit=rs.Get("Unit")
        s Default=rs.Get("Default")
        i Default="Y" s Default="true"
        e  s Default="false"
        s Sequence=rs.Get("Sequence")
        s Desc=rs.Get("Desc")
        i Desc="Y" s Desc="true"
        e  s Desc="false"
        i (mess'="") s mess=mess_","
        s mess=mess_"{""SDSParRef"":"_""""_ParRef_""""
        s mess=mess_","_"""SDSRowId"":"_""""_RowId_""""
        s mess=mess_","_"""SDSTextVal"":"_""""_Text_""""
        s mess=mess_","_"""SDSUnit"":"_""""_Unit_""""
        s mess=mess_","_"""SDSDefaultValue"":"_""""_Default_""""
        s mess=mess_","_"""SDSSequence"":"_""""_Sequence_""""
        s mess=mess_","_"""SDSDesc"":"_""""_Desc_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
    q mess
}

ClassMethod SetFUSDSTemplate(sdsrowid, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
     
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchFUSDSTemplate")
    d rs.Execute(sdsrowid)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s ParRef=rs.Get("ParRef")
        s RowId=rs.Get("RowId")
        s Text=rs.Get("Text")
        s Sequence=rs.Get("Sequence")
     
        i (mess'="") s mess=mess_","
        s mess=mess_"{""SDSTParRef"":"_""""_ParRef_""""
        s mess=mess_","_"""SDSTRowId"":"_""""_RowId_""""
        s mess=mess_","_"""SDSTTextVal"":"_""""_Text_""""
        s mess=mess_","_"""SDSTSequence"":"_""""_Sequence_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
    q mess
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchFUSubject")
Query SearchFUSubjectOld(subjects) As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String,Diseases:%String,Limit:%String,Begin:%String,End:%String,FUPSRowId:%String,Active:%String")
{
}

ClassMethod SearchFUSubjectOldExecute(ByRef qHandle As %Binary, subjects) As %Status
{
   
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    i subjects="" d
    .s RowId=0
    .f  s RowId=$o(^DHCCRMFUS(RowId)) q:RowId=""  d
    ..s Code=$p(^DHCCRMFUS(RowId),"^",1)
    ..s Desc=$p(^DHCCRMFUS(RowId),"^",2)
    ..s Diseases=""
    ..s Limit=$p(^DHCCRMFUS(RowId),"^",4)
    ..s Begin=$p(^DHCCRMFUS(RowId),"^",5)
    ..i Begin'="" s Begin=##class(websys.Conversions).DateLogicalToHtml(Begin)
    ..s End=$p(^DHCCRMFUS(RowId),"^",6)
    ..i End'="" s End=##class(websys.Conversions).DateLogicalToHtml(End)
    ..s Active=$p(^DHCCRMFUS(RowId),"^",7)
    ..;q:(Limit="Y")&&(Begin'="")&&(Begin>+$h)
    ..;q:(Limit="Y")&&(End'="")&&(End<+$h)
    ..s FUPSRowId=RowId
    ..d OutputRow
    e  d
    .f i=1:1:$l(subjects,"$") d
    ..s subject=$p(subjects,"$",i)
    ..s fusrowid=$p(subject,"^",1)
    ..s fuprowid=$p(subject,"^",2)
    ..s RowId=fusrowid
    ..s Code=$p(^DHCCRMFUS(RowId),"^",1)
    ..s Desc=$p(^DHCCRMFUS(RowId),"^",2)
    ..s Diseases=""
    ..s Limit=$p(^DHCCRMFUS(RowId),"^",4)
    ..s Begin=$p(^DHCCRMFUS(RowId),"^",5)
    ..i Begin'="" s Begin=##class(websys.Conversions).DateLogicalToHtml(Begin)
    ..s End=$p(^DHCCRMFUS(RowId),"^",6)
    ..i End'="" s End=##class(websys.Conversions).DateLogicalToHtml(End)
    ..s Active=$p(^DHCCRMFUS(RowId),"^",7)
    ..q:(Limit="Y")&&(Begin'="")&&(Begin>+$h)
    ..q:(Limit="Y")&&(End'="")&&(End<+$h)
    ..s FUPSRowId=fuprowid_"^"_fusrowid
    ..d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(RowId,Code,Desc,Diseases,Limit,Begin,End,FUPSRowId,Active)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUSubjectOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUSubjectOldExecute ]
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

ClassMethod SearchFUSubjectOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUSubjectOldExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchFUSDetail")
Query SearchFUSDetail(fusrowid) As %Query(ROWSPEC = "ParRef:%String,RowId:%String,Sub:%String,Code:%String,Desc:%String,Type:%String,Unit:%String,Explain:%String,Sex:%String,Active:%String,EffDate:%String,EffDateTo:%String,Required:%String,Sequence:%String,Parent:%String,Cascade:%String,SelectNum:%String")
{
}

ClassMethod SearchFUSDetailExecute(ByRef qHandle As %Binary, fusrowid) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    If (fusrowid="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s SDSequence=""
    f  s SDSequence=$o(^DHCCRMFUS(0,"SD_Sequence",fusrowid,SDSequence)) q:SDSequence=""  d
    .s SDSub=0
    .f  s SDSub=$o(^DHCCRMFUS(0,"SD_Sequence",fusrowid,SDSequence,SDSub)) q:SDSub=""  d
    ..s RowId=fusrowid_"||"_SDSub
    ..s Code=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",1)
    ..s Desc=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",2)
    ..s Type=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",3)
    ..s Unit=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",4)
    ..s Explain=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",5)
    ..s Sex=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",6)
    ..s Active=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",7)
    ..s EffDate=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",8)
    ..i EffDate'="" s EffDate=##class(websys.Conversions).DateLogicalToHtml(EffDate)
    ..s EffDateTo=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",9)
    ..i EffDateTo'="" s EffDateTo=##class(websys.Conversions).DateLogicalToHtml(EffDateTo)
    ..s Required=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",10)
    ..s Sequence=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",11)
    ..s ParentDr=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",12)
    ..s Cascade=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",13)
    ..s SelectNum=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",14)
    ..s:(Sex="N") Sex="不限"
    ..s:(Sex="F") Sex="女"
    ..s:(Sex="M") Sex="男"
    ..s:(Type="T") Type="文本"
    ..s:(Type="N") Type="数值"
    ..s:(Type="S") Type="单选"
    ..s:(Type="D") Type="多选"
    ..s:(Type="DT") Type="多文本"
    ..s:(Type="DN") Type="多数值"
    ..s:(Type="DA") Type="日期" 
    ..d OutputSDRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputSDRow
    set Data=$lb(fusrowid,RowId,SDSub,Code,Desc,Type,Unit,Explain,Sex,Active,EffDate,EffDateTo,Required,Sequence,ParentDr,Cascade,SelectNum)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUSDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUSDetailExecute ]
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

ClassMethod SearchFUSDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUSDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchFUSDSelect(fusdrowid) As %Query(ROWSPEC = "ParRef:%String,RowId:%String,Text:%String,Unit:%String,Default:%String,Sequence:%String,Desc:%String")
{
}

ClassMethod SearchFUSDSelectExecute(ByRef qHandle As %Binary, fusdrowid) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    If (fusdrowid="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s SDSSub=0
    f  s SDSSub=$o(^DHCCRMFUS(+fusdrowid,"SD",$p(fusdrowid,"||",2),"SDS",SDSSub)) q:SDSSub=""  d
    .s RowId=fusdrowid_"||"_SDSSub
    .s Text=$p(^DHCCRMFUS(+fusdrowid,"SD",$p(fusdrowid,"||",2),"SDS",SDSSub),"^",1)
    .s Unit=$p(^DHCCRMFUS(+fusdrowid,"SD",$p(fusdrowid,"||",2),"SDS",SDSSub),"^",2)
    .s Default=$p(^DHCCRMFUS(+fusdrowid,"SD",$p(fusdrowid,"||",2),"SDS",SDSSub),"^",3)
    .s Sequence=$p(^DHCCRMFUS(+fusdrowid,"SD",$p(fusdrowid,"||",2),"SDS",SDSSub),"^",4)
    .s Desc=$p(^DHCCRMFUS(+fusdrowid,"SD",$p(fusdrowid,"||",2),"SDS",SDSSub),"^",5)
    .d OutputSDSRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputSDSRow
    set Data=$lb(fusdrowid,RowId,Text,Unit,Default,Sequence,Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUSDSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUSDSelectExecute ]
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

ClassMethod SearchFUSDSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUSDSelectExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query SearchFUSDSTemplate(sdsrowid) As %Query(ROWSPEC = "ParRef:%String,RowId:%String,Text:%String,Sequence:%String")
{
}

ClassMethod SearchFUSDSTemplateExecute(ByRef qHandle As %Binary, sdsrowid) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    If (sdsrowid="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s SDSTSub=0
    s sdsub=$p(sdsrowid,"||",2)
    s sdssub=$p(sdsrowid,"||",3)
    f  s SDSTSub=$o(^DHCCRMFUS(+sdsrowid,"SD",sdsub,"SDS",sdssub,"SDST",SDSTSub)) q:SDSTSub=""  d
    .s RowId=sdsrowid_"||"_SDSTSub
    .s Text=$p(^DHCCRMFUS(+sdsrowid,"SD",sdsub,"SDS",sdssub,"SDST",SDSTSub),"^",1)
    .s Sequence=$p(^DHCCRMFUS(+sdsrowid,"SD",sdsub,"SDS",sdssub,"SDST",SDSTSub),"^",2)
    .d OutputSDSTRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputSDSTRow
    set Data=$lb(sdsrowid,RowId,Text,Sequence)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUSDSTemplateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUSDSTemplateExecute ]
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

ClassMethod SearchFUSDSTemplateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUSDSTemplateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchFUSICD",4)
Query SearchFUSICD(fusrowid) As %Query(ROWSPEC = "ParRef:%String,RowId:%String,Sub:%String,Code:%String,Desc:%String,ICDDR:%String")
{
}

ClassMethod SearchFUSICDExecute(ByRef qHandle As %Binary, fusrowid) As %Status
{
    
    //DHCCRMFUSDiseases
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    If (fusrowid="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s ICDSub=0
    f  s ICDSub=$o(^DHCCRMFUS(fusrowid,"SDIS",ICDSub)) q:ICDSub=""  d
    .s RowId=fusrowid_"||"_ICDSub
    .s Code=$p(^DHCCRMFUS(fusrowid,"SDIS",ICDSub),"^",1)
    .s Desc=$p(^DHCCRMFUS(fusrowid,"SDIS",ICDSub),"^",2)
    .s ICDDR=$p(^DHCCRMFUS(fusrowid,"SDIS",ICDSub),"^",3)
    .d OutputICDRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputICDRow
    set Data=$lb(fusrowid,RowId,ICDSub,Code,Desc,ICDDR)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUSICDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUSICDExecute ]
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

ClassMethod SearchFUSICDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUSICDExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchQTDisease")
Query SearchQTDisease() As %Query(ROWSPEC = "RowId:%String,Code:%String,Desc:%String")
{
}

ClassMethod SearchQTDiseaseExecute(ByRef qHandle As %Binary) As %Status
{
   
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s RowId=0
    f  s RowId=$o(^User.DHCCRMQTDiseaseD(RowId)) q:RowId=""  d
    .s Code=$lg(^User.DHCCRMQTDiseaseD(RowId),2)
    .s Desc=$lg(^User.DHCCRMQTDiseaseD(RowId),3)
    .d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(RowId,Code,Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchQTDiseaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchQTDiseaseExecute ]
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

ClassMethod SearchQTDiseaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchQTDiseaseExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchICDRelate",1)
Query SearchICDRelate(qtid) As %Query(ROWSPEC = "icdid:%String,qtid:%String,icddr:%String,icddesc:%String")
{
}

ClassMethod SearchICDRelateExecute(ByRef qHandle As %Binary, qtid) As %Status
{
   
   
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s icdid=0
    f  s icdid=$o(^User.DHCCRMQTICDRelateI("QTRQTDDRIndex",qtid,icdid)) q:icdid=""  d
    .s icddr=$lg(^User.DHCCRMQTICDRelateD(icdid),3)
    .s icddesc=$p(^MRC("ID",icddr),"^",2)
    .d OutputRow
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(icdid,qtid,icddr,icddesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchICDRelateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchICDRelateExecute ]
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

ClassMethod SearchICDRelateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchICDRelateExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetFUSLoc(fusrowid, start, limit)
{
    s start=$G(start)
    s limit=$G(limit)
     
    s rs=##class(%ResultSet).%New("web.DHCCRM.CRMBaseSet:SearchFUSLoc") 
    d rs.Execute(fusrowid)
 
    s count=0
    s mess=""
    s topnum=start+limit
    
    while (rs.Next())
    {
        s count=count+1
        i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
        
        s ParRef=rs.Get("ParRef")
        s RowId=rs.Get("RowId")
        //s LocSub=$p(RowId,"||",2)
        s LocSub=rs.Get("LocSub")
        s Code=rs.Get("Code")
        s Loc=rs.Get("Loc")
     
        i (mess'="") s mess=mess_","
        s mess=mess_"{""LocParRef"":"_""""_ParRef_""""
        s mess=mess_","_"""LocRowId"":"_""""_RowId_""""
        s mess=mess_","_"""LocSub"":"_""""_LocSub_""""
        s mess=mess_","_"""LocCode"":"_""""_Code_""""
        s mess=mess_","_"""Loc"":"_""""_Loc_""""
        s mess=mess_"}"
    }        
    s mess="["_mess_"]"
    s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
    q mess
}

/// d ##class(%ResultSet).RunQuery("web.DHCCRM.CRMBaseSet","SearchFUSICD",4)
Query SearchFUSLoc(fusrowid) As %Query(ROWSPEC = "ParRef:%String,RowId:%String,LocSub:%Integer,Code:%String,LocDR:%String,Loc:%String")
{
}

ClassMethod SearchFUSLocExecute(ByRef qHandle As %Binary, fusrowid) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    If (fusrowid="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s LocSub=0
    f  s LocSub=$o(^DHCCRMFUS(fusrowid,"SL",LocSub)) q:LocSub=""  d
    .s RowId=fusrowid_"||"_LocSub
    .s Code=$p(^DHCCRMFUS(fusrowid,"SL",LocSub),"^",1)
    .s Desc=$p(^DHCCRMFUS(fusrowid,"SL",LocSub),"^",2)
    .s LocDR=$p(^DHCCRMFUS(fusrowid,"SL",LocSub),"^",3)
    .s Loc=$p(^CTLOC(LocDR),"^",2)
    .d OutputLocRow

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputLocRow
    set Data=$lb(fusrowid,RowId,LocSub,Code,LocDR,Loc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchFUSLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchFUSLocExecute ]
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

ClassMethod SearchFUSLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchFUSLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DeleteFUSLocHISUI(rowid) As %String
{
    s SQLCODE=0
    q:rowid="" SQLCODE
    

    &sql(delete from sqlUser.DHC_CRM_FUSLoc where SL_RowId=:rowid )
    q SQLCODE
}

ClassMethod DeleteFUSLoc(rowid) As %String
{
    q:rowid=""
    

    &sql(delete from sqlUser.DHC_CRM_FUSLoc where SL_RowId=:rowid )
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":""删除成功!""}"
    e  d
    .w "{""success"":""false"",""info"":"_SQLCODE_"}"
    q ""
}

/// w ##class(web.DHCCRM.CRMBaseSet).SaveLoc("","20^^^^")
ClassMethod SaveLoc(id, Instring)
{
    s SQLCODE=0
    s SLPar=$p(Instring,"^",1)
    s LocDR = $p(Instring,"^",3)
    s LocCode=$p($g(^CTLOC(LocDR)),"^",1)
    s LocDesc = $p($g(^CTLOC(LocDR)),"^",2)
    
    if (id="")
    {
        &sql(insert into DHC_CRM_FUSLoc (SL_ParRef,SL_Code,SL_Desc,SL_Loc_Dr)  values (:SLPar,:LocCode,:LocDesc,:LocDR))
        
    }
    else
    {
        &sql(update DHC_CRM_FUSLoc set SL_Code=:LocCode,SL_Desc=:LocDesc,SL_Loc_Dr=:LocDR where SL_RowId=:id)
        
    }
    q SQLCODE
}

ClassMethod InsertFUSLoc(LocParRef, LocCTDR) As %String
{
    q:LocParRef=""
    s LocCode=$p(^CTLOC(LocCTDR),"^",1)
    s LocDesc=$p(^CTLOC(LocCTDR),"^",2)
            
    &sql(insert into DHC_CRM_FUSLoc (SL_ParRef,SL_Code,SL_Desc,SL_Loc_Dr)  values (:LocParRef,:LocCode,:LocDesc,:LocCTDR))
    
    
    i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""添加失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod SaveFUSDetail(Instring)
{
    
    s SQLCODE=0
    
    s sdparref=$p(Instring,"^",1)
    s sdid=$p(Instring,"^",2)
    s sdcode=$p(Instring,"^",3)
    s sddesc=$p(Instring,"^",4)
    s sdsex=$p(Instring,"^",6)
    i sdsex="" s sdsex="N"
    s sdtype=$p(Instring,"^",5)
    s sdunit=$p(Instring,"^",7)
    s sdexplain=$p(Instring,"^",8)
    
    s sdeffdate=$p(Instring,"^",11)
    s sdenddate=$p(Instring,"^",12)
    i sdeffdate'="" d
    .s sdeffdate=##class(websys.Conversions).DateHtmlToLogical(sdeffdate)
    i sdenddate'="" d
    .s sdenddate=##class(websys.Conversions).DateHtmlToLogical(sdenddate)
    
    s sdactive=$p(Instring,"^",9)
    s sdrequired=$p(Instring,"^",10)
    
    
    s sdsequence=$p(Instring,"^",13)
    s sdparent=$p(Instring,"^",14)
    s sdcascade=$p(Instring,"^",15)
    s sdselectnum=$p(Instring,"^",16)
    
    i sdid="" d
    .&sql(insert into sqlUser.DHC_CRM_FUSDetail (SD_ParRef,SD_Code,SD_Desc,SD_Unit,SD_Explain,SD_Active,SD_EffDate,SD_EffDateTo,SD_Required,SD_Cascade,SD_Sequence,SD_Type,SD_Sex,SD_Parent_DR,SD_SelectNum) values(:sdparref,:sdcode,:sddesc,:sdunit,:sdexplain,:sdactive,:sdeffdate,:sdenddate,:sdrequired,:sdcascade,:sdsequence,:sdtype,:sdsex,:sdparent,:sdselectnum))
    e  d
    .&sql(update sqlUser.DHC_CRM_FUSDetail set SD_Code=:sdcode,SD_Desc=:sddesc,SD_Unit=:sdunit,SD_Explain=:sdexplain,SD_Active=:sdactive,SD_EffDate=:sdeffdate,SD_EffDateTo=:sdenddate,SD_Required=:sdrequired,SD_Cascade=:sdcascade,SD_Sequence=:sdsequence,SD_Type=:sdtype,SD_Sex=:sdsex,SD_Parent_DR=:sdparent,SD_SelectNum=:sdselectnum where SD_RowId=:sdid)
    q SQLCODE
}

ClassMethod SaveFUSubjectBak(Instring)
{
    s SQLCODE=0
    s id=$p(Instring,"^",1)
    s Code=$p(Instring,"^",2)
    s Desc=$p(Instring,"^",3)
    s Active=$p(Instring,"^",4)
    s Limit=$p(Instring,"^",5)
    s Begin=$p(Instring,"^",6)
    s End=$p(Instring,"^",7)
    
    i Begin'="" d
    .i Begin'="" s Begin=##class(websys.Conversions).DateHtmlToLogical(Begin)
    i End'="" d
    .i End'="" s End=##class(websys.Conversions).DateHtmlToLogical(End)
    
    
    i id=""  d
    .&sql(insert into sqlUser.DHC_CRM_FUSubject (FUS_Code,FUS_Desc,FUS_DateLimit,FUS_DateBegin,FUS_DateEnd,FUS_Active) values(:Code,:Desc,:Limit,:Begin,:End,:Active))
    e  d
    .&sql(update sqlUser.DHC_CRM_FUSubject set FUS_Code=:Code,FUS_Desc=:Desc,FUS_DateLimit=:Limit,FUS_DateBegin=:Begin,FUS_DateEnd=:End,FUS_Active=:Active where FUS_RowId=:id )
    q SQLCODE
}

/// w ##class(web.DHCCRM.CRMBaseSet).SaveFUSubject("2^01^父主题^Y^N^2021-08-09^^^2")
ClassMethod SaveFUSubject(Instring)
{
    s SQLCODE=0
    s id=$p(Instring,"^",1)
    s Code=$p(Instring,"^",2)
    s Desc=$p(Instring,"^",3)
    s Active=$p(Instring,"^",4)
    s Limit=$p(Instring,"^",5)
    s Begin=$p(Instring,"^",6)
    s End=$p(Instring,"^",7)
    s Level=$p(Instring,"^",8)  // 随访级别
    s Subject=$p(Instring,"^",9)   // 链接主问卷
    q:(Subject'="")&&(id=Subject) "父主题不能是主题自身"
    s Flag=0
    if Subject'="" d
    .s RowId=0
    .f  s RowId=$o(^DHCCRMFUS(RowId)) q:RowId=""  d
    ..s subData=$g(^DHCCRMFUS(RowId))
    ..s Parent=$p(subData,"^",9)
    ..q:Parent'=Subject
    ..s OldLevel=$p(subData,"^",8)
    ..q:OldLevel'=Level
    ..q:(id'="")&&(id=RowId)
    ..s Flag=1
    q:Flag=1 "同一父主题下只能有1个同一级别主题"
    i Begin'="" d
    .i Begin'="" s Begin=##class(websys.Conversions).DateHtmlToLogical(Begin)
    i End'="" d
    .i End'="" s End=##class(websys.Conversions).DateHtmlToLogical(End)
    
    i id=""  d
    .&sql(insert into sqlUser.DHC_CRM_FUSubject (FUS_Code,FUS_Desc,FUS_DateLimit,FUS_DateBegin,FUS_DateEnd,FUS_Active,FUS_Level,FUS_LinkSubject_DR) values(:Code,:Desc,:Limit,:Begin,:End,:Active,:Level,:Subject))
    e  d
    .&sql(update sqlUser.DHC_CRM_FUSubject set FUS_Code=:Code,FUS_Desc=:Desc,FUS_DateLimit=:Limit,FUS_DateBegin=:Begin,FUS_DateEnd=:End,FUS_Active=:Active,FUS_Level=:Level,FUS_LinkSubject_DR=:Subject where FUS_RowId=:id)
    q SQLCODE
}

ClassMethod GetFUSById(RowId)
{
    
    s Code=$p(^DHCCRMFUS(RowId),"^",1)
    s Desc=$p(^DHCCRMFUS(RowId),"^",2)
    s Limit=$p(^DHCCRMFUS(RowId),"^",4)
    s Begin=$p(^DHCCRMFUS(RowId),"^",5)
    i Begin'="" s Begin=##class(websys.Conversions).DateLogicalToHtml(Begin)
    s End=$p(^DHCCRMFUS(RowId),"^",6)
    i End'="" s End=##class(websys.Conversions).DateLogicalToHtml(End)
    s Active=$p(^DHCCRMFUS(RowId),"^",7)
    s Level=$p(^DHCCRMFUS(RowId),"^",8)
    s Parent=$p(^DHCCRMFUS(RowId),"^",9)
    q Code_"^"_Desc_"^"_Limit_"^"_Begin_"^"_End_"^"_Active_"^"_Level_"^"_Parent
}

ClassMethod GetFUSDById(RowId)
{
    s fusrowid=+RowId
    s SDSub=$p(RowId,"||",2)
    s Code=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",1)
    s Desc=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",2)
    s Type=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",3)
    s Unit=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",4)
    s Explain=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",5)
    s Sex=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",6)
    s Active=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",7)
    s EffDate=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",8)
    i EffDate'="" s EffDate=##class(websys.Conversions).DateLogicalToHtml(EffDate)
    s EffDateTo=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",9)
    i EffDateTo'="" s EffDateTo=##class(websys.Conversions).DateLogicalToHtml(EffDateTo)
    s Required=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",10)
    s Sequence=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",11)
    s ParentDr=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",12)
    s Cascade=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",13)
    s SelectNum=$p(^DHCCRMFUS(fusrowid,"SD",SDSub),"^",14)
    q Code_"^"_Desc_"^"_Type_"^"_Unit_"^"_Explain_"^"_Sex_"^"_Active_"^"_EffDate_"^"_EffDateTo_"^"_Required_"^"_Sequence_"^"_ParentDr_"^"_Cascade_"^"_SelectNum
}

ClassMethod SaveFUSDSelect(Instring)
{
    
    s SQLCODE=0
    
    s sdsparref=$p(Instring,"^",1)
    s sdsid=$p(Instring,"^",2)
    s sdstextval=$p(Instring,"^",3)
    s sdsunit=$p(Instring,"^",4)
    s sdsdefault=$p(Instring,"^",5)
    
    s sdsdesc=$p(Instring,"^",6)
    
    s sdssequence=$p(Instring,"^",7)
    
    s LinkDetail=$p(Instring,"^",8)
    s ExclusiveDetail=$p(Instring,"^",9)
    
    i sdsid="" d
    .&sql(insert into sqlUser.DHC_CRM_FUSDSelect (SDS_ParRef,SDS_TextVal,SDS_Unit,SDS_DefaultValue,SDS_Sequence,SDS_Desc,SDS_LinkDetail,SDS_ExclusiveDetail) values(:sdsparref,:sdstextval,:sdsunit,:sdsdefault,:sdssequence,:sdsdesc,:LinkDetail,:ExclusiveDetail))
    e  d
    .&sql(update sqlUser.DHC_CRM_FUSDSelect set SDS_TextVal=:sdstextval,SDS_Unit=:sdsunit,SDS_DefaultValue=:sdsdefault,SDS_Sequence=:sdssequence,SDS_Desc=:sdsdesc,SDS_LinkDetail=:LinkDetail,SDS_ExclusiveDetail=:ExclusiveDetail where SDS_RowId=:sdsid)
    q SQLCODE
}

ClassMethod GetFUSDSById(RowId)
{
    
    s fusrowid=+RowId
    s SDSub=$p(RowId,"||",2)
    s SDSSub=$p(RowId,"||",3)
    s Text=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",1)
    s Unit=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",2)
    s Default=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",3)
    s Sequence=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",4)
    s Desc=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",5)
    s LinkDetail=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",6)
    s ExclusiveDetail=$p(^DHCCRMFUS(fusrowid,"SD",SDSub,"SDS",SDSSub),"^",7)

    q Text_"^"_Unit_"^"_Default_"^"_Sequence_"^"_Desc_"^"_LinkDetail_"^"_ExclusiveDetail
}

Query FindContractReason1() As websys.Query(ROWSPEC = "id:%String,Code:%String,Reason:%String,Type:%String,Seq:%String,Active:%String,TypeDesc:%String")
{
}

ClassMethod FindContractReason1Execute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^User.DHCCRMContactReasonD(id)) q:id=""  d
    .s Code=$lg(^User.DHCCRMContactReasonD(id),2)
    .s Reason=$lg(^User.DHCCRMContactReasonD(id),3)
    .s Type=$lg(^User.DHCCRMContactReasonD(id),4)
    .s TypeDesc="暂时联系不上"
    .i Type="L" s TypeDesc="联系不上"
    .s Seq=$lg(^User.DHCCRMContactReasonD(id),5)
    .s Active=$lg(^User.DHCCRMContactReasonD(id),6)
    .q:Active="N"
    .s ^CacheTemp(repid,ind)=$lb(id,Code,Reason,Type,Seq,Active,TypeDesc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

Query FindContractReason() As websys.Query(ROWSPEC = "id:%String,Code:%String,Reason:%String,Type:%String,Seq:%String,Active:%String,TypeDesc:%String")
{
}

ClassMethod FindContractReasonExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    
    s id=0
    f  s id=$O(^User.DHCCRMContactReasonD(id)) q:id=""  d
    .s Code=$lg(^User.DHCCRMContactReasonD(id),2)
    .s Reason=$lg(^User.DHCCRMContactReasonD(id),3)
    .s Type=$lg(^User.DHCCRMContactReasonD(id),4)
    .s TypeDesc="暂时联系不上"
    .i Type="L" s TypeDesc="联系不上"
    .s Seq=$lg(^User.DHCCRMContactReasonD(id),5)
    .s Active=$lg(^User.DHCCRMContactReasonD(id),6)
    .s ^CacheTemp(repid,ind)=$lb(id,Code,Reason,Type,Seq,Active,TypeDesc)
    .s ind=ind+1
    
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

ClassMethod UpdateLinkReason(ID, Code, Reason, Type, Seq, Active)
{
    if (ID=""){
        
        &SQL(insert into SQLUser.DHC_CRM_ContactReason (CR_Code,CR_Desc,CR_Type,CR_Sequence,CR_Active) values (:Code,:Reason,:Type,:Seq,:Active))    
    }else{
       
        &SQL(Update SQLUser.DHC_CRM_ContactReason (CR_Code,CR_Desc,CR_Type,CR_Sequence,CR_Active) values  (:Code,:Reason,:Type,:Seq,:Active) where CR_RowId=:ID)
        
    }
    q SQLCODE
}

ClassMethod UpdateFUSGroup(ID, FUS, Group, Read, Write)
{
    if (ID=""){
        
        &SQL(insert into SQLUser.DHC_CRM_FUSGroup (SG_Subject_Dr,SG_Group_Dr,SG_Read,SG_Write) values (:FUS,:Group,:Read,:Write))    
    }else{
       
        &SQL(Update SQLUser.DHC_CRM_FUSGroup (SG_Subject_Dr,SG_Group_Dr,SG_Read,SG_Write) values  (:FUS,:Group,:Read,:Write) where SG_RowId=:ID)
        
    }
    q SQLCODE
}

/// 通过id返回联系不上原因的类型
ClassMethod GetRealLinkFlag(id)
{
    q:id="" ""
    q $lg(^User.DHCCRMContactReasonD(id),4)
}

}

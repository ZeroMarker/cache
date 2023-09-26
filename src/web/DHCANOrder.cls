Class web.DHCANOrder Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetByOpaAndDateTime(opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Query(ROWSPEC = "anoId,ancoId,oeoriId,userId,anoStartDate,anoStartTime,anoEndDate,anoEndTime,arcimId,anoNote,anoQty,ctuomId,anoDensity,anacomId,phcinId,ancvcId,anoFlag,anoDrugMode,anoSpeed,anoUpdateDate,anoUpdateTime,anoReason,anoEditFlag,anoAnoId,anoRecLocId,anoDocUserId,anoVolume,anosuId,anoSource,anoType,ancoDesc,arcimDesc,anoQty2,anoQty3,anoSubANOrder,anoMainANODr")
{
}

ClassMethod GetByOpaAndDateTimeExecute(ByRef qHandle As %Binary, opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Status
{
    //取开始时间点数据，不取结束时间点数据
    //D ##class(%ResultSet).RunQuery("web.DHCANOrder","GetByOpaAndDateTime",44,62169,36000,62169,43200)
    //s ^tmpYpz("queryTime")=$p($h,",",2)
    Set repid=$I(^CacheTemp)

    If $g(ind)="" Set ind=1
    k ^TMPAN("Order",$j)
    k ^TMPAN("OrderRet",$j)
    
    i opaId="" s qHandle=$lb(0,repid,0) Quit $$$OK

    s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
    s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
    i startDate>endDate s qHandle=$lb(0,repid,0) Quit $$$OK

    s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
    s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
    i (startDate=endDate)&(startTime>endTime) s qHandle=$lb(0,repid,0) Quit $$$OK
    i endDate>$h s endDate=$h+1
    
    f uDate=startDate:1:endDate d
        .i uDate=startDate s uTime=startTime-1
        .e  s uTime=-1
        .i uDate=endDate s eTime=endTime
        .e  s eTime=86400
        .f  s uTime=$o(^DHCANOrder(0,"UpdateDateTime",opaId,uDate,uTime)) q:(uTime="")!(uTime'<eTime)  d
            ..s anoId=""
            ..f  s anoId=$o(^DHCANOrder(0,"UpdateDateTime",opaId,uDate,uTime,anoId)) q:(anoId="")  d
                ...q:'$d(^DHCANOrder(anoId))
                ...s arcimId=$p(^DHCANOrder(anoId),"^",9)  //query.GetDataByName("ANO_ARCIM_Dr")
                ...s ancoId=$p(^DHCANOrder(anoId),"^",2)  //query.GetDataByName("ANO_ANCORD_Dr")  
                ...q:(+ancoId=0)&(arcimId="")
                ...s tmpStr=ancoId_"^"
                ...s oeoriId=$p(^DHCANOrder(anoId),"^",3)  
                ...s tmpStr=tmpStr_oeoriId_"^" //query.GetDataByName("ANO_OEORI_Dr")_"^"
                ...s userId=$p(^DHCANOrder(anoId),"^",4)
                ...s tmpStr=tmpStr_userId_"^" //query.GetDataByName("ANO_User_Dr")_"^"
                ...s anoStartDate=$ZD($p(^DHCANOrder(anoId),"^",5),3)
                ...s tmpStr=tmpStr_anoStartDate_"^" //$ZD(query.GetDataByName("ANO_StartDate"),3)_"^"
                ...s anoStartTime=$ZT($p(^DHCANOrder(anoId),"^",6))
                ...s tmpStr=tmpStr_anoStartTime_"^" //$ZT(query.GetDataByName("ANO_StartTime"))_"^"
                ...s anoEndDate=$ZD($p(^DHCANOrder(anoId),"^",7),3)
                ...s tmpStr=tmpStr_anoEndDate_"^" //$ZD(query.GetDataByName("ANO_EndDate"),3)_"^"
                ...s anoEndTime=$ZT($p(^DHCANOrder(anoId),"^",8))
                ...s tmpStr=tmpStr_anoEndTime_"^" //$ZT(query.GetDataByName("ANO_EndTime"))_"^"
                ...s tmpStr=tmpStr_arcimId_"^"
                ...s anoNote=$p(^DHCANOrder(anoId),"^",10)
                ...s tmpStr=tmpStr_anoNote_"^" //query.GetDataByName("ANO_Note")_"^"
                ...s anoQty=+$p(^DHCANOrder(anoId),"^",11)
                ...s tmpStr=tmpStr_anoQty_"^" //query.GetDataByName("ANO_Qty")_"^"
                ...s ctuomId=$p(^DHCANOrder(anoId),"^",12)
                ...s tmpStr=tmpStr_ctuomId_"^" //query.GetDataByName("ANO_Uom_Dr")_"^"
                ...s anoDensity=$p(^DHCANOrder(anoId),"^",13)
                ...s tmpStr=tmpStr_anoDensity_"^" //query.GetDataByName("ANO_Density")_"^"
                ...s anacomId=$p(^DHCANOrder(anoId),"^",14)
                ...s tmpStr=tmpStr_anacomId_"^" //query.GetDataByName("ANO_Compli_Dr")_"^"
                ...s phcinId=$p(^DHCANOrder(anoId),"^",15)
                ...s tmpStr=tmpStr_phcinId_"^" //query.GetDataByName("ANO_Instr_Dr")_"^"
                ...s ancvcId=$p(^DHCANOrder(anoId),"^",16) //query.GetDataByName("ANO_ViewCat_Dr")                  
                ...s ancvcDesc=""
                ...i ancvcId'="" s ancvcDesc=$p($g(^DHCANC("ViewCat",ancvcId)),"^",2)
                ...s tmpStr=tmpStr_ancvcId_"^"
                ...s anoFlag=$p(^DHCANOrder(anoId),"^",17)
                ...s tmpStr=tmpStr_anoFlag_"^" //query.GetDataByName("ANO_Flag")_"^"
                ...s anoDrugMode=$p(^DHCANOrder(anoId),"^",18)
                ...s tmpStr=tmpStr_anoDrugMode_"^" //query.GetDataByName("ANO_DrugMode")_"^"
                ...s anoSpeed=+$p(^DHCANOrder(anoId),"^",19)
                ...s tmpStr=tmpStr_anoSpeed_"^" //+query.GetDataByName("ANO_Speed")_"^"
                ...s updateDate=$p(^DHCANOrder(anoId),"^",21)
                ...s anoUpdateDate=$ZD($p(^DHCANOrder(anoId),"^",21),3)
                ...s tmpStr=tmpStr_anoUpdateDate_"^" //$ZD(query.GetDataByName("ANO_UpdateDate"),3)_"^"
                ...s updateTime=$p(^DHCANOrder(anoId),"^",22)
                ...s anoUpdateTime=$ZT($p(^DHCANOrder(anoId),"^",22))
                ...s tmpStr=tmpStr_anoUpdateTime_"^" //$ZT(query.GetDataByName("ANO_UpdateTime"))_"^"
                ...s anoReason=$p(^DHCANOrder(anoId),"^",24)
                ...s tmpStr=tmpStr_anoReason_"^" //query.GetDataByName("ANO_Reason")_"^"
                ...s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
                ...s tmpStr=tmpStr_anoEditFlag_"^" //query.GetDataByName("ANO_EditFlag")_"^"
                ...s anoAnoId=$p(^DHCANOrder(anoId),"^",23)
                ...s tmpStr=tmpStr_anoAnoId_"^" //query.GetDataByName("ANO_ANO_DR")_"^"
                ...s anoRecLocId=$p(^DHCANOrder(anoId),"^",26)
                ...s tmpStr=tmpStr_anoRecLocId_"^" //query.GetDataByName("ANO_RecLoc_Dr")_"^"
                ...s anoDocUserId=$p(^DHCANOrder(anoId),"^",27)
                ...s tmpStr=tmpStr_anoDocUserId_"^" //query.GetDataByName("ANO_DocUser_Dr")_"^"
                ...s anoVolume=+$p(^DHCANOrder(anoId),"^",28)
                ...s tmpStr=tmpStr_anoVolume_"^" //+query.GetDataByName("ANO_Volume")_"^"
                ...s anosuId=+$p(^DHCANOrder(anoId),"^",20)
                ...s tmpStr=tmpStr_anosuId_"^" //+query.GetDataByName("ANO_SpeedUnit_Dr")_"^"
                ...s anoSource=$p(^DHCANOrder(anoId),"^",29)
                ...s tmpStr=tmpStr_anoSource_"^" //query.GetDataByName("ANO_Source")_"^"
                ...s anoType=$p(^DHCANOrder(anoId),"^",30)
                ...s tmpStr=tmpStr_anoType_"^" //query.GetDataByName("ANO_Type")_"^"
                ...s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
                ...s tmpStr=tmpStr_ancoDesc_"^"  //$p($g(^DHCANC("ComOrd",+query.GetDataByName("ANO_ANCORD_Dr"))),"^",2)_"^"
                ...s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
                ...s tmpStr=tmpStr_arcimDesc_"^" //$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
                ...s anoQty2=+$p(^DHCANOrder(anoId),"^",31)
                ...s anoQty3=+$p(^DHCANOrder(anoId),"^",32)
                ...s anoSubANOrder=$p(^DHCANOrder(anoId),"^",33)
                ...s anoMainANODr=$p(^DHCANOrder(anoId),"^",34)
                ...//s anoId=query.GetDataByName("ANO_RowId")                         //anoId
                ...s ^TMPAN("Order",$j,ancoId_arcimId,updateDate,updateTime,anoId)=tmpStr_anoId
                ...//w ^TMPAN("Order",$j,arcimId,ANOUDate,ANOUTime,anoId),!
                ...Do OutputRow
    /*
    s i=0
    s arcimId="" f  s arcimId=$o(^TMPAN("Order",$j,arcimId))  q:arcimId=""  d
     .s dat="" f  s dat=$o(^TMPAN("Order",$j,arcimId,dat))  q:dat=""  d
         ..s tim="" f  s tim=$o(^TMPAN("Order",$j,arcimId,dat,tim))  q:tim=""  d
             ...s anoId="" f  s anoId=$o(^TMPAN("Order",$j,arcimId,dat,tim,anoId))  q:anoId=""  d
                 ....s i=i+1
                 ....s ^TMPAN("OrderRet",$j,i)=^TMPAN("Order",$j,arcimId,dat,tim,anoId)
                 ....//w i_": " _^TMPAN("OrderRet",$j,i),!
                 ....*/
    Set qHandle=$lb(0,repid,0)
    //s ^tmpYpz("queryTime")=^tmpYpz("queryTime")_"/"_$p($h,",",2)
    Quit $$$OK
    
OutputRow
    set Data=$lb(anoId,ancoId,oeoriId,userId,anoStartDate,anoStartTime,anoEndDate,anoEndTime,arcimId,anoNote,anoQty,ctuomId,anoDensity,anacomId,phcinId,ancvcId,anoFlag,anoDrugMode,anoSpeed,anoUpdateDate,anoUpdateTime,anoReason,anoEditFlag,anoAnoId,anoRecLocId,anoDocUserId,anoVolume,anosuId,anoSource,anoType,ancoDesc,arcimDesc,anoQty2,anoQty3,anoSubANOrder,anoMainANODr)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetByOpaAndDateTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetByOpaAndDateTimeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
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

ClassMethod GetByOpaAndDateTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetByOpaAndDateTimeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// Query FindANOrders(opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Query(ROWSPEC = "Id,RecordItemId,OEOriId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Density,anacomId,InstrId,RecordSubCatId,Float,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,RecordOrderId,RecvLocId,DocUserId,Volume,SpeedUnitId,Source,OrderType,RecordItemDesc,ArcimDesc,Qty2,Qty3,SubRecordOrderId,MainRecordOrderId,Abbreviate,ParaItemId")

Query FindANOrders(opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Query(ROWSPEC = "Id,RecordItemId,OEOriId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Density,anacomId,InstrId,RecordSubCatId,Flag,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,RecordOrderId,RecvLocId,DocUserId,Volume,SpeedUnitId,Source,OrderType,RecordItemDesc,ArcimDesc,Qty2,Qty3,SubRecordOrderId,MainRecordOrderId,Abbreviate,ParaItemId")
{
}

ClassMethod FindANOrdersExecute(ByRef qHandle As %Binary, opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String) As %Status
{
    //取开始时间点数据，不取结束时间点数据
    //D ##class(%ResultSet).RunQuery("web.DHCANOrder","GetByOpaAndDateTime",44,62169,36000,62169,43200)
    //s ^tmpYpz("queryTime")=$p($h,",",2)
    Set repid=$I(^CacheTemp)

    If $g(ind)="" Set ind=1
    k ^TMPAN("Order",$j)
    k ^TMPAN("OrderRet",$j)
    
    i opaId="" s qHandle=$lb(0,repid,0) Quit $$$OK

    s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
    s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
    i startDate>endDate s qHandle=$lb(0,repid,0) Quit $$$OK

    s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
    s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
    i (startDate=endDate)&(startTime>endTime) s qHandle=$lb(0,repid,0) Quit $$$OK
    i endDate>$h s endDate=$h+1
    f uDate=startDate:1:endDate d
        .i uDate=startDate s uTime=startTime-1
        .e  s uTime=-1
        .i uDate=endDate s eTime=endTime
        .e  s eTime=86400
        .f  s uTime=$o(^DHCANOrder(0,"UpdateDateTime",opaId,uDate,uTime)) q:(uTime="")!(uTime'<eTime)  d
            ..s anoId=""
            ..f  s anoId=$o(^DHCANOrder(0,"UpdateDateTime",opaId,uDate,uTime,anoId)) q:(anoId="")  d
                ...q:'$d(^DHCANOrder(anoId))
                ...s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
                ...q:((anoEditFlag'="E")&&(anoEditFlag'="N"))
                ...s arcimId=$p(^DHCANOrder(anoId),"^",9)  //query.GetDataByName("ANO_ARCIM_Dr")
                ...s ancoId=$p(^DHCANOrder(anoId),"^",2)  //query.GetDataByName("ANO_ANCORD_Dr")  
                ...q:(+ancoId=0)&(arcimId="")
                ...s tmpStr=ancoId_"^"
                ...s oeoriId=$p(^DHCANOrder(anoId),"^",3)  
                ...s tmpStr=tmpStr_oeoriId_"^" //query.GetDataByName("ANO_OEORI_Dr")_"^"
                ...s userId=$p(^DHCANOrder(anoId),"^",4)
                ...s tmpStr=tmpStr_userId_"^" //query.GetDataByName("ANO_User_Dr")_"^"
                ...s anoStartDate=$ZD($p(^DHCANOrder(anoId),"^",5),3)
                ...s tmpStr=tmpStr_anoStartDate_"^" //$ZD(query.GetDataByName("ANO_StartDate"),3)_"^"
                ...s anoStartTime=$ZT($p(^DHCANOrder(anoId),"^",6))
                ...s tmpStr=tmpStr_anoStartTime_"^" //$ZT(query.GetDataByName("ANO_StartTime"))_"^"
                ...s anoEndDate=$ZD($p(^DHCANOrder(anoId),"^",7),3)
                ...s tmpStr=tmpStr_anoEndDate_"^" //$ZD(query.GetDataByName("ANO_EndDate"),3)_"^"
                ...s anoEndTime=$ZT($p(^DHCANOrder(anoId),"^",8))
                ...s tmpStr=tmpStr_anoEndTime_"^" //$ZT(query.GetDataByName("ANO_EndTime"))_"^"
                ...s tmpStr=tmpStr_arcimId_"^"
                ...s anoNote=$p(^DHCANOrder(anoId),"^",10)
                ...s tmpStr=tmpStr_anoNote_"^" //query.GetDataByName("ANO_Note")_"^"
                ...s anoQty=+$p(^DHCANOrder(anoId),"^",11)
                ...s tmpStr=tmpStr_anoQty_"^" //query.GetDataByName("ANO_Qty")_"^"
                ...s ctuomId=$p(^DHCANOrder(anoId),"^",12)
                ...s tmpStr=tmpStr_ctuomId_"^" //query.GetDataByName("ANO_Uom_Dr")_"^"
                ...s anoDensity=$p(^DHCANOrder(anoId),"^",13)
                ...s tmpStr=tmpStr_anoDensity_"^" //query.GetDataByName("ANO_Density")_"^"
                ...s anacomId=$p(^DHCANOrder(anoId),"^",14)
                ...s tmpStr=tmpStr_anacomId_"^" //query.GetDataByName("ANO_Compli_Dr")_"^"
                ...s phcinId=$p(^DHCANOrder(anoId),"^",15)
                ...s tmpStr=tmpStr_phcinId_"^" //query.GetDataByName("ANO_Instr_Dr")_"^"
                ...s ancvcId=$p(^DHCANOrder(anoId),"^",16) //query.GetDataByName("ANO_ViewCat_Dr")                  
                ...s ancvcDesc=""
                ...i ancvcId'="" s ancvcDesc=$p($g(^DHCANC("ViewCat",ancvcId)),"^",2)
                ...s tmpStr=tmpStr_ancvcId_"^"
                ...s anoFlag=$p(^DHCANOrder(anoId),"^",17)
                ...s tmpStr=tmpStr_anoFlag_"^" //query.GetDataByName("ANO_Flag")_"^"
                ...s anoDrugMode=$p(^DHCANOrder(anoId),"^",18)
                ...s tmpStr=tmpStr_anoDrugMode_"^" //query.GetDataByName("ANO_DrugMode")_"^"
                ...s anoSpeed=+$p(^DHCANOrder(anoId),"^",19)
                ...s tmpStr=tmpStr_anoSpeed_"^" //+query.GetDataByName("ANO_Speed")_"^"
                ...s updateDate=$p(^DHCANOrder(anoId),"^",21)
                ...s anoUpdateDate=$ZD($p(^DHCANOrder(anoId),"^",21),3)
                ...s tmpStr=tmpStr_anoUpdateDate_"^" //$ZD(query.GetDataByName("ANO_UpdateDate"),3)_"^"
                ...s updateTime=$p(^DHCANOrder(anoId),"^",22)
                ...s anoUpdateTime=$ZT($p(^DHCANOrder(anoId),"^",22))
                ...s tmpStr=tmpStr_anoUpdateTime_"^" //$ZT(query.GetDataByName("ANO_UpdateTime"))_"^"
                ...s anoReason=$p(^DHCANOrder(anoId),"^",24)
                ...s tmpStr=tmpStr_anoReason_"^" //query.GetDataByName("ANO_Reason")_"^"
                ...s tmpStr=tmpStr_anoEditFlag_"^" //query.GetDataByName("ANO_EditFlag")_"^"
                ...s anoAnoId=$p(^DHCANOrder(anoId),"^",23)
                ...s tmpStr=tmpStr_anoAnoId_"^" //query.GetDataByName("ANO_ANO_DR")_"^"
                ...s anoRecLocId=$p(^DHCANOrder(anoId),"^",26)
                ...s tmpStr=tmpStr_anoRecLocId_"^" //query.GetDataByName("ANO_RecLoc_Dr")_"^"
                ...s anoDocUserId=$p(^DHCANOrder(anoId),"^",27)
                ...s tmpStr=tmpStr_anoDocUserId_"^" //query.GetDataByName("ANO_DocUser_Dr")_"^"
                ...s anoVolume=+$p(^DHCANOrder(anoId),"^",28)
                ...s tmpStr=tmpStr_anoVolume_"^" //+query.GetDataByName("ANO_Volume")_"^"
                ...s anosuId=+$p(^DHCANOrder(anoId),"^",20)
                ...s tmpStr=tmpStr_anosuId_"^" //+query.GetDataByName("ANO_SpeedUnit_Dr")_"^"
                ...s anoSource=$p(^DHCANOrder(anoId),"^",29)
                ...s tmpStr=tmpStr_anoSource_"^" //query.GetDataByName("ANO_Source")_"^"
                ...s anoType=$p(^DHCANOrder(anoId),"^",30)
                ...s tmpStr=tmpStr_anoType_"^" //query.GetDataByName("ANO_Type")_"^"
                ...s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
                ...s tmpStr=tmpStr_ancoDesc_"^"  //$p($g(^DHCANC("ComOrd",+query.GetDataByName("ANO_ANCORD_Dr"))),"^",2)_"^"
                ...s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
                ...s tmpStr=tmpStr_arcimDesc_"^" //$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
                ...s anoQty2=+$p(^DHCANOrder(anoId),"^",31)
                ...s anoQty3=+$p(^DHCANOrder(anoId),"^",32)
                ...s anoSubANOrder=$p(^DHCANOrder(anoId),"^",33)
                ...s anoMainANODr=$p(^DHCANOrder(anoId),"^",34)
                ...s abbreviate=$p(^DHCANOrder(anoId),"^",35)
                ...s anoANPIDr=$p(^DHCANOrder(anoId),"^",36)
                ...s sheetFlag=..GetSheetFlag(anoANPIDr)
                ...i (sheetFlag="PACU") s anoFlag="P"   //区分数据来源(AN/PACU) YuanLin 20170912
                ...//s anoId=query.GetDataByName("ANO_RowId")                         //anoId
                ...//s ^TMPAN("Order",$j,ancoId_arcimId,updateDate,updateTime,anoId)=tmpStr_anoId
                ...//w ^TMPAN("Order",$j,arcimId,ANOUDate,ANOUTime,anoId),!
                ...Do OutputRow
    /*
    s i=0
    s arcimId="" f  s arcimId=$o(^TMPAN("Order",$j,arcimId))  q:arcimId=""  d
     .s dat="" f  s dat=$o(^TMPAN("Order",$j,arcimId,dat))  q:dat=""  d
         ..s tim="" f  s tim=$o(^TMPAN("Order",$j,arcimId,dat,tim))  q:tim=""  d
             ...s anoId="" f  s anoId=$o(^TMPAN("Order",$j,arcimId,dat,tim,anoId))  q:anoId=""  d
                 ....s i=i+1
                 ....s ^TMPAN("OrderRet",$j,i)=^TMPAN("Order",$j,arcimId,dat,tim,anoId)
                 ....//w i_": " _^TMPAN("OrderRet",$j,i),!
                 ....*/
    Set qHandle=$lb(0,repid,0)
    //s ^tmpYpz("queryTime")=^tmpYpz("queryTime")_"/"_$p($h,",",2)
    Quit $$$OK
    
OutputRow
    set Data=$lb(anoId,ancoId,oeoriId,userId,anoStartDate,anoStartTime,anoEndDate,anoEndTime,arcimId,anoNote,anoQty,ctuomId,anoDensity,anacomId,phcinId,ancvcId,anoFlag,anoDrugMode,anoSpeed,anoUpdateDate,anoUpdateTime,anoReason,anoEditFlag,anoAnoId,anoRecLocId,anoDocUserId,anoVolume,anosuId,anoSource,anoType,ancoDesc,arcimDesc,anoQty2,anoQty3,anoSubANOrder,anoMainANODr,abbreviate,anoANPIDr)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindANOrdersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANOrdersExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
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

ClassMethod FindANOrdersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANOrdersExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetRecLoc(EpisodeID, arcimId) As %String
{
    s retStr=""
    s recLocStrList=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,arcimId)
    //s recLocStrList=1_$c(1)_"A科"_$c(1)_"N"_$c(2)_2_$c(1)_"B科"_$c(1)_"Y"
    f j=1:1:$l(recLocStrList,$c(2)) d
        .s recLocStr=$p(recLocStrList,$c(2),j)
        .q:$p(recLocStr,$c(1),3)'="Y"
        .s retStr=$tr(recLocStr,$c(1),$c(3))
    q retStr
}

// ClassMethod InsertOrdItem(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes) As %String

ClassMethod InsertOrderItem(EpisodeID, mulOeoriStr, userId, locId) As %String
{
    //EpisodeID就诊号, userId用户Id, locId登录科室Id, 
    //mulOeoriStr由$c(3)分割：arcimId医嘱码Id, startDate开始日期, startTime开始时间,recDepId接收科室, 
    //doseQty单次剂量,doseQtySum数量, doseUomId等效剂量单位, instrId用法, seqNo序号, masterSeqNo主医嘱序号,oeoriPrice价格,排班表opaId,医嘱备注depProcNotes
    //其中seqNo序号取自然序号，不是插入后的序号。masterSeqNo值取主医嘱的seqNo序号
    //返回以"^"分割的第一部分为0未成功,错误信息为第二部分。成功则返回类于"1576||1*924106||331*V^1402||1*924106||332*V^"的串
    s ^tempck("InsertOrderItem")=EpisodeID_"*"_mulOeoriStr_"*"_userId_"*"_locId
    //w ##class(web.DHCANOrder).InsertOrderItem(1030551,"",10376,831)
    //s mulOeoriStr="1576||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_250_$c(3)_250_$c(3)_619_$c(3)_12_$c(3)_1_$c(3)_""
    //s mulOeoriStr=mulOeoriStr_"^1402||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_160_$c(3)_160_$c(3)_619_$c(3)_12_$c(3)_2_$c(3)_"1"
    //s mulOeoriStr=  "1575||1"_$c(3)_"2012-4-11"_$c(3)_"17:57"_$c(3)_42_$c(3)_1_$c(3)_1_$c(3)_17_$c(3)_$c(3)_1_$c(3)_$c(3)_1.71_$c(3)_84
    //freqId会不会有变
    
    q:(EpisodeID="")!(mulOeoriStr="")!(userId="")!(locId="") "0^输入数据有误!"
    s LABDATA="LABDATA"
    s docId=$p($g(^SSU("SSUSR",userId)),"^",14)
    q:docId="" "0^请使用医护人员身份登录!"
    
    s orderType="",packQty="",oeprice=0,drugFormId="",depProcNotes="",phPrescType=""
    s masterSeqNo="",skinTest="N",phSpecInstr="",orderCoverMainIns="Y",actionId="",arcosId=""

    s admReasonId=$p(^PAADM(EpisodeID,1),"^",7)

    s defDurId=0
    s phcduId=0
    f  s phcduId=$o(^PHCDU(phcduId)) q:(phcduId="")!(defDurId>0)  d
        .q:$p(^PHCDU(phcduId),"^",2)'=1
        .s defDurId=phcduId
    q:defDurId=0 "没有疗程为1天的数据,请维护!" 
    s defFreqId=0,phcfrId=0,isFind=0
    f  s phcfrId=$o(^PHCFR(phcfrId)) q:(phcfrId="")!(isFind)  d
        .q:$p(^PHCFR(phcfrId),"^",1)'="ONCE"    //YuanLin  20170825
        .q:$p(^PHCFR(phcfrId),"^",2)'=1
        .q:'$d(^PHCFR(phcfrId,"DT"))
        .s defFreqId=phcfrId
        .;i ^PHCFR(phcfrId,"DT",1)=28800 s isFind=1
    //i $o(^PHCFR(0,"Code","QD",""))'="" s defFreqId=$o(^PHCFR(0,"Code","QD",""))
    q:defFreqId=0 "没有频次为1数据,请维护!"
    s priorId=$o(^OECPR(0,"Code","NORM",""))   //优先级
    q:+priorId=0 "没有临时医嘱优先级数据,请维护!"
     
    /*s Config=##Class(websys.Configuration).%OpenId(1)
    s MEDDATA=Config.DataNamespace
    s CurrentNS=$ZNSPACE
    zn MEDDATA     //转换命名空间
    */
    s retStr=0
    s oeoriStr=""
    f i=1:1:$l(mulOeoriStr,"^") d
        .s singleOeoriStr=$p(mulOeoriStr,"^",i)
        .s arcimId=$p(singleOeoriStr,$c(3),1)
        .i '$d(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)) s retStr="医嘱码"_arcimId_"不对!" q
        .s startDate=$p(singleOeoriStr,$c(3),2)
        .s startTime=$p(singleOeoriStr,$c(3),3)
        .
        .s recLocId=$p(singleOeoriStr,$c(3),4)
        .i '$d(^CTLOC(+recLocId)) s recLocId=""
        .i recLocId="" d
            ..s recLocStr=..GetRecLoc(EpisodeID,arcimId)
            ..s recLocId=$p(recLocStr,$c(3),1)
        .i recLocId="" s recLocId=locId
        .s doseQty=$p(singleOeoriStr,$c(3),5)
        .s doseQtySum=+$p(singleOeoriStr,$c(3),6)
        .s doseUomId=$p(singleOeoriStr,$c(3),7)
        .s itemCatId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",10)
        .s orderType=$p($g(^ARC("IC",itemCatId)),"^",7)
        .s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
        .i phcdfId>0 s doseQtySum=##class(web.DHCDocOrderEntry).CalDose(doseUomId,phcdfId,doseQty)
        .i doseQtySum>$p(doseQtySum,".") s doseQtySum=$p(doseQtySum,".")+1
        .s instrId=$p(singleOeoriStr,$c(3),8)
        .s freqId=defFreqId
        .s durId=defDurId
        .s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
        .i phcdfId=-1 s phcdfId=""
        .//i (orderType'="R")  d
        .//.s doseQty="",doseUomId="",phcdfId="",doseQtySum="",freqId=""
        .i phcdfId="" s freqId="",durId=""
        .s seqNo=$p(singleOeoriStr,$c(3),9)
        .s masterSeqNo=$p(singleOeoriStr,$c(3),10)
        .s oeprice=$p(singleOeoriStr,$c(3),11) //ypz 110316
        .s packQty=$p(singleOeoriStr,$c(3),12)  //dyl+20160301
        .s opaId=$p(singleOeoriStr,$c(3),13) //dyl+20160301
        .s anaId=$p($g(^DHCANOPArrange(+opaId)),"^",2) //ypz 110316
        .s depProcNotes=$p(singleOeoriStr,$c(3),14) //dyl+20160301
        .
        .s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
        .s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
        .;病人出院时间
        .s patDisCharDate=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
        .;病人出院状态
        .s patOutStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
        .i (patDisCharDate'="")&(patOutStatus="B") s startDate=$p(patDisCharDate,"^",1),startTime=$p(patDisCharDate,"^",2)
        .s startDate=$ZD(startDate,4)
        .s startTime=$ZT(startTime,3)
        .s admId=$p($g(^DHCANOPArrange(+opaId)),"^",1)
        .s oeordId=$o(^OEORD(0,"Adm",admId,""))
        .s orderCoverMainIns=$p($g(^OEORD(oeordId,"I",1,3)),"^",3)  ;20170406+dyl+取医保标志
        .i oeoriStr'="" s oeoriStr=oeoriStr_$c(1)
        .s oeoriStr=oeoriStr_arcimId_"^"_orderType_"^"_priorId_"^"_startDate_"^"_startTime_"^"_packQty_"^"_oeprice_"^"_recLocId_"^"_admReasonId_"^"_drugFormId
        .s oeoriStr=oeoriStr_"^"_depProcNotes_"^"_doseQty_"^"_doseUomId_"^"_doseQtySum_"^"_freqId_"^"_durId_"^"_instrId_"^"_phPrescType_"^"_masterSeqNo_"^"_seqNo
        .s oeoriStr=oeoriStr_"^"_skinTest_"^"_phSpecInstr_"^"_orderCoverMainIns_"^"_actionId_"^"_arcosId_"^^^^^"
        .s oeoriStr=oeoriStr_"^^^^^^^"_anaId
    //s ^TMPCLInsertOrd($j)=1
    //2010
    //s retStr=##class(appcom.OEOrdItem).InsertMulti(EpisodeID, oeoriStr, userId, locId, docId)
    //医生站统一新接口 插入医嘱用 YuanLin 20170829
    s retStr=##class(web.DHCOEOrdItem).SaveOrderItems(EpisodeID, oeoriStr, userId, locId, docId)
    s ^tempck("retStr")=retStr
    //P5-P8
    //s retStr=##class(web.DHCANCall).InsertOrderItem(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
    ////s retStr=$$InsertMultiple^DHCDocOrderCommon(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
    i $p(retStr,"^",1)=-1 s $p(retStr,"^",1,2)=$p(retStr,"^",2)
    //k ^TMPCLInsertOrd($j)
    
    ////zn CurrentNS   //恢复命名空间
    //i retStr'="" d ##class(web.DHCOEOrdItem).UpdateOrderStatus(retStr, EpisodeID, userId)
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2009-08-19
/// Description：    取医嘱套医嘱
/// Table：          ARC_OrdSets,ARC_OrdSetDate,ARC_OrdSetDateItem
/// Input：          医嘱套Id,安全组Id,日期
/// Output：       
/// Return：         返回""无数据。返回数据分两级，第一级"^"，是每条医嘱码数据。
///                 第二级$c(3)：医嘱码Id_$c(3)_医嘱码名_$c(3)_医嘱数量
/// 修改记录 ck 20130412 增加3个返回值 医嘱套默认使用剂量、医嘱套默认使用剂量单位ID、医嘱套默认使用剂量单位
ClassMethod GetArcosItem(arcosId, ssgrpId = "", curDate = "") As %String
{
    q:arcosId="" ""
    s curDate="" s curDate=+$h
    s dateDateFrom=$o(^ARCOS(arcosId,"DATE",0,"DateFrom",curDate+1),-1)
    q:dateDateFrom="" ""
    s dateId=$o(^ARCOS(arcosId,"DATE",0,"DateFrom",dateDateFrom,""))
    q:dateId="" ""
    s dateDateTo=$p($g(^ARCOS(arcosId,"DATE",dateId)),"^",2)
    q:(dateDateTo'="")&(dateDateTo<curDate) ""
    s retStr=""
    s itmId=0
    f  s itmId=$o(^ARCOS(arcosId,"DATE",dateId,"ITM",itmId)) q:itmId=""  d
    .s itmValueStr=^(itmId)
    .s arcimId=$p(itmValueStr,"^",1)
    .
    .s arcimDateFrom=$p($g(^ARCIM(+arcimId,1,1)),"^",13)
    .s arcimDateTo=$p($g(^ARCIM(+arcimId,1,7)),"^",1)
    .q:arcimDateFrom>$h //医嘱未到有效期
    .q:(arcimDateTo'="")&(arcimDateTo<$h) //医嘱过有效期
    .
    .s itemQty=$p(itmValueStr,"^",2)
    .i itemQty="" s itemQty=1
    .s itemUomDesc=""
    .s itemDoseQty=$p(itmValueStr,"^",13)
    .s itemUomDr=$p(itmValueStr,"^",10)
    .i itemUomDr'="" s itemUomDesc=$p(^CT("UOM",itemUomDr),"^",2)
    .
    .s arcimStr=##class(web.DHCANCom).GetArcimById(arcimId)
    .s orderPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,"","","","","")
    .i retStr'="" s retStr=retStr_"^"
    .s retStr=retStr_arcimId_$c(3)_$p($g(^ARCIM(+arcimId,1,1)),"^",2)_$c(3)_itemQty
    .s retStr=retStr_$c(3)_$p(arcimStr,"^",4)_$c(3)_$p(arcimStr,"^",5)_$c(3)_$p(arcimStr,"^",6)_$c(3)_$p(arcimStr,"^",7)_$c(3)_$p(arcimStr,"^",8)_$c(3)_$p(arcimStr,"^",9)_$c(3)_$p(arcimStr,"^",10)_$c(3)_$p(orderPrice,"^",1)_$c(3)_itemDoseQty_$c(3)_itemUomDr_$c(3)_itemUomDesc
    
    q retStr
}

ClassMethod GetUserGroupArcos(ssgrpId = "") As %String
{
    q:ssgrpId="" "^^"
    s orcatIdStr="",arcicIdStr=""
    
    s ssordSub=0
    f  s ssordSub=$o(^SSU("SSGRP",+ssgrpId,"SSORD",ssordSub)) q:ssordSub=""  d
        .s ssordStr=^(ssordSub)
        .q:$p(ssordStr,"^",4)'="Y"
        .i $p(ssordStr,"^",5)'="" d
            ..i arcicIdStr'="" s arcicIdStr=arcicIdStr_"#"
            ..s arcicIdStr=arcicIdStr_$p(ssordStr,"^",5)
        .q:$p(ssordStr,"^",5)'=""
        .i $p(ssordStr,"^",1)'="" d
            ..i orcatIdStr'="" s orcatIdStr=orcatIdStr_"#"
            ..s orcatIdStr=orcatIdStr_$p(ssordStr,"^",1)
    q orcatIdStr_"^"_arcicIdStr_"^"
}

/// Creator：        ypz
/// CreatDate：      2009-08-19
/// Description：    取医嘱套
/// Table：          ARC_OrdSets
/// Input：          安全组Id
/// Output：        医嘱套Id和描述
/// Return：         
Query FindARCOrdSets(ssgrpId) As %Query(ROWSPEC = "arcosId:%String,arcosDesc:%String,arcosCode:%String")
{
}

ClassMethod FindARCOrdSetsExecute(ByRef qHandle As %Binary, ssgrpId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s userGroupArcosStr=..GetUserGroupArcos(ssgrpId)
    s orcatIdStr=$p(userGroupArcosStr,"^")
    s arcicIdStr=$p(userGroupArcosStr,"^",2)
    s arcosId=0
    f  s arcosId=$o(^ARCOS(arcosId)) q:arcosId=""  d
        .q:$d(^ARCOS(arcosId))<11
        .s arcosDesc=$p(^ARCOS(arcosId),"^",2)
        .q:arcosDesc=""
        .s arcosCode=$p(^ARCOS(arcosId),"^",1)
        .q:arcosCode=""
        .s orcatId=$p(^ARCOS(arcosId),"^",8)
        .q:orcatId=""
        .s arcicId=$p(^ARCOS(arcosId),"^",9)
        .q:($p(^ARCOS(arcosId),"^",16)>0)&($p(^ARCOS(arcosId),"^",16)<$h) //ARCOS_EffDateTo
        .q:(ssgrpId'="")&((("#"_orcatIdStr_"#")'[("#"_orcatId_"#"))&(("#"_arcicIdStr_"#")'[("#"_arcicId_"#")))
        .d OutputRow1
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(arcosId,arcosDesc,arcosCode)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindARCOrdSetsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindARCOrdSetsExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
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

ClassMethod FindARCOrdSetsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindARCOrdSetsExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 计算两个事件间相距的时间差，单位分钟
ClassMethod GetAnoDuraMinute(opaId, startAncoCode, endAncoCode) As %String
{
    q:(opaId="")!(startAncoCode="")!(endAncoCode="") ""
    s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode","E",startAncoCode,""))
    q:ancoId="" ""
    s anoId="",startDate=""
    f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId)) q:(anoId="")!(startDate'="")  d
        .q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
        .s startDate=$p(^DHCANOrder(anoId),"^",5)
        .s startTime=$p(^DHCANOrder(anoId),"^",6)
    s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode","E",endAncoCode,""))
    s anoId="",endDate=""
    f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId),-1) q:(anoId="")!(endDate'="")  d
        .q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
        .s endDate=$p(^DHCANOrder(anoId),"^",5)
        .s endTime=$p(^DHCANOrder(anoId),"^",6)
    q:(startDate="")!(endDate="") ""
    q:startDate>endDate ""
    q:(startDate=endDate)&(startTime>endTime) ""
    q (endDate-startDate)*86400+endTime-startTime
}

ClassMethod GetAnoVitalSignQty(opaId, ancoCodeStr, delimter = "^") As %String
{
    q:(opaId="")!(ancoCodeStr="") ""
    i delimter="" s delimter="^"
    s retStr=""
    f i=1:1:$l(ancoCodeStr,"^") d
        .s ancoCode=$p(ancoCodeStr,"^",i)
        .q:ancoCode=""
        .s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode","V",ancoCode,""))
        .q:ancoId=""
        .s anoId=""
        .f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId)) q:(anoId="")  d
            ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
            ..i retStr'="" s retStr=retStr_delimter
            ..s retStr=retStr_$p(^DHCANOrder(anoId),"^",11)
    q retStr
}

ClassMethod GetAnoEvent(opaId, ancoCodeStr, delimter = "^") As %String
{
    q:(opaId="") ""
    i delimter="" s delimter="^"
    i ancoCodeStr="" d
        .s ancoCode=""
        .f  s ancoCode=$o(^DHCANC("ComOrd",0,"TypeCode","E",ancoCode)) q:ancoCode=""  d
            ..i ancoCodeStr'="" s ancoCodeStr=ancoCodeStr_"^"
            ..s ancoCodeStr=ancoCodeStr_ancoCode
    s retStr=""
    f i=1:1:$l(ancoCodeStr,"^") d
        .s ancoCode=$p(ancoCodeStr,"^",i)
        .s curEventStr=..GetAnoEventSingle(opaId,ancoCode)
        .q:curEventStr=""
        .i retStr'="" s retStr=retStr_delimter
        .s retStr=retStr_curEventStr
    q retStr
}

/// Creator：        ypz
/// CreatDate：      2012-03-23
/// Description：    取病人一个事件代码的麻醉监护数据
/// Table：          DHC_AN_Order
/// Input：          排班表opaId, 事件代码ancoCode, 时间序order(1顺序，-1倒序),是否单个数据ifSingle(Y/N)，
///                     是否包括事件描述ifIncludeDesc(Y/N), 时间格式dateTimeFormat("T"不含日期，仅时间)，分隔符delimter
/// Output：        事件描述和时间，多个时间点以delimter分割。
/// Return：
/// w ##class(web.DHCANOrder).GetAnoEventSingle(115,"TheatreIn")        
ClassMethod GetAnoEventSingle(opaId, ancoCode, order = 1, ifSingle = "", ifIncludeDesc = "Y", dateTimeFormat = "", delimter = "^") As %String
{
    q:(opaId="") ""
    i delimter="" s delimter="^"
    q:ancoCode="" ""
    i order'=-1 s order=1
    s retStr=""
    s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode","E",ancoCode,""))
    q:ancoId="" ""
    s anoId="",ifFind=0
    f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId),order) q:(anoId="")!(ifFind)  d
        .q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
        .//b ;11
        .i dateTimeFormat="T" s dateTime=##class(web.DHCANOPCom).ConvertToTime($p($g(^DHCANOrder(anoId)),"^",6),"")
        .e  s dateTime=##class(web.DHCANOPCom).ConvertToDateTime($p($g(^DHCANOrder(anoId)),"^",5),$p($g(^DHCANOrder(anoId)),"^",6),"")
        .i retStr'="" s retStr=retStr_delimter
        .i ifIncludeDesc="Y" s retStr=retStr_$p($g(^DHCANC("ComOrd",ancoId)),"^",2)_$c(3)_dateTime
        .e  s retStr=retStr_dateTime
        .i ifSingle="Y" s ifFind=1
    q retStr
}

/// 是否完成麻醉单，根据事件计算的手术时长、麻醉时长。
ClassMethod IfFinishAnaRecord(opaId) As %String
{
    q:opaId="" 0
    q:"ARDI"[$p(^DHCANOPArrange(opaId),"^",27) 0
    //q:$g(^DHCCLSet("AnOp","FinishAnaRecordEvent"))="" 1
    q:(..GetAnoDuraMinute(opaId, "AnaStart", "AnaEnd")'>0) 0
    q:(..GetAnoDuraMinute(opaId, "OperStart", "OperEnd")'>0) 0
    q 1
}

ClassMethod GetAnOrderInfoCRF(opaId, type, ancoCodeStr = "", delimter = "^") As %Library.ListOfObjects
{
    q:(opaId="") ""
    q:(type="") ""
    s list=##class(%Library.ListOfObjects).%New()
    i delimter="" s delimter="^"
    i ancoCodeStr="" d
        .s ancoCode=""
        .f  s ancoCode=$o(^DHCANC("ComOrd",0,"TypeCode",type,ancoCode)) q:ancoCode=""  d
            ..i ancoCodeStr'="" s ancoCodeStr=ancoCodeStr_"^"
            ..s ancoCodeStr=ancoCodeStr_ancoCode
    s retStr=""
    f i=1:1:$l(ancoCodeStr,"^") d
        .s ancoCode=$p(ancoCodeStr,"^",i)
        .q:ancoCode=""
        .s ancoId=$o(^DHCANC("ComOrd",0,"TypeCode",type,ancoCode,""))
        .q:ancoId=""
        .s anoId=""
        .f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId)) q:(anoId="")  d
            ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
            ..s ancoId=$p(^DHCANOrder(anoId),"^",2)
            ..s obj = ##class(web.DHCAnEntityOrder).%New()
            ..s obj.ANCODesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
            ..s obj.ANOStartDateTime=##class(web.DHCANOPCom).ConvertToDateTime($p($g(^DHCANOrder(anoId)),"^",5),$p($g(^DHCANOrder(anoId)),"^",6),"")
            ..s obj.ANOEndDateTime=##class(web.DHCANOPCom).ConvertToDateTime($p($g(^DHCANOrder(anoId)),"^",7),$p($g(^DHCANOrder(anoId)),"^",8),"")
            ..s ctuomId=$p(^DHCANOrder(anoId),"^",12)
            ..s obj.ANOUom=$p(^CT("UOM",+ctuomId),"^",2)
            ..s obj.ANOQty=+$p(^DHCANOrder(anoId),"^",11)
            ..s phcinId=$p(^DHCANOrder(anoId),"^",15)
            ..s obj.ANOInstr=$p($g(^PHCIN(+phcinId)),"^",2)
            ..s obj.ANODrugMode=$p(^DHCANOrder(anoId),"^",18)
            ..i obj.ANODrugMode="S" s obj.ANODrugMode="单次给药"
            ..i obj.ANODrugMode="C" s obj.ANODrugMode="连续给药"
            ..i obj.ANODrugMode="T" s obj.ANODrugMode="靶控给药"
            ..s obj.ANOSpeed=+$p(^DHCANOrder(anoId),"^",19)
            ..s speedUnitId=+$p(^DHCANOrder(anoId),"^",20)
            ..s obj.ANOSpeedUnit=$p(^DHCANC("SUnit",+speedUnitId),"^",2)
            ..s obj.ANONote=$p(^DHCANOrder(+anoId),"^",10)
            ..//w obj.ANCODesc,obj.ANOStartDateTime,obj.ANOEndDateTime,obj.ANOUom,obj.ANOQty,obj.ANOInstr,obj.ANODrugMode,obj.ANOSpeed,obj.ANOSpeedUnit,obj.ANONote
            ..//w !
            ..d list.Insert(obj)
    q list
}

ClassMethod SaveANOrders(orderPara As %String) As %String
{
    s singleOrderNum=$l(orderPara,"^")
    s result=""
    f i=1:1:singleOrderNum d
    .s singleOrderPara=$p(orderPara,"^",i)
    .s singleOrder=..CreateANOrder(singleOrderPara)
    .b //ccq
    .d singleOrder.%Save()
    .b //ccq2
    .i result'="" s result=result_"^"
    .s result=result_singleOrder.%Id()
    
    q result
}

ClassMethod CreateANOrder(singleOrderPara As %String) As User.DHCANOrder
{
    s orderId=$p(singleOrderPara,$c(3),1)
    s result=""
    i orderId="" s result=##class(User.DHCANOrder).%New()
    e  s result=##class(User.DHCANOrder).%OpenId(orderId)
    
    s opaId=$p(singleOrderPara,$c(3),2)
    i opaId'="" s result.ANOOPADr=##class(User.DHCANOPArrange).%OpenId(opaId)
    
    s comOrdId=$p(singleOrderPara,$c(3),3)
    i comOrdId'="" s result.ANOANCORDDr=##class(User.DHCANCCommonOrd).%OpenId(comOrdId)
    
    s result.ANOUserDr=$p(singleOrderPara,$c(3),4)
    s result.ANOStartDate=##class(web.DHCANOPCom).ConvertToDateH($p(singleOrderPara,$c(3),5))
    s result.ANOStartTime=##class(web.DHCANOPCom).ConvertToTimeH($p(singleOrderPara,$c(3),6))
    s result.ANOEndDate=##class(web.DHCANOPCom).ConvertToDateH($p(singleOrderPara,$c(3),7))
    s result.ANOEndTime=##class(web.DHCANOPCom).ConvertToTimeH($p(singleOrderPara,$c(3),8))
    s result.ANOARCIMDr=$p(singleOrderPara,$c(3),9)
    s result.ANONote=$p(singleOrderPara,$c(3),10)
    s result.ANOQty=$p(singleOrderPara,$c(3),11)
    s result.ANOUomDr=$p(singleOrderPara,$c(3),12)
    s result.ANODensity=$p(singleOrderPara,$c(3),13)
    s result.ANOCompliDr=$p(singleOrderPara,$c(3),14)
    s result.ANOInstrDr=$p(singleOrderPara,$c(3),15)
    
    s viewCatId=$p(singleOrderPara,$c(3),16)
    i viewCatId'="" s result.ANOViewCatDr=##class(User.DHCANCViewCat).%OpenId(viewCatId)
    
    s result.ANOFlag=$p(singleOrderPara,$c(3),17)
    s result.ANODrugMode=$p(singleOrderPara,$c(3),18)
    s result.ANOSpeed=$p(singleOrderPara,$c(3),19)
    
    s speedUnitId=$p(singleOrderPara,$c(3),20)
    i speedUnitId'="" s result.ANOSpeedUnitDr=##class(User.DHCANCSpeedUnit).%OpenId(speedUnitId)
    
    s result.ANOUpdateDate=##class(web.DHCANOPCom).ConvertToDateH($p(singleOrderPara,$c(3),21))
    s result.ANOUpdateTime=##class(web.DHCANOPCom).ConvertToTimeH($p(singleOrderPara,$c(3),22))
    
    s relateOrderId=$p(singleOrderPara,$c(3),23)
    i relateOrderId'="" s result.ANOANODR=##class(User.DHCANOrder).%OpenId(relateOrderId)
    
    s anoReason=$p(singleOrderPara,$c(3),24)
    i anoReason'="" s result.ANOReason=anoReason
    s result.ANOEditFlag=$p(singleOrderPara,$c(3),25)
    s result.ANOOEORIDr=$p(singleOrderPara,$c(3),26)
    s result.ANORecLocDr=$p(singleOrderPara,$c(3),27)
    s result.ANODocUserDr=$p(singleOrderPara,$c(3),28)
    s result.ANOVolume=$p(singleOrderPara,$c(3),29)
    s result.ANOSource=$p(singleOrderPara,$c(3),30)
    s result.ANOType=$p(singleOrderPara,$c(3),31)
    s result.ANOQty2=$p(singleOrderPara,$c(3),32)
    s result.ANOQty3=$p(singleOrderPara,$c(3),33)
    s result.ANOSubANOrder=$p(singleOrderPara,$c(3),34)
    
    s mainOrderId=$p(singleOrderPara,$c(3),35)
    i mainOrderId'="" s result.ANOMainANODr=##class(User.DHCANOrder).%OpenId(mainOrderId)
    
    s result.ANOAbbreviate=$p(singleOrderPara,$c(3),36)
    
    s paraItemId=$p(singleOrderPara,$c(3),37)
    i paraItemId'="" s result.ANOANPIDr=##class(User.DHCANParaItem).%OpenId(paraItemId)
    
    q result
}

ClassMethod StopOrder(itmjs As %Library.String = "", itmjsex As %Library.String = "", OrdList As %String = "", UserID As %String = "", PinNum As %String) As %String
{
    s result=##class(web.UDHCStopOrderLook).StopOrder(itmjs,itmjsex,OrdList,UserID,PinNum)
    q result
}

/// w ##Class(web.DHCANOrder).SetAnoEventDateTime("182763","112","4533")
ClassMethod SetAnoEventDateTime(opaId, comOrdId, userId)
{
    s ^tpp(333)=opaId_"^"_comOrdId_"^"_userId
    q:opaId="" "opaid is null"
    q:comOrdId="" "comOrdId is null"
    q:userId="" "userId is null"
    s anoCode=$P(^DHCANC("ComOrd",comOrdId),"^",1)
    q:anoCode="" "anoCode is null"
    s eventDT=##class(web.DHCANOrder).GetAnoEventSingle(opaId,anoCode,-1,"","","T","^")
    s eventDT=$p(eventDT,"^",1)
    s extendCode=""
    i anoCode="TheatreIn" s extendCode="TheatreIn"
    e  i anoCode="TheatreOut" s extendCode="TheatreOut"
    e  i anoCode="AnaStart" s extendCode="AnaStart"
    e  i anoCode="AnaEnd" s extendCode="AnaEnd"
    e  i anoCode="InTube" s extendCode="InTube"
    e  i anoCode="ExTube" s extendCode="ExTube"
    e  i anoCode="OperStart" s extendCode="OperStart"
    e  i anoCode="OperEnd" s extendCode="OperEnd"
    q:extendCode="" "Code is null"
    s retStr=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,extendCode,eventDT,"",userId)
    q retStr
}

Query FindANPACUOrders(opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, OrdCategories As %String, OrdType As %String) As %Query(ROWSPEC = "Id,RecordItemId,OEOriId,UserId,StartDate,StartTime,EndDate,EndTime,ArcimId,Note,Qty,UomId,Density,anacomId,InstrId,RecordSubCatId,Float,DrugMode,Speed,UpdateDate,UpdateTime,Reason,EditFlag,RecordOrderId,RecvLocId,DocUserId,Volume,SpeedUnitId,Source,OrderType,RecordItemDesc,ArcimDesc,Qty2,Qty3,SubRecordOrderId,MainRecordOrderId,Abbreviate,ParaItemId")
{
}

ClassMethod FindANPACUOrdersExecute(ByRef qHandle As %Binary, opaId As %String, startDate As %String, startTime As %String, endDate As %String, endTime As %String, OrdCategories As %String, OrdType As %String) As %Status
{
    //取开始时间点数据，不取结束时间点数据
    //D ##class(%ResultSet).RunQuery("web.DHCANOrder","GetByOpaAndDateTime",44,62169,36000,62169,43200)
    //s ^tmpYpz("queryTime")=$p($h,",",2)
    k ^DHCANICUDEBUG("FindANPACUOrders")
    s ^DHCANICUDEBUG("FindANPACUOrders")=opaId
    Set repid=$I(^CacheTemp)

    If $g(ind)="" Set ind=1
    k ^TMPAN("Order",$j)
    k ^TMPAN("OrderRet",$j)
    k ^TempLm("FindANPACUOrders",$j)
    i opaId="" s qHandle=$lb(0,repid,0) Quit $$$OK
    

    //s ret=""                   //lm 20140225

    s startDate=##class(web.DHCANOPCom).ConvertToDateH(startDate)
    s endDate=##class(web.DHCANOPCom).ConvertToDateH(endDate)
    i startDate>endDate s qHandle=$lb(0,repid,0) Quit $$$OK

    s startTime=##class(web.DHCANOPCom).ConvertToTimeH(startTime)
    s endTime=##class(web.DHCANOPCom).ConvertToTimeH(endTime)
    i (startDate=endDate)&(startTime>endTime) s qHandle=$lb(0,repid,0) Quit $$$OK
    i endDate>$h s endDate=$h+1
    s ancvcCode=""
    f uDate=startDate:1:endDate d
        .i uDate=startDate s uTime=startTime-1
        .e  s uTime=-1
        .i uDate=endDate s eTime=endTime
        .e  s eTime=86400
        .f  s uTime=$o(^DHCANOrder(0,"UpdateDateTime",opaId,uDate,uTime)) q:(uTime="")!(uTime'<eTime)  d
            ..s anoId=""
            ..f  s anoId=$o(^DHCANOrder(0,"UpdateDateTime",opaId,uDate,uTime,anoId)) q:(anoId="")  d
                ...q:'$d(^DHCANOrder(anoId))
                ...s arcimId=$p(^DHCANOrder(anoId),"^",9)  //query.GetDataByName("ANO_ARCIM_Dr")
                ...s ancoId=$p(^DHCANOrder(anoId),"^",2)  //query.GetDataByName("ANO_ANCORD_Dr")  
                ...q:(+ancoId=0)&(arcimId="")
                ...s tmpStr=ancoId_"^"
                ...s oeoriId=$p(^DHCANOrder(anoId),"^",3)  
                ...s tmpStr=tmpStr_oeoriId_"^" //query.GetDataByName("ANO_OEORI_Dr")_"^"
                ...s userId=$p(^DHCANOrder(anoId),"^",4)
                ...s tmpStr=tmpStr_userId_"^" //query.GetDataByName("ANO_User_Dr")_"^"
                ...s anoStartDate=$ZD($p(^DHCANOrder(anoId),"^",5),3)
                ...s tmpStr=tmpStr_anoStartDate_"^" //$ZD(query.GetDataByName("ANO_StartDate"),3)_"^"
                ...s anoStartTime=$ZT($p(^DHCANOrder(anoId),"^",6))
                ...s tmpStr=tmpStr_anoStartTime_"^" //$ZT(query.GetDataByName("ANO_StartTime"))_"^"
                ...s anoEndDate=$ZD($p(^DHCANOrder(anoId),"^",7),3)
                ...s tmpStr=tmpStr_anoEndDate_"^" //$ZD(query.GetDataByName("ANO_EndDate"),3)_"^"
                ...s anoEndTime=$ZT($p(^DHCANOrder(anoId),"^",8))
                ...s tmpStr=tmpStr_anoEndTime_"^" //$ZT(query.GetDataByName("ANO_EndTime"))_"^"
                ...s tmpStr=tmpStr_arcimId_"^"
                ...s anoNote=$p(^DHCANOrder(anoId),"^",10)
                ...s tmpStr=tmpStr_anoNote_"^" //query.GetDataByName("ANO_Note")_"^"
                ...s anoQty=+$p(^DHCANOrder(anoId),"^",11)
                ...s tmpStr=tmpStr_anoQty_"^" //query.GetDataByName("ANO_Qty")_"^"
                ...s ctuomId=$p(^DHCANOrder(anoId),"^",12)
                ...s tmpStr=tmpStr_ctuomId_"^" //query.GetDataByName("ANO_Uom_Dr")_"^"
                ...s anoDensity=$p(^DHCANOrder(anoId),"^",13)
                ...s tmpStr=tmpStr_anoDensity_"^" //query.GetDataByName("ANO_Density")_"^"
                ...s anacomId=$p(^DHCANOrder(anoId),"^",14)
                ...s tmpStr=tmpStr_anacomId_"^" //query.GetDataByName("ANO_Compli_Dr")_"^"
                ...s phcinId=$p(^DHCANOrder(anoId),"^",15)
                ...s tmpStr=tmpStr_phcinId_"^" //query.GetDataByName("ANO_Instr_Dr")_"^"
                ...s ancvcId=$p(^DHCANOrder(anoId),"^",16) //query.GetDataByName("ANO_ViewCat_Dr")                  
                ...s ancvcDesc=""
                ...i ancvcId'="" d
                ....s ancvcDesc=$p($g(^DHCANC("ViewCat",ancvcId)),"^",2)
                ....s ancvcCode=$p($g(^DHCANC("ViewCat",ancvcId)),"^",1)
                ...q:OrdCategories'[ancvcCode
                ...s tmpStr=tmpStr_ancvcId_"^"
                ...s anoFlag=$p(^DHCANOrder(anoId),"^",17)
                ...s tmpStr=tmpStr_anoFlag_"^" //query.GetDataByName("ANO_Flag")_"^"
                ...s anoDrugMode=$p(^DHCANOrder(anoId),"^",18)
                ...s tmpStr=tmpStr_anoDrugMode_"^" //query.GetDataByName("ANO_DrugMode")_"^"
                ...s anoSpeed=+$p(^DHCANOrder(anoId),"^",19)
                ...s tmpStr=tmpStr_anoSpeed_"^" //+query.GetDataByName("ANO_Speed")_"^"
                ...s updateDate=$p(^DHCANOrder(anoId),"^",21)
                ...s anoUpdateDate=$ZD($p(^DHCANOrder(anoId),"^",21),3)
                ...s tmpStr=tmpStr_anoUpdateDate_"^" //$ZD(query.GetDataByName("ANO_UpdateDate"),3)_"^"
                ...s updateTime=$p(^DHCANOrder(anoId),"^",22)
                ...s anoUpdateTime=$ZT($p(^DHCANOrder(anoId),"^",22))
                ...s tmpStr=tmpStr_anoUpdateTime_"^" //$ZT(query.GetDataByName("ANO_UpdateTime"))_"^"
                ...s anoReason=$p(^DHCANOrder(anoId),"^",24)
                ...s tmpStr=tmpStr_anoReason_"^" //query.GetDataByName("ANO_Reason")_"^"
                ...s anoEditFlag=$p(^DHCANOrder(anoId),"^",25)
               
                ...;b ;"123"
                ...q:anoEditFlag="D"
                ...q:anoEditFlag="C"
              
                ...s tmpStr=tmpStr_anoEditFlag_"^" //query.GetDataByName("ANO_EditFlag")_"^"
                ...s anoAnoId=$p(^DHCANOrder(anoId),"^",23)
                ...s tmpStr=tmpStr_anoAnoId_"^" //query.GetDataByName("ANO_ANO_DR")_"^"
                ...s anoRecLocId=$p(^DHCANOrder(anoId),"^",26)
                ...s tmpStr=tmpStr_anoRecLocId_"^" //query.GetDataByName("ANO_RecLoc_Dr")_"^"
                ...s anoDocUserId=$p(^DHCANOrder(anoId),"^",27)
                ...s tmpStr=tmpStr_anoDocUserId_"^" //query.GetDataByName("ANO_DocUser_Dr")_"^"
                ...s anoVolume=+$p(^DHCANOrder(anoId),"^",28)
                ...s tmpStr=tmpStr_anoVolume_"^" //+query.GetDataByName("ANO_Volume")_"^"
                ...s anosuId=+$p(^DHCANOrder(anoId),"^",20)
                ...s tmpStr=tmpStr_anosuId_"^" //+query.GetDataByName("ANO_SpeedUnit_Dr")_"^"
                ...s anoSource=$p(^DHCANOrder(anoId),"^",29)
                ...s tmpStr=tmpStr_anoSource_"^" //query.GetDataByName("ANO_Source")_"^"
                ...s anoType=$p(^DHCANOrder(anoId),"^",30)
               
                ...q:anoType'=OrdType
                ...s tmpStr=tmpStr_anoType_"^" //query.GetDataByName("ANO_Type")_"^"
                ...s ancoDesc=$p($g(^DHCANC("ComOrd",+ancoId)),"^",2)
                ...s tmpStr=tmpStr_ancoDesc_"^"  //$p($g(^DHCANC("ComOrd",+query.GetDataByName("ANO_ANCORD_Dr"))),"^",2)_"^"
                ...s arcimDesc=$p($g(^ARCIM(+arcimId,1,1)),"^",2)
                ...s tmpStr=tmpStr_arcimDesc_"^" //$p($g(^ARCIM(+arcimId,1,1)),"^",2)_"^"
                ...s anoQty2=+$p(^DHCANOrder(anoId),"^",31)
                ...s anoQty3=+$p(^DHCANOrder(anoId),"^",32)
                ...s anoSubANOrder=$p(^DHCANOrder(anoId),"^",33)
                ...s anoMainANODr=$p(^DHCANOrder(anoId),"^",34)
                ...s abbreviate=$p(^DHCANOrder(anoId),"^",35)
                ...s anoANPIDr=$p(^DHCANOrder(anoId),"^",36)
                ...i (abbreviate="无创舒张压") d
                ....i (anoQty<1) d
                .....s anoQty=5
                ...i (abbreviate="无创收缩压") d
                ....i (anoQty>220) d
                .....s anoQty=220
                ...Do OutputRow
               
    Set qHandle=$lb(0,repid,0)
    //s ^tmpYpz("queryTime")=^tmpYpz("queryTime")_"/"_$p($h,",",2)
    Quit $$$OK
    
OutputRow

    set Data=$lb(anoId,ancoId,oeoriId,userId,anoStartDate,anoStartTime,anoEndDate,anoEndTime,arcimId,anoNote,anoQty,ctuomId,anoDensity,anacomId,phcinId,ancvcId,anoFlag,anoDrugMode,anoSpeed,anoUpdateDate,anoUpdateTime,anoReason,anoEditFlag,anoAnoId,anoRecLocId,anoDocUserId,anoVolume,anosuId,anoSource,anoType,ancoDesc,arcimDesc,anoQty2,anoQty3,anoSubANOrder,anoMainANODr,abbreviate,anoANPIDr)
    s ^DHCANICUDEBUG("FindANPACUOrders",ind)=Data
    s ^TempLm("FindANPACUOrders",$j,opaId,anoId)=Data
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod FindANPACUOrdersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANPACUOrdersExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
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

ClassMethod FindANPACUOrdersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANPACUOrdersExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// YuanLin
/// 20170912
/// w ##Class(web.DHCANOrder).GetSheetFlag("12||10")
ClassMethod GetSheetFlag(paraItemId)
{
    q:(paraItemId="") ""
    s tempType=""
    &sql(SELECT ANPI_TempType into:tempType FROM sqluser.DHC_AN_ParaItem WHERE ANPI_RowId=:paraItemId)
    q tempType
}

/// add by YuanLin
/// 20171018
/// w ##Class(web.DHCANOrder).InsertOrderItemNew()
ClassMethod InsertOrderItemNew(EpisodeID, mulOeoriStr, userId, locId) As %String
{
    //EpisodeID就诊号, userId用户Id, locId登录科室Id, 
    //mulOeoriStr由$c(3)分割：arcimId医嘱码Id, startDate开始日期, startTime开始时间,recDepId接收科室, 
    //doseQty单次剂量,doseQtySum数量, doseUomId等效剂量单位, instrId用法, seqNo序号, masterSeqNo主医嘱序号,oeoriPrice价格,排班表opaId,医嘱备注depProcNotes
    //其中seqNo序号取自然序号，不是插入后的序号。masterSeqNo值取主医嘱的seqNo序号
    //返回以"^"分割的第一部分为0未成功,错误信息为第二部分。成功则返回类于"1576||1*924106||331*V^1402||1*924106||332*V^"的串
    s ^tempck("InsertOrderItem")=EpisodeID_"*"_mulOeoriStr_"*"_userId_"*"_locId
    //w ##class(web.DHCANOrder).InsertOrderItem(1030551,"",10376,831)
    //s mulOeoriStr="1576||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_250_$c(3)_250_$c(3)_619_$c(3)_12_$c(3)_1_$c(3)_""
    //s mulOeoriStr=mulOeoriStr_"^1402||1"_$c(3)_"2009-7-17"_$c(3)_"18:00"_$c(3)_640_$c(3)_160_$c(3)_160_$c(3)_619_$c(3)_12_$c(3)_2_$c(3)_"1"
    //s mulOeoriStr=  "1575||1"_$c(3)_"2012-4-11"_$c(3)_"17:57"_$c(3)_42_$c(3)_1_$c(3)_1_$c(3)_17_$c(3)_$c(3)_1_$c(3)_$c(3)_1.71_$c(3)_84
    //freqId会不会有变
    
    q:(EpisodeID="")!(mulOeoriStr="")!(userId="")!(locId="") "0^输入数据有误!"
    s LABDATA="LABDATA"
    s docId=$p($g(^SSU("SSUSR",userId)),"^",14)
    q:docId="" "0^请使用医护人员身份登录!"
    
    s orderType="",packQty="",oeprice=0,drugFormId="",depProcNotes="",phPrescType=""
    s masterSeqNo="",skinTest="N",phSpecInstr="",orderCoverMainIns="Y",actionId="",arcosId=""

    s admReasonId=$p(^PAADM(EpisodeID,1),"^",7)

    s defDurId=0
    s phcduId=0
    f  s phcduId=$o(^PHCDU(phcduId)) q:(phcduId="")!(defDurId>0)  d
        .q:$p(^PHCDU(phcduId),"^",2)'=1
        .s defDurId=phcduId
    q:defDurId=0 "0^没有疗程为1天的数据,请维护!" 
    s defFreqId=0,phcfrId=0,isFind=0
    f  s phcfrId=$o(^PHCFR(phcfrId)) q:(phcfrId="")!(isFind)  d
        .q:$p(^PHCFR(phcfrId),"^",2)'=1
        .q:'$d(^PHCFR(phcfrId,"DT",1))
        .s defFreqId=phcfrId
        .i ^PHCFR(phcfrId,"DT",1)=28800 s isFind=1
    //i $o(^PHCFR(0,"Code","QD",""))'="" s defFreqId=$o(^PHCFR(0,"Code","QD",""))
    q:defFreqId=0 "0^没有频次为1数据,请维护!"
    s priorId=$o(^OECPR(0,"Code","NORM",""))   //优先级
    q:+priorId=0 "0^没有临时医嘱优先级数据,请维护!"
     
    /*s Config=##Class(websys.Configuration).%OpenId(1)
    s MEDDATA=Config.DataNamespace
    s CurrentNS=$ZNSPACE
    zn MEDDATA     //转换命名空间
    */
    s retStr=0
    s oeoriStr=""
    f i=1:1:$l(mulOeoriStr,"^") d
        .s singleOeoriStr=$p(mulOeoriStr,"^",i)
        .s arcimId=$p(singleOeoriStr,$c(3),1)
        .i '$d(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)) s retStr="0^医嘱码"_arcimId_"不对!" q
        .s startDate=$p(singleOeoriStr,$c(3),2)
        .s startTime=$p(singleOeoriStr,$c(3),3)
        .
        .s recLocId=$p(singleOeoriStr,$c(3),4)
        .i '$d(^CTLOC(+recLocId)) s recLocId=""
        .i recLocId="" d
            ..s recLocStr=..GetRecLoc(EpisodeID,arcimId)
            ..s recLocId=$p(recLocStr,$c(3),1)
        .i recLocId="" s recLocId=locId
        .s doseQty=$p(singleOeoriStr,$c(3),5)
        .s doseQtySum=+$p(singleOeoriStr,$c(3),6)
        .s doseUomId=$p(singleOeoriStr,$c(3),7)
        .s itemCatId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",10)
        .s orderType=$p($g(^ARC("IC",itemCatId)),"^",7)
        .s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
        .i phcdfId>0 s doseQtySum=##class(web.DHCDocOrderEntry).CalDose(doseUomId,phcdfId,doseQty)
        .i doseQtySum>$p(doseQtySum,".") s doseQtySum=$p(doseQtySum,".")+1
        .s instrId=$p(singleOeoriStr,$c(3),8)
        .s freqId=defFreqId
        .s durId=defDurId
        .s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
        .i phcdfId=-1 s phcdfId=""
        .//i (orderType'="R")  d
        .//.s doseQty="",doseUomId="",phcdfId="",doseQtySum="",freqId=""
        .i phcdfId="" s freqId="",durId=""
        .s seqNo=$p(singleOeoriStr,$c(3),9)
        .s masterSeqNo=$p(singleOeoriStr,$c(3),10)
        .s oeprice=$p(singleOeoriStr,$c(3),11) //ypz 110316
        .s packQty=$p(singleOeoriStr,$c(3),12)  //dyl+20160301
        .s opsId=$p(singleOeoriStr,$c(3),13) //dyl+20160301
        .//s anaId=$p($g(^DHCANOPArrange(+opaId)),"^",2) //ypz 110316
        .s anaId=##class(DHCAN.BLL.AnaSchedule).GetORAnaestID(opsId) //ypz 110316
        .s depProcNotes=$p(singleOeoriStr,$c(3),14) //dyl+20160301
        .
        .s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
        .s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
        .;病人出院时间
        .s patDisCharDate=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
        .;病人出院状态
        .s patOutStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
        .i (patDisCharDate'="")&(patOutStatus="B") s startDate=$p(patDisCharDate,"^",1),startTime=$p(patDisCharDate,"^",2)
        .s startDate=$ZD(startDate,4)
        .s startTime=$ZT(startTime,3)
        .s admId=EpisodeID
        .s oeordId=$o(^OEORD(0,"Adm",admId,""))
        .s orderCoverMainIns=$p($g(^OEORD(oeordId,"I",1,3)),"^",3)  ;20170406+dyl+取医保标志
        .i oeoriStr'="" s oeoriStr=oeoriStr_$c(1)
        .s oeoriStr=oeoriStr_arcimId_"^"_orderType_"^"_priorId_"^"_startDate_"^"_startTime_"^"_packQty_"^"_oeprice_"^"_recLocId_"^"_admReasonId_"^"_drugFormId
        .s oeoriStr=oeoriStr_"^"_depProcNotes_"^"_doseQty_"^"_doseUomId_"^"_doseQtySum_"^"_freqId_"^"_durId_"^"_instrId_"^"_phPrescType_"^"_masterSeqNo_"^"_seqNo
        .s oeoriStr=oeoriStr_"^"_skinTest_"^"_phSpecInstr_"^"_orderCoverMainIns_"^"_actionId_"^"_arcosId_"^^^^^"
        .s oeoriStr=oeoriStr_"^^^^^^^"_anaId
    //s ^TMPCLInsertOrd($j)=1
    //2010
    s retStr=##class(appcom.OEOrdItem).InsertMulti(EpisodeID, oeoriStr, userId, locId, docId)
    s ^tempck("retStr")=retStr
    //P5-P8
    //s retStr=##class(web.DHCANCall).InsertOrderItem(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
    ////s retStr=$$InsertMultiple^DHCDocOrderCommon(EpisodeID, oeoriStr, userId, locId, docId, LABDATA)
    i $p(retStr,"^",1)=-1 s $p(retStr,"^",1,2)=$p(retStr,"^",2)
    //k ^TMPCLInsertOrd($j)
    
    ////zn CurrentNS   //恢复命名空间
    //i retStr'="" d ##class(web.DHCOEOrdItem).UpdateOrderStatus(retStr, EpisodeID, userId)
    q retStr
}

// w ##class(web.DHCANOrder).GetCallectDataByImport(334,"1^2^3^4^5^6^7^8^98")

ClassMethod GetCallectDataByImport(opaId, ancoCodeStr) As %String
{
   s hr="",bp="",SpO2="",temp="",co2="",sys="",dia="",Sev="",rr="",str=""
   f i=1:1:$l(ancoCodeStr,"^") d
   .s ancoId=$p(ancoCodeStr,"^",i)
   .s flag=0,anoId=""
   .f  s anoId=$o(^DHCANOrder(0,"CommOrd",ancoId,opaId,anoId),-1) q:(anoId="")||(flag=1)  d
   ..q:"CD"[$p($g(^DHCANOrder(anoId)),"^",25)
   ..i str'=""  s str=str_"^"
   ..s str=str_ancoId_"@"_$p(^DHCANOrder(anoId),"^",11)
   ..s flag=1
   b
   f i=1:1:$L(str,"^")  d
   .s retstr=$P(str,"^",i)
   .s ancoId=$P(retstr,"@",1)
   .i ancoId=2 s hr=$fn($P(retstr,"@",2),"",0)   ///HR
   .i ancoId=8  s SpO2=$fn($P(retstr,"@",2),"",0) //氧饱和度
   .i ancoId=3  s rr=$fn($P(retstr,"@",2),"",0)  //RR
   .i ancoId=1 s temp=$fn($P(retstr,"@",2),"",0)  //体温
   .i ancoId=10 s co2=$fn($P(retstr,"@",2),"",0)    //CO2
   .i ancoId=185  s Sev=$fn($P(retstr,"@",2),"",0)
   .i (ancoId=4)||(ancoId=6) s sys=$fn($P(retstr,"@",2),"",0)   //收缩压
   .i (ancoId=5)||(ancoId=7) s dia=$fn($P(retstr,"@",2),"",0)   //舒张压
    s bp=sys_"/"_dia
    s str=SpO2_"^"_bp_"^"_hr_"^"_Sev_"^"_rr_"^"_temp_"^"_co2
    q str
}

}

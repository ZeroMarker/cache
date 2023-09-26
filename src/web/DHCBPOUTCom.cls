Import SQLUser

Class web.DHCBPOUTCom Extends %Persistent
{

/// w ##class(web.DHCBPOUTCom).InsertEquipInfo("127.0.0.1^192.168.0.2^951^1000^Mindray")
ClassMethod InsertEquipInfo(EquipInfoStr) As %String
{
    s EquipInfoId=##class(User.DHCBPOUTEquipInfo).%New()
    s EquipInfoId.BPOUTEqInLocalIP=$P(EquipInfoStr,"^",1)
    s EquipInfoId.BPOUTEqInEqIP=$P(EquipInfoStr,"^",2)
    s EquipInfoId.BPOUTEqInEqPort=$P(EquipInfoStr,"^",3)
    s EquipInfoId.BPOBPOUTEqInEqNo=$P(EquipInfoStr,"^",4)
    s EquipInfoId.BPOUTEqInCollCode=$P(EquipInfoStr,"^",5)
    s result=EquipInfoId.%Save()
    q result
}

/// w ##class(web.DHCBPOUTCom).InsertPatDataInfo("10^SYS^65279^50400^110")
ClassMethod InsertPatDataInfo(PatDataInfoStr) As %String
{
    s rowid=""
    s find=0,result=0
    s InsertRegon=$P(PatDataInfoStr,"^",1)
    s InsertData=$P(PatDataInfoStr,"^",3)
    s InsertItem=$P(PatDataInfoStr,"^",2)
    q:(InsertRegon="")||(InsertData="") ""
    f  s rowid=$O(^User.DHCBPOUTPatDataCollectI("Value"," "_InsertRegon,InsertData,rowid)) q:rowid=""  d
    .s Time=$lg(^User.DHCBPOUTPatDataCollectD(rowid),5)
    .s ItemCode=$lg(^User.DHCBPOUTPatDataCollectD(rowid),3)
    .i ((Time=$P(PatDataInfoStr,"^",4))&&(InsertItem=ItemCode)) s find=1
    i find=0  d
    .s PatDataInfoId=##class(User.DHCBPOUTPatDataCollect).%New()
    .s PatDataInfoId.BPOUTPACREGON=$P(PatDataInfoStr,"^",1)
    .s PatDataInfoId.BPOUTPACItem=$P(PatDataInfoStr,"^",2)
    .s PatDataInfoId.BPOUTPACDATE=$P(PatDataInfoStr,"^",3)
    .s PatDataInfoId.BPOUTPACTime=$P(PatDataInfoStr,"^",4)
    .s PatDataInfoId.BPOUTPACValue=$P(PatDataInfoStr,"^",5)
    .s result=PatDataInfoId.%Save()
    q result
}

/// w ##class(web.DHCBPOUTCom).DeleteEquipInfo(7)
ClassMethod DeleteEquipInfo(Id) As %String
{
    q:Id="" ""
    &sql(delete from sqluser.DHC_BP_OUT_EquipInfo where BPOUT_EqIn_RowId=:Id)
    q 0
}

/// w ##class(web.DHCBPOUTCom).ifHaveIP("127.0.0.1","Mindray")
ClassMethod ifHaveIP(LocalIP = "", CollectCode = "", No = "") As %String
{
    s ifHave=0
    q:(LocalIP="")||(CollectCode="") ""
    s rowId=""
    f  s rowId=$O(^User.DHCBPOUTEquipInfoD(rowId)) q:rowId=""  d
    .s LocalIPB=$lg(^User.DHCBPOUTEquipInfoD(rowId),2)
    .s CollectCodeB=$lg(^User.DHCBPOUTEquipInfoD(rowId),6)
    .i (LocalIP=LocalIPB)&&(CollectCode=CollectCodeB)  s ifHave=1
    &sql(select BPOUT_EqIn_RowId into :Id from sqluser.DHC_BP_OUT_EquipInfo where BPOUT_EqIn_EqNo=:No)
	q:+Id>0 2
    q ifHave
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPOUTCom","GetEquipInfo")
Query GetEquipInfo() As %Query(ROWSPEC = "LocalIP:%String,EquipNo:%String,EquipIP:%String,EquipPort:%String,CollectCode:%String,Id:%String")
{
}

ClassMethod GetEquipInfoExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    

    s rowId="" 
    f  s rowId=$O(^User.DHCBPOUTEquipInfoD(rowId)) q:rowId=""  d
    .s LocalIP="",EquipNo="",EquipIP="",EquipPort="",CollectCode="",Id=""
    .s LocalIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),2)
    .s EquipNo=$lg(^User.DHCBPOUTEquipInfoD(rowId),3)
    .s EquipIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),4)
    .s EquipPort=$lg(^User.DHCBPOUTEquipInfoD(rowId),5)
    .s CollectCode=$lg(^User.DHCBPOUTEquipInfoD(rowId),6)
    .s Id=rowId
    .Do OutputEquipInfo   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutputEquipInfo
    set Data=$lb(LocalIP,EquipNo,EquipIP,EquipPort,CollectCode,Id)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetEquipInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipInfoExecute ]
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

ClassMethod GetEquipInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCBPOUTCom).StatDevCollect("192.169.1.117")
ClassMethod StatDevCollect(IP) As %String
{
    q:IP="" ""
    s rowId="",ret=0 
    f  s rowId=$O(^User.DHCBPOUTEquipInfoD(rowId)) q:rowId=""  d
    .s LocalIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),2)
    .q:LocalIP'=IP
    .s ret=ret+1
    .s EquipNo=$lg(^User.DHCBPOUTEquipInfoD(rowId),3)
    .s EquipIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),4)
    .s EquipPort=$lg(^User.DHCBPOUTEquipInfoD(rowId),5)
    .s CollectCode=$lg(^User.DHCBPOUTEquipInfoD(rowId),6)
    .s re=0  ;..StartDevInfo(EquipIP,"127.0.0.1",EquipPort,CollectCode)
     q ret
}

ClassMethod StartDevInfo(equipId As %String, devIP As %String, devPort As %String, interfaceProgram As %String = "OMRON", source As %String = "PE") As %String
{
    s objDeviceServer=##class(web.DHCCLDevSoapInferface).%New() 
    //使用配置的IP
    s mIP=$g(^DHCCLSet("MSrvIP"))
    i mIP'="" d
    .s mIP=$p(mIP,"|",1)
    .s locStr=objDeviceServer.Location
    .s $p(locStr,"/",3)=mIP ;
    .s objDeviceServer.Location=locStr
    s para=""
    s res=objDeviceServer.StartTask(source,equipId,"",devIP,.devPort,"50000",interfaceProgram,"")  
    q res
}

/// w ##class(web.DHCBPOUTCom).getDevInfoByRegNo("C596794","10.56.24.23")
ClassMethod getDevInfoByRegNo(regNo As %String, IP As %String) As %String
{
    q:regNo="" "卡号扫描错误"
    s re=""
    s papmiId=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
    q:papmiId="" "卡号扫描错误"
    ;s papmiId=$p($g(^PAADM(admId)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
    ;s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)    
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    s rowId="",Sys="",Dia="",Height="",Weight="",HR="",SPO2="",PR="",EquipNo=""
    f  s rowId=$O(^User.DHCBPOUTEquipInfoD(rowId)) q:rowId=""  d
    .s LocalIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),2)
    .q:LocalIP'=IP
    .s EquipNo=$lg(^User.DHCBPOUTEquipInfoD(rowId),3)
    .s EquipIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),4)
    .s EquipPort=$lg(^User.DHCBPOUTEquipInfoD(rowId),5)
    .s CollectCode=$lg(^User.DHCBPOUTEquipInfoD(rowId),6)
    .//s re="SYS#2020-06-02#15:55:50#V#70#A#4#4#^DIA#2020-06-02#15:55:50#V#180#A#4#4#^HR#2020-06-02#15:55:50#V#86#A#4#4#"
    .//s re=re_"^Height#2020-06-02#15:55:50#V#86#A#4#4#^Weight#2020-06-02#15:55:50#V#86#A#4#4#^PR#2020-06-02#15:55:50#V#87#A#4#4#"
    .;b ;001
    .;s re=$G(^TMPYGB("InsertANOrder","PE",EquipNo))
    .//s ^dhcbpmfc(regNo,"pre")=EquipNo_"^"_LocalIP_"^"_EquipPort_"^"_CollectCode
    .;s re=##class(web.DHCCLDeviceCollectInterface).GetPEDevInfo(EquipNo,LocalIP,EquipPort,CollectCode)
    .s re=##class(web.DHCCLDeviceCollectInterface).GetPEData(EquipNo)
    .;b ;1000
    .q:re=""
    .//s ^dhcbpmfc(+$h,regNo,EquipNo,IP)=re
    .//k ^TMPYGB("InsertANOrder","PE",EquipNo)
    .
    .s reItemNum=$l(re,"^")
    .;b ;001    
    .f i=1:1:reItemNum  d
    ..;b ;ceshi
    ..s IfInsert="Y"
    ..s ItemCode=$P($P(re,"^",i),"#",1) //采集代码
    ..i ItemCode="HR" s HR=$P($P(re,"^",i),"#",5)
    ..e  i ItemCode="PR" s PR=$P($P(re,"^",i),"#",5) //脉搏
    ..e  i ItemCode="SPO2" s SPO2=$P($P(re,"^",i),"#",5)
    ..e  i ItemCode="Height" s Height=$P($P(re,"^",i),"#",5)
    ..e  i ItemCode="weight" s Weight=$P($P(re,"^",i),"#",5)
    ..e  i ItemCode="SYS" s Sys=$P($P(re,"^",i),"#",5)
    ..e  i ItemCode="DIA" s Dia=$P($P(re,"^",i),"#",5)
    ..e  s IfInsert="N"
    ..i IfInsert="Y"  d
    ...s insertDate=##class(web.DHCClinicCom).ConvertToDateH($P($P(re,"^",i),"#",2))
    ...s insertTime=##class(web.DHCClinicCom).ConvertToTimeH($P($P(re,"^",i),"#",3))
    ...;b ;009
    ...s PatDataInfoStr=regNo_"^"_ItemCode_"^"_insertDate_"^"_insertTime_"^"_$P($P(re,"^",i),"#",5)
    ...s result=..InsertPatDataInfo(PatDataInfoStr)
    i EquipNo'="" s cleanres=##class(web.DHCCLDeviceCollectInterface).cleanPEData(EquipNo)
    s re="Name"_":"_patName_"^"_"Sex"_":"_sex_"^"_"Age"_":"_age_"^"_"Sys"_":"_Sys_"^"_"Dia"_":"_Dia_"^"_"Height"_":"_Height_"^"_"Weight"_":"_Weight_"^"_"HR"_":"_HR_"^"_"SPO2"_":"_SPO2_"^"_"PR"_":"_PR    
    q re
}

ClassMethod InitCollectCodeStr() As %String
{
    q "OmronHBP"
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPOUTCom","GetHisData")
Query GetHisData() As %Query(ROWSPEC = "BPDate:%String,Weight:%String,BP:%String")
{
}

ClassMethod GetHisDataExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    f i=1:1:3  d
    .s BPDate="2020-09-23"
    .s Weight="86"
    .s BP="130/20"
    .Do OutputHistoryData
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    
OutputHistoryData
    set Data=$lb(BPDate,Weight,BP)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetHisDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHisDataExecute ]
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

ClassMethod GetHisDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHisDataExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCBPOUTCom).startAlltask()
ClassMethod startAlltask()
{
	s rowId="",ret=0 
    f  s rowId=$O(^User.DHCBPOUTEquipInfoD(rowId)) q:rowId=""  d
    .s LocalIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),2)
    .s ret=ret+1
    .s EquipNo=$lg(^User.DHCBPOUTEquipInfoD(rowId),3)
    .s EquipIP=$lg(^User.DHCBPOUTEquipInfoD(rowId),4)
    .s EquipPort=$lg(^User.DHCBPOUTEquipInfoD(rowId),5)
    .s CollectCode=$lg(^User.DHCBPOUTEquipInfoD(rowId),6)
    .s re=..StartDevInfo(EquipNo,EquipIP,EquipPort,CollectCode)
     q ret
}

Storage Default
{
<Data name="DHCBPOUTComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBPOUTComD</DataLocation>
<DefaultData>DHCBPOUTComDefaultData</DefaultData>
<IdLocation>^web.DHCBPOUTComD</IdLocation>
<IndexLocation>^web.DHCBPOUTComI</IndexLocation>
<StreamLocation>^web.DHCBPOUTComS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

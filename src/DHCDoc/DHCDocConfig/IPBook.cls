Class DHCDoc.DHCDocConfig.IPBook Extends Common
{

Query QueryOPLoc(HospID = "") As %Query(ROWSPEC = "id,text,alias,InPatLoc,NeedtoDate,NeedtoPre")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.IPBook","QueryOPLoc",2)
ClassMethod QueryOPLocExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Common:QueryLoc")
    d rs.Execute(HospID,"E","O^E^I")
    while rs.Next(){
        s id=rs.GetDataByName("id")
        s text=rs.GetDataByName("text")
        s alias=rs.GetDataByName("alias")
        s InPatLoc=..GetOPLocInLocStr(id)
        s NeedtoDate=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",id,"NeedtoDate",HospID)
        s NeedtoPre=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",id,"NeedtoPre",HospID)
        d rows.%Push($LB(id,text,alias,InPatLoc,NeedtoDate,NeedtoPre))
    }
	Quit $$$OK
}

ClassMethod QueryOPLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOPLocExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod GetOPLocInLocStr(OPLocID)
{
    s LocStr=""
    s HospID=0 for{
        s HospID=$O(^CT("HOSP",HospID)) Q:HospID=""
        s CanCreatBookLocStr=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",OPLocID,"CanCreatBookLocStr",HospID)
        for i=1:1:$L(CanCreatBookLocStr,"^"){
            s LocID=$P(CanCreatBookLocStr,"^",i)
            continue:LocID=""
            s LocDesc=$P(^CTLOC(LocID),"^",2)
            if LocStr="" s LocStr=LocDesc
            else  s LocStr=LocStr_"; "_LocDesc
        }
    }
    Q LocStr
}

ClassMethod GetOPLocInLocIDStr(OPLocID)
{
    s LocStr=""
    s HospID=0 for{
        s HospID=$O(^CT("HOSP",HospID)) Q:HospID=""
        s CanCreatBookLocStr=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",OPLocID,"CanCreatBookLocStr",HospID)
        for i=1:1:$L(CanCreatBookLocStr,"^"){
            s LocID=$P(CanCreatBookLocStr,"^",i)
            continue:LocID=""
            if LocStr="" s LocStr=LocID
            else  s LocStr=LocStr_"^"_LocID
        }
    }
    Q LocStr
}

/// w ##class(DHCDoc.DHCDocConfig.IPBook).SaveOPLocCfgData(^Wqy("SaveOPLocCfgData"),2)
ClassMethod SaveOPLocCfgData(InputStr, HospID = "")
{
    ;s ^Wqy("SaveOPLocCfgData")=InputStr
    s rows=##class(%DynamicArray).%FromJSON(InputStr)
    for i=1:1:rows.%Size(){
        s row=rows.%Get(i-1)
        s LocID=row.id
        continue:LocID=""
        d ##class(web.DHCDocConfig).SetConfigNode3("IPBBook",LocID,"NeedtoDate",HospID,row.NeedtoDate)
        d ##class(web.DHCDocConfig).SetConfigNode3("IPBBook",LocID,"NeedtoPre",HospID,row.NeedtoPre)
    }
    Q 0
}

Query QueryLocInLoc(LocID, HospID = "") As %Query(ROWSPEC = "id,text,alias,CanCreatBook:%Boolean,DefCreatBookLoc:%Boolean")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.IPBook","QueryLocInLoc",39,2)
ClassMethod QueryLocInLocExecute(ByRef qHandle As %Binary, LocID, HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
    s CanCreatBookLocStr="^"_##class(web.DHCDocConfig).GetConfigNode3("IPBBook",LocID,"CanCreatBookLocStr",HospID)_"^"
    s DefCreatBookLocID=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",LocID,"DefCreatBookLocID",HospID)
	s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Common:QueryLoc")
    d rs.Execute(HospID,"E","I")
    while rs.Next(){
        s id=rs.GetDataByName("id")
        s text=rs.GetDataByName("text")
        s alias=rs.GetDataByName("alias")
        s CanCreatBook=CanCreatBookLocStr[("^"_id_"^")
        s DefCreatBookLoc=DefCreatBookLocID=id
        d rows.%Push($LB(id,text,alias,CanCreatBook,DefCreatBookLoc))
    }
	Quit $$$OK
}

ClassMethod QueryLocInLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocInLocExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryInLocHosp(LocID = "") As %Query(ROWSPEC = "id,text,selected:%Boolean")
{
}

/// 获取门诊科室可开院区,本院如果没授权 全部显示,分院没授权则不显示
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.IPBook","QueryInLocHosp",2)
ClassMethod QueryInLocHospExecute(ByRef qHandle As %Binary, LocID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
    s LocHospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LocID)
    s HospID=0 for{
        s HospID=$O(^CT("HOSP",HospID)) Q:HospID=""
        if LocHospID'=HospID{
            s CanCreatBookLocStr=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",LocID,"CanCreatBookLocStr",HospID)
            continue:CanCreatBookLocStr=""
        }
        s HospName=$P(^CT("HOSP",HospID),"^",2)
        d rows.%Push($LB(HospID,HospName,LocHospID=HospID))
    }
	Quit $$$OK
}

ClassMethod QueryInLocHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInLocHospExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryInLoc(OPLocID = "", InHospID = "") As %Query(ROWSPEC = "id,text,alias,selected:%Boolean")
{
}

/// 获取门诊科室可开院区,本院如果没授权 全部显示,分院没授权则不显示
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.IPBook","QueryInLoc",2)
ClassMethod QueryInLocExecute(ByRef qHandle As %Binary, OPLocID = "", InHospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
    s LocHospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(OPLocID)
    s CanCreatBookLocStr=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",OPLocID,"CanCreatBookLocStr",InHospID)
    Q:(CanCreatBookLocStr="")&&(InHospID'=LocHospID) $$$OK
    s DefCreatBookLocID=##class(web.DHCDocConfig).GetConfigNode3("IPBBook",OPLocID,"DefCreatBookLocID",InHospID)
    s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.Common:QueryLoc")
    d rs.Execute(InHospID,"E","I")
    while rs.Next(){
        s id=rs.GetDataByName("id")
        continue:(CanCreatBookLocStr'="")&&(("^"_CanCreatBookLocStr_"^")'[("^"_id_"^"))
        s text=rs.GetDataByName("text")
        s alias=rs.GetDataByName("alias")
        s selected=((DefCreatBookLocID="")&&('rows.%Size()))||(DefCreatBookLocID=id)
        d rows.%Push($LB(id,text,alias,selected))
    }
	Quit $$$OK
}

ClassMethod QueryInLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInLocExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod GetDepConfigData(Code, HospID = "")
{
    s LocIDStr=""
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s rs=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.IPBook:QueryOPLoc")
    d rs.Execute(HospID)
    while rs.Next(){
        if rs.GetDataByName(Code)="Y"{
            s LocID=rs.GetDataByName("id")
            i LocIDStr="" s LocIDStr=LocID
            e  s LocIDStr=LocIDStr_"^"_LocID
        }
    }
    Q LocIDStr
}

}

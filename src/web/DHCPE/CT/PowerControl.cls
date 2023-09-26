/// 名称: 表记录授权查询
/// 编写者：xy
/// 编写日期: 2021-08-18
Class web.DHCPE.CT.PowerControl Extends %RegisteredObject
{

/// Creator：    xy 
/// CreatDate：  20210818
/// Description: 查询表记录授权表
/// Table：      表记录授权表  DHC_PE_PowerControl
/// Input:       TabName:表名, ClsName:类名, Empower:单独授权, EffPower:有效授权
/// Return：
/// debug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.PowerControl","FindPowerControlList","1","DHC_PE_StationOrder","","N","Y")
Query FindPowerControlList(LocID As %String = "", TabName As %String = "", ClsName As %String = "", Empower As %String = "", EffPower As %String = "Y") As websys.Query(ROWSPEC = "TID,TRecordID,TPowerTypeDesc,TTableCode,TTableDesc,TEmpower,TLocGrpDesc,TEffPower,TLocDesc,TUpdateDate,TUpdateTime,TUserName")
{
}

ClassMethod FindPowerControlListExecute(ByRef qHandle As %Binary, LocID As %String = "", TabName As %String = "", ClsName As %String = "", Empower As %String = "", EffPower As %String = "Y") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    s ^tempdhcpe("FindPowerControlList")=$lb(LocID,TabName,ClsName,Empower,EffPower)
    i (((TabName="")&&(ClsName=""))){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
    }
    i ClsName'="" s TabName=ClsName
    s LocGrpID=##class(web.DHCPE.CT.DHCPEMappingLoc).GetLocGrpByLocID(LocID)
    q:LocGrpID="" $$$OK
    s objPowerType=##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeObj(TabName)
    q:'$IsObject(objPowerType) $$$OK
    s PowerType=objPowerType.PTPowerType
    S PowerTypeDesc=##class(web.DHCPE.CT.DHCPEMappingLoc).GetPowerTypeDesc(PowerType)
    s TableListDR=objPowerType.%Id()
    s TableCode=objPowerType.PTTabCode
    s TableDesc=objPowerType.PTTabDesc
   
    i (PowerType="G"){
	   
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	    
    }elseif(PowerType="S"){
	    s tRecordID=0
	    for {
	    	s tRecordID=$o(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,tRecordID))
	    	q:tRecordID=""
	    	
	    	s EID=""
		    for{
			    s EID=$O(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,tRecordID,LocID,EffPower,EID))
		        q:EID=""
		        d GetPowerControlList 
		    }   
		    		 
	    	s ID=""
	    	for{
		    	s ID=$O(^CF.PE.PowerControlI("IdxOfLocGrpPower",TableListDR,tRecordID,LocGrpID,EffPower,"N",ID))
		    	q:ID=""  
		    	d GetPowerControlList 
		       
	    	}	
	    	
	    }
	    
    }else{
	    s tRecordID=0
	    for {
		    s tRecordID=$o(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,tRecordID))
		    q:tRecordID=""
		    s ID=""
		    for{
			    s ID=$O(^CF.PE.PowerControlI("IdxOfLocPower",TableListDR,tRecordID,LocID,EffPower,ID))
		        q:ID=""
		        d GetPowerControlList 
		    }   
	    }    
    }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK   
GetPowerControlList
        q:ID=""
        s RecordID=$lg($g(^CF.PE.PowerControlD(ID)),3)
    	s TLocGrpID=$lg($g(^CF.PE.PowerControlD(ID)),4)
    	s:TLocGrpID'="" TLocGrpDesc=$p($g(^CTLOC(TLocGrpID)),"^",2)
	    s TEmpower=$lg($g(^CF.PE.PowerControlD(ID)),5)
	    s TLocID=$lg($g(^CF.PE.PowerControlD(ID)),6)
	    s:TLocID'="" TLocDesc=$p($g(^CTLOC(TLocID)),"^",2)
	    s TEffPower=$lg($g(^CF.PE.PowerControlD(ID)),7)
	    s TUpdateDate=$lg($g(^CF.PE.PowerControlD(ID)),8)
        i TUpdateDate'="" s TUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TUpdateDate)
        s TUpdateTime=$lg($g(^CF.PE.PowerControlD(ID)),9)
        i TUpdateTime'="" s TUpdateTime=##class(websys.Conversions).TimeLogicalToHtml(TUpdateTime)
        s TUserDR=$lg($g(^CF.PE.PowerControlD(ID)),10)
        i TUserDR'="" s TUserName=$p($g(^SSU("SSUSR",TUserDR)),"^",2)
        
        d FindBuild 
 		q
FindBuild 
	set Data=$lb(ID,RecordID,PowerTypeDesc,TableCode,TableDesc,TEmpower,TLocGrpDesc,TEffPower,TLocDesc,TUpdateDate,TUpdateTime,TUserName) 
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}

/// Function:医为内部效益分析数据接口
/// CreateDate:2022-11-21
/// Creator: sunfengchao 
Class web.DHCBL.CT.EQDataView Extends %RegisteredObject
{

/// Function:  HIS服务项目（EQ_SERVICE_VIEW）
/// Table:     ARC_ItmMast
/// CreateDate:2022-11-21
/// Creator:   sunfengchao 
///            CALL web_DHCBL_CT.EQDataView_EQSERVICEVIEW()
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.EQDataView","EQSERVICEVIEW")
Query EQSERVICEVIEW(hospid As %String = "") As %Query(ROWSPEC = "D_DEVICETYPE,SER_CODE,SER_NAME,UNIT_NAME,PRICE,INVALID_FLAG,REMARK") [ SqlProc ]
{
}

ClassMethod EQSERVICEVIEWExecute(ByRef qHandle As %Binary, hospid As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1   
    s DDEVICETYPE ="DHC-HIS" // 系统类型 
    s ARCIMSubscript=0
    for
    {
        s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
        s ARCIMVersion=0
        for 
        {
            s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion)) q:(ARCIMVersion="")
            s ARCIMRowId=ARCIMSubscript_"||"_ARCIMVersion
                  
            if hospid'=""
            {
               s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowId,hospid)
               continue:showflag="N"
            }
    
            s ARCIMCODE =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)   // 医嘱代码 服务项ID
            s SERNAME =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)  //  服务项目名称   
            s ARCIMBILLINGUOMDR= $p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",14)     // 计量单位
            s:ARCIMBILLINGUOMDR'="" ARCIMBILLINGUOMDR=$p($g(^CT("UOM",ARCIMBILLINGUOMDR)),"^",2)  
            s aricmprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowId,+$h,"","","","",3) 
			s OrderPrice=$p(aricmprice,"^",1)  ///服务项目单价  PRICE 
			if $e(OrderPrice,1,1)="." s OrderPrice="0"_OrderPrice
	
            s ARCIMEffDate=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",13)      ;开始日期
            s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,"Z",1)
            s:ARCIMEffDate'="" ARCIMEffDate=$p(ARCIMEffDate,",",1)
            s ARCIMEffDateTo=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,7)),"^",1)       ;结束日期 
            if (ARCIMEffDate>+$H)||((ARCIMEffDateTo'="")&&(ARCIMEffDateTo<+$H)) s INVALIDFLAG =1  //无效标识
            else  s INVALIDFLAG=0 
            s REMARK=$g(^ARCIM(ARCIMSubscript,ARCIMVersion,"OEM",1))     ; 医嘱备注  备注  
            s REMARK=##class(web.DHCBL.BDP.FunLib).Util(REMARK)  
            d EQSERVICEVIEW        
        } 
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
EQSERVICEVIEW 
    set ^CacheTemp(repid,ind)=$lb(DDEVICETYPE,ARCIMCODE,SERNAME,ARCIMBILLINGUOMDR,OrderPrice,INVALIDFLAG,REMARK)
    Set ind=ind+1
    quit
}

ClassMethod EQSERVICEVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQSERVICEVIEWExecute ]
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

ClassMethod EQSERVICEVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQSERVICEVIEWExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/*

ClassMethod EQCHARGEITEMVIEWExecute(ByRef qHandle As %Binary, hospid As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1  
    
    s TARIRowId=0
    for
    {
       s TARIRowId=$o(^DHCTARI(TARIRowId)) 
       q:TARIRowId="" 
        
       
       s SERCODE ="DHC-HIS" // 服务项编码   
       s CHARGECODE =$p($g(^DHCTARI(TARIRowId)),"^",1)  // 收费项编码 
       s CHARGEDESC =$p($g(^DHCTARI(TARIRowId)),"^",2) // 收费项描述  
       s CHARGECATEID= $p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项类型   收费项目子类 
       s CHARGECATEDESC=""  //收费项类型
       s:CHARGECATEID'="" CHARGECATEDESC=$p($g(^DHCTarC("SC",CHARGECATEID)),"^",2) 
       s SFDW=$p($g(^DHCTARI(TARIRowId)),"^",3)        // 单位
       s UNITCODE=""  // 计量编码
       s:SFDW'="" UNITCODE=$p($g(^CT("UOM",SFDW)),"^",1)  
       s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.UDHCJFPRICE||GetItmPrice")
       if $IsObject(myobj)
       {
            s Params=myobj.FormalSpec
            if ($zcvt(Params,"U")["HOSPID")
            {   
                 s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(TARIRowId,+$h,"","","",3)
            }
            else
            {
                 s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(TARIRowId,+$h,"","","")
            }
        }  
       s TariPrice=$p(priceinfo,"^",1)
       s PRICE=$fn(TariPrice,"N") // 收费单价 
       s DrugFlag="" // 药品标志   0否 1是 
       if CHARGECATEDESC["药" s DrugFlag=1 //药品
       else  s DrugFlag=0
       s TARIStartDate =$p($g(^DHCTARI(TARIRowId)),"^",11) ///开始日期
       s TARIEndDate = $p($g(^DHCTARI(TARIRowId)),"^",12)
       s TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
       s INVALIDFLAG=0 //   无效标志      
       if ((TARIStartDate>+$H)||((TARIEndDate'="")&(TARIEndDate<+$H))||(TARIActiveFlag="N")) 
       {
            s INVALIDFLAG=1 //使用标志   1.停用;  0.使用中
       }   
       s UPDATEDATEDATE=$zd(+$H,3) //更新日期           
       s UPDATETIMETIME =$zt($p($h,",",2),1)  // 更新时间    
       if $d(%session) s UPDATEUSERDR=$g(%session.Data("LOGON.USERNAME"))
       else  s UPDATEUSERDR=""  //更新人 
       s REMARK =$p($g(^DHCTARI(TARIRowId)),"^",33) //备注 
       d EQCHARGEITEOutputRow       
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
EQCHARGEITEOutputRow 
    set ^CacheTemp(repid,ind)=$lb(SERCODE,CHARGECODE,CHARGEDESC,CHARGECATEID,CHARGECATEDESC,UNITCODE,PRICE,DrugFlag,UPDATEDATEDATE,UPDATETIMETIME,UPDATEUSERDR,INVALIDFLAG,REMARK) 
    Set ind=ind+1
    quit
}

*/
/// Function:  医嘱项关联收费项目（EQ_CHARGE_ITEM_VIEW）
/// Table:     DHC_TarItem 
/// CreateDate:2022-11-21
/// Creator:   sunfengchao 
/// Table:     EQ_CHARGE_ITEM_VIEW
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.EQDataView","EQCHARGEITEMVIEW")
/// Others:    CALL web_DHCBL_CT.EQDataView_EQCHARGEITEMVIEW()  
Query EQCHARGEITEMVIEW() As %Query(ROWSPEC = "SER_CODE,CHARGE_CODE,CHARGE_DESC,CHARGE_CATE_ID,CHARGE_CATE_DESC,UNIT_CODE,PRICE,DrugFlag,UPDATE_DATE,UPDATE_TIME,UPDATE_USERDR,INVALID_FLAG,REMARK") [ SqlProc ]
{
}

ClassMethod EQCHARGEITEMVIEWExecute(ByRef qHandle As %Binary) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    s arcimrowid=0
    for
    {
        s arcimrowid=$O(^DHCOLT(0,"ARTTA",arcimrowid)) q:arcimrowid="" 
        s ARCIMSubscript=$p(arcimrowid,"||",1)
   		s ARCIMVersion=$p(arcimrowid,"||",2)
        s SERCODE =$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)   // 服务项编码 
        s SERCODE=##class(web.DHCBL.BDP.FunLib).Utilstring(SERCODE)  
        continue:SERCODE=""
        
        s olttariffdr=0
        for
        {
            s olttariffdr=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr)) q:olttariffdr="" 
            s TARIRowId=olttariffdr
			s CHARGECODE =$p($g(^DHCTARI(TARIRowId)),"^",1)  // 收费项编码 
			s CHARGECODE=##class(web.DHCBL.BDP.FunLib).Utilstring(CHARGECODE)  
		    continue:CHARGECODE=""
				     
            s startdate=0
            for
            {
                s startdate=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate)) q:startdate=""
                s associaterowid=0
                for
                {
                    s associaterowid=$o(^DHCOLT(0,"ARTTA",arcimrowid,olttariffdr,startdate,associaterowid)) q:associaterowid="" 
                    s tarDateTo=$p($g(^DHCOLT(associaterowid)),"^",5)
                    if ((tarDateTo'="")&&(tarDateTo<+$h)) continue  // 过滤有结束日期的数据
                    
				   s CHARGEDESC =$p($g(^DHCTARI(TARIRowId)),"^",2) // 收费项描述 
				   s CHARGEDESC=##class(web.DHCBL.BDP.FunLib).Utilstring(CHARGEDESC)  
				   s CHARGECATEID= $p($g(^DHCTARI(TARIRowId)),"^",4) ///收费项类型   收费项目子类 
				   s CHARGECATEDESC=""  //收费项类型
				   s:CHARGECATEID'="" CHARGECATEDESC=$p($g(^DHCTarC("SC",CHARGECATEID)),"^",2) 
				   s SFDW=$p($g(^DHCTARI(TARIRowId)),"^",3)        // 单位
				   s UNITCODE=""  // 计量编码
				   s:SFDW'="" UNITCODE=$p($g(^CT("UOM",SFDW)),"^",1)  
				   s myobj=##class(%Dictionary.CompiledMethod).%OpenId("web.UDHCJFPRICE||GetItmPrice")
				   if $IsObject(myobj)
				   {
				        s Params=myobj.FormalSpec
				        if ($zcvt(Params,"U")["HOSPID")
				        {   
				             s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(TARIRowId,+$h,"","","",3)
				        }
				        else
				        {
				             s priceinfo=##class(web.UDHCJFPRICE).GetItmPrice(TARIRowId,+$h,"","","")
				        }
				    }  
				   s TariPrice=$p(priceinfo,"^",1)
				   s PRICE=$fn(TariPrice,"N") // 收费单价 
				   s DrugFlag="" // 药品标志   0否 1是 
				   if CHARGECATEDESC["药" s DrugFlag=1 //药品
				   else  s DrugFlag=0
				   s TARIStartDate =$p($g(^DHCTARI(TARIRowId)),"^",11) ///开始日期
				   s TARIEndDate = $p($g(^DHCTARI(TARIRowId)),"^",12)
				   s TARIActiveFlag=$p($g(^DHCTARI(TARIRowId)),"^",7)
				   s INVALIDFLAG=0 //   无效标志      
				   if ((TARIStartDate>+$H)||((TARIEndDate'="")&(TARIEndDate<+$H))||(TARIActiveFlag="N")) 
				   {
				        s INVALIDFLAG=1 //使用标志   1.停用;  0.使用中
				   }   
				   s UPDATEDATEDATE=$zd(+$H,3) //更新日期           
				   s UPDATETIMETIME =$zt($p($h,",",2),1)  // 更新时间    
				   if $d(%session) s UPDATEUSERDR=$g(%session.Data("LOGON.USERNAME"))
				   else  s UPDATEUSERDR=""  //更新人 
				   s REMARK =$p($g(^DHCTARI(TARIRowId)),"^",33) //备注 
                   d OutputRowA  
                }
            }
        } 
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowA    
    set Data=$lb(SERCODE,CHARGECODE,CHARGEDESC,CHARGECATEID,CHARGECATEDESC,UNITCODE,PRICE,DrugFlag,UPDATEDATEDATE,UPDATETIMETIME,UPDATEUSERDR,INVALIDFLAG,REMARK)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod EQCHARGEITEMVIEWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQCHARGEITEMVIEWExecute ]
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

ClassMethod EQCHARGEITEMVIEWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQCHARGEITEMVIEWExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}

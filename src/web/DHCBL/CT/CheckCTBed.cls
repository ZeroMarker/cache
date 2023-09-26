Import SQLUser

/// 名称:科室/病区 - 全院床位查询	
/// 描述:包含查询功能
/// 编写者:基础平台组 -谷雪萍
/// 编写日期:2015-7-2
/// 修改日期:2015-7-2
Class web.DHCBL.CT.CheckCTBed Extends %RegisteredObject [ ProcedureBlock ]
{

/// Description：查询病区床位的内容
/// Table：User.PACBed
/// Input：rowid,code,desc
/// D ##class(%ResultSet).RunQuery("web.DHCBL.CT.CheckCTBed","GetList","5","","","","Y")
Query GetList(code As %String, loc As %String, type As %String, room As %String, using As %String) As %Query(ROWSPEC = "BEDRowID,PAWARDDesc,IfUsing,price,BEDRoomDesc,BEDCode,BEDBedTypeDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, code As %String, loc As %String, type As %String, room As %String, using As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:code'="" code=$ZCONVERT(code,"U")
    s price=""
    s HOSPtalID=%session.Get("LOGON.HOSPID")
    s paramnum=##class(web.DHCBL.CT.ARCItmMast).GetCMInParaNum("web.UDHCJFPRICE","GetOrderPrice")
		s ParRef=0
		for{
			s ParRef=$o(^PAWARD(ParRef)) q:ParRef=""
			s rowid=0
			for
			{
				s rowid=$o(^PAWARD(ParRef,"BED",rowid)) q:rowid=""
				s BEDRowID=ParRef_"||"_rowid
				
				s PAWARDDesc=$p(^PAWARD(ParRef),"^",2)   //病区
				s IfUsing=##class(web.DHCBL.CT.PACBed).IfCanDelete(BEDRowID)  //是否在用
				s:IfUsing=1 IfUsing="Y"
				s:IfUsing=0 IfUsing="N"

				s BEDCode=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",1)     //床代码
				s BEDBedTypeDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",2)     //床类型id
				s:BEDBedTypeDR'="" BEDTPBedTypeCodeDR=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",4) //医嘱项
				s:BEDBedTypeDR="" BEDTPBedTypeCodeDR="" 
				if (BEDTPBedTypeCodeDR'="")
				{
					
					if (paramnum=10)
				  	{
				  		s priceStr=##class(web.UDHCJFPRICE).GetOrderPrice("","",BEDTPBedTypeCodeDR,+$h,"","","","",HOSPtalID,"")
				  	}
				 	 elseif (paramnum=8)
				  	{
				  		s priceStr=##class(web.UDHCJFPRICE).GetOrderPrice("","",BEDTPBedTypeCodeDR,+$h,"","","","")
				  	}
				}
				else
				{
					s priceStr=""
				}

				s price=$p(priceStr,"^",1) //目前金额
				s:BEDBedTypeDR'="" BEDBedTypeDesc=$p($g(^PAC("BEDTP",BEDBedTypeDR)),"^",2)	//床类型描述
				s:BEDBedTypeDR="" BEDBedTypeDesc=""		
				s BEDRoomDR=$p($g(^PAWARD(ParRef,"BED",rowid)),"^",3)    //房间id
				s:BEDRoomDR'="" BEDRoomDesc=$p($g(^PAROOM(BEDRoomDR)),"^",2)  //房间描述
				s:BEDRoomDR="" BEDRoomDesc=""
			
				if ($ZCVT(BEDCode,"u")[code)&((BEDBedTypeDR=type)||(type=""))&((BEDRoomDR=room)||(room=""))&((IfUsing=using)||(using=""))&((ParRef=loc)||(loc=""))
				{
					d OutputRow
				}
				
			}
		}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(BEDRowID,PAWARDDesc,IfUsing,price,BEDRoomDesc,BEDCode,BEDBedTypeDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

/// Function:进行数据检索，为combo查询提供接口
/// CreateDate:2015-7-2
/// Creator:基础数据平台公共产品组  谷雪萍
/// Table:PAC_Ward
/// Input: desc, code 
/// Output:   
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CheckCTBed", "GetDataForCmbl","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "WARDRowId,WARDCode,WARDDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.PACWARDype).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s WARDRowId=rowid
		s WARDCode=$p($g(^PAWARD(WARDRowId)),"^",1)
		s WARDDesc=$p($g(^PAWARD(WARDRowId)),"^",2)
		d OutputRow2
	}
	else
	{
		//s AuFlag=0
		//if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
		s:code'="" code=$ZCONVERT(code,"U")
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s WARDRowId=0
		for  
		{	
			s WARDRowId=$o(^PAWARD(WARDRowId)) q:WARDRowId=""
			//s strRowId = "{ID:"_WARDRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s WARDCode=$p($g(^PAWARD(WARDRowId)),"^",1)
				s WARDDesc=$p($g(^PAWARD(WARDRowId)),"^",2)
				i ($ZCONVERT(WARDCode,"U")[code)&($ZCONVERT(WARDDesc,"U")[desc)
				{
					d OutputRow2
				}
			//}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
    set Data=$lb(WARDRowId,WARDCode,WARDDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

}

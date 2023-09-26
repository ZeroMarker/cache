Class web.DHCANCOrc Extends %RegisteredObject
{

Query FindOrcOperation(operCategId As %String = "", operDesc As %String = "") As %Query(ROWSPEC = "tOperId:%String,tOperDesc:%String,tOperCode:%String,tAncoplId:%String,tAncoplDesc:%String,tBldtpId:%String,tBldtpDesc:%String,tBodsId:%String,tBodsDesc:%String,tOperPositionId:%String,tOperPositionDesc:%String,tAddName:%String,tAddDateTime:%String,tOperCategDesc:%String,tOperCategId:%String,tOpType:%String,tOpTypeCode:%String")
{
}

ClassMethod FindOrcOperationExecute(ByRef qHandle As %Binary, operCategId As %String = "", operDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s dateformatnum=##class(websys.Conversions).DateFormat()
	s tOperId=0,i=0
    if (operDesc'="")
    {
		s operDescAlias=$$ALPHAUP^SSUTIL4(operDesc)
		s flag="N"
		s curOperDesc=$O(^ORC("OPER",0,"ALIAS",operDescAlias),-1)
	    if operDescAlias'="" d
	    	.f  s curOperDesc=$O(^ORC("OPER",0,"ALIAS",curOperDesc)) q:(curOperDesc="")!(flag="Y")  d
	    		..i $p(curOperDesc,operDescAlias)'="" s flag="Y" q
	    		..s tOperId=""
	    		..f  s tOperId=$O(^ORC("OPER",0,"ALIAS",curOperDesc,tOperId)) q:tOperId=""  d
	    			...s tOperDesc=$p(^ORC("OPER",tOperId),"^",2)
	    			...s tOperCode=$p(^ORC("OPER",tOperId),"^",1)
	    			...s tOperCategId=$p(^ORC("OPER",tOperId),"^",7)
	    			...q:(operCategId'="")&(operCategId'=tOperCategId)
	    			...s i=i+1
	    			...d SetData
    }
    if i>0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	f  s tOperId=$o(^ORC("OPER",tOperId)) q:tOperId=""  d
		.s tOperDesc=$p(^ORC("OPER",tOperId),"^",2)
		.q:(operDesc'="")&(tOperDesc'[operDesc)
		.s tOperCode=$p(^ORC("OPER",tOperId),"^",1)
		.s tOperCategId=$p(^ORC("OPER",tOperId),"^",7)
		.;q:(operCategId'="")&(operCategId'=tOperCategId)
	 	.d SetData	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetData
	s tAncoplId=$p($g(^ORC("OPER",tOperId,"DHC")),"^",1)
	s tAncoplDesc=$p($g(^DHCANC("OPLevel",+tAncoplId)),"^",2)
    s tBldtpId=$p($g(^ORC("OPER",tOperId,"DHC")),"^",2)
	s tBldtpDesc=$p($g(^ORC("BLDTP",+tBldtpId)),"^",2)				;ORC_BladeType
	s tBodsId=$p($g(^ORC("OPER",tOperId,"DHC")),"^",3)
	s tBodsDesc=$p($g(^OEC("BODS",+tBodsId)),"^",2)
	s tOperPositionId=$p($g(^ORC("OPER",tOperId,"DHC")),"^",4)
	s tOpType=""
	s tOpTypeCode=$p($g(^ORC("OPER",tOperId,"DHC")),"^",11)
	i tOpTypeCode="T" s tOpType="治疗性操作"
	i tOpTypeCode="D" s tOpType="诊断性操作"
	i tOpTypeCode="N" s tOpType="手术"
	s tOperPositionDesc=$P($G(^ORC("OPPOS",+tOperPositionId)),"^",2)
	s tOperCategDesc=$p($g(^ORC("CATEG",+tOperCategId)),"^",2)
	s tAddName=$p($g(^ORC("OPER",tOperId,"DHC","ADD")),"^",1)
	s tAddDate=$p($g(^ORC("OPER",tOperId,"DHC","ADD")),"^",2)
	s tAddTime=$p($g(^ORC("OPER",tOperId,"DHC","ADD")),"^",3)
	
	i (tAddDate'="")&(tAddTime'="") s tAddDateTime=$ZD(tAddDate,dateformatnum)_" "_$ZT(tAddTime,2)
	e  s tAddDateTime=""
    Do OutputRow1
    q

OutputRow1
	set Data=$lb(tOperId,tOperDesc,tOperCode,tAncoplId,tAncoplDesc,tBldtpId,tBldtpDesc,tBodsId,tBodsDesc,tOperPositionId,tOperPositionDesc,tAddName,tAddDateTime,tOperCategDesc,tOperCategId,tOpType,tOpTypeCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrcOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcOperationExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrcOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 20150316+dyl+修改手术，能改其他信息，但是不能改名称和代码，如果需要维护，需要到基础数据维护中修改

ClassMethod SaveDHCOrcOperation(operId, dhcOrcOperStr, OperCateDr, opType) As %String
{
	i OperCateDr'="" s $p(^ORC("OPER",operId),"^",7)=OperCateDr
	s ^ORC("OPER",operId,"DHC")=dhcOrcOperStr
	i opType'="" s $p(^ORC("OPER",operId,"DHC"),"^",11)=opType
	q 0
}

ClassMethod DeleteDHCOrcOperation(operId) As %String
{
	i operId'=""  d
	.&SQL(delete from sqluser.ORC_Operation where %ID=:operId)
	q SQLCODE
}

Query FindORCOperationCategory() As %SQLQuery(CONTAINID = 1, ROWSPEC = "operCategId:%Integer,operCategLDesc:%String")
{
    select CATEG_RowId,CATEG_Desc from SQLUser.ORC_OperationCategory
}

Query FindAncAppDate() As %Query(ROWSPEC = "appdate:%String,week:%String,status:%String")
{
}

ClassMethod FindAncAppDateExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s dateformatnum=##class(websys.Conversions).DateFormat()
	s id=""
	f  s id=$o(^DHCANCAPPDATE(id)) q:id=""  d
	    .s week="",status=""
	    .s appdate=$zd(id,dateformatnum)
	    .s day=$zd(id,10)
        .i (day=0)!(day=6) d
	    ..s status="上班"
	    .e  d
	    ..s status="休息"
	    .i day=0 d
	    ..s week="周日"
	    .i day=1 d
	    ..s week="周一"
	    .i day=2 d
	    ..s week="周二"
	    .i day=3 d
	    ..s week="周三"
	    .i day=4 d
	    ..s week="周四"
	    .i day=5 d
	    ..s week="周五"
	    .i day=6 d
	    ..s week="周六"
		.Do OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(appdate,week,status)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindAncAppDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncAppDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAncAppDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncAppDateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InsertAncAppDate(SetStr As %String)
{
	//手术申请对应医嘱项
	q:SetStr="" -1
	
	s SetStr=##class(web.DHCANOPCom).ConvertToDateH(SetStr,"")
	s ^DHCANCAPPDATE(SetStr)=""
	
	q 0
}

ClassMethod DeleAncAppDate(id As %String)
{
	//手术申请对应医嘱项
	s id=##class(web.DHCANOPCom).ConvertToDateH(id,"")
	k ^DHCANCAPPDATE(id)
	
	q 0
}

// 20150316+dyl

ClassMethod AddDHCOrcOperation(operDesc As %String, opercode As %String, dhcOrcOperStr As %String, OperCateDr As %String, opType As %String) As %String
{
	s ret=0
	q:operDesc="" "手术名称不能为空!"
	//q:operAlias="" "手术别名不能为空!"
	s oprowid=0 f  s oprowid=$o(^ORC("OPER",oprowid)) q:oprowid=""  d
	.s tOperDesc=$p(^ORC("OPER",oprowid),"^",2)
	.i (tOperDesc=operDesc)  d
	..s ret=1
	i ret=1 q "手术名称重复!"
	

	s fromdate=(+$h)-1
	s todate=(+$h)-1
	s usercode=%session.Data("LOGON.USERCODE")
	s username=%session.Data("LOGON.USERNAME")
	s adddate=$p($h,",",1)
	s addtime=$p($h,",",2)
	i opercode="" s opercode="LS"_"-"_($o(^ORC("OPER",""),-1)+1)_"-"_usercode
	&sql(insert into sqluser.ORC_Operation(OPER_Code,OPER_Desc,OPER_DateActiveFrom,OPER_ActiveDateTo) values(:opercode,:operDesc,:fromdate,:todate))
	i SQLCODE'=0 q "插入手术表错误!"
	

	s operId=$g(%ROWID)
	i OperCateDr'="" s $p(^ORC("OPER",operId),"^",7)=OperCateDr
	s ^ORC("OPER",operId,"DHC")=dhcOrcOperStr
	i opType'="" s $p(^ORC("OPER",operId,"DHC"),"^",11)=opType
	s ^ORC("OPER",operId,"DHC","ADD")=username_"^"_adddate_"^"_addtime
	/*
	&sql(insert into sqluser.ORC_OperationAlias(ALIAS_ParRef,ALIAS_Text) values(:operId,:operAlias))
	i SQLCODE'=0 q "插入手术别名表错误!"
	*/
    q ret
}

ClassMethod GetAddOperInfo(operId As %String)
{
	s dateformatnum=##class(websys.Conversions).DateFormat()
	q:operId="" ""
	s OperCode=$p($g(^ORC("OPER",operId)),"^",1)
	s OperName=$p($g(^ORC("OPER",operId)),"^",2)
	s OperSubRowid=$o(^ORC("OPER",operId,"ALIAS",""),-1)
	s OperAlias=$p($g(^ORC("OPER",operId,"ALIAS",OperSubRowid)),"^",1)
	s FromDate=$p($g(^ORC("OPER",operId)),"^",5)
	i FromDate'="" s FromDate=$ZD(FromDate,dateformatnum)
	s ToDate=$p($g(^ORC("OPER",operId)),"^",6)
	i ToDate'="" s ToDate=$ZD(ToDate,dateformatnum)
	s Data=OperCode_"^"_OperName_"^"_OperAlias_"^"_FromDate_"^"_ToDate
	q Data
}

ClassMethod UpdateAddOperInfo(operId, OperCode, OperName, OperAlias, FromDate, ToDate) As %String
{
	q:operId="" ""
	s dateformatnum=##class(websys.Conversions).DateFormat()
	i FromDate'="" s FromDate=$ZDH(FromDate,dateformatnum)
	i ToDate'="" s ToDate=$ZDH(ToDate,dateformatnum)
	&sql(Update sqluser.ORC_Operation set OPER_Code=:OperCode,OPER_Desc=:OperName,OPER_DateActiveFrom=:FromDate,OPER_ActiveDateTo=:ToDate where OPER_RowId=:operId)
	i SQLCODE'=0 q "更新手术表错误!"
	
    &sql(Update sqluser.ORC_OperationAlias set ALIAS_Text=:OperAlias where ALIAS_ParRef=:operId)
	i SQLCODE'=0 q "更新手术别名表错误!"
	
	q 0
}

}

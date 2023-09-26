/// Creator:         wk
/// CreatDate:       2018-01-11
/// Description:	 床位维护的后台处理程序
Class web.DHCWL.V1.MRBase.BedConfig Extends %RegisteredObject
{

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 获取所有已维护科室
/// Table：        
/// Input：       
/// Output：      
/// Return：          
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRBase.BedConfig","GetLocListQuery","24")
/// 
Query GetLocListQuery(locType As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:科室ID,code:%String:科室编码,name:%String:科室name,date:%String:日期,GDNum:%String:编制床位数,SYNum:%String:实有床位数,BZNum:%String:备注床位数") [ SqlProc ]
{
}

ClassMethod GetLocListQueryExecute(ByRef qHandle As %Binary, locType As %String, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	i locType="Ward" s locType="W"
	i locType="Loc" s locType="E"
	s upFilter=$zcvt(filterValue,"U")
	
	k ^||TEMPDHCWL($j),locList
	s id=0
	s result=0,totalNum=0,Str=""
	f  {
		s id=$O(^DHCMRBed(id)) 
		Q:id=""
		s LocId=$P(^DHCMRBed(id),"^",2)
		s WardId=$P(^DHCMRBed(id),"^",6)
		continue:(locType="E")&&(+LocId=0)
		continue:(locType="W")&&(+WardId=0)
		if (locType="E"){
			s locList(LocId)=""
		}
		if (locType="W"){
			s locList(WardId)=""
		}
	}
	s id=""
	for {
		s id=$o(locList(id))
		q:id=""
		s date="",bedID=""
		if (locType="W"){
			s date=$o(^DHCMRBed(0,"Ward",id,"Date",""),-1)
			s bedID=$o(^DHCMRBed(0,"Ward",id,"Date",date,""))
			continue:('$d(^PAWARD(id)))
			s desc=$P(^PAWARD(id),"^",2)
			s code=$P(^PAWARD(id),"^",1)
			
		}else{
			s date=$o(^DHCMRBed(0,"Loc",id,"Date",""),-1)
			s bedID=$o(^DHCMRBed(0,"Loc",id,"Date",date,""))
			continue:('$d(^CTLOC(id)))
			s desc=$P(^CTLOC(id),"^",2)
			s code=$P(^CTLOC(id),"^",1)
		}
		s Date=$P(^DHCMRBed(bedID),"^",1)
		s GDNum=$P(^DHCMRBed(bedID),"^",3)
		s SYNum=$P(^DHCMRBed(bedID),"^",4)
		s BZNum=$P(^DHCMRBed(bedID),"^",5)
		s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
		continue:(upFilter'="")&&(id '[ upFilter)&&($zcvt(desc,"U") '[ upFilter)&&($zcvt(code,"U") '[ upFilter)
		s ^CacheTemp(repid,ind)=$lb(id,code,desc,Date,GDNum,SYNum,BZNum)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 根绝科室获取床位维护信息
/// Table：        
/// Input：       
/// Output：      
/// Return：          
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRBase.BedConfig","GetBedInforByLocQuery")
/// 
Query GetBedInforByLocQuery(locType As %String, locID As %String) As websys.Query(ROWSPEC = "date:%String:生效日期,GDNum:%String:固定床位数,SYNum:%String:实有床位数,BZNum:%String:备注床位数") [ SqlProc ]
{
}

ClassMethod GetBedInforByLocQueryExecute(ByRef qHandle As %Binary, locType As %String, locID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	i locType="Ward" s locType="W"
	i locType="Loc" s locType="E"
	s bedID=""
	for {
		if (locType="W") {
			s bedID=$o(^DHCMRBed(0,"Ward",locID,bedID))
		}else{
			s bedID=$o(^DHCMRBed(0,"Loc",locID,bedID))
		}
		q:bedID=""
		continue:+bedID=0
		s date=$P(^DHCMRBed(bedID),"^",1)
		s GDNum=$P(^DHCMRBed(bedID),"^",3)
	 	s SYNum=$P(^DHCMRBed(bedID),"^",4)
		s BZNum=$P(^DHCMRBed(bedID),"^",5)
		s formatDate=##class(websys.Conversions).DateLogicalToHtml(date)
		s bedInforlist(date)=formatDate_"^"_GDNum_"^"_SYNum_"^"_BZNum
	}
	s date=""
	for {
		s date=$o(bedInforlist(date),-1)
		q:date=""
		s ^CacheTemp(repid,ind)=$lb($p(bedInforlist(date),"^",1),$p(bedInforlist(date),"^",2),$p(bedInforlist(date),"^",3),$p(bedInforlist(date),"^",4))
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator：      wk
/// CreatDate：    2017-12-26
/// Description:： 获取所有未维护科室
/// Table：        
/// Input：       
/// Output：      
/// Return：          
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRBase.BedConfig","GetAllLocQuery")
/// 
Query GetAllLocQuery(LocOrWard As %String = "", filterLoc As %String = "") As websys.Query(ROWSPEC = "id:%String:生效日期,code:%String:科室编码,name:%String:科室描述") [ SqlProc ]
{
}

ClassMethod GetAllLocQueryExecute(ByRef qHandle As %Binary, LocOrWard As %String, filterLoc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s upFilter=$zcvt(filterLoc,"U")  //变大写 不区分大小写

	k ^||TEMPDHCWL($j)
	s ID=0
	f  s ID=$O(^CTLOC(ID)) Q:+ID=0  d
	.s LocCode=$P(^CTLOC(ID),"^",1)
	.s LocDesc=$P(^CTLOC(ID),"^",2)
	.s LocType=$P(^CTLOC(ID),"^",13)
	.s LocDepdr=$P(^CTLOC(ID),"^",19)
	.s isLocLinkFlag=..isCTLocLink(ID)   ////是否为科室病区关联
	.s wardRowID=0
	.s:((LocOrWard="Ward")&&(ID'="")) wardRowID=$O(^PAWARD(0,"WARD_LocationDR",ID,""))
	.Q:(LocOrWard="Ward")&&((LocType'="W")||($d(^DHCMRBed(0,"Ward",wardRowID))))
	.Q:(LocOrWard="Loc")&&(((+isLocLinkFlag=0)||(LocType'="E"))||($d(^DHCMRBed(0,"Loc",ID))))
	.s ^||TEMPDHCWL($j,"Desc",LocDesc,ID)=LocCode   ///解决汉字排序
	
	s LocDesc=""
	f  s LocDesc=$O(^||TEMPDHCWL($j,"Desc",LocDesc)) Q:LocDesc=""  d
	.s count=""
	.f  s count=$O(^||TEMPDHCWL($j,"Desc",LocDesc,count)) Q:count=""  d
	..s LocCode=$g(^||TEMPDHCWL($j,"Desc",LocDesc,count))
	..q:(filterLoc'="")&&($zcvt(LocCode,"U") '[ filterLoc)&&($zcvt(LocDesc,"U") '[ filterLoc)
	..s ^CacheTemp(repid,ind)=$lb(count,LocCode,LocDesc)
	..s ind=ind+1
	Quit $$$OK
}

/// 判断科室是否存在CT_LocLinkLocation关联
/// 存在返回：1,否则：0
ClassMethod isCTLocLink(Locid As %String) As %String
{
	s ret=0
	q:+Locid=0 ret
	q:$D(^CTLOC(Locid,"LINK")) "1"
	q ret
}

/// Creator：      wk
/// CreatDate：    2018-01-12
/// Description：  床位维护信息
/// Table：        
/// Input：       
/// Output：      
/// Return：          
/// Others：       do ##class(web.DHCWL.V1.MRBase.BedConfig).SaveBedInfor()
/// 
ClassMethod SaveBedInfor(locType, locCode, locDesc, startDate, GDNum, SYNum, BZNum)
{
	s paraValues=startDate_"&"_locType_"&"_locCode_"&"_locDesc_"&"_GDNum_"&"_SYNum_"&"_BZNum
	s ret=##Class(web.DHCMRTJService).addBed(paraValues)
	q ret
}

/// Creator：      wk
/// CreatDate：    2018-01-12
/// Description:： 获取指定科室历史床位信息
/// Table：        
/// Input：       
/// Output：      
/// Return：          
/// Others：d ##class(%ResultSet).RunQuery("web.DHCWL.V1.MRBase.BedConfig","GetLocHisBedListQuery")
/// 
Query GetLocHisBedListQuery(locType As %String, locID As %String) As websys.Query(ROWSPEC = "ID:%String:科室ID,code:%String:科室编码,name:%String:科室name,date:%String:日期,GDNum:%String:编制床位数,SYNum:%String:实有床位数,BZNum:%String:备注床位数") [ SqlProc ]
{
}

ClassMethod GetLocHisBedListQueryExecute(ByRef qHandle As %Binary, locType As %String, locID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
	i locType="Ward" s locType="W"
	i locType="Loc" s locType="E"

	q:locID=""
	s id=locID
	s date="",bedID=""
	for {
		if (locType="W"){
			s date=$o(^DHCMRBed(0,"Ward",id,"Date",date),-1)
			q:date=""
			s bedID=$o(^DHCMRBed(0,"Ward",id,"Date",date,""))
			s desc=$P(^PAWARD(id),"^",2)
			s code=$P(^PAWARD(id),"^",1)
			
		}else{
			s date=$o(^DHCMRBed(0,"Loc",id,"Date",date),-1)
			q:date=""
			s bedID=$o(^DHCMRBed(0,"Loc",id,"Date",date,""))
			s desc=$P(^CTLOC(id),"^",2)
			s code=$P(^CTLOC(id),"^",1)
		}
		s bedDate=$P(^DHCMRBed(bedID),"^",1)
		s GDNum=$P(^DHCMRBed(bedID),"^",3)
		s SYNum=$P(^DHCMRBed(bedID),"^",4)
		s BZNum=$P(^DHCMRBed(bedID),"^",5)
		s bedDate=##class(websys.Conversions).DateLogicalToHtml(bedDate)
		;continue:(upFilter'="")&&(id '[ upFilter)&&($zcvt(desc,"U") '[ upFilter)
		s ^CacheTemp(repid,ind)=$lb(id,code,desc,bedDate,GDNum,SYNum,BZNum)
		s ind=ind+1
	}
	Quit $$$OK
}

}

Class web.DHCDISWorkquery Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

/// Description:科室列表下拉
/// Creator:     guoguomin
/// CreateDate:  2017-02-08
/// Table: 		 
/// Input:  	 HospID
/// Return： 
/// Others:D ##class(%ResultSet).RunQuery("web.DHCDISWorkquery","FindLoc")
Query FindLoc() As %Query(ROWSPEC = "LocId:%String,LocDesc:%String") [ SqlProc ]
{
}

//query的执行部分

ClassMethod FindLocExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	
    s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.;q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	
	
	.s data = $lb(LocId,LocDesc)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	
	;LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod FindLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod FindLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// W ##Class(web.DHCDISWorkquery).GetApplayLoc("2")   
ClassMethod GetApplayLoc(HospID As %String)
{
	s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// 统计某个人的配送工作量
/// w ##Class(web.DHCDISWorkquery).QueryDisApp1("2017-01-01","2017-02-24","","申请人员")
ClassMethod QueryDisApp1(StDate As %String, EndDate As %String, Dept As %String, PeopelType As %String) As %String
{
	S:StDate'="" StDate=$zdh(StDate,3)
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	;w Score
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.workquery","ListPeScore")
    S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)         
	i PeopelType="申请人员" s PersonType="待处理"

	i PeopelType="验证人员" s PersonType="验证确认"
	i PeopelType="完成人员" s PersonType="完成确认"
	
	s point="0"
	f  s point=$o(^DHCDISRS(point)) q:point=""  d
	.s UserDr = $p(^DHCDISRS(point),"^",6)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	.s ThisHosItemNum=0     //本院项目数
	.s OtherHosItemNum=0    //外院项目数
	.s ThisPeopleNum=0      //本院人次
	.s OtherPeopleNum=0     //外院人次
	.s ItemNum=0            //项目合计
	.s PeopleNum=0 
	.s count1=0
	.s point="0"
	.f  s point=$o(^DHCDISRS(point)) q:point=""  d
	..s hosdr=""
	..q:UserDr'=$p(^DHCDISRS(point),"^",6)
	..s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	..s DpReqType=$p(^DHCDISRS(point),"^",1) //配送或陪送类型  配送:1,陪送:0
	..q:DpReqType=0
	..s ReqExeDate = $p(^DHCDISRS(point),"^",4)
	..Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	..Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
	..s PType=$p(^DHCDISRS(point),"^",3)   //状态（区分三种不同人员类型）
	..s PTypeDesc=$p(^DHCDISSA(PType),"^",2)
	..q:PTypeDesc'=PersonType
	..s Pointer = $p(^DHCDISRS(point),"^",2)
	..s LocId = $p(^DHCDISGRE(Pointer),"^",2)
	..Q:(Dept'="")&(Dept'=LocId)
	..i LocId'="" s LocName=$p(^CTLOC(LocId),"^",1)   //取科室名称
	..;i PersonType'="完成人员" s itemNum=1
	..;i PersonType ="完成人员" s itemNum=0
	..s itemNum=0
	..s ReqChildSub	=""
	..f  s ReqChildSub=$o(^DHCDISGRE(Pointer,"ITM",ReqChildSub)) q:ReqChildSub=""  d
	
	...s ReqItem=$p(^DHCDISGRE(Pointer,"ITM",ReqChildSub),"^",1)  //项目ID                
	...s disType=$p(^DHCDISLI(ReqItem),"^",4)  //配送或陪送类型  配送:1,陪送:0
	...q:disType=0 
	...s itemNum=$p(^DHCDISGRE(Pointer,"ITM",ReqChildSub),"^",3)  //数量
    
    ...s hosdr=$p(^DHCDISLI(ReqItem),"^",6)	
 																						 
    ..s:hosdr=HosId ThisHosItemNum=ThisHosItemNum+itemNum   //增加本院项目数
	..s:hosdr=HosId ThisPeopleNum=ThisPeopleNum+1
	..s:hosdr'=HosId OtherHosItemNum=OtherHosItemNum+itemNum //增加外院项目数
	..s:hosdr'=HosId OtherPeopleNum=OtherPeopleNum+1
	 
	.;s itmname=$p()
	.s ItemNum=ItemNum+ThisHosItemNum+OtherHosItemNum
	.;q:ItemNum=0
	.s PeopleNum=PeopleNum+ThisPeopleNum+OtherPeopleNum 
	.s data=LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	.w data
}

/// w ##class(web.DHCDISWorkquery).test("2017-1-12","2017-2-20","","配送人员")
ClassMethod test(StDate As %String, EndDate As %String, Dept As %String, PeopelType As %String) As %String
{
	S:StDate'="" StDate=$zdh(StDate,3)
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	;w Score
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.workquery","ListPeScore")
    S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)         

	if (PeopelType="配送人员"){
		
    s prowid="0"
	s count1=0
	f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	.s UserDr = $p(^DHCDISPE(prowid),"^",3)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	.s UserName=""
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	.s data=..GetScores(UserDr)
	.s ReqExeDate=$p(data,"^",9)
	.Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	.Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
	.s LocId = $p(data,"^",10)
	.Q:(Dept'="")&(Dept'=LocId)
	.s UserName=$p(data,"^",1)
	.s LocName=$p(data,"^",2)
	.s ThisHosItemNum=$p(data,"^",3)
	.s ThisPeopleNum=$p(data,"^",4)
	.s OtherHosItemNum=$p(data,"^",5)
	.s OtherPeopleNum=$p(data,"^",6)
	.s ItemNum=$p(data,"^",7)
	.s PeopleNum=$p(data,"^",8)
	.q:ItemNum=0
	.s count1=count1+1
	.s data=LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	.w data
		}
	if (PeopelType'="配送人员"){
	s ThisHosItemNum=0     //本院项目数
	s OtherHosItemNum=0    //外院项目数
	s ThisPeopleNum=0      //本院人次
	s OtherPeopleNum=0     //外院人次
	s ItemNum=0            //项目合计
	s PeopleNum=0 
	s count1=0
	
	s point="0"
	f  s point=$o(^DHCDISGRE(point)) q:point=""  d
	.s UserDr = $p(^DHCDISGRE(point),"^",9)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	.s point="0"
	.f  s point=$o(^DHCDISGRE(point)) q:point=""  d
	..q:UserDr'=$p(^DHCDISGRE(point),"^",9)
	..s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	..s LocId=$p(^DHCDISGRE(point),"^",2)
	..Q:(Dept'="")&(Dept'=LocId)
	..i LocId'="" s LocName=$p(^CTLOC(LocId),"^",1)   //取科室名称
	..s ReqChildSub	=""
	..f  s ReqChildSub=$o(^DHCDISGRE(point,"ITM",ReqChildSub)) q:ReqChildSub=""  d
	...s itemNum=$p(^DHCDISGRE(point,"ITM",ReqChildSub),"^",3)  //数量
	...s ReqItem=$p(^DHCDISGRE(point,"ITM",ReqChildSub),"^",1)  //项目ID                
	...s disType=$p(^DHCDISLI(ReqItem),"^",4)  //配送或陪送类型  配送:1,陪送:0
	...q:disType=0 
	...s ReqExeDate = $p(^DHCDISGRE(point),"^",4)
	...s hosdr=$p(^DHCDISLI(ReqItem),"^",6)
	...Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	...Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
    ...s hosdr=$p(^DHCDISLI(ReqItem),"^",6)																											 
    ...s:hosdr=HosId ThisHosItemNum=ThisHosItemNum+itemNum    //增加本院项目数
	...s:hosdr=HosId ThisPeopleNum=ThisPeopleNum+1
	...s:hosdr'=HosId OtherHosItemNum=OtherHosItemNum+itemNum //增加外院项目数
	...s:hosdr'=HosId OtherPeopleNum=OtherPeopleNum+1
	 
	.;s itmname=$p()
	.s ItemNum=ItemNum+ThisHosItemNum+OtherHosItemNum
	.s PeopleNum=PeopleNum+ThisPeopleNum+OtherPeopleNum 
	.s data=LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	.w data
		
		
		
		}
}

/// w ##class(web.DHCDISWorkquery).ListPeScore1("2017-1-12","2017-2-20","","")
ClassMethod ListPeScore1(StDate As %String, EndDate As %String, Dept As %String, PeopelType As %String) As %String
{
	
	S:StDate'="" StDate=$zdh(StDate,3)
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	;w Score
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.workquery","ListPeScore")
    S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)         
	
	s ThisHosItemNum=0     //本院项目数
	s OtherHosItemNum=0    //外院项目数
	s ThisPeopleNum=0      //本院人次
	s OtherPeopleNum=0     //外院人次
	s ItemNum=0            //项目合计
	s PeopleNum=0 
	s count1=0
	
	s point="0"
	f  s point=$o(^DHCDISGRE(point)) q:point=""  d
	.s UserDr = $p(^DHCDISGRE(point),"^",9)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	
	.s point="0"
	.f  s point=$o(^DHCDISGRE(point)) q:point=""  d
	..q:UserDr'=$p(^DHCDISGRE(point),"^",9)
	..s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	..s LocId=$p(^DHCDISGRE(point),"^",2)
	..i LocId'="" s LocName=$p(^CTLOC(LocId),"^",1)   //取科室名称
	..s ReqChildSub	=""
	..f  s ReqChildSub=$o(^DHCDISGRE(point,"ITM",ReqChildSub)) q:ReqChildSub=""  d
	...s itemNum=$p(^DHCDISGRE(point,"ITM",ReqChildSub),"^",3)  //数量
	...s ReqItem=$p(^DHCDISGRE(point,"ITM",ReqChildSub),"^",1)  //项目ID                
	...s disType=$p(^DHCDISLI(ReqItem),"^",4)  //配送或陪送类型  配送:1,陪送:0
	...q:disType=0 
	...s ReqExeDate = $p(^DHCDISGRE(point),"^",4)
	...s hosdr=$p(^DHCDISLI(ReqItem),"^",6)
	...Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	...Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
    ...s hosdr=$p(^DHCDISLI(ReqItem),"^",6)
																													
	    
    ...s:hosdr=HosId ThisHosItemNum=ThisHosItemNum+itemNum    //增加本院项目数
	...s:hosdr=HosId ThisPeopleNum=ThisPeopleNum+1
	...s:hosdr'=HosId OtherHosItemNum=OtherHosItemNum+itemNum //增加外院项目数
	...s:hosdr'=HosId OtherPeopleNum=OtherPeopleNum+1
	 
	.;s itmname=$p()
	.s ItemNum=ItemNum+ThisHosItemNum+OtherHosItemNum
	
	.s PeopleNum=PeopleNum+ThisPeopleNum+OtherPeopleNum 
	
	.s tmp=LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	w tmp
	b
}

/// Description:获取科室的名称
/// Creator:     zhanghailong
/// CreateDate:  2017-02-09
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// W ##Class(web.DHCDISWorkquery).GetLocName(4)
ClassMethod GetLocName(User As %String)
{

	s acceptLoc=""
	s LocData=""
	s LUid="" 
	f  s LUid=$o(^DHCDISLU(LUid))  q:LUid=""  d
	.s msgiii=$g(^DHCDISLU(LUid))
	.q:msgiii="" 
	.s userdr=$p(msgiii,"^",2)
	.i userdr=User  d
	..s LocId=$p(msgiii,"^",1)
	..i LocId'="" s acceptLoc=$p(^CTLOC(LocId),"^",1)   //取科室名称
	..s LocData=LocId_"^"_acceptLoc
	q LocData
}

/// w ##class(web.DHCDISWorkquery).ListPeScore("2017-1-1","2017-2-20","","")
ClassMethod ListPeScore(StDate As %String, EndDate As %String, Dept As %String, PeopelType As %String) As %String
{
	
	S:StDate'="" StDate=$zdh(StDate,3)
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	;w Score
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.workquery","ListPeScore")
    S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)         

	
	s prowid="0"
	s count1=0
	f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	.s UserDr = $p(^DHCDISPE(prowid),"^",3)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	.s UserName=""
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	.s data=..GetScores(UserDr)
	.s ReqExeDate=$p(data,"^",9)
	.Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	.Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
	.s LocId = $p(data,"^",10)
	.Q:(Dept'="")&(Dept'=LocId)
	.s UserName=$p(data,"^",1)
	.s LocName=$p(data,"^",2)
	.s ThisHosItemNum=$p(data,"^",3)
	.s ThisPeopleNum=$p(data,"^",4)
	.s OtherHosItemNum=$p(data,"^",5)
	.s OtherPeopleNum=$p(data,"^",6)
	.s ItemNum=$p(data,"^",7)
	.s PeopleNum=$p(data,"^",8)
	.q:ItemNum=0
	.s count1=count1+1
	
	
	.s tmp=LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	q tmp
}

/// Description:根据人员获取项目数
/// Creator:     guoguomin
/// CreateDate:  2017-02-15
/// Table: 		 
/// Input:  	 
/// Return： 	 
/// w ##class(web.DHCDISWorkquery).GetScores(820)
ClassMethod GetScores(UserDr As %String)
{
	
	s count=0
	
	s prowid=0
	s score=0
	s ThisHosItemNum=0     //本院项目数
	s OtherHosItemNum=0    //外院项目数
	s ThisPeopleNum=0      //本院人次
	s OtherPeopleNum=0     //外院人次
	s ItemNum=0            //项目合计
	s PeopleNum=0 
	s ReqExeDate=""
	s Total=0
	S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)
	
	f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	.q:UserDr'=$p(^DHCDISPE(prowid),"^",3)
	.s DpReqType=$p(^DHCDISPE(prowid),"^",1) //配送或陪送类型  配送:1,陪送:0
	.q:DpReqType=0
	.s UserName=$p(^SSU("SSUSR",$p(^DHCDISPE(prowid),"^",3)),"^",2)
	.s LocDate = ..GetLocName($p(^DHCDISPE(prowid),"^",3))
	.s LocName = $p(LocDate,"^",2)
	.s LocId = $p(LocDate,"^",1)
	.s Pointer = $p(^DHCDISPE(prowid),"^",2)
	.s ReqChildSub	=""
	.f  s ReqChildSub=$o(^DHCDISGRE(Pointer,"ITM",ReqChildSub)) q:ReqChildSub=""  d
	
	..s ReqItem=$p(^DHCDISGRE(Pointer,"ITM",ReqChildSub),"^",1)  //项目ID          
	..;b ;yyyyy
	..;s point =$p(Pointer,"||",1)
	..;s pointitm=$p(Pointer,"||",2)  //取任务id
	..;w Pointer
	..;b ;ggm
	..;s ReqItem=$p(^DHCDISGRE(pointer,"ITM",pointitm),"^",1)  //项目ID                
	..;s disType=$p(^DHCDISLI(ReqItem),"^",4)            //配送或陪送类型  配送:1,陪送:0
	..;q:disType=0 
	..;b ;ppppp
	..s ReqExeDate = $p(^DHCDISGRE(Pointer),"^",4)
	..w Pointer_"^"_ReqChildSub
	..s itemNum=$p(^DHCDISGRE(Pointer,"ITM",ReqChildSub),"^",3)  //数量
    ..s hosdr=$p(^DHCDISLI(ReqItem),"^",6) 
																													
	    
    ..s:hosdr=HosId ThisHosItemNum=ThisHosItemNum+itemNum    //增加本院项目数
	..s:hosdr=HosId ThisPeopleNum=ThisPeopleNum+1
	..s:hosdr'=HosId OtherHosItemNum=OtherHosItemNum+itemNum //增加外院项目数
	..s:hosdr'=HosId OtherPeopleNum=OtherPeopleNum+1
	..s count=count+1 
	.;s itmname=$p()
	s ItemNum=ItemNum+ThisHosItemNum+OtherHosItemNum
	
	s PeopleNum=PeopleNum+ThisPeopleNum+OtherPeopleNum 
	s data=UserName_"^"_LocName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum_"^"_ReqExeDate_"^"_LocId
	q data
}

/// Description:获取项目数
/// Creator:     guoguomin
/// CreateDate:  2017-02-15
/// Table: 		 
/// Input: 开始时间， 	 
/// Return： 	 
/// Others:D ##class(%ResultSet).RunQuery("web.DHCDISWorkquery","FindPhyQty","2017-1-12^2017-2-28^^完成人员")
Query FindPhyQty(strings As %String) As %Query(ROWSPEC = "LocName:%String,UserDr:%String,UserName:%String,ThisHosItemNum:%Float,ThisPeopleNum:%Float,OtherHosItemNum:%Float,OtherPeopleNum:%Float,ItemNum:%Float,PeopleNum:%Float") [ SqlProc ]
{
}

//query的执行部分

ClassMethod FindPhyQtyExecute(ByRef qHandle As %Binary, strings As %String) As %Status
{
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	;s StDate  EndDate Dept PeopelType
	s StDate=$p(strings,"^",1)
	s EndDate=$p(strings,"^",2)
	s Dept=$p(strings,"^",3)
	s PeopelType=$p(strings,"^",4)
	
	S:StDate'="" StDate=$zdh(StDate,3)
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	;w Score
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.workquery","ListPeScore")
    S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)         

	if (PeopelType="配送人员"){
		
    s prowid="0"
	s count1=0
	f  s prowid=$o(^DHCDISPE(prowid)) q:prowid=""  d
	.s UserDr = $p(^DHCDISPE(prowid),"^",3)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	.s UserName=""
	.s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	.s data=..GetScores(UserDr)
	.s ReqExeDate=$p(data,"^",9)
	.Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	.Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
	.s LocId = $p(data,"^",10)
	.Q:(Dept'="")&(Dept'=LocId)
	.s UserName=$p(data,"^",1)
	.s LocName=$p(data,"^",2)
	.s ThisHosItemNum=$p(data,"^",3)
	.s ThisPeopleNum=$p(data,"^",4)
	.s OtherHosItemNum=$p(data,"^",5)
	.s OtherPeopleNum=$p(data,"^",6)
	.s ItemNum=$p(data,"^",7)
	.s PeopleNum=$p(data,"^",8)
	.q:ItemNum=0
	.s count1=count1+1
	.;s data=LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	.s data=$lb(LocName,UserDr,UserName,ThisHosItemNum,ThisPeopleNum,OtherHosItemNum,OtherPeopleNum,ItemNum,PeopleNum)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
		}
	if (PeopelType'="配送人员"){
	s StDate=$p(strings,"^",1)
	s EndDate=$p(strings,"^",2)
	s Dept=$p(strings,"^",3)
	s PeopelType=$p(strings,"^",4)
	S:StDate'="" StDate=$zdh(StDate,3)
	S:EndDate'="" EndDate=$zdh(EndDate,3)
	;w Score
	s pid=$i(^CacheTemp)
	Kill ^TMP("DHCEM","web.workquery","ListPeScore")
    S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)         
	i PeopelType="申请人员" s PersonType="待处理"

	i PeopelType="验证人员" s PersonType="验证确认"
	i PeopelType="完成人员" s PersonType="完成确认"
	
	s point="0"
	f  s point=$o(^DHCDISRS(point)) q:point=""  d
	.s UserDr = $p(^DHCDISRS(point),"^",6)
	.q:UserDr=""
	.s ^TMP("DHCEM","web.workquery","ListPeScore",UserDr)=""   //临时globle
	
	s LocName=""
	s UserDr=""
	f  s UserDr=$o(^TMP("DHCEM","web.workquery","ListPeScore",UserDr)) q:UserDr=""  d
	.s ThisHosItemNum=0     //本院项目数
	.s OtherHosItemNum=0    //外院项目数
	.s ThisPeopleNum=0      //本院人次
	.s OtherPeopleNum=0     //外院人次
	.s ItemNum=0            //项目合计
	.s PeopleNum=0 
	.s count1=0
	.s point="0"
	.f  s point=$o(^DHCDISRS(point)) q:point=""  d
	..s hosdr=""
	..q:UserDr'=$p(^DHCDISRS(point),"^",6)
	..s UserName=$p(^SSU("SSUSR",UserDr),"^",2)     //取用户名
	..s DpReqType=$p(^DHCDISRS(point),"^",1) //配送或陪送类型  配送:1,陪送:0
	..q:DpReqType=0
	..s ReqExeDate = $p(^DHCDISRS(point),"^",4)
	..Q:(+StDate'=0)&(StDate>ReqExeDate) ///过滤日期 
	..Q:(+EndDate'=0)&(ReqExeDate>EndDate) ///过滤日期 
	..s Pointer = $p(^DHCDISRS(point),"^",2)
	..s LocId = $p(^DHCDISGRE(Pointer),"^",2)
	..Q:(Dept'="")&(Dept'=LocId)
	..i LocId'="" s LocName=$p(^CTLOC(LocId),"^",1)   //取科室名称
	..s PType=$p(^DHCDISRS(point),"^",3)   //状态（区分三种不同人员类型）
	..s PTypeDesc=$p(^DHCDISSA(PType),"^",2)
	..q:PTypeDesc'=PersonType
	..;w LocName
	..;i PersonType'="完成人员" s itemNum=1
	..;i PersonType ="完成人员" s itemNum=0
	..s itemNum=0
	..s ReqChildSub	=""
	..f  s ReqChildSub=$o(^DHCDISGRE(Pointer,"ITM",ReqChildSub)) q:ReqChildSub=""  d
	
	...s ReqItem=$p(^DHCDISGRE(Pointer,"ITM",ReqChildSub),"^",1)  //项目ID                
	...s disType=$p(^DHCDISLI(ReqItem),"^",4)  //配送或陪送类型  配送:1,陪送:0
	...q:disType=0 
	...s itemNum=$p(^DHCDISGRE(Pointer,"ITM",ReqChildSub),"^",3)  //数量
    
    ...s hosdr=$p(^DHCDISLI(ReqItem),"^",6)	
 																						 
    ..s:hosdr=HosId ThisHosItemNum=ThisHosItemNum+itemNum   //增加本院项目数
	..s:hosdr=HosId ThisPeopleNum=ThisPeopleNum+1
	..s:hosdr'=HosId OtherHosItemNum=OtherHosItemNum+itemNum //增加外院项目数
	..s:hosdr'=HosId OtherPeopleNum=OtherPeopleNum+1
	.;s itmname=$p()
	.s ItemNum=ItemNum+ThisHosItemNum+OtherHosItemNum
	.;q:ItemNum=0
	.;s LocName="门诊西药房"
	.s PeopleNum=PeopleNum+ThisPeopleNum+OtherPeopleNum 
	.;w LocName_"^"_UserDr_"^"_UserName_"^"_ThisHosItemNum_"^"_ThisPeopleNum_"^"_OtherHosItemNum_"^"_OtherPeopleNum_"^"_ItemNum_"^"_PeopleNum
	.;b ;wwww
	.s data=$lb(LocName,UserDr,UserName,ThisHosItemNum,ThisPeopleNum,OtherHosItemNum,OtherPeopleNum,ItemNum,PeopleNum)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1		

	 }
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod FindPhyQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPhyQtyExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod FindPhyQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPhyQtyExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

}

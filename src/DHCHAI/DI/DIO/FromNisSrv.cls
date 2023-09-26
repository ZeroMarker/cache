/// 名称: DHCHAI.DI.DIO.FromNisSrv
/// 描述: 护理数据接口
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DIO.FromNisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      高志恒
/// CreatDate：    2017-08-01
/// Description:   查询某一病人指定日期内的生命体征数据
/// Table：        MR_Observations、MRC_ObservationItem
/// Input：        Adm:就诊号, 
/// 			   StDate:查询开始日期, EndDate:查询结束日期
///                TemCode:体温的项目代码，如 Item1
///                BowCode:大便的项目代码，如 Item11
/// Output：       项目记录ID:OBsID、项目代码：OBItemCode、项目名称：OBItemDesc、项目值：OBItemValue、录入日期：OBEntryDate、录入时间：OBEntryTime、记录人ID：OBEntryUserID、记录人姓名：OBEntryUserName
/// Return：       
/// Others：       若体温项目代码TemCode、大便的项目代码BowCode 参数不为空，则只会输出相应项目的数据
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromNisSrv","GetThreeList","1577187","2017-04-13","2017-04-16","Item1","Item11")
Query GetThreeList(Adm As %String, StDate As %String, EndDate As %String, TemCode As %String = "", BowCode As %String = "") As %Query(ROWSPEC = "OBsID:%String,OBItemCode:%String,OBItemDesc:%String,OBItemValue:%String,OBEntryDate:%String,OBEntryTime:%String,OBEntryUserID:%String,OBEntryUserCode:%String,OBEntryUserName:%String")
{
}

ClassMethod GetThreeListExecute(ByRef qHandle As %Binary, Adm As %String, StDate As %String, EndDate As %String, TemCode As %String = "", BowCode As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set EpisodeID=Adm
 	Quit:EpisodeID="" $$$OK
 	Set Adm=$p($g(^PAADM(EpisodeID)),"^",61)
 	Quit:Adm="" $$$OK
	
	i StDate="" s StDate=+$h
	e  s:StDate["-" StDate=$zdh(StDate,3)
	i EndDate="" s EndDate=+$h
	e  s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	f Date=StDate:1:EndDate  d
	.s ItmDr=""  f  s ItmDr=$O(^MR(Adm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
	..q:'$d(^MRC("OBITM",ItmDr))
	..//项目ID、项目代码、项目名称
	..s ItmRowId=ItmDr
	..s OBItemCode=$p($g(^MRC("OBITM",ItmRowId)),"^",1)
	..s OBItemDesc=$p($g(^MRC("OBITM",ItmRowId)),"^",2)
	..//若体温代码不为空
	..q:((TemCode'="")&(BowCode="")&(OBItemCode'=TemCode))
	..//若大便代码不为空
	..q:((TemCode="")&(BowCode'="")&(OBItemCode'=BowCode))
	..//若均不为空
	..q:((TemCode'="")&(BowCode'="")&(OBItemCode'=TemCode)&(OBItemCode'=BowCode))
	..//
	..s chl=""  f  s chl=$O(^MR(Adm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
	...//项目ID
	...s OBsID=Adm_"||"_chl  
	...//项目值
	...s OBItemValue=$P(^MR(Adm,"OBS",chl),"^",2)
	...//录入日期 
	...s OBEntryDate=$P(^MR(Adm,"OBS",chl),"^",3)
	...//录入时间  
	...s OBEntryTime=$P(^MR(Adm,"OBS",chl),"^",4)
	...//录入人ID  
	...s OBEntryUserID=$P(^MR(Adm,"OBS",chl),"^",5)
	...//录入人工号 
	...s OBEntryUserCode=$P(^SSU("SSUSR",+OBEntryUserID),"^",1)
	...//录入人姓名  
	...s OBEntryUserName=$P(^SSU("SSUSR",+OBEntryUserID),"^",2)
	...d OutThreeRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutThreeRow
	set Data=$lb($g(OBsID),$g(OBItemCode),$g(OBItemDesc),$g(OBItemValue),$g(OBEntryDate),$g(OBEntryTime),$g(OBEntryUserID),$g(OBEntryUserCode),$g(OBEntryUserName))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetThreeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetThreeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetThreeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetThreeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2017-12-26
/// Description:   查询护理管理字典
/// Table：        MRC_ObservationItem
/// Input：        无
/// Output：       项目代码：OBItemCode、项目名称：OBItemDesc
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.FromNisSrv","GetObsItemDic")
Query GetObsItemDic() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod GetObsItemDicExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Set xID=0
 	For {
		Set xID=$o(^MRC("OBITM",xID))
		Quit:xID=""
		
		Set ItemCode=$p($g(^MRC("OBITM",xID)),"^",1)
		Set ItemDesc=$p($g(^MRC("OBITM",xID)),"^",2)
		Continue:(ItemCode="")||(ItemDesc="")
		Set IsActive=1
		
		set Data=$lb(xID,ItemCode,ItemDesc,IsActive)
 		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod GetObsItemDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetObsItemDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetObsItemDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetObsItemDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:      SongChao
/// CreateDate:   2020.08.11
/// Description:  根据就诊获取婴儿的Apgar评分
/// Input:        
/// Return:       就诊号:姓名:出生日期:出生时间:性别:评分时段:评分顺序:心率/脉搏:呼吸:肌张力:反射(弹足底或插鼻反应评分):肤色:总分:记录人:记录日期:记录时间:
/// Other:        ##Class(%ResultSet).RunQuery("Nur.Interface.OutSide.Patient","getApgarByEpisodeID",2200)
/// ForTeam:      医务管理
Query getApgarByEpisodeID(EpisodeID) As websys.Query(ROWSPEC = "EpisodeID,name,birthDate,birthTime,sex,time,apgarNo,pulse,respiration,activity,grimace,appearance,total,userID,updateDate,updateTime")
{
}

ClassMethod getApgarByEpisodeIDExecute(ByRef qHandle As %Binary, EpisodeID) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	If $g(ind)="" Set ind=1
	s motherEpisodeID=$p($g(^PAADM(EpisodeID)),"^",75)
	q:motherEpisodeID="" $$$OK
	s motherPersonID=$p($g(^PAADM(motherEpisodeID)),"^",1)
	s pregnancyID=$o(^PAPRGi("PREG_Person",motherPersonID,0))
	q:pregnancyID="" $$$OK
	s deliveryID=$o(^PAPRGi("DEL_Adm_DR",motherEpisodeID,pregnancyID,"DEL",""))
	s babyParRefID=pregnancyID_"||"_deliveryID
	s personID=$p($g(^PAADM(EpisodeID)),"^",1)
	s name=$p($g(^PAPER(personID,"ALL")),"^")
	s deliveryBabyID=$o(^PAPRGi("BABY_Person_DR",personID,pregnancyID,"DEL",deliveryID,"BABY",""))
	q:deliveryBabyID="" $$$OK
	s deliveryBabyData=$g(^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID))
    s orderNumber=$p(deliveryBabyData,"^",15)
    s sexDR=$p(deliveryBabyData,"^",48)
    s sex=$p($g(^CT("SEX",sexDR)),"^",2)
    s birthDate=$p(deliveryBabyData,"^",13)
	s birthTime=$p(deliveryBabyData,"^",49)
	s userID=$p(deliveryBabyData,"^",74)
	s updateDate=$p(deliveryBabyData,"^",75)
	s updateTime=$p(deliveryBabyData,"^",76)
	s babyID=babyParRefID_"||"_deliveryBabyID
	s sub=0 f  s sub=$O(^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID,"PDBAS",sub)) q:(sub="")  d
	.s info=$g(^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID,"PDBAS",sub))
	.q:info=""
	.s apgarNo=$p(info,"^",1)
	.s pulse=+$p(info,"^",2)
	.s respiration=+$p(info,"^",3)
	.s activity=+$p(info,"^",4)
	.s grimace=+$p(info,"^",5)
	.s appearance=+$p(info,"^",6)
	.s total=activity+respiration+pulse+grimace+appearance
	.s:sub=1 time=1
	.s:sub=2 time=5
	.s:sub=3 time=$p(^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID),"^",9)
	.s:sub=4 time=$p(^PAPRG(pregnancyID,"DEL",deliveryID,"BABY",deliveryBabyID),"^",10)
	.d getApgar
	;q ##class(Nur.JSON).EncodeByWrite(##class(Nur.IP.Delivery).getApgarScore(babyID,3,""))
	
	Quit $$$OK	
getApgar
	set Data=$lb(EpisodeID,name,birthDate,birthTime,sex,$g(time),apgarNo,pulse,respiration,activity,grimace,appearance,total,userID,updateDate,updateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator：     liuzhenhe
/// CreatDate：   2020-11-20
/// Description:  通过护理接口获取新生儿阿普加评分用于ICU日志  DHCHAI.DI.DIO.FromNisSrv
/// Input：       就诊号
/// Return：	  阿普加总评分
/// w ##class(DHCHAI.DI.DIO.FromNisSrv).GetApgarByAdm(127,1)
/// w ##class(DHCHAI.DI.DIO.FromNisSrv).GetApgarByAdm(3213,1)
ClassMethod GetApgarByAdm(Adm As %String, aFlg As %String = "")
{
	New (Adm,aFlg)
	
	Set return=""
	Set EpisodeID=$$GetFirEpisodeID(Adm)
	Quit:EpisodeID="" return    //没有关联母亲的就诊号 退出
	w EpisodeID,!
	Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromNisSrv:getApgarByEpisodeID")
  	Set sc=rs.Execute(EpisodeID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	
  	Set flg=""
    While (rs.Next()){
	    if (aFlg){
		    Set:flg="" flg=rs.Data("time")
		    Continue:flg>rs.Data("time")
	    }
	    Set return= rs.Data("total")
	}
	Quit return
	
GetFirEpisodeID(aEpisodeID)
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" ""
	
	Set AdmType="",ret=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Quit:AdmType=""
		
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set motherEpisodeID=$p($g(^PAADM(Paadm)),"^",75)
			if (motherEpisodeID'="") {
				Set ret=Paadm
				Quit
			}
		}
		Quit:ret'=""
	}
	Quit ret
}

}

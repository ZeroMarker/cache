/// 描述:护士长今日提示待测体温
/// 编写者：bmz
/// 编写日期: 2014-12-11
Class DtPortal.NH.NH02Message.NH0204UnmeTemp Extends %RegisteredObject
{

/// 名称:DtPortal.NH.NH02Message.NH0204UnmeTemp
/// CreatDate： 2014-12-15
/// Description: 查询护士长今日提示待测体温的信息
/// Input：  userCode         
/// Return： 
/// 服务代码 NH02.04.01
/// d ##class(%ResultSet).RunQuery("DtPortal.NH.NH02Message.NH0204UnmeTemp","NH020401","2156","")
Query NH020401(userCode As %String, wardId As %String) As DtPortal.Query(ROWSPEC = "bedCode:%String,name:%String,tempStr:%String,EpisodeId:%String")
{
}

ClassMethod NH020401Execute(ByRef qHandle As %Binary, userCode As %String, wardId As %String) As %Status
{
	//New (qHandle,userCode)
	
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	Quit:wardId="" $$$OK
	
	set locWarld=$p(^PAWARD(wardId),"^",5)
	Quit:locWarld="" $$$OK
	
	Set admIdStr=""
	Set admIdStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward",userCode,wardId)
	Quit:admIdStr="" $$$OK
	Set inNum=$l(admIdStr,"^")
	
	
	f index1=1:1:inNum {
		s EpisodeId="",tempStr=""
		s EpisodeId=$p(admIdStr,"^",index1)
		continue:EpisodeId=""
		set locID=$P($g(^PAADM(EpisodeId)),"^",4)
		//判断是否存在标准版的接口，不存在的话使用护理组给项目提供的旧版接口
		s mdf=##class(%Dictionary.CompiledMethod).%OpenId("Nur.NIS.Service.VitalSign.TemperatureMeasure||GetNeedMeasureTemperature",0)
		if ($IsObject(mdf)){
			try{
				//如果调用标准版接口报错，那就调用护理组给项目提供的接口
				s infos=##class(Nur.NIS.Service.VitalSign.TemperatureMeasure).GetNeedMeasureTemperature(EpisodeId,"","",locID,"")
			}catch{
				s infos=##Class(DtPortal.NH.NH02Message.NH0204UnmeTemp).getNeedMeasureInfoByEpisodeID(EpisodeId,locID)
			}
			
		}else{
			//b ;01
			s infos=##Class(DtPortal.NH.NH02Message.NH0204UnmeTemp).getNeedMeasureInfoByEpisodeID(EpisodeId,locID)
		}
		
		s count=infos.Count()
		continue:count<1
		s ifHasUnMessage=0  //是否存在未测，不存在过滤
		f index2=1:1:count {
			s info= infos.GetAt(index2)
			s time=info.GetAt("time")
			s value=info.GetAt("value")
			s ifMeasure=info.GetAt("ifMeasure")
			if (value=""){
				s ifHasUnMessage=1
			}
			if (tempStr=""){
				s tempStr=time_"^"_ifMeasure_"^"_value
			}else{
			 	s tempStr=tempStr_"#"_time_"^"_ifMeasure_"^"_value
			}
		}
		
		//w !,tempStr
		continue:ifHasUnMessage=0  //全部测量完毕的过滤
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeId)
		s bedCode=$p(patInfoStr,"^",1)
 		s name=$p(patInfoStr,"^",2)
 		
		d UnmeTempList
	}
  	q $$$OK
UnmeTempList
    s Data=$lb(bedCode,name,tempStr,EpisodeId)
 	s ^||CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// sunhaiming 2020-7-2
/// 供Portal组调用--根据就诊号返回该患者当天需测体温时间点和是否测量过，如果测量过要返回对应值
/// 数据格式：对象
/// ##Class(Nur.DHCNurInterface).getNeedMeasureInfoByEpisodeID("335")
/// ##Class(DtPortal.NH.NH02Message.NH0204UnmeTemp).getNeedMeasureInfoByEpisodeID("335")
ClassMethod getNeedMeasureInfoByEpisodeID(EpisodeID, locID = "")
{
	s $zt="Error"
	s ifShowCurrentNeedMeasure="false"   //是否显示当前时间点，否则显示当天所有时间点
	s currentDate=$zd(+$h,3)
	i locID="" s locID=$p($g(^PAADM(EpisodeID)),"^",4)
	s pos=##class(Nur.CommonInterface.Temperature).GetCurrTimePos($p($h,",",2))
	s checkTime=$zt(pos,2)
	s measureInfo=##class(Nur.CommonInterface.TemperatureMeasure).getNeedMeasureInfo(EpisodeID, currentDate, checkTime, locID)
	s theDayNeedMeasure=##class(%ListOfDataTypes).%New()
	s key=""
	f{
		s data=measureInfo.GetNext(.key)
		q:(key="")||('$IsValidNum(key))
		s keySub=""
		f{
			s dataSub=data.GetNext(.keySub)  //时间点对象
			q:keySub=""   //时间点
			s keySubChild=""
			s theDayNeedMeasureDetail=##class(%ArrayOfDataTypes).%New()
			f{
				s dataSubChild=dataSub.GetNext(.keySubChild)
				q:keySubChild=""
				i (keySubChild="temperature")&&(dataSub.GetAt(keySubChild)="true") d
				.s ifMeasure="N",value=""
				.d getThisTimeTemperature
				.d theDayNeedMeasureDetail.SetAt(ifMeasure,"ifMeasure")
				.d theDayNeedMeasureDetail.SetAt(keySub,"time")
				.d theDayNeedMeasureDetail.SetAt(value,"value")
				}
			i theDayNeedMeasureDetail.GetNext("")'="" d theDayNeedMeasure.Insert(theDayNeedMeasureDetail)
			}
		}
		q:ifShowCurrentNeedMeasure="true" theDayNeedMeasure.GetAt(checkTime)
		q theDayNeedMeasure
		q ##class(Nur.JSON).Encode(theDayNeedMeasure)
getThisTimeTemperature
      s mrAdmID=$P(^PAADM(EpisodeID),"^",61)
      s time=$zth(keySub)
      s itemID=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(keySubChild),""))
      s obsID=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,+$h,time,""))
      q:obsID=""
      s ifMeasure="Y"
      s value=$P(^MR(mrAdmID,"OBS",obsID),"^",2)
      q
Error
     w $ze
}

}

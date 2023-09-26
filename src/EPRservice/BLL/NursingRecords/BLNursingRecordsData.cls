/// 名称： EPRservice.BLL.NursingRecords.BLNursingRecordsData
/// 描述:  根据EpisodeID,查询患者指定项目的护理记录单信息,并且可以通过时间进行数据的筛选
/// 创建者：牛才才
/// 创建时间：2014-08-08
/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.NursingRecords.BLNursingRecordsData","GetNursingRecordsData","","","","","","")
/// d ##class(%ResultSet).RunQuery("EPRservice.BLL.NursingRecords.BLNursingRecordsData","GetNursingRecordsData","5","ITEM1:体温|ITEM2:脉搏|ITEM3:舒张压|ITEM4:收缩压|ITEM5:心率","2008-07-01","2008-07-02","1","12")
Class EPRservice.BLL.NursingRecords.BLNursingRecordsData Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query GetNursingRecordsData(AEpisodeID As %String, ArgItemStr As %String, AStDate As %String, AEndDate As %String, ArgStartNum As %String, ArgEndNum As %String) As %Query(ROWSPEC = "Date:%String,Time:%String,tiwen:%String,maibo:%String,huxi:%String,shousuoya:%String,shuzhangya:%String,SPO2:%String,xinlv:%String,jielv:%String,yishi:%String,tongkouzuo:%String,tongkongyou:%String,duiguangfanshezuo:%String,duiguangfansheyou:%String,xuetang:%String,ruliangxiangmu:%String,ruliangliang:%String,chuliangxiangmu:%String,chuliangliang:%String,BQBHJHLCS:%String,qianming:%String,rw:%String,par:%String")
{
}

ClassMethod GetNursingRecordsDataExecute(ByRef qHandle As %Binary, AEpisodeID As %String, ArgItemStr As %String, AStDate As %String, AEndDate As %String, ArgStartNum As %String, ArgEndNum As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	//s ^tempncc("0") = AEpisodeID_"#"_ArgItemStr_"#"_AStDate_"#"_AEndDate_"#"_ArgStartNum_"#"_ArgEndNum
	s resultStr = ##class(Nur.DHCNurseInterface).getnursebyadm(AEpisodeID)
	
	//s resultStr = "2014-8-9/15:11^体温1^脉搏1^呼吸1^收缩压1/舒张压1^血糖1^瞳孔左1/瞳孔右1#2014-8-9/15:22^体温2^脉搏2^呼吸2^收缩压2/舒张压2^血糖2^瞳孔左2/瞳孔右2#2014-8-9/15:33^体温3^脉搏3^呼吸3^收缩压3/舒张压3^血糖3^瞳孔左3/瞳孔右3#2014-8-9/15:44^体温4^脉搏4^呼吸4^收缩压4/舒张压4^血糖4^瞳孔左4/瞳孔右4#2014-8-9/15:55^体温5^脉搏5^呼吸5^收缩压5/舒张压5^血糖5^瞳孔左5/瞳孔右5#2014-8-9/16:06^体温6^脉搏6^呼吸6^收缩压6/舒张压6^血糖6^瞳孔左6/瞳孔右6"
	s count = $l(resultStr,"#")
	
	//计算页数
	s pageNum = count\(ArgEndNum+1-ArgStartNum)
 	s modulo = count#(ArgEndNum+1-ArgStartNum)
 	if modulo'=0
	{ 	
		s pageNum = pageNum + 1
	}  
	
	if (ArgStartNum<=count)
	{
		if (ArgEndNum<=count)
		{
			for i=ArgStartNum:1:ArgEndNum
			{
				s subresultStr = $p(resultStr,"#",i)
		
				s DateTime = $p(subresultStr,"^",1)
				s Date = $p(DateTime,"/",1)
				if (AStDate '= " ") & (AEndDate '= " ")
				{
					s curDate = $zdh(Date,3) 
					s StDate = $zdh(AStDate,3)
					s EndDate = $zdh(AEndDate,3)
					continue:(curDate>EndDate)||(curDate<StDate)
				}
		
				s Time = $p(DateTime,"/",2)
		
				s tiwen = $p(subresultStr,"^",2)
				s maibo = $p(subresultStr,"^",3)
				s huxi = $p(subresultStr,"^",4)
		
				s xueya = $p(subresultStr,"^",5)
				s shousuoya = $p(xueya,"/",1)
				s shuzhangya = $p(xueya,"/",2)
		
				s xuetang = $p(subresultStr,"^",6)
		
				s tongkong = $p(subresultStr,"^",7)
				s tongkouzuo = $p(tongkong,"/",1)
				s tongkongyou = $p(tongkong,"/",2)
		
				s SPO2 = "6"
				s xinlv = "7"
				s jielv = "8"
				s yishi = "9"
				s duiguangfanshezuo = "12"
				s duiguangfansheyou = "13"
				s ruliangxiangmu = "15"
				s ruliangliang = "16"
				s chuliangxiangmu = "17"
				s chuliangliang = "18"
				s BQBHJHLCS = "19"
				s qianming = "20"
				s rw = "21"
				s par = "22"
		
				set ^CacheTemp(repid,ind) = $LB(Date,Time,tiwen,maibo,huxi,shousuoya,shuzhangya,SPO2,xinlv,jielv,yishi,tongkouzuo,tongkongyou,duiguangfanshezuo,duiguangfansheyou,xuetang,ruliangxiangmu,ruliangliang,chuliangxiangmu,chuliangliang,BQBHJHLCS,qianming,rw,par)
				set ind = ind + 1
			}
		}
		else
		{
			for i=ArgStartNum:1:count
			{
				s subresultStr = $p(resultStr,"#",i)
		
				s DateTime = $p(subresultStr,"^",1)
				s Date = $p(DateTime,"/",1)
				if (AStDate '= " ") & (AEndDate '= " ")
				{
					s curDate = $zdh(Date,3) 
					s StDate = $zdh(AStDate,3)
					s EndDate = $zdh(AEndDate,3)
					continue:(curDate>EndDate)||(curDate<StDate)
				}
		
				s Time = $p(DateTime,"/",2)
		
				s tiwen = $p(subresultStr,"^",2)
				s maibo = $p(subresultStr,"^",3)
				s huxi = $p(subresultStr,"^",4)
		
				s xueya = $p(subresultStr,"^",5)
				s shousuoya = $p(xueya,"/",1)
				s shuzhangya = $p(xueya,"/",2)
		
				s xuetang = $p(subresultStr,"^",6)
		
				s tongkong = $p(subresultStr,"^",7)
				s tongkouzuo = $p(tongkong,"/",1)
				s tongkongyou = $p(tongkong,"/",2)
		
				s SPO2 = "6"
				s xinlv = "7"
				s jielv = "8"
				s yishi = "9"
				s duiguangfanshezuo = "12"
				s duiguangfansheyou = "13"
				s ruliangxiangmu = "15"
				s ruliangliang = "16"
				s chuliangxiangmu = "17"
				s chuliangliang = "18"
				s BQBHJHLCS = "19"
				s qianming = "20"
				s rw = "21"
				s par = "22"
		
				set ^CacheTemp(repid,ind) = $LB(Date,Time,tiwen,maibo,huxi,shousuoya,shuzhangya,SPO2,xinlv,jielv,yishi,tongkouzuo,tongkongyou,duiguangfanshezuo,duiguangfansheyou,xuetang,ruliangxiangmu,ruliangliang,chuliangxiangmu,chuliangliang,BQBHJHLCS,qianming,rw,par)
				set ind = ind + 1
			}
		}
	}
	
	/*
	s Date = "2014-8-8"
	s Time = "18:08"
	s tiwen = "1"
	s maibo = "2"
	s huxi = "3"
	s shousuoya = "4"
	s shuzhangya = "5"
	s SPO2 = "6"
	s xinlv = "7"
	s jielv = "8"
	s yishi = "9"
	s tongkouzuo = "10"
	s tongkongyou = "11"
	s duiguangfanshezuo = "12"
	s duiguangfansheyou = "13"
	s xuetang = "14"
	s ruliangxiangmu = "15"
	s ruliangliang = "16"
	s chuliangxiangmu = "17"
	s chuliangliang = "18"
	s BQBHJHLCS = "19"
	s qianming = "20"
	s rw = "21"
	s par = "22"
	*/
	
	
	Quit $$$OK
}

ClassMethod GetNursingRecordsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNursingRecordsDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNursingRecordsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNursingRecordsDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				
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

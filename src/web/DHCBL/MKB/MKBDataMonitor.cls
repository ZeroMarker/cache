Class web.DHCBL.MKB.MKBDataMonitor Extends %RegisteredObject
{

/// d ##class(web.DHCBL.MKB.MKBDataMonitor).GetList("2010-01-01","2020-01-01","A")
ClassMethod GetList(start, end, op)
{
	s result="",total=0,jsonstr=""
	//s startdate=$ZDH(start,3)
	//s enddate = $ZDH(end,3)
	s startdate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(start)
	s enddate=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(end)
	
	s date=startdate
	for
	{
		s date=$O(^User.BDPDataChangeLogI("UpdateDateIndex",date))
		q:date=""
		q:date>enddate
			
		s ID=""
		for
		{
			s ID=$o(^User.BDPDataChangeLogI("UpdateDateIndex",date,ID),-1)
			q:ID=""
			
			s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
			continue:(($zcvt(ClassName,"U")'["USER.MKB")&&($zcvt(ClassName,"U")'="USER.BDPMENU"))
			s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
			continue:OperateType'[op
			s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
            s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
            s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6) 
            
            s:$D(arr(UpdateUserName))=0 arr(UpdateUserName)=0
            s:$D(arr(UpdateUserName)) arr(UpdateUserName)=arr(UpdateUserName)+1
		}
	}
	w "{""rows"":["
	s Name=""
	for
	{
		s Name=$O(arr(Name))	
		q:Name=""
		
		s mainstr="{""Name"":"""_Name_""",""Num"":"""_arr(Name)_"""}"						
		if (jsonstr'="")
		{ 
			w ","
			s jsonstr=jsonstr_","_mainstr
		}
		else
		{
			s jsonstr=mainstr
		}
		w mainstr
	}
	w "]}"
	q ""
}

}

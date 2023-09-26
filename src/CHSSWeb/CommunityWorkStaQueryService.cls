Class CHSSWeb.CommunityWorkStaQueryService Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//根据树的街道节点，列出下属机构的统计数据

ClassMethod List(streetid, Start, Limit, BeginDate, EndDate)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	
	s startdate=$zdh(BeginDate,3)
	s enddate=$zdh(EndDate,3)
	Set end = start+limit
	set FamilyCountZ=0
	set PersonCountZ=0
	s WomanArcAllNumZ=0
    s ElderArcAllNumZ=0
    s HBPArcAllNumZ=0
    s DiabeteArcAllNumZ=0
    s SchizoArcAllNumZ=0
    s ChildArcAllNumZ=0
    s HandicappedArcAllNumZ=0
	Set json = ##class(Code.JsonObj).%New()	
     s result = ##class(%Library.ResultSet).%New()	
		
    s sqlStr="select communitycode,communityname from chss.dicthospital where recorddr="_streetid_" and (communitytype='社区卫生服务中心' or communitytype='乡镇卫生院') union select communitycode,communityname from chss.dicthospital where recorddr in (select rowid from chss.dictVillage where rowidparref="_streetid_") and (communitytype='村卫生所' or communitytype='社区卫生服务站')"	
    ;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()	
	While(result.Next())
	{
	s communitycode=result.Data("CommunityCode")
	s communityname = result.Data("CommunityName")
	;总家庭档案数,个人档案数
	s FPCount=..GetFPCount(communitycode)
    s FamilyCount=$P(FPCount,"^",1)
    s PersonCount=$P(FPCount,"^",2)
    s FamilyCountZ=FamilyCountZ+FamilyCount
    s PersonCountZ=PersonCountZ+PersonCount	
    ;得到高血压，糖尿病，。。。。。。
    s ChoricCount=..GetChorincCount(communitycode)
    s HBPArcNum=$P(ChoricCount,"^",1)
	s DiabeteArcNum=$P(ChoricCount,"^",2)
	s SchizoArcNum=$P(ChoricCount,"^",3)
	s HandicappedArcNum=$P(ChoricCount,"^",4)
    ;得到老年人，儿童，妇女
    s OtherCount=..GetOtherCount(communitycode,startdate,enddate)
	s ElderArcNum=$P(OtherCount,"^",1)
	s WomanArcNum=$P(OtherCount,"^",2)
	s ChildArcNum=$P(OtherCount,"^",3)
	
	
	s WomanArcAllNumZ=WomanArcAllNumZ+WomanArcNum
    s ElderArcAllNumZ=ElderArcAllNumZ+ElderArcNum
    s HBPArcAllNumZ=HBPArcAllNumZ+HBPArcNum
    s DiabeteArcAllNumZ=DiabeteArcAllNumZ+DiabeteArcNum
    s SchizoArcAllNumZ=SchizoArcAllNumZ+SchizoArcNum
    s ChildArcAllNumZ=ChildArcAllNumZ+ChildArcNum
    s HandicappedArcAllNumZ=HandicappedArcAllNumZ+HandicappedArcNum
	
	
	s tmp=""
	s tmp=communityname_"^"_PersonCount_"^"_FamilyCount_"^"_HBPArcNum_"^"_DiabeteArcNum_"^"_ElderArcNum_"^"_WomanArcNum_"^"_ChildArcNum_"^"_SchizoArcNum_"^"_HandicappedArcNum
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s tamp="<b><font color=red>总计</font></b>"_"^"_PersonCountZ_"^"_FamilyCountZ_"^"_HBPArcAllNumZ_"^"_DiabeteArcAllNumZ_"^"_ElderArcAllNumZ_"^"_WomanArcAllNumZ_"^"_ChildArcAllNumZ_"^"_SchizoArcAllNumZ_"^"_HandicappedArcAllNumZ
	d json.InsertRowData(tamp)
	s resultString = json.getJsonData("CommuniyName^PersonCount^FamilyCount^HBPArcNum^DiabeteArcNum^ElderArcNum^WomanArcNum^ChildArcNum^SchizoArcNum^HandicappedArcNum",count)
	k json	
	Quit resultString
}

//根据树的区县节点，列出下属街道和乡镇的统计数据

ClassMethod ListSection(sectionid, Start, Limit, BeginDate, EndDate)
{
	Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	
	s startdate=$zdh(BeginDate,3)
	s enddate=$zdh(EndDate,3)
	Set end = start+limit
	set FamilyCountZ=0
	set PersonCountZ=0
	s WomanArcAllNumZ=0
    s ElderArcAllNumZ=0
    s HBPArcAllNumZ=0
    s DiabeteArcAllNumZ=0
    s SchizoArcAllNumZ=0
    s ChildArcAllNumZ=0
    s HandicappedArcAllNumZ=0
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
	s sqlstr="select description as streetname,rowid as streetid from chss.dictstreet where rowidparref="_sectionid
	d result.Prepare(sqlstr)
	d result.Execute()	
	While(result.Next())
	{
	s streetname=result.Get("streetname")
	s streetid = result.Get("streetid")
	s CommunityCodesqlStr = "select hospital.Communitycode as code from CHSS.DictHospital hospital, CHSS.DictStreet street where street.RowId = "_streetid_" and street.rowid = hospital.RecordDR  and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
    s CommunityCodesqlStr = CommunityCodesqlStr_" union select hospital.Communitycode as code from CHSS.DictVillage village, CHSS.DictHospital hospital,CHSS.DictStreet street where village.RowIdParref = street.RowId and street.RowId="_streetid_" and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
    ;w CommunityCodesqlStr_"---------------------------",!
    s FamilyCount=0
    s PersonCount=0
    s HBPArcNum=0 
    s DiabeteArcNum=0
    s SchizoArcNum=0
    s HandicappedArcNum=0
    s ElderArcNum=0
    s WomanArcNum=0
    s ChildArcNum=0
    ;w CommunityCodesqlStr
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
    While(resultCommunityCode.Next())
    { 
    s communitycode=resultCommunityCode.Get("code")	
	;总家庭档案数,个人档案数
	s FPCount=..GetFPCount(communitycode)
    s FamilyCount=FamilyCount+$P(FPCount,"^",1)
    s PersonCount=PersonCount+$P(FPCount,"^",2)
   
    ;得到高血压，糖尿病，。。。。。。
    s ChoricCount=..GetChorincCount(communitycode)
    s HBPArcNum=HBPArcNum+$P(ChoricCount,"^",1)
	s DiabeteArcNum=DiabeteArcNum+$P(ChoricCount,"^",2)
	s SchizoArcNum=SchizoArcNum+$P(ChoricCount,"^",3)
	s HandicappedArcNum=HandicappedArcNum+$P(ChoricCount,"^",4)
    ;得到老年人，儿童，妇女
    s OtherCount=..GetOtherCount(communitycode,startdate,enddate)
	s ElderArcNum=ElderArcNum+$P(OtherCount,"^",1)
	s WomanArcNum=WomanArcNum+$P(OtherCount,"^",2)
	s ChildArcNum=ChildArcNum+$P(OtherCount,"^",3)
	
	}
	d resultCommunityCode.Close()
	s FamilyCountZ=FamilyCountZ+FamilyCount
    s PersonCountZ=PersonCountZ+PersonCount	
	s WomanArcAllNumZ=WomanArcAllNumZ+WomanArcNum
    s ElderArcAllNumZ=ElderArcAllNumZ+ElderArcNum
    s HBPArcAllNumZ=HBPArcAllNumZ+HBPArcNum
    s DiabeteArcAllNumZ=DiabeteArcAllNumZ+DiabeteArcNum
    s SchizoArcAllNumZ=SchizoArcAllNumZ+SchizoArcNum
    s ChildArcAllNumZ=ChildArcAllNumZ+ChildArcNum
    s HandicappedArcAllNumZ=HandicappedArcAllNumZ+HandicappedArcNum
	
	
	s tmp=""
	s tmp=streetname_"^"_PersonCount_"^"_FamilyCount_"^"_HBPArcNum_"^"_DiabeteArcNum_"^"_ElderArcNum_"^"_WomanArcNum_"^"_ChildArcNum_"^"_SchizoArcNum_"^"_HandicappedArcNum
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s tamp="<b><font color=red>总计</font></b>"_"^"_PersonCountZ_"^"_FamilyCountZ_"^"_HBPArcAllNumZ_"^"_DiabeteArcAllNumZ_"^"_ElderArcAllNumZ_"^"_WomanArcAllNumZ_"^"_ChildArcAllNumZ_"^"_SchizoArcAllNumZ_"^"_HandicappedArcAllNumZ
	d json.InsertRowData(tamp)
	s resultString = json.getJsonData("CommuniyName^PersonCount^FamilyCount^HBPArcNum^DiabeteArcNum^ElderArcNum^WomanArcNum^ChildArcNum^SchizoArcNum^HandicappedArcNum",count)
	k json	
	Quit resultString
}

//根据树的市节点，列出下属区县的数据

ClassMethod ListCity(cityid, Start, Limit, BeginDate, EndDate)
{
		Set start=$G(Start)
	Set limit=$G(Limit)
	Set count=0
	Set resultString = ""
	
	s startdate=$zdh(BeginDate,3)
	s enddate=$zdh(EndDate,3)
	Set end = start+limit
	set FamilyCountZ=0
	set PersonCountZ=0
	s WomanArcAllNumZ=0
    s ElderArcAllNumZ=0
    s HBPArcAllNumZ=0
    s DiabeteArcAllNumZ=0
    s SchizoArcAllNumZ=0
    s ChildArcAllNumZ=0
    s HandicappedArcAllNumZ=0
	Set json = ##class(Code.JsonObj).%New()	
    s result = ##class(%Library.ResultSet).%New()	
	s sqlstr="select description as sectionname,rowid as sectionid from chss.dictsection where rowidparref="_cityid
	d result.Prepare(sqlstr)
	d result.Execute()	
	While(result.Next())
	{
	s sectionname=result.Get("sectionname")
	s sectionid = result.Get("sectionid")
	s CommunityCodesqlStr = "select hospital.Communitycode as code from CHSS.DictHospital hospital, CHSS.DictStreet street where street.RowIdParref = "_sectionid_" and street.rowid = hospital.RecordDR  and (hospital.communitytype = '社区卫生服务中心' or hospital.communitytype = '乡镇卫生院' )"
    s CommunityCodesqlStr = CommunityCodesqlStr_" union select hospital.Communitycode as code from CHSS.DictVillage village, CHSS.DictHospital hospital,CHSS.DictStreet street where village.RowIdParref = street.RowId and street.RowIdParref="_sectionid_" and village.rowid = hospital.RecordDR and (hospital.communitytype = '社区卫生服务站' or hospital.communitytype = '村卫生所' )"
        ;w CommunityCodesqlStr_"---------------------------",!
    s FamilyCount=0
    s PersonCount=0
    s HBPArcNum=0 
    s DiabeteArcNum=0
    s SchizoArcNum=0
    s HandicappedArcNum=0
    s ElderArcNum=0
    s WomanArcNum=0
    s ChildArcNum=0
    ;w CommunityCodesqlStr
    Set resultCommunityCode = ##class(%Library.ResultSet).%New()        
    d resultCommunityCode.Prepare(CommunityCodesqlStr)
	d resultCommunityCode.Execute()
    While(resultCommunityCode.Next())
    { 
    s communitycode=resultCommunityCode.Get("code")	
	;总家庭档案数,个人档案数
	s FPCount=..GetFPCount(communitycode)
    s FamilyCount=FamilyCount+$P(FPCount,"^",1)
    s PersonCount=PersonCount+$P(FPCount,"^",2)
   
    ;得到高血压，糖尿病，。。。。。。
    s ChoricCount=..GetChorincCount(communitycode)
    s HBPArcNum=HBPArcNum+$P(ChoricCount,"^",1)
	s DiabeteArcNum=DiabeteArcNum+$P(ChoricCount,"^",2)
	s SchizoArcNum=SchizoArcNum+$P(ChoricCount,"^",3)
	s HandicappedArcNum=HandicappedArcNum+$P(ChoricCount,"^",4)
    ;得到老年人，儿童，妇女
    s OtherCount=..GetOtherCount(communitycode,startdate,enddate)
	s ElderArcNum=ElderArcNum+$P(OtherCount,"^",1)
	s WomanArcNum=WomanArcNum+$P(OtherCount,"^",2)
	s ChildArcNum=ChildArcNum+$P(OtherCount,"^",3)
	
	}
	d resultCommunityCode.Close()
	s FamilyCountZ=FamilyCountZ+FamilyCount
    s PersonCountZ=PersonCountZ+PersonCount	
	s WomanArcAllNumZ=WomanArcAllNumZ+WomanArcNum
    s ElderArcAllNumZ=ElderArcAllNumZ+ElderArcNum
    s HBPArcAllNumZ=HBPArcAllNumZ+HBPArcNum
    s DiabeteArcAllNumZ=DiabeteArcAllNumZ+DiabeteArcNum
    s SchizoArcAllNumZ=SchizoArcAllNumZ+SchizoArcNum
    s ChildArcAllNumZ=ChildArcAllNumZ+ChildArcNum
    s HandicappedArcAllNumZ=HandicappedArcAllNumZ+HandicappedArcNum
	
	
	s tmp=""
	s tmp=sectionname_"^"_PersonCount_"^"_FamilyCount_"^"_HBPArcNum_"^"_DiabeteArcNum_"^"_ElderArcNum_"^"_WomanArcNum_"^"_ChildArcNum_"^"_SchizoArcNum_"^"_HandicappedArcNum
	s count=count+1
	i (count>start)&(count<=end) d
    .d json.InsertRowData(tmp)
	}
	s tamp="<b><font color=red>总计</font></b>"_"^"_PersonCountZ_"^"_FamilyCountZ_"^"_HBPArcAllNumZ_"^"_DiabeteArcAllNumZ_"^"_ElderArcAllNumZ_"^"_WomanArcAllNumZ_"^"_ChildArcAllNumZ_"^"_SchizoArcAllNumZ_"^"_HandicappedArcAllNumZ
	d json.InsertRowData(tamp)
	s resultString = json.getJsonData("CommuniyName^PersonCount^FamilyCount^HBPArcNum^DiabeteArcNum^ElderArcNum^WomanArcNum^ChildArcNum^SchizoArcNum^HandicappedArcNum",count)
	k json	
	Quit resultString
}

//根据机构编码得到家庭档案总数 和个人档案总数

ClassMethod GetFPCount(CommunityCode As %String) As %String
{
	     s FamilyCount=0
         s PersonCount=0
	 	 s rowid=0
	     f  s rowid=$o(^CHSS.ReportCommunityFPCountI("CommunityAndDateIndex"," "_CommunityCode,0,rowid)) q:rowid=""    d  
	     .s tmp=##class(CHSS.ReportCommunityFPCount).%OpenId(rowid)
	     .s FamilyCount=tmp.FamilyCount //家庭档案数
 	     .s PersonCount=tmp.PersonCount //个人档案数
 	     q FamilyCount_"^"_PersonCount
}

//根据机构编码得到 慢性病数据

ClassMethod GetChorincCount(CommunityCode As %String)
{
	s HBPArcAllNum=0
    s DiabeteArcAllNum=0
    s SchizoArcAllNum=0
	s HandicappedArcAllNum=0
	s rowid=0
	f  s rowid=$o(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,0,rowid)) q:rowid=""    d  
	.s tmp=##class(CHSS.CommunityWorkStaNum).%OpenId(rowid)
	.s HBPArcAllNum=tmp.HBPArcAllNum 
 	.s DiabeteArcAllNum=tmp.DiabeteArcAllNum 
 	.s SchizoArcAllNum=tmp.SchizoArcAllNum 
 	.s HandicappedArcAllNum=tmp.HandicappedArcAllNum 
 	q HBPArcAllNum_"^"_DiabeteArcAllNum_"^"_SchizoArcAllNum_"^"_HandicappedArcAllNum
}

//根据机构编码 日期范围 得到 其他数据

ClassMethod GetOtherCount(CommunityCode As %String, BeginDate As %Date, EndDate As %Date)
{

	    s WomanArcAllNumZ=0
        s ElderArcAllNumZ=0
        s ChildArcAllNumZ=0
 	    f i=BeginDate:1:EndDate d
 	    . s RowId=0
	    .f  s RowId=$o(^CHSS.CommunityWorkStaNumI("CommunityAndDateIndex"," "_CommunityCode,i,RowId)) q:RowId=""    d 
        ..s PYCTmp=##class(CHSS.CommunityWorkStaNum).%OpenId(RowId)
        ..s WomanArcAllNum=PYCTmp.WomanArcAllNum
        ..s ElderArcAllNum=PYCTmp.ElderArcAllNum
       
        ..s ChildArcAllNum=PYCTmp.ChildArcAllNum
       
 	    ..i WomanArcAllNum'="" d
 	    ...s WomanArcAllNumZ=WomanArcAllNumZ+WomanArcAllNum  
 	    ..i ElderArcAllNum'="" d
 	    ...s ElderArcAllNumZ=ElderArcAllNumZ+ElderArcAllNum
 	   
 	    ..i ChildArcAllNum'="" d
 	    ...s ChildArcAllNumZ=ChildArcAllNumZ+ChildArcAllNum
 	   
 	     q ElderArcAllNumZ_"^"_WomanArcAllNumZ_"^"_ChildArcAllNumZ
}

Storage Default
{
<Data name="CommunityWorkStaQueryServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.CommunityWorB77D</DataLocation>
<DefaultData>CommunityWorkStaQueryServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.CommunityWorB77D</IdLocation>
<IndexLocation>^CHSSWeb.CommunityWorB77I</IndexLocation>
<StreamLocation>^CHSSWeb.CommunityWorB77S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

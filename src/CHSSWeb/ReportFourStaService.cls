Class CHSSWeb.ReportFourStaService Extends %Persistent
{

//设置宣传栏栏数

ClassMethod getHealthBroad(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s HealthBroadNum=0
    s sqlStr = "select count(*)  as HealthBroadNum from CHSS.HealthEducationBulletinBoard where DateOfCreate between "_sdate_" and "_enddate_" and communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s HealthBroadNum=result.Data("HealthBroadNum")
	}
	d result.Close()
	q HealthBroadNum
}

//举办健康知识讲座次数

ClassMethod getHealthEducationLecture(code, startdate, enddate)
{


	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s HealthEducationLectureNum=0
    s sqlStr = "select count(*)  as HealthEducationLectureNum from CHSS.HealthEducationLecture where DateOfCreate between "_sdate_" and "_enddate_" and communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s HealthEducationLectureNum=result.Data("HealthEducationLectureNum")
	}
	d result.Close()
	q HealthEducationLectureNum
}

//健康教育活动次数

//疫情报告例数

//儿童预防接种证(卡)建立数

ClassMethod getChildImmuCardNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s ChildImmuCardNum=0
    s sqlStr = "select count(*)  as ChildImmuCardNum from CHSS.ChildPlanedImmuCard where dinovoldate between "_sdate_" and "_enddate_" and communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s ChildImmuCardNum=result.Data("ChildImmuCardNum")
	}
	d result.Close()
	q ChildImmuCardNum
}

//接种人次数

ClassMethod getImmunityBacterinRecord(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s tempCommunityName=""
    &SQL(select CommunityName into :tempCommunityName from CHSS.DictHospital where CommunityCode= :code)
    s ImmunityBacterinRecordNum=0
    s sqlStr = "select count(num) as ImmunityBacterinRecordNum from (select distinct ImmuCardRowid  as num from CHSS.ImmunityBacterinRecord where ImmunityDate between "_sdate_" and "_enddate_" and communitycode='"_tempCommunityName_"' and ImmunityStatus='true')"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s ImmunityBacterinRecordNum=result.Data("ImmunityBacterinRecordNum")
	}
	d result.Close()
	q ImmunityBacterinRecordNum
}

//免疫规划相关疾病发病例数

//建立婴幼儿保健手册人数

ClassMethod getChildBaseInfo(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s ChildBaseInfoNum=0
    s sqlStr = "select count(*)  as ChildBaseInfoNum from CHSS.childbaseinfo where OperateDate between "_sdate_" and "_enddate_" and communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s ChildBaseInfoNum=result.Data("ChildBaseInfoNum")
	}
	d result.Close()
	q ChildBaseInfoNum
}

//新生儿访视人数

ClassMethod getChildFirstCheckNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s ChildFirstCheckNum=0
    s sqlStr = "select count(*)  as ChildFirstCheckNum from CHSS.childFirstcheck where Dateofcheck between "_sdate_" and "_enddate_" and communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s ChildFirstCheckNum=result.Data("ChildFirstCheckNum")
	}
	d result.Close()
	q ChildFirstCheckNum
}

//3岁以下儿童保健覆盖人数

ClassMethod getChildCheckRecordNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s ChildCheckRecordNum=0
    s sqlStr = "select count(childrowid)   as ChildCheckRecordNum from(select distinct childrowid from CHSS.childcheckrecord as a  where a.Dateofcheck between "_sdate_" and "_enddate_" and a.childrowid->communitycode='"_code_"')"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s ChildCheckRecordNum=result.Data("ChildCheckRecordNum")
	}
	d result.Close()
	q ChildCheckRecordNum
}

//3岁以下儿童系统管理人数

ClassMethod getChildCheckManageNum(code, startdate, enddate)
{
}

//高血压患者规范管理人数

ClassMethod getHBPCheckNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s HBPCheckNum=0
    s sqlStr = "select count(*) as HBPCheckNum  from (select distinct personrowidparref from CHSS.HBPCheckRecord a where a.Datecheck between "_sdate_" and "_enddate_" and a.personrowidparref->communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s HBPCheckNum=result.Data("HBPCheckNum")
	}
	d result.Close()
	q HBPCheckNum
}

//高血压患者管理人数

ClassMethod getHbpCheckManageNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s HbpCheckManageNum=0
    s sqlStr = "select count(*) as HbpCheckManageNum from CHSS.PersonHealthDiagnose a where a.personrowidparref in (select personrowid from CHSS.PersonHealthRecordMain  where communitycode='"_code_"') and  a.ItemdCode = '22' and a.ItemAssortName = '高血压'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s HbpCheckManageNum=result.Data("HbpCheckManageNum")
	}
	d result.Close()
	q HbpCheckManageNum
}

//高血压患者控制例数

//糖尿病患者管理人数

ClassMethod getDiabteNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s DiabteNum=0
    s sqlStr = "select count(*) as DiabteNum from CHSS.PersonHealthDiagnose a where a.personrowidparref in  (select personrowid from CHSS.PersonHealthRecordMain  where communitycode='"_code_"') and ItemdCode = '22' and ItemAssortName = '糖尿病'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s DiabteNum=result.Data("DiabteNum")
	}
	d result.Close()
	q DiabteNum
}

//糖尿病患者规范管理人数

ClassMethod getDiabteManageNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s DiabteManageNum=0
    s sqlStr = "select count(*) as DiabteManageNum from (select distinct personrowidparref from CHSS.DiabetesCheckRecord where a.Datecheck between "_sdate_" and "_enddate_" and a.personrowidparref->communitycode='"_code_"'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s DiabteManageNum=result.Data("DiabteManageNum")
	}
	d result.Close()
	q DiabteManageNum
}

//糖尿病患者控制例数

//其它慢病服务人次数

ClassMethod getOtherChornicNum(code, startdate, enddate)
{
	s result = ##class(%Library.ResultSet).%New()
	s sdate =$zdh(startdate,3)
    s enddate=$zdh(enddate,3)
    s OtherChornicNum=0
    s sqlStr = "select count(*) as OtherChornicNum from CHSS.PersonHealthDiagnose a where a.personrowidparref in  (select personrowid from CHSS.PersonHealthRecordMain  where communitycode='"_code_"') and ItemdCode = '22' and ItemAssortName<>'糖尿病' and ItemAssortName<>'高血压' and ItemAssortName<>'精神病'"
    d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{   
	
	 s OtherChornicNum=result.Data("OtherChornicNum")
	}
	d result.Close()
	q OtherChornicNum
}

//计生服务人次数

Storage Default
{
<Data name="ReportFourStaServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ReportFourStaServiceD</DataLocation>
<DefaultData>ReportFourStaServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ReportFourStaServiceD</IdLocation>
<IndexLocation>^CHSSWeb.ReportFourStaServiceI</IndexLocation>
<StreamLocation>^CHSSWeb.ReportFourStaServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}

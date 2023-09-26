Class User.TestYHT Extends %RegisteredObject
{

/// Function: 返回n小时后的日期与时间
/// Creator: 杨洪涛
/// CreatDate: 2023-9-16
/// Input: n
/// Output: DateTime
/// Others: w ##class(User.TestYHT).GetYangHongtaoLCDateTime(1)
ClassMethod GetYangHongtaoLCDateTime(n As %String) As %String
{
	q:n<0 "请输入大于0的数"
	s datenow=+$p($h,",",1)
	s timenow=+$p($h,",",2)
	s timetmp=$ZTIME(timenow)
	s hournow=$p(timetmp,":",1)
	if ((n+hournow)<24)  //判断是否需要改变日期
	{
		s timenext=timenow+(n*3600)
		s datenext=datenow
	}
	else 
	{
		if (n<24)  //判断所加时间是否超过一天（24小时）
		{
			;s n=n+hournow-24
			s timenext=timenow+(n*3600)-86400
			s datenext=datenow+1
		}
		else 
		{
			s d=n\24
			s n=n#24
			s timenext=timenow+(n*3600)
			if (timenext>86400)
			{
				s timenext=timenext-86400	
			}
			if ((n+hournow)<24) 
			{
				s datenext=datenow+d
			}
			else 
			{
				s datenext=datenow+1+d	
			}	
		}
	}
	s Date=$ZDATE(datenext,3)
	s Time=$ZTIME(timenext)

	Quit Date_" "_Time
}

/// Function: 统计出该病人就诊总次数（包含所有就诊类型）, 并返回总数。
/// Creator: 杨洪涛
/// CreatDate: 2023-9-16
/// Input: PAPMIName
/// Output: Count
/// Others: w ##class(User.TestYHT).GetPatCountYangHongtaoLC("罗墙医政研发")
ClassMethod GetPatCountYangHongtaoLC(PAPMIName As %String) As %String
{
	s PAPMIRowId=0
	s Count=0
	s PAPMIRowId=$o(^PAPERi("PAPER_PatName",PAPMIName,PAPMIRowId))
	q:PAPMIRowId=""
	s PAADMRowId=0
	//统计各就诊类型就诊次数
	for
	{
		s PAADMRowId=$o(^PAPERdr(PAPMIRowId,"ADM","I",PAADMRowId))
		q:PAADMRowId=""
		s Count=Count+1
	}
	for
	{
		s PAADMRowId=$o(^PAPERdr(PAPMIRowId,"ADM","O",PAADMRowId))
		q:PAADMRowId=""
		s Count=Count+1
	}
	for
	{
		s PAADMRowId=$o(^PAPERdr(PAPMIRowId,"ADM","E",PAADMRowId))
		q:PAADMRowId=""
		s Count=Count+1
	}
	for
	{
		s PAADMRowId=$o(^PAPERdr(PAPMIRowId,"ADM","N",PAADMRowId))
		q:PAADMRowId=""
		s Count=Count+1
	}
	for
	{
		s PAADMRowId=$o(^PAPERdr(PAPMIRowId,"ADM","H",PAADMRowId))
		q:PAADMRowId=""
		s Count=Count+1
	}
	q "姓名为"_PAPMIName_"的患者就诊次数为"_Count_"次"
}

/// Function: 按床号（BED_NO）顺序输出病人姓名
/// Creator: 杨洪涛
/// CreatDate: 2023-9-16
/// Input: 
/// Output: NameList
/// Others: d ##class(User.TestYHT).ShowBedsYangHongtaoLC()
ClassMethod ShowBedsYangHongtaoLC() As %String
{
	//建Global
	k ^TempB
	s ^TempB(1)="学生姓名01^1050^小单人床F"
	s ^TempB(2)="学生姓名02^1000^大单人床A"
	s ^TempB(3)="学生姓名03^1020^单人床C"
	s ^TempB(4)="学生姓名04^1030^贵单人床D"
	s ^TempB(5)="学生姓名05^1010^便宜单人床B"
	
	//建索引
	s RowId=0
	for 
	{
		s RowId=$o(^TempB(RowId))
		q:RowId=""
		s BedNo=$p($g(^TempB(RowId)),"^",2)
		s ^TempB(0,"BedNo",BedNo,RowId)=""	
	}
	//查询并输出学生姓名列表
	s Code=""
	for
	{
		s Code=$o(^TempB(0,"BedNo",Code))
		q:Code=""
		s Id=$o(^TempB(0,"BedNo",Code,0))
		w $p(^TempB(Id),"^",1)
		w !
	}
}

/// Function: 更新病人信息
/// Creator: 杨洪涛
/// CreatDate: 2023-9-16
/// Input: RowId, Name, CardNo, SexDesc
/// Output: result
/// Others: w ##class(User.TestYHT)UpDatePatientYangHongtaoLC("10","杨洪涛","10086","男")
ClassMethod UpDatePatientYangHongtaoLC(RowId As %String, Name As %String, CardNo As %String, SexDesc As %String) As %String
{
	q:RowId="" "RowId为空"
	q:Name="" "姓名为空"
	q:CardNo="" "卡号为空"
	s SexDR=$o(^CT("SEX",0,"Desc",SexDesc,0))
	q:SexDR="" "性别输入不正确"
	s PatObj=##class(User.PATest).%OpenId(RowId)
	if (PatObj)  //更新
	{
		if ((Name'=PatObj.PAName)||(CardNo'=PatObj.PACardNo))
		{
			s OldName=PatObj.PAName
			s OldCardNo=PatObj.PACardNo
			s PatObj.PARowId=RowId
			s PatObj.PAName=Name
			s PatObj.PACardNo=CardNo
			d PatObj.PASexDrSetObjectId(SexDR)
			TSTART
			s PaSc=PatObj.%Save()
			if ($$$ISOK(PaSc))
			{
				s LogObj=##class(User.PATestLog).%New()
				d LogObj.LogPersonDrSetObjectId(RowId)
				if (Name'=PatObj.PAName)  //仅姓名字段改变
				{
					s LogObj.LogFiled="PAName"
					s LogObj.LogOldValue=PatObj.PAName
					s LogObj.LogNewValue=Name	
				}
				elseif (CardNo'=PatObj.PACardNo)  //仅卡号字段改变
				{
					s LogObj.LogFiled="PACardNo"
					s LogObj.LogOldValue=PatObj.PACardNo
					s LogObj.LogNewValue=CardNo	
				}
				elseif ((Name'=PatObj.PAName)&(CardNo'=PatObj.PACardNo))  //姓名与卡号字段都改变,属性值为"姓名^卡号"
				{
					s LogObj.LogFiled="PAName^PACardNo"
					s LogObj.LogOldValue=PatObj.PAName_"^"_PatObj.PACardNo
					s LogObj.LogNewValue=Name_"^"_CardNo	
				}
				s LogSc=LogObj.%Save()
				if ($$$ISOK(LogSc))
				{
					TCOMMIT
					s LogRowId=LogObj.%Id()
					s result="日志表更新成功^"_LogRowId
				}
				else 
				{
					TROLLBACK
					s result="日志表更新失败^"_$System.OBJ.DisplaError(LogSc)
				}
			}
			else
			{
				TROLLBACK
				s result="患者信息表更新失败^"_$System.OBJ.DisplaError(PaSc)	
			}	
		}
		else
		{
			s PatObj.PARowId=RowId
			s PatObj.PAName=Name
			s PatObj.PACardNo=CardNo
			d PatObj.PASexDrSetObjectId(SexDR)
			TSTART
			s PaSc=PatObj.%Save()
			if ($$$ISOK(PaSc))
			{
				TCOMMIT
				s result="患者信息表更新成功^"_RowId	
			}
			else
			{
				TROLLBACK
				s result="患者信息表更新失败^"_$System.OBJ.DisplaError(PaSc)	
			}		
		}
	}
	else  //新增
	{
		s PatObj=##class(User.PATest).%New()
		s PatObj.PARowId=RowId
		s PatObj.PAName=Name
		s PatObj.PACardNo=CardNo
		d PatObj.PASexDrSetObjectId(SexDR)
		s PaSc=PatObj.%Save()
		if ($$$ISOK(PaSc))
		{
			s result="更新成功^"_RowId	
		}
		else
		{
			s result="更新失败^"_$System.OBJ.DisplaError(PaSc)	
		}	
	}
	d PatObj.%Close()
	k PatObj
	q result
}

/// Function: 查询某病人姓名信息变化的次数
/// Creator: 杨洪涛
/// CreatDate: 2023-9-16
/// Input: PARowId
/// Output: Count
/// Others: w ##class(User.TestYHT).GetNameChangeCountYangHongtaoLC("2")
ClassMethod GetNameChangeCountYangHongtaoLC(PARowId As %String) As %String
{
	q:((PARowId="")||(PARowId<=0)) "非法的病人id"
	q:'$d(^PATESTLOGi(0,"Person",PARowId)) "病人不存在"
	s LogRowId=0
	s Count=0
	for  //按索引取出病人对应的日志Id
	{
		s PaLogRowId=$o(^PATESTLOGi(0,"Person",PARowId,LogRowId))
		q:LogRowId=""
		s obj=##class(User.PATestLog).%OpenId(LogRowId)
		if (obj)
		{
			s Field= obj.LogField
			if (Field["PAName")  //判断哪些日志记录的是姓名信息改变
			{
				s Count=Count+1	
			}	
		}
	}
	q "Id为"_PARowId_"的病人姓名信息变化的次数为"_Count_"次"
}

/// d ##class(User.TestYHT).Test()
ClassMethod Test() As %String
{
	SET ^TMP(3)="2" 
	SET ^TMP(3,2)="2^3^4" 
	SET ^TMP(4)="3" 
	SET ^TMP(4,2)="1^2^3" 
	SET ^TMP(4,3)="3^4^5" 
	Set index=1 
	Set count=0 
	For 
	{ 
		SET index = $Order(^TMP(index)) 
		Quit:index=""
	 	Set count = count+1 
	} 
	Write count
}

Method TestYHT()
{
	q "@@@"
}

}

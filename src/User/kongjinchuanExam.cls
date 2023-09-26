Class User.kongjinchuanExam Extends %RegisteredObject
{

/// Function:返回n小时后日期和时间
/// CreaterDate:2023-09-16
/// Creater:孔晋川(HIS研发)
/// InPut: n(小时数)
/// OutPut: YYYY-MM-DD hh:mm:ss
/// Others:w ##class(User.kongjinchuanExam).GetKongJinChuanHISYFDateTime(2)
ClassMethod GetKongJinChuanHISYFDateTime(n)
{
		q:n="" "请输入小时数"
		s n=n * 60 * 60
		s OldDate=$p($h,",",1)
		s OldTime=$p($h,",",2)
		s NewTime=OldTime+n
		if (NewTime>86400) //超过一天
		{
			s OldDate=OldDate+1
			s NewTime=NewTime-86400
		}
		s NewDate=$zdate(OldDate,3)
		s NewTime=$ztime(NewTime,1)
		q NewDate_" "_NewTime
}

/// Function:根据PAPMIName, 统计病人就诊总次数（包含所有就诊类型）, 返回总数
/// input:APMIName
/// output:count
/// others:w ##Class(User.kongjinchuanExam).GetCountKongJinChuanHISYF("孔晋川HIS研发部")
ClassMethod GetCountKongJinChuanHISYF(PAPMIName As %String) As %String
{
	q:PAPMIName="" "PAPMIName不能为空"
	s count=0
	s PAPMIDr=""
	s PAPMIDr=$o(^PAPERi("PAPER_PatName",$$ALPHAUP^SSUTIL4(PAPMIName),PAPMIDr))
	q:PAPMIDr="" 
	s PAADMType=""
	for {
		s PAADMType=$o(^PAPERdr(PAPMIDr,"ADM",PAADMType))
		q:PAADMType="" 
		s PAADMDr=""
		for {
			s PAADMDr=$o(^PAPERdr(PAPMIDr,"ADM",PAADMType,PAADMDr))
			q:PAADMDr=""
			s count=count+1
		}	
	}
	s Result="该病人的就诊数："_count
	q Result
}

/// Function:按床号（BED_NO）顺序输出病人姓名
/// input:
/// output:病人姓名
/// others:w ##Class(User.kongjinchuanExam).GetPatNameKongJinChuanHISYF()
ClassMethod GetPatNameKongJinChuanHISYF()
{
	
	s RowId=""
	for {
		s RowId=$o(^TempB(0,"BedNo",RowId))
		q:RowId=""
		s PatName=$p($g(^TempB(RowId)),"^",1)
		w Name,!
	}
}

}

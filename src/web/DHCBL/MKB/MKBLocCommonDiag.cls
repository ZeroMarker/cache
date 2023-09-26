Class web.DHCBL.MKB.MKBLocCommonDiag Extends %RegisteredObject
{

/// Creator：李得原
/// CreatDate: 2021-03-17
/// Description：批处理统计数据处理工厂结构化结果中心词对应的科室频率，并存到User表
/// Input: HospitalName：数据处理工厂名称
/// return:	
/// w ##class(web.DHCBL.MKB.MKBStructedDiag).TermLocFrequency("西南医科大数据处理工厂")
ClassMethod TermLocFrequency(HospitalName As %String)
{
	s Term=""
	s n=0
	s HospitalName=$zstrip(HospitalName,"<>W")
	s HospitalName=$zconvert(HospitalName,"U")
	if $d(^User.MKBStructuredBaseI("DescIndex"," "_HospitalName))     //是否存在此数据处理工厂
	{
		s MKBSDBaseRowid=$o(^User.MKBStructuredBaseI("DescIndex"," "_HospitalName,0))  //找到此医院对应的BaseDR
		
		s MKBSDRowid=0
		for
		{
			s MKBSDRowid=$o(^User.MKBStructuredDataI("BaseIndex",MKBSDBaseRowid,MKBSDRowid))  //遍历此医院下的诊断
			q:MKBSDRowid=""
			
			s Sequence=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,0))   //获取最小顺序号（第一个结构化结果）
			//w:Sequence="" MKBSDRowid,!
			s:Sequence="" n=n+1
			continue:Sequence=""
			
			s MKBSDRRowid=$o(^User.MKBStructuredDataResultI("SeqIndex",MKBSDRowid,Sequence,0)) //获取第一个结构化结果Rowid
			
			s MKBTRowid=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructResult",MKBSDRRowid)),4) //获取中心词ID
			
			if '$d(Term(MKBTRowid))
			{
				s Term(MKBTRowid)=""
			}
			s MKBSDLRowid=0
			for
			{
				s MKBSDLRowid=$o(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid))
				q:MKBSDLRowid=""
				s LocDesc=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),2)  //科室描述
				s LocFre=$lg($g(^User.MKBStructuredDataD(MKBSDRowid,"MKBSDStructLoc",MKBSDLRowid)),3)  //科室频次
				s:LocFre="" LocFre=0
				if $d(Term(MKBTRowid,LocDesc))   //如果已经记录了此中心词的科室频次
				{
					s TempFre=Term(MKBTRowid,LocDesc)
					s Term(MKBTRowid,LocDesc)=TempFre+LocFre
				}
				else    //如果没记录过此中心词的频次
				{
					s Term(MKBTRowid,LocDesc)=LocFre
				}
				
			} 
			
		}
		ts
		s TermNode=0
		for
		{
			s TermNode=$o(Term(TermNode))
			q:TermNode=""
			
			s Loc=""
			for
			{
				s Loc=$o(Term(TermNode,Loc))
				q:Loc=""
				
				s obj=##class(User.MKBLocCommonDiag).%New()
				s obj.Frequency=Term(TermNode,Loc)
				d obj.TermDRSetObjectId(TermNode)
				s obj.LocDesc=Loc
				s sc=obj.%Save()
				if $$$ISERR(sc)
				{
					tro
					s error= $system.OBJ.DisplayError(sc)
					return error
				}
			}
		}
	}
	else
	{
		q "医院数据处理工厂不存在"
	}
	tc
	q "导入完成 "_n_"没结构化"
}

}

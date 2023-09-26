Import SQLUser

/// *****************************************************
/// CLASS说明:取可重复模板数据
/// *****************************************************
Class web.DHCWMRQuality.BOACRExpEprMulti Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 241;

/// 可重复模板标题升级后才能启用可重复模板相关的检查标准
/// ret=0：不检查    ret=1：检查
ClassMethod CheckRegDate(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret=0
	s AdmDate=+$p($g(^PAADM(EpisodeID)),"^",6)
	s TitleDate=$zdh("2009-06-03",3)
	s:(AdmDate-TitleDate)>0 ret=1
	q ret
}

/// ****************************************************************
/// 说明          : 模板已创建的前提下检查可重复模板单元是否填写或填写错误
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录标准名称
/// ElNormName    : 单元标准名称
/// TemplateID    ：要检查模板ID LIST
/// InstanceID    : 可重复模板记录ID LIST
/// 返回值        ：
/// ret           ：“ret<0”模板单元未填或填写错误、“ret=0”不需要检查、“ret>0”模板单元已填
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprMulti).IsSaveTemEl(EpisodeID,CatNormName,ElNormName,TemplateID,InstanceID)
/// ****************************************************************
ClassMethod IsSaveTemEl(EpisodeID As %String, CatNormName As %String, ElNormName As %String, TemplateID As %String, InstanceID As %String) As %String
{
	n (EpisodeID,CatNormName,ElNormName,TemplateID,InstanceID)
	
	//是否有对应模板单元
	s ret=0
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName,ElNormName,TemplateID)
	q:flg<1 ret
	
	//可重复模板记录ID为空,不检查
	q:InstanceID="" ret
	
	//是否需要检查非空,非法值,合法值
	s TemplateID=$p(##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateDataByName(EpisodeID,CatNormName),"^",1)
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemplate(TemplateID,ElNormName)
	s IsNull=$p(tmp,"^",4)         //是否允许为空
	s AllowValue=$p(tmp,"^",5)     //允许填写内容  多个值"|"分割
	s DisallowValue=$p(tmp,"^",6)  //不允许填写内容  多个值"|"分割
	q:(IsNull="Y")&&(AllowValue="")&&(DisallowValue="") ret   //无检查内容、不需要检查 "Y"表示可以为空
	
	//检查模板单元值的非空,非法值,合法值
	s ret=-1
	s tmpElData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatNormName,ElNormName,InstanceID)
	q:(IsNull'="Y")&&(tmpElData="") ret   //不允许为空、模板单元值为空
	
	//模板单元值填写正确
	s ret=1
	q:tmpElData="" ret
	f Ind=1:1:$listlength(tmpElData) d
	.s tmpData=$list(tmpElData,Ind)
	.s:(tmpElData'="")&&(AllowValue'="")&&(("|"_AllowValue_"|")'[("|"_tmpElData_"|")) ret=-1    //有限定允许填写值、模板单元值不在限定范围内
	.s:(tmpElData'="")&&(DisallowValue'="")&&(("|"_DisallowValue_"|")[("|"_tmpElData_"|")) ret=-1    //有限定不允许填写值、模板单元值在限定范围内
	
	q ret
}

/// ****************************************************************
/// 说明          : 可重复模板一致性检查
/// 入参          : 
/// EpisodeID     : 就诊号
/// UnifyCode     : 一致性编码
/// CatNormName   : 目录标准名称
/// DataCode1     : 数据编码1
/// DataCode2     : 数据编码2
/// 返回值        ：
/// ret           ：“ret<0”不一致、“ret=0”不需要检查、“ret>0”一致
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprMulti).IsUnifyTemData(EpisodeID,UnifyCode,CatNormName,DataCode1,DataCode2,TemplateID)
/// ****************************************************************
ClassMethod IsUnifyTemData(EpisodeID As %String, UnifyCode As %String, CatNormName As %String, DataCode1 As %String, DataCode2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,UnifyCode,CatNormName,DataCode1,DataCode2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(UnifyCode="") ret
	q:(DataCode1="")||(DataCode2="") ret
	
	//更新EPR.TITLE之前就诊的病人不检查
	q:(..CheckRegDate(EpisodeID))=1 ret
	
	//没有对应模板
	s ret=0
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatNormName,TemplateID)
	q:flg<1 ret
	
	//取数据和一致性检查
	s:$e(DataCode1,1,3)="HIS" tmpValue1=##Class(web.DHCWMRQuality.BOACRExpBaseArg).GetDataByCode(EpisodeID,DataCode1,"","","")
	s:$e(DataCode1,1,3)="EPR" tmpValue1=##Class(web.DHCWMRQuality.BOACRExpBaseArg).GetDataByCode(EpisodeID,DataCode1,CatNormName,"","")
	s:$e(DataCode2,1,3)="HIS" tmpValue2=##Class(web.DHCWMRQuality.BOACRExpBaseArg).GetDataByCode(EpisodeID,DataCode2,"","","")
	s:$e(DataCode2,1,3)="EPR" tmpValue2=##Class(web.DHCWMRQuality.BOACRExpBaseArg).GetDataByCode(EpisodeID,DataCode2,CatNormName,"","")
	s ret=##Class(web.DHCWMRQuality.BOACRExpBaseArg).IsUnifyByCode(UnifyCode,tmpValue1,tmpValue2)
	
	q ret
}

/// ****************************************************************
/// 说明          : 取可重复模板发生日期时间LIST
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录名称
/// StartDate     : 开始日期 "2009-05-23"
/// StartTime     : 开始时间 "21:32:10"
/// EndDate       : 结束日期 "2009-05-23"
/// EndTime       : 结束时间 "21:32:10"
/// TypeCode      : 类型代码(标题)
/// 返回值        ：
/// ret           ：ret=发生日期时间$LIST
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatNormName,StartDate,StartTime,EndDate,EndTime,TypeCode)
/// ****************************************************************
ClassMethod GetMultiTemHaDateTime(EpisodeID As %String, CatNormName As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, TypeCode As %String) As %String
{
	n (EpisodeID,CatNormName,StartDate,StartTime,EndDate,EndTime,TypeCode)
	s Data=""
	q:(EpisodeID="")||(CatNormName="") Data
	
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRCatalog(CatNormName)
	q:(tmp="")||($p(tmp,"^",1)="") Data
	s MountCategoryID=$p(tmp,"^",1)
	d ..CheckDateTime()
	s TitleList=..GetMultiTitleList(TypeCode)
	
	s ds = ##class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
	k ^CacheTemp($zn,$j,"HappenDateTime")
	if (TitleList'="")
	{
		for ind=1:1:$listlength(TitleList)
		{
			s Title=$list(TitleList,ind)
			q:Title=""
			d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,Title)
			while(ds.Next())
			{
				s MultiDataInfo=ds.Data("MultiDataInfo")
				s HappenDate=$p(MultiDataInfo,$c(1),7)   //发生日期
				s HappenTime=$p(MultiDataInfo,$c(1),8)   //发生时间
				q:(HappenDate="")||(HappenTime="")
				s HappenDateTime=$zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
				s ^CacheTemp($zn,$j,"HappenDateTime",HappenDateTime)=""
			}
			d ds.Close()
		}
	}
	else{
		d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,"")
		while(ds.Next())
		{
			s MultiDataInfo=ds.Data("MultiDataInfo")
			s HappenDate=$p(MultiDataInfo,$c(1),7)   //发生日期
			s HappenTime=$p(MultiDataInfo,$c(1),8)   //发生时间
			q:(HappenDate="")||(HappenTime="")
			s HappenDateTime=$zd(+HappenDate,3)_" "_$zt(+HappenTime,2)
			s HappenDateTime=HappenDate_" "_HappenTime
			s ^CacheTemp($zn,$j,"HappenDateTime",HappenDateTime)=""
		}
		d ds.Close()
	}
	
	s DateTime=""
	f  s DateTime=$o(^CacheTemp($zn,$j,"HappenDateTime",DateTime)) q:DateTime=""  d
	.s Data=Data_$lb(DateTime)
	k ^CacheTemp($zn,$j,"HappenDateTime")
	
	q Data
}

/// ****************************************************************
/// 说明          : 取可重复模板发生日期LIST
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录名称
/// StartDate     : 开始日期 "2009-05-23"
/// StartTime     : 开始时间 "21:32:10"
/// EndDate       : 结束日期 "2009-05-23"
/// EndTime       : 结束时间 "21:32:10"
/// TypeCode      : 类型代码(标题)
/// 返回值        ：
/// ret           ：ret=发生日期$LIST
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDate(EpisodeID,CatNormName,StartDate,StartTime,EndDate,EndTime,TypeCode)
/// ****************************************************************
ClassMethod GetMultiTemHaDate(EpisodeID As %String, CatNormName As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, TypeCode As %String) As %String
{
	n (EpisodeID,CatNormName,StartDate,StartTime,EndDate,EndTime,TypeCode)
	s Data=""
	q:(EpisodeID="")||(CatNormName="") Data
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRCatalog(CatNormName)
	q:(tmp="")||($p(tmp,"^",1)="") Data
	s MountCategoryID=$p(tmp,"^",1)
	d ..CheckDateTime()
	s TitleList=..GetMultiTitleList(TypeCode)
	
	s ds = ##class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
	k ^CacheTemp($zn,$j,"HappenDate")
	if (TitleList'="")
	{
		for ind=1:1:$listlength(TitleList)
		{
			s Title=$list(TitleList,ind)
			q:Title=""
			d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,Title)
			while(ds.Next())
			{
				s MultiDataInfo=ds.Data("MultiDataInfo")
				s HappenDate=$p(MultiDataInfo,$c(1),7)   //发生日期
				q:HappenDate=""
				s HappenDate=$zd(HappenDate,3)
				s ^CacheTemp($zn,$j,"HappenDate",HappenDate)=""
			}
			d ds.Close()
		}
	}else{
		d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,"")
		while(ds.Next())
		{
			s MultiDataInfo=ds.Data("MultiDataInfo")
			s HappenDate=$p(MultiDataInfo,$c(1),7)   //发生日期
			q:HappenDate=""
			s HappenDate=$zd(HappenDate,3)
			s ^CacheTemp($zn,$j,"HappenDate",HappenDate)=""
		}
		d ds.Close()
	}
		
	s Date=""
	f  s Date=$o(^CacheTemp($zn,$j,"HappenDate",Date)) q:Date=""  d
	.s Data=Data_$lb(Date)
	k ^CacheTemp($zn,$j,"HappenDate")
	
	q Data
}

/// ****************************************************************
/// 说明          : 取可重复模板记录数量
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录名称
/// StartDate     : 开始日期 "2009-05-23"
/// StartTime     : 开始时间 "21:32:10"
/// EndDate       : 结束日期 "2009-05-23"
/// EndTime       : 结束时间 "21:32:10"
/// TypeCode      : 类型代码(标题)
/// 返回值        ：
/// ret           ：ret=发生时间$LIST
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatNormName,StartDate,StartTime,EndDate,EndTime,TypeCode)
/// ****************************************************************
ClassMethod GetMultiTemReCount(EpisodeID As %String, CatNormName As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, TypeCode As %String) As %String
{
	n (EpisodeID,CatNormName,StartDate,StartTime,EndDate,EndTime,TypeCode)
	s Count=0
	q:(EpisodeID="")||(CatNormName="") Count
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRCatalog(CatNormName)
	q:(tmp="")||($p(tmp,"^",1)="") Count
	s MountCategoryID=$p(tmp,"^",1)
	d ..CheckDateTime()
	s TitleList=..GetMultiTitleList(TypeCode)
	
	s ds = ##class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
	if (TitleList'="")
	{
		for ind=1:1:$listlength(TitleList)
		{
			s Title=$list(TitleList,ind)
			q:Title=""
			d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,Title)
			while(ds.Next())
			{
				s:ds.Data("MultiDataInfo")'="" Count=Count+1
			}
			d ds.Close()
		}
	}else{
		d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,"")
		while(ds.Next())
		{
			s:ds.Data("MultiDataInfo")'="" Count=Count+1
		}
		d ds.Close()
	}
	
	q Count
}

/// ****************************************************************
/// 说明          : 取可重复模板单元LIST
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录名称
/// ElNormName    : 单元名称
/// StartDate     : 开始日期 "2009-05-23"
/// StartTime     : 开始时间 "21:32:10"
/// EndDate       : 结束日期 "2009-05-23"
/// EndTime       : 结束时间 "21:32:10"
/// TypeCode      : 类型代码(标题)
/// InstanceID    : 可重复模板记录ID
/// 返回值        ：
/// ret           ：ret=模板单元$LIST
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemElData(EpisodeID,CatNormName,ElNormName,StartDate,StartTime,EndDate,EndTime,TypeCode,InstanceID)
/// ****************************************************************
ClassMethod GetMultiTemElData(EpisodeID As %String, CatNormName As %String, ElNormName As %String, StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String, TypeCode As %String, InstanceID As %String) As %String
{
	n (EpisodeID,CatNormName,ElNormName,StartDate,StartTime,EndDate,EndTime,TypeCode,InstanceID)
	s Data=""
	q:(EpisodeID="")||(CatNormName="")||(ElNormName="") Data
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRCatalog(CatNormName)
	q:(tmp="")||($p(tmp,"^",1)="") Data
	s MountCategoryID=$p(tmp,"^",1)
	d ..CheckDateTime()
	s TitleList=..GetMultiTitleList(TypeCode)
	
	s ds = ##class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
	if (TitleList'="")
	{
		for ind=1:1:$listlength(TitleList)
		{
			s Title=$list(TitleList,ind)
			q:Title=""
			d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,Title)
			while(ds.Next())
			{
				s MultiDataInfo=ds.Data("MultiDataInfo")
				s TemplateID=$p(MultiDataInfo,$c(1),1)    //模板号
				s InstanceDataID=$p(MultiDataInfo,$c(1),2)    //记录号
				q:(TemplateID="")||(InstanceDataID="")
				q:(InstanceID'="")&&($listfind(InstanceID,InstanceDataID))  //这条记录不在检查范围内
				s ElementCode=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemplate(TemplateID,ElNormName)
				q:ElementCode=""
				s Content=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID,ElementCode,InstanceDataID)
				s Data=Data_$lb(Content)
			}
			d ds.Close()
		}
	}else{
		d ds.Execute(EpisodeID,MountCategoryID,StartDate,StartTime,EndDate,EndTime,"")
		while(ds.Next())
		{
			s MultiDataInfo=ds.Data("MultiDataInfo")
			s TemplateID=$p(MultiDataInfo,$c(1),1)    //模板号
			s InstanceDataID=$p(MultiDataInfo,$c(1),2)    //记录号
			q:(TemplateID="")||(InstanceDataID="")
			q:(InstanceID'="")&&($listfind(InstanceID,InstanceDataID))  //这条记录不在检查范围内
			s ElementCode=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemplate(TemplateID,ElNormName)
			q:ElementCode=""
			s Content=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID,ElementCode,InstanceDataID)
			s Data=Data_$lb(Content)
		}
		d ds.Close()
	}
		
	q Data
}

/// 检查开始时间和结束时间
/// 开始时间:第一次安床时间;安床时间为空就取住院登记时间
/// 结束时间:病人已出院为出院时间;病人未出院为系统当前时间
ClassMethod CheckDateTime()
{
	//n (StartDate,StartTime,EndDate,EndTime)
	i (StartDate="")||(StartTime="") d
	.s RegDateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegDateTime(EpisodeID)
	.s StartDate=$p(RegDateTime," ",1),StartTime=$p(RegDateTime," ",2)
	.s:(StartDate="")||(StartTime="") StartDate="",StartTime=""
	q:(StartDate="")||(StartTime="") $$$OK
	i (EndDate="")||(EndTime="") d
	.s DischDateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime(EpisodeID)
	.s EndDate=$p(DischDateTime," ",1),EndTime=$p(DischDateTime," ",2)
	.s:(EndDate="")||(EndTime="") EndDate=+$h,EndTime=$p($h,",",2)
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:StartDate["/" StartDate=$zdh(StartDate,4)
	s:StartTime[":" StartTime=$zth(StartTime,2)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s:EndDate["/" EndDate=$zdh(EndDate,4)
	s:EndTime[":" EndTime=$zth(EndTime,2)
	s StartDate=+StartDate,StartTime=+StartTime
	s EndDate=+EndDate,EndTime=+EndTime
	q
}

/// 根据代码取可重复模板标题LIST
ClassMethod GetMultiTitleList(TypeCode As %String) As %String
{
	n (TypeCode)
	s TitleList=""
	s HospCode=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetHospCode()
	q:(TypeCode="")||(HospCode="") TitleList
	q:'$d(^DHCWMRACRArg(HospCode,TypeCode)) TitleList
	s Ind=0
	f  s Ind=$o(^DHCWMRACRArg(HospCode,TypeCode,Ind)) q:Ind=""  d
	.s tmp=$g(^DHCWMRACRArg(HospCode,TypeCode,Ind))
	.q:tmp=""
	.s TitleList=TitleList_$lb(tmp)
	q TitleList
}

}

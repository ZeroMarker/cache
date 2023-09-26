Class DHCEWELL.SendInPatInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:	获取病程记录相关文书参数
/// 		
/// 		参数维护：
/// 		INSERT INTO EMRmeta.CustomDictionary(CtmDictAlias, CtmDictCode, CtmDictDesc, CtmDictID, CtmDictStatus,CtmDictType)
/// 			VALUES ('病程记录文书[给集成平台接口]', '58^5^#TYPE:ISectionDesc#TID:5#SCODE:S001#VTYPE:V', '病程记录文书[给集成平台接口]', 'EnsDailyRecordGroup', 'Y','DHCEMRVRecordGroup')
///         或
///         update EPRmeta.CustomDictionary 
///         set CtmDictAlias = '病程记录文书[给集成平台接口]', CtmDictCode = '604^847^#TYPE:TextDesc#TID:842#TVER:0#ECODE:E0001', 
///         CtmDictDesc = '病程记录文书[给集成平台接口]', CtmDictID = 'EnsDailyRecordGroup', 
///         CtmDictStatus = 'Y', CtmDictType = 'DHCEPRVRecordGroup'
ClassMethod GetEnsDailyRecordConfig() As %String
{
	s info = ""
	&sql(select top 1 CtmDictCode into :info from EPRmeta.EPRmeta.CustomDictionary
		where CtmDictType = 'DHCEPRVRecordGroup' and CtmDictID = 'EnsDailyRecordGroup' and CtmDictStatus = 'Y')
	
	if (info = $C(0)) s info = ""
	q info
}

/// Creator:	HouJian
/// CreatDate:	2012-05-11
/// Desc:：   	获取指定实例数据相关信息，包括模板ID、标题、创建人、创建日期时间、发生日期时间
/// Table：		无
/// Input：     AEpisodeID ：就诊指针
/// Output:		InstanceDataID : 实例数据ID,
/// 			TemplateID : 界面模板ID,
/// 			Title : 实例数据标题,
/// 			CreateUserID : 创建者ID,
/// 			CreateDate : 创建日期,格式为Cache内部逻辑值（如$H的日期部分）,
/// 			CreateTime : 创建时间,格式为Cache内部逻辑值（如$H的时间部分）,
/// 			HappenDate : 发生日期,格式为Cache内部逻辑值（如$H的日期部分）,
/// 			HappenTime : 发生时间,格式为Cache内部逻辑值（如$H的时间部分）,
/// 			Content: 病历内容
/// w ##class(DHCENS.IIP.BO.SendInPatInfo).GetDailyRecordInfo("1119007")
ClassMethod GetDailyRecordInfo(AEpisodeID As %String) As %ListOfObjects
{
	;b ;GetDailyRecordInfo
	s ARecordConfig = ..GetEnsDailyRecordConfig()
	
	s ACategoryID = $p(ARecordConfig,"^",1)
	s ATemplateID = $p(ARecordConfig,"^",2)
	s AItemCode = $p(ARecordConfig,"^",3)
	s DataList=##class(%ListOfObjects).%New()
	s Ret=""
	//处理新页面框架情况
	s ecRecordID = ""
	;b ;1.1
	for 
	{
		s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID", AEpisodeID, ACategoryID, ecRecordID))
		q:(ecRecordID="") 
	
		s objListECRecord = $g(^DHCEPRI.ECRecordD(ecRecordID))
		continue:(objListECRecord="")
	
		s chartItemType = $list(objListECRecord,3)
	
		s childSub = "0"
		for 
		{
			s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordID,childSub))
			q:(childSub="")
		
			s instanceDataID = ecRecordID_"||"_childSub
		
			s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(instanceDataID)
			continue:(objInstance = "")
		
			//获取指定模板的内容
			quit:(objInstance.TemplateID.%Id() '= ATemplateID)
		
			continue:(objInstance.Status="UnSave")||(objInstance.Status="")
		
			s templateID = objInstance.TemplateID.%Id()
			s title = objInstance.Title
			s createUserID = objInstance.CreateUser
			s createDate = objInstance.CreateDate
			s createTime = objInstance.CreateTime
			if (chartItemType = "Single")
			{
				s happenDate = createDate
				s happenTime = createTime
			}
			else
			{
				s happenDate = objInstance.HappenDate
				s happenTime = objInstance.HappenTime
			}
			s recordContent = ##class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID, AItemCode, instanceDataID)
			s EMR=##class(DHCENS.IIP.Model.PatEMR).%New()
			s EMR.FileNo=title
			s EMR.DocName=createUserID ;$p($g(^CTPCP(DocRowid,1)),"^",1)
			i ((createDate'="")&&(createTime'=""))
			{
				s EMR.DateTime=$zd(createDate,3)_" "_$zt(createTime)
			}
			s EMR.Content=recordContent
			d DataList.Insert(EMR)
			;if Ret=""
			;{
			;	s Ret=instanceDataID_"^"_templateID_"^"_title_"^"_createUserID_"^"_createDate_"^"_createTime_"^"_happenDate_"^"_happenTime_"^"_recordContent
			;}
			;else
			;{
			;	b ;
			;	s Ret=Ret_"@"_instanceDataID_"^"_templateID_"^"_title_"^"_createUserID_"^"_createDate_"^"_createTime_"^"_happenDate_"^"_happenTime_"^"_recordContent
			;}
		}
	}
	;b ;GetDailyRecordInfo_end
	Quit DataList
}

}
